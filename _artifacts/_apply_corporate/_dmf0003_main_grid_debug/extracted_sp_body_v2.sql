    1| PROCEDURE           "DMF0003_GET_MKT_FCST_DATA"
    2|     ( P_DIVISION_ID      IN  VARCHAR2
    3|     , P_SCM_SITE_ID      IN  VARCHAR2
    4|     , P_PLANT_SITE_ID    IN  VARCHAR2
    5|     , P_TEAM_ID          IN  VARCHAR2
    6|     , P_CUSTOMER         IN  VARCHAR2
    7|     , P_BIZ_TYPE         IN  VARCHAR2
    8|     , P_PROJECT_CODE     IN  VARCHAR2
    9|     , P_ITEM_ID          IN  VARCHAR2
   10|     , P_FROM_YYYYMMDD    IN  VARCHAR2
   11|     , P_TO_YYYYMMDD      IN  VARCHAR2
   12|     , P_CREATED_BY       IN  VARCHAR2
   13|     , P_USER_GROUP       IN  VARCHAR2
   14|     , P_ITEM_TYPE        IN  VARCHAR2
   15|     , P_OWNER            IN  VARCHAR2
   16|     , P_QTY_YN           IN  VARCHAR2
   17|     , P_CELL_YN          IN  VARCHAR2
   18|     , P_INVALID_EXEC     IN  VARCHAR2   -- [C20200612-000174] ESS사업부 New Model Flag
   19|     , P_AS_YN            IN  VARCHAR2
   20|     , P_USER_DEPT_ID     IN  VARCHAR2   -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
   21|     , P_SENDER_CODE      IN  VARCHAR2   -- SENDER_CODE 추가
   22|     , P_USER_ID          IN VARCHAR2
   23|     , P_MENU_ID          IN VARCHAR2
   24|     , O_RC1              OUT SYS_REFCURSOR
   25|     , O_RC2              OUT SYS_REFCURSOR   -- 8주 이내 bucket 정보
   26|     , O_RC3              OUT SYS_REFCURSOR   -- 현재 주차 정보
   27|     , O_RESULT_CURSOR    OUT SYS_REFCURSOR
   28| 
   29|     )
   30| /*=====================================================================================================================================================
   31|  * Program ID  : DMF0003_GET_MKT_FCST_DATA
   32|  * Description : Procedure 작성 가이드
   33|  * Usage       : Procedure 작성 시 참조하세요!
   34|  * Parameter   :
   35|  *=====================================================================================================================================================
   36|  * Date				In Charge    Description
   37|  *=====================================================================================================================================================
   38|  * 2017.11.24		SongDH		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
   39|  * 2018.05.14		KHSONG		BALANCE MEASURE 신규추가로 MINUS값까지 보여주기위하여 QTY <> 0 로 수정
   40|  * 2018.05.30		JYE			복수 팀 권한 관련  수정
   41|  * 2018.07.12		KHSONG		속도개선 수정버젼임
   42|  * 2018.07.27		SonYoungSuk 컬럼 정렬 정보
   43|  * 2018.07.30		SonYoungSuk 검색조건 project(코드,네임 라이크 검색), model/item(코드,닉네임 라이크 검색)으로 수정
   44|  * 2018.08.08		KHSONG		실적구간 중복되어 between 에서 수식으로 수정/p_from 변수사용
   45|  * 2018.08.09		ytchoi		조건수정으로 속도개선
   46|  * 2018.08.10		ytchoi		조회속도개선 SCM_MST_MODEL_FINAL_ITEM_BOM_V.CHILD_ITEM_ID -> SCM_MST_SITE.attribute5 컬럼사용
   47|  * 2018.08.09		JYE			멀티 오너 추가
   48|  * 2018.08.13		JYE			Qty '0' 포함 추가
   49|  * 2018.08.16		KHSONG		VALID_YN 조건추가
   50|  * 2018.08.23		JYE			멀티 오너에 대한 수정 권한 수정. 신규 함수 적용.
   51|  * 2018.09.04		JYE			멀티 오너에 대한 수정 권한 변경 수정 -- 주석처리.20180912
   52|  * 2018.09.11		SonYoungSuk 조회 컬럼 CELL_TYPE 추가 #TEMP_DM_MST_ITEM_SINGLE_V.CELL_TYPE 사용 LookUp 테이블로 명칭 조회
   53|  * 2018.09.28		JYE			RTF 수정 불가 처리
   54|  * 2018.10.04		SonYoungSuk MEASURE VMI_IN_Req, VMI_IN_Plan Edit 가능
   55|  * 2018.11.01		khsong		특정기간(20181101-20190531) 조회시 에러발생으로 BUCKET_PER null조건추가
   56|  * 2018.11.02					속도개선을 의해서 추가
   57|  * 2018.11.14		JYE			Cell Qty 환산 추가
   58|  * 2018.11.15		JYE			소형 사업부 8주 이내는 일별로만 입력되도록
   59|  * 2018.12.21		KHSONG		PR_SCP_ENG_EE_PRE_SET_INTRANSITSHIPMENTS 참조하여 주석처리함
   60|  * 2019.01.18		KHSONG		중복제거위한 DISTINCT추가
   61|  * 2019.01.21		KHSONG		MERGE 추가
   62|  * 2019.01.23		KHSONG		전지재료DIV설정 (''42'',''44'') -> 20190624 모두 제거함
   63|  * 2019.02.13		KHSONG		[CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건
   64|  * 2019.02.14		JYE			정렬 쿼리에 디비전 조건 추가
   65|  * ----------------------------------------------------------------------------------------
   66|  * 20190219 KHSONG JOIN 조건 위로 올려서 속도개선한 버전
   67|  * ----------------------------------------------------------------------------------------
   68|  * 2019.02.19		KHSONG		숫자가 아닌 MEASURE는 FORECAST_INFO_CELL_PACK_COUNT로 곱하지 않도록 수정
   69|  * 2019.03.08		KHSONG		[CSR ID:3940493] MKT FcstUI상 Shipping Plan Measure 추가 (SHIPMENT_PLAN)
   70|  * 2019.03.22		KHSONG		고객군, 판매처 컬럼 NULL처리조건 추가
   71|  * 2019.04.01		KHSONG		81,82인경우 PROJECT_CODE 를 출력하면 GROUP이 묶이지 않으므로 END_CUSTOMER 출력으로 변경함
   72|  * 2019.04.19		KHSONG		[CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
   73|  * 2019.06.24		KHSONG		[CSR_ID:4016234]자동차전지 사업부 RTF(Manual 입력) 메져 추가건 적용
   74|  * 2019.07.04		KHSONG		ITEM_ID = ('MCCM346010A1,MCCM346010A1-D06') 이렇게 조회시 두배로 보이는 현상으로 재 GROUP
   75|  * 2019.07.05		KHSONG		[CSR ID:4023158] Column / Measure 추가 Setting 요청건 (Column 3개 : Cell/Module , Cell/Car , Module/Car) (Measure 4개:MKT_FCST_RP_CAR,MKT_FCST_RP_CELL,RTF_RP_CAR,RTF_RP_CELL)
   76|  * 2019.02.14		JYE			Warranty 용도 권한 추가
   77|  * 2019.08.09		KHSONG		[CSR ID:4059971] VMI-In Request 로직 변경 -> ESS 사업부 별도추가 필요없음
   78|  * 2019.10.02		KHSONG		조회시 DB Lock 현상으로 로직수정
   79|  * 2019.10.29		KYH			Shipment_Plan 관련 MKT_FCST 의 기간조건 제거
   80|  * 2019.11.18		KHSONG		[CSR ID:C20191031-000137] GSCM(DM)에서 Incoterms 조건에 따라 Customer EDI의 DP 반영 요청의 건
   81|  * 2019.11.19		KHSONG		Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
   82|  * 2020.01.30		KHSONG		[C20200114-000201] ESS사업부 ENERGE, CELL_QUANTITY 컬럼/Measure추가
   83|  * 2020.02.17		KHSONG		C20200103-000586 'SCM PI Admin' ADD
   84|  * 2020.02.18		KHSONG		C20200212-000304 : GSCM 차량대수 환산 오류 개선 요청 건
   85|  * 2020.02.25		KHSONG		C20200221-000056 Sales plan waterfall 차량대수 환산 logic 변경 요청 RTF MEASURE 삭제
   86|  * 2020.03.09		KHSONG		C20200303-000078 : DM meausre 추가의 건 / TMM MEASURE 권한추가
   87|  * 2020.03.11		KHSONG		C20200103-000586 권한그룹을 LOOKUP관리
   88|  * 2020.06.05		P.C.I		[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
   89|  * 2020.06.18		P.C.I		[C20200612-000174] ESS사업부 조회 구간에 mapping되지 않은 Sales Price 데이터
   90|  * 2020.07.02		P.C.I		[C20200702-000136] Sales Price check시 currency 제외, new_flag 추가
   91|  * 2020.07.16		HWI1993		[C20200713-000189] [VMI-in Req] VMI Biz의 경우 VMI-in Req 입력을 통한 MKT FCST 자동산출 로직 추가
   92|  * 2020.07.23		P.C.I		[prepare] MKT_FCST_RP 실적 구간 변경(현재 기준 전주 일요일까지)
   93|  * 2020.08.31		hwi1993		[C20200812-000104] [시스템 변경요청]  Active = ‘N’ 인 Model 도 조회되도록 변경
   94|  * 2020.10.15		hwi1993		[C20201015-000200] VMi 원복 (원본은 C20200713-000189 ). 원복하기로 해서 프로시저는 삭제하지 않고, Agent 에서만 제거함.
   95|  * 2020.11.13		hwi1993		개발에서 ssp sync 작업한 버전을 [DMF0003_GET_MKT_FCST_DATA_SSP_SYNC_작업분] 으로 백업하고, 운영에서 새로 내려받음
   96|  * 2020.11.13		hwi1993		[C20201103-000114] [SCM PI팀] ESS 사업부 판매 법인 VMI biz의 MKT FCST 입력 시 VMI in req 자동산출 로직 적용의 건
   97|  * 2020.11.27		hwi1993		[C20201103-000114]. Sales Price 기반으로 데이터 가져오는 부분에서는 VMI 메저 강제추가 제거함.
   98|  * 2020.12.15		hwi1993		[C20201105-000099] 오류 데이터 삭제요청 -- ESS 의 경우 Future Price 를 참조할 때 FCST_TYPE = '' 인 것들 제외
   99|  * 2020.12.28		HWI1993		[C20200804-000123] MKT FCST - SSP 동기화
  100|  * 2021.01.14		HWI1993		[C20210112-000446] [SCM PI팀] 소형사업부 MKT FCST - SSP 동기화 ( ATP 메저 보완 )
  101|  * 2021.02.26		P.C.I		[C20210225-000385] 동기화 기준은 ATTRIBUTE4, ATTRIBUTE5으로 구분
  102|  * 2021.05.12		hwi1993		[PJ20209642R] Digital SCM Level.3 달성을 위한 개선 - ESS 상품 PR
  103|  * 2021.05.17		HWI1993		[PJ20209642R] Digital SCM Level.3 달성을 위한 개선 - 중장기계획
  104|  * 2021.06.18		HWI1993		[PJ20209642R] PR REQUEST 에 원재료 추가
  105|  * 2021.08.10		hwi1993		[C20210810-000268] 메저 순서 변경 시 오류 발생
  106|  * 2021.08.24		HWI1993		[과제]_BOD 유효기간 추가
  107|  * 2021.09.01		SJHAN		[C20210827-000130] GSCM내 VMI inventory값 표시 변경 요청
  108|  * 2021.09.15		SJHAN		[PJ20209643]-속도개선
  109|  * 2021.09.17		hwi1993		[PJ20209643] AS 프로세스
  110|  * 2021.11.02		hwi1993		[PJ20209643] AS 프로세스 - balance 메저 표시방법 변경, 룩업 컬럼 변경
  111|  * 2021.11.17		hwi1993		[PJ20209643] 성능개선 - hash 옵션 추가 등
  112|  * 2021.11.18		kdw2819		[과제]_자동차 사업부 JV Planner 의 조회 권한 추가
  113|  * 2021.11.19		ROSIA27		[C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
  114|  * 2021.11.30		rosia27		[C20211122-000414]
  115| 속도개선을 위한 색구현 및 조회조건 변경안
  116|  * 2021.12.07		rosia27		[C20211130-000420][ESS영업관리팀] RTF{R+P] Energy Measure MWh 단위로 수정 요청의 건
  117|  * 2021.12.15		kdw2819		[C20211215-000076] 1년 이상 조회기간을 설정하여도 가능하도록 변경 건
  118|  * 2022.01.06		hwi1993		[] sales_type_code 룩업의 as 전용 fcst type 을 사용할수 없게 되어서, as 구분방법 변경
  119| 								( 고객향은 attribute10, 플랜트향은 scm_site_id 이용 )
  120|  * 2022.02.07		kdw2819		[C20220125-000192] MKT FSCT 상 From stie 표기 요청의 건
  121|  * 2022.02.24		HWI1993		[C20220218-000409] GSCM-DM AS Inventory 메저 계산 로직 수정 -- INV 메저 표시방법 변경, INTRANSIT 메저의 ATTR10 오류 수정
  122|  * 2022.04.05		rosia27		[과제PJ20216891R]GM_JV
  123|  * 2022.12.14		rosia27		[C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
  124|  * 2023.03.13		rosia27		[E20230308-000315] [시스템 오류] Owner 조회조건 수정 요청 건
  125|  * 2023.05.03		kdmcc14		[EDI과제]
  126|  * 2023.08.25		JSSBAE		[E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청(LOOKUP이용)
  127|  * 2023.10.19		JSSBAE		[E20231018-000776]_[영업/마케팅 PI팀] MKT FCST 화면 SHIPMENT_PLAN 메저 로직 수정 프로그램 화면 내 메져의 VALID가 Y인 대상만 나오도록 수정
  128|  * 2023.11.21		chano0612	[고객수요분석시스템 정비] EDI데이터 중복건 제거
  129|  * 2023.12.07		kcw3408		[개발요청] 수요분석시스템_4_고객수요 Measure 통합
  130|  * 2024.01.15		JSSBAE		[E20240102-000545] [마케팅PI] 82번 사업부 - VMI표기 로직 개선
  131|  * 2024.03.07       kcw3408     DM 프로시저 속도개선(CNS 전정관 책임님이 지원)
  132|  * 2024.05.17       kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
  133|  * 2024.07.18		JSSBAE		[E20240712-001683]_'MKT FCST 미등록제외' 관련 소스 수정
  134|  * 2024.08.02		JSSBAE		[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선
  135|  * 2024.09.05		JSSBAE		[E20240812-000094]_82사업부 MKT FCST 화면 Energy Measure 소수점 자리수 수정 요청
  136|  * 2024.08.27		KJJ			[PJ2024-50461] Team Mapping
  137|  * 2024.09.12		JSSBAE		[E20240920-000300]_SCM.DM 화면 조회 속도 개선
  138|  * 2024.11.04		JSSBAE		[E20241030-000923]_MKT FCST, MKT FCST Waterfall 화면 신규 컬럼 추가 요청 건
  139|  *                              SSPM에 신규 추가 요청드린 'Project(S&OP Report)' 컬럼 MKT FCST Waterfall 사용자 화면에 추가 요청
  140|  * 2024.11.12		JSSBAE		[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건
  141|  * 2024.12.04		JSSBAE		[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정
  142|  * 2025.07.07		KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
  143|  * 2026.01.23		JSSBAE		[E20260123-001715]_E20241015-000415 CSR 원복 요청
  144|  * 2026.02.20		JSSBAE		[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
  145|  * 2026.04.13       kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
  146|  *                                  SCM_MST_SITE_ITEM Table PROJECT_S_OP_REPORT Column 삭제에 따라 컬럼 사용 문장 삭제
  147|  *                                  ORA-01799: a column may not be outer-joined to a subquery 방지용으로 불필요한 outer join 제거
  148|  EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='40', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
  149| 	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
  150| 	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='N', @p_cell_yn='N', @p_invalid_exec='N', @p_as_yn='N', @p_user_dept_id='58235660',@p_sender_code='ALL'
  151|  EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='81', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
  152| 	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
  153| 	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='N', @p_cell_yn='N', @p_invalid_exec='N', @p_as_yn='N', @p_user_dept_id='58235660',@p_sender_code='ALL'
  154|  EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='82', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
  155| 	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
  156| 	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='N', @p_cell_yn='N', @p_invalid_exec='N', @p_as_yn='N', @p_user_dept_id='58235660',@p_sender_code='ALL'
  157|  *===================================================================================================================================================*/
  158| -- 2026-05-11 전병주 컴파일 오류 수정
  159| AS
  160|     -- 프로그램명 (로그용)
  161|     V_PROGRAM_NAME      VARCHAR2(150);
  162| 
  163|     -- 동적 SQL / PIVOT 관련
  164|     V_SQL_TEXT          CLOB;
  165|     V_PV_LIST           CLOB    := '';
  166|     V_PV_COL_LIST       CLOB    := '';
  167|     V_PV_COLUMN_NAME    VARCHAR2(1000);
  168|     V_PV_NAME           VARCHAR2(200);
  169|     V_SORT_ORDER_NO     VARCHAR2(50);
  170|     V_COLUMN_NAME       VARCHAR2(100);
  171|     V_COLUMN            CLOB    := '';
  172|     V_GROUPBY           CLOB    := '';
  173|     V_ORDERBY           CLOB    := '';
  174| 
  175|     -- 프로그램 / 시트 고정값
  176|     VA_PROGRAM_ID       VARCHAR2(50)  := 'DMF0003';
  177|     VA_SHEET_NAME       VARCHAR2(50)  := 'main';
  178| 
  179|     -- 권한 / 부서
  180|     V_GROUP_ID          VARCHAR2(50)  := '';
  181|     V_DEPT_ID           VARCHAR2(50)  := '';
  182| 
  183|     -- 조회 구간 날짜 변수
  184|     V_EXP_YYYYMMDD      VARCHAR2(8);
  185|     V_FROM_YYYYMMDD     VARCHAR2(8)   := '';   -- 계획 구간 FROM (당주 월요일 기준)
  186|     V_TO_YYYYMMDD       VARCHAR2(8)   := '';   -- 계획 구간 TO
  187|     V_FROM_RESULT       VARCHAR2(8)   := '';   -- 실적 구간 FROM
  188|     V_TO_RESULT         VARCHAR2(8)   := '';   -- 실적 구간 TO
  189|     V_USER_TIME_ZONE    VARCHAR2(50)  := '';
  190| 
  191|     -- 사용자 컬럼/메저 카운트
  192|     V_USER_COL_CNT      PLS_INTEGER   := 0;
  193|     V_USER_MEA_CNT      PLS_INTEGER   := 0;
  194| 
  195|     -- IN 파라미터를 로컬 복사본으로 사용 (IN 파라미터 직접 수정 불가)
  196|     LP_AS_YN            VARCHAR2(1);
  197|     LP_SCM_SITE_ID      VARCHAR2(4000);
  198|     LP_PROJECT_CODE     VARCHAR2(4000);
  199| 
  200|     -- 팀 WHERE 조건 (동적 SQL에 삽입)
  201|     V_TEAM_WHERE        VARCHAR2(4000);
  202| 
  203|     -- 예외처리 / 로그 변수
  204|     V_LOG_TYPE          VARCHAR2(30);
  205|     V_LOG_MESSAGE       VARCHAR2(1000);
  206|     V_DESCRIPTION       VARCHAR2(500);
  207|     D_EVENT_DATE        DATE;
  208|     V_SQL_CODE          VARCHAR2(20);
  209|     V_SQL_ERRMSG        VARCHAR2(4000);
  210|     V_BACKTRACE         VARCHAR2(4000);
  211|     V_PROC_INPUT        CLOB;
  212| 
  213|     -- T_SSP_SYNC 컬렉션용
  214|     T_SCM_SITE_IDS      SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();
  215| 
  216| BEGIN
  217|     -----------------------------------------------------------------------
  218|     -- 프로그램명 설정
  219|     -----------------------------------------------------------------------
  220|     IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
  221|         V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
  222|     ELSE
  223|         V_PROGRAM_NAME := $$PLSQL_UNIT;
  224|     END IF;
  225| 
  226|     -- IN 파라미터 로컬 복사
  227|     LP_AS_YN        := P_AS_YN;
  228|     LP_SCM_SITE_ID  := P_SCM_SITE_ID;
  229|     LP_PROJECT_CODE := P_PROJECT_CODE;
  230| 
  231|     -- 시작 LOG
  232|     V_LOG_TYPE    := 'START';
  233|     V_LOG_MESSAGE := '########## Start of procedure ##########';
  234|     V_DESCRIPTION := '-';
  235|     D_EVENT_DATE  := SYSDATE;
  236|     BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
  237|     V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
  238| 
  239|     -----------------------------------------------------------------------
  240|     -- GTT 초기화 (세션 재사용 시 이전 데이터 제거)
  241|     -----------------------------------------------------------------------
  242|     DELETE FROM SCM_MGR.GT_GGET_T_SSP_SYNC;
  243|     DELETE FROM SCM_MGR.GT_GGET_T_BNP;
  244|     DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_ORI;
  245|     DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_A;
  246|     DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_B;
  247|     DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_V;
  248|     DELETE FROM SCM_MGR.GT_GGET_SELECT_MEASURE;
  249|     DELETE FROM SCM_MGR.GT_GGET_VMI_DIO;
  250|     DELETE FROM SCM_MGR.GT_GGET_SITE_ITEM_ALL;
  251|     DELETE FROM SCM_MGR.GT_GGET_SITE_ITEM;
  252|     DELETE FROM SCM_MGR.GT_GGET_MKT_FCST_DATA;
  253|     DELETE FROM SCM_MGR.GT_GGET_MKT_FCST_DST;
  254|     DELETE FROM SCM_MGR.GT_GGET_SALES_PRICE;
  255|     DELETE FROM SCM_MGR.GT_GGET_EDI_SENDER;
  256|     DELETE FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP;
  257|     DELETE FROM SCM_MGR.GT_GGET_EDI_END_CUST;
  258|     DELETE FROM SCM_MGR.GT_GGET_RPA_END_CUST;
  259|     DELETE FROM SCM_MGR.GT_GGET_MKT_FCST_RESULT;
  260|     DELETE FROM SCM_MGR.GT_GGET_MF;
  261|     DELETE FROM SCM_MGR.GT_GGET_CAL_MONTH_END;
  262|     DELETE FROM SCM_MGR.GT_GGET_CAL_WEEK_END;
  263|     DELETE FROM SCM_MGR.GT_GGET_SHIPMENT_PLAN;
  264|     DELETE FROM SCM_MGR.GT_GGET_INTRANSIT_DATA;
  265|     DELETE FROM SCM_MGR.GT_GGET_VMI_INV;
  266|     DELETE FROM SCM_MGR.GT_GGET_VMI_INV_RESULT;
  267| 
  268|     -----------------------------------------------------------------------
  269|     -- 권한그룹 LOOKUP 관리 [20200311 KHSONG C20200103-000586]
  270|     -----------------------------------------------------------------------
  271|     DECLARE
  272|         V_ADMIN_CNT PLS_INTEGER := 0;
  273|     BEGIN
  274|         SELECT NVL(COUNT(1),0) INTO V_ADMIN_CNT
  275|         FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  276|         WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
  277|           AND  VALID_YN    = 'Y'
  278|           AND  SEGMENT2   IN ('ALL','DMF0003')
  279|           AND  SEGMENT1    = P_USER_GROUP;
  280|         IF V_ADMIN_CNT > 0 THEN
  281|             V_GROUP_ID := 'ADMIN';
  282|         END IF;
  283|     END;
  284| 
  285|     -----------------------------------------------------------------------
  286|     -- 조회 만료 기준 계산 (from + 40주)
  287|     -- SM임시작업 20240621 화면 장애 오류로 인하여 임시조치
  288|     -----------------------------------------------------------------------
  289|     V_EXP_YYYYMMDD := TO_CHAR(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD') + 40*7, 'YYYYMMDD');
  290| 
  291|     -----------------------------------------------------------------------
  292|     -- 버킷 컬럼 목록 동적 생성 (일별 D_, 주별 W_, 월별 M_)
  293|     -- CURSOR FAST_FORWARD → FOR LOOP
  294|     -----------------------------------------------------------------------
  295|     FOR R IN (
  296|         SELECT 'D_' || A.BASIS_YYYYMMDD || ' AS D_' || A.BASIS_YYYYMMDD     AS COLUMN_NAME
  297|              , '''D_' || A.BASIS_YYYYMMDD || ''' AS D_' || A.BASIS_YYYYMMDD AS PV_NAME
  298|              , A.BASIS_YYYYMMDD || '_31'                                    AS SORT_ORDER_NO
  299|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
  300|         WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
  301|           AND  A.BASIS_YYYYMMDD <= V_EXP_YYYYMMDD
  302|         UNION ALL
  303|         SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK
  304|              , '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ''' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK
  305|              , A.BASIS_START_DATE || '_21'
  306|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
  307|         WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
  308|           AND  A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
  309|         GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
  310|         UNION ALL
  311|         SELECT 'M_' || A.BASIS_YYYYMM || ' AS M_' || A.BASIS_YYYYMM
  312|              , '''M_' || A.BASIS_YYYYMM || ''' AS M_' || A.BASIS_YYYYMM
  313|              , MIN(A.BASIS_START_DATE) || '_01'
  314|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
  315|         WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
  316|           AND  A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
  317|         GROUP BY A.BASIS_YYYYMM
  318|         ORDER BY 3 -- SORT_ORDER_NO -- 컴파일 오류로 번호로 변경
  319|     )
  320|     LOOP
  321|         IF V_PV_COL_LIST IS NULL OR V_PV_COL_LIST = '' THEN
  322|             V_PV_COL_LIST := R.COLUMN_NAME;
  323|             V_PV_LIST     := R.PV_NAME;
  324|         ELSE
  325|             V_PV_COL_LIST := V_PV_COL_LIST || ',' || R.COLUMN_NAME;
  326|             V_PV_LIST     := V_PV_LIST     || ',' || R.PV_NAME;
  327|         END IF;
  328|     END LOOP;
  329| 
  330|     -----------------------------------------------------------------------
  331|     -- 사용자 컬럼 초기화 처리
  332|     -----------------------------------------------------------------------
  333|     V_COLUMN_NAME  := '';
  334|     V_COLUMN       := '';
  335|     V_GROUPBY      := '';
  336|     V_USER_COL_CNT := 0;
  337|     V_USER_MEA_CNT := 0;
  338| 
  339|     -- 사용자 컬럼 존재 여부 확인
  340|     SELECT COUNT(1) INTO V_USER_COL_CNT
  341|     FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  342|     WHERE  U.PROGRAM_ID                    = VA_PROGRAM_ID
  343|       AND  U.SHEET_NAME                    = VA_SHEET_NAME
  344|       AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
  345|       AND  U.USER_ID                       = P_CREATED_BY;
  346| 
  347|     IF V_USER_COL_CNT = 0 THEN
  348|         -- 사용자 컬럼이 없으면 기본값으로 복사
  349|         INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
  350|         ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
  351|         , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
  352|         , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
  353|         SELECT P_CREATED_BY, C.PROGRAM_ID, C.SHEET_NAME, 'C'
  354|              , C.COLUMN_NAME, C.SORT_ORDER_NO, 'N', ''
  355|              , P_CREATED_BY, SYSDATE
  356|              , P_CREATED_BY, SYSDATE
  357|         FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
  358|         WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
  359|           AND  C.SHEET_NAME   = VA_SHEET_NAME
  360|           AND  C.DEFAULT_FLAG = 'Y'
  361|           AND  C.VALID_YN     = 'Y';
  362| 
  363|           COMMIT WORK;
  364|     END IF;
  365| 
  366|     -- 사용자 메저 존재 여부 확인
  367|     SELECT COUNT(1) INTO V_USER_MEA_CNT
  368|     FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  369|     WHERE  U.PROGRAM_ID                    = VA_PROGRAM_ID
  370|       AND  U.SHEET_NAME                    = VA_SHEET_NAME
  371|       AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  372|       AND  U.USER_ID                       = P_CREATED_BY;
  373| 
  374|     IF V_USER_MEA_CNT = 0 THEN
  375|         INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
  376|         ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
  377|         , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
  378|         , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
  379|         SELECT P_CREATED_BY, C.PROGRAM_ID, C.SHEET_NAME, 'M'
  380|              , C.COLUMN_NAME, C.SORT_ORDER_NO, 'N', ''
  381|              , P_CREATED_BY, SYSDATE
  382|              , P_CREATED_BY, SYSDATE
  383|         FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
  384|         WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
  385|           AND  C.SHEET_NAME   = VA_SHEET_NAME
  386|           AND  C.DEFAULT_FLAG = 'Y'
  387|           AND  C.VALID_YN     = 'Y';
  388| 
  389|           COMMIT WORK;
  390|     END IF;
  391| 
  392|     -----------------------------------------------------------------------
  393|     -- 컬럼/정렬 문자열 동적 조립
  394|     -- CURSOR FAST_FORWARD c_title → FOR LOOP
  395|     -----------------------------------------------------------------------
  396|     FOR R IN (
  397|         SELECT U.COLUMN_NAME
  398|              , U.SORT_ORDER_NO
  399|         FROM  ( SELECT U.COLUMN_NAME
  400|                      , CASE WHEN U.COLUMN_NAME = 'LAST_UPDATE_DATE' THEN '800'
  401|                             WHEN U.COLUMN_NAME = 'LAST_UPDATED_BY'  THEN '560'
  402|                             ELSE TO_CHAR(U.SORT_ORDER_NO) END AS SORT_ORDER_NO
  403|                 FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  404|                      , SCM_MGR.SCM_MST_SHEET_COLUMNS C
  405|                 WHERE  U.PROGRAM_ID  = C.PROGRAM_ID
  406|                   AND  U.SHEET_NAME  = C.SHEET_NAME
  407|                   AND  U.COLUMN_NAME = C.COLUMN_NAME
  408|                   AND  U.PROGRAM_ID  = VA_PROGRAM_ID
  409|                   AND  U.SHEET_NAME  = VA_SHEET_NAME
  410|                   AND  U.USER_ID     = P_CREATED_BY
  411|                   AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
  412|                 UNION ALL
  413|                 -- 2024/05/17 kcw3408 이동계획 판가 매출GROUP_ID 추가
  414|                 SELECT C.COLUMN_NAME
  415|                      , CASE WHEN C.COLUMN_NAME = 'GROUP_ID'
  416|                             THEN TO_CHAR(NVL(U.SORT_ORDER_NO,85) - 0.5)
  417|                             ELSE TO_CHAR(C.SORT_ORDER_NO) END AS SORT_ORDER_NO
  418|                 FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
  419|                 LEFT   OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
  420|                   ON   U.PROGRAM_ID  = C.PROGRAM_ID
  421|                  AND   U.SHEET_NAME  = C.SHEET_NAME
  422|                  AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
  423|                  AND   U.COLUMN_NAME IN ('ITEM_ID')
  424|                  AND   U.USER_ID     = P_CREATED_BY
  425|                 WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
  426|                   AND  C.SHEET_NAME   = VA_SHEET_NAME
  427|                   AND  ( C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' '  OR C.DEFAULT_FLAG = '' )
  428|                   AND  C.VALID_YN     = 'Y' ) U
  429|         ORDER BY TO_NUMBER(U.SORT_ORDER_NO)
  430|     )
  431|     LOOP
  432|         IF V_COLUMN IS NULL OR V_COLUMN = '' THEN
  433|             V_COLUMN  := R.COLUMN_NAME;
  434|             V_GROUPBY := ' GROUP BY ' || R.COLUMN_NAME;
  435|             V_ORDERBY := ' ORDER BY SORT_KEY, '
  436|                       || CASE WHEN R.COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG')
  437|                                THEN R.COLUMN_NAME ELSE '' END;
  438|         ELSE
  439|             V_COLUMN  := V_COLUMN  || ', ' || R.COLUMN_NAME;
  440|             V_GROUPBY := V_GROUPBY || ', ' || R.COLUMN_NAME;
  441|             V_ORDERBY := V_ORDERBY
  442|                       || CASE WHEN R.COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG')
  443|                                THEN ', ' || R.COLUMN_NAME ELSE '' END;
  444|         END IF;
  445|     END LOOP;
  446| 
  447|     -- [E20240812-000094] NOTATION 컬럼 추가
  448|     V_COLUMN  := V_COLUMN  || ',NOTATION';
  449|     V_GROUPBY := V_GROUPBY || ', EDIT_FLAG, SORT_ORDER_NO';
  450|     V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');
  451|     V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');
  452| 
  453|     -----------------------------------------------------------------------
  454|     -- 사용자 시차(TIMEZONE) 조회
  455|     -----------------------------------------------------------------------
  456|     BEGIN
  457|         SELECT U.TMZ_CD INTO V_USER_TIME_ZONE
  458|         FROM   SCM_MGR.SCM_ADM_USER_M U
  459|         WHERE  U.USER_ID = P_CREATED_BY;
  460|     EXCEPTION
  461|         WHEN NO_DATA_FOUND THEN V_USER_TIME_ZONE := '';
  462|     END;
  463| 
  464|     -----------------------------------------------------------------------
  465|     -- 계획/실적 기준 날짜 계산
  466|     -----------------------------------------------------------------------
  467|     -- @v_from_yyyymmdd : (User 시차 고려) 당주 월요일
  468|     BEGIN
  469|         SELECT MIN(C.BASIS_YYYYMMDD) INTO V_FROM_YYYYMMDD
  470|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
  471|              , ( SELECT DISTINCT ISO_YYYYWW
  472|                  FROM   SCM_MGR.SCM_SYS_CALENDAR_M
  473|                  WHERE  BASIS_YYYYMMDD =
  474|                         TO_CHAR(SCM_MGR.FN_MULTY_TIME(V_USER_TIME_ZONE),'YYYYMMDD')
  475|                ) T
  476|         WHERE  C.ISO_YYYYWW = T.ISO_YYYYWW;
  477|     EXCEPTION
  478|         WHEN NO_DATA_FOUND THEN V_FROM_YYYYMMDD := TO_CHAR(SYSDATE,'YYYYMMDD');
  479|     END;
  480| 
  481|     -- From 실적 : From 조회 구간 월요일
  482|     BEGIN
  483|         SELECT C.BASIS_START_DATE INTO V_FROM_RESULT
  484|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
  485|         WHERE  C.BASIS_YYYYMMDD = P_FROM_YYYYMMDD;
  486|     EXCEPTION
  487|         WHEN NO_DATA_FOUND THEN V_FROM_RESULT := '';
  488|     END;
  489| 
  490|     -- To 실적 : To 조회 구간 월요일 전까지
  491|     BEGIN
  492|         SELECT C.BASIS_START_DATE INTO V_TO_RESULT
  493|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
  494|         WHERE  C.BASIS_YYYYMMDD = P_TO_YYYYMMDD;
  495|     EXCEPTION
  496|         WHEN NO_DATA_FOUND THEN V_TO_RESULT := '';
  497|     END;
  498| 
  499|     IF V_FROM_YYYYMMDD > V_FROM_RESULT THEN
  500|         -- 실적 보여줌
  501|         V_TO_YYYYMMDD := P_TO_YYYYMMDD;
  502|         V_TO_RESULT   := V_FROM_YYYYMMDD;  -- To 실적 : 당주 월요일 전까지
  503|     ELSIF V_FROM_YYYYMMDD <= V_FROM_RESULT THEN
  504|         -- 실적 없음
  505|         V_TO_YYYYMMDD := P_TO_YYYYMMDD;
  506|         V_FROM_RESULT := '19000101';
  507|         V_TO_RESULT   := '19000101';
  508|     ELSIF V_FROM_YYYYMMDD > V_TO_RESULT THEN
  509|         -- 실적만 보여줌
  510|         V_FROM_YYYYMMDD := '19000101';
  511|         V_TO_YYYYMMDD   := '19000101';
  512|         V_FROM_RESULT   := P_FROM_YYYYMMDD;
  513|         V_TO_RESULT     := P_TO_YYYYMMDD;
  514|     ELSIF V_FROM_YYYYMMDD = V_TO_RESULT THEN
  515|         -- 실적 없음
  516|         V_TO_YYYYMMDD := V_FROM_YYYYMMDD;
  517|         V_FROM_RESULT := P_FROM_YYYYMMDD;
  518|         V_TO_RESULT   := P_TO_YYYYMMDD;
  519|     END IF;
  520| 
  521|     -----------------------------------------------------------------------
  522|     -- [E20260211-001189] 조회 SALES SITE 중 AS용 데이터가 있으면 AS_YN = 'Y'로 처리
  523|     -- TABLE()은 컬렉션 변수만 허용 → 먼저 변수에 COLLECT 후 참조
  524|     -----------------------------------------------------------------------
  525|     DECLARE
  526|         V_AS_CNT PLS_INTEGER := 0;
  527|     BEGIN
  528|         SELECT CAST(
  529|                    COLLECT(DISTINCT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)))
  530|                AS SCM_MGR.T_STR_TAB)
  531|         INTO   T_SCM_SITE_IDS
  532|         FROM   DUAL
  533|         CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL;
  534| 
  535|         SELECT COUNT(DISTINCT A.COLUMN_VALUE) INTO V_AS_CNT
  536|         FROM   TABLE(T_SCM_SITE_IDS) A
  537|         JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
  538|           ON   A.COLUMN_VALUE = B.SEGMENT1
  539|          AND   B.LOOKUP_TYPE  = 'AS_SITE_PLANT';
  540| 
  541|         IF V_AS_CNT > 0 THEN
  542|             LP_AS_YN := 'Y';
  543|         END IF;
  544|     END;
  545|     -- [E20260211-001189] END
  546| 
  547|     -----------------------------------------------------------------------
  548|     -- [C20200804-000123] SSP 동기화 / BNP 데이터 수집
  549|     -----------------------------------------------------------------------
  550|     -- Division 40: DM_PLN_MKT_FCST 기반 PIVOT → GT_GGET_T_SSP_SYNC
  551|     IF P_DIVISION_ID = '40' THEN
  552|         INSERT INTO SCM_MGR.GT_GGET_T_SSP_SYNC
  553|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ATTR1 )
  554|         SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
  555|              , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
  556|             || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
  557|             || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
  558|             || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
  559|             || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
  560|             || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
  561|             || '^' || NVL(A31,'') AS ATTR1
  562|         FROM (
  563|             SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, A.FCST_TYPE, INCOTERMS
  564|                  , YYYYMMDD || '/'
  565|                    || CASE
  566|                           WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
  567|                            AND A.QTY >
  568|                                CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
  569|                                     THEN TO_NUMBER(ATTRIBUTE3) ELSE 0 END
  570|                              + CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE2,'0'),'^[0-9.]+$')
  571|                                     THEN TO_NUMBER(ATTRIBUTE2) ELSE 0 END
  572|                           THEN 'P'
  573|                           ELSE 'A'
  574|                       END AS SYNC_YN
  575|                  , 'A' || TO_CHAR(
  576|                        ROW_NUMBER() OVER (
  577|                            PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
  578|                                         DOM_EXP, A.FCST_TYPE, INCOTERMS
  579|                            ORDER BY YYYYMMDD
  580|                        )) AS ROW_NUM
  581|             FROM   SCM_MGR.DM_PLN_MKT_FCST A
  582|             -- [E20260211-001189] #T_WS_FCST JOIN 주석처리된 원본 그대로 반영
  583|             WHERE  A.DIVISION_ID = P_DIVISION_ID
  584|               AND  A.MEASURE     = 'MKT_FCST'
  585|               AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
  586|               AND  ( A.ATTRIBUTE4 IS NOT NULL OR A.ATTRIBUTE5 IS NOT NULL OR NVL(A.ATTRIBUTE4,'') <> '' OR NVL(A.ATTRIBUTE5,'') <> '')  -- [C20210225-000385]
  587|               AND  A.QTY <> 0
  588|               AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID
  589|                           ELSE A.SCM_SITE_ID END
  590|                      IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL))
  591|                          FROM DUAL
  592|                          CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
  593|               AND  ( LP_PROJECT_CODE IS NULL
  594|                      OR CASE WHEN LP_PROJECT_CODE = '' THEN LP_PROJECT_CODE
  595|                           ELSE A.PROJECT_CODE END
  596|                      IN (SELECT TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL))
  597|                          FROM DUAL
  598|                          CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL) )
  599|               AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID
  600|                           ELSE A.PLANT_SITE_ID END
  601|                      IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL))
  602|                          FROM DUAL
  603|                          CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
  604|         ) A
  605|         PIVOT (
  606|             MAX(SYNC_YN) FOR ROW_NUM IN (
  607|                 'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
  608|                 'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
  609|                 'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
  610|                 'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
  611|                 'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
  612|                 'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
  613|                 'A31' A31
  614|             )
  615|         );
  616| 
  617|     -- Division 82: DM_PLN_PR_DETAIL 기반 PIVOT → GT_GGET_T_BNP [PJ20209642R]
  618|     ELSIF P_DIVISION_ID = '82' THEN
  619|         INSERT INTO SCM_MGR.GT_GGET_T_BNP
  620|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ATTR1 )
  621|         SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
  622|              , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
  623|             || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
  624|             || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
  625|             || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
  626|             || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
  627|             || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
  628|             || '^' || NVL(A31,'') AS ATTR1
  629|         FROM (
  630|             SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
  631|                             DOM_EXP, FCST_TYPE, INCOTERMS
  632|                  , YYYYMMDD || '/A' AS SYNC_YN
  633|                  , 'A' || TO_CHAR(
  634|                        ROW_NUMBER() OVER (
  635|                            PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
  636|                                         DOM_EXP, FCST_TYPE, INCOTERMS
  637|                            ORDER BY YYYYMMDD
  638|                        )) AS ROW_NUM
  639|             FROM   SCM_MGR.DM_PLN_PR_DETAIL A
  640|             WHERE  A.DIVISION_ID = P_DIVISION_ID
  641|               AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
  642|         ) A
  643|         PIVOT (
  644|             MAX(SYNC_YN) FOR ROW_NUM IN (
  645|                 'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
  646|                 'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
  647|                 'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
  648|                 'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
  649|                 'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
  650|                 'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
  651|                 'A31' A31
  652|             )
  653|         );
  654|     END IF;
  655|     -- [C20200804-000123] 끝
  656| 
  657|     -----------------------------------------------------------------------
  658|     -- [E20240920-000300] ITEM_SINGLE_V 속도 개선 - 3단계로 나눠서 INSERT
  659|     -----------------------------------------------------------------------
  660|     -- Step 1: SCM_MST_ITEM_SN 전체를 GT_GGET_ITEM_SINGLE_ORI에 적재
  661|     INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_ORI
  662|     ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
  663|     , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
  664|     , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
  665|     , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
  666|     , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
  667|     SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
  668|          , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
  669|          , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
  670|          , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
  671|          , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
  672|     FROM   SCM_MGR.SCM_MST_ITEM_SN
  673|     WHERE  DIVISION_ID = P_DIVISION_ID
  674|       AND  ACTIVE_FLAG = 'Y';
  675| 
  676|     -- Step 2A: 기본 컬럼 GROUP BY → GT_GGET_ITEM_SINGLE_A
  677|     INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_A
  678|     ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
  679|     , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
  680|     , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
  681|     SELECT T1.DIVISION_ID
  682|          , T1.ITEM_ID
  683|          , MAX(T1.ITEM_NAME)
  684|          , MAX(T1.ITEM_CLASS)
  685|          , MAX(T1.ITEM_CLASS_NAME)
  686|          , MAX(T1.NICK_NAME)
  687|          , CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
  688|                          WHEN T1.ITEM_TYPE = 'H' THEN 2
  689|                          WHEN T1.ITEM_TYPE = 'Q' THEN 3
  690|                          ELSE 4 END)
  691|                WHEN 1 THEN 'P' WHEN 2 THEN 'H' WHEN 3 THEN 'Q' ELSE 'R' END
  692|          , MAX(T1.MATERIAL_CLASS_NAME)
  693|          , MAX(T1.ITEM_UOM)
  694|          , MAX(T1.SPEC)
  695|          , MAX(T1.MDM_PROJECT_NAME)
  696|          , MAX(T1.MIN_CAPACITY)
  697|          , MAX(T1.ACTIVE_FLAG)
  698|          , MAX(T1.ENERGE)
  699|          , MAX(T1.CELL_QUANTITY)
  700|          , MAX(T1.SCP_EXTRA_SPEC)
  701|     FROM   SCM_MGR.GT_GGET_ITEM_SINGLE_ORI T1
  702|     GROUP BY T1.DIVISION_ID, T1.ITEM_ID;
  703| 
  704|     -- Step 2B: FORECAST_INFO 계열 LEFT(12) 기준 집계 → GT_GGET_ITEM_SINGLE_B
  705|     INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_B
  706|     ( DIVISION_ID, ITEM_ID
  707|     , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
  708|     , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
  709|     SELECT DIVISION_ID
  710|          , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
  711|          , MAX(FORECAST_INFO_BIZ_TYPE)
  712|          , MAX(FORECAST_INFO_PRODUCT_GROUP)
  713|          , MAX(FORECAST_INFO_CELL_MODEL)
  714|          , MAX(FORECAST_INFO_CELL_PACK_COUNT)
  715|          , MAX(FORECAST_INFO_SPEC)
  716|          , MAX(FORECAST_INFOR_VERSION)
  717|          , MAX(CELL_TYPE)
  718|     FROM   SCM_MGR.GT_GGET_ITEM_SINGLE_ORI
  719|     GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);
  720| 
  721|     -- Step 3: A+B JOIN 후 ITEM_ID/NICK_NAME LIKE 필터 적용 → GT_GGET_ITEM_SINGLE_V
  722|     INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_V
  723|     ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
  724|     , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
  725|     , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
  726|     , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
  727|     , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
  728|     SELECT T1.DIVISION_ID, T1.ITEM_ID
  729|          , T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
  730|          , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
  731|          , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
  732|          , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
  733|          , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
  734|     FROM   SCM_MGR.GT_GGET_ITEM_SINGLE_A T1
  735|     JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_B T2
  736|       ON   T1.DIVISION_ID          = T2.DIVISION_ID
  737|      AND   SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
  738|     WHERE  T1.DIVISION_ID = P_DIVISION_ID
  739|       AND  EXISTS (
  740|                SELECT 1
  741|                FROM (
  742|                    SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) || '%' AS TST
  743|                    FROM DUAL
  744|                    CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL
  745|                ) B
  746|                WHERE T1.ITEM_ID   LIKE B.TST
  747|                   OR T1.NICK_NAME LIKE B.TST
  748|            )
  749|     GROUP BY T1.DIVISION_ID, T1.ITEM_ID
  750|            , T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
  751|            , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
  752|            , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
  753|            , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
  754|            , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC;
  755| 
  756|     -- [E20240731-000856] Wh → KWh 환산
  757|     UPDATE SCM_MGR.GT_GGET_ITEM_SINGLE_V
  758|     SET    ENERGE = CASE WHEN REGEXP_LIKE(NVL(ENERGE,'X'),'^[0-9.]+$')
  759|                          THEN TO_CHAR(ROUND(TO_NUMBER(ENERGE)/1000, 4))
  760|                          ELSE NULL END;
  761| 
  762|     -----------------------------------------------------------------------
  763|     -- GT_GGET_SELECT_MEASURE 수집
  764|     -- [C20200612-000174] ESS사업부 조회 구간에 mapping되지 않은 Sales Price 데이터 제공
  765|     -----------------------------------------------------------------------
  766|     INSERT INTO SCM_MGR.GT_GGET_SELECT_MEASURE
  767|     ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO )
  768|     SELECT DISTINCT U.PROGRAM_ID
  769|                   , U.SHEET_NAME
  770|                   , U.USER_ID
  771|                   , CASE WHEN U.COLUMN_NAME IN ('CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO')
  772|                          THEN 'CUST. PSI'
  773|                          WHEN U.COLUMN_NAME IN ('MKT_INV_I','MKT_PRODUCT_S','MKT_WHIN_P','MKT_DIO')
  774|                          THEN 'MKT PSI'
  775|                          ELSE U.COLUMN_NAME END AS MEASURE_GROUP
  776|                   , U.COLUMN_NAME AS MEASURE
  777|                   , CASE WHEN U.COLUMN_NAME IN ('CUST_FCST','CUST_FCST_EDI','CUST_FCST_ORG','CUST_FCST_EDI_ORG')
  778|                          THEN SMSM.SORT_ORDER_NO   -- 20231212 kcw3408 4_고객수요 Measure 통합
  779|                          ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO
  780|     FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  781|     JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
  782|       ON   U.PROGRAM_ID  = SMSM.PROGRAM_ID
  783|      AND   U.SHEET_NAME  = SMSM.SHEET_NAME
  784|      AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
  785|      AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  786|      AND   SMSM.VALID_YN = 'Y'
  787|     LEFT   JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
  788|       ON   U.USER_ID    = T.SEGMENT4     -- 20200309 KHSONG TMM MEASURE 권한추가
  789|      AND   P_CREATED_BY = T.SEGMENT4
  790|      AND   T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
  791|      AND   T.VALID_YN    = 'Y'
  792|     WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  793|       AND  U.PROGRAM_ID = 'DMF0003'
  794|       AND  U.SHEET_NAME = 'main'
  795|       AND  U.USER_ID    = P_CREATED_BY
  796|       AND  U.USER_ID    = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4
  797|                                ELSE P_CREATED_BY END
  798|     -----------------------------------------------------------------------
  799|     -- [20191118 KHSONG CSR ID:C20191031-000137] CUST_FCST_EDI 계열 sub-measure 추가
  800|     -----------------------------------------------------------------------
  801|     UNION ALL
  802|     SELECT A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE
  803|          , A.SORT_ORDER_NO + B.SORT_ORDER_NO
  804|     FROM (
  805|         SELECT U.PROGRAM_ID, U.SHEET_NAME, U.USER_ID
  806|              -- [E20241126-000426] CUST_FCST_EDI → CUST_FCST 로 변경
  807|              , 'CUST_FCST' AS MEASURE_GROUP
  808|              , SMSM.SORT_ORDER_NO
  809|         FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  810|         JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
  811|           ON   U.PROGRAM_ID  = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
  812|          AND   U.COLUMN_NAME = SMSM.COLUMN_NAME AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  813|          AND   SMSM.VALID_YN = 'Y'
  814|         WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  815|           AND  U.PROGRAM_ID  = 'DMF0003'
  816|           AND  U.SHEET_NAME  = 'main'
  817|           AND  U.USER_ID     = P_CREATED_BY
  818|           -- [E20241126-000426] CUST_FCST_EDI → CUST_FCST 로 변경
  819|           AND  U.COLUMN_NAME = 'CUST_FCST'
  820|     ) A,
  821|     (
  822|         -- [E20241126-000426] CUST_FCST_EDI 추가 및 순서 변경
  823|         SELECT 'Immidiate'                   AS MEASURE, 0.15 AS SORT_ORDER_NO FROM DUAL UNION ALL
  824|         SELECT 'Planning_Forecast'                      , 0.18 FROM DUAL UNION ALL
  825|         SELECT 'Commercial_Agreement'                   , 0.13 FROM DUAL UNION ALL
  826|         SELECT 'Firm_Temp'                              , 0.14 FROM DUAL UNION ALL
  827|         SELECT 'Manumacturing_Material_Temp'            , 0.16 FROM DUAL UNION ALL
  828|         SELECT 'Material_Temp'                          , 0.17 FROM DUAL UNION ALL
  829|         SELECT 'Backorder'                              , 0.12 FROM DUAL UNION ALL
  830|         SELECT 'CUST_FCST_EDI'                          , 0.11 FROM DUAL
  831|     ) B
  832|     GROUP BY A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE
  833|            , A.SORT_ORDER_NO + B.SORT_ORDER_NO
  834|     -----------------------------------------------------------------------
  835|     -- CUST_FCST_2 : DM_MST_CUSTOMER_FCST 기반 동적 Measure
  836|     -----------------------------------------------------------------------
  837|     UNION ALL
  838|     SELECT DISTINCT 'DMF0003'   AS PROGRAM_ID
  839|                   , 'main'  AS SHEET_NAME
  840|                   , P_CREATED_BY AS USER_ID
  841|                   , 'CUST_FCST_2' AS MEASURE_GROUP
  842|                   , C.MEASURE
  843|                   ,
  844|                       ( SELECT SMSM.SORT_ORDER_NO
  845|                         FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  846|                         JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
  847|                           ON   U.PROGRAM_ID = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
  848|                          AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
  849|                          AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M' AND SMSM.VALID_YN = 'Y'
  850|                         WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  851|                           AND  U.PROGRAM_ID = 'DMF0003' AND U.SHEET_NAME = 'main'
  852|                           AND  U.USER_ID = P_CREATED_BY AND U.COLUMN_NAME = 'CUST_FCST' )
  853|                       + 0.1
  854|                      AS SORT_ORDER_NO
  855|     FROM   SCM_MGR.DM_MST_CUSTOMER_FCST C
  856|     WHERE  C.MEASURE_GROUP = 'CUST_FCST'
  857|       AND  NVL(C.MEASURE,'-') <> '-'
  858|       AND  C.VALID_YN = 'Y'
  859|       AND  EXISTS (
  860|                SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER X
  861|                WHERE  X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  862|                  AND  X.PROGRAM_ID = 'DMF0003' AND X.SHEET_NAME = 'main'
  863|                  AND  X.USER_ID    = P_CREATED_BY
  864|                  AND  X.COLUMN_NAME = 'CUST_FCST' AND X.COLUMN_NAME = C.MEASURE_GROUP
  865|            )
  866|     -----------------------------------------------------------------------
  867|     -- CUST_FCST_3 : Customer Fcst[Org.] 고정 Measure
  868|     -----------------------------------------------------------------------
  869|     UNION ALL
  870|     SELECT DISTINCT 'DMF0003', 'main', P_CREATED_BY
  871|                   , 'CUST_FCST_3', 'Customer Fcst[Org.]'
  872|                   ,
  873|                       ( SELECT SMSM.SORT_ORDER_NO
  874|                         FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  875|                         JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
  876|                           ON   U.PROGRAM_ID = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
  877|                          AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
  878|                          AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M' AND SMSM.VALID_YN = 'Y'
  879|                         WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  880|                           AND  U.PROGRAM_ID = 'DMF0003' AND U.SHEET_NAME = 'main'
  881|                           AND  U.USER_ID = P_CREATED_BY AND U.COLUMN_NAME = 'CUST_FCST_ORG' )
  882|                       + 0.1
  883|                      AS SORT_ORDER_NO
  884|     FROM   SCM_MGR.DM_MST_CUSTOMER_FCST C
  885|     WHERE  C.MEASURE_GROUP = 'CUST_FCST'
  886|       AND  NVL(C.MEASURE,'-') <> '-'
  887|       AND  C.VALID_YN = 'Y'
  888|       AND  EXISTS (
  889|                SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER X
  890|                WHERE  X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  891|                  AND  X.PROGRAM_ID = 'DMF0003' AND X.SHEET_NAME = 'main'
  892|                  AND  X.USER_ID    = P_CREATED_BY AND X.COLUMN_NAME = 'CUST_FCST_ORG'
  893|            );
  894| 
  895|     -----------------------------------------------------------------------
  896|     -- [C20201103-000114] Division 82: MKT_FCST_RP 선택 시 VMI 관련 메저 강제 추가
  897|     -----------------------------------------------------------------------
  898|     DECLARE
  899|         V_MKT_RP_CNT PLS_INTEGER := 0;
  900|     BEGIN
  901|         SELECT COUNT(1) INTO V_MKT_RP_CNT
  902|         FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
  903|         WHERE  MEASURE = 'MKT_FCST_RP';
  904| 
  905|         IF V_MKT_RP_CNT > 0 AND P_DIVISION_ID = '82' THEN
  906|             -- 순서 조정을 위해 기존 항목 제거 후 재삽입
  907|             DELETE FROM SCM_MGR.GT_GGET_SELECT_MEASURE
  908|             WHERE  MEASURE IN ('RTF_SYS_RP','VMI_IN_PLAN','VMI_IN_REQ','VMI_INV');
  909| 
  910|             INSERT INTO SCM_MGR.GT_GGET_SELECT_MEASURE
  911|             ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO )
  912|             SELECT A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID
  913|                  , B.MEASURE_GROUP, B.MEASURE
  914|                  , REPLACE(A.SORT_ORDER_NO, '.0', B.SORTKEY)
  915|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE A
  916|             JOIN   (
  917|                        SELECT 'RTF_SYS_RP'  AS MEASURE_GROUP, 'RTF_SYS_RP'  AS MEASURE, '.1' AS SORTKEY FROM DUAL UNION ALL
  918|                        SELECT 'VMI_In_Plan'               , 'VMI_In_Plan'               , '.2' FROM DUAL UNION ALL
  919|                        SELECT 'VMI_In_Req'                , 'VMI_In_Req'                , '.3' FROM DUAL UNION ALL
  920|                        SELECT 'VMI_Inv'                   , 'VMI_Inv'                   , '.4' FROM DUAL
  921|                    ) B ON 1=1
  922|             WHERE  A.MEASURE = 'MKT_FCST_RP';
  923|         END IF;
  924|     END;
  925| 
  926|     -- MKT FCST 메저 순서 변경
  927|     UPDATE SCM_MGR.GT_GGET_SELECT_MEASURE
  928|     SET    SORT_ORDER_NO = REPLACE(SORT_ORDER_NO, '.0', '.9')
  929|     WHERE  MEASURE = 'MKT_FCST_RP';
  930| 
  931|     -----------------------------------------------------------------------
  932|     -- GT_GGET_VMI_DIO 수집
  933|     -----------------------------------------------------------------------
  934|     IF P_DIVISION_ID = '40' THEN
  935|         INSERT INTO SCM_MGR.GT_GGET_VMI_DIO ( KEY_JOIN, VMI_STD_DIO )
  936|         SELECT A.ITEM_ID, A.VMI_STD_DIO
  937|         FROM   SCM_MGR.SCP_MST_DIO A
  938|         JOIN (
  939|             SELECT DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN, MAX(YYYYMM) AS YYYYMM
  940|             FROM   SCM_MGR.SCP_MST_DIO
  941|             WHERE  DIVISION_ID = '40' AND TOTAL_YN = 'Y' AND PLANT_ID = '*'
  942|             GROUP  BY DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN
  943|         ) B ON A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
  944|            AND A.ITEM_ID     = B.ITEM_ID     AND A.TOTAL_YN = B.TOTAL_YN
  945|            AND A.YYYYMM      = B.YYYYMM
  946|         WHERE  A.DIVISION_ID = '40' AND A.TOTAL_YN = 'Y' AND A.PLANT_ID = '*';
  947| 
  948|     ELSIF P_DIVISION_ID = '82' THEN   -- [C20201103-000114]
  949|         INSERT INTO SCM_MGR.GT_GGET_VMI_DIO ( KEY_JOIN, VMI_VAL )
  950|         SELECT A.SCM_SITE_ID
  951|              , A.VMI_YN || '^' || NVL(TO_CHAR(A.ATTRIBUTE5),'')
  952|         FROM   SCM_MGR.SCM_MST_SITE A
  953|         WHERE  DIVISION_ID = P_DIVISION_ID;
  954|     END IF;
  955| 
  956|     -----------------------------------------------------------------------
  957|     -- GT_GGET_SITE_ITEM_ALL 수집 (81/82 vs 40 분기)
  958|     -----------------------------------------------------------------------
  959|     IF P_DIVISION_ID LIKE '81%' OR P_DIVISION_ID = '82' THEN
  960|         INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL
  961|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
  962|              , T2.NICK_NAME, T3.PROJECT_NAME
  963|              , ''   AS CELL_MODEL      -- 20180809 ytchoi modify
  964|              , T3.BIZ_TYPE
  965|              , S.END_CUSTOMER
  966|              , S.SOLDTO_CUSTOMER
  967|              , I.COUNTRY, I.COUNTRY_NAME
  968|              , H.CITY, H.CITY_NAME
  969|              , ( SELECT DISTINCT
  970|                      LISTAGG(ZA.USER_NAME_EN,',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN)
  971|                  FROM   SCM_MGR.SCM_MST_SSO_USER_INFO ZA
  972|                  WHERE  ZA.USER_ID IN (
  973|                      SELECT TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL))
  974|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL) IS NOT NULL
  975|                  )
  976|                ) AS OWNER
  977|              , CASE WHEN F.DIVISION_ID NOT IN ('40') THEN T3.PROJECT_OWNER
  978|                     ELSE J.USER_NAME_EN END AS PROJECT_OWNER   -- 20180705
  979|              , J.USER_ID
  980|              , T2.ITEM_NAME, T2.ITEM_TYPE
  981|              , T3.PROJECT_STATUS
  982|              , F.CUST_GROUP, F.CUST_GROUP_DTL, F.APPLICATION, F.ROUTE
  983|              , T2.MDM_PROJECT_NAME, TO_CHAR(T2.MIN_CAPACITY)
  984|              , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
  985|              , LOOK.NAME  AS CELL_TYPE   -- 20180911 LookUp TABLE JOIN
  986|              , T2.FORECAST_INFO_CELL_PACK_COUNT
  987|              , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
  988|              , T2.FORECAST_INFO_SPEC
  989|              , T2.FORECAST_INFOR_VERSION
  990|              , NVL(T4.NICK_NAME,'')  AS CELL_MODEL_NICK_NAME  -- 20190419 KHSONG
  991|              , S.VMI_YN
  992|              , NVL(F.ATTRIBUTE1,'')  AS DMS_SALES    -- 20190213 KHSONG
  993|              , NVL(F.ATTRIBUTE2,'')  AS DMS_CUSTOMER -- 20190213 KHSONG
  994|              -- [PJ2024-50461] Team Mapping
  995|              , TEAM.DEPT_ID
  996|              , TEAM_DEPT.DEPT_NAME_KO
  997|              , F.CELL_PER_CAR
  998|              , F.CELL_PER_MODULE  -- [E20260123-001715] 원소스 복원
  999|              , F.CELL_PER_CAR / CASE WHEN NVL(F.CELL_PER_MODULE,0) = 0 THEN 1
 1000|                                       ELSE F.CELL_PER_MODULE END  AS MODULE_PER_CAR
 1001|              , T2.ITEM_CLASS_NAME
 1002|              , T2.ENERGE
 1003|              , TO_CHAR(T2.CELL_QUANTITY)
 1004|              , F.VALID_YN  AS ITEM_VALID_YN
 1005|         FROM   SCM_MGR.SCM_MST_SITE_ITEM F
 1006|         JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_V T2
 1007|           ON   F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
 1008|         JOIN   SCM_MGR.SCM_MST_PROJECT T3
 1009|           ON   F.DIVISION_ID = T3.DIVISION_ID AND F.PROJECT_CODE = T3.PROJECT_CODE
 1010|         JOIN (
 1011|              SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) || '%' TST
 1012|              FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL
 1013|         ) B ON (F.ITEM_ID LIKE B.TST OR T2.NICK_NAME LIKE B.TST)   -- 20190118 DISTINCT 추가
 1014|         JOIN (
 1015|              SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL)) || '%' TST
 1016|              FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL
 1017|         ) C ON (F.PROJECT_CODE LIKE C.TST OR T3.PROJECT_NAME LIKE C.TST)
 1018|         JOIN   SCM_MGR.SCM_MST_SITE S
 1019|           ON   F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID
 1020|          AND   S.SITE_TYPE   = 'SALES' AND S.VALID_YN = 'Y'
 1021|         JOIN   SCM_MGR.SCM_MST_CITY H    ON S.CITY    = H.CITY
 1022|         JOIN   SCM_MGR.SCM_MST_COUNTRY I ON S.COUNTRY = I.COUNTRY
 1023|         -- [PJ2024-50461] Team Mapping
 1024|         LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO TEAM
 1025|           ON   TEAM.USER_ID = TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1))
 1026|         LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM_DEPT
 1027|           ON   TEAM.DEPT_ID = TEAM_DEPT.DEPT_ID
 1028|         LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
 1029|           ON   SUBSTR(F.OWNER, 1,
 1030|                       CASE WHEN INSTR(F.OWNER,',') = 0 THEN LENGTH(F.OWNER)
 1031|                            ELSE INSTR(F.OWNER,',') - 1 END) = J.USER_ID
 1032|         LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K ON J.DEPT_ID = K.DEPT_ID
 1033|         LEFT   JOIN (
 1034|                         SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
 1035|                         FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 1036|                         WHERE  LOOKUP_TYPE = 'CELL_TYPE'
 1037|                     ) LOOK ON LOOK.CODE = T2.CELL_TYPE
 1038|         LEFT   JOIN SCM_MGR.GT_GGET_ITEM_SINGLE_V T4
 1039|           ON   T2.DIVISION_ID = T4.DIVISION_ID
 1040|          AND   NVL(T2.FORECAST_INFO_CELL_MODEL,'') = T4.ITEM_ID  -- 20190419 KHSONG
 1041|         WHERE  F.DIVISION_ID <> '40'   -- hard coding (20190123 KHSONG)
 1042|           AND  F.DIVISION_ID = P_DIVISION_ID
 1043|           -- [E20260211-001189] SCM_SITE_ID 조건 주석처리
 1044|           AND  ( CASE WHEN P_CUSTOMER = 'ALL' THEN P_CUSTOMER
 1045|                       ELSE S.END_CUSTOMER END
 1046|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
 1047|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL) )
 1048|           AND  ( CASE WHEN P_ITEM_TYPE = 'ALL' THEN P_ITEM_TYPE
 1049|                       ELSE T2.ITEM_TYPE END
 1050|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
 1051|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
 1052|           AND  ( CASE WHEN P_BIZ_TYPE = 'ALL' THEN P_BIZ_TYPE
 1053|                       ELSE T3.BIZ_TYPE END
 1054|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
 1055|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
 1056|           AND  ( ( P_OWNER IS NULL OR P_OWNER = '' )
 1057|                    OR F.OWNER IN (SELECT TRIM(REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL))
 1058|                                   FROM DUAL CONNECT BY REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL) IS NOT NULL) );
 1059| 
 1060|     ELSE
 1061|         -- Division 40 (소형) 케이스
 1062|         INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL
 1063|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
 1064|              , T2.NICK_NAME, F.PROJECT_CODE  AS PROJECT_NAME
 1065|              , F.ATTRIBUTE5  AS CELL_MODEL   -- 20180810 ytchoi 조회속도개선
 1066|              , ''  AS BIZ_TYPE
 1067|              , S.END_CUSTOMER
 1068|              , S.SOLDTO_CUSTOMER
 1069|              , I.COUNTRY, I.COUNTRY_NAME
 1070|              , H.CITY, H.CITY_NAME
 1071|              , ( SELECT DISTINCT
 1072|                      LISTAGG(ZA.USER_NAME_EN,',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN)
 1073|                  FROM   SCM_MGR.SCM_MST_SSO_USER_INFO ZA
 1074|                  WHERE  ZA.USER_ID IN (
 1075|                      SELECT TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL))
 1076|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL) IS NOT NULL
 1077|                  )
 1078|                ) AS OWNER
 1079|              , J.USER_NAME_EN  AS PROJECT_OWNER   -- 20180705
 1080|              , J.USER_ID
 1081|              , T2.ITEM_NAME, T2.ITEM_TYPE
 1082|              , ''  AS PROJECT_STATUS
 1083|              , F.CUST_GROUP, F.CUST_GROUP_DTL, F.APPLICATION, F.ROUTE
 1084|              , T2.MDM_PROJECT_NAME, TO_CHAR(T2.MIN_CAPACITY)
 1085|              -- [E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청
 1086|              , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
 1087|                     ELSE T2.FORECAST_INFO_BIZ_TYPE END  AS FORECAST_INFO_BIZ_TYPE
 1088|              , T2.FORECAST_INFO_PRODUCT_GROUP
 1089|              , LOOK.NAME  AS CELL_TYPE
 1090|              , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT)
 1091|                     ELSE T2.FORECAST_INFO_CELL_PACK_COUNT END  AS FORECAST_INFO_CELL_PACK_COUNT
 1092|              , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
 1093|              , T2.FORECAST_INFO_SPEC
 1094|              , T2.FORECAST_INFOR_VERSION
 1095|              , NVL(T4.NICK_NAME,'')  AS CELL_MODEL_NICK_NAME
 1096|              , S.VMI_YN
 1097|              , NVL(F.ATTRIBUTE1,'')  AS DMS_SALES
 1098|              , NVL(F.ATTRIBUTE2,'')  AS DMS_CUSTOMER
 1099|              -- [PJ2024-50461] Team Mapping
 1100|              , TEAM.DEPT_ID
 1101|              , TEAM.DEPT_NAME_KO
 1102|              , F.CELL_PER_CAR
 1103|              , F.CELL_PER_MODULE
 1104|              , F.CELL_PER_CAR / CASE WHEN NVL(F.CELL_PER_MODULE,0) = 0 THEN 1
 1105|                                       ELSE F.CELL_PER_MODULE END  AS MODULE_PER_CAR
 1106|              , T2.ITEM_CLASS_NAME
 1107|              , T2.ENERGE
 1108|              , TO_CHAR(T2.CELL_QUANTITY)
 1109|              , F.VALID_YN  AS ITEM_VALID_YN
 1110|         FROM   SCM_MGR.SCM_MST_SITE_ITEM F
 1111|         JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_V T2
 1112|           ON   F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
 1113|         JOIN (
 1114|              SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) || '%' TST
 1115|              FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL
 1116|         ) B ON (F.ITEM_ID LIKE B.TST OR T2.NICK_NAME LIKE B.TST)
 1117|         JOIN (
 1118|              SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL)) || '%' TST
 1119|              FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL
 1120|         ) C ON F.PROJECT_CODE LIKE C.TST
 1121|         JOIN   SCM_MGR.SCM_MST_SITE S
 1122|           ON   F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID
 1123|          AND   S.SITE_TYPE   = 'SALES'
 1124|         JOIN   SCM_MGR.SCM_MST_CITY H    ON S.CITY    = H.CITY
 1125|         JOIN   SCM_MGR.SCM_MST_COUNTRY I ON S.COUNTRY = I.COUNTRY
 1126|         LEFT   JOIN (
 1127|                         SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
 1128|                         FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B
 1129|                         JOIN   SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
 1130|                     ) TEAM
 1131|           ON   TEAM.USER_ID IN (
 1132|                    SELECT TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1)) FROM DUAL
 1133|                )
 1134|         LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
 1135|           ON   SUBSTR(F.OWNER, 1,
 1136|                       CASE WHEN INSTR(F.OWNER,',') = 0 THEN LENGTH(F.OWNER)
 1137|                            ELSE INSTR(F.OWNER,',') - 1 END) = J.USER_ID
 1138|         LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
 1139|           ON   CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID
 1140|                     ELSE F.DEPT_ID END = K.DEPT_ID   -- 20190123 KHSONG
 1141|         LEFT   JOIN (
 1142|                         SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
 1143|                         FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 1144|                         WHERE  LOOKUP_TYPE = 'CELL_TYPE'
 1145|                     ) LOOK ON LOOK.CODE = T2.CELL_TYPE
 1146|         LEFT   JOIN SCM_MGR.GT_GGET_ITEM_SINGLE_V T4
 1147|           ON   T2.DIVISION_ID = T4.DIVISION_ID
 1148|          AND   NVL(T2.FORECAST_INFO_CELL_MODEL,'') = T4.ITEM_ID
 1149|         -- [E20230720-001573] 40번사업부 AMDMO0001A모델 BIZ_TYPE/CELL_PACK_COUNT LOOKUP 적용
 1150|         LEFT   JOIN (
 1151|                         SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT
 1152|                         FROM (
 1153|                             SELECT SEGMENT2 AS MODEL
 1154|                                  , SEGMENT3 AS BIZ_TYPE
 1155|                                  , SEGMENT4 AS CELL_PACK_COUNT
 1156|                                  , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
 1157|                             FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 1158|                             WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40' AND SEGMENT1 = '40'
 1159|                         ) A WHERE MODEL_RANK = 1
 1160|                     ) LOOKA ON LOOKA.MODEL = F.ITEM_ID
 1161|         WHERE  F.DIVISION_ID = '40'
 1162|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID
 1163|                       ELSE F.SCM_SITE_ID END
 1164|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL))
 1165|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1166|           AND  ( CASE WHEN P_CUSTOMER = 'ALL' THEN P_CUSTOMER
 1167|                       ELSE F.PROJECT_CODE END
 1168|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
 1169|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL) )
 1170|           AND  ( CASE WHEN P_ITEM_TYPE = 'ALL' THEN P_ITEM_TYPE
 1171|                       ELSE T2.ITEM_TYPE END
 1172|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
 1173|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
 1174|           -- [E20230720-001573] BIZ_TYPE LOOKUP 우선 적용
 1175|           AND  ( CASE WHEN P_BIZ_TYPE = 'ALL' THEN P_BIZ_TYPE
 1176|                       WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
 1177|                       ELSE T2.FORECAST_INFO_BIZ_TYPE END
 1178|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
 1179|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
 1180|           AND  ( ( P_OWNER IS NULL OR P_OWNER = '' )
 1181|                    OR F.OWNER IN (SELECT TRIM(REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL))
 1182|                                   FROM DUAL CONNECT BY REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL) IS NOT NULL) );
 1183| 
 1184|     END IF;
 1185| 
 1186|     -----------------------------------------------------------------------
 1187|     -- [20190704 KHSONG] ITEM_ID 중복 현상 방지를 위해 재 GROUP
 1188|     -- GT_GGET_SITE_ITEM_ALL → GT_GGET_SITE_ITEM
 1189|     -----------------------------------------------------------------------
 1190|     INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM
 1191|     SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
 1192|          , MAX(CELL_MODEL)
 1193|          , MAX(BIZ_TYPE)
 1194|          , MAX(END_CUSTOMER)
 1195|          , MAX(SOLDTO_CUSTOMER)
 1196|          , MAX(COUNTRY)
 1197|          , MAX(COUNTRY_NAME)
 1198|          , MAX(CITY)
 1199|          , MAX(CITY_NAME)
 1200|          , MAX(OWNER)
 1201|          , MAX(PROJECT_OWNER)
 1202|          , MAX(USER_ID)
 1203|          , MAX(ITEM_NAME)
 1204|          , MAX(ITEM_TYPE)
 1205|          , MAX(PROJECT_STATUS)
 1206|          , MAX(CUST_GROUP)
 1207|          , MAX(CUST_GROUP_DTL)
 1208|          , MAX(APPLICATION)
 1209|          , MAX(ROUTE)
 1210|          , MAX(MDM_PROJECT_NAME)
 1211|          , MAX(MIN_CAPACITY)
 1212|          , MAX(FORECAST_INFO_BIZ_TYPE)
 1213|          , MAX(FORECAST_INFO_PRODUCT_GROUP)
 1214|          , MAX(CELL_TYPE)
 1215|          , MAX(FORECAST_INFO_CELL_PACK_COUNT)
 1216|          , MAX(FORECAST_INFO_ALL)
 1217|          , MAX(FORECAST_INFO_SPEC)
 1218|          , MAX(FORECAST_INFOR_VERSION)
 1219|          , MAX(CELL_MODEL_NICK_NAME)
 1220|          , MAX(VMI_YN)
 1221|          , MAX(DMS_SALES)
 1222|          , MAX(DMS_CUSTOMER)
 1223|          , MAX(DEPT_ID)
 1224|          , MAX(DEPT_NAME_KO)
 1225|          , MAX(CELL_PER_CAR)
 1226|          , MAX(CELL_PER_MODULE)
 1227|          , MAX(MODULE_PER_CAR)
 1228|          , MAX(ITEM_CLASS_NAME)
 1229|          , MAX(ENERGE)
 1230|          , MAX(CELL_QUANTITY)
 1231|          , MAX(ITEM_VALID_YN)
 1232|     FROM   SCM_MGR.GT_GGET_SITE_ITEM_ALL
 1233|     GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;
 1234| 
 1235|     -----------------------------------------------------------------------
 1236|     -- GT_GGET_EDI_SENDER 수집
 1237|     -----------------------------------------------------------------------
 1238|     INSERT INTO SCM_MGR.GT_GGET_EDI_SENDER ( SCM_SITE_ID, SENDER_CODE, SENDER_NAME )
 1239|     SELECT A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6
 1240|     FROM   SCM_MGR.SCM_MST_SITE A
 1241|     JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
 1242|       ON   A.END_CUSTOMER = B.SEGMENT2
 1243|      AND   A.DIVISION_ID  = B.SEGMENT1
 1244|      AND   B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER'
 1245|     GROUP  BY A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6;
 1246| 
 1247|     -----------------------------------------------------------------------
 1248|     -- GT_GGET_LAST_DATA_SETUP 수집 (최종 입력일시 및 입력자)
 1249|     -----------------------------------------------------------------------
 1250|     INSERT INTO SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1251|     ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
 1252|     , CREATE_DATE, LAST_UPDATED_BY )
 1253|     SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID
 1254|          , X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
 1255|          , MAX(X.LAST_UPDATE_DATE), MAX(X.LAST_UPDATED_BY)
 1256|     FROM (
 1257|         -- DM_PLN_MKT_FCST (계획 테이블)
 1258|         SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
 1259|              , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
 1260|              , CASE WHEN A.MEASURE IN (
 1261|                         'CUST_FCST','CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1262|                         'Commercial_Agreement','Firm_Temp','Manumacturing_Material_Temp',
 1263|                         'Material_Temp','Backorder','CUST_FCST_EDI_ORG','Immidiate[Org.]',
 1264|                         'Planning_Forecast[Org.]','Commercial_Agreement[Org.]',
 1265|                         'Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]',
 1266|                         'Material_Temp[Org.]','Backorder[Org.]')
 1267|                     THEN ( CASE WHEN MAX(A.ATTRIBUTE9) IS NULL OR NVL(MAX(A.ATTRIBUTE9),'') = ''
 1268|                                 THEN MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
 1269|                                 ELSE MAX(A.ATTRIBUTE9) END )
 1270|                     ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
 1271|                END AS LAST_UPDATE_DATE
 1272|              , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
 1273|         FROM   SCM_MGR.DM_PLN_MKT_FCST A
 1274|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE B
 1275|           ON   A.MEASURE = CASE WHEN B.MEASURE = 'CUST_FCST_ORG'         THEN 'CUST_FCST'
 1276|                                 WHEN B.MEASURE = 'Customer Fcst[Org.]'   THEN 'Customer FCST'
 1277|                                 WHEN B.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN 'MKT_FCST'
 1278|                                 WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR',
 1279|                                                    'RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
 1280|                                                THEN 'RTF'
 1281|                                 ELSE B.MEASURE END
 1282|         WHERE  A.DIVISION_ID = P_DIVISION_ID
 1283|           AND  A.YYYYMMDD   >= TO_CHAR(ADD_MONTHS(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD'),-12),'YYYYMMDD')
 1284|           AND  A.YYYYMMDD   <= P_TO_YYYYMMDD
 1285|         GROUP  BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
 1286|                , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
 1287|         UNION ALL
 1288|         -- DM_PLN_MKT_FCST_RESULT (실적 테이블)
 1289|         SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
 1290|              , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
 1291|              , CASE WHEN A.MEASURE IN (
 1292|                         'CUST_FCST','CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1293|                         'Commercial_Agreement','Firm_Temp','Manumacturing_Material_Temp',
 1294|                         'Material_Temp','Backorder','CUST_FCST_EDI_ORG','Immidiate[Org.]',
 1295|                         'Planning_Forecast[Org.]','Commercial_Agreement[Org.]',
 1296|                         'Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]',
 1297|                         'Material_Temp[Org.]','Backorder[Org.]')
 1298|                     THEN ( CASE WHEN MAX(A.ATTRIBUTE9) IS NULL OR NVL(MAX(A.ATTRIBUTE9),'') = ''
 1299|                                 THEN MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
 1300|                                 ELSE MAX(A.ATTRIBUTE9) END )
 1301|                     ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
 1302|                END AS LAST_UPDATE_DATE
 1303|              , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
 1304|         FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
 1305|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE B
 1306|           ON   A.MEASURE = CASE WHEN B.MEASURE = 'CUST_FCST_ORG'         THEN 'CUST_FCST'
 1307|                                 WHEN B.MEASURE = 'Customer Fcst[Org.]'   THEN 'Customer FCST'
 1308|                                 WHEN B.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN 'MKT_FCST'
 1309|                                 WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR',
 1310|                                                    'RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
 1311|                                                THEN 'RTF'
 1312|                                 ELSE B.MEASURE END
 1313|         WHERE  A.DIVISION_ID = P_DIVISION_ID
 1314|           AND  A.YYYYMMDD   >= TO_CHAR(ADD_MONTHS(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD'),-12),'YYYYMMDD')
 1315|           AND  A.YYYYMMDD   <= P_TO_YYYYMMDD
 1316|         GROUP  BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
 1317|                , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
 1318|     ) X
 1319|     WHERE  ( X.PROJECT_CODE IS NOT NULL OR NVL(X.PROJECT_CODE,'') <> '' )
 1320|       AND  ( X.SCM_SITE_ID IS NOT NULL OR NVL(X.SCM_SITE_ID,'')  <> '' )
 1321|       AND  ( X.ITEM_ID IS NOT NULL OR NVL(X.ITEM_ID,'')      <> '' )
 1322|     GROUP  BY X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID
 1323|            ,  X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE;
 1324| 
 1325|     -----------------------------------------------------------------------
 1326|     -- GT_GGET_EDI_END_CUST 수집 (EDI END_CUSTOMER별 기간 설정)
 1327|     -----------------------------------------------------------------------
 1328|     INSERT INTO SCM_MGR.GT_GGET_EDI_END_CUST
 1329|     ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
 1330|     SELECT A.DIVISION_ID
 1331|          , A.END_CUSTOMER
 1332|          , NVL(B.SEGMENT4, '-')
 1333|          , CASE WHEN NVL(B.SEGMENT5,'Off') = 'Off' THEN -52
 1334|                 ELSE NVL(TO_NUMBER(B.ATTRIBUTE1),-1) END
 1335|          , NVL(B.ATTRIBUTE2, 'TUE')
 1336|          , NVL(TO_NUMBER(B.ATTRIBUTE3), 0)
 1337|          , NVL(B.ATTRIBUTE4, 'MON')
 1338|          , NVL(B.SEGMENT5, 'Off')
 1339|     FROM   SCM_MGR.SCM_MST_SITE A
 1340|     LEFT   OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
 1341|       ON   B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER'
 1342|      AND   A.DIVISION_ID  = B.SEGMENT1
 1343|      AND   A.END_CUSTOMER = B.SEGMENT2
 1344|      AND   B.VALID_YN     = 'Y'
 1345|     WHERE  ( A.END_CUSTOMER IS NOT NULL OR NVL(A.END_CUSTOMER,'') <> '' )
 1346|     GROUP  BY A.DIVISION_ID, A.END_CUSTOMER
 1347|            ,  B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;
 1348| 
 1349|     -----------------------------------------------------------------------
 1350|     -- GT_GGET_RPA_END_CUST 수집 (RPA END_CUSTOMER별 기간 설정)
 1351|     -----------------------------------------------------------------------
 1352|     INSERT INTO SCM_MGR.GT_GGET_RPA_END_CUST
 1353|     ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
 1354|     SELECT A.DIVISION_ID
 1355|          , A.END_CUSTOMER
 1356|          , NVL(B.SEGMENT4, '-')
 1357|          , CASE WHEN NVL(B.SEGMENT5,'Off') = 'Off' THEN -52
 1358|                 ELSE NVL(TO_NUMBER(B.ATTRIBUTE1),-1) END
 1359|          , NVL(B.ATTRIBUTE2, 'TUE')
 1360|          , NVL(TO_NUMBER(B.ATTRIBUTE3), 0)
 1361|          , NVL(B.ATTRIBUTE4, 'MON')
 1362|          , NVL(B.SEGMENT5, 'Off')
 1363|     FROM   SCM_MGR.SCM_MST_SITE A
 1364|     LEFT   OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
 1365|       ON   B.LOOKUP_TYPE  = 'RPA_END_CUSTOMER'
 1366|      AND   A.DIVISION_ID  = B.SEGMENT1
 1367|      AND   A.END_CUSTOMER = B.SEGMENT2
 1368|      AND   B.VALID_YN     = 'Y'
 1369|     WHERE  ( A.END_CUSTOMER IS NOT NULL OR NVL(A.END_CUSTOMER,'') <> '' )
 1370|     GROUP  BY A.DIVISION_ID, A.END_CUSTOMER
 1371|            ,  B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;
 1372| 
 1373|     -----------------------------------------------------------------------
 1374|     -- CAL_MONTH_END / CAL_WEEK_END 수집 (월말일 / 주말일 목록)
 1375|     -----------------------------------------------------------------------
 1376|     INSERT INTO SCM_MGR.GT_GGET_CAL_MONTH_END ( MONTH_END_DATE )
 1377|     SELECT TO_CHAR(LAST_DAY(TO_DATE(BASIS_YYYYMM,'YYYYMM')),'YYYYMMDD') AS MONTH_END_DATE
 1378|     FROM   SCM_MGR.SCM_SYS_CALENDAR_M
 1379|     WHERE  BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
 1380|     GROUP  BY BASIS_YYYYMM;
 1381| 
 1382|     INSERT INTO SCM_MGR.GT_GGET_CAL_WEEK_END ( WEEK_END_DATE )
 1383|     SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
 1384|     FROM   SCM_MGR.SCM_SYS_CALENDAR_M
 1385|     WHERE  BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
 1386|     GROUP  BY BASIS_YYYYMM, ISO_WEEK;
 1387| 
 1388| 
 1389|     -----------------------------------------------------------------------
 1390|     -- 계획 구간 INSERT 조건:
 1391|     --   V_TO_YYYYMMDD >= 당주 월요일  →  계획구간 데이터 존재
 1392|     -- CONVERT(CHAR(8), DATEADD(DD,-7, FN_NEXT_DAY(GETDATE(),'MON')),112)
 1393|     --   → TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
 1394|     -----------------------------------------------------------------------
 1395|     IF V_TO_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD') THEN
 1396| 
 1397|         -----------------------------------------------------------------------
 1398|         -- Block 1-A : MKT_FCST 계열 (CUST_FCST_EDI/Immidiate 등 제외)
 1399|         --             AS콤보박스 제거로 T4(AS_SITE_PLANT) LEFT JOIN 추가 [E20260211-001189]
 1400|         -----------------------------------------------------------------------
 1401|         INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 1402|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 1403|         , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 1404|         , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 1405|         , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 1406|         , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 1407|         , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 1408|         , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 1409|         , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 1410|         , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 1411|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 1412|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 1413|              , F.MEASURE
 1414|              , F.YYYYMMDD
 1415|              , F.QTY
 1416|              , M.MEASURE_GROUP
 1417|              , T2.CELL_MODEL
 1418|              , T2.END_CUSTOMER
 1419|              , T2.NICK_NAME
 1420|              , T2.DMS_SALES
 1421|              , T2.DMS_CUSTOMER
 1422|              , T2.OWNER
 1423|              , T2.DEPT_ID
 1424|              , T2.DEPT_NAME_KO
 1425|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 1426|              , T2.ITEM_TYPE
 1427|              , T2.PROJECT_NAME
 1428|              , T2.PROJECT_OWNER
 1429|              , T2.BIZ_TYPE
 1430|              , T2.SOLDTO_CUSTOMER
 1431|              , T2.COUNTRY_NAME
 1432|              , T2.CITY_NAME
 1433|              , T2.PROJECT_STATUS
 1434|              , T2.ITEM_NAME
 1435|              , T2.VMI_YN
 1436|              , T2.CUST_GROUP
 1437|              , T2.CUST_GROUP_DTL
 1438|              , T2.APPLICATION
 1439|              , T2.ROUTE
 1440|              , T2.MDM_PROJECT_NAME
 1441|              , T2.MIN_CAPACITY
 1442|              , T2.FORECAST_INFO_BIZ_TYPE
 1443|              , T2.CELL_TYPE
 1444|              , T2.FORECAST_INFO_ALL
 1445|              , T2.FORECAST_INFO_SPEC
 1446|              , T2.FORECAST_INFOR_VERSION
 1447|              , T2.CELL_MODEL_NICK_NAME
 1448|              , T2.CELL_PER_CAR
 1449|              , T2.CELL_PER_MODULE
 1450|              , T2.MODULE_PER_CAR
 1451|              , M.SORT_ORDER_NO
 1452|              , T2.ENERGE
 1453|              , T2.CELL_QUANTITY
 1454|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 1455|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1456|                  WHERE  DIVISION_ID  = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1457|                    AND  SCM_SITE_ID  = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1458|                    AND  DOM_EXP      = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1459|                    AND  INCOTERMS    = F.INCOTERMS    AND MEASURE      = F.MEASURE
 1460|                    AND  QTY         <> 0 )
 1461|              , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1462|                  WHERE  DIVISION_ID  = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1463|                    AND  SCM_SITE_ID  = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1464|                    AND  DOM_EXP      = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1465|                    AND  INCOTERMS    = F.INCOTERMS    AND MEASURE      = F.MEASURE )
 1466|              , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 1467|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1468|              , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 1469|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1470|         FROM   SCM_MGR.DM_PLN_MKT_FCST F
 1471|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 1472|           ON   F.MEASURE = M.MEASURE
 1473|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 1474|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 1475|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 1476|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 1477|          AND   F.ITEM_ID      = T2.ITEM_ID
 1478|          AND   T2.ITEM_VALID_YN = 'Y'
 1479|         -- [E20260211-001189] AS콤보박스 제거 → AS_SITE_PLANT LEFT JOIN으로 AS데이터 포함
 1480|         LEFT   OUTER JOIN (
 1481|                                SELECT SEGMENT1, SEGMENT2
 1482|                                FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 1483|                                WHERE  LOOKUP_TYPE = 'AS_SITE_PLANT'
 1484|                                  AND  SEGMENT3    = P_DIVISION_ID
 1485|                            ) T4 ON NVL(F.ATTRIBUTE10,'') = T4.SEGMENT2
 1486|         WHERE  F.QTY <> 0
 1487|           AND  F.MEASURE NOT IN (
 1488|                    'CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement',
 1489|                    'Firm_Temp','Manumacturing_Material_Temp','Material_Temp','Backorder',
 1490|                    'CUST_FCST','Customer FCST' )
 1491|           AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 1492|           AND  F.DIVISION_ID = P_DIVISION_ID
 1493|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 1494|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1495|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL)
 1496|                  OR
 1497|                  CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE T4.SEGMENT1 END
 1498|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1499|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1500|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 1501|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1502|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1503| 
 1504|         -----------------------------------------------------------------------
 1505|         -- Block 1-B : CUST_FCST_EDI 계열 (EDI/RPA Sender 기반)
 1506|         --             YYYYMMDD 범위: v_to_result ~ p_to_yyyymmdd  [고객수요분석시스템 정비]
 1507|         -----------------------------------------------------------------------
 1508|         UNION ALL
 1509|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 1510|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 1511|              , F.MEASURE
 1512|              , F.YYYYMMDD
 1513|              , F.QTY
 1514|              , M.MEASURE_GROUP
 1515|              , T2.CELL_MODEL
 1516|              , T2.END_CUSTOMER
 1517|              , T2.NICK_NAME
 1518|              , T2.DMS_SALES
 1519|              , T2.DMS_CUSTOMER
 1520|              , T2.OWNER
 1521|              , T2.DEPT_ID
 1522|              , T2.DEPT_NAME_KO
 1523|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 1524|              , T2.ITEM_TYPE
 1525|              , T2.PROJECT_NAME
 1526|              , T2.PROJECT_OWNER
 1527|              , T2.BIZ_TYPE
 1528|              , T2.SOLDTO_CUSTOMER
 1529|              , T2.COUNTRY_NAME
 1530|              , T2.CITY_NAME
 1531|              , T2.PROJECT_STATUS
 1532|              , T2.ITEM_NAME
 1533|              , T2.VMI_YN
 1534|              , T2.CUST_GROUP
 1535|              , T2.CUST_GROUP_DTL
 1536|              , T2.APPLICATION
 1537|              , T2.ROUTE
 1538|              , T2.MDM_PROJECT_NAME
 1539|              , T2.MIN_CAPACITY
 1540|              , T2.FORECAST_INFO_BIZ_TYPE
 1541|              , T2.CELL_TYPE
 1542|              , T2.FORECAST_INFO_ALL
 1543|              , T2.FORECAST_INFO_SPEC
 1544|              , T2.FORECAST_INFOR_VERSION
 1545|              , T2.CELL_MODEL_NICK_NAME
 1546|              , T2.CELL_PER_CAR
 1547|              , T2.CELL_PER_MODULE
 1548|              , T2.MODULE_PER_CAR
 1549|              , M.SORT_ORDER_NO
 1550|              , T2.ENERGE
 1551|              , T2.CELL_QUANTITY
 1552|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 1553|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1554|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1555|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1556|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1557|                    AND  INCOTERMS   = F.INCOTERMS
 1558|                    AND  MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1559|                                     'Commercial_Agreement','Firm_Temp',
 1560|                                     'Manumacturing_Material_Temp','Material_Temp','Backorder') )
 1561|              , CASE WHEN ( F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' ) THEN
 1562|                    ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 1563|                      WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 ) || '_EDI'
 1564|                    ELSE F.ATTRIBUTE5 || '_' || F.LAST_UPDATED_BY END  AS LAST_UPDATED_BY
 1565|              , CASE WHEN ( F.ATTRIBUTE4 IS NULL OR NVL(F.ATTRIBUTE4,'') = '' ) THEN
 1566|                    ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 1567|                      WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1568|                    ELSE F.ATTRIBUTE4 END  AS SENDER_CODE
 1569|              , CASE WHEN ( F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' ) THEN
 1570|                    ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 1571|                      WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1572|                    ELSE F.ATTRIBUTE5 END  AS SENDER_NAME
 1573|         FROM   SCM_MGR.DM_PLN_MKT_FCST F
 1574|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 1575|           ON   F.MEASURE = M.MEASURE
 1576|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 1577|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 1578|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 1579|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 1580|          AND   F.ITEM_ID      = T2.ITEM_ID
 1581|          AND   T2.ITEM_VALID_YN = 'Y'
 1582|         LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
 1583|           ON   F.DIVISION_ID  = B.DIVISION_ID
 1584|          AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
 1585|          AND   B.SITE_TYPE    = 'SALES'
 1586|          AND   B.VALID_YN     = 'Y'
 1587|          AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 1588|                          ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
 1589|                OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 1590|                          ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
 1591|         WHERE  F.QTY <> -9999999999
 1592|           AND  F.MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1593|                              'Commercial_Agreement','Firm_Temp',
 1594|                              'Manumacturing_Material_Temp','Material_Temp','Backorder')
 1595|           -- [고객수요분석시스템 정비] EDI데이터 중복건 제거: v_to_result 이후부터만 조회
 1596|           AND  F.YYYYMMDD    BETWEEN V_TO_RESULT AND P_TO_YYYYMMDD
 1597|           AND  F.DIVISION_ID = P_DIVISION_ID
 1598|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 1599|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1600|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1601|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 1602|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1603|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1604|           AND  ( CASE WHEN ( CASE WHEN F.MEASURE IN (
 1605|                                       'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1606|                                       'Commercial_Agreement','Firm_Temp',
 1607|                                       'Manumacturing_Material_Temp','Material_Temp','Backorder')
 1608|                                   THEN P_SENDER_CODE ELSE 'ALL' END ) = 'ALL'
 1609|                       THEN ( CASE WHEN F.MEASURE IN (
 1610|                                       'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1611|                                       'Commercial_Agreement','Firm_Temp',
 1612|                                       'Manumacturing_Material_Temp','Material_Temp','Backorder')
 1613|                                   THEN P_SENDER_CODE ELSE 'ALL' END )
 1614|                       ELSE F.ATTRIBUTE4 END
 1615|                  IN ( SELECT TRIM(REGEXP_SUBSTR(
 1616|                           CASE WHEN F.MEASURE IN (
 1617|                                    'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1618|                                    'Commercial_Agreement','Firm_Temp',
 1619|                                    'Manumacturing_Material_Temp','Material_Temp','Backorder')
 1620|                                THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL))
 1621|                       FROM DUAL
 1622|                       CONNECT BY REGEXP_SUBSTR(
 1623|                           CASE WHEN F.MEASURE IN (
 1624|                                    'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1625|                                    'Commercial_Agreement','Firm_Temp',
 1626|                                    'Manumacturing_Material_Temp','Material_Temp','Backorder')
 1627|                                THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL) IS NOT NULL ) )
 1628| 
 1629|         -----------------------------------------------------------------------
 1630|         -- Block 1-C : Customer FCST (RPA/EXCEL 경로, Cust.FCST_RPA[P+P] / Cust.FCST_EXCEL[P+P] 으로 표시)
 1631|         --             [E20241126-000426] Customer FCST 전용 로직
 1632|         -----------------------------------------------------------------------
 1633|         UNION ALL
 1634|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 1635|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 1636|              , CASE WHEN F.MEASURE = 'Customer FCST' THEN
 1637|                         CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
 1638|                              THEN 'Cust.FCST_RPA[P+P]'
 1639|                              ELSE 'Cust.FCST_EXCEL[P+P]' END
 1640|                     ELSE F.MEASURE END  AS MEASURE
 1641|              , F.YYYYMMDD
 1642|              , F.QTY
 1643|              , M.MEASURE_GROUP
 1644|              , T2.CELL_MODEL
 1645|              , T2.END_CUSTOMER
 1646|              , T2.NICK_NAME
 1647|              , T2.DMS_SALES
 1648|              , T2.DMS_CUSTOMER
 1649|              , T2.OWNER
 1650|              , T2.DEPT_ID
 1651|              , T2.DEPT_NAME_KO
 1652|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 1653|              , T2.ITEM_TYPE
 1654|              , T2.PROJECT_NAME
 1655|              , T2.PROJECT_OWNER
 1656|              , T2.BIZ_TYPE
 1657|              , T2.SOLDTO_CUSTOMER
 1658|              , T2.COUNTRY_NAME
 1659|              , T2.CITY_NAME
 1660|              , T2.PROJECT_STATUS
 1661|              , T2.ITEM_NAME
 1662|              , T2.VMI_YN
 1663|              , T2.CUST_GROUP
 1664|              , T2.CUST_GROUP_DTL
 1665|              , T2.APPLICATION
 1666|              , T2.ROUTE
 1667|              , T2.MDM_PROJECT_NAME
 1668|              , T2.MIN_CAPACITY
 1669|              , T2.FORECAST_INFO_BIZ_TYPE
 1670|              , T2.CELL_TYPE
 1671|              , T2.FORECAST_INFO_ALL
 1672|              , T2.FORECAST_INFO_SPEC
 1673|              , T2.FORECAST_INFOR_VERSION
 1674|              , T2.CELL_MODEL_NICK_NAME
 1675|              , T2.CELL_PER_CAR
 1676|              , T2.CELL_PER_MODULE
 1677|              , T2.MODULE_PER_CAR
 1678|              , M.SORT_ORDER_NO
 1679|              , T2.ENERGE
 1680|              , T2.CELL_QUANTITY
 1681|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 1682|              -- [E20241126-000426] Customer FCST 전용 LAST_DATA_SETUP
 1683|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1684|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1685|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1686|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1687|                    AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'Customer FCST' )
 1688|              , CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
 1689|                     THEN F.LAST_UPDATED_BY || '_RPA'
 1690|                     ELSE F.LAST_UPDATED_BY || '_EXCEL' END  AS LAST_UPDATED_BY
 1691|              , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 1692|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1693|              , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 1694|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1695|         FROM   SCM_MGR.DM_PLN_MKT_FCST F
 1696|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 1697|           ON   F.MEASURE = M.MEASURE
 1698|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 1699|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 1700|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 1701|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 1702|          AND   F.ITEM_ID      = T2.ITEM_ID
 1703|          AND   T2.ITEM_VALID_YN = 'Y'
 1704|         LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
 1705|           ON   F.DIVISION_ID  = B.DIVISION_ID
 1706|          AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
 1707|          AND   B.SITE_TYPE    = 'SALES'
 1708|          AND   B.VALID_YN     = 'Y'
 1709|          AND   ( ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 1710|                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
 1711|                OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 1712|                     ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
 1713|         WHERE  F.QTY <> 0
 1714|           -- [E20241126-000426] Customer FCST 전용
 1715|           AND  F.MEASURE      = 'Customer FCST'
 1716|           AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 1717|           AND  F.DIVISION_ID  = P_DIVISION_ID
 1718|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 1719|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1720|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1721|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 1722|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1723|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1724| 
 1725|         -----------------------------------------------------------------------
 1726|         -- Block 1-D : CUST_FCST 전용  [E20241126-000426]
 1727|         -----------------------------------------------------------------------
 1728|         UNION ALL
 1729|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 1730|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 1731|              , F.MEASURE
 1732|              , F.YYYYMMDD
 1733|              , F.QTY
 1734|              , M.MEASURE_GROUP
 1735|              , T2.CELL_MODEL
 1736|              , T2.END_CUSTOMER
 1737|              , T2.NICK_NAME
 1738|              , T2.DMS_SALES
 1739|              , T2.DMS_CUSTOMER
 1740|              , T2.OWNER
 1741|              , T2.DEPT_ID
 1742|              , T2.DEPT_NAME_KO
 1743|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 1744|              , T2.ITEM_TYPE
 1745|              , T2.PROJECT_NAME
 1746|              , T2.PROJECT_OWNER
 1747|              , T2.BIZ_TYPE
 1748|              , T2.SOLDTO_CUSTOMER
 1749|              , T2.COUNTRY_NAME
 1750|              , T2.CITY_NAME
 1751|              , T2.PROJECT_STATUS
 1752|              , T2.ITEM_NAME
 1753|              , T2.VMI_YN
 1754|              , T2.CUST_GROUP
 1755|              , T2.CUST_GROUP_DTL
 1756|              , T2.APPLICATION
 1757|              , T2.ROUTE
 1758|              , T2.MDM_PROJECT_NAME
 1759|              , T2.MIN_CAPACITY
 1760|              , T2.FORECAST_INFO_BIZ_TYPE
 1761|              , T2.CELL_TYPE
 1762|              , T2.FORECAST_INFO_ALL
 1763|              , T2.FORECAST_INFO_SPEC
 1764|              , T2.FORECAST_INFOR_VERSION
 1765|              , T2.CELL_MODEL_NICK_NAME
 1766|              , T2.CELL_PER_CAR
 1767|              , T2.CELL_PER_MODULE
 1768|              , T2.MODULE_PER_CAR
 1769|              , M.SORT_ORDER_NO
 1770|              , T2.ENERGE
 1771|              , T2.CELL_QUANTITY
 1772|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 1773|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1774|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1775|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1776|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1777|                    AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'CUST_FCST' )
 1778|              , F.LAST_UPDATED_BY
 1779|              , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 1780|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1781|              , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 1782|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1783|         FROM   SCM_MGR.DM_PLN_MKT_FCST F
 1784|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 1785|           ON   F.MEASURE = M.MEASURE
 1786|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 1787|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 1788|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 1789|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 1790|          AND   F.ITEM_ID      = T2.ITEM_ID
 1791|          AND   T2.ITEM_VALID_YN = 'Y'
 1792|         LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
 1793|           ON   F.DIVISION_ID  = B.DIVISION_ID
 1794|          AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
 1795|          AND   B.SITE_TYPE    = 'SALES'
 1796|          AND   B.VALID_YN     = 'Y'
 1797|          AND  ( ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 1798|                         ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
 1799|                 OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 1800|                           ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
 1801|         WHERE  F.QTY <> 0
 1802|           AND  F.MEASURE      = 'CUST_FCST'
 1803|           AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 1804|           AND  F.DIVISION_ID  = P_DIVISION_ID
 1805|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 1806|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1807|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1808|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 1809|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1810|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 1811| 
 1812|         -----------------------------------------------------------------------
 1813|         -- Block 2 : MKT_FCST_RP / MKT_FCST_RP_CAR / MKT_FCST_RP_CELL
 1814|         --           (Cell/Car/Module 환산 포함)
 1815|         -----------------------------------------------------------------------
 1816|         DECLARE
 1817|             V_RP_CNT PLS_INTEGER := 0;
 1818|         BEGIN
 1819|             SELECT COUNT(1) INTO V_RP_CNT
 1820|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 1821|             WHERE  MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL');
 1822| 
 1823|             IF V_RP_CNT > 0 THEN
 1824|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 1825|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 1826|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 1827|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 1828|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 1829|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 1830|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 1831|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 1832|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 1833|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 1834|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 1835|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 1836|                      , CASE WHEN M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
 1837|                             THEN M.MEASURE ELSE F.MEASURE END  AS MEASURE
 1838|                      , F.YYYYMMDD
 1839|                      , CASE
 1840|                            WHEN M.MEASURE = 'MKT_FCST_RP' THEN F.QTY
 1841|                            WHEN M.MEASURE = 'MKT_FCST_RP_CAR' THEN
 1842|                                CASE
 1843|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell') > 0   AND NVL(T2.CELL_PER_CAR,0) > 0
 1844|                                         THEN F.QTY / T2.CELL_PER_CAR
 1845|                                    -- [C20200212-000304] Module: QTY / MODULE_PER_CAR
 1846|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0) > 0
 1847|                                     AND NVL(T2.CELL_PER_MODULE,0) > 0
 1848|                                         THEN F.QTY / T2.MODULE_PER_CAR
 1849|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack') > 0   THEN F.QTY
 1850|                                    ELSE 0
 1851|                                END
 1852|                            WHEN M.MEASURE = 'MKT_FCST_RP_CELL' AND F.DIVISION_ID LIKE '81%' THEN
 1853|                                CASE
 1854|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
 1855|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
 1856|                                    -- [C20200511-000360] Pack → CELL_PER_CAR 곱
 1857|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
 1858|                                    ELSE 0
 1859|                                END
 1860|                            -- [C20200114-000201] ESS(82): CELL_QUANTITY 곱
 1861|                            WHEN M.MEASURE = 'MKT_FCST_RP_CELL' AND F.DIVISION_ID = '82' THEN
 1862|                                F.QTY * T2.CELL_QUANTITY
 1863|                        END  AS QTY
 1864|                      , M.MEASURE_GROUP
 1865|                      , T2.CELL_MODEL
 1866|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 1867|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 1868|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 1869|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 1870|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 1871|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 1872|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 1873|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 1874|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 1875|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 1876|                      , T2.CELL_MODEL_NICK_NAME
 1877|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 1878|                      , M.SORT_ORDER_NO
 1879|                      , T2.ENERGE, T2.CELL_QUANTITY
 1880|                      , F.ATTRIBUTE10  AS AS_FROM_SITE
 1881|                      , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1882|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1883|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1884|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1885|                            AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST' )
 1886|                      , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1887|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1888|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1889|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1890|                            AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST'
 1891|                            AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1892|                                                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1893|                                                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1894|                                                   AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
 1895|                                                   AND  INCOTERMS   = F.INCOTERMS   AND MEASURE       = 'MKT_FCST' ) )
 1896|                      , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 1897|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1898|                      , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 1899|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1900|                 FROM   SCM_MGR.DM_PLN_MKT_FCST F
 1901|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 1902|                   ON   F.MEASURE = 'MKT_FCST'
 1903|                  AND   M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
 1904|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 1905|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 1906|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 1907|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 1908|                  AND   F.ITEM_ID      = T2.ITEM_ID
 1909|                  AND   T2.ITEM_VALID_YN = 'Y'
 1910|                 WHERE  F.MEASURE = CASE WHEN M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
 1911|                                         THEN 'MKT_FCST' ELSE M.MEASURE END
 1912|                   AND  F.QTY <> 0
 1913|                   AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 1914|                   AND  F.DIVISION_ID = P_DIVISION_ID
 1915|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 1916|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1917|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1918|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 1919|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1920|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 1921|             END IF;  -- Block 2 END
 1922|         END;
 1923| 
 1924|         -----------------------------------------------------------------------
 1925|         -- Block 3 : RTF_RP_CAR / RTF_SYS_RP_CAR / RTF_RP_CELL / RTF_SYS_RP_CELL / RTF_ENERGY
 1926|         --           [CSR ID:4023158] 20190705 KHSONG
 1927|         --           [C20211103-000146] 20211119 RTF_ENERGY 추가
 1928|         -----------------------------------------------------------------------
 1929|         DECLARE
 1930|             V_RTF_CNT PLS_INTEGER := 0;
 1931|         BEGIN
 1932|             SELECT COUNT(1) INTO V_RTF_CNT
 1933|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 1934|             WHERE  MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY');
 1935| 
 1936|             IF V_RTF_CNT > 0 THEN
 1937|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 1938|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 1939|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 1940|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 1941|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 1942|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 1943|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 1944|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 1945|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 1946|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 1947|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 1948|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 1949|                      -- Measure명 결정
 1950|                      , CASE
 1951|                            WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
 1952|                                CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CAR'
 1953|                                     WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CAR'
 1954|                                     ELSE '' END
 1955|                            WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
 1956|                                CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CELL'
 1957|                                     WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CELL'
 1958|                                     ELSE '' END
 1959|                            WHEN M.MEASURE = 'RTF_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_ENERGY'
 1960|                        END  AS MEASURE
 1961|                      , F.YYYYMMDD
 1962|                      -- QTY 환산
 1963|                      , CASE
 1964|                            WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
 1965|                                CASE
 1966|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0) > 0
 1967|                                         THEN F.QTY / T2.CELL_PER_CAR
 1968|                                    -- [C20200212-000304] Module → MODULE_PER_CAR
 1969|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0
 1970|                                     AND NVL(T2.CELL_PER_CAR,0) > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0
 1971|                                         THEN F.QTY / T2.MODULE_PER_CAR
 1972|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 THEN F.QTY
 1973|                                    ELSE 0
 1974|                                END
 1975|                            WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') AND F.DIVISION_ID LIKE '81%' THEN
 1976|                                CASE
 1977|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
 1978|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
 1979|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
 1980|                                    ELSE 0
 1981|                                END
 1982|                            -- [C20200114-000201] ESS(82) RTF_RP_CELL: CELL_QUANTITY 곱
 1983|                            WHEN M.MEASURE = 'RTF_RP_CELL' AND F.DIVISION_ID = '82' THEN
 1984|                                F.QTY * T2.CELL_QUANTITY
 1985|                            -- [C20211103-000146] RTF_ENERGY: ENERGE * QTY / 1000
 1986|                            WHEN M.MEASURE = 'RTF_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN
 1987|                                CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
 1988|                                     THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
 1989|                                END
 1990|                        END  AS QTY
 1991|                      , M.MEASURE_GROUP
 1992|                      , T2.CELL_MODEL
 1993|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 1994|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 1995|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 1996|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 1997|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 1998|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 1999|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2000|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2001|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2002|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2003|                      , T2.CELL_MODEL_NICK_NAME
 2004|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2005|                      , M.SORT_ORDER_NO
 2006|                      , T2.ENERGE, T2.CELL_QUANTITY
 2007|                      , F.ATTRIBUTE10  AS AS_FROM_SITE
 2008|                      , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2009|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2010|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2011|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2012|                            AND  INCOTERMS   = F.INCOTERMS
 2013|                            AND  MEASURE    IN ('RTF','RTF_SYS_RP') )
 2014|                      , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2015|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2016|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2017|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2018|                            AND  INCOTERMS   = F.INCOTERMS
 2019|                            AND  MEASURE    IN ('RTF','RTF_SYS_RP')
 2020|                            AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2021|                                                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2022|                                                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2023|                                                   AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
 2024|                                                   AND  INCOTERMS   = F.INCOTERMS
 2025|                                                   AND  MEASURE    IN ('RTF','RTF_SYS_RP') ) )
 2026|                      , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2027|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2028|                      , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2029|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2030|                 FROM   SCM_MGR.DM_PLN_MKT_FCST F
 2031|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2032|                   ON   F.MEASURE IN ('RTF','RTF_SYS_RP')
 2033|                  AND   M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
 2034|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2035|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 2036|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2037|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2038|                  AND   F.ITEM_ID      = T2.ITEM_ID
 2039|                  AND   T2.ITEM_VALID_YN = 'Y'
 2040|                 WHERE  F.MEASURE = CASE
 2041|                                        WHEN M.MEASURE IN ('RTF_RP_CAR', 'RTF_RP_CELL')                    THEN 'RTF'
 2042|                                        WHEN M.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL','RTF_ENERGY') THEN 'RTF_SYS_RP'
 2043|                                        ELSE M.MEASURE END
 2044|                   AND  F.QTY <> 0
 2045|                   AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 2046|                   AND  F.DIVISION_ID = P_DIVISION_ID
 2047|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2048|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2049|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2050|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2051|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2052|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2053|             END IF;  -- Block 3 END
 2054|         END;
 2055| 
 2056| 
 2057|         -----------------------------------------------------------------------
 2058|         -- Block 4 : MKT_FCST_ENERGY  [C20221207-000080] 20221214 rosia27
 2059|         --           소스: GT_GGET_MKT_FCST_DATA 에 이미 들어간 MKT_FCST_RP 행에서 파생
 2060|         --           (원본: #TempMktFcstData JOIN #TempSiteItem)
 2061|         -----------------------------------------------------------------------
 2062|         DECLARE
 2063|             V_ENERGY_CNT PLS_INTEGER := 0;
 2064|         BEGIN
 2065|             SELECT COUNT(1) INTO V_ENERGY_CNT
 2066|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 2067|             WHERE  MEASURE = 'MKT_FCST_ENERGY';
 2068| 
 2069|             IF V_ENERGY_CNT > 0 THEN
 2070|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 2071|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2072|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 2073|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 2074|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 2075|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 2076|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2077|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 2078|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2079|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2080|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2081|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2082|                      , CASE WHEN M.MEASURE = 'MKT_FCST_ENERGY' AND F.MEASURE = 'MKT_FCST_RP'
 2083|                             THEN 'MKT_FCST_ENERGY' END  AS MEASURE
 2084|                      , F.YYYYMMDD
 2085|                      , CASE WHEN M.MEASURE = 'MKT_FCST_ENERGY' THEN
 2086|                                CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
 2087|                                     THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
 2088|                                END
 2089|                             ELSE 0 END  AS QTY
 2090|                      , M.MEASURE_GROUP
 2091|                      , T2.CELL_MODEL
 2092|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2093|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2094|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 2095|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2096|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2097|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2098|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2099|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2100|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2101|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2102|                      , T2.CELL_MODEL_NICK_NAME
 2103|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2104|                      , M.SORT_ORDER_NO
 2105|                      , T2.ENERGE, T2.CELL_QUANTITY
 2106|                      -- MKT_FCST_ENERGY는 GT_GGET_MKT_FCST_DATA의 MKT_FCST_RP 행에서 파생
 2107|                      -- CREATE_DATE / LAST_UPDATED_BY / SENDER_* 는 원본 F 행 값 그대로 사용
 2108|                      , F.AS_FROM_SITE
 2109|                      , F.CREATE_DATE
 2110|                      , F.LAST_UPDATED_BY
 2111|                      , F.SENDER_CODE
 2112|                      , F.SENDER_NAME
 2113|                 FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA F   -- 이미 삽입된 MKT_FCST_RP 행을 소스로 사용
 2114|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2115|                   ON   F.MEASURE = 'MKT_FCST_RP'
 2116|                  AND   M.MEASURE = 'MKT_FCST_ENERGY'
 2117|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2118|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 2119|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2120|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2121|                  AND   F.ITEM_ID      = T2.ITEM_ID
 2122|                  AND   T2.ITEM_VALID_YN = 'Y'
 2123|                 WHERE  F.QTY <> 0
 2124|                   AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 2125|                   AND  F.DIVISION_ID = P_DIVISION_ID
 2126|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2127|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2128|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2129|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2130|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2131|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2132|             END IF;  -- Block 4 END
 2133|         END;
 2134| 
 2135|     END IF;  -- 계획 구간 조건 END (V_TO_YYYYMMDD >= 당주 월요일)
 2136| 
 2137| 
 2138|     -----------------------------------------------------------------------
 2139|     -- 실적 구간 INSERT 조건:
 2140|     --   V_FROM_YYYYMMDD <= 당주 월요일
 2141|     -- CONVERT(CHAR(8), DATEADD(DD,-7, FN_NEXT_DAY(GETDATE(),'MON')),112)
 2142|     --   → TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
 2143|     -----------------------------------------------------------------------
 2144|     IF V_FROM_YYYYMMDD <= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD') THEN
 2145| 
 2146|         -----------------------------------------------------------------------
 2147|         -- [PJ2025-50188] GT_GGET_MKT_FCST_RESULT 생성
 2148|         --   DM_PLN_MKT_FCST_RESULT에 CELL_PROD_SITE_ID 컬럼이 추가되어
 2149|         --   DUP 방지를 위해 CELL_PROD_SITE_ID 제거 후 GROUP BY로 집계
 2150|         -----------------------------------------------------------------------
 2151|         INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_RESULT
 2152|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2153|         , MEASURE, PLANT_SITE_ID, YYYYMMDD
 2154|         , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
 2155|         , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
 2156|         , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
 2157|         , QTY )
 2158|         SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2159|              , MEASURE, PLANT_SITE_ID, YYYYMMDD
 2160|              , MAX(CREATED_BY)        AS CREATED_BY
 2161|              , MAX(CREATION_DATE)     AS CREATION_DATE
 2162|              , MAX(LAST_UPDATED_BY)   AS LAST_UPDATED_BY
 2163|              , MAX(LAST_UPDATE_DATE)  AS LAST_UPDATE_DATE
 2164|              , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
 2165|              , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
 2166|              , SUM(QTY)               AS QTY
 2167|         FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT
 2168|         WHERE  DIVISION_ID  = P_DIVISION_ID
 2169|           AND  YYYYMMDD    >= P_FROM_YYYYMMDD
 2170|           AND  YYYYMMDD     < V_TO_RESULT
 2171|         GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2172|                ,  MEASURE, PLANT_SITE_ID, YYYYMMDD
 2173|                ,  ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
 2174|                ,  ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10;
 2175| 
 2176|         -----------------------------------------------------------------------
 2177|         -- Block R-1 ~ R-4: 단일 INSERT … UNION ALL
 2178|         --   소스: GT_GGET_MKT_FCST_RESULT (= 집계된 실적 테이블)
 2179|         -----------------------------------------------------------------------
 2180|         INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 2181|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2182|         , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 2183|         , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 2184|         , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 2185|         , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 2186|         , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2187|         , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 2188|         , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2189|         , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2190| 
 2191|         -----------------------------------------------------------------------
 2192|         -- R-1: MKT_FCST 계열 (CUST_FCST_EDI 계열 및 CUST_FCST/Customer FCST 제외)
 2193|         -----------------------------------------------------------------------
 2194|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2195|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2196|              , F.MEASURE
 2197|              , F.YYYYMMDD, F.QTY
 2198|              , M.MEASURE_GROUP
 2199|              , T2.CELL_MODEL
 2200|              , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2201|              , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2202|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 2203|              , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2204|              , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2205|              , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2206|              , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2207|              , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2208|              , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2209|              , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2210|              , T2.CELL_MODEL_NICK_NAME
 2211|              , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2212|              , M.SORT_ORDER_NO
 2213|              , T2.ENERGE, T2.CELL_QUANTITY
 2214|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 2215|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2216|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2217|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2218|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2219|                    AND  INCOTERMS   = F.INCOTERMS
 2220|                    AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END )
 2221|              , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2222|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2223|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2224|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2225|                    AND  INCOTERMS   = F.INCOTERMS
 2226|                    AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END
 2227|                    AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2228|                                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2229|                                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2230|                                           AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
 2231|                                           AND  INCOTERMS   = F.INCOTERMS
 2232|                                           AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END ) )
 2233|              , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2234|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2235|              , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2236|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2237|         FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2238|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2239|           ON   F.MEASURE = M.MEASURE
 2240|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2241|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 2242|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2243|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2244|          AND   F.ITEM_ID      = T2.ITEM_ID
 2245|         WHERE  F.QTY <> 0
 2246|           AND  F.MEASURE NOT IN (
 2247|                    'CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement',
 2248|                    'Firm_Temp','Manumacturing_Material_Temp','Material_Temp','Backorder',
 2249|                    'CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]',
 2250|                    'Commercial_Agreement[Org.]','Firm_Temp[Org.]',
 2251|                    'Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]',
 2252|                    'CUST_FCST','Customer FCST' )
 2253|           AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2254|           AND  F.YYYYMMDD     < V_TO_RESULT
 2255|           AND  F.DIVISION_ID  = P_DIVISION_ID
 2256|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2257|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2258|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2259|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2260|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2261|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2262| 
 2263|         -----------------------------------------------------------------------
 2264|         -- R-2: CUST_FCST_EDI 계열 (EDI Sender 포함)
 2265|         -----------------------------------------------------------------------
 2266|         UNION ALL
 2267|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2268|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2269|              , F.MEASURE
 2270|              , F.YYYYMMDD, F.QTY
 2271|              , M.MEASURE_GROUP
 2272|              , T2.CELL_MODEL
 2273|              , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2274|              , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2275|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 2276|              , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2277|              , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2278|              , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2279|              , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2280|              , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2281|              , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2282|              , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2283|              , T2.CELL_MODEL_NICK_NAME
 2284|              , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2285|              , M.SORT_ORDER_NO
 2286|              , T2.ENERGE, T2.CELL_QUANTITY
 2287|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 2288|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2289|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2290|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2291|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2292|                    AND  INCOTERMS   = F.INCOTERMS
 2293|                    AND  MEASURE    IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
 2294|                                        'Commercial_Agreement','Firm_Temp',
 2295|                                        'Manumacturing_Material_Temp','Material_Temp','Backorder') )
 2296|              , CASE WHEN F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' THEN
 2297|                    ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2298|                      WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 ) || '_EDI'
 2299|                    ELSE F.ATTRIBUTE5 || '_' || F.LAST_UPDATED_BY END  AS LAST_UPDATED_BY
 2300|              , CASE WHEN F.ATTRIBUTE4 IS NULL OR NVL(F.ATTRIBUTE4,'') = '' THEN
 2301|                    ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2302|                      WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2303|                    ELSE F.ATTRIBUTE4 END  AS SENDER_CODE
 2304|              , CASE WHEN F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' THEN
 2305|                    ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2306|                      WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2307|                    ELSE F.ATTRIBUTE5 END  AS SENDER_NAME
 2308|         FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2309|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2310|           ON   F.MEASURE = M.MEASURE
 2311|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2312|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 2313|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2314|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2315|          AND   F.ITEM_ID      = T2.ITEM_ID
 2316|         LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
 2317|           ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
 2318|          AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
 2319|          AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 2320|                     ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
 2321|                OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 2322|                       ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
 2323|         WHERE  F.QTY <> -9999999999
 2324|           AND  F.MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
 2325|                              'Commercial_Agreement','Firm_Temp',
 2326|                              'Manumacturing_Material_Temp','Material_Temp','Backorder')
 2327|           -- [E20241126-000426] EDI 기간 필터 주석처리(배치에서 정리) → 단순 날짜 범위만 적용
 2328|           AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2329|           AND  F.YYYYMMDD     < V_TO_RESULT
 2330|           AND  F.DIVISION_ID  = P_DIVISION_ID
 2331|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2332|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2333|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2334|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2335|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2336|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2337|           AND  ( CASE WHEN ( CASE WHEN F.MEASURE IN (
 2338|                                       'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 2339|                                       'Commercial_Agreement','Firm_Temp',
 2340|                                       'Manumacturing_Material_Temp','Material_Temp','Backorder')
 2341|                                   THEN P_SENDER_CODE ELSE 'ALL' END ) = 'ALL'
 2342|                       THEN ( CASE WHEN F.MEASURE IN (
 2343|                                       'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 2344|                                       'Commercial_Agreement','Firm_Temp',
 2345|                                       'Manumacturing_Material_Temp','Material_Temp','Backorder')
 2346|                                   THEN P_SENDER_CODE ELSE 'ALL' END )
 2347|                       ELSE F.ATTRIBUTE4 END
 2348|                  IN ( SELECT TRIM(REGEXP_SUBSTR(
 2349|                           CASE WHEN F.MEASURE IN (
 2350|                                    'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 2351|                                    'Commercial_Agreement','Firm_Temp',
 2352|                                    'Manumacturing_Material_Temp','Material_Temp','Backorder')
 2353|                                THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL))
 2354|                       FROM DUAL
 2355|                       CONNECT BY REGEXP_SUBSTR(
 2356|                           CASE WHEN F.MEASURE IN (
 2357|                                    'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 2358|                                    'Commercial_Agreement','Firm_Temp',
 2359|                                    'Manumacturing_Material_Temp','Material_Temp','Backorder')
 2360|                                THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL) IS NOT NULL ) )
 2361| 
 2362|         -----------------------------------------------------------------------
 2363|         -- R-3: Customer FCST (RPA/EXCEL → Cust.FCST_RPA/EXCEL[P+P])
 2364|         --      [E20241126-000426] Customer FCST 전용; LAST_UPDATED_BY는 CREATED_BY 기반
 2365|         -----------------------------------------------------------------------
 2366|         UNION ALL
 2367|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2368|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2369|              , CASE WHEN F.MEASURE = 'Customer FCST' THEN
 2370|                         CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
 2371|                              THEN 'Cust.FCST_RPA[P+P]'
 2372|                              ELSE 'Cust.FCST_EXCEL[P+P]' END
 2373|                     ELSE F.MEASURE END  AS MEASURE
 2374|              , F.YYYYMMDD, F.QTY
 2375|              , M.MEASURE_GROUP
 2376|              , T2.CELL_MODEL
 2377|              , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2378|              , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2379|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 2380|              , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2381|              , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2382|              , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2383|              , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2384|              , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2385|              , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2386|              , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2387|              , T2.CELL_MODEL_NICK_NAME
 2388|              , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2389|              , M.SORT_ORDER_NO
 2390|              , T2.ENERGE, T2.CELL_QUANTITY
 2391|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 2392|              -- [E20241126-000426] Customer FCST 전용 CREATE_DATE
 2393|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2394|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2395|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2396|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2397|                    AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'Customer FCST' )
 2398|              -- [PJ2025-50188] 실적은 CREATED_BY 기반으로 _RPA/_EXCEL 결정
 2399|              , CASE WHEN F.CREATED_BY LIKE '%robot'
 2400|                     THEN F.CREATED_BY || '_RPA'
 2401|                     ELSE F.CREATED_BY || '_EXCEL' END  AS LAST_UPDATED_BY
 2402|              , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2403|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2404|              , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2405|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2406|         FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2407|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2408|           ON   F.MEASURE = M.MEASURE
 2409|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2410|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 2411|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2412|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2413|          AND   F.ITEM_ID      = T2.ITEM_ID
 2414|         LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
 2415|           ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
 2416|          AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
 2417|          AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 2418|                     ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
 2419|                OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 2420|                       ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
 2421|         WHERE  F.QTY <> 0
 2422|           -- [E20241126-000426] Customer FCST 전용
 2423|           AND  F.MEASURE      = 'Customer FCST'
 2424|           -- [E20241126-000426] 날짜 필터 단순화(배치에서 RPA 기간 정리)
 2425|           AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2426|           AND  F.YYYYMMDD     < V_TO_RESULT
 2427|           AND  F.DIVISION_ID  = P_DIVISION_ID
 2428|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2429|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2430|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2431|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2432|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2433|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2434| 
 2435|         -----------------------------------------------------------------------
 2436|         -- R-4: CUST_FCST 전용  [E20241126-000426]
 2437|         -----------------------------------------------------------------------
 2438|         UNION ALL
 2439|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2440|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2441|              , F.MEASURE
 2442|              , F.YYYYMMDD, F.QTY
 2443|              , M.MEASURE_GROUP
 2444|              , T2.CELL_MODEL
 2445|              , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2446|              , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2447|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 2448|              , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2449|              , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2450|              , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2451|              , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2452|              , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2453|              , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2454|              , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2455|              , T2.CELL_MODEL_NICK_NAME
 2456|              , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2457|              , M.SORT_ORDER_NO
 2458|              , T2.ENERGE, T2.CELL_QUANTITY
 2459|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 2460|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2461|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2462|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2463|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2464|                    AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'CUST_FCST' )
 2465|              , F.LAST_UPDATED_BY
 2466|              , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2467|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2468|              , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2469|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2470|         FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2471|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2472|           ON   F.MEASURE = M.MEASURE
 2473|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2474|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 2475|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2476|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2477|          AND   F.ITEM_ID      = T2.ITEM_ID
 2478|         LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
 2479|           ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
 2480|          AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
 2481|          AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 2482|                     ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
 2483|                OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 2484|                       ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
 2485|         WHERE  F.QTY <> 0
 2486|           AND  F.MEASURE      = 'CUST_FCST'
 2487|           AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2488|           AND  F.YYYYMMDD     < V_TO_RESULT
 2489|           AND  F.DIVISION_ID  = P_DIVISION_ID
 2490|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2491|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2492|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2493|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2494|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2495|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2496| 
 2497|         -----------------------------------------------------------------------
 2498|         -- Block R-5 : MKT_FCST_RP_CAR / MKT_FCST_RP_CELL
 2499|         --   소스: GT_GGET_MKT_FCST_RESULT (RTF → 실적 기준)
 2500|         --   20190722 KHSONG: MKT_FCST_RESULT에서 RTF 컬럼이 실적값
 2501|         -----------------------------------------------------------------------
 2502|         DECLARE
 2503|             V_RP_RESULT_CNT PLS_INTEGER := 0;
 2504|         BEGIN
 2505|             SELECT COUNT(1) INTO V_RP_RESULT_CNT
 2506|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 2507|             WHERE  MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL');
 2508| 
 2509|             IF V_RP_RESULT_CNT > 0 THEN
 2510|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 2511|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2512|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 2513|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 2514|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 2515|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 2516|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2517|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 2518|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2519|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2520|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2521|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2522|                      , CASE WHEN M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
 2523|                             THEN M.MEASURE ELSE F.MEASURE END  AS MEASURE
 2524|                      , F.YYYYMMDD
 2525|                      , CASE
 2526|                            WHEN M.MEASURE = 'MKT_FCST_RP_CAR' THEN
 2527|                                CASE
 2528|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY / T2.CELL_PER_CAR
 2529|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0
 2530|                                     AND NVL(T2.CELL_PER_MODULE,0) > 0                                             THEN F.QTY / T2.MODULE_PER_CAR
 2531|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0                                    THEN F.QTY
 2532|                                    ELSE 0
 2533|                                END
 2534|                            WHEN M.MEASURE = 'MKT_FCST_RP_CELL' THEN
 2535|                                CASE
 2536|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
 2537|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
 2538|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
 2539|                                    ELSE 0
 2540|                                END
 2541|                        END  AS QTY
 2542|                      , M.MEASURE_GROUP
 2543|                      , T2.CELL_MODEL
 2544|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2545|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2546|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 2547|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2548|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2549|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2550|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2551|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2552|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2553|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2554|                      , T2.CELL_MODEL_NICK_NAME
 2555|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2556|                      , M.SORT_ORDER_NO
 2557|                      , T2.ENERGE, T2.CELL_QUANTITY
 2558|                      , F.ATTRIBUTE10  AS AS_FROM_SITE
 2559|                      , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2560|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2561|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2562|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2563|                            AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST' )
 2564|                      , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2565|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2566|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2567|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2568|                            AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST'
 2569|                            AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2570|                                                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2571|                                                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2572|                                                   AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
 2573|                                                   AND  INCOTERMS   = F.INCOTERMS   AND MEASURE       = 'MKT_FCST' ) )
 2574|                      , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2575|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2576|                      , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2577|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2578|                 FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2579|                 -- 실적에서 RTF는 MKT_FCST_RP_CAR/CELL 환산 소스 (20190722 KHSONG)
 2580|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2581|                   ON   F.MEASURE = 'RTF'
 2582|                  AND   M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
 2583|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2584|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 2585|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2586|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2587|                  AND   F.ITEM_ID      = T2.ITEM_ID
 2588|                 WHERE  F.MEASURE = CASE WHEN M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
 2589|                                         THEN 'RTF' ELSE M.MEASURE END
 2590|                   AND  F.QTY <> 0
 2591|                   AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2592|                   AND  F.YYYYMMDD     < V_TO_RESULT
 2593|                   AND  F.DIVISION_ID  = P_DIVISION_ID
 2594|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2595|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2596|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2597|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2598|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2599|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2600|             END IF;  -- R-5 END
 2601|         END;
 2602| 
 2603|         -----------------------------------------------------------------------
 2604|         -- Block R-6: RTF_RP_CAR/CELL/ENERGY + MKT_FCST_ENERGY
 2605|         --   소스: GT_GGET_MKT_FCST_RESULT (RTF/RTF_SYS_RP)
 2606|         --   [CSR ID:4023158] + [C20211103-000146] + [C20221207-000080]
 2607|         -----------------------------------------------------------------------
 2608|         DECLARE
 2609|             V_RTF_RESULT_CNT PLS_INTEGER := 0;
 2610|         BEGIN
 2611|             SELECT COUNT(1) INTO V_RTF_RESULT_CNT
 2612|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 2613|             WHERE  MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL',
 2614|                                'RTF_ENERGY','MKT_FCST_ENERGY');
 2615| 
 2616|             IF V_RTF_RESULT_CNT > 0 THEN
 2617|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 2618|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2619|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 2620|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 2621|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 2622|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 2623|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2624|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 2625|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2626|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2627|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2628|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2629|                      , CASE
 2630|                            WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
 2631|                                CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CAR'
 2632|                                     WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CAR'
 2633|                                     ELSE '' END
 2634|                            WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
 2635|                                CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CELL'
 2636|                                     WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CELL'
 2637|                                     ELSE '' END
 2638|                            WHEN M.MEASURE = 'RTF_ENERGY'      AND F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_ENERGY'
 2639|                            WHEN M.MEASURE = 'MKT_FCST_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN 'MKT_FCST_ENERGY'
 2640|                        END  AS MEASURE
 2641|                      , F.YYYYMMDD
 2642|                      , CASE
 2643|                            WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
 2644|                                CASE
 2645|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY / T2.CELL_PER_CAR
 2646|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0
 2647|                                     AND NVL(T2.CELL_PER_MODULE,0) > 0                                             THEN F.QTY / T2.MODULE_PER_CAR
 2648|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0                                    THEN F.QTY
 2649|                                    ELSE 0
 2650|                                END
 2651|                            WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
 2652|                                CASE
 2653|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
 2654|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
 2655|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
 2656|                                    ELSE 0
 2657|                                END
 2658|                            -- [C20211103-000146] RTF_ENERGY
 2659|                            WHEN M.MEASURE = 'RTF_ENERGY' THEN
 2660|                                CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
 2661|                                     THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
 2662|                                END
 2663|                            -- [C20221207-000080] MKT_FCST_ENERGY
 2664|                            WHEN M.MEASURE = 'MKT_FCST_ENERGY' THEN
 2665|                                CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
 2666|                                     THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
 2667|                                END
 2668|                        END  AS QTY
 2669|                      , M.MEASURE_GROUP
 2670|                      , T2.CELL_MODEL
 2671|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2672|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2673|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 2674|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2675|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2676|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2677|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2678|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2679|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2680|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2681|                      , T2.CELL_MODEL_NICK_NAME
 2682|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2683|                      , M.SORT_ORDER_NO
 2684|                      , T2.ENERGE, T2.CELL_QUANTITY
 2685|                      , F.ATTRIBUTE10  AS AS_FROM_SITE
 2686|                      , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2687|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2688|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2689|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2690|                            AND  INCOTERMS   = F.INCOTERMS
 2691|                            AND  MEASURE    IN ('RTF','RTF_SYS_RP') )
 2692|                      , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2693|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2694|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2695|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2696|                            AND  INCOTERMS   = F.INCOTERMS    AND MEASURE     IN ('RTF','RTF_SYS_RP')
 2697|                            AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2698|                                                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2699|                                                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2700|                                                   AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
 2701|                                                   AND  INCOTERMS   = F.INCOTERMS
 2702|                                                   AND  MEASURE    IN ('RTF','RTF_SYS_RP') ) )
 2703|                      , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2704|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2705|                      , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2706|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2707|                 FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2708|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2709|                   ON   F.MEASURE IN ('RTF','RTF_SYS_RP')
 2710|                  AND   M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL',
 2711|                                      'RTF_ENERGY','MKT_FCST_ENERGY')
 2712|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2713|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 2714|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2715|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2716|                  AND   F.ITEM_ID      = T2.ITEM_ID
 2717|                 WHERE  F.MEASURE = CASE
 2718|                                        WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_RP_CELL')                        THEN 'RTF'
 2719|                                        WHEN M.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL',
 2720|                                                           'RTF_ENERGY','MKT_FCST_ENERGY')                   THEN 'RTF_SYS_RP'
 2721|                                        ELSE M.MEASURE END
 2722|                   AND  F.QTY <> 0
 2723|                   AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2724|                   AND  F.YYYYMMDD     < V_TO_RESULT
 2725|                   AND  F.DIVISION_ID  = P_DIVISION_ID
 2726|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2727|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2728|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2729|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2730|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2731|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2732|             END IF;  -- R-6 END
 2733|         END;
 2734| 
 2735|         -----------------------------------------------------------------------
 2736|         -- Block R-7: MKT_FCST_RP
 2737|         --   소스: GT_GGET_MKT_FCST_RESULT (RTF → MKT_FCST_RP 표시)
 2738|         -----------------------------------------------------------------------
 2739|         DECLARE
 2740|             V_MFTRP_CNT PLS_INTEGER := 0;
 2741|         BEGIN
 2742|             SELECT COUNT(1) INTO V_MFTRP_CNT
 2743|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 2744|             WHERE  MEASURE = 'MKT_FCST_RP';
 2745| 
 2746|             IF V_MFTRP_CNT > 0 THEN
 2747|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 2748|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2749|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 2750|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 2751|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 2752|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 2753|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2754|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 2755|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2756|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2757|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2758|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2759|                      , 'MKT_FCST_RP'  AS MEASURE   -- RTF 실적 → MKT_FCST_RP 로 표시
 2760|                      , F.YYYYMMDD, F.QTY
 2761|                      , M.MEASURE_GROUP
 2762|                      , T2.CELL_MODEL
 2763|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2764|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2765|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 2766|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2767|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2768|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2769|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2770|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2771|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2772|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2773|                      , T2.CELL_MODEL_NICK_NAME
 2774|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2775|                      , M.SORT_ORDER_NO
 2776|                      , T2.ENERGE, T2.CELL_QUANTITY
 2777|                      , F.ATTRIBUTE10  AS AS_FROM_SITE
 2778|                      , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2779|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2780|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2781|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2782|                            AND  INCOTERMS   = F.INCOTERMS
 2783|                            AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END )
 2784|                      , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2785|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2786|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2787|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2788|                            AND  INCOTERMS   = F.INCOTERMS    AND QTY         <> 0
 2789|                            AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END
 2790|                            AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2791|                                                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2792|                                                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2793|                                                   AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
 2794|                                                   AND  INCOTERMS   = F.INCOTERMS
 2795|                                                   AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END ) )
 2796|                      , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2797|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2798|                      , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2799|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2800|                 FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2801|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2802|                   ON   F.MEASURE  = 'RTF'         -- 실적은 RTF
 2803|                  AND   M.MEASURE  = 'MKT_FCST_RP' -- → MKT_FCST_RP 로 표시
 2804|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2805|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 2806|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2807|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2808|                  AND   F.ITEM_ID      = T2.ITEM_ID
 2809|                 WHERE  F.QTY <> 0
 2810|                   AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2811|                   AND  F.YYYYMMDD     < V_TO_RESULT
 2812|                   AND  F.DIVISION_ID  = P_DIVISION_ID
 2813|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2814|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2815|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2816|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2817|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2818|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2819|             END IF;  -- R-7 END
 2820|         END;
 2821| 
 2822|         -----------------------------------------------------------------------
 2823|         -- Block R-8: IN_TRANSIT
 2824|         --   소스: GT_GGET_INTRANSIT_DATA
 2825|         --   [E20241126-000426] SHIPMENT_PLAN 주석처리됨; IN_TRANSIT만 사용
 2826|         --   주의: YYYYMMDD 범위가 p_from_yyyymmdd ~ v_to_yyyymmdd (계획+실적 모두)
 2827|         -----------------------------------------------------------------------
 2828|         DECLARE
 2829|             V_IT_CNT PLS_INTEGER := 0;
 2830|         BEGIN
 2831|             SELECT COUNT(1) INTO V_IT_CNT
 2832|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 2833|             WHERE  MEASURE = 'IN_TRANSIT';
 2834| 
 2835|             IF V_IT_CNT > 0 THEN
 2836|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 2837|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2838|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 2839|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 2840|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 2841|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 2842|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2843|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 2844|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2845|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2846|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2847|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2848|                      , F.MEASURE
 2849|                      , F.YYYYMMDD, F.QTY
 2850|                      , M.MEASURE_GROUP
 2851|                      , T2.CELL_MODEL
 2852|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2853|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2854|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 2855|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2856|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2857|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2858|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2859|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2860|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2861|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2862|                      , T2.CELL_MODEL_NICK_NAME
 2863|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2864|                      , M.SORT_ORDER_NO
 2865|                      , T2.ENERGE, T2.CELL_QUANTITY
 2866|                      , ''  AS AS_FROM_SITE
 2867|                      , ''  AS CREATE_DATE
 2868|                      , ''  AS LAST_UPDATED_BY
 2869|                      , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2870|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2871|                      , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2872|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2873|                 FROM   SCM_MGR.GT_GGET_INTRANSIT_DATA F
 2874|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2875|                   ON   F.MEASURE = 'IN_TRANSIT'
 2876|                  AND   F.MEASURE = M.MEASURE
 2877|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2878|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 2879|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2880|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2881|                  AND   F.ITEM_ID      = T2.ITEM_ID
 2882|                 WHERE  F.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 2883|                   AND  F.DIVISION_ID  = P_DIVISION_ID
 2884|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2885|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2886|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2887|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2888|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2889|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2890|             END IF;  -- R-8 END
 2891|         END;
 2892| 
 2893|     END IF;  -- 실적 구간 조건 END (V_FROM_YYYYMMDD <= 당주 월요일)
 2894| 
 2895|     -----------------------------------------------------------------------
 2896|     -- Step 1: GT_GGET_MKT_FCST_DATA → GT_GGET_MKT_FCST_DST  집계
 2897|     --   [E20240712-001683] YYYYMMDD 포함 GROUP BY
 2898|     -----------------------------------------------------------------------
 2899|     INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DST
 2900|     ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 2901|     , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD
 2902|     , MEASURE_GROUP, FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
 2903|     , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
 2904|     , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
 2905|     , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
 2906|     , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
 2907|     , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2908|     , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
 2909|     , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
 2910|     , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2911|     , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2912|     SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2913|          , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE
 2914|          , F.YYYYMMDD
 2915|          , MAX(F.MEASURE_GROUP)             AS MEASURE_GROUP
 2916|          , MAX(F.CELL_MODEL)               AS FORECAST_INFO_CELL_MODEL
 2917|          , MAX(F.END_CUSTOMER)             AS END_CUSTOMER
 2918|          , MAX(F.NICK_NAME)               AS NICK_NAME
 2919|          , MAX(F.DMS_SALES)               AS DMS_SALES
 2920|          , MAX(F.DMS_CUSTOMER)            AS DMS_CUSTOMER
 2921|          , MAX(F.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
 2922|          , MAX(F.DEPT_ID)                 AS DEPT_ID
 2923|          , MAX(F.DEPT_NAME_KO)            AS DEPT_NAME_KO
 2924|          , MAX(F.ITEM_TYPE)               AS ITEM_TYPE
 2925|          , MAX(F.PROJECT_NAME)            AS PROJECT_NAME
 2926|          , MAX(F.PROJECT_OWNER)           AS PROJECT_OWNER
 2927|          , MAX(F.OWNER)                   AS OWNER
 2928|          , MAX(F.BIZ_TYPE)               AS BIZ_TYPE
 2929|          , MAX(F.SOLDTO_CUSTOMER)         AS SOLDTO_CUSTOMER
 2930|          , MAX(F.COUNTRY_NAME)            AS COUNTRY_NAME
 2931|          , MAX(F.CITY_NAME)              AS CITY_NAME
 2932|          , MAX(F.PROJECT_STATUS)          AS PROJECT_STATUS
 2933|          , MAX(F.ITEM_NAME)              AS ITEM_NAME
 2934|          , MAX(F.VMI_YN)                 AS VMI_YN
 2935|          , MAX(F.CUST_GROUP)             AS CUST_GROUP
 2936|          , MAX(F.CUST_GROUP_DTL)         AS CUST_GROUP_DTL
 2937|          , MAX(F.APPLICATION)            AS APPLICATION
 2938|          , MAX(F.ROUTE)                  AS ROUTE
 2939|          , MAX(F.MDM_PROJECT_NAME)       AS MDM_PROJECT_NAME
 2940|          , MAX(F.MIN_CAPACITY)           AS MIN_CAPACITY
 2941|          , MAX(F.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
 2942|          , MAX(F.CELL_TYPE)              AS CELL_TYPE
 2943|          , MAX(F.FORECAST_INFO_ALL)      AS FORECAST_INFO_ALL
 2944|          , MAX(F.FORECAST_INFO_SPEC)     AS FORECAST_INFO_SPEC
 2945|          , MAX(F.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
 2946|          , MAX(F.CELL_MODEL_NICK_NAME)   AS CELL_MODEL_NICK_NAME
 2947|          , MAX(F.CELL_PER_CAR)           AS CELL_PER_CAR
 2948|          , MAX(F.CELL_PER_MODULE)        AS CELL_PER_MODULE
 2949|          , MAX(F.MODULE_PER_CAR)         AS MODULE_PER_CAR
 2950|          , MAX(F.SORT_ORDER_NO)          AS SORT_ORDER_NO
 2951|          , MAX(F.ENERGE)                 AS ENERGE
 2952|          , MAX(F.CELL_QUANTITY)          AS CELL_QUANTITY
 2953|          , MAX(F.AS_FROM_SITE)           AS AS_FROM_SITE
 2954|          , MAX(F.CREATE_DATE)            AS CREATE_DATE
 2955|          , MAX(F.LAST_UPDATED_BY)        AS LAST_UPDATED_BY
 2956|          , MAX(F.SENDER_CODE)            AS SENDER_CODE
 2957|          , MAX(F.SENDER_NAME)            AS SENDER_NAME
 2958|     FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA F
 2959|     GROUP  BY F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2960|            ,  F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD;
 2961| 
 2962|     -----------------------------------------------------------------------
 2963|     -- Step 2: Division 82, MKT_FCST_RP 선택 + VMI 사이트 존재 시
 2964|     --         빠진 메저(RTF_SYS_RP, VMI_In_Plan/Req, VMI_Inv, MKT_FCST_RP) 행 보완
 2965|     --   [C20201103-000114]
 2966|     -----------------------------------------------------------------------
 2967|     DECLARE
 2968|         V_MKT_FCST_RP_VMI_CNT PLS_INTEGER := 0;
 2969|     BEGIN
 2970|         SELECT COUNT(1) INTO V_MKT_FCST_RP_VMI_CNT
 2971|         FROM   SCM_MGR.GT_GGET_SELECT_MEASURE A
 2972|         WHERE  A.MEASURE = 'MKT_FCST_RP'
 2973|           AND  P_DIVISION_ID = '82'
 2974|           AND  EXISTS (
 2975|                    SELECT 1
 2976|                    FROM   SCM_MGR.GT_GGET_MKT_FCST_DST D
 2977|                    JOIN   SCM_MGR.SCM_MST_SITE B
 2978|                      ON   D.DIVISION_ID = B.DIVISION_ID
 2979|                     AND   D.SCM_SITE_ID = B.SCM_SITE_ID
 2980|                     AND   B.VMI_YN      = 'Y'
 2981|                    WHERE  D.MEASURE     = 'MKT_FCST_RP'
 2982|                );
 2983| 
 2984|         IF V_MKT_FCST_RP_VMI_CNT > 0 THEN
 2985|             -- VMI 사이트 × 빠진 메저 조합 보완
 2986|             INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DST
 2987|             ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 2988|             , DOM_EXP, FCST_TYPE, INCOTERMS
 2989|             , MEASURE, MEASURE_GROUP
 2990|             , FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
 2991|             , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
 2992|             , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
 2993|             , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
 2994|             , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
 2995|             , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2996|             , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
 2997|             , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
 2998|             , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2999|             , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 3000|             SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
 3001|                  , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
 3002|                  , A.MEASURE, A.MEASURE_GROUP
 3003|                  , A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
 3004|                  , A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT
 3005|                  , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER
 3006|                  , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
 3007|                  , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
 3008|                  , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
 3009|                  , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
 3010|                  , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
 3011|                  , REPLACE(D.SORT_ORDER_NO, '.0', A.SORTKEY)  AS SORT_ORDER_NO
 3012|                  , A.ENERGE, A.CELL_QUANTITY
 3013|                  , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
 3014|             FROM (
 3015|                 -- VMI 사이트 기반 DISTINCT 헤더
 3016|                 SELECT B2.MEASURE    AS MEASURE
 3017|                      , B2.MEASURE_GROUP
 3018|                      , B2.SORTKEY
 3019|                      , A2.*
 3020|                 FROM (
 3021|                     SELECT DISTINCT
 3022|                            A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
 3023|                          , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
 3024|                          , A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
 3025|                          , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
 3026|                          , A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
 3027|                          , A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
 3028|                          , A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
 3029|                          , A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
 3030|                          , A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
 3031|                          , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
 3032|                          , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
 3033|                          , A2.ENERGE, A2.CELL_QUANTITY
 3034|                          , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
 3035|                     FROM   SCM_MGR.GT_GGET_MKT_FCST_DST A2
 3036|                     JOIN   SCM_MGR.SCM_MST_SITE S
 3037|                       ON   A2.DIVISION_ID = S.DIVISION_ID
 3038|                      AND   A2.SCM_SITE_ID = S.SCM_SITE_ID
 3039|                      AND   S.VMI_YN       = 'Y'
 3040|                 ) A2,
 3041|                 (
 3042|                     SELECT 'MKT_FCST_RP' AS MEASURE_GROUP, 'MKT_FCST_RP' AS MEASURE, '.9' AS SORTKEY FROM DUAL UNION ALL
 3043|                     SELECT 'RTF_SYS_RP'  AS MEASURE_GROUP, 'RTF_SYS_RP'  AS MEASURE, '.1' FROM DUAL UNION ALL
 3044|                     SELECT 'VMI_In_Plan' AS MEASURE_GROUP, 'VMI_In_Plan' AS MEASURE, '.2' FROM DUAL UNION ALL
 3045|                     SELECT 'VMI_In_Req'  AS MEASURE_GROUP, 'VMI_In_Req'  AS MEASURE, '.3' FROM DUAL UNION ALL
 3046|                     SELECT 'VMI_Inv'     AS MEASURE_GROUP, 'VMI_Inv'     AS MEASURE, '.4' FROM DUAL
 3047|                 ) B2
 3048|             ) A
 3049|             -- 이미 GT_GGET_MKT_FCST_DST에 존재하는 조합은 제외
 3050|             LEFT OUTER JOIN SCM_MGR.GT_GGET_MKT_FCST_DST C
 3051|               ON  A.DIVISION_ID    = C.DIVISION_ID
 3052|              AND  A.PROJECT_CODE   = C.PROJECT_CODE
 3053|              AND  A.SCM_SITE_ID    = C.SCM_SITE_ID
 3054|              AND  A.PLANT_SITE_ID  = C.PLANT_SITE_ID
 3055|              AND  A.ITEM_ID        = C.ITEM_ID
 3056|              AND  A.DOM_EXP        = C.DOM_EXP
 3057|              AND  A.FCST_TYPE      = C.FCST_TYPE
 3058|              AND  A.INCOTERMS      = C.INCOTERMS
 3059|              AND  A.MEASURE        = C.MEASURE
 3060|              AND  A.MEASURE_GROUP  = C.MEASURE_GROUP
 3061|             LEFT OUTER JOIN SCM_MGR.GT_GGET_SELECT_MEASURE D
 3062|               ON  A.MEASURE = D.MEASURE AND A.MEASURE_GROUP = D.MEASURE_GROUP
 3063|             WHERE C.MEASURE IS NULL
 3064|             ORDER BY A.INCOTERMS, A.MEASURE;
 3065|         END IF;
 3066|     END;
 3067| 
 3068|     -----------------------------------------------------------------------
 3069|     -- Step 3: Division 82 + P_INVALID_EXEC='N'
 3070|     --         → GT_GGET_SALES_PRICE 수집 (mapping 미등록 Sales Price 제공)
 3071|     --   [C20200612-000174]
 3072|     -----------------------------------------------------------------------
 3073|     IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' THEN
 3074| 
 3075|         -- LOC measure → MKT_FCST_RP, BNPIn(상품/전극) 행 수집
 3076|         INSERT INTO SCM_MGR.GT_GGET_SALES_PRICE
 3077|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 3078|         , DOM_EXP, FCST_TYPE, INCOTERMS
 3079|         , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY, COUNTRY_NAME, CITY, CITY_NAME
 3080|         , OWNER, PROJECT_OWNER, USER_ID, ITEM_NAME, ITEM_TYPE
 3081|         , PROJECT_STATUS, NICK_NAME, DEPT_ID, DEPT_NAME_KO, VMI_YN
 3082|         , PROJECT_NAME, END_CUSTOMER, ENERGE, CELL_QUANTITY
 3083|         , MEASURE, MEASURE_GROUP, SORT_ORDER_NO )
 3084|         SELECT DISTINCT
 3085|                A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
 3086|              , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
 3087|              , B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY, B.COUNTRY_NAME, B.CITY, B.CITY_NAME
 3088|              , B.OWNER, B.PROJECT_OWNER, B.USER_ID, B.ITEM_NAME, B.ITEM_TYPE
 3089|              , B.PROJECT_STATUS, B.NICK_NAME, B.DEPT_ID, B.DEPT_NAME_KO, B.VMI_YN
 3090|              , B.PROJECT_NAME, B.END_CUSTOMER, B.ENERGE, B.CELL_QUANTITY
 3091|              , 'MKT_FCST_RP'  AS MEASURE
 3092|              , 'MKT_FCST_RP'  AS MEASURE_GROUP
 3093|              , CASE WHEN NVL(B.VMI_YN,'N') <> 'Y' THEN '00.0' ELSE '.9' END  AS SORT_ORDER_NO
 3094|         FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
 3095|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM B
 3096|           ON   A.DIVISION_ID  = B.DIVISION_ID
 3097|          AND   A.PROJECT_CODE = B.PROJECT_CODE
 3098|          AND   A.SCM_SITE_ID  = B.SCM_SITE_ID
 3099|          AND   A.ITEM_ID      = B.ITEM_ID
 3100|          AND   ( A.FCST_TYPE IS NOT NULL OR A.FCST_TYPE   <> '' )
 3101|         WHERE  A.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
 3102|           AND  A.MEASURE     = 'LOC'
 3103|           AND  A.FCST_TYPE  <> 'ETC'    -- [C20200702-000136] ETC 제외
 3104| 
 3105|         UNION ALL
 3106| 
 3107|         SELECT DISTINCT
 3108|                A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
 3109|              , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
 3110|              , B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY, B.COUNTRY_NAME, B.CITY, B.CITY_NAME
 3111|              , B.OWNER, B.PROJECT_OWNER, B.USER_ID, B.ITEM_NAME, B.ITEM_TYPE
 3112|              , B.PROJECT_STATUS, B.NICK_NAME, B.DEPT_ID, B.DEPT_NAME_KO, B.VMI_YN
 3113|              , B.PROJECT_NAME, B.END_CUSTOMER, B.ENERGE, B.CELL_QUANTITY
 3114|              , 'BNPIn'  AS MEASURE
 3115|              , 'BNPIn'  AS MEASURE_GROUP
 3116|              , '00.0'   AS SORT_ORDER_NO
 3117|         FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
 3118|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM B
 3119|           ON   A.DIVISION_ID  = B.DIVISION_ID
 3120|          AND   A.PROJECT_CODE = B.PROJECT_CODE
 3121|          AND   A.SCM_SITE_ID  = B.SCM_SITE_ID
 3122|          AND   A.ITEM_ID      = B.ITEM_ID
 3123|          AND   ( A.FCST_TYPE IS NOT NULL OR A.FCST_TYPE   <> '' )
 3124|          AND   B.ITEM_TYPE   IN ('Q','R')  -- 상품/전극만
 3125|         WHERE  A.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
 3126|           AND  A.MEASURE     = 'LOC'
 3127|           AND  A.FCST_TYPE  <> 'ETC';
 3128| 
 3129|         -- SORT_ORDER_NO: GT_GGET_SELECT_MEASURE 기준으로 업데이트
 3130|         UPDATE SCM_MGR.GT_GGET_SALES_PRICE A
 3131|         SET    A.SORT_ORDER_NO = (
 3132|                    SELECT B.SORT_ORDER_NO
 3133|                    FROM   SCM_MGR.GT_GGET_SELECT_MEASURE B
 3134|                    WHERE  A.MEASURE       = B.MEASURE
 3135|                      AND  A.MEASURE_GROUP = B.MEASURE_GROUP
 3136|                      AND  ROWNUM          = 1 );
 3137| 
 3138|         -- VMI/RTF/MKT_FCST_RP 계열 SORT_ORDER_NO 소수점 자리 조정
 3139|         UPDATE SCM_MGR.GT_GGET_SALES_PRICE
 3140|         SET    SORT_ORDER_NO =
 3141|                CASE WHEN MEASURE = 'RTF_SYS_RP'  THEN REPLACE(SORT_ORDER_NO, '.0', '.1')
 3142|                     WHEN MEASURE = 'VMI_In_Plan'  THEN REPLACE(SORT_ORDER_NO, '.0', '.2')
 3143|                     WHEN MEASURE = 'VMI_In_Req'   THEN REPLACE(SORT_ORDER_NO, '.0', '.3')
 3144|                     WHEN MEASURE = 'VMI_Inv'      THEN REPLACE(SORT_ORDER_NO, '.0', '.4')
 3145|                     WHEN MEASURE = 'MKT_FCST_RP'  THEN REPLACE(SORT_ORDER_NO, '.0', '.9')
 3146|                END
 3147|         WHERE  MEASURE IN ('MKT_FCST_RP','RTF_SYS_RP','VMI_In_Plan','VMI_In_Req','VMI_Inv');
 3148| 
 3149|     END IF;
 3150| 
 3151|     -----------------------------------------------------------------------
 3152|     -- Step 4: LP_AS_YN='Y' → AS_IN_REQ/PLAN/INV 빈 행 GT_GGET_MKT_FCST_DST에 추가
 3153|     --   조건: AS_SITE_PLANT LOOKUP에 있는 SCM_SITE_ID인 데이터 중
 3154|     --         아직 GT_GGET_MKT_FCST_DATA에 AS 메저가 없는 조합 삽입
 3155|     -----------------------------------------------------------------------
 3156|     IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' AND LP_AS_YN = 'Y' THEN
 3157|         DECLARE
 3158|             V_AS_MEA_CNT PLS_INTEGER := 0;
 3159|         BEGIN
 3160|             SELECT COUNT(1) INTO V_AS_MEA_CNT
 3161|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 3162|             WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV');
 3163| 
 3164|             IF V_AS_MEA_CNT > 0 THEN
 3165|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DST
 3166|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 3167|                 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, MEASURE_GROUP
 3168|                 , FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
 3169|                 , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
 3170|                 , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
 3171|                 , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
 3172|                 , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
 3173|                 , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 3174|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
 3175|                 , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
 3176|                 , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 3177|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 3178|                 SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
 3179|                      , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
 3180|                      , C.MEASURE, C.MEASURE_GROUP
 3181|                      , A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
 3182|                      , A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT
 3183|                      , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER
 3184|                      , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
 3185|                      , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
 3186|                      , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
 3187|                      , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
 3188|                      , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
 3189|                      , C.SORT_ORDER_NO
 3190|                      , A.ENERGE, A.CELL_QUANTITY
 3191|                      , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
 3192|                 FROM (
 3193|                     -- AS_SITE_PLANT LOOKUP에 있는 SCM_SITE_ID 기반 DST 헤더 (중복 제거)
 3194|                     SELECT A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
 3195|                          , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS, A2.MEASURE, A2.MEASURE_GROUP
 3196|                          , A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
 3197|                          , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
 3198|                          , A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
 3199|                          , A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
 3200|                          , A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
 3201|                          , A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
 3202|                          , A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
 3203|                          , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
 3204|                          , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
 3205|                          , A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
 3206|                          , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
 3207|                     FROM   SCM_MGR.GT_GGET_MKT_FCST_DST A2
 3208|                     JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B2
 3209|                       ON   A2.SCM_SITE_ID = B2.SEGMENT1
 3210|                      AND   B2.LOOKUP_TYPE = 'AS_SITE_PLANT'
 3211|                      AND   B2.SEGMENT3    = P_DIVISION_ID
 3212|                     GROUP  BY A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
 3213|                            ,  A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS, A2.MEASURE, A2.MEASURE_GROUP
 3214|                            ,  A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
 3215|                            ,  A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
 3216|                            ,  A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
 3217|                            ,  A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
 3218|                            ,  A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
 3219|                            ,  A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
 3220|                            ,  A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
 3221|                            ,  A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
 3222|                            ,  A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
 3223|                            ,  A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
 3224|                            ,  A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
 3225|                 ) A
 3226|                 -- AS_IN_REQ/PLAN/INV 메저 목록 (CROSS JOIN)
 3227|                 JOIN (
 3228|                     SELECT MEASURE, MEASURE_GROUP, SORT_ORDER_NO
 3229|                     FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 3230|                     WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV')
 3231|                 ) C ON 1=1
 3232|                 -- 이미 GT_GGET_MKT_FCST_DATA에 AS 메저가 있는 조합은 제외
 3233|                 LEFT OUTER JOIN (
 3234|                     SELECT DISTINCT
 3235|                            D2.DIVISION_ID, D2.PROJECT_CODE, D2.SCM_SITE_ID, D2.ITEM_ID
 3236|                          , D2.DOM_EXP, D2.FCST_TYPE, D2.INCOTERMS, D2.MEASURE, D2.PLANT_SITE_ID
 3237|                     FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA D2
 3238|                     JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B3
 3239|                       ON   D2.SCM_SITE_ID = B3.SEGMENT1
 3240|                      AND   B3.LOOKUP_TYPE = 'AS_SITE_PLANT'
 3241|                      AND   B3.SEGMENT3    = P_DIVISION_ID
 3242|                 ) D ON  A.DIVISION_ID   = D.DIVISION_ID
 3243|                     AND A.PROJECT_CODE  = D.PROJECT_CODE
 3244|                     AND A.SCM_SITE_ID   = D.SCM_SITE_ID
 3245|                     AND A.ITEM_ID       = D.ITEM_ID
 3246|                     AND A.DOM_EXP       = D.DOM_EXP
 3247|                     AND A.FCST_TYPE     = D.FCST_TYPE
 3248|                     AND A.INCOTERMS     = D.INCOTERMS
 3249|                     AND C.MEASURE       = D.MEASURE
 3250|                     AND A.PLANT_SITE_ID = D.PLANT_SITE_ID
 3251|                 WHERE D.DIVISION_ID IS NULL;
 3252|             END IF;
 3253|         END;
 3254|    END IF;
 3255| 
 3256|     -----------------------------------------------------------------------
 3257|     -- Step 5: Division 82 VMI 재고계산  [E20240102-000545]
 3258|     --   5-1) GT_GGET_VMI_INV: RANK=1(최신 일자) 행 추출
 3259|     --   5-2) DELETE: VMI_INV 일자 이후에 MKT_FCST/VMI_In_Plan/VMI_In_Req 있는 경우 제거
 3260|     --   5-3) DELETE: MKT_FCST/VMI_In_Plan/VMI_In_Req 행 삭제 (VMI_INV만 남김)
 3261|     --   5-4) GT_GGET_VMI_INV_RESULT: GT_GGET_MKT_FCST_DATA와 JOIN → 헤더 정보 붙임
 3262|     --   5-5) PERIOD 기간만큼 GT_GGET_VMI_INV_RESULT 확장
 3263|     --   5-6) 원본 VMI_INV 날짜 행 삭제 (모수 제거)
 3264|     --   5-7) GT_GGET_MKT_FCST_DATA에 최종 INSERT
 3265|     -----------------------------------------------------------------------
 3266|     IF P_DIVISION_ID = '82' THEN
 3267| 
 3268|         -- 5-1) 최신 날짜 VMI 관련 데이터 추출 (RANK=1)
 3269|         DELETE FROM SCM_MGR.GT_GGET_VMI_INV;
 3270|         DELETE FROM SCM_MGR.GT_GGET_VMI_INV_RESULT;
 3271| 
 3272|         INSERT INTO SCM_MGR.GT_GGET_VMI_INV
 3273|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3274|         , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY )
 3275|         SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3276|              , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
 3277|         FROM (
 3278|             SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3279|                  , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
 3280|                  , RANK() OVER (
 3281|                        PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
 3282|                                     DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE
 3283|                        ORDER BY YYYYMMDD DESC
 3284|                    ) AS SEQ
 3285|             FROM (
 3286|                 -- 계획 테이블
 3287|                 SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3288|                      , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
 3289|                 FROM   SCM_MGR.DM_PLN_MKT_FCST
 3290|                 WHERE  DIVISION_ID = P_DIVISION_ID
 3291|                   AND  MEASURE    IN ('VMI_INV','MKT_FCST','VMI_In_Plan','VMI_In_Req')
 3292|                   AND  QTY        <> 0
 3293|                   AND  YYYYMMDD  BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
 3294|                 UNION ALL
 3295|                 -- 실적 테이블 (RESULT): 당주 월요일 이전까지
 3296|                 SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3297|                      , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
 3298|                      , SUM(QTY) AS QTY   -- [PJ2025-50188] CELL_PROD_SITE_ID 제거 후 집계
 3299|                 FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT
 3300|                 WHERE  DIVISION_ID = P_DIVISION_ID
 3301|                   AND  MEASURE    IN ('VMI_INV','MKT_FCST','VMI_In_Plan','VMI_In_Req')
 3302|                   AND  QTY        <> 0
 3303|                   AND  YYYYMMDD  >= P_FROM_YYYYMMDD
 3304|                   AND  YYYYMMDD   < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
 3305|                 GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3306|                        ,  DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
 3307|             ) A
 3308|         ) B
 3309|         WHERE SEQ = 1;
 3310| 
 3311|         -- 5-2) VMI_INV 일자 이후에 MKT_FCST 계열이 있는 경우 → VMI_INV 행 제거
 3312|         DELETE FROM SCM_MGR.GT_GGET_VMI_INV C
 3313|         WHERE EXISTS (
 3314|             SELECT 1
 3315|             FROM (
 3316|                 SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
 3317|                      , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
 3318|                 FROM   SCM_MGR.GT_GGET_VMI_INV A    -- VMI_INV
 3319|                 JOIN   SCM_MGR.GT_GGET_VMI_INV B    -- MKT_FCST 계열
 3320|                   ON   A.DIVISION_ID   = B.DIVISION_ID
 3321|                  AND   A.PROJECT_CODE  = B.PROJECT_CODE
 3322|                  AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
 3323|                  AND   A.ITEM_ID       = B.ITEM_ID
 3324|                  AND   A.DOM_EXP       = B.DOM_EXP
 3325|                  AND   A.FCST_TYPE     = B.FCST_TYPE
 3326|                  AND   A.INCOTERMS     = B.INCOTERMS
 3327|                  AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
 3328|                  AND   A.MEASURE       = 'VMI_INV'
 3329|                  AND   B.MEASURE      IN ('MKT_FCST','VMI_In_Plan','VMI_In_Req')
 3330|                  AND   B.YYYYMMDD     >= A.YYYYMMDD + 1
 3331|             ) T
 3332|             WHERE C.DIVISION_ID   = T.DIVISION_ID
 3333|               AND C.PROJECT_CODE  = T.PROJECT_CODE
 3334|               AND C.SCM_SITE_ID   = T.SCM_SITE_ID
 3335|               AND C.ITEM_ID       = T.ITEM_ID
 3336|               AND C.DOM_EXP       = T.DOM_EXP
 3337|               AND C.FCST_TYPE     = T.FCST_TYPE
 3338|               AND C.INCOTERMS     = T.INCOTERMS
 3339|               AND C.PLANT_SITE_ID = T.PLANT_SITE_ID
 3340|         );
 3341| 
 3342|         -- 5-3) MKT_FCST/VMI_In_Plan/VMI_In_Req 행 삭제 → VMI_INV만 남김
 3343|         DELETE FROM SCM_MGR.GT_GGET_VMI_INV
 3344|         WHERE  MEASURE IN ('MKT_FCST','VMI_In_Plan','VMI_In_Req');
 3345| 
 3346|         -- 5-4) GT_GGET_MKT_FCST_DATA와 JOIN하여 헤더 정보 포함 → GT_GGET_VMI_INV_RESULT
 3347|         INSERT INTO SCM_MGR.GT_GGET_VMI_INV_RESULT
 3348|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3349|         , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
 3350|         , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
 3351|         , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 3352|         , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
 3353|         , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
 3354|         , CUST_GROUP, CUST_GROUP_DTL, MDM_PROJECT_NAME, MIN_CAPACITY
 3355|         , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
 3356|         , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
 3357|         , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 3358|         , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 3359|         SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
 3360|              , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD, A.PLANT_SITE_ID, A.QTY
 3361|              , B.MEASURE_GROUP, B.CELL_MODEL, B.END_CUSTOMER, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER
 3362|              , B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT
 3363|              , B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER
 3364|              , B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN
 3365|              , B.CUST_GROUP, B.CUST_GROUP_DTL, B.MDM_PROJECT_NAME, B.MIN_CAPACITY
 3366|              , B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC
 3367|              , B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE
 3368|              , B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY
 3369|              , B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME
 3370|         FROM   SCM_MGR.GT_GGET_VMI_INV A
 3371|         JOIN   SCM_MGR.GT_GGET_MKT_FCST_DATA B
 3372|           ON   A.DIVISION_ID   = B.DIVISION_ID
 3373|          AND   A.PROJECT_CODE  = B.PROJECT_CODE
 3374|          AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
 3375|          AND   A.ITEM_ID       = B.ITEM_ID
 3376|          AND   A.DOM_EXP       = B.DOM_EXP
 3377|          AND   A.FCST_TYPE     = B.FCST_TYPE
 3378|          AND   A.INCOTERMS     = B.INCOTERMS
 3379|          AND   A.MEASURE       = B.MEASURE
 3380|          AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
 3381|          AND   A.YYYYMMDD      = B.YYYYMMDD;
 3382| 
 3383|         -- 5-5) PERIOD 기간만큼 GT_GGET_VMI_INV_RESULT 행 확장
 3384|         --       (원본 날짜 이후의 모든 날짜에 동일 QTY 행 생성)
 3385|         INSERT INTO SCM_MGR.GT_GGET_VMI_INV_RESULT
 3386|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3387|         , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
 3388|         , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
 3389|         , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 3390|         , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
 3391|         , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
 3392|         , CUST_GROUP, CUST_GROUP_DTL, MDM_PROJECT_NAME, MIN_CAPACITY
 3393|         , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
 3394|         , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
 3395|         , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 3396|         , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 3397|         SELECT DISTINCT
 3398|                B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID
 3399|              , B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE
 3400|              , A.BASIS_YYYYMMDD  AS YYYYMMDD   -- 캘린더 날짜로 확장
 3401|              , B.PLANT_SITE_ID, B.QTY
 3402|              , B.MEASURE_GROUP, B.CELL_MODEL, B.END_CUSTOMER, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER
 3403|              , B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT
 3404|              , B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER
 3405|              , B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN
 3406|              , B.CUST_GROUP, B.CUST_GROUP_DTL, B.MDM_PROJECT_NAME, B.MIN_CAPACITY
 3407|              , B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC
 3408|              , B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE
 3409|              , B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY
 3410|              , B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME
 3411|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
 3412|         LEFT   OUTER JOIN SCM_MGR.GT_GGET_VMI_INV_RESULT B
 3413|           ON   A.BASIS_YYYYMMDD > B.YYYYMMDD   -- 원본 날짜 이후 모든 날짜
 3414|         WHERE  A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
 3415|           AND  A.BASIS_YYYYMMDD > B.YYYYMMDD;
 3416| 
 3417|         -- 5-6) 원본 VMI_INV 날짜 행 삭제 (모수 제거)
 3418|         DELETE FROM SCM_MGR.GT_GGET_VMI_INV_RESULT A
 3419|         WHERE  DIVISION_ID = '82'
 3420|           AND  MEASURE     = 'VMI_INV'
 3421|           AND  EXISTS (
 3422|                    SELECT 1
 3423|                    FROM   SCM_MGR.GT_GGET_VMI_INV Z
 3424|                    WHERE  A.DIVISION_ID   = Z.DIVISION_ID
 3425|                      AND  A.PROJECT_CODE  = Z.PROJECT_CODE
 3426|                      AND  A.SCM_SITE_ID   = Z.SCM_SITE_ID
 3427|                      AND  A.ITEM_ID       = Z.ITEM_ID
 3428|                      AND  A.DOM_EXP       = Z.DOM_EXP
 3429|                      AND  A.FCST_TYPE     = Z.FCST_TYPE
 3430|                      AND  A.INCOTERMS     = Z.INCOTERMS
 3431|                      AND  A.PLANT_SITE_ID = Z.PLANT_SITE_ID
 3432|                      AND  A.YYYYMMDD      = Z.YYYYMMDD
 3433|                );
 3434| 
 3435|         -- 5-7) GT_GGET_MKT_FCST_DATA에 VMI_INV 보완 행 INSERT
 3436|         INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 3437|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 3438|         , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
 3439|         , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
 3440|         , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 3441|         , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
 3442|         , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
 3443|         , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
 3444|         , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 3445|         , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
 3446|         , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
 3447|         , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 3448|         , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 3449|         SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 3450|              , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
 3451|              , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
 3452|              , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 3453|              , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
 3454|              , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
 3455|              , CUST_GROUP, CUST_GROUP_DTL
 3456|              , NULL  AS APPLICATION   -- GT_GGET_VMI_INV_RESULT에 APPLICATION/ROUTE 없음
 3457|              , NULL  AS ROUTE
 3458|              , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 3459|              , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
 3460|              , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
 3461|              , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 3462|              , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
 3463|         FROM   SCM_MGR.GT_GGET_VMI_INV_RESULT;
 3464| 
 3465|     END IF;  -- Division 82 VMI 재고계산 END
 3466| 
 3467|     -----------------------------------------------------------------------
 3468|     -- Step 6: NOTATION 컬럼 업데이트  [E20240812-000094]
 3469|     --   DM_MEASURE_POSITIONAL_NOTATION LOOKUP → MEASURE별 소수점 표기형태 설정
 3470|     -----------------------------------------------------------------------
 3471|     UPDATE SCM_MGR.GT_GGET_MKT_FCST_DATA A
 3472|     SET    A.NOTATION = NVL(
 3473|                ( SELECT C.SEGMENT3
 3474|                  FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
 3475|                  WHERE  C.LOOKUP_TYPE = 'DM_MEASURE_POSITIONAL_NOTATION'
 3476|                    AND  A.MEASURE     = C.SEGMENT2
 3477|                    AND  A.DIVISION_ID = C.SEGMENT1
 3478|                    AND  ROWNUM        = 1 ),
 3479|                'DEFAULT' );
 3480| 
 3481|     -----------------------------------------------------------------------
 3482|     -- 팀 WHERE 조건 생성 (FN_SCM_GET_WHERE_SQL → 인라인 변환)
 3483|     -----------------------------------------------------------------------
 3484|     IF P_TEAM_ID = 'ALL' THEN
 3485|         V_TEAM_WHERE := '1=1';
 3486|     ELSE
 3487|         -- P_TEAM_ID 가 콤마 구분 목록일 경우 IN 절 생성
 3488|         V_TEAM_WHERE := 'A.DEPT_ID IN ('''
 3489|                      || REPLACE(P_TEAM_ID, ',', ''',''')
 3490|                      || ''')';
 3491|     END IF;
 3492| 
 3493|     -----------------------------------------------------------------------
 3494|     -- 분기: Division 82 + P_INVALID_EXEC='N'  → PIVOT SQL #1 (AS용)
 3495|     --        그 외                             → AS_IN_REQ 보완 + PIVOT SQL #2
 3496|     -----------------------------------------------------------------------
 3497|     IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' THEN
 3498| 
 3499|         -- -----------------------------------------------------------------------
 3500|         -- PIVOT SQL #1 (AS용)
 3501|         --   소스: GT_GGET_SALES_PRICE  FULL OUTER JOIN  GT_GGET_MKT_FCST_DST
 3502|         --         → GT_GGET_MF (임시 조인 결과)
 3503|         --         → PIVOT + EXECUTE IMMEDIATE → O_RC
 3504|         -- -----------------------------------------------------------------------
 3505|         V_SQL_TEXT :=
 3506|         'WITH MF_BASE AS (' || CHR(10) ||
 3507|         'SELECT' || CHR(10) ||
 3508|         '      A.DIVISION_ID' || CHR(10) ||
 3509|         '    , A.DIVISION_ID                                         AS DIVISION_ID40' || CHR(10) ||
 3510|         '    , CASE WHEN ''' || LP_AS_YN || ''' = ''Y'' THEN NVL(X.DISPLAY_SEQ,999) ELSE 999 END AS SORT_KEY' || CHR(10) ||
 3511|         '    , A.SCM_SITE_ID' || CHR(10) ||
 3512|         '    , A.SCM_SITE_ID                                         AS SCM_SITE_ID40' || CHR(10) ||
 3513|         '    , A.PLANT_SITE_ID' || CHR(10) ||
 3514|         '    , A.PROJECT_CODE' || CHR(10) ||
 3515|         '    , NVL(I.GROUP_ID,'''')                                  AS GROUP_ID' || CHR(10) ||
 3516|         '    , A.ITEM_ID' || CHR(10) ||
 3517|         '    , A.ITEM_ID                                             AS ITEM_ID40' || CHR(10) ||
 3518|         '    , A.INCOTERMS' || CHR(10) ||
 3519|         '    , A.FCST_TYPE' || CHR(10) ||
 3520|         '    , A.DOM_EXP' || CHR(10) ||
 3521|         '    , A.MEASURE' || CHR(10) ||
 3522|         '    , A.END_CUSTOMER' || CHR(10) ||
 3523|         '    , CASE WHEN (A.DIVISION_ID LIKE ''81%'' OR A.DIVISION_ID = ''82'')' || CHR(10) ||
 3524|         '           THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END      AS END_CUSTOMER40' || CHR(10) ||
 3525|         '    , A.NICK_NAME' || CHR(10) ||
 3526|         '    , A.DMS_SALES' || CHR(10) ||
 3527|         '    , A.DMS_CUSTOMER' || CHR(10) ||
 3528|         '    , C.BASIS_YYYYMM                                        AS YYYYMM' || CHR(10) ||
 3529|         '    , C.BASIS_YYYYMM || C.ISO_WEEK                          AS YYYYMMWW' || CHR(10) ||
 3530|         '    , C.BASIS_YYYYMMDD                                      AS YYYYMMDD' || CHR(10) ||
 3531|         '    , C.DAYOFWEEK' || CHR(10) ||
 3532|         '    , A.FORECAST_INFO_CELL_MODEL' || CHR(10) ||
 3533|         '    , A.DEPT_ID                                             AS TEAM_ID' || CHR(10) ||
 3534|         '    , A.DEPT_NAME_KO                                        AS TEAM_NAME_KO' || CHR(10) ||
 3535|         '    , A.ITEM_TYPE' || CHR(10) ||
 3536|         '    , A.PROJECT_NAME' || CHR(10) ||
 3537|         '    , A.PROJECT_OWNER' || CHR(10) ||
 3538|         '    , A.OWNER' || CHR(10) ||
 3539|         '    , A.BIZ_TYPE' || CHR(10) ||
 3540|         '    , A.SOLDTO_CUSTOMER' || CHR(10) ||
 3541|         '    , A.COUNTRY_NAME' || CHR(10) ||
 3542|         '    , A.CITY_NAME' || CHR(10) ||
 3543|         '    , A.PROJECT_STATUS' || CHR(10) ||
 3544|         '    , A.ITEM_NAME' || CHR(10) ||
 3545|         '    , A.VMI_YN' || CHR(10) ||
 3546|         '    , A.CUST_GROUP' || CHR(10) ||
 3547|         '    , A.CUST_GROUP_DTL' || CHR(10) ||
 3548|         '    , A.APPLICATION' || CHR(10) ||
 3549|         '    , A.ROUTE' || CHR(10) ||
 3550|         '    , A.MDM_PROJECT_NAME' || CHR(10) ||
 3551|         '    , A.MIN_CAPACITY' || CHR(10) ||
 3552|         '    , A.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
 3553|         '    , A.CELL_TYPE' || CHR(10) ||
 3554|         '    , A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
 3555|         '    , A.FORECAST_INFO_ALL' || CHR(10) ||
 3556|         '    , A.FORECAST_INFO_SPEC' || CHR(10) ||
 3557|         '    , A.FORECAST_INFOR_VERSION' || CHR(10) ||
 3558|         '    , A.CELL_MODEL_NICK_NAME' || CHR(10) ||
 3559|         '    , CAST(CASE WHEN ''Y'' = ''[@CellQtyYN]''' || CHR(10) ||
 3560|         '                 AND A.MEASURE_GROUP NOT IN (''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'')' || CHR(10) ||
 3561|         '                 AND NVL(A.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1' || CHR(10) ||
 3562|         '                THEN D.QTY * A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
 3563|         '                ELSE D.QTY END AS NUMBER(10)) AS QTY' || CHR(10) ||
 3564|         '    , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS MONTH_END_YN' || CHR(10) ||
 3565|         '    , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN ''Y'' ELSE ''N'' END AS WEEK_END_YN' || CHR(10) ||
 3566|         '    , CASE' || CHR(10) ||
 3567|         '          WHEN MA.DEPT_ID IS NOT NULL' || CHR(10) ||
 3568|         '               AND A.MEASURE_GROUP NOT IN (''CUST_FCST_2'',''CUST_FCST_3'',''TMM_FCST'')' || CHR(10) ||
 3569|         '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
 3570|         '          WHEN ''[@v_group_id]'' = ''ADMIN''' || CHR(10) ||
 3571|         '               AND A.MEASURE_GROUP <> ''TMM_FCST''' || CHR(10) ||
 3572|         '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
 3573|         '          WHEN A.MEASURE_GROUP = ''TMM_FCST''' || CHR(10) ||
 3574|         '               AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
 3575|         '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
 3576|         '          ELSE ''N''' || CHR(10) ||
 3577|         '      END AS EDIT_FLAG' || CHR(10) ||
 3578|         '    , A.CELL_PER_CAR' || CHR(10) ||
 3579|         '    , A.CELL_PER_MODULE' || CHR(10) ||
 3580|         '    , A.MODULE_PER_CAR' || CHR(10) ||
 3581|         '    , A.SORT_ORDER_NO' || CHR(10) ||
 3582|         '    , A.MEASURE_GROUP' || CHR(10) ||
 3583|         '    , A.ENERGE' || CHR(10) ||
 3584|         '    , A.CELL_QUANTITY' || CHR(10) ||
 3585|         '    , A.NEW_FLAG' || CHR(10) ||
 3586|         '    , NVL(VM.VMI_VAL,'''')                                  AS VMI_STD_DIO' || CHR(10) ||
 3587|         '    , NVL(B1.ATTR1, B2.ATTR1)                              AS ATTR1' || CHR(10) ||
 3588|         '    , NVL(BK.BUCKET,''0000000'')                           AS BUCKET' || CHR(10) ||
 3589|         '    , A.AS_YN' || CHR(10) ||
 3590|         '    , A.AS_FROM_SITE' || CHR(10) ||
 3591|         '    , CASE WHEN A.CREATE_DATE IS NULL OR NVL(A.CREATE_DATE,'''')    = '''' THEN '' '' ELSE A.CREATE_DATE    END AS LAST_UPDATE_DATE' || CHR(10) ||
 3592|         '    , CASE WHEN A.LAST_UPDATED_BY IS NULL OR NVL(A.LAST_UPDATED_BY,'''')= '''' THEN '' '' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY' || CHR(10) ||
 3593|         '    , CASE WHEN A.SENDER_CODE IS NULL OR NVL(A.SENDER_CODE,'''')    = '''' THEN '' '' ELSE A.SENDER_CODE    END AS SENDER_CODE' || CHR(10) ||
 3594|         '    , CASE WHEN A.SENDER_NAME IS NULL OR NVL(A.SENDER_NAME,'''')    = '''' THEN '' '' ELSE A.SENDER_NAME    END AS SENDER_NAME' || CHR(10) ||
 3595|         '    , CASE WHEN 1 = 2 THEN '' '' END AS NOTATION' || CHR(10) ||
 3596|         'FROM (' || CHR(10) ||
 3597|         '    SELECT' || CHR(10) ||
 3598|         '          NVL(M.DIVISION_ID,  P.DIVISION_ID)                AS DIVISION_ID' || CHR(10) ||
 3599|         '        , NVL(M.PROJECT_CODE, P.PROJECT_CODE)               AS PROJECT_CODE' || CHR(10) ||
 3600|         '        , NVL(M.SCM_SITE_ID,  P.SCM_SITE_ID)                AS SCM_SITE_ID' || CHR(10) ||
 3601|         '        , NVL(M.PLANT_SITE_ID,P.PLANT_SITE_ID)              AS PLANT_SITE_ID' || CHR(10) ||
 3602|         '        , NVL(M.ITEM_ID,      P.ITEM_ID)                    AS ITEM_ID' || CHR(10) ||
 3603|         '        , NVL(M.DOM_EXP,      P.DOM_EXP)                    AS DOM_EXP' || CHR(10) ||
 3604|         '        , NVL(M.FCST_TYPE,    P.FCST_TYPE)                  AS FCST_TYPE' || CHR(10) ||
 3605|         '        , NVL(M.INCOTERMS,    P.INCOTERMS)                  AS INCOTERMS' || CHR(10) ||
 3606|         '        , CASE WHEN P.MEASURE IS NOT NULL OR NVL(P.MEASURE,'''') <> '''' THEN P.MEASURE' || CHR(10) ||
 3607|         '               WHEN M.MEASURE IS NULL THEN ''MKT_FCST_RP''' || CHR(10) ||
 3608|         '               ELSE M.MEASURE END                           AS MEASURE' || CHR(10) ||
 3609|         '        , CASE WHEN P.MEASURE_GROUP IS NOT NULL OR NVL(P.MEASURE_GROUP,'''') <> '''' THEN P.MEASURE_GROUP' || CHR(10) ||
 3610|         '               WHEN M.MEASURE_GROUP IS NULL THEN ''MKT_FCST_RP''' || CHR(10) ||
 3611|         '               ELSE M.MEASURE_GROUP END                     AS MEASURE_GROUP' || CHR(10) ||
 3612|         '        , M.FORECAST_INFO_CELL_MODEL' || CHR(10) ||
 3613|         '        , NVL(M.END_CUSTOMER,   P.END_CUSTOMER)             AS END_CUSTOMER' || CHR(10) ||
 3614|         '        , NVL(M.NICK_NAME,      P.NICK_NAME)                AS NICK_NAME' || CHR(10) ||
 3615|         '        , M.DMS_SALES' || CHR(10) ||
 3616|         '        , M.DMS_CUSTOMER' || CHR(10) ||
 3617|         '        , M.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
 3618|         '        , NVL(M.DEPT_ID,        P.DEPT_ID)                  AS DEPT_ID' || CHR(10) ||
 3619|         '        , NVL(M.DEPT_NAME_KO,   P.DEPT_NAME_KO)             AS DEPT_NAME_KO' || CHR(10) ||
 3620|         '        , NVL(M.ITEM_TYPE,      P.ITEM_TYPE)                AS ITEM_TYPE' || CHR(10) ||
 3621|         '        , NVL(M.PROJECT_NAME,   P.PROJECT_NAME)             AS PROJECT_NAME' || CHR(10) ||
 3622|         '        , NVL(M.PROJECT_OWNER,  P.PROJECT_OWNER)            AS PROJECT_OWNER' || CHR(10) ||
 3623|         '        , NVL(M.OWNER,          P.OWNER)                    AS OWNER' || CHR(10) ||
 3624|         '        , NVL(M.BIZ_TYPE,       P.BIZ_TYPE)                 AS BIZ_TYPE' || CHR(10) ||
 3625|         '        , NVL(M.SOLDTO_CUSTOMER,P.SOLDTO_CUSTOMER)          AS SOLDTO_CUSTOMER' || CHR(10) ||
 3626|         '        , NVL(M.COUNTRY_NAME,   P.COUNTRY_NAME)             AS COUNTRY_NAME' || CHR(10) ||
 3627|         '        , NVL(M.CITY_NAME,      P.CITY_NAME)                AS CITY_NAME' || CHR(10) ||
 3628|         '        , NVL(M.PROJECT_STATUS, P.PROJECT_STATUS)           AS PROJECT_STATUS' || CHR(10) ||
 3629|         '        , NVL(M.ITEM_NAME,      P.ITEM_NAME)                AS ITEM_NAME' || CHR(10) ||
 3630|         '        , NVL(M.VMI_YN,         P.VMI_YN)                   AS VMI_YN' || CHR(10) ||
 3631|         '        , M.CUST_GROUP' || CHR(10) ||
 3632|         '        , M.CUST_GROUP_DTL' || CHR(10) ||
 3633|         '        , M.APPLICATION' || CHR(10) ||
 3634|         '        , M.ROUTE' || CHR(10) ||
 3635|         '        , M.MDM_PROJECT_NAME' || CHR(10) ||
 3636|         '        , M.MIN_CAPACITY' || CHR(10) ||
 3637|         '        , M.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
 3638|         '        , M.CELL_TYPE' || CHR(10) ||
 3639|         '        , M.FORECAST_INFO_ALL' || CHR(10) ||
 3640|         '        , M.FORECAST_INFO_SPEC' || CHR(10) ||
 3641|         '        , M.FORECAST_INFOR_VERSION' || CHR(10) ||
 3642|         '        , M.CELL_MODEL_NICK_NAME' || CHR(10) ||
 3643|         '        , M.CELL_PER_CAR' || CHR(10) ||
 3644|         '        , M.CELL_PER_MODULE' || CHR(10) ||
 3645|         '        , M.MODULE_PER_CAR' || CHR(10) ||
 3646|         '        , NVL(P.SORT_ORDER_NO, M.SORT_ORDER_NO)             AS SORT_ORDER_NO' || CHR(10) ||
 3647|         '        , NVL(M.ENERGE,         P.ENERGE)                   AS ENERGE' || CHR(10) ||
 3648|         '        , NVL(M.CELL_QUANTITY,  P.CELL_QUANTITY)            AS CELL_QUANTITY' || CHR(10) ||
 3649|         '        , CASE WHEN M.DIVISION_ID IS NULL THEN ''Y'' ELSE ''N'' END AS NEW_FLAG' || CHR(10) ||
 3650|         '        , ''' || LP_AS_YN || '''                             AS AS_YN' || CHR(10) ||
 3651|         '        , M.AS_FROM_SITE' || CHR(10) ||
 3652|         '        , M.CREATE_DATE' || CHR(10) ||
 3653|         '        , M.LAST_UPDATED_BY' || CHR(10) ||
 3654|         '        , M.SENDER_CODE' || CHR(10) ||
 3655|         '        , M.SENDER_NAME' || CHR(10) ||
 3656|         '        , M.YYYYMMDD' || CHR(10) ||
 3657|         '    FROM SCM_MGR.GT_GGET_SALES_PRICE P' || CHR(10) ||
 3658|         '    FULL OUTER JOIN SCM_MGR.GT_GGET_MKT_FCST_DST M' || CHR(10) ||
 3659|         '      ON  P.DIVISION_ID   = M.DIVISION_ID' || CHR(10) ||
 3660|         '      AND P.PROJECT_CODE  = M.PROJECT_CODE' || CHR(10) ||
 3661|         '      AND P.SCM_SITE_ID   = M.SCM_SITE_ID' || CHR(10) ||
 3662|         '      AND P.PLANT_SITE_ID = M.PLANT_SITE_ID' || CHR(10) ||
 3663|         '      AND P.ITEM_ID       = M.ITEM_ID' || CHR(10) ||
 3664|         '      AND P.FCST_TYPE     = M.FCST_TYPE' || CHR(10) ||
 3665|         '      AND P.INCOTERMS     = M.INCOTERMS' || CHR(10) ||
 3666|         '      AND P.DOM_EXP       = M.DOM_EXP' || CHR(10) ||
 3667|         '      AND P.MEASURE       = M.MEASURE' || CHR(10) ||
 3668|         ') A' || CHR(10) ||
 3669|         'LEFT JOIN SCM_MGR.GT_GGET_MKT_FCST_DATA D' || CHR(10) ||
 3670|         '  ON  A.DIVISION_ID   = D.DIVISION_ID' || CHR(10) ||
 3671|         '  AND A.PROJECT_CODE  = D.PROJECT_CODE' || CHR(10) ||
 3672|         '  AND A.SCM_SITE_ID   = D.SCM_SITE_ID' || CHR(10) ||
 3673|         '  AND A.PLANT_SITE_ID = D.PLANT_SITE_ID' || CHR(10) ||
 3674|         '  AND A.ITEM_ID       = D.ITEM_ID' || CHR(10) ||
 3675|         '  AND A.DOM_EXP       = D.DOM_EXP' || CHR(10) ||
 3676|         '  AND A.FCST_TYPE     = D.FCST_TYPE' || CHR(10) ||
 3677|         '  AND A.INCOTERMS     = D.INCOTERMS' || CHR(10) ||
 3678|         '  AND A.MEASURE       = D.MEASURE' || CHR(10) ||
 3679|         'LEFT OUTER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C' || CHR(10) ||
 3680|         '  ON  C.BASIS_YYYYMMDD = D.YYYYMMDD' || CHR(10) ||
 3681|         'LEFT OUTER JOIN SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL I' || CHR(10) ||
 3682|         '  ON  A.DIVISION_ID = I.DIVISION_ID' || CHR(10) ||
 3683|         '  AND A.PROJECT_CODE = I.PROJECT_CODE' || CHR(10) ||
 3684|         '  AND A.ITEM_ID      = I.ITEM_ID' || CHR(10) ||
 3685|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_MONTH_END C2' || CHR(10) ||
 3686|         '  ON  A.YYYYMMDD = C2.MONTH_END_DATE' || CHR(10) ||
 3687|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_WEEK_END C3' || CHR(10) ||
 3688|         '  ON  A.YYYYMMDD = C3.WEEK_END_DATE' || CHR(10) ||
 3689|         'LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X' || CHR(10) ||
 3690|         '  ON  A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = ''AS_SITE_PLANT''' || CHR(10) ||
 3691|         'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M1' || CHR(10) ||
 3692|         '  ON  A.DIVISION_ID = M1.SEGMENT1' || CHR(10) ||
 3693|         '  AND A.MEASURE     = M1.SEGMENT2' || CHR(10) ||
 3694|         '  AND M1.LOOKUP_TYPE = ''MKT_FCST_MEASURE''' || CHR(10) ||
 3695|         '  AND M1.SEGMENT5    = ''Y''' || CHR(10) ||
 3696|         '  AND M1.VALID_YN    = ''Y''' || CHR(10) ||
 3697|         'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M2' || CHR(10) ||
 3698|         '  ON  A.DIVISION_ID  = M2.SEGMENT1' || CHR(10) ||
 3699|         '  AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
 3700|         '  AND ''[@p_created_by]'' = M2.SEGMENT4' || CHR(10) ||
 3701|         '  AND M2.LOOKUP_TYPE = ''TMM_MEASURE_ADMIN''' || CHR(10) ||
 3702|         '  AND M2.VALID_YN    = ''Y''' || CHR(10) ||
 3703|         'LEFT JOIN SCM_MGR.GT_GGET_VMI_DIO VM' || CHR(10) ||
 3704|         '  ON  A.SCM_SITE_ID = VM.KEY_JOIN' || CHR(10) ||
 3705|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_SSP_SYNC B1' || CHR(10) ||
 3706|         '  ON  A.DIVISION_ID  = B1.DIVISION_ID AND A.PROJECT_CODE = B1.PROJECT_CODE' || CHR(10) ||
 3707|         '  AND A.SCM_SITE_ID  = B1.SCM_SITE_ID  AND A.ITEM_ID     = B1.ITEM_ID' || CHR(10) ||
 3708|         '  AND A.DOM_EXP      = B1.DOM_EXP       AND A.FCST_TYPE   = B1.FCST_TYPE' || CHR(10) ||
 3709|         '  AND A.INCOTERMS    = B1.INCOTERMS     AND A.MEASURE     = ''MKT_FCST_RP''' || CHR(10) ||
 3710|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_BNP B2' || CHR(10) ||
 3711|         '  ON  A.DIVISION_ID  = B2.DIVISION_ID AND A.PROJECT_CODE = B2.PROJECT_CODE' || CHR(10) ||
 3712|         '  AND A.SCM_SITE_ID  = B2.SCM_SITE_ID  AND A.ITEM_ID     = B2.ITEM_ID' || CHR(10) ||
 3713|         '  AND A.DOM_EXP      = B2.DOM_EXP       AND A.FCST_TYPE   = B2.FCST_TYPE' || CHR(10) ||
 3714|         '  AND A.INCOTERMS    = B2.INCOTERMS     AND A.MEASURE     = ''BNPIn''' || CHR(10) ||
 3715|         'LEFT OUTER JOIN (' || CHR(10) ||
 3716|         '    SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS' || CHR(10) ||
 3717|         '         , NVL(V_SUN,0)||NVL(V_MON,0)||NVL(V_TUE,0)||NVL(V_WED,0)' || CHR(10) ||
 3718|         '           ||NVL(V_THU,0)||NVL(V_FRI,0)||NVL(V_SAT,0)              AS BUCKET' || CHR(10) ||
 3719|         '    FROM  (SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD' || CHR(10) ||
 3720|         '                , CASE WHEN BUCKET_PER = ''Y'' THEN 1 ELSE 0 END AS BUCKET_PER' || CHR(10) ||
 3721|         '           FROM  SCM_MGR.DM_MST_BUCKET_CONVERSION' || CHR(10) ||
 3722|         '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || ''') A' || CHR(10) ||
 3723|         '    PIVOT (MAX(BUCKET_PER) FOR YYYYMMDD' || CHR(10) ||
 3724|         '           IN (''SUN'' AS V_SUN,''MON'' AS V_MON,''TUE'' AS V_TUE,''WED'' AS V_WED,' || CHR(10) ||
 3725|         '               ''THU'' AS V_THU,''FRI'' AS V_FRI,''SAT'' AS V_SAT))' || CHR(10) ||
 3726|         ') BK ON A.DIVISION_ID = BK.DIVISION_ID' || CHR(10) ||
 3727|         '     AND A.SCM_SITE_ID = BK.SCM_SITE_ID' || CHR(10) ||
 3728|         '     AND A.INCOTERMS   = BK.INCOTERMS' || CHR(10) ||
 3729|         'LEFT OUTER JOIN (' || CHR(10) ||
 3730|         '    SELECT LOOK.SEGMENT3 AS DEPT_ID' || CHR(10) ||
 3731|         '    FROM   SCM_MGR.SCM_ADM_USER_M USR' || CHR(10) ||
 3732|         '    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK' || CHR(10) ||
 3733|         '      ON   USR.DEPT_ID = LOOK.SEGMENT1' || CHR(10) ||
 3734|         '     AND   LOOK.LOOKUP_TYPE = ''PM_TEAM_MAPPING''' || CHR(10) ||
 3735|         '     AND   LOOK.VALID_YN    = ''Y''' || CHR(10) ||
 3736|         '    WHERE  USR.USER_ID = ''[@p_created_by]''' || CHR(10) ||
 3737|         '    UNION' || CHR(10) ||
 3738|         '    SELECT DEPT_ID FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID = ''[@p_created_by]''' || CHR(10) ||
 3739|         ') MA ON A.DEPT_ID = MA.DEPT_ID' || CHR(10) ||
 3740|         'WHERE 1=1 AND [@v_team_id]' || CHR(10) ||
 3741|         ')' || CHR(10) ||
 3742|         -- ── PIVOT WRAPPER (일별/주별/월별 UNION ALL + PIVOT) ──────────────────────
 3743|         'SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]' || CHR(10) ||
 3744|         'FROM (' || CHR(10) ||
 3745|         '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY' || CHR(10) ||
 3746|         '    FROM   MF_BASE F' || CHR(10) ||
 3747|         '    UNION ALL' || CHR(10) ||
 3748|         '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD' || CHR(10) ||
 3749|         '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
 3750|         '                THEN CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
 3751|         '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
 3752|         '    FROM   MF_BASE F' || CHR(10) ||
 3753|         '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
 3754|         '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
 3755|         '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
 3756|         '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
 3757|         '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
 3758|         '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
 3759|         '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
 3760|         '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
 3761|         '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN' || CHR(10) ||
 3762|         '    UNION ALL' || CHR(10) ||
 3763|         '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD' || CHR(10) ||
 3764|         '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
 3765|         '                THEN CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
 3766|         '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
 3767|         '    FROM   MF_BASE F' || CHR(10) ||
 3768|         '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
 3769|         '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
 3770|         '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
 3771|         '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
 3772|         '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
 3773|         '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
 3774|         '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
 3775|         '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
 3776|         '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN' || CHR(10) ||
 3777|         ') F' || CHR(10) ||
 3778|         'PIVOT (SUM(QTY) FOR YYYYMMDD IN ([@V_PV_LIST])) PVT' || CHR(10) ||
 3779|         '[@V_ORDERBY]';
 3780| 
 3781| 
 3782|     ELSE
 3783| 
 3784|         -- -----------------------------------------------------------------------
 3785|         -- 비AS 경로 보완 처리: LP_AS_YN='Y' → AS_IN_REQ/PLAN/INV 빈 행 추가
 3786|         -- -----------------------------------------------------------------------
 3787| 		-- IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' AND AND LP_AS_YN = 'Y' THEN
 3788|         IF LP_AS_YN = 'Y' THEN
 3789|             DECLARE
 3790|                 V_AS_CNT2 PLS_INTEGER := 0;
 3791|             BEGIN
 3792|                 SELECT COUNT(1) INTO V_AS_CNT2
 3793|                 FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 3794|                 WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV');
 3795| 
 3796|                 IF V_AS_CNT2 > 0 THEN
 3797|                     -- AS 사이트에 해당하는 조합 중 AS 메저가 없는 날짜에 QTY=0 행 삽입
 3798|                     INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 3799|                     ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 3800|                     , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
 3801|                     , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 3802|                     , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
 3803|                     , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER
 3804|                     , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
 3805|                     , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
 3806|                     , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 3807|                     , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
 3808|                     , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
 3809|                     , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 3810|                     , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 3811|                     SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
 3812|                          , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
 3813|                          , C.MEASURE
 3814|                          , A.YYYYMMDD   -- MAX(YYYYMMDD) 기준 날짜 사용
 3815|                          , 0  AS QTY
 3816|                          , C.MEASURE_GROUP
 3817|                          , A.CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
 3818|                          , A.DMS_SALES, A.DMS_CUSTOMER, A.OWNER, A.DEPT_ID, A.DEPT_NAME_KO
 3819|                          , A.FORECAST_INFO_CELL_PACK_COUNT, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER
 3820|                          , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
 3821|                          , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
 3822|                          , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
 3823|                          , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
 3824|                          , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
 3825|                          , C.SORT_ORDER_NO
 3826|                          , A.ENERGE, A.CELL_QUANTITY
 3827|                          , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
 3828|                     FROM (
 3829|                         -- AS 사이트 기반 헤더 (최신 YYYYMMDD)
 3830|                         SELECT A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
 3831|                              , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
 3832|                              , MAX(A2.YYYYMMDD) AS YYYYMMDD
 3833|                              , 0 AS QTY
 3834|                              , A2.CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
 3835|                              , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.OWNER, A2.DEPT_ID, A2.DEPT_NAME_KO
 3836|                              , A2.FORECAST_INFO_CELL_PACK_COUNT, A2.ITEM_TYPE, A2.PROJECT_NAME, A2.PROJECT_OWNER
 3837|                              , A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER, A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS
 3838|                              , A2.ITEM_NAME, A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL
 3839|                              , A2.APPLICATION, A2.ROUTE, A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY
 3840|                              , A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
 3841|                              , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
 3842|                              , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
 3843|                              , A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
 3844|                              , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
 3845|                         FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA A2
 3846|                         JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B2
 3847|                           ON   A2.SCM_SITE_ID = B2.SEGMENT1
 3848|                          AND   B2.LOOKUP_TYPE = 'AS_SITE_PLANT'
 3849|                          AND   B2.SEGMENT3    = P_DIVISION_ID
 3850|                         GROUP  BY A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
 3851|                                ,  A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
 3852|                                ,  A2.CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
 3853|                                ,  A2.DMS_SALES, A2.DMS_CUSTOMER, A2.OWNER, A2.DEPT_ID, A2.DEPT_NAME_KO
 3854|                                ,  A2.FORECAST_INFO_CELL_PACK_COUNT, A2.ITEM_TYPE, A2.PROJECT_NAME, A2.PROJECT_OWNER
 3855|                                ,  A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER, A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS
 3856|                                ,  A2.ITEM_NAME, A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL
 3857|                                ,  A2.APPLICATION, A2.ROUTE, A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY
 3858|                                ,  A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
 3859|                                ,  A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
 3860|                                ,  A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
 3861|                                ,  A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
 3862|                                ,  A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
 3863|                     ) A
 3864|                     -- AS_IN_REQ/PLAN/INV 메저 CROSS JOIN
 3865|                     JOIN (
 3866|                         SELECT MEASURE, MEASURE_GROUP, SORT_ORDER_NO
 3867|                         FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 3868|                         WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV')
 3869|                     ) C ON 1=1
 3870|                     -- 이미 존재하는 조합 제외
 3871|                     LEFT OUTER JOIN (
 3872|                         SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3873|                                       , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
 3874|                         FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA D2
 3875|                         JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B3
 3876|                           ON   D2.SCM_SITE_ID = B3.SEGMENT1
 3877|                          AND   B3.LOOKUP_TYPE = 'AS_SITE_PLANT'
 3878|                          AND   B3.SEGMENT3    = P_DIVISION_ID
 3879|                     ) D ON  A.DIVISION_ID   = D.DIVISION_ID
 3880|                         AND A.PROJECT_CODE  = D.PROJECT_CODE
 3881|                         AND A.SCM_SITE_ID   = D.SCM_SITE_ID
 3882|                         AND A.ITEM_ID       = D.ITEM_ID
 3883|                         AND A.DOM_EXP       = D.DOM_EXP
 3884|                         AND A.FCST_TYPE     = D.FCST_TYPE
 3885|                         AND A.INCOTERMS     = D.INCOTERMS
 3886|                         AND C.MEASURE       = D.MEASURE
 3887|                         AND A.PLANT_SITE_ID = D.PLANT_SITE_ID
 3888|                     WHERE D.DIVISION_ID IS NULL;
 3889|                 END IF;
 3890|             END;
 3891|         END IF;
 3892| 
 3893|         -- -----------------------------------------------------------------------
 3894|         -- PIVOT SQL #2 (비AS용, 일반 경로)
 3895|         --   소스: GT_GGET_MKT_FCST_DATA  → #MF (임시)
 3896|         --         → PIVOT + EXECUTE IMMEDIATE
 3897|         -- -----------------------------------------------------------------------
 3898|         V_SQL_TEXT :=
 3899|         'WITH MF_BASE AS (' || CHR(10) ||
 3900|         'SELECT' || CHR(10) ||
 3901|         '      A.DIVISION_ID' || CHR(10) ||
 3902|         '    , A.DIVISION_ID                                         AS DIVISION_ID40' || CHR(10) ||
 3903|         '    , A.SCM_SITE_ID' || CHR(10) ||
 3904|         '    , A.SCM_SITE_ID                                         AS SCM_SITE_ID40' || CHR(10) ||
 3905|         '    , A.PLANT_SITE_ID' || CHR(10) ||
 3906|         '    , A.PROJECT_CODE' || CHR(10) ||
 3907|         '    , NVL(I.GROUP_ID,'''')                                  AS GROUP_ID' || CHR(10) ||
 3908|         '    , A.ITEM_ID' || CHR(10) ||
 3909|         '    , A.ITEM_ID                                             AS ITEM_ID40' || CHR(10) ||
 3910|         '    , A.INCOTERMS' || CHR(10) ||
 3911|         '    , A.FCST_TYPE' || CHR(10) ||
 3912|         '    , A.DOM_EXP' || CHR(10) ||
 3913|         '    , A.MEASURE' || CHR(10) ||
 3914|         '    , A.END_CUSTOMER' || CHR(10) ||
 3915|         '    , CASE WHEN (A.DIVISION_ID LIKE ''81%'' OR A.DIVISION_ID = ''82'')' || CHR(10) ||
 3916|         '           THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END      AS END_CUSTOMER40' || CHR(10) ||
 3917|         '    , A.NICK_NAME' || CHR(10) ||
 3918|         '    , A.DMS_SALES' || CHR(10) ||
 3919|         '    , A.DMS_CUSTOMER' || CHR(10) ||
 3920|         '    , C.BASIS_YYYYMM                                        AS YYYYMM' || CHR(10) ||
 3921|         '    , C.BASIS_YYYYMM || C.ISO_WEEK                          AS YYYYMMWW' || CHR(10) ||
 3922|         '    , C.BASIS_YYYYMMDD                                      AS YYYYMMDD' || CHR(10) ||
 3923|         '    , C.DAYOFWEEK' || CHR(10) ||
 3924|         '    , A.CELL_MODEL                                          AS FORECAST_INFO_CELL_MODEL' || CHR(10) ||
 3925|         '    , A.DEPT_ID                                             AS TEAM_ID' || CHR(10) ||
 3926|         '    , A.DEPT_NAME_KO                                        AS TEAM_NAME_KO' || CHR(10) ||
 3927|         '    , A.ITEM_TYPE' || CHR(10) ||
 3928|         '    , A.PROJECT_NAME' || CHR(10) ||
 3929|         '    , A.PROJECT_OWNER' || CHR(10) ||
 3930|         '    , A.OWNER' || CHR(10) ||
 3931|         '    , A.BIZ_TYPE' || CHR(10) ||
 3932|         '    , A.SOLDTO_CUSTOMER' || CHR(10) ||
 3933|         '    , A.COUNTRY_NAME' || CHR(10) ||
 3934|         '    , A.CITY_NAME' || CHR(10) ||
 3935|         '    , A.PROJECT_STATUS' || CHR(10) ||
 3936|         '    , A.ITEM_NAME' || CHR(10) ||
 3937|         '    , A.VMI_YN' || CHR(10) ||
 3938|         '    , A.CUST_GROUP' || CHR(10) ||
 3939|         '    , A.CUST_GROUP_DTL' || CHR(10) ||
 3940|         '    , A.APPLICATION' || CHR(10) ||
 3941|         '    , A.ROUTE' || CHR(10) ||
 3942|         '    , A.MDM_PROJECT_NAME' || CHR(10) ||
 3943|         '    , A.MIN_CAPACITY' || CHR(10) ||
 3944|         '    , A.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
 3945|         '    , A.CELL_TYPE' || CHR(10) ||
 3946|         '    , A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
 3947|         '    , A.FORECAST_INFO_ALL' || CHR(10) ||
 3948|         '    , A.FORECAST_INFO_SPEC' || CHR(10) ||
 3949|         '    , A.FORECAST_INFOR_VERSION' || CHR(10) ||
 3950|         '    , A.CELL_MODEL_NICK_NAME' || CHR(10) ||
 3951|         '    , CAST(CASE WHEN ''Y'' = ''[@CellQtyYN]''' || CHR(10) ||
 3952|         '                 AND A.MEASURE_GROUP NOT IN (''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'')' || CHR(10) ||
 3953|         '                 AND NVL(A.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1' || CHR(10) ||
 3954|         '                THEN A.QTY * A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
 3955|         '                ELSE A.QTY END AS NUMBER(36,10)) AS QTY' || CHR(10) ||
 3956|         '    , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS MONTH_END_YN' || CHR(10) ||
 3957|         '    , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN ''Y'' ELSE ''N'' END AS WEEK_END_YN' || CHR(10) ||
 3958|         '    , CASE' || CHR(10) ||
 3959|         '          WHEN MA.DEPT_ID IS NOT NULL' || CHR(10) ||
 3960|         '               AND A.MEASURE_GROUP NOT IN (''CUST_FCST_2'',''CUST_FCST_3'',''TMM_FCST'')' || CHR(10) ||
 3961|         '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
 3962|         '          WHEN ''[@v_group_id]'' = ''ADMIN''' || CHR(10) ||
 3963|         '               AND A.MEASURE_GROUP <> ''TMM_FCST''' || CHR(10) ||
 3964|         '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
 3965|         '          WHEN A.MEASURE_GROUP = ''TMM_FCST''' || CHR(10) ||
 3966|         '               AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
 3967|         '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
 3968|         '          ELSE ''N''' || CHR(10) ||
 3969|         '      END AS EDIT_FLAG' || CHR(10) ||
 3970|         '    , A.CELL_PER_CAR' || CHR(10) ||
 3971|         '    , A.CELL_PER_MODULE' || CHR(10) ||
 3972|         '    , A.MODULE_PER_CAR' || CHR(10) ||
 3973|         '    , A.SORT_ORDER_NO' || CHR(10) ||
 3974|         '    , A.MEASURE_GROUP' || CHR(10) ||
 3975|         '    , A.ENERGE' || CHR(10) ||
 3976|         '    , A.CELL_QUANTITY' || CHR(10) ||
 3977|         '    , ''N''                                                 AS NEW_FLAG' || CHR(10) ||
 3978|         '    , CASE WHEN A.DIVISION_ID = ''40''' || CHR(10) ||
 3979|         '           THEN TO_CHAR(CAST(VM.VMI_STD_DIO AS NUMBER))' || CHR(10) ||
 3980|         '           ELSE VM.VMI_VAL END                              AS VMI_STD_DIO' || CHR(10) ||
 3981|         '    , NVL(B1.ATTR1, B2.ATTR1)                              AS ATTR1' || CHR(10) ||
 3982|         '    , NVL(BK.BUCKET,''0000000'')                           AS BUCKET' || CHR(10) ||
 3983|         '    , ''' || LP_AS_YN || '''                                AS AS_YN' || CHR(10) ||
 3984|         '    , CASE WHEN ''' || LP_AS_YN || ''' = ''Y'' THEN NVL(X.DISPLAY_SEQ,999) ELSE 999 END AS SORT_KEY' || CHR(10) ||
 3985|         '    , NVL(A.AS_FROM_SITE,'''')                             AS AS_FROM_SITE' || CHR(10) ||
 3986|         '    , CASE WHEN A.CREATE_DATE IS NULL OR NVL(A.CREATE_DATE,'''')    = '''' THEN '' '' ELSE A.CREATE_DATE    END AS LAST_UPDATE_DATE' || CHR(10) ||
 3987|         '    , CASE WHEN A.LAST_UPDATED_BY IS NULL OR NVL(A.LAST_UPDATED_BY,'''')= '''' THEN '' '' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY' || CHR(10) ||
 3988|         '    , CASE WHEN A.SENDER_CODE IS NULL OR NVL(A.SENDER_CODE,'''')    = '''' THEN '' '' ELSE A.SENDER_CODE    END AS SENDER_CODE' || CHR(10) ||
 3989|         '    , CASE WHEN A.SENDER_NAME IS NULL OR NVL(A.SENDER_NAME,'''')    = '''' THEN '' '' ELSE A.SENDER_NAME    END AS SENDER_NAME' || CHR(10) ||
 3990|         '    , A.NOTATION' || CHR(10) ||
 3991|         'FROM SCM_MGR.GT_GGET_MKT_FCST_DATA A' || CHR(10) ||
 3992|         'INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C' || CHR(10) ||
 3993|         '  ON  C.BASIS_YYYYMMDD = A.YYYYMMDD' || CHR(10) ||
 3994|         'LEFT OUTER JOIN SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL I' || CHR(10) ||
 3995|         '  ON  A.DIVISION_ID = I.DIVISION_ID' || CHR(10) ||
 3996|         '  AND A.PROJECT_CODE = I.PROJECT_CODE' || CHR(10) ||
 3997|         '  AND A.ITEM_ID      = I.ITEM_ID' || CHR(10) ||
 3998|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_MONTH_END C2' || CHR(10) ||
 3999|         '  ON  A.YYYYMMDD = C2.MONTH_END_DATE' || CHR(10) ||
 4000|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_WEEK_END C3' || CHR(10) ||
 4001|         '  ON  A.YYYYMMDD = C3.WEEK_END_DATE' || CHR(10) ||
 4002|         'LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X' || CHR(10) ||
 4003|         '  ON  A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = ''AS_SITE_PLANT''' || CHR(10) ||
 4004|         'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M1' || CHR(10) ||
 4005|         '  ON  A.DIVISION_ID = M1.SEGMENT1' || CHR(10) ||
 4006|         '  AND A.MEASURE     = M1.SEGMENT2' || CHR(10) ||
 4007|         '  AND M1.LOOKUP_TYPE = ''MKT_FCST_MEASURE''' || CHR(10) ||
 4008|         '  AND M1.SEGMENT5    = ''Y''' || CHR(10) ||
 4009|         '  AND M1.VALID_YN    = ''Y''' || CHR(10) ||
 4010|         'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M2' || CHR(10) ||
 4011|         '  ON  A.DIVISION_ID  = M2.SEGMENT1' || CHR(10) ||
 4012|         '  AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
 4013|         '  AND ''[@p_created_by]'' = M2.SEGMENT4' || CHR(10) ||
 4014|         '  AND M2.LOOKUP_TYPE = ''TMM_MEASURE_ADMIN''' || CHR(10) ||
 4015|         '  AND M2.VALID_YN    = ''Y''' || CHR(10) ||
 4016|         'LEFT JOIN SCM_MGR.GT_GGET_VMI_DIO VM' || CHR(10) ||
 4017|         '  ON  A.ITEM_ID     = CASE WHEN ''' || P_DIVISION_ID || ''' = ''40'' THEN VM.KEY_JOIN ELSE A.ITEM_ID END' || CHR(10) ||
 4018|         '  AND ( ''' || P_DIVISION_ID || ''' = ''40''  ' || CHR(10) ||
 4019|         '        OR A.SCM_SITE_ID = VM.KEY_JOIN )' || CHR(10) ||
 4020|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_SSP_SYNC B1' || CHR(10) ||
 4021|         '  ON  A.DIVISION_ID  = B1.DIVISION_ID AND A.PROJECT_CODE = B1.PROJECT_CODE' || CHR(10) ||
 4022|         '  AND A.SCM_SITE_ID  = B1.SCM_SITE_ID  AND A.ITEM_ID     = B1.ITEM_ID' || CHR(10) ||
 4023|         '  AND A.DOM_EXP      = B1.DOM_EXP       AND A.FCST_TYPE   = B1.FCST_TYPE' || CHR(10) ||
 4024|         '  AND A.INCOTERMS    = B1.INCOTERMS     AND A.MEASURE     = ''MKT_FCST_RP''' || CHR(10) ||
 4025|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_BNP B2' || CHR(10) ||
 4026|         '  ON  A.DIVISION_ID  = B2.DIVISION_ID AND A.PROJECT_CODE = B2.PROJECT_CODE' || CHR(10) ||
 4027|         '  AND A.SCM_SITE_ID  = B2.SCM_SITE_ID  AND A.ITEM_ID     = B2.ITEM_ID' || CHR(10) ||
 4028|         '  AND A.DOM_EXP      = B2.DOM_EXP       AND A.FCST_TYPE   = B2.FCST_TYPE' || CHR(10) ||
 4029|         '  AND A.INCOTERMS    = B2.INCOTERMS     AND A.MEASURE     = ''BNPIn''' || CHR(10) ||
 4030|         'LEFT OUTER JOIN (' || CHR(10) ||
 4031|         '    SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS' || CHR(10) ||
 4032|         '         , NVL(V_SUN,0)||NVL(V_MON,0)||NVL(V_TUE,0)||NVL(V_WED,0)' || CHR(10) ||
 4033|         '           ||NVL(V_THU,0)||NVL(V_FRI,0)||NVL(V_SAT,0)              AS BUCKET' || CHR(10) ||
 4034|         '    FROM  (SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD' || CHR(10) ||
 4035|         '                , CASE WHEN BUCKET_PER = ''Y'' THEN 1 ELSE 0 END AS BUCKET_PER' || CHR(10) ||
 4036|         '           FROM  SCM_MGR.DM_MST_BUCKET_CONVERSION' || CHR(10) ||
 4037|         '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || ''') A' || CHR(10) ||
 4038|         '    PIVOT (MAX(BUCKET_PER) FOR YYYYMMDD' || CHR(10) ||
 4039|         '           IN (''SUN'' AS V_SUN,''MON'' AS V_MON,''TUE'' AS V_TUE,''WED'' AS V_WED,' || CHR(10) ||
 4040|         '               ''THU'' AS V_THU,''FRI'' AS V_FRI,''SAT'' AS V_SAT))' || CHR(10) ||
 4041|         ') BK ON A.DIVISION_ID = BK.DIVISION_ID' || CHR(10) ||
 4042|         '     AND A.SCM_SITE_ID = BK.SCM_SITE_ID' || CHR(10) ||
 4043|         '     AND A.INCOTERMS   = BK.INCOTERMS' || CHR(10) ||
 4044|         'LEFT OUTER JOIN (' || CHR(10) ||
 4045|         '    SELECT LOOK.SEGMENT3 AS DEPT_ID' || CHR(10) ||
 4046|         '    FROM   SCM_MGR.SCM_ADM_USER_M USR' || CHR(10) ||
 4047|         '    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK' || CHR(10) ||
 4048|         '      ON   USR.DEPT_ID = LOOK.SEGMENT1' || CHR(10) ||
 4049|         '     AND   LOOK.LOOKUP_TYPE = ''PM_TEAM_MAPPING''' || CHR(10) ||
 4050|         '     AND   LOOK.VALID_YN    = ''Y''' || CHR(10) ||
 4051|         '    WHERE  USR.USER_ID = ''[@p_created_by]''' || CHR(10) ||
 4052|         '    UNION' || CHR(10) ||
 4053|         '    SELECT DEPT_ID FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID = ''[@p_created_by]''' || CHR(10) ||
 4054|         ') MA ON A.DEPT_ID = MA.DEPT_ID' || CHR(10) ||
 4055|         'WHERE 1=1 AND [@v_team_id]' || CHR(10) ||
 4056|         ')' || CHR(10) ||
 4057|         -- ── PIVOT WRAPPER (동일) ──────────────────────────────────────────────────
 4058|         'SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]' || CHR(10) ||
 4059|         'FROM (' || CHR(10) ||
 4060|         '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY' || CHR(10) ||
 4061|         '    FROM   MF_BASE F' || CHR(10) ||
 4062|         '    UNION ALL' || CHR(10) ||
 4063|         '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD' || CHR(10) ||
 4064|         '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
 4065|         '                THEN CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
 4066|         '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
 4067|         '    FROM   MF_BASE F' || CHR(10) ||
 4068|         '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
 4069|         '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
 4070|         '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
 4071|         '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
 4072|         '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
 4073|         '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
 4074|         '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
 4075|         '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
 4076|         '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN' || CHR(10) ||
 4077|         '    UNION ALL' || CHR(10) ||
 4078|         '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD' || CHR(10) ||
 4079|         '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
 4080|         '                THEN CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
 4081|         '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
 4082|         '    FROM   MF_BASE F' || CHR(10) ||
 4083|         '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
 4084|         '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
 4085|         '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
 4086|         '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
 4087|         '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
 4088|         '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
 4089|         '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
 4090|         '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
 4091|         '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN' || CHR(10) ||
 4092|         ') F' || CHR(10) ||
 4093|         'PIVOT (SUM(QTY) FOR YYYYMMDD IN ([@V_PV_LIST])) PVT' || CHR(10) ||
 4094|         '[@V_ORDERBY]';
 4095| 
 4096|     END IF;
 4097| 
 4098| 
 4099| 
 4100|     -----------------------------------------------------------------------
 4101|     -- 플레이스홀더 치환
 4102|     -----------------------------------------------------------------------
 4103|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_COL_LIST]',  V_PV_COL_LIST);
 4104|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_LIST]',      V_PV_LIST);
 4105|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_COLUMN]',       V_COLUMN);
 4106|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_groupby]',      V_GROUPBY);
 4107|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_team_id]',      V_TEAM_WHERE);
 4108|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_created_by]',   P_CREATED_BY);
 4109|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_group_id]',     V_GROUP_ID);
 4110|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_orderby]',      V_ORDERBY);
 4111|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_ORDERBY]',      V_ORDERBY);
 4112|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_from_yyyymmdd]',P_FROM_YYYYMMDD);
 4113|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_to_yyyymmdd]',  P_TO_YYYYMMDD);
 4114|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@CellQtyYN]',      P_CELL_YN);
 4115|     -- 종료 LOG
 4116|     V_LOG_TYPE    := 'END';
 4117|     V_LOG_MESSAGE := '########## END of procedure ##########';
 4118|     V_DESCRIPTION := '-';
 4119|     D_EVENT_DATE  := SYSDATE;
 4120|     BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
 4121| 
 4122|     -----------------------------------------------------------------------
 4123|     -- EXECUTE IMMEDIATE → O_RC 반환
 4124|     -----------------------------------------------------------------------
 4125|     DBMS_OUTPUT.PUT_LINE(V_SQL_TEXT);
 4126|     OPEN O_RC1 FOR V_SQL_TEXT;
 4127| 
 4128|     -----------------------------------------------------------------------
 4129|     -- O_RC2: 8주 이내 버킷 정보 (20181115 소형 사업부 일별 입력 전용)
 4130|     -- 원본: SELECT TOP 1 * FROM SCM_SYS_CALENDAR_M
 4131|     --       WHERE ISO_WEEK = DATEPART(ISO_WEEK, DATEADD(WEEK,7,GETDATE()))
 4132|     --         AND CALENDAR_YYYY = DATEPART(YEAR, DATEADD(WEEK,7,GETDATE()))
 4133|     --       ORDER BY BASIS_YYYYMMDD
 4134|     -----------------------------------------------------------------------
 4135|     OPEN O_RC2 FOR
 4136|         SELECT *
 4137|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M
 4138|         WHERE  ISO_YYYYWW  = TO_CHAR(SYSDATE + (7*7), 'IYYY') ||
 4139|                              TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE + (7*7), 'IW')), 'FM00')
 4140|         ORDER  BY BASIS_YYYYMMDD
 4141|         FETCH  FIRST 1 ROW ONLY;
 4142| 
 4143|     -----------------------------------------------------------------------
 4144|     -- O_RC3: 현재 주차 정보 (20211130)
 4145|     -- 원본: SELECT 'M_'+THIS_YYYYMM, 'W_'+THIS_YYYYMMWW, ...
 4146|     --                현재주 + 전주 정보
 4147|     -----------------------------------------------------------------------
 4148|     OPEN O_RC3 FOR
 4149|         SELECT 'M_' || A.BASIS_YYYYMM                         AS THIS_YYYYMM
 4150|              , 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK           AS THIS_YYYYMMWW
 4151|              , A.BASIS_DATE
 4152|              , 'M_' || B.BASIS_YYYYMM                         AS PRE_YYYYMM
 4153|              , 'W_' || B.BASIS_YYYYMM || B.ISO_WEEK           AS PRE_YYYYMMWW
 4154|              , A.BASIS_YYYYMM, A.ISO_WEEK
 4155|         FROM   (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
 4156|                 FROM   SCM_MGR.SCM_SYS_CALENDAR_M
 4157|                 WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')) A
 4158|         JOIN   (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
 4159|                 FROM   SCM_MGR.SCM_SYS_CALENDAR_M
 4160|                 WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE - 7, 'YYYYMMDD')) B ON 1=1;
 4161| 
 4162|     OPEN O_RESULT_CURSOR FOR
 4163|     SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
 4164| 
 4165| EXCEPTION
 4166|     WHEN OTHERS THEN
 4167|         ROLLBACK;
 4168|         V_LOG_TYPE    := 'ERROR';
 4169|         V_LOG_MESSAGE := 'EXCEPTION';
 4170|         V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
 4171|         D_EVENT_DATE  := SYSDATE;
 4172|         V_SQL_CODE    := TO_CHAR(SQLCODE);
 4173|         V_SQL_ERRMSG  := SQLERRM;
 4174| 
 4175|         V_PROC_INPUT := JSON_OBJECT(
 4176|             'P_DIVISION_ID'   VALUE P_DIVISION_ID,
 4177|             'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
 4178|             'P_PLANT_SITE_ID' VALUE P_PLANT_SITE_ID,
 4179|             'P_FROM_YYYYMMDD' VALUE P_FROM_YYYYMMDD,
 4180|             'P_TO_YYYYMMDD'   VALUE P_TO_YYYYMMDD,
 4181|             'P_CREATED_BY'    VALUE P_CREATED_BY,
 4182|             'P_USER_GROUP'    VALUE P_USER_GROUP,
 4183|             'P_ITEM_ID'       VALUE P_ITEM_ID
 4184|         );
 4185|         V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
 4186| 
 4187|         BEGIN
 4188|             SCM_MGR.PR_DM_SYS_LOG_BATCH(
 4189|                 V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE,
 4190|                 V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY, V_PROC_INPUT,
 4191|                 V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
 4192|             );
 4193|         END;
 4194| 
 4195|         RAISE_APPLICATION_ERROR(-20001,
 4196|             '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE
 4197|          || ' / SQLERRM='   || V_SQL_ERRMSG
 4198|          || ' / BACKTRACE=' || V_BACKTRACE
 4199|          || ' / PARAMS='    || V_PROC_INPUT
 4200|         );
 4201| 
 4202| END DMF0003_GET_MKT_FCST_DATA;

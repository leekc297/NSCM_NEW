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
  114|  * 2021.11.30		rosia27		[C20211122-000414]속도개선을 위한 색구현 및 조회조건 변경안
  115|  * 2021.12.07		rosia27		[C20211130-000420][ESS영업관리팀] RTF{R+P] Energy Measure MWh 단위로 수정 요청의 건
  116|  * 2021.12.15		kdw2819		[C20211215-000076] 1년 이상 조회기간을 설정하여도 가능하도록 변경 건
  117|  * 2022.01.06		hwi1993		[] sales_type_code 룩업의 as 전용 fcst type 을 사용할수 없게 되어서, as 구분방법 변경
  118| 								( 고객향은 attribute10, 플랜트향은 scm_site_id 이용 )
  119|  * 2022.02.07		kdw2819		[C20220125-000192] MKT FSCT 상 From stie 표기 요청의 건
  120|  * 2022.02.24		HWI1993		[C20220218-000409] GSCM-DM AS Inventory 메저 계산 로직 수정 -- INV 메저 표시방법 변경, INTRANSIT 메저의 ATTR10 오류 수정
  121|  * 2022.04.05		rosia27		[과제PJ20216891R]GM_JV
  122|  * 2022.12.14		rosia27		[C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
  123|  * 2023.03.13		rosia27		[E20230308-000315] [시스템 오류] Owner 조회조건 수정 요청 건
  124|  * 2023.05.03		kdmcc14		[EDI과제]
  125|  * 2023.08.25		JSSBAE		[E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청(LOOKUP이용)
  126|  * 2023.10.19		JSSBAE		[E20231018-000776]_[영업/마케팅 PI팀] MKT FCST 화면 SHIPMENT_PLAN 메저 로직 수정 프로그램 화면 내 메져의 VALID가 Y인 대상만 나오도록 수정
  127|  * 2023.11.21		chano0612	[고객수요분석시스템 정비] EDI데이터 중복건 제거
  128|  * 2023.12.07		kcw3408		[개발요청] 수요분석시스템_4_고객수요 Measure 통합
  129|  * 2024.01.15		JSSBAE		[E20240102-000545] [마케팅PI] 82번 사업부 - VMI표기 로직 개선
  130|  * 2024.03.07       kcw3408     DM 프로시저 속도개선(CNS 전정관 책임님이 지원)
  131|  * 2024.05.17       kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
  132|  * 2024.07.18		JSSBAE		[E20240712-001683]_'MKT FCST 미등록제외' 관련 소스 수정
  133|  * 2024.08.02		JSSBAE		[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선
  134|  * 2024.09.05		JSSBAE		[E20240812-000094]_82사업부 MKT FCST 화면 Energy Measure 소수점 자리수 수정 요청
  135|  * 2024.08.27		KJJ			[PJ2024-50461] Team Mapping
  136|  * 2024.09.12		JSSBAE		[E20240920-000300]_SCM.DM 화면 조회 속도 개선
  137|  * 2024.11.04		JSSBAE		[E20241030-000923]_MKT FCST, MKT FCST Waterfall 화면 신규 컬럼 추가 요청 건
  138|  *                              SSPM에 신규 추가 요청드린 'Project(S&OP Report)' 컬럼 MKT FCST Waterfall 사용자 화면에 추가 요청
  139|  * 2024.11.12		JSSBAE		[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건
  140|  * 2024.12.04		JSSBAE		[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정
  141|  * 2025.07.07		KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
  142|  * 2026.01.23		JSSBAE		[E20260123-001715]_E20241015-000415 CSR 원복 요청
  143|  * 2026.02.20		JSSBAE		[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
  144|  * 2026.04.13       kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
  145|  *                                  SCM_MST_SITE_ITEM Table PROJECT_S_OP_REPORT Column 삭제에 따라 컬럼 사용 문장 삭제
  146|  *                                  ORA-01799: a column may not be outer-joined to a subquery 방지용으로 불필요한 outer join 제거
  147|  EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='40', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
  148| 	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
  149| 	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='N', @p_cell_yn='N', @p_invalid_exec='N', @p_as_yn='N', @p_user_dept_id='58235660',@p_sender_code='ALL'
  150|  EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='81', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
  151| 	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
  152| 	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='N', @p_cell_yn='N', @p_invalid_exec='N', @p_as_yn='N', @p_user_dept_id='58235660',@p_sender_code='ALL'
  153|  EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='82', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
  154| 	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
  155| 	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='N', @p_cell_yn='N', @p_invalid_exec='N', @p_as_yn='N', @p_user_dept_id='58235660',@p_sender_code='ALL'
  156|  *===================================================================================================================================================*/
  157| -- 2026-05-11 전병주 컴파일 오류 수정
  158| AS
  159|     -- 프로그램명 (로그용)
  160|     V_PROGRAM_NAME      VARCHAR2(150);
  161| 
  162|     -- 동적 SQL / PIVOT 관련
  163|     V_SQL_TEXT          CLOB;
  164|     V_PV_LIST           CLOB    := '';
  165|     V_PV_COL_LIST       CLOB    := '';
  166|     V_PV_COLUMN_NAME    VARCHAR2(1000);
  167|     V_PV_NAME           VARCHAR2(200);
  168|     V_SORT_ORDER_NO     VARCHAR2(50);
  169|     V_COLUMN_NAME       VARCHAR2(100);
  170|     V_COLUMN            CLOB    := '';
  171|     V_GROUPBY           CLOB    := '';
  172|     V_ORDERBY           CLOB    := '';
  173| 
  174|     -- 프로그램 / 시트 고정값
  175|     VA_PROGRAM_ID       VARCHAR2(50)  := 'DMF0003';
  176|     VA_SHEET_NAME       VARCHAR2(50)  := 'Mkt Fcst';
  177| 
  178|     -- 권한 / 부서
  179|     V_GROUP_ID          VARCHAR2(50)  := '';
  180|     V_DEPT_ID           VARCHAR2(50)  := '';
  181| 
  182|     -- 조회 구간 날짜 변수
  183|     V_EXP_YYYYMMDD      VARCHAR2(8);
  184|     V_FROM_YYYYMMDD     VARCHAR2(8)   := '';   -- 계획 구간 FROM (당주 월요일 기준)
  185|     V_TO_YYYYMMDD       VARCHAR2(8)   := '';   -- 계획 구간 TO
  186|     V_FROM_RESULT       VARCHAR2(8)   := '';   -- 실적 구간 FROM
  187|     V_TO_RESULT         VARCHAR2(8)   := '';   -- 실적 구간 TO
  188|     V_USER_TIME_ZONE    VARCHAR2(50)  := '';
  189| 
  190|     -- 사용자 컬럼/메저 카운트
  191|     V_USER_COL_CNT      PLS_INTEGER   := 0;
  192|     V_USER_MEA_CNT      PLS_INTEGER   := 0;
  193| 
  194|     -- IN 파라미터를 로컬 복사본으로 사용 (IN 파라미터 직접 수정 불가)
  195|     LP_AS_YN            VARCHAR2(1);
  196|     LP_SCM_SITE_ID      VARCHAR2(4000);
  197|     LP_PROJECT_CODE     VARCHAR2(4000);
  198| 
  199|     -- 팀 WHERE 조건 (동적 SQL에 삽입)
  200|     V_TEAM_WHERE        VARCHAR2(4000);
  201| 
  202|     -- 예외처리 / 로그 변수
  203|     V_LOG_TYPE          VARCHAR2(30);
  204|     V_LOG_MESSAGE       VARCHAR2(1000);
  205|     V_DESCRIPTION       VARCHAR2(500);
  206|     D_EVENT_DATE        DATE;
  207|     V_SQL_CODE          VARCHAR2(20);
  208|     V_SQL_ERRMSG        VARCHAR2(4000);
  209|     V_BACKTRACE         VARCHAR2(4000);
  210|     V_PROC_INPUT        CLOB;
  211| 
  212|     -- T_SSP_SYNC 컬렉션용
  213|     T_SCM_SITE_IDS      SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();
  214| 
  215| BEGIN
  216|     -----------------------------------------------------------------------
  217|     -- 프로그램명 설정
  218|     -----------------------------------------------------------------------
  219|     IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
  220|         V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
  221|     ELSE
  222|         V_PROGRAM_NAME := $$PLSQL_UNIT;
  223|     END IF;
  224| 
  225|     -- IN 파라미터 로컬 복사
  226|     LP_AS_YN        := P_AS_YN;
  227|     LP_SCM_SITE_ID  := P_SCM_SITE_ID;
  228|     LP_PROJECT_CODE := P_PROJECT_CODE;
  229| 
  230|     -- 시작 LOG
  231|     V_LOG_TYPE    := 'START';
  232|     V_LOG_MESSAGE := '########## Start of procedure ##########';
  233|     V_DESCRIPTION := '-';
  234|     D_EVENT_DATE  := SYSDATE;
  235|     BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
  236|     V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
  237| 
  238|     -----------------------------------------------------------------------
  239|     -- GTT 초기화 (세션 재사용 시 이전 데이터 제거)
  240|     -----------------------------------------------------------------------
  241|     DELETE FROM SCM_MGR.GT_GGET_T_SSP_SYNC;
  242|     DELETE FROM SCM_MGR.GT_GGET_T_BNP;
  243|     DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_ORI;
  244|     DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_A;
  245|     DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_B;
  246|     DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_V;
  247|     DELETE FROM SCM_MGR.GT_GGET_SELECT_MEASURE;
  248|     DELETE FROM SCM_MGR.GT_GGET_VMI_DIO;
  249|     DELETE FROM SCM_MGR.GT_GGET_SITE_ITEM_ALL;
  250|     DELETE FROM SCM_MGR.GT_GGET_SITE_ITEM;
  251|     DELETE FROM SCM_MGR.GT_GGET_MKT_FCST_DATA;
  252|     DELETE FROM SCM_MGR.GT_GGET_MKT_FCST_DST;
  253|     DELETE FROM SCM_MGR.GT_GGET_SALES_PRICE;
  254|     DELETE FROM SCM_MGR.GT_GGET_EDI_SENDER;
  255|     DELETE FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP;
  256|     DELETE FROM SCM_MGR.GT_GGET_EDI_END_CUST;
  257|     DELETE FROM SCM_MGR.GT_GGET_RPA_END_CUST;
  258|     DELETE FROM SCM_MGR.GT_GGET_MKT_FCST_RESULT;
  259|     DELETE FROM SCM_MGR.GT_GGET_MF;
  260|     DELETE FROM SCM_MGR.GT_GGET_CAL_MONTH_END;
  261|     DELETE FROM SCM_MGR.GT_GGET_CAL_WEEK_END;
  262|     DELETE FROM SCM_MGR.GT_GGET_SHIPMENT_PLAN;
  263|     DELETE FROM SCM_MGR.GT_GGET_INTRANSIT_DATA;
  264|     DELETE FROM SCM_MGR.GT_GGET_VMI_INV;
  265|     DELETE FROM SCM_MGR.GT_GGET_VMI_INV_RESULT;
  266| 
  267|     -----------------------------------------------------------------------
  268|     -- 권한그룹 LOOKUP 관리 [20200311 KHSONG C20200103-000586]
  269|     -----------------------------------------------------------------------
  270|     DECLARE
  271|         V_ADMIN_CNT PLS_INTEGER := 0;
  272|     BEGIN
  273|         SELECT NVL(COUNT(1),0) INTO V_ADMIN_CNT
  274|         FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  275|         WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
  276|           AND  VALID_YN    = 'Y'
  277|           AND  SEGMENT2   IN ('ALL','DMF0003')
  278|           AND  SEGMENT1    = P_USER_GROUP;
  279|         IF V_ADMIN_CNT > 0 THEN
  280|             V_GROUP_ID := 'ADMIN';
  281|         END IF;
  282|     END;
  283| 
  284|     -----------------------------------------------------------------------
  285|     -- 조회 만료 기준 계산 (from + 40주)
  286|     -- SM임시작업 20240621 화면 장애 오류로 인하여 임시조치
  287|     -----------------------------------------------------------------------
  288|     V_EXP_YYYYMMDD := TO_CHAR(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD') + 40*7, 'YYYYMMDD');
  289| 
  290|     -----------------------------------------------------------------------
  291|     -- 버킷 컬럼 목록 동적 생성 (일별 D_, 주별 W_, 월별 M_)
  292|     -- CURSOR FAST_FORWARD → FOR LOOP
  293|     -----------------------------------------------------------------------
  294|     FOR R IN (
  295|         SELECT 'D_' || A.BASIS_YYYYMMDD || ' AS D_' || A.BASIS_YYYYMMDD     AS COLUMN_NAME
  296|              , '''D_' || A.BASIS_YYYYMMDD || ''' AS D_' || A.BASIS_YYYYMMDD AS PV_NAME
  297|              , A.BASIS_YYYYMMDD || '_31'                                    AS SORT_ORDER_NO
  298|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
  299|         WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
  300|           AND  A.BASIS_YYYYMMDD <= V_EXP_YYYYMMDD
  301|         UNION ALL
  302|         SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK
  303|              , '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ''' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK
  304|              , A.BASIS_START_DATE || '_21'
  305|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
  306|         WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
  307|           AND  A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
  308|         GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
  309|         UNION ALL
  310|         SELECT 'M_' || A.BASIS_YYYYMM || ' AS M_' || A.BASIS_YYYYMM
  311|              , '''M_' || A.BASIS_YYYYMM || ''' AS M_' || A.BASIS_YYYYMM
  312|              , MIN(A.BASIS_START_DATE) || '_01'
  313|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
  314|         WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
  315|           AND  A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
  316|         GROUP BY A.BASIS_YYYYMM
  317|         ORDER BY 3 -- SORT_ORDER_NO -- 컴파일 오류로 번호로 변경
  318|     )
  319|     LOOP
  320|         IF V_PV_COL_LIST IS NULL OR V_PV_COL_LIST = '' THEN
  321|             V_PV_COL_LIST := R.COLUMN_NAME;
  322|             V_PV_LIST     := R.PV_NAME;
  323|         ELSE
  324|             V_PV_COL_LIST := V_PV_COL_LIST || ',' || R.COLUMN_NAME;
  325|             V_PV_LIST     := V_PV_LIST     || ',' || R.PV_NAME;
  326|         END IF;
  327|     END LOOP;
  328| 
  329|     -----------------------------------------------------------------------
  330|     -- 사용자 컬럼 초기화 처리
  331|     -----------------------------------------------------------------------
  332|     V_COLUMN_NAME  := '';
  333|     V_COLUMN       := '';
  334|     V_GROUPBY      := '';
  335|     V_USER_COL_CNT := 0;
  336|     V_USER_MEA_CNT := 0;
  337| 
  338|     -- 사용자 컬럼 존재 여부 확인
  339|     SELECT COUNT(1) INTO V_USER_COL_CNT
  340|     FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  341|     WHERE  U.PROGRAM_ID                    = VA_PROGRAM_ID
  342|       AND  U.SHEET_NAME                    = VA_SHEET_NAME
  343|       AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
  344|       AND  U.USER_ID                       = P_CREATED_BY;
  345| 
  346|     IF V_USER_COL_CNT = 0 THEN
  347|         -- 사용자 컬럼이 없으면 기본값으로 복사
  348|         INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
  349|         ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
  350|         , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
  351|         , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
  352|         SELECT P_CREATED_BY, C.PROGRAM_ID, C.SHEET_NAME, 'C'
  353|              , C.COLUMN_NAME, C.SORT_ORDER_NO, 'N', ''
  354|              , P_CREATED_BY, SYSDATE
  355|              , P_CREATED_BY, SYSDATE
  356|         FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
  357|         WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
  358|           AND  C.SHEET_NAME   = VA_SHEET_NAME
  359|           AND  C.DEFAULT_FLAG = 'Y'
  360|           AND  C.VALID_YN     = 'Y';
  361| 
  362|           COMMIT WORK;
  363|     END IF;
  364| 
  365|     -- 사용자 메저 존재 여부 확인
  366|     SELECT COUNT(1) INTO V_USER_MEA_CNT
  367|     FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  368|     WHERE  U.PROGRAM_ID                    = VA_PROGRAM_ID
  369|       AND  U.SHEET_NAME                    = VA_SHEET_NAME
  370|       AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  371|       AND  U.USER_ID                       = P_CREATED_BY;
  372| 
  373|     IF V_USER_MEA_CNT = 0 THEN
  374|         INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
  375|         ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
  376|         , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
  377|         , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
  378|         SELECT P_CREATED_BY, C.PROGRAM_ID, C.SHEET_NAME, 'M'
  379|              , C.COLUMN_NAME, C.SORT_ORDER_NO, 'N', ''
  380|              , P_CREATED_BY, SYSDATE
  381|              , P_CREATED_BY, SYSDATE
  382|         FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
  383|         WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
  384|           AND  C.SHEET_NAME   = VA_SHEET_NAME
  385|           AND  C.DEFAULT_FLAG = 'Y'
  386|           AND  C.VALID_YN     = 'Y';
  387| 
  388|           COMMIT WORK;
  389|     END IF;
  390| 
  391|     -----------------------------------------------------------------------
  392|     -- 컬럼/정렬 문자열 동적 조립
  393|     -- CURSOR FAST_FORWARD c_title → FOR LOOP
  394|     -----------------------------------------------------------------------
  395|     FOR R IN (
  396|         SELECT U.COLUMN_NAME
  397|              , U.SORT_ORDER_NO
  398|         FROM  ( SELECT U.COLUMN_NAME
  399|                      , CASE WHEN U.COLUMN_NAME = 'LAST_UPDATE_DATE' THEN '800'
  400|                             WHEN U.COLUMN_NAME = 'LAST_UPDATED_BY'  THEN '560'
  401|                             ELSE TO_CHAR(U.SORT_ORDER_NO) END AS SORT_ORDER_NO
  402|                 FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  403|                      , SCM_MGR.SCM_MST_SHEET_COLUMNS C
  404|                 WHERE  U.PROGRAM_ID  = C.PROGRAM_ID
  405|                   AND  U.SHEET_NAME  = C.SHEET_NAME
  406|                   AND  U.COLUMN_NAME = C.COLUMN_NAME
  407|                   AND  U.PROGRAM_ID  = VA_PROGRAM_ID
  408|                   AND  U.SHEET_NAME  = VA_SHEET_NAME
  409|                   AND  U.USER_ID     = P_CREATED_BY
  410|                   AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
  411|                 UNION ALL
  412|                 -- 2024/05/17 kcw3408 이동계획 판가 매출GROUP_ID 추가
  413|                 SELECT C.COLUMN_NAME
  414|                      , CASE WHEN C.COLUMN_NAME = 'GROUP_ID'
  415|                             THEN TO_CHAR(NVL(U.SORT_ORDER_NO,85) - 0.5)
  416|                             ELSE TO_CHAR(C.SORT_ORDER_NO) END AS SORT_ORDER_NO
  417|                 FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
  418|                 LEFT   OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
  419|                   ON   U.PROGRAM_ID  = C.PROGRAM_ID
  420|                  AND   U.SHEET_NAME  = C.SHEET_NAME
  421|                  AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
  422|                  AND   U.COLUMN_NAME IN ('ITEM_ID')
  423|                  AND   U.USER_ID     = P_CREATED_BY
  424|                 WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
  425|                   AND  C.SHEET_NAME   = VA_SHEET_NAME
  426|                   AND  ( C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' '  OR C.DEFAULT_FLAG = '' )
  427|                   AND  C.VALID_YN     = 'Y' ) U
  428|         ORDER BY TO_NUMBER(U.SORT_ORDER_NO)
  429|     )
  430|     LOOP
  431|         IF V_COLUMN IS NULL OR V_COLUMN = '' THEN
  432|             V_COLUMN  := R.COLUMN_NAME;
  433|             V_GROUPBY := ' GROUP BY ' || R.COLUMN_NAME;
  434|             V_ORDERBY := ' ORDER BY SORT_KEY, '
  435|                       || CASE WHEN R.COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG')
  436|                                THEN R.COLUMN_NAME ELSE '' END;
  437|         ELSE
  438|             V_COLUMN  := V_COLUMN  || ', ' || R.COLUMN_NAME;
  439|             V_GROUPBY := V_GROUPBY || ', ' || R.COLUMN_NAME;
  440|             V_ORDERBY := V_ORDERBY
  441|                       || CASE WHEN R.COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG')
  442|                                THEN ', ' || R.COLUMN_NAME ELSE '' END;
  443|         END IF;
  444|     END LOOP;
  445| 
  446|     -- [E20240812-000094] NOTATION 컬럼 추가
  447|     V_COLUMN  := V_COLUMN  || ',NOTATION';
  448|     V_GROUPBY := V_GROUPBY || ', EDIT_FLAG, SORT_ORDER_NO';
  449|     V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');
  450|     V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');
  451| 
  452|     -----------------------------------------------------------------------
  453|     -- 사용자 시차(TIMEZONE) 조회
  454|     -----------------------------------------------------------------------
  455|     BEGIN
  456|         SELECT U.TMZ_CD INTO V_USER_TIME_ZONE
  457|         FROM   SCM_MGR.SCM_ADM_USER_M U
  458|         WHERE  U.USER_ID = P_CREATED_BY;
  459|     EXCEPTION
  460|         WHEN NO_DATA_FOUND THEN V_USER_TIME_ZONE := '';
  461|     END;
  462| 
  463|     -----------------------------------------------------------------------
  464|     -- 계획/실적 기준 날짜 계산
  465|     -----------------------------------------------------------------------
  466|     -- @v_from_yyyymmdd : (User 시차 고려) 당주 월요일
  467|     BEGIN
  468|         SELECT MIN(C.BASIS_YYYYMMDD) INTO V_FROM_YYYYMMDD
  469|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
  470|              , ( SELECT DISTINCT ISO_YYYYWW
  471|                  FROM   SCM_MGR.SCM_SYS_CALENDAR_M
  472|                  WHERE  BASIS_YYYYMMDD =
  473|                         TO_CHAR(SCM_MGR.FN_MULTY_TIME(V_USER_TIME_ZONE),'YYYYMMDD')
  474|                ) T
  475|         WHERE  C.ISO_YYYYWW = T.ISO_YYYYWW;
  476|     EXCEPTION
  477|         WHEN NO_DATA_FOUND THEN V_FROM_YYYYMMDD := TO_CHAR(SYSDATE,'YYYYMMDD');
  478|     END;
  479| 
  480|     -- From 실적 : From 조회 구간 월요일
  481|     BEGIN
  482|         SELECT C.BASIS_START_DATE INTO V_FROM_RESULT
  483|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
  484|         WHERE  C.BASIS_YYYYMMDD = P_FROM_YYYYMMDD;
  485|     EXCEPTION
  486|         WHEN NO_DATA_FOUND THEN V_FROM_RESULT := '';
  487|     END;
  488| 
  489|     -- To 실적 : To 조회 구간 월요일 전까지
  490|     BEGIN
  491|         SELECT C.BASIS_START_DATE INTO V_TO_RESULT
  492|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
  493|         WHERE  C.BASIS_YYYYMMDD = P_TO_YYYYMMDD;
  494|     EXCEPTION
  495|         WHEN NO_DATA_FOUND THEN V_TO_RESULT := '';
  496|     END;
  497| 
  498|     IF V_FROM_YYYYMMDD > V_FROM_RESULT THEN
  499|         -- 실적 보여줌
  500|         V_TO_YYYYMMDD := P_TO_YYYYMMDD;
  501|         V_TO_RESULT   := V_FROM_YYYYMMDD;  -- To 실적 : 당주 월요일 전까지
  502|     ELSIF V_FROM_YYYYMMDD <= V_FROM_RESULT THEN
  503|         -- 실적 없음
  504|         V_TO_YYYYMMDD := P_TO_YYYYMMDD;
  505|         V_FROM_RESULT := '19000101';
  506|         V_TO_RESULT   := '19000101';
  507|     ELSIF V_FROM_YYYYMMDD > V_TO_RESULT THEN
  508|         -- 실적만 보여줌
  509|         V_FROM_YYYYMMDD := '19000101';
  510|         V_TO_YYYYMMDD   := '19000101';
  511|         V_FROM_RESULT   := P_FROM_YYYYMMDD;
  512|         V_TO_RESULT     := P_TO_YYYYMMDD;
  513|     ELSIF V_FROM_YYYYMMDD = V_TO_RESULT THEN
  514|         -- 실적 없음
  515|         V_TO_YYYYMMDD := V_FROM_YYYYMMDD;
  516|         V_FROM_RESULT := P_FROM_YYYYMMDD;
  517|         V_TO_RESULT   := P_TO_YYYYMMDD;
  518|     END IF;
  519| 
  520|     -----------------------------------------------------------------------
  521|     -- [E20260211-001189] 조회 SALES SITE 중 AS용 데이터가 있으면 AS_YN = 'Y'로 처리
  522|     -- TABLE()은 컬렉션 변수만 허용 → 먼저 변수에 COLLECT 후 참조
  523|     -----------------------------------------------------------------------
  524|     DECLARE
  525|         V_AS_CNT PLS_INTEGER := 0;
  526|     BEGIN
  527|         SELECT CAST(
  528|                    COLLECT(DISTINCT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)))
  529|                AS SCM_MGR.T_STR_TAB)
  530|         INTO   T_SCM_SITE_IDS
  531|         FROM   DUAL
  532|         CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL;
  533| 
  534|         SELECT COUNT(DISTINCT A.COLUMN_VALUE) INTO V_AS_CNT
  535|         FROM   TABLE(T_SCM_SITE_IDS) A
  536|         JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
  537|           ON   A.COLUMN_VALUE = B.SEGMENT1
  538|          AND   B.LOOKUP_TYPE  = 'AS_SITE_PLANT';
  539| 
  540|         IF V_AS_CNT > 0 THEN
  541|             LP_AS_YN := 'Y';
  542|         END IF;
  543|     END;
  544|     -- [E20260211-001189] END
  545| 
  546|     -----------------------------------------------------------------------
  547|     -- [C20200804-000123] SSP 동기화 / BNP 데이터 수집
  548|     -----------------------------------------------------------------------
  549|     -- Division 40: DM_PLN_MKT_FCST 기반 PIVOT → GT_GGET_T_SSP_SYNC
  550|     IF P_DIVISION_ID = '40' THEN
  551|         INSERT INTO SCM_MGR.GT_GGET_T_SSP_SYNC
  552|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ATTR1 )
  553|         SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
  554|              , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
  555|             || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
  556|             || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
  557|             || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
  558|             || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
  559|             || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
  560|             || '^' || NVL(A31,'') AS ATTR1
  561|         FROM (
  562|             SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, A.FCST_TYPE, INCOTERMS
  563|                  , YYYYMMDD || '/'
  564|                    || CASE
  565|                           WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
  566|                            AND A.QTY >
  567|                                CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
  568|                                     THEN TO_NUMBER(ATTRIBUTE3) ELSE 0 END
  569|                              + CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE2,'0'),'^[0-9.]+$')
  570|                                     THEN TO_NUMBER(ATTRIBUTE2) ELSE 0 END
  571|                           THEN 'P'
  572|                           ELSE 'A'
  573|                       END AS SYNC_YN
  574|                  , 'A' || TO_CHAR(
  575|                        ROW_NUMBER() OVER (
  576|                            PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
  577|                                         DOM_EXP, A.FCST_TYPE, INCOTERMS
  578|                            ORDER BY YYYYMMDD
  579|                        )) AS ROW_NUM
  580|             FROM   SCM_MGR.DM_PLN_MKT_FCST A
  581|             -- [E20260211-001189] #T_WS_FCST JOIN 주석처리된 원본 그대로 반영
  582|             WHERE  A.DIVISION_ID = P_DIVISION_ID
  583|               AND  A.MEASURE     = 'MKT_FCST'
  584|               AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
  585|               AND  ( A.ATTRIBUTE4 IS NOT NULL OR A.ATTRIBUTE5 IS NOT NULL OR NVL(A.ATTRIBUTE4,'') <> '' OR NVL(A.ATTRIBUTE5,'') <> '')  -- [C20210225-000385]
  586|               AND  A.QTY <> 0
  587|               AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID
  588|                           ELSE A.SCM_SITE_ID END
  589|                      IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL))
  590|                          FROM DUAL
  591|                          CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
  592|               AND  ( LP_PROJECT_CODE IS NULL
  593|                      OR CASE WHEN LP_PROJECT_CODE = '' THEN LP_PROJECT_CODE
  594|                           ELSE A.PROJECT_CODE END
  595|                      IN (SELECT TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL))
  596|                          FROM DUAL
  597|                          CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL) )
  598|               AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID
  599|                           ELSE A.PLANT_SITE_ID END
  600|                      IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL))
  601|                          FROM DUAL
  602|                          CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
  603|         ) A
  604|         PIVOT (
  605|             MAX(SYNC_YN) FOR ROW_NUM IN (
  606|                 'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
  607|                 'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
  608|                 'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
  609|                 'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
  610|                 'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
  611|                 'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
  612|                 'A31' A31
  613|             )
  614|         );
  615| 
  616|     -- Division 82: DM_PLN_PR_DETAIL 기반 PIVOT → GT_GGET_T_BNP [PJ20209642R]
  617|     ELSIF P_DIVISION_ID = '82' THEN
  618|         INSERT INTO SCM_MGR.GT_GGET_T_BNP
  619|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ATTR1 )
  620|         SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
  621|              , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
  622|             || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
  623|             || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
  624|             || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
  625|             || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
  626|             || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
  627|             || '^' || NVL(A31,'') AS ATTR1
  628|         FROM (
  629|             SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
  630|                             DOM_EXP, FCST_TYPE, INCOTERMS
  631|                  , YYYYMMDD || '/A' AS SYNC_YN
  632|                  , 'A' || TO_CHAR(
  633|                        ROW_NUMBER() OVER (
  634|                            PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
  635|                                         DOM_EXP, FCST_TYPE, INCOTERMS
  636|                            ORDER BY YYYYMMDD
  637|                        )) AS ROW_NUM
  638|             FROM   SCM_MGR.DM_PLN_PR_DETAIL A
  639|             WHERE  A.DIVISION_ID = P_DIVISION_ID
  640|               AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
  641|         ) A
  642|         PIVOT (
  643|             MAX(SYNC_YN) FOR ROW_NUM IN (
  644|                 'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
  645|                 'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
  646|                 'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
  647|                 'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
  648|                 'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
  649|                 'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
  650|                 'A31' A31
  651|             )
  652|         );
  653|     END IF;
  654|     -- [C20200804-000123] 끝
  655| 
  656|     -----------------------------------------------------------------------
  657|     -- [E20240920-000300] ITEM_SINGLE_V 속도 개선 - 3단계로 나눠서 INSERT
  658|     -----------------------------------------------------------------------
  659|     -- Step 1: SCM_MST_ITEM_SN 전체를 GT_GGET_ITEM_SINGLE_ORI에 적재
  660|     INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_ORI
  661|     ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
  662|     , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
  663|     , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
  664|     , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
  665|     , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
  666|     SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
  667|          , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
  668|          , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
  669|          , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
  670|          , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
  671|     FROM   SCM_MGR.SCM_MST_ITEM_SN
  672|     WHERE  DIVISION_ID = P_DIVISION_ID
  673|       AND  ACTIVE_FLAG = 'Y';
  674| 
  675|     -- Step 2A: 기본 컬럼 GROUP BY → GT_GGET_ITEM_SINGLE_A
  676|     INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_A
  677|     ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
  678|     , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
  679|     , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
  680|     SELECT T1.DIVISION_ID
  681|          , T1.ITEM_ID
  682|          , MAX(T1.ITEM_NAME)
  683|          , MAX(T1.ITEM_CLASS)
  684|          , MAX(T1.ITEM_CLASS_NAME)
  685|          , MAX(T1.NICK_NAME)
  686|          , CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
  687|                          WHEN T1.ITEM_TYPE = 'H' THEN 2
  688|                          WHEN T1.ITEM_TYPE = 'Q' THEN 3
  689|                          ELSE 4 END)
  690|                WHEN 1 THEN 'P' WHEN 2 THEN 'H' WHEN 3 THEN 'Q' ELSE 'R' END
  691|          , MAX(T1.MATERIAL_CLASS_NAME)
  692|          , MAX(T1.ITEM_UOM)
  693|          , MAX(T1.SPEC)
  694|          , MAX(T1.MDM_PROJECT_NAME)
  695|          , MAX(T1.MIN_CAPACITY)
  696|          , MAX(T1.ACTIVE_FLAG)
  697|          , MAX(T1.ENERGE)
  698|          , MAX(T1.CELL_QUANTITY)
  699|          , MAX(T1.SCP_EXTRA_SPEC)
  700|     FROM   SCM_MGR.GT_GGET_ITEM_SINGLE_ORI T1
  701|     GROUP BY T1.DIVISION_ID, T1.ITEM_ID;
  702| 
  703|     -- Step 2B: FORECAST_INFO 계열 LEFT(12) 기준 집계 → GT_GGET_ITEM_SINGLE_B
  704|     INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_B
  705|     ( DIVISION_ID, ITEM_ID
  706|     , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
  707|     , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
  708|     SELECT DIVISION_ID
  709|          , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
  710|          , MAX(FORECAST_INFO_BIZ_TYPE)
  711|          , MAX(FORECAST_INFO_PRODUCT_GROUP)
  712|          , MAX(FORECAST_INFO_CELL_MODEL)
  713|          , MAX(FORECAST_INFO_CELL_PACK_COUNT)
  714|          , MAX(FORECAST_INFO_SPEC)
  715|          , MAX(FORECAST_INFOR_VERSION)
  716|          , MAX(CELL_TYPE)
  717|     FROM   SCM_MGR.GT_GGET_ITEM_SINGLE_ORI
  718|     GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);
  719| 
  720|     -- Step 3: A+B JOIN 후 ITEM_ID/NICK_NAME LIKE 필터 적용 → GT_GGET_ITEM_SINGLE_V
  721|     INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_V
  722|     ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
  723|     , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
  724|     , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
  725|     , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
  726|     , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
  727|     SELECT T1.DIVISION_ID, T1.ITEM_ID
  728|          , T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
  729|          , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
  730|          , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
  731|          , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
  732|          , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
  733|     FROM   SCM_MGR.GT_GGET_ITEM_SINGLE_A T1
  734|     JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_B T2
  735|       ON   T1.DIVISION_ID          = T2.DIVISION_ID
  736|      AND   SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
  737|     WHERE  T1.DIVISION_ID = P_DIVISION_ID
  738|       AND  EXISTS (
  739|                SELECT 1
  740|                FROM (
  741|                    SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) || '%' AS TST
  742|                    FROM DUAL
  743|                    CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL
  744|                ) B
  745|                WHERE T1.ITEM_ID   LIKE B.TST
  746|                   OR T1.NICK_NAME LIKE B.TST
  747|            )
  748|     GROUP BY T1.DIVISION_ID, T1.ITEM_ID
  749|            , T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
  750|            , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
  751|            , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
  752|            , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
  753|            , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC;
  754| 
  755|     -- [E20240731-000856] Wh → KWh 환산
  756|     UPDATE SCM_MGR.GT_GGET_ITEM_SINGLE_V
  757|     SET    ENERGE = CASE WHEN REGEXP_LIKE(NVL(ENERGE,'X'),'^[0-9.]+$')
  758|                          THEN TO_CHAR(ROUND(TO_NUMBER(ENERGE)/1000, 4))
  759|                          ELSE NULL END;
  760| 
  761|     -----------------------------------------------------------------------
  762|     -- GT_GGET_SELECT_MEASURE 수집
  763|     -- [C20200612-000174] ESS사업부 조회 구간에 mapping되지 않은 Sales Price 데이터 제공
  764|     -----------------------------------------------------------------------
  765|     INSERT INTO SCM_MGR.GT_GGET_SELECT_MEASURE
  766|     ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO )
  767|     SELECT DISTINCT U.PROGRAM_ID
  768|                   , U.SHEET_NAME
  769|                   , U.USER_ID
  770|                   , CASE WHEN U.COLUMN_NAME IN ('CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO')
  771|                          THEN 'CUST. PSI'
  772|                          WHEN U.COLUMN_NAME IN ('MKT_INV_I','MKT_PRODUCT_S','MKT_WHIN_P','MKT_DIO')
  773|                          THEN 'MKT PSI'
  774|                          ELSE U.COLUMN_NAME END AS MEASURE_GROUP
  775|                   , U.COLUMN_NAME AS MEASURE
  776|                   , CASE WHEN U.COLUMN_NAME IN ('CUST_FCST','CUST_FCST_EDI','CUST_FCST_ORG','CUST_FCST_EDI_ORG')
  777|                          THEN SMSM.SORT_ORDER_NO   -- 20231212 kcw3408 4_고객수요 Measure 통합
  778|                          ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO
  779|     FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  780|     JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
  781|       ON   U.PROGRAM_ID  = SMSM.PROGRAM_ID
  782|      AND   U.SHEET_NAME  = SMSM.SHEET_NAME
  783|      AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
  784|      AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  785|      AND   SMSM.VALID_YN = 'Y'
  786|     LEFT   JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
  787|       ON   U.USER_ID    = T.SEGMENT4     -- 20200309 KHSONG TMM MEASURE 권한추가
  788|      AND   P_CREATED_BY = T.SEGMENT4
  789|      AND   T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
  790|      AND   T.VALID_YN    = 'Y'
  791|     WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  792|       AND  U.PROGRAM_ID = 'DMF0003'
  793|       AND  U.SHEET_NAME = 'Mkt Fcst'
  794|       AND  U.USER_ID    = P_CREATED_BY
  795|       AND  U.USER_ID    = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4
  796|                                ELSE P_CREATED_BY END
  797|     -----------------------------------------------------------------------
  798|     -- [20191118 KHSONG CSR ID:C20191031-000137] CUST_FCST_EDI 계열 sub-measure 추가
  799|     -----------------------------------------------------------------------
  800|     UNION ALL
  801|     SELECT A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE
  802|          , A.SORT_ORDER_NO + B.SORT_ORDER_NO
  803|     FROM (
  804|         SELECT U.PROGRAM_ID, U.SHEET_NAME, U.USER_ID
  805|              -- [E20241126-000426] CUST_FCST_EDI → CUST_FCST 로 변경
  806|              , 'CUST_FCST' AS MEASURE_GROUP
  807|              , SMSM.SORT_ORDER_NO
  808|         FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  809|         JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
  810|           ON   U.PROGRAM_ID  = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
  811|          AND   U.COLUMN_NAME = SMSM.COLUMN_NAME AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  812|          AND   SMSM.VALID_YN = 'Y'
  813|         WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  814|           AND  U.PROGRAM_ID  = 'DMF0003'
  815|           AND  U.SHEET_NAME  = 'Mkt Fcst'
  816|           AND  U.USER_ID     = P_CREATED_BY
  817|           -- [E20241126-000426] CUST_FCST_EDI → CUST_FCST 로 변경
  818|           AND  U.COLUMN_NAME = 'CUST_FCST'
  819|     ) A,
  820|     (
  821|         -- [E20241126-000426] CUST_FCST_EDI 추가 및 순서 변경
  822|         SELECT 'Immidiate'                   AS MEASURE, 0.15 AS SORT_ORDER_NO FROM DUAL UNION ALL
  823|         SELECT 'Planning_Forecast'                      , 0.18 FROM DUAL UNION ALL
  824|         SELECT 'Commercial_Agreement'                   , 0.13 FROM DUAL UNION ALL
  825|         SELECT 'Firm_Temp'                              , 0.14 FROM DUAL UNION ALL
  826|         SELECT 'Manumacturing_Material_Temp'            , 0.16 FROM DUAL UNION ALL
  827|         SELECT 'Material_Temp'                          , 0.17 FROM DUAL UNION ALL
  828|         SELECT 'Backorder'                              , 0.12 FROM DUAL UNION ALL
  829|         SELECT 'CUST_FCST_EDI'                          , 0.11 FROM DUAL
  830|     ) B
  831|     GROUP BY A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE
  832|            , A.SORT_ORDER_NO + B.SORT_ORDER_NO
  833|     -----------------------------------------------------------------------
  834|     -- CUST_FCST_2 : DM_MST_CUSTOMER_FCST 기반 동적 Measure
  835|     -----------------------------------------------------------------------
  836|     UNION ALL
  837|     SELECT DISTINCT 'DMF0003'   AS PROGRAM_ID
  838|                   , 'Mkt Fcst'  AS SHEET_NAME
  839|                   , P_CREATED_BY AS USER_ID
  840|                   , 'CUST_FCST_2' AS MEASURE_GROUP
  841|                   , C.MEASURE
  842|                   ,
  843|                       ( SELECT SMSM.SORT_ORDER_NO
  844|                         FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  845|                         JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
  846|                           ON   U.PROGRAM_ID = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
  847|                          AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
  848|                          AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M' AND SMSM.VALID_YN = 'Y'
  849|                         WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  850|                           AND  U.PROGRAM_ID = 'DMF0003' AND U.SHEET_NAME = 'Mkt Fcst'
  851|                           AND  U.USER_ID = P_CREATED_BY AND U.COLUMN_NAME = 'CUST_FCST' )
  852|                       + 0.1
  853|                      AS SORT_ORDER_NO
  854|     FROM   SCM_MGR.DM_MST_CUSTOMER_FCST C
  855|     WHERE  C.MEASURE_GROUP = 'CUST_FCST'
  856|       AND  NVL(C.MEASURE,'-') <> '-'
  857|       AND  C.VALID_YN = 'Y'
  858|       AND  EXISTS (
  859|                SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER X
  860|                WHERE  X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  861|                  AND  X.PROGRAM_ID = 'DMF0003' AND X.SHEET_NAME = 'Mkt Fcst'
  862|                  AND  X.USER_ID    = P_CREATED_BY
  863|                  AND  X.COLUMN_NAME = 'CUST_FCST' AND X.COLUMN_NAME = C.MEASURE_GROUP
  864|            )
  865|     -----------------------------------------------------------------------
  866|     -- CUST_FCST_3 : Customer Fcst[Org.] 고정 Measure
  867|     -----------------------------------------------------------------------
  868|     UNION ALL
  869|     SELECT DISTINCT 'DMF0003', 'Mkt Fcst', P_CREATED_BY
  870|                   , 'CUST_FCST_3', 'Customer Fcst[Org.]'
  871|                   ,
  872|                       ( SELECT SMSM.SORT_ORDER_NO
  873|                         FROM   SCM_MGR.SCM_MST_TITLESET_USER U
  874|                         JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
  875|                           ON   U.PROGRAM_ID = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
  876|                          AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
  877|                          AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M' AND SMSM.VALID_YN = 'Y'
  878|                         WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  879|                           AND  U.PROGRAM_ID = 'DMF0003' AND U.SHEET_NAME = 'Mkt Fcst'
  880|                           AND  U.USER_ID = P_CREATED_BY AND U.COLUMN_NAME = 'CUST_FCST_ORG' )
  881|                       + 0.1
  882|                      AS SORT_ORDER_NO
  883|     FROM   SCM_MGR.DM_MST_CUSTOMER_FCST C
  884|     WHERE  C.MEASURE_GROUP = 'CUST_FCST'
  885|       AND  NVL(C.MEASURE,'-') <> '-'
  886|       AND  C.VALID_YN = 'Y'
  887|       AND  EXISTS (
  888|                SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER X
  889|                WHERE  X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  890|                  AND  X.PROGRAM_ID = 'DMF0003' AND X.SHEET_NAME = 'Mkt Fcst'
  891|                  AND  X.USER_ID    = P_CREATED_BY AND X.COLUMN_NAME = 'CUST_FCST_ORG'
  892|            );
  893| 
  894|     -----------------------------------------------------------------------
  895|     -- [C20201103-000114] Division 82: MKT_FCST_RP 선택 시 VMI 관련 메저 강제 추가
  896|     -----------------------------------------------------------------------
  897|     DECLARE
  898|         V_MKT_RP_CNT PLS_INTEGER := 0;
  899|     BEGIN
  900|         SELECT COUNT(1) INTO V_MKT_RP_CNT
  901|         FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
  902|         WHERE  MEASURE = 'MKT_FCST_RP';
  903| 
  904|         IF V_MKT_RP_CNT > 0 AND P_DIVISION_ID = '82' THEN
  905|             -- 순서 조정을 위해 기존 항목 제거 후 재삽입
  906|             DELETE FROM SCM_MGR.GT_GGET_SELECT_MEASURE
  907|             WHERE  MEASURE IN ('RTF_SYS_RP','VMI_IN_PLAN','VMI_IN_REQ','VMI_INV');
  908| 
  909|             INSERT INTO SCM_MGR.GT_GGET_SELECT_MEASURE
  910|             ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO )
  911|             SELECT A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID
  912|                  , B.MEASURE_GROUP, B.MEASURE
  913|                  , REPLACE(A.SORT_ORDER_NO, '.0', B.SORTKEY)
  914|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE A
  915|             JOIN   (
  916|                        SELECT 'RTF_SYS_RP'  AS MEASURE_GROUP, 'RTF_SYS_RP'  AS MEASURE, '.1' AS SORTKEY FROM DUAL UNION ALL
  917|                        SELECT 'VMI_In_Plan'               , 'VMI_In_Plan'               , '.2' FROM DUAL UNION ALL
  918|                        SELECT 'VMI_In_Req'                , 'VMI_In_Req'                , '.3' FROM DUAL UNION ALL
  919|                        SELECT 'VMI_Inv'                   , 'VMI_Inv'                   , '.4' FROM DUAL
  920|                    ) B ON 1=1
  921|             WHERE  A.MEASURE = 'MKT_FCST_RP';
  922|         END IF;
  923|     END;
  924| 
  925|     -- MKT FCST 메저 순서 변경
  926|     UPDATE SCM_MGR.GT_GGET_SELECT_MEASURE
  927|     SET    SORT_ORDER_NO = REPLACE(SORT_ORDER_NO, '.0', '.9')
  928|     WHERE  MEASURE = 'MKT_FCST_RP';
  929| 
  930|     -----------------------------------------------------------------------
  931|     -- GT_GGET_VMI_DIO 수집
  932|     -----------------------------------------------------------------------
  933|     IF P_DIVISION_ID = '40' THEN
  934|         INSERT INTO SCM_MGR.GT_GGET_VMI_DIO ( KEY_JOIN, VMI_STD_DIO )
  935|         SELECT A.ITEM_ID, A.VMI_STD_DIO
  936|         FROM   SCM_MGR.SCP_MST_DIO A
  937|         JOIN (
  938|             SELECT DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN, MAX(YYYYMM) AS YYYYMM
  939|             FROM   SCM_MGR.SCP_MST_DIO
  940|             WHERE  DIVISION_ID = '40' AND TOTAL_YN = 'Y' AND PLANT_ID = '*'
  941|             GROUP  BY DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN
  942|         ) B ON A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
  943|            AND A.ITEM_ID     = B.ITEM_ID     AND A.TOTAL_YN = B.TOTAL_YN
  944|            AND A.YYYYMM      = B.YYYYMM
  945|         WHERE  A.DIVISION_ID = '40' AND A.TOTAL_YN = 'Y' AND A.PLANT_ID = '*';
  946| 
  947|     ELSIF P_DIVISION_ID = '82' THEN   -- [C20201103-000114]
  948|         INSERT INTO SCM_MGR.GT_GGET_VMI_DIO ( KEY_JOIN, VMI_VAL )
  949|         SELECT A.SCM_SITE_ID
  950|              , A.VMI_YN || '^' || NVL(TO_CHAR(A.ATTRIBUTE5),'')
  951|         FROM   SCM_MGR.SCM_MST_SITE A
  952|         WHERE  DIVISION_ID = P_DIVISION_ID;
  953|     END IF;
  954| 
  955|     -----------------------------------------------------------------------
  956|     -- GT_GGET_SITE_ITEM_ALL 수집 (81/82 vs 40 분기)
  957|     -----------------------------------------------------------------------
  958|     IF P_DIVISION_ID LIKE '81%' OR P_DIVISION_ID = '82' THEN
  959|         INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL
  960|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
  961|              , T2.NICK_NAME, T3.PROJECT_NAME
  962|              , ''   AS CELL_MODEL      -- 20180809 ytchoi modify
  963|              , T3.BIZ_TYPE
  964|              , S.END_CUSTOMER
  965|              , S.SOLDTO_CUSTOMER
  966|              , I.COUNTRY, I.COUNTRY_NAME
  967|              , H.CITY, H.CITY_NAME
  968|              , ( SELECT DISTINCT
  969|                      LISTAGG(ZA.USER_NAME_EN,',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN)
  970|                  FROM   SCM_MGR.SCM_MST_SSO_USER_INFO ZA
  971|                  WHERE  ZA.USER_ID IN (
  972|                      SELECT TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL))
  973|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL) IS NOT NULL
  974|                  )
  975|                ) AS OWNER
  976|              , CASE WHEN F.DIVISION_ID NOT IN ('40') THEN T3.PROJECT_OWNER
  977|                     ELSE J.USER_NAME_EN END AS PROJECT_OWNER   -- 20180705
  978|              , J.USER_ID
  979|              , T2.ITEM_NAME, T2.ITEM_TYPE
  980|              , T3.PROJECT_STATUS
  981|              , F.CUST_GROUP, F.CUST_GROUP_DTL, F.APPLICATION, F.ROUTE
  982|              , T2.MDM_PROJECT_NAME, TO_CHAR(T2.MIN_CAPACITY)
  983|              , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
  984|              , LOOK.NAME  AS CELL_TYPE   -- 20180911 LookUp TABLE JOIN
  985|              , T2.FORECAST_INFO_CELL_PACK_COUNT
  986|              , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
  987|              , T2.FORECAST_INFO_SPEC
  988|              , T2.FORECAST_INFOR_VERSION
  989|              , NVL(T4.NICK_NAME,'')  AS CELL_MODEL_NICK_NAME  -- 20190419 KHSONG
  990|              , S.VMI_YN
  991|              , NVL(F.ATTRIBUTE1,'')  AS DMS_SALES    -- 20190213 KHSONG
  992|              , NVL(F.ATTRIBUTE2,'')  AS DMS_CUSTOMER -- 20190213 KHSONG
  993|              -- [PJ2024-50461] Team Mapping
  994|              , TEAM.DEPT_ID
  995|              , TEAM_DEPT.DEPT_NAME_KO
  996|              , F.CELL_PER_CAR
  997|              , F.CELL_PER_MODULE  -- [E20260123-001715] 원소스 복원
  998|              , F.CELL_PER_CAR / CASE WHEN NVL(F.CELL_PER_MODULE,0) = 0 THEN 1
  999|                                       ELSE F.CELL_PER_MODULE END  AS MODULE_PER_CAR
 1000|              , T2.ITEM_CLASS_NAME
 1001|              , T2.ENERGE
 1002|              , TO_CHAR(T2.CELL_QUANTITY)
 1003|              , F.VALID_YN  AS ITEM_VALID_YN
 1004|         FROM   SCM_MGR.SCM_MST_SITE_ITEM F
 1005|         JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_V T2
 1006|           ON   F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
 1007|         JOIN   SCM_MGR.SCM_MST_PROJECT T3
 1008|           ON   F.DIVISION_ID = T3.DIVISION_ID AND F.PROJECT_CODE = T3.PROJECT_CODE
 1009|         JOIN (
 1010|              SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) || '%' TST
 1011|              FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL
 1012|         ) B ON (F.ITEM_ID LIKE B.TST OR T2.NICK_NAME LIKE B.TST)   -- 20190118 DISTINCT 추가
 1013|         JOIN (
 1014|              SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL)) || '%' TST
 1015|              FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL
 1016|         ) C ON (F.PROJECT_CODE LIKE C.TST OR T3.PROJECT_NAME LIKE C.TST)
 1017|         JOIN   SCM_MGR.SCM_MST_SITE S
 1018|           ON   F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID
 1019|          AND   S.SITE_TYPE   = 'SALES' AND S.VALID_YN = 'Y'
 1020|         JOIN   SCM_MGR.SCM_MST_CITY H    ON S.CITY    = H.CITY
 1021|         JOIN   SCM_MGR.SCM_MST_COUNTRY I ON S.COUNTRY = I.COUNTRY
 1022|         -- [PJ2024-50461] Team Mapping
 1023|         LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO TEAM
 1024|           ON   TEAM.USER_ID = TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1))
 1025|         LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM_DEPT
 1026|           ON   TEAM.DEPT_ID = TEAM_DEPT.DEPT_ID
 1027|         LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
 1028|           ON   SUBSTR(F.OWNER, 1,
 1029|                       CASE WHEN INSTR(F.OWNER,',') = 0 THEN LENGTH(F.OWNER)
 1030|                            ELSE INSTR(F.OWNER,',') - 1 END) = J.USER_ID
 1031|         LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K ON J.DEPT_ID = K.DEPT_ID
 1032|         LEFT   JOIN (
 1033|                         SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
 1034|                         FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 1035|                         WHERE  LOOKUP_TYPE = 'CELL_TYPE'
 1036|                     ) LOOK ON LOOK.CODE = T2.CELL_TYPE
 1037|         LEFT   JOIN SCM_MGR.GT_GGET_ITEM_SINGLE_V T4
 1038|           ON   T2.DIVISION_ID = T4.DIVISION_ID
 1039|          AND   NVL(T2.FORECAST_INFO_CELL_MODEL,'') = T4.ITEM_ID  -- 20190419 KHSONG
 1040|         WHERE  F.DIVISION_ID <> '40'   -- hard coding (20190123 KHSONG)
 1041|           AND  F.DIVISION_ID = P_DIVISION_ID
 1042|           -- [E20260211-001189] SCM_SITE_ID 조건 주석처리
 1043|           AND  ( CASE WHEN P_CUSTOMER = 'ALL' THEN P_CUSTOMER
 1044|                       ELSE S.END_CUSTOMER END
 1045|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
 1046|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL) )
 1047|           AND  ( CASE WHEN P_ITEM_TYPE = 'ALL' THEN P_ITEM_TYPE
 1048|                       ELSE T2.ITEM_TYPE END
 1049|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
 1050|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
 1051|           AND  ( CASE WHEN P_BIZ_TYPE = 'ALL' THEN P_BIZ_TYPE
 1052|                       ELSE T3.BIZ_TYPE END
 1053|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
 1054|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
 1055|           AND  ( ( P_OWNER IS NULL OR P_OWNER = '' )
 1056|                    OR F.OWNER IN (SELECT TRIM(REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL))
 1057|                                   FROM DUAL CONNECT BY REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL) IS NOT NULL) );
 1058| 
 1059|     ELSE
 1060|         -- Division 40 (소형) 케이스
 1061|         INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL
 1062|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
 1063|              , T2.NICK_NAME, F.PROJECT_CODE  AS PROJECT_NAME
 1064|              , F.ATTRIBUTE5  AS CELL_MODEL   -- 20180810 ytchoi 조회속도개선
 1065|              , ''  AS BIZ_TYPE
 1066|              , S.END_CUSTOMER
 1067|              , S.SOLDTO_CUSTOMER
 1068|              , I.COUNTRY, I.COUNTRY_NAME
 1069|              , H.CITY, H.CITY_NAME
 1070|              , ( SELECT DISTINCT
 1071|                      LISTAGG(ZA.USER_NAME_EN,',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN)
 1072|                  FROM   SCM_MGR.SCM_MST_SSO_USER_INFO ZA
 1073|                  WHERE  ZA.USER_ID IN (
 1074|                      SELECT TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL))
 1075|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL) IS NOT NULL
 1076|                  )
 1077|                ) AS OWNER
 1078|              , J.USER_NAME_EN  AS PROJECT_OWNER   -- 20180705
 1079|              , J.USER_ID
 1080|              , T2.ITEM_NAME, T2.ITEM_TYPE
 1081|              , ''  AS PROJECT_STATUS
 1082|              , F.CUST_GROUP, F.CUST_GROUP_DTL, F.APPLICATION, F.ROUTE
 1083|              , T2.MDM_PROJECT_NAME, TO_CHAR(T2.MIN_CAPACITY)
 1084|              -- [E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청
 1085|              , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
 1086|                     ELSE T2.FORECAST_INFO_BIZ_TYPE END  AS FORECAST_INFO_BIZ_TYPE
 1087|              , T2.FORECAST_INFO_PRODUCT_GROUP
 1088|              , LOOK.NAME  AS CELL_TYPE
 1089|              , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT)
 1090|                     ELSE T2.FORECAST_INFO_CELL_PACK_COUNT END  AS FORECAST_INFO_CELL_PACK_COUNT
 1091|              , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
 1092|              , T2.FORECAST_INFO_SPEC
 1093|              , T2.FORECAST_INFOR_VERSION
 1094|              , NVL(T4.NICK_NAME,'')  AS CELL_MODEL_NICK_NAME
 1095|              , S.VMI_YN
 1096|              , NVL(F.ATTRIBUTE1,'')  AS DMS_SALES
 1097|              , NVL(F.ATTRIBUTE2,'')  AS DMS_CUSTOMER
 1098|              -- [PJ2024-50461] Team Mapping
 1099|              , TEAM.DEPT_ID
 1100|              , TEAM.DEPT_NAME_KO
 1101|              , F.CELL_PER_CAR
 1102|              , F.CELL_PER_MODULE
 1103|              , F.CELL_PER_CAR / CASE WHEN NVL(F.CELL_PER_MODULE,0) = 0 THEN 1
 1104|                                       ELSE F.CELL_PER_MODULE END  AS MODULE_PER_CAR
 1105|              , T2.ITEM_CLASS_NAME
 1106|              , T2.ENERGE
 1107|              , TO_CHAR(T2.CELL_QUANTITY)
 1108|              , F.VALID_YN  AS ITEM_VALID_YN
 1109|         FROM   SCM_MGR.SCM_MST_SITE_ITEM F
 1110|         JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_V T2
 1111|           ON   F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
 1112|         JOIN (
 1113|              SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) || '%' TST
 1114|              FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL
 1115|         ) B ON (F.ITEM_ID LIKE B.TST OR T2.NICK_NAME LIKE B.TST)
 1116|         JOIN (
 1117|              SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL)) || '%' TST
 1118|              FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL
 1119|         ) C ON F.PROJECT_CODE LIKE C.TST
 1120|         JOIN   SCM_MGR.SCM_MST_SITE S
 1121|           ON   F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID
 1122|          AND   S.SITE_TYPE   = 'SALES'
 1123|         JOIN   SCM_MGR.SCM_MST_CITY H    ON S.CITY    = H.CITY
 1124|         JOIN   SCM_MGR.SCM_MST_COUNTRY I ON S.COUNTRY = I.COUNTRY
 1125|         LEFT   JOIN (
 1126|                         SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
 1127|                         FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B
 1128|                         JOIN   SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
 1129|                     ) TEAM
 1130|           ON   TEAM.USER_ID IN (
 1131|                    SELECT TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1)) FROM DUAL
 1132|                )
 1133|         LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
 1134|           ON   SUBSTR(F.OWNER, 1,
 1135|                       CASE WHEN INSTR(F.OWNER,',') = 0 THEN LENGTH(F.OWNER)
 1136|                            ELSE INSTR(F.OWNER,',') - 1 END) = J.USER_ID
 1137|         LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
 1138|           ON   CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID
 1139|                     ELSE F.DEPT_ID END = K.DEPT_ID   -- 20190123 KHSONG
 1140|         LEFT   JOIN (
 1141|                         SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
 1142|                         FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 1143|                         WHERE  LOOKUP_TYPE = 'CELL_TYPE'
 1144|                     ) LOOK ON LOOK.CODE = T2.CELL_TYPE
 1145|         LEFT   JOIN SCM_MGR.GT_GGET_ITEM_SINGLE_V T4
 1146|           ON   T2.DIVISION_ID = T4.DIVISION_ID
 1147|          AND   NVL(T2.FORECAST_INFO_CELL_MODEL,'') = T4.ITEM_ID
 1148|         -- [E20230720-001573] 40번사업부 AMDMO0001A모델 BIZ_TYPE/CELL_PACK_COUNT LOOKUP 적용
 1149|         LEFT   JOIN (
 1150|                         SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT
 1151|                         FROM (
 1152|                             SELECT SEGMENT2 AS MODEL
 1153|                                  , SEGMENT3 AS BIZ_TYPE
 1154|                                  , SEGMENT4 AS CELL_PACK_COUNT
 1155|                                  , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
 1156|                             FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 1157|                             WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40' AND SEGMENT1 = '40'
 1158|                         ) A WHERE MODEL_RANK = 1
 1159|                     ) LOOKA ON LOOKA.MODEL = F.ITEM_ID
 1160|         WHERE  F.DIVISION_ID = '40'
 1161|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID
 1162|                       ELSE F.SCM_SITE_ID END
 1163|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL))
 1164|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1165|           AND  ( CASE WHEN P_CUSTOMER = 'ALL' THEN P_CUSTOMER
 1166|                       ELSE F.PROJECT_CODE END
 1167|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
 1168|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL) )
 1169|           AND  ( CASE WHEN P_ITEM_TYPE = 'ALL' THEN P_ITEM_TYPE
 1170|                       ELSE T2.ITEM_TYPE END
 1171|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
 1172|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
 1173|           -- [E20230720-001573] BIZ_TYPE LOOKUP 우선 적용
 1174|           AND  ( CASE WHEN P_BIZ_TYPE = 'ALL' THEN P_BIZ_TYPE
 1175|                       WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
 1176|                       ELSE T2.FORECAST_INFO_BIZ_TYPE END
 1177|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
 1178|                      FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
 1179|           AND  ( ( P_OWNER IS NULL OR P_OWNER = '' )
 1180|                    OR F.OWNER IN (SELECT TRIM(REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL))
 1181|                                   FROM DUAL CONNECT BY REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL) IS NOT NULL) );
 1182| 
 1183|     END IF;
 1184| 
 1185|     -----------------------------------------------------------------------
 1186|     -- [20190704 KHSONG] ITEM_ID 중복 현상 방지를 위해 재 GROUP
 1187|     -- GT_GGET_SITE_ITEM_ALL → GT_GGET_SITE_ITEM
 1188|     -----------------------------------------------------------------------
 1189|     INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM
 1190|     SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
 1191|          , MAX(CELL_MODEL)
 1192|          , MAX(BIZ_TYPE)
 1193|          , MAX(END_CUSTOMER)
 1194|          , MAX(SOLDTO_CUSTOMER)
 1195|          , MAX(COUNTRY)
 1196|          , MAX(COUNTRY_NAME)
 1197|          , MAX(CITY)
 1198|          , MAX(CITY_NAME)
 1199|          , MAX(OWNER)
 1200|          , MAX(PROJECT_OWNER)
 1201|          , MAX(USER_ID)
 1202|          , MAX(ITEM_NAME)
 1203|          , MAX(ITEM_TYPE)
 1204|          , MAX(PROJECT_STATUS)
 1205|          , MAX(CUST_GROUP)
 1206|          , MAX(CUST_GROUP_DTL)
 1207|          , MAX(APPLICATION)
 1208|          , MAX(ROUTE)
 1209|          , MAX(MDM_PROJECT_NAME)
 1210|          , MAX(MIN_CAPACITY)
 1211|          , MAX(FORECAST_INFO_BIZ_TYPE)
 1212|          , MAX(FORECAST_INFO_PRODUCT_GROUP)
 1213|          , MAX(CELL_TYPE)
 1214|          , MAX(FORECAST_INFO_CELL_PACK_COUNT)
 1215|          , MAX(FORECAST_INFO_ALL)
 1216|          , MAX(FORECAST_INFO_SPEC)
 1217|          , MAX(FORECAST_INFOR_VERSION)
 1218|          , MAX(CELL_MODEL_NICK_NAME)
 1219|          , MAX(VMI_YN)
 1220|          , MAX(DMS_SALES)
 1221|          , MAX(DMS_CUSTOMER)
 1222|          , MAX(DEPT_ID)
 1223|          , MAX(DEPT_NAME_KO)
 1224|          , MAX(CELL_PER_CAR)
 1225|          , MAX(CELL_PER_MODULE)
 1226|          , MAX(MODULE_PER_CAR)
 1227|          , MAX(ITEM_CLASS_NAME)
 1228|          , MAX(ENERGE)
 1229|          , MAX(CELL_QUANTITY)
 1230|          , MAX(ITEM_VALID_YN)
 1231|     FROM   SCM_MGR.GT_GGET_SITE_ITEM_ALL
 1232|     GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;
 1233| 
 1234|     -----------------------------------------------------------------------
 1235|     -- GT_GGET_EDI_SENDER 수집
 1236|     -----------------------------------------------------------------------
 1237|     INSERT INTO SCM_MGR.GT_GGET_EDI_SENDER ( SCM_SITE_ID, SENDER_CODE, SENDER_NAME )
 1238|     SELECT A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6
 1239|     FROM   SCM_MGR.SCM_MST_SITE A
 1240|     JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
 1241|       ON   A.END_CUSTOMER = B.SEGMENT2
 1242|      AND   A.DIVISION_ID  = B.SEGMENT1
 1243|      AND   B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER'
 1244|     GROUP  BY A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6;
 1245| 
 1246|     -----------------------------------------------------------------------
 1247|     -- GT_GGET_LAST_DATA_SETUP 수집 (최종 입력일시 및 입력자)
 1248|     -----------------------------------------------------------------------
 1249|     INSERT INTO SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1250|     ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
 1251|     , CREATE_DATE, LAST_UPDATED_BY )
 1252|     SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID
 1253|          , X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
 1254|          , MAX(X.LAST_UPDATE_DATE), MAX(X.LAST_UPDATED_BY)
 1255|     FROM (
 1256|         -- DM_PLN_MKT_FCST (계획 테이블)
 1257|         SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
 1258|              , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
 1259|              , CASE WHEN A.MEASURE IN (
 1260|                         'CUST_FCST','CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1261|                         'Commercial_Agreement','Firm_Temp','Manumacturing_Material_Temp',
 1262|                         'Material_Temp','Backorder','CUST_FCST_EDI_ORG','Immidiate[Org.]',
 1263|                         'Planning_Forecast[Org.]','Commercial_Agreement[Org.]',
 1264|                         'Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]',
 1265|                         'Material_Temp[Org.]','Backorder[Org.]')
 1266|                     THEN ( CASE WHEN MAX(A.ATTRIBUTE9) IS NULL OR NVL(MAX(A.ATTRIBUTE9),'') = ''
 1267|                                 THEN MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
 1268|                                 ELSE MAX(A.ATTRIBUTE9) END )
 1269|                     ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
 1270|                END AS LAST_UPDATE_DATE
 1271|              , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
 1272|         FROM   SCM_MGR.DM_PLN_MKT_FCST A
 1273|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE B
 1274|           ON   A.MEASURE = CASE WHEN B.MEASURE = 'CUST_FCST_ORG'         THEN 'CUST_FCST'
 1275|                                 WHEN B.MEASURE = 'Customer Fcst[Org.]'   THEN 'Customer FCST'
 1276|                                 WHEN B.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN 'MKT_FCST'
 1277|                                 WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR',
 1278|                                                    'RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
 1279|                                                THEN 'RTF'
 1280|                                 ELSE B.MEASURE END
 1281|         WHERE  A.DIVISION_ID = P_DIVISION_ID
 1282|           AND  A.YYYYMMDD   >= TO_CHAR(ADD_MONTHS(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD'),-12),'YYYYMMDD')
 1283|           AND  A.YYYYMMDD   <= P_TO_YYYYMMDD
 1284|         GROUP  BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
 1285|                , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
 1286|         UNION ALL
 1287|         -- DM_PLN_MKT_FCST_RESULT (실적 테이블)
 1288|         SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
 1289|              , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
 1290|              , CASE WHEN A.MEASURE IN (
 1291|                         'CUST_FCST','CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1292|                         'Commercial_Agreement','Firm_Temp','Manumacturing_Material_Temp',
 1293|                         'Material_Temp','Backorder','CUST_FCST_EDI_ORG','Immidiate[Org.]',
 1294|                         'Planning_Forecast[Org.]','Commercial_Agreement[Org.]',
 1295|                         'Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]',
 1296|                         'Material_Temp[Org.]','Backorder[Org.]')
 1297|                     THEN ( CASE WHEN MAX(A.ATTRIBUTE9) IS NULL OR NVL(MAX(A.ATTRIBUTE9),'') = ''
 1298|                                 THEN MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
 1299|                                 ELSE MAX(A.ATTRIBUTE9) END )
 1300|                     ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
 1301|                END AS LAST_UPDATE_DATE
 1302|              , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
 1303|         FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
 1304|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE B
 1305|           ON   A.MEASURE = CASE WHEN B.MEASURE = 'CUST_FCST_ORG'         THEN 'CUST_FCST'
 1306|                                 WHEN B.MEASURE = 'Customer Fcst[Org.]'   THEN 'Customer FCST'
 1307|                                 WHEN B.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN 'MKT_FCST'
 1308|                                 WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR',
 1309|                                                    'RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
 1310|                                                THEN 'RTF'
 1311|                                 ELSE B.MEASURE END
 1312|         WHERE  A.DIVISION_ID = P_DIVISION_ID
 1313|           AND  A.YYYYMMDD   >= TO_CHAR(ADD_MONTHS(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD'),-12),'YYYYMMDD')
 1314|           AND  A.YYYYMMDD   <= P_TO_YYYYMMDD
 1315|         GROUP  BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
 1316|                , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
 1317|     ) X
 1318|     WHERE  ( X.PROJECT_CODE IS NOT NULL OR NVL(X.PROJECT_CODE,'') <> '' )
 1319|       AND  ( X.SCM_SITE_ID IS NOT NULL OR NVL(X.SCM_SITE_ID,'')  <> '' )
 1320|       AND  ( X.ITEM_ID IS NOT NULL OR NVL(X.ITEM_ID,'')      <> '' )
 1321|     GROUP  BY X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID
 1322|            ,  X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE;
 1323| 
 1324|     -----------------------------------------------------------------------
 1325|     -- GT_GGET_EDI_END_CUST 수집 (EDI END_CUSTOMER별 기간 설정)
 1326|     -----------------------------------------------------------------------
 1327|     INSERT INTO SCM_MGR.GT_GGET_EDI_END_CUST
 1328|     ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
 1329|     SELECT A.DIVISION_ID
 1330|          , A.END_CUSTOMER
 1331|          , NVL(B.SEGMENT4, '-')
 1332|          , CASE WHEN NVL(B.SEGMENT5,'Off') = 'Off' THEN -52
 1333|                 ELSE NVL(TO_NUMBER(B.ATTRIBUTE1),-1) END
 1334|          , NVL(B.ATTRIBUTE2, 'TUE')
 1335|          , NVL(TO_NUMBER(B.ATTRIBUTE3), 0)
 1336|          , NVL(B.ATTRIBUTE4, 'MON')
 1337|          , NVL(B.SEGMENT5, 'Off')
 1338|     FROM   SCM_MGR.SCM_MST_SITE A
 1339|     LEFT   OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
 1340|       ON   B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER'
 1341|      AND   A.DIVISION_ID  = B.SEGMENT1
 1342|      AND   A.END_CUSTOMER = B.SEGMENT2
 1343|      AND   B.VALID_YN     = 'Y'
 1344|     WHERE  ( A.END_CUSTOMER IS NOT NULL OR NVL(A.END_CUSTOMER,'') <> '' )
 1345|     GROUP  BY A.DIVISION_ID, A.END_CUSTOMER
 1346|            ,  B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;
 1347| 
 1348|     -----------------------------------------------------------------------
 1349|     -- GT_GGET_RPA_END_CUST 수집 (RPA END_CUSTOMER별 기간 설정)
 1350|     -----------------------------------------------------------------------
 1351|     INSERT INTO SCM_MGR.GT_GGET_RPA_END_CUST
 1352|     ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
 1353|     SELECT A.DIVISION_ID
 1354|          , A.END_CUSTOMER
 1355|          , NVL(B.SEGMENT4, '-')
 1356|          , CASE WHEN NVL(B.SEGMENT5,'Off') = 'Off' THEN -52
 1357|                 ELSE NVL(TO_NUMBER(B.ATTRIBUTE1),-1) END
 1358|          , NVL(B.ATTRIBUTE2, 'TUE')
 1359|          , NVL(TO_NUMBER(B.ATTRIBUTE3), 0)
 1360|          , NVL(B.ATTRIBUTE4, 'MON')
 1361|          , NVL(B.SEGMENT5, 'Off')
 1362|     FROM   SCM_MGR.SCM_MST_SITE A
 1363|     LEFT   OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
 1364|       ON   B.LOOKUP_TYPE  = 'RPA_END_CUSTOMER'
 1365|      AND   A.DIVISION_ID  = B.SEGMENT1
 1366|      AND   A.END_CUSTOMER = B.SEGMENT2
 1367|      AND   B.VALID_YN     = 'Y'
 1368|     WHERE  ( A.END_CUSTOMER IS NOT NULL OR NVL(A.END_CUSTOMER,'') <> '' )
 1369|     GROUP  BY A.DIVISION_ID, A.END_CUSTOMER
 1370|            ,  B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;
 1371| 
 1372|     -----------------------------------------------------------------------
 1373|     -- CAL_MONTH_END / CAL_WEEK_END 수집 (월말일 / 주말일 목록)
 1374|     -----------------------------------------------------------------------
 1375|     INSERT INTO SCM_MGR.GT_GGET_CAL_MONTH_END ( MONTH_END_DATE )
 1376|     SELECT TO_CHAR(LAST_DAY(TO_DATE(BASIS_YYYYMM,'YYYYMM')),'YYYYMMDD') AS MONTH_END_DATE
 1377|     FROM   SCM_MGR.SCM_SYS_CALENDAR_M
 1378|     WHERE  BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
 1379|     GROUP  BY BASIS_YYYYMM;
 1380| 
 1381|     INSERT INTO SCM_MGR.GT_GGET_CAL_WEEK_END ( WEEK_END_DATE )
 1382|     SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
 1383|     FROM   SCM_MGR.SCM_SYS_CALENDAR_M
 1384|     WHERE  BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
 1385|     GROUP  BY BASIS_YYYYMM, ISO_WEEK;
 1386| 
 1387| 
 1388|     -----------------------------------------------------------------------
 1389|     -- 계획 구간 INSERT 조건:
 1390|     --   V_TO_YYYYMMDD >= 당주 월요일  →  계획구간 데이터 존재
 1391|     -- CONVERT(CHAR(8), DATEADD(DD,-7, FN_NEXT_DAY(GETDATE(),'MON')),112)
 1392|     --   → TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
 1393|     -----------------------------------------------------------------------
 1394|     IF V_TO_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD') THEN
 1395| 
 1396|         -----------------------------------------------------------------------
 1397|         -- Block 1-A : MKT_FCST 계열 (CUST_FCST_EDI/Immidiate 등 제외)
 1398|         --             AS콤보박스 제거로 T4(AS_SITE_PLANT) LEFT JOIN 추가 [E20260211-001189]
 1399|         -----------------------------------------------------------------------
 1400|         INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 1401|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 1402|         , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 1403|         , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 1404|         , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 1405|         , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 1406|         , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 1407|         , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 1408|         , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 1409|         , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 1410|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 1411|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 1412|              , F.MEASURE
 1413|              , F.YYYYMMDD
 1414|              , F.QTY
 1415|              , M.MEASURE_GROUP
 1416|              , T2.CELL_MODEL
 1417|              , T2.END_CUSTOMER
 1418|              , T2.NICK_NAME
 1419|              , T2.DMS_SALES
 1420|              , T2.DMS_CUSTOMER
 1421|              , T2.OWNER
 1422|              , T2.DEPT_ID
 1423|              , T2.DEPT_NAME_KO
 1424|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 1425|              , T2.ITEM_TYPE
 1426|              , T2.PROJECT_NAME
 1427|              , T2.PROJECT_OWNER
 1428|              , T2.BIZ_TYPE
 1429|              , T2.SOLDTO_CUSTOMER
 1430|              , T2.COUNTRY_NAME
 1431|              , T2.CITY_NAME
 1432|              , T2.PROJECT_STATUS
 1433|              , T2.ITEM_NAME
 1434|              , T2.VMI_YN
 1435|              , T2.CUST_GROUP
 1436|              , T2.CUST_GROUP_DTL
 1437|              , T2.APPLICATION
 1438|              , T2.ROUTE
 1439|              , T2.MDM_PROJECT_NAME
 1440|              , T2.MIN_CAPACITY
 1441|              , T2.FORECAST_INFO_BIZ_TYPE
 1442|              , T2.CELL_TYPE
 1443|              , T2.FORECAST_INFO_ALL
 1444|              , T2.FORECAST_INFO_SPEC
 1445|              , T2.FORECAST_INFOR_VERSION
 1446|              , T2.CELL_MODEL_NICK_NAME
 1447|              , T2.CELL_PER_CAR
 1448|              , T2.CELL_PER_MODULE
 1449|              , T2.MODULE_PER_CAR
 1450|              , M.SORT_ORDER_NO
 1451|              , T2.ENERGE
 1452|              , T2.CELL_QUANTITY
 1453|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 1454|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1455|                  WHERE  DIVISION_ID  = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1456|                    AND  SCM_SITE_ID  = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1457|                    AND  DOM_EXP      = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1458|                    AND  INCOTERMS    = F.INCOTERMS    AND MEASURE      = F.MEASURE
 1459|                    AND  QTY         <> 0 )
 1460|              , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1461|                  WHERE  DIVISION_ID  = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1462|                    AND  SCM_SITE_ID  = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1463|                    AND  DOM_EXP      = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1464|                    AND  INCOTERMS    = F.INCOTERMS    AND MEASURE      = F.MEASURE )
 1465|              , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 1466|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1467|              , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 1468|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1469|         FROM   SCM_MGR.DM_PLN_MKT_FCST F
 1470|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 1471|           ON   F.MEASURE = M.MEASURE
 1472|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 1473|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 1474|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 1475|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 1476|          AND   F.ITEM_ID      = T2.ITEM_ID
 1477|          AND   T2.ITEM_VALID_YN = 'Y'
 1478|         -- [E20260211-001189] AS콤보박스 제거 → AS_SITE_PLANT LEFT JOIN으로 AS데이터 포함
 1479|         LEFT   OUTER JOIN (
 1480|                                SELECT SEGMENT1, SEGMENT2
 1481|                                FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 1482|                                WHERE  LOOKUP_TYPE = 'AS_SITE_PLANT'
 1483|                                  AND  SEGMENT3    = P_DIVISION_ID
 1484|                            ) T4 ON NVL(F.ATTRIBUTE10,'') = T4.SEGMENT2
 1485|         WHERE  F.QTY <> 0
 1486|           AND  F.MEASURE NOT IN (
 1487|                    'CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement',
 1488|                    'Firm_Temp','Manumacturing_Material_Temp','Material_Temp','Backorder',
 1489|                    'CUST_FCST','Customer FCST' )
 1490|           AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 1491|           AND  F.DIVISION_ID = P_DIVISION_ID
 1492|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 1493|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1494|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL)
 1495|                  OR
 1496|                  CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE T4.SEGMENT1 END
 1497|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1498|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1499|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 1500|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1501|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1502| 
 1503|         -----------------------------------------------------------------------
 1504|         -- Block 1-B : CUST_FCST_EDI 계열 (EDI/RPA Sender 기반)
 1505|         --             YYYYMMDD 범위: v_to_result ~ p_to_yyyymmdd  [고객수요분석시스템 정비]
 1506|         -----------------------------------------------------------------------
 1507|         UNION ALL
 1508|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 1509|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 1510|              , F.MEASURE
 1511|              , F.YYYYMMDD
 1512|              , F.QTY
 1513|              , M.MEASURE_GROUP
 1514|              , T2.CELL_MODEL
 1515|              , T2.END_CUSTOMER
 1516|              , T2.NICK_NAME
 1517|              , T2.DMS_SALES
 1518|              , T2.DMS_CUSTOMER
 1519|              , T2.OWNER
 1520|              , T2.DEPT_ID
 1521|              , T2.DEPT_NAME_KO
 1522|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 1523|              , T2.ITEM_TYPE
 1524|              , T2.PROJECT_NAME
 1525|              , T2.PROJECT_OWNER
 1526|              , T2.BIZ_TYPE
 1527|              , T2.SOLDTO_CUSTOMER
 1528|              , T2.COUNTRY_NAME
 1529|              , T2.CITY_NAME
 1530|              , T2.PROJECT_STATUS
 1531|              , T2.ITEM_NAME
 1532|              , T2.VMI_YN
 1533|              , T2.CUST_GROUP
 1534|              , T2.CUST_GROUP_DTL
 1535|              , T2.APPLICATION
 1536|              , T2.ROUTE
 1537|              , T2.MDM_PROJECT_NAME
 1538|              , T2.MIN_CAPACITY
 1539|              , T2.FORECAST_INFO_BIZ_TYPE
 1540|              , T2.CELL_TYPE
 1541|              , T2.FORECAST_INFO_ALL
 1542|              , T2.FORECAST_INFO_SPEC
 1543|              , T2.FORECAST_INFOR_VERSION
 1544|              , T2.CELL_MODEL_NICK_NAME
 1545|              , T2.CELL_PER_CAR
 1546|              , T2.CELL_PER_MODULE
 1547|              , T2.MODULE_PER_CAR
 1548|              , M.SORT_ORDER_NO
 1549|              , T2.ENERGE
 1550|              , T2.CELL_QUANTITY
 1551|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 1552|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1553|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1554|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1555|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1556|                    AND  INCOTERMS   = F.INCOTERMS
 1557|                    AND  MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1558|                                     'Commercial_Agreement','Firm_Temp',
 1559|                                     'Manumacturing_Material_Temp','Material_Temp','Backorder') )
 1560|              , CASE WHEN ( F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' ) THEN
 1561|                    ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 1562|                      WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 ) || '_EDI'
 1563|                    ELSE F.ATTRIBUTE5 || '_' || F.LAST_UPDATED_BY END  AS LAST_UPDATED_BY
 1564|              , CASE WHEN ( F.ATTRIBUTE4 IS NULL OR NVL(F.ATTRIBUTE4,'') = '' ) THEN
 1565|                    ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 1566|                      WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1567|                    ELSE F.ATTRIBUTE4 END  AS SENDER_CODE
 1568|              , CASE WHEN ( F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' ) THEN
 1569|                    ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 1570|                      WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1571|                    ELSE F.ATTRIBUTE5 END  AS SENDER_NAME
 1572|         FROM   SCM_MGR.DM_PLN_MKT_FCST F
 1573|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 1574|           ON   F.MEASURE = M.MEASURE
 1575|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 1576|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 1577|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 1578|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 1579|          AND   F.ITEM_ID      = T2.ITEM_ID
 1580|          AND   T2.ITEM_VALID_YN = 'Y'
 1581|         LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
 1582|           ON   F.DIVISION_ID  = B.DIVISION_ID
 1583|          AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
 1584|          AND   B.SITE_TYPE    = 'SALES'
 1585|          AND   B.VALID_YN     = 'Y'
 1586|          AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 1587|                          ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
 1588|                OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 1589|                          ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
 1590|         WHERE  F.QTY <> -9999999999
 1591|           AND  F.MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1592|                              'Commercial_Agreement','Firm_Temp',
 1593|                              'Manumacturing_Material_Temp','Material_Temp','Backorder')
 1594|           -- [고객수요분석시스템 정비] EDI데이터 중복건 제거: v_to_result 이후부터만 조회
 1595|           AND  F.YYYYMMDD    BETWEEN V_TO_RESULT AND P_TO_YYYYMMDD
 1596|           AND  F.DIVISION_ID = P_DIVISION_ID
 1597|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 1598|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1599|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1600|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 1601|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1602|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1603|           AND  ( CASE WHEN ( CASE WHEN F.MEASURE IN (
 1604|                                       'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1605|                                       'Commercial_Agreement','Firm_Temp',
 1606|                                       'Manumacturing_Material_Temp','Material_Temp','Backorder')
 1607|                                   THEN P_SENDER_CODE ELSE 'ALL' END ) = 'ALL'
 1608|                       THEN ( CASE WHEN F.MEASURE IN (
 1609|                                       'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1610|                                       'Commercial_Agreement','Firm_Temp',
 1611|                                       'Manumacturing_Material_Temp','Material_Temp','Backorder')
 1612|                                   THEN P_SENDER_CODE ELSE 'ALL' END )
 1613|                       ELSE F.ATTRIBUTE4 END
 1614|                  IN ( SELECT TRIM(REGEXP_SUBSTR(
 1615|                           CASE WHEN F.MEASURE IN (
 1616|                                    'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1617|                                    'Commercial_Agreement','Firm_Temp',
 1618|                                    'Manumacturing_Material_Temp','Material_Temp','Backorder')
 1619|                                THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL))
 1620|                       FROM DUAL
 1621|                       CONNECT BY REGEXP_SUBSTR(
 1622|                           CASE WHEN F.MEASURE IN (
 1623|                                    'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 1624|                                    'Commercial_Agreement','Firm_Temp',
 1625|                                    'Manumacturing_Material_Temp','Material_Temp','Backorder')
 1626|                                THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL) IS NOT NULL ) )
 1627| 
 1628|         -----------------------------------------------------------------------
 1629|         -- Block 1-C : Customer FCST (RPA/EXCEL 경로, Cust.FCST_RPA[P+P] / Cust.FCST_EXCEL[P+P] 으로 표시)
 1630|         --             [E20241126-000426] Customer FCST 전용 로직
 1631|         -----------------------------------------------------------------------
 1632|         UNION ALL
 1633|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 1634|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 1635|              , CASE WHEN F.MEASURE = 'Customer FCST' THEN
 1636|                         CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
 1637|                              THEN 'Cust.FCST_RPA[P+P]'
 1638|                              ELSE 'Cust.FCST_EXCEL[P+P]' END
 1639|                     ELSE F.MEASURE END  AS MEASURE
 1640|              , F.YYYYMMDD
 1641|              , F.QTY
 1642|              , M.MEASURE_GROUP
 1643|              , T2.CELL_MODEL
 1644|              , T2.END_CUSTOMER
 1645|              , T2.NICK_NAME
 1646|              , T2.DMS_SALES
 1647|              , T2.DMS_CUSTOMER
 1648|              , T2.OWNER
 1649|              , T2.DEPT_ID
 1650|              , T2.DEPT_NAME_KO
 1651|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 1652|              , T2.ITEM_TYPE
 1653|              , T2.PROJECT_NAME
 1654|              , T2.PROJECT_OWNER
 1655|              , T2.BIZ_TYPE
 1656|              , T2.SOLDTO_CUSTOMER
 1657|              , T2.COUNTRY_NAME
 1658|              , T2.CITY_NAME
 1659|              , T2.PROJECT_STATUS
 1660|              , T2.ITEM_NAME
 1661|              , T2.VMI_YN
 1662|              , T2.CUST_GROUP
 1663|              , T2.CUST_GROUP_DTL
 1664|              , T2.APPLICATION
 1665|              , T2.ROUTE
 1666|              , T2.MDM_PROJECT_NAME
 1667|              , T2.MIN_CAPACITY
 1668|              , T2.FORECAST_INFO_BIZ_TYPE
 1669|              , T2.CELL_TYPE
 1670|              , T2.FORECAST_INFO_ALL
 1671|              , T2.FORECAST_INFO_SPEC
 1672|              , T2.FORECAST_INFOR_VERSION
 1673|              , T2.CELL_MODEL_NICK_NAME
 1674|              , T2.CELL_PER_CAR
 1675|              , T2.CELL_PER_MODULE
 1676|              , T2.MODULE_PER_CAR
 1677|              , M.SORT_ORDER_NO
 1678|              , T2.ENERGE
 1679|              , T2.CELL_QUANTITY
 1680|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 1681|              -- [E20241126-000426] Customer FCST 전용 LAST_DATA_SETUP
 1682|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1683|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1684|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1685|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1686|                    AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'Customer FCST' )
 1687|              , CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
 1688|                     THEN F.LAST_UPDATED_BY || '_RPA'
 1689|                     ELSE F.LAST_UPDATED_BY || '_EXCEL' END  AS LAST_UPDATED_BY
 1690|              , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 1691|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1692|              , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 1693|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1694|         FROM   SCM_MGR.DM_PLN_MKT_FCST F
 1695|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 1696|           ON   F.MEASURE = M.MEASURE
 1697|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 1698|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 1699|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 1700|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 1701|          AND   F.ITEM_ID      = T2.ITEM_ID
 1702|          AND   T2.ITEM_VALID_YN = 'Y'
 1703|         LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
 1704|           ON   F.DIVISION_ID  = B.DIVISION_ID
 1705|          AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
 1706|          AND   B.SITE_TYPE    = 'SALES'
 1707|          AND   B.VALID_YN     = 'Y'
 1708|          AND   ( ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 1709|                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
 1710|                OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 1711|                     ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
 1712|         WHERE  F.QTY <> 0
 1713|           -- [E20241126-000426] Customer FCST 전용
 1714|           AND  F.MEASURE      = 'Customer FCST'
 1715|           AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 1716|           AND  F.DIVISION_ID  = P_DIVISION_ID
 1717|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 1718|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1719|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1720|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 1721|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1722|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1723| 
 1724|         -----------------------------------------------------------------------
 1725|         -- Block 1-D : CUST_FCST 전용  [E20241126-000426]
 1726|         -----------------------------------------------------------------------
 1727|         UNION ALL
 1728|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 1729|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 1730|              , F.MEASURE
 1731|              , F.YYYYMMDD
 1732|              , F.QTY
 1733|              , M.MEASURE_GROUP
 1734|              , T2.CELL_MODEL
 1735|              , T2.END_CUSTOMER
 1736|              , T2.NICK_NAME
 1737|              , T2.DMS_SALES
 1738|              , T2.DMS_CUSTOMER
 1739|              , T2.OWNER
 1740|              , T2.DEPT_ID
 1741|              , T2.DEPT_NAME_KO
 1742|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 1743|              , T2.ITEM_TYPE
 1744|              , T2.PROJECT_NAME
 1745|              , T2.PROJECT_OWNER
 1746|              , T2.BIZ_TYPE
 1747|              , T2.SOLDTO_CUSTOMER
 1748|              , T2.COUNTRY_NAME
 1749|              , T2.CITY_NAME
 1750|              , T2.PROJECT_STATUS
 1751|              , T2.ITEM_NAME
 1752|              , T2.VMI_YN
 1753|              , T2.CUST_GROUP
 1754|              , T2.CUST_GROUP_DTL
 1755|              , T2.APPLICATION
 1756|              , T2.ROUTE
 1757|              , T2.MDM_PROJECT_NAME
 1758|              , T2.MIN_CAPACITY
 1759|              , T2.FORECAST_INFO_BIZ_TYPE
 1760|              , T2.CELL_TYPE
 1761|              , T2.FORECAST_INFO_ALL
 1762|              , T2.FORECAST_INFO_SPEC
 1763|              , T2.FORECAST_INFOR_VERSION
 1764|              , T2.CELL_MODEL_NICK_NAME
 1765|              , T2.CELL_PER_CAR
 1766|              , T2.CELL_PER_MODULE
 1767|              , T2.MODULE_PER_CAR
 1768|              , M.SORT_ORDER_NO
 1769|              , T2.ENERGE
 1770|              , T2.CELL_QUANTITY
 1771|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 1772|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1773|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1774|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1775|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1776|                    AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'CUST_FCST' )
 1777|              , F.LAST_UPDATED_BY
 1778|              , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 1779|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1780|              , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 1781|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1782|         FROM   SCM_MGR.DM_PLN_MKT_FCST F
 1783|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 1784|           ON   F.MEASURE = M.MEASURE
 1785|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 1786|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 1787|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 1788|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 1789|          AND   F.ITEM_ID      = T2.ITEM_ID
 1790|          AND   T2.ITEM_VALID_YN = 'Y'
 1791|         LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
 1792|           ON   F.DIVISION_ID  = B.DIVISION_ID
 1793|          AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
 1794|          AND   B.SITE_TYPE    = 'SALES'
 1795|          AND   B.VALID_YN     = 'Y'
 1796|          AND  ( ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 1797|                         ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
 1798|                 OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 1799|                           ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
 1800|         WHERE  F.QTY <> 0
 1801|           AND  F.MEASURE      = 'CUST_FCST'
 1802|           AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 1803|           AND  F.DIVISION_ID  = P_DIVISION_ID
 1804|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 1805|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1806|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1807|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 1808|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1809|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 1810| 
 1811|         -----------------------------------------------------------------------
 1812|         -- Block 2 : MKT_FCST_RP / MKT_FCST_RP_CAR / MKT_FCST_RP_CELL
 1813|         --           (Cell/Car/Module 환산 포함)
 1814|         -----------------------------------------------------------------------
 1815|         DECLARE
 1816|             V_RP_CNT PLS_INTEGER := 0;
 1817|         BEGIN
 1818|             SELECT COUNT(1) INTO V_RP_CNT
 1819|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 1820|             WHERE  MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL');
 1821| 
 1822|             IF V_RP_CNT > 0 THEN
 1823|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 1824|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 1825|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 1826|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 1827|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 1828|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 1829|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 1830|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 1831|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 1832|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 1833|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 1834|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 1835|                      , CASE WHEN M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
 1836|                             THEN M.MEASURE ELSE F.MEASURE END  AS MEASURE
 1837|                      , F.YYYYMMDD
 1838|                      , CASE
 1839|                            WHEN M.MEASURE = 'MKT_FCST_RP' THEN F.QTY
 1840|                            WHEN M.MEASURE = 'MKT_FCST_RP_CAR' THEN
 1841|                                CASE
 1842|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell') > 0   AND NVL(T2.CELL_PER_CAR,0) > 0
 1843|                                         THEN F.QTY / T2.CELL_PER_CAR
 1844|                                    -- [C20200212-000304] Module: QTY / MODULE_PER_CAR
 1845|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0) > 0
 1846|                                     AND NVL(T2.CELL_PER_MODULE,0) > 0
 1847|                                         THEN F.QTY / T2.MODULE_PER_CAR
 1848|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack') > 0   THEN F.QTY
 1849|                                    ELSE 0
 1850|                                END
 1851|                            WHEN M.MEASURE = 'MKT_FCST_RP_CELL' AND F.DIVISION_ID LIKE '81%' THEN
 1852|                                CASE
 1853|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
 1854|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
 1855|                                    -- [C20200511-000360] Pack → CELL_PER_CAR 곱
 1856|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
 1857|                                    ELSE 0
 1858|                                END
 1859|                            -- [C20200114-000201] ESS(82): CELL_QUANTITY 곱
 1860|                            WHEN M.MEASURE = 'MKT_FCST_RP_CELL' AND F.DIVISION_ID = '82' THEN
 1861|                                F.QTY * T2.CELL_QUANTITY
 1862|                        END  AS QTY
 1863|                      , M.MEASURE_GROUP
 1864|                      , T2.CELL_MODEL
 1865|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 1866|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 1867|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 1868|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 1869|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 1870|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 1871|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 1872|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 1873|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 1874|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 1875|                      , T2.CELL_MODEL_NICK_NAME
 1876|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 1877|                      , M.SORT_ORDER_NO
 1878|                      , T2.ENERGE, T2.CELL_QUANTITY
 1879|                      , F.ATTRIBUTE10  AS AS_FROM_SITE
 1880|                      , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1881|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1882|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1883|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1884|                            AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST' )
 1885|                      , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1886|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1887|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1888|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 1889|                            AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST'
 1890|                            AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 1891|                                                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 1892|                                                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 1893|                                                   AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
 1894|                                                   AND  INCOTERMS   = F.INCOTERMS   AND MEASURE       = 'MKT_FCST' ) )
 1895|                      , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 1896|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1897|                      , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 1898|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 1899|                 FROM   SCM_MGR.DM_PLN_MKT_FCST F
 1900|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 1901|                   ON   F.MEASURE = 'MKT_FCST'
 1902|                  AND   M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
 1903|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 1904|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 1905|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 1906|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 1907|                  AND   F.ITEM_ID      = T2.ITEM_ID
 1908|                  AND   T2.ITEM_VALID_YN = 'Y'
 1909|                 WHERE  F.MEASURE = CASE WHEN M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
 1910|                                         THEN 'MKT_FCST' ELSE M.MEASURE END
 1911|                   AND  F.QTY <> 0
 1912|                   AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 1913|                   AND  F.DIVISION_ID = P_DIVISION_ID
 1914|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 1915|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1916|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 1917|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 1918|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 1919|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 1920|             END IF;  -- Block 2 END
 1921|         END;
 1922| 
 1923|         -----------------------------------------------------------------------
 1924|         -- Block 3 : RTF_RP_CAR / RTF_SYS_RP_CAR / RTF_RP_CELL / RTF_SYS_RP_CELL / RTF_ENERGY
 1925|         --           [CSR ID:4023158] 20190705 KHSONG
 1926|         --           [C20211103-000146] 20211119 RTF_ENERGY 추가
 1927|         -----------------------------------------------------------------------
 1928|         DECLARE
 1929|             V_RTF_CNT PLS_INTEGER := 0;
 1930|         BEGIN
 1931|             SELECT COUNT(1) INTO V_RTF_CNT
 1932|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 1933|             WHERE  MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY');
 1934| 
 1935|             IF V_RTF_CNT > 0 THEN
 1936|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 1937|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 1938|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 1939|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 1940|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 1941|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 1942|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 1943|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 1944|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 1945|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 1946|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 1947|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 1948|                      -- Measure명 결정
 1949|                      , CASE
 1950|                            WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
 1951|                                CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CAR'
 1952|                                     WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CAR'
 1953|                                     ELSE '' END
 1954|                            WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
 1955|                                CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CELL'
 1956|                                     WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CELL'
 1957|                                     ELSE '' END
 1958|                            WHEN M.MEASURE = 'RTF_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_ENERGY'
 1959|                        END  AS MEASURE
 1960|                      , F.YYYYMMDD
 1961|                      -- QTY 환산
 1962|                      , CASE
 1963|                            WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
 1964|                                CASE
 1965|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0) > 0
 1966|                                         THEN F.QTY / T2.CELL_PER_CAR
 1967|                                    -- [C20200212-000304] Module → MODULE_PER_CAR
 1968|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0
 1969|                                     AND NVL(T2.CELL_PER_CAR,0) > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0
 1970|                                         THEN F.QTY / T2.MODULE_PER_CAR
 1971|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 THEN F.QTY
 1972|                                    ELSE 0
 1973|                                END
 1974|                            WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') AND F.DIVISION_ID LIKE '81%' THEN
 1975|                                CASE
 1976|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
 1977|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
 1978|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
 1979|                                    ELSE 0
 1980|                                END
 1981|                            -- [C20200114-000201] ESS(82) RTF_RP_CELL: CELL_QUANTITY 곱
 1982|                            WHEN M.MEASURE = 'RTF_RP_CELL' AND F.DIVISION_ID = '82' THEN
 1983|                                F.QTY * T2.CELL_QUANTITY
 1984|                            -- [C20211103-000146] RTF_ENERGY: ENERGE * QTY / 1000
 1985|                            WHEN M.MEASURE = 'RTF_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN
 1986|                                CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
 1987|                                     THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
 1988|                                END
 1989|                        END  AS QTY
 1990|                      , M.MEASURE_GROUP
 1991|                      , T2.CELL_MODEL
 1992|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 1993|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 1994|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 1995|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 1996|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 1997|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 1998|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 1999|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2000|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2001|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2002|                      , T2.CELL_MODEL_NICK_NAME
 2003|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2004|                      , M.SORT_ORDER_NO
 2005|                      , T2.ENERGE, T2.CELL_QUANTITY
 2006|                      , F.ATTRIBUTE10  AS AS_FROM_SITE
 2007|                      , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2008|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2009|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2010|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2011|                            AND  INCOTERMS   = F.INCOTERMS
 2012|                            AND  MEASURE    IN ('RTF','RTF_SYS_RP') )
 2013|                      , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2014|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2015|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2016|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2017|                            AND  INCOTERMS   = F.INCOTERMS
 2018|                            AND  MEASURE    IN ('RTF','RTF_SYS_RP')
 2019|                            AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2020|                                                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2021|                                                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2022|                                                   AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
 2023|                                                   AND  INCOTERMS   = F.INCOTERMS
 2024|                                                   AND  MEASURE    IN ('RTF','RTF_SYS_RP') ) )
 2025|                      , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2026|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2027|                      , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2028|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2029|                 FROM   SCM_MGR.DM_PLN_MKT_FCST F
 2030|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2031|                   ON   F.MEASURE IN ('RTF','RTF_SYS_RP')
 2032|                  AND   M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
 2033|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2034|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 2035|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2036|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2037|                  AND   F.ITEM_ID      = T2.ITEM_ID
 2038|                  AND   T2.ITEM_VALID_YN = 'Y'
 2039|                 WHERE  F.MEASURE = CASE
 2040|                                        WHEN M.MEASURE IN ('RTF_RP_CAR', 'RTF_RP_CELL')                    THEN 'RTF'
 2041|                                        WHEN M.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL','RTF_ENERGY') THEN 'RTF_SYS_RP'
 2042|                                        ELSE M.MEASURE END
 2043|                   AND  F.QTY <> 0
 2044|                   AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 2045|                   AND  F.DIVISION_ID = P_DIVISION_ID
 2046|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2047|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2048|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2049|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2050|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2051|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2052|             END IF;  -- Block 3 END
 2053|         END;
 2054| 
 2055| 
 2056|         -----------------------------------------------------------------------
 2057|         -- Block 4 : MKT_FCST_ENERGY  [C20221207-000080] 20221214 rosia27
 2058|         --           소스: GT_GGET_MKT_FCST_DATA 에 이미 들어간 MKT_FCST_RP 행에서 파생
 2059|         --           (원본: #TempMktFcstData JOIN #TempSiteItem)
 2060|         -----------------------------------------------------------------------
 2061|         DECLARE
 2062|             V_ENERGY_CNT PLS_INTEGER := 0;
 2063|         BEGIN
 2064|             SELECT COUNT(1) INTO V_ENERGY_CNT
 2065|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 2066|             WHERE  MEASURE = 'MKT_FCST_ENERGY';
 2067| 
 2068|             IF V_ENERGY_CNT > 0 THEN
 2069|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 2070|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2071|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 2072|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 2073|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 2074|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 2075|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2076|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 2077|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2078|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2079|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2080|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2081|                      , CASE WHEN M.MEASURE = 'MKT_FCST_ENERGY' AND F.MEASURE = 'MKT_FCST_RP'
 2082|                             THEN 'MKT_FCST_ENERGY' END  AS MEASURE
 2083|                      , F.YYYYMMDD
 2084|                      , CASE WHEN M.MEASURE = 'MKT_FCST_ENERGY' THEN
 2085|                                CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
 2086|                                     THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
 2087|                                END
 2088|                             ELSE 0 END  AS QTY
 2089|                      , M.MEASURE_GROUP
 2090|                      , T2.CELL_MODEL
 2091|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2092|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2093|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 2094|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2095|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2096|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2097|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2098|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2099|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2100|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2101|                      , T2.CELL_MODEL_NICK_NAME
 2102|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2103|                      , M.SORT_ORDER_NO
 2104|                      , T2.ENERGE, T2.CELL_QUANTITY
 2105|                      -- MKT_FCST_ENERGY는 GT_GGET_MKT_FCST_DATA의 MKT_FCST_RP 행에서 파생
 2106|                      -- CREATE_DATE / LAST_UPDATED_BY / SENDER_* 는 원본 F 행 값 그대로 사용
 2107|                      , F.AS_FROM_SITE
 2108|                      , F.CREATE_DATE
 2109|                      , F.LAST_UPDATED_BY
 2110|                      , F.SENDER_CODE
 2111|                      , F.SENDER_NAME
 2112|                 FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA F   -- 이미 삽입된 MKT_FCST_RP 행을 소스로 사용
 2113|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2114|                   ON   F.MEASURE = 'MKT_FCST_RP'
 2115|                  AND   M.MEASURE = 'MKT_FCST_ENERGY'
 2116|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2117|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 2118|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2119|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2120|                  AND   F.ITEM_ID      = T2.ITEM_ID
 2121|                  AND   T2.ITEM_VALID_YN = 'Y'
 2122|                 WHERE  F.QTY <> 0
 2123|                   AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 2124|                   AND  F.DIVISION_ID = P_DIVISION_ID
 2125|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2126|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2127|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2128|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2129|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2130|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2131|             END IF;  -- Block 4 END
 2132|         END;
 2133| 
 2134|     END IF;  -- 계획 구간 조건 END (V_TO_YYYYMMDD >= 당주 월요일)
 2135| 
 2136| 
 2137|     -----------------------------------------------------------------------
 2138|     -- 실적 구간 INSERT 조건:
 2139|     --   V_FROM_YYYYMMDD <= 당주 월요일
 2140|     -- CONVERT(CHAR(8), DATEADD(DD,-7, FN_NEXT_DAY(GETDATE(),'MON')),112)
 2141|     --   → TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
 2142|     -----------------------------------------------------------------------
 2143|     IF V_FROM_YYYYMMDD <= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD') THEN
 2144| 
 2145|         -----------------------------------------------------------------------
 2146|         -- [PJ2025-50188] GT_GGET_MKT_FCST_RESULT 생성
 2147|         --   DM_PLN_MKT_FCST_RESULT에 CELL_PROD_SITE_ID 컬럼이 추가되어
 2148|         --   DUP 방지를 위해 CELL_PROD_SITE_ID 제거 후 GROUP BY로 집계
 2149|         -----------------------------------------------------------------------
 2150|         INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_RESULT
 2151|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2152|         , MEASURE, PLANT_SITE_ID, YYYYMMDD
 2153|         , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
 2154|         , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
 2155|         , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
 2156|         , QTY )
 2157|         SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2158|              , MEASURE, PLANT_SITE_ID, YYYYMMDD
 2159|              , MAX(CREATED_BY)        AS CREATED_BY
 2160|              , MAX(CREATION_DATE)     AS CREATION_DATE
 2161|              , MAX(LAST_UPDATED_BY)   AS LAST_UPDATED_BY
 2162|              , MAX(LAST_UPDATE_DATE)  AS LAST_UPDATE_DATE
 2163|              , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
 2164|              , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
 2165|              , SUM(QTY)               AS QTY
 2166|         FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT
 2167|         WHERE  DIVISION_ID  = P_DIVISION_ID
 2168|           AND  YYYYMMDD    >= P_FROM_YYYYMMDD
 2169|           AND  YYYYMMDD     < V_TO_RESULT
 2170|         GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2171|                ,  MEASURE, PLANT_SITE_ID, YYYYMMDD
 2172|                ,  ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
 2173|                ,  ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10;
 2174| 
 2175|         -----------------------------------------------------------------------
 2176|         -- Block R-1 ~ R-4: 단일 INSERT … UNION ALL
 2177|         --   소스: GT_GGET_MKT_FCST_RESULT (= 집계된 실적 테이블)
 2178|         -----------------------------------------------------------------------
 2179|         INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 2180|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2181|         , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 2182|         , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 2183|         , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 2184|         , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 2185|         , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2186|         , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 2187|         , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2188|         , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2189| 
 2190|         -----------------------------------------------------------------------
 2191|         -- R-1: MKT_FCST 계열 (CUST_FCST_EDI 계열 및 CUST_FCST/Customer FCST 제외)
 2192|         -----------------------------------------------------------------------
 2193|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2194|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2195|              , F.MEASURE
 2196|              , F.YYYYMMDD, F.QTY
 2197|              , M.MEASURE_GROUP
 2198|              , T2.CELL_MODEL
 2199|              , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2200|              , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2201|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 2202|              , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2203|              , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2204|              , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2205|              , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2206|              , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2207|              , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2208|              , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2209|              , T2.CELL_MODEL_NICK_NAME
 2210|              , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2211|              , M.SORT_ORDER_NO
 2212|              , T2.ENERGE, T2.CELL_QUANTITY
 2213|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 2214|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2215|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2216|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2217|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2218|                    AND  INCOTERMS   = F.INCOTERMS
 2219|                    AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END )
 2220|              , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2221|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2222|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2223|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2224|                    AND  INCOTERMS   = F.INCOTERMS
 2225|                    AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END
 2226|                    AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2227|                                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2228|                                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2229|                                           AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
 2230|                                           AND  INCOTERMS   = F.INCOTERMS
 2231|                                           AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END ) )
 2232|              , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2233|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2234|              , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2235|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2236|         FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2237|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2238|           ON   F.MEASURE = M.MEASURE
 2239|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2240|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 2241|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2242|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2243|          AND   F.ITEM_ID      = T2.ITEM_ID
 2244|         WHERE  F.QTY <> 0
 2245|           AND  F.MEASURE NOT IN (
 2246|                    'CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement',
 2247|                    'Firm_Temp','Manumacturing_Material_Temp','Material_Temp','Backorder',
 2248|                    'CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]',
 2249|                    'Commercial_Agreement[Org.]','Firm_Temp[Org.]',
 2250|                    'Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]',
 2251|                    'CUST_FCST','Customer FCST' )
 2252|           AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2253|           AND  F.YYYYMMDD     < V_TO_RESULT
 2254|           AND  F.DIVISION_ID  = P_DIVISION_ID
 2255|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2256|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2257|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2258|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2259|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2260|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2261| 
 2262|         -----------------------------------------------------------------------
 2263|         -- R-2: CUST_FCST_EDI 계열 (EDI Sender 포함)
 2264|         -----------------------------------------------------------------------
 2265|         UNION ALL
 2266|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2267|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2268|              , F.MEASURE
 2269|              , F.YYYYMMDD, F.QTY
 2270|              , M.MEASURE_GROUP
 2271|              , T2.CELL_MODEL
 2272|              , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2273|              , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2274|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 2275|              , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2276|              , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2277|              , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2278|              , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2279|              , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2280|              , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2281|              , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2282|              , T2.CELL_MODEL_NICK_NAME
 2283|              , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2284|              , M.SORT_ORDER_NO
 2285|              , T2.ENERGE, T2.CELL_QUANTITY
 2286|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 2287|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2288|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2289|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2290|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2291|                    AND  INCOTERMS   = F.INCOTERMS
 2292|                    AND  MEASURE    IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
 2293|                                        'Commercial_Agreement','Firm_Temp',
 2294|                                        'Manumacturing_Material_Temp','Material_Temp','Backorder') )
 2295|              , CASE WHEN F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' THEN
 2296|                    ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2297|                      WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 ) || '_EDI'
 2298|                    ELSE F.ATTRIBUTE5 || '_' || F.LAST_UPDATED_BY END  AS LAST_UPDATED_BY
 2299|              , CASE WHEN F.ATTRIBUTE4 IS NULL OR NVL(F.ATTRIBUTE4,'') = '' THEN
 2300|                    ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2301|                      WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2302|                    ELSE F.ATTRIBUTE4 END  AS SENDER_CODE
 2303|              , CASE WHEN F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' THEN
 2304|                    ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2305|                      WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2306|                    ELSE F.ATTRIBUTE5 END  AS SENDER_NAME
 2307|         FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2308|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2309|           ON   F.MEASURE = M.MEASURE
 2310|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2311|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 2312|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2313|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2314|          AND   F.ITEM_ID      = T2.ITEM_ID
 2315|         LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
 2316|           ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
 2317|          AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
 2318|          AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 2319|                     ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
 2320|                OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 2321|                       ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
 2322|         WHERE  F.QTY <> -9999999999
 2323|           AND  F.MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
 2324|                              'Commercial_Agreement','Firm_Temp',
 2325|                              'Manumacturing_Material_Temp','Material_Temp','Backorder')
 2326|           -- [E20241126-000426] EDI 기간 필터 주석처리(배치에서 정리) → 단순 날짜 범위만 적용
 2327|           AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2328|           AND  F.YYYYMMDD     < V_TO_RESULT
 2329|           AND  F.DIVISION_ID  = P_DIVISION_ID
 2330|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2331|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2332|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2333|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2334|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2335|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2336|           AND  ( CASE WHEN ( CASE WHEN F.MEASURE IN (
 2337|                                       'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 2338|                                       'Commercial_Agreement','Firm_Temp',
 2339|                                       'Manumacturing_Material_Temp','Material_Temp','Backorder')
 2340|                                   THEN P_SENDER_CODE ELSE 'ALL' END ) = 'ALL'
 2341|                       THEN ( CASE WHEN F.MEASURE IN (
 2342|                                       'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 2343|                                       'Commercial_Agreement','Firm_Temp',
 2344|                                       'Manumacturing_Material_Temp','Material_Temp','Backorder')
 2345|                                   THEN P_SENDER_CODE ELSE 'ALL' END )
 2346|                       ELSE F.ATTRIBUTE4 END
 2347|                  IN ( SELECT TRIM(REGEXP_SUBSTR(
 2348|                           CASE WHEN F.MEASURE IN (
 2349|                                    'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 2350|                                    'Commercial_Agreement','Firm_Temp',
 2351|                                    'Manumacturing_Material_Temp','Material_Temp','Backorder')
 2352|                                THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL))
 2353|                       FROM DUAL
 2354|                       CONNECT BY REGEXP_SUBSTR(
 2355|                           CASE WHEN F.MEASURE IN (
 2356|                                    'CUST_FCST_EDI','Immidiate','Planning_Forecast',
 2357|                                    'Commercial_Agreement','Firm_Temp',
 2358|                                    'Manumacturing_Material_Temp','Material_Temp','Backorder')
 2359|                                THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL) IS NOT NULL ) )
 2360| 
 2361|         -----------------------------------------------------------------------
 2362|         -- R-3: Customer FCST (RPA/EXCEL → Cust.FCST_RPA/EXCEL[P+P])
 2363|         --      [E20241126-000426] Customer FCST 전용; LAST_UPDATED_BY는 CREATED_BY 기반
 2364|         -----------------------------------------------------------------------
 2365|         UNION ALL
 2366|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2367|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2368|              , CASE WHEN F.MEASURE = 'Customer FCST' THEN
 2369|                         CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
 2370|                              THEN 'Cust.FCST_RPA[P+P]'
 2371|                              ELSE 'Cust.FCST_EXCEL[P+P]' END
 2372|                     ELSE F.MEASURE END  AS MEASURE
 2373|              , F.YYYYMMDD, F.QTY
 2374|              , M.MEASURE_GROUP
 2375|              , T2.CELL_MODEL
 2376|              , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2377|              , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2378|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 2379|              , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2380|              , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2381|              , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2382|              , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2383|              , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2384|              , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2385|              , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2386|              , T2.CELL_MODEL_NICK_NAME
 2387|              , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2388|              , M.SORT_ORDER_NO
 2389|              , T2.ENERGE, T2.CELL_QUANTITY
 2390|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 2391|              -- [E20241126-000426] Customer FCST 전용 CREATE_DATE
 2392|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2393|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2394|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2395|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2396|                    AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'Customer FCST' )
 2397|              -- [PJ2025-50188] 실적은 CREATED_BY 기반으로 _RPA/_EXCEL 결정
 2398|              , CASE WHEN F.CREATED_BY LIKE '%robot'
 2399|                     THEN F.CREATED_BY || '_RPA'
 2400|                     ELSE F.CREATED_BY || '_EXCEL' END  AS LAST_UPDATED_BY
 2401|              , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2402|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2403|              , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2404|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2405|         FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2406|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2407|           ON   F.MEASURE = M.MEASURE
 2408|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2409|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 2410|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2411|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2412|          AND   F.ITEM_ID      = T2.ITEM_ID
 2413|         LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
 2414|           ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
 2415|          AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
 2416|          AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 2417|                     ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
 2418|                OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 2419|                       ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
 2420|         WHERE  F.QTY <> 0
 2421|           -- [E20241126-000426] Customer FCST 전용
 2422|           AND  F.MEASURE      = 'Customer FCST'
 2423|           -- [E20241126-000426] 날짜 필터 단순화(배치에서 RPA 기간 정리)
 2424|           AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2425|           AND  F.YYYYMMDD     < V_TO_RESULT
 2426|           AND  F.DIVISION_ID  = P_DIVISION_ID
 2427|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2428|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2429|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2430|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2431|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2432|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2433| 
 2434|         -----------------------------------------------------------------------
 2435|         -- R-4: CUST_FCST 전용  [E20241126-000426]
 2436|         -----------------------------------------------------------------------
 2437|         UNION ALL
 2438|         SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2439|              , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2440|              , F.MEASURE
 2441|              , F.YYYYMMDD, F.QTY
 2442|              , M.MEASURE_GROUP
 2443|              , T2.CELL_MODEL
 2444|              , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2445|              , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2446|              , T2.FORECAST_INFO_CELL_PACK_COUNT
 2447|              , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2448|              , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2449|              , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2450|              , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2451|              , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2452|              , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2453|              , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2454|              , T2.CELL_MODEL_NICK_NAME
 2455|              , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2456|              , M.SORT_ORDER_NO
 2457|              , T2.ENERGE, T2.CELL_QUANTITY
 2458|              , F.ATTRIBUTE10  AS AS_FROM_SITE
 2459|              , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2460|                  WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2461|                    AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2462|                    AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2463|                    AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'CUST_FCST' )
 2464|              , F.LAST_UPDATED_BY
 2465|              , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2466|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2467|              , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2468|                  WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2469|         FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2470|         JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2471|           ON   F.MEASURE = M.MEASURE
 2472|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2473|           ON   F.DIVISION_ID  = T2.DIVISION_ID
 2474|          AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2475|          AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2476|          AND   F.ITEM_ID      = T2.ITEM_ID
 2477|         LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
 2478|           ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
 2479|          AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
 2480|          AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 2481|                     ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
 2482|                OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
 2483|                       ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
 2484|         WHERE  F.QTY <> 0
 2485|           AND  F.MEASURE      = 'CUST_FCST'
 2486|           AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2487|           AND  F.YYYYMMDD     < V_TO_RESULT
 2488|           AND  F.DIVISION_ID  = P_DIVISION_ID
 2489|           AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2490|                  IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2491|                      CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2492|           AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2493|                  IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2494|                      CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2495| 
 2496|         -----------------------------------------------------------------------
 2497|         -- Block R-5 : MKT_FCST_RP_CAR / MKT_FCST_RP_CELL
 2498|         --   소스: GT_GGET_MKT_FCST_RESULT (RTF → 실적 기준)
 2499|         --   20190722 KHSONG: MKT_FCST_RESULT에서 RTF 컬럼이 실적값
 2500|         -----------------------------------------------------------------------
 2501|         DECLARE
 2502|             V_RP_RESULT_CNT PLS_INTEGER := 0;
 2503|         BEGIN
 2504|             SELECT COUNT(1) INTO V_RP_RESULT_CNT
 2505|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 2506|             WHERE  MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL');
 2507| 
 2508|             IF V_RP_RESULT_CNT > 0 THEN
 2509|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 2510|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2511|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 2512|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 2513|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 2514|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 2515|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2516|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 2517|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2518|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2519|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2520|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2521|                      , CASE WHEN M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
 2522|                             THEN M.MEASURE ELSE F.MEASURE END  AS MEASURE
 2523|                      , F.YYYYMMDD
 2524|                      , CASE
 2525|                            WHEN M.MEASURE = 'MKT_FCST_RP_CAR' THEN
 2526|                                CASE
 2527|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY / T2.CELL_PER_CAR
 2528|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0
 2529|                                     AND NVL(T2.CELL_PER_MODULE,0) > 0                                             THEN F.QTY / T2.MODULE_PER_CAR
 2530|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0                                    THEN F.QTY
 2531|                                    ELSE 0
 2532|                                END
 2533|                            WHEN M.MEASURE = 'MKT_FCST_RP_CELL' THEN
 2534|                                CASE
 2535|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
 2536|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
 2537|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
 2538|                                    ELSE 0
 2539|                                END
 2540|                        END  AS QTY
 2541|                      , M.MEASURE_GROUP
 2542|                      , T2.CELL_MODEL
 2543|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2544|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2545|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 2546|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2547|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2548|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2549|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2550|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2551|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2552|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2553|                      , T2.CELL_MODEL_NICK_NAME
 2554|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2555|                      , M.SORT_ORDER_NO
 2556|                      , T2.ENERGE, T2.CELL_QUANTITY
 2557|                      , F.ATTRIBUTE10  AS AS_FROM_SITE
 2558|                      , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2559|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2560|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2561|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2562|                            AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST' )
 2563|                      , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2564|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2565|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2566|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2567|                            AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST'
 2568|                            AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2569|                                                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2570|                                                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2571|                                                   AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
 2572|                                                   AND  INCOTERMS   = F.INCOTERMS   AND MEASURE       = 'MKT_FCST' ) )
 2573|                      , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2574|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2575|                      , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2576|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2577|                 FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2578|                 -- 실적에서 RTF는 MKT_FCST_RP_CAR/CELL 환산 소스 (20190722 KHSONG)
 2579|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2580|                   ON   F.MEASURE = 'RTF'
 2581|                  AND   M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
 2582|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2583|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 2584|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2585|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2586|                  AND   F.ITEM_ID      = T2.ITEM_ID
 2587|                 WHERE  F.MEASURE = CASE WHEN M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
 2588|                                         THEN 'RTF' ELSE M.MEASURE END
 2589|                   AND  F.QTY <> 0
 2590|                   AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2591|                   AND  F.YYYYMMDD     < V_TO_RESULT
 2592|                   AND  F.DIVISION_ID  = P_DIVISION_ID
 2593|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2594|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2595|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2596|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2597|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2598|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2599|             END IF;  -- R-5 END
 2600|         END;
 2601| 
 2602|         -----------------------------------------------------------------------
 2603|         -- Block R-6: RTF_RP_CAR/CELL/ENERGY + MKT_FCST_ENERGY
 2604|         --   소스: GT_GGET_MKT_FCST_RESULT (RTF/RTF_SYS_RP)
 2605|         --   [CSR ID:4023158] + [C20211103-000146] + [C20221207-000080]
 2606|         -----------------------------------------------------------------------
 2607|         DECLARE
 2608|             V_RTF_RESULT_CNT PLS_INTEGER := 0;
 2609|         BEGIN
 2610|             SELECT COUNT(1) INTO V_RTF_RESULT_CNT
 2611|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 2612|             WHERE  MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL',
 2613|                                'RTF_ENERGY','MKT_FCST_ENERGY');
 2614| 
 2615|             IF V_RTF_RESULT_CNT > 0 THEN
 2616|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 2617|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2618|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 2619|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 2620|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 2621|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 2622|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2623|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 2624|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2625|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2626|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2627|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2628|                      , CASE
 2629|                            WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
 2630|                                CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CAR'
 2631|                                     WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CAR'
 2632|                                     ELSE '' END
 2633|                            WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
 2634|                                CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CELL'
 2635|                                     WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CELL'
 2636|                                     ELSE '' END
 2637|                            WHEN M.MEASURE = 'RTF_ENERGY'      AND F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_ENERGY'
 2638|                            WHEN M.MEASURE = 'MKT_FCST_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN 'MKT_FCST_ENERGY'
 2639|                        END  AS MEASURE
 2640|                      , F.YYYYMMDD
 2641|                      , CASE
 2642|                            WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
 2643|                                CASE
 2644|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY / T2.CELL_PER_CAR
 2645|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0
 2646|                                     AND NVL(T2.CELL_PER_MODULE,0) > 0                                             THEN F.QTY / T2.MODULE_PER_CAR
 2647|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0                                    THEN F.QTY
 2648|                                    ELSE 0
 2649|                                END
 2650|                            WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
 2651|                                CASE
 2652|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
 2653|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
 2654|                                    WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
 2655|                                    ELSE 0
 2656|                                END
 2657|                            -- [C20211103-000146] RTF_ENERGY
 2658|                            WHEN M.MEASURE = 'RTF_ENERGY' THEN
 2659|                                CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
 2660|                                     THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
 2661|                                END
 2662|                            -- [C20221207-000080] MKT_FCST_ENERGY
 2663|                            WHEN M.MEASURE = 'MKT_FCST_ENERGY' THEN
 2664|                                CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
 2665|                                     THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
 2666|                                END
 2667|                        END  AS QTY
 2668|                      , M.MEASURE_GROUP
 2669|                      , T2.CELL_MODEL
 2670|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2671|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2672|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 2673|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2674|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2675|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2676|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2677|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2678|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2679|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2680|                      , T2.CELL_MODEL_NICK_NAME
 2681|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2682|                      , M.SORT_ORDER_NO
 2683|                      , T2.ENERGE, T2.CELL_QUANTITY
 2684|                      , F.ATTRIBUTE10  AS AS_FROM_SITE
 2685|                      , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2686|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2687|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2688|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2689|                            AND  INCOTERMS   = F.INCOTERMS
 2690|                            AND  MEASURE    IN ('RTF','RTF_SYS_RP') )
 2691|                      , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2692|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2693|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2694|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2695|                            AND  INCOTERMS   = F.INCOTERMS    AND MEASURE     IN ('RTF','RTF_SYS_RP')
 2696|                            AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2697|                                                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2698|                                                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2699|                                                   AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
 2700|                                                   AND  INCOTERMS   = F.INCOTERMS
 2701|                                                   AND  MEASURE    IN ('RTF','RTF_SYS_RP') ) )
 2702|                      , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2703|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2704|                      , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2705|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2706|                 FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2707|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2708|                   ON   F.MEASURE IN ('RTF','RTF_SYS_RP')
 2709|                  AND   M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL',
 2710|                                      'RTF_ENERGY','MKT_FCST_ENERGY')
 2711|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2712|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 2713|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2714|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2715|                  AND   F.ITEM_ID      = T2.ITEM_ID
 2716|                 WHERE  F.MEASURE = CASE
 2717|                                        WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_RP_CELL')                        THEN 'RTF'
 2718|                                        WHEN M.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL',
 2719|                                                           'RTF_ENERGY','MKT_FCST_ENERGY')                   THEN 'RTF_SYS_RP'
 2720|                                        ELSE M.MEASURE END
 2721|                   AND  F.QTY <> 0
 2722|                   AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2723|                   AND  F.YYYYMMDD     < V_TO_RESULT
 2724|                   AND  F.DIVISION_ID  = P_DIVISION_ID
 2725|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2726|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2727|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2728|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2729|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2730|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2731|             END IF;  -- R-6 END
 2732|         END;
 2733| 
 2734|         -----------------------------------------------------------------------
 2735|         -- Block R-7: MKT_FCST_RP
 2736|         --   소스: GT_GGET_MKT_FCST_RESULT (RTF → MKT_FCST_RP 표시)
 2737|         -----------------------------------------------------------------------
 2738|         DECLARE
 2739|             V_MFTRP_CNT PLS_INTEGER := 0;
 2740|         BEGIN
 2741|             SELECT COUNT(1) INTO V_MFTRP_CNT
 2742|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 2743|             WHERE  MEASURE = 'MKT_FCST_RP';
 2744| 
 2745|             IF V_MFTRP_CNT > 0 THEN
 2746|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 2747|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2748|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 2749|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 2750|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 2751|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 2752|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2753|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 2754|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2755|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2756|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2757|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2758|                      , 'MKT_FCST_RP'  AS MEASURE   -- RTF 실적 → MKT_FCST_RP 로 표시
 2759|                      , F.YYYYMMDD, F.QTY
 2760|                      , M.MEASURE_GROUP
 2761|                      , T2.CELL_MODEL
 2762|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2763|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2764|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 2765|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2766|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2767|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2768|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2769|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2770|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2771|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2772|                      , T2.CELL_MODEL_NICK_NAME
 2773|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2774|                      , M.SORT_ORDER_NO
 2775|                      , T2.ENERGE, T2.CELL_QUANTITY
 2776|                      , F.ATTRIBUTE10  AS AS_FROM_SITE
 2777|                      , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2778|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2779|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2780|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2781|                            AND  INCOTERMS   = F.INCOTERMS
 2782|                            AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END )
 2783|                      , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2784|                          WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2785|                            AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2786|                            AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
 2787|                            AND  INCOTERMS   = F.INCOTERMS    AND QTY         <> 0
 2788|                            AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END
 2789|                            AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
 2790|                                                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
 2791|                                                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
 2792|                                                   AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
 2793|                                                   AND  INCOTERMS   = F.INCOTERMS
 2794|                                                   AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END ) )
 2795|                      , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2796|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2797|                      , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2798|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2799|                 FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
 2800|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2801|                   ON   F.MEASURE  = 'RTF'         -- 실적은 RTF
 2802|                  AND   M.MEASURE  = 'MKT_FCST_RP' -- → MKT_FCST_RP 로 표시
 2803|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2804|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 2805|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2806|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2807|                  AND   F.ITEM_ID      = T2.ITEM_ID
 2808|                 WHERE  F.QTY <> 0
 2809|                   AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
 2810|                   AND  F.YYYYMMDD     < V_TO_RESULT
 2811|                   AND  F.DIVISION_ID  = P_DIVISION_ID
 2812|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2813|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2814|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2815|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2816|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2817|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2818|             END IF;  -- R-7 END
 2819|         END;
 2820| 
 2821|         -----------------------------------------------------------------------
 2822|         -- Block R-8: IN_TRANSIT
 2823|         --   소스: GT_GGET_INTRANSIT_DATA
 2824|         --   [E20241126-000426] SHIPMENT_PLAN 주석처리됨; IN_TRANSIT만 사용
 2825|         --   주의: YYYYMMDD 범위가 p_from_yyyymmdd ~ v_to_yyyymmdd (계획+실적 모두)
 2826|         -----------------------------------------------------------------------
 2827|         DECLARE
 2828|             V_IT_CNT PLS_INTEGER := 0;
 2829|         BEGIN
 2830|             SELECT COUNT(1) INTO V_IT_CNT
 2831|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 2832|             WHERE  MEASURE = 'IN_TRANSIT';
 2833| 
 2834|             IF V_IT_CNT > 0 THEN
 2835|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 2836|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
 2837|                 , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 2838|                 , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 2839|                 , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
 2840|                 , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
 2841|                 , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2842|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
 2843|                 , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2844|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2845|                 SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2846|                      , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
 2847|                      , F.MEASURE
 2848|                      , F.YYYYMMDD, F.QTY
 2849|                      , M.MEASURE_GROUP
 2850|                      , T2.CELL_MODEL
 2851|                      , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
 2852|                      , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
 2853|                      , T2.FORECAST_INFO_CELL_PACK_COUNT
 2854|                      , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
 2855|                      , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
 2856|                      , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
 2857|                      , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
 2858|                      , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
 2859|                      , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
 2860|                      , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
 2861|                      , T2.CELL_MODEL_NICK_NAME
 2862|                      , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
 2863|                      , M.SORT_ORDER_NO
 2864|                      , T2.ENERGE, T2.CELL_QUANTITY
 2865|                      , ''  AS AS_FROM_SITE
 2866|                      , ''  AS CREATE_DATE
 2867|                      , ''  AS LAST_UPDATED_BY
 2868|                      , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
 2869|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2870|                      , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
 2871|                          WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
 2872|                 FROM   SCM_MGR.GT_GGET_INTRANSIT_DATA F
 2873|                 JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
 2874|                   ON   F.MEASURE = 'IN_TRANSIT'
 2875|                  AND   F.MEASURE = M.MEASURE
 2876|                 JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
 2877|                   ON   F.DIVISION_ID  = T2.DIVISION_ID
 2878|                  AND   F.PROJECT_CODE = T2.PROJECT_CODE
 2879|                  AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
 2880|                  AND   F.ITEM_ID      = T2.ITEM_ID
 2881|                 WHERE  F.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND V_TO_YYYYMMDD
 2882|                   AND  F.DIVISION_ID  = P_DIVISION_ID
 2883|                   AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
 2884|                          IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2885|                              CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
 2886|                   AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
 2887|                          IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
 2888|                              CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
 2889|             END IF;  -- R-8 END
 2890|         END;
 2891| 
 2892|     END IF;  -- 실적 구간 조건 END (V_FROM_YYYYMMDD <= 당주 월요일)
 2893| 
 2894|     -----------------------------------------------------------------------
 2895|     -- Step 1: GT_GGET_MKT_FCST_DATA → GT_GGET_MKT_FCST_DST  집계
 2896|     --   [E20240712-001683] YYYYMMDD 포함 GROUP BY
 2897|     -----------------------------------------------------------------------
 2898|     INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DST
 2899|     ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 2900|     , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD
 2901|     , MEASURE_GROUP, FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
 2902|     , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
 2903|     , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
 2904|     , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
 2905|     , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
 2906|     , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2907|     , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
 2908|     , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
 2909|     , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2910|     , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2911|     SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2912|          , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE
 2913|          , F.YYYYMMDD
 2914|          , MAX(F.MEASURE_GROUP)             AS MEASURE_GROUP
 2915|          , MAX(F.CELL_MODEL)               AS FORECAST_INFO_CELL_MODEL
 2916|          , MAX(F.END_CUSTOMER)             AS END_CUSTOMER
 2917|          , MAX(F.NICK_NAME)               AS NICK_NAME
 2918|          , MAX(F.DMS_SALES)               AS DMS_SALES
 2919|          , MAX(F.DMS_CUSTOMER)            AS DMS_CUSTOMER
 2920|          , MAX(F.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
 2921|          , MAX(F.DEPT_ID)                 AS DEPT_ID
 2922|          , MAX(F.DEPT_NAME_KO)            AS DEPT_NAME_KO
 2923|          , MAX(F.ITEM_TYPE)               AS ITEM_TYPE
 2924|          , MAX(F.PROJECT_NAME)            AS PROJECT_NAME
 2925|          , MAX(F.PROJECT_OWNER)           AS PROJECT_OWNER
 2926|          , MAX(F.OWNER)                   AS OWNER
 2927|          , MAX(F.BIZ_TYPE)               AS BIZ_TYPE
 2928|          , MAX(F.SOLDTO_CUSTOMER)         AS SOLDTO_CUSTOMER
 2929|          , MAX(F.COUNTRY_NAME)            AS COUNTRY_NAME
 2930|          , MAX(F.CITY_NAME)              AS CITY_NAME
 2931|          , MAX(F.PROJECT_STATUS)          AS PROJECT_STATUS
 2932|          , MAX(F.ITEM_NAME)              AS ITEM_NAME
 2933|          , MAX(F.VMI_YN)                 AS VMI_YN
 2934|          , MAX(F.CUST_GROUP)             AS CUST_GROUP
 2935|          , MAX(F.CUST_GROUP_DTL)         AS CUST_GROUP_DTL
 2936|          , MAX(F.APPLICATION)            AS APPLICATION
 2937|          , MAX(F.ROUTE)                  AS ROUTE
 2938|          , MAX(F.MDM_PROJECT_NAME)       AS MDM_PROJECT_NAME
 2939|          , MAX(F.MIN_CAPACITY)           AS MIN_CAPACITY
 2940|          , MAX(F.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
 2941|          , MAX(F.CELL_TYPE)              AS CELL_TYPE
 2942|          , MAX(F.FORECAST_INFO_ALL)      AS FORECAST_INFO_ALL
 2943|          , MAX(F.FORECAST_INFO_SPEC)     AS FORECAST_INFO_SPEC
 2944|          , MAX(F.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
 2945|          , MAX(F.CELL_MODEL_NICK_NAME)   AS CELL_MODEL_NICK_NAME
 2946|          , MAX(F.CELL_PER_CAR)           AS CELL_PER_CAR
 2947|          , MAX(F.CELL_PER_MODULE)        AS CELL_PER_MODULE
 2948|          , MAX(F.MODULE_PER_CAR)         AS MODULE_PER_CAR
 2949|          , MAX(F.SORT_ORDER_NO)          AS SORT_ORDER_NO
 2950|          , MAX(F.ENERGE)                 AS ENERGE
 2951|          , MAX(F.CELL_QUANTITY)          AS CELL_QUANTITY
 2952|          , MAX(F.AS_FROM_SITE)           AS AS_FROM_SITE
 2953|          , MAX(F.CREATE_DATE)            AS CREATE_DATE
 2954|          , MAX(F.LAST_UPDATED_BY)        AS LAST_UPDATED_BY
 2955|          , MAX(F.SENDER_CODE)            AS SENDER_CODE
 2956|          , MAX(F.SENDER_NAME)            AS SENDER_NAME
 2957|     FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA F
 2958|     GROUP  BY F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
 2959|            ,  F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD;
 2960| 
 2961|     -----------------------------------------------------------------------
 2962|     -- Step 2: Division 82, MKT_FCST_RP 선택 + VMI 사이트 존재 시
 2963|     --         빠진 메저(RTF_SYS_RP, VMI_In_Plan/Req, VMI_Inv, MKT_FCST_RP) 행 보완
 2964|     --   [C20201103-000114]
 2965|     -----------------------------------------------------------------------
 2966|     DECLARE
 2967|         V_MKT_FCST_RP_VMI_CNT PLS_INTEGER := 0;
 2968|     BEGIN
 2969|         SELECT COUNT(1) INTO V_MKT_FCST_RP_VMI_CNT
 2970|         FROM   SCM_MGR.GT_GGET_SELECT_MEASURE A
 2971|         WHERE  A.MEASURE = 'MKT_FCST_RP'
 2972|           AND  P_DIVISION_ID = '82'
 2973|           AND  EXISTS (
 2974|                    SELECT 1
 2975|                    FROM   SCM_MGR.GT_GGET_MKT_FCST_DST D
 2976|                    JOIN   SCM_MGR.SCM_MST_SITE B
 2977|                      ON   D.DIVISION_ID = B.DIVISION_ID
 2978|                     AND   D.SCM_SITE_ID = B.SCM_SITE_ID
 2979|                     AND   B.VMI_YN      = 'Y'
 2980|                    WHERE  D.MEASURE     = 'MKT_FCST_RP'
 2981|                );
 2982| 
 2983|         IF V_MKT_FCST_RP_VMI_CNT > 0 THEN
 2984|             -- VMI 사이트 × 빠진 메저 조합 보완
 2985|             INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DST
 2986|             ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 2987|             , DOM_EXP, FCST_TYPE, INCOTERMS
 2988|             , MEASURE, MEASURE_GROUP
 2989|             , FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
 2990|             , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
 2991|             , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
 2992|             , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
 2993|             , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
 2994|             , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 2995|             , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
 2996|             , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
 2997|             , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 2998|             , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 2999|             SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
 3000|                  , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
 3001|                  , A.MEASURE, A.MEASURE_GROUP
 3002|                  , A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
 3003|                  , A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT
 3004|                  , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER
 3005|                  , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
 3006|                  , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
 3007|                  , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
 3008|                  , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
 3009|                  , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
 3010|                  , REPLACE(D.SORT_ORDER_NO, '.0', A.SORTKEY)  AS SORT_ORDER_NO
 3011|                  , A.ENERGE, A.CELL_QUANTITY
 3012|                  , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
 3013|             FROM (
 3014|                 -- VMI 사이트 기반 DISTINCT 헤더
 3015|                 SELECT B2.MEASURE    AS MEASURE
 3016|                      , B2.MEASURE_GROUP
 3017|                      , B2.SORTKEY
 3018|                      , A2.*
 3019|                 FROM (
 3020|                     SELECT DISTINCT
 3021|                            A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
 3022|                          , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
 3023|                          , A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
 3024|                          , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
 3025|                          , A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
 3026|                          , A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
 3027|                          , A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
 3028|                          , A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
 3029|                          , A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
 3030|                          , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
 3031|                          , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
 3032|                          , A2.ENERGE, A2.CELL_QUANTITY
 3033|                          , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
 3034|                     FROM   SCM_MGR.GT_GGET_MKT_FCST_DST A2
 3035|                     JOIN   SCM_MGR.SCM_MST_SITE S
 3036|                       ON   A2.DIVISION_ID = S.DIVISION_ID
 3037|                      AND   A2.SCM_SITE_ID = S.SCM_SITE_ID
 3038|                      AND   S.VMI_YN       = 'Y'
 3039|                 ) A2,
 3040|                 (
 3041|                     SELECT 'MKT_FCST_RP' AS MEASURE_GROUP, 'MKT_FCST_RP' AS MEASURE, '.9' AS SORTKEY FROM DUAL UNION ALL
 3042|                     SELECT 'RTF_SYS_RP'  AS MEASURE_GROUP, 'RTF_SYS_RP'  AS MEASURE, '.1' FROM DUAL UNION ALL
 3043|                     SELECT 'VMI_In_Plan' AS MEASURE_GROUP, 'VMI_In_Plan' AS MEASURE, '.2' FROM DUAL UNION ALL
 3044|                     SELECT 'VMI_In_Req'  AS MEASURE_GROUP, 'VMI_In_Req'  AS MEASURE, '.3' FROM DUAL UNION ALL
 3045|                     SELECT 'VMI_Inv'     AS MEASURE_GROUP, 'VMI_Inv'     AS MEASURE, '.4' FROM DUAL
 3046|                 ) B2
 3047|             ) A
 3048|             -- 이미 GT_GGET_MKT_FCST_DST에 존재하는 조합은 제외
 3049|             LEFT OUTER JOIN SCM_MGR.GT_GGET_MKT_FCST_DST C
 3050|               ON  A.DIVISION_ID    = C.DIVISION_ID
 3051|              AND  A.PROJECT_CODE   = C.PROJECT_CODE
 3052|              AND  A.SCM_SITE_ID    = C.SCM_SITE_ID
 3053|              AND  A.PLANT_SITE_ID  = C.PLANT_SITE_ID
 3054|              AND  A.ITEM_ID        = C.ITEM_ID
 3055|              AND  A.DOM_EXP        = C.DOM_EXP
 3056|              AND  A.FCST_TYPE      = C.FCST_TYPE
 3057|              AND  A.INCOTERMS      = C.INCOTERMS
 3058|              AND  A.MEASURE        = C.MEASURE
 3059|              AND  A.MEASURE_GROUP  = C.MEASURE_GROUP
 3060|             LEFT OUTER JOIN SCM_MGR.GT_GGET_SELECT_MEASURE D
 3061|               ON  A.MEASURE = D.MEASURE AND A.MEASURE_GROUP = D.MEASURE_GROUP
 3062|             WHERE C.MEASURE IS NULL
 3063|             ORDER BY A.INCOTERMS, A.MEASURE;
 3064|         END IF;
 3065|     END;
 3066| 
 3067|     -----------------------------------------------------------------------
 3068|     -- Step 3: Division 82 + P_INVALID_EXEC='N'
 3069|     --         → GT_GGET_SALES_PRICE 수집 (mapping 미등록 Sales Price 제공)
 3070|     --   [C20200612-000174]
 3071|     -----------------------------------------------------------------------
 3072|     IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' THEN
 3073| 
 3074|         -- LOC measure → MKT_FCST_RP, BNPIn(상품/전극) 행 수집
 3075|         INSERT INTO SCM_MGR.GT_GGET_SALES_PRICE
 3076|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 3077|         , DOM_EXP, FCST_TYPE, INCOTERMS
 3078|         , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY, COUNTRY_NAME, CITY, CITY_NAME
 3079|         , OWNER, PROJECT_OWNER, USER_ID, ITEM_NAME, ITEM_TYPE
 3080|         , PROJECT_STATUS, NICK_NAME, DEPT_ID, DEPT_NAME_KO, VMI_YN
 3081|         , PROJECT_NAME, END_CUSTOMER, ENERGE, CELL_QUANTITY
 3082|         , MEASURE, MEASURE_GROUP, SORT_ORDER_NO )
 3083|         SELECT DISTINCT
 3084|                A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
 3085|              , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
 3086|              , B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY, B.COUNTRY_NAME, B.CITY, B.CITY_NAME
 3087|              , B.OWNER, B.PROJECT_OWNER, B.USER_ID, B.ITEM_NAME, B.ITEM_TYPE
 3088|              , B.PROJECT_STATUS, B.NICK_NAME, B.DEPT_ID, B.DEPT_NAME_KO, B.VMI_YN
 3089|              , B.PROJECT_NAME, B.END_CUSTOMER, B.ENERGE, B.CELL_QUANTITY
 3090|              , 'MKT_FCST_RP'  AS MEASURE
 3091|              , 'MKT_FCST_RP'  AS MEASURE_GROUP
 3092|              , CASE WHEN NVL(B.VMI_YN,'N') <> 'Y' THEN '00.0' ELSE '.9' END  AS SORT_ORDER_NO
 3093|         FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
 3094|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM B
 3095|           ON   A.DIVISION_ID  = B.DIVISION_ID
 3096|          AND   A.PROJECT_CODE = B.PROJECT_CODE
 3097|          AND   A.SCM_SITE_ID  = B.SCM_SITE_ID
 3098|          AND   A.ITEM_ID      = B.ITEM_ID
 3099|          AND   ( A.FCST_TYPE IS NOT NULL OR A.FCST_TYPE   <> '' )
 3100|         WHERE  A.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
 3101|           AND  A.MEASURE     = 'LOC'
 3102|           AND  A.FCST_TYPE  <> 'ETC'    -- [C20200702-000136] ETC 제외
 3103| 
 3104|         UNION ALL
 3105| 
 3106|         SELECT DISTINCT
 3107|                A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
 3108|              , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
 3109|              , B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY, B.COUNTRY_NAME, B.CITY, B.CITY_NAME
 3110|              , B.OWNER, B.PROJECT_OWNER, B.USER_ID, B.ITEM_NAME, B.ITEM_TYPE
 3111|              , B.PROJECT_STATUS, B.NICK_NAME, B.DEPT_ID, B.DEPT_NAME_KO, B.VMI_YN
 3112|              , B.PROJECT_NAME, B.END_CUSTOMER, B.ENERGE, B.CELL_QUANTITY
 3113|              , 'BNPIn'  AS MEASURE
 3114|              , 'BNPIn'  AS MEASURE_GROUP
 3115|              , '00.0'   AS SORT_ORDER_NO
 3116|         FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
 3117|         JOIN   SCM_MGR.GT_GGET_SITE_ITEM B
 3118|           ON   A.DIVISION_ID  = B.DIVISION_ID
 3119|          AND   A.PROJECT_CODE = B.PROJECT_CODE
 3120|          AND   A.SCM_SITE_ID  = B.SCM_SITE_ID
 3121|          AND   A.ITEM_ID      = B.ITEM_ID
 3122|          AND   ( A.FCST_TYPE IS NOT NULL OR A.FCST_TYPE   <> '' )
 3123|          AND   B.ITEM_TYPE   IN ('Q','R')  -- 상품/전극만
 3124|         WHERE  A.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
 3125|           AND  A.MEASURE     = 'LOC'
 3126|           AND  A.FCST_TYPE  <> 'ETC';
 3127| 
 3128|         -- SORT_ORDER_NO: GT_GGET_SELECT_MEASURE 기준으로 업데이트
 3129|         UPDATE SCM_MGR.GT_GGET_SALES_PRICE A
 3130|         SET    A.SORT_ORDER_NO = (
 3131|                    SELECT B.SORT_ORDER_NO
 3132|                    FROM   SCM_MGR.GT_GGET_SELECT_MEASURE B
 3133|                    WHERE  A.MEASURE       = B.MEASURE
 3134|                      AND  A.MEASURE_GROUP = B.MEASURE_GROUP
 3135|                      AND  ROWNUM          = 1 );
 3136| 
 3137|         -- VMI/RTF/MKT_FCST_RP 계열 SORT_ORDER_NO 소수점 자리 조정
 3138|         UPDATE SCM_MGR.GT_GGET_SALES_PRICE
 3139|         SET    SORT_ORDER_NO =
 3140|                CASE WHEN MEASURE = 'RTF_SYS_RP'  THEN REPLACE(SORT_ORDER_NO, '.0', '.1')
 3141|                     WHEN MEASURE = 'VMI_In_Plan'  THEN REPLACE(SORT_ORDER_NO, '.0', '.2')
 3142|                     WHEN MEASURE = 'VMI_In_Req'   THEN REPLACE(SORT_ORDER_NO, '.0', '.3')
 3143|                     WHEN MEASURE = 'VMI_Inv'      THEN REPLACE(SORT_ORDER_NO, '.0', '.4')
 3144|                     WHEN MEASURE = 'MKT_FCST_RP'  THEN REPLACE(SORT_ORDER_NO, '.0', '.9')
 3145|                END
 3146|         WHERE  MEASURE IN ('MKT_FCST_RP','RTF_SYS_RP','VMI_In_Plan','VMI_In_Req','VMI_Inv');
 3147| 
 3148|     END IF;
 3149| 
 3150|     -----------------------------------------------------------------------
 3151|     -- Step 4: LP_AS_YN='Y' → AS_IN_REQ/PLAN/INV 빈 행 GT_GGET_MKT_FCST_DST에 추가
 3152|     --   조건: AS_SITE_PLANT LOOKUP에 있는 SCM_SITE_ID인 데이터 중
 3153|     --         아직 GT_GGET_MKT_FCST_DATA에 AS 메저가 없는 조합 삽입
 3154|     -----------------------------------------------------------------------
 3155|     IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' AND LP_AS_YN = 'Y' THEN
 3156|         DECLARE
 3157|             V_AS_MEA_CNT PLS_INTEGER := 0;
 3158|         BEGIN
 3159|             SELECT COUNT(1) INTO V_AS_MEA_CNT
 3160|             FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 3161|             WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV');
 3162| 
 3163|             IF V_AS_MEA_CNT > 0 THEN
 3164|                 INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DST
 3165|                 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 3166|                 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, MEASURE_GROUP
 3167|                 , FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
 3168|                 , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
 3169|                 , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
 3170|                 , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
 3171|                 , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
 3172|                 , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 3173|                 , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
 3174|                 , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
 3175|                 , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 3176|                 , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 3177|                 SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
 3178|                      , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
 3179|                      , C.MEASURE, C.MEASURE_GROUP
 3180|                      , A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
 3181|                      , A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT
 3182|                      , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER
 3183|                      , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
 3184|                      , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
 3185|                      , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
 3186|                      , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
 3187|                      , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
 3188|                      , C.SORT_ORDER_NO
 3189|                      , A.ENERGE, A.CELL_QUANTITY
 3190|                      , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
 3191|                 FROM (
 3192|                     -- AS_SITE_PLANT LOOKUP에 있는 SCM_SITE_ID 기반 DST 헤더 (중복 제거)
 3193|                     SELECT A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
 3194|                          , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS, A2.MEASURE, A2.MEASURE_GROUP
 3195|                          , A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
 3196|                          , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
 3197|                          , A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
 3198|                          , A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
 3199|                          , A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
 3200|                          , A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
 3201|                          , A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
 3202|                          , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
 3203|                          , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
 3204|                          , A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
 3205|                          , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
 3206|                     FROM   SCM_MGR.GT_GGET_MKT_FCST_DST A2
 3207|                     JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B2
 3208|                       ON   A2.SCM_SITE_ID = B2.SEGMENT1
 3209|                      AND   B2.LOOKUP_TYPE = 'AS_SITE_PLANT'
 3210|                      AND   B2.SEGMENT3    = P_DIVISION_ID
 3211|                     GROUP  BY A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
 3212|                            ,  A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS, A2.MEASURE, A2.MEASURE_GROUP
 3213|                            ,  A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
 3214|                            ,  A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
 3215|                            ,  A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
 3216|                            ,  A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
 3217|                            ,  A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
 3218|                            ,  A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
 3219|                            ,  A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
 3220|                            ,  A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
 3221|                            ,  A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
 3222|                            ,  A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
 3223|                            ,  A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
 3224|                 ) A
 3225|                 -- AS_IN_REQ/PLAN/INV 메저 목록 (CROSS JOIN)
 3226|                 JOIN (
 3227|                     SELECT MEASURE, MEASURE_GROUP, SORT_ORDER_NO
 3228|                     FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 3229|                     WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV')
 3230|                 ) C ON 1=1
 3231|                 -- 이미 GT_GGET_MKT_FCST_DATA에 AS 메저가 있는 조합은 제외
 3232|                 LEFT OUTER JOIN (
 3233|                     SELECT DISTINCT
 3234|                            D2.DIVISION_ID, D2.PROJECT_CODE, D2.SCM_SITE_ID, D2.ITEM_ID
 3235|                          , D2.DOM_EXP, D2.FCST_TYPE, D2.INCOTERMS, D2.MEASURE, D2.PLANT_SITE_ID
 3236|                     FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA D2
 3237|                     JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B3
 3238|                       ON   D2.SCM_SITE_ID = B3.SEGMENT1
 3239|                      AND   B3.LOOKUP_TYPE = 'AS_SITE_PLANT'
 3240|                      AND   B3.SEGMENT3    = P_DIVISION_ID
 3241|                 ) D ON  A.DIVISION_ID   = D.DIVISION_ID
 3242|                     AND A.PROJECT_CODE  = D.PROJECT_CODE
 3243|                     AND A.SCM_SITE_ID   = D.SCM_SITE_ID
 3244|                     AND A.ITEM_ID       = D.ITEM_ID
 3245|                     AND A.DOM_EXP       = D.DOM_EXP
 3246|                     AND A.FCST_TYPE     = D.FCST_TYPE
 3247|                     AND A.INCOTERMS     = D.INCOTERMS
 3248|                     AND C.MEASURE       = D.MEASURE
 3249|                     AND A.PLANT_SITE_ID = D.PLANT_SITE_ID
 3250|                 WHERE D.DIVISION_ID IS NULL;
 3251|             END IF;
 3252|         END;
 3253|    END IF;
 3254| 
 3255|     -----------------------------------------------------------------------
 3256|     -- Step 5: Division 82 VMI 재고계산  [E20240102-000545]
 3257|     --   5-1) GT_GGET_VMI_INV: RANK=1(최신 일자) 행 추출
 3258|     --   5-2) DELETE: VMI_INV 일자 이후에 MKT_FCST/VMI_In_Plan/VMI_In_Req 있는 경우 제거
 3259|     --   5-3) DELETE: MKT_FCST/VMI_In_Plan/VMI_In_Req 행 삭제 (VMI_INV만 남김)
 3260|     --   5-4) GT_GGET_VMI_INV_RESULT: GT_GGET_MKT_FCST_DATA와 JOIN → 헤더 정보 붙임
 3261|     --   5-5) PERIOD 기간만큼 GT_GGET_VMI_INV_RESULT 확장
 3262|     --   5-6) 원본 VMI_INV 날짜 행 삭제 (모수 제거)
 3263|     --   5-7) GT_GGET_MKT_FCST_DATA에 최종 INSERT
 3264|     -----------------------------------------------------------------------
 3265|     IF P_DIVISION_ID = '82' THEN
 3266| 
 3267|         -- 5-1) 최신 날짜 VMI 관련 데이터 추출 (RANK=1)
 3268|         DELETE FROM SCM_MGR.GT_GGET_VMI_INV;
 3269|         DELETE FROM SCM_MGR.GT_GGET_VMI_INV_RESULT;
 3270| 
 3271|         INSERT INTO SCM_MGR.GT_GGET_VMI_INV
 3272|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3273|         , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY )
 3274|         SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3275|              , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
 3276|         FROM (
 3277|             SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3278|                  , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
 3279|                  , RANK() OVER (
 3280|                        PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
 3281|                                     DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE
 3282|                        ORDER BY YYYYMMDD DESC
 3283|                    ) AS SEQ
 3284|             FROM (
 3285|                 -- 계획 테이블
 3286|                 SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3287|                      , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
 3288|                 FROM   SCM_MGR.DM_PLN_MKT_FCST
 3289|                 WHERE  DIVISION_ID = P_DIVISION_ID
 3290|                   AND  MEASURE    IN ('VMI_INV','MKT_FCST','VMI_In_Plan','VMI_In_Req')
 3291|                   AND  QTY        <> 0
 3292|                   AND  YYYYMMDD  BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
 3293|                 UNION ALL
 3294|                 -- 실적 테이블 (RESULT): 당주 월요일 이전까지
 3295|                 SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3296|                      , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
 3297|                      , SUM(QTY) AS QTY   -- [PJ2025-50188] CELL_PROD_SITE_ID 제거 후 집계
 3298|                 FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT
 3299|                 WHERE  DIVISION_ID = P_DIVISION_ID
 3300|                   AND  MEASURE    IN ('VMI_INV','MKT_FCST','VMI_In_Plan','VMI_In_Req')
 3301|                   AND  QTY        <> 0
 3302|                   AND  YYYYMMDD  >= P_FROM_YYYYMMDD
 3303|                   AND  YYYYMMDD   < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
 3304|                 GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3305|                        ,  DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
 3306|             ) A
 3307|         ) B
 3308|         WHERE SEQ = 1;
 3309| 
 3310|         -- 5-2) VMI_INV 일자 이후에 MKT_FCST 계열이 있는 경우 → VMI_INV 행 제거
 3311|         DELETE FROM SCM_MGR.GT_GGET_VMI_INV C
 3312|         WHERE EXISTS (
 3313|             SELECT 1
 3314|             FROM (
 3315|                 SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
 3316|                      , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
 3317|                 FROM   SCM_MGR.GT_GGET_VMI_INV A    -- VMI_INV
 3318|                 JOIN   SCM_MGR.GT_GGET_VMI_INV B    -- MKT_FCST 계열
 3319|                   ON   A.DIVISION_ID   = B.DIVISION_ID
 3320|                  AND   A.PROJECT_CODE  = B.PROJECT_CODE
 3321|                  AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
 3322|                  AND   A.ITEM_ID       = B.ITEM_ID
 3323|                  AND   A.DOM_EXP       = B.DOM_EXP
 3324|                  AND   A.FCST_TYPE     = B.FCST_TYPE
 3325|                  AND   A.INCOTERMS     = B.INCOTERMS
 3326|                  AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
 3327|                  AND   A.MEASURE       = 'VMI_INV'
 3328|                  AND   B.MEASURE      IN ('MKT_FCST','VMI_In_Plan','VMI_In_Req')
 3329|                  AND   B.YYYYMMDD     >= A.YYYYMMDD + 1
 3330|             ) T
 3331|             WHERE C.DIVISION_ID   = T.DIVISION_ID
 3332|               AND C.PROJECT_CODE  = T.PROJECT_CODE
 3333|               AND C.SCM_SITE_ID   = T.SCM_SITE_ID
 3334|               AND C.ITEM_ID       = T.ITEM_ID
 3335|               AND C.DOM_EXP       = T.DOM_EXP
 3336|               AND C.FCST_TYPE     = T.FCST_TYPE
 3337|               AND C.INCOTERMS     = T.INCOTERMS
 3338|               AND C.PLANT_SITE_ID = T.PLANT_SITE_ID
 3339|         );
 3340| 
 3341|         -- 5-3) MKT_FCST/VMI_In_Plan/VMI_In_Req 행 삭제 → VMI_INV만 남김
 3342|         DELETE FROM SCM_MGR.GT_GGET_VMI_INV
 3343|         WHERE  MEASURE IN ('MKT_FCST','VMI_In_Plan','VMI_In_Req');
 3344| 
 3345|         -- 5-4) GT_GGET_MKT_FCST_DATA와 JOIN하여 헤더 정보 포함 → GT_GGET_VMI_INV_RESULT
 3346|         INSERT INTO SCM_MGR.GT_GGET_VMI_INV_RESULT
 3347|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3348|         , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
 3349|         , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
 3350|         , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 3351|         , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
 3352|         , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
 3353|         , CUST_GROUP, CUST_GROUP_DTL, MDM_PROJECT_NAME, MIN_CAPACITY
 3354|         , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
 3355|         , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
 3356|         , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 3357|         , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 3358|         SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
 3359|              , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD, A.PLANT_SITE_ID, A.QTY
 3360|              , B.MEASURE_GROUP, B.CELL_MODEL, B.END_CUSTOMER, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER
 3361|              , B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT
 3362|              , B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER
 3363|              , B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN
 3364|              , B.CUST_GROUP, B.CUST_GROUP_DTL, B.MDM_PROJECT_NAME, B.MIN_CAPACITY
 3365|              , B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC
 3366|              , B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE
 3367|              , B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY
 3368|              , B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME
 3369|         FROM   SCM_MGR.GT_GGET_VMI_INV A
 3370|         JOIN   SCM_MGR.GT_GGET_MKT_FCST_DATA B
 3371|           ON   A.DIVISION_ID   = B.DIVISION_ID
 3372|          AND   A.PROJECT_CODE  = B.PROJECT_CODE
 3373|          AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
 3374|          AND   A.ITEM_ID       = B.ITEM_ID
 3375|          AND   A.DOM_EXP       = B.DOM_EXP
 3376|          AND   A.FCST_TYPE     = B.FCST_TYPE
 3377|          AND   A.INCOTERMS     = B.INCOTERMS
 3378|          AND   A.MEASURE       = B.MEASURE
 3379|          AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
 3380|          AND   A.YYYYMMDD      = B.YYYYMMDD;
 3381| 
 3382|         -- 5-5) PERIOD 기간만큼 GT_GGET_VMI_INV_RESULT 행 확장
 3383|         --       (원본 날짜 이후의 모든 날짜에 동일 QTY 행 생성)
 3384|         INSERT INTO SCM_MGR.GT_GGET_VMI_INV_RESULT
 3385|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3386|         , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
 3387|         , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
 3388|         , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 3389|         , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
 3390|         , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
 3391|         , CUST_GROUP, CUST_GROUP_DTL, MDM_PROJECT_NAME, MIN_CAPACITY
 3392|         , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
 3393|         , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
 3394|         , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 3395|         , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 3396|         SELECT DISTINCT
 3397|                B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID
 3398|              , B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE
 3399|              , A.BASIS_YYYYMMDD  AS YYYYMMDD   -- 캘린더 날짜로 확장
 3400|              , B.PLANT_SITE_ID, B.QTY
 3401|              , B.MEASURE_GROUP, B.CELL_MODEL, B.END_CUSTOMER, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER
 3402|              , B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT
 3403|              , B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER
 3404|              , B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN
 3405|              , B.CUST_GROUP, B.CUST_GROUP_DTL, B.MDM_PROJECT_NAME, B.MIN_CAPACITY
 3406|              , B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC
 3407|              , B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE
 3408|              , B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY
 3409|              , B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME
 3410|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
 3411|         LEFT   OUTER JOIN SCM_MGR.GT_GGET_VMI_INV_RESULT B
 3412|           ON   A.BASIS_YYYYMMDD > B.YYYYMMDD   -- 원본 날짜 이후 모든 날짜
 3413|         WHERE  A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
 3414|           AND  A.BASIS_YYYYMMDD > B.YYYYMMDD;
 3415| 
 3416|         -- 5-6) 원본 VMI_INV 날짜 행 삭제 (모수 제거)
 3417|         DELETE FROM SCM_MGR.GT_GGET_VMI_INV_RESULT A
 3418|         WHERE  DIVISION_ID = '82'
 3419|           AND  MEASURE     = 'VMI_INV'
 3420|           AND  EXISTS (
 3421|                    SELECT 1
 3422|                    FROM   SCM_MGR.GT_GGET_VMI_INV Z
 3423|                    WHERE  A.DIVISION_ID   = Z.DIVISION_ID
 3424|                      AND  A.PROJECT_CODE  = Z.PROJECT_CODE
 3425|                      AND  A.SCM_SITE_ID   = Z.SCM_SITE_ID
 3426|                      AND  A.ITEM_ID       = Z.ITEM_ID
 3427|                      AND  A.DOM_EXP       = Z.DOM_EXP
 3428|                      AND  A.FCST_TYPE     = Z.FCST_TYPE
 3429|                      AND  A.INCOTERMS     = Z.INCOTERMS
 3430|                      AND  A.PLANT_SITE_ID = Z.PLANT_SITE_ID
 3431|                      AND  A.YYYYMMDD      = Z.YYYYMMDD
 3432|                );
 3433| 
 3434|         -- 5-7) GT_GGET_MKT_FCST_DATA에 VMI_INV 보완 행 INSERT
 3435|         INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 3436|         ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 3437|         , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
 3438|         , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
 3439|         , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 3440|         , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
 3441|         , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
 3442|         , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
 3443|         , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 3444|         , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
 3445|         , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
 3446|         , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 3447|         , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 3448|         SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 3449|              , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
 3450|              , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
 3451|              , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
 3452|              , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
 3453|              , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
 3454|              , CUST_GROUP, CUST_GROUP_DTL
 3455|              , NULL  AS APPLICATION   -- GT_GGET_VMI_INV_RESULT에 APPLICATION/ROUTE 없음
 3456|              , NULL  AS ROUTE
 3457|              , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 3458|              , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
 3459|              , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
 3460|              , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 3461|              , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
 3462|         FROM   SCM_MGR.GT_GGET_VMI_INV_RESULT;
 3463| 
 3464|     END IF;  -- Division 82 VMI 재고계산 END
 3465| 
 3466|     -----------------------------------------------------------------------
 3467|     -- Step 6: NOTATION 컬럼 업데이트  [E20240812-000094]
 3468|     --   DM_MEASURE_POSITIONAL_NOTATION LOOKUP → MEASURE별 소수점 표기형태 설정
 3469|     -----------------------------------------------------------------------
 3470|     UPDATE SCM_MGR.GT_GGET_MKT_FCST_DATA A
 3471|     SET    A.NOTATION = NVL(
 3472|                ( SELECT C.SEGMENT3
 3473|                  FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
 3474|                  WHERE  C.LOOKUP_TYPE = 'DM_MEASURE_POSITIONAL_NOTATION'
 3475|                    AND  A.MEASURE     = C.SEGMENT2
 3476|                    AND  A.DIVISION_ID = C.SEGMENT1
 3477|                    AND  ROWNUM        = 1 ),
 3478|                'DEFAULT' );
 3479| 
 3480|     -----------------------------------------------------------------------
 3481|     -- 팀 WHERE 조건 생성 (FN_SCM_GET_WHERE_SQL → 인라인 변환)
 3482|     -----------------------------------------------------------------------
 3483|     IF P_TEAM_ID = 'ALL' THEN
 3484|         V_TEAM_WHERE := '1=1';
 3485|     ELSE
 3486|         -- P_TEAM_ID 가 콤마 구분 목록일 경우 IN 절 생성
 3487|         V_TEAM_WHERE := 'A.DEPT_ID IN ('''
 3488|                      || REPLACE(P_TEAM_ID, ',', ''',''')
 3489|                      || ''')';
 3490|     END IF;
 3491| 
 3492|     -----------------------------------------------------------------------
 3493|     -- 분기: Division 82 + P_INVALID_EXEC='N'  → PIVOT SQL #1 (AS용)
 3494|     --        그 외                             → AS_IN_REQ 보완 + PIVOT SQL #2
 3495|     -----------------------------------------------------------------------
 3496|     IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' THEN
 3497| 
 3498|         -- -----------------------------------------------------------------------
 3499|         -- PIVOT SQL #1 (AS용)
 3500|         --   소스: GT_GGET_SALES_PRICE  FULL OUTER JOIN  GT_GGET_MKT_FCST_DST
 3501|         --         → GT_GGET_MF (임시 조인 결과)
 3502|         --         → PIVOT + EXECUTE IMMEDIATE → O_RC
 3503|         -- -----------------------------------------------------------------------
 3504|         V_SQL_TEXT :=
 3505|         'WITH MF_BASE AS (' || CHR(10) ||
 3506|         'SELECT' || CHR(10) ||
 3507|         '      A.DIVISION_ID' || CHR(10) ||
 3508|         '    , A.DIVISION_ID                                         AS DIVISION_ID40' || CHR(10) ||
 3509|         '    , CASE WHEN ''' || LP_AS_YN || ''' = ''Y'' THEN NVL(X.DISPLAY_SEQ,999) ELSE 999 END AS SORT_KEY' || CHR(10) ||
 3510|         '    , A.SCM_SITE_ID' || CHR(10) ||
 3511|         '    , A.SCM_SITE_ID                                         AS SCM_SITE_ID40' || CHR(10) ||
 3512|         '    , A.PLANT_SITE_ID' || CHR(10) ||
 3513|         '    , A.PROJECT_CODE' || CHR(10) ||
 3514|         '    , NVL(I.GROUP_ID,'''')                                  AS GROUP_ID' || CHR(10) ||
 3515|         '    , A.ITEM_ID' || CHR(10) ||
 3516|         '    , A.ITEM_ID                                             AS ITEM_ID40' || CHR(10) ||
 3517|         '    , A.INCOTERMS' || CHR(10) ||
 3518|         '    , A.FCST_TYPE' || CHR(10) ||
 3519|         '    , A.DOM_EXP' || CHR(10) ||
 3520|         '    , A.MEASURE' || CHR(10) ||
 3521|         '    , A.END_CUSTOMER' || CHR(10) ||
 3522|         '    , CASE WHEN (A.DIVISION_ID LIKE ''81%'' OR A.DIVISION_ID = ''82'')' || CHR(10) ||
 3523|         '           THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END      AS END_CUSTOMER40' || CHR(10) ||
 3524|         '    , A.NICK_NAME' || CHR(10) ||
 3525|         '    , A.DMS_SALES' || CHR(10) ||
 3526|         '    , A.DMS_CUSTOMER' || CHR(10) ||
 3527|         '    , C.BASIS_YYYYMM                                        AS YYYYMM' || CHR(10) ||
 3528|         '    , C.BASIS_YYYYMM || C.ISO_WEEK                          AS YYYYMMWW' || CHR(10) ||
 3529|         '    , C.BASIS_YYYYMMDD                                      AS YYYYMMDD' || CHR(10) ||
 3530|         '    , C.DAYOFWEEK' || CHR(10) ||
 3531|         '    , A.FORECAST_INFO_CELL_MODEL' || CHR(10) ||
 3532|         '    , A.DEPT_ID                                             AS TEAM_ID' || CHR(10) ||
 3533|         '    , A.DEPT_NAME_KO                                        AS TEAM_NAME_KO' || CHR(10) ||
 3534|         '    , A.ITEM_TYPE' || CHR(10) ||
 3535|         '    , A.PROJECT_NAME' || CHR(10) ||
 3536|         '    , A.PROJECT_OWNER' || CHR(10) ||
 3537|         '    , A.OWNER' || CHR(10) ||
 3538|         '    , A.BIZ_TYPE' || CHR(10) ||
 3539|         '    , A.SOLDTO_CUSTOMER' || CHR(10) ||
 3540|         '    , A.COUNTRY_NAME' || CHR(10) ||
 3541|         '    , A.CITY_NAME' || CHR(10) ||
 3542|         '    , A.PROJECT_STATUS' || CHR(10) ||
 3543|         '    , A.ITEM_NAME' || CHR(10) ||
 3544|         '    , A.VMI_YN' || CHR(10) ||
 3545|         '    , A.CUST_GROUP' || CHR(10) ||
 3546|         '    , A.CUST_GROUP_DTL' || CHR(10) ||
 3547|         '    , A.APPLICATION' || CHR(10) ||
 3548|         '    , A.ROUTE' || CHR(10) ||
 3549|         '    , A.MDM_PROJECT_NAME' || CHR(10) ||
 3550|         '    , A.MIN_CAPACITY' || CHR(10) ||
 3551|         '    , A.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
 3552|         '    , A.CELL_TYPE' || CHR(10) ||
 3553|         '    , A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
 3554|         '    , A.FORECAST_INFO_ALL' || CHR(10) ||
 3555|         '    , A.FORECAST_INFO_SPEC' || CHR(10) ||
 3556|         '    , A.FORECAST_INFOR_VERSION' || CHR(10) ||
 3557|         '    , A.CELL_MODEL_NICK_NAME' || CHR(10) ||
 3558|         '    , CAST(CASE WHEN ''Y'' = ''[@CellQtyYN]''' || CHR(10) ||
 3559|         '                 AND A.MEASURE_GROUP NOT IN (''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'')' || CHR(10) ||
 3560|         '                 AND NVL(A.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1' || CHR(10) ||
 3561|         '                THEN D.QTY * A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
 3562|         '                ELSE D.QTY END AS NUMBER(10)) AS QTY' || CHR(10) ||
 3563|         '    , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS MONTH_END_YN' || CHR(10) ||
 3564|         '    , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN ''Y'' ELSE ''N'' END AS WEEK_END_YN' || CHR(10) ||
 3565|         '    , CASE' || CHR(10) ||
 3566|         '          WHEN MA.DEPT_ID IS NOT NULL' || CHR(10) ||
 3567|         '               AND A.MEASURE_GROUP NOT IN (''CUST_FCST_2'',''CUST_FCST_3'',''TMM_FCST'')' || CHR(10) ||
 3568|         '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
 3569|         '          WHEN ''[@v_group_id]'' = ''ADMIN''' || CHR(10) ||
 3570|         '               AND A.MEASURE_GROUP <> ''TMM_FCST''' || CHR(10) ||
 3571|         '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
 3572|         '          WHEN A.MEASURE_GROUP = ''TMM_FCST''' || CHR(10) ||
 3573|         '               AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
 3574|         '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
 3575|         '          ELSE ''N''' || CHR(10) ||
 3576|         '      END AS EDIT_FLAG' || CHR(10) ||
 3577|         '    , A.CELL_PER_CAR' || CHR(10) ||
 3578|         '    , A.CELL_PER_MODULE' || CHR(10) ||
 3579|         '    , A.MODULE_PER_CAR' || CHR(10) ||
 3580|         '    , A.SORT_ORDER_NO' || CHR(10) ||
 3581|         '    , A.MEASURE_GROUP' || CHR(10) ||
 3582|         '    , A.ENERGE' || CHR(10) ||
 3583|         '    , A.CELL_QUANTITY' || CHR(10) ||
 3584|         '    , A.NEW_FLAG' || CHR(10) ||
 3585|         '    , NVL(VM.VMI_VAL,'''')                                  AS VMI_STD_DIO' || CHR(10) ||
 3586|         '    , NVL(B1.ATTR1, B2.ATTR1)                              AS ATTR1' || CHR(10) ||
 3587|         '    , NVL(BK.BUCKET,''0000000'')                           AS BUCKET' || CHR(10) ||
 3588|         '    , A.AS_YN' || CHR(10) ||
 3589|         '    , A.AS_FROM_SITE' || CHR(10) ||
 3590|         '    , CASE WHEN A.CREATE_DATE IS NULL OR NVL(A.CREATE_DATE,'''')    = '''' THEN '' '' ELSE A.CREATE_DATE    END AS LAST_UPDATE_DATE' || CHR(10) ||
 3591|         '    , CASE WHEN A.LAST_UPDATED_BY IS NULL OR NVL(A.LAST_UPDATED_BY,'''')= '''' THEN '' '' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY' || CHR(10) ||
 3592|         '    , CASE WHEN A.SENDER_CODE IS NULL OR NVL(A.SENDER_CODE,'''')    = '''' THEN '' '' ELSE A.SENDER_CODE    END AS SENDER_CODE' || CHR(10) ||
 3593|         '    , CASE WHEN A.SENDER_NAME IS NULL OR NVL(A.SENDER_NAME,'''')    = '''' THEN '' '' ELSE A.SENDER_NAME    END AS SENDER_NAME' || CHR(10) ||
 3594|         '    , CASE WHEN 1 = 2 THEN '' '' END AS NOTATION' || CHR(10) ||
 3595|         'FROM (' || CHR(10) ||
 3596|         '    SELECT' || CHR(10) ||
 3597|         '          NVL(M.DIVISION_ID,  P.DIVISION_ID)                AS DIVISION_ID' || CHR(10) ||
 3598|         '        , NVL(M.PROJECT_CODE, P.PROJECT_CODE)               AS PROJECT_CODE' || CHR(10) ||
 3599|         '        , NVL(M.SCM_SITE_ID,  P.SCM_SITE_ID)                AS SCM_SITE_ID' || CHR(10) ||
 3600|         '        , NVL(M.PLANT_SITE_ID,P.PLANT_SITE_ID)              AS PLANT_SITE_ID' || CHR(10) ||
 3601|         '        , NVL(M.ITEM_ID,      P.ITEM_ID)                    AS ITEM_ID' || CHR(10) ||
 3602|         '        , NVL(M.DOM_EXP,      P.DOM_EXP)                    AS DOM_EXP' || CHR(10) ||
 3603|         '        , NVL(M.FCST_TYPE,    P.FCST_TYPE)                  AS FCST_TYPE' || CHR(10) ||
 3604|         '        , NVL(M.INCOTERMS,    P.INCOTERMS)                  AS INCOTERMS' || CHR(10) ||
 3605|         '        , CASE WHEN P.MEASURE IS NOT NULL OR NVL(P.MEASURE,'''') <> '''' THEN P.MEASURE' || CHR(10) ||
 3606|         '               WHEN M.MEASURE IS NULL THEN ''MKT_FCST_RP''' || CHR(10) ||
 3607|         '               ELSE M.MEASURE END                           AS MEASURE' || CHR(10) ||
 3608|         '        , CASE WHEN P.MEASURE_GROUP IS NOT NULL OR NVL(P.MEASURE_GROUP,'''') <> '''' THEN P.MEASURE_GROUP' || CHR(10) ||
 3609|         '               WHEN M.MEASURE_GROUP IS NULL THEN ''MKT_FCST_RP''' || CHR(10) ||
 3610|         '               ELSE M.MEASURE_GROUP END                     AS MEASURE_GROUP' || CHR(10) ||
 3611|         '        , M.FORECAST_INFO_CELL_MODEL' || CHR(10) ||
 3612|         '        , NVL(M.END_CUSTOMER,   P.END_CUSTOMER)             AS END_CUSTOMER' || CHR(10) ||
 3613|         '        , NVL(M.NICK_NAME,      P.NICK_NAME)                AS NICK_NAME' || CHR(10) ||
 3614|         '        , M.DMS_SALES' || CHR(10) ||
 3615|         '        , M.DMS_CUSTOMER' || CHR(10) ||
 3616|         '        , M.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
 3617|         '        , NVL(M.DEPT_ID,        P.DEPT_ID)                  AS DEPT_ID' || CHR(10) ||
 3618|         '        , NVL(M.DEPT_NAME_KO,   P.DEPT_NAME_KO)             AS DEPT_NAME_KO' || CHR(10) ||
 3619|         '        , NVL(M.ITEM_TYPE,      P.ITEM_TYPE)                AS ITEM_TYPE' || CHR(10) ||
 3620|         '        , NVL(M.PROJECT_NAME,   P.PROJECT_NAME)             AS PROJECT_NAME' || CHR(10) ||
 3621|         '        , NVL(M.PROJECT_OWNER,  P.PROJECT_OWNER)            AS PROJECT_OWNER' || CHR(10) ||
 3622|         '        , NVL(M.OWNER,          P.OWNER)                    AS OWNER' || CHR(10) ||
 3623|         '        , NVL(M.BIZ_TYPE,       P.BIZ_TYPE)                 AS BIZ_TYPE' || CHR(10) ||
 3624|         '        , NVL(M.SOLDTO_CUSTOMER,P.SOLDTO_CUSTOMER)          AS SOLDTO_CUSTOMER' || CHR(10) ||
 3625|         '        , NVL(M.COUNTRY_NAME,   P.COUNTRY_NAME)             AS COUNTRY_NAME' || CHR(10) ||
 3626|         '        , NVL(M.CITY_NAME,      P.CITY_NAME)                AS CITY_NAME' || CHR(10) ||
 3627|         '        , NVL(M.PROJECT_STATUS, P.PROJECT_STATUS)           AS PROJECT_STATUS' || CHR(10) ||
 3628|         '        , NVL(M.ITEM_NAME,      P.ITEM_NAME)                AS ITEM_NAME' || CHR(10) ||
 3629|         '        , NVL(M.VMI_YN,         P.VMI_YN)                   AS VMI_YN' || CHR(10) ||
 3630|         '        , M.CUST_GROUP' || CHR(10) ||
 3631|         '        , M.CUST_GROUP_DTL' || CHR(10) ||
 3632|         '        , M.APPLICATION' || CHR(10) ||
 3633|         '        , M.ROUTE' || CHR(10) ||
 3634|         '        , M.MDM_PROJECT_NAME' || CHR(10) ||
 3635|         '        , M.MIN_CAPACITY' || CHR(10) ||
 3636|         '        , M.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
 3637|         '        , M.CELL_TYPE' || CHR(10) ||
 3638|         '        , M.FORECAST_INFO_ALL' || CHR(10) ||
 3639|         '        , M.FORECAST_INFO_SPEC' || CHR(10) ||
 3640|         '        , M.FORECAST_INFOR_VERSION' || CHR(10) ||
 3641|         '        , M.CELL_MODEL_NICK_NAME' || CHR(10) ||
 3642|         '        , M.CELL_PER_CAR' || CHR(10) ||
 3643|         '        , M.CELL_PER_MODULE' || CHR(10) ||
 3644|         '        , M.MODULE_PER_CAR' || CHR(10) ||
 3645|         '        , NVL(P.SORT_ORDER_NO, M.SORT_ORDER_NO)             AS SORT_ORDER_NO' || CHR(10) ||
 3646|         '        , NVL(M.ENERGE,         P.ENERGE)                   AS ENERGE' || CHR(10) ||
 3647|         '        , NVL(M.CELL_QUANTITY,  P.CELL_QUANTITY)            AS CELL_QUANTITY' || CHR(10) ||
 3648|         '        , CASE WHEN M.DIVISION_ID IS NULL THEN ''Y'' ELSE ''N'' END AS NEW_FLAG' || CHR(10) ||
 3649|         '        , ''' || LP_AS_YN || '''                             AS AS_YN' || CHR(10) ||
 3650|         '        , M.AS_FROM_SITE' || CHR(10) ||
 3651|         '        , M.CREATE_DATE' || CHR(10) ||
 3652|         '        , M.LAST_UPDATED_BY' || CHR(10) ||
 3653|         '        , M.SENDER_CODE' || CHR(10) ||
 3654|         '        , M.SENDER_NAME' || CHR(10) ||
 3655|         '        , M.YYYYMMDD' || CHR(10) ||
 3656|         '    FROM SCM_MGR.GT_GGET_SALES_PRICE P' || CHR(10) ||
 3657|         '    FULL OUTER JOIN SCM_MGR.GT_GGET_MKT_FCST_DST M' || CHR(10) ||
 3658|         '      ON  P.DIVISION_ID   = M.DIVISION_ID' || CHR(10) ||
 3659|         '      AND P.PROJECT_CODE  = M.PROJECT_CODE' || CHR(10) ||
 3660|         '      AND P.SCM_SITE_ID   = M.SCM_SITE_ID' || CHR(10) ||
 3661|         '      AND P.PLANT_SITE_ID = M.PLANT_SITE_ID' || CHR(10) ||
 3662|         '      AND P.ITEM_ID       = M.ITEM_ID' || CHR(10) ||
 3663|         '      AND P.FCST_TYPE     = M.FCST_TYPE' || CHR(10) ||
 3664|         '      AND P.INCOTERMS     = M.INCOTERMS' || CHR(10) ||
 3665|         '      AND P.DOM_EXP       = M.DOM_EXP' || CHR(10) ||
 3666|         '      AND P.MEASURE       = M.MEASURE' || CHR(10) ||
 3667|         ') A' || CHR(10) ||
 3668|         'LEFT JOIN SCM_MGR.GT_GGET_MKT_FCST_DATA D' || CHR(10) ||
 3669|         '  ON  A.DIVISION_ID   = D.DIVISION_ID' || CHR(10) ||
 3670|         '  AND A.PROJECT_CODE  = D.PROJECT_CODE' || CHR(10) ||
 3671|         '  AND A.SCM_SITE_ID   = D.SCM_SITE_ID' || CHR(10) ||
 3672|         '  AND A.PLANT_SITE_ID = D.PLANT_SITE_ID' || CHR(10) ||
 3673|         '  AND A.ITEM_ID       = D.ITEM_ID' || CHR(10) ||
 3674|         '  AND A.DOM_EXP       = D.DOM_EXP' || CHR(10) ||
 3675|         '  AND A.FCST_TYPE     = D.FCST_TYPE' || CHR(10) ||
 3676|         '  AND A.INCOTERMS     = D.INCOTERMS' || CHR(10) ||
 3677|         '  AND A.MEASURE       = D.MEASURE' || CHR(10) ||
 3678|         'LEFT OUTER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C' || CHR(10) ||
 3679|         '  ON  C.BASIS_YYYYMMDD = D.YYYYMMDD' || CHR(10) ||
 3680|         'LEFT OUTER JOIN SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL I' || CHR(10) ||
 3681|         '  ON  A.DIVISION_ID = I.DIVISION_ID' || CHR(10) ||
 3682|         '  AND A.PROJECT_CODE = I.PROJECT_CODE' || CHR(10) ||
 3683|         '  AND A.ITEM_ID      = I.ITEM_ID' || CHR(10) ||
 3684|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_MONTH_END C2' || CHR(10) ||
 3685|         '  ON  A.YYYYMMDD = C2.MONTH_END_DATE' || CHR(10) ||
 3686|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_WEEK_END C3' || CHR(10) ||
 3687|         '  ON  A.YYYYMMDD = C3.WEEK_END_DATE' || CHR(10) ||
 3688|         'LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X' || CHR(10) ||
 3689|         '  ON  A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = ''AS_SITE_PLANT''' || CHR(10) ||
 3690|         'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M1' || CHR(10) ||
 3691|         '  ON  A.DIVISION_ID = M1.SEGMENT1' || CHR(10) ||
 3692|         '  AND A.MEASURE     = M1.SEGMENT2' || CHR(10) ||
 3693|         '  AND M1.LOOKUP_TYPE = ''MKT_FCST_MEASURE''' || CHR(10) ||
 3694|         '  AND M1.SEGMENT5    = ''Y''' || CHR(10) ||
 3695|         '  AND M1.VALID_YN    = ''Y''' || CHR(10) ||
 3696|         'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M2' || CHR(10) ||
 3697|         '  ON  A.DIVISION_ID  = M2.SEGMENT1' || CHR(10) ||
 3698|         '  AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
 3699|         '  AND ''[@p_created_by]'' = M2.SEGMENT4' || CHR(10) ||
 3700|         '  AND M2.LOOKUP_TYPE = ''TMM_MEASURE_ADMIN''' || CHR(10) ||
 3701|         '  AND M2.VALID_YN    = ''Y''' || CHR(10) ||
 3702|         'LEFT JOIN SCM_MGR.GT_GGET_VMI_DIO VM' || CHR(10) ||
 3703|         '  ON  A.SCM_SITE_ID = VM.KEY_JOIN' || CHR(10) ||
 3704|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_SSP_SYNC B1' || CHR(10) ||
 3705|         '  ON  A.DIVISION_ID  = B1.DIVISION_ID AND A.PROJECT_CODE = B1.PROJECT_CODE' || CHR(10) ||
 3706|         '  AND A.SCM_SITE_ID  = B1.SCM_SITE_ID  AND A.ITEM_ID     = B1.ITEM_ID' || CHR(10) ||
 3707|         '  AND A.DOM_EXP      = B1.DOM_EXP       AND A.FCST_TYPE   = B1.FCST_TYPE' || CHR(10) ||
 3708|         '  AND A.INCOTERMS    = B1.INCOTERMS     AND A.MEASURE     = ''MKT_FCST_RP''' || CHR(10) ||
 3709|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_BNP B2' || CHR(10) ||
 3710|         '  ON  A.DIVISION_ID  = B2.DIVISION_ID AND A.PROJECT_CODE = B2.PROJECT_CODE' || CHR(10) ||
 3711|         '  AND A.SCM_SITE_ID  = B2.SCM_SITE_ID  AND A.ITEM_ID     = B2.ITEM_ID' || CHR(10) ||
 3712|         '  AND A.DOM_EXP      = B2.DOM_EXP       AND A.FCST_TYPE   = B2.FCST_TYPE' || CHR(10) ||
 3713|         '  AND A.INCOTERMS    = B2.INCOTERMS     AND A.MEASURE     = ''BNPIn''' || CHR(10) ||
 3714|         'LEFT OUTER JOIN (' || CHR(10) ||
 3715|         '    SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS' || CHR(10) ||
 3716|         '         , NVL(V_SUN,0)||NVL(V_MON,0)||NVL(V_TUE,0)||NVL(V_WED,0)' || CHR(10) ||
 3717|         '           ||NVL(V_THU,0)||NVL(V_FRI,0)||NVL(V_SAT,0)              AS BUCKET' || CHR(10) ||
 3718|         '    FROM  (SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD' || CHR(10) ||
 3719|         '                , CASE WHEN BUCKET_PER = ''Y'' THEN 1 ELSE 0 END AS BUCKET_PER' || CHR(10) ||
 3720|         '           FROM  SCM_MGR.DM_MST_BUCKET_CONVERSION' || CHR(10) ||
 3721|         '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || ''') A' || CHR(10) ||
 3722|         '    PIVOT (MAX(BUCKET_PER) FOR YYYYMMDD' || CHR(10) ||
 3723|         '           IN (''SUN'' AS V_SUN,''MON'' AS V_MON,''TUE'' AS V_TUE,''WED'' AS V_WED,' || CHR(10) ||
 3724|         '               ''THU'' AS V_THU,''FRI'' AS V_FRI,''SAT'' AS V_SAT))' || CHR(10) ||
 3725|         ') BK ON A.DIVISION_ID = BK.DIVISION_ID' || CHR(10) ||
 3726|         '     AND A.SCM_SITE_ID = BK.SCM_SITE_ID' || CHR(10) ||
 3727|         '     AND A.INCOTERMS   = BK.INCOTERMS' || CHR(10) ||
 3728|         'LEFT OUTER JOIN (' || CHR(10) ||
 3729|         '    SELECT LOOK.SEGMENT3 AS DEPT_ID' || CHR(10) ||
 3730|         '    FROM   SCM_MGR.SCM_ADM_USER_M USR' || CHR(10) ||
 3731|         '    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK' || CHR(10) ||
 3732|         '      ON   USR.DEPT_ID = LOOK.SEGMENT1' || CHR(10) ||
 3733|         '     AND   LOOK.LOOKUP_TYPE = ''PM_TEAM_MAPPING''' || CHR(10) ||
 3734|         '     AND   LOOK.VALID_YN    = ''Y''' || CHR(10) ||
 3735|         '    WHERE  USR.USER_ID = ''[@p_created_by]''' || CHR(10) ||
 3736|         '    UNION' || CHR(10) ||
 3737|         '    SELECT DEPT_ID FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID = ''[@p_created_by]''' || CHR(10) ||
 3738|         ') MA ON A.DEPT_ID = MA.DEPT_ID' || CHR(10) ||
 3739|         'WHERE 1=1 AND [@v_team_id]' || CHR(10) ||
 3740|         ')' || CHR(10) ||
 3741|         -- ── PIVOT WRAPPER (일별/주별/월별 UNION ALL + PIVOT) ──────────────────────
 3742|         'SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]' || CHR(10) ||
 3743|         'FROM (' || CHR(10) ||
 3744|         '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY' || CHR(10) ||
 3745|         '    FROM   MF_BASE F' || CHR(10) ||
 3746|         '    UNION ALL' || CHR(10) ||
 3747|         '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD' || CHR(10) ||
 3748|         '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
 3749|         '                THEN CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
 3750|         '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
 3751|         '    FROM   MF_BASE F' || CHR(10) ||
 3752|         '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
 3753|         '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
 3754|         '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
 3755|         '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
 3756|         '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
 3757|         '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
 3758|         '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
 3759|         '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
 3760|         '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN' || CHR(10) ||
 3761|         '    UNION ALL' || CHR(10) ||
 3762|         '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD' || CHR(10) ||
 3763|         '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
 3764|         '                THEN CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
 3765|         '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
 3766|         '    FROM   MF_BASE F' || CHR(10) ||
 3767|         '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
 3768|         '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
 3769|         '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
 3770|         '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
 3771|         '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
 3772|         '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
 3773|         '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
 3774|         '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
 3775|         '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN' || CHR(10) ||
 3776|         ') F' || CHR(10) ||
 3777|         'PIVOT (SUM(QTY) FOR YYYYMMDD IN ([@V_PV_LIST])) PVT' || CHR(10) ||
 3778|         '[@V_ORDERBY]';
 3779| 
 3780| 
 3781|     ELSE
 3782| 
 3783|         -- -----------------------------------------------------------------------
 3784|         -- 비AS 경로 보완 처리: LP_AS_YN='Y' → AS_IN_REQ/PLAN/INV 빈 행 추가
 3785|         -- -----------------------------------------------------------------------
 3786| 		-- IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' AND AND LP_AS_YN = 'Y' THEN
 3787|         IF LP_AS_YN = 'Y' THEN
 3788|             DECLARE
 3789|                 V_AS_CNT2 PLS_INTEGER := 0;
 3790|             BEGIN
 3791|                 SELECT COUNT(1) INTO V_AS_CNT2
 3792|                 FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 3793|                 WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV');
 3794| 
 3795|                 IF V_AS_CNT2 > 0 THEN
 3796|                     -- AS 사이트에 해당하는 조합 중 AS 메저가 없는 날짜에 QTY=0 행 삽입
 3797|                     INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
 3798|                     ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
 3799|                     , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
 3800|                     , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
 3801|                     , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
 3802|                     , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER
 3803|                     , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
 3804|                     , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
 3805|                     , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
 3806|                     , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
 3807|                     , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
 3808|                     , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
 3809|                     , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
 3810|                     SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
 3811|                          , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
 3812|                          , C.MEASURE
 3813|                          , A.YYYYMMDD   -- MAX(YYYYMMDD) 기준 날짜 사용
 3814|                          , 0  AS QTY
 3815|                          , C.MEASURE_GROUP
 3816|                          , A.CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
 3817|                          , A.DMS_SALES, A.DMS_CUSTOMER, A.OWNER, A.DEPT_ID, A.DEPT_NAME_KO
 3818|                          , A.FORECAST_INFO_CELL_PACK_COUNT, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER
 3819|                          , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
 3820|                          , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
 3821|                          , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
 3822|                          , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
 3823|                          , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
 3824|                          , C.SORT_ORDER_NO
 3825|                          , A.ENERGE, A.CELL_QUANTITY
 3826|                          , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
 3827|                     FROM (
 3828|                         -- AS 사이트 기반 헤더 (최신 YYYYMMDD)
 3829|                         SELECT A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
 3830|                              , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
 3831|                              , MAX(A2.YYYYMMDD) AS YYYYMMDD
 3832|                              , 0 AS QTY
 3833|                              , A2.CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
 3834|                              , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.OWNER, A2.DEPT_ID, A2.DEPT_NAME_KO
 3835|                              , A2.FORECAST_INFO_CELL_PACK_COUNT, A2.ITEM_TYPE, A2.PROJECT_NAME, A2.PROJECT_OWNER
 3836|                              , A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER, A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS
 3837|                              , A2.ITEM_NAME, A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL
 3838|                              , A2.APPLICATION, A2.ROUTE, A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY
 3839|                              , A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
 3840|                              , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
 3841|                              , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
 3842|                              , A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
 3843|                              , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
 3844|                         FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA A2
 3845|                         JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B2
 3846|                           ON   A2.SCM_SITE_ID = B2.SEGMENT1
 3847|                          AND   B2.LOOKUP_TYPE = 'AS_SITE_PLANT'
 3848|                          AND   B2.SEGMENT3    = P_DIVISION_ID
 3849|                         GROUP  BY A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
 3850|                                ,  A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
 3851|                                ,  A2.CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
 3852|                                ,  A2.DMS_SALES, A2.DMS_CUSTOMER, A2.OWNER, A2.DEPT_ID, A2.DEPT_NAME_KO
 3853|                                ,  A2.FORECAST_INFO_CELL_PACK_COUNT, A2.ITEM_TYPE, A2.PROJECT_NAME, A2.PROJECT_OWNER
 3854|                                ,  A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER, A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS
 3855|                                ,  A2.ITEM_NAME, A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL
 3856|                                ,  A2.APPLICATION, A2.ROUTE, A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY
 3857|                                ,  A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
 3858|                                ,  A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
 3859|                                ,  A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
 3860|                                ,  A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
 3861|                                ,  A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
 3862|                     ) A
 3863|                     -- AS_IN_REQ/PLAN/INV 메저 CROSS JOIN
 3864|                     JOIN (
 3865|                         SELECT MEASURE, MEASURE_GROUP, SORT_ORDER_NO
 3866|                         FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
 3867|                         WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV')
 3868|                     ) C ON 1=1
 3869|                     -- 이미 존재하는 조합 제외
 3870|                     LEFT OUTER JOIN (
 3871|                         SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 3872|                                       , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
 3873|                         FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA D2
 3874|                         JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B3
 3875|                           ON   D2.SCM_SITE_ID = B3.SEGMENT1
 3876|                          AND   B3.LOOKUP_TYPE = 'AS_SITE_PLANT'
 3877|                          AND   B3.SEGMENT3    = P_DIVISION_ID
 3878|                     ) D ON  A.DIVISION_ID   = D.DIVISION_ID
 3879|                         AND A.PROJECT_CODE  = D.PROJECT_CODE
 3880|                         AND A.SCM_SITE_ID   = D.SCM_SITE_ID
 3881|                         AND A.ITEM_ID       = D.ITEM_ID
 3882|                         AND A.DOM_EXP       = D.DOM_EXP
 3883|                         AND A.FCST_TYPE     = D.FCST_TYPE
 3884|                         AND A.INCOTERMS     = D.INCOTERMS
 3885|                         AND C.MEASURE       = D.MEASURE
 3886|                         AND A.PLANT_SITE_ID = D.PLANT_SITE_ID
 3887|                     WHERE D.DIVISION_ID IS NULL;
 3888|                 END IF;
 3889|             END;
 3890|         END IF;
 3891| 
 3892|         -- -----------------------------------------------------------------------
 3893|         -- PIVOT SQL #2 (비AS용, 일반 경로)
 3894|         --   소스: GT_GGET_MKT_FCST_DATA  → #MF (임시)
 3895|         --         → PIVOT + EXECUTE IMMEDIATE
 3896|         -- -----------------------------------------------------------------------
 3897|         V_SQL_TEXT :=
 3898|         'WITH MF_BASE AS (' || CHR(10) ||
 3899|         'SELECT' || CHR(10) ||
 3900|         '      A.DIVISION_ID' || CHR(10) ||
 3901|         '    , A.DIVISION_ID                                         AS DIVISION_ID40' || CHR(10) ||
 3902|         '    , A.SCM_SITE_ID' || CHR(10) ||
 3903|         '    , A.SCM_SITE_ID                                         AS SCM_SITE_ID40' || CHR(10) ||
 3904|         '    , A.PLANT_SITE_ID' || CHR(10) ||
 3905|         '    , A.PROJECT_CODE' || CHR(10) ||
 3906|         '    , NVL(I.GROUP_ID,'''')                                  AS GROUP_ID' || CHR(10) ||
 3907|         '    , A.ITEM_ID' || CHR(10) ||
 3908|         '    , A.ITEM_ID                                             AS ITEM_ID40' || CHR(10) ||
 3909|         '    , A.INCOTERMS' || CHR(10) ||
 3910|         '    , A.FCST_TYPE' || CHR(10) ||
 3911|         '    , A.DOM_EXP' || CHR(10) ||
 3912|         '    , A.MEASURE' || CHR(10) ||
 3913|         '    , A.END_CUSTOMER' || CHR(10) ||
 3914|         '    , CASE WHEN (A.DIVISION_ID LIKE ''81%'' OR A.DIVISION_ID = ''82'')' || CHR(10) ||
 3915|         '           THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END      AS END_CUSTOMER40' || CHR(10) ||
 3916|         '    , A.NICK_NAME' || CHR(10) ||
 3917|         '    , A.DMS_SALES' || CHR(10) ||
 3918|         '    , A.DMS_CUSTOMER' || CHR(10) ||
 3919|         '    , C.BASIS_YYYYMM                                        AS YYYYMM' || CHR(10) ||
 3920|         '    , C.BASIS_YYYYMM || C.ISO_WEEK                          AS YYYYMMWW' || CHR(10) ||
 3921|         '    , C.BASIS_YYYYMMDD                                      AS YYYYMMDD' || CHR(10) ||
 3922|         '    , C.DAYOFWEEK' || CHR(10) ||
 3923|         '    , A.CELL_MODEL                                          AS FORECAST_INFO_CELL_MODEL' || CHR(10) ||
 3924|         '    , A.DEPT_ID                                             AS TEAM_ID' || CHR(10) ||
 3925|         '    , A.DEPT_NAME_KO                                        AS TEAM_NAME_KO' || CHR(10) ||
 3926|         '    , A.ITEM_TYPE' || CHR(10) ||
 3927|         '    , A.PROJECT_NAME' || CHR(10) ||
 3928|         '    , A.PROJECT_OWNER' || CHR(10) ||
 3929|         '    , A.OWNER' || CHR(10) ||
 3930|         '    , A.BIZ_TYPE' || CHR(10) ||
 3931|         '    , A.SOLDTO_CUSTOMER' || CHR(10) ||
 3932|         '    , A.COUNTRY_NAME' || CHR(10) ||
 3933|         '    , A.CITY_NAME' || CHR(10) ||
 3934|         '    , A.PROJECT_STATUS' || CHR(10) ||
 3935|         '    , A.ITEM_NAME' || CHR(10) ||
 3936|         '    , A.VMI_YN' || CHR(10) ||
 3937|         '    , A.CUST_GROUP' || CHR(10) ||
 3938|         '    , A.CUST_GROUP_DTL' || CHR(10) ||
 3939|         '    , A.APPLICATION' || CHR(10) ||
 3940|         '    , A.ROUTE' || CHR(10) ||
 3941|         '    , A.MDM_PROJECT_NAME' || CHR(10) ||
 3942|         '    , A.MIN_CAPACITY' || CHR(10) ||
 3943|         '    , A.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
 3944|         '    , A.CELL_TYPE' || CHR(10) ||
 3945|         '    , A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
 3946|         '    , A.FORECAST_INFO_ALL' || CHR(10) ||
 3947|         '    , A.FORECAST_INFO_SPEC' || CHR(10) ||
 3948|         '    , A.FORECAST_INFOR_VERSION' || CHR(10) ||
 3949|         '    , A.CELL_MODEL_NICK_NAME' || CHR(10) ||
 3950|         '    , CAST(CASE WHEN ''Y'' = ''[@CellQtyYN]''' || CHR(10) ||
 3951|         '                 AND A.MEASURE_GROUP NOT IN (''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'')' || CHR(10) ||
 3952|         '                 AND NVL(A.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1' || CHR(10) ||
 3953|         '                THEN A.QTY * A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
 3954|         '                ELSE A.QTY END AS NUMBER(36,10)) AS QTY' || CHR(10) ||
 3955|         '    , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS MONTH_END_YN' || CHR(10) ||
 3956|         '    , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN ''Y'' ELSE ''N'' END AS WEEK_END_YN' || CHR(10) ||
 3957|         '    , CASE' || CHR(10) ||
 3958|         '          WHEN MA.DEPT_ID IS NOT NULL' || CHR(10) ||
 3959|         '               AND A.MEASURE_GROUP NOT IN (''CUST_FCST_2'',''CUST_FCST_3'',''TMM_FCST'')' || CHR(10) ||
 3960|         '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
 3961|         '          WHEN ''[@v_group_id]'' = ''ADMIN''' || CHR(10) ||
 3962|         '               AND A.MEASURE_GROUP <> ''TMM_FCST''' || CHR(10) ||
 3963|         '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
 3964|         '          WHEN A.MEASURE_GROUP = ''TMM_FCST''' || CHR(10) ||
 3965|         '               AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
 3966|         '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
 3967|         '          ELSE ''N''' || CHR(10) ||
 3968|         '      END AS EDIT_FLAG' || CHR(10) ||
 3969|         '    , A.CELL_PER_CAR' || CHR(10) ||
 3970|         '    , A.CELL_PER_MODULE' || CHR(10) ||
 3971|         '    , A.MODULE_PER_CAR' || CHR(10) ||
 3972|         '    , A.SORT_ORDER_NO' || CHR(10) ||
 3973|         '    , A.MEASURE_GROUP' || CHR(10) ||
 3974|         '    , A.ENERGE' || CHR(10) ||
 3975|         '    , A.CELL_QUANTITY' || CHR(10) ||
 3976|         '    , ''N''                                                 AS NEW_FLAG' || CHR(10) ||
 3977|         '    , CASE WHEN A.DIVISION_ID = ''40''' || CHR(10) ||
 3978|         '           THEN TO_CHAR(CAST(VM.VMI_STD_DIO AS NUMBER))' || CHR(10) ||
 3979|         '           ELSE VM.VMI_VAL END                              AS VMI_STD_DIO' || CHR(10) ||
 3980|         '    , NVL(B1.ATTR1, B2.ATTR1)                              AS ATTR1' || CHR(10) ||
 3981|         '    , NVL(BK.BUCKET,''0000000'')                           AS BUCKET' || CHR(10) ||
 3982|         '    , ''' || LP_AS_YN || '''                                AS AS_YN' || CHR(10) ||
 3983|         '    , CASE WHEN ''' || LP_AS_YN || ''' = ''Y'' THEN NVL(X.DISPLAY_SEQ,999) ELSE 999 END AS SORT_KEY' || CHR(10) ||
 3984|         '    , NVL(A.AS_FROM_SITE,'''')                             AS AS_FROM_SITE' || CHR(10) ||
 3985|         '    , CASE WHEN A.CREATE_DATE IS NULL OR NVL(A.CREATE_DATE,'''')    = '''' THEN '' '' ELSE A.CREATE_DATE    END AS LAST_UPDATE_DATE' || CHR(10) ||
 3986|         '    , CASE WHEN A.LAST_UPDATED_BY IS NULL OR NVL(A.LAST_UPDATED_BY,'''')= '''' THEN '' '' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY' || CHR(10) ||
 3987|         '    , CASE WHEN A.SENDER_CODE IS NULL OR NVL(A.SENDER_CODE,'''')    = '''' THEN '' '' ELSE A.SENDER_CODE    END AS SENDER_CODE' || CHR(10) ||
 3988|         '    , CASE WHEN A.SENDER_NAME IS NULL OR NVL(A.SENDER_NAME,'''')    = '''' THEN '' '' ELSE A.SENDER_NAME    END AS SENDER_NAME' || CHR(10) ||
 3989|         '    , A.NOTATION' || CHR(10) ||
 3990|         'FROM SCM_MGR.GT_GGET_MKT_FCST_DATA A' || CHR(10) ||
 3991|         'INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C' || CHR(10) ||
 3992|         '  ON  C.BASIS_YYYYMMDD = A.YYYYMMDD' || CHR(10) ||
 3993|         'LEFT OUTER JOIN SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL I' || CHR(10) ||
 3994|         '  ON  A.DIVISION_ID = I.DIVISION_ID' || CHR(10) ||
 3995|         '  AND A.PROJECT_CODE = I.PROJECT_CODE' || CHR(10) ||
 3996|         '  AND A.ITEM_ID      = I.ITEM_ID' || CHR(10) ||
 3997|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_MONTH_END C2' || CHR(10) ||
 3998|         '  ON  A.YYYYMMDD = C2.MONTH_END_DATE' || CHR(10) ||
 3999|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_WEEK_END C3' || CHR(10) ||
 4000|         '  ON  A.YYYYMMDD = C3.WEEK_END_DATE' || CHR(10) ||
 4001|         'LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X' || CHR(10) ||
 4002|         '  ON  A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = ''AS_SITE_PLANT''' || CHR(10) ||
 4003|         'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M1' || CHR(10) ||
 4004|         '  ON  A.DIVISION_ID = M1.SEGMENT1' || CHR(10) ||
 4005|         '  AND A.MEASURE     = M1.SEGMENT2' || CHR(10) ||
 4006|         '  AND M1.LOOKUP_TYPE = ''MKT_FCST_MEASURE''' || CHR(10) ||
 4007|         '  AND M1.SEGMENT5    = ''Y''' || CHR(10) ||
 4008|         '  AND M1.VALID_YN    = ''Y''' || CHR(10) ||
 4009|         'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M2' || CHR(10) ||
 4010|         '  ON  A.DIVISION_ID  = M2.SEGMENT1' || CHR(10) ||
 4011|         '  AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
 4012|         '  AND ''[@p_created_by]'' = M2.SEGMENT4' || CHR(10) ||
 4013|         '  AND M2.LOOKUP_TYPE = ''TMM_MEASURE_ADMIN''' || CHR(10) ||
 4014|         '  AND M2.VALID_YN    = ''Y''' || CHR(10) ||
 4015|         'LEFT JOIN SCM_MGR.GT_GGET_VMI_DIO VM' || CHR(10) ||
 4016|         '  ON  A.ITEM_ID     = CASE WHEN ''' || P_DIVISION_ID || ''' = ''40'' THEN VM.KEY_JOIN ELSE A.ITEM_ID END' || CHR(10) ||
 4017|         '  AND ( ''' || P_DIVISION_ID || ''' = ''40''  ' || CHR(10) ||
 4018|         '        OR A.SCM_SITE_ID = VM.KEY_JOIN )' || CHR(10) ||
 4019|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_SSP_SYNC B1' || CHR(10) ||
 4020|         '  ON  A.DIVISION_ID  = B1.DIVISION_ID AND A.PROJECT_CODE = B1.PROJECT_CODE' || CHR(10) ||
 4021|         '  AND A.SCM_SITE_ID  = B1.SCM_SITE_ID  AND A.ITEM_ID     = B1.ITEM_ID' || CHR(10) ||
 4022|         '  AND A.DOM_EXP      = B1.DOM_EXP       AND A.FCST_TYPE   = B1.FCST_TYPE' || CHR(10) ||
 4023|         '  AND A.INCOTERMS    = B1.INCOTERMS     AND A.MEASURE     = ''MKT_FCST_RP''' || CHR(10) ||
 4024|         'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_BNP B2' || CHR(10) ||
 4025|         '  ON  A.DIVISION_ID  = B2.DIVISION_ID AND A.PROJECT_CODE = B2.PROJECT_CODE' || CHR(10) ||
 4026|         '  AND A.SCM_SITE_ID  = B2.SCM_SITE_ID  AND A.ITEM_ID     = B2.ITEM_ID' || CHR(10) ||
 4027|         '  AND A.DOM_EXP      = B2.DOM_EXP       AND A.FCST_TYPE   = B2.FCST_TYPE' || CHR(10) ||
 4028|         '  AND A.INCOTERMS    = B2.INCOTERMS     AND A.MEASURE     = ''BNPIn''' || CHR(10) ||
 4029|         'LEFT OUTER JOIN (' || CHR(10) ||
 4030|         '    SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS' || CHR(10) ||
 4031|         '         , NVL(V_SUN,0)||NVL(V_MON,0)||NVL(V_TUE,0)||NVL(V_WED,0)' || CHR(10) ||
 4032|         '           ||NVL(V_THU,0)||NVL(V_FRI,0)||NVL(V_SAT,0)              AS BUCKET' || CHR(10) ||
 4033|         '    FROM  (SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD' || CHR(10) ||
 4034|         '                , CASE WHEN BUCKET_PER = ''Y'' THEN 1 ELSE 0 END AS BUCKET_PER' || CHR(10) ||
 4035|         '           FROM  SCM_MGR.DM_MST_BUCKET_CONVERSION' || CHR(10) ||
 4036|         '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || ''') A' || CHR(10) ||
 4037|         '    PIVOT (MAX(BUCKET_PER) FOR YYYYMMDD' || CHR(10) ||
 4038|         '           IN (''SUN'' AS V_SUN,''MON'' AS V_MON,''TUE'' AS V_TUE,''WED'' AS V_WED,' || CHR(10) ||
 4039|         '               ''THU'' AS V_THU,''FRI'' AS V_FRI,''SAT'' AS V_SAT))' || CHR(10) ||
 4040|         ') BK ON A.DIVISION_ID = BK.DIVISION_ID' || CHR(10) ||
 4041|         '     AND A.SCM_SITE_ID = BK.SCM_SITE_ID' || CHR(10) ||
 4042|         '     AND A.INCOTERMS   = BK.INCOTERMS' || CHR(10) ||
 4043|         'LEFT OUTER JOIN (' || CHR(10) ||
 4044|         '    SELECT LOOK.SEGMENT3 AS DEPT_ID' || CHR(10) ||
 4045|         '    FROM   SCM_MGR.SCM_ADM_USER_M USR' || CHR(10) ||
 4046|         '    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK' || CHR(10) ||
 4047|         '      ON   USR.DEPT_ID = LOOK.SEGMENT1' || CHR(10) ||
 4048|         '     AND   LOOK.LOOKUP_TYPE = ''PM_TEAM_MAPPING''' || CHR(10) ||
 4049|         '     AND   LOOK.VALID_YN    = ''Y''' || CHR(10) ||
 4050|         '    WHERE  USR.USER_ID = ''[@p_created_by]''' || CHR(10) ||
 4051|         '    UNION' || CHR(10) ||
 4052|         '    SELECT DEPT_ID FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID = ''[@p_created_by]''' || CHR(10) ||
 4053|         ') MA ON A.DEPT_ID = MA.DEPT_ID' || CHR(10) ||
 4054|         'WHERE 1=1 AND [@v_team_id]' || CHR(10) ||
 4055|         ')' || CHR(10) ||
 4056|         -- ── PIVOT WRAPPER (동일) ──────────────────────────────────────────────────
 4057|         'SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]' || CHR(10) ||
 4058|         'FROM (' || CHR(10) ||
 4059|         '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY' || CHR(10) ||
 4060|         '    FROM   MF_BASE F' || CHR(10) ||
 4061|         '    UNION ALL' || CHR(10) ||
 4062|         '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD' || CHR(10) ||
 4063|         '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
 4064|         '                THEN CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
 4065|         '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
 4066|         '    FROM   MF_BASE F' || CHR(10) ||
 4067|         '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
 4068|         '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
 4069|         '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
 4070|         '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
 4071|         '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
 4072|         '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
 4073|         '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
 4074|         '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
 4075|         '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN' || CHR(10) ||
 4076|         '    UNION ALL' || CHR(10) ||
 4077|         '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD' || CHR(10) ||
 4078|         '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
 4079|         '                THEN CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
 4080|         '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
 4081|         '    FROM   MF_BASE F' || CHR(10) ||
 4082|         '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
 4083|         '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
 4084|         '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
 4085|         '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
 4086|         '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
 4087|         '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
 4088|         '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
 4089|         '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
 4090|         '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN' || CHR(10) ||
 4091|         ') F' || CHR(10) ||
 4092|         'PIVOT (SUM(QTY) FOR YYYYMMDD IN ([@V_PV_LIST])) PVT' || CHR(10) ||
 4093|         '[@V_ORDERBY]';
 4094| 
 4095|     END IF;
 4096| 
 4097| 
 4098| 
 4099|     -----------------------------------------------------------------------
 4100|     -- 플레이스홀더 치환
 4101|     -----------------------------------------------------------------------
 4102|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_COL_LIST]',  V_PV_COL_LIST);
 4103|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_LIST]',      V_PV_LIST);
 4104|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_COLUMN]',       V_COLUMN);
 4105|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_groupby]',      V_GROUPBY);
 4106|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_team_id]',      V_TEAM_WHERE);
 4107|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_created_by]',   P_CREATED_BY);
 4108|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_group_id]',     V_GROUP_ID);
 4109|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_orderby]',      V_ORDERBY);
 4110|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_ORDERBY]',      V_ORDERBY);
 4111|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_from_yyyymmdd]',P_FROM_YYYYMMDD);
 4112|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_to_yyyymmdd]',  P_TO_YYYYMMDD);
 4113|     V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@CellQtyYN]',      P_CELL_YN);
 4114|     -- 종료 LOG
 4115|     V_LOG_TYPE    := 'END';
 4116|     V_LOG_MESSAGE := '########## END of procedure ##########';
 4117|     V_DESCRIPTION := '-';
 4118|     D_EVENT_DATE  := SYSDATE;
 4119|     BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
 4120| 
 4121|     -----------------------------------------------------------------------
 4122|     -- EXECUTE IMMEDIATE → O_RC 반환
 4123|     -----------------------------------------------------------------------
 4124|     DBMS_OUTPUT.PUT_LINE(V_SQL_TEXT);
 4125|     OPEN O_RC1 FOR V_SQL_TEXT;
 4126| 
 4127|     -----------------------------------------------------------------------
 4128|     -- O_RC2: 8주 이내 버킷 정보 (20181115 소형 사업부 일별 입력 전용)
 4129|     -- 원본: SELECT TOP 1 * FROM SCM_SYS_CALENDAR_M
 4130|     --       WHERE ISO_WEEK = DATEPART(ISO_WEEK, DATEADD(WEEK,7,GETDATE()))
 4131|     --         AND CALENDAR_YYYY = DATEPART(YEAR, DATEADD(WEEK,7,GETDATE()))
 4132|     --       ORDER BY BASIS_YYYYMMDD
 4133|     -----------------------------------------------------------------------
 4134|     OPEN O_RC2 FOR
 4135|         SELECT *
 4136|         FROM   SCM_MGR.SCM_SYS_CALENDAR_M
 4137|         WHERE  ISO_YYYYWW  = TO_CHAR(SYSDATE + (7*7), 'IYYY') ||
 4138|                              TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE + (7*7), 'IW')), 'FM00')
 4139|         ORDER  BY BASIS_YYYYMMDD
 4140|         FETCH  FIRST 1 ROW ONLY;
 4141| 
 4142|     -----------------------------------------------------------------------
 4143|     -- O_RC3: 현재 주차 정보 (20211130)
 4144|     -- 원본: SELECT 'M_'+THIS_YYYYMM, 'W_'+THIS_YYYYMMWW, ...
 4145|     --                현재주 + 전주 정보
 4146|     -----------------------------------------------------------------------
 4147|     OPEN O_RC3 FOR
 4148|         SELECT 'M_' || A.BASIS_YYYYMM                         AS THIS_YYYYMM
 4149|              , 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK           AS THIS_YYYYMMWW
 4150|              , A.BASIS_DATE
 4151|              , 'M_' || B.BASIS_YYYYMM                         AS PRE_YYYYMM
 4152|              , 'W_' || B.BASIS_YYYYMM || B.ISO_WEEK           AS PRE_YYYYMMWW
 4153|              , A.BASIS_YYYYMM, A.ISO_WEEK
 4154|         FROM   (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
 4155|                 FROM   SCM_MGR.SCM_SYS_CALENDAR_M
 4156|                 WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')) A
 4157|         JOIN   (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
 4158|                 FROM   SCM_MGR.SCM_SYS_CALENDAR_M
 4159|                 WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE - 7, 'YYYYMMDD')) B ON 1=1;
 4160| 
 4161|     OPEN O_RESULT_CURSOR FOR
 4162|     SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
 4163| 
 4164| EXCEPTION
 4165|     WHEN OTHERS THEN
 4166|         ROLLBACK;
 4167|         V_LOG_TYPE    := 'ERROR';
 4168|         V_LOG_MESSAGE := 'EXCEPTION';
 4169|         V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
 4170|         D_EVENT_DATE  := SYSDATE;
 4171|         V_SQL_CODE    := TO_CHAR(SQLCODE);
 4172|         V_SQL_ERRMSG  := SQLERRM;
 4173| 
 4174|         V_PROC_INPUT := JSON_OBJECT(
 4175|             'P_DIVISION_ID'   VALUE P_DIVISION_ID,
 4176|             'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
 4177|             'P_PLANT_SITE_ID' VALUE P_PLANT_SITE_ID,
 4178|             'P_FROM_YYYYMMDD' VALUE P_FROM_YYYYMMDD,
 4179|             'P_TO_YYYYMMDD'   VALUE P_TO_YYYYMMDD,
 4180|             'P_CREATED_BY'    VALUE P_CREATED_BY,
 4181|             'P_USER_GROUP'    VALUE P_USER_GROUP,
 4182|             'P_ITEM_ID'       VALUE P_ITEM_ID
 4183|         );
 4184|         V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
 4185| 
 4186|         BEGIN
 4187|             SCM_MGR.PR_DM_SYS_LOG_BATCH(
 4188|                 V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE,
 4189|                 V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY, V_PROC_INPUT,
 4190|                 V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
 4191|             );
 4192|         END;
 4193| 
 4194|         RAISE_APPLICATION_ERROR(-20001,
 4195|             '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE
 4196|          || ' / SQLERRM='   || V_SQL_ERRMSG
 4197|          || ' / BACKTRACE=' || V_BACKTRACE
 4198|          || ' / PARAMS='    || V_PROC_INPUT
 4199|         );
 4200| 
 4201| END DMF0003_GET_MKT_FCST_DATA;

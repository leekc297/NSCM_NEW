# SSP0014 기준 원장 (2026-11-25 03:00:55)

- 원장 1068행 → 기준 항목 959개 · 요소 72개 · 상태 확정 559 · 대상 아님 368 · 판단 대기 32
- 다른 문서 행 710행: 같은 확인으로 합침 109 · 요소 지정 69 · 화면 전체 131 · 대상 아님(검색 0건 확인) 361 · 판단 대기 30
- TO-BE 룰 결합 247건(인용 불일치로 버림 0) · AS-IS 실측 연결 34건(판단 대기 28) · 사용자의견 고정 0건
- AI 호출 0(기억 37 · 실패 0 · 바꾼 것 없는 호출 0) · 비용 출처 Doc/verify/SSP0014/llm_usage.csv

## 판단 대기(사용자 확인)

| 기준 항목 | 요소 | 규칙 | 확인 | 사유 |
|---|---|---|---|---|
| C-e88f4173c2 | SCREEN | C1 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | 이 화면의 조회조건과 그리드에는 Team·End Customer·Sales Site 콤보가 없다. · 검색어가 화면에 있음: Team 10곳 |
| C-75199f765f | SCREEN | C1 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | 이 화면에는 Team·End Customer·Sales Site 조회조건이 없다. · 검색어가 화면에 있음: Team 10곳 |
| C-39bad5f21d | SCREEN | M3 | [DMF0042 결함 유형] Replace 버튼 팝업 Period·조회 | SSP0014 에는 Replace 버튼 팝업이 없다. · 검색어가 화면에 있음: Replace 2곳 |
| C-87acb1fa8b | SCREEN | B4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SSP0014에는 ETC 입력의 Team·Measure 컬럼이 없다. · 검색어가 화면에 있음: Measure 1곳 |
| C-6457070f5e | SCREEN | N1 | [DMF0044 결함 유형] Measure 항목 구성 | SSP0014에는 Div별 UI Category 기준 Measure 항목이 없습니다. · 검색어가 화면에 있음: UI Category 1곳 |
| C-231b87bfc2 | SCREEN | M3 | [DMF0053 결함 유형] 팝업 Filter 텍스트 입력창 | SSP0014 팝업 호출부에는 Filter 텍스트 입력창이 없다. · 검색어가 화면에 있음: Filter 9곳 |
| C-aa2df58c20 | SCREEN | C2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | 이 화면 그리드에는 Measure 입력이나 AS From Site 콤보가 없다. · 검색어가 화면에 있음: Measure 1곳 |
| C-4a050175c7 | SCREEN | F1 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SSP0014 에는 FCST Type·Text 컬럼과 ETC 테이블 저장 기능이 없다. · 검색어가 화면에 있음: TEXT 7곳 |
| C-b6921659e1 | SCREEN | C2 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | 이 화면 그리드에는 AS From Site·Measure 컬럼이 없다. · 검색어가 화면에 있음: Measure 1곳 |
| C-ae44c2ea44 | SCREEN | B4 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SSP0014에는 AS From Site 항목과 Measure 콤보가 없다. · 검색어가 화면에 있음: Measure 1곳 |
| C-6a838de719 | SCREEN | H5 | [DMF0035 결함 유형] Measure 명칭 MKT FCST[R+P] | SSP0014 Shipment Model PIC 화면에는 Measure 조회나 MKT FCST[R+P] 명칭 표시가 없어 DMF0035 Measure 명칭 결함 유형의 대상이 아니다. · 검색어가 화면에 있음: Measure 1곳 |
| C-288f4f1c8c | SCREEN | H5 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SSP0014 그리드에는 Dept 컬럼과 Use Y/N 병합 헤더가 없고 Active 상태 컬럼은 VALID_YN(Active*) 하나여서 SYS0002 Dept 결함 유형의 대상이 아니다. · 검색어가 화면에 있음: Dept 1곳 |
| C-7050001730 | SCREEN | F6 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SSP0014 의 컬럼 목록에 Dept 컬럼과 Use Y/N 헤더가 없다. · 검색어가 화면에 있음: DEPT 1곳 |
| C-132c16be69 | SCREEN | F1 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | SSP0014 에는 Division 시트와 JV Planner 저장 기능이 없다. · 검색어가 화면에 있음: JV Planner 1곳 |
| C-9007a65dc5 | SCREEN | F6 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | SSP0014 는 시트가 spdMain 하나라 JV Planner 용 Division 시트가 없다. · 검색어가 화면에 있음: JV Planner 1곳 |
| C-240e9defa8 | SCREEN | A1 | [DMF0082 결함 유형] RTF[R+P] Measure 행 | SSP0014 그리드는 Model·User ID·Mail User 등 담당자 컬럼만 있고 실적·계획 구간을 합친 RTF[R+P] Measure 행이 없다. · 검색어가 화면에 있음: Measure 1곳 |
| C-761020b7d9 | SCREEN | G5 | [SCP0006 결함 유형] Capa New Model 팝업 조건(Group/Plant) | 기준 정리 답 없음(AI 꺼짐 또는 실패) — 화면 전체로 둠 |
| C-e7a1d51af3 | SCREEN | M3 | [SCP0006 결함 유형] Capa New Model 팝업 조건(Group/Plant) | SSP0014 에는 Capa New Model 팝업이 없다. · 검색어가 화면에 있음: Capa 1곳 |
| C-95595efe96 | SCREEN | B4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SSP0014 그리드에는 To Site 콤보와 City 컬럼이 없다. · 검색어가 화면에 있음: CITY 1곳 |
| C-ad0d968dae | SCREEN | F1 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SSP0014 에는 To Site 콤보와 City 컬럼이 없다. · 검색어가 화면에 있음: CITY 1곳 |
| C-34e1da29c8 | SCREEN | C4 | [DMF0082 결함 일반화] 그리드 Measure 필터(MEASURE Filter) × Division(DIVISION_ID) 변경 재조회 · 건수 표시 | SSP0014 그리드에는 Measure 컬럼과 Measure 필터가 없다. · 검색어가 화면에 있음: MEASURE 1곳, Measure 1곳 |
| C-477e43326c | SCREEN | M4 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME·PROJECT_STATUS·PROJECT_OWNER·BIZ_TYPE) · Model 팝업(ITEM_ID → | SSP0014 그리드에는 신규 행 Project 팝업·Sales Site 자동 채움이 없고, Model 팝업은 조회조건에만 있어 ITEM_TYPE 자동 채움이 없다. · 검색어가 화면에 있음: SCM_SITE_ID 1곳 |
| C-7285fb77af | SCREEN | MS1 | [DMF0014 결함 일반화] 공용 업로드 창(Upload) 검증 완료 후 저장 전 Cancel · X 닫기 확인창 MSG00684 「취소하시겠습니까?」(AS-IS MSG00195) | SSP0014 화면에는 공용 업로드 창 버튼이 없고(Search·Reset·Insert·Delete·Save·Excel·ItemId 만 있음), Upload·MSG00684·MSG00195 검색 결과가 0건이다. · 검색어가 화면에 있음: Upload 2곳, MSG00684 1곳, MSG00195 1곳 |
| C-a5da1b090a | SCREEN | I1 | [DMF0074 결함 일반화] 공용 Excel Upload 창 안내 메시지 MSG00657(오류 행 저장 차단) · MSG00658 · MSG00659 EN · CN 등록값(SCM_ADM_MSG_M) | SSP0014에는 공용 Excel Upload 창이 없습니다. TO-BE 화면에서 upload: false이고, AS-IS 소스에 업로드 호출이 없습니다. · 검색어가 화면에 있음: MSG00657 1곳, MSG00658 1곳, MSG00659 1곳 |
| C-b2053d63dd | SCREEN | M3 | [DMF0082 결함 일반화] Price Batch Input 팝업 Save 결과 판정(o_rc1 첫 행 RESULT_CODE ≠ '0' → RESULT_MSG 표시 · 창 유지) | SSP0014 에는 Price Batch Input 팝업 Save 가 없다. · 검색어가 화면에 있음: o_rc1 5곳 |
| C-a038d01fc3 | SCREEN | I2 | [DMF0043_01 결함 일반화] Version 팝업 미선택 OK 안내 — 다국어 코드 MSG00701(AS-IS MSG00279) 「버전은 1개만 선택해 주세요.」/「Please select only one ve | SSP0014에는 Version 선택 팝업이 없습니다. 팝업은 Model 검색과 사용자 선택(UserInfoPopup)만 있습니다. · 검색어가 화면에 있음: MSG00701 1곳, MSG00279 1곳 |
| C-9ffc7ae3e1 | SCREEN | MS1 | [DMF0043_01 결함 일반화] Version 팝업 미선택 OK 안내 — 다국어 코드 MSG00701(AS-IS MSG00279) 「버전은 1개만 선택해 주세요.」/「Please select only one ve | SSP0014 화면에는 Version 팝업이 없고, AS-IS 소스와 TO-BE 화면 폴더에서 MSG00279·MSG00701 검색 결과가 0건이다. · 검색어가 화면에 있음: MSG00279 1곳, MSG00701 1곳 |
| C-6409ae5865 | SCREEN | C2 | [결함 유형 묶음 C2-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | 이 화면 그리드에는 Measure 콤보가 없다. · 검색어가 화면에 있음: Measure 1곳 |
| C-d56389f431 | SCREEN | F1 | [결함 유형 묶음 F1-G03 · 2건] 신규 행 Insert 후 Save | SSP0014 의 Insert 는 AS-IS InsertButton 본문이 주석 처리되어 있고 TO-BE 는 insert=false 라 신규 행 Insert 후 Save 기능이 없다. · 검색어가 화면에 있음: InsertRow 2곳, addRow 2곳 |
| C-37428a9fdc | SCREEN | G5 | [결함 유형 묶음 G5-G01 · 3건] 팝업 Period 기본값(메인 Period 연동) | 이 화면에는 Period 조회조건과 Period 를 받는 팝업이 없다. · 검색어가 화면에 있음: FROM_YYYYMM 1곳 |
| C-8436f64f1b | SCREEN | G5 | [결함 유형 묶음 G5-G02 · 2건] 팝업 Spread 기간 컬럼 생성 | 기준 정리 답 없음(AI 꺼짐 또는 실패) — 화면 전체로 둠 |
| C-d81b46566f | SCREEN | M3 | [결함 유형 묶음 M3-G04 · 2건] 팝업 Period 기간별 월 컬럼 생성·조회 | SSP0014 팝업에는 Period 월 컬럼 조회가 없다. · 검색어가 화면에 있음: YYYYMM 1곳 |
| 실측 | SP:SQL: DECLARE @TRESULT TABLE( | - | 실측-파싱 대조 SQL: DECLARE @TResult TABLE( | AS-IS 1회 · TO-BE  · INLINE |
| 실측 | SP:SQL: SELECT * | - | 실측-파싱 대조 SQL: SELECT * | AS-IS 1회 · TO-BE  · INLINE |
| 실측 | SP:SSP0014_GET_USER_ID_CHECK | - | 실측-파싱 대조 SSP0014_GET_USER_ID_CHECK | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | SP:SSP0014_SAVE_SHIPMENT_MODEL_PIC | - | 실측-파싱 대조 SSP0014_SAVE_SHIPMENT_MODEL_PIC | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | (요소 없음) | - | 실측-파싱 대조 (선언 ↔ 실측) | AS-IS 23개 · TO-BE  · INFO |
| 실측 | (요소 없음) | - | 실측-파싱 대조 BaseRibbonCtl | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 Change | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cbo | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 chkAll | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clb | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 panel1 | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 pictureBox1 | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 pnlBaseForm | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 pnlMain | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 statusStripBaseForm | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 textBox1 | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 textBox2 | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtTextKeyin | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cboDivision | AS-IS Div* [필수] · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cboOperationGroup | AS-IS Operation Group · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clbFromSite | AS-IS From Site · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cboValidYN | AS-IS Valid · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtUser | AS-IS User ID(Name) · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnItemId | AS-IS layoutControlItem4 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtItemId | AS-IS Model · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 spdMain/Shipment Model PIC | AS-IS 컬럼 23(보임 21) · 헤더 1단 · 행 7667 · 고정 1 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 조회 인자 SSP0014_GET_SHIPMENT_MODEL_PIC.language | AS-IS KO · TO-BE CN · DIFF |
| 실측 | COL:USER_ID | - | 조회 인자 SSP0014_GET_SHIPMENT_MODEL_PIC.user_id | AS-IS  · TO-BE  · USER(비교 제외) |

## 대상 아님

| 기준 항목 | 규칙 | 확인 | 근거 |
|---|---|---|---|
| C-e2b1679914 | A1 | SSP0014 화면 | TO-BE 룰 CR-105: 값 불일치와 행·키 집합 차이는 판정에서 뺀다(해당없음으로 두고 근거를 표시한다). · SSP0014 화면 A1 항목은 행수·키 집합 비교이고, 이 비교는 차등 검증 판정에서 빠진다. |
| C-2509586288 | D6 | SSP0014 정렬 상태 Insert | TO-BE 룰 CR-070: AS-IS 가 기능 없는 버튼(override 본문 공백)을 일괄 노출해도 TO-BE 는 숨긴다(= PASS). · AS-IS InsertButton 본문이 주석이고 TO-BE hotkeyConfig 에서 insert 가 false 라 Insert 버튼이 숨겨지므로 Insert 행 Div·필터·정렬 확인은 대상이 아닙니다. |
| C-13830949a0 | D6 | SSP0014 필터 상태 Insert | TO-BE 룰 CR-070: AS-IS 가 기능 없는 버튼(override 본문 공백)을 일괄 노출해도 TO-BE 는 숨긴다(= PASS). · AS-IS InsertButton 본문이 주석이고 TO-BE hotkeyConfig 에서 insert 가 false 라 Insert 버튼이 숨겨지므로 Insert 행 Div·필터·정렬 확인은 대상이 아닙니다. |
| C-f4397771db | F5 | SSP0014 병합 셀 Delete 범위 | TO-BE 룰 CR-057: Active 컬럼으로 사용여부를 관리하는 화면은 Delete 시 신규행만 제거하고 기존행에 D Flag 를 표시하지 않는다 · SSP0014 는 Active(VALID_YN) 컬럼으로 사용여부를 관리하므로 기존행에 D Flag 를 표시하지 않고, 따라서 병합 셀 Delete 시 병합 전체 행 D 표시 항목은 확인 대상이 아니다. |
| C-ccf4904acd | I1 | SSP0014 시나리오 [자동] CN 언어 조회 건수 총/건 표기 | TO-BE 룰 DD-215: AS-IS: CN 언어 총/건 표기 검사 대상 → TO-BE: 검사 대상 제외(NA) · CN 언어 조회 건수 총/건 표기 시나리오는 사용자 결정으로 검사에서 제외됩니다. |
| C-401f266be3 | D4 | SSP0014 Insert 행 Division | TO-BE 룰 CR-070: AS-IS 가 기능 없는 버튼(override 본문 공백)을 일괄 노출해도 TO-BE 는 숨긴다(= PASS). · AS-IS InsertButton 본문이 주석이고 TO-BE hotkeyConfig 에서 insert 가 false 라 Insert 버튼이 숨겨지므로 Insert 행 Div·필터·정렬 확인은 대상이 아닙니다. |
| C-75a844f876 | K1 | SSP0014 필터 유지 재조회 | TO-BE 룰 DD-217: AS-IS: 화면별 검사 대상 → TO-BE: 검사 대상 제외(NA) · 사유 사용자 결정 2026-11-06(SCP0016 CheckList 11번) — 공통 기능(공용 DataGrid)이라 화면별 오류 아님 · 재조회 뒤 그리드 필터 유지 여부는 공용 DataGrid 기능이라 SSP0014 화면별 검사 대상에서 빠진다. |
| C-4d9f699a2d | K2 | 컬럼/Measure 셋팅(개인화 Default) | SSP0014 화면에는 컬럼/Measure 셋팅 팝업과 개인화 Default 기능이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-963abb1189 | C1 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | 이 화면의 조회조건은 Division·Operation Group·From Site·Model·User·Active 뿐이고 Sales Site·End Customer·Sold to·Team 콤보는 없다. · 검색어 End Customer, Sales Site, Sold to, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c532089eb8 | B8 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SSP0014 조회조건에는 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보가 없고, From Site 콤보만 있다. · 검색어 End Customer, END_CUSTOMER, Sold to Customer, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6d1b4fddfe | K2 | Measure 순서·메저셋팅 순서 저장 | SSP0014 화면에는 메저셋팅 순서를 저장하는 기능도, Measure 행도 없다. · 검색어 MeasureSetting, Measure Setting, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f7538e5e77 | J4 | Home / Auth Request 메뉴 | Home의 Auth Request 메뉴 화면은 SSP0014 Shipment Model PIC 화면에 없는 기능이다. · 검색어 Auth Request, AuthRequest, AUTH_REQUEST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5e27e0531a | A7 | RTF Measure 금액(AMT) 계산 시 적용 LOC(판가) 기준(RTF · AMT · LOC) | SSP0014에는 RTF Measure와 AMT 금액 계산 기능이 없다. · 검색어 RTF, AMT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8a2ce2679f | H6 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | Model(ITEM_ID) 컬럼은 잠금(S) 컬럼이라 그리드 셀 팝업이 없고, 셀 더블클릭 팝업은 User ID 계열 8개 컬럼에만 있습니다. · 검색어 e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID), ItemCellPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d2e0a5446f | A5 | [SYS0002 결함 유형] User 화면 Group 컬럼 | SSP0014 그리드에는 사용자 Group 컬럼이 없다. · 검색어 DEFAULT_GROUP, Default Group, GROUP_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-10f077fb2b | B6 | [DMF0043_01 결함 유형] 조회조건 Product Group·Biz Type | SSP0014에는 Product Group·Biz Type 조회조건이 없다. · 검색어 Product Group, PRODUCT_GROUP, Biz Type, BIZ_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4f96d5a31a | G2 | [DMF0043_01 결함 유형] 조회조건 Product Group·Biz Type | SSP0014 조회조건은 Div·Operation Group·From Site·Active·Model/Nickname·User ID(Name)이며 Product Group·Biz Type 조회조건은 없다. · 검색어 PRODUCT_GROUP, BIZ_TYPE, Product Group, Biz Type: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-66334c0f85 | B4 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | SSP0014 그리드에는 Sales Site 셀 콤보가 없다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7bac7b2beb | F1 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | SSP0014 그리드에는 Sales Site 셀 콤보가 없다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7f76a9b0c6 | F2 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | 이 화면에는 Sales Site 셀 콤보가 없고, 저장 성공 후 DB 반영은 C-9dd2b075f1 이 이미 확인한다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c00525ecf4 | B5 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_MST_CUSTOMER_FCST(_C/_H).MEASURE | SSP0014 화면에는 Measure 콤보(CUST_FCST_MEASURE)가 없다. · 검색어 CUST_FCST_MEASURE, Customer FCST, Cutomer FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-dd662802f3 | N1 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_MST_CUSTOMER_FCST(_C/_H).MEASURE | SSP0014에는 Measure Combo(CUST_FCST_MEASURE)가 없습니다. · 검색어 CUST_FCST_MEASURE, Cutomer FCST, Customer FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-18e3436478 | M3 | [DMF0005 결함 유형] Team 팝업 | SSP0014 에는 Team 팝업이 없고 TEAM_LEADER 컬럼은 User 팝업을 연다. · 검색어 TeamPopup, DeptPopup, SSO_DEPT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e5ffc94fa4 | G5 | [DMF0005 결함 유형] Team 팝업 | 이 화면에는 Team 팝업이 없고, 셀 팝업은 UserInfoPopup 만 쓴다. · 검색어 TeamPopup, SSO_DEPT, DeptPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7528eeb237 | C3 | [DMF0005 결함 유형] Team·Owner 컬럼 | SSP0014 그리드에는 Team·Owner 컬럼이 없고, 담당자 컬럼은 USER_ID·PART_LEADER·TEAM_LEADER·MAIL_USER1~5 이다. · 검색어 OWNER, Owner, TEAM_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-be75ce6f4e | F6 | [DMF0005 결함 유형] Team·Owner 컬럼 | SSP0014 에는 Owner 컬럼과 Owner 선택 시 Team 을 채우는 동작이 없고, 비슷한 컬럼은 TEAM_LEADER 뿐이다. · 검색어 OWNER, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4d7ef53731 | F1 | [DMF0005 결함 유형] 하단 Purchase 탭 EDI Incoterms | SSP0014 에는 하단 Purchase 탭과 EDI Incoterms 컬럼이 없다. · 검색어 INCOTERMS, EDI Incoterms, Purchase: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-bf6601dfda | E3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | SSP0014 그리드에는 Team 팝업 컬럼과 Project 컬럼이 없다. · 검색어 TEAM_CD, PROJECT_CD, PROJECT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-93d00d2e89 | F3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | 이 화면에는 Team 팝업 컬럼과 Project 컬럼이 없다(팝업 컬럼은 User ID·Part Leader·Team Leader 이고, 키인과 팝업을 함께 허용한다). · 검색어 TEAM_ID, PROJECT_ID, Team Code: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6a4de6b606 | D1 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | 이 화면에는 Team 팝업 컬럼과 Project 컬럼이 없고, 팝업 컬럼은 USER_ID·PART_LEADER·TEAM_LEADER·MAIL_USER1~5뿐이다. · 검색어 TEAM_CD, PROJECT_CD, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0d83727b59 | B4 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SSP0014 화면에는 Team 조회조건과 Team·End Customer·Sales Site 그리드 콤보가 없다. · 검색어 END_CUSTOMER, SALES_SITE, TeamByDivision: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-310e6f1965 | B2 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SSP0014에는 조회조건 Team과 그리드 End Customer·Sales Site 콤보가 없고, 조회조건은 Div·Operation Group·From Site·Active로 구성된다. · 검색어 END_CUSTOMER, SALES_SITE, Sales Site, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-1fc5a98102 | B8 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SSP0014에는 Team 조회조건이나 그리드 Team·End Customer·Sales Site 콤보가 없다. · 검색어 DEPT_ID, End Customer, END_CUSTOMER, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4c787eb3ba | N1 | [DMF0020 결함 유형] Exchange Rate 팝업 · DM_MST_EXCHANGE_RATE | SSP0014에는 Exchange Rate 팝업과 Period 기간 컬럼이 없습니다. · 검색어 Exchange Rate, EXCHANGE_RATE, DM_MST_EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-cc3511bc3f | D2 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | 이 화면에는 Monthly Bucket 입력과 Project Code 팝업이 없다. · 검색어 MONTHLY, BUCKET, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-12f6a4de0b | F6 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SSP0014 는 담당자 지정 화면이라 Monthly Bucket 입력과 Project Code 팝업이 없다. · 검색어 Monthly, BUCKET, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-caa4316c54 | F4 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SSP0014 에는 Monthly Bucket 입력과 Project Code 팝업이 없다. · 검색어 Monthly, Bucket, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f69d225d12 | M3 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SSP0014 화면에는 Monthly Bucket 입력 컬럼과 Project Code 팝업이 없고, AS-IS 소스와 TO-BE 화면 폴더에서 Monthly·Bucket·PROJECT_CODE 검색 결과가 0건이다. · 검색어 Monthly, Bucket, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-cf8ebb5e52 | A2 | [DMF0020 결함 유형] 조회 건수 · Team 컬럼 표시 · 컬럼팝업 저장 설정 | SSP0014 에는 Name 으로 표시할 Team(DEPT_ID) 컬럼이 없고, 컬럼 설정 팝업도 AS-IS·TO-BE 모두 없다. · 검색어 DEPT_ID, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8e0daf8b48 | K2 | [DMF0020 결함 유형] 조회 건수 · Team 컬럼 표시 · 컬럼팝업 저장 설정 | SSP0014 화면에는 컬럼팝업 저장 설정과 Team 컬럼이 없고 컬럼 목록은 고정 21열이다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-cee2dd92f1 | J2 | [DMF0020 결함 유형] Price Batch Input 버튼 | SSP0014 에는 Price Batch Input 버튼이 없습니다. · 검색어 Price Batch Input, btnPriceBatch, PRICE_BATCH: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-57b850a666 | K4 | [DMF0020 결함 유형] Price Batch Input 버튼 | 이 화면에는 Price Batch Input 버튼이 없다. · 검색어 Price Batch Input, PriceBatch, btnPriceBatch: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-070df1a18c | G4 | [DMF0020 결함 유형] 조회조건 Project | 이 화면 조회조건에는 Project 가 없고, txtProject 는 주석 처리되어 있다. · 검색어 cboProject, lblProject: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a3a76374ce | G4 | [DMF0068 결함 유형] Main Version 조회조건 크기 · Version 팝업 Description 컬럼 폭 | 이 화면에는 Main Version 조회조건과 Version 팝업이 없다. · 검색어 Version, cboVersion, Main Version: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2ea88bd889 | H6 | [DMF0068 결함 유형] Main Version 조회조건 크기 · Version 팝업 Description 컬럼 폭 | 이 화면 조회조건과 팝업에는 Main Version 조회조건과 Version 팝업 Description 컬럼이 없습니다. · 검색어 Main Version, VersionPopup, Version 팝업: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8ee5fd015a | B4 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer 콤보 | SSP0014 그리드에는 End Customer·Sold to Customer 콤보가 없다. · 검색어 END_CUSTOMER, SOLD_TO, Sold to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-33433f6866 | B7 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer 콤보 | SSP0014 그리드에는 End Customer·Sold to Customer 콤보가 없다. · 검색어 End Customer, END_CUSTOMER, Sold to Customer, SOLD_TO: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ca79a11452 | C2 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | 이 화면 그리드에는 Cust Group·End Customer·Sales Site 컬럼이 없다. · 검색어 Cust Group, End Customer, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d462d51f84 | B2 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | SSP0014 그리드에는 Cust Group→End Customer→Sales Site 연쇄 콤보가 없다. · 검색어 CUST_GROUP, Cust Group, END_CUSTOMER: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a03f83de16 | K1 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | SSP0014 그리드에는 Cust Group·End Customer·Sales Site 연쇄 콤보 컬럼이 없다. · 검색어 CUST_GROUP, Cust Group, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-35b27ab0b4 | E4 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Active 컬럼 | SSP0014에는 Cust Group·End Customer·Sales Site 관계 컬럼이 없습니다. · 검색어 End Customer, CUST_GROUP, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a242d1d54c | C2 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Active 컬럼 | 이 화면에는 Cust Group·End Customer·Sales Site 관계 컬럼이 없다. · 검색어 Cust Group, End Customer, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-05b6133303 | B4 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | SSP0014에는 Team·End Customer·Sales Site 후보 콤보가 없다. · 검색어 DEPT_ID, END_CUSTOMER, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f8e15e7855 | M1 | [DMF0014 결함 유형] Excel Form 입력 버킷 | SSP0014 has no Excel Form or Period search condition, so the input bucket check has no target. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-03f5e80da0 | G5 | [DMF0014 결함 유형] Excel Form 입력 버킷 | 이 화면에는 Excel Form 입력 버킷과 Main Period 조회조건이 없다. · 검색어 Bucket, Period, ExcelUpload: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-79c4eddcb2 | M1 | [DMF0014 결함 유형] Excel Form 양식 | SSP0014 has only the grid Excel download (excelFileName='ShipmentModelPic') and has no Excel Form button. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e5ef51c16a | H2 | [DMF0003 결함 일반화] 실적 구간 배경색 | Shipment Model PIC 그리드에는 편집 불가 과거 기간(실적 구간) 셀이 없다. · 검색어 ACTUAL, ACT_FLAG: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-bd163eb30b | D2 | [DMF0003 결함 일반화] 실적 구간 배경색 | 이 화면에는 기간 Bucket이 없어 실적 구간 셀도 없다. · 검색어 BUCKET, ACTUAL: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ae1cf826fa | C2 | [DMF0003 결함 유형] AS From Site 입력 후 W35~W38 수량 | 이 화면에는 AS From Site 컬럼과 주차별 수량 컬럼이 없다. · 검색어 AS From Site, AS_FROM_SITE, W35: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f3e70ffd12 | B8 | [DMF0003 결함 일반화] Team 컬럼(MKT FCST 조회·신규행) | SSP0014 그리드에는 SSPM DEPT_ID 기준 Team 컬럼이 없다. · 검색어 DEPT_ID, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-19b54a62a3 | A2 | [DMF0003 결함 일반화] Team 컬럼(MKT FCST 조회·신규행) | SSP0014 에는 SSPM DEPT_ID 로 표시하는 Team 컬럼이 없고, TEAM_LEADER 컬럼은 사용자 ID 다. · 검색어 DEPT_ID, SSPM, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e6aa3e29ab | B5 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | SSP0014 화면에는 FCST Type 콤보와 Measure 입력이 없다. · 검색어 FCST_TYPE, FCST Type: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0fd2bb4925 | D3 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | SSP0014 에는 FCST Type 콤보와 Measure 입력 기능이 없습니다. · 검색어 FCST Type, FCST_TYPE, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-298ab92704 | A5 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SSP0014에는 컬럼셋팅의 VERSION 컬럼과 AS FROM SITE 컬럼이 없다. · 검색어 AS_FROM_SITE, AS FROM SITE, ColumnSetting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d39cfff34c | K2 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SSP0014 화면에는 컬럼셋팅 목록이 없고 VERSION 컬럼과 AS FROM SITE 컬럼도 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅, AS FROM SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d5f84ced7f | N1 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SSP0014에는 컬럼셋팅 기능과 AS FROM SITE 컬럼이 없습니다. · 검색어 AS_FROM_SITE, AS From Site, ColumnSetting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0240a74047 | E1 | [DMF0082 결함 유형] MKT_FCST[R+P]·AS_In_Request[R+P]·Unit_Price(LOC) | SSP0014 그리드에는 MKT_FCST·AS_In_Request·Unit_Price(LOC) 컬럼이 없다. · 검색어 MKT_FCST, AS_IN_REQUEST, Unit_Price(LOC): AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ddf58b6541 | M3 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | SSP0014 에는 Price Batch Input 팝업과 End Customer 컬럼이 없다. · 검색어 Price Batch, PriceBatch, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d73079e62a | H3 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | 이 화면에는 Price Batch Input 팝업과 End Customer 컬럼이 없고, 다른 화면(DMF0082)의 결함 유형입니다. · 검색어 Price Batch Input, END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f910c945ec | G4 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | 이 화면에는 Price Batch Input 팝업과 End Customer 컬럼이 없다. · 검색어 PriceBatch, Price Batch Input: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5076ca2569 | M3 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SSP0014 에는 Exchange Rate 팝업 저장 기능이 없다. · 검색어 Exchange Rate, ExchangeRate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0b563961be | F4 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SSP0014 에는 Exchange Rate 팝업이 없다. · 검색어 Exchange Rate, ExchangeRate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-63705b04f7 | F3 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | 이 화면에는 Exchange Rate 팝업과 그 저장 기능이 없다. · 검색어 Exchange Rate, EXCHANGE_RATE, ExchangeRate: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-74e17bfa04 | F1 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SSP0014 에는 Exchange Rate 팝업이 없다. · 검색어 EXCHANGE_RATE, Exchange Rate: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-eda1aa5794 | M2 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | SSP0014 화면에는 BPS I/F 버튼과 환율 반영 기능이 없고, Last Update Date와 Last Update By 컬럼만 있습니다. · 검색어 BPS I/F, BpsIf, 반영할 환율 정보가 없습니다: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-54e06d7395 | F1 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | 이 화면에는 BPS I/F 버튼과 환율 반영 기능이 없다. · 검색어 BPS, Exchange Rate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b46e6db298 | A5 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | SSP0014에는 BPS I/F 버튼과 환율 반영 기능이 없고, Last Update Date와 Last Updated By 컬럼 표시는 Division별 컬럼 기준 항목에서 확인한다. · 검색어 BPS, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b13579dc51 | E4 | [DMF0082 결함 유형] Biz Type 미존재 검증 팝업 메시지 | SSP0014에는 Biz Type 미존재 검증이 없습니다. · 검색어 Biz Type, BIZ_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-cf0d9db58f | E1 | [DMF0082 결함 유형] QTY ≥ 0 검증 | SSP0014 그리드에는 수량(QTY) 컬럼이 없다. · 검색어 QTY, Quantity: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8fab94deba | F6 | [DMF0082 결함 일반화] 필수 컬럼(Project Code·Plant Site) 표시 · 저장 | SSP0014 에는 Project Code·Plant Site 필수 컬럼과 Div 별 개인화 구성이 없다. · 검색어 PROJECT_CODE, PLANT_SITE, Project Code, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e7d9097d15 | A5 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SSP0014에는 Measure 셋팅과 VMI 및 MKT FCST AMT 메저가 없다. · 검색어 VMI, MKT FCST AMT, MKT_FCST_AMT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-79dc046d97 | K2 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SSP0014 화면에는 Measure 셋팅이 없고 VMI 메저나 MKT FCST AMT 메저도 없다. · 검색어 MKT FCST, VMI, MeasureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9413dad207 | N1 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SSP0014에는 Measure 셋팅(VMI 메저·MKT FCST AMT)이 없습니다. · 검색어 VMI In Request, MKT FCST AMT, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-1d1554a544 | B5 | [DMF0082 결함 유형] SCM_FCST·MKT_FCST 편집 구간(GET_ADMIN_GROUP_MEASURE) | SSP0014 화면에는 SCM_FCST·MKT_FCST 편집 구간이 없다. · 검색어 SCM_FCST, MKT_FCST, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6e126a6445 | N1 | [DMF0007 결함 유형] Customer FCST Master 기준정보 | SSP0014에서는 Customer FCST Master 기준정보를 조회하지 않습니다. · 검색어 Customer FCST, CUSTOMER_FCST, DM_MST_CUSTOMER_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d4de33c049 | A1 | [DMF0007 결함 유형] Customer FCST Master 기준정보 | SSP0014 는 Shipment Model PIC 담당자를 관리하는 화면이고, Customer FCST Master 기준정보를 조회하지 않는다. · 검색어 Customer FCST, FCST Master, CUST_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4e2351b5bd | B4 | [DMF0004 결함 유형] Sales Site 조회조건 표시값 | SSP0014 화면에는 Sales Site 조회조건이 없다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f42d2190aa | C2 | [DMF0005 결함 일반화] Sales Company·Sales Plant 셀 | 이 화면 그리드에는 Sales Company·Sales Plant 셀이 없다. · 검색어 Sales Company, Sales Plant, SALES_COMPANY, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-19ee79731a | F4 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | SSP0014 에는 RTF×Unit Price 계산값 컬럼이 없다. · 검색어 Unit Price, UNIT_PRICE, RTF: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b49bc781b0 | E1 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | SSP0014 그리드에는 RTF·Unit Price 같은 수치 계산 컬럼이 없고 USER_ID·MAIL_USER1~5 같은 문자 컬럼만 있다. · 검색어 RTF, UNIT_PRICE, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c2657186d3 | E4 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | SSP0014에는 RTF×Unit Price 계산값 컬럼과 자릿수 초과 메시지가 없습니다. · 검색어 Unit Price, RTF, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-af3d92a319 | K4 | [DMF0020 결함 일반화] Condition(F6) 저장 · Sales Report ETC Insert 기능 | 이 화면 조회조건(Div·From Site·Model/Nickname·User·Active 등)에는 Period 조건이 없다. · 검색어 Period, FromDate, ToDate, dtpFrom: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-09fd7997a1 | E4 | [DMF0044 결함 유형] Cell Prod Site 검증 · Application Gr·Country Name | SSP0014에는 Cell Prod Site·Application Gr·Country Name 컬럼이 없습니다. · 검색어 Cell Prod Site, Application Gr, Country Name: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-078ec3d526 | F1 | [DMF0044 결함 유형] Cell Prod Site 검증 · Application Gr·Country Name | SSP0014 에는 Cell Prod Site·Application Gr·Country Name 컬럼이 없다. · 검색어 CELL_PROD_SITE, Cell Prod Site, Application Gr: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-30def85d32 | C1 | [DMF0044 결함 유형] 조회조건 Report Type→Data Type | 이 화면에는 Report Type·Data Type 조회조건이 없다. · 검색어 Report Type, Data Type, cboReportType: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3bf6154e35 | K4 | [DMF0044 결함 유형] Delete 버튼 | 이 화면에는 Cutoff Data 구분에 따라 Delete 버튼을 숨기는 기능이 없다. · 검색어 Cutoff, CUTOFF_YN, CutOff: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-517a3e680f | J2 | [DMF0044 결함 유형] Delete 버튼 | SSP0014 에는 Cutoff Data 구분이 없어서 Cutoff 상태에 따라 Delete 버튼을 숨기는 조건이 적용되지 않습니다. · 검색어 Cutoff, CUTOFF, CUT_OFF: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c570c4f92b | F1 | [DMF0044 결함 유형] Biz Plan Cutoff Data 저장 값 | SSP0014 에는 Biz Plan Cutoff Data 값 저장 기능이 없다. · 검색어 Biz Plan, BIZ_PLAN, Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9b1078b000 | D2 | [DMF0044 결함 유형] 입력 가능 Measure(Business Plan·Unit Price(LOC)) | 이 화면에는 Business Plan·Unit Price(LOC) Measure가 없다. · 검색어 Business Plan, BUSINESS_PLAN, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c2bb532a2d | G5 | [DMF0044 결함 유형] Version 팝업 Div 조건 | 이 화면에는 Version 팝업이 없다. · 검색어 VersionPopup, VERSION_ID, cboVersion: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c598f99de0 | E4 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | SSP0014는 단일 그리드(spdMain)이며 하단 Owner 그리드가 없습니다. · 검색어 Owner, OWNER_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-bca30d3877 | F1 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | 이 화면에는 상단·하단 그리드 구조와 Owner 다건 등록 그리드가 없다. · 검색어 Owner, OWNER_ID, spdDetail: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-671fd75e1b | C5 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | SSP0014 에는 하단 그리드와 Owner 컬럼이 없고, 상단 그리드를 더블클릭해 하단을 조회하는 기능도 없다. · 검색어 OWNER, Owner, spdSub, spdDetail: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ced992d3a3 | D1 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | 이 화면에는 Exchange Rate의 Currency 컬럼이 없다. · 검색어 CURRENCY, EXCHANGE_RATE, Exchange Rate, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3315ddb53e | E4 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | SSP0014에는 Exchange Rate 화면의 Currency 컬럼이 없습니다. · 검색어 Exchange Rate, Currency, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4d8a2b11ee | D6 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | SSP0014 에는 Exchange Rate Currency 컬럼이 없습니다. · 검색어 Exchange Rate, Currency, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-df62a0e167 | G4 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | 이 화면 조회조건에는 Cust Group 이 없다. · 검색어 CustGroup, Cust Group, cboCustGroup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-01ca9a4287 | G1 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | SSP0014 조회조건은 Div, Operation Group, From Site, Active, Model/Nickname, User ID(Name)이고 Cust Group 조회조건이 없다. · 검색어 CUST_GROUP, Cust Group, cboCustGroup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-439f6a7d62 | M2 | [DMF0042 결함 유형] Replace 버튼 팝업 Period·조회 | SSP0014 화면 버튼은 SEARCH, INSERT, DELETE, SAVE, EXCEL, RESET, ITEMID이고, Replace 버튼과 Replace 팝업은 없습니다. · 검색어 btnReplace, ReplacePopup, Replace Period: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ef06920634 | G5 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | 이 화면에는 Ver.Cutoff 팝업이 없다. · 검색어 Cutoff, VersionPopup, VER_CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-098f10f7d6 | G4 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | 이 화면에는 Ver.Cutoff 팝업과 Period·Type 조회조건이 없다. · 검색어 Cutoff, Ver.Cutoff, VerCutoff: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-be938a23bc | H6 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | 이 화면에는 Ver.Cutoff 팝업이 없습니다. · 검색어 Cutoff, Ver.Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-731ac24b45 | H4 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | SSP0014에는 Ver.Cutoff 팝업이 없다. · 검색어 Cutoff, Ver.Cutoff, VER_CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-13d0dbfaa2 | M3 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SSP0014 에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 Version Create, BP Version, btnVersionCreate: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b7998d5c08 | M2 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SSP0014 화면에는 BP Version 팝업과 Version Create 기능이 없습니다. · 검색어 BP Version, Version Create, VersionCreate: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3ad432c72d | E4 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SSP0014에는 BP Version 팝업과 Version Create 기능이 없습니다. · 검색어 Version Create, BP Version: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-48f8fff3c2 | F1 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SSP0014 에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 Version Create, BP Version, CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-884764b3e3 | B3 | [DMF0049 결함 유형] 버전 팝업 Version 목록 정렬 | SSP0014에는 버전 팝업과 Version 목록이 없다. · 검색어 VERSION_ID, Version: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-621d850725 | M3 | [DMF0049 결함 유형] 버전 팝업 Version 목록 정렬 | SSP0014 에는 버전 팝업이 없다. · 검색어 VersionPopup, cboVersion: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2eedc19855 | G4 | [DMF0049 결함 유형] Version 조회조건 선택값 표시 | 이 화면 조회조건에는 Version 이 없다. · 검색어 Version, cboVersion, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-87b88cc85f | G7 | [DMF0049 결함 유형] Version 조회조건 선택값 표시 | 이 화면에는 Version 조회조건이 없다. · 검색어 cboVersion, VersionName, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-1bdb481612 | B4 | [DMF0014 결함 유형] Team 조회조건 후보 | SSP0014에는 Team 조회조건이 없다. · 검색어 cboTeam, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2b53c4fc59 | J1 | [DMF0014 결함 유형] Team 조회조건 후보 | SSP0014 조회조건에는 Team 콤보가 없고 Div·Operation Group·From Site·Model/NickName·User ID·Active 만 있습니다. · 검색어 cboTeam, TEAM_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9d0a43c974 | G1 | [DMF0020 결함 유형] Biz.Type 조회조건 | SSP0014 에는 Biz.Type 조회조건이 없다. · 검색어 BIZ_TYPE, Biz.Type, Biz Type: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a101945849 | M3 | [DMF0020 결함 유형] Price Batch Input 팝업 Sales Site 조건 | SSP0014 에는 Price Batch Input 팝업이 없다. · 검색어 Price Batch, PriceBatch, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ec35b36205 | F4 | [DMF0014 결함 유형] Excel Upload OK·Customs Handbook/Project/Model 검증 | SSP0014 에는 Excel Upload 기능과 Customs Handbook/Project 입력 항목이 없고, TO-BE 에서도 upload 가 false 로 설정되어 있다. · 검색어 Customs Handbook, CUSTOMS_HANDBOOK, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b4b26fc077 | E3 | [DMF0014 결함 유형] Excel Upload OK·Customs Handbook/Project/Model 검증 | SSP0014에는 Excel Upload 기능과 Customs Handbook 컬럼이 없고, Excel 버튼은 다운로드 전용이다. · 검색어 Customs Handbook, CUSTOMS_HANDBOOK, HANDBOOK: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-406e394068 | M1 | [DMF0014 결함 유형] Excel Upload 수량 미입력 메시지 | SSP0014 has no Excel Upload or quantity column, so the missing-quantity message has no target. · 검색어 ExcelUpload, Excel Upload, Please Input QTY: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c60f9a6536 | M1 | [DMF0014 결함 일반화] Excel Upload Validation 메시지(Sales Site/Project/Model) | SSP0014 has no Excel Upload feature, so the per-row validation messages have no target. · 검색어 ExcelUpload, Excel Upload, Invalid Column Header Title: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a29089c958 | M1 | [DMF0074 결함 유형] Excel Form 양식 헤더 | SSP0014 has no Excel Form template to download, so the Excel Form 2-row header check has no target. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-59a28158e8 | M1 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Validation 메시지 | SSP0014 sets upload: false in SubTitle and has no Excel Upload feature. · 검색어 ExcelUpload, Excel Upload, Invalid Column Header Title: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-bc5a1f73c7 | F1 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Validation 메시지 | SSP0014 에는 Excel Upload 와 Period From/To 컬럼이 없다(TO-BE upload=false). · 검색어 Excel Upload, PERIOD_FROM, Period From: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-034c5c8bd0 | M1 | [DMF0082 결함 유형] Excel Form 양식 Bucket | SSP0014 has no Excel Form template, so the Monthly bucket check has no target. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8e8ff2496f | D1 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | 이 화면에는 ETC 입력의 Team·Measure 컬럼이 없다. · 검색어 MEASURE_CD, SALES_AMT, Sales AMT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-733d61b9f8 | E3 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SSP0014 그리드에는 ETC 입력 Team 콤보나 Measure(Sales AMT(LOC)) 컬럼이 없다. · 검색어 SSPM, Sales AMT(LOC), SALES_AMT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d1ecd81aff | D4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SSP0014 에는 ETC 입력 Team 컬럼과 Sales AMT Measure 가 없습니다. · 검색어 Sales AMT, SALES_AMT, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-948efaf742 | A1 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | SSP0014 에는 Dynamic Query 기능이나 ESS KWh 판가 계산이 없다. · 검색어 Dynamic Query, KWh, DYNAMIC_QUERY: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ccb8ada0ba | H4 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | SSP0014에는 Dynamic Query 기능이 없다. · 검색어 DynamicQuery, Dynamic Query, KWh: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-be9c0e2a79 | F4 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | SSP0014 에는 Dynamic Query 나 ESS KWh 판가 계산 기능이 없다. · 검색어 Dynamic Query, DynamicQuery, KWh: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4c966a59a6 | F8 | [SYS0012 결함 유형] Request 데이터 Reject Reason·Request Date | SSP0014 에는 재요청 절차와 Reject Reason·Request Date 컬럼이 없다. · 검색어 REJECT_REASON, Reject Reason, Request Date: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-1f6dff3c46 | B4 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SSP0014에는 Approval Result 조회조건이 없다. · 검색어 Approval Result, APPROVAL_RESULT, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d2a1c13840 | B6 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SSP0014에는 Approval Result 조회조건이 없다. · 검색어 Approval Result, APPROVAL_RESULT, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fbf2453084 | I2 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SSP0014에는 Approval Result 조회조건 콤보가 없습니다. · 검색어 APPROVAL_RESULT, Approval Result, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2c40631efa | G4 | [DMF0040 결함 유형] Version 조회조건 크기 | 이 화면 조회조건에는 Version 이 없다. · 검색어 Version, cboVersion, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9d57c4b73d | H5 | [DMF0040 결함 유형] Measure Version(A)/Version(B) 명칭 | SSP0014 화면에는 Version(A)/Version(B) Measure 비교 기능이 없어 DMF0040 결함 유형의 대상이 아니다. · 검색어 Version(A), Version(B), VERSION_A, VERSION_B: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8add48fad3 | A9 | [DMF0040 결함 유형] Measure Version(A)/Version(B) 명칭 | SSP0014에는 Version(A)/Version(B) Measure가 없다. · 검색어 Version(A), VERSION_A, Version(B): AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7663c454da | H2 | [DMF0040 결함 유형] 실적 구간 배경색 | Shipment Model PIC 그리드는 담당자 마스터라 실적·계획 구간 컬럼이 없다. · 검색어 ACTUAL, ACT_FLAG: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5da3fcb6a8 | K2 | [DMF0042 결함 유형] Column Setting 팝업 Default 버튼 | SSP0014 화면에는 Column Setting 팝업과 그 팝업의 Default 버튼이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-1180eab86a | C3 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | SSP0014 그리드에는 Sales Site·End Customer 셀이 없다. · 검색어 END_CUSTOMER, End Customer, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d3f0363e1b | D1 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | 이 화면에는 Sales Site·End Customer 셀이 없다. · 검색어 END_CUSTOMER, SALES_SITE_ID, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5460af15d2 | G4 | [DMF0044 결함 유형] Year 조회조건 | 이 화면 조회조건에는 Year 가 없다. · 검색어 Year, cboYear: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fa5df3d224 | G6 | [DMF0044 결함 유형] Year 조회조건 | 이 화면에는 Year 조회조건이 없다. · 검색어 cboYear, Year, PLAN_YEAR: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4c94f59516 | A5 | [DMF0044 결함 유형] Measure 항목 구성 | SSP0014는 컬럼 21개가 고정된 그리드이고 Measure 항목이 없어서 UI Category 기준 Measure 구성은 대상이 아니다. · 검색어 UI_CATEGORY, MEASURE_CD, MEASURE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e3f289acbb | B5 | [DMF0044 결함 유형] Measure 항목 구성 | SSP0014 화면에는 Measure 항목이 없다. · 검색어 UI_CATEGORY, SCM_FCST, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7a9581deec | M3 | [DMF0005 결함 유형] Owner 팝업 사용자 목록 | SSP0014 에는 Owner 팝업이 없고 사용자 선택은 UserInfoPopup 으로 한다. · 검색어 OwnerPopup, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7c7f5e83f1 | D2 | [DMF0021 결함 유형] Partial 주차 편집 구간·실적 구분선 | 이 화면에는 주차 Bucket과 Partial 주차 편집 구간이 없다. · 검색어 PARTIAL_WEEK, BUCKET, Partial Week: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c0a05cf764 | H2 | [DMF0021 결함 유형] Partial 주차 편집 구간·실적 구분선 | 이 화면에는 주차별 파셜 편집 구간과 실적 구분선이 없다. · 검색어 실적 구분선, PARTIAL_WEEK: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a2198cb396 | A5 | [DMF0003 결함 유형] Measure 컬럼 | SSP0014 그리드에는 Measure 컬럼과 Measure 설정이 없다. · 검색어 MEASURE_ID, MEASURE_CODE, USER_SELECTED_FLAG: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-aa59955b3e | J1 | [DMF0003 결함 유형] FCST Type 후보 | SSP0014 에는 FCST Type 조회조건이 없습니다. · 검색어 FCST_TYPE, FCST Type, cboFcstType: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4285c3c6ae | G2 | [DMF0040 결함 유형] End Customer 다중 선택 조회조건 | SSP0014 조회조건에 End Customer 다중 선택 조건이 없다. · 검색어 END_CUSTOMER, clbEndCustomer, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-03991b9c3b | I3 | [DMF0040 결함 유형] Team 조회조건 vs 결과 컬럼 언어 | SSP0014에는 Team 조회조건이 없고, Team 명 결과 컬럼도 없습니다. · 검색어 TEAM_NAME, TEAM_CD, cboTeam: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-abc8e58335 | K2 | [DMF0040 결함 유형] Column Setting 저장·Default | SSP0014 화면에는 Column Setting 팝업이 없어서 저장 후 새 탭 유지와 Default 복원 기능이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4b24926a05 | A5 | [DMF0040 결함 유형] Column Setting 저장·Default | SSP0014에는 Column Setting 저장과 Default 기능이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-10e0ee3fff | G4 | [DMF0040 결함 유형] Ver. 조회조건 기본값 | 이 화면 조회조건에는 Ver. 이 없다. · 검색어 Version, cboVersion, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-585a67b9f4 | G6 | [DMF0040 결함 유형] Ver. 조회조건 기본값 | 이 화면에는 Ver. 조회조건이 없다. · 검색어 cboVersion, VERSION_ID, Version: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-46b86532f9 | G1 | [DMF0040 결함 유형] Plant Site 조회조건 | SSP0014 에는 Plant Site 조회조건이 없다. · 검색어 PLANT_SITE, Plant Site, cboPlantSite: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-65dd78d70e | K2 | [DMF0040 결함 유형] Measure Setting 버튼 | SSP0014 화면에는 AS-IS·TO-BE 모두 Measure Setting 버튼이 없다. · 검색어 MeasureSetting, Measure Setting, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b714f7f619 | J2 | [DMF0040 결함 유형] Measure Setting 버튼 | SSP0014 에는 Measure Setting 버튼이 없습니다. · 검색어 Measure Setting, btnMeasureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e18ae6f76a | G4 | [DMF0040 결함 유형] Plant Site 조회조건 | 이 화면에는 Plant Site 조회조건이 없고 From Site(clbFromSite)만 있다. · 검색어 Plant Site, cboPlantSite, plantSiteId: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7122687771 | A5 | [DMF0053 결함 일반화] Column Setting 필수 컬럼 표시·Div 전환 End Customer | SSP0014에는 컬럼셋팅 팝업이 없어 필수 컬럼을 빨간색으로 표시하거나 해제를 막는 동작이 없다. · 검색어 ColumnSetting, 컬럼셋팅, USER_SELECTED_FLAG: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5617f7280d | B4 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | SSP0014에는 Biz Type 조회조건이 없다. · 검색어 Biz Type, BIZ_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b2bf887477 | G1 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | SSP0014 에는 Biz Type, Plant Site 조회조건이 없다. · 검색어 BIZ_TYPE, Biz Type, PLANT_SITE, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3e8f8c996a | D2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | 이 화면에는 MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req Measure가 없다. · 검색어 MKT_FCST, AS_In_Req, VMI_In_Req: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-23dc16cad1 | J3 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SSP0014 에는 Current 버전 입력 Measure(MKT_FCST·SCM_FCST·AS_In_Req·VMI_In_Req)와 AS From Site 콤보가 없습니다. · 검색어 AS_In_Req, VMI_In_Req, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e6605bd1f3 | D3 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SSP0014 에는 Current 버전 입력 Measure 와 AS From Site 콤보가 없습니다. · 검색어 SCM_FCST, AS_In_Req, GET_ADMIN_GROUP_MEASURE, AS From Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-eafcd56476 | B5 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SSP0014 화면에는 Measure 입력과 AS From Site 콤보가 없다. · 검색어 MKT_FCST, SCM_FCST, GET_ADMIN_GROUP_MEASURE, AS_FROM_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c6e1218675 | B4 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SSP0014 화면에는 Measure 입력과 AS From Site 콤보가 없다. · 검색어 MKT_FCST, SCM_FCST, GET_ADMIN_GROUP_MEASURE, AS_FROM_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0fa7dc9143 | B4 | [DMF0082 결함 유형] FCST Type 후보 | SSP0014에는 FCST Type 콤보가 없다. · 검색어 FCST Type, FCST_TYPE, SALES_TYPE_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a11769398e | N1 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site ID | SSP0014에는 MKT_FCST와 Unit Price(LOC) 입력 항목이 없습니다. · 검색어 MKT_FCST, Unit Price, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f628e0f2ff | F1 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site ID | SSP0014 에는 MKT_FCST 와 Unit Price(LOC) 조건부 필수 검증이 없다. · 검색어 MKT_FCST, Unit Price(LOC), PLANT_SITE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b086c6747e | F4 | [DMF0082 결함 유형] Bucket 전환 후 저장 | SSP0014 에는 Bucket 전환 기능이 없다. · 검색어 Bucket, BUCKET, Weekly: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-56350fd771 | M3 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SSP0014 에는 Exchange Rate 팝업이 없다. · 검색어 Exchange Rate, ExchangeRate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-25db46ff20 | F2 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | 이 화면에는 Exchange Rate 팝업이 없다. · 검색어 Exchange Rate, EXCHANGE_RATE, ExchangeRate: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-16b4963f11 | M2 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SSP0014 Shipment Model PIC 화면에는 Exchange Rate 팝업이 없고, 팝업은 UserInfoPopup과 SCM0002_ItembyDivisionPopup만 있습니다. · 검색어 Exchange Rate, ExchangeRate, BPS I/F: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fc441f5bb4 | M4 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SSP0014 화면에는 Exchange Rate 팝업이 없고, AS-IS 소스와 TO-BE 화면 폴더에서 Exchange·BPS 검색 결과가 0건이다. · 검색어 Exchange Rate, EXCHANGE_RATE, BPS: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9a2e505b13 | D2 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | 이 화면에는 RTF[R+P] Measure와 Cutoff 조건이 없다. · 검색어 RTF, CUTOFF, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-929eed078f | J3 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | SSP0014 에는 RTF[R+P] Measure 와 Cutoff 편집 조건이 없습니다. · 검색어 RTF, GET_ADMIN_GROUP_MEASURE, Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-42fb018a06 | E4 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | SSP0014에는 RTF[R+P] 컬럼과 Cutoff 기준 편집 조건이 없습니다. · 검색어 Cutoff, RTF, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5ddcee7a65 | E4 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SSP0014에는 FCST Type=ETC Text 필수 검증과 ETC 테이블이 없습니다. · 검색어 FCST Type, FCST_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0a999c6d4d | F6 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SSP0014 에는 FCST Type, ETC Text 필수 검증과 ETC 테이블이 없다. · 검색어 FCST_TYPE, FCST Type: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-13c7dc7ffa | D1 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | 이 화면에는 신규 행의 Sales Site·Project 팝업·SALES_PLAN_ITEM_ID 기준 Model 후보·Team 컬럼이 없다. · 검색어 SALES_PLAN_ITEM_ID, SALES_SITE_ID, PROJECT_CD: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2115a1f168 | C3 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SSP0014 그리드에는 Sales Site·Project·Team 컬럼이 없고, AS-IS InsertButton 은 주석 처리되어 신규 행을 추가하지 않는다. · 검색어 SALES_SITE, Sales Site, SALES_PLAN_ITEM_ID, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6c5f72bbec | B5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SSP0014 화면에는 Sales Site·Project 팝업·Team 컬럼이 없다. · 검색어 SALES_SITE, PROJECT_ID, SALES_PLAN_ITEM_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ca40369048 | M3 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SSP0014 그리드에는 Sales Site 컬럼과 Team 팝업 입력 컬럼이 없다. · 검색어 SALES_PLAN_ITEM_ID, Sales Site, SalesSite: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-472a8f772e | G5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | 이 화면 그리드에는 Sales Site·Project 팝업·Team 컬럼 입력이 없다. · 검색어 SALES_SITE, SALES_PLAN_ITEM_ID, ProjectPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c7fb626281 | D5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SSP0014 그리드에는 Sales Site·Project 팝업·Team 컬럼이 없습니다. · 검색어 SALES_PLAN_ITEM_ID, Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-817e8d7708 | A5 | [DMF0021 결함 일반화] Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | SSP0014는 AS-IS와 TO-BE 모두 컬럼셋팅 팝업이 없고 그리드는 21개 컬럼으로 고정되어 있어 컬럼셋팅 OK 후 컬럼을 다시 구성하는 동작이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅, COL_LIST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7234fc097b | K2 | [DMF0021 결함 일반화] Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | SSP0014 화면에는 컬럼셋팅 팝업이 없어서 OK를 누를 때 그리드 컬럼을 다시 구성하는 동작이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-403ff05d9d | D3 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SSP0014 에는 AS From Site 컬럼과 Measure 후보 기능이 없습니다. · 검색어 AS From Site, AS_FROM_SITE, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7c43e443c8 | B5 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SSP0014 화면에는 AS From Site 컬럼과 Measure 후보가 없다. · 검색어 AS_FROM_SITE, SCM_FCST, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-45bf8d97f8 | J3 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SSP0014 에는 AS From Site 콤보와 Measure 후보가 없습니다. 이 화면에 있는 것은 From Site 조회조건뿐입니다. · 검색어 AS_FROM_SITE, AS From Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-cdd75404ef | B4 | [DMF0082 결함 유형] End Customer 셀 콤보 후보 | SSP0014 그리드에는 End Customer 셀 콤보가 없고 셀 콤보는 From Site와 Active뿐이다. · 검색어 END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e38f8bdbe8 | B5 | [DMF0082 결함 유형] End Customer 셀 콤보 후보 | SSP0014 그리드에는 End Customer 셀 콤보가 없다. · 검색어 END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-51c7460283 | M3 | [DMF0082 결함 유형] Excel Form 팝업 Search | SSP0014 에는 Excel Form 팝업 버튼이 없고 BTN:EXCEL 만 있다. · 검색어 Excel Form, ExcelForm, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3342f6595b | M1 | [DMF0082 결함 유형] Excel Form 팝업 Search | SSP0014 has no Excel Form popup, so there is no Search inside such a popup. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-78e32f2e79 | K2 | [DMF0082 결함 일반화] 컬럼·메저 셋팅 Save/OK 재조회 | SSP0014 화면에는 컬럼·메저 셋팅 팝업이 없어서 Save/OK 후 재조회 여부를 확인할 대상이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ea683e076e | B4 | [DMF0082 결함 유형] Customs Handbook 콤보 후보 | SSP0014에는 Customs Handbook 콤보가 없다. · 검색어 Customs Handbook, CUSTOMS_HANDBOOK: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-da7deeba4a | B4 | [DMF0005 결함 유형] Team 조회조건 후보 | SSP0014에는 Team 조회조건이 없다. · 검색어 cboTeam, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ad68d052d1 | B7 | [DMF0005 결함 유형] Team 조회조건 후보 | SSP0014에는 Team 조회조건이 없다. · 검색어 DEPT_ID, cboTeam: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c4df896440 | B4 | [DMF0035 결함 유형] Version 조회조건 | SSP0014에는 Version 조회조건이 없다. · 검색어 cboVersion, VERSION_ID, PLAN_VERSION: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9e7ece09d3 | M3 | [DMF0035 결함 유형] Version 조회조건 | SSP0014 조회조건에는 Version 이 없다. · 검색어 cboVersion, Version: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c5aed20dba | F1 | [DMF0082 결함 유형] Unit Price(LOC) 저장 | SSP0014 그리드에는 Unit Price(LOC) 컬럼이 없어 그 저장을 확인할 대상이 없다. · 검색어 UNIT_PRICE, Unit Price(LOC), Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e56ae48a5e | F6 | [DMF0082 결함 유형] Unit Price(LOC) 저장 | SSP0014 에는 Unit Price(LOC) 컬럼과 조회기간 컬럼이 없다. · 검색어 UNIT_PRICE, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-69fcf1df26 | E4 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SSP0014에는 RTF 저장과 Sales Plan Waterfall 동기화 기능이 없습니다. · 검색어 RTF, Waterfall, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-1f0cccb423 | F1 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SSP0014 에는 RTF 저장과 Sales Plan Waterfall 동기화 기능이 없다. · 검색어 RTF, Waterfall, Sales Plan: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-322a8a8e97 | F7 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SSP0014 에는 RTF 판가 검증과 Sales Plan Waterfall 연동이 없다. · 검색어 RTF, Waterfall: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6458163c92 | G4 | [DMF0035 결함 유형] Plan Type 조회조건 위치 | 이 화면 조회조건에는 Plan Type 이 없다. · 검색어 PlanType, Plan Type, cboPlanType: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8699c48283 | H6 | [DMF0005 결함 유형] Team 팝업 조건(Team ID/Team Name) | 이 화면에는 Team ID/Team Name 조건이 있는 Team 팝업이 없고, Team Leader 셀은 사용자 팝업을 엽니다. · 검색어 Team ID, TeamPopup, Team Name: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a01e1d3783 | B4 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | SSP0014 그리드에는 Sales Plant 셀 콤보가 없다. · 검색어 Sales Plant, SALES_PLANT, SCM_MST_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-57f9f4fad0 | N1 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | SSP0014 그리드에는 Sales Plant 셀 콤보가 없고, 콤보는 From Site(PlantSiteByDivision)뿐입니다. · 검색어 Sales Plant, SALES_PLANT, SCM_MST_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-66365eb26d | A5 | [DMF0021 결함 일반화] 컬럼셋팅 Company ID(필수 표시·Invisible 이동) | SSP0014에는 컬럼셋팅 팝업과 Invisible 영역이 없다. · 검색어 ColumnSetting, 컬럼셋팅, Invisible: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9887c94251 | K2 | [DMF0035 결함 유형] Measure 명칭 MKT FCST[R+P] | SSP0014 화면은 Shipment Model PIC 담당자를 관리하는 화면이라 MKT FCST[R+P] Measure와 메저셋팅이 없다. · 검색어 MKT FCST, MeasureSetting, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7e3b20e74c | H8 | [SYS0012 결함 유형] Request Date 컬럼 | SSP0014 에는 Request Date 컬럼이 없고 날짜 컬럼 Creation Date·Last Update Date 는 별도 기준 항목으로 확인한다. · 검색어 REQUEST_DATE, Request Date: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-842acb358c | D1 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | 이 화면에는 Dept 컬럼이 없다. · 검색어 DEPT_ID, DEPT_NAME, SSO_DEPT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0972922688 | C3 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SSP0014 그리드에는 Dept 컬럼과 Use Y/N 헤더가 없다. · 검색어 DEPT_ID, DEPT_NAME, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b76c62a07e | H3 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | 이 화면 그리드에는 Dept 컬럼과 Use Y/N 헤더가 없고, 다른 화면(SYS0002)의 결함 유형입니다. · 검색어 DEPT_ID, DEPT_NAME, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d1d6105160 | F1 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SSP0014 그리드에는 Dept 컬럼과 Use Y/N 헤더가 없다. · 검색어 DEPT_ID, DEPT_NAME, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fc046d9381 | A5 | [SYS0014 결함 유형] Email 컬럼 | SSP0014 그리드에는 Email 컬럼이 없고 Mail User1~5 컬럼만 있다. · 검색어 EMAIL, E_MAIL, Email: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-1604e4a296 | B4 | [SYS0010 결함 유형] System 컬럼 입력 방식 | SSP0014 그리드에는 System 컬럼이 없다. · 검색어 SYSTEM_CODE, SYS0010: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f758ba3f48 | A5 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | SSP0014에는 URL-ROUTE_PATH 컬럼이 없다. · 검색어 ROUTE_PATH, Route Path: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-770993d8cf | D1 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | 이 화면에는 URL·ROUTE_PATH 컬럼이 없다. · 검색어 ROUTE_PATH, Route Path: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fb86657741 | F1 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | SSP0014 에는 URL-ROUTE_PATH 컬럼이 없다. · 검색어 ROUTE_PATH, URL: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fcc5bf69fe | B6 | [SYS0005 결함 유형] Schema 조회조건 | SSP0014에는 Schema 조회조건이 없다. · 검색어 Schema, SCHEMA_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-da24107a1a | G2 | [SYS0005 결함 유형] Schema 조회조건 | SSP0014 조회조건에 Schema 조건이 없다. · 검색어 cboSchema, SCHEMA_NAME, Schema: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-59773f5304 | G1 | [SYS0005 결함 유형] Schema 조회조건 | SSP0014 에는 Schema 조회조건이 없다. · 검색어 SCHEMA, Schema, cboSchema: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6d07cc31fd | B6 | [SYS0006 결함 유형] API Type 조회조건 | SSP0014에는 API Type 조회조건이 없다. · 검색어 API Type, API_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ee4f4f26b4 | B4 | [SYS0006 결함 유형] API Type 조회조건 | SSP0014 화면에는 API Type 조회조건이 없다. · 검색어 API_TYPE, API Type: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-678190ddca | B1 | [SYS0006 결함 유형] API Type 조회조건 | SSP0014 조회조건에는 API Type이 없다. · 검색어 API_TYPE, API Type: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-84ddabb5f2 | B4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SSP0014에는 Module·Sub Module 조회조건과 Notice Content가 없다. · 검색어 Sub Module, Notice Content, MODULE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a3e6cf3303 | B6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SSP0014에는 Module·Sub Module 조회조건과 Notice Content 입력이 없다. · 검색어 Notice Content, Sub Module, SUB_MODULE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-497da011e2 | G4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | 이 화면 조회조건에는 Module·Sub Module 이 없다. · 검색어 Sub Module, cboModule, cboSubModule: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-86ecff343e | H5 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SSP0014 화면에는 Module·Sub Module 조회조건과 Notice Content가 없어 SYS0016 결함 유형의 대상이 아니다. · 검색어 Sub Module, Notice Content, MODULE_CD: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f88c518abb | D4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SSP0014 에는 Module·Sub Module 조회조건과 Notice Content 가 없습니다. · 검색어 Sub Module, SUB_MODULE, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-dab69f48d3 | H6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | 이 화면에는 Module·Sub Module 조회조건과 Notice Content 가 없습니다. · 검색어 Sub Module, SubModule, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d40e36ed60 | K5 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | 이 화면에는 Module·Sub Module 조회조건과 Notice Content가 없다. · 검색어 SUB_MODULE, Sub Module, Notice Content, Insert Module: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-91c6a13d3c | B6 | [SYS0017 결함 유형] Module / Sub Module 조회조건 | SSP0014 조회조건은 Div·Operation group·From Site·Active·Model/Nickname·User ID(Name)이고 Module·Sub Module 조회조건이 없다. · 검색어 Sub Module, SUB_MODULE, MODULE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3a437a52d5 | G4 | [SYS0017 결함 유형] Module / Sub Module 조회조건 | 이 화면 조회조건에는 Module·Sub Module 이 없다. · 검색어 Sub Module, cboModule, cboSubModule: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c1faa8302b | B4 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SSP0014 그리드에는 Sales Company·Sales Plant 콤보가 없다. · 검색어 Sales Company, SALES_COMPANY, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8f9615ef28 | C2 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | 이 화면 그리드에는 Sales Company·Sales Plant 콤보가 없다. · 검색어 Sales Company, Sales Plant, SALES_COMPANY: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-43b357e27e | F2 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | 이 화면 그리드에는 Sales Company·Sales Plant 콤보 컬럼이 없다. · 검색어 Sales Company, SALES_COMPANY, Sales Plant, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a76e57896f | F1 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | 이 화면 그리드에는 Sales Company·Sales Plant 콤보 컬럼이 없다. · 검색어 Sales Company, SALES_COMPANY, Sales Plant, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-1fabc41135 | H6 | [DMF0005 결함 유형] Project 팝업(그리드) | 이 화면은 Model 팝업에 Project 값을 빈 값으로 넘기고, Project 팝업은 따로 없습니다. · 검색어 ProjectPopup, btnProject: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8c97514557 | M3 | [DMF0005 결함 유형] Project 팝업(그리드) | SSP0014 에는 Project 팝업이 없고 btnItemId_Click 은 Project 값으로 빈 문자열을 넘긴다. · 검색어 ProjectPopup, btnProject: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-807e5154dd | G2 | [DMF0005 결함 유형] Project 팝업(그리드) | SSP0014의 팝업은 Model 조회용 SCM0002 팝업뿐이고, AS-IS txtProject는 주석 처리되어 Project 팝업이 없다. · 검색어 ProjectPopup, PROJECT_POPUP, Project Popup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-795366e5ce | B3 | [SYS0010 결함 유형] 메인화면 System admin 정보(SYSTEM_ADM Lookup) | SSP0014에는 메인화면 System admin 정보(SYSTEM_ADM Lookup) 표시 기능이 없다. · 검색어 SYSTEM_ADM, System admin: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-dcfbdf1692 | E4 | [DMF0004 결함 유형] Customer 탭 Sold to/Ship to 저장 검증 | SSP0014에는 Customer 탭 Sold to/Ship to 저장 검증이 없습니다. · 검색어 Sold to, Ship to, NERP_CONV_MASTER: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ba8fb13270 | E3 | [DMF0005 결함 유형] Project 컬럼 필수 검증 | SSP0014 그리드에는 Project 컬럼이 없다. · 검색어 PROJECT_CD, PROJECT_NAME, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5484edad47 | E4 | [DMF0005 결함 유형] Project 컬럼 필수 검증 | SSP0014 그리드에는 Project 컬럼이 없습니다. · 검색어 PROJECT_ID, PROJECT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-bf1cfa1c49 | B7 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SSP0014 그리드에는 Team(DEPT_ID) 셀 콤보가 없고, 비슷한 이름의 컬럼은 Team Leader·Team Leader Name뿐이다. · 검색어 DEPT_ID, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-45501bfb38 | A2 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SSP0014 에는 Team(DEPT_ID) 셀 콤보가 없다. · 검색어 DEPT_ID, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-11d3c1e0a6 | B4 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SSP0014 그리드에는 Team(DEPT_ID) 셀 콤보가 없다. · 검색어 DEPT_ID, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a78b05495b | B7 | [DMF0003 결함 유형] Team 정보(DEPT_ID) | SSP0014에는 Team(DEPT_ID) 정보 컬럼이 없다. · 검색어 DEPT_ID, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-73e9b2df4d | A1 | [DMF0003 결함 유형] Team 정보(DEPT_ID) | SSP0014 에는 Team(DEPT_ID) 컬럼이 없고, TEAM_LEADER 컬럼은 팀이 아니라 사용자 ID 다. · 검색어 DEPT_ID, SSPM, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-27285b805a | F7 | [DMF0020 결함 유형] Unit Price(LOC) → Sales Price 연동 | SSP0014 에는 Unit Price(LOC) 와 Sales Price 연동이 없다. · 검색어 UNIT_PRICE, SALES_PRICE, Sales Price: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c713c30b30 | F1 | [DMF0020 결함 유형] Unit Price(LOC) → Sales Price 연동 | SSP0014 에는 Unit Price(LOC) 와 Sales Price 연동 기능이 없다. · 검색어 SALES_PRICE, Sales Price, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b1d568dd65 | B5 | [SYS0012 결함 유형] 권한 신청 가능 Group 목록 | SSP0014 화면에는 권한 신청 Group 목록이 없다. · 검색어 REQ_NO_DISPLAY, 권한 신청: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-28a65c2123 | F8 | [SYS0011 결함 유형] Approval Date 컬럼 | SSP0014 에는 Request·Approval 절차와 Approval Date 컬럼이 없다. · 검색어 APPROVAL_DATE, Approval Date: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4ed8867532 | F1 | [SYS0011 결함 유형] Approval Date 컬럼 | SSP0014 에는 Approval Date 컬럼이 없다. · 검색어 APPROVAL_DATE, Approval Date: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b9f91b2925 | C5 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | SSP0014 에는 Mail Setup 탭과 사용자 좌/우 그리드가 없고, 메일 수신자는 단일 그리드의 MAIL_USER1~5 컬럼으로 입력한다. · 검색어 Mail Setup, MAIL_SETUP: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e6544570f6 | F1 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | 이 화면은 그리드(spdMain) 하나만 쓰고, Mail Setup 탭의 사용자 좌/우 그리드와 더블클릭 이동 기능이 없다. · 검색어 Mail Setup, MailSetup, tabMailSetup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3fea013260 | F5 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | SSP0014 에는 Mail Setup 탭과 사용자 좌/우 그리드가 없고, Mail User1~5 컬럼만 있다. · 검색어 Mail Setup, MailSetup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3a194f7fa5 | H4 | [DMF0035 결함 유형] Version 조회조건 돋보기 버튼 | SSP0014 조회조건에는 Version 조회조건과 돋보기 버튼이 없다. · 검색어 txtVersion, btnVersion, VERSION_ID, VersionPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4630cb50b6 | C1 | [DMF0035 결함 유형] Version 조회조건 기본값 | 이 화면에는 Version 조회조건이 없다. · 검색어 cboVersion, Version: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9434f02bf9 | A3 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | SSP0014 에는 Sum 행 라벨이나 Sum/Qty≠0 체크박스가 없다. · 검색어 Qty≠0, Sum/Qty, chkSum: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-24f782bb61 | H5 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | SSP0014 그리드에는 Sum 행이나 Sum·Qty≠0 체크박스가 없어 DMF0035 Sum 표기 결함 유형의 대상이 아니다. · 검색어 Qty≠0, Sum/Qty, chkSum, SUM_YN: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d5c11d55d9 | G4 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | 이 화면 그리드에는 Sum 행과 Sum/Qty≠0 체크박스가 없다. · 검색어 chkSum, Sum/Qty, Qty≠0: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b143525897 | A5 | [DMF0035 결함 유형] Version 컬럼 | SSP0014 그리드에는 Version 컬럼이 없다. · 검색어 VERSION_ID, PLAN_VERSION, VERSION_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-38ed532bb2 | F7 | [DMF0021 결함 유형] RTF[R+P] → DM_PLN_MKT_FCST / DM_PLN_MKT_FCST_C 연동 | SSP0014 의 저장 SP 는 Model PIC 를 저장하며 DM_PLN_MKT_FCST 연동이 없다. · 검색어 DM_PLN_MKT_FCST, RTF: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ea2e4553a0 | F1 | [DMF0021 결함 유형] RTF[R+P] → DM_PLN_MKT_FCST / DM_PLN_MKT_FCST_C 연동 | SSP0014 에는 RTF[R+P] 를 DM_PLN_MKT_FCST 에 연동하는 기능이 없다. · 검색어 DM_PLN_MKT_FCST, MKT_FCST, RTF: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5d039f890b | I2 | [SCP0028 결함 유형] Lot Size<Increment 검증 메시지 | SSP0014에는 Lot Size와 Increment를 비교하는 검증 메시지가 없습니다. · 검색어 LotSize, LOT_SIZE, Increment: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-75ad531b9d | I1 | [SCP0028 결함 유형] Lot Size<Increment 검증 메시지 | SSP0014에는 Lot Size와 Increment를 비교하는 검증이 없습니다. AS-IS 저장 검증은 User ID와 Team Leader 등록 여부만 확인합니다. · 검색어 LotSize, LOT_SIZE, Increment: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c287142cb7 | E4 | [SCP0028 결함 유형] Lot Size<Increment 검증 메시지 | SSP0014에는 Lot Size·Increment 컬럼과 그 검증 메시지가 없습니다. · 검색어 Lot Size, LOT_SIZE, Increment: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8595f912bc | A1 | [SCP0006 결함 유형] BOM Explosion Plant Assign(MCCH125020A1/MACH125020A1) | SSP0014 에는 BOM Explosion 이나 Plant Assign 정보를 조회하는 기능이 없다. · 검색어 BOM Explosion, Plant Assign, EXPLOSION: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-909ac24c64 | N1 | [SCP0006 결함 유형] BOM Explosion Plant Assign(MCCH125020A1/MACH125020A1) | SSP0014에는 BOM Explosion이나 Plant Assign 기능이 없습니다. · 검색어 BOM Explosion, Plant Assign, PLANT_ASSIGN: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-89072a6a3f | D3 | [SCP0006 결함 유형] Plant Assign 그리드 색상 | SSP0014 그리드에는 Plant Assign 그리드와 CA1 행 색상 기능이 없습니다. · 검색어 Plant Assign, CA1: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fa4325bda5 | H2 | [SCP0006 결함 유형] Plant Assign 그리드 색상 | 이 화면에는 Plant Assign 그리드와 CA1 행이 없다. · 검색어 Plant Assign, PLANT_ASSIGN, CA1: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-aad62d783a | H6 | [SCP0007 결함 유형] Route 검색 팝업 제목 | 이 화면에는 Route 검색 팝업이 없습니다. · 검색어 Route, RoutePopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0109e68fb1 | H5 | [SCP0007 결함 유형] Route 검색 팝업 제목 | SSP0014 화면에는 Route 검색 팝업이 없고 팝업은 SCM0002_ItemByDivisionPopup뿐이어서 SCP0007 Route 팝업 제목 결함 유형의 대상이 아니다. · 검색어 Route, RoutePopup, ROUTE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-062af6057c | B4 | [SCP0007 결함 유형] To Site 조회조건 콤보 | SSP0014에는 To Site 조회조건이 없고 From Site만 있다. · 검색어 To Site, TO_SITE, cboToSite: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d93bfd86af | D4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SSP0014 그리드에는 To Site 콤보와 City 매핑이 없습니다. · 검색어 To Site, TO_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-123e9c071d | C3 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SSP0014 그리드에는 To Site·City 컬럼이 없고, Insert 버튼은 동작하지 않는다. · 검색어 TO_SITE, To Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-038043c6fc | E2 | [SCP0007 결함 유형] Period 날짜 | SSP0014에는 Period 날짜 입력 칸이 없고, 날짜 컬럼 Creation Date·Last Update Date는 편집 잠금 상태다. · 검색어 Period, FromDate, ToDate: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b2ed88f315 | F4 | [SCP0007 결함 유형] Period 날짜 | SSP0014 에는 Period 날짜 입력 항목이 없다. · 검색어 Period, PERIOD, FromDate: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f025d9215e | M1 | [DMF0014 결함 일반화] 공용 업로드 창(Upload) 검증 완료 후 저장 전 Cancel · X 닫기 확인창 MSG00684 「취소하시겠습니까?」(AS-IS MSG00195) | SSP0014 does not use the shared Excel Upload window, so the Cancel confirmation on close has no target. · 검색어 ExcelUpload, Excel Upload, Invalid Column Header Title: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d7a9af8cbc | B5 | [DMF0021 결함 일반화] Measure 설정 팝업(Measure Setting) 후보 · Column 설정 후보 — Division 기준 재조회 | SSP0014 화면에는 Measure Setting 팝업이 없고, 컬럼은 21개로 고정이다. · 검색어 MeasureSetting, Measure Setting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b1a66f0aa0 | K2 | [DMF0021 결함 일반화] Measure 설정 팝업(Measure Setting) 후보 · Column 설정 후보 — Division 기준 재조회 | SSP0014 화면에는 AS-IS·TO-BE 모두 Measure Setting 팝업이나 Column Setting 팝업이 없어서 Division 기준으로 목록을 다시 조회하는 기능도 없다. · 검색어 MeasureSetting, Measure Setting, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-97228df716 | H7 | [DMF0049 결함 일반화] Excel Download 월 칸 서식(#,##0.000;[Red]-#,##0.000 · 메타 자릿수) · 음수 빨강 — 공용 엑셀 내려받기 칸별 서식 | SSP0014 그리드에는 사용자·사이트·모델·날짜 컬럼만 있고 숫자 서식 칸이 없어 Excel 숫자 칸 서식 대상이 없다. · 검색어 #,##0, NumberFormat, decimal: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0447ccf05f | H8 | [DMF0049 결함 일반화] Excel Download 월 칸 서식(#,##0.000;[Red]-#,##0.000 · 메타 자릿수) · 음수 빨강 — 공용 엑셀 내려받기 칸별 서식 | SSP0014 그리드에는 숫자 서식 칸이 없어 Excel 숫자 칸 서식 대상이 없다. · 검색어 #,##0, NumberFormat, decimal: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a63a9ca042 | C1 | [DMF0053 결함 일반화] 조회조건 Filter 콤보 6종(FilterMyDivision·FilterTeambyDivision·FilterEndCustomerByDivision·FilterBizType·Filte | 이 화면의 From Site 조회조건은 Filter 콤보가 아니라 Data_SCP PlantSiteByDivision 으로 채운다(cs:202). · 검색어 FilterFromSiteByDivision, FilterMyDivision, FilterTeambyDivision, FilterEndCustomerByDivision: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-53d8dceaa4 | M1 | [DMF0074 결함 일반화] 공용 Excel Upload 창 2단계 — Upload(검사 · 분류) → OK(저장) · 오류 1건 이상이면 저장 차단 MSG00657 | SSP0014 does not use the shared Excel Upload window, so the 2-step Upload/OK flow has no target. · 검색어 ExcelUpload, Excel Upload, Invalid Column Header Title: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2cf47dbdca | A2 | [결함 유형 묶음 A2-G02 · 2건] Category 코드 컬럼(CATEGORY_ID) 숨김 | SSP0014 그리드 21개 컬럼 가운데 CATEGORY_ID 와 CATEGORY_DESC 는 없다. · 검색어 CATEGORY_ID, CATEGORY_DESC: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-73d6ecaf6a | A5 | [결함 유형 묶음 A5-G01 · 2건] Main 그리드 Sub Module 컬럼(SUB_MODULE_CODE) | SSP0014 그리드에는 Sub Module 컬럼(SUB_MODULE_CODE)이 없다. · 검색어 SUB_MODULE_CODE, Sub Module: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-87627c960a | A5 | [결함 유형 묶음 A5-G02 · 2건] Category 코드 컬럼(CATEGORY_ID) 숨김 | SSP0014 그리드에는 Category 코드 컬럼(CATEGORY_ID)과 CATEGORY_DESC 컬럼이 없다. · 검색어 CATEGORY_ID, CATEGORY_DESC: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9c91939a8d | A5 | [결함 유형 묶음 A5-G03 · 2건] 조회 그리드 컬럼 구성 = 컬럼셋팅 설정 | SSP0014에는 컬럼셋팅 설정값으로 그리드를 구성하는 기능과 COL_LIST 컬럼이 없다. · 검색어 COL_LIST, ColumnSetting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-69aebd639b | A5 | [결함 유형 묶음 A5-G07 · 2건] Div별 Project 계열 제외 컬럼 비노출 | SSP0014 그리드에는 Project Name, Project Status 같은 Project 계열 컬럼이 없다. · 검색어 PROJECT_NAME, PROJECT_STATUS, Project Name, Project Status: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a64633195a | A5 | [결함 유형 묶음 A5-G08 · 2건] Plan Type별 제외 컬럼(Cust Group Dtl 등) | SSP0014에는 Plan Type 조건과 Cust Group Dtl 컬럼이 없다. · 검색어 PLAN_TYPE, Cust Group Dtl, CUST_GROUP_DTL: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4c0fd4ce78 | A5 | [결함 유형 묶음 A5-G09 · 2건] Div 40 Report 컬럼 표시 | SSP0014 그리드에는 Cell Prod. Site (S&OP Report) 컬럼과 Sold-to Cust(Report) 컬럼이 없다. · 검색어 Cell Prod. Site, Sold-to Cust, S&OP Report: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2d63fdf425 | A8 | [결함 유형 묶음 A8-G01 · 2건] 팝업 Spread의 기간 동적 컬럼(YYYYMM) | SSP0014에는 기간별 YYYYMM 동적 컬럼을 만드는 팝업 Spread가 없다. · 검색어 PERIOD, FROM_MONTH, TO_MONTH: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-bc99526b81 | B1 | [결함 유형 묶음 B1-G01 · 3건] 그리드 End Customer 콤보 후보 목록 | SSP0014 그리드에는 End Customer 콤보 컬럼이 없다. · 검색어 END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ee93a87562 | B2 | [결함 유형 묶음 B2-G01 · 3건] 그리드 End Customer 콤보 후보 목록 | SSP0014 그리드에는 End Customer 콤보 컬럼이 없다. · 검색어 END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0e41f898e4 | B3 | [결함 유형 묶음 B3-G01 · 3건] 그리드 셀 콤보(End Customer·Sold-to Customer) 후보 | SSP0014 그리드에는 End Customer·Sold-to Customer 셀 콤보가 없다. · 검색어 END_CUSTOMER, SOLD_TO, Sold-to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-eefa16b10f | B4 | [결함 유형 묶음 B4-G01 · 3건] 저장 · Sales Site 조회조건 콤보 | SSP0014 화면에는 Sales Site 저장 기능과 Sales Site 조회조건 콤보가 없다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-24a9f0b449 | B5 | [결함 유형 묶음 B5-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | SSP0014 화면에는 신규 행 Measure 콤보가 없다. · 검색어 MKT_FCST, AS_In_Request, VMI_In_Request: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b775395668 | B5 | [결함 유형 묶음 B5-G02 · 2건] FCST Type 콤보 후보 | SSP0014 화면에는 FCST Type 콤보가 없다. · 검색어 FCST_TYPE, SALES_TYPE_CODE, FCST Type: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-23d431d583 | C2 | [결함 유형 묶음 C2-G06 · 4건] 그리드 상위 셀 변경 시 하위 셀 cascade | 이 화면 그리드에는 End Customer·Sales Site·Sales Company·Sales Plant·Sold-to 컬럼이 없다. · 검색어 End Customer, Sales Company, Sales Plant, Sold-to: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b1ac480bbe | C3 | [결함 유형 묶음 C3-G01 · 3건] Team·End Customer(·Energy(WH)) 컬럼 자동 세팅 | SSP0014 그리드에는 Team·End Customer·Energy(WH) 컬럼이 없다. · 검색어 END_CUSTOMER, End Customer, ENERGE, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fde847de4d | C5 | [결함 유형 묶음 C5-G01 · 2건] 사용자 좌/우 그리드 더블클릭 추가/제거 | SSP0014 에는 사용자를 좌/우 그리드 사이에서 더블클릭으로 추가·제거하는 기능이 없다. · 검색어 spdLeft, spdRight, Mail Setup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3334c8c968 | D1 | [결함 유형 묶음 D1-G01 · 2건] 신규 행 Team·End Customer 등 자동 매핑 컬럼 | 이 화면에는 SSPM 기준으로 자동 매핑되는 Team·End Customer·Energy(WH) 컬럼이 없다. · 검색어 END_CUSTOMER, SSPM, Energy(WH): AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4eadc26e0d | D2 | [결함 유형 묶음 D2-G01 · 2건] MKT_FCST·SCM_FCST 편집 권한(GET_ADMIN_GROUP_MEASURE) | 이 화면에는 MKT_FCST·SCM_FCST Measure가 없다. · 검색어 MKT_FCST, SCM_FCST, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e9ee076b54 | D2 | [결함 유형 묶음 D2-G02 · 3건] Bucket 유형별 Measure 편집 구간 | 이 화면에는 Bucket 유형별 Measure 편집 구간이 없다. · 검색어 MKT_FCST, BUCKET, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8c2c6449a5 | D3 | [결함 유형 묶음 D3-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | SSP0014 그리드에는 Measure 콤보 컬럼이 없습니다. · 검색어 MKT_FCST, VMI_In_Request, AS_In_Request: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-20fc999b85 | D4 | [결함 유형 묶음 D4-G01 · 2건] 하단 메시지설정 탭의 Insert(행추가) | SSP0014 에는 하단 메시지설정 탭이 없습니다. · 검색어 메시지설정, Message Setting, MSG_SETTING: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-dda8e499df | D5 | [결함 유형 묶음 D5-G01 · 2건] 코드성 컬럼의 셀 입력 방식(Menu Type·Auth Unit·System) | SSP0014 그리드에는 Menu Type·Auth Unit·System 컬럼이 없습니다. · 검색어 Menu Type, MENU_TYPE, Auth Unit, AUTH_UNIT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0d25bfc55e | E1 | [결함 유형 묶음 E1-G01 · 2건] 정수 전용 수량·일수 입력 컬럼 | SSP0014 그리드에는 MKT FCST 수량이나 Additional Lead Time 같은 정수 전용 컬럼이 없다. · 검색어 MKT_FCST, Additional Lead Time, LEAD_TIME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0ee3e095fb | E4 | [결함 유형 묶음 E4-G01 · 2건] Excel Upload Validation 메시지(행·항목별) | SSP0014에는 Excel Upload 기능이 없으며 BTN:EXCEL은 다운로드 버튼입니다. · 검색어 Excel Upload, ExcelUpload, UploadExcel: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c9952d6da3 | E4 | [결함 유형 묶음 E4-G02 · 2건] 판가(Unit Price) 미입력 Validation 오탐 | SSP0014에는 판가(Unit Price) 컬럼과 판가 미입력 검증이 없습니다. · 검색어 Unit Price, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-aab329940f | E4 | [결함 유형 묶음 E4-G03 · 2건] 수량 입력 시 Unit Price 조건부 필수 | SSP0014에는 MKT FCST 수량과 Unit Price 조건부 필수 검증이 없습니다. · 검색어 Unit Price, MKT FCST, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-61cd83b1d7 | F1 | [결함 유형 묶음 F1-G01 · 3건] 저장 · Sales Site 조회조건 콤보 | SSP0014 조회조건에는 Sales Site 콤보가 없다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e4cffc9273 | F1 | [결함 유형 묶음 F1-G02 · 2건] 수량·Unit Price(LOC) 입력 행 저장 Validation | 이 화면에는 수량·Unit Price(LOC) 입력 컬럼과 판가 미입력 Validation 이 없다. · 검색어 Unit Price, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e58cc10f5b | F1 | [결함 유형 묶음 F1-G04 · 2건] 사용자 우측 그리드(allReceiver) 추가 후 Save | SSP0014 는 단일 그리드 화면이라 우측 그리드(allReceiver)가 없다. · 검색어 allReceiver, Receiver: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9d9b7c64e8 | F2 | [결함 유형 묶음 F2-G01 · 3건] 저장 후 Sales Site 조회조건 콤보 갱신 | 이 화면 조회조건에는 Sales Site 콤보가 없다(조회조건은 Division·Operation Group·From Site·Active·Model·User). · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0142bab4ed | F4 | [결함 유형 묶음 F4-G01 · 2건] SQL View 버튼(VIEW) 클릭 | SSP0014 의 AS-IS 소스와 TO-BE 화면에는 SQL View(VIEW) 버튼이 없다. · 검색어 SQL View, SqlView, btnSqlView: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6af77be343 | H4 | [결함 유형 묶음 H4-G02 · 2건] Version 팝업(VERSION Modal) 레이아웃 | SSP0014에는 Version 팝업이 없다(팝업은 SCM0002 Model 팝업과 사용자 팝업만 있다). · 검색어 VersionPopup, VersionModal, btnVersion, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-dbb9517ad1 | H4 | [결함 유형 묶음 H4-G03 · 2건] 좌/우 사용자 영역 높이 | SSP0014는 단일 Main Grid 화면으로 좌/우 사용자 영역 분할이 없다. · 검색어 SplitContainer, splitContainer, Splitter: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a833d2d23e | H5 | [결함 유형 묶음 H5-G01 · 2건] Version·Plan Type 조회조건 라벨 명칭 | SSP0014 조회조건은 Div·Operation group·From Site·Active·Model/Nickname·User ID(Name)이고 Version·Plan Type 조회조건이 없어 H5-G01 결함 유형의 대상이 아니다. · 검색어 Ver., Waterfall Type, Plan Type, PLAN_VERSION: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7b7e3c896b | I2 | [결함 유형 묶음 I2-G02 · 2건] Team 명칭(조회조건과 결과 컬럼) | SSP0014에는 Team 조회조건과 Team 명 결과 컬럼이 없습니다. 결과 컬럼은 사용자 ID인 Team Leader와 Team Leader Name만 있습니다. · 검색어 TEAM_NAME, TEAM_CD, cboTeam: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5809ed35ed | J3 | [결함 유형 묶음 J3-G01 · 2건] MKT_FCST·SCM_FCST Measure 편집 구간(GET_ADMIN_GROUP_MEASURE) | SSP0014 에는 MKT_FCST·SCM_FCST Measure 편집 구간이 없습니다. · 검색어 MKT_FCST, SCM_FCST, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f7fc69ffba | K2 | [결함 유형 묶음 K2-G01 · 2건] 조회 그리드 컬럼 구성 | SSP0014 그리드는 컬럼셋팅 설정값이 아니라 고정 21열 메타로 그려지고 COL_LIST 같은 내부 컬럼도 없다. · 검색어 COL_LIST, ColumnSetting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2c16ac4c69 | K2 | [결함 유형 묶음 K2-G04 · 2건] 컬럼셋팅 팝업 필수 컬럼 조작 제한 | SSP0014 화면에는 컬럼셋팅 팝업과 Invisible 영역이 없어서 필수 컬럼의 해제·이동을 막는 동작이 없다. · 검색어 USER_SELECTED_FLAG, ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-45e744283d | K2 | [결함 유형 묶음 K2-G05 · 2건] Div 전환 시 필수 컬럼 유지 | SSP0014 화면에는 개인화 컬럼 저장 기능이 없고 Project Code·Plant Site 같은 Div별 필수 컬럼을 자동으로 추가하는 동작도 없다. · 검색어 Project Code, USER_SELECTED_FLAG, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-aa36ffc8a5 | K2 | [결함 유형 묶음 K2-G07 · 2건] 조회 결과 Measure 표시 순서 | SSP0014 조회 결과에는 Measure 행이 없고 메저셋팅 순서를 저장하는 기능도 없다. · 검색어 MeasureSetting, Measure Setting, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-dd7e9c19a8 | K2 | [결함 유형 묶음 K2-G08 · 1건] 개인화 없을 때 Default 컬럼·Measure | SSP0014 그리드는 21열 고정이고 컬럼셋팅·메저셋팅 개인화 기능이 없어서 개인화가 없을 때 Default 구성을 보여 주는 동작도 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅, MeasureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5c50ad7a63 | M1 | [결함 유형 묶음 M1-G01 · 2건] Excel Form 버튼 클릭 동작 | SSP0014 has no Excel Form button, so clicking it has no target. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-46c6655331 | M1 | [결함 유형 묶음 M1-G07 · 2건] Excel Upload 후 OK 저장·DB 반영 | SSP0014 has no Excel Upload feature, so there is no OK-to-save step after an upload. · 검색어 ExcelUpload, Excel Upload, Invalid Column Header Title: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b796ce61fa | M1 | [결함 유형 묶음 M1-G09 · 2건] Excel Upload 헤더·컬럼명 불일치 검증 | SSP0014 has no Excel Upload feature, so the header name check has no target. · 검색어 ExcelUpload, Excel Upload, Invalid Column Header Title: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-50ce3c2ab6 | M2 | [결함 유형 묶음 M2-G01 · 2건] SQL View 버튼(VIEW) 클릭 결과 | SSP0014 화면 버튼 목록에 SQL View(VIEW) 버튼이 없습니다. · 검색어 SQL View, SqlView, btnView: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d8a0cd4e29 | M3 | [결함 유형 묶음 M3-G01 · 2건] SQL 버튼 팝업 쿼리 저장 | SSP0014 에는 쿼리를 등록하는 SQL 버튼 팝업이 없다. · 검색어 btnSql, SqlPopup, QueryPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0d6b21abb3 | N1 | [결함 유형 묶음 N1-G02 · 2건] Div별 컬럼·Measure 구성의 AS-IS 일치 | SSP0014는 고정 컬럼 그리드라서 Div별 Measure 구성(Project·Cust FCST·End Cust(Report))과 SSPM 제외 컬럼이 없습니다. · 검색어 Cust FCST, SSPM, End Cust, S Report: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a3b9dec52a | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SSP0014 조회조건은 Div·Operation Group·From Site·Model/Nickname·User·Active이고 Team(DEPT) 콤보는 없다. · 검색어 DEPT_ID, cboTeam, SCM_MST_SITE_ITEM: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fca9bc5ea1 | C2 | 그리드 End Customer→Sold-to Customer cascade | 이 화면 그리드에는 End Customer·Sold-to Customer 컬럼이 없다. · 검색어 End Customer, Sold-to, SOLD_TO: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2b8ddd165d | C2 | 그리드 Sales Company→Sales Plant · Sales Site→Company/Plant | 이 화면 그리드에는 Sales Company·Sales Plant·Sales Site 셀이 없다. · 검색어 Sales Company, Sales Plant, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a0b5aa7e70 | M1 | Excel Upload 컬럼명 검증 메시지 · 파일 첨부 개수 | SSP0014 has no Excel Upload feature, so the file attachment count and column name check have no target. · 검색어 ExcelUpload, Excel Upload, Invalid Column Header Title: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4816fd58dc | H2 | 실적 구간 배경색 | Shipment Model PIC 그리드에는 편집 불가 과거 기간(실적 구간) 셀이 없다. · 검색어 ACTUAL, ACT_FLAG: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c34fa6fb42 | B8 | Team 컬럼(MKT FCST 조회·신규행) | SSP0014 그리드에는 SSPM DEPT_ID 기준 Team 컬럼이 없다. · 검색어 DEPT_ID, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-dd235197e9 | M1 | Excel Upload 헤더 검증 메시지 | SSP0014 has no Excel Upload feature, so the Invalid Column Header Title message has no target. · 검색어 ExcelUpload, Excel Upload, Invalid Column Header Title: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3859556249 | M1 | Excel Upload Validation 메시지(Sales Site/Project/Model) | SSP0014 has no Excel Upload feature, so the per-row validation messages have no target. · 검색어 ExcelUpload, Excel Upload, Invalid Column Header Title: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ec0ec0a7a1 | K2 | Column Setting 필수 컬럼 표시·Div 전환 End Customer | SSP0014 화면에는 컬럼셋팅 팝업이 없어서 필수 컬럼(USER_SELECTED_FLAG=N)을 빨간색으로 표시하는 대상이 없다. · 검색어 USER_SELECTED_FLAG, ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-288082d828 | M3 | Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SSP0014 에는 Exchange Rate 팝업이 없고 팝업은 UserInfoPopup 과 SCM0002_ItembyDivisionPopup 만 있다. · 검색어 Exchange Rate, ExchangeRate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7ab3dd3344 | A5 | Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | SSP0014는 AS-IS와 TO-BE 모두 컬럼셋팅 팝업이 없어 컬럼셋팅 OK 후 그리드를 다시 구성하는 동작이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅, COL_LIST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b72ba0712e | K2 | 컬럼·메저 셋팅 Save/OK 재조회 | SSP0014 화면에는 컬럼·메저 셋팅 팝업이 없어서 Save/OK 후 재조회 여부를 확인할 대상이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e9b56debe0 | A5 | 컬럼셋팅 Company ID(필수 표시·Invisible 이동) | SSP0014에는 컬럼셋팅 팝업과 Invisible 영역이 없다. · 검색어 ColumnSetting, 컬럼셋팅, Invisible: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f43dee9c90 | K2 | Measure 순서·메저셋팅 순서 저장 | SSP0014 화면에는 메저셋팅 버튼이 없다. · 검색어 MeasureSetting, Measure Setting, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-92b3fc4bbc | K2 | Measure 순서 | SSP0014 화면에는 메저셋팅이 없어서 Measure 표시 순서를 확인할 대상이 없다. · 검색어 MeasureSetting, Measure Setting, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9b3c4ed757 | C5 | 다중 그리드 더블클릭 연동 | SSP0014 는 그리드가 spdMain 하나뿐이라 그리드 간 더블클릭 연동이 없다. · 검색어 spdSub, spdDetail, shtSub: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e26c7a94f9 | M1 | Excel Form 버튼 | SSP0014 has no Excel Form button in either the AS-IS or the TO-BE screen. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-99729d6b8b | A5 | 그리드 행 선택용 체크 컬럼(AS-IS CHK 컬럼 + 머리글 전체 체크) | AS-IS Shipment Model PIC 그리드에 CHK 체크 컬럼이 없고 TO-BE에도 행 선택기가 없어서 대상이 아니다. · 검색어 CheckBoxCellType, rowSelection, headerCheckbox: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-76964278ac | E2 | 월 범위 조회조건 기간 역전(시작 > 끝) | SSP0014 조회조건은 Division·From Site·Model·User·Active·Operation Group뿐이고 월 범위 기간 조건이 없다. · 검색어 FromMonth, ToMonth, MSG00344, Period: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-216f8bd161 | G4 | 스냅샷 조회조건 공용 기간 칸 구조·아이콘 | 이 화면 조회조건에는 월 범위 기간 칸이 없다. · 검색어 Period, dtpPeriod, YYYY.MM: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |

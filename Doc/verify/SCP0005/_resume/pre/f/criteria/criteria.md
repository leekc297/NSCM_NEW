# SCP0005 기준 원장 (2026-11-26 01:18:17)

- 원장 1357행 → 기준 항목 1253개 · 요소 103개 · 상태 확정 857 · 대상 아님 371 · 판단 대기 25
- 다른 문서 행 711행: 같은 확인으로 합침 104 · 요소 지정 68 · 화면 전체 140 · 대상 아님(검색 0건 확인) 364 · 판단 대기 24
- TO-BE 룰 결합 347건(인용 불일치로 버림 1) · AS-IS 실측 연결 70건(판단 대기 29) · 사용자의견 고정 0건
- AI 호출 0(기억 38 · 실패 0 · 바꾼 것 없는 호출 0) · 비용 출처 Doc/verify/SCP0005/llm_usage.csv

## 판단 대기(사용자 확인)

| 기준 항목 | 요소 | 규칙 | 확인 | 사유 |
|---|---|---|---|---|
| C-d4a59387d1 | SCREEN | M4 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | AS-IS 소스의 그리드 더블클릭은 Route Id 팝업과 City 팝업만 열고, ITEM_ID Model 팝업은 열지 않습니다. · 검색어가 화면에 있음: ItemByDivision 1곳, SCM0002_ItemByDivisionPopup 1곳 |
| C-36e70abdf6 | SCREEN | F3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | SCP0005 에는 Team 팝업 컬럼과 Project 컬럼이 없다. · 검색어가 화면에 있음: Project 1곳 |
| C-3de86d83a8 | SCREEN | M3 | [DMF0042 결함 유형] Replace 버튼 팝업 Period·조회 | SCP0005 에는 Replace 버튼 팝업과 Period 조건이 없다. · 검색어가 화면에 있음: Replace 3곳 |
| C-c8566de95d | SCREEN | D1 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | Distribution Route 화면에는 ETC 입력과 Team·Measure 컬럼이 없다. · 검색어가 화면에 있음: MEASURE 1곳 |
| C-6ab4119a15 | SCREEN | B5 | [DMF0044 결함 유형] Measure 항목 구성 | SCP0005 에는 Measure 항목 구성이 없다. · 검색어가 화면에 있음: MEASURE 1곳 |
| C-557fe4a9a6 | SCREEN | D2 | [DMF0021 결함 유형] Partial 주차 편집 구간·실적 구분선 | Distribution Route 화면에는 주차 Bucket과 Partial 편집 구간이 없다. · 검색어가 화면에 있음: Partial 3곳, PARTIAL 3곳 |
| C-bc7ea67f38 | SCREEN | M3 | [DMF0053 결함 유형] 팝업 Filter 텍스트 입력창 | SCP0005 의 팝업(Route 이력·도시)에는 Filter 텍스트 입력창이 없다. · 검색어가 화면에 있음: Filter 6곳 |
| C-cc68a294a9 | SCREEN | H5 | [DMF0035 결함 유형] Measure 명칭 MKT FCST[R+P] | Distribution Route 화면에는 Measure 조회조건과 'MKT FCST[R+P]' Measure 명칭이 없습니다. · 검색어가 화면에 있음: Measure 1곳 |
| C-04dccc8044 | SCREEN | D1 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | Distribution Route 그리드에는 Dept 컬럼과 SSO 부서 자동 세팅이 없다. · 검색어가 화면에 있음: Dept 1곳 |
| C-e9596ce74e | SCREEN | H5 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | Distribution Route 화면에는 Dept 컬럼, User 선택 시 SSO DEPT 자동 세팅, Use Y/N 헤더 병합 기능이 없습니다. · 검색어가 화면에 있음: SSO 2곳, Dept 1곳 |
| C-2bfad23d49 | SCREEN | F6 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0005 그리드에는 Dept 컬럼과 SSO DEPT 자동 세팅이 없다. · 검색어가 화면에 있음: Dept 1곳 |
| C-5a056c2473 | SCREEN | D1 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | Distribution Route 그리드에는 ROUTE_PATH 컬럼이 없고 ROUTE_ID만 있다. · 검색어가 화면에 있음: ROUTE_PATH 2곳 |
| C-cf8a5fe480 | SCREEN | G2 | [DMF0005 결함 유형] Project 팝업(그리드) | SCP0005에는 Project 팝업이 없고 도시 검색 팝업(SCM0002)만 있다. · 검색어가 화면에 있음: Project 1곳, PROJECT 1곳 |
| C-b17a71c0fe | SCREEN | A1 | [DMF0082 결함 유형] RTF[R+P] Measure 행 | SCP0005 Distribution Route 화면에는 RTF[R+P] Measure 행이 없습니다. · 검색어가 화면에 있음: Measure 1곳 |
| C-f66f432b7b | SCREEN | G2 | [SCP0028 결함 유형] From Site 조회조건 | SCP0005의 조회조건은 From/To Country·City, Trans Mode, Valid이고 From Site 조회조건은 없다. · 검색어가 화면에 있음: FromSite 1곳 |
| C-2561cf6cd1 | SCREEN | B4 | [SCP0007 결함 유형] To Site 조회조건 콤보 | SCP0005 의 To Site 조회조건 콤보는 AS-IS 에서 주석 처리되어 동작하지 않고 TO-BE 에도 만들지 않았다. · 검색어가 화면에 있음: clbToSite 1곳, ToSiteByDivision 1곳 |
| C-0ba081b8fb | SCREEN | B4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SCP0005 의 Insert 행에는 To Site 콤보가 없고 To Country·To City 는 TOSRCH 팝업으로 입력한다. · 검색어가 화면에 있음: clbToSite 1곳, ToSiteByDivision 1곳 |
| C-800bda12a0 | SCREEN | C3 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SCP0005 에는 To Site 콤보가 없고 To City 는 국가·도시 팝업(SCM0002_CitybyCountry)으로 입력한다. · 검색어가 화면에 있음: To Site 1곳 |
| C-fb70398ec2 | SCREEN | I2 | [DMF0043_01 결함 일반화] Version 팝업 미선택 OK 안내 — 다국어 코드 MSG00701(AS-IS MSG00279) 「버전은 1개만 선택해 주세요.」/「Please select only one ve | SCP0005 소스에는 Version 팝업과 MSG00701 안내가 없다. · 검색어가 화면에 있음: MSG00701 1곳 |
| C-af2de3fdcd | SCREEN | MS1 | [DMF0043_01 결함 일반화] Version 팝업 미선택 OK 안내 — 다국어 코드 MSG00701(AS-IS MSG00279) 「버전은 1개만 선택해 주세요.」/「Please select only one ve | 이 화면에는 Version 팝업이 없고, AS-IS 소스에서 MSG00279도 쓰지 않습니다. · 검색어가 화면에 있음: MSG00279 1곳, MSG00701 1곳 |
| C-a3ca59ee39 | SCREEN | A8 | [결함 유형 묶음 A8-G01 · 2건] 팝업 Spread의 기간 동적 컬럼(YYYYMM) | SCP0005 팝업에는 Period 기간 동적 컬럼이 없다. · 검색어가 화면에 있음: YYYYMM 1곳 |
| C-96c547d0ad | SCREEN | B5 | [결함 유형 묶음 B5-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | SCP0005 신규 행에는 Measure 콤보가 없다. · 검색어가 화면에 있음: MEASURE 1곳 |
| C-1ee690f398 | SCREEN | M3 | [결함 유형 묶음 M3-G04 · 2건] 팝업 Period 기간별 월 컬럼 생성·조회 | SCP0005 팝업에는 Period 조건과 기간별 월 컬럼이 없다. · 검색어가 화면에 있음: YYYYMM 1곳 |
| C-9d91d22d83 | SCREEN | C1 | 조회조건 콤보 cascade(상위 → 하위 후보) | 조회조건 From/To Country·City는 텍스트 입력과 도시 팝업(SCM0002)으로 값을 넣고, Country→City 콤보 cascade는 AS-IS에서 주석으로 막혀 있어 상위→하위 콤보 재구성이 없다. · 검색어가 화면에 있음: clbFromCity 1곳, clbToCity 1곳, CITY_MST 1곳 |
| C-6ccd08f95a | SCREEN | G4 | 스냅샷 조회조건 공용 기간 칸 구조·아이콘 | 기준 정리 답 없음(AI 꺼짐 또는 실패) — 화면 전체로 둠 |
| 실측 | SP:SQL: SELECT * | - | 실측-파싱 대조 SQL: SELECT * | AS-IS 1회 · TO-BE  · INLINE |
| 실측 | SP:SCP0005_GET_DISTRIBUTION_ROUTEID | - | 실측-파싱 대조 SCP0005_GET_DISTRIBUTION_ROUTEID | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | SP:SCP0005_SAVE_DISTRIBUTION_ROUTE | - | 실측-파싱 대조 SCP0005_SAVE_DISTRIBUTION_ROUTE | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | (요소 없음) | - | 실측-파싱 대조 (선언 ↔ 실측) | AS-IS 23개 · TO-BE  · INFO |
| 실측 | (요소 없음) | - | 실측-파싱 대조 BaseRibbonCtl | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 Change | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cbo | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 chkAll | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clb | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 panel1 | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 pnlBaseForm | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 pnlMain | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 statusStripBaseForm | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtTextKeyin | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnToSrch | AS-IS layoutControlItem6 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnFromSrch | AS-IS layoutControlItem7 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cboValidYN | AS-IS Valid · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clbTransMode | AS-IS Trans Mode · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtFromCountry | AS-IS From Country · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtFromCity | AS-IS From City · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtToCountry | AS-IS To Country · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtToCity | AS-IS To City · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnEaxel_Upload | AS-IS layoutControlItem9 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnExcel_Form | AS-IS layoutControlItem10 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 spdMain/Distribution Route | AS-IS 컬럼 40(보임 39) · 헤더 2단 · 행 8076 · 고정 2 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 저장 인자 SCP0005_SAVE_DISTRIBUTION_ROUTE.debug_mode | AS-IS F · TO-BE  · ASIS_ONLY |
| 실측 | COL:FROM_CITY_NAME | - | 저장 인자 SCP0005_SAVE_DISTRIBUTION_ROUTE.from_city_name | AS-IS WINDSOR, CANADA · TO-BE  · DIFF |
| 실측 | COL:PRIORITY | - | 저장 인자 SCP0005_SAVE_DISTRIBUTION_ROUTE.priority | AS-IS 2 · TO-BE 1 · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0005_SAVE_DISTRIBUTION_ROUTE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |

## 대상 아님

| 기준 항목 | 규칙 | 확인 | 근거 |
|---|---|---|---|
| C-03ce2ce9dd | A1 | SCP0005 화면 | TO-BE 룰 CR-105: 값 불일치와 행·키 집합 차이는 판정에서 뺀다(해당없음으로 두고 근거를 표시한다). · SCP0005 조회 결과의 행수·키 집합 비교는 CR-105 에 따라 판정에서 빠집니다. |
| C-cb4c46e6fc | F5 | SCP0005 병합 셀 Delete 범위 | TO-BE 룰 CR-057: Active 컬럼으로 사용여부를 관리하는 화면은 Delete 시 신규행만 제거하고 기존행에 D Flag 를 표시하지 않는다 · Active(VALID_YN) 관리 화면이라 Delete 시 기존행에 D 표시를 하지 않으므로, 병합 전체 행 D 표시는 확인 대상이 아니다. |
| C-faf5093a72 | I1 | SCP0005 시나리오 [자동] CN 언어 조회 건수 총/건 표기 | TO-BE 룰 DD-215: AS-IS: CN 언어 총/건 표기 검사 대상 → TO-BE: 검사 대상 제외(NA) · CN 언어 조회 건수 총/건 표기 시나리오는 사용자 결정으로 검사 대상에서 빠진다. |
| C-a138fdd27f | D4 | SCP0005 Insert 행 Division | TO-BE 룰 CR-028: 신규행의 Div 기본값은 조회조건 Div 로 하고, 조회조건 Div 변경 시 그리드를 초기화하여 이전 Div 행이 남지 않게 한다. · SCP0005 조회조건에는 Division 이 없어 신규행 Div 기본값과 Div 변경 시 그리드 초기화를 확인할 대상이 없습니다. |
| C-50748c62ef | K1 | SCP0005 필터 유지 재조회 | TO-BE 룰 DD-217: AS-IS: 화면별 검사 대상 → TO-BE: 검사 대상 제외(NA) · 사유 사용자 결정 2026-11-06(SCP0016 CheckList 11번) — 공통 기능(공용 DataGrid)이라 화면별 오류 아님 · 재조회 뒤 필터 유지 여부는 공용 DataGrid 공통 기능이라 SCP0005 화면별 검사 대상에서 제외한다. |
| C-54913ed44e | A6 | SCP0005_GET_COUNTRY_CITY | TO-BE 룰 CR-075: ③ 예외: 그리드에 바인딩되지 않는 룩업·보조 SP(countryCity 등)와 결과 1행 집계 SP(routeCnt)는 대상 아님(NA 사유 기재). · SCP0005_GET_COUNTRY_CITY 는 City Name 조회용 룩업 SP 이고 그리드에 바인딩되지 않는다. |
| C-3599eb9072 | D1 | siMain.LockColumn | TO-BE 룰 CR-093: D1 편집 기대는 AS-IS 편집 모드 ON 상태(SwitchLock 뒤 LockColumn/LockRange 결과)를 기준으로 판정한다. · 조회 직후 siMain.LockColumn(0, GetMaxColumnIndex(), true)으로 전체를 잠그는 것은 편집 모드 OFF 상태이므로 TO-BE 판정 대상이 아니다. |
| C-ad03e5f098 | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SCP0005 조회조건에는 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보가 없다. · 검색어 SALES_SITE, END_CUSTOMER, PLANT_SITE, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-9fac350279 | C1 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SCP0005 조회조건에는 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보가 없다. · 검색어 DEPT_ID, SALES_SITE, END_CUSTOMER, Sold to: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3cfc3e1077 | B8 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SCP0005 조회조건에 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보가 없습니다. · 검색어 Sales Site, End Customer, Plant Site, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-f4a2fb4dee | B4 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Customer) | SCP0005 그리드에는 End Customer·Sold-to Customer 셀 콤보가 없다. · 검색어 END_CUSTOMER, SOLD_TO, Sold-to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-15cd7c41cd | K2 | Measure 순서·메저셋팅 순서 저장 | SCP0005 화면에는 메저셋팅이 없어 메저셋팅 순서 저장을 확인할 대상이 없다. · 검색어 Measure Setting, MeasureSetting, measureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-aeb28eea52 | B4 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/Nickname) | SCP0005 조회조건은 From/To Country·City 텍스트 입력, Trans Mode 콤보, Valid 콤보뿐이고 End Customer·Sold to·Sales Site·Model/Nickname 조회조건은 없다. · 검색어 END_CUSTOMER, SOLD_TO, SALES_SITE, Nickname: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-8376b76af3 | J4 | Home / Auth Request 메뉴 | Home / Auth Request 메뉴 화면 표시는 Distribution Route 화면(SCP0005)에 없는 기능이다. · 검색어 Auth Request, AuthRequest, AUTH_REQUEST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-abe946fae4 | A7 | RTF Measure 금액(AMT) 계산 시 적용 LOC(판가) 기준(RTF · AMT · LOC) | SCP0005 에는 RTF Measure 와 AMT 계산 기능이 없다. · 검색어 RTF, DEMAND_LOC, RTF_AMT: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a1f549fe6b | H6 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | 이 화면 그리드에는 ITEM_ID 컬럼이 없고, 셀에서 여는 Model 팝업도 없다. · 검색어 ITEM_ID, ModelPopup, ItemPopup: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-bf0b535ded | J1 | 사용자 Division 권한 콤보 쿼리(DIVISION_ID · 권한 USE_YN) 필터 | SCP0005 에는 사용자 Division 권한 콤보가 없어 권한 USE_YN 필터를 확인할 대상이 없다. · 검색어 DIVISION_ID, cboDivision, divisionId: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-e50f218b6d | A5 | [SYS0002 결함 유형] User 화면 Group 컬럼 | SCP0005에는 User 화면의 Group 컬럼이 없다. · 검색어 DEFAULT_GROUP, Default Group: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-73588fade6 | B6 | [DMF0043_01 결함 유형] 조회조건 Product Group·Biz Type | SCP0005 조회조건에 Product Group·Biz Type 이 없습니다. · 검색어 Product Group, PRODUCT_GROUP, Biz Type, BIZ_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-7d64f8e39a | G2 | [DMF0043_01 결함 유형] 조회조건 Product Group·Biz Type | SCP0005 조회조건에 Product Group·Biz Type이 없다. · 검색어 Product Group, Biz Type, PRODUCT_GROUP, BIZ_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-4c9072c9b7 | B4 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | SCP0005 그리드에는 Sales Site 셀 콤보가 없다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-590f8fa724 | F1 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | SCP0005 화면 그리드에는 Sales Site 셀 콤보가 없다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-1373465175 | F2 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | 이 행이 따로 요구하는 Sales Site 셀 콤보는 SCP0005 에 없고, 저장 성공 후 DB 반영은 C-a4e747bbd3 이 이미 확인한다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b4a797399f | B5 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_MST_CUSTOMER_FCST(_C/_H).MEASURE | SCP0005 에는 CUST_FCST_MEASURE Measure 콤보와 DM_MST_CUSTOMER_FCST 데이터가 없다. · 검색어 CUST_FCST_MEASURE, DM_MST_CUSTOMER_FCST, Customer FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-63288cd2fb | N1 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_MST_CUSTOMER_FCST(_C/_H).MEASURE | SCP0005 화면에는 CUST_FCST_MEASURE Measure Combo가 없다. · 검색어 CUST_FCST_MEASURE, Cutomer FCST, Customer FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-9c32f108ee | M3 | [DMF0005 결함 유형] Team 팝업 | SCP0005 에는 Team 팝업이 없다. · 검색어 TeamPopup, SSO_DEPT, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-1318348ccd | G5 | [DMF0005 결함 유형] Team 팝업 | 이 화면에는 Team 팝업이 없다. · 검색어 SSO_DEPT, TeamPopup, DEPT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-469977929f | C3 | [DMF0005 결함 유형] Team·Owner 컬럼 | SCP0005 그리드에는 Team·Owner 컬럼이 없다. · 검색어 OWNER, TEAM, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a384832584 | F6 | [DMF0005 결함 유형] Team·Owner 컬럼 | SCP0005 그리드에는 Team·Owner 컬럼이 없고, AS-IS 소스와 TO-BE 화면 폴더에서도 검색되지 않는다. · 검색어 Team, Owner, OWNER_ID: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b836a4e306 | F1 | [DMF0005 결함 유형] 하단 Purchase 탭 EDI Incoterms | SCP0005 화면에는 Purchase 탭과 EDI Incoterms 컬럼이 없다. · 검색어 Incoterms, EDI_INCOTERMS: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-d6b5cb0e84 | E3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | SCP0005 그리드에는 Team 팝업 컬럼과 Project 컬럼이 없다. · 검색어 Team, TEAM_CODE, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-6bc10547c5 | D1 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | Distribution Route 그리드에는 Team 팝업 컬럼과 Project 컬럼이 없다. · 검색어 TEAM_CODE, TEAM_NAME, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-98d050743f | B4 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SCP0005 에는 Team 조회조건과 Team/End Customer/Sales Site 그리드 콤보가 없다. · 검색어 TEAM, DEPT_ID, END_CUSTOMER: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-21dab69c64 | C1 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SCP0005 조회조건과 그리드에는 Team·End Customer·Sales Site 콤보가 없다. · 검색어 DEPT_ID, TEAM, END_CUSTOMER, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-1610dd6733 | B2 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SCP0005 Distribution Route 화면에는 조회조건 Team과 그리드 End Customer·Sales Site 콤보가 없고, AS-IS 소스와 TO-BE 화면 폴더에서 검색해도 0건이다. · 검색어 DEPT_ID, END_CUSTOMER, End Customer, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a7e534481b | B8 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SCP0005 에는 Team 조회조건과 Team·End Customer·Sales Site 그리드 콤보가 없습니다. · 검색어 DEPT_ID, Team, End Customer, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-5d77ee3a3c | D2 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | Distribution Route 화면에는 Monthly Bucket 입력과 Project Code/Model 팝업이 없다. · 검색어 Monthly, BUCKET, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-4eef63da8b | F6 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SCP0005에는 Monthly Bucket 입력과 Project Code/Model 팝업이 없고, AS-IS 소스와 TO-BE 화면 폴더에서도 Monthly·Project Code가 검색되지 않는다. · 검색어 Monthly, Project Code, PROJECT_CODE, Bucket: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-509419428c | F4 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | AS-IS 소스와 TO-BE 화면 폴더 모두에 Monthly Bucket 입력과 Project Code/Model 팝업이 없다. · 검색어 Bucket, MonthlyBucket, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-f16ec1f439 | M3 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SCP0005 Distribution Route 화면에는 Monthly Bucket 입력 셀과 Project Code·Model 팝업이 없습니다. · 검색어 Monthly, Bucket, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-dc8c03535a | A2 | [DMF0020 결함 유형] 조회 건수 · Team 컬럼 표시 · 컬럼팝업 저장 설정 | A2 로 확인할 대상인 Team 컬럼의 이름 표시가 SCP0005 화면에 없습니다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a619105858 | J2 | [DMF0020 결함 유형] Price Batch Input 버튼 | SCP0005 에는 Price Batch Input 버튼이 없다. · 검색어 Price Batch Input, PRICE_BATCH, btnPriceBatch: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-0f8e984a8c | K4 | [DMF0020 결함 유형] Price Batch Input 버튼 | Price Batch Input 버튼은 SCP0005 버튼 목록에 없다. · 검색어 Price Batch Input, PRICE_BATCH, PriceBatch: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-1df970366d | G4 | [DMF0020 결함 유형] 조회조건 Project | SCP0005 조회조건에 Project와 Div 40 분기가 없다. · 검색어 cboProject, PROJECT_ID, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-2543c87b62 | G4 | [DMF0068 결함 유형] Main Version 조회조건 크기 · Version 팝업 Description 컬럼 폭 | SCP0005에는 Main Version 조회조건과 Version 팝업이 없다. · 검색어 MAIN_VERSION, Main Version, cboVersion: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a2f0b21fe7 | H6 | [DMF0068 결함 유형] Main Version 조회조건 크기 · Version 팝업 Description 컬럼 폭 | 이 화면에는 Main Version 조회조건과 Version 팝업이 없다. · 검색어 MainVersion, VersionPopup, Main Version: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-e1b8d04a24 | B4 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer 콤보 | SCP0005 그리드에는 End Customer·Sold to Customer 콤보가 없다. · 검색어 END_CUSTOMER, SOLD_TO, Sold to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-d55c602eda | B7 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer 콤보 | SCP0005 그리드에 End Customer·Sold to Customer 콤보가 없습니다. · 검색어 End Customer, END_CUSTOMER, Sold to Customer, SOLD_TO: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-eb820f017a | C2 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | SCP0005 그리드에는 Cust Group·End Customer·Sales Site 컬럼이 없다. · 검색어 CUST_GROUP, END_CUSTOMER, Cust Group: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-9ec29961b0 | B2 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | SCP0005 그리드에는 Cust Group→End Customer→Sales Site로 이어지는 연동(cascade) 콤보가 없다. · 검색어 CUST_GROUP, Cust Group, END_CUSTOMER, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-883d8e865c | K1 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | Cust Group→End Customer→Sales Site 연쇄 선택 컬럼은 SCP0005 그리드에 없다. · 검색어 CUST_GROUP, END_CUSTOMER, SALES_SITE, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-0cd965c71e | E4 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Active 컬럼 | SCP0005 화면에는 Cust Group·End Customer·Sales Site 관계 컬럼이 없다. · 검색어 End Customer, CUST_GROUP, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3e915fee2e | C2 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Active 컬럼 | SCP0005 그리드에는 Cust Group·End Customer·Sales Site 관계 컬럼이 없다. · 검색어 CUST_GROUP, END_CUSTOMER, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-5c35500e79 | B4 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | SCP0005 에는 Team·End Customer·Sales Site 후보가 없다. · 검색어 DEPT_ID, END_CUSTOMER, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-9d5b79b47c | C1 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | SCP0005에는 Team·End Customer·Sales Site 후보 콤보가 없다. · 검색어 TEAM, END_CUSTOMER, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-5e2106149a | M1 | [DMF0014 결함 유형] Excel Form 입력 버킷 | SCP0005 조회조건과 Excel Form 에는 Period·버킷 항목이 없다. · 검색어 Main Period, BUCKET, PERIOD_FROM: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a54edabba5 | H2 | [DMF0003 결함 일반화] 실적 구간 배경색 | SCP0005 는 기간 컬럼이 없는 마스터 화면이라 실적 구간 회색 표시 대상이 없다. · 검색어 ACTUAL, isActual: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-e514040480 | D2 | [DMF0003 결함 일반화] 실적 구간 배경색 | Distribution Route 그리드에는 기간 Bucket과 실적 구간이 없다. · 검색어 ACTUAL, Actual: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a600aead6f | C2 | [DMF0003 결함 유형] AS From Site 입력 후 W35~W38 수량 | SCP0005 그리드에는 AS From Site 셀과 주차별 수량 컬럼이 없다. · 검색어 AS_FROM_SITE, From Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3e1877815b | B8 | [DMF0003 결함 일반화] Team 컬럼(MKT FCST 조회·신규행) | SCP0005 그리드에 Team 컬럼이 없습니다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-21bfd18869 | A2 | [DMF0003 결함 일반화] Team 컬럼(MKT FCST 조회·신규행) | SCP0005 화면에는 Team 컬럼이 없습니다. · 검색어 DEPT_ID, Team, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-0bf757315c | G5 | [DMF0003 결함 유형] Model 팝업(sMdmActive_Sw) | 이 화면에는 Model 팝업과 MDM 중지 코드 인자가 없다. · 검색어 sMdmActive_Sw, MdmActive, ModelPopup: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-5b1660b903 | M3 | [DMF0003 결함 유형] Model 팝업(sMdmActive_Sw) | SCP0005 에는 Model 팝업과 sMdmActive_Sw 파라미터가 없다. · 검색어 sMdmActive_Sw, ModelPopup: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-54a889e6e9 | J1 | [DMF0003 결함 일반화] Division 조회조건 후보 | SCP0005 조회조건은 From/To Country·City, Trans Mode, Valid 이고, Division 콤보는 AS-IS 에서 주석 처리된 미사용 코드라 Division 후보 확인 대상이 없다. · 검색어 DIVISION_ID, cboDivision, divisionId: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-d768986059 | B5 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | SCP0005 에는 FCST Type 콤보와 Measure 입력이 없다. · 검색어 FCST_TYPE, FCST Type: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a1dc243e17 | D3 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | SCP0005 화면에는 FCST Type 콤보와 Measure 입력 컬럼이 없습니다. · 검색어 FCST_TYPE, FCST Type, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3619e86164 | A5 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SCP0005 그리드에는 VERSION 컬럼과 AS FROM SITE 컬럼이 없다. · 검색어 AS_FROM_SITE, AS FROM SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-d84bbb1ad1 | K2 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SCP0005 화면에는 VERSION 컬럼과 AS FROM SITE 컬럼이 없다. · 검색어 AS_FROM_SITE, AS FROM SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-703cb6ab9f | N1 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SCP0005 화면에는 AS FROM SITE 컬럼과 VERSION 컬럼셋팅 항목이 없다. · 검색어 AS_FROM_SITE, AS FROM SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-8da686c097 | E1 | [DMF0082 결함 유형] MKT_FCST[R+P]·AS_In_Request[R+P]·Unit_Price(LOC) | SCP0005 그리드에는 MKT_FCST·AS_In_Request·Unit_Price(LOC) 컬럼이 없다. · 검색어 MKT_FCST, AS_In_Request, Unit_Price: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-7140403ffa | M3 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | SCP0005 에는 Price Batch Input 팝업과 End Customer 컬럼이 없다. · 검색어 Price Batch Input, PriceBatch, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ca4514ba75 | H3 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | SCP0005 에는 Price Batch Input 팝업과 End Customer 컬럼이 없다. · 검색어 Price Batch, END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-95ba294504 | G4 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | SCP0005에는 Price Batch Input 팝업과 End Customer 컬럼이 없다. · 검색어 Price Batch, END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b67c87b361 | M3 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SCP0005 에는 Exchange Rate 팝업 저장 기능이 없다. · 검색어 Exchange Rate, ExchangeRate: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-578f7afd09 | F4 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | AS-IS 소스와 TO-BE 화면 폴더 모두에 Exchange Rate 팝업이 없다. · 검색어 ExchangeRate, Exchange Rate: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-2830537ecc | F3 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SCP0005 에는 Exchange Rate 팝업 저장 기능이 없다. · 검색어 Exchange Rate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-621eb22c4a | F1 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SCP0005 화면에는 Exchange Rate 팝업이 없다. · 검색어 Exchange Rate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-7f210bce62 | M2 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | SCP0005 화면에는 BPS I/F 버튼과 환율 반영 기능이 없다. · 검색어 BPS I/F, btnBps, BPS_IF: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-77437dba3a | F1 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | SCP0005 에는 BPS I/F 버튼과 환율 반영 기능이 없다. · 검색어 BPS, Exchange Rate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a31269d697 | E4 | [DMF0082 결함 유형] Biz Type 미존재 검증 팝업 메시지 | SCP0005 화면에는 Biz Type 검증 팝업이 없다. · 검색어 BIZ_TYPE, Biz Type: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-5ad4539d54 | E1 | [DMF0082 결함 유형] QTY ≥ 0 검증 | SCP0005 그리드에는 수량(QTY) 컬럼이 없고 음수 차단은 Lead Time·Priority 컬럼 기준 항목에서 따로 확인한다. · 검색어 QTY, ORDER_QTY: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-0eebe0a143 | F6 | [DMF0082 결함 일반화] 필수 컬럼(Project Code·Plant Site) 표시 · 저장 | SCP0005 그리드는 모든 Division에서 같은 39개 컬럼이고, Project Code·Plant Site 필수 컬럼도 없다. · 검색어 Project Code, PROJECT_CODE, Plant Site, PLANT_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-682a78f626 | A5 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SCP0005에는 Measure 셋팅과 VMI·MKT FCST AMT 메저가 없다. · 검색어 VMI, MKT_FCST_AMT, MKT FCST AMT: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-74339de160 | K2 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SCP0005 화면에는 Measure 셋팅이 없고 VMI·MKT FCST AMT 메저도 없다. · 검색어 VMI, MKT FCST, Measure Setting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ac1def99cd | N1 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SCP0005 화면에는 VMI 메저와 MKT FCST AMT 같은 Measure 셋팅이 없다. · 검색어 VMI, MKT_FCST, MKT FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3c52253b0e | B5 | [DMF0082 결함 유형] SCM_FCST·MKT_FCST 편집 구간(GET_ADMIN_GROUP_MEASURE) | SCP0005 에는 SCM_FCST·MKT_FCST 편집 구간이 없다. · 검색어 GET_ADMIN_GROUP_MEASURE, MKT_FCST, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-021c430a91 | N1 | [DMF0007 결함 유형] Customer FCST Master 기준정보 | SCP0005 화면은 Customer FCST Master 기준정보를 조회하지 않는다. · 검색어 Customer FCST, CUST_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-bff36d11ef | A1 | [DMF0007 결함 유형] Customer FCST Master 기준정보 | SCP0005 화면은 Customer FCST Master 기준정보를 조회하지 않습니다. · 검색어 Customer FCST, FCST_MASTER, CUSTOMER_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a449efe612 | B4 | [DMF0004 결함 유형] Sales Site 조회조건 표시값 | SCP0005 에는 Sales Site 조회조건이 없다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-f79b0f6326 | C3 | [DMF0005 결함 일반화] Sales Company·Sales Plant 셀 | SCP0005 그리드에는 Sales Company·Sales Plant 셀이 없다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Company, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-4b6423ccea | C2 | [DMF0005 결함 일반화] Sales Company·Sales Plant 셀 | SCP0005 그리드에는 Sales Company·Sales Plant 셀이 없다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Company: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-078ca141d5 | D4 | [DMF0004 결함 일반화] Insert 행 Div · Div 변경 시 그리드 | SCP0005 조회조건에 Division 이 없어 신규행 Div 기본값과 Div 변경 시 그리드 초기화가 해당하지 않습니다. · 검색어 DIVISION_CODE, cboDivision, p_division: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-1f04f39038 | C4 | [DMF0004 결함 일반화] Insert 행 Div · Div 변경 시 그리드 | SCP0005 조회조건에 Div 가 없다(AS-IS 의 Division 코드는 주석 처리됐고 TO-BE 에서도 만들지 않는 미사용 콤보로 분류됐다). · 검색어 DIVISION_ID, cboDivision: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-2ea35ecc70 | A5 | [DMF0004 결함 일반화] Insert 행 Div · Div 변경 시 그리드 | SCP0005에는 Div 조회조건이 없고 Insert 행에도 Div 컬럼이 없다(AS-IS Division 콤보는 주석 처리된 코드). · 검색어 DIVISION_ID, cboDivision, DIV_CD: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-c11679b9e4 | F4 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | AS-IS 소스와 TO-BE 화면 폴더 모두에 RTF×Unit Price 계산값이 없다. · 검색어 UNIT_PRICE, Unit Price, RTF: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ffebf22835 | E1 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | SCP0005 Distribution Route 그리드에는 RTF×Unit Price 계산 컬럼이 없고 AS-IS 소스와 TO-BE 화면 폴더에서 RTF·UNIT_PRICE 가 검색되지 않는다. · 검색어 RTF, Unit Price, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-6eb2265bc9 | E4 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | SCP0005 Distribution Route 화면에는 RTF×Unit Price 계산값 저장 기능이 없다. · 검색어 UNIT_PRICE, Unit Price, RTF: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-9c577f70bc | E4 | [DMF0044 결함 유형] Cell Prod Site 검증 · Application Gr·Country Name | SCP0005 화면에는 Cell Prod Site·Application Gr 컬럼이 없다. · 검색어 Cell Prod Site, CELL_PROD_SITE, Application Gr: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-d5bb9463ef | F1 | [DMF0044 결함 유형] Cell Prod Site 검증 · Application Gr·Country Name | SCP0005 화면에는 Cell Prod Site 와 Application Gr 컬럼이 없다. · 검색어 Cell Prod Site, CELL_PROD_SITE, Application Gr: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3f94077c0d | C1 | [DMF0044 결함 유형] 조회조건 Report Type→Data Type | SCP0005 조회조건에는 Report Type·Data Type 조건이 없다. · 검색어 REPORT_TYPE, Report Type: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-557f4b2796 | K4 | [DMF0044 결함 유형] Delete 버튼 | Cutoff Data 상태에 따라 Delete 버튼을 숨기는 기능은 SCP0005 화면 요소 목록에 없다. · 검색어 Cutoff, CUTOFF, CUT_OFF: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-44b78098d3 | J2 | [DMF0044 결함 유형] Delete 버튼 | SCP0005 에는 Cutoff Data 상태가 없어 Delete 버튼의 Cutoff 조건 확인 대상이 없다. · 검색어 Cutoff, CUTOFF_YN, CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-6dd9bc599b | F1 | [DMF0044 결함 유형] Biz Plan Cutoff Data 저장 값 | SCP0005 화면에는 Biz Plan Cutoff Data 컬럼이 없다. · 검색어 Cutoff, Biz Plan, BIZ_PLAN: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-360952155e | D2 | [DMF0044 결함 유형] 입력 가능 Measure(Business Plan·Unit Price(LOC)) | Distribution Route 화면에는 Business Plan·Unit Price(LOC) Measure가 없다. · 검색어 Business Plan, BUSINESS_PLAN, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-75966756d7 | G5 | [DMF0044 결함 유형] Version 팝업 Div 조건 | 이 화면에는 Version 팝업이 없다. · 검색어 VersionPopup, VERSION_ID, cboVersion: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3356d33f9e | E4 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | SCP0005 화면에는 하단 Owner 그리드가 없고 단일 그리드(spdMain)만 있다. · 검색어 OWNER, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-8e1f031e2d | F1 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | SCP0005 는 단일 그리드 화면이라 하단 Owner 그리드가 없다. · 검색어 Owner, OWNER_ID, OWNER: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-50c2a05c44 | C5 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | SCP0005 에는 하단 그리드와 Owner 컬럼이 없고 그리드는 spdMain 하나뿐이다. · 검색어 OWNER, spdSub, spdDetail: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-6b26bc2e1f | D1 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | Distribution Route 화면에는 Exchange Rate의 Currency 컬럼이 없다. · 검색어 CURRENCY, Exchange Rate, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-35e8e8fe73 | E4 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | SCP0005 화면에는 Exchange Rate 의 Currency 컬럼이 없다. · 검색어 Exchange Rate, EXCHANGE_RATE, CURRENCY: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b489d98d4d | D6 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | SCP0005 화면에는 Exchange Rate 의 Currency 컬럼과 중복 Keyset 확인이 없습니다. · 검색어 Exchange Rate, EXCHANGE_RATE, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-0cd8898176 | K4 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | Exchange Rate 그리드와 Currency 컬럼은 SCP0005 화면 요소 목록에 없다. · 검색어 Exchange Rate, EXCHANGE_RATE, CURRENCY, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-026c28cd24 | A5 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | SCP0005에는 Cust Group 조회조건과 Div 파라미터가 없다. · 검색어 CUST_GROUP, Cust Group: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-43e0c84df7 | G4 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | SCP0005에는 Cust Group 조회조건과 Div에 따른 그리드 헤더 재구성이 없다. · 검색어 CUST_GROUP, Cust Group, cboCustGroup: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-edb879c1cb | G1 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | SCP0005 조회조건은 From/To Country·City, Trans Mode, Valid뿐이고 Cust Group 조회조건과 Div 파라미터 그리드 헤더는 없습니다. · 검색어 CUST_GROUP, CustGroup, Cust Group: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-0908ee78b0 | G1 | [DMF0005 결함 유형] Owner 팝업(PKG_COM0000 COM0004/0006) User 조회조건 | SCP0005에는 Owner 팝업(COM0004/COM0006)과 User 조회조건이 없고, 팝업은 도시 검색 팝업뿐입니다. · 검색어 PKG_COM0000, COM0004, COM0006, OwnerPopup: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-2ec64bb40b | M2 | [DMF0042 결함 유형] Replace 버튼 팝업 Period·조회 | SCP0005 화면에는 Replace 버튼과 Period 를 넘겨받는 팝업이 없다. · 검색어 btnReplace, Replace Popup, ReplacePopup: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-9655ee4f9b | G5 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | 이 화면에는 Ver.Cutoff 팝업이 없다. · 검색어 Cutoff, VerCutoff, CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-c20089efe4 | G4 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | SCP0005에는 Ver.Cutoff 팝업이 없고, 팝업은 도시검색(SCM0002)과 Route 이력 팝업뿐이다. · 검색어 Cutoff, Ver.Cutoff, VERSION_CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-14efc1598f | H6 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | 이 화면에는 Ver.Cutoff 팝업과 Period·Div/Type 조회조건이 없다. · 검색어 Cutoff, VerCutoff, Ver.Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-23cb950abf | H4 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | 이 화면에는 Ver.Cutoff 팝업과 Period·Description·Div/Type 조회조건이 없다. · 검색어 Cutoff, VerCutoff, Ver.Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a4dd15db35 | M3 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SCP0005 에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 Version Create, BP Version, VersionCreate: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-c89493a509 | M2 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SCP0005 화면에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 Version Create, BP Version, btnVersionCreate: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-036fd9edd3 | E4 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SCP0005 화면에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 Version Create, BP Version, VERSION_CREATE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-5e2de9b063 | F1 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SCP0005 화면에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 Version Create, BP Version: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-f70374fe33 | B3 | [DMF0049 결함 유형] 버전 팝업 Version 목록 정렬 | SCP0005 화면에는 버전 팝업과 Version 목록이 없다. · 검색어 VersionPopup, VERSION_ID, Version: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-96919d617b | M3 | [DMF0049 결함 유형] 버전 팝업 Version 목록 정렬 | SCP0005 에는 버전 팝업과 Version 목록이 없다. · 검색어 VersionPopup, Version: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-589fd17ed5 | G4 | [DMF0049 결함 유형] Version 조회조건 선택값 표시 | SCP0005 조회조건에 Version 선택값 표시 대상이 없다. · 검색어 cboVersion, VERSION_ID, PLAN_VERSION: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-72bcf855dd | G7 | [DMF0049 결함 유형] Version 조회조건 선택값 표시 | 이 화면에는 조회조건 Version이 없다. · 검색어 cboVersion, VERSION_ID, VersionName: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a8a834e0cf | I3 | [DMF0014 결함 유형] Team 명칭 데이터 | SCP0005 화면에는 Team 명칭 데이터가 없다. · 검색어 TEAM, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-7151ee70c1 | B4 | [DMF0014 결함 유형] Team 조회조건 후보 | SCP0005 에는 Team 조회조건이 없다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-5d3dbc2380 | J1 | [DMF0014 결함 유형] Team 조회조건 후보 | SCP0005 조회조건에는 Team 콤보가 없다. · 검색어 TEAM_ID, cboTeam, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3c852159f3 | G1 | [DMF0020 결함 유형] Biz.Type 조회조건 | SCP0005 조회조건에는 Biz.Type이 없습니다. · 검색어 BIZ_TYPE, Biz.Type, BizType: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-691222a07f | M3 | [DMF0020 결함 유형] Price Batch Input 팝업 Sales Site 조건 | SCP0005 에는 Price Batch Input 팝업과 Sales Site 조건이 없다. · 검색어 Price Batch Input, PriceBatch, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-4c55c5061f | E3 | [DMF0014 결함 유형] Excel Upload OK·Customs Handbook/Project/Model 검증 | SCP0005 Excel Upload 대상에는 Customs Handbook·Project·Model 항목이 없다. · 검색어 Customs Handbook, Handbook, MODEL_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b46bf4a644 | M1 | [DMF0014 결함 유형] Excel Upload 수량 미입력 메시지 | SCP0005 Excel Upload 양식에는 수량(QTY) 컬럼이 없다. · 검색어 Please Input QTY, QTY: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ecf5c88d92 | M1 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Validation 메시지 | SCP0005 Excel Upload 양식에는 Key 영역과 Period From/To 컬럼이 없다. · 검색어 PERIOD_FROM, Period From, PERIOD_TO, Period To: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-198b9e8867 | F1 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Validation 메시지 | SCP0005 Excel Upload 에는 Key 영역과 Period From/To 컬럼이 없다. · 검색어 PERIOD_FROM, Period From, PERIOD_TO: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ed5498d641 | M1 | [DMF0082 결함 유형] Excel Form 양식 Bucket | SCP0005 Excel Form 양식에는 Monthly Bucket 과 M0~M12 컬럼이 없다. · 검색어 Monthly, BUCKET_TYPE, M12: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-0cc096b127 | B4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SCP0005 에는 ETC 입력 Team·Measure 컬럼이 없다. · 검색어 DEPT_ID, Sales AMT, SALES_AMT_LOC: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-9f72d5fc7d | E3 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SCP0005 그리드에는 Team·Sales AMT(LOC) Measure 입력 컬럼이 없다. · 검색어 Team, TEAM_CODE, Sales AMT: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-d346b3e901 | D4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SCP0005 화면에는 ETC 입력용 Team 컬럼과 Measure 컬럼이 없습니다. · 검색어 SSPM, Sales AMT, TEAM_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-d1b26877c5 | A1 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | SCP0005 화면에는 Dynamic Query 기능이 없습니다. · 검색어 Dynamic Query, KWh, DYNAMIC_QUERY: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-25b1b46038 | H4 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | 이 화면에는 Dynamic Query 기능이 없다. · 검색어 DynamicQuery, Dynamic Query, KWh: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-d56ef512de | F4 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | AS-IS 소스와 TO-BE 화면 폴더 모두에 Dynamic Query 기능이 없다. · 검색어 DynamicQuery, Dynamic Query, KWh: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-2de6c3d277 | F8 | [SYS0012 결함 유형] Request 데이터 Reject Reason·Request Date | SCP0005에는 Reject Reason·Request Date 컬럼과 재요청 흐름이 없다. · 검색어 REJECT_REASON, Reject Reason, REQUEST_DATE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-150296c61e | B4 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SCP0005 에는 Approval Result 조회조건이 없다. · 검색어 APPROVAL_RESULT, Approval Result, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-4359e8c5fe | B6 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SCP0005 조회조건에 Approval Result 콤보가 없습니다. · 검색어 Approval Result, APPROVAL_RESULT, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-05bda3b426 | I2 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SCP0005 화면에는 Approval Result 조회조건 콤보가 없다. · 검색어 APPROVAL_RESULT, Approval Result, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-4f1727f8a9 | G4 | [DMF0040 결함 유형] Version 조회조건 크기 | SCP0005 조회조건에 Version이 없다. · 검색어 cboVersion, VERSION_ID, PLAN_VERSION: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b62afe0253 | H5 | [DMF0040 결함 유형] Measure Version(A)/Version(B) 명칭 | Distribution Route 화면에는 Version(A)/Version(B) Measure 명칭이 없습니다. · 검색어 Version(A), Version(B), VERSION_A: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-f3789bdc4a | A9 | [DMF0040 결함 유형] Measure Version(A)/Version(B) 명칭 | SCP0005 에는 Version(A)/Version(B) Measure 가 없다. · 검색어 Version(A), Version(B), VERSION_A: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-75330d0139 | H2 | [DMF0040 결함 유형] 실적 구간 배경색 | SCP0005 는 기간 축이 없는 운송 경로 마스터 화면이라 실적 구간이 없다. · 검색어 ACTUAL, isActual: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-5967830327 | C3 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | SCP0005 그리드에는 Sales Site·End Customer 셀이 없다. · 검색어 END_CUSTOMER, End Customer, SALES_SITE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ab3a38d078 | D1 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | Distribution Route 그리드에는 Sales Site·End Customer 셀이 없다. · 검색어 END_CUSTOMER, End Customer, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-47e2454852 | G4 | [DMF0044 결함 유형] Year 조회조건 | SCP0005 조회조건에 Year가 없다. · 검색어 cboYear, PLAN_YEAR, dtpYear: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-fef7aadf16 | G6 | [DMF0044 결함 유형] Year 조회조건 | 이 화면에는 조회조건 Year가 없다. · 검색어 cboYear, PLAN_YEAR, selectedYear: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3d9b68544c | A5 | [DMF0044 결함 유형] Measure 항목 구성 | SCP0005 는 고정 컬럼 그리드(spdMain)만 쓰며 UI Category 기준 Measure 항목 구성 기능이 없다. · 검색어 MEASURE_CD, UI_CATEGORY, MeasureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-607d7dfb28 | N1 | [DMF0044 결함 유형] Measure 항목 구성 | SCP0005 화면은 정적 컬럼 구성이고 Div별 UI Category 기준 Measure 항목이 없다. · 검색어 MEASURE_CODE, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-980f583469 | M3 | [DMF0005 결함 유형] Owner 팝업 사용자 목록 | SCP0005 에는 Owner 팝업이 없다. · 검색어 OwnerPopup, Owner, SSO_USER: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-d110b0ab31 | B4 | [DMF0005 결함 유형] Owner 팝업 사용자 목록 | SCP0005 에는 Owner 사용자 팝업이 없다. · 검색어 SSO_USER, SCM_ADM_USER_M, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-c39deb8f43 | H2 | [DMF0021 결함 유형] Partial 주차 편집 구간·실적 구분선 | SCP0005 에는 주차·파셜 구간이나 실적 구분선이 없다. · 검색어 PARTIAL_WEEK, M-1: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-f4f4582aa7 | A5 | [DMF0003 결함 유형] Measure 컬럼 | SCP0005 Distribution Route 그리드에는 Measure 컬럼이 없다(정적 39컬럼, SHEET_MEASURE 0건). · 검색어 MEASURE_CODE, MEASURE_ID, MEASURE_CD: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-bef8a5abca | J1 | [DMF0003 결함 유형] FCST Type 후보 | SCP0005 에는 FCST Type 조회조건이 없다. · 검색어 FCST_TYPE, FCST Type, WS(Free): AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-d6dc6a5a30 | I3 | [DMF0040 결함 유형] Team 조회조건 vs 결과 컬럼 언어 | SCP0005 화면에는 Team 조회조건과 Team 결과 컬럼이 없다. · 검색어 TEAM, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-c0a55dd6b9 | G4 | [DMF0040 결함 유형] Ver. 조회조건 기본값 | SCP0005 조회조건에 Ver. 콤보가 없다. · 검색어 cboVersion, VERSION_ID, PLAN_VERSION: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b0671058d4 | G6 | [DMF0040 결함 유형] Ver. 조회조건 기본값 | 이 화면에는 조회조건 Ver.가 없다. · 검색어 cboVersion, VERSION_ID, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-6befe450eb | F4 | [DMF0040 결함 유형] Plant Site 조회조건 | AS-IS 소스와 TO-BE 화면 폴더 모두에 Plant Site 조회조건이 없다. · 검색어 PlantSite, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-64f3ebf911 | G1 | [DMF0040 결함 유형] Plant Site 조회조건 | SCP0005 조회조건에는 Plant Site가 없습니다. · 검색어 PLANT_SITE, Plant Site, PlantSite: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-09911de908 | K2 | [DMF0040 결함 유형] Measure Setting 버튼 | SCP0005 화면에는 Measure Setting 버튼이 원래 없다. · 검색어 Measure Setting, MeasureSetting, measureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-46866df082 | J2 | [DMF0040 결함 유형] Measure Setting 버튼 | SCP0005 에는 Measure Setting 버튼이 없다. · 검색어 Measure Setting, MEASURE_SETTING, btnMeasureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b9ebd31bb2 | G4 | [DMF0040 결함 유형] Plant Site 조회조건 | SCP0005 조회조건에 Plant Site와 ESS 구분이 없다. · 검색어 PLANT_SITE, Plant Site, PlantSite: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-4681853c9b | B4 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | SCP0005 에는 Biz Type·Plant Site 조회조건이 없다. · 검색어 BIZ_TYPE, Biz Type, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-1244b84951 | G1 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | SCP0005 조회조건에는 Biz Type·Plant Site가 없습니다. · 검색어 BIZ_TYPE, Biz Type, PLANT_SITE, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-80b4ae1b49 | D2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | Distribution Route 화면에는 Current 버전 입력 Measure와 AS From Site 콤보가 없다. · 검색어 AS_In_Req, VMI_In_Req, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-245e34db7f | J3 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0005 에는 MKT_FCST·SCM_FCST·AS_In_Req·VMI_In_Req 입력 Measure 가 없다. · 검색어 AS_In_Req, VMI_In_Req, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-0c0a301b42 | D3 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0005 화면에는 Current 버전 입력 Measure 와 AS From Site 콤보가 없습니다. · 검색어 MKT_FCST, SCM_FCST, AS From Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ce731d8c96 | B5 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0005 에는 MKT_FCST·SCM_FCST·AS_In_Req·VMI_In_Req Measure 와 AS From Site 콤보가 없다. · 검색어 MKT_FCST, SCM_FCST, AS_In_Req, VMI_In_Req: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ac174070d7 | B4 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0005 에는 MKT_FCST·SCM_FCST·AS_In_Req·VMI_In_Req Measure 와 AS From Site 콤보가 없다. · 검색어 MKT_FCST, SCM_FCST, AS_In_Req, VMI_In_Req: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-470526884a | C2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0005 그리드에는 Measure 행과 AS From Site 콤보가 없다. · 검색어 MKT_FCST, SCM_FCST, AS_IN_REQ, VMI_IN_REQ: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b3d45e76a3 | B4 | [DMF0082 결함 유형] FCST Type 후보 | SCP0005 에는 FCST Type 후보가 없다. · 검색어 SALES_TYPE_CODE, FCST_TYPE, FCST Type: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3a3ada83a5 | N1 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site ID | SCP0005 화면에는 MKT_FCST, Unit Price(LOC), Plant Site ID 입력이 없다. · 검색어 MKT_FCST, Unit Price, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a62505be58 | F1 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site ID | SCP0005 화면에는 MKT_FCST, Unit Price(LOC), Plant Site ID 컬럼이 없다. · 검색어 MKT_FCST, PLANT_SITE_ID, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-31fc5596af | F4 | [DMF0082 결함 유형] Bucket 전환 후 저장 | AS-IS 소스와 TO-BE 화면 폴더 모두에 Bucket 전환 기능이 없다. · 검색어 Bucket, BUCKET: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a580641f09 | M3 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SCP0005 에는 Exchange Rate 팝업이 없고, Route Id 이력 팝업은 편집할 수 없는 조회 전용 팝업이다. · 검색어 Exchange Rate, ExchangeRate, BPS: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-7269f0cafb | F2 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SCP0005 에는 Exchange Rate 팝업이 없고, Route Id 더블클릭으로 여는 SCP0005_DistributionRoutePopup 은 편집·저장 기능이 없는 이력 조회 팝업이다. · 검색어 Exchange Rate, EXCHANGE_RATE, BPS: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-1ab78c6c2f | M2 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SCP0005 AS-IS 소스와 TO-BE distribution-route 폴더 어디에도 Exchange Rate 팝업과 BPS I/F 기능이 없다. · 검색어 Exchange Rate, ExchangeRate, BPS I/F: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-e2545b60c7 | M4 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | 이 화면에는 Exchange Rate 팝업이 없습니다. · 검색어 ExchangeRate, EXCHANGE_RATE, Exchange Rate: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-6849516a2a | D2 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | Distribution Route 화면에는 RTF[R+P] Measure와 Cutoff 상태가 없다. · 검색어 RTF, Cutoff, CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a06a3dcc1e | J3 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | SCP0005 에는 RTF[R+P] Measure 와 Cutoff 기반 편집 조건이 없다. · 검색어 GET_ADMIN_GROUP_MEASURE, Cutoff, CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-cf4d50a787 | E4 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | SCP0005 화면에는 RTF[R+P] 편집과 Cutoff 상태 조건이 없다. · 검색어 Cutoff, GET_ADMIN_GROUP_MEASURE, RTF[R+P]: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a101deaf9b | E4 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SCP0005 화면에는 FCST Type=ETC 의 Text 필수 검증 기능이 없다. · 검색어 FCST_TYPE, FCST Type: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-54cdb4df2f | F6 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SCP0005에는 FCST Type=ETC 구분과 Text 필수 검증이 없다. · 검색어 FCST_TYPE, FCST Type, ETC_TEXT: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-7ac75a3c7d | F1 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SCP0005 화면에는 FCST Type 과 ETC 테이블에 걸린 Text 필수 검증이 없다. · 검색어 FCST Type, FCST_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-87cbbf8a4e | D1 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | Distribution Route 그리드에는 Sales Site·Project·Model·Team 컬럼이 없다. · 검색어 SALES_SITE, Sales Site, SALES_PLAN_ITEM_ID, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-e25138d675 | C3 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0005 그리드에는 Sales Site·Project·Model·Team 컬럼이 없고 Route·City·Port 컬럼만 있다. · 검색어 SALES_SITE_ID, PROJECT_CODE, SALES_PLAN_ITEM_ID, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-72c0a59d10 | B5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0005 신규 행에는 Sales Site·Project 팝업·Model·Team 컬럼이 없다. · 검색어 SALES_PLAN_ITEM_ID, SALES_SITE, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a8735452d8 | M3 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0005 그리드에는 Sales Site·Project·Model·Team 컬럼이 없다. · 검색어 Sales Site, SALES_PLAN_ITEM_ID, ProjectPopup, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-05deb1fa49 | G5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | 이 화면에는 Sales Site·Project 팝업·Model 후보·Team 컬럼이 없다. · 검색어 SALES_PLAN_ITEM_ID, SalesSite, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-f89705d8aa | D5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0005 화면에는 Sales Site·Project 팝업·Model·Team 컬럼이 없습니다. · 검색어 SALES_PLAN_ITEM_ID, SALES_SITE, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-5d5366264e | D3 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0005 화면에는 AS From Site 컬럼과 Measure 후보 콤보가 없습니다. · 검색어 AS From Site, AS_FROM_SITE, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-73c11a6fab | C2 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0005 그리드에는 AS From Site 셀과 Measure 후보가 없다. · 검색어 AS_FROM_SITE, From Site, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-23380ecb7c | B4 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0005 에는 AS From Site 콤보와 Measure 후보가 없다. · 검색어 AS_FROM_SITE, AS From Site, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-fbb24fa45d | B5 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0005 에는 AS From Site 콤보와 Measure 후보가 없다. · 검색어 AS_FROM_SITE, AS From Site, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-43c1084e26 | J3 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0005 에는 AS From Site 콤보와 Measure 후보가 없다. · 검색어 AS From Site, AS_FROM_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-779bec1182 | B4 | [DMF0082 결함 유형] End Customer 셀 콤보 후보 | SCP0005 그리드에는 End Customer 셀 콤보가 없다. · 검색어 END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-54d9b41409 | B5 | [DMF0082 결함 유형] End Customer 셀 콤보 후보 | SCP0005 그리드에는 End Customer 셀 콤보가 없다. · 검색어 END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-9be580e344 | M1 | [DMF0082 결함 유형] Excel Form 팝업 Search | SCP0005 Excel Form 은 AS-IS 에서는 MenuEtcFileDownButton 파일 다운로드, TO-BE 에서는 팝업 없는 즉시 다운로드라 Excel Form 팝업과 그 Search 버튼이 없다. · 검색어 ExcelFormPopup, ExcelFormModal, Excel Form Popup: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-925ed40fbe | B4 | [DMF0082 결함 유형] Customs Handbook 콤보 후보 | SCP0005 에는 Customs Handbook 콤보가 없다. · 검색어 CUSTOMS_HANDBOOK, Customs Handbook: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3cf139ca8f | B4 | [DMF0005 결함 유형] Team 조회조건 후보 | SCP0005 에는 Team 조회조건이 없다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-bc6ba0806c | B7 | [DMF0005 결함 유형] Team 조회조건 후보 | SCP0005 조회조건에 Team 이 없습니다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-f1f5c51d5e | B4 | [DMF0035 결함 유형] Version 조회조건 | SCP0005 조회조건에는 Version 이 없다. · 검색어 VERSION_ID, PLAN_VERSION, Version: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-221dc5208a | M3 | [DMF0035 결함 유형] Version 조회조건 | SCP0005 조회조건은 From/To Country·City, Trans Mode, Active 이고 Version 조회조건이 없다. · 검색어 cboVersion, Version: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b4c1e7b7b5 | F1 | [DMF0082 결함 유형] Unit Price(LOC) 저장 | SCP0005 화면 소스와 TO-BE 화면 폴더에는 Unit Price(LOC) 컬럼이 없다. · 검색어 Unit Price, UNIT_PRICE_LOC: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-fef3c47f73 | F6 | [DMF0082 결함 유형] Unit Price(LOC) 저장 | SCP0005 그리드에는 Unit Price(LOC) 컬럼이 없고 비용 컬럼은 Pick Up Cost·Freight Cost·Delivery Cost뿐이다. · 검색어 Unit Price, UNIT_PRICE, PRICE_LOC: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b2022b612c | E4 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SCP0005 화면에는 RTF 저장과 Sales Plan Waterfall 동기화 기능이 없다. · 검색어 Waterfall, Sales Plan, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-620a3e8fb3 | F1 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SCP0005 화면에는 RTF 저장 판가 검증과 Sales Plan Waterfall 동기화가 없다. · 검색어 RTF, Waterfall: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-84d10fa44f | F7 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SCP0005 저장은 SCP_MST_DISTRIBUTION_ROUTE와 이력 테이블에만 쓰고, RTF 판가 검증과 Sales Plan Waterfall 동기화는 없다. · 검색어 RTF, Waterfall, Sales Plan: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-4409fa60b8 | G4 | [DMF0035 결함 유형] Plan Type 조회조건 위치 | SCP0005 조회조건에 Plan Type과 Div가 없다. · 검색어 PLAN_TYPE, Plan Type, cboPlanType: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-d754eb5550 | H4 | [DMF0035 결함 유형] Project/Model/Owner 조회조건 팝업 | 이 화면에는 Project·Model·Owner 조회조건과 그 팝업이 없다. · 검색어 txtProject, txtOwner, ProjectModal, OwnerModal: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ca78249c20 | H6 | [DMF0035 결함 유형] Project/Model/Owner 조회조건 팝업 | 이 화면에는 Project/Model/Owner 조회조건 팝업이 없다. · 검색어 ProjectPopup, ModelPopup, OwnerPopup: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-4b1b64a70a | H6 | [DMF0005 결함 유형] Team 팝업 조건(Team ID/Team Name) | 이 화면에는 Team 팝업과 Team ID/Team Name 조건이 없다. · 검색어 TeamPopup, TEAM_ID, Team Name: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-78ef59b36a | B4 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | SCP0005 그리드에는 Sales Plant 셀 콤보가 없다. · 검색어 SALES_PLANT, Sales Plant, SCM_MST_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-605d345896 | N1 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | SCP0005 화면에는 Sales Plant 셀 콤보가 없다. · 검색어 Sales Plant, SCM_MST_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-aaae06a5f0 | K2 | [DMF0035 결함 유형] Measure 명칭 MKT FCST[R+P] | SCP0005 Distribution Route 그리드는 정적 컬럼으로 구성되어 Measure 명칭 MKT FCST[R+P]가 없다. · 검색어 MKT FCST, MKT_FCST, Measure Setting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-033270cf90 | H8 | [SYS0012 결함 유형] Request Date 컬럼 | SCP0005 그리드에는 Request Date 컬럼이 없고 일시 컬럼은 Creation Date·Last Update Date 기준 항목으로 확인한다. · 검색어 REQUEST_DATE, Request Date, REQ_DATE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ff03da4dea | C3 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0005 그리드에는 Dept 컬럼과 User 선택 기능이 없고 활성 여부는 Active 컬럼(VALID_YN) 하나뿐이다. · 검색어 DEPT_ID, DEPT_NAME, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-16f160c3a3 | H3 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0005 에는 Dept 컬럼과 Use Y/N 헤더가 없다. · 검색어 DEPT_ID, DEPT_NAME, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-df13c8b871 | F1 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0005 화면에는 Dept 컬럼과 Use Y/N 헤더가 없다. · 검색어 DEPT_ID, DEPT_NAME, USE_YN: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ba39694781 | A5 | [SYS0014 결함 유형] Email 컬럼 | SCP0005 그리드에는 Email 컬럼이 없다. · 검색어 EMAIL, E-mail: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-7b8108b561 | M3 | [SYS0014 결함 유형] User 팝업(User Info) | SCP0005 에는 User 팝업이 없다. · 검색어 UserPopup, SCM_ADM_USER_M, User Info: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-dfd1672fa4 | F1 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | SCP0005 화면에는 JV Planner 용 Division 시트가 없다. · 검색어 JV Planner, JV_PLANNER: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-392dec9a1d | F6 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | SCP0005에는 Distribution Route 시트만 있고, Division 시트와 JV Planner 저장 기능이 없다. · 검색어 JV Planner, JV_PLANNER, Division Sheet: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-50d460832f | B4 | [SYS0010 결함 유형] System 컬럼 입력 방식 | SCP0005 그리드에는 System 컬럼이 없다. · 검색어 SYSTEM_CODE, LOOKUP_SYSTEM: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-2adee88220 | A5 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | SCP0005에는 메뉴 URL·ROUTE_PATH 입력 컬럼이 없다. · 검색어 MENU_URL, URL_PATH: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-30b6aec503 | F1 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | SCP0005 화면에는 URL-ROUTE_PATH 입력 컬럼이 없다. · 검색어 MENU_URL, Route Path: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-fe33749307 | B6 | [SYS0005 결함 유형] Schema 조회조건 | SCP0005 조회조건에 Schema 콤보가 없습니다. · 검색어 SCHEMA_NAME, cboSchema, Schema Name: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3df475828d | G2 | [SYS0005 결함 유형] Schema 조회조건 | SCP0005 조회조건에 Schema가 없다. · 검색어 Schema, SCHEMA, cboSchema: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-81296d7280 | G1 | [SYS0005 결함 유형] Schema 조회조건 | SCP0005 조회조건에는 Schema가 없습니다. · 검색어 cboSchema, SCHEMA_NAME, Schema: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-6ab834a2cd | B6 | [SYS0006 결함 유형] API Type 조회조건 | SCP0005 조회조건에 API Type 콤보가 없습니다. · 검색어 API Type, API_TYPE, cboApiType: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b146acd9ce | B4 | [SYS0006 결함 유형] API Type 조회조건 | SCP0005 에는 API Type 조회조건이 없다. · 검색어 API_TYPE, API Type: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-e551ec0ec3 | B1 | [SYS0006 결함 유형] API Type 조회조건 | SCP0005 조회조건에는 API Type 콤보가 없다. · 검색어 API_TYPE, API Type, apiType: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-0098d9bd87 | B4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0005 에는 Module·Sub Module 조회조건과 Notice Content 가 없다. · 검색어 SUB_MODULE, Sub Module, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-6e36629743 | B6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0005 에는 Module·Sub Module 조회조건과 Notice Content 항목이 없습니다. · 검색어 Sub Module, Notice Content, NOTICE_CONTENT: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-98b76481dc | G4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0005에는 Module·Sub Module 조회조건과 Notice Content가 없다. · 검색어 SUB_MODULE, Sub Module, cboSubModule, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-6ef46a87ef | H5 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | Distribution Route 화면에는 Module·Sub Module 조회조건과 Notice Content 입력이 없습니다. · 검색어 Sub Module, Notice Content, cboModule: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a0c6866110 | D4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0005 화면에는 Module·Sub Module 조회조건과 Notice Content 가 없습니다. · 검색어 Sub Module, SUB_MODULE, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-500e762d4a | H6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | 이 화면에는 Module/Sub Module 조회조건과 Notice Content가 없다. · 검색어 SUB_MODULE, Sub Module, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-dcae78e8bd | K5 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | Module·Sub Module 조회조건과 Notice Content는 SCP0005 화면 요소 목록에 없다. · 검색어 Sub Module, SUB_MODULE, Notice Content, NOTICE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-22ae885bc7 | B6 | [SYS0017 결함 유형] Module / Sub Module 조회조건 | SCP0005 조회조건은 From/To Country·City, Trans Mode, Valid 이고 Module·Sub Module 조회조건은 없습니다. · 검색어 Sub Module, SUB_MODULE, MODULE_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-73796ee1d7 | G4 | [SYS0017 결함 유형] Module / Sub Module 조회조건 | SCP0005에는 Module·Sub Module 조회조건이 없다. · 검색어 SUB_MODULE, Sub Module, cboSubModule: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ba7c26775a | B4 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SCP0005 에는 Sales Company·Sales Plant 콤보가 없다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Company: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b137ec7f44 | C2 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SCP0005 그리드에는 Sales Company·Sales Plant 콤보가 없다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Company: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-52c82f5bf2 | F2 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SCP0005 에는 Sales Company·Sales Plant 콤보가 없다. · 검색어 Sales Company, SALES_PLANT, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-1ca973f196 | F1 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SCP0005 에는 Sales Company·Sales Plant 콤보가 없다. · 검색어 Sales Company, SALES_PLANT, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-e780a45045 | H6 | [DMF0005 결함 유형] Project 팝업(그리드) | 이 화면에는 Project 팝업이 없다. · 검색어 ProjectPopup, PROJECT_ID, Project Name: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-e0dd6e48dd | M3 | [DMF0005 결함 유형] Project 팝업(그리드) | SCP0005 에는 Project 팝업이 없다. · 검색어 ProjectPopup, Project Popup, PROJECT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-02ded0b162 | B3 | [SYS0010 결함 유형] 메인화면 System admin 정보(SYSTEM_ADM Lookup) | SCP0005 화면에는 메인화면 System admin 정보(SYSTEM_ADM Lookup) 표시가 없다. · 검색어 SYSTEM_ADM, System admin, SystemAdmin: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-e36d1f7034 | E4 | [DMF0004 결함 유형] Customer 탭 Sold to/Ship to 저장 검증 | SCP0005 화면에는 Customer 탭 Sold to/Ship to 저장 검증이 없다. · 검색어 SOLD_TO, Sold to, NERP_CONV_MASTER: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-dd38d8c227 | E3 | [DMF0005 결함 유형] Project 컬럼 필수 검증 | SCP0005 그리드에는 Project 컬럼이 없다. · 검색어 PROJECT_CODE, PROJECT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-8c83885203 | E4 | [DMF0005 결함 유형] Project 컬럼 필수 검증 | SCP0005 화면 그리드에는 Project 컬럼이 없다. · 검색어 PROJECT_CODE, PROJECT_CD: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-7313ca6a42 | B7 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SCP0005 그리드에 Team(DEPT_ID) 컬럼과 셀 콤보가 없습니다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-728879c3e8 | A2 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SCP0005 화면에는 Team(DEPT_ID) 셀 콤보가 없습니다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-eea20c05ab | B4 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SCP0005 그리드에는 Team(DEPT_ID) 셀 콤보가 없다. · 검색어 DEPT_ID, DEPT_NAME, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-423b8d62d0 | B7 | [DMF0003 결함 유형] Team 정보(DEPT_ID) | SCP0005 에 Team(DEPT_ID) 정보가 없습니다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-0fdb6aa939 | A1 | [DMF0003 결함 유형] Team 정보(DEPT_ID) | SCP0005 화면에는 Team(DEPT_ID) 컬럼이 없습니다. · 검색어 DEPT_ID, Team, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-2a7a6ac42d | F7 | [DMF0020 결함 유형] Unit Price(LOC) → Sales Price 연동 | SCP0005에는 Unit Price(LOC) 입력과 Sales Price 연동이 없다. · 검색어 Unit Price, SALES_PRICE, Sales Price: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-30248e6149 | F1 | [DMF0020 결함 유형] Unit Price(LOC) → Sales Price 연동 | SCP0005 화면에는 Unit Price(LOC) 를 Sales Price 로 넘기는 연동이 없다. · 검색어 Sales Price, SALES_PRICE, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-c2a22c3446 | A5 | [DMF0008 결함 유형] 하단 그리드 CRUD Status 컬럼 | SCP0005 는 메인 그리드 spdMain 하나만 있고 하단 그리드가 없다. · 검색어 spdDetail, spdSub, CRUD Status: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b6dd26bfac | G5 | [DMF0005 결함 유형] Model 팝업 조회 | 이 화면에는 Model 팝업이 없다. · 검색어 ModelPopup, ITEM_ID, NICK_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-dffacea635 | B5 | [SYS0012 결함 유형] 권한 신청 가능 Group 목록 | SCP0005 에는 권한 신청 가능 Group 목록이 없다. · 검색어 REQ_NO_DISPLAY, AUTH_GROUP: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-10cb1fe4b4 | C1 | [DMF0035 결함 유형] 조회조건 전체(숫자·ITEM TYPE 포함) | SCP0005 조회조건에는 Div 콤보와 ITEM TYPE 조건이 없어 Div 변경 시 조회조건 초기화 동작이 없다. · 검색어 DIVISION_ID, FilterMyDivision, ITEM_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ecc224b5c5 | F8 | [SYS0011 결함 유형] Approval Date 컬럼 | SCP0005 그리드에는 Approval Date 컬럼과 Request 승인 흐름이 없다. · 검색어 APPROVAL_DATE, Approval Date: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-4cb12472fb | F1 | [SYS0011 결함 유형] Approval Date 컬럼 | SCP0005 화면에는 Approval Date 컬럼이 없다. · 검색어 Approval Date, APPROVAL_DATE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-2ff82b3ea4 | C5 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | SCP0005 에는 Mail Setup 탭과 사용자 좌/우 그리드가 없다. · 검색어 Mail Setup, MAIL_SETUP, spdUserLeft: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a14b152264 | F1 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | SCP0005 에는 Mail Setup 탭과 사용자 좌/우 그리드가 없다. · 검색어 Mail Setup, MAIL_USER, Mail: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-8f76e664b7 | F5 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | AS-IS 소스와 TO-BE 화면 폴더 모두에 Mail Setup 탭과 사용자 좌/우 그리드가 없다. · 검색어 MailSetup, Mail Setup: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-1119153638 | H4 | [DMF0035 결함 유형] Version 조회조건 돋보기 버튼 | 이 화면 조회조건은 From/To Country·City, Trans Mode, Valid뿐이고 Version 조회조건 돋보기 버튼은 없다. · 검색어 txtVersion, btnVersion, VersionModal: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-739f953860 | C1 | [DMF0035 결함 유형] Version 조회조건 기본값 | SCP0005 조회조건에는 Version과 Div 조건이 없다. · 검색어 VERSION_ID, PLAN_VERSION, DIVISION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-722b69d7e1 | A3 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | SCP0005 화면에는 Sum 행 라벨과 Sum·Qty≠0 체크박스가 없습니다. · 검색어 Sum/Qty, Qty≠0, chkSum, SUM_QTY: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-35087e3e22 | H5 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | Distribution Route 화면에는 Sum 행과 Sum·Qty≠0 체크박스가 없습니다. · 검색어 Qty≠0, Sum/Qty, chkSum: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-51e846ff34 | G4 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | SCP0005 그리드에는 Sum 행과 Sum·Qty≠0 체크박스가 없고, LT_SUM은 Total L/T 컬럼이다. · 검색어 chkSum, Qty≠0, chkQtyZero: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-d152bd353c | A5 | [DMF0035 결함 유형] Version 컬럼 | SCP0005 그리드에는 Version 컬럼이 없다. · 검색어 VERSION_ID, VERSION_CODE, PLAN_VERSION: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3c5ee63af8 | F7 | [DMF0021 결함 유형] RTF[R+P] → DM_PLN_MKT_FCST / DM_PLN_MKT_FCST_C 연동 | SCP0005 저장 SP는 DM_PLN_MKT_FCST 테이블에 쓰지 않는다. · 검색어 DM_PLN_MKT_FCST, RTF, Demand Plan Waterfall: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-5d40cd9b7f | F1 | [DMF0021 결함 유형] RTF[R+P] → DM_PLN_MKT_FCST / DM_PLN_MKT_FCST_C 연동 | SCP0005 화면에는 RTF[R+P] 를 DM_PLN_MKT_FCST 로 넘기는 연동이 없다. · 검색어 DM_PLN_MKT_FCST, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-f9cc8b6fb7 | I2 | [SCP0028 결함 유형] Lot Size<Increment 검증 메시지 | SCP0005 물류 경로 화면에는 Lot Size·Increment 컬럼과 그 검증 메시지가 없다. · 검색어 LOT_SIZE, INCREMENT, Lot Size: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-553f1b443b | I1 | [SCP0028 결함 유형] Lot Size<Increment 검증 메시지 | SCP0005 물류 경로 화면에는 Lot Size·Increment 컬럼과 그 검증 메시지가 없다. · 검색어 LOT_SIZE, INCREMENT, Lot Size: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-5d5e0fab21 | E4 | [SCP0028 결함 유형] Lot Size<Increment 검증 메시지 | SCP0005 화면에는 Lot Size·Increment 검증이 없다. · 검색어 LOT_SIZE, Lot Size, Increment: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-731c441d5a | A1 | [SCP0006 결함 유형] BOM Explosion Plant Assign(MCCH125020A1/MACH125020A1) | SCP0005 화면에는 BOM Explosion Plant Assign 기능이 없습니다. · 검색어 Plant Assign, BOM Explosion, PLANT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-16b09b122a | N1 | [SCP0006 결함 유형] BOM Explosion Plant Assign(MCCH125020A1/MACH125020A1) | SCP0005 화면에는 BOM Explosion과 Plant Assign 기능이 없다. · 검색어 BOM Explosion, Plant Assign: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-1c9b87b306 | D3 | [SCP0006 결함 유형] Plant Assign 그리드 색상 | SCP0005 화면에는 SCP0006 의 Plant Assign 그리드가 없고, AS-IS 소스와 TO-BE 화면 폴더에서 Plant Assign 이 검색되지 않습니다. · 검색어 Plant Assign, PLANT_ASSIGN, CA1: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-95d531ff26 | H2 | [SCP0006 결함 유형] Plant Assign 그리드 색상 | SCP0005 에는 Plant Assign 그리드와 CA1 행이 없다. · 검색어 Plant Assign, PLANT_ASSIGN, CA1: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-aaf88ea53d | G5 | [SCP0006 결함 유형] Capa New Model 팝업 조건(Group/Plant) | 이 화면에는 Capa New Model 팝업이 없다. · 검색어 Capa, NewModel, PLANT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-3637ef1940 | M3 | [SCP0006 결함 유형] Capa New Model 팝업 조건(Group/Plant) | SCP0005 에는 Capa New Model 팝업과 Group/Plant 조건이 없다. · 검색어 Capa, New Model, NewModel: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-244a0c6d13 | C2 | [SCP0007 결함 유형] Insert 행 Div 셀 / 하위 Site | SCP0005 그리드에는 Div 셀과 하위 Site 셀이 없다. · 검색어 DIVISION_ID, divisionId: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-71828a6deb | D4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SCP0005 의 Insert 행에는 To Site 콤보가 없고, 도착지는 COL:TO_COUNTRY·COL:TO_CITY 로 입력합니다. · 검색어 TO_SITE, TO_SITE_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-efe4b2f63a | E2 | [SCP0007 결함 유형] Period 날짜 | SCP0005에는 Period 날짜 입력 칸이 없고 AS-IS 소스와 TO-BE 화면 폴더에서 Period 가 검색되지 않는다. · 검색어 Period, PERIOD_FROM, RangePicker: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-2228169fb1 | F4 | [SCP0007 결함 유형] Period 날짜 | AS-IS 소스와 TO-BE 화면 폴더 모두에 Period 날짜 조건이 없다. · 검색어 Period, PERIOD: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-6f4198e093 | C4 | [DMF0082 결함 일반화] 그리드 Measure 필터(MEASURE Filter) × Division(DIVISION_ID) 변경 재조회 · 건수 표시 | SCP0005 는 컬럼 39개를 고정으로 쓰는 그리드라 Measure 필터와 Division 조회조건이 없다. · 검색어 MEASURE_FILTER, Measure Filter, DIVISION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-fede69fc93 | J1 | [DMF0074 결함 일반화] 조회조건 Division 콤보(DIVISION_ID) 권한 자동 선택 · Period(PERIOD) 입력란 크기 | SCP0005 에는 화면 OPEN 시 자동 선택할 Division 조회조건이 없다. · 검색어 DIVISION_ID, cboDivision, divisionId: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-7f36f5cfc6 | G4 | [DMF0074 결함 일반화] 조회조건 Division 콤보(DIVISION_ID) 권한 자동 선택 · Period(PERIOD) 입력란 크기 | SCP0005 조회조건은 From Country·From City·To Country·To City·Trans Mode·Valid 여섯 개뿐이고 Division 콤보와 Period 입력란이 없다. · 검색어 DIVISION_ID, cboDivision, PERIOD: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ac761b7999 | J1 | [DMF0004 결함 일반화] 조회조건 Division 콤보(DIVISION_ID) 초기 선택값 · 사용자 권한 | SCP0005 에는 초기 선택값을 확인할 Division 조회조건이 없다. · 검색어 DIVISION_ID, cboDivision, divisionId: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ebe6cb8486 | D6 | [DMF0005 결함 일반화] Insert 행 위치 · 셀 병합(FPMerge) 그룹 | SCP0005 그리드에는 셀 병합(FPMerge) 그룹이 없습니다. · 검색어 FPMerge, SpanModel, AddSpanCell: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-0a444fac21 | C3 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME·PROJECT_STATUS·PROJECT_OWNER·BIZ_TYPE) · Model 팝업(ITEM_ID → | SCP0005 에는 Project·Model·Sales Site 팝업이 없고 자동 채움은 City 팝업(FROM_CITY·TO_CITY)과 Trans Mode 변경에서만 일어난다. · 검색어 PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, VMI_YN: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-8b977ba2cf | M4 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME·PROJECT_STATUS·PROJECT_OWNER·BIZ_TYPE) · Model 팝업(ITEM_ID → | 이 화면에는 Project·Model·Sales Site 팝업과 PROJECT_NAME·ITEM_TYPE·VMI_YN 자동 채움이 없습니다. · 검색어 PROJECT_CODE, SCM_SITE_ID, VMI_YN: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-031dfb1a6e | B5 | [DMF0021 결함 일반화] Measure 설정 팝업(Measure Setting) 후보 · Column 설정 후보 — Division 기준 재조회 | SCP0005 에는 Measure Setting 팝업과 Division 기준 Column 설정이 없다. · 검색어 Measure Setting, MeasureSetting, Column Setting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-80ef5b2597 | K2 | [DMF0021 결함 일반화] Measure 설정 팝업(Measure Setting) 후보 · Column 설정 후보 — Division 기준 재조회 | SCP0005 화면에는 Measure Setting 팝업이 없고 Division 콤보도 TO-BE에 구현되지 않아(dead 콤보, 신설 금지) Division 기준 재조회 대상이 없다. · 검색어 Measure Setting, MeasureSetting, measureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-7c17f9739a | B3 | [DMF0048 결함 일반화] 조회조건 Team(DEPT_ID)·End Customer(END_CUSTOMER)·Sales Site(SCM_SITE_ID)·Plant Site 콤보 후보 정렬 = 표시명 순(숫자-영문 | SCP0005 조회조건은 From/To Country·City, Trans Mode, Valid이고, Team·End Customer·Sales Site·Plant Site 콤보는 없다. · 검색어 DEPT_ID, SCM_SITE_ID, END_CUSTOMER, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a34b33924f | C1 | [DMF0053 결함 일반화] 조회조건 Filter 콤보 6종(FilterMyDivision·FilterTeambyDivision·FilterEndCustomerByDivision·FilterBizType·Filte | SCP0005 조회조건은 Trans Mode·Valid 콤보와 Country·City 텍스트뿐이고 Filter 콤보 6종을 쓰지 않는다. · 검색어 FilterMyDivision, FilterTeambyDivision, FilterEndCustomerByDivision, FilterBizType: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ae905f1715 | B4 | [DMF0053 결함 일반화] 조회조건 Filter 콤보 6종(FilterMyDivision·FilterTeambyDivision·FilterEndCustomerByDivision·FilterBizType·Filte | SCP0005 조회조건에는 Division·Team·End Customer·Biz Type 계열 Filter 콤보가 없다. · 검색어 FilterMyDivision, FilterTeambyDivision, FilterEndCustomerByDivision, FilterBizType: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-5cc15b19fd | G5 | [DMF0074 결함 일반화] 조회조건 Project(PROJECT) · Model/Nickname(MODEL) 입력칸 Enter 키 → Project Popup · Item Popup 열기 · Model 팝업 사전 | 이 화면에는 조회조건 Project·Model/Nickname과 해당 팝업이 없다. · 검색어 PROJECT_CODE, ProjectPopup, ItemPopup: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-75f7a57895 | A2 | [결함 유형 묶음 A2-G02 · 2건] Category 코드 컬럼(CATEGORY_ID) 숨김 | SCP0005 화면에는 CATEGORY_ID, CATEGORY_DESC 컬럼이 없습니다. · 검색어 CATEGORY_ID, CATEGORY_DESC: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-36641fce77 | A5 | [결함 유형 묶음 A5-G01 · 2건] Main 그리드 Sub Module 컬럼(SUB_MODULE_CODE) | SCP0005 Main 그리드에는 Sub Module 컬럼(SUB_MODULE_CODE)이 없다. · 검색어 SUB_MODULE_CODE, Sub Module: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-eaa3ca7e8a | A5 | [결함 유형 묶음 A5-G02 · 2건] Category 코드 컬럼(CATEGORY_ID) 숨김 | SCP0005 그리드에는 Category 코드 컬럼(CATEGORY_ID)이 없다. · 검색어 CATEGORY_ID, CATEGORY_DESC: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-dcb495c732 | A5 | [결함 유형 묶음 A5-G07 · 2건] Div별 Project 계열 제외 컬럼 비노출 | SCP0005 그리드에는 Project Name·Project Status 같은 Project 계열 컬럼이 없다. · 검색어 PROJECT_NAME, PROJECT_STATUS, Project Name: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-40d74a1874 | A5 | [결함 유형 묶음 A5-G08 · 2건] Plan Type별 제외 컬럼(Cust Group Dtl 등) | SCP0005에는 Plan Type 조회조건과 Cust Group Dtl 컬럼이 없다. · 검색어 PLAN_TYPE, CUST_GROUP_DTL, Cust Group Dtl: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-0b3182497e | A5 | [결함 유형 묶음 A5-G09 · 2건] Div 40 Report 컬럼 표시 | SCP0005 그리드에는 Cell Prod. Site(S&OP Report)·Sold-to Cust(Report) 컬럼이 없다. · 검색어 Cell Prod. Site, Sold-to Cust, S&OP Report: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-541b34b690 | B1 | [결함 유형 묶음 B1-G01 · 3건] 그리드 End Customer 콤보 후보 목록 | SCP0005 그리드에는 End Customer 콤보 컬럼이 없다. · 검색어 END_CUSTOMER, End Customer, endCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-07296f7b8c | B2 | [결함 유형 묶음 B2-G01 · 3건] 그리드 End Customer 콤보 후보 목록 | SCP0005 그리드에는 End Customer 콤보 컬럼이 없다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-7cc0c4cabc | B4 | [결함 유형 묶음 B4-G01 · 3건] 저장 · Sales Site 조회조건 콤보 | SCP0005 에는 Sales Site 저장 대상과 Sales Site 조회조건 콤보가 없다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-f3122d7013 | B4 | [결함 유형 묶음 B4-G03 · 1건] 그리드 셀 콤보 후보(End Customer·Sold-to Customer) | SCP0005 그리드에는 End Customer·Sold-to Customer 셀 콤보가 없다. · 검색어 END_CUSTOMER, SOLD_TO, End Customer, Sold-to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-bfe775de14 | B5 | [결함 유형 묶음 B5-G02 · 2건] FCST Type 콤보 후보 | SCP0005 에는 FCST Type 콤보가 없다. · 검색어 FCST_TYPE, SALES_TYPE_CODE, FCST Type: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-4ee95c249b | C2 | [결함 유형 묶음 C2-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | SCP0005 그리드는 고정 컬럼 그리드이고 신규 행 Measure 콤보가 없다. · 검색어 MKT_FCST, VMI_In_Request, AS_In_Request: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-36e6b45aed | C2 | [결함 유형 묶음 C2-G06 · 4건] 그리드 상위 셀 변경 시 하위 셀 cascade | SCP0005 그리드에는 End Customer·Sales Site·Sales Company·Sales Plant 상위/하위 셀이 없다. · 검색어 END_CUSTOMER, SALES_SITE, SALES_COMPANY, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-eab958d3c6 | C3 | [결함 유형 묶음 C3-G01 · 3건] Team·End Customer(·Energy(WH)) 컬럼 자동 세팅 | SCP0005 그리드에는 Team·End Customer·Energy(WH) 컬럼이 없다. · 검색어 END_CUSTOMER, ENERGE, SSPM, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-259946adf8 | C5 | [결함 유형 묶음 C5-G01 · 2건] 사용자 좌/우 그리드 더블클릭 추가/제거 | SCP0005 에는 사용자 좌/우 그리드가 없다. · 검색어 spdLeft, spdRight, USER_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ab8c4643e7 | D1 | [결함 유형 묶음 D1-G01 · 2건] 신규 행 Team·End Customer 등 자동 매핑 컬럼 | Distribution Route 그리드에는 Team·End Customer·Energy(WH) 같은 자동 매핑 컬럼이 없다. · 검색어 END_CUSTOMER, SSPM, Energy(WH): AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-668c89414b | D2 | [결함 유형 묶음 D2-G01 · 2건] MKT_FCST·SCM_FCST 편집 권한(GET_ADMIN_GROUP_MEASURE) | Distribution Route 화면에는 MKT_FCST·SCM_FCST Measure 편집 권한이 없다. · 검색어 MKT_FCST, SCM_FCST, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-44155b439e | D2 | [결함 유형 묶음 D2-G02 · 3건] Bucket 유형별 Measure 편집 구간 | Distribution Route 화면에는 Bucket 유형별 Measure 편집 구간이 없다. · 검색어 Bucket, Unit Price, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-7f41085a89 | D3 | [결함 유형 묶음 D3-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | SCP0005 그리드에는 Measure 콤보가 없고 MKT_FCST·VMI_In_Request·AS_In_Request 가 소스에서 검색되지 않습니다. · 검색어 MKT_FCST, VMI_In_Request, AS_In_Request: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-fac2ed0922 | D4 | [결함 유형 묶음 D4-G01 · 2건] 하단 메시지설정 탭의 Insert(행추가) | SCP0005 화면은 Distribution Route 그리드 하나뿐이고 하단 메시지설정 탭이 없습니다. · 검색어 메시지설정, MESSAGE_SETTING, Message Setting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-e02ecbd331 | D5 | [결함 유형 묶음 D5-G01 · 2건] 코드성 컬럼의 셀 입력 방식(Menu Type·Auth Unit·System) | SCP0005 화면에는 Menu Type·Auth Unit·System 컬럼이 없습니다. · 검색어 MENU_TYPE, Menu Type, AUTH_UNIT, Auth Unit: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-edb8a8f1ef | E4 | [결함 유형 묶음 E4-G02 · 2건] 판가(Unit Price) 미입력 Validation 오탐 | SCP0005 화면에는 판가(Unit Price) 입력·검증 컬럼이 없다. · 검색어 UNIT_PRICE, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ff3fa475a5 | E4 | [결함 유형 묶음 E4-G03 · 2건] 수량 입력 시 Unit Price 조건부 필수 | SCP0005 화면에는 수량 입력과 Unit Price 조건부 필수 검증이 없다. · 검색어 UNIT_PRICE, MKT FCST, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-921fddcb59 | F1 | [결함 유형 묶음 F1-G01 · 3건] 저장 · Sales Site 조회조건 콤보 | SCP0005 화면에는 Sales Site 조회조건 콤보가 없다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-72781c947c | F1 | [결함 유형 묶음 F1-G02 · 2건] 수량·Unit Price(LOC) 입력 행 저장 Validation | SCP0005 에는 수량·Unit Price(LOC) 입력 컬럼이 없다. · 검색어 Unit Price, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-9995a943d2 | F1 | [결함 유형 묶음 F1-G04 · 2건] 사용자 우측 그리드(allReceiver) 추가 후 Save | SCP0005 화면에는 사용자 우측 그리드(allReceiver)가 없다. · 검색어 allReceiver, ALL_RECEIVER: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-cc55d06682 | F2 | [결함 유형 묶음 F2-G01 · 3건] 저장 후 Sales Site 조회조건 콤보 갱신 | SCP0005 에는 Sales Site 조회조건 콤보가 없다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ff948c25d7 | F4 | [결함 유형 묶음 F4-G01 · 2건] SQL View 버튼(VIEW) 클릭 | AS-IS 소스와 TO-BE 화면 폴더 모두에 SQL View 버튼이 없다. · 검색어 SqlView, SQL View, SQL_VIEW: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a904c49f63 | G1 | [결함 유형 묶음 G1-G08 · 2건] Project·Model/Nickname·Owner 조회조건 결과 반영 | SCP0005 조회조건에는 Project·Model/Nickname·Owner가 없습니다. · 검색어 txtProject, Nickname, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-8e19faf937 | G5 | [결함 유형 묶음 G5-G01 · 3건] 팝업 Period 기본값(메인 Period 연동) | 이 화면의 팝업과 조회조건에는 Period가 없다. · 검색어 Period, PeriodFrom, FromPeriod: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-e78d35d55e | G5 | [결함 유형 묶음 G5-G02 · 2건] 팝업 Spread 기간 컬럼 생성 | 이 화면의 팝업에는 Period 기간별 Spread 컬럼이 없다. · 검색어 Period, PeriodColumn, MonthColumn: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a4233f1bdc | G8 | [결함 유형 묶음 G8-G03 · 2건] Project·Model/Nickname 텍스트 조건 대소문자·콤마 다중값 | 이 화면에는 조회조건 Project·Model/Nickname이 없다. · 검색어 PROJECT_CODE, NICK_NAME, ITEM_ID: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-904d59a689 | G9 | [결함 유형 묶음 G9-G01 · 2건] 텍스트 조회조건 Project·Model/Nickname 다중값·대소문자 조회 | SCP0005 조회조건은 txtFromCountry·txtFromCity·txtToCountry·txtToCity·cboValidYN 이고, AS-IS 소스와 TO-BE distribution-route 폴더 모두 Project·Model/Nickname·Owner 조회조건이 검색 0건이다. · 검색어 PROJECT_CODE, NICK_NAME, Nickname, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 18개  |
| C-d24f89f99b | H4 | [결함 유형 묶음 H4-G02 · 2건] Version 팝업(VERSION Modal) 레이아웃 | 이 화면의 팝업은 도시검색(RegionModal)과 Excel Upload 팝업뿐이고 Version 팝업은 없다. · 검색어 VersionModal, VERSION Modal, frmVersionPopup: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-9885507c39 | H4 | [결함 유형 묶음 H4-G03 · 2건] 좌/우 사용자 영역 높이 | 이 화면은 단일 그리드 화면이라 좌/우 사용자 영역과 하단 탭이 없다. · 검색어 SplitContainer, SplitterPanel, xtraTabControl: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-fe58a3bf1d | H5 | [결함 유형 묶음 H5-G01 · 2건] Version·Plan Type 조회조건 라벨 명칭 | Distribution Route 화면에는 Version 조회조건과 Waterfall Type 조회조건이 없습니다. · 검색어 Waterfall Type, Plan Type, cboVersion: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-c28fa846d5 | I2 | [결함 유형 묶음 I2-G02 · 2건] Team 명칭(조회조건과 결과 컬럼) | SCP0005 화면에는 Team 조회조건과 Team 결과 컬럼이 없다. · 검색어 TEAM, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a1eafd01ec | J3 | [결함 유형 묶음 J3-G01 · 2건] MKT_FCST·SCM_FCST Measure 편집 구간(GET_ADMIN_GROUP_MEASURE) | SCP0005 에는 MKT_FCST·SCM_FCST Measure 편집 구간이 없다. · 검색어 GET_ADMIN_GROUP_MEASURE, MKT_FCST, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-8ae8a9fafb | K2 | [결함 유형 묶음 K2-G05 · 2건] Div 전환 시 필수 컬럼 유지 | SCP0005 화면에는 Div 전환이 없고 Project Code·Plant Site·END_CUSTOMER_ID 필수 컬럼도 없다. · 검색어 END_CUSTOMER_ID, Project Code, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-c2189e6092 | K2 | [결함 유형 묶음 K2-G07 · 2건] 조회 결과 Measure 표시 순서 | SCP0005 화면에는 메저셋팅이 없어 Measure 표시 순서를 확인할 대상이 없다. · 검색어 Measure Setting, MeasureSetting, measureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-b56ee2fd52 | M2 | [결함 유형 묶음 M2-G01 · 2건] SQL View 버튼(VIEW) 클릭 결과 | SCP0005 화면에는 SQL View(VIEW) 버튼이 없다. · 검색어 SQL View, btnView, SqlView: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-cd526bd1c3 | M3 | [결함 유형 묶음 M3-G01 · 2건] SQL 버튼 팝업 쿼리 저장 | SCP0005 에는 SQL 버튼과 쿼리를 저장하는 SQL 팝업이 없다. · 검색어 btnSql, SqlPopup, SQL_POPUP: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-7f898721c6 | N1 | [결함 유형 묶음 N1-G02 · 2건] Div별 컬럼·Measure 구성의 AS-IS 일치 | SCP0005 Distribution Route 화면은 정적 컬럼으로 구성되고 Div별 Measure(Cust FCST·End Cust 등) 구성이 AS-IS 소스와 TO-BE 화면 폴더 어디에도 없다. · 검색어 Cust FCST, End Cust, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ac45a2c401 | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SCP0005 조회조건은 Valid·Trans Mode·From/To Country·City 뿐이고 Team(DEPT) 콤보가 없다. · 검색어 DEPT_ID, SCM_MST_SITE_ITEM, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-563657d3c0 | C2 | 그리드 End Customer→Sold-to Customer cascade | SCP0005 그리드에는 End Customer·Sold-to Customer 컬럼이 없고, Country·City는 도시 팝업으로 함께 채워져 후보 cascade가 없다. · 검색어 END_CUSTOMER, SOLD_TO, Sold to: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-98f717bb42 | C2 | 그리드 Sales Company→Sales Plant · Sales Site→Company/Plant | SCP0005 그리드에는 Sales Company→Sales Plant, Sales Site→Company/Plant cascade 대상 컬럼이 없다. · 검색어 SALES_COMPANY, SALES_PLANT, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-260973b28c | H2 | 실적 구간 배경색 | SCP0005 에는 편집 불가 과거 기간인 실적 구간이 없다. · 검색어 ACTUAL, isActual: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-2d7d73fcd1 | B8 | Team 컬럼(MKT FCST 조회·신규행) | SCP0005 그리드에 Team 컬럼이 없습니다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-f186103a3a | J1 | Division 조회조건 후보 | SCP0005 에는 Division 조회조건 후보가 없다. · 검색어 DIVISION_ID, cboDivision, divisionId: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-4619071941 | A5 | 필수 컬럼(Project Code·Plant Site) 표시 · 저장 | SCP0005 그리드에는 Project Code·Plant Site 컬럼이 없다. · 검색어 PROJECT_CODE, PLANT_SITE, Project Code, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-247ec00ce0 | C3 | Sales Company·Sales Plant 셀 | 확정 요구의 대상인 Sales Company·Sales Plant 셀이 SCP0005 그리드에 없다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Company, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-e523cc1006 | D4 | Insert 행 Div · Div 변경 시 그리드 | SCP0005 조회조건은 From/To Country·City, Trans Mode, Valid 뿐이고 Division 조회조건이 없습니다(AS-IS 의 clbDivision 은 주석 처리된 코드입니다). · 검색어 DIVISION_CODE, cboDivision, p_division: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-4fe7c5396c | M3 | Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SCP0005 에는 Exchange Rate 팝업이 없고, Route Id 이력 팝업(SCP0005_DistributionRoutePopup)은 편집·저장 기능이 없는 조회 전용 팝업이다. · 검색어 Exchange Rate, ExchangeRate, BPS: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-6f73648028 | K2 | Measure 순서·메저셋팅 순서 저장 | SCP0005 화면에는 메저셋팅 버튼이 없다. · 검색어 Measure Setting, MeasureSetting, measureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-cca6b06a1a | B4 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/Nickname) | SCP0005 조회조건에는 End Customer·Sold to·Sales Site·Model/Nickname 이 없다. · 검색어 END_CUSTOMER, SOLD_TO, SALES_SITE, Nickname: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-0e5ef92a2b | K2 | Measure 순서 | SCP0005 화면에는 메저셋팅이 없어 Measure 순서를 확인할 대상이 없다. · 검색어 Measure Setting, MeasureSetting, measureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-ccb959c32f | C1 | 조회조건 Division 콤보(DIVISION_ID 단일 선택 화면) · 하위 조회조건 · 전 그리드 | SCP0005는 Division 조회조건이 없는 화면이라 Div 변경 시 그리드·하위 조회조건 초기화 대상이 아니다. · 검색어 DIVISION_ID, FilterMyDivision: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-6aaffd96b9 | C5 | 다중 그리드 더블클릭 연동 | SCP0005 메인 화면 그리드는 spdMain 하나뿐이라 여러 그리드 사이의 더블클릭 연동이 없다. · 검색어 spdSub, spdDetail, DetailGrid: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-fad46c0a2b | A5 | 그리드 행 선택용 체크 컬럼(AS-IS CHK 컬럼 + 머리글 전체 체크) | SCP0005 AS-IS 메인 그리드에는 CHK 컬럼이 없다. · 검색어 "CHK", COL_CHK, headerCheckboxSelection: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |
| C-a229f1f909 | E2 | 월 범위 조회조건 기간 역전(시작 > 끝) | SCP0005 조회조건은 From/To Country·City·Trans Mode·Valid 뿐이고 월 범위 기간 조회조건이 없다. · 검색어 MSG00344, RangePicker, FROM_YYYYMM: AS-IS 화면 소스·TO-BE 화면 폴더 18개 파일·요소 목록 0건 |

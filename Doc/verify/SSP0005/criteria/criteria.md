# SSP0005 기준 원장 (2026-11-25 01:17:24)

- 원장 916행 → 기준 항목 814개 · 요소 55개 · 상태 확정 359 · 대상 아님 403 · 판단 대기 52
- 다른 문서 행 710행: 같은 확인으로 합침 102 · 요소 지정 57 · 화면 전체 96 · 대상 아님(검색 0건 확인) 391 · 판단 대기 52
- TO-BE 룰 결합 134건(인용 불일치로 버림 0) · AS-IS 실측 연결 34건(판단 대기 29) · 사용자의견 고정 0건
- AI 호출 37(기억 0 · 실패 0 · 바꾼 것 없는 호출 0) · 비용 출처 Doc/verify/SSP0005/llm_usage.csv

## 판단 대기(사용자 확인)

| 기준 항목 | 요소 | 규칙 | 확인 | 사유 |
|---|---|---|---|---|
| C-9d3776e0c4 | SCREEN | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | AS-IS Designer의 조회조건 라벨은 Company·Division·Period*·Day of the week·Input Value뿐이고, Sales Site·End Customer·Sold to·Plant Site·Team 콤보는 AS-IS 소스와 TO-BE 화면 폴더 어디에도 없다. · 검색어가 화면에 있음: Plant Site 1곳 |
| C-d197e56e8f | SCREEN | B8 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SSP0005 AS-IS 소스와 TO-BE 화면 조회조건(Company·Div·Period)에는 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보가 없다. · 검색어가 화면에 있음: Plant Site 1곳 |
| C-42a2961677 | SCREEN | G5 | 팝업 연결 조회조건·그리드 컬럼 | SSP0005에는 팝업이 연결된 조회조건이나 그리드 셀이 없다. · 검색어가 화면에 있음: SCM0002 1곳, ItemByDivision 1곳 |
| C-0b7d417fc7 | SCREEN | K1 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | SSP0005에는 업무 팝업 그리드가 없고, Input 버튼의 Bulk Update 팝업은 드롭다운만 있어 No. 컬럼과 건수를 확인할 그리드가 없습니다. · 검색어가 화면에 있음: SCM0002 1곳, ItemByDivisionPopup 1곳 |
| C-0b4e86bbf9 | SCREEN | K3 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | SSP0005 AS-IS 소스에는 팝업을 띄우는 코드가 없고 using GSCM.SCM.Popup.UIL 선언만 있어, 팝업 No. 컬럼·건수 확인 대상이 이 화면에 있는지 검색으로 판정한다. · 검색어가 화면에 있음: SCM0002 1곳, ItemByDivisionPopup 1곳 |
| C-a153f284ea | SCREEN | M4 | 팝업 입력 컬럼 | SSP0005 그리드에는 팝업으로 값을 입력하는 셀이 없고, 셀 값은 btnInput 으로 일괄 입력한다. · 검색어가 화면에 있음: ItemByDivisionPopup 1곳, SCM0002 1곳 |
| C-b5521337d5 | SCREEN | H6 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | SSP0005 그리드에는 ITEM_ID 컬럼과 셀 Model 팝업이 없습니다. · 검색어가 화면에 있음: ItemByDivisionPopup 1곳 |
| C-f785ed2d1b | SCREEN | H1 | [DMF0043 결함 유형] Contribution Version Valid_YN 컬럼 | SSP0005 그리드에는 Valid_YN 컬럼이 없다. · 검색어가 화면에 있음: VALID_YN 1곳, Valid_YN 1곳 |
| C-3c4b9da1c9 | SCREEN | B2 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SSP0005 조회조건은 Company·Division·Period 이고 Team·End Customer·Sales Site 콤보는 AS-IS 소스와 TO-BE 화면 폴더 어디에도 없다. · 검색어가 화면에 있음: SCM_SITE_ID 1곳 |
| C-8386aba0a3 | SCREEN | F6 | [DMF0082 결함 일반화] 필수 컬럼(Project Code·Plant Site) 표시 · 저장 | SSP0005 에는 Project Code 필수 컬럼이 없고, Div 전환 때 개인화 컬럼을 구성하는 기능도 없다. · 검색어가 화면에 있음: Personalize 1곳 |
| C-9b7e617927 | SCREEN | A5 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SSP0005 에는 Measure 셋팅과 VMI·MKT FCST AMT 메저가 없다. · 검색어가 화면에 있음: MKT FCST 1곳 |
| C-1490f4c48c | SCREEN | A1 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | SSP0005 에는 Dynamic Query(ESS KWh 판가 계산) 기능이 없다. · 검색어가 화면에 있음: KWh 1곳 |
| C-53de1526ba | SCREEN | F4 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | SSP0005에는 Dynamic Query 기능이 없다. · 검색어가 화면에 있음: KWh 1곳 |
| C-cba076272b | SCREEN | B4 | [DMF0005 결함 유형] Owner 팝업 사용자 목록 | SSP0005 에는 Owner 팝업이 없다. · 검색어가 화면에 있음: SCM_ADM_USER_M 1곳 |
| C-e47e46899f | SCREEN | H2 | [DMF0021 결함 유형] Partial 주차 편집 구간·실적 구분선 | SSP0005 에는 Partial 주차 편집 구간과 실적 구분선이 없다. · 검색어가 화면에 있음: Partial 3곳 |
| C-b51e1f1945 | SCREEN | K1 | [DMF0053 결함 유형] 팝업 Filter 텍스트 입력창 | SSP0005에는 Filter 텍스트 입력창이 있는 팝업 그리드가 없습니다. · 검색어가 화면에 있음: SCM0002 1곳, ItemByDivisionPopup 1곳 |
| C-4f52f9a8fd | SCREEN | E4 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SSP0005 에는 RTF 저장과 Sales Plan Waterfall 동기화가 없다. · 검색어가 화면에 있음: Waterfall 1곳 |
| C-89d82ae19b | SCREEN | F1 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SSP0005 에는 RTF 저장 판가 검증과 Sales Plan Waterfall 동기화 기능이 없다. · 검색어가 화면에 있음: Waterfall 1곳 |
| C-2b4e0666a2 | SCREEN | F7 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SSP0005 에는 RTF 저장과 Sales Plan Waterfall 연동이 없다. · 검색어가 화면에 있음: Waterfall 1곳 |
| C-5b9966d9ff | SCREEN | N1 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | 이 화면 그리드에는 Sales Plant 셀 콤보가 없고 AS-IS 소스에도 Plant 참조가 없다. · 검색어가 화면에 있음: ACTIVE_FLAG 3곳 |
| C-0082e2b7d0 | SCREEN | D1 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | 이 화면에는 Dept 컬럼과 Use Y/N·Active 헤더가 없다. · 검색어가 화면에 있음: Dept 3곳 |
| C-d96539e279 | SCREEN | H3 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SSP0005 그리드에는 Dept 컬럼과 Use Y/N·Active 헤더가 없고, Company·Divison 컬럼과 일자 컬럼만 있습니다. · 검색어가 화면에 있음: SSO 2곳 |
| C-6e9103df31 | SCREEN | H5 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SSP0005 그리드 컬럼은 Company·Divison·달력 날짜 컬럼이고, Dept 컬럼과 Use Y/N 헤더는 없다. · 검색어가 화면에 있음: Dept 3곳, SSO 2곳 |
| C-2f8a47408e | SCREEN | F1 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SSP0005 에는 Dept 컬럼과 Use Y/N·Active 헤더가 없다. · 검색어가 화면에 있음: Dept 3곳 |
| C-1e8afba91b | SCREEN | F6 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SSP0005 에는 Dept 컬럼과 SSO DEPT 자동 세팅이 없다. · 검색어가 화면에 있음: Dept 3곳, SSO 2곳 |
| C-f03384114d | SCREEN | G5 | [DMF0005 결함 유형] Model 팝업 조회 | SSP0005에는 Model 팝업이 없다. · 검색어가 화면에 있음: SCM0002 1곳 |
| C-c799309192 | SCREEN | F8 | [SYS0011 결함 유형] Approval Date 컬럼 | SSP0005 에는 Request·Approval Date 흐름이 없다. · 검색어가 화면에 있음: Request 2곳 |
| C-1361c75179 | SCREEN | C1 | [DMF0035 결함 유형] Version 조회조건 기본값 | SSP0005 조회조건에는 Version 콤보가 없다. · 검색어가 화면에 있음: Current 3곳 |
| C-bae013bf4c | SCREEN | F7 | [DMF0021 결함 유형] RTF[R+P] → DM_PLN_MKT_FCST / DM_PLN_MKT_FCST_C 연동 | SSP0005 저장은 DM_PLN_MKT_FCST 테이블에 반영하지 않는다. · 검색어가 화면에 있음: Waterfall 1곳 |
| C-24472c3bc3 | SCREEN | G2 | [SCP0028 결함 유형] From Site 조회조건 | SSP0005 조회조건은 Company·Div·Period 이고 From Site 조회조건은 AS-IS 소스에 주석으로만 남아 있다. · 검색어가 화면에 있음: clbFromSite 1곳 |
| C-c945cc1576 | SCREEN | C2 | [SCP0007 결함 유형] Insert 행 Div 셀 / 하위 Site | SSP0005 Insert는 AS-IS InsertButton 본문이 주석뿐인 NO-OP라 새 행이 생기지 않고, 그리드 Division 컬럼은 잠긴 텍스트 컬럼이며 하위 Site 컬럼도 없다. · 검색어가 화면에 있음: SITE_ID 1곳 |
| C-c6affcf640 | SCREEN | G3 | [SCP0007 결함 유형] Active 조회조건 저장·복원 | SSP0005 조회조건에 Active 가 없다. · 검색어가 화면에 있음: Active 4곳 |
| C-7826403232 | SCREEN | C3 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME·PROJECT_STATUS·PROJECT_OWNER·BIZ_TYPE) · Model 팝업(ITEM_ID → | SSP0005 에는 신규 행 Project·Model 팝업과 Sales Site 자동 채움 동작이 없습니다. · 검색어가 화면에 있음: SCM_SITE_ID 1곳 |
| C-800e66b970 | SCREEN | MS1 | [DMF0014 결함 일반화] 공용 업로드 창(Upload) 검증 완료 후 저장 전 Cancel · X 닫기 확인창 MSG00684 「취소하시겠습니까?」(AS-IS MSG00195) | SSP0005 는 공용 업로드 창을 쓰지 않으며, TO-BE 툴바 설정이 upload: false 이다. · 검색어가 화면에 있음: MSG00684 1곳, MSG00195 1곳 |
| C-d90e4e04c2 | SCREEN | G10 | [DMF0074 결함 일반화] 조회조건 Project(PROJECT) · Model/Nickname(MODEL) 입력칸 Enter 키 → Project Popup · Item Popup 열기 · Model 팝업 사전 | SSP0005 에는 Project 입력칸과 Model/Nickname 입력칸이 없고 Project Popup·Item Popup 호출도 없습니다. · 검색어가 화면에 있음: ItemByDivisionPopup 1곳 |
| C-6e4bda5f47 | SCREEN | I1 | [DMF0074 결함 일반화] 공용 Excel Upload 창 안내 메시지 MSG00657(오류 행 저장 차단) · MSG00658 · MSG00659 EN · CN 등록값(SCM_ADM_MSG_M) | SSP0005 에는 Excel 버튼만 있고 공용 Excel Upload 창과 MSG00657·MSG00658·MSG00659 사용처는 검색되지 않습니다. · 검색어가 화면에 있음: MSG00657 1곳, MSG00658 1곳, Upload 1곳 |
| C-1d5f7be063 | SCREEN | I2 | [DMF0043_01 결함 일반화] Version 팝업 미선택 OK 안내 — 다국어 코드 MSG00701(AS-IS MSG00279) 「버전은 1개만 선택해 주세요.」/「Please select only one ve | SSP0005 AS-IS 소스와 TO-BE 화면 폴더에는 Version 팝업과 MSG00701·MSG00279 사용처가 없습니다. · 검색어가 화면에 있음: MSG00701 1곳, MSG00279 1곳 |
| C-fda135d02e | SCREEN | MS1 | [DMF0043_01 결함 일반화] Version 팝업 미선택 OK 안내 — 다국어 코드 MSG00701(AS-IS MSG00279) 「버전은 1개만 선택해 주세요.」/「Please select only one ve | SSP0005 에는 Version 팝업이 없고, AS-IS·TO-BE 모두 MSG00279·MSG00701 을 쓰지 않는다. · 검색어가 화면에 있음: MSG00701 1곳, MSG00279 1곳 |
| C-50df942cf1 | SCREEN | E4 | [결함 유형 묶음 E4-G03 · 2건] 수량 입력 시 Unit Price 조건부 필수 | SSP0005 에는 수량·Unit Price 조건부 필수 검증이 없다. · 검색어가 화면에 있음: MKT FCST 1곳 |
| C-58efbbe004 | SCREEN | F1 | [결함 유형 묶음 F1-G03 · 2건] 신규 행 Insert 후 Save | SSP0005 Insert 버튼은 AS-IS 본문이 주석(//InsertRow())뿐인 무동작이고 TO-BE 에서 숨겨 신규 행 저장 기능이 없다. · 검색어가 화면에 있음: InsertRow 2곳, addRow 2곳 |
| C-332ba80de2 | SCREEN | G5 | [결함 유형 묶음 G5-G01 · 3건] 팝업 Period 기본값(메인 Period 연동) | SSP0005에는 Period 조건을 받는 조회 팝업이 없고 Period는 메인 조회조건에만 있다. · 검색어가 화면에 있음: SCM0002 1곳, ItemByDivision 1곳 |
| C-de44370a00 | SCREEN | G5 | [결함 유형 묶음 G5-G02 · 2건] 팝업 Spread 기간 컬럼 생성 | SSP0005에는 기간 Spread 컬럼을 만드는 조회 팝업이 없다. · 검색어가 화면에 있음: SCM0002 1곳, ItemByDivision 1곳 |
| C-72c3fa4c38 | SCREEN | G5 | [결함 유형 묶음 G5-G03 · 1건] 입력값의 팝업 조건 전달·필터 | SSP0005에는 입력 텍스트를 팝업 조건으로 넘기는 검색 팝업 칸이 없다. · 검색어가 화면에 있음: SCM0002 1곳, ItemByDivision 1곳 |
| C-da0651df77 | SCREEN | M3 | [결함 유형 묶음 M3-G02 · 2건] 팝업 조회조건 입력 후 결과 필터링 | SSP0005 는 조회조건을 입력해 조회하는 팝업을 열지 않고, SCM0002 팝업 호출도 소스에 없다. · 검색어가 화면에 있음: SCM0002 1곳, ItemByDivision 1곳 |
| C-591334c36c | SCREEN | M3 | [결함 유형 묶음 M3-G04 · 2건] 팝업 Period 기간별 월 컬럼 생성·조회 | SSP0005 에는 Period 기간별 월 컬럼을 만드는 팝업이 없고, 일자 컬럼 생성은 메인 그리드에서만 한다. · 검색어가 화면에 있음: SCM0002 1곳 |
| C-9f820cfab6 | SCREEN | G5 | 팝업 연결 조회조건·그리드 컬럼 | SSP0005에는 팝업이 연결된 조회조건이나 그리드 셀이 없다. · 검색어가 화면에 있음: SCM0002 1곳, ItemByDivision 1곳 |
| C-5f6719148d | SCREEN | M4 | 팝업 입력 컬럼 | SSP0005 그리드 셀은 btnInput 과 cboInputValue(Y/N)로만 값을 넣고, __asis-mapping__.md §10 에 업무 팝업 0건으로 적혀 있어 팝업으로 입력하는 컬럼이 없다. · 검색어가 화면에 있음: ItemByDivisionPopup 1곳, SCM0002 1곳 |
| C-f9f9f6a4b5 | SCREEN | H6 | 팝업 No. 컬럼(Model/Owner/Project/Version 팝업) | SSP0005 의 유일한 팝업인 Bulk Update 팝업(ShipmentWorkingDayBulkModal)에는 그리드가 없어 팝업 그리드 No. 컬럼 확인 대상이 없습니다. · 검색어가 화면에 있음: ItemByDivisionPopup 1곳 |
| C-f5c9772f74 | SCREEN | H6 | From City 검색 버튼 | SSP0005 조회조건(Company·Division·Period·Plant Site)에는 팝업을 여는 검색 버튼이 없습니다. · 검색어가 화면에 있음: ItemByDivisionPopup 1곳 |
| C-27c93cf66b | SCREEN | G9 | 팝업 조회조건 텍스트(콤마 다중값) | SSP0005_ShipmentWorkingDay.cs 에는 조회조건 팝업 호출 코드가 없고 팝업 조회조건 텍스트도 없다. · 검색어가 화면에 있음: ItemByDivisionPopup 1곳, SCM0002 1곳 |
| C-b1da07906f | SCREEN | H5 | SCP·SSP 컬럼·조회조건 라벨 Valid→Active | SSP0005 AS-IS 소스의 컬럼과 조회조건(Div·Plant Site·Period)에는 'Valid' 라벨이 없다. · 검색어가 화면에 있음: Valid 4곳, VALID_YN 1곳 |
| C-83f9b7af62 | SCREEN | G5 | 검색 팝업(공용 모달) 호출 인자 | SSP0005 조회조건(Div·Plant Site·Period·Day/Week·Input Value)에는 공용 검색 모달을 호출하는 칸이 없다. · 검색어가 화면에 있음: SCM0002 1곳, ItemByDivision 1곳 |
| 실측 | SP:SQL: SELECT * | - | 실측-파싱 대조 SQL: SELECT * | AS-IS 1회 · TO-BE  · INLINE |
| 실측 | SP:SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW | - | 실측-파싱 대조 SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | (요소 없음) | - | 실측-파싱 대조 (선언 ↔ 실측) | AS-IS 24개 · TO-BE  · INFO |
| 실측 | (요소 없음) | - | 실측-파싱 대조 BaseRibbonCtl | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 Change | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cbo | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 chkAll | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clb | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 dp1 | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 dp2 | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 dtp | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 lbl | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 panel1 | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 pnlBaseForm | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 pnlMain | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 statusStripBaseForm | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txt | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtTextKeyin | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cboDayWeek | AS-IS Day of the week · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnInput | AS-IS Input · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 drpPeriod | AS-IS Period* [필수] · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clbDivision | AS-IS Div · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cboInputValue | AS-IS Input Value · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cboCompany | AS-IS Company · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 spdMain/Shipment Working Day | AS-IS 컬럼 363(보임 362) · 헤더 3단 · 행 0 · 고정 3 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 조회 인자 . | AS-IS  · TO-BE  · NO_PAIR |
| 실측 | COL:DIVISION_ID | - | 조회 인자 SSP0005_GET_SHIPMENT_WORKING_DAY.division_id | AS-IS 81,40,82,81_UC,81_HM,81_HD,81_HG · TO-BE 81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG · DIFF |
| 실측 | (요소 없음) | - | 조회 인자 SSP0005_GET_SHIPMENT_WORKING_DAY.from_yyyymmdd | AS-IS 20260520 · TO-BE 20261113 · DIFF |
| 실측 | (요소 없음) | - | 조회 인자 SSP0005_GET_SHIPMENT_WORKING_DAY.to_yyyymmdd | AS-IS 20270514 · TO-BE 20271107 · DIFF |

## 대상 아님

| 기준 항목 | 규칙 | 확인 | 근거 |
|---|---|---|---|
| C-b99bc93fb6 | K6 | SSP0005 화면 | TO-BE 룰 CR-088: 그리드가 여러 개인 화면의 더블클릭 연동은 AS-IS 와 같이 동작하고 상단 그리드는 재조회·깜빡임 없이 유지되며 팝업 선택값은 즉시 반영된다. · SSP0005 는 spdMain 그리드 하나뿐이고 CellDoubleClick 은 헤더의 주·일 컬럼 펼침/접기에만 쓰여, 상하단 그리드 연동 확인은 대상이 아니다. |
| C-668b3c8c6e | A1 | SSP0005 화면 | TO-BE 룰 CR-105: 값 불일치와 행·키 집합 차이는 판정에서 뺀다(해당없음으로 두고 근거를 표시한다). · SSP0005 조회 결과 행수·키 집합 비교는 차등 검증 판정에서 빠진다. |
| C-82b95035e7 | D6 | SSP0005 정렬 상태 Insert | TO-BE 룰 CR-070: AS-IS 가 기능 없는 버튼(override 본문 공백)을 일괄 노출해도 TO-BE 는 숨긴다(= PASS). · AS-IS InsertButton() 은 본문이 주석(//InsertRow();)뿐이고 TO-BE 는 Insert 버튼을 숨기므로(insert: false), Insert 행 Division·위치·필터·정렬 항목은 확인 대상이 아니다. |
| C-781c92eb35 | D6 | SSP0005 필터 상태 Insert | TO-BE 룰 CR-070: AS-IS 가 기능 없는 버튼(override 본문 공백)을 일괄 노출해도 TO-BE 는 숨긴다(= PASS). · AS-IS InsertButton() 은 본문이 주석(//InsertRow();)뿐이고 TO-BE 는 Insert 버튼을 숨기므로(insert: false), Insert 행 Division·위치·필터·정렬 항목은 확인 대상이 아니다. |
| C-76ce5cfb9d | I1 | SSP0005 시나리오 [자동] CN 언어 조회 건수 총/건 표기 | TO-BE 룰 DD-215: AS-IS: CN 언어 총/건 표기 검사 대상 → TO-BE: 검사 대상 제외(NA) · CN 언어 조회 건수 총/건 표기 항목은 사용자 결정(2026-11-06)으로 검사 대상에서 빠집니다. |
| C-0a34cb8349 | D6 | SSP0005 시나리오 [자동] 선택 행 위로 Insert | TO-BE 룰 CR-070: AS-IS 가 기능 없는 버튼(override 본문 공백)을 일괄 노출해도 TO-BE 는 숨긴다(= PASS). · AS-IS InsertButton() 은 본문이 주석(//InsertRow();)뿐이고 TO-BE 는 Insert 버튼을 숨기므로(insert: false), Insert 행 Division·위치·필터·정렬 항목은 확인 대상이 아니다. |
| C-b053bfc3b6 | D4 | SSP0005 Insert 행 Division | TO-BE 룰 CR-070: AS-IS 가 기능 없는 버튼(override 본문 공백)을 일괄 노출해도 TO-BE 는 숨긴다(= PASS). · AS-IS InsertButton() 은 본문이 주석(//InsertRow();)뿐이고 TO-BE 는 Insert 버튼을 숨기므로(insert: false), Insert 행 Division·위치·필터·정렬 항목은 확인 대상이 아니다. |
| C-d23b7f6374 | A6 | SCM0001_GET_SCP_PERIOD | TO-BE 룰 CR-075: ③ 예외: 그리드에 바인딩되지 않는 룩업·보조 SP(countryCity 등)와 결과 1행 집계 SP(routeCnt)는 대상 아님(NA 사유 기재) · SCM0001_GET_SCP_PERIOD 는 Rows[0][0] 한 값만 읽는 기간 룩업이고 SCP0009_GET_SHEET_CALENDAR_3SPAN 은 기간 컬럼을 만드는 보조 SP 라서, 둘 다 그리드 행에 바인딩되지 않는다. |
| C-92e3ba7aab | A6 | SCP0009_GET_SHEET_CALENDAR_3SPAN | TO-BE 룰 CR-075: ③ 예외: 그리드에 바인딩되지 않는 룩업·보조 SP(countryCity 등)와 결과 1행 집계 SP(routeCnt)는 대상 아님(NA 사유 기재) · SCM0001_GET_SCP_PERIOD 는 Rows[0][0] 한 값만 읽는 기간 룩업이고 SCP0009_GET_SHEET_CALENDAR_3SPAN 은 기간 컬럼을 만드는 보조 SP 라서, 둘 다 그리드 행에 바인딩되지 않는다. |
| C-f39c08f7ab | D1 | siMain.LockColumn | TO-BE 룰 CR-093: D1 편집 기대는 AS-IS 편집 모드 ON 상태(SwitchLock 뒤 LockColumn/LockRange 결과)를 기준으로 판정한다. · 조회 직후 siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true)(cs:420)로 모든 컬럼을 잠그는 것은 편집 모드 OFF 상태라 D1 판정 기준이 아니다. |
| C-03d9396b0d | H4 | SSP0005 스냅샷 화면샷 1920 | TO-BE 룰 CR-114: 화면샷 차이(컬럼 폭 비율 등 표시 차이)는 오류에서 제외한다(PASS 로 근거와 차이 이미지 경로 표시). · 1920·1366 스냅샷 화면샷의 골든 대비 픽셀 차이는 오류로 판정하지 않는다. |
| C-87caffda0b | H4 | SSP0005 스냅샷 화면샷 1366 | TO-BE 룰 CR-114: 화면샷 차이(컬럼 폭 비율 등 표시 차이)는 오류에서 제외한다(PASS 로 근거와 차이 이미지 경로 표시). · 1920·1366 스냅샷 화면샷의 골든 대비 픽셀 차이는 오류로 판정하지 않는다. |
| C-5d5d99dc95 | K2 | 컬럼/Measure 셋팅(개인화 Default) | SSP0005 에는 컬럼/Measure 셋팅 기능이 없어 개인화 Default 컬럼·메저 표시를 확인할 대상이 없다. · 검색어 ColumnSetting, Column Setting, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-52ebdd819d | C1 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SSP0005 조회조건은 Company·Division·Period·Day of the week·Input Value뿐이고, Sales Site·End Customer·Sold to·Plant Site·Team 콤보는 AS-IS Designer와 TO-BE 화면 폴더에 없다. · 검색어 Sales Site, End Customer, Sold to, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목 |
| C-96434ae506 | H6 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | SSP0005 에는 팝업 그리드와 Contribution Sales Version 팝업이 없습니다. · 검색어 PopupGrid, ContributionSalesVersion, VersionPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2e6b5cb460 | G2 | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | SSP0005 조회조건에는 콤마 다중 입력 대상인 Key-in 텍스트 조회조건(Project·Model/Nickname·Owner)이 없다. · 검색어 txtProject, Nickname, OWNER_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fa7f77e961 | B6 | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | SSP0005 조회조건에는 Project·Model/Nickname·Owner 같은 Key-in 텍스트 조회조건이 없고 Company·Div·Period만 있다. · 검색어 Project, Nickname, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ad39ca4385 | K2 | Measure 순서·메저셋팅 순서 저장 | SSP0005 에는 메저셋팅 순서 저장 기능과 조회 결과 Measure 가 없다. · 검색어 MeasureSetting, Measure Setting, Measure, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e57d35738b | B4 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/Nickname) | SSP0005 조회조건은 Company·Division·Period·Day of the week·Input Value뿐이고 End Customer·Sold to·Sales Site·Model/Nickname 조회조건은 AS-IS 소스와 TO-BE 화면 폴더에 없다. · 검색어 End Customer, Sold to, Sales Site, Nickname: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e77bd66f54 | J4 | Home / Auth Request 메뉴 | Auth Request 메뉴 화면은 SSP0005 Shipment Working Day 화면의 AS-IS 소스와 TO-BE 화면 폴더 어디에도 없습니다. · 검색어 AuthRequest, Auth Request: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7963a75d9a | H6 | From City 검색 버튼 | SSP0005 에는 From City 조회조건과 검색 버튼이 없습니다. · 검색어 FROM_CITY, From City, CityPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f9cf1af1fa | G5 | From City 검색 버튼 | SSP0005에는 From City 같은 조회조건 팝업 호출 버튼이 없다. · 검색어 FromCity, From City: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-402c5cf348 | A7 | RTF Measure 금액(AMT) 계산 시 적용 LOC(판가) 기준(RTF · AMT · LOC) | SSP0005 는 출하 근무일(WORKDAY_YN) 화면이고 RTF Measure 금액(AMT)·LOC 계산이 없다. · 검색어 RTF, DEMAND_LOC, RTF_AMT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-93ab600ae4 | M4 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | SSP0005 그리드에는 ITEM_ID 컬럼과 그리드 셀 Model 팝업이 없다. · 검색어 ITEM_ID, ItemPopup, ModelPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0c8c3d723e | DB-SYN | TO-BE PKG 소스(PKG_DMF0003·PKG_DMF0021·PKG_DMF0042·PKG_DMF0045·PKG_DMF0049·PKG_DMF0082) 의 AS-IS 사용자 테이블(TB_FX_USER 등) 참조 | 이 결함은 PKG_DMF0003 등 DMF 패키지 대상이고, SSP0005 는 PKG_SSP0005·PKG_COM0000 을 쓴다. · 검색어 PKG_DMF0003, PKG_DMF0082, TB_FX_USER: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-10fcb12bb5 | A5 | [SYS0002 결함 유형] User 화면 Group 컬럼 | SSP0005 는 User 화면이 아니고 Group 컬럼이 없다. · 검색어 DEFAULT_GROUP, Default Group, GROUP_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b81e063e3f | B6 | [DMF0043_01 결함 유형] 조회조건 Product Group·Biz Type | SSP0005에는 Product Group·Biz Type 조회조건이 없다. · 검색어 Product Group, Biz Type, BIZ_TYPE, PRODUCT_GROUP: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-63f98eb7ef | G2 | [DMF0043_01 결함 유형] 조회조건 Product Group·Biz Type | SSP0005 조회조건에 Product Group·Biz Type 이 없다. · 검색어 Product Group, Biz Type, PRODUCT_GROUP, BIZ_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3104757fd1 | F2 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | 이 행이 확인하는 Sales Site 셀 콤보가 SSP0005 그리드에 없다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f825e4ae4d | B5 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_MST_CUSTOMER_FCST(_C/_H).MEASURE | SSP0005에는 CUST_FCST_MEASURE Measure 콤보가 없다. · 검색어 CUST_FCST_MEASURE, Customer FCST, DM_MST_CUSTOMER_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-97e5f74eef | N1 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_MST_CUSTOMER_FCST(_C/_H).MEASURE | 이 화면에는 Measure Combo와 DM_MST_CUSTOMER_FCST 참조가 없다. · 검색어 CUST_FCST_MEASURE, Cutomer FCST, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e564ed8629 | M3 | [DMF0005 결함 유형] Team 팝업 | SSP0005 에는 Team 팝업이 없다. · 검색어 TeamPopup, SSO_DEPT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-603ca1d994 | G5 | [DMF0005 결함 유형] Team 팝업 | SSP0005에는 Team 팝업이 없다. · 검색어 TeamPopup, SSO_DEPT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c7b55f5f3d | C3 | [DMF0005 결함 유형] Team·Owner 컬럼 | SSP0005 그리드에 Team·Owner 컬럼이 없습니다. · 검색어 OWNER, Owner, TEAM, Team: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-cb619e0d8b | F6 | [DMF0005 결함 유형] Team·Owner 컬럼 | SSP0005 그리드에는 Team·Owner 컬럼이 없다. · 검색어 Team, Owner, OWNER_ID, TEAM_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6b0962d6e4 | F1 | [DMF0005 결함 유형] 하단 Purchase 탭 EDI Incoterms | SSP0005 에는 하단 Purchase 탭과 EDI Incoterms 컬럼이 없다. · 검색어 Incoterms, EDI_INCOTERMS, Purchase: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ded7314c06 | E3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | SSP0005 그리드에는 Team 팝업 컬럼과 Project 컬럼이 없다. · 검색어 Team, Project, TEAM_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6543f9b09f | F3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | SSP0005 그리드에는 Team 팝업 컬럼과 Project 컬럼이 없다. · 검색어 Team, TEAM_CODE, Project, PROJECT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-bff9348768 | D1 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | 이 화면에는 Team 팝업 컬럼과 Project 컬럼이 없다. · 검색어 Team, TEAM_ID, Project: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7ef224360f | K3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | SSP0005 그리드 컬럼은 Company·Division·동적 일자 컬럼뿐이고 Team 팝업 컬럼과 Project 컬럼은 AS-IS 소스에 없다. · 검색어 TEAM_ID, TEAM_NAME, Team, PROJECT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-23ae1d94dd | B4 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SSP0005에는 Team 조회조건과 그리드 Team·End Customer·Sales Site 콤보가 없다. · 검색어 Team, End Customer, Sales Site, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9dcee7a948 | C1 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | 조회조건 Team과 그리드 Team·End Customer·Sales Site 콤보는 SSP0005에 없고, 그리드 컬럼은 Company·Division·일자(Y/N)뿐이다. · 검색어 Team, End Customer, Sales Site, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-03c61888dc | B8 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SSP0005에는 Team 조회조건과 그리드 Team·End Customer·Sales Site 콤보가 없다. · 검색어 Team, DEPT_ID, End Customer, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3c00e1d7c9 | D2 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | 이 화면에는 Monthly Bucket 수량 입력과 Project Code/Model 팝업이 없고 그리드 값은 Y/N 콤보다. · 검색어 Project Code, PROJECT_CD, Current 버전: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f0b4f8c9f9 | F4 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SSP0005 그리드는 일자별 Y/N 콤보 컬럼이다. Monthly Bucket 입력과 Project Code/Model 팝업이 없다. · 검색어 Project Code, PROJECT_CODE, MODEL_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-15ab0b21ce | M3 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SSP0005 는 출하 근무일 그리드만 있는 화면이고 AS-IS·TO-BE 소스에 Project Code/Model 팝업이 없으며, AS-IS 소스의 Monthly 는 Period 구분 상수이다. · 검색어 PROJECT_CODE, ProjectPopup, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-68699fd771 | K2 | [DMF0020 결함 유형] 조회 건수 · Team 컬럼 표시 · 컬럼팝업 저장 설정 | SSP0005 그리드에는 Team 컬럼이 없고 컬럼팝업 저장 구성도 없어 이 결함 유형을 확인할 대상이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a153ee35c0 | J2 | [DMF0020 결함 유형] Price Batch Input 버튼 | SSP0005에는 Price Batch Input 버튼이 없다. · 검색어 Price Batch Input, PriceBatch, btnPriceBatchInput: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-da14b34aaa | K4 | [DMF0020 결함 유형] Price Batch Input 버튼 | SSP0005 의 Input 버튼(btnInput)은 입력값 일괄 반영용이고 Price Batch Input 버튼은 AS-IS 소스에 없다. · 검색어 Price Batch Input, PriceBatch, btnPriceBatchInput: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-791f9d16d0 | G4 | [DMF0020 결함 유형] 조회조건 Project | SSP0005 조회조건에는 Project 가 없습니다. · 검색어 cboProject, PROJECT_ID, Project: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-486666822a | G4 | [DMF0068 결함 유형] Main Version 조회조건 크기 · Version 팝업 Description 컬럼 폭 | SSP0005 에는 Main Version 조회조건과 Version 팝업이 없습니다. · 검색어 Main Version, MAIN_VERSION, cboMainVersion: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-eba587c3e7 | H6 | [DMF0068 결함 유형] Main Version 조회조건 크기 · Version 팝업 Description 컬럼 폭 | SSP0005 에는 Main Version 조회조건과 Version 팝업이 없습니다. · 검색어 MAIN_VERSION, Main Version, VersionPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7986501076 | B4 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer 콤보 | SSP0005 그리드에는 End Customer·Sold to Customer 콤보가 없다. · 검색어 End Customer, Sold to Customer, SOLD_TO: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-29b99aa56a | B7 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer 콤보 | SSP0005 그리드에는 End Customer·Sold to Customer 콤보가 없다. · 검색어 End Customer, Sold to Customer, END_CUSTOMER, SOLD_TO: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8c2538a27d | C2 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | SSP0005 그리드에는 Cust Group·End Customer·Sales Site 컬럼이 없다. · 검색어 Cust Group, CUST_GROUP, End Customer, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d6da1ab2c1 | B2 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | SSP0005 그리드에는 Cust Group→End Customer→Sales Site 연쇄 콤보가 없다. · 검색어 CUST_GROUP, Cust Group, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-94f2dcdc10 | K1 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | SSP0005 그리드에는 Company·Divison 컬럼과 일자 컬럼만 있고 Cust Group→End Customer→Sales Site 연쇄 컬럼은 없습니다. · 검색어 CustGroup, EndCustomer, Cust Group, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e9e072a887 | E4 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Active 컬럼 | SSP0005 그리드에는 Cust Group·End Customer·Sales Site 컬럼이 없다. · 검색어 END_CUSTOMER, CUST_GROUP, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8ddaa675b0 | F6 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Active 컬럼 | SSP0005 에는 Cust Group·End Customer·Sales Site 관계 컬럼이 없다. · 검색어 End Customer, Cust Group, Sales Site, END_CUSTOMER: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8aa427fa1d | C2 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Active 컬럼 | SSP0005 그리드에는 Cust Group·End Customer·Sales Site 관계 컬럼이 없다. · 검색어 Cust Group, End Customer, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b41488befd | B4 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | SSP0005 에는 Team·End Customer·Sales Site 후보가 없다. · 검색어 Team, End Customer, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-250c8d9ef3 | C1 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | Team·End Customer·Sales Site 후보 콤보는 SSP0005 AS-IS 소스와 TO-BE 화면 폴더에 없다. · 검색어 Team, End Customer, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3467d94c7c | D1 | [DMF0068 결함 일반화] Insert 시 Project 컬럼 · Sort | AS-IS InsertButton 본문이 주석 한 줄뿐(cs:335-338)이라 신규 행이 추가되지 않고, 이 화면에는 Project 컬럼이 없다. · 검색어 Project, PROJECT_ID, PROJECT_CD: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2db63e0f84 | M1 | [DMF0014 결함 유형] Excel Form 입력 버킷 | SSP0005 에는 Excel Form 입력 버킷이 없다. · 검색어 Excel Form, ExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-caad1d1b60 | M1 | [DMF0014 결함 유형] Excel Form 양식 | SSP0005 에는 Excel Form 버튼이 없고 Excel 버튼은 그리드 다운로드만 한다. · 검색어 Excel Form, ExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6a24bdfca2 | H2 | [DMF0003 결함 일반화] 실적 구간 배경색 | SSP0005 출하 작업일 그리드에는 편집 불가 실적 구간이 없다. · 검색어 ACTUAL_FLAG, ActualFlag, PLAN_FROM: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-db964bfd97 | D2 | [DMF0003 결함 일반화] 실적 구간 배경색 | 이 화면에는 과거 실적 구간 구분이 없고, AS-IS 는 조회 뒤 LockColumn(cs:420)으로 모든 컬럼을 한꺼번에 잠근다. · 검색어 실적 구간, ACT_FLAG, Actual: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0ffa71e965 | C2 | [DMF0003 결함 유형] AS From Site 입력 후 W35~W38 수량 | SSP0005 그리드에는 AS From Site 컬럼과 주차별 수량 입력이 없다. · 검색어 AS From Site, AS_FROM_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d52e8b5e27 | B8 | [DMF0003 결함 일반화] Team 컬럼(MKT FCST 조회·신규행) | SSP0005 그리드에는 Team 컬럼이 없다. · 검색어 Team, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-cffef7fbcf | A2 | [DMF0003 결함 일반화] Team 컬럼(MKT FCST 조회·신규행) | SSP0005 에는 Team 컬럼이 없어 SSPM DEPT_ID 표시 규칙의 대상이 없다. · 검색어 DEPT_ID, Team, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-300472ea08 | G5 | [DMF0003 결함 유형] Model 팝업(sMdmActive_Sw) | SSP0005에는 Model 팝업이 없다. · 검색어 sMdmActive, ModelPopup, ItemPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6ca297a35e | M3 | [DMF0003 결함 유형] Model 팝업(sMdmActive_Sw) | SSP0005 에는 Model 팝업과 sMdmActive_Sw 전달이 없다. · 검색어 MdmActive, ModelPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-08325555ac | B5 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | SSP0005에는 FCST Type 콤보와 Measure 입력이 없다. · 검색어 FCST Type, FCST_TYPE, SALES_TYPE_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8332b8f66a | D3 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | SSP0005 에는 FCST Type 콤보와 Measure 입력이 없다. · 검색어 FCST Type, FCST_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-362c56bde1 | A5 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SSP0005 에는 컬럼셋팅의 VERSION 컬럼과 AS FROM SITE 컬럼이 없다. · 검색어 AS_FROM_SITE, AS FROM SITE, ColumnSetting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-24fd4d55f5 | K2 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SSP0005 에는 컬럼셋팅 목록과 AS FROM SITE 컬럼이 없다. · 검색어 AS FROM SITE, ColumnSetting, Column Setting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d3781c9203 | N1 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | 이 화면에는 컬럼셋팅 기능이나 AS FROM SITE 컬럼이 없다. · 검색어 AS_FROM_SITE, AS FROM SITE, Column Setting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4012c76d3e | E1 | [DMF0082 결함 유형] MKT_FCST[R+P]·AS_In_Request[R+P]·Unit_Price(LOC) | SSP0005 에는 MKT_FCST[R+P]·AS_In_Request[R+P]·Unit_Price(LOC) 컬럼이 없다. · 검색어 MKT_FCST, AS_IN_REQUEST, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-443aac1875 | M3 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | SSP0005 에는 Price Batch Input 팝업과 End Customer 컬럼이 없다. · 검색어 PriceBatch, Price Batch, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b0cf92a5bb | H3 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | SSP0005 에는 Price Batch Input 팝업, Model 조회조건, End Customer 컬럼이 없습니다. · 검색어 End Customer, END_CUSTOMER, Price Batch, Batch Input: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8a2340a3db | G4 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | SSP0005 에는 Price Batch Input 팝업과 End Customer 컬럼이 없습니다. · 검색어 Price Batch Input, PriceBatch, END_CUSTOMER: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c9d0c26dc8 | M3 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SSP0005 에는 Exchange Rate 팝업 저장 기능이 없다. · 검색어 ExchangeRate, Exchange Rate: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2cf51d48ac | F4 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SSP0005에는 Exchange Rate 팝업이 없다. · 검색어 Exchange Rate, EXCHANGE_RATE, ExchangeRate: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fe54aff5fc | F3 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SSP0005에는 Exchange Rate 팝업 저장이 없다. · 검색어 Exchange Rate, EXCHANGE_RATE, BPS: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c2868873f2 | F1 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SSP0005 에는 Exchange Rate 팝업이 없다. · 검색어 Exchange Rate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6fd1a29f82 | M2 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | SSP0005에는 BPS I/F 버튼과 Last Update Date/By 컬럼이 없습니다. · 검색어 BPS I/F, btnBps, Last Update Date, 반영할 환율 정보가 없습니다: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e6e6ad8a91 | F1 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | SSP0005에는 BPS I/F 버튼, 환율 반영, Last Update Date/By 컬럼이 없다. · 검색어 BPS, Exchange Rate, EXCHANGE_RATE, Last Update Date: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-48a8b9ea45 | A5 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | SSP0005 에는 BPS I/F 버튼과 Last Update Date/By 컬럼이 없다. · 검색어 BPS, BPS I/F, LAST_UPDATE_DATE, Last Update By: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d683b9e7e7 | E4 | [DMF0082 결함 유형] Biz Type 미존재 검증 팝업 메시지 | SSP0005 에는 Biz Type 검증 팝업이 없다. · 검색어 BIZ_TYPE, Biz Type: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-62dad3c4f9 | E1 | [DMF0082 결함 유형] QTY ≥ 0 검증 | SSP0005 그리드에는 QTY 수량 컬럼이 없고 일자별 Y/N 값만 저장한다. · 검색어 QTY, AddNumberColumn: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-517986a1e9 | K2 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SSP0005 에는 Measure 셋팅이 없어 VMI 메저 추가와 MKT FCST AMT 제거를 확인할 대상이 없다. · 검색어 Measure, VMI, MeasureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-32fae84357 | N1 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | 이 화면에는 Measure 셋팅, VMI 메저, MKT FCST AMT 항목이 없다. · 검색어 Measure, VMI, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a836fa27c8 | G1 | [SYS0010 결함 일반화] Lookup 텍스트 조회조건 · 화면 깜빡임 · 상단 Grid 스크롤 | SSP0005 에는 입력 중 대소문자 무시 조회와 깜빡임을 확인할 텍스트 조회조건이 없습니다. · 검색어 TextEdit, TextField, CustomInput: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7054f7e5cd | H4 | [SYS0010 결함 일반화] Lookup 텍스트 조회조건 · 화면 깜빡임 · 상단 Grid 스크롤 | SSP0005 조회조건은 Company 콤보, Division 체크리스트, Period 기간, Day of the week 콤보로만 되어 있고 텍스트 조회조건이 없다. · 검색어 UsrTextBox, TextEdit: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8551a8b261 | B5 | [DMF0082 결함 유형] SCM_FCST·MKT_FCST 편집 구간(GET_ADMIN_GROUP_MEASURE) | SSP0005에는 SCM_FCST·MKT_FCST 편집 구간이 없다. · 검색어 GET_ADMIN_GROUP_MEASURE, SCM_FCST, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0ec7f1aa28 | N1 | [DMF0007 결함 유형] Customer FCST Master 기준정보 | 이 화면은 Customer FCST Master 기준정보를 다루지 않는다. · 검색어 Customer FCST, CUSTOMER_FCST, DM_MST_CUSTOMER_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e22f7652ec | A1 | [DMF0007 결함 유형] Customer FCST Master 기준정보 | SSP0005 에는 Customer FCST Master 기준정보 조회 기능이 없다. · 검색어 Customer FCST, FCST_MASTER, CUSTOMER_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ddd351e0d3 | B4 | [DMF0004 결함 유형] Sales Site 조회조건 표시값 | SSP0005에는 Sales Site 조회조건이 없다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f47d8f302f | C3 | [DMF0005 결함 일반화] Sales Company·Sales Plant 셀 | SSP0005 그리드에 Sales Company·Sales Plant 콤보 셀이 없고 Company·Divison 컬럼은 편집 모드에서 잠깁니다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Company, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c8c7b645c2 | C2 | [DMF0005 결함 일반화] Sales Company·Sales Plant 셀 | SSP0005 그리드에는 Sales Company·Sales Plant 콤보 셀이 없다. · 검색어 Sales Company, Sales Plant, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a793bed4e7 | E1 | [DMF0044 결함 유형] 붙여넣기 후 저장 · 자릿수 | SSP0005 그리드의 입력 컬럼은 일자별 Y/N 콤보뿐이라 붙여넣기 후 자릿수 초과를 검사할 숫자 컬럼이 없다. · 검색어 maxLength, decimalPlaces, AddNumberColumn: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d4537f4a0c | F4 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | SSP0005에는 RTF×Unit Price 계산값 컬럼이 없다. · 검색어 Unit Price, UNIT_PRICE, RTF: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-93dd890bb5 | E1 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | SSP0005 그리드에는 Company·Division 컬럼과 일자별 Y/N 콤보 컬럼만 있고 RTF·Unit Price 계산 컬럼이 없다. · 검색어 UNIT_PRICE, RTF, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4007189730 | E4 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | SSP0005 는 Company·Division·날짜별 Work Day(Y/N) 만 저장하며 RTF×Unit Price 계산값 컬럼이 없다. · 검색어 UNIT_PRICE, RTF, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-eeb5cfdb6f | E4 | [DMF0044 결함 유형] Cell Prod Site 검증 · Application Gr·Country Name | SSP0005 에는 Cell Prod Site·Application Gr·Country Name 컬럼이 없다. · 검색어 CELL_PROD_SITE, Cell Prod Site, Application Gr: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-293e0beaed | F1 | [DMF0044 결함 유형] Cell Prod Site 검증 · Application Gr·Country Name | SSP0005 에는 Cell Prod Site·Application Gr·Country Name 컬럼이 없다. · 검색어 Cell Prod Site, Application Gr, Country Name: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8cd9466d12 | L1 | [DMF0044 결함 유형] Cell Prod Site 검증 · Application Gr·Country Name | SSP0005 에는 Cell Prod Site·Application Gr·Country Name 컬럼이 없다. · 검색어 Cell Prod Site, CELL_PROD_SITE, Application Gr, COUNTRY_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-bf066e4135 | L1 | [DMF0044 결함 유형] Delete 속도 · 병합 셀 Delete CRUD Status | SSP0005 DeleteButton 본문은 주석(//siMain.Delete())뿐이고 삭제 SP 도 없어, 삭제 응답·병합 셀 삭제 기능이 없다. · 검색어 P_SSP0005_DELETE, DELETE_SHIPMENT_WORKING_DAY: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c3aeb55b7c | C1 | [DMF0044 결함 유형] 조회조건 Report Type→Data Type | SSP0005 조회조건에는 Report Type·Data Type 콤보가 없다. · 검색어 Report Type, REPORT_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ec03e7b051 | K4 | [DMF0044 결함 유형] Delete 버튼 | SSP0005 AS-IS 소스에는 Cutoff Data 구분이 없고 Delete 버튼(DeleteButton) 본문도 비어 있다. · 검색어 Cutoff, CUTOFF_YN, Cutoff Data: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3f44de83fd | J2 | [DMF0044 결함 유형] Delete 버튼 | SSP0005에는 Cutoff 데이터 구분이 없어 Cutoff 상태에 따른 Delete 버튼 비노출 기능이 없다. · 검색어 Cutoff, CUTOFF_YN, CutOff: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5e3d6ca0d5 | F1 | [DMF0044 결함 유형] Biz Plan Cutoff Data 저장 값 | SSP0005 에는 Biz Plan Cutoff Data 입력 컬럼이 없다. · 검색어 Biz Plan, Cutoff, CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-da4c7fd5d9 | D2 | [DMF0044 결함 유형] 입력 가능 Measure(Business Plan·Unit Price(LOC)) | 이 화면에는 Business Plan·Unit Price(LOC) Measure 가 없다. · 검색어 Business Plan, Unit Price(LOC), BIZ_PLAN: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3101963e22 | G5 | [DMF0044 결함 유형] Version 팝업 Div 조건 | SSP0005에는 Version 팝업이 없다. · 검색어 VersionPopup, cboVersion: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-48ba21de9a | E4 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | SSP0005 는 그리드가 하나(spdMain)이며 하단 Owner 그리드가 없다. · 검색어 OWNER_ID, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-954fd9b2ed | F1 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | SSP0005에는 Owner 하단 그리드와 상·하단 그리드 연동 조회가 없다. · 검색어 Owner, OWNER_ID, OWNER_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9379c072fd | C5 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | SSP0005 에는 하단 그리드와 Owner 컬럼이 없습니다. · 검색어 OWNER, Owner, spdDetail: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-247c7186f5 | D1 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | 이 화면에는 Exchange Rate Currency 컬럼이 없고, Insert·Delete 버튼은 AS-IS 에서 동작하지 않는다(cs:335-343). · 검색어 Exchange Rate, Currency, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-87b38bf83d | E4 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | SSP0005 에는 Exchange Rate·Currency 컬럼이 없다. · 검색어 CURRENCY, Exchange Rate, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ae7c4bf5e9 | D6 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | SSP0005 에는 Exchange Rate 와 Currency 컬럼이 없다. · 검색어 Exchange Rate, Currency, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3913b8bbf3 | K4 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | SSP0005 AS-IS 소스에는 Exchange Rate Currency 컬럼이 없다. · 검색어 CURRENCY, Exchange Rate, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3f9a1d65fd | G4 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | SSP0005 조회조건에는 Cust Group 이 없습니다. · 검색어 CUST_GROUP, Cust Group, cboCustGroup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9c94097f92 | G1 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | SSP0005 에는 Cust Group 조회조건이 없고, Div. 변경 시 그리드 헤더를 다시 만드는 동작도 없습니다. · 검색어 CustGroup, CUST_GROUP, Cust Group: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-81ba2e6a30 | G1 | [DMF0005 결함 유형] Owner 팝업(PKG_COM0000 COM0004/0006) User 조회조건 | SSP0005 에는 Owner 팝업과 User 조회조건이 없습니다. · 검색어 COM0004, COM0006, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7ffdb8d1d7 | M2 | [DMF0042 결함 유형] Replace 버튼 팝업 Period·조회 | SSP0005에는 Replace 버튼과 Replace 팝업이 없고, 소스의 Replace는 날짜 문자열 치환에만 쓰입니다. · 검색어 btnReplace, Replace Popup, ReplacePopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-68e1517243 | M3 | [DMF0042 결함 유형] Replace 버튼 팝업 Period·조회 | SSP0005 에는 Replace 버튼과 Replace 팝업이 없다. · 검색어 btnReplace, ReplacePopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2d54e2043c | G5 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | SSP0005에는 Ver.Cutoff 팝업이 없다. · 검색어 Cutoff, VersionPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-bba4de3da4 | G4 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | SSP0005 에는 Ver.Cutoff 팝업이 없고, 조회조건은 Company·Div·Period 뿐입니다. · 검색어 Cutoff, Ver.Cutoff, CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-dcc3b7aec5 | H6 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | SSP0005 에는 Ver.Cutoff 팝업이 없습니다. · 검색어 VerCutoff, Ver.Cutoff, CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-76a75c3e5e | H4 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | SSP0005에는 Ver.Cutoff 팝업이 없다. · 검색어 Cutoff, VerCutoff, Ver.Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-bc1ca0799c | M3 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SSP0005 에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 VersionCreate, BP Version: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5f05cf12bb | M2 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SSP0005에는 BP Version 팝업과 Version Create 버튼이 없습니다. · 검색어 Version Create, BP Version, btnVersionCreate: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-16ec1900d5 | E4 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SSP0005 에는 BP Version 팝업이나 Version Create 기능이 없다. · 검색어 Version Create, BP_VERSION, VersionCreate: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fbc378b8e0 | F1 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SSP0005 에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 Version Create, BP Version: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b42ba5712f | B3 | [DMF0049 결함 유형] 버전 팝업 Version 목록 정렬 | SSP0005 에는 버전 팝업이 없고, 이 화면의 팝업은 SCM0002_ITEMBYDIVISIONPOPUP 뿐이다. · 검색어 VersionPopup, VERSION_ID, Version List: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fab2e45fed | M3 | [DMF0049 결함 유형] 버전 팝업 Version 목록 정렬 | SSP0005 에는 버전 팝업과 Version 목록이 없다. · 검색어 VersionPopup, BP Version: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2d48732fe8 | G4 | [DMF0049 결함 유형] Version 조회조건 선택값 표시 | SSP0005 조회조건에는 Version 이 없습니다. · 검색어 cboVersion, VersionField, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c944ae78bf | G7 | [DMF0049 결함 유형] Version 조회조건 선택값 표시 | SSP0005에는 Version 조회조건이 없다. · 검색어 cboVersion, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-190226c0ae | B4 | [DMF0014 결함 유형] Team 조회조건 후보 | SSP0005 에는 Team 조회조건이 없다. · 검색어 Team, DEPT_ID, cboTeam: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-33e330f6a8 | J1 | [DMF0014 결함 유형] Team 조회조건 후보 | SSP0005 AS-IS 소스와 TO-BE 화면 폴더에 Team 조회조건이 없다. · 검색어 Team, cboTeam, TEAM_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f377c84f85 | G1 | [DMF0020 결함 유형] Biz.Type 조회조건 | SSP0005 에는 Biz.Type 조회조건이 없습니다. · 검색어 Biz.Type, BIZ_TYPE, BizType: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d33e304463 | M3 | [DMF0020 결함 유형] Price Batch Input 팝업 Sales Site 조건 | SSP0005 에는 Price Batch Input 팝업의 Sales Site 조건이 없다. · 검색어 PriceBatch, Price Batch, SalesSite: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5482311727 | F4 | [DMF0014 결함 유형] Excel Upload OK·Customs Handbook/Project/Model 검증 | SSP0005에는 Excel Upload 버튼이 없고 Customs Handbook·Project·Model 입력 항목도 없다(TO-BE는 upload: false). · 검색어 Customs Handbook, CUSTOMS_HANDBOOK, ExcelUpload: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4947067a29 | E3 | [DMF0014 결함 유형] Excel Upload OK·Customs Handbook/Project/Model 검증 | SSP0005 에는 Excel Upload 기능이 없고(TO-BE upload: false) Customs Handbook·Project·Model 컬럼도 없다. · 검색어 ExcelUpload, Handbook, CUSTOMS: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-db13297257 | M1 | [DMF0014 결함 유형] Excel Upload 수량 미입력 메시지 | SSP0005 에는 Excel Upload 기능이 없어 수량 미입력 메시지 대상이 없다. · 검색어 Excel Upload, ExcelUpload, UploadModal: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-eca0f9728a | M1 | [DMF0014 결함 일반화] Excel Upload Validation 메시지(Sales Site/Project/Model) | SSP0005 에는 Excel Upload 기능이 없어 행별 Validation 메시지 대상이 없다. · 검색어 Excel Upload, ExcelUpload, UploadModal: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-66f9b854fd | M1 | [DMF0074 결함 유형] Excel Form 양식 헤더 | SSP0005 에는 Excel Form 양식 다운로드 기능이 없어 2단 헤더 양식을 확인할 대상이 없다. · 검색어 Excel Form, ExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d5fc5deac4 | M1 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Validation 메시지 | SSP0005 에는 Excel Upload 기능이 없고 TO-BE 도 upload 버튼을 false 로 두었다. · 검색어 Excel Upload, ExcelUpload, Invalid Column Header: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-1ce60f323f | F1 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Validation 메시지 | SSP0005 에는 Excel Upload 기능과 Key·Period From/To 업로드 컬럼이 없다. · 검색어 Excel Upload, ExcelUpload, Period From: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-de19eed2dd | M1 | [DMF0082 결함 유형] Excel Form 양식 Bucket | SSP0005 에는 Excel Form 양식 Bucket 이 없다. · 검색어 Excel Form, ExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3f694f34d9 | D1 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | 이 화면에는 ETC 입력 Team 컬럼과 Measure 컬럼이 없다. · 검색어 Measure, Sales AMT, TEAM_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-54801d971c | B4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SSP0005 에는 ETC 입력 Team·Measure 컬럼이 없다. · 검색어 Sales AMT, Measure, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-1da4e1d327 | E3 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SSP0005 그리드에는 Team·Measure 컬럼이 없다. · 검색어 Team, Measure, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0f514f58fd | D4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SSP0005 에는 ETC 입력과 Team·Measure 컬럼이 없다. · 검색어 SSPM, Sales AMT, TEAM_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-bc035c6981 | H4 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | SSP0005에는 Dynamic Query 기능이 없다. · 검색어 DynamicQuery, Dynamic Query, SYS0013: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2f3c5b7274 | F8 | [SYS0012 결함 유형] Request 데이터 Reject Reason·Request Date | SSP0005 에는 Reject Reason·Request Date 요청 데이터가 없다. · 검색어 Reject Reason, REJECT_REASON, Request Date: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-66d654f3a2 | B4 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SSP0005 에는 Approval Result 조회조건이 없다. · 검색어 Approval Result, APPROVAL, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-49b91896ee | B6 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SSP0005에는 Approval Result 조회조건 콤보가 없다. · 검색어 Approval Result, APPROVAL, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5079ad90b6 | I2 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SSP0005 조회조건에는 Approval Result 콤보가 없습니다. · 검색어 Approval, APPROVAL_RESULT, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9d29f38e3e | G4 | [DMF0040 결함 유형] Version 조회조건 크기 | SSP0005 조회조건에는 Version 이 없습니다. · 검색어 cboVersion, VersionField, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-58ba323f21 | H5 | [DMF0040 결함 유형] Measure Version(A)/Version(B) 명칭 | SSP0005 에는 Version(A)/Version(B) Measure 비교 기능이 없다. · 검색어 Version(A), Version(B), VERSION_A: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3e1a906d89 | A9 | [DMF0040 결함 유형] Measure Version(A)/Version(B) 명칭 | SSP0005 에는 Version(A)/Version(B) Measure 가 없다. · 검색어 Version(A), Version(B), VERSION_A: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a36862b736 | H2 | [DMF0040 결함 유형] 실적 구간 배경색 | SSP0005 출하 작업일 그리드에는 실적·계획 구간 구분이 없다. · 검색어 ACTUAL_FLAG, ActualFlag, PLAN_FROM: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-921b83d047 | K2 | [DMF0042 결함 유형] Column Setting 팝업 Default 버튼 | SSP0005 에는 Column Setting 팝업이 없어 Default 버튼의 기본 컬럼 구성 복원을 확인할 대상이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e4016d98c6 | C3 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | SSP0005 그리드에 Sales Site·End Customer 셀이 없습니다. · 검색어 Sales Site, END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e888d1b9f2 | D1 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | 이 화면에는 Sales Site·End Customer 셀이 없다. · 검색어 End Customer, END_CUSTOMER, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d022ff84cc | G4 | [DMF0044 결함 유형] Year 조회조건 | SSP0005 조회조건에는 Year 가 없고, 기간은 Period(drpPeriod)로 받습니다. · 검색어 cboYear, YearField, PLAN_YEAR: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9cd34ebf9b | G6 | [DMF0044 결함 유형] Year 조회조건 | SSP0005에는 Year 조회조건이 없고 기간은 Period(drpPeriod)로 받는다. · 검색어 cboYear, lcYear: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c98b8f0846 | A5 | [DMF0044 결함 유형] Measure 항목 구성 | SSP0005 그리드에는 Measure 항목이 없고 Division·Company·일자별 근무일 컬럼만 있다. · 검색어 Measure, MEASURE_ID, UI_CATEGORY: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4d1cbce1e1 | N1 | [DMF0044 결함 유형] Measure 항목 구성 | 이 화면에는 Div별 UI Category 기준 Measure 항목이 없다. · 검색어 Measure, UI_CATEGORY, UI Category: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e77904f59b | B5 | [DMF0044 결함 유형] Measure 항목 구성 | SSP0005에는 Measure 항목 구성이 없다. · 검색어 Measure, UI_CATEGORY, UI Category: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8185dc5adf | M3 | [DMF0005 결함 유형] Owner 팝업 사용자 목록 | SSP0005 에는 Owner 팝업이 없다. · 검색어 OwnerPopup, SSO_USER: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b2550f8d74 | D2 | [DMF0021 결함 유형] Partial 주차 편집 구간·실적 구분선 | 이 화면은 조회 기간의 일자별 Y/N 컬럼만 보여 주며 Partial 주차 편집 구간과 실적 구분선이 없다. · 검색어 PARTIAL_WEEK, 실적 구분선: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5a79a24754 | A5 | [DMF0003 결함 유형] Measure 컬럼 | SSP0005 그리드에는 Measure 컬럼이 없고 컬럼은 Company·Division·일자 컬럼뿐이다. · 검색어 Measure, MEASURE, USER_SELECTED_FLAG: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-69de4e01a0 | J1 | [DMF0003 결함 유형] FCST Type 후보 | SSP0005에는 FCST Type 조회조건이 없다. · 검색어 FCST_TYPE, FcstType, WS(Free): AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-499c939b00 | G2 | [DMF0040 결함 유형] End Customer 다중 선택 조회조건 | SSP0005 조회조건에 End Customer 가 없다. · 검색어 End Customer, END_CUSTOMER, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8dd2bf6256 | K2 | [DMF0040 결함 유형] Column Setting 저장·Default | SSP0005 에는 Column Setting 팝업이 없어 저장 후 새 탭 유지와 Default 기준을 확인할 대상이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-71e8439f01 | A5 | [DMF0040 결함 유형] Column Setting 저장·Default | SSP0005 에는 Column Setting 저장 기능과 Default 기능이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8c0b77759f | G4 | [DMF0040 결함 유형] Ver. 조회조건 기본값 | SSP0005 조회조건에는 Ver. 이 없습니다. · 검색어 cboVersion, VersionField, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0c46e89734 | G6 | [DMF0040 결함 유형] Ver. 조회조건 기본값 | SSP0005에는 Ver. 조회조건이 없다. · 검색어 cboVersion, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b2dbc29026 | K2 | [DMF0040 결함 유형] Measure Setting 버튼 | SSP0005 버튼은 Search·Reset·Insert·Delete·Save·Excel·Input 이고 Measure Setting 버튼이 없다. · 검색어 MeasureSetting, Measure Setting, btnMeasure: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a9fb938e23 | J2 | [DMF0040 결함 유형] Measure Setting 버튼 | SSP0005에는 Measure Setting 버튼이 없다. · 검색어 Measure Setting, btnMeasureSetting, MeasureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-278e50e023 | A5 | [DMF0053 결함 일반화] Column Setting 필수 컬럼 표시·Div 전환 End Customer | SSP0005 에는 필수 컬럼을 빨간색으로 표시하는 컬럼셋팅 팝업이 없다. · 검색어 USER_SELECTED_FLAG, ColumnSetting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-124377b9f8 | G1 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | SSP0005 조회조건과 그리드에는 Biz Type 조건과 컬럼이 없습니다. · 검색어 Biz Type, BIZ_TYPE, BizType: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ab35ed9363 | M3 | [DMF0053 결함 유형] 팝업 Filter 텍스트 입력창 | SSP0005 에는 Filter 텍스트 입력창이 있는 팝업이 없다. · 검색어 PopupFilter, PopupSearch: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b0ec14516b | D2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | 이 화면에는 Current 버전 입력 Measure 와 AS From Site 콤보가 없다. · 검색어 AS_In_Req, VMI_In_Req, MKT_FCST, AS From Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2c0084ae5d | J3 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SSP0005에는 MKT_FCST·SCM_FCST·AS_In_Req·VMI_In_Req 입력 Measure와 AS From Site 콤보가 없다. · 검색어 GET_ADMIN_GROUP_MEASURE, AS_In_Req, VMI_In_Req, AS From Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b47d58f153 | D3 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SSP0005 에는 Measure 입력 컬럼과 AS From Site 콤보가 없다. · 검색어 SCM_FCST, AS From Site, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-588232d91c | B5 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SSP0005에는 MKT_FCST·SCM_FCST·AS_In_Req·VMI_In_Req Measure와 AS From Site 콤보가 없다. · 검색어 MKT_FCST, SCM_FCST, AS_In_Req, VMI_In_Req: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f7ef4d3792 | B4 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SSP0005에는 MKT_FCST·SCM_FCST·AS_In_Req·VMI_In_Req Measure와 AS From Site 콤보가 없다. · 검색어 MKT_FCST, SCM_FCST, AS_In_Req, VMI_In_Req: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4b187b3798 | C2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SSP0005 그리드에는 Measure 입력 행과 AS From Site 콤보가 없다. · 검색어 MKT_FCST, AS_In_Req, VMI_In_Req, AS From Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8688e7d7be | B4 | [DMF0082 결함 유형] FCST Type 후보 | SSP0005 에는 FCST Type 후보가 없다. · 검색어 FCST_TYPE, SALES_TYPE_CODE, FCST Type: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7614bd8a0e | N1 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site ID | 이 화면에는 MKT_FCST나 Unit Price(LOC) 입력이 없고 저장 대상은 WORKDAY_YN뿐이다. · 검색어 MKT_FCST, UNIT_PRICE, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a0e1204cee | F1 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site ID | SSP0005 에는 MKT_FCST 와 Unit Price(LOC) 조건부 필수 검증이 없다. · 검색어 MKT_FCST, Unit Price, UNIT_PRICE_LOC: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-85dde47d64 | M3 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SSP0005 에는 Exchange Rate 팝업 Close·재오픈 기능이 없다. · 검색어 ExchangeRate, Exchange Rate, BPS: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3d4650c341 | F2 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SSP0005에는 Exchange Rate 팝업이 없다. · 검색어 Exchange Rate, EXCHANGE_RATE, BPS: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c974e35dd5 | M2 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SSP0005 AS-IS 소스와 TO-BE 화면 폴더에는 Exchange Rate 팝업과 BPS I/F 버튼이 없습니다. · 검색어 Exchange Rate, ExchangeRate, BPS I/F: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e5e50847a8 | M4 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SSP0005 에는 Exchange Rate 팝업과 BPS I/F 가 없다. · 검색어 ExchangeRate, Exchange Rate, BPS: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e67b9750c4 | D2 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | 이 화면에는 RTF[R+P] Measure 와 Cutoff 상태에 따른 편집 조건이 없다. · 검색어 Cutoff, CUTOFF_STATUS, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-820bc8e53b | J3 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | SSP0005에는 RTF[R+P] Measure와 Cutoff 기준 편집 조건이 없다. · 검색어 RTF[R+P], GET_ADMIN_GROUP_MEASURE, Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fbfe249229 | E4 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | SSP0005 에는 RTF[R+P] 컬럼과 Cutoff 기준 편집 조건이 없다. · 검색어 RTF, Cutoff, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8b4c466056 | E4 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SSP0005 에는 FCST Type·Text 필수 검증이 없다. · 검색어 FCST_TYPE, FCST Type: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a2b1b9de1a | F6 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SSP0005 에는 FCST Type=ETC Text 필수 검증과 ETC 수정 저장이 없다. · 검색어 FCST_TYPE, FCST Type, ETC 테이블: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-233fdcbfa6 | F1 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SSP0005 에는 FCST Type 과 ETC Text 입력 컬럼이 없다. · 검색어 FCST Type, FCST_TYPE, ETC_TEXT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-448c8143aa | D1 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | 이 화면 그리드는 Company·Divison 과 동적 일자 Y/N 컬럼으로만 이루어져 Sales Site·Project 팝업·Model·Team 컬럼이 없다. · 검색어 SALES_SITE, SALES_PLAN_ITEM_ID, Project, Team: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5f695e8fe6 | C3 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SSP0005 그리드는 Company·Divison·날짜별 출하 근무일 컬럼만 있고 Sales Site·Project·Model·Team 컬럼이 없습니다. · 검색어 SALES_PLAN_ITEM_ID, PROJECT_CODE, Sales Site, TEAM: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9f6fe49ac8 | B5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SSP0005 신규 행에는 Sales Site·Project 팝업·Model·Team 컬럼이 없다. · 검색어 Sales Site, SALES_PLAN_ITEM_ID, Project Popup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-046e6bc543 | M3 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SSP0005 그리드에는 Sales Site·Project·Model·Team 컬럼과 Project 팝업이 없다. · 검색어 SalesSite, SALES_PLAN_ITEM_ID, ProjectPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-1b8d78f95d | G5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SSP0005 그리드에는 Sales Site·Project·Model·Team 컬럼과 해당 팝업이 없다. · 검색어 SALES_PLAN_ITEM_ID, ProjectPopup, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-00de5fd7a1 | D5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SSP0005 에는 Sales Site·Project 팝업·Model·Team 컬럼이 없다. · 검색어 Sales Site, SALES_PLAN_ITEM_ID, Project: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9030cebb63 | A5 | [DMF0021 결함 일반화] Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | SSP0005 에는 컬럼셋팅 팝업이 없어서 OK 를 눌렀을 때 그리드 컬럼을 다시 짜는 확인을 할 대상이 없다. · 검색어 ColumnSetting, columnSetting, 컬럼셋팅, Column Setting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6d949b4553 | K2 | [DMF0021 결함 일반화] Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | SSP0005 에는 컬럼셋팅 팝업이 없어 OK 를 눌렀을 때 그리드 컬럼이 다시 구성되는지 확인할 대상이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7b5a2c2267 | D3 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SSP0005 에는 AS From Site 컬럼과 Measure 후보 콤보가 없다. · 검색어 AS From Site, AS_FROM_SITE, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f01ab089c6 | C2 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SSP0005 그리드에는 AS From Site 컬럼과 Measure 콤보가 없다. · 검색어 AS From Site, AS_FROM_SITE, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-cacdbd2d78 | B4 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SSP0005 에는 AS From Site 콤보와 Measure 후보가 없다. · 검색어 AS_FROM_SITE, AS From Site, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-294f5bb5a0 | B5 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SSP0005에는 AS From Site 콤보와 Measure 후보가 없다. · 검색어 AS From Site, AS_FROM_SITE, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7779623a87 | J3 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SSP0005에는 AS From Site 콤보와 Measure 후보가 없다. · 검색어 AS From Site, AS_FROM_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-81b40a9fa8 | B4 | [DMF0082 결함 유형] End Customer 셀 콤보 후보 | SSP0005 그리드에는 End Customer 셀 콤보가 없고 셀 콤보는 Company·요일별 Y/N 컬럼뿐이다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-56df6d7880 | B5 | [DMF0082 결함 유형] End Customer 셀 콤보 후보 | SSP0005 그리드에는 End Customer 셀 콤보가 없다. · 검색어 End Customer, END_CUSTOMER: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7f68390850 | M3 | [DMF0082 결함 유형] Excel Form 팝업 Search | SSP0005 에는 Excel Form 버튼과 Excel Form 팝업이 없다. · 검색어 ExcelForm, Excel Form: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-aeff1bcb26 | M1 | [DMF0082 결함 유형] Excel Form 팝업 Search | SSP0005 에는 Excel Form 팝업이 없다. · 검색어 Excel Form, ExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-260ff175ea | K2 | [DMF0082 결함 일반화] 컬럼·메저 셋팅 Save/OK 재조회 | SSP0005 에는 컬럼·메저 셋팅 팝업이 없어 변경 없이 Save/OK 할 때 재조회하지 않는지 확인할 대상이 없다. · 검색어 ColumnSetting, Column Setting, MeasureSetting, Measure Setting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4a2327a111 | B4 | [DMF0082 결함 유형] Customs Handbook 콤보 후보 | SSP0005 에는 Customs Handbook 콤보가 없다. · 검색어 Customs Handbook, CUSTOMS: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-16575d9395 | B4 | [DMF0005 결함 유형] Team 조회조건 후보 | SSP0005 에는 Team 조회조건이 없다. · 검색어 Team, DEPT_ID, cboTeam: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ce551b3981 | B7 | [DMF0005 결함 유형] Team 조회조건 후보 | SSP0005에는 Team 조회조건이 없다. · 검색어 Team, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-51a8b19dd2 | A5 | [DMF0020 결함 유형] 콤보 입력 컬럼·COL_LIST·Measure 위치 | SSP0005 에는 COL_LIST 컬럼이 없고, UI Category 에 따라 Measure 위치를 정하는 구성도 없다. · 검색어 COL_LIST, Measure, UI_CATEGORY: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6593fa2b24 | B4 | [DMF0035 결함 유형] Version 조회조건 | SSP0005 에는 Version 조회조건이 없다. · 검색어 Version, cboVersion, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-758d639c86 | M3 | [DMF0035 결함 유형] Version 조회조건 | SSP0005 조회조건은 Company·Division·Period·Day of the week 이고 Version 조회조건은 없다. · 검색어 cboVersion, VersionPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f8f5b0dbcc | F1 | [DMF0082 결함 유형] Unit Price(LOC) 저장 | SSP0005 그리드는 Company·Division 과 일자별 근무여부(Y/N) 컬럼만 저장하며 Unit Price(LOC) 컬럼은 없다. · 검색어 Unit Price, UNIT_PRICE_LOC: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-732476d8fc | F6 | [DMF0082 결함 유형] Unit Price(LOC) 저장 | SSP0005 에는 Unit Price(LOC) 입력·저장 기능이 없다. · 검색어 UNIT_PRICE, Unit Price, Unit Price(LOC): AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fbc88c9e67 | G4 | [DMF0035 결함 유형] Plan Type 조회조건 위치 | SSP0005 조회조건에는 Plan Type 이 없습니다. · 검색어 PLAN_TYPE, cboPlanType, Plan Type: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-52d4e4e155 | H4 | [DMF0035 결함 유형] Project/Model/Owner 조회조건 팝업 | SSP0005에는 Project/Model/Owner 조회조건과 그 팝업이 없다. · 검색어 ProjectPopup, OwnerPopup, txtProject: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e8459dcede | H6 | [DMF0035 결함 유형] Project/Model/Owner 조회조건 팝업 | SSP0005 에는 Project·Model·Owner 조회조건 팝업이 없습니다. · 검색어 ProjectPopup, ModelPopup, OwnerPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-04c1487284 | H6 | [DMF0005 결함 유형] Team 팝업 조건(Team ID/Team Name) | SSP0005 에는 Team 팝업과 Team ID·Team Name 조건이 없습니다. · 검색어 TeamPopup, TEAM_ID, Team Name: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3902c195b0 | B4 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | SSP0005 그리드에는 Sales Plant 셀 콤보가 없다. · 검색어 Sales Plant, SALES_PLANT, SalesPlant: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-213bd7ba1e | H6 | [DMF0005 결함 일반화] 팝업 No. 컬럼(Model/Owner/Project/Version 팝업) | SSP0005 의 Bulk Update 팝업에는 그리드가 없어 No. 컬럼 확인 대상이 없습니다. · 검색어 PopupGrid, ModelPopup, OwnerPopup, VersionPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9689563232 | G2 | [SYS0002 결함 유형] Active 조회조건(ALL)·User Group 다중선택 | SSP0005 조회조건에 Active·User Group 이 없다. · 검색어 cboActive, User Group, USER_GROUP: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-aa4963447a | F4 | [SYS0002 결함 유형] Active 조회조건(ALL)·User Group 다중선택 | SSP0005 조회조건은 Company·Division·Plant Site·Period다. Active(ALL)·User Group 다중선택 조건이 없다. · 검색어 User Group, UserGroup, USER_GROUP: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-67f36fb603 | A5 | [DMF0021 결함 일반화] 컬럼셋팅 Company ID(필수 표시·Invisible 이동) | SSP0005 에는 필수 컬럼의 Invisible 영역 이동을 막아야 할 컬럼셋팅 팝업이 없다. · 검색어 ColumnSetting, 컬럼셋팅, USER_SELECTED_FLAG: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7c7a67d41c | K2 | [DMF0035 결함 유형] Measure 명칭 MKT FCST[R+P] | SSP0005 조회 결과에는 Measure 행이 없고 메저셋팅 기능도 없어 MKT FCST[R+P] 명칭을 확인할 대상이 없다. · 검색어 MeasureSetting, Measure Setting, Measure, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6eb66e8533 | H5 | [DMF0035 결함 유형] Measure 명칭 MKT FCST[R+P] | SSP0005 Shipment Working Day 화면에는 Measure 명칭 MKT FCST[R+P] 표시 기능이 없고, AS-IS 소스에는 'Mkt fcst' 문구가 주석으로만 있다. · 검색어 MKT FCST[R+P], MeasureSetting, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-82ae0e1cd6 | H8 | [SYS0012 결함 유형] Request Date 컬럼 | SSP0005 요소 목록에는 Request Date 컬럼이 없고 컬럼은 Company·Divison·날짜 동적 컬럼뿐이다. · 검색어 REQUEST_DATE, Request Date, REQ_DATE, RequestDate: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-733ba53f61 | C3 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SSP0005 그리드에 Dept 컬럼과 Use Y/N·Active 헤더가 없습니다. · 검색어 DEPT_ID, USE_YN: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e753d818dc | A5 | [SYS0014 결함 유형] Email 컬럼 | SSP0005 그리드에는 Email 컬럼이 없다. · 검색어 EMAIL, Email: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2cc6246ad1 | M3 | [SYS0014 결함 유형] User 팝업(User Info) | SSP0005 에는 User 팝업(User Info)이 없다. · 검색어 UserPopup, SSO_USER: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-06260fbdc1 | F1 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | SSP0005 에는 JV Planner 용 Division 시트가 없다. · 검색어 JV Planner, JV_PLANNER: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b19b204dc2 | F6 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | SSP0005 에는 JV Planner 용 Division 시트 저장 기능이 없다. · 검색어 JV Planner, JV_PLANNER, Division 시트: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9af87b8954 | B4 | [SYS0010 결함 유형] System 컬럼 입력 방식 | SSP0005 그리드에는 System 컬럼이 없고 Company·Divison·요일별 Y/N 컬럼만 있다. · 검색어 SYSTEM Lookup, SYSTEM_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c02fa1b400 | A5 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | SSP0005 에는 URL·ROUTE_PATH 컬럼이 없다. · 검색어 ROUTE_PATH, Route Path: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d1c15e1820 | D1 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | 이 화면에는 ROUTE_PATH 컬럼이 없다. · 검색어 ROUTE_PATH, Route Path: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-79fd84de72 | F1 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | SSP0005 에는 URL-ROUTE_PATH 컬럼이 없다. · 검색어 ROUTE_PATH, Route Path: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0b0267c385 | B6 | [SYS0005 결함 유형] Schema 조회조건 | SSP0005에는 Schema 조회조건이 없다. · 검색어 Schema, SCHEMA_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-95da31db14 | G2 | [SYS0005 결함 유형] Schema 조회조건 | SSP0005 조회조건에 Schema 가 없다. · 검색어 Schema, SCHEMA_NAME, cboSchema: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-dbf1474184 | G1 | [SYS0005 결함 유형] Schema 조회조건 | SSP0005 에는 Schema 조회조건이 없습니다. · 검색어 cboSchema, SCHEMA_ID, Schema Name: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-48783619d7 | B6 | [SYS0006 결함 유형] API Type 조회조건 | SSP0005에는 API Type 조회조건이 없다. · 검색어 API Type, API_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6911c6e245 | B4 | [SYS0006 결함 유형] API Type 조회조건 | SSP0005에는 API Type 조회조건이 없다. · 검색어 API Type, API_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-72d882011b | B1 | [SYS0006 결함 유형] API Type 조회조건 | SSP0005 조회조건에는 API Type 이 없고 Div·Plant Site·Period 만 있다. · 검색어 API_TYPE, API Type, ApiType: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-02d21dbd03 | B4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SSP0005 에는 Module·Sub Module 조회조건과 Notice Content 가 없다. · 검색어 Sub Module, SUB_MODULE, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7372dbf846 | B6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SSP0005에는 Module·Sub Module 조회조건, Notice Content, Active 항목이 없다. · 검색어 Sub Module, Notice Content, NOTICE_CONTENT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b4131ae05a | G4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SSP0005 에는 Module·Sub Module 조회조건과 Notice Content 가 없습니다. · 검색어 Sub Module, SUB_MODULE, cboSubModule: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4da4d8790d | H5 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SSP0005 에는 Module·Sub Module 조회조건과 Notice Content 기능이 없다. · 검색어 Sub Module, Notice Content, Insert Module: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9a2c3565b8 | D4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SSP0005 에는 Module·Sub Module 조회조건과 Notice Content 입력이 없다. · 검색어 Sub Module, SUB_MODULE, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7b1bf3b7be | H6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SSP0005 에는 Module·Sub Module 조회조건과 Notice Content 가 없습니다. · 검색어 SUB_MODULE, Sub Module, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d6b1f6d6ef | K5 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SSP0005 에는 Module·Sub Module 조회조건과 Notice Content 가 없다. · 검색어 Sub Module, SUB_MODULE, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a83ea53103 | B6 | [SYS0017 결함 유형] Module / Sub Module 조회조건 | SSP0005 조회조건은 Company·Div·Period뿐이고 Module·Sub Module 조회조건이 없다. · 검색어 Sub Module, SUB_MODULE, MODULE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c12c66e85a | G4 | [SYS0017 결함 유형] Module / Sub Module 조회조건 | SSP0005 에는 Module·Sub Module 조회조건이 없습니다. · 검색어 Sub Module, SUB_MODULE, cboSubModule: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f64993d81a | B4 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SSP0005 에는 하단 그리드와 Sales Company·Sales Plant 콤보가 없다. · 검색어 Sales Company, Sales Plant, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6f04292a48 | C2 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SSP0005 그리드에는 Sales Company·Sales Plant 콤보 컬럼이 없다. · 검색어 Sales Company, Sales Plant, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f9850a2c5b | F2 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SSP0005 그리드에는 Sales Company/Sales Plant 콤보 컬럼이 없다. · 검색어 Sales Company, SALES_COMPANY, Sales Plant, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-edb6dda3a6 | F1 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SSP0005 그리드에는 Sales Company/Sales Plant 콤보 컬럼이 없다. · 검색어 Sales Company, SALES_COMPANY, Sales Plant, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0e9278d8ac | H6 | [DMF0005 결함 유형] Project 팝업(그리드) | SSP0005 에는 Project 팝업이 없습니다. · 검색어 ProjectPopup, PROJECT_ID, Project: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-acf76580b3 | M3 | [DMF0005 결함 유형] Project 팝업(그리드) | SSP0005 에는 Project 팝업이 없다. · 검색어 ProjectPopup, Project: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-93e250cadd | G2 | [DMF0005 결함 유형] Project 팝업(그리드) | SSP0005 에는 Project 팝업이 없다. · 검색어 Project, PROJECT_ID, ProjectPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-753812dfbc | B3 | [SYS0010 결함 유형] 메인화면 System admin 정보(SYSTEM_ADM Lookup) | SSP0005 는 Shipment Working Day 화면이고, 메인화면의 System admin 정보 표시 기능은 이 화면에 없다. · 검색어 System admin, SystemAdmin: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fcda6668fc | E4 | [DMF0004 결함 유형] Customer 탭 Sold to/Ship to 저장 검증 | SSP0005 에는 Customer 탭과 Sold to·Ship to 컬럼이 없다. · 검색어 SOLD_TO, SHIP_TO, NERP_CONV_MASTER: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8826621a15 | E3 | [DMF0005 결함 유형] Project 컬럼 필수 검증 | SSP0005 그리드에는 Project 컬럼이 없다. · 검색어 Project, PROJECT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-27e7d75f95 | E4 | [DMF0005 결함 유형] Project 컬럼 필수 검증 | SSP0005 그리드에는 Project 컬럼이 없다. · 검색어 PROJECT_ID, Project: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c85fcee802 | B7 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SSP0005 그리드에는 Team(DEPT_ID) 셀 콤보가 없다. · 검색어 Team, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-583e2ec2a5 | A2 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SSP0005 그리드에는 Team(DEPT_ID) 셀 콤보가 없다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2923a5b7bb | B4 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SSP0005 그리드에는 Team(DEPT_ID) 셀 콤보가 없다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5e418d0c0e | B7 | [DMF0003 결함 유형] Team 정보(DEPT_ID) | SSP0005에는 Team(DEPT_ID) 정보가 없다. · 검색어 Team, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-05ee50f00b | A1 | [DMF0003 결함 유형] Team 정보(DEPT_ID) | SSP0005 그리드에는 Team(DEPT_ID) 컬럼이 없다. · 검색어 DEPT_ID, Team, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-eaf6cb8bbd | F7 | [DMF0020 결함 유형] Unit Price(LOC) → Sales Price 연동 | SSP0005 에는 Unit Price(LOC)→Sales Price 연동이 없다. · 검색어 Unit Price, Sales Price, UNIT_PRICE, SALES_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-935e198244 | F1 | [DMF0020 결함 유형] Unit Price(LOC) → Sales Price 연동 | SSP0005 에는 Unit Price(LOC) 와 Sales Price 연동 기능이 없다. · 검색어 Sales Price, SALES_PRICE, UNIT_PRICE_LOC: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5f1f15a97a | B5 | [SYS0012 결함 유형] 권한 신청 가능 Group 목록 | SSP0005에는 권한 신청 Group 목록이 없다. · 검색어 REQ_NO_DISPLAY, 권한 신청: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-931cce11dc | F1 | [SYS0011 결함 유형] Approval Date 컬럼 | SSP0005 에는 Approval Date 컬럼이 없다. · 검색어 Approval Date, APPROVAL_DATE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3e4293835f | C5 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | SSP0005 에는 Mail Setup 탭과 사용자 좌/우 그리드가 없습니다. · 검색어 Mail Setup, MAIL, spdUser: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4393fc7583 | F1 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | SSP0005에는 Mail Setup 탭과 사용자 좌/우 그리드가 없다. · 검색어 Mail Setup, MailSetup, MAIL_USER: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b9cf195b30 | F5 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | SSP0005에는 Mail Setup 탭과 좌/우 사용자 그리드가 없다. · 검색어 Mail Setup, MAIL_SETUP, MailSetup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-32454b9ce6 | G4 | [DMF0035 결함 유형] Version 조회조건 돋보기 버튼 | SSP0005 에는 Version 조회조건과 그 돋보기 버튼이 없습니다. · 검색어 cboVersion, VersionField, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-26f57dc044 | H4 | [DMF0035 결함 유형] Version 조회조건 돋보기 버튼 | SSP0005 AS-IS 소스와 TO-BE 화면 폴더에 Version 조회조건과 돋보기 버튼이 없다. · 검색어 Version, txtVersion, VersionPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-94f99c2c1d | A3 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | SSP0005 는 SUM 헤더가 주석 처리되어 있고 Sum/Qty≠0 체크박스가 없다. · 검색어 Qty≠0, chkSum, SUM_QTY: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-da495ec3f5 | H5 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | SSP0005 에는 Sum 행과 Sum·Qty≠0 체크박스가 없고, AS-IS 소스에는 SUM 헤더 처리가 주석으로만 있다. · 검색어 Qty≠0, Sum/Qty, chkSum: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c2ba314979 | G4 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | SSP0005 에는 Sum 행 표기와 Sum·Qty≠0 체크박스가 없고, AS-IS SUM 헤더 코드는 주석 처리돼 있습니다. · 검색어 chkSum, Sum/Qty, Qty≠0: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f36aada600 | A5 | [DMF0035 결함 유형] Version 컬럼 | SSP0005 그리드에는 Version 컬럼이 없다. · 검색어 VERSION_ID, PLAN_VERSION, Version: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c8cf3268f3 | A1 | [DMF0082 결함 유형] RTF[R+P] Measure 행 | SSP0005 그리드는 Company·Divison·일자(D_) 컬럼만 있고 RTF[R+P] Measure 행이 없다. · 검색어 RTF, MEASURE_CD, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-45f6568098 | F1 | [DMF0021 결함 유형] RTF[R+P] → DM_PLN_MKT_FCST / DM_PLN_MKT_FCST_C 연동 | SSP0005 저장은 SSP_MST_SHIP_CALENDAR 만 갱신하며 DM_PLN_MKT_FCST 연동이 없다. · 검색어 DM_PLN_MKT_FCST, MKT_FCST, RTF: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-525cd33796 | M3 | [SCP0028 결함 유형] 메인 그리드 행 정렬 | SSP0005 에는 팝업 결과를 메인 그리드에 반영하는 기능이 없어 반영 후 행 정렬을 확인할 대상이 없다. · 검색어 PopupApply, SCP0028: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fd2ab29ff5 | I2 | [SCP0028 결함 유형] Lot Size<Increment 검증 메시지 | SSP0005 AS-IS 소스와 TO-BE 화면 폴더에서 Lot Size·Increment 검증 메시지가 검색되지 않습니다. · 검색어 LotSize, Lot Size, Increment: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d5a0ddc1bf | I1 | [SCP0028 결함 유형] Lot Size<Increment 검증 메시지 | SSP0005 AS-IS 소스와 TO-BE 화면 폴더에서 Lot Size·Increment 입력과 그 검증 메시지가 검색되지 않습니다. · 검색어 LotSize, Lot Size, Increment: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fb7ed3e060 | E4 | [SCP0028 결함 유형] Lot Size<Increment 검증 메시지 | SSP0005 에는 Lot Size·Increment 검증이 없다. · 검색어 LOT_SIZE, Lot Size, Increment: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c79c7cd9ac | A1 | [SCP0006 결함 유형] BOM Explosion Plant Assign(MCCH125020A1/MACH125020A1) | SSP0005 는 출하 작업일 화면이며 BOM Explosion Plant Assign 기능이 없다. · 검색어 Plant Assign, PLANT_ASSIGN, BOM Explosion: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4d8c36ee2e | N1 | [SCP0006 결함 유형] BOM Explosion Plant Assign(MCCH125020A1/MACH125020A1) | 이 화면에는 BOM Explosion이나 Plant Assign 기능이 없다. · 검색어 BOM, Explosion, Plant Assign: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f05ae03983 | D3 | [SCP0006 결함 유형] Plant Assign 그리드 색상 | SSP0005 그리드는 Company·Division·일자별 Y/N 컬럼만 있으며, SCP0006 의 Plant Assign 그리드와 CA1 행 색상 처리는 이 화면에 없다. · 검색어 Plant Assign, PLANT_ASSIGN, CA1: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-53dc258b3e | H2 | [SCP0006 결함 유형] Plant Assign 그리드 색상 | SSP0005 에는 Plant Assign 그리드와 CA1 행이 없다. · 검색어 Plant Assign, PLANT_ASSIGN, CA1: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-70e178f239 | G5 | [SCP0006 결함 유형] Capa New Model 팝업 조건(Group/Plant) | SSP0005에는 Capa New Model 팝업이 없다. · 검색어 NewModel, CapaNewModel: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-198f208aaf | M3 | [SCP0006 결함 유형] Capa New Model 팝업 조건(Group/Plant) | SSP0005 에는 Capa New Model 팝업이 없다. · 검색어 CapaNewModel, New Model: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6cd54aa6be | I1 | [SCP0007 결함 유형] Route 검색 팝업 제목 | SSP0005 에는 Route 검색 팝업이 없습니다. · 검색어 Route, RoutePopup, Route Search: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2bd6767820 | H6 | [SCP0007 결함 유형] Route 검색 팝업 제목 | SSP0005 에는 Route 검색 팝업이 없습니다. · 검색어 RoutePopup, ROUTE_ID, Route: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3d2db2b623 | H5 | [SCP0007 결함 유형] Route 검색 팝업 제목 | SSP0005 에는 Route 검색 팝업이 없고, 화면 팝업은 SCM0002_ITEMBYDIVISIONPOPUP 이다. · 검색어 Route, RoutePopup, Route Search: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-60f5d7e1d2 | B4 | [SCP0007 결함 유형] To Site 조회조건 콤보 | SSP0005 의 To Site 조회조건은 AS-IS 소스에서 주석 처리되어 화면에 없다. · 검색어 To Site, TO_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-82bc874099 | D4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SSP0005 그리드에는 To Site 콤보와 City 컬럼이 없다. · 검색어 To Site, TO_SITE, CITY: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2a16c9e988 | B4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SSP0005 에는 Insert 행 To Site 콤보와 City 매핑이 없다. · 검색어 To Site, TO_SITE, City: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-95a6f3b18e | C3 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SSP0005 에는 To Site 콤보와 City 컬럼이 없고 AS-IS InsertButton 도 주석 처리되어 신규 행이 없습니다. · 검색어 TO_SITE, To Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fdf03bd5bd | F1 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SSP0005 에는 To Site 콤보와 City 컬럼이 없다. · 검색어 To Site, TO_SITE, City: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c5562539de | C4 | [DMF0082 결함 일반화] 그리드 Measure 필터(MEASURE Filter) × Division(DIVISION_ID) 변경 재조회 · 건수 표시 | SSP0005 그리드에 Measure 컬럼과 Measure 필터가 없습니다. · 검색어 MEASURE, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5c3707f86a | M4 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME·PROJECT_STATUS·PROJECT_OWNER·BIZ_TYPE) · Model 팝업(ITEM_ID → | SSP0005 에는 Project·Model·Sales Site 팝업과 PROJECT_NAME·ITEM_TYPE·VMI_YN 자동 채움 컬럼이 없다. · 검색어 PROJECT_NAME, PROJECT_OWNER, VMI_STD_DIO, ITEM_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a8c40978ff | M1 | [DMF0014 결함 일반화] 공용 업로드 창(Upload) 검증 완료 후 저장 전 Cancel · X 닫기 확인창 MSG00684 「취소하시겠습니까?」(AS-IS MSG00195) | SSP0005 에는 공용 업로드 창이 없어 Cancel·X 닫기 확인창 대상이 없다. · 검색어 Excel Upload, ExcelUpload, UploadModal: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5671d6ac5e | B5 | [DMF0021 결함 일반화] Measure 설정 팝업(Measure Setting) 후보 · Column 설정 후보 — Division 기준 재조회 | SSP0005에는 Measure Setting 팝업이 없다. · 검색어 Measure Setting, MeasureSetting, MEASURE_SETTING: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-cfd10344ab | K2 | [DMF0021 결함 일반화] Measure 설정 팝업(Measure Setting) 후보 · Column 설정 후보 — Division 기준 재조회 | SSP0005 AS-IS 소스와 TO-BE 화면 폴더 모두에 Measure Setting 팝업과 Column Setting 팝업이 없어 Division 기준 재조회를 확인할 기능이 없다. · 검색어 MeasureSetting, Measure Setting, ColumnSetting, Column Setting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-421e650a8f | G10 | [DMF0072 결함 일반화] 조회조건 Project(PROJECT) · Model/Nickname(MODEL) 입력칸 Enter 키 → Project Popup · Model/Nickname Popup 열기(Div | SSP0005 에는 Project 입력칸과 Model/Nickname 입력칸, 그리고 Enter 키로 여는 팝업이 없습니다. · 검색어 ProjectPopup, PROJECT_ID, Nickname: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-999317a927 | G5 | [DMF0074 결함 일반화] 조회조건 Project(PROJECT) · Model/Nickname(MODEL) 입력칸 Enter 키 → Project Popup · Item Popup 열기 · Model 팝업 사전 | SSP0005에는 Project·Model/Nickname 조회조건과 팝업이 없다. · 검색어 ProjectPopup, ItemPopup, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-76f77508a7 | M1 | [DMF0074 결함 일반화] 공용 Excel Upload 창 2단계 — Upload(검사 · 분류) → OK(저장) · 오류 1건 이상이면 저장 차단 MSG00657 | SSP0005 에는 공용 Excel Upload 창(Upload→OK 2단계)을 여는 기능이 없다. · 검색어 Excel Upload, ExcelUpload, UploadModal: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-51a73020b5 | M4 | [DMF0074 결함 일반화] 조회조건 Model/Nickname(MODEL) 팝업 Close(취소) 시 기존 값 유지 — 선택값이 있을 때만 갱신 | SSP0005 조회조건은 Company·Division·Period·Day Week·Input Value 이고 Model/Nickname 팝업이 없다. · 검색어 Nickname, ModelPopup, ITEM_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2afc3d9e84 | A2 | [결함 유형 묶음 A2-G02 · 2건] Category 코드 컬럼(CATEGORY_ID) 숨김 | SSP0005 그리드에는 CATEGORY_ID·CATEGORY_DESC 컬럼이 없다. · 검색어 CATEGORY_ID, CATEGORY_DESC, Category: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ad8188ca66 | A5 | [결함 유형 묶음 A5-G01 · 2건] Main 그리드 Sub Module 컬럼(SUB_MODULE_CODE) | SSP0005 Main 그리드에는 Sub Module 컬럼(SUB_MODULE_CODE)이 없다. · 검색어 SUB_MODULE_CODE, Sub Module: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-30337e1529 | A5 | [결함 유형 묶음 A5-G02 · 2건] Category 코드 컬럼(CATEGORY_ID) 숨김 | SSP0005 그리드에는 CATEGORY_ID·CATEGORY_DESC 컬럼이 없다. · 검색어 CATEGORY_ID, CATEGORY_DESC: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5ad71c95fa | A5 | [결함 유형 묶음 A5-G03 · 2건] 조회 그리드 컬럼 구성 = 컬럼셋팅 설정 | SSP0005 에는 컬럼셋팅 설정과 COL_LIST 컬럼이 없다. · 검색어 COL_LIST, ColumnSetting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-bff29d1451 | A5 | [결함 유형 묶음 A5-G07 · 2건] Div별 Project 계열 제외 컬럼 비노출 | SSP0005 그리드에는 Project Name·Project Status·Owner·Department 컬럼이 없다. · 검색어 PROJECT_NAME, PROJECT_STATUS, Project Name, Project Status: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-bf6a73d757 | A5 | [결함 유형 묶음 A5-G08 · 2건] Plan Type별 제외 컬럼(Cust Group Dtl 등) | SSP0005 에는 Plan Type 조건과 Cust Group Dtl 컬럼이 없다. · 검색어 CUST_GROUP_DTL, Cust Group Dtl, PLAN_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c13126d771 | A5 | [결함 유형 묶음 A5-G09 · 2건] Div 40 Report 컬럼 표시 | SSP0005 그리드에는 Cell Prod. Site (S&OP Report)·Sold-to Cust(Report) 컬럼이 없다. · 검색어 Cell Prod. Site, Sold-to Cust, S&OP Report: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7dd9cfcd3e | A8 | [결함 유형 묶음 A8-G01 · 2건] 팝업 Spread의 기간 동적 컬럼(YYYYMM) | AS-IS SSP0005 에는 ShowDialog 로 여는 팝업 Spread 가 없고, 기간 동적 컬럼(D_YYYYMMDD)은 메인 그리드에만 있다. · 검색어 ShowDialog, spdPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5504a147e7 | B1 | [결함 유형 묶음 B1-G01 · 3건] 그리드 End Customer 콤보 후보 목록 | SSP0005 그리드에는 End Customer 콤보 컬럼이 없다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ec6521b7de | B2 | [결함 유형 묶음 B2-G01 · 3건] 그리드 End Customer 콤보 후보 목록 | SSP0005 그리드에는 End Customer 콤보 컬럼이 없고, 셀 콤보는 Company(COMPANY_ID)와 일자별 Y/N 컬럼뿐이다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b46790f94c | B4 | [결함 유형 묶음 B4-G01 · 3건] 저장 · Sales Site 조회조건 콤보 | SSP0005에는 Sales Site 저장과 Sales Site 조회조건 콤보가 없다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5d52e62f02 | B5 | [결함 유형 묶음 B5-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | SSP0005에는 신규 행 Measure 콤보가 없다. · 검색어 AS_In_Request, VMI_In_Request, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3335c18df8 | B5 | [결함 유형 묶음 B5-G02 · 2건] FCST Type 콤보 후보 | SSP0005에는 FCST Type 콤보가 없다. · 검색어 FCST Type, FCST_TYPE, SALES_TYPE_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fc97409c3a | C2 | [결함 유형 묶음 C2-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | SSP0005 Insert는 AS-IS 본문이 주석뿐인 NO-OP이고, 그리드에 Measure 콤보도 없다. · 검색어 Measure, MKT_FCST, VMI_In_Request, AS_In_Request: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-27eda5d845 | C2 | [결함 유형 묶음 C2-G06 · 4건] 그리드 상위 셀 변경 시 하위 셀 cascade | SSP0005 그리드에는 End Customer·Sold-to·Sales Company·Sales Plant·Sales Site로 이어지는 상하위 셀이 없다. · 검색어 End Customer, Sold-to, Sales Plant, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3c2fdff682 | C3 | [결함 유형 묶음 C3-G01 · 3건] Team·End Customer(·Energy(WH)) 컬럼 자동 세팅 | SSP0005 그리드에 Team·End Customer·Energy(WH) 컬럼이 없습니다. · 검색어 END_CUSTOMER, End Customer, ENERGE, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a31425f9f0 | C5 | [결함 유형 묶음 C5-G01 · 2건] 사용자 좌/우 그리드 더블클릭 추가/제거 | SSP0005 에는 사용자 좌/우 그리드와 더블클릭 추가/제거 동작이 없습니다. · 검색어 USER_ID, spdUser, Mail: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-68b9c85f93 | D1 | [결함 유형 묶음 D1-G01 · 2건] 신규 행 Team·End Customer 등 자동 매핑 컬럼 | 이 화면에는 Team·End Customer·Energy(WH) 처럼 자동 매핑되는 컬럼이 없다. · 검색어 Team, End Customer, SSPM, Energy: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d368f75eb1 | D2 | [결함 유형 묶음 D2-G01 · 2건] MKT_FCST·SCM_FCST 편집 권한(GET_ADMIN_GROUP_MEASURE) | 이 화면에는 MKT_FCST·SCM_FCST Measure 와 GET_ADMIN_GROUP_MEASURE 편집 권한 룩업이 없다. · 검색어 MKT_FCST, SCM_FCST, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-13de757fec | D2 | [결함 유형 묶음 D2-G02 · 3건] Bucket 유형별 Measure 편집 구간 | 이 화면에는 Bucket 유형별로 편집 구간이 달라지는 MKT_FCST·SCM_FCST·Unit Price(LOC) Measure 가 없다. · 검색어 MKT_FCST, SCM_FCST, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6c6444660d | D3 | [결함 유형 묶음 D3-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | SSP0005 에는 Measure 콤보도 신규 행 입력도 없다. · 검색어 MKT_FCST, VMI_In_Request, AS_In_Request: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9f2097a627 | D4 | [결함 유형 묶음 D4-G01 · 2건] 하단 메시지설정 탭의 Insert(행추가) | SSP0005 는 그리드 하나(spdMain)로 된 화면이고 하단 메시지설정 탭이 없다. · 검색어 메시지설정, MessageSetting, MSG_SET: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-137fdbcee6 | D5 | [결함 유형 묶음 D5-G01 · 2건] 코드성 컬럼의 셀 입력 방식(Menu Type·Auth Unit·System) | SSP0005 에는 Menu Type·Auth Unit·System 컬럼이 없다. · 검색어 Menu Type, Auth Unit, MENU_TYPE, AUTH_UNIT: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-9308de5e77 | E1 | [결함 유형 묶음 E1-G01 · 2건] 정수 전용 수량·일수 입력 컬럼 | SSP0005 에는 MKT FCST 수량이나 Additional Lead Time 같은 정수 전용 컬럼이 없다. · 검색어 MKT_FCST, LEAD_TIME, AddNumberColumn: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-dd779b3cdb | E4 | [결함 유형 묶음 E4-G01 · 2건] Excel Upload Validation 메시지(행·항목별) | SSP0005 는 AS-IS 에 Excel Upload 경로가 없고 TO-BE 도 upload: false 로 업로드 기능이 없다. · 검색어 ExcelUpload, Excel Upload, UploadButton: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5c8ef042cc | E4 | [결함 유형 묶음 E4-G02 · 2건] 판가(Unit Price) 미입력 Validation 오탐 | SSP0005 에는 판가(Unit Price) 컬럼과 판가 미입력 검증이 없다. · 검색어 UNIT_PRICE, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-cf8908e224 | F1 | [결함 유형 묶음 F1-G01 · 3건] 저장 · Sales Site 조회조건 콤보 | SSP0005 조회조건은 Division·Company·Period 이며 Sales Site 조회조건 콤보가 없다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8ddd37f682 | F1 | [결함 유형 묶음 F1-G02 · 2건] 수량·Unit Price(LOC) 입력 행 저장 Validation | SSP0005 그리드에는 수량·Unit Price(LOC) 컬럼과 판가 미입력 Validation이 없다. · 검색어 Unit Price, UNIT_PRICE, PRICE_LOC: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-05c82f5ac7 | F1 | [결함 유형 묶음 F1-G04 · 2건] 사용자 우측 그리드(allReceiver) 추가 후 Save | SSP0005 에는 사용자 우측 그리드(allReceiver)가 없다. · 검색어 allReceiver, Receiver: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-66c3fe6cce | F2 | [결함 유형 묶음 F2-G01 · 3건] 저장 후 Sales Site 조회조건 콤보 갱신 | SSP0005 조회조건에는 Sales Site 콤보가 없다. · 검색어 Sales Site, SALES_SITE, cboSalesSite: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-428ad640f5 | F4 | [결함 유형 묶음 F4-G01 · 2건] SQL View 버튼(VIEW) 클릭 | SSP0005 요소 목록에 SQL View(VIEW) 버튼이 없다. · 검색어 SQL View, SqlView, btnView: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-cae648ee4f | G1 | [결함 유형 묶음 G1-G01 · 3건] 텍스트 조회조건 검색 방식(부분일치·대소문자·복수값) | SSP0005 조회조건(Company, Div., Period)에는 부분일치·콤마 복수값·대소문자 무시를 적용할 텍스트 입력칸이 없습니다. · 검색어 TextEdit, TextField, CustomInput: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-cf1e072db0 | G1 | [결함 유형 묶음 G1-G08 · 2건] Project·Model/Nickname·Owner 조회조건 결과 반영 | SSP0005 조회조건에는 Project, Model/Nickname, Owner 가 없습니다. · 검색어 Project, PROJECT_ID, Nickname: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-dee6575949 | G8 | [결함 유형 묶음 G8-G03 · 2건] Project·Model/Nickname 텍스트 조건 대소문자·콤마 다중값 | SSP0005에는 Project·Model/Nickname·Owner 텍스트 조회조건이 없다. · 검색어 PROJECT_CODE, NICK_NAME, txtProject: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-cd8fb981fb | G9 | [결함 유형 묶음 G9-G01 · 2건] 텍스트 조회조건 Project·Model/Nickname 다중값·대소문자 조회 | SSP0005 조회조건은 Company·Division·Period·Day/Week·Input Value 뿐이고 Project·Model/Nickname·Owner 텍스트 조회조건이 없다. · 검색어 PROJECT_CODE, NICK_NAME, txtProject, Nickname: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-54cc787fd2 | H4 | [결함 유형 묶음 H4-G02 · 2건] Version 팝업(VERSION Modal) 레이아웃 | SSP0005에는 Version 팝업이 없고 TO-BE 팝업은 Bulk Update 팝업(ShipmentWorkingDayBulkModal) 하나뿐이다. · 검색어 Version, VersionPopup, VERSION: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-145aa76cd1 | H4 | [결함 유형 묶음 H4-G03 · 2건] 좌/우 사용자 영역 높이 | SSP0005는 Main Grid(spdMain) 하나로 된 화면이며 좌/우 사용자 영역과 하단 탭이 없다. · 검색어 SplitContainer, SplitPane, ResizablePanel: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-8029847a13 | H5 | [결함 유형 묶음 H5-G01 · 2건] Version·Plan Type 조회조건 라벨 명칭 | SSP0005 조회조건(Div·Plant Site·Period)에는 Version·Waterfall Type 라벨이 없다. · 검색어 Ver., Waterfall Type, Plan Type: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-d3cc93b261 | J3 | [결함 유형 묶음 J3-G01 · 2건] MKT_FCST·SCM_FCST Measure 편집 구간(GET_ADMIN_GROUP_MEASURE) | SSP0005에는 MKT_FCST·SCM_FCST Measure 편집 구간이 없다. · 검색어 GET_ADMIN_GROUP_MEASURE, MKT_FCST, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e5fa426408 | K2 | [결함 유형 묶음 K2-G01 · 2건] 조회 그리드 컬럼 구성 | SSP0005 그리드 컬럼은 컬럼셋팅 설정값이 아니라 3SPAN 캘린더 메타로 그려지고, 이 화면에 COL_LIST 컬럼도 없다. · 검색어 ColumnSetting, Column Setting, COL_LIST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-47c9a47a2b | K2 | [결함 유형 묶음 K2-G04 · 2건] 컬럼셋팅 팝업 필수 컬럼 조작 제한 | SSP0005 에는 컬럼셋팅 팝업이 없어 필수 컬럼을 해제하거나 Invisible 영역으로 옮기는 것을 막는지 확인할 대상이 없다. · 검색어 USER_SELECTED_FLAG, ColumnSetting, Column Setting, Invisible: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4d793e937b | K2 | [결함 유형 묶음 K2-G05 · 2건] Div 전환 시 필수 컬럼 유지 | SSP0005 에는 컬럼 개인화 저장과 Div 별 필수 컬럼(END_CUSTOMER_ID 등) 자동 추가 기능이 없다. · 검색어 USER_SELECTED_FLAG, END_CUSTOMER_ID, ColumnSetting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c8cb5b645b | K2 | [결함 유형 묶음 K2-G07 · 2건] 조회 결과 Measure 표시 순서 | SSP0005 에는 메저셋팅 기능이 없고 조회 결과에 Measure 가 없어 Measure 표시 순서를 확인할 대상이 없다. · 검색어 MeasureSetting, Measure Setting, Measure, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-b6d4522731 | K2 | [결함 유형 묶음 K2-G08 · 1건] 개인화 없을 때 Default 컬럼·Measure | SSP0005 에는 컬럼셋팅 팝업과 Measure 구성이 없어 개인화가 없을 때의 Div Default 컬럼·Measure 구성을 확인할 대상이 없다. · 검색어 ColumnSetting, Column Setting, Measure, USER_SELECTED_FLAG: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f5e980ac46 | M1 | [결함 유형 묶음 M1-G01 · 2건] Excel Form 버튼 클릭 동작 | SSP0005 에는 Excel Form 버튼이 없다. · 검색어 Excel Form, ExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0ac87cc535 | M1 | [결함 유형 묶음 M1-G07 · 2건] Excel Upload 후 OK 저장·DB 반영 | SSP0005 에는 Excel Upload 후 OK 로 저장하는 기능이 없다. · 검색어 Excel Upload, ExcelUpload, UploadModal: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-392245a93a | M1 | [결함 유형 묶음 M1-G09 · 2건] Excel Upload 헤더·컬럼명 불일치 검증 | SSP0005 에는 Excel Upload 기능이 없어 헤더·컬럼명 검증 대상이 없다. · 검색어 Excel Upload, ExcelUpload, Invalid Column Header: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4d5c171720 | M2 | [결함 유형 묶음 M2-G01 · 2건] SQL View 버튼(VIEW) 클릭 결과 | SSP0005의 버튼은 SEARCH·SAVE·INSERT·DELETE·EXCEL·RESET·INPUT뿐이며, SQL View(VIEW) 버튼은 없습니다. · 검색어 SQL View, btnView, btnSqlView: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-242e6bcd88 | M3 | [결함 유형 묶음 M3-G01 · 2건] SQL 버튼 팝업 쿼리 저장 | SSP0005 에는 SQL 버튼과 쿼리 저장 팝업이 없다. · 검색어 SqlPopup, SQL 팝업: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-92fdeebca5 | M3 | [결함 유형 묶음 M3-G03 · 2건] 팝업 텍스트 조회조건 검색 대상 컬럼·Like | SSP0005 에는 텍스트 조회조건이 있는 팝업이 없다. · 검색어 TeamPopup, OwnerPopup, UserPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5787342dfa | N1 | [결함 유형 묶음 N1-G02 · 2건] Div별 컬럼·Measure 구성의 AS-IS 일치 | 이 화면은 Company·Divison 행과 일자 컬럼으로 출하 근무일(WORKDAY_YN)을 입력하는 화면이며 AS-IS 소스에 Measure 컬럼 구성이 없다. · 검색어 Measure, MEASURE, SSPM, Cust FCST: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f74f30d867 | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SSP0005 조회조건은 Division·Company·Period·Day of the week·Input Value 이고 Team(DEPT) 콤보는 AS-IS·TO-BE 화면에 없다. · 검색어 DEPT_ID, Team, SCM_MST_SITE_ITEM: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-90e071553f | H6 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | SSP0005 에는 팝업 그리드가 없어 팝업 No. 컬럼·건수·단축키·Sort 확인 대상이 없습니다. · 검색어 PopupGrid, ContributionSalesVersion, VersionPopup: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-641a149ee7 | C2 | 그리드 End Customer→Sold-to Customer cascade | SSP0005 그리드에는 End Customer·Sold-to Customer 컬럼이 없다. · 검색어 End Customer, Sold-to, SOLD_TO: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-297847cb02 | C2 | 그리드 Sales Company→Sales Plant · Sales Site→Company/Plant | SSP0005 그리드에는 Sales Company→Sales Plant, Sales Site→Company/Plant로 이어지는 셀이 없다. · 검색어 Sales Company, Sales Plant, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-3583df53b7 | M1 | Excel Upload 컬럼명 검증 메시지 · 파일 첨부 개수 | SSP0005 에는 Excel Upload 파일 첨부 기능이 없다. · 검색어 Excel Upload, ExcelUpload, FileUpload: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-da950a46cb | H2 | 실적 구간 배경색 | SSP0005 출하 작업일 그리드에는 편집 불가 실적 구간이 없다. · 검색어 ACTUAL_FLAG, ActualFlag, PLAN_FROM: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-03ff4692cc | B8 | Team 컬럼(MKT FCST 조회·신규행) | SSP0005 그리드에는 Team 컬럼이 없다. · 검색어 Team, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7c370bb148 | N1 | AS From Site 공란 데이터 | 이 화면에는 AS From Site 컬럼이 없다. · 검색어 AS_FROM_SITE, AS From Site: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-c1a55db5fd | G1 | Lookup 텍스트 조회조건 · 화면 깜빡임 · 상단 Grid 스크롤 | SSP0005 조회조건은 Company 콤보, Div. 다중 선택, Period 날짜 범위뿐이고 대소문자 검사를 할 텍스트 조회조건이 없습니다. · 검색어 TextEdit, TextField, CustomInput: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-13c5742ac8 | C3 | Sales Company·Sales Plant 셀 | SSP0005 그리드에 Sales Company·Sales Plant 콤보 셀이 없습니다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Company, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-71ddff0fd2 | M1 | Excel Upload 헤더 검증 메시지 | SSP0005 에는 Excel Upload 기능이 없어 "Invalid Column Header Title" 문구를 띄울 곳이 없다. · 검색어 Excel Upload, ExcelUpload, Invalid Column Header: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-6917014776 | M1 | Excel Upload Validation 메시지(Sales Site/Project/Model) | SSP0005 에는 Excel Upload 기능이 없어 Validation 메시지 대상이 없다. · 검색어 Excel Upload, ExcelUpload, UploadModal: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-07d554d786 | G2 | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | SSP0005 조회조건은 Company 콤보·Div 멀티선택·Period 기간이고 Key-in 텍스트 조회조건은 없다. · 검색어 txtProject, Nickname, OWNER_ID: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-acf03da3b5 | K2 | Column Setting 필수 컬럼 표시·Div 전환 End Customer | SSP0005 에는 컬럼셋팅 팝업과 USER_SELECTED_FLAG 필수 컬럼 정의가 없어 빨간색 필수 컬럼 표시와 다국어 메시지를 확인할 대상이 없다. · 검색어 USER_SELECTED_FLAG, ColumnSetting, Column Setting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-7e102b1629 | M3 | Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SSP0005 AS-IS 소스와 TO-BE 화면 폴더에는 Exchange Rate 팝업이 없고, 업무 팝업은 0건이다. · 검색어 ExchangeRate, Exchange Rate, BPS: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ad17393250 | A5 | Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | SSP0005 에는 컬럼셋팅 팝업이 없어서 OK 를 눌렀을 때 그리드 컬럼을 다시 짜는 확인을 할 대상이 없다. · 검색어 ColumnSetting, columnSetting, 컬럼셋팅, Column Setting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-fd8f841a69 | K2 | 컬럼·메저 셋팅 Save/OK 재조회 | SSP0005 에는 컬럼·메저 셋팅 팝업이 없어 변경 없이 Save/OK 할 때 재조회하지 않는지 확인할 대상이 없다. · 검색어 ColumnSetting, Column Setting, MeasureSetting, Measure Setting: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-f991131d48 | G1 | 텍스트 조회조건 Like 검색(Owner 팝업 User Name/EN) | SSP0005 에는 부분일치(Like) 검색을 할 텍스트 조회조건이 없고, Period 는 날짜 범위 선택입니다. · 검색어 TextEdit, TextField, CustomInput: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ec14e8f4d1 | A5 | 컬럼셋팅 Company ID(필수 표시·Invisible 이동) | SSP0005 에는 필수 컬럼의 Invisible 영역 이동을 막아야 할 컬럼셋팅 팝업이 없다. · 검색어 ColumnSetting, 컬럼셋팅, USER_SELECTED_FLAG: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-a73c357bd7 | G1 | API Name 조회조건 | SSP0005 에는 대/소문자 무시 검색을 할 텍스트 조회조건이 없습니다. · 검색어 TextEdit, TextField, CustomInput: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-2f47a9b07a | K2 | Measure 순서·메저셋팅 순서 저장 | SSP0005 에는 메저셋팅 버튼이 없어 메저셋팅 순서 저장과 Measure 표시 순서를 확인할 대상이 없다. · 검색어 MeasureSetting, Measure Setting, Measure, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-0ba10676e7 | B4 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/Nickname) | SSP0005 에는 End Customer·Sold to·Sales Site·Model/Nickname 조회조건이 없다. · 검색어 End Customer, Sold to, Sales Site, Nickname: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4779cfcf99 | K2 | Measure 순서 | SSP0005 에는 메저셋팅이 없어 저장된 메저셋팅 순서대로 Measure 를 표시하는지 확인할 대상이 없다. · 검색어 MeasureSetting, Measure Setting, Measure, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-4b4a2e7e91 | H2 | 팝업 입력 셀(FPModal · 더블클릭 팝업으로 값이 채워지는 셀, 예 BOD Route Id) | SSP0005 그리드 셀은 Y/N 콤보와 텍스트뿐이고 팝업으로 값을 채우는 셀이 없다. · 검색어 FPModal, AddPopupColumn, PopupColumn: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5080ec33df | C5 | 다중 그리드 더블클릭 연동 | SSP0005 는 spdMain 그리드 하나만 쓰고 더블클릭은 헤더의 주·일 컬럼 펼침에만 쓰므로 다중 그리드 연동이 없습니다. · 검색어 spdDetail, spdSub, siDetail: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-e688512a91 | E7 | 그리드 팝업 셀 Key-in(FPModal 컬럼) 잘못된 값 | SSP0005 그리드 컬럼은 Company(콤보)·Division(텍스트)·날짜 D_ 컬럼(콤보)뿐이고 팝업(FPModal) 셀이 없다. · 검색어 FPModal, AddModalColumn: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-ae1555e54e | M1 | Excel Form 버튼 | SSP0005 에는 Excel Form 버튼이 없다. · 검색어 Excel Form, ExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |
| C-5b979ca2ea | A5 | 그리드 행 선택용 체크 컬럼(AS-IS CHK 컬럼 + 머리글 전체 체크) | AS-IS SSP0005 Designer.cs·.cs 에는 CHK 컬럼과 CheckBox 셀이 없다. · 검색어 CHK, CheckBoxCellType, CheckBox: AS-IS 화면 소스·TO-BE 화면 폴더 14개 파일·요소 목록 0건 |

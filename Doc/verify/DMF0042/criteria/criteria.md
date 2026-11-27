# DMF0042 기준 원장 (2026-11-26 18:27:30)

- 원장 2685행 → 기준 항목 2571개 · 요소 174개 · 상태 확정 2361 · 대상 아님 182 · 판단 대기 28
- 다른 문서 행 755행: 같은 확인으로 합침 114 · 요소 지정 198 · 화면 전체 229 · 대상 아님(검색 0건 확인) 175 · 판단 대기 28
- TO-BE 룰 결합 508건(인용 불일치로 버림 1) · AS-IS 실측 연결 58건(판단 대기 54) · 사용자의견 고정 0건
- AI 호출 48(기억 0 · 실패 0 · 바꾼 것 없는 호출 0) · 비용 출처 Doc/verify/DMF0042/llm_usage.csv

## 판단 대기(사용자 확인)

| 기준 항목 | 요소 | 규칙 | 확인 | 사유 |
|---|---|---|---|---|
| C-bfa63aca55 | SCREEN | K4 | [DMF0020 결함 유형] Price Batch Input 버튼 | DMF0042에는 Set Price(btnSetPrice) 버튼만 있고 Price Batch Input 버튼은 없습니다. · 검색어가 화면에 있음: PriceBatch 1곳 |
| C-596f2cffbc | SCREEN | G5 | [DMF0014 결함 유형] Excel Form 입력 버킷 | DMF0042_BizPlan.cs 에 Excel Form 입력 기능이 없고 Excel 버튼은 내려받기 전용이다. · 검색어가 화면에 있음: FcstUpload 1곳 |
| C-d1534694a7 | SCREEN | E1 | [DMF0082 결함 유형] MKT_FCST[R+P]·AS_In_Request[R+P]·Unit_Price(LOC) | DMF0082의 MKT_FCST·AS_In_Request·Unit_Price(LOC) 컬럼은 DMF0042 Biz Plan 그리드에 없습니다. · 검색어가 화면에 있음: MKT_FCST 7곳 |
| C-d9c3585872 | SCREEN | M3 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | DMF0042 AS-IS 소스에 Price Batch Input 팝업이 없고 Set Price 버튼은 팝업 없이 SP 를 호출합니다. · 검색어가 화면에 있음: PriceBatchInput 1곳, PriceBatch 1곳 |
| C-d27d607691 | SCREEN | H3 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | DMF0042 에는 Price Batch Input 팝업이 없습니다. Set Price 버튼(btnSetPrice_Click)은 조회조건이나 End Customer 컬럼이 있는 팝업을 띄우지 않고 DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV 를 바로 실행합니다. · 검색어가 화면에 있음: PriceBatchInput 1곳 |
| C-410f969f40 | SCREEN | F1 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | DMF0042 는 단일 그리드(siMain)라서 상단 더블클릭으로 하단 그리드 Owner 를 다건 조회·등록하는 구조가 없다. · 검색어가 화면에 있음: DMF0005 1곳 |
| C-2dd89f3c78 | SCREEN | M2 | [DMF0044 결함 유형] BP Version 팝업 Version Create | DMF0042에는 BP Version 팝업의 Version Create가 없고 Ver. Cutoff는 다른 기능이라 확인할 대상이 없습니다. · 검색어가 화면에 있음: VERSION_CREATE 1곳 |
| C-78e8ddfc6c | SCREEN | M3 | [DMF0020 결함 유형] Price Batch Input 팝업 Sales Site 조건 | DMF0042 AS-IS 소스에 Price Batch Input 팝업이 없습니다. · 검색어가 화면에 있음: PriceBatchInput 1곳, PriceBatch 1곳 |
| C-44bea6c699 | SCREEN | F4 | [DMF0014 결함 유형] Excel Upload OK·Customs Handbook/Project/Model 검증 | 이 화면 버튼 목록에는 Excel Upload 버튼과 Customs Handbook 항목이 없다. · 검색어가 화면에 있음: Customs Handbook 1곳 |
| C-26fa04da92 | SCREEN | E3 | [DMF0014 결함 유형] Excel Upload OK·Customs Handbook/Project/Model 검증 | DMF0014의 Excel Upload와 Customs Handbook 검증이 AS-IS DMF0042_BizPlan.cs에 없고, TO-BE BusinessPlan.tsx는 upload: false로 되어 있다. · 검색어가 화면에 있음: Customs Handbook 1곳 |
| C-c039f7eb5c | SCREEN | F1 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Validation 메시지 | DMF0042 에는 Excel Upload 버튼과 Period From/To 컬럼이 없고 Excel 버튼(BTN:EXCEL)만 있다. · 검색어가 화면에 있음: Upload 2곳 |
| C-526ffc298d | SCREEN | F4 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | 이 화면에는 Dynamic Query 기능이 없다. · 검색어가 화면에 있음: KWh 1곳 |
| C-e237ca1778 | SCREEN | F1 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | DMF0042 AS-IS 소스에는 FCST Type=ETC 행과 Text 필수 검사를 처리하는 코드가 없습니다. · 검색어가 화면에 있음: ETC 24곳 |
| C-deccdfc0d3 | SCREEN | B4 | [DMF0082 결함 유형] Customs Handbook 콤보 후보 | DMF0042 에 Customs Handbook 콤보가 없고, AS-IS 소스에서 검색해도 0건이다. · 검색어가 화면에 있음: Customs Handbook 1곳 |
| C-fcd23d2103 | SCREEN | F7 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | DMF0042 AS-IS 소스와 TO-BE business-plan 폴더에서 RTF와 Sales Plan Waterfall을 찾으면 0건이라, 이 화면에는 RTF 저장 판가 검증 기능이 없습니다. · 검색어가 화면에 있음: RTF 2곳 |
| C-c1d9201fd3 | SCREEN | H6 | [DMF0005 결함 유형] Team 팝업 조건(Team ID/Team Name) | DMF0042의 Team 조회조건은 FilterTeambyDivision 콤보이고 Team 팝업은 없습니다. · 검색어가 화면에 있음: Team ID 1곳 |
| C-e312ff8301 | SCREEN | G1 | [SYS0002 결함 유형] Active 조회조건(ALL)·User Group 다중선택 | DMF0042 조회조건에는 Active 콤보와 User Group 다중선택 조건이 없다. · 검색어가 화면에 있음: Active 8곳 |
| C-c123f94d74 | SCREEN | F4 | [SYS0002 결함 유형] Active 조회조건(ALL)·User Group 다중선택 | 이 화면 조회조건 목록에 User Group 다중선택 조건이 없다. · 검색어가 화면에 있음: UserGroup 2곳 |
| C-7277d8d2e2 | SCREEN | H3 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SYS0002 의 User 선택 시 SSO DEPT 자동 세팅과 Use Y/N·Active 헤더 병합은 사용자 관리 기능입니다. DMF0042 의 AS-IS 소스와 TO-BE 화면 폴더에서 해당 식별자가 나오지 않습니다. · 검색어가 화면에 있음: SSO 5곳 |
| C-ff0824ecf8 | SCREEN | F1 | [DMF0020 결함 유형] Unit Price(LOC) → Sales Price 연동 | DMF0042 AS-IS 소스에는 Unit Price(LOC) 값을 Sales Price 테이블로 넘기는 코드가 없습니다. · 검색어가 화면에 있음: Sales Price 1곳 |
| C-9b49e479a1 | SCREEN | A1 | [DMF0082 결함 유형] RTF[R+P] Measure 행 | RTF[R+P] Measure 행은 DMF0082 기능이고 DMF0042 AS-IS 소스와 TO-BE 화면 폴더에서 찾지 못했다. · 검색어가 화면에 있음: RTF 2곳 |
| C-0972a7d7c6 | SCREEN | G2 | [SCP0028 결함 유형] From Site 조회조건 | DMF0042 조회조건에는 From Site 가 없고 Division·Team·End Customer·Sales Site·Plant Site·Biz Type·Period·Bucket·Project·Model·Owner·Item Type 만 있다. · 검색어가 화면에 있음: fromSite 2곳 |
| C-108d687577 | SCREEN | D3 | [SCP0006 결함 유형] Plant Assign 그리드 색상 | DMF0042 사업계획 화면 AS-IS 소스에는 Plant Assign 그리드와 CA1 행이 없다. · 검색어가 화면에 있음: CA1 3곳 |
| C-957548da69 | SCREEN | MS1 | [DMF0014 결함 일반화] 공용 업로드 창(Upload) 검증 완료 후 저장 전 Cancel · X 닫기 확인창 MSG00684 「취소하시겠습니까?」(AS-IS MSG00195) | DMF0042 AS-IS 소스에는 Upload 기능이 없고, TO-BE business-plan 화면은 upload: false로 공용 업로드 창을 쓰지 않으며 MSG00684·MSG00195도 쓰지 않는다. · 검색어가 화면에 있음: MSG00684 1곳, MSG00195 1곳 |
| C-28dad8d8bf | SCREEN | I1 | [DMF0074 결함 일반화] 공용 Excel Upload 창 안내 메시지 MSG00657(오류 행 저장 차단) · MSG00658 · MSG00659 EN · CN 등록값(SCM_ADM_MSG_M) | DMF0042 TO-BE 는 BusinessPlan.tsx 에서 upload: false 이고 AS-IS 소스에도 Excel Upload 창이 없어서, 공용 Excel Upload 메시지 MSG00657·MSG00658·MSG00659 를 쓰지 않습니다. · 검색어가 화면에 있음: MSG00657 1곳, MSG00659 1곳 |
| C-f828184ece | SCREEN | MS1 | [DMF0043_01 결함 일반화] Version 팝업 미선택 OK 안내 — 다국어 코드 MSG00701(AS-IS MSG00279) 「버전은 1개만 선택해 주세요.」/「Please select only one ve | DMF0042 AS-IS 소스와 TO-BE business-plan 폴더에는 MSG00279·MSG00701을 쓰는 Version 팝업 단일 선택 안내가 없다. · 검색어가 화면에 있음: MSG00701 1곳, MSG00279 1곳 |
| C-6e7b61dec9 | SCREEN | A2 | [결함 유형 묶음 A2-G02 · 2건] Category 코드 컬럼(CATEGORY_ID) 숨김 | CATEGORY_ID 컬럼은 DMF0042 AS-IS 소스와 TO-BE 화면 폴더에 없다. · 검색어가 화면에 있음: Category 1곳 |
| C-1ea494e1d8 | SCREEN | E1 | [결함 유형 묶음 E1-G01 · 2건] 정수 전용 수량·일수 입력 컬럼 | MKT FCST[R+P]와 Additional Lead Time 같은 정수 전용 컬럼은 DMF0042에 없고, 동적 기간 컬럼은 소수 2자리입니다. · 검색어가 화면에 있음: MKT_FCST 7곳 |
| 실측 | SP:SQL: SELECT * | - | 실측-파싱 대조 SQL: SELECT * | AS-IS 1회 · TO-BE  · INLINE |
| 실측 | SP:DMF0009_GET_CODE | - | 실측-파싱 대조 DMF0009_GET_CODE | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | SP:DMF0042_1_GET_SPREAD_TITLE | - | 실측-파싱 대조 DMF0042_1_GET_SPREAD_TITLE | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | SP:DMF0042_3_GET_BIZPLAN | - | 실측-파싱 대조 DMF0042_3_GET_BIZPLAN | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | SP:DMF0042_3_GET_SPREAD_TITLE | - | 실측-파싱 대조 DMF0042_3_GET_SPREAD_TITLE | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | SP:DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA | - | 실측-파싱 대조 DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | SP:DMF0042_GET_EXCHANGE_PRICE | - | 실측-파싱 대조 DMF0042_GET_EXCHANGE_PRICE | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | SP:DMF0042_SAVE_DM_PLN_BP_FCST | - | 실측-파싱 대조 DMF0042_SAVE_DM_PLN_BP_FCST | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | SP:DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV | - | 실측-파싱 대조 DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | SP:UP_FX_GETCOMMONDATALIST_DM | - | 실측-파싱 대조 UP_FX_GETCOMMONDATALIST_DM | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | (요소 없음) | - | 실측-파싱 대조 (선언 ↔ 실측) | AS-IS 45개 · TO-BE  · INFO |
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
| 실측 | (요소 없음) | - | 실측-파싱 대조 pictureBox1 | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 pnlBaseForm | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 pnlMain | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 statusStripBaseForm | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 textBox1 | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 textBox2 | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txt | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtTextKeyin | AS-IS 있음 · TO-BE  · LIVE_ONLY |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clbTeam | AS-IS Team · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clbCustomer | AS-IS End Customer · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clbBizType | AS-IS Biz.Type · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clbSalesSite | AS-IS Sales Site · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtProject | AS-IS Project · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnProject | AS-IS layoutControlItem3 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnColumn | AS-IS item0 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnMeasure | AS-IS layoutControlItem4 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clbPlantSite | AS-IS Plant Site · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 chkSum | AS-IS layoutControlItem5 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnItemId | AS-IS layoutControlItem2 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clbDivision | AS-IS Div · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtItemId | AS-IS Model / Nickname · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtOwner | AS-IS Owner · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnOwner | AS-IS layoutControlItem6 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clbItemType | AS-IS Item Type · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 drpPeriod | AS-IS Period · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnSetPrice | AS-IS Set Price · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnExchangeRate | AS-IS Exchange Rate · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnCutOff | AS-IS Ver. Cutoff · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cboBucketType | AS-IS Bucket · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cboClosed | AS-IS Closed · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cboQty | AS-IS . · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnReplace | AS-IS Replace · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 spdMain/Biz Plan | AS-IS 컬럼 19(보임 18) · 헤더 3단 · 행 0 · 고정 7 · TO-BE  · LIVE |

## 대상 아님

| 기준 항목 | 규칙 | 확인 | 근거 |
|---|---|---|---|
| C-0712c83eaa | A1 | DMF0042 화면 | TO-BE 룰 CR-105: 값 불일치와 행·키 집합 차이는 판정에서 뺀다(해당없음으로 두고 근거를 표시한다). · DMF0042 조회 결과의 행수와 키 집합 비교는 차등 검증 판정에서 빠지므로 C-0712c83eaa 는 해당없음이다. |
| C-08edaf5296 | I1 | DMF0042 시나리오 [자동] CN 언어 조회 건수 총/건 표기 | TO-BE 룰 DD-215: AS-IS: CN 언어 총/건 표기 검사 대상 → TO-BE: 검사 대상 제외(NA) · CN 언어 조회 건수 총/건 표기 시나리오는 2026-11-06 사용자 결정으로 검사 대상에서 빠집니다. |
| C-77c727fa98 | K1 | DMF0042 필터 유지 재조회 | TO-BE 룰 DD-217: AS-IS: 화면별 검사 대상 → TO-BE: 검사 대상 제외(NA) · 재조회 때 필터 유지 여부는 공용 DataGrid 공통 기능이므로 DMF0042 필터 유지 재조회 항목은 화면별 검사 대상에서 빠진다. |
| C-1564942b14 | A6 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | TO-BE 룰 CR-075: ③ 예외: 그리드에 바인딩되지 않는 룩업·보조 SP(countryCity 등)와 결과 1행 집계 SP(routeCnt)는 대상 아님(NA 사유 기재) · SCM0001_GET_BIZ_TYPE_BY_DIVISION(Biz.Type 콤보), PR_GET_DAY_RANGE(기간 계산), DMF0042_1_GET_SPREAD_TITLE(컬럼 타이틀)는 그리드 데이터에 바인딩되지 않는 룩업·보조 SP라서 행 |
| C-1d19d3b594 | A6 | PR_GET_DAY_RANGE | TO-BE 룰 CR-075: ③ 예외: 그리드에 바인딩되지 않는 룩업·보조 SP(countryCity 등)와 결과 1행 집계 SP(routeCnt)는 대상 아님(NA 사유 기재) · SCM0001_GET_BIZ_TYPE_BY_DIVISION(Biz.Type 콤보), PR_GET_DAY_RANGE(기간 계산), DMF0042_1_GET_SPREAD_TITLE(컬럼 타이틀)는 그리드 데이터에 바인딩되지 않는 룩업·보조 SP라서 행 |
| C-2bc1044357 | A6 | DMF0042_1_GET_SPREAD_TITLE | TO-BE 룰 CR-075: ③ 예외: 그리드에 바인딩되지 않는 룩업·보조 SP(countryCity 등)와 결과 1행 집계 SP(routeCnt)는 대상 아님(NA 사유 기재) · SCM0001_GET_BIZ_TYPE_BY_DIVISION(Biz.Type 콤보), PR_GET_DAY_RANGE(기간 계산), DMF0042_1_GET_SPREAD_TITLE(컬럼 타이틀)는 그리드 데이터에 바인딩되지 않는 룩업·보조 SP라서 행 |
| C-61582536a2 | E4 | MSG00113 | TO-BE 룰 CR-103: AS-IS 편집 버튼 경로의 안내 메시지는 TO-BE 에 없어도 정상이다(메시지 유무를 오류로 판정하지 않는다). · C-61582536a2는 EditButton 진입점(DMF0042_1·_2·_3·_old의 필수 Column Check)에서만 나오는 MSG00113이고, Save 경로의 MSG00113은 C-0c197e7692로 따로 남습니다. |
| C-0b6c0c5dd8 | J4 | Home / Auth Request 메뉴 | Auth Request 메뉴 화면은 DMF0042 사업계획 화면의 기능이 아니다. · 검색어 Auth Request, AuthRequest, AUTH_REQUEST: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-7a753ff91f | H6 | From City 검색 버튼 | DMF0042 조회조건 목록에 From City 조회조건과 검색 버튼이 없습니다. · 검색어 From City, FROM_CITY, FromCity: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-3fe295b695 | G5 | From City 검색 버튼 | 이 화면에 From City 조회조건과 그 검색 버튼이 없다. · 검색어 From City, FROM_CITY, txtFromCity: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-72a854d001 | A5 | [SYS0002 결함 유형] User 화면 Group 컬럼 | User 화면 Group 컬럼은 SYS0002 기능이고 DMF0042 에 없다. · 검색어 DEFAULT_GROUP, Default Group: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-b42ccede28 | H1 | [DMF0043 결함 유형] Contribution Version Valid_YN 컬럼 | DMF0042 AS-IS 소스에는 Contribution Version 그리드와 Valid_YN 컬럼이 없고, TO-BE 의 VALID_YN 은 Cutoff 편집 구간 판정에 쓰는 데이터 값일 뿐 그리드 컬럼이 아니다. · 검색어 Contribution Version, ContributionVersion, CONTRIBUTION_VERSION: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-03c4cb862e | B5 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_MST_CUSTOMER_FCST(_C/_H).MEASURE | DMF0042 에는 CUST_FCST_MEASURE 룩업과 DM_MST_CUSTOMER_FCST Measure 콤보가 없습니다. · 검색어 CUST_FCST_MEASURE, Cutomer FCST, DM_MST_CUSTOMER_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-353b9f6ea6 | N1 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_MST_CUSTOMER_FCST(_C/_H).MEASURE | DMF0007의 CUST_FCST_MEASURE Measure 콤보는 이 화면 소스에 없고 TO-BE 폴더에서 Cutomer 검색 결과가 0건이다. · 검색어 CUST_FCST_MEASURE, Cutomer FCST, DM_MST_CUSTOMER_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-e863e83d46 | M3 | [DMF0005 결함 유형] Team 팝업 | DMF0042 AS-IS 소스에 Team 팝업 호출이 없습니다. · 검색어 DeptPopup, TeamPopup, SSO_DEPT: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-78b3446112 | G5 | [DMF0005 결함 유형] Team 팝업 | 이 화면의 Team 조회조건은 체크 목록(clbTeam)이고 그리드 Team 컬럼은 콤보라 Team 팝업이 없다. · 검색어 TeamPopup, DeptPopup, SSO_DEPT: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-8bf16b7f5a | F1 | [DMF0005 결함 유형] 하단 Purchase 탭 EDI Incoterms | DMF0042 에는 하단 Purchase 탭과 EDI Incoterms 컬럼이 없습니다. · 검색어 EDI Incoterms, EDI_INCOTERMS, Purchase: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-c98cda6699 | J2 | [DMF0020 결함 유형] Price Batch Input 버튼 | DMF0042 에는 Set Price 버튼만 있고 Price Batch Input 버튼은 없습니다. · 검색어 Price Batch Input, btnPriceBatch, PRICE_BATCH: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-a79425095d | H6 | [DMF0068 결함 유형] Main Version 조회조건 크기 · Version 팝업 Description 컬럼 폭 | DMF0042 조회조건 목록에 Main Version 조회조건과 Version 선택 팝업이 없습니다. · 검색어 Main Version, MAIN_VERSION, VersionPopup: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-2c68af6397 | E4 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Active 컬럼 | DMF0005 마스터의 Cust Group-End Customer-Sales Site 관계와 Active 컬럼 검사이고, DMF0042 그리드에는 Active 컬럼이 없습니다. · 검색어 ACTIVE_YN, Active N, CUST_GROUP_END_CUSTOMER: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-b8ff65a7f2 | M1 | [DMF0014 결함 유형] Excel Form 입력 버킷 | DMF0042에는 Excel Form 양식이 없어 입력 버킷과 Main Period의 연동을 확인할 대상이 없습니다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-8d7d0413de | M1 | [DMF0014 결함 유형] Excel Form 양식 | DMF0042 AS-IS 소스와 TO-BE business-plan 폴더에는 Excel Form 버튼이 없어 데이터 없는 양식 다운로드를 확인할 대상이 없습니다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-65b1407016 | C2 | [DMF0003 결함 유형] AS From Site 입력 후 W35~W38 수량 | DMF0042 그리드에는 AS From Site 컬럼이 없다. · 검색어 AS_FROM_SITE, AS From Site: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-26343dfbe8 | G4 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | DMF0042 에는 Price Batch Input 팝업이 없고, 가격 관련 기능은 팝업 없이 SP 를 부르는 Set Price 버튼뿐이다. · 검색어 Price Batch Input, btnPriceBatch, PriceBatchInputPopup: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-c135ac4d43 | M2 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | DMF0042 AS-IS 소스와 TO-BE Exchange Rate 팝업에는 BPS I/F 버튼이 없어 환율 반영과 Last Update Date/By 컬럼을 확인할 대상이 없습니다. · 검색어 BPS I/F, BPS_IF, 반영할 환율 정보가 없습니다: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-017336e7e5 | F1 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | DMF0042 의 Exchange Rate 팝업에는 BPS I/F 버튼이 없다. · 검색어 BPS, BPS I/F, 반영할 환율 정보가 없습니다: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-505ef0266a | A5 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | BPS I/F 버튼은 DMF0082 기능이고 DMF0042 버튼 목록에 없다. · 검색어 BPS I/F, BPS_IF, 반영할 환율 정보가 없습니다: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-fabc8d5cd9 | K2 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | VMI In Request/Plan/Inv와 MKT FCST AMT Measure는 DMF0082의 Measure이고, DMF0042 AS-IS 소스와 business-plan 폴더에서 검색되지 않는다. · 검색어 VMI In Request, VMI_IN_REQUEST, MKT FCST AMT, MKT_FCST_AMT: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-f496a01d82 | B5 | [DMF0082 결함 유형] SCM_FCST·MKT_FCST 편집 구간(GET_ADMIN_GROUP_MEASURE) | DMF0042 에는 SCM_FCST Measure 가 없고, MKT_FCST 는 SP 가 산출한 값이라 편집 구간 통제를 할 대상이 없습니다. · 검색어 SCM_FCST, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-8d4eb9eb01 | N1 | [DMF0007 결함 유형] Customer FCST Master 기준정보 | DMF0007 Customer FCST Master 기준정보는 이 화면의 조회·저장 프로시저 목록에 없다. · 검색어 DM_MST_CUSTOMER_FCST, Customer FCST Master, CUST_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-21d2c13421 | A1 | [DMF0007 결함 유형] Customer FCST Master 기준정보 | Customer FCST Master 기준정보는 DMF0007 기능이고 DMF0042 화면 요소에 없다. · 검색어 Customer FCST Master, CUST_FCST_MASTER, DMF0007: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-4d59394f13 | C3 | [DMF0005 결함 일반화] Sales Company·Sales Plant 셀 | DMF0042 AS-IS 소스와 TO-BE 화면 폴더에는 Sales Company·Sales Plant 셀이 없다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Company, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-882d56516c | C1 | [DMF0044 결함 유형] 조회조건 Report Type→Data Type | DMF0042 조회조건에는 Report Type·Data Type 콤보가 없습니다. · 검색어 cboReportType, Report Type, cboDataType, Data Type: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-3fbe3ebfac | E4 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | 상단 더블클릭으로 하단 Owner 그리드를 조회하는 구조는 DMF0005 기능이고, DMF0042의 Owner는 조회조건 팝업(btnOwner)뿐입니다. · 검색어 spdSub, spdDetail, grdSub: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-afc29200da | C5 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | DMF0042 에는 하단 Owner 그리드가 없고, Owner 는 조회조건 팝업(BTN:OWNER)으로만 고릅니다. · 검색어 spdSub, spdDetail, spdBottom: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-502034b742 | G1 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | DMF0042 에서 CUST_GROUP 은 그리드 컬럼으로만 있고 Cust Group 조회조건은 없다. · 검색어 clbCustGroup, cboCustGroup: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-d8ae9afba0 | F1 | [DMF0044 결함 유형] BP Version 팝업 Version Create | DMF0042 AS-IS 소스에는 BP Version 팝업의 Version Create 기능이 없습니다. · 검색어 Version Create, VersionCreate: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-1850123ebd | G4 | [DMF0049 결함 유형] Version 조회조건 선택값 표시 | DMF0042 메인 조회조건에는 Version 조회조건이 없다. · 검색어 cboVersion, txtVersion, VersionField: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-3e634bc52d | G7 | [DMF0049 결함 유형] Version 조회조건 선택값 표시 | DMF0042 조회조건에는 Version 콤보가 없어서 Version 선택값 표시를 확인할 대상이 없습니다. · 검색어 cboVersion, cboVer, VersionField: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-65fdbd3828 | M1 | [DMF0014 결함 유형] Excel Upload 수량 미입력 메시지 | DMF0042에는 Excel Upload가 없어 업로드 수량 미입력 문구 "Please Input QTY"를 확인할 대상이 없습니다. · 검색어 Please Input QTY, ExcelUpload, Excel Upload: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-cae5e1dcf6 | M1 | [DMF0014 결함 일반화] Excel Upload Validation 메시지(Sales Site/Project/Model) | DMF0042에는 Excel Upload 검증 단계가 없어 Sales Site·Project·Model 행별 검증 메시지를 확인할 대상이 없습니다. · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-0764b9cb75 | M1 | [DMF0074 결함 유형] Excel Form 양식 헤더 | DMF0042에는 Excel Form 양식 다운로드가 없어 2단 헤더 양식을 확인할 대상이 없습니다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-c4142bad83 | M1 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Validation 메시지 | DMF0042에는 Excel Upload 기능이 없고 TO-BE BusinessPlan.tsx도 upload 버튼을 false로 두어 Key·Period From/To 업로드 대상이 없습니다. · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-b27d7872ad | M1 | [DMF0082 결함 유형] Excel Form 양식 Bucket | DMF0042에는 Excel Form 양식이 없어 Monthly Bucket과 M0~M12 공란 양식을 확인할 대상이 없습니다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-1052e3f365 | D1 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | ETC 입력의 Measure=Sales AMT(LOC) 고정은 DMF0021 기능이며, DMF0042 AS-IS 소스와 TO-BE business-plan 폴더에서 검색하면 0건이다. · 검색어 Sales AMT(LOC), SALES_AMT_LOC, ETC 입력: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-88772ce26e | B4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | DMF0042 에 ETC 입력 기능이 없고, AS-IS 소스에서 Sales AMT(LOC) 를 검색하면 0건이다. · 검색어 SALES_AMT_LOC, Sales AMT(LOC): AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-75b402e7cc | E3 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | DMF0021의 ETC 입력 Team·Measure(Sales AMT(LOC) 고정) 기능을 이 화면 Biz Plan 그리드에서 찾지 못했다. · 검색어 Sales AMT(LOC), SALES_AMT_LOC, ETC 입력: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-1c062a4f81 | D4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | DMF0021 ETC 입력의 SSPM 기준 Team과 Sales AMT(LOC) 고정 Measure는 DMF0042에 없고, DMF0042의 Team(DEPT_ID)은 AS-IS 콤보입니다. · 검색어 SSPM, Sales AMT(LOC): AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-dc200b367a | A1 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | Dynamic Query 는 SYS0013 기능이고 DMF0042 화면 요소에 없다. · 검색어 Dynamic Query, DynamicQuery, SYS0013: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-1dbd0b5c4e | H4 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | DMF0042에는 Dynamic Query 기능이 없다. · 검색어 DynamicQuery, Dynamic Query, ESS KWh: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-31618f4754 | F8 | [SYS0012 결함 유형] Request 데이터 Reject Reason·Request Date | DMF0042 AS-IS 소스와 TO-BE business-plan 폴더에서 Reject Reason과 REQUEST_DATE를 찾으면 0건이라, 이 화면에는 요청·반려 기능이 없습니다. · 검색어 Reject Reason, REJECT_REASON, Request Date, REQUEST_DATE: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-1da58b9408 | B4 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | DMF0042 조회조건에 Approval Result 콤보가 없고, AS-IS 소스에서 검색해도 0건이다. · 검색어 APPROVAL_RESULT, Approval Result, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-0476b199ce | B6 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | DMF0042 조회조건에는 Approval Result 콤보가 없습니다. · 검색어 Approval Result, Requesting, APPROVAL_RESULT, cboApproval: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-25dc112017 | I2 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | Approval Result 조회조건 콤보는 SYS0012 기능이며, DMF0042 조회조건에는 없습니다. · 검색어 APPROVAL_RESULT, Approval Result, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-fb183963b9 | G4 | [DMF0040 결함 유형] Version 조회조건 크기 | DMF0042 메인 조회조건에는 Version 조회조건이 없다. · 검색어 cboVersion, txtVersion, VersionField: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-d8ba638e3c | H5 | [DMF0040 결함 유형] Measure Version(A)/Version(B) 명칭 | DMF0042 에는 버전 두 개를 비교하는 Version(A)/Version(B) Measure 가 없습니다. · 검색어 Version(A), Version(B), VERSION_A: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-3efbb9a08d | A9 | [DMF0040 결함 유형] Measure Version(A)/Version(B) 명칭 | DMF0042 AS-IS 소스(DMF0042_BizPlan·_1·_3)에는 Measure Version(A)/Version(B) 명칭이 없고, 이 항목은 DMF0040 버전 비교 화면의 결함 유형입니다. · 검색어 Version(A), Version(B), VERSION_A, VERSION_B: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-a441fff2ca | G4 | [DMF0044 결함 유형] Year 조회조건 | DMF0042 조회조건에는 Year 가 없고, 기간은 Period 로 입력한다. · 검색어 cboYear, YearField: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-4492a57dff | G6 | [DMF0044 결함 유형] Year 조회조건 | DMF0042 조회조건은 Period 기간 조건을 쓰며, Year 콤보는 AS-IS와 TO-BE 어디에도 없습니다. · 검색어 cboYear, dtpYear, YearField, selectedYear: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-8353f60884 | D2 | [DMF0021 결함 유형] Partial 주차 편집 구간·실적 구분선 | DMF0042 의 Bucket 콤보는 Monthly·Quarterly·Yearly 만 있어 주차 Partial 편집 구간과 실적 구분선 기능이 없다. · 검색어 PARTIAL_WEEK, 실적 구분선: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-99c07fd6df | H2 | [DMF0021 결함 유형] Partial 주차 편집 구간·실적 구분선 | DMF0042는 Yearly/Quarterly/Monthly 버킷만 쓰고 주차 파셜 구간이 없다. · 검색어 PARTIAL_WEEK, PartialWeek: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-add223b05b | G4 | [DMF0040 결함 유형] Ver. 조회조건 기본값 | DMF0042 메인 조회조건에는 Ver. 조회조건이 없다. · 검색어 cboVersion, txtVersion, VersionField: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-d4c9e0ecc0 | G6 | [DMF0040 결함 유형] Ver. 조회조건 기본값 | DMF0042 AS-IS Designer.cs와 TO-BE BusinessPlanForm.tsx 조회조건에는 Ver. 콤보가 없습니다. · 검색어 cboVersion, cboVer, VersionField: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-0f967a2784 | D2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | DMF0042 에는 AS_In_Req·VMI_In_Req Measure 와 AS From Site 콤보가 AS-IS 소스와 TO-BE 화면 폴더 모두에 없다. · 검색어 AS_In_Req, VMI_In_Req, AS From Site: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-e5bd1cea89 | J3 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | DMF0042 에는 AS_In_Req·VMI_In_Req Measure 와 AS From Site 콤보가 없습니다. · 검색어 AS_In_Req, VMI_In_Req, AS_FROM_SITE, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-8f2773456f | D3 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | DMF0042 화면에는 AS From Site 콤보, AS_In_Req·VMI_In_Req Measure, GET_ADMIN_GROUP_MEASURE 통제가 없다. · 검색어 GET_ADMIN_GROUP_MEASURE, AS_In_Req, VMI_In_Req, AS From Site: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-a64a0f6a2c | B5 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | DMF0042 에는 AS_In_Req·VMI_In_Req 입력 Measure 와 AS From Site 콤보가 없고, MKT_FCST 는 SP 가 산출한 값이라 잠겨 있습니다. · 검색어 AS_In_Req, VMI_In_Req, AS From Site, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-89aa267163 | B4 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | DMF0042 에는 AS_In_Req·VMI_In_Req 입력 Measure 와 AS From Site 콤보가 없고, MKT_FCST 는 SP 가 산출한 값이라 잠겨 있습니다. · 검색어 AS_In_Req, VMI_In_Req, AS From Site, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-58d0815d05 | C2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | DMF0042 Measure 행은 입력 Measure 콤보가 아닌 고정 행이고 AS-IS DMF0042 소스에는 AS_In_Req·VMI_In_Req·AS From Site 가 없다. · 검색어 AS_In_Req, VMI_In_Req, AS From Site, AS_FROM_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-76db66441b | D2 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | DMF0042 에는 RTF[R+P] Measure 편집 조건과 GET_ADMIN_GROUP_MEASURE 룩업이 없고, BTN:CUTOFF 는 버전 Cutoff 저장 버튼이다. · 검색어 RTF[R+P], GET_ADMIN_GROUP_MEASURE, Cutoff 미완료: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-febc08a81c | J3 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | DMF0042 에는 RTF[R+P] Measure 편집 기능이 없습니다. · 검색어 RTF[R+P], RTF_RP, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-7cc4e456ab | E4 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | RTF[R+P] Measure 편집 조건과 GET_ADMIN_GROUP_MEASURE 기준은 DMF0021 기능이고, DMF0042 Measure에는 없습니다. · 검색어 GET_ADMIN_GROUP_MEASURE, RTF[R+P], RTF_RP: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-7b387bb012 | E4 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | FCST Type=ETC일 때 Text를 필수로 받는 검사는 DMF0021 기능이고, DMF0042 FCST Type 컬럼에는 ETC Text 입력 분기가 없습니다. · 검색어 "ETC", ETC_TEXT, FCST_TYPE_ETC: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-f2dd7b7c48 | F6 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | DMF0042 에는 FCST Type=ETC 행의 Text 필수 검증과 ETC 테이블 저장이 없다. · 검색어 ETC_TEXT, DM_PLN_ETC, Text 필수: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-73e60a56f2 | D5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | DMF0021의 SALES_PLAN_ITEM_ID Model 후보와 SSPM 기준 Team 팝업은 DMF0042 AS-IS 소스에서 검색되지 않습니다. · 검색어 SALES_PLAN_ITEM_ID, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-57ae04ce7d | D3 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | DMF0042 화면에는 AS From Site 컬럼이 없고, AS-IS 소스에서도 이 컬럼의 활성 여부나 콤보 동작을 찾을 수 없다. · 검색어 AS From Site, AS_FROM_SITE, ASFromSite: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-5aebe7706c | C2 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | DMF0042 그리드에는 AS From Site 컬럼과 Sales Site 유형별 Measure 후보 콤보가 없다. · 검색어 AS_FROM_SITE, AS From Site, AS_In_Req: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-5861b04fe5 | B4 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | DMF0042 AS-IS 소스와 TO-BE business-plan 폴더에서 AS From Site 를 검색하면 0건이고, Measure 컬럼 후보는 DMF0042_BP_Measure 원천이며 Sales Site 유형별 분기가 없다. · 검색어 AS_FROM_SITE, AS From Site, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-9c23b5cdf3 | B5 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | DMF0042 에는 AS From Site 컬럼과 Sales Site 유형별 Measure 후보 콤보가 없습니다. · 검색어 AS From Site, FROM_SITE, AS_FROM_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-0255895264 | J3 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | DMF0042 에는 AS From Site 콤보가 없습니다. · 검색어 AS_FROM_SITE, AS From Site, asFromSite: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-57649d548a | M3 | [DMF0082 결함 유형] Excel Form 팝업 Search | DMF0042 AS-IS 소스에 Excel Form 팝업이 없고 BTN:EXCEL 은 엑셀 다운로드 버튼입니다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-265876348a | M1 | [DMF0082 결함 유형] Excel Form 팝업 Search | DMF0042에는 Excel Form 팝업이 없어 팝업 Search 조회를 확인할 대상이 없습니다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-aa6b2fe165 | B4 | [DMF0035 결함 유형] Version 조회조건 | DMF0042 조회조건 목록에 Version 이 없고, AS-IS 소스에서 cboVersion·clbVersion 을 검색하면 0건이다. · 검색어 cboVersion, clbVersion, lblVersion: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-e08eabd4d7 | M3 | [DMF0035 결함 유형] Version 조회조건 | DMF0042 조회조건 목록에 Version 조회조건이 없습니다. · 검색어 cboVersion, lblVersion, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-c5843d3b41 | E4 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | RTF 저장 후 Sales Plan Waterfall에 반영하는 동기화는 DMF0021 기능이고, DMF0042 Save 경로에는 없습니다. · 검색어 Waterfall, Sales Plan Waterfall, SALES_PLAN_WATERFALL: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-1c07107a67 | F1 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | DMF0042 에는 RTF 저장 시 판가 검증과 Sales Plan Waterfall 동기화 기능이 없습니다. · 검색어 Sales Plan Waterfall, SALES_PLAN_WATERFALL: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-6ee4329fa0 | G4 | [DMF0035 결함 유형] Plan Type 조회조건 위치 | DMF0042 조회조건에는 Plan Type 이 없다. · 검색어 cboPlanType, PlanTypeField, Plan Type: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-423ff20530 | B4 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | DMF0042 그리드에 Sales Plant 셀 콤보가 없고, AS-IS 소스에서 검색해도 0건이다. · 검색어 SALES_PLANT, Sales Plant, SCM_MST_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-d93bb24b2e | N1 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | DMF0005의 Sales Plant 셀 콤보는 이 화면 그리드 컬럼 목록에 없다. · 검색어 SALES_PLANT, Sales Plant, SCM_MST_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-10f98753a0 | G2 | [SYS0002 결함 유형] Active 조회조건(ALL)·User Group 다중선택 | DMF0042 조회조건에는 Active 와 User Group 이 없다. · 검색어 User Group, USER_GROUP, chkActive, ACTIVE_YN: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-9a3e995c22 | K2 | [DMF0035 결함 유형] Measure 명칭 MKT FCST[R+P] | Measure 명칭 MKT FCST[R+P]는 DMF0035의 Measure이고, DMF0042 AS-IS 소스와 business-plan 폴더에서 MKT FCST가 검색되지 않는다. · 검색어 MKT FCST[R+P], MKT_FCST_RP, MKT FCST: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-db38725816 | H5 | [DMF0035 결함 유형] Measure 명칭 MKT FCST[R+P] | DMF0042 AS-IS 소스와 TO-BE business-plan 폴더에 Measure 명칭 MKT FCST[R+P] 가 없습니다. · 검색어 MKT FCST, FCST[R+P], R+P: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-91c1f10d23 | H8 | [SYS0012 결함 유형] Request Date 컬럼 | DMF0042 요소 목록과 AS-IS 소스·TO-BE business-plan 폴더에 Request Date 컬럼이 없다. · 검색어 REQUEST_DATE, Request Date, REQ_DATE, requestDate: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-34ed7a2563 | D1 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | Dept 컬럼의 SSO 자동 세팅과 Use Y/N 헤더 병합은 SYS0002 기능이며, DMF0042 AS-IS 소스와 TO-BE business-plan 폴더에서 USE_YN·Use Y/N 을 검색하면 0건이다. · 검색어 USE_YN, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-6be35454dc | C3 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | DMF0042 AS-IS 소스와 TO-BE 화면 폴더에는 SSO DEPT 자동 세팅과 Use Y/N·Active 헤더가 없다. · 검색어 SSO_DEPT, Use Y/N, SSO DEPT: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-9fdc29b9fd | H5 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | DMF0042 에는 User 선택 시 Dept 를 자동으로 넣는 사용자 관리 그리드와 Use Y/N 헤더가 없습니다. · 검색어 SSO_DEPT, Use Y/N, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-e25e9e8d94 | F1 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | DMF0042 에는 Use Y/N·Active 헤더와 User 선택 시 SSO DEPT 를 자동으로 넣는 기능이 없습니다. · 검색어 Use Y/N, USE_YN: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-49a7543d55 | F6 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | DMF0042 에는 User 선택 시 SSO DEPT 자동 세팅과 Use Y/N·Active 헤더가 없다. · 검색어 USE_YN, Use Y/N, SSO_DEPT: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-10f357fac5 | A5 | [SYS0014 결함 유형] Email 컬럼 | Email 컬럼은 SYS0014 컬럼이고 DMF0042 그리드에 없다. · 검색어 EMAIL, Email: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-4ce3f867cd | M3 | [SYS0014 결함 유형] User 팝업(User Info) | DMF0042 에는 Group User·User Info 팝업이 없고 사용자 선택은 Owner 팝업으로 합니다. · 검색어 GroupUserPopup, UserInfoPopup, User Info: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-fdd04ef95a | F1 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | DMF0042 에는 JV Planner 용 Division 시트가 없습니다. · 검색어 JV Planner, JV_PLANNER: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-afe57700f9 | F6 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | DMF0042 에는 JV Planner 용 Division 시트 저장 기능이 없다. · 검색어 JV Planner, JV_PLANNER, Division 시트: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-30910c69a5 | B4 | [SYS0010 결함 유형] System 컬럼 입력 방식 | DMF0042 그리드에는 System 컬럼이 없습니다. · 검색어 SYSTEM_ID, SYSTEM_CODE, SYSTEM Lookup: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-58602079fc | A5 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | URL-ROUTE_PATH 입력 컬럼은 SYS0003 기능이고 DMF0042 에 없다. · 검색어 ROUTE_PATH, Route Path: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-b76a7e5175 | D1 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | URL-ROUTE_PATH 컬럼은 SYS0003 화면 기능이며, DMF0042 AS-IS 소스와 TO-BE business-plan 폴더에서 ROUTE_PATH 를 검색하면 0건이다. · 검색어 ROUTE_PATH, Route Path: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-c6f347bf8d | F1 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | DMF0042 에는 URL ROUTE_PATH 컬럼이 없습니다. · 검색어 ROUTE_PATH, Route Path: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-f358060ea8 | B6 | [SYS0005 결함 유형] Schema 조회조건 | DMF0042 조회조건에는 Schema 항목이 없습니다. · 검색어 Schema, cboSchema, SCHEMA_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-4ce7639711 | G2 | [SYS0005 결함 유형] Schema 조회조건 | DMF0042 조회조건에는 Schema 가 없다. · 검색어 cboSchema, SCHEMA_NAME, Schema: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-c59dca48d1 | G1 | [SYS0005 결함 유형] Schema 조회조건 | DMF0042 조회조건에는 Schema 조건이 없다. · 검색어 cboSchema, Schema, SCHEMA_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-6499175a55 | B6 | [SYS0006 결함 유형] API Type 조회조건 | DMF0042 조회조건에는 API Type 항목이 없습니다. · 검색어 API Type, cboApiType, API_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-2138d71c3b | B4 | [SYS0006 결함 유형] API Type 조회조건 | DMF0042 에는 API Type 조회조건이 없습니다. · 검색어 API_TYPE, API Type, apiType: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-90d8421355 | B1 | [SYS0006 결함 유형] API Type 조회조건 | DMF0042 조회조건 콤보에는 API Type이 없고, 이 항목은 SYS0006 화면의 결함 유형입니다. · 검색어 API_TYPE, API Type, ApiType: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-bd3602f071 | B4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | DMF0042 에 Module·Sub Module·Notice Content 요소가 없고, AS-IS 소스에서 검색해도 0건이다. · 검색어 Sub Module, Notice Content, SUB_MODULE: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-95381984e7 | B6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | DMF0042 에는 Module·Sub Module 조회조건과 Notice Content·Active 입력이 없습니다. · 검색어 Sub Module, Notice Content, cboModule, NOTICE_CONTENT: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-b6c8a5d0ff | G4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | DMF0042 에는 Module·Sub Module 조회조건과 Notice 입력 기능이 없다. · 검색어 cboModule, SubModule, ModuleField, Sub Module: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-927fd136be | H5 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | DMF0042 에는 Module·Sub Module 조회조건과 Notice Content 입력 기능이 없습니다. · 검색어 Sub Module, SUB_MODULE, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-83ce6910d8 | D4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SYS0016의 Module/Sub Module 조회조건과 Notice Content는 DMF0042 Biz Plan 화면에 없습니다. · 검색어 Sub Module, Notice Content, SYS0016: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-a7fb030f2b | H6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | DMF0042에는 Module·Sub Module 조회조건과 Notice Content 기능이 없습니다. · 검색어 Sub Module, SUB_MODULE, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-e2ba64a48f | K5 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | DMF0042에는 SYS0016의 Module·Sub Module 조회조건과 Notice Content 입력이 없습니다. · 검색어 Sub Module, SubModule, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-e579c06ce5 | B6 | [SYS0017 결함 유형] Module / Sub Module 조회조건 | DMF0042 조회조건에는 Module·Sub Module 항목이 없습니다. · 검색어 Sub Module, SubModule, cboModule, SUB_MODULE: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-89d611685c | G4 | [SYS0017 결함 유형] Module / Sub Module 조회조건 | DMF0042 에는 Module·Sub Module 조회조건이 없다. · 검색어 cboModule, SubModule, ModuleField, Sub Module: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-ba9741bd93 | B4 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | DMF0042 에 Sales Company·Sales Plant 그리드 콤보가 없고, AS-IS 소스에서 검색해도 0건이다. · 검색어 SALES_COMPANY, Sales Company, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-013572439f | C2 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | DMF0042 그리드에는 Sales Company·Sales Plant 컬럼이 없다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Company, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-fcfc695273 | F2 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | DMF0042 에는 Sales Company/Sales Plant 콤보 컬럼이 없다. · 검색어 Sales Company, SALES_COMPANY, Sales Plant, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-8d8534949b | F1 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | DMF0042 에는 Sales Company/Sales Plant 콤보 컬럼이 없다. · 검색어 Sales Company, SALES_COMPANY, Sales Plant, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-3ddcf391e4 | B3 | [SYS0010 결함 유형] 메인화면 System admin 정보(SYSTEM_ADM Lookup) | 메인화면 System admin 정보(SYSTEM_ADM Lookup)는 SYS0010 기능이고 DMF0042 AS-IS 소스에서 SYSTEM_ADM 검색 결과는 0건입니다. · 검색어 SYSTEM_ADM, System admin, SYS0010: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-fb7b7fb508 | E4 | [DMF0004 결함 유형] Customer 탭 Sold to/Ship to 저장 검증 | NERP_CONV_MASTER 기준 Sold to/Ship to 구코드 저장 차단은 DMF0004 Customer 탭 기능이고, DMF0042에는 없습니다. · 검색어 NERP_CONV_MASTER, NERP_CONV: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-b3dc727e3f | A5 | [DMF0008 결함 유형] 하단 그리드 CRUD Status 컬럼 | DMF0042 Biz Plan에는 하단 그리드와 CRUD Status 컬럼이 없고, 메인 그리드는 CRUD_TYPE을 내부 값으로만 쓴다. · 검색어 CRUD Status, CRUD_STATUS, ROW_STATUS: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-e40b2036f7 | B5 | [SYS0012 결함 유형] 권한 신청 가능 Group 목록 | DMF0042 에는 권한 신청 Group 목록 기능이 없습니다. · 검색어 REQ_NO_DISPLAY, 권한 신청: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-cd24c312f0 | F8 | [SYS0011 결함 유형] Approval Date 컬럼 | DMF0042 AS-IS 소스와 TO-BE business-plan 폴더에서 Approval Date 컬럼을 찾으면 0건이라, 이 화면에는 승인 기능이 없습니다. · 검색어 Approval Date, APPROVAL_DATE, APPROV: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-5d9792bcda | F1 | [SYS0011 결함 유형] Approval Date 컬럼 | DMF0042 에는 Approval Date 컬럼과 Request 기능이 없다. · 검색어 APPROVAL_DATE, Approval Date: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-30c7e93a44 | C5 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | DMF0042 에는 Mail Setup 탭과 사용자 좌/우 그리드가 없고, 그리드는 spdMain 하나뿐입니다. · 검색어 MailSetup, Mail Setup, spdLeft, spdRight: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-2b513c6c09 | F1 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | DMF0042 에는 Mail Setup 탭과 사용자 좌/우 그리드가 없다. · 검색어 Mail Setup, MAIL_SETUP, MailSetup: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-c0cedbb0db | F5 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | DMF0042 에는 Mail Setup 탭과 사용자 좌/우 그리드가 없다. · 검색어 MailSetup, Mail Setup, MAIL_SETUP: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-86b75f3bc3 | H4 | [DMF0035 결함 유형] Version 조회조건 돋보기 버튼 | DMF0042 조회조건에는 Version 조회조건과 돋보기 버튼이 없다. · 검색어 txtVersion, btnVersion, VersionPopup: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-a504f76202 | C1 | [DMF0035 결함 유형] Version 조회조건 기본값 | DMF0042 조회조건에 Version 콤보가 없고 Version 은 그리드 컬럼 VERSION_NO 로만 있습니다. · 검색어 cboVersion, lblVersion, clbVersion: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-de51bc4b11 | F7 | [DMF0021 결함 유형] RTF[R+P] → DM_PLN_MKT_FCST / DM_PLN_MKT_FCST_C 연동 | DMF0042에서 MKT_FCST는 Measure로만 쓰이고, RTF[R+P]를 DM_PLN_MKT_FCST_C·Cutoff 버전 테이블로 넘기는 기능은 없습니다. · 검색어 RTF[R+P], DM_PLN_MKT_FCST_C, Demand Plan Waterfall: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-b23e02dfe4 | F1 | [DMF0021 결함 유형] RTF[R+P] → DM_PLN_MKT_FCST / DM_PLN_MKT_FCST_C 연동 | DMF0042 에는 RTF[R+P] 값을 DM_PLN_MKT_FCST_C 로 넘기는 기능이 없습니다. · 검색어 DM_PLN_MKT_FCST_C, Demand Plan Waterfall, FCST&PRICE MGMT: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-22225d5b50 | G1 | [SCP0028 결함 유형] From Site 조회조건 | DMF0042 조회조건에는 From Site 조건이 없다. · 검색어 clbFromSite, FROM_SITE, From Site: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-970986f39b | I2 | [SCP0028 결함 유형] Lot Size<Increment 검증 메시지 | Lot Size·Increment 검증 메시지는 SCP0028 기능이며, DMF0042 에는 그 항목이 없습니다. · 검색어 LotSize, LOT_SIZE, Increment, Lot Size: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-b2b53e4e2a | I1 | [SCP0028 결함 유형] Lot Size<Increment 검증 메시지 | Lot Size·Increment 검증은 SCP0028 기능이며, DMF0042 AS-IS 소스에는 Lot Size·Increment 항목이 없습니다. · 검색어 LotSize, LOT_SIZE, Increment, Lot Size: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-8de1fa81df | E4 | [SCP0028 결함 유형] Lot Size<Increment 검증 메시지 | Lot Size와 Increment를 비교하는 검사는 SCP0028 기능이고, DMF0042에는 Lot Size 컬럼이 없습니다. · 검색어 LOT_SIZE, Lot Size, INCREMENT: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-da4e955062 | A1 | [SCP0006 결함 유형] BOM Explosion Plant Assign(MCCH125020A1/MACH125020A1) | BOM Explosion Plant Assign 은 SCP0006 기능이고 DMF0042 AS-IS 소스와 TO-BE 화면 폴더에서 찾지 못했다. · 검색어 Plant Assign, BOM Explosion, PLANT_ASSIGN: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-45a49129aa | N1 | [SCP0006 결함 유형] BOM Explosion Plant Assign(MCCH125020A1/MACH125020A1) | SCP0006의 BOM Explosion Plant Assign 기능은 사업계획 화면 소스와 TO-BE 폴더에서 BOM 검색 결과가 0건이다. · 검색어 BOM_EXPLOSION, BOM Explosion, PLANT_ASSIGN, Plant Assign: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-66ed4af9e1 | H2 | [SCP0006 결함 유형] Plant Assign 그리드 색상 | DMF0042에는 Plant Assign 그리드와 CA1 행 구분이 없고 Plant Site 컬럼(PLANT_SITE_ID)만 있다. · 검색어 Plant Assign, PlantAssign, PLANT_ASSIGN: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-38e09464a1 | G5 | [SCP0006 결함 유형] Capa New Model 팝업 조건(Group/Plant) | 이 화면에 Capa New Model 팝업이 없다. · 검색어 NewModelPopup, Capa New Model, CapaNewModel: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-943d1b5729 | M3 | [SCP0006 결함 유형] Capa New Model 팝업 조건(Group/Plant) | DMF0042 AS-IS 소스에는 Capa New Model 팝업과 Capa·NewModel 식별자가 없습니다. · 검색어 Capa New Model, CapaNewModel, NewModelPopup, Plant Group: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-be4b94667d | I1 | [SCP0007 결함 유형] Route 검색 팝업 제목 | DMF0042 의 Route 는 Biz Plan 그리드 컬럼이며, Route 검색 팝업은 이 화면에 없습니다. · 검색어 RoutePopup, Route Search, SearchRoute: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-6f0d1ccd36 | H6 | [SCP0007 결함 유형] Route 검색 팝업 제목 | DMF0042에는 Route 컬럼만 있고 Route 검색 팝업은 없습니다. · 검색어 RoutePopup, Route Search, ROUTE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-c078d3c0cd | H5 | [SCP0007 결함 유형] Route 검색 팝업 제목 | DMF0042 에는 Route 컬럼만 있고 Route 검색 팝업은 없습니다. · 검색어 RoutePopup, ROUTE_POPUP, SearchRoute: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-4da27868c5 | B4 | [SCP0007 결함 유형] To Site 조회조건 콤보 | DMF0042 에 To Site 조회조건이 없고, AS-IS 소스에서 검색해도 0건이다. · 검색어 TO_SITE, To Site, cboToSite: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-2d12dfc5b0 | D4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SCP0007의 To Site 콤보와 City 매핑은 DMF0042 AS-IS 소스에서 검색되지 않습니다. · 검색어 TO_SITE, To Site, ToSite: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-591ebbdd49 | B4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | DMF0042 Insert 행에 To Site 콤보가 없고, AS-IS 소스에서 검색해도 0건이다. · 검색어 TO_SITE, To Site, TO_SITE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-770e3b3524 | C3 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | DMF0042 AS-IS 소스와 TO-BE 화면 폴더에는 To Site 콤보 컬럼이 없다. · 검색어 TO_SITE, To Site, TO_SITE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-cfc84ef7ff | F1 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | DMF0042 그리드에는 To Site 콤보 컬럼이 없다. · 검색어 TO_SITE_ID, To Site, TO_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-85fc02afeb | M1 | [DMF0014 결함 일반화] 공용 업로드 창(Upload) 검증 완료 후 저장 전 Cancel · X 닫기 확인창 MSG00684 「취소하시겠습니까?」(AS-IS MSG00195) | DMF0042에는 공용 업로드 창이 없어 Cancel·X 닫기 때의 MSG00684 확인창을 확인할 대상이 없습니다. · 검색어 ExcelUpload, Excel Upload, UploadPopup: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-7040b482d2 | A5 | [결함 유형 묶음 A5-G01 · 2건] Main 그리드 Sub Module 컬럼(SUB_MODULE_CODE) | Sub Module 컬럼(SUB_MODULE_CODE)은 DMF0042 요소 목록과 소스에 없다. · 검색어 SUB_MODULE_CODE, Sub Module: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-a6e2c5c149 | A5 | [결함 유형 묶음 A5-G02 · 2건] Category 코드 컬럼(CATEGORY_ID) 숨김 | Category 코드 컬럼(CATEGORY_ID)은 DMF0042 요소 목록과 소스에 없다. · 검색어 CATEGORY_ID, CATEGORY_DESC: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-281a0a3f04 | A5 | [결함 유형 묶음 A5-G08 · 2건] Plan Type별 제외 컬럼(Cust Group Dtl 등) | Plan Type 구분은 DMF0042 조회조건과 소스에 없다. · 검색어 PLAN_TYPE, Plan Type: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-b83fd4aa25 | B4 | [결함 유형 묶음 B4-G01 · 3건] 저장 · Sales Site 조회조건 콤보 | DMF0042 저장은 사업계획 FCST 저장이고, 신규 Sales Site 마스터를 등록하는 기능은 없습니다. · 검색어 SAVE_SCM_MST_SITE, SCM_MST_SITE 저장: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-2450a2e835 | B5 | [결함 유형 묶음 B5-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | DMF0042 의 Insert 는 고정된 Measure 행을 잠긴 상태로 만들 뿐이고, AS_In_Request·VMI_In_Request 를 고르는 Measure 콤보가 없습니다. · 검색어 AS_In_Request, VMI_In_Request: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-7072a12cc4 | C2 | [결함 유형 묶음 C2-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | DMF0042 는 Insert 시 dtMeasure 행을 Measure 칸에 고정·잠금으로 넣고 VMI_In_Request·AS_In_Request Measure 후보가 없다. · 검색어 VMI_In_Request, AS_In_Request, VMI_In_Req, AS_In_Req: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-1e5eef13a3 | C5 | [결함 유형 묶음 C5-G01 · 2건] 사용자 좌/우 그리드 더블클릭 추가/제거 | DMF0042 에는 사용자 좌/우 그리드 사이를 더블클릭으로 추가·제거하는 기능이 없습니다. · 검색어 spdLeft, spdRight, MailSetup: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-17da498127 | D2 | [결함 유형 묶음 D2-G01 · 2건] MKT_FCST·SCM_FCST 편집 권한(GET_ADMIN_GROUP_MEASURE) | DMF0042 의 EditButton 은 MEASURE 가 Business_Plan·LOC 인 행만 편집을 열고 MKT_FCST 는 SP 에서 계산하는 값이며, GET_ADMIN_GROUP_MEASURE 권한 룩업과 SCM_FCST Measure 는 AS-IS 소스와 TO-BE 화면 폴더에 없다. · 검색어 GET_ADMIN_GROUP_MEASURE, SCM_FCST, MKT_FCST[R+P]: AS-IS 화면 소스·TO-BE |
| C-b41e2e9e0c | D2 | [결함 유형 묶음 D2-G02 · 3건] Bucket 유형별 Measure 편집 구간 | DMF0042 의 Bucket 은 Monthly·Quarterly·Yearly 뿐이고 SCM_FCST 편집 Measure 가 없어 Daily·Weekly 기준 Measure 편집 구간 규칙이 없다. · 검색어 SCM_FCST, BucketType.Daily, BucketType.Weekly: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-a46dcbb431 | D3 | [결함 유형 묶음 D3-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | DMF0042 Insert 버튼은 DMF0042_BP_Measure 콤보의 Measure 를 한 묶음으로 모두 넣고, VMI_In_Request·AS_In_Request Measure 는 AS-IS 소스에 나오지 않는다. · 검색어 VMI_In_Request, AS_In_Request, VMI_In_Req, AS_In_Req: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-30f5d43a9a | D4 | [결함 유형 묶음 D4-G01 · 2건] 하단 메시지설정 탭의 Insert(행추가) | DMF0042 AS-IS 소스에는 하단 메시지설정 탭이 없고, 이 화면의 Insert는 Biz Plan 그리드에만 있습니다. · 검색어 메시지설정, MessageSetting, MSG_SETTING: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-25668b445a | D5 | [결함 유형 묶음 D5-G01 · 2건] 코드성 컬럼의 셀 입력 방식(Menu Type·Auth Unit·System) | Menu Type·Auth Unit·System 코드 컬럼은 DMF0042 Biz Plan 그리드에 없습니다. · 검색어 Menu Type, Auth Unit, MENU_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-4fb886b6a0 | E4 | [결함 유형 묶음 E4-G01 · 2건] Excel Upload Validation 메시지(행·항목별) | AS-IS DMF0042에는 Excel Upload 처리가 없고 TO-BE BusinessPlan은 upload: false로 업로드 버튼을 끄고 있습니다. · 검색어 ExcelUpload, btnUpload, UploadButton: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-06563373a0 | F1 | [결함 유형 묶음 F1-G04 · 2건] 사용자 우측 그리드(allReceiver) 추가 후 Save | DMF0042 에는 사용자를 추가하는 우측 그리드(allReceiver)가 없습니다. · 검색어 allReceiver, Receiver: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-c55cc45070 | F4 | [결함 유형 묶음 F4-G01 · 2건] SQL View 버튼(VIEW) 클릭 | 이 화면 버튼 목록과 AS-IS 소스에 SQL View 버튼이 없다. · 검색어 SqlView, SQL View: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-12410f9c00 | H4 | [결함 유형 묶음 H4-G02 · 2건] Version 팝업(VERSION Modal) 레이아웃 | DMF0042에는 Version 선택 팝업(VERSION Modal)이 없고 Ver. Cutoff 팝업만 있다. · 검색어 VersionModal, VersionPopup, VersionPopUp: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-d5f5cec810 | H4 | [결함 유형 묶음 H4-G03 · 2건] 좌/우 사용자 영역 높이 | DMF0042는 메인 그리드(spdMain) 하나만 있고 좌/우 사용자 영역과 하단 탭이 없다. · 검색어 SplitContainer, Splitter, leftArea, rightArea: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-0b29dfe60e | H5 | [결함 유형 묶음 H5-G01 · 2건] Version·Plan Type 조회조건 라벨 명칭 | DMF0042 조회조건에는 Version 콤보와 Waterfall Type 라벨이 없습니다. · 검색어 cboVersion, Waterfall, Plan Type: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-a85efbed3c | J3 | [결함 유형 묶음 J3-G01 · 2건] MKT_FCST·SCM_FCST Measure 편집 구간(GET_ADMIN_GROUP_MEASURE) | DMF0042 에는 GET_ADMIN_GROUP_MEASURE 룩업과 SCM_FCST Measure 편집 구간이 없습니다. · 검색어 GET_ADMIN_GROUP_MEASURE, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-9544503391 | M1 | [결함 유형 묶음 M1-G07 · 2건] Excel Upload 후 OK 저장·DB 반영 | DMF0042에는 Excel Upload 창과 OK 저장 단계가 없어 업로드 후 DB 반영을 확인할 대상이 없습니다. · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-17e4c65e5f | M2 | [결함 유형 묶음 M2-G01 · 2건] SQL View 버튼(VIEW) 클릭 결과 | DMF0042 요소 목록과 소스에는 SQL View(VIEW) 버튼이 없어 확인할 대상이 없습니다. · 검색어 SQL View, btnSqlView, VIEW_SQL: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-cdf6514f64 | M3 | [결함 유형 묶음 M3-G01 · 2건] SQL 버튼 팝업 쿼리 저장 | DMF0042 AS-IS 소스에 SQL 버튼과 쿼리 등록 팝업이 없습니다. · 검색어 btnSql, SqlPopup, SQL 버튼: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-3c102fc763 | C3 | Sales Company·Sales Plant 셀 | DMF0042 AS-IS 소스와 TO-BE 화면 폴더에는 Sales Company·Sales Plant 셀이 없다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Company, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-8ae2cb26ec | M1 | Excel Upload Validation 메시지(Sales Site/Project/Model) | DMF0042에는 Excel Upload 검증 단계가 없어 Sales Site·Project·Model 행별 실제 원인 메시지를 확인할 대상이 없습니다. · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-6e5c0d0b20 | C5 | 다중 그리드 더블클릭 연동 | DMF0042 는 그리드가 spdMain 하나뿐이어서 다중 그리드 더블클릭 연동이 없습니다. · 검색어 spdSub, spdDetail, spdBottom: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |
| C-920b149996 | M1 | Excel Form 버튼 | DMF0042 AS-IS와 TO-BE 모두 Excel Form 버튼이 없어 Excel Form 팝업 동작을 확인할 대상이 없습니다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 48개 파일·요소 목록 0건 |

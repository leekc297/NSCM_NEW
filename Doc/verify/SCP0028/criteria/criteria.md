# SCP0028 기준 원장 (2026-11-25 02:48:39)

- 원장 1073행 → 기준 항목 974개 · 요소 76개 · 상태 확정 565 · 대상 아님 389 · 판단 대기 20
- 다른 문서 행 711행: 같은 확인으로 합침 99 · 요소 지정 71 · 화면 전체 134 · 대상 아님(검색 0건 확인) 381 · 판단 대기 18
- TO-BE 룰 결합 219건(인용 불일치로 버림 0) · AS-IS 실측 연결 135건(판단 대기 79) · 사용자의견 고정 0건
- AI 호출 37(기억 0 · 실패 0 · 바꾼 것 없는 호출 0) · 비용 출처 Doc/verify/SCP0028/llm_usage.csv

## 판단 대기(사용자 확인)

| 기준 항목 | 요소 | 규칙 | 확인 | 사유 |
|---|---|---|---|---|
| C-f97c16a388 | SCREEN | A7 | RTF Measure 금액(AMT) 계산 시 적용 LOC(판가) 기준(RTF · AMT · LOC) | SCP0028에는 RTF Measure와 AMT 금액 계산 기능이 없습니다. · 검색어가 화면에 있음: LOC 6곳 |
| C-5a0ce00a23 | SCREEN | F4 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | 기준 정리 답 없음(AI 꺼짐 또는 실패) — 화면 전체로 둠 |
| C-50eda4e96b | SCREEN | M3 | [DMF0042 결함 유형] Replace 버튼 팝업 Period·조회 | SCP0028 에는 Replace 버튼 팝업과 Period 조건이 없다. · 검색어가 화면에 있음: Replace 4곳 |
| C-b94d433b61 | SCREEN | N1 | [DMF0044 결함 유형] Measure 항목 구성 | SCP0028에는 Div별 UI Category에 따라 Measure를 표시하는 구성이 없다. · 검색어가 화면에 있음: UI Category 1곳 |
| C-eec85fa671 | SCREEN | F6 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SCP0028 에는 FCST Type=ETC 행과 Text 필수 검증이 없고, 기존 행 갱신은 C-12d88fd0aa 에서 이미 다룬다. · 검색어가 화면에 있음: ETC 9곳 |
| C-959e03e733 | SCREEN | D5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0028에는 Sales Site·Project 팝업·Team 컬럼이 없다. · 검색어가 화면에 있음: Project 3곳 |
| C-a9c6d4b08b | SCREEN | F6 | [DMF0082 결함 유형] Unit Price(LOC) 저장 | SCP0028 에는 Unit Price(LOC) 컬럼과 조회기간별 값 저장이 없다. · 검색어가 화면에 있음: LOC 6곳 |
| C-a3a9d4a494 | SCREEN | H3 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0028 화면에는 Dept 컬럼과 Use Y/N 헤더 병합이 없습니다. · 검색어가 화면에 있음: SSO 2곳 |
| C-3b53561ff1 | SCREEN | F6 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0028 에는 Dept 컬럼과 Use Y/N 헤더가 없고 사용 여부는 Active*(VALID_YN) 컬럼으로만 관리한다. · 검색어가 화면에 있음: SSO 2곳 |
| C-749b9b1b82 | SCREEN | D1 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | 이 화면에는 ROUTE_PATH 컬럼이 없다. · 검색어가 화면에 있음: ROUTE_PATH 1곳 |
| C-f18ccb8695 | SCREEN | F8 | [SYS0011 결함 유형] Approval Date 컬럼 | SCP0028 에는 Request·Approval 흐름과 Approval Date 컬럼이 없다. · 검색어가 화면에 있음: Request 7곳 |
| C-566f47a3fb | SCREEN | F1 | [SYS0011 결함 유형] Approval Date 컬럼 | SCP0028 에는 Approval Date 컬럼과 Request 기능이 없다. · 검색어가 화면에 있음: Request 7곳 |
| C-9e1055744f | SCREEN | C1 | [DMF0035 결함 유형] Version 조회조건 기본값 | SCP0028 조회조건에는 Version 콤보가 없다. · 검색어가 화면에 있음: Current 4곳 |
| C-795ab72c1f | SCREEN | C2 | [SCP0007 결함 유형] Insert 행 Div 셀 / 하위 Site | AS-IS SCP0028 의 InsertRow 는 비어 있어 행 입력을 SCM0002_ShipmentLotSizePopup 이 맡고, 그리드 DIVISION_ID~TRANS_MODE_NAME 컬럼은 LockColumn 으로 잠겨 있어 Insert 행에서 Div 셀을 바꾸는 기능이 없다. · 검색어가 화면에 있음: FROM_SITE 8곳, DIVISION_I |
| C-33cdf3a97e | SCREEN | F4 | [SCP0007 결함 유형] Period 날짜 | 기준 정리 답 없음(AI 꺼짐 또는 실패) — 화면 전체로 둠 |
| C-6cab6caee5 | SCREEN | MS1 | [DMF0014 결함 일반화] 공용 업로드 창(Upload) 검증 완료 후 저장 전 Cancel · X 닫기 확인창 MSG00684 「취소하시겠습니까?」(AS-IS MSG00195) | SCP0028 에는 공용 업로드 창(Upload) 기능이 없다. · 검색어가 화면에 있음: Upload 1곳 |
| C-163de5d76d | SCREEN | MS1 | [DMF0043_01 결함 일반화] Version 팝업 미선택 OK 안내 — 다국어 코드 MSG00701(AS-IS MSG00279) 「버전은 1개만 선택해 주세요.」/「Please select only one ve | SCP0028 에는 Version 팝업이 없고, Version 미선택 안내(MSG00279·MSG00701)를 쓰는 곳도 없다. · 검색어가 화면에 있음: MSG00279 1곳, MSG00701 1곳 |
| C-1a36d25487 | SCREEN | A8 | [결함 유형 묶음 A8-G01 · 2건] 팝업 Spread의 기간 동적 컬럼(YYYYMM) | SCP0028의 Input·Delete 팝업에는 Period 기간에 따라 늘어나는 YYYYMM 동적 컬럼이 없습니다. · 검색어가 화면에 있음: YYYYMM 1곳 |
| C-482ac32f4b | SCREEN | G5 | [결함 유형 묶음 G5-G02 · 2건] 팝업 Spread 기간 컬럼 생성 | SCP0028 팝업은 기간 Spread 컬럼을 만들지 않는다. · 검색어가 화면에 있음: YYYYMM 1곳 |
| C-9850a4044b | SCREEN | M3 | [결함 유형 묶음 M3-G04 · 2건] 팝업 Period 기간별 월 컬럼 생성·조회 | SCP0028 팝업에는 Period 조건과 월별 YYYYMM 컬럼이 없다. · 검색어가 화면에 있음: YYYYMM 1곳 |
| 실측 | SP:SQL: SELECT * | - | 실측-파싱 대조 SQL: SELECT * | AS-IS 1회 · TO-BE  · INLINE |
| 실측 | SP:SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | - | 실측-파싱 대조 SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | SP:SCP0028_SAVE_SHIPMENT_LOT_SIZE | - | 실측-파싱 대조 SCP0028_SAVE_SHIPMENT_LOT_SIZE | AS-IS 0회 · TO-BE  · NOT_CALLED |
| 실측 | (요소 없음) | - | 실측-파싱 대조 (선언 ↔ 실측) | AS-IS 26개 · TO-BE  · INFO |
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
| 실측 | (요소 없음) | - | 실측-파싱 대조 txtItemId | AS-IS Model · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnItemId | AS-IS layoutControlItem11 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 cboValid | AS-IS Valid · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnInput | AS-IS Input · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 btnDelete | AS-IS Delete · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clbToSite | AS-IS To Site · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 clbTransMode | AS-IS Trans Mode · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 실측-파싱 대조 spdMain/Shipment Lot Size | AS-IS 컬럼 20(보임 15) · 헤더 1단 · 행 1735 · 고정 1 · TO-BE  · LIVE |
| 실측 | (요소 없음) | - | 조회 인자 SCP0028_GET_SHIPMENT_LOT_SIZE.action_flag | AS-IS  · TO-BE D · TOBE_ONLY |
| 실측 | COND:TRANS MODE | - | 조회 인자 SCP0028_GET_SHIPMENT_LOT_SIZE.trans_mode | AS-IS  · TO-BE  · ASIS_ONLY |
| 실측 | COND:VALID | - | 조회 인자 SCP0028_GET_SHIPMENT_LOT_SIZE.valid | AS-IS  · TO-BE  · ASIS_ONLY |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.debug_mode | AS-IS F · TO-BE N · DIFF |
| 실측 | COL:INCREMENT | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.increment | AS-IS 12800 · TO-BE 2484 · DIFF |
| 실측 | COL:ITEM_ID | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.item_id | AS-IS ACEP2065I-B1 · TO-BE ACPP1015U-B1-001 · DIFF |
| 실측 | COL:LOT_SIZE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.lot_size | AS-IS 12801 · TO-BE 24840 · DIFF |
| 실측 | COL:TO_SITE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.to_site | AS-IS Club Car_US_AGS · TO-BE BAE_US_ENC · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.debug_mode | AS-IS F · TO-BE N · DIFF |
| 실측 | COL:INCREMENT | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.increment | AS-IS 1 · TO-BE 2484 · DIFF |
| 실측 | COL:ITEM_ID | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.item_id | AS-IS ACEP2065I-B1 · TO-BE ACPP1015U-B1-001 · DIFF |
| 실측 | COL:LOT_SIZE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.lot_size | AS-IS 1 · TO-BE 24840 · DIFF |
| 실측 | COL:TO_SITE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.to_site | AS-IS Club Car_US_AGS · TO-BE BAE_US_ENC · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.transport_mode | AS-IS AIR · TO-BE SEA · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.debug_mode | AS-IS F · TO-BE N · DIFF |
| 실측 | COL:INCREMENT | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.increment | AS-IS 1 · TO-BE 2484 · DIFF |
| 실측 | COL:ITEM_ID | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.item_id | AS-IS ACEP2065I-B1 · TO-BE ACPP1015U-B1-001 · DIFF |
| 실측 | COL:LOT_SIZE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.lot_size | AS-IS 1 · TO-BE 24840 · DIFF |
| 실측 | COL:TO_SITE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.to_site | AS-IS Club Car_US_AGS · TO-BE BAE_US_ENC · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.transport_mode | AS-IS AIR · TO-BE SEA · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.debug_mode | AS-IS F · TO-BE N · DIFF |
| 실측 | COL:INCREMENT | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.increment | AS-IS 12800 · TO-BE 2484 · DIFF |
| 실측 | COL:ITEM_ID | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.item_id | AS-IS ACEP2065I-B1 · TO-BE ACPP1015U-B1-001 · DIFF |
| 실측 | COL:LOT_SIZE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.lot_size | AS-IS 12801 · TO-BE 24840 · DIFF |
| 실측 | COL:TO_SITE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.to_site | AS-IS Club Car_US_AGS · TO-BE BAE_US_ENC · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.debug_mode | AS-IS F · TO-BE N · DIFF |
| 실측 | COL:INCREMENT | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.increment | AS-IS 1 · TO-BE 2484 · DIFF |
| 실측 | COL:ITEM_ID | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.item_id | AS-IS ACEP2065I-B1 · TO-BE ACPP1015U-B1-001 · DIFF |
| 실측 | COL:LOT_SIZE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.lot_size | AS-IS 1 · TO-BE 24840 · DIFF |
| 실측 | COL:TO_SITE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.to_site | AS-IS Club Car_US_AGS · TO-BE BAE_US_ENC · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.transport_mode | AS-IS AIR · TO-BE SEA · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.debug_mode | AS-IS F · TO-BE N · DIFF |
| 실측 | COL:INCREMENT | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.increment | AS-IS 12800^288 · TO-BE 2484^12800 · DIFF |
| 실측 | COL:ITEM_ID | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.item_id | AS-IS ACEP2065I-B1^ACEN1053I-A1 · TO-BE ACPP1015U-B1-001^ACEP2065I-B1 · DIFF |
| 실측 | COL:LOT_SIZE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.lot_size | AS-IS 12801^5761 · TO-BE 24840^12800 · DIFF |
| 실측 | COL:TO_SITE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.to_site | AS-IS Club Car_US_AGS^CS Enertech_KR_OSN · TO-BE BAE_US_ENC^Club Car_US_AGS · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.transport_mode | AS-IS SEA^TRK · TO-BE SEA^SEA · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.active_flag | AS-IS D · TO-BE M · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.debug_mode | AS-IS F · TO-BE N · DIFF |
| 실측 | COL:INCREMENT | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.increment | AS-IS 0 · TO-BE 2484 · DIFF |
| 실측 | COL:ITEM_ID | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.item_id | AS-IS ACEP2065I-B1 · TO-BE ACPP1015U-B1-001 · DIFF |
| 실측 | COL:LOT_SIZE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.lot_size | AS-IS 0 · TO-BE 24840 · DIFF |
| 실측 | COL:TO_SITE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.to_site | AS-IS Club Car_US_AGS · TO-BE BAE_US_ENC · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.transport_mode | AS-IS X · TO-BE SEA · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |

## 대상 아님

| 기준 항목 | 규칙 | 확인 | 근거 |
|---|---|---|---|
| C-e35a680324 | A1 | SCP0028 화면 | TO-BE 룰 CR-105: 값 불일치와 행·키 집합 차이는 판정에서 뺀다(해당없음으로 두고 근거를 표시한다). · SCP0028 화면 A1 항목은 조회 결과의 행수와 키 집합을 비교하는 확인인데, 이 룰이 행·키 집합 차이를 판정에서 빼므로 해당없음이다. |
| C-867d62bd01 | D6 | SCP0028 정렬 상태 Insert | TO-BE 룰 CR-070: AS-IS 가 기능 없는 버튼(override 본문 공백)을 일괄 노출해도 TO-BE 는 숨긴다(= PASS). · AS-IS InsertButton이 부르는 InsertRow 본문이 비어 있어 Insert는 기능 없는 버튼이므로 Insert 행의 Div·필터·정렬·위치 확인은 대상이 아니다. |
| C-705a05c192 | D6 | SCP0028 필터 상태 Insert | TO-BE 룰 CR-070: AS-IS 가 기능 없는 버튼(override 본문 공백)을 일괄 노출해도 TO-BE 는 숨긴다(= PASS). · AS-IS InsertButton이 부르는 InsertRow 본문이 비어 있어 Insert는 기능 없는 버튼이므로 Insert 행의 Div·필터·정렬·위치 확인은 대상이 아니다. |
| C-d99f7049ee | I1 | SCP0028 시나리오 CN 언어 조회 건수 총/건 표기 | TO-BE 룰 DD-215: AS-IS: CN 언어 총/건 표기 검사 대상 → TO-BE: 검사 대상 제외(NA) · CN 언어 조회 건수 총/건 표기는 2026-11-06 사용자 결정으로 검사 대상에서 빠졌습니다. |
| C-bf407e8d3f | D6 | SCP0028 시나리오 [자동] 선택 행 위로 Insert | TO-BE 룰 CR-070: AS-IS 가 기능 없는 버튼(override 본문 공백)을 일괄 노출해도 TO-BE 는 숨긴다(= PASS). · AS-IS InsertButton이 부르는 InsertRow 본문이 비어 있어 Insert는 기능 없는 버튼이므로 Insert 행의 Div·필터·정렬·위치 확인은 대상이 아니다. |
| C-b7cf65884c | D4 | SCP0028 Insert 행 Division | TO-BE 룰 CR-070: AS-IS 가 기능 없는 버튼(override 본문 공백)을 일괄 노출해도 TO-BE 는 숨긴다(= PASS). · AS-IS InsertButton이 부르는 InsertRow 본문이 비어 있어 Insert는 기능 없는 버튼이므로 Insert 행의 Div·필터·정렬·위치 확인은 대상이 아니다. |
| C-4876b42679 | K1 | SCP0028 필터 유지 재조회 | TO-BE 룰 DD-217: TO-BE: 검사 대상 제외(NA) · 사유 사용자 결정 2026-11-06(SCP0016 CheckList 11번) — 공통 기능(공용 DataGrid)이라 화면별 오류 아님 · 재조회 때 필터 유지 여부는 사용자 결정으로 공용 DataGrid 기능이 되어 SCP0028 화면별 검사 대상에서 빠진다. |
| C-3e785657cb | D1 | siMain.SwitchLock | TO-BE 룰 CR-093: TO-BE 는 Edit(F2) 버튼으로 편집 모드를 켜지 않고 셀을 바로 편집한다 · TO-BE 에는 Edit 토글이 없으므로 siMain.SwitchLock() 잠금 전환은 확인 대상이 아니다. |
| C-b31c6e487a | K2 | 컬럼/Measure 셋팅(개인화 Default) | SCP0028 화면에는 컬럼/Measure 셋팅 개인화 기능이 없어 개인화가 없을 때의 Default 컬럼·Measure 표시를 확인할 수 없다. · 검색어 ColumnSetting, Measure, UI_CATEGORY, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ed5e509bcd | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | 이 화면의 조회조건에는 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보가 없다. · 검색어 SALES_SITE, END_CUSTOMER, SOLD_TO, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-03f9afe2e6 | C1 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SCP0028 조회조건에는 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보가 없다. · 검색어 SALES_SITE, END_CUSTOMER, SOLD_TO, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6bfd4c490c | B8 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SCP0028 조회조건은 Division·Operation Group·From Site·To Site·Model·Valid·Trans Mode이고 Sales Site·End Customer·Sold to Customer·Team 콤보가 없다. · 검색어 SALES_SITE, END_CUSTOMER, SOLD_TO_CUSTOMER, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b647339101 | B2 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Customer) | 대상은 Sales Site 화면에서 Insert할 때의 End Customer·Sold-to Customer 콤보이며, SCP0028 그리드에는 두 컬럼이 없습니다. · 검색어 END_CUSTOMER, SOLD_TO_CUSTOMER, Sold-to Customer, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b7f5e63342 | B3 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Customer) | 대상은 Sales Site 화면에서 Insert할 때의 End Customer·Sold-to Customer 콤보이며, SCP0028 그리드에는 두 컬럼이 없습니다. · 검색어 END_CUSTOMER, SOLD_TO_CUSTOMER, Sold-to Customer, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4e7e2d259c | B4 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Customer) | SCP0028 그리드에는 End Customer·Sold-to Customer 셀 콤보가 없습니다. · 검색어 END_CUSTOMER, SOLD_TO_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8e5251c1e4 | M4 | 팝업 입력 컬럼 | SCP0028 그리드에는 팝업으로 값을 넣는 셀이 없다. 편집할 수 있는 컬럼은 LOT_SIZE·INCREMENT·VALID_YN·SPLIT_YN 뿐이다. · 검색어 ButtonClicked, CellDoubleClick, cellPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fec3161cfc | K2 | Measure 순서·메저셋팅 순서 저장 | SCP0028 화면에는 메저셋팅이 없어 메저셋팅 순서 저장과 Measure 순서를 확인할 대상이 없다. · 검색어 Measure, MeasureSetting, Measure Setting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1cc8a9e52b | J4 | Home / Auth Request 메뉴 | Home / Auth Request 메뉴는 다른 화면의 기능이고, SCP0028 Shipment Lot Size 화면에는 이 기능이 없다. · 검색어 Auth Request, AuthRequest, AUTH_REQUEST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-73b1eb19ac | M4 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | SCP0028 의 ITEM_ID(Model) 컬럼은 잠금 컬럼이라 그리드 셀에서 Model 팝업을 열지 않고, Model 팝업은 조회조건의 ITEMID 버튼에서만 연다. · 검색어 ButtonClicked, CellDoubleClick, cellPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-bc5b777e47 | H6 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | SCP0028 그리드 ITEM_ID(Model) 컬럼에는 셀 Model 팝업이 없고 Model 팝업은 조회조건에서만 연다. · 검색어 ButtonClicked, FPModal, CellPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cb567b6ee5 | DB-SYN | TO-BE PKG 소스(PKG_DMF0003·PKG_DMF0021·PKG_DMF0042·PKG_DMF0045·PKG_DMF0049·PKG_DMF0082) 의 AS-IS 사용자 테이블(TB_FX_USER 등) 참조 | 대상 PKG는 DMF 화면 PKG이고 SCP0028의 PKG_SCP0028은 목록에 없다. · 검색어 TB_FX_USER, PKG_DMF0003, PKG_DMF0082: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-93a55ca312 | A5 | [SYS0002 결함 유형] User 화면 Group 컬럼 | SCP0028 에는 User 화면의 Group 컬럼이 없다. · 검색어 DEFAULT_GROUP, Default Group, USER_GROUP: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2f7bfe647f | B6 | [DMF0043_01 결함 유형] 조회조건 Product Group·Biz Type | SCP0028 조회조건에 Product Group·Biz Type이 없다. · 검색어 Product Group, PRODUCT_GROUP, Biz Type, BIZ_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8fc809556e | G2 | [DMF0043_01 결함 유형] 조회조건 Product Group·Biz Type | SCP0028 조회조건은 Division·Operation Group·From Site·To Site·Model/Nickname·Valid·Trans Mode이고 Product Group·Biz Type 조건은 없다. · 검색어 Product Group, Biz Type, PRODUCT_GROUP, BIZ_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f90a5c0e2a | B4 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | 이 행의 B4 확인 대상인 Sales Site 셀 콤보가 SCP0028 그리드에 없습니다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fcff138de7 | F1 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | SCP0028 에는 Sales Site 셀 콤보가 없고, 사이트 관련 컬럼은 From Site 와 To Site 다. · 검색어 Sales Site, SALES_SITE, SalesSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5d407d49da | F2 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | 이 화면 그리드에는 Sales Site 셀 콤보가 없다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4a4251ac00 | F6 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | SCP0028 에는 Sales Site 셀 콤보가 없고, 저장 반영 확인은 C-44229301d8 에서 이미 다룬다. · 검색어 Sales Site, SALES_SITE, SalesSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c5e4f09db4 | B5 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_MST_CUSTOMER_FCST(_C/_H).MEASURE | 이 화면에는 Customer FCST Measure 콤보가 없다. · 검색어 CUST_FCST_MEASURE, DM_MST_CUSTOMER_FCST, Customer FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fca9ddf123 | N1 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_MST_CUSTOMER_FCST(_C/_H).MEASURE | SCP0028에는 Measure Combo(CUST_FCST_MEASURE)와 DM_MST_CUSTOMER_FCST 데이터가 없다. · 검색어 CUST_FCST_MEASURE, Cutomer FCST, DM_MST_CUSTOMER_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3b1dbe8930 | M3 | [DMF0005 결함 유형] Team 팝업 | SCP0028 에는 Team 팝업이 없다. · 검색어 TeamPopup, SSO_DEPT, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4819771fd0 | G5 | [DMF0005 결함 유형] Team 팝업 | SCP0028 조회조건은 Division·Operation Group·From Site·To Site·Trans Mode·Valid·Model 뿐이고 Team 팝업이 없다. · 검색어 SSO_DEPT, TeamPopup, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2460be616a | C3 | [DMF0005 결함 유형] Team·Owner 컬럼 | SCP0028 화면에는 Team·Owner 컬럼이 없습니다. · 검색어 Team, Owner, OWNER: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-af0148bb5f | F6 | [DMF0005 결함 유형] Team·Owner 컬럼 | SCP0028 그리드에는 Team·Owner 컬럼이 없다. · 검색어 TEAM, OWNER, Team, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e807506246 | F1 | [DMF0005 결함 유형] 하단 Purchase 탭 EDI Incoterms | SCP0028 에는 하단 Purchase 탭과 EDI Incoterms 컬럼이 없다. · 검색어 Incoterms, INCOTERMS, Purchase: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4df874a9bb | E3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | SCP0028 그리드에는 Team 팝업 컬럼과 Project 컬럼이 없다. · 검색어 TEAM_CODE, PROJECT_CODE, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5c5602f364 | F3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | 이 화면 그리드에는 Team 팝업 컬럼과 Project 컬럼이 없다. · 검색어 TEAM_ID, Team Code, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-416a36f228 | D1 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | 이 화면에는 Team 팝업 컬럼과 Project 컬럼이 없다. · 검색어 TEAM_CODE, TEAM_NAME, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-15615605e9 | K3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | 이 화면 그리드의 편집 컬럼은 Lot Size·Increment·Active·Container Split 4개이고 Team·Project 팝업 컬럼은 없습니다. · 검색어 TEAM_CODE, PROJECT_CODE, TEAM_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-23dd793289 | B4 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | 이 화면에는 Team 조회조건과 그리드 Team·End Customer·Sales Site 콤보가 없다. · 검색어 DEPT_ID, END_CUSTOMER, SALES_SITE, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1cab3d909d | C1 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SCP0028 에는 Team 조회조건이 없고, 그리드에도 Team·End Customer·Sales Site 콤보가 없다. · 검색어 DEPT_ID, END_CUSTOMER, SALES_SITE, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d3df98bf57 | B2 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SCP0028에는 조회조건 Team과 그리드 End Customer·Sales Site 콤보가 없고, AS-IS 소스와 TO-BE 화면 폴더에서도 END_CUSTOMER·DEPT_ID가 0건입니다. · 검색어 END_CUSTOMER, DEPT_ID, End Customer, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-44fd997d9c | B8 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SCP0028에는 Team 조회조건, 그리드 Team·End Customer·Sales Site 콤보가 없다. · 검색어 DEPT_ID, Team, END_CUSTOMER, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-438cf6adaf | N1 | [DMF0020 결함 유형] Exchange Rate 팝업 · DM_MST_EXCHANGE_RATE | SCP0028에는 Exchange Rate 팝업과 Period 기간만큼 그리는 YYYYMM 컬럼이 없고, 기간 이상값 확인은 C-9cd5b75f3d가 맡는다. · 검색어 EXCHANGE_RATE, Exchange Rate, DM_MST_EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c15f31d807 | D2 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | 이 화면에는 Monthly Bucket 입력과 Project Code 팝업이 없다. · 검색어 Monthly, BUCKET_TYPE, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-31fb6f6f53 | F6 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SCP0028 에는 Monthly Bucket 입력 셀과 Project Code 팝업이 없고 Lot Size·Increment 컬럼만 저장한다. · 검색어 Monthly, Bucket, PROJECT_CODE, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-618b571050 | F4 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SCP0028에는 Monthly Bucket 입력과 Project Code 팝업이 없다. · 검색어 Monthly, Bucket, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1f683f05f0 | M3 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SCP0028 에는 Monthly Bucket 입력 컬럼과 Project Code 팝업이 없고, 그리드 컬럼은 LOT_SIZE·INCREMENT·VALID_YN·SPLIT_YN 등 Lot Size 항목뿐이다. · 검색어 Monthly, Bucket, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6b7c3e5dc7 | K2 | [DMF0020 결함 유형] 조회 건수 · Team 컬럼 표시 · 컬럼팝업 저장 설정 | SCP0028 그리드에는 Team 컬럼과 컬럼팝업 저장 구성이 없다. · 검색어 ColumnSetting, Team, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4c544c9962 | J2 | [DMF0020 결함 유형] Price Batch Input 버튼 | SCP0028 화면에는 Price Batch Input 버튼이 없다. · 검색어 Price Batch Input, btnPriceBatch, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e4bc9752bb | K4 | [DMF0020 결함 유형] Price Batch Input 버튼 | Price Batch Input 버튼은 이 화면 버튼 목록에 없습니다. · 검색어 Price Batch Input, PriceBatch, btnPriceBatch: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0620638323 | G4 | [DMF0020 결함 유형] 조회조건 Project | 이 화면에는 Project 조회조건이 없다. · 검색어 cboProject, clbProject: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-75f1979cd9 | G4 | [DMF0068 결함 유형] Main Version 조회조건 크기 · Version 팝업 Description 컬럼 폭 | 이 화면에는 Main Version 조회조건과 Version 팝업이 없다. · 검색어 Main Version, MAIN_VERSION: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-15e8913185 | H6 | [DMF0068 결함 유형] Main Version 조회조건 크기 · Version 팝업 Description 컬럼 폭 | SCP0028 화면에는 Main Version 조회조건과 Version 팝업이 없다. · 검색어 MainVersion, Main Version, VersionPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-80dab668f4 | B4 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer 콤보 | SCP0028 그리드에는 End Customer·Sold to Customer 콤보가 없습니다. · 검색어 END_CUSTOMER, SOLD_TO_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ab4ba3b0cc | B7 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer 콤보 | SCP0028 그리드에 End Customer·Sold to Customer 콤보가 없다. · 검색어 END_CUSTOMER, SOLD_TO_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0b94b462a7 | C2 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | SCP0028 그리드에는 Cust Group·End Customer·Sales Site 연쇄 콤보 셀이 없다. · 검색어 CUST_GROUP, END_CUSTOMER, Cust Group: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-264e31a6d1 | B2 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | SCP0028 그리드에는 Cust Group→End Customer→Sales Site로 이어지는 연쇄 콤보가 없습니다. · 검색어 CUST_GROUP, Cust Group, END_CUSTOMER: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e21afde888 | K1 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | SCP0028 그리드에는 Cust Group→End Customer→Sales Site 연쇄 칸이 없다. · 검색어 CUST_GROUP, END_CUSTOMER, End Customer, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-16ccc6f073 | E4 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Active 컬럼 | SCP0028 에는 Cust Group·End Customer·Sales Site 관계 컬럼이 없다. · 검색어 End Customer, Cust Group: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-89af789c7b | B4 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | SCP0028 에는 Team·End Customer·Sales Site 후보가 없습니다. · 검색어 Team, END_CUSTOMER, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b8b4590a74 | C1 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | SCP0028 에는 Team·End Customer·Sales Site 후보 콤보가 없다. · 검색어 DEPT_ID, END_CUSTOMER, SALES_SITE, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-46585778e2 | M1 | [DMF0014 결함 유형] Excel Form 입력 버킷 | SCP0028 에는 Excel Form 이 없고 Period 조회조건도 없다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-00080fbf16 | M1 | [DMF0014 결함 유형] Excel Form 양식 | SCP0028 의 AS-IS·TO-BE 버튼은 Search·Save·Input·Delete·Excel 이고 Excel Form 양식 다운로드 기능은 없다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8a21d25282 | H2 | [DMF0003 결함 일반화] 실적 구간 배경색 | Shipment Lot Size 그리드에는 실적 기간 구간 컬럼이 없다. · 검색어 Actual, ACTUAL: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a96e1bffc9 | D2 | [DMF0003 결함 일반화] 실적 구간 배경색 | 이 화면에는 기간 Bucket 이 없어 실적 구간 셀도 없다. · 검색어 ACTUAL_PERIOD, Actual, 실적 구간: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8949f3d1e9 | C2 | [DMF0003 결함 유형] AS From Site 입력 후 W35~W38 수량 | SCP0028 에는 AS From Site 입력과 주차별(W35~W38) 수량 컬럼이 없다. · 검색어 AS_FROM_SITE, AS From Site, W35: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-853c0cfa4e | B8 | [DMF0003 결함 일반화] Team 컬럼(MKT FCST 조회·신규행) | SCP0028 그리드에 Team 컬럼이 없다. · 검색어 DEPT_ID, Team, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a8a7b557c1 | A2 | [DMF0003 결함 일반화] Team 컬럼(MKT FCST 조회·신규행) | SCP0028 화면에는 Team 컬럼이 없다. · 검색어 DEPT_ID, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-747cfb8056 | B5 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | 이 화면에는 FCST Type 콤보와 Measure 입력이 없다. · 검색어 FCST_TYPE, FCST Type, SALES_TYPE_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f783f29944 | D3 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | SCP0028에는 FCST Type 콤보와 Measure 입력이 없다. · 검색어 FCST Type, FCST_TYPE, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a38aa0a017 | A5 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SCP0028 에는 컬럼셋팅 VERSION 컬럼과 AS FROM SITE 컬럼이 없다. · 검색어 AS_FROM_SITE, AS FROM SITE, PLAN_VERSION: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c025115802 | K2 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SCP0028 그리드에는 VERSION 컬럼과 AS FROM SITE 컬럼이 없고 컬럼셋팅 목록도 없다. · 검색어 VERSION, AS_FROM_SITE, ColumnSetting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a591ca7b08 | N1 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SCP0028에는 컬럼셋팅의 VERSION 컬럼과 AS FROM SITE 컬럼이 없고, From Site·To Site 컬럼만 있다. · 검색어 AS_FROM_SITE, AS FROM SITE, Column Setting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0c22081e2a | E1 | [DMF0082 결함 유형] MKT_FCST[R+P]·AS_In_Request[R+P]·Unit_Price(LOC) | SCP0028 그리드에는 MKT_FCST·AS_In_Request·Unit_Price(LOC) 컬럼이 없다. · 검색어 MKT_FCST, AS_IN_REQUEST, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a8301385a3 | M3 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | SCP0028 에는 Price Batch Input 팝업과 End Customer 컬럼이 없다. · 검색어 Price Batch, PriceBatch, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b596200287 | H3 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | SCP0028 화면에는 Price Batch Input 팝업과 End Customer 컬럼이 없습니다. · 검색어 End Customer, END_CUSTOMER, Price Batch Input: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-79f22ec67c | G4 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | 이 화면에는 Price Batch Input 팝업과 End Customer 컬럼이 없다. · 검색어 End Customer, END_CUSTOMER, PriceBatch: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-66cb60b962 | M3 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SCP0028 에는 Exchange Rate 팝업과 그 저장 기능이 없다. · 검색어 Exchange Rate, ExchangeRate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-924a5fdd8d | F4 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SCP0028에는 Exchange Rate 팝업이 없다. · 검색어 Exchange Rate, ExchangeRate: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-591e3170b0 | F3 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | 이 화면에는 Exchange Rate 팝업 저장 기능이 없다. · 검색어 Exchange Rate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-af56acddc2 | F1 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SCP0028 에는 Exchange Rate 팝업이 없고, 쓰는 팝업은 Shipment Lot Size Input/Delete 팝업과 Item 팝업뿐이다. · 검색어 Exchange Rate, EXCHANGE_RATE, EXCH_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-315ce1de99 | M2 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | 이 행은 BPS I/F 버튼으로 환율을 반영하는지 확인하는데, SCP0028 에는 BPS I/F 버튼과 환율 반영 기능이 없다. · 검색어 BPS, Exchange Rate, 반영할 환율 정보가 없습니다: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c1e1b2fe02 | F1 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | 이 화면에는 BPS I/F 버튼과 환율 반영 기능이 없다. · 검색어 BPS, Exchange Rate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5dd1cba597 | E4 | [DMF0082 결함 유형] Biz Type 미존재 검증 팝업 메시지 | SCP0028 에는 Biz Type 미존재 검증이 없다. · 검색어 Biz Type, BIZ_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4813bc3f6c | F6 | [DMF0082 결함 일반화] 필수 컬럼(Project Code·Plant Site) 표시 · 저장 | SCP0028 에는 Project Code·Plant Site 필수 컬럼이 없다. · 검색어 PROJECT_CODE, PLANT_SITE, Plant Site, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7076fcb0e2 | A5 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SCP0028 에는 Measure 셋팅과 VMI·MKT FCST AMT 메저가 없다. · 검색어 VMI, MKT FCST, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d6d5c36a0a | K2 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SCP0028 화면에는 VMI 메저와 MKT FCST AMT 같은 Measure 가 없다. · 검색어 VMI, MKT FCST AMT, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-58c37c1108 | N1 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SCP0028에는 Measure 셋팅이 없고 VMI·MKT FCST AMT 메저도 없다. · 검색어 Measure, VMI, MKT FCST AMT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b7f43020bd | B5 | [DMF0082 결함 유형] SCM_FCST·MKT_FCST 편집 구간(GET_ADMIN_GROUP_MEASURE) | 이 화면에는 SCM_FCST·MKT_FCST 편집 구간이 없다. · 검색어 GET_ADMIN_GROUP_MEASURE, SCM_FCST, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-28bd91645b | N1 | [DMF0007 결함 유형] Customer FCST Master 기준정보 | SCP0028에는 Customer FCST Master 기준정보를 조회하는 기능이 없다. · 검색어 Customer FCST, CUSTOMER_FCST, DM_MST_CUSTOMER_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-897d9b209f | A1 | [DMF0007 결함 유형] Customer FCST Master 기준정보 | SCP0028 화면은 Customer FCST Master 기준정보를 조회하지 않는다. · 검색어 Customer FCST, CUSTOMER_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5beb3c5c92 | B4 | [DMF0004 결함 유형] Sales Site 조회조건 표시값 | 이 화면의 조회조건에는 Sales Site가 없다. · 검색어 SALES_SITE, Sales Site, salesSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7cf32feb90 | C2 | [DMF0005 결함 일반화] Sales Company·Sales Plant 셀 | SCP0028 그리드에는 Sales Company·Sales Plant 콤보 셀이 없다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9c53b0a219 | E1 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | SCP0028 에는 RTF×Unit Price 계산값 컬럼이 없고 저장 수치 컬럼은 LOT_SIZE·INCREMENT 뿐이다. · 검색어 RTF, Unit Price, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-70bd83a74d | E4 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | SCP0028 그리드에는 RTF×Unit Price 계산값 컬럼이 없다. · 검색어 Unit Price, UNIT_PRICE, RTF: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a7f6cbf5f3 | G3 | [DMF0020 결함 일반화] Condition(F6) 저장 · Sales Report ETC Insert 기능 | SCP0028 조회조건에는 Period(기간) 조건이 없다. · 검색어 Period, dtpPeriod, periodFrom: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c1feb89f3c | K4 | [DMF0020 결함 일반화] Condition(F6) 저장 · Sales Report ETC Insert 기능 | 이 화면 조회조건은 Division·Model·Operation Group·From/To Site·Trans Mode·Valid 이고 Period 조건은 없습니다. · 검색어 PERIOD, Period, FROM_DATE, TO_DATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1e678a3a05 | E4 | [DMF0044 결함 유형] Cell Prod Site 검증 · Application Gr·Country Name | SCP0028 에는 Cell Prod Site·Application Gr·Country Name 컬럼이 없다. · 검색어 Cell Prod, Application Gr: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-94d750646d | F1 | [DMF0044 결함 유형] Cell Prod Site 검증 · Application Gr·Country Name | SCP0028 에는 Cell Prod Site, Application Gr, Country Name 컬럼이 없다. · 검색어 Cell Prod Site, CELL_PROD_SITE, Application Gr: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fd8a5e6b82 | C1 | [DMF0044 결함 유형] 조회조건 Report Type→Data Type | SCP0028 조회조건에는 Report Type·Data Type 콤보가 없다. · 검색어 REPORT_TYPE, DATA_TYPE, Report Type: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-32fdecef94 | K4 | [DMF0044 결함 유형] Delete 버튼 | Cutoff Data 에 따른 Delete 버튼 비노출 항목이며 AS-IS 소스에 Cutoff 개념이 없습니다. · 검색어 Cutoff, CUTOFF, CUT_OFF: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d33051b5da | J2 | [DMF0044 결함 유형] Delete 버튼 | SCP0028 화면에는 Cutoff Data 에 따라 Delete 버튼을 숨기는 조건이 없다. · 검색어 Cutoff, CUTOFF_YN, Cut Off: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c8912642ed | F1 | [DMF0044 결함 유형] Biz Plan Cutoff Data 저장 값 | SCP0028 에는 Biz Plan Cutoff Data 컬럼이 없다. · 검색어 Biz Plan, Cutoff, CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4cd94d7e36 | D2 | [DMF0044 결함 유형] 입력 가능 Measure(Business Plan·Unit Price(LOC)) | 이 화면에는 Business Plan·Unit Price(LOC) Measure 가 없다. · 검색어 Business Plan, BUSINESS_PLAN, Unit Price(LOC): AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-02b9b29a9b | G5 | [DMF0044 결함 유형] Version 팝업 Div 조건 | SCP0028 에 Version 팝업이 없다. · 검색어 VersionPopup, cboVersion, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e4dfc543bb | E4 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | SCP0028 은 단일 그리드 화면으로 하단 Owner 그리드가 없다. · 검색어 Owner, OWNER_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c0d17591ca | F1 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | 이 화면은 Shipment Lot Size 단일 그리드라서 하단 Owner 그리드와 상단 더블클릭 연동이 없다. · 검색어 Owner, OWNER_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2ca357f85d | C5 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | SCP0028 화면에는 하단 Owner 그리드와 상단 더블클릭 시 하단 조회가 없습니다. · 검색어 Owner, OWNER, DoubleClick: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0b21f4dbea | D1 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | 이 화면에는 Exchange Rate 의 Currency 컬럼이 없다. · 검색어 Exchange Rate, CURRENCY, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ea006e7d34 | E4 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | SCP0028 에는 Exchange Rate·Currency 컬럼이 없다. · 검색어 Exchange Rate, CURRENCY: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-234c6183ab | D6 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | SCP0028에는 Exchange Rate Currency 컬럼이 없다. · 검색어 Exchange Rate, Currency, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b0dd88525a | K4 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | Exchange Rate 화면의 Currency 고정 항목이며 이 화면에는 Currency 컬럼이 없습니다. · 검색어 CURRENCY_CODE, Currency, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-08c47687f8 | G4 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | 이 화면에는 Cust Group 조회조건이 없다. · 검색어 Cust Group, CUST_GROUP: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-554bf575c5 | G1 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | 이 화면 조회조건은 Division·Operation Group·From Site·To Site·Trans Mode·Model·Valid뿐이고 Cust Group 조건이 없다. · 검색어 CUST_GROUP, Cust Group, CustGroup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5fcf467925 | G1 | [DMF0005 결함 유형] Owner 팝업(PKG_COM0000 COM0004/0006) User 조회조건 | 이 화면은 Owner 팝업을 쓰지 않고 Item 팝업(SCM0002_ItembyDivisionPopup)만 연결되어 있다. · 검색어 OwnerPopup, COM0004, COM0006, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-43d8bc1c87 | M2 | [DMF0042 결함 유형] Replace 버튼 팝업 Period·조회 | SCP0028 에는 Replace 버튼과 Period 조회조건이 없고, 팝업 Period 기본값을 메인 그리드 Period 로 맞추는 기능도 없다. · 검색어 btnReplace, Replace Popup, Period: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-21e4cfb3b3 | G5 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | SCP0028 에 Ver.Cutoff 팝업이 없다. · 검색어 Cutoff, VER_CUTOFF, VersionCutoff: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5de46ee5be | G4 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | 이 화면에는 Ver.Cutoff 팝업과 Period·Description·Type 조회조건이 없다. · 검색어 Cutoff, VerCutoff, Ver.Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-436ad2beff | H6 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | SCP0028 화면에는 Ver.Cutoff 팝업이 없다. · 검색어 Cutoff, VerCutoff, Ver.Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fbc1c3b425 | H4 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | SCP0028에는 Ver.Cutoff 팝업과 Period 조회조건이 없다. · 검색어 Cutoff, VerCutoff, Ver.Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fd2d287883 | M3 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SCP0028 에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 Version Create, VersionCreate, BP Version: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cc2514f8cd | M2 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SCP0028 에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 Version Create, BP Version, btnVersionCreate: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8e53fe57c1 | E4 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SCP0028 에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 Version Create, BP Version: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f82ab5b211 | F1 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SCP0028 에는 BP Version 팝업과 Version Create 버튼이 없다. · 검색어 Version Create, BP Version, CUTOFF_VERSION: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-de216c0306 | B3 | [DMF0049 결함 유형] 버전 팝업 Version 목록 정렬 | SCP0028에는 Version 목록을 보여 주는 버전 팝업이 없습니다. · 검색어 VERSION_ID, PLAN_VERSION, VersionPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-13906f0adf | M3 | [DMF0049 결함 유형] 버전 팝업 Version 목록 정렬 | SCP0028 에는 버전 팝업과 Version 목록이 없다. · 검색어 VersionPopup, btnVersion, VERSION_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a876ea6f7b | G4 | [DMF0049 결함 유형] Version 조회조건 선택값 표시 | 이 화면에는 Version 조회조건이 없다. · 검색어 VERSION_ID, cboVersion, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-45d8531a1d | G7 | [DMF0049 결함 유형] Version 조회조건 선택값 표시 | SCP0028 에 Version 조회조건이 없다. · 검색어 cboVersion, VERSION_ID, VersionName: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8fb025d5f9 | I3 | [DMF0014 결함 유형] Team 명칭 데이터 | 이 화면에는 Team 명칭 데이터 컬럼이 없습니다. · 검색어 TEAM_NAME, TEAM_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3936d67825 | B4 | [DMF0014 결함 유형] Team 조회조건 후보 | SCP0028 조회조건에는 Team 조건이 없습니다. · 검색어 DEPT_ID, cboTeam, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f627415513 | J1 | [DMF0014 결함 유형] Team 조회조건 후보 | SCP0028 조회조건에는 Team 콤보가 없다. · 검색어 Team, TEAM_ID, cboTeam: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3f216c868b | G1 | [DMF0020 결함 유형] Biz.Type 조회조건 | 이 화면 조회조건에는 Biz.Type이 없다. · 검색어 BIZ_TYPE, Biz.Type, BizType: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-850738a2a5 | M3 | [DMF0020 결함 유형] Price Batch Input 팝업 Sales Site 조건 | SCP0028 에는 Price Batch Input 팝업과 Sales Site 조건이 없다. · 검색어 Price Batch, PriceBatch, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-df0b709d03 | F4 | [DMF0014 결함 유형] Excel Upload OK·Customs Handbook/Project/Model 검증 | SCP0028에는 Excel Upload 기능과 Customs Handbook·Project 항목이 없다(TO-BE 툴바 upload: false). · 검색어 Customs Handbook, Handbook, ExcelUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fa41a26f9e | E3 | [DMF0014 결함 유형] Excel Upload OK·Customs Handbook/Project/Model 검증 | SCP0028 에는 Excel Upload 기능과 Customs Handbook·Project 컬럼이 없다. · 검색어 Customs Handbook, CUSTOMS_HANDBOOK, ExcelUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cb7f36ae53 | M1 | [DMF0014 결함 유형] Excel Upload 수량 미입력 메시지 | SCP0028 에는 Excel Upload 가 없어 수량 미입력 메시지를 확인할 대상이 없다. · 검색어 ExcelUpload, Excel Upload, btnExcelUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-66ac7d776f | M1 | [DMF0014 결함 일반화] Excel Upload Validation 메시지(Sales Site/Project/Model) | SCP0028 에는 Excel Upload 가 없어 업로드 검증 오류 메시지를 확인할 대상이 없다. · 검색어 ExcelUpload, Excel Upload, btnExcelUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6eb98a3779 | M1 | [DMF0074 결함 유형] Excel Form 양식 헤더 | SCP0028 에는 Excel Form 양식이 없어 2단 헤더 양식을 확인할 대상이 없다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fcb5b0f8d4 | M1 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Validation 메시지 | SCP0028 은 AS-IS 에 Upload 기능이 없고 TO-BE 에서도 upload: false 로 막혀 있어 Excel Upload 기능이 없다. · 검색어 ExcelUpload, Excel Upload, btnExcelUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7d1cbad785 | F1 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Validation 메시지 | SCP0028 에는 Excel Upload 와 Period From/To 컬럼이 없다. · 검색어 Excel Upload, PERIOD_FROM, Period From: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cbc256090e | M1 | [DMF0082 결함 유형] Excel Form 양식 Bucket | SCP0028 에는 Excel Form 양식이 없어 Bucket 을 확인할 대상이 없다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-92ff92ce0e | D1 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | 이 화면에는 ETC 입력의 Team·Measure 컬럼이 없다. · 검색어 Sales AMT, SALES_AMT, MEASURE_CD: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-be1437dd77 | B4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SCP0028 에는 ETC 입력의 Team·Measure 컬럼이 없습니다. · 검색어 Measure, Team, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4103926c5e | E3 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SCP0028 에는 Team·Measure 컬럼과 ETC 입력 기능이 없다. · 검색어 SSPM, Sales AMT, TEAM_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-19b84a523e | D4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SCP0028에는 ETC 입력 Team·Measure 컬럼이 없다. · 검색어 SSPM, Sales AMT, TEAM_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3b01774743 | A1 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | SCP0028 화면에는 Dynamic Query 기능이 없다. · 검색어 Dynamic Query, DYNAMIC_QUERY, KWh: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e47d4466a3 | H4 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | SCP0028은 Shipment Lot Size 기준정보 화면이라 Dynamic Query 기능이 없다. · 검색어 DynamicQuery, Dynamic Query, KWh: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e6a219e61e | F4 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | SCP0028에는 Dynamic Query 기능이 없다. · 검색어 Dynamic Query, DynamicQuery, ESS KWh: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-031cb3deb1 | F8 | [SYS0012 결함 유형] Request 데이터 Reject Reason·Request Date | SCP0028 에는 재요청 데이터와 Reject Reason·Request Date 컬럼이 없다. · 검색어 Reject Reason, REJECT_REASON, Request Date, REQUEST_DATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-750505655d | B4 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SCP0028 조회조건에는 Approval Result 콤보가 없습니다. · 검색어 APPROVAL_RESULT, Approval Result: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e7d2389ee7 | B6 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SCP0028 조회조건에 Approval Result 콤보가 없다. · 검색어 Approval Result, APPROVAL_RESULT, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cfa323faae | I2 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | 이 화면의 조회조건에는 Approval Result 콤보가 없습니다. · 검색어 Approval Result, APPROVAL_RESULT, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2635fdd892 | G4 | [DMF0040 결함 유형] Version 조회조건 크기 | 이 화면에는 Version 조회조건이 없다. · 검색어 VERSION_ID, cboVersion, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8abf72e918 | H5 | [DMF0040 결함 유형] Measure Version(A)/Version(B) 명칭 | SCP0028 화면에는 Version(A)/Version(B) Measure 비교 기능이 없습니다. · 검색어 Version(A), Version(B), VERSION_A: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6172b455f8 | A9 | [DMF0040 결함 유형] Measure Version(A)/Version(B) 명칭 | SCP0028에는 Version(A)·Version(B) Measure가 없습니다. · 검색어 Version(A), VERSION_A, Version(B): AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-dfd3ef131b | H2 | [DMF0040 결함 유형] 실적 구간 배경색 | Shipment Lot Size 그리드에는 실적·계획 기간 구간 컬럼이 없다. · 검색어 Actual, ACTUAL: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-303fb67b83 | K2 | [DMF0042 결함 유형] Column Setting 팝업 Default 버튼 | SCP0028 그리드는 Column Setting 팝업을 켜지 않아 팝업의 Default 버튼이 없다. · 검색어 ColumnSetting, Column Settings, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ca370c0667 | C3 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | SCP0028 화면에는 Sales Site·End Customer 셀이 없습니다. · 검색어 END_CUSTOMER, End Customer, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-87bd4ccaec | D1 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | 이 화면에는 Sales Site·End Customer 셀이 없다. · 검색어 END_CUSTOMER, End Customer, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d24898fd14 | G4 | [DMF0044 결함 유형] Year 조회조건 | 이 화면에는 Year 조회조건이 없다. · 검색어 cboYear, Year: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-41d7086dd8 | G6 | [DMF0044 결함 유형] Year 조회조건 | SCP0028 에 Year 조회조건이 없다. · 검색어 cboYear, PLAN_YEAR, selectedYear: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-00c15b67d0 | A5 | [DMF0044 결함 유형] Measure 항목 구성 | SCP0028 Shipment Lot Size 그리드에는 Measure 항목이 없고 Lot Size·Increment·Active·Container Split 같은 고정 컬럼만 있습니다. · 검색어 Measure, UI_CATEGORY, MEASURE_CD: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b9556dfdb9 | B5 | [DMF0044 결함 유형] Measure 항목 구성 | 이 화면에는 Measure 항목 구성이 없다. · 검색어 MEASURE, UI_CATEGORY, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-21343b3c3f | M3 | [DMF0005 결함 유형] Owner 팝업 사용자 목록 | SCP0028 에는 Owner 팝업과 사용자 목록 조회가 없다. · 검색어 OwnerPopup, SSO_USER, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e0b16e7856 | B4 | [DMF0005 결함 유형] Owner 팝업 사용자 목록 | SCP0028 에는 Owner 팝업이 없습니다. · 검색어 OWNER, Owner, SSO_USER: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a7d9514f6c | D2 | [DMF0021 결함 유형] Partial 주차 편집 구간·실적 구분선 | 이 화면에는 Partial 주차 편집 구간과 실적 구분선이 없다. · 검색어 PARTIAL_WEEK, Partial Week, 실적 구분선: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9fdc53246a | H2 | [DMF0021 결함 유형] Partial 주차 편집 구간·실적 구분선 | 이 화면에는 주차 파셜 구간과 실적 구분선이 없다. · 검색어 PARTIAL_WEEK, 실적 구분선: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-19a640bf7b | A5 | [DMF0003 결함 유형] Measure 컬럼 | SCP0028 그리드는 Lot Size·Increment 등 고정 컬럼으로 구성되고 Measure 컬럼이 없다. · 검색어 Measure, USER_SELECTED_FLAG, MEASURE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6963bfc82c | J1 | [DMF0003 결함 유형] FCST Type 후보 | SCP0028 화면에는 FCST Type 후보가 없다. · 검색어 FCST Type, FCST_TYPE, WS(Free): AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e27c7ba144 | G2 | [DMF0040 결함 유형] End Customer 다중 선택 조회조건 | SCP0028에는 End Customer 조회조건이 없다. · 검색어 End Customer, END_CUSTOMER, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1bd9f88d19 | I3 | [DMF0040 결함 유형] Team 조회조건 vs 결과 컬럼 언어 | 이 화면의 조회조건과 결과 컬럼에는 Team 항목이 없습니다. · 검색어 TEAM_NAME, TEAM_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-11760a7eb8 | K2 | [DMF0040 결함 유형] Column Setting 저장·Default | SCP0028 그리드는 Column Setting 팝업을 켜지 않아 저장 후 탭 유지와 Default 복원을 확인할 팝업이 없다. · 검색어 ColumnSetting, Column Settings, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-23d7627514 | A5 | [DMF0040 결함 유형] Column Setting 저장·Default | SCP0028 에는 Column Setting 저장·Default 기능이 없다. · 검색어 layoutKey, ColumnSetting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3682dd9227 | G4 | [DMF0040 결함 유형] Ver. 조회조건 기본값 | 이 화면에는 Ver. 조회조건이 없다. · 검색어 VERSION_ID, cboVersion, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f453587cb5 | G6 | [DMF0040 결함 유형] Ver. 조회조건 기본값 | SCP0028 에 Ver. 조회조건이 없다. · 검색어 cboVersion, VERSION_ID, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1e8814536a | G1 | [DMF0040 결함 유형] Plant Site 조회조건 | 이 화면 조회조건에는 Plant Site가 없고, From Site·To Site만 있다. · 검색어 PLANT_SITE, Plant Site, cboPlantSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-76435a7633 | K2 | [DMF0040 결함 유형] Measure Setting 버튼 | SCP0028 화면의 버튼은 SEARCH·RESET·SAVE·INSERT·DELETE·EXCEL·INPUT·ITEMID 뿐이고 Measure Setting 버튼은 없다. · 검색어 Measure Setting, MeasureSetting, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2881e600d5 | J2 | [DMF0040 결함 유형] Measure Setting 버튼 | SCP0028 화면에는 Measure Setting 버튼이 없다. · 검색어 Measure Setting, btnMeasureSetting, MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-be46ace9c2 | G4 | [DMF0040 결함 유형] Plant Site 조회조건 | 이 화면에는 Plant Site 조회조건이 없고 From Site·To Site 조회조건만 있다. · 검색어 Plant Site, PLANT_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5cbd7938df | A5 | [DMF0053 결함 일반화] Column Setting 필수 컬럼 표시·Div 전환 End Customer | SCP0028 에는 컬럼셋팅 팝업이 없어 필수 컬럼을 빨간색으로 표시하는지 확인할 대상이 없다. · 검색어 USER_SELECTED_FLAG, layoutKey, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f4fed4df04 | B4 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | SCP0028 에는 Biz Type 조회조건이 없습니다. · 검색어 BIZ_TYPE, Biz Type: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3b8df87f8e | G1 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | 이 화면 조회조건에는 Biz Type·Plant Site가 없다. · 검색어 BIZ_TYPE, Biz Type, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d2f55b1fe2 | M3 | [DMF0053 결함 유형] 팝업 Filter 텍스트 입력창 | SCP0028 팝업에는 Filter 텍스트 입력창이 없고, 조회조건은 Div·From Site·To Site·Model/Nickname·Operation Group 이다. · 검색어 txtFilter, FilterText: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a268d165d3 | D2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | 이 화면에는 Current 버전 입력 Measure 와 AS From Site 콤보가 없다. · 검색어 AS_In_Req, VMI_In_Req, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-89c4e20207 | J3 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0028 화면에는 Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)가 없다. · 검색어 AS_In_Req, VMI_In_Req, MKT_FCST, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4705ef2a1d | D3 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0028에는 입력 Measure와 AS From Site 콤보가 없다. · 검색어 GET_ADMIN_GROUP_MEASURE, SCM_FCST, AS From Site, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e85b882746 | B5 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | 이 화면에는 Current 버전 입력 Measure와 AS From Site 콤보가 없다. · 검색어 MKT_FCST, SCM_FCST, AS_In_Req, VMI_In_Req: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2ed591120e | B4 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | 이 화면에는 Current 버전 입력 Measure와 AS From Site 콤보가 없다. · 검색어 MKT_FCST, SCM_FCST, AS_In_Req, VMI_In_Req: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ef4f1d511f | C2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0028 에는 Measure 입력과 AS From Site 콤보가 없다. · 검색어 MKT_FCST, AS_IN_REQ, AS_FROM_SITE, MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-510cf4ddb0 | B4 | [DMF0082 결함 유형] FCST Type 후보 | SCP0028 에는 FCST Type 후보가 없습니다. · 검색어 FCST_TYPE, SALES_TYPE_CODE, FCST Type: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-674906a770 | N1 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site ID | SCP0028에는 MKT_FCST와 Unit Price(LOC)의 조건부 필수 입력이 없고 Plant Site ID 컬럼도 없다. · 검색어 MKT_FCST, Unit Price, PLANT_SITE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-22a44d9bb3 | F1 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site ID | SCP0028 에는 MKT_FCST, Unit Price(LOC) 조건부 필수, Plant Site ID 컬럼이 없다. · 검색어 MKT_FCST, PLANT_SITE_ID, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9422889079 | F4 | [DMF0082 결함 유형] Bucket 전환 후 저장 | SCP0028에는 Bucket 전환 기능이 없다(AS-IS·TO-BE 모두 Bucket 0건). · 검색어 Bucket, btnBucket: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-235ea3c0d5 | M3 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SCP0028 에는 Exchange Rate 팝업이 없어 Close 후 다시 열 때의 동작을 확인할 대상이 없다. · 검색어 Exchange Rate, ExchangeRate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-869ebd2f59 | F2 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | 이 화면에는 Exchange Rate 팝업이 없다. · 검색어 Exchange Rate, EXCHANGE_RATE, BPS: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8695fd187b | M2 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SCP0028 의 AS-IS 소스와 TO-BE 화면 폴더에는 Exchange Rate 팝업도 BPS I/F 버튼도 없다. · 검색어 Exchange Rate, ExchangeRate, BPS I/F: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4dbae579a8 | M4 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SCP0028 에는 Exchange Rate 팝업과 BPS I/F 기능이 없다. · 검색어 Exchange Rate, EXCHANGE_RATE, BPS: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-418a718626 | D2 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | 이 화면에는 RTF[R+P] Measure 와 Cutoff 상태에 따른 편집 조건이 없다. · 검색어 RTF[R+P], CUTOFF_STATUS, Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d515c00434 | J3 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | SCP0028 화면에는 RTF[R+P] 편집 조건과 Cutoff 상태가 없다. · 검색어 RTF[R+P], GET_ADMIN_GROUP_MEASURE, CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8be25aad9e | E4 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | SCP0028 에는 RTF[R+P] 컬럼과 Cutoff 기준 편집 조건이 없다. · 검색어 Cutoff, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a115fc3fc0 | E4 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SCP0028 에는 FCST Type·ETC Text 컬럼이 없다. · 검색어 FCST Type, FCST_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c9470e7203 | F1 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SCP0028 에는 FCST Type 과 Text 컬럼, ETC 테이블 저장 기능이 없다. · 검색어 FCST Type, FCST_TYPE, ETC_TEXT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7dc387181e | D1 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | 이 화면에는 Sales Site·Project 팝업·Team 컬럼이 없다. · 검색어 SALES_PLAN_ITEM_ID, SSPM, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-476e945c09 | C3 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0028 화면에는 Sales Site·Project 팝업·Team 컬럼이 없고, 그리드 컬럼은 Div·From Site·To Site·Model·Lot Size 등입니다. · 검색어 SALES_PLAN_ITEM_ID, SSPM, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-660ae8f990 | B5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | 이 화면의 신규 행에는 Sales Site·Project 팝업·Team 컬럼이 없고 Model 후보를 SALES_PLAN_ITEM_ID 룩업에서 가져오지 않는다. · 검색어 SALES_PLAN_ITEM_ID, SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-abe059a127 | M3 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0028 그리드에는 Sales Site·Project·Team 컬럼이 없고, Model 후보 룩업 SALES_PLAN_ITEM_ID 도 없다. · 검색어 Sales Site, SALES_PLAN_ITEM_ID, SSPM, TeamPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-464a8dbf6e | G5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0028 그리드에 Sales Site·Project·Team 컬럼이 없다. · 검색어 SALES_PLAN_ITEM_ID, ProjectPopup, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f3e1e1cc9a | A5 | [DMF0021 결함 일반화] Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | SCP0028 메인 그리드(ShipmentLotSizeGrid)는 DataGrid 에 layoutKey 를 넘기지 않아 Column Settings 팝업이 없고, AS-IS 에도 컬럼셋팅 기능이 없어 OK 반영 확인 대상이 없다. · 검색어 layoutKey, ColumnSetting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-46acf2c50f | K2 | [DMF0021 결함 일반화] Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | SCP0028 그리드에는 컬럼셋팅 팝업이 없어 OK 후 그리드 컬럼을 다시 구성하는 동작을 확인할 수 없다. · 검색어 ColumnSetting, Column Settings, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d66c04825c | D3 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0028에는 AS From Site 활성 제어와 Measure 후보가 없다. · 검색어 AS From Site, AS_FROM_SITE, SCM_FCST, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-56c31397f5 | C2 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0028 에는 AS From Site 입력과 Measure 후보가 없다. · 검색어 AS_FROM_SITE, AS From Site, MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a433a52e22 | B4 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0028 에는 AS From Site 와 Measure 후보가 없습니다. · 검색어 AS_FROM_SITE, AS From Site, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-500b8b14d5 | B5 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | 이 화면에는 AS From Site 컬럼과 Measure 후보가 없다. · 검색어 AS_FROM_SITE, AS From Site, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-39fbd00363 | J3 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0028 화면에는 AS From Site 콤보와 Measure 후보가 없다. · 검색어 AS From Site, AS_FROM_SITE, SALES_SITE_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-aa552dcfa0 | B4 | [DMF0082 결함 유형] End Customer 셀 콤보 후보 | SCP0028 그리드에는 End Customer 셀 콤보가 없습니다. · 검색어 END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-69a6377f59 | B5 | [DMF0082 결함 유형] End Customer 셀 콤보 후보 | 이 화면의 그리드에는 End Customer 셀 콤보가 없다. · 검색어 END_CUSTOMER, End Customer, endCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c54a1d7e22 | M3 | [DMF0082 결함 유형] Excel Form 팝업 Search | SCP0028 에는 Excel 다운로드 버튼(BTN:EXCEL)만 있고 Excel Form 팝업은 없다. · 검색어 Excel Form, ExcelForm, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6f5311f789 | M1 | [DMF0082 결함 유형] Excel Form 팝업 Search | SCP0028 에는 Excel Form 팝업이 없다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e5407f26b4 | K2 | [DMF0082 결함 일반화] 컬럼·메저 셋팅 Save/OK 재조회 | SCP0028 그리드는 컬럼·메저 셋팅 팝업을 켜지 않아 변경 없이 Save/OK 했을 때 재조회 여부를 확인할 팝업이 없다. · 검색어 ColumnSetting, Column Settings, MeasureSetting, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-84b52ec567 | B4 | [DMF0082 결함 유형] Customs Handbook 콤보 후보 | SCP0028 에는 Customs Handbook 콤보가 없습니다. · 검색어 CUSTOMS_HANDBOOK, Customs Handbook: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9b55910f78 | B4 | [DMF0005 결함 유형] Team 조회조건 후보 | SCP0028 조회조건에는 Team 조건이 없습니다. · 검색어 DEPT_ID, cboTeam, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4c1efaecb7 | B7 | [DMF0005 결함 유형] Team 조회조건 후보 | SCP0028 조회조건에 Team이 없다. · 검색어 DEPT_ID, Team, cboTeam: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-77aa30a231 | B4 | [DMF0035 결함 유형] Version 조회조건 | SCP0028 조회조건에는 Version 조건이 없습니다. · 검색어 cboVersion, VERSION_ID, PLAN_VERSION: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ca92e880dc | M3 | [DMF0035 결함 유형] Version 조회조건 | SCP0028 조회조건은 Division·Operation Group·From Site·To Site·Model·Trans Mode·Valid 이고, Version 조건은 없다. · 검색어 cboVersion, txtVersion, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-874818ea95 | F1 | [DMF0082 결함 유형] Unit Price(LOC) 저장 | SCP0028 에는 Unit Price(LOC) 컬럼이 없고, AS-IS 소스와 TO-BE 화면 폴더 모두에서 해당 식별자가 나오지 않는다. · 검색어 Unit Price, UNIT_PRICE, Price(LOC): AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-df802e58f0 | E4 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SCP0028 에는 RTF 저장과 Sales Plan Waterfall 동기화가 없다. · 검색어 Waterfall, RTF: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-eb51d2c89b | F1 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SCP0028 에는 RTF 저장과 Sales Plan Waterfall 동기화 기능이 없다. · 검색어 Waterfall, Sales Plan, RTF_QTY: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c69748482b | F7 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SCP0028 저장은 SCP_MST_SHIPMENT_LOT_SIZE 와 이력 표만 바꾸고 RTF 판가 검증이나 Sales Plan Waterfall 연동은 없다. · 검색어 RTF, Waterfall, Sales Price: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1f167cd842 | G4 | [DMF0035 결함 유형] Plan Type 조회조건 위치 | 이 화면에는 Plan Type 조회조건이 없다. · 검색어 Plan Type, PLAN_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e0bee7270d | H6 | [DMF0005 결함 유형] Team 팝업 조건(Team ID/Team Name) | SCP0028 화면에는 Team 팝업과 Team ID/Team Name 조건이 없다. · 검색어 TeamPopup, TEAM_ID, Team Name: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7e721cbd52 | B4 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | SCP0028 그리드에는 Sales Plant 셀 콤보가 없습니다. · 검색어 SALES_PLANT, Sales Plant, SCM_MST_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ad6179bcf1 | N1 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | SCP0028에는 Sales Plant 셀 콤보와 SCM_MST_PLANT 후보 조회가 없다. · 검색어 Sales Plant, SCM_MST_PLANT, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-10c1eed8b2 | A5 | [DMF0021 결함 일반화] 컬럼셋팅 Company ID(필수 표시·Invisible 이동) | SCP0028 에는 컬럼셋팅 Invisible 영역과 Company ID 컬럼이 없다. · 검색어 COMPANY_ID, Invisible, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f4623b6fd3 | K2 | [DMF0035 결함 유형] Measure 명칭 MKT FCST[R+P] | SCP0028 화면은 Shipment Lot Size 마스터 화면이라 Measure 와 MKT FCST[R+P] 명칭이 없다. · 검색어 MKT FCST, Measure, MeasureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f1e6953c70 | H5 | [DMF0035 결함 유형] Measure 명칭 MKT FCST[R+P] | SCP0028 Shipment Lot Size 화면에는 Measure 명칭(MKT FCST[R+P])을 표시하는 조회 기능이 없습니다. · 검색어 MKT FCST, Measure, MEASURE_CD: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6b21a79dfd | H8 | [SYS0012 결함 유형] Request Date 컬럼 | SCP0028 화면에는 Request Date 컬럼이 없고 날짜 컬럼은 Creation Date·Last Update Date 뿐이다. · 검색어 REQUEST_DATE, Request Date, REQ_DATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-982274e726 | D1 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | 이 화면에는 Dept 컬럼과 Use Y/N 헤더가 없다. · 검색어 DEPT_ID, DEPT_NAME, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-55a091f6ae | C3 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0028 화면에는 Dept 컬럼과 Use Y/N 헤더가 없습니다. · 검색어 DEPT_ID, Dept, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8f2febd8ee | H5 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0028 그리드에는 Dept 컬럼과 Use Y/N 헤더가 없습니다. · 검색어 Dept, DEPT_ID, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-889f4e7c89 | F1 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0028 에는 Dept 컬럼, SSO DEPT 자동 세팅, Use Y/N 헤더가 없다. · 검색어 DEPT_ID, DEPT_NAME, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-12f0bd0dc2 | A5 | [SYS0014 결함 유형] Email 컬럼 | SCP0028 그리드에는 Email 컬럼이 없다. · 검색어 EMAIL, E-mail: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8375ff9e32 | M3 | [SYS0014 결함 유형] User 팝업(User Info) | SCP0028 에는 User 팝업이 없다. · 검색어 UserPopup, SCM_ADM_USER_M, User Info: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c8b9392c1d | F1 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | SCP0028 에는 JV Planner 용 Division 시트가 없고, Div 는 메인 그리드의 컬럼이다. · 검색어 JV Planner, JV_PLANNER, Division Sheet: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-aaa1f10bb3 | F6 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | SCP0028 에는 JV Planner 용 Division 시트가 없다. · 검색어 JV Planner, JV_PLANNER, Division Sheet: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-514885a689 | B4 | [SYS0010 결함 유형] System 컬럼 입력 방식 | 이 화면의 그리드에는 System 컬럼이 없다. · 검색어 SYSTEM_CODE, SYSTEM_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5f142f601d | A5 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | SCP0028 에는 메뉴 URL·ROUTE_PATH 입력 컬럼이 없다. · 검색어 MENU_URL, PROGRAM_URL, routePath: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-43736623b6 | F1 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | SCP0028 그리드에는 URL·ROUTE_PATH 입력 컬럼이 없다(TO-BE 상수 주석의 ROUTE_PATH 는 메뉴 경로 설명이다). · 검색어 URL-ROUTE_PATH, Route Path, RoutePath: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-74425a62fa | B6 | [SYS0005 결함 유형] Schema 조회조건 | SCP0028 조회조건에 Schema가 없다. · 검색어 SCHEMA_NAME, cboSchema, lblSchema: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-748659e358 | G2 | [SYS0005 결함 유형] Schema 조회조건 | SCP0028에는 Schema 조회조건이 없다. · 검색어 Schema, SCHEMA, cboSchema: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-06fdee55e8 | G1 | [SYS0005 결함 유형] Schema 조회조건 | 이 화면 조회조건에는 Schema가 없다. · 검색어 SCHEMA_NAME, Schema, cboSchema: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5db5eb7f4a | B6 | [SYS0006 결함 유형] API Type 조회조건 | SCP0028 조회조건에 API Type이 없다. · 검색어 API Type, API_TYPE, cboApiType: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-84cf83dc8e | B4 | [SYS0006 결함 유형] API Type 조회조건 | 이 화면의 조회조건에는 API Type이 없다. · 검색어 API_TYPE, API Type: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-37eb5bdd46 | B1 | [SYS0006 결함 유형] API Type 조회조건 | SCP0028 조회조건에는 API Type이 없습니다. · 검색어 API_TYPE, API Type: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c2b9ea975a | B4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0028 에는 Module·Sub Module 조회조건과 Notice Content 가 없습니다. · 검색어 SUB_MODULE, Sub Module, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-938e648cf4 | B6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0028에는 Module 조회조건, Insert Module 콤보, Notice Content가 없다. · 검색어 Notice Content, NOTICE, Sub Module: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-bee58ed879 | G4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | 이 화면에는 Module·Sub Module 조회조건과 Notice Content 가 없다. · 검색어 Sub Module, SUB_MODULE, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-951ec99b86 | H5 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0028 화면에는 Module·Sub Module 조회조건과 Notice Content 입력이 없습니다. · 검색어 Sub Module, Notice Content, NOTICE_CONTENT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3d141b391b | D4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0028에는 Module·Sub Module 조회조건과 Notice Content가 없다. · 검색어 Sub Module, Notice Content, MODULE_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-dd2222fa57 | H6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0028 화면에는 Module·Sub Module 조회조건과 Notice Content가 없다. · 검색어 Sub Module, SUB_MODULE, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0275576f47 | K5 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SYS0016 의 Module·Sub Module·Notice Content 항목이며 이 화면에는 해당 조건과 필드가 없습니다. · 검색어 Sub Module, Notice Content, MODULE_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-648679b0fe | B6 | [SYS0017 결함 유형] Module / Sub Module 조회조건 | SCP0028 조회조건은 Division·Operation Group·From Site·To Site·Model·Valid·Trans Mode이고 Module·Sub Module 조회조건이 없다. · 검색어 Sub Module, SUB_MODULE, MODULE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-eef93b96a0 | G4 | [SYS0017 결함 유형] Module / Sub Module 조회조건 | 이 화면에는 Module·Sub Module 조회조건이 없다. · 검색어 Sub Module, SUB_MODULE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7038bc805a | B4 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SCP0028 그리드에는 Sales Company·Sales Plant 콤보가 없습니다. · 검색어 SALES_COMPANY, Sales Company, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-dd3cc6684f | C2 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SCP0028 그리드에는 Sales Company·Sales Plant 콤보 셀이 없다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Company: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-30b5f61e3e | F2 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | 이 화면 그리드에는 Sales Company·Sales Plant 콤보가 없다. · 검색어 Sales Company, Sales Plant, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-58165142fe | F1 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | 이 화면 그리드에는 Sales Company·Sales Plant 콤보가 없다. · 검색어 Sales Company, Sales Plant, SALES_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d39825d277 | H6 | [DMF0005 결함 유형] Project 팝업(그리드) | SCP0028 화면에는 Project 팝업이 없고 Model 팝업 호출 시 sProject 는 빈 값으로만 넘긴다. · 검색어 ProjectPopup, ProjectModal, Project Popup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-480bcb606b | M3 | [DMF0005 결함 유형] Project 팝업(그리드) | SCP0028 에는 Project 팝업이 없고, Model 팝업 호출 때 sProject 를 빈 값으로 넘기기만 한다. · 검색어 ProjectPopup, btnProject, Project 팝업: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-843cfff50a | G2 | [DMF0005 결함 유형] Project 팝업(그리드) | SCP0028에는 Project 팝업이 없고 Model 옆 Item 팝업만 있다. · 검색어 ProjectPopup, Project Popup, PROJECT_CODE, PROJECT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e63a949b70 | B3 | [SYS0010 결함 유형] 메인화면 System admin 정보(SYSTEM_ADM Lookup) | SCP0028에는 메인화면의 System admin 정보(SYSTEM_ADM Lookup)가 없습니다. · 검색어 SYSTEM_ADM, System admin: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7ff5b1febb | E4 | [DMF0004 결함 유형] Customer 탭 Sold to/Ship to 저장 검증 | SCP0028 에는 Customer 탭 Sold to·Ship to 컬럼이 없다. · 검색어 Sold to, Ship to, NERP_CONV: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8f2e6b38aa | E3 | [DMF0005 결함 유형] Project 컬럼 필수 검증 | SCP0028 그리드에는 Project 컬럼이 없다. · 검색어 PROJECT_CODE, PROJECT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c2e64bdf98 | E4 | [DMF0005 결함 유형] Project 컬럼 필수 검증 | SCP0028 그리드에는 Project 컬럼이 없다. · 검색어 PROJECT_ID, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-39fe4b0d7a | B7 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SCP0028 그리드에 Team(DEPT_ID) 컬럼이 없다. · 검색어 DEPT_ID, DEPT_NAME, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d82a2caca4 | A2 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SCP0028 화면에는 Team(DEPT_ID) 셀 콤보가 없다. · 검색어 DEPT_ID, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3399460d64 | B4 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SCP0028 그리드에는 Team(DEPT_ID) 셀 콤보가 없습니다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8cc81c357e | B7 | [DMF0003 결함 유형] Team 정보(DEPT_ID) | SCP0028에 Team(DEPT_ID) 정보가 없다. · 검색어 DEPT_ID, DEPT_NAME, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-076156b627 | A1 | [DMF0003 결함 유형] Team 정보(DEPT_ID) | SCP0028 화면에는 Team(DEPT_ID) 컬럼이 없다. · 검색어 DEPT_ID, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-60f82fde7b | F7 | [DMF0020 결함 유형] Unit Price(LOC) → Sales Price 연동 | SCP0028 에는 Unit Price(LOC) 입력이나 Sales Price 연동이 없다. · 검색어 Unit Price, UNIT_PRICE, Sales Price, SALES_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f1267e7d40 | F1 | [DMF0020 결함 유형] Unit Price(LOC) → Sales Price 연동 | SCP0028 에는 Unit Price(LOC) 와 Sales Price 연동 기능이 없다. · 검색어 Sales Price, SALES_PRICE, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1590397c6e | B5 | [SYS0012 결함 유형] 권한 신청 가능 Group 목록 | 이 화면에는 권한 신청 Group 목록이 없다. · 검색어 REQ_NO_DISPLAY, Request Group: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-79a5ce1eaa | C5 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | SCP0028 화면에는 Mail Setup 탭과 사용자 좌/우 그리드가 없습니다. · 검색어 Mail Setup, Mail: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c379852bd3 | F1 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | 이 화면에는 Mail Setup 탭과 사용자 좌/우 그리드가 없다. · 검색어 Mail Setup, MAIL_USER, mailSetup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5a2ce2e578 | F5 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | SCP0028에는 Mail Setup 탭과 좌/우 사용자 그리드가 없다. · 검색어 Mail Setup, Mail: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1d8f92f081 | A3 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | SCP0028 화면에는 Sum 행 라벨과 Sum/Qty≠0 체크박스가 없다. · 검색어 Sum/Qty, SUM_ROW, Subtotal: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1afe680702 | H5 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | SCP0028 그리드에는 Sum 행과 Sum·Qty≠0 체크박스가 없습니다. · 검색어 Sum/Qty, Qty≠0, chkSum: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2748aa5204 | G4 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | 이 화면에는 Sum 행과 Sum·Qty≠0 체크박스가 없다. · 검색어 chkSum, Sum/Qty: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a9a478ef6b | A5 | [DMF0035 결함 유형] Version 컬럼 | SCP0028 그리드에는 Version 컬럼이 없다. · 검색어 VERSION_ID, PLAN_VERSION: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-52d21b1b2d | A1 | [DMF0082 결함 유형] RTF[R+P] Measure 행 | SCP0028 화면에는 RTF Measure 행이 없고, 그리드는 Shipment Lot Size 컬럼만으로 되어 있다. · 검색어 RTF[R+P], MEASURE_ID, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-415cff7fa1 | F7 | [DMF0021 결함 유형] RTF[R+P] → DM_PLN_MKT_FCST / DM_PLN_MKT_FCST_C 연동 | SCP0028 저장 SP 는 DM_PLN_MKT_FCST 표에 쓰지 않는다. · 검색어 DM_PLN_MKT_FCST, RTF, Waterfall: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-75e0dc7f89 | F1 | [DMF0021 결함 유형] RTF[R+P] → DM_PLN_MKT_FCST / DM_PLN_MKT_FCST_C 연동 | SCP0028 에는 RTF[R+P] 와 DM_PLN_MKT_FCST 연동 기능이 없다. · 검색어 DM_PLN_MKT_FCST, Demand Plan Waterfall, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-139cc1adcb | A1 | [SCP0006 결함 유형] BOM Explosion Plant Assign(MCCH125020A1/MACH125020A1) | SCP0028 화면에는 BOM Explosion Plant Assign 기능이 없다. · 검색어 Plant Assign, BOM Explosion, PLANT_ASSIGN: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3632bb1cc2 | N1 | [SCP0006 결함 유형] BOM Explosion Plant Assign(MCCH125020A1/MACH125020A1) | SCP0028에는 BOM Explosion이나 Plant Assign 기능이 없다. · 검색어 BOM Explosion, Plant Assign, BOM_EXPLOSION: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5db3fea811 | D3 | [SCP0006 결함 유형] Plant Assign 그리드 색상 | SCP0028에는 Plant Assign 그리드와 CA1 행 색상 처리가 없다. · 검색어 CA1, Plant Assign, PLANT_ASSIGN: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a859aad9ff | H2 | [SCP0006 결함 유형] Plant Assign 그리드 색상 | 이 화면에는 Plant Assign 그리드와 CA1 행이 없다. · 검색어 Plant Assign, PLANT_ASSIGN, CA1: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1071c18629 | G5 | [SCP0006 결함 유형] Capa New Model 팝업 조건(Group/Plant) | SCP0028 에 Capa New Model 팝업이 없다. · 검색어 CapaNewModel, NewModelPopup, PLANT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c47c01aea7 | M3 | [SCP0006 결함 유형] Capa New Model 팝업 조건(Group/Plant) | SCP0028 에는 Capa New Model 팝업과 Group/Plant 조건이 없다. · 검색어 Capa New Model, CapaNewModel, NewModel: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f12b612887 | I1 | [SCP0007 결함 유형] Route 검색 팝업 제목 | 이 화면의 팝업은 Item 팝업과 SCM0002 일괄입력·삭제 팝업뿐이고 Route 검색 팝업은 없습니다. · 검색어 RouteSearchPopup, Route Search, Route 검색: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-da0483e429 | H6 | [SCP0007 결함 유형] Route 검색 팝업 제목 | SCP0028 화면에는 Route 검색 팝업이 없다. · 검색어 RoutePopup, Route Search, ROUTE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-edbeb5560e | H5 | [SCP0007 결함 유형] Route 검색 팝업 제목 | SCP0028 화면에는 Route 검색 팝업이 없고 팝업은 ItemByDivisionPopup·ShipmentLotSizePopup만 있습니다. · 검색어 RoutePopup, Route Search, ROUTE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-790452387d | D4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SCP0028에는 To Site 선택 시 City를 매핑하는 기능이 없고, Insert(InsertRow)도 빈 구현이라 신규 행이 생기지 않는다. · 검색어 City, CITY_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7d23485031 | B4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SCP0028 에는 Insert 행의 To Site 셀 콤보와 City 매핑이 없습니다. · 검색어 CITY, City: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-760603e3a0 | C3 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SCP0028의 Insert 버튼은 AS-IS InsertRow()가 빈 구현이라 동작하지 않고, To Site 컬럼은 표시 전용이며 City 컬럼이 없습니다. · 검색어 CITY_ID, CITY_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-27e4b23d1b | F1 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SCP0028 에는 City 컬럼이 없고, 툴바 Insert 는 AS-IS InsertRow 가 비어 있어 동작하지 않는다. · 검색어 CITY_NAME, City Name, CITY_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1edbd6c91e | E2 | [SCP0007 결함 유형] Period 날짜 | SCP0028 에는 사용자가 입력하는 Period 날짜 칸이 없고 날짜 컬럼은 Creation Date·Last Update Date 시스템 컬럼뿐이다. · 검색어 Period, PERIOD, FROM_DATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8c9b58122b | C4 | [DMF0082 결함 일반화] 그리드 Measure 필터(MEASURE Filter) × Division(DIVISION_ID) 변경 재조회 · 건수 표시 | SCP0028 그리드에는 Measure 컬럼과 Measure 필터가 없습니다. · 검색어 MEASURE, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-482945d23b | C3 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME·PROJECT_STATUS·PROJECT_OWNER·BIZ_TYPE) · Model 팝업(ITEM_ID → | SCP0028 화면의 신규 행에는 Project·Model·Sales Site 팝업 자동 채움이 없고, 행은 Input 팝업 후보로만 들어옵니다. · 검색어 PROJECT_STATUS, VMI_STD_DIO, PROJECT_OWNER: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-091d38e885 | M4 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME·PROJECT_STATUS·PROJECT_OWNER·BIZ_TYPE) · Model 팝업(ITEM_ID → | SCP0028 에는 신규 행에서 여는 Project 팝업·Sales Site 팝업과 그에 따른 PROJECT_NAME·VMI_YN 자동 채움이 없다. · 검색어 PROJECT_CODE, SCM_SITE_ID, VMI_YN: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-314f550ef1 | M1 | [DMF0014 결함 일반화] 공용 업로드 창(Upload) 검증 완료 후 저장 전 Cancel · X 닫기 확인창 MSG00684 「취소하시겠습니까?」(AS-IS MSG00195) | SCP0028 은 공용 Excel Upload 창을 쓰지 않아 Cancel·X 닫기 확인창을 확인할 대상이 없다. · 검색어 ExcelUpload, Excel Upload, btnExcelUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8453e701e2 | B5 | [DMF0021 결함 일반화] Measure 설정 팝업(Measure Setting) 후보 · Column 설정 후보 — Division 기준 재조회 | 이 화면에는 Measure Setting 팝업과 Column 설정 목록이 없다. · 검색어 Measure Setting, MEASURE, Column Setting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-11eca584da | K2 | [DMF0021 결함 일반화] Measure 설정 팝업(Measure Setting) 후보 · Column 설정 후보 — Division 기준 재조회 | SCP0028 화면에는 Measure Setting 팝업과 Column Setting 팝업이 없고, 그리드 컬럼은 staticColumns 로 고정되어 있어 Division 기준 재조회 대상이 없다. · 검색어 Measure, MeasureSetting, Measure Setting, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-15c01891ab | B3 | [DMF0048 결함 일반화] 조회조건 Team(DEPT_ID)·End Customer(END_CUSTOMER)·Sales Site(SCM_SITE_ID)·Plant Site 콤보 후보 정렬 = 표시명 순(숫자-영문 | SCP0028 조회조건은 Division·Operation Group·Trans Mode·Valid·From Site·To Site이고, Team·End Customer·Sales Site·Plant Site 조회조건은 없습니다. · 검색어 DEPT_ID, END_CUSTOMER, SCM_SITE_ID, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-10b1d224d3 | B4 | [DMF0053 결함 일반화] 조회조건 Filter 콤보 6종(FilterMyDivision·FilterTeambyDivision·FilterEndCustomerByDivision·FilterBizType·Filte | AS-IS 소스와 TO-BE 화면 폴더에서 Filter 콤보 6종을 쓰는 곳이 확인되지 않는다. · 검색어 FilterMyDivision, FilterTeambyDivision, FilterEndCustomerByDivision, FilterFromSiteByDivision: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-bb7fa83a6d | M1 | [DMF0074 결함 일반화] 공용 Excel Upload 창 2단계 — Upload(검사 · 분류) → OK(저장) · 오류 1건 이상이면 저장 차단 MSG00657 | SCP0028 은 공용 Excel Upload 창을 쓰지 않는다(TO-BE upload: false). · 검색어 ExcelUpload, Excel Upload, btnExcelUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-62b5d6fff7 | I2 | [DMF0043_01 결함 일반화] Version 팝업 미선택 OK 안내 — 다국어 코드 MSG00701(AS-IS MSG00279) 「버전은 1개만 선택해 주세요.」/「Please select only one ve | 이 화면에는 Version 선택 팝업이 없어 Version 미선택 OK 안내도 없습니다. · 검색어 VersionPopup, select only one version, 버전은 1개만: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c96370a672 | A2 | [결함 유형 묶음 A2-G02 · 2건] Category 코드 컬럼(CATEGORY_ID) 숨김 | SCP0028 그리드에는 Category 코드 컬럼(CATEGORY_ID)이 없다. · 검색어 CATEGORY_ID, CATEGORY_DESC: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ca29cb80f6 | A5 | [결함 유형 묶음 A5-G01 · 2건] Main 그리드 Sub Module 컬럼(SUB_MODULE_CODE) | SCP0028 메인 그리드에는 Sub Module 컬럼(SUB_MODULE_CODE)이 없다. · 검색어 SUB_MODULE_CODE, Sub Module: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6a1336e3d4 | A5 | [결함 유형 묶음 A5-G02 · 2건] Category 코드 컬럼(CATEGORY_ID) 숨김 | SCP0028 그리드에는 Category 컬럼(CATEGORY_ID·CATEGORY_DESC)이 없다. · 검색어 CATEGORY_ID, CATEGORY_DESC: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e8c5385ae2 | A5 | [결함 유형 묶음 A5-G03 · 2건] 조회 그리드 컬럼 구성 = 컬럼셋팅 설정 | SCP0028 에는 컬럼셋팅 설정과 COL_LIST 컬럼이 없다. · 검색어 COL_LIST, layoutKey, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-22d7cee677 | A5 | [결함 유형 묶음 A5-G07 · 2건] Div별 Project 계열 제외 컬럼 비노출 | SCP0028 그리드에는 Project Name·Project Status·Owner·Department 컬럼이 없다. · 검색어 PROJECT_NAME, PROJECT_STATUS, Project Status: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-39e00cc4d3 | A5 | [결함 유형 묶음 A5-G08 · 2건] Plan Type별 제외 컬럼(Cust Group Dtl 등) | SCP0028 에는 Plan Type 조건과 Cust Group Dtl 컬럼이 없다. · 검색어 PLAN_TYPE, Cust Group Dtl, CUST_GROUP: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8d6da6dff4 | A5 | [결함 유형 묶음 A5-G09 · 2건] Div 40 Report 컬럼 표시 | SCP0028 에는 Cell Prod. Site (S&OP Report)·Sold-to Cust(Report) 컬럼이 없다. · 검색어 Cell Prod, Sold-to, S&OP Report: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-bcc825d014 | B1 | [결함 유형 묶음 B1-G01 · 3건] 그리드 End Customer 콤보 후보 목록 | SCP0028 그리드에는 End Customer 콤보 컬럼이 없습니다. · 검색어 END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6c0617699d | B2 | [결함 유형 묶음 B2-G01 · 3건] 그리드 End Customer 콤보 후보 목록 | SCP0028 그리드에는 End Customer 컬럼이 없습니다. · 검색어 END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-59d1e8224e | B3 | [결함 유형 묶음 B3-G01 · 3건] 그리드 셀 콤보(End Customer·Sold-to Customer) 후보 | SCP0028 그리드에는 End Customer·Sold-to Customer 셀 콤보가 없습니다. · 검색어 END_CUSTOMER, SOLD_TO_CUSTOMER, Sold-to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7fb9a99a1f | B4 | [결함 유형 묶음 B4-G01 · 3건] 저장 · Sales Site 조회조건 콤보 | 이 화면에는 Sales Site 저장 기능과 Sales Site 조회조건 콤보가 없다. · 검색어 SALES_SITE, Sales Site, salesSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-709953c46b | B5 | [결함 유형 묶음 B5-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | 이 화면의 신규 행에는 Measure 콤보가 없다. · 검색어 MEASURE, MKT_FCST, VMI_In_Request, AS_In_Request: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-db3bcdf071 | B5 | [결함 유형 묶음 B5-G02 · 2건] FCST Type 콤보 후보 | 이 화면에는 FCST Type 콤보가 없다. · 검색어 FCST_TYPE, FCST Type, SALES_TYPE_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e3e1bbe23a | C2 | [결함 유형 묶음 C2-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | SCP0028 그리드에는 Measure 콤보 셀이 없다. · 검색어 MEASURE, MKT_FCST, VMI_In_Request: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8f342311f2 | C2 | [결함 유형 묶음 C2-G06 · 4건] 그리드 상위 셀 변경 시 하위 셀 cascade | SCP0028 그리드에는 End Customer·Sales Company·Sales Plant·Sales Site 상위-하위 콤보 셀이 없다. · 검색어 END_CUSTOMER, SALES_COMPANY, SALES_PLANT, SOLD_TO: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c287aaf8ee | C3 | [결함 유형 묶음 C3-G01 · 3건] Team·End Customer(·Energy(WH)) 컬럼 자동 세팅 | SCP0028 화면에는 Team·End Customer·Energy(WH) 컬럼이 없습니다. · 검색어 END_CUSTOMER, ENERGE, SSPM, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-121d9d074a | C5 | [결함 유형 묶음 C5-G01 · 2건] 사용자 좌/우 그리드 더블클릭 추가/제거 | SCP0028 화면에는 사용자 좌/우 그리드와 더블클릭으로 추가·제거하는 기능이 없습니다. · 검색어 DoubleClick, Mail Setup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b2655285d0 | D1 | [결함 유형 묶음 D1-G01 · 2건] 신규 행 Team·End Customer 등 자동 매핑 컬럼 | 이 화면에는 Team·End Customer·Energy(WH) 같은 자동 매핑 컬럼이 없다. · 검색어 END_CUSTOMER, SSPM, Energy(WH): AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3b1a9a9b09 | D2 | [결함 유형 묶음 D2-G01 · 2건] MKT_FCST·SCM_FCST 편집 권한(GET_ADMIN_GROUP_MEASURE) | 이 화면에는 MKT_FCST·SCM_FCST Measure 편집 권한 기능이 없다. · 검색어 GET_ADMIN_GROUP_MEASURE, MKT_FCST, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-049823d75c | D2 | [결함 유형 묶음 D2-G02 · 3건] Bucket 유형별 Measure 편집 구간 | 이 화면에는 Bucket 유형별 Measure 편집 구간이 없다. · 검색어 MKT_FCST, Unit Price(LOC), BUCKET_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a4ad92c3fe | D3 | [결함 유형 묶음 D3-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | SCP0028 그리드에는 Measure 콤보 컬럼이 없다. · 검색어 MKT_FCST, VMI_In_Request, AS_In_Request, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7c8359ee42 | D4 | [결함 유형 묶음 D4-G01 · 2건] 하단 메시지설정 탭의 Insert(행추가) | SCP0028에는 하단 메시지설정 탭이 없다. · 검색어 메시지설정, Message Setting, MSG_SETTING: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cd6d1de45f | D5 | [결함 유형 묶음 D5-G01 · 2건] 코드성 컬럼의 셀 입력 방식(Menu Type·Auth Unit·System) | SCP0028에는 Menu Type·Auth Unit·System 컬럼이 없다. · 검색어 Menu Type, Auth Unit, MENU_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-44d2fa918c | E4 | [결함 유형 묶음 E4-G01 · 2건] Excel Upload Validation 메시지(행·항목별) | SCP0028 에는 Excel 다운로드(BTN:EXCEL)만 있고 Excel Upload 기능이 없다. · 검색어 Excel Upload, EXCEL_UPLOAD, ExcelUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-502d5e4a02 | E4 | [결함 유형 묶음 E4-G02 · 2건] 판가(Unit Price) 미입력 Validation 오탐 | SCP0028 에는 판가(Unit Price) 컬럼과 판가 미입력 검증이 없다. · 검색어 Unit Price, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1d4c588aa1 | E4 | [결함 유형 묶음 E4-G03 · 2건] 수량 입력 시 Unit Price 조건부 필수 | SCP0028 에는 MKT FCST 수량과 Unit Price 조건부 필수 검증이 없다. · 검색어 MKT FCST, UNIT_PRICE, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-45603d4c5f | F1 | [결함 유형 묶음 F1-G01 · 3건] 저장 · Sales Site 조회조건 콤보 | SCP0028 조회조건에는 Sales Site 콤보가 없고, 사이트 조회조건은 From Site 와 To Site 다. · 검색어 Sales Site, SALES_SITE, SalesSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-31c95ff5ce | F1 | [결함 유형 묶음 F1-G02 · 2건] 수량·Unit Price(LOC) 입력 행 저장 Validation | 이 화면에는 수량·Unit Price(LOC) 입력 컬럼과 판가 미입력 검증이 없다. · 검색어 Unit Price, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-34d8095216 | F1 | [결함 유형 묶음 F1-G04 · 2건] 사용자 우측 그리드(allReceiver) 추가 후 Save | SCP0028 에는 사용자 우측 그리드(allReceiver)가 없고, 그리드는 Shipment Lot Size 메인 시트 하나다. · 검색어 allReceiver, Receiver, RECEIVER: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-439af87b6a | F2 | [결함 유형 묶음 F2-G01 · 3건] 저장 후 Sales Site 조회조건 콤보 갱신 | 이 화면에는 Sales Site 조회조건 콤보가 없고, 조회조건은 Division·From Site·To Site·Trans Mode 등이다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7404259654 | F4 | [결함 유형 묶음 F4-G01 · 2건] SQL View 버튼(VIEW) 클릭 | SCP0028의 AS-IS 소스와 TO-BE 화면에는 SQL View(VIEW) 버튼이 없다. · 검색어 SQL View, SqlView, btnView: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e937b834a2 | G5 | [결함 유형 묶음 G5-G01 · 3건] 팝업 Period 기본값(메인 Period 연동) | SCP0028 메인 화면과 팝업에 Period 조회조건이 없다. · 검색어 FROM_PERIOD, dtpPeriod, fromPeriod: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-17cd3e59f0 | H4 | [결함 유형 묶음 H4-G02 · 2건] Version 팝업(VERSION Modal) 레이아웃 | SCP0028의 팝업은 Model 선택 팝업과 일괄 입력 팝업뿐이고 Version 팝업은 없다. · 검색어 VersionPopup, VERSION_ID, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-dd1d42d630 | H4 | [결함 유형 묶음 H4-G03 · 2건] 좌/우 사용자 영역 높이 | SCP0028은 Main Grid(spdMain) 하나로 된 화면이라 좌/우 사용자 영역과 하단 탭이 없다. · 검색어 SplitContainer, splitterPosition, LeftPanel, RightPanel: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1febcf6c22 | H5 | [결함 유형 묶음 H5-G01 · 2건] Version·Plan Type 조회조건 라벨 명칭 | SCP0028 조회조건에는 Version·Waterfall Type 라벨이 없습니다. · 검색어 Ver., Waterfall Type, Plan Type: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f8cccf1b03 | I2 | [결함 유형 묶음 I2-G02 · 2건] Team 명칭(조회조건과 결과 컬럼) | 이 화면의 조회조건과 결과 컬럼에는 Team 항목이 없습니다. · 검색어 TEAM_NAME, TEAM_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-125e886e1d | J3 | [결함 유형 묶음 J3-G01 · 2건] MKT_FCST·SCM_FCST Measure 편집 구간(GET_ADMIN_GROUP_MEASURE) | SCP0028 화면에는 MKT_FCST·SCM_FCST Measure 편집 구간이 없다. · 검색어 MKT_FCST, SCM_FCST, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0a6791b101 | K2 | [결함 유형 묶음 K2-G01 · 2건] 조회 그리드 컬럼 구성 | SCP0028 그리드는 컬럼셋팅 설정값 없이 고정된 LOT_SIZE_COLUMNS 로 그려지고 COL_LIST 같은 내부 컬럼도 없다. · 검색어 ColumnSetting, COL_LIST, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f1246e5f09 | K2 | [결함 유형 묶음 K2-G04 · 2건] 컬럼셋팅 팝업 필수 컬럼 조작 제한 | SCP0028 화면에는 컬럼셋팅 팝업과 Invisible 영역이 없어 필수 컬럼 조작 제한을 확인할 수 없다. · 검색어 ColumnSetting, Invisible, USER_SELECTED_FLAG, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e6e1e9a20e | K2 | [결함 유형 묶음 K2-G05 · 2건] Div 전환 시 필수 컬럼 유지 | SCP0028 화면에는 개인화 컬럼 저장이 없고 Project Code·Plant Site·END_CUSTOMER_ID 컬럼도 없다. · 검색어 PROJECT_CODE, END_CUSTOMER_ID, ColumnSetting, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b8cd3d7815 | K2 | [결함 유형 묶음 K2-G07 · 2건] 조회 결과 Measure 표시 순서 | SCP0028 조회 결과에는 Measure 행이 없어 메저셋팅 순서를 확인할 대상이 없다. · 검색어 Measure, MeasureSetting, Measure Setting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a27caec2cb | K2 | [결함 유형 묶음 K2-G08 · 1건] 개인화 없을 때 Default 컬럼·Measure | SCP0028 그리드는 layoutKey 를 넘기지 않아 개인화 컬럼 구성이 없고 Measure 도 없어, Div 별 UI Category Default 구성을 적용할 곳이 없다. · 검색어 ColumnSetting, Measure, UI_CATEGORY, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e39643ee06 | M1 | [결함 유형 묶음 M1-G01 · 2건] Excel Form 버튼 클릭 동작 | SCP0028 에는 Excel Form 버튼이 없다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-043093ccbc | M1 | [결함 유형 묶음 M1-G07 · 2건] Excel Upload 후 OK 저장·DB 반영 | SCP0028 에는 Excel Upload 후 OK 로 저장하는 기능이 없다. · 검색어 ExcelUpload, Excel Upload, btnExcelUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c5ed807023 | M1 | [결함 유형 묶음 M1-G09 · 2건] Excel Upload 헤더·컬럼명 불일치 검증 | SCP0028 에는 Excel Upload 가 없어 헤더명 검증을 할 대상이 없다. · 검색어 ExcelUpload, Excel Upload, Invalid Column Header Title: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0b44dd6b31 | M2 | [결함 유형 묶음 M2-G01 · 2건] SQL View 버튼(VIEW) 클릭 결과 | SCP0028 버튼은 SEARCH·SAVE·INSERT·DELETE·EXCEL·RESET·INPUT·ITEMID 뿐이고 SQL View(VIEW) 버튼은 없다. · 검색어 SQL View, SqlView, btnView: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d3f96f3f07 | M3 | [결함 유형 묶음 M3-G01 · 2건] SQL 버튼 팝업 쿼리 저장 | SCP0028 화면 버튼은 Search·Reset·Insert·Save·Excel·Input·Delete·ItemId 이고, 쿼리를 저장하는 SQL 버튼 팝업은 없다. · 검색어 btnSql, SqlPopup, SQL 등록: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-305866a297 | N1 | [결함 유형 묶음 N1-G02 · 2건] Div별 컬럼·Measure 구성의 AS-IS 일치 | SCP0028 그리드에는 Div별 Measure 구성(Project·Cust FCST·End Cust 등)이 없고, 컬럼은 Lot Size·Increment·Container Split·Active 같은 고정 컬럼이다. · 검색어 Measure, SSPM, Cust FCST, End Cust: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0b50672bd9 | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SCP0028 조회조건에는 Division·Operation Group·From Site·To Site·Trans Mode·Model·Valid 만 있고 Team(DEPT) 콤보가 없습니다. · 검색어 DEPT_ID, cboTeam, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5815962404 | C2 | 그리드 End Customer→Sold-to Customer cascade | SCP0028 그리드에는 End Customer·Sold-to Customer 셀이 없다. · 검색어 END_CUSTOMER, SOLD_TO, Sold-to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c8ed0c157a | C2 | 그리드 Sales Company→Sales Plant · Sales Site→Company/Plant | SCP0028 그리드에는 Sales Company→Sales Plant, Sales Site→Company/Plant 연쇄 셀이 없다. · 검색어 SALES_COMPANY, SALES_PLANT, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8c1dba812f | M1 | Excel Upload 컬럼명 검증 메시지 · 파일 첨부 개수 | SCP0028 에는 Excel Upload 파일 첨부 기능이 없다. · 검색어 ExcelUpload, Excel Upload, btnExcelUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0fd64e2d58 | H2 | 실적 구간 배경색 | Shipment Lot Size 그리드에는 실적 기간 구간 컬럼이 없다. · 검색어 Actual, ACTUAL: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-be27873f34 | B8 | Team 컬럼(MKT FCST 조회·신규행) | SCP0028 그리드에 Team 컬럼이 없다. · 검색어 DEPT_ID, Team, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-437af744fd | G3 | Condition(F6) 저장 · Sales Report ETC Insert 기능 | SCP0028 조회조건에는 Period(기간) 조건이 없다. · 검색어 Period, dtpPeriod, periodFrom: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-df4a6375bb | M1 | Excel Upload 헤더 검증 메시지 | SCP0028 에는 Excel Upload 가 없어 헤더 검증 메시지를 표시할 대상이 없다. · 검색어 ExcelUpload, Excel Upload, Invalid Column Header Title: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3ed86402f0 | M1 | Excel Upload Validation 메시지(Sales Site/Project/Model) | SCP0028 에는 Excel Upload 가 없어 업로드 검증 오류 메시지를 확인할 대상이 없다. · 검색어 ExcelUpload, Excel Upload, btnExcelUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-62ca4c2ca5 | K2 | Column Setting 필수 컬럼 표시·Div 전환 End Customer | SCP0028 화면에는 컬럼셋팅 팝업이 없어 USER_SELECTED_FLAG=N 필수 컬럼의 빨간색 표시와 다국어 메시지를 확인할 수 없다. · 검색어 ColumnSetting, USER_SELECTED_FLAG, Column Settings, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-86f292e3e8 | M3 | Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SCP0028 에는 Exchange Rate 팝업이 없고, 팝업은 Model 선택(SCM0002_ItembyDivisionPopup)과 Input/Delete(SCM0002_ShipmentLotSizePopup) 두 가지뿐이다. · 검색어 Exchange Rate, ExchangeRate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c6f5981189 | A5 | Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | SCP0028 메인 그리드에는 Column Settings 팝업이 없어 컬럼셋팅 OK 반영 확인 대상이 없다. · 검색어 layoutKey, ColumnSetting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-56c7157814 | K2 | 컬럼·메저 셋팅 Save/OK 재조회 | SCP0028 그리드는 Column Settings 메뉴를 켜는 layoutKey 를 쓰지 않고 메저셋팅 팝업도 없어, Save/OK 후 재조회 여부를 확인할 팝업이 없다. · 검색어 ColumnSetting, Column Settings, MeasureSetting, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3f6fe9a276 | M4 | 팝업 입력 컬럼 | SCP0028 그리드에서 편집할 수 있는 컬럼은 LOT_SIZE·INCREMENT·VALID_YN·SPLIT_YN 뿐이고, 팝업으로 값을 넣는 셀은 없다. · 검색어 ButtonClicked, CellDoubleClick, cellPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-86c098ddd0 | A5 | 컬럼셋팅 Company ID(필수 표시·Invisible 이동) | SCP0028 에는 컬럼셋팅 Invisible 영역과 Company ID 컬럼이 없다. · 검색어 COMPANY_ID, Invisible, layoutKey: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-eb2095583a | K2 | Measure 순서·메저셋팅 순서 저장 | SCP0028 화면에는 메저셋팅 버튼이 없어 메저셋팅 순서 저장 요구가 적용되지 않는다. · 검색어 Measure, MeasureSetting, Measure Setting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0e969557bd | K2 | Measure 순서 | SCP0028 화면에는 메저셋팅이 없어 Measure 표시 순서 요구가 적용되지 않는다. · 검색어 Measure, MeasureSetting, Measure Setting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-15ee2584f5 | H2 | 팝업 입력 셀(FPModal · 더블클릭 팝업으로 값이 채워지는 셀, 예 BOD Route Id) | 이 화면 그리드에는 더블클릭 팝업으로 값을 채우는 FPModal 셀이 없고, 팝업은 ItemId·Input·Delete 버튼에서만 열린다. · 검색어 FPModal, CELL_CONTROL_OBJECT_TYPE_CODE FPModal, Route Id: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-48669c0fc5 | C5 | 다중 그리드 더블클릭 연동 | SCP0028 화면은 그리드가 spdMain 하나뿐이고 더블클릭 연동이 없습니다. · 검색어 DoubleClick, CellDoubleClick, onDoubleClick: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-644cb71506 | E7 | 그리드 팝업 셀 Key-in(FPModal 컬럼) 잘못된 값 | SCP0028 그리드에는 팝업으로 고르는 셀(FPModal 컬럼)이 없고 ITEM_ID 는 편집 잠금이다. · 검색어 FPModal, FpModalCellType: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9f940cebe0 | M1 | Excel Form 버튼 | SCP0028 에는 Excel Form 버튼이 없다. · 검색어 ExcelForm, Excel Form, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9d01854953 | H6 | TO-BE 메타 공통 셀 팝업(SCM_MST_SHEET_COLUMNS CELL_CONTROL_OBJECT_TYPE_CODE = FPModal·FPTextModal) | SCP0028 메인 그리드 셀에는 FPModal·FPTextModal 메타 공통 셀 팝업이 없고 콤보 셀만 쓴다. · 검색어 FPModal, FPTextModal, CELL_CONTROL_OBJECT_TYPE_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3783aea0d9 | A5 | 그리드 행 선택용 체크 컬럼(AS-IS CHK 컬럼 + 머리글 전체 체크) | SCP0028 AS-IS 메인 그리드에는 행 선택용 CHK 컬럼과 머리글 전체 체크가 없습니다. · 검색어 CHK, CHK_ALL, chkAll: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5bf38ebfa9 | E2 | 월 범위 조회조건 기간 역전(시작 > 끝) | SCP0028 조회조건은 Division·Operation Group·From Site·To Site·Model·Trans Mode·Valid 뿐이며 월 범위 조건이 없다. · 검색어 MSG00344, FROM_MONTH, TO_MONTH, Period: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8370915e43 | G4 | 스냅샷 조회조건 공용 기간 칸 구조·아이콘 | 이 화면 조회영역에는 공용 월 범위(Period) 칸이 없다. · 검색어 Period, YYYY.MM: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |

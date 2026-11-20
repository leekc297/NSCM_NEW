# SCP0028 기준 원장 (2026-11-20 10:35:05)

- 원장 1612행 → 기준 항목 1465개 · 요소 85개 · 상태 확정 990 · 대상 아님 459 · 판단 대기 16
- 다른 문서 행 840행: 같은 확인으로 합침 147 · 요소 지정 69 · 화면 전체 150 · 대상 아님(검색 0건 확인) 450 · 판단 대기 11
- TO-BE 룰 결합 376건(인용 불일치로 버림 0) · AS-IS 실측 연결 135건(판단 대기 58) · 사용자의견 고정 0건
- AI 호출 0(기억 44 · 실패 0 · 바꾼 것 없는 호출 0) · 비용 출처 Doc/verify/SCP0028/llm_usage.csv

## 판단 대기(사용자 확인)

| 기준 항목 | 요소 | 규칙 | 확인 | 사유 |
|---|---|---|---|---|
| C-58b654e33e | SCREEN | G5 | [DMF0042 결함 유형] Replace 버튼 팝업 Period·조회 | SCP0028 에는 Replace 버튼과 Period 조회조건이 없고, AS-IS cs 와 TO-BE 폴더에서 Period 검색 결과가 0건이다. · 검색어가 화면에 있음: Replace 4곳 |
| C-50eda4e96b | SCREEN | M3 | [DMF0042 결함 유형] Replace 버튼 팝업 Period·조회 | SCP0028 에는 Replace 버튼과 Period 조건이 없다. · 검색어가 화면에 있음: Replace 4곳 |
| C-599be7b6a4 | SCREEN | F1 | [DMF0082 결함 유형] 신규 데이터셋 수량·판가 저장 | SCP0028 에는 신규 데이터셋 수량·판가 입력 기능이 없다. · 검색어가 화면에 있음: Dataset 1곳 |
| C-a3a9d4a494 | SCREEN | H3 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | 이 화면에는 Dept 컬럼과 Use Y/N 헤더가 없다. · 검색어가 화면에 있음: SSO 2곳 |
| C-5f142f601d | SCREEN | A5 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | SCP0028에는 URL·ROUTE_PATH 입력 컬럼이 없다. · 검색어가 화면에 있음: ROUTE_PATH 1곳 |
| C-1071c18629 | SCREEN | G5 | [SCP0006 결함 유형] Capa New Model 팝업 조건(Group/Plant) | 기준 정리 답 없음(AI 꺼짐 또는 실패) — 화면 전체로 둠 |
| C-c47c01aea7 | SCREEN | M3 | [SCP0006 결함 유형] Capa New Model 팝업 조건(Group/Plant) | SCP0028 에는 Capa New Model 팝업과 Group/Plant 조건이 없습니다. · 검색어가 화면에 있음: SCP0006 3곳 |
| C-7f914f4bd6 | SCREEN | G5 | [SCP0007 결함 유형] Route 검색 팝업 결과 | 기준 정리 답 없음(AI 꺼짐 또는 실패) — 화면 전체로 둠 |
| C-a2e76efa38 | SCREEN | K1 | [DMF0048 결함 일반화] 그리드 필터(Filter) 유지 · 건수(Count) 표시 | 기준 정리 답 없음(AI 꺼짐 또는 실패) — 화면 전체로 둠 |
| C-602befe09c | SCREEN | K1 | [DMF0074 결함 일반화] 그리드 필터(Filter) 유지 · 건수(Count) 표시 | 기준 정리 답 없음(AI 꺼짐 또는 실패) — 화면 전체로 둠 |
| C-0a4b4fe439 | SCREEN | H4 | [DMF0048 결함 일반화] 조회조건 영역 공통 컴포넌트(SearchCondition) 너비 | 기준 정리 답 없음(AI 꺼짐 또는 실패) — 화면 전체로 둠 |
| C-6cab6caee5 | SCREEN | MS1 | [DMF0014 결함 일반화] 공용 업로드 창(Upload) 검증 완료 후 저장 전 Cancel · X 닫기 확인창 MSG00684 「취소하시겠습니까?」(AS-IS MSG00195) | SCP0028 에는 공용 업로드 창(Upload)이 없고 MSG00684·MSG00195 도 쓰지 않습니다. · 검색어가 화면에 있음: MSG00684 1곳, MSG00195 1곳, Upload 1곳 |
| C-f8943fbdbc | SCREEN | I1 | [DMF0074 결함 일반화] 공용 Excel Upload 창 안내 메시지 MSG00657(오류 행 저장 차단) · MSG00658 · MSG00659 EN · CN 등록값(SCM_ADM_MSG_M) | SCP0028에는 공용 Excel Upload 창이 없어(ShipmentLotSize.tsx:304 upload: false) MSG00657·MSG00658·MSG00659 안내 메시지가 나오지 않는다. · 검색어가 화면에 있음: MSG00657 1곳, MSG00658 1곳, MSG00659 1곳 |
| C-6b0b987f2f | SCREEN | I2 | [DMF0074 결함 일반화] 공용 Excel Upload 창 안내 메시지 MSG00657(오류 행 저장 차단) · MSG00658 · MSG00659 EN · CN 등록값(SCM_ADM_MSG_M) | SCP0028에는 공용 Excel Upload 창이 없어(ShipmentLotSize.tsx:304 upload: false) MSG00657·MSG00658·MSG00659 안내 메시지가 나오지 않는다. · 검색어가 화면에 있음: MSG00657 1곳, MSG00658 1곳, MSG00659 1곳 |
| C-62b5d6fff7 | SCREEN | I2 | [DMF0043_01 결함 일반화] Version 팝업 미선택 OK 안내 — 다국어 코드 MSG00701(AS-IS MSG00279) 「버전은 1개만 선택해 주세요.」/「Please select only one ve | SCP0028에는 Version 팝업이 없고 AS-IS·TO-BE 소스 어디에서도 MSG00701·MSG00279를 쓰지 않는다. · 검색어가 화면에 있음: MSG00701 1곳, MSG00279 1곳 |
| C-163de5d76d | SCREEN | MS1 | [DMF0043_01 결함 일반화] Version 팝업 미선택 OK 안내 — 다국어 코드 MSG00701(AS-IS MSG00279) 「버전은 1개만 선택해 주세요.」/「Please select only one ve | SCP0028 에는 Version 팝업이 없고, AS-IS 소스와 TO-BE 화면 폴더 모두 MSG00701·MSG00279 를 쓰지 않습니다. · 검색어가 화면에 있음: MSG00701 1곳, MSG00279 1곳 |
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
| 실측 | COL:INCREMENT | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.increment | AS-IS 12800 · TO-BE 1 · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.debug_mode | AS-IS F · TO-BE N · DIFF |
| 실측 | COL:LOT_SIZE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.lot_size | AS-IS 1 · TO-BE 12800 · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.transport_mode | AS-IS AIR · TO-BE SEA · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.debug_mode | AS-IS F · TO-BE N · DIFF |
| 실측 | COL:LOT_SIZE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.lot_size | AS-IS 1 · TO-BE 12800 · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.transport_mode | AS-IS AIR · TO-BE SEA · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.debug_mode | AS-IS F · TO-BE N · DIFF |
| 실측 | COL:INCREMENT | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.increment | AS-IS 12800 · TO-BE 1 · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.debug_mode | AS-IS F · TO-BE N · DIFF |
| 실측 | COL:LOT_SIZE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.lot_size | AS-IS 1 · TO-BE 12800 · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.transport_mode | AS-IS AIR · TO-BE SEA · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.debug_mode | AS-IS F · TO-BE N · DIFF |
| 실측 | COL:INCREMENT | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.increment | AS-IS 12800^288 · TO-BE 1^288 · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.active_flag | AS-IS D · TO-BE M · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.debug_mode | AS-IS F · TO-BE N · DIFF |
| 실측 | COL:INCREMENT | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.increment | AS-IS 0 · TO-BE 1 · DIFF |
| 실측 | COL:LOT_SIZE | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.lot_size | AS-IS 0 · TO-BE 12800 · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.transport_mode | AS-IS X · TO-BE SEA · DIFF |
| 실측 | (요소 없음) | - | 저장 인자 SCP0028_SAVE_SHIPMENT_LOT_SIZE.user_id | AS-IS jaeuk.shin · TO-BE minyonglee1 · USER(비교 제외) |

## 대상 아님

| 기준 항목 | 규칙 | 확인 | 근거 |
|---|---|---|---|
| C-d1b0d59417 | K6 | SCP0028 화면 | TO-BE 룰 CR-088: 그리드가 여러 개인 화면의 더블클릭 연동은 AS-IS 와 같이 동작하고 상단 그리드는 재조회·깜빡임 없이 유지되며 팝업 선택값은 즉시 반영된다. · SCP0028 은 spdMain 그리드 하나뿐이고 더블클릭으로 하단 그리드를 조회하는 연동이 없어 상·하단 그리드 유지 확인 대상이 아니다. |
| C-4df490db2d | F5 | SCP0028 병합 셀 Delete 범위 | TO-BE 룰 CR-057: Active 컬럼으로 사용여부를 관리하는 화면은 Delete 시 신규행만 제거하고 기존행에 D Flag 를 표시하지 않는다 · Active 관리 화면에서는 기존행에 D Flag 를 표시하지 않으므로, 병합 셀 Delete 때 병합 전체 행에 D 를 표시하는지는 확인 대상이 아니다. |
| C-d99f7049ee | I1 | SCP0028 시나리오 CN 언어 조회 건수 총/건 표기 | TO-BE 룰 DD-215: AS-IS: CN 언어 총/건 표기 검사 대상 → TO-BE: 검사 대상 제외(NA) · CN 언어 조회 건수 총/건 표기 항목은 2026-11-06 사용자 결정으로 검사 대상에서 빠진다. |
| C-4876b42679 | K1 | SCP0028 필터 유지 재조회 | TO-BE 룰 DD-217: TO-BE: 검사 대상 제외(NA) · 재조회 뒤 필터 유지 여부는 공용 DataGrid 공통 기능이라 SCP0028 화면 검사 대상에서 뺀다. |
| C-f6002572c3 | A7 | SCP0028_GET_SHIPMENT_LOT_SIZE | TO-BE 룰 CR-105: 값 불일치와 행·키 집합 차이는 판정에서 뺀다(해당없음으로 두고 근거를 표시한다). · SCP0028_GET_SHIPMENT_LOT_SIZE 와 SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT 의 컬럼 값 일치 확인은 값 불일치 판정이라 해당없음이다. |
| C-540f056179 | A7 | SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | TO-BE 룰 CR-105: 값 불일치와 행·키 집합 차이는 판정에서 뺀다(해당없음으로 두고 근거를 표시한다). · SCP0028_GET_SHIPMENT_LOT_SIZE 와 SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT 의 컬럼 값 일치 확인은 값 불일치 판정이라 해당없음이다. |
| C-a30284ca14 | A7 | SCP0028 SCP0028_GET_SHIPMENT_LOT_SIZE 공통행 컬럼 값(공통 1940행 · 불일치 셀 0) | TO-BE 룰 CR-105: 값 불일치와 행·키 집합 차이는 판정에서 뺀다(해당없음으로 두고 근거를 표시한다). · SCP0028_GET_SHIPMENT_LOT_SIZE 와 SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT 의 컬럼 값 일치 확인은 값 불일치 판정이라 해당없음이다. |
| C-ecfbad9b03 | A6 | PR_GET_MNU_BTN_AUTH | TO-BE 룰 CR-075: ③ 예외: 그리드에 바인딩되지 않는 룩업·보조 SP(countryCity 등)와 결과 1행 집계 SP(routeCnt)는 대상 아님(NA 사유 기재). · PR_GET_MNU_BTN_AUTH 는 버튼 권한 조회용 보조 SP 이고 그리드에 바인딩되지 않는다. |
| C-b89ca18051 | I2 | SCP0028 언어 전환 CN | TO-BE 룰 DD-216: AS-IS: CN 언어 화면 문구 검사 대상 → TO-BE: 검사 대상 제외(NA) · 언어 전환 CN 시 라벨·버튼·헤더 문구 항목은 2026-11-06 사용자 결정으로 검사 대상에서 빠진다. |
| C-b31c6e487a | K2 | 컬럼/Measure 셋팅(개인화 Default) | SCP0028 그리드는 고정 컬럼(LOT_SIZE_COLUMNS)으로 그려지며, 컬럼·Measure 개인화 Default 셋팅 기능이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ed5e509bcd | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SCP0028 조회조건에는 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보가 없다. · 검색어 End Customer, Sold to, DEPT_ID, SalesSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-03f9afe2e6 | C1 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SCP0028 조회조건에는 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보와 Team cascade 가 없다. · 검색어 SALES_SITE, END_CUSTOMER, SOLD_TO, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6bfd4c490c | B8 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SCP0028 조회조건에는 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보가 없다. · 검색어 SALES_SITE, END_CUSTOMER, SOLD_TO, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b647339101 | B2 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Customer) | SCP0028 그리드에는 Insert 때 쓰는 End Customer·Sold-to Customer 콤보가 없습니다. · 검색어 END_CUSTOMER, SOLD_TO, End Customer, Sold-to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b7f5e63342 | B3 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Customer) | SCP0028 그리드에는 Insert 때 쓰는 End Customer·Sold-to Customer 콤보가 없습니다. · 검색어 END_CUSTOMER, SOLD_TO, End Customer, Sold-to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4e7e2d259c | B4 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Customer) | 이 행은 Sales Site 화면 Insert 시 End Customer·Sold-to Customer 그리드 콤보를 다루며, SCP0028 그리드에는 이 컬럼들이 없다. · 검색어 END_CUSTOMER, SOLD_TO_CUSTOMER, Sold-to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8e5251c1e4 | M4 | 팝업 입력 컬럼 | SCP0028 메인 그리드와 Input/Delete 일괄 팝업 그리드에는 팝업으로 값을 넣는 셀이 없습니다. · 검색어 ButtonClicked, CellButtonClick, onCellPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fec3161cfc | K2 | Measure 순서·메저셋팅 순서 저장 | SCP0028에는 메저셋팅 순서를 저장하는 기능이 없다. · 검색어 Measure, MeasureSetting, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f97c16a388 | A7 | RTF Measure 금액(AMT) 계산 시 적용 LOC(판가) 기준(RTF · AMT · LOC) | SCP0028 에는 RTF Measure 와 AMT 금액 계산 기능이 없다. · 검색어 RTF, Measure, LOC_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-73b1eb19ac | M4 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | SCP0028 메인 그리드의 ITEM_ID 셀에는 Model 팝업이 붙어 있지 않고, Model 팝업은 조회조건 btnItemId 에서만 열립니다. · 검색어 ButtonClicked, CellDoubleClick, onCellPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-bc5b777e47 | H6 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | 이 화면 그리드의 ITEM_ID(Model) 컬럼에는 셀 팝업이 없고, Model 팝업은 조회조건에서만 열립니다. · 검색어 ButtonClicked, FPModal, CellPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-93a55ca312 | A5 | [SYS0002 결함 유형] User 화면 Group 컬럼 | SCP0028은 User 화면이 아니며 User Group 컬럼이 없다. · 검색어 Default Group, DEFAULT_GROUP, USER_GROUP: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2f7bfe647f | B6 | [DMF0043_01 결함 유형] 조회조건 Product Group·Biz Type | SCP0028 조회조건에는 Product Group·Biz Type 이 없다. · 검색어 Product Group, Biz Type, BIZ_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8fc809556e | G2 | [DMF0043_01 결함 유형] 조회조건 Product Group·Biz Type | SCP0028 조회조건은 Division·Operation Group·From Site·To Site·Model/Nickname·Valid·Trans Mode 이고 Product Group·Biz Type 조회조건은 없다. · 검색어 PRODUCT_GROUP, BIZ_TYPE, Product Group, Biz Type: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-645a23e70b | C2 | [DMF0007 결함 유형] 그리드 End Customer→Sales Site cascade | SCP0028 그리드에는 End Customer·Sales Site 컬럼이 없습니다. · 검색어 END_CUSTOMER, End Customer, SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f90a5c0e2a | B4 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | SCP0028 그리드에는 Sales Site 셀 콤보가 없다. · 검색어 SALES_SITE, Sales Site, salesSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fcff138de7 | F1 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | SCP0028 그리드에는 Sales Site 셀 콤보가 없고 Site 컬럼은 From Site·To Site 이다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5d407d49da | F2 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | SCP0028 그리드에는 Sales Site 셀 콤보가 없고, 저장 성공 확인은 C-f21f0ebd45 가 맡습니다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-98f87f7046 | B1 | [DMF0007 결함 유형] 그리드 End Customer 콤보 | SCP0028 그리드에는 End Customer 콤보가 없습니다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-622f808105 | B2 | [DMF0007 결함 유형] 그리드 End Customer 콤보 | SCP0028 그리드에는 End Customer 콤보가 없습니다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-696d6e45a3 | B3 | [DMF0007 결함 유형] 그리드 End Customer 콤보 | SCP0028 그리드에는 End Customer 콤보가 없습니다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c5e4f09db4 | B5 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_MST_CUSTOMER_FCST(_C/_H).MEASURE | SCP0028 은 CUST_FCST_MEASURE 룩업이나 DM_MST_CUSTOMER_FCST 를 쓰지 않는다. · 검색어 CUST_FCST_MEASURE, Cutomer FCST, DM_MST_CUSTOMER_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fca9ddf123 | N1 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_MST_CUSTOMER_FCST(_C/_H).MEASURE | SCP0028 화면에는 Measure 콤보(CUST_FCST_MEASURE)가 없다. · 검색어 CUST_FCST_MEASURE, Cutomer FCST, DM_MST_CUSTOMER_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-da1691c59f | F2 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | SCP0028 조회조건에는 Sales Site 콤보가 없고, 사이트 조건은 From Site·To Site 뿐입니다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-96edbb4a83 | F1 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | SCP0028 조회조건에는 Sales Site 콤보가 없고 From Site·To Site 조건만 있다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7d3fc0aeb4 | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | SCP0028 은 Shipment Lot Size 를 저장하고, Sales Site 를 저장하거나 Sales Site 조회조건 콤보를 쓰지 않는다. · 검색어 Sales Site, SalesSite, SiteByEndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9706f7c40b | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | SCP0028 에는 Sales Site 조회조건이 없고 Sales Site 를 저장하는 기능도 없다. · 검색어 SALES_SITE, Sales Site, SalesSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7d27c8dc57 | F2 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | SCP0028 조회조건에는 Sales Site 콤보가 없고, 사이트 조건은 From Site·To Site 뿐입니다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-076d437cba | F1 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | SCP0028 조회조건에는 Sales Site 콤보가 없고, 사이트 조건은 From Site·To Site 뿐입니다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-22d765f3a5 | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | SCP0028에는 Sales Site 조회조건 콤보가 없다. · 검색어 SALES_SITE, Sales Site, salesSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-db6827d3b2 | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | SCP0028 에는 Sales Site 조회조건이 없고 Sales Site 를 저장하는 기능도 없다. · 검색어 SALES_SITE, Sales Site, SalesSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0840d7b144 | F2 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | SCP0028 조회조건에는 Sales Site 콤보가 없고, 사이트 조건은 From Site·To Site 뿐입니다. · 검색어 SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b226550bca | F1 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | SCP0028 조회조건에는 Sales Site 콤보가 없고 From Site·To Site 조건만 있다. · 검색어 Sales Site, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1852e8a9c8 | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | SCP0028 조회조건은 Division·Operation Group·Trans Mode·From Site·To Site·Valid·Model이며 Sales Site 조회조건 콤보는 이 화면에 없다. · 검색어 SALES_SITE, Sales Site, salesSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4fac009d0a | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | SCP0028 에는 Sales Site 조회조건이 없고 Sales Site 를 저장하는 기능도 없다. · 검색어 SALES_SITE, Sales Site, SalesSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3b1dbe8930 | M3 | [DMF0005 결함 유형] Team 팝업 | SCP0028 에는 Team 팝업과 SSO_DEPT 조회가 없다. · 검색어 TeamPopup, SSO_DEPT, btnTeam: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4819771fd0 | G5 | [DMF0005 결함 유형] Team 팝업 | SCP0028 에는 Team 팝업이 없다. · 검색어 TeamPopup, SSO_DEPT, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2460be616a | C3 | [DMF0005 결함 유형] Team·Owner 컬럼 | SCP0028 화면에는 Team·Owner 컬럼이 없다. · 검색어 Owner, OWNER, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-af0148bb5f | F6 | [DMF0005 결함 유형] Team·Owner 컬럼 | SCP0028 그리드에는 Team 과 Owner 컬럼이 없다. · 검색어 TEAM_NAME, OWNER_ID, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e807506246 | F1 | [DMF0005 결함 유형] 하단 Purchase 탭 EDI Incoterms | SCP0028 에는 하단 Purchase 탭과 EDI Incoterms 컬럼이 없다. · 검색어 Incoterms, INCOTERMS, Purchase: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0fee141c4c | B1 | [DMF0005 결함 유형] 그리드 End Customer 콤보 | SCP0028 그리드에는 End Customer 콤보가 없습니다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-bf1bc0f2d1 | B2 | [DMF0005 결함 유형] 그리드 End Customer 콤보 | SCP0028 그리드에는 End Customer 콤보가 없습니다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d130ece72a | B3 | [DMF0005 결함 유형] 그리드 End Customer 콤보 | SCP0028 그리드에는 End Customer 콤보가 없습니다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4df874a9bb | E3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | SCP0028 그리드에는 Team 팝업 컬럼과 Project 컬럼이 없다. · 검색어 Team, DEPT_ID, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5c5602f364 | F3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | SCP0028 그리드에는 Team·Project 컬럼이 없고 Team 팝업 컬럼 필수 Validation 기능도 없습니다. · 검색어 TEAM_CODE, TEAM_NAME, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-416a36f228 | D1 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | SCP0028 그리드에는 Team 팝업 컬럼과 Project 컬럼이 없다. · 검색어 TEAM_CODE, PROJECT_CODE, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-eb522dd994 | B1 | [DMF0072 결함 유형] 그리드 End Customer 콤보 | SCP0028 그리드에는 End Customer 콤보가 없습니다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-db64ea4933 | B2 | [DMF0072 결함 유형] 그리드 End Customer 콤보 | SCP0028 그리드에는 End Customer 콤보가 없습니다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fd82d4ed74 | B3 | [DMF0072 결함 유형] 그리드 End Customer 콤보 | SCP0028 그리드에는 End Customer 콤보가 없습니다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6f7c9c1b82 | B4 | [DMF0006 결함 유형] 그리드 End Customer 콤보 | SCP0028 그리드에는 End Customer 컬럼이 없다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-23dd793289 | B4 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SCP0028 에는 조회조건 Team 과 그리드 Team·End Customer·Sales Site 콤보가 없다. · 검색어 DEPT_ID, Team, End Customer, SalesSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1cab3d909d | C1 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SCP0028 에는 Team 조회조건이 없고 그리드에도 Team·End Customer·Sales Site 콤보가 없다. · 검색어 DEPT_ID, Team, END_CUSTOMER, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d3df98bf57 | B2 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SCP0028에는 Team 조회조건과 Team/End Customer/Sales Site 그리드 콤보가 없습니다. · 검색어 DEPT_ID, Team, Sales Site, END_CUSTOMER: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-44fd997d9c | B8 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site 콤보 | SCP0028 에는 Team 조회조건이 없고 그리드에도 Team·End Customer·Sales Site 콤보가 없다. · 검색어 DEPT_ID, Team, END_CUSTOMER, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-def396f4b9 | G5 | [DMF0020 결함 유형] Exchange Rate 팝업 · DM_MST_EXCHANGE_RATE | SCP0028 에는 Exchange Rate 팝업이 없다. · 검색어 ExchangeRate, EXCHANGE_RATE, Exchange Rate: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-dcb97d3ae1 | M3 | [DMF0020 결함 유형] Exchange Rate 팝업 · DM_MST_EXCHANGE_RATE | SCP0028 에는 Exchange Rate 팝업과 DM_MST_EXCHANGE_RATE 조회가 없다. · 검색어 Exchange Rate, DM_MST_EXCHANGE_RATE, ExchangeRate: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-438cf6adaf | N1 | [DMF0020 결함 유형] Exchange Rate 팝업 · DM_MST_EXCHANGE_RATE | SCP0028 화면에는 Exchange Rate 팝업이 없다. · 검색어 DM_MST_EXCHANGE_RATE, EXCHANGE_RATE, Exchange Rate: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0cd1502921 | A8 | [DMF0020 결함 유형] Exchange Rate 팝업 · DM_MST_EXCHANGE_RATE | SCP0028에는 Exchange Rate 팝업과 DM_MST_EXCHANGE_RATE 조회가 없습니다. · 검색어 EXCHANGE_RATE, Exchange Rate, DM_MST_EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-dbb646b1e5 | D1 | [DMF0020 결함 유형] Team·End Customer 컬럼 | SCP0028 그리드에는 Team·End Customer 컬럼이 없다. · 검색어 END_CUSTOMER, TEAM_CODE, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3afe3d054b | C3 | [DMF0020 결함 유형] Team·End Customer 컬럼 | SCP0028 화면에는 Team·End Customer 컬럼이 없다. · 검색어 END_CUSTOMER, End Customer, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f81dac6928 | D1 | [DMF0020 결함 유형] Price Exist 컬럼 | SCP0028 그리드에는 Price Exist 컬럼이 없다. · 검색어 PRICE_EXIST, Price Exist: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c15f31d807 | D2 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SCP0028 화면에는 Monthly Bucket 입력과 Project Code 팝업이 없다. · 검색어 Monthly, BUCKET, Project Code, MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-31fb6f6f53 | F6 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SCP0028 에는 Monthly Bucket 입력과 Project Code 팝업이 없다. · 검색어 Monthly, PROJECT_CODE, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-618b571050 | F4 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SCP0028에는 Monthly Bucket 입력과 Project Code 팝업이 없습니다. · 검색어 Monthly, Bucket, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1f683f05f0 | M3 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Model 팝업 | SCP0028 에는 Monthly Bucket 입력, Project Code 팝업, 셀 더블클릭 팝업이 없습니다. · 검색어 Monthly Bucket, MonthlyBucket, ProjectCodePopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2e21d10414 | K2 | [DMF0020 결함 일반화] 컬럼셋팅 팝업 Default | SCP0028에는 컬럼셋팅 팝업이 없어 개인화 정보가 없을 때의 Div Default 컬럼 구성을 확인할 대상이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4c544c9962 | J2 | [DMF0020 결함 유형] Price Batch Input 버튼 | SCP0028 에는 Price Batch Input 버튼이 없어 Div 별 버튼 숨김 확인은 대상 기능이 없습니다. · 검색어 Price Batch Input, PriceBatch, btnPriceBatch: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e4bc9752bb | K4 | [DMF0020 결함 유형] Price Batch Input 버튼 | SCP0028 버튼 목록에 Price Batch Input 버튼이 없다. · 검색어 Price Batch Input, PriceBatch, PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3b39faea7b | M3 | [DMF0020 결함 유형] Price Batch Input 팝업 | SCP0028 에는 Price Batch Input 팝업과 Period 기간만큼 생기는 Spread 컬럼이 없습니다. · 검색어 Price Batch Input, PriceBatchInput, DMF0020: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e100a28bcb | G5 | [DMF0020 결함 유형] Price Batch Input 팝업 | SCP0028 에는 Price Batch Input 팝업이 없다. · 검색어 PriceBatch, Price Batch Input, Price: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-283a5be920 | A8 | [DMF0020 결함 유형] Price Batch Input 팝업 | SCP0028에는 Price Batch Input 팝업과 Period 기간별 컬럼 생성 기능이 없습니다. · 검색어 PRICE_BATCH, Price Batch Input, PriceBatch: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0620638323 | G4 | [DMF0020 결함 유형] 조회조건 Project | 이 화면에는 Project 조회조건이 없다. · 검색어 cboProject, PROJECT_ID, lblProject: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-75f1979cd9 | G4 | [DMF0068 결함 유형] Main Version 조회조건 크기 · Version 팝업 Description 컬럼 폭 | SCP0028에는 Main Version 조회조건과 Version 팝업이 없고, 팝업은 SCM0002_ITEMBYDIVISIONPOPUP·SCM0002_SHIPMENTLOTSIZEPOPUP만 있습니다. · 검색어 Main Version, MAIN_VERSION, cboVersion: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-15e8913185 | H6 | [DMF0068 결함 유형] Main Version 조회조건 크기 · Version 팝업 Description 컬럼 폭 | 이 화면 조회조건에는 Main Version 조건과 Version 팝업이 없습니다. · 검색어 VersionPopup, VersionModal, Main Version: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-80dab668f4 | B4 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer 콤보 | SCP0028 그리드에는 End Customer·Sold to Customer 콤보가 없다. · 검색어 END_CUSTOMER, SOLD_TO_CUSTOMER, Sold to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ab4ba3b0cc | B7 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer 콤보 | SCP0028 그리드에는 End Customer·Sold to Customer 콤보 컬럼이 없다. · 검색어 END_CUSTOMER, SOLD_TO, End Customer, Sold to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-885074db44 | C2 | [DMF0004 결함 일반화] 그리드 End Customer→Sold-to Customer cascade | SCP0028 그리드에는 End Customer·Sold-to Customer 컬럼이 없습니다. · 검색어 END_CUSTOMER, End Customer, SOLD_TO, Sold-to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1b3464d9f8 | C2 | [DMF0005 결함 일반화] 그리드 Sales Company→Sales Plant · Sales Site→Company/Plant | SCP0028 그리드에는 Sales Company·Sales Plant·Sales Site 컬럼이 없습니다. 콤보 셀은 OPERATION_GROUP_ID·SPLIT_YN·VALID_YN 뿐이고, 이 컬럼들 사이에는 상위·하위 cascade가 없습니다. · 검색어 SALES_COMPANY, Sales Company, SALES_PLANT, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록  |
| C-0b94b462a7 | C2 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | SCP0028 그리드에는 Cust Group·End Customer·Sales Site 컬럼이 없습니다. · 검색어 CUST_GROUP, END_CUSTOMER, End Customer, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-264e31a6d1 | B2 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | SCP0028 그리드에는 Cust Group→End Customer→Sales Site 연쇄 콤보가 없습니다. · 검색어 CUST_GROUP, Cust Group, END_CUSTOMER, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e21afde888 | K1 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | SCP0028 그리드에는 Cust Group·End Customer·Sales Site 컬럼과 그 연쇄(cascade) 기능이 없다. · 검색어 CUST_GROUP, END_CUSTOMER, Sales Site, Cust Group: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d41825eba0 | C2 | [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Active 컬럼 | SCP0028에는 Cust Group·End Customer·Sales Site 관계 컬럼이 없습니다. · 검색어 CUST_GROUP, END_CUSTOMER, End Customer, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-89af789c7b | B4 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | SCP0028에는 Team·End Customer·Sales Site 후보 콤보가 없다. · 검색어 DEPT_ID, END_CUSTOMER, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b8b4590a74 | C1 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | SCP0028 에는 Team·End Customer·Sales Site 후보 콤보가 없다. · 검색어 DEPT_ID, Team, END_CUSTOMER, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d06c26d22f | M1 | [DMF0014 결함 일반화] Excel Upload 컬럼명 검증 메시지 · 파일 첨부 개수 | SCP0028에는 Excel Upload가 없어 파일 1개 제한과 컬럼명 안내 문구 대상이 없다. · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-46585778e2 | M1 | [DMF0014 결함 유형] Excel Form 입력 버킷 | SCP0028에는 Excel Form이 없고 조회 조건에 Main Period도 없다. · 검색어 ExcelForm, Excel Form, btnForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-00080fbf16 | M1 | [DMF0014 결함 유형] Excel Form 양식 | SCP0028에는 AS-IS(Designer.cs·.cs)와 TO-BE(shipment-lot-size) 어디에도 Excel Form 버튼이 없고, Excel 다운로드(excelFileName='ShipmentLotSize')만 있다. · 검색어 ExcelForm, Excel Form, btnForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-67fd06422d | B5 | [DMF0003 결함 유형] Measure 콤보(입력 가능 Measure) | SCP0028 에는 입력 가능 Measure 콤보가 없다. · 검색어 VMI In Request, MKT FCST, AS_In_Request, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-daf0b22bf3 | D3 | [DMF0003 결함 유형] Measure 콤보(입력 가능 Measure) | SCP0028 화면에는 Measure 콤보와 VMI Site별 입력 Measure 제한이 없다. · 검색어 MEASURE, VMI, MKT FCST, AS_In_Request: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1f280ad92f | C2 | [DMF0003 결함 유형] Measure 콤보(입력 가능 Measure) | SCP0028에는 Measure 콤보가 없습니다. · 검색어 Measure, MKT_FCST, VMI_IN_REQUEST, AS_IN_REQUEST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8a21d25282 | H2 | [DMF0003 결함 일반화] 실적 구간 배경색 | Shipment Lot Size 에는 실적 구간(과거 기간) 셀이 없다. · 검색어 ACTUAL_WEEK, PLAN_START: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a96e1bffc9 | D2 | [DMF0003 결함 일반화] 실적 구간 배경색 | SCP0028 화면에는 실적(과거 기간) 구간을 나누는 기간 Bucket 컬럼이 없다. · 검색어 실적 구간, BUCKET, Actual, MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8949f3d1e9 | C2 | [DMF0003 결함 유형] AS From Site 입력 후 W35~W38 수량 | SCP0028에는 AS From Site 입력과 주차별 수량 컬럼이 없습니다. · 검색어 AS_FROM_SITE, AS From Site, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-853c0cfa4e | B8 | [DMF0003 결함 일반화] Team 컬럼(MKT FCST 조회·신규행) | SCP0028 그리드에는 Team 컬럼이 없어 SSPM DEPT_ID 로 Team 을 표시할 대상이 없다. · 검색어 DEPT_ID, Team, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fd6956d636 | C3 | [DMF0003 결함 일반화] Team 컬럼(MKT FCST 조회·신규행) | SCP0028 화면에는 Team 컬럼이 없다. · 검색어 Team, SSPM, DEPT_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a8a7b557c1 | A2 | [DMF0003 결함 일반화] Team 컬럼(MKT FCST 조회·신규행) | SCP0028 화면에는 Team 컬럼이 없다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cf049fab71 | M3 | [DMF0003 결함 유형] Model 팝업(sMdmActive_Sw) | SCP0028 의 btnItemId 는 SCM0002_ItembyDivisionPopup 을 Form_Load(true, division, sScmSite, sProject, sItemId) 로 열고 sMdmActive_Sw 는 넘기지 않으며, TO-BE 화면 폴더에도 MDM 중지 코드 조건이 없습니다. · 검색어 sMdmActive_Sw, mdmActiveSw, MdmActive: AS-IS 화면 소스·TO-BE 화면 폴더  |
| C-747cfb8056 | B5 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | SCP0028 에는 FCST Type 콤보와 Measure 입력 제한이 없다. · 검색어 FCST_TYPE, FCST Type, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f783f29944 | D3 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | SCP0028 화면에는 FCST Type 콤보와 Site 유형별 입력 Measure 제한이 없다. · 검색어 FCST Type, FCST_TYPE, MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fbd0530b95 | E1 | [DMF0003 결함 유형] MKT FCST[R+P] 수량 | SCP0028 그리드에는 MKT FCST 수량 컬럼이 없다. · 검색어 MKT_FCST, MKT FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a38aa0a017 | A5 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SCP0028에는 VERSION 컬럼, AS FROM SITE 컬럼, 컬럼셋팅 목록이 없다. · 검색어 AS_FROM_SITE, AS FROM SITE, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c025115802 | K2 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SCP0028에는 컬럼셋팅 목록, VERSION 컬럼, AS FROM SITE 컬럼이 없다. · 검색어 VERSION, AS FROM SITE, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a591ca7b08 | N1 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | SCP0028 화면에는 컬럼셋팅의 AS FROM SITE 컬럼이 없다. · 검색어 AS_FROM_SITE, AS From Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0c22081e2a | E1 | [DMF0082 결함 유형] MKT_FCST[R+P]·AS_In_Request[R+P]·Unit_Price(LOC) | SCP0028 그리드에는 MKT_FCST·AS_In_Request·Unit_Price(LOC) 컬럼이 없다. · 검색어 MKT_FCST, AS_IN_REQUEST, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a8301385a3 | M3 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | SCP0028 에는 Price Batch Input 팝업과 End Customer 컬럼이 없다. · 검색어 Price Batch, PriceBatch, End Customer, END_CUSTOMER: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b596200287 | H3 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | 이 화면에는 Price Batch Input 팝업과 End Customer 컬럼이 없다. · 검색어 End Customer, END_CUSTOMER, Price Batch: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-79f22ec67c | G4 | [DMF0082 결함 유형] Price Batch Input 팝업 Model 조건 · End Customer 병합 | 이 화면에는 Price Batch Input 팝업과 End Customer 컬럼이 없다. · 검색어 Price Batch, End Customer, END_CUSTOMER: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8873c4ab1e | H3 | [DMF0082 결함 유형] 셀병합(Unit Price Currency 등) | 이 화면에는 Unit Price·Currency 컬럼이 없다. · 검색어 Unit Price, CURRENCY, Currency: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-66cb60b962 | M3 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SCP0028 에는 Exchange Rate 팝업이 없고 팝업 붙여넣기 저장도 없다. · 검색어 Exchange Rate, ExchangeRate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-924a5fdd8d | F4 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SCP0028에는 Exchange Rate 팝업이 없습니다. · 검색어 Exchange Rate, EXCHANGE_RATE, ExchangeRate: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-591e3170b0 | F3 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SCP0028에는 Exchange Rate 팝업이 없습니다. · 검색어 Exchange Rate, EXCHANGE_RATE, ExchangeRate: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-af56acddc2 | F1 | [DMF0082 결함 유형] Exchange Rate 팝업 저장 | SCP0028 의 팝업은 SCM0002 Item·Shipment Lot Size 팝업이고 Exchange Rate 팝업은 없다. · 검색어 Exchange Rate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-315ce1de99 | M2 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | SCP0028 화면에는 BPS I/F 버튼과 환율 반영 기능이 없다. · 검색어 BPS I/F, btnBps, ExchangeRate: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c1e1b2fe02 | F1 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | SCP0028 에는 BPS I/F 버튼과 환율 반영 기능이 없습니다. · 검색어 BPS, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0fc71b6f1c | A5 | [DMF0082 결함 유형] BPS I/F 버튼 · Last Update Date/By 컬럼 | SCP0028에는 BPS I/F 버튼과 환율 반영 기능이 없다. · 검색어 BPS I/F, BPS, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5dd1cba597 | E4 | [DMF0082 결함 유형] Biz Type 미존재 검증 팝업 메시지 | SCP0028에는 Biz Type 미존재 검증이 없다. · 검색어 Biz Type, BIZ_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4175ddc3dc | E4 | [DMF0082 결함 유형] MKT FCST 수량 입력 시 Unit Price 필수 | SCP0028에는 MKT FCST 수량과 Unit Price 컬럼이 없다. · 검색어 MKT_FCST, MKT FCST, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3e0e778477 | K2 | [DMF0082 결함 일반화] 필수 컬럼(Project Code·Plant Site) 표시 · 저장 | SCP0028에는 개인화 컬럼 구성이 없어, Div를 바꿀 때 필수 컬럼을 자동으로 추가하는 동작도 없다. · 검색어 USER_SELECTED_FLAG, ColumnSetting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4813bc3f6c | F6 | [DMF0082 결함 일반화] 필수 컬럼(Project Code·Plant Site) 표시 · 저장 | SCP0028 에는 Project Code 와 Plant Site 필수 컬럼이 없다. · 검색어 PROJECT_CODE, PLANT_SITE, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7076fcb0e2 | A5 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SCP0028에는 Measure 셋팅과 VMI·MKT FCST AMT 메저가 없다. · 검색어 Measure, VMI, MKT FCST AMT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d6d5c36a0a | K2 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SCP0028에는 Measure 셋팅과 VMI·MKT FCST AMT Measure가 없다. · 검색어 Measure, VMI, MKT FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-58c37c1108 | N1 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST AMT) | SCP0028 화면에는 Measure 셋팅과 VMI 메저가 없다. · 검색어 Measure, VMI, MKT FCST AMT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cc039f0929 | J3 | [DMF0082 결함 유형] SCM_FCST·MKT_FCST 편집 구간(GET_ADMIN_GROUP_MEASURE) | SCP0028 에는 SCM_FCST·MKT_FCST Measure 행이 없어 GET_ADMIN_GROUP_MEASURE 기준의 시간대별 편집 구간을 확인할 대상이 없습니다. · 검색어 SCM_FCST, MKT_FCST, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b7f43020bd | B5 | [DMF0082 결함 유형] SCM_FCST·MKT_FCST 편집 구간(GET_ADMIN_GROUP_MEASURE) | SCP0028 에는 SCM_FCST·MKT_FCST 편집 구간이 없다. · 검색어 GET_ADMIN_GROUP_MEASURE, MKT_FCST, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-bc78a42f45 | D2 | [DMF0082 결함 유형] SCM_FCST·MKT_FCST 편집 구간(GET_ADMIN_GROUP_MEASURE) | SCP0028 화면에는 GET_ADMIN_GROUP_MEASURE 룩업 기반 Measure 편집 통제가 없다. · 검색어 SCM_FCST, MKT_FCST, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-28339ccfe9 | J3 | [DMF0082 결함 유형] MKT_FCST[R+P] 편집 | SCP0028 의 AS-IS 소스와 TO-BE shipment-lot-size 폴더에는 MKT_FCST Measure 와 GET_ADMIN_GROUP_MEASURE 룩업이 없고, 그리드 컬럼은 Lot Size·Increment·Active·Container Split 입니다. · 검색어 MKT_FCST, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-38e2fd3908 | D2 | [DMF0082 결함 유형] MKT_FCST[R+P] 편집 | SCP0028 화면에는 MKT_FCST[R+P] Measure도 DM Planner 시간대 편집 통제도 없다. · 검색어 MKT_FCST, DM Planner, GET_ADMIN_GROUP_MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-28bd91645b | N1 | [DMF0007 결함 유형] Customer FCST Master 기준정보 | SCP0028 화면은 Customer FCST Master 기준정보를 쓰지 않는다. · 검색어 DM_MST_CUSTOMER_FCST, CUSTOMER_FCST, Customer FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-897d9b209f | A1 | [DMF0007 결함 유형] Customer FCST Master 기준정보 | SCP0028 화면은 Shipment Lot Size 기준정보를 다루고, Customer FCST Master 기준정보는 다루지 않는다. · 검색어 Customer FCST, CUSTOMER_FCST, FCST Master: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5beb3c5c92 | B4 | [DMF0004 결함 유형] Sales Site 조회조건 표시값 | SCP0028 조회조건에는 Sales Site 가 없다. · 검색어 Sales Site, SalesSite, SiteByEndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9c53b0a219 | E1 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | SCP0028에는 RTF×Unit Price 계산값 컬럼이 없고 Lot Size·Increment 입력만 있다. · 검색어 UNIT_PRICE, Unit Price, RTF: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-70bd83a74d | E4 | [DMF0044 결함 유형] 저장 자릿수 · 계산값(RTF×Unit Price) 초과 메시지 | SCP0028에는 RTF×Unit Price 계산값 컬럼이 없다. · 검색어 RTF, UNIT_PRICE, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c1feb89f3c | K4 | [DMF0020 결함 일반화] Condition(F6) 저장 · Sales Report ETC Insert 기능 | SCP0028 조회조건은 Division·Operation Group·From Site·To Site·Trans Mode·Model·Valid 이고 Period 조건이 없다. · 검색어 Period, FromDate, dtpFrom: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1e678a3a05 | E4 | [DMF0044 결함 유형] Cell Prod Site 검증 · Application Gr·Country Name | SCP0028에는 Cell Prod Site·Application Gr·Country Name 컬럼이 없다. · 검색어 Cell Prod Site, CELL_PROD, Application Gr: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-94d750646d | F1 | [DMF0044 결함 유형] Cell Prod Site 검증 · Application Gr·Country Name | SCP0028 에는 Cell Prod Site·Application Gr·Country Name 컬럼이 없다. · 검색어 Cell Prod Site, CELL_PROD, Application Gr, Country Name: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fd8a5e6b82 | C1 | [DMF0044 결함 유형] 조회조건 Report Type→Data Type | SCP0028 에는 Report Type·Data Type 조회조건이 없다. · 검색어 cboReportType, REPORT_TYPE, cboDataType, DATA_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-32fdecef94 | K4 | [DMF0044 결함 유형] Delete 버튼 | SCP0028 에는 Cutoff Data 구분이 없어 Cutoff Data 일 때 Delete 버튼을 숨기는 조건도 없다. · 검색어 Cutoff, CUTOFF, Cut Off: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d33051b5da | J2 | [DMF0044 결함 유형] Delete 버튼 | SCP0028 에는 Cutoff Data 구분이 없어 Cutoff Data 일 때 Delete 버튼을 숨기는지 확인할 대상 기능이 없습니다. · 검색어 Cutoff, CUTOFF_YN, Cutoff Data: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c8912642ed | F1 | [DMF0044 결함 유형] Biz Plan Cutoff Data 저장 값 | SCP0028 에는 Biz Plan Cutoff Data 저장 기능이 없다. · 검색어 Biz Plan, Cutoff, CUTOFF: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4cd94d7e36 | D2 | [DMF0044 결함 유형] 입력 가능 Measure(Business Plan·Unit Price(LOC)) | SCP0028 화면에는 Business Plan·Unit Price(LOC) Measure가 없다. · 검색어 Business Plan, Unit Price, MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-02b9b29a9b | G5 | [DMF0044 결함 유형] Version 팝업 Div 조건 | SCP0028 에는 Version 팝업이 없다. · 검색어 VersionPopup, cboVersion, Version: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e4dfc543bb | E4 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | SCP0028에는 하단 Owner 그리드가 없고 그리드는 spdMain 하나뿐이다. · 검색어 OWNER, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c0d17591ca | F1 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | SCP0028 은 단일 그리드(spdMain) 화면이라 하단 Owner 그리드와 상단 더블클릭 연동이 없습니다. · 검색어 OWNER, Owner: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2ca357f85d | C5 | [DMF0005 결함 유형] 하단 Grid Owner 다건 · 상단 더블클릭 하단 조회 | SCP0028 화면에는 하단 Owner 그리드가 없고, 상단 그리드를 더블클릭해 하단을 조회하는 동작도 없다. · 검색어 Owner, OWNER, DoubleClick: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0b21f4dbea | D1 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | SCP0028에는 Exchange Rate·Currency 컬럼이 없고, Insert 버튼은 무동작이며 Delete 버튼은 신규행만 지우는 구조라 이 결함 유형의 대상 기능이 없다. · 검색어 EXCHANGE_RATE, CURRENCY_CODE, Exchange Rate: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-234c6183ab | D6 | [DMF0042 결함 유형] Exchange Rate Currency · 중복 Keyset 메시지 · Insert 위치 · Delete 버튼 | SCP0028 에는 Exchange Rate 와 Currency 컬럼이 없다. · 검색어 Exchange Rate, EXCHANGE_RATE, CURRENCY, KRW: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-152b13de1e | A5 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | SCP0028 조회조건은 Division·Operation Group·From Site·To Site·Trans Mode·Model·Valid 이고 Cust Group 조회조건은 없다. · 검색어 CUST_GROUP, Cust Group, cboCustGroup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-08c47687f8 | G4 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | 이 화면에는 Cust Group 조회조건이 없다. · 검색어 Cust Group, CUST_GROUP, cboCustGroup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-554bf575c5 | G1 | [DMF0005 결함 유형] Cust Group 조회조건 · Div 파라미터 · 그리드 헤더 | SCP0028에는 Cust Group 조회조건이 없고, 그리드 헤더도 Division에 따라 다시 구성되지 않습니다. · 검색어 CUST_GROUP, Cust Group, CustGroup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4d71243994 | M3 | [DMF0005 결함 유형] Owner 팝업(PKG_COM0000 COM0004/0006) User 조회조건 | SCP0028 에는 Owner 팝업(PKG_COM0000 COM0004/0006)과 User 조회조건이 없습니다. · 검색어 COM0004, COM0006, OwnerPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5fcf467925 | G1 | [DMF0005 결함 유형] Owner 팝업(PKG_COM0000 COM0004/0006) User 조회조건 | SCP0028에는 Owner 팝업(COM0004/COM0006)이 없고, 화면 팝업은 Item 팝업과 Input 일괄입력 팝업 두 개입니다. · 검색어 PKG_COM0000, COM0004, COM0006, OwnerPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-43d8bc1c87 | M2 | [DMF0042 결함 유형] Replace 버튼 팝업 Period·조회 | SCP0028 화면에는 Replace 버튼과 Period 조건을 가진 팝업이 없다. · 검색어 btnReplace, ReplacePopup, Period: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-21e4cfb3b3 | G5 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | SCP0028 에는 Ver.Cutoff 팝업이 없다. · 검색어 Cutoff, Ver.Cutoff, VersionCutoff: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5de46ee5be | G4 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | 이 화면에는 Ver.Cutoff 팝업과 Period 조회조건이 없다. · 검색어 Cutoff, VER_CUTOFF, Ver.Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-436ad2beff | H6 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | SCP0028 화면에는 Ver.Cutoff 팝업과 그 팝업의 Period·Description 조회조건이 없다. · 검색어 Cutoff, VerCutoff, Ver.Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fbc1c3b425 | H4 | [DMF0042 결함 유형] Ver.Cutoff 팝업 Period·Description·Div/Type 조회조건 | 이 화면에는 Ver.Cutoff 팝업과 Period·Description 조회조건이 없습니다. · 검색어 CUTOFF, Ver.Cutoff, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5777090731 | H6 | [DMF0042 결함 유형] Cutoff 완료 후 버전 팝업 | 이 화면에는 Cutoff 기능과 버전 팝업이 없습니다. · 검색어 Cutoff, VersionPopup, VersionModal: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-bf34b06843 | D1 | [DMF0042 결함 유형] Team·End Customer·Energy(WH) 컬럼 | SCP0028 그리드에는 Team·End Customer·Energy(WH) 컬럼이 없고, 컬럼은 Div·Operation Group·From Site·To Site·Model·Trans Mode·Lot Size·Increment·Active·Container Split과 감사 컬럼뿐이다. · 검색어 END_CUSTOMER, ENERGE, End Customer, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파 |
| C-5befc440ce | C3 | [DMF0042 결함 유형] Team·End Customer·Energy(WH) 컬럼 | SCP0028 화면에는 Team·End Customer·Energy(WH) 컬럼이 없다. · 검색어 END_CUSTOMER, ENERGE, Energy, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fd2d287883 | M3 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SCP0028 에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 Version Create, BP Version, VersionCreate: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cc2514f8cd | M2 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SCP0028 화면에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 BP Version, Version Create, VersionCreate, cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8e53fe57c1 | E4 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SCP0028에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 Version Create, BP_VERSION, Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f82ab5b211 | F1 | [DMF0044 결함 유형] BP Version 팝업 Version Create | SCP0028 에는 BP Version 팝업과 Version Create 기능이 없다. · 검색어 Version Create, BP Version, Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-de216c0306 | B3 | [DMF0049 결함 유형] 버전 팝업 Version 목록 정렬 | SCP0028에는 버전 팝업과 Version 목록이 없습니다. · 검색어 VERSION_ID, VersionPopup, Version Popup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-13906f0adf | M3 | [DMF0049 결함 유형] 버전 팝업 Version 목록 정렬 | SCP0028 에는 Version 팝업이 없다. · 검색어 VersionPopup, cboVersion, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a876ea6f7b | G4 | [DMF0049 결함 유형] Version 조회조건 선택값 표시 | 이 화면에는 Version 조회조건이 없다. · 검색어 cboVersion, VERSION_ID, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-45d8531a1d | G7 | [DMF0049 결함 유형] Version 조회조건 선택값 표시 | SCP0028 에는 Version 조회조건이 없다. · 검색어 cboVersion, Version: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5b5d2ef1b0 | D1 | [DMF0049 결함 유형] Cell Model·Cell Model Info 컬럼 | SCP0028 그리드에는 Cell Model·Cell Model Info 컬럼이 없다. · 검색어 CELL_MODEL, Cell Model Info, Cell Model: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-93837cfe44 | I2 | [DMF0014 결함 유형] Team 명칭 데이터 | SCP0028에는 Team 명칭 데이터를 보여 주는 조건이나 컬럼이 없다. · 검색어 TEAM_CODE, TEAM_NAME, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3936d67825 | B4 | [DMF0014 결함 유형] Team 조회조건 후보 | SCP0028에는 Team 조회조건이 없다. · 검색어 DEPT_ID, Team, cboTeam: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f627415513 | J1 | [DMF0014 결함 유형] Team 조회조건 후보 | SCP0028 에는 Team 조회조건이 없어 사업부별 Team 후보 확인은 대상 기능이 없습니다. · 검색어 Team, TEAM_ID, cboTeam: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3f216c868b | G1 | [DMF0020 결함 유형] Biz.Type 조회조건 | SCP0028에는 Biz.Type 조회조건이 없습니다. · 검색어 BIZ_TYPE, Biz.Type, Biz Type: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f9757446fe | G2 | [DMF0020 결함 유형] Price Batch Input 팝업 Sales Site 조건 | SCP0028 에는 Price Batch Input 팝업과 Sales Site 조건이 없다. · 검색어 SALES_SITE, Sales Site, Price Batch: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-850738a2a5 | M3 | [DMF0020 결함 유형] Price Batch Input 팝업 Sales Site 조건 | SCP0028 에는 Price Batch Input 팝업과 Sales Site 조건이 없다. · 검색어 Price Batch, PriceBatch, SALES_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-29aae37ba1 | G5 | [DMF0044 결함 유형] 팝업 Period | SCP0028 의 메인 화면과 팝업에는 Period 조건이 없다. · 검색어 Period, dtpPeriod, PeriodPicker: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f831d703e9 | M1 | [DMF0014 결함 유형] Excel Form 버튼 | SCP0028에는 Excel Form 버튼이 없고 조회 조건에 Period도 없다. · 검색어 ExcelForm, Excel Form, btnForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6d5503f374 | M1 | [DMF0014 결함 유형] Excel Upload OK·Customs Handbook/Project/Model 검증 | SCP0028에는 Excel Upload가 없어 OK 저장과 Customs Handbook/Project/Model 검증 대상이 없다. · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-df0b709d03 | F4 | [DMF0014 결함 유형] Excel Upload OK·Customs Handbook/Project/Model 검증 | SCP0028에는 Excel Upload 기능과 Customs Handbook·Project 항목이 없고, TO-BE 설정도 upload:false입니다. · 검색어 ExcelUpload, Customs Handbook, CUSTOMS_HANDBOOK: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fa41a26f9e | E3 | [DMF0014 결함 유형] Excel Upload OK·Customs Handbook/Project/Model 검증 | SCP0028에는 Excel Upload 기능과 Customs Handbook·Project 컬럼이 없다. · 검색어 CUSTOMS_HANDBOOK, Customs Handbook, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cb7f36ae53 | M1 | [DMF0014 결함 유형] Excel Upload 수량 미입력 메시지 | SCP0028에는 Excel Upload가 없어 수량 미입력 메시지 대상이 없다. · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d0dbc5763a | M1 | [DMF0014 결함 일반화] Excel Upload 헤더 검증 메시지 | SCP0028에는 Excel Upload가 없어 헤더 검증 메시지 대상이 없다. · 검색어 ExcelUpload, Excel Upload, Invalid Column Header Title: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-66ac7d776f | M1 | [DMF0014 결함 일반화] Excel Upload Validation 메시지(Sales Site/Project/Model) | SCP0028에는 Excel Upload가 없어 Sales Site/Project/Model 업로드 검증 메시지 대상이 없다. · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a57ca265d6 | E4 | [DMF0014 결함 일반화] Excel Upload Validation 메시지(Sales Site/Project/Model) | SCP0028에는 Excel Upload 기능이 없다(AS-IS 소스에 Upload가 0건이고 TO-BE 설정은 upload: false). · 검색어 ExcelUpload, UploadExcel, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b76a75ecae | M1 | [DMF0074 결함 유형] Excel Form 버튼 | SCP0028에는 Excel Form 버튼이 없다. · 검색어 ExcelForm, Excel Form, btnForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6eb98a3779 | M1 | [DMF0074 결함 유형] Excel Form 양식 헤더 | SCP0028에는 Excel Form 양식 다운로드 기능이 없어 2단 헤더 양식 확인 대상이 없다. · 검색어 ExcelForm, Excel Form, btnForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fcb5b0f8d4 | M1 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Validation 메시지 | SCP0028은 TO-BE 버튼 설정이 upload: false이고 AS-IS에도 Excel Upload가 없어 Key·Period From/To 업로드 대상이 없다. · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7d1cbad785 | F1 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Validation 메시지 | SCP0028 에는 Excel Upload 기능과 Period From/To 컬럼이 없고 BTN:EXCEL 은 내려받기 버튼이다. · 검색어 Excel Upload, Period From, PERIOD_FROM: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7dbd99bbd7 | E4 | [DMF0074 결함 유형] Excel Upload Key 영역·Period From/To 컬럼·Validation 메시지 | SCP0028에는 Excel Upload와 Period From/To 컬럼이 없다. · 검색어 ExcelUpload, Excel Upload, PERIOD_FROM, Period From: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cbc256090e | M1 | [DMF0082 결함 유형] Excel Form 양식 Bucket | SCP0028에는 Excel Form 양식이 없고 그리드에 M0~M12 Bucket 컬럼도 없다. · 검색어 ExcelForm, Excel Form, btnForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-92ff92ce0e | D1 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SCP0028에는 ETC 입력의 Team·Measure 컬럼이 없다. · 검색어 SALES_AMT, TEAM_CODE, Sales AMT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-be1437dd77 | B4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SCP0028에는 ETC 입력의 Team·Measure 컬럼이 없다. · 검색어 DEPT_ID, Sales AMT, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4103926c5e | E3 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SCP0028 그리드에는 ETC 입력 Team·Measure 컬럼이 없다. · 검색어 DEPT_ID, Team, Sales AMT, MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-19b84a523e | D4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | SCP0028 에는 ETC 입력과 Team·Measure 컬럼이 없다. · 검색어 SSPM, Measure, MEASURE, TEAM_: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3b01774743 | A1 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | SCP0028 화면에는 Dynamic Query 기능이 없다. · 검색어 Dynamic Query, DynamicQuery, ESS KWh: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e47d4466a3 | H4 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | 이 화면에는 Dynamic Query 조회 기능이 없습니다. · 검색어 DynamicQuery, DYNAMIC_QUERY, KWh: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e6a219e61e | F4 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 계산 등) | SCP0028에는 Dynamic Query 기능이 없습니다. · 검색어 Dynamic Query, DynamicQuery, KWh: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f37cad2bda | H6 | [SYS0012 결함 유형] Reject 팝업 | 이 화면에는 Reject 팝업이 없습니다. · 검색어 RejectPopup, RejectModal, Reject: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-031cb3deb1 | F8 | [SYS0012 결함 유형] Request 데이터 Reject Reason·Request Date | SCP0028에는 Reject Reason·Request Date 컬럼도 재요청 흐름도 없습니다. · 검색어 REJECT_REASON, Reject Reason, REQUEST_DATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-750505655d | B4 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SCP0028에는 Approval Result 조회조건이 없다. · 검색어 APPROVAL_RESULT, Approval Result: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e7d2389ee7 | B6 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SCP0028 조회조건에는 Approval Result 콤보가 없다. · 검색어 Approval Result, APPROVAL_RESULT, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cfa323faae | I2 | [SYS0012 결함 유형] Approval Result 조회조건 콤보 | SCP0028 조회조건에는 Approval Result 콤보가 없다. · 검색어 APPROVAL_RESULT, Approval Result, Requesting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a805c40009 | D5 | [SYS0003 결함 유형] Menu Type·Auth Unit 컬럼 | SCP0028 에는 Menu Type·Auth Unit 컬럼이 없다. · 검색어 Menu Type, MENU_TYPE, Auth Unit, AUTH_UNIT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2635fdd892 | G4 | [DMF0040 결함 유형] Version 조회조건 크기 | 이 화면에는 Version 조회조건이 없다. · 검색어 cboVersion, VERSION_ID, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8abf72e918 | H5 | [DMF0040 결함 유형] Measure Version(A)/Version(B) 명칭 | SCP0028 에는 Version(A)/Version(B) Measure 가 없습니다. · 검색어 Version(A), Version(B), VERSION_A: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6172b455f8 | A9 | [DMF0040 결함 유형] Measure Version(A)/Version(B) 명칭 | SCP0028에는 Measure Version(A)/Version(B) 명칭 표시 기능이 없습니다. · 검색어 Version(A), Version(B), MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-dfd3ef131b | H2 | [DMF0040 결함 유형] 실적 구간 배경색 | Shipment Lot Size 는 기간 컬럼이 없는 마스터 화면이라 실적 구간이 없다. · 검색어 ACTUAL_WEEK, PLAN_START: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-303fb67b83 | K2 | [DMF0042 결함 유형] Column Setting 팝업 Default 버튼 | SCP0028에는 Column Setting 팝업과 그 팝업의 Default 버튼이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-012d64f05f | C2 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | SCP0028 그리드에는 End Customer·Sales Site 셀이 없습니다. · 검색어 END_CUSTOMER, End Customer, SALES_SITE, Sales Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ca370c0667 | C3 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | SCP0028 화면에는 Sales Site·End Customer 셀이 없다. · 검색어 Sales Site, END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-87bd4ccaec | D1 | [DMF0042 결함 유형] Sales Site·End Customer 셀 | SCP0028 그리드에는 Sales Site·End Customer 셀이 없다. · 검색어 SALES_SITE, END_CUSTOMER, Sales Site, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d24898fd14 | G4 | [DMF0044 결함 유형] Year 조회조건 | 이 화면에는 Year 조회조건이 없다. · 검색어 cboYear, YEAR, Year: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-41d7086dd8 | G6 | [DMF0044 결함 유형] Year 조회조건 | SCP0028 에는 Year 조회조건이 없다. · 검색어 cboYear, Year: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-00c15b67d0 | A5 | [DMF0044 결함 유형] Measure 항목 구성 | SCP0028 은 Lot Size·Increment 마스터 그리드 화면이고 Measure 항목 구성이 없다. · 검색어 Measure, MEASURE_ID, MeasureSetting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b94d433b61 | N1 | [DMF0044 결함 유형] Measure 항목 구성 | SCP0028 화면에는 Measure 항목이 없다. · 검색어 Measure, MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b9556dfdb9 | B5 | [DMF0044 결함 유형] Measure 항목 구성 | SCP0028 에는 Measure 항목이나 UI Category 기준 Measure 구성이 없다. · 검색어 MEASURE, Measure, UI_CATEGORY: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-21343b3c3f | M3 | [DMF0005 결함 유형] Owner 팝업 사용자 목록 | SCP0028 에는 Owner 팝업이 없다. · 검색어 OwnerPopup, Owner, SSO_USER: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e0b16e7856 | B4 | [DMF0005 결함 유형] Owner 팝업 사용자 목록 | SCP0028에는 Owner 사용자 팝업이 없고, 팝업은 Model(btnItemId) 팝업과 Shipment Lot Size 팝업 두 개다. · 검색어 OWNER_ID, SSO_USER, SCM_ADM_USER_M: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4cd10e2d93 | A5 | [DMF0020 결함 유형] Div별 컬럼 구성(COL_LIST 등) | SCP0028에는 COL_LIST와 컬럼셋팅 기반 컬럼 구성이 없다. · 검색어 COL_LIST, ColumnSetting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cc7334a5c1 | K2 | [DMF0020 결함 유형] Div별 컬럼 구성(COL_LIST 등) | SCP0028에는 Div별 컬럼셋팅 구성과 COL_LIST 컬럼이 없다. · 검색어 COL_LIST, ColumnSetting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a7d9514f6c | D2 | [DMF0021 결함 유형] Partial 주차 편집 구간·실적 구분선 | SCP0028 Shipment Lot Size 화면은 주차 Bucket 그리드와 실적 구분선이 없는 마스터 화면이다. · 검색어 Partial 주차, 실적 구분선, BUCKET, MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9fdc53246a | H2 | [DMF0021 결함 유형] Partial 주차 편집 구간·실적 구분선 | 이 화면에는 주차·파셜 구간 컬럼이 없다. · 검색어 PARTIAL_WEEK, 실적 구분선: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8c1b65d253 | E4 | [DMF0082 결함 유형] Unit Price(LOC) 52주 Validation | SCP0028에는 Unit Price(LOC) 52주 컬럼이 없다. · 검색어 UNIT_PRICE, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-28b7184d02 | F1 | [DMF0082 결함 유형] Unit Price(LOC) 52주 Validation | SCP0028 에는 Unit Price(LOC) 컬럼과 52주 판가 Validation 이 없습니다. · 검색어 UNIT_PRICE, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-91716a3612 | B5 | [DMF0003 결함 유형] 신규 행 Measure 후보 | SCP0028 의 신규 행(Insert)에는 Measure 후보 컬럼이 없다. · 검색어 MKT_FCST, VMI_In_Request, AS_In_Request: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2096f45f93 | C2 | [DMF0003 결함 유형] 신규 행 Measure 후보 | SCP0028 신규 행에는 Measure 후보가 없습니다. · 검색어 Measure, MKT_FCST, VMI_IN_REQUEST, AS_IN_REQUEST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-bd6d250804 | D3 | [DMF0003 결함 유형] 신규 행 Measure 후보 | SCP0028 화면의 신규 행에는 Measure 후보 컬럼이 없다. · 검색어 MEASURE, MKT_FCST, VMI_In_Request, AS_In_Request: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-19a640bf7b | A5 | [DMF0003 결함 유형] Measure 컬럼 | SCP0028 메인 그리드는 Div·Model·Lot Size·Increment 같은 고정 컬럼만 있고 Measure 컬럼이 없다. · 검색어 Measure, MEASURE_ID, USER_SELECTED_FLAG: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f96da40851 | B5 | [DMF0003 결함 유형] FCST Type 후보 | SCP0028 에는 FCST Type 후보 콤보가 없다. · 검색어 FCST_TYPE, FCST Type, WS(Free): AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6963bfc82c | J1 | [DMF0003 결함 유형] FCST Type 후보 | SCP0028 에는 FCST Type 조회조건이 없어 Div 별 FCST Type 후보 확인은 대상 기능이 없습니다. · 검색어 FCST_TYPE, FCST Type, WS(Free), Chargeable: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-05660a50f9 | A5 | [DMF0082 결함 유형] 조회 그리드 컬럼 구성 | SCP0028은 조회 컬럼을 고정 목록으로 그리고, 컬럼셋팅 설정값으로 그리는 기능이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7c5fb07198 | K2 | [DMF0082 결함 유형] 조회 그리드 컬럼 구성 | SCP0028 조회 그리드는 고정 컬럼(LOT_SIZE_COLUMNS)으로 그려지며 컬럼셋팅 설정값을 쓰지 않는다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e27c7ba144 | G2 | [DMF0040 결함 유형] End Customer 다중 선택 조회조건 | SCP0028 조회조건에 End Customer 가 없다. · 검색어 END_CUSTOMER, End Customer, EndCustomer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1bd9f88d19 | I3 | [DMF0040 결함 유형] Team 조회조건 vs 결과 컬럼 언어 | SCP0028 의 AS-IS 소스와 TO-BE 화면 폴더에 Team 조회조건과 Team 결과 컬럼이 없어 '조건·결과 모두 영문' 확인은 대상 기능이 없습니다. · 검색어 Team, TEAM_ID, TEAM_NAME, cboTeam: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-67f48c36b9 | I2 | [DMF0040 결함 유형] Team 조회조건 vs 결과 컬럼 언어 | SCP0028에는 Team 조회조건도 Team 결과 컬럼도 없다. · 검색어 TEAM_CODE, TEAM_NAME, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ef0e073b29 | G1 | [DMF0040 결함 유형] Owner 조회조건 | SCP0028 조회영역에는 Owner 조회조건이 없습니다. · 검색어 OWNER_ID, Owner, cboOwner: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-11760a7eb8 | K2 | [DMF0040 결함 유형] Column Setting 저장·Default | SCP0028에는 Column Setting 팝업의 저장·Default 기능이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3682dd9227 | G4 | [DMF0040 결함 유형] Ver. 조회조건 기본값 | 이 화면에는 Ver. 조회조건이 없다. · 검색어 cboVersion, VERSION_ID, txtVersion: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f453587cb5 | G6 | [DMF0040 결함 유형] Ver. 조회조건 기본값 | SCP0028 에는 Ver. 조회조건이 없다. · 검색어 cboVersion, Version, Ver.: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1e8814536a | G1 | [DMF0040 결함 유형] Plant Site 조회조건 | SCP0028에는 Plant Site 조회조건이 없고, 사이트 조건은 From Site·To Site입니다. · 검색어 PLANT_SITE, Plant Site, PlantSiteId: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-76435a7633 | K2 | [DMF0040 결함 유형] Measure Setting 버튼 | SCP0028 버튼은 SEARCH·SAVE·INSERT·DELETE·INPUT·EXCEL·RESET·ITEMID뿐이고 Measure Setting 버튼은 없다. · 검색어 Measure, MeasureSetting, Measure Setting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2881e600d5 | J2 | [DMF0040 결함 유형] Measure Setting 버튼 | SCP0028 의 AS-IS·TO-BE 에 Measure Setting 버튼이 없어 버튼 제거 확인은 대상 기능이 없습니다. · 검색어 Measure Setting, MeasureSetting, btnMeasure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-be46ace9c2 | G4 | [DMF0040 결함 유형] Plant Site 조회조건 | 이 화면에는 Plant Site 조회조건이 없고 From Site·To Site만 있다. · 검색어 Plant Site, PLANT_SITE, cboPlantSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9cfd9cad3e | K2 | [DMF0053 결함 일반화] Column Setting 필수 컬럼 표시·Div 전환 End Customer | SCP0028에는 컬럼셋팅 팝업과 END_CUSTOMER 컬럼이 없다. · 검색어 USER_SELECTED_FLAG, ColumnSetting, 컬럼셋팅, END_CUSTOMER: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f4fed4df04 | B4 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | SCP0028에는 Biz Type 조회조건이 없고, Plant Site 조건(clbPlantSite)은 AS-IS 소스에서 주석 처리돼 있다. · 검색어 BIZ_TYPE, Biz Type: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3b8df87f8e | G1 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | SCP0028에는 Biz Type·Plant Site 조회조건이 없습니다. · 검색어 BIZ_TYPE, Biz Type, Plant Site: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d2f55b1fe2 | M3 | [DMF0053 결함 유형] 팝업 Filter 텍스트 입력창 | SCP0028 의 Model 팝업과 Input/Delete 팝업에는 Filter 텍스트 입력창이 없다. · 검색어 txtFilter, filterText: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a268d165d3 | D2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0028 화면에는 MKT_FCST·SCM_FCST·AS_In_Req·VMI_In_Req Measure와 AS From Site 콤보가 없다. · 검색어 MKT_FCST, SCM_FCST, AS_In_Req, VMI: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-89c4e20207 | J3 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0028 에는 Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)와 AS From Site 콤보가 없습니다. · 검색어 AS_IN_REQ, VMI_IN_REQ, MKT_FCST, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4705ef2a1d | D3 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0028 화면에는 Current 버전 입력 Measure와 AS From Site 콤보가 없다. · 검색어 MKT_FCST, SCM_FCST, AS_In_Req, VMI: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e85b882746 | B5 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0028 에는 Current 버전 입력 Measure와 AS From Site 콤보가 없다. · 검색어 MKT_FCST, SCM_FCST, AS_In_Req, VMI_In_Req: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2ed591120e | B4 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0028 에는 Current 버전 Measure 입력(MKT_FCST·SCM_FCST·AS_In_Req·VMI_In_Req)과 AS From Site 콤보가 없다. · 검색어 MKT_FCST, AS_IN_REQ, VMI_IN_REQ, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ef4f1d511f | C2 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit Price·AS_In_Req·VMI_In_Req)·AS From Site 콤보 | SCP0028에는 Measure 입력과 AS From Site 콤보가 없습니다. · 검색어 MKT_FCST, AS_FROM_SITE, AS From Site, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4c4f27bc65 | B5 | [DMF0082 결함 유형] FCST Type 후보 | SCP0028 에는 SALES_TYPE_CODE 기준 FCST Type 후보가 없다. · 검색어 SALES_TYPE_CODE, FCST_TYPE, FCST Type: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-510cf4ddb0 | B4 | [DMF0082 결함 유형] FCST Type 후보 | SCP0028에는 FCST Type 후보 콤보가 없다. · 검색어 FCST_TYPE, SALES_TYPE_CODE, FCST Type: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-530dc978e4 | D2 | [DMF0082 결함 유형] Daily Bucket 편집 Measure | SCP0028 화면에는 Daily Bucket과 Measure별 편집 구분이 없다. · 검색어 Daily, BUCKET, Unit Price, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fdce070755 | D2 | [DMF0082 결함 유형] Monthly Bucket 편집 구간 | SCP0028 화면에는 Monthly Bucket 편집 구간과 Unit Price(LOC) Measure가 없다. · 검색어 Monthly, BUCKET, MKT_FCST, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3ce1cbde54 | E4 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site ID | SCP0028에는 MKT_FCST·Unit Price(LOC)·Plant Site ID 컬럼이 없다. · 검색어 MKT_FCST, PLANT_SITE_ID, Unit Price: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-674906a770 | N1 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site ID | SCP0028 화면에는 MKT_FCST 컬럼과 Unit Price(LOC) 컬럼이 없다. · 검색어 MKT_FCST, Unit Price, PLANT_SITE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-22a44d9bb3 | F1 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site ID | SCP0028 에는 MKT_FCST·Unit Price(LOC) 조건부 필수와 Plant Site ID 컬럼이 없다. · 검색어 MKT_FCST, Unit Price, PLANT_SITE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e981cd0365 | D2 | [DMF0082 결함 유형] Bucket 유형별 MKT_FCST·Unit Price(LOC) 편집 구간 | SCP0028 화면에는 Bucket 유형별 MKT_FCST·Unit Price(LOC) 편집 구간이 없다. · 검색어 MKT_FCST, Unit Price, BUCKET, W+0: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9422889079 | F4 | [DMF0082 결함 유형] Bucket 전환 후 저장 | SCP0028에는 Bucket 전환 기능이 없습니다. · 검색어 Bucket, cboBucket, BUCKET: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8695fd187b | M2 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SCP0028 AS-IS 소스와 TO-BE 화면 폴더에 Exchange Rate 팝업이 없고, 이 화면의 팝업은 일괄입력/삭제 팝업(SCM0002_ShipmentLotSizePopup)과 Model 팝업뿐이다. · 검색어 ExchangeRate, Exchange Rate, BPS I/F, btnBps: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4dbae579a8 | M4 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SCP0028 에는 Exchange Rate 팝업과 BPS I/F 가 없습니다. · 검색어 Exchange Rate, ExchangeRate, BPS: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3d3b642ff3 | E4 | [DMF0082 결함 유형] 신규 데이터셋 수량·판가 저장 | SCP0028에는 수량·판가 컬럼이 없다. · 검색어 UNIT_PRICE, Unit Price, MKT_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-418a718626 | D2 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | SCP0028 화면에는 RTF[R+P] Measure도 Cutoff 상태 기준 편집 차단도 없다. · 검색어 RTF, Cutoff, GET_ADMIN_GROUP_MEASURE, MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d515c00434 | J3 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | SCP0028 에는 RTF[R+P] Measure 와 Cutoff 상태에 따른 편집 차단이 없고, lock_rules.csv 의 잠금은 Edit·Search·Input 버튼 동작에만 걸려 있습니다. · 검색어 Cutoff, GET_ADMIN_GROUP_MEASURE, RTF_QTY: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8be25aad9e | E4 | [DMF0021 결함 유형] RTF[R+P] 편집 가능 조건 | SCP0028에는 RTF[R+P] 컬럼과 Cutoff 상태에 따른 편집 조건이 없다. · 검색어 RTF, GET_ADMIN_GROUP_MEASURE, Cutoff: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a115fc3fc0 | E4 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SCP0028에는 FCST Type과 ETC Text 필수 검증이 없다. · 검색어 FCST_TYPE, FCST Type: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-eec85fa671 | F6 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SCP0028 에는 FCST Type 과 ETC Text 컬럼이 없다. · 검색어 FCST_TYPE, FCST Type, ETC_TEXT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c9470e7203 | F1 | [DMF0021 결함 유형] Text 필수 Validation·ETC 수정 저장 | SCP0028 에는 FCST Type 컬럼과 ETC 테이블 저장 기능이 없다. · 검색어 FCST Type, FCST_TYPE, FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7dc387181e | D1 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0028에는 Sales Site·Project 팝업·Team 컬럼이 없고, AS-IS InsertRow()가 빈 구현이라 신규 행도 만들지 않는다. · 검색어 SALES_SITE, SALES_PLAN_ITEM_ID, Sales Site, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-476e945c09 | C3 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0028 화면에는 Sales Site·Project 팝업·Team 컬럼이 없고, 그리드는 Shipment Lot Size 단일 그리드다. · 검색어 Sales Site, SALES_PLAN_ITEM_ID, SSPM, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-660ae8f990 | B5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0028 의 신규 행에는 Sales Site·Project 팝업·Team 컬럼이 없다. · 검색어 Sales Site, SALES_PLAN_ITEM_ID, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-abe059a127 | M3 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0028 그리드에는 Sales Site·Project·Team 컬럼이 없다. · 검색어 Sales Site, SALES_SITE, SALES_PLAN_ITEM_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-464a8dbf6e | G5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0028 그리드에는 Sales Site·Project·Team 컬럼이 없다. · 검색어 SALES_PLAN_ITEM_ID, SalesSite, Sales Site, ProjectPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-959e03e733 | D5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | SCP0028 에는 Sales Site 컬럼과 Team 컬럼, SALES_PLAN_ITEM_ID 룩업이 없다. · 검색어 Sales Site, SALES_SITE, SALES_PLAN_ITEM_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f3e1e1cc9a | A5 | [DMF0021 결함 일반화] Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | SCP0028은 메인 그리드 컬럼을 LOT_SIZE_COLUMNS 고정 목록으로 그리고, AS-IS 소스와 TO-BE 화면 폴더 모두에서 컬럼셋팅 팝업을 찾지 못했다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-46acf2c50f | K2 | [DMF0021 결함 일반화] Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | SCP0028에는 컬럼셋팅 팝업이 없어 OK를 눌렀을 때 그리드 컬럼을 재구성하는 동작도 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d66c04825c | D3 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0028 화면에는 AS From Site 컬럼과 Sales Site 유형별 Measure 후보가 없다. · 검색어 AS From Site, AS_FROM_SITE, MEASURE, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-56c31397f5 | C2 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0028에는 AS From Site 콤보와 Measure 후보가 없습니다. · 검색어 AS_FROM_SITE, AS From Site, SCM_FCST, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a433a52e22 | B4 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0028의 From Site는 일반 출하 From Site이고, AS From Site와 Measure 후보는 이 화면에 없다. · 검색어 AS_FROM_SITE, AS From Site, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-500b8b14d5 | B5 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0028 의 From Site 는 출하 Site 이고 AS From Site 활성 제어나 Measure 후보가 없다. · 검색어 AS_FROM_SITE, SCM_FCST, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-39fbd00363 | J3 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | SCP0028 조회 조건에는 From Site·To Site 콤보만 있고 AS From Site 콤보와 Measure 후보 목록은 없습니다. · 검색어 AS_FROM_SITE, AS From Site, SCM_FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-aa552dcfa0 | B4 | [DMF0082 결함 유형] End Customer 셀 콤보 후보 | SCP0028 그리드에는 End Customer 셀 콤보가 없다. · 검색어 END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-69a6377f59 | B5 | [DMF0082 결함 유형] End Customer 셀 콤보 후보 | SCP0028 에는 End Customer 셀 콤보가 없고 그리드는 Lot Size·Increment·Container Split·Active 컬럼만 편집한다. · 검색어 END_CUSTOMER, End Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d67841a993 | A5 | [DMF0082 결함 유형] Div 81 컬럼·Measure 구성(Project·Cust FCST 등) | SCP0028에는 MKT FCST 조회와 Div 81 전용 Measure 구성이 없다. · 검색어 MKT_FCST, MKT FCST, Cust FCST: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-b86b94e633 | N1 | [DMF0082 결함 유형] Div 81 컬럼·Measure 구성(Project·Cust FCST 등) | SCP0028 화면에는 MKT FCST 컬럼과 Measure 구성이 없다. · 검색어 DMF0003_GET_MKT_FCST_DATA, MKT_FCST, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c54a1d7e22 | M3 | [DMF0082 결함 유형] Excel Form 팝업 Search | SCP0028 에는 Excel 버튼만 있고 Excel Form 팝업은 없다. · 검색어 Excel Form, ExcelForm, btnExcelForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6f5311f789 | M1 | [DMF0082 결함 유형] Excel Form 팝업 Search | SCP0028에는 Excel Form 팝업이 없고, 화면의 팝업은 Input·Delete 일괄 팝업과 Model 팝업뿐이다. · 검색어 ExcelForm, Excel Form, btnForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-965040f29a | M1 | [DMF0082 결함 유형] Excel Upload | SCP0028에는 Excel Upload 버튼이 없다(TO-BE upload: false). · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-84b52ec567 | B4 | [DMF0082 결함 유형] Customs Handbook 콤보 후보 | SCP0028에는 Customs Handbook 콤보가 없다. · 검색어 CUSTOMS_HANDBOOK, Customs Handbook: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9b55910f78 | B4 | [DMF0005 결함 유형] Team 조회조건 후보 | SCP0028에는 Team 조회조건이 없다. · 검색어 DEPT_ID, Team, cboTeam: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4c1efaecb7 | B7 | [DMF0005 결함 유형] Team 조회조건 후보 | SCP0028 의 조회조건은 Division·Operation Group·From Site·To Site·Trans Mode·Valid·Model 이고 Team 은 없다. · 검색어 DEPT_ID, Team, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e7ef62f4be | A5 | [DMF0020 결함 유형] 콤보 입력 컬럼·COL_LIST·Measure 위치 | SCP0028에는 COL_LIST와 Measure 위치 설정이 없다. · 검색어 COL_LIST, MEASURE_ID, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a106553e12 | H5 | [DMF0035 결함 유형] Ver.·Waterfall Type 라벨 | SCP0028 에는 Ver. 와 Waterfall Type 라벨이 없습니다. · 검색어 Waterfall Type, WATERFALL, Plan Type: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-77aa30a231 | B4 | [DMF0035 결함 유형] Version 조회조건 | SCP0028에는 Version 조회조건이 없다. · 검색어 cboVersion, PLAN_VERSION, VERSION_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ca92e880dc | M3 | [DMF0035 결함 유형] Version 조회조건 | SCP0028 조회조건은 Division·Model·Operation Group·From Site·To Site·Trans Mode·Valid 이고 Version 조건은 없다. · 검색어 cboVersion, VERSION_ID, Version: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-dbbf1a336a | A5 | [DMF0035 결함 유형] Div별 컬럼·Measure(End Cust(Report)·Project(S Report) 등) | SCP0028 메인 그리드에는 End Cust(Report)·Project(S Report) 컬럼과 Measure가 없다. · 검색어 END_CUSTOMER, End Cust, Project(S Report), SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-68e9eba0c1 | N1 | [DMF0035 결함 유형] Div별 컬럼·Measure(End Cust(Report)·Project(S Report) 등) | SCP0028 화면에는 Div별 Measure 컬럼과 End Cust 컬럼이 없다. · 검색어 Measure, End Cust, SSPM: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-874818ea95 | F1 | [DMF0082 결함 유형] Unit Price(LOC) 저장 | SCP0028 그리드에는 Unit Price(LOC) 컬럼이 없고 저장 대상은 Lot Size·Increment·Container Split·Active 컬럼이다. · 검색어 Unit Price, UNIT_PRICE, Unit Price(LOC): AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a9c6d4b08b | F6 | [DMF0082 결함 유형] Unit Price(LOC) 저장 | SCP0028 에는 Unit Price(LOC) 컬럼이 없다. · 검색어 UNIT_PRICE, Unit Price(LOC), LOC_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-df802e58f0 | E4 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SCP0028에는 RTF 저장 판가 검증과 Sales Plan Waterfall 연동이 없다. · 검색어 RTF, Waterfall, UNIT_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-eb51d2c89b | F1 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SCP0028 에는 RTF 저장과 Sales Plan Waterfall 동기화 기능이 없다. · 검색어 RTF, Waterfall, Sales Plan: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c69748482b | F7 | [DMF0021 결함 유형] RTF 저장 판가 검증 / Sales Plan Waterfall 동기화 | SCP0028 저장은 RTF 판가나 Sales Plan Waterfall 연동과 관계가 없다. · 검색어 RTF, Sales Plan Waterfall, SALES_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1f167cd842 | G4 | [DMF0035 결함 유형] Plan Type 조회조건 위치 | 이 화면에는 Plan Type 조회조건이 없다. · 검색어 Plan Type, PLAN_TYPE, cboPlanType: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e0bee7270d | H6 | [DMF0005 결함 유형] Team 팝업 조건(Team ID/Team Name) | 이 화면에는 Team 팝업과 Team ID/Team Name 조건이 없습니다. · 검색어 TeamPopup, TeamModal, Team Name: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1aaf1a2223 | M3 | [DMF0005 결함 유형] Team 팝업 조건(Team ID/Team Name) | SCP0028 에는 Team 팝업이 없다. · 검색어 TeamPopup, btnTeam, TEAM_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7e721cbd52 | B4 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | SCP0028 그리드에는 Sales Plant 셀 콤보가 없다. · 검색어 SALES_PLANT, Sales Plant, SCM_MST_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ad6179bcf1 | N1 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | SCP0028 화면에는 Sales Plant 셀 콤보가 없다. · 검색어 SALES_PLANT, Sales Plant, SCM_MST_PLANT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2a57045d05 | K2 | [DMF0021 결함 일반화] 컬럼셋팅 Company ID(필수 표시·Invisible 이동) | SCP0028에는 컬럼셋팅의 Invisible 영역과 COMPANY_ID 컬럼이 없다. · 검색어 COMPANY_ID, ColumnSetting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f4623b6fd3 | K2 | [DMF0035 결함 유형] Measure 명칭 MKT FCST[R+P] | SCP0028에는 Measure 컬럼과 MKT FCST[R+P] 명칭이 없다. · 검색어 Measure, MKT FCST, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f1e6953c70 | H5 | [DMF0035 결함 유형] Measure 명칭 MKT FCST[R+P] | SCP0028 에는 Measure 축과 MKT FCST[R+P] 명칭이 없습니다. · 검색어 MKT FCST, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6b21a79dfd | H8 | [SYS0012 결함 유형] Request Date 컬럼 | SCP0028 그리드에는 Request Date 컬럼이 없고, 날짜 컬럼은 Creation Date·Last Update Date 뿐이다. · 검색어 REQUEST_DATE, Request Date, RequestDate: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-982274e726 | D1 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0028에는 Dept 컬럼과 사용자 선택 시 SSO DEPT를 자동으로 넣는 기능이 없다. · 검색어 DEPT_ID, DEPT_NAME, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-55a091f6ae | C3 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0028 화면에는 Dept 컬럼과 Use Y/N 헤더가 없다. · 검색어 DEPT_ID, Dept, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8f2febd8ee | H5 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0028 그리드에는 Dept 컬럼과 Use Y/N 병합 헤더가 없습니다. · 검색어 DEPT_ID, DEPT_NAME, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-889f4e7c89 | F1 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0028 그리드에는 Dept 컬럼과 Use Y/N 헤더가 없다. · 검색어 DEPT, DEPT_ID, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3b53561ff1 | F6 | [SYS0002 결함 유형] Dept 컬럼 / Use Y/N·Active 헤더 | SCP0028 그리드에는 Dept 컬럼과 Use Y/N 헤더가 없다. · 검색어 DEPT_ID, DEPT_NAME, Use Y/N: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-12f0bd0dc2 | A5 | [SYS0014 결함 유형] Email 컬럼 | SCP0028 메인 그리드에는 Email 컬럼이 없다. · 검색어 EMAIL, Email: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8375ff9e32 | M3 | [SYS0014 결함 유형] User 팝업(User Info) | SCP0028 에는 User 팝업이 없다. · 검색어 UserPopup, SCM_ADM_USER_M, User Info: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c8b9392c1d | F1 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | SCP0028 에는 JV Planner 용 Division 시트가 없고 그리드는 spdMain 하나다. · 검색어 JV Planner, JV_PLANNER: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-aaa1f10bb3 | F6 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | SCP0028 에는 JV Planner 의 Division 시트가 없다. · 검색어 JV Planner, JV_PLANNER, Division Sheet: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-811f75a6db | E4 | [SYS0014 결함 유형] Division 시트 저장(JV Planner) | SCP0028에는 Division 시트와 JV Planner 저장 기능이 없다. · 검색어 JV Planner, JV_PLANNER: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-275848f9c3 | D5 | [SYS0010 결함 유형] System 컬럼 입력 방식 | SCP0028 그리드에는 System 컬럼이 없다. · 검색어 SYSTEM_CODE, SYSTEM_ID, SYSTEM Lookup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-514885a689 | B4 | [SYS0010 결함 유형] System 컬럼 입력 방식 | SCP0028 그리드에는 System 컬럼이 없다. · 검색어 SYSTEM_CODE, SYSTEM_ID, SYSTEM_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9fbe5333bb | K2 | [DMF0003 결함 유형] Measure 표시 순서 | SCP0028에는 개인화 Measure 셋팅과 Measure 표시가 없다. · 검색어 Measure, MeasureSetting, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-749b9b1b82 | D1 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | SCP0028은 Shipment Lot Size 기준정보 화면이라 URL·ROUTE_PATH 입력 컬럼이 없다. · 검색어 MENU_URL, URL_PATH, Route Path: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-43736623b6 | F1 | [SYS0003 결함 유형] URL-ROUTE_PATH 컬럼 | SCP0028 그리드에는 URL·ROUTE_PATH 입력 컬럼이 없다. · 검색어 URL, Menu URL: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-74425a62fa | B6 | [SYS0005 결함 유형] Schema 조회조건 | SCP0028 조회조건에는 Schema 가 없다. · 검색어 cboSchema, SCHEMA_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-748659e358 | G2 | [SYS0005 결함 유형] Schema 조회조건 | SCP0028 조회조건에 Schema 가 없다. · 검색어 SCHEMA_NAME, cboSchema, Schema Name: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-06fdee55e8 | G1 | [SYS0005 결함 유형] Schema 조회조건 | SCP0028에는 Schema 조회조건이 없습니다. · 검색어 SCHEMA_NAME, cboSchema, SCHEMA_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5db5eb7f4a | B6 | [SYS0006 결함 유형] API Type 조회조건 | SCP0028 조회조건에는 API Type 이 없다. · 검색어 API Type, API_TYPE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-84cf83dc8e | B4 | [SYS0006 결함 유형] API Type 조회조건 | SCP0028 조회조건에는 API Type 이 없다. · 검색어 API_TYPE, API Type, ApiType: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-37eb5bdd46 | B1 | [SYS0006 결함 유형] API Type 조회조건 | SCP0028에는 API Type 조회조건이 없습니다. · 검색어 API_TYPE, API Type, ApiType: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c2b9ea975a | B4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0028에는 Module·Sub Module 조회조건과 Notice Content가 없다. · 검색어 SUB_MODULE, Sub Module, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-938e648cf4 | B6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0028 에는 Module·Sub Module 조회조건과 Notice Content 가 없다. · 검색어 Sub Module, Notice Content, NOTICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-bee58ed879 | G4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0028에는 Module·Sub Module 조회조건과 Notice Content 입력이 없고, 조회조건은 Division·Operation Group·From Site·To Site·Trans Mode·Model·Active로 구성됩니다. · 검색어 Sub Module, SUB_MODULE, Notice Content, cboModule: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-951ec99b86 | H5 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0028 에는 Module, Sub Module 조회조건과 Notice Content 입력이 없습니다. · 검색어 Sub Module, SUB_MODULE, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3d141b391b | D4 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0028 에는 Module/Sub Module 조회조건과 Notice Content 컬럼이 없다. · 검색어 Sub Module, SUB_MODULE, Notice Content, NOTICE_CONTENT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-dd2222fa57 | H6 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0028 화면에는 Module·Sub Module 조회조건과 Notice Content 입력 영역이 없다. · 검색어 SubModule, Sub Module, Notice Content: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0275576f47 | K5 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회조건 / 라벨 / Active / Notice Content / 팝업 타이틀 | SCP0028 에는 Module·Sub Module 조회조건과 Notice Content 가 없다. · 검색어 Sub Module, Notice Content, NOTICE, SUB_MODULE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-648679b0fe | B6 | [SYS0017 결함 유형] Module / Sub Module 조회조건 | SCP0028 조회조건에는 Module·Sub Module 이 없다. · 검색어 Sub Module, SUB_MODULE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-eef93b96a0 | G4 | [SYS0017 결함 유형] Module / Sub Module 조회조건 | SCP0028 조회조건에는 Module·Sub Module 항목이 없고, AS-IS 화면 소스와 TO-BE 화면 폴더 모두에서 해당 식별자가 검색되지 않습니다. · 검색어 Sub Module, SUB_MODULE, cboModule, cboSubModule: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3fe0faab35 | A5 | [DMF0005 결함 유형] Cell Prod. Site (S&OP Report) 컬럼 | SCP0028 메인 그리드에는 Cell Prod. Site(S&OP Report) 컬럼이 없다. · 검색어 Cell Prod, CELL_PROD_SITE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7038bc805a | B4 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SCP0028에는 하단 그리드와 Sales Company·Sales Plant 콤보가 없다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Company: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-dd3cc6684f | C2 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SCP0028 그리드에는 Sales Company·Sales Plant 콤보가 없습니다. · 검색어 SALES_COMPANY, Sales Company, SALES_PLANT, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-30b5f61e3e | F2 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SCP0028 에는 하단 그리드와 Sales Company·Sales Plant 콤보가 없습니다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-58165142fe | F1 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | SCP0028 에는 하단 그리드와 Sales Company·Sales Plant 콤보가 없습니다. · 검색어 SALES_COMPANY, SALES_PLANT, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d39825d277 | H6 | [DMF0005 결함 유형] Project 팝업(그리드) | 이 화면에는 Project 조회조건 팝업이 없습니다. · 검색어 ProjectPopup, ProjectModal, btnProject: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-480bcb606b | M3 | [DMF0005 결함 유형] Project 팝업(그리드) | SCP0028 에는 Project 팝업을 여는 버튼이 없고, Model 팝업을 열 때 Project 값으로 빈 문자열을 넘긴다. · 검색어 ProjectbyDivisionPopup, btnProject, PROJECT_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-843cfff50a | G2 | [DMF0005 결함 유형] Project 팝업(그리드) | SCP0028 에는 Project 팝업이 없고 팝업은 Item(SCM0002_ITEMBYDIVISIONPOPUP)과 일괄입력(SCM0002_SHIPMENTLOTSIZEPOPUP)뿐이다. · 검색어 ProjectPopup, PROJECT_ID, Project Popup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e63a949b70 | B3 | [SYS0010 결함 유형] 메인화면 System admin 정보(SYSTEM_ADM Lookup) | SCP0028에는 메인화면 System admin 정보(SYSTEM_ADM Lookup) 표시가 없습니다. · 검색어 SYSTEM_ADM, System admin, SystemAdmin: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7ff5b1febb | E4 | [DMF0004 결함 유형] Customer 탭 Sold to/Ship to 저장 검증 | SCP0028에는 Customer 탭과 Sold to/Ship to 컬럼이 없다. · 검색어 NERP_CONV_MASTER, Sold to, Ship to: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8f2e6b38aa | E3 | [DMF0005 결함 유형] Project 컬럼 필수 검증 | SCP0028 그리드에는 Project 컬럼이 없다. · 검색어 PROJECT_CODE, PROJECT_ID, Project Code: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-39fe4b0d7a | B7 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SCP0028 그리드에는 Team(DEPT_ID) 컬럼이 없고, AS-IS 소스와 TO-BE 화면 폴더에서 Team·DEPT_ID 가 검색되지 않는다. · 검색어 DEPT_ID, Team, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d82a2caca4 | A2 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SCP0028 화면에는 Team(DEPT_ID) 셀 콤보가 없다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3399460d64 | B4 | [DMF0082 결함 유형] Team(DEPT_ID) 셀 콤보 표시값 | SCP0028 그리드에는 Team(DEPT_ID) 셀 콤보가 없다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8cc81c357e | B7 | [DMF0003 결함 유형] Team 정보(DEPT_ID) | SCP0028 에는 Team(DEPT_ID) 정보를 보여주는 조회조건이나 컬럼이 없다. · 검색어 DEPT_ID, Team, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-076156b627 | A1 | [DMF0003 결함 유형] Team 정보(DEPT_ID) | SCP0028 화면에는 Team(DEPT_ID) 컬럼이 없다. · 검색어 DEPT_ID, Team: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-60f82fde7b | F7 | [DMF0020 결함 유형] Unit Price(LOC) → Sales Price 연동 | SCP0028 에는 Unit Price(LOC) 에서 Sales Price 로 가는 연동이 없다. · 검색어 UNIT_PRICE, Sales Price, SALES_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f1267e7d40 | F1 | [DMF0020 결함 유형] Unit Price(LOC) → Sales Price 연동 | SCP0028 에는 Unit Price(LOC) 입력과 Sales Price 연동 기능이 없다. · 검색어 Unit Price, Sales Price, SALES_PRICE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-08759c2ee0 | A5 | [DMF0008 결함 유형] 하단 그리드 CRUD Status 컬럼 | SCP0028 은 메인 그리드(siMain) 하나만 있고 하단 그리드가 없다. · 검색어 CRUD_STATUS, siSub, siDetail: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-6aa2202309 | A5 | [DMF0005 결함 유형] Sold-to Cust(Report) 컬럼 | SCP0028 메인 그리드에는 Sold-to Cust(Report) 컬럼이 없다. · 검색어 Sold-to Cust, SOLD_TO_CUST, SOLD_TO: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a4d2437cdc | G5 | [DMF0074 결함 유형] Version 팝업 Period | SCP0028 에는 Version 팝업과 Period 조회조건이 없다. · 검색어 VersionPopup, cboVersion, Version: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-76e89c5f4a | H5 | [DMF0040 결함 유형] Version 조회조건 라벨 | SCP0028 조회조건에는 Version 조건이 없습니다(Div, Operation Group, From Site, To Site, Model, Valid, Trans Mode만 있음). · 검색어 VERSION_ID, PLAN_VERSION, lblVersion: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1590397c6e | B5 | [SYS0012 결함 유형] 권한 신청 가능 Group 목록 | SCP0028 에는 권한 신청 Group 목록이 없다. · 검색어 REQ_NO_DISPLAY, Approval Group: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ab5cd5dcfe | A5 | [DMF0035 결함 유형] Div별 제외 컬럼(Project Status·Owner·Department 등) | SCP0028 그리드에 Project Status·Owner·Department 컬럼이 없다. · 검색어 PROJECT_STATUS, Project Status, DEPARTMENT: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c50cbdb716 | A5 | [DMF0082 결함 유형] Project Name 컬럼 | SCP0028 메인 그리드에는 Project Name 컬럼이 없다. · 검색어 PROJECT_NAME, Project Name: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f18ccb8695 | F8 | [SYS0011 결함 유형] Approval Date 컬럼 | SCP0028에는 Approval Date 컬럼도 Request·승인 흐름도 없습니다. · 검색어 APPROVAL_DATE, Approval Date, ApprovalDate: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-566f47a3fb | F1 | [SYS0011 결함 유형] Approval Date 컬럼 | SCP0028 그리드에는 Approval Date 컬럼과 Request 기능이 없습니다. · 검색어 APPROVAL_DATE, Approval Date: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-79a5ce1eaa | C5 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | SCP0028 화면에는 Mail Setup 탭과 사용자 좌/우 그리드가 없다. · 검색어 Mail, MAIL, DoubleClick: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c379852bd3 | F1 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | SCP0028 에는 Mail Setup 탭과 사용자 좌/우 그리드가 없습니다. · 검색어 Mail Setup, MailSetup, MAIL_ADDRESS: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5a2ce2e578 | F5 | [SYS0017 결함 유형] Mail Setup 탭 사용자 좌/우 그리드 | SCP0028 은 Shipment Lot Size 화면이고 Mail Setup 탭과 사용자 좌/우 그리드가 없다. · 검색어 Mail Setup, MAIL_USER, MAIL_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9e1055744f | C1 | [DMF0035 결함 유형] Version 조회조건 기본값 | SCP0028 에는 Version 조회조건이 없다. · 검색어 cboVersion, PLAN_VERSION, VersionId: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2275aed040 | A5 | [DMF0082 결함 유형] BIZ PLAN 제외 컬럼(Cust Group Dtl 등 7개) | SCP0028에는 BIZ PLAN 화면 컬럼과 Cust Group Dtl 컬럼이 없다. · 검색어 BIZ_PLAN, BIZ PLAN, Cust Group Dtl, CUST_GROUP: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ee4713436c | A5 | [DMF0082 결함 유형] Cust Group Dtl 컬럼 | SCP0028 그리드에 Cust Group Dtl 컬럼이 없다. · 검색어 CUST_GROUP_DTL, Cust Group Dtl: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1d8f92f081 | A3 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | SCP0028 화면에는 Sum 행 라벨과 Sum/Qty≠0 체크박스가 없다. · 검색어 Sum/Qty, Qty≠0, Subtotal: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1afe680702 | H5 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | SCP0028 그리드에는 Sum 행과 Sum/Qty≠0 체크박스가 없습니다. · 검색어 SUM_ROW, Sum/Qty, Qty≠0: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2748aa5204 | G4 | [DMF0035 결함 유형] Sum 행 표기 / Sum·Qty≠0 체크박스 | 이 화면에는 Sum 행과 Sum·Qty≠0 체크박스가 없다. · 검색어 Qty≠0, Sum/Qty, chkSumQty: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a9a478ef6b | A5 | [DMF0035 결함 유형] Version 컬럼 | SCP0028 메인 그리드에는 Version 컬럼이 없다. · 검색어 VERSION_ID, PLAN_VERSION, Version: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-516e858349 | K2 | [DMF0035 결함 일반화] Measure 순서 | SCP0028에는 메저셋팅과 Measure 표시가 없다. · 검색어 Measure, MeasureSetting, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-52d21b1b2d | A1 | [DMF0082 결함 유형] RTF[R+P] Measure 행 | SCP0028 화면에는 RTF Measure 행이 없고, 그리드는 Lot Size·Increment 등 마스터 컬럼만 보여 준다. · 검색어 Measure, RTF[R+P], R+P: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-415cff7fa1 | F7 | [DMF0021 결함 유형] RTF[R+P] → DM_PLN_MKT_FCST / DM_PLN_MKT_FCST_C 연동 | SCP0028 저장은 DM_PLN_MKT_FCST 테이블 연동과 관계가 없다. · 검색어 DM_PLN_MKT_FCST, RTF, Demand Plan Waterfall: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-75e0dc7f89 | F1 | [DMF0021 결함 유형] RTF[R+P] → DM_PLN_MKT_FCST / DM_PLN_MKT_FCST_C 연동 | SCP0028 에는 RTF[R+P] 의 DM_PLN_MKT_FCST 연동 기능이 없다. · 검색어 RTF, MKT_FCST, Waterfall: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-139cc1adcb | A1 | [SCP0006 결함 유형] BOM Explosion Plant Assign(MCCH125020A1/MACH125020A1) | SCP0028 화면에는 BOM Explosion Plant Assign 기능이 없다. · 검색어 BOM Explosion, Plant Assign, PlantAssign: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3632bb1cc2 | N1 | [SCP0006 결함 유형] BOM Explosion Plant Assign(MCCH125020A1/MACH125020A1) | SCP0028 화면에는 BOM Explosion Plant Assign 기능이 없다. · 검색어 PLANT_ASSIGN, Plant Assign, BOM Explosion: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5db3fea811 | D3 | [SCP0006 결함 유형] Plant Assign 그리드 색상 | SCP0028 화면에는 Plant Assign 그리드와 CA1 행 구분이 없다. · 검색어 Plant Assign, PLANT_ASSIGN, CA1: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a859aad9ff | H2 | [SCP0006 결함 유형] Plant Assign 그리드 색상 | 이 화면에는 Plant Assign 그리드와 CA1 행이 없다. · 검색어 Plant Assign, PLANT_ASSIGN, CA1: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f12b612887 | I1 | [SCP0007 결함 유형] Route 검색 팝업 제목 | SCP0028에는 Route 검색 팝업이 없고 팝업은 SCM0002 Shipment Lot Size 팝업과 Item 팝업만 있다. · 검색어 RouteSearch, Route Search, ROUTE_ID: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-edbeb5560e | H5 | [SCP0007 결함 유형] Route 검색 팝업 제목 | SCP0028 에는 Route 검색 팝업이 없습니다. · 검색어 RoutePopup, ROUTE_ID, Route Search: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-790452387d | D4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SCP0028 그리드에는 City 컬럼이 없고, AS-IS InsertRow 본문이 비어 있어 To Site·City 매핑 대상 Insert 행이 생기지 않는다. · 검색어 CITY, City: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7d23485031 | B4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SCP0028 은 Insert 를 팝업(SCM0002_SHIPMENTLOTSIZEPOPUP)으로 하고 그리드에 To Site 콤보·City 컬럼이 없다. · 검색어 TO_CITY, FROM_CITY, CountryCity: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-760603e3a0 | C3 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SCP0028 화면은 Input 단추와 SCM0002_ShipmentLotSizePopup 팝업으로 행을 추가하고, To Site 선택에 따른 City 매핑이 없다. · 검색어 City, CITY: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-27e4b23d1b | F1 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | SCP0028 의 Insert 버튼은 InsertRow() 가 비어 있어 동작하지 않고, To Site 는 조회 컬럼이며 City 매핑 컬럼은 없습니다. · 검색어 CITY_CODE, CITY_NAME, cboToSite: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-1edbd6c91e | E2 | [SCP0007 결함 유형] Period 날짜 | SCP0028에는 Period 날짜 입력칸이 없고 Creation Date·Last Update Date는 표시 전용 컬럼이다. · 검색어 Period, PERIOD_FROM, FROM_DATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-33cdf3a97e | F4 | [SCP0007 결함 유형] Period 날짜 | SCP0028에는 Period 날짜 입력 항목이 없습니다. · 검색어 Period, dtpPeriod, FROM_DATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2a89ec95ee | E1 | [SCP0007 결함 유형] Additional Lead Time | SCP0028 그리드에는 Additional Lead Time 컬럼이 없다. · 검색어 ADDITIONAL_LEAD_TIME, Additional Lead Time, LEAD_TIME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fbea4a8352 | A5 | [DMF0021 결함 일반화] 그리드 End Customer 컬럼(END_CUSTOMER_ID) · 컬럼 셋팅 개인화 저장(필수 컬럼) | SCP0028에는 End Customer 컬럼과 컬럼셋팅 개인화 저장 기능이 없다. · 검색어 END_CUSTOMER_ID, End Customer, ColumnSetting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3952b768fa | K2 | [DMF0021 결함 일반화] 그리드 End Customer 컬럼(END_CUSTOMER_ID) · 컬럼 셋팅 개인화 저장(필수 컬럼) | SCP0028에는 END_CUSTOMER_ID 컬럼과 컬럼 셋팅 개인화 저장 기능이 없다. · 검색어 END_CUSTOMER, ColumnSetting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-ed2405fa1d | K1 | [DMF0082 결함 일반화] 그리드 Measure 필터(MEASURE Filter) × Division(DIVISION_ID) 변경 재조회 · 건수 표시 | SCP0028 AS-IS 소스와 TO-BE 화면 폴더에 Measure 필터 요소가 없다. · 검색어 MEASURE, Measure Filter, measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8c9b58122b | C4 | [DMF0082 결함 일반화] 그리드 Measure 필터(MEASURE Filter) × Division(DIVISION_ID) 변경 재조회 · 건수 표시 | SCP0028 화면에는 Measure 필터가 없다. · 검색어 MEASURE, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0ac5172efc | H4 | [DMF0082 결함 일반화] Version 팝업(VERSION Modal) 레이아웃 | SCP0028 에는 Version 팝업이 없습니다(AS-IS 소스와 TO-BE 폴더 모두 Version 화면 요소 없음). · 검색어 VersionPopup, VersionModal, VERSION Modal: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-091d38e885 | M4 | [DMF0003 결함 일반화] 신규 행 Project 팝업(PROJECT_CODE → PROJECT_NAME·PROJECT_STATUS·PROJECT_OWNER·BIZ_TYPE) · Model 팝업(ITEM_ID → | SCP0028 에는 신규 행에서 Project·Model·Sales Site 팝업으로 PROJECT_NAME·ITEM_TYPE·VMI_YN 을 자동으로 채우는 기능이 없습니다. · 검색어 PROJECT_NAME, PROJECT_STATUS, VMI_STD_DIO: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-314f550ef1 | M1 | [DMF0014 결함 일반화] 공용 업로드 창(Upload) 검증 완료 후 저장 전 Cancel · X 닫기 확인창 MSG00684 「취소하시겠습니까?」(AS-IS MSG00195) | SCP0028에는 공용 업로드 창이 없어 Cancel·X 닫기 때의 MSG00684 확인창 대상이 없다. · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8453e701e2 | B5 | [DMF0021 결함 일반화] Measure 설정 팝업(Measure Setting) 후보 · Column 설정 후보 — Division 기준 재조회 | SCP0028 에는 Measure 설정 팝업과 Division 기준 Column 설정 목록이 없다. · 검색어 Measure Setting, MeasureSetting, MEASURE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-11eca584da | K2 | [DMF0021 결함 일반화] Measure 설정 팝업(Measure Setting) 후보 · Column 설정 후보 — Division 기준 재조회 | SCP0028 AS-IS 소스와 TO-BE shipment-lot-size 폴더에는 Measure 설정 팝업과 Column 설정 후보 재조회 기능이 없다. · 검색어 Measure, MeasureSetting, Measure Setting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-bb7fa83a6d | M1 | [DMF0074 결함 일반화] 공용 Excel Upload 창 2단계 — Upload(검사 · 분류) → OK(저장) · 오류 1건 이상이면 저장 차단 MSG00657 | SCP0028에는 공용 Excel Upload 창 호출이 없어 Upload → OK 2단계 저장 차단 대상이 없다. · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-a2512cb145 | A5 | [SYS0017 결함 유형] Main 그리드 Sub Module 컬럼(SUB_MODULE_CODE) | SCP0028 메인 그리드에는 Sub Module 컬럼이 없다. · 검색어 SUB_MODULE_CODE, Sub Module: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e0f3f0212f | A5 | [SYS0017 결함 유형] Category 코드 컬럼(CATEGORY_ID) 숨김 | SCP0028 그리드에 Category 코드 컬럼이 없다. · 검색어 CATEGORY_ID, CATEGORY_DESC: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-91b9b292b8 | A2 | [SYS0017 결함 유형] Category 코드 컬럼(CATEGORY_ID) 숨김 | SCP0028 그리드에는 Category 코드 컬럼이 없다. · 검색어 CATEGORY_ID, CATEGORY_DESC: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7fd0a51a45 | F4 | [SYS0017 결함 유형] SQL View 버튼(VIEW) | SCP0028에는 SQL View 버튼이 없습니다. · 검색어 SQL View, SqlView, btnView: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-2d40c839a9 | M2 | [SYS0017 결함 유형] SQL View 버튼(VIEW) | SCP0028 화면에 SQL View 버튼이 없고, 버튼은 Search·Reset·Insert·Delete·Save·Input·Excel·ItemId뿐이다. · 검색어 SQL View, SqlView, btnSqlView: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-fbb7152ded | D4 | [SYS0017 결함 유형] 하단 메시지설정 탭 Insert | SCP0028 은 단일 그리드 화면이라 하단 메시지설정 탭이 없다. · 검색어 메시지설정, MSG_SETTING, MessageSetting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-903f533cbe | F1 | [SYS0017 결함 유형] 사용자 우측 그리드(allReceiver) 추가 후 Save | SCP0028 에는 사용자 우측 그리드(allReceiver)가 없다. · 검색어 allReceiver, Receiver: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-cd1ec8ea4a | C5 | [SYS0017 결함 유형] 사용자 조회 후 더블클릭 추가/제거 | SCP0028 화면에는 사용자 조회와 더블클릭 추가/제거 그리드가 없다. · 검색어 DoubleClick, CellDoubleClick, onRowDoubleClicked: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7b640f0b61 | H4 | [SYS0017 결함 유형] 우측 사용자 영역 높이 | 이 화면은 Main Grid 하나로 되어 있고 좌/우 사용자 영역이 없습니다. · 검색어 splitContainer, UserArea, panelRight: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-d759a82a41 | M3 | [SYS0017 결함 유형] SQL 버튼 팝업 저장 | SCP0028 에는 SQL 버튼과 SQL 팝업이 없다. · 검색어 btnSql, SqlPopup, QueryPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-be33a80f6c | A5 | [SCM0007 결함 유형] Main 그리드 Sub Module 컬럼(SUB_MODULE_CODE) | SCP0028 메인 그리드에 Sub Module 컬럼이 없다. · 검색어 SUB_MODULE_CODE, Sub Module: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-e8086f7a7d | A5 | [SCM0007 결함 유형] Category 코드 컬럼(CATEGORY_ID) 숨김 | SCP0028 그리드에 Category 코드 컬럼이 없다. · 검색어 CATEGORY_ID, CATEGORY_DESC: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-56032289ab | A2 | [SCM0007 결함 유형] Category 코드 컬럼(CATEGORY_ID) 숨김 | SCP0028 그리드에는 Category 코드 컬럼이 없다. · 검색어 CATEGORY_ID, CATEGORY_DESC: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-7c8c65f926 | F4 | [SCM0007 결함 유형] SQL View 버튼(VIEW) | SCP0028에는 SQL View 버튼이 없습니다. · 검색어 SQL View, SqlView, btnView: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-27863260b4 | M2 | [SCM0007 결함 유형] SQL View 버튼(VIEW) | SCP0028 화면에 SQL View 버튼이 없고, 버튼은 Search·Reset·Insert·Delete·Save·Input·Excel·ItemId뿐이다. · 검색어 SQL View, SqlView, btnSqlView: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5060630da5 | D4 | [SCM0007 결함 유형] 하단 메시지설정 탭 Insert | SCP0028 은 단일 그리드 화면이라 하단 메시지설정 탭이 없다. · 검색어 메시지설정, MSG_SETTING, MessageSetting: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f285ca6496 | F1 | [SCM0007 결함 유형] 사용자 우측 그리드(allReceiver) 추가 후 Save | SCP0028 에는 사용자 우측 그리드(allReceiver)가 없다. · 검색어 allReceiver, Receiver: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-f0d11f81d7 | C5 | [SCM0007 결함 유형] 사용자 조회 후 더블클릭 추가/제거 | SCP0028 화면에는 사용자 조회와 더블클릭 추가/제거 그리드가 없다. · 검색어 DoubleClick, CellDoubleClick, onRowDoubleClicked: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-4a6ab570a4 | H4 | [SCM0007 결함 유형] 우측 사용자 영역 높이 | 이 화면은 Main Grid 하나로 되어 있고 좌/우 사용자 영역이 없습니다. · 검색어 splitContainer, UserArea, panelRight: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-407c48922f | M3 | [SCM0007 결함 유형] SQL 버튼 팝업 저장 | SCP0028 에는 SQL 버튼과 SQL 팝업이 없다. · 검색어 btnSql, SqlPopup, QueryPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0b50672bd9 | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Team 콤보 | SCP0028에는 Team(DEPT) 조회조건 콤보와 cascade가 없다. · 검색어 DEPT_ID, Team, cboTeam: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5815962404 | C2 | 그리드 End Customer→Sold-to Customer cascade | SCP0028 그리드에는 End Customer·Sold-to Customer 컬럼이 없습니다. · 검색어 END_CUSTOMER, End Customer, SOLD_TO, Sold-to Customer: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c8ed0c157a | C2 | 그리드 Sales Company→Sales Plant · Sales Site→Company/Plant | SCP0028 그리드에는 Sales Company·Sales Plant·Sales Site 컬럼이 없습니다. 콤보 셀 사이에 상위·하위 cascade도 없습니다. · 검색어 SALES_COMPANY, Sales Company, SALES_PLANT, Sales Plant: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8c1dba812f | M1 | Excel Upload 컬럼명 검증 메시지 · 파일 첨부 개수 | SCP0028에는 Excel Upload가 없어 파일 첨부 개수와 컬럼명 검증 대상이 없다. · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0fd64e2d58 | H2 | 실적 구간 배경색 | Shipment Lot Size 에는 실적 구간(과거 기간) 셀이 없다. · 검색어 ACTUAL_WEEK, PLAN_START: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-be27873f34 | B8 | Team 컬럼(MKT FCST 조회·신규행) | SCP0028 그리드에는 Team 컬럼이 없어 SSPM DEPT_ID 로 Team 을 표시할 대상이 없다. · 검색어 DEPT_ID, Team, DEPT_NAME: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-df4a6375bb | M1 | Excel Upload 헤더 검증 메시지 | SCP0028에는 Excel Upload가 없어 헤더 검증 메시지 확인 대상이 없다. · 검색어 ExcelUpload, Excel Upload, Invalid Column Header Title: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3ed86402f0 | M1 | Excel Upload Validation 메시지(Sales Site/Project/Model) | SCP0028에는 Excel Upload가 없어 행·항목별 Validation 메시지 대상이 없다. · 검색어 ExcelUpload, Excel Upload, btnUpload: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-62ca4c2ca5 | K2 | Column Setting 필수 컬럼 표시·Div 전환 End Customer | SCP0028에는 컬럼셋팅 팝업이 없어 필수 컬럼(USER_SELECTED_FLAG=N) 빨간색 표시를 확인할 대상이 없다. · 검색어 USER_SELECTED_FLAG, ColumnSetting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-86f292e3e8 | M3 | Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | SCP0028 에는 Exchange Rate 팝업이 없고, 열리는 팝업은 SCM0002_ItembyDivisionPopup 과 SCM0002_ShipmentLotSizePopup 두 개다. · 검색어 Exchange Rate, ExchangeRate, EXCHANGE_RATE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-c6f5981189 | A5 | Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | SCP0028에는 컬럼셋팅 팝업과 OK 버튼이 없어, 컬럼셋팅 OK 시 그리드를 재구성하는 동작을 확인할 대상이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-56c7157814 | K2 | 컬럼·메저 셋팅 Save/OK 재조회 | SCP0028에는 컬럼·메저 셋팅 팝업이 없어 Save/OK 뒤 재조회 여부를 확인할 대상이 없다. · 검색어 ColumnSetting, Column Setting, 컬럼셋팅, Measure: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-3f6fe9a276 | M4 | 팝업 입력 컬럼 | SCP0028 메인 그리드에는 팝업으로 값을 넣는 셀이 없고, 팝업은 조회조건 Model(btnItemId)과 Input/Delete 일괄 팝업뿐입니다. · 검색어 ButtonClicked, CellButtonClick, onCellPopup: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-eb2095583a | K2 | Measure 순서·메저셋팅 순서 저장 | SCP0028에는 메저셋팅 버튼이 없다. · 검색어 Measure, MeasureSetting, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-0e969557bd | K2 | Measure 순서 | SCP0028에는 메저셋팅이 없어 Measure 순서를 확인할 대상이 없다. · 검색어 Measure, MeasureSetting, 메저셋팅: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-15ee2584f5 | H2 | 팝업 입력 셀(FPModal · 더블클릭 팝업으로 값이 채워지는 셀, 예 BOD Route Id) | Shipment Lot Size 그리드에는 더블클릭 팝업으로 값을 채우는 셀이 없고, Model 팝업은 조회조건 버튼(btnItemId)에서만 열린다. · 검색어 FPModal, ModalCell, SetModalCellType: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-48669c0fc5 | C5 | 다중 그리드 더블클릭 연동 | SCP0028 화면은 spdMain 단일 그리드이고 더블클릭 연동이 없다. · 검색어 DoubleClick, CellDoubleClick, onRowDoubleClicked: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-644cb71506 | E7 | 그리드 팝업 셀 Key-in(FPModal 컬럼) 잘못된 값 | Shipment Lot Size 그리드에는 팝업으로 값을 고르는 셀이 없고, Model 팝업은 조회조건 ITEMID 버튼과 Input·Delete 버튼에서만 열린다. · 검색어 FPModal, ButtonClicked, ModalCellType: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9f940cebe0 | M1 | Excel Form 버튼 | SCP0028에는 Excel Form 버튼이 없어 팝업 여부를 판정할 대상이 없다. · 검색어 ExcelForm, Excel Form, btnForm: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-9d01854953 | H6 | TO-BE 메타 공통 셀 팝업(SCM_MST_SHEET_COLUMNS CELL_CONTROL_OBJECT_TYPE_CODE = FPModal·FPTextModal) | 이 화면 그리드에는 메타 공통 셀 팝업(FPModal·FPTextModal)이 없고, 팝업은 조회조건 Model 팝업과 일괄입력/삭제 팝업뿐입니다. · 검색어 FPModal, FPTextModal, CELL_CONTROL_OBJECT_TYPE_CODE: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-5bf38ebfa9 | E2 | 월 범위 조회조건 기간 역전(시작 > 끝) | SCP0028 조회조건은 Division·Operation Group·From Site·To Site·Trans Mode·Model·Valid뿐이고 월 범위 기간 조건이 없다. · 검색어 FROM_DATE, TO_DATE, MSG00344, Period: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |
| C-8370915e43 | G4 | 스냅샷 조회조건 공용 기간 칸 구조·아이콘 | 이 화면에는 공용 월 범위(기간) 조회조건 칸이 없다. · 검색어 Period, MonthRange, YYYY.MM: AS-IS 화면 소스·TO-BE 화면 폴더 16개 파일·요소 목록 0건 |

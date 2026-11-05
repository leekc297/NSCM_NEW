# SCP&SSP 단위테스트 — DMF0045 Shipment Request (공통요건 25 · 검증내역 12) 원문

> 생성: 2026-10-30 · `python tools/Harness/verify/sources_extract.py --only ssp45` 로 재생성(손편집 금지 — 원천 xlsx 를 고친 뒤 재실행).
> 원천: `☆NSCME_SCP&SSP 테스트_DMF0045(Shipment Request).xlsx` (1,192,989 B · 수정 2026-10-29 16:49) · 시트 2개 · 비어있지 않은 셀 178 · 이미지 참조 11(media 파일 11).
> 기계판독본: `Doc/verify/sources/scpssp_test_dmf0045.csv`(표 시트 행 · row_id 열이 2단계 분류 키) · `scpssp_test_dmf0045_cells.csv`(표 바깥·비정형 시트 셀) · `scpssp_test_dmf0045_images.csv`(이미지 위치) · 이미지 `Doc/verify/sources/_img/ssp45/`.
> 행 ID 규칙: 시트 `공통요건` → `SSP45REQ-<No>` · 시트 `검증내역` → `SSP45-<No.>`. 셀 줄바꿈은 `⏎` 로 표기. 값은 자르지 않음.
> 목적: CheckList(정합검증)가 이 파일의 내역을 누락 없이 품도록 하는 1단계 원문 — 2단계에서 결함 재발 규칙·설계 결정·공통 요건으로 분류해 검증엔진에 반영한다.

## 1. 시트 목록 (xlsx ↔ 기록 대조)

| # | 시트 | 유형 | xlsx 비어있지 않은 셀 | 기록 셀 | 표 행 | 이미지 | 차트 | 일치 |
|---|---|---|---|---|---|---|---|---|
| 1 | 공통요건 | 표 | 104 | 104 | 25 |  |  | OK |
| 2 | 검증내역 | 표 | 74 | 74 | 12 | 11 |  | OK |

## 2. 표 시트 `공통요건` — 25행 × 6열 (헤더 행 2)

| 행 ID | 원행 | 열A | No | 구분 | 내용 | 관련 팀 | 비고 | 증빙 이미지 |
|---|---|---|---|---|---|---|---|---|
| SSP45REQ-1 | 3 |  | 1 | div 조회 조건 | div를 1개만 선택하는 화면은 div 변경시 모든 gid와 조회 조건을 초기화 한다 | A |  |  |
| SSP45REQ-2 | 4 |  | 2 | div 조회 조건 | 사업부마다 보여지는 컬럼이 다른지 확인하고 As-is와 동일한지 확인 | A |  |  |
| SSP45REQ-3 | 5 |  | 3 | COMBO 조회 조건 | 보여지는 data가 같은지 확인 (다른 경우는 분석필요) | B |  |  |
| SSP45REQ-4 | 6 |  | 4 | COMBO 조회 조건 | Cascade 가 잘 작동하는 지 | A |  |  |
| SSP45REQ-5 | 7 |  | 5 | COMBO 조회 조건 | single / multi select 일때 조회가 잘 동작하는지 | A/B |  |  |
| SSP45REQ-6 | 8 |  | 6 | Textbox 조회 조건 | Main 조회조건 textbox에서 입력된 값이 팝업을 띄웠을 때 연동되어 조회되는지 | A |  |  |
| SSP45REQ-7 | 9 |  | 7 | Textbox 조회 조건 | 대소문자 구별없이 조회되는지 | B |  |  |
| SSP45REQ-8 | 10 |  | 8 | Textbox 조회 조건 | 콤마를 입력해서 조회(MULTI SELECT) 가 되는지 |  |  |  |
| SSP45REQ-9 | 11 |  | 9 | 공통 버튼 기능 | 각 GRID에 SORT 버튼 / 단축기 기능이 정상작동하는지 | A |  |  |
| SSP45REQ-10 | 12 |  | 10 | 공통 버튼 기능 | 각 GRID에 FILTER 버튼 / 단축기 기능이 정상작동하는지 | A |  |  |
| SSP45REQ-11 | 13 |  | 11 | 공통 버튼 기능 | CONDITION 버튼이 정상 동작하는지. Period(날짜) 관련된 값은 처리 안함 | A |  |  |
| SSP45REQ-12 | 14 |  | 12 | 공통 버튼 기능 | RESET CONDITION 버튼이 정상 동작하는지. | A |  |  |
| SSP45REQ-13 | 15 |  | 13 | 팝업 조회조건 | 대소문자 구별없이 조회되는지 | B |  |  |
| SSP45REQ-14 | 16 |  | 14 | 팝업 조회조건 | 콤마를 입력해서 조회(MULTI SELECT) 가 되는지 | A/B |  |  |
| SSP45REQ-15 | 17 |  | 15 | GRID | 각 GRID에서 AS-IS에서 EDIT(F2)를 눌렀을때 EDIT 되는 컬럼이 TO-BE에서는 기본적으로 EDIT 상태로 조회 되는지 | A |  |  |
| SSP45REQ-16 | 18 |  | 16 | GRID | Insert 기능이 As-Is에 있을때 To-Be도 동작하는지 | A |  |  |
| SSP45REQ-17 | 19 |  | 17 | GRID | Delete 기능이 잘 동작하는지 |  |  |  |
| SSP45REQ-18 | 20 |  | 18 | GRID | Combo / 팝업이 있는 경우 동일하게 구성되는지 | A |  |  |
| SSP45REQ-19 | 21 |  | 19 | GRID | Combo data가 As-Is와 같은지. | B |  |  |
| SSP45REQ-20 | 22 |  | 20 | GRID | Save 기능 확인. 기존값 수정 + Insert 를 대상으로 확인 | A / B |  |  |
| SSP45REQ-21 | 23 |  | 21 | GRID | Grid가 여러 개 있는경우 더블 클릭 기능 확인 | A |  |  |
| SSP45REQ-22 | 24 |  | 22 | GRID | Grid - Combo에서 key-in이 되는 경우 Combo 내에서 없는 값이면 초기화 되기 | A |  |  |
| SSP45REQ-23 | 25 |  | 23 | GRID | Grid - 팝업 컬럼에 key-in이 되는 경우 잘못된 값이면 Validation 하기. As-is에서 동작 비교 필수 | A / B |  |  |
| SSP45REQ-24 | 26 |  | 24 | GRID | Grid - 필수 컬럼 미입력 시 Validation 팝업 필수 | A |  |  |
| SSP45REQ-25 | 27 |  | 25 | GRID | Grid - 필수 컬럼 Setting 검토. 사업부별로 다를 수 있음. | A | 어떻게 체크해야하는지 UI 와 상의필요 |  |

## 3. 표 시트 `검증내역` — 12행 × 14열 (헤더 행 2)

| 행 ID | 원행 | 조치결과 확인일자 | No. | 구분 | UI ID | UI명 | Div | 테스트 내용 | 유형 | 검토담당 | 테스트 결과 | 담당자 | 요청일자 | 요청내용 확인일자 | 조치결과 | 증빙 이미지 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| SSP45-1 | 3 |  | 1 | SCP | DMF0045 | Shipment Request | 공통 | [조회 조건] ⏎(1) 배열순 변경⏎(2) 조회조건명 변경 : Project -> PJT,  Plant Site -> From Site⏎⏎ |  | 강용준 | asis 와 동일하게 수정 |  |  |  |  | [검증내역_r3c6_1.png](_img/ssp45/검증내역_r3c6_1.png) [검증내역_r3c7_1.png](_img/ssp45/검증내역_r3c7_1.png) |
| SSP45-2 | 4 |  | 2 | SCP | DMF0045 | Shipment Request | 공통 | [조회조건] Div 배열순이 다름. 최소한 81_Automotive, 82_ESS_Battery...순으로.. |  | 강용준 | 공통함수로 구현된 순서 -> 이 화면만 개별로 적용 |  |  |  |  | [검증내역_r4c7_1.png](_img/ssp45/검증내역_r4c7_1.png) [검증내역_r4c7_2.png](_img/ssp45/검증내역_r4c7_2.png) |
| SSP45-3 | 5 |  | 3 |  | DMF0045 | Shipment Request | 공통 | [메인그리드] 공통버튼 Insert 눌러서 한행 추가 후 모델 팝업 클릭시 Item 팝업이 표시됨.⏎                 Material by Division 팝업으로 수정 |  | 강용준 | 처리 완료 |  |  |  |  | [검증내역_r5c7_1.png](_img/ssp45/검증내역_r5c7_1.png) |
| SSP45-4 | 6 |  | 4 |  | DMF0045 | Shipment Request |  | [몌인그리드] No3.에서 품목 선택시 메인그리드의 Model 및 Nick Name에 자동 설정되도록 수정. |  | 강용준 | 처리 완료 |  |  |  |  | [검증내역_r6c7_1.png](_img/ssp45/검증내역_r6c7_1.png) |
| SSP45-5 | 7 |  | 5 |  | DMF0045 | Shipment Request |  | [메인그리드] - 계정 : attackgo / Div : 81 조회⏎Insert 행 추가 후 Model : AMCOME782-A1-0K0 / Project Code : A15BW7001 선택이후 Trans Mode 팝업⏎클릭 시 팝업에 No Permission이 표시됨( AS-IS에서는 데이터 표시 및 최종 저장 가능 )  |  |  |  |  |  |  |  | [검증내역_r7c7_1.png](_img/ssp45/검증내역_r7c7_1.png) |
| SSP45-6 | 8 |  | 6 |  | DMF0045 | Shipment Request |  | [조회조건] ⏎1) Project, Model/Nickname like검색 되지 않음. , 복수 건 되지 않음. 소문자 검색 되지 않음.⏎ |  | 강용준 | 안진선 부장님이 처리해주신 것 같음. 현상 재현 불가 |  |  |  |  |  |
| SSP45-7 | 9 |  | 7 |  | DMF0045 | Shipment Request |  | [메인그리드] Insert 로 행 추가 후 아무것도 입력하지 않고, 계획값만 입력 해도 성공했다고 메시지가 표시됨. |  |  |  |  |  |  |  | [검증내역_r9c7_1.png](_img/ssp45/검증내역_r9c7_1.png) |
| SSP45-8 | 10 |  | 8 |  | DMF0045 | Shipment Request |  | [메인그리드] Measure와 Requestor의 위치 변경⏎AS-IS⏎⏎⏎⏎⏎⏎⏎TO-BE |  |  |  |  |  |  |  | [검증내역_r10c7_1.png](_img/ssp45/검증내역_r10c7_1.png) [검증내역_r10c7_2.png](_img/ssp45/검증내역_r10c7_2.png) |
| SSP45-9 | 11 |  | 9 |  | DMF0045 | Shipment Request |  | Insert 이후 Frozen 구간도 입력 가능하도록 되어 있음.⏎추가행의 입력가능 셀 제약 필요. AS-IS는 일괄 오늘+10일 이후로 하드코딩 되어 있는 것 같음.⏎From Site별로 Frozen 구간 결정되는데, 행추가 이후 From Site 선택되지 않음. AS-IS와 동일하게 +10이후⏎부터 수정 가능하도록 수정( Frozen구간에 입력이 되면 문제가 될 수 있음 )⏎ |  |  |  |  |  |  |  | [검증내역_r11c7_1.png](_img/ssp45/검증내역_r11c7_1.png) |
| SSP45-10 | 12 |  | 10 |  | DMF0045 | Shipment Request |  |  |  |  |  |  |  |  |  |  |
| SSP45-11 | 13 |  | 11 |  | DMF0045 | Shipment Request |  |  |  |  |  |  |  |  |  |  |
| SSP45-12 | 14 |  | 12 |  | DMF0045 | Shipment Request |  |  |  |  |  |  |  |  |  |  |

## 4. 비정형 시트 0개 — 셀 원문 + 이미지 위치 (증빙 시트 = 결함 No. 와 같은 이름)


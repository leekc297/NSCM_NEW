# 대조표 ↔ 검증 추적표 v2 — SSP0025 (AS-IS SSP0025) · 2026-11-09T13:20:18

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 55행 (nscm-fe\features\shipping\src\pages\shipment-requestor-pic\__asis-mapping__.md) · AS-IS 액션 510행(진입점 + 전 문장) = **565행** → 검사 인스턴스 **457개**
- 행 판정: FAIL 315 · 검증완료 200 · 미검증 49 · 해당없음 1
- 인스턴스 결과: NA 174 · PASS 173 · FAIL 48 · NOPATH 30 · REVIEW 14 · ERROR 14 · NOT_RUN 4

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 6 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 2 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 2 | 0 | 0 | 0 | 7 | 3 | 2 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 10 | 0 | 0 | 0 | 0 | 44 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 7 | 17 | 0 | 1 | 4 | 15 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 2 | 0 | 0 | 0 | 0 | 3 | 0 | 5 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 2 | 0 | 0 | 0 | 0 | 3 | 0 | 5 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 2 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 7 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 3 | 6 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 20 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 18 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 29 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E3 | 편집·검증 | 있음 | 10 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 4 | 0 | 0 | 0 | 20 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F5 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 23 | 0 | 5 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 14 | 0 | 0 | 0 | 9 | 2 | 3 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 6 | 0 | 0 | 3 | 0 | 4 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J1 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 4 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 27 | 0 | 0 | 1 | 2 | 3 | 0 | 2 | 0 | 0 |
| 동적 생성·조회 | 21 | 21 | 0 | 10 | 11 | 67 | 2 | 1 | 0 | 0 |
| 콤보 후보 | 6 | 0 | 0 | 0 | 0 | 6 | 0 | 16 | 0 | 0 |
| Cascade | 32 | 6 | 0 | 0 | 0 | 21 | 0 | 0 | 0 | 0 |
| 편집·검증 | 64 | 5 | 0 | 0 | 0 | 31 | 0 | 3 | 0 | 0 |
| CRUD | 1 | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 6 | 14 | 0 | 3 | 0 | 43 | 2 | 8 | 0 | 0 |
| 공통 기능 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 11 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 |

## FAIL 인스턴스

- A6|ROW:FindButton → FindData_Main — 행 집계 — 대조표 FindButton → FindData_Main 'cs:185,249~284' 의 A6 2요소: FAIL:2 · FAIL 요소: PKG_SSP0025.P_SSP0025_GET_ITEM — 원장 V-d4de13d9 SP / 정렬대조 FAIL 1번째 키부터 다름: AS- (대조표 1행)
- F1|SCREEN — 원장 V-ba998255 RULE_SCREEN / 원장 V-e401c028 RULE_SCREEN / 원장 V-b43554df RULE_SCREEN / 원장 V-9c07278c RULE_SCREEN / 원장 V-90ec46a6 RULE_SCREEN / 원장 V-96b5f011 GENERA (대조표 70행)
- D6|SCREEN — 원장 V-f3d9b7b1 RULE_SCREEN / 원장 V-2dd948ca RULE_SCREEN / 원장 V-a5043f1c RULE_SCREEN / 원장 V-33299f4e GENERAL / 원장 V-5561da15 GENERAL / 원장 V-969da3be GENERAL / 원장 V (대조표 5행)
- F5|SCREEN — 원장 V-73ae37f0 RULE_SCREEN / 원장 V-4e526a5c RULE_SCREEN / 원장 V-c336a170 RULE_SCREEN / 원장 V-5286bad7 DEFECT / 원장 V-23b367d7 GENERAL / 원장 V-a8b969fb GENERAL / 원장 V- (대조표 5행)
- H6|COL:ITEM_ID — 원장 V-f68afbcd ASIS / 원장 V-a654a081 ASIS / 원장 V-e2ffc896 ASIS (대조표 1행)
- C3|COL:SITE_DESCRIPTION — 원장 V-ecb624d9 ASIS / 실측[T-f95e2155]: 신규행 연쇄 DIVISION_ID → SITE_DESCRIPTION: DIVISION_ID='81 Automotive Battery' → SITE_DESCRIPTION='' | DIVISION_ID='40 Mobility (대조표 5행)
- C3|ROW:R15 ComboSelChange 가드(행0) — 행 집계 — 대조표 R15 ComboSelChange 가드(행0) 'cs:674' 의 C3 13요소: NA:9 · PASS:2 · FAIL:2 · FAIL 요소: SITE_DESCRIPTION — 원장 V-ecb624d9 ASIS / 실측[T-f95e2155]: 신규행 연쇄 DIVISI (대조표 1행)
- H6|COL:USER_ID — 원장 V-97ed4734 ASIS / 원장 V-81497250 ASIS (대조표 14행)
- H6|ROW:R21 이미지셀 아이콘 — 행 집계 — 대조표 R21 이미지셀 아이콘 'cs:162~164,347~353' 의 H6 26요소: FAIL:12 · NA:9 · NOPATH:3 · NOT_RUN:2 · FAIL 요소: ITEM_ID — 원장 V-f68afbcd ASIS / 원장 V-a654a081 ASIS / 원장  (대조표 1행)
- C3|ROW:CellClick 순수가드(619/674) — 행 집계 — 대조표 CellClick 순수가드(619/674) 'cs:619,674' 의 C3 13요소: NA:9 · PASS:2 · FAIL:2 · FAIL 요소: SITE_DESCRIPTION — 원장 V-ecb624d9 ASIS / 실측[T-f95e2155]: 신규행 연쇄 DIVI (대조표 1행)
- H6|COL:SITE_DESCRIPTION — 원장 V-f68afbcd ASIS / 원장 V-a654a081 ASIS / 원장 V-e2ffc896 ASIS (대조표 1행)
- E4|MSG:MSG00004 — 원장 V-0834b71f ASIS / 실측[T-e53b2a1c]: MSG00004: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 FAIL: 저장 성공 메시지 후 재조회에 마커 'E2E_11090212'(마커 칸 없음)·필수 키 일치 행 모두 없음 — 허위 성공 (대조표 2행)
- X-ROW|ENTRY:SSP0025_ItembyDivisionPopup.DefineProperty — 진입점 집계 2검사 — FAIL:1 · NA:1 (대조표 4행)
- A10|SCREEN — 원장 V-da3afa6e RULE_SCREEN / 원장 V-cf4026ca GENERAL / 실측[T-da75f148]: 화면 진입 직후(조회 전) 그리드 0행 · 진입 시 호출 ssoUser/SEARCH(8613행) — 기대 자동 조회 (AS-IS 로드 중 조회 호출: Form_Loa (대조표 79행)
- X-ROW|ENTRY:SSP0025_ItembyDivisionPopup.FindButton — 진입점 집계 4검사 — NA:2 · REVIEW:1 · FAIL:1 (대조표 2행)
- A6|SP:P_SSP0025_GET_ITEM_BY_DIVISION_POPUP — 원장 V-d4de13d9 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['ITEM_ID', 'DIVISION_ID', 'SCM_ / 실측[T-df3a1ffd]: PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP: 화면 진입·조회 경로에 (대조표 35행)
- X-ROW|ENTRY:SSP0025_ItembyDivisionPopup.FindData — 진입점 집계 11검사 — NA:5 · PASS:2 · NOT_RUN:2 · REVIEW:1 · FAIL:1 (대조표 34행)
- X-ROW|ENTRY:SSP0025_ItembyDivisionPopup.Form_Load — 진입점 집계 2검사 — FAIL:1 · NA:1 (대조표 14행)
- X-ROW|ENTRY:SSP0025_ItembyDivisionPopup.InitControls — 진입점 집계 12검사 — NA:7 · PASS:4 · FAIL:1 (대조표 26행)
- X-ROW|ENTRY:SSP0025_ItembyDivisionPopup.InitSpread — 진입점 집계 2검사 — FAIL:1 · NA:1 (대조표 19행)
- C3|ENTRY:SSP0025_ShipmentRequestorPIC.CboDivision_SelectedIndexChanged — 진입점 집계 — 대조표 SSP0025_ShipmentRequestorPIC.CboDivision_SelectedIndexChanged 의 C3 13요소: NA:9 · PASS:2 · FAIL:2 · FAIL 요소: SITE_DESCRIPTION — 원장 V-ecb624d9 ASIS /  (대조표 1행)
- X-ROW|ENTRY:SSP0025_ShipmentRequestorPIC.DefineProperty — 진입점 집계 1검사 — FAIL:1 (대조표 5행)
- X-ROW|ENTRY:SSP0025_ShipmentRequestorPIC.FindButton — 진입점 집계 3검사 — REVIEW:1 · FAIL:1 · PASS:1 (대조표 1행)
- A6|SP:P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC — 원장 V-10718e78 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['DIVISION_ID'] ↔ TO-BE ['FN_ASI / 실측[T-4bcfb8b1]: PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC: 결과 16행이 AS-I (대조표 39행)
- X-ROW|ENTRY:SSP0025_ShipmentRequestorPIC.FindData_Main — 진입점 집계 12검사 — PASS:5 · NA:5 · REVIEW:1 · FAIL:1 (대조표 14행)
- X-ROW|ENTRY:SSP0025_ShipmentRequestorPIC.Form_Load — 진입점 집계 1검사 — FAIL:1 (대조표 2행)
- X-ROW|ENTRY:SSP0025_ShipmentRequestorPIC.InitControls — 진입점 집계 5검사 — PASS:4 · FAIL:1 (대조표 3행)
- X-ROW|ENTRY:SSP0025_ShipmentRequestorPIC.InitSpread — 진입점 집계 16검사 — PASS:12 · NA:3 · FAIL:1 (대조표 7행)
- X-ROW|ENTRY:SSP0025_ShipmentRequestorPIC.InsertButton — 진입점 집계 1검사 — FAIL:1 (대조표 1행)
- X-ROW|ENTRY:SSP0025_ShipmentRequestorPIC.SaveData — 진입점 집계 16검사 — PASS:8 · FAIL:5 · ERROR:2 · NA:1 (대조표 6행)
- E4|LEDGER:V-0834b71f — 원장 V-0834b71f / 실측[T-f7377943]: MSG00251 — EditButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(EditButton)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) (대조표 1행)
- E4|LEDGER:V-9ae33640 — 원장 V-9ae33640 / 실측[T-5d505e7b]: MSG00251 — EditButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(EditButton)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) (대조표 1행)
- E4|MSG:MSG00284 — 원장 V-9ae33640 ASIS / 실측[T-51aa1216]: MSG00284: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 FAIL: 저장 성공 메시지 후 재조회에 마커 'E2E_11090212'(마커 칸 없음)·필수 키 일치 행 모두 없음 — 허위 성공 (대조표 1행)
- C3|ENTRY:SSP0025_ShipmentRequestorPIC.SetChangedControl — 진입점 집계 — 대조표 SSP0025_ShipmentRequestorPIC.SetChangedControl 의 C3 13요소: NA:9 · PASS:2 · FAIL:2 · FAIL 요소: SITE_DESCRIPTION — 원장 V-ecb624d9 ASIS / 실측[T-f95e2155]: (대조표 1행)
- X-ROW|ENTRY:SSP0025_ShipmentRequestorPIC.SpdMain_CellClick — 진입점 집계 25검사 — NA:18 · NOPATH:3 · FAIL:2 · PASS:1 · ERROR:1 (대조표 44행)
- H6|LEDGER:V-e2ffc896 — 원장 V-e2ffc896 (대조표 1행)
- C3|COL:ITEM_ID — 실측[T-24b369d1]: 신규행 연쇄 DIVISION_ID → ITEM_ID: DIVISION_ID='81 Automotive Battery' → ITEM_ID='' | DIVISION_ID='40 Mobility & IT Battery' → ITEM_ID='' | DIVISION_ (대조표 3행)
- H6|COL:PART_LEADER — 원장 V-ed6e2a1b ASIS / 원장 V-466afccb ASIS (대조표 13행)
- H6|COL:TEAM_LEADER — 원장 V-a1a6a97f ASIS / 원장 V-883bdd72 ASIS (대조표 13행)
- H6|ENTRY:SSP0025_ShipmentRequestorPIC.SpdMain_CellDoubleClick — 원장 V-97ed4734 ASIS / 원장 V-81497250 ASIS / 원장 V-ed6e2a1b ASIS / 원장 V-466afccb ASIS / 원장 V-a1a6a97f ASIS / 원장 V-883bdd72 ASIS (대조표 1행)
- H6|LEDGER:V-97ed4734 — 원장 V-97ed4734 (대조표 1행)
- X-ROW|ENTRY:SSP0025_ShipmentRequestorPIC.SpdMain_CellDoubleClick — 진입점 집계 33검사 — NA:20 · FAIL:10 · PASS:3 (대조표 21행)
- H6|LEDGER:V-81497250 — 원장 V-81497250 (대조표 1행)
- H6|LEDGER:V-ed6e2a1b — 원장 V-ed6e2a1b (대조표 1행)
- H6|LEDGER:V-466afccb — 원장 V-466afccb (대조표 1행)
- H6|LEDGER:V-a1a6a97f — 원장 V-a1a6a97f (대조표 1행)
- H6|LEDGER:V-883bdd72 — 원장 V-883bdd72 (대조표 1행)
- X-ROW|ENTRY:SSP0025_ShipmentRequestorPIC.SpdMain_ComboSelChange — 진입점 집계 36검사 — PASS:23 · NA:11 · FAIL:2 (대조표 8행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- H6|COND:cboDivision — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- H6|COND:clbFromSite — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- G1|COND:clbDivisionId — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:clbFromSiteId — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke

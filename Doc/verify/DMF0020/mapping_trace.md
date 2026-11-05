# 대조표 ↔ 검증 추적표 v2 — DMF0020 (AS-IS DMF0020) · 2026-11-04T08:10:35

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 122행 (nscm-fe\features\master\src\pages\sales-future-price\__asis-mapping__.md) · AS-IS 액션 4645행(진입점 + 전 문장) = **4767행** → 검사 인스턴스 **1519개**
- 행 판정: 미검증 4207 · 검증완료 366 · 해당없음 124 · FAIL 70
- 인스턴스 결과: NOT_RUN 801 · ERROR 267 · NA 245 · REVIEW 95 · NOPATH 72 · PASS 22 · FAIL 17

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 8 | 0 | 22 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 11 | 3 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 18 | 0 | 46 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 6 | 0 | 25 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 25 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 2 | 0 | 22 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 3 | 0 | 29 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 11 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 9 | 2 | 0 | 53 | 0 | 3 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 0 | 4 | 0 | 17 | 113 | 105 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 9 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 9 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 30 | 3 | 11 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 29 | 3 | 13 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 0 | 0 | 0 | 0 | 5 | 0 | 7 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 9 | 0 | 63 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 15 | 0 | 23 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 9 | 0 | 47 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 8 | 0 | 25 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 20 | 0 | 140 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 2 | 0 | 2 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 3 | 0 | 23 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E2 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 날짜 형식·유효성 |
| E3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 16 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 12 | 0 | 89 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 1 | 22 | 56 | 3 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 1 | 22 | 57 | 2 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 29 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 23 | 0 | 18 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 12 | 11 | 0 | 0 | 0 | 5 | 0 | 20 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 0 | 0 | 0 | 0 | 9 | 5 | 35 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 1 | 0 | 0 | 0 | 32 | 1 | 106 | 3 | 0 | 0 |
| 동적 생성·조회 | 9 | 6 | 0 | 95 | 118 | 108 | 64 | 1 | 0 | 0 |
| 콤보 후보 | 0 | 0 | 0 | 0 | 0 | 59 | 8 | 42 | 0 | 0 |
| Cascade | 0 | 0 | 0 | 0 | 38 | 5 | 140 | 0 | 0 | 0 |
| 편집·검증 | 0 | 0 | 0 | 0 | 45 | 18 | 280 | 1 | 0 | 0 |
| CRUD | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 0 | 25 | 44 | 160 | 5 | 0 | 0 |
| 공통 기능 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 |
| 권한 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| DB 실행·접근 | 12 | 11 | 0 | 0 | 9 | 10 | 35 | 20 | 0 | 0 |

## FAIL 인스턴스

- X-LOC|ROW:7 — 구현 위치 실존 안 함: components/modals/ColumnTitleSetModal.tsx 없음 (대조표 5행)
- X-LOC|ROW:9 — 구현 위치 실존 안 함: components/modals/SalesPriceTemplateModal.tsx 없음 (대조표 5행)
- DB-SYN|ROW:1 — 행 집계 — 대조표 1 '`SCM0002_ProjectbyDivisionPopupEx` (공통)' 의 DB-SYN 39요소: NOPATH:20 · PASS:12 · NA:4 · FAIL:3 · FAIL 요소: DMF0020_GET_SPREAD_TITLE — 시노님검사 SYN_MISSIN (대조표 1행)
- DB-SYN|SP:DMF0020_GET_SPREAD_TITLE — 시노님검사 SYN_MISSING (대조표 6행)
- DB-SYN|SP:DMF0020_GET_OWNER_DATA — 시노님검사 SYN_MISSING (대조표 1행)
- DB-SYN|SP:DMF0020_GET_WEEKDATA — 시노님검사 SYN_MISSING (대조표 5행)
- X-ROW|ENTRY:DMF0020_SalesFuturePrice.FindData — 진입점 집계 43검사 — NOT_RUN:37 · REVIEW:3 · PASS:2 · FAIL:1 (대조표 19행)
- DB-SYN|ENTRY:DMF0020_SalesFuturePrice.GetCustomsHandbook — 진입점 집계 — 대조표 DMF0020_SalesFuturePrice.GetCustomsHandbook 의 DB-SYN 39요소: NOPATH:20 · PASS:12 · NA:4 · FAIL:3 · FAIL 요소: DMF0020_GET_SPREAD_TITLE — 시노님검사 SYN_MISS (대조표 2행)
- DB-SYN|ENTRY:DMF0020_SalesFuturePrice.GetDayRange — 진입점 집계 — 대조표 DMF0020_SalesFuturePrice.GetDayRange 의 DB-SYN 39요소: NOPATH:20 · PASS:12 · NA:4 · FAIL:3 · FAIL 요소: DMF0020_GET_SPREAD_TITLE — 시노님검사 SYN_MISSING; DM (대조표 2행)
- X-ROW|ENTRY:DMF0020_SalesFuturePrice.GetWeekData — 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · FAIL:1 (대조표 2행)
- X-ROW|ENTRY:DMF0020_SalesFuturePrice.SaveData — 진입점 집계 30검사 — NOT_RUN:24 · PASS:3 · NOPATH:2 · FAIL:1 (대조표 14행)
- DB-SYN|ENTRY:DMF0020_SaveSalesFuturePrice_Popup.GetDayRange — 진입점 집계 — 대조표 DMF0020_SaveSalesFuturePrice_Popup.GetDayRange 의 DB-SYN 39요소: NOPATH:20 · PASS:12 · NA:4 · FAIL:3 · FAIL 요소: DMF0020_GET_SPREAD_TITLE — 시노님검사 SYN_M (대조표 2행)
- X-ROW|ENTRY:DMF0020_SaveSalesFuturePrice_Popup.GetWeekData — 진입점 집계 4검사 — NOT_RUN:3 · FAIL:1 (대조표 9행)
- DB-SYN|ENTRY:_DMF0020_SalesFuturePrice.GetDayRange — 진입점 집계 — 대조표 _DMF0020_SalesFuturePrice.GetDayRange 의 DB-SYN 39요소: NOPATH:20 · PASS:12 · NA:4 · FAIL:3 · FAIL 요소: DMF0020_GET_SPREAD_TITLE — 시노님검사 SYN_MISSING; D (대조표 2행)
- DB-SYN|ENTRY:_DMF0020_SalesFuturePrice.GetFuturePriceInfo — 진입점 집계 — 대조표 _DMF0020_SalesFuturePrice.GetFuturePriceInfo 의 DB-SYN 39요소: NOPATH:20 · PASS:12 · NA:4 · FAIL:3 · FAIL 요소: DMF0020_GET_SPREAD_TITLE — 시노님검사 SYN_MIS (대조표 1행)
- DB-SYN|ENTRY:_DMF0020_SalesFuturePrice.GetMeasureCountInfo — 진입점 집계 — 대조표 _DMF0020_SalesFuturePrice.GetMeasureCountInfo 의 DB-SYN 39요소: NOPATH:20 · PASS:12 · NA:4 · FAIL:3 · FAIL 요소: DMF0020_GET_SPREAD_TITLE — 시노님검사 SYN_MI (대조표 1행)
- DB-SYN|ENTRY:_DMF0020_SalesFuturePrice.GetWeekData — 진입점 집계 — 대조표 _DMF0020_SalesFuturePrice.GetWeekData 의 DB-SYN 39요소: NOPATH:20 · PASS:12 · NA:4 · FAIL:3 · FAIL 요소: DMF0020_GET_SPREAD_TITLE — 시노님검사 SYN_MISSING; D (대조표 1행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- H6|BTN:btnModelType — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|BTN:btnModelType — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|BTN:btnModelType — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- A6|SP:SCM0001_GET_BIZ_TYPE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:SCM0001_GET_BIZ_TYPE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:SCM0001_GET_SITE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:SCM0001_GET_SITE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- H4|SCREEN — 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: 원장 행 실행(@verify)
- A6|SP:DM0021_GET_DM_PLN_SALES_PLAN — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:DM0021_GET_DM_PLN_SALES_PLAN — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- H6|BTN:btnOwner — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|BTN:btnOwner — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|BTN:btnOwner — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- A6|SP:P_DMF0020_GET_FUTUREPRICE_INFO — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0020_GET_FUTUREPRICE_INFO — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- J2|SCREEN — 검사기 있음(auth·authcrud spec) — 실행 필요: 원장 행 실행(@verify)
- F1|SCREEN — 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: 원장 행 실행(@verify)
- F6|SCREEN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- F4|SP:P_DMF0000_SAVE_EXCHANGE_POPUP_DATA — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F2|SCREEN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- A6|SP:P_DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:P_DMF0020_GET_MEASURE_COUNTINFO — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0020_GET_MEASURE_COUNTINFO — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:P_DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- A6|SP:DMF0020_GET_SPREAD_TITLE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:DMF0020_GET_SPREAD_TITLE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:P_DMF0020_GET_SALES_PRICE_TEMPLATE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0020_GET_SALES_PRICE_TEMPLATE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0020_GET_SPREAD_TITLE_SAVE_PRICE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:P_DMF0020_GET_SPREAD_TITLE_SAVE_PRICE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- A6|SP:P_DMF0020_GET_SPREAD_TITLE_DATE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0020_GET_SPREAD_TITLE_DATE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:DMF0020_GET_OWNER_DATA — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:DMF0020_GET_OWNER_DATA — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:DMF0020_GET_WEEKDATA — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:DMF0020_GET_WEEKDATA — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- E4|MSG:MSG00142 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- I1|SCREEN — 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00002 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00283 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00108 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00043 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00004 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00135 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- D6|SCREEN — 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00408 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00255 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00097 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- M4|POPUP:DMF0020_SalesFuturePricePopUp — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- H6|POPUP:DMF0020_SaveSalesFuturePrice_Popup — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|POPUP:DMF0020_SaveSalesFuturePrice_Popup — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|POPUP:DMF0020_SaveSalesFuturePrice_Popup — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|POPUP:DMF0020_SalesPriceRangePopUp — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- H6|POPUP:DMF0020_SalesPriceTemplatePopup — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|POPUP:DMF0020_SalesPriceTemplatePopup — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|POPUP:DMF0020_SalesPriceTemplatePopup — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- F5|SCREEN — 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: 원장 행 실행(@verify)
- K-SA|SCREEN — 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke
- G3|SCREEN — 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: 원장 행 실행(@verify)
- C2|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- D5|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D1|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:DIVISION_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- C2|COL:DEPT_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:DEPT_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:DEPT_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C2|COL:END_CUSTOMER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:END_CUSTOMER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:END_CUSTOMER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C2|COL:SCM_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:SCM_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:SCM_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:PLANT_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:PLANT_SITE_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:drpDateTime — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:clbDivisions — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- A10|SCREEN — 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: 원장 행 실행(@verify)
- G4|COND:drpDateTime — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbDivisions — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- H2|LEDGER:V-62753afe — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- X-REOPEN|SCREEN — 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace
- C2|COL:MEASURE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- C2|COL:CURRENCY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C2|COL:PROJECT_CODE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C2|COL:ITEM_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C2|COL:PLANT_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:MEASURE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:CURRENCY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:PROJECT_CODE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:ITEM_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:PLANT_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C6|COL:MEASURE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:CURRENCY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:PROJECT_CODE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:ITEM_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:PLANT_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- C2|LEDGER:V-a68ad161 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- D5|COL:PROJECT_CODE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:PLANT_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- C2|LEDGER:V-5e79374f — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:MEASURE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D1|COL:PROJECT_CODE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D1|COL:END_CUSTOMER40 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D1|COL:SCM_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D1|COL:PRICE_EXIST — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D1|COL:DEPT_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D1|COL:DEPT_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D1|COL:END_CUSTOMER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:MEASURE — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:PROJECT_CODE — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:END_CUSTOMER40 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|COL:SCM_SITE_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:PRICE_EXIST — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:DEPT_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:DEPT_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:END_CUSTOMER — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D4|LEDGER:V-ae9b4532 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-4a79ba3d — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00448 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:ITEM_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:ITEM_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-4d11e6b4 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|COND:clbDivisions — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COL:END_CUSTOMER40 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|COL:SCM_SITE_ID — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00113 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-ce566b4a — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-907a2521 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-a8be720a — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|COL:PRICE_EXIST — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00412 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-103be26f — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-3e81202a — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-fb0622c9 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-195d5e73 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-bbc21803 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-4204de5d — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-534c6df9 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-ca5021fd — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-5d239028 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-991f175a — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-89ddf6c0 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-41dc08a8 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-9e3ae4be — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:PROJECT_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:PROJECT_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-d78b66c1 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-0fd4343f — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-51d0aa46 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-8c4760fb — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-2467a7bb — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:ITEM_CLASS_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:ITEM_CLASS_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-5388bb29 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:ITEM_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:ITEM_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-b3124f2e — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:NICK_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:NICK_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-9f4f251e — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-d93b5530 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-d7f41861 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:AUTHORITY_YN — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:AUTHORITY_YN — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-89b0eb08 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-fde2bf09 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-1ad9940f — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-f2145c5e — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-c760c7d9 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-486de8b2 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-6311d909 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-dc66169d — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-7edeb33a — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-1ce0de8a — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-0b98c28c — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-dfebbc00 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-d235a405 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-2c34ba04 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-be690dc1 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:CURRENCY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:CURRENCY — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|LEDGER:V-6d021287 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|LEDGER:V-69d23751 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- H2|LEDGER:V-d013624e — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- A6|SP:P_DMF0020_GET_SCM_MST_FUTURE_PRICE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0020_GET_SCM_MST_FUTURE_PRICE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- G1|COND:txtVersion — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)

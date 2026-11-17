# 대조표 ↔ 검증 추적표 v2 — SSP0060 (AS-IS SSP0060) · 2026-11-15T09:05:56

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 274행 (nscm-fe\features\shipping\src\pages\shipment-plan\__asis-mapping__.md) · AS-IS 액션 5045행(진입점 + 전 문장) = **5319행** → 검사 인스턴스 **1787개**
- 행 판정: FAIL 2526 · 미검증 2365 · 검증완료 378 · 해당없음 49 · 미구현 1
- 인스턴스 결과: ERROR 737 · NA 545 · PASS 241 · REVIEW 133 · FAIL 91 · NOPATH 39 · NOT_RUN 1

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 50 | 16 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 1 | 6 | 0 | 0 | 0 | 6 | 1 | 7 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 70 | 28 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 14 | 0 | 0 | 1 | 36 | 21 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 20 | 0 | 0 | 40 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 41 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 2 | 8 | 0 | 3 | 9 | 0 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 9 | 0 | 0 | 0 | 25 | 2 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 7 | 0 | 0 | 0 | 1 | 5 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 42 | 0 | 0 | 34 | 0 | 137 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-NOTIMPL | 동적 생성·조회 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 미구현 = 구현 대상(FAIL) |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 4 | 51 | 0 | 7 | 53 | 77 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 4 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 4 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 13 | 18 | 0 | 2 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 14 | 18 | 0 | 5 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 7 | 1 | 0 | 0 | 1 | 7 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 30 | 0 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 87 | 0 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 1 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 59 | 0 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 43 | 15 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 4 | 0 | 0 | 0 | 57 | 6 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 8 | 0 | 0 | 0 | 9 | 38 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 11 | 6 | 0 | 0 | 0 | 0 | 숫자 소수자리·정수·부호·범위 |
| E3 | 편집·검증 | 있음 | 29 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 5 | 0 | 0 | 0 | 64 | 108 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 1 | 0 | 0 | 0 | 25 | 20 | 0 | 5 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 5 | 0 | 0 | 0 | 40 | 1 | 0 | 5 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 1 | 3 | 0 | 0 | 6 | 2 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 2 | 31 | 0 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J1 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 22 | 0 | 0 | 0 | 0 | 11 | 0 | 6 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 4 | 0 | 0 | 5 | 29 | 1 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 85 | 23 | 0 | 41 | 113 | 61 | 1 | 7 | 0 | 0 |
| 동적 생성·조회 | 67 | 60 | 0 | 85 | 88 | 221 | 0 | 1 | 0 | 0 |
| 콤보 후보 | 0 | 0 | 0 | 0 | 31 | 36 | 0 | 15 | 0 | 0 |
| Cascade | 8 | 1 | 0 | 0 | 177 | 14 | 0 | 0 | 0 | 0 |
| 편집·검증 | 46 | 0 | 0 | 0 | 193 | 178 | 0 | 0 | 0 | 0 |
| CRUD | 1 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 7 | 3 | 0 | 2 | 102 | 23 | 0 | 10 | 0 | 0 |
| 공통 기능 | 0 | 1 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 26 | 0 | 0 | 5 | 29 | 12 | 0 | 6 | 0 | 0 |

## FAIL 인스턴스

- J2|SCREEN — 원장 V-a2606f62 RULE_SCREEN / 원장 V-aa875ee8 DEFECT / 원장 V-767175f2 GENERAL / 원장 V-26768414 GENERAL / 원장 V-ce1731f9 GENERAL / 원장 V-779c3879 GENERAL / 원장 V-45c5ee7c (대조표 220행)
- A5|ROW:D00-1-054 — 행 집계 — 대조표 D00-1-054 'spdDetail' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke columns / 실측[T-3b6b3ca6]: TO_SITE: AS-IS(Div 82) (대조표 1행)
- A5|ROW:D00-1-057 — 행 집계 — 대조표 D00-1-057 'spdMain_Sheet1' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke columns / 실측[T-3b6b3ca6]: TO_SITE: AS-IS(Di (대조표 1행)
- K-SA|SCREEN — E2E smoke common Search Area 조회영역 토글 (대조표 2행)
- I1|SCREEN — 원장 V-71580525 RULE_SCREEN / 원장 V-e5329991 RULE_SCREEN / 원장 V-e29f70d6 RULE_SCREEN / 원장 V-7bce069a DEFECT / 원장 V-42ceba16 DEFECT / 원장 V-30cd4713 DEFECT / 원장 V-d8 (대조표 111행)
- F1|SCREEN — 원장 V-455fa3da RULE_SCREEN / 원장 V-6ffc13c4 RULE_SCREEN / 원장 V-5b86dddb RULE_SCREEN / 원장 V-5c2ce4a6 RULE_SCREEN / 원장 V-5b263d98 RULE_SCREEN / 원장 V-96101c34 GENERA (대조표 536행)
- A5|ROW:D00-2b-015~016 — 행 집계 — 대조표 D00-2b-015~016 'MSG00007 Measure sheet 제한' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke columns / 실측[T-3b6b3ca6]: T (대조표 1행)
- A5|ROW:D00-3-029 — 행 집계 — 대조표 D00-3-029 '조회 후 재병합·주석리셋·0치환' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke columns / 실측[T-3b6b3ca6]: TO_SITE: AS-IS (대조표 1행)
- F6|SCREEN — 원장 V-17898347 RULE_SCREEN / 원장 V-b07e6278 RULE_SCREEN / 원장 V-bdeffec2 RULE_SCREEN / 원장 V-23552254 RULE_SCREEN / 원장 V-4b42cf06 RULE_SCREEN / 원장 V-061dcbdb GENERA (대조표 519행)
- A6|SP:P_SSP0060_GET_SHIPMENT_PLAN_DETAIL — 원장 V-67e6b905 SP / 원장 V-bb23d73a SP / 정렬대조 FAIL 3번째 키부터 다름: AS-IS ['YYYYMMDD', 'ITEM_ID', 'ERP_SO_ / 정렬대조 PASS 분기 키 순서 동일 (가드 ELSE) / 실측[T-b6847aba]: PKG_SSP006 (대조표 98행)
- A6|ROW:D00-4a-002 — 행 집계 — 대조표 D00-4a-002 'FindButton' 의 A6 16요소: ERROR:9 · NOT_RUN:3 · PASS:2 · FAIL:2 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_SHIP — 원장 V-67e6b905 SP / 원장 V-bb23d73a (대조표 1행)
- A5|ROW:D00-4a-003 — 행 집계 — 대조표 D00-4a-003 'SaveButton' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke columns / 실측[T-3b6b3ca6]: TO_SITE: AS-IS(Div 8 (대조표 1행)
- A6|ROW:D00-4a-003 — 행 집계 — 대조표 D00-4a-003 'SaveButton' 의 A6 16요소: ERROR:9 · NOT_RUN:3 · PASS:2 · FAIL:2 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_SHIP — 원장 V-67e6b905 SP / 원장 V-bb23d73a (대조표 1행)
- A6|ROW:D00-4a-004 — 행 집계 — 대조표 D00-4a-004 'DeleteButton (NO-OP 확정)' 의 A6 16요소: ERROR:9 · NOT_RUN:3 · PASS:2 · FAIL:2 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_SHIP — 원장 V-67e6b905 SP /  (대조표 1행)
- A6|ROW:D00-4a-005 — 행 집계 — 대조표 D00-4a-005 'InsertButton' 의 A6 16요소: ERROR:9 · NOT_RUN:3 · PASS:2 · FAIL:2 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_SHIP — 원장 V-67e6b905 SP / 원장 V-bb23d7 (대조표 1행)
- A6|ROW:D00-4a-006~036 — 행 집계 — 대조표 D00-4a-006~036 'event 29종' 의 A6 16요소: ERROR:9 · NOT_RUN:3 · PASS:2 · FAIL:2 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_SHIP — 원장 V-67e6b905 SP / 원장 V-bb23d (대조표 1행)
- G4|ROW:D00-4e-001 — 행 집계 — 대조표 D00-4e-001 'ItembyDivision(조회조건 2차)' 의 G4 18요소: NOPATH:7 · NA:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: clbResultType / Result Type — E2E smoke labe (대조표 1행)
- G4|ROW:D00-4e-008 — 행 집계 — 대조표 D00-4e-008 'ItembyDivision(조회조건 1차)' 의 G4 18요소: NOPATH:7 · NA:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: clbResultType / Result Type — E2E smoke labe (대조표 1행)
- A6|ROW:CRUD:SEARCH — 행 집계 — 대조표 CRUD:SEARCH 'FindData_Main + Detail 8-sheet 조회' 의 A6 16요소: ERROR:9 · NOT_RUN:3 · PASS:2 · FAIL:2 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_SHIP — 원장 V-67e (대조표 1행)
- A5|ROW:I16 Measure 시트변형 — 행 집계 — 대조표 I16 Measure 시트변형 '검증축' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke columns / 실측[T-3b6b3ca6]: TO_SITE: AS-IS(Div 82 (대조표 1행)
- A5|ROW:음수 = 빨간 글자 — 행 집계 — 대조표 음수 = 빨간 글자 '**이식**' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke columns / 실측[T-3b6b3ca6]: TO_SITE: AS-IS(Div 82) ' (대조표 1행)
- X-NOTIMPL|ROW:Ra — 대조표 Ra 'L5503~5510' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- A5|ROW:메타 SQL 3종(18/19/20) 적용 — 행 집계 — 대조표 메타 SQL 3종(18/19/20) 적용 'ERROR(미실행)' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke columns / 실측[T-3b6b3ca6]: TO_SITE: (대조표 1행)
- A5|ROW:브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·EE행 TransMode 드롭다운 — 행 집계 — 대조표 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·EE행 TransMode 드롭다운 'ERROR(미실행)' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke (대조표 1행)
- A5|ROW:I9 — 행 집계 — 대조표 I9 'Division/Company 변경 시 그리드 초기화(hook #5, np §5-5)' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke columns / 실측[T-3b (대조표 1행)
- A5|ROW:I14 — 행 집계 — 대조표 I14 '정정: BaseForm.FpSpread_CellClick(BaseForm.cs L2303~' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke columns / 실측[ (대조표 1행)
- A5|ROW:I16 — 행 집계 — 대조표 I16 'InitSpreadFooterSum(.cs L764~853 — 시트별 수치구간 Sum + ' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke columns / 실측[ (대조표 1행)
- A5|ROW:COMMON:UC-01 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터 유지(keepRowVisibleUnderFil' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke colu (대조표 1행)
- A5|ROW:COMMON:UC-05 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 콤보 컬럼 Code 아닌 Name 출력' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke columns / 실측[T-3b6 (대조표 1행)
- G4|ROW:COMMON:UC-06 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 콤마 다중 입력 전건 조회' 의 G4 18요소: NOPATH:7 · NA:6 · FAIL:3 · PASS:1 · NOT_RUN:1 · FAIL 요소: clbResultType / Result Type — E2E smoke (대조표 1행)
- A5|ROW:COMMON:UC-07 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 필터 유지(rebindFilterColumns)' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E smoke columns / 실측[ (대조표 1행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.BtnItemID2_Click — 진입점 집계 9검사 — NA:4 · ERROR:3 · FAIL:1 · PASS:1 (대조표 9행)
- M3|LEDGER:V-c2145116 — 원장 V-c2145116 (대조표 1행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.BtnMeasure_Click — 진입점 집계 11검사 — ERROR:4 · FAIL:3 · NA:2 · PASS:2 (대조표 10행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.BtnNew_Click — 진입점 집계 29검사 — ERROR:19 · NOPATH:6 · NA:3 · FAIL:1 (대조표 4행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.BtnRequestor_Click — 진입점 집계 7검사 — ERROR:3 · PASS:3 · FAIL:1 (대조표 18행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.BtnSearch_Click — 진입점 집계 2검사 — FAIL:1 · ERROR:1 (대조표 24행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.EditByChange — 진입점 집계 4검사 — ERROR:3 · FAIL:1 (대조표 37행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.FindData_Detail — 진입점 집계 18검사 — PASS:10 · ERROR:4 · NA:2 · REVIEW:1 · FAIL:1 (대조표 10행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.GetErpIFCheck — 진입점 집계 12검사 — ERROR:6 · NOPATH:3 · FAIL:1 · PASS:1 · REVIEW:1 (대조표 2행)
- G4|COND:clbResultType — E2E smoke labels — 누락 라벨 (대조표 2행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.InitControls — 진입점 집계 11검사 — PASS:5 · NA:4 · ERROR:1 · FAIL:1 (대조표 8행)
- G4|COND:chkSum — E2E smoke labels — 누락 라벨 (대조표 2행)
- G4|COND:chkTotPSI — 원장 V-dbc3c7d1 SEARCH / E2E smoke labels — 누락 라벨 (대조표 2행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.InitSpread — 진입점 집계 46검사 — PASS:21 · ERROR:21 · FAIL:2 · NA:2 (대조표 19행)
- A5|COL:TO_SITE — E2E smoke columns / 실측[T-3b6b3ca6]: TO_SITE: AS-IS(Div 82) '숨김' ↔ TO-BE 표시=Y — 표시 여부 불일치 (TO-BE 메타 VISIBLE=Y) (대조표 6행)
- C1|COND:cboPlanDate — 실측[T-a94eb0c9]: AS-IS 는 하위 txtModel2 값을 비우는데 값 유지 · 'Plan Date*' → '2026-10-08' 변경 · 콤보 재요청 0건 · 하위 drpPeriod '2026.10.09 | 2026.10'→'2026.10.08 | 2026.10', drp (대조표 5행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.NewNonSoNo — 진입점 집계 8검사 — ERROR:5 · PASS:2 · FAIL:1 (대조표 135행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.NonSoNo — 진입점 집계 8검사 — ERROR:3 · PASS:2 · NA:2 · FAIL:1 (대조표 128행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.Plan_Current_Check — 진입점 집계 8검사 — NA:6 · FAIL:2 (대조표 29행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.SaveData_Detail — 진입점 집계 31검사 — PASS:12 · ERROR:10 · NA:4 · FAIL:3 · REVIEW:1 · NOPATH:1 (대조표 8행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.SaveData_Main — 진입점 집계 26검사 — ERROR:11 · PASS:9 · FAIL:3 · NA:3 (대조표 12행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.Simulation — 진입점 집계 4검사 — ERROR:3 · FAIL:1 (대조표 261행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.SoNo — 진입점 집계 8검사 — ERROR:3 · PASS:2 · NA:2 · FAIL:1 (대조표 143행)
- M3|LEDGER:V-337977ae — 원장 V-337977ae (대조표 1행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.SpdDetail_CellDoubleClick — 진입점 집계 59검사 — ERROR:39 · NA:12 · NOPATH:4 · FAIL:2 · PASS:2 (대조표 7행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.SpdDetail_ClipboardPasted — 진입점 집계 64검사 — ERROR:53 · NA:10 · FAIL:1 (대조표 21행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.SpdDetail_ComboSelChange — 진입점 집계 42검사 — ERROR:41 · FAIL:1 (대조표 11행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.SpdDetail_EditChange — 진입점 집계 28검사 — ERROR:25 · NA:2 · FAIL:1 (대조표 61행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.SpdMain_ClipboardPasted — 진입점 집계 7검사 — ERROR:4 · NA:2 · FAIL:1 (대조표 1행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.Validation_Check — 진입점 집계 26검사 — ERROR:19 · NA:6 · FAIL:1 (대조표 114행)
- M3|LEDGER:V-7acfe98c — 원장 V-7acfe98c (대조표 1행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.btnItemId_Click — 진입점 집계 9검사 — ERROR:3 · NA:3 · FAIL:2 · PASS:1 (대조표 9행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.checkValidN — 진입점 집계 3검사 — NA:2 · FAIL:1 (대조표 17행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.chkERPIFBlockYn — 진입점 집계 3검사 — NA:2 · FAIL:1 (대조표 17행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.clbCompanyID_SelectedIndexChanged — 진입점 집계 10검사 — NOT_RUN:3 · PASS:3 · NA:2 · NOPATH:1 · FAIL:1 (대조표 15행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.shtDetail_Change — 진입점 집계 9검사 — ERROR:8 · FAIL:1 (대조표 94행)
- X-ROW|ENTRY:SSP0060_ShipmentPlan.spdMain_KeyUp — 진입점 집계 2검사 — FAIL:1 · NA:1 (대조표 28행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanConfirmDetailPopup.FindButton — 진입점 집계 4검사 — ERROR:2 · REVIEW:1 · FAIL:1 (대조표 2행)
- A6|SP:P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING — 원장 V-c4c65f9c SP / 원장 V-b404c22c SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['CHANGE_REQ_NO DESC'] ↔ TO-BE [ / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-9fd84c54]: PKG_SSP0060.P_SSP006 (대조표 50행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanConfirmDetailPopup.FindDataMain — 진입점 집계 7검사 — ERROR:3 · PASS:2 · REVIEW:1 · FAIL:1 (대조표 24행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanConfirmDetailPopup.InitSpread — 진입점 집계 190검사 — NA:76 · PASS:59 · ERROR:54 · FAIL:1 (대조표 74행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanConfirmDetailPopup.btnButtonList_UsrButtonList_Click_Detected — 진입점 집계 3검사 — ERROR:2 · FAIL:1 (대조표 3행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.ChkERPIFBlockYn — 진입점 집계 4검사 — NA:2 · FAIL:1 · ERROR:1 (대조표 29행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.ChkEngProcessing — 진입점 집계 7검사 — PASS:2 · NA:2 · REVIEW:1 · ERROR:1 · FAIL:1 (대조표 29행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.FindButton — 진입점 집계 4검사 — ERROR:2 · REVIEW:1 · FAIL:1 (대조표 2행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.FindData_Main — 진입점 집계 7검사 — ERROR:2 · PASS:2 · REVIEW:1 · FAIL:1 · NA:1 (대조표 26행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.GetERPInterface — 진입점 집계 25검사 — NA:12 · ERROR:9 · PASS:3 · FAIL:1 (대조표 107행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.GetShipmentStatusChk — 진입점 집계 13검사 — NA:7 · ERROR:3 · PASS:2 · FAIL:1 (대조표 31행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.InitSpread — 진입점 집계 194검사 — NA:77 · PASS:59 · ERROR:57 · FAIL:1 (대조표 72행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.NonSoNo — 진입점 집계 7검사 — ERROR:3 · PASS:2 · FAIL:1 · NA:1 (대조표 225행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.SSP0060_ShipmentPlanRequestPopup_FormClosing — 진입점 집계 7검사 — ERROR:5 · FAIL:1 · NOT_RUN:1 (대조표 6행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.SaveButton — 진입점 집계 8검사 — ERROR:4 · FAIL:2 · PASS:1 · REVIEW:1 (대조표 1행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.SaveData — 진입점 집계 23검사 — PASS:8 · ERROR:8 · FAIL:3 · NA:3 · REVIEW:1 (대조표 184행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.SoNo — 진입점 집계 10검사 — ERROR:4 · NA:3 · PASS:2 · FAIL:1 (대조표 155행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.Validation_Check — 진입점 집계 5검사 — ERROR:2 · NA:2 · FAIL:1 (대조표 31행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.btnAutoSet_Click — 진입점 집계 9검사 — ERROR:6 · FAIL:2 · NA:1 (대조표 4행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.btnButtonList_UsrButtonList_Click_Detected — 진입점 집계 3검사 — ERROR:2 · FAIL:1 (대조표 3행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.spdMain_ClipboardPasted — 진입점 집계 6검사 — ERROR:4 · FAIL:1 · NA:1 (대조표 6행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.spdMain_KeyDown — 진입점 집계 3검사 — ERROR:1 · FAIL:1 · NA:1 (대조표 46행)
- X-ROW|ENTRY:SSP0060_ShipmentPlanRequestPopup.usrButtonList1_UsrButtonList_Click_Detected — 진입점 집계 3검사 — ERROR:2 · FAIL:1 (대조표 8행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- G4|COND:cboChangeReason — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke

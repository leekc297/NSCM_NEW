# 대조표 ↔ 검증 추적표 v2 — SYS0004 (AS-IS SCM0004) · 2026-10-26T13:00:19

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 0행 (없음) · AS-IS 액션 869행(진입점 + 전 문장) = **869행** → 검사 인스턴스 **77개**
- 행 판정: 미검증 853 · 검증완료 16
- 인스턴스 결과: REVIEW 39 · NOT_RUN 18 · NA 13 · NOPATH 7

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REOPEN | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 32 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C1 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1회 저장(변경 감지) |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 저장 후 값 보존 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) |
| DB-SYN | DB 실행·접근 | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 4 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 4 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 0 | 0 | 0 | 0 | 0 | 7 | 2 | 0 | 0 | 0 |
| 동적 생성·조회 | 0 | 0 | 0 | 35 | 0 | 0 | 5 | 1 | 0 | 0 |
| 콤보 후보 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| Cascade | 0 | 0 | 0 | 0 | 0 | 2 | 1 | 0 | 0 | 0 |
| 편집·검증 | 0 | 0 | 0 | 2 | 0 | 4 | 3 | 0 | 0 | 0 |
| CRUD | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 2 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 |
| 공통 기능 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 0 | 0 | 0 | 2 | 0 | 0 | 4 | 4 | 0 | 0 |

## FAIL 인스턴스


## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- M3|POPUP:SCM0004MOD_UI_CategorySetup — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace
- X-REOPEN|SCREEN — 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace
- A6|SP:SCM0004_GET_UI_CATEGORY_SETUP_MEASURE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:SCM0004_GET_UI_CATEGORY_SETUP_MEASURE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A10|SCREEN — 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace
- G6|COND:cboValid — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:cboValid — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- C1|COND:cboValid — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- D6|SCREEN — 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace
- F1|SCREEN — 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud
- F4|SP:SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- E4|MSG:MSG00004 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- I1|SCREEN — 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta
- E4|MSG:MSG00052 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- A6|SP:SCM0004_GET_UI_CATEGORY_SETUP_COLUMN — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:SCM0004_GET_UI_CATEGORY_SETUP_COLUMN — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- M3|POPUP:YOUR_CALL — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace

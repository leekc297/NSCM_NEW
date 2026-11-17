# 대조표 ↔ 검증 추적표 v2 — SSP0200 (AS-IS SSP0200) · 2026-11-15T08:53:39

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 143행 (nscm-fe\features\shipping\src\pages\shipment-change-request-plan\__asis-mapping__.md) · AS-IS 액션 2770행(진입점 + 전 문장) = **2913행** → 검사 인스턴스 **1357개**
- 행 판정: FAIL 1386 · 미검증 1101 · 검증완료 305 · 해당없음 108 · 미구현 13
- 인스턴스 결과: ERROR 511 · NA 327 · FAIL 183 · PASS 151 · REVIEW 116 · NOPATH 44 · BLOCKED 22 · NOT_RUN 2 · WARN 1

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 19 | 33 | 0 | 2 | 12 | 0 | 0 | 0 | 0 | 5 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 2 | 18 | 0 | 0 | 0 | 4 | 2 | 6 | 0 | 1 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 14 | 28 | 0 | 0 | 19 | 14 | 0 | 0 | 0 | 5 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 21 | 0 | 0 | 1 | 28 | 10 | 0 | 0 | 0 | 5 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 15 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 3 | 0 | 0 | 35 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 1 | 6 | 0 | 0 | 5 | 1 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 6 | 31 | 0 | 0 | 3 | 2 | 0 | 0 | 0 | 1 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 6 | 0 | 0 | 0 | 0 | 21 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 10 | 3 | 0 | 71 | 0 | 30 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-NOTIMPL | 동적 생성·조회 | 있음 | 0 | 13 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 미구현 = 구현 대상(FAIL) |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 3 | 25 | 0 | 1 | 24 | 24 | 0 | 0 | 0 | 1 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 5 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 5 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 3 | 0 | 0 | 0 | 0 | 18 | 0 | 2 | 0 | 1 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 12 | 10 | 0 | 5 | 0 | 1 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 4 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 44 | 2 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 2 | 0 | 0 | 0 | 62 | 18 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 81 | 2 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 19 | 0 | 0 | 4 | 4 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 53 | 2 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 2 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 0 | 1 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 12 | 3 | 0 | 0 | 2 | 10 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 숫자 소수자리·정수·부호·범위 |
| E2 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 날짜 형식·유효성 |
| E3 | 편집·검증 | 있음 | 2 | 0 | 0 | 0 | 10 | 2 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 1 | 0 | 0 | 0 | 69 | 116 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 1 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 2 | 0 | 0 | 0 | 9 | 14 | 0 | 8 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 1 | 0 | 0 | 0 | 24 | 0 | 0 | 8 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 1 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 1 | 0 | 0 | 1 | 13 | 0 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J1 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 12 | 0 | 0 | 0 | 0 | 7 | 0 | 4 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 3 | 0 | 0 | 4 | 13 | 4 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 71 | 81 | 0 | 4 | 60 | 30 | 2 | 6 | 0 | 17 |
| 동적 생성·조회 | 31 | 78 | 1 | 107 | 32 | 78 | 0 | 0 | 0 | 2 |
| 콤보 후보 | 3 | 0 | 0 | 0 | 12 | 30 | 0 | 17 | 0 | 2 |
| Cascade | 6 | 0 | 0 | 0 | 187 | 23 | 0 | 0 | 0 | 0 |
| 편집·검증 | 18 | 22 | 0 | 0 | 147 | 141 | 0 | 1 | 0 | 1 |
| CRUD | 1 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 4 | 1 | 0 | 1 | 54 | 14 | 0 | 16 | 0 | 0 |
| 공통 기능 | 1 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 15 | 0 | 0 | 4 | 13 | 11 | 0 | 4 | 0 | 0 |

## FAIL 인스턴스

- G1|ROW:설계 정본 — 행 집계 — 대조표 설계 정본 '`.atlas/gscm-design/SSP0200/design/00_checklist.md' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9  (대조표 1행)
- K-SA|SCREEN — E2E smoke common Search Area 조회영역 토글 (대조표 3행)
- A5|ROW:L-014·L-015·**L-126** — 행 집계 — 대조표 L-014·L-015·**L-126** '`layoutControlItem5`/`txtRequestNo` — `Visibility=' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E (대조표 1행)
- G1|ROW:L-016 ~ L-019·**L-148** — 행 집계 — 대조표 L-016 ~ L-019·**L-148** '요청자/부서 세션 주입(언어별 `UserName`/`UserName_E`)' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V- (대조표 1행)
- G4|ROW:L-047 ~ L-049·L-053 ~ L-056 — 행 집계 — 대조표 L-047 ~ L-049·L-053 ~ L-056 '조회조건 라벨' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id / Item — E2E smoke labe (대조표 1행)
- G1|ROW:L-047 ~ L-049·L-053 ~ L-056 — 행 집계 — 대조표 L-047 ~ L-049·L-053 ~ L-056 '조회조건 라벨' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 SEARCH / E2E smoke co (대조표 1행)
- A5|ROW:**L-050** — 행 집계 — 대조표 **L-050** '`PlanType1`(Change Type 라벨/콤보) `Visibility=Never`(' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke col (대조표 1행)
- H2|ROW:**L-050** — 행 집계 — 대조표 **L-050** '`PlanType1`(Change Type 라벨/콤보) `Visibility=Never`(' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode  (대조표 1행)
- A5|ROW:L-062·L-063 — 행 집계 — 대조표 L-062·L-063 '`VisibleTab(true)` 2건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거  (대조표 1행)
- H2|ROW:L-062·L-063 — 행 집계 — 대조표 L-062·L-063 '`VisibleTab(true)` 2건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 (대조표 1행)
- X-NOTIMPL|ROW:**L-065·L-070·L-071** — 대조표 **L-065·L-070·L-071** '`SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` · `SCM_SSP_DELETE_..._BY_CONFIRM` · `PR_SSP_XIF_..._I' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작 (대조표 1행)
- X-NOTIMPL|ROW:L-066 ~ L-069 — 대조표 L-066 ~ L-069 '`DELETE_..._DRAFTING` / `GET_SHIPMENT_STATUS` / `GET_ERP_SO_NO_CNT`' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구 (대조표 1행)
- A6|ROW:L-072 — 행 집계 — 대조표 L-072 '`FindButton` = `FindData_Main(); FindData_Sub_Draf' 의 A6 8요소: ERROR:5 · NA:1 · PASS:1 · FAIL:1 · FAIL 요소: PKG_SSP0200.P_SSP0200_GET_SHIP — 원장  (대조표 1행)
- G1|ROW:L-072 — 행 집계 — 대조표 L-072 '`FindButton` = `FindData_Main(); FindData_Sub_Draf' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9  (대조표 1행)
- A5|ROW:L-081 — 행 집계 — 대조표 L-081 '`SheetName == shtMain` 일 때만 저장' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [ (대조표 1행)
- H2|ROW:L-081 — 행 집계 — 대조표 L-081 '`SheetName == shtMain` 일 때만 저장' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / (대조표 1행)
- I1|SCREEN — 원장 V-416fa20f RULE_SCREEN / 원장 V-d990dbbd RULE_SCREEN / 원장 V-18228284 RULE_SCREEN / 원장 V-49529088 DEFECT / 원장 V-177dc221 DEFECT / 원장 V-4457374f DEFECT / 원장 V-4b (대조표 111행)
- H10|SCREEN — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 (대조표 34행)
- D1|ROW:**L-127·L-128** — 행 집계 — 대조표 **L-127·L-128** 'Division 권한 0건 → 조회영역 전체 잠금 + `return`(이후 초기화 전부 중' 의 D1 19요소: FAIL:11 · NA:4 · ERROR:4 · FAIL 요소: DIVISION_ID / Div — 원장 V-1c4187ef (대조표 1행)
- G1|ROW:**L-127·L-128** — 행 집계 — 대조표 **L-127·L-128** 'Division 권한 0건 → 조회영역 전체 잠금 + `return`(이후 초기화 전부 중' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V (대조표 1행)
- X-NOTIMPL|ROW:L-149·L-150 — 대조표 L-149·L-150 '`CHANGE_REQ_DAY`(`D`/`-56`) → `dDay` → `dBaseDate = 오늘 + dDay`' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기 (대조표 1행)
- X-NOTIMPL|ROW:L-151 — 대조표 L-151 '`SHIPMENT_PERIOD_DAY`(`1D+`=56 / `2D-`=30) → 출하일 상·하한' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- A6|ROW:**L-152** — 행 집계 — 대조표 **L-152** '조회 SP 2번째 커서로 승인자 **빈칸일 때만** 자동채움' 의 A6 8요소: ERROR:5 · NA:1 · PASS:1 · FAIL:1 · FAIL 요소: PKG_SSP0200.P_SSP0200_GET_SHIP — 원장 V-0e0257e2 SP (대조표 1행)
- G1|ROW:**L-152** — 행 집계 — 대조표 **L-152** '조회 SP 2번째 커서로 승인자 **빈칸일 때만** 자동채움' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 SEARCH / E2E  (대조표 1행)
- G4|ROW:9필드 인벤토리 — 행 집계 — 대조표 9필드 인벤토리 'Div / From Site / To Site / Status / Shipment Date' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id (대조표 1행)
- G1|ROW:9필드 인벤토리 — 행 집계 — 대조표 9필드 인벤토리 'Div / From Site / To Site / Status / Shipment Date' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259e (대조표 1행)
- G4|ROW:필드 수 > 6 — 행 집계 — 대조표 필드 수 > 6 '—' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id / Item — E2E smoke labels — 누락 라벨 (대조표 1행)
- G1|ROW:필드 수 > 6 — 행 집계 — 대조표 필드 수 > 6 '—' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 SEARCH / E2E smoke cond combo (대조표 1행)
- G4|ROW:**C1** — 행 집계 — 대조표 **C1** '`dtChangeStatusCode.Rows.RemoveAt(0)` = Status 콤보에' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id / (대조표 1행)
- G1|ROW:**C1** — 행 집계 — 대조표 **C1** '`dtChangeStatusCode.Rows.RemoveAt(0)` = Status 콤보에' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 (대조표 1행)
- G4|ROW:**C2·C3** — 행 집계 — 대조표 **C2·C3** '`CODE != "EE"` — **완전일치 1건만** 제외' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id / Item — E2E smo (대조표 1행)
- G1|ROW:**C2·C3** — 행 집계 — 대조표 **C2·C3** '`CODE != "EE"` — **완전일치 1건만** 제외' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 SEARCH / E2E s (대조표 1행)
- X-NOTIMPL|ROW:**C4** — 대조표 **C4** '`JVFlag = dtMyDivision[ATTRIBUTE1] == '0'`' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- G4|ROW:**C5** — 행 집계 — 대조표 **C5** '`GetCheckedListValue(..., !JVFlag)` — 3번째 인자 false' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id / (대조표 1행)
- G1|ROW:**C5** — 행 집계 — 대조표 **C5** '`GetCheckedListValue(..., !JVFlag)` — 3번째 인자 false' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 (대조표 1행)
- G4|ROW:cascade 5단계 — 행 집계 — 대조표 cascade 5단계 'Div → From/To Site **서버 재조회**, ChangeType → 기간 재산출' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item (대조표 1행)
- G1|ROW:cascade 5단계 — 행 집계 — 대조표 cascade 5단계 'Div → From/To Site **서버 재조회**, ChangeType → 기간 재산출' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-382 (대조표 1행)
- A5|ROW:cascade 5단계 — 행 집계 — 대조표 cascade 5단계 'Div → From/To Site **서버 재조회**, ChangeType → 기간 재산출' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke c (대조표 1행)
- H2|ROW:cascade 5단계 — 행 집계 — 대조표 cascade 5단계 'Div → From/To Site **서버 재조회**, ChangeType → 기간 재산출' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mod (대조표 1행)
- G4|ROW:초기 mount 무발화 — 행 집계 — 대조표 초기 mount 무발화 '`InitEvent()` 가 마지막이라 초기 설정이 cascade 를 트리거하지 않는다' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item  (대조표 1행)
- G1|ROW:초기 mount 무발화 — 행 집계 — 대조표 초기 mount 무발화 '`InitEvent()` 가 마지막이라 초기 설정이 cascade 를 트리거하지 않는다' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-3825 (대조표 1행)
- G4|ROW:자동조회 금지 — 행 집계 — 대조표 자동조회 금지 '`FindData_Main` 은 `FindButton` 에서만' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id / Item — E2E smo (대조표 1행)
- G1|ROW:자동조회 금지 — 행 집계 — 대조표 자동조회 금지 '`FindData_Main` 은 `FindButton` 에서만' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 SEARCH / E2E s (대조표 1행)
- A6|ROW:자동조회 금지 — 행 집계 — 대조표 자동조회 금지 '`FindData_Main` 은 `FindButton` 에서만' 의 A6 8요소: ERROR:5 · NA:1 · PASS:1 · FAIL:1 · FAIL 요소: PKG_SSP0200.P_SSP0200_GET_SHIP — 원장 V-0e0257e2 SP  (대조표 1행)
- G4|ROW:payload 12키 — 행 집계 — 대조표 payload 12키 'cs:1468~1482 · 1540~1541' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id / Item — E2E smoke lab (대조표 1행)
- G1|ROW:payload 12키 — 행 집계 — 대조표 payload 12키 'cs:1468~1482 · 1540~1541' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 SEARCH / E2E smoke c (대조표 1행)
- G4|ROW:Period 기본값 — 행 집계 — 대조표 Period 기본값 '`GetDayRange("")` = `SCM0001_GET_SCP_DAY_PERIOD`' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id (대조표 1행)
- G1|ROW:Period 기본값 — 행 집계 — 대조표 Period 기본값 '`GetDayRange("")` = `SCM0001_GET_SCP_DAY_PERIOD`' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259e (대조표 1행)
- G4|ROW:Model 팝업 — 행 집계 — 대조표 Model 팝업 '`SCM0002_ItembyDivisionPopup` — `sdivision` + **`s' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id (대조표 1행)
- G1|ROW:Model 팝업 — 행 집계 — 대조표 Model 팝업 '`SCM0002_ItembyDivisionPopup` — `sdivision` + **`s' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259e (대조표 1행)
- G4|ROW:Designer 잔여 초기값 — 행 집계 — 대조표 Designer 잔여 초기값 '`2013-07-12` / `1999-01-01`' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id / Item — E2E sm (대조표 1행)
- G1|ROW:Designer 잔여 초기값 — 행 집계 — 대조표 Designer 잔여 초기값 '`2013-07-12` / `1999-01-01`' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 SEARCH / E2E  (대조표 1행)
- G4|COND:txtItemId — E2E smoke labels — 누락 라벨 (대조표 1행)
- G4|ROW:`ChangeType='A'` — 행 집계 — 대조표 `ChangeType='A'` '목록에 있고 항상 else 경로' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id / Item — E2E smoke label (대조표 1행)
- G1|ROW:`ChangeType='A'` — 행 집계 — 대조표 `ChangeType='A'` '목록에 있고 항상 else 경로' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 SEARCH / E2E smoke con (대조표 1행)
- X-LOC|ROW:R-01·R-02 — 구현 위치 실존 안 함: MainGrid.tsx 없음, SubGrid.tsx 없음 (대조표 1행)
- A5|ROW:R-01·R-02 — 행 집계 — 대조표 R-01·R-02 '`FpSpread` 2 + 이벤트 10' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족 (대조표 1행)
- H2|ROW:R-01·R-02 — 행 집계 — 대조표 R-01·R-02 '`FpSpread` 2 + 이벤트 10' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V (대조표 1행)
- A5|ROW:R-10 — 행 집계 — 대조표 R-10 '시트 초기화 폭/라벨/헤더 span/소수 32건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족 (대조표 1행)
- H2|ROW:R-10 — 행 집계 — 대조표 R-10 '시트 초기화 폭/라벨/헤더 span/소수 32건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V (대조표 1행)
- G4|ROW:R-12 — 행 집계 — 대조표 R-12 'div 40/EE 컬럼 표시 전환(시트 축) 12건' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id / Item — E2E smoke labels (대조표 1행)
- G1|ROW:R-12 — 행 집계 — 대조표 R-12 'div 40/EE 컬럼 표시 전환(시트 축) 12건' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 SEARCH / E2E smoke cond (대조표 1행)
- A5|ROW:R-12 — 행 집계 — 대조표 R-12 'div 40/EE 컬럼 표시 전환(시트 축) 12건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거  (대조표 1행)
- H2|ROW:R-12 — 행 집계 — 대조표 R-12 'div 40/EE 컬럼 표시 전환(시트 축) 12건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 (대조표 1행)
- G4|ROW:R-13 — 행 집계 — 대조표 R-13 'div 셀 변경 cascade(행 축) 23건' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id / Item — E2E smoke labels —  (대조표 1행)
- G1|ROW:R-13 — 행 집계 — 대조표 R-13 'div 셀 변경 cascade(행 축) 23건' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 SEARCH / E2E smoke cond co (대조표 1행)
- A5|ROW:R-13 — 행 집계 — 대조표 R-13 'div 셀 변경 cascade(행 축) 23건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족: (대조표 1행)
- H2|ROW:R-13 — 행 집계 — 대조표 R-13 'div 셀 변경 cascade(행 축) 23건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V- (대조표 1행)
- D1|ROW:R-13 — 행 집계 — 대조표 R-13 'div 셀 변경 cascade(행 축) 23건' 의 D1 19요소: FAIL:11 · NA:4 · ERROR:4 · FAIL 요소: DIVISION_ID / Div — 원장 V-1c4187ef COLUMN / 원장 V-00e520c0 COLUMN / 실측[ (대조표 1행)
- H2|COL:TRANSPORT_MODE — 원장 V-5c9d1bd7 COLUMN / 원장 V-aa0a2227 COLUMN / 원장 V-d5f5548e ASIS / 원장 V-39282d7d ASIS / 실측[T-5b78bc4e]: TRANSPORT_MODE: 기존행 편집=true 표시 일치 · 신규행 편집 불가인데 노랑 (대조표 7행)
- A6|ROW:R-14 — 행 집계 — 대조표 R-14 'TO_SITE/FROM_SITE 변경 → `INCOTERMS`/`TRANSPORT_MODE' 의 A6 8요소: ERROR:5 · NA:1 · PASS:1 · FAIL:1 · FAIL 요소: PKG_SSP0200.P_SSP0200_GET_SHIP — 원장 V (대조표 1행)
- G1|ROW:R-14 — 행 집계 — 대조표 R-14 'TO_SITE/FROM_SITE 변경 → `INCOTERMS`/`TRANSPORT_MODE' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 S (대조표 1행)
- A5|ROW:R-18 — 행 집계 — 대조표 R-18 'BOD 0행 처리' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족: 기대원천 GENERAL =  (대조표 1행)
- H2|ROW:R-18 — 행 집계 — 대조표 R-18 'BOD 0행 처리' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V-aa0a2227 COLUMN  (대조표 1행)
- A6|ROW:R-18 — 행 집계 — 대조표 R-18 'BOD 0행 처리' 의 A6 8요소: ERROR:5 · NA:1 · PASS:1 · FAIL:1 · FAIL 요소: PKG_SSP0200.P_SSP0200_GET_SHIP — 원장 V-0e0257e2 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-I (대조표 1행)
- A5|ROW:R-20·R-21 — 행 집계 — 대조표 R-20·R-21 "동일 SO 전파 + 행상태 `'M'`" 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족: (대조표 1행)
- H2|ROW:R-20·R-21 — 행 집계 — 대조표 R-20·R-21 "동일 SO 전파 + 행상태 `'M'`" 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V- (대조표 1행)
- A5|COL:NEW_LT_DAY — E2E smoke columns / 실측[T-ef617a07]: NEW_LT_DAY: AS-IS(Div 40) '숨김' ↔ TO-BE 표시=Y — 표시 여부 불일치 (TO-BE 메타 VISIBLE=N) (대조표 5행)
- A5|ROW:R-24 — 행 집계 — 대조표 R-24 'CHANGE_REASON 연동 11건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족: 기대원천 (대조표 1행)
- H2|ROW:R-24 — 행 집계 — 대조표 R-24 'CHANGE_REASON 연동 11건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V-aa0a2 (대조표 1행)
- A5|ROW:R-27 — 행 집계 — 대조표 R-27 '소수자릿수 동적 전환 8건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족: 기대원천 GENER (대조표 1행)
- H2|ROW:R-27 — 행 집계 — 대조표 R-27 '소수자릿수 동적 전환 8건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V-aa0a2227 CO (대조표 1행)
- D1|ROW:R-27 — 행 집계 — 대조표 R-27 '소수자릿수 동적 전환 8건' 의 D1 19요소: FAIL:11 · NA:4 · ERROR:4 · FAIL 요소: DIVISION_ID / Div — 원장 V-1c4187ef COLUMN / 원장 V-00e520c0 COLUMN / 실측[T-d71b66e9] (대조표 1행)
- G1|ROW:R-27 — 행 집계 — 대조표 R-27 '소수자릿수 동적 전환 8건' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 SEARCH / E2E smoke cond combo (대조표 1행)
- A5|ROW:R-29 — 행 집계 — 대조표 R-29 '검증 전 색/상태 초기화 16건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족: 기대원천 GE (대조표 1행)
- H2|ROW:R-29 — 행 집계 — 대조표 R-29 '검증 전 색/상태 초기화 16건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V-aa0a2227 (대조표 1행)
- X-NOTIMPL|ROW:**R-30** — 대조표 **R-30** '`CHK` 헤더 전체선택 8건' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- X-NOTIMPL|ROW:R-31① — 대조표 R-31① '`RollBack_Flag` 포커스 복귀' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- A5|ROW:R-31② — 행 집계 — 대조표 R-31② 'EditButton 잠금 8건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족: 기대원천 GE (대조표 1행)
- H2|ROW:R-31② — 행 집계 — 대조표 R-31② 'EditButton 잠금 8건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V-aa0a2227 (대조표 1행)
- D1|ROW:R-31② — 행 집계 — 대조표 R-31② 'EditButton 잠금 8건' 의 D1 19요소: FAIL:11 · NA:4 · ERROR:4 · FAIL 요소: DIVISION_ID / Div — 원장 V-1c4187ef COLUMN / 원장 V-00e520c0 COLUMN / 실측[T-d71b66 (대조표 1행)
- A5|ROW:EditButton cs:783 — 행 집계 — 대조표 EditButton cs:783 '`siSub.RowCount==0` 일 때만 편집모드 진입 = 작성 중 요청이 있으면 상단' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E s (대조표 1행)
- H2|ROW:EditButton cs:783 — 행 집계 — 대조표 EditButton cs:783 '`siSub.RowCount==0` 일 때만 편집모드 진입 = 작성 중 요청이 있으면 상단' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Tra (대조표 1행)
- D1|ROW:EditButton cs:783 — 행 집계 — 대조표 EditButton cs:783 '`siSub.RowCount==0` 일 때만 편집모드 진입 = 작성 중 요청이 있으면 상단' 의 D1 19요소: FAIL:11 · NA:4 · ERROR:4 · FAIL 요소: DIVISION_ID / Div — 원장 V-1c4187 (대조표 1행)
- A5|ROW:R-31③④ — 행 집계 — 대조표 R-31③④ '`Query(ds)` 바인딩 / 조회 직후 전열 잠금' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [ (대조표 1행)
- H2|ROW:R-31③④ — 행 집계 — 대조표 R-31③④ '`Query(ds)` 바인딩 / 조회 직후 전열 잠금' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / (대조표 1행)
- D1|ROW:R-31③④ — 행 집계 — 대조표 R-31③④ '`Query(ds)` 바인딩 / 조회 직후 전열 잠금' 의 D1 19요소: FAIL:11 · NA:4 · ERROR:4 · FAIL 요소: DIVISION_ID / Div — 원장 V-1c4187ef COLUMN / 원장 V-00e520c0 COLUMN (대조표 1행)
- G1|ROW:R-31③④ — 행 집계 — 대조표 R-31③④ '`Query(ds)` 바인딩 / 조회 직후 전열 잠금' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 SEARCH / E2E smoke c (대조표 1행)
- A5|ROW:R-40 — 행 집계 — 대조표 R-40 'spCalls 12건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족: 기대원천 GENERAL  (대조표 1행)
- H2|ROW:R-40 — 행 집계 — 대조표 R-40 'spCalls 12건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V-aa0a2227 COLUM (대조표 1행)
- A5|ROW:R-41 — 행 집계 — 대조표 R-41 'entryPoints 12건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족: 기대원천 GENE (대조표 1행)
- H2|ROW:R-41 — 행 집계 — 대조표 R-41 'entryPoints 12건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V-aa0a2227 C (대조표 1행)
- G1|ROW:R-41 — 행 집계 — 대조표 R-41 'entryPoints 12건' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 SEARCH / E2E smoke cond combo (대조표 1행)
- A5|ROW:R-50 — 행 집계 — 대조표 R-50 'buttonGuards 52건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족: 기대원천 GEN (대조표 1행)
- H2|ROW:R-50 — 행 집계 — 대조표 R-50 'buttonGuards 52건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V-aa0a2227  (대조표 1행)
- D1|ROW:R-50 — 행 집계 — 대조표 R-50 'buttonGuards 52건' 의 D1 19요소: FAIL:11 · NA:4 · ERROR:4 · FAIL 요소: DIVISION_ID / Div — 원장 V-1c4187ef COLUMN / 원장 V-00e520c0 COLUMN / 실측[T-d71b66e (대조표 1행)
- A5|ROW:R-51 — 행 집계 — 대조표 R-51 'validations 36건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족: 기대원천 GENE (대조표 1행)
- H2|ROW:R-51 — 행 집계 — 대조표 R-51 'validations 36건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V-aa0a2227 C (대조표 1행)
- A5|ROW:R-52 — 행 집계 — 대조표 R-52 'popups 5건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족: 기대원천 GENERAL =  (대조표 1행)
- H2|ROW:R-52 — 행 집계 — 대조표 R-52 'popups 5건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장 V-aa0a2227 COLUMN  (대조표 1행)
- X-NOTIMPL|ROW:R-60 C7~C9 — 대조표 R-60 C7~C9 '원본 스냅샷 대조' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- A5|ROW:R-60 C10 — 행 집계 — 대조표 R-60 C10 '동일 SO 부분선택 → `MSG00247`' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증거 부 (대조표 1행)
- H2|ROW:R-60 C10 — 행 집계 — 대조표 R-60 C10 '동일 SO 부분선택 → `MSG00247`' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN / 원장  (대조표 1행)
- X-NOTIMPL|ROW:R-60 C12·C13 — 대조표 R-60 C12·C13 '`GetItemFromBOD` 전극 판정' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- A5|ROW:R-70 D1·D2·D4·D5 — 행 집계 — 대조표 R-70 D1·D2·D4·D5 "ChangeType='P' 폭 0/복원" 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: (대조표 1행)
- H2|ROW:R-70 D1·D2·D4·D5 — 행 집계 — 대조표 R-70 D1·D2·D4·D5 "ChangeType='P' 폭 0/복원" 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN (대조표 1행)
- X-NOTIMPL|ROW:R-70 D3·D6 — 대조표 R-70 D3·D6 '수량 라벨 동적 교체' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- X-NOTIMPL|ROW:R-70 D7·D8 — 대조표 R-70 D7·D8 'shtSub CHK 헤더 체크박스 + 장식 Border' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- A5|ROW:R-70 D11~D16 — 행 집계 — 대조표 R-70 D11~D16 '`cellTypeImage` 경로별 차이' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke columns / 실측[T-4e2e49d9]: [증 (대조표 1행)
- H2|ROW:R-70 D11~D16 — 행 집계 — 대조표 R-70 D11~D16 '`cellTypeImage` 경로별 차이' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 COLUMN /  (대조표 1행)
- X-NOTIMPL|ROW:R-70 D17 — 대조표 R-70 D17 '`CharacterCasing.Upper`(ITEM_ID/PROJECT_CODE 대문자 강제)' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- X-NOTIMPL|ROW:R-70 D18 — 대조표 R-70 D18 '`SuspendLayout`/`ResumeLayout`' 의 상태가 '미구현' — 사유: (사유 미기재) → AS-IS 의 이 동작이 TO-BE 화면에 없음 = 구현 필요(FAIL · 구현 엔진 대기열) (대조표 1행)
- X-LOC|ROW:COMMON:UC-02 — 구현 위치 실존 안 함: MainGrid.tsx 없음 (대조표 1행)
- A5|ROW:COMMON:UC-02 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke  (대조표 1행)
- H2|ROW:COMMON:UC-02 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mo (대조표 1행)
- G1|ROW:COMMON:UC-02 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38 (대조표 1행)
- G1|ROW:COMMON:UC-03 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38 (대조표 1행)
- X-LOC|ROW:COMMON:UC-05 — 구현 위치 실존 안 함: hooks/useShipmentChangeRequestPlanToolbar.ts:57-57 > 54줄 (대조표 1행)
- D5|ROW:COMMON:UC-05 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 D5 25요소: PASS:12 · NA:10 · ERROR:2 · FAIL:1 · FAIL 요소: LT_DAY / L/T(Day — 실측[T-a1 (대조표 1행)
- G1|ROW:COMMON:UC-05 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38 (대조표 1행)
- G4|ROW:COMMON:UC-06 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Item Id / I (대조표 1행)
- G1|ROW:COMMON:UC-06 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38259ec9 S (대조표 1행)
- A5|ROW:COMMON:UC-07 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke  (대조표 1행)
- H2|ROW:COMMON:UC-07 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mo (대조표 1행)
- G1|ROW:COMMON:UC-07 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38 (대조표 1행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.BtnChangeRe_Click — 진입점 집계 13검사 — ERROR:12 · FAIL:1 (대조표 2행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.BtnNew_Click — 진입점 집계 46검사 — ERROR:26 · NOPATH:9 · FAIL:7 · PASS:4 (대조표 7행)
- D1|COL:DIVISION_ID — 원장 V-1c4187ef COLUMN / 원장 V-00e520c0 COLUMN / 실측[T-d71b66e9]: 기존행 r0 DIVISION_ID 편집=false — AS-IS 기대 미식별(edit_expect 'AMBIG') | 신규행 r0 DIVISION_ID 편집=false — AS (대조표 10행)
- D1|COL:SHIPMENT_STATUS — 원장 V-416bcf91 COLUMN / 원장 V-fdc2334f COLUMN / 실측[T-5cff5e2b]: 기존행 r0 SHIPMENT_STATUS 편집=false — AS-IS 기대 미식별(edit_expect 'AMBIG') | 신규행 r0 SHIPMENT_STATUS 편집=fa (대조표 6행)
- D1|COL:NICK_NAME — 원장 V-403efb05 COLUMN / 원장 V-9c0b6388 COLUMN / 원장 V-b3f93c40 COLUMN / 원장 V-788c2db1 COLUMN / 실측[T-528f5fce]: 기존행 r0 NICK_NAME 편집=false — AS-IS 기대 미식별(edit_expect (대조표 3행)
- D1|COL:PROJECT_NAME — 원장 V-e5aeb32c COLUMN / 원장 V-b5d3a9ee COLUMN / 원장 V-ea095339 COLUMN / 원장 V-185f3a85 COLUMN / 실측[T-3f1d848c]: 기존행 r0 PROJECT_NAME 편집=false — AS-IS 기대 미식별(edit_exp (대조표 3행)
- D1|COL:REQUESTOR — 원장 V-a0894ec7 COLUMN / 원장 V-9ea7e1a0 COLUMN / 실측[T-cbeb0b33]: 기존행 r0 REQUESTOR 편집=false — AS-IS 기대 미식별(edit_expect 'AMBIG') | 신규행 r0 REQUESTOR 편집=false — AS-IS  (대조표 4행)
- D1|COL:TO_SITE_SOLDTO_CODE — 원장 V-1696486e COLUMN / 원장 V-67fc9977 COLUMN / 실측[T-f5eeba53]: 기존행 r0 TO_SITE_SOLDTO_CODE 편집=false — AS-IS 기대 미식별(edit_expect 'AMBIG') | 신규행 r0 TO_SITE_SOLDTO_CO (대조표 5행)
- D1|COL:REQUEST_DATE — 원장 V-d26e6d6e COLUMN / 원장 V-e1d9252c COLUMN / 실측[T-85467553]: 기존행 r0 REQUEST_DATE 편집=false — AS-IS 기대 미식별(edit_expect 'AMBIG') | 신규행 r0 REQUEST_DATE 편집=false —  (대조표 4행)
- H2|ENTRY:SSP0200_ShipmentChangeRequest.CreateSpread — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.CreateSpread 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mode — 원장 V-5c9d1bd7 CO (대조표 8행)
- D5|ENTRY:SSP0200_ShipmentChangeRequest.CreateSpread — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.CreateSpread 의 D5 25요소: PASS:12 · NA:10 · ERROR:2 · FAIL:1 · FAIL 요소: LT_DAY / L/T(Day — 실측[T-a14fa2d0]: LT_DAY: AS-I (대조표 8행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.DeleteDataDrafting — 진입점 집계 12검사 — PASS:6 · ERROR:4 · NA:1 · FAIL:1 (대조표 46행)
- D1|COL:FROM_SITE_DESCRIPTION — 원장 V-c164dd22 COLUMN / 원장 V-66d3dadf COLUMN / 원장 V-3cfb5bb1 COLUMN / 원장 V-eb060858 COLUMN / 실측[T-f038bffd]: 기존행 r0 FROM_SITE_DESCRIPTION 편집=false — AS-IS 기대 미식별 (대조표 2행)
- D1|ENTRY:SSP0200_ShipmentChangeRequest.EditButton — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.EditButton 의 D1 12요소: FAIL:8 · ERROR:3 · NA:1 · FAIL 요소: DIVISION_ID / Div — 원장 V-1c4187ef COLUMN / 원장 V-00e520c0 COL (대조표 9행)
- D1|COL:TO_SITE_DESCRIPTION — 원장 V-32342f7f COLUMN / 원장 V-9538d71f COLUMN / 원장 V-7296b0a3 COLUMN / 원장 V-c9f1f773 COLUMN / 실측[T-5a0d0358]: 기존행 r0 TO_SITE_DESCRIPTION 편집=false — AS-IS 기대 미식별(e (대조표 1행)
- D1|COL:END_CUSTOMER — 원장 V-edeb1a39 COLUMN / 원장 V-b6c480c3 COLUMN / 실측[T-50556479]: 기존행 r0 END_CUSTOMER 편집=false — AS-IS 기대 미식별(edit_expect 'AMBIG') | 신규행 r0 END_CUSTOMER 편집=true (AS (대조표 3행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.FindButton — 진입점 집계 6검사 — PASS:4 · REVIEW:1 · FAIL:1 (대조표 1행)
- A6|SP:P_SSP0200_GET_SHIPMENT_REQUEST_DRAFTING — 원장 V-0e0257e2 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['NEW_SHIPMENT_DATE'] ↔ TO-BE [' / 실측[T-e68e0bbb]: PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUEST_DRAFTING: 첫 정렬 키 NE (대조표 64행)
- G1|COND:cboStatus — 원장 V-38259ec9 SEARCH / E2E smoke cond combo (대조표 4행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.FindData_Main — 진입점 집계 16검사 — PASS:11 · NA:2 · ERROR:2 · FAIL:1 (대조표 10행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.FindData_Main_Nonasync — 진입점 집계 15검사 — PASS:7 · ERROR:3 · NA:3 · REVIEW:1 · FAIL:1 (대조표 10행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.FindData_Sub_Draft — 진입점 집계 10검사 — PASS:4 · ERROR:2 · NA:2 · REVIEW:1 · FAIL:1 (대조표 6행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.GetErpIFCheck — 진입점 집계 12검사 — ERROR:6 · NOPATH:2 · PASS:2 · FAIL:1 · NA:1 (대조표 2행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.InitSpread — 진입점 집계 105검사 — PASS:50 · NA:33 · ERROR:12 · FAIL:7 · NOT_RUN:2 · REVIEW:1 (대조표 22행)
- D5|COL:LT_DAY — 실측[T-a14fa2d0]: LT_DAY: AS-IS TEXT(cell_rules) ↔ TO-BE dataType=2 dataMap=N — AS-IS TEXT 에디터가 아님 (대조표 4행)
- A5|COL:NEW_ETD — E2E smoke columns / 실측[T-d1d6151b]: NEW_ETD: AS-IS(Div 40) '숨김' ↔ TO-BE 표시=Y — 표시 여부 불일치 (TO-BE 메타 VISIBLE=N) (대조표 2행)
- A5|COL:NEW_ETA — E2E smoke columns / 실측[T-73f3aab1]: NEW_ETA: AS-IS(Div 40) '숨김' ↔ TO-BE 표시=Y — 표시 여부 불일치 (TO-BE 메타 VISIBLE=N) (대조표 2행)
- A5|COL:NEW_TRANSPORT_MODE — E2E smoke columns / 실측[T-dbfd9888]: NEW_TRANSPORT_MODE: AS-IS(Div 40) '숨김' ↔ TO-BE 표시=Y — 표시 여부 불일치 (TO-BE 메타 VISIBLE=N) (대조표 2행)
- A5|COL:NEW_SHIPMENT_DATE — E2E smoke columns / 실측[T-3898decd]: NEW_SHIPMENT_DATE: AS-IS(Div 40) '숨김' ↔ TO-BE 표시=Y — 표시 여부 불일치 (TO-BE 메타 VISIBLE=N) (대조표 2행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.InsertRow — 진입점 집계 40검사 — ERROR:20 · NOPATH:10 · FAIL:7 · PASS:3 (대조표 59행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.InsertRowMultiple — 진입점 집계 39검사 — ERROR:19 · NOPATH:10 · FAIL:7 · PASS:3 (대조표 73행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.NewNonSoNo — 진입점 집계 6검사 — PASS:3 · NA:1 · FAIL:1 · ERROR:1 (대조표 139행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.NonSoNo — 진입점 집계 10검사 — NA:5 · PASS:2 · ERROR:2 · FAIL:1 (대조표 156행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.SSP_Main_Validation — 진입점 집계 29검사 — ERROR:22 · NA:5 · FAIL:2 (대조표 134행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.SaveButton — 진입점 집계 42검사 — NA:21 · PASS:11 · ERROR:9 · FAIL:1 (대조표 12행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.SaveDataDrafting — 진입점 집계 24검사 — NA:12 · PASS:6 · ERROR:5 · FAIL:1 (대조표 5행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.SoNo — 진입점 집계 10검사 — NA:5 · PASS:2 · ERROR:2 · FAIL:1 (대조표 179행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.SpdMain_CellClick — 진입점 집계 28검사 — ERROR:17 · NOPATH:7 · FAIL:2 · PASS:2 (대조표 91행)
- A5|COL:CHANGE_REQ_NO — E2E smoke columns / 실측[T-2991ac67]: CHANGE_REQ_NO: AS-IS(Div 40) '숨김' ↔ TO-BE 표시=Y — 표시 여부 불일치 (TO-BE 메타 VISIBLE=N) (대조표 2행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.SpdMain_CellDoubleClick — 진입점 집계 59검사 — ERROR:37 · NA:12 · NOPATH:4 · PASS:3 · FAIL:2 · NOT_RUN:1 (대조표 6행)
- M3|LEDGER:V-1075a1e6 — 원장 V-1075a1e6 (대조표 1행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.SpdMain_ComboSelChange — 진입점 집계 174검사 — ERROR:149 · NOPATH:10 · NA:6 · PASS:5 · FAIL:4 (대조표 45행)
- D1|COL:PROJECT_CODE — 원장 V-9139fd4a COLUMN / 원장 V-e4fbca0b COLUMN / 실측[T-2d24645e]: 기존행 r0 PROJECT_CODE 편집=false — AS-IS 기대 미식별(edit_expect 'AMBIG') | 신규행 r0 PROJECT_CODE 편집=false (A (대조표 2행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.SpdMain_EditChange — 진입점 집계 42검사 — ERROR:39 · PASS:2 · FAIL:1 (대조표 66행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.checkRequired — 진입점 집계 10검사 — ERROR:9 · FAIL:1 (대조표 20행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.chkERPIFBlockYn — 진입점 집계 3검사 — NA:2 · FAIL:1 (대조표 17행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequest.shtMain_Change — 진입점 집계 7검사 — ERROR:5 · NA:1 · FAIL:1 (대조표 126행)
- X-ROW|ENTRY:SSP0200_ShipmentChangeRequestInsertPopup.SaveData — 진입점 집계 7검사 — ERROR:5 · FAIL:1 · NA:1 (대조표 3행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- G4|COND:cboChangeType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:dtDate — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke

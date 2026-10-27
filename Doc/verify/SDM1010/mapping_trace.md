# 대조표 ↔ 검증 추적표 v2 — SDM1010 (AS-IS SDM1010) · 2026-10-26T12:55:46

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 115행 (nscm-fe\features\sdm\src\pages\project-reg\__asis-mapping__.md) · AS-IS 액션 0행(진입점 + 전 문장) = **115행** → 검사 인스턴스 **464개**
- 행 판정: 미검증 52 · FAIL 49 · 검증완료 7 · 해당없음 7
- 인스턴스 결과: NA 256 · PASS 76 · REVIEW 75 · FAIL 32 · NOT_RUN 24 · NOPATH 1

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 14 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 15 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 13 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 40 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 38 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 69 | 31 | 0 | 8 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 18 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | **미구현** | 0 | 0 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 18 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E2 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 날짜 형식·유효성 |
| E3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 11 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 9 | 0 | 0 | 16 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1회 저장(변경 감지) |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 28 | 0 | 0 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 28 | 0 | 0 | 0 | 0 | 팝업 표준·열림 |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 28 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 7 | 1 | 0 | 0 | 0 | 50 | 2 | 0 | 0 | 0 |
| 동적 생성·조회 | 69 | 31 | 0 | 66 | 0 | 48 | 0 | 0 | 0 | 0 |
| 콤보 후보 | 0 | 0 | 0 | 0 | 0 | 19 | 0 | 0 | 0 | 0 |
| Cascade | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 |
| 편집·검증 | 0 | 0 | 0 | 9 | 0 | 48 | 17 | 0 | 0 | 0 |
| CRUD | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 1 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 0 | 0 | 84 | 0 | 0 | 0 | 0 |
| 공통 기능 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 |
| 권한 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| DB 실행·접근 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 |

## FAIL 인스턴스

- X-LOC|ROW:E17 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:E18 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:E19 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:E20 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:E21 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:E22 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:E23 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- H10|SCREEN — 표준 메시지 대신 브라우저 alert/confirm 직접 호출: project-reg.constants.ts, ProjectReg.tsx (대조표 24행)
- X-LOC|ROW:E24 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CF-04 — 구현 위치 실존 안 함: ProjectRegForm.tsx:128-145 > 143줄 (대조표 1행)
- X-LOC|ROW:CF-05 — 구현 위치 실존 안 함: ProjectRegForm.tsx:148-154 > 143줄 (대조표 1행)
- X-LOC|ROW:CF-13 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CF-14 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CF-15 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:P-18 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:P-19 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:P-20 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:P-21 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:P-22 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E09:SEARCH — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E17:SEARCH — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E18:SEARCH — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E19:INSERT — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E19:SEARCH — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E20:INSERT — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E20:SAVE — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E21:SAVE — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E23:SAVE — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E23:SEARCH — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E24:SAVE — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:MODAL:ProjectAuthRegModal — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:COMMON:UC-04 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 (대조표 1행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- SC1|SCREEN — 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke
- J2|SCREEN — 검사기 있음(auth·authcrud spec) — 실행 필요: auth
- D6|SCREEN — 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace
- F1|SCREEN — 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud
- F5|SCREEN — 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace
- I1|SCREEN — 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta
- E4|MSG:MSG00097 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00108 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00715 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00113 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00043 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00001 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00706 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00707 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00708 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00709 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00710 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00713 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00714 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00716 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00717 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- K4|SCREEN — 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace
- G3|SCREEN — 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke
- E4|MSG:MSG00703 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace

# 대조표 ↔ 검증 추적표 v2 — SYS0014 (AS-IS GSCM_GROUPUSERINFO) · 2026-10-26T13:00:38

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 7행 (nscm-fe\features\admin\src\pages\group-user\__asis-mapping__.md) · AS-IS 액션 569행(진입점 + 전 문장) = **576행** → 검사 인스턴스 **123개**
- 행 판정: 미검증 563 · 검증완료 13
- 인스턴스 결과: REVIEW 65 · NOT_RUN 23 · NA 19 · PASS 13 · NOPATH 3

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 12 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 9 | 0 | 0 | 3 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| X-LOC | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 18 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1회 저장(변경 감지) |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 팝업 표준·열림 |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 3 | 0 | 0 | 1 | 0 | 0 | 0 | 팝업 선택값 반영 |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 13 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 0 | 0 | 0 | 11 | 0 | 0 | 4 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 0 | 0 | 0 | 6 | 0 | 0 | 5 | 0 | 0 | 0 |
| 동적 생성·조회 | 0 | 0 | 0 | 43 | 0 | 9 | 5 | 1 | 0 | 0 |
| 콤보 후보 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| Cascade | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 편집·검증 | 0 | 0 | 0 | 2 | 0 | 4 | 5 | 0 | 0 | 0 |
| CRUD | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 3 | 0 | 6 | 1 | 0 | 0 | 0 |
| 공통 기능 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| DB 실행·접근 | 13 | 0 | 0 | 11 | 0 | 0 | 4 | 0 | 0 | 0 |

## FAIL 인스턴스


## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- A6|SP:P_SYS0014_GET_GROUP_LIST_M — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_SYS0014_GET_GROUP_LIST_M — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F1|SCREEN — 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud
- F5|SCREEN — 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace
- J2|SCREEN — 검사기 있음(auth·authcrud spec) — 실행 필요: auth
- A6|SP:P_SYS0014_GET_USER_BY_GROUP_M — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_SYS0014_GET_USER_BY_GROUP_M — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:P_SYS0014_GET_AUTH_LIST_M — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_SYS0014_GET_AUTH_LIST_M — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- D3|COL:D — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- H2|COL:D — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- F4|SP:P_SYS0014_SAVE_GROUP_USER_M — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- D6|SCREEN — 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace
- A10|SCREEN — 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace
- X-REOPEN|SCREEN — 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace
- A5|COL:C — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- H2|COL:C — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H5|COL:C — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- D5|COL:C — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- E4|MSG:MSG00093 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- I1|SCREEN — 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta
- E4|MSG:MSG00004 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- M4|COL:G — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace

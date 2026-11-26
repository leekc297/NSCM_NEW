# 대조표 ↔ 검증 추적표 v2 — SSP0014 (AS-IS SSP0014) · 2026-11-25T03:01:48

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 93행 (nscm-fe\features\shipping\src\pages\shipment-model-pic\__asis-mapping__.md) · AS-IS 액션 377행(진입점 + 전 문장) = **470행** → 검사 인스턴스 **511개**
- 행 판정: 미검증 405 · 검증완료 49 · 해당없음 15 · FAIL 1
- 인스턴스 결과: NOT_RUN 222 · PASS 134 · ERROR 91 · NA 39 · REVIEW 21 · NOPATH 3 · FAIL 1

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 20 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 6 | 0 | 0 | 0 | 0 | 4 | 0 | 1 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 9 | 0 | 9 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 8 | 0 | 10 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 15 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 21 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 1 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 5 | 0 | 0 | 0 | 19 | 0 | 1 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 4 | 0 | 6 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 74 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 15 | 13 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 2 | 0 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 7 | 0 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B6 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | ALL 옵션·다중선택 사양 |
| C1 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 3 | 0 | 9 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 2 | 0 | 13 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 2 | 6 | 12 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 9 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 11 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E3 | 편집·검증 | 있음 | 1 | 0 | 0 | 0 | 6 | 0 | 2 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 3 | 0 | 18 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 6 | 1 | 28 | 0 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 6 | 0 | 28 | 0 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 6 | 0 | 9 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J1 | 권한 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 5 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 3 | 1 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 42 | 1 | 0 | 0 | 17 | 7 | 22 | 1 | 0 | 0 |
| 동적 생성·조회 | 81 | 0 | 0 | 21 | 38 | 18 | 9 | 1 | 0 | 0 |
| 콤보 후보 | 0 | 0 | 0 | 0 | 0 | 4 | 27 | 0 | 0 | 0 |
| Cascade | 0 | 0 | 0 | 0 | 3 | 2 | 14 | 0 | 0 | 0 |
| 편집·검증 | 1 | 0 | 0 | 0 | 15 | 6 | 69 | 0 | 0 | 0 |
| CRUD | 1 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 0 | 18 | 1 | 74 | 0 | 0 | 0 |
| 공통 기능 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| DB 실행·접근 | 5 | 0 | 0 | 0 | 0 | 1 | 3 | 1 | 0 | 0 |

## FAIL 인스턴스

- X-REASON|ROW:D00-3-009 — [대조표 근거 없음] 요소 '§3 LockColumn / 348 ((0,max) 조회=전체 lock 뷰)' 제외 사유 '조회 직후 전체 lock(뷰 모드) 미이관(Edit 토글 제거). 키/이름/감사 13열은 여전히 컬럼메타 lock.' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 (대조표 1행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- SC1|SCREEN — 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:cboDivision — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- B1|COND:cboDivision — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B2|COND:cboDivision — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B4|COND:cboDivision — 검사기 있음(combo_oracle.py(W1)) — 실행 필요: 원장 행 실행(@verify)
- B6|COND:cboDivision — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:cboOperationGroup — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- B1|COND:cboOperationGroup — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B2|COND:cboOperationGroup — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B4|COND:cboOperationGroup — 검사기 있음(combo_oracle.py(W1)) — 실행 필요: 원장 행 실행(@verify)
- B6|COND:cboOperationGroup — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:clbFromSite — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- B1|COND:clbFromSite — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B2|COND:clbFromSite — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B4|COND:clbFromSite — 검사기 있음(combo_oracle.py(W1)) — 실행 필요: 원장 행 실행(@verify)
- B6|COND:clbFromSite — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:cboValidYN — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- B1|COND:cboValidYN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B2|COND:cboValidYN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B4|COND:cboValidYN — 검사기 있음(combo_oracle.py(W1)) — 실행 필요: 원장 행 실행(@verify)
- B6|COND:cboValidYN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- G1|COND:txtItemId — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:txtItemId — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:txtUser — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- C1|COND:cboDivision — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: 원장 행 실행(@verify)
- C4|COND:cboDivision — 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace
- H6|BTN:btnItemId — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|BTN:btnItemId — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|BTN:btnItemId — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D1|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:OPERATION_GROUP — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:FROM_SITE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:ITEM_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:NICK_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:DIVISION_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|COL:OPERATION_GROUP — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|COL:FROM_SITE — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|COL:ITEM_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|COL:NICK_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:USER_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:USER_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:PART_LEADER_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:PART_LEADER_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:TEAM_LEADER_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:TEAM_LEADER_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:CREATED_BY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:CREATION_DATE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:LAST_UPDATED_BY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:LAST_UPDATE_DATE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:CREATED_BY — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:CREATION_DATE — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|COL:LAST_UPDATED_BY — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|COL:LAST_UPDATE_DATE — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D4|COL:OPERATION_GROUP — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- H6|COL:USER_ID — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|COL:USER_ID — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|COL:USER_ID — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D4|COL:USER_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- H6|COL:PART_LEADER — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|COL:PART_LEADER — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|COL:PART_LEADER — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D4|COL:PART_LEADER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- H6|COL:TEAM_LEADER — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|COL:TEAM_LEADER — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|COL:TEAM_LEADER — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D4|COL:TEAM_LEADER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- H6|COL:MAIL_USER1 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|COL:MAIL_USER1 — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|COL:MAIL_USER1 — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D4|COL:MAIL_USER1 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- H6|COL:MAIL_USER2 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|COL:MAIL_USER2 — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|COL:MAIL_USER2 — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D4|COL:MAIL_USER2 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- H6|COL:MAIL_USER3 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|COL:MAIL_USER3 — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|COL:MAIL_USER3 — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D4|COL:MAIL_USER3 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- H6|COL:MAIL_USER4 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|COL:MAIL_USER4 — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|COL:MAIL_USER4 — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D4|COL:MAIL_USER4 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- H6|COL:MAIL_USER5 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|COL:MAIL_USER5 — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|COL:MAIL_USER5 — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D4|COL:MAIL_USER5 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- F2|SCREEN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- D6|SCREEN — 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: 원장 행 실행(@verify)
- F5|SCREEN — 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00703 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00704 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- I1|SCREEN — 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00672 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- B1|COL:OPERATION_GROUP — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B1|COL:FROM_SITE — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B1|COL:VALID_YN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B2|COL:OPERATION_GROUP — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B2|COL:FROM_SITE — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B2|COL:VALID_YN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B4|COL:OPERATION_GROUP — 검사기 있음(combo_oracle.py(W1)) — 실행 필요: 원장 행 실행(@verify)
- B4|COL:FROM_SITE — 검사기 있음(combo_oracle.py(W1)) — 실행 필요: 원장 행 실행(@verify)
- B4|COL:VALID_YN — 검사기 있음(combo_oracle.py(W1)) — 실행 필요: 원장 행 실행(@verify)
- D5|COL:OPERATION_GROUP — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: 원장 행 실행(@verify)
- D5|COL:FROM_SITE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: 원장 행 실행(@verify)
- D5|COL:VALID_YN — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: 원장 행 실행(@verify)
- E5|COL:OPERATION_GROUP — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- E5|COL:FROM_SITE — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- E5|COL:VALID_YN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H4|SCREEN — 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00004 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00284 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00003 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00251 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG01261 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00097 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COL:USER_ID — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00667 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- H5|COL:DIVISION_ID — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H2|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- F6|SCREEN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- B3|COL:OPERATION_GROUP — 검사기 있음(combo_oracle order_check — AS-IS ORDER BY 키(사내 값 재검사)·CODE 정렬·고정 목록 순서 대조(변이 B3_MUTATE)) — 실행 필요: 원장 행 실행(@verify
- B3|COND:cboValidYN — 검사기 있음(combo_oracle order_check — AS-IS ORDER BY 키(사내 값 재검사)·CODE 정렬·고정 목록 순서 대조(변이 B3_MUTATE)) — 실행 필요: 원장 행 실행(@verify
- E4|MSG:MSG00429 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- A10|SCREEN — 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: 원장 행 실행(@verify)
- X-REOPEN|SCREEN — 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace
- F4|SP:SSP0014_GET_SHIPMENT_MODEL_PIC — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- E3|LEDGER:V-de901fe9 — 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필요: 원장 행 실행(@verify)
- D1|LEDGER:V-4df3afb1 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: 원장 행 실행(@verify)
- H5|COL:OPERATION_GROUP — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- C3|COL:OPERATION_GROUP — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- F4|SP:P_SSP0014_GET_USER_ID_CHECK — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- E4|LEDGER:V-4f7d4689 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- J1|LEDGER:V-b53141f3 — 검사기 있음(_trace.spec(@trace) W4b Division 후보 실측 ↔ 계정 권한 Division(user_group) — 기대 미확정 시 판정필요) — 실행 필요: 원장 행 실행(@verify)
- C1|COND:cboOperationGroup — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:cboValidYN — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- H2|COL:USER_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:PART_LEADER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:TEAM_LEADER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:MAIL_USER1 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:MAIL_USER2 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:MAIL_USER3 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:MAIL_USER4 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:MAIL_USER5 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- H5|COL:USER_ID — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:PART_LEADER — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:TEAM_LEADER — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:MAIL_USER1 — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:MAIL_USER2 — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:MAIL_USER3 — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:MAIL_USER4 — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:MAIL_USER5 — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- D5|COL:USER_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:PART_LEADER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:TEAM_LEADER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:MAIL_USER1 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:MAIL_USER2 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:MAIL_USER3 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:MAIL_USER4 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:MAIL_USER5 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- C3|COL:USER_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:PART_LEADER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:TEAM_LEADER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:MAIL_USER1 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:MAIL_USER2 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:MAIL_USER3 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:MAIL_USER4 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:MAIL_USER5 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- F4|SP:SSP0014_SAVE_SHIPMENT_MODEL_PIC — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- E3|LEDGER:V-12443416 — 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-339a10c5 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|LEDGER:V-28e0310f — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|COL:OPERATION_GROUP — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COND:cboDivision — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COND:clbFromSite — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- C1|COND:clbFromSite — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- G5|LEDGER:V-84d25ca8 — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-ceb0b8e0 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- M3|LEDGER:V-eeb6ba28 — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- G5|LEDGER:V-11a4fcdf — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-5b76aa66 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|LEDGER:V-dfb225ee — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-b877a560 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- M3|LEDGER:V-10abf93d — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- G5|LEDGER:V-51cca87a — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-853fe327 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|LEDGER:V-b70eeccb — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-d914f74d — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- M3|LEDGER:V-fd32cb60 — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- G5|LEDGER:V-969965a4 — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-bb93253d — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|LEDGER:V-6ad1182d — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-12db2bb2 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- M3|LEDGER:V-dc324506 — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- G5|LEDGER:V-c4ea73fb — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-4aa26436 — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|LEDGER:V-9bbebfe3 — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-076a035a — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- M3|LEDGER:V-44eec31e — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- G5|LEDGER:V-56fc463e — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- H6|LEDGER:V-44f0058d — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)

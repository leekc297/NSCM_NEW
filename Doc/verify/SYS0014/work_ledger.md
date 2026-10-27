# 작업 원장 — SYS0014 · 2026-10-26 13:00

> 검사 인스턴스 123건 중 PASS·NA 32건 외 **91건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 3 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 23 | 실행 → PASS |
| W7 | 기대값 확정 | 65 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 65 · E2E 23 · 하네스 3
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 18 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| F4 | DB |  |  |  |  |  | 4 | 11 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  |  | 3 | 9 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| A1 | GEN |  |  |  |  |  |  | 12 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| H2 | DESIGN |  |  |  |  |  | 2 | 2 |  |  | 배경·글자색 규칙 |
| M4 | POPUP |  |  |  |  |  | 1 | 3 |  |  | 팝업 선택값 반영 |
| X-LOC | GEN |  |  |  |  |  |  | 4 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A5 | DESIGN |  |  |  |  |  | 1 | 2 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 1 | 2 |  |  | 라벨 명칭 |
| D3 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 행 값 기반 조건부 잠금 |
| D5 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 셀 에디터 유형 |
| E4 | EDIT |  |  |  |  |  | 2 |  |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W5 검사기 연결 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0014-0001 | F2 | SYS0014 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SYS0014 화면 | 판단불가(대상 단위 SCREEN) | 163 (GroupInfo 저장(통합) ACT:GroupUserInfo.SaveB) |
| WK-SYS0014-0002 | F6 | SYS0014 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SYS0014 화면 | 판단불가(대상 단위 SCREEN) | 163 (GroupInfo 저장(통합) ACT:GroupUserInfo.SaveB) |
| WK-SYS0014-0003 | G03-WIRE | SYS0014 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SYS0014 화면 | 판단불가(대상 단위 SCREEN) | 6 (ACT:GroupUserInfo..ctor ACT:GroupUserInf) |

## W6 검증 실행 (23)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0014-0004 | J2 | SYS0014 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SYS0014 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 4 (GroupInfo UserInfo Division 저장(통합)) |
| WK-SYS0014-0005 | F1 | SYS0014 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SYS0014 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 176 (GroupInfo UserInfo Division 저장(통합) ACT:G) |
| WK-SYS0014-0006 | F5 | SYS0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SYS0014 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 14 (GroupInfo UserInfo Division ACT:GroupUse) |
| WK-SYS0014-0007 | F4 | PKG_SYS0014.P_SYS0014_GET_AUTH_LIST_M | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SYS0014.P_SYS0014_GET_AUTH_LIST_M · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 0 () |
| WK-SYS0014-0008 | F4 | PKG_SYS0014.P_SYS0014_GET_GROUP_LIST_M | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SYS0014.P_SYS0014_GET_GROUP_LIST_M · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 0 () |
| WK-SYS0014-0009 | F4 | PKG_SYS0014.P_SYS0014_GET_USER_BY_GROUP_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SYS0014.P_SYS0014_GET_USER_BY_GROUP_M · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 0 () |
| WK-SYS0014-0010 | F4 | PKG_SYS0014.P_SYS0014_SAVE_GROUP_USER_M | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SYS0014.P_SYS0014_SAVE_GROUP_USER_M · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 1 (저장(통합)) |
| WK-SYS0014-0011 | A5 | C | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — C · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:GroupUserInfo.InitSpread:183:22) |
| WK-SYS0014-0012 | H2 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:GroupUserInfo.InitSpread:183:22) |
| WK-SYS0014-0013 | H2 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-SYS0014-0014 | H5 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — C · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:GroupUserInfo.InitSpread:183:22) |
| WK-SYS0014-0015 | I1 | SYS0014 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SYS0014 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 11 (ACT:GroupUserInfo.InsertRow:780:5 ACT:Gr) |
| WK-SYS0014-0016 | D3 | D | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — D · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 0 () |
| WK-SYS0014-0017 | D5 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:GroupUserInfo.InitSpread:183:22) |
| WK-SYS0014-0018 | D6 | SYS0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SYS0014 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 5 (GroupInfo UserInfo Division ACT:GroupUse) |
| WK-SYS0014-0019 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:GroupUserInfo.SaveData:551:35 ACT:Gr) |
| WK-SYS0014-0020 | E4 | MSG00093 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00093 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (ACT:GroupUserInfo.InsertRow:780:5 ACT:Gr) |
| WK-SYS0014-0021 | A10 | SYS0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SYS0014 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 44 (ACT:GroupUserInfo.DefineProperty ACT:Gro) |
| WK-SYS0014-0022 | A6 | PKG_SYS0014.P_SYS0014_GET_AUTH_LIST_M | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SYS0014.P_SYS0014_GET_AUTH_LIST_M · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _ |  | 0 () |
| WK-SYS0014-0023 | A6 | PKG_SYS0014.P_SYS0014_GET_GROUP_LIST_M | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SYS0014.P_SYS0014_GET_GROUP_LIST_M · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 0 () |
| WK-SYS0014-0024 | A6 | PKG_SYS0014.P_SYS0014_GET_USER_BY_GROUP_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SYS0014.P_SYS0014_GET_USER_BY_GROUP_M · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 0 () |
| WK-SYS0014-0025 | X-REOPEN | SYS0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SYS0014 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 13 (ACT:GroupUserInfo.Dispose ACT:GroupUserI) |
| WK-SYS0014-0026 | M4 | G | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — G · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (ACT:GroupUserInfo.SpdDivision_CellDouble) |

## W7 기대값 확정 (65)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0014-0027 | F4 | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — Division: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Division) |
| WK-SYS0014-0028 | F4 | GroupInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — GroupInfo: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (GroupInfo) |
| WK-SYS0014-0029 | F4 | GroupUserInfo.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — GroupUserInfo.FindButton: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:GroupUserInfo.FindButton ACT:GroupUs) |
| WK-SYS0014-0030 | F4 | GroupUserInfo.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — GroupUserInfo.FindData: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 13 (ACT:GroupUserInfo.FindData ACT:GroupUser) |
| WK-SYS0014-0031 | F4 | GroupUserInfo.FindData_Customer | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — GroupUserInfo.FindData_Customer: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 16 (ACT:GroupUserInfo.FindData_Customer ACT:) |
| WK-SYS0014-0032 | F4 | GroupUserInfo.FindData_Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — GroupUserInfo.FindData_Division: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 25 (ACT:GroupUserInfo.FindData_Division ACT:) |
| WK-SYS0014-0033 | F4 | GroupUserInfo.FindData_Plant | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — GroupUserInfo.FindData_Plant: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 16 (ACT:GroupUserInfo.FindData_Plant ACT:Gro) |
| WK-SYS0014-0034 | F4 | GroupUserInfo.FindData_User | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — GroupUserInfo.FindData_User: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 9 (ACT:GroupUserInfo.FindData_User ACT:Grou) |
| WK-SYS0014-0035 | F4 | GroupUserInfo.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — GroupUserInfo.SaveButton: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:GroupUserInfo.SaveButton) |
| WK-SYS0014-0036 | F4 | GroupUserInfo.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — GroupUserInfo.SaveData: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:GroupUserInfo.SaveData) |
| WK-SYS0014-0037 | F4 | UserInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — UserInfo: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (UserInfo) |
| WK-SYS0014-0038 | A5 | GroupUserInfo.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — GroupUserInfo.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:GroupUserInfo.CreateSpread:125:1 ACT) |
| WK-SYS0014-0039 | A5 | 저장(통합) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 저장(통합): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (저장(통합)) |
| WK-SYS0014-0040 | H2 | GroupUserInfo.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — GroupUserInfo.CreateSpread: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 10 (ACT:GroupUserInfo.CreateSpread:125:1 ACT) |
| WK-SYS0014-0041 | H2 | 저장(통합) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 저장(통합): 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (저장(통합)) |
| WK-SYS0014-0042 | H5 | GroupUserInfo.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — GroupUserInfo.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:GroupUserInfo.CreateSpread:125:1 ACT) |
| WK-SYS0014-0043 | H5 | 저장(통합) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 저장(통합): 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (저장(통합)) |
| WK-SYS0014-0044 | D3 | GroupUserInfo.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — GroupUserInfo.EditButton: 진입점 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:GroupUserInfo.EditButton:257:1 ACT:G) |
| WK-SYS0014-0045 | D5 | GroupUserInfo.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — GroupUserInfo.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:GroupUserInfo.CreateSpread:125:1 ACT) |
| WK-SYS0014-0046 | A1 | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Division: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (Division) |
| WK-SYS0014-0047 | A1 | GroupInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — GroupInfo: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (GroupInfo) |
| WK-SYS0014-0048 | A1 | GroupUserInfo.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — GroupUserInfo.FindButton: 진입점 집계 — A1 3요소: REVIEW:3 |  | 2 (ACT:GroupUserInfo.FindButton ACT:GroupUs) |
| WK-SYS0014-0049 | A1 | GroupUserInfo.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — GroupUserInfo.FindData: 진입점 집계 — A1 3요소: REVIEW:3 |  | 13 (ACT:GroupUserInfo.FindData ACT:GroupUser) |
| WK-SYS0014-0050 | A1 | GroupUserInfo.FindData_Customer | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — GroupUserInfo.FindData_Customer: 진입점 집계 — A1 3요소: REVIEW:3 |  | 16 (ACT:GroupUserInfo.FindData_Customer ACT:) |
| WK-SYS0014-0051 | A1 | GroupUserInfo.FindData_Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — GroupUserInfo.FindData_Division: 진입점 집계 — A1 3요소: REVIEW:3 |  | 25 (ACT:GroupUserInfo.FindData_Division ACT:) |
| WK-SYS0014-0052 | A1 | GroupUserInfo.FindData_Plant | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — GroupUserInfo.FindData_Plant: 진입점 집계 — A1 3요소: REVIEW:3 |  | 16 (ACT:GroupUserInfo.FindData_Plant ACT:Gro) |
| WK-SYS0014-0053 | A1 | GroupUserInfo.FindData_User | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — GroupUserInfo.FindData_User: 진입점 집계 — A1 3요소: REVIEW:3 |  | 9 (ACT:GroupUserInfo.FindData_User ACT:Grou) |
| WK-SYS0014-0054 | A1 | PKG_SYS0014.P_SYS0014_GET_AUTH_LIST_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SYS0014.P_SYS0014_GET_AUTH_LIST_M: 골든 비교 케이스 없음(PKG_SYS0014.P_SYS0014_GET_AUTH_LIST_M — 팝업·보조 SP 는 golden_cases.cs |  | 0 () |
| WK-SYS0014-0055 | A1 | PKG_SYS0014.P_SYS0014_GET_GROUP_LIST_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SYS0014.P_SYS0014_GET_GROUP_LIST_M: 골든 비교 케이스 없음(PKG_SYS0014.P_SYS0014_GET_GROUP_LIST_M — 팝업·보조 SP 는 golden_cases. |  | 0 () |
| WK-SYS0014-0056 | A1 | PKG_SYS0014.P_SYS0014_GET_USER_BY_GROUP_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SYS0014.P_SYS0014_GET_USER_BY_GROUP_M: 골든 비교 케이스 없음(PKG_SYS0014.P_SYS0014_GET_USER_BY_GROUP_M — 팝업·보조 SP 는 golden_ |  | 0 () |
| WK-SYS0014-0057 | A1 | UserInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — UserInfo: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (UserInfo) |
| WK-SYS0014-0058 | A6 | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — Division: 행 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Division) |
| WK-SYS0014-0059 | A6 | GroupInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — GroupInfo: 행 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (GroupInfo) |
| WK-SYS0014-0060 | A6 | GroupUserInfo.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — GroupUserInfo.FindButton: 진입점 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:GroupUserInfo.FindButton ACT:GroupUs) |
| WK-SYS0014-0061 | A6 | GroupUserInfo.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — GroupUserInfo.FindData: 진입점 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 13 (ACT:GroupUserInfo.FindData ACT:GroupUser) |
| WK-SYS0014-0062 | A6 | GroupUserInfo.FindData_Customer | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — GroupUserInfo.FindData_Customer: 진입점 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 16 (ACT:GroupUserInfo.FindData_Customer ACT:) |
| WK-SYS0014-0063 | A6 | GroupUserInfo.FindData_Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — GroupUserInfo.FindData_Division: 진입점 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 25 (ACT:GroupUserInfo.FindData_Division ACT:) |
| WK-SYS0014-0064 | A6 | GroupUserInfo.FindData_Plant | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — GroupUserInfo.FindData_Plant: 진입점 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 16 (ACT:GroupUserInfo.FindData_Plant ACT:Gro) |
| WK-SYS0014-0065 | A6 | GroupUserInfo.FindData_User | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — GroupUserInfo.FindData_User: 진입점 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 9 (ACT:GroupUserInfo.FindData_User ACT:Grou) |
| WK-SYS0014-0066 | A6 | UserInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — UserInfo: 행 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (UserInfo) |
| WK-SYS0014-0067 | X-LOC | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division) |
| WK-SYS0014-0068 | X-LOC | GroupInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — GroupInfo: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (GroupInfo) |
| WK-SYS0014-0069 | X-LOC | UserInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — UserInfo: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (UserInfo) |
| WK-SYS0014-0070 | X-LOC | 저장(통합) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 저장(통합): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (저장(통합)) |
| WK-SYS0014-0071 | X-ROW | GroupUserInfo.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupUserInfo.CreateSpread) |
| WK-SYS0014-0072 | X-ROW | GroupUserInfo.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupUserInfo.DefineProperty) |
| WK-SYS0014-0073 | X-ROW | GroupUserInfo.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupUserInfo.EditButton) |
| WK-SYS0014-0074 | X-ROW | GroupUserInfo.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupUserInfo.FindButton) |
| WK-SYS0014-0075 | X-ROW | GroupUserInfo.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.FindData: 진입점 집계 6검사 — NOPATH:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:GroupUserInfo.FindData ACT:GroupUser) |
| WK-SYS0014-0076 | X-ROW | GroupUserInfo.FindData_Customer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.FindData_Customer: 진입점 집계 6검사 — NOPATH:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:GroupUserInfo.FindData_Customer ACT:) |
| WK-SYS0014-0077 | X-ROW | GroupUserInfo.FindData_Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.FindData_Division: 진입점 집계 6검사 — NOPATH:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:GroupUserInfo.FindData_Division ACT:) |
| WK-SYS0014-0078 | X-ROW | GroupUserInfo.FindData_Plant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.FindData_Plant: 진입점 집계 6검사 — NOPATH:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:GroupUserInfo.FindData_Plant ACT:Gro) |
| WK-SYS0014-0079 | X-ROW | GroupUserInfo.FindData_User | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.FindData_User: 진입점 집계 6검사 — NOPATH:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:GroupUserInfo.FindData_User ACT:Grou) |
| WK-SYS0014-0080 | X-ROW | GroupUserInfo.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupUserInfo.Form_Load) |
| WK-SYS0014-0081 | X-ROW | GroupUserInfo.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.InitSpread: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 2 (ACT:GroupUserInfo.InitSpread ACT:GroupUs) |
| WK-SYS0014-0082 | X-ROW | GroupUserInfo.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupUserInfo.InsertButton) |
| WK-SYS0014-0083 | X-ROW | GroupUserInfo.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.InsertRow: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 90 (ACT:GroupUserInfo.InsertRow ACT:GroupUse) |
| WK-SYS0014-0084 | X-ROW | GroupUserInfo.JVPlantColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.JVPlantColumn: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/GRID_INIT, 연결된 요소 검사 없음 |  | 4 (ACT:GroupUserInfo.JVPlantColumn ACT:Grou) |
| WK-SYS0014-0085 | X-ROW | GroupUserInfo.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.SaveData: 진입점 집계 8검사 — NOT_RUN:4 · NOPATH:3 · REVIEW:1 |  | 13 (ACT:GroupUserInfo.SaveData:535:27 ACT:Gr) |
| WK-SYS0014-0086 | X-ROW | GroupUserInfo.SpdDivision_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.SpdDivision_CellDoubleClick: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 21 (ACT:GroupUserInfo.SpdDivision_CellDouble) |
| WK-SYS0014-0087 | X-ROW | GroupUserInfo.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupUserInfo.SpdMain_CellDoubleClic) |
| WK-SYS0014-0088 | X-ROW | GroupUserInfo.SpdUserInfo_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupUserInfo.SpdUserInfo_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupUserInfo.SpdUserInfo_CellDouble) |
| WK-SYS0014-0089 | M4 | GroupUserInfo.SpdDivision_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — GroupUserInfo.SpdDivision_CellDoubleClick: 진입점 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 55 (ACT:GroupUserInfo.SpdDivision_CellDouble) |
| WK-SYS0014-0090 | M4 | GroupUserInfo.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — GroupUserInfo.SpdMain_CellDoubleClick: 진입점 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:GroupUserInfo.SpdMain_CellDoubleClic) |
| WK-SYS0014-0091 | M4 | GroupUserInfo.SpdUserInfo_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — GroupUserInfo.SpdUserInfo_CellDoubleClick: 진입점 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:GroupUserInfo.SpdUserInfo_CellDouble) |

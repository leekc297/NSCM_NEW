# 작업 원장 — SYS0003 · 2026-10-26 13:00

> 검사 인스턴스 55건 중 PASS·NA 20건 외 **35건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 3 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 14 | 실행 → PASS |
| W7 | 기대값 확정 | 18 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 18 · E2E 14 · 하네스 3
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 14 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A5 | DESIGN |  |  |  |  |  | 1 | 1 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 1 | 1 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 1 | 1 |  |  | 라벨 명칭 |
| D5 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 셀 에디터 유형 |
| E4 | EDIT |  |  |  |  |  | 2 |  |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| G4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 표시·라벨·활성 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| G6 | GEN |  |  |  |  |  | 1 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W5 검사기 연결 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0003-0001 | F2 | SYS0003 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SYS0003 화면 | 판단불가(대상 단위 SCREEN) | 75 (ACT:MenuItemInfo.SaveButton ACT:MenuItem) |
| WK-SYS0003-0002 | F6 | SYS0003 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SYS0003 화면 | 판단불가(대상 단위 SCREEN) | 75 (ACT:MenuItemInfo.SaveButton ACT:MenuItem) |
| WK-SYS0003-0003 | G03-WIRE | SYS0003 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SYS0003 화면 | 판단불가(대상 단위 SCREEN) | 7 (ACT:MenuItemInfo..ctor ACT:MenuItemInfo.) |

## W6 검증 실행 (14)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0003-0004 | F1 | SYS0003 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SYS0003 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 84 (ACT:MenuItemInfo.DeleteButton ACT:MenuIt) |
| WK-SYS0003-0005 | F5 | SYS0003 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SYS0003 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 9 (ACT:MenuItemInfo.DeleteButton ACT:MenuIt) |
| WK-SYS0003-0006 | A5 | U | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — U · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:MenuItemInfo.InitSpread) |
| WK-SYS0003-0007 | G4 | usrPanel / Panel | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — usrPanel / Panel · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:MenuItemInfo.DefineProperty ACT:Menu) |
| WK-SYS0003-0008 | H2 | U | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — U · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:MenuItemInfo.InitSpread) |
| WK-SYS0003-0009 | H5 | U | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — U · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:MenuItemInfo.InitSpread) |
| WK-SYS0003-0010 | I1 | SYS0003 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SYS0003 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 2 (ACT:MenuItemInfo.SaveData:444:51 ACT:Men) |
| WK-SYS0003-0011 | D5 | U | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — U · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:MenuItemInfo.InitSpread) |
| WK-SYS0003-0012 | D6 | SYS0003 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SYS0003 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (ACT:MenuItemInfo.InsertButton ACT:MenuIt) |
| WK-SYS0003-0013 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:MenuItemInfo.SaveData:444:51) |
| WK-SYS0003-0014 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:MenuItemInfo.SaveData:476:70) |
| WK-SYS0003-0015 | A10 | SYS0003 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SYS0003 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 69 (ACT:MenuItemInfo.DefineProperty ACT:Menu) |
| WK-SYS0003-0016 | G6 | usrPanel / Panel | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — usrPanel / Panel · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:MenuItemInfo.DefineProperty ACT:Menu) |
| WK-SYS0003-0017 | X-REOPEN | SYS0003 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SYS0003 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 6 (ACT:MenuItemInfo.Dispose ACT:MenuItemInf) |

## W7 기대값 확정 (18)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0003-0018 | A5 | MenuItemInfo.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — MenuItemInfo.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 11 (ACT:MenuItemInfo.CreateSpread:122:1 ACT:) |
| WK-SYS0003-0019 | H2 | MenuItemInfo.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — MenuItemInfo.CreateSpread: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 11 (ACT:MenuItemInfo.CreateSpread:122:1 ACT:) |
| WK-SYS0003-0020 | H5 | MenuItemInfo.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — MenuItemInfo.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 11 (ACT:MenuItemInfo.CreateSpread:122:1 ACT:) |
| WK-SYS0003-0021 | D5 | MenuItemInfo.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — MenuItemInfo.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 11 (ACT:MenuItemInfo.CreateSpread:122:1 ACT:) |
| WK-SYS0003-0022 | X-ROW | MenuItemInfo.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:MenuItemInfo.CreateSpread) |
| WK-SYS0003-0023 | X-ROW | MenuItemInfo.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:MenuItemInfo.EditButton) |
| WK-SYS0003-0024 | X-ROW | MenuItemInfo.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:MenuItemInfo.FindButton) |
| WK-SYS0003-0025 | X-ROW | MenuItemInfo.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.FindData: 진입점 집계 6검사 — NOPATH:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:MenuItemInfo.FindData ACT:MenuItemIn) |
| WK-SYS0003-0026 | X-ROW | MenuItemInfo.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:MenuItemInfo.Form_Load) |
| WK-SYS0003-0027 | X-ROW | MenuItemInfo.IconFileDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.IconFileDialog: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/POPUP/RETURN/UI_PROP, 연결된 요소 검사 없음 |  | 8 (ACT:MenuItemInfo.IconFileDialog ACT:Menu) |
| WK-SYS0003-0028 | X-ROW | MenuItemInfo.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.InitSpread: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:MenuItemInfo.InitSpread) |
| WK-SYS0003-0029 | X-ROW | MenuItemInfo.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:MenuItemInfo.InsertButton) |
| WK-SYS0003-0030 | X-ROW | MenuItemInfo.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLOW/GRID_LOCK/GRID_SET/LOCAL/RETURN, 연 |  | 36 (ACT:MenuItemInfo.InsertRow ACT:MenuItemI) |
| WK-SYS0003-0031 | X-ROW | MenuItemInfo.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.SaveData: 진입점 집계 9검사 — NOT_RUN:5 · NOPATH:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:MenuItemInfo.SaveData:460:62 ACT:Men) |
| WK-SYS0003-0032 | X-ROW | MenuItemInfo.SpdLevel1_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.SpdLevel1_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:MenuItemInfo.SpdLevel1_CellDoubleCli) |
| WK-SYS0003-0033 | X-ROW | MenuItemInfo.SpdLevel2_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.SpdLevel2_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/EXPR/GRID_SET/POPUP/RETURN/UI_P |  | 15 (ACT:MenuItemInfo.SpdLevel2_CellClick ACT) |
| WK-SYS0003-0034 | X-ROW | MenuItemInfo.SpdLevel2_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.SpdLevel2_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:MenuItemInfo.SpdLevel2_CellDoubleCli) |
| WK-SYS0003-0035 | X-ROW | MenuItemInfo.SpdLevel3_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MenuItemInfo.SpdLevel3_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/EXPR/GRID_SET/POPUP/RETURN/UI_P |  | 15 (ACT:MenuItemInfo.SpdLevel3_CellClick ACT) |

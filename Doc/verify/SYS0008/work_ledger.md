# 작업 원장 — SYS0008 · 2026-10-26 13:00

> 검사 인스턴스 87건 중 PASS·NA 35건 외 **52건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 3 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 11 | 실행 → PASS |
| W7 | 기대값 확정 | 38 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 38 · E2E 11 · 하네스 3
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 29 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 2 | 5 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A5 | DESIGN |  |  |  |  |  | 1 | 1 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 1 | 1 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 1 | 1 |  |  | 라벨 명칭 |
| D5 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 셀 에디터 유형 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W5 검사기 연결 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0008-0001 | F2 | SYS0008 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SYS0008 화면 | 판단불가(대상 단위 SCREEN) | 50 (ACT:GroupMenuAuth.SaveButton ACT:GroupMe) |
| WK-SYS0008-0002 | F6 | SYS0008 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SYS0008 화면 | 판단불가(대상 단위 SCREEN) | 50 (ACT:GroupMenuAuth.SaveButton ACT:GroupMe) |
| WK-SYS0008-0003 | G03-WIRE | SYS0008 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SYS0008 화면 | 판단불가(대상 단위 SCREEN) | 5 (ACT:GroupMenuAuth..ctor ACT:GroupMenuAut) |

## W6 검증 실행 (11)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0008-0004 | F1 | SYS0008 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SYS0008 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 54 (ACT:GroupMenuAuth.DeleteButton ACT:Group) |
| WK-SYS0008-0005 | F5 | SYS0008 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SYS0008 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 4 (ACT:GroupMenuAuth.DeleteButton ACT:Group) |
| WK-SYS0008-0006 | A5 | U | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — U · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:GroupMenuAuth.InitSpread) |
| WK-SYS0008-0007 | H2 | U | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — U · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:GroupMenuAuth.InitSpread) |
| WK-SYS0008-0008 | H5 | U | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — U · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:GroupMenuAuth.InitSpread) |
| WK-SYS0008-0009 | I1 | SYS0008 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SYS0008 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 9 (ACT:GroupMenuAuth.OpenFileUplad:690:14 A) |
| WK-SYS0008-0010 | D5 | U | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — U · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:GroupMenuAuth.InitSpread) |
| WK-SYS0008-0011 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:GroupMenuAuth.SaveData:432:26) |
| WK-SYS0008-0012 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:GroupMenuAuth.SaveData:464:45) |
| WK-SYS0008-0013 | A10 | SYS0008 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SYS0008 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 51 (ACT:GroupMenuAuth.DefineProperty ACT:Gro) |
| WK-SYS0008-0014 | X-REOPEN | SYS0008 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SYS0008 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 8 (ACT:GroupMenuAuth.Dispose ACT:GroupMenuA) |

## W7 기대값 확정 (38)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0008-0015 | A5 | GroupMenuAuth.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — GroupMenuAuth.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:GroupMenuAuth.CreateSpread:130:1 ACT) |
| WK-SYS0008-0016 | H2 | GroupMenuAuth.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — GroupMenuAuth.CreateSpread: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:GroupMenuAuth.CreateSpread:130:1 ACT) |
| WK-SYS0008-0017 | H5 | GroupMenuAuth.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — GroupMenuAuth.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:GroupMenuAuth.CreateSpread:130:1 ACT) |
| WK-SYS0008-0018 | D5 | GroupMenuAuth.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — GroupMenuAuth.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:GroupMenuAuth.CreateSpread:130:1 ACT) |
| WK-SYS0008-0019 | E4 | GroupMenuAuth.SetAddColumnHelp | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — GroupMenuAuth.SetAddColumnHelp: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:GroupMenuAuth.SetAddColumnHelp:559:1) |
| WK-SYS0008-0020 | E4 | GroupMenuAuth.SetCheckExistsHelpFile | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — GroupMenuAuth.SetCheckExistsHelpFile: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 23 (ACT:GroupMenuAuth.SetCheckExistsHelpFile) |
| WK-SYS0008-0021 | E4 | GroupMenuAuth.SetFileExists | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — GroupMenuAuth.SetFileExists: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:GroupMenuAuth.SetFileExists:574:1 AC) |
| WK-SYS0008-0022 | E4 | GroupMenuAuth.SetFocusGroupID | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — GroupMenuAuth.SetFocusGroupID: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:GroupMenuAuth.SetFocusGroupID:340:1) |
| WK-SYS0008-0023 | E4 | GroupMenuAuth.SetHelpFileList | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — GroupMenuAuth.SetHelpFileList: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 7 (ACT:GroupMenuAuth.SetHelpFileList:808:1 ) |
| WK-SYS0008-0024 | X-ROW | GroupMenuAuth.CheckAuthManual | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.CheckAuthManual: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/FLOW/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 6 (ACT:GroupMenuAuth.CheckAuthManual ACT:Gr) |
| WK-SYS0008-0025 | X-ROW | GroupMenuAuth.CheckAuthMenuGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.CheckAuthMenuGroup: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/FLOW/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 7 (ACT:GroupMenuAuth.CheckAuthMenuGroup ACT) |
| WK-SYS0008-0026 | X-ROW | GroupMenuAuth.CheckExistsHelpFileInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.CheckExistsHelpFileInfo: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:GroupMenuAuth.CheckExistsHelpFileInf) |
| WK-SYS0008-0027 | X-ROW | GroupMenuAuth.ConvertHelpFile | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.ConvertHelpFile: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 |  | 13 (ACT:GroupMenuAuth.ConvertHelpFile ACT:Gr) |
| WK-SYS0008-0028 | X-ROW | GroupMenuAuth.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupMenuAuth.CreateSpread) |
| WK-SYS0008-0029 | X-ROW | GroupMenuAuth.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupMenuAuth.DefineProperty) |
| WK-SYS0008-0030 | X-ROW | GroupMenuAuth.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupMenuAuth.EditButton) |
| WK-SYS0008-0031 | X-ROW | GroupMenuAuth.FileUpload | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.FileUpload: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:GroupMenuAuth.FileUpload ACT:GroupMe) |
| WK-SYS0008-0032 | X-ROW | GroupMenuAuth.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupMenuAuth.FindButton) |
| WK-SYS0008-0033 | X-ROW | GroupMenuAuth.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.FindData: 진입점 집계 6검사 — NOPATH:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:GroupMenuAuth.FindData ACT:GroupMenu) |
| WK-SYS0008-0034 | X-ROW | GroupMenuAuth.FindDataList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.FindDataList: 진입점 집계 6검사 — NOPATH:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:GroupMenuAuth.FindDataList ACT:Group) |
| WK-SYS0008-0035 | X-ROW | GroupMenuAuth.FindSub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.FindSub: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:GroupMenuAuth.FindSub ACT:GroupMenuA) |
| WK-SYS0008-0036 | X-ROW | GroupMenuAuth.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupMenuAuth.Form_Load) |
| WK-SYS0008-0037 | X-ROW | GroupMenuAuth.GetMenuName | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.GetMenuName: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupMenuAuth.GetMenuName) |
| WK-SYS0008-0038 | X-ROW | GroupMenuAuth.GetUserGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.GetUserGroup: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupMenuAuth.GetUserGroup) |
| WK-SYS0008-0039 | X-ROW | GroupMenuAuth.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.InitSpread: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 7 (ACT:GroupMenuAuth.InitSpread ACT:GroupMe) |
| WK-SYS0008-0040 | X-ROW | GroupMenuAuth.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/GRID_INIT/GRID_LOCK/GRID_SET/LOCAL/POP |  | 26 (ACT:GroupMenuAuth.InsertRow ACT:GroupMen) |
| WK-SYS0008-0041 | X-ROW | GroupMenuAuth.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:GroupMenuAuth.OnShown ACT:GroupMenuA) |
| WK-SYS0008-0042 | X-ROW | GroupMenuAuth.OpenFileUplad | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.OpenFileUplad: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 51 (ACT:GroupMenuAuth.OpenFileUplad ACT:Grou) |
| WK-SYS0008-0043 | X-ROW | GroupMenuAuth.OpenHelpFile | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.OpenHelpFile: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:GroupMenuAuth.OpenHelpFile ACT:Group) |
| WK-SYS0008-0044 | X-ROW | GroupMenuAuth.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.SaveData: 진입점 집계 9검사 — NOT_RUN:5 · NOPATH:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:GroupMenuAuth.SaveData:448:37 ACT:Gr) |
| WK-SYS0008-0045 | X-ROW | GroupMenuAuth.SetAddColumnHelp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.SetAddColumnHelp: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupMenuAuth.SetAddColumnHelp) |
| WK-SYS0008-0046 | X-ROW | GroupMenuAuth.SetCheckExistsHelpFile | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.SetCheckExistsHelpFile: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:GroupMenuAuth.SetCheckExistsHelpFile) |
| WK-SYS0008-0047 | X-ROW | GroupMenuAuth.SetFileExists | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.SetFileExists: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupMenuAuth.SetFileExists) |
| WK-SYS0008-0048 | X-ROW | GroupMenuAuth.SetFocusGroupID | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.SetFocusGroupID: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupMenuAuth.SetFocusGroupID) |
| WK-SYS0008-0049 | X-ROW | GroupMenuAuth.SetHelpFileList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.SetHelpFileList: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupMenuAuth.SetHelpFileList) |
| WK-SYS0008-0050 | X-ROW | GroupMenuAuth.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:GroupMenuAuth.SpdMain_CellDoubleClic) |
| WK-SYS0008-0051 | X-ROW | GroupMenuAuth.SpdSub_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.SpdSub_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 9 (ACT:GroupMenuAuth.SpdSub_CellClick ACT:G) |
| WK-SYS0008-0052 | X-ROW | GroupMenuAuth.WriteLog | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GroupMenuAuth.WriteLog: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/LOCAL, 연결된 요소 검사 없음 |  | 4 (ACT:GroupMenuAuth.WriteLog ACT:GroupMenu) |

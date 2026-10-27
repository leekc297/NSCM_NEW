# 작업 원장 — SCP0039 · 2026-10-26 12:53

> 검사 인스턴스 170건 중 PASS·NA 10건 외 **160건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 2 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 13 | 구현 위치 실존 |
| W4 | 검사기 구현 | 1 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 9 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 48 | 실행 → PASS |
| W7 | 기대값 확정 | 83 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 4 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 77 · E2E 48 · 대조표 19 · 하네스 10 · 선행 W1 완료 후 E2E 4 · FE 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 5건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 25 | 1 |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 13 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| C3 | CASCADE |  |  |  |  |  | 6 | 4 |  |  | 연쇄 자동 채움 |
| F4 | DB |  |  |  |  |  | 3 | 6 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| E4 | EDIT |  |  |  |  |  | 5 | 3 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G1 | GEN |  |  |  |  |  | 3 | 5 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 8 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| DB-SYN | DB |  |  |  |  | 2 |  | 4 |  |  | BE 계정 시노님·권한·대상 객체 |
| A6 | GEN |  |  |  |  |  | 1 | 5 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| M4 | POPUP |  |  |  |  |  | 4 | 1 | 1 |  | 팝업 선택값 반영 |
| X-REASON | DESIGN |  |  |  |  |  |  | 6 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B3 | COMBO |  |  |  | 1 |  |  | 4 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 1 |  | 4 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G5 | POPUP |  |  |  |  | 2 |  | 1 | 1 |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 | 1 | 1 | 1 |  | 팝업 표준·열림 |
| D1 | EDIT |  |  |  |  |  | 3 | 1 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 3 | 1 |  |  | 행 값 기반 조건부 잠금 |
| G4 | DESIGN |  |  |  |  | 1 | 2 |  |  |  | 조회조건 표시·라벨·활성 |
| C1 | CASCADE |  |  |  |  |  | 2 | 1 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| A5 | DESIGN |  |  |  |  |  | 2 | 1 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 2 | 1 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 2 | 1 |  |  | 라벨 명칭 |
| X-NOTIMPL | GEN | 2 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| G6 | GEN |  |  |  |  |  | 2 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W1 기능 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0039-0001 | X-NOTIMPL | `IsPopup` 임베드 변형(Plan Control 호출) | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — `IsPopup` 임베드 변형(Plan Control 호출) 141~163 미구현 — standalone MDI 우선(확인필요, design 01 §5-L2) |  | 1 (`IsPopup` 임베드 변형(Plan Control 호출)) |
| WK-SCP0039-0002 | X-NOTIMPL | `SetCalendar`/`AddNumColumn`(동적 월컬럼) | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — `SetCalendar`/`AddNumColumn`(동적 월컬럼) 1235~1266 미구현 — 호출부 전무(dead code, design 02/03 §2) |  | 1 (`SetCalendar`/`AddNumColumn`(동적 월컬럼)) |

## W2 구현 위치 확인 (13)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0039-0003 | X-LOC | `CONSTRAINTS01` `Const:...^PlanGroup` 파싱 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`CONSTRAINTS01` `Const:...^PlanGroup` 파싱) |
| WK-SCP0039-0004 | X-LOC | `ClbDivision_SelectedIndexChanged` → `Cl | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`ClbDivision_SelectedIndexChanged` → `Cl) |
| WK-SCP0039-0005 | X-LOC | `FindButton()` → `FindDataAll()` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`FindButton()` → `FindDataAll()`) |
| WK-SCP0039-0006 | X-LOC | `FindDataAll` `Div:xx` 행 skip | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`FindDataAll` `Div:xx` 행 skip) |
| WK-SCP0039-0007 | X-LOC | `InsertBaseRow()` (lookup MASTER_VALIDAT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`InsertBaseRow()` (lookup MASTER_VALIDAT) |
| WK-SCP0039-0008 | X-LOC | `InsertButton/EditButton/DeleteButton/Sa | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`InsertButton/EditButton/DeleteButton/Sa) |
| WK-SCP0039-0009 | X-LOC | `LockColumn(0..max)` siMain/siProjectRou | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`LockColumn(0..max)` siMain/siProjectRou) |
| WK-SCP0039-0010 | X-LOC | `SpdMain_CellClick` OPEN 컬럼 → `GoPage` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SpdMain_CellClick` OPEN 컬럼 → `GoPage`) |
| WK-SCP0039-0011 | X-LOC | `SpdMain_CellClick` QUERY 컬럼 → `FindData | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SpdMain_CellClick` QUERY 컬럼 → `FindData) |
| WK-SCP0039-0012 | X-LOC | `SpdMain_CellClick` 기타 → `ChangeActiveSh | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SpdMain_CellClick` 기타 → `ChangeActiveSh) |
| WK-SCP0039-0013 | X-LOC | `cboDivision` (`BLUtils.GetDivisionWitho | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`cboDivision` (`BLUtils.GetDivisionWitho) |
| WK-SCP0039-0014 | X-LOC | `clbPlanGroup` (SCP0121 Tables[3], `DBUt | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`clbPlanGroup` (SCP0121 Tables[3], `DBUt) |
| WK-SCP0039-0015 | X-LOC | `txtItemId + btnItemId` → `DM0002_Itemby | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`txtItemId + btnItemId` → `DM0002_Itemby) |

## W4 검사기 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0039-0016 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 1 (`cboDivision` (`BLUtils.GetDivisionWitho) |

## W5 검사기 연결 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0039-0017 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (`cboDivision` (`BLUtils.GetDivisionWitho) |
| WK-SCP0039-0018 | F2 | SCP0039 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0039 화면 | 판단불가(대상 단위 SCREEN) | 1 (`InsertButton/EditButton/DeleteButton/Sa) |
| WK-SCP0039-0019 | DB-SYN | PKG_SCP0039 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_SCP0039 | 없음(PROC_M 대응 없음) | 1 (`SpdMain_CellClick` QUERY 컬럼 → `FindData) |
| WK-SCP0039-0020 | DB-SYN | SCM0003_GET_LOOKUP_MASTER_DETAIL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0003_GET_LOOKUP_MASTER_DETAIL | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0039_ValidationMaster.getLookupMa) |
| WK-SCP0039-0021 | G4 | btnSearch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSearch | 없음 | 2 (ACT:SCP0039_ValidationMaster.InitEvent A) |
| WK-SCP0039-0022 | G03-WIRE | SCP0039 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0039 화면 | 판단불가(대상 단위 SCREEN) | 15 (ACT:SCP0039_ValidationMaster..ctor ACT:S) |
| WK-SCP0039-0023 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 없음 | 1 (`txtItemId + btnItemId` → `DM0002_Itemby) |
| WK-SCP0039-0024 | G5 | txtItemId / Model / Nickname / Item Id / | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItemId / Model / Nickname / Item Id / Model/Nic | 있음(FE 소스) | 1 (`txtItemId + btnItemId` → `DM0002_Itemby) |
| WK-SCP0039-0025 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 없음 | 1 (`txtItemId + btnItemId` → `DM0002_Itemby) |

## W6 검증 실행 (48)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0039-0026 | J2 | SCP0039 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0039 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 21 (`FindButton()` → `FindDataAll()` `Insert) |
| WK-SCP0039-0027 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0039_ValidationMaster.InitControl) |
| WK-SCP0039-0028 | C1 | clbPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0039_ValidationMaster.RefreshPlan) |
| WK-SCP0039-0029 | C3 | COUNT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — COUNT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCP0039_ValidationMaster.ClearSheet:) |
| WK-SCP0039-0030 | C3 | IMPACT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — IMPACT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0039_ValidationMaster.SetVisibleS) |
| WK-SCP0039-0031 | C3 | OPEN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPEN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0039_ValidationMaster.SetVisibleS) |
| WK-SCP0039-0032 | C3 | QUERY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — QUERY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCP0039_ValidationMaster.InsertBaseR) |
| WK-SCP0039-0033 | C3 | YYYYMM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — YYYYMM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0039_ValidationMaster.SetCalendar) |
| WK-SCP0039-0034 | C3 | YYYYMM_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — YYYYMM_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0039_ValidationMaster.SetCalendar) |
| WK-SCP0039-0035 | K4 | SCP0039 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0039 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 17 (ACT:SCP0039_ValidationMaster.BtnSearch_C) |
| WK-SCP0039-0036 | F1 | SCP0039 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0039 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 1 (`InsertButton/EditButton/DeleteButton/Sa) |
| WK-SCP0039-0037 | F5 | SCP0039 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0039 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (`InsertButton/EditButton/DeleteButton/Sa) |
| WK-SCP0039-0038 | F4 | PKG_COM0000.P_SCP0121_GET_SEARCH_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0121_GET_SEARCH_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 2 (ACT:SCP0039_ValidationMaster.GetSearchIn) |
| WK-SCP0039-0039 | F4 | PKG_SCP0039 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0039 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (`SpdMain_CellClick` QUERY 컬럼 → `FindData) |
| WK-SCP0039-0040 | F4 | SCM0003_GET_LOOKUP_MASTER_DETAIL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0003_GET_LOOKUP_MASTER_DETAIL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 2 (ACT:SCP0039_ValidationMaster.getLookupMa) |
| WK-SCP0039-0041 | A5 | OPEN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPEN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (`LockColumn(0..max)` siMain/siProjectRou) |
| WK-SCP0039-0042 | A5 | QUERY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — QUERY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (`LockColumn(0..max)` siMain/siProjectRou) |
| WK-SCP0039-0043 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0039_ValidationMaster.InitControl) |
| WK-SCP0039-0044 | G4 | clbPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlanGroup / Plan Group · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:SCP0039_ValidationMaster.InitControl) |
| WK-SCP0039-0045 | H2 | OPEN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPEN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (`LockColumn(0..max)` siMain/siProjectRou) |
| WK-SCP0039-0046 | H2 | QUERY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — QUERY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (`LockColumn(0..max)` siMain/siProjectRou) |
| WK-SCP0039-0047 | H5 | OPEN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPEN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (`LockColumn(0..max)` siMain/siProjectRou) |
| WK-SCP0039-0048 | H5 | QUERY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — QUERY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (`LockColumn(0..max)` siMain/siProjectRou) |
| WK-SCP0039-0049 | D1 | CONSTRAINTS01 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CONSTRAINTS01 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (`SpdMain_CellClick` 기타 → `ChangeActiveSh) |
| WK-SCP0039-0050 | D1 | OPEN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPEN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (`LockColumn(0..max)` siMain/siProjectRou) |
| WK-SCP0039-0051 | D1 | QUERY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — QUERY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (`LockColumn(0..max)` siMain/siProjectRou) |
| WK-SCP0039-0052 | D3 | CONSTRAINTS01 | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CONSTRAINTS01 · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (`SpdMain_CellClick` 기타 → `ChangeActiveSh) |
| WK-SCP0039-0053 | D3 | OPEN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPEN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (`LockColumn(0..max)` siMain/siProjectRou) |
| WK-SCP0039-0054 | D3 | QUERY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — QUERY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (`LockColumn(0..max)` siMain/siProjectRou) |
| WK-SCP0039-0055 | D6 | SCP0039 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0039 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (`InsertButton/EditButton/DeleteButton/Sa) |
| WK-SCP0039-0056 | E4 | IMPACT | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — IMPACT · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0039_ValidationMaster.SetVisibleS) |
| WK-SCP0039-0057 | E4 | OPEN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — OPEN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0039_ValidationMaster.SetVisibleS) |
| WK-SCP0039-0058 | E4 | QUERY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — QUERY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0039_ValidationMaster.SetVisibleS) |
| WK-SCP0039-0059 | E4 | YYYYMM | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — YYYYMM · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0039_ValidationMaster.SetCalendar) |
| WK-SCP0039-0060 | E4 | YYYYMM_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — YYYYMM_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0039_ValidationMaster.SetCalendar) |
| WK-SCP0039-0061 | A10 | SCP0039 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0039 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 45 (ACT:SCP0039_ValidationMaster.Form_Load A) |
| WK-SCP0039-0062 | A6 | PKG_SCP0039 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0039 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (`SpdMain_CellClick` QUERY 컬럼 → `FindData) |
| WK-SCP0039-0063 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0039_ValidationMaster.FindData AC) |
| WK-SCP0039-0064 | G1 | clbPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlanGroup / Plan Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (`clbPlanGroup` (SCP0121 Tables[3], `DBUt) |
| WK-SCP0039-0065 | G1 | txtItemId / Model / Nickname / Item Id / | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Nickname / Item Id / Model/Nic · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0039_ValidationMaster.FindData AC) |
| WK-SCP0039-0066 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SCP0039_ValidationMaster.InitControl) |
| WK-SCP0039-0067 | G6 | clbPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:SCP0039_ValidationMaster.InitControl) |
| WK-SCP0039-0068 | X-REOPEN | SCP0039 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0039 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 8 (ACT:SCP0039_ValidationMaster.Dispose ACT) |
| WK-SCP0039-0069 | H6 | txtItemId / Model / Nickname / Item Id / | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Nickname / Item Id / Model/Nic · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (`txtItemId + btnItemId` → `DM0002_Itemby) |
| WK-SCP0039-0070 | M4 | COUNT | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — COUNT · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (ACT:SCP0039_ValidationMaster.SpdMain_Cel) |
| WK-SCP0039-0071 | M4 | SHEET_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SHEET_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0039_ValidationMaster.SpdMain_Cel) |
| WK-SCP0039-0072 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (`txtItemId + btnItemId` → `DM0002_Itemby) |
| WK-SCP0039-0073 | M4 | txtItemId / Model / Nickname / Item Id / | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Model / Nickname / Item Id / Model/Nic · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요:  |  | 1 (`txtItemId + btnItemId` → `DM0002_Itemby) |

## W7 기대값 확정 (83)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0039-0074 | C1 | `ClbDivision_SelectedIndexChanged` → `Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `ClbDivision_SelectedIndexChanged` → `ClearSheet +: 행 집계 — C1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`ClbDivision_SelectedIndexChanged` → `Cl) |
| WK-SCP0039-0075 | C3 | SCP0039_ValidationMaster.ClbDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0039_ValidationMaster.ClbDivision_SelectedIndex: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0039_ValidationMaster.ClbDivision) |
| WK-SCP0039-0076 | C3 | SCP0039_ValidationMaster.ClbPlanGroup_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0039_ValidationMaster.ClbPlanGroup_SelectedInde: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0039_ValidationMaster.ClbPlanGrou) |
| WK-SCP0039-0077 | C3 | SCP0039_ValidationMaster.SetCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0039_ValidationMaster.SetCalendar: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0039_ValidationMaster.SetCalendar) |
| WK-SCP0039-0078 | C3 | SCP0039_ValidationMaster.SetVisibleSheet | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0039_ValidationMaster.SetVisibleSheetColumns: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0039_ValidationMaster.SetVisibleS) |
| WK-SCP0039-0079 | B3 | SCP0039_ValidationMaster.GetDicToValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0039_ValidationMaster.GetDicToValue: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0039_ValidationMaster.GetDicToVal) |
| WK-SCP0039-0080 | B3 | SCP0039_ValidationMaster.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0039_ValidationMaster.GetSearchInfo: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0039_ValidationMaster.GetSearchIn) |
| WK-SCP0039-0081 | B3 | SCP0039_ValidationMaster.getLookupMaster | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0039_ValidationMaster.getLookupMasterValidation: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0039_ValidationMaster.getLookupMa) |
| WK-SCP0039-0082 | B3 | `InsertBaseRow()` (lookup MASTER_VALIDAT | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `InsertBaseRow()` (lookup MASTER_VALIDATION seed): 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (`InsertBaseRow()` (lookup MASTER_VALIDAT) |
| WK-SCP0039-0083 | B4 | SCP0039_ValidationMaster.GetDicToValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0039_ValidationMaster.GetDicToValue: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0039_ValidationMaster.GetDicToVal) |
| WK-SCP0039-0084 | B4 | SCP0039_ValidationMaster.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0039_ValidationMaster.GetSearchInfo: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0039_ValidationMaster.GetSearchIn) |
| WK-SCP0039-0085 | B4 | SCP0039_ValidationMaster.getLookupMaster | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0039_ValidationMaster.getLookupMasterValidation: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0039_ValidationMaster.getLookupMa) |
| WK-SCP0039-0086 | B4 | `InsertBaseRow()` (lookup MASTER_VALIDAT | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `InsertBaseRow()` (lookup MASTER_VALIDATION seed): 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (`InsertBaseRow()` (lookup MASTER_VALIDAT) |
| WK-SCP0039-0087 | DB-SYN | SCP0039_ValidationMaster.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0039_ValidationMaster.FindData: 진입점 집계 — DB-SYN 3요소: NOPATH:2 · PASS:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0039_ValidationMaster.FindData:61) |
| WK-SCP0039-0088 | DB-SYN | SCP0039_ValidationMaster.GoPage | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0039_ValidationMaster.GoPage: 진입점 집계 — DB-SYN 3요소: NOPATH:2 · PASS:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0039_ValidationMaster.GoPage:1140) |
| WK-SCP0039-0089 | DB-SYN | `FindButton()` → `FindDataAll()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — `FindButton()` → `FindDataAll()`: 행 집계 — DB-SYN 3요소: NOPATH:2 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (`FindButton()` → `FindDataAll()`) |
| WK-SCP0039-0090 | DB-SYN | `FindDataAll` `Div:xx` 행 skip | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — `FindDataAll` `Div:xx` 행 skip: 행 집계 — DB-SYN 3요소: NOPATH:2 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (`FindDataAll` `Div:xx` 행 skip) |
| WK-SCP0039-0091 | F4 | SCP0039_ValidationMaster.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0039_ValidationMaster.FindButton: 진입점 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0039_ValidationMaster.FindButton ) |
| WK-SCP0039-0092 | F4 | SCP0039_ValidationMaster.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0039_ValidationMaster.FindData: 진입점 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 23 (ACT:SCP0039_ValidationMaster.FindData AC) |
| WK-SCP0039-0093 | F4 | SCP0039_ValidationMaster.FindDataAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0039_ValidationMaster.FindDataAll: 진입점 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0039_ValidationMaster.FindDataAll) |
| WK-SCP0039-0094 | F4 | SCP0039_ValidationMaster.GoPage | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0039_ValidationMaster.GoPage: 진입점 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0039_ValidationMaster.GoPage:1140) |
| WK-SCP0039-0095 | F4 | `FindButton()` → `FindDataAll()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `FindButton()` → `FindDataAll()`: 행 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`FindButton()` → `FindDataAll()`) |
| WK-SCP0039-0096 | F4 | `FindDataAll` `Div:xx` 행 skip | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `FindDataAll` `Div:xx` 행 skip: 행 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`FindDataAll` `Div:xx` 행 skip) |
| WK-SCP0039-0097 | A5 | SCP0039_ValidationMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0039_ValidationMaster.CreateSpread: 진입점 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0039_ValidationMaster.CreateSprea) |
| WK-SCP0039-0098 | H2 | SCP0039_ValidationMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0039_ValidationMaster.CreateSpread: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0039_ValidationMaster.CreateSprea) |
| WK-SCP0039-0099 | H5 | SCP0039_ValidationMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0039_ValidationMaster.CreateSpread: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0039_ValidationMaster.CreateSprea) |
| WK-SCP0039-0100 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 노출(keepRowVisibleUnderFilter) - read-only 뷰어 — Insert = NO-OP(`( |  | 1 (COMMON:UC-01) |
| WK-SCP0039-0101 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시 'MSG00703' confirm - 편집 모드 없음(상시 read-only, isReadOnly). 미저장 수정 상태가 존재하지 않아 재 |  | 1 (COMMON:UC-02) |
| WK-SCP0039-0102 | X-REASON | COMMON:UC-04 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-04 CRUD 완료 알림 = 하단 중앙 Toast 자동 소멸 - CRUD 경로 없음(read-only). 저장/삭제/등록 완료 이벤트가 없어 완료 Toast 미해당 해당없음 |  | 1 (COMMON:UC-04) |
| WK-SCP0039-0103 | X-REASON | COMMON:UC-05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-05 Excel Download 시 콤보 컬럼 데이터 Code 아닌 Name 출력 - 마스터/detail 그리드 콤보 컬럼 0(전 컬럼 read-only text, CELL_CONT |  | 1 (COMMON:UC-05) |
| WK-SCP0039-0104 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 콤마 구분 다중 입력 시 전건 조회 - 조회조건에 자유 key-in 다중검색 텍스트 필드 없음 — Division/PlanGroup = 콤보(단일/다중 s |  | 1 (COMMON:UC-06) |
| WK-SCP0039-0105 | X-REASON | COMMON:UC-07 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-07 필터 걸린 상태 재조회 시 조회되고 필터도 그대로 적용(rebindFilterColumns) - 재조회 = 명시 SEARCH/QUERY 로 데이터 교체(마스터 lookup·de |  | 1 (COMMON:UC-07) |
| WK-SCP0039-0106 | D1 | `InsertButton/EditButton/DeleteButton/Sa | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `InsertButton/EditButton/DeleteButton/SaveButton`(: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`InsertButton/EditButton/DeleteButton/Sa) |
| WK-SCP0039-0107 | D3 | `InsertButton/EditButton/DeleteButton/Sa | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `InsertButton/EditButton/DeleteButton/SaveButton`(: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`InsertButton/EditButton/DeleteButton/Sa) |
| WK-SCP0039-0108 | E4 | SCP0039_ValidationMaster.SetCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0039_ValidationMaster.SetCalendar: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0039_ValidationMaster.SetCalendar) |
| WK-SCP0039-0109 | E4 | SCP0039_ValidationMaster.SetVisibleSheet | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0039_ValidationMaster.SetVisibleSheetColumns: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0039_ValidationMaster.SetVisibleS) |
| WK-SCP0039-0110 | E4 | `InsertBaseRow()` (lookup MASTER_VALIDAT | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `InsertBaseRow()` (lookup MASTER_VALIDATION seed): 행 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`InsertBaseRow()` (lookup MASTER_VALIDAT) |
| WK-SCP0039-0111 | A1 | PKG_SCP0039 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0039: 골든 비교 케이스 없음(PKG_SCP0039 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (`SpdMain_CellClick` QUERY 컬럼 → `FindData) |
| WK-SCP0039-0112 | A1 | SCP0039_ValidationMaster.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0039_ValidationMaster.FindButton: 진입점 집계 — A1 1요소: REVIEW:1 |  | 2 (ACT:SCP0039_ValidationMaster.FindButton ) |
| WK-SCP0039-0113 | A1 | SCP0039_ValidationMaster.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0039_ValidationMaster.FindData: 진입점 집계 — A1 1요소: REVIEW:1 |  | 23 (ACT:SCP0039_ValidationMaster.FindData AC) |
| WK-SCP0039-0114 | A1 | SCP0039_ValidationMaster.FindDataAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0039_ValidationMaster.FindDataAll: 진입점 집계 — A1 1요소: REVIEW:1 |  | 10 (ACT:SCP0039_ValidationMaster.FindDataAll) |
| WK-SCP0039-0115 | A1 | SCP0039_ValidationMaster.InsertBaseRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0039_ValidationMaster.InsertBaseRow: 진입점 집계 — A1 1요소: REVIEW:1 |  | 1 (ACT:SCP0039_ValidationMaster.InsertBaseR) |
| WK-SCP0039-0116 | A1 | `FindButton()` → `FindDataAll()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `FindButton()` → `FindDataAll()`: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`FindButton()` → `FindDataAll()`) |
| WK-SCP0039-0117 | A1 | `FindDataAll` `Div:xx` 행 skip | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `FindDataAll` `Div:xx` 행 skip: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`FindDataAll` `Div:xx` 행 skip) |
| WK-SCP0039-0118 | A1 | `clbPlanGroup` (SCP0121 Tables[3], `DBUt | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `clbPlanGroup` (SCP0121 Tables[3], `DBUtils.Filter: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`clbPlanGroup` (SCP0121 Tables[3], `DBUt) |
| WK-SCP0039-0119 | A6 | SCP0039_ValidationMaster.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0039_ValidationMaster.FindButton: 진입점 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0039_ValidationMaster.FindButton ) |
| WK-SCP0039-0120 | A6 | SCP0039_ValidationMaster.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0039_ValidationMaster.FindData: 진입점 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:SCP0039_ValidationMaster.FindData AC) |
| WK-SCP0039-0121 | A6 | SCP0039_ValidationMaster.FindDataAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0039_ValidationMaster.FindDataAll: 진입점 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0039_ValidationMaster.FindDataAll) |
| WK-SCP0039-0122 | A6 | `FindButton()` → `FindDataAll()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — `FindButton()` → `FindDataAll()`: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`FindButton()` → `FindDataAll()`) |
| WK-SCP0039-0123 | A6 | `FindDataAll` `Div:xx` 행 skip | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — `FindDataAll` `Div:xx` 행 skip: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`FindDataAll` `Div:xx` 행 skip) |
| WK-SCP0039-0124 | G1 | SCP0039_ValidationMaster.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0039_ValidationMaster.FindButton: 진입점 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0039_ValidationMaster.FindButton:) |
| WK-SCP0039-0125 | G1 | SCP0039_ValidationMaster.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0039_ValidationMaster.FindData: 진입점 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 22 (ACT:SCP0039_ValidationMaster.FindData:59) |
| WK-SCP0039-0126 | G1 | SCP0039_ValidationMaster.FindDataAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0039_ValidationMaster.FindDataAll: 진입점 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0039_ValidationMaster.FindDataAll) |
| WK-SCP0039-0127 | G1 | `FindButton()` → `FindDataAll()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `FindButton()` → `FindDataAll()`: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`FindButton()` → `FindDataAll()`) |
| WK-SCP0039-0128 | G1 | `FindDataAll` `Div:xx` 행 skip | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `FindDataAll` `Div:xx` 행 skip: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`FindDataAll` `Div:xx` 행 skip) |
| WK-SCP0039-0129 | X-ROW | SCP0039_ValidationMaster..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster..ctor: 진입점 집계 1검사 — NOPATH:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0039_ValidationMaster..ctor:154:4) |
| WK-SCP0039-0130 | X-ROW | SCP0039_ValidationMaster.ClbDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.ClbDivision_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0039_ValidationMaster.ClbDivision) |
| WK-SCP0039-0131 | X-ROW | SCP0039_ValidationMaster.ClbPlanGroup_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.ClbPlanGroup_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0039_ValidationMaster.ClbPlanGrou) |
| WK-SCP0039-0132 | X-ROW | SCP0039_ValidationMaster.ClearSheet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.ClearSheet: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0039_ValidationMaster.ClearSheet ) |
| WK-SCP0039-0133 | X-ROW | SCP0039_ValidationMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0039_ValidationMaster.CreateSprea) |
| WK-SCP0039-0134 | X-ROW | SCP0039_ValidationMaster.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0039_ValidationMaster.FindButton) |
| WK-SCP0039-0135 | X-ROW | SCP0039_ValidationMaster.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.FindData: 진입점 집계 10검사 — NOT_RUN:5 · REVIEW:3 · NOPATH:2 |  | 9 (ACT:SCP0039_ValidationMaster.FindData:58) |
| WK-SCP0039-0136 | X-ROW | SCP0039_ValidationMaster.FindDataAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.FindDataAll: 진입점 집계 6검사 — REVIEW:4 · NOT_RUN:2 |  | 1 (ACT:SCP0039_ValidationMaster.FindDataAll) |
| WK-SCP0039-0137 | X-ROW | SCP0039_ValidationMaster.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0039_ValidationMaster.Form_Load) |
| WK-SCP0039-0138 | X-ROW | SCP0039_ValidationMaster.GetDicToValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.GetDicToValue: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0039_ValidationMaster.GetDicToVal) |
| WK-SCP0039-0139 | X-ROW | SCP0039_ValidationMaster.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.GetSearchInfo: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0039_ValidationMaster.GetSearchIn) |
| WK-SCP0039-0140 | X-ROW | SCP0039_ValidationMaster.GoPage | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.GoPage: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SCP0039_ValidationMaster.GoPage ACT:) |
| WK-SCP0039-0141 | X-ROW | SCP0039_ValidationMaster.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.InitControls: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0039_ValidationMaster.InitControl) |
| WK-SCP0039-0142 | X-ROW | SCP0039_ValidationMaster.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0039_ValidationMaster.InitSpread) |
| WK-SCP0039-0143 | X-ROW | SCP0039_ValidationMaster.InsertBaseRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.InsertBaseRow: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 52 (ACT:SCP0039_ValidationMaster.InsertBaseR) |
| WK-SCP0039-0144 | X-ROW | SCP0039_ValidationMaster.RefreshPlanGrou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.RefreshPlanGroupByDivisio: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0039_ValidationMaster.RefreshPlan) |
| WK-SCP0039-0145 | X-ROW | SCP0039_ValidationMaster.SCP0039_Validat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.SCP0039_ValidationMaster_: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/FLAG/LOCAL/UI_PROP, |  | 14 (ACT:SCP0039_ValidationMaster.SCP0039_Val) |
| WK-SCP0039-0146 | X-ROW | SCP0039_ValidationMaster.SetCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.SetCalendar: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0039_ValidationMaster.SetCalendar) |
| WK-SCP0039-0147 | X-ROW | SCP0039_ValidationMaster.SpdMain_CellCli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.SpdMain_CellClick: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 27 (ACT:SCP0039_ValidationMaster.SpdMain_Cel) |
| WK-SCP0039-0148 | X-ROW | SCP0039_ValidationMaster.SpdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.SpdMain_CellDoubleClick: 진입점 집계 5검사 — NOT_RUN:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0039_ValidationMaster.SpdMain_Cel) |
| WK-SCP0039-0149 | X-ROW | SCP0039_ValidationMaster.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0039_ValidationMaster.btnItemId_C) |
| WK-SCP0039-0150 | X-ROW | SCP0039_ValidationMaster.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.btnItemId_Click_1: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LOCAL/POPUP/UI_PROP/VALUE_SET, 연 |  | 14 (ACT:SCP0039_ValidationMaster.btnItemId_C) |
| WK-SCP0039-0151 | X-ROW | SCP0039_ValidationMaster.getLookupMaster | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0039_ValidationMaster.getLookupMasterValidation: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0039_ValidationMaster.getLookupMa) |
| WK-SCP0039-0152 | X-ROW | `CONSTRAINTS01` `Const:...^PlanGroup` 파싱 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `CONSTRAINTS01` `Const:...^PlanGroup` 파싱: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`CONSTRAINTS01` `Const:...^PlanGroup` 파싱) |
| WK-SCP0039-0153 | X-ROW | `SpdMain_CellClick` OPEN 컬럼 → `GoPage` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `SpdMain_CellClick` OPEN 컬럼 → `GoPage`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`SpdMain_CellClick` OPEN 컬럼 → `GoPage`) |
| WK-SCP0039-0154 | G5 | SCP0039_ValidationMaster.SpdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0039_ValidationMaster.SpdMain_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0039_ValidationMaster.SpdMain_Cel) |
| WK-SCP0039-0155 | H6 | SCP0039_ValidationMaster.SpdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0039_ValidationMaster.SpdMain_CellDoubleClick: 진입점 집계 — H6 2요소: NOT_RUN:1 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0039_ValidationMaster.SpdMain_Cel) |
| WK-SCP0039-0156 | M4 | SCP0039_ValidationMaster.SpdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0039_ValidationMaster.SpdMain_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0039_ValidationMaster.SpdMain_Cel) |

## W8 구현 후 검증 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0039-0157 | X-ROW | `SetCalendar`/`AddNumColumn`(동적 월컬럼) | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 `SetCalendar`/`AddNumColumn`(동적 월컬럼) 구현 후 검증 · 대상 `SetCalendar`/`AddNumColumn`(동적 월컬럼) |  | 1 (`SetCalendar`/`AddNumColumn`(동적 월컬럼)) |
| WK-SCP0039-0158 | G5 | `IsPopup` 임베드 변형(Plan Control 호출) | 선행 W1 완료 후 E2E | G5 — 대조표 미구현 행 `IsPopup` 임베드 변형(Plan Control 호출) 구현 후 검증 · 대상 `IsPopup` 임베드 변형(Plan Control 호출) |  | 1 (`IsPopup` 임베드 변형(Plan Control 호출)) |
| WK-SCP0039-0159 | H6 | `IsPopup` 임베드 변형(Plan Control 호출) | 선행 W1 완료 후 E2E | H6 — 대조표 미구현 행 `IsPopup` 임베드 변형(Plan Control 호출) 구현 후 검증 · 대상 `IsPopup` 임베드 변형(Plan Control 호출) |  | 1 (`IsPopup` 임베드 변형(Plan Control 호출)) |
| WK-SCP0039-0160 | M4 | `IsPopup` 임베드 변형(Plan Control 호출) | 선행 W1 완료 후 E2E | M4 — 대조표 미구현 행 `IsPopup` 임베드 변형(Plan Control 호출) 구현 후 검증 · 대상 `IsPopup` 임베드 변형(Plan Control 호출) |  | 1 (`IsPopup` 임베드 변형(Plan Control 호출)) |

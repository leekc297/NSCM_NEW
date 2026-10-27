# 작업 원장 — SSP0017 · 2026-10-26 12:56

> 검사 인스턴스 186건 중 PASS·NA 57건 외 **129건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 20 | 구현 위치 실존 |
| W4 | 검사기 구현 | 2 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 11 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 44 | 실행 → PASS |
| W7 | 기대값 확정 | 52 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 52 · E2E 44 · 대조표 20 · 하네스 13
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 3건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 20 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 19 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| G4 | DESIGN |  |  |  |  | 2 | 5 | 3 |  |  | 조회조건 표시·라벨·활성 |
| A1 | GEN |  |  |  |  |  |  | 10 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 5 | 4 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| B4 | COMBO |  |  |  |  | 2 |  | 6 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G6 | GEN |  |  |  |  |  | 5 | 3 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B3 | COMBO |  |  |  | 2 |  |  | 5 |  |  | 콤보 후보 정렬 = AS-IS |
| E4 | EDIT |  |  |  |  |  | 5 | 1 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C1 | CASCADE |  |  |  |  |  | 4 | 1 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G5 | POPUP |  |  |  |  | 3 |  |  |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 1 |  |  |  | 팝업 표준·열림 |
| F4 | DB |  |  |  |  |  | 3 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| M4 | POPUP |  |  |  |  |  | 3 |  |  |  | 팝업 선택값 반영 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | GEN |  |  |  |  |  | 1 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (20)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0017-0001 | X-LOC | `DataUtil.checkRequiredOfSearch` alert 문 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DataUtil.checkRequiredOfSearch` alert 문) |
| WK-SSP0017-0002 | X-LOC | `DataUtil.checkRequiredOfSearch`("Plan-d | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DataUtil.checkRequiredOfSearch`("Plan-d) |
| WK-SSP0017-0003 | X-LOC | `INVENTORY_TYPE`/`INVENTORY_STATUS` 셀 콤보 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`INVENTORY_TYPE`/`INVENTORY_STATUS` 셀 콤보) |
| WK-SSP0017-0004 | X-LOC | `InitSpreadFooterSum()`(cs:213-233 — Sum | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`InitSpreadFooterSum()`(cs:213-233 — Sum) |
| WK-SSP0017-0005 | X-LOC | `Insert/Delete/Edit/SaveButton` override | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`Insert/Delete/Edit/SaveButton` override) |
| WK-SSP0017-0006 | X-LOC | `LockColumn(0, max, true)`(조회 직후 전 컬럼 잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`LockColumn(0, max, true)`(조회 직후 전 컬럼 잠금) |
| WK-SSP0017-0007 | X-LOC | `SmartColMerge()`(스크롤 재계산) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SmartColMerge()`(스크롤 재계산)) |
| WK-SSP0017-0008 | X-LOC | `btnMeasure_Click` → `SCM0002_TitleSetFo | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`btnMeasure_Click` → `SCM0002_TitleSetFo) |
| WK-SSP0017-0009 | X-LOC | `cboInventoryType`(`LookupCommon`/INV_TY | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`cboInventoryType`(`LookupCommon`/INV_TY) |
| WK-SSP0017-0010 | X-LOC | `cboPlanDate`(`PlanDateShip`) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`cboPlanDate`(`PlanDateShip`)) |
| WK-SSP0017-0011 | X-LOC | `clbDivision_SelectedIndexChanged`(casca | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`clbDivision_SelectedIndexChanged`(casca) |
| WK-SSP0017-0012 | X-LOC | `clbDivision`(고정 "40"+disabled, `MyDivis | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`clbDivision`(고정 "40"+disabled, `MyDivis) |
| WK-SSP0017-0013 | X-LOC | `clbPlantSite`(Division EE 분기 2종 SQL_ID) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`clbPlantSite`(Division EE 분기 2종 SQL_ID)) |
| WK-SSP0017-0014 | X-LOC | `imageList1`(edit.png, cellTypeImage) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`imageList1`(edit.png, cellTypeImage)) |
| WK-SSP0017-0015 | X-LOC | `panel1`(Dock=Fill) → `spdMain` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`panel1`(Dock=Fill) → `spdMain`) |
| WK-SSP0017-0016 | X-LOC | `siMain.Query(dsBinding)`(SP 바인딩) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`siMain.Query(dsBinding)`(SP 바인딩)) |
| WK-SSP0017-0017 | X-LOC | `txtItemId`+`btnItemId`(`SCM0002_ItembyD | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`txtItemId`+`btnItemId`(`SCM0002_ItembyD) |
| WK-SSP0017-0018 | X-LOC | `usrButton1`(미배선 죽은 컨트롤) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`usrButton1`(미배선 죽은 컨트롤)) |
| WK-SSP0017-0019 | X-LOC | `usrConditionPanel1`(HidePanel) + `usrLa | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`usrConditionPanel1`(HidePanel) + `usrLa) |
| WK-SSP0017-0020 | X-LOC | 컬럼 31개(DB메타, hidden 4건) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (컬럼 31개(DB메타, hidden 4건)) |

## W4 검사기 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0017-0021 | B3 | cboInventoryType / Inventory Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboInventoryType / Inventory Type | 있음(FE 소스) | 1 (`cboInventoryType`(`LookupCommon`/INV_TY) |
| WK-SSP0017-0022 | B3 | cboPlanDate / Plan-date / Plan Date | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 3 (ACT:SSP0017_InventoryRaw.GetDayRange ACT) |

## W5 검사기 연결 (11)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0017-0023 | B4 | cboInventoryType / Inventory Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboInventoryType / Inventory Type | 있음(FE 소스) | 1 (`cboInventoryType`(`LookupCommon`/INV_TY) |
| WK-SSP0017-0024 | B4 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 3 (ACT:SSP0017_InventoryRaw.GetDayRange ACT) |
| WK-SSP0017-0025 | F2 | SSP0017 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0017 화면 | 판단불가(대상 단위 SCREEN) | 1 (`Insert/Delete/Edit/SaveButton` override) |
| WK-SSP0017-0026 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 3 (`txtItemId`+`btnItemId`(`SCM0002_ItembyD) |
| WK-SSP0017-0027 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:SSP0017_InventoryRaw.InitEvent ACT:S) |
| WK-SSP0017-0028 | G03-WIRE | SSP0017 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0017 화면 | 판단불가(대상 단위 SCREEN) | 8 (ACT:SSP0017_InventoryRaw..ctor ACT:SSP00) |
| WK-SSP0017-0029 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 없음 | 1 (`txtItemId`+`btnItemId`(`SCM0002_ItembyD) |
| WK-SSP0017-0030 | G5 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (`btnMeasure_Click` → `SCM0002_TitleSetFo) |
| WK-SSP0017-0031 | G5 | txtItemId / Model / Item Id / Model/Nick | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItemId / Model / Item Id / Model/Nickname | 있음(FE 소스) | 1 (`txtItemId`+`btnItemId`(`SCM0002_ItembyD) |
| WK-SSP0017-0032 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 없음 | 1 (`txtItemId`+`btnItemId`(`SCM0002_ItembyD) |
| WK-SSP0017-0033 | H6 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (`btnMeasure_Click` → `SCM0002_TitleSetFo) |

## W6 검증 실행 (44)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0017-0034 | J2 | SSP0017 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0017 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 39 (`imageList1`(edit.png, cellTypeImage) `c) |
| WK-SSP0017-0035 | C1 | cboInventoryType / Inventory Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboInventoryType / Inventory Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0017_InventoryRaw.InitControls:18) |
| WK-SSP0017-0036 | C1 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0017_InventoryRaw.SetChangedContr) |
| WK-SSP0017-0037 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0017_InventoryRaw.InitControls:17) |
| WK-SSP0017-0038 | C1 | clbPlantSite / Plant Site / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0017_InventoryRaw.SetChangedContr) |
| WK-SSP0017-0039 | G3 | SSP0017 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0017 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 1 (`usrConditionPanel1`(HidePanel) + `usrLa) |
| WK-SSP0017-0040 | K-SA | SSP0017 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0017 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (`usrConditionPanel1`(HidePanel) + `usrLa) |
| WK-SSP0017-0041 | K4 | SSP0017 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0017 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 28 (ACT:SSP0017_InventoryRaw.btnItemId_Click) |
| WK-SSP0017-0042 | F1 | SSP0017 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0017 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 1 (`Insert/Delete/Edit/SaveButton` override) |
| WK-SSP0017-0043 | F5 | SSP0017 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SSP0017 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (`Insert/Delete/Edit/SaveButton` override) |
| WK-SSP0017-0044 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 2 (ACT:SSP0017_InventoryRaw.GetDayRange:514) |
| WK-SSP0017-0045 | F4 | PKG_SSP0017.P_SSP0017_GET_INVENTORY_RAW | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0017.P_SSP0017_GET_INVENTORY_RAW · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 43 (ACT:SSP0017_InventoryRaw.FindButton ACT:) |
| WK-SSP0017-0046 | F4 | SCM0001_GET_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SSP0017_InventoryRaw.GetDivision:478) |
| WK-SSP0017-0047 | G4 | cboInventoryType / Inventory Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboInventoryType / Inventory Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (`cboInventoryType`(`LookupCommon`/INV_TY) |
| WK-SSP0017-0048 | G4 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (`cboPlanDate`(`PlanDateShip`) ACT:SSP001) |
| WK-SSP0017-0049 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (`clbDivision`(고정 "40"+disabled, `MyDivis) |
| WK-SSP0017-0050 | G4 | clbPlantSite / Plant Site / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site / From Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (`clbPlantSite`(Division EE 분기 2종 SQL_ID)) |
| WK-SSP0017-0051 | G4 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (`txtItemId`+`btnItemId`(`SCM0002_ItembyD) |
| WK-SSP0017-0052 | H4 | SSP0017 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0017 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SSP0017_InventoryRaw.SpdMain_TopChan) |
| WK-SSP0017-0053 | I1 | SSP0017 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0017 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 3 (`DataUtil.checkRequiredOfSearch` alert 문) |
| WK-SSP0017-0054 | SC1 | SSP0017 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SSP0017 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 8 (`clbDivision`(고정 "40"+disabled, `MyDivis) |
| WK-SSP0017-0055 | D6 | SSP0017 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0017 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (`Insert/Delete/Edit/SaveButton` override) |
| WK-SSP0017-0056 | E4 | MSG00007 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00007 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0017_InventoryRaw.btnMeasure_Clic) |
| WK-SSP0017-0057 | E4 | MSG00614 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00614 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (`DataUtil.checkRequiredOfSearch` alert 문) |
| WK-SSP0017-0058 | E4 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 2 (ACT:SSP0017_InventoryRaw.SetChangedContr) |
| WK-SSP0017-0059 | E4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SSP0017_InventoryRaw.SetChangedContr) |
| WK-SSP0017-0060 | E4 | clbPlantSite / Plant Site / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site / From Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저 |  | 2 (ACT:SSP0017_InventoryRaw.SetChangedContr) |
| WK-SSP0017-0061 | A10 | SSP0017 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0017 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 48 (ACT:SSP0017_InventoryRaw.DefineProperty ) |
| WK-SSP0017-0062 | A6 | PKG_SSP0017.P_SSP0017_GET_INVENTORY_RAW | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0017.P_SSP0017_GET_INVENTORY_RAW · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · |  | 43 (ACT:SSP0017_InventoryRaw.FindButton ACT:) |
| WK-SSP0017-0063 | G1 | cboInventoryType / Inventory Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboInventoryType / Inventory Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (`cboInventoryType`(`LookupCommon`/INV_TY) |
| WK-SSP0017-0064 | G1 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (`cboPlanDate`(`PlanDateShip`) ACT:SSP001) |
| WK-SSP0017-0065 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (`clbDivision`(고정 "40"+disabled, `MyDivis) |
| WK-SSP0017-0066 | G1 | clbPlantSite / Plant Site / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (`clbPlantSite`(Division EE 분기 2종 SQL_ID)) |
| WK-SSP0017-0067 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (`txtItemId`+`btnItemId`(`SCM0002_ItembyD) |
| WK-SSP0017-0068 | G6 | cboInventoryType / Inventory Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboInventoryType / Inventory Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (`cboInventoryType`(`LookupCommon`/INV_TY) |
| WK-SSP0017-0069 | G6 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (`cboPlanDate`(`PlanDateShip`) ACT:SSP001) |
| WK-SSP0017-0070 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (`clbDivision`(고정 "40"+disabled, `MyDivis) |
| WK-SSP0017-0071 | G6 | clbPlantSite / Plant Site / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site / From Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (`clbPlantSite`(Division EE 분기 2종 SQL_ID)) |
| WK-SSP0017-0072 | G6 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (`txtItemId`+`btnItemId`(`SCM0002_ItembyD) |
| WK-SSP0017-0073 | X-REOPEN | SSP0017 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0017 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SSP0017_InventoryRaw.Dispose ACT:SSP) |
| WK-SSP0017-0074 | H6 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (`txtItemId`+`btnItemId`(`SCM0002_ItembyD) |
| WK-SSP0017-0075 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (`txtItemId`+`btnItemId`(`SCM0002_ItembyD) |
| WK-SSP0017-0076 | M4 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (`btnMeasure_Click` → `SCM0002_TitleSetFo) |
| WK-SSP0017-0077 | M4 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (`txtItemId`+`btnItemId`(`SCM0002_ItembyD) |

## W7 기대값 확정 (52)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0017-0078 | C1 | `clbDivision_SelectedIndexChanged`(casca | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `clbDivision_SelectedIndexChanged`(cascade): 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`clbDivision_SelectedIndexChanged`(casca) |
| WK-SSP0017-0079 | B3 | SSP0017_InventoryRaw.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0017_InventoryRaw.GetDayRange: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0017_InventoryRaw.GetDayRange:505) |
| WK-SSP0017-0080 | B3 | SSP0017_InventoryRaw.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0017_InventoryRaw.GetDivision: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0017_InventoryRaw.GetDivision:474) |
| WK-SSP0017-0081 | B3 | SSP0017_InventoryRaw.GetShipToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0017_InventoryRaw.GetShipToParty: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0017_InventoryRaw.GetShipToParty:) |
| WK-SSP0017-0082 | B3 | SSP0017_InventoryRaw.GetShipType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0017_InventoryRaw.GetShipType: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0017_InventoryRaw.GetShipType:487) |
| WK-SSP0017-0083 | B3 | SSP0017_InventoryRaw.GetSoldToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0017_InventoryRaw.GetSoldToParty: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0017_InventoryRaw.GetSoldToParty:) |
| WK-SSP0017-0084 | B4 | SSP0017_InventoryRaw.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0017_InventoryRaw.GetDayRange: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0017_InventoryRaw.GetDayRange:505) |
| WK-SSP0017-0085 | B4 | SSP0017_InventoryRaw.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0017_InventoryRaw.GetDivision: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0017_InventoryRaw.GetDivision:474) |
| WK-SSP0017-0086 | B4 | SSP0017_InventoryRaw.GetShipToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0017_InventoryRaw.GetShipToParty: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0017_InventoryRaw.GetShipToParty:) |
| WK-SSP0017-0087 | B4 | SSP0017_InventoryRaw.GetShipType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0017_InventoryRaw.GetShipType: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0017_InventoryRaw.GetShipType:487) |
| WK-SSP0017-0088 | B4 | SSP0017_InventoryRaw.GetSoldToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0017_InventoryRaw.GetSoldToParty: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0017_InventoryRaw.GetSoldToParty:) |
| WK-SSP0017-0089 | B4 | `INVENTORY_TYPE`/`INVENTORY_STATUS` 셀 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `INVENTORY_TYPE`/`INVENTORY_STATUS` 셀 콤보: 행 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`INVENTORY_TYPE`/`INVENTORY_STATUS` 셀 콤보) |
| WK-SSP0017-0090 | G4 | `DataUtil.checkRequiredOfSearch` alert 문 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `DataUtil.checkRequiredOfSearch` alert 문구(MSG00614: 행 집계 — G4 7요소: NOT_RUN:5 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`DataUtil.checkRequiredOfSearch` alert 문) |
| WK-SSP0017-0091 | G4 | `DataUtil.checkRequiredOfSearch`("Plan-d | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `DataUtil.checkRequiredOfSearch`("Plan-date*"): 행 집계 — G4 7요소: NOT_RUN:5 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`DataUtil.checkRequiredOfSearch`("Plan-d) |
| WK-SSP0017-0092 | G4 | `clbDivision_SelectedIndexChanged`(casca | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `clbDivision_SelectedIndexChanged`(cascade): 행 집계 — G4 7요소: NOT_RUN:5 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`clbDivision_SelectedIndexChanged`(casca) |
| WK-SSP0017-0093 | E4 | SSP0017_InventoryRaw.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0017_InventoryRaw.SetChangedControl: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0017_InventoryRaw.SetChangedContr) |
| WK-SSP0017-0094 | A1 | PKG_SSP0017.P_SSP0017_GET_INVENTORY_RAW | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0017.P_SSP0017_GET_INVENTORY_RAW: 골든 비교 케이스 없음(PKG_SSP0017.P_SSP0017_GET_INVENTORY_RAW — 팝업·보조 SP 는 golden_case |  | 43 (ACT:SSP0017_InventoryRaw.FindButton ACT:) |
| WK-SSP0017-0095 | A1 | `DataUtil.checkRequiredOfSearch` alert 문 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `DataUtil.checkRequiredOfSearch` alert 문구(MSG00614: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`DataUtil.checkRequiredOfSearch` alert 문) |
| WK-SSP0017-0096 | A1 | `DataUtil.checkRequiredOfSearch`("Plan-d | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `DataUtil.checkRequiredOfSearch`("Plan-date*"): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`DataUtil.checkRequiredOfSearch`("Plan-d) |
| WK-SSP0017-0097 | A1 | `LockColumn(0, max, true)`(조회 직후 전 컬럼 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `LockColumn(0, max, true)`(조회 직후 전 컬럼 잠금): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`LockColumn(0, max, true)`(조회 직후 전 컬럼 잠금) |
| WK-SSP0017-0098 | A1 | `cboInventoryType`(`LookupCommon`/INV_TY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `cboInventoryType`(`LookupCommon`/INV_TYPE): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`cboInventoryType`(`LookupCommon`/INV_TY) |
| WK-SSP0017-0099 | A1 | `cboPlanDate`(`PlanDateShip`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `cboPlanDate`(`PlanDateShip`): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`cboPlanDate`(`PlanDateShip`)) |
| WK-SSP0017-0100 | A1 | `clbDivision_SelectedIndexChanged`(casca | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `clbDivision_SelectedIndexChanged`(cascade): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`clbDivision_SelectedIndexChanged`(casca) |
| WK-SSP0017-0101 | A1 | `clbDivision`(고정 "40"+disabled, `MyDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `clbDivision`(고정 "40"+disabled, `MyDivisionInEE_SC: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`clbDivision`(고정 "40"+disabled, `MyDivis) |
| WK-SSP0017-0102 | A1 | `clbPlantSite`(Division EE 분기 2종 SQL_ID) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `clbPlantSite`(Division EE 분기 2종 SQL_ID): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`clbPlantSite`(Division EE 분기 2종 SQL_ID)) |
| WK-SSP0017-0103 | A1 | `txtItemId`+`btnItemId`(`SCM0002_ItembyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `txtItemId`+`btnItemId`(`SCM0002_ItembyDivisionPop: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`txtItemId`+`btnItemId`(`SCM0002_ItembyD) |
| WK-SSP0017-0104 | G1 | `DataUtil.checkRequiredOfSearch` alert 문 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `DataUtil.checkRequiredOfSearch` alert 문구(MSG00614: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`DataUtil.checkRequiredOfSearch` alert 문) |
| WK-SSP0017-0105 | G1 | `DataUtil.checkRequiredOfSearch`("Plan-d | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `DataUtil.checkRequiredOfSearch`("Plan-date*"): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`DataUtil.checkRequiredOfSearch`("Plan-d) |
| WK-SSP0017-0106 | G1 | `LockColumn(0, max, true)`(조회 직후 전 컬럼 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `LockColumn(0, max, true)`(조회 직후 전 컬럼 잠금): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`LockColumn(0, max, true)`(조회 직후 전 컬럼 잠금) |
| WK-SSP0017-0107 | G1 | `clbDivision_SelectedIndexChanged`(casca | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `clbDivision_SelectedIndexChanged`(cascade): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`clbDivision_SelectedIndexChanged`(casca) |
| WK-SSP0017-0108 | G6 | `DataUtil.checkRequiredOfSearch` alert 문 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `DataUtil.checkRequiredOfSearch` alert 문구(MSG00614: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`DataUtil.checkRequiredOfSearch` alert 문) |
| WK-SSP0017-0109 | G6 | `DataUtil.checkRequiredOfSearch`("Plan-d | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `DataUtil.checkRequiredOfSearch`("Plan-date*"): 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`DataUtil.checkRequiredOfSearch`("Plan-d) |
| WK-SSP0017-0110 | G6 | `clbDivision_SelectedIndexChanged`(casca | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `clbDivision_SelectedIndexChanged`(cascade): 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`clbDivision_SelectedIndexChanged`(casca) |
| WK-SSP0017-0111 | X-ROW | SSP0017_InventoryRaw.ClearUsrCheckedList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된 요소 검사 |  | 4 (ACT:SSP0017_InventoryRaw.ClearUsrChecked) |
| WK-SSP0017-0112 | X-ROW | SSP0017_InventoryRaw.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0017_InventoryRaw.CreateSpread) |
| WK-SSP0017-0113 | X-ROW | SSP0017_InventoryRaw.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0017_InventoryRaw.DefineProperty ) |
| WK-SSP0017-0114 | X-ROW | SSP0017_InventoryRaw.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SSP0017_InventoryRaw.FindButton) |
| WK-SSP0017-0115 | X-ROW | SSP0017_InventoryRaw.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.FindData_Main: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:1 · PASS:1 |  | 7 (ACT:SSP0017_InventoryRaw.FindData_Main:3) |
| WK-SSP0017-0116 | X-ROW | SSP0017_InventoryRaw.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0017_InventoryRaw.Form_Load) |
| WK-SSP0017-0117 | X-ROW | SSP0017_InventoryRaw.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.GetDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0017_InventoryRaw.GetDivision) |
| WK-SSP0017-0118 | X-ROW | SSP0017_InventoryRaw.GetShipToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.GetShipToParty: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0017_InventoryRaw.GetShipToParty) |
| WK-SSP0017-0119 | X-ROW | SSP0017_InventoryRaw.GetShipType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.GetShipType: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0017_InventoryRaw.GetShipType) |
| WK-SSP0017-0120 | X-ROW | SSP0017_InventoryRaw.GetSoldToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.GetSoldToParty: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0017_InventoryRaw.GetSoldToParty) |
| WK-SSP0017-0121 | X-ROW | SSP0017_InventoryRaw.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.InitControls: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0017_InventoryRaw.InitControls:17) |
| WK-SSP0017-0122 | X-ROW | SSP0017_InventoryRaw.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0017_InventoryRaw.InitSpread ACT:) |
| WK-SSP0017-0123 | X-ROW | SSP0017_InventoryRaw.InitSpreadFooterSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.InitSpreadFooterSum: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0017_InventoryRaw.InitSpreadFoote) |
| WK-SSP0017-0124 | X-ROW | SSP0017_InventoryRaw.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.SetChangedControl: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SSP0017_InventoryRaw.SetChangedContr) |
| WK-SSP0017-0125 | X-ROW | SSP0017_InventoryRaw.SpdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0017_InventoryRaw.SpdMain_TopChan) |
| WK-SSP0017-0126 | X-ROW | SSP0017_InventoryRaw.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0017_InventoryRaw.btnItemId_Click) |
| WK-SSP0017-0127 | X-ROW | SSP0017_InventoryRaw.btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.btnMeasure_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0017_InventoryRaw.btnMeasure_Clic) |
| WK-SSP0017-0128 | X-ROW | SSP0017_InventoryRaw.clbDivision_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0017_InventoryRaw.clbDivision_SelectedIndexChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0017_InventoryRaw.clbDivision_Sel) |
| WK-SSP0017-0129 | X-ROW | `usrButton1`(미배선 죽은 컨트롤) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `usrButton1`(미배선 죽은 컨트롤): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`usrButton1`(미배선 죽은 컨트롤)) |

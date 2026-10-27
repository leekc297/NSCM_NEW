# 작업 원장 — SCP0097 · 2026-10-26 12:54

> 검사 인스턴스 296건 중 PASS·NA 115건 외 **181건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 33 | 구현 위치 실존 |
| W4 | 검사기 구현 | 2 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 11 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 39 | 실행 → PASS |
| W7 | 기대값 확정 | 96 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 92 · E2E 39 · 대조표 37 · 하네스 13
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 33 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 27 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| D1 | EDIT |  |  |  |  |  | 5 | 12 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 5 | 12 |  |  | 행 값 기반 조건부 잠금 |
| G1 | GEN |  |  |  |  |  | 3 | 11 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 14 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| E4 | EDIT |  |  |  |  |  | 6 | 6 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| B3 | COMBO |  |  |  | 2 |  |  | 2 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 2 |  | 2 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| F4 | DB |  |  |  |  |  | 2 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| D5 | EDIT |  |  |  |  |  | 2 | 2 |  |  | 셀 에디터 유형 |
| X-REASON | DESIGN |  |  |  |  |  |  | 4 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B1 | COMBO |  |  |  |  | 2 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 2 |  |  |  |  | 콤보 후보 중복 없음 |
| E5 | EDIT |  |  |  |  | 2 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| C1 | CASCADE |  |  |  |  |  | 1 | 1 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| A6 | GEN |  |  |  |  |  | 1 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| G4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 표시·라벨·활성 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| G6 | GEN |  |  |  |  |  | 1 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (33)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0097-0001 | X-LOC | (R5) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((R5)) |
| WK-SCP0097-0002 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SCP0097-0003 | X-LOC | ClbDivision_SelectedIndexChanged | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ClbDivision_SelectedIndexChanged) |
| WK-SCP0097-0004 | X-LOC | DeleteButton (부재) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DeleteButton (부재)) |
| WK-SCP0097-0005 | X-LOC | EditButton (cs:241) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton (cs:241)) |
| WK-SCP0097-0006 | X-LOC | FindButton (cs:220) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton (cs:220)) |
| WK-SCP0097-0007 | X-LOC | InsertButton (부재) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (InsertButton (부재)) |
| WK-SCP0097-0008 | X-LOC | P_DEBUG_MODE='F'(cs:309) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P_DEBUG_MODE='F'(cs:309)) |
| WK-SCP0097-0009 | X-LOC | SaveButton (cs:231) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton (cs:231)) |
| WK-SCP0097-0010 | X-LOC | `Data.Common(Type.MyDivision, false, Now | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`Data.Common(Type.MyDivision, false, Now) |
| WK-SCP0097-0011 | X-LOC | `SelectCombo(cboDivision,"CODE","81")`(c | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SelectCombo(cboDivision,"CODE","81")`(c) |
| WK-SCP0097-0012 | X-LOC | `V1` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`V1`) |
| WK-SCP0097-0013 | X-LOC | `W10` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`W10`) |
| WK-SCP0097-0014 | X-LOC | `W11` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`W11`) |
| WK-SCP0097-0015 | X-LOC | `W12` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`W12`) |
| WK-SCP0097-0016 | X-LOC | `W13` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`W13`) |
| WK-SCP0097-0017 | X-LOC | `W1` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`W1`) |
| WK-SCP0097-0018 | X-LOC | `W2` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`W2`) |
| WK-SCP0097-0019 | X-LOC | `W3` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`W3`) |
| WK-SCP0097-0020 | X-LOC | `W4` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`W4`) |
| WK-SCP0097-0021 | X-LOC | `W5` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`W5`) |
| WK-SCP0097-0022 | X-LOC | `W6` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`W6`) |
| WK-SCP0097-0023 | X-LOC | `W7` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`W7`) |
| WK-SCP0097-0024 | X-LOC | `W8` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`W8`) |
| WK-SCP0097-0025 | X-LOC | `W9` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`W9`) |
| WK-SCP0097-0026 | X-LOC | dsdmMain.Changed → SpdMain_Changed | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (dsdmMain.Changed → SpdMain_Changed) |
| WK-SCP0097-0027 | X-LOC | spdMain.ActiveSheetChanged | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain.ActiveSheetChanged) |
| WK-SCP0097-0028 | X-LOC | spdMain.CellClick | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain.CellClick) |
| WK-SCP0097-0029 | X-LOC | spdMain.CellDoubleClick | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain.CellDoubleClick) |
| WK-SCP0097-0030 | X-LOC | spdMain.ClipboardPasted | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain.ClipboardPasted) |
| WK-SCP0097-0031 | X-LOC | spdMain.EditChange | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain.EditChange) |
| WK-SCP0097-0032 | X-LOC | spdMain.TopChange | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain.TopChange) |
| WK-SCP0097-0033 | X-LOC | txtParentID/txtChildID.Text(개행→콤마 UsrMul | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtParentID/txtChildID.Text(개행→콤마 UsrMul) |

## W4 검사기 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0097-0034 | B3 | SCP_YN | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SCP_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0097-0035 | B3 | STOCK_SUM | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 STOCK_SUM | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |

## W5 검사기 연결 (11)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0097-0036 | B1 | SCP_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCP_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0097-0037 | B1 | STOCK_SUM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL STOCK_SUM | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0097-0038 | B2 | SCP_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCP_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0097-0039 | B2 | STOCK_SUM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL STOCK_SUM | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0097-0040 | B4 | SCP_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCP_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0097-0041 | B4 | STOCK_SUM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL STOCK_SUM | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0097-0042 | F2 | SCP0097 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0097 화면 | 판단불가(대상 단위 SCREEN) | 68 (D00-4d-002 MODAL:AlertModal `V2` `V3` `V) |
| WK-SCP0097-0043 | F6 | SCP0097 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0097 화면 | 판단불가(대상 단위 SCREEN) | 61 (`V4` ACT:SCP0097_SCP_BOM_Elec.SaveButton) |
| WK-SCP0097-0044 | E5 | SCP_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL SCP_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0097-0045 | E5 | STOCK_SUM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL STOCK_SUM | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0097-0046 | G03-WIRE | SCP0097 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0097 화면 | 판단불가(대상 단위 SCREEN) | 12 (ACT:SCP0097_SCP_BOM_Elec..ctor ACT:SCP00) |

## W6 검증 실행 (39)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0097-0047 | J2 | SCP0097 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0097 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 28 (D00-3-008 D00-3-010 D00-3-011 D00-3-012 ) |
| WK-SCP0097-0048 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0097_SCP_BOM_Elec.InitControls:11) |
| WK-SCP0097-0049 | G3 | SCP0097 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0097 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (COMMON:UC-02 COMMON:UC-03 COMMON:UC-04 C) |
| WK-SCP0097-0050 | K-SA | SCP0097 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0097 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (COMMON:UC-02 Vf2) |
| WK-SCP0097-0051 | K4 | SCP0097 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0097 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 6 (COMMON:UC-02 COMMON:UC-03 COMMON:UC-04 C) |
| WK-SCP0097-0052 | F1 | SCP0097 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0097 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 69 (D00-4d-002 MODAL:AlertModal `V2` `V3` `V) |
| WK-SCP0097-0053 | F3 | SCP0097 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0097 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 4 (spdMain.ClipboardPasted ACT:SCP0097_SCP_) |
| WK-SCP0097-0054 | F5 | SCP0097 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0097 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (DeleteButton (부재)) |
| WK-SCP0097-0055 | F4 | PKG_SCP0097.P_SCP0097_GET_SCP_BOM_ELEC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0097.P_SCP0097_GET_SCP_BOM_ELEC · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 94 (ACT:SCP0097_SCP_BOM_Elec.FindButton ACT:) |
| WK-SCP0097-0056 | F4 | PKG_SCP0097.P_SCP0097_SAVE_SCP_BOM_ELEC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0097.P_SCP0097_SAVE_SCP_BOM_ELEC · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 60 (ACT:SCP0097_SCP_BOM_Elec.SaveButton ACT:) |
| WK-SCP0097-0057 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0097_SCP_BOM_Elec.DefineProperty ) |
| WK-SCP0097-0058 | H4 | SCP0097 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0097 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 7 (D00-3-001 `W1` spdMain.TopChange ACT:SCP) |
| WK-SCP0097-0059 | I1 | SCP0097 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0097 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 11 (COMMON:UC-02 `V1` `V2` `V3` `V4` Vf2 ACT) |
| WK-SCP0097-0060 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0097_SCP_BOM_Elec.EditButton ACT:) |
| WK-SCP0097-0061 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (`W5` ACT:SCP0097_SCP_BOM_Elec.EditButton) |
| WK-SCP0097-0062 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0097_SCP_BOM_Elec.EditButton:256:) |
| WK-SCP0097-0063 | D1 | SCP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SCP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (D00-3-008 EditButton (cs:241) `W7` ACT:S) |
| WK-SCP0097-0064 | D1 | USAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — USAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (D00-3-006 `W5` ACT:SCP0097_SCP_BOM_Elec.) |
| WK-SCP0097-0065 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0097_SCP_BOM_Elec.EditButton ACT:) |
| WK-SCP0097-0066 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (`W5` ACT:SCP0097_SCP_BOM_Elec.EditButton) |
| WK-SCP0097-0067 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0097_SCP_BOM_Elec.EditButton:256:) |
| WK-SCP0097-0068 | D3 | SCP_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SCP_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (D00-3-008 EditButton (cs:241) `W7` ACT:S) |
| WK-SCP0097-0069 | D3 | USAGE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — USAGE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (D00-3-006 `W5` ACT:SCP0097_SCP_BOM_Elec.) |
| WK-SCP0097-0070 | D5 | SCP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0097-0071 | D5 | STOCK_SUM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — STOCK_SUM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0097-0072 | D6 | SCP0097 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0097 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (InsertButton (부재)) |
| WK-SCP0097-0073 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (`V2` ACT:SCP0097_SCP_BOM_Elec.SaveData_M) |
| WK-SCP0097-0074 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (`V3` ACT:SCP0097_SCP_BOM_Elec.SaveData_M) |
| WK-SCP0097-0075 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (Vf2) |
| WK-SCP0097-0076 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (`V2`) |
| WK-SCP0097-0077 | E4 | MSG00704 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00704 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0097-0078 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 1 (Vf2) |
| WK-SCP0097-0079 | A10 | SCP0097 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0097 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 27 (ACT:SCP0097_SCP_BOM_Elec.DefineProperty ) |
| WK-SCP0097-0080 | A6 | PKG_SCP0097.P_SCP0097_GET_SCP_BOM_ELEC | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0097.P_SCP0097_GET_SCP_BOM_ELEC · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 36 (ACT:SCP0097_SCP_BOM_Elec.FindButton ACT:) |
| WK-SCP0097-0081 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (Vf2 ACT:SCP0097_SCP_BOM_Elec.FindData_Ma) |
| WK-SCP0097-0082 | G1 | txtChildID / Child Item / Child ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtChildID / Child Item / Child ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0097_SCP_BOM_Elec.FindData_Main A) |
| WK-SCP0097-0083 | G1 | txtParentID / Parent Item / Parent ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtParentID / Parent Item / Parent ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0097_SCP_BOM_Elec.FindData_Main A) |
| WK-SCP0097-0084 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SCP0097_SCP_BOM_Elec.DefineProperty ) |
| WK-SCP0097-0085 | X-REOPEN | SCP0097 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0097 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 6 (ACT:SCP0097_SCP_BOM_Elec.Dispose ACT:SCP) |

## W7 기대값 확정 (96)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0097-0086 | C1 | ClbDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — ClbDivision_SelectedIndexChanged: 행 집계 — C1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ClbDivision_SelectedIndexChanged) |
| WK-SCP0097-0087 | B3 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-001: 행 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0097-0088 | B3 | `Data.Common(Type.MyDivision, false, Now | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `Data.Common(Type.MyDivision, false, NowGroupID, U: 행 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(Type.MyDivision, false, Now) |
| WK-SCP0097-0089 | B4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-001: 행 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0097-0090 | B4 | `Data.Common(Type.MyDivision, false, Now | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `Data.Common(Type.MyDivision, false, NowGroupID, U: 행 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(Type.MyDivision, false, Now) |
| WK-SCP0097-0091 | F4 | `V1` | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `V1`: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`V1`) |
| WK-SCP0097-0092 | F4 | `V4` | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `V4`: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`V4`) |
| WK-SCP0097-0093 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터 유지 신규행 Insert (keepRowVisibleUnderFilter)  INSERT NO-OP(design 01 R4 — base 빈 본문). 신규행 추가 경로 자체 |  | 1 (COMMON:UC-01) |
| WK-SCP0097-0094 | X-REASON | D00-3-002 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-002 W2 ChangeActiveSheet(cs:185) InitSpread  단일 그리드로 소멸 — Except 시트 미구현(design 01 R5), 활성시트 전환 개념 없음 해당없음 |  | 1 (D00-3-002) |
| WK-SCP0097-0095 | X-REASON | D00-3-004 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-004 R5 VisibleTab(cs:196) 시트탭  단일 DataGrid — 시트탭 UI 없음(단일 시트 SCP BOM Elec) 해당없음 |  | 1 (D00-3-004) |
| WK-SCP0097-0096 | X-REASON | D00-3-014 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-014 W13 ChangeActiveSheet(cs:497) ActiveSheetChanged shtMain 재동기  단일 시트로 소멸 — 활성시트 전환 없음 해당없음 |  | 1 (D00-3-014) |
| WK-SCP0097-0097 | D1 | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-007: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-007) |
| WK-SCP0097-0098 | D1 | D00-3-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-009: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-009) |
| WK-SCP0097-0099 | D1 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-011: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-SCP0097-0100 | D1 | D00-4d-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-004: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-004) |
| WK-SCP0097-0101 | D1 | SCP0097_SCP_BOM_Elec.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0097_SCP_BOM_Elec.EditButton: 진입점 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0097_SCP_BOM_Elec.EditButton:246:) |
| WK-SCP0097-0102 | D1 | SaveButton (cs:231) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SaveButton (cs:231): 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton (cs:231)) |
| WK-SCP0097-0103 | D1 | `W10` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `W10`: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`W10`) |
| WK-SCP0097-0104 | D1 | `W12` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `W12`: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`W12`) |
| WK-SCP0097-0105 | D1 | `W4` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `W4`: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`W4`) |
| WK-SCP0097-0106 | D1 | `W6` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `W6`: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`W6`) |
| WK-SCP0097-0107 | D1 | `W8` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `W8`: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`W8`) |
| WK-SCP0097-0108 | D1 | spdMain.CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — spdMain.CellDoubleClick: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spdMain.CellDoubleClick) |
| WK-SCP0097-0109 | D3 | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-007: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-007) |
| WK-SCP0097-0110 | D3 | D00-3-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-009: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-009) |
| WK-SCP0097-0111 | D3 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-011: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-SCP0097-0112 | D3 | D00-4d-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-004: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-004) |
| WK-SCP0097-0113 | D3 | SCP0097_SCP_BOM_Elec.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0097_SCP_BOM_Elec.EditButton: 진입점 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0097_SCP_BOM_Elec.EditButton:246:) |
| WK-SCP0097-0114 | D3 | SaveButton (cs:231) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SaveButton (cs:231): 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton (cs:231)) |
| WK-SCP0097-0115 | D3 | `W10` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `W10`: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`W10`) |
| WK-SCP0097-0116 | D3 | `W12` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `W12`: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`W12`) |
| WK-SCP0097-0117 | D3 | `W4` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `W4`: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`W4`) |
| WK-SCP0097-0118 | D3 | `W6` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `W6`: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`W6`) |
| WK-SCP0097-0119 | D3 | `W8` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `W8`: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`W8`) |
| WK-SCP0097-0120 | D3 | spdMain.CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — spdMain.CellDoubleClick: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spdMain.CellDoubleClick) |
| WK-SCP0097-0121 | D5 | SCP0097_SCP_BOM_Elec.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0097_SCP_BOM_Elec.CreateSpread: 진입점 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0097_SCP_BOM_Elec.CreateSpread:17) |
| WK-SCP0097-0122 | D5 | SCP0097_SCP_BOM_Elec.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0097_SCP_BOM_Elec.SetSpreadInit: 진입점 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0097_SCP_BOM_Elec.SetSpreadInit:1) |
| WK-SCP0097-0123 | E4 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-002: 행 집계 — E4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SCP0097-0124 | E4 | FindButton (cs:220) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — FindButton (cs:220): 행 집계 — E4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (FindButton (cs:220)) |
| WK-SCP0097-0125 | E4 | SCP0097_SCP_BOM_Elec.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0097_SCP_BOM_Elec.SetSpreadInit: 진입점 집계 — E4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0097_SCP_BOM_Elec.SetSpreadInit:1) |
| WK-SCP0097-0126 | E4 | Vf3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — Vf3: 행 집계 — E4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Vf3) |
| WK-SCP0097-0127 | E4 | `V1` | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `V1`: 행 집계 — E4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (`V1`) |
| WK-SCP0097-0128 | E4 | `V4` | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `V4`: 행 집계 — E4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (`V4`) |
| WK-SCP0097-0129 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0097-0130 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-03) |
| WK-SCP0097-0131 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-06) |
| WK-SCP0097-0132 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0097-0133 | A1 | D00-3-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-010: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-3-010) |
| WK-SCP0097-0134 | A1 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-011: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-3-011) |
| WK-SCP0097-0135 | A1 | D00-3-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-012: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-3-012) |
| WK-SCP0097-0136 | A1 | FindButton (cs:220) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton (cs:220): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (FindButton (cs:220)) |
| WK-SCP0097-0137 | A1 | PKG_SCP0097.P_SCP0097_GET_SCP_BOM_ELEC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0097.P_SCP0097_GET_SCP_BOM_ELEC: 골든 비교 케이스 없음(PKG_SCP0097.P_SCP0097_GET_SCP_BOM_ELEC — 팝업·보조 SP 는 golden_cases. |  | 36 (ACT:SCP0097_SCP_BOM_Elec.FindButton ACT:) |
| WK-SCP0097-0138 | A1 | Vf2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Vf2: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (Vf2) |
| WK-SCP0097-0139 | A1 | `V1` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `V1`: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`V1`) |
| WK-SCP0097-0140 | A1 | `V2` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `V2`: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`V2`) |
| WK-SCP0097-0141 | A1 | `W10` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `W10`: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`W10`) |
| WK-SCP0097-0142 | A1 | `W11` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `W11`: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`W11`) |
| WK-SCP0097-0143 | A6 | `V1` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — `V1`: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`V1`) |
| WK-SCP0097-0144 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0097-0145 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0097-0146 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0097-0147 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0097-0148 | G1 | D00-3-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-010: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-010) |
| WK-SCP0097-0149 | G1 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-011: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-SCP0097-0150 | G1 | D00-3-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-012: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-012) |
| WK-SCP0097-0151 | G1 | FindButton (cs:220) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton (cs:220): 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (FindButton (cs:220)) |
| WK-SCP0097-0152 | G1 | `V2` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `V2`: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`V2`) |
| WK-SCP0097-0153 | G1 | `W10` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `W10`: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`W10`) |
| WK-SCP0097-0154 | G1 | `W11` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `W11`: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`W11`) |
| WK-SCP0097-0155 | X-ROW | SCP0097_SCP_BOM_Elec.CheckScpYN | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.CheckScpYN: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/EXPR/GRID_SET/LOCAL/RETURN, 연결된  |  | 29 (ACT:SCP0097_SCP_BOM_Elec.CheckScpYN ACT:) |
| WK-SCP0097-0156 | X-ROW | SCP0097_SCP_BOM_Elec.ClbDivision_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.ClbDivision_SelectedIndexChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0097_SCP_BOM_Elec.ClbDivision_Sel) |
| WK-SCP0097-0157 | X-ROW | SCP0097_SCP_BOM_Elec.ClearUsrCheckedList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된 요소 검사 |  | 4 (ACT:SCP0097_SCP_BOM_Elec.ClearUsrChecked) |
| WK-SCP0097-0158 | X-ROW | SCP0097_SCP_BOM_Elec.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0097_SCP_BOM_Elec.CreateSpread) |
| WK-SCP0097-0159 | X-ROW | SCP0097_SCP_BOM_Elec.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.EditButton: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:2 |  | 2 (ACT:SCP0097_SCP_BOM_Elec.EditButton:266:) |
| WK-SCP0097-0160 | X-ROW | SCP0097_SCP_BOM_Elec.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0097_SCP_BOM_Elec.FindButton) |
| WK-SCP0097-0161 | X-ROW | SCP0097_SCP_BOM_Elec.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.FindData_Main: 진입점 집계 9검사 — NOT_RUN:7 · REVIEW:1 · PASS:1 |  | 9 (ACT:SCP0097_SCP_BOM_Elec.FindData_Main:2) |
| WK-SCP0097-0162 | X-ROW | SCP0097_SCP_BOM_Elec.Find_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.Find_Data: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0097_SCP_BOM_Elec.Find_Data ACT:S) |
| WK-SCP0097-0163 | X-ROW | SCP0097_SCP_BOM_Elec.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0097_SCP_BOM_Elec.Form_Load) |
| WK-SCP0097-0164 | X-ROW | SCP0097_SCP_BOM_Elec.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0097_SCP_BOM_Elec.InitControls:11) |
| WK-SCP0097-0165 | X-ROW | SCP0097_SCP_BOM_Elec.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0097_SCP_BOM_Elec.InitSpread) |
| WK-SCP0097-0166 | X-ROW | SCP0097_SCP_BOM_Elec.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0097_SCP_BOM_Elec.OnShown ACT:SCP) |
| WK-SCP0097-0167 | X-ROW | SCP0097_SCP_BOM_Elec.SaveData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.SaveData_Main: 진입점 집계 11검사 — NOT_RUN:7 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0097_SCP_BOM_Elec.SaveData_Main:3) |
| WK-SCP0097-0168 | X-ROW | SCP0097_SCP_BOM_Elec.SelectCombo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.SelectCombo: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/FLOW/LOCAL/VALUE_SET, 연결된 요소 검사 없음 |  | 10 (ACT:SCP0097_SCP_BOM_Elec.SelectCombo ACT) |
| WK-SCP0097-0169 | X-ROW | SCP0097_SCP_BOM_Elec.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.SetSpreadInit: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0097_SCP_BOM_Elec.SetSpreadInit) |
| WK-SCP0097-0170 | X-ROW | SCP0097_SCP_BOM_Elec.ShowMessage | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.ShowMessage: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0097_SCP_BOM_Elec.ShowMessage ACT) |
| WK-SCP0097-0171 | X-ROW | SCP0097_SCP_BOM_Elec.SpdMain_ActiveSheet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.SpdMain_ActiveSheetChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0097_SCP_BOM_Elec.SpdMain_ActiveS) |
| WK-SCP0097-0172 | X-ROW | SCP0097_SCP_BOM_Elec.SpdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.SpdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0097_SCP_BOM_Elec.SpdMain_CellCli) |
| WK-SCP0097-0173 | X-ROW | SCP0097_SCP_BOM_Elec.SpdMain_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0097_SCP_BOM_Elec.SpdMain_CellDou) |
| WK-SCP0097-0174 | X-ROW | SCP0097_SCP_BOM_Elec.SpdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.SpdMain_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0097_SCP_BOM_Elec.SpdMain_Changed) |
| WK-SCP0097-0175 | X-ROW | SCP0097_SCP_BOM_Elec.SpdMain_ClipboardPa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.SpdMain_ClipboardPasted: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0097_SCP_BOM_Elec.SpdMain_Clipboa) |
| WK-SCP0097-0176 | X-ROW | SCP0097_SCP_BOM_Elec.SpdMain_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.SpdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/EXPR/FLAG, 연결된 요소 검사 없음 |  | 6 (ACT:SCP0097_SCP_BOM_Elec.SpdMain_EditCha) |
| WK-SCP0097-0177 | X-ROW | SCP0097_SCP_BOM_Elec.SpdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0097_SCP_BOM_Elec.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0097_SCP_BOM_Elec.SpdMain_TopChan) |
| WK-SCP0097-0178 | X-ROW | `W9` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `W9`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`W9`) |
| WK-SCP0097-0179 | X-ROW | spdMain.CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — spdMain.CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (spdMain.CellClick) |
| WK-SCP0097-0180 | X-ROW | spdMain.EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — spdMain.EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (spdMain.EditChange) |
| WK-SCP0097-0181 | X-ROW | txtParentID/txtChildID.Text(개행→콤마 UsrMul | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — txtParentID/txtChildID.Text(개행→콤마 UsrMultiLineEdit: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (txtParentID/txtChildID.Text(개행→콤마 UsrMul) |

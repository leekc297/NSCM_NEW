# 작업 원장 — SCP0084 · 2026-10-26 12:54

> 검사 인스턴스 197건 중 PASS·NA 21건 외 **176건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 22 | 구현 위치 실존 |
| W4 | 검사기 구현 | 1 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 5 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 51 | 실행 → PASS |
| W7 | 기대값 확정 | 97 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 97 · E2E 51 · 대조표 22 · 하네스 6
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 22 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 11 | 5 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-ROW | GEN |  |  |  |  |  |  | 16 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A5 | DESIGN |  |  |  |  |  | 3 | 10 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 3 | 10 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 3 | 10 |  |  | 라벨 명칭 |
| A1 | GEN |  |  |  |  |  |  | 10 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 3 | 6 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| D1 | EDIT |  |  |  |  |  | 1 | 7 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 1 | 7 |  |  | 행 값 기반 조건부 잠금 |
| G4 | DESIGN |  |  |  |  |  | 3 | 4 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 3 | 4 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F4 | DB |  |  |  |  |  | 3 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| B3 | COMBO |  |  |  | 1 |  |  | 2 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 1 |  | 2 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| DB-SYN | DB |  |  |  |  | 1 |  | 2 |  |  | BE 계정 시노님·권한·대상 객체 |
| C1 | CASCADE |  |  |  |  |  | 3 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| H3 | DESIGN |  |  |  |  |  | 2 |  |  |  | 셀 병합 = AS-IS |
| A6 | GEN |  |  |  |  |  | 2 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0084-0001 | X-LOC | **EditButton 노출** | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (**EditButton 노출**) |
| WK-SCP0084-0002 | X-LOC | Edit 가드 Action(String) 컬럼 hidden (R6) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Edit 가드 Action(String) 컬럼 hidden (R6)) |
| WK-SCP0084-0003 | X-LOC | Edit 가드 RowCount==0 (R5) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Edit 가드 RowCount==0 (R5)) |
| WK-SCP0084-0004 | X-LOC | Edit 가드 fps==null (R4) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Edit 가드 fps==null (R4)) |
| WK-SCP0084-0005 | X-LOC | EditButton → SwitchLock + LockRange (MEM | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton → SwitchLock + LockRange (MEM) |
| WK-SCP0084-0006 | X-LOC | ExcelButton + MSG00100 confirm (R9) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ExcelButton + MSG00100 confirm (R9)) |
| WK-SCP0084-0007 | X-LOC | FIXED_FLAG=Y (ITEM_UOM) 틀고정 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FIXED_FLAG=Y (ITEM_UOM) 틀고정) |
| WK-SCP0084-0008 | X-LOC | GetCheckedListValue → CSV 조립 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (GetCheckedListValue → CSV 조립) |
| WK-SCP0084-0009 | X-LOC | ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0010 | X-LOC | SaveData_Memo (I/M/D 행, 6키+MEMO) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0011 | X-LOC | SetDivisionAuthCheck (권한0행) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetDivisionAuthCheck (권한0행)) |
| WK-SCP0084-0012 | X-LOC | SetSheetHeaderColumn + ColumnHeaderHeigh | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetSheetHeaderColumn + ColumnHeaderHeigh) |
| WK-SCP0084-0013 | X-LOC | SmartColMerge (W2/W5) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SmartColMerge (W2/W5)) |
| WK-SCP0084-0014 | X-LOC | cboDivision (Division, 다중) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboDivision (Division, 다중)) |
| WK-SCP0084-0015 | X-LOC | cboLongTermType (다중) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboLongTermType (다중)) |
| WK-SCP0084-0016 | X-LOC | cellclipboardPast=false (R7) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cellclipboardPast=false (R7)) |
| WK-SCP0084-0017 | X-LOC | checkRequiredOfSearch | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (checkRequiredOfSearch) |
| WK-SCP0084-0018 | X-LOC | clbPlant (Plant, 다중, cascade) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbPlant (Plant, 다중, cascade)) |
| WK-SCP0084-0019 | X-LOC | monthPicker (Month, 단일) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (monthPicker (Month, 단일)) |
| WK-SCP0084-0020 | X-LOC | siMain.Query(ds) 컬럼명 바인딩 (W3) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (siMain.Query(ds) 컬럼명 바인딩 (W3)) |
| WK-SCP0084-0021 | X-LOC | 조회 후 전 컬럼 Lock (R2, W4) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0022 | X-LOC | 통화 파생(SP CASE) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (통화 파생(SP CASE)) |

## W4 검사기 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0084-0023 | B3 | cboLongTermType / Long Term Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboLongTermType / Long Term Type | 있음(FE 소스) | 1 (cboLongTermType (다중)) |

## W5 검사기 연결 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0084-0024 | B4 | cboLongTermType / Long Term Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboLongTermType / Long Term Type | 있음(FE 소스) | 1 (cboLongTermType (다중)) |
| WK-SCP0084-0025 | F2 | SCP0084 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0084 화면 | 판단불가(대상 단위 SCREEN) | 79 (**EditButton 노출** SetSheetHeaderColumn +) |
| WK-SCP0084-0026 | F6 | SCP0084 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0084 화면 | 판단불가(대상 단위 SCREEN) | 71 (SaveData_Memo (I/M/D 행, 6키+MEMO) ACT:SCP) |
| WK-SCP0084-0027 | DB-SYN | SCP0084_GET_MONTH_RANGE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0084_GET_MONTH_RANGE | 없음(PROC_M 대응 없음) | 2 (monthPicker (Month, 단일) ACT:SCP0084_Long) |
| WK-SCP0084-0028 | G03-WIRE | SCP0084 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0084 화면 | 판단불가(대상 단위 SCREEN) | 5 (ACT:SCP0084_LongTermStock..ctor ACT:SCP0) |

## W6 검증 실행 (51)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0084-0029 | J2 | SCP0084 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0084 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 22 (monthPicker (Month, 단일) cboDivision (Div) |
| WK-SCP0084-0030 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0084_LongTermStock.InitControls:1) |
| WK-SCP0084-0031 | C1 | cboLongTermType / Long Term Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboLongTermType / Long Term Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0084_LongTermStock.InitControls:1) |
| WK-SCP0084-0032 | C1 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0084_LongTermStock.SetChangedCont) |
| WK-SCP0084-0033 | G3 | SCP0084 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0084 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 1 (SetDivisionAuthCheck (권한0행)) |
| WK-SCP0084-0034 | K-SA | SCP0084 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0084 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (SetDivisionAuthCheck (권한0행)) |
| WK-SCP0084-0035 | F1 | SCP0084 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0084 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 79 (**EditButton 노출** SetSheetHeaderColumn +) |
| WK-SCP0084-0036 | F3 | SCP0084 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0084 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 1 (cellclipboardPast=false (R7)) |
| WK-SCP0084-0037 | F4 | PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOCK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 73 (ACT:SCP0084_LongTermStock.FindButton ACT) |
| WK-SCP0084-0038 | F4 | PKG_SCP0084.P_SCP0084_SAVE_LONG_TERM_STO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0084.P_SCP0084_SAVE_LONG_TERM_STOCK_MEMO_RO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 70 (ACT:SCP0084_LongTermStock.SaveButton ACT) |
| WK-SCP0084-0039 | F4 | SCP0084_GET_MONTH_RANGE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0084_GET_MONTH_RANGE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (monthPicker (Month, 단일) ACT:SCP0084_Long) |
| WK-SCP0084-0040 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (SmartColMerge (W2/W5)) |
| WK-SCP0084-0041 | A5 | MEMO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MEMO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0042 | A5 | PLANT_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (SmartColMerge (W2/W5)) |
| WK-SCP0084-0043 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (cboDivision (Division, 다중) ACT:SCP0084_L) |
| WK-SCP0084-0044 | G4 | cboLongTermType / Long Term Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboLongTermType / Long Term Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (cboLongTermType (다중) ACT:SCP0084_LongTer) |
| WK-SCP0084-0045 | G4 | clbPlant / Plant | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlant / Plant · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (clbPlant (Plant, 다중, cascade)) |
| WK-SCP0084-0046 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SmartColMerge (W2/W5)) |
| WK-SCP0084-0047 | H2 | MEMO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEMO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0048 | H2 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SmartColMerge (W2/W5)) |
| WK-SCP0084-0049 | H3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (SmartColMerge (W2/W5)) |
| WK-SCP0084-0050 | H3 | PLANT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — PLANT_ID · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (SmartColMerge (W2/W5)) |
| WK-SCP0084-0051 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (SmartColMerge (W2/W5)) |
| WK-SCP0084-0052 | H5 | MEMO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MEMO · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0053 | H5 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PLANT_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (SmartColMerge (W2/W5)) |
| WK-SCP0084-0054 | I1 | SCP0084 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0084 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 10 (SetDivisionAuthCheck (권한0행) SaveData_Mem) |
| WK-SCP0084-0055 | SC1 | SCP0084 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0084 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 7 (monthPicker (Month, 단일) cboDivision (Div) |
| WK-SCP0084-0056 | D1 | MEMO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEMO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (EditButton → SwitchLock + LockRange (MEM) |
| WK-SCP0084-0057 | D3 | MEMO | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEMO · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (EditButton → SwitchLock + LockRange (MEM) |
| WK-SCP0084-0058 | D6 | SCP0084 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0084 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0059 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (SmartColMerge (W2/W5)) |
| WK-SCP0084-0060 | E4 | MEMO | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEMO · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0061 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0062 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (SaveData_Memo (I/M/D 행, 6키+MEMO) ACT:SCP) |
| WK-SCP0084-0063 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (SaveData_Memo (I/M/D 행, 6키+MEMO) ACT:SCP) |
| WK-SCP0084-0064 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (SetDivisionAuthCheck (권한0행)) |
| WK-SCP0084-0065 | E4 | MSG00100 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00100 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ExcelButton + MSG00100 confirm (R9) ACT:) |
| WK-SCP0084-0066 | E4 | MSG00719 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00719 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ExcelButton + MSG00100 confirm (R9)) |
| WK-SCP0084-0067 | E4 | PLANT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (SmartColMerge (W2/W5)) |
| WK-SCP0084-0068 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SCP0084_LongTermStock.SetChangedCont) |
| WK-SCP0084-0069 | E4 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0084_LongTermStock.SetChangedCont) |
| WK-SCP0084-0070 | A10 | SCP0084 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0084 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 36 (ACT:SCP0084_LongTermStock.Form_Load ACT:) |
| WK-SCP0084-0071 | A6 | PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOC | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOCK · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 2 (ACT:SCP0084_LongTermStock.FindButton ACT) |
| WK-SCP0084-0072 | A6 | SCP0084_GET_MONTH_RANGE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0084_GET_MONTH_RANGE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tr |  | 1 (monthPicker (Month, 단일)) |
| WK-SCP0084-0073 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (cboDivision (Division, 다중)) |
| WK-SCP0084-0074 | G1 | cboLongTermType / Long Term Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboLongTermType / Long Term Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (cboLongTermType (다중)) |
| WK-SCP0084-0075 | G1 | clbPlant / Plant | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlant / Plant · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (clbPlant (Plant, 다중, cascade)) |
| WK-SCP0084-0076 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboDivision (Division, 다중) ACT:SCP0084_L) |
| WK-SCP0084-0077 | G6 | cboLongTermType / Long Term Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboLongTermType / Long Term Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (cboLongTermType (다중) ACT:SCP0084_LongTer) |
| WK-SCP0084-0078 | G6 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (clbPlant (Plant, 다중, cascade)) |
| WK-SCP0084-0079 | X-REOPEN | SCP0084 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0084 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 8 (ACT:SCP0084_LongTermStock.Dispose ACT:SC) |

## W7 기대값 확정 (97)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0084-0080 | B3 | ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1~12 등): 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0081 | B3 | SCP0084_LongTermStock.GetMonthRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0084_LongTermStock.GetMonthRange: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0084_LongTermStock.GetMonthRange:) |
| WK-SCP0084-0082 | B4 | ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1~12 등): 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0083 | B4 | SCP0084_LongTermStock.GetMonthRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0084_LongTermStock.GetMonthRange: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0084_LongTermStock.GetMonthRange:) |
| WK-SCP0084-0084 | DB-SYN | SCP0084_LongTermStock.SCM_SYS_LOG_BATCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0084_LongTermStock.SCM_SYS_LOG_BATCH: 진입점 집계 — DB-SYN 3요소: PASS:2 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0084_LongTermStock.SCM_SYS_LOG_BA) |
| WK-SCP0084-0085 | DB-SYN | SaveData_Memo (I/M/D 행, 6키+MEMO) | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SaveData_Memo (I/M/D 행, 6키+MEMO): 행 집계 — DB-SYN 3요소: PASS:2 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0086 | F4 | SCP0084_LongTermStock.SCM_SYS_LOG_BATCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0084_LongTermStock.SCM_SYS_LOG_BATCH: 진입점 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0084_LongTermStock.SCM_SYS_LOG_BA) |
| WK-SCP0084-0087 | F4 | SaveData_Memo (I/M/D 행, 6키+MEMO) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SaveData_Memo (I/M/D 행, 6키+MEMO): 행 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0088 | A5 | Edit 가드 Action(String) 컬럼 hidden (R6) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Edit 가드 Action(String) 컬럼 hidden (R6): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Edit 가드 Action(String) 컬럼 hidden (R6)) |
| WK-SCP0084-0089 | A5 | ExcelButton + MSG00100 confirm (R9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — ExcelButton + MSG00100 confirm (R9): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ExcelButton + MSG00100 confirm (R9)) |
| WK-SCP0084-0090 | A5 | FIXED_FLAG=Y (ITEM_UOM) 틀고정 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — FIXED_FLAG=Y (ITEM_UOM) 틀고정: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (FIXED_FLAG=Y (ITEM_UOM) 틀고정) |
| WK-SCP0084-0091 | A5 | ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1~12 등): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0092 | A5 | SCP0084_LongTermStock.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0084_LongTermStock.CreateSpread: 진입점 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0084_LongTermStock.CreateSpread:1) |
| WK-SCP0084-0093 | A5 | SCP0084_LongTermStock.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0084_LongTermStock.SetSpreadInit: 진입점 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0084_LongTermStock.SetSpreadInit:) |
| WK-SCP0084-0094 | A5 | SetSheetHeaderColumn + ColumnHeaderHeigh | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SetSheetHeaderColumn + ColumnHeaderHeight(0,50) 다단: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SetSheetHeaderColumn + ColumnHeaderHeigh) |
| WK-SCP0084-0095 | A5 | siMain.Query(ds) 컬럼명 바인딩 (W3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — siMain.Query(ds) 컬럼명 바인딩 (W3): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (siMain.Query(ds) 컬럼명 바인딩 (W3)) |
| WK-SCP0084-0096 | A5 | 조회 후 전 컬럼 Lock (R2, W4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 조회 후 전 컬럼 Lock (R2, W4): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0097 | A5 | 통화 파생(SP CASE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 통화 파생(SP CASE): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (통화 파생(SP CASE)) |
| WK-SCP0084-0098 | G4 | GetCheckedListValue → CSV 조립 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — GetCheckedListValue → CSV 조립: 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (GetCheckedListValue → CSV 조립) |
| WK-SCP0084-0099 | G4 | SetDivisionAuthCheck (권한0행) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — SetDivisionAuthCheck (권한0행): 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SetDivisionAuthCheck (권한0행)) |
| WK-SCP0084-0100 | G4 | checkRequiredOfSearch | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — checkRequiredOfSearch: 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSearch) |
| WK-SCP0084-0101 | G4 | monthPicker (Month, 단일) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — monthPicker (Month, 단일): 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (monthPicker (Month, 단일)) |
| WK-SCP0084-0102 | H2 | Edit 가드 Action(String) 컬럼 hidden (R6) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Edit 가드 Action(String) 컬럼 hidden (R6): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Edit 가드 Action(String) 컬럼 hidden (R6)) |
| WK-SCP0084-0103 | H2 | ExcelButton + MSG00100 confirm (R9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — ExcelButton + MSG00100 confirm (R9): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ExcelButton + MSG00100 confirm (R9)) |
| WK-SCP0084-0104 | H2 | FIXED_FLAG=Y (ITEM_UOM) 틀고정 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — FIXED_FLAG=Y (ITEM_UOM) 틀고정: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (FIXED_FLAG=Y (ITEM_UOM) 틀고정) |
| WK-SCP0084-0105 | H2 | ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1~12 등): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0106 | H2 | SCP0084_LongTermStock.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0084_LongTermStock.CreateSpread: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0084_LongTermStock.CreateSpread:1) |
| WK-SCP0084-0107 | H2 | SCP0084_LongTermStock.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0084_LongTermStock.SetSpreadInit: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0084_LongTermStock.SetSpreadInit:) |
| WK-SCP0084-0108 | H2 | SetSheetHeaderColumn + ColumnHeaderHeigh | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SetSheetHeaderColumn + ColumnHeaderHeight(0,50) 다단: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SetSheetHeaderColumn + ColumnHeaderHeigh) |
| WK-SCP0084-0109 | H2 | siMain.Query(ds) 컬럼명 바인딩 (W3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — siMain.Query(ds) 컬럼명 바인딩 (W3): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (siMain.Query(ds) 컬럼명 바인딩 (W3)) |
| WK-SCP0084-0110 | H2 | 조회 후 전 컬럼 Lock (R2, W4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 조회 후 전 컬럼 Lock (R2, W4): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0111 | H2 | 통화 파생(SP CASE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 통화 파생(SP CASE): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (통화 파생(SP CASE)) |
| WK-SCP0084-0112 | H5 | Edit 가드 Action(String) 컬럼 hidden (R6) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Edit 가드 Action(String) 컬럼 hidden (R6): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Edit 가드 Action(String) 컬럼 hidden (R6)) |
| WK-SCP0084-0113 | H5 | ExcelButton + MSG00100 confirm (R9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — ExcelButton + MSG00100 confirm (R9): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ExcelButton + MSG00100 confirm (R9)) |
| WK-SCP0084-0114 | H5 | FIXED_FLAG=Y (ITEM_UOM) 틀고정 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — FIXED_FLAG=Y (ITEM_UOM) 틀고정: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (FIXED_FLAG=Y (ITEM_UOM) 틀고정) |
| WK-SCP0084-0115 | H5 | ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1~12 등): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0116 | H5 | SCP0084_LongTermStock.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0084_LongTermStock.CreateSpread: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0084_LongTermStock.CreateSpread:1) |
| WK-SCP0084-0117 | H5 | SCP0084_LongTermStock.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0084_LongTermStock.SetSpreadInit: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0084_LongTermStock.SetSpreadInit:) |
| WK-SCP0084-0118 | H5 | SetSheetHeaderColumn + ColumnHeaderHeigh | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SetSheetHeaderColumn + ColumnHeaderHeight(0,50) 다단: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SetSheetHeaderColumn + ColumnHeaderHeigh) |
| WK-SCP0084-0119 | H5 | siMain.Query(ds) 컬럼명 바인딩 (W3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — siMain.Query(ds) 컬럼명 바인딩 (W3): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (siMain.Query(ds) 컬럼명 바인딩 (W3)) |
| WK-SCP0084-0120 | H5 | 조회 후 전 컬럼 Lock (R2, W4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 조회 후 전 컬럼 Lock (R2, W4): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0121 | H5 | 통화 파생(SP CASE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 통화 파생(SP CASE): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (통화 파생(SP CASE)) |
| WK-SCP0084-0122 | D1 | **EditButton 노출** | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — **EditButton 노출**: 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (**EditButton 노출**) |
| WK-SCP0084-0123 | D1 | Edit 가드 Action(String) 컬럼 hidden (R6) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Edit 가드 Action(String) 컬럼 hidden (R6): 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Edit 가드 Action(String) 컬럼 hidden (R6)) |
| WK-SCP0084-0124 | D1 | Edit 가드 RowCount==0 (R5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Edit 가드 RowCount==0 (R5): 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Edit 가드 RowCount==0 (R5)) |
| WK-SCP0084-0125 | D1 | Edit 가드 fps==null (R4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Edit 가드 fps==null (R4): 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Edit 가드 fps==null (R4)) |
| WK-SCP0084-0126 | D1 | SCP0084_LongTermStock.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0084_LongTermStock.EditButton: 진입점 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCP0084_LongTermStock.EditButton:229) |
| WK-SCP0084-0127 | D1 | cellclipboardPast=false (R7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — cellclipboardPast=false (R7): 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (cellclipboardPast=false (R7)) |
| WK-SCP0084-0128 | D1 | 조회 후 전 컬럼 Lock (R2, W4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 조회 후 전 컬럼 Lock (R2, W4): 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0129 | D3 | **EditButton 노출** | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — **EditButton 노출**: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (**EditButton 노출**) |
| WK-SCP0084-0130 | D3 | Edit 가드 Action(String) 컬럼 hidden (R6) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Edit 가드 Action(String) 컬럼 hidden (R6): 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Edit 가드 Action(String) 컬럼 hidden (R6)) |
| WK-SCP0084-0131 | D3 | Edit 가드 RowCount==0 (R5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Edit 가드 RowCount==0 (R5): 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Edit 가드 RowCount==0 (R5)) |
| WK-SCP0084-0132 | D3 | Edit 가드 fps==null (R4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Edit 가드 fps==null (R4): 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Edit 가드 fps==null (R4)) |
| WK-SCP0084-0133 | D3 | SCP0084_LongTermStock.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0084_LongTermStock.EditButton: 진입점 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCP0084_LongTermStock.EditButton:229) |
| WK-SCP0084-0134 | D3 | cellclipboardPast=false (R7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — cellclipboardPast=false (R7): 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (cellclipboardPast=false (R7)) |
| WK-SCP0084-0135 | D3 | 조회 후 전 컬럼 Lock (R2, W4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 조회 후 전 컬럼 Lock (R2, W4): 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0136 | E4 | SCP0084_LongTermStock.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0084_LongTermStock.SetChangedControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0084_LongTermStock.SetChangedCont) |
| WK-SCP0084-0137 | E4 | SCP0084_LongTermStock.SetColumnFooterDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0084_LongTermStock.SetColumnFooterData: 진입점 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0084_LongTermStock.SetColumnFoote) |
| WK-SCP0084-0138 | E4 | SCP0084_LongTermStock.SetMonthRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0084_LongTermStock.SetMonthRange: 진입점 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0084_LongTermStock.SetMonthRange:) |
| WK-SCP0084-0139 | E4 | SCP0084_LongTermStock.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0084_LongTermStock.SetSpreadInit: 진입점 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0084_LongTermStock.SetSpreadInit:) |
| WK-SCP0084-0140 | E4 | checkRequiredOfSearch | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — checkRequiredOfSearch: 행 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSearch) |
| WK-SCP0084-0141 | A1 | GetCheckedListValue → CSV 조립 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — GetCheckedListValue → CSV 조립: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (GetCheckedListValue → CSV 조립) |
| WK-SCP0084-0142 | A1 | PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOCK: 골든 비교 케이스 없음(PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOCK — 팝업·보조 SP 는 golden_ |  | 3 (ACT:SCP0084_LongTermStock.FindButton ACT) |
| WK-SCP0084-0143 | A1 | SCP0084_GET_MONTH_RANGE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0084_GET_MONTH_RANGE: 골든 비교 케이스 없음(SCP0084_GET_MONTH_RANGE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (monthPicker (Month, 단일)) |
| WK-SCP0084-0144 | A1 | SaveData_Memo (I/M/D 행, 6키+MEMO) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SaveData_Memo (I/M/D 행, 6키+MEMO): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0145 | A1 | SetDivisionAuthCheck (권한0행) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SetDivisionAuthCheck (권한0행): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (SetDivisionAuthCheck (권한0행)) |
| WK-SCP0084-0146 | A1 | cboDivision (Division, 다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision (Division, 다중): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (cboDivision (Division, 다중)) |
| WK-SCP0084-0147 | A1 | cboLongTermType (다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboLongTermType (다중): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (cboLongTermType (다중)) |
| WK-SCP0084-0148 | A1 | checkRequiredOfSearch | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — checkRequiredOfSearch: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (checkRequiredOfSearch) |
| WK-SCP0084-0149 | A1 | clbPlant (Plant, 다중, cascade) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbPlant (Plant, 다중, cascade): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (clbPlant (Plant, 다중, cascade)) |
| WK-SCP0084-0150 | A1 | 조회 후 전 컬럼 Lock (R2, W4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회 후 전 컬럼 Lock (R2, W4): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0151 | G1 | GetCheckedListValue → CSV 조립 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — GetCheckedListValue → CSV 조립: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (GetCheckedListValue → CSV 조립) |
| WK-SCP0084-0152 | G1 | SaveData_Memo (I/M/D 행, 6키+MEMO) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SaveData_Memo (I/M/D 행, 6키+MEMO): 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0153 | G1 | SetDivisionAuthCheck (권한0행) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SetDivisionAuthCheck (권한0행): 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SetDivisionAuthCheck (권한0행)) |
| WK-SCP0084-0154 | G1 | checkRequiredOfSearch | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — checkRequiredOfSearch: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSearch) |
| WK-SCP0084-0155 | G1 | monthPicker (Month, 단일) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — monthPicker (Month, 단일): 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (monthPicker (Month, 단일)) |
| WK-SCP0084-0156 | G1 | 조회 후 전 컬럼 Lock (R2, W4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회 후 전 컬럼 Lock (R2, W4): 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0157 | G6 | GetCheckedListValue → CSV 조립 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — GetCheckedListValue → CSV 조립: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (GetCheckedListValue → CSV 조립) |
| WK-SCP0084-0158 | G6 | SetDivisionAuthCheck (권한0행) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — SetDivisionAuthCheck (권한0행): 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SetDivisionAuthCheck (권한0행)) |
| WK-SCP0084-0159 | G6 | checkRequiredOfSearch | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — checkRequiredOfSearch: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSearch) |
| WK-SCP0084-0160 | G6 | monthPicker (Month, 단일) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — monthPicker (Month, 단일): 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (monthPicker (Month, 단일)) |
| WK-SCP0084-0161 | X-ROW | SCP0084_LongTermStock.CboDivision_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.CboDivision_SelectedIndexCha: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0084_LongTermStock.CboDivision_Se) |
| WK-SCP0084-0162 | X-ROW | SCP0084_LongTermStock.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0084_LongTermStock.CreateSpread) |
| WK-SCP0084-0163 | X-ROW | SCP0084_LongTermStock.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.ExcelButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0084_LongTermStock.ExcelButton AC) |
| WK-SCP0084-0164 | X-ROW | SCP0084_LongTermStock.ExportExcelData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.ExportExcelData: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 113 (ACT:SCP0084_LongTermStock.ExportExcelDat) |
| WK-SCP0084-0165 | X-ROW | SCP0084_LongTermStock.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0084_LongTermStock.FindButton) |
| WK-SCP0084-0166 | X-ROW | SCP0084_LongTermStock.Find_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.Find_Data: 진입점 집계 5검사 — NOT_RUN:3 · PASS:1 · REVIEW:1 |  | 36 (ACT:SCP0084_LongTermStock.Find_Data ACT:) |
| WK-SCP0084-0167 | X-ROW | SCP0084_LongTermStock.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0084_LongTermStock.Form_Load) |
| WK-SCP0084-0168 | X-ROW | SCP0084_LongTermStock.GetMonthRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.GetMonthRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0084_LongTermStock.GetMonthRange) |
| WK-SCP0084-0169 | X-ROW | SCP0084_LongTermStock.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0084_LongTermStock.InitControls:1) |
| WK-SCP0084-0170 | X-ROW | SCP0084_LongTermStock.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0084_LongTermStock.InitSpread) |
| WK-SCP0084-0171 | X-ROW | SCP0084_LongTermStock.SCM_SYS_LOG_BATCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.SCM_SYS_LOG_BATCH: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0084_LongTermStock.SCM_SYS_LOG_BA) |
| WK-SCP0084-0172 | X-ROW | SCP0084_LongTermStock.SaveData_Memo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.SaveData_Memo: 진입점 집계 11검사 — NOT_RUN:7 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0084_LongTermStock.SaveData_Memo:) |
| WK-SCP0084-0173 | X-ROW | SCP0084_LongTermStock.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.SetChangedControl: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0084_LongTermStock.SetChangedCont) |
| WK-SCP0084-0174 | X-ROW | SCP0084_LongTermStock.SetColumnFooterDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.SetColumnFooterData: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0084_LongTermStock.SetColumnFoote) |
| WK-SCP0084-0175 | X-ROW | SCP0084_LongTermStock.SetMonthRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.SetMonthRange: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0084_LongTermStock.SetMonthRange ) |
| WK-SCP0084-0176 | X-ROW | SCP0084_LongTermStock.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.SetSpreadInit: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0084_LongTermStock.SetSpreadInit) |

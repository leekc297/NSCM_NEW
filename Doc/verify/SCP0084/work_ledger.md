# 작업 원장 — SCP0084 · 2026-11-05 07:51

> 검사 인스턴스 212건 중 PASS·NA 146건 외 **66건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 36 | 재판정 PASS |
| W5 | 검사기 연결 | 2 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 12 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 16 | 원인 해소 → 재판정 |

- 담당: FE 27 · 하네스·환경 16 · 사람 판정 / AS-IS 원문 확인 → 재판정 12 · DB 9 · 하네스 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 6 |  |  |  | 1 |  | 6 | 대조표 행이 서술한 동작을 화면에서 재현 |
| H2 | DESIGN |  |  | 11 |  |  |  |  |  |  | 배경·글자색 규칙 |
| A1 | GEN |  |  |  |  |  |  | 10 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| D3 | EDIT |  |  | 8 |  |  |  |  |  |  | 행 값 기반 조건부 잠금 |
| G1 | GEN |  |  |  |  |  |  |  |  | 7 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| F4 | DB |  |  | 4 |  |  |  |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| J2 | AUTH |  |  | 1 |  |  |  |  |  |  | 권한별 버튼·기능 |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  | 1 |  |  |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 값 보존 |
| I1 | DESIGN |  |  | 1 |  |  |  |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  | 1 |  |  |  |  |  |  | 조회조건 순서 = 기준표 |
| X-REOPEN | GEN |  |  | 1 |  |  |  |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| DB-SYN | DB |  |  |  |  | 1 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| A6 | GEN |  |  |  |  |  |  | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| K-SA | COMMON |  |  |  |  |  |  |  |  | 1 | 조회영역 토글 |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |

## W3 동작 수정 (36)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0084-0001 | J2 | SCP0084 화면 | DB(🛠️/🧯 적용 가능) | J2 FAIL 수정 — SCP0084 화면: 원장 V-6f68ca62 RULE_SCREEN / 원장 V-84371ffd DEFECT / 원장 V-7bb8d701 GENERAL / 원장 V-26902320 GENERAL / 원장 V-e |  | 22 (monthPicker (Month, 단일) cboDivision (Div) |
| WK-SCP0084-0002 | F1 | SCP0084 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F1 FAIL 수정 — SCP0084 화면: 원장 V-c2b915da RULE_SCREEN / 원장 V-c4427e25 RULE_SCREEN / 원장 V-e34556f7 RULE_SCREEN / 원장 V-2828d9b5 RULE_SC |  | 79 (**EditButton 노출** SetSheetHeaderColumn +) |
| WK-SCP0084-0003 | F2 | SCP0084 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F2 FAIL 수정 — SCP0084 화면: 원장 V-854a8a97 RULE_SCREEN / 원장 V-b8408c5e RULE_SCREEN / 원장 V-fca772ec GENERAL / 원장 V-a2d5679c GENERAL / 원 |  | 79 (**EditButton 노출** SetSheetHeaderColumn +) |
| WK-SCP0084-0004 | F6 | SCP0084 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F6 FAIL 수정 — SCP0084 화면: 원장 V-8294a827 RULE_SCREEN / 원장 V-b6a3890b RULE_SCREEN / 원장 V-39b8853b RULE_SCREEN / 원장 V-73a21b12 RULE_SC |  | 71 (SaveData_Memo (I/M/D 행, 6키+MEMO) ACT:SCP) |
| WK-SCP0084-0005 | F4 | PKG_SCP0084.P_SCP0084_SAVE_LONG_TERM_STO | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — PKG_SCP0084.P_SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET: 실측[T-3408d1cb]: PKG_SCP0084.P_SCP0084_SAVE_LONG_TERM_STO |  | 70 (ACT:SCP0084_LongTermStock.SaveButton ACT) |
| WK-SCP0084-0006 | F4 | SCP0084_GET_MONTH_RANGE | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — SCP0084_GET_MONTH_RANGE: 실측[T-e10eea6a]: SCP0084_GET_MONTH_RANGE: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배선 확인) — 화면 |  | 2 (monthPicker (Month, 단일) ACT:SCP0084_Long) |
| WK-SCP0084-0007 | F4 | SCP0084_LongTermStock.SCM_SYS_LOG_BATCH | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — SCP0084_LongTermStock.SCM_SYS_LOG_BATCH: 진입점 집계 — 대조표 SCP0084_LongTermStock.SCM_SYS_LOG_BATCH 의 F4 3요소: FAIL:2 · PASS |  | 2 (ACT:SCP0084_LongTermStock.SCM_SYS_LOG_BA) |
| WK-SCP0084-0008 | F4 | SaveData_Memo (I/M/D 행, 6키+MEMO) | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — SaveData_Memo (I/M/D 행, 6키+MEMO): 행 집계 — 대조표 SaveData_Memo (I/M/D 행, 6키+MEMO) '405~420' 의 F4 3요소: FAIL:2 · PASS:1 · F |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0009 | H2 | Edit 가드 Action(String) 컬럼 hidden (R6) | FE(repairScope=DB_ONLY — 이번 범위 밖) | H2 FAIL 수정 — Edit 가드 Action(String) 컬럼 hidden (R6): 행 집계 — 대조표 Edit 가드 Action(String) 컬럼 hidden (R6) '244' 의 H2 3요소: PASS:2 · FAIL |  | 1 (Edit 가드 Action(String) 컬럼 hidden (R6)) |
| WK-SCP0084-0010 | H2 | ExcelButton + MSG00100 confirm (R9) | FE(repairScope=DB_ONLY — 이번 범위 밖) | H2 FAIL 수정 — ExcelButton + MSG00100 confirm (R9): 행 집계 — 대조표 ExcelButton + MSG00100 confirm (R9) '258~274/263~270' 의 H2 3요소: PASS: |  | 1 (ExcelButton + MSG00100 confirm (R9)) |
| WK-SCP0084-0011 | H2 | FIXED_FLAG=Y (ITEM_UOM) 틀고정 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H2 FAIL 수정 — FIXED_FLAG=Y (ITEM_UOM) 틀고정: 행 집계 — 대조표 FIXED_FLAG=Y (ITEM_UOM) 틀고정 '메타' 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: MEMO —  |  | 1 (FIXED_FLAG=Y (ITEM_UOM) 틀고정) |
| WK-SCP0084-0012 | H2 | MEMO | FE(repairScope=DB_ONLY — 이번 범위 밖) | H2 FAIL 수정 — MEMO: 실측[T-1cef9004]: MEMO: 기존행 편집 가능인데 노랑 아님 |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0013 | H2 | ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H2 FAIL 수정 — ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1~12 등): 행 집계 — 대조표 ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1~12 등) '미배선' 의 H2  |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0014 | H2 | SCP0084_LongTermStock.CreateSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | H2 FAIL 수정 — SCP0084_LongTermStock.CreateSpread: 진입점 집계 — 대조표 SCP0084_LongTermStock.CreateSpread 의 H2 3요소: PASS:2 · FAIL:1 · FAIL  |  | 4 (ACT:SCP0084_LongTermStock.CreateSpread:1) |
| WK-SCP0084-0015 | H2 | SCP0084_LongTermStock.SetSpreadInit | FE(repairScope=DB_ONLY — 이번 범위 밖) | H2 FAIL 수정 — SCP0084_LongTermStock.SetSpreadInit: 진입점 집계 — 대조표 SCP0084_LongTermStock.SetSpreadInit 의 H2 3요소: PASS:2 · FAIL:1 · FAI |  | 3 (ACT:SCP0084_LongTermStock.SetSpreadInit:) |
| WK-SCP0084-0016 | H2 | SetSheetHeaderColumn + ColumnHeaderHeigh | FE(repairScope=DB_ONLY — 이번 범위 밖) | H2 FAIL 수정 — SetSheetHeaderColumn + ColumnHeaderHeight(0,50) 다단 헤더 (R1/W2: 행 집계 — 대조표 SetSheetHeaderColumn + ColumnHeaderHeight(0, |  | 1 (SetSheetHeaderColumn + ColumnHeaderHeigh) |
| WK-SCP0084-0017 | H2 | siMain.Query(ds) 컬럼명 바인딩 (W3) | FE(repairScope=DB_ONLY — 이번 범위 밖) | H2 FAIL 수정 — siMain.Query(ds) 컬럼명 바인딩 (W3): 행 집계 — 대조표 siMain.Query(ds) 컬럼명 바인딩 (W3) '325' 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: ME |  | 1 (siMain.Query(ds) 컬럼명 바인딩 (W3)) |
| WK-SCP0084-0018 | H2 | 조회 후 전 컬럼 Lock (R2, W4) | DB(🛠️/🧯 적용 가능) | H2 FAIL 수정 — 조회 후 전 컬럼 Lock (R2, W4): 행 집계 — 대조표 조회 후 전 컬럼 Lock (R2, W4) '327' 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: MEMO — 실측[T-1c |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0019 | H2 | 통화 파생(SP CASE) | FE(repairScope=DB_ONLY — 이번 범위 밖) | H2 FAIL 수정 — 통화 파생(SP CASE): 행 집계 — 대조표 통화 파생(SP CASE) 'SP' 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: MEMO — 실측[T-1cef9004]: MEMO: 기존행  |  | 1 (통화 파생(SP CASE)) |
| WK-SCP0084-0020 | I1 | SCP0084 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | I1 FAIL 수정 — SCP0084 화면: 원장 V-87b9620a RULE_SCREEN / 원장 V-eb8bf778 RULE_SCREEN / 원장 V-afbf57f8 RULE_SCREEN / 원장 V-90652cbe DEFECT  |  | 10 (SetDivisionAuthCheck (권한0행) SaveData_Mem) |
| WK-SCP0084-0021 | SC1 | SCP0084 화면 | DB(🛠️/🧯 적용 가능) | SC1 FAIL 수정 — SCP0084 화면: E2E smoke cond order / 실측[T-cd8baac8]: 조회조건 순서 = AS-IS 화면 배치 순서(디자이너 좌표: 위→아래 줄, 줄 안 왼→오른) — 기준표 tobe_or |  | 7 (monthPicker (Month, 단일) cboDivision (Div) |
| WK-SCP0084-0022 | D3 | **EditButton 노출** | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — **EditButton 노출**: 행 집계 — 대조표 **EditButton 노출** '227' 의 D3 1요소: FAIL:1 · FAIL 요소: MEMO — 실측[T-1a8ec3b0]: r0  → MEMO 편 |  | 1 (**EditButton 노출**) |
| WK-SCP0084-0023 | D3 | Edit 가드 Action(String) 컬럼 hidden (R6) | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — Edit 가드 Action(String) 컬럼 hidden (R6): 행 집계 — 대조표 Edit 가드 Action(String) 컬럼 hidden (R6) '244' 의 D3 1요소: FAIL:1 · FAIL |  | 1 (Edit 가드 Action(String) 컬럼 hidden (R6)) |
| WK-SCP0084-0024 | D3 | Edit 가드 RowCount==0 (R5) | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — Edit 가드 RowCount==0 (R5): 행 집계 — 대조표 Edit 가드 RowCount==0 (R5) '231' 의 D3 1요소: FAIL:1 · FAIL 요소: MEMO — 실측[T-1a8ec3b0] |  | 1 (Edit 가드 RowCount==0 (R5)) |
| WK-SCP0084-0025 | D3 | Edit 가드 fps==null (R4) | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — Edit 가드 fps==null (R4): 행 집계 — 대조표 Edit 가드 fps==null (R4) '229' 의 D3 1요소: FAIL:1 · FAIL 요소: MEMO — 실측[T-1a8ec3b0]: r0 |  | 1 (Edit 가드 fps==null (R4)) |
| WK-SCP0084-0026 | D3 | MEMO | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — MEMO: 실측[T-1a8ec3b0]: r0  → MEMO 편집=true (AS-IS 잠금 EditButton:242) NG · r1  → MEMO 편집=true (AS-IS 잠금 EditButton:242)  |  | 4 (EditButton → SwitchLock + LockRange (MEM) |
| WK-SCP0084-0027 | D3 | SCP0084_LongTermStock.EditButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — SCP0084_LongTermStock.EditButton: 진입점 집계 — 대조표 SCP0084_LongTermStock.EditButton 의 D3 1요소: FAIL:1 · FAIL 요소: MEMO — 실측 |  | 11 (ACT:SCP0084_LongTermStock.EditButton:229) |
| WK-SCP0084-0028 | D3 | cellclipboardPast=false (R7) | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — cellclipboardPast=false (R7): 행 집계 — 대조표 cellclipboardPast=false (R7) '237~240' 의 D3 1요소: FAIL:1 · FAIL 요소: MEMO — 실측 |  | 1 (cellclipboardPast=false (R7)) |
| WK-SCP0084-0029 | D3 | 조회 후 전 컬럼 Lock (R2, W4) | DB(🛠️/🧯 적용 가능) | D3 FAIL 수정 — 조회 후 전 컬럼 Lock (R2, W4): 행 집계 — 대조표 조회 후 전 컬럼 Lock (R2, W4) '327' 의 D3 1요소: FAIL:1 · FAIL 요소: MEMO — 실측[T-1a8ec3b0]:  |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0030 | X-REOPEN | SCP0084 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REOPEN FAIL 수정 — SCP0084 화면: 실측[T-5ebb12ee]: 탭 닫기 → 재오픈: 치명 콘솔 0 · 5xx 1 · 재오픈 직후 행 0(최초 진입 0) |  | 8 (ACT:SCP0084_LongTermStock.Dispose ACT:SC) |
| WK-SCP0084-0031 | X-ROW | SCP0084_LongTermStock.ExcelButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0084_LongTermStock.ExcelButton: 진입점 집계 3검사 — NA:2 · FAIL:1 |  | 7 (ACT:SCP0084_LongTermStock.ExcelButton AC) |
| WK-SCP0084-0032 | X-ROW | SCP0084_LongTermStock.ExportExcelData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0084_LongTermStock.ExportExcelData: 진입점 집계 5검사 — NA:4 · FAIL:1 |  | 113 (ACT:SCP0084_LongTermStock.ExportExcelDat) |
| WK-SCP0084-0033 | X-ROW | SCP0084_LongTermStock.Find_Data | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0084_LongTermStock.Find_Data: 진입점 집계 8검사 — PASS:3 · NA:2 · FAIL:2 · REVIEW:1 |  | 36 (ACT:SCP0084_LongTermStock.Find_Data ACT:) |
| WK-SCP0084-0034 | X-ROW | SCP0084_LongTermStock.GetMonthRange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0084_LongTermStock.GetMonthRange: 진입점 집계 5검사 — NOPATH:3 · FAIL:2 |  | 1 (ACT:SCP0084_LongTermStock.GetMonthRange) |
| WK-SCP0084-0035 | X-ROW | SCP0084_LongTermStock.SCM_SYS_LOG_BATCH | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — SCP0084_LongTermStock.SCM_SYS_LOG_BATCH: 진입점 집계 3검사 — NOT_RUN:1 · NOPATH:1 · FAIL:1 |  | 12 (ACT:SCP0084_LongTermStock.SCM_SYS_LOG_BA) |
| WK-SCP0084-0036 | X-ROW | SCP0084_LongTermStock.SaveData_Memo | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0084_LongTermStock.SaveData_Memo: 진입점 집계 15검사 — FAIL:6 · NA:6 · PASS:3 |  | 4 (ACT:SCP0084_LongTermStock.SaveData_Memo:) |

## W5 검사기 연결 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0084-0037 | DB-SYN | SCP0084_GET_MONTH_RANGE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0084_GET_MONTH_RANGE | 없음(PROC_M 대응 없음) | 2 (monthPicker (Month, 단일) ACT:SCP0084_Long) |
| WK-SCP0084-0038 | G03-WIRE | SCP0084 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0084 화면 | 판단불가(대상 단위 SCREEN) | 5 (ACT:SCP0084_LongTermStock..ctor ACT:SCP0) |

## W7 기대값 확정 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0084-0039 | A1 | GetCheckedListValue → CSV 조립 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — GetCheckedListValue → CSV 조립: 행 집계 — 대조표 GetCheckedListValue → CSV 조립 '293~314' 의 A1 2요소: REVIEW:2 · FAIL 요소: SCP0084_ |  | 1 (GetCheckedListValue → CSV 조립) |
| WK-SCP0084-0040 | A1 | PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOCK: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0084/SCP0084_GET_LONG_TERM |  | 3 (ACT:SCP0084_LongTermStock.FindButton ACT) |
| WK-SCP0084-0041 | A1 | SCP0084_GET_MONTH_RANGE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0084_GET_MONTH_RANGE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0084/SCP0084_GET_MONTH_RANGE.md — 파라미터 미정 |  | 1 (monthPicker (Month, 단일)) |
| WK-SCP0084-0042 | A1 | SaveData_Memo (I/M/D 행, 6키+MEMO) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SaveData_Memo (I/M/D 행, 6키+MEMO): 행 집계 — 대조표 SaveData_Memo (I/M/D 행, 6키+MEMO) '405~420' 의 A1 2요소: REVIEW:2 · FAIL 요소:  |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0043 | A1 | SetDivisionAuthCheck (권한0행) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SetDivisionAuthCheck (권한0행): 행 집계 — 대조표 SetDivisionAuthCheck (권한0행) '146~147' 의 A1 2요소: REVIEW:2 · FAIL 요소: SCP0084_GE |  | 1 (SetDivisionAuthCheck (권한0행)) |
| WK-SCP0084-0044 | A1 | cboDivision (Division, 다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision (Division, 다중): 행 집계 — 대조표 cboDivision (Division, 다중) '40/294' 의 A1 2요소: REVIEW:2 · FAIL 요소: SCP0084_GET_M |  | 1 (cboDivision (Division, 다중)) |
| WK-SCP0084-0045 | A1 | cboLongTermType (다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboLongTermType (다중): 행 집계 — 대조표 cboLongTermType (다중) '97~106/151~167/296' 의 A1 2요소: REVIEW:2 · FAIL 요소: SCP0084_GET_M |  | 1 (cboLongTermType (다중)) |
| WK-SCP0084-0046 | A1 | checkRequiredOfSearch | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — checkRequiredOfSearch: 행 집계 — 대조표 checkRequiredOfSearch '285' 의 A1 2요소: REVIEW:2 · FAIL 요소: SCP0084_GET_MONTH_RANGE —  |  | 1 (checkRequiredOfSearch) |
| WK-SCP0084-0047 | A1 | clbPlant (Plant, 다중, cascade) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbPlant (Plant, 다중, cascade): 행 집계 — 대조표 clbPlant (Plant, 다중, cascade) '42/295/173~181/808~811' 의 A1 2요소: REVIEW:2 ·  |  | 1 (clbPlant (Plant, 다중, cascade)) |
| WK-SCP0084-0048 | A1 | 조회 후 전 컬럼 Lock (R2, W4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회 후 전 컬럼 Lock (R2, W4): 행 집계 — 대조표 조회 후 전 컬럼 Lock (R2, W4) '327' 의 A1 2요소: REVIEW:2 · FAIL 요소: SCP0084_GET_MONTH_RANG |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0049 | A6 | SCP0084_GET_MONTH_RANGE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0084_GET_MONTH_RANGE: 원장 V-43818378 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-d475b28f]: SCP008 |  | 1 (monthPicker (Month, 단일)) |
| WK-SCP0084-0050 | X-ROW | SCP0084_LongTermStock.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0084_LongTermStock.FindButton: 진입점 집계 3검사 — PASS:2 · REVIEW:1 |  | 1 (ACT:SCP0084_LongTermStock.FindButton) |

## W9 도구 오류 (16)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0084-0051 | K-SA | SCP0084 화면 | 하네스·환경 | K-SA 도구 오류 — E2E smoke common Search Area 조회영역 토글 |  | 1 (SetDivisionAuthCheck (권한0행)) |
| WK-SCP0084-0052 | F3 | SCP0084 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-620fd324 RULE_SCREEN / 원장 V-9829cde2 RULE_SCREEN / 원장 V-9508dc01 GENERAL / 원장 V-96aca34b GENERAL / 원장 V-81ea5f75 G |  | 1 (cellclipboardPast=false (R7)) |
| WK-SCP0084-0053 | H10 | SCP0084 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 3 (SetDivisionAuthCheck (권한0행) SaveData_Mem) |
| WK-SCP0084-0054 | G1 | GetCheckedListValue → CSV 조립 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 GetCheckedListValue → CSV 조립 '293~314' 의 G1 4요소: PASS:2 · ERROR:1 · NA:1 |  | 1 (GetCheckedListValue → CSV 조립) |
| WK-SCP0084-0055 | G1 | SaveData_Memo (I/M/D 행, 6키+MEMO) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SaveData_Memo (I/M/D 행, 6키+MEMO) '405~420' 의 G1 4요소: PASS:2 · ERROR:1 · NA:1 |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0056 | G1 | SetDivisionAuthCheck (권한0행) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SetDivisionAuthCheck (권한0행) '146~147' 의 G1 4요소: PASS:2 · ERROR:1 · NA:1 |  | 1 (SetDivisionAuthCheck (권한0행)) |
| WK-SCP0084-0057 | G1 | checkRequiredOfSearch | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 checkRequiredOfSearch '285' 의 G1 4요소: PASS:2 · ERROR:1 · NA:1 |  | 1 (checkRequiredOfSearch) |
| WK-SCP0084-0058 | G1 | clbPlant / Plant | 하네스·환경 | G1 도구 오류 — 원장 V-907975a9 SEARCH / E2E smoke cond combo |  | 1 (clbPlant (Plant, 다중, cascade)) |
| WK-SCP0084-0059 | G1 | monthPicker (Month, 단일) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 monthPicker (Month, 단일) '40/143/293/361~368' 의 G1 4요소: PASS:2 · ERROR:1 · NA:1 |  | 1 (monthPicker (Month, 단일)) |
| WK-SCP0084-0060 | G1 | 조회 후 전 컬럼 Lock (R2, W4) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 조회 후 전 컬럼 Lock (R2, W4) '327' 의 G1 4요소: PASS:2 · ERROR:1 · NA:1 |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0061 | X-ROW | SCP0084_LongTermStock.CboDivision_Select | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0084_LongTermStock.CboDivision_Se) |
| WK-SCP0084-0062 | X-ROW | SCP0084_LongTermStock.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0084_LongTermStock.CreateSpread) |
| WK-SCP0084-0063 | X-ROW | SCP0084_LongTermStock.SetChangedControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:3 · NOT_RUN:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0084_LongTermStock.SetChangedCont) |
| WK-SCP0084-0064 | X-ROW | SCP0084_LongTermStock.SetColumnFooterDat | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0084_LongTermStock.SetColumnFoote) |
| WK-SCP0084-0065 | X-ROW | SCP0084_LongTermStock.SetMonthRange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0084_LongTermStock.SetMonthRange ) |
| WK-SCP0084-0066 | X-ROW | SCP0084_LongTermStock.SetSpreadInit | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:4 · PASS:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0084_LongTermStock.SetSpreadInit) |

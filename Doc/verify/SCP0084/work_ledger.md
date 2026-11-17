# 작업 원장 — SCP0084 · 2026-11-14 13:40

> 검사 인스턴스 240건 중 PASS·NA 170건 외 **70건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 2 | 재판정 PASS |
| W5 | 검사기 연결 | 2 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 9 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 57 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 57 · 사람 판정 / AS-IS 원문 확인 → 재판정 9 · 하네스 2 · 사람판정 1 · 화면 FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 1 |  |  |  |  |  | 10 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 10 | 연쇄 자동 채움 |
| A1 | GEN |  |  |  |  |  |  | 9 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| D1 | EDIT |  |  |  |  |  |  |  |  | 8 | 컬럼 편집 가능 여부(신규행·기존행) |
| G1 | GEN |  |  |  |  |  |  |  |  | 7 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| B4 | COMBO |  |  |  |  |  |  |  |  | 4 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| D4 | EDIT |  |  |  |  |  |  |  |  | 4 | 신규행 기본값·자동세팅·Insert 전제 |
| B3 | COMBO |  |  |  |  |  |  |  |  | 3 | 콤보 후보 정렬 = AS-IS |
| A6 | GEN |  |  | 1 |  |  |  |  |  | 1 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| E4 | EDIT |  |  |  |  |  |  |  |  | 2 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| DB-SYN | DB |  |  |  |  | 1 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |
| G5 | POPUP |  |  |  |  |  |  |  |  | 1 | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  |  |  |  |  | 1 | 팝업 표준·열림 |

## W3 동작 수정 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0084-0001 | A6 | PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOC | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOCK: 원장 V-825d772c SP / 정렬대조 PASS 분기 키 순서 동일 / 실측 순서대조 DIFF 공통 1107행(Doc/golden |  | 2 (ACT:SCP0084_LongTermStock.FindButton ACT) |
| WK-SCP0084-0002 | X-ROW | SCP0084_LongTermStock.FindButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0084_LongTermStock.FindButton: 진입점 집계 3검사 — PASS:2 · FAIL:1 (FX-SCP0084-013) |  | 1 (ACT:SCP0084_LongTermStock.FindButton) |

## W5 검사기 연결 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0084-0003 | DB-SYN | SCP0084_GET_MONTH_RANGE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0084_GET_MONTH_RANGE | 없음(PROC_M 대응 없음) | 2 (monthPicker (Month, 단일) ACT:SCP0084_Long) |
| WK-SCP0084-0004 | G03-WIRE | SCP0084 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0084 화면 | 판단불가(대상 단위 SCREEN) | 5 (ACT:SCP0084_LongTermStock..ctor ACT:SCP0) |

## W7 기대값 확정 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0084-0005 | A1 | GetCheckedListValue → CSV 조립 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — GetCheckedListValue → CSV 조립: 행 집계 — 대조표 GetCheckedListValue → CSV 조립 '293~314' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: |  | 1 (GetCheckedListValue → CSV 조립) |
| WK-SCP0084-0006 | A1 | SCP0084_GET_MONTH_RANGE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0084_GET_MONTH_RANGE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0084/SCP0084_GET_MONTH_RANGE.md — 파라미터 미정 |  | 1 (monthPicker (Month, 단일)) |
| WK-SCP0084-0007 | A1 | SaveData_Memo (I/M/D 행, 6키+MEMO) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SaveData_Memo (I/M/D 행, 6키+MEMO): 행 집계 — 대조표 SaveData_Memo (I/M/D 행, 6키+MEMO) '405~420' 의 A1 2요소: REVIEW:1 · PASS:1 ·  |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0008 | A1 | SetDivisionAuthCheck (권한0행) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SetDivisionAuthCheck (권한0행): 행 집계 — 대조표 SetDivisionAuthCheck (권한0행) '146~147' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: S |  | 1 (SetDivisionAuthCheck (권한0행)) |
| WK-SCP0084-0009 | A1 | cboDivision (Division, 다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision (Division, 다중): 행 집계 — 대조표 cboDivision (Division, 다중) '40/294' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: SCP0 |  | 1 (cboDivision (Division, 다중)) |
| WK-SCP0084-0010 | A1 | cboLongTermType (다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboLongTermType (다중): 행 집계 — 대조표 cboLongTermType (다중) '97~106/151~167/296' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: SCP0 |  | 1 (cboLongTermType (다중)) |
| WK-SCP0084-0011 | A1 | checkRequiredOfSearch | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — checkRequiredOfSearch: 행 집계 — 대조표 checkRequiredOfSearch '285' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: SCP0084_GET_MONTH |  | 1 (checkRequiredOfSearch) |
| WK-SCP0084-0012 | A1 | clbPlant (Plant, 다중, cascade) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbPlant (Plant, 다중, cascade): 행 집계 — 대조표 clbPlant (Plant, 다중, cascade) '42/295/173~181/808~811' 의 A1 2요소: REVIEW:1 ·  |  | 1 (clbPlant (Plant, 다중, cascade)) |
| WK-SCP0084-0013 | A1 | 조회 후 전 컬럼 Lock (R2, W4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회 후 전 컬럼 Lock (R2, W4): 행 집계 — 대조표 조회 후 전 컬럼 Lock (R2, W4) '327' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: SCP0084_GET_M |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |

## W9 도구 오류 (57)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0084-0014 | J2 | SCP0084 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-b8863463 RULE_SCREEN / 원장 V-84371ffd DEFECT / 원장 V-7bb8d701 GENERAL / 원장 V-26902320 GENERAL / 원장 V-ef267bea GENERA |  | 22 (monthPicker (Month, 단일) cboDivision (Div) |
| WK-SCP0084-0015 | C3 | LONG_TERM_STOCK_AMOUNT / Amount(KRW | 하네스·환경 | C3 도구 오류 — 실측[T-3ff3faf4]: LONG_TERM_STOCK_AMOUNT 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0084_LongTermStock.ExportExcelDat) |
| WK-SCP0084-0016 | C3 | LONG_TERM_STOCK_AMOUNT_XLS / Amount(KRW | 하네스·환경 | C3 도구 오류 — 실측[T-5d6662af]: LONG_TERM_STOCK_AMOUNT_XLS 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0084_LongTermStock.ExportExcelDat) |
| WK-SCP0084-0017 | C3 | LONG_TERM_STOCK_QTY / Quantity | 하네스·환경 | C3 도구 오류 — 실측[T-31a47125]: LONG_TERM_STOCK_QTY 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0084_LongTermStock.ExportExcelDat) |
| WK-SCP0084-0018 | C3 | LONG_TERM_STOCK_QTY_XLS / Quantity | 하네스·환경 | C3 도구 오류 — 실측[T-4e7583c4]: LONG_TERM_STOCK_QTY_XLS 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0084_LongTermStock.ExportExcelDat) |
| WK-SCP0084-0019 | C3 | SCP0084_LongTermStock.CboDivision_Select | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0084_LongTermStock.CboDivision_SelectedIndexChanged 의 C3 4요소: ERROR:4 |  | 1 (ACT:SCP0084_LongTermStock.CboDivision_Se) |
| WK-SCP0084-0020 | C3 | SCP0084_LongTermStock.SetChangedControl | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0084_LongTermStock.SetChangedControl 의 C3 4요소: ERROR:4 |  | 3 (ACT:SCP0084_LongTermStock.SetChangedCont) |
| WK-SCP0084-0021 | C3 | SCP0084_LongTermStock.SetColumnFooterDat | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0084_LongTermStock.SetColumnFooterData 의 C3 4요소: ERROR:4 |  | 3 (ACT:SCP0084_LongTermStock.SetColumnFoote) |
| WK-SCP0084-0022 | C3 | SCP0084_LongTermStock.SetMonthRange | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0084_LongTermStock.SetMonthRange 의 C3 4요소: ERROR:4 |  | 2 (ACT:SCP0084_LongTermStock.SetMonthRange:) |
| WK-SCP0084-0023 | C3 | SCP0084_LongTermStock.SetSpreadInit | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0084_LongTermStock.SetSpreadInit 의 C3 4요소: ERROR:4 |  | 3 (ACT:SCP0084_LongTermStock.SetSpreadInit:) |
| WK-SCP0084-0024 | C3 | cellclipboardPast=false (R7) | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 cellclipboardPast=false (R7) '237~240' 의 C3 4요소: ERROR:4 |  | 1 (cellclipboardPast=false (R7)) |
| WK-SCP0084-0025 | B3 | EXHT_TP_CD / 소진방안 유형 | 하네스·환경 | B3 도구 오류 — 원장 V-76d0225e COLUMN |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0026 | B3 | OCCR_RSN_CD / 발생사유 유형 | 하네스·환경 | B3 도구 오류 — 원장 V-00556d19 COLUMN |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0027 | B3 | SCP0084_LongTermStock.GetMonthRange | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0084_LongTermStock.GetMonthRange 의 B3 4요소: ERROR:2 · PASS:1 · NA:1 |  | 2 (ACT:SCP0084_LongTermStock.GetMonthRange:) |
| WK-SCP0084-0028 | B4 | EXHT_TP_CD / 소진방안 유형 | 하네스·환경 | B4 도구 오류 — 원장 V-6ac94f60 COLUMN |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0029 | B4 | OCCR_RSN_CD / 발생사유 유형 | 하네스·환경 | B4 도구 오류 — 원장 V-322968e8 COLUMN |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0030 | B4 | SCP0084_LongTermStock.GetMonthRange | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0084_LongTermStock.GetMonthRange 의 B4 4요소: ERROR:3 · NA:1 |  | 2 (ACT:SCP0084_LongTermStock.GetMonthRange:) |
| WK-SCP0084-0031 | B4 | cboLongTermType / Long Term Type | 하네스·환경 | B4 도구 오류 — 원장 V-2501070e SEARCH |  | 1 (cboLongTermType (다중)) |
| WK-SCP0084-0032 | F1 | SCP0084 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-c9d3bd14 RULE_SCREEN / 원장 V-c4427e25 RULE_SCREEN / 원장 V-e34556f7 RULE_SCREEN / 원장 V-2828d9b5 RULE_SCREEN / 원장 V-e3 |  | 79 (**EditButton 노출** SetSheetHeaderColumn +) |
| WK-SCP0084-0033 | F2 | SCP0084 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-f42de3e7 RULE_SCREEN / 원장 V-b8408c5e RULE_SCREEN / 원장 V-fca772ec GENERAL / 원장 V-a2d5679c GENERAL / 원장 V-b36b747c G |  | 79 (**EditButton 노출** SetSheetHeaderColumn +) |
| WK-SCP0084-0034 | F3 | SCP0084 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-620fd324 RULE_SCREEN / 원장 V-9829cde2 RULE_SCREEN / 원장 V-9508dc01 GENERAL / 원장 V-96aca34b GENERAL / 원장 V-81ea5f75 G |  | 1 (cellclipboardPast=false (R7)) |
| WK-SCP0084-0035 | F6 | SCP0084 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-922eb524 RULE_SCREEN / 원장 V-b6a3890b RULE_SCREEN / 원장 V-39b8853b RULE_SCREEN / 원장 V-73a21b12 RULE_SCREEN / 원장 V-2f |  | 71 (SaveData_Memo (I/M/D 행, 6키+MEMO) ACT:SCP) |
| WK-SCP0084-0036 | I1 | SCP0084 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-eed2928c RULE_SCREEN / 원장 V-eb8bf778 RULE_SCREEN / 원장 V-afbf57f8 RULE_SCREEN / 원장 V-90652cbe DEFECT / 원장 V-8592a01 |  | 10 (SetDivisionAuthCheck (권한0행) SaveData_Mem) |
| WK-SCP0084-0037 | D1 | **EditButton 노출** | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 **EditButton 노출** '227' 의 D1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (**EditButton 노출**) |
| WK-SCP0084-0038 | D1 | Edit 가드 Action(String) 컬럼 hidden (R6) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 Edit 가드 Action(String) 컬럼 hidden (R6) '244' 의 D1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (Edit 가드 Action(String) 컬럼 hidden (R6)) |
| WK-SCP0084-0039 | D1 | Edit 가드 RowCount==0 (R5) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 Edit 가드 RowCount==0 (R5) '231' 의 D1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (Edit 가드 RowCount==0 (R5)) |
| WK-SCP0084-0040 | D1 | Edit 가드 fps==null (R4) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 Edit 가드 fps==null (R4) '229' 의 D1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (Edit 가드 fps==null (R4)) |
| WK-SCP0084-0041 | D1 | SCP0084_LongTermStock.EditButton | 하네스·환경 | D1 도구 오류 — 원장 V-a91c9b1c ASIS / 원장 V-08d8aa9d ASIS / 원장 V-ce55cccc ASIS |  | 11 (ACT:SCP0084_LongTermStock.EditButton:229) |
| WK-SCP0084-0042 | D1 | cellclipboardPast=false (R7) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 cellclipboardPast=false (R7) '237~240' 의 D1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (cellclipboardPast=false (R7)) |
| WK-SCP0084-0043 | D1 | siMain.SwitchLock | 하네스·환경 | D1 도구 오류 — 원장 V-a91c9b1c |  | 1 (ACT:SCP0084_LongTermStock.EditButton:233) |
| WK-SCP0084-0044 | D1 | 조회 후 전 컬럼 Lock (R2, W4) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 조회 후 전 컬럼 Lock (R2, W4) '327' 의 D1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0045 | D4 | EXHT_TP_CD / 소진방안 유형 | 하네스·환경 | D4 도구 오류 — 실측[T-6c27e428]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0046 | D4 | OCCR_RSN_CD / 발생사유 유형 | 하네스·환경 | D4 도구 오류 — 실측[T-352cf5a4]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0047 | D4 | QTY_1 | 하네스·환경 | D4 도구 오류 — 실측[T-ade9edce]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1) |
| WK-SCP0084-0048 | D4 | checkRequiredOfSearch | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 checkRequiredOfSearch '285' 의 D4 3요소: ERROR:3 |  | 1 (checkRequiredOfSearch) |
| WK-SCP0084-0049 | E4 | MSG00100 | 하네스·환경 | E4 도구 오류 — 원장 V-8a056ad0 ASIS / 실측[T-5eb7ae09]: MSG00100 — ExcelButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(ExcelBut |  | 2 (ExcelButton + MSG00100 confirm (R9) ACT:) |
| WK-SCP0084-0050 | E4 | MSG00100 | 하네스·환경 | E4 도구 오류 — 원장 V-8a056ad0 / 실측[T-4a0d3125]: MSG00100 — ExcelButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(ExcelButton)에 |  | 1 (ACT:SCP0084_LongTermStock.ExcelButton:26) |
| WK-SCP0084-0051 | A6 | SCP0084_GET_MONTH_RANGE | 하네스·환경 | A6 도구 오류 — 원장 V-43818378 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-d475b28f]: SCP0084_GET_MONTH_RANGE: 화면 진입·조 |  | 1 (monthPicker (Month, 단일)) |
| WK-SCP0084-0052 | G1 | GetCheckedListValue → CSV 조립 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 GetCheckedListValue → CSV 조립 '293~314' 의 G1 4요소: PASS:2 · ERROR:1 · NA:1 |  | 1 (GetCheckedListValue → CSV 조립) |
| WK-SCP0084-0053 | G1 | SaveData_Memo (I/M/D 행, 6키+MEMO) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SaveData_Memo (I/M/D 행, 6키+MEMO) '405~420' 의 G1 4요소: PASS:2 · ERROR:1 · NA:1 |  | 1 (SaveData_Memo (I/M/D 행, 6키+MEMO)) |
| WK-SCP0084-0054 | G1 | SetDivisionAuthCheck (권한0행) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SetDivisionAuthCheck (권한0행) '146~147' 의 G1 4요소: PASS:2 · ERROR:1 · NA:1 |  | 1 (SetDivisionAuthCheck (권한0행)) |
| WK-SCP0084-0055 | G1 | checkRequiredOfSearch | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 checkRequiredOfSearch '285' 의 G1 4요소: PASS:2 · ERROR:1 · NA:1 |  | 1 (checkRequiredOfSearch) |
| WK-SCP0084-0056 | G1 | clbPlant / Plant | 하네스·환경 | G1 도구 오류 — 원장 V-907975a9 SEARCH / E2E smoke cond combo |  | 1 (clbPlant (Plant, 다중, cascade)) |
| WK-SCP0084-0057 | G1 | monthPicker (Month, 단일) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 monthPicker (Month, 단일) '40/143/293/361~368' 의 G1 4요소: PASS:2 · ERROR:1 · NA:1 |  | 1 (monthPicker (Month, 단일)) |
| WK-SCP0084-0058 | G1 | 조회 후 전 컬럼 Lock (R2, W4) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 조회 후 전 컬럼 Lock (R2, W4) '327' 의 G1 4요소: PASS:2 · ERROR:1 · NA:1 |  | 1 (조회 후 전 컬럼 Lock (R2, W4)) |
| WK-SCP0084-0059 | X-ROW | SCP0084_LongTermStock.CboDivision_Select | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0084_LongTermStock.CboDivision_Se) |
| WK-SCP0084-0060 | X-ROW | SCP0084_LongTermStock.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0084_LongTermStock.CreateSpread) |
| WK-SCP0084-0061 | X-ROW | SCP0084_LongTermStock.ExcelButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 7 (ACT:SCP0084_LongTermStock.ExcelButton AC) |
| WK-SCP0084-0062 | X-ROW | SCP0084_LongTermStock.ExportExcelData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:7 · NA:2 |  | 113 (ACT:SCP0084_LongTermStock.ExportExcelDat) |
| WK-SCP0084-0063 | X-ROW | SCP0084_LongTermStock.Find_Data | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — PASS:4 · NA:3 · ERROR:1 |  | 36 (ACT:SCP0084_LongTermStock.Find_Data ACT:) |
| WK-SCP0084-0064 | X-ROW | SCP0084_LongTermStock.SaveData_Memo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — NA:6 · PASS:5 · ERROR:4 |  | 4 (ACT:SCP0084_LongTermStock.SaveData_Memo:) |
| WK-SCP0084-0065 | X-ROW | SCP0084_LongTermStock.SetChangedControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:3 · NOT_RUN:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0084_LongTermStock.SetChangedCont) |
| WK-SCP0084-0066 | X-ROW | SCP0084_LongTermStock.SetColumnFooterDat | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0084_LongTermStock.SetColumnFoote) |
| WK-SCP0084-0067 | X-ROW | SCP0084_LongTermStock.SetMonthRange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0084_LongTermStock.SetMonthRange ) |
| WK-SCP0084-0068 | X-ROW | SCP0084_LongTermStock.SetSpreadInit | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:4 · PASS:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0084_LongTermStock.SetSpreadInit) |
| WK-SCP0084-0069 | G5 | saveFileDialog.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-17e9559b |  | 1 (ACT:SCP0084_LongTermStock.ExportExcelDat) |
| WK-SCP0084-0070 | H6 | saveFileDialog.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-05a7b55d |  | 1 (ACT:SCP0084_LongTermStock.ExportExcelDat) |

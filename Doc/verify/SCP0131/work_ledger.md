# 작업 원장 — SCP0131 · 2026-11-07 20:27

> 검사 인스턴스 359건 중 PASS·NA 310건 외 **49건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 4 | 재판정 PASS |
| W5 | 검사기 연결 | 5 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 12 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 27 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 27 · 사람 판정 / AS-IS 원문 확인 → 재판정 12 · 하네스 5 · FE 3 · 화면 FE 1 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  |  |  |  |  |  | 11 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  | 1 |  |  |  |  |  | 7 | 대조표 행이 서술한 동작을 화면에서 재현 |
| G1 | GEN |  |  |  |  |  |  |  |  | 7 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G5 | POPUP |  |  |  |  | 1 |  |  |  | 5 | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  |  | 1 |  |  | 3 | 팝업 표준·열림 |
| E2 | EDIT |  |  |  |  | 2 |  |  |  |  | 날짜 형식·유효성 |
| M4 | POPUP |  |  |  |  |  |  | 1 |  | 1 | 팝업 선택값 반영 |
| G3 | COMMON |  |  | 1 |  |  |  |  |  |  | 조회조건 저장·복원 |
| F2 | CRUD |  |  | 1 |  |  |  |  |  |  | 1회 저장(변경 감지) |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| G4 | DESIGN |  |  |  |  | 1 |  |  |  |  | 조회조건 표시·라벨·활성 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  |  |  |  | 1 | CRUD Status 표시 정합 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0001 | G3 | SCP0131 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | G3 FAIL 수정 — SCP0131 화면: 원장 V-c8cd860a RULE_SCREEN / 원장 V-54f2a1f5 GENERAL / 원장 V-3baa65b8 GENERAL / 원장 V-ec535bd5 GENERAL / 원장 V- |  | 7 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SCP0131-0002 | F2 | SCP0131 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F2 FAIL 수정 — SCP0131 화면: 원장 V-ef6e0fe0 RULE_SCREEN / 원장 V-11d9fee9 RULE_SCREEN / 원장 V-9c901d28 RULE_SCREEN / 원장 V-a713c0b0 GENERAL |  | 165 (7 8 11 ACT:SCP0131_SalesSitePriority.Sav) |
| WK-SCP0131-0003 | H10 | SCP0131 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H10 FAIL 수정 — SCP0131 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: hooks/useSalesSitePriorityValidation.ts |  | 13 (7 8 9 10 11 12 COMMON:UC-01 COMMON:UC-02) |
| WK-SCP0131-0004 | X-ROW | SCP0131_SalesSitePriority.SaveData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0131_SalesSitePriority.SaveData: 진입점 집계 27검사 — NA:16 · PASS:7 · ERROR:3 · FAIL:1 (FX-SCP0131-030) |  | 5 (ACT:SCP0131_SalesSitePriority.SaveData:7) |

## W5 검사기 연결 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0005 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SCP0131_SalesSitePriority.InitEvent ) |
| WK-SCP0131-0006 | E2 | FROM_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL FROM_YYYYMMDD | 있음(SHEET_COLUMNS) | 1 (12) |
| WK-SCP0131-0007 | E2 | TO_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL TO_YYYYMMDD | 있음(SHEET_COLUMNS) | 3 (10 11 SetValue(1004)) |
| WK-SCP0131-0008 | G03-WIRE | SCP0131 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0131 화면 | 판단불가(대상 단위 SCREEN) | 10 (ACT:SCP0131_SalesSitePriority..ctor ACT:) |
| WK-SCP0131-0009 | G5 | cboDivision / Division / Div / Div. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboDivision / Division / Div / Div. | 있음(FE 소스) | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0010 | H6 | cboDivision / Division / Div / Div. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division / Div / Div. · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |

## W7 기대값 확정 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0011 | X-LOC | - | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — -: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (-) |
| WK-SCP0131-0012 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SCP0131-0013 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0131-0014 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0131-0015 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (12) |
| WK-SCP0131-0016 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0131-0017 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0131-0018 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0131-0019 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0131-0020 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SCP0131-0021 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0131-0022 | M4 | cboDivision / Division / Div / Div. | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboDivision / Division / Div / Div.: 검증 엔진이 실행됐으나 이 대상(COND cboDivision)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |

## W9 도구 오류 (27)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0023 | F1 | SCP0131 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-3a29440b RULE_SCREEN / 원장 V-b4a22450 RULE_SCREEN / 원장 V-c98b11b3 RULE_SCREEN / 원장 V-6232615f RULE_SCREEN / 원장 V-a0 |  | 171 (7 8 11 Delete(365) ACT:SCP0131_SalesSite) |
| WK-SCP0131-0024 | F5 | SCP0131 화면 | 하네스·환경 | F5 도구 오류 — 원장 V-10ebb742 RULE_SCREEN / 원장 V-22ad4421 RULE_SCREEN / 원장 V-96f1e525 RULE_SCREEN / 원장 V-763a348f DEFECT / 원장 V-4162078 |  | 6 (Delete(365) ACT:SCP0131_SalesSitePriorit) |
| WK-SCP0131-0025 | F6 | SCP0131 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-1986aabd RULE_SCREEN / 원장 V-b407164c RULE_SCREEN / 원장 V-d3a39193 RULE_SCREEN / 원장 V-0ff9c901 RULE_SCREEN / 원장 V-b4 |  | 162 (ACT:SCP0131_SalesSitePriority.SaveButton) |
| WK-SCP0131-0026 | I1 | SCP0131 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-5645cb8f RULE_SCREEN / 원장 V-c97ad313 RULE_SCREEN / 원장 V-748656b4 RULE_SCREEN / 원장 V-fec12d8c DEFECT / 원장 V-f03325d |  | 18 (7 8 9 10 11 12 ACT:SCP0131_SalesSitePrio) |
| WK-SCP0131-0027 | G1 | - | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 - 'InsertButton override 본문' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (-) |
| WK-SCP0131-0028 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 '수정 중 다른 데이터 조회 시 confirm' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0131-0029 | G1 | COMMON:UC-03 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 설정 적용 시 재조회 유도' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-03) |
| WK-SCP0131-0030 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 '콤마 다중 조회조건 전건 조회' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-06) |
| WK-SCP0131-0031 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회 시 필터 유지' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0131-0032 | G1 | LockColumn(462) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 LockColumn(462) 'lock' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (LockColumn(462)) |
| WK-SCP0131-0033 | G1 | clbPlanGroup / Plan Group | 하네스·환경 | G1 도구 오류 — 원장 V-54e6f257 SEARCH / E2E smoke cond combo |  | 2 (ACT:SCP0131_SalesSitePriority.FindData_M) |
| WK-SCP0131-0034 | X-ROW | SCP0131_SalesSitePriority.ClbDivision_Se | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.ClbDivisio) |
| WK-SCP0131-0035 | X-ROW | SCP0131_SalesSitePriority.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CreateSpre) |
| WK-SCP0131-0036 | X-ROW | SCP0131_SalesSitePriority.FindData_Main | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — PASS:8 · NA:3 · ERROR:1 |  | 7 (ACT:SCP0131_SalesSitePriority.FindData_M) |
| WK-SCP0131-0037 | X-ROW | SCP0131_SalesSitePriority.SetChangedCont | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.SetChanged) |
| WK-SCP0131-0038 | X-ROW | SCP0131_SalesSitePriority.SpdMain_CellDo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — NA:8 · PASS:7 · NOT_RUN:2 · NOPATH:1 · ERROR:1 |  | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |
| WK-SCP0131-0039 | X-ROW | SCP0131_SalesSitePriority.btnItemId_Clic | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:4 · NA:3 · ERROR:2 |  | 5 (ACT:SCP0131_SalesSitePriority.btnItemId_) |
| WK-SCP0131-0040 | X-ROW | SCP0131_SalesSitePriority.setPeriod | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0131_SalesSitePriority.setPeriod ) |
| WK-SCP0131-0041 | G5 | 3 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 3 'spdMain.CellClick' 의 G5 8요소: NA:5 · ERROR:2 · NOPATH:1 |  | 0 () |
| WK-SCP0131-0042 | G5 | 4 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 4 'spdMain.CellDoubleClick' 의 G5 8요소: NA:5 · ERROR:2 · NOPATH:1 |  | 0 () |
| WK-SCP0131-0043 | G5 | 5 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 5 'spdMain.ClipboardPasted' 의 G5 8요소: NA:5 · ERROR:2 · NOPATH:1 |  | 0 () |
| WK-SCP0131-0044 | G5 | new SCM0002_MaterialByDivisionPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-b28c9b7e |  | 1 (ACT:SCP0131_SalesSitePriority.btnItemId_) |
| WK-SCP0131-0045 | G5 | popItem.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-8164addc |  | 1 (ACT:SCP0131_SalesSitePriority.btnItemId_) |
| WK-SCP0131-0046 | H6 | 3 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 3 'spdMain.CellClick' 의 H6 8요소: PASS:6 · NOT_RUN:1 · NA:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0047 | H6 | 4 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 4 'spdMain.CellDoubleClick' 의 H6 8요소: PASS:6 · NOT_RUN:1 · NA:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0048 | H6 | 5 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 5 'spdMain.ClipboardPasted' 의 H6 8요소: PASS:6 · NOT_RUN:1 · NA:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0049 | M4 | SCP0131_SalesSitePriority.SpdMain_CellDo | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 SCP0131_SalesSitePriority.SpdMain_CellDoubleClick 의 M4 3요소: NA:1 · NOT_RUN:1 · PASS:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |

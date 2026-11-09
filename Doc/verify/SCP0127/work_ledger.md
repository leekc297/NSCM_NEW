# 작업 원장 — SCP0127 · 2026-11-08 21:11

> 검사 인스턴스 169건 중 PASS·NA 149건 외 **20건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 5 | 재판정 PASS |
| W5 | 검사기 연결 | 3 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 2 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 9 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 9 · 화면 FE 4 · 하네스 3 · 사람 판정 / AS-IS 원문 확인 → 재판정 2 · 사람판정 1 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 3 |  |  |  |  |  | 5 | 대조표 행이 서술한 동작을 화면에서 재현 |
| M4 | POPUP |  |  |  |  |  |  | 1 |  | 1 | 팝업 선택값 반영 |
| F2 | CRUD |  |  | 1 |  |  |  |  |  |  | 1회 저장(변경 감지) |
| A6 | GEN |  |  | 1 |  |  |  |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G4 | DESIGN |  |  |  |  | 1 |  |  |  |  | 조회조건 표시·라벨·활성 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G5 | POPUP |  |  |  |  | 1 |  |  |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  |  | 1 |  |  |  | 팝업 표준·열림 |
| A1 | GEN |  |  |  |  |  |  | 1 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |
| G1 | GEN |  |  |  |  |  |  |  |  | 1 | 조회조건 값 변경 → 조회 인자·결과 반영 |

## W3 동작 수정 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0127-0001 | F2 | SCP0127 화면 | 화면 FE(범위 밖(가이드만)) | F2 FAIL 수정 — SCP0127 화면: 원장 V-db98db04 RULE_SCREEN / 원장 V-b2ba2199 RULE_SCREEN / 원장 V-0d28d9be RULE_SCREEN / 원장 V-02f21913 GENERAL |  | 181 (ACT:SCP0127_PrecedeSafetyStockDay.SaveBu) |
| WK-SCP0127-0002 | A6 | PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY: 원장 V-ca7dfaf3 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['VALUE_TYPE', 'DI |  | 52 (ACT:SCP0127_PrecedeSafetyStockDay.FindBu) |
| WK-SCP0127-0003 | X-ROW | SCP0127_PrecedeSafetyStockDay.FindButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0127_PrecedeSafetyStockDay.FindButton: 진입점 집계 3검사 — REVIEW:1 · FAIL:1 · PASS:1 (FX-SCP0127-020) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.FindBu) |
| WK-SCP0127-0004 | X-ROW | SCP0127_PrecedeSafetyStockDay.FindData_M | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0127_PrecedeSafetyStockDay.FindData_Main: 진입점 집계 14검사 — PASS:8 · NA:3 · REVIEW:1 · FAIL:1 · ERROR:1 (FX-SCP0127 |  | 7 (ACT:SCP0127_PrecedeSafetyStockDay.FindDa) |
| WK-SCP0127-0005 | X-ROW | SCP0127_PrecedeSafetyStockDay.SaveData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0127_PrecedeSafetyStockDay.SaveData: 진입점 집계 27검사 — NA:13 · PASS:11 · ERROR:2 · FAIL:1 (FX-SCP0127-023) |  | 5 (ACT:SCP0127_PrecedeSafetyStockDay.SaveDa) |

## W5 검사기 연결 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0127-0006 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0127_PrecedeSafetyStockDay.InitEv) |
| WK-SCP0127-0007 | G03-WIRE | SCP0127 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0127 화면 | 판단불가(대상 단위 SCREEN) | 10 (ACT:SCP0127_PrecedeSafetyStockDay..ctor ) |
| WK-SCP0127-0008 | G5 | cboDivision / Division / Div / Div. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboDivision / Division / Div / Div. | 있음(FE 소스) | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0127-0009 | H6 | cboDivision / Division / Div / Div. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division / Div / Div. · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |

## W7 기대값 확정 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0127-0010 | A1 | PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0127/SCP0127_GET_ |  | 52 (ACT:SCP0127_PrecedeSafetyStockDay.FindBu) |
| WK-SCP0127-0011 | M4 | cboDivision / Division / Div / Div. | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboDivision / Division / Div / Div.: 검증 엔진이 실행됐으나 이 대상(COND cboDivision)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |

## W9 도구 오류 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0127-0012 | F6 | SCP0127 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-5a6cd9ce RULE_SCREEN / 원장 V-d6ece6ac RULE_SCREEN / 원장 V-8a5762d8 RULE_SCREEN / 원장 V-66a4274e RULE_SCREEN / 원장 V-61 |  | 181 (ACT:SCP0127_PrecedeSafetyStockDay.SaveBu) |
| WK-SCP0127-0013 | I1 | SCP0127 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-b2267fbf RULE_SCREEN / 원장 V-8ddbb6e1 RULE_SCREEN / 원장 V-af8df719 RULE_SCREEN / 원장 V-4d0b3f9e DEFECT / 원장 V-084d9c2 |  | 13 (ACT:SCP0127_PrecedeSafetyStockDay.SaveDa) |
| WK-SCP0127-0014 | G1 | clbPlanGroup / Plan Group | 하네스·환경 | G1 도구 오류 — 원장 V-a6593ee3 SEARCH / E2E smoke cond combo |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.FindDa) |
| WK-SCP0127-0015 | X-ROW | SCP0127_PrecedeSafetyStockDay.ClbDivisio | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.ClbDiv) |
| WK-SCP0127-0016 | X-ROW | SCP0127_PrecedeSafetyStockDay.CreateSpre | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.Create) |
| WK-SCP0127-0017 | X-ROW | SCP0127_PrecedeSafetyStockDay.SetChanged | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0127_PrecedeSafetyStockDay.SetCha) |
| WK-SCP0127-0018 | X-ROW | SCP0127_PrecedeSafetyStockDay.SpdMain_Ce | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — NA:8 · PASS:7 · NOT_RUN:2 · ERROR:1 · NOPATH:1 |  | 2 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |
| WK-SCP0127-0019 | X-ROW | SCP0127_PrecedeSafetyStockDay.setPeriod | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.setPer) |
| WK-SCP0127-0020 | M4 | SCP0127_PrecedeSafetyStockDay.SpdMain_Ce | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 SCP0127_PrecedeSafetyStockDay.SpdMain_CellDoubleClick 의 M4 3요소: NOT_RUN:1 · PASS:1 · NA:1 (미실행 요소가 남아 판정필요 |  | 3 (ACT:SCP0127_PrecedeSafetyStockDay.SpdMai) |

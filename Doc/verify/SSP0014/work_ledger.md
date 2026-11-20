# 작업 원장 — SSP0014 · 2026-11-20 09:48

> 검사 인스턴스 511건 중 PASS·NA 479건 외 **32건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W5 | 검사기 연결 | 1 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 22 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 8 | 원인 해소 → 재판정 |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 22 · 하네스·환경 8 · FE 1 · 하네스 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A1 | GEN |  |  |  |  |  |  | 21 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| B4 | COMBO |  |  |  |  |  |  |  |  | 2 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| F4 | DB |  |  |  |  |  |  |  |  | 2 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| X-ROW | GEN |  |  |  |  |  |  |  |  | 2 | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-REASON | DESIGN |  |  | 1 |  |  |  |  |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A6 | GEN |  |  |  |  | 1 |  |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B2 | COMBO |  |  |  |  |  |  | 1 |  |  | 콤보 후보 중복 없음 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0001 | X-REASON | D00-3-009 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — D00-3-009: [대조표 근거 없음] 요소 '§3 LockColumn / 348 ((0,max) 조회=전체 lock 뷰)' 제외 사유 '조회 직후 전체 lock(뷰 모드) 미이관(Edit 토글 제 |  | 1 (D00-3-009) |

## W5 검사기 연결 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0002 | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 A6(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE ) → 대상 SP PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | 있음(PROC_M) | 1 (SCM0002_ItembyDivisionPopup) |

## W7 기대값 확정 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0003 | B2 | clbFromSite / From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — clbFromSite / From Site: 원장 V-c951c278 SEARCH |  | 1 (D00-1-015) |
| WK-SSP0014-0004 | A1 | 13-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 13-14: 행 집계 — 대조표 13-14 'SmartColMerge(조회후/TopChange)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GE |  | 1 (13-14) |
| WK-SSP0014-0005 | A1 | A#1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A#1: 행 집계 — 대조표 A#1 'cboDivision.SelectedIndexChanged → SetChangedContr' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SC |  | 1 (A#1) |
| WK-SSP0014-0006 | A1 | A#2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A#2: 행 집계 — 대조표 A#2 'btnItemId.Click → SCM0002 팝업' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GET_IT |  | 1 (A#2) |
| WK-SSP0014-0007 | A1 | A-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-1: 행 집계 — 대조표 A-1 'validations' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GET_ITEM — 골든 비교 케이스 없음 |  | 1 (A-1) |
| WK-SSP0014-0008 | A1 | A-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-3: 행 집계 — 대조표 A-3 'events' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GET_ITEM — 골든 비교 케이스 없음(PKG_ |  | 1 (A-3) |
| WK-SSP0014-0009 | A1 | B#1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B#1: 행 집계 — 대조표 B#1 'AS-IS MSG00004 저장 성공(건수) — "{0}개의 데이터가 저장되었습니다."' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0 |  | 1 (B#1) |
| WK-SSP0014-0010 | A1 | B#2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B#2: 행 집계 — 대조표 B#2 'AS-IS MSG00284 저장 실패' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GET_ITEM — 골든  |  | 1 (B#2) |
| WK-SSP0014-0011 | A1 | B#3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B#3: 행 집계 — 대조표 B#3 'AS-IS MSG00251 미등록 사용자 — "GSCM 시스템에 등록되지 않은 사용자 입니' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SC |  | 1 (B#3) |
| WK-SSP0014-0012 | A1 | B-1~B-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B-1~B-7: 행 집계 — 대조표 B-1~B-7 '해당없음(AS-IS 무관)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GET_ITEM — 골 |  | 1 (B-1~B-7) |
| WK-SSP0014-0013 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A1 2요소: REVIEW:1 · PASS:1 |  | 1 (COMMON:UC-02) |
| WK-SSP0014-0014 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL  |  | 1 (COMMON:UC-06) |
| WK-SSP0014-0015 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 2요소: REVIEW:1 · PASS:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0014-0016 | A1 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:SEARCH: 행 집계 — 대조표 CRUD:SEARCH '조회(FindButton→GET SP)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM00 |  | 1 (CRUD:SEARCH) |
| WK-SSP0014-0017 | A1 | D00-1-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-018: 행 집계 — 대조표 D00-1-018 '§1 btnItemId / UsrButton(SCM0002)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002 |  | 1 (D00-1-018) |
| WK-SSP0014-0018 | A1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-001: 행 집계 — 대조표 D00-2-001 '§2 cboDivision / SelectedIndexChanged(FromSite 재조회' 의 A1 2요소: REVIEW:1 · PASS:1 · FAI |  | 1 (D00-2-001) |
| WK-SSP0014-0019 | A1 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-002: 행 집계 — 대조표 D00-2-002 '§2 btnItemId / Click(SCM0002 팝업)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002. |  | 1 (D00-2-002) |
| WK-SSP0014-0020 | A1 | L109#B#+ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L109#B#+: 행 집계 — 대조표 L109#B#+ 'checkRequiredOfSearch(Division 필수)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002. |  | 1 (L109#B#+) |
| WK-SSP0014-0021 | A1 | L110#B#+ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L110#B#+: 행 집계 — 대조표 L110#B#+ 'checkRequiredOfSpread' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GET |  | 1 (L110#B#+) |
| WK-SSP0014-0022 | A1 | L111#B#+ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L111#B#+: 행 집계 — 대조표 L111#B#+ 'SetDivisionAuthCheck(권한 Division 0건)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM000 |  | 1 (L111#B#+) |
| WK-SSP0014-0023 | A1 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SSP0014-0024 | A1 | ProgressForm(FindData/SaveData) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ProgressForm(FindData/SaveData): 행 집계 — 대조표 ProgressForm(FindData/SaveData) '2' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: |  | 1 (ProgressForm(FindData/SaveData)) |

## W9 도구 오류 (8)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0025 | B4 | cboOperationGroup / Operation Group / Op | 하네스·환경 | B4 도구 오류 — 원장 V-62f2170d SEARCH |  | 1 (D00-1-014) |
| WK-SSP0014-0026 | B4 | clbFromSite / From Site | 하네스·환경 | B4 도구 오류 — 원장 V-0db2d553 SEARCH |  | 1 (D00-1-015) |
| WK-SSP0014-0027 | K4 | SSP0014 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-aea2e384 GENERAL / 원장 V-1adc78a7 GENERAL / 원장 V-924a173e GENERAL / 원장 V-7c98aee0 GENERAL / 원장 V-8efd43f7 GENERAL / |  | 17 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SSP0014-0028 | F1 | SSP0014 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-45fe7803 RULE_SCREEN / 원장 V-9bcbf1f5 RULE_SCREEN / 원장 V-5473aa5a RULE_SCREEN / 원장 V-504dee98 RULE_SCREEN / 원장 V-62 |  | 109 (CRUD:SAVE CRUD:DELETE COMMON:UC-04 B#1 B) |
| WK-SSP0014-0029 | F4 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 하네스·환경 | F4 도구 오류 — 실측[T-bab6f023]: PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: SCM0002/ModelPopup/SEARCH, SCP0033/popup/SEARCH, SSP0 |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SSP0014-0030 | F4 | ProgressForm(FindData/SaveData) | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 ProgressForm(FindData/SaveData) '2' 의 F4 4요소: PASS:3 · ERROR:1 |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0031 | X-ROW | SSP0014_ShipmentModelPIC.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — PASS:14 · ERROR:1 · NA:1 |  | 3 (ACT:SSP0014_ShipmentModelPIC.SaveData:38) |
| WK-SSP0014-0032 | X-ROW | SSP0014_ShipmentModelPIC.btnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:6 · NA:2 · ERROR:1 |  | 5 (ACT:SSP0014_ShipmentModelPIC.btnItemId_C) |

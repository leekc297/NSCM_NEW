# 작업 원장 — SSP0014 · 2026-11-14 21:23

> 검사 인스턴스 501건 중 PASS·NA 313건 외 **188건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 6 | 재판정 PASS |
| W5 | 검사기 연결 | 3 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 46 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 132 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 132 · 사람 판정 / AS-IS 원문 확인 → 재판정 40 · 대조표 6 · DB 메타 5 · 하네스 3 · 화면 FE 1 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| G5 | POPUP |  |  |  |  | 1 |  |  |  | 30 | 팝업 조건 연동(인자) |
| X-LOC | GEN |  |  |  |  |  |  | 21 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A1 | GEN |  |  |  |  |  |  | 17 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  |  |  |  | 17 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 12 | 연쇄 자동 채움 |
| X-ROW | GEN |  |  |  |  |  |  |  |  | 12 | 대조표 행이 서술한 동작을 화면에서 재현 |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 10 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| D4 | EDIT |  |  |  |  |  |  |  |  | 10 | 신규행 기본값·자동세팅·Insert 전제 |
| H5 | DESIGN |  |  |  |  |  |  |  |  | 9 | 라벨 명칭 |
| H6 | POPUP |  |  |  |  |  | 1 |  |  | 5 | 팝업 표준·열림 |
| X-REASON | DESIGN |  |  |  |  |  |  | 6 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| D1 | EDIT |  |  | 5 |  |  |  |  |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| B4 | COMBO |  |  |  |  |  |  |  |  | 5 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B2 | COMBO |  |  | 1 |  |  |  |  |  | 3 | 콤보 후보 중복 없음 |
| E4 | EDIT |  |  |  |  |  |  |  |  | 4 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A6 | GEN |  |  |  |  |  |  | 1 |  | 2 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B1 | COMBO |  |  |  |  |  |  |  |  | 3 | 콤보 후보 빈 행 없음 |
| F4 | DB |  |  |  |  |  |  |  |  | 3 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G4 | DESIGN |  |  |  |  | 1 |  |  |  |  | 조회조건 표시·라벨·활성 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| M4 | POPUP |  |  |  |  |  |  | 1 |  |  | 팝업 선택값 반영 |
| B3 | COMBO |  |  |  |  |  |  |  |  | 1 | 콤보 후보 정렬 = AS-IS |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |

## W3 동작 수정 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0001 | B2 | clbFromSite / From Site | 화면 FE(범위 밖(가이드만)) | B2 FAIL 수정 — clbFromSite / From Site: 원장 V-c951c278 SEARCH (FX-SSP0014-003) |  | 1 (D00-1-015) |
| WK-SSP0014-0002 | D1 | B-1~B-7 | DB 메타(적용 예정) | D1 FAIL 수정 — B-1~B-7: 행 집계 — 대조표 B-1~B-7 '해당없음(AS-IS 무관)' 의 D1 14요소: PASS:8 · FAIL:4 · NA:2 · FAIL 요소: DIVISION_ID / Division — 원장 |  | 1 (B-1~B-7) |
| WK-SSP0014-0003 | D1 | DIVISION_ID / Division | DB 메타(적용 예정) | D1 FAIL 수정 — DIVISION_ID / Division: 원장 V-6784cbc4 COLUMN / 실측[T-89b09392]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank |  | 1 (D00-3-003) |
| WK-SSP0014-0004 | D1 | FROM_SITE / From Site | DB 메타(적용 예정) | D1 FAIL 수정 — FROM_SITE / From Site: 원장 V-d61664b1 COLUMN / 실측[T-69d4500f]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank. |  | 1 (D00-3-003) |
| WK-SSP0014-0005 | D1 | ITEM_ID / Model | DB 메타(적용 예정) | D1 FAIL 수정 — ITEM_ID / Model: 원장 V-f3e00fd4 COLUMN / 실측[T-401cfb8f]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)]  |  | 1 (D00-3-003) |
| WK-SSP0014-0006 | D1 | OPERATION_GROUP / Operation Group | DB 메타(적용 예정) | D1 FAIL 수정 — OPERATION_GROUP / Operation Group: 원장 V-849c95fd COLUMN / 실측[T-9d8a5eb7]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_ |  | 1 (D00-3-003) |

## W5 검사기 연결 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0007 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SSP0014_ShipmentModelPIC.InitEvent A) |
| WK-SSP0014-0008 | G03-WIRE | SSP0014 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0014 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:SSP0014_ShipmentModelPIC..ctor ACT:S) |
| WK-SSP0014-0009 | G5 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 1 (SCM0002_ItembyDivisionPopup) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0010 | H6 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbFromSite / From Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (SCM0002_ItembyDivisionPopup) |

## W7 기대값 확정 (46)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0011 | X-REASON | D00-1-022 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-022 §1 usrButton1 / UsrButton(ButtonAccessType=None, 미배치) — AS-IS 렌더 안 함(미배치 헬퍼 버튼). TO-BE 대상 아님(00 §1 근거 |  | 1 (D00-1-022) |
| WK-SSP0014-0012 | X-REASON | D00-2-004 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-004 §2 spdMain / TopChange(스크롤 재병합) components/ShipmentModelPicGrid.tsx:124~136 (공용 DataGrid 스크롤 병합 관장) 스 |  | 1 (D00-2-004) |
| WK-SSP0014-0013 | X-REASON | D00-3-001 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-001 §3 SmartColMerge / 223 (InitSpread 초기병합) components/ShipmentModelPicGrid.tsx:124~136 (공용 DataGrid 병합) |  | 1 (D00-3-001) |
| WK-SSP0014-0014 | X-REASON | D00-3-009 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-009 §3 LockColumn / 348 ((0,max) 조회=전체 lock 뷰) 제외 — Edit 토글 제거로 조회 후 뷰 lock 없음. lock 은 컬럼메타(13열 'S')로만 유지 |  | 1 (D00-3-009) |
| WK-SSP0014-0015 | X-REASON | D00-3-013 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-013 §3 SmartColMerge / 364 (조회 후 병합) components/ShipmentModelPicGrid.tsx:124~136 (공용 DataGrid 병합) 조회 후 병합 |  | 1 (D00-3-013) |
| WK-SSP0014-0016 | X-REASON | D00-3-014 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-014 §3 SmartColMerge / 622 (TopChange 재병합) components/ShipmentModelPicGrid.tsx:124~136 (공용 DataGrid 병합) 스 |  | 1 (D00-3-014) |
| WK-SSP0014-0017 | A1 | + | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — +: 행 집계 — 대조표 + 'SetDivisionAuthCheck(권한 Division 0건)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GE |  | 1 (+) |
| WK-SSP0014-0018 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — 대조표 1 'SmartColMerge(InitSpread)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GET_ITEM — 골든 |  | 0 () |
| WK-SSP0014-0019 | A1 | 13-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 13-14: 행 집계 — 대조표 13-14 'SmartColMerge(조회후/TopChange)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GE |  | 1 (13-14) |
| WK-SSP0014-0020 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — 대조표 2 'SwitchLock(EditButton)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GET_ITEM — 골든 비교 |  | 0 () |
| WK-SSP0014-0021 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — 대조표 3 'AS-IS MSG00251 미등록 사용자 — "GSCM 시스템에 등록되지 않은 사용자 입니' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM000 |  | 1 (3) |
| WK-SSP0014-0022 | A1 | A-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-1: 행 집계 — 대조표 A-1 'validations' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GET_ITEM — 골든 비교 케이스 없음 |  | 1 (A-1) |
| WK-SSP0014-0023 | A1 | A-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-3: 행 집계 — 대조표 A-3 'events' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GET_ITEM — 골든 비교 케이스 없음(PKG_ |  | 1 (A-3) |
| WK-SSP0014-0024 | A1 | B-1~B-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B-1~B-7: 행 집계 — 대조표 B-1~B-7 '해당없음(AS-IS 무관)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM0002_GET_ITEM — 골 |  | 1 (B-1~B-7) |
| WK-SSP0014-0025 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A1 2요소: REVIEW:1 · PASS:1 |  | 1 (COMMON:UC-02) |
| WK-SSP0014-0026 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL  |  | 1 (COMMON:UC-06) |
| WK-SSP0014-0027 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 2요소: REVIEW:1 · PASS:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0014-0028 | A1 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:SEARCH: 행 집계 — 대조표 CRUD:SEARCH '조회(FindButton→GET SP)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002.P_SCM00 |  | 1 (CRUD:SEARCH) |
| WK-SSP0014-0029 | A1 | D00-1-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-018: 행 집계 — 대조표 D00-1-018 '§1 btnItemId / UsrButton(SCM0002)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002 |  | 1 (D00-1-018) |
| WK-SSP0014-0030 | A1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-001: 행 집계 — 대조표 D00-2-001 '§2 cboDivision / SelectedIndexChanged(FromSite 재조회' 의 A1 2요소: REVIEW:1 · PASS:1 · FAI |  | 1 (D00-2-001) |
| WK-SSP0014-0031 | A1 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-002: 행 집계 — 대조표 D00-2-002 '§2 btnItemId / Click(SCM0002 팝업)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCM0002. |  | 1 (D00-2-002) |
| WK-SSP0014-0032 | A1 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SSP0014-0033 | A1 | ProgressForm(FindData/SaveData) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ProgressForm(FindData/SaveData): 행 집계 — 대조표 ProgressForm(FindData/SaveData) '2' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0034 | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 검증 엔진이 실행됐으나 이 대상(SP PKG_SCM0002.P_SCM0002_GET_ITEM)을 판정하지 못함 — 결과 행 |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SSP0014-0035 | X-LOC | + | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — +: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (+) |
| WK-SSP0014-0036 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SSP0014-0037 | X-LOC | 10-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10-12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10-12) |
| WK-SSP0014-0038 | X-LOC | 13-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 13-14: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (13-14) |
| WK-SSP0014-0039 | X-LOC | 15-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 15-22: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (15-22) |
| WK-SSP0014-0040 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-SSP0014-0041 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SSP0014-0042 | X-LOC | 3-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3-7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3-7) |
| WK-SSP0014-0043 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SSP0014-0044 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SSP0014-0045 | X-LOC | A-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — A-1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (A-1) |
| WK-SSP0014-0046 | X-LOC | A-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — A-3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (A-3) |
| WK-SSP0014-0047 | X-LOC | A-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — A-5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (A-5) |
| WK-SSP0014-0048 | X-LOC | B-1~B-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — B-1~B-7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (B-1~B-7) |
| WK-SSP0014-0049 | X-LOC | Division* | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division*: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division*) |
| WK-SSP0014-0050 | X-LOC | From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — From Site: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (From Site) |
| WK-SSP0014-0051 | X-LOC | Operation Group | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Operation Group: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Operation Group) |
| WK-SSP0014-0052 | X-LOC | ProgressForm(FindData/SaveData) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ProgressForm(FindData/SaveData): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0053 | X-LOC | SCM0002_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCM0002_ItembyDivisionPopup: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SSP0014-0054 | X-LOC | UserInfoPopup(USER_ID/PART/TEAM/MAIL1~5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — UserInfoPopup(USER_ID/PART/TEAM/MAIL1~5): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (UserInfoPopup(USER_ID/PART/TEAM/MAIL1~5)) |
| WK-SSP0014-0055 | X-LOC | Valid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Valid: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Valid) |
| WK-SSP0014-0056 | M4 | clbFromSite / From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — clbFromSite / From Site: 검증 엔진이 실행됐으나 이 대상(COND clbFromSite)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (SCM0002_ItembyDivisionPopup) |

## W9 도구 오류 (132)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0014-0057 | C3 | MAIL_USER1 / Mail User1 | 하네스·환경 | C3 도구 오류 — 실측[T-23be6f89]: MAIL_USER1 연쇄 원천 컬럼 해석 불가 — AS-IS InitSpread:229 siMain.ActiveSheet.Columns[DefColumns.MAIL_USER1].Cell |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0058 | C3 | MAIL_USER2 / Mail User2 | 하네스·환경 | C3 도구 오류 — 실측[T-1fe84ed3]: MAIL_USER2 연쇄 원천 컬럼 해석 불가 — AS-IS InitSpread:230 siMain.ActiveSheet.Columns[DefColumns.MAIL_USER2].Cell |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0059 | C3 | MAIL_USER3 / Mail User3 | 하네스·환경 | C3 도구 오류 — 실측[T-f91b5ced]: MAIL_USER3 연쇄 원천 컬럼 해석 불가 — AS-IS InitSpread:231 siMain.ActiveSheet.Columns[DefColumns.MAIL_USER3].Cell |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0060 | C3 | MAIL_USER4 / Mail User4 | 하네스·환경 | C3 도구 오류 — 실측[T-01c956ac]: MAIL_USER4 연쇄 원천 컬럼 해석 불가 — AS-IS InitSpread:232 siMain.ActiveSheet.Columns[DefColumns.MAIL_USER4].Cell |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0061 | C3 | MAIL_USER5 / Mail User5 | 하네스·환경 | C3 도구 오류 — 실측[T-8c99afdd]: MAIL_USER5 연쇄 원천 컬럼 해석 불가 — AS-IS InitSpread:233 siMain.ActiveSheet.Columns[DefColumns.MAIL_USER5].Cell |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0062 | C3 | OPERATION_GROUP / Operation Group | 하네스·환경 | C3 도구 오류 — 실측[T-3443e90f]: OPERATION_GROUP 연쇄 원천 컬럼 해석 불가 — AS-IS FindData_Main:358 siMain.SetValue(i, siMain.GetColumnIndex(DefCo |  | 5 (ACT:SSP0014_ShipmentModelPIC.FindData_Ma) |
| WK-SSP0014-0063 | C3 | PART_LEADER / Part Leader | 하네스·환경 | C3 도구 오류 — 실측[T-0de8f686]: PART_LEADER 연쇄 원천 컬럼 해석 불가 — AS-IS InitSpread:226 siMain.ActiveSheet.Columns[DefColumns.PART_LEADER].Ce |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0064 | C3 | SSP0014_ShipmentModelPIC.CboDivision_Sel | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0014_ShipmentModelPIC.CboDivision_SelectedIndexChanged 의 C3 9요소: ERROR:9 |  | 1 (ACT:SSP0014_ShipmentModelPIC.CboDivision) |
| WK-SSP0014-0065 | C3 | SSP0014_ShipmentModelPIC.SetChangeContro | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0014_ShipmentModelPIC.SetChangeControl 의 C3 2요소: ERROR:2 |  | 2 (ACT:SSP0014_ShipmentModelPIC.SetChangeCo) |
| WK-SSP0014-0066 | C3 | SSP0014_ShipmentModelPIC.SetChangedContr | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0014_ShipmentModelPIC.SetChangedControl 의 C3 9요소: ERROR:9 |  | 0 () |
| WK-SSP0014-0067 | C3 | TEAM_LEADER / Team Leader | 하네스·환경 | C3 도구 오류 — 실측[T-299891aa]: TEAM_LEADER 연쇄 원천 컬럼 해석 불가 — AS-IS InitSpread:227 siMain.ActiveSheet.Columns[DefColumns.TEAM_LEADER].Ce |  | 2 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0068 | C3 | USER_ID / User ID | 하네스·환경 | C3 도구 오류 — 실측[T-3a988f9b]: USER_ID 연쇄 원천 컬럼 해석 불가 — AS-IS InitSpread:225 siMain.ActiveSheet.Columns[DefColumns.USER_ID].CellType = |  | 8 (ACT:SSP0014_ShipmentModelPIC.InitSpread:) |
| WK-SSP0014-0069 | B1 | FROM_SITE / From Site | 하네스·환경 | B1 도구 오류 — 원장 V-bf039e79 COLUMN |  | 1 (COMMON:UC-05) |
| WK-SSP0014-0070 | B1 | OPERATION_GROUP / Operation Group | 하네스·환경 | B1 도구 오류 — 원장 V-62b2d88c COLUMN |  | 1 (COMMON:UC-05) |
| WK-SSP0014-0071 | B1 | VALID_YN / Valid | 하네스·환경 | B1 도구 오류 — 원장 V-554a3323 COLUMN |  | 1 (COMMON:UC-05) |
| WK-SSP0014-0072 | B2 | FROM_SITE / From Site | 하네스·환경 | B2 도구 오류 — 원장 V-c8ca1844 COLUMN |  | 1 (COMMON:UC-05) |
| WK-SSP0014-0073 | B2 | OPERATION_GROUP / Operation Group | 하네스·환경 | B2 도구 오류 — 원장 V-288052e4 COLUMN |  | 1 (COMMON:UC-05) |
| WK-SSP0014-0074 | B2 | VALID_YN / Valid | 하네스·환경 | B2 도구 오류 — 원장 V-e4b056e1 COLUMN |  | 1 (COMMON:UC-05) |
| WK-SSP0014-0075 | B3 | OPERATION_GROUP / Operation Group | 하네스·환경 | B3 도구 오류 — 원장 V-2177460f COLUMN |  | 2 (Operation Group ACT:SSP0014_ShipmentMode) |
| WK-SSP0014-0076 | B4 | FROM_SITE / From Site | 하네스·환경 | B4 도구 오류 — 원장 V-331571e7 COLUMN |  | 1 (COMMON:UC-05) |
| WK-SSP0014-0077 | B4 | OPERATION_GROUP / Operation Group | 하네스·환경 | B4 도구 오류 — 원장 V-3b3152f7 COLUMN |  | 3 (COMMON:UC-05 Operation Group ACT:SSP0014) |
| WK-SSP0014-0078 | B4 | VALID_YN / Valid | 하네스·환경 | B4 도구 오류 — 원장 V-e64cb16c COLUMN |  | 1 (COMMON:UC-05) |
| WK-SSP0014-0079 | B4 | cboOperationGroup / Operation Group / Op | 하네스·환경 | B4 도구 오류 — 원장 V-62f2170d SEARCH |  | 1 (D00-1-014) |
| WK-SSP0014-0080 | B4 | clbFromSite / From Site | 하네스·환경 | B4 도구 오류 — 원장 V-0db2d553 SEARCH |  | 1 (D00-1-015) |
| WK-SSP0014-0081 | K4 | SSP0014 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-aea2e384 GENERAL / 원장 V-1adc78a7 GENERAL / 원장 V-924a173e GENERAL / 원장 V-7c98aee0 GENERAL / 원장 V-8efd43f7 GENERAL / |  | 17 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SSP0014-0082 | F1 | SSP0014 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-45fe7803 RULE_SCREEN / 원장 V-9bcbf1f5 RULE_SCREEN / 원장 V-5473aa5a RULE_SCREEN / 원장 V-504dee98 RULE_SCREEN / 원장 V-62 |  | 107 (CRUD:SAVE CRUD:DELETE COMMON:UC-04 Progr) |
| WK-SSP0014-0083 | F2 | SSP0014 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-2dd4a9bd RULE_SCREEN / 원장 V-947085e8 RULE_SCREEN / 원장 V-86458d2d GENERAL / 원장 V-8f1720d8 GENERAL / 원장 V-483fff42 G |  | 105 (CRUD:SAVE COMMON:UC-04 A-1 A-3 A-5 B-1~B) |
| WK-SSP0014-0084 | F6 | SSP0014 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-244ceb9e RULE_SCREEN / 원장 V-6ea977f3 RULE_SCREEN / 원장 V-01c25404 RULE_SCREEN / 원장 V-09388b3d RULE_SCREEN / 원장 V-65 |  | 100 (ProgressForm(FindData/SaveData) ACT:SSP0) |
| WK-SSP0014-0085 | F4 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 하네스·환경 | F4 도구 오류 — 실측[T-bab6f023]: PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: SCM0002/ModelPopup/SEARCH, SCP0033/popup/SEARCH, SSP0 |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SSP0014-0086 | F4 | PKG_SSP0014.P_SSP0014_GET_USER_ID_CHECK | 하네스·환경 | F4 도구 오류 — 실측[T-247065c7]: PKG_SSP0014.P_SSP0014_GET_USER_ID_CHECK: SSP0014/main/USER_CHECK — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 |  | 100 (ACT:SSP0014_ShipmentModelPIC.GetUserIDCh) |
| WK-SSP0014-0087 | F4 | ProgressForm(FindData/SaveData) | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 ProgressForm(FindData/SaveData) '2' 의 F4 4요소: ERROR:2 · PASS:1 · NA:1 |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0088 | A5 | 1 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 1 'SmartColMerge(InitSpread)' 의 A5 10요소: PASS:9 · ERROR:1 |  | 1 (1) |
| WK-SSP0014-0089 | A5 | 13-14 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 13-14 'SmartColMerge(조회후/TopChange)' 의 A5 10요소: PASS:9 · ERROR:1 |  | 1 (13-14) |
| WK-SSP0014-0090 | A5 | 4 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 4 'spdMain.TopChange → 스크롤 재병합' 의 A5 10요소: PASS:9 · ERROR:1 |  | 1 (4) |
| WK-SSP0014-0091 | A5 | COMMON:UC-02 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A5 10요소: PASS:9 · ERROR:1 |  | 1 (COMMON:UC-02) |
| WK-SSP0014-0092 | A5 | COMMON:UC-07 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A5 10요소: PASS:9 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0014-0093 | A5 | D00-1-003 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-003 '§1 usrConditionPanel1 / UsrConditionPanel(HidePane' 의 A5 10요소: PASS:9 · ERROR:1 |  | 1 (D00-1-003) |
| WK-SSP0014-0094 | A5 | D00-1-009 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-009 '§1 layoutControlItem4 / LayoutControlItem(btnItemI' 의 A5 10요소: PASS:9 · ERROR:1 |  | 1 (D00-1-009) |
| WK-SSP0014-0095 | A5 | D00-1-020 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-020 '§1 spdMain / FpSpread(메인 그리드)' 의 A5 10요소: PASS:9 · ERROR:1 |  | 1 (D00-1-020) |
| WK-SSP0014-0096 | A5 | D00-1-021 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-021 '§1 spdMain_Sheet1 / SheetView(시트)' 의 A5 10요소: PASS:9 · ERROR:1 |  | 1 (D00-1-021) |
| WK-SSP0014-0097 | A5 | DIVISION | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-0bba9c32]: DIVISION: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 1 (3-7) |
| WK-SSP0014-0098 | H10 | SSP0014 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 8 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SSP0014-0099 | H4 | SSP0014 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-eadcb5d4 RULE_SCREEN / 원장 V-8e7f1026 RULE_SCREEN / 원장 V-3e6746b8 RULE_SCREEN / 원장 V-d86a6b7c RULE_SCREEN / 원장 V-35 |  | 6 (4 13-14 ACT:SSP0014_ShipmentModelPIC.Spd) |
| WK-SSP0014-0100 | H5 | 1 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 1 'SmartColMerge(InitSpread)' 의 H5 10요소: PASS:9 · ERROR:1 |  | 1 (1) |
| WK-SSP0014-0101 | H5 | 13-14 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 13-14 'SmartColMerge(조회후/TopChange)' 의 H5 10요소: PASS:9 · ERROR:1 |  | 1 (13-14) |
| WK-SSP0014-0102 | H5 | 4 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 4 'spdMain.TopChange → 스크롤 재병합' 의 H5 10요소: PASS:9 · ERROR:1 |  | 1 (4) |
| WK-SSP0014-0103 | H5 | COMMON:UC-02 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 H5 10요소: PASS:9 · ERROR:1 |  | 1 (COMMON:UC-02) |
| WK-SSP0014-0104 | H5 | COMMON:UC-07 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H5 10요소: PASS:9 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0014-0105 | H5 | D00-1-020 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-020 '§1 spdMain / FpSpread(메인 그리드)' 의 H5 10요소: PASS:9 · ERROR:1 |  | 1 (D00-1-020) |
| WK-SSP0014-0106 | H5 | D00-1-021 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-021 '§1 spdMain_Sheet1 / SheetView(시트)' 의 H5 10요소: PASS:9 · ERROR:1 |  | 1 (D00-1-021) |
| WK-SSP0014-0107 | H5 | DIVISION | 하네스·환경 | H5 도구 오류 — 실측[T-86e85805]: DIVISION 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (3-7) |
| WK-SSP0014-0108 | H5 | SSP0014_ShipmentModelPIC.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0014_ShipmentModelPIC.CreateSpread 의 H5 10요소: PASS:9 · ERROR:1 |  | 4 (ACT:SSP0014_ShipmentModelPIC.CreateSprea) |
| WK-SSP0014-0109 | D4 | CRUD:INSERT | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 CRUD:INSERT '신규행(InsertButton)' 의 D4 9요소: ERROR:9 |  | 1 (CRUD:INSERT) |
| WK-SSP0014-0110 | D4 | MAIL_USER1 / Mail User1 | 하네스·환경 | D4 도구 오류 — 실측[T-e49d499d]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (D00-3-018) |
| WK-SSP0014-0111 | D4 | MAIL_USER2 / Mail User2 | 하네스·환경 | D4 도구 오류 — 실측[T-956fded6]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (D00-3-019) |
| WK-SSP0014-0112 | D4 | MAIL_USER3 / Mail User3 | 하네스·환경 | D4 도구 오류 — 실측[T-62d64184]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (D00-3-020) |
| WK-SSP0014-0113 | D4 | MAIL_USER4 / Mail User4 | 하네스·환경 | D4 도구 오류 — 실측[T-c4668fe0]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (D00-3-021) |
| WK-SSP0014-0114 | D4 | MAIL_USER5 / Mail User5 | 하네스·환경 | D4 도구 오류 — 실측[T-8fba0868]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (D00-3-022) |
| WK-SSP0014-0115 | D4 | OPERATION_GROUP / Operation Group | 하네스·환경 | D4 도구 오류 — 실측[T-e5b858cc]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (D00-3-011 10-12 Operation Group) |
| WK-SSP0014-0116 | D4 | PART_LEADER / Part Leader | 하네스·환경 | D4 도구 오류 — 실측[T-9dfd7d79]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (D00-3-016) |
| WK-SSP0014-0117 | D4 | TEAM_LEADER / Team Leader | 하네스·환경 | D4 도구 오류 — 실측[T-72273c1d]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (D00-3-017) |
| WK-SSP0014-0118 | D4 | USER_ID / User ID | 하네스·환경 | D4 도구 오류 — 실측[T-04057317]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (D00-3-015 15-22) |
| WK-SSP0014-0119 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-339a10c5 ASIS / 실측[T-927730ac]: MSG00004: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 ERROR: [측정 경로 누락] Insert 버튼 없음(수 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SaveData:52) |
| WK-SSP0014-0120 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-339a10c5 / 실측[T-de1acc73]: MSG00004: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 ERROR: [측정 경로 누락] Insert 버튼 없음(수정 저장형 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SaveData:52) |
| WK-SSP0014-0121 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-28e0310f ASIS / 실측[T-01a15dbe]: MSG00284: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 ERROR: [측정 경로 누락] Insert 버튼 없음(수 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SaveData:54) |
| WK-SSP0014-0122 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-28e0310f / 실측[T-64d2c285]: MSG00284: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 ERROR: [측정 경로 누락] Insert 버튼 없음(수정 저장형 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SaveData:54) |
| WK-SSP0014-0123 | A6 | ProgressForm(FindData/SaveData) | 하네스·환경 | A6 도구 오류 — 행 집계 — 대조표 ProgressForm(FindData/SaveData) '2' 의 A6 2요소: NOT_RUN:1 · ERROR:1 |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0124 | A6 | SSP0014_GET_SHIPMENT_MODEL_PIC | 하네스·환경 | A6 도구 오류 — 원장 V-2d3318b4 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측 순서대조 PASS 공통 5152행(Doc/golden/SSP0014/SSP0014 |  | 46 (ACT:SSP0014_ShipmentModelPIC.FindButton ) |
| WK-SSP0014-0125 | G1 | + | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 + 'SetDivisionAuthCheck(권한 Division 0건)' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (+) |
| WK-SSP0014-0126 | G1 | 1 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 1 'SmartColMerge(InitSpread)' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 0 () |
| WK-SSP0014-0127 | G1 | 13-14 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 13-14 'SmartColMerge(조회후/TopChange)' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (13-14) |
| WK-SSP0014-0128 | G1 | 2 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 2 'SwitchLock(EditButton)' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 0 () |
| WK-SSP0014-0129 | G1 | 3 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 3 'AS-IS MSG00251 미등록 사용자 — "GSCM 시스템에 등록되지 않은 사용자 입니' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (3) |
| WK-SSP0014-0130 | G1 | A-1 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 A-1 'validations' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (A-1) |
| WK-SSP0014-0131 | G1 | A-3 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 A-3 'events' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (A-3) |
| WK-SSP0014-0132 | G1 | B-1~B-7 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 B-1~B-7 '해당없음(AS-IS 무관)' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (B-1~B-7) |
| WK-SSP0014-0133 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-02) |
| WK-SSP0014-0134 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-06) |
| WK-SSP0014-0135 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0014-0136 | G1 | CRUD:SEARCH | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 CRUD:SEARCH '조회(FindButton→GET SP)' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (CRUD:SEARCH) |
| WK-SSP0014-0137 | G1 | D00-1-001 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-001 '§1 usrLayoutControl2 / UsrLayoutControl' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (D00-1-001) |
| WK-SSP0014-0138 | G1 | D00-1-003 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-003 '§1 usrConditionPanel1 / UsrConditionPanel(HidePane' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (D00-1-003) |
| WK-SSP0014-0139 | G1 | D00-1-018 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-018 '§1 btnItemId / UsrButton(SCM0002)' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (D00-1-018) |
| WK-SSP0014-0140 | G1 | D00-2-002 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-002 '§2 btnItemId / Click(SCM0002 팝업)' 의 G1 6요소: PASS:4 · ERROR:1 · NA:1 |  | 1 (D00-2-002) |
| WK-SSP0014-0141 | G1 | clbFromSite / From Site | 하네스·환경 | G1 도구 오류 — 원장 V-ccba28ce SEARCH / E2E smoke cond combo |  | 3 (D00-1-015 ACT:SSP0014_ShipmentModelPIC.F) |
| WK-SSP0014-0142 | X-ROW | SSP0014_ShipmentModelPIC.CboDivision_Sel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0014_ShipmentModelPIC.CboDivision) |
| WK-SSP0014-0143 | X-ROW | SSP0014_ShipmentModelPIC.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0014_ShipmentModelPIC.CreateSprea) |
| WK-SSP0014-0144 | X-ROW | SSP0014_ShipmentModelPIC.FindButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — PASS:2 · ERROR:1 |  | 1 (ACT:SSP0014_ShipmentModelPIC.FindButton) |
| WK-SSP0014-0145 | X-ROW | SSP0014_ShipmentModelPIC.FindData_Main | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — PASS:10 · ERROR:3 · NA:3 |  | 8 (ACT:SSP0014_ShipmentModelPIC.FindData_Ma) |
| WK-SSP0014-0146 | X-ROW | SSP0014_ShipmentModelPIC.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 41검사 — PASS:33 · ERROR:8 |  | 10 (ACT:SSP0014_ShipmentModelPIC.InitSpread ) |
| WK-SSP0014-0147 | X-ROW | SSP0014_ShipmentModelPIC.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — ERROR:8 · PASS:6 · NA:2 |  | 3 (ACT:SSP0014_ShipmentModelPIC.SaveData:38) |
| WK-SSP0014-0148 | X-ROW | SSP0014_ShipmentModelPIC.SetChangeContro | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:5 · NA:3 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SetChangeCo) |
| WK-SSP0014-0149 | X-ROW | SSP0014_ShipmentModelPIC.SetChangedContr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:3 · PASS:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0014_ShipmentModelPIC.SetChangedC) |
| WK-SSP0014-0150 | X-ROW | SSP0014_ShipmentModelPIC.SetImageCell | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — PASS:4 · NA:1 · ERROR:1 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SetImageCel) |
| WK-SSP0014-0151 | X-ROW | SSP0014_ShipmentModelPIC.SpdMain_CellDou | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 83검사 — PASS:44 · ERROR:33 · NA:6 |  | 56 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0152 | X-ROW | SSP0014_ShipmentModelPIC.SpdMain_TopChan | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Top) |
| WK-SSP0014-0153 | X-ROW | SSP0014_ShipmentModelPIC.btnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:5 · NA:3 · ERROR:1 |  | 5 (ACT:SSP0014_ShipmentModelPIC.btnItemId_C) |
| WK-SSP0014-0154 | G5 | 3 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 3 'AS-IS MSG00251 미등록 사용자 — "GSCM 시스템에 등록되지 않은 사용자 입니' 의 G5 29요소: ERROR:24 · NA:4 · NOPATH:1 |  | 0 () |
| WK-SSP0014-0155 | G5 | D00-2-003 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-2-003 '§2 spdMain / CellDoubleClick(UserInfoPopup)' 의 G5 29요소: ERROR:24 · NA:4 · NOPATH:1 |  | 1 (D00-2-003) |
| WK-SSP0014-0156 | G5 | MAIL_USER1 / Mail User1 | 하네스·환경 | G5 도구 오류 — 원장 V-6ad1182d ASIS / 원장 V-c4ea73fb ASIS |  | 14 (D00-3-018 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0157 | G5 | MAIL_USER2 / Mail User2 | 하네스·환경 | G5 도구 오류 — 원장 V-9bbebfe3 ASIS / 원장 V-56fc463e ASIS |  | 14 (D00-3-019 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0158 | G5 | MAIL_USER3 / Mail User3 | 하네스·환경 | G5 도구 오류 — 원장 V-8a43cba5 ASIS / 원장 V-456975c2 ASIS |  | 14 (D00-3-020 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0159 | G5 | MAIL_USER4 / Mail User4 | 하네스·환경 | G5 도구 오류 — 원장 V-113d1799 ASIS / 원장 V-e88e29a7 ASIS |  | 14 (D00-3-021 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0160 | G5 | MAIL_USER5 / Mail User5 | 하네스·환경 | G5 도구 오류 — 원장 V-92b73e23 ASIS / 원장 V-a66510d8 ASIS |  | 13 (D00-3-022 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0161 | G5 | MODAL:ItemByDivisionModal | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 MODAL:ItemByDivisionModal 'AS-IS SCM0002_ItembyDivisionPopup(Model 검색, divisi' 의 G5 29요소: ERROR:24 · NA:4 ·  |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0014-0162 | G5 | MODAL:SsoUserModal | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 MODAL:SsoUserModal 'AS-IS UserInfoPopup(이미지셀 7 공유, SingleSelectYn)' 의 G5 29요소: ERROR:24 · NA:4 · NOPATH:1 |  | 1 (MODAL:SsoUserModal) |
| WK-SSP0014-0163 | G5 | PART_LEADER / Part Leader | 하네스·환경 | G5 도구 오류 — 원장 V-dfb225ee ASIS / 원장 V-51cca87a ASIS |  | 14 (D00-3-016 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0164 | G5 | ProgressForm(FindData/SaveData) | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 ProgressForm(FindData/SaveData) '2' 의 G5 29요소: ERROR:24 · NA:4 · NOPATH:1 |  | 1 (ProgressForm(FindData/SaveData)) |
| WK-SSP0014-0165 | G5 | SSP0014_ShipmentModelPIC.SpdMain_CellDou | 하네스·환경 | G5 도구 오류 — 원장 V-84d25ca8 ASIS / 원장 V-11a4fcdf ASIS / 원장 V-dfb225ee ASIS / 원장 V-51cca87a ASIS / 원장 V-b70eeccb ASIS / 원장 V-969965a4  |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0166 | G5 | TEAM_LEADER / Team Leader | 하네스·환경 | G5 도구 오류 — 원장 V-b70eeccb ASIS / 원장 V-969965a4 ASIS |  | 14 (D00-3-017 ACT:SSP0014_ShipmentModelPIC.S) |
| WK-SSP0014-0167 | G5 | USER_ID / User ID | 하네스·환경 | G5 도구 오류 — 원장 V-84d25ca8 ASIS / 원장 V-11a4fcdf ASIS |  | 16 (D00-3-015 15-22 UserInfoPopup(USER_ID/PA) |
| WK-SSP0014-0168 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-84d25ca8 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0169 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-dfb225ee |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0170 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-b70eeccb |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0171 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-6ad1182d |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0172 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-9bbebfe3 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0173 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-8a43cba5 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0174 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-113d1799 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0175 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-92b73e23 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0176 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-11a4fcdf |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0177 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-51cca87a |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0178 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-969965a4 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0179 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-c4ea73fb |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0180 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-56fc463e |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0181 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-456975c2 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0182 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-e88e29a7 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0183 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-a66510d8 |  | 1 (ACT:SSP0014_ShipmentModelPIC.SpdMain_Cel) |
| WK-SSP0014-0184 | H6 | 3 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 3 'AS-IS MSG00251 미등록 사용자 — "GSCM 시스템에 등록되지 않은 사용자 입니' 의 H6 29요소: PASS:28 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0014-0185 | H6 | D00-2-003 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-2-003 '§2 spdMain / CellDoubleClick(UserInfoPopup)' 의 H6 29요소: PASS:28 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-003) |
| WK-SSP0014-0186 | H6 | MODAL:ItemByDivisionModal | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 MODAL:ItemByDivisionModal 'AS-IS SCM0002_ItembyDivisionPopup(Model 검색, divisi' 의 H6 29요소: PASS:28 · NOT_RUN: |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0014-0187 | H6 | MODAL:SsoUserModal | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 MODAL:SsoUserModal 'AS-IS UserInfoPopup(이미지셀 7 공유, SingleSelectYn)' 의 H6 29요소: PASS:28 · NOT_RUN:1 (미실행 요소가  |  | 1 (MODAL:SsoUserModal) |
| WK-SSP0014-0188 | H6 | ProgressForm(FindData/SaveData) | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 ProgressForm(FindData/SaveData) '2' 의 H6 29요소: PASS:28 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(FindData/SaveData)) |

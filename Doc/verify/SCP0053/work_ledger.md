# 작업 원장 — SCP0053 · 2026-10-26 12:54

> 검사 인스턴스 354건 중 PASS·NA 120건 외 **234건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 35 | 구현 위치 실존 |
| W4 | 검사기 구현 | 1 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 11 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 60 | 실행 → PASS |
| W7 | 기대값 확정 | 127 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 121 · E2E 60 · 대조표 41 · 하네스 12
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 2건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 35 |  |  |  |  | 1 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 31 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 15 | 4 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G1 | GEN |  |  |  |  |  | 5 | 14 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G5 | POPUP |  |  |  |  | 6 |  | 9 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 | 5 | 9 |  |  | 팝업 표준·열림 |
| D1 | EDIT |  |  |  |  |  | 3 | 12 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 3 | 12 |  |  | 행 값 기반 조건부 잠금 |
| M4 | POPUP |  |  |  |  |  | 6 | 9 |  |  | 팝업 선택값 반영 |
| A1 | GEN |  |  |  |  |  |  | 15 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-REASON | DESIGN |  |  |  |  |  |  | 6 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B4 | COMBO |  |  |  |  | 1 |  | 2 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| F4 | DB |  |  |  |  |  | 2 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| B3 | COMBO |  |  |  | 1 |  |  | 1 |  |  | 콤보 후보 정렬 = AS-IS |
| C1 | CASCADE |  |  |  |  |  | 2 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C4 | CASCADE |  |  |  |  |  | 2 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| G4 | DESIGN |  |  |  |  |  | 2 |  |  |  | 조회조건 표시·라벨·활성 |
| A6 | GEN |  |  |  |  |  | 1 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G6 | GEN |  |  |  |  |  | 2 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
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
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (35)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0053-0001 | X-LOC | 1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1) |
| WK-SCP0053-0002 | X-LOC | 10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (10) |
| WK-SCP0053-0003 | X-LOC | 11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (11) |
| WK-SCP0053-0004 | X-LOC | 12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (12) |
| WK-SCP0053-0005 | X-LOC | 13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (13) |
| WK-SCP0053-0006 | X-LOC | 2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2) |
| WK-SCP0053-0007 | X-LOC | 3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (3) |
| WK-SCP0053-0008 | X-LOC | 4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (4) |
| WK-SCP0053-0009 | X-LOC | 5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (5) |
| WK-SCP0053-0010 | X-LOC | 6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (6) |
| WK-SCP0053-0011 | X-LOC | 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (7) |
| WK-SCP0053-0012 | X-LOC | 8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (8) |
| WK-SCP0053-0013 | X-LOC | 9 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (9) |
| WK-SCP0053-0014 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-02) |
| WK-SCP0053-0015 | X-LOC | COMMON:UC-03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-03) |
| WK-SCP0053-0016 | X-LOC | COMMON:UC-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-04) |
| WK-SCP0053-0017 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SCP0053-0018 | X-LOC | COMMON:UC-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-06) |
| WK-SCP0053-0019 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-07) |
| WK-SCP0053-0020 | X-LOC | D00-3-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-001) |
| WK-SCP0053-0021 | X-LOC | D00-3-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-003) |
| WK-SCP0053-0022 | X-LOC | D00-3-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-006) |
| WK-SCP0053-0023 | X-LOC | D00-3-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-008) |
| WK-SCP0053-0024 | X-LOC | D00-3-010 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-010) |
| WK-SCP0053-0025 | X-LOC | D00-3-011 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-011) |
| WK-SCP0053-0026 | X-LOC | D00-4d-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-006) |
| WK-SCP0053-0027 | X-LOC | MODAL:ShowDialog | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MODAL:ShowDialog) |
| WK-SCP0053-0028 | X-LOC | ProgressForm | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ProgressForm) |
| WK-SCP0053-0029 | X-LOC | SCM0002_ItembyDivisionPopup | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SCP0053-0030 | X-LOC | btnItemId(UsrButton) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnItemId(UsrButton)) |
| WK-SCP0053-0031 | X-LOC | cboDivision(UsrCombo) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboDivision(UsrCombo)) |
| WK-SCP0053-0032 | X-LOC | clbPlantSite(UsrCheckedList) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbPlantSite(UsrCheckedList)) |
| WK-SCP0053-0033 | X-LOC | spdMain(FpSpread) 단일 시트 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain(FpSpread) 단일 시트) |
| WK-SCP0053-0034 | X-LOC | txtModelID/txtParentID/txtChildID(UsrMul | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtModelID/txtParentID/txtChildID(UsrMul) |
| WK-SCP0053-0035 | X-LOC | ucbAltBOM(UsrCheckBox) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ucbAltBOM(UsrCheckBox)) |

## W4 검사기 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0053-0036 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 1 (ACT:SCP0053_SCPBOM.SetChangedControl:186) |

## W5 검사기 연결 (11)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0053-0037 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (ACT:SCP0053_SCPBOM.SetChangedControl:186) |
| WK-SCP0053-0038 | F2 | SCP0053 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0053 화면 | 판단불가(대상 단위 SCREEN) | 82 (D00-4d-002 MODAL:AlertModal COMMON:UC-04) |
| WK-SCP0053-0039 | F6 | SCP0053 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0053 화면 | 판단불가(대상 단위 SCREEN) | 79 (ACT:SCP0053_SCPBOM.SaveButton ACT:SCP005) |
| WK-SCP0053-0040 | G03-WIRE | SCP0053 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0053 화면 | 판단불가(대상 단위 SCREEN) | 13 (ACT:SCP0053_SCPBOM..ctor ACT:SCP0053_SCP) |
| WK-SCP0053-0041 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 없음 | 1 (btnItemId(UsrButton)) |
| WK-SCP0053-0042 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (cboDivision(UsrCombo)) |
| WK-SCP0053-0043 | G5 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (clbPlantSite(UsrCheckedList)) |
| WK-SCP0053-0044 | G5 | txtChildID / Child Item / Child ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtChildID / Child Item / Child ID | 있음(FE 소스) | 1 (txtModelID/txtParentID/txtChildID(UsrMul) |
| WK-SCP0053-0045 | G5 | txtModelID / Model / Model ID / Model/Ni | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtModelID / Model / Model ID / Model/Nickname | 있음(FE 소스) | 2 (txtModelID/txtParentID/txtChildID(UsrMul) |
| WK-SCP0053-0046 | G5 | txtParentID / Parent Item / Parent ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtParentID / Parent Item / Parent ID | 있음(FE 소스) | 1 (txtModelID/txtParentID/txtChildID(UsrMul) |
| WK-SCP0053-0047 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 없음 | 1 (btnItemId(UsrButton)) |

## W6 검증 실행 (60)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0053-0048 | J2 | SCP0053 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0053 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 32 (D00-3-007 D00-3-010 D00-3-011 D00-4d-002) |
| WK-SCP0053-0049 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0053_SCPBOM.InitControls:126:4 AC) |
| WK-SCP0053-0050 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0053_SCPBOM.SetChangedControl:187) |
| WK-SCP0053-0051 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 0 () |
| WK-SCP0053-0052 | C4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 0 () |
| WK-SCP0053-0053 | G3 | SCP0053 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0053 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 6 (COMMON:UC-02 COMMON:UC-03 COMMON:UC-04 C) |
| WK-SCP0053-0054 | K-SA | SCP0053 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0053 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (COMMON:UC-02) |
| WK-SCP0053-0055 | K4 | SCP0053 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0053 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 18 (COMMON:UC-02 COMMON:UC-03 COMMON:UC-04 C) |
| WK-SCP0053-0056 | F1 | SCP0053 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0053 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 86 (D00-4d-002 D00-4d-003 MODAL:AlertModal C) |
| WK-SCP0053-0057 | F3 | SCP0053 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0053 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 3 (ACT:SCP0053_SCPBOM.SpdMain_ClipboardPast) |
| WK-SCP0053-0058 | F5 | SCP0053 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0053 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 4 (D00-4d-003 ACT:SCP0053_SCPBOM.DeleteButt) |
| WK-SCP0053-0059 | F4 | PKG_SCP0053.P_SCP0053_GET_SCP_BOM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0053.P_SCP0053_GET_SCP_BOM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 119 (ACT:SCP0053_SCPBOM.FindButton ACT:SCP005) |
| WK-SCP0053-0060 | F4 | PKG_SCP0053.P_SCP0053_SAVE_SCP_BOM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0053.P_SCP0053_SAVE_SCP_BOM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 79 (ACT:SCP0053_SCPBOM.SaveButton ACT:SCP005) |
| WK-SCP0053-0061 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0053_SCPBOM.DefineProperty ACT:SC) |
| WK-SCP0053-0062 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0053_SCPBOM.InitEvent ACT:SCP0053) |
| WK-SCP0053-0063 | H4 | SCP0053 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0053 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 6 (D00-3-001 1 ACT:SCP0053_SCPBOM.SpdMain_T) |
| WK-SCP0053-0064 | I1 | SCP0053 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0053 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 6 (COMMON:UC-02 9(신규) ACT:SCP0053_SCPBOM.Fi) |
| WK-SCP0053-0065 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (6 ACT:SCP0053_SCPBOM.EditButton ACT:SCP0) |
| WK-SCP0053-0066 | D1 | ECO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ECO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (6 ACT:SCP0053_SCPBOM.EditButton:284:6) |
| WK-SCP0053-0067 | D1 | SCP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SCP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0053_SCPBOM.EditButton ACT:SCP005) |
| WK-SCP0053-0068 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (6 ACT:SCP0053_SCPBOM.EditButton ACT:SCP0) |
| WK-SCP0053-0069 | D3 | ECO_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ECO_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (6 ACT:SCP0053_SCPBOM.EditButton:284:6) |
| WK-SCP0053-0070 | D3 | SCP_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SCP_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0053_SCPBOM.EditButton ACT:SCP005) |
| WK-SCP0053-0071 | D6 | SCP0053 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0053 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 4 (D00-4d-004 ACT:SCP0053_SCPBOM.InsertButt) |
| WK-SCP0053-0072 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0053_SCPBOM.SaveData_Main:520:65) |
| WK-SCP0053-0073 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0053_SCPBOM.SaveData_Main:531:72) |
| WK-SCP0053-0074 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (9(신규)) |
| WK-SCP0053-0075 | E4 | MSG00333 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00333 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0053-0076 | E4 | MSG00334 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00334 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0053-0077 | E4 | MSG00335 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00335 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0053-0078 | E4 | MSG00336 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00336 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0053-0079 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0053-0080 | E4 | MSG00704 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00704 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0053-0081 | E4 | MSG01329 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01329 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0053-0082 | E4 | MSG01330 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01330 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0053-0083 | E4 | MSG01331 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01331 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0053-0084 | E4 | MSG01332 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01332 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0053-0085 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 6 (ACT:SCP0053_SCPBOM.SetChangedControl ACT) |
| WK-SCP0053-0086 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 3 (ACT:SCP0053_SCPBOM.SetChangedControl ACT) |
| WK-SCP0053-0087 | A10 | SCP0053 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0053 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 28 (ACT:SCP0053_SCPBOM.DefineProperty ACT:SC) |
| WK-SCP0053-0088 | A6 | PKG_SCP0053.P_SCP0053_GET_SCP_BOM | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0053.P_SCP0053_GET_SCP_BOM · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trac |  | 42 (ACT:SCP0053_SCPBOM.FindButton ACT:SCP005) |
| WK-SCP0053-0089 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0053_SCPBOM.FindData_Main ACT:SCP) |
| WK-SCP0053-0090 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0053_SCPBOM.FindData_Main ACT:SCP) |
| WK-SCP0053-0091 | G1 | txtChildID / Child Item / Child ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtChildID / Child Item / Child ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0053_SCPBOM.FindData_Main ACT:SCP) |
| WK-SCP0053-0092 | G1 | txtModelID / Model / Model ID / Model/Ni | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtModelID / Model / Model ID / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0053_SCPBOM.FindData_Main ACT:SCP) |
| WK-SCP0053-0093 | G1 | txtParentID / Parent Item / Parent ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtParentID / Parent Item / Parent ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0053_SCPBOM.FindData_Main ACT:SCP) |
| WK-SCP0053-0094 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SCP0053_SCPBOM.DefineProperty ACT:SC) |
| WK-SCP0053-0095 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0053_SCPBOM.InitEvent ACT:SCP0053) |
| WK-SCP0053-0096 | X-REOPEN | SCP0053 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0053 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 6 (ACT:SCP0053_SCPBOM.Dispose ACT:SCP0053_S) |
| WK-SCP0053-0097 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (cboDivision(UsrCombo)) |
| WK-SCP0053-0098 | H6 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbPlantSite / Plant Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (clbPlantSite(UsrCheckedList)) |
| WK-SCP0053-0099 | H6 | txtChildID / Child Item / Child ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtChildID / Child Item / Child ID · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (txtModelID/txtParentID/txtChildID(UsrMul) |
| WK-SCP0053-0100 | H6 | txtModelID / Model / Model ID / Model/Ni | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtModelID / Model / Model ID / Model/Nickname · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (txtModelID/txtParentID/txtChildID(UsrMul) |
| WK-SCP0053-0101 | H6 | txtParentID / Parent Item / Parent ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtParentID / Parent Item / Parent ID · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (txtModelID/txtParentID/txtChildID(UsrMul) |
| WK-SCP0053-0102 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (btnItemId(UsrButton)) |
| WK-SCP0053-0103 | M4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (cboDivision(UsrCombo)) |
| WK-SCP0053-0104 | M4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (clbPlantSite(UsrCheckedList)) |
| WK-SCP0053-0105 | M4 | txtChildID / Child Item / Child ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtChildID / Child Item / Child ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (txtModelID/txtParentID/txtChildID(UsrMul) |
| WK-SCP0053-0106 | M4 | txtModelID / Model / Model ID / Model/Ni | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtModelID / Model / Model ID / Model/Nickname · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trac |  | 2 (txtModelID/txtParentID/txtChildID(UsrMul) |
| WK-SCP0053-0107 | M4 | txtParentID / Parent Item / Parent ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtParentID / Parent Item / Parent ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (txtModelID/txtParentID/txtChildID(UsrMul) |

## W7 기대값 확정 (127)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0053-0108 | B3 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-001: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0053-0109 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0053-0110 | B4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-001: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0053-0111 | F4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 5: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0112 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터 상태 Insert 시 필터 유지  INSERT NO-OP(R4) — 신규행 추가 경로 없어 필터유지 대상 없음 해당없음 |  | 1 (COMMON:UC-01) |
| WK-SCP0053-0113 | X-REASON | D00-3-002 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-002 §3 205 / siMain  ChangeActiveSheet — 단일 그리드(Except 미부착, design 01 R6) 활성시트 전환 없음 해당없음 |  | 1 (D00-3-002) |
| WK-SCP0053-0114 | X-REASON | D00-3-004 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-004 §3 216 / siMain  VisibleTab 단일시트 탭 — 단일 DataGrid 탭 UI 없음(design 01 R6) 해당없음 |  | 1 (D00-3-004) |
| WK-SCP0053-0115 | X-REASON | D00-3-012 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-012 §3 667 / siMain  IsLockCell CellClick — AS-IS 바디 빈 블록(design 03 §3.2) no-op 해당없음 |  | 1 (D00-3-012) |
| WK-SCP0053-0116 | X-REASON | D00-3-013 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-013 §3 707 / siMain  ChangeActiveSheet ActiveSheetChanged — 단일 시트 재동기화 원천 제거 해당없음 |  | 1 (D00-3-013) |
| WK-SCP0053-0117 | X-REASON | D00-4d-001 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4d-001 §4d SpdMain_CellDoubleClick / -  SpdMain_CellDoubleClick — 선택 좌표 저장뿐(후속 없음) 미배선 해당없음 |  | 1 (D00-4d-001) |
| WK-SCP0053-0118 | D1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 10: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0053-0119 | D1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 12: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0053-0120 | D1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 5: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0053-0121 | D1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 6: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0122 | D1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 7: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0053-0123 | D1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 8: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0053-0124 | D1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 9: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0125 | D1 | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-006: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-006) |
| WK-SCP0053-0126 | D1 | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-007: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-007) |
| WK-SCP0053-0127 | D1 | D00-3-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-010: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-010) |
| WK-SCP0053-0128 | D1 | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-006: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-006) |
| WK-SCP0053-0129 | D1 | SCP0053_SCPBOM.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0053_SCPBOM.EditButton: 진입점 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0053_SCPBOM.EditButton:275:1 ACT:) |
| WK-SCP0053-0130 | D3 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 10: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0053-0131 | D3 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 12: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0053-0132 | D3 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 5: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0053-0133 | D3 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 6: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0134 | D3 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 7: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0053-0135 | D3 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 8: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0053-0136 | D3 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 9: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0137 | D3 | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-006: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-006) |
| WK-SCP0053-0138 | D3 | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-007: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-007) |
| WK-SCP0053-0139 | D3 | D00-3-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-010: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-010) |
| WK-SCP0053-0140 | D3 | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-006: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-006) |
| WK-SCP0053-0141 | D3 | SCP0053_SCPBOM.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0053_SCPBOM.EditButton: 진입점 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0053_SCPBOM.EditButton:275:1 ACT:) |
| WK-SCP0053-0142 | E4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 5: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0143 | E4 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 8: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0144 | E4 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-002: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SCP0053-0145 | E4 | SCP0053_SCPBOM.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0053_SCPBOM.SetSpreadInit: 진입점 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0053_SCPBOM.SetSpreadInit:212:1 A) |
| WK-SCP0053-0146 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-SCP0053-0147 | A1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 10: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (10) |
| WK-SCP0053-0148 | A1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 11: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (11) |
| WK-SCP0053-0149 | A1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 5: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-SCP0053-0150 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-SCP0053-0151 | A1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (9) |
| WK-SCP0053-0152 | A1 | 9(신규) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9(신규): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (9(신규)) |
| WK-SCP0053-0153 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0053-0154 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-03) |
| WK-SCP0053-0155 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-06) |
| WK-SCP0053-0156 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0053-0157 | A1 | D00-3-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-010: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-3-010) |
| WK-SCP0053-0158 | A1 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-011: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-3-011) |
| WK-SCP0053-0159 | A1 | MODAL:MaterialByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MODAL:MaterialByDivisionModal: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (MODAL:MaterialByDivisionModal) |
| WK-SCP0053-0160 | A1 | PKG_SCP0053.P_SCP0053_GET_SCP_BOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0053.P_SCP0053_GET_SCP_BOM: 골든 비교 케이스 없음(PKG_SCP0053.P_SCP0053_GET_SCP_BOM — 팝업·보조 SP 는 golden_cases.csv 에 FE 실 |  | 42 (ACT:SCP0053_SCPBOM.FindButton ACT:SCP005) |
| WK-SCP0053-0161 | A6 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 5: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0162 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0163 | G1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 10: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0053-0164 | G1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 11: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0053-0165 | G1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 5: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0166 | G1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 6: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0167 | G1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 9: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0053-0168 | G1 | 9(신규) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 9(신규): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (9(신규)) |
| WK-SCP0053-0169 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0053-0170 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0053-0171 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0053-0172 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0053-0173 | G1 | D00-3-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-010: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-010) |
| WK-SCP0053-0174 | G1 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-011: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-SCP0053-0175 | G1 | MODAL:MaterialByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MODAL:MaterialByDivisionModal: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:MaterialByDivisionModal) |
| WK-SCP0053-0176 | X-LOC | 9(신규) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9(신규): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9(신규)) |
| WK-SCP0053-0177 | X-ROW | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 10: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0053-0178 | X-ROW | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0053-0179 | X-ROW | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0053-0180 | X-ROW | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-008) |
| WK-SCP0053-0181 | X-ROW | D00-4b-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-002) |
| WK-SCP0053-0182 | X-ROW | SCP0053_SCPBOM.ClbDivision_SelectedIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.ClbDivision_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0053_SCPBOM.ClbDivision_SelectedI) |
| WK-SCP0053-0183 | X-ROW | SCP0053_SCPBOM.ClbPlantSite_SelectedInde | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.ClbPlantSite_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0053_SCPBOM.ClbPlantSite_Selected) |
| WK-SCP0053-0184 | X-ROW | SCP0053_SCPBOM.ClearUsrCheckedList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0053_SCPBOM.ClearUsrCheckedList A) |
| WK-SCP0053-0185 | X-ROW | SCP0053_SCPBOM.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0053_SCPBOM.CreateSpread) |
| WK-SCP0053-0186 | X-ROW | SCP0053_SCPBOM.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.EditButton: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:2 |  | 2 (ACT:SCP0053_SCPBOM.EditButton:294:12 ACT) |
| WK-SCP0053-0187 | X-ROW | SCP0053_SCPBOM.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0053_SCPBOM.FindButton) |
| WK-SCP0053-0188 | X-ROW | SCP0053_SCPBOM.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.FindData_Main: 진입점 집계 11검사 — NOT_RUN:9 · REVIEW:1 · PASS:1 |  | 9 (ACT:SCP0053_SCPBOM.FindData_Main:357:1 A) |
| WK-SCP0053-0189 | X-ROW | SCP0053_SCPBOM.Find_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.Find_Data: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0053_SCPBOM.Find_Data ACT:SCP0053) |
| WK-SCP0053-0190 | X-ROW | SCP0053_SCPBOM.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0053_SCPBOM.Form_Load) |
| WK-SCP0053-0191 | X-ROW | SCP0053_SCPBOM.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0053_SCPBOM.InitControls:124:3 AC) |
| WK-SCP0053-0192 | X-ROW | SCP0053_SCPBOM.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0053_SCPBOM.InitSpread) |
| WK-SCP0053-0193 | X-ROW | SCP0053_SCPBOM.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0053_SCPBOM.InsertButton) |
| WK-SCP0053-0194 | X-ROW | SCP0053_SCPBOM.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0053_SCPBOM.OnShown ACT:SCP0053_S) |
| WK-SCP0053-0195 | X-ROW | SCP0053_SCPBOM.SaveData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.SaveData_Main: 진입점 집계 11검사 — NOT_RUN:7 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0053_SCPBOM.SaveData_Main:456:20 ) |
| WK-SCP0053-0196 | X-ROW | SCP0053_SCPBOM.SelectCombo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.SelectCombo: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/FLOW/LOCAL/VALUE_SET, 연결된 요소 검사 없음 |  | 10 (ACT:SCP0053_SCPBOM.SelectCombo ACT:SCP00) |
| WK-SCP0053-0197 | X-ROW | SCP0053_SCPBOM.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.SetChangedControl: 진입점 집계 6검사 — NOT_RUN:4 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0053_SCPBOM.SetChangedControl ACT) |
| WK-SCP0053-0198 | X-ROW | SCP0053_SCPBOM.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.SetSpreadInit: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0053_SCPBOM.SetSpreadInit) |
| WK-SCP0053-0199 | X-ROW | SCP0053_SCPBOM.SpdMain_ActiveSheetChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.SpdMain_ActiveSheetChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0053_SCPBOM.SpdMain_ActiveSheetCh) |
| WK-SCP0053-0200 | X-ROW | SCP0053_SCPBOM.SpdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.SpdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0053_SCPBOM.SpdMain_CellClick ACT) |
| WK-SCP0053-0201 | X-ROW | SCP0053_SCPBOM.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0053_SCPBOM.SpdMain_CellDoubleCli) |
| WK-SCP0053-0202 | X-ROW | SCP0053_SCPBOM.SpdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.SpdMain_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0053_SCPBOM.SpdMain_Changed) |
| WK-SCP0053-0203 | X-ROW | SCP0053_SCPBOM.SpdMain_ClipboardPasted | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.SpdMain_ClipboardPasted: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0053_SCPBOM.SpdMain_ClipboardPast) |
| WK-SCP0053-0204 | X-ROW | SCP0053_SCPBOM.SpdMain_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.SpdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/FLAG, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0053_SCPBOM.SpdMain_EditChange AC) |
| WK-SCP0053-0205 | X-ROW | SCP0053_SCPBOM.SpdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0053_SCPBOM.SpdMain_TopChange ACT) |
| WK-SCP0053-0206 | X-ROW | SCP0053_SCPBOM.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0053_SCPBOM.btnItemId_Click:585:5) |
| WK-SCP0053-0207 | X-ROW | SCP0053_SCPBOM.checkValidN0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0053_SCPBOM.checkValidN0: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0053_SCPBOM.checkValidN0 ACT:SCP0) |
| WK-SCP0053-0208 | G5 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 1: 행 집계 — G5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0209 | G5 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 7: 행 집계 — G5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0210 | G5 | MODAL:AlertModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:AlertModal: 행 집계 — G5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:AlertModal) |
| WK-SCP0053-0211 | G5 | MODAL:MaterialByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:MaterialByDivisionModal: 행 집계 — G5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:MaterialByDivisionModal) |
| WK-SCP0053-0212 | G5 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ShowDialog: 행 집계 — G5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0053-0213 | G5 | ProgressForm | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ProgressForm: 행 집계 — G5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm) |
| WK-SCP0053-0214 | G5 | SCP0053_SCPBOM.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0053_SCPBOM.SpdMain_CellDoubleClick: 진입점 집계 — G5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0053_SCPBOM.SpdMain_CellDoubleCli) |
| WK-SCP0053-0215 | G5 | spdMain(FpSpread) 단일 시트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — spdMain(FpSpread) 단일 시트: 행 집계 — G5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread) 단일 시트) |
| WK-SCP0053-0216 | G5 | ucbAltBOM(UsrCheckBox) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ucbAltBOM(UsrCheckBox): 행 집계 — G5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (ucbAltBOM(UsrCheckBox)) |
| WK-SCP0053-0217 | H6 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 1: 행 집계 — H6 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0218 | H6 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 7: 행 집계 — H6 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0219 | H6 | MODAL:AlertModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:AlertModal: 행 집계 — H6 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:AlertModal) |
| WK-SCP0053-0220 | H6 | MODAL:MaterialByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:MaterialByDivisionModal: 행 집계 — H6 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:MaterialByDivisionModal) |
| WK-SCP0053-0221 | H6 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ShowDialog: 행 집계 — H6 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0053-0222 | H6 | ProgressForm | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ProgressForm: 행 집계 — H6 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm) |
| WK-SCP0053-0223 | H6 | SCP0053_SCPBOM.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0053_SCPBOM.SpdMain_CellDoubleClick: 진입점 집계 — H6 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0053_SCPBOM.SpdMain_CellDoubleCli) |
| WK-SCP0053-0224 | H6 | spdMain(FpSpread) 단일 시트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — spdMain(FpSpread) 단일 시트: 행 집계 — H6 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread) 단일 시트) |
| WK-SCP0053-0225 | H6 | ucbAltBOM(UsrCheckBox) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ucbAltBOM(UsrCheckBox): 행 집계 — H6 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (ucbAltBOM(UsrCheckBox)) |
| WK-SCP0053-0226 | M4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 1: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0227 | M4 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 7: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0053-0228 | M4 | MODAL:AlertModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:AlertModal: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:AlertModal) |
| WK-SCP0053-0229 | M4 | MODAL:MaterialByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:MaterialByDivisionModal: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:MaterialByDivisionModal) |
| WK-SCP0053-0230 | M4 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ShowDialog: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0053-0231 | M4 | ProgressForm | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ProgressForm: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm) |
| WK-SCP0053-0232 | M4 | SCP0053_SCPBOM.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0053_SCPBOM.SpdMain_CellDoubleClick: 진입점 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0053_SCPBOM.SpdMain_CellDoubleCli) |
| WK-SCP0053-0233 | M4 | spdMain(FpSpread) 단일 시트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — spdMain(FpSpread) 단일 시트: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread) 단일 시트) |
| WK-SCP0053-0234 | M4 | ucbAltBOM(UsrCheckBox) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ucbAltBOM(UsrCheckBox): 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ucbAltBOM(UsrCheckBox)) |

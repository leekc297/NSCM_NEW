# 작업 원장 — SSP0025 · 2026-10-26 12:59

> 검사 인스턴스 384건 중 PASS·NA 28건 외 **356건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 45 | 구현 위치 실존 |
| W4 | 검사기 구현 | 7 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 41 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 137 | 실행 → PASS |
| W7 | 기대값 확정 | 126 | 기대 확정 → PASS/FAIL |

- 담당: E2E 137 · 사람 판정 / AS-IS 원문 확인 → 재판정 126 · 하네스 48 · 대조표 45
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 45 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 44 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| D1 | EDIT |  |  |  |  |  | 13 | 7 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 13 | 7 |  |  | 행 값 기반 조건부 잠금 |
| E4 | EDIT |  |  |  |  |  | 11 | 7 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C3 | CASCADE |  |  |  |  |  | 12 | 5 |  |  | 연쇄 자동 채움 |
| G1 | GEN |  |  |  |  |  | 7 | 7 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G5 | POPUP |  |  |  |  | 11 |  | 2 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 9 | 2 | 2 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 11 | 2 |  |  | 팝업 선택값 반영 |
| C2 | CASCADE |  |  |  |  |  | 8 | 4 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 8 | 4 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| B3 | COMBO |  |  |  | 7 |  |  | 3 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 7 |  | 3 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A1 | GEN |  |  |  |  |  |  | 9 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G4 | DESIGN |  |  |  |  | 2 | 5 | 1 |  |  | 조회조건 표시·라벨·활성 |
| F4 | DB |  |  |  |  |  | 5 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A5 | DESIGN |  |  |  |  |  | 3 | 4 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 3 | 4 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 3 | 4 |  |  | 라벨 명칭 |
| D5 | EDIT |  |  |  |  |  | 6 | 1 |  |  | 셀 에디터 유형 |
| G6 | GEN |  |  |  |  |  | 5 | 1 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| C1 | CASCADE |  |  |  |  |  | 4 | 1 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| B1 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 중복 없음 |
| E5 | EDIT |  |  |  |  | 3 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| D4 | EDIT |  |  |  |  |  | 2 | 1 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| A6 | GEN |  |  |  |  |  | 2 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H3 | DESIGN |  |  |  |  |  | 1 |  |  |  | 셀 병합 = AS-IS |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| M3 | POPUP |  |  |  |  |  | 1 |  |  |  | 팝업 내부 기능(조회·CRUD) |

## W2 구현 위치 확인 (45)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0001 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: hotkey.ts 없음, SubTitle.tsx 없음 |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0002 | X-LOC | CboDivision_SelectedIndexChanged → SetCh | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SSP0025-0003 | X-LOC | CellClick Division/PlantSite 선점(628/642) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CellClick Division/PlantSite 선점(628/642)) |
| WK-SSP0025-0004 | X-LOC | CellClick 순수가드(619/674) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CellClick 순수가드(619/674)) |
| WK-SSP0025-0005 | X-LOC | DeleteButton(action='I'만 제거) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DeleteButton(action='I'만 제거)) |
| WK-SSP0025-0006 | X-LOC | EditButton(SwitchLock) + GetSSPUserCheck | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton(SwitchLock) + GetSSPUserCheck) |
| WK-SSP0025-0007 | X-LOC | FindButton → FindData_Main | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton → FindData_Main) |
| WK-SSP0025-0008 | X-LOC | GetUserIDChk(USER_ID_CHECK) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (GetUserIDChk(USER_ID_CHECK)) |
| WK-SSP0025-0009 | X-LOC | InsertButton(IsLock=false 가드) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (InsertButton(IsLock=false 가드)) |
| WK-SSP0025-0010 | X-LOC | R1 초기 전체잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R1 초기 전체잠금) |
| WK-SSP0025-0011 | X-LOC | R10 CellClick 가드(Division 선점) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R10 CellClick 가드(Division 선점)) |
| WK-SSP0025-0012 | X-LOC | R11 신규행 SITE 재조회 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R11 신규행 SITE 재조회) |
| WK-SSP0025-0013 | X-LOC | R12 신규행 ITEM 팝업 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R12 신규행 ITEM 팝업) |
| WK-SSP0025-0014 | X-LOC | R13 SITE→TO_SITE 파생 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R13 SITE→TO_SITE 파생) |
| WK-SSP0025-0015 | X-LOC | R14 신규행 Division 변경 reset | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R14 신규행 Division 변경 reset) |
| WK-SSP0025-0016 | X-LOC | R15 ComboSelChange 가드(행0) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R15 ComboSelChange 가드(행0)) |
| WK-SSP0025-0017 | X-LOC | R16 USER_ID 더블클릭 팝업 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R16 USER_ID 더블클릭 팝업) |
| WK-SSP0025-0018 | X-LOC | R17 PART_LEADER 더블클릭 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R17 PART_LEADER 더블클릭) |
| WK-SSP0025-0019 | X-LOC | R18 TEAM_LEADER 더블클릭 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R18 TEAM_LEADER 더블클릭) |
| WK-SSP0025-0020 | X-LOC | R19 삭제=신규행만 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R19 삭제=신규행만) |
| WK-SSP0025-0021 | X-LOC | R2 편집권한 게이트 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R2 편집권한 게이트) |
| WK-SSP0025-0022 | X-LOC | R20 셀 병합 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R20 셀 병합) |
| WK-SSP0025-0023 | X-LOC | R21 이미지셀 아이콘 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R21 이미지셀 아이콘) |
| WK-SSP0025-0024 | X-LOC | R3 기존행 편집칸 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R3 기존행 편집칸) |
| WK-SSP0025-0025 | X-LOC | R4 신규행 편집칸 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R4 신규행 편집칸) |
| WK-SSP0025-0026 | X-LOC | R7 신규행 VALID 기본값 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R7 신규행 VALID 기본값) |
| WK-SSP0025-0027 | X-LOC | R8 CellClick 가드(행0) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R8 CellClick 가드(행0)) |
| WK-SSP0025-0028 | X-LOC | R9 CellClick 가드(편집모드) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R9 CellClick 가드(편집모드)) |
| WK-SSP0025-0029 | X-LOC | SSP0025_ItembyDivisionPopup | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SSP0025_ItembyDivisionPopup) |
| WK-SSP0025-0030 | X-LOC | Save 응답판정(S/건수/에러) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Save 응답판정(S/건수/에러)) |
| WK-SSP0025-0031 | X-LOC | SaveButton → SaveData | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton → SaveData) |
| WK-SSP0025-0032 | X-LOC | UserInfoPopup(User/Part/Team) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (UserInfoPopup(User/Part/Team)) |
| WK-SSP0025-0033 | X-LOC | cboDivision | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboDivision) |
| WK-SSP0025-0034 | X-LOC | cboDivision(UsrCombo, MyDivision) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboDivision(UsrCombo, MyDivision)) |
| WK-SSP0025-0035 | X-LOC | checkRequiredOfSearch(Division 필수) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (checkRequiredOfSearch(Division 필수)) |
| WK-SSP0025-0036 | X-LOC | checkRequiredOfSpread(필수 4칸) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (checkRequiredOfSpread(필수 4칸)) |
| WK-SSP0025-0037 | X-LOC | clbFromSite | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbFromSite) |
| WK-SSP0025-0038 | X-LOC | clbFromSite(UsrCheckedList, PlantCell) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbFromSite(UsrCheckedList, PlantCell)) |
| WK-SSP0025-0039 | X-LOC | spdMain(FpSpread) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain(FpSpread)) |
| WK-SSP0025-0040 | X-LOC | txtItemId(다건) + btnItemId | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtItemId(다건) + btnItemId) |
| WK-SSP0025-0041 | X-LOC | txtModelId(다건) + btnModelId | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtModelId(다건) + btnModelId) |
| WK-SSP0025-0042 | X-LOC | txtNickName | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtNickName) |
| WK-SSP0025-0043 | X-LOC | usrButton1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrButton1) |
| WK-SSP0025-0044 | X-LOC | usrConditionPanel1(HidePanel) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrConditionPanel1(HidePanel)) |
| WK-SSP0025-0045 | X-LOC | 셀 VALID_YN | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (셀 VALID_YN) |

## W4 검사기 구현 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0046 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (셀 DIVISION_ID) |
| WK-SSP0025-0047 | B3 | N | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 N | 판단불가(대상 단위 PCOL) | 3 (UserInfoPopup(User/Part/Team) ACT:SSP002) |
| WK-SSP0025-0048 | B3 | SITE_DESCRIPTION | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 1 (셀 SITE_DESCRIPTION) |
| WK-SSP0025-0049 | B3 | USER_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 USER_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0025_ShipmentRequestorPIC.GetUser) |
| WK-SSP0025-0050 | B3 | VALID_YN | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 VALID_YN | 있음(SHEET_COLUMNS) | 1 (셀 VALID_YN) |
| WK-SSP0025-0051 | B3 | cboDivision / Div / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Div / Division | 있음(FE 소스) | 1 (cboDivision) |
| WK-SSP0025-0052 | B3 | clbFromSite / Plant Site / From Site | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbFromSite / Plant Site / From Site | 있음(FE 소스) | 1 (clbFromSite) |

## W5 검사기 연결 (41)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0053 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 ACT:SSP0025_ShipmentRequest) |
| WK-SSP0025-0054 | B1 | SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 3 (COMMON:UC-05 ACT:SSP0025_ShipmentRequest) |
| WK-SSP0025-0055 | B1 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0025-0056 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 ACT:SSP0025_ShipmentRequest) |
| WK-SSP0025-0057 | B2 | SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 3 (COMMON:UC-05 ACT:SSP0025_ShipmentRequest) |
| WK-SSP0025-0058 | B2 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0025-0059 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (셀 DIVISION_ID COMMON:UC-05 ACT:SSP0025_S) |
| WK-SSP0025-0060 | B4 | N | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL N | 판단불가(대상 단위 PCOL) | 3 (UserInfoPopup(User/Part/Team) ACT:SSP002) |
| WK-SSP0025-0061 | B4 | SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 4 (셀 SITE_DESCRIPTION COMMON:UC-05 ACT:SSP0) |
| WK-SSP0025-0062 | B4 | USER_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL USER_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0025_ShipmentRequestorPIC.GetUser) |
| WK-SSP0025-0063 | B4 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 2 (셀 VALID_YN COMMON:UC-05) |
| WK-SSP0025-0064 | B4 | cboDivision / Div / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Div / Division | 있음(FE 소스) | 1 (cboDivision) |
| WK-SSP0025-0065 | B4 | clbFromSite / Plant Site / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbFromSite / Plant Site / From Site | 있음(FE 소스) | 1 (clbFromSite) |
| WK-SSP0025-0066 | F2 | SSP0025 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0025 화면 | 판단불가(대상 단위 SCREEN) | 64 (EditButton(SwitchLock) + GetSSPUserCheck) |
| WK-SSP0025-0067 | F6 | SSP0025 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SSP0025 화면 | 판단불가(대상 단위 SCREEN) | 60 (SaveButton → SaveData ACT:SSP0025_Shipme) |
| WK-SSP0025-0068 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitEve) |
| WK-SSP0025-0069 | G4 | btnModelId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnModelId | 있음(FE 소스) | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitEve) |
| WK-SSP0025-0070 | E5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0025-0071 | E5 | SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0025-0072 | E5 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SSP0025-0073 | G03-WIRE | SSP0025 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0025 화면 | 판단불가(대상 단위 SCREEN) | 15 (ACT:SSP0025_ItembyDivisionPopup..ctor AC) |
| WK-SSP0025-0074 | G5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (셀 DIVISION_ID) |
| WK-SSP0025-0075 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 1 (R12 신규행 ITEM 팝업) |
| WK-SSP0025-0076 | G5 | N | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 PCOL N | 판단불가(대상 단위 PCOL) | 1 (UserInfoPopup(User/Part/Team)) |
| WK-SSP0025-0077 | G5 | PART_LEADER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PART_LEADER | 있음(SHEET_COLUMNS) | 13 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0078 | G5 | SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 1 (셀 SITE_DESCRIPTION) |
| WK-SSP0025-0079 | G5 | SSP0025_ItembyDivisionPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SSP0025_ItembyDivisionPopup | 판단불가(대상 단위 POPUP) | 5 (SSP0025_ItembyDivisionPopup ACT:SSP0025_) |
| WK-SSP0025-0080 | G5 | TEAM_LEADER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL TEAM_LEADER | 있음(SHEET_COLUMNS) | 13 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0081 | G5 | USER_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL USER_ID | 있음(SHEET_COLUMNS) | 14 (R16 USER_ID 더블클릭 팝업 ACT:SSP0025_Shipment) |
| WK-SSP0025-0082 | G5 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (셀 VALID_YN) |
| WK-SSP0025-0083 | G5 | cboDivision / Div / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Div / Division | 있음(FE 소스) | 1 (cboDivision) |
| WK-SSP0025-0084 | G5 | clbFromSite / Plant Site / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbFromSite / Plant Site / From Site | 있음(FE 소스) | 1 (clbFromSite) |
| WK-SSP0025-0085 | H6 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (셀 DIVISION_ID) |
| WK-SSP0025-0086 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 1 (R12 신규행 ITEM 팝업) |
| WK-SSP0025-0087 | H6 | N | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 PCOL N | 판단불가(대상 단위 PCOL) | 1 (UserInfoPopup(User/Part/Team)) |
| WK-SSP0025-0088 | H6 | PART_LEADER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PART_LEADER | 있음(SHEET_COLUMNS) | 13 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0089 | H6 | SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 1 (셀 SITE_DESCRIPTION) |
| WK-SSP0025-0090 | H6 | SSP0025_ItembyDivisionPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SSP0025_ItembyDivisionPopup | 판단불가(대상 단위 POPUP) | 5 (SSP0025_ItembyDivisionPopup ACT:SSP0025_) |
| WK-SSP0025-0091 | H6 | TEAM_LEADER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TEAM_LEADER | 있음(SHEET_COLUMNS) | 13 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0092 | H6 | USER_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL USER_ID | 있음(SHEET_COLUMNS) | 14 (R16 USER_ID 더블클릭 팝업 ACT:SSP0025_Shipment) |
| WK-SSP0025-0093 | H6 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (셀 VALID_YN) |

## W6 검증 실행 (137)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0094 | J2 | SSP0025 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0025 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 51 (FindButton → FindData_Main EditButton(Sw) |
| WK-SSP0025-0095 | C1 | cboDivision / Div / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Div / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InitCon) |
| WK-SSP0025-0096 | C1 | clbDivisionId / Division / Division Id | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivisionId / Division / Division Id · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0097 | C1 | clbFromSite / Plant Site / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / Plant Site / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SetChan) |
| WK-SSP0025-0098 | C1 | clbFromSiteId / From Site / From Site Id | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSiteId / From Site / From Site Id · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0099 | C2 | CELL_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CELL_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0100 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (R14 신규행 Division 변경 reset ACT:SSP0025_It) |
| WK-SSP0025-0101 | C2 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0102 | C2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0103 | C2 | MODEL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — MODEL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0104 | C2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0105 | C2 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (R13 SITE→TO_SITE 파생 ACT:SSP0025_Shipment) |
| WK-SSP0025-0106 | C2 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (R13 SITE→TO_SITE 파생 ACT:SSP0025_Shipment) |
| WK-SSP0025-0107 | C3 | CELL_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CELL_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0108 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (R14 신규행 Division 변경 reset ACT:SSP0025_It) |
| WK-SSP0025-0109 | C3 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0110 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0111 | C3 | MODEL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MODEL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0112 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0113 | C3 | PART_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PART_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0114 | C3 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (R13 SITE→TO_SITE 파생 ACT:SSP0025_Shipment) |
| WK-SSP0025-0115 | C3 | TEAM_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TEAM_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0116 | C3 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (R13 SITE→TO_SITE 파생 ACT:SSP0025_Shipment) |
| WK-SSP0025-0117 | C3 | USER_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — USER_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0118 | C3 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InsertR) |
| WK-SSP0025-0119 | C6 | CELL_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CELL_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0120 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (R14 신규행 Division 변경 reset ACT:SSP0025_It) |
| WK-SSP0025-0121 | C6 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0122 | C6 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0123 | C6 | MODEL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — MODEL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0124 | C6 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0125 | C6 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (R13 SITE→TO_SITE 파생 ACT:SSP0025_Shipment) |
| WK-SSP0025-0126 | C6 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (R13 SITE→TO_SITE 파생 ACT:SSP0025_Shipment) |
| WK-SSP0025-0127 | G3 | SSP0025 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0025 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (usrConditionPanel1(HidePanel) COMMON:UC-) |
| WK-SSP0025-0128 | K-SA | SSP0025 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0025 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (usrConditionPanel1(HidePanel)) |
| WK-SSP0025-0129 | K4 | SSP0025 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0025 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 35 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SSP0025-0130 | F1 | SSP0025 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0025 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 69 (EditButton(SwitchLock) + GetSSPUserCheck) |
| WK-SSP0025-0131 | F5 | SSP0025 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SSP0025 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 5 (DeleteButton(action='I'만 제거) R19 삭제=신규행만) |
| WK-SSP0025-0132 | F4 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.GetSSPU) |
| WK-SSP0025-0133 | F4 | PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 35 (ACT:SSP0025_ItembyDivisionPopup.FindButt) |
| WK-SSP0025-0134 | F4 | PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 96 (ACT:SSP0025_ShipmentRequestorPIC.FindBut) |
| WK-SSP0025-0135 | F4 | PKG_SSP0025.P_SSP0025_GET_USER_ID_CHECK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0025.P_SSP0025_GET_USER_ID_CHECK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 59 (ACT:SSP0025_ShipmentRequestorPIC.GetUser) |
| WK-SSP0025-0136 | F4 | PKG_SSP0025.P_SSP0025_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0025.P_SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 59 (ACT:SSP0025_ShipmentRequestorPIC.SaveBut) |
| WK-SSP0025-0137 | A5 | PART_LEADER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PART_LEADER · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0138 | A5 | TEAM_LEADER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TEAM_LEADER · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0139 | A5 | USER_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — USER_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 12 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0140 | G4 | cboDivision / Div / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Div / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.InitCon) |
| WK-SSP0025-0141 | G4 | clbDivisionId / Division / Division Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivisionId / Division / Division Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0142 | G4 | clbFromSiteId / From Site / From Site Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbFromSiteId / From Site / From Site Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0143 | G4 | txtItemId / Material / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Material / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0144 | G4 | txtModelId / Model / Model Id / Model/Ni | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtModelId / Model / Model Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0145 | H2 | PART_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PART_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0146 | H2 | TEAM_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TEAM_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0147 | H2 | USER_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — USER_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0148 | H3 | I | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — I · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (R20 셀 병합) |
| WK-SSP0025-0149 | H4 | SSP0025 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0025 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0150 | H5 | PART_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PART_LEADER · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0151 | H5 | TEAM_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TEAM_LEADER · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0152 | H5 | USER_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — USER_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0153 | I1 | SSP0025 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0025 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 9 (GetUserIDChk(USER_ID_CHECK) COMMON:UC-02) |
| WK-SSP0025-0154 | SC1 | SSP0025 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SSP0025 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 1 (COMMON:UC-06) |
| WK-SSP0025-0155 | D1 | CELL_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CELL_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InsertR) |
| WK-SSP0025-0156 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0157 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0158 | D1 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InsertR) |
| WK-SSP0025-0159 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0160 | D1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0161 | D1 | PART_LEADER_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PART_LEADER_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0162 | D1 | TEAM_LEADER_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TEAM_LEADER_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0163 | D1 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InsertR) |
| WK-SSP0025-0164 | D1 | U | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — U · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0165 | D1 | USER_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — USER_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (R3 기존행 편집칸) |
| WK-SSP0025-0166 | D1 | USER_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — USER_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0167 | D1 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (R3 기존행 편집칸) |
| WK-SSP0025-0168 | D3 | CELL_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CELL_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InsertR) |
| WK-SSP0025-0169 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0170 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0171 | D3 | ELECTRODE_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ELECTRODE_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InsertR) |
| WK-SSP0025-0172 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0173 | D3 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0174 | D3 | PART_LEADER_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PART_LEADER_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0175 | D3 | TEAM_LEADER_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TEAM_LEADER_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0176 | D3 | TO_SITE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TO_SITE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InsertR) |
| WK-SSP0025-0177 | D3 | U | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — U · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0178 | D3 | USER_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — USER_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (R3 기존행 편집칸) |
| WK-SSP0025-0179 | D3 | USER_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — USER_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0180 | D3 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (R3 기존행 편집칸) |
| WK-SSP0025-0181 | D4 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (InsertButton(IsLock=false 가드)) |
| WK-SSP0025-0182 | D4 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (InsertButton(IsLock=false 가드) R7 신규행 VAL) |
| WK-SSP0025-0183 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (COMMON:UC-05 ACT:SSP0025_ShipmentRequest) |
| WK-SSP0025-0184 | D5 | PART_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PART_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0185 | D5 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (COMMON:UC-05 ACT:SSP0025_ShipmentRequest) |
| WK-SSP0025-0186 | D5 | TEAM_LEADER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TEAM_LEADER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0187 | D5 | USER_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — USER_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0188 | D5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SSP0025-0189 | D6 | SSP0025 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0025 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 5 (InsertButton(IsLock=false 가드) R7 신규행 VAL) |
| WK-SSP0025-0190 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0191 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (COMMON:UC-04 ACT:SSP0025_ShipmentRequest) |
| WK-SSP0025-0192 | E4 | MSG00093 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00093 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0193 | E4 | MSG00251 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00251 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (GetUserIDChk(USER_ID_CHECK) ACT:SSP0025_) |
| WK-SSP0025-0194 | E4 | MSG00284 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00284 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SaveDat) |
| WK-SSP0025-0195 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-04) |
| WK-SSP0025-0196 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0197 | E4 | MSG01261 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01261 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (GetUserIDChk(USER_ID_CHECK)) |
| WK-SSP0025-0198 | E4 | USER_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — USER_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (checkRequiredOfSpread(필수 4칸) ACT:SSP0025) |
| WK-SSP0025-0199 | E4 | cboDivision / Div / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Div / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정)  |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SetChan) |
| WK-SSP0025-0200 | E4 | clbFromSite / Plant Site / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbFromSite / Plant Site / From Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SetChan) |
| WK-SSP0025-0201 | A10 | SSP0025 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0025 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 78 (ACT:SSP0025_ItembyDivisionPopup.DefinePr) |
| WK-SSP0025-0202 | A6 | PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE |  | 35 (ACT:SSP0025_ItembyDivisionPopup.FindButt) |
| WK-SSP0025-0203 | A6 | PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE |  | 39 (ACT:SSP0025_ShipmentRequestorPIC.FindBut) |
| WK-SSP0025-0204 | G1 | cboDivision / Div / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Div / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.FindDat) |
| WK-SSP0025-0205 | G1 | clbDivisionId / Division / Division Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivisionId / Division / Division Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0025_ItembyDivisionPopup.FindData) |
| WK-SSP0025-0206 | G1 | clbFromSite / Plant Site / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSite / Plant Site / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.FindDat) |
| WK-SSP0025-0207 | G1 | clbFromSiteId / From Site / From Site Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSiteId / From Site / From Site Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0025_ItembyDivisionPopup.FindData) |
| WK-SSP0025-0208 | G1 | txtItemId / Material / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Material / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0025_ItembyDivisionPopup.FindData) |
| WK-SSP0025-0209 | G1 | txtModelId / Model / Model Id / Model/Ni | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtModelId / Model / Model Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0025_ItembyDivisionPopup.FindData) |
| WK-SSP0025-0210 | G1 | txtNickName / Nick Name / Model/Nickname | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtNickName / Nick Name / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.FindDat) |
| WK-SSP0025-0211 | G6 | cboDivision / Div / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Div / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.InitCon) |
| WK-SSP0025-0212 | G6 | clbDivisionId / Division / Division Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivisionId / Division / Division Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0213 | G6 | clbFromSiteId / From Site / From Site Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbFromSiteId / From Site / From Site Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0214 | G6 | txtItemId / Material / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Material / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0215 | G6 | txtModelId / Model / Model Id / Model/Ni | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtModelId / Model / Model Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0216 | X-REOPEN | SSP0025 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0025 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 13 (ACT:SSP0025_ItembyDivisionPopup.Dispose ) |
| WK-SSP0025-0217 | H6 | cboDivision / Div / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Div / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (cboDivision) |
| WK-SSP0025-0218 | H6 | clbFromSite / Plant Site / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbFromSite / Plant Site / From Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (clbFromSite) |
| WK-SSP0025-0219 | M3 | SSP0025_ItembyDivisionPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SSP0025_ItembyDivisionPopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 13 (ACT:SSP0025_ItembyDivisionPopup..ctor AC) |
| WK-SSP0025-0220 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (셀 DIVISION_ID) |
| WK-SSP0025-0221 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (R12 신규행 ITEM 팝업) |
| WK-SSP0025-0222 | M4 | N | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — N · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (UserInfoPopup(User/Part/Team)) |
| WK-SSP0025-0223 | M4 | PART_LEADER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PART_LEADER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 13 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0224 | M4 | SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (셀 SITE_DESCRIPTION) |
| WK-SSP0025-0225 | M4 | SSP0025_ItembyDivisionPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SSP0025_ItembyDivisionPopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (SSP0025_ItembyDivisionPopup ACT:SSP0025_) |
| WK-SSP0025-0226 | M4 | TEAM_LEADER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — TEAM_LEADER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 13 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0227 | M4 | USER_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — USER_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 14 (R16 USER_ID 더블클릭 팝업 ACT:SSP0025_Shipment) |
| WK-SSP0025-0228 | M4 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (셀 VALID_YN) |
| WK-SSP0025-0229 | M4 | cboDivision / Div / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDivision / Div / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (cboDivision) |
| WK-SSP0025-0230 | M4 | clbFromSite / Plant Site / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — clbFromSite / Plant Site / From Site · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (clbFromSite) |

## W7 기대값 확정 (126)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0025-0231 | C1 | CboDivision_SelectedIndexChanged → SetCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — CboDivision_SelectedIndexChanged → SetChangedContr: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SSP0025-0232 | C2 | CellClick 순수가드(619/674) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CellClick 순수가드(619/674): 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (CellClick 순수가드(619/674)) |
| WK-SSP0025-0233 | C2 | R15 ComboSelChange 가드(행0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — R15 ComboSelChange 가드(행0): 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (R15 ComboSelChange 가드(행0)) |
| WK-SSP0025-0234 | C2 | SSP0025_ShipmentRequestorPIC.CboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0025_ShipmentRequestorPIC.CboDivision_SelectedI: 진입점 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.CboDivi) |
| WK-SSP0025-0235 | C2 | SSP0025_ShipmentRequestorPIC.SpdMain_Com | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0025_ShipmentRequestorPIC.SpdMain_ComboSelChang: 진입점 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0236 | C3 | CellClick 순수가드(619/674) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — CellClick 순수가드(619/674): 행 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (CellClick 순수가드(619/674)) |
| WK-SSP0025-0237 | C3 | R15 ComboSelChange 가드(행0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — R15 ComboSelChange 가드(행0): 행 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R15 ComboSelChange 가드(행0)) |
| WK-SSP0025-0238 | C3 | SSP0025_ShipmentRequestorPIC.CboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0025_ShipmentRequestorPIC.CboDivision_SelectedI: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.CboDivi) |
| WK-SSP0025-0239 | C3 | SSP0025_ShipmentRequestorPIC.SetChangedC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0025_ShipmentRequestorPIC.SetChangedControl: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0025-0240 | C3 | SSP0025_ShipmentRequestorPIC.SpdMain_Com | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0025_ShipmentRequestorPIC.SpdMain_ComboSelChang: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0241 | C6 | CellClick 순수가드(619/674) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — CellClick 순수가드(619/674): 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (CellClick 순수가드(619/674)) |
| WK-SSP0025-0242 | C6 | R15 ComboSelChange 가드(행0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — R15 ComboSelChange 가드(행0): 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (R15 ComboSelChange 가드(행0)) |
| WK-SSP0025-0243 | C6 | SSP0025_ShipmentRequestorPIC.CboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0025_ShipmentRequestorPIC.CboDivision_SelectedI: 진입점 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.CboDivi) |
| WK-SSP0025-0244 | C6 | SSP0025_ShipmentRequestorPIC.SpdMain_Com | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0025_ShipmentRequestorPIC.SpdMain_ComboSelChang: 진입점 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0245 | B3 | SSP0025_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0025_ItembyDivisionPopup: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (SSP0025_ItembyDivisionPopup) |
| WK-SSP0025-0246 | B3 | SSP0025_ShipmentRequestorPIC.GetSSPUserC | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0025_ShipmentRequestorPIC.GetSSPUserCheck: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0025_ShipmentRequestorPIC.GetSSPU) |
| WK-SSP0025-0247 | B3 | SSP0025_ShipmentRequestorPIC.GetUserIDCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0025_ShipmentRequestorPIC.GetUserIDChk: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0025_ShipmentRequestorPIC.GetUser) |
| WK-SSP0025-0248 | B4 | SSP0025_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0025_ItembyDivisionPopup: 행 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (SSP0025_ItembyDivisionPopup) |
| WK-SSP0025-0249 | B4 | SSP0025_ShipmentRequestorPIC.GetSSPUserC | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0025_ShipmentRequestorPIC.GetSSPUserCheck: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0025_ShipmentRequestorPIC.GetSSPU) |
| WK-SSP0025-0250 | B4 | SSP0025_ShipmentRequestorPIC.GetUserIDCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0025_ShipmentRequestorPIC.GetUserIDChk: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0025_ShipmentRequestorPIC.GetUser) |
| WK-SSP0025-0251 | F4 | FindButton → FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — FindButton → FindData_Main: 행 집계 — F4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (FindButton → FindData_Main) |
| WK-SSP0025-0252 | F4 | SaveButton → SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SaveButton → SaveData: 행 집계 — F4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton → SaveData) |
| WK-SSP0025-0253 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0254 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0025-0255 | A5 | SSP0025_ShipmentRequestorPIC.CreateSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0025_ShipmentRequestorPIC.CreateSpread: 진입점 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.CreateS) |
| WK-SSP0025-0256 | A5 | spdMain(FpSpread) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdMain(FpSpread): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread)) |
| WK-SSP0025-0257 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 7요소: NOT_RUN:5 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0025-0258 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0259 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0025-0260 | H2 | SSP0025_ShipmentRequestorPIC.CreateSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0025_ShipmentRequestorPIC.CreateSpread: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.CreateS) |
| WK-SSP0025-0261 | H2 | spdMain(FpSpread) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdMain(FpSpread): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread)) |
| WK-SSP0025-0262 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0263 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0025-0264 | H5 | SSP0025_ShipmentRequestorPIC.CreateSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0025_ShipmentRequestorPIC.CreateSpread: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.CreateS) |
| WK-SSP0025-0265 | H5 | spdMain(FpSpread) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdMain(FpSpread): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread)) |
| WK-SSP0025-0266 | D1 | EditButton(SwitchLock) + GetSSPUserCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — EditButton(SwitchLock) + GetSSPUserCheck: 행 집계 — D1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (EditButton(SwitchLock) + GetSSPUserCheck) |
| WK-SSP0025-0267 | D1 | R1 초기 전체잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R1 초기 전체잠금: 행 집계 — D1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R1 초기 전체잠금) |
| WK-SSP0025-0268 | D1 | R2 편집권한 게이트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R2 편집권한 게이트: 행 집계 — D1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R2 편집권한 게이트) |
| WK-SSP0025-0269 | D1 | R4 신규행 편집칸 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R4 신규행 편집칸: 행 집계 — D1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R4 신규행 편집칸) |
| WK-SSP0025-0270 | D1 | R8 CellClick 가드(행0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R8 CellClick 가드(행0): 행 집계 — D1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R8 CellClick 가드(행0)) |
| WK-SSP0025-0271 | D1 | R9 CellClick 가드(편집모드) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R9 CellClick 가드(편집모드): 행 집계 — D1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R9 CellClick 가드(편집모드)) |
| WK-SSP0025-0272 | D1 | SSP0025_ShipmentRequestorPIC.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SSP0025_ShipmentRequestorPIC.EditButton: 진입점 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0273 | D3 | EditButton(SwitchLock) + GetSSPUserCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — EditButton(SwitchLock) + GetSSPUserCheck: 행 집계 — D3 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (EditButton(SwitchLock) + GetSSPUserCheck) |
| WK-SSP0025-0274 | D3 | R1 초기 전체잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R1 초기 전체잠금: 행 집계 — D3 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R1 초기 전체잠금) |
| WK-SSP0025-0275 | D3 | R2 편집권한 게이트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R2 편집권한 게이트: 행 집계 — D3 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R2 편집권한 게이트) |
| WK-SSP0025-0276 | D3 | R4 신규행 편집칸 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R4 신규행 편집칸: 행 집계 — D3 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R4 신규행 편집칸) |
| WK-SSP0025-0277 | D3 | R8 CellClick 가드(행0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R8 CellClick 가드(행0): 행 집계 — D3 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R8 CellClick 가드(행0)) |
| WK-SSP0025-0278 | D3 | R9 CellClick 가드(편집모드) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R9 CellClick 가드(편집모드): 행 집계 — D3 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R9 CellClick 가드(편집모드)) |
| WK-SSP0025-0279 | D3 | SSP0025_ShipmentRequestorPIC.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SSP0025_ShipmentRequestorPIC.EditButton: 진입점 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0025_ShipmentRequestorPIC.EditBut) |
| WK-SSP0025-0280 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SSP0025-0281 | D5 | SSP0025_ShipmentRequestorPIC.CreateSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0025_ShipmentRequestorPIC.CreateSpread: 진입점 집계 — D5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.CreateS) |
| WK-SSP0025-0282 | E4 | CellClick Division/PlantSite 선점(628/642) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CellClick Division/PlantSite 선점(628/642): 행 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (CellClick Division/PlantSite 선점(628/642)) |
| WK-SSP0025-0283 | E4 | CellClick 순수가드(619/674) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CellClick 순수가드(619/674): 행 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (CellClick 순수가드(619/674)) |
| WK-SSP0025-0284 | E4 | EditButton(SwitchLock) + GetSSPUserCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EditButton(SwitchLock) + GetSSPUserCheck: 행 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (EditButton(SwitchLock) + GetSSPUserCheck) |
| WK-SSP0025-0285 | E4 | SSP0025_ShipmentRequestorPIC.SetChangedC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0025_ShipmentRequestorPIC.SetChangedControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0025-0286 | E4 | Save 응답판정(S/건수/에러) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — Save 응답판정(S/건수/에러): 행 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (Save 응답판정(S/건수/에러)) |
| WK-SSP0025-0287 | E4 | SaveButton → SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SaveButton → SaveData: 행 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton → SaveData) |
| WK-SSP0025-0288 | E4 | checkRequiredOfSearch(Division 필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — checkRequiredOfSearch(Division 필수): 행 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSearch(Division 필수)) |
| WK-SSP0025-0289 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0290 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-06) |
| WK-SSP0025-0291 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-SSP0025-0292 | A1 | CboDivision_SelectedIndexChanged → SetCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CboDivision_SelectedIndexChanged → SetChangedContr: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SSP0025-0293 | A1 | FindButton → FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton → FindData_Main: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FindButton → FindData_Main) |
| WK-SSP0025-0294 | A1 | PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 35 (ACT:SSP0025_ItembyDivisionPopup.FindButt) |
| WK-SSP0025-0295 | A1 | PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC: 골든 비교 케이스 없음(PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC — 팝업·보 |  | 39 (ACT:SSP0025_ShipmentRequestorPIC.FindBut) |
| WK-SSP0025-0296 | A1 | R11 신규행 SITE 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R11 신규행 SITE 재조회: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (R11 신규행 SITE 재조회) |
| WK-SSP0025-0297 | A1 | checkRequiredOfSearch(Division 필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — checkRequiredOfSearch(Division 필수): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (checkRequiredOfSearch(Division 필수)) |
| WK-SSP0025-0298 | A6 | FindButton → FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — FindButton → FindData_Main: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (FindButton → FindData_Main) |
| WK-SSP0025-0299 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0025-0300 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0025-0301 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0025-0302 | G1 | CboDivision_SelectedIndexChanged → SetCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CboDivision_SelectedIndexChanged → SetChangedContr: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SSP0025-0303 | G1 | FindButton → FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton → FindData_Main: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (FindButton → FindData_Main) |
| WK-SSP0025-0304 | G1 | R11 신규행 SITE 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R11 신규행 SITE 재조회: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R11 신규행 SITE 재조회) |
| WK-SSP0025-0305 | G1 | checkRequiredOfSearch(Division 필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — checkRequiredOfSearch(Division 필수): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSearch(Division 필수)) |
| WK-SSP0025-0306 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0025-0307 | X-ROW | R10 CellClick 가드(Division 선점) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R10 CellClick 가드(Division 선점): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R10 CellClick 가드(Division 선점)) |
| WK-SSP0025-0308 | X-ROW | R17 PART_LEADER 더블클릭 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R17 PART_LEADER 더블클릭: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R17 PART_LEADER 더블클릭) |
| WK-SSP0025-0309 | X-ROW | R18 TEAM_LEADER 더블클릭 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R18 TEAM_LEADER 더블클릭: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R18 TEAM_LEADER 더블클릭) |
| WK-SSP0025-0310 | X-ROW | R5 신규행 DIVISION 셀콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R5 신규행 DIVISION 셀콤보: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R5 신규행 DIVISION 셀콤보) |
| WK-SSP0025-0311 | X-ROW | R6 신규행 SITE 셀콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R6 신규행 SITE 셀콤보: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R6 신규행 SITE 셀콤보) |
| WK-SSP0025-0312 | X-ROW | SSP0025_ItembyDivisionPopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ItembyDivisionPopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0025_ItembyDivisionPopup..ctor:16) |
| WK-SSP0025-0313 | X-ROW | SSP0025_ItembyDivisionPopup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ItembyDivisionPopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0025_ItembyDivisionPopup.CreateSp) |
| WK-SSP0025-0314 | X-ROW | SSP0025_ItembyDivisionPopup.DefineProper | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ItembyDivisionPopup.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.DefinePr) |
| WK-SSP0025-0315 | X-ROW | SSP0025_ItembyDivisionPopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ItembyDivisionPopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0025_ItembyDivisionPopup.Dispose:) |
| WK-SSP0025-0316 | X-ROW | SSP0025_ItembyDivisionPopup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ItembyDivisionPopup.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · REVIEW:1 |  | 2 (ACT:SSP0025_ItembyDivisionPopup.FindButt) |
| WK-SSP0025-0317 | X-ROW | SSP0025_ItembyDivisionPopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ItembyDivisionPopup.FindData: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:1 · PASS:1 |  | 32 (ACT:SSP0025_ItembyDivisionPopup.FindData) |
| WK-SSP0025-0318 | X-ROW | SSP0025_ItembyDivisionPopup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ItembyDivisionPopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SSP0025_ItembyDivisionPopup.Form_Loa) |
| WK-SSP0025-0319 | X-ROW | SSP0025_ItembyDivisionPopup.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ItembyDivisionPopup.InitControls: 진입점 집계 12검사 — NOT_RUN:12 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SSP0025_ItembyDivisionPopup.InitCont) |
| WK-SSP0025-0320 | X-ROW | SSP0025_ItembyDivisionPopup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ItembyDivisionPopup.InitSpread: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SSP0025_ItembyDivisionPopup.InitSpre) |
| WK-SSP0025-0321 | X-ROW | SSP0025_ItembyDivisionPopup.SetMaterial | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ItembyDivisionPopup.SetMaterial: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 50 (ACT:SSP0025_ItembyDivisionPopup.SetMater) |
| WK-SSP0025-0322 | X-ROW | SSP0025_ItembyDivisionPopup.btnButtonLis | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ItembyDivisionPopup.btnButtonList_UsrButto: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SSP0025_ItembyDivisionPopup.btnButto) |
| WK-SSP0025-0323 | X-ROW | SSP0025_ItembyDivisionPopup.clbDivision_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ItembyDivisionPopup.clbDivision_SelectedIn: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0025_ItembyDivisionPopup.clbDivis) |
| WK-SSP0025-0324 | X-ROW | SSP0025_ItembyDivisionPopup.spdMain_Cell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ItembyDivisionPopup.spdMain_CellDoubleClic: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0025_ItembyDivisionPopup.spdMain_) |
| WK-SSP0025-0325 | X-ROW | SSP0025_ShipmentRequestorPIC.CboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.CboDivision_SelectedI: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.CboDivi) |
| WK-SSP0025-0326 | X-ROW | SSP0025_ShipmentRequestorPIC.CreateSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.CreateS) |
| WK-SSP0025-0327 | X-ROW | SSP0025_ShipmentRequestorPIC.DefinePrope | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.DefineP) |
| WK-SSP0025-0328 | X-ROW | SSP0025_ShipmentRequestorPIC.Delete | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.Delete: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/DATA_OP/ENTRY/EXPR/LOCAL, 연결된 요소 검사 없음 |  | 8 (ACT:SSP0025_ShipmentRequestorPIC.Delete ) |
| WK-SSP0025-0329 | X-ROW | SSP0025_ShipmentRequestorPIC.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.FindBut) |
| WK-SSP0025-0330 | X-ROW | SSP0025_ShipmentRequestorPIC.FindData_Ma | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.FindData_Main: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:1 · PASS:1 |  | 7 (ACT:SSP0025_ShipmentRequestorPIC.FindDat) |
| WK-SSP0025-0331 | X-ROW | SSP0025_ShipmentRequestorPIC.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.Form_Lo) |
| WK-SSP0025-0332 | X-ROW | SSP0025_ShipmentRequestorPIC.InitControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.InitCon) |
| WK-SSP0025-0333 | X-ROW | SSP0025_ShipmentRequestorPIC.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.InitSpread: 진입점 집계 16검사 — NOT_RUN:16 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0025_ShipmentRequestorPIC.InitSpr) |
| WK-SSP0025-0334 | X-ROW | SSP0025_ShipmentRequestorPIC.InsertButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.InsertB) |
| WK-SSP0025-0335 | X-ROW | SSP0025_ShipmentRequestorPIC.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.InsertRow: 진입점 집계 25검사 — NOT_RUN:19 · NOPATH:6 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SSP0025_ShipmentRequestorPIC.InsertR) |
| WK-SSP0025-0336 | X-ROW | SSP0025_ShipmentRequestorPIC.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.SaveData: 진입점 집계 13검사 — NOT_RUN:8 · PASS:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.SaveDat) |
| WK-SSP0025-0337 | X-ROW | SSP0025_ShipmentRequestorPIC.SetChangedC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.SetChangedControl: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0025_ShipmentRequestorPIC.SetChan) |
| WK-SSP0025-0338 | X-ROW | SSP0025_ShipmentRequestorPIC.SetImageCel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.SetImageCell: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SetImag) |
| WK-SSP0025-0339 | X-ROW | SSP0025_ShipmentRequestorPIC.SpdMain_Cel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.SpdMain_CellClick: 진입점 집계 15검사 — NOT_RUN:10 · NOPATH:5 (미실행 검사가 남아 판정필요) |  | 29 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0340 | X-ROW | SSP0025_ShipmentRequestorPIC.SpdMain_Cel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.SpdMain_CellDoubleCli: 진입점 집계 18검사 — NOT_RUN:9 · NOPATH:6 · REVIEW:3 |  | 21 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0341 | X-ROW | SSP0025_ShipmentRequestorPIC.SpdMain_Com | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.SpdMain_ComboSelChang: 진입점 집계 27검사 — NOT_RUN:24 · REVIEW:3 |  | 8 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0342 | X-ROW | SSP0025_ShipmentRequestorPIC.SpdMain_Top | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0343 | X-ROW | SSP0025_ShipmentRequestorPIC.btnItemId_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.btnItemId_Click: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.btnItem) |
| WK-SSP0025-0344 | X-ROW | SSP0025_ShipmentRequestorPIC.btnModelId_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0025_ShipmentRequestorPIC.btnModelId_Click: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0025_ShipmentRequestorPIC.btnMode) |
| WK-SSP0025-0345 | X-ROW | cboDivision(UsrCombo, MyDivision) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — cboDivision(UsrCombo, MyDivision): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (cboDivision(UsrCombo, MyDivision)) |
| WK-SSP0025-0346 | X-ROW | clbFromSite(UsrCheckedList, PlantCell) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — clbFromSite(UsrCheckedList, PlantCell): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (clbFromSite(UsrCheckedList, PlantCell)) |
| WK-SSP0025-0347 | X-ROW | txtItemId(다건) + btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — txtItemId(다건) + btnItemId: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (txtItemId(다건) + btnItemId) |
| WK-SSP0025-0348 | X-ROW | txtModelId(다건) + btnModelId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — txtModelId(다건) + btnModelId: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (txtModelId(다건) + btnModelId) |
| WK-SSP0025-0349 | X-ROW | txtNickName | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — txtNickName: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (txtNickName) |
| WK-SSP0025-0350 | X-ROW | usrButton1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — usrButton1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (usrButton1) |
| WK-SSP0025-0351 | G5 | R21 이미지셀 아이콘 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — R21 이미지셀 아이콘: 행 집계 — G5 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (R21 이미지셀 아이콘) |
| WK-SSP0025-0352 | G5 | SSP0025_ShipmentRequestorPIC.SpdMain_Cel | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SSP0025_ShipmentRequestorPIC.SpdMain_CellDoubleCli: 진입점 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0353 | H6 | R21 이미지셀 아이콘 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — R21 이미지셀 아이콘: 행 집계 — H6 11요소: NOPATH:9 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R21 이미지셀 아이콘) |
| WK-SSP0025-0354 | H6 | SSP0025_ShipmentRequestorPIC.SpdMain_Cel | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SSP0025_ShipmentRequestorPIC.SpdMain_CellDoubleCli: 진입점 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |
| WK-SSP0025-0355 | M4 | R21 이미지셀 아이콘 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — R21 이미지셀 아이콘: 행 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R21 이미지셀 아이콘) |
| WK-SSP0025-0356 | M4 | SSP0025_ShipmentRequestorPIC.SpdMain_Cel | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SSP0025_ShipmentRequestorPIC.SpdMain_CellDoubleCli: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0025_ShipmentRequestorPIC.SpdMain) |

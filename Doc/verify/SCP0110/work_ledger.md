# 작업 원장 — SCP0110 · 2026-10-26 12:55

> 검사 인스턴스 324건 중 PASS·NA 25건 외 **299건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 31 | 구현 위치 실존 |
| W4 | 검사기 구현 | 3 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 26 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 96 | 실행 → PASS |
| W7 | 기대값 확정 | 143 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 141 · E2E 96 · 대조표 33 · 하네스 29
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 3건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 31 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 25 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| H5 | DESIGN |  |  |  |  |  | 9 | 12 |  |  | 라벨 명칭 |
| H2 | DESIGN |  |  |  |  |  | 7 | 13 |  |  | 배경·글자색 규칙 |
| A5 | DESIGN |  |  |  |  |  | 7 | 12 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| D1 | EDIT |  |  |  |  |  | 7 | 11 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 7 | 11 |  |  | 행 값 기반 조건부 잠금 |
| A1 | GEN |  |  |  |  |  |  | 18 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 5 | 10 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| E4 | EDIT |  |  |  |  |  | 10 | 1 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G4 | DESIGN |  |  |  |  | 2 | 3 | 4 |  |  | 조회조건 표시·라벨·활성 |
| F4 | DB |  |  |  |  |  | 7 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G6 | GEN |  |  |  |  |  | 3 | 6 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| A6 | GEN |  |  |  |  |  | 5 | 2 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B4 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| DB-SYN | DB |  |  |  |  | 3 |  | 2 |  |  | BE 계정 시노님·권한·대상 객체 |
| G5 | POPUP |  |  |  |  | 2 |  | 3 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 |  | 3 |  |  | 팝업 표준·열림 |
| D5 | EDIT |  |  |  |  |  | 4 | 1 |  |  | 셀 에디터 유형 |
| M4 | POPUP |  |  |  |  |  | 2 | 3 |  |  | 팝업 선택값 반영 |
| D4 | EDIT |  |  |  |  |  | 3 | 1 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| B3 | COMBO |  |  |  | 3 |  |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| B1 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 중복 없음 |
| E5 | EDIT |  |  |  |  | 3 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| C1 | CASCADE |  |  |  |  |  | 2 | 1 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| H3 | DESIGN |  |  |  |  |  | 3 |  |  |  | 셀 병합 = AS-IS |
| X-REASON | DESIGN |  |  |  |  |  |  | 2 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (31)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0110-0001 | X-LOC | Delete(siMain) 신규행 제거/기존행 D→valid_yn='N' | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Delete(siMain) 신규행 제거/기존행 D→valid_yn='N') |
| WK-SCP0110-0002 | X-LOC | Insert(siMain, 편집모드) 기본값 div/opGroup, GR | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Insert(siMain, 편집모드) 기본값 div/opGroup, GR) |
| WK-SCP0110-0003 | X-LOC | LockColumn DIVISION_ID..GROUP_ID (siMain | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn DIVISION_ID..GROUP_ID (siMain) |
| WK-SCP0110-0004 | X-LOC | LockColumn DIVISION_ID..ITEM_ID (siSub 키 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn DIVISION_ID..ITEM_ID (siSub 키) |
| WK-SCP0110-0005 | X-LOC | LockColumn(0..max,true) 조회직후 전잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn(0..max,true) 조회직후 전잠금) |
| WK-SCP0110-0006 | X-LOC | ONLY_STOCK YesOrNo 셀콤보 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ONLY_STOCK YesOrNo 셀콤보) |
| WK-SCP0110-0007 | X-LOC | SAVE_GROUP_MASTER(action I/M/D, valid_yn | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SAVE_GROUP_MASTER(action I/M/D, valid_yn) |
| WK-SCP0110-0008 | X-LOC | SAVE_MODEL_LIST(action=M 만, GROUP_ID 재매핑 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SAVE_MODEL_LIST(action=M 만, GROUP_ID 재매핑) |
| WK-SCP0110-0009 | X-LOC | SetComBoParam(GroupMaster→dtGruop) siSub | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetComBoParam(GroupMaster→dtGruop) siSub) |
| WK-SCP0110-0010 | X-LOC | SetComBoParam(LookupCommon, dtOperationG | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetComBoParam(LookupCommon, dtOperationG) |
| WK-SCP0110-0011 | X-LOC | SetDivisionAuthCheck(0건→조회영역 잠금) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetDivisionAuthCheck(0건→조회영역 잠금)) |
| WK-SCP0110-0012 | X-LOC | SmartColMerge(spdSub) 세로 병합 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SmartColMerge(spdSub) 세로 병합) |
| WK-SCP0110-0013 | X-LOC | SpdMain_CellDoubleClick → FindData_Sub,  | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SpdMain_CellDoubleClick → FindData_Sub, ) |
| WK-SCP0110-0014 | X-LOC | btnItemId → SCM0002_ItembyDivisionPopup( | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnItemId → SCM0002_ItembyDivisionPopup() |
| WK-SCP0110-0015 | X-LOC | btnProject → SCM0002_ProjectbyDivisionPo | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnProject → SCM0002_ProjectbyDivisionPo) |
| WK-SCP0110-0016 | X-LOC | cascade 없음 (SelectedIndexChanged 주석) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cascade 없음 (SelectedIndexChanged 주석)) |
| WK-SCP0110-0017 | X-LOC | cboDivision = GetDivisionWithoutEE + '81 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboDivision = GetDivisionWithoutEE + '81) |
| WK-SCP0110-0018 | X-LOC | cboOperationGroup = LookupCommon(OPERATI | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboOperationGroup = LookupCommon(OPERATI) |
| WK-SCP0110-0019 | X-LOC | siMain 컬럼 (DB 메타 구동, 6컬럼) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (siMain 컬럼 (DB 메타 구동, 6컬럼)) |
| WK-SCP0110-0020 | X-LOC | siSub 컬럼 (DB 메타 구동, 5컬럼) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (siSub 컬럼 (DB 메타 구동, 5컬럼)) |
| WK-SCP0110-0021 | X-LOC | spdMain (Group Name 시트) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain (Group Name 시트)) |
| WK-SCP0110-0022 | X-LOC | spdSub (Model List 시트) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdSub (Model List 시트)) |
| WK-SCP0110-0023 | X-LOC | splitContainer1 (Vertical splitter, 좌 56 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (splitContainer1 (Vertical splitter, 좌 56) |
| WK-SCP0110-0024 | X-LOC | txtGroupName → p_group_name | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtGroupName → p_group_name) |
| WK-SCP0110-0025 | X-LOC | user_id = @LoginUser | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (user_id = @LoginUser) |
| WK-SCP0110-0026 | X-LOC | usrLayoutControl1 (1행 5필드) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrLayoutControl1 (1행 5필드)) |
| WK-SCP0110-0027 | X-LOC | 라벨 리터럴 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (라벨 리터럴) |
| WK-SCP0110-0028 | X-LOC | 저장 후 FindData_Main_Sub 재조회 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (저장 후 FindData_Main_Sub 재조회) |
| WK-SCP0110-0029 | X-LOC | 저장검증 그룹명 중복(신규간/기존대비) MSG00043 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (저장검증 그룹명 중복(신규간/기존대비) MSG00043) |
| WK-SCP0110-0030 | X-LOC | 저장검증 복수 Project 동일그룹 금지(수정간/기존대비) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (저장검증 복수 Project 동일그룹 금지(수정간/기존대비)) |
| WK-SCP0110-0031 | X-LOC | 필수 OPERATION_GROUP*·GROUP_NAME* | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (필수 OPERATION_GROUP*·GROUP_NAME*) |

## W4 검사기 구현 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0110-0032 | B3 | OPERATION_GROUP | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPERATION_GROUP | 있음(SHEET_COLUMNS) | 3 (cboOperationGroup = LookupCommon(OPERATI) |
| WK-SCP0110-0033 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 1 (cboDivision = GetDivisionWithoutEE + '81) |
| WK-SCP0110-0034 | B3 | cboOperationGroup / Operation Group / Op | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboOperationGroup / Operation Group / Operation gr | 있음(FE 소스) | 1 (cboOperationGroup = LookupCommon(OPERATI) |

## W5 검사기 연결 (26)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0110-0035 | B1 | GROUP_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL GROUP_ID | 있음(SHEET_COLUMNS) | 1 (SetComBoParam(GroupMaster→dtGruop) siSub) |
| WK-SCP0110-0036 | B1 | ONLY_STOCK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL ONLY_STOCK | 있음(SHEET_COLUMNS) | 1 (ONLY_STOCK YesOrNo 셀콤보) |
| WK-SCP0110-0037 | B1 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (SetComBoParam(LookupCommon, dtOperationG) |
| WK-SCP0110-0038 | B2 | GROUP_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL GROUP_ID | 있음(SHEET_COLUMNS) | 1 (SetComBoParam(GroupMaster→dtGruop) siSub) |
| WK-SCP0110-0039 | B2 | ONLY_STOCK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL ONLY_STOCK | 있음(SHEET_COLUMNS) | 1 (ONLY_STOCK YesOrNo 셀콤보) |
| WK-SCP0110-0040 | B2 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (SetComBoParam(LookupCommon, dtOperationG) |
| WK-SCP0110-0041 | B4 | GROUP_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL GROUP_ID | 있음(SHEET_COLUMNS) | 1 (SetComBoParam(GroupMaster→dtGruop) siSub) |
| WK-SCP0110-0042 | B4 | ONLY_STOCK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ONLY_STOCK | 있음(SHEET_COLUMNS) | 1 (ONLY_STOCK YesOrNo 셀콤보) |
| WK-SCP0110-0043 | B4 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 3 (cboOperationGroup = LookupCommon(OPERATI) |
| WK-SCP0110-0044 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (cboDivision = GetDivisionWithoutEE + '81) |
| WK-SCP0110-0045 | B4 | cboOperationGroup / Operation Group / Op | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboOperationGroup / Operation Group / Operation gr | 있음(FE 소스) | 1 (cboOperationGroup = LookupCommon(OPERATI) |
| WK-SCP0110-0046 | F2 | SCP0110 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0110 화면 | 판단불가(대상 단위 SCREEN) | 166 (저장검증 그룹명 중복(신규간/기존대비) MSG00043 저장검증 복수 P) |
| WK-SCP0110-0047 | F6 | SCP0110 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0110 화면 | 판단불가(대상 단위 SCREEN) | 159 (ACT:SCP0110_GroupModelMapping.SaveButton) |
| WK-SCP0110-0048 | DB-SYN | P_GROUP_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_GROUP_NAME | 없음(PROC_M 대응 없음) | 1 (COMMON:UC-06) |
| WK-SCP0110-0049 | DB-SYN | P_ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_ITEM_ID | 없음(PROC_M 대응 없음) | 1 (COMMON:UC-06) |
| WK-SCP0110-0050 | DB-SYN | P_PROJECT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_PROJECT_ID | 없음(PROC_M 대응 없음) | 1 (COMMON:UC-06) |
| WK-SCP0110-0051 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (btnItemId → SCM0002_ItembyDivisionPopup() |
| WK-SCP0110-0052 | G4 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnProject | 있음(FE 소스) | 1 (btnProject → SCM0002_ProjectbyDivisionPo) |
| WK-SCP0110-0053 | E5 | GROUP_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL GROUP_ID | 있음(SHEET_COLUMNS) | 1 (SetComBoParam(GroupMaster→dtGruop) siSub) |
| WK-SCP0110-0054 | E5 | ONLY_STOCK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL ONLY_STOCK | 있음(SHEET_COLUMNS) | 1 (ONLY_STOCK YesOrNo 셀콤보) |
| WK-SCP0110-0055 | E5 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (SetComBoParam(LookupCommon, dtOperationG) |
| WK-SCP0110-0056 | G03-WIRE | SCP0110 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0110 화면 | 판단불가(대상 단위 SCREEN) | 11 (ACT:SCP0110_GroupModelMapping..ctor ACT:) |
| WK-SCP0110-0057 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (btnItemId → SCM0002_ItembyDivisionPopup() |
| WK-SCP0110-0058 | G5 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnProject | 있음(FE 소스) | 1 (btnProject → SCM0002_ProjectbyDivisionPo) |
| WK-SCP0110-0059 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (btnItemId → SCM0002_ItembyDivisionPopup() |
| WK-SCP0110-0060 | H6 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnProject | 있음(FE 소스) | 1 (btnProject → SCM0002_ProjectbyDivisionPo) |

## W6 검증 실행 (96)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0110-0061 | J2 | SCP0110 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0110 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 55 (cboDivision = GetDivisionWithoutEE + '81) |
| WK-SCP0110-0062 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0110_GroupModelMapping.InitContro) |
| WK-SCP0110-0063 | C1 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0110_GroupModelMapping.InitContro) |
| WK-SCP0110-0064 | G3 | SCP0110 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0110 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 6 (Form BaseForm + usrConditionPanel1 usrLa) |
| WK-SCP0110-0065 | K-SA | SCP0110 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0110 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 3 (Form BaseForm + usrConditionPanel1 usrLa) |
| WK-SCP0110-0066 | K4 | SCP0110 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0110 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 28 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0110-0067 | F1 | SCP0110 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0110 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 171 (Delete(siMain) 신규행 제거/기존행 D→valid_yn='N') |
| WK-SCP0110-0068 | F5 | SCP0110 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0110 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 5 (Delete(siMain) 신규행 제거/기존행 D→valid_yn='N') |
| WK-SCP0110-0069 | F4 | PKG_SCP0110.P_SCP0110_GET_GROUP_MASTER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0110.P_SCP0110_GET_GROUP_MASTER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 237 (ACT:SCP0110_GroupModelMapping.FindButton) |
| WK-SCP0110-0070 | F4 | PKG_SCP0110.P_SCP0110_GET_MODEL_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0110.P_SCP0110_GET_MODEL_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 244 (COMMON:UC-06 ACT:SCP0110_GroupModelMappi) |
| WK-SCP0110-0071 | F4 | PKG_SCP0110.P_SCP0110_SAVE_GROUP_MASTER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0110.P_SCP0110_SAVE_GROUP_MASTER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 158 (ACT:SCP0110_GroupModelMapping.SaveButton) |
| WK-SCP0110-0072 | F4 | PKG_SCP0110.P_SCP0110_SAVE_MODEL_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0110.P_SCP0110_SAVE_MODEL_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 157 (ACT:SCP0110_GroupModelMapping.SaveButton) |
| WK-SCP0110-0073 | F4 | P_GROUP_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_GROUP_NAME · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (COMMON:UC-06) |
| WK-SCP0110-0074 | F4 | P_ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_ITEM_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (COMMON:UC-06) |
| WK-SCP0110-0075 | F4 | P_PROJECT_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_PROJECT_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (COMMON:UC-06) |
| WK-SCP0110-0076 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (LockColumn DIVISION_ID..GROUP_ID (siMain) |
| WK-SCP0110-0077 | A5 | GROUP_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — GROUP_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (SetComBoParam(GroupMaster→dtGruop) siSub) |
| WK-SCP0110-0078 | A5 | GROUP_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — GROUP_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (spdMain (Group Name 시트) LockColumn DIVIS) |
| WK-SCP0110-0079 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (LockColumn DIVISION_ID..ITEM_ID (siSub 키) |
| WK-SCP0110-0080 | A5 | ONLY_STOCK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ONLY_STOCK · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ONLY_STOCK YesOrNo 셀콤보 LockColumn DIVISI) |
| WK-SCP0110-0081 | A5 | OPERATION_GROUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (SetComBoParam(LookupCommon, dtOperationG) |
| WK-SCP0110-0082 | A5 | PROJECT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (SmartColMerge(spdSub) 세로 병합 저장검증 복수 Proj) |
| WK-SCP0110-0083 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (cboDivision = GetDivisionWithoutEE + '81) |
| WK-SCP0110-0084 | G4 | cboOperationGroup / Operation Group / Op | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (cboOperationGroup = LookupCommon(OPERATI) |
| WK-SCP0110-0085 | G4 | txtGroupName / Group Name | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtGroupName / Group Name · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtGroupName → p_group_name) |
| WK-SCP0110-0086 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (LockColumn DIVISION_ID..GROUP_ID (siMain) |
| WK-SCP0110-0087 | H2 | GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (SetComBoParam(GroupMaster→dtGruop) siSub) |
| WK-SCP0110-0088 | H2 | GROUP_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — GROUP_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (spdMain (Group Name 시트) LockColumn DIVIS) |
| WK-SCP0110-0089 | H2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (LockColumn DIVISION_ID..ITEM_ID (siSub 키) |
| WK-SCP0110-0090 | H2 | ONLY_STOCK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ONLY_STOCK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ONLY_STOCK YesOrNo 셀콤보 LockColumn DIVISI) |
| WK-SCP0110-0091 | H2 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (SetComBoParam(LookupCommon, dtOperationG) |
| WK-SCP0110-0092 | H2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (SmartColMerge(spdSub) 세로 병합 저장검증 복수 Proj) |
| WK-SCP0110-0093 | H3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (SmartColMerge(spdSub) 세로 병합) |
| WK-SCP0110-0094 | H3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (SmartColMerge(spdSub) 세로 병합) |
| WK-SCP0110-0095 | H3 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (SmartColMerge(spdSub) 세로 병합) |
| WK-SCP0110-0096 | H4 | SCP0110 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0110 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SCP0110_GroupModelMapping.spdSub_Top) |
| WK-SCP0110-0097 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (LockColumn DIVISION_ID..GROUP_ID (siMain) |
| WK-SCP0110-0098 | H5 | GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — GROUP_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (SetComBoParam(GroupMaster→dtGruop) siSub) |
| WK-SCP0110-0099 | H5 | GROUP_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — GROUP_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (spdMain (Group Name 시트) LockColumn DIVIS) |
| WK-SCP0110-0100 | H5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ITEM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (LockColumn DIVISION_ID..ITEM_ID (siSub 키) |
| WK-SCP0110-0101 | H5 | ONLY_STOCK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ONLY_STOCK · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ONLY_STOCK YesOrNo 셀콤보 LockColumn DIVISI) |
| WK-SCP0110-0102 | H5 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPERATION_GROUP · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (SetComBoParam(LookupCommon, dtOperationG) |
| WK-SCP0110-0103 | H5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (SmartColMerge(spdSub) 세로 병합 저장검증 복수 Proj) |
| WK-SCP0110-0104 | H5 | cboDivision / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboDivision / Division · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0110_GroupModelMapping.InitSpread) |
| WK-SCP0110-0105 | H5 | cboOperationGroup / Operation Group / Op | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_ |  | 2 (ACT:SCP0110_GroupModelMapping.InitSpread) |
| WK-SCP0110-0106 | I1 | SCP0110 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0110 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 15 (저장검증 그룹명 중복(신규간/기존대비) MSG00043 COMMON:UC) |
| WK-SCP0110-0107 | SC1 | SCP0110 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0110 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 9 (cboDivision = GetDivisionWithoutEE + '81) |
| WK-SCP0110-0108 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 11 (LockColumn DIVISION_ID..GROUP_ID (siMain) |
| WK-SCP0110-0109 | D1 | GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 8 (SetComBoParam(GroupMaster→dtGruop) siSub) |
| WK-SCP0110-0110 | D1 | GROUP_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — GROUP_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (LockColumn DIVISION_ID..GROUP_ID (siMain) |
| WK-SCP0110-0111 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (LockColumn DIVISION_ID..ITEM_ID (siSub 키) |
| WK-SCP0110-0112 | D1 | ONLY_STOCK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ONLY_STOCK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ONLY_STOCK YesOrNo 셀콤보 LockColumn DIVISI) |
| WK-SCP0110-0113 | D1 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (SetComBoParam(LookupCommon, dtOperationG) |
| WK-SCP0110-0114 | D1 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (SmartColMerge(spdSub) 세로 병합 저장검증 복수 Proj) |
| WK-SCP0110-0115 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 11 (LockColumn DIVISION_ID..GROUP_ID (siMain) |
| WK-SCP0110-0116 | D3 | GROUP_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — GROUP_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 8 (SetComBoParam(GroupMaster→dtGruop) siSub) |
| WK-SCP0110-0117 | D3 | GROUP_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — GROUP_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (LockColumn DIVISION_ID..GROUP_ID (siMain) |
| WK-SCP0110-0118 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (LockColumn DIVISION_ID..ITEM_ID (siSub 키) |
| WK-SCP0110-0119 | D3 | ONLY_STOCK | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ONLY_STOCK · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ONLY_STOCK YesOrNo 셀콤보 LockColumn DIVISI) |
| WK-SCP0110-0120 | D3 | OPERATION_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_GROUP · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (SetComBoParam(LookupCommon, dtOperationG) |
| WK-SCP0110-0121 | D3 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (SmartColMerge(spdSub) 세로 병합 저장검증 복수 Proj) |
| WK-SCP0110-0122 | D4 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (Insert(siMain, 편집모드) 기본값 div/opGroup, GR) |
| WK-SCP0110-0123 | D4 | GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (Insert(siMain, 편집모드) 기본값 div/opGroup, GR) |
| WK-SCP0110-0124 | D4 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (Insert(siMain, 편집모드) 기본값 div/opGroup, GR) |
| WK-SCP0110-0125 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0110_GroupModelMapping.InitSpread) |
| WK-SCP0110-0126 | D5 | GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (SetComBoParam(GroupMaster→dtGruop) siSub) |
| WK-SCP0110-0127 | D5 | ONLY_STOCK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ONLY_STOCK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ONLY_STOCK YesOrNo 셀콤보) |
| WK-SCP0110-0128 | D5 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (SetComBoParam(LookupCommon, dtOperationG) |
| WK-SCP0110-0129 | D6 | SCP0110 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0110 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 4 (Insert(siMain, 편집모드) 기본값 div/opGroup, GR) |
| WK-SCP0110-0130 | E4 | GROUP_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — GROUP_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (저장검증 복수 Project 동일그룹 금지(수정간/기존대비)) |
| WK-SCP0110-0131 | E4 | GROUP_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — GROUP_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (필수 OPERATION_GROUP*·GROUP_NAME*) |
| WK-SCP0110-0132 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0110_GroupModelMapping.SaveData:7) |
| WK-SCP0110-0133 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0110_GroupModelMapping.SaveData:9) |
| WK-SCP0110-0134 | E4 | MSG00043 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00043 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (저장검증 그룹명 중복(신규간/기존대비) MSG00043 ACT:SCP01) |
| WK-SCP0110-0135 | E4 | MSG00129 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00129 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0110_GroupModelMapping.spdSub_Act) |
| WK-SCP0110-0136 | E4 | MSG00130 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00130 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0110_GroupModelMapping.EditButton) |
| WK-SCP0110-0137 | E4 | MSG00704 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00704 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0110-0138 | E4 | OPERATION_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — OPERATION_GROUP · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (필수 OPERATION_GROUP*·GROUP_NAME*) |
| WK-SCP0110-0139 | E4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (저장검증 복수 Project 동일그룹 금지(수정간/기존대비)) |
| WK-SCP0110-0140 | A10 | SCP0110 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0110 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 52 (ACT:SCP0110_GroupModelMapping.DefineProp) |
| WK-SCP0110-0141 | A6 | PKG_SCP0110.P_SCP0110_GET_GROUP_MASTER | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0110.P_SCP0110_GET_GROUP_MASTER · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 81 (ACT:SCP0110_GroupModelMapping.FindButton) |
| WK-SCP0110-0142 | A6 | PKG_SCP0110.P_SCP0110_GET_MODEL_LIST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0110.P_SCP0110_GET_MODEL_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 86 (COMMON:UC-06 ACT:SCP0110_GroupModelMappi) |
| WK-SCP0110-0143 | A6 | P_GROUP_NAME | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_GROUP_NAME · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (COMMON:UC-06) |
| WK-SCP0110-0144 | A6 | P_ITEM_ID | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_ITEM_ID · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (COMMON:UC-06) |
| WK-SCP0110-0145 | A6 | P_PROJECT_ID | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_PROJECT_ID · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (COMMON:UC-06) |
| WK-SCP0110-0146 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (cboDivision = GetDivisionWithoutEE + '81) |
| WK-SCP0110-0147 | G1 | cboOperationGroup / Operation Group / Op | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (cboOperationGroup = LookupCommon(OPERATI) |
| WK-SCP0110-0148 | G1 | txtGroupName / Group Name | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtGroupName / Group Name · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (txtGroupName → p_group_name ACT:SCP0110_) |
| WK-SCP0110-0149 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0110_GroupModelMapping.FindData_M) |
| WK-SCP0110-0150 | G1 | txtProject / Project / PJT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / Project / PJT · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0110_GroupModelMapping.FindData_M) |
| WK-SCP0110-0151 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (cboDivision = GetDivisionWithoutEE + '81) |
| WK-SCP0110-0152 | G6 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboOperationGroup = LookupCommon(OPERATI) |
| WK-SCP0110-0153 | G6 | txtGroupName / Group Name | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtGroupName / Group Name · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtGroupName → p_group_name) |
| WK-SCP0110-0154 | X-REOPEN | SCP0110 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0110 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 11 (ACT:SCP0110_GroupModelMapping.Dispose AC) |
| WK-SCP0110-0155 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (btnItemId → SCM0002_ItembyDivisionPopup() |
| WK-SCP0110-0156 | M4 | btnProject | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnProject · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (btnProject → SCM0002_ProjectbyDivisionPo) |

## W7 기대값 확정 (143)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0110-0157 | C1 | cascade 없음 (SelectedIndexChanged 주석) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — cascade 없음 (SelectedIndexChanged 주석): 행 집계 — C1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (cascade 없음 (SelectedIndexChanged 주석)) |
| WK-SCP0110-0158 | DB-SYN | SpdMain_CellDoubleClick → FindData_Sub,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SpdMain_CellDoubleClick → FindData_Sub, 빈그리드 무시: 행 집계 — DB-SYN 7요소: PASS:4 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_CellDoubleClick → FindData_Sub, ) |
| WK-SCP0110-0159 | DB-SYN | 저장 후 FindData_Main_Sub 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 저장 후 FindData_Main_Sub 재조회: 행 집계 — DB-SYN 7요소: PASS:4 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (저장 후 FindData_Main_Sub 재조회) |
| WK-SCP0110-0160 | F4 | SpdMain_CellDoubleClick → FindData_Sub,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SpdMain_CellDoubleClick → FindData_Sub, 빈그리드 무시: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_CellDoubleClick → FindData_Sub, ) |
| WK-SCP0110-0161 | F4 | 저장 후 FindData_Main_Sub 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 저장 후 FindData_Main_Sub 재조회: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (저장 후 FindData_Main_Sub 재조회) |
| WK-SCP0110-0162 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0110-0163 | A5 | Delete(siMain) 신규행 제거/기존행 D→valid_yn='N' | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Delete(siMain) 신규행 제거/기존행 D→valid_yn='N': 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (Delete(siMain) 신규행 제거/기존행 D→valid_yn='N') |
| WK-SCP0110-0164 | A5 | LockColumn(0..max,true) 조회직후 전잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — LockColumn(0..max,true) 조회직후 전잠금: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(0..max,true) 조회직후 전잠금) |
| WK-SCP0110-0165 | A5 | SAVE_GROUP_MASTER(action I/M/D, valid_yn | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SAVE_GROUP_MASTER(action I/M/D, valid_yn, only_sto: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SAVE_GROUP_MASTER(action I/M/D, valid_yn) |
| WK-SCP0110-0166 | A5 | SCP0110_GroupModelMapping.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0110_GroupModelMapping.CreateSpread: 진입점 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0110_GroupModelMapping.CreateSpre) |
| WK-SCP0110-0167 | A5 | SpdMain_CellDoubleClick → FindData_Sub,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SpdMain_CellDoubleClick → FindData_Sub, 빈그리드 무시: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_CellDoubleClick → FindData_Sub, ) |
| WK-SCP0110-0168 | A5 | siMain 컬럼 (DB 메타 구동, 6컬럼) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — siMain 컬럼 (DB 메타 구동, 6컬럼): 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (siMain 컬럼 (DB 메타 구동, 6컬럼)) |
| WK-SCP0110-0169 | A5 | siSub 컬럼 (DB 메타 구동, 5컬럼) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — siSub 컬럼 (DB 메타 구동, 5컬럼): 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (siSub 컬럼 (DB 메타 구동, 5컬럼)) |
| WK-SCP0110-0170 | A5 | spdSub (Model List 시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdSub (Model List 시트): 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (spdSub (Model List 시트)) |
| WK-SCP0110-0171 | A5 | user_id = @LoginUser | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — user_id = @LoginUser: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (user_id = @LoginUser) |
| WK-SCP0110-0172 | A5 | 저장 후 FindData_Main_Sub 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 저장 후 FindData_Main_Sub 재조회: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (저장 후 FindData_Main_Sub 재조회) |
| WK-SCP0110-0173 | A5 | 저장검증 그룹명 중복(신규간/기존대비) MSG00043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 저장검증 그룹명 중복(신규간/기존대비) MSG00043: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (저장검증 그룹명 중복(신규간/기존대비) MSG00043) |
| WK-SCP0110-0174 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 5요소: NOT_RUN:3 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0110-0175 | G4 | SetDivisionAuthCheck(0건→조회영역 잠금) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — SetDivisionAuthCheck(0건→조회영역 잠금): 행 집계 — G4 5요소: NOT_RUN:3 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (SetDivisionAuthCheck(0건→조회영역 잠금)) |
| WK-SCP0110-0176 | G4 | cascade 없음 (SelectedIndexChanged 주석) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — cascade 없음 (SelectedIndexChanged 주석): 행 집계 — G4 5요소: NOT_RUN:3 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (cascade 없음 (SelectedIndexChanged 주석)) |
| WK-SCP0110-0177 | G4 | 라벨 리터럴 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 라벨 리터럴: 행 집계 — G4 5요소: NOT_RUN:3 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (라벨 리터럴) |
| WK-SCP0110-0178 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0110-0179 | H2 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-06: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0110-0180 | H2 | Delete(siMain) 신규행 제거/기존행 D→valid_yn='N' | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Delete(siMain) 신규행 제거/기존행 D→valid_yn='N': 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (Delete(siMain) 신규행 제거/기존행 D→valid_yn='N') |
| WK-SCP0110-0181 | H2 | LockColumn(0..max,true) 조회직후 전잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — LockColumn(0..max,true) 조회직후 전잠금: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(0..max,true) 조회직후 전잠금) |
| WK-SCP0110-0182 | H2 | SAVE_GROUP_MASTER(action I/M/D, valid_yn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SAVE_GROUP_MASTER(action I/M/D, valid_yn, only_sto: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SAVE_GROUP_MASTER(action I/M/D, valid_yn) |
| WK-SCP0110-0183 | H2 | SCP0110_GroupModelMapping.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0110_GroupModelMapping.CreateSpread: 진입점 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0110_GroupModelMapping.CreateSpre) |
| WK-SCP0110-0184 | H2 | SpdMain_CellDoubleClick → FindData_Sub,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SpdMain_CellDoubleClick → FindData_Sub, 빈그리드 무시: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_CellDoubleClick → FindData_Sub, ) |
| WK-SCP0110-0185 | H2 | siMain 컬럼 (DB 메타 구동, 6컬럼) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — siMain 컬럼 (DB 메타 구동, 6컬럼): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (siMain 컬럼 (DB 메타 구동, 6컬럼)) |
| WK-SCP0110-0186 | H2 | siSub 컬럼 (DB 메타 구동, 5컬럼) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — siSub 컬럼 (DB 메타 구동, 5컬럼): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (siSub 컬럼 (DB 메타 구동, 5컬럼)) |
| WK-SCP0110-0187 | H2 | spdSub (Model List 시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdSub (Model List 시트): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (spdSub (Model List 시트)) |
| WK-SCP0110-0188 | H2 | user_id = @LoginUser | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — user_id = @LoginUser: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (user_id = @LoginUser) |
| WK-SCP0110-0189 | H2 | 저장 후 FindData_Main_Sub 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 저장 후 FindData_Main_Sub 재조회: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (저장 후 FindData_Main_Sub 재조회) |
| WK-SCP0110-0190 | H2 | 저장검증 그룹명 중복(신규간/기존대비) MSG00043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 저장검증 그룹명 중복(신규간/기존대비) MSG00043: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (저장검증 그룹명 중복(신규간/기존대비) MSG00043) |
| WK-SCP0110-0191 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0110-0192 | H5 | Delete(siMain) 신규행 제거/기존행 D→valid_yn='N' | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Delete(siMain) 신규행 제거/기존행 D→valid_yn='N': 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (Delete(siMain) 신규행 제거/기존행 D→valid_yn='N') |
| WK-SCP0110-0193 | H5 | LockColumn(0..max,true) 조회직후 전잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — LockColumn(0..max,true) 조회직후 전잠금: 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(0..max,true) 조회직후 전잠금) |
| WK-SCP0110-0194 | H5 | SAVE_GROUP_MASTER(action I/M/D, valid_yn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SAVE_GROUP_MASTER(action I/M/D, valid_yn, only_sto: 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (SAVE_GROUP_MASTER(action I/M/D, valid_yn) |
| WK-SCP0110-0195 | H5 | SCP0110_GroupModelMapping.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0110_GroupModelMapping.CreateSpread: 진입점 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0110_GroupModelMapping.CreateSpre) |
| WK-SCP0110-0196 | H5 | SpdMain_CellDoubleClick → FindData_Sub,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SpdMain_CellDoubleClick → FindData_Sub, 빈그리드 무시: 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_CellDoubleClick → FindData_Sub, ) |
| WK-SCP0110-0197 | H5 | siMain 컬럼 (DB 메타 구동, 6컬럼) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — siMain 컬럼 (DB 메타 구동, 6컬럼): 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (siMain 컬럼 (DB 메타 구동, 6컬럼)) |
| WK-SCP0110-0198 | H5 | siSub 컬럼 (DB 메타 구동, 5컬럼) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — siSub 컬럼 (DB 메타 구동, 5컬럼): 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (siSub 컬럼 (DB 메타 구동, 5컬럼)) |
| WK-SCP0110-0199 | H5 | spdSub (Model List 시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdSub (Model List 시트): 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (spdSub (Model List 시트)) |
| WK-SCP0110-0200 | H5 | user_id = @LoginUser | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — user_id = @LoginUser: 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (user_id = @LoginUser) |
| WK-SCP0110-0201 | H5 | 저장 후 FindData_Main_Sub 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 저장 후 FindData_Main_Sub 재조회: 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (저장 후 FindData_Main_Sub 재조회) |
| WK-SCP0110-0202 | H5 | 저장검증 그룹명 중복(신규간/기존대비) MSG00043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 저장검증 그룹명 중복(신규간/기존대비) MSG00043: 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (저장검증 그룹명 중복(신규간/기존대비) MSG00043) |
| WK-SCP0110-0203 | X-REASON | Dsdm_Changed / spdMainDsdm_Changed 파생 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — Dsdm_Changed / spdMainDsdm_Changed 파생 없음 — AS-IS 빈 본문 cs:1014/1094 |  | 1 (Dsdm_Changed / spdMainDsdm_Changed 파생) |
| WK-SCP0110-0204 | X-REASON | cboDivision 다중 체크(콤마 결합값 전달) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — cboDivision 다중 체크(콤마 결합값 전달) **의도적 단일선택으로 조정(2026-09-29)** — `PKG_SCP0110.P_SCP0110_GET_GROUP_MASTER`가 `WHERE D |  | 1 (cboDivision 다중 체크(콤마 결합값 전달)) |
| WK-SCP0110-0205 | D1 | Delete(siMain) 신규행 제거/기존행 D→valid_yn='N' | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Delete(siMain) 신규행 제거/기존행 D→valid_yn='N': 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (Delete(siMain) 신규행 제거/기존행 D→valid_yn='N') |
| WK-SCP0110-0206 | D1 | LockColumn(0..max,true) 조회직후 전잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — LockColumn(0..max,true) 조회직후 전잠금: 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(0..max,true) 조회직후 전잠금) |
| WK-SCP0110-0207 | D1 | SAVE_GROUP_MASTER(action I/M/D, valid_yn | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SAVE_GROUP_MASTER(action I/M/D, valid_yn, only_sto: 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SAVE_GROUP_MASTER(action I/M/D, valid_yn) |
| WK-SCP0110-0208 | D1 | SCP0110_GroupModelMapping.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0110_GroupModelMapping.EditButton: 진입점 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0110_GroupModelMapping.EditButton) |
| WK-SCP0110-0209 | D1 | SetDivisionAuthCheck(0건→조회영역 잠금) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SetDivisionAuthCheck(0건→조회영역 잠금): 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SetDivisionAuthCheck(0건→조회영역 잠금)) |
| WK-SCP0110-0210 | D1 | SpdMain_CellDoubleClick → FindData_Sub,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SpdMain_CellDoubleClick → FindData_Sub, 빈그리드 무시: 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_CellDoubleClick → FindData_Sub, ) |
| WK-SCP0110-0211 | D1 | siMain 컬럼 (DB 메타 구동, 6컬럼) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — siMain 컬럼 (DB 메타 구동, 6컬럼): 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (siMain 컬럼 (DB 메타 구동, 6컬럼)) |
| WK-SCP0110-0212 | D1 | siSub 컬럼 (DB 메타 구동, 5컬럼) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — siSub 컬럼 (DB 메타 구동, 5컬럼): 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (siSub 컬럼 (DB 메타 구동, 5컬럼)) |
| WK-SCP0110-0213 | D1 | user_id = @LoginUser | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — user_id = @LoginUser: 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (user_id = @LoginUser) |
| WK-SCP0110-0214 | D1 | 저장 후 FindData_Main_Sub 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 저장 후 FindData_Main_Sub 재조회: 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (저장 후 FindData_Main_Sub 재조회) |
| WK-SCP0110-0215 | D1 | 저장검증 그룹명 중복(신규간/기존대비) MSG00043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 저장검증 그룹명 중복(신규간/기존대비) MSG00043: 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (저장검증 그룹명 중복(신규간/기존대비) MSG00043) |
| WK-SCP0110-0216 | D3 | Delete(siMain) 신규행 제거/기존행 D→valid_yn='N' | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Delete(siMain) 신규행 제거/기존행 D→valid_yn='N': 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (Delete(siMain) 신규행 제거/기존행 D→valid_yn='N') |
| WK-SCP0110-0217 | D3 | LockColumn(0..max,true) 조회직후 전잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — LockColumn(0..max,true) 조회직후 전잠금: 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(0..max,true) 조회직후 전잠금) |
| WK-SCP0110-0218 | D3 | SAVE_GROUP_MASTER(action I/M/D, valid_yn | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SAVE_GROUP_MASTER(action I/M/D, valid_yn, only_sto: 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SAVE_GROUP_MASTER(action I/M/D, valid_yn) |
| WK-SCP0110-0219 | D3 | SCP0110_GroupModelMapping.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0110_GroupModelMapping.EditButton: 진입점 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0110_GroupModelMapping.EditButton) |
| WK-SCP0110-0220 | D3 | SetDivisionAuthCheck(0건→조회영역 잠금) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SetDivisionAuthCheck(0건→조회영역 잠금): 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SetDivisionAuthCheck(0건→조회영역 잠금)) |
| WK-SCP0110-0221 | D3 | SpdMain_CellDoubleClick → FindData_Sub,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SpdMain_CellDoubleClick → FindData_Sub, 빈그리드 무시: 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_CellDoubleClick → FindData_Sub, ) |
| WK-SCP0110-0222 | D3 | siMain 컬럼 (DB 메타 구동, 6컬럼) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — siMain 컬럼 (DB 메타 구동, 6컬럼): 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (siMain 컬럼 (DB 메타 구동, 6컬럼)) |
| WK-SCP0110-0223 | D3 | siSub 컬럼 (DB 메타 구동, 5컬럼) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — siSub 컬럼 (DB 메타 구동, 5컬럼): 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (siSub 컬럼 (DB 메타 구동, 5컬럼)) |
| WK-SCP0110-0224 | D3 | user_id = @LoginUser | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — user_id = @LoginUser: 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (user_id = @LoginUser) |
| WK-SCP0110-0225 | D3 | 저장 후 FindData_Main_Sub 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 저장 후 FindData_Main_Sub 재조회: 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (저장 후 FindData_Main_Sub 재조회) |
| WK-SCP0110-0226 | D3 | 저장검증 그룹명 중복(신규간/기존대비) MSG00043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 저장검증 그룹명 중복(신규간/기존대비) MSG00043: 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (저장검증 그룹명 중복(신규간/기존대비) MSG00043) |
| WK-SCP0110-0227 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0110-0228 | D5 | SCP0110_GroupModelMapping.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0110_GroupModelMapping.CreateSpread: 진입점 집계 — D5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0110_GroupModelMapping.CreateSpre) |
| WK-SCP0110-0229 | E4 | SCP0110_GroupModelMapping.SetChangedCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0110_GroupModelMapping.SetChangedControl: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0110_GroupModelMapping.SetChanged) |
| WK-SCP0110-0230 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (COMMON:UC-02) |
| WK-SCP0110-0231 | A1 | LockColumn(0..max,true) 조회직후 전잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — LockColumn(0..max,true) 조회직후 전잠금: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (LockColumn(0..max,true) 조회직후 전잠금) |
| WK-SCP0110-0232 | A1 | PKG_SCP0110.P_SCP0110_GET_GROUP_MASTER | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0110.P_SCP0110_GET_GROUP_MASTER: 골든 비교 케이스 없음(PKG_SCP0110.P_SCP0110_GET_GROUP_MASTER — 팝업·보조 SP 는 golden_cases. |  | 81 (ACT:SCP0110_GroupModelMapping.FindButton) |
| WK-SCP0110-0233 | A1 | PKG_SCP0110.P_SCP0110_GET_MODEL_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0110.P_SCP0110_GET_MODEL_LIST: 골든 비교 케이스 없음(PKG_SCP0110.P_SCP0110_GET_MODEL_LIST — 팝업·보조 SP 는 golden_cases.csv  |  | 86 (COMMON:UC-06 ACT:SCP0110_GroupModelMappi) |
| WK-SCP0110-0234 | A1 | P_GROUP_NAME | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_GROUP_NAME: 골든 비교 케이스 없음(P_GROUP_NAME — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0110-0235 | A1 | P_ITEM_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_ITEM_ID: 골든 비교 케이스 없음(P_ITEM_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0110-0236 | A1 | P_PROJECT_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_PROJECT_ID: 골든 비교 케이스 없음(P_PROJECT_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0110-0237 | A1 | SetComBoParam(GroupMaster→dtGruop) siSub | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SetComBoParam(GroupMaster→dtGruop) siSub GROUP_ID,: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (SetComBoParam(GroupMaster→dtGruop) siSub) |
| WK-SCP0110-0238 | A1 | SetDivisionAuthCheck(0건→조회영역 잠금) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SetDivisionAuthCheck(0건→조회영역 잠금): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (SetDivisionAuthCheck(0건→조회영역 잠금)) |
| WK-SCP0110-0239 | A1 | SpdMain_CellDoubleClick → FindData_Sub,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SpdMain_CellDoubleClick → FindData_Sub, 빈그리드 무시: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (SpdMain_CellDoubleClick → FindData_Sub, ) |
| WK-SCP0110-0240 | A1 | btnItemId → SCM0002_ItembyDivisionPopup( | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnItemId → SCM0002_ItembyDivisionPopup(division+p: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (btnItemId → SCM0002_ItembyDivisionPopup() |
| WK-SCP0110-0241 | A1 | btnProject → SCM0002_ProjectbyDivisionPo | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnProject → SCM0002_ProjectbyDivisionPopup(divisi: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (btnProject → SCM0002_ProjectbyDivisionPo) |
| WK-SCP0110-0242 | A1 | cascade 없음 (SelectedIndexChanged 주석) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cascade 없음 (SelectedIndexChanged 주석): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (cascade 없음 (SelectedIndexChanged 주석)) |
| WK-SCP0110-0243 | A1 | cboDivision = GetDivisionWithoutEE + '81 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision = GetDivisionWithoutEE + '81' 필터, CODE: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (cboDivision = GetDivisionWithoutEE + '81) |
| WK-SCP0110-0244 | A1 | cboOperationGroup = LookupCommon(OPERATI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboOperationGroup = LookupCommon(OPERATION_GROUP) : 행 집계 — A1 5요소: REVIEW:5 |  | 1 (cboOperationGroup = LookupCommon(OPERATI) |
| WK-SCP0110-0245 | A1 | txtGroupName → p_group_name | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtGroupName → p_group_name: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (txtGroupName → p_group_name) |
| WK-SCP0110-0246 | A1 | 라벨 리터럴 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 라벨 리터럴: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (라벨 리터럴) |
| WK-SCP0110-0247 | A1 | 저장 후 FindData_Main_Sub 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 저장 후 FindData_Main_Sub 재조회: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (저장 후 FindData_Main_Sub 재조회) |
| WK-SCP0110-0248 | A6 | SpdMain_CellDoubleClick → FindData_Sub,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SpdMain_CellDoubleClick → FindData_Sub, 빈그리드 무시: 행 집계 — A6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_CellDoubleClick → FindData_Sub, ) |
| WK-SCP0110-0249 | A6 | 저장 후 FindData_Main_Sub 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 저장 후 FindData_Main_Sub 재조회: 행 집계 — A6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (저장 후 FindData_Main_Sub 재조회) |
| WK-SCP0110-0250 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0110-0251 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0110-0252 | G1 | LockColumn(0..max,true) 조회직후 전잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — LockColumn(0..max,true) 조회직후 전잠금: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(0..max,true) 조회직후 전잠금) |
| WK-SCP0110-0253 | G1 | SetComBoParam(GroupMaster→dtGruop) siSub | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SetComBoParam(GroupMaster→dtGruop) siSub GROUP_ID,: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SetComBoParam(GroupMaster→dtGruop) siSub) |
| WK-SCP0110-0254 | G1 | SetDivisionAuthCheck(0건→조회영역 잠금) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SetDivisionAuthCheck(0건→조회영역 잠금): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SetDivisionAuthCheck(0건→조회영역 잠금)) |
| WK-SCP0110-0255 | G1 | btnItemId → SCM0002_ItembyDivisionPopup( | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — btnItemId → SCM0002_ItembyDivisionPopup(division+p: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (btnItemId → SCM0002_ItembyDivisionPopup() |
| WK-SCP0110-0256 | G1 | btnProject → SCM0002_ProjectbyDivisionPo | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — btnProject → SCM0002_ProjectbyDivisionPopup(divisi: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (btnProject → SCM0002_ProjectbyDivisionPo) |
| WK-SCP0110-0257 | G1 | cascade 없음 (SelectedIndexChanged 주석) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — cascade 없음 (SelectedIndexChanged 주석): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (cascade 없음 (SelectedIndexChanged 주석)) |
| WK-SCP0110-0258 | G1 | 라벨 리터럴 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 라벨 리터럴: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (라벨 리터럴) |
| WK-SCP0110-0259 | G1 | 저장 후 FindData_Main_Sub 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 저장 후 FindData_Main_Sub 재조회: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (저장 후 FindData_Main_Sub 재조회) |
| WK-SCP0110-0260 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0110-0261 | G6 | SetDivisionAuthCheck(0건→조회영역 잠금) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — SetDivisionAuthCheck(0건→조회영역 잠금): 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SetDivisionAuthCheck(0건→조회영역 잠금)) |
| WK-SCP0110-0262 | G6 | btnItemId → SCM0002_ItembyDivisionPopup( | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — btnItemId → SCM0002_ItembyDivisionPopup(division+p: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (btnItemId → SCM0002_ItembyDivisionPopup() |
| WK-SCP0110-0263 | G6 | btnProject → SCM0002_ProjectbyDivisionPo | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — btnProject → SCM0002_ProjectbyDivisionPopup(divisi: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (btnProject → SCM0002_ProjectbyDivisionPo) |
| WK-SCP0110-0264 | G6 | cascade 없음 (SelectedIndexChanged 주석) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — cascade 없음 (SelectedIndexChanged 주석): 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (cascade 없음 (SelectedIndexChanged 주석)) |
| WK-SCP0110-0265 | G6 | 라벨 리터럴 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 라벨 리터럴: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (라벨 리터럴) |
| WK-SCP0110-0266 | X-ROW | SCP0110_GroupModelMapping.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.CreateSpread: 진입점 집계 5검사 — NOT_RUN:4 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0110_GroupModelMapping.CreateSpre) |
| WK-SCP0110-0267 | X-ROW | SCP0110_GroupModelMapping.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0110_GroupModelMapping.DefineProp) |
| WK-SCP0110-0268 | X-ROW | SCP0110_GroupModelMapping.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0110_GroupModelMapping.FindButton) |
| WK-SCP0110-0269 | X-ROW | SCP0110_GroupModelMapping.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.FindData_Main: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0110_GroupModelMapping.FindData_M) |
| WK-SCP0110-0270 | X-ROW | SCP0110_GroupModelMapping.FindData_Main_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.FindData_Main_Sub: 진입점 집계 14검사 — NOT_RUN:10 · REVIEW:2 · PASS:2 |  | 9 (ACT:SCP0110_GroupModelMapping.FindData_M) |
| WK-SCP0110-0271 | X-ROW | SCP0110_GroupModelMapping.FindData_Sub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.FindData_Sub: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:1 · PASS:1 |  | 5 (ACT:SCP0110_GroupModelMapping.FindData_S) |
| WK-SCP0110-0272 | X-ROW | SCP0110_GroupModelMapping.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0110_GroupModelMapping.Form_Load) |
| WK-SCP0110-0273 | X-ROW | SCP0110_GroupModelMapping.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.InitControls: 진입점 집계 9검사 — NOT_RUN:7 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0110_GroupModelMapping.InitContro) |
| WK-SCP0110-0274 | X-ROW | SCP0110_GroupModelMapping.InitEvent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.InitEvent: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0110_GroupModelMapping.InitEvent) |
| WK-SCP0110-0275 | X-ROW | SCP0110_GroupModelMapping.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.InitSpread: 진입점 집계 15검사 — NOT_RUN:15 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0110_GroupModelMapping.InitSpread) |
| WK-SCP0110-0276 | X-ROW | SCP0110_GroupModelMapping.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0110_GroupModelMapping.InsertButt) |
| WK-SCP0110-0277 | X-ROW | SCP0110_GroupModelMapping.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.InsertRow: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0110_GroupModelMapping.InsertRow ) |
| WK-SCP0110-0278 | X-ROW | SCP0110_GroupModelMapping.RefreshModelLi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.RefreshModelList: 진입점 집계 3검사 — NOT_RUN:2 · PASS:1 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SCP0110_GroupModelMapping.RefreshMod) |
| WK-SCP0110-0279 | X-ROW | SCP0110_GroupModelMapping.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.SaveData: 진입점 집계 16검사 — NOT_RUN:10 · PASS:4 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCP0110_GroupModelMapping.SaveData:6) |
| WK-SCP0110-0280 | X-ROW | SCP0110_GroupModelMapping.SetChangedCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0110_GroupModelMapping.SetChanged) |
| WK-SCP0110-0281 | X-ROW | SCP0110_GroupModelMapping.SpdMain_CellCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.SpdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0110_GroupModelMapping.SpdMain_Ce) |
| WK-SCP0110-0282 | X-ROW | SCP0110_GroupModelMapping.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0110_GroupModelMapping.SpdMain_Ce) |
| WK-SCP0110-0283 | X-ROW | SCP0110_GroupModelMapping.SpdMain_KeyPre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.SpdMain_KeyPress: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/UI_PROP, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0110_GroupModelMapping.SpdMain_Ke) |
| WK-SCP0110-0284 | X-ROW | SCP0110_GroupModelMapping.SpdSub_ActiveS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.SpdSub_ActiveSheetChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0110_GroupModelMapping.SpdSub_Act) |
| WK-SCP0110-0285 | X-ROW | SCP0110_GroupModelMapping.btnItemId_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0110_GroupModelMapping.btnItemId_) |
| WK-SCP0110-0286 | X-ROW | SCP0110_GroupModelMapping.btnProject_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.btnProject_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0110_GroupModelMapping.btnProject) |
| WK-SCP0110-0287 | X-ROW | SCP0110_GroupModelMapping.spdSub_ActiveS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.spdSub_ActiveSheetChangi: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0110_GroupModelMapping.spdSub_Act) |
| WK-SCP0110-0288 | X-ROW | SCP0110_GroupModelMapping.spdSub_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.spdSub_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0110_GroupModelMapping.spdSub_Cel) |
| WK-SCP0110-0289 | X-ROW | SCP0110_GroupModelMapping.spdSub_TopChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0110_GroupModelMapping.spdSub_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0110_GroupModelMapping.spdSub_Top) |
| WK-SCP0110-0290 | X-ROW | splitContainer1 (Vertical splitter, 좌 56 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — splitContainer1 (Vertical splitter, 좌 566 / 우 622): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (splitContainer1 (Vertical splitter, 좌 56) |
| WK-SCP0110-0291 | G5 | SCP0110_GroupModelMapping.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0110_GroupModelMapping.SpdMain_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0110_GroupModelMapping.SpdMain_Ce) |
| WK-SCP0110-0292 | G5 | SCP0110_GroupModelMapping.spdSub_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0110_GroupModelMapping.spdSub_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0110_GroupModelMapping.spdSub_Cel) |
| WK-SCP0110-0293 | G5 | SpdMain_CellDoubleClick → FindData_Sub,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SpdMain_CellDoubleClick → FindData_Sub, 빈그리드 무시: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_CellDoubleClick → FindData_Sub, ) |
| WK-SCP0110-0294 | H6 | SCP0110_GroupModelMapping.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0110_GroupModelMapping.SpdMain_CellDoubleClick: 진입점 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0110_GroupModelMapping.SpdMain_Ce) |
| WK-SCP0110-0295 | H6 | SCP0110_GroupModelMapping.spdSub_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0110_GroupModelMapping.spdSub_CellDoubleClick: 진입점 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0110_GroupModelMapping.spdSub_Cel) |
| WK-SCP0110-0296 | H6 | SpdMain_CellDoubleClick → FindData_Sub,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SpdMain_CellDoubleClick → FindData_Sub, 빈그리드 무시: 행 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_CellDoubleClick → FindData_Sub, ) |
| WK-SCP0110-0297 | M4 | SCP0110_GroupModelMapping.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0110_GroupModelMapping.SpdMain_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0110_GroupModelMapping.SpdMain_Ce) |
| WK-SCP0110-0298 | M4 | SCP0110_GroupModelMapping.spdSub_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0110_GroupModelMapping.spdSub_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0110_GroupModelMapping.spdSub_Cel) |
| WK-SCP0110-0299 | M4 | SpdMain_CellDoubleClick → FindData_Sub,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SpdMain_CellDoubleClick → FindData_Sub, 빈그리드 무시: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_CellDoubleClick → FindData_Sub, ) |

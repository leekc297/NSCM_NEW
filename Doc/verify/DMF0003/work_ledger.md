# 작업 원장 — DMF0003 · 2026-10-30 05:39

> 검사 인스턴스 3271건 중 PASS·NA 2341건 외 **930건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_FE** — FE 항목은 적용 대상. 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 198 | 재판정 PASS |
| W5 | 검사기 연결 | 77 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 25 | 실행 → PASS |
| W7 | 기대값 확정 | 184 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 446 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 446 · 화면 FE 142 · 사람 판정 / AS-IS 원문 확인 → 재판정 132 · 하네스 77 · 대조표 52 · DB 객체 45 · E2E 25 · DB 11
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 16건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| D3 | EDIT |  |  |  |  |  |  |  |  | 348 | 행 값 기반 조건부 잠금 |
| X-ROW | GEN |  |  | 26 |  |  |  | 12 |  | 32 | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 56 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-REASON | DESIGN |  |  |  |  |  |  | 52 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| X-LOC | GEN |  |  |  |  |  |  | 47 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| G1 | GEN |  |  | 45 |  |  |  |  |  | 1 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| F4 | DB |  |  | 45 |  |  |  |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| B3 | COMBO |  |  | 33 |  | 10 |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| E3 | EDIT |  |  |  |  |  |  | 4 |  | 37 | 필수 입력 검증 |
| M4 | POPUP |  |  |  |  |  |  | 10 |  | 28 | 팝업 선택값 반영 |
| G5 | POPUP |  |  | 26 |  | 4 |  |  |  |  | 팝업 조건 연동(인자) |
| G4 | DESIGN |  |  |  |  | 8 | 21 |  |  |  | 조회조건 표시·라벨·활성 |
| B4 | COMBO |  |  |  |  | 15 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A6 | GEN |  |  | 11 |  |  |  | 3 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| D5 | EDIT |  |  | 11 |  |  |  |  |  |  | 셀 에디터 유형 |
| B1 | COMBO |  |  |  |  | 10 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 10 |  |  |  |  | 콤보 후보 중복 없음 |
| DB-SYN | DB |  |  |  |  | 9 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| E5 | EDIT |  |  |  |  | 7 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| H6 | POPUP |  |  |  |  | 2 | 3 |  |  |  | 팝업 표준·열림 |
| C4 | CASCADE |  |  | 1 |  |  |  |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| E2 | EDIT |  |  |  |  | 1 |  |  |  |  | 날짜 형식·유효성 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |

## W3 동작 수정 (198)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0003-0001 | C4 | chkColor / Color | 화면 FE(적용 예정) | C4 FAIL 수정 — chkColor / Color: 실측[T-3a6f97cf]: 상위 조회조건 [Color] 칸 없음 (FX-DMF0003-189) |  | 1 (HANDLER:chkColor_CheckedChanged) |
| WK-DMF0003-0002 | B3 | 5 | 화면 FE(적용 예정) | B3 FAIL 수정 — 5: 행 집계 — 대조표 5 'Sales Site 재로드 GetSalesSite (L2653~2656/L3103~3111' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FAIL 요소 |  | 1 (5) |
| WK-DMF0003-0003 | B3 | 8 | 화면 FE(적용 예정) | B3 FAIL 수정 — 8: 행 집계 — 대조표 8 'SCP 시간창(81) — LOOKUP SCP_PLANNER_EDIT_FLAG 행 0=차단 ' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FAIL 요소 |  | 1 (8) |
| WK-DMF0003-0004 | B3 | 9 | 화면 FE(적용 예정) | B3 FAIL 수정 — 9: 행 집계 — 대조표 9 'DM류 시간창 — LOOKUP DM_PLANNER_EDIT_FLAG 행 존재=차단 MSG0' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FAIL 요소 |  | 1 (9) |
| WK-DMF0003-0005 | B3 | CA-03 | 화면 FE(적용 예정) | B3 FAIL 수정 — CA-03: 행 집계 — 대조표 CA-03 '§1 `SCP Planner` × 81* × `SCP_PLANNER_EDIT_FLAG` 0' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · |  | 1 (CA-03) |
| WK-DMF0003-0006 | B3 | CE-110 | 화면 FE(적용 예정) | B3 FAIL 수정 — CE-110: 행 집계 — 대조표 CE-110 '§5.3 [원문 무번호] LOOKUP_TYPE / 건수(유효)' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FAIL 요소: clbT |  | 1 (CE-110) |
| WK-DMF0003-0007 | B3 | CE-115 | 화면 FE(적용 예정) | B3 FAIL 수정 — CE-115: 행 집계 — 대조표 CE-115 '§5.3 [원문 무번호] **TMM_MEASURE_ADMIN** / 70(70)' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FAI |  | 1 (CE-115) |
| WK-DMF0003-0008 | B3 | CE-116 | 화면 FE(적용 예정) | B3 FAIL 수정 — CE-116: 행 집계 — 대조표 CE-116 '§5.3 [원문 무번호] **CELL_TYPE** / 21(21)' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FAIL 요소: cl |  | 1 (CE-116) |
| WK-DMF0003-0009 | B3 | CE-117 | 화면 FE(적용 예정) | B3 FAIL 수정 — CE-117: 행 집계 — 대조표 CE-117 '§5.3 [원문 무번호] **DM_BIZ_TYPE** / 3(3)' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FAIL 요소: cl |  | 1 (CE-117) |
| WK-DMF0003-0010 | B3 | CE-118 | 화면 FE(적용 예정) | B3 FAIL 수정 — CE-118: 행 집계 — 대조표 CE-118 '§5.3 [원문 무번호] **DM_BIZ_TYPE_40** / 1(1)' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FAIL 요소: |  | 1 (CE-118) |
| WK-DMF0003-0011 | B3 | CE-119 | 화면 FE(적용 예정) | B3 FAIL 수정 — CE-119: 행 집계 — 대조표 CE-119 '§5.3 [원문 무번호] **EDI_END_CUSTOMER** / 16(16)' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FAIL |  | 1 (CE-119) |
| WK-DMF0003-0012 | B3 | CE-120 | 화면 FE(적용 예정) | B3 FAIL 수정 — CE-120: 행 집계 — 대조표 CE-120 '§5.3 [원문 무번호] **RPA_END_CUSTOMER** / 4(4)' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FAIL 요 |  | 1 (CE-120) |
| WK-DMF0003-0013 | B3 | CE-121 | 화면 FE(적용 예정) | B3 FAIL 수정 — CE-121: 행 집계 — 대조표 CE-121 '§5.3 [원문 무번호] **DM_MEASURE_POSITIONAL_NOTATION** /' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 |  | 1 (CE-121) |
| WK-DMF0003-0014 | B3 | CG-07 | 화면 FE(적용 예정) | B3 FAIL 수정 — CG-07: 행 집계 — 대조표 CG-07 "§7 버킷 배분 / 주→일: 요일비트(기본 '0000010'=FRI) 균등+잔여 마지막, " 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · |  | 1 (CG-07) |
| WK-DMF0003-0015 | B3 | CI-08 | 화면 FE(적용 예정) | B3 FAIL 수정 — CI-08: 행 집계 — 대조표 CI-08 '§9.2 SCP Planner 시간창(81) / LOOKUP `SCP_PLANNER_EDI' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · |  | 1 (CI-08) |
| WK-DMF0003-0016 | B3 | CI-09 | 화면 FE(적용 예정) | B3 FAIL 수정 — CI-09: 행 집계 — 대조표 CI-09 '§9.2 DM Planner류 시간창(81) / LOOKUP `DM_PLANNER_EDIT' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · |  | 1 (CI-09) |
| WK-DMF0003-0017 | B3 | CK-07 | 화면 FE(적용 예정) | B3 FAIL 수정 — CK-07: 행 집계 — 대조표 CK-07 '§11 SCM.SCM0001_GET_LOOKUP_VALUES / ITEM_TYPE_CODE' 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · |  | 1 (CK-07) |
| WK-DMF0003-0018 | B3 | DMF0003_1_MktFcst.GetBizTypebyDivision | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetBizTypebyDivision: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetBizTypebyDivision 의 B3 14요소: NOPATH:10 · PA |  | 3 (ACT:DMF0003_1_MktFcst.GetBizTypebyDivisi) |
| WK-DMF0003-0019 | B3 | DMF0003_1_MktFcst.GetBucketType | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetBucketType: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetBucketType 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2  |  | 2 (ACT:DMF0003_1_MktFcst.GetBucketType:5581) |
| WK-DMF0003-0020 | B3 | DMF0003_1_MktFcst.GetCustomerbyDivision | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetCustomerbyDivision: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetCustomerbyDivision 의 B3 14요소: NOPATH:10 ·  |  | 4 (ACT:DMF0003_1_MktFcst.GetCustomerbyDivis) |
| WK-DMF0003-0021 | B3 | DMF0003_1_MktFcst.GetCustomsHandbook | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetCustomsHandbook: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetCustomsHandbook 의 B3 14요소: NOPATH:10 · PASS:2 |  | 8 (ACT:DMF0003_1_MktFcst.GetCustomsHandbook) |
| WK-DMF0003-0022 | B3 | DMF0003_1_MktFcst.GetDayRange | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetDayRange: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetDayRange 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FA |  | 4 (ACT:DMF0003_1_MktFcst.GetDayRange:5512:1) |
| WK-DMF0003-0023 | B3 | DMF0003_1_MktFcst.GetDivision | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetDivision: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetDivision 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FA |  | 2 (ACT:DMF0003_1_MktFcst.GetDivision:5468:1) |
| WK-DMF0003-0024 | B3 | DMF0003_1_MktFcst.GetEdiSender | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetEdiSender: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetEdiSender 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 ·  |  | 8 (ACT:DMF0003_1_MktFcst.GetEdiSender:6211:) |
| WK-DMF0003-0025 | B3 | DMF0003_1_MktFcst.GetFirstWed | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetFirstWed: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetFirstWed 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FA |  | 9 (ACT:DMF0003_1_MktFcst.GetFirstWed:6851:1) |
| WK-DMF0003-0026 | B3 | DMF0003_1_MktFcst.GetItemType | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetItemType: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetItemType 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 · FA |  | 3 (ACT:DMF0003_1_MktFcst.GetItemType:5593:1) |
| WK-DMF0003-0027 | B3 | DMF0003_1_MktFcst.GetItemType2 | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetItemType2: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetItemType2 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 ·  |  | 3 (ACT:DMF0003_1_MktFcst.GetItemType2:5606:) |
| WK-DMF0003-0028 | B3 | DMF0003_1_MktFcst.GetPlantSitebyEndCusto | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetPlantSitebyEndCustomer: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetPlantSitebyEndCustomer 의 B3 14요소: NOPA |  | 5 (ACT:DMF0003_1_MktFcst.GetPlantSitebyEndC) |
| WK-DMF0003-0029 | B3 | DMF0003_1_MktFcst.GetScmSitebyDivision | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetScmSitebyDivision: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetScmSitebyDivision 의 B3 14요소: NOPATH:10 · PA |  | 5 (ACT:DMF0003_1_MktFcst.GetScmSitebyDivisi) |
| WK-DMF0003-0030 | B3 | DMF0003_1_MktFcst.GetTeambyDivision | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetTeambyDivision: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetTeambyDivision 의 B3 14요소: NOPATH:10 · PASS:2 · |  | 3 (ACT:DMF0003_1_MktFcst.GetTeambyDivision:) |
| WK-DMF0003-0031 | B3 | DMF0003_1_MktFcst.GetWeekNumber | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.GetWeekNumber: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetWeekNumber 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2  |  | 9 (ACT:DMF0003_1_MktFcst.GetWeekNumber:5795) |
| WK-DMF0003-0032 | B3 | DMF0003_1_MktFcst.getDayOfWeek | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0003_1_MktFcst.getDayOfWeek: 진입점 집계 — 대조표 DMF0003_1_MktFcst.getDayOfWeek 의 B3 14요소: NOPATH:10 · PASS:2 · FAIL:2 ·  |  | 3 (ACT:DMF0003_1_MktFcst.getDayOfWeek:6070:) |
| WK-DMF0003-0033 | B3 | clbCustomer / End Customer / Customer | 화면 FE(적용 예정) | B3 FAIL 수정 — clbCustomer / End Customer / Customer: 원장 V-d987a33b SEARCH (FX-DMF0003-016) |  | 4 (ACT:DMF0003_1_MktFcst.cboDivision_Select) |
| WK-DMF0003-0034 | B3 | clbTeam / Team | 화면 FE(적용 예정) | B3 FAIL 수정 — clbTeam / Team: 원장 V-af0b4a18 SEARCH (FX-DMF0003-019) |  | 6 (ACT:DMF0003_1_MktFcst.cboDivision_Select) |
| WK-DMF0003-0035 | F4 | 3 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — 3: 행 집계 — 대조표 3 'AS FROM SITE 필수 — MSG00113(EditButton L876~888, DM' 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소: DM |  | 1 (3) |
| WK-DMF0003-0036 | F4 | 34 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — 34: 행 집계 — 대조표 34 'FindData data_start_pos<0' 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소: DMF0000_GET_MASTER_CHG_PO |  | 1 (34) |
| WK-DMF0003-0037 | F4 | 6 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — 6: 행 집계 — 대조표 6 '공통 콤보 PARAM5 W/S 플래그 — GetSalesSite40(L7047~7066) ' 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소: DM |  | 0 () |
| WK-DMF0003-0038 | F4 | 7 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — 7: 행 집계 — 대조표 7 'SCP Planner 차단 — Edit 82·40(L828~834) / Insert 81(' 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소: DM |  | 0 () |
| WK-DMF0003-0039 | F4 | 8 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — 8: 행 집계 — 대조표 8 'SCP 시간창(81) — LOOKUP SCP_PLANNER_EDIT_FLAG 행 0=차단 ' 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소: DM |  | 0 () |
| WK-DMF0003-0040 | F4 | CK-06 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — CK-06: 행 집계 — 대조표 CK-06 '§11 DM.PR_GET_DAY_RANGE / 기간 기본값' 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소: DMF0000_GET_ |  | 1 (CK-06) |
| WK-DMF0003-0041 | F4 | CRUD:E02:SEARCH | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — CRUD:E02:SEARCH: 행 집계 — 대조표 CRUD:E02:SEARCH '[SEARCH] §2 FindData — 조회 (FindButton L805 → FindD' 의 F4 27요소: NA:23 · F |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0003-0042 | F4 | DMF0000_GET_MASTER_CHG_POPUP | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0000_GET_MASTER_CHG_POPUP: 실측[T-c92f2883]: DMF0000_GET_MASTER_CHG_POPUP: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배 |  | 152 (CH-108 ACT:DMF0003_MatsterChgPopup.FindB) |
| WK-DMF0003-0043 | F4 | DMF0003_1_MktFcst.GetCustomsHandbook | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_1_MktFcst.GetCustomsHandbook: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetCustomsHandbook 의 F4 27요소: NA:23 · FAIL:3 · P |  | 2 (ACT:DMF0003_1_MktFcst.GetCustomsHandbook) |
| WK-DMF0003-0044 | F4 | DMF0003_1_MktFcst.GetDayRange | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_1_MktFcst.GetDayRange: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetDayRange 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요 |  | 2 (ACT:DMF0003_1_MktFcst.GetDayRange:5516:3) |
| WK-DMF0003-0045 | F4 | DMF0003_1_MktFcst.GetEdiSender | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_1_MktFcst.GetEdiSender: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetEdiSender 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL |  | 2 (ACT:DMF0003_1_MktFcst.GetEdiSender:6215:) |
| WK-DMF0003-0046 | F4 | DMF0003_1_MktFcst.GetFcstType | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_1_MktFcst.GetFcstType: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetFcstType 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요 |  | 2 (ACT:DMF0003_1_MktFcst.GetFcstType:6086:3) |
| WK-DMF0003-0047 | F4 | DMF0003_1_MktFcst.GetIncotermsType | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_1_MktFcst.GetIncotermsType: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetIncotermsType 의 F4 27요소: NA:23 · FAIL:3 · PASS: |  | 2 (ACT:DMF0003_1_MktFcst.GetIncotermsType:6) |
| WK-DMF0003-0048 | F4 | DMF0003_1_MktFcst.GetSalesSite | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_1_MktFcst.GetSalesSite: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetSalesSite 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL |  | 2 (ACT:DMF0003_1_MktFcst.GetSalesSite:6130:) |
| WK-DMF0003-0049 | F4 | DMF0003_1_MktFcst.GetSalesSite40 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_1_MktFcst.GetSalesSite40: 진입점 집계 — 대조표 DMF0003_1_MktFcst.GetSalesSite40 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 ·  |  | 2 (ACT:DMF0003_1_MktFcst.GetSalesSite40:615) |
| WK-DMF0003-0050 | F4 | DMF0003_CustDemandAnalysis.FindDataMain | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_CustDemandAnalysis.FindDataMain: 진입점 집계 — 대조표 DMF0003_CustDemandAnalysis.FindDataMain 의 F4 27요소: NA:23 · FAIL |  | 1 (ACT:DMF0003_CustDemandAnalysis.FindDataM) |
| WK-DMF0003-0051 | F4 | DMF0003_CustDemandAnalysis.GetSLOC | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_CustDemandAnalysis.GetSLOC: 진입점 집계 — 대조표 DMF0003_CustDemandAnalysis.GetSLOC 의 F4 27요소: NA:23 · FAIL:3 · PASS: |  | 2 (ACT:DMF0003_CustDemandAnalysis.GetSLOC:9) |
| WK-DMF0003-0052 | F4 | DMF0003_CustDemandAnalysis.GetSPlant | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_CustDemandAnalysis.GetSPlant: 진입점 집계 — 대조표 DMF0003_CustDemandAnalysis.GetSPlant 의 F4 27요소: NA:23 · FAIL:3 · P |  | 2 (ACT:DMF0003_CustDemandAnalysis.GetSPlant) |
| WK-DMF0003-0053 | F4 | DMF0003_GET_BUCKET_TYPE_CODE | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_GET_BUCKET_TYPE_CODE: 실측[T-166a486d]: DMF0003_GET_BUCKET_TYPE_CODE: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배 |  | 7 (CK-04 ACT:DMF0003_1_MktFcst.GetBucketTyp) |
| WK-DMF0003-0054 | F4 | DMF0003_MktFcst.GetCustomsHandbook | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_MktFcst.GetCustomsHandbook: 진입점 집계 — 대조표 DMF0003_MktFcst.GetCustomsHandbook 의 F4 27요소: NA:23 · FAIL:3 · PASS: |  | 2 (ACT:DMF0003_MktFcst.GetCustomsHandbook:7) |
| WK-DMF0003-0055 | F4 | DMF0003_MktFcst.GetDayRange | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_MktFcst.GetDayRange: 진입점 집계 — 대조표 DMF0003_MktFcst.GetDayRange 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소: D |  | 2 (ACT:DMF0003_MktFcst.GetDayRange:6325:3 A) |
| WK-DMF0003-0056 | F4 | DMF0003_MktFcst.GetEdiSender | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_MktFcst.GetEdiSender: 진입점 집계 — 대조표 DMF0003_MktFcst.GetEdiSender 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소: |  | 2 (ACT:DMF0003_MktFcst.GetEdiSender:7111:3 ) |
| WK-DMF0003-0057 | F4 | DMF0003_MktFcst.GetFcstType | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_MktFcst.GetFcstType: 진입점 집계 — 대조표 DMF0003_MktFcst.GetFcstType 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소: D |  | 2 (ACT:DMF0003_MktFcst.GetFcstType:6984:3 A) |
| WK-DMF0003-0058 | F4 | DMF0003_MktFcst.GetIncotermsType | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_MktFcst.GetIncotermsType: 진입점 집계 — 대조표 DMF0003_MktFcst.GetIncotermsType 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 ·  |  | 2 (ACT:DMF0003_MktFcst.GetIncotermsType:700) |
| WK-DMF0003-0059 | F4 | DMF0003_MktFcst.GetLookupValues | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_MktFcst.GetLookupValues: 진입점 집계 — 대조표 DMF0003_MktFcst.GetLookupValues 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FA |  | 2 (ACT:DMF0003_MktFcst.GetLookupValues:7131) |
| WK-DMF0003-0060 | F4 | DMF0003_MktFcst.GetSalesSite | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_MktFcst.GetSalesSite: 진입점 집계 — 대조표 DMF0003_MktFcst.GetSalesSite 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소: |  | 2 (ACT:DMF0003_MktFcst.GetSalesSite:7028:3 ) |
| WK-DMF0003-0061 | F4 | DMF0003_MktFcst.GetSalesSite40 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_MktFcst.GetSalesSite40: 진입점 집계 — 대조표 DMF0003_MktFcst.GetSalesSite40 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL |  | 2 (ACT:DMF0003_MktFcst.GetSalesSite40:7053:) |
| WK-DMF0003-0062 | F4 | DMF0003_PRPopup.GetSLOC | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_PRPopup.GetSLOC: 진입점 집계 — 대조표 DMF0003_PRPopup.GetSLOC 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소: DMF0000_G |  | 2 (ACT:DMF0003_PRPopup.GetSLOC:603:3 ACT:DM) |
| WK-DMF0003-0063 | F4 | DMF0003_PRPopup.GetSPlant | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_PRPopup.GetSPlant: 진입점 집계 — 대조표 DMF0003_PRPopup.GetSPlant 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소: DMF00 |  | 2 (ACT:DMF0003_PRPopup.GetSPlant:585:3 ACT:) |
| WK-DMF0003-0064 | F4 | DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE: 실측[T-9d634966]: DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE: (PROC_M 배선 없음 — AS-IS 엔드포 |  | 106 (ACT:DMF0003_MatsterChgPopup.SaveButton A) |
| WK-DMF0003-0065 | F4 | DMF0003_SspSyncComparePopUp.FindData | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_SspSyncComparePopUp.FindData: 진입점 집계 — 대조표 DMF0003_SspSyncComparePopUp.FindData 의 F4 27요소: NA:23 · FAIL:3 · P |  | 1 (ACT:DMF0003_SspSyncComparePopUp.FindData) |
| WK-DMF0003-0066 | F4 | DMF0003_SspSyncPopUp.FindData | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_SspSyncPopUp.FindData: 진입점 집계 — 대조표 DMF0003_SspSyncPopUp.FindData 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요 |  | 1 (ACT:DMF0003_SspSyncPopUp.FindData) |
| WK-DMF0003-0067 | F4 | DMF0003_T_MktFcst.GetCustomsHandbook | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_T_MktFcst.GetCustomsHandbook: 진입점 집계 — 대조표 DMF0003_T_MktFcst.GetCustomsHandbook 의 F4 27요소: NA:23 · FAIL:3 · P |  | 2 (ACT:DMF0003_T_MktFcst.GetCustomsHandbook) |
| WK-DMF0003-0068 | F4 | DMF0003_T_MktFcst.GetDayRange | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_T_MktFcst.GetDayRange: 진입점 집계 — 대조표 DMF0003_T_MktFcst.GetDayRange 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요 |  | 2 (ACT:DMF0003_T_MktFcst.GetDayRange:5069:3) |
| WK-DMF0003-0069 | F4 | DMF0003_T_MktFcst.GetEdiSender | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_T_MktFcst.GetEdiSender: 진입점 집계 — 대조표 DMF0003_T_MktFcst.GetEdiSender 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL |  | 2 (ACT:DMF0003_T_MktFcst.GetEdiSender:5722:) |
| WK-DMF0003-0070 | F4 | DMF0003_T_MktFcst.GetFcstType | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_T_MktFcst.GetFcstType: 진입점 집계 — 대조표 DMF0003_T_MktFcst.GetFcstType 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요 |  | 2 (ACT:DMF0003_T_MktFcst.GetFcstType:5601:3) |
| WK-DMF0003-0071 | F4 | DMF0003_T_MktFcst.GetIncotermsType | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_T_MktFcst.GetIncotermsType: 진입점 집계 — 대조표 DMF0003_T_MktFcst.GetIncotermsType 의 F4 27요소: NA:23 · FAIL:3 · PASS: |  | 2 (ACT:DMF0003_T_MktFcst.GetIncotermsType:5) |
| WK-DMF0003-0072 | F4 | DMF0003_T_MktFcst.GetSalesSite | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_T_MktFcst.GetSalesSite: 진입점 집계 — 대조표 DMF0003_T_MktFcst.GetSalesSite 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL |  | 2 (ACT:DMF0003_T_MktFcst.GetSalesSite:5645:) |
| WK-DMF0003-0073 | F4 | DMF0003_T_MktFcst.GetSalesSite40 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_T_MktFcst.GetSalesSite40: 진입점 집계 — 대조표 DMF0003_T_MktFcst.GetSalesSite40 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 ·  |  | 2 (ACT:DMF0003_T_MktFcst.GetSalesSite40:566) |
| WK-DMF0003-0074 | F4 | E02 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — E02: 행 집계 — 대조표 E02 '§2 FindData — 조회 (FindButton L805 → FindData L1673' 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소 |  | 1 (E02) |
| WK-DMF0003-0075 | F4 | E03-2 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — E03-2: 행 집계 — 대조표 E03-2 '§3.2 SaveButton (L1340) → SaveData (L2220~2506)' 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요 |  | 1 (E03-2) |
| WK-DMF0003-0076 | F4 | E04-2 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — E04-2: 행 집계 — 대조표 E04-2 '§4.2 SetSaveData (L5395~5522) / SetSaveDataRemove ' 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAI |  | 1 (E04-2) |
| WK-DMF0003-0077 | F4 | HANDLER:FindData | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — HANDLER:FindData: 행 집계 — 대조표 HANDLER:FindData 'AS-IS `DMF0003_MktFcst.cs:1673` (라이브 80행)' 의 F4 27요소: NA:23 · FAIL:3 · |  | 1 (HANDLER:FindData) |
| WK-DMF0003-0078 | F4 | HANDLER:SaveData | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — HANDLER:SaveData: 행 집계 — 대조표 HANDLER:SaveData 'AS-IS `DMF0003_MktFcst.cs:2220` (라이브 199행)' 의 F4 27요소: NA:23 · FAIL:3  |  | 1 (HANDLER:SaveData) |
| WK-DMF0003-0079 | F4 | — | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — —: 행 집계 — 대조표 — '(저장대상 0)' 의 F4 27요소: NA:23 · FAIL:3 · PASS:1 · FAIL 요소: DMF0000_GET_MASTER_CHG_POPUP — 실측[T-c92f2883 |  | 1 (—) |
| WK-DMF0003-0080 | D5 | 12 | 화면 FE(적용 예정) | D5 FAIL 수정 — 12: 행 집계 — 대조표 12 'spdMain_ComboSelChange' 의 D5 49요소: NA:45 · PASS:3 · FAIL:1 · FAIL 요소: MEASURE / Measure — 실측[T-af7 |  | 1 (12) |
| WK-DMF0003-0081 | D5 | 73 | 화면 FE(적용 예정) | D5 FAIL 수정 — 73: 행 집계 — 대조표 73 'MSG00472 FcstType 코드 검증' 의 D5 49요소: NA:45 · PASS:3 · FAIL:1 · FAIL 요소: MEASURE / Measure — 실측[T-af |  | 1 (73) |
| WK-DMF0003-0082 | D5 | BizType / CustomsHandbook / FcstType / I | 화면 FE(적용 예정) | D5 FAIL 수정 — BizType / CustomsHandbook / FcstType / Incoterms / ItemType : 행 집계 — 대조표 BizType / CustomsHandbook / FcstType / Incot |  | 1 (BizType / CustomsHandbook / FcstType / I) |
| WK-DMF0003-0083 | D5 | COMMON:UC-05 | 화면 FE(적용 예정) | D5 FAIL 수정 — COMMON:UC-05: 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 D5 49요소: NA:45 · PASS:3  |  | 1 (COMMON:UC-05) |
| WK-DMF0003-0084 | D5 | DMF0003_1_MktFcst.CreateSpread | 화면 FE(적용 예정) | D5 FAIL 수정 — DMF0003_1_MktFcst.CreateSpread: 진입점 집계 — 대조표 DMF0003_1_MktFcst.CreateSpread 의 D5 49요소: NA:45 · PASS:3 · FAIL:1 · FAIL |  | 10 (ACT:DMF0003_1_MktFcst.CreateSpread:529:1) |
| WK-DMF0003-0085 | D5 | E04-3 | 화면 FE(적용 예정) | D5 FAIL 수정 — E04-3: 행 집계 — 대조표 E04-3 '§4.3 spdMain_ComboSelChange (L3291~3603)' 의 D5 49요소: NA:45 · PASS:3 · FAIL:1 · FAIL 요소: MEAS |  | 1 (E04-3) |
| WK-DMF0003-0086 | D5 | EndCustomerByDivision40Team | 화면 FE(적용 예정) | D5 FAIL 수정 — EndCustomerByDivision40Team: 행 집계 — 대조표 EndCustomerByDivision40Team '(없음)' 의 D5 49요소: NA:45 · PASS:3 · FAIL:1 · FAIL  |  | 1 (EndCustomerByDivision40Team) |
| WK-DMF0003-0087 | D5 | MEASURE / Measure | 화면 FE(적용 예정) | D5 FAIL 수정 — MEASURE / Measure: 실측[T-af790eaa]: MEASURE: AS-IS TEXT(cell_rules) ↔ TO-BE dataType=1 dataMap=Y — AS-IS TEXT 에디터가 아님  |  | 2 (ACT:DMF0003_SspSyncPopUp.InitSpread ACT:) |
| WK-DMF0003-0088 | D5 | Measure | 화면 FE(적용 예정) | D5 FAIL 수정 — Measure: 행 집계 — 대조표 Measure 'mnuId' 의 D5 49요소: NA:45 · PASS:3 · FAIL:1 · FAIL 요소: MEASURE / Measure — 실측[T-af790eaa]: |  | 1 (Measure) |
| WK-DMF0003-0089 | D5 | SiteByEndCustomer | 화면 FE(적용 예정) | D5 FAIL 수정 — SiteByEndCustomer: 행 집계 — 대조표 SiteByEndCustomer 'divisionId, endCustomer' 의 D5 49요소: NA:45 · PASS:3 · FAIL:1 · FAIL 요 |  | 1 (SiteByEndCustomer) |
| WK-DMF0003-0090 | D5 | TeambyDivisionAuth | 화면 FE(적용 예정) | D5 FAIL 수정 — TeambyDivisionAuth: 행 집계 — 대조표 TeambyDivisionAuth '(없음)' 의 D5 49요소: NA:45 · PASS:3 · FAIL:1 · FAIL 요소: MEASURE / Meas |  | 1 (TeambyDivisionAuth) |
| WK-DMF0003-0091 | A6 | 34 | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — 34: 행 집계 — 대조표 34 'FindData data_start_pos<0' 의 A6 12요소: PASS:7 · REVIEW:3 · FAIL:2 · FAIL 요소: PKG_DMF0003.P_DMF0003_ |  | 1 (34) |
| WK-DMF0003-0092 | A6 | 6 | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — 6: 행 집계 — 대조표 6 '공통 콤보 PARAM5 W/S 플래그 — GetSalesSite40(L7047~7066) ' 의 A6 12요소: PASS:7 · REVIEW:3 · FAIL:2 · FAIL 요소: |  | 0 () |
| WK-DMF0003-0093 | A6 | CK-06 | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — CK-06: 행 집계 — 대조표 CK-06 '§11 DM.PR_GET_DAY_RANGE / 기간 기본값' 의 A6 12요소: PASS:7 · REVIEW:3 · FAIL:2 · FAIL 요소: PKG_DMF00 |  | 1 (CK-06) |
| WK-DMF0003-0094 | A6 | CRUD:E02:SEARCH | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — CRUD:E02:SEARCH: 행 집계 — 대조표 CRUD:E02:SEARCH '[SEARCH] §2 FindData — 조회 (FindButton L805 → FindD' 의 A6 12요소: PASS:7 ·  |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0003-0095 | A6 | DMF0003_CustDemandAnalysis.FindDataMain | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0003_CustDemandAnalysis.FindDataMain: 진입점 집계 — 대조표 DMF0003_CustDemandAnalysis.FindDataMain 의 A6 12요소: PASS:7 · REV |  | 1 (ACT:DMF0003_CustDemandAnalysis.FindDataM) |
| WK-DMF0003-0096 | A6 | DMF0003_SspSyncComparePopUp.FindData | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0003_SspSyncComparePopUp.FindData: 진입점 집계 — 대조표 DMF0003_SspSyncComparePopUp.FindData 의 A6 12요소: PASS:7 · REVIEW:3  |  | 1 (ACT:DMF0003_SspSyncComparePopUp.FindData) |
| WK-DMF0003-0097 | A6 | DMF0003_SspSyncPopUp.FindData | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0003_SspSyncPopUp.FindData: 진입점 집계 — 대조표 DMF0003_SspSyncPopUp.FindData 의 A6 12요소: PASS:7 · REVIEW:3 · FAIL:2 · FAI |  | 1 (ACT:DMF0003_SspSyncPopUp.FindData) |
| WK-DMF0003-0098 | A6 | E02 | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — E02: 행 집계 — 대조표 E02 '§2 FindData — 조회 (FindButton L805 → FindData L1673' 의 A6 12요소: PASS:7 · REVIEW:3 · FAIL:2 · FAIL |  | 1 (E02) |
| WK-DMF0003-0099 | A6 | HANDLER:FindData | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — HANDLER:FindData: 행 집계 — 대조표 HANDLER:FindData 'AS-IS `DMF0003_MktFcst.cs:1673` (라이브 80행)' 의 A6 12요소: PASS:7 · REVIEW: |  | 1 (HANDLER:FindData) |
| WK-DMF0003-0100 | A6 | PKG_DMF0003.P_DMF0003_GET_MKT_FCST_COMPA | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — PKG_DMF0003.P_DMF0003_GET_MKT_FCST_COMPARE_POPUP: 원장 V-14cb6885 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['CASE'] ↔ TO-BE ['S |  | 2 (CH-105 CK-05) |
| WK-DMF0003-0101 | A6 | PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA: 원장 V-c65d7696 SP / 원장 V-e9044489 SP / 원장 V-dfbc6aa5 SP / 원장 V-5e5f45bb SP /  |  | 297 (CK-01 ACT:DMF0003_1_MktFcst.FindButton A) |
| WK-DMF0003-0102 | G1 | 15 | 화면 FE(적용 예정) | G1 FAIL 수정 — 15: 행 집계 — 대조표 15 'ValidationCheck' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 · FAIL 요소: drpPeriod / Period — 원장  |  | 0 () |
| WK-DMF0003-0103 | G1 | 2 | 화면 FE(적용 예정) | G1 FAIL 수정 — 2: 행 집계 — 대조표 2 "InitSpread(sType) 5곳 — CreateSpread·Division변경='LO" 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 ·  |  | 1 (2) |
| WK-DMF0003-0104 | G1 | 34 | 화면 FE(적용 예정) | G1 FAIL 수정 — 34: 행 집계 — 대조표 34 'FindData data_start_pos<0' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 · FAIL 요소: drpPeriod / Pe |  | 1 (34) |
| WK-DMF0003-0105 | G1 | 6 | 화면 FE(적용 예정) | G1 FAIL 수정 — 6: 행 집계 — 대조표 6 '공통 콤보 PARAM5 W/S 플래그 — GetSalesSite40(L7047~7066) ' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 ·  |  | 0 () |
| WK-DMF0003-0106 | G1 | 6. HTTP E2E | 화면 FE(적용 예정) | G1 FAIL 수정 — 6. HTTP E2E: 행 집계 — 대조표 6. HTTP E2E '일반 행 M 왕복 생략' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 · FAIL 요소: drpPeriod |  | 1 (6. HTTP E2E) |
| WK-DMF0003-0107 | G1 | AS_FROM_SITE | 화면 FE(적용 예정) | G1 FAIL 수정 — AS_FROM_SITE: 행 집계 — 대조표 AS_FROM_SITE 'param1' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 · FAIL 요소: drpPeriod / P |  | 1 (AS_FROM_SITE) |
| WK-DMF0003-0108 | G1 | CA-07 | 화면 FE(적용 예정) | G1 FAIL 수정 — CA-07: 행 집계 — 대조표 CA-07 '§1 dt8Week 없음(조회 선행 안 함) / MSG00259 차단' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 · FAIL |  | 1 (CA-07) |
| WK-DMF0003-0109 | G1 | CD-03 | 화면 FE(적용 예정) | G1 FAIL 수정 — CD-03: 행 집계 — 대조표 CD-03 '§4 AS_FROM_SITE / `AS_FROM_SITE`(division)' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 ·  |  | 1 (CD-03) |
| WK-DMF0003-0110 | G1 | CD-10 | 화면 FE(적용 예정) | G1 FAIL 수정 — CD-10: 행 집계 — 대조표 CD-10 '§4 PLANT_SITE_ID / 조회조건 dtPlantSite → 행별 `SalesPla' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ER |  | 1 (CD-10) |
| WK-DMF0003-0111 | G1 | CE-05 | 화면 FE(적용 예정) | G1 FAIL 수정 — CE-05: 행 집계 — 대조표 CE-05 '§5 조회 컬럼 강제 / [E20260402] W/S 권한 진입 시 GET_SPREAD_T' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ER |  | 1 (CE-05) |
| WK-DMF0003-0112 | G1 | CF-05 | 화면 FE(적용 예정) | G1 FAIL 수정 — CF-05: 행 집계 — 대조표 CF-05 '§6 저장 성공(Tables 없음) / MSG00004(건수) + 재조회 + viewpor' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ER |  | 1 (CF-05) |
| WK-DMF0003-0113 | G1 | CF-102 | 화면 FE(적용 예정) | G1 FAIL 수정 — CF-102: 행 집계 — 대조표 CF-102 '§6.2 [원문 무번호] 조회 / MSG00097' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 · FAIL 요소: drpP |  | 1 (CF-102) |
| WK-DMF0003-0114 | G1 | CF-103 | 화면 FE(적용 예정) | G1 FAIL 수정 — CF-103: 행 집계 — 대조표 CF-103 '§6.2 [원문 무번호] 조회 / MSG00108' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 · FAIL 요소: drpP |  | 1 (CF-103) |
| WK-DMF0003-0115 | G1 | CF-104 | 화면 FE(적용 예정) | G1 FAIL 수정 — CF-104: 행 집계 — 대조표 CF-104 '§6.2 [원문 무번호] 조회 / MSG00164' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 · FAIL 요소: drpP |  | 1 (CF-104) |
| WK-DMF0003-0116 | G1 | CF-105 | 화면 FE(적용 예정) | G1 FAIL 수정 — CF-105: 행 집계 — 대조표 CF-105 '§6.2 [원문 무번호] 조회 / MSG00665' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 · FAIL 요소: drpP |  | 1 (CF-105) |
| WK-DMF0003-0117 | G1 | CG-07 | 화면 FE(적용 예정) | G1 FAIL 수정 — CG-07: 행 집계 — 대조표 CG-07 "§7 버킷 배분 / 주→일: 요일비트(기본 '0000010'=FRI) 균등+잔여 마지막, " 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ER |  | 1 (CG-07) |
| WK-DMF0003-0118 | G1 | CH-09 | 화면 FE(적용 예정) | G1 FAIL 수정 — CH-09: 행 집계 — 대조표 CH-09 '§8 캐스케이드 / Division→Team→EndCustomer→SalesSite(+Pl' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ER |  | 1 (CH-09) |
| WK-DMF0003-0119 | G1 | CI-02 | 화면 FE(적용 예정) | G1 FAIL 수정 — CI-02: 행 집계 — 대조표 CI-02 '§9 당주 라인 / 초록 BevelBorder — count≥2 시 [E20250313] ' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ER |  | 1 (CI-02) |
| WK-DMF0003-0120 | G1 | CI-07 | 화면 FE(적용 예정) | G1 FAIL 수정 — CI-07: 행 집계 — 대조표 CI-07 '§9 저장 후 / Action 클리어 + UnLockColor + 행 재잠금(빨강 계열)' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERR |  | 1 (CI-07) |
| WK-DMF0003-0121 | G1 | CK-01 | 화면 FE(적용 예정) | G1 FAIL 수정 — CK-01: 행 집계 — 대조표 CK-01 '§11 DM.DMF0003_GET_MKT_FCST_DATA / 조회' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 · FAIL  |  | 1 (CK-01) |
| WK-DMF0003-0122 | G1 | CK-10 | 화면 FE(적용 예정) | G1 FAIL 수정 — CK-10: 행 집계 — 대조표 CK-10 '§11 DataService.GetDMInnerTable / 조회조건 콤보 8축(§1.1-' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ER |  | 1 (CK-10) |
| WK-DMF0003-0123 | G1 | COMMON:UC-02 | 화면 FE(적용 예정) | G1 FAIL 수정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 G1 35요소: NA:21 · FAIL:10 |  | 1 (COMMON:UC-02) |
| WK-DMF0003-0124 | G1 | COMMON:UC-03 | 화면 FE(적용 예정) | G1 FAIL 수정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 G1 35요소: NA:21 · FAIL:10 |  | 1 (COMMON:UC-03) |
| WK-DMF0003-0125 | G1 | COMMON:UC-06 | 화면 FE(적용 예정) | G1 FAIL 수정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G1 35요소: NA:21 · FAIL:10 · PASS: |  | 1 (COMMON:UC-06) |
| WK-DMF0003-0126 | G1 | COMMON:UC-07 | 화면 FE(적용 예정) | G1 FAIL 수정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 G1 35요소: NA:21 · FAIL:10 |  | 1 (COMMON:UC-07) |
| WK-DMF0003-0127 | G1 | CRUD:E02:SEARCH | 화면 FE(적용 예정) | G1 FAIL 수정 — CRUD:E02:SEARCH: 행 집계 — 대조표 CRUD:E02:SEARCH '[SEARCH] §2 FindData — 조회 (FindButton L805 → FindD' 의 G1 35요소: NA:21 · F |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0003-0128 | G1 | E01-1 | 화면 FE(적용 예정) | G1 FAIL 수정 — E01-1: 행 집계 — 대조표 E01-1 '§1.1 InitControls (L422~563) — 조회조건 콤보 로딩·기본값' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 |  | 1 (E01-1) |
| WK-DMF0003-0129 | G1 | E02 | 화면 FE(적용 예정) | G1 FAIL 수정 — E02: 행 집계 — 대조표 E02 '§2 FindData — 조회 (FindButton L805 → FindData L1673' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR: |  | 1 (E02) |
| WK-DMF0003-0130 | G1 | HANDLER:OnShown | 화면 FE(적용 예정) | G1 FAIL 수정 — HANDLER:OnShown: 행 집계 — 대조표 HANDLER:OnShown 'AS-IS `DMF0003_MktFcst.cs:332` (라이브 12행)' 의 G1 35요소: NA:21 · FAIL:10 · P |  | 1 (HANDLER:OnShown) |
| WK-DMF0003-0131 | G1 | HANDLER:btnItemId_Click | 화면 FE(적용 예정) | G1 FAIL 수정 — HANDLER:btnItemId_Click: 행 집계 — 대조표 HANDLER:btnItemId_Click 'AS-IS `DMF0003_MktFcst.cs:5725` (라이브 17행)' 의 G1 35요소: NA |  | 1 (HANDLER:btnItemId_Click) |
| WK-DMF0003-0132 | G1 | HANDLER:btnOwner_Click | 화면 FE(적용 예정) | G1 FAIL 수정 — HANDLER:btnOwner_Click: 행 집계 — 대조표 HANDLER:btnOwner_Click 'AS-IS `DMF0003_MktFcst.cs:6449` (라이브 14행)' 의 G1 35요소: NA:2 |  | 1 (HANDLER:btnOwner_Click) |
| WK-DMF0003-0133 | G1 | HANDLER:btnProject_Click | 화면 FE(적용 예정) | G1 FAIL 수정 — HANDLER:btnProject_Click: 행 집계 — 대조표 HANDLER:btnProject_Click 'AS-IS `DMF0003_MktFcst.cs:5702` (라이브 17행)' 의 G1 35요소:  |  | 1 (HANDLER:btnProject_Click) |
| WK-DMF0003-0134 | G1 | HANDLER:spdMain_CellClick | 화면 FE(적용 예정) | G1 FAIL 수정 — HANDLER:spdMain_CellClick: 행 집계 — 대조표 HANDLER:spdMain_CellClick 'AS-IS `DMF0003_MktFcst.cs:6596` (라이브 74행)' 의 G1 35요소 |  | 1 (HANDLER:spdMain_CellClick) |
| WK-DMF0003-0135 | G1 | `components/MktFcstForm.tsx` | 화면 FE(적용 예정) | G1 FAIL 수정 — `components/MktFcstForm.tsx`: 행 집계 — 대조표 `components/MktFcstForm.tsx` '수정' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERRO |  | 1 (`components/MktFcstForm.tsx`) |
| WK-DMF0003-0136 | G1 | cboAS / AS | 화면 FE(적용 예정) | G1 FAIL 수정 — cboAS / AS: 원장 V-a1348885 SEARCH (FX-DMF0003-003) |  | 4 (ACT:DMF0003_1_MktFcst.FindData ACT:DMF00) |
| WK-DMF0003-0137 | G1 | chkColor / Color | 화면 FE(적용 예정) | G1 FAIL 수정 — chkColor / Color: 원장 V-84383569 SEARCH (FX-DMF0003-002) |  | 32 (ACT:DMF0003_1_MktFcst.FindData ACT:DMF00) |
| WK-DMF0003-0138 | G1 | clbBizType / Biz Type | 화면 FE(적용 예정) | G1 FAIL 수정 — clbBizType / Biz Type: 원장 V-d9b5a2c9 SEARCH (FX-DMF0003-015) |  | 6 (ACT:DMF0003_1_MktFcst.FindData ACT:DMF00) |
| WK-DMF0003-0139 | G1 | clbCustomer / End Customer / Customer | 화면 FE(적용 예정) | G1 FAIL 수정 — clbCustomer / End Customer / Customer: 원장 V-0d8798bf SEARCH (FX-DMF0003-018) |  | 6 (ACT:DMF0003_1_MktFcst.FindData ACT:DMF00) |
| WK-DMF0003-0140 | G1 | clbEDISender / Sender Code / EDISender | 화면 FE(적용 예정) | G1 FAIL 수정 — clbEDISender / Sender Code / EDISender: 원장 V-20252a50 SEARCH (FX-DMF0003-025) |  | 6 (ACT:DMF0003_1_MktFcst.FindData ACT:DMF00) |
| WK-DMF0003-0141 | G1 | clbEndCustomer / End Customer | 화면 FE(적용 예정) | G1 FAIL 수정 — clbEndCustomer / End Customer: 원장 V-0d8798bf SEARCH (FX-DMF0003-018) |  | 2 (ACT:DMF0003_MatsterChgPopup.FindData ACT) |
| WK-DMF0003-0142 | G1 | clbItemType / Item Type | 화면 FE(적용 예정) | G1 FAIL 수정 — clbItemType / Item Type: 원장 V-dba4ba2f SEARCH (FX-DMF0003-005) |  | 6 (ACT:DMF0003_1_MktFcst.FindData ACT:DMF00) |
| WK-DMF0003-0143 | G1 | clbPlantSite / Plant Site | 화면 FE(적용 예정) | G1 FAIL 수정 — clbPlantSite / Plant Site: 원장 V-9b63a879 SEARCH (FX-DMF0003-008) |  | 6 (ACT:DMF0003_1_MktFcst.FindData ACT:DMF00) |
| WK-DMF0003-0144 | G1 | drpPeriod / Period | 화면 FE(적용 예정) | G1 FAIL 수정 — drpPeriod / Period: 원장 V-a1d2192a SEARCH (FX-DMF0003-010) |  | 18 (ACT:DMF0003_1_MktFcst.FindData ACT:DMF00) |
| WK-DMF0003-0145 | G1 | txtItemId / Model / Item Id | 화면 FE(적용 예정) | G1 FAIL 수정 — txtItemId / Model / Item Id: 실측[T-4e914bf7]: 조회조건 Model 칸 없음 (FX-DMF0003-208) |  | 6 (ACT:DMF0003_1_MktFcst.FindData ACT:DMF00) |
| WK-DMF0003-0146 | G1 | — | 화면 FE(적용 예정) | G1 FAIL 수정 — —: 행 집계 — 대조표 — '(저장대상 0)' 의 G1 35요소: NA:21 · FAIL:10 · PASS:3 · ERROR:1 · FAIL 요소: drpPeriod / Period — 원장 V-a1d2192 |  | 0 () |
| WK-DMF0003-0147 | X-ROW | DMF0003_1_MktFcst.FindButton | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_1_MktFcst.FindButton: 진입점 집계 12검사 — REVIEW:4 · PASS:4 · NA:3 · FAIL:1 (FX-DMF0003-205) |  | 1 (ACT:DMF0003_1_MktFcst.FindButton) |
| WK-DMF0003-0148 | X-ROW | DMF0003_1_MktFcst.FindData | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_1_MktFcst.FindData: 진입점 집계 50검사 — NA:18 · PASS:15 · FAIL:10 · REVIEW:4 · ERROR:2 · NOT_RUN:1 (FX-DMF0003-2 |  | 14 (ACT:DMF0003_1_MktFcst.FindData:1453:2 AC) |
| WK-DMF0003-0149 | X-ROW | DMF0003_1_MktFcst.GetBucketType | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_1_MktFcst.GetBucketType: 진입점 집계 5검사 — NOPATH:3 · PASS:1 · FAIL:1 (FX-DMF0003-211) |  | 1 (ACT:DMF0003_1_MktFcst.GetBucketType) |
| WK-DMF0003-0150 | X-ROW | DMF0003_1_MktFcst.btnColumn_Click | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_1_MktFcst.btnColumn_Click: 진입점 집계 8검사 — NA:5 · FAIL:1 · NOT_RUN:1 · NOPATH:1 (FX-DMF0003-240) |  | 2 (ACT:DMF0003_1_MktFcst.btnColumn_Click:49) |
| WK-DMF0003-0151 | X-ROW | DMF0003_1_MktFcst.btnMeasure_Click | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_1_MktFcst.btnMeasure_Click: 진입점 집계 8검사 — NA:5 · NOT_RUN:1 · NOPATH:1 · FAIL:1 (FX-DMF0003-241) |  | 2 (ACT:DMF0003_1_MktFcst.btnMeasure_Click:4) |
| WK-DMF0003-0152 | X-ROW | DMF0003_1_MktFcst.cboDivision_SelectedIn | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_1_MktFcst.cboDivision_SelectedIndexChanged: 진입점 집계 16검사 — NA:8 · PASS:6 · FAIL:2 (FX-DMF0003-242) |  | 5 (ACT:DMF0003_1_MktFcst.cboDivision_Select) |
| WK-DMF0003-0153 | X-ROW | DMF0003_1_MktFcst.clbTeam_SelectedIndexC | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_1_MktFcst.clbTeam_SelectedIndexChanged: 진입점 집계 9검사 — NOT_RUN:3 · PASS:2 · NA:2 · FAIL:2 (FX-DMF0003-243) |  | 3 (ACT:DMF0003_1_MktFcst.clbTeam_SelectedIn) |
| WK-DMF0003-0154 | X-ROW | DMF0003_MatsterChgPopup.FindButton | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_MatsterChgPopup.FindButton: 진입점 집계 7검사 — REVIEW:3 · NA:2 · FAIL:1 · PASS:1 (FX-DMF0003-258) |  | 2 (ACT:DMF0003_MatsterChgPopup.FindButton A) |
| WK-DMF0003-0155 | X-ROW | DMF0003_MatsterChgPopup.FindData | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_MatsterChgPopup.FindData: 진입점 집계 27검사 — NA:12 · PASS:6 · REVIEW:3 · ERROR:3 · FAIL:2 · NOPATH:1 (FX-DMF000 |  | 45 (ACT:DMF0003_MatsterChgPopup.FindData:315) |
| WK-DMF0003-0156 | X-ROW | DMF0003_MatsterChgPopup.SaveButton | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_MatsterChgPopup.SaveButton: 진입점 집계 7검사 — NA:5 · FAIL:2 (FX-DMF0003-267) |  | 1 (ACT:DMF0003_MatsterChgPopup.SaveButton:3) |
| WK-DMF0003-0157 | X-ROW | DMF0003_MatsterChgPopup.SaveData | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_MatsterChgPopup.SaveData: 진입점 집계 22검사 — NA:15 · PASS:3 · FAIL:2 · NOPATH:2 (FX-DMF0003-268) |  | 103 (ACT:DMF0003_MatsterChgPopup.SaveData:408) |
| WK-DMF0003-0158 | X-ROW | DMF0003_MktFcst.FindButton | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_MktFcst.FindButton: 진입점 집계 7검사 — REVIEW:2 · NA:2 · PASS:2 · FAIL:1 (FX-DMF0003-271) |  | 2 (ACT:DMF0003_MktFcst.FindButton ACT:DMF00) |
| WK-DMF0003-0159 | X-ROW | DMF0003_MktFcst.FindData | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_MktFcst.FindData: 진입점 집계 37검사 — NA:14 · PASS:11 · FAIL:8 · REVIEW:2 · NOT_RUN:1 · ERROR:1 (FX-DMF0003-272) |  | 59 (ACT:DMF0003_MktFcst.FindData:1675:1 ACT:) |
| WK-DMF0003-0160 | X-ROW | DMF0003_MktFcst.GetBucketType | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_MktFcst.GetBucketType: 진입점 집계 4검사 — PASS:1 · NA:1 · FAIL:1 · NOPATH:1 (FX-DMF0003-274) |  | 6 (ACT:DMF0003_MktFcst.GetBucketType ACT:DM) |
| WK-DMF0003-0161 | X-ROW | DMF0003_MktFcst.btnColumn_Click | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_MktFcst.btnColumn_Click: 진입점 집계 10검사 — NA:7 · NOT_RUN:1 · NOPATH:1 · FAIL:1 (FX-DMF0003-288) |  | 6 (ACT:DMF0003_MktFcst.btnColumn_Click:5752) |
| WK-DMF0003-0162 | X-ROW | DMF0003_MktFcst.btnMeasure_Click | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_MktFcst.btnMeasure_Click: 진입점 집계 10검사 — NA:7 · NOT_RUN:1 · NOPATH:1 · FAIL:1 (FX-DMF0003-289) |  | 6 (ACT:DMF0003_MktFcst.btnMeasure_Click:576) |
| WK-DMF0003-0163 | X-ROW | DMF0003_MktFcst.spdMain_CellDoubleClick | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_MktFcst.spdMain_CellDoubleClick: 진입점 집계 41검사 — NA:22 · NOT_RUN:8 · PASS:5 · NOPATH:4 · ERROR:1 · FAIL:1 (F |  | 187 (ACT:DMF0003_MktFcst.spdMain_CellDoubleCl) |
| WK-DMF0003-0164 | X-ROW | DMF0003_SspSyncPopUp.InitSpread | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_SspSyncPopUp.InitSpread: 진입점 집계 50검사 — NA:35 · PASS:14 · FAIL:1 (FX-DMF0003-309) |  | 14 (ACT:DMF0003_SspSyncPopUp.InitSpread ACT:) |
| WK-DMF0003-0165 | X-ROW | DMF0003_T_MktFcst.FindButton | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_T_MktFcst.FindButton: 진입점 집계 7검사 — REVIEW:2 · NA:2 · PASS:2 · FAIL:1 (FX-DMF0003-312) |  | 2 (ACT:DMF0003_T_MktFcst.FindButton ACT:DMF) |
| WK-DMF0003-0166 | X-ROW | DMF0003_T_MktFcst.FindData | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_T_MktFcst.FindData: 진입점 집계 43검사 — NA:17 · PASS:11 · FAIL:10 · REVIEW:2 · ERROR:2 · NOT_RUN:1 (FX-DMF0003-3 |  | 121 (ACT:DMF0003_T_MktFcst.FindData:1085:1 AC) |
| WK-DMF0003-0167 | X-ROW | DMF0003_T_MktFcst.GetBucketType | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_T_MktFcst.GetBucketType: 진입점 집계 4검사 — NA:1 · FAIL:1 · NOPATH:1 · PASS:1 (FX-DMF0003-315) |  | 6 (ACT:DMF0003_T_MktFcst.GetBucketType ACT:) |
| WK-DMF0003-0168 | X-ROW | DMF0003_T_MktFcst.btnColumn_Click | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_T_MktFcst.btnColumn_Click: 진입점 집계 10검사 — NA:7 · NOT_RUN:1 · NOPATH:1 · FAIL:1 (FX-DMF0003-328) |  | 5 (ACT:DMF0003_T_MktFcst.btnColumn_Click:45) |
| WK-DMF0003-0169 | X-ROW | DMF0003_T_MktFcst.btnMeasure_Click | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_T_MktFcst.btnMeasure_Click: 진입점 집계 10검사 — NA:7 · NOT_RUN:1 · NOPATH:1 · FAIL:1 (FX-DMF0003-329) |  | 5 (ACT:DMF0003_T_MktFcst.btnMeasure_Click:4) |
| WK-DMF0003-0170 | X-ROW | DMF0003_T_MktFcst.cboDivision_SelectedIn | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_T_MktFcst.cboDivision_SelectedIndexChanged: 진입점 집계 17검사 — NA:8 · PASS:7 · FAIL:2 (FX-DMF0003-330) |  | 52 (ACT:DMF0003_T_MktFcst.cboDivision_Select) |
| WK-DMF0003-0171 | X-ROW | DMF0003_T_MktFcst.clbTeam_SelectedIndexC | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_T_MktFcst.clbTeam_SelectedIndexChanged: 진입점 집계 7검사 — NA:3 · PASS:2 · FAIL:2 (FX-DMF0003-331) |  | 12 (ACT:DMF0003_T_MktFcst.clbTeam_SelectedIn) |
| WK-DMF0003-0172 | X-ROW | DMF0003_T_MktFcst.spdMain_CellDoubleClic | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0003_T_MktFcst.spdMain_CellDoubleClick: 진입점 집계 41검사 — NA:22 · NOT_RUN:8 · PASS:5 · NOPATH:4 · ERROR:1 · FAIL:1  |  | 177 (ACT:DMF0003_T_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0173 | G5 | 13 | 화면 FE(적용 예정) | G5 FAIL 수정 — 13: 행 집계 — 대조표 13 'spdMain_CellDoubleClick' 의 G5 132요소: NA:94 · PASS:22 · FAIL:12 · NOPATH:4 · FAIL 요소: C — 원장 V-2dda |  | 1 (13) |
| WK-DMF0003-0174 | G5 | 2 | 화면 FE(적용 예정) | G5 FAIL 수정 — 2: 행 집계 — 대조표 2 "InitSpread(sType) 5곳 — CreateSpread·Division변경='LO" 의 G5 132요소: NA:94 · PASS:22 · FAIL:12 · NOPATH:4 |  | 1 (2) |
| WK-DMF0003-0175 | G5 | C | 화면 FE(적용 예정) | G5 FAIL 수정 — C: 원장 V-2dda3c64 ASIS / 원장 V-9131aabd ASIS / 원장 V-d3ac0e98 ASIS / 원장 V-7d612a9e ASIS / 원장 V-3b167019 ASIS / 원장 V-d69b |  | 2 (C-119 HANDLER:spdMain_KeyUp) |
| WK-DMF0003-0176 | G5 | CF-05 | 화면 FE(적용 예정) | G5 FAIL 수정 — CF-05: 행 집계 — 대조표 CF-05 '§6 저장 성공(Tables 없음) / MSG00004(건수) + 재조회 + viewpor' 의 G5 132요소: NA:94 · PASS:22 · FAIL:12 ·  |  | 1 (CF-05) |
| WK-DMF0003-0177 | G5 | CF-06 | 화면 FE(적용 예정) | G5 FAIL 수정 — CF-06: 행 집계 — 대조표 CF-06 '§6 SP 가 Tables[0] 반환 / 그 메시지 표시 + Tables[1] 있으면 Ss' 의 G5 132요소: NA:94 · PASS:22 · FAIL:12 ·  |  | 1 (CF-06) |
| WK-DMF0003-0178 | G5 | CH-102 | 화면 FE(적용 예정) | G5 FAIL 수정 — CH-102: 행 집계 — 대조표 CH-102 '§8 [원문 무번호] PR (Request Info) / `DMF0003_GET_PRPOP' 의 G5 132요소: NA:94 · PASS:22 · FAIL:12  |  | 1 (CH-102) |
| WK-DMF0003-0179 | G5 | CH-103 | 화면 FE(적용 예정) | G5 FAIL 수정 — CH-103: 행 집계 — 대조표 CH-103 '§8 [원문 무번호] PR History / `DMF0003_GET_PR_HISTORY_P' 의 G5 132요소: NA:94 · PASS:22 · FAIL:12  |  | 1 (CH-103) |
| WK-DMF0003-0180 | G5 | CH-105 | 화면 FE(적용 예정) | G5 FAIL 수정 — CH-105: 행 집계 — 대조표 CH-105 '§8 [원문 무번호] SSP Sync Compare / `DMF0003_GET_MKT_FC' 의 G5 132요소: NA:94 · PASS:22 · FAIL:12  |  | 1 (CH-105) |
| WK-DMF0003-0181 | G5 | CH-108 | 화면 FE(적용 예정) | G5 FAIL 수정 — CH-108: 행 집계 — 대조표 CH-108 '§8 [원문 무번호] **Master Change** / `DMF0000_GET_MASTE' 의 G5 132요소: NA:94 · PASS:22 · FAIL:12  |  | 1 (CH-108) |
| WK-DMF0003-0182 | G5 | CK-05 | 화면 FE(적용 예정) | G5 FAIL 수정 — CK-05: 행 집계 — 대조표 CK-05 '§11 DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP / 동기화 비교' 의 G5 132요소: NA:94 · PASS:22 · FAIL:12 ·  |  | 1 (CK-05) |
| WK-DMF0003-0183 | G5 | CK-11 | 화면 FE(적용 예정) | G5 FAIL 수정 — CK-11: 행 집계 — 대조표 CK-11 '§11 (팝업 경유) DMF0003_GET_PRPOPUP/GET_PR_HISTORY_POP' 의 G5 132요소: NA:94 · PASS:22 · FAIL:12 ·  |  | 1 (CK-11) |
| WK-DMF0003-0184 | G5 | DMF0003_MktFcst | 화면 FE(적용 예정) | G5 FAIL 수정 — DMF0003_MktFcst: 원장 V-84af1dc6 ASIS / 원장 V-9d72c711 ASIS / 원장 V-046f681e ASIS / 원장 V-a7b2c013 ASIS / 원장 V-1fae3d2f AS |  | 3 (HANDLER:spdMain_CellDoubleClick HANDLER:) |
| WK-DMF0003-0185 | G5 | DMF0003_T_MktFcst | 화면 FE(적용 예정) | G5 FAIL 수정 — DMF0003_T_MktFcst: 원장 V-9ef5ec0e ASIS / 원장 V-cce72a64 ASIS / 원장 V-4980f96a ASIS / 원장 V-756a4574 ASIS / 원장 V-43f3e3cc  |  | 1 (ACT:DMF0003_T_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0186 | G5 | E04-4 | 화면 FE(적용 예정) | G5 FAIL 수정 — E04-4: 행 집계 — 대조표 E04-4 '§4.4 spdMain_CellDoubleClick (L3604~3942)' 의 G5 132요소: NA:94 · PASS:22 · FAIL:12 · NOPATH:4  |  | 1 (E04-4) |
| WK-DMF0003-0187 | G5 | E04-5 | 화면 FE(적용 예정) | G5 FAIL 수정 — E04-5: 행 집계 — 대조표 E04-5 '§4.5 spdMain_KeyUp (L5636~5700) / EditChange (L648' 의 G5 132요소: NA:94 · PASS:22 · FAIL:12 ·  |  | 1 (E04-5) |
| WK-DMF0003-0188 | G5 | E06 | 화면 FE(적용 예정) | G5 FAIL 수정 — E06: 행 집계 — 대조표 E06 '§6 호출 팝업 상세 (8종)' 의 G5 132요소: NA:94 · PASS:22 · FAIL:12 · NOPATH:4 · FAIL 요소: C — 원장 V-2dda3c64  |  | 1 (E06) |
| WK-DMF0003-0189 | G5 | M | 화면 FE(적용 예정) | G5 FAIL 수정 — M: 원장 V-2dda3c64 ASIS / 원장 V-9131aabd ASIS / 원장 V-d69b319c ASIS / 원장 V-ae56a1a3 ASIS / 원장 V-6b81da15 ASIS / 원장 V-27f9 |  | 1 (MODAL:MeasureSelectModal) |
| WK-DMF0003-0190 | G5 | Popup | 화면 FE(적용 예정) | G5 FAIL 수정 — Popup: 행 집계 — 대조표 Popup '**8**' 의 G5 132요소: NA:94 · PASS:22 · FAIL:12 · NOPATH:4 · FAIL 요소: C — 원장 V-2dda3c64 ASIS /  |  | 1 (Popup) |
| WK-DMF0003-0191 | G5 | btnColumn | 화면 FE(적용 예정) | G5 FAIL 수정 — btnColumn: 원장 V-9131aabd ASIS / 원장 V-db3c29e8 ASIS / 원장 V-9d72c711 ASIS / 원장 V-046f681e ASIS / 원장 V-cce72a64 ASIS / 원 |  | 0 () |
| WK-DMF0003-0192 | G5 | btnMeasure | 화면 FE(적용 예정) | G5 FAIL 수정 — btnMeasure: 원장 V-d69b319c ASIS / 원장 V-46313296 ASIS / 원장 V-23333d6b ASIS / 원장 V-477859ab ASIS / 원장 V-0b9540b9 ASIS /  |  | 0 () |
| WK-DMF0003-0193 | G5 | new DM0002_TitleSetForm_Popup("DMF0003", | 화면 FE(적용 예정) | G5 FAIL 수정 — new DM0002_TitleSetForm_Popup("DMF0003", SpdSheet.shtMain, f: 원장 V-d69b319c (FX-DMF0003-028) |  | 1 (ACT:DMF0003_1_MktFcst.btnMeasure_Click:4) |
| WK-DMF0003-0194 | G5 | new DM0002_TitleSetForm_Popup("DMF0003", | 화면 FE(적용 예정) | G5 FAIL 수정 — new DM0002_TitleSetForm_Popup("DMF0003", SpdSheet.shtMain, f: 원장 V-23333d6b (FX-DMF0003-030) |  | 1 (ACT:DMF0003_MktFcst.btnMeasure_Click:576) |
| WK-DMF0003-0195 | G5 | new DM0002_TitleSetForm_Popup("DMF0003", | 화면 FE(적용 예정) | G5 FAIL 수정 — new DM0002_TitleSetForm_Popup("DMF0003", SpdSheet.shtMain, f: 원장 V-0b9540b9 (FX-DMF0003-032) |  | 1 (ACT:DMF0003_T_MktFcst.btnMeasure_Click:4) |
| WK-DMF0003-0196 | G5 | new DM0002_TitleSetForm_Popup("DMF0003", | 화면 FE(적용 예정) | G5 FAIL 수정 — new DM0002_TitleSetForm_Popup("DMF0003", SpdSheet.shtMain, t: 원장 V-9131aabd (FX-DMF0003-027) |  | 1 (ACT:DMF0003_1_MktFcst.btnColumn_Click:49) |
| WK-DMF0003-0197 | G5 | new DM0002_TitleSetForm_Popup("DMF0003", | 화면 FE(적용 예정) | G5 FAIL 수정 — new DM0002_TitleSetForm_Popup("DMF0003", SpdSheet.shtMain, t: 원장 V-9d72c711 (FX-DMF0003-029) |  | 1 (ACT:DMF0003_MktFcst.btnColumn_Click:5752) |
| WK-DMF0003-0198 | G5 | new DM0002_TitleSetForm_Popup("DMF0003", | 화면 FE(적용 예정) | G5 FAIL 수정 — new DM0002_TitleSetForm_Popup("DMF0003", SpdSheet.shtMain, t: 원장 V-cce72a64 (FX-DMF0003-031) |  | 1 (ACT:DMF0003_T_MktFcst.btnColumn_Click:45) |

## W5 검사기 연결 (77)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0003-0199 | B1 | AS_FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL AS_FROM_SITE | 있음(SHEET_COLUMNS) | 2 (AS_FROM_SITE ACT:DMF0003_MktFcst.InsertR) |
| WK-DMF0003-0200 | B1 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL C | 있음(FE 소스) | 1 (C-118) |
| WK-DMF0003-0201 | B1 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL D | 있음(FE 소스) | 1 (AS_FROM_SITE) |
| WK-DMF0003-0202 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (AS_FROM_SITE) |
| WK-DMF0003-0203 | B1 | END_CUSTOMER / End Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL END_CUSTOMER / End Customer | 있음(SHEET_COLUMNS) | 1 (EndCustomerByDivisionDeptAuth) |
| WK-DMF0003-0204 | B1 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 3 (PlantByDivisionCompany PlantSiteByItem 7) |
| WK-DMF0003-0205 | B1 | S | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL S | 있음(FE 소스) | 2 (ACT:DMF0003_MktFcst.InsertRow:2597:36 AC) |
| WK-DMF0003-0206 | B1 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (SiteByEndCustomerAuth) |
| WK-DMF0003-0207 | B1 | SLOC | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 PCOL SLOC | 판단불가(대상 단위 PCOL) | 2 (ACT:DMF0003_PRPopup.SetChangeRequestInfo) |
| WK-DMF0003-0208 | B1 | STORAGE_PLANT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 PCOL STORAGE_PLANT_ID | 판단불가(대상 단위 PCOL) | 1 (ACT:DMF0003_PRPopup.spdMain_Changed:566:) |
| WK-DMF0003-0209 | B2 | AS_FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL AS_FROM_SITE | 있음(SHEET_COLUMNS) | 2 (AS_FROM_SITE ACT:DMF0003_MktFcst.InsertR) |
| WK-DMF0003-0210 | B2 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL C | 있음(FE 소스) | 1 (C-118) |
| WK-DMF0003-0211 | B2 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL D | 있음(FE 소스) | 1 (AS_FROM_SITE) |
| WK-DMF0003-0212 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (AS_FROM_SITE) |
| WK-DMF0003-0213 | B2 | END_CUSTOMER / End Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL END_CUSTOMER / End Customer | 있음(SHEET_COLUMNS) | 1 (EndCustomerByDivisionDeptAuth) |
| WK-DMF0003-0214 | B2 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 3 (PlantByDivisionCompany PlantSiteByItem 7) |
| WK-DMF0003-0215 | B2 | S | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL S | 있음(FE 소스) | 2 (ACT:DMF0003_MktFcst.InsertRow:2597:36 AC) |
| WK-DMF0003-0216 | B2 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (SiteByEndCustomerAuth) |
| WK-DMF0003-0217 | B2 | SLOC | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 PCOL SLOC | 판단불가(대상 단위 PCOL) | 2 (ACT:DMF0003_PRPopup.SetChangeRequestInfo) |
| WK-DMF0003-0218 | B2 | STORAGE_PLANT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 PCOL STORAGE_PLANT_ID | 판단불가(대상 단위 PCOL) | 1 (ACT:DMF0003_PRPopup.spdMain_Changed:566:) |
| WK-DMF0003-0219 | B3 | AS_FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL AS_FROM_SITE | 있음(SHEET_COLUMNS) | 8 (CD-03 ACT:DMF0003_MktFcst.InsertRow:2615) |
| WK-DMF0003-0220 | B3 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL D | 있음(FE 소스) | 1 (CD-03) |
| WK-DMF0003-0221 | B3 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (CD-03) |
| WK-DMF0003-0222 | B3 | FCST_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL FCST_TYPE | 있음(SHEET_COLUMNS) | 9 (ACT:DMF0003_1_MktFcst.GetFcstType ACT:DM) |
| WK-DMF0003-0223 | B3 | N | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL N | 있음(FE 소스) | 13 (6 ACT:DMF0003_1_MktFcst.GetSalesSite ACT) |
| WK-DMF0003-0224 | B3 | P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL P | 있음(FE 소스) | 3 (ACT:DMF0003_1_MktFcst.GetIncotermsType:6) |
| WK-DMF0003-0225 | B3 | S | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL S | 있음(FE 소스) | 6 (CD-08 6 ACT:DMF0003_MktFcst.GetSalesSite) |
| WK-DMF0003-0226 | B3 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (CD-08) |
| WK-DMF0003-0227 | B3 | cboAS / AS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND cboAS / AS | 있음(FE 소스) | 8 (ACT:DMF0003_1_MktFcst.GetSalesSite ACT:D) |
| WK-DMF0003-0228 | B3 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 10 (ACT:DMF0003_1_MktFcst.GetSpdTitle ACT:DM) |
| WK-DMF0003-0229 | B4 | AS_FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL AS_FROM_SITE | 있음(SHEET_COLUMNS) | 10 (CD-03 AS_FROM_SITE ACT:DMF0003_MktFcst.I) |
| WK-DMF0003-0230 | B4 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL C | 있음(FE 소스) | 1 (C-118) |
| WK-DMF0003-0231 | B4 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL D | 있음(FE 소스) | 2 (CD-03 AS_FROM_SITE) |
| WK-DMF0003-0232 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (CD-03 AS_FROM_SITE) |
| WK-DMF0003-0233 | B4 | END_CUSTOMER / End Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL END_CUSTOMER / End Customer | 있음(SHEET_COLUMNS) | 1 (EndCustomerByDivisionDeptAuth) |
| WK-DMF0003-0234 | B4 | FCST_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FCST_TYPE | 있음(SHEET_COLUMNS) | 9 (ACT:DMF0003_1_MktFcst.GetFcstType ACT:DM) |
| WK-DMF0003-0235 | B4 | N | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL N | 있음(FE 소스) | 13 (6 ACT:DMF0003_1_MktFcst.GetSalesSite ACT) |
| WK-DMF0003-0236 | B4 | P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL P | 있음(FE 소스) | 3 (ACT:DMF0003_1_MktFcst.GetIncotermsType:6) |
| WK-DMF0003-0237 | B4 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 3 (PlantByDivisionCompany PlantSiteByItem 7) |
| WK-DMF0003-0238 | B4 | S | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL S | 있음(FE 소스) | 8 (CD-08 6 ACT:DMF0003_MktFcst.GetSalesSite) |
| WK-DMF0003-0239 | B4 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 2 (CD-08 SiteByEndCustomerAuth) |
| WK-DMF0003-0240 | B4 | SLOC | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL SLOC | 판단불가(대상 단위 PCOL) | 2 (ACT:DMF0003_PRPopup.SetChangeRequestInfo) |
| WK-DMF0003-0241 | B4 | STORAGE_PLANT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL STORAGE_PLANT_ID | 판단불가(대상 단위 PCOL) | 1 (ACT:DMF0003_PRPopup.spdMain_Changed:566:) |
| WK-DMF0003-0242 | B4 | cboAS / AS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboAS / AS | 있음(FE 소스) | 8 (ACT:DMF0003_1_MktFcst.GetSalesSite ACT:D) |
| WK-DMF0003-0243 | B4 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 10 (ACT:DMF0003_1_MktFcst.GetSpdTitle ACT:DM) |
| WK-DMF0003-0244 | DB-SYN | DMF0000_GET_MASTER_CHG_POPUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0000_GET_MASTER_CHG_POPUP | 없음(PROC_M 대응 없음) | 5 (CH-108 ACT:DMF0003_MatsterChgPopup.FindD) |
| WK-DMF0003-0245 | DB-SYN | DMF0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 7 (CK-04 ACT:DMF0003_1_MktFcst.GetBucketTyp) |
| WK-DMF0003-0246 | DB-SYN | DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0003_MatsterChgPopup.SaveData:529) |
| WK-DMF0003-0247 | DB-SYN | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | 없음(PROC_M 대응 없음) | 7 (CK-08 ACT:DMF0003_1_MktFcst.GetBizTypeby) |
| WK-DMF0003-0248 | DB-SYN | SCM0001_GET_CUSTOMER_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_CUSTOMER_BY_DIVISION | 없음(PROC_M 대응 없음) | 6 (ACT:DMF0003_1_MktFcst.GetCustomerbyDivis) |
| WK-DMF0003-0249 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 15 (CK-07 ACT:DMF0003_1_MktFcst.GetItemType:) |
| WK-DMF0003-0250 | DB-SYN | SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 없음(PROC_M 대응 없음) | 6 (ACT:DMF0003_1_MktFcst.GetPlantSitebyEndC) |
| WK-DMF0003-0251 | DB-SYN | SCM0001_GET_SITE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SITE_BY_DIVISION | 없음(PROC_M 대응 없음) | 6 (ACT:DMF0003_1_MktFcst.GetScmSitebyDivisi) |
| WK-DMF0003-0252 | DB-SYN | SCM0001_GET_TEAM_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_TEAM_BY_DIVISION | 없음(PROC_M 대응 없음) | 6 (ACT:DMF0003_1_MktFcst.GetTeambyDivision:) |
| WK-DMF0003-0253 | G4 | btnCalculation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnCalculation | 없음 | 6 (ACT:DMF0003_1_MktFcst.InitControls:473:6) |
| WK-DMF0003-0254 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 없음 | 4 (ACT:DMF0003_1_MktFcst.InitControls:465:5) |
| WK-DMF0003-0255 | G4 | btnIncotermsChg | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnIncotermsChg | 있음(FE 소스) | 24 (ACT:DMF0003_1_MktFcst.DefineProperty ACT) |
| WK-DMF0003-0256 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 1 (HANDLER:btnItemId_Click) |
| WK-DMF0003-0257 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 없음 | 4 (ACT:DMF0003_1_MktFcst.InitControls:466:5) |
| WK-DMF0003-0258 | G4 | btnOwner | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnOwner | 없음 | 1 (HANDLER:btnOwner_Click) |
| WK-DMF0003-0259 | G4 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnProject | 없음 | 10 (HANDLER:btnProject_Click ACT:DMF0003_1_M) |
| WK-DMF0003-0260 | G4 | btnUpDown | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnUpDown | 없음 | 5 (ACT:DMF0003_1_MktFcst.InitSpread ACT:DMF) |
| WK-DMF0003-0261 | E2 | YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL YYYYMMDD | 있음(SHEET_COLUMNS) | 1 (111) |
| WK-DMF0003-0262 | E5 | AS_FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL AS_FROM_SITE | 있음(SHEET_COLUMNS) | 1 (AS_FROM_SITE) |
| WK-DMF0003-0263 | E5 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL C | 있음(FE 소스) | 1 (C-118) |
| WK-DMF0003-0264 | E5 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL D | 있음(FE 소스) | 1 (AS_FROM_SITE) |
| WK-DMF0003-0265 | E5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (AS_FROM_SITE) |
| WK-DMF0003-0266 | E5 | END_CUSTOMER / End Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL END_CUSTOMER / End Customer | 있음(SHEET_COLUMNS) | 1 (EndCustomerByDivisionDeptAuth) |
| WK-DMF0003-0267 | E5 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 3 (PlantByDivisionCompany PlantSiteByItem 7) |
| WK-DMF0003-0268 | E5 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (SiteByEndCustomerAuth) |
| WK-DMF0003-0269 | G03-WIRE | DMF0003 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0003 화면 | 판단불가(대상 단위 SCREEN) | 56 (ACT:DMF0003_1_MktFcst..ctor ACT:DMF0003_) |
| WK-DMF0003-0270 | G5 | DMF0003_SspSyncComparePopUp | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 POPUP DMF0003_SspSyncComparePopUp | 판단불가(대상 단위 POPUP) | 6 (CA-114 MODAL:DMF0003_SspSyncComparePopUp) |
| WK-DMF0003-0271 | G5 | DMF0003_SspSyncPopUp | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 POPUP DMF0003_SspSyncPopUp | 판단불가(대상 단위 POPUP) | 6 (MODAL:DMF0003_SspSyncPopUp MODAL:SspSync) |
| WK-DMF0003-0272 | G5 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 6 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0273 | G5 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbDivision / Division | 있음(FE 소스) | 16 (ACT:DMF0003_1_MktFcst.btnColumn_Click:49) |
| WK-DMF0003-0274 | H6 | DMF0003_SspSyncComparePopUp | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP DMF0003_SspSyncComparePopUp | 판단불가(대상 단위 POPUP) | 6 (CA-114 MODAL:DMF0003_SspSyncComparePopUp) |
| WK-DMF0003-0275 | H6 | DMF0003_SspSyncPopUp | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP DMF0003_SspSyncPopUp | 판단불가(대상 단위 POPUP) | 6 (MODAL:DMF0003_SspSyncPopUp MODAL:SspSync) |

## W6 검증 실행 (25)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0003-0276 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 15 (ACT:DMF0003_1_MktFcst.DefineProperty ACT) |
| WK-DMF0003-0277 | G4 | cboCellQty / Cell Qty | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboCellQty / Cell Qty · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 12 (ACT:DMF0003_1_MktFcst.InitControls ACT:D) |
| WK-DMF0003-0278 | G4 | chkColor / Color | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkColor / Color · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0003_1_MktFcst.InitControls ACT:D) |
| WK-DMF0003-0279 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0003_1_MktFcst.InitControls ACT:D) |
| WK-DMF0003-0280 | G4 | clbBizType / Biz Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbBizType / Biz Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 11 (ACT:DMF0003_1_MktFcst.InitControls ACT:D) |
| WK-DMF0003-0281 | G4 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 11 (ACT:DMF0003_1_MktFcst.InitControls ACT:D) |
| WK-DMF0003-0282 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 61 (ACT:DMF0003_1_MktFcst.DefineProperty ACT) |
| WK-DMF0003-0283 | G4 | clbEDISender / Sender Code / EDISender | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbEDISender / Sender Code / EDISender · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (ACT:DMF0003_1_MktFcst.InitControls ACT:D) |
| WK-DMF0003-0284 | G4 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:DMF0003_MatsterChgPopup.InitControls) |
| WK-DMF0003-0285 | G4 | clbItemType / Item Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbItemType / Item Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:DMF0003_1_MktFcst.InitControls:462:5) |
| WK-DMF0003-0286 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0003_1_MktFcst.InitControls ACT:D) |
| WK-DMF0003-0287 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 10 (ACT:DMF0003_1_MktFcst.InitControls ACT:D) |
| WK-DMF0003-0288 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 18 (ACT:DMF0003_1_MktFcst.InitControls ACT:D) |
| WK-DMF0003-0289 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0003_1_MktFcst.FindData:1482:16 A) |
| WK-DMF0003-0290 | G4 | drpPeriod1 / ▼ PERIOD: / Period1 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod1 / ▼ PERIOD: / Period1 · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0003_1_MktFcst.InitControls ACT:D) |
| WK-DMF0003-0291 | G4 | drpPeriodPSI / PERIOD / Period PSI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriodPSI / PERIOD / Period PSI · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0003_1_MktFcst.InitControls ACT:D) |
| WK-DMF0003-0292 | G4 | drpPeriodSimulation / SIMULATION / Perio | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriodSimulation / SIMULATION / Period Simulati · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0003_1_MktFcst.InitControls:456:5) |
| WK-DMF0003-0293 | G4 | txtMarketShare / ▼ 당사 M/S(%): / Market S | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtMarketShare / ▼ 당사 M/S(%): / Market Share · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0003_1_MktFcst.txtMarketShare_Cli) |
| WK-DMF0003-0294 | G4 | txtPrHeader / PR Header / Pr Header | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtPrHeader / PR Header / Pr Header · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0003_PRPopup.EditButton:293:16 AC) |
| WK-DMF0003-0295 | G4 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0003_MatsterChgPopup.InitControls) |
| WK-DMF0003-0296 | G4 | txtRequestNo / Request No | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtRequestNo / Request No · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (ACT:DMF0003_PRPopup.SetChangeRequestInfo) |
| WK-DMF0003-0297 | SC1 | DMF0003 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — DMF0003 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 8 (E01-1 CD-10 CK-10 COMMON:UC-06 `componen) |
| WK-DMF0003-0298 | H6 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 6 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0299 | H6 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 16 (ACT:DMF0003_1_MktFcst.btnColumn_Click:49) |
| WK-DMF0003-0300 | H6 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — drpPeriod / Period · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 5 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |

## W7 기대값 확정 (184)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0003-0301 | X-REASON | C-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — C-101 §0.1 [원문 무번호] 계통 / 방식 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (C-101) |
| WK-DMF0003-0302 | X-REASON | C-108 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — C-108 §0.2 [원문 무번호] 이벤트 / 81/82 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (C-108) |
| WK-DMF0003-0303 | X-REASON | CA-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-06 §1 필수 컬럼 부재 — 81*: 9종(+PlantSiteId) / 82: 8종 / 40: 8종(40 계열 키) / MSG00113 차단  AS-IS 는 컬럼셋팅으로 필수 컬럼 제거 가능한 |  | 1 (CA-06) |
| WK-DMF0003-0304 | X-REASON | CA-102 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-102 §1 [원문 무번호] DMF0003_1 / (별도 소스) 해당없음 범위 제외 — `DMF0003_1`/`DMF0003_T` 는 별도 메뉴(사용자 확정 2026-08-15). 본 대사표 대 |  | 1 (CA-102) |
| WK-DMF0003-0305 | X-REASON | CA-103 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-103 §1 [원문 무번호] DMF0003_T / (별도 소스) 해당없음 범위 제외 — `DMF0003_1`/`DMF0003_T` 는 별도 메뉴(사용자 확정 2026-08-15). 본 대사표 대 |  | 1 (CA-103) |
| WK-DMF0003-0306 | X-REASON | CA-104 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-104 §1 [원문 무번호] 화면 ID / DMF0003 (MktFcst / 시장예측) 해당없음 문서 머리말(화면 메타정보) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CA-104) |
| WK-DMF0003-0307 | X-REASON | CA-105 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-105 §1 [원문 무번호] 도메인 / Demand (수요) 해당없음 문서 머리말(화면 메타정보) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CA-105) |
| WK-DMF0003-0308 | X-REASON | CA-106 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-106 §1 [원문 무번호] 메뉴 / Demand > Demand Plan > MKT FCST 해당없음 문서 머리말(화면 메타정보) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없 |  | 1 (CA-106) |
| WK-DMF0003-0309 | X-REASON | CA-107 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-107 §1 [원문 무번호] TO-BE FE / `nscm-fe/features/demand/src/pages/mkt-fcst/` 해당없음 문서 머리말(화면 메타정보) — 요구사항 행이 아님.  |  | 1 (CA-107) |
| WK-DMF0003-0310 | X-REASON | CA-109 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-109 §1 [원문 무번호] 편집 가능 / **Division 82 만** (회의 확정 2026-07-07, 실 데이터 확인) 해당없음 문서 머리말(화면 메타정보) — 요구사항 행이 아님. `- |  | 1 (CA-109) |
| WK-DMF0003-0311 | X-REASON | CA-110 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-110 §1 [원문 무번호] POPUP / AS-IS Class 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CA-110) |
| WK-DMF0003-0312 | X-REASON | CA-112 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-112 §1 [원문 무번호] PR History / `DMF0003_PRHistoryPopup` 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없 |  | 1 (CA-112) |
| WK-DMF0003-0313 | X-REASON | CA-113 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-113 §1 [원문 무번호] SSP Sync / `DMF0003_SspSyncPopUp` 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CA-113) |
| WK-DMF0003-0314 | X-REASON | CC-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CC-101 §3.1 [원문 무번호] 컨트롤 / 담긴 LAYER (Control 바인딩) 해당없음 — 표 헤더 원천 `DMF0003_MktFcst_상세분석서_v2.0.md` L69 = 표 헤더 행(컨 |  | 1 (CC-101) |
| WK-DMF0003-0315 | X-REASON | CE-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CE-101 §5.1 [원문 무번호] 논리 컬럼 / 40 전용 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CE-101) |
| WK-DMF0003-0316 | X-REASON | CE-102 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CE-102 §5.1 [원문 무번호] Div* / `DIVISION_ID40` 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CE-102) |
| WK-DMF0003-0317 | X-REASON | CE-104 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CE-104 §5.1 [원문 무번호] Sales Site* / `SCM_SITE_ID40` 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CE-104) |
| WK-DMF0003-0318 | X-REASON | CE-105 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CE-105 §5.1 [원문 무번호] Model* / `ITEM_ID40` 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CE-105) |
| WK-DMF0003-0319 | X-REASON | CE-106 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CE-106 §5.1 [원문 무번호] Plant Site* / — 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CE-106) |
| WK-DMF0003-0320 | X-REASON | CE-107 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CE-107 §5.1 [원문 무번호] Energy/Cell / — 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CE-107) |
| WK-DMF0003-0321 | X-REASON | CE-122 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CE-122 §5.4 [원문 무번호] 콤보 SQL_ID / 바인드 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CE-122) |
| WK-DMF0003-0322 | X-REASON | CE-123 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CE-123 §5.4 [원문 무번호] `MktFcstEditMeasure` / @divisionId 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CE-123) |
| WK-DMF0003-0323 | X-REASON | CE-124 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CE-124 §5.4 [원문 무번호] `MktFcstEditableDivision` / 없음 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CE-124) |
| WK-DMF0003-0324 | X-REASON | CE-125 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CE-125 §5.4 [원문 무번호] `MktFcstUserEditDivision` / @sesUserId 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물  |  | 1 (CE-125) |
| WK-DMF0003-0325 | X-REASON | CE-126 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CE-126 §5.4 [원문 무번호] `MktFcstWsPlannerYn` / @sesUserId 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CE-126) |
| WK-DMF0003-0326 | X-REASON | CE-127 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CE-127 §5.4 [원문 무번호] `BizType` / 없음 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CE-127) |
| WK-DMF0003-0327 | X-REASON | CF-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CF-03 §6 dtSave 행 중 그리드 실재+AS_FROM_SITE 일치(bAsCompare)만 dtSaveFinal 승계 / I 저장이 기존 행 키와 같으면 제외 /…  dtSave→dtSave |  | 1 (CF-03) |
| WK-DMF0003-0328 | X-REASON | CF-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CF-101 §6.2 [원문 무번호] 트리거 / MSG_ID 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CF-101) |
| WK-DMF0003-0329 | X-REASON | CG-102 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CG-102 §7.1 [원문 무번호] Plant Site 필수 / ✗ 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CG-102) |
| WK-DMF0003-0330 | X-REASON | CG-103 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CG-103 §7.1 [원문 무번호] 중복키 Plant 포함 / ✗ 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CG-103) |
| WK-DMF0003-0331 | X-REASON | CG-105 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CG-105 §7.1 [원문 무번호] Project 필드 / **비활성** 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CG-105) |
| WK-DMF0003-0332 | X-REASON | CG-107 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CG-107 §7.1 [원문 무번호] Cell Qty / **40만** 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CG-107) |
| WK-DMF0003-0333 | X-REASON | CG-108 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CG-108 §7.1 [원문 무번호] checkInvalidExec / ✗ 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CG-108) |
| WK-DMF0003-0334 | X-REASON | CG-109 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CG-109 §7.1 [원문 무번호] Energy/Cell 컬럼 / ✗ 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CG-109) |
| WK-DMF0003-0335 | X-REASON | CG-111 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CG-111 §7.1 [원문 무번호] Bucket 기본 / Weekly 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CG-111) |
| WK-DMF0003-0336 | X-REASON | CG-112 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CG-112 §7.1 [원문 무번호] **편집 가능** / ✗ 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CG-112) |
| WK-DMF0003-0337 | X-REASON | CG-114 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CG-114 §7.3 [원문 무번호] 상위(선택) / 조건 해당없음 — 표 헤더 원천 `상세분석서_v2.0.md` L228 = §7.3 표 헤더 행(상위(선택) · 조건 · 하위(종속) · 유형 ·  |  | 1 (CG-114) |
| WK-DMF0003-0338 | X-REASON | CG-115 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CG-115 §7.3 [원문 무번호] CUST_FCST / 전 division 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CG-115) |
| WK-DMF0003-0339 | X-REASON | CG-117 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CG-117 §7.3 [원문 무번호] **MKT_FCST_RP** / **Division 82 한정** 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당 |  | 1 (CG-117) |
| WK-DMF0003-0340 | X-REASON | CG-120 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CG-120 §7.3 [원문 무번호] TMM_FCST / 81 계열, TMM_MEASURE_ADMIN 등록자 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 |  | 1 (CG-120) |
| WK-DMF0003-0341 | X-REASON | CG-121 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CG-121 §7.3 [원문 무번호] CUST_FCST_ORG / (비활성, E20241126 합의) 해당없음 — AS-IS 비활성 원천 `상세분석서_v2.0.md` L236 = CUST_FCST_O |  | 1 (CG-121) |
| WK-DMF0003-0342 | X-REASON | CH-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CH-101 §8 [원문 무번호] POPUP / SP 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 해당없음 |  | 1 (CH-101) |
| WK-DMF0003-0343 | X-REASON | CH-104 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CH-104 §8 [원문 무번호] SSP Sync / (SP 없음) 제외 — SSP Sync 범위 제외 — SSP Sync 는 구현 대상에서 제외(사용자 확정 2026-08-15). 표시/색상 축(E |  | 1 (CH-104) |
| WK-DMF0003-0344 | X-REASON | CH-107 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CH-107 §8 [원문 무번호] Project/Item/Owner byDivision / 콤보/팝업 SP 해당없음 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물  |  | 1 (CH-107) |
| WK-DMF0003-0345 | X-REASON | E00 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E00 §0 정본 vs 구본 차이 — git diff --no-index 실측  정본 선택 근거(폴더본 7,143줄 — diff = DMF0003_정본전환_diff_20260812.md). 구현 산출 |  | 1 (E00) |
| WK-DMF0003-0346 | X-REASON | E01-4 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E01-4 §1.4 InitSaveDataTable (L758~800)  WinForms 로컬 DataTable(dtSave/dtSaveFinal) 구조 — TO-BE 는 EditTracker+uti |  | 1 (E01-4) |
| WK-DMF0003-0347 | X-REASON | HANDLER:FindButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:FindButton AS-IS `DMF0003_MktFcst.cs:805` (라이브 3행) · **사문(빈 몸통)**  사문 래퍼(3행 — FindData 위임). TO-BE handl |  | 1 (HANDLER:FindButton) |
| WK-DMF0003-0348 | X-REASON | HANDLER:InsertButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:InsertButton AS-IS `DMF0003_MktFcst.cs:811` (라이브 3행) · **사문(빈 몸통)**  사문 래퍼(3행 — InsertRow 위임) 제외 |  | 1 (HANDLER:InsertButton) |
| WK-DMF0003-0349 | X-REASON | HANDLER:SaveButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:SaveButton AS-IS `DMF0003_MktFcst.cs:1340` (라이브 3행) · **사문(빈 몸통)**  사문 래퍼(3행 — SaveData 위임) 제외 |  | 1 (HANDLER:SaveButton) |
| WK-DMF0003-0350 | X-REASON | HANDLER:spdMain_TopChange | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:spdMain_TopChange AS-IS `DMF0003_MktFcst.cs:5621` (라이브 5행)  FarPoint SmartColMerge 재적용 전용 — Wijmo wrapp |  | 1 (HANDLER:spdMain_TopChange) |
| WK-DMF0003-0351 | X-REASON | MODAL:ImagePopUp | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:ImagePopUp AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 해당없음 — 모달 아님 AS-IS `DMF0003_MktFcst.cs` L555/L558 `siM |  | 1 (MODAL:ImagePopUp) |
| WK-DMF0003-0352 | X-REASON | MODAL:ShowDialog | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:ShowDialog AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 해당없음 — 메서드명 AS-IS 15회 전부 `popup.ShowDialog()` 형태 = Win |  | 1 (MODAL:ShowDialog) |
| WK-DMF0003-0353 | E3 | D | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — D: 검증 엔진이 실행됐으나 이 대상(COL D)을 판정하지 못함 — 필수 입력 검증 시나리오 수동 확인 또는 엔진 확장 |  | 1 (E04-1) |
| WK-DMF0003-0354 | E3 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — I: 검증 엔진이 실행됐으나 이 대상(COL I)을 판정하지 못함 — 필수 입력 검증 시나리오 수동 확인 또는 엔진 확장 |  | 3 (CF-01 CF-02 CG-02) |
| WK-DMF0003-0355 | E3 | L | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — L: 검증 엔진이 실행됐으나 이 대상(COL L)을 판정하지 못함 — 필수 입력 검증 시나리오 수동 확인 또는 엔진 확장 |  | 1 (17) |
| WK-DMF0003-0356 | E3 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — M: 검증 엔진이 실행됐으나 이 대상(COL M)을 판정하지 못함 — 필수 입력 검증 시나리오 수동 확인 또는 엔진 확장 |  | 1 (E04-1) |
| WK-DMF0003-0357 | A1 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 15: 행 집계 — 대조표 15 'ValidationCheck' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX — 골든 비교 케이스 없음(UP_FX — 팝업·보조 SP 는 g |  | 0 () |
| WK-DMF0003-0358 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — 대조표 2 "InitSpread(sType) 5곳 — CreateSpread·Division변경='LO" 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX —  |  | 1 (2) |
| WK-DMF0003-0359 | A1 | 34 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 34: 행 집계 — 대조표 34 'FindData data_start_pos<0' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX — 골든 비교 케이스 없음(UP_FX — 팝업 |  | 1 (34) |
| WK-DMF0003-0360 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — 대조표 6 '공통 콤보 PARAM5 W/S 플래그 — GetSalesSite40(L7047~7066) ' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX —  |  | 0 () |
| WK-DMF0003-0361 | A1 | 6. HTTP E2E | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6. HTTP E2E: 행 집계 — 대조표 6. HTTP E2E '일반 행 M 왕복 생략' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX — 골든 비교 케이스 없음(UP_FX |  | 1 (6. HTTP E2E) |
| WK-DMF0003-0362 | A1 | AS_FROM_SITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — AS_FROM_SITE: 행 집계 — 대조표 AS_FROM_SITE 'param1' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX — 골든 비교 케이스 없음(UP_FX — 팝 |  | 1 (AS_FROM_SITE) |
| WK-DMF0003-0363 | A1 | CA-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CA-07: 행 집계 — 대조표 CA-07 '§1 dt8Week 없음(조회 선행 안 함) / MSG00259 차단' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX — 골든 비 |  | 1 (CA-07) |
| WK-DMF0003-0364 | A1 | CD-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CD-03: 행 집계 — 대조표 CD-03 '§4 AS_FROM_SITE / `AS_FROM_SITE`(division)' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX —  |  | 1 (CD-03) |
| WK-DMF0003-0365 | A1 | CE-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CE-05: 행 집계 — 대조표 CE-05 '§5 조회 컬럼 강제 / [E20260402] W/S 권한 진입 시 GET_SPREAD_T' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소:  |  | 1 (CE-05) |
| WK-DMF0003-0366 | A1 | CF-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-05: 행 집계 — 대조표 CF-05 '§6 저장 성공(Tables 없음) / MSG00004(건수) + 재조회 + viewpor' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소:  |  | 1 (CF-05) |
| WK-DMF0003-0367 | A1 | CF-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-102: 행 집계 — 대조표 CF-102 '§6.2 [원문 무번호] 조회 / MSG00097' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX — 골든 비교 케이스 없음( |  | 1 (CF-102) |
| WK-DMF0003-0368 | A1 | CF-103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-103: 행 집계 — 대조표 CF-103 '§6.2 [원문 무번호] 조회 / MSG00108' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX — 골든 비교 케이스 없음( |  | 1 (CF-103) |
| WK-DMF0003-0369 | A1 | CF-104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-104: 행 집계 — 대조표 CF-104 '§6.2 [원문 무번호] 조회 / MSG00164' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX — 골든 비교 케이스 없음( |  | 1 (CF-104) |
| WK-DMF0003-0370 | A1 | CF-105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-105: 행 집계 — 대조표 CF-105 '§6.2 [원문 무번호] 조회 / MSG00665' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX — 골든 비교 케이스 없음( |  | 1 (CF-105) |
| WK-DMF0003-0371 | A1 | CG-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CG-07: 행 집계 — 대조표 CG-07 "§7 버킷 배분 / 주→일: 요일비트(기본 '0000010'=FRI) 균등+잔여 마지막, " 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소:  |  | 1 (CG-07) |
| WK-DMF0003-0372 | A1 | CH-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CH-09: 행 집계 — 대조표 CH-09 '§8 캐스케이드 / Division→Team→EndCustomer→SalesSite(+Pl' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소:  |  | 1 (CH-09) |
| WK-DMF0003-0373 | A1 | CI-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CI-02: 행 집계 — 대조표 CI-02 '§9 당주 라인 / 초록 BevelBorder — count≥2 시 [E20250313] ' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소:  |  | 1 (CI-02) |
| WK-DMF0003-0374 | A1 | CI-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CI-07: 행 집계 — 대조표 CI-07 '§9 저장 후 / Action 클리어 + UnLockColor + 행 재잠금(빨강 계열)' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: U |  | 1 (CI-07) |
| WK-DMF0003-0375 | A1 | CK-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CK-06: 행 집계 — 대조표 CK-06 '§11 DM.PR_GET_DAY_RANGE / 기간 기본값' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX — 골든 비교 케이스  |  | 1 (CK-06) |
| WK-DMF0003-0376 | A1 | CK-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CK-10: 행 집계 — 대조표 CK-10 '§11 DataService.GetDMInnerTable / 조회조건 콤보 8축(§1.1-' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소:  |  | 1 (CK-10) |
| WK-DMF0003-0377 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A1 18요소: REVIEW:17 · PASS |  | 1 (COMMON:UC-02) |
| WK-DMF0003-0378 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 A1 18요소: REVIEW:17 · PASS |  | 1 (COMMON:UC-03) |
| WK-DMF0003-0379 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 A1 18요소: REVIEW:17 · PASS:1 · FAI |  | 1 (COMMON:UC-06) |
| WK-DMF0003-0380 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 18요소: REVIEW:17 · PASS |  | 1 (COMMON:UC-07) |
| WK-DMF0003-0381 | A1 | CRUD:E02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E02:SEARCH: 행 집계 — 대조표 CRUD:E02:SEARCH '[SEARCH] §2 FindData — 조회 (FindButton L805 → FindD' 의 A1 18요소: REVIEW:17  |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0003-0382 | A1 | DMF0000_GET_MASTER_CHG_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0000_GET_MASTER_CHG_POPUP: 골든 비교 케이스 없음(DMF0000_GET_MASTER_CHG_POPUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케 |  | 49 (CH-108 ACT:DMF0003_MatsterChgPopup.FindB) |
| WK-DMF0003-0383 | A1 | DMF0003_CustDemandAnalysis.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0003_CustDemandAnalysis.FindDataMain: 진입점 집계 — 대조표 DMF0003_CustDemandAnalysis.FindDataMain 의 A1 18요소: REVIEW:17 · P |  | 1 (ACT:DMF0003_CustDemandAnalysis.FindDataM) |
| WK-DMF0003-0384 | A1 | DMF0003_MktFcst.Draw | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0003_MktFcst.Draw: 진입점 집계 — 대조표 DMF0003_MktFcst.Draw 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX — 골든 비교 케이스 없음( |  | 1 (ACT:DMF0003_MktFcst.Draw:1961:8) |
| WK-DMF0003-0385 | A1 | DMF0003_SspSyncComparePopUp.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0003_SspSyncComparePopUp.FindData: 진입점 집계 — 대조표 DMF0003_SspSyncComparePopUp.FindData 의 A1 18요소: REVIEW:17 · PASS:1  |  | 1 (ACT:DMF0003_SspSyncComparePopUp.FindData) |
| WK-DMF0003-0386 | A1 | DMF0003_SspSyncPopUp.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0003_SspSyncPopUp.FindData: 진입점 집계 — 대조표 DMF0003_SspSyncPopUp.FindData 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_ |  | 1 (ACT:DMF0003_SspSyncPopUp.FindData) |
| WK-DMF0003-0387 | A1 | E01-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01-1: 행 집계 — 대조표 E01-1 '§1.1 InitControls (L422~563) — 조회조건 콤보 로딩·기본값' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX |  | 1 (E01-1) |
| WK-DMF0003-0388 | A1 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E02: 행 집계 — 대조표 E02 '§2 FindData — 조회 (FindButton L805 → FindData L1673' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_F |  | 1 (E02) |
| WK-DMF0003-0389 | A1 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindData: 행 집계 — 대조표 HANDLER:FindData 'AS-IS `DMF0003_MktFcst.cs:1673` (라이브 80행)' 의 A1 18요소: REVIEW:17 · PASS: |  | 1 (HANDLER:FindData) |
| WK-DMF0003-0390 | A1 | HANDLER:OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:OnShown: 행 집계 — 대조표 HANDLER:OnShown 'AS-IS `DMF0003_MktFcst.cs:332` (라이브 12행)' 의 A1 18요소: REVIEW:17 · PASS:1 · |  | 1 (HANDLER:OnShown) |
| WK-DMF0003-0391 | A1 | HANDLER:btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:btnItemId_Click: 행 집계 — 대조표 HANDLER:btnItemId_Click 'AS-IS `DMF0003_MktFcst.cs:5725` (라이브 17행)' 의 A1 18요소: REV |  | 1 (HANDLER:btnItemId_Click) |
| WK-DMF0003-0392 | A1 | HANDLER:btnOwner_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:btnOwner_Click: 행 집계 — 대조표 HANDLER:btnOwner_Click 'AS-IS `DMF0003_MktFcst.cs:6449` (라이브 14행)' 의 A1 18요소: REVIE |  | 1 (HANDLER:btnOwner_Click) |
| WK-DMF0003-0393 | A1 | HANDLER:btnProject_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:btnProject_Click: 행 집계 — 대조표 HANDLER:btnProject_Click 'AS-IS `DMF0003_MktFcst.cs:5702` (라이브 17행)' 의 A1 18요소: R |  | 1 (HANDLER:btnProject_Click) |
| WK-DMF0003-0394 | A1 | HANDLER:spdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:spdMain_CellClick: 행 집계 — 대조표 HANDLER:spdMain_CellClick 'AS-IS `DMF0003_MktFcst.cs:6596` (라이브 74행)' 의 A1 18요소: |  | 1 (HANDLER:spdMain_CellClick) |
| WK-DMF0003-0395 | A1 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE — 팝업·보조 SP 는 |  | 46 (ACT:DMF0003_MatsterChgPopup.FindButton A) |
| WK-DMF0003-0396 | A1 | PKG_DMF0003.P_DMF0003_GET_DM_ANL_CAR_REF | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_DM_ANL_CAR_REF: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0003/DMF0003_GET_DM_ANL_CAR |  | 1 (ACT:DMF0003_1_MktFcst.CAR_REF_DATA:6602:) |
| WK-DMF0003-0397 | A1 | PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0003/DMF0003_GET_D |  | 1 (ACT:DMF0003_1_MktFcst.PSI_FindData:6968:) |
| WK-DMF0003-0398 | A1 | PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DATA: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0003/DMF0003_GET_DM_AN |  | 3 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0399 | A1 | PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT: 골든 비교 케이스 없음(PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT — 팝업·보조  |  | 1 (ACT:DMF0003_CustDemandAnalysis.Select_Dp) |
| WK-DMF0003-0400 | A1 | PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT: 골든 비교 케이스 없음(PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT — 팝업 |  | 1 (ACT:DMF0003_CustDemandAnalysis.Select_Dp) |
| WK-DMF0003-0401 | A1 | PKG_DMF0003.P_DMF0003_GET_MKT_FCST_COMPA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_MKT_FCST_COMPARE_POPUP: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0003/DMF0003_GET_MK |  | 3 (CH-105 CK-05 ACT:DMF0003_1_MktFcst.spdMa) |
| WK-DMF0003-0402 | A1 | PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0003/DMF0003_GET_MKT_FCST_DA |  | 297 (CK-01 ACT:DMF0003_1_MktFcst.FindButton A) |
| WK-DMF0003-0403 | A1 | PKG_DMF0003.P_DMF0003_GET_PRPOPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_PRPOPUP: 골든 비교 케이스 없음(PKG_DMF0003.P_DMF0003_GET_PRPOPUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실 |  | 42 (CH-102 CK-11 ACT:DMF0003_PRPopup.FindDat) |
| WK-DMF0003-0404 | A1 | PKG_DMF0003.P_DMF0003_GET_PR_HISTORY_POP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_PR_HISTORY_POPUP: 골든 비교 케이스 없음(PKG_DMF0003.P_DMF0003_GET_PR_HISTORY_POPUP — 팝업·보조 SP 는 golde |  | 35 (CH-103 ACT:DMF0003_PRHistoryPopup.FindDa) |
| WK-DMF0003-0405 | A1 | PKG_DMF0003.P_DMF0003_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_SPREAD_TITLE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0003/DMF0003_GET_SPREAD_TITLE |  | 288 (CK-03 ACT:DMF0003_1_MktFcst.FindButton A) |
| WK-DMF0003-0406 | A1 | PKG_DMF0003.P_DMF0003_GET_SPREAD_TITLE_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_SPREAD_TITLE_CAR: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0003/DMF0003_GET_SPREAD_T |  | 107 (ACT:DMF0003_1_MktFcst.FindButton ACT:DMF) |
| WK-DMF0003-0407 | A1 | PKG_DMF0003.P_DMF0003_GET_SPREAD_TITLE_P | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_SPREAD_TITLE_PSI: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0003/DMF0003_GET_SPREAD_T |  | 107 (ACT:DMF0003_1_MktFcst.FindButton ACT:DMF) |
| WK-DMF0003-0408 | A1 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_BIZ_TYPE_BY_DIVISION: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0003/SCM0001_GET_BIZ_TYPE_BY_DIVISI |  | 1 (CK-08) |
| WK-DMF0003-0409 | A1 | SCM0001_GET_LOOKUP_VALUES | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_LOOKUP_VALUES: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0003/SCM0001_GET_LOOKUP_VALUES.md — 파라미터 미 |  | 1 (CK-07) |
| WK-DMF0003-0410 | A1 | UP_FX | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — UP_FX: 골든 비교 케이스 없음(UP_FX — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (CD-10) |
| WK-DMF0003-0411 | A1 | `components/MktFcstForm.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `components/MktFcstForm.tsx`: 행 집계 — 대조표 `components/MktFcstForm.tsx` '수정' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP |  | 1 (`components/MktFcstForm.tsx`) |
| WK-DMF0003-0412 | A1 | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — —: 행 집계 — 대조표 — '(저장대상 0)' 의 A1 18요소: REVIEW:17 · PASS:1 · FAIL 요소: UP_FX — 골든 비교 케이스 없음(UP_FX — 팝업·보조 SP 는 golden_cas |  | 0 () |
| WK-DMF0003-0413 | A6 | DMF0000_GET_MASTER_CHG_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — DMF0000_GET_MASTER_CHG_POPUP: 원장 V-8ebef86c SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-a66fd0c8]: D |  | 49 (CH-108 ACT:DMF0003_MatsterChgPopup.FindB) |
| WK-DMF0003-0414 | A6 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCM0001_GET_BIZ_TYPE_BY_DIVISION: 원장 V-41134236 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-12a5dc5d |  | 1 (CK-08) |
| WK-DMF0003-0415 | A6 | SCM0001_GET_LOOKUP_VALUES | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCM0001_GET_LOOKUP_VALUES: 원장 V-3b78e8ca SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-2dcb07ce]: SCM0 |  | 1 (CK-07) |
| WK-DMF0003-0416 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-DMF0003-0417 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-DMF0003-0418 | X-LOC | 26/27/28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 26/27/28: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (26/27/28) |
| WK-DMF0003-0419 | X-LOC | 3. 배선 체인 L7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3. 배선 체인 L7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3. 배선 체인 L7) |
| WK-DMF0003-0420 | X-LOC | 34 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 34: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (34) |
| WK-DMF0003-0421 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-DMF0003-0422 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-DMF0003-0423 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-DMF0003-0424 | X-LOC | 6. HTTP E2E | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6. HTTP E2E: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6. HTTP E2E) |
| WK-DMF0003-0425 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-DMF0003-0426 | X-LOC | 7. 콤보 파라미터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7. 콤보 파라미터: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7. 콤보 파라미터) |
| WK-DMF0003-0427 | X-LOC | 73 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 73: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (73) |
| WK-DMF0003-0428 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-DMF0003-0429 | X-LOC | 8. 콤보 호출지점 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8. 콤보 호출지점: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8. 콤보 호출지점) |
| WK-DMF0003-0430 | X-LOC | 81 Plant Site 편집 후보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 81 Plant Site 편집 후보: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (81 Plant Site 편집 후보) |
| WK-DMF0003-0431 | X-LOC | 8주 잠금(40 Monthly) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8주 잠금(40 Monthly): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8주 잠금(40 Monthly)) |
| WK-DMF0003-0432 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-DMF0003-0433 | X-LOC | AS_FROM_SITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS_FROM_SITE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS_FROM_SITE) |
| WK-DMF0003-0434 | X-LOC | BizType / CustomsHandbook / FcstType / I | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BizType / CustomsHandbook / FcstType / Incoterms /: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BizType / CustomsHandbook / FcstType / I) |
| WK-DMF0003-0435 | X-LOC | Div40 Sales Site 편집 후보 (`endCustomer='HP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Div40 Sales Site 편집 후보 (`endCustomer='HP'`): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Div40 Sales Site 편집 후보 (`endCustomer='HP) |
| WK-DMF0003-0436 | X-LOC | EndCustomerByDivision40Team | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EndCustomerByDivision40Team: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EndCustomerByDivision40Team) |
| WK-DMF0003-0437 | X-LOC | EndCustomerByDivisionDeptAuth | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EndCustomerByDivisionDeptAuth: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EndCustomerByDivisionDeptAuth) |
| WK-DMF0003-0438 | X-LOC | Events | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Events: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Events) |
| WK-DMF0003-0439 | X-LOC | Expressions | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Expressions: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Expressions) |
| WK-DMF0003-0440 | X-LOC | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Measure: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Measure) |
| WK-DMF0003-0441 | X-LOC | PlantByDivisionCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PlantByDivisionCompany: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PlantByDivisionCompany) |
| WK-DMF0003-0442 | X-LOC | PlantSite 필수(81만) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PlantSite 필수(81만): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PlantSite 필수(81만)) |
| WK-DMF0003-0443 | X-LOC | PlantSiteByItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PlantSiteByItem: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PlantSiteByItem) |
| WK-DMF0003-0444 | X-LOC | Popup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Popup: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Popup) |
| WK-DMF0003-0445 | X-LOC | SiteByEndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SiteByEndCustomer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SiteByEndCustomer) |
| WK-DMF0003-0446 | X-LOC | SiteByEndCustomerAuth | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SiteByEndCustomerAuth: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SiteByEndCustomerAuth) |
| WK-DMF0003-0447 | X-LOC | SspSync(40 & MKT_FCST_RP) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SspSync(40 & MKT_FCST_RP): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SspSync(40 & MKT_FCST_RP)) |
| WK-DMF0003-0448 | X-LOC | TeambyDivisionAuth | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — TeambyDivisionAuth: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (TeambyDivisionAuth) |
| WK-DMF0003-0449 | X-LOC | VMI_YN/STD_DIO 표시(82만) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — VMI_YN/STD_DIO 표시(82만): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (VMI_YN/STD_DIO 표시(82만)) |
| WK-DMF0003-0450 | X-LOC | `Substring(0,2)=="81"` / `=="82"` / else | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `Substring(0,2)=="81"` / `=="82"` / else(40): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`Substring(0,2)=="81"` / `=="82"` / else) |
| WK-DMF0003-0451 | X-LOC | `__asis-mapping__.md` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `__asis-mapping__.md`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`__asis-mapping__.md`) |
| WK-DMF0003-0452 | X-LOC | `_artifacts/_apply_corporate/40_dmf0003_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `_artifacts/_apply_corporate/40_dmf0003_i18n_regis: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`_artifacts/_apply_corporate/40_dmf0003_) |
| WK-DMF0003-0453 | X-LOC | `components/modals/{PrModal,PrHistoryMod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `components/modals/{PrModal,PrHistoryModal,SspSync: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`components/modals/{PrModal,PrHistoryMod) |
| WK-DMF0003-0454 | X-LOC | `public/locales/{KO,EN,CN}.json` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `public/locales/{KO,EN,CN}.json`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`public/locales/{KO,EN,CN}.json`) |
| WK-DMF0003-0455 | X-LOC | iDailyQty/iRemnant 분배 (#103/104/107/108/ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — iDailyQty/iRemnant 분배 (#103/104/107/108/110): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (iDailyQty/iRemnant 분배 (#103/104/107/108/) |
| WK-DMF0003-0456 | X-LOC | iLastWeeklySum 과거합 (#115/116/117) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — iLastWeeklySum 과거합 (#115/116/117): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (iLastWeeklySum 과거합 (#115/116/117)) |
| WK-DMF0003-0457 | X-LOC | iMonthlySum 누적/세팅 (#98/99/112/127) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — iMonthlySum 누적/세팅 (#98/99/112/127): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (iMonthlySum 누적/세팅 (#98/99/112/127)) |
| WK-DMF0003-0458 | X-LOC | iMonthlySum-iLastWeeklySum 분배 (#118/119) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — iMonthlySum-iLastWeeklySum 분배 (#118/119): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (iMonthlySum-iLastWeeklySum 분배 (#118/119)) |
| WK-DMF0003-0459 | X-LOC | iWeeklySum 누적/세팅 (#96/97/122/125) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — iWeeklySum 누적/세팅 (#96/97/122/125): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (iWeeklySum 누적/세팅 (#96/97/122/125)) |
| WK-DMF0003-0460 | X-LOC | iWkSum_Sync 강제상향 (#102/105/106) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — iWkSum_Sync 강제상향 (#102/105/106): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (iWkSum_Sync 강제상향 (#102/105/106)) |
| WK-DMF0003-0461 | X-LOC | 중복키 81=+PlantSite / 82=제외 / 40=Customer4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 중복키 81=+PlantSite / 82=제외 / 40=Customer40계열: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (중복키 81=+PlantSite / 82=제외 / 40=Customer4) |
| WK-DMF0003-0462 | X-LOC | 키 컬럼 40=Customer40/ScmSiteId40/ItemId40  | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 키 컬럼 40=Customer40/ScmSiteId40/ItemId40 vs 81·82=P: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (키 컬럼 40=Customer40/ScmSiteId40/ItemId40 ) |
| WK-DMF0003-0463 | X-ROW | DMF0003_1_MktFcst.CAR_REF_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0003_1_MktFcst.CAR_REF_DATA: 진입점 집계 7검사 — NA:3 · PASS:3 · REVIEW:1 |  | 43 (ACT:DMF0003_1_MktFcst.CAR_REF_DATA ACT:D) |
| WK-DMF0003-0464 | X-ROW | DMF0003_1_MktFcst.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0003_1_MktFcst.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된 요소 검사 |  | 15 (ACT:DMF0003_1_MktFcst.ExcelButton ACT:DM) |
| WK-DMF0003-0465 | X-ROW | DMF0003_1_MktFcst.FirstWeeked | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0003_1_MktFcst.FirstWeeked: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:DMF0003_1_MktFcst.FirstWeeked ACT:DM) |
| WK-DMF0003-0466 | X-ROW | DMF0003_1_MktFcst.PSI_FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0003_1_MktFcst.PSI_FindData: 진입점 집계 12검사 — NA:8 · PASS:3 · REVIEW:1 |  | 62 (ACT:DMF0003_1_MktFcst.PSI_FindData ACT:D) |
| WK-DMF0003-0467 | X-ROW | DMF0003_1_MktFcst.fnValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0003_1_MktFcst.fnValidation: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLOW/LOCAL/RETURN/STATE_RESET,  |  | 164 (ACT:DMF0003_1_MktFcst.fnValidation ACT:D) |
| WK-DMF0003-0468 | X-ROW | DMF0003_1_MktFcst.spdMain_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0003_1_MktFcst.spdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/FLAG/RETURN, 연결된 요소 검사 없음 |  | 4 (ACT:DMF0003_1_MktFcst.spdMain_EditChange) |
| WK-DMF0003-0469 | X-ROW | DMF0003_1_MktFcst.spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0003_1_MktFcst.spdMain_KeyUp: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/FLAG/RETURN, 연결된 요소 검사 없음 |  | 9 (ACT:DMF0003_1_MktFcst.spdMain_KeyUp ACT:) |
| WK-DMF0003-0470 | X-ROW | DMF0003_1_MktFcst.splitContainer2_Double | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0003_1_MktFcst.splitContainer2_DoubleClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/UI_PROP, 연결된 요소 검사 없음 |  | 4 (ACT:DMF0003_1_MktFcst.splitContainer2_Do) |
| WK-DMF0003-0471 | X-ROW | DMF0003_CustDemandAnalysis.Select_DpInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0003_CustDemandAnalysis.Select_DpInit_Data: 진입점 집계 13검사 — NA:9 · PASS:3 · REVIEW:1 |  | 55 (ACT:DMF0003_CustDemandAnalysis.Select_Dp) |
| WK-DMF0003-0472 | X-ROW | DMF0003_CustDemandAnalysis.Select_DpResu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0003_CustDemandAnalysis.Select_DpResult_Data: 진입점 집계 13검사 — NA:9 · PASS:3 · REVIEW:1 |  | 54 (ACT:DMF0003_CustDemandAnalysis.Select_Dp) |
| WK-DMF0003-0473 | X-ROW | DMF0003_PRHistoryPopup.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0003_PRHistoryPopup.FindDataMain: 진입점 집계 8검사 — PASS:4 · NA:3 · REVIEW:1 |  | 34 (ACT:DMF0003_PRHistoryPopup.FindDataMain ) |
| WK-DMF0003-0474 | X-ROW | DMF0003_PRPopup.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0003_PRPopup.FindDataMain: 진입점 집계 10검사 — NA:5 · PASS:4 · REVIEW:1 |  | 39 (ACT:DMF0003_PRPopup.FindDataMain ACT:DMF) |
| WK-DMF0003-0475 | M4 | DMF0003_MatsterChgPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0003_MatsterChgPopup: 검증 엔진이 실행됐으나 이 대상(POPUP DMF0003_MatsterChgPopup)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (CA-116) |
| WK-DMF0003-0476 | M4 | DMF0003_MktFcst | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0003_MktFcst: 검증 엔진이 실행됐으나 이 대상(POPUP DMF0003_MktFcst)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 3 (HANDLER:spdMain_CellDoubleClick HANDLER:) |
| WK-DMF0003-0477 | M4 | DMF0003_PRHistoryPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0003_PRHistoryPopup: 검증 엔진이 실행됐으나 이 대상(POPUP DMF0003_PRHistoryPopup)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (MODAL:PrHistoryModal) |
| WK-DMF0003-0478 | M4 | DMF0003_PRPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0003_PRPopup: 검증 엔진이 실행됐으나 이 대상(POPUP DMF0003_PRPopup)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (CA-111 MODAL:PrModal) |
| WK-DMF0003-0479 | M4 | DMF0003_SspSyncComparePopUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0003_SspSyncComparePopUp: 검증 엔진이 실행됐으나 이 대상(POPUP DMF0003_SspSyncComparePopUp)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔 |  | 6 (CA-114 MODAL:DMF0003_SspSyncComparePopUp) |
| WK-DMF0003-0480 | M4 | DMF0003_SspSyncPopUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0003_SspSyncPopUp: 검증 엔진이 실행됐으나 이 대상(POPUP DMF0003_SspSyncPopUp)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 3 (MODAL:DMF0003_SspSyncPopUp MODAL:SspSync) |
| WK-DMF0003-0481 | M4 | DMF0003_T_MktFcst | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0003_T_MktFcst: 검증 엔진이 실행됐으나 이 대상(POPUP DMF0003_T_MktFcst)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (ACT:DMF0003_T_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0482 | M4 | cboBucketType / Bucket / Bucket Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboBucketType / Bucket / Bucket Type: 검증 엔진이 실행됐으나 이 대상(COND cboBucketType)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 6 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0483 | M4 | clbDivision / Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — clbDivision / Division: 검증 엔진이 실행됐으나 이 대상(COND clbDivision)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 10 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0484 | M4 | drpPeriod / Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — drpPeriod / Period: 검증 엔진이 실행됐으나 이 대상(COND drpPeriod)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 5 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |

## W9 도구 오류 (446)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0003-0485 | D3 | 4 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 4 'FCST_TYPE 편집 콤보 분기(L2587~2605) — W/S=EDIT_MODE 6종 ' 의 D3 337요소: ERROR:323 · NA:14 |  | 0 () |
| WK-DMF0003-0486 | D3 | 7 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 7 'SCP Planner 차단 — Edit 82·40(L828~834) / Insert 81(' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (7) |
| WK-DMF0003-0487 | D3 | 8 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 8 'SCP 시간창(81) — LOOKUP SCP_PLANNER_EDIT_FLAG 행 0=차단 ' 의 D3 337요소: ERROR:323 · NA:14 |  | 0 () |
| WK-DMF0003-0488 | D3 | 81 Plant Site 편집 후보 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 81 Plant Site 편집 후보 '표시 콤보 그대로(전 27~107행, Project/Item 무관)' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (81 Plant Site 편집 후보) |
| WK-DMF0003-0489 | D3 | 8주 잠금(40 Monthly) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 8주 잠금(40 Monthly) 'L974~981' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (8주 잠금(40 Monthly)) |
| WK-DMF0003-0490 | D3 | APPLICATION | 하네스·환경 | D3 도구 오류 — 원장 V-c1e5840f ASIS / 원장 V-7b50f3f3 ASIS / 원장 V-9ad3875f ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2037:98 ) |
| WK-DMF0003-0491 | D3 | APPLICATION,APPLICATION | 하네스·환경 | D3 도구 오류 — 원장 V-c1e5840f |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2037:98) |
| WK-DMF0003-0492 | D3 | APPLICATION,APPLICATION | 하네스·환경 | D3 도구 오류 — 원장 V-7b50f3f3 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2729:116) |
| WK-DMF0003-0493 | D3 | APPLICATION,APPLICATION | 하네스·환경 | D3 도구 오류 — 원장 V-9ad3875f |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1785:98) |
| WK-DMF0003-0494 | D3 | AS_FROM_SITE | 하네스·환경 | D3 도구 오류 — 원장 V-8adca92a ASIS / 원장 V-83bae784 ASIS / 원장 V-efba9423 ASIS / 원장 V-45197a47 ASIS / 원장 V-290df333 ASIS / 원장 V-c3e777c1  |  | 21 (CC-05 CE-02 CK-09 Expressions 행잠금: AS_FR) |
| WK-DMF0003-0495 | D3 | AS_FROM_SITE,AS_FROM_SITE | 하네스·환경 | D3 도구 오류 — 원장 V-8adca92a |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2062:122) |
| WK-DMF0003-0496 | D3 | AS_FROM_SITE,AS_FROM_SITE | 하네스·환경 | D3 도구 오류 — 원장 V-83bae784 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2753:140) |
| WK-DMF0003-0497 | D3 | AS_FROM_SITE,AS_FROM_SITE | 하네스·환경 | D3 도구 오류 — 원장 V-efba9423 |  | 1 (ACT:DMF0003_MktFcst.spdMain_ClipboardPas) |
| WK-DMF0003-0498 | D3 | AS_FROM_SITE,AS_FROM_SITE | 하네스·환경 | D3 도구 오류 — 원장 V-45197a47 |  | 1 (ACT:DMF0003_MktFcst.spdMain_ClipboardPas) |
| WK-DMF0003-0499 | D3 | AS_FROM_SITE,AS_FROM_SITE | 하네스·환경 | D3 도구 오류 — 원장 V-290df333 |  | 1 (ACT:DMF0003_MktFcst.spdMain_ClipboardPas) |
| WK-DMF0003-0500 | D3 | AS_FROM_SITE,AS_FROM_SITE | 하네스·환경 | D3 도구 오류 — 원장 V-c3e777c1 |  | 1 (ACT:DMF0003_MktFcst.spdMain_ComboSelChan) |
| WK-DMF0003-0501 | D3 | AS_FROM_SITE,AS_FROM_SITE | 하네스·환경 | D3 도구 오류 — 원장 V-cc8245e8 |  | 1 (ACT:DMF0003_MktFcst.spdMain_ComboSelChan) |
| WK-DMF0003-0502 | D3 | AS_FROM_SITE,AS_FROM_SITE | 하네스·환경 | D3 도구 오류 — 원장 V-da039d81 |  | 1 (ACT:DMF0003_MktFcst.spdMain_ComboSelChan) |
| WK-DMF0003-0503 | D3 | AS_FROM_SITE,AS_FROM_SITE | 하네스·환경 | D3 도구 오류 — 원장 V-b06cffd3 |  | 1 (ACT:DMF0003_MktFcst.spdMain_ComboSelChan) |
| WK-DMF0003-0504 | D3 | AS_FROM_SITE,AS_FROM_SITE | 하네스·환경 | D3 도구 오류 — 원장 V-27f5021d |  | 1 (ACT:DMF0003_MktFcst.spdMain_ComboSelChan) |
| WK-DMF0003-0505 | D3 | AS_FROM_SITE,AS_FROM_SITE | 하네스·환경 | D3 도구 오류 — 원장 V-874d43fc |  | 1 (ACT:DMF0003_MktFcst.spdMain_ComboSelChan) |
| WK-DMF0003-0506 | D3 | AS_FROM_SITE,AS_FROM_SITE | 하네스·환경 | D3 도구 오류 — 원장 V-8bd3375a |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1810:122) |
| WK-DMF0003-0507 | D3 | B,B | 하네스·환경 | D3 도구 오류 — 원장 V-56edef85 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1260:94) |
| WK-DMF0003-0508 | D3 | B,B | 하네스·환경 | D3 도구 오류 — 원장 V-d3ba6e94 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2011:72) |
| WK-DMF0003-0509 | D3 | B,B | 하네스·환경 | D3 도구 오류 — 원장 V-bf936681 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1154:119) |
| WK-DMF0003-0510 | D3 | B,B | 하네스·환경 | D3 도구 오류 — 원장 V-0f0bb749 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2703:90) |
| WK-DMF0003-0511 | D3 | B,B | 하네스·환경 | D3 도구 오류 — 원장 V-4d33e385 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:929:94) |
| WK-DMF0003-0512 | D3 | B,B | 하네스·환경 | D3 도구 오류 — 원장 V-17763ed7 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1759:72) |
| WK-DMF0003-0513 | D3 | C | 하네스·환경 | D3 도구 오류 — 원장 V-fe246f47 ASIS / 원장 V-b353fe2c ASIS / 원장 V-d2791862 ASIS / 원장 V-2359ec1e ASIS / 원장 V-a95deb70 ASIS / 원장 V-73c6fd81  |  | 2 (C-121 ACT:DMF0003_MktFcst.EditButton) |
| WK-DMF0003-0514 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-ddcacf1c |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1258:92) |
| WK-DMF0003-0515 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-8e7a9a97 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1262:96) |
| WK-DMF0003-0516 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-59b71925 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1264:98) |
| WK-DMF0003-0517 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-b4773799 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1266:10) |
| WK-DMF0003-0518 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-4de91be7 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1268:10) |
| WK-DMF0003-0519 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-2faa75a6 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2015:76) |
| WK-DMF0003-0520 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-63194b1d |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2017:78) |
| WK-DMF0003-0521 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-d55c3916 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2047:108) |
| WK-DMF0003-0522 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-f40a5f02 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1152:117) |
| WK-DMF0003-0523 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-59d2a932 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1156:121) |
| WK-DMF0003-0524 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-7524d13d |  | 1 (ACT:DMF0003_MktFcst.EditButton:1158:123) |
| WK-DMF0003-0525 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-c0a4c475 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1160:125) |
| WK-DMF0003-0526 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-09b04e56 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1162:127) |
| WK-DMF0003-0527 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-a180d8ae |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2707:94) |
| WK-DMF0003-0528 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-5359e84b |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2709:96) |
| WK-DMF0003-0529 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-8af8affc |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2739:126) |
| WK-DMF0003-0530 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-4956e6e6 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:927:92) |
| WK-DMF0003-0531 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-4d17b0d5 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:931:96) |
| WK-DMF0003-0532 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-97ada01f |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:933:98) |
| WK-DMF0003-0533 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-63cfc909 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:935:100) |
| WK-DMF0003-0534 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-87f88578 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:937:102) |
| WK-DMF0003-0535 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-f76911b7 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1763:76) |
| WK-DMF0003-0536 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-03a60f79 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1765:78) |
| WK-DMF0003-0537 | D3 | C,C | 하네스·환경 | D3 도구 오류 — 원장 V-e21e9aac |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1795:108) |
| WK-DMF0003-0538 | D3 | CB-01 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CB-01 "§2 `EDIT_FLAG != 'Y'` 행 = Measure 이후 전열 잠금 / L1132" 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CB-01) |
| WK-DMF0003-0539 | D3 | CB-02 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CB-02 '§2 Measure 컬럼까지(키 영역) 전 행 잠금 — Insert 행만 예외 / L112' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CB-02) |
| WK-DMF0003-0540 | D3 | CB-102 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CB-102 '§2 [원문 무번호] Daily / 과거(<당주월요일) 잠금' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CB-102) |
| WK-DMF0003-0541 | D3 | CB-103 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CB-103 '§2 [원문 무번호] Weekly / 전부 잠금' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CB-103) |
| WK-DMF0003-0542 | D3 | CB-104 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CB-104 '§2 [원문 무번호] Monthly / 전부 잠금 (40: 조건부 — MONTH_NAME ' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CB-104) |
| WK-DMF0003-0543 | D3 | CELL_PER_MODULE | 하네스·환경 | D3 도구 오류 — 원장 V-1621dcee ASIS |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2772:152) |
| WK-DMF0003-0544 | D3 | CELL_PER_MODULE,CELL_PER_MODULE | 하네스·환경 | D3 도구 오류 — 원장 V-1621dcee |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2772:152) |
| WK-DMF0003-0545 | D3 | CF-106 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CF-106 '§6.2 [원문 무번호] 셀편집/저장 / MSG00429' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CF-106) |
| WK-DMF0003-0546 | D3 | CF-112 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CF-112 '§6.2 [원문 무번호] 편집게이트 / MSG00448' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CF-112) |
| WK-DMF0003-0547 | D3 | CG-113 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CG-113 '§7.1 [원문 무번호] 8주 잠금(Monthly) / ✓' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CG-113) |
| WK-DMF0003-0548 | D3 | CH-08 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CH-08 '§8 버킷 변경(편집모드) / EditButton 2회 재호출로 잠금 재계산' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CH-08) |
| WK-DMF0003-0549 | D3 | CI-07 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CI-07 '§9 저장 후 / Action 클리어 + UnLockColor + 행 재잠금(빨강 계열)' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CI-07) |
| WK-DMF0003-0550 | D3 | CJ-04 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CJ-04 '§10 SCP Planner / 82·40 편집 차단(MSG00096) / 81* 시간 게' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CJ-04) |
| WK-DMF0003-0551 | D3 | CJ-05 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CJ-05 '§10 그 외(Viewer 등) / Master Chg 숨김·편집 버튼 BaseForm 권' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CJ-05) |
| WK-DMF0003-0552 | D3 | CRUD:E03:EDIT | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CRUD:E03:EDIT '[EDIT] §3.1 EditButton — 편집 게이트 8종 + 잠금 (수기 추가)' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CRUD:E03:EDIT) |
| WK-DMF0003-0553 | D3 | CRUD:E03:SAVE | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CRUD:E03:SAVE '[SAVE] §3 편집/저장' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (CRUD:E03:SAVE) |
| WK-DMF0003-0554 | D3 | CUST_GROUP | 하네스·환경 | D3 도구 오류 — 원장 V-dc2429f1 ASIS / 원장 V-8b7dd565 ASIS / 원장 V-e60700a4 ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2031:92 ) |
| WK-DMF0003-0555 | D3 | CUST_GROUP,CUST_GROUP | 하네스·환경 | D3 도구 오류 — 원장 V-dc2429f1 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2031:92) |
| WK-DMF0003-0556 | D3 | CUST_GROUP,CUST_GROUP | 하네스·환경 | D3 도구 오류 — 원장 V-8b7dd565 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2723:110) |
| WK-DMF0003-0557 | D3 | CUST_GROUP,CUST_GROUP | 하네스·환경 | D3 도구 오류 — 원장 V-e60700a4 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1779:92) |
| WK-DMF0003-0558 | D3 | CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-7482b962 ASIS / 원장 V-e8e56091 ASIS / 원장 V-c8eacf2c ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2033:94 ) |
| WK-DMF0003-0559 | D3 | CUST_GROUP_DTL,CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-7482b962 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2033:94) |
| WK-DMF0003-0560 | D3 | CUST_GROUP_DTL,CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-e8e56091 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2725:112) |
| WK-DMF0003-0561 | D3 | CUST_GROUP_DTL,CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-c8eacf2c |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1781:94) |
| WK-DMF0003-0562 | D3 | D | 하네스·환경 | D3 도구 오류 — 원장 V-fe246f47 ASIS / 원장 V-b353fe2c ASIS / 원장 V-d2791862 ASIS / 원장 V-2359ec1e ASIS / 원장 V-a95deb70 ASIS / 원장 V-73c6fd81  |  | 5 (AS_FROM_SITE ACT:DMF0003_1_MktFcst.Inser) |
| WK-DMF0003-0563 | D3 | D,D | 하네스·환경 | D3 도구 오류 — 원장 V-b7b45899 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1358:15) |
| WK-DMF0003-0564 | D3 | D,D | 하네스·환경 | D3 도구 오류 — 원장 V-05b94e31 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1360:15) |
| WK-DMF0003-0565 | D3 | D,D | 하네스·환경 | D3 도구 오류 — 원장 V-a2f2c5cd |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2007:68) |
| WK-DMF0003-0566 | D3 | D,D | 하네스·환경 | D3 도구 오류 — 원장 V-aa4efd05 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2009:70) |
| WK-DMF0003-0567 | D3 | D,D | 하네스·환경 | D3 도구 오류 — 원장 V-50c8b70e |  | 1 (ACT:DMF0003_MktFcst.EditButton:1276:183) |
| WK-DMF0003-0568 | D3 | D,D | 하네스·환경 | D3 도구 오류 — 원장 V-3feb475f |  | 1 (ACT:DMF0003_MktFcst.EditButton:1278:184) |
| WK-DMF0003-0569 | D3 | D,D | 하네스·환경 | D3 도구 오류 — 원장 V-cdc8bdc7 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2699:86) |
| WK-DMF0003-0570 | D3 | D,D | 하네스·환경 | D3 도구 오류 — 원장 V-7714e1db |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2701:88) |
| WK-DMF0003-0571 | D3 | D,D | 하네스·환경 | D3 도구 오류 — 원장 V-70f40d41 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:1027:15) |
| WK-DMF0003-0572 | D3 | D,D | 하네스·환경 | D3 도구 오류 — 원장 V-f4485f37 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:1029:15) |
| WK-DMF0003-0573 | D3 | D,D | 하네스·환경 | D3 도구 오류 — 원장 V-b779578f |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1755:68) |
| WK-DMF0003-0574 | D3 | D,D | 하네스·환경 | D3 도구 오류 — 원장 V-abe68dd0 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1757:70) |
| WK-DMF0003-0575 | D3 | DMF0003_1_MktFcst.EditButton | 하네스·환경 | D3 도구 오류 — 원장 V-e02c99cc ASIS / 원장 V-fe246f47 ASIS / 원장 V-b353fe2c ASIS / 원장 V-d2791862 ASIS / 원장 V-2359ec1e ASIS / 원장 V-a95deb70  |  | 114 (ACT:DMF0003_1_MktFcst.EditButton:981:1 A) |
| WK-DMF0003-0576 | D3 | DMS_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-ab6fbabb ASIS / 원장 V-c1ddf067 ASIS / 원장 V-c3c0fb17 ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2059:120) |
| WK-DMF0003-0577 | D3 | DMS_CUSTOMER,DMS_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-ab6fbabb |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2059:120) |
| WK-DMF0003-0578 | D3 | DMS_CUSTOMER,DMS_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-c1ddf067 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2751:138) |
| WK-DMF0003-0579 | D3 | DMS_CUSTOMER,DMS_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-c3c0fb17 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1807:120) |
| WK-DMF0003-0580 | D3 | DMS_SALES | 하네스·환경 | D3 도구 오류 — 원장 V-6f84b26d ASIS / 원장 V-304fe1dd ASIS / 원장 V-b95448ee ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2057:118) |
| WK-DMF0003-0581 | D3 | DMS_SALES,DMS_SALES | 하네스·환경 | D3 도구 오류 — 원장 V-6f84b26d |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2057:118) |
| WK-DMF0003-0582 | D3 | DMS_SALES,DMS_SALES | 하네스·환경 | D3 도구 오류 — 원장 V-304fe1dd |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2749:136) |
| WK-DMF0003-0583 | D3 | DMS_SALES,DMS_SALES | 하네스·환경 | D3 도구 오류 — 원장 V-b95448ee |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1805:118) |
| WK-DMF0003-0584 | D3 | E03 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 E03 '§3 편집/저장' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (E03) |
| WK-DMF0003-0585 | D3 | E03-1 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 E03-1 '§3.1 EditButton (L824~1338) — 편집 게이트 8종 + 잠금 매트릭스' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (E03-1) |
| WK-DMF0003-0586 | D3 | FORECAST_INFO_BIZ_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-1a0ac536 ASIS / 원장 V-953d1969 ASIS / 원장 V-7f105184 ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2045:106) |
| WK-DMF0003-0587 | D3 | FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_BIZ | 하네스·환경 | D3 도구 오류 — 원장 V-1a0ac536 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2045:106) |
| WK-DMF0003-0588 | D3 | FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_BIZ | 하네스·환경 | D3 도구 오류 — 원장 V-953d1969 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2737:124) |
| WK-DMF0003-0589 | D3 | FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_BIZ | 하네스·환경 | D3 도구 오류 — 원장 V-7f105184 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1793:106) |
| WK-DMF0003-0590 | D3 | FORECAST_INFO_CELL_MODEL | 하네스·환경 | D3 도구 오류 — 원장 V-6b279cab ASIS / 원장 V-1ccdbc21 ASIS / 원장 V-3bafa148 ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2049:110) |
| WK-DMF0003-0591 | D3 | FORECAST_INFO_CELL_MODEL,FORECAST_INFO_C | 하네스·환경 | D3 도구 오류 — 원장 V-6b279cab |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2049:110) |
| WK-DMF0003-0592 | D3 | FORECAST_INFO_CELL_MODEL,FORECAST_INFO_C | 하네스·환경 | D3 도구 오류 — 원장 V-1ccdbc21 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2741:128) |
| WK-DMF0003-0593 | D3 | FORECAST_INFO_CELL_MODEL,FORECAST_INFO_C | 하네스·환경 | D3 도구 오류 — 원장 V-3bafa148 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1797:110) |
| WK-DMF0003-0594 | D3 | FORECAST_INFO_CELL_PACK_COUNT | 하네스·환경 | D3 도구 오류 — 원장 V-fde698d2 ASIS / 원장 V-7d6bfd84 ASIS / 원장 V-74e8f0cb ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2051:112) |
| WK-DMF0003-0595 | D3 | FORECAST_INFO_CELL_PACK_COUNT,FORECAST_I | 하네스·환경 | D3 도구 오류 — 원장 V-fde698d2 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2051:112) |
| WK-DMF0003-0596 | D3 | FORECAST_INFO_CELL_PACK_COUNT,FORECAST_I | 하네스·환경 | D3 도구 오류 — 원장 V-7d6bfd84 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2743:130) |
| WK-DMF0003-0597 | D3 | FORECAST_INFO_CELL_PACK_COUNT,FORECAST_I | 하네스·환경 | D3 도구 오류 — 원장 V-74e8f0cb |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1799:112) |
| WK-DMF0003-0598 | D3 | FORECAST_INFO_SPEC | 하네스·환경 | D3 도구 오류 — 원장 V-c2565891 ASIS / 원장 V-876e0bf3 ASIS / 원장 V-6b3dd6ec ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2053:114) |
| WK-DMF0003-0599 | D3 | FORECAST_INFO_SPEC,FORECAST_INFO_SPEC | 하네스·환경 | D3 도구 오류 — 원장 V-c2565891 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2053:114) |
| WK-DMF0003-0600 | D3 | FORECAST_INFO_SPEC,FORECAST_INFO_SPEC | 하네스·환경 | D3 도구 오류 — 원장 V-876e0bf3 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2745:132) |
| WK-DMF0003-0601 | D3 | FORECAST_INFO_SPEC,FORECAST_INFO_SPEC | 하네스·환경 | D3 도구 오류 — 원장 V-6b3dd6ec |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1801:114) |
| WK-DMF0003-0602 | D3 | HANDLER:EditButton | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 HANDLER:EditButton 'AS-IS `DMF0003_MktFcst.cs:824` (라이브 358행)' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (HANDLER:EditButton) |
| WK-DMF0003-0603 | D3 | HANDLER:spdMain_CellClick | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 HANDLER:spdMain_CellClick 'AS-IS `DMF0003_MktFcst.cs:6596` (라이브 74행)' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (HANDLER:spdMain_CellClick) |
| WK-DMF0003-0604 | D3 | I | 하네스·환경 | D3 도구 오류 — 원장 V-fe246f47 ASIS / 원장 V-b353fe2c ASIS / 원장 V-d2791862 ASIS / 원장 V-2359ec1e ASIS / 원장 V-a95deb70 ASIS / 원장 V-73c6fd81  |  | 1 (CB-03) |
| WK-DMF0003-0605 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-a014037a |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1272:10) |
| WK-DMF0003-0606 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-7682f168 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1274:10) |
| WK-DMF0003-0607 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-166be135 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1276:11) |
| WK-DMF0003-0608 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-88f8db86 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1278:11) |
| WK-DMF0003-0609 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-54ec32a7 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2025:86) |
| WK-DMF0003-0610 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-33809d50 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2029:90) |
| WK-DMF0003-0611 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-ee2a3066 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1166:131) |
| WK-DMF0003-0612 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-0d11918d |  | 1 (ACT:DMF0003_MktFcst.EditButton:1168:133) |
| WK-DMF0003-0613 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-7be03afd |  | 1 (ACT:DMF0003_MktFcst.EditButton:1170:135) |
| WK-DMF0003-0614 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-515b90e1 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1172:137) |
| WK-DMF0003-0615 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-d043b644 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2717:104) |
| WK-DMF0003-0616 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-db252de3 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2721:108) |
| WK-DMF0003-0617 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-8eb96889 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:941:106) |
| WK-DMF0003-0618 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-98fd1c90 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:943:108) |
| WK-DMF0003-0619 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-09492de9 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:945:110) |
| WK-DMF0003-0620 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-ef5c6db2 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:947:112) |
| WK-DMF0003-0621 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-a5f8cbb2 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1773:86) |
| WK-DMF0003-0622 | D3 | I,I | 하네스·환경 | D3 도구 오류 — 원장 V-446ccd1d |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1777:90) |
| WK-DMF0003-0623 | D3 | ITEM_DETAIL,ITEM_DETAIL | 하네스·환경 | D3 도구 오류 — 원장 V-4ab35b8f |  | 1 (ACT:DMF0003_PRPopup.EditButton:288:13) |
| WK-DMF0003-0624 | D3 | L | 하네스·환경 | D3 도구 오류 — 원장 V-e02c99cc ASIS / 원장 V-fe246f47 ASIS / 원장 V-b353fe2c ASIS / 원장 V-d2791862 ASIS / 원장 V-2359ec1e ASIS / 원장 V-a95deb70  |  | 0 () |
| WK-DMF0003-0625 | D3 | LAST_UPDATED_BY | 하네스·환경 | D3 도구 오류 — 원장 V-37dd4981 ASIS / 원장 V-26ae99a5 ASIS / 원장 V-39a45714 ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2067:126) |
| WK-DMF0003-0626 | D3 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D3 도구 오류 — 원장 V-37dd4981 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2067:126) |
| WK-DMF0003-0627 | D3 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D3 도구 오류 — 원장 V-26ae99a5 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2757:144) |
| WK-DMF0003-0628 | D3 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D3 도구 오류 — 원장 V-39a45714 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1815:126) |
| WK-DMF0003-0629 | D3 | LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-e726e67a ASIS / 원장 V-549592c2 ASIS / 원장 V-a8df6e72 ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2065:124) |
| WK-DMF0003-0630 | D3 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-e726e67a |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2065:124) |
| WK-DMF0003-0631 | D3 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-549592c2 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2755:142) |
| WK-DMF0003-0632 | D3 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-a8df6e72 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1813:124) |
| WK-DMF0003-0633 | D3 | M | 하네스·환경 | D3 도구 오류 — 원장 V-923ceeea |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1229:77) |
| WK-DMF0003-0634 | D3 | M | 하네스·환경 | D3 도구 오류 — 원장 V-47b03baf |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1241:80) |
| WK-DMF0003-0635 | D3 | M | 하네스·환경 | D3 도구 오류 — 원장 V-f6a0831e |  | 1 (ACT:DMF0003_1_MktFcst.SetSaveSheetColor:) |
| WK-DMF0003-0636 | D3 | M | 하네스·환경 | D3 도구 오류 — 원장 V-f1589f84 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1123:102) |
| WK-DMF0003-0637 | D3 | M | 하네스·환경 | D3 도구 오류 — 원장 V-cae033ec |  | 1 (ACT:DMF0003_MktFcst.EditButton:1135:105) |
| WK-DMF0003-0638 | D3 | M | 하네스·환경 | D3 도구 오류 — 원장 V-6e91fcb5 |  | 1 (ACT:DMF0003_MktFcst.SetSaveSheetColor:25) |
| WK-DMF0003-0639 | D3 | M | 하네스·환경 | D3 도구 오류 — 원장 V-2a4b00ba |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:898:77) |
| WK-DMF0003-0640 | D3 | M | 하네스·환경 | D3 도구 오류 — 원장 V-bc4c3710 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:910:80) |
| WK-DMF0003-0641 | D3 | M | 하네스·환경 | D3 도구 오류 — 원장 V-c37ca3d9 |  | 1 (ACT:DMF0003_T_MktFcst.SetSaveSheetColor:) |
| WK-DMF0003-0642 | D3 | M,M | 하네스·환경 | D3 도구 오류 — 원장 V-3c2166e2 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1270:10) |
| WK-DMF0003-0643 | D3 | M,M | 하네스·환경 | D3 도구 오류 — 원장 V-c2feb605 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1289:12) |
| WK-DMF0003-0644 | D3 | M,M | 하네스·환경 | D3 도구 오류 — 원장 V-b4dc5013 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2074:132) |
| WK-DMF0003-0645 | D3 | M,M | 하네스·환경 | D3 도구 오류 — 원장 V-cfcd3347 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1164:129) |
| WK-DMF0003-0646 | D3 | M,M | 하네스·환경 | D3 도구 오류 — 원장 V-07ca623b |  | 1 (ACT:DMF0003_MktFcst.EditButton:1182:146) |
| WK-DMF0003-0647 | D3 | M,M | 하네스·환경 | D3 도구 오류 — 원장 V-6af15637 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2776:154) |
| WK-DMF0003-0648 | D3 | M,M | 하네스·환경 | D3 도구 오류 — 원장 V-75d4c341 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:939:104) |
| WK-DMF0003-0649 | D3 | M,M | 하네스·환경 | D3 도구 오류 — 원장 V-3e6b0f11 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:958:121) |
| WK-DMF0003-0650 | D3 | M,M | 하네스·환경 | D3 도구 오류 — 원장 V-cbfe83de |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1822:132) |
| WK-DMF0003-0651 | D3 | MDM_PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-1587ee70 ASIS / 원장 V-2f0e9b96 ASIS / 원장 V-8463daaa ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2041:102) |
| WK-DMF0003-0652 | D3 | MDM_PROJECT_NAME,MDM_PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-1587ee70 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2041:102) |
| WK-DMF0003-0653 | D3 | MDM_PROJECT_NAME,MDM_PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-2f0e9b96 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2733:120) |
| WK-DMF0003-0654 | D3 | MDM_PROJECT_NAME,MDM_PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-8463daaa |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1789:102) |
| WK-DMF0003-0655 | D3 | MIN_CAPACITY | 하네스·환경 | D3 도구 오류 — 원장 V-d8c533b2 ASIS / 원장 V-9a3b2871 ASIS / 원장 V-797bbb3b ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2043:104) |
| WK-DMF0003-0656 | D3 | MIN_CAPACITY,MIN_CAPACITY | 하네스·환경 | D3 도구 오류 — 원장 V-d8c533b2 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2043:104) |
| WK-DMF0003-0657 | D3 | MIN_CAPACITY,MIN_CAPACITY | 하네스·환경 | D3 도구 오류 — 원장 V-9a3b2871 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2735:122) |
| WK-DMF0003-0658 | D3 | MIN_CAPACITY,MIN_CAPACITY | 하네스·환경 | D3 도구 오류 — 원장 V-797bbb3b |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1791:104) |
| WK-DMF0003-0659 | D3 | N | 하네스·환경 | D3 도구 오류 — 원장 V-fe246f47 ASIS / 원장 V-b353fe2c ASIS / 원장 V-2359ec1e ASIS / 원장 V-a95deb70 ASIS / 원장 V-7019746f ASIS / 원장 V-b30ca865  |  | 1 (8. 콤보 호출지점) |
| WK-DMF0003-0660 | D3 | N,N | 하네스·환경 | D3 도구 오류 — 원장 V-f0b410d7 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1281:11) |
| WK-DMF0003-0661 | D3 | N,N | 하네스·환경 | D3 도구 오류 — 원장 V-c30fec7f |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2027:88) |
| WK-DMF0003-0662 | D3 | N,N | 하네스·환경 | D3 도구 오류 — 원장 V-d67f74db |  | 1 (ACT:DMF0003_MatsterChgPopup.FindData:368) |
| WK-DMF0003-0663 | D3 | N,N | 하네스·환경 | D3 도구 오류 — 원장 V-f2e50b8e |  | 1 (ACT:DMF0003_MatsterChgPopup.FindData:378) |
| WK-DMF0003-0664 | D3 | N,N | 하네스·환경 | D3 도구 오류 — 원장 V-32d39889 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1174:139) |
| WK-DMF0003-0665 | D3 | N,N | 하네스·환경 | D3 도구 오류 — 원장 V-6d3c7fea |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2719:106) |
| WK-DMF0003-0666 | D3 | N,N | 하네스·환경 | D3 도구 오류 — 원장 V-3ba00d4d |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:950:114) |
| WK-DMF0003-0667 | D3 | N,N | 하네스·환경 | D3 도구 오류 — 원장 V-daab0ac3 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1775:88) |
| WK-DMF0003-0668 | D3 | O,O | 하네스·환경 | D3 도구 오류 — 원장 V-a7579352 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1287:12) |
| WK-DMF0003-0669 | D3 | O,O | 하네스·환경 | D3 도구 오류 — 원장 V-e0ffd49e |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2035:96) |
| WK-DMF0003-0670 | D3 | O,O | 하네스·환경 | D3 도구 오류 — 원장 V-d4262f2e |  | 1 (ACT:DMF0003_MktFcst.EditButton:1180:145) |
| WK-DMF0003-0671 | D3 | O,O | 하네스·환경 | D3 도구 오류 — 원장 V-0a6b0691 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2727:114) |
| WK-DMF0003-0672 | D3 | O,O | 하네스·환경 | D3 도구 오류 — 원장 V-b4ac837a |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:956:120) |
| WK-DMF0003-0673 | D3 | O,O | 하네스·환경 | D3 도구 오류 — 원장 V-6c15e79b |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1783:96) |
| WK-DMF0003-0674 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-dc390b61 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1252:86) |
| WK-DMF0003-0675 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-c9669037 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1254:88) |
| WK-DMF0003-0676 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-c7ccd43b |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1256:90) |
| WK-DMF0003-0677 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-7bdbd6d0 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1283:11) |
| WK-DMF0003-0678 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-9193addf |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2019:80) |
| WK-DMF0003-0679 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-d53c6ae6 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2021:82) |
| WK-DMF0003-0680 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-2dc69a1b |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2023:84) |
| WK-DMF0003-0681 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-8ebc3c14 |  | 1 (ACT:DMF0003_1_MktFcst.spdMain_ComboSelCh) |
| WK-DMF0003-0682 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-0a9160b8 |  | 1 (ACT:DMF0003_1_MktFcst.spdMain_ComboSelCh) |
| WK-DMF0003-0683 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-39c2d781 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1146:111) |
| WK-DMF0003-0684 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-926ff93d |  | 1 (ACT:DMF0003_MktFcst.EditButton:1148:113) |
| WK-DMF0003-0685 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-584e0413 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1150:115) |
| WK-DMF0003-0686 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-b5c0ad21 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1176:141) |
| WK-DMF0003-0687 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-730de1b9 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2711:98) |
| WK-DMF0003-0688 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-2110536c |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2713:100) |
| WK-DMF0003-0689 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-89ac8b6d |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2715:102) |
| WK-DMF0003-0690 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-ed9fec71 |  | 1 (ACT:DMF0003_MktFcst.spdMain_ComboSelChan) |
| WK-DMF0003-0691 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-36410e7c |  | 1 (ACT:DMF0003_MktFcst.spdMain_ComboSelChan) |
| WK-DMF0003-0692 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-7dd150df |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:921:86) |
| WK-DMF0003-0693 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-f7cf66a3 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:923:88) |
| WK-DMF0003-0694 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-af52d789 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:925:90) |
| WK-DMF0003-0695 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-0cb8eb0f |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:952:116) |
| WK-DMF0003-0696 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-00a09a36 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1767:80) |
| WK-DMF0003-0697 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-1b4734bc |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1769:82) |
| WK-DMF0003-0698 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-4e171cab |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1771:84) |
| WK-DMF0003-0699 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-0c98dbb9 |  | 1 (ACT:DMF0003_T_MktFcst.spdMain_ComboSelCh) |
| WK-DMF0003-0700 | D3 | P,P | 하네스·환경 | D3 도구 오류 — 원장 V-7b68644b |  | 1 (ACT:DMF0003_T_MktFcst.spdMain_ComboSelCh) |
| WK-DMF0003-0701 | D3 | PROJECT_S_OP_REPORT | 하네스·환경 | D3 도구 오류 — 원장 V-e2707edd ASIS |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2766:150) |
| WK-DMF0003-0702 | D3 | PROJECT_S_OP_REPORT,PROJECT_S_OP_REPORT | 하네스·환경 | D3 도구 오류 — 원장 V-e2707edd |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2766:150) |
| WK-DMF0003-0703 | D3 | QTY,QTY | 하네스·환경 | D3 도구 오류 — 원장 V-12ebb440 |  | 1 (ACT:DMF0003_PRPopup.EditButton:284:10) |
| WK-DMF0003-0704 | D3 | ROUTE | 하네스·환경 | D3 도구 오류 — 원장 V-44a53f04 ASIS / 원장 V-d4931f4a ASIS / 원장 V-315aa4be ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2039:100) |
| WK-DMF0003-0705 | D3 | ROUTE,ROUTE | 하네스·환경 | D3 도구 오류 — 원장 V-44a53f04 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2039:100) |
| WK-DMF0003-0706 | D3 | ROUTE,ROUTE | 하네스·환경 | D3 도구 오류 — 원장 V-d4931f4a |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2731:118) |
| WK-DMF0003-0707 | D3 | ROUTE,ROUTE | 하네스·환경 | D3 도구 오류 — 원장 V-315aa4be |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1787:100) |
| WK-DMF0003-0708 | D3 | S | 하네스·환경 | D3 도구 오류 — 원장 V-e02c99cc ASIS / 원장 V-fe246f47 ASIS / 원장 V-b353fe2c ASIS / 원장 V-2359ec1e ASIS / 원장 V-a95deb70 ASIS / 원장 V-7019746f  |  | 17 (CB-04 행잠금: 좌측 상세컬럼 read-only (#8~27, #34) |
| WK-DMF0003-0709 | D3 | S,S | 하네스·환경 | D3 도구 오류 — 원장 V-16bbd632 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1248:84) |
| WK-DMF0003-0710 | D3 | S,S | 하네스·환경 | D3 도구 오류 — 원장 V-b96ff5de |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2013:74) |
| WK-DMF0003-0711 | D3 | S,S | 하네스·환경 | D3 도구 오류 — 원장 V-dc88aad2 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1142:109) |
| WK-DMF0003-0712 | D3 | S,S | 하네스·환경 | D3 도구 오류 — 원장 V-b0744595 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2705:92) |
| WK-DMF0003-0713 | D3 | S,S | 하네스·환경 | D3 도구 오류 — 원장 V-f225b76a |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:917:84) |
| WK-DMF0003-0714 | D3 | S,S | 하네스·환경 | D3 도구 오류 — 원장 V-f08f1944 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1761:74) |
| WK-DMF0003-0715 | D3 | SENDER_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-45ed9f11 ASIS / 원장 V-72c1306b ASIS / 원장 V-faf4ab4f ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2069:128) |
| WK-DMF0003-0716 | D3 | SENDER_CODE,SENDER_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-45ed9f11 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2069:128) |
| WK-DMF0003-0717 | D3 | SENDER_CODE,SENDER_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-72c1306b |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2759:146) |
| WK-DMF0003-0718 | D3 | SENDER_CODE,SENDER_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-faf4ab4f |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1817:128) |
| WK-DMF0003-0719 | D3 | SENDER_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-b993bc6f ASIS / 원장 V-eb2a75af ASIS / 원장 V-aa4cf0cf ASIS |  | 3 (ACT:DMF0003_1_MktFcst.InsertRow:2071:130) |
| WK-DMF0003-0720 | D3 | SENDER_NAME,SENDER_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-b993bc6f |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2071:130) |
| WK-DMF0003-0721 | D3 | SENDER_NAME,SENDER_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-eb2a75af |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2761:148) |
| WK-DMF0003-0722 | D3 | SENDER_NAME,SENDER_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-aa4cf0cf |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1819:130) |
| WK-DMF0003-0723 | D3 | SLOC,SLOC | 하네스·환경 | D3 도구 오류 — 원장 V-f9c6560e |  | 1 (ACT:DMF0003_PRPopup.EditButton:287:12) |
| WK-DMF0003-0724 | D3 | STORAGE_PLANT_ID,STORAGE_PLANT_ID | 하네스·환경 | D3 도구 오류 — 원장 V-f7d8d34a |  | 1 (ACT:DMF0003_PRPopup.EditButton:286:11) |
| WK-DMF0003-0725 | D3 | T,T | 하네스·환경 | D3 도구 오류 — 원장 V-59888984 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2780:156) |
| WK-DMF0003-0726 | D3 | T,T | 하네스·환경 | D3 도구 오류 — 원장 V-26bf0089 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2782:158) |
| WK-DMF0003-0727 | D3 | VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-d7d3b5b1 ASIS / 원장 V-49eee9e9 ASIS / 원장 V-87e9d4d4 ASIS / 원장 V-c5fe28bc ASIS / 원장 V-ec3359b9 ASIS / 원장 V-202e969e  |  | 9 (ACT:DMF0003_1_MktFcst.EditButton:1284:11) |
| WK-DMF0003-0728 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-d7d3b5b1 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1285:11) |
| WK-DMF0003-0729 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-49eee9e9 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2055:116) |
| WK-DMF0003-0730 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-87e9d4d4 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1178:143) |
| WK-DMF0003-0731 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-c5fe28bc |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2747:134) |
| WK-DMF0003-0732 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-ec3359b9 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:954:118) |
| WK-DMF0003-0733 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-202e969e |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1803:116) |
| WK-DMF0003-0734 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-fe246f47 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1067:28) |
| WK-DMF0003-0735 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-b353fe2c |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1070:29) |
| WK-DMF0003-0736 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-d2791862 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1077:32) |
| WK-DMF0003-0737 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-2359ec1e |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1094:40) |
| WK-DMF0003-0738 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-a95deb70 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1117:41) |
| WK-DMF0003-0739 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-73c6fd81 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1162:48) |
| WK-DMF0003-0740 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-7019746f |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1173:53) |
| WK-DMF0003-0741 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-b30ca865 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1184:60) |
| WK-DMF0003-0742 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-9246e2ba |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1189:61) |
| WK-DMF0003-0743 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-262143f7 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1202:66) |
| WK-DMF0003-0744 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-b914db02 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1209:71) |
| WK-DMF0003-0745 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-36cc166f |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1216:73) |
| WK-DMF0003-0746 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-e131c740 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1220:75) |
| WK-DMF0003-0747 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-eef42fc4 |  | 1 (ACT:DMF0003_MktFcst.EditButton:969:53) |
| WK-DMF0003-0748 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-570caa63 |  | 1 (ACT:DMF0003_MktFcst.EditButton:972:54) |
| WK-DMF0003-0749 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-601ad0f6 |  | 1 (ACT:DMF0003_MktFcst.EditButton:979:57) |
| WK-DMF0003-0750 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-8ea7b603 |  | 1 (ACT:DMF0003_MktFcst.EditButton:996:65) |
| WK-DMF0003-0751 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-a45cf7ca |  | 1 (ACT:DMF0003_MktFcst.EditButton:1015:66) |
| WK-DMF0003-0752 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-ff8fc653 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1056:73) |
| WK-DMF0003-0753 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-5cc00db3 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1067:78) |
| WK-DMF0003-0754 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-f3f70d4f |  | 1 (ACT:DMF0003_MktFcst.EditButton:1078:85) |
| WK-DMF0003-0755 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-4208921b |  | 1 (ACT:DMF0003_MktFcst.EditButton:1083:86) |
| WK-DMF0003-0756 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-e1ffe08b |  | 1 (ACT:DMF0003_MktFcst.EditButton:1096:91) |
| WK-DMF0003-0757 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-d751ede6 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1103:96) |
| WK-DMF0003-0758 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-7d454ee2 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1110:98) |
| WK-DMF0003-0759 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-130d5ee6 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1114:100) |
| WK-DMF0003-0760 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-0fbc4744 |  | 1 (ACT:DMF0003_PRPopup.EditButton:277:7) |
| WK-DMF0003-0761 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-635c1ae8 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:744:28) |
| WK-DMF0003-0762 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-3c21f451 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:747:29) |
| WK-DMF0003-0763 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-0f50b711 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:754:32) |
| WK-DMF0003-0764 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-4ea3cc38 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:771:40) |
| WK-DMF0003-0765 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-a2845e5d |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:790:41) |
| WK-DMF0003-0766 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-d94f914a |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:831:48) |
| WK-DMF0003-0767 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-21d378d2 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:842:53) |
| WK-DMF0003-0768 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-635e3fc3 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:853:60) |
| WK-DMF0003-0769 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-423c6ea9 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:858:61) |
| WK-DMF0003-0770 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-60513c78 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:871:66) |
| WK-DMF0003-0771 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-30a3d52f |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:878:71) |
| WK-DMF0003-0772 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-fbf917c0 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:885:73) |
| WK-DMF0003-0773 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-bb127f34 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:889:75) |
| WK-DMF0003-0774 | D3 | siMain.LockColumn2 | 하네스·환경 | D3 도구 오류 — 원장 V-0c4c2f3c |  | 1 (ACT:DMF0003_1_MktFcst.FindData:1548:55) |
| WK-DMF0003-0775 | D3 | siMain.LockColumn2 | 하네스·환경 | D3 도구 오류 — 원장 V-c3e4cd87 |  | 1 (ACT:DMF0003_MktFcst.Draw:1964:11) |
| WK-DMF0003-0776 | D3 | siMain.LockColumn2 | 하네스·환경 | D3 도구 오류 — 원장 V-915ea95f |  | 1 (ACT:DMF0003_T_MktFcst.FindData:1245:55) |
| WK-DMF0003-0777 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-133152e4 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1308:13) |
| WK-DMF0003-0778 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-86a9f4c2 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1343:14) |
| WK-DMF0003-0779 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-ce1cd2c4 |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1348:15) |
| WK-DMF0003-0780 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-d5f70cac |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1353:15) |
| WK-DMF0003-0781 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-625cb52f |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2099:146) |
| WK-DMF0003-0782 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-f4723303 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2138:163) |
| WK-DMF0003-0783 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-7e69335a |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2149:168) |
| WK-DMF0003-0784 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-6cdf8abb |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2169:169) |
| WK-DMF0003-0785 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-1bd6779f |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2211:176) |
| WK-DMF0003-0786 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-5715e58e |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2223:181) |
| WK-DMF0003-0787 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-18ad8a47 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2235:187) |
| WK-DMF0003-0788 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a3f93e4d |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2239:188) |
| WK-DMF0003-0789 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-661afcfa |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2252:193) |
| WK-DMF0003-0790 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-266b7220 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2258:197) |
| WK-DMF0003-0791 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-cb550c14 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2264:199) |
| WK-DMF0003-0792 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-4a610f27 |  | 1 (ACT:DMF0003_1_MktFcst.InsertRow:2268:201) |
| WK-DMF0003-0793 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-29e51e93 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1201:156) |
| WK-DMF0003-0794 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-ee05b17a |  | 1 (ACT:DMF0003_MktFcst.EditButton:1261:175) |
| WK-DMF0003-0795 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-df684fd8 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1266:178) |
| WK-DMF0003-0796 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-f068f538 |  | 1 (ACT:DMF0003_MktFcst.EditButton:1271:181) |
| WK-DMF0003-0797 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-f5ef4e2d |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2808:172) |
| WK-DMF0003-0798 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-529e8ca1 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2875:192) |
| WK-DMF0003-0799 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-de989b8a |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2886:197) |
| WK-DMF0003-0800 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-0fed9bf1 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2906:198) |
| WK-DMF0003-0801 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-bd6f610d |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2948:205) |
| WK-DMF0003-0802 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-bcccddb0 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2960:210) |
| WK-DMF0003-0803 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-104dd1ca |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2972:216) |
| WK-DMF0003-0804 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-2c5f6008 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2976:217) |
| WK-DMF0003-0805 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-86f2572f |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2989:222) |
| WK-DMF0003-0806 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-ac16584b |  | 1 (ACT:DMF0003_MktFcst.InsertRow:2995:226) |
| WK-DMF0003-0807 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a7841ae6 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:3001:228) |
| WK-DMF0003-0808 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-80192542 |  | 1 (ACT:DMF0003_MktFcst.InsertRow:3005:230) |
| WK-DMF0003-0809 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-ce5d3598 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:977:131) |
| WK-DMF0003-0810 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-2e9bcafb |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:1012:14) |
| WK-DMF0003-0811 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-3eaa14ed |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:1017:15) |
| WK-DMF0003-0812 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-85e6f102 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:1022:15) |
| WK-DMF0003-0813 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-abe85a5e |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1847:146) |
| WK-DMF0003-0814 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-70145bff |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1886:163) |
| WK-DMF0003-0815 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-93d35e00 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1897:168) |
| WK-DMF0003-0816 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-d92ce79f |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1917:169) |
| WK-DMF0003-0817 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-2046c2f3 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1959:176) |
| WK-DMF0003-0818 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a6998535 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1971:181) |
| WK-DMF0003-0819 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-92262a39 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1983:187) |
| WK-DMF0003-0820 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-f46c7b05 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:1987:188) |
| WK-DMF0003-0821 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-c11dc891 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:2000:193) |
| WK-DMF0003-0822 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-06fb9282 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:2006:197) |
| WK-DMF0003-0823 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-3d287f1e |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:2012:199) |
| WK-DMF0003-0824 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-79996ab8 |  | 1 (ACT:DMF0003_T_MktFcst.InsertRow:2016:201) |
| WK-DMF0003-0825 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-e02c99cc |  | 1 (ACT:DMF0003_1_MktFcst.EditButton:1048:18) |
| WK-DMF0003-0826 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-2b2292a8 |  | 1 (ACT:DMF0003_MktFcst.EditButton:948:42) |
| WK-DMF0003-0827 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-45e191cd |  | 1 (ACT:DMF0003_PRPopup.EditButton:275:6) |
| WK-DMF0003-0828 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-963e0463 |  | 1 (ACT:DMF0003_T_MktFcst.EditButton:725:18) |
| WK-DMF0003-0829 | D3 | siSub1.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-966eb005 |  | 1 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0830 | D3 | siSub1.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-f5c7de0c |  | 1 (ACT:DMF0003_1_MktFcst.spdSub1_CellClick:) |
| WK-DMF0003-0831 | D3 | siSub1.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-a98167bc |  | 1 (ACT:DMF0003_1_MktFcst.spdSub1_CellClick:) |
| WK-DMF0003-0832 | D3 | 행잠금: bucket×past 셀 잠금 (#28~33, #71~87) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 행잠금: bucket×past 셀 잠금 (#28~33, #71~87) '~23' 의 D3 337요소: ERROR:323 · NA:14 |  | 1 (행잠금: bucket×past 셀 잠금 (#28~33, #71~87)) |
| WK-DMF0003-0833 | E3 | 10 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 10 'SAVE p_authority 16번째 (L2421~2441)' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-DMF0003-0834 | E3 | 10/12/14 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 10/12/14 'L802/814/826' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (10/12/14) |
| WK-DMF0003-0835 | E3 | 106 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 106 'L4335' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (106) |
| WK-DMF0003-0836 | E3 | 130 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 130 'L5401' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (130) |
| WK-DMF0003-0837 | E3 | 15 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 15 'ValidationCheck' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (15) |
| WK-DMF0003-0838 | E3 | 16 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 16 'fnValidation' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (16) |
| WK-DMF0003-0839 | E3 | 26/27/28 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 26/27/28 'ExportExcel 사전검증(myarray/FrozenColumnCount)+MSG000' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (26/27/28) |
| WK-DMF0003-0840 | E3 | 30 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 30 'L1213' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (30) |
| WK-DMF0003-0841 | E3 | 31 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 31 'L1224' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (31) |
| WK-DMF0003-0842 | E3 | 32 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 32 'L1230' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (32) |
| WK-DMF0003-0843 | E3 | 36 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 36 'L1493' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (36) |
| WK-DMF0003-0844 | E3 | 37/43 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 37/43 'L1499/L1660' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (37/43) |
| WK-DMF0003-0845 | E3 | 4 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 4 'FCST_TYPE 편집 콤보 분기(L2587~2605) — W/S=EDIT_MODE 6종 ' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0003-0846 | E3 | 40 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 40 'L1569' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (40) |
| WK-DMF0003-0847 | E3 | 6 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 6 '공통 콤보 PARAM5 W/S 플래그 — GetSalesSite40(L7047~7066) ' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0003-0848 | E3 | 7 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 7 'SCP Planner 차단 — Edit 82·40(L828~834) / Insert 81(' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0003-0849 | E3 | 73 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 73 'MSG00472 FcstType 코드 검증' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (73) |
| WK-DMF0003-0850 | E3 | 95 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 95 'L3253' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (95) |
| WK-DMF0003-0851 | E3 | 99/122 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 99/122 'iWeeklySum<iWkSum_Sync / iValidation>1 (내부 분기)' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (99/122) |
| WK-DMF0003-0852 | E3 | CF-05 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 CF-05 '§6 저장 성공(Tables 없음) / MSG00004(건수) + 재조회 + viewpor' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (CF-05) |
| WK-DMF0003-0853 | E3 | CG-01 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 CG-01 '§7 수량 셀 수정 시 필수값 빈값 — Division/Project(81*·82)/End' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (CG-01) |
| WK-DMF0003-0854 | E3 | CH-01 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 CH-01 '§8 division 미선택 / MSG00097' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (CH-01) |
| WK-DMF0003-0855 | E3 | E04-5 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 E04-5 '§4.5 spdMain_KeyUp (L5636~5700) / EditChange (L648' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E04-5) |
| WK-DMF0003-0856 | E3 | E05-3 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 E05-3 '§5.3 화면 내 검증 메시지 전수 (활성 기준)' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E05-3) |
| WK-DMF0003-0857 | E3 | E07 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 E07 '§7 fnValidation (L5887~6273)' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E07) |
| WK-DMF0003-0858 | E3 | Grid입력 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 Grid입력 '1' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Grid입력) |
| WK-DMF0003-0859 | E3 | Validation | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 Validation '**152**' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Validation) |
| WK-DMF0003-0860 | E3 | `utils/mkt-fcst.validate.ts` | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 `utils/mkt-fcst.validate.ts` '신규' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`utils/mkt-fcst.validate.ts`) |
| WK-DMF0003-0861 | E3 | — | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 — '(저장대상 0)' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (—) |
| WK-DMF0003-0862 | E3 | 기타(사전검증분기) | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 기타(사전검증분기) '25' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (기타(사전검증분기)) |
| WK-DMF0003-0863 | E3 | 날짜기간 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 날짜기간 '2' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (날짜기간) |
| WK-DMF0003-0864 | E3 | 모드분기 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 모드분기 '1' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (모드분기) |
| WK-DMF0003-0865 | E3 | 사업부분기(40/81/82) | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 사업부분기(40/81/82) '113' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (사업부분기(40/81/82)) |
| WK-DMF0003-0866 | E3 | 숫자값검증 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 숫자값검증 '1' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (숫자값검증) |
| WK-DMF0003-0867 | E3 | 중복체크 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 중복체크 '3' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (중복체크) |
| WK-DMF0003-0868 | E3 | 필수값 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 필수값 '4' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (필수값) |
| WK-DMF0003-0869 | E3 | 확인메시지 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 확인메시지 '2' 의 E3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (확인메시지) |
| WK-DMF0003-0870 | G1 | clbTeam / Team | 하네스·환경 | G1 도구 오류 — 원장 V-3478aadf SEARCH |  | 11 (ACT:DMF0003_1_MktFcst.FindData ACT:DMF00) |
| WK-DMF0003-0871 | X-ROW | DMF0003_1_MktFcst.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0003_1_MktFcst.CreateSpread) |
| WK-DMF0003-0872 | X-ROW | DMF0003_1_MktFcst.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 58검사 — ERROR:44 · NA:12 · NOT_RUN:1 · PASS:1 |  | 11 (ACT:DMF0003_1_MktFcst.EditButton ACT:DMF) |
| WK-DMF0003-0873 | X-ROW | DMF0003_1_MktFcst.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 99검사 — ERROR:64 · NA:32 · PASS:3 |  | 203 (ACT:DMF0003_1_MktFcst.InsertRow ACT:DMF0) |
| WK-DMF0003-0874 | X-ROW | DMF0003_1_MktFcst.SetSaveDataRemove | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0003_1_MktFcst.SetSaveDataRemove) |
| WK-DMF0003-0875 | X-ROW | DMF0003_1_MktFcst.SetSaveSheetColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:3 · NOT_RUN:1 · ERROR:1 |  | 3 (ACT:DMF0003_1_MktFcst.SetSaveSheetColor ) |
| WK-DMF0003-0876 | X-ROW | DMF0003_1_MktFcst.SetSpreadColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — NA:15 · NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 15 (ACT:DMF0003_1_MktFcst.SetSpreadColumn AC) |
| WK-DMF0003-0877 | X-ROW | DMF0003_1_MktFcst.btnCalculation_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — NA:7 · NOT_RUN:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0003_1_MktFcst.btnCalculation_Cli) |
| WK-DMF0003-0878 | X-ROW | DMF0003_1_MktFcst.cboAS_CheckedChanged | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0003_1_MktFcst.cboAS_CheckedChang) |
| WK-DMF0003-0879 | X-ROW | DMF0003_1_MktFcst.cboBucketType_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — NA:8 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0003_1_MktFcst.cboBucketType_Sele) |
| WK-DMF0003-0880 | X-ROW | DMF0003_1_MktFcst.chkColor_CheckedChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0003_1_MktFcst.chkColor_CheckedCh) |
| WK-DMF0003-0881 | X-ROW | DMF0003_1_MktFcst.chkSum_CheckedChanged | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0003_1_MktFcst.chkSum_CheckedChan) |
| WK-DMF0003-0882 | X-ROW | DMF0003_1_MktFcst.clbCustomer_SelectedIn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0003_1_MktFcst.clbCustomer_Select) |
| WK-DMF0003-0883 | X-ROW | DMF0003_1_MktFcst.cmbCarMaker_SelectedIn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:3 · PASS:2 · NA:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0003_1_MktFcst.cmbCarMaker_Select) |
| WK-DMF0003-0884 | X-ROW | DMF0003_1_MktFcst.spdMain_CellDoubleClic | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 54검사 — NA:27 · PASS:8 · NOT_RUN:7 · ERROR:6 · NOPATH:4 · REVIEW:2 |  | 39 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0885 | X-ROW | DMF0003_1_MktFcst.spdMain_ComboSelChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 34검사 — NA:27 · PASS:5 · ERROR:2 |  | 36 (ACT:DMF0003_1_MktFcst.spdMain_ComboSelCh) |
| WK-DMF0003-0886 | X-ROW | DMF0003_1_MktFcst.spdSub1_CellClick | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 22검사 — NA:16 · ERROR:3 · PASS:2 · REVIEW:1 |  | 100 (ACT:DMF0003_1_MktFcst.spdSub1_CellClick ) |
| WK-DMF0003-0887 | X-ROW | DMF0003_1_MktFcst.txtMarketShare_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0003_1_MktFcst.txtMarketShare_Cli) |
| WK-DMF0003-0888 | X-ROW | DMF0003_1_MktFcst.txtMarketShare_KeyDown | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:DMF0003_1_MktFcst.txtMarketShare_Key) |
| WK-DMF0003-0889 | X-ROW | DMF0003_MatsterChgPopup.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 20검사 — PASS:8 · NA:7 · NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 31 (ACT:DMF0003_MatsterChgPopup.InitControls) |
| WK-DMF0003-0890 | X-ROW | DMF0003_MktFcst.Draw | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NA:4 · ERROR:1 · NOPATH:1 |  | 124 (ACT:DMF0003_MktFcst.Draw ACT:DMF0003_Mkt) |
| WK-DMF0003-0891 | X-ROW | DMF0003_MktFcst.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 73검사 — ERROR:46 · NA:26 · PASS:1 |  | 201 (ACT:DMF0003_MktFcst.EditButton:826:1 ACT) |
| WK-DMF0003-0892 | X-ROW | DMF0003_MktFcst.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — PASS:3 · NA:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:DMF0003_MktFcst.Form_Load:304:1 ACT:) |
| WK-DMF0003-0893 | X-ROW | DMF0003_MktFcst.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 124검사 — ERROR:70 · NA:43 · NOPATH:7 · PASS:4 |  | 232 (ACT:DMF0003_MktFcst.InsertRow ACT:DMF000) |
| WK-DMF0003-0894 | X-ROW | DMF0003_MktFcst.SetSaveSheetColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · ERROR:1 |  | 7 (ACT:DMF0003_MktFcst.SetSaveSheetColor AC) |
| WK-DMF0003-0895 | X-ROW | DMF0003_MktFcst.spdMain_ClipboardPasted | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 27검사 — NA:21 · ERROR:4 · NOPATH:2 |  | 45 (ACT:DMF0003_MktFcst.spdMain_ClipboardPas) |
| WK-DMF0003-0896 | X-ROW | DMF0003_MktFcst.spdMain_ComboSelChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 76검사 — NA:59 · ERROR:9 · PASS:6 · NOPATH:2 |  | 158 (ACT:DMF0003_MktFcst.spdMain_ComboSelChan) |
| WK-DMF0003-0897 | X-ROW | DMF0003_PRPopup.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 20검사 — NA:12 · ERROR:6 · NOT_RUN:1 · PASS:1 |  | 16 (ACT:DMF0003_PRPopup.EditButton:253:1 ACT) |
| WK-DMF0003-0898 | X-ROW | DMF0003_T_MktFcst.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 57검사 — ERROR:43 · NA:13 · PASS:1 |  | 172 (ACT:DMF0003_T_MktFcst.EditButton ACT:DMF) |
| WK-DMF0003-0899 | X-ROW | DMF0003_T_MktFcst.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — PASS:3 · NA:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0003_T_MktFcst.Form_Load:254:1 AC) |
| WK-DMF0003-0900 | X-ROW | DMF0003_T_MktFcst.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 100검사 — ERROR:64 · NA:33 · PASS:3 |  | 203 (ACT:DMF0003_T_MktFcst.InsertRow ACT:DMF0) |
| WK-DMF0003-0901 | X-ROW | DMF0003_T_MktFcst.SetSaveSheetColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · ERROR:1 |  | 7 (ACT:DMF0003_T_MktFcst.SetSaveSheetColor ) |
| WK-DMF0003-0902 | X-ROW | DMF0003_T_MktFcst.spdMain_ComboSelChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 32검사 — NA:25 · PASS:5 · ERROR:2 |  | 95 (ACT:DMF0003_T_MktFcst.spdMain_ComboSelCh) |
| WK-DMF0003-0903 | M4 | 13 | 하네스·환경 | M4 도구 오류 — 실측[T-3886d727]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (13) |
| WK-DMF0003-0904 | M4 | 2 | 하네스·환경 | M4 도구 오류 — 실측[T-df7ac738]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (2) |
| WK-DMF0003-0905 | M4 | C | 하네스·환경 | M4 도구 오류 — 실측[T-ceb71894]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (C-119 HANDLER:spdMain_KeyUp) |
| WK-DMF0003-0906 | M4 | CF-05 | 하네스·환경 | M4 도구 오류 — 실측[T-1e579633]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (CF-05) |
| WK-DMF0003-0907 | M4 | CF-06 | 하네스·환경 | M4 도구 오류 — 실측[T-886806bb]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (CF-06) |
| WK-DMF0003-0908 | M4 | CH-102 | 하네스·환경 | M4 도구 오류 — 실측[T-993ac48a]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (CH-102) |
| WK-DMF0003-0909 | M4 | CH-103 | 하네스·환경 | M4 도구 오류 — 실측[T-3393430d]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (CH-103) |
| WK-DMF0003-0910 | M4 | CH-105 | 하네스·환경 | M4 도구 오류 — 실측[T-ef68876f]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (CH-105) |
| WK-DMF0003-0911 | M4 | CH-108 | 하네스·환경 | M4 도구 오류 — 실측[T-1a494435]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (CH-108) |
| WK-DMF0003-0912 | M4 | CK-05 | 하네스·환경 | M4 도구 오류 — 실측[T-3bc174bd]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (CK-05) |
| WK-DMF0003-0913 | M4 | CK-11 | 하네스·환경 | M4 도구 오류 — 실측[T-898c7c30]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (CK-11) |
| WK-DMF0003-0914 | M4 | DMF0003_1_MktFcst.spdMain_CellDoubleClic | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 DMF0003_1_MktFcst.spdMain_CellDoubleClick 의 M4 8요소: NOT_RUN:4 · ERROR:4 |  | 179 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0915 | M4 | E04-4 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 E04-4 '§4.4 spdMain_CellDoubleClick (L3604~3942)' 의 M4 23요소: ERROR:13 · NOT_RUN:10 |  | 1 (E04-4) |
| WK-DMF0003-0916 | M4 | E04-5 | 하네스·환경 | M4 도구 오류 — 실측[T-6ff008c7]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (E04-5) |
| WK-DMF0003-0917 | M4 | E06 | 하네스·환경 | M4 도구 오류 — 실측[T-2b273d39]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (E06) |
| WK-DMF0003-0918 | M4 | GAP / GAP (ⓒ-ⓓ | 하네스·환경 | M4 도구 오류 — 실측[T-ac910c47]: [검사기 미검증] GAP: P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 5 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0919 | M4 | I | 하네스·환경 | M4 도구 오류 — 실측[T-b98120bf]: [검사기 미검증] I: P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (CG-05) |
| WK-DMF0003-0920 | M4 | M | 하네스·환경 | M4 도구 오류 — 실측[T-4bfadbee]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (MODAL:MeasureSelectModal) |
| WK-DMF0003-0921 | M4 | MKT_DP / ⓓMKT FCST(DP | 하네스·환경 | M4 도구 오류 — 실측[T-4e6a1c42]: [검사기 미검증] MKT_DP: P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0922 | M4 | N | 하네스·환경 | M4 도구 오류 — 실측[T-15ae852c]: [검사기 미검증] N: P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 3 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0923 | M4 | Popup | 하네스·환경 | M4 도구 오류 — 실측[T-1a262ebb]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (Popup) |
| WK-DMF0003-0924 | M4 | RESULT / ⓒResult (ⓐ+ⓑ | 하네스·환경 | M4 도구 오류 — 실측[T-f5510b1a]: [검사기 미검증] RESULT: P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 3 (ACT:DMF0003_1_MktFcst.spdMain_CellDouble) |
| WK-DMF0003-0925 | M4 | btnColumn | 하네스·환경 | M4 도구 오류 — 실측[T-8428ba37]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 0 () |
| WK-DMF0003-0926 | M4 | btnIncotermsChg | 하네스·환경 | M4 도구 오류 — 실측[T-1357a08d]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 0 () |
| WK-DMF0003-0927 | M4 | btnItemId | 하네스·환경 | M4 도구 오류 — 실측[T-f587be53]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 0 () |
| WK-DMF0003-0928 | M4 | btnMeasure | 하네스·환경 | M4 도구 오류 — 실측[T-d70926d8]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 0 () |
| WK-DMF0003-0929 | M4 | btnOwner | 하네스·환경 | M4 도구 오류 — 실측[T-74d236e2]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 0 () |
| WK-DMF0003-0930 | M4 | btnProject | 하네스·환경 | M4 도구 오류 — 실측[T-15cb1ca6]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 0 () |

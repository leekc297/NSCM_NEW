# 작업 원장 — SCP0122 · 2026-11-08 22:09

> 검사 인스턴스 283건 중 PASS·NA 239건 외 **44건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W5 | 검사기 연결 | 6 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 18 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 19 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 19 · 사람 판정 / AS-IS 원문 확인 → 재판정 15 · 하네스 6 · 대조표 3 · DB 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A1 | GEN |  |  |  |  |  |  | 12 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-ROW | GEN |  |  |  |  |  |  | 3 |  | 6 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 9 | 연쇄 자동 채움 |
| X-REASON | DESIGN |  |  |  |  |  |  | 3 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B4 | COMBO |  |  |  |  | 2 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |
| B1 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 중복 없음 |
| B3 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| E5 | EDIT |  |  |  |  | 1 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0122-0001 | F1 | SCP0122 화면 | DB(🛠️/🧯 적용 가능) | F1 FAIL 수정 — SCP0122 화면: 원장 V-aeb64a23 RULE_SCREEN / 원장 V-1d783c8b RULE_SCREEN / 원장 V-d6b2ad6b RULE_SCREEN / 원장 V-561acd2b RULE_SC |  | 13 (`DeleteButton`→`siMain.Delete` `Save_Dat) |

## W5 검사기 연결 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0122-0002 | B1 | OPMZ_ACTV_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL OPMZ_ACTV_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0122-0003 | B2 | OPMZ_ACTV_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL OPMZ_ACTV_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0122-0004 | B3 | OPMZ_PRS_CD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL OPMZ_PRS_CD | 있음(SHEET_COLUMNS) | 1 (`Data.Common(LookupCommon,false,"OPMZ_PR) |
| WK-SCP0122-0005 | B4 | OPMZ_ACTV_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPMZ_ACTV_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0122-0006 | B4 | OPMZ_PRS_CD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPMZ_PRS_CD | 있음(SHEET_COLUMNS) | 1 (`Data.Common(LookupCommon,false,"OPMZ_PR) |
| WK-SCP0122-0007 | E5 | OPMZ_ACTV_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL OPMZ_ACTV_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |

## W7 기대값 확정 (18)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0122-0008 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 - Column/Measure 설정 버튼 없음(SCP0122 Measure 0건,  |  | 1 (COMMON:UC-03) |
| WK-SCP0122-0009 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 콤마 구분 다중 입력 시 전건 조회 - 조회조건 3콤보(Division/PlanGroup/Process)만 — 자유 key-in 콤마 다중검색 텍스트 필드 |  | 1 (COMMON:UC-06) |
| WK-SCP0122-0010 | X-REASON | `prsCd`(GET) = `CString.GetCheckedListVa | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `prsCd`(GET) = `CString.GetCheckedListValue(dtPlanGroup, cboProcess.SelectedValue)` cs:310 AS-IS 오타 인자(dtPlanGr |  | 1 (`prsCd`(GET) = `CString.GetCheckedListVa) |
| WK-SCP0122-0011 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회 시 조회되고 필터도 그대로 적용(rebindFilterColumns' 의 A1 1요소: REVIEW:1 · FAIL 요 |  | 1 (COMMON:UC-07) |
| WK-SCP0122-0012 | A1 | MSG00097 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MSG00097: 행 집계 — 대조표 MSG00097 '권한 Division 없음' 의 A1 1요소: REVIEW:1 · FAIL 요소: PKG_SCP0122.P_SCP0122_GET_PLAN — golden S |  | 1 (MSG00097) |
| WK-SCP0122-0013 | A1 | PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_MGMT: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0122/SCP0122_GET_PLAN_A |  | 34 (ACT:SCP0122_PlanActivityMgmt.FindButton ) |
| WK-SCP0122-0014 | A1 | `BLUtils.GetDivision(false,"")` → `Divis | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `BLUtils.GetDivision(false,"")` → `Division_SCP`: 행 집계 — 대조표 `BLUtils.GetDivision(false,"")` → `Division_SCP` 'cs:40,1 |  | 1 (`BLUtils.GetDivision(false,"")` → `Divis) |
| WK-SCP0122-0015 | A1 | `CboPlanGroup_SelectedIndexChanged`→`Cle | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `CboPlanGroup_SelectedIndexChanged`→`ClearDataSour: 행 집계 — 대조표 `CboPlanGroup_SelectedIndexChanged`→`ClearDataSource` ' |  | 1 (`CboPlanGroup_SelectedIndexChanged`→`Cle) |
| WK-SCP0122-0016 | A1 | `ClbDivision_SelectedIndexChanged`→`Refr | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `ClbDivision_SelectedIndexChanged`→`RefreshPlanGro: 행 집계 — 대조표 `ClbDivision_SelectedIndexChanged`→`RefreshPlanGroupByD |  | 1 (`ClbDivision_SelectedIndexChanged`→`Refr) |
| WK-SCP0122-0017 | A1 | `Data.Common(LookupCommon,false,"OPMZ_PR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `Data.Common(LookupCommon,false,"OPMZ_PRS_CD")`: 행 집계 — 대조표 `Data.Common(LookupCommon,false,"OPMZ_PRS_CD")` 'cs:47,127 |  | 1 (`Data.Common(LookupCommon,false,"OPMZ_PR) |
| WK-SCP0122-0018 | A1 | `GetPlanGroupByUserID()` Tables[3] → `Pl | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `GetPlanGroupByUserID()` Tables[3] → `PlanGroup_SC: 행 집계 — 대조표 `GetPlanGroupByUserID()` Tables[3] → `PlanGroup_SCP_ALL |  | 1 (`GetPlanGroupByUserID()` Tables[3] → `Pl) |
| WK-SCP0122-0019 | A1 | `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `LockColumn(0,MaxCol,true)` 조회직후 전체잠금: 행 집계 — 대조표 `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 'cs:342' 의 A1 1요소: REVIEW:1 ·  |  | 1 (`LockColumn(0,MaxCol,true)` 조회직후 전체잠금) |
| WK-SCP0122-0020 | A1 | `RefreshPlanGroupByDivision` DIVISION_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `RefreshPlanGroupByDivision` DIVISION_ID='' 필터 → 후: 행 집계 — 대조표 `RefreshPlanGroupByDivision` DIVISION_ID='' 필터 → 후보 0 ' |  | 1 (`RefreshPlanGroupByDivision` DIVISION_ID) |
| WK-SCP0122-0021 | A1 | `SetDivisionAuthCheck`(`dtMyDivision.Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `SetDivisionAuthCheck`(`dtMyDivision.Rows.Count==0: 행 집계 — 대조표 `SetDivisionAuthCheck`(`dtMyDivision.Rows.Count==0`, `u |  | 1 (`SetDivisionAuthCheck`(`dtMyDivision.Row) |
| WK-SCP0122-0022 | A1 | 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00443: 행 집계 — 대조표 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00443 'cs:453' 의 A1 1요소: |  | 1 (중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00) |
| WK-SCP0122-0023 | X-ROW | SCP0122_PlanActivityMgmt.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.FindButton: 진입점 집계 3검사 — PASS:2 · REVIEW:1 |  | 1 (ACT:SCP0122_PlanActivityMgmt.FindButton) |
| WK-SCP0122-0024 | X-ROW | SCP0122_PlanActivityMgmt.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.FindData_Main: 진입점 집계 10검사 — PASS:7 · NA:2 · REVIEW:1 |  | 7 (ACT:SCP0122_PlanActivityMgmt.FindData_Ma) |
| WK-SCP0122-0025 | X-ROW | SCP0122_PlanActivityMgmt.spdMain_CellCli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.spdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0122_PlanActivityMgmt.spdMain_Cel) |

## W9 도구 오류 (19)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0122-0026 | C3 | AUTO_YN | 하네스·환경 | C3 도구 오류 — 원장 V-500cf5a2 ASIS / 실측[T-5c47cc13]: 신규행 연쇄 OPMZ_ACTV_NAME → AUTO_YN: OPMZ_ACTV_NAME='Master Validation' → AUTO_YN=' '  |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0027 | C3 | AUTO_YN,AUTO_YN | 하네스·환경 | C3 도구 오류 — 원장 V-500cf5a2 |  | 1 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0028 | C3 | OPMZ_ACTV_NAME | 하네스·환경 | C3 도구 오류 — 원장 V-ea47bd85 ASIS / 원장 V-f7e600f1 ASIS / 원장 V-e04d2a4f ASIS / 원장 V-c36d9de8 ASIS / 원장 V-500cf5a2 ASIS / 원장 V-b00190a9  |  | 11 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0029 | C3 | PROGRAM_NAME | 하네스·환경 | C3 도구 오류 — 원장 V-e04d2a4f ASIS / 실측[T-5d81418a]: 신규행 연쇄 OPMZ_ACTV_NAME → PROGRAM_NAME: OPMZ_ACTV_NAME='Master Validation' → PROGRAM |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0030 | C3 | PROGRAM_NAME,PROGRAM_NAME | 하네스·환경 | C3 도구 오류 — 원장 V-e04d2a4f |  | 1 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0031 | C3 | SCP0122_PlanActivityMgmt.ClbDivision_Sel | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0122_PlanActivityMgmt.ClbDivision_SelectedIndexChanged 의 C3 14요소: PASS:8 · ERROR:5 · NA:1 |  | 1 (ACT:SCP0122_PlanActivityMgmt.ClbDivision) |
| WK-SCP0122-0032 | C3 | SCP0122_PlanActivityMgmt.SetChangedContr | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0122_PlanActivityMgmt.SetChangedControl 의 C3 14요소: PASS:8 · ERROR:5 · NA:1 |  | 1 (ACT:SCP0122_PlanActivityMgmt.SetChangedC) |
| WK-SCP0122-0033 | C3 | SCP0122_PlanActivityMgmt.SetSpreadInit | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0122_PlanActivityMgmt.SetSpreadInit 의 C3 14요소: PASS:8 · ERROR:5 · NA:1 |  | 4 (ACT:SCP0122_PlanActivityMgmt.SetSpreadIn) |
| WK-SCP0122-0034 | C3 | SCP0122_PlanActivityMgmt.SpdMain_ComboSe | 하네스·환경 | C3 도구 오류 — 원장 V-ea47bd85 ASIS / 원장 V-f7e600f1 ASIS / 원장 V-e04d2a4f ASIS / 원장 V-c36d9de8 ASIS / 원장 V-500cf5a2 ASIS / 원장 V-b00190a9  |  | 1 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0035 | F2 | SCP0122 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-e7eb2e22 RULE_SCREEN / 원장 V-0641830f RULE_SCREEN / 원장 V-4c4d17d8 RULE_SCREEN / 원장 V-b3b1e001 GENERAL / 원장 V-2688b6 |  | 7 (`Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세) |
| WK-SCP0122-0036 | F6 | SCP0122 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-c349a23c RULE_SCREEN / 원장 V-b039b9f2 RULE_SCREEN / 원장 V-085b90b1 RULE_SCREEN / 원장 V-1bf41900 RULE_SCREEN / 원장 V-08 |  | 4 (ACT:SCP0122_PlanActivityMgmt.SaveButton ) |
| WK-SCP0122-0037 | H10 | SCP0122 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 10 (`SetDivisionAuthCheck`(`dtMyDivision.Row) |
| WK-SCP0122-0038 | I1 | SCP0122 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-2faa8d6b RULE_SCREEN / 원장 V-97a0630a RULE_SCREEN / 원장 V-6d26be32 RULE_SCREEN / 원장 V-131c2337 DEFECT / 원장 V-bb62113 |  | 13 (`SetDivisionAuthCheck`(`dtMyDivision.Row) |
| WK-SCP0122-0039 | X-ROW | SCP0122_PlanActivityMgmt.ClbDivision_Sel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.ClbDivision) |
| WK-SCP0122-0040 | X-ROW | SCP0122_PlanActivityMgmt.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.CreateSprea) |
| WK-SCP0122-0041 | X-ROW | SCP0122_PlanActivityMgmt.Save_Data | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — NA:7 · PASS:6 · ERROR:1 |  | 82 (ACT:SCP0122_PlanActivityMgmt.Save_Data A) |
| WK-SCP0122-0042 | X-ROW | SCP0122_PlanActivityMgmt.SetChangedContr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.SetChangedC) |
| WK-SCP0122-0043 | X-ROW | SCP0122_PlanActivityMgmt.SetSpreadInit | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:4 · PASS:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0122_PlanActivityMgmt.SetSpreadIn) |
| WK-SCP0122-0044 | X-ROW | SCP0122_PlanActivityMgmt.SpdMain_ComboSe | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 36검사 — PASS:22 · NA:8 · ERROR:6 |  | 6 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |

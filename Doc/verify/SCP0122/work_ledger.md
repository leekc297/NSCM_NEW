# 작업 원장 — SCP0122 · 2026-11-14 18:23

> 검사 인스턴스 283건 중 PASS·NA 241건 외 **42건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W7 | 기대값 확정 | 4 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 37 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 37 · 대조표 3 · 화면 FE 1 · 사람 판정 / AS-IS 원문 확인 → 재판정 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 1 |  | 9 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 9 | 그리드 셀 cascade 후보 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 9 | 연쇄 자동 채움 |
| X-REASON | DESIGN |  |  |  |  |  |  | 3 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| C1 | CASCADE |  |  |  |  |  |  |  |  | 3 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| F4 | DB |  |  |  |  |  |  |  |  | 1 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0122-0001 | F5 | SCP0122 화면 | 화면 FE(범위 밖(가이드만)) | F5 FAIL 수정 — SCP0122 화면: 원장 V-b2ab9f0a RULE_SCREEN / 원장 V-17ff72e9 RULE_SCREEN / 원장 V-eae7d9ad RULE_SCREEN / 원장 V-7bbebad7 DEFECT  |  | 7 (`DeleteButton`→`siMain.Delete` `Save_Dat) |

## W7 기대값 확정 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0122-0002 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 - Column/Measure 설정 버튼 없음(SCP0122 Measure 0건,  |  | 1 (COMMON:UC-03) |
| WK-SCP0122-0003 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 콤마 구분 다중 입력 시 전건 조회 - 조회조건 3콤보(Division/PlanGroup/Process)만 — 자유 key-in 콤마 다중검색 텍스트 필드 |  | 1 (COMMON:UC-06) |
| WK-SCP0122-0004 | X-REASON | `prsCd`(GET) = `CString.GetCheckedListVa | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `prsCd`(GET) = `CString.GetCheckedListValue(dtPlanGroup, cboProcess.SelectedValue)` cs:310 AS-IS 오타 인자(dtPlanGr |  | 1 (`prsCd`(GET) = `CString.GetCheckedListVa) |
| WK-SCP0122-0005 | X-ROW | SCP0122_PlanActivityMgmt.spdMain_CellCli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.spdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0122_PlanActivityMgmt.spdMain_Cel) |

## W9 도구 오류 (37)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0122-0006 | C1 | `ClbDivision_SelectedIndexChanged`→`Refr | 하네스·환경 | C1 도구 오류 — 실측[T-3bfb2186]: 행 `ClbDivision_SelectedIndexChanged`→`RefreshPlanGroupByDivisi() = 조회조건 C1 실측 상속: 'Div' → '40 Mobility  |  | 1 (`ClbDivision_SelectedIndexChanged`→`Refr) |
| WK-SCP0122-0007 | C1 | cboDivision / Division / Div / Div. | 하네스·환경 | C1 도구 오류 — 원장 V-37a5b07b SEARCH / 실측[T-3c596e73]: 'Div' → '40 Mobility & IT Battery' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 ClbDivis |  | 1 (ACT:SCP0122_PlanActivityMgmt.InitControl) |
| WK-SCP0122-0008 | C1 | cboPlanGroup / Plan Group | 하네스·환경 | C1 도구 오류 — 실측[T-ee24f291]: 'Plan Group' → 'E72B' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 CboPlanGroup_SelectedIndexChanged · AS-IS 하위 |  | 1 (ACT:SCP0122_PlanActivityMgmt.RefreshPlan) |
| WK-SCP0122-0009 | C2 | AUTO_YN / Auto Flag | 하네스·환경 | C2 도구 오류 — 실측[T-3d19f6a9]: AUTO_YN 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0010 | C2 | CONFIRM_YN / Confirm Flag | 하네스·환경 | C2 도구 오류 — 실측[T-58cf3c02]: CONFIRM_YN 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0011 | C2 | LINK_UI_TYPE / Link UI Type | 하네스·환경 | C2 도구 오류 — 실측[T-a21662da]: LINK_UI_TYPE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0012 | C2 | OPMZ_ACTV_CD / Activity Code | 하네스·환경 | C2 도구 오류 — 실측[T-f2ceeba6]: OPMZ_ACTV_CD 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (Auto-Sync `SetValue` OPMZ_ACTV_CD+5속성 AC) |
| WK-SCP0122-0013 | C2 | OPMZ_ACTV_NAME / Activity Name | 하네스·환경 | C2 도구 오류 — 실측[T-32156746]: OPMZ_ACTV_NAME 연쇄 원천 해석 불가 — AS-IS SpdMain_ComboSelChange:229 siMain.GetColumnIndex(DefColumns.OPMZ_ACT |  | 11 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0014 | C2 | OPTION_YN / Option Flag | 하네스·환경 | C2 도구 오류 — 실측[T-591ee6b6]: OPTION_YN 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0015 | C2 | PROGRAM_NAME / Program Name | 하네스·환경 | C2 도구 오류 — 실측[T-05c8a62c]: PROGRAM_NAME 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0016 | C2 | SCP0122_PlanActivityMgmt.ClbDivision_Sel | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0122_PlanActivityMgmt.ClbDivision_SelectedIndexChanged 의 C2 7요소: ERROR:7 |  | 1 (ACT:SCP0122_PlanActivityMgmt.ClbDivision) |
| WK-SCP0122-0017 | C2 | SCP0122_PlanActivityMgmt.SpdMain_ComboSe | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0122_PlanActivityMgmt.SpdMain_ComboSelChange 의 C2 7요소: ERROR:7 |  | 1 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0018 | C3 | AUTO_YN / Auto Flag | 하네스·환경 | C3 도구 오류 — 원장 V-500cf5a2 ASIS / 실측[T-5c47cc13]: 신규행 연쇄 OPMZ_ACTV_NAME → AUTO_YN: OPMZ_ACTV_NAME='Master Validation' → AUTO_YN=' '  |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0019 | C3 | AUTO_YN,AUTO_YN | 하네스·환경 | C3 도구 오류 — 원장 V-500cf5a2 |  | 1 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0020 | C3 | OPMZ_ACTV_NAME / Activity Name | 하네스·환경 | C3 도구 오류 — 원장 V-ea47bd85 ASIS / 원장 V-f7e600f1 ASIS / 원장 V-e04d2a4f ASIS / 원장 V-c36d9de8 ASIS / 원장 V-500cf5a2 ASIS / 원장 V-b00190a9  |  | 11 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0021 | C3 | PROGRAM_NAME / Program Name | 하네스·환경 | C3 도구 오류 — 원장 V-e04d2a4f ASIS / 실측[T-5d81418a]: 신규행 연쇄 OPMZ_ACTV_NAME → PROGRAM_NAME: OPMZ_ACTV_NAME='Master Validation' → PROGRAM |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0022 | C3 | PROGRAM_NAME,PROGRAM_NAME | 하네스·환경 | C3 도구 오류 — 원장 V-e04d2a4f |  | 1 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0023 | C3 | SCP0122_PlanActivityMgmt.ClbDivision_Sel | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0122_PlanActivityMgmt.ClbDivision_SelectedIndexChanged 의 C3 14요소: PASS:8 · ERROR:5 · NA:1 |  | 1 (ACT:SCP0122_PlanActivityMgmt.ClbDivision) |
| WK-SCP0122-0024 | C3 | SCP0122_PlanActivityMgmt.SetChangedContr | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0122_PlanActivityMgmt.SetChangedControl 의 C3 14요소: PASS:8 · ERROR:5 · NA:1 |  | 1 (ACT:SCP0122_PlanActivityMgmt.SetChangedC) |
| WK-SCP0122-0025 | C3 | SCP0122_PlanActivityMgmt.SetSpreadInit | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0122_PlanActivityMgmt.SetSpreadInit 의 C3 14요소: PASS:8 · ERROR:5 · NA:1 |  | 4 (ACT:SCP0122_PlanActivityMgmt.SetSpreadIn) |
| WK-SCP0122-0026 | C3 | SCP0122_PlanActivityMgmt.SpdMain_ComboSe | 하네스·환경 | C3 도구 오류 — 원장 V-ea47bd85 ASIS / 원장 V-f7e600f1 ASIS / 원장 V-e04d2a4f ASIS / 원장 V-c36d9de8 ASIS / 원장 V-500cf5a2 ASIS / 원장 V-b00190a9  |  | 1 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0027 | K4 | SCP0122 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-c01ccef9 GENERAL / 원장 V-7457c63b GENERAL / 원장 V-422e0d5a GENERAL / 원장 V-2194a72d GENERAL / 원장 V-12147997 GENERAL / |  | 3 (COMMON:UC-04 COMMON:UC-05 COMMON:UC-07) |
| WK-SCP0122-0028 | F1 | SCP0122 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-aeb64a23 RULE_SCREEN / 원장 V-1d783c8b RULE_SCREEN / 원장 V-d6b2ad6b RULE_SCREEN / 원장 V-561acd2b RULE_SCREEN / 원장 V-06 |  | 13 (`DeleteButton`→`siMain.Delete` `Save_Dat) |
| WK-SCP0122-0029 | F2 | SCP0122 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-e7eb2e22 RULE_SCREEN / 원장 V-4c4d17d8 RULE_SCREEN / 원장 V-b3b1e001 GENERAL / 원장 V-2688b660 GENERAL / 원장 V-ced6f5c2 G |  | 7 (`Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세) |
| WK-SCP0122-0030 | F6 | SCP0122 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-c349a23c RULE_SCREEN / 원장 V-b039b9f2 RULE_SCREEN / 원장 V-085b90b1 RULE_SCREEN / 원장 V-1bf41900 RULE_SCREEN / 원장 V-08 |  | 4 (ACT:SCP0122_PlanActivityMgmt.SaveButton ) |
| WK-SCP0122-0031 | F4 | PKG_COM0000.P_SCP0121_GET_SEARCH_INFO | 하네스·환경 | F4 도구 오류 — 실측[T-d57b7cbe]: PKG_COM0000.P_SCP0121_GET_SEARCH_INFO: SCP0121/searchInfo/SEARCH, SCP0123/searchInfo/SEARCH, SCP0124/se |  | 2 (ACT:SCP0122_PlanActivityMgmt.GetPlanGrou) |
| WK-SCP0122-0032 | H10 | SCP0122 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 10 (`SetDivisionAuthCheck`(`dtMyDivision.Row) |
| WK-SCP0122-0033 | I1 | SCP0122 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-2faa8d6b RULE_SCREEN / 원장 V-97a0630a RULE_SCREEN / 원장 V-6d26be32 RULE_SCREEN / 원장 V-131c2337 DEFECT / 원장 V-bb62113 |  | 13 (`SetDivisionAuthCheck`(`dtMyDivision.Row) |
| WK-SCP0122-0034 | X-ROW | SCP0122_PlanActivityMgmt.ClbDivision_Sel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.ClbDivision) |
| WK-SCP0122-0035 | X-ROW | SCP0122_PlanActivityMgmt.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.CreateSprea) |
| WK-SCP0122-0036 | X-ROW | SCP0122_PlanActivityMgmt.GetPlanGroupByU | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — PASS:2 · NOPATH:2 · ERROR:1 |  | 2 (ACT:SCP0122_PlanActivityMgmt.GetPlanGrou) |
| WK-SCP0122-0037 | X-ROW | SCP0122_PlanActivityMgmt.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — PASS:7 · ERROR:1 |  | 3 (ACT:SCP0122_PlanActivityMgmt.InitControl) |
| WK-SCP0122-0038 | X-ROW | SCP0122_PlanActivityMgmt.RefreshPlanGrou | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 4 (ACT:SCP0122_PlanActivityMgmt.RefreshPlan) |
| WK-SCP0122-0039 | X-ROW | SCP0122_PlanActivityMgmt.Save_Data | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — NA:7 · PASS:6 · ERROR:1 |  | 82 (ACT:SCP0122_PlanActivityMgmt.Save_Data A) |
| WK-SCP0122-0040 | X-ROW | SCP0122_PlanActivityMgmt.SetChangedContr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.SetChangedC) |
| WK-SCP0122-0041 | X-ROW | SCP0122_PlanActivityMgmt.SetSpreadInit | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:4 · PASS:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0122_PlanActivityMgmt.SetSpreadIn) |
| WK-SCP0122-0042 | X-ROW | SCP0122_PlanActivityMgmt.SpdMain_ComboSe | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 36검사 — PASS:22 · ERROR:14 |  | 6 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |

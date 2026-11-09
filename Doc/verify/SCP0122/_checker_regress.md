# 검사기 회귀 대조 SCP0122 — 기준 2026-11-07 15:25 (1548행) ↔ 현재 2026-11-08 22:09 (1504행)

- 악화(기준 비FAIL → 현재 FAIL): **0** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 0 · 그 외 변경: 16 · 사용자 판정 자동 승인 0 · 기준에만 있는 행 45 · 새 행 1
- 승격 대기(received): Doc\verify\_checker_golden\SCP0122.received.csv — 확인 뒤 `checker_regress.py SCP0122 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-6ec80739 | J2 | SCP0122 화면 | ERROR | PASS | E2E auth authorized=true notFound=false menuAccess=Y tobeGroups=ADMIN／GUEST／SSP Planner roster=40:AD |  |
| V-cfe5831b | A7 | [DMF0035 결함 유형] 결과 컬럼 값(Plan Type=MKT FCST Version 컬럼 등) | PASS | NA | 규칙 A7 대상 일치 1행이 모두 NA — [V-1934eacc] SCP0122_GET_PLAN_ACTIVITY_MGMT:  ／ 검사기(tools/DbConn/golden.py < |  |
| T-541a6795 | A1 | `BLUtils.GetDivision(false,"")` → `Division_SCP` · cs:40,126 | PASS | 판정필요 | 행 집계 — 대조표 `BLUtils.GetDivision(false,"")` → `Division_SCP` 'cs:40,126' 의 A1 1요소: REVIEW:1 · FAIL 요소 |  |
| T-111d7ffa | A1 | `GetPlanGroupByUserID()` Tables[3] → `PlanGroup_SCP_ALL` · c | PASS | 판정필요 | 행 집계 — 대조표 `GetPlanGroupByUserID()` Tables[3] → `PlanGroup_SCP_ALL` 'cs:53,129,174' 의 A1 1요소: REVIEW |  |
| T-1b716d1b | A1 | `Data.Common(LookupCommon,false,"OPMZ_PRS_CD")` · cs:47,127 | PASS | 판정필요 | 행 집계 — 대조표 `Data.Common(LookupCommon,false,"OPMZ_PRS_CD")` 'cs:47,127' 의 A1 1요소: REVIEW:1 · FAIL 요소: |  |
| T-0ba50f6d | A1 | `ClbDivision_SelectedIndexChanged`→`RefreshPlanGroupByDivisi | PASS | 판정필요 | 행 집계 — 대조표 `ClbDivision_SelectedIndexChanged`→`RefreshPlanGroupByDivisi 'cs:544,169-175,548' 의 A1 1요 |  |
| T-ae5bc4c7 | A1 | `CboPlanGroup_SelectedIndexChanged`→`ClearDataSource` · cs:5 | PASS | 판정필요 | 행 집계 — 대조표 `CboPlanGroup_SelectedIndexChanged`→`ClearDataSource` 'cs:551-554' 의 A1 1요소: REVIEW:1 · F |  |
| T-ce60c735 | A1 | `SetDivisionAuthCheck`(`dtMyDivision.Rows.Count==0`, `usrLay | PASS | 판정필요 | 행 집계 — 대조표 `SetDivisionAuthCheck`(`dtMyDivision.Rows.Count==0`, `usrLay 'cs:123-124' 의 A1 1요소: REVIE |  |
| T-a21da12d | A1 | `RefreshPlanGroupByDivision` DIVISION_ID='' 필터 → 후보 0 · cs:1 | PASS | 판정필요 | 행 집계 — 대조표 `RefreshPlanGroupByDivision` DIVISION_ID='' 필터 → 후보 0 'cs:169-172' 의 A1 1요소: REVIEW:1 · F |  |
| T-8fb206b5 | A1 | `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 · cs:342 | PASS | 판정필요 | 행 집계 — 대조표 `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 'cs:342' 의 A1 1요소: REVIEW:1 · FAIL 요소: PKG_SCP0122. |  |
| T-6c008842 | A1 | 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00443 · cs:453 | PASS | 판정필요 | 행 집계 — 대조표 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00443 'cs:453' 의 A1 1요소: REVIEW:1 · FAIL 요소: PKG_SC |  |
| T-9555c5b0 | A1 | MSG00097 · 권한 Division 없음 | PASS | 판정필요 | 행 집계 — 대조표 MSG00097 '권한 Division 없음' 의 A1 1요소: REVIEW:1 · FAIL 요소: PKG_SCP0122.P_SCP0122_GET_PLAN —  |  |
| T-f090f5cb | A1 | COMMON:UC-07 · 필터 걸린 상태 재조회 시 조회되고 필터도 그대로 적용(rebindFilterCo | PASS | 판정필요 | 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회 시 조회되고 필터도 그대로 적용(rebindFilterColumns' 의 A1 1요소: REVIEW:1 · FA |  |
| T-c64588b2 | X-ROW | SCP0122_PlanActivityMgmt.FindButton | PASS | 판정필요 | 진입점 집계 3검사 — PASS:2 · REVIEW:1 |  |
| T-7b11916e | A1 | PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_MGMT | PASS | 판정필요 | golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0122/SCP0122_GET_PLAN_ACTIVITY_MGMT.md — 파라미터 미정 |  |
| T-39d1db98 | X-ROW | SCP0122_PlanActivityMgmt.FindData_Main | PASS | 판정필요 | 진입점 집계 10검사 — PASS:7 · NA:2 · REVIEW:1 |  |

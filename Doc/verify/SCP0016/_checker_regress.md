# 검사기 회귀 대조 SCP0016 — 기준 2026-11-06 19:43 (2077행) ↔ 현재 2026-11-07 22:57 (2151행)

- 악화(기준 비FAIL → 현재 FAIL): **1** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 23 · 그 외 변경: 54 · 사용자 판정 자동 승인 2 · 기준에만 있는 행 25 · 새 행 99
- 승격 대기(received): Doc\verify\_checker_golden\SCP0016.received.csv — 확인 뒤 `checker_regress.py SCP0016 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| T-a851e7f6 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SpdMain_TopChange | PASS | FAIL | 진입점 집계 1검사 — FAIL:1 |  |

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-7a9d555f | L1 | 조회조건 텍스트 입력 중 그리드 | FAIL | PASS | 조회(Division ALL) 응답 3216ms(요청~응답 3216ms · 벽시계 5707ms) · 436행 — 기준 10초(화면 규칙 L1: 조회·저장·키 이동 응답 기준 이내) |  |
| T-d2929754 | G1 | D00-1-004 · §1 btnProject / UsrButton | FAIL | PASS | 행 집계 — 대조표 D00-1-004 '§1 btnProject / UsrButton' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-d8493b15 | G1 | D00-1-007 · §1 btnItem_Id / UsrButton | FAIL | PASS | 행 집계 — 대조표 D00-1-007 '§1 btnItem_Id / UsrButton' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-5623a7a5 | G1 | D00-1-012 · §1 usrConditionPanel1 / UsrConditionPanel | FAIL | PASS | 행 집계 — 대조표 D00-1-012 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-cc1bcbfa | G1 | D00-2-003 · §2 btnProject / Click | FAIL | PASS | 행 집계 — 대조표 D00-2-003 '§2 btnProject / Click' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-12c3e2ad | G1 | D00-2-004 · §2 btnItem_Id / Click | FAIL | PASS | 행 집계 — 대조표 D00-2-004 '§2 btnItem_Id / Click' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-3c89c28a | G1 | D00-4a-001 · §4a SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL  | FAIL | PASS | 행 집계 — 대조표 D00-4a-001 '§4a SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL / F' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-5242d23f | G1 | D00-4b-001 · §4b FindButton / toolbarOverride / Search | FAIL | PASS | 행 집계 — 대조표 D00-4b-001 '§4b FindButton / toolbarOverride / Search' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-9e764a2a | G1 | D00-4b-005 · §4b BtnItem_Id_Click / event / btnItem_Id | FAIL | PASS | 행 집계 — 대조표 D00-4b-005 '§4b BtnItem_Id_Click / event / btnItem_Id' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-96f9055e | G1 | D00-4b-006 · §4b BtnProject_Click / event / btnProject | FAIL | PASS | 행 집계 — 대조표 D00-4b-006 '§4b BtnProject_Click / event / btnProject' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-d8764c4f | G1 | CRUD:D00-4b-001:SEARCH · [SEARCH] §4b FindButton / toolbarOv | FAIL | PASS | 행 집계 — 대조표 CRUD:D00-4b-001:SEARCH '[SEARCH] §4b FindButton / toolbarOverride / Search' 의 G1 9요소: PAS |  |
| T-62a9e277 | G1 | COMMON:UC-03 · 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Re | FAIL | PASS | 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-2adfb86b | G1 | COMMON:UC-06 · Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | FAIL | PASS | 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-2383e795 | G1 | COMMON:UC-07 · 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebind | FAIL | PASS | 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-60260947 | G1 | 1 · MSG00109 EditButton 읽기전용 가드(644) | FAIL | PASS | 행 집계 — 대조표 1 'MSG00109 EditButton 읽기전용 가드(644)' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-d6f085b3 | G1 | 2 · GMessageBoxForException SetOperationGroupByDivision(908) | FAIL | PASS | 행 집계 — 대조표 2 'GMessageBoxForException SetOperationGroupByDivisio' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-d577555d | G1 | FindButton(636) · FindData_Main() 실동작 | FAIL | PASS | 행 집계 — 대조표 FindButton(636) 'FindData_Main() 실동작' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-8e1e9118 | G1 | SaveButton(648) · NO-OP 빈 `{}` | FAIL | PASS | 행 집계 — 대조표 SaveButton(648) 'NO-OP 빈 `{}`' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-7aab5d54 | G1 | LookupCommon OPERATION_GROUP(203) · lookup(초기 P/A/E) | FAIL | PASS | 행 집계 — 대조표 LookupCommon OPERATION_GROUP(203) 'lookup(초기 P/A/E)' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-f9d567dd | G1 | OperationGroup(928) / OperationGroupEE(932) · `OperationGrou | FAIL | PASS | 행 집계 — 대조표 OperationGroup(928) / OperationGroupEE(932) '`OperationGroup_SCP`{P,A} / `OperationGroupE |  |
| T-706d647d | G1 | LookupCommon ELECTRODE_TYPE(206) · lookup `ELECTRODE_TYPE`(다 | FAIL | PASS | 행 집계 — 대조표 LookupCommon ELECTRODE_TYPE(206) 'lookup `ELECTRODE_TYPE`(다중)' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-881108c8 | G1 | WaterfallVer_FG2(234) · `WaterfallVer_FG2_SCP`(@divisionId) | FAIL | PASS | 행 집계 — 대조표 WaterfallVer_FG2(234) '`WaterfallVer_FG2_SCP`(@divisionId)' 의 G1 9요소: PASS:5 · NA:4 |  |
| T-de4e391a | G1 | BucketISO(221) · `BucketISO_SCP` | FAIL | PASS | 행 집계 — 대조표 BucketISO(221) '`BucketISO_SCP`' 의 G1 9요소: PASS:5 · NA:4 |  |

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-a0617921 | E2 | SCP0016 기간 역전 조회 | ERROR | PASS | 기간 역전 입력을 컨트롤이 거부(From '2026.11.07' · To '2027.11.07') · 정상 범위 날짜 입력은 됨 |  |
| V-f9046a3f | H12 | SCP0016 화면 | PASS | NA | 고정 컬럼 20개 [DIVISION_ID, BIZ_TYPE_NAME, ITEM_ID, NICK_NAME, ELECTRODE_TYPE, ORIGIN_TO_DIVISION_ID, TO |  |
| V-f516468e | D1 | Waterfall Shipment Plan.DEPT_NAME_KO (Team) | NA | PASS | 기존행 r0 DEPT_NAME_KO 편집=false (AS-IS 잠금) |  |
| V-1663f850 | H2 | Waterfall Shipment Plan.DEPT_NAME_KO (Team) | NA | PASS | DEPT_NAME_KO: 기존행 편집=false 표시 일치 |  |
| V-3a05113e | H13 | Waterfall Shipment Plan.<DYNAMIC:LOOP> (동적 LOOP 컬럼) | ERROR | PASS | D_20260824 r13 값 '-120' 글자색 rgb(192, 57, 43) (동적 <DYNAMIC:LOOP> → 대표 M_202608(439개 중)) |  |
| V-35c9006d | H7 | Excel Download 양식(공통 모듈) | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['MEASURE_SELECT', 'SEARCH'] · plan.buttons ['Button1', 'Column', 'Me |  |
| V-53aae4fb | H6 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | ERROR | PASS | 규칙 H6 판정 7행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-fb8039d6] txtItem_Id / Model / Item_Id / Model/Nickname / |  |
| V-29bc0ba5 | D1 | [DMF0042 결함 유형] Team·End Customer·Energy(WH) 컬럼 | NA | PASS | 규칙 D1 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-f516468e] Waterfall Shipment Plan.DEPT_NAME_KO (Team): 기존 |  |
| V-c1c3e108 | H7 | [DMF0074 결함 유형] Excel Form 양식 헤더 | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['MEASURE_SELECT', 'SEARCH'] · plan.buttons ['Button1', 'Column', 'Me |  |
| V-5dedc215 | H7 | [DMF0021 결함 일반화] Excel Download(TEAM·FCST Type·Measure·Proje | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['MEASURE_SELECT', 'SEARCH'] · plan.buttons ['Button1', 'Column', 'Me |  |
| V-4af7ab0e | A7 | [DMF0035 결함 유형] 결과 컬럼 값(Plan Type=MKT FCST Version 컬럼 등) | NA | PASS | 규칙 A7 판정 19행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-05926782] SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL:  ／ 검사기 |  |
| V-f8c11e2e | H6 | [DMF0005 결함 유형] Team 팝업 조건(Team ID/Team Name) | ERROR | NA | 규칙 H6 대상 일치 1행이 모두 NA — [T-fb8039d6] txtItem_Id / Model / Item_Id / Model/Nickname / Nickname: E2E s |  |
| V-d716dfc1 | E3 | [SYS0004 결함 유형] Insert 저장 / Delete CRUD Status | 판정필요 | NA | 대상 없음 — 대상 없음(근거: SAVE: plan.hasSave=False · proc_meta 저장 배선 0건) |  |
| V-321d1ef1 | H6 | [DMF0005 결함 일반화] Model Code Change 팝업(MODEL_CODE_CHANGE Moda | ERROR | PASS | 규칙 H6 판정 9행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-fb8039d6] txtItem_Id / Model / Item_Id / Model/Nickname / |  |
| V-7e8e3a13 | H7 | [DMF0049 결함 일반화] Excel Download 월 칸 서식(#,##0.000;[Red]-#,##0 | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['MEASURE_SELECT', 'SEARCH'] · plan.buttons ['Button1', 'Column', 'Me |  |
| V-e5787dfd | H7 | Excel Download 양식(공통 모듈) | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['MEASURE_SELECT', 'SEARCH'] · plan.buttons ['Button1', 'Column', 'Me |  |
| V-1aec5c36 | H7 | Excel Download(TEAM·FCST Type·Measure·Project) | PASS | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['MEASURE_SELECT', 'SEARCH'] · plan.buttons ['Button1', 'Column', 'Me |  |
| V-1d6670a6 | E3 | 그리드 필수 컬럼(USER_SELECTABLE_FLAG=N · 라벨 *) 미입력 저장 | 판정필요 | NA | 대상 없음 — 대상 없음(근거: SAVE: plan.hasSave=False · proc_meta 저장 배선 0건) |  |
| V-51989246 | E3 | 그리드 필수 컬럼 Setting(Div 별 META) · 컬럼셋팅 필수 표시 · 저장 필수 검증 | 판정필요 | NA | 대상 없음 — 대상 없음(근거: SAVE: plan.hasSave=False · proc_meta 저장 배선 0건) |  |
| T-fb8039d6 | H6 | txtItem_Id / Model / Item_Id / Model/Nickname / Nickname | ERROR | NA | E2E smoke cond popup / 실측[T-fb8039d6]: E2E smoke cond popup → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) → 기계 판정  |  |
| T-519950e7 | A5 | D00-1-011 · §1 chkSum / UsrCheckBox | 판정필요 | PASS | 행 집계 — 대조표 D00-1-011 '§1 chkSum / UsrCheckBox' 의 A5 1요소: PASS:1 |  |
| T-ec630595 | A5 | D00-1-013 · §1 spdMain / FpSpread | 판정필요 | PASS | 행 집계 — 대조표 D00-1-013 '§1 spdMain / FpSpread' 의 A5 1요소: PASS:1 |  |
| T-c5226947 | A5 | D00-1-016 · §1 spdMain_Sheet1 / SheetView | 판정필요 | PASS | 행 집계 — 대조표 D00-1-016 '§1 spdMain_Sheet1 / SheetView' 의 A5 1요소: PASS:1 |  |
| T-8333c7ee | A5 | D00-3-020 · §3 Query / (dsBinding) 그리드 바인딩 | 판정필요 | PASS | 행 집계 — 대조표 D00-3-020 '§3 Query / (dsBinding) 그리드 바인딩' 의 A5 1요소: PASS:1 |  |
| T-3c897917 | A5 | D00-3-021 · §3 LockColumn / (0, GetMaxColumnIndex, true) 전 컬 | 판정필요 | PASS | 행 집계 — 대조표 D00-3-021 '§3 LockColumn / (0, GetMaxColumnIndex, true) 전 컬럼 ' 의 A5 1요소: PASS:1 |  |
| T-6ddddb2b | A5 | D00-3-033 · §3 Visible= / Daily: isDaily/isWeekly → true | 판정필요 | PASS | 행 집계 — 대조표 D00-3-033 '§3 Visible= / Daily: isDaily/isWeekly → true' 의 A5 1요소: PASS:1 |  |
| T-e6aec75b | A5 | D00-3-034 · §3 Visible= / Daily: isMonthly/isWeekly → chkSum | 판정필요 | PASS | 행 집계 — 대조표 D00-3-034 '§3 Visible= / Daily: isMonthly/isWeekly → chkSum.C' 의 A5 1요소: PASS:1 |  |
| T-b0d5c148 | A5 | D00-3-035 · §3 Visible= / Weekly: isDaily → false | 판정필요 | PASS | 행 집계 — 대조표 D00-3-035 '§3 Visible= / Weekly: isDaily → false' 의 A5 1요소: PASS:1 |  |
| T-f8e013e4 | A5 | D00-3-036 · §3 Visible= / Weekly: isWeekly → true | 판정필요 | PASS | 행 집계 — 대조표 D00-3-036 '§3 Visible= / Weekly: isWeekly → true' 의 A5 1요소: PASS:1 |  |
| T-e7509ac2 | A5 | D00-3-037 · §3 Visible= / Weekly: isMonthly → chkSum.Checked | 판정필요 | PASS | 행 집계 — 대조표 D00-3-037 '§3 Visible= / Weekly: isMonthly → chkSum.Checked' 의 A5 1요소: PASS:1 |  |
| T-a19a4a28 | A5 | D00-3-038 · §3 Visible= / WeeklyISO: isWeeklyISO | 판정필요 | PASS | 행 집계 — 대조표 D00-3-038 '§3 Visible= / WeeklyISO: isWeeklyISO' 의 A5 1요소: PASS:1 |  |
| T-113cc0ec | A5 | D00-3-039 · §3 Visible= / Monthly: isDaily/isWeekly → false | 판정필요 | PASS | 행 집계 — 대조표 D00-3-039 '§3 Visible= / Monthly: isDaily/isWeekly → false' 의 A5 1요소: PASS:1 |  |
| T-e2762619 | A5 | D00-3-040 · §3 Visible= / Monthly: else → true | 판정필요 | PASS | 행 집계 — 대조표 D00-3-040 '§3 Visible= / Monthly: else → true' 의 A5 1요소: PASS:1 |  |
| T-1d27dffe | A1 | PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 판정필요 | PASS | golden PASS AS-IS 2212행 ↔ TO-BE 2212행: Doc/golden/SCP0016/SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL.md  |  |
| T-3a4b4795 | A5 | COMMON:UC-07 · 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebind | 판정필요 | PASS | 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A5 1요소: PASS:1 |  |
| T-d99d9999 | A5 | 7 · cboBucketType_SelectedIndexChanged(1193) | 판정필요 | PASS | 행 집계 — 대조표 7 'cboBucketType_SelectedIndexChanged(1193)' 의 A5 1요소: PASS:1 |  |
| T-23179cae | A5 | 9 · dCalendar_ValueChanged(1351) | 판정필요 | PASS | 행 집계 — 대조표 9 'dCalendar_ValueChanged(1351)' 의 A5 1요소: PASS:1 |  |
| T-503a93d4 | A5 | 전 컬럼 Lock(#21, R1) · DataGrid `isReadOnly={true}` | 판정필요 | PASS | 행 집계 — 대조표 전 컬럼 Lock(#21, R1) 'DataGrid `isReadOnly={true}`' 의 A5 1요소: PASS:1 |  |
| T-22c2b7dc | A5 | SmartColMerge 세로병합(#1/#19/#22, R2) · `WaterfallMergeManager` | 판정필요 | PASS | 행 집계 — 대조표 SmartColMerge 세로병합(#1/#19/#22, R2) '`WaterfallMergeManager`(KEY_IDX 좌측 누적 그룹) + `allow' 의 |  |
| T-b23bc1c4 | A5 | TopChange sticky(#19) · scrollPositionChanged → invalidate | 판정필요 | PASS | 행 집계 — 대조표 TopChange sticky(#19) 'scrollPositionChanged → invalidate' 의 A5 1요소: PASS:1 |  |
| T-3d595925 | A5 | 다단 헤더 span 3단(#3~18, R5) · `buildDynamicColumns`(월/주/SUM) +  | 판정필요 | PASS | 행 집계 — 대조표 다단 헤더 span 3단(#3~18, R5) '`buildDynamicColumns`(월/주/SUM) + WaterfallMergeMan' 의 A5 1요소: P |  |
| T-e767d6c9 | A5 | 요일 헤더색(#8, R9) · formatItem SAT=Blue/SUN=Red(HEADER_COLORS) | 판정필요 | PASS | 행 집계 — 대조표 요일 헤더색(#8, R9) 'formatItem SAT=Blue/SUN=Red(HEADER_COLORS)' 의 A5 1요소: PASS:1 |  |
| T-5545943b | A5 | 더블클릭 펼침/접기(#31, R10) · Grid onDblClick 드릴 + WeeklyISO 가드 | 판정필요 | PASS | 행 집계 — 대조표 더블클릭 펼침/접기(#31, R10) 'Grid onDblClick 드릴 + WeeklyISO 가드' 의 A5 1요소: PASS:1 |  |
| T-28cf0a57 | A5 | 헤더높이(#32, R11) · headerRowHeight 48/tier | 판정필요 | PASS | 행 집계 — 대조표 헤더높이(#32, R11) 'headerRowHeight 48/tier' 의 A5 1요소: PASS:1 |  |
| T-ef4e8b6e | A5 | BucketType×chkSum visible 8분기(#33~40, R12) · `baseVisibleOf` | 판정필요 | PASS | 행 집계 — 대조표 BucketType×chkSum visible 8분기(#33~40, R12) '`baseVisibleOf`' 의 A5 1요소: PASS:1 |  |
| T-40deb042 | A5 | 숫자 셀타입(#2/#6/#7, R4) · dynamicColumns format `#,##0`(정수) | 판정필요 | PASS | 행 집계 — 대조표 숫자 셀타입(#2/#6/#7, R4) 'dynamicColumns format `#,##0`(정수)' 의 A5 1요소: PASS:1 |  |
| T-2ff4a252 | A5 | 그리드 바인딩(#20, R3) · useTabProcQuery → DataGrid itemsSource(de | 판정필요 | PASS | 행 집계 — 대조표 그리드 바인딩(#20, R3) 'useTabProcQuery → DataGrid itemsSource(derivePerio' 의 A5 1요소: PASS:1 |  |
| T-3fad9520 | A5 | 월/주합 파생 SetValue(#23~30, R6~R8) · `derivePeriodSums`(utils/w | 판정필요 | PASS | 행 집계 — 대조표 월/주합 파생 SetValue(#23~30, R6~R8) '`derivePeriodSums`(utils/waterfall.derive) — D_ 만 ' 의 A5 |  |
| T-12a2d599 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN | 판정필요 | PASS | golden PASS AS-IS 439행 ↔ TO-BE 439행: Doc/golden/SCP0016/SCP0009_GET_SHEET_CALENDAR_3SPAN.md · 데이터 기준 |  |
| T-a5ca728a | X-ROW | SCP0016_WaterfallShipmentPlanFG.SetSpreadColumn | 판정필요 | PASS | 진입점 집계 16검사 — NA:11 · PASS:5 |  |
| EG-e0a3f241 | H4 | SCP0016 팝업 SCM0002_ProjectbyDivisionPopup COND:Project RESIZ | NA | PASS | 기대 축소 → 조건·버튼 겹침 없음 · 실제 rect {"x":360,"y":315,"w":1200,"h":450} · 겹침 [] · 근거 문서 DM-166 |  |
| EG-30fc6a65 | H4 | SCP0016 팝업 SCM0002_TitleSetForm_Popup BTN:btnMeasure RESIZE_ | NA | PASS | 기대 축소 → 조건·버튼 겹침 없음 · 실제 rect {"x":560,"y":390,"w":800,"h":300} · 겹침 [] · 근거 문서 DM-166 |  |
| EG-66f098c0 | I2 | SCP0016 언어 전환 EN 데이터 | PASS | ERROR | [확인 대상] 그리드 칸 한글 DEPT_NAME_KO 200행 — 명칭 칸이면 언어 미반영 |  |
| EG-fe633b22 | I2 | SCP0016 언어 전환 CN 데이터 | PASS | ERROR | [확인 대상] 그리드 칸 한글 DEPT_NAME_KO 200행 — 명칭 칸이면 언어 미반영 |  |

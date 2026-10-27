[LITE]

=== FILE: analysis.md ===
# SCP0122 Plan Activity Mgmt — As-is 분석서

> 근거: AsisFacts 정적 추출 Fact Pack (SCP0122). Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 내용 |
|---|---|
| 화면 ID | SCP0122 |
| 화면명(Form Text) | `SCP0122_PlanActivityMgmt` (Designer.cs:293) |
| 도메인 | SCP (`06.UIL\GSCM.SCP.Forms.UIL\Master\`) |
| 클래스 | `SCP0122_PlanActivityMgmt` |
| 프로젝트 | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\SCP0122_PlanActivityMgmt.csproj` (sln 미등록) |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current(sln미등록) | `SCP0122_PlanActivityMgmt.cs` | 587 |
| current(sln미등록) | `SCP0122_PlanActivityMgmt.Designer.cs` | 336 |
| current(sln미등록) | `Properties\AssemblyInfo.cs` | 37 |
| current(sln미등록) | `Properties\Resources.Designer.cs` | 72 |
| current(sln미등록) | `Properties\Settings.Designer.cs` | 31 |
| shared | 없음 (Fact Pack에 기재되지 않음) | — |
| legacy | 없음 (Fact Pack에 기재되지 않음) | — |

> 모든 파일이 **sln 미등록**입니다. 운영 빌드에 포함되는지는 **확인 필요**입니다.

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 321 | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` | MATCH | SCP0122_GET_PLAN_ACTIVITY_MGMT |
| button:SaveButton | SaveButton > Save_Data | 480 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` | MATCH | SCP0122_SAVE_PLAN_ACTIVITY_MGMT |
| button:SaveButton | SaveButton > Save_Data > FindData_Main | 321 | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` | MATCH | SCP0122_GET_PLAN_ACTIVITY_MGMT (저장 후 재조회) |
| (진입점 미연결) | GetPlanGroupByUserID | 155 | `SCP.SCP0121_GET_SEARCH_INFO` | MATCH | SCP0121_GET_SEARCH_INFO |
| (진입점 미연결) | `<field:dtProcessCdAll>` | 47 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | (Biz 공통: UP_FX_GetCommonDataList) |

- **진입점 미연결 2건**: 정적 파서가 호출 진입점(Form_Load/이벤트/버튼)까지 추적하지 못했습니다. `GetPlanGroupByUserID`는 Plan Group 콤보를 채우는 메서드로 보이며 `Form_Load`나 `ClbDivision_SelectedIndexChanged` → `RefreshPlanGroupByDivision`(171)에서 호출될 가능성이 있지만, 정적 사실로 확인되지 않아 **확인 필요**입니다.
- `dtProcessCdAll`은 필드 초기화식(47행)에서 LookupCommon 공통코드를 조회합니다. 따라서 클래스 생성 시점에 실행된다고 봅니다. 소비처(cboProcess 바인딩 여부)는 **확인 필요**입니다.
- 그 밖의 메서드: `Insert_Row`(367, GetCheckedListValue 호출), `EditButton`(275, GetSheetInfo)는 엔드포인트를 호출하지 않습니다.

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 테이블/객체 |
|---|---|---:|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 1 | — | 코드분기 UP_FX_GetCommonDataList: SELECT SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCP.SCP0121_GET_SEARCH_INFO` | MATCH | 1 | SCP0121_GET_SEARCH_INFO | INSERT #DIVISION_INFO / #LINE_MASTER / #OSP_PLANT_INFO; SELECT SCM_MST_DIVISION, SCM_MST_LINE_SN, SCM_MST_FACTORY_SN, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_LINE_OSP, SCM_MST_SITE, SCM_MST_VENDOR, SCP_MST_CAPA_LINE, SCP_OPMZ_PLAN_GR_M, SCM_ADM_LOOKUP_MASTER, SCM_OPERATION_M_SN |
| `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` | MATCH | 1 | SCP0122_GET_PLAN_ACTIVITY_MGMT | SELECT SCP_OPMZ_PLAN_GR_ACTV_M, SCP_OPMZ_PLAN_GR_M, SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` | MATCH | 1 | SCP0122_SAVE_PLAN_ACTIVITY_MGMT | EXEC PR_SCM_SYS_LOG_BATCH, SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST; REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL; INSERT/UPDATE/DELETE SCP_OPMZ_PLAN_GR_ACTV_M; INSERT SCM_SYS_LOG_BATCH, SCP_OPMZ_PLAN_GR_ACTV_H |

> 주석 처리된 호출(commented_calls): **0건**

## 4. 이벤트 배선

| 대상 | 이벤트 | 핸들러 | 배선 위치 |
|---|---|---|---|
| this | Load | `Form_Load` | .ctor:98 |
| cboDivision | SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` | InitEvent:217 |
| cboPlanGroup | SelectedIndexChanged | `CboPlanGroup_SelectedIndexChanged` | InitEvent:218 |
| this.spdMain | ComboSelChange | `SpdMain_ComboSelChange` | InitEvent:220 |
| this.spdMain | CellClick | `spdMain_CellClick` | InitEvent:221 |

- `SpdMain_ClipboardPasted`(574행) 메서드는 `dtPlanGroup`에서 셀 Text와 `NAME`이 같은 행을 찾아 `CODE`를 읽습니다. 그런데 events.csv에 배선 기록이 없어 연결 방식(InitEvent:219 등 누락 여부)은 **확인 필요**입니다.
- 각 핸들러의 본문 동작(호출 메서드)은 Fact Pack에 없어 **확인 필요**입니다.

## 5. Grid 구성 방식

- 구성 방식: **`META(프레임워크) (+코드 표시/라벨 변경)`**
- 시트: `Plan Activity Mgmt` 1개 (CreateSpread:185 `AddSheet`, 인자 원문 `spdMain ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 1 ¦ 1 ¦ 30`)
- 메타 컬럼 생성: `SetSheetHeaderColumnSCP(siObj, 1, false, "")` @ SetSpreadInit:212. `sheetName.Equals("Plan Activity Mgmt")` 분기 안에서 실행됩니다. SCM_MST_SHEET_COLUMNS의 COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, VISIBLE_FLAG, VALID_YN, FIXED_FLAG, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, HORIZONTAL_ALIGN_CODE, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, UPPERCASE_APPLY_FLAG, ATTRIBUTE1~5 등을 읽습니다.
- 코드 표시 변경: Designer.cs 252~255행의 ColumnHeader 스타일(정렬 General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced)만 있습니다. 컬럼을 추가하거나 숨기는 코드는 없습니다.
- 연결 규칙: `META+코드연결`

### 5-1. Division별 차이

| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Plan Activity Mgmt | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |

→ 모든 division에서 15컬럼(전부 '기본')이며 **division별 차이는 없습니다**. 분기 조건을 판단하지 못한 건은 0건입니다.

## 6. 확인 필요 항목

1. `GetPlanGroupByUserID`(155, SCP0121_GET_SEARCH_INFO)의 호출 진입점: Form_Load인지 Division 변경인지 확인해야 합니다. 143행에서 `FoxUserInfoContext.Current.NowGroupID`를 사용합니다.
2. `dtProcessCdAll`(47, LookupCommon)의 LOOKUP 코드값과 cboProcess 바인딩 여부.
3. `SpdMain_ClipboardPasted`의 이벤트 배선 여부.
4. `Insert_Row`(367)를 부르는 버튼 진입점(InsertButton 등).
5. `FindData_Main` 308~310행의 `GetCheckedListValue` 3회 호출이 어느 컨트롤을 대상으로 하는지 (Division/Plan Group/Process로 추정되지만 정적 사실로 미확정).
6. `Division` LayoutControlItem의 Text 원문 (props.csv에 Text 속성 없음).
7. 실제 SP 실행 결과와 매칭되는 시트가 없습니다. SP 결과 컬럼과 메타 15컬럼이 일치하는지 실행 검증이 필요합니다.
8. `usrLayoutControl1`(657×184, parent 미기재)의 화면 내 실제 사용 여부.
9. 모든 파일이 sln 미등록이므로 운영 배포 대상인지 확인해야 합니다.

=== FILE: source_links.md ===
# SCP0122 소스 링크

기준 경로: `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0122_PlanActivityMgmt\`

## 1. 엔드포인트 호출 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [SCP0122_PlanActivityMgmt.cs](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0122_PlanActivityMgmt/SCP0122_PlanActivityMgmt.cs#L47) | `<field:dtProcessCdAll>` | 47 | `biz:CommonData.CommonDataList` [code=LookupCommon] (Data.Common → Data.CallBizCommonData) |
| [SCP0122_PlanActivityMgmt.cs](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0122_PlanActivityMgmt/SCP0122_PlanActivityMgmt.cs#L155) | GetPlanGroupByUserID | 155 | `SCP.SCP0121_GET_SEARCH_INFO` |
| [SCP0122_PlanActivityMgmt.cs](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0122_PlanActivityMgmt/SCP0122_PlanActivityMgmt.cs#L321) | FindData_Main | 321 | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` |
| [SCP0122_PlanActivityMgmt.cs](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0122_PlanActivityMgmt/SCP0122_PlanActivityMgmt.cs#L480) | Save_Data | 480 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0122_PlanActivityMgmt.cs | .ctor | 98 | `this.Load += Form_Load` |
| SCP0122_PlanActivityMgmt.cs | InitEvent | 217 | `cboDivision.SelectedIndexChanged += ClbDivision_SelectedIndexChanged` |
| SCP0122_PlanActivityMgmt.cs | InitEvent | 218 | `cboPlanGroup.SelectedIndexChanged += CboPlanGroup_SelectedIndexChanged` |
| SCP0122_PlanActivityMgmt.cs | InitEvent | 220 | `this.spdMain.ComboSelChange += SpdMain_ComboSelChange` |
| SCP0122_PlanActivityMgmt.cs | InitEvent | 221 | `this.spdMain.CellClick += spdMain_CellClick` |

## 3. Grid / 메타 / 기타

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0122_PlanActivityMgmt.cs | GetPlanGroupByUserID | 143 | `FoxUserInfoContext.Current` → `NowGroupID` |
| SCP0122_PlanActivityMgmt.cs | RefreshPlanGroupByDivision | 171 | `GetCheckedListValue` (CODE) |
| SCP0122_PlanActivityMgmt.cs | CreateSpread | 185 | `AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30)` → "Plan Activity Mgmt" |
| SCP0122_PlanActivityMgmt.cs | CreateSpread | 186 | `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)` |
| SCP0122_PlanActivityMgmt.cs | CreateSpread | 188 | `ChangeSheet` |
| SCP0122_PlanActivityMgmt.cs | InitSpread | 197 | `ChangeSheet(0)` |
| SCP0122_PlanActivityMgmt.cs | InitSpread | 198 | `ChangeActiveSheet(SpdSheet.shtMain)` |
| SCP0122_PlanActivityMgmt.cs | SetSpreadInit | 205 | `ChangeSheet(0)` — `if(sheetName.Equals("Plan Activity Mgmt"))` |
| SCP0122_PlanActivityMgmt.cs | SetSpreadInit | 206 | `InitSheet(0)` — 같은 분기 |
| SCP0122_PlanActivityMgmt.cs | SetSpreadInit | 212 | `SetSheetHeaderColumnSCP(siObj, 1, false, "")` (메타 컬럼 생성) |
| SCP0122_PlanActivityMgmt.cs | EditButton | 275 | `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)` — `if(spdMain != null)` |
| SCP0122_PlanActivityMgmt.cs | FindData_Main | 306 | `ChangeSheet(SpdSheet.shtMain)` |
| SCP0122_PlanActivityMgmt.cs | FindData_Main | 308 / 309 / 310 | `GetCheckedListValue` (CODE) ×3 |
| SCP0122_PlanActivityMgmt.cs | Insert_Row | 367 | `GetCheckedListValue` (CODE) |
| SCP0122_PlanActivityMgmt.cs | SpdMain_ClipboardPasted | 574 | `dtPlanGroup` NAME → CODE 변환 |
| SCP0122_PlanActivityMgmt.Designer.cs | InitializeComponent | 252~255 | ColumnHeader 스타일 (HorizontalAlignment / NoteIndicatorColor / Parent / VerticalAlignment) |
| SCP0122_PlanActivityMgmt.Designer.cs | InitializeComponent | 199 | layoutControlItem2.Text = "Process" |
| SCP0122_PlanActivityMgmt.Designer.cs | InitializeComponent | 210 | layoutControlItem9.Text = "Plan Group" |
| SCP0122_PlanActivityMgmt.Designer.cs | InitializeComponent | 293 | this.Text = "SCP0122_PlanActivityMgmt" |

=== FILE: web_components.md ===
# SCP0122 Web 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 후보 |
|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel (Dock Top, HidePanel) | — | 1561×98 | 조회조건 패널 (접기 가능) |
| usrLayoutControl2 | UsrLayoutControl (Dock Fill, 조건패널 내부) | — | 1561×98 | 조회조건 Form 레이아웃 |
| cboDivision | UsrCombo | (LayoutControlItem `Division`, Text 원문 미기재 — **확인 필요**) | 311×26 | Division 콤보 (멀티선택 여부는 GetCheckedListValue 사용으로 추정, **확인 필요**) |
| cboPlanGroup | UsrComboBox | `Plan Group` | 285×26 | Plan Group 콤보 |
| cboProcess | UsrComboBox | `Process` | 332×26 | Process 콤보 |
| emptySpaceItem1 | EmptySpaceItem | — | 383×68 | 여백 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView (Dock Fill) | — | 1561×766 | Wijmo FlexGrid |
| usrLayoutControl1 | UsrLayoutControl (Dock Fill, parent 미기재) | — | 657×184 | 사용 여부 **확인 필요** |
| imageList1 | ImageList | — | — | 대응 불필요 여부 **확인 필요** |

## 2. 화면 배치

- props.csv에 **SplitContainer가 없습니다**. Dock으로만 배치합니다.
- 상/하 분할: 조회조건 `usrConditionPanel1` (Dock Top, 높이 98) / 그리드 `spdMain` (Dock Fill, 높이 766)
  - 비율 ≈ **상 11% : 하 89%** (98 : 766)
- 좌/우 분할: 없음
- 조회조건 행 (LayoutControlItem 폭 383/383/382, 높이 68): Division, Plan Group, Process, emptySpaceItem1. 항목 간 정확한 좌우 순서는 Location 값이 없어 **확인 필요**입니다.

## 3. 시트별 Grid 컬럼 — `Plan Activity Mgmt`

- 연결 규칙: `META+코드연결` (AddSheet → SetSheetHeaderColumnSCP)
- 코드 하드코딩 컬럼: 없음 (코드 변경은 ColumnHeader 스타일 4건뿐)
- Division별 표시: 14개 division 모두 15컬럼이 '기본'으로 표시되어 차이가 없습니다.

| # | COLUMN_NAME | 라벨 | 출처 | 40 | 81 계열 | 82 | EE 계열 |
|---:|---|---|---|---|---|---|---|
| 1 | AUTO_YN | Auto Flag | META | 기본 | 기본 | 기본 | 기본 |
| 2 | CONFIRM_YN | Confirm Flag | META | 기본 | 기본 | 기본 | 기본 |
| 3 | DIVISION_ID | Div. | META | 기본 | 기본 | 기본 | 기본 |
| 4 | LINK_UI_TYPE | Link UI Type | META | 기본 | 기본 | 기본 | 기본 |
| 5 | OPMZ_ACTV_CD | Activity Code | META | 기본 | 기본 | 기본 | 기본 |
| 6 | OPMZ_ACTV_NAME | Activity Name | META | 기본 | 기본 | 기본 | 기본 |
| 7 | OPMZ_ACTV_SEQ | Act. Seq | META | 기본 | 기본 | 기본 | 기본 |
| 8 | OPMZ_PLAN_GR_ID | Plan Group ID | META | 기본 | 기본 | 기본 | 기본 |
| 9 | OPMZ_PLAN_GR_NAME | Plan Group | META | 기본 | 기본 | 기본 | 기본 |
| 10 | OPMZ_PRS_CD | Process CD | META | 기본 | 기본 | 기본 | 기본 |
| 11 | OPMZ_PRS_NAME | Process | META | 기본 | 기본 | 기본 | 기본 |
| 12 | OPTION_YN | Option Flag | META | 기본 | 기본 | 기본 | 기본 |
| 13 | PRE_OPMZ_ACTV_CD | PRE_OPMZ_ACTV_CD | META | 기본 | 기본 | 기본 | 기본 |
| 14 | PRE_OPMZ_ACTV_SEQ | PRE_OPMZ_ACTV_SEQ | META | 기본 | 기본 | 기본 | 기본 |
| 15 | PROGRAM_NAME | Program Name | META | 기본 | 기본 | 기본 | 기본 |

> 81 계열 = 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC / EE 계열 = EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC — 모두 동일합니다.
> 컬럼 순서는 grid_effective.csv 기재 순서(알파벳)를 따랐습니다. 실제 표시 순서(SORT 메타)·폭·셀 유형(콤보 등)은 SCM_MST_SHEET_COLUMNS 원문을 봐야 하므로 **확인 필요**입니다.
> 셀 콤보: `SpdMain_ComboSelChange` 배선과 ClipboardPasted의 Plan Group NAME→CODE 변환으로 보아 Plan Group 셀은 콤보로 추정됩니다. 확정하려면 메타 CELL_CONTROL_OBJECT_TYPE_CODE를 **확인**해야 합니다.

## 4. 시트 연결 규칙

| 시트 | 규칙 | 생성 | 메타 빌드 | 활성화 |
|---|---|---|---|---|
| Plan Activity Mgmt | META+코드연결 | CreateSpread:185 AddSheet | SetSpreadInit:212 SetSheetHeaderColumnSCP | InitSpread:198 ChangeActiveSheet, FindData_Main:306 ChangeSheet |

- 단일 시트이므로 시트 간 마스터-디테일 연결은 없습니다.

=== FILE: oracle_migration.md ===
# SCP0122 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 엔드포인트 | 용도 | 참조 객체 | EXEC 체인 |
|---|---|---|---|---|
| `SCP0121_GET_SEARCH_INFO` | SCP.SCP0121_GET_SEARCH_INFO | 조회조건 정보 (GetPlanGroupByUserID) | 임시테이블 #DIVISION_INFO, #LINE_MASTER, #OSP_PLANT_INFO (INSERT/SELECT); SCM_MST_DIVISION, SCM_MST_LINE_SN, SCM_MST_FACTORY_SN, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_LINE_OSP, SCM_MST_SITE, SCM_MST_VENDOR, SCP_MST_CAPA_LINE, SCP_OPMZ_PLAN_GR_M, SCM_ADM_LOOKUP_MASTER, SCM_OPERATION_M_SN (SELECT) | 없음 |
| `SCP0122_GET_PLAN_ACTIVITY_MGMT` | SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT | 메인 조회 | SCP_OPMZ_PLAN_GR_ACTV_M, SCP_OPMZ_PLAN_GR_M, SCM_ADM_LOOKUP_MASTER_DETAIL (SELECT) | 없음 |
| `SCP0122_SAVE_PLAN_ACTIVITY_MGMT` | SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT | 저장 | SCP_OPMZ_PLAN_GR_ACTV_M (INSERT/UPDATE/DELETE), SCM_SYS_LOG_BATCH (INSERT), SCP_OPMZ_PLAN_GR_ACTV_H (INSERT); REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | → `PR_SCM_SYS_LOG_BATCH`, → `SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST` |

> `SCP0121_GET_SEARCH_INFO`는 SCP0121 화면 소유의 SP를 공유 호출한 것입니다. 이 화면 전용 SP가 아니므로 공용 처리 여부를 결정해야 합니다.

## 2. 공통코드 분기

| 호출 | code | 처리 SP | 테이블 |
|---|---|---|---|
| `biz:CommonData.CommonDataList` (`dtProcessCdAll`, 47행) | LookupCommon | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |

- LOOKUP 그룹 코드값(어떤 LOOKUP_TYPE을 조회하는지)은 Fact Pack에 없어 **확인 필요**입니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

- FoxQuery 미등록: **없음** (3개 SP 엔드포인트 모두 MATCH)
- 직접 SQL/직접 SP 호출: **없음**
- 주석 처리된 호출: **0건**
- 진입점 미연결 2건 (GetPlanGroupByUserID → SCP0121_GET_SEARCH_INFO, dtProcessCdAll → CommonDataList)은 정적 미추적일 뿐 활성 코드입니다. 호출 시점은 **확인 필요**입니다.

## 4. Oracle 전환 확인 포인트

| # | 대상 | 사실 | 확인 포인트 |
|---:|---|---|---|
| 1 | SCP0121_GET_SEARCH_INFO | `#DIVISION_INFO`, `#LINE_MASTER`, `#OSP_PLANT_INFO` 임시테이블 3개를 INSERT 후 SELECT | Oracle GTT DDL을 직접 준비하거나 WITH/서브쿼리로 바꿀지 결정. 기존 TO-BE에 이미 이관된 SP가 있는지 먼저 확인 |
| 2 | SCP0122_SAVE_PLAN_ACTIVITY_MGMT | `SCM_ARR_SPL_CNT`, `SCM_ARR_SPL_VAL` 참조 (구분자 문자열 분해 함수로 보임) | Oracle 대응 함수의 존재 여부와 FE 전송 페이로드 형식(구분자 문자열인지 JSON인지) 확인 |
| 3 | SCP0122_SAVE_PLAN_ACTIVITY_MGMT | INSERT/UPDATE/DELETE를 하나의 SP에서 처리 | 행 상태(I/U/D) 플래그 전달 방식 확인 |
| 4 | SCP0122_SAVE_PLAN_ACTIVITY_MGMT | `SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST` EXEC → `SCP_OPMZ_PLAN_GR_ACTV_H` INSERT | 이력 SP를 PKG 내부 프로시저로 넣을지, Oracle에서 `_H` 테이블 존재 여부 확인 |
| 5 | SCP0122_SAVE_PLAN_ACTIVITY_MGMT | `PR_SCM_SYS_LOG_BATCH` EXEC → `SCM_SYS_LOG_BATCH` INSERT | 공용 로그 SP의 Oracle 존재 여부 확인 (공용이므로 standalone 유지 대상) |
| 6 | SCP0122_GET_PLAN_ACTIVITY_MGMT | 3개 테이블 SELECT, EXEC 체인 없음 | 결과 컬럼이 메타 15컬럼(AUTO_YN…PROGRAM_NAME)과 일치하는지 확인. Fact Pack은 "SP 실행 결과와 매칭되는 시트 없음"으로 보고 |
| 7 | 공통 | 원본 SP 본문(T-SQL)은 Fact Pack에 미포함 | MSSQL 고유 구문(ISNULL/GETDATE/TOP/NOLOCK 등)의 실제 존재 여부는 원문을 봐야 판단 가능 |

## 5. 난이도 (사실 근거)

| SP | 근거 | 난이도 |
|---|---|---|
| SCP0122_GET_PLAN_ACTIVITY_MGMT | SELECT 3테이블, EXEC 체인·임시테이블 없음 | 낮음 |
| SCP0122_SAVE_PLAN_ACTIVITY_MGMT | DML 3종, EXEC 2단, 분해 함수 REF 2개, 이력/로그 테이블 | 중간 |
| SCP0121_GET_SEARCH_INFO | 임시테이블 3개, 참조 테이블 11개 | 중간~높음 (본문 미확인. 공유 SP라 이미 이관됐는지에 따라 달라짐) |

=== FILE: tobe_design.md ===
# SCP0122 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 순번 | As-is 컨트롤 | 라벨(원문) | 데이터 원천 | 연동 |
|---:|---|---|---|---|
| 1 | cboDivision (UsrCombo) | (Division — Text 원문 **확인 필요**) | 확인 필요 (SCP0121_GET_SEARCH_INFO가 SCM_MST_DIVISION을 참조하므로 후보) | 변경 시 `ClbDivision_SelectedIndexChanged` → `RefreshPlanGroupByDivision`(171)으로 Plan Group 갱신 추정 (**확인 필요**) |
| 2 | cboPlanGroup (UsrComboBox) | Plan Group | `GetPlanGroupByUserID` → `SCP.SCP0121_GET_SEARCH_INFO` (NowGroupID 사용) | 변경 시 `CboPlanGroup_SelectedIndexChanged` (동작 **확인 필요**) |
| 3 | cboProcess (UsrComboBox) | Process | `dtProcessCdAll` → `biz:CommonData.CommonDataList` [LookupCommon] 추정 (**확인 필요**) | — |

- 조회 시 `FindData_Main` 308~310행에서 `GetCheckedListValue`(CODE)를 3번 호출합니다. 조건 3개를 CODE 목록으로 전달하는 것으로 추정되지만 **확인 필요**입니다.
- 조회조건 패널: HidePanel 유형 (접기 가능)

## 2. 액션별 호출 API 후보

| 액션 | As-is | 호출 SP | TO-BE API 후보 |
|---|---|---|---|
| 화면 로드 | `Form_Load` | 확인 필요 (GetPlanGroupByUserID 호출 여부) | 조회조건 콤보 API (SCP0121_GET_SEARCH_INFO) |
| Division 변경 | `ClbDivision_SelectedIndexChanged` | 확인 필요 | Plan Group 콤보 재조회 |
| Plan Group 변경 | `CboPlanGroup_SelectedIndexChanged` | 확인 필요 | 확인 필요 |
| 조회 | FindButton → FindData_Main:321 | SCP0122_GET_PLAN_ACTIVITY_MGMT | call-proc 조회 |
| 저장 | SaveButton → Save_Data:480 → FindData_Main:321 | SCP0122_SAVE_PLAN_ACTIVITY_MGMT → 재조회 SCP0122_GET_PLAN_ACTIVITY_MGMT | call-proc 저장 + 성공 시 재조회 |
| 행 추가 | Insert_Row:367 (진입 버튼 **확인 필요**) | 없음 (조건 콤보 CODE를 읽음) | FE 행 추가. 조건값을 기본값으로 채우는지 **확인 필요** |
| 편집 | EditButton:275 (GetSheetInfo) | 없음 | 확인 필요 |
| 그리드 콤보 변경 | `SpdMain_ComboSelChange` | 확인 필요 | 확인 필요 |
| 그리드 셀 클릭 | `spdMain_CellClick` | 확인 필요 | 확인 필요 |
| 붙여넣기 | `SpdMain_ClipboardPasted`:574 (배선 **확인 필요**) | 없음 | Plan Group NAME → CODE 변환 (dtPlanGroup 기준) |

## 3. Division별 Grid 변형 요약

| 시트 | 구성 | Division 차이 |
|---|---|---|
| Plan Activity Mgmt | META 15컬럼 (SCM_MST_SHEET_COLUMNS) + 헤더 스타일 코드 | **없음** — 14개 division 모두 15컬럼 '기본' 표시 |

## 4. 권한(C/R/U/D) 관련 사실

| 구분 | 사실 |
|---|---|
| R | FindButton → SCP0122_GET_PLAN_ACTIVITY_MGMT |
| C | Insert_Row 메서드 있음. 저장 SP가 SCP_OPMZ_PLAN_GR_ACTV_M에 INSERT |
| U | SaveButton. 저장 SP가 SCP_OPMZ_PLAN_GR_ACTV_M에 UPDATE. EditButton 있음 |
| D | 저장 SP가 SCP_OPMZ_PLAN_GR_ACTV_M에 DELETE. 삭제 버튼 진입점은 Fact Pack에 없음 (**확인 필요**) |
| 메타 | TB_FX_GroupMenuAuth 3행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_SearchCondition 3행 존재. 행 내용(그룹·버튼 권한값)은 **확인 필요** |
| 사용자 컨텍스트 | GetPlanGroupByUserID에서 `FoxUserInfoContext.Current.NowGroupID` 사용 → Plan Group 목록이 사용자 그룹에 따라 달라질 가능성 |

## 5. 미확정 사항

1. 진입점 미연결 2건(SCP0121_GET_SEARCH_INFO, CommonDataList LookupCommon)의 실제 호출 시점
2. 5개 이벤트 핸들러의 본문 동작
3. Insert/Delete/Edit 버튼의 실제 노출 여부와 권한 메타값 (TB_FX_GroupMenuAuth 3행)
4. TB_FX_SearchCondition 3행이 조회조건 3개와 1:1로 대응하는지
5. 메인 조회 SP 결과 컬럼과 메타 15컬럼의 일치 여부 (SP 실행 결과 매칭 시트 없음)
6. 메타 컬럼별 편집 가능 여부·셀 유형·표시 순서 (SCM_MST_SHEET_COLUMNS 원문 확인 필요)
7. 저장 페이로드 형식 (SCM_ARR_SPL_CNT/VAL로 보아 구분자 문자열 가능성)
8. sln 미등록 프로젝트가 운영 대상인지

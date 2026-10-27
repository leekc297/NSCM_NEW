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

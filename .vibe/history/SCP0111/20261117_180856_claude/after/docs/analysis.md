# SCP0111 Integration PSI — As-is 분석

> 근거: AsisFacts 정적 추출 Fact Pack에 있는 사실만 썼습니다. 묶음에 없는 내용은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0111 |
| 화면명(Form Text) | `Integration PSI` (Designer.cs:905 `this.Text`) |
| 도메인 | SCP (프로젝트 경로 `GSCM.SCP.Forms.UIL\Analysis`) |
| 클래스 | `SCP0111_IntegrationPSI` |
| csproj | `06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.csproj` |

### 1-1. 파일 구성
| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `...\SCP0111_IntegrationPSI\Properties\AssemblyInfo.cs` | 37 |
| current | `...\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.cs` | 2136 |
| current | `...\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.Designer.cs` | 989 |
| shared | 없음 (Fact Pack에 없음) | - |
| legacy | 없음 (Fact Pack 본문에 legacy 행 없음) | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 |
|---|---|---:|---|---|
| Form_Load (`this.Load`) | Form_Load > InitControls > SetChangedPeriod | 287, 288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| Form_Load | Form_Load > CreateSpread > InitSpread > SetCalendar | 345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| Form_Load | Form_Load > GetEssPackLineAll | 490 | `SCP.SCP0111_GET_ESS_PACK_LINE` | MATCH |
| Form_Load | Form_Load > InitControls > GetBucketType | 1095 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH |
| CboDivision_SelectedIndexChanged | > SetChangedPeriod | 287, 288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| CboPlanDate_SelectedIndexChanged | > SetChangedPeriod | 287, 288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| CboPlanDate_SelectedIndexChanged | > InitSpread > SetCalendar | 345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| CboPlanType_SelectedIndexChanged | > SetChangedPeriod | 287, 288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| _defaultDataModel_Changed | (직접) | 1980 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| FindButton | FindButton > FindData_Main | 874 | `SCP.SCP0111_GET_INTEGRATION_PSI` | MATCH |
| FindButton | FindButton > FindData_Main > InitSpread > SetCalendar | 345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| EditButton | EditButton | 554 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| EditButton | EditButton | 622 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH |
| SaveButton | SaveButton > SaveData | 1154, 1242, 1511 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| SaveButton | SaveButton > SaveData | 1205 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH |
| SaveButton | SaveButton > SaveData | 1379 | `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN` | MATCH |
| SaveButton | SaveButton > SaveData | 1637 | `SCP.SCP0111_SAVE_INTEGRATION_PSI` | MATCH |
| SaveButton | SaveButton > SaveData > FindData_Main | 874 | `SCP.SCP0111_GET_INTEGRATION_PSI` (저장 후 재조회) | MATCH |
| SaveButton | SaveButton > SaveData > FindData_Main > InitSpread > SetCalendar | 345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| (진입점 미연결) | `<field:dtPeriod>` 필드 초기화 | 66 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH |

- SaveData 안에서 `SCP0111_SAVE_INTEGRATION_PSI_ADMIN`(1379)과 `SCP0111_SAVE_INTEGRATION_PSI`(1637)이 모두 호출됩니다. **둘 중 어느 쪽을 언제 타는지(분기 조건)는 Fact Pack에 없어 확인 필요**입니다. SaveData:1159에서 `FoxUserInfoContext.Current.NowGroupID`를 읽는 사실은 있지만, 이 값이 분기 조건인지는 확인되지 않았습니다.

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 테이블/객체 |
|---|---|---:|---|---|
| `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH | 8 | (UP_FX_GetCommonDataList 코드 분기) | SCM_SYS_CALENDAR_M |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 3 | (UP_FX_GetCommonDataList 코드 분기) | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | DM0003_GET_BUCKET_TYPE_CODE | SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCP.SCP0111_GET_ESS_PACK_LINE` | MATCH | 1 | SCP0111_GET_ESS_PACK_LINE | SCM_MST_LINE_OSP, SCM_MST_SITE |
| `SCP.SCP0111_GET_INTEGRATION_PSI` | MATCH | 1 | SCP0111_GET_INTEGRATION_PSI | SCP_ANL_PSI_INTEGRATION, SCP_MST_FINAL_ITEM, SCM_MST_ITEM_SN, #SCP_ANL_PSI_INTEGRATION_ITEM, STRING_SPLIT, 동적 SQL |
| `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN` | MATCH | 1 | SCP0111_SAVE_INTEGRATION_PSI_ADMIN | SCP_ANL_PSI_INTEGRATION(SELECT/UPDATE/INSERT), SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| `SCP.SCP0111_SAVE_INTEGRATION_PSI` | MATCH | 1 | SCP0111_SAVE_INTEGRATION_PSI | SCP_ANL_PSI_INTEGRATION 외 다수(oracle_migration.md §1 참조) |

## 4. 이벤트 배선 표

| 대상 | 이벤트 | 핸들러 | 배선 위치 |
|---|---|---|---|
| this | Load | `Form_Load` | .ctor:167 |
| btnNickName | Click | `BtnNickName_Click` | InitEvent:360 |
| btnItemId | Click | `BtnItemId_Click` | InitEvent:362 |
| spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:363 |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:364 |
| spdMain | CellClick | `spdMain_CellClick` | InitEvent:365 |
| cboDivision | SelectedIndexChanged | `CboDivision_SelectedIndexChanged` | InitEvent:367 |
| cboPlanDate | SelectedIndexChanged | `CboPlanDate_SelectedIndexChanged` | InitEvent:368 |
| cboPlanType | SelectedIndexChanged | `CboPlanType_SelectedIndexChanged` | InitEvent:369 |
| _defaultDataModel | Changed | `_defaultDataModel_Changed` | InitEvent:374 |

핸들러 동작 중 Fact Pack에 있는 것:
- `BtnNickName_Click`:1887 — `txtNickName.Text = sNickName`. 어떤 팝업이나 데이터 원천에서 값을 가져오는지는 확인 필요입니다.
- `BtnItemId_Click`:1926 — `txtItemId.Text = sItemId`. 원천은 확인 필요입니다.
- `spdMain_CellClick`:1781~1786 — `dtLine.Rows[i]`·`drLine`의 CODE와 NAME을 읽습니다. dtLine이 어디서 오는지(GetEssPackLineAll 결과인지)는 확인 필요입니다.
- `SpdMain_CellDoubleClick`, `SpdMain_TopChange` — 엔드포인트 호출도, 동작 사실도 Fact Pack에 없어 확인 필요입니다.
- btnCellItem_Id에는 Click 배선이 없습니다(Designer에서 Visible=false).

## 5. Grid 구성 방식

**구성 방식: `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`**

| 단계 | 메서드:줄 | 내용 |
|---|---|---|
| 시트 생성 | CreateSpread:299 | `AddSheet(spdMain, "Integration PSI", "Integration PSI", 1, 1, 35)` — 숫자 인자 3개의 의미는 확인 필요 |
| 시트 초기화 | InitSpread:312 | `InitSheet("Integration PSI")` |
| 메타 컬럼 | InitSpread:333 | `SetSheetHeaderColumn(spdInfo, 1)` → SCM_MST_SHEET_COLUMNS 메타(COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, VISIBLE_FLAG 등) |
| 화면 자체 메서드 | InitSpread:336 → SetSpreadColumn | 컬럼 Tag 접두가 `D_` 또는 `W_`면 숨김(392), `M_`이면 표시(396) |
| DB 루프 컬럼 | SetCalendar:354 | `dtCalendar`(CommonDataList CalendarMonth, 345)를 돌면서 `AddNumColumn(YYYYMM_NAME, YYYYMM, None, 75, true)`로 월 컬럼을 동적으로 추가 |
| 표시 전환 | SetVisibleSheetColumns:1069~1082 | 편집 모드 여부(`siMain.OF.IsEditMode`)에 따라 표시 전환(아래 표) |

SetVisibleSheetColumns 표시 전환:
| 컬럼 | IsEditMode = true | IsEditMode = false |
|---|---|---|
| SEQ_FLAG | 폭 60, 표시 | 폭 0, 숨김 |
| MEASURE | 폭 80, 표시 | 폭 0, 숨김 |
| PLANT_ID | 폭 65, 표시 | 폭 0, visible=true |
| TO_SITE | 폭 75, 표시 | 폭 0, visible=true |

### 5-1. Division별 차이
- 메타 규칙상 모든 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 **SHEET_COLUMNS 22/0, SHEET_MEASURE 7/0으로 같습니다**. division별 차이가 없습니다.
- 코드에 division 비교 분기가 없습니다(분기 판단 불가 0건).
- 최종 표시 컬럼은 division마다 22개입니다(grid_effective). 여기에는 동적 월 컬럼과 IsEditMode에 따른 숨김(SEQ_FLAG, MEASURE)이 반영되지 않았습니다. 그래서 **조회 모드의 실제 표시 수는 확인 필요**입니다.
- 실제 SP 실행 결과와 매칭되는 시트가 없습니다(grid 단계 미실행 또는 시트명 불일치).

## 6. 확인 필요 항목
1. SaveData에서 `SCP0111_SAVE_INTEGRATION_PSI_ADMIN` / `SCP0111_SAVE_INTEGRATION_PSI` 중 무엇을 타는지(분기 조건).
2. 4-2장에 SaveButton:816 → `PersonalSettingPopup.SaveData`로 해석된 호출이 있습니다. 화면 로컬 `SaveData`를 잘못 해석한 것인지 확인해야 합니다.
3. `RefreshPlanDate` / `RefreshPlanType` / `RefreshPlanSeq`가 쓰는 데이터 원천(dtPlanTypeFN 등)의 엔드포인트가 Fact Pack에 없습니다.
4. `InsertRow`(960, NowGroupID 읽음)가 어느 버튼이나 이벤트에서 진입하는지.
5. `SpdMain_CellDoubleClick` / `SpdMain_TopChange` 내부 동작.
6. 줄 66 `<field:dtPeriod>` LookupCommon 호출은 진입점과 연결되지 않았습니다(필드 초기화 시점에 실행되는지).
7. `usrButton1`(parent 없음, 75x23)을 실제로 쓰는지.
8. AddSheet 인자 `1, 1, 35`의 의미(헤더 행 수, 고정 컬럼 수 등).
9. TB_FX_SearchCondition 19행, TITLESET_USER 7행, GroupMenuAuth 4행의 내용.
10. 주석 처리된 호출(commented_calls)은 0건입니다.

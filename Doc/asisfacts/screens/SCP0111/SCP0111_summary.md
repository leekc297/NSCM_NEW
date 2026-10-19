# SCP0111 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0111_IntegrationPSI\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.csproj | 2136 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.csproj | 989 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:_defaultDataModel.Changed | _defaultDataModel_Changed | 1980 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedPeriod | 287 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedPeriod | 288 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > SetChangedPeriod | 287 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > SetChangedPeriod | 288 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > InitSpread > SetCalendar | 345 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged > SetChangedPeriod | 287 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged > SetChangedPeriod | 288 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| button:EditButton | EditButton | 554 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| button:EditButton | EditButton | 622 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main > InitSpread > SetCalendar | 345 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 874 | SCP.SCP0111_GET_INTEGRATION_PSI | MATCH | SP SCP0111_GET_INTEGRATION_PSI |
| button:SaveButton | SaveButton > SaveData > FindData_Main > InitSpread > SetCalendar | 345 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 874 | SCP.SCP0111_GET_INTEGRATION_PSI | MATCH | SP SCP0111_GET_INTEGRATION_PSI |
| button:SaveButton | SaveButton > SaveData | 1154 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1205 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1242 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1379 | SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN | MATCH | SP SCP0111_SAVE_INTEGRATION_PSI_ADMIN |
| button:SaveButton | SaveButton > SaveData | 1511 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1637 | SCP.SCP0111_SAVE_INTEGRATION_PSI | MATCH | SP SCP0111_SAVE_INTEGRATION_PSI |
| event:this.Load | Form_Load > InitControls > SetChangedPeriod | 287 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedPeriod | 288 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetCalendar | 345 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:this.Load | Form_Load > GetEssPackLineAll | 490 | SCP.SCP0111_GET_ESS_PACK_LINE | MATCH | SP SCP0111_GET_ESS_PACK_LINE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1095 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| unreached:(진입점 미연결) | <field:dtPeriod> | 66 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH | 8 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_SYS_CALENDAR_M |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0111_GET_ESS_PACK_LINE | MATCH | 1 | SP SCP0111_GET_ESS_PACK_LINE | EXEC:SCP0111_GET_ESS_PACK_LINE, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE |  |
| SCP.SCP0111_GET_INTEGRATION_PSI | MATCH | 1 | SP SCP0111_GET_INTEGRATION_PSI | EXEC:SCP0111_GET_INTEGRATION_PSI, SELECT:SCP_ANL_PSI_INTEGRATION, SELECT:SCP_MST_FINAL_ITEM, INSERT:#SCP_ANL_PSI_INTEGRATION_ITEM, SELECT:SCM_MST_ITEM_SN, REF:STRING_SPLIT, DYNAMIC@SCP0111_GET_INTEGRATION_PSI |  |
| SCP.SCP0111_SAVE_INTEGRATION_PSI | MATCH | 1 | SP SCP0111_SAVE_INTEGRATION_PSI | EXEC:SCP0111_SAVE_INTEGRATION_PSI, REF:FN_GET_LOOKUP_VALUE, INSERT:#ELEC_PLANT, SELECT:SCM_MST_SITE, INSERT:#CELL_ELEC_PLANT_MAPPING, SELECT:#ELEC_PLANT, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SCP_ANL_PSI_INTEGRATION, UPDATE:SCP_ANL_PSI_INTEGRATION, UPDATE:X, SELECT:SCP_ANL_PSI_INTEGRATION, SELECT:SCP_MST_BOM_ELEC, SELECT:SCM_MST_YIELD_VER_H_V, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:#CELL_ELEC_PLANT_MAPPING, SELECT:SCP_MST_CELL_PROD_ASSY_MAP, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCP_MST_FORMATION, SELECT:SCM_ADM_LOOKUP_MASTER, INSERT:#TMP_SCP_ANL_PSI_INTEGRATION_230, SELECT:#TMP_SCP_ANL_PSI_INTEGRATION_230, INSERT:#TMP_PSI_INTEGRATION_YIELD_VER_H_V_230, INSERT:#TMP_SCP_ANL_PSI_INTEGRATION_CELL, SELECT:SCM_MST_MODEL_FINAL_ITEM_BOM_V, SELECT:#TMP_PSI_INTEGRATION_YIELD_VER_H_V_230, SELECT:#TMP_SCP_ANL_PSI_INTEGRATION_CELL, SELECT:SCM_MST_BOM_EFFECTIVE_SN_V, SELECT:SCM_MST_ITEM_SN, INSERT:#TMP_PSI_INTEGRATION_YIELD_VER_H_V, SELECT:#TMP_PSI_INTEGRATION_YIELD_VER_H_V, SELECT:SCP_MST_TACT_TIME_OSP, INSERT:#TMP_YIELD_VER_H_V_A, INSERT:#TMP_SCP_ANL_PSI_INTEGRATION_530, SELECT:#TMP_YIELD_VER_H_V_A, SELECT:#TMP_SCP_ANL_PSI_INTEGRATION_530, INSERT:#TMP_TCO_NO_CA2_ITEM_PROD, SELECT:#TMP_TCO_NO_CA2_ITEM_PROD, INSERT:#TMP_PSI_INTEGRATION_750_SMALL, SELECT:SCP_MST_FORMATION_V, SELECT:#TMP_PSI_INTEGRATION_750_SMALL, INSERT:#TMP_PSI_INTEGRATION_350_SMALL, SELECT:#TMP_PSI_INTEGRATION_350_SMALL, INSERT:#TEM_SCP_ANL_PSI_INTEGRATION_350, SELECT:#TEM_SCP_ANL_PSI_INTEGRATION_350, CREATE:#TMP_PSI_INTEGRATION_230_ITEM_SMALL, INSERT:#TMP_PSI_INTEGRATION_230_ITEM_SMALL, SELECT:#TMP_PSI_INTEGRATION_230_ITEM_SMALL, INSERT:#TMP_PSI_INTEGRATION_SMALL_230, SELECT:#TMP_PSI_INTEGRATION_SMALL_230, INSERT:#TMP_PSI_INTEGRATION_SMALL_330, SELECT:#TMP_PSI_INTEGRATION_SMALL_330, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_CODE_LOOKUP_VALUE |  |
| SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN | MATCH | 1 | SP SCP0111_SAVE_INTEGRATION_PSI_ADMIN | EXEC:SCP0111_SAVE_INTEGRATION_PSI_ADMIN, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_ANL_PSI_INTEGRATION, UPDATE:SCP_ANL_PSI_INTEGRATION, INSERT:SCP_ANL_PSI_INTEGRATION, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| EditButton | TheOne.Security.FoxUserInfoContext.Current | NowGroupID |
| EditButton | dtMultiChildItem.Rows[i] | NAME |
| InsertRow | TheOne.Security.FoxUserInfoContext.Current | NowGroupID |
| RefreshPlanDate | dtPlanTypeFN.Rows[i] | PLANDATE |
| SaveData | TheOne.Security.FoxUserInfoContext.Current | NowGroupID |
| SaveData | dtTemp.Rows[0] | CODE |
| SaveData | dtToMonth.Rows[k] | CODE |
| SaveData | dtMonth.Rows[k] | CODE |
| SetChangedPeriod | dtPeriod.Rows[0] | CODE |
| SetChangedPeriod | dtScpPlanPeriod.Rows[0] | HORIZON_END_DATE |
| spdMain_CellClick | dtLine.Rows[i] | NAME, CODE |
| spdMain_CellClick | drLine | CODE, NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedPeriod:249, SetChangedPeriod:250, RefreshPlanDate:403, RefreshPlanType:438, RefreshPlanType:439, RefreshPlanSeq:448, RefreshPlanSeq:449, RefreshPlanSeq:450 | CString.GetCheckedListValue | CODE |
| DataBind | SetChangedPeriod:290, SetChangedPeriod:291 | UsrComboBox.DataBind | CODE, NAME |
| SetSheetHeaderColumn | InitSpread:333 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:816 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| OnShown | OnShown:1932 | BaseForm.OnShown | NowGroupID, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:167 |
| this.btnNickName | Click | BtnNickName_Click | InitEvent:360 |
| this.btnItemId | Click | BtnItemId_Click | InitEvent:362 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:363 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:364 |
| this.spdMain | CellClick | spdMain_CellClick | InitEvent:365 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:367 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:368 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:369 |
| _defaultDataModel | Changed | _defaultDataModel_Changed | InitEvent:374 |

## 6. 컨트롤 (41개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 12 | lblCombo1, lblCellItem, PlanDate, layoutControlItem3, lblItemId, layoutControlItem1, layoutControlItem4, lblNickName, layoutControlItem2, PlanType, layoutControlItem5, layoutControlItem6 |
| EmptySpaceItem | 11 | emptySpaceItem2, emptySpaceItem1, emptySpaceItem4, emptySpaceItem5, emptySpaceItem6, emptySpaceItem9, emptySpaceItem10, emptySpaceItem8, emptySpaceItem3, emptySpaceItem7, emptySpaceItem11 |
| UsrButton | 4 | usrButton1, btnNickName, btnCellItem_Id, btnItemId |
| UsrMultiLineEditor | 3 | txtNickName, txtCellItemId, txtItemId |
| UsrCombo | 3 | cboDivision, cboPlanDate, cboPlanType |
| UsrComboBox | 2 | cmbToMonth, cmbFromMonth |
| UsrConditionPanel | 1 | pnlCondition |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckBox | 1 | chkQty |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 196 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 24 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 7 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 7 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 5 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 19 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0111 | Integration PSI | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_MEASURE | SCP0111 | Integration PSI | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Integration PSI
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:333
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetCalendar |  | 354 | DB루프 | AddNumColumn | {?a.Field<string>(DefMain.YYYYMM_NAME)} | {?a.Field<string>(DefMain.YYYYMM)} | foreach(a in dtCalendar.AsEnumerable()) |
| SetSpreadColumn |  | 392 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 396 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetVisibleSheetColumns |  | 1069 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)} |  | if(siMain.OF.IsEditMode) |
| SetVisibleSheetColumns |  | 1070 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)} |  | if(siMain.OF.IsEditMode) |
| SetVisibleSheetColumns |  | 1072 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)} |  | if(siMain.OF.IsEditMode) |
| SetVisibleSheetColumns |  | 1073 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)} |  | if(siMain.OF.IsEditMode) |
| SetVisibleSheetColumns |  | 1078 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)} |  | else!(siMain.OF.IsEditMode) |
| SetVisibleSheetColumns |  | 1079 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)} |  | else!(siMain.OF.IsEditMode) |
| SetVisibleSheetColumns |  | 1081 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)} |  | else!(siMain.OF.IsEditMode) |
| SetVisibleSheetColumns |  | 1082 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)} |  | else!(siMain.OF.IsEditMode) |
| InitializeComponent |  | 858 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 859 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 860 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 861 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Integration PSI | META+코드연결 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

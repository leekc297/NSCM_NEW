# SCP0121 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_PlanGroupMaster.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\Properties\Resources.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_PlanGroupMaster.csproj | 72 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\Properties\Settings.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_PlanGroupMaster.csproj | 31 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_OwnerPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_PlanGroupMaster.csproj | 552 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_OwnerPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_PlanGroupMaster.csproj | 431 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_PlanGroupInfoPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_PlanGroupMaster.csproj | 436 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_PlanGroupInfoPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_PlanGroupMaster.csproj | 342 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_PlanGroupMaster.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_PlanGroupMaster.csproj | 971 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_PlanGroupMaster.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0121_PlanGroupMaster\SCP0121_PlanGroupMaster.csproj | 665 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > GetOwnerData | 283 | SCP.SCP0121_GET_OWNER_DATA_POPUP | MATCH | SP SCP0121_GET_OWNER_DATA_POPUP |
| button:FindButton | FindButton > FindData_PlanGroup | 421 | SCP.SCP0121_GET_PLAN_GROUP_LINE | MATCH | SP SCP0121_GET_PLAN_GROUP_LINE |
| button:SaveButton | SaveButton > SaveData > FindData | 225 | SCP.SCP0121_GET_PLAN_GROUP_POPUP | MATCH | SP SCP0121_GET_PLAN_GROUP_POPUP |
| button:SaveButton | SaveButton > SaveData | 314 | SCP.SCP0121_SAVE_PLAN_GROUP_POPUP | MATCH | SP SCP0121_SAVE_PLAN_GROUP_POPUP |
| button:SaveButton | SaveButton > Save_Data > FindData_PlanGroup | 421 | SCP.SCP0121_GET_PLAN_GROUP_LINE | MATCH | SP SCP0121_GET_PLAN_GROUP_LINE |
| button:SaveButton | SaveButton > Save_Data | 791 | SCP.SCP0121_SAVE_PLAN_GROUP_LINE | MATCH | SP SCP0121_SAVE_PLAN_GROUP_LINE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData > FindData | 225 | SCP.SCP0121_GET_PLAN_GROUP_POPUP | MATCH | SP SCP0121_GET_PLAN_GROUP_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > GetOwnerData | 283 | SCP.SCP0121_GET_OWNER_DATA_POPUP | MATCH | SP SCP0121_GET_OWNER_DATA_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData | 314 | SCP.SCP0121_SAVE_PLAN_GROUP_POPUP | MATCH | SP SCP0121_SAVE_PLAN_GROUP_POPUP |
| event:this.btnPlanGroupReg.Click | BtnPlanGroupReg_Click > GetSearchInfo | 169 | SCP.SCP0121_GET_SEARCH_INFO | MATCH | SP SCP0121_GET_SEARCH_INFO |
| event:this.Load | Form_Load > FindData | 225 | SCP.SCP0121_GET_PLAN_GROUP_POPUP | MATCH | SP SCP0121_GET_PLAN_GROUP_POPUP |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 226 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > GetOwnerData | 283 | SCP.SCP0121_GET_OWNER_DATA_POPUP | MATCH | SP SCP0121_GET_OWNER_DATA_POPUP |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| SCP.SCP0121_GET_OWNER_DATA_POPUP | MATCH | 1 | SP SCP0121_GET_OWNER_DATA_POPUP | EXEC:SCP0121_GET_OWNER_DATA_POPUP, SELECT:TB_FX_USER, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SSO_USER_INFO, SELECT:TB_FX_USERGROUPAUTHEXTENTION, REF:STRING_SPLIT, REF:UF_FX_STRING_SPLITFORIN, SELECT:SPLIT |  |
| SCP.SCP0121_GET_PLAN_GROUP_LINE | MATCH | 1 | SP SCP0121_GET_PLAN_GROUP_LINE | EXEC:SCP0121_GET_PLAN_GROUP_LINE, INSERT:#TEMP_PLAN_GROUP_LINE, SELECT:LINE_MASTER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:DIVISION_INFO, SELECT:SCP_OPMZ_PLAN_GR_LINE_M, REF:STRING_SPLIT, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:#TEMP_PLAN_GROUP_LINE, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE |  |
| SCP.SCP0121_GET_PLAN_GROUP_POPUP | MATCH | 1 | SP SCP0121_GET_PLAN_GROUP_POPUP | EXEC:SCP0121_GET_PLAN_GROUP_POPUP, SELECT:SCP_OPMZ_PLAN_GR_M |  |
| SCP.SCP0121_GET_SEARCH_INFO | MATCH | 1 | SP SCP0121_GET_SEARCH_INFO | EXEC:SCP0121_GET_SEARCH_INFO, INSERT:#DIVISION_INFO, SELECT:SCM_MST_DIVISION, INSERT:#LINE_MASTER, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#OSP_PLANT_INFO, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, SELECT:#LINE_MASTER, SELECT:#DIVISION_INFO, SELECT:SCP_MST_CAPA_LINE, SELECT:#OSP_PLANT_INFO, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_OPERATION_M_SN |  |
| SCP.SCP0121_SAVE_PLAN_GROUP_LINE | MATCH | 1 | SP SCP0121_SAVE_PLAN_GROUP_LINE | EXEC:SCP0121_SAVE_PLAN_GROUP_LINE, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SCP_OPMZ_PLAN_GR_LINE_M, UPDATE:SCP_OPMZ_PLAN_GR_LINE_M, DELETE:SCP_OPMZ_PLAN_GR_LINE_M, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0121_SAVE_PLAN_GROUP_POPUP | MATCH | 1 | SP SCP0121_SAVE_PLAN_GROUP_POPUP | EXEC:SCP0121_SAVE_PLAN_GROUP_POPUP, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_OPMZ_PLAN_GR_M, EXEC:SCP0121_SCP_OPMZ_PLAN_GR_M_HIST, INSERT:SCP_OPMZ_PLAN_GR_M, UPDATE:SCP_OPMZ_PLAN_GR_M, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_OPMZ_PLAN_GR_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitControls | TheOne.Security.FoxUserInfoContext.Current | NowGroupID |
| SpdMain_ClipboardPasted | dtPlanGroup.Select().Where(c => c["NAME"].ToString() == siMain.ActiveSheet.Cells[iRow, iCol].Text).FirstOrDefault() | CODE |
| SpdMain_ClipboardPasted | c | NAME |
| spdUser_ButtonClicked | sv.Columns | SUB_TOTAL_FLAG |
| spdUser_RowDragMove | sv.Columns | USER_SELECTABLE_FLAG |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:168 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:169 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SetSheetHeaderColumn | InitSpread:155 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:195 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | RefreshOperationByDivision:184, RefreshPlantIdByDivision:208, RefreshBuildingByPlantId:217, RefreshLine:225, RefreshLine:226, RefreshLine:227, RefreshLine:228, RefreshPlanGroupByDivision:247 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumnSCP | SetSpreadInit:306 | SpreadInfo.SetSheetHeaderColumnSCP | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.usrButtonList1 | UsrButtonList_Click_Detected | usrButtonList1_UsrButtonList_Click_Detected | InitializeComponent:158 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:210 |
| this.spdBase | CellDoubleClick | spdBase_CellDoubleClick | InitializeComponent:310 |
| this.spdUser | RowDragMove | spdUser_RowDragMove | InitializeComponent:329 |
| this.spdUser | CellDoubleClick | spdUser_CellDoubleClick | InitializeComponent:331 |
| this.spdUser | ButtonClicked | spdUser_ButtonClicked | InitializeComponent:332 |
| this.btnRight | Click | btnRight_Click | InitializeComponent:365 |
| this.btnLeft | Click | btnLeft_Click | InitializeComponent:375 |
| this | Load | Form_Load | InitializeComponent:389 |
| this | SizeChanged | TitleSetForm_SizeChanged | InitializeComponent:390 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:179 |
| this | FormClosing | SCP0121_PlanGroupInfoPopup_FormClosing | InitializeComponent:301 |
| this | Load | Form_Load | .ctor:90 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:164 |
| this | Load | Form_Load | .ctor:104 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:313 |
| clbOperation | SelectedIndexChanged | ClbOperation_SelectedIndexChanged | InitEvent:314 |
| clbPlant | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:315 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:316 |
| clbPlanGroup | SelectedIndexChanged | ClbPlanGroup_SelectedIndexChanged | InitEvent:317 |
| this.btnPlanGroupReg | Click | BtnPlanGroupReg_Click | InitEvent:318 |
| this.spdMain | CellClick | spdMain_CellClick | InitEvent:320 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:321 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:324 |

## 6. 컨트롤 (53개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | layoutControlItem3, layoutControlItem2, layoutControlItem2, layoutControlItem6, layoutControlItem9, layoutControlItem4, Division, lciBtnPlanGroupReg, layoutControlItem5 |
| LayoutControlGroup | 5 | layoutControlGroup1, layoutControlGroup2, Root, layoutControlGroup1, layoutControlGroup2 |
| UsrCheckedList2 | 5 | clbPlanGroup, clbLine, clbOperation, clbBuilding, clbPlant |
| Panel | 4 | pnlBottom, pnlSearch, pnlCenter, pnlCenterButton |
| UsrButtonList | 4 | usrButtonList2, usrButtonList1, btnButtonList, btnButtonList |
| FpSpread | 4 | spdBase, spdUser, spdMain, spdMain |
| SheetView | 4 | spdBase_Sheet1, spdUser_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem1, emptySpaceItem5 |
| Button | 2 | btnRight, btnLeft |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrTextBox | 1 | txtSearch |
| UsrLabel | 1 | usrLabel1 |
| SplitContainer | 1 | splMain |
| Label | 1 | lblDivision |
| UsrButton | 1 | btnPlanGroupReg |
| UsrCombo | 1 | cboDivision |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 62 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 10 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 19 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0121 | Plan Group Master | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 |
| SCM_MST_SHEET_COLUMNS | SCP0121 | PlanGroupInfoPopup | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Owner Base, Owner User, PlanGroupInfoPopup, Plan Group Master
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:169, SetSheetHeaderColumn@InitSpread:155, SetSheetHeaderColumnSCP@SetSpreadInit:306

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetTitleSet |  | 420 | 표시/라벨 변경 | set:Text | Text = {?sUserID} |  | foreach(i in selectIndex.Keys) |
| SetTitleSet |  | 421 | 표시/라벨 변경 | set:Text | Text = {?sUserName} |  | foreach(i in selectIndex.Keys) |
| SetTitleSet |  | 422 | 표시/라벨 변경 | set:Text | Text = {?sDEPT_NAME_KO} |  | foreach(i in selectIndex.Keys) |
| SetTitleSet |  | 423 | 표시/라벨 변경 | set:Text | Text = {?sSortOrderNo} |  | foreach(i in selectIndex.Keys) |
| SetTitleSet |  | 424 | 표시/라벨 변경 | set:Text | Text = {?sUserSelectedFlag} |  | foreach(i in selectIndex.Keys) |
| SetTitleSet |  | 425 | 표시/라벨 변경 | set:Text | Text = {?sUSER_NAME_EN} |  | foreach(i in selectIndex.Keys) |
| InitializeComponent |  | 269 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 270 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 271 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 272 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 566 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 567 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 568 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 569 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Plan Group Master | META+코드연결 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
| PlanGroupInfoPopup | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

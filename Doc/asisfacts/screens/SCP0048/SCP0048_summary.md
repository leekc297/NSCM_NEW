# SCP0048 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0048_ProjectRoute_Warranty\POPUP\SCP0048_ItembyDivisionPopupEx.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0048_ProjectRoute_Warranty\SCP0048_ProjectRoute_Warranty.csproj | 564 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0048_ProjectRoute_Warranty\POPUP\SCP0048_ItembyDivisionPopupEx.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0048_ProjectRoute_Warranty\SCP0048_ProjectRoute_Warranty.csproj | 606 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0048_ProjectRoute_Warranty\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0048_ProjectRoute_Warranty\SCP0048_ProjectRoute_Warranty.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0048_ProjectRoute_Warranty\SCP0048_ProjectRoute_Warranty.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0048_ProjectRoute_Warranty\SCP0048_ProjectRoute_Warranty.csproj | 1775 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0048_ProjectRoute_Warranty\SCP0048_ProjectRoute_Warranty.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0048_ProjectRoute_Warranty\SCP0048_ProjectRoute_Warranty.csproj | 496 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 195 | biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 339 | DM_H.SCM0002_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | SP SCM0002_GET_ITEM_BY_DIVISION_POPUPEx |
| button:FindButton | FindButton > FindData | 371 | SCP.SCP0048_GET_ProjectRoute_Warranty | MATCH | SP SCP0048_GET_PROJECTROUTE_WARRANTY |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 422 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 371 | SCP.SCP0048_GET_ProjectRoute_Warranty | MATCH | SP SCP0048_GET_PROJECTROUTE_WARRANTY |
| button:SaveButton | SaveButton > SaveData | 598 | SCP.SCP0048_SAVE_PROJECTROUTE_Warranty | MATCH | SP SCP0048_SAVE_PROJECTROUTE_WARRANTY |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 339 | DM_H.SCM0002_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | SP SCM0002_GET_ITEM_BY_DIVISION_POPUPEx |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > InitSpread > GetSpdTitle | 422 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetDivisionbyScmSite | 515 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls | 162 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 164 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 169 | biz:CommonData.CommonDataList [code=PERIOD_ \|\| PERIOD_DEFAULT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 195 | biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 422 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > SetChangedPeriod | 427 | biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH |  |
| event:this.txtItemID.KeyDown | txtItemID_KeyDown > FindButton > FindData | 339 | DM_H.SCM0002_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | SP SCM0002_GET_ITEM_BY_DIVISION_POPUPEx |
| event:this.txtItemID.KeyDown | txtItemID_KeyDown > FindButton > FindData > InitSpread > GetSpdTitle | 422 | DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DM0000_GET_COMMON_SPREAD_TITLE |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 47 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetDivision | 501 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 532 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetEndCustomerbyDivision | 546 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PERIOD_ \|\| PERIOD_DEFAULT] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP:REF:STRING_SPLIT |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| DM_H.DM0000_GET_COMMON_SPREAD_TITLE | MATCH | 1 | SP DM0000_GET_COMMON_SPREAD_TITLE | EXEC:DM0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| DM_H.SCM0002_GET_ITEM_BY_DIVISION_POPUPEx | MATCH | 1 | SP SCM0002_GET_ITEM_BY_DIVISION_POPUPEx | EXEC:SCM0002_GET_ITEM_BY_DIVISION_POPUPEX, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:UF_FX_STRING_SPLITFORIN, REF:UF_FX_STRING_SPLIT, SELECT:SPLIT |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCP.SCP0048_GET_ProjectRoute_Warranty | MATCH | 1 | SP SCP0048_GET_PROJECTROUTE_WARRANTY | EXEC:SCP0048_GET_PROJECTROUTE_WARRANTY, REF:FN_CHAR_TO_DATE, REF:FN_GET_ITEM_NICKNAME, SELECT:SCP_MST_TACT_TIME, SELECT:SCM_MST_LINE_SN, REF:STRING_SPLIT, SELECT:SCP_MST_OUTSOURCING_CAPA, SELECT:SCP_MST_TACT_TIME_OSP, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_PROJECT |  |
| SCP.SCP0048_SAVE_PROJECTROUTE_Warranty | MATCH | 1 | SP SCP0048_SAVE_PROJECTROUTE_WARRANTY | EXEC:SCP0048_SAVE_PROJECTROUTE_WARRANTY, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCM_MST_SITE_ITEM, EXEC:PR_SCM_MST_SITE_ITEM_HIST, EXEC:PR_SCM_MST_SITE_ITEM_PRIORITY_HIST, MERGE:SCM_MST_SITE_ITEM, UPDATE:SCM_MST_SITE_ITEM_PRIORITY, INSERT:SCM_MST_SITE_ITEM_PRIORITY, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_MST_SITE_ITEM_H, INSERT:SCM_MST_SITE_ITEM_PRIORITY_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitControls | UserInfoContext.Current | NowGroupID |
| spdMain_Change | drs[0] | nick_name |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:222, InitControls:227, FindData:341, SetChangedControl:193, FindData:352, FindData:353, FindData:354, InsertRow:457 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:268 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:269 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| DataBind | InitControls:162 | UsrComboBox.DataBind | CODE, NAME |
| SetSheetHeaderColumn | InitSpread:217 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:240 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.txtItemID | KeyDown | txtItemID_KeyDown | InitializeComponent:130 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:170 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:264 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:504 |
| this | Load | Form_Load | .ctor:156 |
| this | Load | Form_Load | .ctor:118 |
| cboOperationGroup | SelectedIndexChanged | cboOperationGroup_SelectedIndexChanged | InitEvent:146 |
| dsdm | Changed | spdMain_Change | InitEvent:150 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitControls:171 |
| this.btnItemId | Click | btnItemId_Click | InitControls:173 |
| spdMain | CellClick | SpdMain_CellClick | InitControls:175 |
| spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitControls:176 |
| dsdm | Changed | spdMain_Change | SpdMain_ClipboardPasted:703 |
| dsdm | Changed | spdMain_Change | SpdMain_ClipboardPasted:714 |
| dsdm | Changed | spdMain_Change | SpdMain_CellClick:967 |
| dsdm | Changed | spdMain_Change | SpdMain_CellClick:1008 |

## 6. 컨트롤 (44개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 13 | layoutControlItem1, lblDivision, Team, lblDivision2, lblScmSite, lblProject, layoutControlItem2, layoutControlItem2, layoutControlItem11, layoutControlItem9, layoutControlItem1, layoutControlItem3, layoutControlItem4 |
| UsrCheckedList | 6 | clbDivision, clbScmSite, clbTeam, clbEndCustomer, clbPlantSite, clbDivision |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 3 | emptySpaceItem2, emptySpaceItem1, emptySpaceItem1 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| TextBox | 2 | txtItemID, txtItemId |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrButtonList | 1 | btnButtonList |
| UsrMultiLineEditor | 1 | txtProject |
| UsrComboBox | 1 | cboValid |
| UsrButton | 1 | btnItemId |
| UsrCombo | 1 | cboOperationGroup |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 6 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 31 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 8 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 502 | DM.Get_Division | commented:NOT_IN_FOXQUERY |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0048 | Main | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: ItemPopup, Main
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:269, SetSheetHeaderColumn@InitSpread:217

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 520 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 521 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 522 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 523 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 406 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 407 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 408 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 409 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

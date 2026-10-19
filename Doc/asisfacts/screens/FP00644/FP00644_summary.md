# FP00644 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00644_Group_Cell_Mgmt.UIL\FP00644_Group_Cell_Mgmt.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00644_Group_Cell_Mgmt.UIL\FP00644_Group_Cell_Mgmt.UIL.csproj | 1271 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00644_Group_Cell_Mgmt.UIL\FP00644_Group_Cell_Mgmt.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00644_Group_Cell_Mgmt.UIL\FP00644_Group_Cell_Mgmt.UIL.csproj | 928 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00644_Group_Cell_Mgmt.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00644_Group_Cell_Mgmt.UIL\FP00644_Group_Cell_Mgmt.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboNewItem.SelectedIndexChanged | CboNewItem_SelectedIndexChanged > SetChangedControl | 243 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cboNewItem.SelectedIndexChanged | CboNewItem_SelectedIndexChanged > SetChangedControl | 249 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboNewItem.SelectedIndexChanged | CboNewItem_SelectedIndexChanged > SetChangedControl | 261 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cboNewItem.SelectedIndexChanged | CboNewItem_SelectedIndexChanged > SetChangedControl | 271 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 243 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 249 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 261 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 271 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 243 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 249 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 261 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 271 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangedControl | 243 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangedControl | 249 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangedControl | 261 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangedControl | 271 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Main > Save_Data_Execute | 937 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00644] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Main > Save_Data_Execute | 937 | FP\Master\FP00644_GroupCellMgmt#merge_FP00644 | MATCH | [update-batch]  |
| event:this.Load | Form_Load > InitControls | 211 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 214 | biz:FPCommonDataBLL.YesNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 243 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 249 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 261 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 271 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 2 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00644] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.YesNo | BIZ_MATCH | 1 |  |  |  |
| FP\Master\FP00644_GroupCellMgmt#merge_FP00644 | MATCH | 1 | [update-batch]  | MERGE:SCM_GROUP_CELL_M, REF:FN_SITE_TIME, INSERT:HIS_GROUP_CELL_M, REF:SYSDATE1, SELECT:SCM_GROUP_CELL_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| EditButton | row | EDIT_YN |
| GetSearchCondition | dRow | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, GROUP_CELL_ID |
| SetBackColor | row | SAME_GROUP_CELL_FLAG |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:241, SetChangedControl:247, SetChangedControl:258, SetChangedControl:269, SetChangedControl:277, SetChangedControl:278, SetChangedControl:279, SetChangedControl:280 | CString.GetCheckedListValue | CODE |
| SetFilter | SetChangedControl:277, SetChangedControl:278, SetChangedControl:279, SetChangedControl:280, Find_Data_Sub_Execute:779, Find_Data_Sub_Execute:780, Find_Data_Sub_Execute:781, Find_Data_Sub_Execute:782 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetChanges | Save_Data_Execute:933 | FPExtensions.GetChanges | ROW_ID |
| FP_UpdateBatch | Save_Data_Execute:937 | DataService.FP_UpdateBatch | COUNT, RESULT |
| GetSearchCondition | RunSqlSource:1202, lfn_SearchDetailGrid:1214 | BaseForm.GetSearchCondition | ControlName, ControlValue |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | Change | spdMain_Change | InitializeComponent:115 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitializeComponent:116 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:253 |
| this.spdSub | CellClick | spdSub_CellClick | InitializeComponent:729 |
| this | Load | Form_Load | .ctor:129 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:155 |
| clbSite | SelectedIndexChanged | ClbSite_SelectedIndexChanged | InitEvent:156 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:157 |
| cboNewItem | SelectedIndexChanged | CboNewItem_SelectedIndexChanged | InitEvent:158 |
| txtCell | TextChanged | cell_changed | InitEvent:161 |
| txtCellName | TextChanged | cell_name_changed | InitEvent:162 |
| txtGroupCell | TextChanged | group_cell_changed | InitEvent:163 |
| txtGroupCellName | TextChanged | group_cell_name_changed | InitEvent:164 |
| popSql | OnSql | RunSqlSource | btnSql_Click:532 |

## 6. 컨트롤 (34개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | lblDivision, layoutControlItem4, lblSite, layoutControlItem5, lblPlant, layoutControlItem3, lblSql, layoutControlItem7, layoutControlItem6 |
| UsrTextBox | 4 | txtCellName, txtGroupCellName, txtGroupCell, txtCell |
| EmptySpaceItem | 4 | emptySpaceItem2, emptySpaceItem5, emptySpaceItem3, emptySpaceItem7 |
| UsrCheckedList2 | 3 | clbPlant, clbSite, clbDivision |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl3 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup3 |
| UsrCombo | 1 | cboNewItem |
| UsrButton | 1 | btnSql |
| ImageList | 1 | imageList1 |
| Panel | 1 | StockPanel |
| Splitter | 1 | splitter1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 28 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00644 | Main | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |
| SCM_MST_SHEET_COLUMNS | FP00644 | Sub | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main, Sub
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:310, SetSheetHeaderColumn_FP@InitSpread:318

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| Find_Main | Main | 631 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 132 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 133 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 134 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 135 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 745 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 746 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 747 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 748 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |
| Sub | META+코드연결 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

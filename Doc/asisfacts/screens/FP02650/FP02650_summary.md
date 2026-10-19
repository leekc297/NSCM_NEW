# FP02650 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Master.UIL\FP02650_SlurryBatchGroup_Master.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 2211 |
| only | 06.UIL\GSCM.FP.Master.UIL\FP02650_SlurryBatchGroup_Master.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 900 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged | 1806 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 240 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 247 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Main > Find_Data_Main | 686 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |
| button:FindButton | FindButton > Find_Main > Find_Sub > Find_Data_Sub | 812 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |
| event:popSql.OnSql | RunSqlSource > Find_Data_Main | 686 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |
| event:popSql.OnSql | RunSqlSource > Find_Data_Sub | 812 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |
| event:popSql.OnSql | RunSqlSource > Save_GroupMasterData_Main | 1055 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Save_GroupMasterData_Main | 1132 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |
| event:popSql.OnSql | RunSqlSource > Save_Data_Sub | 1594 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |
| event:popSql.OnSql | RunSqlSource > Find_Data_Main_By_Ratio | 1672 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |
| button:SaveButton | SaveButton > Find_Main > Find_Data_Main | 686 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |
| button:SaveButton | SaveButton > Find_Main > Find_Sub > Find_Data_Sub | 812 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |
| button:SaveButton | SaveButton > Save_Main > Save_GroupMasterData_Main | 1055 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| button:SaveButton | SaveButton > Save_Main > Save_GroupMasterData_Main | 1132 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |
| button:SaveButton | SaveButton > Save_Main > Update_DataDetail_Main | 1321 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |
| button:SaveButton | SaveButton > Save_Sub > Save_Data_Sub | 1594 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |
| event:this.Load | Form_Load > InitControls | 199 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 240 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 247 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > Find_Sub > Find_Data_Sub | 812 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |
| event:this.spdSub.CellDoubleClick | SpdSub_CellDoubleClick > Find_Data_Main_By_Ratio | 1672 | FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 2 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | 1 | SP PR_UI_FP_MASTER_FORM_CODE | EXEC:PR_UI_FP_MASTER_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | MATCH | 6 | SP PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | EXEC:PR_UI_FP02650_SLURRYBATCHGROUP_MASTER | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| Save_GroupMasterData_Main | dtNewBatchRatio.Rows[0] | RATIO_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:237, SetChangedControl:244, Find_Data_Main:675, Find_Data_Main:676, Find_Data_Main:677, CboSite_SelectedIndexChanged:1797, CboSite_SelectedIndexChanged:1802, RunSqlSource:2171 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitializeComponent:119 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:120 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:435 |
| this.spdSub | CellClick | spdSub_CellClick | InitializeComponent:644 |
| this.spdSub | CellDoubleClick | SpdSub_CellDoubleClick | InitializeComponent:645 |
| this | Load | Form_Load | .ctor:135 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:159 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:160 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1770 |

## 6. 컨트롤 (29개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 8 | layoutControlItem1, Site, layoutControlItem9, layoutControlItem2, layoutControlItem3, layoutControlItem4, layoutControlItem10, lblSql |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl3 |
| UsrTextBox | 2 | txtNickName, txtItemID |
| UsrCheckedList2 | 2 | clbPlant, clbDivision |
| UsrLabel | 2 | usrLabel3, usrLabel1 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup3 |
| ImageList | 1 | imageList1 |
| UsrButton | 1 | btnSql |
| UsrCombo | 1 | cboSite |
| EmptySpaceItem | 1 | emptySpaceItem7 |
| Panel | 1 | StockPanel |
| Splitter | 1 | splitter1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 51 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP02650 | spdMain | 43/0 | 43/0 | 43/0 | 43/0 | 43/0 | 43/0 | 43/0 | 43/0 | 43/0 | 43/0 | 43/0 | 43/0 | 43/0 | 43/0 |
| SCM_MST_SHEET_COLUMNS | FP02650 | spdSub | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: spdMain, spdSub
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:280, SetSheetHeaderColumn_FP@InitSpread:295

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 287 | 표시/라벨 변경 | set:Visible | Visible = {?false} | EDIT_YN | if(spreadInfo.SheetName == "spdMain") |
| Find_Main | spdMain | 660 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| Find_Sub | spdSub | 801 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 136 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 137 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 138 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 139 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 661 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 662 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 663 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 664 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| spdMain | META+코드연결 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 |
| spdSub | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

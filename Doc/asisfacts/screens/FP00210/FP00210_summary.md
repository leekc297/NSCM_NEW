# FP00210 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00210_BOM.UIL\FP00210_BOM.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00210_BOM.UIL\FP00210_BOM.UIL.csproj | 953 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00210_BOM.UIL\FP00210_BOM.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00210_BOM.UIL\FP00210_BOM.UIL.csproj | 826 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00210_BOM.UIL\FP00210_BOMViewPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00210_BOM.UIL\FP00210_BOM.UIL.csproj | 338 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00210_BOM.UIL\FP00210_BOMViewPopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00210_BOM.UIL\FP00210_BOM.UIL.csproj | 112 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00210_BOM.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00210_BOM.UIL\FP00210_BOM.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00210_BOM.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00210_BOM.UIL\FP00210_BOM.UIL.csproj | 74 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00210_BOM.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 827 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00210_BOM.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 820 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00210_BOMViewPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 299 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00210_BOMViewPopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 112 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 221 | FP_Master.PR_UI_FP00210_BOM | MATCH | SP PR_UI_FP00210_BOM |
| button:FindButton | FindButton > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 561 | FP_Master.PR_UI_FP00210_BOM | MATCH | SP PR_UI_FP00210_BOM |
| button:FindButton | FindButton > Find_Data > Find_Data_Execute | 631 | FP_Master.PR_UI_FP00210_BOM | MATCH | SP PR_UI_FP00210_BOM |
| event:popSql.OnSql | RunSqlSource > Find_Data_Execute | 631 | FP_Master.PR_UI_FP00210_BOM | MATCH | SP PR_UI_FP00210_BOM |
| event:this.Load | Form_Load > FindData | 221 | FP_Master.PR_UI_FP00210_BOM | MATCH | SP PR_UI_FP00210_BOM |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 561 | FP_Master.PR_UI_FP00210_BOM | MATCH | SP PR_UI_FP00210_BOM |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| FP_Master.PR_UI_FP00210_BOM | MATCH | 3 | SP PR_UI_FP00210_BOM | EXEC:PR_UI_FP00210_BOM | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnBom_Click | Filter | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PARENT_ITEM_ID, CHILD_ITEM_ID, PARENT_NICK_NAME, CHILD_NICK_NAME |
| FindData | Filter | DIVISION_ID, SITE_ID, PLANT_ID |
| GetDivision | Filter | USER_ID |
| GetSearchCondition | dRow | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PARENT_ITEM_ID |
| SetChangeControl | Filter | DIVISION_ID, SITE_ID, PLANT_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | Find_Data_Sub_Execute:526, Find_Data_Sub_Execute:527, Find_Data_Sub_Execute:528, Find_Data_Execute:606, Find_Data_Execute:607, Find_Data_Execute:608, btnBom_Click:868, btnBom_Click:869 | CString.GetCheckedListValue | CODE |
| GetSearchCondition | lfn_SearchDetailGrid:761 | BaseForm.GetSearchCondition | ControlName, ControlValue |
| GetInnerTable | SetChangeControl:908, SetChangeControl:917, SetChangeControl:928, GetDivision:947 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:135 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:250 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:252 |
| clbSite | SelectedIndexChanged | ClbSite_SelectedIndexChanged | InitEvent:253 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:254 |
| popSql | OnSql | RunSqlSource | btnSql_Click:358 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:456 |
| this.btnBom | Click | btnBom_Click | InitializeComponent:468 |
| this | Load | Form_Load | .ctor:88 |

## 6. 컨트롤 (34개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | lblSql, lblBomView, lblPlant, lblSite, lblChildNickName, lblDivision, lblChildItemId, lblParentNickName, lblParentItem |
| UsrTextBox | 4 | txtParentItemId, txtParentNickName, txtChildItemId, txtChildNickName |
| UsrCheckedList2 | 3 | clbSite, clbPlant, clbDivision |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3 |
| FpSpread | 3 | spdMain, spdSub, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdSub_Sheet1, spdMain_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrButton | 1 | btnSql |
| SimpleButton | 1 | btnBom |
| ImageList | 1 | imgList |
| SplitContainer | 1 | splitContainer1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 5 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 32 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 17 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 15 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00210 | Alternate BOM | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |
| SCM_MST_SHEET_COLUMNS | FP00210 | Main | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main, Alternate BOM, BOM View
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:287, SetSheetHeaderColumn_FP@InitSpread:295

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 642 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 643 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 644 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 645 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 720 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 721 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 722 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 723 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| Form_Load |  | 96 | 표시/라벨 변경 | set:Width | Width = 56 |  |  |
| InitSpread |  | 129 | 하드코딩 | AddTextColumn | Division | DIVISION_ID |  |
| InitSpread |  | 130 | 하드코딩 | AddTextColumn | Site | SITE_ID |  |
| InitSpread |  | 131 | 하드코딩 | AddTextColumn | Model | MODEL_ID |  |
| InitSpread |  | 132 | 하드코딩 | AddTextColumn | PJT Code | NICK_NAME |  |
| InitSpread |  | 133 | 하드코딩 | AddTextColumn | Assembly | PARENT_ITEM_ID |  |
| InitSpread |  | 134 | 하드코딩 | AddTextColumn | Category Name | CATEGORY_NAME |  |
| InitSpread |  | 135 | 하드코딩 | AddTextColumn | Part No | CHILD_ITEM_ID |  |
| InitSpread |  | 136 | 하드코딩 | AddTextColumn | Description | DESCRIPTION |  |
| InitSpread |  | 137 | 하드코딩 | AddTextColumn | SPEC | SPEC |  |
| InitSpread |  | 138 | 하드코딩 | AddTextColumn | QTY | QTY |  |
| InitSpread |  | 139 | 하드코딩 | AddTextColumn | UOM | ITEM_UOM |  |
| InitSpread |  | 140 | 하드코딩 | AddTextColumn | Active | ACTIVE_FLAG |  |
| InitSpread |  | 141 | 하드코딩 | AddDateTextColumn | DATE | DATE |  |
| InitializeComponent |  | 64 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 65 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 66 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 67 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Alternate BOM | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |
| BOM View | 코드 하드코딩 전용(메타 없음) | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |
| Main | META+코드연결 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

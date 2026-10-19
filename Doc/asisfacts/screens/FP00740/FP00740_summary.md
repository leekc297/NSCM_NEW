# FP00740 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00740_Theory_Stock.UIL\FP00740_Theory_Stock.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00740_Theory_Stock.UIL\FP00740_Theory_Stock.UIL.csproj | 1085 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00740_Theory_Stock.UIL\FP00740_Theory_Stock.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00740_Theory_Stock.UIL\FP00740_Theory_Stock.UIL.csproj | 701 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00740_Theory_Stock.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00740_Theory_Stock.UIL\FP00740_Theory_Stock.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00740_Theory_Stock.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00740_Theory_Stock.UIL\FP00740_Theory_Stock.UIL.csproj | 84 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboFactory.SelectedIndexChanged | CboFactory_SelectedIndexChanged | 740 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboFactory.SelectedIndexChanged | CboFactory_SelectedIndexChanged | 740 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboFactory.SelectedIndexChanged | CboFactory_SelectedIndexChanged > SetChangeControl | 1004 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboFactory.SelectedIndexChanged | CboFactory_SelectedIndexChanged > SetChangeControl | 1004 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboFactory.SelectedIndexChanged | CboFactory_SelectedIndexChanged > SetChangeControl | 1018 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboFactory.SelectedIndexChanged | CboFactory_SelectedIndexChanged > SetChangeControl | 1018 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboLine.SelectedIndexChanged | CboLine_SelectedIndexChanged > SetChangeControl | 1004 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboLine.SelectedIndexChanged | CboLine_SelectedIndexChanged > SetChangeControl | 1004 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboLine.SelectedIndexChanged | CboLine_SelectedIndexChanged > SetChangeControl | 1018 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboLine.SelectedIndexChanged | CboLine_SelectedIndexChanged > SetChangeControl | 1018 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbInstance.SelectedIndexChanged | ClbInstance_SelectedIndexChanged > SetChangeControl | 1004 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbInstance.SelectedIndexChanged | ClbInstance_SelectedIndexChanged > SetChangeControl | 1004 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbInstance.SelectedIndexChanged | ClbInstance_SelectedIndexChanged > SetChangeControl | 1018 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbInstance.SelectedIndexChanged | ClbInstance_SelectedIndexChanged > SetChangeControl | 1018 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 733 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 733 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 1004 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 1004 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 1018 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 1018 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:popSql.OnSql | RunSqlSource > Save_Data_Test | 623 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00740] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Test | 623 | FP\Master\FP00740_Theory_Stock#merge_FP00740 | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Test | 623 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00740] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Test | 623 | FP\Master\FP00740_Theory_Stock#merge_FP00740 | MATCH | [update-batch]  |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 733 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 733 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > CboFactory_SelectedIndexChanged | 740 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > CboFactory_SelectedIndexChanged | 740 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > CboLine_SelectedIndexChanged > SetChangeControl | 1004 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > CboLine_SelectedIndexChanged > SetChangeControl | 1004 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > CboLine_SelectedIndexChanged > SetChangeControl | 1018 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > CboLine_SelectedIndexChanged > SetChangeControl | 1018 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > GetFactory | 1070 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetFactory | 1070 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 5 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00740] | BIZ_MATCH | 1 |  |  |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 5 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Master\FP00740_Theory_Stock#merge_FP00740 | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| Find_Data_Line | Filter | INSTANCE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, CHK_LINE_ASSIGN |
| GetFactory | Filter | USER_ID |
| GetInstance | Filter | AMEND_INSTANCE, USER_ID |
| GetLine | Filter | USER_ID |
| GetPlant | Filter | USER_ID |
| SetChangeControl | Filter | INSTANCE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | Find_Data_Line:479, Find_Data_Line:480, Find_Data_Line:481, Find_Data_Line:482, SetChangeControl:980, SetChangeControl:1001, SetChangeControl:1022, SetChangeControl:1044 | CString.GetCheckedListValue | CODE |
| FP_UpdateBatch | Save_Data_Test:623 | DataService.FP_UpdateBatch | COUNT, RESULT |
| GetInnerTable | SetChangeControl:976, SetChangeControl:983, SetChangeControl:997, SetChangeControl:1004, SetChangeControl:1018, SetChangeControl:1026, SetChangeControl:1040, GetInstance:1058 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnSql | Click | btnSql_Click | InitializeComponent:336 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:591 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:592 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:593 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:594 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:595 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:596 |
| this | Load | Form_Load | .ctor:99 |
| clbInstance | SelectedIndexChanged | ClbInstance_SelectedIndexChanged | InitEvent:200 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:201 |
| cboFactory | SelectedIndexChanged | CboFactory_SelectedIndexChanged | InitEvent:202 |
| cboLine | SelectedIndexChanged | CboLine_SelectedIndexChanged | InitEvent:203 |
| popSql | OnSql | RunSqlSource | btnSql_Click:711 |

## 6. 컨트롤 (22개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | layoutControlItem4, lblSql, layoutControlItem2, layoutControlItem1, layoutControlItem3, layoutControlItem6, layoutControlItem5 |
| UsrCheckedList2 | 4 | clbPlant, clbInstance, cboFactory, cboLine |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCheckBox | 1 | chk_lineAssign |
| UsrMultiLineEditor | 1 | txtItemID |
| UsrButton | 1 | btnSql |
| ImageList | 1 | imageList1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 13 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00740 | Theory_Stock | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Theory_Stock
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:263

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| Find_Data | Theory_Stock | 470 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 612 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 613 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 614 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 615 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Theory_Stock | META+코드연결 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

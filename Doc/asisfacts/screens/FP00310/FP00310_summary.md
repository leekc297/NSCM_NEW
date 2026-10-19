# FP00310 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00310_Formation_Yield.UIL\FP00310_Formation_Yield.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00310_Formation_Yield.UIL\FP00310_Formation_Yield.UIL.csproj | 1149 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00310_Formation_Yield.UIL\FP00310_Formation_Yield.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00310_Formation_Yield.UIL\FP00310_Formation_Yield.UIL.csproj | 774 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00310_Formation_Yield.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00310_Formation_Yield.UIL\FP00310_Formation_Yield.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangeControl | 242 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangeControl | 242 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged > SetChangeControl | 242 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged > SetChangeControl | 242 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 242 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 242 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 242 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 242 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 242 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 242 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 644 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 644 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| button:FindButton | FindButton > Find_Data > Find_Data_Yield | 549 | FP_Master.PR_UI_FP00310_FORMATION_YIELD | MATCH | SP PR_UI_FP00310_FORMATION_YIELD |
| event:popSql.OnSql | RunSqlSource > Find_Data_Yield | 549 | FP_Master.PR_UI_FP00310_FORMATION_YIELD | MATCH | SP PR_UI_FP00310_FORMATION_YIELD |
| event:this.Load | Form_Load > InitControls > ClbLine_SelectedIndexChanged > SetChangeControl | 242 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbLine_SelectedIndexChanged > SetChangeControl | 242 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 644 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 644 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| unreached:(진입점 미연결) | SetDivision | 870 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetSite | 901 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetPlant | 934 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetFactory | 972 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetLine | 1042 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | 1 | SP PR_UI_FP_MASTER_FORM_CODE | EXEC:PR_UI_FP_MASTER_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP00310_FORMATION_YIELD | MATCH | 1 | SP PR_UI_FP00310_FORMATION_YIELD | EXEC:PR_UI_FP00310_FORMATION_YIELD | ⚠ DB에 SP 없음 |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| Find_Data | Filter | DIVISION_ID |
| GetDivision | Filter | USER_ID |
| SetChangeControl | Filter | PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetInnerTable | GetDivision:202, SetChangeControl:219, SetChangeControl:225, SetChangeControl:233, SetChangeControl:242, SetChangeControl:253 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetCheckedListValue | SetChangeControl:223, SetChangeControl:232, SetChangeControl:241, SetChangeControl:250, SetChangeControl:260, Find_Data_Yield:533, Find_Data_Yield:534, Find_Data_Yield:535 | CString.GetCheckedListValue | CODE |
| SetFilter | SetChangeControl:224, SetSite:904, SetPlant:937, SetFactory:975, SetLine:1045 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:117 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:276 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:277 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:278 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:279 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:280 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:282 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:283 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:284 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:285 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:286 |
| popSql | OnSql | RunSqlSource | btnSql_Click:622 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:461 |

## 6. 컨트롤 (25개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 8 | layoutControlItem2, layoutControlItem12, lblSql, layoutControlItem3, layoutControlItem6, layoutControlItem5, layoutControlItem1, layoutControlItem7 |
| UsrCheckedList2 | 4 | clbLine, clbBuilding, clbPlant, clbDivision |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrMultiLineEditor | 2 | txtNickName, txtItemID |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCombo | 1 | cboSite |
| UsrButton | 1 | btnSql |
| ImageList | 1 | imageList1 |
| EmptySpaceItem | 1 | emptySpaceItem10 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 37 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 3 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 5 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00310 | FormationYield | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: FormationYield
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:346

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadInit | 0 | 350 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID |  |
| SetSpreadInit | 0 | 351 | 표시/라벨 변경 | set:Visible | Visible = {?false} | EDIT_YN |  |
| Find_Data | FormationYield | 516 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 636 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 637 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 638 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 639 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| FormationYield | META+코드연결 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

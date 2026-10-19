# FP00510 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_ChangeProdTypePopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_SCP_Target.UIL.csproj | 1179 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_ChangeProdTypePopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_SCP_Target.UIL.csproj | 690 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_SCP_Target.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_SCP_Target.UIL.csproj | 1475 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_SCP_Target.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_SCP_Target.UIL.csproj | 1034 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_TargetBalancingPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_SCP_Target.UIL.csproj | 510 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_TargetBalancingPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_SCP_Target.UIL.csproj | 1200 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_SCP_Target.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00510_SCP_Target.UIL\FP00510_SCP_Target.UIL.csproj | 84 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00510_SCP_Target.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1430 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00510_SCP_Target.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1034 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00510_ChangeProdTypePopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1179 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00510_ChangeProdTypePopup.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 690 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00510_TargetBalancingPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 510 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00510_TargetBalancingPopup.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1200 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > GetOrderType | 266 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | clbPlant_SelectedIndexChanged > GetScpPlantID | 311 | biz:FPCommonDataBLL.FPCommonDataList [code=SCP_PLAN] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Data > Find_Data_ProdType | 512 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data > Find_Data_ProdType | 512 | {?pServiceCallName} | UNRESOLVED |  |
| button:FindButton | FindButton > FindData_Main > Find_Data_Main | 602 | FP_Master.PR_UI_FP00510_SCP_TARGET | MATCH | SP PR_UI_FP00510_SCP_TARGET |
| event:popSql.OnSql | RunSqlSource > Save_Data_Target | 343 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Target | 343 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Target | 407 | FP_Master.PR_UI_FP00510_SCP_TARGET_SAVE | MATCH | SP PR_UI_FP00510_SCP_TARGET_SAVE |
| event:popSql.OnSql | RunSqlSource > Find_Data_ProdType | 512 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_ProdType | 512 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Main | 602 | FP_Master.PR_UI_FP00510_SCP_TARGET | MATCH | SP PR_UI_FP00510_SCP_TARGET |
| event:popSql.OnSql | RunSqlSource > Save_Data_ProdType | 670 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_ProdType | 670 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Sub | 710 | FP_Master.PR_UI_FP00510_SCP_TARGET | MATCH | SP PR_UI_FP00510_SCP_TARGET |
| event:popSql.OnSql | RunSqlSource > Save_Data_Main | 887 | FP_Master.PR_UI_FP00510_SCP_TARGET | MATCH | SP PR_UI_FP00510_SCP_TARGET |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Target | 343 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Target | 343 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Target | 407 | FP_Master.PR_UI_FP00510_SCP_TARGET_SAVE | MATCH | SP PR_UI_FP00510_SCP_TARGET_SAVE |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_ProdType | 512 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_ProdType | 512 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data | 561 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data | 561 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > FindData_Main > Find_Data_Main | 602 | FP_Master.PR_UI_FP00510_SCP_TARGET | MATCH | SP PR_UI_FP00510_SCP_TARGET |
| button:SaveButton | SaveButton > Save_Data > Save_Data_ProdType | 670 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_ProdType | 670 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Main | 887 | FP_Master.PR_UI_FP00510_SCP_TARGET | MATCH | SP PR_UI_FP00510_SCP_TARGET |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_ProdType | 512 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_ProdType | 512 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Target | 343 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Target | 343 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Target | 407 | FP_Master.PR_UI_FP00510_SCP_TARGET_SAVE | MATCH | SP PR_UI_FP00510_SCP_TARGET_SAVE |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_ProdType | 512 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_ProdType | 512 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 561 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 561 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_ProdType | 670 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_ProdType | 670 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSplit.Click | btnSplit_Click > FindData_Main > Find_Data_Main | 602 | FP_Master.PR_UI_FP00510_SCP_TARGET | MATCH | SP PR_UI_FP00510_SCP_TARGET |
| event:this.Load | Form_Load > InitControls | 191 | biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 193 | biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 193 | biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 196 | biz:FPCommonDataBLL.YesNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetOrderType | 266 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetScpPlantID | 311 | biz:FPCommonDataBLL.FPCommonDataList [code=SCP_PLAN] | BIZ_MATCH |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_ProdType | 512 | {?string.Empty} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_ProdType | 512 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub > Find_Data_Sub | 710 | FP_Master.PR_UI_FP00510_SCP_TARGET | MATCH | SP PR_UI_FP00510_SCP_TARGET |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?pServiceCallName} | UNRESOLVED | 4 |  |  |  |
| {?string.Empty} | UNRESOLVED | 4 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=SCP_PLAN] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.YesNo | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP00510_SCP_TARGET | MATCH | 3 | SP PR_UI_FP00510_SCP_TARGET | EXEC:PR_UI_FP00510_SCP_TARGET | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP00510_SCP_TARGET_SAVE | MATCH | 1 | SP PR_UI_FP00510_SCP_TARGET_SAVE | EXEC:PR_UI_FP00510_SCP_TARGET_SAVE | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnChangeProd_Click | Application.OpenForms | FP00510_ChangeProdTypePopup |
| btnImport_Click | Application.OpenForms | FPC0100_ExcelImportPopup |
| btnSplit_Click | Application.OpenForms | FP00510_TargetBalancingPopup |
| GetPlanGroup | Filter | USER_ID, MASTER_ID, INSTANCE_ID, USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| GetPlanGroup | dtInstance.Rows[cboPlanGroup.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SetChangeControl | Filter | INSTANCE_ID, MASTER_ID, SITE_ID, PLANT_ID |
| SetChangeControl | dtInstance.Rows[cboPlanGroup.SelectedIndex] | USE_WOW_STATUS, CONFIRM_AREA, IS_SAME_PLAN_ID |
| SpdMain_CellClick | dRow | DIVISION_ID, CODE, NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | FindButton:297, btnFind_Click:390, CboOrderType_SelectedIndexChanged:734, GetOrderType:246, GetOrderType:251, GetOrderType:256, GetOrderType:261, GetScpPlantID:291 | CString.GetCheckedListValue | CODE |
| FP_Log2 | CboPlanGroup_SelectedIndexChanged:1179, CboPlanGroup_SelectedIndexChanged:1181 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| OnShown | OnShown:1284 | BaseForm.OnShown | NowGroupID, USER_ID |
| GetInnerTable | GetPlanGroup:1391, SetChangeControl:1415, SetChangeControl:1424, SetChangeControl:1437, SetChangeControl:1446, SetChangeControl:1458 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| SetFilter | SetChangeControl:1421, SetChangeControl:1422, SetChangeControl:1423, SetChangeControl:1442 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:164 |
| cboOrderType | SelectedIndexChanged | CboOrderType_SelectedIndexChanged | InitControls:204 |
| popSql | OnSql | RunSqlSource | btnSql_Click:414 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:177 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:325 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:374 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:413 |
| this.chlAll | CheckedChanged | chlAll_CheckedChanged | InitializeComponent:602 |
| this.spdMain | CellClick | SpdMain_CellClick | InitializeComponent:125 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitializeComponent:126 |
| this.btnChangeProd | Click | btnChangeProd_Click | InitializeComponent:201 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:241 |
| this.btnSplit | Click | btnSplit_Click | InitializeComponent:253 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:883 |
| this | Load | Form_Load | .ctor:120 |
| cboPlanGroup | SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | InitEvent:143 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:144 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:145 |
| clbPlant | SelectedIndexChanged | clbPlant_SelectedIndexChanged | InitEvent:146 |
| popSql | OnSql | RunSqlSource | btnSql_Click:953 |
| this | Load | Form_Load | .ctor:126 |
| popSql | OnSql | RunSqlSource | btnSql_Click:235 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:307 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:346 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:385 |
| this.txtQtySplit | TextChanged | txtQtySplit_TextChanged | InitializeComponent:453 |

## 6. 컨트롤 (101개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 37 | layoutControlItem5, layoutControlItem4, layoutControlItem6, layoutControlItem2, layoutControlItem1, lblSql, layoutControlItem3, layoutControlItem7, layoutControlItem3, layoutControlItem7, layoutControlItem1, Site, Material, Division, layoutControlItem2 … |
| UsrTextBox | 11 | txtOrgQty, txtQtySplit, txtMarket, txtQty, txtScpTarget, txtScpPlan, txtItem, txtShopGroup, txtPlant, txtSite, txtDivision |
| UsrButton | 9 | btnSql, btnClose, btnSave, btnFind, btnSql, btnImport, btnSql, btnClose, btnSave |
| UsrCombo | 7 | cboOrderType, cboOrderType, cboScpPlanID, cboPlanGroup, cboSite, cboDivision, cboMarket |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl3, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup3, layoutControlGroup1, layoutControlGroup2 |
| UsrMultiLineEditor | 4 | txtItemName, txtItemID, txtItemName, txtItemID |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| ImageList | 3 | imageList1, imageList1, imageList1 |
| FpSpread | 3 | spdTarget, spdMain, spdSub |
| SheetView | 3 | spdTarget_Sheet1, spdMain_Sheet1, spdSub_Sheet1 |
| SimpleButton | 2 | btnChangeProd, btnSplit |
| UsrLabel | 2 | usrLabel2, usrLabel1 |
| CheckBox | 1 | chlAll |
| UsrCheckedList2 | 1 | clbPlant |
| EmptySpaceItem | 1 | emptySpaceItem7 |
| Panel | 1 | StockPanel |
| Splitter | 1 | splitter1 |

## 7. 확인 필요 (8건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 512 | Find_Data_ProdType | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 512 | Find_Data_ProdType | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 561 | Save_Data | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 561 | Save_Data | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 670 | Save_Data_ProdType | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 670 | Save_Data_ProdType | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 343 | Save_Data_Target | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 343 | Save_Data_Target | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 65 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 42 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 72 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00510 | SCPTarget | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 |
| SCM_MST_SHEET_COLUMNS | FP00510 | SCPTargetChangeProdTypePopup | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |
| SCM_MST_SHEET_COLUMNS | FP00510 | SCPTargetSub | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: {?this.sSheetName}, SCPTarget, SCPTargetSub
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:267, SetSheetHeaderColumn_FP@InitSpread:346, SetSheetHeaderColumn_FP@InitSpread:363

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadInit | 0 | 270 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID |  |
| SetSpreadInit | 0 | 271 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DIVISION_ID |  |
| SetSpreadInit | 0 | 272 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID |  |
| SetSpreadInit | 0 | 273 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORG_MARKET |  |
| SetSpreadInit | 0 | 274 | 표시/라벨 변경 | set:Visible | Visible = {?false} | EDIT_YN |  |
| Find_Data |  | 498 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| spdTarget_CellClick |  | 808 | 표시/라벨 변경 | set:Value | Value = {?true} |  | if(siTarget.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siTarget.IsLock(siTarget.SheetName) == false) ⟫ if(siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ if(Convert.ToBoolean(siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value) == false) |
| spdTarget_CellClick |  | 813 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siTarget.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siTarget.IsLock(siTarget.SheetName) == false) ⟫ if(siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ else!(Convert.ToBoolean(siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value) == false) |
| InitializeComponent |  | 567 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 568 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 569 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 570 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 354 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID | if(spreadInfo.SheetName == "SCPTarget") |
| InitSpread |  | 355 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORG_MARKET | if(spreadInfo.SheetName == "SCPTarget") |
| InitSpread |  | 356 | 표시/라벨 변경 | set:Visible | Visible = {?false} | OPERATION_ID | if(spreadInfo.SheetName == "SCPTarget") |
| InitSpread |  | 368 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID | else!(spreadInfo.SheetName == "SCPTarget") ⟫ if(spreadInfo.SheetName == "SCPTargetSub") |
| InitSpread |  | 369 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DIVISION_ID | else!(spreadInfo.SheetName == "SCPTarget") ⟫ if(spreadInfo.SheetName == "SCPTargetSub") |
| InitSpread |  | 370 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID | else!(spreadInfo.SheetName == "SCPTarget") ⟫ if(spreadInfo.SheetName == "SCPTargetSub") |
| InitSpread |  | 371 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLANT_ID | else!(spreadInfo.SheetName == "SCPTarget") ⟫ if(spreadInfo.SheetName == "SCPTargetSub") |
| InitSpread |  | 372 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TO_PLANT_ID | else!(spreadInfo.SheetName == "SCPTarget") ⟫ if(spreadInfo.SheetName == "SCPTargetSub") |
| InitSpread |  | 373 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MESSAGE_ID | else!(spreadInfo.SheetName == "SCPTarget") ⟫ if(spreadInfo.SheetName == "SCPTargetSub") |
| InitSpread |  | 374 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SEQ | else!(spreadInfo.SheetName == "SCPTarget") ⟫ if(spreadInfo.SheetName == "SCPTargetSub") |
| FindData_Main | SCPTarget | 567 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Sub | SCPTargetSub | 699 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 142 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 143 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 144 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 145 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 806 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 807 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 808 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 809 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| SCPTarget | META+코드연결 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 |
| SCPTargetChangeProdTypePopup | 메타 정의만, 코드 미참조(미사용 가능) | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |
| SCPTargetSub | META+코드연결 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

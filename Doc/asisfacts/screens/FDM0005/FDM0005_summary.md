# FDM0005 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Master.UIL\FDM0005_Shipping_Plan.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1418 |
| only | 06.UIL\GSCM.FP.Master.UIL\FDM0005_Shipping_Plan.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1081 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FDM0005_ItemPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 573 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FDM0005_ItemPopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 559 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FDM0005_TransportModePopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 409 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FDM0005_TransportModePopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 383 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl | 248 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl | 255 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl | 262 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | 1148 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:cboSite.SelectedIndexChanged | cboSite_SelectedIndexChanged | 492 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged | 1186 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboWppWeek.SelectedIndexChanged | CboWppWeek_SelectedIndexChanged | 1201 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 458 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 466 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_TransMode | 277 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > FindData > Find_Data_Item | 383 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > Find_Data > Find_Data_ShippingPlan | 764 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_TransMode | 277 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Item | 383 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_ShippingPlan | 764 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_ShippingPlan | 1004 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_ShippingPlan | 764 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_ShippingPlan | 1004 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_TransMode | 277 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_Item | 383 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| event:this.btnCreateWPP.Click | btnCreateWPP_Click | 483 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnCreateWPP.Click | btnCreateWPP_Click > Find_Data > Find_Data_ShippingPlan | 764 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| event:this.btnCreateWPP.Click | btnCreateWPP_Click > Save_Data_CreateWPP | 1093 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| event:this.btnImport.Click | btnImport_Click | 560 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.cboSite.SelectedIndexChanged | cboSite_SelectedIndexChanged | 492 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.chkWPP.CheckedChanged | chkWPP_CheckedChanged | 1216 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.chkWPP.CheckedChanged | chkWPP_CheckedChanged | 1222 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 458 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 466 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 152 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 158 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 169 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 173 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 179 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 189 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 190 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 213 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 225 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 234 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 248 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 255 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 262 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_TransMode | 277 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > FindData > Find_Data_Item | 383 | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 5 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 3 |  |  |  |
| FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY | 5 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | 12 | SP PR_UI_FP_MASTER_FORM_CODE | EXEC:PR_UI_FP_MASTER_FORM_CODE | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnCreateWPP_Click | dtNewVersion.Rows[0] | INSTANCE_ID, WPP_WEEK, WPP_SEQ |
| btnImport_Click | dtNewVersion.Rows[0] | INSTANCE_DATE, VERSION_ID |
| CboPlanGroup_SelectedIndexChanged | dtCurrVersion.Rows[0] | INSTANCE_DATE, VERSION_ID |
| chkWPP_CheckedChanged | dtWppSeq.Rows[0] | MIN_DATE, MAX_DATE |
| Save_Data_ShippingPlan | dtCurrVersion.Rows[0] | INSTANCE_DATE, VERSION_ID |
| spdMain_CellClick | dtCurrVersion.Rows[0] | INSTANCE_ID, INSTANCE_DATE, VERSION_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:156, InitControls:165, InitControls:177, SetChangedControl:246, SetChangedControl:252, SetChangedControl:259, btnCreateWPP_Click:481, btnImport_Click:542 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnCreateWPP | Click | btnCreateWPP_Click | InitializeComponent:175 |
| this.chkWPP | CheckedChanged | chkWPP_CheckedChanged | InitializeComponent:285 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:633 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:697 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:895 |
| this | Load | Form_Load | .ctor:113 |
| cboPlanGroup | SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | InitEvent:278 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:279 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:280 |
| cboWppWeek | SelectedIndexChanged | CboWppWeek_SelectedIndexChanged | InitEvent:281 |
| popSql | OnSql | RunSqlSource | btnSql_Click:531 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:155 |
| this.cboSite | SelectedIndexChanged | cboSite_SelectedIndexChanged | InitializeComponent:260 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:301 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:357 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:459 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:460 |
| this | Load | Form_Load | .ctor:140 |
| this | Load | Form_Load | .ctor:151 |
| this | Load | Form_Load | .ctor:162 |
| this | Load | Form_Load | .ctor:176 |
| clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitEvent:262 |
| cboSite | SelectedIndexChanged | cboSite_SelectedIndexChanged | InitEvent:263 |
| popSql | OnSql | RunSqlSource | btnSql_Click:318 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:180 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:237 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:292 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:293 |
| this | Load | Form_Load | .ctor:124 |
| this | Load | Form_Load | .ctor:133 |
| popSql | OnSql | RunSqlSource | btnSql_Click:218 |

## 6. 컨트롤 (68개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 23 | layoutControlItem3, layoutControlItem6, layoutControlItem7, layoutControlItem8, layoutControlItem4, layoutControlItem5, layoutControlItem9, lblWppWeek, lblWppSeq, layoutControlItem2, layoutControlItem1, lblExcelImport, lblSql, layoutControlItem12, layoutControlItem1 … |
| UsrCombo | 7 | cboWppSeq, cboWppWeek, cboPlanGroup, cboCellType, cboSite, cboPlant, cboSite |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 4 | btnImport, btnSql, btnSql, btnSql |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrCheckedList2 | 3 | clbPlant, clbDivision, clbDivision |
| FpSpread | 3 | spdMain, spdMain, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrMultiLineEditor | 2 | txtItemName, txtItemID |
| UsrButtonList | 2 | btnButtonList, btnButtonList |
| SimpleButton | 1 | btnCreateWPP |
| UsrCheckBox | 1 | chkWPP |
| UsrDateRangePicker | 1 | drpPeriod |
| ImageList | 1 | imageList1 |
| UsrTextBox | 1 | txtItem |
| UsrLabel | 1 | usrLabel1 |

## 7. 확인 필요 (5건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 764 | Find_Data_ShippingPlan | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 1004 | Save_Data_ShippingPlan | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 1093 | Save_Data_CreateWPP | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 383 | Find_Data_Item | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 277 | Find_Data_TransMode | FP_Master.PR_UI_FDM0005_SHIPPING_PLAN | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: ShippingPlan, ItemPopup, TransportModePopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:341, SetSheetHeaderColumn_FP@SetSpreadInit:291, SetSheetHeaderColumn_FP@SetSpreadInit:188

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadInit | 0 | 345 | 표시/라벨 변경 | set:Visible | Visible = {?false} | INSTANCE_ID |  |
| SetSpreadInit | 0 | 346 | 표시/라벨 변경 | set:Visible | Visible = {?false} | INSTANCE_DATE |  |
| SetSpreadInit | 0 | 347 | 표시/라벨 변경 | set:Visible | Visible = {?false} | VERSION_ID |  |
| SetSpreadInit | 0 | 348 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID |  |
| SetSpreadInit | 0 | 349 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCTION_TYPE |  |
| SetSpreadInit | 0 | 350 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MARKET |  |
| SetSpreadInit | 0 | 351 | 표시/라벨 변경 | set:Visible | Visible = {?false} | WPP_TYPE |  |
| SetSpreadInit | 0 | 352 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MESSAGE_ID |  |
| SetSpreadInit | 0 | 353 | 표시/라벨 변경 | set:Visible | Visible = {?false} | VALID_YN |  |
| Find_Data | ShippingPlan | 712 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 911 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 912 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 913 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 914 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 476 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 477 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 478 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 479 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadInit | 0 | 191 | 표시/라벨 변경 | set:Visible | Visible = {?false} | FROM_PLANT_ID |  |
| SetSpreadInit | 0 | 192 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TO_PLANT_NAME |  |
| SetSpreadInit | 0 | 193 | 표시/라벨 변경 | set:Visible | Visible = {?false} | LT_TOTAL |  |
| SetSpreadInit | 0 | 194 | 표시/라벨 변경 | set:Visible | Visible = {?false} | NAME |  |
| InitializeComponent |  | 309 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 310 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 311 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 312 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

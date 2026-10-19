# FP00414 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_Formation_Tray_4Model.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_Formation_Tray_4Model.UIL.csproj | 1131 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_Formation_Tray_4Model.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_Formation_Tray_4Model.UIL.csproj | 919 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_ItemAddPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_Formation_Tray_4Model.UIL.csproj | 453 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_ItemAddPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_Formation_Tray_4Model.UIL.csproj | 540 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_LineAddPop.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_Formation_Tray_4Model.UIL.csproj | 641 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_LineAddPop.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_Formation_Tray_4Model.UIL.csproj | 462 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_TrayAddPop.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_Formation_Tray_4Model.UIL.csproj | 624 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_TrayAddPop.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_Formation_Tray_4Model.UIL.csproj | 523 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00414_Formation_Tray_4Model.UIL\FP00414_Formation_Tray_4Model.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > GetPlant | 207 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged | 524 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > GetSite | 198 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged | 492 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged | 500 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 299 | FP_Common.PR_UI_COMMON_POPUP | MATCH | SP PR_UI_COMMON_POPUP |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Line | 525 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_FP00414] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Line | 525 | FP\MASTER\FP00414_FormationTrayModel#update_FP00414 | MATCH | [update-batch]  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 299 | FP_Common.PR_UI_COMMON_POPUP | MATCH | SP PR_UI_COMMON_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 352 | FP_Master.PR_UI_FP00414_ADD_POP | MATCH | SP PR_UI_FP00414_ADD_POP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData | 371 | FP_Master.PR_UI_FP00414_ADD_POP | MATCH | SP PR_UI_FP00414_ADD_POP |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 375 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 145 | biz:FPCommonDataBLL.YesNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 179 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 183 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetDivision | 191 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 194 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetSite | 198 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > GetPlant | 207 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 214 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 225 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 237 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_Save | 920 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00411_import] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_Save | 920 | FP\MASTER\FP00414_FormationTrayModel#merge_FP00411_import | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 950 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 950 | FP\MASTER\FP00414_FormationTrayModel#delete_Excel_buffer | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 954 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 954 | FP\MASTER\FP00414_FormationTrayModel#insert_Excel_buffer | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 959 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 959 | FP\MASTER\FP00414_FormationTrayModel#find_Excel_buffer_validation | NOT_IN_FOXQUERY |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 4 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 5 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00411_import] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_FP00414] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.YesNo | BIZ_MATCH | 1 |  |  |  |
| FP_Common.PR_UI_COMMON_POPUP | MATCH | 1 | SP PR_UI_COMMON_POPUP | EXEC:PR_UI_COMMON_POPUP | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP00414_ADD_POP | MATCH | 2 | SP PR_UI_FP00414_ADD_POP | EXEC:PR_UI_FP00414_ADD_POP | ⚠ DB에 SP 없음 |
| FP\MASTER\FP00414_FormationTrayModel#delete_Excel_buffer | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP\MASTER\FP00414_FormationTrayModel#find_Excel_buffer_validation | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP\MASTER\FP00414_FormationTrayModel#insert_Excel_buffer | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP\MASTER\FP00414_FormationTrayModel#merge_FP00411_import | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP\MASTER\FP00414_FormationTrayModel#update_FP00414 | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnExcel_Click | p.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, OPERATION_ID, SHORTER_LT |
| btnExcel_Click | p.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, NICK_NAME, OPERATION_ID, BEFORE_DEGAS_ROUTE_ID, BEFORE_DEGAS_LT, BEFORE_DEGAS_LT_DAY, AFTER_DEGAS_ROUTE_ID, AFTER_DEGAS_LT, AFTER_DEGAS_LT_DAY, SHORTER_LT, MESSAGE |
| btnExcel_Click | p.ColumnWidth | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, NICK_NAME, OPERATION_ID, BEFORE_DEGAS_ROUTE_ID, BEFORE_DEGAS_LT, BEFORE_DEGAS_LT_DAY, AFTER_DEGAS_ROUTE_ID, AFTER_DEGAS_LT, AFTER_DEGAS_LT_DAY, SHORTER_LT, MESSAGE |
| btnExcel_Click | p.ColumnBgColor | SHORTER_LT |
| ClbDivision_SelectedIndexChanged | Filter | DIVISION_ID |
| ClbPlant_SelectedIndexChanged | Filter | PLANT_ID |
| ClbSite_SelectedIndexChanged | Filter | SITE_ID |
| CreateTrayTypeTable | dt.Rows[0] | CODE, NAME |
| CreateTrayTypeTable | dt.Rows[1] | CODE, NAME |
| CreateTrayTypeTable | dt.Rows[2] | CODE, NAME |
| CreateTrayTypeTable | dt.Rows[3] | CODE, NAME |
| Find_Data_Execute | Filter | ACTIVE_FLAG, FCS_MODEL_ID, NICK_NAME, ITEM_ID |
| FindData | siMain.ActiveSheet.Columns | ACTIVE_FLAG |
| GetPlant | Filter | DIVISION_ID, SITE_ID |
| GetSite | Filter | DIVISION_ID |
| Save_Data_Line | bindingRow | DIVISION_ID, SITE_ID, PLANT_ID, PSEUDO_FACTORY_ID, FACTORY_ID, LINE_ID, TRAY_ID, ITEM_ID, ACTIVE_FLAG |
| SetChangeControl | Filter | DIVISION_ID, SITE_ID, PLANT_ID, ACTIVE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangeControl:161, SetChangeControl:165, SetChangeControl:169, ClbDivision_SelectedIndexChanged:232, ClbSite_SelectedIndexChanged:240, ClbPlant_SelectedIndexChanged:248, InitControls:190, FindData:281 | CString.GetCheckedListValue | CODE |
| GetChanges | Save_Data_Line:521 | FPExtensions.GetChanges | ROW_ID |
| FP_UpdateBatch | Save_Data_Line:525, Excel_Save:920, Excel_CheckValidation:954 | DataService.FP_UpdateBatch | COUNT, RESULT |
| LoadCombo | FindData:751 | SpreadInfo.LoadCombo | CODE, NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:93 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:183 |
| cboSite | SelectedIndexChanged | ClbSite_SelectedIndexChanged | InitEvent:184 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:185 |
| popSql | OnSql | RunSqlSource | btnSql_Click:571 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:559 |
| this.btnExcel | Click | btnExcel_Click | InitializeComponent:599 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:786 |
| this | Load | Form_Load | .ctor:130 |
| this | Load | Form_Load | .ctor:148 |
| this.cboSite | SelectedIndexChanged | cboSite_SelectedIndexChanged | InitializeComponent:157 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:197 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:253 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:441 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:442 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:282 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:366 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:367 |
| this | Load | Form_Load | .ctor:152 |
| this | Load | Form_Load | .ctor:174 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:256 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:257 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:209 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:366 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:367 |
| this | Load | Form_Load | .ctor:164 |
| this | Load | Form_Load | .ctor:190 |

## 6. 컨트롤 (89개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 26 | lblSql, layoutControlItem5, layoutControlItem1, layoutControlItem3, layoutControlItem4, layoutControlItem6, layoutControlItem9, layoutControlItem8, layoutControlItem7, layoutControlItem10, layoutControlItem2, layoutControlItem12, lblBtn, layoutControlItem2, lblNickName … |
| UsrTextBox | 9 | txtItemId, txtNickName, txtFcsModelId, txtNickName, txtItemId, txtDivision, txtSite, txtPlant, txtFactory |
| UsrLayoutControl | 8 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 8 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 8 | emptySpaceItem2, emptySpaceItem1, emptySpaceItem3, emptySpaceItem1, emptySpaceItem3, emptySpaceItem1, emptySpaceItem2, emptySpaceItem3 |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrCombo | 4 | cboSite, cboSite, cboPlant, cboSite |
| FpSpread | 4 | spdMain, spdMain, spdMain, spdMain |
| SheetView | 4 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrRadio | 3 | radioActiveN, radioActiveY, radioActiveAll |
| UsrCheckedList2 | 3 | clbPlant, clbDivision, clbDivision |
| UsrButtonList | 3 | btnButtonList, btnButtonList, btnButtonList |
| UsrButton | 2 | btnSql, btnExcel |
| UsrLabel | 1 | usrLabel1 |
| ImageList | 1 | imageList1 |
| UsrCheckedList | 1 | clbDivision |

## 7. 확인 필요 (4건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 959 | Excel_CheckValidation | FP\MASTER\FP00414_FormationTrayModel#find_Excel_buffer_validation | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) |
| 950 | Excel_CheckValidation | FP\MASTER\FP00414_FormationTrayModel#delete_Excel_buffer | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) |
| 920 | Excel_Save | FP\MASTER\FP00414_FormationTrayModel#merge_FP00411_import | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) |
| 954 | Excel_CheckValidation | FP\MASTER\FP00414_FormationTrayModel#insert_Excel_buffer | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 14 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (4건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 353 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | commented:MATCH |
| 420 | FP_Common.PR_UI_COMMON_POPUP | commented:MATCH |
| 372 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | commented:MATCH |
| 439 | FP_Common.PR_UI_COMMON_POPUP | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00414 | Main | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main, Item Popup, LineAddPopup || {?pSheetName}, WorkCenterOperationPopup || {?pSheetName}
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:266, SetSheetHeaderColumn_FP@InitSpread:234

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 802 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 803 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 804 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 805 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 458 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 459 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 460 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 461 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadInit |  | 300 | 하드코딩 | AddTextColumn | Division | DIVISION_ID |  |
| SetSpreadInit |  | 301 | 하드코딩 | AddTextColumn | Site | SITE_ID |  |
| SetSpreadInit |  | 302 | 하드코딩 | AddTextColumn | Plant | PLANT_ID |  |
| SetSpreadInit |  | 303 | 하드코딩 | AddTextColumn | Virtual Building | PSEUDO_FACTORY_ID |  |
| SetSpreadInit |  | 304 | 하드코딩 | AddTextColumn | Building | FACTORY_ID |  |
| SetSpreadInit |  | 305 | 하드코딩 | AddTextColumn | Line | LINE_ID |  |
| SetSpreadInit |  | 306 | 하드코딩 | AddTextColumn | Line Name | LINE_NAME |  |
| InitializeComponent |  | 383 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 384 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 385 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 386 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadInit |  | 317 | 하드코딩 | AddTextColumn | Division | DIVISION_ID |  |
| SetSpreadInit |  | 318 | 하드코딩 | AddTextColumn | Site | SITE_ID |  |
| SetSpreadInit |  | 319 | 하드코딩 | AddTextColumn | Plant | PLANT_ID |  |
| SetSpreadInit |  | 320 | 하드코딩 | AddTextColumn | Building | FACTORY_ID |  |
| SetSpreadInit |  | 321 | 하드코딩 | AddTextColumn | Tray ID | TRAY_TYPE_CODE |  |
| SetSpreadInit |  | 322 | 하드코딩 | AddTextColumn | Tray Name | TRAY_TYPE_NAME |  |
| SetSpreadInit |  | 323 | 하드코딩 | AddTextColumn | Group Tray ID | TRAY_TYPE_GROUP |  |
| SetSpreadInit |  | 324 | 하드코딩 | AddTextColumn | Tray Type | TRAY_TYPE |  |
| InitializeComponent |  | 383 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 384 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 385 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 386 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| LineAddPopup || {?pSheetName} | (시트 미상) | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |
| Main | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |
| WorkCenterOperationPopup || {?pSheetName} | (시트 미상) | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

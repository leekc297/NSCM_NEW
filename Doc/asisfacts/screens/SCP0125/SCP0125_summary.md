# SCP0125 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0125_Workbench\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0125_Workbench\SCP0125_Workbench.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0125_Workbench\Properties\Resources.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0125_Workbench\SCP0125_Workbench.csproj | 72 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0125_Workbench\Properties\Settings.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0125_Workbench\SCP0125_Workbench.csproj | 31 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0125_Workbench\SCP0125_Workbench.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0125_Workbench\SCP0125_Workbench.csproj | 2405 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0125_Workbench\SCP0125_Workbench.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0125_Workbench\SCP0125_Workbench.csproj | 523 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 659 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > FindData_Main | 659 | SCP.SCP0125_GET_MKT_FCST_ADJ | MATCH | SP SCP0125_GET_MKT_FCST_ADJ |
| button:FindButton | FindButton > FindData_Main | 659 | SCP.SCP0125_GET_STOCK_ADJ | MATCH | SP SCP0125_GET_STOCK_ADJ |
| button:FindButton | FindButton > FindData_Main | 659 | SCP.SCP0125_GET_STOCK_ADJ_UC | MATCH | SP SCP0125_GET_STOCK_ADJ_UC |
| button:FindButton | FindButton > FindData_Main | 659 | SCP.SCP0125_GET_STOCK_ELEC_PLNT | MATCH | SP SCP0125_GET_STOCK_ELEC_PLNT |
| button:FindButton | FindButton > FindData_Main | 659 | SCP.SCP0125_GET_STOCK_ELEC_PLNT_UC | MATCH | SP SCP0125_GET_STOCK_ELEC_PLNT_UC |
| button:FindButton | FindButton > FindData_Main | 659 | SCP.SCP0125_GET_MKT_FCST_ELEC_DEMAND | MATCH | SP SCP0125_GET_MKT_FCST_ELEC_DEMAND |
| button:FindButton | FindButton > FindData_Main | 659 | SCP.SCP0125_GET_STOCK_SECOND_OCV | MATCH | SP SCP0125_GET_STOCK_SECOND_OCV |
| button:SaveButton | SaveButton > Save_Data > Save_SecondOcv > FindData_Main | 659 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_SecondOcv > FindData_Main | 659 | SCP.SCP0125_GET_MKT_FCST_ADJ | MATCH | SP SCP0125_GET_MKT_FCST_ADJ |
| button:SaveButton | SaveButton > Save_Data > Save_SecondOcv > FindData_Main | 659 | SCP.SCP0125_GET_STOCK_ADJ | MATCH | SP SCP0125_GET_STOCK_ADJ |
| button:SaveButton | SaveButton > Save_Data > Save_SecondOcv > FindData_Main | 659 | SCP.SCP0125_GET_STOCK_ADJ_UC | MATCH | SP SCP0125_GET_STOCK_ADJ_UC |
| button:SaveButton | SaveButton > Save_Data > Save_SecondOcv > FindData_Main | 659 | SCP.SCP0125_GET_STOCK_ELEC_PLNT | MATCH | SP SCP0125_GET_STOCK_ELEC_PLNT |
| button:SaveButton | SaveButton > Save_Data > Save_SecondOcv > FindData_Main | 659 | SCP.SCP0125_GET_STOCK_ELEC_PLNT_UC | MATCH | SP SCP0125_GET_STOCK_ELEC_PLNT_UC |
| button:SaveButton | SaveButton > Save_Data > Save_SecondOcv > FindData_Main | 659 | SCP.SCP0125_GET_MKT_FCST_ELEC_DEMAND | MATCH | SP SCP0125_GET_MKT_FCST_ELEC_DEMAND |
| button:SaveButton | SaveButton > Save_Data > Save_SecondOcv > FindData_Main | 659 | SCP.SCP0125_GET_STOCK_SECOND_OCV | MATCH | SP SCP0125_GET_STOCK_SECOND_OCV |
| button:SaveButton | SaveButton > Save_Data | 1100 | SCP.SCP0125_SAVE_MKT_FCST_ADJ | MATCH | SP SCP0125_SAVE_MKT_FCST_ADJ |
| button:SaveButton | SaveButton > Save_Data | 1400 | SCP.SCP0125_SAVE_STOCK_ADJ | MATCH | SP SCP0125_SAVE_STOCK_ADJ |
| button:SaveButton | SaveButton > Save_Data | 1661 | SCP.SCP0125_SAVE_MKT_FCST_ELEC_DEMAND | MATCH | SP SCP0125_SAVE_MKT_FCST_ELEC_DEMAND |
| button:SaveButton | SaveButton > Save_Data > Save_SecondOcv | 1923 | SCP.SCP0125_SAVE_STOCK_SECOND_OCV | MATCH | SP SCP0125_SAVE_STOCK_SECOND_OCV |
| unreached:(진입점 미연결) | <field:dtFcstType> | 61 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtIncoterms> | 62 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtStockType> | 63 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtDivision_GM> | 64 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtBefore_YN> | 68 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetSearchInfo | 241 | SCP.SCP0125_GET_SEARCH_INFO | MATCH | SP SCP0125_GET_SEARCH_INFO |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?string.Empty} | UNRESOLVED | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| SCP.SCP0125_GET_MKT_FCST_ADJ | MATCH | 1 | SP SCP0125_GET_MKT_FCST_ADJ | EXEC:SCP0125_GET_MKT_FCST_ADJ, SELECT:DM_PLN_NET_DEMAND, SELECT:SCM_MST_ITEM_SN, SELECT:SCP_OPMZ_DMD_ADJ, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0125_GET_MKT_FCST_ELEC_DEMAND | MATCH | 1 | SP SCP0125_GET_MKT_FCST_ELEC_DEMAND | EXEC:SCP0125_GET_MKT_FCST_ELEC_DEMAND, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:SCM_MST_ITEM_SN, SELECT:SCP_OPMZ_DMD_ELEC |  |
| SCP.SCP0125_GET_SEARCH_INFO | MATCH | 1 | SP SCP0125_GET_SEARCH_INFO | EXEC:SCP0125_GET_SEARCH_INFO, SELECT:DM_MST_VERSION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN |  |
| SCP.SCP0125_GET_STOCK_ADJ | MATCH | 1 | SP SCP0125_GET_STOCK_ADJ | EXEC:SCP0125_GET_STOCK_ADJ, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_MODELING, SELECT:DM_PLN_NET_DEMAND, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_BOM_SN_V, SELECT:SCM_MST_SITE, SELECT:SCP_MST_FINAL_ITEM, INSERT:#NET_DEMAND, SELECT:DM_MST_VERSION, INSERT:#INVENTORY_ORG, SELECT:SCM_DNM_STOCK, SELECT:SCM_ITEM_M_SN, INSERT:#INVENTORY_AGING_ORG, SELECT:SCM_DNM_STOCK_AGING_V, INSERT:#SCP_INVENTORY_I, SELECT:#INVENTORY_ORG, REF:FN_GET_ITEM_OPERATION_GROUP, SELECT:SCM_DNM_INTRANSIT_C, UPDATE:#SCP_INVENTORY_I, SELECT:#SCP_INVENTORY_I, SELECT:#NET_DEMAND, SELECT:SCM_MST_LOCATION, SELECT:#INVENTORY_AGING_ORG, INSERT:#SCP_INTRANSIT_I, SELECT:SCM_DNM_INTRANSIT_V, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:SCM_MST_VMI_INT_SLOC, UPDATE:#SCP_INTRANSIT_I, SELECT:#SCP_INTRANSIT_I, INSERT:#CP_INFO, SELECT:SCP_MST_CELL_PROD_ASSY_MAP, SELECT:#CP_INFO, SELECT:SCP_OPMZ_INV_ADJ, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0125_GET_STOCK_ADJ_UC | MATCH | 1 | SP SCP0125_GET_STOCK_ADJ_UC | EXEC:SCP0125_GET_STOCK_ADJ_UC, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_MODELING, SELECT:DM_PLN_NET_DEMAND, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_BOM_SN_V, SELECT:SCM_MST_SITE, SELECT:SCP_MST_FINAL_ITEM, INSERT:#NET_DEMAND, SELECT:DM_MST_VERSION, INSERT:#INVENTORY_ORG, SELECT:SCM_DNM_STOCK, SELECT:SCM_ITEM_M_SN, INSERT:#INVENTORY_AGING_ORG, SELECT:SCM_DNM_STOCK_AGING_V, INSERT:#SCP_INVENTORY_I, SELECT:#INVENTORY_ORG, REF:FN_GET_ITEM_OPERATION_GROUP, SELECT:SCM_DNM_INTRANSIT_C, UPDATE:#SCP_INVENTORY_I, SELECT:#SCP_INVENTORY_I, SELECT:#NET_DEMAND, SELECT:SCM_MST_LOCATION, SELECT:#INVENTORY_AGING_ORG, INSERT:#SCP_INTRANSIT_I, SELECT:SCM_DNM_INTRANSIT_V, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:SCM_MST_VMI_INT_SLOC, UPDATE:#SCP_INTRANSIT_I, SELECT:#SCP_INTRANSIT_I, INSERT:#CP_INFO, SELECT:SCP_MST_CELL_PROD_ASSY_MAP, SELECT:#CP_INFO, SELECT:SCP_OPMZ_INV_ADJ, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0125_GET_STOCK_ELEC_PLNT | MATCH | 1 | SP SCP0125_GET_STOCK_ELEC_PLNT | EXEC:SCP0125_GET_STOCK_ELEC_PLNT, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_MODELING, SELECT:DM_PLN_NET_DEMAND, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, INSERT:#DIVISION, SELECT:SCM_MST_DIVISION, INSERT:#INVENTORY_ORG, SELECT:SCM_DNM_STOCK, SELECT:SCM_ITEM_M_SN, INSERT:#SCP_INVENTORY_I, SELECT:#INVENTORY_ORG, SELECT:SCM_MST_SITE, SELECT:#DIVISION, SELECT:SCP_OPT_ENG_DEMAND_SN, UPDATE:#SCP_INVENTORY_I, SELECT:#SCP_INVENTORY_I, SELECT:SCP_OPT_ENG_BOM_ELEC_SN, SELECT:SCP_OPMZ_INV_ADJ, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0125_GET_STOCK_ELEC_PLNT_UC | MATCH | 1 | SP SCP0125_GET_STOCK_ELEC_PLNT_UC | EXEC:SCP0125_GET_STOCK_ELEC_PLNT_UC, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_MODELING, SELECT:DM_PLN_NET_DEMAND, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, INSERT:#DIVISION, SELECT:SCM_MST_DIVISION, INSERT:#INVENTORY_ORG, SELECT:SCM_DNM_STOCK, SELECT:SCM_ITEM_M_SN, INSERT:#SCP_INVENTORY_I, SELECT:#INVENTORY_ORG, SELECT:SCM_MST_SITE, SELECT:#DIVISION, SELECT:SCP_OPT_ENG_DEMAND_SN, UPDATE:#SCP_INVENTORY_I, SELECT:#SCP_INVENTORY_I, SELECT:SCP_OPMZ_INV_ADJ, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0125_GET_STOCK_SECOND_OCV | MATCH | 1 | SP SCP0125_GET_STOCK_SECOND_OCV | EXEC:SCP0125_GET_STOCK_SECOND_OCV, INSERT:#NICK_NAME_LIST, SELECT:SCM_MST_ITEM_SN, INSERT:#OCV_EXCEPT_LIST, SELECT:SCM_MST_BOM_SN_V, SELECT:SCM_MST_SITE, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, SELECT:SCM_DNM_STOCK_SN, SELECT:#OCV_EXCEPT_LIST, SELECT:SCM_MST_MMD_OPERATION_SN, SELECT:#NICK_NAME_LIST, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_OPMZ_INV_SECOND_OCV |  |
| SCP.SCP0125_SAVE_MKT_FCST_ADJ | MATCH | 1 | SP SCP0125_SAVE_MKT_FCST_ADJ | EXEC:SCP0125_SAVE_MKT_FCST_ADJ, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:DM_PLN_NET_DEMAND, INSERT:SCP_OPMZ_DMD_ADJ, UPDATE:SCP_OPMZ_DMD_ADJ, DELETE:SCP_OPMZ_DMD_ADJ, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0125_SAVE_MKT_FCST_ELEC_DEMAND | MATCH | 1 | SP SCP0125_SAVE_MKT_FCST_ELEC_DEMAND | EXEC:SCP0125_SAVE_MKT_FCST_ELEC_DEMAND, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:SCP_OPMZ_DMD_ELEC, INSERT:SCP_OPMZ_DMD_ELEC, UPDATE:SCP_OPMZ_DMD_ELEC, DELETE:SCP_OPMZ_DMD_ELEC, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0125_SAVE_STOCK_ADJ | MATCH | 1 | SP SCP0125_SAVE_STOCK_ADJ | EXEC:SCP0125_SAVE_STOCK_ADJ, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SCP_OPMZ_INV_ADJ, UPDATE:SCP_OPMZ_INV_ADJ, DELETE:SCP_OPMZ_INV_ADJ, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0125_SAVE_STOCK_SECOND_OCV | MATCH | 1 | SP SCP0125_SAVE_STOCK_SECOND_OCV | EXEC:SCP0125_SAVE_STOCK_SECOND_OCV, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SCP_OPMZ_INV_SECOND_OCV, UPDATE:SCP_OPMZ_INV_SECOND_OCV, DELETE:SCP_OPMZ_INV_SECOND_OCV, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| GetOperationByLine | dtPlant.Rows[0] | PLANT_ID |
| GetOperationByLine | dtTemp.Rows[0] | OPERATION_ID |
| InitControls | dr | CODE, NAME, DIVISION_ID |
| InitControls | dtPlantSiteAll.Rows[i] | PLANT_ID, DIVISION_ID |
| InitSpread | drLine | CODE, NAME |
| Insert_Row | DBUtils.Filter(dtVersionNo, "DIVISION_ID = '" + division_id + "' AND CODE = '" + versionNo + "'").Rows[0] | YYYYMMDD |
| SpdMain_ClipboardPasted | dtFcstType.Select().Where(c => c["NAME"].ToString() == siMain.ActiveSheet.Cells[iRow, iCol].Text).FirstOrDefault() | CODE |
| SpdMain_ClipboardPasted | c | NAME |
| SpdMain_ClipboardPasted | dtStockType.Select().Where(c => c["NAME"].ToString() == siMain.ActiveSheet.Cells[iRow, iCol].Text).FirstOrDefault() | CODE |
| SpdMain_ComboSelChange | dtFcstType.Select().Where(c => c["NAME"].ToString() == siMain.ActiveSheet.Cells[e.Row, e.Column].Text).FirstOrDefault() | CODE |
| SpdMain_ComboSelChange | c | NAME |
| SpdMain_ComboSelChange | dtStockType.Select().Where(c => c["NAME"].ToString() == siMain.ActiveSheet.Cells[e.Row, e.Column].Text).FirstOrDefault() | CODE |
| SpdMain_ComboSelChange | dtPlant.Rows[0] | PLANT_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | RefreshPlanDate:256, RefreshVersionNo:283, RefreshVersionNo:284, RefreshSiteByDivision:294, SetVisibleSheetColumns:440, FindData_Main:564, FindData_Main:577, FindData_Main:593 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:355, InitSpread:375, InitSpread:383, InitSpread:390, InitSpread:399 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SetSheetHeaderColumnSCP | SetSpreadInit:422 | SpreadInfo.SetSheetHeaderColumnSCP | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:164 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:427 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:428 |
| this.spdMain | CellClick | spdMain_CellClick | InitEvent:430 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:431 |
| this.spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:432 |
| this.spdMain | ActiveSheetChanging | spdSub_ActiveSheetChanging | InitEvent:433 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:434 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:435 |

## 6. 컨트롤 (22개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 6 | lciVersion, lciPlanDate, Division, layoutControlItem1, layoutControlItem3, lciPlanDate_Days |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrTextBox | 2 | txtItem, txtNickName |
| UsrComboBox | 2 | cboPlanDate, cboVersion |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDatePicker | 1 | dpPlanDate_Days |
| UsrCombo | 1 | cboDivision |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 659 | FindData_Main | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 318 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 102 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
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
| SCM_MST_SHEET_COLUMNS | SCP0125 | Elec. Demand | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 |
| SCM_MST_SHEET_COLUMNS | SCP0125 | MKT FCST | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_COLUMNS | SCP0125 | STOCK | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_COLUMNS | SCP0125 | Stock(2nd OCV) | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |
| SCM_MST_SHEET_COLUMNS | SCP0125 | Stock(Elec. Plant) | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: MKT FCST, Stock, Stock(Elec. Plant), Elec. Demand, Stock(2nd OCV)
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:355, SetSheetHeaderColumn@InitSpread:375, SetSheetHeaderColumn@InitSpread:383, SetSheetHeaderColumn@InitSpread:390, SetSheetHeaderColumn@InitSpread:399, SetSheetHeaderColumnSCP@SetSpreadInit:422

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetVisibleSheetColumns |  | 447 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtMktFcst)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStock)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockElec)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtElecDemand)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockSecondOcv)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | if(_sActiveSheetName == "MKT FCST") ⟫ if(division == "40") |
| SetVisibleSheetColumns |  | 448 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtMktFcst)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStock)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockElec)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtElecDemand)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockSecondOcv)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | if(_sActiveSheetName == "MKT FCST") ⟫ if(division == "40") |
| SetVisibleSheetColumns |  | 452 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtMktFcst)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStock)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockElec)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtElecDemand)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockSecondOcv)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | if(_sActiveSheetName == "MKT FCST") ⟫ else!(division == "40") |
| SetVisibleSheetColumns |  | 453 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtMktFcst)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStock)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockElec)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtElecDemand)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockSecondOcv)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | if(_sActiveSheetName == "MKT FCST") ⟫ else!(division == "40") |
| SetVisibleSheetColumns |  | 461 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtMktFcst)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStock)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockElec)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtElecDemand)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockSecondOcv)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | if(_sActiveSheetName == "Stock"\|\| _sActiveSheetName == "Stock(Elec. Plant)") ⟫ if(_sActiveSheetName == "Stock"&& division == "81_UC") |
| SetVisibleSheetColumns |  | 462 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtMktFcst)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStock)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockElec)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtElecDemand)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockSecondOcv)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | if(_sActiveSheetName == "Stock"\|\| _sActiveSheetName == "Stock(Elec. Plant)") ⟫ if(_sActiveSheetName == "Stock"&& division == "81_UC") |
| SetVisibleSheetColumns |  | 467 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtMktFcst)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStock)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockElec)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtElecDemand)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockSecondOcv)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | if(_sActiveSheetName == "Stock"\|\| _sActiveSheetName == "Stock(Elec. Plant)") ⟫ else!(_sActiveSheetName == "Stock"&& division == "81_UC") |
| SetVisibleSheetColumns |  | 468 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtMktFcst)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStock)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockElec)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtElecDemand)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockSecondOcv)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | if(_sActiveSheetName == "Stock"\|\| _sActiveSheetName == "Stock(Elec. Plant)") ⟫ else!(_sActiveSheetName == "Stock"&& division == "81_UC") |
| SetVisibleSheetColumns |  | 473 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtMktFcst)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStock)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockElec)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtElecDemand)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtStockSecondOcv)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | else!(_sActiveSheetName == "Stock"\|\| _sActiveSheetName == "Stock(Elec. Plant)") ⟫ if(_sActiveSheetName == "Elec. Demand") |
| InitializeComponent |  | 428 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 429 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 430 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 431 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Elec. Demand | META+코드연결 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 |
| MKT FCST | META+코드연결 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |
| STOCK | META+코드연결 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |
| Stock(2nd OCV) | META+코드연결 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |
| Stock(Elec. Plant) | META+코드연결 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

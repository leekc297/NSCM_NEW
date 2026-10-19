# FP00130 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00130_Equipment.UIL\FP00130_Equipment.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00130_Equipment.UIL\FP00130_Equipment.UIL.csproj | 1303 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00130_Equipment.UIL\FP00130_Equipment.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00130_Equipment.UIL\FP00130_Equipment.UIL.csproj | 1033 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00130_Equipment.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00130_Equipment.UIL\FP00130_Equipment.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00130_Equipment.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00130_Equipment.UIL\FP00130_Equipment.UIL.csproj | 84 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00130_Equipment.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1303 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00130_Equipment.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1033 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_equip.SelectedIndexChanged | cbo_equip_SelectedIndexChanged > SetChangeControl | 1232 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cbo_equip.SelectedIndexChanged | cbo_equip_SelectedIndexChanged > SetChangeControl | 1232 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > SetChangeControl | 1232 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > SetChangeControl | 1232 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbFactory.SelectedIndexChanged | clbFactory_SelectedIndexChanged > SetChangeControl | 1232 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | clbFactory_SelectedIndexChanged > SetChangeControl | 1232 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbLine.SelectedIndexChanged | clbLine_SelectedIndexChanged > SetChangeControl | 1232 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | clbLine_SelectedIndexChanged > SetChangeControl | 1232 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > SetChangeControl | 1232 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > SetChangeControl | 1232 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | clbPlant_SelectedIndexChanged | 879 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | clbPlant_SelectedIndexChanged | 879 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | clbPlant_SelectedIndexChanged > SetChangeControl | 1232 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | clbPlant_SelectedIndexChanged > SetChangeControl | 1232 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbSite.SelectedIndexChanged | clbSite_SelectedIndexChanged > SetChangeControl | 1232 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | clbSite_SelectedIndexChanged > SetChangeControl | 1232 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Line | 566 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00130] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Line | 566 | FP\MASTER\FP00130_Equipment#saveAll_FP00130 | MATCH | [update-batch]  |
| event:this.Load | Form_Load > InitControls > clbPlant_SelectedIndexChanged | 879 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > clbPlant_SelectedIndexChanged | 879 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > cbo_equip_SelectedIndexChanged > SetChangeControl | 1232 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > cbo_equip_SelectedIndexChanged > SetChangeControl | 1232 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.CellClick | spdMain_CellClick | 1061 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | spdMain_CellClick | 1081 | biz:FPCommonDataBLL.FPCommonDataList [code=ELECTRODE_TYPE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 76 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetSite | 229 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetPlant | 236 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetFactory | 245 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetOperation | 255 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetLine | 263 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00130_SaveDataDelegate | 989 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00130] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00130_SaveDataDelegate | 989 | FP\Common\FP00130_Equipment#merge_FP00130 | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | FP00130_ValidateDataDelegate | 1009 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00130_ValidateDataDelegate | 1009 | FP\Common\FP00130_Equipment#delete_Excel_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00130_Equipment_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | FP00130_ValidateDataDelegate | 1013 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00130_ValidateDataDelegate | 1013 | FP\Common\FP00130_Equipment#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | FP00130_ValidateDataDelegate | 1019 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00130_ValidateDataDelegate | 1019 | FP\Common\FP00130_Equipment#find_Excel_buffer_validation | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00130_Equipment_find_Excel_buffer_validation.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=ELECTRODE_TYPE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT |
| biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00130] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00130] | BIZ_MATCH | 1 |  |  |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\FP00130_Equipment#delete_Excel_buffer | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00130_Equipment_delete_Excel_buffer.sql | DELETE:BUF_EQUIPMENT_M |  |
| FP\Common\FP00130_Equipment#find_Excel_buffer_validation | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00130_Equipment_find_Excel_buffer_validation.sql | SELECT:BUF_EQUIPMENT_M, SELECT:SCM_FACTORY_M, SELECT:SCM_OPERATION_M, SELECT:SCM_LINE_M, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Common\FP00130_Equipment#insert_Excel_buffer | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\FP00130_Equipment#merge_FP00130 | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\MASTER\FP00130_Equipment#saveAll_FP00130 | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnExcelImport_Click | p.KeyColumns | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, EQUIPMENT_ID, FACTORY_ID, OPERATION_ID |
| btnExcelImport_Click | p.ColumnTitle | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, EQUIPMENT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, LINE |
| cbo_equip_SelectedIndexChanged | Filter | RESOURCE_ID |
| clbFactory_SelectedIndexChanged | Filter | FACTORY_ID |
| clbOperation_SelectedIndexChanged | Filter | OPERATION_ID |
| FP00130_ValidateDataDelegate | dtUpdateResult.Rows[0] | RESULT |
| GetDivision | Filter | USER_ID |
| GetFactory | Filter | DIVISION_ID, SITE_ID, PLANT_ID |
| GetLine | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID |
| GetOperation | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| GetPlant | Filter | DIVISION_ID, SITE_ID |
| GetSite | Filter | DIVISION_ID |
| InitControls | Filter | EQUIPMENT_TYPE |
| SetChangeControl | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, RESOURCE_ID |
| spdMain_CellClick | r | CODE, NAME |
| spdMain_CellClick | SubFilter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetInnerTable | GetDivision:337, SetChangeControl:1200, SetChangeControl:1209, SetChangeControl:1221, SetChangeControl:1232, SetChangeControl:1244, SetChangeControl:1257 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| LockColumnFP | EditButton:422, EditButton:423, EditButton:424, EditButton:428, EditButton:429, EditButton:430 | FPExtensions.LockColumnFP | EDIT_YN |
| GetChanges | Save_Data_Line:565 | FPExtensions.GetChanges | ROW_ID |
| FP_UpdateBatch | Save_Data_Line:566, FP00130_SaveDataDelegate:989, FP00130_ValidateDataDelegate:1013 | DataService.FP_UpdateBatch | COUNT, RESULT |
| GetCheckedListValue | FindDataEquipmentAsync:622, clbFactory_SelectedIndexChanged:886, clbOperation_SelectedIndexChanged:902, cbo_active_SelectedIndexChanged:926, SetChangeControl:1204, SetChangeControl:1220, SetChangeControl:1231, SetChangeControl:1242 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:138 |
| clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitEvent:348 |
| clbSite | SelectedIndexChanged | clbSite_SelectedIndexChanged | InitEvent:349 |
| clbPlant | SelectedIndexChanged | clbPlant_SelectedIndexChanged | InitEvent:350 |
| clbFactory | SelectedIndexChanged | clbFactory_SelectedIndexChanged | InitEvent:351 |
| clbOperation | SelectedIndexChanged | clbOperation_SelectedIndexChanged | InitEvent:353 |
| clbLine | SelectedIndexChanged | clbLine_SelectedIndexChanged | InitEvent:354 |
| cbo_equip | SelectedIndexChanged | cbo_equip_SelectedIndexChanged | InitEvent:355 |
| cbo_active | SelectedIndexChanged | cbo_active_SelectedIndexChanged | InitEvent:356 |
| cbo_equip | Click | cbo_equip_clicked | InitEvent:358 |
| popSql | OnSql | RunSqlSource | btnSql_Click:594 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:193 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:235 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:763 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:764 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:765 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:766 |

## 6. 컨트롤 (36개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 10 | lblDivision, layoutControlItem2, lblSite, lblPlant, lblBuilding, lblSql, lblOperation, lblLine, lblEquipment, lblActive |
| UsrCheckedList2 | 4 | clbDivision, clbSite, clbFactory, clbPlant |
| UsrCombo | 4 | clbOperation, cbo_active, clbLine, cbo_equip |
| UsrButton | 3 | btnSql, btnExcelImport, usrButton2 |
| EmptySpaceItem | 3 | emptySpaceItem3, emptySpaceItem4, emptySpaceItem1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, sheetView1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| SplitContainer | 1 | splitContainer1 |
| Panel | 1 | panel1 |
| Label | 1 | label1 |

## 7. 확인 필요 (4건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1019 | FP00130_ValidateDataDelegate | FP\{?default:part_service}\FP00130_Equipment#find_Excel_buffer_validation | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1009 | FP00130_ValidateDataDelegate | FP\{?default:part_service}\FP00130_Equipment#delete_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 989 | FP00130_SaveDataDelegate | FP\{?default:part_service}\FP00130_Equipment#merge_FP00130 | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1013 | FP00130_ValidateDataDelegate | FP\{?default:part_service}\FP00130_Equipment#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 24 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 4 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 16 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00130 | Equipment | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |
| SCM_MST_SHEET_COLUMNS | FP00130 | Sub | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | FP00130 | UNUSING | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Equipment, Sub
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:308, SetSheetHeaderColumn_FP@InitSpread:315, SetSheetHeaderColumn_FP@SetSpreadInit:327

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 782 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 783 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 784 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 785 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 891 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 892 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 893 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 894 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Equipment | META+코드연결 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |
| Sub | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| UNUSING | 메타 정의만, 코드 미참조(미사용 가능) | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

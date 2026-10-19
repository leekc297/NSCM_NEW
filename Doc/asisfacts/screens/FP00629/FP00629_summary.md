# FP00629 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00629_MaterialDemandSupplySimul.UIL\FP00629_BucketSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00629_MaterialDemandSupplySimul.UIL\FP00629_MaterialDemandSupplySimul.UIL.csproj | 243 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00629_MaterialDemandSupplySimul.UIL\FP00629_BucketSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00629_MaterialDemandSupplySimul.UIL\FP00629_MaterialDemandSupplySimul.UIL.csproj | 263 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00629_MaterialDemandSupplySimul.UIL\FP00629_MaterialDemandSupplySimul.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00629_MaterialDemandSupplySimul.UIL\FP00629_MaterialDemandSupplySimul.UIL.csproj | 2343 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00629_MaterialDemandSupplySimul.UIL\FP00629_MaterialDemandSupplySimul.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00629_MaterialDemandSupplySimul.UIL\FP00629_MaterialDemandSupplySimul.UIL.csproj | 1803 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00629_MaterialDemandSupplySimul.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00629_MaterialDemandSupplySimul.UIL\FP00629_MaterialDemandSupplySimul.UIL.csproj | 37 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\FP00629_MaterialDemandSupplySimul_Ref.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 2082 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00629_MaterialDemandSupplySimul.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 2394 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00629_MaterialDemandSupplySimul.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 1805 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00629_BucketSetForm_Popup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 243 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00629_BucketSetForm_Popup.Designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 263 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed | 1092 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed | 1403 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetDivision | 1702 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetSite | 1711 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetPlant | 1722 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetOperation | 1732 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetFpPlanInfo | 1873 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetDivision | 1954 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetSite | 1963 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetPlant | 1974 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetChangeControl > SetOperation | 1984 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetFpPlanInfo | 2128 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetFpPlanInfo | 2132 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > SetPlant | 1722 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > SetPlant | 1974 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:dtpPlanDate.ValueChanged | dtpPlanDate_ValueChanged | 1129 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:dtpPlanDate.ValueChanged | dtpPlanDate_ValueChanged | 1443 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:dtpPlanDate.ValueChanged | dtpPlanDate_ValueChanged > GetFpPlanInfo | 1873 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:dtpPlanDate.ValueChanged | dtpPlanDate_ValueChanged > GetFpPlanInfo | 2128 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:dtpPlanDate.ValueChanged | dtpPlanDate_ValueChanged > GetFpPlanInfo | 2132 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 602 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 605 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 608 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 611 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 614 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 703 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 706 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 709 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 712 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 715 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetSite | 1711 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetSite | 1963 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetOperation | 1732 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetOperation | 1984 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 602 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 605 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 608 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 611 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 614 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 703 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 706 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 709 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 712 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 715 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetPlanGroup | 1688 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetDivision | 1702 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetSite | 1711 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetPlant | 1722 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetOperation | 1732 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > GetFpPlanInfo | 1873 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetPlanGroup | 1940 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetDivision | 1954 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetSite | 1963 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetPlant | 1974 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetOperation | 1984 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > GetFpPlanInfo | 2128 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > GetFpPlanInfo | 2132 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 124 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 124 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetPlanPeriod | 1777 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetPlanPeriod | 2029 | biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 2 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 2 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 21 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO, RESULT_VAL, RESULT_VAL2 |
| ApplyAmendCalendarCondition | dtMap.Rows[i] | _DATE |
| ApplySearchCondition | Filter | BUCKET_FROM, BUCKET_TO, RELEASE_FLAG, INSTANCE_ID, AMEND_TABLE, PLAN_TYPE, IS_RESULT |
| btnBucket_Click | Application.OpenForms | FP00629_BucketSetForm_Popup |
| btnColumn_Click | Application.OpenForms | FPC0097_ColumnSetForm_Popup |
| btnMrpTransit_Click | Filter | PLAN_ID, PLAN_TYPE |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| cbo_plan_group_changed | dtCurrDate.Rows[0] | CURR_DATE, PLAN_START_DATE, PLAN_END_DATE |
| cbo_planid_changed | dtPlanId.Rows[i] | PLAN_ID, READ_ONLY |
| cbo_planid_changed | Filter | PLAN_TYPE, DESCRIPTION, READ_ONLY, PLAN_NAME |
| cbo_planid_changed | dtPlanId.Rows[idx] | PLAN_TYPE, DESCRIPTION, READ_ONLY, NAME |
| CheckAndGetMeasure | measure.Data | chk_day, chk_week, chk_month |
| dtpPlanDate_ValueChanged | dtCurrDate.Rows[0] | CURR_DATE |
| Find_Data | Filter | PLAN_NAME |
| FpPlanFilterInit | dtPlanId.Rows[idx] | PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME, CODE |
| GetFpPlanInfo | Filter | POPUP_OPEN, READ_ONLY |
| GetFpPlanInfo | dtPlanId.Rows[i] | PLAN_ID |
| GetFpPlanInfo | dtPlanId.Rows[idx] | PLAN_TYPE, DESCRIPTION, READ_ONLY, NAME |
| InitControls | c | ControlName |
| InitControls | a | ControlName, ControlValue |
| InitControls | Filter | USER_ID, POPUP_OPEN |
| onNLFAmendMenu | frm.Filter | MASTER_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onNLFAmendMenu | Filter | INSTANCE_ID, FP_PLAN_ID, PLAN_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO, PLAN_TYPE |
| onZeroBucketMenu | row_to_test | CATEGORY_ID |
| onZeroMaterialMenu | row_to_test | CATEGORY_ID |
| SetBohQty | row | MATERIAL_ID, LWH_BOH, PWH_BOH, M_BOH |
| SetBohQty | rowx | MATERIAL_ID |
| SetBohQty | each_row | FACTORY_ID, OPERATION_ID, MATERIAL_ID |
| SetBohQty | dr | FACTORY_ID, OPERATION_ID, MATERIAL_ID |
| SetDivision | Filter | INSTANCE_ID |
| SetFpPlanFilterInit | dtPlanId.Rows[i] | PLAN_ID |
| SetFpPlanFilterInit | dtPlanId.Rows[idx] | PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME |
| SetOperation | Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, AMEND_MAIN_FLAG |
| SetPlanGroup | dtInstance.Rows[0] | CONFIRM_AREA |
| SetPlanInfo | dtPlanId.Rows[iRow] | DESCRIPTION, INSERT_ID, INSERT_Time, BASIC_VERSION, FACTORY_LT |
| SetPlanPeriod | Filter | INSTANCE_ID |
| SetPlanPeriod | dtPeriod.Rows[0] | START_DATE, END_DATE |
| SetPlant | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID |
| SetShortageDate | Filter | PLAN_DATE |
| SetShortageDate | each_row | _DATE, D_VALUE |
| SetShortageDate | result.First() | D_VALUE |
| SetShortageDate | dateMap.Tables[0].Rows[dateMap.Tables[0].Rows.Count - 1] | D_VALUE |
| SetShortageDate | row | IS_RESULT, SHORTAGE_DATE, PROD_SHORTAGE_DATE, IS_RESULT_COLOR, KEY_YN |
| SetShortageDate | result2.First() | D_VALUE |
| SetShortageDate | result3.First() | _DATE |
| SetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID |
| UIFindData | Filter | POPUP_OPEN, RELEASE_FLAG, PLAN_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetMeasure | Measure:134, InitControl:162, RefreshSpreadSheet:946, CheckAndGetMeasure:1184, RefreshSpreadSheet:747, CheckAndGetMeasure:989 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetFilter | InitControls:281, InitControls:282, InitControls:292, InitControls:293, InitControls:303, InitControls:304, InitControls:305, InitControls:306 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetCheckedListValue | InitControls:332, InitControls:340, UIFindData:505, UIFindData:512, ApplySearchCondition:777, cbo_plan_group_changed:1400, dtpPlanDate_ValueChanged:1440, cbo_planid_changed:1484 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | SetAmendHeaderColumn_FP_Local:1103, SetAmendHeaderColumn_FP_Local:927 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetMenuColumn | SetAmendHeaderColumn_FP_Local:1125, SetAmendHeaderColumn_FP_Local:949 | MenuService.SetMenuColumn | CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, DATA_SORT_METHOD_CODE, DEFAULT_FLAG, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, SORT_ORDER_NO, UPPERCASE_APPLY_FLAG, USER_SELECTABLE_FLAG, VALID_YN |
| SetSheetHeaderColumn | SetAmendHeaderColumn_FP_Local:1170, SetAmendHeaderColumn_FP_Local:974 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| FP_Log2 | cbo_plan_group_changed:1398, cbo_plan_group_changed:1433 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btbSet | Click | btnSet_Click | InitializeComponent:184 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:221 |
| this | Load | MeasureSetForm_Load | InitializeComponent:236 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:237 |
| this | Load | Form_Load | .ctor:192 |
| this | Load | Form_Load | .ctor:201 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:246 |
| dtpPlanDate | ValueChanged | dtpPlanDate_ValueChanged | InitEvent:247 |
| cbo_planid | SelectedIndexChanged | cbo_planid_changed | InitEvent:248 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:249 |
| cbo_site | SelectedIndexChanged | cbo_site_changed | InitEvent:250 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:251 |
| mcbo_operation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:252 |
| cboResult | SelectedIndexChanged | cboResult_changed | InitEvent:253 |
| txtPjtGroupName | TextChanged | TxtPjtGroupName_TextChanged | InitEvent:255 |
| txtModel | TextChanged | TxtModel_TextChanged | InitEvent:256 |
| txtItem | TextChanged | TxtItem_TextChanged | InitEvent:257 |
| txtNickName | TextChanged | TxtNickName_TextChanged | InitEvent:258 |
| dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitEvent:260 |
| chk_alt | CheckedChanged | chk_alt_CheckedChanged | InitEvent:262 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1819 |
| this.chk_release | CheckedChanged | chk_release_CheckedChanged | InitializeComponent:364 |
| this.txtNickName | TextChanged | TxtNickName_TextChanged | InitializeComponent:400 |
| this.txtPjtGroupName | TextChanged | TxtPjtGroupName_TextChanged | InitializeComponent:436 |
| this.chkInfo | CheckedChanged | chkInfo_CheckedChanged | InitializeComponent:476 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:516 |
| this.dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitializeComponent:569 |
| this.btnMrpTransit | Click | btnMrpTransit_Click | InitializeComponent:1209 |
| this.btnClose1 | Click | btnClose1_Click | InitializeComponent:1344 |
| this.btnMrpReceive | Click | btnMrpReceive_Click | InitializeComponent:1525 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:1612 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:1650 |
| this | Load | Form_Load | .ctor:185 |
| this | Load | Form_Load | .ctor:194 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:239 |
| dtpPlanDate | ValueChanged | dtpPlanDate_ValueChanged | InitEvent:240 |
| cbo_planid | SelectedIndexChanged | cbo_planid_changed | InitEvent:241 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:242 |
| cbo_site | SelectedIndexChanged | cbo_site_changed | InitEvent:243 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:244 |
| mcbo_operation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:245 |
| txtPjtGroupName | TextChanged | TxtPjtGroupName_TextChanged | InitEvent:247 |
| txtModel | TextChanged | TxtModel_TextChanged | InitEvent:248 |
| txtItem | TextChanged | TxtItem_TextChanged | InitEvent:249 |
| txtNickName | TextChanged | TxtNickName_TextChanged | InitEvent:250 |
| dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitEvent:252 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1488 |

## 6. 컨트롤 (82개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 17 | lblSql, layoutControlItem1, layoutControlItem9, lblFpPlanId, layoutControlItem5, layoutControlItem11, layoutControlItem7, Operation, layoutControlItem17, layoutControlItem3, layoutControlItem12, layoutControlItem14, layoutControlItem4, lblResult, layoutControlItem6 … |
| Label | 11 | label3, txtBuilding, txtBasic, txtDesc, txtCreation, txtCreator, label7, label6, label5, label4, label2 |
| CheckBox | 9 | chk_comeoh2_qty, chk_comeoh_qty, chk_day, chk_eoh2_qty, chk_eoh_qty, chk_matin_qty, chk_mat_qty, chk_qty, chk_release |
| UsrButton | 8 | btbSet, btnOK, btnSql, btnMrpTransit, usrButton2, btnMrpReceive, btnBucket, btnColumn |
| Panel | 5 | panel1, infoPanel, panel2, panel4, panel1 |
| UsrCombo | 4 | cboResult, cbo_site, cbo_planid, cbo_plan_group |
| UsrTextBox | 4 | txtNickName, txtPjtGroupName, txtItem, txtModel |
| EmptySpaceItem | 4 | emptySpaceItem3, emptySpaceItem2, emptySpaceItem4, emptySpaceItem1 |
| UsrCheckedList2 | 3 | mcbo_operation, mcbo_plant, mcbo_division |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCheckBox | 2 | chk_alt, chkInfo |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePickerWtWeek | 1 | dCalendar_planrange |
| UsrDatePickerWtWeek | 1 | dtpPlanDate |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| SplitContainer | 1 | splitter |
| Button | 1 | btnClose1 |
| ImageList | 1 | imageList1 |
| GroupBox | 1 | groupBox1 |
| UsrLabel | 1 | lblPlanID |
| TextBox | 1 | tbLog |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 24 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
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
| SCM_MST_SHEET_COLUMNS | FP00629 | Amend | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@RefreshHeaderOnly:443, SetSheetHeaderColumn@SetAmendHeaderColumn_FP_Local:1170, SetSheetHeaderColumn_FP@RefreshHeaderOnly:388, SetSheetHeaderColumn@SetAmendHeaderColumn_FP_Local:974
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetColumnHidden |  | 465 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CLASS_ID |  |
| SetColumnHidden |  | 466 | 표시/라벨 변경 | set:Visible | Visible = {?false} | IS_RESULT |  |
| SetColumnHidden |  | 468 | 표시/라벨 변경 | set:Visible | Visible = {?false} | IS_RESULT_COLOR |  |
| SetColumnHidden |  | 469 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SORT_ORDER |  |
| SetColumnHidden |  | 470 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MATERIAL_RANK |  |
| RefreshHeader |  | 1082 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?color_Blue} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null && index > -1) ⟫ if(date.isSatureDay()) |
| RefreshHeader |  | 1086 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?color_Red} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null && index > -1) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) |
| InitializeComponent |  | 1236 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1237 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1238 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1239 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetColumnHidden |  | 407 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DIVISION_ID |  |
| SetColumnHidden |  | 408 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID |  |
| SetColumnHidden |  | 409 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLANT_ID |  |
| SetColumnHidden |  | 410 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CLASS_ID |  |
| SetColumnHidden |  | 411 | 표시/라벨 변경 | set:Visible | Visible = {?false} | IS_RESULT |  |
| SetColumnHidden |  | 413 | 표시/라벨 변경 | set:Visible | Visible = {?false} | IS_RESULT_COLOR |  |
| SetColumnHidden |  | 414 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SORT_ORDER |  |
| SetColumnHidden |  | 415 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MATERIAL_RANK |  |
| RefreshHeader |  | 902 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| RefreshHeader |  | 908 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

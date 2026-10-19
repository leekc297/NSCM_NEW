# DMF0014 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0014_CustFcstUpload\DMF0014_CustFcstUpload.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0014_CustFcstUpload\DMF0014_CustFcstUpload.csproj | 1276 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0014_CustFcstUpload\DMF0014_CustFcstUpload.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0014_CustFcstUpload\DMF0014_CustFcstUpload.csproj | 1003 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0014_CustFcstUpload\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0014_CustFcstUpload\DMF0014_CustFcstUpload.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0014_CustFcstUpload\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0014_CustFcstUpload\DMF0014_CustFcstUpload.csproj | 72 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0014_CustFcstUpload\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0014_CustFcstUpload\DMF0014_CustFcstUpload.csproj | 31 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0014_CustFcstUpload.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1218 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0014_CustFcstUpload.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1003 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 1251 | DM.DMF0014_GET_SPREAD_TITLE | MATCH | SP DMF0014_GET_SPREAD_TITLE |
| event:dsdm.Changed | spdMain_Changed | 1105 | biz:CommonData.CommonDataList [code=CUST_FCST_UPLOAD_UOM] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 573 | biz:CommonData.CommonDataList [code=CustomerMeasure] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 603 | DM.DMF0014_GET_CUST_FCST_UPLOAD_DATA | MATCH | SP DMF0014_GET_CUST_FCST_UPLOAD_DATA |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 1251 | DM.DMF0014_GET_SPREAD_TITLE | MATCH | SP DMF0014_GET_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindButton > FindData | 573 | biz:CommonData.CommonDataList [code=CustomerMeasure] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindButton > FindData | 603 | DM.DMF0014_GET_CUST_FCST_UPLOAD_DATA | MATCH | SP DMF0014_GET_CUST_FCST_UPLOAD_DATA |
| button:SaveButton | SaveButton > SaveData | 734 | DM.DMF0014_SAVE_CUST_FCST_UPLOAD_DATA | MATCH | SP DMF0014_SAVE_CUST_FCST_UPLOAD_DATA |
| button:SaveButton | SaveButton > SaveData > FindButton > FindData > InitSpread > GetSpdTitle | 1251 | DM.DMF0014_GET_SPREAD_TITLE | MATCH | SP DMF0014_GET_SPREAD_TITLE |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 1251 | DM.DMF0014_GET_SPREAD_TITLE | MATCH | SP DMF0014_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls | 238 | biz:CommonData.CommonDataList [code=Division] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 292 | biz:CommonData.CommonDataList [code=DOM_EXP] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 300 | biz:CommonData.CommonDataList [code=CustomerMeasure] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1235 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1251 | DM.DMF0014_GET_SPREAD_TITLE | MATCH | SP DMF0014_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetLookupValues | 1266 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1185 | biz:CommonData.CommonDataList [code=CustomerMeasure] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1198 | biz:CommonData.CommonDataList [code=CustomerMeasure] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 55 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CUST_FCST_UPLOAD_UOM] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:DM_MST_CUSTOMER_FCST, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=CustomerMeasure] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:DM_MST_CUSTOMER_FCST, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=Division] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:CommonData.CommonDataList [code=DOM_EXP] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| DM.DMF0014_GET_CUST_FCST_UPLOAD_DATA | MATCH | 1 | SP DMF0014_GET_CUST_FCST_UPLOAD_DATA | EXEC:DMF0014_GET_CUST_FCST_UPLOAD_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, REF:FN_SCM_GET_WHERE_SQL, EXEC:SP_EXECUTESQL, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT |  |
| DM.DMF0014_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0014_GET_SPREAD_TITLE | EXEC:DMF0014_GET_SPREAD_TITLE, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0014_SAVE_CUST_FCST_UPLOAD_DATA | MATCH | 1 | SP DMF0014_SAVE_CUST_FCST_UPLOAD_DATA | EXEC:DMF0014_SAVE_CUST_FCST_UPLOAD_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, DELETE:DM_PLN_CUSTOMER_PSI, INSERT:DM_PLN_CUSTOMER_PSI, SELECT:DM_PLN_CUSTOMER_PSI, UPDATE:DM_PLN_CUSTOMER_PSI, INSERT:DM_PLN_CUSTOMER_PSI_H, EXEC:PR_DM_PLN_CUST_FCST_TO_MKT_FCST, INSERT:SCM_SYS_LOG_BATCH, SELECT:SYSCURSORS, INSERT:#TEMP_DM_PLN_CUSTOMER_PSI$, CREATE:#TEMP_CUST_FCST_DIVISION, INSERT:#TEMP_CUST_FCST_DIVISION, SELECT:#TEMP_DM_PLN_CUSTOMER_PSI$, INSERT:#TEMP_PSI_GROUP_COUNT$, SELECT:#TEMP_PSI_GROUP_COUNT$, INSERT:#TEMP3_DM_PLN_CUSTOMER_PSI$, DELETE:#TEMP3_DM_PLN_CUSTOMER_PSI$, INSERT:#TEMP2_DM_PLN_CUSTOMER_PSI$, DELETE:#TEMP2_DM_PLN_CUSTOMER_PSI$, SELECT:DM_MST_CUSTOMER_FCST, REF:FN_NEXT_DAY, SELECT:DM_MST_CUSTOMER_MODEL, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_ITEM_SN, INSERT:#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$, SELECT:SCM_SYS_CALENDAR_M, DELETE:#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#TEMP_MIN_MAX_PSI$, SELECT:#TEMP3_DM_PLN_CUSTOMER_PSI$, SELECT:#TEMP_MIN_MAX_PSI$, EXEC:PR_DM_CUST_ITEM_MAPPING, INSERT:#TEMP_DM_CUST_ITEM_MAPPING_DTL_N, SELECT:DM_CUST_ITEM_MAPPING_M, SELECT:DM_CUST_ITEM_MAPPING_DTL_N, SELECT:#TEMP_DM_CUST_ITEM_MAPPING_DTL_N, SELECT:#TEMP2_DM_PLN_CUSTOMER_PSI$, SELECT:DM_PLN_MKT_FCST, DELETE:DM_PLN_MKT_FCST, INSERT:DM_PLN_MKT_FCST, SELECT:#TEMP_CUST_FCST_DIVISION, EXEC:PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST, EXEC:PR_DM_SYS_LOG_BATCH, INSERT:#TEMP_DM_DNM_EDI_CALLOFF_ITEM, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_MST_SITE, INSERT:DM_CUST_ITEM_MAPPING_M, SELECT:#TEMP_DM_DNM_EDI_CALLOFF_ITEM, INSERT:DM_CUST_ITEM_MAPPING_DTL_N, INSERT:DM_CUST_ITEM_MAPPING_DTL_H, DELETE:DM_CUST_ITEM_MAPPING_DTL_H, INSERT:#TEMP_MKT_FCST_DATA, SELECT:#TEMP_MKT_FCST_DATA |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| DefineProperty | UserInfoContext.Current | NowGroupID |
| FindData | UserInfoContext.Current | NowGroupID |
| InitSpread | dr | COLUMN_NAME, COLUMN_LABEL, SMALL_LABEL_NAME |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:171, SetChangeControl:178, SetChangeControl:186, SetChangeControl:202, SetChangeControl:209 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetCheckedListValue | InitControls:254, InitControls:273, FindData:564, cboDivision_SelectedIndexChanged:825, cboDivision_SelectedIndexChanged:838, cboDivision_SelectedIndexChanged:853, cboDivision_SelectedIndexChanged:871, clbTeam_SelectedIndexChanged:893 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:373 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SaveData | SaveButton:483 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| FP_Log2 | cboDivision_SelectedIndexChanged:830, cboDivision_SelectedIndexChanged:888 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:220 |
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:260 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:300 |
| this.btnExcelUpload | Click | btnExcelUpload_Click | InitializeComponent:340 |
| this.btmItem | Click | btmItem_Click | InitializeComponent:523 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:559 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:873 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:874 |
| this | Load | Form_Load | .ctor:138 |
| cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:410 |
| dsdm | Changed | spdMain_Changed | InitEvent:412 |
| drpPeriod | ValueChanged | drpPeriod_ValueChanged | InitEvent:414 |

## 6. 컨트롤 (37개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 13 | lblProject, lblEndCustomer, lblScmSite, lblDivision, lblTeam, lblBtnProject, lblItem, lblBtnItemId, lblPeriod, lblBucketType, lblPlantSite, layoutControlItem1, lblDomExp |
| UsrCheckedList | 5 | clbPlantSite, clbEndCustomer, clbTeam, clbScmSite, clbDomExp |
| UsrButton | 3 | btnExcelUpload, btmItem, btnProject |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem5, emptySpaceItem2 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 2 | cboBucketType, cboDivision |
| UsrMultiLineEditor | 2 | txtProject, txtItemId |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePicker | 1 | drpPeriod |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 98 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_EXCEL_COLUMNS | 1 | dbmeta_dbo_SCM_ADM_EXCEL_COLUMNS.csv |
| dbo.TB_FX_Favorite | 4 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 133 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: FCST Upload

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 340 | 하드코딩 | AddComboColumn | Division* | DIVISION_ID |  |
| InitSpread |  | 341 | 하드코딩 | AddComboColumn | Sales Site* | SCM_SITE_ID |  |
| InitSpread |  | 342 | 하드코딩 | AddComboColumn | Plant Site* | PLANT_SITE_ID |  |
| InitSpread |  | 343 | 하드코딩 | AddTextColumn | Customer Project* | CUSTOMER_PROJECT_CODE |  |
| InitSpread |  | 344 | 하드코딩 | AddTextColumn | Customer Model* | CUSTOMER_MODEL |  |
| InitSpread |  | 345 | 하드코딩 | AddComboColumn | Incoterms* | INCOTERMS |  |
| InitSpread |  | 346 | 하드코딩 | AddComboColumn | FCST Type* | FCST_TYPE |  |
| InitSpread |  | 347 | 하드코딩 | AddComboColumn | Customs Handbook* | DOM_EXP |  |
| InitSpread |  | 348 | 하드코딩 | AddTextColumn | Measure Group* | MEASURE_GROUP |  |
| InitSpread |  | 349 | 하드코딩 | AddComboColumn | Measure* | MEASURE |  |
| InitSpread |  | 350 | 하드코딩 | AddComboColumn | Upload UOM* | UPLOAD_UOM |  |
| InitSpread |  | 351 | 하드코딩 | AddTextColumn | Project | PROJECT_CODE |  |
| InitSpread |  | 352 | 하드코딩 | AddTextColumn | Model | ITEM_ID |  |
| InitSpread |  | 353 | 하드코딩 | AddTextColumn | EDIT_FLAG | EDIT_FLAG |  |
| InitSpread |  | 388 | DB루프 | AddNumTextColumn | {?string.Empty} \|\| {?dr["COLUMN_LABEL"]} | {?string.Empty} \|\| {?dr["COLUMN_NAME"]} | foreach(dr in dtTitle.Rows) |
| InitSpread |  | 401 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sSmallLabelName == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dtTitle.Rows) ⟫ if(sSmallLabelName == "SAT"\|\| sSmallLabelName == "SUN") |
| InitializeComponent |  | 890 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 891 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 892 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 893 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| FCST Upload | 코드 하드코딩 전용(메타 없음) | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

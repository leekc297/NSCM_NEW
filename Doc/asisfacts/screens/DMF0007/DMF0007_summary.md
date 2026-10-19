# DMF0007 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0007_CustFcstMaster\DMF0007_CustFcstMaster.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0007_CustFcstMaster\DMF0007_CustFcstMaster.csproj | 1913 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0007_CustFcstMaster\DMF0007_CustFcstMaster.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0007_CustFcstMaster\DMF0007_CustFcstMaster.csproj | 577 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0007_CustFcstMaster\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0007_CustFcstMaster\DMF0007_CustFcstMaster.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0007_CustFcstMaster\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0007_CustFcstMaster\DMF0007_CustFcstMaster.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0007_CustFcstMaster\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0007_CustFcstMaster\DMF0007_CustFcstMaster.csproj | 27 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0007_CustFcstMaster.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 1735 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0007_CustFcstMaster.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 566 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivisions.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 308 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:clbDivisions.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 1850 | DM.DMF0007_GET_SPREAD_TITLE | MATCH | SP DMF0007_GET_SPREAD_TITLE |
| event:clbDivisions.SelectedIndexChanged | clbDivisions_SelectedIndexChanged > InitSpread > GetSpdTitle | 1850 | DM.DMF0007_GET_SPREAD_TITLE | MATCH | SP DMF0007_GET_SPREAD_TITLE |
| event:clbDivisions.SelectedIndexChanged | clbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 1865 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:clbDivisions.SelectedIndexChanged | clbDivisions_SelectedIndexChanged > InitSpread > GetSpdTitle | 1865 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindDataFCST | 628 | DM.DMF0007_GET_CUST_FCST_DATA | MATCH | SP DMF0007_GET_CUST_FCST_DATA |
| button:FindButton | FindButton > FindDataPSI | 711 | DM.DMF0007_GET_CUST_PSI_DATA | MATCH | SP DMF0007_GET_CUST_PSI_DATA |
| button:FindButton | FindButton > FindDataPSI > InitSpread > GetSpdTitle | 1850 | DM.DMF0007_GET_SPREAD_TITLE | MATCH | SP DMF0007_GET_SPREAD_TITLE |
| button:FindButton | FindButton > FindDataPSI > InitSpread > GetSpdTitle | 1865 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1271 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow > GetCustFcstMeasure | 1899 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| button:SaveButton | SaveButton > SaveData > FindButton > FindDataFCST | 628 | DM.DMF0007_GET_CUST_FCST_DATA | MATCH | SP DMF0007_GET_CUST_FCST_DATA |
| button:SaveButton | SaveButton > SaveData > FindButton > FindDataPSI | 711 | DM.DMF0007_GET_CUST_PSI_DATA | MATCH | SP DMF0007_GET_CUST_PSI_DATA |
| button:SaveButton | SaveButton > SaveData | 951 | DM.DMF0007_SAVE_CUST_FCST_DATA | MATCH | SP DMF0007_SAVE_CUST_FCST_DATA |
| button:SaveButton | SaveButton > SaveData | 1194 | DM.DMF0007_SAVE_CUST_FCST_DATA | MATCH | SP DMF0007_SAVE_CUST_FCST_DATA |
| button:SaveButton | SaveButton > SaveData > FindButton > FindDataPSI > InitSpread > GetSpdTitle | 1850 | DM.DMF0007_GET_SPREAD_TITLE | MATCH | SP DMF0007_GET_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindButton > FindDataPSI > InitSpread > GetSpdTitle | 1865 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 1850 | DM.DMF0007_GET_SPREAD_TITLE | MATCH | SP DMF0007_GET_SPREAD_TITLE |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 1865 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 219 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 231 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 244 | biz:CommonData.CommonDataList [code=BucketType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 250 | biz:CommonData.CommonDataList [code=UploadUOM] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 261 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 263 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1850 | DM.DMF0007_GET_SPREAD_TITLE | MATCH | SP DMF0007_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1865 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 50 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtEndCustomer40> | 138 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=BucketType] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_COLUMNS |
| biz:CommonData.CommonDataList [code=UploadUOM] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| DM.DMF0007_GET_CUST_FCST_DATA | MATCH | 1 | SP DMF0007_GET_CUST_FCST_DATA | EXEC:DMF0007_GET_CUST_FCST_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, REF:FN_SCM_GET_WHERE_SQL, EXEC:SP_EXECUTESQL, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT |  |
| DM.DMF0007_GET_CUST_PSI_DATA | MATCH | 1 | SP DMF0007_GET_CUST_PSI_DATA | EXEC:DMF0007_GET_CUST_PSI_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, REF:FN_SCM_GET_WHERE_SQL, EXEC:SP_EXECUTESQL, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT |  |
| DM.DMF0007_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0007_GET_SPREAD_TITLE | EXEC:DMF0007_GET_SPREAD_TITLE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, EXEC:SP_EXECUTESQL, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| DM.DMF0007_SAVE_CUST_FCST_DATA | MATCH | 2 | SP DMF0007_SAVE_CUST_FCST_DATA | EXEC:DMF0007_SAVE_CUST_FCST_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCM_SYS_CALENDAR_M, SELECT:DM_MST_CUSTOMER_FCST, INSERT:DM_MST_CUSTOMER_FCST, DELETE:DM_MST_CUSTOMER_FCST, EXEC:PR_DM_MST_CUSTOMER_FCST_HIST, INSERT:#TMP_SITE_CUSTOMER_MAP, REF:FN_NEXT_DAY, INSERT:#DELETE_TARGET, SELECT:DM_PLN_MKT_FCST, DELETE:T1, SELECT:#DELETE_TARGET, INSERT:DM_PLN_MKT_FCST, SELECT:#TMP_SITE_CUSTOMER_MAP, INSERT:SCM_SYS_LOG_BATCH, INSERT:DM_MST_CUSTOMER_FCST_H |  |
| DM.UP_FX_GetCommonDataList_DM | MATCH | 1 | SP UP_FX_GETCOMMONDATALIST_DM | EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtEndCustomer40> | UserInfoContext.Current | NowGroupID |
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| FindDataFCST | UserInfoContext.Current | NowGroupID |
| FindDataPSI | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InsertRow | UserInfoContext.Current | NowGroupID |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:183, SetChangeControl:190, SetChangeControl:198, SetChangeControl:207 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetCheckedListValue | InitControls:227, InitControls:239, clbDivision_SelectedIndexChanged:301, clbDivision_SelectedIndexChanged:311, clbDivision_SelectedIndexChanged:324, FindDataFCST:606, clbDivisions_SelectedIndexChanged:1702, clbDivisions_SelectedIndexChanged:1712 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:338, InitSpread:344 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:339, InitSpread:345 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:537, SaveButton:541 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| FP_Log2 | spdMain_ComboSelChange:1661, spdMain_ComboSelChange:1695, clbDivisions_SelectedIndexChanged:1701, clbDivisions_SelectedIndexChanged:1721, clbTeam_SelectedIndexChanged:1728, clbTeam_SelectedIndexChanged:1747, clbEndCustomer_SelectedIndexChanged:1752, clbEndCustomer_SelectedIndexChanged:1764 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:159 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:199 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:268 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:465 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:466 |
| this | Load | Form_Load | .ctor:149 |
| clbDivisions | SelectedIndexChanged | clbDivision_SelectedIndexChanged | CreateSpread:284 |
| clbDivisions | SelectedIndexChanged | clbDivisions_SelectedIndexChanged | InitEvent:351 |
| dsdm | Changed | shtMainFCSTDataModel_Changed | InitEvent:354 |
| dsdm2 | Changed | shtMainPSIDataModel_Changed | InitEvent:357 |

## 6. 컨트롤 (21개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 6 | lblTeam, lblEndCustomer, lblBucketType, lblSalesSite, lblActive, layoutControlItem1 |
| UsrCheckedList | 3 | clbEndCustomer, clbTeam, clbSalesSite |
| UsrCombo | 3 | cboActive, cboBucketType, clbDivisions |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem5 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 36 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 30 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 12 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 97 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0007 | Customer FCST | 7/4 | 7/4 | 7/4 | 7/4 | 7/4 | 7/4 | 7/4 | 7/4 | 7/4 | 7/4 | 7/4 | 7/4 | 7/4 | 7/4 |
| SCM_MST_SHEET_COLUMNS | DMF0007 | Customer PSI | 7/7 | 7/7 | 7/7 | 7/7 | 7/7 | 7/7 | 7/7 | 7/7 | 7/7 | 7/7 | 7/7 | 7/7 | 7/7 | 7/7 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Customer FCST, Customer PSI
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:339, CreateSheetHeaderColumn@InitSpread:345

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadColor |  | 1886 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?siMain.GetColumnText(0, iCol) == "SAT"? Color.Blue : Color.Red} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnText(0, iCol) == "SAT"\|\| siMain.GetColumnText(0, iCol) == "SUN") |
| InitializeComponent |  | 482 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 483 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 484 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 485 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Customer FCST | META+코드연결 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |
| Customer PSI | META+코드연결 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

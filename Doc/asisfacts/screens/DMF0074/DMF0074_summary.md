# DMF0074 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0074_MetalLinkPrice\DMF0074_MetalLinkPrice.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0074_MetalLinkPrice\DMF0074_MetalLinkPrice.csproj | 761 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0074_MetalLinkPrice\DMF0074_MetalLinkPrice.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0074_MetalLinkPrice\DMF0074_MetalLinkPrice.csproj | 1080 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0074_MetalLinkPrice\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0074_MetalLinkPrice\DMF0074_MetalLinkPrice.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0074_MetalLinkPrice\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0074_MetalLinkPrice\DMF0074_MetalLinkPrice.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0074_MetalLinkPrice\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0074_MetalLinkPrice\DMF0074_MetalLinkPrice.csproj | 27 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0074_MetalLinkPricePopup.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 348 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0074_MetalLinkPricePopup.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 358 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 197 | DM.DMF0074_GET_METAL_LINK_TEMPLATE | MATCH | SP DMF0074_GET_METAL_LINK_TEMPLATE |
| button:FindButton | FindButton > FindData | 443 | DM.DMF0074_GET_METAL_LINK_PRICE | MATCH | SP DMF0074_GET_METAL_LINK_PRICE |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 745 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindButton > FindData | 197 | DM.DMF0074_GET_METAL_LINK_TEMPLATE | MATCH | SP DMF0074_GET_METAL_LINK_TEMPLATE |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData | 443 | DM.DMF0074_GET_METAL_LINK_PRICE | MATCH | SP DMF0074_GET_METAL_LINK_PRICE |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData > InitSpread > GetSpdTitle | 745 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.clbDivisions.SelectedIndexChanged | clbDivisions_SelectedIndexChanged > InitSpread > GetSpdTitle | 745 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls | 96 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 176 | biz:CommonData.CommonDataList [code=UpperDeptId] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 287 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 745 | DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | SP DMF0000_GET_COMMON_SPREAD_TITLE |
| unreached:(진입점 미연결) | GetDayRange | 231 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=UpperDeptId] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO |
| DM.DMF0000_GET_COMMON_SPREAD_TITLE | MATCH | 2 | SP DMF0000_GET_COMMON_SPREAD_TITLE | EXEC:DMF0000_GET_COMMON_SPREAD_TITLE, SELECT:SCM_MST_TITLESET_USER, REF:FN_GET_DIVISION_YN, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |  |
| DM.DMF0074_GET_METAL_LINK_PRICE | MATCH | 1 | SP DMF0074_GET_METAL_LINK_PRICE | EXEC:DMF0074_GET_METAL_LINK_PRICE, CREATE:#TMP_SEARCHED_METAL_LINK_PRICE, INSERT:#TMP_SEARCHED_METAL_LINK_PRICE, SELECT:DM_BPS_METAL_LINK_PRICE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:SCM_MST_PROJECT, REF:UF_FX_STRING_SPLITFORIN, SELECT:DM_BPS_METAL_LINK_PRICE_C, INSERT:#TMP_APPLY_PRICE_TYPE, SELECT:#TMP_SEARCHED_METAL_LINK_PRICE, INSERT:#TMP_FROM_PERIOD, INSERT:#TMP_TO_PERIOD, INSERT:#TMP_CONTRACT_UNIT, INSERT:#TMP_METAL_APPLY, INSERT:#TMP_METAL_REQR, INSERT:#TEMP_METAL_KEY_VALUE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:#TMP_APPLY_PRICE_TYPE, SELECT:#TEMP_METAL_KEY_VALUE, SELECT:#TMP_FROM_PERIOD, SELECT:#TMP_TO_PERIOD, SELECT:#TMP_CONTRACT_UNIT, SELECT:#TMP_METAL_APPLY, SELECT:#TMP_METAL_REQR, SELECT:SPLIT |  |
| DM.DMF0074_GET_METAL_LINK_TEMPLATE | MATCH | 1 | SP DMF0074_GET_METAL_LINK_TEMPLATE | EXEC:DMF0074_GET_METAL_LINK_TEMPLATE, INSERT:#TEMP_VERSION_NO, REF:FN_NEXT_DAY, SELECT:DM_MST_VERSION, SELECT:SCM_SYS_CALENDAR_M, INSERT:#RTNTMP, SELECT:DM_PLN_SALES_PLAN_C, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE_ITEM, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:#TEMP_VERSION_NO, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_ITEM_SN, SELECT:DM_PLN_SALES_PLAN_RESULT_C, SELECT:#RTNTMP |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnSPVer_Click | UserInfoContext.Current | TimeZone |
| InitControls | UserInfoContext.Current | NowGroupID |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetDMInnerTable | SetChangeControl:109, SetChangeControl:116, SetChangeControl:124, SetChangeControl:131, SetChangeControl:140, SetChangeControl:147, SetChangeControl:155 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetCheckedListValue | InitControls:174, InitControls:181, InitControls:210, FindData:408, clbDivisions_SelectedIndexChanged:515, clbDivisions_SelectedIndexChanged:520, clbDivisions_SelectedIndexChanged:565, clbTeam_SelectedIndexChanged:608 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:279, InitSpread:124 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:280, InitSpread:125 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| FP_Log2 | clbDivisions_SelectedIndexChanged:514, clbDivisions_SelectedIndexChanged:570 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:198 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:238 |
| this.btnExcelUpload | Click | btnExcelUpload_Click | InitializeComponent:278 |
| this.btmItem | Click | btmItem_Click | InitializeComponent:421 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:457 |
| this.btnSPVer | Click | btnSPVer_Click | InitializeComponent:639 |
| this.btnTemplate | Click | btnTemplate_Click | InitializeComponent:680 |
| this | Load | Form_Load | .ctor:80 |
| this.txtProject | KeyDown | txtProject_KeyDown | DefineProperty:247 |
| this.txtItemId | KeyDown | txtItemId_KeyDown | DefineProperty:248 |
| this.clbDivisions | SelectedIndexChanged | clbDivisions_SelectedIndexChanged | DefineProperty:249 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:160 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:266 |
| this | Load | Form_Load | .ctor:71 |

## 6. 컨트롤 (54개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 16 | lblProject, lblEndCustomer, lblScmSite, lblTeam, lblBtnProject, lblItem, lblBtnItemId, lblPlantSite, layoutControlItem1, layoutControlItem5, lblDivision1, lblVersion, layoutControlItem7, layoutControlItem29, layoutControlItem2 … |
| EmptySpaceItem | 7 | emptySpaceItem1, emptySpaceItem3, emptySpaceItem4, emptySpaceItem5, emptySpaceItem2, emptySpaceItem1, emptySpaceItem3 |
| UsrCheckedList | 5 | clbEndCustomer, clbTeam, clbScmSite, clbPlantSite, clbDivisions |
| UsrButton | 5 | btnExcelUpload, btmItem, btnProject, btnSPVer, btnTemplate |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrMultiLineEditor | 3 | txtProject, txtItemId, txtVersion |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrMonthRangePicker | 1 | drpPeriodMonth |
| UsrCombo | 1 | clbDivisions |
| ImageList | 1 | imageList1 |
| UsrButtonList | 1 | btnButtonList |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 453 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_EXCEL_COLUMNS | 2 | dbmeta_dbo_SCM_ADM_EXCEL_COLUMNS.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 58 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 1 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
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
| SCM_MST_SHEET_COLUMNS | DMF0074 | Metal Link Price | 53/0 | 55/0 | 55/0 | 55/0 | 55/0 | 55/0 | 55/0 | 55/0 | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 8개 시트×division 비교, 차이 0건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Metal Link Price
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:280, CreateSheetHeaderColumn@InitSpread:125

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 956 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 957 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 958 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 959 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 282 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 283 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 284 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 285 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Metal Link Price | META+코드연결 | 53 | 55 | 55 | 55 | 55 | 55 | 55 | 55 | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

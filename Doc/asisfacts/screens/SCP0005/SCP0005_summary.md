# SCP0005 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| shared | 06.UIL\GSCM.SCM.Popup.UIL\SCP0005_DistributionRoutePopup.cs | 06.UIL\GSCM.SCM.Popup.UIL\GSCM.SCM.Popup.UIL.csproj | 192 |
| shared | 06.UIL\GSCM.SCM.Popup.UIL\SCP0005_DistributionRoutePopup.Designer.cs | 06.UIL\GSCM.SCM.Popup.UIL\GSCM.SCM.Popup.UIL.csproj | 115 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0005_DistributionRoute\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0005_DistributionRoute\SCP0005_DistributionRoute.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0005_DistributionRoute\SCP0005_DistributionRoute.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0005_DistributionRoute\SCP0005_DistributionRoute.csproj | 1389 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0005_DistributionRoute\SCP0005_DistributionRoute.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0005_DistributionRoute\SCP0005_DistributionRoute.csproj | 619 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 171 | SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | MATCH | SP SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID |
| button:FindButton | FindButton > FindDataMain | 424 | SCP.SCP0005_GET_DISTRIBUTION_ROUTE | MATCH | SP SCP0005_GET_DISTRIBUTION_ROUTE |
| button:FindButton | FindButton > FindDataReceive | 499 | SCP.SCP0005_GET_DISTRIBUTION_ROUTEID | MATCH | SP SCP0005_GET_DISTRIBUTION_ROUTEID |
| button:FindButton | FindButton > GetData_Country | 916 | SCP.SCP0005_GET_COUNTRY_CITY | MATCH | SP SCP0005_GET_COUNTRY_CITY |
| button:SaveButton | SaveButton > SaveData > FindDataMain | 424 | SCP.SCP0005_GET_DISTRIBUTION_ROUTE | MATCH | SP SCP0005_GET_DISTRIBUTION_ROUTE |
| button:SaveButton | SaveButton > SaveData | 752 | SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE | MATCH | SP SCP0005_SAVE_DISTRIBUTION_ROUTE |
| event:this.btnEaxel_Upload.Click | btnEaxel_Upload_Click > FindDataMain | 424 | SCP.SCP0005_GET_DISTRIBUTION_ROUTE | MATCH | SP SCP0005_GET_DISTRIBUTION_ROUTE |
| event:this.Load | Form_Load > FindData | 171 | SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | MATCH | SP SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID |
| unreached:(진입점 미연결) | <field:dtFromCountry> | 44 | biz:CommonData.CommonDataList [code=COUNTRY_MST] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtToCountry> | 46 | biz:CommonData.CommonDataList [code=COUNTRY_MST] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 48 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtTransMode> | 49 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtValidYN> | 51 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetFromSitebyDivision | 1187 | biz:CommonData.CommonDataList [code=FromSiteByDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetToSitebyDivision | 1195 | biz:CommonData.CommonDataList [code=ToSiteByDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetBodType | 1207 | biz:CommonData.CommonDataList [code=BodType] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetTransMode | 1217 | biz:CommonData.CommonDataList [code=TransportMode] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=BodType] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=COUNTRY_MST] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_COUNTRY |
| biz:CommonData.CommonDataList [code=FromSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=ToSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=TransportMode] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCP.SCP0005_GET_COUNTRY_CITY | MATCH | 1 | SP SCP0005_GET_COUNTRY_CITY | EXEC:SCP0005_GET_COUNTRY_CITY, SELECT:SCM_MST_CITY |  |
| SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | MATCH | 1 | SP SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | EXEC:SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID, SELECT:SCM_MST_CITY, REF:FN_GET_LOOKUP_CODE_DESC, SELECT:SCP_MST_DISTRIBUTION_ROUTE_H, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0005_GET_DISTRIBUTION_ROUTE | MATCH | 1 | SP SCP0005_GET_DISTRIBUTION_ROUTE | EXEC:SCP0005_GET_DISTRIBUTION_ROUTE, SELECT:SCM_MST_CITY, REF:FN_GET_LOOKUP_CODE_DESC, SELECT:SCP_MST_DISTRIBUTION_ROUTE, REF:STRING_SPLIT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0005_GET_DISTRIBUTION_ROUTEID | MATCH | 1 | SP SCP0005_GET_DISTRIBUTION_ROUTEID | EXEC:SCP0005_GET_DISTRIBUTION_ROUTEID, SELECT:SCM_MST_CITY, REF:FN_GET_LOOKUP_CODE_DESC, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE | MATCH | 1 | SP SCP0005_SAVE_DISTRIBUTION_ROUTE | EXEC:SCP0005_SAVE_DISTRIBUTION_ROUTE, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCP_MST_DISTRIBUTION_ROUTE_HIST, UPDATE:SCP_MST_DISTRIBUTION_ROUTE, INSERT:SCP_MST_DISTRIBUTION_ROUTE, DELETE:SCP_MST_DISTRIBUTION_ROUTE, SELECT:SCP_MST_DISTRIBUTION_ROUTE, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_MST_DISTRIBUTION_ROUTE_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:UserGroup> | UserInfoContext.Current | NowGroupID |
| InitControls | c | ControlName |
| InitControls | ManualSearchCondition.Tables[0].Rows[0] | ControlValue |
| SaveData | dtErr.Rows[0] | ERR_MESSAGE |
| SetCityCode | drsFrom[0] | COUNTRY, CITY, CITY_NAME |
| SetCityCode | drsTo[0] | COUNTRY, CITY, CITY_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpread:136, InitSpread:246 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:333 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | FindDataMain:404 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:98 |
| this.btnToSrch | Click | btnToSrch_Click | InitializeComponent:244 |
| this.btnFromSrch | Click | btnFromSrch_Click | InitializeComponent:280 |
| this.btnExcel_Form | Click | btnExcel_Form_Click | InitializeComponent:327 |
| this | Load | Form_Load | .ctor:144 |
| spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitEvent:187 |
| this.btnEaxel_Upload | Click | btnEaxel_Upload_Click | InitEvent:189 |
| dsdm | Changed | spdMainDataModel_Changed | InitEvent:192 |
| dsdm | Changed | spdMainDataModel_Changed | spdMainDataModel_Changed:970 |
| dsdm | Changed | spdMainDataModel_Changed | spdMainDataModel_Changed:1082 |
| dsdm | Changed | spdMainDataModel_Changed | spdMain_CellDoubleClick:1135 |
| dsdm | Changed | spdMainDataModel_Changed | spdMain_CellDoubleClick:1164 |

## 6. 컨트롤 (32개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 10 | layoutControlItem6, layoutControlItem7, layoutControlItem3, layoutControlItem4, layoutControlItem5, layoutControlItem2, layoutControlItem1, layoutControlItem8, layoutControlItem9, layoutControlItem10 |
| TextBox | 4 | txtFromCountry, txtFromCity, txtToCountry, txtToCity |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 2 | btnToSrch, btnFromSrch |
| SimpleButton | 2 | btnEaxel_Upload, btnExcel_Form |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem4 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCombo | 1 | cboValidYN |
| UsrCheckedList | 1 | clbTransMode |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 20 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_EXCEL_COLUMNS | 1 | dbmeta_dbo_SCM_ADM_EXCEL_COLUMNS.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 55 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 16 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 32 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0005 | Distribution Route | 39/0 | 39/0 | 39/0 | 39/0 | 39/0 | 39/0 | 39/0 | 39/0 | 39/0 | 39/0 | 39/0 | 39/0 | 39/0 | 39/0 |
| SCM_MST_SHEET_COLUMNS | SCP0005 | POPUP | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: POPUP, Distribution Route
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:136, SetSheetHeaderColumn@InitSpread:246
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 65 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 66 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 67 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 68 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 515 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 516 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 517 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 518 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Distribution Route | META+코드연결 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 |
| POPUP | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

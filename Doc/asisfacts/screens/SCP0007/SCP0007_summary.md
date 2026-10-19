# SCP0007 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| shared | 06.UIL\GSCM.SCM.Popup.UIL\SCP0007_DistributionRoutePopup.cs | 06.UIL\GSCM.SCM.Popup.UIL\GSCM.SCM.Popup.UIL.csproj | 713 |
| shared | 06.UIL\GSCM.SCM.Popup.UIL\SCP0007_DistributionRoutePopup.Designer.cs | 06.UIL\GSCM.SCM.Popup.UIL\GSCM.SCM.Popup.UIL.csproj | 700 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0007_BOD\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0007_BOD\SCP0007_BOD.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0007_BOD\SCP0007_BOD.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0007_BOD\SCP0007_BOD.csproj | 1471 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0007_BOD\SCP0007_BOD.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0007_BOD\SCP0007_BOD.csproj | 684 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:dsdm.Changed | SpdMain_Changed > SetCityCode | 1448 | SCP.SCP0007_GET_ROUTE_CNT | MATCH | SP SCP0007_GET_ROUTE_CNT |
| button:FindButton | FindButton > FindDataMain | 436 | SCP.SCP0005_GET_DISTRIBUTION_ROUTE | MATCH | SP SCP0005_GET_DISTRIBUTION_ROUTE |
| button:FindButton | FindButton > FindData_Main | 553 | SCP.SCP0007_GET_BOD | MATCH | SP SCP0007_GET_BOD |
| button:FindButton | FindButton > GetData_Country | 626 | SCP.SCP0007_GET_COUNTRY_CITY | MATCH | SP SCP0007_GET_COUNTRY_CITY |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 553 | SCP.SCP0007_GET_BOD | MATCH | SP SCP0007_GET_BOD |
| button:SaveButton | SaveButton > SaveData_Main | 794 | SCP.SCP0007_SAVE_BOD | MATCH | SP SCP0007_SAVE_BOD |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindDataMain | 436 | SCP.SCP0005_GET_DISTRIBUTION_ROUTE | MATCH | SP SCP0005_GET_DISTRIBUTION_ROUTE |
| event:this.Load | Form_Load > FindDataMain | 436 | SCP.SCP0005_GET_DISTRIBUTION_ROUTE | MATCH | SP SCP0005_GET_DISTRIBUTION_ROUTE |
| unreached:(진입점 미연결) | <field:dtFromCountry> | 44 | biz:CommonData.CommonDataList [code=COUNTRY_MST] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtToCountry> | 46 | biz:CommonData.CommonDataList [code=COUNTRY_MST] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 48 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtTransMode> | 49 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtIncoterms> | 65 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtTransMode> | 66 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtValidYN> | 68 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtIncotermsEdit> | 69 | biz:CommonData.CommonDataList [code=incotermsEdit] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetDivision | 540 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetFromSitebyDivision | 549 | biz:CommonData.CommonDataList [code=FromSiteByDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetToSitebyDivision | 557 | biz:CommonData.CommonDataList [code=ToSiteByDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetBodType | 569 | biz:CommonData.CommonDataList [code=BodType] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetTransMode | 579 | biz:CommonData.CommonDataList [code=TransportMode] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=BodType] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=COUNTRY_MST] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_COUNTRY |
| biz:CommonData.CommonDataList [code=FromSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=incotermsEdit] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=ToSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=TransportMode] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCP.SCP0005_GET_DISTRIBUTION_ROUTE | MATCH | 1 | SP SCP0005_GET_DISTRIBUTION_ROUTE | EXEC:SCP0005_GET_DISTRIBUTION_ROUTE, SELECT:SCM_MST_CITY, REF:FN_GET_LOOKUP_CODE_DESC, SELECT:SCP_MST_DISTRIBUTION_ROUTE, REF:STRING_SPLIT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0007_GET_BOD | MATCH | 1 | SP SCP0007_GET_BOD | EXEC:SCP0007_GET_BOD, REF:STRING_SPLIT, DYNAMIC@SCP0007_GET_BOD |  |
| SCP.SCP0007_GET_COUNTRY_CITY | MATCH | 1 | SP SCP0007_GET_COUNTRY_CITY | EXEC:SCP0007_GET_COUNTRY_CITY, SELECT:SCM_MST_SITE, REF:STRING_SPLIT |  |
| SCP.SCP0007_GET_ROUTE_CNT | MATCH | 1 | SP SCP0007_GET_ROUTE_CNT | EXEC:SCP0007_GET_ROUTE_CNT, SELECT:SCP_MST_DISTRIBUTION_ROUTE |  |
| SCP.SCP0007_SAVE_BOD | MATCH | 1 | SP SCP0007_SAVE_BOD | EXEC:SCP0007_SAVE_BOD, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_MST_DISTRIBUTION_ROUTE, EXEC:PR_SCP_MST_BOD_HIST, MERGE:SCP_MST_BOD, UPDATE:SCP_MST_BOD_ITEM, SELECT:SCP_MST_BOD, DELETE:SCP_MST_BOD, EXEC:PR_SCP_MST_BOD_ITEM, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_MST_BOD_H, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#TMP_SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE_ITEM, SELECT:SCP_MST_FINAL_ITEM_V, INSERT:SCP_MST_BOD_ITEM, REF:FN_NEXT_DAY, REF:STRING_SPLIT, SELECT:SCM_MST_SITE, SELECT:#TMP_SCM_MST_SITE_ITEM, SELECT:SCP_MST_BOD_ITEM, UPDATE:X |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtFromSiteAll> | UserInfoContext.Current | NowGroupID |
| <field:dtFromSiteOfSpdAll> | UserInfoContext.Current | NowGroupID |
| <field:dtToSiteOfSpdAll1> | UserInfoContext.Current | NowGroupID |
| <field:dtToSiteOfSpdAll2> | UserInfoContext.Current | NowGroupID |
| <field:UserGroup> | UserInfoContext.Current | NowGroupID |
| EditButton | drsTo[0] | SITE_TYPE |
| SaveData_Main | dtErr.Rows[0] | ERR_MESSAGE |
| SetCityCode | drsFrom[0] | COUNTRY, CITY |
| SetCityCode | drsTo[0] | COUNTRY, CITY, VMI_YN, SITE_TYPE |
| SetCityCode | ds.Tables[0].Rows[0] | route_cnt |
| spdMain_CellDoubleClick | dr | ROUTE_ID, TRANSPORT_MODE_NAME, PRIORITY, DAYS_MON, DAYS_TUE, DAYS_WED, DAYS_THU, DAYS_FRI, DAYS_SAT, DAYS_SUN, VALID_YN, LT_SUM, LT_TYPE |
| SpdMain_ClipboardPasted | dr | OSP_YN, CITY |
| SpdMain_ComboSelChange | dr | OSP_YN, CITY |
| SpdMain_EditChange | drsTo[0] | SITE_TYPE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangeControl:240, FindData_Main:517, FindData_Main:518, FindData_Main:530, FindData_Main:531, FindData_Main:532, FindData_Main:533, FindData_Main:534 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:275 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnToSrch | Click | btnToSrch_Click | InitializeComponent:168 |
| this.btnFromSrch | Click | btnFromSrch_Click | InitializeComponent:238 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:394 |
| this | Load | Form_Load | .ctor:149 |
| spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitEvent:201 |
| dsdm | Changed | spdMainDataModel_Changed | InitEvent:203 |
| dsdm | Changed | spdMainDataModel_Changed | spdMainDataModel_Changed:489 |
| dsdm | Changed | spdMainDataModel_Changed | spdMainDataModel_Changed:521 |
| this | Load | Form_Load | .ctor:157 |
| clbDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:176 |
| spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitEvent:178 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:179 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:180 |
| spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:181 |
| spdMain | KeyPress | SpdMain_KeyPress | InitEvent:182 |
| spdMain | EditChange | SpdMain_EditChange | InitEvent:183 |
| dsdm | Changed | SpdMain_Changed | InitEvent:186 |
| dsdm | Changed | SpdMain_Changed | spdMain_CellDoubleClick:1073 |
| dsdm | Changed | SpdMain_Changed | spdMain_CellDoubleClick:1104 |
| dsdm | Changed | SpdMain_Changed | SpdMain_Changed:1284 |
| dsdm | Changed | SpdMain_Changed | SpdMain_Changed:1315 |

## 6. 컨트롤 (54개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 16 | layoutControlItem5, layoutControlItem6, layoutControlItem7, layoutControlItem8, layoutControlItem9, layoutControlItem1, layoutControlItem2, layoutControlItem10, layoutControlItem1, layoutControlItem3, layoutFrom, layoutToSite, layoutIncoterms, layoutTransMode, layoutSSPIncoterms … |
| EmptySpaceItem | 6 | emptySpaceItem1, emptySpaceItem5, emptySpaceItem7, emptySpaceItem6, emptySpaceItem1, emptySpaceItem3 |
| UsrCheckedList2 | 6 | clbDivision, clbIncotermsSSP, clbTransMode, clbIncoterms, clbToSite, clbFromSite |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrMultiLineEditor | 4 | txtToCity, txtToCountry, txtFromCity, txtFromCountry |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrButton | 2 | btnToSrch, btnFromSrch |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| ImageList | 2 | imageList1, imageList1 |
| UsrCombo | 2 | cboValidYN, cboInputStatus |
| UsrButtonList | 1 | btnButtonList |
| UsrCheckedList | 1 | clbTransMode |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 65 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 8 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 39 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 71 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 473 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0007 | BOD | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Distribution Route, BOD
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:275

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 264 | 하드코딩 | AddTextColumn | Route Id | ROUTE_ID | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 265 | 하드코딩 | AddTextColumn | L/T Type | LT_TYPE | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 266 | 하드코딩 | AddComboColumn | Valid | VALID_YN | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 267 | 하드코딩 | AddTextColumn | City Name | FROM_CITY_NAME | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 268 | 하드코딩 | AddExTextColumn | Country | FROM_COUNTRY | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 269 | 하드코딩 | AddExTextColumn | City | FROM_CITY | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 271 | 하드코딩 | AddTextColumn | Trans Mode | TRANSPORT_MODE_NAME | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 272 | 하드코딩 | AddNumTextColumn | Priority | PRIORITY | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 273 | 하드코딩 | AddComboColumn | Mon | DAYS_MON | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 274 | 하드코딩 | AddComboColumn | Tue | DAYS_TUE | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 275 | 하드코딩 | AddComboColumn | Wed | DAYS_WED | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 276 | 하드코딩 | AddComboColumn | Thu | DAYS_THU | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 277 | 하드코딩 | AddComboColumn | Fri | DAYS_FRI | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 278 | 하드코딩 | AddComboColumn | Sat | DAYS_SAT | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 279 | 하드코딩 | AddComboColumn | Sun | DAYS_SUN | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 280 | 하드코딩 | AddTextColumn | Departure Days | DAYS | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 281 | 하드코딩 | AddTextColumn | Port | D_PORT_NAME | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 282 | 하드코딩 | AddExTextColumn | Country | D_COUNTRY | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 283 | 하드코딩 | AddExTextColumn | Port Code | D_PORT_CODE | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 284 | 하드코딩 | AddTextColumn | Port | A_PORT_NAME | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 285 | 하드코딩 | AddExTextColumn | Country | A_COUNTRY | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 286 | 하드코딩 | AddExTextColumn | Port Code | A_PORT_CODE | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 287 | 하드코딩 | AddExTextColumn | Shipping Company | SHIPPING_COMPANY | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 288 | 하드코딩 | AddTextColumn | City Name | TO_CITY_NAME | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 289 | 하드코딩 | AddExTextColumn | Country | TO_COUNTRY | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 290 | 하드코딩 | AddExTextColumn | City | TO_CITY | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 291 | 하드코딩 | AddDateColumn | Shipping Document Preparation Data | SHIP_DOC_PREPARATION_DATE | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 292 | 하드코딩 | AddNumTextColumn | Departure Inland | LT_DEPARTURE_INLAND | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 293 | 하드코딩 | AddNumTextColumn | Waiting For Shipping | LT_WAIT_SHIPPING | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 294 | 하드코딩 | AddNumTextColumn | Sea/Air Ferry | LT_VOYAGE | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 295 | 하드코딩 | AddNumTextColumn | Lay Off/Customs Clearance | LT_LAY_OFF_CLEARANCE | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 296 | 하드코딩 | AddNumTextColumn | Arrival Inland | LT_ARRIVAL_INLAND | if(spreadInfo.SheetName == "Distribution Route") |
| InitSpread |  | 297 | 하드코딩 | AddNumTextColumn | Sum | LT_SUM | if(spreadInfo.SheetName == "Distribution Route") |
| InitializeComponent |  | 600 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 601 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 602 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 603 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 277 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  |  |
| InitSpread |  | 338 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SAFETY_STOCK |  |
| InitializeComponent |  | 586 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 587 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 588 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 589 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| BOD | META+코드연결 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 |
| Distribution Route | 코드 하드코딩 전용(메타 없음) | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

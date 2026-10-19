# DM0015 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Master.UIL\DM0015_BOD.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 1331 |
| only | 06.UIL\GSCM.DM.Master.UIL\DM0015_BOD.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 567 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindDataMain | 562 | DM.DM0015_GET_BOD_DATA | MATCH | SP DM0015_GET_BOD_DATA |
| button:FindButton | FindButton > FindDataSub | 606 | DM.DM0015_GET_BOD_ITEM_DATA | MATCH | SP DM0015_GET_BOD_ITEM_DATA |
| button:FindButton | FindButton > FindDataSub > InitSpread > GetSpdTitle | 1304 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow > GetItemBySite | 1222 | biz:CommonData.CommonDataList [code=ItemBySite] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindDataMain | 562 | DM.DM0015_GET_BOD_DATA | MATCH | SP DM0015_GET_BOD_DATA |
| button:SaveButton | SaveButton > SaveData > FindDataSub | 606 | DM.DM0015_GET_BOD_ITEM_DATA | MATCH | SP DM0015_GET_BOD_ITEM_DATA |
| button:SaveButton | SaveButton > SaveData | 813 | DM.DM0015_SAVE_BOD_DATA | MATCH | SP DM0015_SAVE_BOD_DATA |
| button:SaveButton | SaveButton > SaveData | 813 | DM.DM0015_SAVE_BOD_ITEM_DATA | MATCH | SP DM0015_SAVE_BOD_ITEM_DATA |
| button:SaveButton | SaveButton > SaveData | 959 | DM.DM0015_SAVE_BOD_DATA | MATCH | SP DM0015_SAVE_BOD_DATA |
| button:SaveButton | SaveButton > SaveData | 959 | DM.DM0015_SAVE_BOD_ITEM_DATA | MATCH | SP DM0015_SAVE_BOD_ITEM_DATA |
| button:SaveButton | SaveButton > SaveData > FindDataSub > InitSpread > GetSpdTitle | 1304 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > GetFromSitebyDivision | 1147 | biz:CommonData.CommonDataList [code=FromSiteByDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDivision | 1138 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetFromSitebyDivision | 1147 | biz:CommonData.CommonDataList [code=FromSiteByDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetToSitebyDivision | 1155 | biz:CommonData.CommonDataList [code=ToSiteByDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetBodType | 1167 | biz:CommonData.CommonDataList [code=BodType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetTransMode | 1177 | biz:CommonData.CommonDataList [code=TransportMode] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetIncoterms | 1186 | biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPortBySite | 1206 | biz:CommonData.CommonDataList [code=PortBySite] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetItemBySite | 1222 | biz:CommonData.CommonDataList [code=ItemBySite] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1304 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindDataSub | 606 | DM.DM0015_GET_BOD_ITEM_DATA | MATCH | SP DM0015_GET_BOD_ITEM_DATA |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > FindDataSub > InitSpread > GetSpdTitle | 1304 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetSiteByEndCustomer | 1214 | biz:CommonData.CommonDataList [code=SiteByEndCustomer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 48 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=BodType] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=FromSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=Incoterms] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList_SCP:SELECT:SCP_MST_BOD_V, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=ItemBySite] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=PortBySite] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SiteByEndCustomer] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE, UP_FX_GETCOMMONDATALIST_DM:REF:STRING_SPLIT, UP_FX_GETCOMMONDATALIST_DM:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_COLUMNS |
| biz:CommonData.CommonDataList [code=ToSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=TransportMode] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| DM.DM0015_GET_BOD_DATA | MATCH | 1 | SP DM0015_GET_BOD_DATA | EXEC:DM0015_GET_BOD_DATA, SELECT:SCM_MST_BOD, SELECT:SCM_MST_SITE, SELECT:TB_FX_USERGROUPAUTHEXTENTION, REF:VALUE, REF:NODES |  |
| DM.DM0015_GET_BOD_ITEM_DATA | MATCH | 1 | SP DM0015_GET_BOD_ITEM_DATA | EXEC:DM0015_GET_BOD_ITEM_DATA, SELECT:SCM_MST_BOD_ITEM, REF:VALUE, REF:NODES |  |
| DM.DM0015_SAVE_BOD_DATA | MATCH | 2 | SP DM0015_SAVE_BOD_DATA | EXEC:DM0015_SAVE_BOD_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_DM_MST_BOD_HIST, MERGE:SCM_MST_BOD, SELECT:SCM_MST_BOD, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_MST_BOD_H |  |
| DM.DM0015_SAVE_BOD_ITEM_DATA | MATCH | 2 | SP DM0015_SAVE_BOD_ITEM_DATA | EXEC:DM0015_SAVE_BOD_ITEM_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_DM_MST_BOD_ITEM_HIST, MERGE:SCM_MST_BOD_ITEM, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_MST_BOD_ITEM_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:UserGroup> | UserInfoContext.Current | NowGroupID |
| GetEndCustomerByDivision | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:425, InitSpread:430 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:426, InitSpread:431 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:532 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:310 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:391 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:392 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:393 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:394 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:446 |
| this | Load | Form_Load | .ctor:196 |

## 6. 컨트롤 (21개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 5 | layoutControlItem2, layoutControlItem1, layoutControlItem3, layoutControlItem4, Active |
| UsrCheckedList | 4 | clbToSite, clbFromSite, clbBodType, clbDivision |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCombo | 1 | clbActive |
| EmptySpaceItem | 1 | emptySpaceItem1 |
| SplitContainer | 1 | splitContainer1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 11 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 41 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DM0015 | Bod | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 | 31/0 |
| SCM_MST_SHEET_COLUMNS | DM0015 | Bod Item | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Bod, Bod Item
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:426, CreateSheetHeaderColumn@InitSpread:431

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread2 |  | 300 | 하드코딩 | AddTextColumn | BOD | BOD_ID | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 301 | 하드코딩 | AddComboColumn | Division | DIVISION_ID | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 302 | 하드코딩 | AddComboColumn | BOD Type | BOD_TYPE | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 303 | 하드코딩 | AddComboColumn | End Customer | END_CUSTOMER | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 304 | 하드코딩 | AddComboColumn | To Site | TO_SITE | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 305 | 하드코딩 | AddTextColumn | Hub Sloc | HUB_SLOC | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 306 | 하드코딩 | AddComboColumn | Incoterms | INCOTERMS | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 307 | 하드코딩 | AddComboColumn | From Site | FROM_SITE | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 308 | 하드코딩 | AddNumColumn | Priority | PRIORITY | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 309 | 하드코딩 | AddComboColumn | Ship Method | TRANSPORT_MODE | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 310 | 하드코딩 | AddComboColumn | Mon | PERIOD_SHIPSCH_MON | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 311 | 하드코딩 | AddComboColumn | Tue | PERIOD_SHIPSCH_TUE | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 312 | 하드코딩 | AddComboColumn | Wed | PERIOD_SHIPSCH_WED | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 313 | 하드코딩 | AddComboColumn | Thu | PERIOD_SHIPSCH_THU | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 314 | 하드코딩 | AddComboColumn | Fri | PERIOD_SHIPSCH_FRI | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 315 | 하드코딩 | AddComboColumn | Sat | PERIOD_SHIPSCH_SAT | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 316 | 하드코딩 | AddComboColumn | Sun | PERIOD_SHIPSCH_SUN | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 317 | 하드코딩 | AddComboColumn | From Port | POL | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 318 | 하드코딩 | AddComboColumn | To Port | POD | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 319 | 하드코딩 | AddTextColumn | Freight Forwarder | FREIGHT_FORWARDER | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 320 | 하드코딩 | AddNumColumn | Safety Stock | SAFETY_STOCK | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 321 | 하드코딩 | AddNumColumn | Plant to CY | PERIOD1_LT | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 322 | 하드코딩 | AddNumColumn | Pol Clearance | POL_CLEARANCE_LT | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 323 | 하드코딩 | AddNumColumn | CY to CY | PERIOD2_LT | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 324 | 하드코딩 | AddNumColumn | Pod Clearance | POD_CLEARANCE_LT | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 325 | 하드코딩 | AddNumColumn | CY to Dest. | PERIOD3_LT | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 326 | 하드코딩 | AddNumColumn | Total | LT_TOTAL | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 327 | 하드코딩 | AddNumColumn | Customer L/T | CUSTOMER_LT | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 328 | 하드코딩 | AddTextColumn | Active | VALID_YN | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 329 | 하드코딩 | AddTextColumn | Update Date | LAST_UPDATE_DATE | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 330 | 하드코딩 | AddTextColumn | Updated By | LAST_UPDATED_BY | if(spreadInfo.SheetName == "Bod") |
| InitSpread2 |  | 398 | 하드코딩 | AddTextColumn | BOD | BOD_ID | if(spreadInfo.SheetName == "Bod Item") |
| InitSpread2 |  | 399 | 하드코딩 | AddComboColumn | Division | DIVISION_ID | if(spreadInfo.SheetName == "Bod Item") |
| InitSpread2 |  | 400 | 하드코딩 | AddTextColumn | Item ID | ITEM_ID | if(spreadInfo.SheetName == "Bod Item") |
| InitSpread2 |  | 401 | 하드코딩 | AddTextColumn | Lot Size | LOT_SIZE | if(spreadInfo.SheetName == "Bod Item") |
| InitSpread2 |  | 402 | 하드코딩 | AddTextColumn | Frozen Period | FROZEN_PERIOD | if(spreadInfo.SheetName == "Bod Item") |
| InitSpread2 |  | 403 | 하드코딩 | AddTextColumn | EFF Start Date | EFF_START_DATE | if(spreadInfo.SheetName == "Bod Item") |
| InitSpread2 |  | 404 | 하드코딩 | AddTextColumn | EFF End Date | EFF_END_DATE | if(spreadInfo.SheetName == "Bod Item") |
| InitSpread2 |  | 405 | 하드코딩 | AddTextColumn | Active | VALID_YN | if(spreadInfo.SheetName == "Bod Item") |
| InitSpread2 |  | 407 | 하드코딩 | AddTextColumn | Update Date | LAST_UPDATE_DATE | if(spreadInfo.SheetName == "Bod Item") |
| InitSpread2 |  | 408 | 하드코딩 | AddTextColumn | Updated By | LAST_UPDATED_BY | if(spreadInfo.SheetName == "Bod Item") |
| InitializeComponent |  | 410 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 411 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 412 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 413 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 462 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 463 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 464 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 465 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Bod | META+코드연결 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 |
| Bod Item | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

# SSP0014 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 864 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 596 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 329 | SSP.SSP0014_GET_SHIPMENT_MODEL_PIC | MATCH | SP SSP0014_GET_SHIPMENT_MODEL_PIC |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 329 | SSP.SSP0014_GET_SHIPMENT_MODEL_PIC | MATCH | SP SSP0014_GET_SHIPMENT_MODEL_PIC |
| button:SaveButton | SaveButton > SaveData | 497 | SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC | MATCH | SP SSP0014_SAVE_SHIPMENT_MODEL_PIC |
| button:SaveButton | SaveButton > SaveData > GetUserIDChk | 562 | SSP.SSP0014_GET_USER_ID_CHECK | MATCH | SP SSP0014_GET_USER_ID_CHECK |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 54 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| SSP.SSP0014_GET_SHIPMENT_MODEL_PIC | MATCH | 1 | SP SSP0014_GET_SHIPMENT_MODEL_PIC | EXEC:SSP0014_GET_SHIPMENT_MODEL_PIC, REF:FN_GET_ITEM_NICKNAME, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE, SELECT:SSP_MST_MODEL_USER, SELECT:TB_FX_USER, REF:STRING_SPLIT, SELECT:SCM_MST_ITEM_SN |  |
| SSP.SSP0014_GET_USER_ID_CHECK | MATCH | 1 | SP SSP0014_GET_USER_ID_CHECK | EXEC:SSP0014_GET_USER_ID_CHECK, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPAUTHEXTENTION, REF:STRING_SPLIT |  |
| SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC | MATCH | 1 | SP SSP0014_SAVE_SHIPMENT_MODEL_PIC | EXEC:SSP0014_SAVE_SHIPMENT_MODEL_PIC, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SSP_MST_MODEL_USER, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitControls | insertRow | CODE, NAME |
| SetChangeControl | Filter | GROUP_ID, USER_ID |
| SetChangeControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSSPInnerTable | SetChangeControl:144, SetChangeControl:149 | DataService.GetSSPInnerTable | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| FP_Log2 | InitControls:170, InitControls:173 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetCheckedListValue | SetChangedControl:197, FindData_Main:310, FindData_Main:311, FindData_Main:312, FindData_Main:313 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:222 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:285 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:110 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:240 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:241 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:242 |
| btnItemId | Click | btnItemId_Click | InitEvent:243 |

## 6. 컨트롤 (23개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | Division, layoutControlItem1, layoutControlItem7, layoutControlItem3, layoutControlItem2, layoutControlItem4, lblItemId |
| UsrCombo | 3 | cboDivision, cboOperationGroup, cboValidYN |
| UsrButton | 2 | usrButton1, btnItemId |
| EmptySpaceItem | 2 | emptySpaceItem2, emptySpaceItem1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckedList | 1 | clbFromSite |
| TextBox | 1 | txtUser |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| UsrMultiLineEditor | 1 | txtItemId |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 5 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 21 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 56 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 112 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0014 | Shipment Model PIC | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Model PIC
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:222

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Shipment Model PIC | 225 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  | if(spdInfo.SheetName == "Shipment Model PIC") |
| InitSpread | Shipment Model PIC | 226 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  | if(spdInfo.SheetName == "Shipment Model PIC") |
| InitSpread | Shipment Model PIC | 227 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  | if(spdInfo.SheetName == "Shipment Model PIC") |
| InitSpread | Shipment Model PIC | 229 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  | if(spdInfo.SheetName == "Shipment Model PIC") |
| InitSpread | Shipment Model PIC | 230 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  | if(spdInfo.SheetName == "Shipment Model PIC") |
| InitSpread | Shipment Model PIC | 231 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  | if(spdInfo.SheetName == "Shipment Model PIC") |
| InitSpread | Shipment Model PIC | 232 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  | if(spdInfo.SheetName == "Shipment Model PIC") |
| InitSpread | Shipment Model PIC | 233 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} |  | if(spdInfo.SheetName == "Shipment Model PIC") |
| InitializeComponent |  | 411 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 412 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 413 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 414 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Model PIC | META+코드연결 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.


### FILE endpoints.csv (4 rows)
```csv
"variant","file","class","member","line","site_kind","kind","candidate","key","status","sp_or_sql","objects","via","detail"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","<field:dtYesOrNo>","54","derived","biz","CommonData.YesOrNo","biz:CommonData.YesOrNo","BIZ_MATCH","","","Data.Common[case Type.YesOrNo:Type.YesOrNo] > Data.CallBizData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","FindData_Main","329","ctor","fox","SSP.SSP0014_GET_SHIPMENT_MODEL_PIC","SSP.SSP0014_GET_SHIPMENT_MODEL_PIC","MATCH","SP SSP0014_GET_SHIPMENT_MODEL_PIC","EXEC:SSP0014_GET_SHIPMENT_MODEL_PIC, REF:FN_GET_ITEM_NICKNAME, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE, SELECT:SSP_MST_MODEL_USER, SELECT:TB_FX_USER, REF:STRING_SPLIT, SELECT:SCM_MST_ITEM_SN","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","SaveData","497","ctor","fox","SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC","SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC","MATCH","SP SSP0014_SAVE_SHIPMENT_MODEL_PIC","EXEC:SSP0014_SAVE_SHIPMENT_MODEL_PIC, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SSP_MST_MODEL_USER, INSERT:SCM_SYS_LOG_BATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","GetUserIDChk","562","ctor","fox","SSP.SSP0014_GET_USER_ID_CHECK","SSP.SSP0014_GET_USER_ID_CHECK","MATCH","SP SSP0014_GET_USER_ID_CHECK","EXEC:SSP0014_GET_USER_ID_CHECK, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPAUTHEXTENTION, REF:STRING_SPLIT","",""
```

### FILE flow.csv (5 rows)
```csv
"variant","file","class","entry_kind","entry","path","member","line","endpoint","status","sp_or_sql","objects"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","button","FindButton","FindButton > FindData_Main","FindData_Main","329","SSP.SSP0014_GET_SHIPMENT_MODEL_PIC","MATCH","SP SSP0014_GET_SHIPMENT_MODEL_PIC","EXEC:SSP0014_GET_SHIPMENT_MODEL_PIC, REF:FN_GET_ITEM_NICKNAME, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE, SELECT:SSP_MST_MODEL_USER, SELECT:TB_FX_USER, REF:STRING_SPLIT, SELECT:SCM_MST_ITEM_SN"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","button","SaveButton","SaveButton > SaveData","SaveData","497","SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC","MATCH","SP SSP0014_SAVE_SHIPMENT_MODEL_PIC","EXEC:SSP0014_SAVE_SHIPMENT_MODEL_PIC, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SSP_MST_MODEL_USER, INSERT:SCM_SYS_LOG_BATCH"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","button","SaveButton","SaveButton > SaveData > FindData_Main","FindData_Main","329","SSP.SSP0014_GET_SHIPMENT_MODEL_PIC","MATCH","SP SSP0014_GET_SHIPMENT_MODEL_PIC","EXEC:SSP0014_GET_SHIPMENT_MODEL_PIC, REF:FN_GET_ITEM_NICKNAME, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE, SELECT:SSP_MST_MODEL_USER, SELECT:TB_FX_USER, REF:STRING_SPLIT, SELECT:SCM_MST_ITEM_SN"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","button","SaveButton","SaveButton > SaveData > GetUserIDChk","GetUserIDChk","562","SSP.SSP0014_GET_USER_ID_CHECK","MATCH","SP SSP0014_GET_USER_ID_CHECK","EXEC:SSP0014_GET_USER_ID_CHECK, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPAUTHEXTENTION, REF:STRING_SPLIT"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","unreached","(진입점 미연결)","<field:dtYesOrNo>","<field:dtYesOrNo>","54","biz:CommonData.YesOrNo","BIZ_MATCH","",""
```

### FILE events.csv (5 rows)
```csv
"variant","file","class","member","line","target","event","handler","op"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC",".ctor","110","this","Load","Form_Load","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitEvent","240","spdMain","TopChange","SpdMain_TopChange","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitEvent","241","spdMain","CellDoubleClick","SpdMain_CellDoubleClick","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitEvent","242","cboDivision","SelectedIndexChanged","CboDivision_SelectedIndexChanged","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitEvent","243","btnItemId","Click","btnItemId_Click","+="
```

### FILE controls.csv (23 rows)
```csv
"variant","file","class","name","type","parent","line"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","usrButton1","GSCM.Windows.Forms.Controls.UsrButton","","33"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","usrConditionPanel1","GSCM.Windows.Forms.Controls.UsrConditionPanel","this","34"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","usrLayoutControl2","GSCM.Windows.Forms.Controls.UsrLayoutControl","usrConditionPanel1","35"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","cboDivision","GSCM.Windows.Forms.Controls.UsrCombo","usrLayoutControl2","36"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","cboOperationGroup","GSCM.Windows.Forms.Controls.UsrCombo","usrLayoutControl2","37"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","clbFromSite","GSCM.Windows.Forms.Controls.UsrCheckedList","usrLayoutControl2","38"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","cboValidYN","GSCM.Windows.Forms.Controls.UsrCombo","usrLayoutControl2","39"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","txtUser","System.Windows.Forms.TextBox","usrLayoutControl2","40"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","layoutControlGroup2","DevExpress.XtraLayout.LayoutControlGroup","","41"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","emptySpaceItem2","DevExpress.XtraLayout.EmptySpaceItem","","42"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","Division","DevExpress.XtraLayout.LayoutControlItem","","43"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","layoutControlItem1","DevExpress.XtraLayout.LayoutControlItem","","44"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","layoutControlItem7","DevExpress.XtraLayout.LayoutControlItem","","45"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","layoutControlItem3","DevExpress.XtraLayout.LayoutControlItem","","46"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","layoutControlItem2","DevExpress.XtraLayout.LayoutControlItem","","47"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","emptySpaceItem1","DevExpress.XtraLayout.EmptySpaceItem","","48"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","spdMain","FarPoint.Win.Spread.FpSpread","this","49"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","spdMain_Sheet1","FarPoint.Win.Spread.SheetView","","50"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","btnItemId","GSCM.Windows.Forms.Controls.UsrButton","usrLayoutControl2","51"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","layoutControlItem4","DevExpress.XtraLayout.LayoutControlItem","","52"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","txtItemId","GSCM.Windows.Forms.Controls.UsrMultiLineEditor","usrLayoutControl2","53"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","lblItemId","DevExpress.XtraLayout.LayoutControlItem","","54"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","imageList1","System.Windows.Forms.ImageList","","55"
```

### FILE props.csv (42 rows)
```csv
"variant","file","class","member","line","target","prop","value"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","104","usrButton1","Size","new System.Drawing.Size(75, 23)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","113","usrConditionPanel1","Dock","System.Windows.Forms.DockStyle.Top"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","116","usrConditionPanel1","Size","new System.Drawing.Size(1192, 67)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","118","usrConditionPanel1","UsrPanelType","GSCM.Windows.Forms.Controls.UsrConditionPanel.PanelType.HidePanel"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","130","usrLayoutControl2","Dock","System.Windows.Forms.DockStyle.Fill"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","135","usrLayoutControl2","Size","new System.Drawing.Size(1192, 67)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","137","usrLayoutControl2","Text","""usrLayoutControl2"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","171","cboDivision","Size","new System.Drawing.Size(189, 20)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","207","cboOperationGroup","Size","new System.Drawing.Size(142, 20)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","243","clbFromSite","Size","new System.Drawing.Size(240, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","280","cboValidYN","Size","new System.Drawing.Size(105, 20)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","288","txtUser","Size","new System.Drawing.Size(150, 24)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","307","layoutControlGroup2","Size","new System.Drawing.Size(1192, 73)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","315","emptySpaceItem2","Size","new System.Drawing.Size(248, 25)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","320","Division","Control","this.cboDivision"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","324","Division","Size","new System.Drawing.Size(244, 25)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","325","Division","Text","""Division*"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","332","layoutControlItem1","Control","this.cboOperationGroup"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","336","layoutControlItem1","Size","new System.Drawing.Size(240, 25)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","337","layoutControlItem1","Text","""Operation Group"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","342","layoutControlItem7","Control","this.clbFromSite"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","346","layoutControlItem7","Size","new System.Drawing.Size(301, 25)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","347","layoutControlItem7","Text","""From Site"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","354","layoutControlItem3","Control","this.cboValidYN"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","358","layoutControlItem3","Size","new System.Drawing.Size(139, 25)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","359","layoutControlItem3","Text","""Valid"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","366","layoutControlItem2","Control","this.txtUser"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","371","layoutControlItem2","Size","new System.Drawing.Size(240, 28)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","373","layoutControlItem2","Text","""User ID(Name)"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","383","emptySpaceItem1","Size","new System.Drawing.Size(688, 28)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","389","spdMain","Dock","System.Windows.Forms.DockStyle.Fill"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","394","spdMain","Size","new System.Drawing.Size(1192, 582)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","466","btnItemId","Size","new System.Drawing.Size(39, 24)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","474","layoutControlItem4","Control","this.btnItemId"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","480","layoutControlItem4","Size","new System.Drawing.Size(43, 28)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","482","layoutControlItem4","Text","""layoutControlItem2"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","516","txtItemId","Size","new System.Drawing.Size(160, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","522","lblItemId","Control","this.txtItemId"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","526","lblItemId","Size","new System.Drawing.Size(201, 28)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","527","lblItemId","Text","""Model"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","546","this","Text","""SSP0014_ShipmentModelPIC"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","btnItemId_Click","857","txtItemId","Text","sItemId"
```

### FILE grid_effective.csv (21 rows)
```csv
"sheet","sheet_rule","column","label","source","40","81","81_HD","81_HG","81_HM","81_ST","81_UC","82","EE","EE_HD","EE_HG","EE_HM","EE_ST","EE_UC"
"Shipment Model PIC","META+코드연결","CREATED_BY","Created By","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","CREATION_DATE","Creation Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","DIVISION_ID","Division","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","FROM_SITE","From Site","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","ITEM_ID","Model","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","LAST_UPDATE_DATE","Last Update Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","LAST_UPDATED_BY","Last Updated By","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","MAIL_USER1","Mail User1","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","MAIL_USER2","Mail User2","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","MAIL_USER3","Mail User3","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","MAIL_USER4","Mail User4","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","MAIL_USER5","Mail User5","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","NICK_NAME","Nick Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","OPERATION_GROUP","Operation Group","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","PART_LEADER","Part Leader","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","PART_LEADER_NAME","Part Leader Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","TEAM_LEADER","Team Leader","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","TEAM_LEADER_NAME","Team Leader Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","USER_ID","User ID*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","USER_NAME","User Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Model PIC","META+코드연결","VALID_YN","Valid*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
```

### FILE grid_code.csv (18 rows)
```csv
"variant","file","class","member","line","sheet_hint","kind","api","source","header","field","columns","args","arg_names","conditions","raw"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","CreateSpread","208","Shipment Model PIC","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ Shipment Model PIC ¦ Shipment Model PIC ¦ 1 ¦ 1 ¦ 30","","","spdMain ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 1 ¦ 1 ¦ 30"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","CreateSpread","209","0","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ 0","","","spdMain.Name ¦ 0"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","CreateSpread","211","0","SHEET","ChangeSheet","EXPR","","","","","","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitSpread","220","Shipment Model PIC","SHEET","InitSheet","HARDCODED","","","","Shipment Model PIC","","if(spdInfo.SheetName == ""Shipment Model PIC"")","SpdSheet.shtMain"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitSpread","222","Shipment Model PIC","META_BUILD","SetSheetHeaderColumn","EXPR","","","","{p:spdInfo} ¦ 1","siObj,iColumnHeaderRowCount","if(spdInfo.SheetName == ""Shipment Model PIC"")","spdInfo ¦ 1"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitSpread","225","Shipment Model PIC","OVERRIDE","set:CellType","EXPR","","","","{?cellTypeImage}","CellType","if(spdInfo.SheetName == ""Shipment Model PIC"")","cellTypeImage"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitSpread","226","Shipment Model PIC","OVERRIDE","set:CellType","EXPR","","","","{?cellTypeImage}","CellType","if(spdInfo.SheetName == ""Shipment Model PIC"")","cellTypeImage"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitSpread","227","Shipment Model PIC","OVERRIDE","set:CellType","EXPR","","","","{?cellTypeImage}","CellType","if(spdInfo.SheetName == ""Shipment Model PIC"")","cellTypeImage"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitSpread","229","Shipment Model PIC","OVERRIDE","set:CellType","EXPR","","","","{?cellTypeImage}","CellType","if(spdInfo.SheetName == ""Shipment Model PIC"")","cellTypeImage"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitSpread","230","Shipment Model PIC","OVERRIDE","set:CellType","EXPR","","","","{?cellTypeImage}","CellType","if(spdInfo.SheetName == ""Shipment Model PIC"")","cellTypeImage"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitSpread","231","Shipment Model PIC","OVERRIDE","set:CellType","EXPR","","","","{?cellTypeImage}","CellType","if(spdInfo.SheetName == ""Shipment Model PIC"")","cellTypeImage"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitSpread","232","Shipment Model PIC","OVERRIDE","set:CellType","EXPR","","","","{?cellTypeImage}","CellType","if(spdInfo.SheetName == ""Shipment Model PIC"")","cellTypeImage"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitSpread","233","Shipment Model PIC","OVERRIDE","set:CellType","EXPR","","","","{?cellTypeImage}","CellType","if(spdInfo.SheetName == ""Shipment Model PIC"")","cellTypeImage"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","EditButton","271","","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ {?fps.ActiveSheetIndex}","","if(fps != null) ⟫ if(fps.Name == ""spdMain"")","spdMain.Name ¦ fps.ActiveSheetIndex"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","411","","OVERRIDE","set:HorizontalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellHorizontalAlignment.General}","HorizontalAlignment","","FarPoint.Win.Spread.CellHorizontalAlignment.General"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","412","","OVERRIDE","set:NoteIndicatorColor","EXPR","","","","{?System.Drawing.Color.Red}","NoteIndicatorColor","","System.Drawing.Color.Red"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","413","","OVERRIDE","set:Parent","HARDCODED","","","","ColumnHeaderDefaultEnhanced","Parent","","""ColumnHeaderDefaultEnhanced"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs","SSP0014_ShipmentModelPIC","InitializeComponent","414","","OVERRIDE","set:VerticalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellVerticalAlignment.General}","VerticalAlignment","","FarPoint.Win.Spread.CellVerticalAlignment.General"
```

### FILE meta_reads.csv (5 rows)
```csv
"variant","file","class","member","line","receiver","column","via"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","SetChangeControl","137","Filter","GROUP_ID","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","SetChangeControl","137","UserInfoContext.Current","NowGroupID","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","SetChangeControl","138","Filter","USER_ID","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitControls","184","insertRow","CODE","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs","SSP0014_ShipmentModelPIC","InitControls","185","insertRow","NAME","[]"
```

### FILE commented_calls.csv (0 rows)
```csv
"variant","file","line","kind","candidate","key","status"
```

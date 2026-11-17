# SSP0017 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 547 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 641 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > SetChangedControl | 365 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 405 | SSP.SSP0017_GET_INVENTORY_RAW | MATCH | SP SSP0017_GET_INVENTORY_RAW |
| event:this.Load | Form_Load > InitControls | 179 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 365 | biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtInventoryStatus> | 49 | biz:CommonData.CommonDataList [code=OWMS_STOCK_STATUS] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetDivision | 478 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetDayRange | 514 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=OWMS_STOCK_STATUS] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PlanDateShip] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SSP_ANL_SHIP_PLAN_P, UP_FX_GetCommonDataList:SELECT:SSP_PLAN_VERSION_V, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SSP.SSP0017_GET_INVENTORY_RAW | MATCH | 1 | SP SSP0017_GET_INVENTORY_RAW | EXEC:SSP0017_GET_INVENTORY_RAW, SELECT:SCM_MST_ITEM_SN, REF:FN_CHAR_TO_DATE, SELECT:SSP_ANL_INVENTORY_RAW, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_MST_SLOC, SELECT:SCM_MST_SITE, REF:UF_FX_STRING_SPLIT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpread:202 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetCheckedListValue | SetChangedControl:350, FindData_Main:386, FindData_Main:387, FindData_Main:389, FindData_Main:390 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:122 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:243 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:244 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:245 |
| clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitEvent:247 |

## 6. 컨트롤 (24개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | layoutControlItem7, lblItemId, layoutControlItem2, PlanDate, layoutControlItem10, lcDivision, lblInventoryType |
| UsrButton | 3 | usrButton1, btnMeasure, btnItemId |
| UsrCombo | 2 | cboPlanDate, cboInventoryType |
| UsrCheckedList | 2 | clbPlantSite, clbDivision |
| EmptySpaceItem | 2 | emptySpaceItem3, emptySpaceItem1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrMultiLineEditor | 1 | txtItemId |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| ImageList | 1 | imageList1 |
| Panel | 1 | panel1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 2 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 62 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 9 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 14 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 2 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 2 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 8 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (3건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 513 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |
| 532 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 531 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0017 | Inventory Raw(IT & Mobile) | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 |
| SCM_MST_SHEET_COLUMNS | SSP0017 | Inventory Raw(Mobility & IT) | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Inventory Raw(Mobility & IT)
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:202

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 555 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 556 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 557 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 558 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Inventory Raw(IT & Mobile) | 메타 정의만, 코드 미참조(미사용 가능) | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 |
| Inventory Raw(Mobility & IT) | META+코드연결 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.


### FILE endpoints.csv (6 rows)
```csv
"variant","file","class","member","line","site_kind","kind","candidate","key","status","sp_or_sql","objects","via","detail"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","<field:dtInventoryStatus>","49","derived","biz","CommonData.CommonDataList [code=OWMS_STOCK_STATUS]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.OWMS_STOCK_STATUS:Type.OWMS_STOCK_STATUS] > Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","InitControls","179","derived","biz","CommonData.CommonDataList [code=LookupCommon]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.LookupCommon:Type.LookupCommon] > Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","SetChangedControl","365","derived","biz","CommonData.CommonDataList [code=PlanDateShip]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.PlanDateShip:Type.PlanDateShip] > Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","FindData_Main","405","ctor","fox","SSP.SSP0017_GET_INVENTORY_RAW","SSP.SSP0017_GET_INVENTORY_RAW","MATCH","SP SSP0017_GET_INVENTORY_RAW","EXEC:SSP0017_GET_INVENTORY_RAW, SELECT:SCM_MST_ITEM_SN, REF:FN_CHAR_TO_DATE, SELECT:SSP_ANL_INVENTORY_RAW, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_MST_SLOC, SELECT:SCM_MST_SITE, REF:UF_FX_STRING_SPLIT","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","GetDivision","478","ctor","fox","SCM.SCM0001_GET_DIVISION","SCM.SCM0001_GET_DIVISION","MATCH","SP SCM0001_GET_DIVISION","EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","GetDayRange","514","ctor","fox","SCP.SCM0001_GET_SCP_DAY_PERIOD","SCP.SCM0001_GET_SCP_DAY_PERIOD","MATCH","SP SCM0001_GET_SCP_DAY_PERIOD","EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE","",""
```

### FILE flow.csv (7 rows)
```csv
"variant","file","class","entry_kind","entry","path","member","line","endpoint","status","sp_or_sql","objects"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","event","this.Load","Form_Load > InitControls","InitControls","179","biz:CommonData.CommonDataList [code=LookupCommon]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","event","this.Load","Form_Load > InitControls > SetChangedControl","SetChangedControl","365","biz:CommonData.CommonDataList [code=PlanDateShip]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","event","clbDivision.SelectedIndexChanged","clbDivision_SelectedIndexChanged > SetChangedControl","SetChangedControl","365","biz:CommonData.CommonDataList [code=PlanDateShip]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","button","FindButton","FindButton > FindData_Main","FindData_Main","405","SSP.SSP0017_GET_INVENTORY_RAW","MATCH","SP SSP0017_GET_INVENTORY_RAW","EXEC:SSP0017_GET_INVENTORY_RAW, SELECT:SCM_MST_ITEM_SN, REF:FN_CHAR_TO_DATE, SELECT:SSP_ANL_INVENTORY_RAW, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_MST_SLOC, SELECT:SCM_MST_SITE, REF:UF_FX_STRING_SPLIT"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","unreached","(진입점 미연결)","GetDivision","GetDivision","478","SCM.SCM0001_GET_DIVISION","MATCH","SP SCM0001_GET_DIVISION","EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","unreached","(진입점 미연결)","GetDayRange","GetDayRange","514","SCP.SCM0001_GET_SCP_DAY_PERIOD","MATCH","SP SCM0001_GET_SCP_DAY_PERIOD","EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","unreached","(진입점 미연결)","<field:dtInventoryStatus>","<field:dtInventoryStatus>","49","biz:CommonData.CommonDataList [code=OWMS_STOCK_STATUS]","BIZ_MATCH","",""
```

### FILE events.csv (5 rows)
```csv
"variant","file","class","member","line","target","event","handler","op"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw",".ctor","122","this","Load","Form_Load","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","InitEvent","243","spdMain","TopChange","SpdMain_TopChange","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","InitEvent","244","this.btnItemId","Click","btnItemId_Click","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","InitEvent","245","this.btnMeasure","Click","btnMeasure_Click","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","InitEvent","247","clbDivision","SelectedIndexChanged","clbDivision_SelectedIndexChanged","+="
```

### FILE controls.csv (24 rows)
```csv
"variant","file","class","name","type","parent","line"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","usrButton1","GSCM.Windows.Forms.Controls.UsrButton","","32"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","usrConditionPanel1","GSCM.Windows.Forms.Controls.UsrConditionPanel","this","33"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","usrLayoutControl2","GSCM.Windows.Forms.Controls.UsrLayoutControl","usrConditionPanel1","34"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","cboPlanDate","GSCM.Windows.Forms.Controls.UsrCombo","usrLayoutControl2","35"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","btnMeasure","GSCM.Windows.Forms.Controls.UsrButton","usrLayoutControl2","36"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","btnItemId","GSCM.Windows.Forms.Controls.UsrButton","usrLayoutControl2","37"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","clbPlantSite","GSCM.Windows.Forms.Controls.UsrCheckedList","usrLayoutControl2","38"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","txtItemId","GSCM.Windows.Forms.Controls.UsrMultiLineEditor","usrLayoutControl2","39"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","cboInventoryType","GSCM.Windows.Forms.Controls.UsrCombo","usrLayoutControl2","40"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","clbDivision","GSCM.Windows.Forms.Controls.UsrCheckedList","usrLayoutControl2","41"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","layoutControlGroup2","DevExpress.XtraLayout.LayoutControlGroup","","42"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","emptySpaceItem3","DevExpress.XtraLayout.EmptySpaceItem","","43"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","layoutControlItem7","DevExpress.XtraLayout.LayoutControlItem","","44"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","lblItemId","DevExpress.XtraLayout.LayoutControlItem","","45"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","layoutControlItem2","DevExpress.XtraLayout.LayoutControlItem","","46"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","PlanDate","DevExpress.XtraLayout.LayoutControlItem","","47"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","layoutControlItem10","DevExpress.XtraLayout.LayoutControlItem","","48"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","emptySpaceItem1","DevExpress.XtraLayout.EmptySpaceItem","","49"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","lcDivision","DevExpress.XtraLayout.LayoutControlItem","","50"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","lblInventoryType","DevExpress.XtraLayout.LayoutControlItem","","51"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","imageList1","System.Windows.Forms.ImageList","","52"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","panel1","System.Windows.Forms.Panel","this","53"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","spdMain","FarPoint.Win.Spread.FpSpread","panel1","54"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","spdMain_Sheet1","FarPoint.Win.Spread.SheetView","","55"
```

### FILE props.csv (44 rows)
```csv
"variant","file","class","member","line","target","prop","value"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","105","usrButton1","Size","new System.Drawing.Size(75, 23)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","114","usrConditionPanel1","Dock","System.Windows.Forms.DockStyle.Top"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","117","usrConditionPanel1","Size","new System.Drawing.Size(1192, 79)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","119","usrConditionPanel1","UsrPanelType","GSCM.Windows.Forms.Controls.UsrConditionPanel.PanelType.HidePanel"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","131","usrLayoutControl2","Dock","System.Windows.Forms.DockStyle.Top"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","136","usrLayoutControl2","Size","new System.Drawing.Size(1192, 73)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","138","usrLayoutControl2","Text","""usrLayoutControl2"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","172","cboPlanDate","Size","new System.Drawing.Size(165, 20)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","205","btnMeasure","Size","new System.Drawing.Size(39, 24)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","241","btnItemId","Size","new System.Drawing.Size(39, 24)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","279","clbPlantSite","Size","new System.Drawing.Size(100, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","316","txtItemId","Size","new System.Drawing.Size(100, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","352","cboInventoryType","Size","new System.Drawing.Size(145, 20)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","388","clbDivision","Size","new System.Drawing.Size(184, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","411","layoutControlGroup2","Size","new System.Drawing.Size(1192, 73)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","419","emptySpaceItem3","Size","new System.Drawing.Size(287, 28)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","424","layoutControlItem7","Control","this.clbPlantSite"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","428","layoutControlItem7","Size","new System.Drawing.Size(161, 28)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","429","layoutControlItem7","Text","""Plant Site"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","436","lblItemId","Control","this.txtItemId"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","441","lblItemId","Size","new System.Drawing.Size(154, 28)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","442","lblItemId","Text","""Model"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","449","layoutControlItem2","Control","this.btnItemId"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","454","layoutControlItem2","Size","new System.Drawing.Size(43, 28)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","461","PlanDate","Control","this.cboPlanDate"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","464","PlanDate","Size","new System.Drawing.Size(232, 25)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","465","PlanDate","Text","""Plan-date*"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","472","layoutControlItem10","Control","this.btnMeasure"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","477","layoutControlItem10","Size","new System.Drawing.Size(43, 28)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","487","emptySpaceItem1","Size","new System.Drawing.Size(940, 25)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","492","lcDivision","Control","this.clbDivision"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","496","lcDivision","Size","new System.Drawing.Size(232, 28)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","497","lcDivision","Text","""Division"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","504","lblInventoryType","Control","this.cboInventoryType"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","509","lblInventoryType","Size","new System.Drawing.Size(252, 28)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","510","lblInventoryType","Text","""Inventory Type"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","524","panel1","Dock","System.Windows.Forms.DockStyle.Fill"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","527","panel1","Size","new System.Drawing.Size(1192, 570)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","533","spdMain","Dock","System.Windows.Forms.DockStyle.Fill"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","538","spdMain","Size","new System.Drawing.Size(1192, 570)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","589","this","Text","""Inventory Raw(Small)"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","InitControls","176","clbDivision","Enabled","false"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","InitSpreadFooterSum","217","siMain.ActiveSheet.ColumnFooter","Visible","true"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","btnItemId_Click","301","txtItemId","Text","sItemId"
```

### FILE grid_effective.csv (62 rows)
```csv
"sheet","sheet_rule","column","label","source","40","81","81_HD","81_HG","81_HM","81_ST","81_UC","82","EE","EE_HD","EE_HG","EE_HM","EE_ST","EE_UC"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","AVAILABLE_QTY","Available Qty","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","BUILDING","Building","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","CAPACITY","Capacity","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","CURRENT_OP_START_DATE","Current OP Start Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","CUSTOMER","Customer","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","DIVISION_ID","Div","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","EXP_FORMATION_END_DATE","Exp. Formation End Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","EXPIRATION_QTY","Expiration Qty","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","HOLD_QTY","Hold Qty","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","HOLD_YN","Hold YN","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","INVENTORY_STATUS","Inventory Status","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","INVENTORY_TYPE","Inventory Type","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","LINE","Line","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","LONG_QTY","Long-Term Qty","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","LOT","Lot","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","LOT_ID","Lot ID","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","MODEL","Model","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","NICK_NAME","Nick Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","OPERATION","Operation","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","OPERATION_NAME","Operation Name","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","PALLET_ID","Pallet ID","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","PLANT_SITE","Plant Site","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","PRODUCTION_DATE","Production Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","REMAIN_LEAD_TIME","Remain Lead Time(Day)","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","ROUTE","Route","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","ROUTE_NAME","Route Name","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","ROUTE_TYPE","Route Type","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","SOC","SOC","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","SPECIAL_YN","Special YN","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","STOCK_QTY","Stock Qty","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(IT & Mobile)","메타 정의만, 코드 미참조(미사용 가능)","VALTAGE","Valtage","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","AVAILABLE_QTY","Available Qty","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","BUILDING","Building","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","CAPACITY","Capacity","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","CURRENT_OP_START_DATE","Current OP Start Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","CUSTOMER","Customer","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","DIVISION_ID","Div","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","EXP_FORMATION_END_DATE","Exp. Formation End Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","EXPIRATION_QTY","Expiration Qty","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","HOLD_QTY","Hold Qty","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","HOLD_YN","Hold YN","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","INVENTORY_STATUS","Inventory Status","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","INVENTORY_TYPE","Inventory Type","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","LINE","Line","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","LONG_QTY","Long-Term Qty","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Inventory Raw(Mobility & IT)","META+코드연결","LOT","Lot","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","LOT_ID","Lot ID","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","MODEL","Model","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","NICK_NAME","Nick Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","OPERATION","Operation","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","OPERATION_NAME","Operation Name","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Inventory Raw(Mobility & IT)","META+코드연결","PALLET_ID","Pallet ID","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","PLANT_SITE","Plant Site","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","PRODUCTION_DATE","Production Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","REMAIN_LEAD_TIME","Remain Lead Time(Day)","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","ROUTE","Route","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","ROUTE_NAME","Route Name","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Inventory Raw(Mobility & IT)","META+코드연결","ROUTE_TYPE","Route Type","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Inventory Raw(Mobility & IT)","META+코드연결","SOC","SOC","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","SPECIAL_YN","Special YN","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","STOCK_QTY","Stock Qty","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Inventory Raw(Mobility & IT)","META+코드연결","VALTAGE","Valtage","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
```

### FILE grid_code.csv (9 rows)
```csv
"variant","file","class","member","line","sheet_hint","kind","api","source","header","field","columns","args","arg_names","conditions","raw"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","CreateSpread","188","Inventory Raw(Mobility & IT)","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ Inventory Raw(Mobility & IT) ¦ Inventory Raw(Mobility & IT) ¦ 1 ¦ 1 ¦ 30","","","spdMain ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 1 ¦ 1 ¦ 30"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","CreateSpread","189","0","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ 0","","","spdMain.Name ¦ 0"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","CreateSpread","191","0","SHEET","ChangeSheet","EXPR","","","","","","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","InitSpread","200","Inventory Raw(Mobility & IT)","SHEET","InitSheet","HARDCODED","","","","Inventory Raw(Mobility & IT)","","if(spdInfo.SheetName == ""Inventory Raw(Mobility & IT)"")","SpdSheet.shtMain"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","InitSpread","202","Inventory Raw(Mobility & IT)","META_BUILD","SetSheetHeaderColumn","EXPR","","","","{p:spdInfo} ¦ 1","siObj,iColumnHeaderRowCount","if(spdInfo.SheetName == ""Inventory Raw(Mobility & IT)"")","spdInfo ¦ 1"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","555","","OVERRIDE","set:HorizontalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellHorizontalAlignment.General}","HorizontalAlignment","","FarPoint.Win.Spread.CellHorizontalAlignment.General"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","556","","OVERRIDE","set:NoteIndicatorColor","EXPR","","","","{?System.Drawing.Color.Red}","NoteIndicatorColor","","System.Drawing.Color.Red"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","557","","OVERRIDE","set:Parent","HARDCODED","","","","ColumnHeaderDefaultEnhanced","Parent","","""ColumnHeaderDefaultEnhanced"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.Designer.cs","SSP0017_InventoryRaw","InitializeComponent","558","","OVERRIDE","set:VerticalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellVerticalAlignment.General}","VerticalAlignment","","FarPoint.Win.Spread.CellVerticalAlignment.General"
```

### FILE meta_reads.csv (1 rows)
```csv
"variant","file","class","member","line","receiver","column","via"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","SSP0017_InventoryRaw","<field:dtMyDivision>","46","UserInfoContext.Current","NowGroupID","[]"
```

### FILE commented_calls.csv (3 rows)
```csv
"variant","file","line","kind","candidate","key","status"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","513","fox","SCP.GET_DATE_RANGE_1MONTH","SCP.GET_DATE_RANGE_1MONTH","commented:MATCH"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","532","fox","SCP.SCM0001_GET_SCP_PERIOD","SCP.SCM0001_GET_SCP_PERIOD","commented:MATCH"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0017_InventoryRaw.cs","531","fox","SCP.GET_DATE_RANGE_1MONTH","SCP.GET_DATE_RANGE_1MONTH","commented:MATCH"
```

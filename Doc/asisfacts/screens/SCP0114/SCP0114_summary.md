# SCP0114 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0114_CAPA_LineMaster\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0114_CAPA_LineMaster\SCP0114_CAPA_LineMaster.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0114_CAPA_LineMaster\SCP0114_CAPA_LineMaster.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0114_CAPA_LineMaster\SCP0114_CAPA_LineMaster.csproj | 1934 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0114_CAPA_LineMaster\SCP0114_CAPA_LineMaster.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0114_CAPA_LineMaster\SCP0114_CAPA_LineMaster.csproj | 689 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0114_CAPA_LineMaster\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0114_CAPA_LineMaster\SCP0114_CAPA_LineMaster.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0114_CAPA_LineMaster\SCP0114_CAPA_LineMaster.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0114_CAPA_LineMaster\SCP0114_CAPA_LineMaster.csproj | 1562 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0114_CAPA_LineMaster\SCP0114_CAPA_LineMaster.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0114_CAPA_LineMaster\SCP0114_CAPA_LineMaster.csproj | 608 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 442 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| button:FindButton | FindButton > FindData | 729 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| button:SaveButton | SaveButton > SaveData > FindData | 442 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| button:SaveButton | SaveButton > SaveData > FindData | 729 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| button:SaveButton | SaveButton > SaveData | 908 | SCP.SCP0114_SAVE_CAPA_LINE_MASTER | MATCH | SP SCP0114_SAVE_CAPA_LINE_MASTER |
| event:this.cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > FindData | 442 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| event:this.cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > FindData | 729 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| event:this.rgrpSearchLevel.SelectedIndexChanged | rgrpSearchLevel_SelectedIndexChanged > FindData | 442 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| event:this.rgrpSearchLevel.SelectedIndexChanged | rgrpSearchLevel_SelectedIndexChanged > FindData | 729 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| event:this.spdLevel1.CellDoubleClick | SpdLevel1_CellDoubleClick > FindData | 442 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| event:this.spdLevel1.CellDoubleClick | SpdLevel1_CellDoubleClick > FindData | 729 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| event:this.spdLevel2.CellDoubleClick | SpdLevel2_CellDoubleClick > FindData | 442 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| event:this.spdLevel2.CellDoubleClick | SpdLevel2_CellDoubleClick > FindData | 729 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| event:this.spdLevel3.CellDoubleClick | SpdLevel3_CellDoubleClick > FindData | 442 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| event:this.spdLevel3.CellDoubleClick | SpdLevel3_CellDoubleClick > FindData | 729 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| event:this.spdLevel4.CellDoubleClick | SpdLevel4_CellDoubleClick > FindData | 442 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| event:this.spdLevel4.CellDoubleClick | SpdLevel4_CellDoubleClick > FindData | 729 | SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | SP SCP0114_GET_CAPA_LINE_MASTER |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 88 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 89 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCP.SCP0114_GET_CAPA_LINE_MASTER | MATCH | 2 | SP SCP0114_GET_CAPA_LINE_MASTER | EXEC:SCP0114_GET_CAPA_LINE_MASTER, SELECT:SCP_MST_CAPA_LINE, SELECT:SCP_MST_CAPA_ELTR_LINE |  |
| SCP.SCP0114_SAVE_CAPA_LINE_MASTER | MATCH | 1 | SP SCP0114_SAVE_CAPA_LINE_MASTER | EXEC:SCP0114_SAVE_CAPA_LINE_MASTER, REF:FN_MULTY_TIME, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:SP_EXECUTESQL, INSERT:SCP_MST_CAPA_LINE, INSERT:SCP_MST_CAPA_ELTR_LINE, UPDATE:SCP_MST_CAPA_LINE, UPDATE:SCP_MST_CAPA_ELTR_LINE, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT:SCM_SYS_LOG_BATCH, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| _defaultDataModel_Changed | dtFilterSpread.Rows[0] | NAME |
| _defaultDataModel_Changed | rows[0] | CODE |
| InsertRow | row | SORT_ORDER |
| SaveData | dr | A, spreadSeq, RegtUserID |
| SaveData | row | A |
| SetSpreadNameToCode | r | CODE, NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | FindButton:348, cboDivision_SelectedIndexChanged:1839, rgrpSearchLevel_SelectedIndexChanged:1849, FindButton:331, cboDivision_SelectedIndexChanged:1507 | CString.GetCheckedListValue | CODE |
| SaveData | SaveButton:671, SaveButton:388 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetChanges | SaveData:581 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:147 |
| this.spdLevel1 | CellDoubleClick | SpdLevel1_CellDoubleClick | .ctor:149 |
| this.spdLevel2 | CellDoubleClick | SpdLevel2_CellDoubleClick | .ctor:150 |
| this.spdLevel3 | CellDoubleClick | SpdLevel3_CellDoubleClick | .ctor:151 |
| this.spdLevel4 | CellDoubleClick | SpdLevel4_CellDoubleClick | .ctor:152 |
| this.spdLevel5 | CellDoubleClick | SpdLevel5_CellDoubleClick | .ctor:153 |
| this.spdLevel1 | Change | spdAssign_Change | .ctor:155 |
| this.spdLevel2 | Change | spdAssign_Change | .ctor:156 |
| this.spdLevel3 | Change | spdAssign_Change | .ctor:157 |
| this.spdLevel4 | Change | spdAssign_Change | .ctor:158 |
| this.spdLevel5 | Change | spdAssign_Change | .ctor:159 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | .ctor:161 |
| this.rgrpSearchLevel | SelectedIndexChanged | rgrpSearchLevel_SelectedIndexChanged | .ctor:162 |
| this.spdLevel1 | ClipboardPasted | spdLevel1_ClipboardPasted | .ctor:163 |
| this.spdLevel2 | ClipboardPasted | spdLevel2_ClipboardPasted | .ctor:164 |
| this.spdLevel3 | ClipboardPasted | spdLevel3_ClipboardPasted | .ctor:165 |
| this.spdLevel4 | ClipboardPasted | spdLevel4_ClipboardPasted | .ctor:166 |
| this.spdLevel5 | ClipboardPasted | spdLevel5_ClipboardPasted | .ctor:167 |
| this | Load | Form_Load | .ctor:138 |
| this.spdLevel1 | CellClick | spdLevel1_CellClick | .ctor:139 |
| this.spdLevel2 | CellClick | spdLevel2_CellClick | .ctor:140 |
| this.spdLevel3 | CellClick | spdLevel3_CellClick | .ctor:141 |
| this.spdLevel4 | CellClick | spdLevel4_CellClick | .ctor:142 |
| this.spdLevel5 | CellClick | spdLevel5_CellClick | .ctor:143 |
| this.spdLevel1 | ComboSelChange | spdLevel1_ComboSelChange | .ctor:144 |
| this.spdLevel2 | ComboSelChange | spdLevel2_ComboSelChange | .ctor:145 |
| this.spdLevel1 | CellDoubleClick | SpdLevel1_CellDoubleClick | .ctor:147 |
| this.spdLevel2 | CellDoubleClick | SpdLevel2_CellDoubleClick | .ctor:148 |
| this.spdLevel3 | CellDoubleClick | SpdLevel3_CellDoubleClick | .ctor:149 |
| this.spdLevel4 | CellDoubleClick | SpdLevel4_CellDoubleClick | .ctor:150 |
| this.spdLevel5 | CellDoubleClick | SpdLevel5_CellDoubleClick | .ctor:151 |
| this.spdLevel1 | ComboSelChange | spdAssign_ComboSelChange | .ctor:153 |
| this.spdLevel2 | ComboSelChange | spdAssign_ComboSelChange | .ctor:154 |
| this.spdLevel3 | ComboSelChange | spdAssign_ComboSelChange | .ctor:155 |
| this.spdLevel4 | ComboSelChange | spdAssign_ComboSelChange | .ctor:156 |
| this.spdLevel5 | ComboSelChange | spdAssign_ComboSelChange | .ctor:157 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | .ctor:159 |
| _defaultDataModel | Changed | _defaultDataModel_Changed | spdAssign_ComboSelChange:1305 |

## 6. 컨트롤 (50개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| FpSpread | 10 | spdLevel3, spdLevel2, spdLevel1, spdLevel5, spdLevel4, spdLevel3, spdLevel4, spdLevel1, spdLevel2, spdLevel5 |
| SheetView | 10 | spdLevel3_Sheet1, spdLevel2_Sheet1, spdLevel1_Sheet1, spdLevel5_Sheet1, spdLevel4_Sheet1, spdLevel3_Sheet1, spdLevel4_Sheet1, spdLevel1_Sheet1, spdLevel2_Sheet1, spdLevel5_Sheet1 |
| EmptySpaceItem | 8 | emptySpaceItem3, emptySpaceItem9, emptySpaceItem8, emptySpaceItem1, emptySpaceItem3, emptySpaceItem9, emptySpaceItem8, emptySpaceItem1 |
| Panel | 6 | panel6, panel5, panel4, panel3, panel2, panel1 |
| SplitContainer | 4 | splitContainer1, splitContainer1, splitContainer3, splitContainer2 |
| UsrConditionPanel | 2 | usrPanel, usrPanel |
| UsrLayoutControl | 2 | usrLayoutControl2, usrLayoutControl2 |
| UsrCombo | 2 | cboDivision, cboDivision |
| LayoutControlGroup | 2 | layoutControlGroup2, layoutControlGroup2 |
| LayoutControlItem | 2 | Division, Division |
| UsrLabel | 1 | usrLabel1 |
| RadioGroup | 1 | rgrpSearchLevel |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 11 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.TB_FX_Favorite | 3 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1117 |  | commented:EMPTY |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Level1, Level2, Level3, Level4, Level5

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 244 | 하드코딩 | AddTextColumn | Div* | DIVISION_ID | if(level == 1) |
| InitSpread |  | 245 | 하드코딩 | AddTextColumn | Site* | SITE_ID | if(level == 1) |
| InitSpread |  | 246 | 하드코딩 | AddTextColumn | Site Name | SITE_NAME | if(level == 1) |
| InitSpread |  | 247 | 하드코딩 | AddTextColumn | Dummy | DUMMY_YN | if(level == 1) |
| InitSpread |  | 248 | 하드코딩 | AddTextColumn | SortOrder | SORT_ORDER | if(level == 1) |
| InitSpread |  | 261 | 하드코딩 | AddTextColumn | Div* | DIVISION_ID | if(level == 2) |
| InitSpread |  | 262 | 하드코딩 | AddTextColumn | Site* | SITE_ID | if(level == 2) |
| InitSpread |  | 263 | 하드코딩 | AddTextColumn | Site Name | SITE_NAME | if(level == 2) |
| InitSpread |  | 264 | 하드코딩 | AddTextColumn | Company* | COMPANY_ID | if(level == 2) |
| InitSpread |  | 265 | 하드코딩 | AddTextColumn | Company Name | COMPANY_NAME | if(level == 2) |
| InitSpread |  | 266 | 하드코딩 | AddTextColumn | Dummy | DUMMY_YN | if(level == 2) |
| InitSpread |  | 267 | 하드코딩 | AddTextColumn | SortOrder | SORT_ORDER | if(level == 2) |
| InitSpread |  | 279 | 하드코딩 | AddTextColumn | Div* | DIVISION_ID | if(level == 3) |
| InitSpread |  | 280 | 하드코딩 | AddTextColumn | Site* | SITE_ID | if(level == 3) |
| InitSpread |  | 281 | 하드코딩 | AddTextColumn | Site Name | SITE_NAME | if(level == 3) |
| InitSpread |  | 282 | 하드코딩 | AddTextColumn | Company* | COMPANY_ID | if(level == 3) |
| InitSpread |  | 283 | 하드코딩 | AddTextColumn | Company Name | COMPANY_NAME | if(level == 3) |
| InitSpread |  | 284 | 하드코딩 | AddTextColumn | Plant* | PLANT_ID | if(level == 3) |
| InitSpread |  | 285 | 하드코딩 | AddTextColumn | Plant Name | PLANT_NAME | if(level == 3) |
| InitSpread |  | 286 | 하드코딩 | AddTextColumn | Dummy | DUMMY_YN | if(level == 3) |
| InitSpread |  | 287 | 하드코딩 | AddTextColumn | SortOrder | SORT_ORDER | if(level == 3) |
| InitSpread |  | 299 | 하드코딩 | AddTextColumn | Div* | DIVISION_ID | if(level == 4) |
| InitSpread |  | 300 | 하드코딩 | AddTextColumn | Site* | SITE_ID | if(level == 4) |
| InitSpread |  | 301 | 하드코딩 | AddTextColumn | Site Name | SITE_NAME | if(level == 4) |
| InitSpread |  | 302 | 하드코딩 | AddTextColumn | Company* | COMPANY_ID | if(level == 4) |
| InitSpread |  | 303 | 하드코딩 | AddTextColumn | Company Name | COMPANY_NAME | if(level == 4) |
| InitSpread |  | 304 | 하드코딩 | AddTextColumn | Plant* | PLANT_ID | if(level == 4) |
| InitSpread |  | 305 | 하드코딩 | AddTextColumn | Plant Name | PLANT_NAME | if(level == 4) |
| InitSpread |  | 306 | 하드코딩 | AddTextColumn | Building* | FACTORY_ID | if(level == 4) |
| InitSpread |  | 307 | 하드코딩 | AddTextColumn | Building Name | FACTORY_NAME | if(level == 4) |
| InitSpread |  | 308 | 하드코딩 | AddTextColumn | Dummy | DUMMY_YN | if(level == 4) |
| InitSpread |  | 309 | 하드코딩 | AddTextColumn | SortOrder | SORT_ORDER | if(level == 4) |
| InitSpread |  | 321 | 하드코딩 | AddTextColumn | Div* | DIVISION_ID | if(level == 5) |
| InitSpread |  | 322 | 하드코딩 | AddTextColumn | Site* | SITE_ID | if(level == 5) |
| InitSpread |  | 323 | 하드코딩 | AddTextColumn | Site Name | SITE_NAME | if(level == 5) |
| InitSpread |  | 324 | 하드코딩 | AddTextColumn | Company* | COMPANY_ID | if(level == 5) |
| InitSpread |  | 325 | 하드코딩 | AddTextColumn | Company Name | COMPANY_NAME | if(level == 5) |
| InitSpread |  | 326 | 하드코딩 | AddTextColumn | Plant* | PLANT_ID | if(level == 5) |
| InitSpread |  | 327 | 하드코딩 | AddTextColumn | Plant Name | PLANT_NAME | if(level == 5) |
| InitSpread |  | 328 | 하드코딩 | AddTextColumn | Building* | FACTORY_ID | if(level == 5) |
| InitSpread |  | 329 | 하드코딩 | AddTextColumn | Building Name | FACTORY_NAME | if(level == 5) |
| InitSpread |  | 330 | 하드코딩 | AddTextColumn | Line* | LINE_ID | if(level == 5) |
| InitSpread |  | 331 | 하드코딩 | AddTextColumn | Line Name | LINE_NAME | if(level == 5) |
| InitSpread |  | 332 | 하드코딩 | AddTextColumn | Operation Group | SHOP_GROUP_ID | if(level == 5) |
| InitSpread |  | 333 | 하드코딩 | AddTextColumn | Dummy | DUMMY_YN | if(level == 5) |
| InitSpread |  | 334 | 하드코딩 | AddComboColumn | Valid Y/N* | VALID_YN | if(level == 5) |
| InitSpread |  | 335 | 하드코딩 | AddTextColumn | SortOrder | SORT_ORDER | if(level == 5) |
| InitializeComponent |  | 282 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 283 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 284 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 285 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 343 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 344 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 345 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 346 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 404 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 405 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 406 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 407 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 461 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 462 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 463 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 464 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 518 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 519 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 520 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 521 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 229 | 하드코딩 | AddTextColumn | Div* | DIVISION_ID | if(level == 1) |
| InitSpread |  | 230 | 하드코딩 | AddTextColumn | Site* | SITE_ID | if(level == 1) |
| InitSpread |  | 231 | 하드코딩 | AddTextColumn | Site Name | SITE_NAME | if(level == 1) |
| InitSpread |  | 232 | 하드코딩 | AddComboColumn | UseYN* | VALID_YN | if(level == 1) |
| InitSpread |  | 233 | 하드코딩 | AddTextColumn | SortOrder | SORT_ORDER | if(level == 1) |
| InitSpread |  | 246 | 하드코딩 | AddTextColumn | Div* | DIVISION_ID | if(level == 2) |
| InitSpread |  | 247 | 하드코딩 | AddTextColumn | Site* | SITE_ID | if(level == 2) |
| InitSpread |  | 248 | 하드코딩 | AddTextColumn | Site Name | SITE_NAME | if(level == 2) |
| InitSpread |  | 249 | 하드코딩 | AddTextColumn | Company* | COMPANY_ID | if(level == 2) |
| InitSpread |  | 250 | 하드코딩 | AddTextColumn | Company Name | COMPANY_NAME | if(level == 2) |
| InitSpread |  | 251 | 하드코딩 | AddComboColumn | UseYN* | VALID_YN | if(level == 2) |
| InitSpread |  | 252 | 하드코딩 | AddTextColumn | SortOrder | SORT_ORDER | if(level == 2) |
| InitSpread |  | 264 | 하드코딩 | AddTextColumn | Div* | DIVISION_ID | if(level == 3) |
| InitSpread |  | 265 | 하드코딩 | AddTextColumn | Site* | SITE_ID | if(level == 3) |
| InitSpread |  | 266 | 하드코딩 | AddTextColumn | Site Name | SITE_NAME | if(level == 3) |
| InitSpread |  | 267 | 하드코딩 | AddTextColumn | Company* | COMPANY_ID | if(level == 3) |
| InitSpread |  | 268 | 하드코딩 | AddTextColumn | Company Name | COMPANY_NAME | if(level == 3) |
| InitSpread |  | 269 | 하드코딩 | AddTextColumn | Plant* | PLANT_ID | if(level == 3) |
| InitSpread |  | 270 | 하드코딩 | AddTextColumn | Plant Name | PLANT_NAME | if(level == 3) |
| InitSpread |  | 271 | 하드코딩 | AddComboColumn | UseYN* | VALID_YN | if(level == 3) |
| InitSpread |  | 272 | 하드코딩 | AddTextColumn | SortOrder | SORT_ORDER | if(level == 3) |
| InitSpread |  | 284 | 하드코딩 | AddTextColumn | Div* | DIVISION_ID | if(level == 4) |
| InitSpread |  | 285 | 하드코딩 | AddTextColumn | Site* | SITE_ID | if(level == 4) |
| InitSpread |  | 286 | 하드코딩 | AddTextColumn | Site Name | SITE_NAME | if(level == 4) |
| InitSpread |  | 287 | 하드코딩 | AddTextColumn | Company* | COMPANY_ID | if(level == 4) |
| InitSpread |  | 288 | 하드코딩 | AddTextColumn | Company Name | COMPANY_NAME | if(level == 4) |
| InitSpread |  | 289 | 하드코딩 | AddTextColumn | Plant* | PLANT_ID | if(level == 4) |
| InitSpread |  | 290 | 하드코딩 | AddTextColumn | Plant Name | PLANT_NAME | if(level == 4) |
| InitSpread |  | 291 | 하드코딩 | AddTextColumn | Building* | FACTORY_ID | if(level == 4) |
| InitSpread |  | 292 | 하드코딩 | AddTextColumn | Building Name | FACTORY_NAME | if(level == 4) |
| InitSpread |  | 293 | 하드코딩 | AddComboColumn | UseYN* | VALID_YN | if(level == 4) |
| InitSpread |  | 294 | 하드코딩 | AddTextColumn | SortOrder | SORT_ORDER | if(level == 4) |
| InitSpread |  | 306 | 하드코딩 | AddTextColumn | Div* | DIVISION_ID | if(level == 5) |
| InitSpread |  | 307 | 하드코딩 | AddTextColumn | Site* | SITE_ID | if(level == 5) |
| InitSpread |  | 308 | 하드코딩 | AddTextColumn | Site Name | SITE_NAME | if(level == 5) |
| InitSpread |  | 309 | 하드코딩 | AddTextColumn | Company* | COMPANY_ID | if(level == 5) |
| InitSpread |  | 310 | 하드코딩 | AddTextColumn | Company Name | COMPANY_NAME | if(level == 5) |
| InitSpread |  | 311 | 하드코딩 | AddTextColumn | Plant* | PLANT_ID | if(level == 5) |
| InitSpread |  | 312 | 하드코딩 | AddTextColumn | Plant Name | PLANT_NAME | if(level == 5) |
| InitSpread |  | 313 | 하드코딩 | AddTextColumn | Building* | FACTORY_ID | if(level == 5) |
| InitSpread |  | 314 | 하드코딩 | AddTextColumn | Building Name | FACTORY_NAME | if(level == 5) |
| InitSpread |  | 315 | 하드코딩 | AddTextColumn | Line* | LINE_ID | if(level == 5) |
| InitSpread |  | 316 | 하드코딩 | AddTextColumn | Line Name | LINE_NAME | if(level == 5) |
| InitSpread |  | 317 | 하드코딩 | AddComboColumn | UseYN* | VALID_YN | if(level == 5) |
| InitSpread |  | 318 | 하드코딩 | AddTextColumn | SortOrder | SORT_ORDER | if(level == 5) |
| InitializeComponent |  | 285 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 286 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 287 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 288 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 337 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 338 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 339 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 340 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 409 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 410 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 411 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 412 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 457 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 458 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 459 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 460 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 509 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 510 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 511 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 512 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Level1 | 코드 하드코딩 전용(메타 없음) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) |
| Level2 | 코드 하드코딩 전용(메타 없음) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) |
| Level3 | 코드 하드코딩 전용(메타 없음) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) |
| Level4 | 코드 하드코딩 전용(메타 없음) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) |
| Level5 | 코드 하드코딩 전용(메타 없음) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 6440 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 6440건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

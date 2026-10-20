# SCP0096 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.csproj | 852 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.csproj | 724 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 457 | SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | MATCH | SP SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 831 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 457 | SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | MATCH | SP SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main > InitSpread > GetSpdTitle | 831 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetBucketType | 394 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 831 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | <field:dtDayWeek> | 49 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtValidYN> | 51 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | MATCH | 1 | SP SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | EXEC:SCP0096_GET_SHIPMENT_WORKING_DAY_OSP, INSERT:#TBLDYNAMICPIVOT_SCP0096, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_OSP, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, DYNAMIC@SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| GetDayOfWeek | row | COLUMN_NAME |
| GetDayOfWeek | dr | DAY_CODE |
| SaveData_Main | dr | A, p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default |
| SaveData_Main | row | A |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:151 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:156 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:159 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | SetChangedControl:417, SetChangedControl:425, FindData_Main:442, FindData_Main:443, CboDayWeek_SelectedIndexChanged:672, BtnInput_Click:695, BtnInput_Click:696 | CString.GetCheckedListValue | CODE |
| GetChanges | SaveData_Main:609 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:103 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:249 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:250 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:251 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:252 |
| cboDayWeek | SelectedIndexChanged | CboDayWeek_SelectedIndexChanged | InitEvent:253 |
| btnInput | Click | BtnInput_Click | InitEvent:254 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:255 |

## 6. 컨트롤 (28개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| EmptySpaceItem | 8 | emptySpaceItem2, emptySpaceItem4, emptySpaceItem9, emptySpaceItem10, emptySpaceItem1, emptySpaceItem3, emptySpaceItem5, emptySpaceItem6 |
| LayoutControlItem | 7 | layoutControlItem7, layoutControlItem2, layoutControlItem4, layoutControlItem10, layoutSum, layoutControlItem1, layoutControlItem3 |
| UsrCombo | 3 | cboDivision, cboInputValue, cboDayWeek |
| UsrButton | 2 | usrButton1, btnInput |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrCheckedList | 1 | clbPlantSite |
| UsrCheckBox | 1 | chkSum |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 4 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 6 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 456 | SCP.SCP0019_GET_WORKING_TIME | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0096 | Shipment Working Day OSP | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Working Day OSP
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:156
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 196 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 203 | DB루프 | AddComboColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 208 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 350 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 355 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| InitializeComponent |  | 628 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 629 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 630 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 631 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Working Day OSP | META+코드연결 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.


### FILE endpoints.csv (5 rows)
```csv
"variant","file","class","member","line","site_kind","kind","candidate","key","status","sp_or_sql","objects","via","detail"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","<field:dtDayWeek>","49","derived","biz","CommonData.CommonDataList [code=LookupCommon]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.LookupCommon:Type.LookupCommon] > Data.CallBizCommonData",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","<field:dtValidYN>","51","derived","biz","CommonData.YesOrNo","biz:CommonData.YesOrNo","BIZ_MATCH","","","Data.Common[case Type.YesOrNo:Type.YesOrNo] > Data.CallBizData",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","GetBucketType","394","ctor","fox","DM.DM0003_GET_BUCKET_TYPE_CODE","DM.DM0003_GET_BUCKET_TYPE_CODE","MATCH","SP DM0003_GET_BUCKET_TYPE_CODE","EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","FindData_Main","457","ctor","fox","SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP","SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP","MATCH","SP SCP0096_GET_SHIPMENT_WORKING_DAY_OSP","EXEC:SCP0096_GET_SHIPMENT_WORKING_DAY_OSP, INSERT:#TBLDYNAMICPIVOT_SCP0096, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_OSP, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, DYNAMIC@SCP0096_GET_SHIPMENT_WORKING_DAY_OSP","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","GetSpdTitle","831","ctor","fox","SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN","SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN","MATCH","SP SCP0009_GET_SHEET_CALENDAR_3SPAN","EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M","",""
```

### FILE flow.csv (8 rows)
```csv
"variant","file","class","entry_kind","entry","path","member","line","endpoint","status","sp_or_sql","objects"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","event","this.Load","Form_Load > CreateSpread > InitSpread > GetSpdTitle","GetSpdTitle","831","SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN","MATCH","SP SCP0009_GET_SHEET_CALENDAR_3SPAN","EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","event","this.Load","Form_Load > InitControls > GetBucketType","GetBucketType","394","DM.DM0003_GET_BUCKET_TYPE_CODE","MATCH","SP DM0003_GET_BUCKET_TYPE_CODE","EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","button","FindButton","FindButton > FindData_Main","FindData_Main","457","SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP","MATCH","SP SCP0096_GET_SHIPMENT_WORKING_DAY_OSP","EXEC:SCP0096_GET_SHIPMENT_WORKING_DAY_OSP, INSERT:#TBLDYNAMICPIVOT_SCP0096, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_OSP, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, DYNAMIC@SCP0096_GET_SHIPMENT_WORKING_DAY_OSP"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","button","FindButton","FindButton > FindData_Main > InitSpread > GetSpdTitle","GetSpdTitle","831","SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN","MATCH","SP SCP0009_GET_SHEET_CALENDAR_3SPAN","EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","button","SaveButton","SaveButton > SaveData_Main > FindData_Main","FindData_Main","457","SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP","MATCH","SP SCP0096_GET_SHIPMENT_WORKING_DAY_OSP","EXEC:SCP0096_GET_SHIPMENT_WORKING_DAY_OSP, INSERT:#TBLDYNAMICPIVOT_SCP0096, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_OSP, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, DYNAMIC@SCP0096_GET_SHIPMENT_WORKING_DAY_OSP"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","button","SaveButton","SaveButton > SaveData_Main > FindData_Main > InitSpread > GetSpdTitle","GetSpdTitle","831","SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN","MATCH","SP SCP0009_GET_SHEET_CALENDAR_3SPAN","EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","unreached","(진입점 미연결)","<field:dtValidYN>","<field:dtValidYN>","51","biz:CommonData.YesOrNo","BIZ_MATCH","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","unreached","(진입점 미연결)","<field:dtDayWeek>","<field:dtDayWeek>","49","biz:CommonData.CommonDataList [code=LookupCommon]","BIZ_MATCH","",""
```

### FILE events.csv (8 rows)
```csv
"variant","file","class","member","line","target","event","handler","op"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP",".ctor","103","this","Load","Form_Load","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitEvent","249","spdMain","CellDoubleClick","SpdMain_CellDoubleClick","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitEvent","250","spdMain","TopChange","SpdMain_TopChange","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitEvent","251","cboDivision","SelectedIndexChanged","CboDivision_SelectedIndexChanged","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitEvent","252","clbPlantSite","SelectedIndexChanged","ClbPlantSite_SelectedIndexChanged","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitEvent","253","cboDayWeek","SelectedIndexChanged","CboDayWeek_SelectedIndexChanged","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitEvent","254","btnInput","Click","BtnInput_Click","+="
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitEvent","255","this.chkSum","CheckedChanged","chkSum_CheckedChanged","+="
```

### FILE controls.csv (28 rows)
```csv
"variant","file","class","name","type","parent","line"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","usrButton1","GSCM.Windows.Forms.Controls.UsrButton","","33"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","usrConditionPanel1","GSCM.Windows.Forms.Controls.UsrConditionPanel","this","34"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","usrLayoutControl2","GSCM.Windows.Forms.Controls.UsrLayoutControl","usrConditionPanel1","35"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","dCalendar","GSCM.Windows.Forms.Controls.UsrDateRangePicker3","usrLayoutControl2","36"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","btnInput","GSCM.Windows.Forms.Controls.UsrButton","usrLayoutControl2","37"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","cboDivision","GSCM.Windows.Forms.Controls.UsrCombo","usrLayoutControl2","38"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","clbPlantSite","GSCM.Windows.Forms.Controls.UsrCheckedList","usrLayoutControl2","39"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","chkSum","GSCM.Windows.Forms.Controls.UsrCheckBox","usrLayoutControl2","40"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","cboInputValue","GSCM.Windows.Forms.Controls.UsrCombo","usrLayoutControl2","41"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","cboDayWeek","GSCM.Windows.Forms.Controls.UsrCombo","usrLayoutControl2","42"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","layoutControlGroup2","DevExpress.XtraLayout.LayoutControlGroup","","43"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","layoutControlItem7","DevExpress.XtraLayout.LayoutControlItem","","44"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","emptySpaceItem2","DevExpress.XtraLayout.EmptySpaceItem","","45"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","emptySpaceItem4","DevExpress.XtraLayout.EmptySpaceItem","","46"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","emptySpaceItem9","DevExpress.XtraLayout.EmptySpaceItem","","47"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","emptySpaceItem10","DevExpress.XtraLayout.EmptySpaceItem","","48"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","emptySpaceItem1","DevExpress.XtraLayout.EmptySpaceItem","","49"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","emptySpaceItem3","DevExpress.XtraLayout.EmptySpaceItem","","50"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","emptySpaceItem5","DevExpress.XtraLayout.EmptySpaceItem","","51"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","emptySpaceItem6","DevExpress.XtraLayout.EmptySpaceItem","","52"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","layoutControlItem2","DevExpress.XtraLayout.LayoutControlItem","","53"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","layoutControlItem4","DevExpress.XtraLayout.LayoutControlItem","","54"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","layoutControlItem10","DevExpress.XtraLayout.LayoutControlItem","","55"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","layoutSum","DevExpress.XtraLayout.LayoutControlItem","","56"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","layoutControlItem1","DevExpress.XtraLayout.LayoutControlItem","","57"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","layoutControlItem3","DevExpress.XtraLayout.LayoutControlItem","","58"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","spdMain","FarPoint.Win.Spread.FpSpread","this","59"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","spdMain_Sheet1","FarPoint.Win.Spread.SheetView","","60"
```

### FILE props.csv (53 rows)
```csv
"variant","file","class","member","line","target","prop","value"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","115","usrButton1","Size","new System.Drawing.Size(75, 23)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","124","usrConditionPanel1","Dock","System.Windows.Forms.DockStyle.Top"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","127","usrConditionPanel1","Size","new System.Drawing.Size(1192, 96)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","129","usrConditionPanel1","UsrPanelType","GSCM.Windows.Forms.Controls.UsrConditionPanel.PanelType.HidePanel"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","141","usrLayoutControl2","Dock","System.Windows.Forms.DockStyle.Fill"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","146","usrLayoutControl2","Size","new System.Drawing.Size(1192, 96)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","148","usrLayoutControl2","Text","""usrLayoutControl2"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","189","dCalendar","Size","new System.Drawing.Size(210, 22)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","229","btnInput","Size","new System.Drawing.Size(77, 21)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","232","btnInput","Text","""Input"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","268","cboDivision","Size","new System.Drawing.Size(181, 20)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","304","clbPlantSite","Size","new System.Drawing.Size(165, 21)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","341","chkSum","Size","new System.Drawing.Size(46, 20)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","344","chkSum","Text","""Sum"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","346","chkSum","Visible","false"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","380","cboInputValue","Size","new System.Drawing.Size(124, 20)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","416","cboDayWeek","Size","new System.Drawing.Size(134, 20)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","442","layoutControlGroup2","Size","new System.Drawing.Size(1192, 96)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","447","layoutControlItem7","Control","this.clbPlantSite"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","451","layoutControlItem7","Size","new System.Drawing.Size(226, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","453","layoutControlItem7","Text","""Plant Site"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","463","emptySpaceItem2","Size","new System.Drawing.Size(390, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","471","emptySpaceItem4","Size","new System.Drawing.Size(540, 26)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","479","emptySpaceItem9","Size","new System.Drawing.Size(10, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","487","emptySpaceItem10","Size","new System.Drawing.Size(53, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","495","emptySpaceItem1","Size","new System.Drawing.Size(10, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","504","emptySpaceItem3","Size","new System.Drawing.Size(26, 26)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","512","emptySpaceItem5","Size","new System.Drawing.Size(606, 26)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","520","emptySpaceItem6","Size","new System.Drawing.Size(566, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","525","layoutControlItem2","Control","this.dCalendar"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","530","layoutControlItem2","Size","new System.Drawing.Size(260, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","532","layoutControlItem2","Text","""Period*"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","539","layoutControlItem4","Control","this.cboDivision"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","543","layoutControlItem4","Size","new System.Drawing.Size(236, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","545","layoutControlItem4","Text","""Division*"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","552","layoutControlItem10","Control","this.btnInput"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","557","layoutControlItem10","Size","new System.Drawing.Size(81, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","565","layoutSum","Control","this.chkSum"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","570","layoutSum","Size","new System.Drawing.Size(50, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","577","layoutControlItem1","Control","this.cboInputValue"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","582","layoutControlItem1","Size","new System.Drawing.Size(226, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","584","layoutControlItem1","Text","""Input Value"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","591","layoutControlItem3","Control","this.cboDayWeek"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","596","layoutControlItem3","Size","new System.Drawing.Size(236, 25)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","598","layoutControlItem3","Text","""Day of the week"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","606","spdMain","Dock","System.Windows.Forms.DockStyle.Fill"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","611","spdMain","Size","new System.Drawing.Size(1192, 553)"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","663","this","Text","""Shipment Working Day OSP"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","DefineProperty","121","chkSum","Checked","false"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SetSpreadColumn","350","siObj.ActiveSheet.Columns[iCol]","Visible","true"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SetSpreadColumn","355","siObj.ActiveSheet.Columns[iCol]","Visible","chkSum.Checked"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","CboDayWeek_SelectedIndexChanged","675","cboInputValue","Enabled","false"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","CboDayWeek_SelectedIndexChanged","679","cboInputValue","Enabled","true"
```

### FILE grid_effective.csv (6 rows)
```csv
"sheet","sheet_rule","column","label","source","40","81","81_HD","81_HG","81_HM","81_ST","81_UC","82","EE","EE_HD","EE_HG","EE_HM","EE_ST","EE_UC"
"Shipment Working Day OSP","META+코드연결","DIVISION_ID","Division","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Working Day OSP","META+코드연결","LAST_INPUT_DATE","Last Input Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Working Day OSP","META+코드연결","MEASURE","Measure","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Working Day OSP","META+코드연결","PLANT_SITE_ID","Plant Site ID","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Working Day OSP","META+코드연결","PLANT_SITE_NAME","Plant Site","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Working Day OSP","META+코드연결","WORKING_TIME_DEFAULT","Working Time Default","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
```

### FILE grid_code.csv (32 rows)
```csv
"variant","file","class","member","line","sheet_hint","kind","api","source","header","field","columns","args","arg_names","conditions","raw"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","CreateSpread","142","Shipment Working Day OSP","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ Shipment Working Day OSP ¦ Shipment Working Day OSP ¦ 3 ¦ 1 ¦ 35","","","spdMain ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 3 ¦ 1 ¦ 35"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","CreateSpread","143","0","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ 0","","","spdMain.Name ¦ 0"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","CreateSpread","144","0","SHEET","ChangeSheet","EXPR","","","","","","",""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpread","155","Shipment Working Day OSP","SHEET","InitSheet","HARDCODED","","","","Shipment Working Day OSP","","if(spdInfo.SheetName == ""Shipment Working Day OSP"")","SpdSheet.shtMain"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpread","156","Shipment Working Day OSP","META_BUILD","SetSheetHeaderColumn","EXPR","","","","{?GetSheetInfo(spdMain.Name, 0)} || {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)} ¦ 3","siObj,iColumnHeaderRowCount","if(spdInfo.SheetName == ""Shipment Working Day OSP"")","siMain ¦ 3"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpread","159","Shipment Working Day OSP","LOCAL_METHOD","local:InitSpreadDateColumn","EXPR","","","","{p:spdInfo} ¦ {?spdInfo.GetColumnIndex(DefColumns.MEASURE)}1","","if(spdInfo.SheetName == ""Shipment Working Day OSP"")","spdInfo ¦ nIdxDataMain"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpread","160","Shipment Working Day OSP","LOCAL_METHOD","local:SetSpreadColumn","EXPR","","","","{?GetSheetInfo(spdMain.Name, 0)} || {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)}","","if(spdInfo.SheetName == ""Shipment Working Day OSP"")","siMain"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpreadDateColumn","196","","COLUMN","AddTextColumn","DB_DRIVEN","{?dr[DefColumns.COLUMN_LABEL_NAME]}","{?dr[DefColumns.COLUMN_NAME]}","","{?dr[DefColumns.COLUMN_LABEL_NAME]} ¦ {?dr[DefColumns.COLUMN_NAME]} ¦ {?FPMerge.None} ¦ 0 ¦ {?false}","sHeaderText,sFieldName,merge,fWidth,bVisible","foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf(""B_"") > 0)","sColumnLabelname ¦ sColumnName ¦ FPMerge.None ¦ 0 ¦ false"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpreadDateColumn","203","","COLUMN","AddComboColumn","DB_DRIVEN","{?dr[DefColumns.COLUMN_LABEL_NAME]}","{?dr[DefColumns.COLUMN_NAME]}","","{?dr[DefColumns.COLUMN_LABEL_NAME]} ¦ {?dr[DefColumns.COLUMN_NAME]} ¦ {?FPMerge.None} ¦ 50 ¦ {?true} ¦ {?Data.Common(Data.Type.YesOrNo, false)} ¦ {?FPHAlign.Center} ¦ {?FPVAlign.Center}","sHeaderText,sFieldName,merge,fWidth,bVisible,dt,fph,fpv","foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf(""B_"") > 0)","sColumnLabelname ¦ sColumnName ¦ FPMerge.None ¦ 50 ¦ true ¦ dtValidYN ¦ FPHAlign.Center ¦ FPVAlign.Center"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpreadDateColumn","208","","OVERRIDE","set:ForeColor","EXPR","","","","{?sDayCode == ""SAT""? Color.Blue : Color.Red}","ForeColor","foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf(""B_"") > 0) ⟫ if(sDayCode == ""SAT""|| sDayCode == ""SUN"")","sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Re…"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpreadDateColumn","215","","OTHER","ColumnHeaderSpan","DB_DRIVEN","","","","0 ¦ {p:nIdxData} || {?iLargeStartCol}0 ¦ 1 ¦ 0 ¦ 20 ¦ {?dsSpdTitle.Tables[0].Rows[0][2]} || {?dr[DefColumns.LARGE_CLASS_LABEL_NAME]} ¦ {?FPHAlign.Center}","iRow,iCol,iRowCount,iColCount,iHeight,sHeaderString,fph","foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sLargeSpanName != sLargeLabelName)","0 ¦ iLargeStartCol ¦ 1 ¦ iLargeSpanCnt ¦ 20 ¦ sLargeSpanName ¦ FPHAlign.Center"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpreadDateColumn","216","","OTHER","ColumnHeaderSpan","EXPR","","","","1 ¦ {p:nIdxData} || {?iLargeStartCol}0 ¦ 2 ¦ 1 ¦ 20 ¦ SUM ¦ {?FPHAlign.Center}","iRow,iCol,iRowCount,iColCount,iHeight,sHeaderString,fph","foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sLargeSpanName != sLargeLabelName)","1 ¦ iLargeStartCol ¦ 2 ¦ 1 ¦ 20 ¦ ""SUM"" ¦ FPHAlign.Center"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpreadDateColumn","221","","OTHER","ColumnHeaderSpan","DB_DRIVEN","","","","1 ¦ {p:nIdxData} || {?iSmallStartCol}0 ¦ 1 ¦ 0 ¦ 20 ¦ {?dsSpdTitle.Tables[0].Rows[0][2]} || {?dr[DefColumns.SMALL_CLASS_LABEL_NAME]} ¦ {?FPHAlign.Center}","iRow,iCol,iRowCount,iColCount,iHeight,sHeaderString,fph","foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sLargeSpanName != sLargeLabelName)","1 ¦ iSmallStartCol ¦ 1 ¦ iSmallSpanCnt ¦ 20 ¦ sSmallSpanName ¦ FPHAlign.Center"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpreadDateColumn","222","","OTHER","ColumnHeaderSpan","EXPR","","","","2 ¦ {p:nIdxData} || {?iSmallStartCol}0 ¦ 1 ¦ 1 ¦ 30 ¦ SUM ¦ {?FPHAlign.Center}","iRow,iCol,iRowCount,iColCount,iHeight,sHeaderString,fph","foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sLargeSpanName != sLargeLabelName)","2 ¦ iSmallStartCol ¦ 1 ¦ 1 ¦ 30 ¦ ""SUM"" ¦ FPHAlign.Center"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpreadDateColumn","230","","OTHER","ColumnHeaderSpan","DB_DRIVEN","","","","1 ¦ {p:nIdxData} || {?iSmallStartCol}0 ¦ 1 ¦ 0 ¦ 20 ¦ {?dsSpdTitle.Tables[0].Rows[0][2]} || {?dr[DefColumns.SMALL_CLASS_LABEL_NAME]} ¦ {?FPHAlign.Center}","iRow,iCol,iRowCount,iColCount,iHeight,sHeaderString,fph","foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sLargeSpanName != sLargeLabelName) ⟫ if(sSmallSpanName != sSmallLabelName)","1 ¦ iSmallStartCol ¦ 1 ¦ iSmallSpanCnt ¦ 20 ¦ sSmallSpanName ¦ FPHAlign.Center"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpreadDateColumn","231","","OTHER","ColumnHeaderSpan","EXPR","","","","2 ¦ {p:nIdxData} || {?iSmallStartCol}0 ¦ 1 ¦ 1 ¦ 20 ¦ SUM ¦ {?FPHAlign.Center}","iRow,iCol,iRowCount,iColCount,iHeight,sHeaderString,fph","foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sLargeSpanName != sLargeLabelName) ⟫ if(sSmallSpanName != sSmallLabelName)","2 ¦ iSmallStartCol ¦ 1 ¦ 1 ¦ 20 ¦ ""SUM"" ¦ FPHAlign.Center"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpreadDateColumn","241","","OTHER","ColumnHeaderSpan","DB_DRIVEN","","","","1 ¦ {p:nIdxData} || {?iSmallStartCol}0 ¦ 1 ¦ 0 ¦ 20 ¦ {?dsSpdTitle.Tables[0].Rows[0][2]} || {?dr[DefColumns.SMALL_CLASS_LABEL_NAME]} ¦ {?FPHAlign.Center}","iRow,iCol,iRowCount,iColCount,iHeight,sHeaderString,fph","","1 ¦ iSmallStartCol ¦ 1 ¦ iSmallSpanCnt ¦ 20 ¦ sSmallSpanName ¦ FPHAlign.Center"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpreadDateColumn","242","","OTHER","ColumnHeaderSpan","EXPR","","","","2 ¦ {p:nIdxData} || {?iSmallStartCol}0 ¦ 1 ¦ 1 ¦ 20 ¦ SUM ¦ {?FPHAlign.Center}","iRow,iCol,iRowCount,iColCount,iHeight,sHeaderString,fph","","2 ¦ iSmallStartCol ¦ 1 ¦ 1 ¦ 20 ¦ ""SUM"" ¦ FPHAlign.Center"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpreadDateColumn","243","","OTHER","ColumnHeaderSpan","DB_DRIVEN","","","","0 ¦ {p:nIdxData} || {?iLargeStartCol}0 ¦ 1 ¦ 0 ¦ 20 ¦ {?dsSpdTitle.Tables[0].Rows[0][2]} || {?dr[DefColumns.LARGE_CLASS_LABEL_NAME]} ¦ {?FPHAlign.Center}","iRow,iCol,iRowCount,iColCount,iHeight,sHeaderString,fph","","0 ¦ iLargeStartCol ¦ 1 ¦ iLargeSpanCnt ¦ 20 ¦ sLargeSpanName ¦ FPHAlign.Center"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","InitSpreadDateColumn","244","","OTHER","ColumnHeaderSpan","EXPR","","","","1 ¦ {p:nIdxData} || {?iLargeStartCol}0 ¦ 2 ¦ 1 ¦ 20 ¦ SUM ¦ {?FPHAlign.Center}","iRow,iCol,iRowCount,iColCount,iHeight,sHeaderString,fph","","1 ¦ iLargeStartCol ¦ 2 ¦ 1 ¦ 20 ¦ ""SUM"" ¦ FPHAlign.Center"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","EditButton","288","","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ {?fps.ActiveSheetIndex}","","if(fps != null) ⟫ if(fps.Name == ""spdMain"")","spdMain.Name ¦ fps.ActiveSheetIndex"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","cboBucketType_SelectedIndexChanged","311","","LOCAL_METHOD","local:SetSpreadColumn","EXPR","","","","{?GetSheetInfo(spdMain.Name, 0)} || {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)}","","if(fps != null) ⟫ if(fps.Name == ""spdMain"")","siMain"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","cboBucketType_SelectedIndexChanged","316","","LOCAL_METHOD","local:SetSpreadColumn","EXPR","","","","{?GetSheetInfo(spdMain.Name, 0)} || {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)}","","else!(fps != null)","siMain"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","chkSum_CheckedChanged","330","","LOCAL_METHOD","local:SetSpreadColumn","EXPR","","","","{?GetSheetInfo(spdMain.Name, 0)} || {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)}","","if(fps != null) ⟫ if(fps.Name == ""spdMain"")","siMain"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","chkSum_CheckedChanged","335","","LOCAL_METHOD","local:SetSpreadColumn","EXPR","","","","{?GetSheetInfo(spdMain.Name, 0)} || {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)}","","else!(fps != null)","siMain"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SetSpreadColumn","350","","OVERRIDE","set:Visible","EXPR","","","","{?true}","Visible","for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(siObj.GetColumnTag(iCol).IndexOf(""D_"") == 0 || siObj.GetColumnTag(iCol).IndexOf(""W_"") == 0)","true"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SetSpreadColumn","355","","OVERRIDE","set:Visible","EXPR","","","","{?chkSum.Checked}","Visible","for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(siObj.GetColumnTag(iCol).IndexOf(""M_"") == 0 || siObj.GetColumnTag(iCol).IndexOf(""W_"") == 0)","chkSum.Checked"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","FindData_Main","484","","LOCAL_METHOD","local:SetSpreadColumn","EXPR","","","","{?GetSheetInfo(spdMain.Name, 0)} || {?GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)}","","if(siMain.GetMaxRowIndex() > 0)","siMain"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","628","","OVERRIDE","set:HorizontalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellHorizontalAlignment.General}","HorizontalAlignment","","FarPoint.Win.Spread.CellHorizontalAlignment.General"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","629","","OVERRIDE","set:NoteIndicatorColor","EXPR","","","","{?System.Drawing.Color.Red}","NoteIndicatorColor","","System.Drawing.Color.Red"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","630","","OVERRIDE","set:Parent","HARDCODED","","","","ColumnHeaderDefaultEnhanced","Parent","","""ColumnHeaderDefaultEnhanced"""
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs","SCP0096_Shipment_Working_Day_OSP","InitializeComponent","631","","OVERRIDE","set:VerticalAlignment","EXPR","","","","{?FarPoint.Win.Spread.CellVerticalAlignment.General}","VerticalAlignment","","FarPoint.Win.Spread.CellVerticalAlignment.General"
```

### FILE meta_reads.csv (16 rows)
```csv
"variant","file","class","member","line","receiver","column","via"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","558","dr","A","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","560","dr","p_division_id","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","561","dr","p_plant_site_id","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","562","dr","p_measure","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","563","dr","p_user_id","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","570","dr","p_yyyymmdd","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","571","dr","p_shipment_yn","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","572","dr","p_is_save_defalut","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","573","dr","p_working_time_default","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","578","dr","p_yyyymmdd","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","579","dr","p_shipment_yn","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","580","dr","p_is_save_defalut","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","581","dr","p_working_time_default","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","SaveData_Main","600","row","A","[]"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","GetDayOfWeek","815","row","COLUMN_NAME","Field"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","SCP0096_Shipment_Working_Day_OSP","GetDayOfWeek","816","dr","DAY_CODE","[]"
```

### FILE commented_calls.csv (1 rows)
```csv
"variant","file","line","kind","candidate","key","status"
"current","06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs","456","fox","SCP.SCP0019_GET_WORKING_TIME","SCP.SCP0019_GET_WORKING_TIME","commented:MATCH"
```

# DM0036 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DM0036_Capacity_Allocation\DM0036_Capacity_Allocation.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DM0036_Capacity_Allocation\DM0036_Capacity_Allocation.csproj | 988 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DM0036_Capacity_Allocation\DM0036_Capacity_Allocation.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DM0036_Capacity_Allocation\DM0036_Capacity_Allocation.csproj | 678 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DM0036_Capacity_Allocation\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DM0036_Capacity_Allocation\DM0036_Capacity_Allocation.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DM0036_Capacity_Allocation\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DM0036_Capacity_Allocation\DM0036_Capacity_Allocation.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DM0036_Capacity_Allocation\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DM0036_Capacity_Allocation\DM0036_Capacity_Allocation.csproj | 27 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DM0036_Capacity_Allocation.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 988 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DM0036_Capacity_Allocation.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 678 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData > InitSpread > SetCalendar | 182 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 382 | DM.DM0036_GET_CAPACITY_ALLOCATION_RATE | MATCH | SP DM0036_GET_CAPACITY_ALLOCATION_RATE |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > SetCalendar | 182 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData | 382 | DM.DM0036_GET_CAPACITY_ALLOCATION_RATE | MATCH | SP DM0036_GET_CAPACITY_ALLOCATION_RATE |
| event:this.btnDelete.Click | btnDelete_Click > DeleteData > FindData > InitSpread > SetCalendar | 182 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:this.btnDelete.Click | btnDelete_Click > DeleteData > FindData | 382 | DM.DM0036_GET_CAPACITY_ALLOCATION_RATE | MATCH | SP DM0036_GET_CAPACITY_ALLOCATION_RATE |
| event:this.btnInput.Click | btnInput_Click > FindInput > InitSpread > SetCalendar | 182 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:this.btnInput.Click | btnInput_Click > FindInput | 868 | DM.DM0036_GET_CAPACITY_ALLOCATION_RATE_INPUT | MATCH | SP DM0036_GET_CAPACITY_ALLOCATION_RATE_INPUT |
| event:this.Load | Form_Load > InitControls | 147 | biz:CommonData.CommonDataList [code=PERIOD_ \|\| PERIOD_DEFAULT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetCalendar | 182 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedPeriod | 793 | biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtMyDivision> | 44 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_SYS_CALENDAR_M |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=PERIOD_ \|\| PERIOD_DEFAULT] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH | 1 |  |  |  |
| DM.DM0036_GET_CAPACITY_ALLOCATION_RATE | MATCH | 1 | SP DM0036_GET_CAPACITY_ALLOCATION_RATE | EXEC:DM0036_GET_CAPACITY_ALLOCATION_RATE, INSERT:#TBLDYNAMICPIVOT_DM0036_01, REF:UF_FX_STRING_SPLIT, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN, REF:STRING_SPLIT, SELECT:DM_MST_CAPACITY_ALLOCATION, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCM_MST_MODEL_FINAL_ITEM_BOM_V, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, INSERT:#TBLDYNAMICPIVOT_DM0036_01_END, SELECT:#TBLDYNAMICPIVOT_DM0036_01, INSERT:#TBLDYNAMICPIVOT_DM0036_01_SALES, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@DM0036_GET_CAPACITY_ALLOCATION_RATE |  |
| DM.DM0036_GET_CAPACITY_ALLOCATION_RATE_INPUT | MATCH | 1 | SP DM0036_GET_CAPACITY_ALLOCATION_RATE_INPUT | EXEC:DM0036_GET_CAPACITY_ALLOCATION_RATE_INPUT, INSERT:#TBLDYNAMICPIVOT_DM0036_01, REF:UF_FX_STRING_SPLIT, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN, REF:STRING_SPLIT, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCM_MST_MODEL_FINAL_ITEM_BOM_V, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@DM0036_GET_CAPACITY_ALLOCATION_RATE_INPUT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| DeleteData | dr | A, p_active_flag, p_division_id, p_item_id, p_yyyymm, p_capacity_rate, p_project_code, p_scm_site_id, p_user_id, p_program_id, debug_mode, p_loc_flag |
| DeleteData | dsInput.Tables[0].Rows[0] | p_loc_flag |
| DeleteData | dsInput.Tables[0].Rows[nRowCnt - 1] | p_loc_flag |
| DeleteData | row | A |
| SaveData | dr | A, p_active_flag, p_division_id, p_item_id, p_yyyymm, p_capacity_rate, p_project_code, p_scm_site_id, p_user_id, p_program_id, debug_mode, p_loc_flag |
| SaveData | dsInput.Tables[0].Rows[0] | p_loc_flag |
| SaveData | dsInput.Tables[0].Rows[nRowCnt - 1] | p_loc_flag |
| SaveData | row | A |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpread:171 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:252 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | btnInput_Click:260, btnDelete_Click:280, FindData:362, FindData:363, FindData:364, FindInput:854 | CString.GetCheckedListValue | CODE |
| GetChanges | DeleteData:512, SaveData:697 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | DM0036_Capacity_Allocation_Load | InitializeComponent:619 |
| this | Load | Form_Load | .ctor:93 |
| this.btnInput | Click | btnInput_Click | InitEvent:112 |
| this.btnDelete | Click | btnDelete_Click | InitEvent:113 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:114 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:116 |
| dsdm | Changed | spdMain_Change | InitEvent:119 |
| dsdm | Changed | spdMain_Change | TotalMerge:808 |
| dsdm | Changed | spdMain_Change | TotalMerge:830 |
| dsdm | Changed | spdMain_Change | FindInput:840 |
| dsdm | Changed | spdMain_Change | FindInput:915 |
| dsdm | Changed | spdMain_Change | spdMain_Change:924 |
| dsdm | Changed | spdMain_Change | spdMain_Change:971 |

## 6. 컨트롤 (26개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 8 | Model, layoutControlItem11, layoutControlItem1, layoutControlItem5, Period, layoutControlItem4, layoutControlItem2, layoutControlItem3 |
| UsrButton | 3 | btnItemId, btnInput, btnDelete |
| EmptySpaceItem | 3 | emptySpaceItem4, emptySpaceItem3, emptySpaceItem2 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCheckedList | 2 | clbEndCustomer, clbSalesSite |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCombo | 1 | cboDivision |
| UsrMonthRangePicker | 1 | drpPeriod |
| UsrMultiLineEditor | 1 | txtItemId |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 9 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 9 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DM0036 | Main | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:171

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetCalendar |  | 191 | DB루프 | AddNumColumn | {?a.Field<string>(DefColumns.YYYYMM_NAME)} | M_{?a.Field<string>(DefColumns.YYYYMM)} | foreach(a in dtCalendar.AsEnumerable()) |
| InitializeComponent |  | 584 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 585 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 586 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 587 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

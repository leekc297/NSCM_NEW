# SCP0075 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0075_Allo_Target\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0075_Allo_Target\SCP0075_Allo_Target.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0075_Allo_Target\SCP0075_Allo_Target.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0075_Allo_Target\SCP0075_Allo_Target.csproj | 1407 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0075_Allo_Target\SCP0075_Allo_Target.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0075_Allo_Target\SCP0075_Allo_Target.csproj | 1189 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 589 | SCP.SCP0075_GET_ALLO_TARGET_SMALL | MATCH | SP SCP0075_GET_ALLO_TARGET_SMALL |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 589 | SCP.SCP0075_GET_ALLO_TARGET_SMALL | MATCH | SP SCP0075_GET_ALLO_TARGET_SMALL |
| button:SaveButton | SaveButton > SaveData | 1162 | SCP.SCP0075_SAVE_ALLO_TARGET_SMALL | MATCH | SP SCP0075_SAVE_ALLO_TARGET_SMALL |
| event:this.Load | Form_Load > InitControls | 157 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetBucketType | 230 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0075_GET_ALLO_TARGET_SMALL | MATCH | 1 | SP SCP0075_GET_ALLO_TARGET_SMALL | EXEC:SCP0075_GET_ALLO_TARGET_SMALL, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCP_ANL_ALLO_TARGET, INSERT:#SUM, SELECT:#SUM, DYNAMIC@SCP0075_GET_ALLO_TARGET_SMALL |  |
| SCP.SCP0075_SAVE_ALLO_TARGET_SMALL | MATCH | 1 | SP SCP0075_SAVE_ALLO_TARGET_SMALL | EXEC:SCP0075_SAVE_ALLO_TARGET_SMALL, CREATE:#TBLDYNAMIC_SCP0075_ALLO_TARGET, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TBLDYNAMIC_SCP0075_ALLO_TARGET, MERGE:SCP_ANL_ALLO_TARGET, SELECT:#TBLDYNAMIC_SCP0075_ALLO_TARGET, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InsertRow | dtPlanDate.Rows[0] | CODE |
| SetChangedControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:256, SetChangedControl:276, EditButton:499, FindData_Main:574, FindData_Main:575, FindData_Main:579, Get_All_CutOff_Idx:705, clbTeam_SelectedIndexChanged:1375 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | SetSpreadInit:320, InitSpreadVariable:342, FindData_Main:550 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:542 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| OnShown | OnShown:1396 | BaseForm.OnShown | NowGroupID, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:440 |
| this | Load | Form_Load | .ctor:131 |
| this.btnModel_ID | Click | btnModel_ID_Click | InitEvent:210 |
| this.btnNickName | Click | btnNickName_Click | InitEvent:211 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:212 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:213 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:214 |
| cboOperationGroup | SelectedIndexChanged | CboBizType_SelectedIndexChanged | InitEvent:215 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:216 |
| this | FormClosing | SCP0075_Allo_Target_FormClosing | InitEvent:217 |

## 6. 컨트롤 (49개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| EmptySpaceItem | 15 | emptySpaceItem8, emptySpaceItem9, emptySpaceItem2, emptySpaceItem1, emptySpaceItem10, emptySpaceItem11, emptySpaceItem12, emptySpaceItem15, emptySpaceItem16, emptySpaceItem5, emptySpaceItem14, emptySpaceItem3, emptySpaceItem6, emptySpaceItem7, emptySpaceItem13 |
| LayoutControlItem | 14 | lblCombo, lblCombo1, lblItemId, PlanDate, layoutControlItem4, layoutControlItem8, layoutControlItem1, layoutControlItem5, layoutControlItem7, layoutControlItem6, layoutControlItem10, layoutControlItem11, layoutControlItem12, lblBucket |
| UsrCombo | 5 | cboCellTypeGr, cboOperationGroup, cboPlanDate, cboDivision, cboBucketType |
| UsrButton | 3 | usrButton1, btnModel_ID, btnNickName |
| UsrLabel | 2 | ulPlanType_Seq2, ulPlanType_Seq1 |
| UsrMonthPicker | 2 | umpMonthTo, umpMonthFrom |
| UsrMultiLineEditor | 2 | txtNickName, txtModel_ID |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckedList2 | 1 | clbTeam |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 10 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 8 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 6 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 20 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0075 | Allo Target | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Allo Target
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetSpreadInit:320, SetSheetHeaderColumn@InitSpreadVariable:342, SetSheetHeaderColumn@FindData_Main:550
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): ColumnHeaderSpan, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadVariable |  | 361 | 식 | AddNumColumn | {?string.Empty} \|\| {?s.Substring(2, 6)} | {?s} | foreach(s in sColArray) |
| InitSpreadVariable |  | 364 | 표시/라벨 변경 | SetColumnHeader | 0 |  | foreach(s in sColArray) |
| InitSpreadVariable |  | 365 | 표시/라벨 변경 | SetColumnHeader | 1 |  | foreach(s in sColArray) |
| ColumnHeaderSpan |  | 390 | 식 | AddColumnHeaderSpanCell | 0 | {?siMain.GetColumnIndex(DefCol.SORT_ORDER)}1 \|\| {?iCurIdx} | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(sPrevious.Equals(string.Empty)) ⟫ else!(sPrevious == sHeaderText) |
| InitializeComponent |  | 1059 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1060 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1061 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1062 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Allo Target | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

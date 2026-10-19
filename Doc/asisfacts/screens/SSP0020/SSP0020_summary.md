# SSP0020 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0020_Delegate.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 958 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0020_Delegate.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 764 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnSave.Click | BtnSave_Click > FindData_Main | 268 | SSP.SSP0020_GET_DELEGATE | MATCH | SP SSP0020_GET_DELEGATE |
| event:btnSave.Click | BtnSave_Click > SaveData | 507 | SSP.SSP0020_SAVE_DELEGATE | MATCH | SP SSP0020_SAVE_DELEGATE |
| event:btnSave.Click | BtnSave_Click > UserName_Search | 781 | SSP.UP_FX_GetSSPUserUseInfoList | MATCH | SP UP_FX_GetSSPUserUseInfoList |
| event:btnUnSet.Click | BtnUnSet_Click > FindData_Main | 268 | SSP.SSP0020_GET_DELEGATE | MATCH | SP SSP0020_GET_DELEGATE |
| event:btnUnSet.Click | BtnUnSet_Click > UnSet | 657 | SSP.SSP0020_SAVE_UNSET | MATCH | SP SSP0020_SAVE_UNSET |
| event:btnUnSet.Click | BtnUnSet_Click > UnSet | 715 | SSP.SSP0020_SAVE_UNSET | MATCH | SP SSP0020_SAVE_UNSET |
| button:FindButton | FindButton > FindData_Main | 268 | SSP.SSP0020_GET_DELEGATE | MATCH | SP SSP0020_GET_DELEGATE |
| event:this.Load | Form_Load > FindData_Main | 268 | SSP.SSP0020_GET_DELEGATE | MATCH | SP SSP0020_GET_DELEGATE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SSP.SSP0020_GET_DELEGATE | MATCH | 1 | SP SSP0020_GET_DELEGATE | EXEC:SSP0020_GET_DELEGATE, DYNAMIC@SSP0020_GET_DELEGATE |  |
| SSP.SSP0020_SAVE_DELEGATE | MATCH | 1 | SP SSP0020_SAVE_DELEGATE | EXEC:SSP0020_SAVE_DELEGATE, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SSP_MST_DELEGATE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0020_SAVE_UNSET | MATCH | 2 | SP SSP0020_SAVE_UNSET | EXEC:SSP0020_SAVE_UNSET, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SSP_MST_DELEGATE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.UP_FX_GetSSPUserUseInfoList | MATCH | 1 | SP UP_FX_GetSSPUserUseInfoList | EXEC:UP_FX_GETSSPUSERUSEINFOLIST, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| InitControls | c | CODE |
| InitControls | dtMyDivision.Rows[i] | CODE, NAME |
| UserName_Search | dsUserList.Tables[0].Rows[0] | UserID, UserName, UserName_E |
| Validation_Check | row | DIVISION_ID, VALID, FROM_DATE, TO_DATE, USER_ID, DELEGATEE_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpread:199, InitSpread:207 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | BtnSave_Click:352 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.chkAll | CheckStateChanged | chkAll_CheckStateChanged | InitializeComponent:298 |
| this | Load | Form_Load | .ctor:104 |
| btnDelegatee | Click | BtnDelegatee_Click | InitEvent:224 |
| btnSave | Click | BtnSave_Click | InitEvent:225 |
| btnUnSet | Click | BtnUnSet_Click | InitEvent:226 |
| spdMain | SheetTabClick | SpdMain_SheetTabClick | InitEvent:228 |
| spdMain | CellClick | SpdMain_CellClick | InitEvent:229 |

## 6. 컨트롤 (30개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | layoutControlItem10, lblDelegatee, layoutControlItem2, layoutControlItem1, layoutControlItem6, layoutControlItem4, lcBtnUnset, lcBtnSave, layoutControlItem3 |
| UsrButton | 5 | usrButton1, btnSave, btnUnSet, btnMeasure, btnDelegatee |
| EmptySpaceItem | 4 | emptySpaceItem2, emptySpaceItem3, emptySpaceItem6, emptySpaceItem4 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrLabel | 1 | usrLabel1 |
| UsrCheckBox | 1 | chkAll |
| CheckedListBoxControl | 1 | clbDivision |
| UsrMultiLineEditor | 1 | txtDelegatee |
| UsrDateRangePicker | 1 | drpPeriod |
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
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 11 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 16 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 13 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 7 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 2 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0020 | Delegate | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_COLUMNS | SSP0020 | Delegated List | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Delegate, Delegated List
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:199, SetSheetHeaderColumn@InitSpread:207

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Delegated List | 216 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK |  |
| InitSpread | Delegated List | 217 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK |  |
| InitSpread | Delegated List | 218 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK |  |
| SpdMain_CellClick |  | 859 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ if(Convert.ToBoolean(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| SpdMain_CellClick |  | 863 | 표시/라벨 변경 | set:Value | Value = {?true} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ else!(Convert.ToBoolean(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| InitializeComponent |  | 667 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 668 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 669 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 670 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Delegate | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| Delegated List | META+코드연결 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

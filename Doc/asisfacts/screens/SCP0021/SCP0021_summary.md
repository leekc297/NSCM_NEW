# SCP0021 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0021_LossTime\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0021_LossTime\SCP0021_LossTime.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0021_LossTime\SCP0021_LossTime.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0021_LossTime\SCP0021_LossTime.csproj | 1467 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0021_LossTime\SCP0021_LossTime.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0021_LossTime\SCP0021_LossTime.csproj | 751 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1257 | biz:CommonData.CommonDataList [code=BuildingByDivision] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1263 | biz:CommonData.CommonDataList [code=LocationGroupByCapa] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 1267 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | 451 | biz:CommonData.CommonDataList [code=LocationGroupByCapa] | BIZ_MATCH |  |
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | 457 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged | 441 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:clbPlantSite.SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | 464 | biz:CommonData.CommonDataList [code=BuildingByDivision] | BIZ_MATCH |  |
| event:clbPlantSite.SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | 468 | biz:CommonData.CommonDataList [code=LocationGroupByCapa] | BIZ_MATCH |  |
| event:clbPlantSite.SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | 475 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 635 | SCP.SCP0021_GET_LOSS_TIME | MATCH | SP SCP0021_GET_LOSS_TIME |
| button:SaveButton | SaveButton > SaveLossTime > FindData_Main | 635 | SCP.SCP0021_GET_LOSS_TIME | MATCH | SP SCP0021_GET_LOSS_TIME |
| button:SaveButton | SaveButton > SaveExcept > FindData_Except | 688 | SCP.SCP0021_GET_LOSS_TIME_EXCEPT | MATCH | SP SCP0021_GET_LOSS_TIME_EXCEPT |
| button:SaveButton | SaveButton > SaveLossTime | 881 | SCP.SCP0021_SAVE_LOSS_TIME | MATCH | SP SCP0021_SAVE_LOSS_TIME |
| button:SaveButton | SaveButton > SaveExcept | 982 | SCP.SCP0021_SAVE_LOSS_TIME_EXCEPT | MATCH | SP SCP0021_SAVE_LOSS_TIME_EXCEPT |
| event:this.btnLoosTimeApply.Click | BtnLoosTimeApply_Click > SaveButton > SaveLossTime > FindData_Main | 635 | SCP.SCP0021_GET_LOSS_TIME | MATCH | SP SCP0021_GET_LOSS_TIME |
| event:this.btnLoosTimeApply.Click | BtnLoosTimeApply_Click > SaveButton > SaveExcept > FindData_Except | 688 | SCP.SCP0021_GET_LOSS_TIME_EXCEPT | MATCH | SP SCP0021_GET_LOSS_TIME_EXCEPT |
| event:this.btnLoosTimeApply.Click | BtnLoosTimeApply_Click > SaveButton > SaveLossTime | 881 | SCP.SCP0021_SAVE_LOSS_TIME | MATCH | SP SCP0021_SAVE_LOSS_TIME |
| event:this.btnLoosTimeApply.Click | BtnLoosTimeApply_Click > SaveButton > SaveExcept | 982 | SCP.SCP0021_SAVE_LOSS_TIME_EXCEPT | MATCH | SP SCP0021_SAVE_LOSS_TIME_EXCEPT |
| event:this.btnSetupLoosTime.Click | BtnSetupLoosTime_Click > SaveButton > SaveLossTime > FindData_Main | 635 | SCP.SCP0021_GET_LOSS_TIME | MATCH | SP SCP0021_GET_LOSS_TIME |
| event:this.btnSetupLoosTime.Click | BtnSetupLoosTime_Click > SaveButton > SaveExcept > FindData_Except | 688 | SCP.SCP0021_GET_LOSS_TIME_EXCEPT | MATCH | SP SCP0021_GET_LOSS_TIME_EXCEPT |
| event:this.btnSetupLoosTime.Click | BtnSetupLoosTime_Click > SaveButton > SaveLossTime | 881 | SCP.SCP0021_SAVE_LOSS_TIME | MATCH | SP SCP0021_SAVE_LOSS_TIME |
| event:this.btnSetupLoosTime.Click | BtnSetupLoosTime_Click > SaveButton > SaveExcept | 982 | SCP.SCP0021_SAVE_LOSS_TIME_EXCEPT | MATCH | SP SCP0021_SAVE_LOSS_TIME_EXCEPT |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1257 | biz:CommonData.CommonDataList [code=BuildingByDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1263 | biz:CommonData.CommonDataList [code=LocationGroupByCapa] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 1267 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Except | 688 | SCP.SCP0021_GET_LOSS_TIME_EXCEPT | MATCH | SP SCP0021_GET_LOSS_TIME_EXCEPT |
| unreached:(진입점 미연결) | <field:dtDivision> | 48 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetDivision | 1395 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=BuildingByDivision] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_FACTORY_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_LINE_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=LocationGroupByCapa] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SCM_MST_OPERATION_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0021_GET_LOSS_TIME | MATCH | 1 | SP SCP0021_GET_LOSS_TIME | EXEC:SCP0021_GET_LOSS_TIME, REF:FN_GET_DIVISION_NAME, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_SITE, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_MST_OPERATION_SN, SELECT:SCP_MST_LOSS_TIME, SELECT:SCP_MST_LOSS_TIME_BIG, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0021_GET_LOSS_TIME_EXCEPT | MATCH | 1 | SP SCP0021_GET_LOSS_TIME_EXCEPT | EXEC:SCP0021_GET_LOSS_TIME_EXCEPT, REF:FN_GET_DIVISION_NAME, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_SITE, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_MST_OPERATION_SN, SELECT:SCP_MST_LOSS_TIME_EXCEPT, REF:STRING_SPLIT, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0021_SAVE_LOSS_TIME | MATCH | 1 | SP SCP0021_SAVE_LOSS_TIME | EXEC:SCP0021_SAVE_LOSS_TIME, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SCP_MST_LOSS_TIME, EXEC:PR_SCP_MST_LOSS_TIME_HIST, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_MST_LOSS_TIME_H |  |
| SCP.SCP0021_SAVE_LOSS_TIME_EXCEPT | MATCH | 1 | SP SCP0021_SAVE_LOSS_TIME_EXCEPT | EXEC:SCP0021_SAVE_LOSS_TIME_EXCEPT, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SCP_MST_LOSS_TIME_EXCEPT, DELETE:SCP_MST_LOSS_TIME_EXCEPT, EXEC:PR_SCP_MST_LOSS_TIME_EXCEPT_HIST, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_MST_LOSS_TIME_EXCEPT_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtDivision> | UserInfoContext.Current | NowGroupID |
| SaveExcept | dtErr.Rows[0] | ERR_MESSAGE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpread:275, InitSpread:333 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetCheckedListValue | ClbOperation_SelectedIndexChanged:435, ClbOperation_SelectedIndexChanged:436, ClbOperation_SelectedIndexChanged:437, ClbOperation_SelectedIndexChanged:438, ClbBuilding_SelectedIndexChanged:446, ClbBuilding_SelectedIndexChanged:447, ClbBuilding_SelectedIndexChanged:454, ClbBuilding_SelectedIndexChanged:455 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:222 |
| this.btnLoosTimeApply | Click | BtnLoosTimeApply_Click | InitEvent:375 |
| this.btnSetupLoosTime | Click | BtnSetupLoosTime_Click | InitEvent:376 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:377 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:379 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:380 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:381 |
| clbOperation | SelectedIndexChanged | ClbOperation_SelectedIndexChanged | InitEvent:382 |
| this.spdMain | EditChange | SpdMain_EditChange | InitEvent:384 |
| this.spdMain | EditModeOff | SpdMain_EditModeOff | InitEvent:385 |
| this.spdExcept | EditChange | SpdExcept_EditChange | InitEvent:387 |
| this.spdExcept | EditModeOff | SpdExcept_EditModeOff | InitEvent:388 |

## 6. 컨트롤 (28개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | Division, layoutControlItem7, layoutControlItem3, layoutControlItem9, layoutControlItem11, layoutControlItem4, layoutControlItem5 |
| EmptySpaceItem | 5 | emptySpaceItem2, emptySpaceItem1, emptySpaceItem3, emptySpaceItem4, emptySpaceItem5 |
| UsrCheckedList | 4 | clbPlantSite, clbBuilding, clbOperation, clbLine |
| UsrButton | 3 | usrButton1, btnLoosTimeApply, btnSetupLoosTime |
| FpSpread | 2 | spdMain, spdExcept |
| SheetView | 2 | spdMain_Sheet1, spdExcept_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCombo | 1 | cboDivision |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| SplitContainer | 1 | splitContainer1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 8 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 46 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 60 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0021 | Loss Time | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |
| SCM_MST_SHEET_COLUMNS | SCP0021 | Loss Time Except | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Loss Time, Loss Time Except
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:275, SetSheetHeaderColumn@InitSpread:333

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Loss Time | 287 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(spdInfo.SheetName == "Loss Time") |
| InitSpread | Loss Time | 288 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(spdInfo.SheetName == "Loss Time") |
| InitSpread | Loss Time | 289 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(spdInfo.SheetName == "Loss Time") |
| InitializeComponent |  | 602 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 603 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 604 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 605 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 653 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 654 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 655 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 656 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Loss Time | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |
| Loss Time Except | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

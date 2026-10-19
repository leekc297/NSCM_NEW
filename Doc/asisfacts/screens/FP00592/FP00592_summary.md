# FP00592 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00592_Initial_Setup_Validation.UIL\FP00592_Initial_Setup_Validation.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00592_Initial_Setup_Validation.UIL\FP00592_Initial_Setup_Validation.UIL.csproj | 452 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00592_Initial_Setup_Validation.UIL\FP00592_Initial_Setup_Validation.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00592_Initial_Setup_Validation.UIL\FP00592_Initial_Setup_Validation.UIL.csproj | 529 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00592_Initial_Setup_Validation.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00592_Initial_Setup_Validation.UIL\FP00592_Initial_Setup_Validation.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00592_Initial_Setup_Validation.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00592_Initial_Setup_Validation.UIL\FP00592_Initial_Setup_Validation.UIL.csproj | 84 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboFactory.SelectedIndexChanged | cboFactory_changed > SetChangeControl | 177 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboFactory.SelectedIndexChanged | cboFactory_changed > SetChangeControl | 177 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboInstance.SelectedIndexChanged | cboInstance_changed > SetChangeControl | 177 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | cboInstance_changed > SetChangeControl | 177 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboPlant.SelectedIndexChanged | cboPlant_changed > SetChangeControl | 177 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboPlant.SelectedIndexChanged | cboPlant_changed > SetChangeControl | 177 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboPlant.SelectedIndexChanged | cboPlant_changed | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboPlant.SelectedIndexChanged | cboPlant_changed | 238 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:cboSite.SelectedIndexChanged | cboSite_changed > SetChangeControl | 177 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | cboSite_changed > SetChangeControl | 177 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > SetChangeControl | 177 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > SetChangeControl | 177 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InsertBaseRow > GoMain | 370 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_InitalSetup] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InsertBaseRow > GoMain | 370 | FP\ADMIN\FP00592_Initial_Setup_Validation#find_InitalSetup | MATCH | [sql] foxquery_sql\FP_Admin_FP00592_Initial_Setup_Validation_find_InitalSetup.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_InitalSetup] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| FP\ADMIN\FP00592_Initial_Setup_Validation#find_InitalSetup | MATCH | 1 | [sql] foxquery_sql\FP_Admin_FP00592_Initial_Setup_Validation_find_InitalSetup.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| FindGoData | Filter | SITE_ID, INSTANCE_ID, PLANT_ID, FACTORY_ID, setup_code |
| Form_Load | Filter | SCREEN_EXCEPTION, USER_ID |
| GoMain | r | setup_code, setup_desc |
| SetChangeControl | Filter | PLANT_ID, FACTORY_ID |
| SpdMain_CellClick | r | setup_desc |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetInnerTable | SetChangeControl:145, SetChangeControl:154, SetChangeControl:161, SetChangeControl:169, SetChangeControl:177 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetCheckedListValue | SetChangeControl:150, SetChangeControl:165, SetChangeControl:176, SetChangeControl:185 | CString.GetCheckedListValue | CODE |
| SetFilter | SetChangeControl:166 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| SetSheetHeaderColumn | InitSpread:209 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:94 |
| spdMain | CellClick | SpdMain_CellClick | InitEvent:219 |
| cboSite | SelectedIndexChanged | cboSite_changed | InitEvent:221 |
| cboInstance | SelectedIndexChanged | cboInstance_changed | InitEvent:222 |
| cboPlant | SelectedIndexChanged | cboPlant_changed | InitEvent:223 |
| cboFactory | SelectedIndexChanged | cboFactory_changed | InitEvent:224 |

## 6. 컨트롤 (20개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| UsrCombo | 4 | cboSite, cboInstance, cboPlant, cboFactory |
| LayoutControlItem | 4 | Site, Division1, Division2, Division3 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| EmptySpaceItem | 2 | emptySpaceItem2, emptySpaceItem3 |
| FpSpread | 2 | spdMain, spdData |
| SheetView | 2 | spdMain_Sheet1, spdData_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| SplitContainer | 1 | splitContainer1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Validation Info, {?r["setup_desc"].ToSafeString()}
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:209

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 388 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 389 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 390 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 391 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 439 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 440 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 441 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 442 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

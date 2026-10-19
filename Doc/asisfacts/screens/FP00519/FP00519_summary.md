# FP00519 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Master.UIL\FP00519_PJT_Status_Production_Type.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 722 |
| only | 06.UIL\GSCM.FP.Master.UIL\FP00519_PJT_Status_Production_Type.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 655 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 177 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 182 | biz:FPCommonDataBLL.FPCommonDataList [code=ITEM_CLASS] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 191 | biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 177 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 182 | biz:FPCommonDataBLL.FPCommonDataList [code=ITEM_CLASS] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 191 | biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Execute | 413 | FP_Master.PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE | MATCH | SP PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Execute | 413 | FP_Master.PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE | MATCH | SP PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Execute | 413 | FP_Master.PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE | MATCH | SP PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Execute | 550 | FP_Master.PR_UI_FP00519_SAVE | MATCH | SP PR_UI_FP00519_SAVE |
| event:this.Load | Form_Load > InitControls | 159 | biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 177 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 182 | biz:FPCommonDataBLL.FPCommonDataList [code=ITEM_CLASS] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 191 | biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=ITEM_CLASS] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE | MATCH | 1 | SP PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE | EXEC:PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP00519_SAVE | MATCH | 1 | SP PR_UI_FP00519_SAVE | EXEC:PR_UI_FP00519_SAVE | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| EditButton | row | EDIT_YN |
| spdMain_CellClick | dRow | DIVISION_ID, CODE, NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangeControl:175, SetChangeControl:180, SetChangeControl:189, Find_Data_Execute:385, Find_Data_Execute:386, Find_Data_Execute:387, Find_Data_Execute:388 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:101 |
| cboInstance | SelectedIndexChanged | CboInstance_SelectedIndexChanged | InitEvent:206 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:207 |
| popSql | OnSql | RunSqlSource | btnSql_Click:301 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:393 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:538 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:539 |

## 6. 컨트롤 (25개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 8 | lblSql, lblTarget, lblInstance, lblDivision, lblItemClassId, lblModel, lblMaterial, lblNickName |
| UsrTextBox | 3 | txtNickName, txtItemId, txtAppliedModel |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCheckedList2 | 2 | clbItemClassId, clbDivision |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCombo | 1 | cboInstance |
| UsrButton | 1 | btnSql |
| CheckEdit | 1 | chkTarget |
| EmptySpaceItem | 1 | emptySpaceItem2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| ImageList | 1 | imgList |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 9 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 3 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00519 | Main | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_COLUMNS | FP00519 | TEST_TargetMultiPopup | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:232

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
| Main | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| TEST_TargetMultiPopup | 메타 정의만, 코드 미참조(미사용 가능) | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

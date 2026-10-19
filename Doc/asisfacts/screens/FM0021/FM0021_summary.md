# FM0021 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Master.UIL\FM0021_Building_BOD.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 970 |
| only | 06.UIL\GSCM.FP.Master.UIL\FM0021_Building_BOD.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 567 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged | 836 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 199 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 208 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Data > Find_Data_BuildingBOD | 555 | FP_Master.PR_UI_FM0021_BUILDING_BOD | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_BuildingBOD | 555 | FP_Master.PR_UI_FM0021_BUILDING_BOD | NOT_IN_FOXQUERY |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_BuildingBOD | 761 | FP_Master.PR_UI_FM0021_BUILDING_BOD | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_BuildingBOD | 555 | FP_Master.PR_UI_FM0021_BUILDING_BOD | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_BuildingBOD | 761 | FP_Master.PR_UI_FM0021_BUILDING_BOD | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > InitControls | 137 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 138 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 142 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 199 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 208 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FM0021_BUILDING_BOD | NOT_IN_FOXQUERY | 2 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | 2 | SP PR_UI_FP_MASTER_FORM_CODE | EXEC:PR_UI_FP_MASTER_FORM_CODE | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:196, SetChangedControl:204, btnImport_Click:425, btnImport_Click:426, btnImport_Click:427, Find_Data_BuildingBOD:544, Find_Data_BuildingBOD:545, Find_Data_BuildingBOD:546 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnImport | Click | btnImport_Click | InitializeComponent:292 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:332 |
| this.spdMain | CellClick | SpdMain_CellClick | InitializeComponent:470 |
| this | Load | Form_Load | .ctor:101 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:224 |
| cboSite | SelectedIndexChanged | ClbSite_SelectedIndexChanged | InitEvent:225 |
| popSql | OnSql | RunSqlSource | btnSql_Click:413 |

## 6. 컨트롤 (18개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 5 | layoutControlItem3, layoutControlItem6, layoutControlItem10, lblSql, layoutControlItem12 |
| UsrCheckedList2 | 3 | cboSite, clbBuilding, clbDivision |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 2 | btnImport, btnSql |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| ImageList | 1 | imageList1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 555 | Find_Data_BuildingBOD | FP_Master.PR_UI_FM0021_BUILDING_BOD | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 761 | Save_Data_BuildingBOD | FP_Master.PR_UI_FM0021_BUILDING_BOD | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: BuildingBOD
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:293

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadInit | 0 | 297 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID |  |
| SetSpreadInit | 0 | 298 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID |  |
| SetSpreadInit | 0 | 299 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PLANT_ID |  |
| SetSpreadInit | 0 | 300 | 표시/라벨 변경 | set:Visible | Visible = {?false} | FACTORY_ID |  |
| SetSpreadInit | 0 | 301 | 표시/라벨 변경 | set:Visible | Visible = {?false} | BOD_ID |  |
| SetSpreadInit | 0 | 302 | 표시/라벨 변경 | set:Visible | Visible = {?false} | FROM_OPERATION_NAME |  |
| SetSpreadInit | 0 | 303 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TO_OPERATION_NAME |  |
| SetSpreadInit | 0 | 304 | 표시/라벨 변경 | set:Visible | Visible = {?false} | BOD_PATTERN_ID |  |
| SetSpreadInit | 0 | 305 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TRANSPORT_MODE |  |
| SetSpreadInit | 0 | 306 | 표시/라벨 변경 | set:Visible | Visible = {?false} | BOD_START_TIME |  |
| SetSpreadInit | 0 | 307 | 표시/라벨 변경 | set:Visible | Visible = {?false} | RELEASE_FLAG |  |
| SetSpreadInit | 0 | 308 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DESCRIPTION |  |
| SetSpreadInit | 0 | 309 | 표시/라벨 변경 | set:Visible | Visible = {?false} | EDIT_YN1 |  |
| SetSpreadInit | 0 | 310 | 표시/라벨 변경 | set:Visible | Visible = {?false} | EDIT_YN2 |  |
| Find_Data | BuildingBOD | 531 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 486 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 487 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 488 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 489 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

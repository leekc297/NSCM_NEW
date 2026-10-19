# SCM0014 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SCM.Validation.UIL\SCM0014_ValidationShipmentResult.cs | 06.UIL\GSCM.SCM.Validation.UIL\GSCM.SCM.Validation.UIL.csproj | 420 |
| only | 06.UIL\GSCM.SCM.Validation.UIL\SCM0014_ValidationShipmentResult.Designer.cs | 06.UIL\GSCM.SCM.Validation.UIL\GSCM.SCM.Validation.UIL.csproj | 687 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > Find_Data | 322 | SCM.SCM0014_GET_VALIDATION_SHIPMENT_RESULT | MATCH | SP SCM0014_GET_VALIDATION_SHIPMENT_RESULT |
| event:this.Load | Form_Load > InitControls | 155 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDayRange | 165 | SCM.GET_DATE_RANGE_YESTERDAY_BEFORE_1MONTH | MATCH | [statement] foxquery_sql\SCM.GET_DATE_RANGE_YESTERDAY_BEFORE_1MONTH.sql |
| unreached:(진입점 미연결) | <field:dtDivision> | 38 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| SCM.GET_DATE_RANGE_YESTERDAY_BEFORE_1MONTH | MATCH | 1 | [statement] foxquery_sql\SCM.GET_DATE_RANGE_YESTERDAY_BEFORE_1MONTH.sql | REF:FN_MULTY_TIME |  |
| SCM.SCM0014_GET_VALIDATION_SHIPMENT_RESULT | MATCH | 1 | SP SCM0014_GET_VALIDATION_SHIPMENT_RESULT | EXEC:SCM0014_GET_VALIDATION_SHIPMENT_RESULT, REF:FN_GET_SHIPMENT_NO_DISPLAY, SELECT:SCM_MST_ITEM_SN, REF:FN_GET_ITEM_OPERATION_GROUP, SELECT:SCM_DNM_INTRANSIT_C, SELECT:SCP_MST_BOD_N_V, REF:STRING_SPLIT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtDivision> | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:174, Find_Data:301 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread_2:203 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:123 |
| this.btnProjectID | Click | BtnProject_Click | InitEvent:137 |
| this.btnItemId | Click | BtnItemId_Click | InitEvent:138 |
| this.cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:139 |

## 6. 컨트롤 (28개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | lblProject, lblModel, layoutControlItem3, lblCombo, layoutControlItem2, layoutControlItem1, layoutControlItem5, layoutControlItem6, layoutControlItem4 |
| EmptySpaceItem | 3 | emptySpaceItem2, emptySpaceItem3, emptySpaceItem1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 2 | cboDivision, cboResultType |
| UsrButton | 2 | btnItemId, btnProjectID |
| UsrMultiLineEditor | 2 | txtProject, txtItemId |
| TextBox | 2 | txtPlantSite, txtSaleSite |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePicker3 | 1 | dCalendar |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 2 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 7 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 25 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 45 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 34 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCM0014 | Validation Shipment Rsult | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Validation Shipment Rsult
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread_2:203

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Validation Shipment Rsult | 220 | 하드코딩 | AddDateColumn | Result Date | result_date |  |
| InitSpread | Validation Shipment Rsult | 221 | 하드코딩 | AddTextColumn | Result Type | result_type |  |
| InitSpread | Validation Shipment Rsult | 222 | 하드코딩 | AddTextColumn | Division | division_id |  |
| InitSpread | Validation Shipment Rsult | 223 | 하드코딩 | AddTextColumn | Shipment No | shipment_no |  |
| InitSpread | Validation Shipment Rsult | 224 | 하드코딩 | AddTextColumn | Project Code | project_code |  |
| InitSpread | Validation Shipment Rsult | 225 | 하드코딩 | AddTextColumn | Model | item_id |  |
| InitSpread | Validation Shipment Rsult | 226 | 하드코딩 | AddTextColumn | Plant | plant |  |
| InitSpread | Validation Shipment Rsult | 227 | 하드코딩 | AddTextColumn | Trans Mode | Trans_Mode |  |
| InitSpread | Validation Shipment Rsult | 228 | 하드코딩 | AddTextColumn | Operation Group | operation_group |  |
| InitSpread | Validation Shipment Rsult | 229 | 하드코딩 | AddNumColumn | Delivery_Qty | delivery_qty |  |
| InitSpread | Validation Shipment Rsult | 230 | 하드코딩 | AddTextColumn | Sold-To | customer_code |  |
| InitSpread | Validation Shipment Rsult | 231 | 하드코딩 | AddTextColumn | Ship-To | shipto_code |  |
| InitSpread | Validation Shipment Rsult | 232 | 하드코딩 | AddTextColumn | Incoterms | incoterms |  |
| InitSpread | Validation Shipment Rsult | 233 | 하드코딩 | AddTextColumn | Plant Site | from_scm_site_id |  |
| InitSpread | Validation Shipment Rsult | 234 | 하드코딩 | AddTextColumn | Sales Site | to_scm_site_id |  |
| InitSpread | Validation Shipment Rsult | 235 | 하드코딩 | AddTextColumn | BOD | bod_lead_time |  |
| InitSpread | Validation Shipment Rsult | 236 | 하드코딩 | AddDateColumn | Plant Isuue Date | plant_issue_date |  |
| InitSpread | Validation Shipment Rsult | 237 | 하드코딩 | AddDateColumn | POL Date | pol_atd_date |  |
| InitSpread | Validation Shipment Rsult | 238 | 하드코딩 | AddDateColumn | POD Date | pod_ata_date |  |
| InitSpread | Validation Shipment Rsult | 239 | 하드코딩 | AddDateColumn | F.Dest Date | f_dest_ata_date |  |
| InitSpread | Validation Shipment Rsult | 240 | 하드코딩 | AddDateColumn | POD Date (ETA) | pod_eta_date |  |
| InitSpread | Validation Shipment Rsult | 241 | 하드코딩 | AddDateColumn | F.Dest Date (ETA) | f_dest_eta_date |  |
| InitializeComponent |  | 590 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 591 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 592 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 593 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Validation Shipment Rsult | META+코드연결 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

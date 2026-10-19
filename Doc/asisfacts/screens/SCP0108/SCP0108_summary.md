# SCP0108 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0108_CAPA_LOB_Report\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0108_CAPA_LOB_Report\SCP0108_CAPA_LOB_Report.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0108_CAPA_LOB_Report\SCP0108_CAPA_LOB_Report.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0108_CAPA_LOB_Report\SCP0108_CAPA_LOB_Report.csproj | 1626 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0108_CAPA_LOB_Report\SCP0108_CAPA_LOB_Report.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0108_CAPA_LOB_Report\SCP0108_CAPA_LOB_Report.csproj | 1119 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:this.btnColumn.Click | btnColumn_Click > BeforeFindData > RefreshSheetHeader > GetSpdTitle | 1179 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > BeforeFindData > RefreshSheetHeader > GetSpdTitle | 1179 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.cboVersion.SelectedIndexChanged | cboVersion_SelectedIndexChanged > BeforeFindData > RefreshSheetHeader > GetSpdTitle | 1179 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.cboVersionSeq.SelectedIndexChanged | cboVersionSeq_SelectedIndexChanged > BeforeFindData > RefreshSheetHeader > GetSpdTitle | 1179 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitDatasAll > RefreshBottleneck | 882 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > RefreshSheetHeader > GetSpdTitle | 1179 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.rgrpDivisionType.SelectedIndexChanged | rgrpDivisionType_SelectedIndexChanged > BeforeFindData > RefreshSheetHeader > GetSpdTitle | 1179 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 69 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCP.SCP0104_GET_SPREAD_TITLE | MATCH | 1 | SP SCP0104_GET_SPREAD_TITLE | EXEC:SCP0104_GET_SPREAD_TITLE, REF:FN_SCP0104_GET_SPREAD_TITLE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| GetCurrVersionProgessStatus | dtProgressStatusCurr.Rows[0] | PROG_STAT |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValueNone | getDivision:198, getSite:410, getPlant:448, getFactory:472, getLine:496, getOperation:520, getElectrodeType:568 | CString.GetCheckedListValueNone | CODE |
| DataBind | RefreshBottleneck:882 | UsrComboBox.DataBind | CODE, NAME |
| GetSpdTitle | RefreshSheetHeader:1211 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumnSCP | RefreshSheetHeader:1213 | SpreadInfo.SetSheetHeaderColumnSCP | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| Init | ShowItem:1588 | LookupService.Init | USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:208 |
| this | Load | Form_Load | .ctor:860 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:1236 |
| this.cboVersion | SelectedIndexChanged | cboVersion_SelectedIndexChanged | InitEvent:1237 |
| this.cboVersionSeq | SelectedIndexChanged | cboVersionSeq_SelectedIndexChanged | InitEvent:1238 |
| this.clbSite | SelectedIndexChanged | clbSite_SelectedIndexChanged | InitEvent:1239 |
| this.clbPlant | SelectedIndexChanged | clbPlant_SelectedIndexChanged | InitEvent:1240 |
| this.clbFactory | SelectedIndexChanged | clbFactory_SelectedIndexChanged | InitEvent:1241 |
| this.clbLine | SelectedIndexChanged | clbLine_SelectedIndexChanged | InitEvent:1242 |
| this.clbOperation | SelectedIndexChanged | clbOperation_SelectedIndexChanged | InitEvent:1243 |
| this.rgrpDivisionType | SelectedIndexChanged | rgrpDivisionType_SelectedIndexChanged | InitEvent:1245 |
| this.spdMain | TopChange | spdMain_TopChange | InitEvent:1247 |
| this.btnItemId | Click | btnItem_Click | InitEvent:1249 |

## 6. 컨트롤 (43개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 16 | Division, Division1, lciOperation, layoutControlItem8, lciElectrodeType, layoutControlItem4, layoutControlItem11, layoutControlItem10, Division3, VersionSeq, layoutControlItem2, PlanType, lciDivisionType, layoutControlItem6, layoutControlItem9 … |
| UsrCheckedList | 6 | clbLine, clbOperation, clbFactory, clbPlant, clbElectrodeType, clbSite |
| UsrCombo | 4 | cboDivision, cboVersion, cboVersionSeq, cboProgressStatus |
| EmptySpaceItem | 3 | emptySpaceItem4, emptySpaceItem1, emptySpaceItem2 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 2 | btnColumn, btnItemId |
| TextBox | 2 | txtItem, txtPlanType |
| ImageList | 1 | imageList1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrComboBox | 1 | cboBottleneck |
| RadioGroup | 1 | rgrpDivisionType |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 12 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 44 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 62 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 3 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0108 | CURRENT | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |
| SCM_MST_SHEET_COLUMNS | SCP0108 | CUTOFF | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |
| SCM_MST_SHEET_COLUMNS | SCP0108 | MAIN | · | · | · | · | · | · | · | · | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 42개 시트×division 비교, 차이 1260건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: CURRENT, CUTOFF
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumnSCP@RefreshSheetHeader:1213

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| ChangeColumnNameToCodeName |  | 890 | 표시/라벨 변경 | set:ColumnName | ColumnName = CODE |  | if(tbl.Columns.Contains(codeColumnName)) |
| ChangeColumnNameToCodeName |  | 895 | 표시/라벨 변경 | set:ColumnName | ColumnName = NAME |  | if(tbl.Columns.Contains(nameColumnName)) |
| SetVisibleSheetColumns |  | 1347 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, 0)} |  |  |
| InitializeComponent |  | 998 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 999 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1000 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1001 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| CURRENT | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |
| CUTOFF | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |
| MAIN | 메타 정의만, 코드 미참조(미사용 가능) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

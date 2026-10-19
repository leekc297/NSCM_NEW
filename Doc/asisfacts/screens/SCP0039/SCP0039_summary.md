# SCP0039 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0039_ValidationMaster\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0039_ValidationMaster\SCP0039_ValidationMaster.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0039_ValidationMaster\SCP0039_ValidationMaster.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0039_ValidationMaster\SCP0039_ValidationMaster.csproj | 1376 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0039_ValidationMaster\SCP0039_ValidationMaster.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0039_ValidationMaster\SCP0039_ValidationMaster.csproj | 616 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnSearch.Click | BtnSearch_Click > FindDataAll | 556 | {?arg:pProcedureNm} | UNRESOLVED |  |
| event:btnSearch.Click | BtnSearch_Click > FindDataAll > FindData | 623 | {p:pProcedureNm} | TEMPLATE |  |
| button:FindButton | FindButton > FindDataAll | 556 | {?arg:pProcedureNm} | UNRESOLVED |  |
| button:FindButton | FindButton > FindDataAll > FindData | 623 | {p:pProcedureNm} | TEMPLATE |  |
| event:spdMain.CellClick | SpdMain_CellClick > FindData | 623 | {p:pProcedureNm} | TEMPLATE |  |
| event:spdMain.CellClick | SpdMain_CellClick | 990 | {?arg:pProcedureNm} | UNRESOLVED |  |
| event:spdMain.CellClick | SpdMain_CellClick > GoPage | 1144 | MenuContainer.UP_FX_GetGSCMAuthenticationMenuList | MATCH | SP UP_FX_GetGSCMAuthenticationMenuList |
| unreached:(진입점 미연결) | GetSearchInfo | 248 | SCP.SCP0121_GET_SEARCH_INFO | MATCH | SP SCP0121_GET_SEARCH_INFO |
| unreached:(진입점 미연결) | getLookupMasterValidation | 520 | SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL | MATCH | SP SCM0003_GET_LOOKUP_MASTER_DETAIL |
| unreached:(진입점 미연결) | SetCalendar | 1238 | biz:CommonData.CommonDataList [code=PERIOD_DEFAULT] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetCalendar | 1255 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?arg:pProcedureNm} | UNRESOLVED | 2 |  |  |  |
| {p:pProcedureNm} | TEMPLATE | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_SYS_CALENDAR_M |
| biz:CommonData.CommonDataList [code=PERIOD_DEFAULT] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_SYS_CALENDAR_M, UP_FX_GetCommonDataList:REF:FN_MULTY_TIME |
| MenuContainer.UP_FX_GetGSCMAuthenticationMenuList | MATCH | 1 | SP UP_FX_GetGSCMAuthenticationMenuList | EXEC:UP_FX_GETGSCMAUTHENTICATIONMENULIST, SELECT:TB_FX_MENUITEMINFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_GROUPMENUAUTH, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:MENUCTE1, SELECT:TB_FX_PROGRAMINFO |  |
| SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL | MATCH | 1 | SP SCM0003_GET_LOOKUP_MASTER_DETAIL | EXEC:SCM0003_GET_LOOKUP_MASTER_DETAIL, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0121_GET_SEARCH_INFO | MATCH | 1 | SP SCP0121_GET_SEARCH_INFO | EXEC:SCP0121_GET_SEARCH_INFO, INSERT:#DIVISION_INFO, SELECT:SCM_MST_DIVISION, INSERT:#LINE_MASTER, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#OSP_PLANT_INFO, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, SELECT:#LINE_MASTER, SELECT:#DIVISION_INFO, SELECT:SCP_MST_CAPA_LINE, SELECT:#OSP_PLANT_INFO, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_OPERATION_M_SN |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InsertBaseRow | dtMasterValidation.Rows[i] | VALID_YN, SEGMENT2, ATTRIBUTE3, SEGMENT4, SEGMENT5, ATTRIBUTE1, ATTRIBUTE2 |
| InsertBaseRow | dr | VALIDATION_TYPE, COUNT, IMPACT, SHEET_NAME, PROGRAM_ID, PROCEDURE_NAME, CONSTRAINTS01 |
| SetCalendar | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpread:383, InitSpread:427 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetCheckedListValue | RefreshPlanGroupByDivision:452, FindDataAll:544, FindData:609, FindData:629 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnItemId | Click | btnItemId_Click_1 | InitializeComponent:274 |
| this | Load | Form_Load | .ctor:146 |
| this | Load | Form_Load | .ctor:161 |
| spdMain | CellClick | SpdMain_CellClick | InitEvent:437 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:444 |
| clbPlanGroup | SelectedIndexChanged | ClbPlanGroup_SelectedIndexChanged | InitEvent:445 |
| btnSearch | Click | BtnSearch_Click | InitEvent:446 |
| this | FormClosing | SCP0039_ValidationMaster_FormClosing | InitEvent:447 |

## 6. 컨트롤 (23개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 5 | Division, lciPlanGroup, lblModel, lciBtnItem, lciBtnSearch |
| EmptySpaceItem | 3 | emptySpaceItem2, emptySpaceItem3, emptySpaceItem1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 2 | btnItemId, btnSearch |
| FpSpread | 2 | spdMain, spdProjectRouteInfo |
| SheetView | 2 | spdMain_Sheet1, spdUserInfo_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCombo | 1 | cboDivision |
| UsrCheckedList2 | 1 | clbPlanGroup |
| UsrMultiLineEditor | 1 | txtItemId |
| SplitContainer | 1 | splitContainer1 |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 556 | FindDataAll | {?arg:pProcedureNm} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 990 | SpdMain_CellClick | {?arg:pProcedureNm} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 1270 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 183 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 13 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 9 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 10 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0039 | BOD | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | SCP0039 | BOD / BOD Item | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | BOM | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | Capa : Line Assign | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | Capa : Tact Time | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | CAPA : Yield (Formation) | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | INTRANSIT INVENTORY | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | Line Assign | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | Outsourcing Capacity [40] | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | PJT ROUTE (ELEC) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | SCP0039 | Plan Group | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | Project Route | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | Project Route (Elec) | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | Stock OSP | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | Tact Time | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | Tact Time(OSP) [82] | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | SCP0039 | Validation Info | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Validation Info, {?siMain.GetValue(nRow, siMain.GetColumnIndex(DefColumns.VALIDATION_TYPE))}
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:383, SetSheetHeaderColumn@InitSpread:427

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetVisibleSheetColumns |  | 463 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | if(!this.IsPopup) |
| SetVisibleSheetColumns |  | 464 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | if(!this.IsPopup) |
| SetVisibleSheetColumns |  | 465 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | if(!this.IsPopup) |
| SetVisibleSheetColumns |  | 469 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | else!(!this.IsPopup) |
| SetVisibleSheetColumns |  | 470 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | else!(!this.IsPopup) |
| SetVisibleSheetColumns |  | 471 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} |  | else!(!this.IsPopup) |
| SetCalendar |  | 1264 | DB루프 | AddNumColumn | {?a.Field<string>(DefColumns.YYYYMM_NAME)} | {?a.Field<string>(DefColumns.YYYYMM)} | foreach(a in dtCalendar.AsEnumerable()) |
| InitializeComponent |  | 424 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 425 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 426 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 427 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 475 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 476 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 477 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 478 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| BOD | 메타 정의만, 코드 미참조(미사용 가능) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| BOD / BOD Item | 메타 정의만, 코드 미참조(미사용 가능) | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| BOM | 메타 정의만, 코드 미참조(미사용 가능) | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| Capa : Line Assign | 메타 정의만, 코드 미참조(미사용 가능) | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| Capa : Tact Time | 메타 정의만, 코드 미참조(미사용 가능) | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| CAPA : Yield (Formation) | 메타 정의만, 코드 미참조(미사용 가능) | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
| INTRANSIT INVENTORY | 메타 정의만, 코드 미참조(미사용 가능) | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |
| Line Assign | 메타 정의만, 코드 미참조(미사용 가능) | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |
| Outsourcing Capacity [40] | 메타 정의만, 코드 미참조(미사용 가능) | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| PJT ROUTE (ELEC) | 메타 정의만, 코드 미참조(미사용 가능) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| Plan Group | 메타 정의만, 코드 미참조(미사용 가능) | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |
| Project Route | 메타 정의만, 코드 미참조(미사용 가능) | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| Project Route (Elec) | 메타 정의만, 코드 미참조(미사용 가능) | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| Stock OSP | 메타 정의만, 코드 미참조(미사용 가능) | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| Tact Time | 메타 정의만, 코드 미참조(미사용 가능) | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |
| Tact Time(OSP) [82] | 메타 정의만, 코드 미참조(미사용 가능) | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| Validation Info | META+코드연결 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

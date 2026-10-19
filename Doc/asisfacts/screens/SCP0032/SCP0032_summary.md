# SCP0032 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SCM.Validation.UIL\SCP0032_Unplan_List.cs | 06.UIL\GSCM.SCM.Validation.UIL\GSCM.SCM.Validation.UIL.csproj | 454 |
| only | 06.UIL\GSCM.SCM.Validation.UIL\SCP0032_Unplan_List.Designer.cs | 06.UIL\GSCM.SCM.Validation.UIL\GSCM.SCM.Validation.UIL.csproj | 522 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 140 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 145 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 150 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 160 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 177 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 337 | SCP.SCP0032_GET_UNPLAN_LIST | MATCH | SP SCP0032_GET_UNPLAN_LIST |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 140 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 145 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 150 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtMyDivision> | 38 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:REF:FN_CHAR_TO_DATE, UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| SCP.SCP0032_GET_UNPLAN_LIST | MATCH | 1 | SP SCP0032_GET_UNPLAN_LIST | EXEC:SCP0032_GET_UNPLAN_LIST, SELECT:SCP_PLAN_VERSION_V, CREATE:#TBLDYNAMIC_SCP0032_PREFER_DEMAND, CREATE:#TBLDYNAMIC_SCP0032_PREFER_PRODUCT, CREATE:#TBLDYNAMIC_SCP0032_BOM, INSERT:#TBLDYNAMIC_SCP0032_DIV, SELECT:SCM_MST_SITE, SELECT:TH_ENG_PLAN_BOM, SELECT:TH_ENG_ITEM, SELECT:TH_EXP_PROBLEM_REPORT, SELECT:TH_ENG_NET_DEMAND, SELECT:TH_ENG_SALES_PRODUCT_MAP, INSERT:#TBLDYNAMIC_SCP0032_BOM, SELECT:W_NO_BOM_QUERY, SELECT:TH_ENG_DEMAND_ATTRIBUTE, SELECT:#TBLDYNAMIC_SCP0032_BOM, SELECT:TH_ENG_OP_RES_GROUP_MAP, SELECT:TH_ENG_RESOURCE, INSERT:#TBLDYNAMIC_SCP0032_PREFER_DEMAND, REF:FN_GETIDXDATALIKESPLIT, SELECT:COPYT, INSERT:#TBLDYNAMIC_SCP0032_PREFER_BOM, SELECT:#TBLDYNAMIC_SCP0032_PREFER_DEMAND, SELECT:#TBLDYNAMIC_SCP0032_DIV, SELECT:#TBLDYNAMIC_SCP0032_PREFER_BOM, SELECT:TH_EXP_PROBLEM_DATA, INSERT:#TBLDYNAMIC_SCP0032_PREFER_PRODUCT, REF:FN_SPLIT, SELECT:TH_ENG_ITEM_ROUTE_SITE, SELECT:#TBLDYNAMIC_SCP0032_PREFER_PRODUCT, SELECT:W_DEMAND_BOD, SELECT:TH_ENG_BOD, SELECT:TH_ENG_ITEM_BOD, SELECT:TH_ENG_SITE, INSERT:#TBLDYNAMIC_SCP0032_BOM_LIST, SELECT:W_BOM_LIST, INSERT:#TBLDYNAMIC_SCP0032_ELECTRONODE_PAIR_ITEM, SELECT:W_ELECTRONODE_PAIR_ITEM, SELECT:#TBLDYNAMIC_SCP0032_BOM_LIST, SELECT:#TBLDYNAMIC_SCP0032_ELECTRONODE_PAIR_ITEM, INSERT:#TBLDYNAMIC_SCP0032_BOM_LIST_9, INSERT:#TBLDYNAMIC_SCP0032_ELECTRONODE_PAIR_ITEM_PREFER, SELECT:W_ELECTRONODE_PAIR_ITEM_PREFER, SELECT:#TBLDYNAMIC_SCP0032_BOM_LIST_9, SELECT:#TBLDYNAMIC_SCP0032_ELECTRONODE_PAIR_ITEM_PREFER, INSERT:#TBLDYNAMIC_SCP0032_DEMAND_BOD, SELECT:TH_EXP_PROBLEM_REPORT_ORG, INSERT:#TBLDYNAMIC_SCP0032_ITEM_BOD_CAL, SELECT:TH_ENG_ITEM_BOD_CAL, SELECT:TH_ENG_PLAN_INFO, INSERT:#TBLDYNAMIC_SCP0032_NO_BOD_CAL, SELECT:#TBLDYNAMIC_SCP0032_DEMAND_BOD, SELECT:#TBLDYNAMIC_SCP0032_ITEM_BOD_CAL, SELECT:#TBLDYNAMIC_SCP0032_NO_BOD_CAL, SELECT:W_1_DEMAND_RESOURCE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:136, SetChangedControl:144, SetChangedControl:149, CboPlanDate_SelectedIndexChanged:157, CboPlanDate_SelectedIndexChanged:158, CboPlanType_SelectedIndexChanged:173, CboPlanType_SelectedIndexChanged:174, CboPlanType_SelectedIndexChanged:175 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:271 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:83 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:100 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:101 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:102 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:103 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:105 |
| spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:107 |

## 6. 컨트롤 (21개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 5 | Division, PlanDate, PlanType, SEQ, layoutControlItem10 |
| UsrCombo | 4 | cboDivision, cboPlanSeq, cboPlanDate, cboPlanType |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel2 |
| UsrLayoutControl | 2 | usrLayoutControl2, usrLayoutControl3 |
| LayoutControlGroup | 2 | layoutControlGroup2, layoutControlGroup3 |
| ImageList | 1 | imageList1 |
| EmptySpaceItem | 1 | emptySpaceItem3 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| Panel | 1 | panel1 |
| UsrLabel | 1 | usrLabel2 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 26 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 61 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 8 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0032 | 1. NO BOM | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 |
| SCM_MST_SHEET_COLUMNS | SCP0032 | 10. PREFER NO BOD CAL | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 |
| SCM_MST_SHEET_COLUMNS | SCP0032 | 11. NO RESOURCE | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | SCP0032 | 12. PREFER NO RESOURCE | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | SCP0032 | 13. PAST DUE | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |
| SCM_MST_SHEET_COLUMNS | SCP0032 | 14. OUT OF HORIZON | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |
| SCM_MST_SHEET_COLUMNS | SCP0032 | 2. PREFER NO BOM | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | SCP0032 | 3. NO ITEM | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 |
| SCM_MST_SHEET_COLUMNS | SCP0032 | 4. PREFER NO PRODUCT | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | SCP0032 | 5. PREFER NO SITE | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | SCP0032 | 6. NO BOD | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | SCP0032 | 7. NO BOD (ELECTRODE PAIR) | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 |
| SCM_MST_SHEET_COLUMNS | SCP0032 | 8. PREFER NO BOD | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |
| SCM_MST_SHEET_COLUMNS | SCP0032 | 9. PREFER NO BOD (ELECTRODE PAIR) | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: 1. NO BOM, 2. PREFER NO BOM, 3. NO ITEM, 4. PREFER NO PRODUCT, 5. PREFER NO SITE, 6. NO BOD, 7. NO BOD (ELECTRODE PAIR), 8. PREFER NO BOD, 9. PREFER NO BOD (ELECTRODE PAIR), 10. PREFER NO BOD CAL, 11. NO RESOURCE, 12. PREFER NO RESOURCE, 13. PAST DUE, 14. OUT OF HORIZON
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:271

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 360 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 361 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 362 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 363 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1. NO BOM | META+코드연결 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |
| 10. PREFER NO BOD CAL | META+코드연결 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 |
| 11. NO RESOURCE | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| 12. PREFER NO RESOURCE | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| 13. PAST DUE | META+코드연결 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |
| 14. OUT OF HORIZON | META+코드연결 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |
| 2. PREFER NO BOM | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| 3. NO ITEM | META+코드연결 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |
| 4. PREFER NO PRODUCT | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| 5. PREFER NO SITE | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| 6. NO BOD | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| 7. NO BOD (ELECTRODE PAIR) | META+코드연결 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |
| 8. PREFER NO BOD | META+코드연결 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| 9. PREFER NO BOD (ELECTRODE PAIR) | META+코드연결 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

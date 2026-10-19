# SCP0063 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0063_PSI_JV\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0063_PSI_JV\SCP0063_PSI_JV.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0063_PSI_JV\SCP0063_PSI_JV.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0063_PSI_JV\SCP0063_PSI_JV.csproj | 1815 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0063_PSI_JV\SCP0063_PSI_JV.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0063_PSI_JV\SCP0063_PSI_JV.csproj | 1001 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 696 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 700 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 722 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 726 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 733 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:cboOperGroup.SelectedIndexChanged | CboOperGroup_SelectedIndexChanged | 502 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboOperGroup.SelectedIndexChanged | CboOperGroup_SelectedIndexChanged | 506 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | 1705 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:cboPlanType.SelectedIndexChanged | CboPlanType_SelectedIndexChanged | 1719 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 292 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 1088 | SCP.SCP0012_GET_PSI | MATCH | SP SCP0012_GET_PSI |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 1763 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls | 193 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 196 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetBucketType | 214 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 292 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData_Division > SetChangedControl | 696 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData_Division > SetChangedControl | 700 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData_Division > SetChangedControl | 722 | biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData_Division > SetChangedControl | 726 | biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData_Division > SetChangedControl | 733 | biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 1763 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > FindData_Division | 1789 | SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | SP UP_FX_GetUserGroupAuthExtentionList |
| unreached:(진입점 미연결) | GetFromSiteByDivision | 227 | SCM.SCM0001_GET_FROM_SITE | MATCH | SP SCM0001_GET_FROM_SITE |
| unreached:(진입점 미연결) | GetLastPlanVersion | 765 | SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | SP SCP0011_GET_LAST_PLAN_VERSION |
| unreached:(진입점 미연결) | FindData_Main_Parallel | 894 | SCP.SCP0012_GET_PSI_QTY | MATCH | SP SCP0012_GET_PSI_QTY |
| unreached:(진입점 미연결) | FindData_Main_Parallel | 930 | SCP.SCP0012_GET_PSI_PARAL | MATCH | SP SCP0012_GET_PSI_PARAL |
| unreached:(진입점 미연결) | SetChangedPeriod | 1741 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 1745 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PlanDate] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:REF:FN_CHAR_TO_DATE, UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlanSeq] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlanType] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_PLAN_VERSION_V |
| biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_COLUMNS |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_FROM_SITE | MATCH | 1 | SP SCM0001_GET_FROM_SITE | EXEC:SCM0001_GET_FROM_SITE, SELECT:SCM_MST_SITE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0011_GET_LAST_PLAN_VERSION | MATCH | 1 | SP SCP0011_GET_LAST_PLAN_VERSION | EXEC:SCP0011_GET_LAST_PLAN_VERSION, REF:FN_GET_SCP_LAST_PLAN_VERSION_ID, REF:FN_SCM_SPLIT, SELECT:SCP_PLAN_VERSION_V |  |
| SCP.SCP0012_GET_PSI | MATCH | 1 | SP SCP0012_GET_PSI | EXEC:SCP0012_GET_PSI, SELECT:SCM_SYS_CALENDAR_M, CREATE:#TBLDYNAMICPIVOT_SCP0012, INSERT:#BOH, SELECT:SCP_PLN_PLANT_ONHAND, REF:STRING_SPLIT, DYNAMIC@SCP0012_GET_PSI, CREATE:#TBLDYNAMICPIVOT_SCP0012_02, INSERT:#TMP_CELLPRODUCT_INFO, SELECT:SCP_MST_CELL_PROD_ASSY_MAP, SELECT:SCP_MST_FINAL_ITEM, INSERT:#TBLDYNAMICPIVOT_SCP0012_02_FINAL, SELECT:#TBLDYNAMICPIVOT_SCP0012_02, SELECT:SCM_MST_SITE, SELECT:#TMP_CELLPRODUCT_INFO |  |
| SCP.SCP0012_GET_PSI_PARAL | MATCH | 1 | SP SCP0012_GET_PSI_PARAL | EXEC:SCP0012_GET_PSI_PARAL | ⚠ DB에 SP 없음 |
| SCP.SCP0012_GET_PSI_QTY | MATCH | 1 | SP SCP0012_GET_PSI_QTY | EXEC:SCP0012_GET_PSI_QTY | ⚠ DB에 SP 없음 |
| SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | 1 | SP UP_FX_GetUserGroupAuthExtentionList | EXEC:UP_FX_GETUSERGROUPAUTHEXTENTIONLIST, SELECT:SCM_MST_DIVISION, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_VENDOR, SELECT:SCM_MST_SITE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| AddSubSum | dt.Rows[iRow] | PSI_TYPE |
| FindButton | clbFromSite.DataSource.Rows[i] | CODE |
| FindData_Division | ds.Tables[0].Rows[i] | Code, JV_PLANT_ID |
| GetLastPlanVersion | dsBinding.Tables[0].Rows[0] | PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitSpread_2:248, InitSpread:303, CboOperGroup_SelectedIndexChanged:463, CboOperGroup_SelectedIndexChanged:464, SetChangedControl:659, SetChangedControl:660, SetChangedControl:725, SetChangedControl:732 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread_2:252, InitSpread:301, InitSpread:349 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread_2:254 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread_2:256, InitSpread:352 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:152 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:445 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:447 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:448 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:450 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:451 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:453 |
| cboOperGroup | SelectedIndexChanged | CboOperGroup_SelectedIndexChanged | InitEvent:454 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:455 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | InitEvent:456 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | InitEvent:457 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:755 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:756 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:757 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | GetLastPlanVersion:793 |
| cboPlanType | SelectedIndexChanged | CboPlanType_SelectedIndexChanged | GetLastPlanVersion:794 |
| cboPlanSeq | SelectedIndexChanged | CboPlanSeq_SelectedIndexChanged | GetLastPlanVersion:795 |

## 6. 컨트롤 (35개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 13 | PlanDate, layoutControlItem3, lblItemId, layoutControlItem2, lblFromSite, lblCombo1, PlanType, SEQ, layoutControlItem6, layoutControlItem4, lblBucket, layoutControlItem1, lcCellTypeGr |
| UsrCombo | 6 | cboPlanSeq, cboPlanDate, cboPlanType, cboOperGroup, cboDivision, cboBucketType |
| UsrButton | 3 | usrButton1, btnItemId, usrButton2 |
| UsrCheckedList | 3 | clbFromSite, clbElecType, cboCellTypeGr |
| EmptySpaceItem | 2 | emptySpaceItem2, emptySpaceItem1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrCheckBox | 1 | chkSum |
| UsrMultiLineEditor | 1 | txtItemId |
| UsrDateRangePicker | 1 | drpPeriod |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 19 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 3 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 802 | SCP.SCP0011_GET_LAST_PLAN_VERSION | commented:MATCH |
| 963 | SCP.SCP0012_GET_PSI | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0063 | PSI | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |
| SCM_MST_SHEET_MEASURE | SCP0063 | CELL | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 |
| SCM_MST_SHEET_MEASURE | SCP0063 | ELECTRODE | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 |
| SCM_MST_SHEET_MEASURE | SCP0063 | PACK | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: PSI
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread_2:254
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_2 |  | 266 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_FROM_DIVISION_ID | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 267 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 268 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_TO_DIVISION_ID | if(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 271 | 표시/라벨 변경 | set:Visible | Visible = {?true} | CELL_TYPE_GROUP_CODE | if(!division.Substring(0, 2).Equals("EE")) ⟫ if(division == "40") |
| InitSpread_2 |  | 273 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CELL_TYPE_GROUP_CODE | if(!division.Substring(0, 2).Equals("EE")) ⟫ else!(division == "40") |
| InitSpread_2 |  | 278 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_FROM_DIVISION_ID | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 279 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 280 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_TO_DIVISION_ID | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread_2 |  | 281 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CELL_TYPE_GROUP_CODE | else!(!division.Substring(0, 2).Equals("EE")) |
| InitSpread | PSI | 311 | 하드코딩 | AddTextColumn | Division | DIVISION_ID |  |
| InitSpread | PSI | 312 | 하드코딩 | AddTextColumn | Operation Group | OPERATION_GROUP_DESC |  |
| InitSpread | PSI | 313 | 하드코딩 | AddTextColumn | From Site | SITE_DESCRIPTION |  |
| InitSpread | PSI | 314 | 하드코딩 | AddTextColumn | ITEM_ID | ITEM_ID |  |
| InitSpread | PSI | 315 | 하드코딩 | AddTextColumn | Nick Name | NICK_NAME |  |
| InitSpread | PSI | 317 | 하드코딩 | AddTextColumn | Electrode Type | ELECTRODE_TYPE |  |
| InitSpread | PSI | 318 | 하드코딩 | AddNumColumn | BOH (From Site) | BOH |  |
| InitSpread | PSI | 319 | 하드코딩 | AddTextColumn | PSI Type | PSI_NAME |  |
| InitSpread | PSI | 320 | 하드코딩 | AddTextColumn | PSI Value | PSI_VALUE |  |
| InitSpread | PSI | 321 | 하드코딩 | AddTextColumn | PSI Type | PSI_TYPE |  |
| InitSpread | PSI | 323 | 하드코딩 | AddTextColumn | FROM_SITE | FROM_SITE |  |
| InitSpread | PSI | 324 | 하드코딩 | AddTextColumn | Division | DIVISION_NAME |  |
| InitSpread | PSI | 325 | 하드코딩 | AddTextColumn | OPERATION_GROUP | OPERATION_GROUP |  |
| InitSpread | PSI | 326 | 하드코딩 | AddTextColumn | PLAN_START_YYYYMMDD | PLAN_START_YYYYMMDD |  |
| InitSpread | PSI | 327 | 하드코딩 | AddTextColumn | PLAN_TYPE | PLAN_TYPE |  |
| InitSpread | PSI | 329 | 하드코딩 | AddTextColumn | SEQ | SEQ |  |
| InitSpreadDateColumn |  | 393 | DB루프 | AddTextColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("D_") > 0) |
| InitSpreadDateColumn |  | 398 | DB루프 | AddNumColumn | {?dr[DefMain.COLUMN_LABEL_NAME]} | {?dr[DefMain.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("D_") > 0) |
| InitSpreadDateColumn |  | 403 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("D_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 1606 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1611 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1618 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1622 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1627 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1634 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1638 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) |
| InitializeComponent |  | 848 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 849 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 850 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 851 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| PSI | META+코드연결 | 17 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 18 | 18 | 18 | 18 | 18 | 18 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

# SSP0016 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0016_ShipmentRequest.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 2681 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0016_ShipmentRequest.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1349 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:EditButton | EditButton > GetSpdHoliday | 2646 | SSP.SSP0016_GET_SHEET_HOLIDAY_CALENDAR | MATCH | SP SSP0016_GET_SHEET_HOLIDAY_CALENDAR |
| button:FindButton | FindButton > FindData_Main | 1224 | SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL | MATCH | SP SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL |
| button:FindButton | FindButton > FindData_Main > FindData_Detail | 1393 | SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL | MATCH | SP SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL |
| button:FindButton | FindButton > FindData_Main > FindData_Detail > InitSpread > GetSpdTitle | 2565 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:FindButton | FindButton > FindData_Main > FindData_Detail > InitSpread > SetWeekEnd | 2576 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:InsertButton | InsertButton > InsertRow > GetSpdHoliday | 2646 | SSP.SSP0016_GET_SHEET_HOLIDAY_CALENDAR | MATCH | SP SSP0016_GET_SHEET_HOLIDAY_CALENDAR |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Main | 1224 | SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL | MATCH | SP SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Main > FindData_Detail | 1393 | SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL | MATCH | SP SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL |
| button:SaveButton | SaveButton > SaveData_Detail | 1820 | SSP.SSP0016_SAVE_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL | MATCH | SP SSP0016_SAVE_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Main > FindData_Detail > InitSpread > GetSpdTitle | 2565 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Main > FindData_Detail > InitSpread > SetWeekEnd | 2576 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 2565 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > SetWeekEnd | 2576 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnSearch.Click | btnSearch_Click > FindData_Detail_All | 1505 | SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL_ALL | MATCH | SP SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL_ALL |
| event:this.btnSearch.Click | btnSearch_Click > FindData_Detail_All > InitSpread > GetSpdTitle | 2565 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnSearch.Click | btnSearch_Click > FindData_Detail_All > InitSpread > SetWeekEnd | 2576 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1120 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2565 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetWeekEnd | 2576 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail | 1393 | SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL | MATCH | SP SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail > InitSpread > GetSpdTitle | 2565 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail > InitSpread > SetWeekEnd | 2576 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | SetCalendar | 2229 | biz:CommonData.CommonDataList [code=CalendarDay] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CalendarDay] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_SYS_CALENDAR_M |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 2 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0016_GET_SHEET_HOLIDAY_CALENDAR | MATCH | 1 | SP SSP0016_GET_SHEET_HOLIDAY_CALENDAR | EXEC:SSP0016_GET_SHEET_HOLIDAY_CALENDAR, SELECT:SCM_MST_SITE, SELECT:SSP_MST_SHIP_CALENDAR |  |
| SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL | MATCH | 1 | SP SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL | EXEC:SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL, SELECT:SCM_MST_TITLESET_USER, CREATE:#TBLDYNAMICPIVOT_SSP0016_TMP, INSERT:#TBLDYNAMICPIVOT_SSP0016_MEASURE, SELECT:SCM_MST_SHEET_MEASURE, INSERT:#TBLDYNAMICPIVOT_SSP0016_TMP, SELECT:SSP_ANL_SHIP_REQ_D, SELECT:#TBLDYNAMICPIVOT_SSP0016_MEASURE, SELECT:SCM_SYS_CALENDAR_M, REF:UF_FX_STRING_SPLIT, SELECT:SSP_ANL_SHIP_REQ, DYNAMIC@SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL |  |
| SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL | MATCH | 1 | SP SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL | EXEC:SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL, SELECT:SSP_MST_SHIP_REQ, CREATE:#TBLDYNAMICPIVOT_SSP0016_DT, INSERT:#TBLDYNAMICPIVOT_SSP0016_DT, SELECT:SSP_ANL_SHIP_REQ_D, SELECT:SCM_SYS_CALENDAR_M, SELECT:SSP_ANL_SHIP_REQ, INSERT:#TEMP_TABLE, SELECT:#TBLDYNAMICPIVOT_SSP0016_DT, DYNAMIC@SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL |  |
| SSP.SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL_ALL | MATCH | 1 | SP SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL_ALL | EXEC:SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL_ALL, SELECT:SSP_MST_SHIP_REQ, CREATE:#TBLDYNAMICPIVOT_SSP0016_DT_ALL, INSERT:#TBLDYNAMICPIVOT_SSP0016_DT_ALL, SELECT:SSP_ANL_SHIP_REQ_D, SELECT:SCM_SYS_CALENDAR_M, REF:UF_FX_STRING_SPLIT, SELECT:TB_FX_USER, SELECT:SSP_ANL_SHIP_REQ, INSERT:#TEMP_TABLE_ALL, SELECT:#TBLDYNAMICPIVOT_SSP0016_DT_ALL, DYNAMIC@SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL_ALL |  |
| SSP.SSP0016_SAVE_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL | MATCH | 1 | SP SSP0016_SAVE_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL | EXEC:SSP0016_SAVE_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, CREATE:#TMP_SSP_ANL_SHIP_REQ_UPDATE_BOH, CREATE:#TMP_SSP_ANL_SHIP_REQ_01, INSERT:#TMP_SSP_ANL_SHIP_REQ_01, SELECT:SSP_ANL_SHIP_REQ, REF:SCM_ARR_SPL_VAL, REF:FN_GET_SSP_ETA_DATE, UPDATE:#TMP_SSP_ANL_SHIP_REQ_01, SELECT:#TMP_SSP_ANL_SHIP_REQ_01, DELETE:#TMP_SSP_ANL_SHIP_REQ_01, INSERT:SSP_ANL_SHIP_REQ_H, SELECT:SSP_MST_SHIP_REQ, CREATE:#TMP_SSP_ANL_HOLD_STOCK, INSERT:#TMP_SSP_ANL_HOLD_STOCK, SELECT:SSP_ANL_HOLD_STOCK, SELECT:#TMP_SSP_ANL_HOLD_STOCK, INSERT:#TMP_SSP_ANL_SHIP_REQ_UPDATE_BOH, SELECT:SCM_SYS_CALENDAR_M, SELECT:#TMP_SSP_ANL_SHIP_REQ_UPDATE_BOH, DELETE:SSP_ANL_SHIP_REQ, INSERT:SSP_ANL_SHIP_REQ, UPDATE:SSP_ANL_SHIP_REQ, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCP_MST_BOD_N_V, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| chkQtyNewLine | c | CODE |
| EditButton | dsDetailSpdTitle.Tables[0].Rows[i] | YYYYMMDD |
| InsertRow | dsDetailSpdTitle.Tables[0].Rows[i] | YYYYMMDD |
| Set_SumValues | dsBinding.Tables[0].Columns | measure |
| SetWeekEnd | dr | COLUMN_NAME, DAY_CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:290 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:296, InitSpread:326, InitSpread:346 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:299 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | EditButton:699, EditButton:702, SetChangedControl:1143, SetChangedControl:1154, FindData_Main:1191, FindData_Main:1192, FindData_Main:1194, FindData_Detail_All:1478 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:198 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:469 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:471 |
| this.spdDetail | TopChange | SpdDetail_TopChange | InitEvent:472 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:474 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:475 |
| this.cboBucketType_Detail | SelectedIndexChanged | cboBucketType_Detail_SelectedIndexChanged | InitEvent:476 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:477 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:478 |
| this.chkInculdINF | Click | chkIncludINF_Click | InitEvent:479 |
| this.spdDetail | CellClick | SpdDetail_CellClick | InitEvent:481 |
| this.spdDetail | ComboSelChange | SpdDetail_ComboSelChange | InitEvent:482 |
| this.spdDetail | EditChange | SpdDetail_EditChange | InitEvent:483 |
| this.spdDetail | ClipboardPasted | SpdDetail_ClipboardPasted | InitEvent:484 |
| this.spdDetail | ActiveSheetChanged | SpdDetail_ActiveSheetChanged | InitEvent:485 |
| this.btnItemID2 | Click | btnItemID2_Click | InitEvent:488 |
| this.btnRequestor | Click | btnRequestor_Click | InitEvent:489 |
| this.btnSearch | Click | btnSearch_Click | InitEvent:490 |
| dsdm | Changed | Dsdm_Changed | InitEvent:493 |
| clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitEvent:495 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:496 |

## 6. 컨트롤 (51개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 18 | layoutControlItem7, lblItemId, layoutControlItem2, PlanDate, layoutControlItem6, layoutControlItem10, lcDivision, lblBucket, layoutControlItem8, layoutControlItem1, chkDeleted_Req, lblItemId2, layoutControlItem3, lblRequestor, layoutControlItem4 … |
| UsrButton | 5 | usrButton1, btnMeasure, btnItemId, btnRequestor, btnItemID2 |
| UsrCheckBox | 3 | chkDelete, chkSum, chkInculdINF |
| UsrCombo | 3 | cboPlanDate, cboBucketType, cboBucketType_Detail |
| UsrMultiLineEditor | 3 | txtItemId, txtItemId2, txtRequestor |
| EmptySpaceItem | 3 | emptySpaceItem3, emptySpaceItem1, emptySpaceItem2 |
| UsrLayoutControl | 2 | usrLayoutControl2, usrLayoutControl3 |
| UsrCheckedList | 2 | clbPlantSite, clbDivision |
| UsrDateRangePicker | 2 | drpPeriod, drpAvailable |
| LayoutControlGroup | 2 | layoutControlGroup2, layoutControlGroup3 |
| FpSpread | 2 | spdMain, spdDetail |
| SheetView | 2 | spdMain_Sheet1, spdDetail_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| SimpleButton | 1 | btnSearch |
| SplitContainer | 1 | splitContainer1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 25 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 47 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 9 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_Favorite | 26 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 14 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 2 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 2 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 95 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1983 | SSP.SSP0001_SAVE_SHIPMENT_PLAN_CONFIRM_DETAIL | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0016 | Shipment Request Detail | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |
| SCM_MST_SHEET_COLUMNS | SSP0016 | Shipment Request Detail(All) | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |
| SCM_MST_SHEET_COLUMNS | SSP0016 | Shipment Request(IT & Mobile) | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |
| SCM_MST_SHEET_MEASURE | SSP0016 | Shipment Request(IT & Mobile) | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Request(IT & Mobile), Shipment Request Detail, Shipment Request Detail(All)
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:296, SetSheetHeaderColumn@InitSpread:326, SetSheetHeaderColumn@InitSpread:346
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn, SetSpreadColumnDetail

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Shipment Request Detail | 333 | 하드코딩 | AddTextColumn | Last Updated By | LAST_UPDATED_BY | if(spdInfo.SheetName == "Shipment Request Detail") |
| InitSpread | Shipment Request Detail | 334 | 하드코딩 | AddDateTimeColumn | Update Date | LAST_UPDATE_DATE | if(spdInfo.SheetName == "Shipment Request Detail") |
| InitSpread | Shipment Request Detail(All) | 353 | 하드코딩 | AddTextColumn | Last Updated By | LAST_UPDATED_BY | if(spdInfo.SheetName == "Shipment Request Detail(All)") |
| InitSpread | Shipment Request Detail(All) | 354 | 하드코딩 | AddDateTimeColumn | Update Date | LAST_UPDATE_DATE | if(spdInfo.SheetName == "Shipment Request Detail(All)") |
| InitSpreadDateColumn |  | 417 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 421 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 425 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 991 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 996 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1003 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1007 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1012 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1019 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1023 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumnDetail |  | 1042 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | if(siDetail.ActiveSheet.SheetName == "Shipment Request Detail(All)") ⟫ for(iCol <= siDetail.GetMaxColumnIndex()) ⟫ if(cboBucketType_Detail.ControlValues == "DAILY") ⟫ if(siDetail.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumnDetail |  | 1046 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(siDetail.ActiveSheet.SheetName == "Shipment Request Detail(All)") ⟫ for(iCol <= siDetail.GetMaxColumnIndex()) ⟫ if(cboBucketType_Detail.ControlValues == "DAILY") ⟫ else!(siDetail.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siDetail.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siDetail.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumnDetail |  | 1054 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(siDetail.ActiveSheet.SheetName == "Shipment Request Detail(All)") ⟫ for(iCol <= siDetail.GetMaxColumnIndex()) ⟫ else!(cboBucketType_Detail.ControlValues == "DAILY") ⟫ if(cboBucketType_Detail.ControlValues == "WEEKLY") ⟫ if(siDetail.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siDetail.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumnDetail |  | 1058 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | if(siDetail.ActiveSheet.SheetName == "Shipment Request Detail(All)") ⟫ for(iCol <= siDetail.GetMaxColumnIndex()) ⟫ else!(cboBucketType_Detail.ControlValues == "DAILY") ⟫ if(cboBucketType_Detail.ControlValues == "WEEKLY") ⟫ else!(siDetail.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siDetail.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(siDetail.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumnDetail |  | 1065 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(siDetail.ActiveSheet.SheetName == "Shipment Request Detail(All)") ⟫ for(iCol <= siDetail.GetMaxColumnIndex()) ⟫ else!(cboBucketType_Detail.ControlValues == "DAILY") ⟫ else!(cboBucketType_Detail.ControlValues == "WEEKLY") ⟫ if(cboBucketType_Detail.ControlValues == "MONTHLY") ⟫ if(siDetail.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siDetail.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumnDetail |  | 1069 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | if(siDetail.ActiveSheet.SheetName == "Shipment Request Detail(All)") ⟫ for(iCol <= siDetail.GetMaxColumnIndex()) ⟫ else!(cboBucketType_Detail.ControlValues == "DAILY") ⟫ else!(cboBucketType_Detail.ControlValues == "WEEKLY") ⟫ if(cboBucketType_Detail.ControlValues == "MONTHLY") ⟫ else!(siDetail.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siDetail.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siDetail.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumnDetail |  | 1082 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | else!(siDetail.ActiveSheet.SheetName == "Shipment Request Detail(All)") ⟫ for(iCol <= siDetail.GetMaxColumnIndex()) ⟫ if(cboBucketType_Detail.ControlValues == "DAILY") ⟫ if(siDetail.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumnDetail |  | 1086 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | else!(siDetail.ActiveSheet.SheetName == "Shipment Request Detail(All)") ⟫ for(iCol <= siDetail.GetMaxColumnIndex()) ⟫ if(cboBucketType_Detail.ControlValues == "DAILY") ⟫ else!(siDetail.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siDetail.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siDetail.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumnDetail |  | 1094 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | else!(siDetail.ActiveSheet.SheetName == "Shipment Request Detail(All)") ⟫ for(iCol <= siDetail.GetMaxColumnIndex()) ⟫ else!(cboBucketType_Detail.ControlValues == "DAILY") ⟫ if(cboBucketType_Detail.ControlValues == "WEEKLY") ⟫ if(siDetail.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumnDetail |  | 1098 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | else!(siDetail.ActiveSheet.SheetName == "Shipment Request Detail(All)") ⟫ for(iCol <= siDetail.GetMaxColumnIndex()) ⟫ else!(cboBucketType_Detail.ControlValues == "DAILY") ⟫ if(cboBucketType_Detail.ControlValues == "WEEKLY") ⟫ else!(siDetail.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siDetail.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| siDetail.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumnDetail |  | 1105 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | else!(siDetail.ActiveSheet.SheetName == "Shipment Request Detail(All)") ⟫ for(iCol <= siDetail.GetMaxColumnIndex()) ⟫ else!(cboBucketType_Detail.ControlValues == "DAILY") ⟫ else!(cboBucketType_Detail.ControlValues == "WEEKLY") ⟫ if(cboBucketType_Detail.ControlValues == "MONTHLY") ⟫ if(siDetail.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumnDetail |  | 1109 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | else!(siDetail.ActiveSheet.SheetName == "Shipment Request Detail(All)") ⟫ for(iCol <= siDetail.GetMaxColumnIndex()) ⟫ else!(cboBucketType_Detail.ControlValues == "DAILY") ⟫ else!(cboBucketType_Detail.ControlValues == "WEEKLY") ⟫ if(cboBucketType_Detail.ControlValues == "MONTHLY") ⟫ else!(siDetail.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siDetail.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siDetail.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetCalendar |  | 2236 | DB루프 | AddNumColumn | {?a.Field<string>(DefColumns.NAME)} | D_{?a.Field<string>(DefColumns.CODE)} | if(reqInStartDate != "" && reqInEndDate != "") ⟫ foreach(a in dtCalendar.AsEnumerable()) |
| SetWeekEnd |  | 2617 | DB루프 | AddNumColumn | {?DateTime.ParseExact(strWeeKEnd.Replace("M_", ""), "yyyyMM", null).ToString("yyyy-MM")} \|\| {?strWeeKEnd2.Substring(0, 4)}-{?strWeeKEnd2.Substring(4, 2)}-{?strWeeKEnd2.Substring(6, 2)} \|\| {?colName.Substring(0, 7)}(W{?colName.Substring(8, 2)}) \|\| {?DateTime.ParseExact(strWeeKEnd.Replace("D_", ""), "yyyyMMdd", null).ToString("yyyy-MM-dd")} | {?dr["COLUMN_NAME"]} | foreach(dr in dsSpdTitle_WeekEnd.Tables[0].Rows) |
| SetWeekEnd |  | 2631 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?strDayOfWeek == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle_WeekEnd.Tables[0].Rows) ⟫ if(strWeeKEnd.Contains("D_") == true) ⟫ for(i < siDetail.ActiveSheet.ColumnCount) ⟫ if(strDay == strWeeKEndDay) ⟫ if(strDayOfWeek == "SAT"\|\| strDayOfWeek == "SUN") |
| InitializeComponent |  | 1159 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1160 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1161 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1162 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1210 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1211 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1212 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1213 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Request Detail | META+코드연결 | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) |
| Shipment Request Detail(All) | META+코드연결 | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) | 15 (?1) |
| Shipment Request(IT & Mobile) | META+코드연결 | 7 (?1) | 7 (?1) | 7 (?1) | 7 (?1) | 7 (?1) | 7 (?1) | 7 (?1) | 7 (?1) | 7 (?1) | 7 (?1) | 7 (?1) | 7 (?1) | 7 (?1) | 7 (?1) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:조회데이터 42 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 42건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

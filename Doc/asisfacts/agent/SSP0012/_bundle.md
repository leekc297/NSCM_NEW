# SSP0012 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 619 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 598 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > SetChangedControl > GetDayRange | 596 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| button:FindButton | FindButton > FindData_Main | 418 | SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL | MATCH | SP SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL |
| event:this.Load | Form_Load > InitControls > GetDayRange | 596 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| unreached:(진입점 미연결) | <field:dtFcstType> | 56 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtBaseDay> | 57 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 542 | biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH | 1 |  |  |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL | MATCH | 1 | SP SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL | EXEC:SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL, CREATE:#TBLDYNAMICPIVOT_SSP0012, REF:FN_GET_IN_STR, DYNAMIC@SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL, SELECT:#TBLDYNAMICPIVOT_SSP0012, REF:FN_SCM_SPLIT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| InitControls | c | CODE |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpread:266 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetCheckedListValue | SetChangedControl:366, FindData_Main:398, FindData_Main:399 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:186 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:277 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:278 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:280 |
| clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitEvent:282 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:284 |

## 6. 컨트롤 (25개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 8 | layoutControlItem7, lblItemId, layoutControlItem2, layoutControlItem6, lcDivision, layoutControlItem1, layoutControlItem3, layoutControlItem5 |
| UsrButton | 3 | usrButton1, btnItemId, btnColumn |
| UsrCheckedList | 2 | clbPlantSite, clbDivision |
| TextBox | 2 | txtSoldToParty, txtShipToParty |
| EmptySpaceItem | 2 | emptySpaceItem3, emptySpaceItem1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrMultiLineEditor | 1 | txtItemId |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 7 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 47 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 90 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 12 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 16 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 4 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 4 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 46 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 595 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0012 | Shipment Plan Confirm Detail | 44/0 | 44/0 | 44/0 | 44/0 | 44/0 | 44/0 | 44/0 | 44/0 | 44/0 | 44/0 | 44/0 | 44/0 | 44/0 | 44/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Plan Confirm Detail
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:266

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Shipment Plan Confirm Detail | 270 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} | INCOTERMS | if(spdInfo.SheetName == "Shipment Plan Confirm Detail") |
| InitSpread | Shipment Plan Confirm Detail | 271 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} | CHANGE_REQ_NO | if(spdInfo.SheetName == "Shipment Plan Confirm Detail") |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Plan Confirm Detail | META+코드연결 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 | 44 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.


### FILE endpoints.csv (5 rows)
```csv
"variant","file","class","member","line","site_kind","kind","candidate","key","status","sp_or_sql","objects","via","detail"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","<field:dtFcstType>","56","derived","biz","CommonData.CommonDataList [code=LookupCommon]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.LookupCommon:Type.LookupCommon] > Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","<field:dtBaseDay>","57","derived","biz","CommonData.CommonDataList [code=LookupCommon]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.Common[case Type.LookupCommon:Type.LookupCommon] > Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","FindData_Main","418","ctor","fox","SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL","SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL","MATCH","SP SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL","EXEC:SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL, CREATE:#TBLDYNAMICPIVOT_SSP0012, REF:FN_GET_IN_STR, DYNAMIC@SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL, SELECT:#TBLDYNAMICPIVOT_SSP0012, REF:FN_SCM_SPLIT","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","SetChangedPeriod","542","derived","biz","CommonData.CommonDataList [code=PERIOD_{p:value} || PERIOD_DEFAULT]","biz:CommonData.CommonDataList","BIZ_MATCH","","","Data.CallBizCommonData",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","GetDayRange","596","ctor","fox","SCP.SCM0001_GET_SCP_DAY_PERIOD","SCP.SCM0001_GET_SCP_DAY_PERIOD","MATCH","SP SCM0001_GET_SCP_DAY_PERIOD","EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE","",""
```

### FILE flow.csv (6 rows)
```csv
"variant","file","class","entry_kind","entry","path","member","line","endpoint","status","sp_or_sql","objects"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","event","this.Load","Form_Load > InitControls > GetDayRange","GetDayRange","596","SCP.SCM0001_GET_SCP_DAY_PERIOD","MATCH","SP SCM0001_GET_SCP_DAY_PERIOD","EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","event","clbDivision.SelectedIndexChanged","clbDivision_SelectedIndexChanged > SetChangedControl > GetDayRange","GetDayRange","596","SCP.SCM0001_GET_SCP_DAY_PERIOD","MATCH","SP SCM0001_GET_SCP_DAY_PERIOD","EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","button","FindButton","FindButton > FindData_Main","FindData_Main","418","SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL","MATCH","SP SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL","EXEC:SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL, CREATE:#TBLDYNAMICPIVOT_SSP0012, REF:FN_GET_IN_STR, DYNAMIC@SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL, SELECT:#TBLDYNAMICPIVOT_SSP0012, REF:FN_SCM_SPLIT"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","unreached","(진입점 미연결)","SetChangedPeriod","SetChangedPeriod","542","biz:CommonData.CommonDataList [code=PERIOD_{p:value} || PERIOD_DEFAULT]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","unreached","(진입점 미연결)","<field:dtFcstType>","<field:dtFcstType>","56","biz:CommonData.CommonDataList [code=LookupCommon]","BIZ_MATCH","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","unreached","(진입점 미연결)","<field:dtBaseDay>","<field:dtBaseDay>","57","biz:CommonData.CommonDataList [code=LookupCommon]","BIZ_MATCH","",""
```

### FILE events.csv (6 rows)
```csv
"variant","file","class","member","line","target","event","handler","op"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail",".ctor","186","this","Load","Form_Load","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","InitEvent","277","this.spdMain","TopChange","SpdMain_TopChange","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","InitEvent","278","this.btnItemId","Click","btnItemId_Click","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","InitEvent","280","this.spdMain","CellClick","SpdMain_CellClick","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","InitEvent","282","clbDivision","SelectedIndexChanged","clbDivision_SelectedIndexChanged","+="
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","InitEvent","284","this.btnColumn","Click","BtnColumn_Click","+="
```

### FILE controls.csv (25 rows)
```csv
"variant","file","class","name","type","parent","line"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","usrButton1","GSCM.Windows.Forms.Controls.UsrButton","","33"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","usrConditionPanel1","GSCM.Windows.Forms.Controls.UsrConditionPanel","this","34"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","usrLayoutControl2","GSCM.Windows.Forms.Controls.UsrLayoutControl","usrConditionPanel1","35"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","btnItemId","GSCM.Windows.Forms.Controls.UsrButton","usrLayoutControl2","36"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","clbPlantSite","GSCM.Windows.Forms.Controls.UsrCheckedList","usrLayoutControl2","37"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","drpPeriod","GSCM.Windows.Forms.Controls.UsrDateRangePicker","usrLayoutControl2","38"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","txtItemId","GSCM.Windows.Forms.Controls.UsrMultiLineEditor","usrLayoutControl2","39"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","clbDivision","GSCM.Windows.Forms.Controls.UsrCheckedList","usrLayoutControl2","40"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","txtSoldToParty","System.Windows.Forms.TextBox","usrLayoutControl2","41"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","txtShipToParty","System.Windows.Forms.TextBox","usrLayoutControl2","42"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","btnColumn","GSCM.Windows.Forms.Controls.UsrButton","usrLayoutControl2","43"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","layoutControlGroup2","DevExpress.XtraLayout.LayoutControlGroup","","44"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","emptySpaceItem3","DevExpress.XtraLayout.EmptySpaceItem","","45"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","layoutControlItem7","DevExpress.XtraLayout.LayoutControlItem","","46"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","lblItemId","DevExpress.XtraLayout.LayoutControlItem","","47"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","layoutControlItem2","DevExpress.XtraLayout.LayoutControlItem","","48"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","layoutControlItem6","DevExpress.XtraLayout.LayoutControlItem","","49"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","emptySpaceItem1","DevExpress.XtraLayout.EmptySpaceItem","","50"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","lcDivision","DevExpress.XtraLayout.LayoutControlItem","","51"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","layoutControlItem1","DevExpress.XtraLayout.LayoutControlItem","","52"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","layoutControlItem3","DevExpress.XtraLayout.LayoutControlItem","","53"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","layoutControlItem5","DevExpress.XtraLayout.LayoutControlItem","","54"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","spdMain","FarPoint.Win.Spread.FpSpread","this","55"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","spdMain_Sheet1","FarPoint.Win.Spread.SheetView","","56"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","imageList1","System.Windows.Forms.ImageList","","57"
```

### FILE props.csv (44 rows)
```csv
"variant","file","class","member","line","target","prop","value"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","107","usrButton1","Size","new System.Drawing.Size(75, 23)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","116","usrConditionPanel1","Dock","System.Windows.Forms.DockStyle.Top"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","119","usrConditionPanel1","Size","new System.Drawing.Size(1192, 73)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","121","usrConditionPanel1","UsrPanelType","GSCM.Windows.Forms.Controls.UsrConditionPanel.PanelType.HidePanel"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","134","usrLayoutControl2","Dock","System.Windows.Forms.DockStyle.Top"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","139","usrLayoutControl2","Size","new System.Drawing.Size(1192, 73)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","141","usrLayoutControl2","Text","""usrLayoutControl2"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","172","btnItemId","Size","new System.Drawing.Size(39, 24)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","210","clbPlantSite","Size","new System.Drawing.Size(100, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","250","drpPeriod","Size","new System.Drawing.Size(205, 20)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","288","txtItemId","Size","new System.Drawing.Size(272, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","324","clbDivision","Size","new System.Drawing.Size(100, 21)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","335","txtSoldToParty","Size","new System.Drawing.Size(273, 20)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","342","txtShipToParty","Size","new System.Drawing.Size(268, 20)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","374","btnColumn","Size","new System.Drawing.Size(39, 25)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","398","layoutControlGroup2","Size","new System.Drawing.Size(1192, 78)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","406","emptySpaceItem3","Size","new System.Drawing.Size(464, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","411","layoutControlItem7","Control","this.clbPlantSite"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","414","layoutControlItem7","Size","new System.Drawing.Size(161, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","415","layoutControlItem7","Text","""From Site"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","422","lblItemId","Control","this.txtItemId"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","426","lblItemId","Size","new System.Drawing.Size(313, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","427","lblItemId","Text","""Model"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","434","layoutControlItem2","Control","this.btnItemId"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","439","layoutControlItem2","Size","new System.Drawing.Size(43, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","446","layoutControlItem6","Control","this.drpPeriod"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","451","layoutControlItem6","Size","new System.Drawing.Size(309, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","453","layoutControlItem6","Text","""Period*"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","463","emptySpaceItem1","Size","new System.Drawing.Size(156, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","468","lcDivision","Control","this.clbDivision"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","472","lcDivision","Size","new System.Drawing.Size(148, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","473","lcDivision","Text","""Division"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","480","layoutControlItem1","Control","this.txtSoldToParty"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","484","layoutControlItem1","Size","new System.Drawing.Size(356, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","485","layoutControlItem1","Text","""Sold To Party"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","492","layoutControlItem3","Control","this.txtShipToParty"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","496","layoutControlItem3","Size","new System.Drawing.Size(351, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","497","layoutControlItem3","Text","""Ship To Party"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","504","layoutControlItem5","Control","this.btnColumn"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","510","layoutControlItem5","Size","new System.Drawing.Size(43, 29)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","518","spdMain","Dock","System.Windows.Forms.DockStyle.Fill"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","523","spdMain","Size","new System.Drawing.Size(1192, 576)"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.Designer.cs","SSP0012_ShipmentPlanConfirmDetail","InitializeComponent","545","this","Text","""Shipment Plan Confirm"""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","btnItemId_Click","341","txtItemId","Text","sItemId"
```

### FILE grid_effective.csv (47 rows)
```csv
"sheet","sheet_rule","column","label","source","40","81","81_HD","81_HG","81_HM","81_ST","81_UC","82","EE","EE_HD","EE_HG","EE_HM","EE_ST","EE_UC"
"Shipment Plan Confirm Detail","META+코드연결","A_COUNTRY","Country*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","A_PORT_CODE","Port Code*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","A_PORT_NAME","Port*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","BIZ_TYPE_NAME","Biz Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","BOD_ID","bod_id","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Shipment Plan Confirm Detail","META+코드연결","CHANGE_REQ_NO","Change Request No","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","CONFIRM_ID","Confirm ID","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","CONFIRM_QTY","Confirmed Qty","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","D_COUNTRY","Country*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","D_PORT_CODE","Port Code*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","D_PORT_NAME","Port*","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","DAYS_FRI","Fri","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","DAYS_MON","Mon","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","DAYS_SAT","Sat","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","DAYS_SUN","Sun","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","DAYS_THU","Thu","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","DAYS_TUE","Tue","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","DAYS_WED","Wed","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","DIVISION_ID","Division","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","ERP_SO_NO","SO No","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","ETA","ETA","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","ETD","ETD","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","Expected_Shipping_Date","Expected Shipping Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","FCST_TYPE","FCST Type","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","FROM_SITE_DESCRIPTION","From Site","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","INCOTERMS","Incoterms","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","ITEM_ID","Model","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","LAST_UPDATE_DATE","Last Update Date","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","LAST_UPDATED_BY","Last Updated By","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","LT_ARRIVAL_INLAND","Arrival Inland","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","LT_DAY","L/T(Day)","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","LT_DEPARTURE_INLAND","Departure Inland","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","LT_LAY_OFF_CLEARANCE","Lay Off/Customs Clearance","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","LT_SUM","Total L/T","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","LT_TYPE","L/T Type","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","LT_VOYAGE","Voyage","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","LT_WAIT_SHIPPING","Waiting For Shipping","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","MTK_OWNER","MKT Owner","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","NICK_NAME","Nick Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","ORIGIN_FROM_DIVISION_ID","ORIGIN_FROM_DIVISION_ID","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Shipment Plan Confirm Detail","META+코드연결","PLAN_DATE","Shipment Date(GI)","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","PLAN_QTY","Planned Qty","META","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김","숨김"
"Shipment Plan Confirm Detail","META+코드연결","PROJECT_NAME","Project Name","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","SHIPTO_DESCRIPTION","Ship To Party","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","SOLDTO_DESCRIPTION","Sold To Party","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","TO_SITE_DESCRIPTION","To Site","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
"Shipment Plan Confirm Detail","META+코드연결","TRANSPORT_MODE","Trans Mode","META","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본","기본"
```

### FILE grid_code.csv (7 rows)
```csv
"variant","file","class","member","line","sheet_hint","kind","api","source","header","field","columns","args","arg_names","conditions","raw"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","CreateSpread","253","Shipment Plan Confirm Detail","SHEET","AddSheet","HARDCODED","","","","{?new FarPoint.Win.Spread.FpSpread()} ¦ Shipment Plan Confirm Detail ¦ Shipment Plan Confirm Detail ¦ 2 ¦ 1 ¦ 30","","","spdMain ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 2 ¦ 1 ¦ 30"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","CreateSpread","254","0","SHEET","GetSheetInfo","EXPR","","","","{?spdMain.Name} ¦ 0","","","spdMain.Name ¦ 0"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","CreateSpread","256","0","SHEET","ChangeSheet","EXPR","","","","","","",""
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","InitSpread","264","Shipment Plan Confirm Detail","SHEET","InitSheet","HARDCODED","","","","Shipment Plan Confirm Detail","","if(spdInfo.SheetName == ""Shipment Plan Confirm Detail"")","SpdSheet.shtMain"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","InitSpread","266","Shipment Plan Confirm Detail","META_BUILD","SetSheetHeaderColumn","EXPR","","","","{p:spdInfo} ¦ 2","siObj,iColumnHeaderRowCount","if(spdInfo.SheetName == ""Shipment Plan Confirm Detail"")","spdInfo ¦ 2"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","InitSpread","270","Shipment Plan Confirm Detail","OVERRIDE","set:CellType","EXPR","","","INCOTERMS","{?cellTypeImage}","CellType","if(spdInfo.SheetName == ""Shipment Plan Confirm Detail"")","cellTypeImage"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","InitSpread","271","Shipment Plan Confirm Detail","OVERRIDE","set:CellType","EXPR","","","CHANGE_REQ_NO","{?cellTypeImage}","CellType","if(spdInfo.SheetName == ""Shipment Plan Confirm Detail"")","cellTypeImage"
```

### FILE meta_reads.csv (4 rows)
```csv
"variant","file","class","member","line","receiver","column","via"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","<field:dtMyDivision>","48","UserInfoContext.Current","NowGroupID","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","InitControls","237","c","CODE","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","SetChangedPeriod","549","dt.Rows[0]","FROM_VALUE","[]"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","SSP0012_ShipmentPlanConfirmDetail","SetChangedPeriod","550","dt.Rows[0]","TO_VALUE","[]"
```

### FILE commented_calls.csv (1 rows)
```csv
"variant","file","line","kind","candidate","key","status"
"only","06.UIL\GSCM.SSP.Plan.UIL\SSP0012_ShipmentPlanConfirmDetail.cs","595","fox","SCP.GET_DATE_RANGE_1MONTH","SCP.GET_DATE_RANGE_1MONTH","commented:MATCH"
```

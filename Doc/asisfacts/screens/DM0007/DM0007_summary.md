# DM0007 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Master.UIL\DM0007_CustFcstMaster.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 1850 |
| only | 06.UIL\GSCM.DM.Master.UIL\DM0007_CustFcstMaster.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 566 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindDataFCST | 465 | DM.DM0007_GET_CUST_FCST_DATA | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > FindDataPSI | 535 | DM.DM0007_GET_CUST_PSI_DATA | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > FindDataPSI > InitSpread > GetSpdTitle | 1703 | DM.DM0007_GET_SPREAD_TITLE | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > FindDataPSI > InitSpread > GetSpdTitle | 1718 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindButton > FindDataFCST | 465 | DM.DM0007_GET_CUST_FCST_DATA | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData > FindButton > FindDataPSI | 535 | DM.DM0007_GET_CUST_PSI_DATA | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData | 757 | DM.DM0007_SAVE_CUST_FCST_DATA | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData | 1000 | DM.DM0007_SAVE_CUST_FCST_DATA | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData > FindButton > FindDataPSI > InitSpread > GetSpdTitle | 1703 | DM.DM0007_GET_SPREAD_TITLE | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData > FindButton > FindDataPSI > InitSpread > GetSpdTitle | 1718 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 1703 | DM.DM0007_GET_SPREAD_TITLE | NOT_IN_FOXQUERY |  |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread > GetSpdTitle | 1718 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 158 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 177 | biz:CommonData.CommonDataList [code=BucketType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 183 | biz:CommonData.CommonDataList [code=UploadUOM] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 197 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty | 199 | biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1703 | DM.DM0007_GET_SPREAD_TITLE | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1718 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 47 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetDivision | 1730 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivision | 1743 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetEndCustomerbyDivision | 1757 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetScmSitebyDivision | 1772 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetBucketType | 1788 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| unreached:(진입점 미연결) | GetScmSiteInfobyDivision | 1823 | SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_INFO_BY_DIVISION |
| unreached:(진입점 미연결) | GetUploadUOM | 1838 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Auth_Dept] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=BucketType] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_COLUMNS |
| biz:CommonData.CommonDataList [code=UploadUOM] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DM0007_GET_CUST_FCST_DATA | NOT_IN_FOXQUERY | 1 |  |  | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, REF:FN_SCM_GET_WHERE_SQL, EXEC:SP_EXECUTESQL, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT |
| DM.DM0007_GET_CUST_PSI_DATA | NOT_IN_FOXQUERY | 1 |  |  | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, REF:FN_SCM_GET_WHERE_SQL, EXEC:SP_EXECUTESQL, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT |
| DM.DM0007_GET_SPREAD_TITLE | NOT_IN_FOXQUERY | 1 |  |  | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, EXEC:SP_EXECUTESQL, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |
| DM.DM0007_SAVE_CUST_FCST_DATA | NOT_IN_FOXQUERY | 2 |  |  | DB 객체 존재(P) → FoxQuery 없이 직접 호출: EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCM_SYS_CALENDAR_M, SELECT:DM_MST_CUSTOMER_FCST, INSERT:DM_MST_CUSTOMER_FCST, DELETE:DM_MST_CUSTOMER_FCST, EXEC:PR_DM_MST_CUSTOMER_FCST_HIST, INSERT:#TMP_SITE_CUSTOMER_MAP, REF:FN_NEXT_DAY, INSERT:#DELETE_TARGET, SELECT:DM_PLN_MKT_FCST, DELETE:T1, SELECT:#DELETE_TARGET, INSERT:DM_PLN_MKT_FCST, SELECT:#TMP_SITE_CUSTOMER_MAP, INSERT:SCM_SYS_LOG_BATCH, INSERT:DM_MST_CUSTOMER_FCST_H |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_INFO_BY_DIVISION | EXEC:SCM0001_GET_SITE_INFO_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, REF:STRING_SPLIT |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbEndCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| FindDataFCST | UserInfoContext.Current | NowGroupID |
| FindDataPSI | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InsertRow | UserInfoContext.Current | NowGroupID |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:161, InitControls:166, InitControls:172, FindDataFCST:442, FindDataFCST:443, FindDataPSI:518, clbDivision_SelectedIndexChanged:1556, clbDivision_SelectedIndexChanged:1561 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:225, InitSpread:231 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:226, InitSpread:232 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:422, SaveButton:426 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.clbEndCustomer | SelectedIndexChanged | clbEndCustomer_SelectedIndexChanged | InitializeComponent:157 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:197 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:266 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:464 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:465 |
| this | Load | Form_Load | .ctor:139 |
| dsdm | Changed | shtMainFCSTDataModel_Changed | InitEvent:239 |
| dsdm2 | Changed | shtMainPSIDataModel_Changed | InitEvent:242 |

## 6. 컨트롤 (21개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 6 | lblTeam, lblEndCustomer, lblBucketType, lblSalesSite, lblActive, layoutControlItem1 |
| UsrCheckedList | 4 | clbEndCustomer, clbTeam, clbSalesSite, clbDivisions |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 2 | cboActive, cboBucketType |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem5 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (5건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 465 | FindDataFCST | DM.DM0007_GET_CUST_FCST_DATA | NOT_IN_FOXQUERY | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, REF:FN_SCM_GET_WHERE_SQL, EXEC:SP_EXECUTESQL, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 535 | FindDataPSI | DM.DM0007_GET_CUST_PSI_DATA | NOT_IN_FOXQUERY | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, REF:FN_SCM_GET_WHERE_SQL, EXEC:SP_EXECUTESQL, REF:SCM_ARR_SPL_VAL, REF:FN_SCM_SPLIT · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 757 | SaveData | DM.DM0007_SAVE_CUST_FCST_DATA | NOT_IN_FOXQUERY | DB 객체 존재(P) → FoxQuery 없이 직접 호출: EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCM_SYS_CALENDAR_M, SELECT:DM_MST_CUSTOMER_FCST, INSERT:DM_MST_CUSTOMER_FCST, DELETE:DM_MST_CUSTOMER_FCST, EXEC:PR_DM_MST_CUSTOMER_FCST_HIST, INSERT:#TMP_SITE_CUSTOMER_MAP, REF:FN_NEXT_DAY, INSERT:#DELETE_TARGET, SELECT:DM_PLN_MKT_FCST, DELETE:T1, SELECT:#DELETE_TARGET, INSERT:DM_PLN_MKT_FCST, SELECT:#TMP_SITE_CUSTOMER_MAP, INSERT:SCM_SYS_LOG_BATCH, INSERT:DM_MST_CUSTOMER_FCST_H · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 1000 | SaveData | DM.DM0007_SAVE_CUST_FCST_DATA | NOT_IN_FOXQUERY | DB 객체 존재(P) → FoxQuery 없이 직접 호출: EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCM_SYS_CALENDAR_M, SELECT:DM_MST_CUSTOMER_FCST, INSERT:DM_MST_CUSTOMER_FCST, DELETE:DM_MST_CUSTOMER_FCST, EXEC:PR_DM_MST_CUSTOMER_FCST_HIST, INSERT:#TMP_SITE_CUSTOMER_MAP, REF:FN_NEXT_DAY, INSERT:#DELETE_TARGET, SELECT:DM_PLN_MKT_FCST, DELETE:T1, SELECT:#DELETE_TARGET, INSERT:DM_PLN_MKT_FCST, SELECT:#TMP_SITE_CUSTOMER_MAP, INSERT:SCM_SYS_LOG_BATCH, INSERT:DM_MST_CUSTOMER_FCST_H · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 1703 | GetSpdTitle | DM.DM0007_GET_SPREAD_TITLE | NOT_IN_FOXQUERY | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, EXEC:SP_EXECUTESQL, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 16 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 31 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 23 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1731 | DM.Get_Division | commented:NOT_IN_FOXQUERY |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DM0007 | Customer FCST | 8/4 | 8/4 | 8/4 | 8/4 | 8/4 | 8/4 | 8/4 | 8/4 | 8/4 | 8/4 | 8/4 | 8/4 | 8/4 | 8/4 |
| SCM_MST_SHEET_COLUMNS | DM0007 | Customer PSI | 8/7 | 8/7 | 8/7 | 8/7 | 8/7 | 8/7 | 8/7 | 8/7 | 8/7 | 8/7 | 8/7 | 8/7 | 8/7 | 8/7 |
| SCM_MST_SHEET_MEASURE | DM0007 | Customer FCST | 9/14 | 9/14 | 9/14 | 9/14 | 9/14 | 9/14 | 9/14 | 9/14 | 9/14 | 9/14 | 9/14 | 9/14 | 9/14 | 9/14 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Customer FCST, Customer PSI
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:226, CreateSheetHeaderColumn@InitSpread:232

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadColor |  | 1810 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?siMain.GetColumnText(0, iCol) == "SAT"? Color.Blue : Color.Red} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnText(0, iCol) == "SAT"\|\| siMain.GetColumnText(0, iCol) == "SUN") |
| InitializeComponent |  | 481 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 482 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 483 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 484 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Customer FCST | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| Customer PSI | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

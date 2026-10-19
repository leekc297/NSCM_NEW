# SCP0015 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0015_PlanManagement\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0015_PlanManagement\SCP0015_PlanManagement.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0015_PlanManagement\SCP0015_PlanManagement.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0015_PlanManagement\SCP0015_PlanManagement.csproj | 1962 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0015_PlanManagement\SCP0015_PlanManagement.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0015_PlanManagement\SCP0015_PlanManagement.csproj | 608 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:dsdm.Changed | SpdPlan_Changed > FindData_Engin | 1170 | SCP.SCP0015_GET_PLAN_ENGINE_RUN | MATCH | SP SCP0015_GET_PLAN_ENGINE_RUN |
| event:dsdm.Changed | SpdPlan_Changed > FindData_Confirm | 1339 | SCP.SCP0015_GET_PLAN_MST_COMFIRM | MATCH | SP SCP0015_GET_PLAN_MST_COMFIRM |
| button:FindButton | FindButton > FindData_Plan | 998 | SCP.SCP0015_GET_PLAN_MST | MATCH | SP SCP0015_GET_PLAN_MST |
| button:FindButton | FindButton > FindData_Engin | 1170 | SCP.SCP0015_GET_PLAN_ENGINE_RUN | MATCH | SP SCP0015_GET_PLAN_ENGINE_RUN |
| event:spdPlan.CellClick | SpdPlan_CellClick > CallEnginCancel | 600 | SCP.SCP0015_SAVE_PLAN_MST_CANCEL | NOT_IN_FOXQUERY |  |
| event:spdPlan.CellClick | SpdPlan_CellClick > CallEnginCancel > FindData_Plan | 998 | SCP.SCP0015_GET_PLAN_MST | MATCH | SP SCP0015_GET_PLAN_MST |
| event:spdPlan.CellClick | SpdPlan_CellClick > CallEnginRun > FindData_Engin | 1170 | SCP.SCP0015_GET_PLAN_ENGINE_RUN | MATCH | SP SCP0015_GET_PLAN_ENGINE_RUN |
| event:spdPlan.CellClick | SpdPlan_CellClick > SaveData_PlanConfirm | 1416 | SCP.SCP0015_SAVE_PLAN_MST_COMFIRM | MATCH | SP SCP0015_SAVE_PLAN_MST_COMFIRM |
| event:spdPlan.CellClick | SpdPlan_CellClick > CallEnginRun > SaveData_PlanRun | 1558 | SCP.SCP0015_SAVE_PLAN_MST_RUN | MATCH | SP SCP0015_SAVE_PLAN_MST_RUN |
| event:spdPlan.CellDoubleClick | SpdPlan_CellDoubleClick > FindData_Engin | 1170 | SCP.SCP0015_GET_PLAN_ENGINE_RUN | MATCH | SP SCP0015_GET_PLAN_ENGINE_RUN |
| event:timerStatus.Tick | CheckEngineStatus > FindData_Engin | 1170 | SCP.SCP0015_GET_PLAN_ENGINE_RUN | MATCH | SP SCP0015_GET_PLAN_ENGINE_RUN |
| unreached:(진입점 미연결) | SaveData_PlanStop | 1483 | SCP.SCP0015_SAVE_PLAN_MST_STOP | MATCH | SP SCP0015_SAVE_PLAN_MST_STOP |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SCP.SCP0015_GET_PLAN_ENGINE_RUN | MATCH | 1 | SP SCP0015_GET_PLAN_ENGINE_RUN | EXEC:SCP0015_GET_PLAN_ENGINE_RUN, REF:FN_SCM_SPLIT, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_LOOKUP_CODE_DESC |  |
| SCP.SCP0015_GET_PLAN_MST | MATCH | 1 | SP SCP0015_GET_PLAN_MST | EXEC:SCP0015_GET_PLAN_MST, SELECT:SCM_MST_MODELING, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, REF:FN_SCM_SPLIT, REF:FN_SCP_PLAN_VERSION_V, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_PLAN_DETAIL, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:TB_FX_GROUPMENUAUTH, REF:FN_GET_LOOKUP_CODE_DESC, REF:FN_ZERO_LPAD, SELECT:SCM_MST_PLAN, REF:FN_GET_BUCKET_YYYYMMDD, REF:FN_DATE_TO_CHAR, REF:FN_GET_START_YYYYMMDD |  |
| SCP.SCP0015_GET_PLAN_MST_COMFIRM | MATCH | 1 | SP SCP0015_GET_PLAN_MST_COMFIRM | EXEC:SCP0015_GET_PLAN_MST_COMFIRM, REF:FN_SCM_SPLIT, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL |  |
| SCP.SCP0015_SAVE_PLAN_MST_CANCEL | NOT_IN_FOXQUERY | 1 |  |  | DB 객체 존재(P) → FoxQuery 없이 직접 호출: EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:FN_SCM_SPLIT, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, UPDATE:SCM_MST_PLAN_DETAIL, INSERT:SCM_SYS_LOG_BATCH |
| SCP.SCP0015_SAVE_PLAN_MST_COMFIRM | MATCH | 1 | SP SCP0015_SAVE_PLAN_MST_COMFIRM | EXEC:SCP0015_SAVE_PLAN_MST_COMFIRM, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:FN_SCM_SPLIT, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, UPDATE:SCM_MST_PLAN_DETAIL, EXEC:PR_SCP_PLN_INTERFACE_PLAN, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_MODELING, EXEC:PR_SCP_PLN_FP_PROD_TARGET, EXEC:PR_SCP_PLN_FP_SHIP_TARGET, SELECT:SCP_PLN_INTERFACE_YN, EXEC:PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE, EXEC:PR_SCP_PLN_MRP_PROD_TARGET_NERP_CREATE, EXEC:PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE, SELECT:SCM_MST_SITE, EXEC:PR_SSP_ANL_SHIP_REQ_SEMI, EXEC:PR_SSP_ANL_SHIP_REQ_P, EXEC:PR_SSP_ANL_SHIP_REQ_FG, EXEC:PR_SCP_PLN_PEGGING_PLAN, EXEC:PR_SCP_IF_SCS_SHIP_TARGET, EXEC:PR_SCP_IF_SCS_PROD_TARGET, REF:FN_GET_BUCKET_YYYYMMDD, CREATE:#TBL_FP_PLAN, SELECT:SCP_PLN_INTERFACE_SEND_H, REF:FN_ZERO_LPAD, INSERT:#TBL_FP_PLAN, SELECT:SCP_PLN_PROD_PLAN_TARGET_V, SELECT:SCM_MST_LINE_SN, INSERT:XIF_SCP_PROD_TARGET_R_SN, SELECT:#TBL_FP_PLAN, INSERT:SCP_PLN_INTERFACE_SEND_H, EXEC:PR_SCP_PLN_IF_CHECK_SMS_SEND, DELETE:XIF_FP_SCP_PROD_TARGET_S_SN, INSERT:XIF_FP_SCP_PROD_TARGET_S_SN, SELECT:XIF_SCP_PROD_TARGET_R_SN, INSERT:XIF_SCP_SALES_EXFACTORY_R_SN, SELECT:SCP_PLN_SHIP_PLAN_TARGET_V, EXEC:PR_SCM_SYS_LOG_BATCH, REF:FN_NEXT_DAY, SELECT:DM_MST_VERSION, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, CREATE:#T_RESULTS, CREATE:#T_MST_ACCUM, CREATE:#T_MST, CREATE:#T_TEMPX, CREATE:#T_VMI_MST, CREATE:#T_VMI_MST_MAIN, CREATE:#T_VMI_TEMP1, CREATE:#T_VMI_TEMP2, CREATE:#T_VMI_TEMP_ALL, CREATE:#T_CUTOFF, CREATE:#T_SSLVL, CREATE:#T_MF_BALANCE_MKT_FCST, CREATE:#T_RTF_EXCEPTION_ITEM, INSERT:#T_RESULTS, SELECT:#SEND_TARGET_DATA, INSERT:#T_RTF_EXCEPTION_ITEM, SELECT:DM_PLN_CFM_MKT_DEMAND_PLAN |  |
| SCP.SCP0015_SAVE_PLAN_MST_RUN | MATCH | 1 | SP SCP0015_SAVE_PLAN_MST_RUN | EXEC:SCP0015_SAVE_PLAN_MST_RUN, SELECT:SCM_SYS_LOG_BATCH, EXEC:PR_SCM_SYS_LOG_BATCH, EXEC:PR_SCP_ENG_CONTROL, INSERT:SCM_SYS_LOG_BATCH, REF:FN_NEXT_DAY, SELECT:SCM_MST_MODELING, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, SELECT:SCM_MST_DIVISION, EXEC:PR_SCM_MST_PLAN_FP_RELEASE_ID, EXEC:SCP0049_SAVE_NEW_VERSION, EXEC:PR_SCP_MST_WORKING_TIME_COPY_FROM_FP, EXEC:PR_SCP_MST_LOSS_TIME_COPY_FROM_FP, EXEC:PR_SCP_MST_TACT_TIME_EXCEPT_COPY_FROM_FP, EXEC:SCM_ADM_SMS_SEND_BATCH, EXEC:PR_SCP_ENG_IN_PRE_ALL, EXEC:PR_SCP_PLN_ELEC_DEMAND_CELL_PLAN, EXEC:PR_SCP_PLN_ASSEMBLY_YIELD_AVG, EXEC:PR_SCP_PLN_ELEC_YIELD_AVG, EXEC:PR_SCP_ENG_EE_PRE_ALL, EXEC:PR_SCP_ENG_IN_FN_ALL, EXEC:PR_SCP_ENG_EE_FN_ALL, REF:FN_GET_PLAN_STATUS, SELECT:TH_MST_ENG_PLAN_FLAG_SN, EXEC:PR_SCP_ENG_OUT_ALL, EXEC:PR_SCP_PLN_CREATE_DATA, UPDATE:SCM_MST_PLAN_DETAIL, EXEC:PR_SCP_ANL_CREATE_DATA, EXEC:PR_SCP_SUMMARY_REPORT, EXEC:PR_SCP_SUMMARY_REPORT_SALES, SELECT:SCP_ENG_PLAN_SUMMARY_SN, SELECT:TH_ENG_PLAN_INFO_SN, EXEC:PR_SCP_PLN_INTERFACE_PLAN, EXEC:PR_SCP_RPT_DIO_TREND_MM, EXEC:PR_SCP_RPT_GLOBAL_PSI_MD_MM, EXEC:PR_SCP_RPT_GLOBAL_PSI_MD_WW, EXEC:PR_SCP_RPT_GLOBAL_PSI_STD_DIO, EXEC:PR_SCP_ANL_BOD_N_V_PLAN_H, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, EXEC:PR_SCP_MST_CAPA_PROD_PLAN_APPLY, EXEC:PR_SCP_MST_CAPA_PROD_PLAN_APPLY_ELTR, EXEC:PR_SCP_ANL_CELL_TRAY_SIMULATION, EXEC:PR_SCP_ANL_PRODUCTION_PLAN_CUTOFF, EXEC:PR_SCP_ANL_SHIPMENT_PLAN_FG_CUTOFF, EXEC:PR_SCP_ANL_SHIPMENT_PLAN_SEMI_CUTOFF, SELECT:TH_ENG_PLAN_INFO, SELECT:TH_CFG_CONFIG_VALUE, EXEC:PR_SCP_BUF_BULK_INSERT, DELETE:SCM_MST_PLAN_FP_RELEASE_ID, INSERT:SCM_MST_PLAN_FP_RELEASE_ID, SELECT:SCM_MST_SITE, SELECT:SCM_DNM_FP_LAST_RELEASE_PLAN_ID_V_SN, SELECT:SCM_LOSS_M_SN, INSERT:#TMP_SCP0049_VER_LOOKUP, SELECT:SCM_SYS_LOOKUP_VALUE_SN, INSERT:#TMP_SCP0049_VER_DAY_OF_MONTH, SELECT:SCM_SYS_CALENDAR_M, CREATE:#TMP_SCP0049_VER_MM, CREATE:#TMP_SCP0049_VER_STD_SUM |  |
| SCP.SCP0015_SAVE_PLAN_MST_STOP | MATCH | 1 | SP SCP0015_SAVE_PLAN_MST_STOP | EXEC:SCP0015_SAVE_PLAN_MST_STOP, EXEC:PR_SCM_SYS_LOG_BATCH, REF:FN_SCM_SPLIT, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, UPDATE:SCM_MST_PLAN_DETAIL, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| FindData_Engin | dtStatus.Rows[0] | PLAN_STATUS, PLAN_STATUS_NAME |
| FindData_Plan | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | RefreshPlanYear:921, RefreshPlanWeek:936, RefreshPlanWeek:940, SetChangedControl:953, FindData_Plan:978, FindData_Plan:979, FindData_Plan:980 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:201 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:365 |
| cboPlanYear | SelectedIndexChanged | CboPlanYear_SelectedIndexChanged | InitEvent:366 |
| spdPlan | CellDoubleClick | SpdPlan_CellDoubleClick | InitEvent:367 |
| spdPlan | CellClick | SpdPlan_CellClick | InitEvent:368 |
| dsdm | Changed | SpdPlan_Changed | InitEvent:376 |
| timerStatus | Tick | CheckEngineStatus | InitEvent:379 |
| dsdm | Changed | SpdPlan_Changed | FindData_Confirm:1361 |
| dsdm | Changed | SpdPlan_Changed | FindData_Confirm:1367 |
| dsdm | Changed | SpdPlan_Changed | SaveData_PlanConfirm:1446 |
| dsdm | Changed | SpdPlan_Changed | SaveData_PlanConfirm:1452 |
| dsdm | Changed | SpdPlan_Changed | SpdPlan_Changed:1730 |
| dsdm | Changed | SpdPlan_Changed | SpdPlan_Changed:1806 |

## 6. 컨트롤 (26개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| EmptySpaceItem | 5 | emptySpaceItem3, emptySpaceItem4, emptySpaceItem6, emptySpaceItem7, emptySpaceItem8 |
| LayoutControlItem | 4 | Division, PlanType, PlanDate, lcRevision |
| UsrCombo | 3 | cboDivision, cboPlanYear, cboPlanWeek |
| UsrLayoutControl | 2 | usrLayoutControl2, usrLayoutControl3 |
| LayoutControlGroup | 2 | layoutControlGroup2, layoutControlGroup3 |
| FpSpread | 2 | spdPlan, spdEngin |
| SheetView | 2 | spdPlan_Sheet1, spdEngin_Sheet1 |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| UsrButton | 1 | usrButton1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrTextBox | 1 | txtRevision |
| Timer | 1 | timerStatus |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 600 | CallEnginCancel | SCP.SCP0015_SAVE_PLAN_MST_CANCEL | NOT_IN_FOXQUERY | DB 객체 존재(P) → FoxQuery 없이 직접 호출: EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:FN_SCM_SPLIT, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, UPDATE:SCM_MST_PLAN_DETAIL, INSERT:SCM_SYS_LOG_BATCH · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 24 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.TB_FX_Favorite | 9 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 45 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Plan Management, Engine Run

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread | Plan Management | 273 | 하드코딩 | AddTextColumn | MODELING_ID | MODELING_ID | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 274 | 하드코딩 | AddTextColumn | PLAN_ID | PLAN_ID | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 275 | 하드코딩 | AddTextColumn | Division Id | DIVISION_ID | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 276 | 하드코딩 | AddTextColumn | Division | DIVISION_NAME | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 277 | 하드코딩 | AddTextColumn | Plan Type | PLAN_TYPE | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 278 | 하드코딩 | AddTextColumn | Plan Type | PLAN_TYPE_DESCRIPTION | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 279 | 하드코딩 | AddButtonColumn | Engine Run | RUN | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 280 | 하드코딩 | AddButtonColumn | Cancel | CANCEL | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 281 | 하드코딩 | AddButtonColumn | Confirm | CONFIRM | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 282 | 하드코딩 | AddComboColumn | Revision No | REVISION_NO | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 283 | 하드코딩 | AddTextColumn | Status | PLAN_STATUS_NAME | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 284 | 하드코딩 | AddTextColumn | Status | PLAN_STATUS | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 285 | 하드코딩 | AddDateTimeColumn | Confirm Time | CONFIRM_TIME | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 286 | 하드코딩 | AddTextColumn | Confirm User | CONFIRM_USER | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 287 | 하드코딩 | AddTextColumn | CONFIRM_YN | CONFIRM_YN | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 288 | 하드코딩 | AddTextColumn | CONFIRM_AUTH | CONFIRM_AUTH | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 289 | 하드코딩 | AddTextColumn | RUN_AUTH | RUN_AUTH | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Plan Management | 290 | 하드코딩 | AddTextColumn | CANCEL_AUTH | CANCEL_AUTH | if(spdInfo.SheetName == "Plan Management") |
| InitSpread | Engine Run | 326 | 하드코딩 | AddTextColumn | MODELING_ID | MODELING_ID | if(spdInfo.SheetName == "Engine Run") |
| InitSpread | Engine Run | 327 | 하드코딩 | AddTextColumn | PLAN_ID | PLAN_ID | if(spdInfo.SheetName == "Engine Run") |
| InitSpread | Engine Run | 328 | 하드코딩 | AddTextColumn | PLAN_NAME | PLAN_NAME | if(spdInfo.SheetName == "Engine Run") |
| InitSpread | Engine Run | 329 | 하드코딩 | AddTextColumn | DIVISION_ID | DIVISION_ID | if(spdInfo.SheetName == "Engine Run") |
| InitSpread | Engine Run | 330 | 하드코딩 | AddTextColumn | PLAN_TYPE | PLAN_TYPE | if(spdInfo.SheetName == "Engine Run") |
| InitSpread | Engine Run | 331 | 하드코딩 | AddTextColumn | PLAN_SEQ | PLAN_SEQ | if(spdInfo.SheetName == "Engine Run") |
| InitSpread | Engine Run | 332 | 하드코딩 | AddTextColumn | Step | STEP_NAME | if(spdInfo.SheetName == "Engine Run") |
| InitSpread | Engine Run | 333 | 하드코딩 | AddTextColumn | Step | STEP_PROCESS1 | if(spdInfo.SheetName == "Engine Run") |
| InitSpread | Engine Run | 334 | 하드코딩 | AddTextColumn | Step | STEP_PROCESS2 | if(spdInfo.SheetName == "Engine Run") |
| InitSpread | Engine Run | 335 | 하드코딩 | AddTextColumn | Step | STEP_PROCESS3 | if(spdInfo.SheetName == "Engine Run") |
| InitSpread | Engine Run | 336 | 하드코딩 | AddTextColumn | Step | STEP_PROCESS4 | if(spdInfo.SheetName == "Engine Run") |
| InitSpread | Engine Run | 337 | 하드코딩 | AddTextColumn | STEP_STATUS | STEP_STATUS | if(spdInfo.SheetName == "Engine Run") |
| InitSpread | Engine Run | 338 | 하드코딩 | AddDateTimeColumn | Start Time | START_TIME | if(spdInfo.SheetName == "Engine Run") |
| InitSpread | Engine Run | 339 | 하드코딩 | AddDateTimeColumn | End Time | END_TIME | if(spdInfo.SheetName == "Engine Run") |
| InitializeComponent |  | 359 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 360 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 361 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 362 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Engine Run | 코드 하드코딩 전용(메타 없음) | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |
| Plan Management | 코드 하드코딩 전용(메타 없음) | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

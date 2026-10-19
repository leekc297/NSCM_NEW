# FPC0125 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0125_MWPPCopyDWSubmitPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 693 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0125_MWPPCopyDWSubmitPopup.Designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 865 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbLine.SelectedIndexChanged | clbLine_SelectedIndexChanged > FindData | 336 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | clbLine_SelectedIndexChanged > FindData | 336 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:clbLine.SelectedIndexChanged | clbLine_SelectedIndexChanged > FindData | 337 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | clbLine_SelectedIndexChanged > FindData | 337 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:clbLine.SelectedIndexChanged | clbLine_SelectedIndexChanged > FindData | 338 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | clbLine_SelectedIndexChanged > FindData | 338 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:clbLine.SelectedIndexChanged | clbLine_SelectedIndexChanged > FindData | 339 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | clbLine_SelectedIndexChanged > FindData | 339 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > FindData | 336 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > FindData | 336 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > FindData | 337 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > FindData | 337 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > FindData | 338 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > FindData | 338 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > FindData | 339 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | clbOperation_SelectedIndexChanged > FindData | 339 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 336 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 336 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 337 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 337 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 338 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 338 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 339 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:drPeriod.ValueChanged | period_ValueChanged > FindData | 339 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| button:FindButton | FindButton > FindData | 336 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 336 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:FindButton | FindButton > FindData | 337 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 337 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:FindButton | FindButton > FindData | 338 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 338 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:FindButton | FindButton > FindData | 339 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 339 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:this.btnOK.Click | btnOK_Click > SaveData | 451 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click > SaveData | 451 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| event:this.btnOK.Click | btnOK_Click > SaveData | 462 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_saveAuth] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click > SaveData | 462 | FP\Common\XpCommonAmend#find_saveAuth | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_saveAuth.sql |
| event:this.btnOK.Click | btnOK_Click > SaveData | 505 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_DWSubmit] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click > SaveData | 505 | FP\Common\XpCommonAmend#insert_DWSubmit | MATCH_PATTERN | [update-batch]  |
| event:this.btnOK.Click | btnOK_Click > SaveData | 510 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=executeSubmit] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click > SaveData | 510 | FP\Common\XpCommonAmend#executeSubmit | MATCH_PATTERN | SP PR_SCM_MPP_WPP_CONVERT |
| event:this.btnOK.Click | btnOK_Click > SaveData | 510 | biz:AppService.GeneralRunProcedureCustomTable [procedure=executeSubmit] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click > SaveData | 510 | XpCommonAmend#executeSubmit | NOT_IN_FOXQUERY |  |
| event:this.btnOK.Click | btnOK_Click > SaveData | 514 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=update_Submit_Flag] | BIZ_MATCH |  |
| event:this.btnOK.Click | btnOK_Click > SaveData | 514 | FP\Common\XpCommonAmend#update_Submit_Flag | MATCH_PATTERN | [update-batch]  |
| event:this.Load | Form_Load > InitControls | 218 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 238 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPeriod_DWSubmit] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 238 | FP\Common\XpCommonAmend#findPeriod_DWSubmit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_findPeriod_DWSubmit.sql |
| event:this.Load | Form_Load > FindData | 336 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 336 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:this.Load | Form_Load > FindData | 337 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 337 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:this.Load | Form_Load > FindData | 338 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 338 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:this.Load | Form_Load > FindData | 339 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 339 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=executeSubmit] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=update_Submit_Flag] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_saveAuth] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPeriod_DWSubmit] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=executeSubmit] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_DWSubmit] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 1 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\XpCommonAmend#executeSubmit | MATCH_PATTERN | 1 | SP PR_SCM_MPP_WPP_CONVERT | EXEC:PR_SCM_MPP_WPP_CONVERT | ⚠ DB에 SP 없음 |
| FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql | REF:FN_SITE_TIME, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\XpCommonAmend#find_saveAuth | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_saveAuth.sql | SELECT:FP_RELEASE_PLAN_INFO_H, SELECT:FP_USER_ROLE_INFO_V, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\XpCommonAmend#findPeriod_DWSubmit | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonAmend_findPeriod_DWSubmit.sql | SELECT:TH_UIS_CALENDAR, SELECT:TH_UIS_CAL, REF:FN_SITE_TIME, SELECT:FP_INSTANCE_INFO_V, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\XpCommonAmend#insert_DWSubmit | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\XpCommonAmend#update_Submit_Flag | MATCH_PATTERN | 1 | [update-batch]  | UPDATE:A, SELECT:SCM_FP_PLAN_H, REF:FN_SITE_TIME |  |
| XpCommonAmend#executeSubmit | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbLine_SelectedIndexChanged | Filter | LINE_ID |
| clbOperation_SelectedIndexChanged | Filter | OPERATION_ID |
| FindData | Filter | BUCKET |
| FindData | row | _CHK |
| InitControls | Filter | OPERATION_ID, LINE_ID, BUCKET_FROM, BUCKET_TO, INSTANCE_ID, MPP_WPP, START_DATE, END_DATE |
| InitControls | dtControl.Rows[0] | AMEND_LIMIT_YN, AMEND_LIMIT_DATE2 |
| Mpp_CheckedChanged | Filter | MPP_WPP |
| period_ValueChanged | Filter | START_DATE, BUCKET_FROM, BUCKET_TO |
| SaveData | row | _CHK, CALL_SEQUENCE |
| SaveData | Filter | PLAN_TYPE, _SEQ, CALL_SEQUENCE, FP_SITE_ID, SITE_ID |
| Wpp_CheckedChanged | Filter | MPP_WPP |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:168, InitControls:173, clbOperation_SelectedIndexChanged:552, clbLine_SelectedIndexChanged:558 | CString.GetCheckedListValue | CODE |
| FP_UpdateBatch2 | SaveData:505 | DataService.FP_UpdateBatch2 | COUNT, EXCEPTION, RESULT |
| SaveData | btnOK_Click:564 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:696 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:697 |
| this.panel1 | Resize | panel1_Resize | InitializeComponent:748 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:790 |
| this | Load | Form_Load | .ctor:124 |
| this | Load | Form_Load | .ctor:134 |
| drPeriod | ValueChanged | period_ValueChanged | Form_Load:153 |
| cbWpp | CheckedChanged | Wpp_CheckedChanged | Form_Load:154 |
| cbMpp | CheckedChanged | Mpp_CheckedChanged | Form_Load:155 |
| clbOperation | SelectedIndexChanged | clbOperation_SelectedIndexChanged | Form_Load:156 |
| clbLine | SelectedIndexChanged | clbLine_SelectedIndexChanged | Form_Load:157 |
| drPeriod | ValueChanged | period_ValueChanged | period_ValueChanged:648 |
| drPeriod | ValueChanged | period_ValueChanged | period_ValueChanged:672 |

## 6. 컨트롤 (29개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 10 | layoutControlItem3, layoutControlItem1, lblDivision, layoutControlItem4, layoutControlItem2, layoutControlItem5, layoutControlItem6, layoutControlItem7, layoutControlItem8, layoutControlItem10 |
| UsrLabel | 5 | usrLabel5, usrLabel4, usrLabel3, usrLabel1, usrLabel2 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCheckBox | 2 | cbMpp, cbWpp |
| UsrCheckedList2 | 2 | clbLine, clbOperation |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePicker2 | 1 | drPeriod |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| Panel | 1 | panel1 |
| UsrButton | 1 | btnOK |

## 7. 확인 필요 (11건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 336 | FindData | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 337 | FindData | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 338 | FindData | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 339 | FindData | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 451 | SaveData | FP\{?default:part_service}\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 510 | SaveData | FP\{?default:part_service}\XpCommonAmend#executeSubmit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 505 | SaveData | FP\{?default:part_service}\XpCommonAmend#insert_DWSubmit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 514 | SaveData | FP\{?default:part_service}\XpCommonAmend#update_Submit_Flag | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 510 | SaveData | XpCommonAmend#executeSubmit | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) |
| 238 | InitControls | FP\{?default:part_service}\XPCommonAmend#findPeriod_DWSubmit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 462 | SaveData | FP\{?default:part_service}\XpCommonAmend#find_saveAuth | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 10 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FPC0125 | WPPMPP | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: WPPMPP
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:296

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| FindData |  | 360 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK |  |
| FindData |  | 361 | 표시/라벨 변경 | set:Value | Value = {?true} | CHK |  |
| FindData |  | 362 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK |  |
| spdMain_CellClick |  | 584 | 표시/라벨 변경 | set:Value | Value = {?headtf} |  | if(e.Column == chk && e.ColumnHeader) ⟫ if(head != null) |
| spdMain_CellClick |  | 588 | 표시/라벨 변경 | set:Value | Value = {?headtf} |  | if(e.Column == chk && e.ColumnHeader) ⟫ else!(head != null) |
| spdMain_CellClick |  | 614 | 표시/라벨 변경 | set:Value | Value =  |  | else!(e.Column == chk && e.ColumnHeader) ⟫ if(e.Column == chk && e.ColumnHeader == false && e.RowHeader == false) ⟫ if(head != null) ⟫ if(headtf != tf) |
| InitializeComponent |  | 713 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 714 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 715 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 716 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| WPPMPP | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

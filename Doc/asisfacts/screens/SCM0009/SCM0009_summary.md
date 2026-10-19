# SCM0009 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SystemMgmt.UIL\SCM0009_Auth_Approval.cs | 06.UIL\GSCM.SystemMgmt.UIL\GSCM.SystemMgmt.UIL.csproj | 509 |
| only | 06.UIL\GSCM.SystemMgmt.UIL\SCM0009_Auth_Approval.Designer.cs | 06.UIL\GSCM.SystemMgmt.UIL\GSCM.SystemMgmt.UIL.csproj | 546 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnApproval.Click | BtnApproval_Click > SaveData | 269 | SystemManager.UP_FX_SaveApprovalAuthRequest | MATCH | SP UP_FX_SaveApprovalAuthRequest |
| event:btnApproval.Click | BtnApproval_Click > SaveData > FindData | 437 | SystemManager.UP_FX_GetApprovalAuthRequest | MATCH | SP UP_FX_GetApprovalAuthRequest |
| event:btnReject.Click | BtnReject_Click > SaveData | 269 | SystemManager.UP_FX_SaveApprovalAuthRequest | MATCH | SP UP_FX_SaveApprovalAuthRequest |
| event:btnReject.Click | BtnReject_Click > SaveData > FindData | 437 | SystemManager.UP_FX_GetApprovalAuthRequest | MATCH | SP UP_FX_GetApprovalAuthRequest |
| button:FindButton | FindButton > FindData | 437 | SystemManager.UP_FX_GetApprovalAuthRequest | MATCH | SP UP_FX_GetApprovalAuthRequest |
| event:this.Load | Form_Load > InitControls | 318 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDayRange | 337 | SCP.GET_DATE_RANGE_1MONTH_BEFORE | MATCH | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH_BEFORE.sql |
| unreached:(진입점 미연결) | SetChangedPeriod | 298 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| SCP.GET_DATE_RANGE_1MONTH_BEFORE | MATCH | 1 | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH_BEFORE.sql | SELECT:SCM_SYS_CALENDAR_M |  |
| SystemManager.UP_FX_GetApprovalAuthRequest | MATCH | 1 | SP UP_FX_GetApprovalAuthRequest | EXEC:UP_FX_GETAPPROVALAUTHREQUEST, SELECT:SCM_MST_AUTH_REQUEST, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_VENDOR, REF:STRING_SPLIT |  |
| SystemManager.UP_FX_SaveApprovalAuthRequest | MATCH | 1 | SP UP_FX_SaveApprovalAuthRequest | EXEC:UP_FX_SAVEAPPROVALAUTHREQUEST, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SCM_MST_AUTH_REQUEST, DELETE:TB_FX_USERGROUPAUTHEXTENTION, UPDATE:T, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:TB_FX_USER, EXEC:UP_FX_SAVEUSERINFO, EXEC:UP_FX_SAVEUSERGROUPINFO, EXEC:UP_FX_SAVEUSERGROUPAUTHEXTENTION, INSERT:SCM_SYS_LOG_BATCH, MERGE:TB_FX_USER, SELECT:SCM_MST_SSO_USER_INFO, UPDATE:TB_FX_USER, MERGE:TB_FX_USERGROUPINFO, MERGE:TB_FX_USERGROUPAUTHEXTENTION |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitControls | UserInfoContext.Current | NowGroupID |
| SaveData | UserInfoContext.Current | USER_ID |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SaveData | BtnReject_Click:199, BtnApproval_Click:223 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | InitControls:325, FindData:426, FindData:431 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:115 |
| btnApproval | Click | BtnApproval_Click | InitEvent:129 |
| btnReject | Click | BtnReject_Click | InitEvent:130 |
| spdMain | CellClick | SpdMain_CellClick | InitEvent:133 |

## 6. 컨트롤 (22개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | lblProject, lblProject1, lblDivision, layoutControlItem4, layoutControlItem5, layoutControlItem3, layoutControlItem6 |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem4 |
| SimpleButton | 2 | btnReject, btnApproval |
| UsrMultiLineEditor | 2 | txtUser, txtDept |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| UsrDateRangePicker | 1 | drpReqPeriod |
| UsrCombo | 1 | cboApprovalResult |
| UsrCheckedList | 1 | clbDivision |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.TB_FX_Favorite | 3 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 18 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: My Authority List

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 369 | 하드코딩 | AddCheckColumn | ALL | CHK |  |
| InitSpread |  | 370 | 하드코딩 | AddTextColumn | User ID | USER_ID |  |
| InitSpread |  | 371 | 하드코딩 | AddTextColumn | User Name | USER_NAME |  |
| InitSpread |  | 373 | 하드코딩 | AddTextColumn | COMPANY_ID | COMPANY_ID |  |
| InitSpread |  | 374 | 하드코딩 | AddTextColumn | WORKING_NAME | WORKING_NAME |  |
| InitSpread |  | 375 | 하드코딩 | AddTextColumn | SSO_LOCATE | SSO_LOCATE |  |
| InitSpread |  | 376 | 하드코딩 | AddTextColumn | DEPT_ID | DEPT_ID |  |
| InitSpread |  | 377 | 하드코딩 | AddTextColumn | Department | DEPT_NAME_KO |  |
| InitSpread |  | 378 | 하드코딩 | AddTextColumn | Authority | GROUP_ID |  |
| InitSpread |  | 379 | 하드코딩 | AddTextColumn | Division | DIVISION_ID |  |
| InitSpread |  | 380 | 하드코딩 | AddTextColumn | Division | DIVISION_NAME |  |
| InitSpread |  | 381 | 하드코딩 | AddTextColumn | PLANT_ID | PLANT_ID |  |
| InitSpread |  | 382 | 하드코딩 | AddTextColumn | Plant | PLANT_NAME |  |
| InitSpread |  | 384 | 하드코딩 | AddTextColumn | CUSTOMER_CODE | CUSTOMER_CODE |  |
| InitSpread |  | 385 | 하드코딩 | AddTextColumn | Customer | CUSTOMER_NAME |  |
| InitSpread |  | 387 | 하드코딩 | AddDateTimeColumn | Request Date | REQUEST_DATE |  |
| InitSpread |  | 388 | 하드코딩 | AddTextColumn | Approval Result | APPROVAL_RESULT |  |
| InitSpread |  | 389 | 하드코딩 | AddTextColumn | Approval User | APPROVAL_USER |  |
| InitSpread |  | 390 | 하드코딩 | AddDateTimeColumn | Approval Date | APPROVAL_DATE |  |
| InitSpread |  | 391 | 하드코딩 | AddTextColumn | Reject Reason | REJECT_REASON |  |
| InitSpread |  | 399 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK |  |
| InitSpread |  | 400 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK |  |
| InitSpread |  | 401 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK |  |
| InitializeComponent |  | 461 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 462 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 463 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 464 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| My Authority List | 코드 하드코딩 전용(메타 없음) | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

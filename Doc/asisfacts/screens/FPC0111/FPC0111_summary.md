# FPC0111 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0111_AlarmEditPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 980 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0111_AlarmEditPopup.designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 1567 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0111_AlarmEditPopup2.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 812 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0111_AlarmEditPopup2.designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 1513 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:dsdmMain.Changed | SpdMain_Changed | 604 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_userinfo] | BIZ_MATCH |  |
| event:dsdmMain.Changed | SpdMain_Changed | 604 | FP\{?default:part_service}\AmendMemo#get_userinfo | UNRESOLVED |  |
| event:dsdmMain.Changed | SpdMain_Changed | 708 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_userinfo] | BIZ_MATCH |  |
| event:dsdmMain.Changed | SpdMain_Changed | 708 | FP\Common\PICAlarm#get_userinfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_get_userinfo.sql |
| button:FindButton | FindButton > FindData | 391 | FP_Common.PR_UI_COMMON_POPUP | MATCH | SP PR_UI_COMMON_POPUP |
| button:FindButton | FindButton > FindData | 425 | FP_Common.PR_UI_COMMON_POPUP | MATCH | SP PR_UI_COMMON_POPUP |
| event:this.btnSave.Click | usrButton3_Click | 766 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=max_pic_ref] | BIZ_MATCH |  |
| event:this.btnSave.Click | usrButton3_Click | 766 | FP\Common\PICAlarm#max_pic_ref | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_max_pic_ref.sql |
| event:this.btnSave.Click | usrButton3_Click | 809 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_alarm] | BIZ_MATCH |  |
| event:this.btnSave.Click | usrButton3_Click | 809 | FP\Common\PICAlarm#save_alarm | MATCH_PATTERN | [update-batch]  |
| event:this.btnSave.Click | usrButton3_Click | 813 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] | BIZ_MATCH |  |
| event:this.btnSave.Click | usrButton3_Click | 813 | FP\Common\PICAlarm#save_memo | MATCH_PATTERN | [update-batch]  |
| event:this.btnSave.Click | usrButton3_Click | 821 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] | BIZ_MATCH |  |
| event:this.btnSave.Click | usrButton3_Click | 821 | FP\Common\PICAlarm#save_memo | MATCH_PATTERN | [update-batch]  |
| event:this.Load | Form_Load > InitControls | 229 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 229 | FP\Common\AmendMemo#find_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_find_memo.sql |
| event:this.Load | Form_Load > InitControls | 245 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 245 | FP\Common\PICAlarm#find_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_memo.sql |
| event:this.Load | Form_Load > InitControls | 245 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 245 | FP\{?default:part_service}\AmendMemo#find_alarm | UNRESOLVED |  |
| event:this.Load | Form_Load > InitControls | 279 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 279 | FP\Common\PICAlarm#find_alarm | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_alarm.sql |
| event:this.usrButton2.Click | usrButton2_Click | 885 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] | BIZ_MATCH |  |
| event:this.usrButton2.Click | usrButton2_Click | 885 | FP\Common\PICAlarm#find_alarm | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_alarm.sql |
| event:this.usrButton3.Click | usrButton3_Click | 757 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=max_pic_ref] | BIZ_MATCH |  |
| event:this.usrButton3.Click | usrButton3_Click | 757 | FP\{?default:part_service}\AmendMemo#max_pic_ref | UNRESOLVED |  |
| event:this.usrButton3.Click | usrButton3_Click | 789 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_alarm] | BIZ_MATCH |  |
| event:this.usrButton3.Click | usrButton3_Click | 789 | FP\{?default:part_service}\AmendMemo#save_alarm | UNRESOLVED |  |
| event:this.usrButton3.Click | usrButton3_Click | 791 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] | BIZ_MATCH |  |
| event:this.usrButton3.Click | usrButton3_Click | 791 | FP\Common\AmendMemo#save_memo | MATCH_PATTERN | [update-batch]  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_userinfo] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=max_pic_ref] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_alarm] | BIZ_MATCH | 2 |  |  |  |
| FP_Common.PR_UI_COMMON_POPUP | MATCH | 2 | SP PR_UI_COMMON_POPUP | EXEC:PR_UI_COMMON_POPUP | ⚠ DB에 SP 없음 |
| FP\{?default:part_service}\AmendMemo#find_alarm | UNRESOLVED | 1 |  |  |  |
| FP\{?default:part_service}\AmendMemo#get_userinfo | UNRESOLVED | 1 |  |  |  |
| FP\{?default:part_service}\AmendMemo#max_pic_ref | UNRESOLVED | 1 |  |  |  |
| FP\{?default:part_service}\AmendMemo#save_alarm | UNRESOLVED | 1 |  |  |  |
| FP\Common\AmendMemo#find_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_find_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\AmendMemo#save_memo | MATCH_PATTERN | 1 | [update-batch]  | MERGE:FP_AMEND_MEMO_M, SELECT:TH_UIS_CAL, REF:FN_SITE_TIME, SELECT:SCM_FACTORY_M, INSERT:HIS_AMEND_MEMO_M, SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\PICAlarm#find_alarm | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_PICAlarm_find_alarm.sql | SELECT:FP_AMEND_PIC_ALARM |  |
| FP\Common\PICAlarm#find_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\PICAlarm#get_userinfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_get_userinfo.sql | SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER |  |
| FP\Common\PICAlarm#max_pic_ref | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_max_pic_ref.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\PICAlarm#save_alarm | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\PICAlarm#save_memo | MATCH_PATTERN | 2 | [update-batch]  | MERGE:FP_AMEND_MEMO_M, SELECT:TH_UIS_CAL, REF:FN_SITE_TIME, SELECT:SCM_FACTORY_M, INSERT:HIS_AMEND_MEMO_M, SELECT:FP_AMEND_MEMO_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitControls | SrcRow | PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, NICK_NAME, ITEM_TYPE, FACTORY_ID, MARKET, OPERATION_ID, LINE_NAME, ELECTRODE_TYPE, LOCATION, COMPANY_ID, DIVISION_ID, SITE_ID, LINE_ID, PLANT_ID, EQUIPMENT_ID |
| InitControls | Filter | USER_ID, COMPANY_ID, DIVISION_ID, SITE_ID, LINE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET, PLAN_DATE, EQUIPMENT_ID, ELECTRODE_TYPE, ITEM_ID, BUCKET_FROM, BUCKET_TO, OLD_PIC_REF, PIC_REF |
| InitControls | memoInfo.Tables[0].Rows[0] | MEMO, ALARM_TIME, PIC_REF |
| InitControls | ro | USERID, DEPT_NAME, USER_NAME, EMAIL, PHONE |
| SpdMain_Changed | param | USER_ID |
| SpdMain_Changed | dsUser.Rows[0] | UserName, Dept_Name |
| usrButton2_Click | memoPopup.Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, PLAN_ID, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, USER_ID |
| usrButton2_Click | Filter | INSTANCE_ID, PLAN_ID, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, PIC_REF |
| usrButton2_Click | selected[i] | PIC_REF |
| usrButton2_Click | row | USERID, DEPT_NAME, USER_NAME, EMAIL, PHONE |
| usrButton3_Click | Filter | BUCKET_FROM, BUCKET_TO, MEMO, USER_ID, PIC_REF, SEQ, SETUP_COLOR_CODE |
| usrButton3_Click | max_pic_ref.Tables[0].Rows[0] | PIC_REF |
| usrButton3_Click | insRow | PIC_REF, P_USER_ID, USER_NAME, DEPT_NAME, EMAIL, PHONE, USER_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| HasMemoAuthority | InitControls:188 | UserService.HasMemoAuthority | NowGroupID |
| FP_PseudoBatch2 | usrButton3_Click:809, usrButton3_Click:789 | DataService.FP_PseudoBatch2 | COUNT, EXCEPTION, RESULT |
| ReadResult | usrButton3_Click:810, usrButton3_Click:790 | DataService.ReadResult | COUNT, EXCEPTION, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:138 |
| this | Load | Form_Load | .ctor:156 |
| dsdmMain | Changed | SpdMain_Changed | InitControls:286 |
| dsdmMain | Changed | SpdMain_Changed | InitControls:317 |
| dsdmMain | Changed | SpdMain_Changed | usrButton5_Click:600 |
| dsdmMain | Changed | SpdMain_Changed | usrButton5_Click:629 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:684 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:696 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:719 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:732 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:737 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:743 |
| dsdmMain | Changed | SpdMain_Changed | usrButton2_Click:946 |
| dsdmMain | Changed | SpdMain_Changed | usrButton2_Click:969 |
| this.btnSave | Click | usrButton3_Click | InitializeComponent:252 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:291 |
| this.usrButton5 | Click | usrButton5_Click | InitializeComponent:1284 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1297 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1298 |
| this.usrButton4 | Click | usrButton4_Click | InitializeComponent:1417 |
| this | Load | Form_Load | .ctor:138 |
| this | Load | Form_Load | .ctor:156 |
| dsdmMain | Changed | SpdMain_Changed | InitControls:252 |
| dsdmMain | Changed | SpdMain_Changed | InitControls:283 |
| dsdmMain | Changed | SpdMain_Changed | usrButton5_Click:542 |
| dsdmMain | Changed | SpdMain_Changed | usrButton5_Click:567 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:628 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:639 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:644 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:650 |
| this.usrButton3 | Click | usrButton3_Click | InitializeComponent:242 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1235 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1236 |
| this.usrButton5 | Click | usrButton5_Click | InitializeComponent:1362 |

## 6. 컨트롤 (112개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 40 | lblMaterial, layoutControlItem1, layoutControlItem2, layoutControlItem4, layoutControlItem7, layoutControlItem5, layoutControlItem6, layoutControlItem8, layoutControlItem10, layoutControlItem11, layoutControlItem12, layoutControlItem13, layoutControlItem14, layoutControlItem15, layoutControlItem3 … |
| UsrTextBox | 26 | txtMarket, txtProdType, txtNickName, txtQty, txtLocation, txtElectrode, txtLine, txtOperation, txtFactory, txtItemType, txtItem, txtModel, txtItemId, txtMarket, txtProdType … |
| UsrButton | 9 | btnSave, usrButton2, usrButton1, usrButton5, usrButton4, usrButton3, usrButton2, usrButton1, usrButton5 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrDatePicker2 | 4 | dpPlanDate, usrDatePicker21, dpPlanDate, usrDatePicker21 |
| EmptySpaceItem | 4 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem1, emptySpaceItem2 |
| Panel | 4 | panel2, panel1, panel2, panel1 |
| Label | 4 | label1, label2, label1, label2 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrLabel | 2 | usrLabel1, usrLabel1 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| RichTextBox | 2 | txtMemo, txtMemo |
| SplitContainer | 2 | splitContainer1, splitContainer1 |
| TextBox | 1 | txtAlarm |

## 7. 확인 필요 (14건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 245 | InitControls | FP\{?default:part_service}\PICAlarm#find_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 279 | InitControls | FP\{?default:part_service}\PICAlarm#find_alarm | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 766 | usrButton3_Click | FP\{?default:part_service}\PICAlarm#max_pic_ref | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 885 | usrButton2_Click | FP\{?default:part_service}\PICAlarm#find_alarm | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 229 | InitControls | FP\{?default:part_service}\AmendMemo#find_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 245 | InitControls | FP\{?default:part_service}\AmendMemo#find_alarm | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |
| 757 | usrButton3_Click | FP\{?default:part_service}\AmendMemo#max_pic_ref | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |
| 809 | usrButton3_Click | FP\{?default:part_service}\PICAlarm#save_alarm | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 789 | usrButton3_Click | FP\{?default:part_service}\AmendMemo#save_alarm | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |
| 813 | usrButton3_Click | FP\{?default:part_service}\PICAlarm#save_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 821 | usrButton3_Click | FP\{?default:part_service}\PICAlarm#save_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 791 | usrButton3_Click | FP\{?default:part_service}\AmendMemo#save_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 708 | SpdMain_Changed | FP\{?default:part_service}\PICAlarm#get_userinfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 604 | SpdMain_Changed | FP\{?default:part_service}\AmendMemo#get_userinfo | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 15 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 608 | SystemManager.UP_FX_GetUserInfoList | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FPC0111 | AlarmEditPopup | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | FPC0111 | Item Popup | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | FPC0111 | ItemPopup | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: AlarmEditPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:360, SetSheetHeaderColumn_FP@InitSpread:326

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 1314 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1315 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1316 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1317 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1252 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1253 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1254 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1255 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| AlarmEditPopup | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| Item Popup | 메타 정의만, 코드 미참조(미사용 가능) | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| ItemPopup | 메타 정의만, 코드 미참조(미사용 가능) | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

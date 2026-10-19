# FPC0121 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0121_AlarmEditPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 1377 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0121_AlarmEditPopup.designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 1676 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:dsdmMain.Changed | SpdMain_Changed | 1011 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_userinfo] | BIZ_MATCH |  |
| event:dsdmMain.Changed | SpdMain_Changed | 1011 | FP\Common\PICAlarm#get_userinfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_get_userinfo.sql |
| button:FindButton | FindButton > FindData | 728 | FP_Common.PR_UI_COMMON_POPUP | MATCH | SP PR_UI_COMMON_POPUP |
| event:this.btnSave.Click | btnSave_Click | 1078 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=max_pic_ref] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click | 1078 | FP\Common\PICAlarm#max_pic_ref | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_max_pic_ref.sql |
| event:this.btnSave.Click | btnSave_Click | 1154 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_alarm] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click | 1154 | FP\Common\PICAlarm#save_alarm | MATCH_PATTERN | [update-batch]  |
| event:this.btnSave.Click | btnSave_Click | 1158 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_pic_memo] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click | 1158 | FP\Common\PICAlarm#save_pic_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_save_pic_memo.sql |
| event:this.btnSave.Click | btnSave_Click | 1166 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_pic_memo] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click | 1166 | FP\Common\PICAlarm#save_pic_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_save_pic_memo.sql |
| event:this.Load | Form_Load > InitControls | 246 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_color_memo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 246 | FP\Common\PICAlarm#find_color_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_color_memo.sql |
| event:this.Load | Form_Load > InitControls | 298 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 298 | FP\Common\PICAlarm#find_alarm | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_alarm.sql |
| event:this.Load | Form_Load > InitControls | 361 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > RefreshCateCombo | 425 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > RefreshCateCombo | 425 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.Load | Form_Load > InitControls > RefreshCateCombo | 426 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > RefreshCateCombo | 426 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.Load | Form_Load > InitControls > RefreshColorCombo | 592 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.usrButton2.Click | usrButton2_Click | 1230 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] | BIZ_MATCH |  |
| event:this.usrButton2.Click | usrButton2_Click | 1230 | FP\Common\PICAlarm#find_alarm | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_alarm.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_pic_memo] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_color_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_userinfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=max_pic_ref] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_alarm] | BIZ_MATCH | 1 |  |  |  |
| FP_Common.PR_UI_COMMON_POPUP | MATCH | 1 | SP PR_UI_COMMON_POPUP | EXEC:PR_UI_COMMON_POPUP | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 2 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\Common\PICAlarm#find_alarm | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_PICAlarm_find_alarm.sql | SELECT:FP_AMEND_PIC_ALARM |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_color_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_color_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\PICAlarm#get_userinfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_get_userinfo.sql | SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER |  |
| FP\Common\PICAlarm#max_pic_ref | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_max_pic_ref.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\PICAlarm#save_alarm | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\PICAlarm#save_pic_memo | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_PICAlarm_save_pic_memo.sql | MERGE:FP_AMEND_MEMO_M, SELECT:TH_UIS_CAL, REF:FN_SITE_TIME, SELECT:SCM_FACTORY_M, INSERT:HIS_AMEND_MEMO_M, SELECT:FP_AMEND_MEMO_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnSave_Click | Filter | BUCKET_FROM, BUCKET_TO, MEMO, USER_ID, ALARM_TIME, ALARM_YN, PIC_REF, SETUP_COLOR_CODE, ATTR1, ATTR2, ATTR3, ATTR4, ATTR5 |
| btnSave_Click | max_pic_ref.Tables[0].Rows[0] | PIC_REF |
| btnSave_Click | insRow | PIC_REF, P_USER_ID, USER_NAME, DEPT_NAME, EMAIL, PHONE, USER_ID |
| btnSave_Click | m_rows[0] | UI_PARAM |
| clbCategory_GetRectangleColor | dtCategoryColorInfo.Rows[e.Index] | UI_COLOR |
| ClbCategory_SelectedIndexChanged | dr | CODE, NAME |
| InitControls | SrcRow | PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, NICK_NAME, ITEM_TYPE, FACTORY_ID, MARKET, OPERATION_ID, LINE_NAME, ELECTRODE_TYPE, LOCATION, COMPANY_ID, DIVISION_ID, SITE_ID, LINE_ID, PLANT_ID, EQUIPMENT_ID |
| InitControls | Filter | USER_ID, COMPANY_ID, DIVISION_ID, SITE_ID, LINE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET, PLAN_DATE, EQUIPMENT_ID, ELECTRODE_TYPE, ITEM_ID, BUCKET_FROM, BUCKET_TO, OLD_PIC_REF, PIC_REF, INSTANCE_ID, SEQ |
| InitControls | MemoRow | ATTR1, ATTR2 |
| InitControls | memoInfo.Tables[0].Rows[0] | MEMO, ALARM_YN, ALARM_TIME, PIC_REF |
| InitControls | ro | USERID, DEPT_NAME, USER_NAME, EMAIL, PHONE |
| RefreshCateCombo | nn | UI_PARAM, UI_DESC, UI_COLOR, COLOR_A, COLOR_B |
| RefreshCateCombo | cate | SEGMENT1, ATTRIBUTE2, ATTRIBUTE10 |
| RefreshCateCombo | arow | UI_PARAM, UI_COLOR |
| RefreshCateCombo | ress[0] | UI_COLOR, COLOR_B |
| RefreshCateCombo | ro | CODE, UI_PARAM, NAME, UI_DESC |
| RefreshCateCombo | dictCateColor | Default |
| RefreshCateCombo | dtCategoryColorInfo.Rows[i] | UI_DESC, UI_COLOR |
| RefreshColorCombo | Filter | INSTANCE_ID |
| RefreshColorCombo | dtEtcColorInfo.Rows[i] | UI_DESC, UI_COLOR |
| SelectCateCombo | dr | CODE, NAME |
| SelectColorCombo | dtEtcColorInfo.Rows[i] | UI_PARAM |
| SpdMain_Changed | param | USER_ID |
| SpdMain_Changed | dsUser.Rows[0] | UserName, Dept_Name |
| usrButton2_Click | memoPopup.Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, PLAN_ID, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, USER_ID |
| usrButton2_Click | Filter | INSTANCE_ID, PLAN_ID, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, PIC_REF |
| usrButton2_Click | selected[i] | PIC_REF |
| usrButton2_Click | row | USERID, DEPT_NAME, USER_NAME, EMAIL, PHONE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| HasMemoAuthority | InitControls:170 | UserService.HasMemoAuthority | NowGroupID |
| FP_PseudoBatch2 | btnSave_Click:1154 | DataService.FP_PseudoBatch2 | COUNT, EXCEPTION, RESULT |
| ReadResult | btnSave_Click:1155 | DataService.ReadResult | COUNT, EXCEPTION, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:137 |
| dsdmMain | Changed | SpdMain_Changed | InitControls:305 |
| dsdmMain | Changed | SpdMain_Changed | InitControls:336 |
| clbCategory | SelectedIndexChanged | ClbCategory_SelectedIndexChanged | InitControls:372 |
| dsdmMain | Changed | SpdMain_Changed | usrButton5_Click:903 |
| dsdmMain | Changed | SpdMain_Changed | usrButton5_Click:932 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:987 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:999 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:1022 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:1035 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:1040 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:1046 |
| dsdmMain | Changed | SpdMain_Changed | usrButton2_Click:1291 |
| dsdmMain | Changed | SpdMain_Changed | usrButton2_Click:1314 |
| this.cboColorBox | DrawItem | cboColorBox_DrawItem | InitializeComponent:269 |
| this.clbCategory | GetRectangleColor | clbCategory_GetRectangleColor | InitializeComponent:312 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:351 |
| this.btnDelete | Click | usrButton5_Click | InitializeComponent:1352 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1365 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1366 |
| this.btnInsert | Click | usrButton4_Click | InitializeComponent:1485 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:1544 |

## 6. 컨트롤 (59개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 21 | lblMaterial, layoutControlItem1, layoutControlItem2, layoutControlItem4, layoutControlItem7, layoutControlItem5, layoutControlItem6, layoutControlItem8, layoutControlItem10, layoutControlItem11, layoutControlItem12, layoutControlItem13, layoutControlItem14, layoutControlItem15, layoutControlItem3 … |
| UsrTextBox | 13 | txtMarket, txtProdType, txtNickName, txtQty, txtLocation, txtElectrode, txtLine, txtOperation, txtFactory, txtItemType, txtItem, txtModel, txtItemId |
| UsrButton | 5 | usrButton2, usrButton1, btnDelete, btnInsert, btnSave |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrDatePicker2 | 2 | dpPlanDate, usrDatePicker21 |
| Panel | 2 | panel2, panel1 |
| Label | 2 | label1, label2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateTimePickerWtWeek | 1 | dtAlarm |
| UsrComboBox | 1 | cboColorBox |
| UsrColorCheckList | 1 | clbCategory |
| UsrLabel | 1 | usrLabel1 |
| EmptySpaceItem | 1 | emptySpaceItem1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| RichTextBox | 1 | txtMemo |
| SplitContainer | 1 | splitContainer1 |

## 7. 확인 필요 (10건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 246 | InitControls | FP\{?default:part_service}\PICAlarm#find_color_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 298 | InitControls | FP\{?default:part_service}\PICAlarm#find_alarm | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1078 | btnSave_Click | FP\{?default:part_service}\PICAlarm#max_pic_ref | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1230 | usrButton2_Click | FP\{?default:part_service}\PICAlarm#find_alarm | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1154 | btnSave_Click | FP\{?default:part_service}\PICAlarm#save_alarm | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1158 | btnSave_Click | FP\{?default:part_service}\PICAlarm#save_pic_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1166 | btnSave_Click | FP\{?default:part_service}\PICAlarm#save_pic_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 425 | RefreshCateCombo | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 426 | RefreshCateCombo | FP\{?default:part_service}\PICAlarm#find_Category_Color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1011 | SpdMain_Changed | FP\{?default:part_service}\PICAlarm#get_userinfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 15 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FPC0121 | AlarmEditPopup | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | FPC0121 | Item Popup | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | FPC0121 | ItemPopup | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: AlarmEditPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:663

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 1382 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1383 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1384 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1385 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| AlarmEditPopup | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| Item Popup | 메타 정의만, 코드 미참조(미사용 가능) | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| ItemPopup | 메타 정의만, 코드 미참조(미사용 가능) | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

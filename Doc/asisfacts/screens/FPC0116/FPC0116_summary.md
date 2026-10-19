# FPC0116 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0116_AlarmEditPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 959 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0116_AlarmEditPopup.designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 1567 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:dsdmMain.Changed | SpdMain_Changed | 687 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_userinfo] | BIZ_MATCH |  |
| event:dsdmMain.Changed | SpdMain_Changed | 687 | FP\Common\PICAlarm#get_userinfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_get_userinfo.sql |
| button:FindButton | FindButton > FindData | 404 | FP_Common.PR_UI_COMMON_POPUP | MATCH | SP PR_UI_COMMON_POPUP |
| event:this.btnSave.Click | usrButton3_Click | 745 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=max_pic_ref] | BIZ_MATCH |  |
| event:this.btnSave.Click | usrButton3_Click | 745 | FP\Common\PICAlarm#max_pic_ref | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_max_pic_ref.sql |
| event:this.btnSave.Click | usrButton3_Click | 788 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_alarm] | BIZ_MATCH |  |
| event:this.btnSave.Click | usrButton3_Click | 788 | FP\Common\PICAlarm#save_alarm | MATCH_PATTERN | [update-batch]  |
| event:this.btnSave.Click | usrButton3_Click | 792 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] | BIZ_MATCH |  |
| event:this.btnSave.Click | usrButton3_Click | 792 | FP\Common\PICAlarm#save_memo | MATCH_PATTERN | [update-batch]  |
| event:this.btnSave.Click | usrButton3_Click | 800 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] | BIZ_MATCH |  |
| event:this.btnSave.Click | usrButton3_Click | 800 | FP\Common\PICAlarm#save_memo | MATCH_PATTERN | [update-batch]  |
| event:this.Load | Form_Load > InitControls | 224 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 224 | FP\Common\PICAlarm#find_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_memo.sql |
| event:this.Load | Form_Load > InitControls | 258 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 258 | FP\Common\PICAlarm#find_alarm | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_alarm.sql |
| event:this.usrButton2.Click | usrButton2_Click | 864 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] | BIZ_MATCH |  |
| event:this.usrButton2.Click | usrButton2_Click | 864 | FP\Common\PICAlarm#find_alarm | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_alarm.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_userinfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=max_pic_ref] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_alarm] | BIZ_MATCH | 1 |  |  |  |
| FP_Common.PR_UI_COMMON_POPUP | MATCH | 1 | SP PR_UI_COMMON_POPUP | EXEC:PR_UI_COMMON_POPUP | ⚠ DB에 SP 없음 |
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
| usrButton3_Click | Filter | BUCKET_FROM, BUCKET_TO, MEMO, USER_ID, PIC_REF |
| usrButton3_Click | max_pic_ref.Tables[0].Rows[0] | PIC_REF |
| usrButton3_Click | insRow | PIC_REF, P_USER_ID, USER_NAME, DEPT_NAME, EMAIL, PHONE, USER_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| HasMemoAuthority | InitControls:167 | UserService.HasMemoAuthority | NowGroupID |
| FP_PseudoBatch2 | usrButton3_Click:788 | DataService.FP_PseudoBatch2 | COUNT, EXCEPTION, RESULT |
| ReadResult | usrButton3_Click:789 | DataService.ReadResult | COUNT, EXCEPTION, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:138 |
| dsdmMain | Changed | SpdMain_Changed | InitControls:265 |
| dsdmMain | Changed | SpdMain_Changed | InitControls:296 |
| dsdmMain | Changed | SpdMain_Changed | usrButton5_Click:579 |
| dsdmMain | Changed | SpdMain_Changed | usrButton5_Click:608 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:663 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:675 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:698 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:711 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:716 |
| dsdmMain | Changed | SpdMain_Changed | SpdMain_Changed:722 |
| dsdmMain | Changed | SpdMain_Changed | usrButton2_Click:925 |
| dsdmMain | Changed | SpdMain_Changed | usrButton2_Click:948 |
| this.btnSave | Click | usrButton3_Click | InitializeComponent:252 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:291 |
| this.usrButton5 | Click | usrButton5_Click | InitializeComponent:1284 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1297 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1298 |
| this.usrButton4 | Click | usrButton4_Click | InitializeComponent:1417 |

## 6. 컨트롤 (57개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 20 | lblMaterial, layoutControlItem1, layoutControlItem2, layoutControlItem4, layoutControlItem7, layoutControlItem5, layoutControlItem6, layoutControlItem8, layoutControlItem10, layoutControlItem11, layoutControlItem12, layoutControlItem13, layoutControlItem14, layoutControlItem15, layoutControlItem3 … |
| UsrTextBox | 13 | txtMarket, txtProdType, txtNickName, txtQty, txtLocation, txtElectrode, txtLine, txtOperation, txtFactory, txtItemType, txtItem, txtModel, txtItemId |
| UsrButton | 5 | btnSave, usrButton2, usrButton1, usrButton5, usrButton4 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrDatePicker2 | 2 | dpPlanDate, usrDatePicker21 |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem2 |
| Panel | 2 | panel2, panel1 |
| Label | 2 | label1, label2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| TextBox | 1 | txtAlarm |
| UsrLabel | 1 | usrLabel1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| RichTextBox | 1 | txtMemo |
| SplitContainer | 1 | splitContainer1 |

## 7. 확인 필요 (8건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 224 | InitControls | FP\{?default:part_service}\PICAlarm#find_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 258 | InitControls | FP\{?default:part_service}\PICAlarm#find_alarm | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 745 | usrButton3_Click | FP\{?default:part_service}\PICAlarm#max_pic_ref | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 864 | usrButton2_Click | FP\{?default:part_service}\PICAlarm#find_alarm | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 788 | usrButton3_Click | FP\{?default:part_service}\PICAlarm#save_alarm | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 792 | usrButton3_Click | FP\{?default:part_service}\PICAlarm#save_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 800 | usrButton3_Click | FP\{?default:part_service}\PICAlarm#save_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 687 | SpdMain_Changed | FP\{?default:part_service}\PICAlarm#get_userinfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: AlarmEditPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:339

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 1314 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1315 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1316 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1317 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

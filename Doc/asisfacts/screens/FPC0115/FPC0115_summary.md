# FPC0115 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0115_MemoColorEditPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 1224 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0115_MemoColorEditPopup.designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 1200 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:this.btnCateAdd.Click | btnCateAdd_Click | 886 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=edit_cate_default_color] | BIZ_MATCH |  |
| event:this.btnCateAdd.Click | btnCateAdd_Click | 886 | FP\Common\PICAlarm#edit_cate_default_color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_edit_cate_default_color.sql |
| event:this.btnCateAdd.Click | btnCateAdd_Click | 890 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_cate_color] | BIZ_MATCH |  |
| event:this.btnCateAdd.Click | btnCateAdd_Click | 890 | FP\Common\PICAlarm#get_cate_color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_get_cate_color.sql |
| event:this.btnCateAdd.Click | btnCateAdd_Click | 893 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=edit_cate_color] | BIZ_MATCH |  |
| event:this.btnCateAdd.Click | btnCateAdd_Click | 893 | FP\Common\PICAlarm#edit_cate_color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_edit_cate_color.sql |
| event:this.btnCateAdd.Click | btnCateAdd_Click | 898 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=insert_cate_color] | BIZ_MATCH |  |
| event:this.btnCateAdd.Click | btnCateAdd_Click | 898 | FP\Common\PICAlarm#insert_cate_color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_insert_cate_color.sql |
| event:this.btnCateAdd.Click | btnCateAdd_Click > RefreshCateCombo | 963 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.btnCateAdd.Click | btnCateAdd_Click > RefreshCateCombo | 963 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.btnCateAdd.Click | btnCateAdd_Click > RefreshCateCombo | 964 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.btnCateAdd.Click | btnCateAdd_Click > RefreshCateCombo | 964 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.btnClose.Click | btnClose_Click | 694 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_memo] | BIZ_MATCH |  |
| event:this.btnClose.Click | btnClose_Click | 694 | FP\Common\AmendMemo#delete_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_delete_memo.sql |
| event:this.btnColorAdd.Click | btnColorAdd_Click | 949 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=insert_amend_color] | BIZ_MATCH |  |
| event:this.btnColorAdd.Click | btnColorAdd_Click | 949 | FP\Common\PICAlarm#insert_amend_color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_insert_amend_color.sql |
| event:this.btnColorAdd.Click | btnColorAdd_Click > RefreshColorCombo | 1130 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnColorDelete.Click | btnColorDelete_Click | 927 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=delete_amend_color] | BIZ_MATCH |  |
| event:this.btnColorDelete.Click | btnColorDelete_Click | 927 | FP\Common\PICAlarm#delete_amend_color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_delete_amend_color.sql |
| event:this.btnColorDelete.Click | btnColorDelete_Click > RefreshColorCombo | 1130 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnSave.Click | btnSave_Click | 572 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_memo] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click | 572 | FP\Common\AmendMemo#delete_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_delete_memo.sql |
| event:this.btnSave.Click | btnSave_Click | 630 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_option_menu] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click | 630 | FP\Common\PICAlarm#save_option_menu | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_save_option_menu.sql |
| event:this.Load | Form_Load > InitControls | 277 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo_line_type] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 277 | FP\Common\AmendMemo#find_memo_line_type | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_find_memo_line_type.sql |
| event:this.Load | Form_Load > InitControls | 281 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 281 | FP\Common\AmendMemo#find_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_find_memo.sql |
| event:this.Load | Form_Load > InitControls | 351 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 402 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 409 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > RefreshCateCombo | 963 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > RefreshCateCombo | 963 | FP\Common\PICAlarm#find_Category | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql |
| event:this.Load | Form_Load > InitControls > RefreshCateCombo | 964 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > RefreshCateCombo | 964 | FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql |
| event:this.Load | Form_Load > InitControls > RefreshColorCombo | 1130 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_memo] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_option_menu] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=delete_amend_color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=edit_cate_color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=edit_cate_default_color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo_line_type] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_cate_color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=insert_amend_color] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=insert_cate_color] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 4 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\Common\AmendMemo#delete_memo | MATCH_PATTERN | 2 | [sql] foxquery_sql\FP_Common_AmendMemo_delete_memo.sql | MERGE:FP_AMEND_MEMO_M, SELECT:TH_UIS_CAL, INSERT:HIS_AMEND_MEMO_M, SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\AmendMemo#find_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_find_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\AmendMemo#find_memo_line_type | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_find_memo_line_type.sql | SELECT:FP_AMEND_MEMO_M, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#delete_amend_color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_delete_amend_color.sql | DELETE:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#edit_cate_color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_edit_cate_color.sql | MERGE:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#edit_cate_default_color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_edit_cate_default_color.sql | UPDATE:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#find_Category_Color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_find_Category_Color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#get_cate_color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_get_cate_color.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#insert_amend_color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_insert_amend_color.sql | INSERT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#insert_cate_color | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_insert_cate_color.sql | INSERT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Common\PICAlarm#save_option_menu | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_save_option_menu.sql | MERGE:FP_AMEND_MEMO_M, SELECT:TH_UIS_CAL, REF:FN_SITE_TIME, SELECT:SCM_FACTORY_M, INSERT:HIS_AMEND_MEMO_M, SELECT:FP_AMEND_MEMO_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnCateAdd_Click | row | UI_DESC, UI_PARAM, UI_COLOR |
| btnCateAdd_Click | Filter | setup_color_id, setup_color_name, color, ATTRIBUTE1, ATTRIBUTE2 |
| btnClose_Click | Filter | BUCKET_FROM, ELECTRODE_TYPE, EQUIPMENT_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, BUCKET_TO, MEMO, USER_ID |
| btnColorAdd_Click | Filter | setup_color_id, setup_color_name, color, ATTRIBUTE1, ATTRIBUTE2 |
| btnColorDelete_Click | row | UI_DESC, UI_PARAM |
| btnColorDelete_Click | Filter | setup_color_id |
| btnSave_Click | Filter | BUCKET_FROM, PLAN_DATE, ELECTRODE_TYPE, EQUIPMENT_ID, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, BUCKET_TO, MEMO, USER_ID, INSTANCE_ID, SETUP_COLOR_CODE, ATTR1, ATTR2, ATTR3, ATTR4, ATTR5, OPERATION_ID |
| btnSave_Click | m_rows[0] | UI_PARAM |
| clbCategory_GetRectangleColor | dtCategoryColorInfo.Rows[e.Index] | UI_COLOR |
| ClbCategory_SelectedIndexChanged | dr | CODE, NAME |
| Filter | filter | INSTANCE_ID, BUCKET_FROM, PLAN_DATE, BUCKET_TO |
| GetCheckedListValues | dt.Rows[i] | CODE |
| InitControls | Filter | USER_ID, INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, LINE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET, PLAN_DATE, EQUIPMENT_ID, ELECTRODE_TYPE, ITEM_ID, MEMO_TYPE, BUCKET_FROM, BUCKET_TO, SEQ |
| InitControls | SrcRow | COMPANY_ID, DIVISION_ID, SITE_ID, LINE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET, EQUIPMENT_ID, ELECTRODE_TYPE, ITEM_ID |
| InitControls | MemoRow | ATTR1, ATTR2, ATTR3, ATTR4, CREATOR, CREATION, MEMO, BUCKET_FROM, BUCKET_TO |
| InitControls | dr | CODE |
| InitControls | dtEtcColorInfo.Rows[i] | UI_DESC, UI_COLOR, UI_PARAM |
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

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| HasMemoAuthority | InitControls:196 | UserService.HasMemoAuthority | NowGroupID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:144 |
| drpPeriod | ValueChanged | drpPeriod_changed | Form_Load:155 |
| clbCategory | SelectedIndexChanged | ClbCategory_SelectedIndexChanged | InitControls:362 |
| this.clbCategory | GetRectangleColor | clbCategory_GetRectangleColor | InitializeComponent:222 |
| this.btnColorDelete | Click | btnColorDelete_Click | InitializeComponent:263 |
| this.cbAllDay | CheckedChanged | cbAllDay_CheckedChanged | InitializeComponent:342 |
| this.cboColorBox | DrawItem | cboColorBox_DrawItem | InitializeComponent:463 |
| this.btnColorAdd | Click | btnColorAdd_Click | InitializeComponent:504 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:686 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:724 |
| this.btnCateAdd | Click | btnCateAdd_Click | InitializeComponent:765 |

## 6. 컨트롤 (41개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 18 | layoutControlItem1, layoutControlItem3, layoutControlItem4, layoutControlItem7, layoutControlItem2, layoutControlItem5, layoutControlItem12, layoutControlItem13, layoutControlItem14, layoutControlItem15, layoutControlItem16, lcColorAdd, layoutControlItem10, lcCateAdd, lcColorDelete … |
| UsrButton | 5 | btnColorDelete, btnColorAdd, btnClose, btnSave, btnCateAdd |
| UsrLabel | 5 | usrLabel2, txtCreator, txtCreation, usrLabel1, usrLabel3 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| DateTimePicker | 2 | tmEnd, tmStart |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrColorCheckList | 1 | clbCategory |
| UsrCheckedList2 | 1 | clbOperation |
| UsrCheckBox | 1 | cbAllDay |
| UsrDateRangePickerWtWeek | 1 | drpPeriod |
| UsrComboBox | 1 | cboColorBox |
| UsrTextBox | 1 | txtMemo |

## 7. 확인 필요 (13건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 277 | InitControls | FP\{?default:part_service}\AmendMemo#find_memo_line_type | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 281 | InitControls | FP\{?default:part_service}\AmendMemo#find_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 572 | btnSave_Click | FP\{?default:part_service}\AmendMemo#delete_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 630 | btnSave_Click | FP\{?default:part_service}\PICAlarm#save_option_menu | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 694 | btnClose_Click | FP\{?default:part_service}\AmendMemo#delete_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 886 | btnCateAdd_Click | FP\{?default:part_service}\PICAlarm#edit_cate_default_color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 890 | btnCateAdd_Click | FP\{?default:part_service}\PICAlarm#get_cate_color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 893 | btnCateAdd_Click | FP\{?default:part_service}\PICAlarm#edit_cate_color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 898 | btnCateAdd_Click | FP\{?default:part_service}\PICAlarm#insert_cate_color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 927 | btnColorDelete_Click | FP\{?default:part_service}\PICAlarm#delete_amend_color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 949 | btnColorAdd_Click | FP\{?default:part_service}\PICAlarm#insert_amend_color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 963 | RefreshCateCombo | FP\{?default:part_service}\PICAlarm#find_Category | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 964 | RefreshCateCombo | FP\{?default:part_service}\PICAlarm#find_Category_Color | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(행 존재, 생성 호출 미발견)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

# FPC0608 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0608_MemoAddPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 757 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0608_MemoAddPopup.designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 1954 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:this.btnMaterial.Click | btnMaterial_Click > SetValueByPopupData | 600 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 265 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 275 | FP_Planning.PR_UI_FP00608_AMEND_MEMO | MATCH | SP PR_UI_FP00608_AMEND_MEMO |
| event:this.Load | Form_Load > InitControls | 134 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 140 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_info] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 140 | FP\Common\PICAlarm#get_instance_info | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_PICAlarm_get_instance_info.sql |
| event:this.Load | Form_Load > InitControls | 145 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 166 | biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_info] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 3 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP00608_AMEND_MEMO | MATCH | 1 | SP PR_UI_FP00608_AMEND_MEMO | EXEC:PR_UI_FP00608_AMEND_MEMO | ⚠ DB에 SP 없음 |
| FP\Common\PICAlarm#get_instance_info | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_PICAlarm_get_instance_info.sql | SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_SYS_LOOKUP_VALUE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnEquipment_Click | Application.OpenForms | FPC0595_EquipmentPopup |
| btnEquipment_Click | popup.Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID |
| btnEquipment_Click | data | EQUIPMENT_ID |
| btnLine_Click | Application.OpenForms | FP00596_LinePopup |
| btnLine_Click | popup.Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, ITEM_ID |
| btnLine_Click | data | PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE |
| btnMaterial_Click | dRow | CODE, INSTANCE_TYPE |
| btnMaterial_Click | dtResult.Rows[0] | INSTANCE_TYPE |
| btnMaterial_Click | popup.Filter | INSTANCE_ID, DIVISION_ID, SITE_ID, TOP_ITEM_ID, DATE, FORM_OPERATION_ID |
| btnMaterial_Click | Application.OpenForms | FP00602_ItemPopup, FP00601_ItemPopup, FP00621_LineCN2ItemPopup |
| cboInstance_changed | dRow | CODE, INSTANCE_TYPE |
| cboInstance_changed | dtResult.Rows[0] | INSTANCE_TYPE |
| InitControls | Filter | INSTANCE_ID |
| Save_Data | dtRange.Rows[i] | _DATE |
| SetValueByPopupData | data | DIVISION_ID, SITE_ID, ITEM_ID, MODEL_ID, PLANT_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| HasMemoAuthority | InitControls:126 | UserService.HasMemoAuthority | NowGroupID |
| GetCheckedListValue | Check_Data:230, Check_Data:237, cboInstance_changed:330, cboMarket_changed:375, cboProdtype_changed:380, btnMaterial_Click:426, btnLine_Click:659, btnEquipment_Click:708 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:101 |
| cboInstance | SelectedIndexChanged | cboInstance_changed | InitEvent:183 |
| cboMarket | SelectedIndexChanged | cboMarket_changed | InitEvent:184 |
| cboProdType | SelectedIndexChanged | cboProdtype_changed | InitEvent:185 |
| this.drpPeriod | ValueChanged | drpPeriod_ValueChanged | InitializeComponent:291 |
| this.btnEquipment | Click | btnEquipment_Click | InitializeComponent:328 |
| this.btnLine | Click | btnLine_Click | InitializeComponent:556 |
| this.btnMaterial | Click | btnMaterial_Click | InitializeComponent:593 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:1268 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:1307 |

## 6. 컨트롤 (67개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 31 | layoutControlItem20, layoutControlItem7, layoutControlItem13, layoutControlItem15, layoutControlItem4, layoutControlItem16, layoutControlItem19, layoutControlItem23, layoutControlItem33, layoutControlItem24, layoutControlItem28, layoutControlItem31, layoutControlItem26, layoutControlItem6, layoutControlItem11 … |
| UsrLabel | 13 | usrLabel7, usrLabel6, usrLabel16, usrLabel15, usrLabel14, usrLabel13, usrLabel11, usrLabel10, usrLabel4, usrLabel2, usrLabel1, usrLabel3, usrLabel5 |
| UsrTextBox | 8 | txtItem, txtElectrodType, txtBuilding, txtModel, txtOperation, txtEquipment, txtMemo, txtLine |
| UsrButton | 5 | btnEquipment, btnLine, btnMaterial, btnClose, btnSave |
| UsrCombo | 3 | cboInstance, cboProdType, cboMarket |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePicker2 | 1 | drpPeriod |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 140 | InitControls | FP\{?default:part_service}\PICAlarm#get_instance_info | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

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

# FP00540 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Master.UIL\FP00540_SSP_Shipping_Plan.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 672 |
| only | 06.UIL\GSCM.FP.Master.UIL\FP00540_SSP_Shipping_Plan.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 734 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged | 484 | biz:FPCommonDataBLL.FPCommonDataList [code=SCP_PLAN] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged | 493 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged | 500 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged | 504 | biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 174 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 181 | biz:FPCommonDataBLL.FPCommonDataList [code=SCP_PLAN] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 190 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 198 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangeControl | 202 | biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged | 518 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Execute | 387 | FP_Master.PR_UI_FP00540_SSP_SHIPPING_PLAN | MATCH | SP PR_UI_FP00540_SSP_SHIPPING_PLAN |
| event:popSql.OnSql | RunSqlSource > Find_Data_Execute | 387 | FP_Master.PR_UI_FP00540_SSP_SHIPPING_PLAN | MATCH | SP PR_UI_FP00540_SSP_SHIPPING_PLAN |
| event:this.Load | Form_Load > InitControls | 158 | biz:FPCommonDataBLL.FPCommonDataList [code=TARGET_INSTANCE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 174 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 181 | biz:FPCommonDataBLL.FPCommonDataList [code=SCP_PLAN] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 190 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 198 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 202 | biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Find_Data_Excel_Execute | 443 | FP_Master.PR_UI_FP00540_SSP_SHIPPING_PLAN | MATCH | SP PR_UI_FP00540_SSP_SHIPPING_PLAN |
| unreached:(진입점 미연결) | FP00540_SaveDataDelegate | 582 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00540] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00540_SaveDataDelegate | 582 | FP\Common\FP00540_SSP_Shipping_Plan#merge_FP00540 | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | FP00540_ValidateDataDelegate | 595 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00540_ValidateDataDelegate | 595 | FP\Common\FP00540_SSP_Shipping_Plan#delete_Excel_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00540_SSP_Shipping_Plan_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | FP00540_ValidateDataDelegate | 597 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00540_ValidateDataDelegate | 597 | FP\Common\FP00540_SSP_Shipping_Plan#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | FP00540_ValidateDataDelegate | 599 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00540_ValidateDataDelegate | 599 | FP\Common\FP00540_SSP_Shipping_Plan#find_Excel_buffer_validation | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00540_SSP_Shipping_Plan_find_Excel_buffer_validation.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 3 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SCP_PLAN] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=TARGET_INSTANCE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00540] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP00540_SSP_SHIPPING_PLAN | MATCH | 2 | SP PR_UI_FP00540_SSP_SHIPPING_PLAN | EXEC:PR_UI_FP00540_SSP_SHIPPING_PLAN | ⚠ DB에 SP 없음 |
| FP\Common\FP00540_SSP_Shipping_Plan#delete_Excel_buffer | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00540_SSP_Shipping_Plan_delete_Excel_buffer.sql | DELETE:BUF_WEEKLY_DEMAND_SHIPMENT_H |  |
| FP\Common\FP00540_SSP_Shipping_Plan#find_Excel_buffer_validation | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00540_SSP_Shipping_Plan_find_Excel_buffer_validation.sql | SELECT:BUF_WEEKLY_DEMAND_SHIPMENT_H, SELECT:SCM_ITEM_M, SELECT:SCM_ITEM_CLASS_M, SELECT:SCM_PLANT_M, SELECT:TH_UIS_CAL, SELECT:SCM_FACTORY_M |  |
| FP\Common\FP00540_SSP_Shipping_Plan#insert_Excel_buffer | MATCH_PATTERN | 1 | [update-batch]  |  |  |
| FP\Common\FP00540_SSP_Shipping_Plan#merge_FP00540 | MATCH_PATTERN | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnExcelImport_Click | p.Filter | instance_id, division_id, site_id, plant_id, scp_plan_id, production_type, item_id, nick_name, user_id |
| btnExcelImport_Click | p.KeyColumns | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, SCP_PLAN_ID, SCP_TARGET_ID, FP_TARGET_ID |
| btnExcelImport_Click | p.ColumnTitle | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, SCP_PLAN_ID, SCP_TARGET_ID, FP_TARGET_ID, ITEM_ID, NICK_NAME, TO_SITE_ID, TO_PLANT_ID, CUSTOMER_ID, SHIP_WEEK, SHIP_DATE, SHIP_QTY, PRODUCTION_TYPE, TRANSPORT_MODE, BIZ_TYPE, CONFIRM_TYPE |
| btnExcelImport_Click | p.ColumnWidth | INSTANCE_ID |
| Find_Data_Excel_Execute | sp | instance_id, division_id, scp_plan_id, site_id, plant_id, production_type, item_id, nick_name |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangeControl:172, SetChangeControl:179, SetChangeControl:188, SetChangeControl:195, Find_Data_Execute:361, Find_Data_Execute:362, Find_Data_Execute:363, Find_Data_Execute:364 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:237 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| FP_UpdateBatch | FP00540_SaveDataDelegate:582, FP00540_ValidateDataDelegate:597 | DataService.FP_UpdateBatch | COUNT, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:107 |
| cboInstance | SelectedIndexChanged | CboInstance_SelectedIndexChanged | InitEvent:213 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:214 |
| cboScpPlanId | SelectedIndexChanged | CboScpPlanId_SelectedIndexChanged | InitEvent:215 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:216 |
| popSql | OnSql | RunSqlSource | btnSql_Click:272 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:429 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:471 |

## 6. 컨트롤 (27개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | lblSql, lblExcelUpload, lblInstance, lblScpPlanId, lblSite, lblDivision, lblPlant, lblProductionType, lblMaterial |
| UsrCombo | 5 | cboProductionType, cboSite, cboDivision, cboScpPlanId, cboInstance |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 2 | btnSql, btnExcelImport |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrTextBox | 1 | txtItemId |
| UsrCheckedList2 | 1 | clbPlant |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (4건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 599 | FP00540_ValidateDataDelegate | FP\{?default:part_service}\FP00540_SSP_Shipping_Plan#find_Excel_buffer_validation | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 595 | FP00540_ValidateDataDelegate | FP\{?default:part_service}\FP00540_SSP_Shipping_Plan#delete_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 582 | FP00540_SaveDataDelegate | FP\{?default:part_service}\FP00540_SSP_Shipping_Plan#merge_FP00540 | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 597 | FP00540_ValidateDataDelegate | FP\{?default:part_service}\FP00540_SSP_Shipping_Plan#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 17 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00540 | Main | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:237

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 640 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 641 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 642 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 643 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

# FP00920 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Planning.UIL\FP00920_Shipping_Result.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 1026 |
| only | 06.UIL\GSCM.FP.Planning.UIL\FP00920_Shipping_Result.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 712 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboSite.SelectedIndexChanged | cboSite_changed > GetPlant | 255 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | clbDivision_changed > GetPlant | 255 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > GetDivision | 234 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > GetSite | 241 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > GetPlant | 255 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 73 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetFactory | 263 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetOperation | 274 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetLine | 286 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FindAttribute | 673 | FP_Master.PR_UI_FP00180_FINDATTRIBUTE | MATCH | SP PR_UI_FP00180_FINDATTRIBUTE |
| unreached:(진입점 미연결) | FindFormAttribute | 693 | FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE | MATCH | SP PR_UI_FP00180_FINDFORMATTRIBUTE |
| unreached:(진입점 미연결) | FP00180_SaveDataDelegate | 749 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=FP00920_Shipping_Result_EXCEL_UPDATE_BATCH] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00180_SaveDataDelegate | 749 | FP\{?default:part_service}\FP00920_Shipping_Result#FP00920_Shipping_Result_EXCEL_UPDATE_BATCH | UNRESOLVED |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 760 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 760 | FP\{?default:part_service}\FP00920_Shipping_Result#delete_Excel_buffer | UNRESOLVED |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 764 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 764 | FP\{?default:part_service}\FP00920_Shipping_Result#insert_Excel_buffer | UNRESOLVED |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 768 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FP00180_ValidateDataDelegate | 768 | FP\{?default:part_service}\FP00920_Shipping_Result#find_Excel_buffer_validation | UNRESOLVED |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=FP00920_Shipping_Result_EXCEL_UPDATE_BATCH] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP00180_FINDATTRIBUTE | MATCH | 1 | SP PR_UI_FP00180_FINDATTRIBUTE | EXEC:PR_UI_FP00180_FINDATTRIBUTE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE | MATCH | 1 | SP PR_UI_FP00180_FINDFORMATTRIBUTE | EXEC:PR_UI_FP00180_FINDFORMATTRIBUTE | ⚠ DB에 SP 없음 |
| FP\{?default:part_service}\FP00920_Shipping_Result#delete_Excel_buffer | UNRESOLVED | 1 |  |  |  |
| FP\{?default:part_service}\FP00920_Shipping_Result#find_Excel_buffer_validation | UNRESOLVED | 1 |  |  |  |
| FP\{?default:part_service}\FP00920_Shipping_Result#FP00920_Shipping_Result_EXCEL_UPDATE_BATCH | UNRESOLVED | 1 |  |  |  |
| FP\{?default:part_service}\FP00920_Shipping_Result#insert_Excel_buffer | UNRESOLVED | 1 |  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnExcelImport_Click | p.KeyColumns | Company_id, DIVISION_ID, site_id, ITEM_ID |
| cblPlant_changed | Filter | PLANT_ID |
| cboSite_changed | Filter | SITE_ID |
| clbDivision_changed | Filter | DIVISION_ID |
| clboToSite_changed | Filter | TO_SITE_ID |
| drpPeriod_changed | Filter | BUCKET_FROM, DUE_FROM_DATE, BUCKET_TO, DUE_TO_DATE |
| FilterValidation | Filter | DIVISION_ID, PLANT_ID, DUE_FROM_DATE |
| Find_Data_Amend | Filter | DIVISION_ID, SITE_ID, PLANT_ID, TO_SITE_ID, BUCKET_FROM, BUCKET_TO |
| GetFactory | Filter | DIVISION_ID, SITE_ID, PLANT_ID |
| GetLine | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID |
| GetOperation | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| GetPeriod | Filter | DUE_FROM_DATE, DUE_TO_DATE |
| GetPlant | Filter | DIVISION_ID, SITE_ID |
| InitComponents | Filter | CUTOFF_DATE, DIVISION_ID, SITE_ID, PLANT_ID, TO_SITE_ID, BUCKET_FROM, BUCKET_TO |
| InitControls | Filter | USER_ID |
| SetColumnChangeType | siMain.ActiveSheet.Columns | QTY |
| spdMain_CellClick | dRow | CODE, NAME |
| spdMain_CellClick | bindingRow | OPERATION_ID |
| txtMaterial_changed | Filter | ITEM_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitComponents:199, InitComponents:203, InitComponents:208, InitComponents:213, Find_Data_Amend:577, Find_Data_Amend:578, Find_Data_Amend:579, Find_Data_Amend:580 | CString.GetCheckedListValue | CODE |
| FP_UpdateBatch | FP00180_SaveDataDelegate:749, FP00180_ValidateDataDelegate:764 | DataService.FP_UpdateBatch | COUNT, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:134 |
| clbDivision | SelectedIndexChanged | clbDivision_changed | InitEvent:381 |
| cboSite | SelectedIndexChanged | cboSite_changed | InitEvent:382 |
| clbPlant | SelectedIndexChanged | cblPlant_changed | InitEvent:383 |
| cboToSite | SelectedIndexChanged | clboToSite_changed | InitEvent:384 |
| txtMaterial | TextChanged | txtMaterial_changed | InitEvent:389 |
| drpPeriod | ValueChanged | drpPeriod_changed | InitEvent:391 |
| popSql | OnSql | RunSqlSource | btnSql_Click:468 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:377 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:516 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:517 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:518 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:519 |

## 6. 컨트롤 (26개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | layoutControlItem6, layoutControlItem3, lblSql, layoutControlItem8, layoutControlItem7, layoutControlItem4, layoutControlItem1 |
| EmptySpaceItem | 3 | emptySpaceItem2, emptySpaceItem4, emptySpaceItem1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCheckedList2 | 2 | clbPlant, clbDivision |
| UsrCombo | 2 | cboSite, cboToSite |
| UsrButton | 2 | btnSql, usrButton2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrTextBox | 1 | txtMaterial |
| UsrDateRangePicker2 | 1 | drpPeriod |
| ImageList | 1 | imageList1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (4건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 768 | FP00180_ValidateDataDelegate | FP\{?default:part_service}\FP00920_Shipping_Result#find_Excel_buffer_validation | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |
| 760 | FP00180_ValidateDataDelegate | FP\{?default:part_service}\FP00920_Shipping_Result#delete_Excel_buffer | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |
| 749 | FP00180_SaveDataDelegate | FP\{?default:part_service}\FP00920_Shipping_Result#FP00920_Shipping_Result_EXCEL_UPDATE_BATCH | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |
| 764 | FP00180_ValidateDataDelegate | FP\{?default:part_service}\FP00920_Shipping_Result#insert_Excel_buffer | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 11 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00920 | Main | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:369

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetColumnChangeType |  | 566 | 표시/라벨 변경 | set:CellType | CellType = {?GnlcellType} |  | if(ordinal_QTY != -1) |
| InitializeComponent |  | 535 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 536 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 537 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 538 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

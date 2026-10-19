# FP00411 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00411_FCS_Shorter_Aging_Routing.UIL\FP00411_FCS_Shorter_Aging_Routing.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00411_FCS_Shorter_Aging_Routing.UIL\FP00411_FCS_Shorter_Aging_Routing.UIL.csproj | 834 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00411_FCS_Shorter_Aging_Routing.UIL\FP00411_FCS_Shorter_Aging_Routing.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00411_FCS_Shorter_Aging_Routing.UIL\FP00411_FCS_Shorter_Aging_Routing.UIL.csproj | 795 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00411_FCS_Shorter_Aging_Routing.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00411_FCS_Shorter_Aging_Routing.UIL\FP00411_FCS_Shorter_Aging_Routing.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 792 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 792 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 792 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 792 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 792 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 792 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 215 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 215 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 792 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 792 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 792 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 792 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Line | 386 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00411] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Line | 386 | FP\MASTER\FP00411_FcsShortAging#merge_FP00411 | MATCH | [update-batch]  |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 215 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 215 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > ClbLine_SelectedIndexChanged > SetChangeControl | 792 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbLine_SelectedIndexChanged > SetChangeControl | 792 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| unreached:(진입점 미연결) | GetSite | 169 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetFactory | 176 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetPlant | 186 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_Save | 715 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00411_import] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_Save | 715 | FP\MASTER\FP00411_FcsShortAging#merge_FP00411_import | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 735 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 735 | FP\MASTER\FP00411_FcsShortAging#delete_Excel_buffer | MATCH | [sql] foxquery_sql\FP_Master_FP00411_FcsShortAging_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | Excel_CheckValidation | 739 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 739 | FP\MASTER\FP00411_FcsShortAging#insert_Excel_buffer | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 743 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Excel_CheckValidation | 743 | FP\MASTER\FP00411_FcsShortAging#find_Excel_buffer_validation | MATCH | [sql] foxquery_sql\FP_Master_FP00411_FcsShortAging_find_Excel_buffer_validation.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00411_import] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00411] | BIZ_MATCH | 1 |  |  |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\MASTER\FP00411_FcsShortAging#delete_Excel_buffer | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00411_FcsShortAging_delete_Excel_buffer.sql | DELETE:BUF_FORMATION_SHORTER_LT_M |  |
| FP\MASTER\FP00411_FcsShortAging#find_Excel_buffer_validation | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00411_FcsShortAging_find_Excel_buffer_validation.sql | SELECT:BUF_FORMATION_SHORTER_LT_M, SELECT:SCM_FACTORY_M, SELECT:SCM_ITEM_M, SELECT:SCM_ITEM_CLASS_M, SELECT:FP_FORMATION_LT_V, SELECT:SCM_OPERATION_M, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\MASTER\FP00411_FcsShortAging#insert_Excel_buffer | MATCH | 1 | [update-batch]  |  |  |
| FP\MASTER\FP00411_FcsShortAging#merge_FP00411 | MATCH | 1 | [update-batch]  | MERGE:FP_FORMATION_SHORTER_LT_M, REF:FN_SITE_TIME, INSERT:HIS_FORMATION_SHORTER_LT_M, REF:SYSDATE1, SELECT:FP_FORMATION_SHORTER_LT_M |  |
| FP\MASTER\FP00411_FcsShortAging#merge_FP00411_import | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnExcel_Click | p.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, OPERATION_ID, SHORTER_LT |
| btnExcel_Click | p.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, NICK_NAME, OPERATION_ID, BEFORE_DEGAS_ROUTE_ID, BEFORE_DEGAS_LT, BEFORE_DEGAS_LT_DAY, AFTER_DEGAS_ROUTE_ID, AFTER_DEGAS_LT, AFTER_DEGAS_LT_DAY, SHORTER_LT, MESSAGE |
| btnExcel_Click | p.ColumnWidth | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, NICK_NAME, OPERATION_ID, BEFORE_DEGAS_ROUTE_ID, BEFORE_DEGAS_LT, BEFORE_DEGAS_LT_DAY, AFTER_DEGAS_ROUTE_ID, AFTER_DEGAS_LT, AFTER_DEGAS_LT_DAY, SHORTER_LT, MESSAGE |
| btnExcel_Click | p.ColumnBgColor | SHORTER_LT |
| Find_Data_Execute | Filter | NICK_NAME, ITEM_ID |
| GetDivision | Filter | USER_ID |
| GetFactory | Filter | DIVISION_ID, SITE_ID, PLANT_ID |
| GetLine | Filter | LINE_ID |
| GetPlant | Filter | DIVISION_ID, SITE_ID |
| GetSite | Filter | DIVISION_ID |
| SetChangeControl | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID |
| SetEditMode | dbrow | EDIT_YN, CHK_BEFORE, CHK_AFTER |
| SetLookColor | dbrow | CHK_BEFORE, CHK_AFTER |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| findLineCode_Common | GetLine:194 | XpCommonCondService.findLineCode_Common | AMEND_FLAG, COMPANY_ID, CTRL_AMEND_FLAG, CTRL_COMPANY_ID, CTRL_DIVISION_ID, CTRL_DIVISION_LT, CTRL_FACTORY_ID, CTRL_FACTORY_LT, CTRL_INSTANCE_ID, CTRL_INSTANCE_ID2, CTRL_LINE_ID, CTRL_OPERATION_ID, CTRL_OPERATION_LT, CTRL_PLANT_ID, CTRL_PLANT_LT, CTRL_SAVE_FLAG, CTRL_SITE_ID, CTRL_SITE_LT, DIVISION_ID, FACTORY_ID, INSTANCE_ID, LINE_ID, OPERATION_ID, PLANT_ID, SITE_ID, USER_ID, _SAVE_AUTH |
| GetChanges | Save_Data_Line:382 | FPExtensions.GetChanges | ROW_ID |
| FP_UpdateBatch | Save_Data_Line:386, Excel_Save:715, Excel_CheckValidation:739 | DataService.FP_UpdateBatch | COUNT, RESULT |
| LockColumnFP | SetEditMode:500, SetEditMode:521 | FPExtensions.LockColumnFP | EDIT_YN |
| GetInnerTable | SetChangeControl:761, SetChangeControl:770, SetChangeControl:781, SetChangeControl:792, SetChangeControl:804, GetDivision:826 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetCheckedListValue | SetChangeControl:765, SetChangeControl:780, SetChangeControl:791, SetChangeControl:802, SetChangeControl:816 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:84 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:157 |
| clbSite | SelectedIndexChanged | ClbSite_SelectedIndexChanged | InitEvent:158 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:159 |
| clbFactory | SelectedIndexChanged | ClbFactory_SelectedIndexChanged | InitEvent:160 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:161 |
| popSql | OnSql | RunSqlSource | btnSql_Click:432 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:171 |
| this.btnExcel | Click | btnExcel_Click | InitializeComponent:211 |

## 6. 컨트롤 (28개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | lciPlant, lciFactory, lciDivision, lciLine, lciSite, lciMaterial, NickName, lblSql, layoutControlItem5 |
| UsrCheckedList2 | 5 | clbSite, clbLine, clbPlant, clbDivision, clbFactory |
| EmptySpaceItem | 3 | emptySpaceItem3, emptySpaceItem2, emptySpaceItem1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 2 | btnSql, btnExcel |
| UsrTextBox | 2 | txtItemId, txtNickName |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 19 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 7 | dbmeta_dbo_TB_FX_Favorite.csv |
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
| SCM_MST_SHEET_COLUMNS | FP00411 | Main | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:246

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 699 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 700 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 701 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 702 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

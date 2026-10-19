# FP02670 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Master.UIL\FP02670_Slurry_Batch_Master.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1191 |
| only | 06.UIL\GSCM.FP.Master.UIL\FP02670_Slurry_Batch_Master.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 764 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 200 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 206 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 212 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 218 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 230 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 240 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 249 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 200 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 206 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 212 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 218 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 230 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 240 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangeControl | 249 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangeControl | 200 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangeControl | 206 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangeControl | 212 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangeControl | 218 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangeControl | 230 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangeControl | 240 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangeControl | 249 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 200 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 206 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 212 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 218 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 230 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 240 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 249 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 200 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 206 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 212 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 218 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 230 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 240 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 249 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Execute | 512 | FP_Master.PR_UI_FP02670_SLURRY_BATCH_MASTER | MATCH | SP PR_UI_FP02670_SLURRY_BATCH_MASTER |
| event:popSql.OnSql | RunSqlSource > Find_Data_Execute | 512 | FP_Master.PR_UI_FP02670_SLURRY_BATCH_MASTER | MATCH | SP PR_UI_FP02670_SLURRY_BATCH_MASTER |
| button:SaveButton | SaveButton > Save_Data > FindData > Find_Data_Execute | 512 | FP_Master.PR_UI_FP02670_SLURRY_BATCH_MASTER | MATCH | SP PR_UI_FP02670_SLURRY_BATCH_MASTER |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Execute | 739 | FP_Master.PR_UI_FP02670_SAVE | MATCH | SP PR_UI_FP02670_SAVE |
| event:this.btnCopyGplm.Click | btnCopyGplm_Click > Save_Data_Copy > FindData > Find_Data_Execute | 512 | FP_Master.PR_UI_FP02670_SLURRY_BATCH_MASTER | MATCH | SP PR_UI_FP02670_SLURRY_BATCH_MASTER |
| event:this.btnCopyGplm.Click | btnCopyGplm_Click > Save_Data_Copy > Save_Data_Execute | 739 | FP_Master.PR_UI_FP02670_SAVE | MATCH | SP PR_UI_FP02670_SAVE |
| event:this.btnRecieveGplm.Click | btnRecieveGplm_Click > Save_Data_Receive > FindData > Find_Data_Execute | 512 | FP_Master.PR_UI_FP02670_SLURRY_BATCH_MASTER | MATCH | SP PR_UI_FP02670_SLURRY_BATCH_MASTER |
| event:this.btnRecieveGplm.Click | btnRecieveGplm_Click > Save_Data_Receive | 888 | biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_receive] | BIZ_MATCH |  |
| event:this.btnRecieveGplm.Click | btnRecieveGplm_Click > Save_Data_Receive | 888 | FP\Common\FP02670_Slurry_Batch_Master#execute_receive | MATCH_PATTERN | SP PR_XIF_PLM_WO_INSP_SPEC_R |
| event:this.btnRecieveGplm.Click | btnRecieveGplm_Click > Save_Data_Receive | 888 | biz:AppService.GeneralRunProcedureCustomTable [procedure=execute_receive] | BIZ_MATCH |  |
| event:this.btnRecieveGplm.Click | btnRecieveGplm_Click > Save_Data_Receive | 888 | FP02670_Slurry_Batch_Master#execute_receive | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > InitControls | 174 | biz:FPCommonDataBLL.YesNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 178 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 181 | biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 200 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 206 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 212 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 218 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 230 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 240 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl | 249 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralRunProcedureCustomTable [procedure=execute_receive] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 2 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_receive] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.YesNo | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP02670_SAVE | MATCH | 1 | SP PR_UI_FP02670_SAVE | EXEC:PR_UI_FP02670_SAVE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP02670_SLURRY_BATCH_MASTER | MATCH | 1 | SP PR_UI_FP02670_SLURRY_BATCH_MASTER | EXEC:PR_UI_FP02670_SLURRY_BATCH_MASTER | ⚠ DB에 SP 없음 |
| FP\Common\FP02670_Slurry_Batch_Master#execute_receive | MATCH_PATTERN | 1 | SP PR_XIF_PLM_WO_INSP_SPEC_R | EXEC:PR_XIF_PLM_WO_INSP_SPEC_R | ⚠ DB에 SP 없음 |
| FP02670_Slurry_Batch_Master#execute_receive | NOT_IN_FOXQUERY | 1 |  |  | DB에도 없음 (폐기/오타 가능) |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| EditButton | row | EDIT_YN |
| InitControls | dtCurDate.Rows[0] | CUR_DATE |
| Save_Data_Execute | row | COMPANY_ID |
| Save_Data_Receive | Filter | USER_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangeControl:198, SetChangeControl:204, SetChangeControl:210, SetChangeControl:216, SetChangeControl:228, SetChangeControl:238, SetChangeControl:247, Find_Data_Execute:489 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:123 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:273 |
| clbSite | SelectedIndexChanged | ClbSite_SelectedIndexChanged | InitEvent:274 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:275 |
| clbFactory | SelectedIndexChanged | ClbFactory_SelectedIndexChanged | InitEvent:276 |
| clbOperation | SelectedIndexChanged | ClbOperation_SelectedIndexChanged | InitEvent:277 |
| popSql | OnSql | RunSqlSource | btnSql_Click:395 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:287 |
| this.btnCopyGplm | Click | btnCopyGplm_Click | InitializeComponent:299 |
| this.btnRecieveGplm | Click | btnRecieveGplm_Click | InitializeComponent:311 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:649 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:650 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:651 |

## 6. 컨트롤 (29개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 10 | lblSql, lblCancle, lblCancle1, lblDivision, lblOperation, lblSite, lblPlant, lblFactory, lblItemId, lblNickName |
| UsrCheckedList2 | 5 | clbPlant, clbDivision, clbOperation, clbSite, clbFactory |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrTextBox | 2 | txtItemId, txtNickName |
| SimpleButton | 2 | btnCopyGplm, btnRecieveGplm |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrButton | 1 | btnSql |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (2건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 888 | Save_Data_Receive | FP\{?default:part_service}\FP02670_Slurry_Batch_Master#execute_receive | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 888 | Save_Data_Receive | FP02670_Slurry_Batch_Master#execute_receive | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 19 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
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
| SCM_MST_SHEET_COLUMNS | FP02670 | Main | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:298

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 306 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | _GPLMCHK |  |
| InitSpread |  | 307 | 표시/라벨 변경 | set:Value | Value = {?false} | _GPLMCHK |  |
| InitSpread |  | 308 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | _GPLMCHK |  |
| InitializeComponent |  | 667 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 668 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 669 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 670 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

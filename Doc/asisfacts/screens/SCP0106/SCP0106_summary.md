# SCP0106 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0106_CAPA_Loss_Plan\AssemblyUtils.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0106_CAPA_Loss_Plan\SCP0106_CAPA_Loss_Plan.csproj | 1733 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0106_CAPA_Loss_Plan\EltrUtils.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0106_CAPA_Loss_Plan\SCP0106_CAPA_Loss_Plan.csproj | 2490 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0106_CAPA_Loss_Plan\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0106_CAPA_Loss_Plan\SCP0106_CAPA_Loss_Plan.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0106_CAPA_Loss_Plan\SCP0106_CAPA_Loss_Plan.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0106_CAPA_Loss_Plan\SCP0106_CAPA_Loss_Plan.csproj | 4373 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0106_CAPA_Loss_Plan\SCP0106_CAPA_Loss_Plan.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0106_CAPA_Loss_Plan\SCP0106_CAPA_Loss_Plan.csproj | 1203 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:this.btnColumn.Click | btnColumn_Click > BeforeFindData > RefreshSheetHeader > GetSpdTitle | 1601 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > RefreshAll > RefreshOperation | 1420 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > BeforeFindData > RefreshSheetHeader > GetSpdTitle | 1601 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.cboProgressStatus.SelectedIndexChanged | cboProgressStatus_SelectedIndexChanged > cboSheetType_SelectedIndexChanged > RefreshOperation | 1420 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.cboProgressStatus.SelectedIndexChanged | cboProgressStatus_SelectedIndexChanged > cboSheetType_SelectedIndexChanged > BeforeFindData > RefreshSheetHeader > GetSpdTitle | 1601 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.cboSheetType.SelectedIndexChanged | cboSheetType_SelectedIndexChanged > RefreshOperation | 1420 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.cboSheetType.SelectedIndexChanged | cboSheetType_SelectedIndexChanged > BeforeFindData > RefreshSheetHeader > GetSpdTitle | 1601 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.cboVersion.SelectedIndexChanged | cboVersion_SelectedIndexChanged > RefreshAll > RefreshOperation | 1420 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.cboVersion.SelectedIndexChanged | cboVersion_SelectedIndexChanged > BeforeFindData > RefreshSheetHeader > GetSpdTitle | 1601 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.cboVersionSeq.SelectedIndexChanged | cboVersionSeq_SelectedIndexChanged > RefreshAll > RefreshOperation | 1420 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.cboVersionSeq.SelectedIndexChanged | cboVersionSeq_SelectedIndexChanged > BeforeFindData > RefreshSheetHeader > GetSpdTitle | 1601 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.clbFactory.SelectedIndexChanged | clbFactory_SelectedIndexChanged > RefreshOperation | 1420 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.clbLine.SelectedIndexChanged | clbLine_SelectedIndexChanged > RefreshOperation | 1420 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.clbPlant.SelectedIndexChanged | clbPlant_SelectedIndexChanged > RefreshOperation | 1420 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.clbSite.SelectedIndexChanged | clbSite_SelectedIndexChanged > RefreshOperation | 1420 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > RefreshAll > RefreshOperation | 1420 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > RefreshSheetHeader > GetSpdTitle | 1601 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.rgrpDivisionType.SelectedIndexChanged | rgrpDivisionType_SelectedIndexChanged > RefreshAll > RefreshOperation | 1420 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.rgrpDivisionType.SelectedIndexChanged | rgrpDivisionType_SelectedIndexChanged > BeforeFindData > RefreshSheetHeader > GetSpdTitle | 1601 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 75 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| SCP.SCP0104_GET_SPREAD_TITLE | MATCH | 1 | SP SCP0104_GET_SPREAD_TITLE | EXEC:SCP0104_GET_SPREAD_TITLE, REF:FN_SCP0104_GET_SPREAD_TITLE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ADJ_ULD_RT | _values | ADJ_ULD_RT |
| AfterSaveData | result.Tables[0].Rows[0] | result_code, result_cnt |
| AV_RT | _values | AV_RT |
| BM_RT | _values | BM_RT |
| CM_RT | _values | CM_RT |
| DAY_CNT | tbl.Rows[0] | DAY_CNT |
| GetCurrVersionProgessStatus | dtProgressStatusCurr.Rows[0] | PROG_STAT |
| GetMeasureIdx | tbl.Rows[0] | IDX |
| GetMeasureIndexOfTable | this._tblMeasure.Rows[r] | LOSS_CD, IDX |
| GetMeasureIndexOfTable | this._tblCurrMeasureSet.Rows[r] | MEASURE, IDX |
| GetValueFromMeasureTable | this._tblMeasure.Rows[r] | LOSS_CD |
| GetValueFromMeasureTable | this._tblCurrMeasureSet.Rows[r] | LOSS_CD |
| ID_RT | _values | ID_RT |
| Init | r | LOSS_CD, MEASURE |
| ITEM_CNT | _values | ITEM_CNT |
| LD_RT | _values | LD_RT |
| LINE_IDX | _values | LINE_IDX |
| MC_RT | _values | MC_RT |
| MR_RT | _values | MR_RT |
| NM_RT | _values | NM_RT |
| OP_RT | _values | OP_RT |
| PD_RT | _values | PD_RT |
| PF_RT | _values | PF_RT |
| PM_RT | _values | PM_RT |
| PP_RT | _values | PP_RT |
| PROD_CAPA_D | _values | PROD_CAPA_D |
| PROD_CAPA_D | t.Rows[0] | PROD_CAPA_D |
| PROD_CAPA_M | _values | PROD_CAPA_M |
| PROD_OP_RT | _values | PROD_OP_RT |
| QL_RT | _values | QL_RT |
| RefreshLine | _dt.Rows[i] | CODE, SEQ1, SEQ2 |
| RefreshOperation | dtTemp.Rows[i] | NAME |
| SCP_PROD_PLAN | _values | SCP_PROD_PLAN |
| SCP_PROD_PLAN_DDN | _values | SCP_PROD_PLAN_DDN |
| SD_RT | _values | SD_RT |
| SetLockColumnsAll | _tblOriginal.Rows[0] | SCP_PRDN_PLAN_REF_ST_YM, SCP_PRDN_PLAN_REF_END_YM |
| SetLockColumnsOneRow | _tblOriginal.Rows[0] | SCP_PRDN_PLAN_REF_ST_YM, SCP_PRDN_PLAN_REF_END_YM |
| SPEED_BASE_PPM | _values | SPEED_BASE_PPM |
| SPEED_PPM | _values | SPEED_PPM |
| TD_RT | _values | TD_RT |
| TEEP | _values | TEEP |
| THRY_CAPA_D | _values | THRY_CAPA_D |
| UD_RT | _values | UD_RT |
| WT_RT | _values | WT_RT |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| Init | .ctor:969, .ctor:1007, .ctor:1371, .ctor:1596, .ctor:2441, ShowItem:4312 | LookupService.Init | USER_ID |
| GetCheckedListValueNone | getDivision:229, getSite:623, getPlant:661, getFactory:685, getLine:709, getOperation:733, getElectrodeType:781 | CString.GetCheckedListValueNone | CODE |
| GetSpdTitle | RefreshSheetHeader:1832 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumnSCP | RefreshSheetHeader:1834 | SpreadInfo.SetSheetHeaderColumnSCP | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:2661 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:212 |
| this | Load | Form_Load | .ctor:1078 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:1859 |
| this.cboVersion | SelectedIndexChanged | cboVersion_SelectedIndexChanged | InitEvent:1860 |
| this.cboVersionSeq | SelectedIndexChanged | cboVersionSeq_SelectedIndexChanged | InitEvent:1861 |
| this.cboProgressStatus | SelectedIndexChanged | cboProgressStatus_SelectedIndexChanged | InitEvent:1862 |
| this.cboSheetType | SelectedIndexChanged | cboSheetType_SelectedIndexChanged | InitEvent:1863 |
| this.clbSite | SelectedIndexChanged | clbSite_SelectedIndexChanged | InitEvent:1864 |
| this.clbPlant | SelectedIndexChanged | clbPlant_SelectedIndexChanged | InitEvent:1865 |
| this.clbFactory | SelectedIndexChanged | clbFactory_SelectedIndexChanged | InitEvent:1866 |
| this.clbLine | SelectedIndexChanged | clbLine_SelectedIndexChanged | InitEvent:1867 |
| this.clbOperation | SelectedIndexChanged | clbOperation_SelectedIndexChanged | InitEvent:1868 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitEvent:1873 |
| this.btnItemId | Click | btnItem_Click | InitEvent:1880 |
| this.chkShowRate | CheckedChanged | chkShowRate_CheckedChanged | InitEvent:1882 |
| this.rgrpDivisionType | SelectedIndexChanged | rgrpDivisionType_SelectedIndexChanged | InitEvent:1884 |
| _defaultDataModel | Changed | _defaultDataModel_Changed | AfterFindData:2758 |
| _defaultDataModel | Changed | _defaultDataModel_Changed | AfterFindData:2761 |

## 6. 컨트롤 (45개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 17 | Division, Division3, Division1, layoutControlItem8, layoutControlItem4, ucpSheetType, layoutControlItem6, lciItem, layoutControlItem10, lciDivisionType, VersionSeq, PlanType, layoutControlItem2, lciElectrodeType, lciOperation … |
| UsrCheckedList | 6 | clbLine, clbOperation, clbFactory, clbPlant, clbSite, clbElectrodeType |
| UsrCombo | 5 | cboDivision, cboVersion, cboProgressStatus, cboSheetType, cboVersionSeq |
| EmptySpaceItem | 3 | emptySpaceItem4, emptySpaceItem1, emptySpaceItem2 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 2 | btnColumn, btnItemId |
| TextBox | 2 | txtItem, txtPlanType |
| ImageList | 1 | imageList1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCheckBox | 1 | chkShowRate |
| RadioGroup | 1 | rgrpDivisionType |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 372 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 8 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 226 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 109 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 244 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 4 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 12 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0106 | 1ST_CUTOFF_LINE_ASSEMBLY | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 |
| SCM_MST_SHEET_COLUMNS | SCP0106 | 1ST_CUTOFF_LINE_ELTR | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_COLUMNS | SCP0106 | 2ND_CUTOFF_LINE_ASSEMBLY | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 |
| SCM_MST_SHEET_COLUMNS | SCP0106 | 2ND_CUTOFF_LINE_ELTR | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_COLUMNS | SCP0106 | CURRENT_ASSEMBLY | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 |
| SCM_MST_SHEET_COLUMNS | SCP0106 | CURRENT_ELTR | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 | 30/0 |
| SCM_MST_SHEET_COLUMNS | SCP0106 | CUTOFF_MODEL_ASSEMBLY | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 |
| SCM_MST_SHEET_COLUMNS | SCP0106 | CUTOFF_MODEL_ELTR | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 |
| SCM_MST_SHEET_MEASURE | SCP0106 | 1ST_CUTOFF_LINE_ASSEMBLY | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |
| SCM_MST_SHEET_MEASURE | SCP0106 | 1ST_CUTOFF_LINE_ELTR | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |
| SCM_MST_SHEET_MEASURE | SCP0106 | 2ND_CUTOFF_LINE_ASSEMBLY | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |
| SCM_MST_SHEET_MEASURE | SCP0106 | 2ND_CUTOFF_LINE_ELTR | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |
| SCM_MST_SHEET_MEASURE | SCP0106 | CURRENT_ASSEMBLY | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 |
| SCM_MST_SHEET_MEASURE | SCP0106 | CURRENT_ELTR | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 |
| SCM_MST_SHEET_MEASURE | SCP0106 | CUTOFF_MODEL_ASSEMBLY | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 |
| SCM_MST_SHEET_MEASURE | SCP0106 | CUTOFF_MODEL_ELTR | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 |

실제 SP 실행 결과 대조: 112개 시트×division 비교, 차이 6720건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: {?kvp.Key}
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumnSCP@RefreshSheetHeader:1834

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| ChangeColumnNameToCodeName |  | 1105 | 표시/라벨 변경 | set:ColumnName | ColumnName = CODE |  | if(tbl.Columns.Contains(codeColumnName)) |
| ChangeColumnNameToCodeName |  | 1110 | 표시/라벨 변경 | set:ColumnName | ColumnName = NAME |  | if(tbl.Columns.Contains(nameColumnName)) |
| RefreshColumnsVisible |  | 1899 | 표시/라벨 변경 | set:Resizable | Resizable = {?false} |  | for(c <= _si.GetMaxColumnIndex()) ⟫ if(colName.Contains("_ASSIGN_PRIORITY")) |
| RefreshColumnsVisible |  | 1909 | 표시/라벨 변경 | set:Resizable | Resizable = {?true} |  | for(c <= _si.GetMaxColumnIndex()) ⟫ else!(colName.Contains("_ASSIGN_PRIORITY")) ⟫ if(colName.Substring(0, 4).Equals("M_00")) ⟫ if(show) |
| RefreshColumnsVisible |  | 1915 | 표시/라벨 변경 | set:Resizable | Resizable = {?false} |  | for(c <= _si.GetMaxColumnIndex()) ⟫ else!(colName.Contains("_ASSIGN_PRIORITY")) ⟫ if(colName.Substring(0, 4).Equals("M_00")) ⟫ else!(show) |
| RefreshColumnsVisible |  | 1922 | 표시/라벨 변경 | set:Resizable | Resizable = {?true} |  | for(c <= _si.GetMaxColumnIndex()) ⟫ else!(colName.Contains("_ASSIGN_PRIORITY")) ⟫ else!(colName.Substring(0, 4).Equals("M_00")) ⟫ if(colName.Substring(0, 4).Equals("M_01") \|\| colName.Substring(0, 2).Equals("Y_")) |
| RefreshColumnsVisible |  | 1929 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, _sheet_idx)} |  |  |
| EditButton |  | 2555 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, _sheet_idx)} |  | if(this.IsEditMode) |
| EditButton |  | 2556 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, _sheet_idx)} |  | if(this.IsEditMode) |
| EditButton |  | 2560 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, _sheet_idx)} |  | else!(this.IsEditMode) |
| EditButton |  | 2561 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, _sheet_idx)} |  | else!(this.IsEditMode) |
| EditButton |  | 2570 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, _sheet_idx)} |  | foreach(dateCol in _sheetDateColumns) ⟫ if(this.IsEditMode) |
| EditButton |  | 2574 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, _sheet_idx)} |  | foreach(dateCol in _sheetDateColumns) ⟫ else!(this.IsEditMode) |
| InitializeComponent |  | 1079 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1080 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1081 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1082 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1ST_CUTOFF_LINE_ASSEMBLY | 메타 정의만, 코드 미참조(미사용 가능) | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 |
| 1ST_CUTOFF_LINE_ELTR | 메타 정의만, 코드 미참조(미사용 가능) | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |
| 2ND_CUTOFF_LINE_ASSEMBLY | 메타 정의만, 코드 미참조(미사용 가능) | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 |
| 2ND_CUTOFF_LINE_ELTR | 메타 정의만, 코드 미참조(미사용 가능) | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |
| CURRENT_ASSEMBLY | 메타 정의만, 코드 미참조(미사용 가능) | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 |
| CURRENT_ELTR | 메타 정의만, 코드 미참조(미사용 가능) | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 | 30 |
| CUTOFF_MODEL_ASSEMBLY | 메타 정의만, 코드 미참조(미사용 가능) | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |
| CUTOFF_MODEL_ELTR | 메타 정의만, 코드 미참조(미사용 가능) | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

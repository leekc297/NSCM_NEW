# SCP0104 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line_Assign.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\Properties\Resources.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line_Assign.csproj | 64 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line_Assign_Model.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line_Assign.csproj | 1373 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line_Assign_Model.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line_Assign.csproj | 903 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line_Assign.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line_Assign.csproj | 6108 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line_Assign.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line_Assign.csproj | 1201 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line_Assign.csproj | 1110 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line_Assign.csproj | 733 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Linen.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0104_CAPA_Line_Assign\SCP0104_CAPA_Line_Assign.csproj | 1279 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:_defaultDataModel.Changed | _defaultDataModel_Changed > CheckDummyName > CheckValidName > CheckNameOnDummyCodeDB | 2970 | SCP.SCP0104_CHECK_NAME_ON_DUMMY_CODE | MATCH | SP SCP0104_CHECK_NAME_ON_DUMMY_CODE |
| event:spdAssign.Change | spdAssign_Change > CheckDummyName > CheckValidName > CheckNameOnDummyCodeDB | 2970 | SCP.SCP0104_CHECK_NAME_ON_DUMMY_CODE | MATCH | SP SCP0104_CHECK_NAME_ON_DUMMY_CODE |
| event:this.btnColumn.Click | btnColumn_Click > BeforeFindDataAssign > RefreshSheetHeaderAssign > GetSpdTitleAssign | 2094 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > BeforeFindDataAssign > RefreshSheetHeaderAssign > GetSpdTitleAssign | 2094 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.cboVersion.SelectedIndexChanged | cboVersion_SelectedIndexChanged > BeforeFindDataAssign > RefreshSheetHeaderAssign > GetSpdTitleAssign | 2094 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.cboVersionSeq.SelectedIndexChanged | cboVersionSeq_SelectedIndexChanged > BeforeFindDataAssign > RefreshSheetHeaderAssign > GetSpdTitleAssign | 2094 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > RefreshValid | 1737 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > RefreshSheetHeaderAssign > GetSpdTitleAssign | 2094 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.rgrpDivisionType.SelectedIndexChanged | rgrpDivisionType_SelectedIndexChanged > BeforeFindDataAssign > RefreshSheetHeaderAssign > GetSpdTitleAssign | 2094 | SCP.SCP0104_GET_SPREAD_TITLE | MATCH | SP SCP0104_GET_SPREAD_TITLE |
| event:this.spdAssign.Change | spdAssign_Change > CheckDummyName > CheckValidName > CheckNameOnDummyCodeDB | 2970 | SCP.SCP0104_CHECK_NAME_ON_DUMMY_CODE | MATCH | SP SCP0104_CHECK_NAME_ON_DUMMY_CODE |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 67 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | CheckNameOnDummyCodeDB | 843 | SCP.SCP0104_CHECK_NAME_ON_DUMMY_CODE | MATCH | SP SCP0104_CHECK_NAME_ON_DUMMY_CODE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCP.SCP0104_CHECK_NAME_ON_DUMMY_CODE | MATCH | 2 | SP SCP0104_CHECK_NAME_ON_DUMMY_CODE | EXEC:SCP0104_CHECK_NAME_ON_DUMMY_CODE, EXEC:PR_SCM_SYS_LOG_BATCH, MERGE:SCP_MST_CAPA_DUMMY_CODE, SELECT:SCP_MST_CAPA_DUMMY_CODE, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0104_GET_SPREAD_TITLE | MATCH | 1 | SP SCP0104_GET_SPREAD_TITLE | EXEC:SCP0104_GET_SPREAD_TITLE, REF:FN_SCP0104_GET_SPREAD_TITLE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| AfterAddNewVersion | ds.Tables[0].Rows[0] | result_code |
| AfterSaveData | result.Tables[0].Rows[0] | result_code, result_cnt |
| AppendNewDummyCode | r | CODE_TP, CODE, NAME |
| CheckNameOnDummyCodeDB | tbl.Rows[0] | CODE |
| GetCurrVersionProgessStatus | dtProgressStatusCurr.Rows[0] | PROG_STAT |
| GetIdByName | tmp.Rows[0] | CODE |
| GetNameById | tmp.Rows[0] | NAME |
| RefreshLine | _dt.Rows[i] | CODE, SEQ1, SEQ2 |
| RefreshProgressStatus | dtProgressStatus.Rows[0] | PROG_STAT, PROG_STAT_NAME |
| SetCodeName | dtCode.Rows[0] | NAME |
| SetSpreadNameToCode | r | CODE, NAME |
| SetVisibleSheetColumns | _dt.Rows[i] | COLUMN_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | getDivision:164, getSite:192, getPlant:230, getFactory:259, getLine:288, getDivision:295, getSite:447, getPlant:509 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumnSCP | RefreshSheetHeader:586, RefreshSheetHeaderAssign:2163, RefreshSheetHeaderSOP:2187, RefreshSheetHeader:718 | SpreadInfo.SetSheetHeaderColumnSCP | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| DataBind | RefreshValid:1737 | UsrComboBox.DataBind | CODE, NAME |
| SaveData | SaveButton:4329 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| Init | ShowItem:5860 | LookupService.Init | USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:360 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:593 |
| this.clbSite | SelectedIndexChanged | clbSite_SelectedIndexChanged | InitEvent:594 |
| this.clbPlant | SelectedIndexChanged | clbPlant_SelectedIndexChanged | InitEvent:595 |
| this.clbFactory | SelectedIndexChanged | clbFactory_SelectedIndexChanged | InitEvent:596 |
| this.spdAssign | CellClick | spdAssign_CellClick | InitEvent:600 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitEvent:605 |
| this.rgrpDivisionType | SelectedIndexChanged | rgrpDivisionType_SelectedIndexChanged | InitEvent:607 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | ClearEvent:649 |
| this.clbSite | SelectedIndexChanged | clbSite_SelectedIndexChanged | ClearEvent:650 |
| this.clbSite | SelectedIndexChanged | clbSite_SelectedIndexChanged | ClearEvent:651 |
| this.clbPlant | SelectedIndexChanged | clbPlant_SelectedIndexChanged | ClearEvent:652 |
| this.clbFactory | SelectedIndexChanged | clbFactory_SelectedIndexChanged | ClearEvent:653 |
| this.spdAssign | CellClick | spdAssign_CellClick | ClearEvent:657 |
| this.spdAssign | TopChange | spdAssign_TopChange | ClearEvent:658 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | ClearEvent:662 |
| this.rgrpDivisionType | SelectedIndexChanged | rgrpDivisionType_SelectedIndexChanged | ClearEvent:664 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:213 |
| this | Load | Form_Load | .ctor:1339 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:2194 |
| this.cboVersion | SelectedIndexChanged | cboVersion_SelectedIndexChanged | InitEvent:2195 |
| this.cboVersionSeq | SelectedIndexChanged | cboVersionSeq_SelectedIndexChanged | InitEvent:2196 |
| this.clbSite | SelectedIndexChanged | clbSite_SelectedIndexChanged | InitEvent:2197 |
| this.clbPlant | SelectedIndexChanged | clbPlant_SelectedIndexChanged | InitEvent:2198 |
| this.clbFactory | SelectedIndexChanged | clbFactory_SelectedIndexChanged | InitEvent:2199 |
| this.clbLine | SelectedIndexChanged | clbLine_SelectedIndexChanged | InitEvent:2200 |
| this.clbOperation | SelectedIndexChanged | clbOperation_SelectedIndexChanged | InitEvent:2201 |
| this.spdAssign | ComboSelChange | spdAssign_ComboSelChange | InitEvent:2205 |
| this.spdAssign | Change | spdAssign_Change | InitEvent:2207 |
| this.spdAssign | CellDoubleClick | spdAssign_CellDoubleClick | InitEvent:2209 |
| this.spdAssign | CellClick | spdAssign_CellClick | InitEvent:2210 |
| this.spdAssign | TopChange | spdAssign_TopChange | InitEvent:2211 |
| this.btnSopNew | Click | btnSopNew_Click | InitEvent:2215 |
| this.btnItemId | Click | btnItem_Click | InitEvent:2218 |
| this.rgrpDivisionType | SelectedIndexChanged | rgrpDivisionType_SelectedIndexChanged | InitEvent:2220 |
| _defaultDataModel | Changed | _defaultDataModel_Changed | _defaultDataModel_Changed:2566 |
| spdAssign | Change | spdAssign_Change | _defaultDataModel_Changed:2567 |
| _defaultDataModel | Changed | _defaultDataModel_Changed | _defaultDataModel_Changed:2660 |
| spdAssign | Change | spdAssign_Change | _defaultDataModel_Changed:2661 |
| _defaultDataModel | Changed | _defaultDataModel_Changed | AfterFindDataAssign:4507 |
| _defaultDataModel | Changed | _defaultDataModel_Changed | AfterFindDataAssign:4510 |
| _defaultDataModel | Changed | _defaultDataModel_Changed | spdAssign_CellDoubleClick:5737 |
| spdAssign | Change | spdAssign_Change | spdAssign_CellDoubleClick:5738 |
| _defaultDataModel | Changed | _defaultDataModel_Changed | spdAssign_CellDoubleClick:5746 |
| spdAssign | Change | spdAssign_Change | spdAssign_CellDoubleClick:5747 |
| this | Load | Form_Load | .ctor:451 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:725 |
| this.clbSite | SelectedIndexChanged | clbSite_SelectedIndexChanged | InitEvent:726 |
| this.clbPlant | SelectedIndexChanged | clbPlant_SelectedIndexChanged | InitEvent:727 |
| this.clbFactory | SelectedIndexChanged | clbFactory_SelectedIndexChanged | InitEvent:728 |
| this.clbLine | SelectedIndexChanged | clbLine_SelectedIndexChanged | InitEvent:729 |
| this.clbOperation | SelectedIndexChanged | clbOperation_SelectedIndexChanged | InitEvent:730 |
| this.spdAssign | CellClick | spdAssign_CellClick | InitEvent:734 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitEvent:739 |
| this.rgrpDivisionType | SelectedIndexChanged | rgrpDivisionType_SelectedIndexChanged | InitEvent:741 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | ClearEvent:783 |
| this.clbSite | SelectedIndexChanged | clbSite_SelectedIndexChanged | ClearEvent:784 |
| this.clbPlant | SelectedIndexChanged | clbPlant_SelectedIndexChanged | ClearEvent:785 |
| this.clbFactory | SelectedIndexChanged | clbFactory_SelectedIndexChanged | ClearEvent:786 |
| this.clbLine | SelectedIndexChanged | clbLine_SelectedIndexChanged | ClearEvent:787 |
| this.clbOperation | SelectedIndexChanged | clbOperation_SelectedIndexChanged | ClearEvent:788 |
| this.spdAssign | CellClick | spdAssign_CellClick | ClearEvent:792 |
| this.spdAssign | TopChange | spdAssign_TopChange | ClearEvent:793 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | ClearEvent:797 |
| this.rgrpDivisionType | SelectedIndexChanged | rgrpDivisionType_SelectedIndexChanged | ClearEvent:799 |

## 6. 컨트롤 (171개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 46 | Division, layoutControlItem8, layoutControlItem2, layoutControlItem4, layoutControlItem6, lciDivisionType, layoutControlItem1, Division, Division1, layoutControlItem8, layoutControlItem2, lciOperation, lciItem, lciElectrodeType, layoutControlItem4 … |
| EmptySpaceItem | 33 | emptySpaceItem3, emptySpaceItem7, emptySpaceItem9, emptySpaceItem11, emptySpaceItem2, emptySpaceItem12, emptySpaceItem6, emptySpaceItem4, emptySpaceItem6, emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem3, emptySpaceItem7, emptySpaceItem9 … |
| UsrCheckedList | 22 | clbLine, clbFactory, clbPlant, clbSite, clbLine, clbOperation, clbFactory, clbPlant, clbElectrodeType, clbSite, clbLine, clbOperation, clbFactory, clbPlant, clbElectrodeType … |
| UsrLayoutControl | 8 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 8 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 8 | cboDivision, cboDivision, cboVersion, cboVersionSeq, cboDivision, cboDivision, cboVersion, cboVersionSeq |
| FpSpread | 6 | spdAssign, spdAssign, spdSOP, spdAssign, spdAssign, spdSOP |
| SheetView | 6 | spdMain_Sheet1, spdMain_Sheet1, spdSOP_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdSOP_Sheet1 |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| RadioGroup | 4 | rgrpDivisionType, rgrpDivisionType, rgrpDivisionType, rgrpDivisionType |
| ImageList | 4 | imageList1, imageList1, imageList1, imageList1 |
| UsrButton | 4 | btnColumn, btnItemId, btnAddVersion, btnItemId |
| TextBox | 4 | txtItem, txtPlanType, txtItem, txtPlanType |
| TabPage | 4 | tabAssign, tabSOP, tabAssign, tabSOP |
| UsrButtonList | 2 | btnButtonList, btnButtonList |
| UsrComboBox | 2 | cboValid, cboValid |
| TabControl | 2 | tbcAll, tbcAll |
| Panel | 2 | panel1, panel1 |
| Button | 2 | btnSopNew, btnSopNew |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 134 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 139 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_COLUMNS_SCP0104_valid_N | 4 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS_SCP0104_valid_N.csv |
| dbo.SCM_MST_TITLESET_USER | 181 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 3 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 10 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0104 | ASSEMBLY | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 |
| SCM_MST_SHEET_COLUMNS | SCP0104 | ELTR | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 |
| SCM_MST_SHEET_COLUMNS | SCP0104 | LINE | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |
| SCM_MST_SHEET_COLUMNS | SCP0104 | SOP_ASSEMBLY | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 |
| SCM_MST_SHEET_COLUMNS | SCP0104 | SOP_ELTR | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 | 20/0 |
| SCM_MST_SHEET_COLUMNS | SCP0104 | SOP_MODEL_ASSEMBLY | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |
| SCM_MST_SHEET_COLUMNS | SCP0104 | SOP_MODEL_ELTR | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |

실제 SP 실행 결과 대조: 98개 시트×division 비교, 차이 2940건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: LINE, ASSEMBLY, ELTR, SOP_ASSEMBLY, SOP_ELTR, SOP_MODEL_ASSEMBLY, SOP_MODEL_ELTR
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumnSCP@RefreshSheetHeader:586, SetSheetHeaderColumnSetInfo@RefreshSheetHeaderAssign:2161, SetSheetHeaderColumnSCP@RefreshSheetHeaderAssign:2163, SetSheetHeaderColumnSCP@RefreshSheetHeaderSOP:2187, SetSheetHeaderColumnSCP@RefreshSheetHeader:718
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): AddSelectCheckColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| ChangeColumnNameToCodeName |  | 490 | 표시/라벨 변경 | set:ColumnName | ColumnName = CODE |  | if(tbl.Columns.Contains(codeColumnName)) |
| ChangeColumnNameToCodeName |  | 495 | 표시/라벨 변경 | set:ColumnName | ColumnName = NAME |  | if(tbl.Columns.Contains(nameColumnName)) |
| AddSelectCheckColumn |  | 678 | 하드코딩 | AddCheckColumn | V | CHK |  |
| AddSelectCheckColumn |  | 686 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK |  |
| AddSelectCheckColumn |  | 687 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK |  |
| AddSelectCheckColumn |  | 688 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK |  |
| InitializeComponent |  | 759 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 760 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 761 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 762 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| ChangeColumnNameToCodeName |  | 1380 | 표시/라벨 변경 | set:ColumnName | ColumnName = CODE |  | if(tbl.Columns.Contains(codeColumnName)) |
| ChangeColumnNameToCodeName |  | 1385 | 표시/라벨 변경 | set:ColumnName | ColumnName = NAME |  | if(tbl.Columns.Contains(nameColumnName)) |
| SetVisibleSheetColumns |  | 4378 | 표시/라벨 변경 | SetVisibleSheetColumn | {p:si} |  | if(isPageSOP) |
| SetVisibleSheetColumns |  | 4404 | 표시/라벨 변경 | SetVisibleSheetColumn | {p:si} |  | else!(isPageSOP) ⟫ if(!this.IsEditModes["DIC_GET_CAPA_LINE_ASSIGN"]) |
| SetVisibleSheetColumns |  | 4424 | 표시/라벨 변경 | SetVisibleSheetColumn | {p:si} |  | else!(isPageSOP) ⟫ if(!this.IsEditModes["DIC_GET_CAPA_LINE_ASSIGN"]) ⟫ if(_dt != null) ⟫ for(i < _dt.Rows.Count) ⟫ if(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "DIVISION_ID") |
| SetVisibleSheetColumns |  | 4428 | 표시/라벨 변경 | SetVisibleSheetColumn | {p:si} |  | else!(isPageSOP) ⟫ if(!this.IsEditModes["DIC_GET_CAPA_LINE_ASSIGN"]) ⟫ if(_dt != null) ⟫ for(i < _dt.Rows.Count) ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "DIVISION_ID") ⟫ if(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "LINE_NAME") |
| SetVisibleSheetColumns |  | 4433 | 표시/라벨 변경 | SetVisibleSheetColumn | {p:si} |  | else!(isPageSOP) ⟫ if(!this.IsEditModes["DIC_GET_CAPA_LINE_ASSIGN"]) ⟫ if(_dt != null) ⟫ for(i < _dt.Rows.Count) ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "DIVISION_ID") ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "LINE_NAME") ⟫ if(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "PLANT_NAME") |
| SetVisibleSheetColumns |  | 4438 | 표시/라벨 변경 | SetVisibleSheetColumn | {p:si} |  | else!(isPageSOP) ⟫ if(!this.IsEditModes["DIC_GET_CAPA_LINE_ASSIGN"]) ⟫ if(_dt != null) ⟫ for(i < _dt.Rows.Count) ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "DIVISION_ID") ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "LINE_NAME") ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "PLANT_NAME") ⟫ if(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "FACTORY_NAME") |
| SetVisibleSheetColumns |  | 4443 | 표시/라벨 변경 | SetVisibleSheetColumn | {p:si} |  | else!(isPageSOP) ⟫ if(!this.IsEditModes["DIC_GET_CAPA_LINE_ASSIGN"]) ⟫ if(_dt != null) ⟫ for(i < _dt.Rows.Count) ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "DIVISION_ID") ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "LINE_NAME") ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "PLANT_NAME") ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "FACTORY_NAME") ⟫ if(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "OPERATION_NAME") |
| SetVisibleSheetColumns |  | 4450 | 표시/라벨 변경 | SetVisibleSheetColumn | {p:si} |  | else!(isPageSOP) ⟫ else!(!this.IsEditModes["DIC_GET_CAPA_LINE_ASSIGN"]) |
| SetVisibleSheetColumns |  | 4468 | 표시/라벨 변경 | SetVisibleSheetColumn | {p:si} |  | else!(isPageSOP) ⟫ else!(!this.IsEditModes["DIC_GET_CAPA_LINE_ASSIGN"]) ⟫ if(_dt != null) ⟫ for(i < _dt.Rows.Count) ⟫ if(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "DIVISION_ID") |
| SetVisibleSheetColumns |  | 4472 | 표시/라벨 변경 | SetVisibleSheetColumn | {p:si} |  | else!(isPageSOP) ⟫ else!(!this.IsEditModes["DIC_GET_CAPA_LINE_ASSIGN"]) ⟫ if(_dt != null) ⟫ for(i < _dt.Rows.Count) ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "DIVISION_ID") ⟫ if(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "LINE_NAME") |
| SetVisibleSheetColumns |  | 4477 | 표시/라벨 변경 | SetVisibleSheetColumn | {p:si} |  | else!(isPageSOP) ⟫ else!(!this.IsEditModes["DIC_GET_CAPA_LINE_ASSIGN"]) ⟫ if(_dt != null) ⟫ for(i < _dt.Rows.Count) ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "DIVISION_ID") ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "LINE_NAME") ⟫ if(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "PLANT_NAME") |
| SetVisibleSheetColumns |  | 4482 | 표시/라벨 변경 | SetVisibleSheetColumn | {p:si} |  | else!(isPageSOP) ⟫ else!(!this.IsEditModes["DIC_GET_CAPA_LINE_ASSIGN"]) ⟫ if(_dt != null) ⟫ for(i < _dt.Rows.Count) ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "DIVISION_ID") ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "LINE_NAME") ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "PLANT_NAME") ⟫ if(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "FACTORY_NAME") |
| SetVisibleSheetColumns |  | 4487 | 표시/라벨 변경 | SetVisibleSheetColumn | {p:si} |  | else!(isPageSOP) ⟫ else!(!this.IsEditModes["DIC_GET_CAPA_LINE_ASSIGN"]) ⟫ if(_dt != null) ⟫ for(i < _dt.Rows.Count) ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "DIVISION_ID") ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "LINE_NAME") ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "PLANT_NAME") ⟫ else!(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "FACTORY_NAME") ⟫ if(_dt.Rows["0"]["COLUMN_NAME"].ToString() == "OPERATION_NAME") |
| InitializeComponent |  | 984 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 985 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 986 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 987 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1047 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1048 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1049 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1050 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| ChangeColumnNameToCodeName |  | 390 | 표시/라벨 변경 | set:ColumnName | ColumnName = CODE |  | if(tbl.Columns.Contains(codeColumnName)) |
| ChangeColumnNameToCodeName |  | 395 | 표시/라벨 변경 | set:ColumnName | ColumnName = NAME |  | if(tbl.Columns.Contains(nameColumnName)) |
| AddSelectCheckColumn |  | 548 | 하드코딩 | AddCheckColumn | V | CHK |  |
| AddSelectCheckColumn |  | 555 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK |  |
| AddSelectCheckColumn |  | 556 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK |  |
| AddSelectCheckColumn |  | 557 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK |  |
| InitializeComponent |  | 627 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 628 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 629 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 630 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1050 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1051 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1052 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1053 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1113 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1114 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1115 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1116 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| ASSEMBLY | META+코드연결 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 |
| ELTR | META+코드연결 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 |
| LINE | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |
| SOP_ASSEMBLY | META+코드연결 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 |
| SOP_ELTR | META+코드연결 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 |
| SOP_MODEL_ASSEMBLY | META+코드연결 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 |
| SOP_MODEL_ELTR | META+코드연결 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.

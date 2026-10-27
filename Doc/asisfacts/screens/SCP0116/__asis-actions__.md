# AS-IS 액션 대조표 — SCP0116

> 원천: `Doc/asisfacts/screens/SCP0116/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 267행 · 메서드 65 · 종류 DATA_OP 50 · GRID_INIT 35 · UI_PROP 29 · RETURN 26 · FLAG 24 · CALL_EXT 18 · GRID_SET 17 · POPUP 12 · VALUE_SET 10 · LIST_REBIND 10 · UI_MISC 9 · ENDPOINT 9 · STATE 5 · GRID_CLEAR 2 · COMBO_DATA 2 · LIST_BIND 2 · GRID_BIND 1 · GRID_LOCK 1 · CALL_BASE 1 · MESSAGE 1 · THROW 1 · STATE_RESET 1 · VALIDATE 1 · ⚠ 의미 확인 필요 19


## SCP0116_Global_PSI_Report_New_ESS.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb2a0612 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1150 |  | GRID_BIND | _SI.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-78e91ae1 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1152 |  | GRID_LOCK | _SI.LockColumn | (0, _SI.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5d845cb4 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1154 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-85522688 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1158 |  | GRID_INIT | _SI.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64333623 | this.btnColumn.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1945 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0116", sSheetName, true) | 팝업/폼 생성 |  |  |  |
| AC-230b73d3 | this.btnColumn.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1946 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6f8d50c2 | this.btnColumn.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1947 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.BtnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc47ed58 | this.btnItemId.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1889 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e10fd360 | this.btnItemId.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1890 |  | POPUP | popItem.Form_Load | (true, _division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9df71d46 | this.btnItemId.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1891 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ce743073 | this.btnItemId.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1892 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-66826d92 | this.btnItemId.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1898 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdfa79e0 | this.btnMeasure.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1905 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0116", measure, false) | 팝업/폼 생성 |  |  |  |
| AC-681fbb1f | this.btnMeasure.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1906 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0f157f02 | this.btnMeasure.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1907 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4de9c474 | this.btnMeasure.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1911 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-be130383 | this.btnMeasure.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1914 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.BtnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ece37ff | this.btnProject.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1922 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1aaa8fc5 | this.btnProject.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1924 |  | POPUP | popProject.Form_Load | (true, _division, _project) | 팝업 초기화(인자 전달) |  |  |  |
| AC-3d1451af | this.btnProject.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1925 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dff4beff | this.btnProject.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1926 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-23bc241a | this.btnProject.Click | SCP0116_Global_PSI_Report_New_ESS.cs:1932 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.CboBucketType_SelectedIndexChanged

진입점: cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6dee0df1 | cboBucketType.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1764 | if (_SI != null) | FLAG | sBucket | _bucket_type | 화면 필드/플래그 변경 |  |  |  |
| AC-9052a2b3 | cboBucketType.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1771 | if (_SI != null) ▸ if (!_SI.IsLock(_SI.SheetName)) | CALL_BASE | EditButton | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.CboDisplay_SelectedIndexChanged

진입점: cboDisplay.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3ccadb7 | cboDisplay.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1794 | if (cboDisplay.SelectedIndex == 2) | UI_PROP | this.splitContainer1.Panel1MinSize | 0 | 속성 Panel1MinSize 설정 |  |  |  |
| AC-96c52e9e | cboDisplay.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1795 | if (cboDisplay.SelectedIndex == 2) | UI_PROP | splitContainer1.SplitterDistance | 0 | 속성 SplitterDistance 설정 |  |  |  |
| AC-76811f81 | cboDisplay.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1802 | else of (cboDisplay.SelectedIndex == 2) ▸ if (cboDisplay.SelectedIndex == 1) | UI_PROP | this.splitContainer1.Panel1MinSize | 100 | 속성 Panel1MinSize 설정 |  |  |  |
| AC-d3aaf22d | cboDisplay.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1803 | else of (cboDisplay.SelectedIndex == 2) ▸ if (cboDisplay.SelectedIndex == 1) | UI_PROP | splitContainer1.SplitterDistance | 750 | 속성 SplitterDistance 설정 |  |  |  |
| AC-78364384 | cboDisplay.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1810 | else of (cboDisplay.SelectedIndex == 2) ▸ else of (cboDisplay.SelectedIndex == 1) | UI_PROP | this.splitContainer1.Panel1MinSize | 100 | 속성 Panel1MinSize 설정 |  |  |  |
| AC-4c31df2d | cboDisplay.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1811 | else of (cboDisplay.SelectedIndex == 2) ▸ else of (cboDisplay.SelectedIndex == 1) | UI_PROP | splitContainer1.SplitterDistance | 270 | 속성 SplitterDistance 설정 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.CboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c5b72f4 | cboDivision.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1731 | if (fps != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (_SPD) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eadc933 | cboPlanDate.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1748 |  | FLAG | PLAN_DATE | _plan_start_yyyymmdd | 화면 필드/플래그 변경 |  |  |  |
| AC-77c8bd59 | cboPlanDate.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1749 |  | FLAG | PLAN_DATE_YYYYMM | ScpUtils.GetPlanDateYearMonth(cboPlanDate) | 화면 필드/플래그 변경 |  |  |  |
| AC-6a9d0081 | cboPlanDate.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1749 |  | CALL_EXT | ScpUtils.GetPlanDateYearMonth | (cboPlanDate) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.CboUnitQty_SelectedIndexChanged

진입점: cboUnitQty.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ace45e8 | cboUnitQty.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1828 | if (_SI == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc96add1 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:687 |  | GRID_INIT | this.AddSheet | (spdSearchLevel, SpdSheet.SearchLevel, SpdSheet.SearchLevel, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b3790c20 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:688 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.Detail, SpdSheet.Detail, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9783e7d5 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:690 |  | FLAG | siSearchLevel | GetSheetInfo(spdSearchLevel.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-ffe947b8 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:691 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-c3bdffef | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:693 |  | GRID_INIT | siSearchLevel.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8bb96f1 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:694 |  | GRID_INIT | siDetail.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.DCalendar_ValueChanged

진입점: dCalendar.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7ef4e29 | dCalendar.ValueChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1966 | if (dStart > dPlan) | MESSAGE | MessageHelper.GMessageBox | ("[조회 시작일] Plan Date 이전으로 설정해야 합니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3dbcad89 | dCalendar.ValueChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1969 | if (dStart > dPlan) | VALUE_SET | dCalendar.InitValue | sDayRange | 컨트롤 값 설정 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.DefineProperty

진입점: this.Shown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3af161cd | this.Shown | SCP0116_Global_PSI_Report_New_ESS.cs:513 |  | VALUE_SET | cboDisplay.SelectedIndex | 2 | 컨트롤 값 설정 |  |  |  |
| AC-ac6d7a2a | this.Shown | SCP0116_Global_PSI_Report_New_ESS.cs:514 |  | VALUE_SET | rgrpSearchLevel.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adef4e6c | Dispose | SCP0116_Global_PSI_Report_New_ESS.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.EnableSearchLevel

진입점: rgrpSearchLevel.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5c28a6f | rgrpSearchLevel.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1835 |  | STATE | lciSearchLevel.Enabled | !_is_detail | 컨트롤 상태 Enabled |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f84f759c | ExcelButton | SCP0116_Global_PSI_Report_New_ESS.cs:1175 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-79e3e044 | ExcelButton | SCP0116_Global_PSI_Report_New_ESS.cs:1176 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-23b82f56 | ExcelButton | SCP0116_Global_PSI_Report_New_ESS.cs:1177 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-1066cb67 | ExcelButton | SCP0116_Global_PSI_Report_New_ESS.cs:1178 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-945778b0 | ExcelButton | SCP0116_Global_PSI_Report_New_ESS.cs:1179 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-aa0a1fc8 | ExcelButton | SCP0116_Global_PSI_Report_New_ESS.cs:1180 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-7cc80c5a | ExcelButton | SCP0116_Global_PSI_Report_New_ESS.cs:1181 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-b91cecd4 | ExcelButton | SCP0116_Global_PSI_Report_New_ESS.cs:1183 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-d2070be3 | ExcelButton | SCP0116_Global_PSI_Report_New_ESS.cs:1184 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-348321a3 | ExcelButton | SCP0116_Global_PSI_Report_New_ESS.cs:1186 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-e63a2bd8 | ExcelButton | SCP0116_Global_PSI_Report_New_ESS.cs:1190 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ad2d374 | ExcelButton | SCP0116_Global_PSI_Report_New_ESS.cs:1195 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-2582b547 | ExcelButton | SCP0116_Global_PSI_Report_New_ESS.cs:1199 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.FindDataMain

진입점: cboBucketType.SelectedIndexChanged [if (_SI != null)] / cboSearchLevel.SelectedIndexChanged [if (isLoadFinish)] / FindButton [if (this._SPD.Visible)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8da7a6f9 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1217 | if (this.QueryDics[DIC_GLOBAL_PSI_NEW].Count > 0) | CALL_EXT | this.QueryDics[DIC_GLOBAL_PSI_NEW].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a46f8adc | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1222 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.BeforeFindData | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-f64c53dd | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1223 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-cdbd2cca | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1224 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_ANALYSIS_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-1d8eedac | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1225 |  | UI_PROP | qi.QueryId | "SCP.SCP0116_GET_GLOBAL_PSI_REPORT" | 속성 QueryId 설정 |  |  |  |
| AC-a9fce1b1 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1227 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_yyyymmdd", this._from_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-23b9467e | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1228 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_yyyymmdd", this._to_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f54c8728 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1229 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-62c02ae9 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1230 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", this._item_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e86d04f | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1231 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nick_name", "")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e7b1b3a | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1232 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_site", this._from_site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6cf9713e | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1233 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_site", this._to_site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad907506 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1234 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plan_start_yyyymmdd", this._plan_start_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca8f8a6b | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1235 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plan_type", this._plan_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c38210cf | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1236 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cabaa25b | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1237 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_bucket", this._bucket_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8bd44254 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1238 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_cell_group", this._cell_group)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9533be1 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1239 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_project", this._project)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a527093 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1240 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_search_level", this._search_level)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cb9e0d2 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1241 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_chk_cell_qty", this._cell_qty)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7654f0fc | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1242 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_chk_as", this._as)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ae014f9 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1243 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-29be0e27 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1246 |  | DATA_OP | this.QueryDics[DIC_GLOBAL_PSI_NEW] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |
| AC-8b8346a9 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1249 |  | ENDPOINT | this.ExecuteSQL | (_SI, DIC_GLOBAL_PSI_NEW, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-542d6d34 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:486 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getAS

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17e9fb20 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:412 |  | RETURN | return chkAS.Checked ? "Y" : "N"; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getBucketType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04ee2100 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:215 |  | RETURN | return cboBucketType.ControlValues; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getCellGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-691f6b63 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:337 |  | RETURN | return txtCellGroup.Text; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getCellQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-def8af08 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:426 |  | RETURN | return chkCellQty.Checked ? "Y" : "N"; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbbfbcd2 | this.Load 외 1 | SCP0116_Global_PSI_Report_New_ESS.cs:1382 | try ▸ switch (code) case "YEAR": | CALL_EXT | ScpUtils.GetPlanDateYear | (cboPlanDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-682d2666 | this.Load 외 1 | SCP0116_Global_PSI_Report_New_ESS.cs:1383 | try ▸ switch (code) case "YEAR": | CALL_EXT | ScpUtils.GetYearFirstDay | (plan_YYYY) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2afc177b | this.Load 외 1 | SCP0116_Global_PSI_Report_New_ESS.cs:1389 | try ▸ switch (code) case "MONTH": | CALL_EXT | ScpUtils.GetPlanDateYearMonth | (cboPlanDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ad8d54d1 | this.Load 외 1 | SCP0116_Global_PSI_Report_New_ESS.cs:1415 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a9f1f9f | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:445 |  | RETURN | return CString.GetCheckedListValue(dtMyDivision, cboDivision.ControlValues); |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getEndYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb6b68db | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:271 |  | RETURN | return dCalendar.Text2; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getFromSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc7716d9 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:290 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getFromYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e75c4678 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:229 |  | RETURN | return _start_yyyymmdd.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getIsDetail

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-214d8204 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:375 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getItemId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95d8604f | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:180 |  | RETURN | return txtItemId.Text.Trim(); |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.GetMeasureDataType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdf4f651 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1681 |  | DATA_OP | sMeasure.ToUpper().Contains | ("QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-8db78fd5 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1685 | else of (sMeasure.ToUpper().Contains("QTY")) | DATA_OP | sMeasure.ToUpper().Contains | ("AMOUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-caa92f2a | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1689 | else of (sMeasure.ToUpper().Contains("QTY")) ▸ else of (sMeasure.ToUpper().Contains("AMOUNT")) | DATA_OP | sMeasure.ToUpper().Contains | ("AMT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b47818df | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1693 | else of (sMeasure.ToUpper().Contains("QTY")) ▸ else of (sMeasure.ToUpper().Contains("AMOUNT")) ▸ else of (sMeasure.ToUpper().Contains("AMT")… | DATA_OP | sMeasure.ToUpper().Contains | ("DIO") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf8e6f08 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1717 |  | RETURN | return measure_type; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.GetPlanDate

진입점: this.Load [if (this._division != null && !this._division.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df03066c | this.Load [if (this._division != null && !this._division.Equ… | SCP0116_Global_PSI_Report_New_ESS.cs:1344 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0116_GET_PLAN_DATE") ⇒ SCP.SCP0116_GET_PLAN_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-2ef11796 | this.Load [if (this._division != null && !this._division.Equ… | SCP0116_Global_PSI_Report_New_ESS.cs:1345 |  | DATA_OP | request.Parameters["p_division_id"] | this._division | 행/컬럼 값 대입 |  |  |  |
| AC-351812c5 | this.Load [if (this._division != null && !this._division.Equ… | SCP0116_Global_PSI_Report_New_ESS.cs:1346 |  | DATA_OP | request.Parameters["p_bucket"] | this._bucket_type | 행/컬럼 값 대입 |  |  |  |
| AC-78b21261 | this.Load [if (this._division != null && !this._division.Equ… | SCP0116_Global_PSI_Report_New_ESS.cs:1347 |  | DATA_OP | request.Parameters["p_program_id"] | "SCP0116" | 행/컬럼 값 대입 |  |  |  |
| AC-00085594 | this.Load [if (this._division != null && !this._division.Equ… | SCP0116_Global_PSI_Report_New_ESS.cs:1348 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-96e3c02c | this.Load [if (this._division != null && !this._division.Equ… | SCP0116_Global_PSI_Report_New_ESS.cs:1354 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.GetPlanEndDate

진입점: this.Load [try ▸ switch (code) case "MONTH":] / cboPlanDate.SelectedIndexChanged [try ▸ switch (code) case "MONTH":]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0d37585 | this.Load [try ▸ switch (code) case "MONTH":] 외 1 | SCP0116_Global_PSI_Report_New_ESS.cs:1986 | try | COMBO_DATA | Data_REPORT.CallBizCommonData | (Data_REPORT.Type.PLAN_END_DATE , false , CommonUtils.GetValue(_division) , CommonUtils.Ge… ⇒ biz:CommonData.CommonDataList_REPORT [code={?Data_REPORT.Type.PLAN_END_DATE}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-880fe4a5 | this.Load [try ▸ switch (code) case "MONTH":] 외 1 | SCP0116_Global_PSI_Report_New_ESS.cs:1994 | try ▸ if (CommonUtils.CheckDataEmpty(dt) == false) | ENDPOINT | CommonUtils.GetDataValue | (dt) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-03d7497f | this.Load [try ▸ switch (code) case "MONTH":] 외 1 | SCP0116_Global_PSI_Report_New_ESS.cs:2001 |  | RETURN | return endDay; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getPlanStartYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3fd16e0 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:194 |  | RETURN | return CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues).ToStri… |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getPlanType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39c2bb83 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:323 |  | RETURN | return CString.GetCheckedListValue(dtPlanType, cboPlanType.ControlValues); |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getProject

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-690cdfa5 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:351 |  | RETURN | return txtProject.Text; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getSearchLevel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7547f05a | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:398 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.GetSiteList

진입점: this.Shown [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd241ed1 | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:1321 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0116_GET_SITE") ⇒ SCP.SCP0116_GET_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-9e1de65e | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:1322 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9969b556 | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:1323 |  | DATA_OP | request.Parameters["p_site_tpye"] | site_type | 행/컬럼 값 대입 |  |  |  |
| AC-4b3cc271 | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:1324 |  | DATA_OP | request.Parameters["p_division_id"] | _division | 행/컬럼 값 대입 |  |  |  |
| AC-a6b7468a | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:1325 |  | DATA_OP | request.Parameters["p_bucket"] | _bucket_type | 행/컬럼 값 대입 |  |  |  |
| AC-7ce6bfa4 | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:1327 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0f85d9a4 | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:1333 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.GetSpdTitle

진입점: this.Load / cboPlanDate.SelectedIndexChanged [if (cboSearchLevel != null)] / rgrpSearchLevel.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / dCalendar.ValueChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1d1fd3c | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:1305 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0116_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0116_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-6e9d2e20 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:1306 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | _start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cd8f71eb | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:1307 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | _end_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-85b55177 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:1309 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4a3e54a2 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:1309 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getStartYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9da2cbcf | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:257 |  | RETURN | return dCalendar.Text1; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getToSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21f0c56f | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:309 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.getToYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5023e0d5 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:243 |  | RETURN | return _end_yyyymmdd.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.GetUnitDivide

진입점: cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tables[0].Rows.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7795aaf5 | cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tab… | SCP0116_Global_PSI_Report_New_ESS.cs:1639 | if (ScpUtils.CheckDataEmpty(measure_type) == false) ▸ else of (measure_type.ToUpper().Equals("QTY")) ▸ else of (measure_type.ToUpper().Equal… | DATA_OP | measure_type.Contains | ("DIO") | 데이터 객체 조작/조회 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16e13404 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:550 |  | CALL_EXT | ScpUtils.GetCurrentTimeZone | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e972702e | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:551 |  | CALL_EXT | ScpUtils.GetDefaultTimeZone | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e47ff5a6 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:553 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-af070357 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:560 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtMyDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9d5fc6f8 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:561 | if (dtMyDivision.Rows.Count > 0) | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f47b0f52 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:571 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-44a853fe | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:572 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-7d52374c | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:573 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-ea585727 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:575 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e561c6bb | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:579 | if (dtMyDivision.Rows.Count > 0) | UI_PROP | tmpDivision.DefaultView.Sort | "CODE Asc" | 속성 Sort 설정 |  |  |  |
| AC-6d01ca89 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:580 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-192f3ff4 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:582 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e121fb98 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:584 | if (dtMyDivision.Rows.Count > 0) | STATE_RESET | dtMyDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-2561578e | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:585 | if (dtMyDivision.Rows.Count > 0) | FLAG | dtMyDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-09cb6278 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:585 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-843ca70d | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:591 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-f79912d3 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:593 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-038f7c56 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:606 | if (this._division != null && !this._division.Equals("ALL")) | FLAG | dtPlanDate | GetPlanDate() | 화면 필드/플래그 변경 |  |  |  |
| AC-acf1fb13 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:607 | if (this._division != null && !this._division.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0e790948 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:613 |  | FLAG | dtBucketType | ScpUtils.GetBucketType("CODE = 'DAILY'") | 화면 필드/플래그 변경 |  |  |  |
| AC-66b08d4a | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:613 |  | CALL_EXT | ScpUtils.GetBucketType | ("CODE = 'DAILY'") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f94849db | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:614 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3e92a35b | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:616 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |
| AC-ccb7103c | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:618 |  | FLAG | dtUnitQty | ScpUtils.GetUnitQty() | 화면 필드/플래그 변경 |  |  |  |
| AC-c65ea4da | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:618 |  | CALL_EXT | ScpUtils.GetUnitQty | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7fc27d0 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:619 |  | LIST_REBIND | clsCtrl.setListBox | (dtUnitQty, cboUnitQty, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.InitControlsAfter

진입점: this.Shown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-205cb9a4 | this.Shown | SCP0116_Global_PSI_Report_New_ESS.cs:624 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b5e8b62c | this.Shown | SCP0116_Global_PSI_Report_New_ESS.cs:625 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8361b7be | this.Shown | SCP0116_Global_PSI_Report_New_ESS.cs:631 | try ▸ if (dtSearchLevel.Rows.Count > 0) | VALUE_SET | cboSearchLevel.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-3ec25fea | this.Shown | SCP0116_Global_PSI_Report_New_ESS.cs:636 | try ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-ec01b946 | this.Shown | SCP0116_Global_PSI_Report_New_ESS.cs:638 | try | VALUE_SET | cboPlanType.SelectedValue | "FN" | 컨트롤 값 설정 |  |  |  |
| AC-e77ab091 | this.Shown | SCP0116_Global_PSI_Report_New_ESS.cs:650 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab705670 | this.Load | SCP0116_Global_PSI_Report_New_ESS.cs:480 |  | DATA_OP | QueryDics.Add | (DIC_GLOBAL_PSI_NEW, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.InitSpread

진입점: this.Load / cboPlanDate.SelectedIndexChanged [if (cboSearchLevel != null)] / rgrpSearchLevel.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / dCalendar.ValueChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d52fb32 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:703 |  | GRID_INIT | _SI.InitSheet | (_SI.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-38ba6beb | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:706 |  | GRID_INIT | _SI.SetSheetHeaderColumn | (_SI, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-a913d722 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:710 |  | GRID_INIT | _SI.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.InitSpreadDateColumn

진입점: this.Load / cboPlanDate.SelectedIndexChanged [if (cboSearchLevel != null)] / rgrpSearchLevel.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / dCalendar.ValueChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9f56d8a | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:756 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bafd906c | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:757 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a7f351f9 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:761 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e7d3d5ad | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:762 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-62eb2061 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:766 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sColumnName.StartsWith("M_")) | DATA_OP | sColumnName.Contains | (_plan_start_yyyymm) | 데이터 객체 조작/조회 |  |  |  |
| AC-e713fab5 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:768 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sColumnName.StartsWith("M_")) ▸ if (sColum… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, spdInfo.GetMaxColumnIndex()].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-3222c42b | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:773 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ else of (sColumnName.StartsWith("M_")) ▸ if (s… | DATA_OP | sColumnLabelname.Contains | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c384859 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:775 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ else of (sColumnName.StartsWith("M_")) ▸ if (s… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[1, spdInfo.GetMaxColumnIndex()].ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-f4d79419 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:777 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ else of (sColumnName.StartsWith("M_")) ▸ if (s… | DATA_OP | sColumnLabelname.Contains | ("B") | 데이터 객체 조작/조회 |  |  |  |
| AC-b1927761 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:779 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ else of (sColumnName.StartsWith("M_")) ▸ if (s… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[1, spdInfo.GetMaxColumnIndex()].ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-cf2b642e | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:788 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-481f1ff6 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:789 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "Qty", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c61bc853 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:794 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bef098bc | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:795 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "Qty", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80a6b1d2 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:803 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-88bb2165 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:804 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "Qty", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-538a8192 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:814 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8c360093 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:815 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "Qty", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd33afcf | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:816 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80c13a08 | this.Load 외 6 | SCP0116_Global_PSI_Report_New_ESS.cs:817 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "Qty", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a244ffc9 | OnShown | SCP0116_Global_PSI_Report_New_ESS.cs:497 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, 0) | 목록 컨트롤 재구성 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.RefreshDisplay

진입점: this.Shown [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bb90aad | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:534 |  | FLAG | dtDisplay | ScpUtils.GetLookupValues("STOCK_TREND_DISPLAY") | 화면 필드/플래그 변경 |  |  |  |
| AC-ede7f4a4 | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:534 |  | CALL_EXT | ScpUtils.GetLookupValues | ("STOCK_TREND_DISPLAY") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2095044 | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:535 |  | LIST_REBIND | clsCtrl.setListBox | (dtDisplay, cboDisplay, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.RefreshFromSite

진입점: this.Shown [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1b8f973 | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:524 |  | FLAG | dtFromSite | GetSiteList("FROM_SITE") | 화면 필드/플래그 변경 |  |  |  |
| AC-de9b728d | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:525 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.RefreshPlant

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d6de889 | this.Load 외 1 | SCP0116_Global_PSI_Report_New_ESS.cs:519 |  | FLAG | dtPlant | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, this._division) | 화면 필드/플래그 변경 |  |  |  |
| AC-8c545703 | this.Load 외 1 | SCP0116_Global_PSI_Report_New_ESS.cs:519 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, this._division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.RefreshPlantType

진입점: this.Shown [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c9a2719 | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:544 |  | FLAG | dtPlanType | ScpUtils.GetLookupValues("PLAN_TYPE") | 화면 필드/플래그 변경 |  |  |  |
| AC-c35a5fdc | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:544 |  | CALL_EXT | ScpUtils.GetLookupValues | ("PLAN_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2905bae2 | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:545 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.RefreshSearchLevel

진입점: this.Shown [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3908151d | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:539 |  | FLAG | dtSearchLevel | ScpUtils.GetLookupValues("PRODUCT_LEVEL") | 화면 필드/플래그 변경 |  |  |  |
| AC-fdc62abe | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:539 |  | CALL_EXT | ScpUtils.GetLookupValues | ("PRODUCT_LEVEL") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac00d83e | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:540 |  | LIST_REBIND | clsCtrl.setListBox | (dtSearchLevel, cboSearchLevel, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.RefreshToSite

진입점: this.Shown [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1db87e28 | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:529 |  | FLAG | dtToSite | GetSiteList("TO_SITE") | 화면 필드/플래그 변경 |  |  |  |
| AC-2d9ae893 | this.Shown [try] | SCP0116_Global_PSI_Report_New_ESS.cs:530 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.rgrpSearchLevel_SelectedIndexChanged

진입점: rgrpSearchLevel.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6513c7d | rgrpSearchLevel.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1858 | if (_SI == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.SCP0116_Global_PSI_Report_New_ESS_Shown

진입점: this.Shown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83b01a2a | this.Shown | SCP0116_Global_PSI_Report_New_ESS.cs:505 |  | FLAG | isLoadFinish | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.SetBackColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dd5c179 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:824 | try | UI_PROP | siGubunLine.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-f0ec0bbb | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:875 | try | UI_MISC | _SPD.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-aa08740a | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:888 | try ▸ for (iRow <= rowMax) ▸ if (measureGroupFocus == measureGroup) ▸ if (measureGroupBeforeFocus != measureGroupBefore) | DATA_OP | rowArrayGray.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-fed3385c | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:891 | try ▸ for (iRow <= rowMax) ▸ if (measureGroupFocus == measureGroup) ▸ if (measureGroupBeforeFocus != measureGroupBefore) ▸ if (measureGroup.… | DATA_OP | rowArrayBlack.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-906095e5 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:897 | try ▸ for (iRow <= rowMax) ▸ else of (measureGroupFocus == measureGroup) ▸ if (measureGroupFocus != measureGroup) | DATA_OP | rowArrayGray.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-e036c822 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:900 | try ▸ for (iRow <= rowMax) ▸ else of (measureGroupFocus == measureGroup) ▸ if (measureGroupFocus != measureGroup) ▸ if (measureGroup.Equals(… | DATA_OP | rowArrayBlack.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-83efdf54 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:926 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "MKT FCST": case "Ship Plan": case "Semi Ship Plan": case "RTF": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_BLUE | 그리드 속성/값 설정 |  |  |  |
| AC-7a30bc48 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:928 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "Production": case "Production(PKG)": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_ORANGE | 그리드 속성/값 설정 |  |  |  |
| AC-62c35874 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:937 | try ▸ if (rowArrayGray.Count > 0) ▸ for (i < rowArrayGray.Count) | GRID_SET | _SI.ActiveSheet.Rows[rowArrayGray[i]].Border | complexBorderDarkGray | 그리드 속성/값 설정 |  |  |  |
| AC-16590f14 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:938 | try ▸ if (rowArrayGray.Count > 0) ▸ for (i < rowArrayGray.Count) | GRID_SET | _SI.ActiveSheet.Cells[rowArrayGray[i], 0, rowArrayGray[i], colMax].Border | complexBorderDarkGray | 그리드 속성/값 설정 |  |  |  |
| AC-62373261 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:941 | try | CALL_EXT | rowArrayBlack.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b57c898e | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:947 | try ▸ if (rowArrayBlack.Count > 0) ▸ for (i < rowArrayBlack.Count) | GRID_SET | _SI.ActiveSheet.Rows[rowArrayBlack[i]].Border | complexBorderBlack | 그리드 속성/값 설정 |  |  |  |
| AC-5bbf7a0b | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:948 | try ▸ if (rowArrayBlack.Count > 0) ▸ for (i < rowArrayBlack.Count) | GRID_SET | _SI.ActiveSheet.Cells[rowArrayBlack[i], 0, rowArrayBlack[i], colMax].Border | complexBorderBlack | 그리드 속성/값 설정 |  |  |  |
| AC-efedd8dc | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:951 | try | CALL_EXT | rowArrayBlack.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae7e014a | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:979 | try ▸ switch (_bucket_type) case "MONTHLY": | GRID_SET | _SI.ActiveSheet.Cells[0, colStart, rowMax, colEnd].BackColor | DefGridColor.PAST | 그리드 속성/값 설정 |  |  |  |
| AC-edeacb4d | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:985 | try ▸ switch (_bucket_type) case "WEEKLY": | ENDPOINT | CommonUtils.FindDataValue | (dsSpdTitle.Tables[0], "DAY_CODE", _plan_start_yyyymmdd.ToString(), "COLUMN_LABEL_NAME") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-de043dda | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1009 | try ▸ switch (_bucket_type) case "WEEKLY": | GRID_SET | _SI.ActiveSheet.Cells[0, colStart, rowMax, colEnd].BackColor | DefGridColor.PAST | 그리드 속성/값 설정 |  |  |  |
| AC-cec21ab8 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1019 | try ▸ switch (_bucket_type) case "WEEKLY": ▸ for (i <= colEnd) ▸ if (headerName.StartsWith("W_") && headerName.EndsWith("A")) | DATA_OP | colArrayWeekA.Add | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-3eb1596b | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1052 | try ▸ switch (_bucket_type) case "WEEKLY": ▸ for (i <= rowMax) ▸ switch (measureName) case "VMI Inventory": case "Intransit": case "Pack Inv… | GRID_SET | _SI.ActiveSheet.Cells[j, colArrayWeekA[j], j, colArrayWeekA[j]].BackColor | DefGridColor.PAST_INVENTORY | 그리드 속성/값 설정 |  |  |  |
| AC-d7d1d6d0 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1062 | try | UI_MISC | _SPD.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.SetCalculating

진입점: cboUnitQty.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1b6ddac | cboUnitQty.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1553 | if (_SI.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d5e815f | cboUnitQty.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1558 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | _SI.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-89fa4435 | cboUnitQty.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1563 | if (cboUnitQty.SelectedIndex == 0) | LIST_BIND | _SI.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-ec27f5ab | cboUnitQty.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1564 | if (cboUnitQty.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3c26101 | cboUnitQty.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1567 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-efec2d20 | cboUnitQty.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1569 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-868839b8 | cboUnitQty.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1597 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbDivide, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-e57a7f67 | cboUnitQty.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1601 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-db2018ec | cboUnitQty.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1607 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-16029cdd | cboUnitQty.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1611 |  | LIST_BIND | _SI.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-533a2638 | cboUnitQty.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1615 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-1ab7ad5d | cboUnitQty.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1618 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.SetCalendar

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fe2bc8b | this.Load 외 1 | SCP0116_Global_PSI_Report_New_ESS.cs:1298 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.SetGridClear

진입점: cboPlanDate.SelectedIndexChanged [if (cboSearchLevel != null)] / cboBucketType.SelectedIndexChanged [if (_SI != null)] / cboSearchLevel.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87566d18 | cboPlanDate.SelectedIndexChanged [if (cboSearchLevel != null… 외 2 | SCP0116_Global_PSI_Report_New_ESS.cs:1782 | if (_SI != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (_SPD) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.SetLayout

진입점: this.Load / cboSearchLevel.SelectedIndexChanged / rgrpSearchLevel.SelectedIndexChanged / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17333521 | this.Load 외 4 | SCP0116_Global_PSI_Report_New_ESS.cs:1475 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 1: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL1"), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-19ba0056 | this.Load 외 4 | SCP0116_Global_PSI_Report_New_ESS.cs:1476 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 1: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL2"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-123b2572 | this.Load 외 4 | SCP0116_Global_PSI_Report_New_ESS.cs:1477 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 1: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL3"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e296a29a | this.Load 외 4 | SCP0116_Global_PSI_Report_New_ESS.cs:1483 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 2: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL1"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3de29388 | this.Load 외 4 | SCP0116_Global_PSI_Report_New_ESS.cs:1484 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 2: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL2"), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7e280d24 | this.Load 외 4 | SCP0116_Global_PSI_Report_New_ESS.cs:1485 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 2: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL3"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-779faf79 | this.Load 외 4 | SCP0116_Global_PSI_Report_New_ESS.cs:1491 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 3: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL1"), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f866e819 | this.Load 외 4 | SCP0116_Global_PSI_Report_New_ESS.cs:1492 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 3: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL2"), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-45880e78 | this.Load 외 4 | SCP0116_Global_PSI_Report_New_ESS.cs:1493 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 3: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL3"), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-812d7892 | this.Load 외 4 | SCP0116_Global_PSI_Report_New_ESS.cs:1499 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) default: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL1"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6891e2aa | this.Load 외 4 | SCP0116_Global_PSI_Report_New_ESS.cs:1500 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) default: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL2"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a9ae6b20 | this.Load 외 4 | SCP0116_Global_PSI_Report_New_ESS.cs:1501 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) default: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL3"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.SetSpreadColumn

진입점: this.Load / cboPlanDate.SelectedIndexChanged [if (cboSearchLevel != null)] / cboBucketType.SelectedIndexChanged [if (_SI != null)] / rgrpSearchLevel.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / dCalendar.ValueChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59e061aa | this.Load 외 7 | SCP0116_Global_PSI_Report_New_ESS.cs:1089 | for (iCol < _SI.ActiveSheet.Columns.Count) ▸ if (_bucket_type.Equals("MONTHLY")) ▸ if (ColName.IndexOf("M_") == 0) | GRID_SET | _SI.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3530674d | this.Load 외 7 | SCP0116_Global_PSI_Report_New_ESS.cs:1093 | for (iCol < _SI.ActiveSheet.Columns.Count) ▸ if (_bucket_type.Equals("MONTHLY")) ▸ else of (ColName.IndexOf("M_") == 0) | GRID_SET | _SI.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-49ff074c | this.Load 외 7 | SCP0116_Global_PSI_Report_New_ESS.cs:1100 | for (iCol < _SI.ActiveSheet.Columns.Count) ▸ else of (_bucket_type.Equals("MONTHLY")) ▸ if (_bucket_type.Equals("WEEKLY")) ▸ if (ColName.Ind… | GRID_SET | _SI.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-46330285 | this.Load 외 7 | SCP0116_Global_PSI_Report_New_ESS.cs:1104 | for (iCol < _SI.ActiveSheet.Columns.Count) ▸ else of (_bucket_type.Equals("MONTHLY")) ▸ if (_bucket_type.Equals("WEEKLY")) ▸ else of (ColNam… | GRID_SET | _SI.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.SetUnitQty

진입점: cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tables[0].Rows.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-debe7056 | cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tab… | SCP0116_Global_PSI_Report_New_ESS.cs:1662 | switch (cboUnitQty.SelectedIndex) case 0: | FLAG | dbDivideQty | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-016a46e7 | cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tab… | SCP0116_Global_PSI_Report_New_ESS.cs:1665 | switch (cboUnitQty.SelectedIndex) case 1: | FLAG | dbDivideQty | 1000 | 화면 필드/플래그 변경 |  |  |  |
| AC-2d6e4c4d | cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tab… | SCP0116_Global_PSI_Report_New_ESS.cs:1668 | switch (cboUnitQty.SelectedIndex) case 2: | FLAG | dbDivideQty | 1000000 | 화면 필드/플래그 변경 |  |  |  |
| AC-69816631 | cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tab… | SCP0116_Global_PSI_Report_New_ESS.cs:1671 | switch (cboUnitQty.SelectedIndex) case 3: | FLAG | dbDivideQty | 100000000 | 화면 필드/플래그 변경 |  |  |  |
| AC-a02bc733 | cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tab… | SCP0116_Global_PSI_Report_New_ESS.cs:1674 | switch (cboUnitQty.SelectedIndex) default: | FLAG | dbDivideQty | 1 | 화면 필드/플래그 변경 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.SetVisibleColumnCycle

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7eccfd27 | (진입점 미연결) | SCP0116_Global_PSI_Report_New_ESS.cs:1269 | try ▸ for (i < _SI.ActiveSheet.ColumnCount) | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex(day), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0116_Global_PSI_Report_New_ESS.VisibleSheet

진입점: rgrpSearchLevel.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99e26031 | rgrpSearchLevel.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1841 | if (_is_detail) | STATE | spdSearchLevel.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-fe9f8cd2 | rgrpSearchLevel.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1842 | if (_is_detail) | STATE | spdDetail.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-b5476852 | rgrpSearchLevel.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1846 | else of (_is_detail) | STATE | spdSearchLevel.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-52f00955 | rgrpSearchLevel.SelectedIndexChanged | SCP0116_Global_PSI_Report_New_ESS.cs:1847 | else of (_is_detail) | STATE | spdDetail.Visible | false | 컨트롤 상태 Visible |  |  |  |


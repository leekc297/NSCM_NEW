# AS-IS 액션 대조표 — SCP0100

> 원천: `Doc/asisfacts/screens/SCP0100/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 278행 · 메서드 66 · 종류 DATA_OP 43 · GRID_INIT 39 · GRID_SET 29 · UI_PROP 28 · FLAG 26 · RETURN 26 · CALL_EXT 16 · POPUP 12 · VALUE_SET 10 · LIST_REBIND 10 · UI_MISC 9 · STATE 9 · ENDPOINT 9 · GRID_CLEAR 2 · COMBO_DATA 2 · LIST_BIND 2 · GRID_BIND 1 · GRID_LOCK 1 · CALL_BASE 1 · MESSAGE 1 · THROW 1 · VALIDATE 1 · ⚠ 의미 확인 필요 17


## SCP0100_Global_PSI_Report.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fc01430 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1164 |  | GRID_BIND | _SI.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3e4f95ca | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1166 |  | GRID_LOCK | _SI.LockColumn | (0, _SI.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-76acb473 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1168 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4cd1132a | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1172 |  | GRID_INIT | _SI.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0100_Global_PSI_Report.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ae59b85 | this.btnColumn.Click | SCP0100_Global_PSI_Report.cs:1994 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0100", sSheetName, true) | 팝업/폼 생성 |  |  |  |
| AC-948c0e9d | this.btnColumn.Click | SCP0100_Global_PSI_Report.cs:1995 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dec72cd6 | this.btnColumn.Click | SCP0100_Global_PSI_Report.cs:1996 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0100_Global_PSI_Report.BtnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba104f09 | this.btnItemId.Click | SCP0100_Global_PSI_Report.cs:1938 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a1c94cbe | this.btnItemId.Click | SCP0100_Global_PSI_Report.cs:1939 |  | POPUP | popItem.Form_Load | (true, _division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-93f5d257 | this.btnItemId.Click | SCP0100_Global_PSI_Report.cs:1940 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bd040dcd | this.btnItemId.Click | SCP0100_Global_PSI_Report.cs:1941 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-414712ce | this.btnItemId.Click | SCP0100_Global_PSI_Report.cs:1947 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0100_Global_PSI_Report.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7e90bd1 | this.btnMeasure.Click | SCP0100_Global_PSI_Report.cs:1954 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0100", measure, false) | 팝업/폼 생성 |  |  |  |
| AC-624719cd | this.btnMeasure.Click | SCP0100_Global_PSI_Report.cs:1955 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b6d7ba3e | this.btnMeasure.Click | SCP0100_Global_PSI_Report.cs:1956 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c90eb8d2 | this.btnMeasure.Click | SCP0100_Global_PSI_Report.cs:1960 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-141a0cf4 | this.btnMeasure.Click | SCP0100_Global_PSI_Report.cs:1963 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0100_Global_PSI_Report.BtnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-818f0c4e | this.btnProject.Click | SCP0100_Global_PSI_Report.cs:1971 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-68ca5516 | this.btnProject.Click | SCP0100_Global_PSI_Report.cs:1973 |  | POPUP | popProject.Form_Load | (true, _division, _project) | 팝업 초기화(인자 전달) |  |  |  |
| AC-edfcb6c8 | this.btnProject.Click | SCP0100_Global_PSI_Report.cs:1974 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3f82f82c | this.btnProject.Click | SCP0100_Global_PSI_Report.cs:1975 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3d24b752 | this.btnProject.Click | SCP0100_Global_PSI_Report.cs:1981 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCP0100_Global_PSI_Report.CboBucketType_SelectedIndexChanged

진입점: cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abe777d8 | cboBucketType.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1802 | if (_SI != null) | FLAG | sBucket | _bucket_type | 화면 필드/플래그 변경 |  |  |  |
| AC-6cb86fee | cboBucketType.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1809 | if (_SI != null) ▸ if (!_SI.IsLock(_SI.SheetName)) | CALL_BASE | EditButton | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0100_Global_PSI_Report.CboDisplay_SelectedIndexChanged

진입점: cboDisplay.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf64a753 | cboDisplay.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1832 | if (cboDisplay.SelectedIndex == 2) | UI_PROP | this.splitContainer1.Panel1MinSize | 0 | 속성 Panel1MinSize 설정 |  |  |  |
| AC-46945393 | cboDisplay.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1833 | if (cboDisplay.SelectedIndex == 2) | UI_PROP | splitContainer1.SplitterDistance | 0 | 속성 SplitterDistance 설정 |  |  |  |
| AC-9aeda5d9 | cboDisplay.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1840 | else of (cboDisplay.SelectedIndex == 2) ▸ if (cboDisplay.SelectedIndex == 1) | UI_PROP | this.splitContainer1.Panel1MinSize | 100 | 속성 Panel1MinSize 설정 |  |  |  |
| AC-ffc0a854 | cboDisplay.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1841 | else of (cboDisplay.SelectedIndex == 2) ▸ if (cboDisplay.SelectedIndex == 1) | UI_PROP | splitContainer1.SplitterDistance | 750 | 속성 SplitterDistance 설정 |  |  |  |
| AC-de540805 | cboDisplay.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1848 | else of (cboDisplay.SelectedIndex == 2) ▸ else of (cboDisplay.SelectedIndex == 1) | UI_PROP | this.splitContainer1.Panel1MinSize | 100 | 속성 Panel1MinSize 설정 |  |  |  |
| AC-307ba7d8 | cboDisplay.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1849 | else of (cboDisplay.SelectedIndex == 2) ▸ else of (cboDisplay.SelectedIndex == 1) | UI_PROP | splitContainer1.SplitterDistance | 270 | 속성 SplitterDistance 설정 |  |  |  |

## SCP0100_Global_PSI_Report.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ab0459e | cboPlanDate.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1786 |  | FLAG | PLAN_DATE | _plan_start_yyyymmdd | 화면 필드/플래그 변경 |  |  |  |
| AC-84d9f705 | cboPlanDate.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1787 |  | FLAG | PLAN_DATE_YYYYMM | ScpUtils.GetPlanDateYearMonth(cboPlanDate) | 화면 필드/플래그 변경 |  |  |  |
| AC-726b79d5 | cboPlanDate.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1787 |  | CALL_EXT | ScpUtils.GetPlanDateYearMonth | (cboPlanDate) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0100_Global_PSI_Report.CboUnitQty_SelectedIndexChanged

진입점: cboUnitQty.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaa71132 | cboUnitQty.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1867 | if (_SI == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e42edb7c | clbDivision.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1769 | if (fps != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (_SPD) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0100_Global_PSI_Report.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fba9b5bd | this.Load | SCP0100_Global_PSI_Report.cs:684 |  | GRID_INIT | this.AddSheet | (spdSearchLevel, SpdSheet.SearchLevel, SpdSheet.SearchLevel, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-83adcc79 | this.Load | SCP0100_Global_PSI_Report.cs:685 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.Detail, SpdSheet.Detail, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-32176844 | this.Load | SCP0100_Global_PSI_Report.cs:686 |  | GRID_INIT | this.AddSheet | (spdSearchLevelDetail, SpdSheet.SearchLevelDetail, SpdSheet.SearchLevelDetail, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-768fe8e2 | this.Load | SCP0100_Global_PSI_Report.cs:688 |  | FLAG | siSearchLevel | GetSheetInfo(spdSearchLevel.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-3639a55b | this.Load | SCP0100_Global_PSI_Report.cs:689 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-c9cd9b1d | this.Load | SCP0100_Global_PSI_Report.cs:690 |  | FLAG | siSearchLevelDetail | GetSheetInfo(spdSearchLevelDetail.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-b91c2558 | this.Load | SCP0100_Global_PSI_Report.cs:692 |  | GRID_INIT | siSearchLevel.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64c33efa | this.Load | SCP0100_Global_PSI_Report.cs:693 |  | GRID_INIT | siDetail.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0100_Global_PSI_Report.DCalendar_ValueChanged

진입점: dCalendar.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-922c3399 | dCalendar.ValueChanged | SCP0100_Global_PSI_Report.cs:2015 | if (dStart > dPlan) | MESSAGE | MessageHelper.GMessageBox | ("[조회 시작일] Plan Date 이전으로 설정해야 합니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-85ad0cbd | dCalendar.ValueChanged | SCP0100_Global_PSI_Report.cs:2018 | if (dStart > dPlan) | VALUE_SET | dCalendar.InitValue | sDayRange | 컨트롤 값 설정 |  |  |  |

## SCP0100_Global_PSI_Report.DefineProperty

진입점: this.Shown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62dc05ff | this.Shown | SCP0100_Global_PSI_Report.cs:540 |  | VALUE_SET | cboDisplay.SelectedIndex | 2 | 컨트롤 값 설정 |  |  |  |
| AC-3e1a30d7 | this.Shown | SCP0100_Global_PSI_Report.cs:541 |  | VALUE_SET | rgrpSearchLevel.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SCP0100_Global_PSI_Report.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9d62893 | Dispose | SCP0100_Global_PSI_Report.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0100_Global_PSI_Report.EnableSearchLevel

진입점: rgrpSearchLevel.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37045255 | rgrpSearchLevel.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1874 |  | STATE | lciSearchLevel.Enabled | !_is_detail | 컨트롤 상태 Enabled |  |  |  |

## SCP0100_Global_PSI_Report.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26dc661b | ExcelButton | SCP0100_Global_PSI_Report.cs:1189 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-9e6c48ed | ExcelButton | SCP0100_Global_PSI_Report.cs:1190 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-d20eeb79 | ExcelButton | SCP0100_Global_PSI_Report.cs:1191 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-589eab7b | ExcelButton | SCP0100_Global_PSI_Report.cs:1192 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-ed4df689 | ExcelButton | SCP0100_Global_PSI_Report.cs:1193 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-952f2ac2 | ExcelButton | SCP0100_Global_PSI_Report.cs:1194 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-f53f2ca1 | ExcelButton | SCP0100_Global_PSI_Report.cs:1195 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-80240f36 | ExcelButton | SCP0100_Global_PSI_Report.cs:1197 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-c2020d2e | ExcelButton | SCP0100_Global_PSI_Report.cs:1198 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-4878cf66 | ExcelButton | SCP0100_Global_PSI_Report.cs:1200 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-fddfa5a5 | ExcelButton | SCP0100_Global_PSI_Report.cs:1204 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-247f8165 | ExcelButton | SCP0100_Global_PSI_Report.cs:1209 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-3307eb2d | ExcelButton | SCP0100_Global_PSI_Report.cs:1213 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0100_Global_PSI_Report.FindData

진입점: cboBucketType.SelectedIndexChanged [if (_SI != null)] / cboSearchLevel.SelectedIndexChanged [if (isLoadFinish)] / FindButton [if (this._SPD.Visible)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5eb511dc | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1271 |  | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d88cc112 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1274 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | _SI.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |

## SCP0100_Global_PSI_Report.FindDataMain

진입점: cboBucketType.SelectedIndexChanged [if (_SI != null)] / cboSearchLevel.SelectedIndexChanged [if (isLoadFinish)] / FindButton [if (this._SPD.Visible)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a377bae | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1231 | if (this.QueryDics[DIC_GLOBAL_PSI_NEW].Count > 0) | CALL_EXT | this.QueryDics[DIC_GLOBAL_PSI_NEW].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f1d4bc3 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1236 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.BeforeFindData | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-9e3344a4 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1237 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-d2bee1d1 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1238 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_ANALYSIS_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-b40f0828 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1239 |  | UI_PROP | qi.QueryId | "SCP.SCP0100_GET_GLOBAL_PSI_REPORT" | 속성 QueryId 설정 |  |  |  |
| AC-b8d52b34 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1241 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_yyyymmdd", this._from_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-afc8b9d6 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1242 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_yyyymmdd", this._to_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c77a967 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1243 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-87da9165 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1244 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", this._item_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d3f2d3e | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1245 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nick_name", "")) | 데이터 객체 조작/조회 |  |  |  |
| AC-56d2eb46 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1246 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_site", this._from_site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c4f7421 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1247 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_site", this._to_site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5416872e | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1248 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plan_start_yyyymmdd", this._plan_start_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c824ca66 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1249 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plan_type", this._plan_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c8598d6 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1250 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-69c36e5d | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1251 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_bucket", this._bucket_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4e0afee | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1252 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_cell_group", this._cell_group)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa2f011f | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1253 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_project", this._project)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2c09b9d | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1254 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_search_level", this._search_level)) | 데이터 객체 조작/조회 |  |  |  |
| AC-adbfdca0 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1255 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_chk_cell_qty", this._cell_qty)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6482133 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1256 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_chk_as", this._as)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b59c4fcb | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1257 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0068b72 | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1260 |  | DATA_OP | this.QueryDics[DIC_GLOBAL_PSI_NEW] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |
| AC-c05029bb | cboBucketType.SelectedIndexChanged [if (_SI != null)] 외 2 | SCP0100_Global_PSI_Report.cs:1263 |  | ENDPOINT | this.ExecuteSQL | (_SI, DIC_GLOBAL_PSI_NEW, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0100_Global_PSI_Report.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c2dacd0 | this.Load | SCP0100_Global_PSI_Report.cs:513 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0100_Global_PSI_Report.getAS

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3830a41e | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:433 |  | RETURN | return chkAS.Checked ? "Y" : "N"; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getBucketType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70e2aec6 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:236 |  | RETURN | return cboBucketType.ControlValues; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getCellGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a0e1d3b | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:358 |  | RETURN | return txtCellGroup.Text; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getCellQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0a289e7 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:447 |  | RETURN | return chkCellQty.Checked ? "Y" : "N"; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4c1edb2 | this.Load 외 1 | SCP0100_Global_PSI_Report.cs:1403 | try ▸ switch (code) case "YEAR": | CALL_EXT | ScpUtils.GetPlanDateYear | (cboPlanDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99359548 | this.Load 외 1 | SCP0100_Global_PSI_Report.cs:1404 | try ▸ switch (code) case "YEAR": | CALL_EXT | ScpUtils.GetYearFirstDay | (plan_YYYY) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1617e2bd | this.Load 외 1 | SCP0100_Global_PSI_Report.cs:1410 | try ▸ switch (code) case "MONTH": | CALL_EXT | ScpUtils.GetPlanDateYearMonth | (cboPlanDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c02c4d0 | this.Load 외 1 | SCP0100_Global_PSI_Report.cs:1436 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a067897 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:471 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getEndYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a79fc0d | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:292 |  | RETURN | return dCalendar.Text2; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getFromSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ef03881 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:311 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getFromYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82204fd5 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:250 |  | RETURN | return _start_yyyymmdd.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getIsDetail

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a56f1a7 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:396 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getItemId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ea2c7be | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:201 |  | RETURN | return txtItemId.Text.Trim(); |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.GetMeasureDataType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0d99503 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1719 |  | DATA_OP | sMeasure.ToUpper().Contains | ("QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6ef5fae | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1723 | else of (sMeasure.ToUpper().Contains("QTY")) | DATA_OP | sMeasure.ToUpper().Contains | ("AMOUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-8fb21e5f | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1727 | else of (sMeasure.ToUpper().Contains("QTY")) ▸ else of (sMeasure.ToUpper().Contains("AMOUNT")) | DATA_OP | sMeasure.ToUpper().Contains | ("AMT") | 데이터 객체 조작/조회 |  |  |  |
| AC-1ef3ed58 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1731 | else of (sMeasure.ToUpper().Contains("QTY")) ▸ else of (sMeasure.ToUpper().Contains("AMOUNT")) ▸ else of (sMeasure.ToUpper().Contains("AMT")… | DATA_OP | sMeasure.ToUpper().Contains | ("DIO") | 데이터 객체 조작/조회 |  |  |  |
| AC-282b0cdc | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1755 |  | RETURN | return measure_type; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.GetPlanDate

진입점: this.Load [if (this._division != null && !this._division.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24f9aed7 | this.Load [if (this._division != null && !this._division.Equ… | SCP0100_Global_PSI_Report.cs:1365 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0100_GET_PLAN_DATE") ⇒ SCP.SCP0100_GET_PLAN_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-6e3abf29 | this.Load [if (this._division != null && !this._division.Equ… | SCP0100_Global_PSI_Report.cs:1366 |  | DATA_OP | request.Parameters["p_division_id"] | this._division | 행/컬럼 값 대입 |  |  |  |
| AC-4fc30e43 | this.Load [if (this._division != null && !this._division.Equ… | SCP0100_Global_PSI_Report.cs:1367 |  | DATA_OP | request.Parameters["p_bucket"] | this._bucket_type | 행/컬럼 값 대입 |  |  |  |
| AC-1ce9076c | this.Load [if (this._division != null && !this._division.Equ… | SCP0100_Global_PSI_Report.cs:1368 |  | DATA_OP | request.Parameters["p_program_id"] | "SCP0100" | 행/컬럼 값 대입 |  |  |  |
| AC-c044d639 | this.Load [if (this._division != null && !this._division.Equ… | SCP0100_Global_PSI_Report.cs:1369 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b23fec81 | this.Load [if (this._division != null && !this._division.Equ… | SCP0100_Global_PSI_Report.cs:1375 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.GetPlanEndDate

진입점: this.Load [try ▸ switch (code) case "MONTH":] / cboPlanDate.SelectedIndexChanged [try ▸ switch (code) case "MONTH":]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41c39026 | this.Load [try ▸ switch (code) case "MONTH":] 외 1 | SCP0100_Global_PSI_Report.cs:2035 | try | COMBO_DATA | Data_REPORT.CallBizCommonData | (Data_REPORT.Type.PLAN_END_DATE , false //, CommonUtils.GetValue(_division) , CommonUtils.… ⇒ biz:CommonData.CommonDataList_REPORT [code={?Data_REPORT.Type.PLAN_END_DATE}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fa7102bd | this.Load [try ▸ switch (code) case "MONTH":] 외 1 | SCP0100_Global_PSI_Report.cs:2044 | try ▸ if (CommonUtils.CheckDataEmpty(dt) == false) | ENDPOINT | CommonUtils.GetDataValue | (dt) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-61645979 | this.Load [try ▸ switch (code) case "MONTH":] 외 1 | SCP0100_Global_PSI_Report.cs:2051 |  | RETURN | return endDay; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getPlanStartYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76962852 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:215 |  | RETURN | return CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues).ToStri… |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getPlanType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cc82c1a | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:344 |  | RETURN | return CString.GetCheckedListValue(dtPlanType, cboPlanType.ControlValues); |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getProject

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-073caccf | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:372 |  | RETURN | return txtProject.Text; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getSearchLevel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9177176d | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:419 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.GetSiteList

진입점: this.Shown [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0822562 | this.Shown [try] | SCP0100_Global_PSI_Report.cs:1342 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0100_GET_SITE") ⇒ SCP.SCP0100_GET_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-aaa3c532 | this.Shown [try] | SCP0100_Global_PSI_Report.cs:1343 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-28ac1f97 | this.Shown [try] | SCP0100_Global_PSI_Report.cs:1344 |  | DATA_OP | request.Parameters["p_site_tpye"] | site_type | 행/컬럼 값 대입 |  |  |  |
| AC-f0f4d176 | this.Shown [try] | SCP0100_Global_PSI_Report.cs:1345 |  | DATA_OP | request.Parameters["p_division_id"] | _division | 행/컬럼 값 대입 |  |  |  |
| AC-0a82fc02 | this.Shown [try] | SCP0100_Global_PSI_Report.cs:1346 |  | DATA_OP | request.Parameters["p_bucket"] | _bucket_type | 행/컬럼 값 대입 |  |  |  |
| AC-820c2309 | this.Shown [try] | SCP0100_Global_PSI_Report.cs:1348 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ee39a3ba | this.Shown [try] | SCP0100_Global_PSI_Report.cs:1354 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.GetSpdTitle

진입점: this.Load / cboPlanDate.SelectedIndexChanged [if (cboSearchLevel != null)] / rgrpSearchLevel.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / dCalendar.ValueChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6ada637 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:1326 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-7957a56b | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:1327 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | _start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-77c98f2b | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:1328 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | _end_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-36f2d192 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:1330 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8c684a2f | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:1330 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0100_Global_PSI_Report.getStartYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2cc753a | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:278 |  | RETURN | return dCalendar.Text1; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getToSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f484aca | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:330 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.getToYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d4b4484 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:264 |  | RETURN | return _end_yyyymmdd.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.GetUnitDivide

진입점: cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tables[0].Rows.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b38b57c8 | cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tab… | SCP0100_Global_PSI_Report.cs:1677 | if (ScpUtils.CheckDataEmpty(measure_type) == false) ▸ else of (measure_type.ToUpper().Equals("QTY")) ▸ else of (measure_type.ToUpper().Equal… | DATA_OP | measure_type.Contains | ("DIO") | 데이터 객체 조작/조회 |  |  |  |

## SCP0100_Global_PSI_Report.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd02b095 | this.Load | SCP0100_Global_PSI_Report.cs:577 |  | CALL_EXT | ScpUtils.GetCurrentTimeZone | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4841b4d9 | this.Load | SCP0100_Global_PSI_Report.cs:578 |  | CALL_EXT | ScpUtils.GetDefaultTimeZone | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7530af2 | this.Load | SCP0100_Global_PSI_Report.cs:580 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5cf8c6fb | this.Load | SCP0100_Global_PSI_Report.cs:584 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-e55a3141 | this.Load | SCP0100_Global_PSI_Report.cs:586 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-55abd69a | this.Load | SCP0100_Global_PSI_Report.cs:596 | if (this._division != null && !this._division.Equals("ALL")) | FLAG | dtPlanDate | GetPlanDate() | 화면 필드/플래그 변경 |  |  |  |
| AC-c7c29827 | this.Load | SCP0100_Global_PSI_Report.cs:597 | if (this._division != null && !this._division.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d3353a6c | this.Load | SCP0100_Global_PSI_Report.cs:603 |  | FLAG | dtBucketType | ScpUtils.GetBucketType("CODE = 'DAILY'") | 화면 필드/플래그 변경 |  |  |  |
| AC-325e1cfa | this.Load | SCP0100_Global_PSI_Report.cs:603 |  | CALL_EXT | ScpUtils.GetBucketType | ("CODE = 'DAILY'") | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa5f49d4 | this.Load | SCP0100_Global_PSI_Report.cs:604 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5158df5c | this.Load | SCP0100_Global_PSI_Report.cs:606 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |
| AC-41db1ecf | this.Load | SCP0100_Global_PSI_Report.cs:608 |  | FLAG | dtUnitQty | ScpUtils.GetUnitQty() | 화면 필드/플래그 변경 |  |  |  |
| AC-3ebd8500 | this.Load | SCP0100_Global_PSI_Report.cs:608 |  | CALL_EXT | ScpUtils.GetUnitQty | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac4cb661 | this.Load | SCP0100_Global_PSI_Report.cs:609 |  | LIST_REBIND | clsCtrl.setListBox | (dtUnitQty, cboUnitQty, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0100_Global_PSI_Report.InitControlsAfter

진입점: this.Shown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8f2d930 | this.Shown | SCP0100_Global_PSI_Report.cs:614 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-477d8277 | this.Shown | SCP0100_Global_PSI_Report.cs:615 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-59e92478 | this.Shown | SCP0100_Global_PSI_Report.cs:621 | try ▸ if (dtSearchLevel.Rows.Count > 0) | VALUE_SET | cboSearchLevel.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-e2fc202d | this.Shown | SCP0100_Global_PSI_Report.cs:626 | try ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-84e4a025 | this.Shown | SCP0100_Global_PSI_Report.cs:628 | try | VALUE_SET | cboPlanType.SelectedValue | "FN" | 컨트롤 값 설정 |  |  |  |
| AC-34a298ce | this.Shown | SCP0100_Global_PSI_Report.cs:640 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0100_Global_PSI_Report.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12af8143 | this.Load | SCP0100_Global_PSI_Report.cs:507 |  | DATA_OP | QueryDics.Add | (DIC_GLOBAL_PSI_NEW, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0100_Global_PSI_Report.InitSpread

진입점: this.Load / cboPlanDate.SelectedIndexChanged [if (cboSearchLevel != null)] / rgrpSearchLevel.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / dCalendar.ValueChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee3ca522 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:702 |  | GRID_INIT | _SI.InitSheet | (_SI.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-1e75af14 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:705 |  | GRID_INIT | _SI.SetSheetHeaderColumn | (_SI, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-52fef0dd | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:709 |  | GRID_INIT | _SI.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0100_Global_PSI_Report.InitSpreadDateColumn

진입점: this.Load / cboPlanDate.SelectedIndexChanged [if (cboSearchLevel != null)] / rgrpSearchLevel.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / dCalendar.ValueChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8326fd3e | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:755 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a454d58 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:756 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bdee6163 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:760 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a5ab44d5 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:761 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b9e2d613 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:765 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sColumnName.StartsWith("M_")) | DATA_OP | sColumnName.Contains | (_plan_start_yyyymm) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ad8eaa5 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:767 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sColumnName.StartsWith("M_")) ▸ if (sColum… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, spdInfo.GetMaxColumnIndex()].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-077eba02 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:772 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ else of (sColumnName.StartsWith("M_")) ▸ if (s… | DATA_OP | sColumnLabelname.Contains | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2270cf4 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:774 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ else of (sColumnName.StartsWith("M_")) ▸ if (s… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[1, spdInfo.GetMaxColumnIndex()].ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-9affbad7 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:776 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ else of (sColumnName.StartsWith("M_")) ▸ if (s… | DATA_OP | sColumnLabelname.Contains | ("B") | 데이터 객체 조작/조회 |  |  |  |
| AC-e04b95fc | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:778 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ else of (sColumnName.StartsWith("M_")) ▸ if (s… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[1, spdInfo.GetMaxColumnIndex()].ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-ff55f438 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:787 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-104fbbb1 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:788 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "Qty", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-831f5e0e | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:793 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b28913cc | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:794 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "Qty", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd8a0804 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:802 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dd5c13bb | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:803 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "Qty", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ce7450c | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:813 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f0412b2 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:814 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "Qty", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61f7b0b1 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:815 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-589f46e2 | this.Load 외 6 | SCP0100_Global_PSI_Report.cs:816 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "Qty", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0100_Global_PSI_Report.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffa5715e | OnShown | SCP0100_Global_PSI_Report.cs:524 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, 0) | 목록 컨트롤 재구성 |  |  |  |

## SCP0100_Global_PSI_Report.RefreshDisplay

진입점: this.Shown [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be73621b | this.Shown [try] | SCP0100_Global_PSI_Report.cs:561 |  | FLAG | dtDisplay | ScpUtils.GetLookupValues("STOCK_TREND_DISPLAY") | 화면 필드/플래그 변경 |  |  |  |
| AC-83f34f52 | this.Shown [try] | SCP0100_Global_PSI_Report.cs:561 |  | CALL_EXT | ScpUtils.GetLookupValues | ("STOCK_TREND_DISPLAY") | ⚠ 의미 확인 필요 |  |  |  |
| AC-33d3ee51 | this.Shown [try] | SCP0100_Global_PSI_Report.cs:562 |  | LIST_REBIND | clsCtrl.setListBox | (dtDisplay, cboDisplay, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0100_Global_PSI_Report.RefreshFromSite

진입점: this.Shown [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-152ad12e | this.Shown [try] | SCP0100_Global_PSI_Report.cs:551 |  | FLAG | dtFromSite | GetSiteList("FROM_SITE") | 화면 필드/플래그 변경 |  |  |  |
| AC-9b63cce1 | this.Shown [try] | SCP0100_Global_PSI_Report.cs:552 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0100_Global_PSI_Report.RefreshPlant

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-757fdc35 | this.Load 외 1 | SCP0100_Global_PSI_Report.cs:546 |  | FLAG | dtPlant | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, this._division) | 화면 필드/플래그 변경 |  |  |  |
| AC-da93a4b2 | this.Load 외 1 | SCP0100_Global_PSI_Report.cs:546 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, this._division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0100_Global_PSI_Report.RefreshPlantType

진입점: this.Shown [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8805070 | this.Shown [try] | SCP0100_Global_PSI_Report.cs:571 |  | FLAG | dtPlanType | ScpUtils.GetLookupValues("PLAN_TYPE") | 화면 필드/플래그 변경 |  |  |  |
| AC-a34168ac | this.Shown [try] | SCP0100_Global_PSI_Report.cs:571 |  | CALL_EXT | ScpUtils.GetLookupValues | ("PLAN_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac7d54c2 | this.Shown [try] | SCP0100_Global_PSI_Report.cs:572 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0100_Global_PSI_Report.RefreshSearchLevel

진입점: this.Shown [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04751e6f | this.Shown [try] | SCP0100_Global_PSI_Report.cs:566 |  | FLAG | dtSearchLevel | ScpUtils.GetLookupValues("PRODUCT_LEVEL") | 화면 필드/플래그 변경 |  |  |  |
| AC-f79829fd | this.Shown [try] | SCP0100_Global_PSI_Report.cs:566 |  | CALL_EXT | ScpUtils.GetLookupValues | ("PRODUCT_LEVEL") | ⚠ 의미 확인 필요 |  |  |  |
| AC-415ef0f7 | this.Shown [try] | SCP0100_Global_PSI_Report.cs:567 |  | LIST_REBIND | clsCtrl.setListBox | (dtSearchLevel, cboSearchLevel, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0100_Global_PSI_Report.RefreshToSite

진입점: this.Shown [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eed83c4c | this.Shown [try] | SCP0100_Global_PSI_Report.cs:556 |  | FLAG | dtToSite | GetSiteList("TO_SITE") | 화면 필드/플래그 변경 |  |  |  |
| AC-83397893 | this.Shown [try] | SCP0100_Global_PSI_Report.cs:557 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0100_Global_PSI_Report.rgrpSearchLevel_SelectedIndexChanged

진입점: rgrpSearchLevel.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4d424f5 | rgrpSearchLevel.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1907 | if (_SI == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0100_Global_PSI_Report.SCP0100_Global_PSI_Report_Shown

진입점: this.Shown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06fafbef | this.Shown | SCP0100_Global_PSI_Report.cs:532 |  | FLAG | isLoadFinish | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0100_Global_PSI_Report.SetBackColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e456c9d | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:823 | try | UI_PROP | siGubunLine.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-eddf01a1 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:874 | try | UI_MISC | _SPD.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c2995673 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:887 | try ▸ for (iRow <= rowMax) ▸ if (measureGroupFocus == measureGroup) ▸ if (measureGroupBeforeFocus != measureGroupBefore) | DATA_OP | rowArrayGray.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c88d5c2f | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:890 | try ▸ for (iRow <= rowMax) ▸ if (measureGroupFocus == measureGroup) ▸ if (measureGroupBeforeFocus != measureGroupBefore) ▸ if (measureGroup.… | DATA_OP | rowArrayBlack.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-96234102 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:896 | try ▸ for (iRow <= rowMax) ▸ else of (measureGroupFocus == measureGroup) ▸ if (measureGroupFocus != measureGroup) | DATA_OP | rowArrayGray.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc959525 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:899 | try ▸ for (iRow <= rowMax) ▸ else of (measureGroupFocus == measureGroup) ▸ if (measureGroupFocus != measureGroup) ▸ if (measureGroup.Equals(… | DATA_OP | rowArrayBlack.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4661da5 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:922 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "VMI Inventory": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_INVENTORY | 그리드 속성/값 설정 |  |  |  |
| AC-c1ad816d | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:923 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "Intransit": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_INVENTORY | 그리드 속성/값 설정 |  |  |  |
| AC-9075d75d | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:924 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "Semi Intransit": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_INVENTORY | 그리드 속성/값 설정 |  |  |  |
| AC-4372cb24 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:925 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "Pack Inventory": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_INVENTORY | 그리드 속성/값 설정 |  |  |  |
| AC-c895e047 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:926 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "Cell Inventory(Pack)": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_INVENTORY | 그리드 속성/값 설정 |  |  |  |
| AC-d7474181 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:927 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "Cell Inventory": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_INVENTORY | 그리드 속성/값 설정 |  |  |  |
| AC-4c50e8d6 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:928 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "AS Inventory": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_INVENTORY | 그리드 속성/값 설정 |  |  |  |
| AC-7b053c11 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:929 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "Char. Available": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_INVENTORY | 그리드 속성/값 설정 |  |  |  |
| AC-58d24a30 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:930 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "Form. Progress": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_INVENTORY | 그리드 속성/값 설정 |  |  |  |
| AC-3634cdcc | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:931 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "DIO": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_DIO | 그리드 속성/값 설정 |  |  |  |
| AC-3a8bf2f5 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:932 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "STD_DIO": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_STD_DIO | 그리드 속성/값 설정 |  |  |  |
| AC-52d33c6c | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:933 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "Total Inv": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_TOT_INV | 그리드 속성/값 설정 |  |  |  |
| AC-37551b85 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:938 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "MKT FCST": case "Ship Plan": case "RTF": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_BLUE | 그리드 속성/값 설정 |  |  |  |
| AC-1938e663 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:940 | try ▸ for (iRow <= rowMax) ▸ switch (measureName) case "Production": case "Production(PKG)": | GRID_SET | _SI.ActiveSheet.Cells[iRow, colMeasureSet, iRow, colMax].BackColor | DefGridColor.MEASURE_ORANGE | 그리드 속성/값 설정 |  |  |  |
| AC-2bfd84fc | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:951 | try ▸ if (rowArrayGray.Count > 0) ▸ for (i < rowArrayGray.Count) | GRID_SET | _SI.ActiveSheet.Rows[rowArrayGray[i]].Border | complexBorderDarkGray | 그리드 속성/값 설정 |  |  |  |
| AC-91680b7e | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:952 | try ▸ if (rowArrayGray.Count > 0) ▸ for (i < rowArrayGray.Count) | GRID_SET | _SI.ActiveSheet.Cells[rowArrayGray[i], 0, rowArrayGray[i], colMax].Border | complexBorderDarkGray | 그리드 속성/값 설정 |  |  |  |
| AC-e4edf3c6 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:955 | try | CALL_EXT | rowArrayBlack.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c180348 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:961 | try ▸ if (rowArrayBlack.Count > 0) ▸ for (i < rowArrayBlack.Count) | GRID_SET | _SI.ActiveSheet.Rows[rowArrayBlack[i]].Border | complexBorderBlack | 그리드 속성/값 설정 |  |  |  |
| AC-f5b50ea1 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:962 | try ▸ if (rowArrayBlack.Count > 0) ▸ for (i < rowArrayBlack.Count) | GRID_SET | _SI.ActiveSheet.Cells[rowArrayBlack[i], 0, rowArrayBlack[i], colMax].Border | complexBorderBlack | 그리드 속성/값 설정 |  |  |  |
| AC-578c554a | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:965 | try | CALL_EXT | rowArrayBlack.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c2b0132 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:993 | try ▸ switch (_bucket_type) case "MONTHLY": | GRID_SET | _SI.ActiveSheet.Cells[0, colStart, rowMax, colEnd].BackColor | DefGridColor.PAST | 그리드 속성/값 설정 |  |  |  |
| AC-7df50736 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:999 | try ▸ switch (_bucket_type) case "WEEKLY": | ENDPOINT | CommonUtils.FindDataValue | (dsSpdTitle.Tables[0], "DAY_CODE", _plan_start_yyyymmdd.ToString(), "COLUMN_LABEL_NAME") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ea4c1502 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1023 | try ▸ switch (_bucket_type) case "WEEKLY": | GRID_SET | _SI.ActiveSheet.Cells[0, colStart, rowMax, colEnd].BackColor | DefGridColor.PAST | 그리드 속성/값 설정 |  |  |  |
| AC-bd63e878 | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1033 | try ▸ switch (_bucket_type) case "WEEKLY": ▸ for (i <= colEnd) ▸ if (headerName.StartsWith("W_") && headerName.EndsWith("A")) | DATA_OP | colArrayWeekA.Add | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-cebac38d | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1066 | try ▸ switch (_bucket_type) case "WEEKLY": ▸ for (i <= rowMax) ▸ switch (measureName) case "VMI Inventory": case "Intransit": case "Pack Inv… | GRID_SET | _SI.ActiveSheet.Cells[j, colArrayWeekA[j], j, colArrayWeekA[j]].BackColor | DefGridColor.PAST_INVENTORY | 그리드 속성/값 설정 |  |  |  |
| AC-1620d3dc | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1076 | try | UI_MISC | _SPD.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0100_Global_PSI_Report.SetCalculating

진입점: cboUnitQty.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cd5decc | cboUnitQty.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1590 | if (_SI.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3a02f70 | cboUnitQty.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1596 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | _SI.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-661606a3 | cboUnitQty.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1601 | if (cboUnitQty.SelectedIndex == 0) | LIST_BIND | _SI.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-f42b6151 | cboUnitQty.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1602 | if (cboUnitQty.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6baa530b | cboUnitQty.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1605 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3a89038a | cboUnitQty.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1607 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ff63b77d | cboUnitQty.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1635 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbDivide, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-bc5260c0 | cboUnitQty.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1639 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bc8790ff | cboUnitQty.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1645 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-7cbad15a | cboUnitQty.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1649 |  | LIST_BIND | _SI.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-6cc4e797 | cboUnitQty.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1653 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-aa1eefc8 | cboUnitQty.SelectedIndexChanged | SCP0100_Global_PSI_Report.cs:1656 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0100_Global_PSI_Report.SetCalendar

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fefd6d19 | this.Load 외 1 | SCP0100_Global_PSI_Report.cs:1319 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0100_Global_PSI_Report.SetGridClear

진입점: cboPlanDate.SelectedIndexChanged [if (cboSearchLevel != null)] / cboBucketType.SelectedIndexChanged [if (_SI != null)] / cboSearchLevel.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91298cc8 | cboPlanDate.SelectedIndexChanged [if (cboSearchLevel != null… 외 2 | SCP0100_Global_PSI_Report.cs:1820 | if (_SI != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (_SPD) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0100_Global_PSI_Report.SetLayout

진입점: this.Load / cboSearchLevel.SelectedIndexChanged / rgrpSearchLevel.SelectedIndexChanged / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9fd14d2 | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1498 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 1: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL1"), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-01c16022 | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1499 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 1: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL2"), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fe16bc54 | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1500 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 1: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL3"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8300ffee | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1509 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 2: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL1"), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-95ea1955 | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1510 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 2: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL2"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b414197a | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1511 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 2: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL3"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5263f7f8 | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1518 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 3: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL1"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ee782a60 | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1519 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 3: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL2"), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e98c41a9 | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1520 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 3: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL3"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c391b803 | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1527 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 4: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL1"), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8790ccda | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1528 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 4: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL2"), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-330ff018 | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1529 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) case 4: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL3"), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6be31832 | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1536 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) default: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL1"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-604cc0bf | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1537 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) default: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL2"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-135272d6 | this.Load 외 4 | SCP0100_Global_PSI_Report.cs:1538 | try ▸ if (!_is_detail) ▸ switch (cboSearchLevel.SelectedIndex) default: | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex("PRODUCT_LEVEL3"), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0100_Global_PSI_Report.SetSpreadColumn

진입점: this.Load / cboPlanDate.SelectedIndexChanged [if (cboSearchLevel != null)] / cboBucketType.SelectedIndexChanged [if (_SI != null)] / rgrpSearchLevel.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / dCalendar.ValueChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9f25f0e | this.Load 외 7 | SCP0100_Global_PSI_Report.cs:1103 | for (iCol < _SI.ActiveSheet.Columns.Count) ▸ if (_bucket_type.Equals("MONTHLY")) ▸ if (ColName.IndexOf("M_") == 0) | GRID_SET | _SI.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b2f81bc8 | this.Load 외 7 | SCP0100_Global_PSI_Report.cs:1107 | for (iCol < _SI.ActiveSheet.Columns.Count) ▸ if (_bucket_type.Equals("MONTHLY")) ▸ else of (ColName.IndexOf("M_") == 0) | GRID_SET | _SI.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-95c75c1b | this.Load 외 7 | SCP0100_Global_PSI_Report.cs:1114 | for (iCol < _SI.ActiveSheet.Columns.Count) ▸ else of (_bucket_type.Equals("MONTHLY")) ▸ if (_bucket_type.Equals("WEEKLY")) ▸ if (ColName.Ind… | GRID_SET | _SI.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1691625b | this.Load 외 7 | SCP0100_Global_PSI_Report.cs:1118 | for (iCol < _SI.ActiveSheet.Columns.Count) ▸ else of (_bucket_type.Equals("MONTHLY")) ▸ if (_bucket_type.Equals("WEEKLY")) ▸ else of (ColNam… | GRID_SET | _SI.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0100_Global_PSI_Report.SetUnitQty

진입점: cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tables[0].Rows.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1dc956b4 | cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tab… | SCP0100_Global_PSI_Report.cs:1700 | switch (cboUnitQty.SelectedIndex) case 0: | FLAG | dbDivideQty | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-4c8d069b | cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tab… | SCP0100_Global_PSI_Report.cs:1703 | switch (cboUnitQty.SelectedIndex) case 1: | FLAG | dbDivideQty | 1000 | 화면 필드/플래그 변경 |  |  |  |
| AC-0ba6b400 | cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tab… | SCP0100_Global_PSI_Report.cs:1706 | switch (cboUnitQty.SelectedIndex) case 2: | FLAG | dbDivideQty | 1000000 | 화면 필드/플래그 변경 |  |  |  |
| AC-33c62da4 | cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tab… | SCP0100_Global_PSI_Report.cs:1709 | switch (cboUnitQty.SelectedIndex) case 3: | FLAG | dbDivideQty | 100000000 | 화면 필드/플래그 변경 |  |  |  |
| AC-5f3b6169 | cboUnitQty.SelectedIndexChanged [for (i < dsOrigianlCopy.Tab… | SCP0100_Global_PSI_Report.cs:1712 | switch (cboUnitQty.SelectedIndex) default: | FLAG | dbDivideQty | 1 | 화면 필드/플래그 변경 |  |  |  |

## SCP0100_Global_PSI_Report.SetVisibleColumnCycle

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9d69a7e | (진입점 미연결) | SCP0100_Global_PSI_Report.cs:1290 | try ▸ for (i < _SI.ActiveSheet.ColumnCount) | GRID_INIT | _SI.VisibleColumns | (_SI.GetColumnIndex(day), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0100_Global_PSI_Report.VisibleSheet

진입점: cboSearchLevel.SelectedIndexChanged / rgrpSearchLevel.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74f7ff6c | cboSearchLevel.SelectedIndexChanged 외 1 | SCP0100_Global_PSI_Report.cs:1880 | if (_is_detail) | STATE | spdSearchLevel.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a92b9e66 | cboSearchLevel.SelectedIndexChanged 외 1 | SCP0100_Global_PSI_Report.cs:1881 | if (_is_detail) | STATE | spdSearchLevelDetail.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-1925698f | cboSearchLevel.SelectedIndexChanged 외 1 | SCP0100_Global_PSI_Report.cs:1882 | if (_is_detail) | STATE | spdDetail.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-21d9c769 | cboSearchLevel.SelectedIndexChanged 외 1 | SCP0100_Global_PSI_Report.cs:1888 | else of (_is_detail) ▸ if (_search_level == "CELL_GROUP_DETAIL") | STATE | spdSearchLevelDetail.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-ad5f9c93 | cboSearchLevel.SelectedIndexChanged 외 1 | SCP0100_Global_PSI_Report.cs:1889 | else of (_is_detail) ▸ if (_search_level == "CELL_GROUP_DETAIL") | STATE | spdSearchLevel.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-dcd84fd6 | cboSearchLevel.SelectedIndexChanged 외 1 | SCP0100_Global_PSI_Report.cs:1893 | else of (_is_detail) ▸ else of (_search_level == "CELL_GROUP_DETAIL") | STATE | spdSearchLevelDetail.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e2538c94 | cboSearchLevel.SelectedIndexChanged 외 1 | SCP0100_Global_PSI_Report.cs:1894 | else of (_is_detail) ▸ else of (_search_level == "CELL_GROUP_DETAIL") | STATE | spdSearchLevel.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-77f144b6 | cboSearchLevel.SelectedIndexChanged 외 1 | SCP0100_Global_PSI_Report.cs:1896 | else of (_is_detail) | STATE | spdDetail.Visible | false | 컨트롤 상태 Visible |  |  |  |


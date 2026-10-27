# AS-IS 액션 대조표 — SSP0020

> 원천: `Doc/asisfacts/screens/SSP0020/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 198행 · 메서드 17 · 종류 DATA_OP 56 · UI_PROP 22 · RETURN 20 · GRID_INIT 20 · MESSAGE 19 · ENDPOINT 11 · FLAG 10 · UI_MISC 9 · VALUE_SET 8 · POPUP 8 · GRID_SET 7 · GRID_BIND 2 · GRID_LOCK 2 · CALL_EXT 1 · VALIDATE 1 · LIST_CLEAR 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 1


## SSP0020_Delegate.BtnSave_Click

진입점: btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-046dded5 | btnSave.Click | SSP0020_Delegate.cs:343 | if (this.UserName_Search(txtDelegatee.Text) == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d65c3a0 | btnSave.Click | SSP0020_Delegate.cs:349 | if (Validation_Check() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-682cff79 | btnSave.Click | SSP0020_Delegate.cs:359 | else of (SaveData() == true) | MESSAGE | MessageBox.Show | (errorMsg, errCode, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |

## SSP0020_Delegate.BtnUnSet_Click

진입점: btnUnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8affb65 | btnUnSet.Click | SSP0020_Delegate.cs:571 | if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (bChk == true) ▸ else of (UnSet() == true) | MESSAGE | MessageBox.Show | (errorMsg, errCode, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-a94b39d7 | btnUnSet.Click | SSP0020_Delegate.cs:576 | if (siMain.ActiveSheet.Rows.Count > 0) ▸ else of (bChk == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00300", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-92242773 | btnUnSet.Click | SSP0020_Delegate.cs:577 | if (siMain.ActiveSheet.Rows.Count > 0) ▸ else of (bChk == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0020_Delegate.chkAll_CheckStateChanged

진입점: this.chkAll.CheckStateChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f54bd43d | this.chkAll.CheckStateChanged | SSP0020_Delegate.cs:930 | if (chkAll.Checked == true) ▸ for (i < clbDivision.ItemCount) | VALUE_SET | clbDivision.Items[i].CheckState | CheckState.Checked | 컨트롤 값 설정 |  |  |  |
| AC-5a9726c4 | this.chkAll.CheckStateChanged | SSP0020_Delegate.cs:937 | else of (chkAll.Checked == true) ▸ for (i < clbDivision.ItemCount) | VALUE_SET | clbDivision.Items[i].CheckState | CheckState.Unchecked | 컨트롤 값 설정 |  |  |  |

## SSP0020_Delegate.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-858fe41e | this.Load | SSP0020_Delegate.cs:181 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-41046124 | this.Load | SSP0020_Delegate.cs:182 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMainList, SpdSheet.shtMainList, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-37ba69ee | this.Load | SSP0020_Delegate.cs:184 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-2866e823 | this.Load | SSP0020_Delegate.cs:185 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fbcb1940 | this.Load | SSP0020_Delegate.cs:188 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMainList) | 화면 필드/플래그 변경 |  |  |  |
| AC-cbbfce4b | this.Load | SSP0020_Delegate.cs:189 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainList) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0020_Delegate.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee6cfe9c | this.Load | SSP0020_Delegate.cs:124 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-b84f7475 | this.Load | SSP0020_Delegate.cs:126 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-3a9e9255 | this.Load | SSP0020_Delegate.cs:127 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-f5755bc3 | this.Load | SSP0020_Delegate.cs:128 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SSP0020_Delegate.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fca84989 | Dispose | SSP0020_Delegate.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0020_Delegate.FindData_Main

진입점: this.Load / btnSave.Click [if (SaveData() == true)] / btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (bChk == true) ▸ if (UnSet() == true)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d235f27c | this.Load 외 3 | SSP0020_Delegate.cs:248 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a45c16b0 | this.Load 외 3 | SSP0020_Delegate.cs:254 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b1ee80e9 | this.Load 외 3 | SSP0020_Delegate.cs:263 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8a3a9ede | this.Load 외 3 | SSP0020_Delegate.cs:264 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-87815207 | this.Load 외 3 | SSP0020_Delegate.cs:268 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0020_GET_DELEGATE") ⇒ SSP.SSP0020_GET_DELEGATE | 엔드포인트 요청 생성 |  |  |  |
| AC-b0b385a1 | this.Load 외 3 | SSP0020_Delegate.cs:269 | try ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a440eeef | this.Load 외 3 | SSP0020_Delegate.cs:270 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-07e50ad7 | this.Load 외 3 | SSP0020_Delegate.cs:271 | try ▸ lambda | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-990d6a63 | this.Load 외 3 | SSP0020_Delegate.cs:273 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8d685803 | this.Load 외 3 | SSP0020_Delegate.cs:275 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-86b62648 | this.Load 외 3 | SSP0020_Delegate.cs:290 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-02a7cee4 | this.Load 외 3 | SSP0020_Delegate.cs:291 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-85068f0d | this.Load 외 3 | SSP0020_Delegate.cs:293 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-27d444eb | this.Load 외 3 | SSP0020_Delegate.cs:294 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-63e4b21a | this.Load 외 3 | SSP0020_Delegate.cs:299 | try ▸ if (dsBinding.Tables[1].Rows.Count > 0 && isReLoad == false) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainList) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-18cf574a | this.Load 외 3 | SSP0020_Delegate.cs:300 | try ▸ if (dsBinding.Tables[1].Rows.Count > 0 && isReLoad == false) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMainList) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bf9b6836 | this.Load 외 3 | SSP0020_Delegate.cs:303 | try ▸ if (dsBinding.Tables[1].Rows.Count > 0 && isReLoad == false) | DATA_OP | dsBinding.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4e7e1d58 | this.Load 외 3 | SSP0020_Delegate.cs:304 | try ▸ if (dsBinding.Tables[1].Rows.Count > 0 && isReLoad == false) | DATA_OP | dsDelegated.Tables.Add | (dtDelegated) | 데이터 객체 조작/조회 |  |  |  |
| AC-901ed0c5 | this.Load 외 3 | SSP0020_Delegate.cs:306 | try ▸ if (dsBinding.Tables[1].Rows.Count > 0 && isReLoad == false) | GRID_BIND | siMain.Query | (dsDelegated) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cbd7b933 | this.Load 외 3 | SSP0020_Delegate.cs:307 | try ▸ if (dsBinding.Tables[1].Rows.Count > 0 && isReLoad == false) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3f3a5ea3 | this.Load 외 3 | SSP0020_Delegate.cs:309 | try | FLAG | dtFind_Data | dsBinding.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-ff9a5e37 | this.Load 외 3 | SSP0020_Delegate.cs:309 | try | DATA_OP | dsBinding.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-feba2ce8 | this.Load 외 3 | SSP0020_Delegate.cs:312 | try ▸ if (intActiveSheetIdx == 0) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-016fa882 | this.Load 외 3 | SSP0020_Delegate.cs:313 | try ▸ if (intActiveSheetIdx == 0) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-85698b60 | this.Load 외 3 | SSP0020_Delegate.cs:317 | try ▸ else of (intActiveSheetIdx == 0) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainList) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8074ad6f | this.Load 외 3 | SSP0020_Delegate.cs:318 | try ▸ else of (intActiveSheetIdx == 0) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMainList) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8bfac0a9 | this.Load 외 3 | SSP0020_Delegate.cs:325 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-966ad496 | this.Load 외 3 | SSP0020_Delegate.cs:334 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0020_Delegate.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffcc25a1 | this.Load | SSP0020_Delegate.cs:110 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0020_Delegate.InitControls

진입점: this.Load / btnSave.Click [if (SaveData() == true)] / btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (bChk == true) ▸ if (UnSet() == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36f90345 | this.Load 외 2 | SSP0020_Delegate.cs:134 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-edc2bb09 | this.Load 외 2 | SSP0020_Delegate.cs:135 |  | CALL_EXT | chkAll.BringToFront | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c300c9e | this.Load 외 2 | SSP0020_Delegate.cs:137 |  | FLAG | dtMyDivision | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-f72c909c | this.Load 외 2 | SSP0020_Delegate.cs:137 |  | DATA_OP | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2c2fcbb7 | this.Load 외 2 | SSP0020_Delegate.cs:137 |  | DATA_OP | dtMyDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f239d187 | this.Load 외 2 | SSP0020_Delegate.cs:141 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-79344058 | this.Load 외 2 | SSP0020_Delegate.cs:145 | else of (dtMyDivision.Rows.Count == 0) | LIST_CLEAR | clbDivision.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-54d7bccf | this.Load 외 2 | SSP0020_Delegate.cs:152 | else of (dtMyDivision.Rows.Count == 0) | UI_PROP | layoutControlItem4.MinSize | newSize | 속성 MinSize 설정 |  |  |  |
| AC-4cfcee52 | this.Load 외 2 | SSP0020_Delegate.cs:153 | else of (dtMyDivision.Rows.Count == 0) | UI_PROP | layoutControlItem4.MaxSize | newSize | 속성 MaxSize 설정 |  |  |  |
| AC-442ba0ce | this.Load 외 2 | SSP0020_Delegate.cs:159 | else of (dtMyDivision.Rows.Count == 0) ▸ for (i < dtMyDivision.Rows.Count) | DATA_OP | clbDivision.Items.AddRange | (new CheckedListBoxItem[] { new CheckedListBoxItem(dtMyDivision.Rows[i]["CODE"].ToString()… | 데이터 객체 조작/조회 |  |  |  |
| AC-6029b83c | this.Load 외 2 | SSP0020_Delegate.cs:163 | else of (dtMyDivision.Rows.Count == 0) | VALUE_SET | chkAll.CheckState | CheckState.Unchecked | 컨트롤 값 설정 |  |  |  |
| AC-a52936e8 | this.Load 외 2 | SSP0020_Delegate.cs:166 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |
| AC-c61a1f3c | this.Load 외 2 | SSP0020_Delegate.cs:168 |  | VALUE_CLEAR | txtDelegatee.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a7d9e5d6 | this.Load 외 2 | SSP0020_Delegate.cs:169 |  | FLAG | sDelegateeID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-0de5562b | this.Load 외 2 | SSP0020_Delegate.cs:171 |  | UI_PROP | drpPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-878fa184 | this.Load 외 2 | SSP0020_Delegate.cs:172 |  | UI_PROP | drpPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |
| AC-25013f21 | this.Load 외 2 | SSP0020_Delegate.cs:173 |  | UI_PROP | drpPeriod.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-007d7b44 | this.Load 외 2 | SSP0020_Delegate.cs:174 |  | UI_PROP | drpPeriod.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-0e625ef5 | this.Load 외 2 | SSP0020_Delegate.cs:176 |  | VALUE_SET | chkAll.CheckState | CheckState.Checked | 컨트롤 값 설정 |  |  |  |

## SSP0020_Delegate.InitSpread

진입점: this.Load / btnSave.Click [if (SaveData() == true) ▸ try] / btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (bChk == true) ▸ if (UnSet() == true) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3472bedf | this.Load 외 3 | SSP0020_Delegate.cs:198 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-f0e4f4c3 | this.Load 외 3 | SSP0020_Delegate.cs:199 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-90701a10 | this.Load 외 3 | SSP0020_Delegate.cs:200 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17e137ea | this.Load 외 3 | SSP0020_Delegate.cs:201 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e396bb6a | this.Load 외 3 | SSP0020_Delegate.cs:206 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtMainList) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMainList) | 그리드 재구성/초기화 |  |  |  |
| AC-6539f157 | this.Load 외 3 | SSP0020_Delegate.cs:207 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtMainList) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-2fff27e0 | this.Load 외 3 | SSP0020_Delegate.cs:208 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtMainList) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e0d400fa | this.Load 외 3 | SSP0020_Delegate.cs:209 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtMainList) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1ba03384 | this.Load 외 3 | SSP0020_Delegate.cs:216 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-509e484c | this.Load 외 3 | SSP0020_Delegate.cs:217 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-9ca9fcd6 | this.Load 외 3 | SSP0020_Delegate.cs:218 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SSP0020_Delegate.SaveData

진입점: btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83ea8115 | btnSave.Click | SSP0020_Delegate.cs:482 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-49d049a0 | btnSave.Click | SSP0020_Delegate.cs:483 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-469c7a44 | btnSave.Click | SSP0020_Delegate.cs:507 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0020_SAVE_DELEGATE") ⇒ SSP.SSP0020_SAVE_DELEGATE | 엔드포인트 요청 생성 |  |  |  |
| AC-c75b23fc | btnSave.Click | SSP0020_Delegate.cs:509 | if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6ec9ea8d | btnSave.Click | SSP0020_Delegate.cs:510 | if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_delegatee_id"] | p_delegatee_id | 행/컬럼 값 대입 |  |  |  |
| AC-02fd42e5 | btnSave.Click | SSP0020_Delegate.cs:511 | if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-130da097 | btnSave.Click | SSP0020_Delegate.cs:512 | if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_date"] | p_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-3352a78c | btnSave.Click | SSP0020_Delegate.cs:513 | if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-755da501 | btnSave.Click | SSP0020_Delegate.cs:514 | if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-d6e3ed39 | btnSave.Click | SSP0020_Delegate.cs:515 | if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-c7ef2138 | btnSave.Click | SSP0020_Delegate.cs:517 | if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b1fe2be8 | btnSave.Click | SSP0020_Delegate.cs:521 | if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e3cc2c17 | btnSave.Click | SSP0020_Delegate.cs:523 | if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3bf97730 | btnSave.Click | SSP0020_Delegate.cs:527 | if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f3a79356 | btnSave.Click | SSP0020_Delegate.cs:528 | if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d06eac48 | btnSave.Click | SSP0020_Delegate.cs:534 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b839f37b | btnSave.Click | SSP0020_Delegate.cs:535 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0cca2ba5 | btnSave.Click | SSP0020_Delegate.cs:536 | if (iCount > 0) ▸ catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7e7437e0 | btnSave.Click | SSP0020_Delegate.cs:543 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SSP0020_Delegate.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5686e4d2 | spdMain.CellClick | SSP0020_Delegate.cs:859 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-138a3b50 | spdMain.CellClick | SSP0020_Delegate.cs:863 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-d5e1846d | spdMain.CellClick | SSP0020_Delegate.cs:870 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-a274c6bf | spdMain.CellClick | SSP0020_Delegate.cs:874 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |

## SSP0020_Delegate.SpdMain_SheetTabClick

진입점: spdMain.SheetTabClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdbe8697 | spdMain.SheetTabClick | SSP0020_Delegate.cs:236 | if (e.SheetTabIndex == 0) | UI_PROP | lcBtnSave.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c9c68b6e | spdMain.SheetTabClick | SSP0020_Delegate.cs:237 | if (e.SheetTabIndex == 0) | UI_PROP | lcBtnUnset.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4214cba5 | spdMain.SheetTabClick | SSP0020_Delegate.cs:241 | else of (e.SheetTabIndex == 0) | UI_PROP | lcBtnSave.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d4717d8e | spdMain.SheetTabClick | SSP0020_Delegate.cs:242 | else of (e.SheetTabIndex == 0) | UI_PROP | lcBtnUnset.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0020_Delegate.UnSet

진입점: btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (bChk == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d44eab70 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:584 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f865aa4b | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:588 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-52e21210 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:657 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (bChk) ▸ else of (intSaveCnt == 0) ▸ else of (strKey == strKey2) ▸ if (strKey != strKey2) ▸… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0020_SAVE_UNSET") ⇒ SSP.SSP0020_SAVE_UNSET | 엔드포인트 요청 생성 |  |  |  |
| AC-967921a9 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:661 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (bChk) ▸ else of (intSaveCnt == 0) ▸ else of (strKey == strKey2) ▸ if (strKey != strKey2) ▸… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4588e866 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:662 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (bChk) ▸ else of (intSaveCnt == 0) ▸ else of (strKey == strKey2) ▸ if (strKey != strKey2) ▸… | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-2c85961c | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:663 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (bChk) ▸ else of (intSaveCnt == 0) ▸ else of (strKey == strKey2) ▸ if (strKey != strKey2) ▸… | DATA_OP | request.Parameters["p_to_date"] | p_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-e89f54d2 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:664 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (bChk) ▸ else of (intSaveCnt == 0) ▸ else of (strKey == strKey2) ▸ if (strKey != strKey2) ▸… | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-d5befd5d | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:665 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (bChk) ▸ else of (intSaveCnt == 0) ▸ else of (strKey == strKey2) ▸ if (strKey != strKey2) ▸… | DATA_OP | request.Parameters["p_delegate"] | p_delegate | 행/컬럼 값 대입 |  |  |  |
| AC-8f5f440c | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:666 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (bChk) ▸ else of (intSaveCnt == 0) ▸ else of (strKey == strKey2) ▸ if (strKey != strKey2) ▸… | DATA_OP | request.Parameters["p_last_update_by"] | p_last_update_by | 행/컬럼 값 대입 |  |  |  |
| AC-d33f849d | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:667 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (bChk) ▸ else of (intSaveCnt == 0) ▸ else of (strKey == strKey2) ▸ if (strKey != strKey2) ▸… | DATA_OP | request.Parameters["p_last_update_date"] | p_last_update_date | 행/컬럼 값 대입 |  |  |  |
| AC-3dfb578e | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:668 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (bChk) ▸ else of (intSaveCnt == 0) ▸ else of (strKey == strKey2) ▸ if (strKey != strKey2) ▸… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-9179712a | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:669 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (bChk) ▸ else of (intSaveCnt == 0) ▸ else of (strKey == strKey2) ▸ if (strKey != strKey2) ▸… | DATA_OP | request.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-66635f64 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:671 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (bChk) ▸ else of (intSaveCnt == 0) ▸ else of (strKey == strKey2) ▸ if (strKey != strKey2) ▸… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-41133dbf | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:715 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (i == siMain.ActiveSheet.RowCount - 1) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0020_SAVE_UNSET") ⇒ SSP.SSP0020_SAVE_UNSET | 엔드포인트 요청 생성 |  |  |  |
| AC-08f070f0 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:719 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (i == siMain.ActiveSheet.RowCount - 1) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8def2845 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:720 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (i == siMain.ActiveSheet.RowCount - 1) | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-5561d7da | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:721 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (i == siMain.ActiveSheet.RowCount - 1) | DATA_OP | request.Parameters["p_to_date"] | p_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-a5ef1af5 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:722 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (i == siMain.ActiveSheet.RowCount - 1) | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-90d5510a | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:723 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (i == siMain.ActiveSheet.RowCount - 1) | DATA_OP | request.Parameters["p_delegate"] | p_delegate | 행/컬럼 값 대입 |  |  |  |
| AC-103c9c8c | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:724 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (i == siMain.ActiveSheet.RowCount - 1) | DATA_OP | request.Parameters["p_last_update_by"] | p_last_update_by | 행/컬럼 값 대입 |  |  |  |
| AC-190c87e1 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:725 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (i == siMain.ActiveSheet.RowCount - 1) | DATA_OP | request.Parameters["p_last_update_date"] | p_last_update_date | 행/컬럼 값 대입 |  |  |  |
| AC-63849eec | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:726 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (i == siMain.ActiveSheet.RowCount - 1) | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d2d46035 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:727 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (i == siMain.ActiveSheet.RowCount - 1) | DATA_OP | request.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-60afc710 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:729 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (i == siMain.ActiveSheet.RowCount - 1) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a7fe0a09 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:747 | try ▸ if (bolSuessceChk == true) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-68e5ccde | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:749 | try ▸ if (bolSuessceChk == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { intSaveCnt.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-575979a5 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:754 | try ▸ else of (bolSuessceChk == true) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c3804d89 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:757 | try ▸ else of (bolSuessceChk == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0270db16 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:761 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4a32123a | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:762 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-13aae585 | btnUnSet.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if … | SSP0020_Delegate.cs:768 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SSP0020_Delegate.UserName_Search

진입점: btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-feba0ebd | btnSave.Click | SSP0020_Delegate.cs:781 |  | ENDPOINT | new FoxDataRequest | ("SSP.UP_FX_GetSSPUserUseInfoList") ⇒ SSP.UP_FX_GetSSPUserUseInfoList | 엔드포인트 요청 생성 |  |  |  |
| AC-fda2ebf7 | btnSave.Click | SSP0020_Delegate.cs:782 |  | DATA_OP | request.Parameters["Search"] | strDelegatee_Name | 행/컬럼 값 대입 |  |  |  |
| AC-341352cf | btnSave.Click | SSP0020_Delegate.cs:783 |  | DATA_OP | request.Parameters["Language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-f1db9714 | btnSave.Click | SSP0020_Delegate.cs:784 |  | DATA_OP | request.Parameters["UseYN"] | 'Y' | 행/컬럼 값 대입 |  |  |  |
| AC-ab069a6f | btnSave.Click | SSP0020_Delegate.cs:786 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9954e8b0 | btnSave.Click | SSP0020_Delegate.cs:791 | if (dsUserList.Tables[0].Rows.Count == 1) | FLAG | sDelegateeID | dsUserList.Tables[0].Rows[0]["UserID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f1e585a3 | btnSave.Click | SSP0020_Delegate.cs:793 | if (dsUserList.Tables[0].Rows.Count == 1) ▸ if (sLanguage == "KO") | VALUE_SET | txtDelegatee.Text | dsUserList.Tables[0].Rows[0]["UserName"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8e0fb1b5 | btnSave.Click | SSP0020_Delegate.cs:795 | if (dsUserList.Tables[0].Rows.Count == 1) ▸ else of (sLanguage == "KO") | VALUE_SET | txtDelegatee.Text | dsUserList.Tables[0].Rows[0]["UserName_E"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-af0cf91c | btnSave.Click | SSP0020_Delegate.cs:797 | if (dsUserList.Tables[0].Rows.Count == 1) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-7b289780 | btnSave.Click | SSP0020_Delegate.cs:802 | else of (dsUserList.Tables[0].Rows.Count == 1) ▸ if (dsUserList.Tables[0].Rows.Count > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00302") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aaf5a29b | btnSave.Click | SSP0020_Delegate.cs:806 | else of (dsUserList.Tables[0].Rows.Count == 1) ▸ if (dsUserList.Tables[0].Rows.Count > 1) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-dc49978c | btnSave.Click | SSP0020_Delegate.cs:811 | else of (dsUserList.Tables[0].Rows.Count == 1) ▸ else of (dsUserList.Tables[0].Rows.Count > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00301") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-42643fdb | btnSave.Click | SSP0020_Delegate.cs:815 | else of (dsUserList.Tables[0].Rows.Count == 1) ▸ else of (dsUserList.Tables[0].Rows.Count > 1) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SSP0020_Delegate.UserPopup

진입점: btnDelegatee.Click / btnSave.Click [else of (dsUserList.Tables[0].Rows.Count == 1) ▸ if (dsUserList.Tables[0].Rows.Count > 1) ▸ if (MessageHelper.GMessageBox("MSG00302") == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93ba4813 | btnDelegatee.Click 외 1 | SSP0020_Delegate.cs:821 |  | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7596bb89 | btnDelegatee.Click 외 1 | SSP0020_Delegate.cs:823 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-7df4722d | btnDelegatee.Click 외 1 | SSP0020_Delegate.cs:824 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-f0a6c2a3 | btnDelegatee.Click 외 1 | SSP0020_Delegate.cs:825 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-06618716 | btnDelegatee.Click 외 1 | SSP0020_Delegate.cs:826 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-8cf8ee72 | btnDelegatee.Click 외 1 | SSP0020_Delegate.cs:827 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-7190099b | btnDelegatee.Click 외 1 | SSP0020_Delegate.cs:829 |  | UI_PROP | popup.strSearch | txtDelegatee.Text | 속성 strSearch 설정 |  |  |  |
| AC-21cf9866 | btnDelegatee.Click 외 1 | SSP0020_Delegate.cs:830 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-9491815c | btnDelegatee.Click 외 1 | SSP0020_Delegate.cs:832 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4be52f83 | btnDelegatee.Click 외 1 | SSP0020_Delegate.cs:838 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sDelegateeID | item.UserID | 화면 필드/플래그 변경 |  |  |  |
| AC-297062c0 | btnDelegatee.Click 외 1 | SSP0020_Delegate.cs:841 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtDelegatee.Text | item.UserName | 컨트롤 값 설정 |  |  |  |
| AC-355d7418 | btnDelegatee.Click 외 1 | SSP0020_Delegate.cs:843 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtDelegatee.Text | item.UserName_E | 컨트롤 값 설정 |  |  |  |

## SSP0020_Delegate.Validation_Check

진입점: btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5529140a | btnSave.Click | SSP0020_Delegate.cs:372 | if (string.IsNullOrWhiteSpace(txtDelegatee.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00298", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3dada15c | btnSave.Click | SSP0020_Delegate.cs:373 | if (string.IsNullOrWhiteSpace(txtDelegatee.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b3d010c5 | btnSave.Click | SSP0020_Delegate.cs:379 | if (sDelegateeID == UserInfoContext.Current.UserId) | MESSAGE | MessageHelper.GMessageBox | ("MSG00305", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a7c1bc4 | btnSave.Click | SSP0020_Delegate.cs:380 | if (sDelegateeID == UserInfoContext.Current.UserId) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b843f9d8 | btnSave.Click | SSP0020_Delegate.cs:385 | if (string.IsNullOrEmpty(p_from_date) \|\| string.IsNullOrEmpty(p_to_date)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d218907 | btnSave.Click | SSP0020_Delegate.cs:386 | if (string.IsNullOrEmpty(p_from_date) \|\| string.IsNullOrEmpty(p_to_date)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e82f5dbc | btnSave.Click | SSP0020_Delegate.cs:393 | else of (string.IsNullOrEmpty(p_from_date) \|\| string.IsNullOrEmpty(p_to_date)) ▸ if (Convert.ToInt32(p_from_date) > Convert.ToInt32(p_to_d… | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-21395d3f | btnSave.Click | SSP0020_Delegate.cs:394 | else of (string.IsNullOrEmpty(p_from_date) \|\| string.IsNullOrEmpty(p_to_date)) ▸ if (Convert.ToInt32(p_from_date) > Convert.ToInt32(p_to_d… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b52f8423 | btnSave.Click | SSP0020_Delegate.cs:417 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-aa48412c | btnSave.Click | SSP0020_Delegate.cs:418 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0bed5b45 | btnSave.Click | SSP0020_Delegate.cs:419 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("FROM_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-42a85ba8 | btnSave.Click | SSP0020_Delegate.cs:420 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("FROM_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c4eab75a | btnSave.Click | SSP0020_Delegate.cs:421 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("TO_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-400e7e23 | btnSave.Click | SSP0020_Delegate.cs:422 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("TO_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-94488c80 | btnSave.Click | SSP0020_Delegate.cs:426 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ if (intCount … | MESSAGE | MessageHelper.GMessageBox | ("MSG00105", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e7e02b42 | btnSave.Click | SSP0020_Delegate.cs:427 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ if (intCount … | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1cbd7607 | btnSave.Click | SSP0020_Delegate.cs:431 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f2c6b154 | btnSave.Click | SSP0020_Delegate.cs:432 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a125169 | btnSave.Click | SSP0020_Delegate.cs:433 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-435aad6b | btnSave.Click | SSP0020_Delegate.cs:434 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("FROM_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-99ee3f68 | btnSave.Click | SSP0020_Delegate.cs:435 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("FROM_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc8c6500 | btnSave.Click | SSP0020_Delegate.cs:436 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("TO_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b7e9985d | btnSave.Click | SSP0020_Delegate.cs:437 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("TO_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b82f118 | btnSave.Click | SSP0020_Delegate.cs:440 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ if (intCount … | MESSAGE | MessageHelper.GMessageBox | ("MSG00296", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ea514f8f | btnSave.Click | SSP0020_Delegate.cs:441 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ if (intCount … | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d374dfc5 | btnSave.Click | SSP0020_Delegate.cs:445 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-490252e2 | btnSave.Click | SSP0020_Delegate.cs:446 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a37d0b4d | btnSave.Click | SSP0020_Delegate.cs:447 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("DELEGATEE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dddf45e5 | btnSave.Click | SSP0020_Delegate.cs:448 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("FROM_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-67bba25d | btnSave.Click | SSP0020_Delegate.cs:449 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("FROM_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d50b216 | btnSave.Click | SSP0020_Delegate.cs:450 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("TO_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd26a384 | btnSave.Click | SSP0020_Delegate.cs:451 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ lambda | DATA_OP | row.Field | ("TO_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bab96506 | btnSave.Click | SSP0020_Delegate.cs:454 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ if (intCount … | MESSAGE | MessageHelper.GMessageBox | ("MSG00297", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a5a707b0 | btnSave.Click | SSP0020_Delegate.cs:455 | if (bolDivisionChk == true) ▸ for (i < clbDivision.Items.Count) ▸ if (clbDivision.Items[i].CheckState == CheckState.Checked) ▸ if (intCount … | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c6dfe047 | btnSave.Click | SSP0020_Delegate.cs:462 | else of (bolDivisionChk == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00299", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2220a1fb | btnSave.Click | SSP0020_Delegate.cs:463 | else of (bolDivisionChk == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-29a612bd | btnSave.Click | SSP0020_Delegate.cs:466 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |


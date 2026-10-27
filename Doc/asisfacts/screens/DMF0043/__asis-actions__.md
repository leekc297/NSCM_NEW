# AS-IS 액션 대조표 — DMF0043

> 원천: `Doc/asisfacts/screens/DMF0043/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 376행 · 메서드 67 · 종류 DATA_OP 92 · GRID_INIT 48 · UI_PROP 35 · UI_MISC 33 · ENDPOINT 33 · RETURN 27 · FLAG 18 · POPUP 17 · MESSAGE 17 · GRID_LOCK 10 · CALL_EXT 9 · LIST_REBIND 9 · GRID_SET 7 · VALUE_SET 7 · COMBO_DATA 5 · GRID_BIND 4 · THROW 2 · GRID_COMBO 1 · STATE 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 9


## DMF0043_Contribute_Main.btnCutOff_Click

진입점: this.btnCutOff.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a18dd46a | this.btnCutOff.Click | DMF0043_Contribute_Main.cs:575 |  | POPUP | new DMF0043_ContributeRatePopup | () | 팝업/폼 생성 |  |  |  |
| AC-87a26ed1 | this.btnCutOff.Click | DMF0043_Contribute_Main.cs:576 |  | CALL_EXT | popup.LoadData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef257301 | this.btnCutOff.Click | DMF0043_Contribute_Main.cs:578 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9f591738 | this.btnCutOff.Click | DMF0043_Contribute_Main.cs:579 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0043_Contribute_Main.chkYear_CheckedChanged

진입점: this.chkYear.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-605c4601 | this.chkYear.CheckedChanged | DMF0043_Contribute_Main.cs:703 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00266") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-91b8aa0c | this.chkYear.CheckedChanged | DMF0043_Contribute_Main.cs:704 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0043_Contribute_Main.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcc5f9bf | this.Load | DMF0043_Contribute_Main.cs:133 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 60) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7a41c3c4 | this.Load | DMF0043_Contribute_Main.cs:134 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-58cb8855 | this.Load | DMF0043_Contribute_Main.cs:135 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0043_Contribute_Main.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b1f6b2c | this.Load | DMF0043_Contribute_Main.cs:122 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-07777819 | this.Load | DMF0043_Contribute_Main.cs:123 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-135bcc3c | this.Load | DMF0043_Contribute_Main.cs:124 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## DMF0043_Contribute_Main.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78782bc1 | Dispose | DMF0043_Contribute_Main.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0043_Contribute_Main.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ade4a990 | EditButton | DMF0043_Contribute_Main.cs:195 | if (this.fps != null) ▸ if (usrHis.Checked == false) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e6d80da | EditButton | DMF0043_Contribute_Main.cs:196 | if (this.fps != null) ▸ if (usrHis.Checked == false) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-4ece4fbc | EditButton | DMF0043_Contribute_Main.cs:198 | if (this.fps != null) ▸ if (usrHis.Checked == false) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.EDIT_FLAG), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-698303bf | EditButton | DMF0043_Contribute_Main.cs:204 | if (this.fps != null) ▸ if (usrHis.Checked == false) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnInd… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_FLAG) + 1, iRow, siMain.GetMaxColumnIndex(), … | 그리드 편집 잠금/해제 |  |  |  |

## DMF0043_Contribute_Main.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94c45aa8 | ExcelButton | DMF0043_Contribute_Main.cs:223 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-b2dd0793 | ExcelButton | DMF0043_Contribute_Main.cs:224 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-54b48ddc | ExcelButton | DMF0043_Contribute_Main.cs:225 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.ShowZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-186d5902 | ExcelButton | DMF0043_Contribute_Main.cs:226 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-8d046688 | ExcelButton | DMF0043_Contribute_Main.cs:227 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-858cad07 | ExcelButton | DMF0043_Contribute_Main.cs:228 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-f5806ae7 | ExcelButton | DMF0043_Contribute_Main.cs:230 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-6011a0a8 | ExcelButton | DMF0043_Contribute_Main.cs:231 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-e3a51f88 | ExcelButton | DMF0043_Contribute_Main.cs:233 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-9dbc2ffa | ExcelButton | DMF0043_Contribute_Main.cs:237 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3eb89d64 | ExcelButton | DMF0043_Contribute_Main.cs:242 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-0bd722e0 | ExcelButton | DMF0043_Contribute_Main.cs:246 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0043_Contribute_Main.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if ((response.DataSet.Tables.Count > 0) && (response.DataSet.Tables[0].Rows.Count > 0) && (response.DataSet.Tables[0].Rows[0…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf26099c | FindButton 외 1 | DMF0043_Contribute_Main.cs:264 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a58211f1 | FindButton 외 1 | DMF0043_Contribute_Main.cs:268 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7f94abfb | FindButton 외 1 | DMF0043_Contribute_Main.cs:269 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2e9afa8e | FindButton 외 1 | DMF0043_Contribute_Main.cs:275 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5817d10b | FindButton 외 1 | DMF0043_Contribute_Main.cs:276 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { //… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-04359c99 | FindButton 외 1 | DMF0043_Contribute_Main.cs:289 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0043_GET_CONTRIBUTE_MAIN_DATA") ⇒ DM.DMF0043_GET_CONTRIBUTE_MAIN_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-0db4d725 | FindButton 외 1 | DMF0043_Contribute_Main.cs:290 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4e57182d | FindButton 외 1 | DMF0043_Contribute_Main.cs:291 | try ▸ lambda | DATA_OP | request.Parameters["p_yyyy"] | usrYear.Text.Substring(0, 4) | 행/컬럼 값 대입 |  |  |  |
| AC-92a3532d | FindButton 외 1 | DMF0043_Contribute_Main.cs:292 | try ▸ lambda | DATA_OP | request.Parameters["p_ver_seq"] | usrYear.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-22c77b89 | FindButton 외 1 | DMF0043_Contribute_Main.cs:293 | try ▸ lambda | DATA_OP | request.Parameters["p_dis"] | (usrDiscard.Checked == true) ? "N": "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-921745d5 | FindButton 외 1 | DMF0043_Contribute_Main.cs:294 | try ▸ lambda | DATA_OP | request.Parameters["p_his"] | (usrHis.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-99a973c8 | FindButton 외 1 | DMF0043_Contribute_Main.cs:295 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f9e56015 | FindButton 외 1 | DMF0043_Contribute_Main.cs:296 | try ▸ lambda | DATA_OP | request.Parameters["p_user_group"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d9c9a646 | FindButton 외 1 | DMF0043_Contribute_Main.cs:298 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-32f38df1 | FindButton 외 1 | DMF0043_Contribute_Main.cs:300 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6b53abbf | FindButton 외 1 | DMF0043_Contribute_Main.cs:310 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-db571324 | FindButton 외 1 | DMF0043_Contribute_Main.cs:311 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ffe70b6b | FindButton 외 1 | DMF0043_Contribute_Main.cs:312 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b2b0655e | FindButton 외 1 | DMF0043_Contribute_Main.cs:323 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ed9b71a1 | FindButton 외 1 | DMF0043_Contribute_Main.cs:327 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-cc9cbafb | FindButton 외 1 | DMF0043_Contribute_Main.cs:329 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0043_Contribute_Main.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46d2ffc1 | this.Load | DMF0043_Contribute_Main.cs:100 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-53d0a1e3 | this.Load | DMF0043_Contribute_Main.cs:102 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0043_Contribute_Main.GetCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd348c31 | (진입점 미연결) | DMF0043_Contribute_Main.cs:896 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0043_Contribute_Main.GetCellIndexBySpanRowCells

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5766f81 | (진입점 미연결) | DMF0043_Contribute_Main.cs:569 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d84a26b0 | (진입점 미연결) | DMF0043_Contribute_Main.cs:570 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0043_Contribute_Main.GetLookupData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a98a3b37 | (진입점 미연결) | DMF0043_Contribute_Main.cs:541 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-f9bcdd1a | (진입점 미연결) | DMF0043_Contribute_Main.cs:542 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-aa8f46a3 | (진입점 미연결) | DMF0043_Contribute_Main.cs:543 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ef3f6c7c | (진입점 미연결) | DMF0043_Contribute_Main.cs:545 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0043_Contribute_Main.GetVersionData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4dc6b27 | this.Load | DMF0043_Contribute_Main.cs:716 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0043_GET_MAIN_VARSION_DATA") ⇒ DM.DMF0043_GET_MAIN_VARSION_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-eb499177 | this.Load | DMF0043_Contribute_Main.cs:717 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a67c68d5 | this.Load | DMF0043_Contribute_Main.cs:719 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0043_Contribute_Main.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9019115 | this.Load | DMF0043_Contribute_Main.cs:116 |  | LIST_REBIND | clsCtrl.setListBox | (dt, usrYear, false, "CODE", "NAME2") | 목록 컨트롤 재구성 |  |  |  |

## DMF0043_Contribute_Main.InitSpread

진입점: this.usrDiscard.Click / this.usrHis.CheckedChanged / this.Load / usrYear.SelectedIndexChanged / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if ((response.DataSet.Tables.Count > 0) && (response.DataSet.Tables[0].Rows.Count > 0) && (response.DataSet.Tables[0].Rows[0…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c6599de | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:145 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0043_GET_MAIN_SPREAD_TITLE") ⇒ DM.DMF0043_GET_MAIN_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-63e4e7b4 | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:147 |  | DATA_OP | request.Parameters["p_division_id"] | "40" | 행/컬럼 값 대입 |  |  |  |
| AC-0f1b0ab3 | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:148 |  | DATA_OP | request.Parameters["p_yyyy"] | usrYear.Text.Substring(0, 4) | 행/컬럼 값 대입 |  |  |  |
| AC-d0821906 | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:149 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-496cb684 | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:151 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-18060e70 | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:154 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dt) | 그리드 재구성/초기화 |  |  |  |

## DMF0043_Contribute_Main.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec415eaf | (진입점 미연결) | DMF0043_Contribute_Main.cs:490 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c658755e | (진입점 미연결) | DMF0043_Contribute_Main.cs:492 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3f611a48 | (진입점 미연결) | DMF0043_Contribute_Main.cs:494 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.DMF0005_DM_CONTRIBUTION_TYPE_CD, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0005_DM_CONTRIBUTION_TYPE_CD] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-53fce40d | (진입점 미연결) | DMF0043_Contribute_Main.cs:502 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxColumnI… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, i, dt) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e184a1b8 | (진입점 미연결) | DMF0043_Contribute_Main.cs:527 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0043_Contribute_Main.RetConType

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if ((((chkYear.Checked == true) && (sYYYYMM[0] == "Y")) \|\| ((chkYear.Checked == false) && (sYYYYMM[0] == "M"))) && (sQty != …)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69086caa | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0043_Contribute_Main.cs:884 |  | RETURN | return sRet; |  | 처리 중단/반환 |  |  |  |

## DMF0043_Contribute_Main.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bc1e7c3 | SaveButton | DMF0043_Contribute_Main.cs:339 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8d338f99 | SaveButton | DMF0043_Contribute_Main.cs:340 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-29de4d2e | SaveButton | DMF0043_Contribute_Main.cs:344 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ValidChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00303") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b6a64bf3 | SaveButton | DMF0043_Contribute_Main.cs:345 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ValidChk() == false) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-71440481 | SaveButton | DMF0043_Contribute_Main.cs:346 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ValidChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e4ce526 | SaveButton | DMF0043_Contribute_Main.cs:351 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ValidChk2() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00308") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-050e814f | SaveButton | DMF0043_Contribute_Main.cs:352 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ValidChk2() == false) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-68cb8764 | SaveButton | DMF0043_Contribute_Main.cs:353 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ValidChk2() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-547f8494 | SaveButton | DMF0043_Contribute_Main.cs:435 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO | 엔드포인트 요청 생성 |  |  |  |
| AC-47917982 | SaveButton | DMF0043_Contribute_Main.cs:436 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9f565f4f | SaveButton | DMF0043_Contribute_Main.cs:437 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | pAction.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-a4436511 | SaveButton | DMF0043_Contribute_Main.cs:437 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | pAction.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-500d426d | SaveButton | DMF0043_Contribute_Main.cs:438 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_ver_seq"] | pVER_SEQ.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-6895f4be | SaveButton | DMF0043_Contribute_Main.cs:438 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | pVER_SEQ.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-3340c426 | SaveButton | DMF0043_Contribute_Main.cs:440 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_department_id"] | pDEPARTMENT_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-69f356e6 | SaveButton | DMF0043_Contribute_Main.cs:440 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | pDEPARTMENT_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-9297a428 | SaveButton | DMF0043_Contribute_Main.cs:441 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dept_id"] | pDEPT_ID.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-1541f13c | SaveButton | DMF0043_Contribute_Main.cs:441 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | pDEPT_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-224cd30a | SaveButton | DMF0043_Contribute_Main.cs:442 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_end_cust_report"] | pEND_CUST_REPORT.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-9d66958a | SaveButton | DMF0043_Contribute_Main.cs:442 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | pEND_CUST_REPORT.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-27014a8d | SaveButton | DMF0043_Contribute_Main.cs:443 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_soldto_cust_report"] | pSOLDTO_CUST_REPORT.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-10287467 | SaveButton | DMF0043_Contribute_Main.cs:443 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | pSOLDTO_CUST_REPORT.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba0888a1 | SaveButton | DMF0043_Contribute_Main.cs:444 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_product_group"] | pPRODUCT_GROUP.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-70d7d4d2 | SaveButton | DMF0043_Contribute_Main.cs:444 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | pPRODUCT_GROUP.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a352d3fd | SaveButton | DMF0043_Contribute_Main.cs:445 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dm_biz_type"] | pDM_BIZ_TYPE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-70fd5138 | SaveButton | DMF0043_Contribute_Main.cs:445 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | pDM_BIZ_TYPE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a47ba7d | SaveButton | DMF0043_Contribute_Main.cs:447 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymm"] | pYYYYMM.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-618dff32 | SaveButton | DMF0043_Contribute_Main.cs:447 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | pYYYYMM.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d0c65d6 | SaveButton | DMF0043_Contribute_Main.cs:448 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_os_corp_cd"] | pOS_CORP_CD.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-a5e2adb0 | SaveButton | DMF0043_Contribute_Main.cs:448 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | pOS_CORP_CD.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd1cf665 | SaveButton | DMF0043_Contribute_Main.cs:449 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_contribution_type"] | pCONTRIBUTION_TYPE.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-c68e52e3 | SaveButton | DMF0043_Contribute_Main.cs:449 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | pCONTRIBUTION_TYPE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a70a93d | SaveButton | DMF0043_Contribute_Main.cs:450 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_contribution_ratio"] | pQty.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-0b7ee6a6 | SaveButton | DMF0043_Contribute_Main.cs:450 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | pQty.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb702482 | SaveButton | DMF0043_Contribute_Main.cs:451 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | pUser.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-6f3de1a6 | SaveButton | DMF0043_Contribute_Main.cs:451 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | pUser.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1e5a23a | SaveButton | DMF0043_Contribute_Main.cs:453 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-697b3f3b | SaveButton | DMF0043_Contribute_Main.cs:459 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if ((r… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e4bbbb28 | SaveButton | DMF0043_Contribute_Main.cs:464 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51e614ba | SaveButton | DMF0043_Contribute_Main.cs:471 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7b1c3f4b | SaveButton | DMF0043_Contribute_Main.cs:475 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6d0aa024 | SaveButton | DMF0043_Contribute_Main.cs:479 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0043_Contribute_Main.SetSpreadColumn

진입점: this.chkYear.CheckedChanged / this.usrDiscard.Click / this.usrHis.CheckedChanged / this.Load / usrYear.SelectedIndexChanged / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if ((response.DataSet.Tables.Count > 0) && (response.DataSet.Tables[0].Rows.Count > 0) && (response.DataSet.Tables[0].Rows[0…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f941bd1 | this.chkYear.CheckedChanged 외 6 | DMF0043_Contribute_Main.cs:675 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkYear.Checked == true) ▸ if (siMain.GetColumnTag(iCol).IndexOf("Y#") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d3c97e11 | this.chkYear.CheckedChanged 외 6 | DMF0043_Contribute_Main.cs:679 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkYear.Checked == true) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("Y#") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ab9fcce1 | this.chkYear.CheckedChanged 외 6 | DMF0043_Contribute_Main.cs:680 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkYear.Checked == true) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("Y#") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-d99bdae6 | this.chkYear.CheckedChanged 외 6 | DMF0043_Contribute_Main.cs:687 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkYear.Checked == true) ▸ if (siMain.GetColumnTag(iCol).IndexOf("Y#") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-95487b05 | this.chkYear.CheckedChanged 외 6 | DMF0043_Contribute_Main.cs:688 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkYear.Checked == true) ▸ if (siMain.GetColumnTag(iCol).IndexOf("Y#") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-0d6a136d | this.chkYear.CheckedChanged 외 6 | DMF0043_Contribute_Main.cs:693 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkYear.Checked == true) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("Y#") == 0) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0043_Contribute_Main.SetSpreadHeaderSpan

진입점: this.usrDiscard.Click / this.usrHis.CheckedChanged / this.Load / usrYear.SelectedIndexChanged / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if ((response.DataSet.Tables.Count > 0) && (response.DataSet.Tables[0].Rows.Count > 0) && (response.DataSet.Tables[0].Rows[0…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a73a592e | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:609 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 2, 1, 30, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3308898d | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:617 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3c90ed68 | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:629 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-67853058 | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:630 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf9cea10 | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:635 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c959df2d | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:643 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-328029fb | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:655 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-22198692 | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:657 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fbbcf722 | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:658 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7dcc8d7b | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:660 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.EDIT_FLAG) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fa7cf279 | this.usrDiscard.Click 외 5 | DMF0043_Contribute_Main.cs:662 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0043_Contribute_Main.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2540c4d8 | dsdm.Changed | DMF0043_Contribute_Main.cs:931 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetValue(e.Row, siMain.GetColumnIndex(CAp… | GRID_SET | siMain.SetText | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |

## DMF0043_Contribute_Main.usrDiscard_Click

진입점: this.usrDiscard.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c432934c | this.usrDiscard.Click | DMF0043_Contribute_Main.cs:907 |  | VALUE_SET | usrHis.Checked | false | 컨트롤 값 설정 |  |  |  |

## DMF0043_Contribute_Main.usrHis_CheckedChanged

진입점: this.usrHis.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e579e3a | this.usrHis.CheckedChanged | DMF0043_Contribute_Main.cs:901 |  | VALUE_SET | usrDiscard.Checked | false | 컨트롤 값 설정 |  |  |  |

## DMF0043_Contribute_Main.ValidChk

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3de8575 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0043_Contribute_Main.cs:749 | if (chkYear.Checked == true) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sMode == CAppSetting.StringM) ▸ else of ((dSum == 100) \|\| (dSum… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d0c87d78 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0043_Contribute_Main.cs:752 | if (chkYear.Checked == true) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-303f16de | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0043_Contribute_Main.cs:762 | else of (chkYear.Checked == true) ▸ for (iRow <= siMain.GetMaxRowIndex()) | CALL_EXT | ValidChkCol.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f5ce371 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0043_Contribute_Main.cs:787 | else of (chkYear.Checked == true) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sMode == CAppSetting.StringM) && (bFlag == true)) ▸ for (iC… | DATA_OP | ValidChkCol[sYYYYMM[1]] | dSum.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-53d69679 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0043_Contribute_Main.cs:801 | else of (chkYear.Checked == true) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((sMode == CAppSetting.StringM) && (bFlag == true)) ▸ for (iC… | DATA_OP | ValidChkCol[sYYYYMM[1]] | dSum.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e6137c52 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0043_Contribute_Main.cs:812 | else of (chkYear.Checked == true) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## DMF0043_Contribute_Main.ValidChk2

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e74923a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0043_Contribute_Main.cs:838 | if (chkYear.Checked == true) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sMode == CAppSetting.StringM) ▸ for (iCol <= siMain.GetMaxColumnI… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-dd7ffb12 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0043_Contribute_Main.cs:863 | else of (chkYear.Checked == true) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sMode == CAppSetting.StringM) ▸ for (iCol <= siMain.GetMaxCo… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-240354a1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0043_Contribute_Main.cs:869 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## DMF0043_Contribute_Main.YearSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0a85f79 | (진입점 미연결) | DMF0043_Contribute_Main.cs:551 |  | DATA_OP | dt.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae2a57c1 | (진입점 미연결) | DMF0043_Contribute_Main.cs:552 |  | DATA_OP | dt.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c055d3b7 | (진입점 미연결) | DMF0043_Contribute_Main.cs:559 | for (i <= iToYear) | DATA_OP | dt.Rows.Add | (i, i) | 데이터 객체 조작/조회 |  |  |  |
| AC-84a60881 | (진입점 미연결) | DMF0043_Contribute_Main.cs:561 |  | LIST_REBIND | clsCtrl.setListBox | (dt, usrYear, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2c75d7ad | (진입점 미연결) | DMF0043_Contribute_Main.cs:562 |  | VALUE_SET | usrYear.SelectedValue | DateTime.Now.Year | 컨트롤 값 설정 |  |  |  |

## DMF0043_Contribute_View.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7935307 | this.btnColumn.Click | DMF0043_Contribute_View.cs:525 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0043", SpdSheet.shtMain, true, "40") | 팝업/폼 생성 |  |  |  |
| AC-4e968414 | this.btnColumn.Click | DMF0043_Contribute_View.cs:526 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9e2c72a3 | this.btnColumn.Click | DMF0043_Contribute_View.cs:527 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0043_Contribute_View.btnCutOff_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4caa529f | (진입점 미연결) | DMF0043_Contribute_View.cs:496 |  | POPUP | new DMF0043_ContributeRatePopup | () | 팝업/폼 생성 |  |  |  |
| AC-83f576f0 | (진입점 미연결) | DMF0043_Contribute_View.cs:497 |  | CALL_EXT | popup.LoadData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6badb9be | (진입점 미연결) | DMF0043_Contribute_View.cs:499 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ff6abbb2 | (진입점 미연결) | DMF0043_Contribute_View.cs:500 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0043_Contribute_View.btnSPVer_Click

진입점: this.btnSPVer.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11b8a854 | this.btnSPVer.Click | DMF0043_Contribute_View.cs:507 |  | COMBO_DATA | Data.MultiTimeZone | (UserInfoContext.Current["TimeZone"]) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2472d252 | this.btnSPVer.Click | DMF0043_Contribute_View.cs:511 |  | POPUP | new DMF0043_VersionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-90f7f08c | this.btnSPVer.Click | DMF0043_Contribute_View.cs:512 |  | POPUP | popVersion.Form_Load | (true, "SP", sDivision, sStartDate, sEndDate) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1b7f1ede | this.btnSPVer.Click | DMF0043_Contribute_View.cs:513 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3e3e6e71 | this.btnSPVer.Click | DMF0043_Contribute_View.cs:514 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-79220f69 | this.btnSPVer.Click | DMF0043_Contribute_View.cs:518 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |

## DMF0043_Contribute_View.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56f5b1d0 | this.Load | DMF0043_Contribute_View.cs:134 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d32a36fe | this.Load | DMF0043_Contribute_View.cs:135 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8fd4d415 | this.Load | DMF0043_Contribute_View.cs:136 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0043_Contribute_View.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06cb2bf5 | this.Load | DMF0043_Contribute_View.cs:125 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-098e0abb | this.Load | DMF0043_Contribute_View.cs:126 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-43045ff2 | this.Load | DMF0043_Contribute_View.cs:127 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-83a83fdc | this.Load | DMF0043_Contribute_View.cs:129 |  | VALUE_SET | usrType.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## DMF0043_Contribute_View.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75f39e5e | Dispose | DMF0043_Contribute_View.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0043_Contribute_View.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99bc9a29 | ExcelButton | DMF0043_Contribute_View.cs:288 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-63a49278 | ExcelButton | DMF0043_Contribute_View.cs:289 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-97d45cdd | ExcelButton | DMF0043_Contribute_View.cs:290 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-7c12d6c2 | ExcelButton | DMF0043_Contribute_View.cs:291 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-b8c473b0 | ExcelButton | DMF0043_Contribute_View.cs:292 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-bc481277 | ExcelButton | DMF0043_Contribute_View.cs:293 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-8751dc78 | ExcelButton | DMF0043_Contribute_View.cs:295 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-91535a01 | ExcelButton | DMF0043_Contribute_View.cs:296 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-677967ec | ExcelButton | DMF0043_Contribute_View.cs:298 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-4f25668c | ExcelButton | DMF0043_Contribute_View.cs:307 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-53559f7c | ExcelButton | DMF0043_Contribute_View.cs:312 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f943e73e | ExcelButton | DMF0043_Contribute_View.cs:316 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0043_Contribute_View.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b250a46 | FindButton | DMF0043_Contribute_View.cs:337 | if (txtVersion.Text == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00283") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aab91b5e | FindButton | DMF0043_Contribute_View.cs:338 | if (txtVersion.Text == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2883f983 | FindButton | DMF0043_Contribute_View.cs:341 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3af63f73 | FindButton | DMF0043_Contribute_View.cs:344 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-18dd567c | FindButton | DMF0043_Contribute_View.cs:345 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5e52ba65 | FindButton | DMF0043_Contribute_View.cs:351 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-377c18cd | FindButton | DMF0043_Contribute_View.cs:354 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4fd45704 | FindButton | DMF0043_Contribute_View.cs:358 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0043_GET_CONTRIBUTION_SALES_LIST") ⇒ DM.DMF0043_GET_CONTRIBUTION_SALES_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-6eeb2bf3 | FindButton | DMF0043_Contribute_View.cs:359 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-80aecc7e | FindButton | DMF0043_Contribute_View.cs:360 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | "40" | 행/컬럼 값 대입 |  |  |  |
| AC-abf5a788 | FindButton | DMF0043_Contribute_View.cs:361 | try ▸ lambda | DATA_OP | request.Parameters["p_ver_seq"] | usrYear.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-4d03a2a3 | FindButton | DMF0043_Contribute_View.cs:362 | try ▸ lambda | DATA_OP | request.Parameters["p_version_no"] | txtVersion.Text | 행/컬럼 값 대입 |  |  |  |
| AC-3a61c027 | FindButton | DMF0043_Contribute_View.cs:363 | try ▸ lambda | DATA_OP | request.Parameters["p_end_cust_report"] | usrCust.Text | 행/컬럼 값 대입 |  |  |  |
| AC-521e31fe | FindButton | DMF0043_Contribute_View.cs:364 | try ▸ lambda | DATA_OP | request.Parameters["p_product_group"] | usrType.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-3eda99eb | FindButton | DMF0043_Contribute_View.cs:365 | try ▸ lambda | DATA_OP | request.Parameters["p_biz_type"] | usrBiz.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-cc238f2a | FindButton | DMF0043_Contribute_View.cs:366 | try ▸ lambda | DATA_OP | request.Parameters["p_million_yn"] | (chkM.Checked == true) ? "Y": "N" | 행/컬럼 값 대입 |  |  |  |
| AC-04c6fbfc | FindButton | DMF0043_Contribute_View.cs:367 | try ▸ lambda | DATA_OP | request.Parameters["p_compatibility_yn"] | (usrChk.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-c4e14115 | FindButton | DMF0043_Contribute_View.cs:368 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3f466738 | FindButton | DMF0043_Contribute_View.cs:370 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b24f991c | FindButton | DMF0043_Contribute_View.cs:378 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a4ded619 | FindButton | DMF0043_Contribute_View.cs:385 | try ▸ if (strCnt != "0") | MESSAGE | MessageHelper.GMessageBox | ("MSG00307") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f2e03653 | FindButton | DMF0043_Contribute_View.cs:391 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0320986b | FindButton | DMF0043_Contribute_View.cs:392 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1f7079f5 | FindButton | DMF0043_Contribute_View.cs:394 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b06e334 | FindButton | DMF0043_Contribute_View.cs:403 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c129b52 | FindButton | DMF0043_Contribute_View.cs:407 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-35028be5 | FindButton | DMF0043_Contribute_View.cs:409 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0043_Contribute_View.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b98d09ef | this.Load | DMF0043_Contribute_View.cs:93 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad99696a | this.Load | DMF0043_Contribute_View.cs:95 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0043_Contribute_View.GetCellIndexBySpanRowCells

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a57df943 | (진입점 미연결) | DMF0043_Contribute_View.cs:490 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0eb0001 | (진입점 미연결) | DMF0043_Contribute_View.cs:491 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0043_Contribute_View.GetLookupData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cffcd9fe | (진입점 미연결) | DMF0043_Contribute_View.cs:479 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-9fafa2f5 | (진입점 미연결) | DMF0043_Contribute_View.cs:480 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-aaa5da2d | (진입점 미연결) | DMF0043_Contribute_View.cs:481 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-14074192 | (진입점 미연결) | DMF0043_Contribute_View.cs:483 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0043_Contribute_View.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9219b72 | this.Load | DMF0043_Contribute_View.cs:109 |  | CALL_EXT | main.GetVersionData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2c32bde | this.Load | DMF0043_Contribute_View.cs:110 |  | LIST_REBIND | clsCtrl.setListBox | (dt, usrYear, false, "CODE", "NAME2") | 목록 컨트롤 재구성 |  |  |  |
| AC-0ecba200 | this.Load | DMF0043_Contribute_View.cs:114 |  | COMBO_DATA | Data.Common | (Data.Type.DMF0005_REPORT_GROUP3, false, "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0005_REPORT_GROUP3] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-683fdce8 | this.Load | DMF0043_Contribute_View.cs:115 |  | LIST_REBIND | clsCtrl.setListBox | (dtType, usrType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-042755ee | this.Load | DMF0043_Contribute_View.cs:117 |  | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d632ce49 | this.Load | DMF0043_Contribute_View.cs:118 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, usrBiz, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## DMF0043_Contribute_View.InitSpread

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af714f14 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:146 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0043_GET_SALES_LIST_SPREAD_TITLE") ⇒ DM.DMF0043_GET_SALES_LIST_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-ba3480ae | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:148 |  | DATA_OP | request.Parameters["p_division_id"] | "40" | 행/컬럼 값 대입 |  |  |  |
| AC-c2937be1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:149 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7bf4bb00 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:151 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c69e74d8 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:154 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dt) | 그리드 재구성/초기화 |  |  |  |

## DMF0043_Contribute_View.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-981021fa | SaveButton | DMF0043_Contribute_View.cs:419 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-80791f7f | SaveButton | DMF0043_Contribute_View.cs:420 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8d603833 | SaveButton | DMF0043_Contribute_View.cs:424 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0043_Contribute_View.SetSpreadHeaderSpan

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78ac7641 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:185 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 2, 1, 30, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e1ce5b44 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:193 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a3384648 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:205 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66dd2711 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:206 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dea00a4e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:211 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-174e52d7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:219 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37b773a8 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:231 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b0d2d79 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:233 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b999104 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:234 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f7df08c8 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:236 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ff02d831 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | DMF0043_Contribute_View.cs:238 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0043_ContributeRatePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e99e5893 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0043_ContributeRatePopup.cs:351 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-a0f942ab | this.btnButtonList.UsrButtonList_Click_Detected | DMF0043_ContributeRatePopup.cs:354 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0043_ContributeRatePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36e69539 | this.Load | DMF0043_ContributeRatePopup.cs:128 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-71e4e17c | this.Load | DMF0043_ContributeRatePopup.cs:129 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3e5f04c7 | this.Load | DMF0043_ContributeRatePopup.cs:130 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0043_ContributeRatePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ccaabb6 | this.Load | DMF0043_ContributeRatePopup.cs:106 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-20b07657 | this.Load | DMF0043_ContributeRatePopup.cs:117 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Edit) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4375576 | this.Load | DMF0043_ContributeRatePopup.cs:118 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Insert) | 데이터 객체 조작/조회 |  |  |  |
| AC-88e66396 | this.Load | DMF0043_ContributeRatePopup.cs:119 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Save) | 데이터 객체 조작/조회 |  |  |  |
| AC-8be0e272 | this.Load | DMF0043_ContributeRatePopup.cs:120 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Delete) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a88aab3 | this.Load | DMF0043_ContributeRatePopup.cs:123 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0043_ContributeRatePopup.DeleteButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Delete:] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4d837be | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:171 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0043_ContributeRatePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-629a73d2 | Dispose | DMF0043_ContributeRatePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0043_ContributeRatePopup.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-636978cf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:178 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-99eedcdd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:179 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-59ccdf8c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:181 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.VER_SEQ), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0043_ContributeRatePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b0a00d8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:200 | if (clbYear.ControlValues == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00019") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d1dafe6f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:201 | if (clbYear.ControlValues == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31a169df | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:209 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0043_GET_CONTRIBUTE_RATE_POPUP") ⇒ DM.DMF0043_GET_CONTRIBUTE_RATE_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-319623a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:211 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8f83615a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:213 | try | DATA_OP | request.Parameters["p_yyyy"] | clbYear.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-678c16f9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:215 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ec29c767 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:220 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fde3b5ed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:221 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f19e58b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:223 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a07b78f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:228 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bd2a6dd6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:232 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-07ee52f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:236 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0043_ContributeRatePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33b7cc02 | this.Load | DMF0043_ContributeRatePopup.cs:78 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7dc522bf | this.Load | DMF0043_ContributeRatePopup.cs:80 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0043_ContributeRatePopup.GetYearData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / this.Load / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acb294f5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0043_ContributeRatePopup.cs:379 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0043_GET_CONTRIBUTE_YEAR_POPUP") ⇒ DM.DMF0043_GET_CONTRIBUTE_YEAR_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-66b4ac37 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0043_ContributeRatePopup.cs:380 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8ed2091c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0043_ContributeRatePopup.cs:386 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c72bc09 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0043_ContributeRatePopup.cs:392 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0043_ContributeRatePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4d18f29 | this.Load | DMF0043_ContributeRatePopup.cs:100 |  | LIST_REBIND | clsCtrl.setListBox | (dtYear, clbYear, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## DMF0043_ContributeRatePopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d13d9d9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:141 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-46841260 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:142 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-36161179 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:143 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9418419c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:144 |  | DATA_OP | request.Parameters["p_created_by"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3d5c165c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:145 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0043" | 행/컬럼 값 대입 |  |  |  |
| AC-f9a1c2fb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:146 |  | DATA_OP | request.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-02322f6d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:147 |  | DATA_OP | request.Parameters["p_division_id"] | "40" | 행/컬럼 값 대입 |  |  |  |
| AC-9c1bcfc3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:149 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bd4bef39 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0043_ContributeRatePopup.cs:152 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dt) | 그리드 재구성/초기화 |  |  |  |

## DMF0043_ContributeRatePopup.InsertRow

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Insert:] / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-756a7a61 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:314 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1d797d32 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:315 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2853fea1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:318 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VER_SEQ), siMain.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-be2ed6c4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:320 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0043_ContributeRatePopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-977b4bea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:279 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new FoxDataRequest | ("DM.DMF0043_SAVE_DM_MST_CONTRIBUTE_VER") ⇒ DM.DMF0043_SAVE_DM_MST_CONTRIBUTE_VER | 엔드포인트 요청 생성 |  |  |  |
| AC-8656cc1b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:280 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_active_flag"] | sAction.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-2ce24f8b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:280 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | sAction.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8710f17 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:281 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_ver_seq"] | s_ver_seq.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-8f325a6c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:281 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | s_ver_seq.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-75be5738 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:282 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_yyyy"] | s_yyyy.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-71dcd40e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:282 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | s_yyyy.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-84c1f5ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:283 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_version_nm"] | s_version_nm.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-03468f51 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:283 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | s_version_nm.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-4dbccdca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:284 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_description"] | s_description.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-25f0a234 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:284 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | s_description.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-39ac1a50 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:285 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_valid_yn"] | s_valid_yn.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-52cab9ca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:285 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | s_valid_yn.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc13595d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:286 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_created_by"] | s_created_by.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4a50afec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:286 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | s_created_by.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7839686 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:288 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-831cb68e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:293 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | MESSAGE | MessageBox.Show | (sRet, "Error!") | 메시지 표시 |  |  |  |
| AC-ce0e05d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:294 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e70c7ed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:298 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sRet != "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-64439ee1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_ContributeRatePopup.cs:301 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | LIST_REBIND | clsCtrl.setListBox | (dtYear, clbYear, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## DMF0043_ContributeRatePopup.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fca64d9c | this.spdMain.TopChange | DMF0043_ContributeRatePopup.cs:367 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0043_VersionPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff35cfe9 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0043_VersionPopup.cs:292 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f7ea5e6b | this.btnButtonList.UsrButtonList_Click_Detected | DMF0043_VersionPopup.cs:295 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0043_VersionPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5591a6fa | this.Load | DMF0043_VersionPopup.cs:140 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-510ee50f | this.Load | DMF0043_VersionPopup.cs:141 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9c83c3d1 | this.Load | DMF0043_VersionPopup.cs:142 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0043_VersionPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e07358ca | this.Load | DMF0043_VersionPopup.cs:132 |  | UI_PROP | usrConditionPanel1.Height | 70 | 속성 Height 설정 |  |  |  |
| AC-ac2a5abd | this.Load | DMF0043_VersionPopup.cs:135 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0043_VersionPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20e50740 | Dispose | DMF0043_VersionPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0043_VersionPopup.FindData

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe39c09f | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:230 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ae388ae | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:234 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0043_GET_CONT_VIEW_VERSIONPOPUP") ⇒ DM.DMF0043_GET_CONT_VIEW_VERSIONPOPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-b968d10f | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:235 | lambda | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-75e988fb | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:236 | lambda | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-6a149cf5 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:238 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5987a716 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:239 | lambda | DATA_OP | request.Parameters["p_version_type"] | clbType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d9245feb | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:240 | lambda | DATA_OP | request.Parameters["p_description"] | txtDes.Text | 행/컬럼 값 대입 |  |  |  |
| AC-ef63df04 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:243 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a770c58 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:245 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-15d8b00f | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:249 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-dcdd81cc | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:250 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a33c45c8 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:257 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## DMF0043_VersionPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc71b701 | this.Load | DMF0043_VersionPopup.cs:96 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d4a5bb6b | this.Load | DMF0043_VersionPopup.cs:97 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-40e4aeec | this.Load | DMF0043_VersionPopup.cs:106 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-d765efe3 | this.Load | DMF0043_VersionPopup.cs:107 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-e362d473 | this.Load | DMF0043_VersionPopup.cs:108 |  | VALUE_SET | drpPeriod.InitValue | sStartDate + ":" + sEndDate | 컨트롤 값 설정 |  |  |  |

## DMF0043_VersionPopup.GetLookupData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-391644aa | this.Load | DMF0043_VersionPopup.cs:376 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-c73650c0 | this.Load | DMF0043_VersionPopup.cs:377 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-2f667742 | this.Load | DMF0043_VersionPopup.cs:378 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7d398dcb | this.Load | DMF0043_VersionPopup.cs:380 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0043_VersionPopup.GetSpdTitle

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13c131ff | (진입점 미연결) | DMF0043_VersionPopup.cs:318 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DM0000_GET_COMMON_SPREAD_TITLE") ⇒ DM_H.DM0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-d8238405 | (진입점 미연결) | DMF0043_VersionPopup.cs:319 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-39559f40 | (진입점 미연결) | DMF0043_VersionPopup.cs:320 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-40ee6d9f | (진입점 미연결) | DMF0043_VersionPopup.cs:321 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9c79627a | (진입점 미연결) | DMF0043_VersionPopup.cs:322 |  | DATA_OP | request.Parameters["p_program_id"] | "SCM0002" | 행/컬럼 값 대입 |  |  |  |
| AC-cfb1d734 | (진입점 미연결) | DMF0043_VersionPopup.cs:323 |  | DATA_OP | request.Parameters["p_sheet_name"] | "VersionPopup" | 행/컬럼 값 대입 |  |  |  |
| AC-856ba846 | (진입점 미연결) | DMF0043_VersionPopup.cs:325 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b9905953 | (진입점 미연결) | DMF0043_VersionPopup.cs:325 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bfc9cad6 | (진입점 미연결) | DMF0043_VersionPopup.cs:328 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0043_VersionPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bca18156 | this.Load | DMF0043_VersionPopup.cs:116 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-15c874a9 | this.Load | DMF0043_VersionPopup.cs:116 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d27606bc | this.Load | DMF0043_VersionPopup.cs:117 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-98f075d6 | this.Load | DMF0043_VersionPopup.cs:119 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-4d23a9c4 | this.Load | DMF0043_VersionPopup.cs:128 |  | LIST_REBIND | clsCtrl.setListBox | (dtLook, clbType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## DMF0043_VersionPopup.InitSpread_X

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c35af48f | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:158 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-80ba5326 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:160 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2709eb8f | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:161 |  | GRID_INIT | siMain.AddTextColumn | ("Divison", DefColumns.DIVISION_ID, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cfe12a3e | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:162 |  | GRID_INIT | siMain.AddTextColumn | ("Version", DefColumns.VERSION_NO, FPMerge.None, 220, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e5403dbd | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:163 |  | GRID_INIT | siMain.AddTextColumn | ("Description", DefColumns.VERSION_DESCRIPTION, FPMerge.None, 300, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9dcf597 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:164 |  | GRID_INIT | siMain.AddTextColumn | ("Type", DefColumns.VERSION_TYPE, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7bfc453f | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:165 |  | GRID_INIT | siMain.AddTextColumn | ("Seq", DefColumns.VER_CRE_SEQ, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6e59260 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:166 |  | GRID_INIT | siMain.AddTextColumn | ("Date", DefColumns.YYYYMMDD, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ce5fec3 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:167 |  | GRID_INIT | siMain.AddTextColumn | ("Create By", DefColumns.CREATED_BY, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29e772ac | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:168 |  | GRID_INIT | siMain.AddTextColumn | ("Create Date", DefColumns.CREATION_DATE, FPMerge.None, 150, true, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d0756a4 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:170 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3b47d623 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:172 |  | STATE | txtDes.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e5c40193 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0043_VersionPopup.cs:173 |  | VALUE_CLEAR | txtDes.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0043_VersionPopup.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c61afa07 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_VersionPopup.cs:340 | if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ if (cr.RowCount > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00279") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a60275c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_VersionPopup.cs:341 | if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ if (cr.RowCount > 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27810dfe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_VersionPopup.cs:347 | if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr.RowCount) ▸ if (sVer… | FLAG | sVersions | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-748f39e9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_VersionPopup.cs:353 | if (cellRange.LongLength > 0) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-1a2f8f21 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_VersionPopup.cs:357 | else of (cellRange.LongLength > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00279") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-99aae35c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0043_VersionPopup.cs:358 | else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0043_VersionPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-762d1ff8 | this.spdMain.CellDoubleClick | DMF0043_VersionPopup.cs:309 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |


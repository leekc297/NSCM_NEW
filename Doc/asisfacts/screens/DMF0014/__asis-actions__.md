# AS-IS 액션 대조표 — DMF0014

> 원천: `Doc/asisfacts/screens/DMF0014/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 296행 · 메서드 28 · 종류 DATA_OP 81 · GRID_INIT 39 · FLAG 24 · MESSAGE 21 · RETURN 19 · UI_PROP 18 · LIST_REBIND 16 · COMBO_DATA 14 · GRID_STYLE 11 · POPUP 10 · ENDPOINT 10 · STATE 6 · UI_MISC 6 · GRID_LOCK 6 · VALUE_SET 4 · GRID_COMBO 4 · CALL_EXT 2 · GRID_SET 2 · THROW 1 · GRID_BIND 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 2


## DMF0014_CustFcstUpload.btmItem_Click

진입점: this.btmItem.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-743fe960 | this.btmItem.Click | DMF0014_CustFcstUpload.cs:957 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-09e5e777 | this.btmItem.Click | DMF0014_CustFcstUpload.cs:959 |  | POPUP | popItem.Form_Load | (true, sdivision, "", sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-32dd243a | this.btmItem.Click | DMF0014_CustFcstUpload.cs:960 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f5bdb234 | this.btmItem.Click | DMF0014_CustFcstUpload.cs:961 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-734ef232 | this.btmItem.Click | DMF0014_CustFcstUpload.cs:967 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0014_CustFcstUpload.btnExcelUpload_Click

진입점: this.btnExcelUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a89c90c8 | this.btnExcelUpload.Click | DMF0014_CustFcstUpload.cs:1163 |  | POPUP | new ExcelUploadForm | ("DMF0014", this.spdMain.ActiveSheet.SheetName) | 팝업/폼 생성 |  |  |  |
| AC-47142d5e | this.btnExcelUpload.Click | DMF0014_CustFcstUpload.cs:1164 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-1f4b3244 | this.btnExcelUpload.Click | DMF0014_CustFcstUpload.cs:1165 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5e2b7904 | this.btnExcelUpload.Click | DMF0014_CustFcstUpload.cs:1166 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0014_CustFcstUpload.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-606b3b96 | this.btnProject.Click | DMF0014_CustFcstUpload.cs:931 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-a1027c9f | this.btnProject.Click | DMF0014_CustFcstUpload.cs:932 |  | POPUP | popProject.Form_Load | (true, sDivision, "", sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-89130e8e | this.btnProject.Click | DMF0014_CustFcstUpload.cs:933 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b7d4b159 | this.btnProject.Click | DMF0014_CustFcstUpload.cs:934 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cd835d2f | this.btnProject.Click | DMF0014_CustFcstUpload.cs:940 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0014_CustFcstUpload.cboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f782fae4 | cboDivision.SelectedIndexChanged | DMF0014_CustFcstUpload.cs:836 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c31e7772 | cboDivision.SelectedIndexChanged | DMF0014_CustFcstUpload.cs:844 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-41db98b7 | cboDivision.SelectedIndexChanged | DMF0014_CustFcstUpload.cs:845 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fba96eb7 | cboDivision.SelectedIndexChanged | DMF0014_CustFcstUpload.cs:851 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c04ad43d | cboDivision.SelectedIndexChanged | DMF0014_CustFcstUpload.cs:859 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a853ff0f | cboDivision.SelectedIndexChanged | DMF0014_CustFcstUpload.cs:863 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a659df45 | cboDivision.SelectedIndexChanged | DMF0014_CustFcstUpload.cs:864 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b706e9ea | cboDivision.SelectedIndexChanged | DMF0014_CustFcstUpload.cs:869 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-08550998 | cboDivision.SelectedIndexChanged | DMF0014_CustFcstUpload.cs:878 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fdbb2871 | cboDivision.SelectedIndexChanged | DMF0014_CustFcstUpload.cs:886 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0014_CustFcstUpload.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-261b586c | this.clbEndCustomer.SelectedIndexChanged | DMF0014_CustFcstUpload.cs:920 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0014_CustFcstUpload.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09080068 | this.clbTeam.SelectedIndexChanged | DMF0014_CustFcstUpload.cs:900 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-598c83b0 | this.clbTeam.SelectedIndexChanged | DMF0014_CustFcstUpload.cs:908 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0014_CustFcstUpload.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa199d2b | this.Load | DMF0014_CustFcstUpload.cs:319 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-50cf82a4 | this.Load | DMF0014_CustFcstUpload.cs:320 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-df1efccf | this.Load | DMF0014_CustFcstUpload.cs:321 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2bbbf22d | this.Load | DMF0014_CustFcstUpload.cs:323 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-1a59ac71 | this.Load | DMF0014_CustFcstUpload.cs:324 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-c0cd4b2e | this.Load | DMF0014_CustFcstUpload.cs:325 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-4c883fb1 | this.Load | DMF0014_CustFcstUpload.cs:326 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-99fce067 | this.Load | DMF0014_CustFcstUpload.cs:327 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-774c0a03 | this.Load | DMF0014_CustFcstUpload.cs:331 |  | GRID_INIT | siMain.ColumnHeaderHeight | (0, 30) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b6b61959 | this.Load | DMF0014_CustFcstUpload.cs:332 |  | GRID_INIT | siMain.ColumnHeaderHeight | (1, 35) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0014_CustFcstUpload.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40388d02 | this.Load | DMF0014_CustFcstUpload.cs:308 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-5e947080 | this.Load | DMF0014_CustFcstUpload.cs:312 | if (UserInfoContext.Current["NowGroupID"].IndexOf("Viewer") >= 0) | STATE | btnExcelUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1d57c5fc | this.Load | DMF0014_CustFcstUpload.cs:313 | if (UserInfoContext.Current["NowGroupID"].IndexOf("Viewer") >= 0) | STATE | btnExcelUpload.Visible | false | 컨트롤 상태 Visible |  |  |  |

## DMF0014_CustFcstUpload.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9189d2dc | DeleteButton | DMF0014_CustFcstUpload.cs:455 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0014_CustFcstUpload.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae7ee758 | Dispose | DMF0014_CustFcstUpload.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0014_CustFcstUpload.drpPeriod_ValueChanged

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81c001b7 | drpPeriod.ValueChanged | DMF0014_CustFcstUpload.cs:980 | if (dtFrom > dtTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b05f2f29 | drpPeriod.ValueChanged | DMF0014_CustFcstUpload.cs:982 | if (dtFrom > dtTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0014_CustFcstUpload.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0317a49 | EditButton | DMF0014_CustFcstUpload.cs:463 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-48fdb43b | EditButton | DMF0014_CustFcstUpload.cs:464 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-94b10f0a | EditButton | DMF0014_CustFcstUpload.cs:471 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DivisionId), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab9f6623 | EditButton | DMF0014_CustFcstUpload.cs:475 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).T… | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0014_CustFcstUpload.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c05295d | ExcelButton | DMF0014_CustFcstUpload.cs:502 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-81eef80a | ExcelButton | DMF0014_CustFcstUpload.cs:503 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-df08f0b4 | ExcelButton | DMF0014_CustFcstUpload.cs:504 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-4beddc1b | ExcelButton | DMF0014_CustFcstUpload.cs:505 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-68ed98cc | ExcelButton | DMF0014_CustFcstUpload.cs:506 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-b32d0ea4 | ExcelButton | DMF0014_CustFcstUpload.cs:507 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-dad44176 | ExcelButton | DMF0014_CustFcstUpload.cs:509 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-8dba1b95 | ExcelButton | DMF0014_CustFcstUpload.cs:510 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-cf1ac76a | ExcelButton | DMF0014_CustFcstUpload.cs:512 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.##0;[Red]-#,##0.##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-89920fd9 | ExcelButton | DMF0014_CustFcstUpload.cs:521 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-80eb986a | ExcelButton | DMF0014_CustFcstUpload.cs:526 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-252dac2a | ExcelButton | DMF0014_CustFcstUpload.cs:530 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0014_CustFcstUpload.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1402d8bc | FindButton 외 1 | DMF0014_CustFcstUpload.cs:559 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8234f1d2 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:568 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3eda7f5 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:570 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95f8464e | FindButton 외 1 | DMF0014_CustFcstUpload.cs:573 | try | FLAG | dtMeasure | Data.Common(Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, clb… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-3e3ecb63 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:573 | try | COMBO_DATA | Data.Common | (Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, clbScmSite.Con… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-99abdece | FindButton 외 1 | DMF0014_CustFcstUpload.cs:579 | try ▸ if (int.Parse(sDate[0]) > int.Parse(sDate[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1339a872 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:580 | try ▸ if (int.Parse(sDate[0]) > int.Parse(sDate[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53e3d65b | FindButton 외 1 | DMF0014_CustFcstUpload.cs:585 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-23347858 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:587 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-61ac6e1f | FindButton 외 1 | DMF0014_CustFcstUpload.cs:589 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-515a55d1 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:592 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7eb4e534 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:603 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0014_GET_CUST_FCST_UPLOAD_DATA") ⇒ DM.DMF0014_GET_CUST_FCST_UPLOAD_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-d7eccc52 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:605 | try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7a56e381 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:606 | try | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-76535a12 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:607 | try | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-28fb4551 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:608 | try | DATA_OP | request.Parameters["p_scm_site_id"] | clbScmSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-dec92128 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:609 | try | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-875f0d79 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:610 | try | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-10fc06ec | FindButton 외 1 | DMF0014_CustFcstUpload.cs:611 | try | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-30794d50 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:612 | try | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sDate[0].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1cec56ef | FindButton 외 1 | DMF0014_CustFcstUpload.cs:613 | try | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sDate[1].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7e0c26a3 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:614 | try | DATA_OP | request.Parameters["p_bucket_type"] | cboBucketType.SelectedValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c8ec1b4 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:615 | try | DATA_OP | request.Parameters["p_dom_exp"] | clbDomExp.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-4c84a177 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:616 | try | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-090059b7 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:618 | try | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-246a8131 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:619 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8821937f | FindButton 외 1 | DMF0014_CustFcstUpload.cs:621 | try | FLAG | dsMain | response.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-667131ea | FindButton 외 1 | DMF0014_CustFcstUpload.cs:627 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9879304c | FindButton 외 1 | DMF0014_CustFcstUpload.cs:629 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-dd1bc6ce | FindButton 외 1 | DMF0014_CustFcstUpload.cs:630 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-21b646eb | FindButton 외 1 | DMF0014_CustFcstUpload.cs:632 | try | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-afcbbd1f | FindButton 외 1 | DMF0014_CustFcstUpload.cs:642 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f518ffda | FindButton 외 1 | DMF0014_CustFcstUpload.cs:646 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-60fcf408 | FindButton 외 1 | DMF0014_CustFcstUpload.cs:648 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0014_CustFcstUpload.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cea3a86 | this.Load | DMF0014_CustFcstUpload.cs:143 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-98cd84b6 | this.Load | DMF0014_CustFcstUpload.cs:144 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0014_CustFcstUpload.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7d2caf6 | this.Load | DMF0014_CustFcstUpload.cs:1235 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-92c94653 | this.Load | DMF0014_CustFcstUpload.cs:1236 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b6593ad3 | this.Load | DMF0014_CustFcstUpload.cs:1237 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-5a644a54 | this.Load | DMF0014_CustFcstUpload.cs:1239 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cf110c1b | this.Load | DMF0014_CustFcstUpload.cs:1242 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0014_CustFcstUpload.GetLookupValues

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77b7b587 | this.Load | DMF0014_CustFcstUpload.cs:1266 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-d8b8fc23 | this.Load | DMF0014_CustFcstUpload.cs:1267 |  | DATA_OP | request.Parameters["p_lookup_type"] | sLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-888597ff | this.Load | DMF0014_CustFcstUpload.cs:1268 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-39cd36d8 | this.Load | DMF0014_CustFcstUpload.cs:1271 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0014_CustFcstUpload.GetSpdTitle

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load / cboDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cd94d63 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:1251 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0014_GET_SPREAD_TITLE") ⇒ DM.DMF0014_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-3c470488 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:1252 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sDate[0] | 행/컬럼 값 대입 |  |  |  |
| AC-df073747 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:1253 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sDate[1] | 행/컬럼 값 대입 |  |  |  |
| AC-d00790d7 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:1254 |  | DATA_OP | request.Parameters["p_bucket_type"] | cboBucketType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-97109ad1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:1256 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-d94e7dde | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:1256 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0014_CustFcstUpload.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4ee26d9 | this.Load | DMF0014_CustFcstUpload.cs:238 |  | FLAG | dtSprDivision | Data.Common(Data.Type.Division, false) ⇒ biz:CommonData.CommonDataList [code=Division] | 화면 필드/플래그 변경 |  |  |  |
| AC-d129f7c4 | this.Load | DMF0014_CustFcstUpload.cs:238 |  | COMBO_DATA | Data.Common | (Data.Type.Division, false) ⇒ biz:CommonData.CommonDataList [code=Division] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5cffccfa | this.Load | DMF0014_CustFcstUpload.cs:244 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b8ba5c20 | this.Load | DMF0014_CustFcstUpload.cs:252 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1eb5ce0d | this.Load | DMF0014_CustFcstUpload.cs:271 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e5de2ae4 | this.Load | DMF0014_CustFcstUpload.cs:279 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ddded03e | this.Load | DMF0014_CustFcstUpload.cs:285 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8dca621b | this.Load | DMF0014_CustFcstUpload.cs:287 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-791687d7 | this.Load | DMF0014_CustFcstUpload.cs:289 |  | FLAG | dtBucketType | GetLookupValues("BUCKET_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-9e2ee6ad | this.Load | DMF0014_CustFcstUpload.cs:290 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-218337c5 | this.Load | DMF0014_CustFcstUpload.cs:292 |  | FLAG | dtDomExp | Data.Common(Data.Type.DOM_EXP) ⇒ biz:CommonData.CommonDataList [code=DOM_EXP] | 화면 필드/플래그 변경 |  |  |  |
| AC-b1cf506f | this.Load | DMF0014_CustFcstUpload.cs:292 |  | COMBO_DATA | Data.Common | (Data.Type.DOM_EXP) ⇒ biz:CommonData.CommonDataList [code=DOM_EXP] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dd08df34 | this.Load | DMF0014_CustFcstUpload.cs:293 |  | LIST_REBIND | clsCtrl.setListBox | (dtDomExp, clbDomExp, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-329d28fb | this.Load | DMF0014_CustFcstUpload.cs:295 |  | FLAG | dtIncoterms | GetLookupValues("INCOTERMS") | 화면 필드/플래그 변경 |  |  |  |
| AC-208491d1 | this.Load | DMF0014_CustFcstUpload.cs:296 |  | FLAG | dtSalesType | GetLookupValues("SALES_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-dacc8e4a | this.Load | DMF0014_CustFcstUpload.cs:297 |  | FLAG | dtUploadUOM | GetLookupValues("UPLOAD_UOM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-7fe5858e | this.Load | DMF0014_CustFcstUpload.cs:300 |  | FLAG | dtMeasure | Data.Common(Data.Type.CustomerMeasure, false, cboDivision.ControlValues, clbEndCustomer.Co… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-75295232 | this.Load | DMF0014_CustFcstUpload.cs:300 |  | COMBO_DATA | Data.Common | (Data.Type.CustomerMeasure, false, cboDivision.ControlValues, clbEndCustomer.ControlValues… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DMF0014_CustFcstUpload.InitSaveDataTable

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8827f31 | this.Load 외 1 | DMF0014_CustFcstUpload.cs:420 |  | FLAG | dtSave | new DataTable("CustFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-a51d994d | this.Load 외 1 | DMF0014_CustFcstUpload.cs:421 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DivisionId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e83d795 | this.Load 외 1 | DMF0014_CustFcstUpload.cs:422 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ScmSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-87d05e80 | this.Load 외 1 | DMF0014_CustFcstUpload.cs:423 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.CustomerProject, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aba8d09e | this.Load 외 1 | DMF0014_CustFcstUpload.cs:424 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.CustomerModel, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-276635f9 | this.Load 외 1 | DMF0014_CustFcstUpload.cs:425 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4226437 | this.Load 외 1 | DMF0014_CustFcstUpload.cs:426 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f3c3840 | this.Load 외 1 | DMF0014_CustFcstUpload.cs:427 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DomExp, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0801c46b | this.Load 외 1 | DMF0014_CustFcstUpload.cs:428 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.MeasureGroup, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6993c0ff | this.Load 외 1 | DMF0014_CustFcstUpload.cs:429 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Measure, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-917deaf7 | this.Load 외 1 | DMF0014_CustFcstUpload.cs:430 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PlantSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1989ae5b | this.Load 외 1 | DMF0014_CustFcstUpload.cs:431 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.UploadUOM, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d4575dd | this.Load 외 1 | DMF0014_CustFcstUpload.cs:432 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ProjectCode, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9bb03cb | this.Load 외 1 | DMF0014_CustFcstUpload.cs:433 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ItemId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d042e26 | this.Load 외 1 | DMF0014_CustFcstUpload.cs:434 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4a3b7ae | this.Load 외 1 | DMF0014_CustFcstUpload.cs:435 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Qty, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0014_CustFcstUpload.InitSpread

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load / cboDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bc64da2 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:337 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-aabbaea1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:339 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a47f825e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:340 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.DivisionId, DefColumns.DivisionId, FPMerge.Restricted, 60, true, dtSprDiv… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-00a5abe1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:341 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.ScmSite, DefColumns.ScmSite, FPMerge.Restricted, 60, true, dtScmSite, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb4653a8 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:342 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.PlantSite, DefColumns.PlantSite, FPMerge.Restricted, 60, true, dtPlantSit… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc3ae055 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:343 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.CustomerProject, DefColumns.CustomerProject, FPMerge.Restricted, 60, true… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-327a792f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:344 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.CustomerModel, DefColumns.CustomerModel, FPMerge.Restricted, 60, true, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3500731b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:345 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.Incoterms, DefColumns.Incoterms, FPMerge.Restricted, 40, true, dtIncoterm… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6e4d106 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:346 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.FcstType, DefColumns.FcstType, FPMerge.Restricted, 40, true, dtSalesType,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b6e6c53 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:347 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.DomExp, DefColumns.DomExp, FPMerge.Restricted, 60, true, dtDomExp, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c6d8d015 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:348 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.MeasureGroup, DefColumns.MeasureGroup, FPMerge.Restricted, 60, true, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ac547f33 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:349 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.Measure, DefColumns.Measure, FPMerge.Restricted, 40, true, dtMeasure, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da608fe9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:350 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.UploadUOM, DefColumns.UploadUOM, FPMerge.Restricted, 40, true, dtUploadUO… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a0895222 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:351 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ProjectCode, DefColumns.ProjectCode, FPMerge.Restricted, 80, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e193e33 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:352 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ItemId, DefColumns.ItemId, FPMerge.Restricted, 100, true, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e4618ef5 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:353 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.EditFlag, DefColumns.EditFlag, FPMerge.Restricted, 0, true, FPHAlign.Left… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a7642de8 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:355 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(CAppSetting.StringAction), 2, 1, 30, "A", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-42bb6102 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:356 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.DivisionId), 2, 1, 30, DefColumnsLabel.DivisionId, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-484ab8c9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:357 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ScmSite), 2, 1, 30, DefColumnsLabel.ScmSite, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4c968ee1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:358 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.PlantSite), 2, 1, 30, DefColumnsLabel.PlantSite, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f7fc1cab | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:359 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.CustomerProject), 2, 1, 30, DefColumnsLabel.CustomerP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53af4c97 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:360 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.CustomerModel), 2, 1, 30, DefColumnsLabel.CustomerMod… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f33fa68 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:361 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.Incoterms), 2, 1, 30, DefColumnsLabel.Incoterms, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13163487 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:362 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FcstType), 2, 1, 30, DefColumnsLabel.FcstType, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8bccc6c4 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:363 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.DomExp), 2, 1, 30, DefColumnsLabel.DomExp, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1958cd51 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:364 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.MeasureGroup), 2, 1, 30, DefColumnsLabel.MeasureGroup… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-85f7b478 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:365 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.Measure), 2, 1, 30, DefColumnsLabel.Measure, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fbc09cdc | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:366 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.UploadUOM), 2, 1, 30, DefColumnsLabel.UploadUOM, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f14891fa | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:367 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ProjectCode), 2, 1, 30, DefColumnsLabel.ProjectCode, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fed99e15 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:368 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ItemId), 2, 1, 30, DefColumnsLabel.ItemId, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf391eee | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:369 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.EditFlag), 2, 1, 30, DefColumnsLabel.EditFlag, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ada62f50 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:371 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.EditFlag)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c23472f5 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:388 | foreach (DataRow dr in dtTitle.Rows) | GRID_INIT | siMain.AddNumTextColumn | (sColumnLabel, sColumnName, FPMerge.Restricted, 50, true, FPHAlign.Right, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9155b1a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:392 | foreach (DataRow dr in dtTitle.Rows) ▸ if (sSpanLabelName != sSmallLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-196279c5 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:401 | foreach (DataRow dr in dtTitle.Rows) ▸ if (sSmallLabelName == DefColumnsLabel.Saturday \|\| sSmallLabelName == DefColumnsLabel.Sunday) | GRID_SET | siMain.Sheet().ColumnHeader.Cells[0, siMain.GetMaxColumnIndex()].ForeColor | sSmallLabelName == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-7d9cd1a4 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0014_CustFcstUpload.cs:405 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0014_CustFcstUpload.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-703bdd96 | InsertButton | DMF0014_CustFcstUpload.cs:790 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00380", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-99b331b8 | InsertButton | DMF0014_CustFcstUpload.cs:791 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0014_CustFcstUpload.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbe48adf | SaveButton | DMF0014_CustFcstUpload.cs:734 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0014_SAVE_CUST_FCST_UPLOAD_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-85405660 | SaveButton | DMF0014_CustFcstUpload.cs:735 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-b4010a58 | SaveButton | DMF0014_CustFcstUpload.cs:736 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b01514e1 | SaveButton | DMF0014_CustFcstUpload.cs:737 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-1adc210c | SaveButton | DMF0014_CustFcstUpload.cs:738 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_customer_project_code"] | sCustomerProject | 행/컬럼 값 대입 |  |  |  |
| AC-da2b1e6a | SaveButton | DMF0014_CustFcstUpload.cs:739 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_customer_model"] | sCustomerModel | 행/컬럼 값 대입 |  |  |  |
| AC-a78aab88 | SaveButton | DMF0014_CustFcstUpload.cs:740 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-7d1dd7dd | SaveButton | DMF0014_CustFcstUpload.cs:741 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fcst_type"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-1a631157 | SaveButton | DMF0014_CustFcstUpload.cs:742 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dom_exp"] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-a751a528 | SaveButton | DMF0014_CustFcstUpload.cs:743 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure_group"] | sMeasureGroup | 행/컬럼 값 대입 |  |  |  |
| AC-ec80a0ef | SaveButton | DMF0014_CustFcstUpload.cs:744 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-4d902bf6 | SaveButton | DMF0014_CustFcstUpload.cs:745 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_site_id"] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-3bb4f237 | SaveButton | DMF0014_CustFcstUpload.cs:746 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_upload_uom"] | sUploadUOM | 행/컬럼 값 대입 |  |  |  |
| AC-2a64e393 | SaveButton | DMF0014_CustFcstUpload.cs:747 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-62990fb1 | SaveButton | DMF0014_CustFcstUpload.cs:748 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-2900ecf2 | SaveButton | DMF0014_CustFcstUpload.cs:749 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-b436d936 | SaveButton | DMF0014_CustFcstUpload.cs:750 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-eaf9e76f | SaveButton | DMF0014_CustFcstUpload.cs:751 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-532bd231 | SaveButton | DMF0014_CustFcstUpload.cs:753 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1da72ffa | SaveButton | DMF0014_CustFcstUpload.cs:757 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f99ed8c2 | SaveButton | DMF0014_CustFcstUpload.cs:762 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2144d34a | SaveButton | DMF0014_CustFcstUpload.cs:771 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a1616f46 | SaveButton | DMF0014_CustFcstUpload.cs:780 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00152") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0014_CustFcstUpload.SetChangeControl

진입점: this.clbEndCustomer.SelectedIndexChanged / this.clbTeam.SelectedIndexChanged / this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd9f4561 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:164 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8a9b19d0 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:165 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8f9d2b29 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:171 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5ad51baa | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:171 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d20f0488 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:176 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3c178588 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:178 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2689ff21 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:178 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4e1edb59 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:183 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d814562d | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:184 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-8e9da40a | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:186 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-cdfa86ce | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:186 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-21db831b | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:198 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-35566954 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:199 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-1327d791 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:200 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-c97e425c | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:202 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtScmSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e403749 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:202 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-21547da3 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:207 | switch (triggerControl) case "UserPlantSiteByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3bfd2cbd | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:209 | switch (triggerControl) case "UserPlantSiteByDivision": | FLAG | dtPlantSite | DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-08744fc2 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0014_CustFcstUpload.cs:209 | switch (triggerControl) case "UserPlantSiteByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0014_CustFcstUpload.SetSaveData

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0828e21c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1129 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8ba787b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1133 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7fa3f3ba | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1134 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DivisionId] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8960cd4d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1135 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ScmSite] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-b7223c7b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1136 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.CustomerProject] | sCustomerProject | 행/컬럼 값 대입 |  |  |  |
| AC-74d7fa93 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1137 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.CustomerModel] | sCustomerModel | 행/컬럼 값 대입 |  |  |  |
| AC-120a932d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1138 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-75778623 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1139 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-76a254c2 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1140 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DomExp] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-d4b7a3ec | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1141 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.MeasureGroup] | sMeasureGroup | 행/컬럼 값 대입 |  |  |  |
| AC-212879b6 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1142 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Measure] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-4c0336a5 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1143 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.PlantSite] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-6b391dcd | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1144 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.UploadUOM] | sUploadUOM | 행/컬럼 값 대입 |  |  |  |
| AC-426b2785 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1145 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ProjectCode] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-73579741 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1146 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ItemId] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-bea4d484 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1147 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-6f50571b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1148 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-75cdb9d0 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1150 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-1894160b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1151 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1ce0c439 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1155 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-7cdee97d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0014_CustFcstUpload.cs:1156 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0014_CustFcstUpload.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81c6fd79 | this.spdMain.CellDoubleClick | DMF0014_CustFcstUpload.cs:1214 | if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0014_CustFcstUpload.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89865a1c | dsdm.Changed | DMF0014_CustFcstUpload.cs:1024 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivision == "… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.DivisionId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-089fe8f5 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1025 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivision == "… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.DivisionId)) | 그리드 표시 설정 |  |  |  |
| AC-07f8de9c | dsdm.Changed | DMF0014_CustFcstUpload.cs:1026 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivision == "… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21627074 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1031 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.ScmSite }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-12573945 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1032 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSite)) | 그리드 표시 설정 |  |  |  |
| AC-67a9b7c9 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1033 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-65097050 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1037 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.CustomerProject }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2cfee901 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1038 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.CustomerProject)) | 그리드 표시 설정 |  |  |  |
| AC-064d414c | dsdm.Changed | DMF0014_CustFcstUpload.cs:1039 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77a48e88 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1043 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.CustomerModel }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c23659a5 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1044 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.CustomerModel)) | 그리드 표시 설정 |  |  |  |
| AC-746a418d | dsdm.Changed | DMF0014_CustFcstUpload.cs:1045 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d9a2e6e | dsdm.Changed | DMF0014_CustFcstUpload.cs:1049 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b0ba1a9b | dsdm.Changed | DMF0014_CustFcstUpload.cs:1050 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.Incoterms)) | 그리드 표시 설정 |  |  |  |
| AC-67f6b696 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1051 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3d77a9f | dsdm.Changed | DMF0014_CustFcstUpload.cs:1055 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.FcstType }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df17f714 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1056 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.FcstType)) | 그리드 표시 설정 |  |  |  |
| AC-eababf89 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1057 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd90e398 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1061 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.DomExp }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3f3096ce | dsdm.Changed | DMF0014_CustFcstUpload.cs:1062 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.DomExp)) | 그리드 표시 설정 |  |  |  |
| AC-f6238023 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1063 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e2cb3cd | dsdm.Changed | DMF0014_CustFcstUpload.cs:1067 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.MeasureGroup }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a13c2ff1 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1068 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.MeasureGroup)) | 그리드 표시 설정 |  |  |  |
| AC-06b0ecd0 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1069 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6d60de2 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1073 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.Measure }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-422398ea | dsdm.Changed | DMF0014_CustFcstUpload.cs:1074 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.Measure)) | 그리드 표시 설정 |  |  |  |
| AC-2b4d9ef6 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1075 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9815a063 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1079 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.PlantSite }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-330b902a | dsdm.Changed | DMF0014_CustFcstUpload.cs:1080 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSite)) | 그리드 표시 설정 |  |  |  |
| AC-e3e8a09f | dsdm.Changed | DMF0014_CustFcstUpload.cs:1081 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-501843eb | dsdm.Changed | DMF0014_CustFcstUpload.cs:1085 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.UploadUOM }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31334999 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1086 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.Incoterms)) | 그리드 표시 설정 |  |  |  |
| AC-091b9ef0 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1087 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-36ba44c2 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1105 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (e.Column … | COMBO_DATA | Data.Common | (Data.Type.CUST_FCST_UPLOAD_UOM, false, sDivisionId, sScmSiteId, sMeasureGroup, sMeasure, … ⇒ biz:CommonData.CommonDataList [code=CUST_FCST_UPLOAD_UOM] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-778b8113 | dsdm.Changed | DMF0014_CustFcstUpload.cs:1106 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (e.Column … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.UploadUOM), sUploadUOM) | 그리드 값 설정 |  |  |  |

## DMF0014_CustFcstUpload.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8812a506 | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1177 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | FLAG | dtScmSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-6fbf378d | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1177 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, CAppSet… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a57b00f | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1178 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSite), dtScmSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b9156879 | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1180 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-0e6a9910 | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1180 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7ef4b9bd | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1181 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSite), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-450b77ea | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1185 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | FLAG | dtMeasure | Data.Common(Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, sSc… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-45cb8437 | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1185 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | COMBO_DATA | Data.Common | (Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, sScmSite, cboB… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6e6d2585 | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1186 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-20192f65 | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1189 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (sDivision != "81") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSite), e.Row, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5cc4b7ab | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1191 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ else of (sDivision != "81") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSite), e.Row, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-acc01425 | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1198 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ScmSite)) | FLAG | dtMeasure | Data.Common(Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, sSc… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-fdeb800c | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1198 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ScmSite)) | COMBO_DATA | Data.Common | (Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, sScmSite, cboB… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9dcfd40b | this.spdMain.ComboSelChange | DMF0014_CustFcstUpload.cs:1199 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ScmSite)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |


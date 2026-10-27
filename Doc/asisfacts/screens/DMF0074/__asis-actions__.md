# AS-IS 액션 대조표 — DMF0074

> 원천: `Doc/asisfacts/screens/DMF0074/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 233행 · 메서드 32 · 종류 DATA_OP 37 · UI_PROP 31 · FLAG 26 · POPUP 17 · LIST_REBIND 15 · RETURN 14 · STATE 13 · UI_MISC 13 · MESSAGE 12 · ENDPOINT 12 · COMBO_DATA 10 · GRID_INIT 9 · VALUE_CLEAR 7 · VALUE_SET 6 · THROW 5 · CALL_EXT 2 · GRID_BIND 2 · GRID_LOCK 2 · ⚠ 의미 확인 필요 2


## DMF0074_MetalLinkPrice.btmItem_Click

진입점: this.btmItem.Click / this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24169e04 | this.btmItem.Click 외 1 | DMF0074_MetalLinkPrice.cs:663 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-2ec692f1 | this.btmItem.Click 외 1 | DMF0074_MetalLinkPrice.cs:666 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e0d45bd1 | this.btmItem.Click 외 1 | DMF0074_MetalLinkPrice.cs:667 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-71a21827 | this.btmItem.Click 외 1 | DMF0074_MetalLinkPrice.cs:668 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1f26215e | this.btmItem.Click 외 1 | DMF0074_MetalLinkPrice.cs:670 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0074_MetalLinkPrice.btnExcelUpload_Click

진입점: this.btnExcelUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6be5b36d | this.btnExcelUpload.Click | DMF0074_MetalLinkPrice.cs:728 |  | POPUP | new ExcelUploadForm | (strForm, this.spdMain.ActiveSheet.SheetName) | 팝업/폼 생성 |  |  |  |
| AC-ace042db | this.btnExcelUpload.Click | DMF0074_MetalLinkPrice.cs:729 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-9e7e8690 | this.btnExcelUpload.Click | DMF0074_MetalLinkPrice.cs:730 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9761d31d | this.btnExcelUpload.Click | DMF0074_MetalLinkPrice.cs:731 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-63273aa8 | this.btnExcelUpload.Click | DMF0074_MetalLinkPrice.cs:733 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0074_MetalLinkPrice.btnProject_Click

진입점: this.btnProject.Click / this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b515c8ab | this.btnProject.Click 외 1 | DMF0074_MetalLinkPrice.cs:639 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-932db28b | this.btnProject.Click 외 1 | DMF0074_MetalLinkPrice.cs:640 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c4b5e937 | this.btnProject.Click 외 1 | DMF0074_MetalLinkPrice.cs:641 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-70e8a0a1 | this.btnProject.Click 외 1 | DMF0074_MetalLinkPrice.cs:642 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fc8cd401 | this.btnProject.Click 외 1 | DMF0074_MetalLinkPrice.cs:649 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProject | 컨트롤 값 설정 |  |  |  |

## DMF0074_MetalLinkPrice.btnSPVer_Click

진입점: this.btnSPVer.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec48dcda | this.btnSPVer.Click | DMF0074_MetalLinkPrice.cs:678 |  | COMBO_DATA | Data.MultiTimeZone | (UserInfoContext.Current["TimeZone"]) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-393d3a11 | this.btnSPVer.Click | DMF0074_MetalLinkPrice.cs:682 |  | POPUP | new GSCM.DM.Master.UIL.DMF0073_VersionBySalesPricePopup | () | 팝업/폼 생성 |  |  |  |
| AC-cec9caaf | this.btnSPVer.Click | DMF0074_MetalLinkPrice.cs:683 |  | POPUP | popVersion.Form_Load | (true, "SP", sDivision, sStartDate, sEndDate) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ccfe32f5 | this.btnSPVer.Click | DMF0074_MetalLinkPrice.cs:684 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f36a222a | this.btnSPVer.Click | DMF0074_MetalLinkPrice.cs:685 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b06a0a9d | this.btnSPVer.Click | DMF0074_MetalLinkPrice.cs:692 | if (popVersion.sVersions != "") ▸ if (sVersion.Length > 2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00255", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f1b4f3bc | this.btnSPVer.Click | DMF0074_MetalLinkPrice.cs:693 | if (popVersion.sVersions != "") ▸ if (sVersion.Length > 2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc171537 | this.btnSPVer.Click | DMF0074_MetalLinkPrice.cs:697 | if (popVersion.sVersions != "") ▸ else of (sVersion.Length > 2) | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |

## DMF0074_MetalLinkPrice.btnTemplate_Click

진입점: this.btnTemplate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd5c30b9 | this.btnTemplate.Click | DMF0074_MetalLinkPrice.cs:710 |  | POPUP | new DMF0074_MetalLinkPricePopup | (CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues)) | 팝업/폼 생성 |  |  |  |
| AC-3b7ad80e | this.btnTemplate.Click | DMF0074_MetalLinkPrice.cs:711 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f7b4adb1 | this.btnTemplate.Click | DMF0074_MetalLinkPrice.cs:712 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0074_MetalLinkPrice.clbDivisions_SelectedIndexChanged

진입점: this.clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f559dd9e | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:509 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16af0653 | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:512 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3ef17b0d | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:518 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7f0224ce | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:526 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a465677c | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:530 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-843d072f | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:531 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblBtnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fd7b790a | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:536 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sDivision.IndexOf("81") != -1) | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByEndCustomer, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-308b0bb3 | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:542 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sDivision == "82") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-102135dd | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:543 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sDivision == "82") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-0e8536b5 | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:547 | try ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ else of (sDivision == "82") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-270465dd | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:553 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2b5dcbb3 | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:558 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3321d51b | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:559 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3b159702 | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:560 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblBtnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3e0d6d82 | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:562 | try ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-5175c5be | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:568 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2c4bee0b | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:572 | try | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9106cf75 | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:573 | try | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f6c6fd68 | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:574 | try | VALUE_CLEAR | this.txtVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-6961e648 | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:597 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-acce9eae | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:598 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-47cdce74 | this.clbDivisions.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:602 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0074_MetalLinkPrice.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aec49b6e | this.clbEndCustomer.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:629 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0074_MetalLinkPrice.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddd2a830 | this.clbTeam.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:619 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3e533041 | this.clbTeam.SelectedIndexChanged | DMF0074_MetalLinkPrice.cs:623 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0074_MetalLinkPrice.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b21ba1b | this.Load | DMF0074_MetalLinkPrice.cs:270 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5c69b365 | this.Load | DMF0074_MetalLinkPrice.cs:271 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-59510ba8 | this.Load | DMF0074_MetalLinkPrice.cs:272 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0074_MetalLinkPrice.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99919bf4 | this.Load | DMF0074_MetalLinkPrice.cs:245 |  | VALUE_SET | clbDivisions.ControlValues | "ALL" | 컨트롤 값 설정 |  |  |  |

## DMF0074_MetalLinkPrice.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a77b6bdb | Dispose | DMF0074_MetalLinkPrice.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0074_MetalLinkPrice.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68ba869f | ExcelButton | DMF0074_MetalLinkPrice.cs:318 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-7a0c85b6 | ExcelButton | DMF0074_MetalLinkPrice.cs:319 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-8a78aa4c | ExcelButton | DMF0074_MetalLinkPrice.cs:320 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-b52bb927 | ExcelButton | DMF0074_MetalLinkPrice.cs:321 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-eb0a9bfa | ExcelButton | DMF0074_MetalLinkPrice.cs:322 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-511a36a5 | ExcelButton | DMF0074_MetalLinkPrice.cs:323 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-480b8110 | ExcelButton | DMF0074_MetalLinkPrice.cs:325 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-59f5fc80 | ExcelButton | DMF0074_MetalLinkPrice.cs:326 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-fb4298f7 | ExcelButton | DMF0074_MetalLinkPrice.cs:328 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-510d26af | ExcelButton | DMF0074_MetalLinkPrice.cs:337 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cfe05411 | ExcelButton | DMF0074_MetalLinkPrice.cs:342 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-7bccb5a4 | ExcelButton | DMF0074_MetalLinkPrice.cs:346 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0074_MetalLinkPrice.FindData

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e54ef646 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:363 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0088394b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:370 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-21bc1f26 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:371 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d39e2133 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:377 | try ▸ if (txtVersion.Text.Trim() == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00283") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-941d225a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:378 | try ▸ if (txtVersion.Text.Trim() == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6bebccb2 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:382 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c599dc69 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:387 | try ▸ if (drpPeriodMonth.MonthText1 == "" \|\| drpPeriodMonth.MonthText2 == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan Date" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db011415 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:388 | try ▸ if (drpPeriodMonth.MonthText1 == "" \|\| drpPeriodMonth.MonthText2 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a082cd21 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:397 | try ▸ catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee4de72b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:398 | try ▸ catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-64bb27c3 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:403 | try ▸ if (Convert.ToDateTime(drpPeriodMonth.MonthText1 + "-01") > Convert.ToDateTime(drpPeriodMonth.MonthText2 + "-01")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1ea86e2c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:404 | try ▸ if (Convert.ToDateTime(drpPeriodMonth.MonthText1 + "-01") > Convert.ToDateTime(drpPeriodMonth.MonthText2 + "-01")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12ae29ca | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:421 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e4aed72 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:422 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f195b048 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:426 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-421e2a2d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:437 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-408aa6b8 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:439 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0e4b8359 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:443 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0074_GET_METAL_LINK_PRICE") ⇒ DM.DMF0074_GET_METAL_LINK_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-8ec88667 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:445 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f4cd3e19 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:447 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9292fbe2 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:448 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-a9342448 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:449 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-354c3f4b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:450 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-3f125888 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:451 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-3ad58e87 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:452 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c0a4f893 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:453 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-04cccd94 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:454 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | drpPeriodMonth.MonthText1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-40bd87dd | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:455 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | drpPeriodMonth.MonthText2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-1abb64fd | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:457 | try ▸ lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-c93bae1c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:459 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1d730aad | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:461 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4040ef7e | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:465 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a52d0809 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:466 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-402569a4 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:469 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e81ee8da | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:476 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a34e67e9 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:480 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6f8e323 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:482 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3880891b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:486 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-1f3b14bd | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:491 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fcddb010 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 1 | DMF0074_MetalLinkPrice.cs:492 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0074_MetalLinkPrice.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abbc1869 | this.Load | DMF0074_MetalLinkPrice.cs:85 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4634305c | this.Load | DMF0074_MetalLinkPrice.cs:86 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0074_MetalLinkPrice.GetDayRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbd251b1 | (진입점 미연결) | DMF0074_MetalLinkPrice.cs:231 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-f15b98ec | (진입점 미연결) | DMF0074_MetalLinkPrice.cs:232 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9de59c29 | (진입점 미연결) | DMF0074_MetalLinkPrice.cs:233 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-1a80ffaa | (진입점 미연결) | DMF0074_MetalLinkPrice.cs:235 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-77f6d58e | (진입점 미연결) | DMF0074_MetalLinkPrice.cs:238 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0074_MetalLinkPrice.GetSpdTitle

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / this.Load / this.clbDivisions.SelectedIndexChanged [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c5303b9 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | DMF0074_MetalLinkPrice.cs:745 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-caa3f485 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | DMF0074_MetalLinkPrice.cs:746 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7e5235f2 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | DMF0074_MetalLinkPrice.cs:747 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4e894c9d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | DMF0074_MetalLinkPrice.cs:748 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-27aa3c00 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | DMF0074_MetalLinkPrice.cs:749 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0074" | 행/컬럼 값 대입 |  |  |  |
| AC-7871e7f0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | DMF0074_MetalLinkPrice.cs:750 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-77007057 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | DMF0074_MetalLinkPrice.cs:751 |  | DATA_OP | request.Parameters["p_division_id"] | CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-09d55d5a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | DMF0074_MetalLinkPrice.cs:753 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b5238d17 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | DMF0074_MetalLinkPrice.cs:755 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0074_MetalLinkPrice.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9da2edd6 | this.Load | DMF0074_MetalLinkPrice.cs:167 |  | UI_PROP | drpPeriodMonth.MonthText1 | DateTime.Now.ToString("yyyyMM") | 속성 MonthText1 설정 |  |  |  |
| AC-bf90d00c | this.Load | DMF0074_MetalLinkPrice.cs:168 |  | UI_PROP | drpPeriodMonth.MonthText2 | DateTime.Now.AddMonths(6).ToString("yyyyMM") | 속성 MonthText2 설정 |  |  |  |
| AC-d00b2c40 | this.Load | DMF0074_MetalLinkPrice.cs:170 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9fca535c | this.Load | DMF0074_MetalLinkPrice.cs:172 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4f336e0a | this.Load | DMF0074_MetalLinkPrice.cs:176 |  | FLAG | dtDepartment | Data.Common(Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoC… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 화면 필드/플래그 변경 |  |  |  |
| AC-f59dcce2 | this.Load | DMF0074_MetalLinkPrice.cs:176 |  | COMBO_DATA | Data.Common | (Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff5f07ff | this.Load | DMF0074_MetalLinkPrice.cs:179 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-873f2c7f | this.Load | DMF0074_MetalLinkPrice.cs:186 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6f9393cb | this.Load | DMF0074_MetalLinkPrice.cs:190 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3bd4d560 | this.Load | DMF0074_MetalLinkPrice.cs:191 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5eb91d1f | this.Load | DMF0074_MetalLinkPrice.cs:192 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblBtnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-875183e0 | this.Load | DMF0074_MetalLinkPrice.cs:198 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-74f2c6dc | this.Load | DMF0074_MetalLinkPrice.cs:202 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b6858f27 | this.Load | DMF0074_MetalLinkPrice.cs:203 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e4afeab5 | this.Load | DMF0074_MetalLinkPrice.cs:204 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblBtnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ed1973be | this.Load | DMF0074_MetalLinkPrice.cs:206 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-416ad122 | this.Load | DMF0074_MetalLinkPrice.cs:207 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-cbb8dd88 | this.Load | DMF0074_MetalLinkPrice.cs:213 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-17cc0e47 | this.Load | DMF0074_MetalLinkPrice.cs:218 | if (sDivision.IndexOf("81") != -1) | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByEndCustomer, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9d1528ff | this.Load | DMF0074_MetalLinkPrice.cs:222 |  | VALUE_SET | txtVersion.Text | "Current" | 컨트롤 값 설정 |  |  |  |

## DMF0074_MetalLinkPrice.InitSpread

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / this.Load / this.clbDivisions.SelectedIndexChanged [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de4ed4ed | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | DMF0074_MetalLinkPrice.cs:279 |  | FLAG | dtTitle | GetSpdTitle(siMain.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-d121c419 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | DMF0074_MetalLinkPrice.cs:280 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0074_MetalLinkPrice.SetChangeControl

진입점: this.clbEndCustomer.SelectedIndexChanged / this.clbTeam.SelectedIndexChanged [if ((clbDivisions.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivisions.SelectedValue.ToString() == "82"))] / this.Load / this.clbDivisions.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f58cef83 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:102 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7bc79b2b | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:103 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-69214bf5 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:109 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2896a808 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:109 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-48679f60 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:114 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-197218b9 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:116 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2fc85e42 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:116 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-92d58bfe | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:121 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-87bffed0 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:122 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-1459fae7 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:124 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-afad8415 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:124 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-5a811f23 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:129 | switch (triggerControl) case "BizType": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7273e739 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:131 | switch (triggerControl) case "BizType": | FLAG | dtBizType | DataService.GetDMInnerTable("BizType", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d7b97ba | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:131 | switch (triggerControl) case "BizType": | COMBO_DATA | DataService.GetDMInnerTable | ("BizType", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-63fe989c | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:136 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1e7a368d | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:137 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-cee608b4 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:138 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-181d36a1 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:140 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-3bf71cfc | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:140 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-74f81442 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:145 | switch (triggerControl) case "UserPlantSiteByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-2204c2f8 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:147 | switch (triggerControl) case "UserPlantSiteByDivision": | FLAG | dtPlantSite | DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4900df0f | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:147 | switch (triggerControl) case "UserPlantSiteByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-534b7541 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:152 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7f41edfc | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:153 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-586d88ad | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:155 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | FLAG | dtPlantSiteByEndCustomer | DataService.GetDMInnerTable("UserPlantSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d46fd20c | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0074_MetalLinkPrice.cs:155 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0074_MetalLinkPricePopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-131948a9 | .ctor | DMF0074_MetalLinkPricePopup.cs:69 |  | FLAG | sDivision_id | pDivId | 화면 필드/플래그 변경 |  |  |  |

## DMF0074_MetalLinkPricePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e1f544b | this.btnButtonList.UsrButtonList_Click_Detected | DMF0074_MetalLinkPricePopup.cs:258 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f0ea67b5 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0074_MetalLinkPricePopup.cs:261 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0074_MetalLinkPricePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b4d920c | this.Load | DMF0074_MetalLinkPricePopup.cs:113 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1368781f | this.Load | DMF0074_MetalLinkPricePopup.cs:114 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a806cfc2 | this.Load | DMF0074_MetalLinkPricePopup.cs:115 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0074_MetalLinkPricePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44196b59 | this.Load | DMF0074_MetalLinkPricePopup.cs:106 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0074_MetalLinkPricePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-656b5434 | Dispose | DMF0074_MetalLinkPricePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0074_MetalLinkPricePopup.ExcelButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Excel:] / ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1604895 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:307 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-e05f4a92 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:308 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-e3eebba4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:309 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-0f357632 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:310 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-4c1fe11e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:311 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-c0826d8d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:312 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-a24aafa7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:314 |  | UI_PROP | exportOption.UserName | UserInfoContext.Current.UserId | 속성 UserName 설정 |  |  |  |
| AC-70cfa8e0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:315 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-b56f138e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:317 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-e4c4feed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:326 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-08e92251 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:331 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-b051991f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:335 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0074_MetalLinkPricePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37629b8c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:161 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b53bc07e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:170 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-89e4a2fc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:171 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a970eb8e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:176 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7925bad6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:178 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c2531ea2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:191 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-662ab28a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:193 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-80a20d52 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:197 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0074_GET_METAL_LINK_TEMPLATE") ⇒ DM.DMF0074_GET_METAL_LINK_TEMPLATE | 엔드포인트 요청 생성 |  |  |  |
| AC-ade9a78a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:199 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c00acc31 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:201 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-84559f1f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:203 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-33c0e469 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:205 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d7589ad1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:209 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d4d98b79 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:210 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1af1a634 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:213 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a4ba596 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:220 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ab4ce5b5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:222 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f71745c2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:229 | try ▸ if (ds.Tables[0].Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00427") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c0224a16 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:234 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9981e14e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:238 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-97dd84f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0074_MetalLinkPricePopup.cs:243 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0074_MetalLinkPricePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f69b9dad | this.Load | DMF0074_MetalLinkPricePopup.cs:76 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-27982561 | this.Load | DMF0074_MetalLinkPricePopup.cs:78 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0074_MetalLinkPricePopup.GetSpdTitle

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe21a975 | this.Load | DMF0074_MetalLinkPricePopup.cs:287 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-47f9a01a | this.Load | DMF0074_MetalLinkPricePopup.cs:288 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-46834035 | this.Load | DMF0074_MetalLinkPricePopup.cs:289 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d36cc905 | this.Load | DMF0074_MetalLinkPricePopup.cs:290 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3af20af9 | this.Load | DMF0074_MetalLinkPricePopup.cs:291 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0074" | 행/컬럼 값 대입 |  |  |  |
| AC-c14229f6 | this.Load | DMF0074_MetalLinkPricePopup.cs:292 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-6406ed9f | this.Load | DMF0074_MetalLinkPricePopup.cs:293 |  | DATA_OP | request.Parameters["p_division_id"] | CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-b52acee0 | this.Load | DMF0074_MetalLinkPricePopup.cs:295 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bfd22e9e | this.Load | DMF0074_MetalLinkPricePopup.cs:297 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0074_MetalLinkPricePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5aefc0a3 | this.Load | DMF0074_MetalLinkPricePopup.cs:95 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6cdde75f | this.Load | DMF0074_MetalLinkPricePopup.cs:96 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-dc494e07 | this.Load | DMF0074_MetalLinkPricePopup.cs:96 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f7a152ab | this.Load | DMF0074_MetalLinkPricePopup.cs:97 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-521a138d | this.Load | DMF0074_MetalLinkPricePopup.cs:99 |  | VALUE_SET | clbDivisions.ControlValues | this.sDivision_id | 컨트롤 값 설정 |  |  |  |

## DMF0074_MetalLinkPricePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a685d26 | this.Load | DMF0074_MetalLinkPricePopup.cs:124 |  | FLAG | dtTitle | GetSpdTitle(siMain.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-30341706 | this.Load | DMF0074_MetalLinkPricePopup.cs:125 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0074_MetalLinkPricePopup.mOK

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01ad5cf3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0074_MetalLinkPricePopup.cs:271 |  | FLAG | blnOK | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0074_MetalLinkPricePopup.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d4dbf71 | this.spdMain.TopChange | DMF0074_MetalLinkPricePopup.cs:277 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |


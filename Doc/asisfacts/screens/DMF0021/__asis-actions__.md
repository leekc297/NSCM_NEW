# AS-IS 액션 대조표 — DMF0021

> 원천: `Doc/asisfacts/screens/DMF0021/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1541행 · 메서드 70 · 종류 DATA_OP 345 · GRID_LOCK 183 · GRID_SET 149 · FLAG 117 · RETURN 115 · ENDPOINT 94 · CALL_EXT 67 · GRID_COMBO 66 · COMBO_DATA 58 · UI_PROP 56 · GRID_INIT 53 · POPUP 43 · MESSAGE 42 · LIST_REBIND 38 · STATE 34 · UI_MISC 22 · VALUE_CLEAR 14 · THROW 14 · GRID_STYLE 13 · VALUE_SET 12 · STATE_RESET 4 · GRID_BIND 2 · ⚠ 의미 확인 필요 67


## DMF0021_SalesPlan.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05c2345d | this.btnColumn.Click | DMF0021_SalesPlan.cs:4470 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-6eb1cbe8 | this.btnColumn.Click | DMF0021_SalesPlan.cs:4471 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a3bc0fc3 | this.btnColumn.Click | DMF0021_SalesPlan.cs:4472 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-db050904 | this.btnColumn.Click | DMF0021_SalesPlan - 복사본.cs:2677 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-6a8f68d6 | this.btnColumn.Click | DMF0021_SalesPlan - 복사본.cs:2678 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6249059d | this.btnColumn.Click | DMF0021_SalesPlan - 복사본.cs:2679 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0021_SalesPlan.btnCutOff_Click

진입점: this.btnCutOff.Click / this.layoutControlItem7.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6a288f0 | this.btnCutOff.Click 외 1 | DMF0021_SalesPlan - 복사본.cs:2968 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-5ad2ea88 | this.btnCutOff.Click 외 1 | DMF0021_SalesPlan - 복사본.cs:2969 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03490fb9 | this.btnCutOff.Click 외 1 | DMF0021_SalesPlan - 복사본.cs:2975 |  | POPUP | new POPUP.VersionCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-663cf62e | this.btnCutOff.Click 외 1 | DMF0021_SalesPlan - 복사본.cs:2976 |  | CALL_EXT | popup.LoadData | (sVersion_Type, sFoxData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2908ef1 | this.btnCutOff.Click 외 1 | DMF0021_SalesPlan - 복사본.cs:2977 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9335d25d | this.btnCutOff.Click 외 1 | DMF0021_SalesPlan - 복사본.cs:2978 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0021_SalesPlan.btnItemId_Click

진입점: this.btnItemId.Click / this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d361a7a6 | this.btnItemId.Click 외 1 | DMF0021_SalesPlan.cs:3559 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-c0f0afe4 | this.btnItemId.Click 외 1 | DMF0021_SalesPlan.cs:3562 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-4446914c | this.btnItemId.Click 외 1 | DMF0021_SalesPlan.cs:3563 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1144d78c | this.btnItemId.Click 외 1 | DMF0021_SalesPlan.cs:3564 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-62275bde | this.btnItemId.Click 외 1 | DMF0021_SalesPlan.cs:3566 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |
| AC-8c6ab27c | this.btnItemId.Click 외 1 | DMF0021_SalesPlan - 복사본.cs:1999 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-b1b91ee7 | this.btnItemId.Click 외 1 | DMF0021_SalesPlan - 복사본.cs:2002 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-70d59e16 | this.btnItemId.Click 외 1 | DMF0021_SalesPlan - 복사본.cs:2003 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-df81e9be | this.btnItemId.Click 외 1 | DMF0021_SalesPlan - 복사본.cs:2004 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4cbbd64f | this.btnItemId.Click 외 1 | DMF0021_SalesPlan - 복사본.cs:2006 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0021_SalesPlan.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d1595c2 | this.btnMeasure.Click | DMF0021_SalesPlan.cs:4483 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-b612cad4 | this.btnMeasure.Click | DMF0021_SalesPlan.cs:4484 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-56be5e19 | this.btnMeasure.Click | DMF0021_SalesPlan.cs:4485 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0d83aa87 | this.btnMeasure.Click | DMF0021_SalesPlan - 복사본.cs:2690 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-cc2346d1 | this.btnMeasure.Click | DMF0021_SalesPlan - 복사본.cs:2691 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-58d9ec3d | this.btnMeasure.Click | DMF0021_SalesPlan - 복사본.cs:2692 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0021_SalesPlan.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f744ca28 | this.btnOwner.Click | DMF0021_SalesPlan.cs:5502 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4e4a6810 | this.btnOwner.Click | DMF0021_SalesPlan.cs:5505 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-7d9fe66b | this.btnOwner.Click | DMF0021_SalesPlan.cs:5506 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e85a1ce5 | this.btnOwner.Click | DMF0021_SalesPlan.cs:5507 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d30f3b06 | this.btnOwner.Click | DMF0021_SalesPlan.cs:5509 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |
| AC-2d1c6517 | this.btnOwner.Click | DMF0021_SalesPlan - 복사본.cs:3287 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-918723b3 | this.btnOwner.Click | DMF0021_SalesPlan - 복사본.cs:3290 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-13c5800a | this.btnOwner.Click | DMF0021_SalesPlan - 복사본.cs:3291 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f9ca1aa5 | this.btnOwner.Click | DMF0021_SalesPlan - 복사본.cs:3292 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-30271d9b | this.btnOwner.Click | DMF0021_SalesPlan - 복사본.cs:3294 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0021_SalesPlan.btnProject_Click

진입점: this.btnProject.Click / this.layoutControlItem3.Click / this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf2be464 | this.btnProject.Click 외 2 | DMF0021_SalesPlan.cs:3539 | if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-caf90c05 | this.btnProject.Click 외 2 | DMF0021_SalesPlan.cs:3540 | if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a001822c | this.btnProject.Click 외 2 | DMF0021_SalesPlan.cs:3541 | if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-23e7c5b2 | this.btnProject.Click 외 2 | DMF0021_SalesPlan.cs:3542 | if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-aabbb579 | this.btnProject.Click 외 2 | DMF0021_SalesPlan.cs:3544 | if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |
| AC-0ba495e4 | this.btnProject.Click 외 2 | DMF0021_SalesPlan - 복사본.cs:1979 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-077b7e40 | this.btnProject.Click 외 2 | DMF0021_SalesPlan - 복사본.cs:1980 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-24e5c683 | this.btnProject.Click 외 2 | DMF0021_SalesPlan - 복사본.cs:1981 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e2e123a1 | this.btnProject.Click 외 2 | DMF0021_SalesPlan - 복사본.cs:1982 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5d4337a3 | this.btnProject.Click 외 2 | DMF0021_SalesPlan - 복사본.cs:1984 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0021_SalesPlan.cboBucketType_Click

진입점: this.cboBucketType.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01f52d2f | this.cboBucketType.Click | DMF0021_SalesPlan.cs:5519 | if (!siMain.IsLock()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00227") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ddd3fc5 | this.cboBucketType.Click | DMF0021_SalesPlan.cs:5520 | if (!siMain.IsLock()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4572e5a0 | this.cboBucketType.Click | DMF0021_SalesPlan - 복사본.cs:3303 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | MESSAGE | MessageHelper.GMessageBox | ("MSG00227") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2d572690 | this.cboBucketType.Click | DMF0021_SalesPlan - 복사본.cs:3304 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d307626 | this.cboBucketType.SelectedIndexChanged | DMF0021_SalesPlan.cs:3580 | if (siMain != null) | FLAG | sBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-1aa4a168 | this.cboBucketType.SelectedIndexChanged | DMF0021_SalesPlan.cs:3587 | if (siMain != null) | FLAG | sResult_YYYYMMWW | "W_" + sResult_YYYYMMDD.Substring(0, 6) + iso_week | 화면 필드/플래그 변경 |  |  |  |
| AC-b3abd678 | this.cboBucketType.SelectedIndexChanged | DMF0021_SalesPlan.cs:3596 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnIndex("D_"… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResult_YYYYMMDD)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-5b41fad9 | this.cboBucketType.SelectedIndexChanged | DMF0021_SalesPlan.cs:3597 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues == BucketType.Daily) | CALL_EXT | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].ResetBorder | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f19e82e7 | this.cboBucketType.SelectedIndexChanged | DMF0021_SalesPlan.cs:3612 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.Control… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-96422bde | this.cboBucketType.SelectedIndexChanged | DMF0021_SalesPlan.cs:3614 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.Control… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-0c495415 | this.cboBucketType.SelectedIndexChanged | DMF0021_SalesPlan.cs:3617 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.Control… | CALL_EXT | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResult_YYYYMMDD)].ResetBorder | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0021_SalesPlan.cboKRW_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d0262d5 | (진입점 미연결) | DMF0021_SalesPlan.cs:5446 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af2ce66d | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3231 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.cboLOC_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be34a230 | (진입점 미연결) | DMF0021_SalesPlan.cs:5466 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f2b4025 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3251 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.cboUSD_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48c8d63c | (진입점 미연결) | DMF0021_SalesPlan.cs:5456 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23860dc1 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3241 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bb6741e | this.clbCustomer.SelectedIndexChanged | DMF0021_SalesPlan.cs:5130 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c70e387d | this.clbCustomer.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:2987 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-91050ec6 | this.clbCustomer.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:2987 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-96488f85 | this.clbCustomer.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:2988 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0021_SalesPlan.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee4264f0 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5155 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b6041fd0 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5167 | try ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e4c43cba | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5177 | try ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c0028a22 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5178 | try ▸ if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-30e6aaa3 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5179 | try ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0f763d58 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5181 | try ▸ if (sDivision == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-d4062f0f | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5182 | try ▸ if (sDivision == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-65dc2011 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5189 | try ▸ else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-98ca59a7 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5199 | try ▸ else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8bdc7971 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5200 | try ▸ else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a1cc7d9b | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5201 | try ▸ else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d7b6747f | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5207 | try | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-909a4fd9 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5211 | try | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9350dff1 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5220 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2a6d8cd0 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5231 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-72cb85b8 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5236 | try | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-cf40a31c | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5237 | try | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1740cfcb | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5238 | try | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-b5014448 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan.cs:5246 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-522221cf | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:2999 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb14ad7e | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3002 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6f4b1cd6 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3006 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-319f71f8 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3006 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8e6f749b | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3007 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f6f8513b | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3015 | try ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-97e7e9f6 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3015 | try ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5d1f480d | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3016 | try ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a632500e | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3018 | try ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-c4ec8ab2 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3018 | try ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1ef18c97 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3021 | try ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8591b88d | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3022 | try ▸ if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4b798bc1 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3023 | try ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d28e36b0 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3025 | try ▸ if (sDivision == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1dc1d5e4 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3026 | try ▸ if (sDivision == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-9503d02c | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3030 | try ▸ else of (sDivision == "40") | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6f9ab17 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3031 | try ▸ else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-88a7ea3c | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3033 | try ▸ else of (sDivision == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7768713c | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3033 | try ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-00788a6f | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3036 | try ▸ else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-559638ef | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3037 | try ▸ else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4cc8826b | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3038 | try ▸ else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ab8bad79 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3044 | try | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4825f453 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3046 | try | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9ca3f52a | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3050 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-dd7541ea | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3050 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6f086203 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3051 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a8c2b9c8 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3053 | try | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-faa1b8e1 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3053 | try | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6c184572 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3054 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-92588a00 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3056 | try | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-299155f8 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3057 | try | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3dbe6ae9 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3058 | try | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a6be2f5e | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3064 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1cc748d6 | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3065 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-49faeeff | this.clbDivision.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3069 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0021_SalesPlan.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f338a921 | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan.cs:5359 | if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7856f074 | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan.cs:5374 | else of ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-33b793fc | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan.cs:5386 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-95418a9a | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3154 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-53cbf162 | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3154 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-74f56933 | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3155 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-854ed89d | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3159 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-441adeb2 | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3159 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3b9dd153 | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3163 | else of ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-deda0108 | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3163 | else of ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-89e31a1d | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3164 | else of ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b81ca37c | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3168 | else of ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-eaabef8d | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3168 | else of ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bdb4e1c9 | this.clbTeam.SelectedIndexChanged | DMF0021_SalesPlan - 복사본.cs:3171 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0021_SalesPlan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bcbcf2a | this.Load | DMF0021_SalesPlan.cs:581 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-706ee356 | this.Load | DMF0021_SalesPlan.cs:582 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-94271312 | this.Load | DMF0021_SalesPlan.cs:583 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b4326616 | this.Load | DMF0021_SalesPlan - 복사본.cs:374 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-612af32f | this.Load | DMF0021_SalesPlan - 복사본.cs:375 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8f281f51 | this.Load | DMF0021_SalesPlan - 복사본.cs:376 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0021_SalesPlan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5324761a | this.Load | DMF0021_SalesPlan.cs:543 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-7d66c4f9 | this.Load | DMF0021_SalesPlan.cs:544 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-0b97f0db | this.Load | DMF0021_SalesPlan.cs:546 |  | UI_PROP | usrConditionPanel2.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-a3422b4d | this.Load | DMF0021_SalesPlan.cs:549 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |
| AC-130c0591 | this.Load | DMF0021_SalesPlan.cs:551 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-084c8b2f | this.Load | DMF0021_SalesPlan.cs:553 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-63b9be2f | this.Load | DMF0021_SalesPlan.cs:554 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-54f14a4c | this.Load | DMF0021_SalesPlan.cs:555 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-fd0f5fc7 | this.Load | DMF0021_SalesPlan.cs:556 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-57846d00 | this.Load | DMF0021_SalesPlan - 복사본.cs:320 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-44804303 | this.Load | DMF0021_SalesPlan - 복사본.cs:321 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-a4fb139f | this.Load | DMF0021_SalesPlan - 복사본.cs:323 |  | UI_PROP | usrConditionPanel2.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-f45d3c69 | this.Load | DMF0021_SalesPlan - 복사본.cs:326 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-d40f7785 | this.Load | DMF0021_SalesPlan - 복사본.cs:328 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-6f6a3208 | this.Load | DMF0021_SalesPlan - 복사본.cs:330 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-36d6ef2a | this.Load | DMF0021_SalesPlan - 복사본.cs:331 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-bfc8d6db | this.Load | DMF0021_SalesPlan - 복사본.cs:332 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-ff72c012 | this.Load | DMF0021_SalesPlan - 복사본.cs:333 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-a2b8613e | this.Load | DMF0021_SalesPlan - 복사본.cs:340 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-64efa778 | this.Load | DMF0021_SalesPlan - 복사본.cs:341 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-63e3a8d1 | this.Load | DMF0021_SalesPlan - 복사본.cs:342 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-07057537 | this.Load | DMF0021_SalesPlan - 복사본.cs:345 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fde9d84e | this.Load | DMF0021_SalesPlan - 복사본.cs:346 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-88771976 | this.Load | DMF0021_SalesPlan - 복사본.cs:347 | switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DMF0021_SalesPlan.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0abe74f8 | DeleteButton | DMF0021_SalesPlan.cs:683 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ea6f1467 | DeleteButton | DMF0021_SalesPlan - 복사본.cs:593 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0021_SalesPlan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9bbe47d | Dispose | DMF0021_SalesPlan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-17d979ba | Dispose | DMF0021_SalesPlan - 복사본.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0021_SalesPlan.Draw

진입점: FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try ▸ if (blnInsert) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c123994c | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1660 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4faf0446 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1677 | try ▸ if (data_start_pos < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-83996ccc | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1691 | try ▸ for (j < maxCol) | DATA_OP | colnames[j - data_start_pos] | siMain.GetColumnTag(j) | 행/컬럼 값 대입 |  |  |  |
| AC-d9190351 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1695 | try ▸ for (j < maxCol) ▸ for (i < maxRow) | DATA_OP | ds.Tables[0].Columns.Contains | (siMain.GetColumnTag(j)) | 데이터 객체 조작/조회 |  |  |  |
| AC-27420bec | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1703 | try ▸ for (j < maxCol) ▸ for (i < maxRow) | DATA_OP | rNotation[i] | ds.Tables[0].Rows[i]["NOTATION"].String().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-dac975e5 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1703 | try ▸ for (j < maxCol) ▸ for (i < maxRow) | CALL_EXT | ds.Tables[0].Rows[i]["NOTATION"].String | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3ff54d3 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1717 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rNotation[i]) case "INTEGER": | DATA_OP | rMeasureType[i] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-87f6fd9f | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1720 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rNotation[i]) case "POINT": | DATA_OP | rMeasureType[i] | 2 | 행/컬럼 값 대입 |  |  |  |
| AC-12dcea2b | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1723 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rNotation[i]) case "POINT3": | DATA_OP | rMeasureType[i] | 3 | 행/컬럼 값 대입 |  |  |  |
| AC-71164aa7 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1734 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 1: ▸ if (Val.… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-34ed9290 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1736 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 1: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-46930f35 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1743 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 2: ▸ if (Val … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-996c2cb1 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1746 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 2: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "0.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d94fe2ec | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1749 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 2: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca3169ed | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1752 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 2: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff999a24 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1759 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ if (Val … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e85d7f34 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1762 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "0.#00") | ⚠ 의미 확인 필요 |  |  |  |
| AC-12de4e63 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1765 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "0.##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b158c4c2 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1768 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "0.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-82422bcb | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1771 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###.#00") | ⚠ 의미 확인 필요 |  |  |  |
| AC-51f9b6c2 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1774 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###.##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-65320763 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1777 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-63e78a46 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1796 | if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0) | FLAG | this_YYYYMM | ds.Tables[1].Rows[0]["THIS_YYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-21322e92 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1797 | if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0) | FLAG | this_YYYYMMWW | ds.Tables[1].Rows[0]["THIS_YYYYMMWW"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9203aa59 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1798 | if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0) | FLAG | pre_YYYYMM | ds.Tables[1].Rows[0]["PRE_YYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5a76ed27 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1799 | if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0) | FLAG | pre_YYYYMMWW | ds.Tables[1].Rows[0]["PRE_YYYYMMWW"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-48a3059a | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1800 | if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0) | FLAG | weekDate | Convert.ToDateTime(ds.Tables[1].Rows[0]["BASIS_DATE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-db5c00d6 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1801 | if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0) | FLAG | basis_YYYYMM | ds.Tables[1].Rows[0]["BASIS_YYYYMM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0da6aa55 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1802 | if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0) | FLAG | iso_week | ds.Tables[1].Rows[0]["ISO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c1df80f7 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1807 | if (sResult_YYYYMMDD.Substring(0, 6) != basis_YYYYMM) | FLAG | sResult_YYYYMMWW | "W_" + sResult_YYYYMMDD.Substring(0, 6) + iso_week | 화면 필드/플래그 변경 |  |  |  |
| AC-4b093bef | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1825 | for (i <= iTotalRowCount) ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-c9341d3b | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1830 | for (i <= iTotalRowCount) ▸ if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) != -1) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID)].VerticalA… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-c287b013 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1910 | if (chkColor.Checked == true) ▸ if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.GetMaxRowIndex(), iResultCol, Co… | 그리드 표시 설정 |  |  |  |
| AC-93f0cb6d | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1912 | if (chkColor.Checked == true) ▸ if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-c636e965 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1923 | else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues != BucketType.Daily) ▸ if (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-ca5a15b8 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1925 | else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues != BucketType.Daily) ▸ if (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-cdac4870 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1931 | else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues != BucketType.Daily) ▸ if (cboBuc… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResult_YYYYMMDD)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-0bae0e62 | FindButton [try] 외 1 | DMF0021_SalesPlan.cs:1936 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0021_SalesPlan.Dsdm_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68a27797 | dsdm.Changed | DMF0021_SalesPlan.cs:3962 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b266515 | dsdm.Changed | DMF0021_SalesPlan.cs:3967 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42a90206 | dsdm.Changed | DMF0021_SalesPlan.cs:3968 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5997867 | dsdm.Changed | DMF0021_SalesPlan.cs:3969 | if (siMain.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac50cd98 | dsdm.Changed | DMF0021_SalesPlan.cs:3978 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a61c55f | dsdm.Changed | DMF0021_SalesPlan.cs:3983 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-5539846a | dsdm.Changed | DMF0021_SalesPlan.cs:3984 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0bc8cffe | dsdm.Changed | DMF0021_SalesPlan.cs:3988 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row, e.Column, e.Row, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a66d6f21 | dsdm.Changed | DMF0021_SalesPlan.cs:4007 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, iStartCol, siMain.GetText(e.Row, iStartCol)) | 그리드 값 설정 |  |  |  |
| AC-6db65791 | dsdm.Changed | DMF0021_SalesPlan.cs:4023 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, iStartCol, siMain.GetText(e.Row, iStartCol)) | 그리드 값 설정 |  |  |  |
| AC-4673ec71 | dsdm.Changed | DMF0021_SalesPlan - 복사본.cs:2252 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f82ab2a | dsdm.Changed | DMF0021_SalesPlan - 복사본.cs:2257 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52c11d1e | dsdm.Changed | DMF0021_SalesPlan - 복사본.cs:2258 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-42a6b5c7 | dsdm.Changed | DMF0021_SalesPlan - 복사본.cs:2259 | if (siMain.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-412a937f | dsdm.Changed | DMF0021_SalesPlan - 복사본.cs:2268 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-56b754c1 | dsdm.Changed | DMF0021_SalesPlan - 복사본.cs:2273 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-41dd2dc5 | dsdm.Changed | DMF0021_SalesPlan - 복사본.cs:2274 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7667a13d | dsdm.Changed | DMF0021_SalesPlan - 복사본.cs:2278 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row, e.Column, e.Row, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c52d3b77 | dsdm.Changed | DMF0021_SalesPlan - 복사본.cs:2305 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 2, iWeeklySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-6c00100b | dsdm.Changed | DMF0021_SalesPlan - 복사본.cs:2329 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |

## DMF0021_SalesPlan.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36a96233 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:730 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| (CString.GetCheckedListValue(dtDivision, clbDivision.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00429", new object[] { "Team" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d60fbfdc | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:734 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| (CString.GetCheckedListValue(dtDivision, clbDivision.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-447b0e44 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:738 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| (CString.GetCheckedListValue(dtDivision, clbDivision.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4fa17aff | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:741 | if (this.fps != null) ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| (CString.GetCheckedListValue(dtDivision, clbDivision.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-babb70a3 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:746 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-18650ea5 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:747 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-7f57d40e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:750 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bfb0612b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:762 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) | STATE_RESET | list_EDIT_Week.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-a73a903c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:763 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) | STATE_RESET | list_EDIT_Month.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-849c3c7f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:776 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ for (… | DATA_OP | list_EDIT_Month.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a96f8a5 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:784 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ for (… | DATA_OP | list_EDIT_Month.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-7faf894c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:793 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ for (… | DATA_OP | list_EDIT_Month.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ff71891 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:801 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ for (… | DATA_OP | list_EDIT_Month.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-24db9362 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:808 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ for (… | DATA_OP | list_EDIT_Week.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-a68c5adc | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:817 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ for (… | DATA_OP | list_EDIT_Week.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f31534b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:826 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ if (s… | CALL_EXT | sStartPeriod.CompareTo | (weekDate.AddDays(-7)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c836065f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:828 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ if (s… | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.GetMaxRowIndex(), siMain.GetColu… | 그리드 표시 설정 |  |  |  |
| AC-9e072189 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:834 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ if (s… | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(this_YYYYMM), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(thi… | 그리드 표시 설정 |  |  |  |
| AC-c3b030f2 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:855 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ if (s… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-febcc0d6 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:859 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ if (s… | FLAG | sResult_YYYYMMWW | "W_" + sResult_YYYYMMDD.Substring(0, 6) + iso_week | 화면 필드/플래그 변경 |  |  |  |
| AC-eaad40d7 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:860 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ if (s… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-0e03e125 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:880 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Select… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b8395c35 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:917 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | DATA_OP | list_EDIT_Week.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-f79b510b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:944 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | DATA_OP | dsMain.Tables[2].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f3139060 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:945 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | DATA_OP | dt.Columns.Contains | ("EDIT_AUTH_SalesAmt_LOC") | 데이터 객체 조작/조회 |  |  |  |
| AC-85e6ac52 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:949 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | DATA_OP | dt.Columns.Contains | ("EDIT_AUTH_RTF_SYS_RP") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d0d895b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:993 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | CALL_EXT | Convert.ToUInt32 | (sValue.Replace("W_", "").Replace("M_", "").Substring(0, 6)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f2b0df30 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:993 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | CALL_EXT | Convert.ToUInt32 | (DateTime.Now.AddMonths(3).ToString("yyyyMM")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-56ddd208 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1005 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | GRID_LOCK | siMain.LockRange | (i, j, i, siMain.GetMaxColumnIndex(), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-36d4c722 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1012 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | GRID_LOCK | siMain.LockRange | (i, list_EDIT_Week[x], i, list_EDIT_Week[x], true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-07bfab11 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1020 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | GRID_LOCK | siMain.LockRange | (i, list_EDIT_Month[x], i, list_EDIT_Month[x], true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a250da0a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1026 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | GRID_LOCK | siMain.LockRange | (i, j, i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-46c48dfe | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1031 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | GRID_LOCK | siMain.LockRange | (i, j, i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-90631db5 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1036 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | GRID_LOCK | siMain.LockRange | (i, j, i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-73769270 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1056 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | GRID_LOCK | siMain.LockRange | (i, j, i, siMain.GetMaxColumnIndex(), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eea6be17 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1063 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | GRID_LOCK | siMain.LockRange | (i, list_EDIT_Week[x], i, list_EDIT_Week[x], true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f960d015 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1071 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | CALL_EXT | Convert.ToUInt32 | (DateTime.Now.ToString("yyyyMM")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d60f030 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1073 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | CALL_EXT | Convert.ToUInt32 | (siMain.GetColumnTag(list_EDIT_Month[x]).Replace("M_", "").Substring(0, 6)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-01c3a4b9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1073 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | CALL_EXT | Convert.ToUInt32 | (DateTime.Now.AddMonths(1).ToString("yyyyMM")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-159927e8 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1075 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | GRID_LOCK | siMain.LockRange | (i, list_EDIT_Month[x], i, list_EDIT_Month[x], true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c2585649 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1087 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | GRID_LOCK | siMain.LockRange | (i, list_EDIT_Month[x], i, list_EDIT_Month[x], true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-68c049ef | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1092 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | GRID_LOCK | siMain.LockRange | (i, j, i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-98e04a43 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1096 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | GRID_LOCK | siMain.LockRange | (i, j, i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-db7f7bfa | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1100 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ try ▸… | GRID_LOCK | siMain.LockRange | (i, j, i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1dec70ac | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1113 | if (this.fps != null) ▸ if (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ catch… | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-903479e2 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1118 | if (this.fps != null) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00361") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-82cb0870 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1119 | if (this.fps != null) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly \|\| cboBucketType.ControlValues == BucketType.Monthly) ▸ … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d2f6ff1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan.cs:1121 | if (this.fps != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6ad8014f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:622 | if (this.fps != null) ▸ if (clbDivision.SelectedValue.ToString() == "81") ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| siM… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f7d2a87b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:623 | if (this.fps != null) ▸ if (clbDivision.SelectedValue.ToString() == "81") ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| siM… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-56857053 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:642 | if (this.fps != null) ▸ else of (clbDivision.SelectedValue.ToString() == "81") ▸ if (clbDivision.SelectedValue.ToString() == "82") ▸ if (siM… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a10f036 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:643 | if (this.fps != null) ▸ else of (clbDivision.SelectedValue.ToString() == "81") ▸ if (clbDivision.SelectedValue.ToString() == "82") ▸ if (siM… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31153a22 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:677 | if (this.fps != null) ▸ else of (clbDivision.SelectedValue.ToString() == "81") ▸ else of (clbDivision.SelectedValue.ToString() == "82") ▸ if… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-690d68da | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:678 | if (this.fps != null) ▸ else of (clbDivision.SelectedValue.ToString() == "81") ▸ else of (clbDivision.SelectedValue.ToString() == "82") ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3c7f7e04 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:682 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d382eddb | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:683 | if (this.fps != null) | CALL_EXT | siMain.SwitchLockEx | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c9241eb | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:686 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a39842e4 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:721 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetValue(i, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (i, j, i, j, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c0318bce | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:723 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetValue(i, siMain.GetCo… | GRID_LOCK | siMain.LockRange | (i, j, i, j, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e338a220 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:730 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MEASURE), i, siMain.GetColumnIndex(DefColumns.MEASURE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-56fdf0a6 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:732 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), i, siMain.GetColumnIndex(DefColumns.DIV… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3dce7ca6 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:734 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.FcstType), i, siMain.GetColumnIndex(DefColumns.FcstTy… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3b1b861c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:736 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.TEAM_INCHARGE), i, siMain.GetColumnIndex(DefColumns.T… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c50f6a23 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:738 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), i, siMain.GetColumnIndex(DefColumns.PR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-aaf49e1d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:740 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.ProjectStatus), i, siMain.GetColumnIndex(DefColumns.P… | 그리드 편집 잠금/해제 |  |  |  |
| AC-aad6ffd4 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:742 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), i, siMain.GetColumnIndex(DefColumns.P… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1217c790 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:744 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.BizTypeName), i, siMain.GetColumnIndex(DefColumns.Biz… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0205cb75 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:746 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), i, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-77bf2b14 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:748 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.ITEM_NAME), i, siMain.GetColumnIndex(DefColumns.ITEM_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dfbc5c91 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:750 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.ItemType), i, siMain.GetColumnIndex(DefColumns.ItemTy… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b5c90394 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:752 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.NickName), i, siMain.GetColumnIndex(DefColumns.NickNa… | 그리드 편집 잠금/해제 |  |  |  |
| AC-60d9a519 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:754 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN), i, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7ad4f7cd | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:756 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.INCOTERMS), i, siMain.GetColumnIndex(DefColumns.INCOT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-02d93224 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:760 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CUST_GROUP), i, siMain.GetColumnIndex(DefColumns.CUST… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2856b25b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:762 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), i, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-afb190e2 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:764 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.OWNER), i, siMain.GetColumnIndex(DefColumns.OWNER), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-35b12da0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:766 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.APPLICATION), i, siMain.GetColumnIndex(DefColumns.APP… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5d2b3840 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:768 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.ROUTE), i, siMain.GetColumnIndex(DefColumns.ROUTE), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-08e0cfee | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:770 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.INTERNAL_YN), i, siMain.GetColumnIndex(DefColumns.INT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6292e44c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:772 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CELL_TYPE), i, siMain.GetColumnIndex(DefColumns.CELL_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-842b8fbc | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:774 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CELL_PACK_COUNT), i, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1f7a3e69 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:776 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CELL_PACK_COUNT), i, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-af44a703 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:779 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.COUNTRY_NAME), i, siMain.GetColumnIndex(DefColumns.CO… | 그리드 편집 잠금/해제 |  |  |  |
| AC-63808646 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:781 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CITY_NAME), i, siMain.GetColumnIndex(DefColumns.CITY_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6b98b314 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:783 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL), i, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a88b88ef | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:785 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP), i, siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9a3fd2ce | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:787 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), i, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ccbd1c7f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:789 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), i, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3ed28a28 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:791 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MEASURE_GROUP), i, siMain.GetColumnIndex(DefColumns.M… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a56aa6e1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:793 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), i, siMain.GetColumnIndex(DefColumns.MI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9b1410c7 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:795 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.VMI_YN), i, siMain.GetColumnIndex(DefColumns.VMI_YN),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ace5f37e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:803 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, k, i, k, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1d8c711c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:811 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.G… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, i, siMain.GetColumnIndex(sLockDate), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ef95f7e1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0021_SalesPlan - 복사본.cs:817 | if (this.fps != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## DMF0021_SalesPlan.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd7b9ab8 | ExcelButton | DMF0021_SalesPlan.cs:1152 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-44d016a1 | ExcelButton | DMF0021_SalesPlan.cs:1153 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-b20448a9 | ExcelButton | DMF0021_SalesPlan.cs:1154 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-92c19f93 | ExcelButton | DMF0021_SalesPlan.cs:1155 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-e77f756d | ExcelButton | DMF0021_SalesPlan.cs:1156 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-aa51027d | ExcelButton | DMF0021_SalesPlan.cs:1157 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-f29925a2 | ExcelButton | DMF0021_SalesPlan.cs:1159 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-eca1deab | ExcelButton | DMF0021_SalesPlan.cs:1160 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-a9f73305 | ExcelButton | DMF0021_SalesPlan.cs:1162 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.##0;[Red]-#,##0.##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-26d9922f | ExcelButton | DMF0021_SalesPlan.cs:1171 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c1298a8 | ExcelButton | DMF0021_SalesPlan.cs:1176 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-92f7995b | ExcelButton | DMF0021_SalesPlan.cs:1180 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0021_SalesPlan.ExportExcel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5953fb6 | (진입점 미연결) | DMF0021_SalesPlan.cs:1202 |  | UI_PROP | ExcelOptionEx.Border | ExcelBorderOptionEx.All | 속성 Border 설정 |  |  |  |
| AC-e98ac9fb | (진입점 미연결) | DMF0021_SalesPlan.cs:1203 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f9e296c8 | (진입점 미연결) | DMF0021_SalesPlan.cs:1206 | try ▸ if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5013260 | (진입점 미연결) | DMF0021_SalesPlan.cs:1212 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0c95d338 | (진입점 미연결) | DMF0021_SalesPlan.cs:1220 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-416ccddb | (진입점 미연결) | DMF0021_SalesPlan.cs:1224 | try ▸ if (myarray.Length == 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9fe0b4dc | (진입점 미연결) | DMF0021_SalesPlan.cs:1225 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ecef999 | (진입점 미연결) | DMF0021_SalesPlan.cs:1229 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-65d14061 | (진입점 미연결) | DMF0021_SalesPlan.cs:1271 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.LoadObjectXml | (typeof(FarPoint.Win.Spread.SheetView), FarPoint.Win.Serializer.GetObjectXml(sv, "CopyShee… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ca44dbf | (진입점 미연결) | DMF0021_SalesPlan.cs:1271 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.GetObjectXml | (sv, "CopySheet") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f205ab0 | (진입점 미연결) | DMF0021_SalesPlan.cs:1277 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-6411bded | (진입점 미연결) | DMF0021_SalesPlan.cs:1291 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-f40fb36c | (진입점 미연결) | DMF0021_SalesPlan.cs:1295 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (RemoveActionCell == tr… | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-be643a96 | (진입점 미연결) | DMF0021_SalesPlan.cs:1299 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-985951cd | (진입점 미연결) | DMF0021_SalesPlan.cs:1311 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-12ae4fa5 | (진입점 미연결) | DMF0021_SalesPlan.cs:1312 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-3837e595 | (진입점 미연결) | DMF0021_SalesPlan.cs:1321 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-4884f435 | (진입점 미연결) | DMF0021_SalesPlan.cs:1322 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-312c8a93 | (진입점 미연결) | DMF0021_SalesPlan.cs:1328 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-c39d1f13 | (진입점 미연결) | DMF0021_SalesPlan.cs:1337 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2c8435a5 | (진입점 미연결) | DMF0021_SalesPlan.cs:1339 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9211714 | (진입점 미연결) | DMF0021_SalesPlan.cs:1351 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (ignoreDepth > 0) ▸ for (i < newSheet.RowCount) ▸ for (j < collen) ▸ if (newSheet.Cells… | GRID_SET | newSheet.Cells[i, j].Value | null | 그리드 속성/값 설정 |  |  |  |
| AC-8653db63 | (진입점 미연결) | DMF0021_SalesPlan.cs:1362 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-0415e978 | (진입점 미연결) | DMF0021_SalesPlan.cs:1371 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-10598ce3 | (진입점 미연결) | DMF0021_SalesPlan.cs:1378 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-87c2230c | (진입점 미연결) | DMF0021_SalesPlan.cs:1386 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: ▸ if (newSheet.Fr… | UI_PROP | si.MaxRightMerge | newSheet.FrozenColumnCount | 속성 MaxRightMerge 설정 |  |  |  |
| AC-0b594fce | (진입점 미연결) | DMF0021_SalesPlan.cs:1388 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: | CALL_EXT | si.RightColMerge | (true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f8dcffc | (진입점 미연결) | DMF0021_SalesPlan.cs:1393 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.SeperatedRows: case ExcelExp… | CALL_EXT | si.UnMerge | (newSheet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e09fd56d | (진입점 미연결) | DMF0021_SalesPlan.cs:1401 | try ▸ if (ExcelOptionEx.Border == ExcelBorderOptionEx.All) | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-0c95709d | (진입점 미연결) | DMF0021_SalesPlan.cs:1405 | try ▸ else of (ExcelOptionEx.Border == ExcelBorderOptionEx.All) ▸ if (ExcelOptionEx.Border == ExcelBorderOptionEx.None) | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 0, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-7a484111 | (진입점 미연결) | DMF0021_SalesPlan.cs:1409 | try ▸ else of (ExcelOptionEx.Border == ExcelBorderOptionEx.All) ▸ else of (ExcelOptionEx.Border == ExcelBorderOptionEx.None) ▸ if (ExcelOpti… | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, false, false, true, false) | 속성 Border 설정 |  |  |  |
| AC-26c5db91 | (진입점 미연결) | DMF0021_SalesPlan.cs:1412 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-4bd4be7d | (진입점 미연결) | DMF0021_SalesPlan.cs:1416 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-df795c33 | (진입점 미연결) | DMF0021_SalesPlan.cs:1418 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-78f90726 | (진입점 미연결) | DMF0021_SalesPlan.cs:1421 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-7d366bda | (진입점 미연결) | DMF0021_SalesPlan.cs:1423 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-21d15312 | (진입점 미연결) | DMF0021_SalesPlan.cs:1428 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-f50a2370 | (진입점 미연결) | DMF0021_SalesPlan.cs:1438 | try | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-58571adf | (진입점 미연결) | DMF0021_SalesPlan.cs:1443 | try | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc432b10 | (진입점 미연결) | DMF0021_SalesPlan.cs:1449 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b3e735d | (진입점 미연결) | DMF0021_SalesPlan.cs:1453 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0021_SalesPlan.FindData

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try ▸ if (blnInsert)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0664ebef | FindButton 외 1 | DMF0021_SalesPlan.cs:1468 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ab927fcd | FindButton 외 1 | DMF0021_SalesPlan.cs:1491 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c0b99041 | FindButton 외 1 | DMF0021_SalesPlan.cs:1492 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-525f0c86 | FindButton 외 1 | DMF0021_SalesPlan.cs:1498 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-71a76f04 | FindButton 외 1 | DMF0021_SalesPlan.cs:1500 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(3) | 속성 Value2 설정 |  |  |  |
| AC-3dfd984b | FindButton 외 1 | DMF0021_SalesPlan.cs:1502 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc62e8d2 | FindButton 외 1 | DMF0021_SalesPlan.cs:1506 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae09db6b | FindButton 외 1 | DMF0021_SalesPlan.cs:1508 | try | CALL_EXT | Convert.ToInt32(sEndDate).CompareTo | (Convert.ToInt32(sNowDate)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a11d6ca | FindButton 외 1 | DMF0021_SalesPlan.cs:1530 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5a7d9e16 | FindButton 외 1 | DMF0021_SalesPlan.cs:1531 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a35f7120 | FindButton 외 1 | DMF0021_SalesPlan.cs:1535 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-74f81efa | FindButton 외 1 | DMF0021_SalesPlan.cs:1545 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6109cb81 | FindButton 외 1 | DMF0021_SalesPlan.cs:1547 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6866b335 | FindButton 외 1 | DMF0021_SalesPlan.cs:1552 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx") ⇒ DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx | 엔드포인트 요청 생성 |  |  |  |
| AC-983ba438 | FindButton 외 1 | DMF0021_SalesPlan.cs:1553 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d852c243 | FindButton 외 1 | DMF0021_SalesPlan.cs:1555 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0867268b | FindButton 외 1 | DMF0021_SalesPlan.cs:1556 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-9bc62041 | FindButton 외 1 | DMF0021_SalesPlan.cs:1557 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-68e78ea1 | FindButton 외 1 | DMF0021_SalesPlan.cs:1558 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-9f847020 | FindButton 외 1 | DMF0021_SalesPlan.cs:1559 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-20445b5f | FindButton 외 1 | DMF0021_SalesPlan.cs:1560 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c17b0bef | FindButton 외 1 | DMF0021_SalesPlan.cs:1561 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-ac4c35f3 | FindButton 외 1 | DMF0021_SalesPlan.cs:1562 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-92abaf88 | FindButton 외 1 | DMF0021_SalesPlan.cs:1563 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-80e936ca | FindButton 외 1 | DMF0021_SalesPlan.cs:1564 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-1b9ade43 | FindButton 외 1 | DMF0021_SalesPlan.cs:1565 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-766eb338 | FindButton 외 1 | DMF0021_SalesPlan.cs:1566 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-f354174e | FindButton 외 1 | DMF0021_SalesPlan.cs:1567 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-2fd590e1 | FindButton 외 1 | DMF0021_SalesPlan.cs:1568 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d9d81e2d | FindButton 외 1 | DMF0021_SalesPlan.cs:1569 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-4dffe7a2 | FindButton 외 1 | DMF0021_SalesPlan.cs:1570 | try ▸ lambda | DATA_OP | request.Parameters["p_internal_yn"] | (InternalYN.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-a5c147d0 | FindButton 외 1 | DMF0021_SalesPlan.cs:1571 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-05b28865 | FindButton 외 1 | DMF0021_SalesPlan.cs:1572 | try ▸ lambda | DATA_OP | request.Parameters["p_user_dept_id"] | UserInfoContext.Current["Dept_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-06b547d8 | FindButton 외 1 | DMF0021_SalesPlan.cs:1574 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-90f22be8 | FindButton 외 1 | DMF0021_SalesPlan.cs:1576 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c26f8674 | FindButton 외 1 | DMF0021_SalesPlan.cs:1581 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c1629f2 | FindButton 외 1 | DMF0021_SalesPlan.cs:1587 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0ceb561 | FindButton 외 1 | DMF0021_SalesPlan.cs:1590 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-28c992d9 | FindButton 외 1 | DMF0021_SalesPlan.cs:1591 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (dt) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4bee4e0e | FindButton 외 1 | DMF0021_SalesPlan.cs:1592 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b711c34d | FindButton 외 1 | DMF0021_SalesPlan.cs:1596 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-97dcbfcc | FindButton 외 1 | DMF0021_SalesPlan.cs:1605 | try | FLAG | dsMain | ds | 화면 필드/플래그 변경 |  |  |  |
| AC-c4ff85d9 | FindButton 외 1 | DMF0021_SalesPlan.cs:1612 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (dtSave != null) | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ce1737c6 | FindButton 외 1 | DMF0021_SalesPlan.cs:1616 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13306b9e | FindButton 외 1 | DMF0021_SalesPlan.cs:1621 | try ▸ if (!blnInsert) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iUpdateRow, iUpdateCol) | 그리드 표시 설정 |  |  |  |
| AC-eaf9548c | FindButton 외 1 | DMF0021_SalesPlan.cs:1622 | try ▸ if (!blnInsert) | CALL_EXT | spdMain.ShowActiveCell | (FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Cente… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d95c8dc8 | FindButton 외 1 | DMF0021_SalesPlan.cs:1635 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3435c210 | FindButton 외 1 | DMF0021_SalesPlan.cs:1641 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-64ee4d60 | FindButton 외 1 | DMF0021_SalesPlan.cs:1647 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-04fef331 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:834 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-851a6b66 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:841 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54bd3e9e | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:842 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1782fe1d | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:845 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-296f11f7 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:855 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc0b9f6f | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:856 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-46f7d21a | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:862 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ecba7e79 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:864 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-8e564b39 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:866 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c6b4353 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:870 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d694822 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:872 | try | CALL_EXT | drpPeriod.Value2.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d2331c0d | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:891 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2d428a7e | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:892 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-380b3aa4 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:896 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9c9edc5f | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:906 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-9214c567 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:907 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f7cf0a80 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:912 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx") ⇒ DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx | 엔드포인트 요청 생성 |  |  |  |
| AC-deaf3b61 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:913 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a7ae9536 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:915 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-61210376 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:916 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-ffb63721 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:917 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-4e6ec78b | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:918 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-e0a3da0f | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:919 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-c2b1db13 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:920 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d1114718 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:921 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-ed1f946d | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:922 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-c516659d | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:923 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-21377bb6 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:924 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-697550fe | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:925 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8010feb8 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:926 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d1d3b110 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:927 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-0fab7b11 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:928 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-71a2fd82 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:929 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-5b54bd90 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:930 | try ▸ lambda | DATA_OP | request.Parameters["p_internal_yn"] | (InternalYN.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-301808fa | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:931 | try ▸ lambda | DATA_OP | request.Parameters["p_unit_yn"] | (cboUnitYN.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-b63669bf | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:933 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3976867c | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:935 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e1196e1a | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:940 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4242abb2 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:946 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-79f42190 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:950 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ed38a86d | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:952 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5163c59e | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:953 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-079c2253 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:957 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fdafe6fa | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1037 | try ▸ try ▸ if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.GetMaxRowIndex(), iResultCol, Co… | 그리드 표시 설정 |  |  |  |
| AC-a06a7692 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1039 | try ▸ try ▸ if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-c1cb8781 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1041 | try ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-105ec7e6 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1051 | try ▸ try ▸ for (i <= iTotalRowCount) ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-b39348ff | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1058 | try ▸ catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBoxForException | (e) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-be97bea1 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1062 | try ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4091915a | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1069 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (dtSave != null) | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f80d4c3e | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1073 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6035b7f0 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1078 | try ▸ if (!blnInsert) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iUpdateRow, iUpdateCol) | 그리드 표시 설정 |  |  |  |
| AC-8298e20e | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1079 | try ▸ if (!blnInsert) | CALL_EXT | spdMain.ShowActiveCell | (FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Cente… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f64c3c7 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1092 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6931f01a | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1094 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c1171336 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1098 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-9e76dcd1 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1102 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e34c5180 | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1103 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-be566e0b | FindButton 외 1 | DMF0021_SalesPlan - 복사본.cs:1104 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0021_SalesPlan.fnValidation

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d531b993 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | DMF0021_SalesPlan.cs:4228 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸ … | FLAG | sMeasure | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7f31e51c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | DMF0021_SalesPlan.cs:4312 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-dd39d900 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | DMF0021_SalesPlan.cs:4314 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-54899158 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | DMF0021_SalesPlan - 복사본.cs:2510 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸ … | FLAG | sMeasure | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3010f0d2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | DMF0021_SalesPlan - 복사본.cs:2591 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-a61e1b71 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | DMF0021_SalesPlan - 복사본.cs:2593 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e9282e4 | this.Load | DMF0021_SalesPlan.cs:312 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2c0c6d94 | this.Load | DMF0021_SalesPlan.cs:313 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-de5a49f2 | this.Load | DMF0021_SalesPlan - 복사본.cs:220 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd734933 | this.Load | DMF0021_SalesPlan - 복사본.cs:221 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0021_SalesPlan.GetBizTypebyDivision

진입점: this.Load [else of (sDivision == "40")] / this.clbDivision.SelectedIndexChanged [try ▸ else of (sDivision == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82ff7547 | this.Load [else of (sDivision == "40")] 외 1 | DMF0021_SalesPlan.cs:3483 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-655857a2 | this.Load [else of (sDivision == "40")] 외 1 | DMF0021_SalesPlan.cs:3484 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-acc06d5f | this.Load [else of (sDivision == "40")] 외 1 | DMF0021_SalesPlan.cs:3485 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dcbb3379 | this.Load [else of (sDivision == "40")] 외 1 | DMF0021_SalesPlan.cs:3487 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-ad67a539 | this.Load [else of (sDivision == "40")] 외 1 | DMF0021_SalesPlan - 복사본.cs:1923 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-e8a063bf | this.Load [else of (sDivision == "40")] 외 1 | DMF0021_SalesPlan - 복사본.cs:1924 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3add47cd | this.Load [else of (sDivision == "40")] 외 1 | DMF0021_SalesPlan - 복사본.cs:1925 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ed0c8c63 | this.Load [else of (sDivision == "40")] 외 1 | DMF0021_SalesPlan - 복사본.cs:1927 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetBizTypebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b703e45e | (진입점 미연결) | DMF0021_SalesPlan.cs:5269 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-f2466610 | (진입점 미연결) | DMF0021_SalesPlan.cs:5270 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1ac5af44 | (진입점 미연결) | DMF0021_SalesPlan.cs:5271 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f2cd7455 | (진입점 미연결) | DMF0021_SalesPlan.cs:5274 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-9371c555 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3078 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-07767d1d | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3079 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e718de38 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3080 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3d0c23bf | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3083 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11f7b146 | this.Load | DMF0021_SalesPlan.cs:3430 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DMF0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-2df33f73 | this.Load | DMF0021_SalesPlan.cs:3431 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c6db6e19 | this.Load | DMF0021_SalesPlan.cs:3433 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-c7ababcd | this.Load | DMF0021_SalesPlan - 복사본.cs:1870 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-4b731c7a | this.Load | DMF0021_SalesPlan - 복사본.cs:1871 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5a09be1a | this.Load | DMF0021_SalesPlan - 복사본.cs:1873 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetCellColor

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be9f3d41 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … 외 1 | DMF0021_SalesPlan.cs:4325 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |
| AC-91e84c8d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … 외 1 | DMF0021_SalesPlan - 복사본.cs:2604 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b86da29f | (진입점 미연결) | DMF0021_SalesPlan.cs:3469 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-7569fe4a | (진입점 미연결) | DMF0021_SalesPlan.cs:3470 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b3bfa78d | (진입점 미연결) | DMF0021_SalesPlan.cs:3471 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-708b2913 | (진입점 미연결) | DMF0021_SalesPlan.cs:3472 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cd386a65 | (진입점 미연결) | DMF0021_SalesPlan.cs:3474 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-031570d3 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1909 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-51e50c37 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1910 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8f6deb0b | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1911 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-0bde86f1 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1912 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f89e4494 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1914 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetCustomerbyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad0867a6 | (진입점 미연결) | DMF0021_SalesPlan.cs:5296 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-2532bdc2 | (진입점 미연결) | DMF0021_SalesPlan.cs:5297 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ca32484f | (진입점 미연결) | DMF0021_SalesPlan.cs:5298 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-7cc12c1b | (진입점 미연결) | DMF0021_SalesPlan.cs:5299 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ad8acea5 | (진입점 미연결) | DMF0021_SalesPlan.cs:5302 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-3f56aec5 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3105 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-5cb3069e | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3106 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-0bbf1974 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3107 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-0db20f8b | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3108 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d6d1aef1 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3111 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetCustomsHandbook

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3583ac90 | this.Load | DMF0021_SalesPlan.cs:5546 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-20a3bd6b | this.Load | DMF0021_SalesPlan.cs:5547 |  | DATA_OP | request.Parameters["CODE"] | "DM_CUSTOMS_HANDBOOK" | 행/컬럼 값 대입 |  |  |  |
| AC-0fec53c7 | this.Load | DMF0021_SalesPlan.cs:5548 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-33c79116 | this.Load | DMF0021_SalesPlan.cs:5549 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-85a30efb | this.Load | DMF0021_SalesPlan.cs:5550 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d993ab1 | this.Load | DMF0021_SalesPlan.cs:5551 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ab0d61d5 | this.Load | DMF0021_SalesPlan.cs:5552 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8952d809 | this.Load | DMF0021_SalesPlan.cs:5553 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ac920e7e | this.Load | DMF0021_SalesPlan.cs:5555 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetDataTableMeargeForDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d551fad7 | (진입점 미연결) | DMF0021_SalesPlan.cs:5399 | if (sfpInfo.SpreadObject.DataSource == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-82ef74ce | (진입점 미연결) | DMF0021_SalesPlan.cs:5404 |  | CALL_EXT | sv.GetArray | (0, 0, sv.RowCount - 1, sv.ColumnCount - 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-07f8124d | (진입점 미연결) | DMF0021_SalesPlan.cs:5427 | for (i < sv.ColumnCount) ▸ if (sFieldName.IndexOf("D_2") >= 0 \|\| sFieldName.IndexOf("W_2") >= 0 \|\| sFieldName.IndexOf("M_2") >= 0) | DATA_OP | table.Columns.Add | (sFieldName, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-709eab62 | (진입점 미연결) | DMF0021_SalesPlan.cs:5430 | for (i < sv.ColumnCount) ▸ else of (sFieldName.IndexOf("D_2") >= 0 \|\| sFieldName.IndexOf("W_2") >= 0 \|\| sFieldName.IndexOf("M_2") >= 0) | DATA_OP | table.Columns.Add | (sFieldName, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-853770f6 | (진입점 미연결) | DMF0021_SalesPlan.cs:5433 |  | DATA_OP | ds2.Tables.Add | (table) | 데이터 객체 조작/조회 |  |  |  |
| AC-8800abc4 | (진입점 미연결) | DMF0021_SalesPlan.cs:5437 |  | DATA_OP | ds.Tables[0].Merge | (ds2.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a0291ed | (진입점 미연결) | DMF0021_SalesPlan.cs:5439 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-d34cad4a | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3184 | if (sfpInfo.SpreadObject.DataSource == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fe5c91e | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3189 |  | CALL_EXT | sv.GetArray | (0, 0, sv.RowCount - 1, sv.ColumnCount - 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c09ffe1 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3212 | for (i < sv.ColumnCount) ▸ if (sFieldName.IndexOf("D_2") >= 0 \|\| sFieldName.IndexOf("W_2") >= 0 \|\| sFieldName.IndexOf("M_2") >= 0) | DATA_OP | table.Columns.Add | (sFieldName, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f0d97af | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3215 | for (i < sv.ColumnCount) ▸ else of (sFieldName.IndexOf("D_2") >= 0 \|\| sFieldName.IndexOf("W_2") >= 0 \|\| sFieldName.IndexOf("M_2") >= 0) | DATA_OP | table.Columns.Add | (sFieldName, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5aad58c1 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3218 |  | DATA_OP | ds2.Tables.Add | (table) | 데이터 객체 조작/조회 |  |  |  |
| AC-bcae7f5c | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3222 |  | DATA_OP | ds.Tables[0].Merge | (ds2.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe106cf9 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3224 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a04dcac7 | this.Load | DMF0021_SalesPlan.cs:3410 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-8f8aee42 | this.Load | DMF0021_SalesPlan.cs:3411 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-baa7ff5e | this.Load | DMF0021_SalesPlan.cs:3412 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-42268117 | this.Load | DMF0021_SalesPlan.cs:3414 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-71531283 | this.Load | DMF0021_SalesPlan.cs:3421 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |
| AC-ed120fca | this.Load | DMF0021_SalesPlan - 복사본.cs:1854 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-a3115ce9 | this.Load | DMF0021_SalesPlan - 복사본.cs:1855 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6ee12cb2 | this.Load | DMF0021_SalesPlan - 복사본.cs:1856 |  | DATA_OP | request.Parameters["p_month"] | 7 | 행/컬럼 값 대입 |  |  |  |
| AC-01d49a73 | this.Load | DMF0021_SalesPlan - 복사본.cs:1858 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a91eec73 | this.Load | DMF0021_SalesPlan - 복사본.cs:1861 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-247a584b | (진입점 미연결) | DMF0021_SalesPlan.cs:3380 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-3750ea70 | (진입점 미연결) | DMF0021_SalesPlan.cs:3382 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-575d90b5 | (진입점 미연결) | DMF0021_SalesPlan.cs:3385 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-e849f1ac | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1824 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-47b3b82e | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1826 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-96b00d54 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1829 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86acb419 | (진입점 미연결) | DMF0021_SalesPlan.cs:3496 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-9b329ad7 | (진입점 미연결) | DMF0021_SalesPlan.cs:3497 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-dedad391 | (진입점 미연결) | DMF0021_SalesPlan.cs:3498 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-55df27a2 | (진입점 미연결) | DMF0021_SalesPlan.cs:3499 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc946dbf | (진입점 미연결) | DMF0021_SalesPlan.cs:3501 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-7183bbaa | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1936 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-22a55986 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1937 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-93be5a83 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1938 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-d66a6465 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1939 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5cc2d266 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1941 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetFcstType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c602175c | this.Load | DMF0021_SalesPlan.cs:5585 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-6f6a3319 | this.Load | DMF0021_SalesPlan.cs:5586 |  | DATA_OP | request.Parameters["CODE"] | "FCST_TYPE" | 행/컬럼 값 대입 |  |  |  |
| AC-77e28fb3 | this.Load | DMF0021_SalesPlan.cs:5587 |  | DATA_OP | request.Parameters["PARAM1"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b31ac006 | this.Load | DMF0021_SalesPlan.cs:5588 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-89ce503d | this.Load | DMF0021_SalesPlan.cs:5589 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-65c8e21b | this.Load | DMF0021_SalesPlan.cs:5590 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4930e6be | this.Load | DMF0021_SalesPlan.cs:5591 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-28ca052d | this.Load | DMF0021_SalesPlan.cs:5592 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-15b4a26d | this.Load | DMF0021_SalesPlan.cs:5595 |  | DATA_OP | dt.Select(@" CODE <> 'ETC' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a52a4081 | this.Load | DMF0021_SalesPlan.cs:5595 |  | DATA_OP | dt.Select | (@" CODE <> 'ETC' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae63f30f | this.Load | DMF0021_SalesPlan.cs:5595 |  | RETURN | return dt.Select(@" CODE <> 'ETC' ").CopyToDataTable<DataRow>(); |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetIncotermsType

진입점: this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DEPT_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnInd…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfba1992 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0021_SalesPlan.cs:5566 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-ff48f9d9 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0021_SalesPlan.cs:5567 |  | DATA_OP | request.Parameters["CODE"] | "AS_INCOTERMS" | 행/컬럼 값 대입 |  |  |  |
| AC-9129170c | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0021_SalesPlan.cs:5568 |  | DATA_OP | request.Parameters["PARAM1"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-9de6279a | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0021_SalesPlan.cs:5569 |  | DATA_OP | request.Parameters["PARAM2"] | sScmSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-098a22ba | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0021_SalesPlan.cs:5570 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-85888035 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0021_SalesPlan.cs:5571 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d19deda1 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0021_SalesPlan.cs:5572 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-57cbb2ff | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0021_SalesPlan.cs:5573 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8001a137 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0021_SalesPlan.cs:5575 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetItemType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e05bcdf6 | this.Load | DMF0021_SalesPlan.cs:3442 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-4e31349b | this.Load | DMF0021_SalesPlan.cs:3443 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-00339543 | this.Load | DMF0021_SalesPlan.cs:3444 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-72eca158 | this.Load | DMF0021_SalesPlan.cs:3446 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-5d89a6c0 | this.Load | DMF0021_SalesPlan - 복사본.cs:1882 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-a8ceea44 | this.Load | DMF0021_SalesPlan - 복사본.cs:1883 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-f957b806 | this.Load | DMF0021_SalesPlan - 복사본.cs:1884 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5d5f75e0 | this.Load | DMF0021_SalesPlan - 복사본.cs:1886 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetLookupValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe1d18ef | (진입점 미연결) | DMF0021_SalesPlan.cs:5604 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-aed6f2ca | (진입점 미연결) | DMF0021_SalesPlan.cs:5605 |  | DATA_OP | request.Parameters["CODE"] | p_code | 행/컬럼 값 대입 |  |  |  |
| AC-5611ab39 | (진입점 미연결) | DMF0021_SalesPlan.cs:5606 |  | DATA_OP | request.Parameters["PARAM1"] | p_param1 | 행/컬럼 값 대입 |  |  |  |
| AC-f032dd49 | (진입점 미연결) | DMF0021_SalesPlan.cs:5607 |  | DATA_OP | request.Parameters["PARAM2"] | p_param2 | 행/컬럼 값 대입 |  |  |  |
| AC-34b3c6b8 | (진입점 미연결) | DMF0021_SalesPlan.cs:5608 |  | DATA_OP | request.Parameters["PARAM3"] | p_param3 | 행/컬럼 값 대입 |  |  |  |
| AC-916cd1a2 | (진입점 미연결) | DMF0021_SalesPlan.cs:5609 |  | DATA_OP | request.Parameters["PARAM4"] | p_param4 | 행/컬럼 값 대입 |  |  |  |
| AC-3ca84ceb | (진입점 미연결) | DMF0021_SalesPlan.cs:5610 |  | DATA_OP | request.Parameters["PARAM5"] | p_param5 | 행/컬럼 값 대입 |  |  |  |
| AC-75d1b2e1 | (진입점 미연결) | DMF0021_SalesPlan.cs:5611 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-92802391 | (진입점 미연결) | DMF0021_SalesPlan.cs:5613 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetPlantSitebyEndCustomer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d367305b | (진입점 미연결) | DMF0021_SalesPlan.cs:4499 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-5a70465a | (진입점 미연결) | DMF0021_SalesPlan.cs:4500 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b35b9415 | (진입점 미연결) | DMF0021_SalesPlan.cs:4501 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-2386bc58 | (진입점 미연결) | DMF0021_SalesPlan.cs:4502 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-bf4c52db | (진입점 미연결) | DMF0021_SalesPlan.cs:4503 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ca7aa120 | (진입점 미연결) | DMF0021_SalesPlan.cs:4506 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-e1ad955a | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2706 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-5a175486 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2707 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c987dc22 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2708 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-f13eacfd | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2709 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-123e1045 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2710 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d31cedfa | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2713 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetPlantSitebyEndCustomerAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c1eb304 | (진입점 미연결) | DMF0021_SalesPlan.cs:5311 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-18c8efdd | (진입점 미연결) | DMF0021_SalesPlan.cs:5312 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-efdde1e3 | (진입점 미연결) | DMF0021_SalesPlan.cs:5313 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-e9296a30 | (진입점 미연결) | DMF0021_SalesPlan.cs:5314 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-fe4977d4 | (진입점 미연결) | DMF0021_SalesPlan.cs:5315 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-42743549 | (진입점 미연결) | DMF0021_SalesPlan.cs:5318 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-222ed761 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3120 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-2f9d1b2e | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3121 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-602aea8e | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3122 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-267bdf90 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3123 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-4f70f655 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3124 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1cda8797 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3127 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetSALESPLAN_MEASUREInfo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc624259 | this.Load | DMF0021_SalesPlan.cs:3510 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0021_GET_SALES_PLAN_MEASUREINFO") ⇒ DM.DMF0021_GET_SALES_PLAN_MEASUREINFO | 엔드포인트 요청 생성 |  |  |  |
| AC-2e30dc2b | this.Load | DMF0021_SalesPlan.cs:3511 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2c0590a1 | this.Load | DMF0021_SalesPlan.cs:3513 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-783e30a4 | this.Load | DMF0021_SalesPlan - 복사본.cs:1950 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0021_GET_SALES_PLAN_MEASUREINFO") ⇒ DM.DMF0021_GET_SALES_PLAN_MEASUREINFO | 엔드포인트 요청 생성 |  |  |  |
| AC-d1024c48 | this.Load | DMF0021_SalesPlan - 복사본.cs:1951 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7bd533d9 | this.Load | DMF0021_SalesPlan - 복사본.cs:1953 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetSALESPLAN_MEASUREInfo2

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8635132b | this.Load | DMF0021_SalesPlan.cs:3523 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0021_GET_SALES_PLAN_MEASUREINFO2") ⇒ DM.DMF0021_GET_SALES_PLAN_MEASUREINFO2 | 엔드포인트 요청 생성 |  |  |  |
| AC-f30306ac | this.Load | DMF0021_SalesPlan.cs:3524 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0f663548 | this.Load | DMF0021_SalesPlan.cs:3526 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-1a9d1d06 | this.Load | DMF0021_SalesPlan - 복사본.cs:1963 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0021_GET_SALES_PLAN_MEASUREINFO2") ⇒ DM.DMF0021_GET_SALES_PLAN_MEASUREINFO2 | 엔드포인트 요청 생성 |  |  |  |
| AC-c7efbf5d | this.Load | DMF0021_SalesPlan - 복사본.cs:1964 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b642217b | this.Load | DMF0021_SalesPlan - 복사본.cs:1966 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetScmSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab17f901 | (진입점 미연결) | DMF0021_SalesPlan.cs:3394 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-0618349d | (진입점 미연결) | DMF0021_SalesPlan.cs:3395 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3d30f82c | (진입점 미연결) | DMF0021_SalesPlan.cs:3396 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-a4ecb3dc | (진입점 미연결) | DMF0021_SalesPlan.cs:3397 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-635a6410 | (진입점 미연결) | DMF0021_SalesPlan.cs:3398 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b8939eb4 | (진입점 미연결) | DMF0021_SalesPlan.cs:3401 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-dc644666 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1838 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-4a9f70ae | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1839 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3c301d3e | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1840 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-023169e1 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1841 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-74d32217 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1842 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-47a73008 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1845 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetScmSitebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e286354d | (진입점 미연결) | DMF0021_SalesPlan.cs:5327 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-aa80343d | (진입점 미연결) | DMF0021_SalesPlan.cs:5328 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-008e6a18 | (진입점 미연결) | DMF0021_SalesPlan.cs:5329 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-d3033c01 | (진입점 미연결) | DMF0021_SalesPlan.cs:5330 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-0f601df0 | (진입점 미연결) | DMF0021_SalesPlan.cs:5331 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-016d44f8 | (진입점 미연결) | DMF0021_SalesPlan.cs:5334 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-af1897ec | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3136 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-6852db66 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3137 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d58351ef | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3138 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-f0d94c3c | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3139 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-20b2fbd7 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3140 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8d66d001 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3143 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ try ▸ else of (dtSta…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e92c3a7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:649 |  | FLAG | fBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-654deb4c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:654 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0021_GET_SPREAD_TITLE") ⇒ DM.DMF0021_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-0aa1b64f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:655 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-d153a09c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:656 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-7f913706 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:657 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-791d6d0c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:658 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-42c89c10 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:659 |  | DATA_OP | request.Parameters["p_bucket"] | fBucket | 행/컬럼 값 대입 |  |  |  |
| AC-bb40f05a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:661 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-e069b773 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:661 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-95a0362a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:664 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |
| AC-16cf9e7d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:563 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0021_GET_SPREAD_TITLE") ⇒ DM.DMF0021_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-6ad0297b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:564 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-ae7208e8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:565 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-5891f061 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:566 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8d996b42 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:567 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-1126b5d9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:569 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-645cea81 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:569 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5229f9de | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:572 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a5722e8 | (진입점 미연결) | DMF0021_SalesPlan.cs:3456 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-7b61a679 | (진입점 미연결) | DMF0021_SalesPlan.cs:3457 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-fb62508e | (진입점 미연결) | DMF0021_SalesPlan.cs:3458 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4e2135e8 | (진입점 미연결) | DMF0021_SalesPlan.cs:3460 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-793d5fb5 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1896 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-bf725b3e | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1897 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-5123737f | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1898 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7c9d74a7 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1900 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetTeambyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a18f42d | (진입점 미연결) | DMF0021_SalesPlan.cs:5283 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-802c4511 | (진입점 미연결) | DMF0021_SalesPlan.cs:5284 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-4853f98e | (진입점 미연결) | DMF0021_SalesPlan.cs:5285 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-35342576 | (진입점 미연결) | DMF0021_SalesPlan.cs:5287 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-e176411b | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3092 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-51b54a81 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3093 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-20491bd7 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3094 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-337a7512 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:3096 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.GetThisWeekMonday

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetText(i, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)] / FindButton [try] / InsertButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / EditButton [if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sSALES_PLAN_ADJUST_YN == "N_Y") ▸ if (siMain.GetTex…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81478ccb | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0021_SalesPlan.cs:4527 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |
| AC-3891dd95 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 4 | DMF0021_SalesPlan - 복사본.cs:2734 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0021_SalesPlan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abdb0f42 | this.Load | DMF0021_SalesPlan.cs:431 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b8106e61 | this.Load | DMF0021_SalesPlan.cs:439 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1c10c643 | this.Load | DMF0021_SalesPlan.cs:452 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0cfe84c3 | this.Load | DMF0021_SalesPlan.cs:461 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5288a1b6 | this.Load | DMF0021_SalesPlan.cs:462 | if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bbbba1bf | this.Load | DMF0021_SalesPlan.cs:463 | if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d654b91d | this.Load | DMF0021_SalesPlan.cs:465 | if (sDivision == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f253023f | this.Load | DMF0021_SalesPlan.cs:466 | if (sDivision == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-8ff68ff9 | this.Load | DMF0021_SalesPlan.cs:474 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e9c898a9 | this.Load | DMF0021_SalesPlan.cs:483 | else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8aed68aa | this.Load | DMF0021_SalesPlan.cs:484 | else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e4fe3b89 | this.Load | DMF0021_SalesPlan.cs:485 | else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-15990c4b | this.Load | DMF0021_SalesPlan.cs:491 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-aea0817b | this.Load | DMF0021_SalesPlan.cs:492 |  | VALUE_SET | chkColor.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-ba3bd510 | this.Load | DMF0021_SalesPlan.cs:493 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-a60a22e7 | this.Load | DMF0021_SalesPlan.cs:495 |  | UI_PROP | layoutControlItem10.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-51e9a500 | this.Load | DMF0021_SalesPlan.cs:497 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a42b3d14 | this.Load | DMF0021_SalesPlan.cs:504 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-73e8e952 | this.Load | DMF0021_SalesPlan.cs:511 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fb0f4bb8 | this.Load | DMF0021_SalesPlan.cs:514 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-b7c64227 | this.Load | DMF0021_SalesPlan.cs:515 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9ee6c910 | this.Load | DMF0021_SalesPlan.cs:517 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-228d88b2 | this.Load | DMF0021_SalesPlan.cs:519 |  | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-b878cd5a | this.Load | DMF0021_SalesPlan.cs:520 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-94238a8a | this.Load | DMF0021_SalesPlan.cs:525 |  | FLAG | dtITEM_ID | Data.Common(Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], Us… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-769b9268 | this.Load | DMF0021_SalesPlan.cs:525 |  | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f3d0a899 | this.Load | DMF0021_SalesPlan.cs:528 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-96bb42f9 | this.Load | DMF0021_SalesPlan.cs:528 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b5e1040 | this.Load | DMF0021_SalesPlan.cs:531 |  | FLAG | dtMearsure | GetSALESPLAN_MEASUREInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-477ddf84 | this.Load | DMF0021_SalesPlan.cs:535 |  | FLAG | dtCustomsHandbook | GetCustomsHandbook() | 화면 필드/플래그 변경 |  |  |  |
| AC-e9459e1a | this.Load | DMF0021_SalesPlan.cs:536 |  | FLAG | dtFcstType | GetFcstType() | 화면 필드/플래그 변경 |  |  |  |
| AC-f3c007cd | this.Load | DMF0021_SalesPlan - 복사본.cs:239 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-87090a9b | this.Load | DMF0021_SalesPlan - 복사본.cs:239 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf8d0419 | this.Load | DMF0021_SalesPlan - 복사본.cs:240 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d0193068 | this.Load | DMF0021_SalesPlan - 복사본.cs:243 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-dddbf150 | this.Load | DMF0021_SalesPlan - 복사본.cs:243 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9268a12e | this.Load | DMF0021_SalesPlan - 복사본.cs:244 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9013f2cb | this.Load | DMF0021_SalesPlan - 복사본.cs:252 | if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-1a39cbf4 | this.Load | DMF0021_SalesPlan - 복사본.cs:252 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1fe751ab | this.Load | DMF0021_SalesPlan - 복사본.cs:253 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bae1161e | this.Load | DMF0021_SalesPlan - 복사본.cs:255 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-c0837378 | this.Load | DMF0021_SalesPlan - 복사본.cs:255 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1601ae06 | this.Load | DMF0021_SalesPlan - 복사본.cs:257 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5c793f4f | this.Load | DMF0021_SalesPlan - 복사본.cs:258 | if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-291c5ea0 | this.Load | DMF0021_SalesPlan - 복사본.cs:259 | if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2e15ce35 | this.Load | DMF0021_SalesPlan - 복사본.cs:260 | if (sDivision == "40") | STATE | cboUnitYN.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-95025054 | this.Load | DMF0021_SalesPlan - 복사본.cs:262 | if (sDivision == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-ad40a9ed | this.Load | DMF0021_SalesPlan - 복사본.cs:263 | if (sDivision == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-2aada801 | this.Load | DMF0021_SalesPlan - 복사본.cs:267 | else of (sDivision == "40") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-8651cb05 | this.Load | DMF0021_SalesPlan - 복사본.cs:268 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b44908ac | this.Load | DMF0021_SalesPlan - 복사본.cs:270 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ede8564b | this.Load | DMF0021_SalesPlan - 복사본.cs:270 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c1f498e6 | this.Load | DMF0021_SalesPlan - 복사본.cs:272 | else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-df9ffe59 | this.Load | DMF0021_SalesPlan - 복사본.cs:273 | else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4a1897c2 | this.Load | DMF0021_SalesPlan - 복사본.cs:274 | else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8793273e | this.Load | DMF0021_SalesPlan - 복사본.cs:275 | else of (sDivision == "40") | STATE | cboUnitYN.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c2a51b46 | this.Load | DMF0021_SalesPlan - 복사본.cs:282 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-644272da | this.Load | DMF0021_SalesPlan - 복사본.cs:284 |  | UI_PROP | layoutControlItem10.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9781615e | this.Load | DMF0021_SalesPlan - 복사본.cs:286 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b2861e81 | this.Load | DMF0021_SalesPlan - 복사본.cs:289 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-16cd7563 | this.Load | DMF0021_SalesPlan - 복사본.cs:289 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-46ff9852 | this.Load | DMF0021_SalesPlan - 복사본.cs:290 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8d96ee15 | this.Load | DMF0021_SalesPlan - 복사본.cs:292 |  | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-539b607f | this.Load | DMF0021_SalesPlan - 복사본.cs:292 |  | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4502beae | this.Load | DMF0021_SalesPlan - 복사본.cs:293 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-56e36485 | this.Load | DMF0021_SalesPlan - 복사본.cs:295 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-57bbd8f5 | this.Load | DMF0021_SalesPlan - 복사본.cs:296 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-dea85a62 | this.Load | DMF0021_SalesPlan - 복사본.cs:298 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-0d8a5938 | this.Load | DMF0021_SalesPlan - 복사본.cs:300 |  | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-4dcd11fa | this.Load | DMF0021_SalesPlan - 복사본.cs:301 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-20ed8a64 | this.Load | DMF0021_SalesPlan - 복사본.cs:306 |  | FLAG | dtITEM_ID | Data.Common(Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], Us… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-eb0b4aab | this.Load | DMF0021_SalesPlan - 복사본.cs:306 |  | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7268eed8 | this.Load | DMF0021_SalesPlan - 복사본.cs:309 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-d78e14b4 | this.Load | DMF0021_SalesPlan - 복사본.cs:309 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e195d9a4 | this.Load | DMF0021_SalesPlan - 복사본.cs:312 |  | FLAG | dtMearsure | GetSALESPLAN_MEASUREInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-e7f7dafb | this.Load | DMF0021_SalesPlan - 복사본.cs:313 |  | FLAG | dtMearsure2 | GetSALESPLAN_MEASUREInfo2() | 화면 필드/플래그 변경 |  |  |  |

## DMF0021_SalesPlan.InitSaveDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d171abb | (진입점 미연결) | DMF0021_SalesPlan.cs:4129 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-e427c265 | (진입점 미연결) | DMF0021_SalesPlan.cs:4130 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8f2cc32 | (진입점 미연결) | DMF0021_SalesPlan.cs:4131 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PROJECT_CODE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-75683bd4 | (진입점 미연결) | DMF0021_SalesPlan.cs:4132 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.SCM_SITE_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f26147c7 | (진입점 미연결) | DMF0021_SalesPlan.cs:4133 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ITEM_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-83865e34 | (진입점 미연결) | DMF0021_SalesPlan.cs:4134 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.TEXT, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-90d43997 | (진입점 미연결) | DMF0021_SalesPlan.cs:4135 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DomExp, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-db78b8aa | (진입점 미연결) | DMF0021_SalesPlan.cs:4136 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.INCOTERMS, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea410e40 | (진입점 미연결) | DMF0021_SalesPlan.cs:4137 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1905a1b7 | (진입점 미연결) | DMF0021_SalesPlan.cs:4138 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.MEASURE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f48a1729 | (진입점 미연결) | DMF0021_SalesPlan.cs:4139 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9686818 | (진입점 미연결) | DMF0021_SalesPlan.cs:4140 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Qty, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-550ad295 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2416 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-1b237029 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2417 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc640e43 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2418 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PROJECT_CODE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2a75a8b | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2419 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.SCM_SITE_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c91e848 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2420 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ITEM_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3817a048 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2421 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DomExp, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-284c3310 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2422 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.INCOTERMS, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d4c0784 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2423 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6056566c | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2424 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.MEASURE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-db6e1808 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2425 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7da14fb5 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2426 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Qty, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0021_SalesPlan.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily)] / this.Load / this.clbDivision.SelectedIndexChanged [try] / FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try ▸ if (blnInsert) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9354965 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:599 | try ▸ if (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6712e23 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:603 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-b6172d4b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:604 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-1a3c826d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:609 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-f842a40b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:619 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-675d8252 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:396 | try ▸ if (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-808f61cd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:402 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-99f9acf5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:403 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-0abb92cc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:408 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-b25f048d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:418 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## DMF0021_SalesPlan.InitSpread_X

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de4bd53e | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:427 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.MEASURE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cdd6114c | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:433 |  | DATA_OP | nvc["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-c76d9689 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:434 |  | DATA_OP | nvc["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-82b4192c | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:435 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1ca18362 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:437 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM_H.DM0021_GET_SPREAD_TITLE_DATE", nvc) ⇒ DM_H.DM0021_GET_SPREAD_TITLE_DATE | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-edb5dcae | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:437 |  | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0021_GET_SPREAD_TITLE_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-b5671952 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:458 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.AddNumColumn | ("M_" + sFYear, "M_" + sFYear, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0db7905a | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:460 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iFCow, 2, 1, 25, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7dc65f36 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:470 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.AddNumColumn | ("SUM", "W_" + sFWeek, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-246783fc | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:481 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFCow, 1, iLCow - 1, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77c169b9 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:486 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.AddNumColumn | ("M_" + sFYear, "M_" + sFYear, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e64b4b9 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:488 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iFCow, 2, 1, 25, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7fad6542 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:496 | for (i < dt.Rows.Count) ▸ if (sFWeek != dt.Rows[i]["COL_WEEK_NAME"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iWeekFRow, 1, iWeekLRow - 1, 25, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dd51a2fb | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:501 | for (i < dt.Rows.Count) ▸ if (sFWeek != dt.Rows[i]["COL_WEEK_NAME"].ToString()) | GRID_INIT | siMain.AddNumColumn | ("SUM", "W_" + sFWeek, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a512f28 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:509 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["CALENDAR_DAY"].ToString(), dt.Rows[i]["BASIS_YYYYMMDD"].ToString(), FPMerge.N… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fc574d89 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:511 | for (i < dt.Rows.Count) ▸ if (dt.Rows[i]["DAYOFWEEK"].ToString() == "SAT") | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, siMain.GetColumnIndex(dt.Rows[i]["BASIS_YYYYMMDD"… | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-cd09f1f5 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:513 | for (i < dt.Rows.Count) ▸ else of (dt.Rows[i]["DAYOFWEEK"].ToString() == "SAT") ▸ if (dt.Rows[i]["DAYOFWEEK"].ToString() == "SUN") | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, siMain.GetColumnIndex(dt.Rows[i]["BASIS_YYYYMMDD"… | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-877a8529 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:518 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFCow, 1, iLCow, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-665512ad | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:525 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iWeekFRow, 1, iWeekLRow, 25, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d08a017b | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:533 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0021_SalesPlan.InitSpreadFooterSum

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ try ▸ else of (dtSta…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e99ac226 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0021_SalesPlan.cs:630 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-0165cd5a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0021_SalesPlan.cs:631 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-a868045b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0021_SalesPlan.cs:638 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a581a07e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0021_SalesPlan.cs:639 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-879f8f32 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0021_SalesPlan.cs:640 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-3790b8bf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0021_SalesPlan.cs:641 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-baefb160 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0021_SalesPlan - 복사본.cs:540 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-cad6f563 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0021_SalesPlan - 복사본.cs:541 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-b7021c6d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0021_SalesPlan - 복사본.cs:548 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2132543f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0021_SalesPlan - 복사본.cs:549 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1981adb5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0021_SalesPlan - 복사본.cs:550 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-6a09111f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0021_SalesPlan - 복사본.cs:551 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0021_SalesPlan.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cf8ddb2 | InsertButton | DMF0021_SalesPlan.cs:2882 | try ▸ if (dsMain != null && dsMain.Tables.Count >= 3) | DATA_OP | dsMain.Tables[2].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-413da8b8 | InsertButton | DMF0021_SalesPlan.cs:2883 | try ▸ if (dsMain != null && dsMain.Tables.Count >= 3) | DATA_OP | dt.Columns.Contains | ("EDIT_AUTH_SalesAmt_LOC") | 데이터 객체 조작/조회 |  |  |  |
| AC-271fff1c | InsertButton | DMF0021_SalesPlan.cs:2891 | try ▸ if (!bEDIT_AUTH_SalesAmt_LOC) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ec8d66d | InsertButton | DMF0021_SalesPlan.cs:2899 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-82c8e87b | InsertButton | DMF0021_SalesPlan.cs:2902 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-38f911c7 | InsertButton | DMF0021_SalesPlan.cs:2910 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cfe69e7c | InsertButton | DMF0021_SalesPlan.cs:2911 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b172beb | InsertButton | DMF0021_SalesPlan.cs:2916 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_SET | siMain.SetText | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-91c74b40 | InsertButton | DMF0021_SalesPlan.cs:2917 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e2178cc6 | InsertButton | DMF0021_SalesPlan.cs:2920 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-44a11ff7 | InsertButton | DMF0021_SalesPlan.cs:2925 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40" &&… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8a91c8d5 | InsertButton | DMF0021_SalesPlan.cs:2930 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "4… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), siMain.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-93ef5031 | InsertButton | DMF0021_SalesPlan.cs:2946 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | FLAG | dtCellProdSiteID | Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-c4caa3ea | InsertButton | DMF0021_SalesPlan.cs:2946 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | COMBO_DATA | Data.Common | (Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ae80e33b | InsertButton | DMF0021_SalesPlan.cs:2947 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSit… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-36a5563a | InsertButton | DMF0021_SalesPlan.cs:2952 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-045e16bb | InsertButton | DMF0021_SalesPlan.cs:2954 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-dfc3382d | InsertButton | DMF0021_SalesPlan.cs:2960 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.MEASURE), dtMearsure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a8b14853 | InsertButton | DMF0021_SalesPlan.cs:2961 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.MEASURE), "SalesAmt_LOC") | 그리드 값 설정 |  |  |  |
| AC-1e2c8fc1 | InsertButton | DMF0021_SalesPlan.cs:2970 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-d10cc225 | InsertButton | DMF0021_SalesPlan.cs:2975 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-3e309c98 | InsertButton | DMF0021_SalesPlan.cs:2979 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FcstType), "ETC") | 그리드 값 설정 |  |  |  |
| AC-bb640613 | InsertButton | DMF0021_SalesPlan.cs:2980 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FcstType), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5f8709a2 | InsertButton | DMF0021_SalesPlan.cs:2985 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TEAM_INCHARGE), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f0649d71 | InsertButton | DMF0021_SalesPlan.cs:2987 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a2d76f92 | InsertButton | DMF0021_SalesPlan.cs:2989 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectStatus), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-39c8a4f1 | InsertButton | DMF0021_SalesPlan.cs:2991 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-79c591cc | InsertButton | DMF0021_SalesPlan.cs:2994 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BizTypeName), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-38cc27f4 | InsertButton | DMF0021_SalesPlan.cs:2998 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-58ad59e9 | InsertButton | DMF0021_SalesPlan.cs:3000 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_NAME), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-50fc9d13 | InsertButton | DMF0021_SalesPlan.cs:3003 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemType), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-857c90d7 | InsertButton | DMF0021_SalesPlan.cs:3007 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_COMPANY), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-36f5d09d | InsertButton | DMF0021_SalesPlan.cs:3009 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLANT), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-17e8bb41 | InsertButton | DMF0021_SalesPlan.cs:3012 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NickName), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-22a4a98a | InsertButton | DMF0021_SalesPlan.cs:3015 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.KwhCell), siMain.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-38bff536 | InsertButton | DMF0021_SalesPlan.cs:3018 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.KwhModule), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6fd41c44 | InsertButton | DMF0021_SalesPlan.cs:3021 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.KwhPack), siMain.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-651bcf19 | InsertButton | DMF0021_SalesPlan.cs:3024 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5c1da43b | InsertButton | DMF0021_SalesPlan.cs:3030 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DomExp), siMain.ActiveRowIndex, s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b2f045cc | InsertButton | DMF0021_SalesPlan.cs:3035 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8a7e9cba | InsertButton | DMF0021_SalesPlan.cs:3038 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN), siMain.Act… | 그리드 편집 잠금/해제 |  |  |  |
| AC-570caee0 | InsertButton | DMF0021_SalesPlan.cs:3040 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INCOTERMS), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cde1eb0e | InsertButton | DMF0021_SalesPlan.cs:3045 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OWNER), siMain.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7cfaad40 | InsertButton | DMF0021_SalesPlan.cs:3048 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.COUNTRY_NAME), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b64558d6 | InsertButton | DMF0021_SalesPlan.cs:3050 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CITY_NAME), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a4b75b00 | InsertButton | DMF0021_SalesPlan.cs:3052 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP), siM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-03890cb9 | InsertButton | DMF0021_SalesPlan.cs:3054 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VMI_YN), siMain.ActiveRowIndex, s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-29536d74 | InsertButton | DMF0021_SalesPlan.cs:3058 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectName), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9d2cb86d | InsertButton | DMF0021_SalesPlan.cs:3060 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DistributionChannel), siMain.Acti… | 그리드 편집 잠금/해제 |  |  |  |
| AC-61e8fa95 | InsertButton | DMF0021_SalesPlan.cs:3062 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CellName), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ba3c8553 | InsertButton | DMF0021_SalesPlan.cs:3064 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ShipmentSite), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c79d192a | InsertButton | DMF0021_SalesPlan.cs:3076 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-19589706 | InsertButton | DMF0021_SalesPlan.cs:3080 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CUST_GROUP), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7db6b502 | InsertButton | DMF0021_SalesPlan.cs:3084 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), siMain.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-92ad3f7d | InsertButton | DMF0021_SalesPlan.cs:3088 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.APPLICATION), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c656104 | InsertButton | DMF0021_SalesPlan.cs:3092 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ROUTE), siMain.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ecaf39a6 | InsertButton | DMF0021_SalesPlan.cs:3096 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME40), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ba03d466 | InsertButton | DMF0021_SalesPlan.cs:3100 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.GROUP_ID), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-319d0a5e | InsertButton | DMF0021_SalesPlan.cs:3104 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INTERNAL_YN), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c6e81f9f | InsertButton | DMF0021_SalesPlan.cs:3108 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_TYPE), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-84d4cb4c | InsertButton | DMF0021_SalesPlan.cs:3112 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT), s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-73fbcc28 | InsertButton | DMF0021_SalesPlan.cs:3116 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_MODEL_INFO), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2acdfe72 | InsertButton | DMF0021_SalesPlan.cs:3120 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_MODEL), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-02ad648c | InsertButton | DMF0021_SalesPlan.cs:3124 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_ALL), siMain.Active… | 그리드 편집 잠금/해제 |  |  |  |
| AC-20aaad6c | InsertButton | DMF0021_SalesPlan.cs:3128 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), siMain.Activ… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bb34cfa8 | InsertButton | DMF0021_SalesPlan.cs:3132 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFOR_VERSION), siMain.A… | 그리드 편집 잠금/해제 |  |  |  |
| AC-53e79eca | InsertButton | DMF0021_SalesPlan.cs:3136 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_MODEL_NICK_NAME), siMain.Act… | 그리드 편집 잠금/해제 |  |  |  |
| AC-847a3861 | InsertButton | DMF0021_SalesPlan.cs:3140 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), siMain.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a5b21cf6 | InsertButton | DMF0021_SalesPlan.cs:3144 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-63b9e62a | InsertButton | DMF0021_SalesPlan.cs:3148 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f67c780b | InsertButton | DMF0021_SalesPlan.cs:3152 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3a770f6d | InsertButton | DMF0021_SalesPlan.cs:3156 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), siMain.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-aa5f3d47 | InsertButton | DMF0021_SalesPlan.cs:3160 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ENERGE), siMain.ActiveRowIndex, s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee96f299 | InsertButton | DMF0021_SalesPlan.cs:3164 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ENERGE_WH), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-61b2ad8b | InsertButton | DMF0021_SalesPlan.cs:3168 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_QUANTITY), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-21caa794 | InsertButton | DMF0021_SalesPlan.cs:3172 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DMS_SALES), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7da79f59 | InsertButton | DMF0021_SalesPlan.cs:3176 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-01300fc6 | InsertButton | DMF0021_SalesPlan.cs:3184 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCP_USE_YN), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3570fa90 | InsertButton | DMF0021_SalesPlan.cs:3190 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FromSiteId), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-65d05784 | InsertButton | DMF0021_SalesPlan.cs:3275 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (i_EditStartCol > 0 &… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d8973166 | InsertButton | DMF0021_SalesPlan.cs:3280 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (i_EditStartCol > 0 &… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-77654472 | InsertButton | DMF0021_SalesPlan.cs:3285 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (i_EditStartCol > 0 &… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9454ea7c | InsertButton | DMF0021_SalesPlan.cs:3292 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (i_EditStartCol … | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-10098cac | InsertButton | DMF0021_SalesPlan.cs:3298 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (i_EditStartCol … | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9aadd7fc | InsertButton | DMF0021_SalesPlan.cs:3301 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (i_EditStartCol … | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ccb16024 | InsertButton | DMF0021_SalesPlan.cs:3306 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (i_EditStartCol … | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-adeabcc0 | InsertButton | DMF0021_SalesPlan.cs:3315 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxC… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-04f1ee84 | InsertButton | DMF0021_SalesPlan.cs:3324 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxC… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d043c59d | InsertButton | DMF0021_SalesPlan.cs:3333 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxC… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f94e1e4f | InsertButton | DMF0021_SalesPlan.cs:3346 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUB… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-12afbe4b | InsertButton | DMF0021_SalesPlan.cs:3346 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-61a9e415 | InsertButton | DMF0021_SalesPlan.cs:3346 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '82' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-28faca00 | InsertButton | DMF0021_SalesPlan.cs:3348 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUB… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-63dfd34b | InsertButton | DMF0021_SalesPlan.cs:3348 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-14ea695e | InsertButton | DMF0021_SalesPlan.cs:3348 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '81' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-c2e53d37 | InsertButton | DMF0021_SalesPlan.cs:3351 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUB… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-84b49547 | InsertButton | DMF0021_SalesPlan.cs:3351 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f0bb6a9e | InsertButton | DMF0021_SalesPlan.cs:3351 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '40' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d76aeba | InsertButton | DMF0021_SalesPlan.cs:3354 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-06715700 | InsertButton | DMF0021_SalesPlan.cs:3360 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-ae4d23ed | InsertButton | DMF0021_SalesPlan - 복사본.cs:1659 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ff51d04c | InsertButton | DMF0021_SalesPlan - 복사본.cs:1662 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e17a3ab6 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1667 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c6449461 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1668 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-32c3cba4 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1673 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_SET | siMain.SetText | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-422e4307 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1674 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cfb9fef6 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1679 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b2634a7e | InsertButton | DMF0021_SalesPlan - 복사본.cs:1681 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "4… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-acb32d0f | InsertButton | DMF0021_SalesPlan - 복사본.cs:1684 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3b39af86 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1686 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-104f9e29 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1688 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomerAut… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f11be8d8 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1690 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e7ef38db | InsertButton | DMF0021_SalesPlan - 복사본.cs:1695 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.MEASURE), dtMearsure2) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-07e3aebc | InsertButton | DMF0021_SalesPlan - 복사본.cs:1696 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.MEASURE), "SalesAmt_LOC") | 그리드 값 설정 |  |  |  |
| AC-83d801ae | InsertButton | DMF0021_SalesPlan - 복사본.cs:1697 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-7f4397e4 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1700 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-4021f318 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1704 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FcstType), "ETC") | 그리드 값 설정 |  |  |  |
| AC-7f93608f | InsertButton | DMF0021_SalesPlan - 복사본.cs:1705 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FcstType), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e3fed746 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1710 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TEAM_INCHARGE), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ebd42b76 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1712 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-76514ec1 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1714 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectStatus), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-85973b80 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1716 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c2064189 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1719 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BizTypeName), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c604ab81 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1723 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc9a2eda | InsertButton | DMF0021_SalesPlan - 복사본.cs:1725 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_NAME), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-33592ebb | InsertButton | DMF0021_SalesPlan - 복사본.cs:1728 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemType), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-42797563 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1730 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NickName), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2b881ef5 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1735 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1ff26ea0 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1738 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN), siMain.Act… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ae814541 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1740 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INCOTERMS), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1d734fbe | InsertButton | DMF0021_SalesPlan - 복사본.cs:1745 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CUST_GROUP), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-321eed75 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1747 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), siMain.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ac70cfa1 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1749 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OWNER), siMain.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-009f8477 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1751 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.APPLICATION), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dbeb2a6b | InsertButton | DMF0021_SalesPlan - 복사본.cs:1753 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ROUTE), siMain.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-84b22f58 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1755 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INTERNAL_YN), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7d3e3e7c | InsertButton | DMF0021_SalesPlan - 복사본.cs:1757 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_TYPE), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-68de8a61 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1759 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PACK_COUNT), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-024d178e | InsertButton | DMF0021_SalesPlan - 복사본.cs:1761 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PACK_COUNT), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-384ffb04 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1764 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.COUNTRY_NAME), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ad1c7bd7 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1766 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CITY_NAME), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a56c4c36 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1768 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL), siMain… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d7e7096a | InsertButton | DMF0021_SalesPlan - 복사본.cs:1770 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP), siM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d63086df | InsertButton | DMF0021_SalesPlan - 복사본.cs:1772 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), siMain.Activ… | 그리드 편집 잠금/해제 |  |  |  |
| AC-438f94ac | InsertButton | DMF0021_SalesPlan - 복사본.cs:1774 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), siMain.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e75b808b | InsertButton | DMF0021_SalesPlan - 복사본.cs:1776 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE_GROUP), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-649b9d6a | InsertButton | DMF0021_SalesPlan - 복사본.cs:1778 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-710fe7ca | InsertButton | DMF0021_SalesPlan - 복사본.cs:1780 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VMI_YN), siMain.ActiveRowIndex, s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b6661d00 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1788 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxC… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-49d6d0e2 | InsertButton | DMF0021_SalesPlan - 복사본.cs:1796 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4b31280d | InsertButton | DMF0021_SalesPlan - 복사본.cs:1798 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ee50c61a | InsertButton | DMF0021_SalesPlan - 복사본.cs:1804 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## DMF0021_SalesPlan.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3888a7f | SaveButton | DMF0021_SalesPlan.cs:1961 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3705407b | SaveButton | DMF0021_SalesPlan.cs:2047 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| (CString.GetCheckedListValue(… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ca02ce4 | SaveButton | DMF0021_SalesPlan.cs:2048 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| (CString.GetCheckedListValue(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-59f95cf6 | SaveButton | DMF0021_SalesPlan.cs:2085 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | FLAG | sMeasure | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-83b0be29 | SaveButton | DMF0021_SalesPlan.cs:2156 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) != -1) | FLAG | sMeasure | (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e9b9bc2 | SaveButton | DMF0021_SalesPlan.cs:2266 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDivisionId == "" \|\| (sDivisionId != "40" && sP… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-20fa93fc | SaveButton | DMF0021_SalesPlan.cs:2270 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDivisionId == "" \|\| (sDivisionId != "40" && sP… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-0c768d10 | SaveButton | DMF0021_SalesPlan.cs:2272 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDivisionId == "" \|\| (sDivisionId != "40" && sP… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-51213222 | SaveButton | DMF0021_SalesPlan.cs:2344 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | FLAG | sMeasure | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c4d5011e | SaveButton | DMF0021_SalesPlan.cs:2435 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) != -1) | FLAG | sMeasure | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-35907cbf | SaveButton | DMF0021_SalesPlan.cs:2504 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sCurrency == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e4affaa8 | SaveButton | DMF0021_SalesPlan.cs:2505 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sCurrency == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-478ac7d0 | SaveButton | DMF0021_SalesPlan.cs:2510 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | FLAG | sBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-c435d8b7 | SaveButton | DMF0021_SalesPlan.cs:2531 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (siMain.Ge… | CALL_EXT | siMain.SetColor | (i, j, i, j, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3f676e81 | SaveButton | DMF0021_SalesPlan.cs:2538 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (siMain.Ge… | CALL_EXT | siMain.SetColor | (i, j, i, j, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c10c50dd | SaveButton | DMF0021_SalesPlan.cs:2619 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-22f055d2 | SaveButton | DMF0021_SalesPlan.cs:2620 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ffd4ea53 | SaveButton | DMF0021_SalesPlan.cs:2698 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (iDateCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00146", new object[] { i + 1 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4d6541a6 | SaveButton | DMF0021_SalesPlan.cs:2699 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (iDateCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f9dff2a3 | SaveButton | DMF0021_SalesPlan.cs:2715 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL | 엔드포인트 요청 생성 |  |  |  |
| AC-d16093de | SaveButton | DMF0021_SalesPlan.cs:2717 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | ptempAction | 행/컬럼 값 대입 |  |  |  |
| AC-de1536d7 | SaveButton | DMF0021_SalesPlan.cs:2718 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-0339fb35 | SaveButton | DMF0021_SalesPlan.cs:2719 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | pProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-2bdd21b9 | SaveButton | DMF0021_SalesPlan.cs:2720 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | pScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-9d80151c | SaveButton | DMF0021_SalesPlan.cs:2721 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_plant_site_id"] | pPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-06f167aa | SaveButton | DMF0021_SalesPlan.cs:2722 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-b1be32cd | SaveButton | DMF0021_SalesPlan.cs:2723 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_dom_exp"] | pDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-348ccef3 | SaveButton | DMF0021_SalesPlan.cs:2724 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_fcst_type"] | pFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-d95156cf | SaveButton | DMF0021_SalesPlan.cs:2725 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_incoterms"] | pIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-f6bd8dcc | SaveButton | DMF0021_SalesPlan.cs:2726 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | pMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-c240c3e4 | SaveButton | DMF0021_SalesPlan.cs:2727 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | pYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-8610f464 | SaveButton | DMF0021_SalesPlan.cs:2728 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | pPrice | 행/컬럼 값 대입 |  |  |  |
| AC-7aee19f2 | SaveButton | DMF0021_SalesPlan.cs:2729 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_currency"] | pCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-0c7d8444 | SaveButton | DMF0021_SalesPlan.cs:2730 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | pUserId | 행/컬럼 값 대입 |  |  |  |
| AC-dd44cf96 | SaveButton | DMF0021_SalesPlan.cs:2731 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_last_updated_by"] | pUserId | 행/컬럼 값 대입 |  |  |  |
| AC-facf3c15 | SaveButton | DMF0021_SalesPlan.cs:2732 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_text"] | pText | 행/컬럼 값 대입 |  |  |  |
| AC-3b17bad1 | SaveButton | DMF0021_SalesPlan.cs:2733 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_dept_id"] | pDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-ba31e680 | SaveButton | DMF0021_SalesPlan.cs:2734 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | DATA_OP | request.Parameters["p_cell_prod_site_id"] | pCellProdSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-8e7bb6a1 | SaveButton | DMF0021_SalesPlan.cs:2736 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3158da32 | SaveButton | DMF0021_SalesPlan.cs:2738 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3dd62b12 | SaveButton | DMF0021_SalesPlan.cs:2808 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try ▸ if (sResultMsg != "success") | DATA_OP | sResultMsg.Contains | ("^") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae4aeefc | SaveButton | DMF0021_SalesPlan.cs:2814 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try ▸ if (sResultMsg != "success") ▸ if (sResultMsg.Contains("^")) | MESSAGE | MessageHelper.GMessageBox | (messageCode, new object[] { addmessage }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b290fcf | SaveButton | DMF0021_SalesPlan.cs:2820 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try ▸ if (sResultMsg != "success") ▸ else of (sResultMsg.Contains("^")) | MESSAGE | MessageBox.Show | (response.DataSet.Tables[0].Rows[0][0].ToString(), "Error!") | 메시지 표시 |  |  |  |
| AC-1297dc00 | SaveButton | DMF0021_SalesPlan.cs:2823 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try ▸ if (sResultMsg != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-855c001b | SaveButton | DMF0021_SalesPlan.cs:2826 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ try | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e4827366 | SaveButton | DMF0021_SalesPlan.cs:2843 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCUD > 0) ▸ catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-d62688c0 | SaveButton | DMF0021_SalesPlan.cs:2857 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-801e567e | SaveButton | DMF0021_SalesPlan - 복사본.cs:1286 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dddac435 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1287 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3e28694 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1290 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-48c2d4f7 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1294 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3f94298 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1315 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (clbDivision.SelectedValue.ToString() == "81") ▸ if (siMain.GetColumnIndex(DefColumns.D… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e461b694 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1316 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (clbDivision.SelectedValue.ToString() == "81") ▸ if (siMain.GetColumnIndex(DefColumns.D… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1bbb106d | SaveButton | DMF0021_SalesPlan - 복사본.cs:1335 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (clbDivision.SelectedValue.ToString() == "81") ▸ if (clbDivision.SelectedValue.ToS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7b8768f6 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1336 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (clbDivision.SelectedValue.ToString() == "81") ▸ if (clbDivision.SelectedValue.ToS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4f2ab29 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1371 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (clbDivision.SelectedValue.ToString() == "81") ▸ else of (clbDivision.SelectedValu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e0887dfe | SaveButton | DMF0021_SalesPlan - 복사본.cs:1372 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (clbDivision.SelectedValue.ToString() == "81") ▸ else of (clbDivision.SelectedValu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f90fd2c4 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1465 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "" \|\| sPROJECT_CODE == "" \|\| … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c981ef78 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1468 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "" \|\| sPROJECT_CODE == "" \|\| … | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-0dcd3bd7 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1470 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "" \|\| sPROJECT_CODE == "" \|\| … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba845fea | SaveButton | DMF0021_SalesPlan - 복사본.cs:1493 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!fnValidation()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cb0fe90b | SaveButton | DMF0021_SalesPlan - 복사본.cs:1494 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!fnValidation()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df6e12be | SaveButton | DMF0021_SalesPlan - 복사본.cs:1583 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], stempAction, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-cd8eb5b9 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1584 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_DIVISION_ID"] | CString.AppendStringEx(nvc["p_DIVISION_ID"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-82bdba02 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1585 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_PROJECT_CODE"] | CString.AppendStringEx(nvc["p_PROJECT_CODE"], sPROJECT_CODE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-3cba7ab3 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1586 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_SCM_SITE_ID"] | CString.AppendStringEx(nvc["p_SCM_SITE_ID"], sSCM_SITE_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-085ba111 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1587 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_PLANT_SITE_ID"] | CString.AppendStringEx(nvc["p_PLANT_SITE_ID"], sPLANT_SITE_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-8b8c2330 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1588 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_ITEM_ID"] | CString.AppendStringEx(nvc["p_ITEM_ID"], sITEM_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-05b5265c | SaveButton | DMF0021_SalesPlan - 복사본.cs:1589 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_DOM_EXP"] | CString.AppendStringEx(nvc["p_DOM_EXP"], p_DOM_EXP, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-e17c11c4 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1590 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_FCST_TYPE"] | CString.AppendStringEx(nvc["p_FCST_TYPE"], p_FCST_TYPE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-7beba47c | SaveButton | DMF0021_SalesPlan - 복사본.cs:1591 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_INCOTERMS"] | CString.AppendStringEx(nvc["p_INCOTERMS"], sINCOTERMS, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-d43677d6 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1592 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_MEASURE"] | CString.AppendStringEx(nvc["p_MEASURE"], p_MEASURE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-53a11e19 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1593 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], sYYYYMMDD, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-18983fc9 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1594 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_QTY"] | CString.AppendStringEx(nvc["p_QTY"], sPRICE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-02e0ab17 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1595 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_CURRENCY"] | CString.AppendStringEx(nvc["p_CURRENCY"], sCURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-603d80f7 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1596 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-2b078393 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1597 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-9d9abc45 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1606 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (iDateCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00146", new object[] { i + 1 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-338d38c7 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1607 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (iDateCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a012f3e2 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1617 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | (new CUIControl()).GetAsyncDataUsingByDB | (this, "DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL", nvc) ⇒ DM_H.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL | 엔드포인트 호출 |  |  |  |
| AC-26e2b771 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1617 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new CUIControl | () ⇒ DM_H.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL | 엔드포인트 요청 생성 |  |  |  |
| AC-cf0fd6e2 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1622 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | MESSAGE | MessageBox.Show | (ds.Tables[0].Rows[0][0].ToString(), "Error!") | 메시지 표시 |  |  |  |
| AC-7bf2e522 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1623 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac052171 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1627 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00124368 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1630 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f44b4038 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1641 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-95ce7874 | SaveButton | DMF0021_SalesPlan - 복사본.cs:1642 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-8e282a3a | SaveButton | DMF0021_SalesPlan - 복사본.cs:1647 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0021_SalesPlan.SaveData_All

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce4a25f9 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1112 | if (siMain != null && siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3e8ad61 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1150 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "" \|\| sPROJECT_CODE == "" \|\| sSCM_S… | MESSAGE | MessageBox.Show | (sMsg, "Warining!") | 메시지 표시 |  |  |  |
| AC-e2a4b00f | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1153 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "" \|\| sPROJECT_CODE == "" \|\| sSCM_S… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-1e89afc0 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1155 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "" \|\| sPROJECT_CODE == "" \|\| sSCM_S… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c9c564bf | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1176 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | dsSpread.Tables[0].Select | (sWhere) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ede8c41 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1180 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ if (rows.Length > 0) | MESSAGE | MessageBox.Show | ("It happened a Duplication. Informatoin : " + sWhere, "Error!") | 메시지 표시 |  |  |  |
| AC-7b447758 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1183 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ if (rows.Length > 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-b6dc3682 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1184 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ if (rows.Length > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44a06878 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1237 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], stempAction, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-1119b8a1 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1238 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_DIVISION_ID"] | CString.AppendStringEx(nvc["p_DIVISION_ID"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-5ec8a132 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1239 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_PROJECT_CODE"] | CString.AppendStringEx(nvc["p_PROJECT_CODE"], sPROJECT_CODE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-fb1d8b8f | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1240 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_SCM_SITE_ID"] | CString.AppendStringEx(nvc["p_SCM_SITE_ID"], sSCM_SITE_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-7f918f49 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1241 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_PLANT_SITE_ID"] | CString.AppendStringEx(nvc["p_PLANT_SITE_ID"], sPLANT_SITE_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-3936f85c | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1242 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_ITEM_ID"] | CString.AppendStringEx(nvc["p_ITEM_ID"], sITEM_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-4b09eb8f | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1243 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_DOM_EXP"] | CString.AppendStringEx(nvc["p_DOM_EXP"], p_DOM_EXP, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-12a2f53b | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1244 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_FCST_TYPE"] | CString.AppendStringEx(nvc["p_FCST_TYPE"], p_FCST_TYPE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-04c765c6 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1245 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_INCOTERMS"] | CString.AppendStringEx(nvc["p_INCOTERMS"], sINCOTERMS, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-baeb3881 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1246 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_MEASURE"] | CString.AppendStringEx(nvc["p_MEASURE"], p_MEASURE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-483e0329 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1247 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], sYYYYMMDD, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-e5a7e5a7 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1248 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_QTY"] | CString.AppendStringEx(nvc["p_QTY"], sPRICE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-43f721c1 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1249 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-b385d73c | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1250 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_CREATION_DATE"] | CString.AppendStringEx(nvc["p_CREATION_DATE"], System.DateTime.Now.ToString(), iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-c2766cbf | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1251 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-b22f0a12 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1254 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if ((j % 20) == 0) | UI_MISC | Application.DoEvents | () | 화면 갱신/대기창 |  |  |  |
| AC-a755ec0e | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1261 | if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | (new CUIControl()).GetAsyncDataUsingByDB | (this, "DM0021_SAVE_DM_PLN_SALES_PLAN_ALL", nvc) ⇒ DM_H.DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | 엔드포인트 호출 |  |  |  |
| AC-f020e968 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1261 | if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | 엔드포인트 요청 생성 |  |  |  |
| AC-bf9810b1 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1266 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | MESSAGE | MessageBox.Show | (ds.Tables[0].Rows[0][1].ToString(), "Error!") | 메시지 표시 |  |  |  |
| AC-b60b1f7e | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1267 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ddee9be | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:1271 | if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0021_SalesPlan.SetChangeControl

진입점: this.clbCustomer.SelectedIndexChanged / this.clbTeam.SelectedIndexChanged [if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82"))] / this.Load / this.clbDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b9d50e1 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:375 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-90fbfff1 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:376 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ad6f958f | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:381 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b49f413 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:381 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ab65c01d | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:385 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7acea695 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:386 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-8ee9a04f | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:386 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4b13b213 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:390 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8b8505bc | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:391 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-b547c87c | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:392 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-81c537bf | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:392 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4975b889 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:396 | switch (triggerControl) case "BizType": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-48b323a4 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:397 | switch (triggerControl) case "BizType": | FLAG | dtBizType | DataService.GetDMInnerTable("BizType", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-71d391ca | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:397 | switch (triggerControl) case "BizType": | COMBO_DATA | DataService.GetDMInnerTable | ("BizType", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b9745ca9 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:401 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-340dabd0 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:402 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-01685af7 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:403 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-6889b26b | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:404 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-0ee8c81f | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:404 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-36de6d77 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:408 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-322050b6 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:409 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-822bf999 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:410 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | FLAG | dtPlantSite | DataService.GetDMInnerTable("UserPlantSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-25d4feb9 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:410 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-fca31b41 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:414 | switch (triggerControl) case "UserPlantSiteByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a295b9e1 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:415 | switch (triggerControl) case "UserPlantSiteByDivision": | FLAG | dtPlantSiteByDivision | DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9edb075d | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0021_SalesPlan.cs:415 | switch (triggerControl) case "UserPlantSiteByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0021_SalesPlan.SetSaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d26ffa5 | (진입점 미연결) | DMF0021_SalesPlan.cs:4156 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddb7a978 | (진입점 미연결) | DMF0021_SalesPlan.cs:4160 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-188385b9 | (진입점 미연결) | DMF0021_SalesPlan.cs:4161 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DIVISION_ID] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ef1f2695 | (진입점 미연결) | DMF0021_SalesPlan.cs:4162 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.PROJECT_CODE] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-4f6a1a51 | (진입점 미연결) | DMF0021_SalesPlan.cs:4163 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.SCM_SITE_ID] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-531c3b51 | (진입점 미연결) | DMF0021_SalesPlan.cs:4164 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ITEM_ID] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-7e65b5bb | (진입점 미연결) | DMF0021_SalesPlan.cs:4165 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.TEXT] | sText | 행/컬럼 값 대입 |  |  |  |
| AC-9da61977 | (진입점 미연결) | DMF0021_SalesPlan.cs:4166 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DomExp] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-5f4a4d1b | (진입점 미연결) | DMF0021_SalesPlan.cs:4167 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-3c81e581 | (진입점 미연결) | DMF0021_SalesPlan.cs:4168 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.INCOTERMS] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-96ccbeff | (진입점 미연결) | DMF0021_SalesPlan.cs:4169 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.MEASURE] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-bda833a6 | (진입점 미연결) | DMF0021_SalesPlan.cs:4170 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-8d846d8e | (진입점 미연결) | DMF0021_SalesPlan.cs:4171 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-b807ad07 | (진입점 미연결) | DMF0021_SalesPlan.cs:4173 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-9921e3cc | (진입점 미연결) | DMF0021_SalesPlan.cs:4174 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6cd63b24 | (진입점 미연결) | DMF0021_SalesPlan.cs:4178 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-8b408c26 | (진입점 미연결) | DMF0021_SalesPlan.cs:4179 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5c127a01 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2442 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-20a3cc5d | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2446 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1c310114 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2447 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DIVISION_ID] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ea2d1970 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2448 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.PROJECT_CODE] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-db0e786b | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2449 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.SCM_SITE_ID] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-645f1085 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2450 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ITEM_ID] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-a9f9e54f | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2451 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DomExp] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-78aaf7fa | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2452 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-26b10160 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2453 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.INCOTERMS] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-4d9a919f | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2454 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.MEASURE] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-73b114b6 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2455 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-a55105d0 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2456 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-394266bd | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2458 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-45630ca0 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2459 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2d2724e7 | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2463 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-5b8dbf4a | (진입점 미연결) | DMF0021_SalesPlan - 복사본.cs:2464 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0021_SalesPlan.SetSpreadColumn

진입점: this.chkColor.CheckedChanged [if (siMain != null)] / this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [try ▸ el…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf70d50a | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3633 |  | FLAG | sResult_YYYYMMDD | dateTime.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-fbbf2f29 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3641 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-03302a4e | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3643 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-3a2bce17 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3648 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9397d104 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3650 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-14cbeca1 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3653 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-6924a27b | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3658 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-38587c87 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3660 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-decd0cfa | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3669 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.G… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-8ae220a3 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3670 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.G… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-364baa71 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3671 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.G… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Width | 60 | 그리드 속성/값 설정 |  |  |  |
| AC-2022d145 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3678 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-32ffc087 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3679 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-1ccfcfbf | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3686 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-37c962c1 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3687 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-32b45522 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3694 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkColor.Checked == false) ▸ if (chkColor.Checked == true) | GRID_STYLE | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-def435d5 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan.cs:3695 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkColor.Checked == false) ▸ if (chkColor.Checked == true) | CALL_EXT | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetFont | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fb10231c | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan - 복사본.cs:2039 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c55aa2d2 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan - 복사본.cs:2041 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-8e8ad845 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan - 복사본.cs:2046 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-eb9c51d9 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan - 복사본.cs:2048 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-889e059f | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan - 복사본.cs:2051 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-0ffe5a6f | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan - 복사본.cs:2056 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-65ac4054 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0021_SalesPlan - 복사본.cs:2058 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0021_SalesPlan.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ try ▸ else of (dtSta…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f78c4665 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3726 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0129d257 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3734 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b876a97c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3747 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-cc6b70a8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3754 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-32d79200 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3755 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9dccc87 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3760 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92f1f1d7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3761 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-69e9997d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3768 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3cd6fd76 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3769 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-db095d55 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3780 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-20315882 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3781 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a1a59e90 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3782 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-326761bf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3783 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4aa70647 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3784 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-752078d3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan.cs:3786 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c6b204fc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2090 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bda73e32 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2098 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5b293600 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2111 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-cf39a412 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2118 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-74671b94 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2119 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-688614c2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2124 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fedafd2a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2125 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9de10bb6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2132 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d354bd9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2133 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c5d9a29 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2144 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c651f800 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2145 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2e2adf0a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2146 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a5c4350 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2147 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dd2f5b3c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2149 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b6afea24 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0021_SalesPlan - 복사본.cs:2151 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0021_SalesPlan.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e31b8c8 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3800 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-2e831971 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3807 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-c21fd909 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3813 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-89122918 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3827 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-66ad5876 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3838 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed1d06d8 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3871 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) != -1) | FLAG | sMeasure | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9d79db7a | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3876 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-b43d7329 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3877 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d71cf157 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3878 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-293b57a0 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3879 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-21ffeb3b | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3884 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode) | 그리드 값 설정 |  |  |  |
| AC-29b79d5c | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3886 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), popProject.ProjectName) | 그리드 값 설정 |  |  |  |
| AC-733a07b4 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3888 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), popProject.ProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-9702d4b5 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3891 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizTypeName), popProject.BizTypeName) | 그리드 값 설정 |  |  |  |
| AC-9d008d69 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3893 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), popProject.ProjectOwner) | 그리드 값 설정 |  |  |  |
| AC-cea9b91e | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3897 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-f38c6546 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3899 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-0465177b | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3931 | else of (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ … | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-4ad76f78 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3935 | else of (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ … | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sMdmActive_Sw, sMea… | 팝업 초기화(인자 전달) |  |  |  |
| AC-32107b7b | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3936 | else of (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ … | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8bec0b81 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3937 | else of (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ … | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4c90a374 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3946 | else of (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ … | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |
| AC-4e33b0ab | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3949 | else of (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ItemType), sItemType) | 그리드 값 설정 |  |  |  |
| AC-af9e208c | this.spdMain.CellDoubleClick | DMF0021_SalesPlan.cs:3952 | else of (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NickName), sNickName) | 그리드 값 설정 |  |  |  |
| AC-08225f8c | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2164 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-5e35bf13 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2169 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-cfc20abf | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2181 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-a1f7fd9f | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2191 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e50b086e | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2219 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-2a626d28 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2220 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c8eab4f5 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2221 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1d2fec4e | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2222 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-34487ac4 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2227 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode) | 그리드 값 설정 |  |  |  |
| AC-3d51c4d2 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2229 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), popProject.ProjectName) | 그리드 값 설정 |  |  |  |
| AC-9e51b46b | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2231 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), popProject.ProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-7d8a3918 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2234 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizTypeName), popProject.BizTypeName) | 그리드 값 설정 |  |  |  |
| AC-cd756e6d | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2236 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), popProject.ProjectOwner) | 그리드 값 설정 |  |  |  |
| AC-ee057d86 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2240 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-6c5c3702 | this.spdMain.CellDoubleClick | DMF0021_SalesPlan - 복사본.cs:2242 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) ▸ if (p… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |

## DMF0021_SalesPlan.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8923d605 | this.spdMain.ClipboardPasted | DMF0021_SalesPlan.cs:5633 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | FLAG | dtCellProdSiteID | Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-10a7642f | this.spdMain.ClipboardPasted | DMF0021_SalesPlan.cs:5633 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | COMBO_DATA | Data.Common | (Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d685f3c1 | this.spdMain.ClipboardPasted | DMF0021_SalesPlan.cs:5634 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSiteID) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0021_SalesPlan.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03bc1e9d | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4546 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtTeam | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-bd213d3b | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4546 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff518648 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4547 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-635d0118 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4554 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-0211aedb | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4554 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bff37778 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4555 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-518a7d26 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4563 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-390e673b | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4563 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1da60f4b | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4564 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-256dab57 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4572 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-8b1a5e5c | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4572 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-229d9c89 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4573 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-56ff007e | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4578 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-2b204e5e | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4578 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fd42d123 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4579 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-687e498e | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4584 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f56e6001 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4586 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0fb89485 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4596 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-33e89d2e | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4596 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2540ebbc | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4596 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '82' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee4e35a8 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4598 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b6b7c2d1 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4598 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d6255bbd | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4598 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '81' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed0918ad | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4601 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-da905955 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4601 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dee77c7b | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4601 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '40' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-922f7b28 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4607 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-51a398d0 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4609 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-a8117525 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4611 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-457afe3f | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4613 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-a39e9772 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4615 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-b5a47d4a | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4617 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-988dd552 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4619 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TEXT), "") | 그리드 값 설정 |  |  |  |
| AC-7e917a10 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4621 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-3c6a1c9f | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4690 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-87de9b5b | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4690 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eca1f17a | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4691 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d319297a | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4698 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-522195c9 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4698 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bab2f7a3 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4698 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '82' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-0178aa4f | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4700 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1cce03a5 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4700 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f0ac899e | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4700 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '81' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-0bb1facb | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4703 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-38238d0f | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4703 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f2ab7fa4 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4703 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '40' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-30240404 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4709 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-1f729ba0 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4711 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-8e40c0ed | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4713 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-b46eda5b | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4715 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-e438e6d3 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4717 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TEXT), "") | 그리드 값 설정 |  |  |  |
| AC-bc7cce86 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4719 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-40b33f6c | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4727 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c1308293 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4727 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1a559b91 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4728 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-01d488b9 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4735 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-75d1595f | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4735 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e28e6561 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4735 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '82' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-29d0f0eb | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4737 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-272e5edc | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4737 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7dfce04e | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4737 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '81' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0aa4083 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4744 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8a049b09 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4744 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-152ccf1d | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4744 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '40' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-b2858c08 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4757 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e66a8e74 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4757 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1cc3609c | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4757 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '82' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-ccdbcbdd | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4759 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-94da6a7c | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4759 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-732a9dbf | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4759 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '81' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-6be8f3b8 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4766 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b1797f45 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4766 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ba373c54 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4766 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '40' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-d404ce9c | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4773 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-c3a8f2f8 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4775 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-704aee29 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4777 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-26cbb24a | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4779 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TEXT), "") | 그리드 값 설정 |  |  |  |
| AC-6f5c282b | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4781 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-febb9428 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4786 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | ("CODE = '" + sModelCode.Trim() + "' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4febb81 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4793 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), sModelName) | 그리드 값 설정 |  |  |  |
| AC-c9be79db | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4809 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtCellProdSiteID | Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID2, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-1f6dd8a1 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4809 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.Common | (Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID2, "", "", "") ⇒ biz:CommonData.CommonDataList [code=CELL_PROD_SITE_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea7b9561 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4810 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSit… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a26a4ad4 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4819 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5304cc76 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4909 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-fa61accd | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4910 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-0ef9c5a6 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4915 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.DomExp), "") | 그리드 값 설정 |  |  |  |
| AC-4a82eaea | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4916 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DomExp), dtCustomsHandbook) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ff78d48a | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4917 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.DomExp), e.Row, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ba61ee79 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4933 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-436bdd3a | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4934 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtIncotermsType | GetIncotermsType(sDivision, sScmSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-f12286de | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4935 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), dtIncotermsType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9ee1d32f | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4936 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), e.Row, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-47cb8293 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4941 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FcstType), "") | 그리드 값 설정 |  |  |  |
| AC-e4b069fd | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4942 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FcstType), dtFcstType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-92214b34 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4943 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.FcstType), e.Row, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-aaecabc3 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4950 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-e2b8cf62 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4951 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), e.Row, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5fad7554 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4964 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | Convert.ToUInt32 | (sValue.Replace("W_", "").Replace("M_", "").Substring(0, 6)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0536755b | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4964 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | Convert.ToUInt32 | (DateTime.Now.AddMonths(3).ToString("yyyyMM")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9eff30f9 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4966 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3d4b107e | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4970 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-17a93f26 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4976 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-53baa899 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4985 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FcstType), "ETC") | 그리드 값 설정 |  |  |  |
| AC-7b4dd258 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4986 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_INIT | siMain.SetCellTypeText | (e.Row, siMain.GetColumnIndex(DefColumns.FcstType)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c888d21d | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4987 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.FcstType), e.Row, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-03dbc666 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4992 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.DomExp), "") | 그리드 값 설정 |  |  |  |
| AC-ae5ce23e | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4993 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.DomExp), e.Row, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b5127f7f | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4998 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-54282024 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:4999 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), e.Row, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-783830f5 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5006 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-ea899fa6 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5007 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), e.Row, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8f4ac5b6 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5012 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | null | 그리드 속성/값 설정 |  |  |  |
| AC-ca971450 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5013 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-ddc1ada3 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5014 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3345784a | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5014 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3cb344fa | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5014 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '40' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-b5e8c38b | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5019 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NickName), "") | 그리드 값 설정 |  |  |  |
| AC-e67a7bb1 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5033 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-984ee2d7 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5047 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c8dc8cdb | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5050 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2d9b9821 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5056 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bbe4d440 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5062 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-505662af | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5065 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c8405ae1 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5070 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ae1587b2 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5079 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-532fcd6a | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5087 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-29a9050f | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5096 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2e0c6331 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5111 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, i, "") | 그리드 값 설정 |  |  |  |
| AC-0dc97c87 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5115 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-84beb555 | this.spdMain.ComboSelChange | DMF0021_SalesPlan.cs:5118 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-97f9c133 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2753 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtTeam | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-2f488b57 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2753 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-02ebc8f5 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2754 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f05e39b0 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2761 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-d86d79ff | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2761 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9c947f54 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2762 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8250372a | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2770 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-87911ffe | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2770 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-97bea00a | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2771 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e5db142b | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2779 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-d5f397b2 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2779 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9dc93e22 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2780 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-938ad00b | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2785 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-4433ce84 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2785 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-08d40021 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2786 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7dd059cc | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2789 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-efe87a3e | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2791 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b31936f2 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2798 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-86898880 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2798 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d0504f7d | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2798 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '82' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-320d193e | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2800 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6a7c5d9a | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2800 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c199587b | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2800 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '81' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-8c30034a | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2803 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c21bfeb9 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2803 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-add519eb | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2803 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '40' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-5731ca14 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2808 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-8f44979a | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2810 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-1905e467 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2812 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-10aff6de | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2814 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-93f328f3 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2816 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-eea7933f | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2818 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-7cac4f18 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2820 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-c91cbc45 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2828 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-e763b966 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2828 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-619c578a | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2829 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a5d1ec4b | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2833 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-f25e4149 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2833 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8d02e150 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2834 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1187195a | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2841 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-76b68c43 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2841 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fa6eb2c3 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2842 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6e297f63 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2846 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-dc8a1d3f | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2846 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2800192d | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2847 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c5219f7f | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2853 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-30a02e3b | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2853 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-252e8ca3 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2853 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '82' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-a03c4865 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2855 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e24ab78b | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2855 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0afe7124 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2855 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '81' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe522dbe | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2858 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a1d8d095 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2858 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eb39e66b | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2858 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '40' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-4b0edff9 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2864 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-7e32a6c9 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2866 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-fb1ffda4 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2868 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-87a5558e | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2870 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-13edc9ae | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2872 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-bbf34e37 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2874 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-23f37379 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2880 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-0dc61c78 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2880 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-73a26d40 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2881 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-091b181d | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2886 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-47ba57b5 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2886 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d3231351 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2886 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '82' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d641d1c | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2888 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b19ad4ad | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2888 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6ba2be4a | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2888 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '81' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-0650db59 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2891 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b13942ab | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2891 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ff28db12 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2891 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '40' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-f485d610 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2896 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c5f364a0 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2898 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-fdcf7d0f | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2900 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-50205e7b | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2902 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-d265b3c6 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2904 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-13d63647 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2912 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-45bebf2b | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2912 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-05e8c498 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2913 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d01ffa12 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2918 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-12e8252a | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2918 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1ff98fd0 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2918 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '82' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-1034b4e5 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2920 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-97f8bfce | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2920 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-beebb0cd | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2920 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '81' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbf9e8ae | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2923 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5247f734 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2923 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e860db1d | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2923 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '40' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-97829d01 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2931 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d0752811 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2931 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ff791216 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2931 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '82' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ae06a9e | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2933 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-78b117da | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2933 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5692dcfd | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2933 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '81' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b679aa5 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2936 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-81a266be | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2936 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-733b9502 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2936 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '40' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-d35e700a | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2940 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-0db6acca | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2942 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-61faf00e | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2944 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-73184077 | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2946 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-96b05f1c | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2951 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | ("CODE = '" + sModelCode.Trim() + "' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-848d099e | this.spdMain.ComboSelChange | DMF0021_SalesPlan - 복사본.cs:2958 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), sModelName) | 그리드 값 설정 |  |  |  |

## DMF0021_SalesPlan.spdMain_EnterCell

진입점: this.spdMain.EnterCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-876935a3 | this.spdMain.EnterCell | DMF0021_SalesPlan.cs:4336 | if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column) | FLAG | sOrigianlValue | sText == "" ? "0" : sText | 화면 필드/플래그 변경 |  |  |  |
| AC-6c5f0d76 | this.spdMain.EnterCell | DMF0021_SalesPlan - 복사본.cs:2616 | if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column) | FLAG | sOrigianlValue | sText == "" ? "0" : sText | 화면 필드/플래그 변경 |  |  |  |

## DMF0021_SalesPlan.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cef98e89 | this.spdMain.KeyUp | DMF0021_SalesPlan.cs:5475 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1acdd434 | this.spdMain.KeyUp | DMF0021_SalesPlan.cs:5479 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-74d81186 | this.spdMain.KeyUp | DMF0021_SalesPlan.cs:5485 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa943916 | this.spdMain.KeyUp | DMF0021_SalesPlan.cs:5486 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0483fb59 | this.spdMain.KeyUp | DMF0021_SalesPlan - 복사본.cs:3260 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-765e718e | this.spdMain.KeyUp | DMF0021_SalesPlan - 복사본.cs:3264 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-97cc912d | this.spdMain.KeyUp | DMF0021_SalesPlan - 복사본.cs:3270 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b1a5f76 | this.spdMain.KeyUp | DMF0021_SalesPlan - 복사본.cs:3271 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0021_SalesPlan.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0ff9889 | this.spdMain.LeaveCell | DMF0021_SalesPlan.cs:4382 |  | CALL_EXT | siMain.GetBGColor | (iRow, iColumn) | ⚠ 의미 확인 필요 |  |  |  |
| AC-46c7e0d9 | this.spdMain.LeaveCell | DMF0021_SalesPlan.cs:4388 | if (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor && siMain.GetColumnIndex(this_YYYYMM) > 0 && siMain.GetColu…) ▸ if (siMain.… | FLAG | sMeasure | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c11cc18a | this.spdMain.LeaveCell | DMF0021_SalesPlan.cs:4400 | if (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor && siMain.GetColumnIndex(this_YYYYMM) > 0 && siMain.GetColu…) ▸ if (sMeasur… | GRID_SET | siMain.SetValue | (iRow, iColumn, "") | 그리드 값 설정 |  |  |  |
| AC-b1f9eae9 | this.spdMain.LeaveCell | DMF0021_SalesPlan.cs:4401 | if (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor && siMain.GetColumnIndex(this_YYYYMM) > 0 && siMain.GetColu…) ▸ if (sMeasur… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f08376c6 | this.spdMain.LeaveCell | DMF0021_SalesPlan.cs:4420 | if (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor && siMain.GetColumnIndex(this_YYYYMM) > 0 && siMain.GetColu…) ▸ switch (iMe… | CALL_EXT | siMain.SetRowFormat | (iRow, iColumn, 1, "###,###,###,###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-59697b19 | this.spdMain.LeaveCell | DMF0021_SalesPlan.cs:4424 | if (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor && siMain.GetColumnIndex(this_YYYYMM) > 0 && siMain.GetColu…) ▸ switch (iMe… | CALL_EXT | siMain.SetRowFormat | (iRow, iColumn, 1, "###,###,###,##0.000") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2aa3b472 | this.spdMain.LeaveCell | DMF0021_SalesPlan.cs:4430 | if (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor && siMain.GetColumnIndex(this_YYYYMM) > 0 && siMain.GetColu…) ▸ if (sMeasur… | DATA_OP | Val.Contains | (".") | 데이터 객체 조작/조회 |  |  |  |
| AC-04e4acce | this.spdMain.LeaveCell | DMF0021_SalesPlan.cs:4433 | if (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor && siMain.GetColumnIndex(this_YYYYMM) > 0 && siMain.GetColu…) ▸ if (sMeasur… | GRID_SET | siMain.SetValue | (iRow, iColumn, Val) | 그리드 값 설정 |  |  |  |

## DMF0021_SalesPlan.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acac0b22 | this.spdMain.TopChange | DMF0021_SalesPlan.cs:3572 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-432a2b76 | this.spdMain.TopChange | DMF0021_SalesPlan - 복사본.cs:2012 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |


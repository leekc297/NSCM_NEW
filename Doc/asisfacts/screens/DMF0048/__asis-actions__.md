# AS-IS 액션 대조표 — DMF0048

> 원천: `Doc/asisfacts/screens/DMF0048/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 657행 · 메서드 78 · 종류 DATA_OP 119 · FLAG 76 · RETURN 57 · GRID_SET 52 · ENDPOINT 52 · GRID_INIT 40 · LIST_REBIND 38 · UI_PROP 37 · STATE 32 · POPUP 30 · COMBO_DATA 29 · CALL_EXT 19 · MESSAGE 14 · VALUE_CLEAR 14 · UI_MISC 13 · VALUE_SET 12 · GRID_STYLE 9 · THROW 7 · CALL_BASE 2 · GRID_BIND 2 · GRID_LOCK 2 · STATE_RESET 1 · ⚠ 의미 확인 필요 21


## DMF0048_SalesMonitoring.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e24bbb9c | this.btnColumn.Click | DMF0048_SalesMonitoring.cs:1758 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-543d2235 | this.btnColumn.Click | DMF0048_SalesMonitoring.cs:1759 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d3eeb3d9 | this.btnColumn.Click | DMF0048_SalesMonitoring.cs:1760 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0048_SalesMonitoring.btnItemId_Click

진입점: this.btnItemId.Click / this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-711c784e | this.btnItemId.Click 외 1 | DMF0048_SalesMonitoring.cs:1112 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-5c0275be | this.btnItemId.Click 외 1 | DMF0048_SalesMonitoring.cs:1115 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-74a00236 | this.btnItemId.Click 외 1 | DMF0048_SalesMonitoring.cs:1116 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-66160ac6 | this.btnItemId.Click 외 1 | DMF0048_SalesMonitoring.cs:1117 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b555829f | this.btnItemId.Click 외 1 | DMF0048_SalesMonitoring.cs:1119 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0048_SalesMonitoring.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfbf5006 | this.btnMeasure.Click | DMF0048_SalesMonitoring.cs:1771 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-e1288fb0 | this.btnMeasure.Click | DMF0048_SalesMonitoring.cs:1772 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9a0fca43 | this.btnMeasure.Click | DMF0048_SalesMonitoring.cs:1773 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0048_SalesMonitoring.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a646dec | this.btnOwner.Click | DMF0048_SalesMonitoring.cs:2157 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e5cdc24e | this.btnOwner.Click | DMF0048_SalesMonitoring.cs:2160 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-bb71ace6 | this.btnOwner.Click | DMF0048_SalesMonitoring.cs:2161 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6e70add3 | this.btnOwner.Click | DMF0048_SalesMonitoring.cs:2162 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c82eae46 | this.btnOwner.Click | DMF0048_SalesMonitoring.cs:2164 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0048_SalesMonitoring.btnProject_Click

진입점: this.btnProject.Click / this.layoutControlItem3.Click / this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bf2a029 | this.btnProject.Click 외 2 | DMF0048_SalesMonitoring.cs:1092 | if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-62ed343f | this.btnProject.Click 외 2 | DMF0048_SalesMonitoring.cs:1093 | if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-834f8b32 | this.btnProject.Click 외 2 | DMF0048_SalesMonitoring.cs:1094 | if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6f57df48 | this.btnProject.Click 외 2 | DMF0048_SalesMonitoring.cs:1095 | if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2c4b02ea | this.btnProject.Click 외 2 | DMF0048_SalesMonitoring.cs:1097 | if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0048_SalesMonitoring.cboBucketType_Click

진입점: this.cboBucketType.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03de88fe | this.cboBucketType.Click | DMF0048_SalesMonitoring.cs:2173 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | MESSAGE | MessageHelper.GMessageBox | ("MSG00227") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5d3fcb5e | this.cboBucketType.Click | DMF0048_SalesMonitoring.cs:2174 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d89f766c | this.cboBucketType.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1133 | if (siMain != null) | FLAG | sBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-824a314f | this.cboBucketType.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1141 | if (siMain != null) | FLAG | sResult_YYYYMMWW | "W_" + sResult_YYYYMMDD.Substring(0, 6) + weekNumber | 화면 필드/플래그 변경 |  |  |  |
| AC-cfab267b | this.cboBucketType.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1150 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnIndex("D_"… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sPre_YYYYMMDD)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-4f939fb0 | this.cboBucketType.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1154 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnIndex(sRes… | CALL_EXT | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].ResetBorder | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-48846277 | this.cboBucketType.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1158 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (siMain.GetColumnIndex… | CALL_EXT | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].ResetBorder | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-30a6563f | this.cboBucketType.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1165 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.Control… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-3b68698c | this.cboBucketType.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1169 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.Control… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-eb0cdf7a | this.cboBucketType.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1173 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.Control… | CALL_EXT | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sPre_YYYYMMDD)].ResetBorder | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff5fb36b | this.cboBucketType.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1183 | if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) | CALL_BASE | EditButton | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9b1d5d0 | this.cboBucketType.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1184 | if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) | CALL_BASE | EditButton | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0048_SalesMonitoring.cboKRW_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df51305a | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2119 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.cboLOC_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5863dff | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2139 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.cboUSD_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1332201 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2129 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f2cc8b5 | this.clbCustomer.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1825 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0048_SalesMonitoring.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dfc5fa3 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1838 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c541b7d | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1841 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9ca71a01 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1849 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-41f29037 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1861 | try ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-83770adf | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1869 | try ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3265abc3 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1870 | try ▸ if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-59da73ee | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1871 | try ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-72e26fb6 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1873 | try ▸ if (sDivision == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-235f3467 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1874 | try ▸ if (sDivision == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-d6dd630c | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1882 | try ▸ else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1b823cd3 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1890 | try ▸ else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e237c226 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1891 | try ▸ else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-71647cdf | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1892 | try ▸ else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2bef88c7 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1898 | try | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6f06bd07 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1903 | try | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-99a8cba9 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1911 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1d2fe8c9 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1920 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-37b0c26d | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1925 | try | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-667471a9 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1926 | try | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-90af5f26 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1927 | try | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-89567c84 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1933 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d815520c | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1934 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-a1558a27 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:1938 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0048_SalesMonitoring.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42f12942 | this.clbTeam.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:2035 | if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2e91cf24 | this.clbTeam.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:2049 | else of ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-921091bd | this.clbTeam.SelectedIndexChanged | DMF0048_SalesMonitoring.cs:2059 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0048_SalesMonitoring.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aea26046 | this.Load | DMF0048_SalesMonitoring.cs:462 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dfed9ea7 | this.Load | DMF0048_SalesMonitoring.cs:463 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5a2f98cf | this.Load | DMF0048_SalesMonitoring.cs:464 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0048_SalesMonitoring.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74d1fe51 | this.Load | DMF0048_SalesMonitoring.cs:424 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-59a247f8 | this.Load | DMF0048_SalesMonitoring.cs:425 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-620eb6da | this.Load | DMF0048_SalesMonitoring.cs:427 |  | UI_PROP | usrConditionPanel2.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-9f44d107 | this.Load | DMF0048_SalesMonitoring.cs:430 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |
| AC-86b43ea6 | this.Load | DMF0048_SalesMonitoring.cs:432 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-35c8ba5f | this.Load | DMF0048_SalesMonitoring.cs:434 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-3e5c3c67 | this.Load | DMF0048_SalesMonitoring.cs:435 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-9f1caa4d | this.Load | DMF0048_SalesMonitoring.cs:436 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-a5241c53 | this.Load | DMF0048_SalesMonitoring.cs:437 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DMF0048_SalesMonitoring.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c6b1530 | Dispose | DMF0048_SalesMonitoring.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0048_SalesMonitoring.Dsdm_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b19346c2 | dsdm.Changed | DMF0048_SalesMonitoring.cs:1394 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-611fc080 | dsdm.Changed | DMF0048_SalesMonitoring.cs:1399 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-287a041d | dsdm.Changed | DMF0048_SalesMonitoring.cs:1400 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ac82f3e | dsdm.Changed | DMF0048_SalesMonitoring.cs:1401 | if (siMain.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-faa9f579 | dsdm.Changed | DMF0048_SalesMonitoring.cs:1410 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b2c7c27b | dsdm.Changed | DMF0048_SalesMonitoring.cs:1415 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-98391f9e | dsdm.Changed | DMF0048_SalesMonitoring.cs:1416 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8ecbbd7 | dsdm.Changed | DMF0048_SalesMonitoring.cs:1420 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row, e.Column, e.Row, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0b9de2d | dsdm.Changed | DMF0048_SalesMonitoring.cs:1439 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, iStartCol, siMain.GetText(e.Row, iStartCol)) | 그리드 값 설정 |  |  |  |
| AC-7a697510 | dsdm.Changed | DMF0048_SalesMonitoring.cs:1461 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |

## DMF0048_SalesMonitoring.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a351c0e | ExcelButton | DMF0048_SalesMonitoring.cs:570 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-d4a9e8a9 | ExcelButton | DMF0048_SalesMonitoring.cs:571 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-c591b092 | ExcelButton | DMF0048_SalesMonitoring.cs:572 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-334c98bb | ExcelButton | DMF0048_SalesMonitoring.cs:573 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-dd55c524 | ExcelButton | DMF0048_SalesMonitoring.cs:574 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-fed7c3b7 | ExcelButton | DMF0048_SalesMonitoring.cs:575 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-b89607d4 | ExcelButton | DMF0048_SalesMonitoring.cs:577 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-c89f2463 | ExcelButton | DMF0048_SalesMonitoring.cs:578 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-4ec2b3cd | ExcelButton | DMF0048_SalesMonitoring.cs:580 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.##0;[Red]-#,##0.##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-5bfe78d2 | ExcelButton | DMF0048_SalesMonitoring.cs:589 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2110a8a | ExcelButton | DMF0048_SalesMonitoring.cs:594 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-5453ae49 | ExcelButton | DMF0048_SalesMonitoring.cs:598 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0048_SalesMonitoring.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f383d21 | FindButton | DMF0048_SalesMonitoring.cs:618 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-27dbe471 | FindButton | DMF0048_SalesMonitoring.cs:625 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4193a28b | FindButton | DMF0048_SalesMonitoring.cs:626 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3bfeef8 | FindButton | DMF0048_SalesMonitoring.cs:629 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4829149f | FindButton | DMF0048_SalesMonitoring.cs:638 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f13f7979 | FindButton | DMF0048_SalesMonitoring.cs:639 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-46c5bfda | FindButton | DMF0048_SalesMonitoring.cs:645 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-36debe1f | FindButton | DMF0048_SalesMonitoring.cs:647 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(3) | 속성 Value2 설정 |  |  |  |
| AC-1f655538 | FindButton | DMF0048_SalesMonitoring.cs:649 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab14668a | FindButton | DMF0048_SalesMonitoring.cs:671 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b9127749 | FindButton | DMF0048_SalesMonitoring.cs:672 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c999f06c | FindButton | DMF0048_SalesMonitoring.cs:676 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b9618995 | FindButton | DMF0048_SalesMonitoring.cs:686 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-59487693 | FindButton | DMF0048_SalesMonitoring.cs:688 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-df59e90c | FindButton | DMF0048_SalesMonitoring.cs:693 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0048_GET_DM_PLN_SALES_MONITORING") ⇒ DM.DMF0048_GET_DM_PLN_SALES_MONITORING | 엔드포인트 요청 생성 |  |  |  |
| AC-cf90199b | FindButton | DMF0048_SalesMonitoring.cs:694 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-988a93d5 | FindButton | DMF0048_SalesMonitoring.cs:696 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-20ca5451 | FindButton | DMF0048_SalesMonitoring.cs:697 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-b12f3a4b | FindButton | DMF0048_SalesMonitoring.cs:698 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-2e1b7aac | FindButton | DMF0048_SalesMonitoring.cs:699 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-2564f089 | FindButton | DMF0048_SalesMonitoring.cs:700 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-f0ef38e9 | FindButton | DMF0048_SalesMonitoring.cs:701 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-2cced56a | FindButton | DMF0048_SalesMonitoring.cs:702 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-31fe4a7d | FindButton | DMF0048_SalesMonitoring.cs:703 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-d53a3ee7 | FindButton | DMF0048_SalesMonitoring.cs:704 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-c8da3dfc | FindButton | DMF0048_SalesMonitoring.cs:705 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-b703580b | FindButton | DMF0048_SalesMonitoring.cs:706 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9b761746 | FindButton | DMF0048_SalesMonitoring.cs:707 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a4b30447 | FindButton | DMF0048_SalesMonitoring.cs:708 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-a041bda7 | FindButton | DMF0048_SalesMonitoring.cs:709 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ab21ffc3 | FindButton | DMF0048_SalesMonitoring.cs:710 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-c53d3e15 | FindButton | DMF0048_SalesMonitoring.cs:711 | try ▸ lambda | DATA_OP | request.Parameters["p_internal_yn"] | (InternalYN.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-c55f528b | FindButton | DMF0048_SalesMonitoring.cs:712 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-dc41be8c | FindButton | DMF0048_SalesMonitoring.cs:713 | try ▸ lambda | DATA_OP | request.Parameters["p_user_dept_id"] | UserInfoContext.Current["Dept_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0c2f975d | FindButton | DMF0048_SalesMonitoring.cs:715 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0c681b32 | FindButton | DMF0048_SalesMonitoring.cs:717 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-67fdfaf4 | FindButton | DMF0048_SalesMonitoring.cs:722 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a344d6dc | FindButton | DMF0048_SalesMonitoring.cs:728 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9eedc80 | FindButton | DMF0048_SalesMonitoring.cs:732 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-98faca6d | FindButton | DMF0048_SalesMonitoring.cs:734 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1c38ea2d | FindButton | DMF0048_SalesMonitoring.cs:735 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-89b15820 | FindButton | DMF0048_SalesMonitoring.cs:739 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8fa83547 | FindButton | DMF0048_SalesMonitoring.cs:753 | try ▸ try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | weekNumber | Convert.ToInt32(ds.Tables[1].Rows[0]["ISO_WEEK"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-570aa61f | FindButton | DMF0048_SalesMonitoring.cs:754 | try ▸ try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | weekDate | Convert.ToDateTime(ds.Tables[1].Rows[0]["BASIS_DATE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-b01bfebf | FindButton | DMF0048_SalesMonitoring.cs:756 | try ▸ try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | this_YYYYMMWW | ds.Tables[1].Rows[0]["THIS_YYYYMMWW"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a2d97671 | FindButton | DMF0048_SalesMonitoring.cs:757 | try ▸ try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | pre_YYYYMMWW | ds.Tables[1].Rows[0]["PRE_YYYYMMWW"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2f9b6e8c | FindButton | DMF0048_SalesMonitoring.cs:762 | try ▸ try ▸ if (dateTime.ToString("yyyyMM") != basis_YYYYMM) | FLAG | sResult_YYYYMMWW | "W_" + dateTime.ToString("yyyyMM") + weekNumber | 화면 필드/플래그 변경 |  |  |  |
| AC-8f7d5015 | FindButton | DMF0048_SalesMonitoring.cs:777 | try ▸ try ▸ else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues != BucketType.Daily) ▸ if … | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-1189e456 | FindButton | DMF0048_SalesMonitoring.cs:779 | try ▸ try ▸ else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues != BucketType.Daily) ▸ if … | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-1d13ac7d | FindButton | DMF0048_SalesMonitoring.cs:785 | try ▸ try ▸ else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues != BucketType.Daily) … | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sPre_YYYYMMDD)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-f9ffe59d | FindButton | DMF0048_SalesMonitoring.cs:789 | try ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7ec838a7 | FindButton | DMF0048_SalesMonitoring.cs:799 | try ▸ try ▸ for (i <= iTotalRowCount) ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-91ee18f0 | FindButton | DMF0048_SalesMonitoring.cs:806 | try ▸ catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBoxForException | (e) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e865a3ac | FindButton | DMF0048_SalesMonitoring.cs:810 | try ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e9e8bfd7 | FindButton | DMF0048_SalesMonitoring.cs:817 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (dtSave != null) | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8465eacb | FindButton | DMF0048_SalesMonitoring.cs:821 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c427d806 | FindButton | DMF0048_SalesMonitoring.cs:826 | try ▸ if (!blnInsert) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iUpdateRow, iUpdateCol) | 그리드 표시 설정 |  |  |  |
| AC-8f0c39f6 | FindButton | DMF0048_SalesMonitoring.cs:827 | try ▸ if (!blnInsert) | CALL_EXT | spdMain.ShowActiveCell | (FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Cente… | ⚠ 의미 확인 필요 |  |  |  |
| AC-174559d4 | FindButton | DMF0048_SalesMonitoring.cs:840 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1fc818d1 | FindButton | DMF0048_SalesMonitoring.cs:842 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9572dd7e | FindButton | DMF0048_SalesMonitoring.cs:846 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-9a755727 | FindButton | DMF0048_SalesMonitoring.cs:850 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-be4f4838 | FindButton | DMF0048_SalesMonitoring.cs:851 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7f2450df | FindButton | DMF0048_SalesMonitoring.cs:852 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0048_SalesMonitoring.fnValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f21a027 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1723 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-06a001af | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1725 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a280ddc | this.Load | DMF0048_SalesMonitoring.cs:230 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-dd5ef9ff | this.Load | DMF0048_SalesMonitoring.cs:231 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0048_SalesMonitoring.GetBizTypebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6a95243 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1061 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-16dca14c | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1062 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-34ac4bfc | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1063 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-467781a7 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1065 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetBizTypebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c885a1b | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1947 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-a988512d | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1948 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-92e913fc | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1949 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ca738262 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1952 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfd4cb23 | this.Load | DMF0048_SalesMonitoring.cs:1008 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DMF0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-ff182d50 | this.Load | DMF0048_SalesMonitoring.cs:1009 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-59682105 | this.Load | DMF0048_SalesMonitoring.cs:1011 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4f2a59d | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1736 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-341f0d1a | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1047 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-4d27cf27 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1048 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-6daf1d11 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1049 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-cfb5e5e3 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1050 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ef82973e | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1052 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetCustomerbyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89f08231 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1974 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-8eb60446 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1975 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7039dbe4 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1976 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-b2c2969f | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1977 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f9bb947e | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1980 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetDataTableMeargeForDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-870231d8 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2072 | if (sfpInfo.SpreadObject.DataSource == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-025fa7d2 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2077 |  | CALL_EXT | sv.GetArray | (0, 0, sv.RowCount - 1, sv.ColumnCount - 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9735314a | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2100 | for (i < sv.ColumnCount) ▸ if (sFieldName.IndexOf("D_2") >= 0 \|\| sFieldName.IndexOf("W_2") >= 0 \|\| sFieldName.IndexOf("M_2") >= 0) | DATA_OP | table.Columns.Add | (sFieldName, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1c7f6e9 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2103 | for (i < sv.ColumnCount) ▸ else of (sFieldName.IndexOf("D_2") >= 0 \|\| sFieldName.IndexOf("W_2") >= 0 \|\| sFieldName.IndexOf("M_2") >= 0) | DATA_OP | table.Columns.Add | (sFieldName, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfea21b6 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2106 |  | DATA_OP | ds2.Tables.Add | (table) | 데이터 객체 조작/조회 |  |  |  |
| AC-649f39c5 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2110 |  | DATA_OP | ds.Tables[0].Merge | (ds2.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc7e8556 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2112 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-958b5afb | this.Load | DMF0048_SalesMonitoring.cs:992 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-fe64cebd | this.Load | DMF0048_SalesMonitoring.cs:993 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-34d0b133 | this.Load | DMF0048_SalesMonitoring.cs:994 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-3c95d2da | this.Load | DMF0048_SalesMonitoring.cs:996 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-64c09e9f | this.Load | DMF0048_SalesMonitoring.cs:999 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca61d671 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:962 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-5acebbe2 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:964 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d57c1425 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:967 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb821288 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1074 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d4e90b85 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1075 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-0d09aee5 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1076 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-4c02631f | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1077 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e626a76c | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1079 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetItemType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbc2afc7 | this.Load | DMF0048_SalesMonitoring.cs:1020 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-84850e62 | this.Load | DMF0048_SalesMonitoring.cs:1021 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-e5038a4a | this.Load | DMF0048_SalesMonitoring.cs:1022 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5e9a8264 | this.Load | DMF0048_SalesMonitoring.cs:1024 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetPlantSitebyEndCustomer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a99becb | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1787 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-e90eb6ac | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1788 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-db38bfdd | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1789 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-ac545a6c | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1790 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-ef70e3fa | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1791 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-52ea9c24 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1794 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetPlantSitebyEndCustomerAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-104f5eaf | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1989 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-0e70923a | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1990 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d23195f8 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1991 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-0085ebde | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1992 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-6c64a7ee | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1993 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5a089aac | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1996 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetScmSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-deb521e4 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:976 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-42cb855f | (진입점 미연결) | DMF0048_SalesMonitoring.cs:977 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c3aad87f | (진입점 미연결) | DMF0048_SalesMonitoring.cs:978 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-1b592d6d | (진입점 미연결) | DMF0048_SalesMonitoring.cs:979 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-beeb9754 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:980 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3a0df304 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:983 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetScmSitebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-024b2c6f | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2005 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-161e12b8 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2006 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-5680c633 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2007 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-a8190125 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2008 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-e9da7f9c | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2009 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-260f7964 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:2012 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ try ▸ else of (dtSta…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8000a3b8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:535 |  | FLAG | fBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-d3c576e7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:540 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0048_GET_SPREAD_TITLE") ⇒ DM.DMF0048_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-8613e9fd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:541 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-d61c7cbe | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:542 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-3f39fc53 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:543 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7a9797c4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:544 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-5b872e97 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:545 |  | DATA_OP | request.Parameters["p_bucket"] | fBucket | 행/컬럼 값 대입 |  |  |  |
| AC-d28bfbc4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:547 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ab6c6b87 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:547 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-588ecefa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:550 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fcab827 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1034 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-23f9bf49 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1035 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3ddb1b10 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1036 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8831aef5 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1038 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetTeambyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6673930f | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1961 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-de698058 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1962 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-12af1243 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1963 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fabe4ea9 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1965 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.GetThisWeekMonday

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc59ed98 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1815 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesMonitoring.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e03a5432 | this.Load | DMF0048_SalesMonitoring.cs:325 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-46806201 | this.Load | DMF0048_SalesMonitoring.cs:332 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1b4c22bb | this.Load | DMF0048_SalesMonitoring.cs:344 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6ae28e4b | this.Load | DMF0048_SalesMonitoring.cs:351 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-add08f69 | this.Load | DMF0048_SalesMonitoring.cs:352 | if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e13aa198 | this.Load | DMF0048_SalesMonitoring.cs:353 | if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8789e6da | this.Load | DMF0048_SalesMonitoring.cs:355 | if (sDivision == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2236363b | this.Load | DMF0048_SalesMonitoring.cs:356 | if (sDivision == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-8fbd2a1b | this.Load | DMF0048_SalesMonitoring.cs:364 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-119fbe37 | this.Load | DMF0048_SalesMonitoring.cs:371 | else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-31822561 | this.Load | DMF0048_SalesMonitoring.cs:372 | else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-43560bab | this.Load | DMF0048_SalesMonitoring.cs:373 | else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9fe6e313 | this.Load | DMF0048_SalesMonitoring.cs:380 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bdc51245 | this.Load | DMF0048_SalesMonitoring.cs:381 |  | VALUE_SET | chkColor.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-9a67a74c | this.Load | DMF0048_SalesMonitoring.cs:382 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-72d9c2bd | this.Load | DMF0048_SalesMonitoring.cs:384 |  | UI_PROP | layoutControlItem10.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4f72bb7c | this.Load | DMF0048_SalesMonitoring.cs:386 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e5fcbb0c | this.Load | DMF0048_SalesMonitoring.cs:393 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6ca85df5 | this.Load | DMF0048_SalesMonitoring.cs:399 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-491e00df | this.Load | DMF0048_SalesMonitoring.cs:401 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-664a8d91 | this.Load | DMF0048_SalesMonitoring.cs:402 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-92bb65cb | this.Load | DMF0048_SalesMonitoring.cs:404 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-9b26fa1e | this.Load | DMF0048_SalesMonitoring.cs:406 |  | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-65103032 | this.Load | DMF0048_SalesMonitoring.cs:407 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3ac9bf43 | this.Load | DMF0048_SalesMonitoring.cs:412 |  | FLAG | dtITEM_ID | Data.Common(Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], Us… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-24f65de8 | this.Load | DMF0048_SalesMonitoring.cs:412 |  | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-89af4080 | this.Load | DMF0048_SalesMonitoring.cs:415 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-5faec708 | this.Load | DMF0048_SalesMonitoring.cs:415 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DMF0048_SalesMonitoring.InitSaveDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18ca45ee | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1548 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-0abc599d | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1549 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b01d374 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1550 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PROJECT_CODE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-88cc9f89 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1551 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.SCM_SITE_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca219891 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1552 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ITEM_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-04d6065c | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1553 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DomExp, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c22b432 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1554 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.INCOTERMS, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e376d5eb | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1555 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b46d743 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1556 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.MEASURE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8967479d | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1557 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-595dec18 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1558 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Qty, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0048_SalesMonitoring.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily)] / this.Load / this.clbDivision.SelectedIndexChanged [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ac01a8b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:484 | try ▸ if (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1008afe | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:490 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-6a0d2ef9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:491 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-8f94e013 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:496 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-57e30ad4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:506 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## DMF0048_SalesMonitoring.InitSpreadFooterSum

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ try ▸ else of (dtSta…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2292c0ea | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:516 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b355565e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:517 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-08170197 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:524 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-238c5021 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:525 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf60d191 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:526 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-6b680ec6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:527 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0048_SalesMonitoring.SetChangeControl

진입점: this.clbCustomer.SelectedIndexChanged / this.clbTeam.SelectedIndexChanged [if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") \|\| (clbDivision.SelectedValue.ToString() == "82"))] / this.Load / this.clbDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6686de83 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:256 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ec24d1dc | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:257 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e8883ffa | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:263 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-88a00c49 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:263 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-12571eb9 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:268 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-bdd9def7 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:270 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6c457b0b | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:270 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c89faedc | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:275 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c1024505 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:276 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-7949f6d6 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:278 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d42e4024 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:278 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-07100fb7 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:283 | switch (triggerControl) case "BizType": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-93f57985 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:285 | switch (triggerControl) case "BizType": | FLAG | dtBizType | DataService.GetDMInnerTable("BizType", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d46e7c77 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:285 | switch (triggerControl) case "BizType": | COMBO_DATA | DataService.GetDMInnerTable | ("BizType", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0bebc1ae | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:290 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-93b500ff | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:291 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-72e46786 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:292 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-af021c03 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:294 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6a486f41 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:294 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8a973985 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:299 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-cbea2202 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:300 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-9cfa217c | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:302 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | FLAG | dtPlantSite | DataService.GetDMInnerTable("UserPlantSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-63099bef | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:302 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-84dd7e94 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:307 | switch (triggerControl) case "UserPlantSiteByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d33f0b84 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:309 | switch (triggerControl) case "UserPlantSiteByDivision": | FLAG | dtPlantSiteByDivision | DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4ec14f8e | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0048_SalesMonitoring.cs:309 | switch (triggerControl) case "UserPlantSiteByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0048_SalesMonitoring.setResultPeriod

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ else of (chkColor.Checked == false) ▸ if (chkColor.Checked == true)] / FindButton [try ▸ try ▸ if (chkColor.Checked == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bd09e05 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0048_SalesMonitoring.cs:870 | if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, 0, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), Color.White) | 그리드 표시 설정 |  |  |  |
| AC-20d2b64a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0048_SalesMonitoring.cs:946 | if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.GetMaxRowIndex(), iResultCol, Co… | 그리드 표시 설정 |  |  |  |
| AC-7e44f7ac | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0048_SalesMonitoring.cs:948 | if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |

## DMF0048_SalesMonitoring.SetSaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-722b0b02 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1574 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-a726bbd2 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1578 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-62b8b620 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1579 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DIVISION_ID] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9e686cf8 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1580 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.PROJECT_CODE] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-fcfa46a4 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1581 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.SCM_SITE_ID] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-4db24b7f | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1582 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ITEM_ID] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-7a3ece02 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1583 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DomExp] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-c8dc2a5e | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1584 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-ad3c2ade | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1585 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.INCOTERMS] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-d302fdb7 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1586 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.MEASURE] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-9231c99f | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1587 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-29e8395f | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1588 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-0022417d | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1590 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c0e09b3 | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1591 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eeea984a | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1595 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-dac22a5e | (진입점 미연결) | DMF0048_SalesMonitoring.cs:1596 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0048_SalesMonitoring.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.chkColor.CheckedChanged [if (siMain != null)] / this.Load [try ▸ el…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c0ca04c | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1193 |  | FLAG | sResult_YYYYMMDD | dateTime.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-f51733dd | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1194 |  | FLAG | sPre_YYYYMMDD | DateTime.Today.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-d447e444 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1202 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6619aeb9 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1204 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-189f1bea | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1209 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a28691d6 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1211 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ec4b3ce8 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1214 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-2679ac39 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1219 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8196009b | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1221 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c89b5339 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1226 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) | GRID_STYLE | siMain.ActiveSheet.ColumnHeader.Columns[siMain.GetColumnTag(iCol)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-0d89dc04 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1227 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) | CALL_EXT | siMain.ActiveSheet.ColumnHeader.Columns[siMain.GetColumnTag(iCol)].ResetFont | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b16fb49 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1234 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-2a0c8906 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1235 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-46bb1c69 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1236 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Width | 60 | 그리드 속성/값 설정 |  |  |  |
| AC-40241f1c | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1243 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-4c9117e3 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1244 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-78074248 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1251 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-13e0f1ca | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1252 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-ae9200d2 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1263 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-803b6229 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1264 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-3ac415b3 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1265 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Width | 60 | 그리드 속성/값 설정 |  |  |  |
| AC-16f623de | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1272 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-f0aedf97 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1273 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-55ec58c9 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1280 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-663bf114 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1281 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-f82a0b2a | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1289 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkColor.Checked == false) ▸ if (chkColor.Checked == true) | GRID_STYLE | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-438aa6d2 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0048_SalesMonitoring.cs:1290 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkColor.Checked == false) ▸ if (chkColor.Checked == true) | CALL_EXT | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetFont | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0048_SalesMonitoring.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ try ▸ else of (dtSta…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0de2b23 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1321 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0ee9918a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1329 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f889c28e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1342 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-3cad0440 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1349 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b3b1093a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1350 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ed336629 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1355 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5c69576a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1356 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a51605df | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1363 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8dea695 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1364 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b17cebc1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1375 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17ee0358 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1376 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a5d8b79a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1377 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c6d6de7f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1378 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b1cf07f9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1380 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2115c0de | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0048_SalesMonitoring.cs:1382 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0048_SalesMonitoring.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39f3f016 | this.spdMain.TopChange | DMF0048_SalesMonitoring.cs:1125 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0048_SalesPlanMonitoring.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7915652c | this.btnColumn.Click | DMF0048_SalesPlanMonitoring.cs:1134 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-6d88c031 | this.btnColumn.Click | DMF0048_SalesPlanMonitoring.cs:1135 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ddf1429b | this.btnColumn.Click | DMF0048_SalesPlanMonitoring.cs:1136 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0048_SalesPlanMonitoring.btnItemId_Click

진입점: this.btnItemId.Click / this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ff367c1 | this.btnItemId.Click 외 1 | DMF0048_SalesPlanMonitoring.cs:843 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-a8e5397e | this.btnItemId.Click 외 1 | DMF0048_SalesPlanMonitoring.cs:846 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9b450ae2 | this.btnItemId.Click 외 1 | DMF0048_SalesPlanMonitoring.cs:847 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6a58bbd4 | this.btnItemId.Click 외 1 | DMF0048_SalesPlanMonitoring.cs:848 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bdbc6d3e | this.btnItemId.Click 외 1 | DMF0048_SalesPlanMonitoring.cs:850 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0048_SalesPlanMonitoring.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4081c060 | this.btnMeasure.Click | DMF0048_SalesPlanMonitoring.cs:1147 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-11edba3b | this.btnMeasure.Click | DMF0048_SalesPlanMonitoring.cs:1148 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c33237bc | this.btnMeasure.Click | DMF0048_SalesPlanMonitoring.cs:1149 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0048_SalesPlanMonitoring.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2fc7070 | this.btnOwner.Click | DMF0048_SalesPlanMonitoring.cs:1284 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-35022ebb | this.btnOwner.Click | DMF0048_SalesPlanMonitoring.cs:1287 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-37914174 | this.btnOwner.Click | DMF0048_SalesPlanMonitoring.cs:1288 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b7f3633f | this.btnOwner.Click | DMF0048_SalesPlanMonitoring.cs:1289 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fe5eff1f | this.btnOwner.Click | DMF0048_SalesPlanMonitoring.cs:1291 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0048_SalesPlanMonitoring.btnProject_Click

진입점: this.btnProject.Click / this.layoutControlItem3.Click / this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d091a32 | this.btnProject.Click 외 2 | DMF0048_SalesPlanMonitoring.cs:823 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-3e58b596 | this.btnProject.Click 외 2 | DMF0048_SalesPlanMonitoring.cs:824 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-4930ca82 | this.btnProject.Click 외 2 | DMF0048_SalesPlanMonitoring.cs:825 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-84c4b239 | this.btnProject.Click 외 2 | DMF0048_SalesPlanMonitoring.cs:826 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d75e563a | this.btnProject.Click 외 2 | DMF0048_SalesPlanMonitoring.cs:828 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0048_SalesPlanMonitoring.cboBucketType_Click

진입점: this.cboBucketType.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4132e14e | this.cboBucketType.Click | DMF0048_SalesPlanMonitoring.cs:1300 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | MESSAGE | MessageHelper.GMessageBox | ("MSG00227") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81a3edec | this.cboBucketType.Click | DMF0048_SalesPlanMonitoring.cs:1301 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesPlanMonitoring.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10292401 | this.clbCustomer.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1159 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ef12df06 | this.clbCustomer.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1159 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-63a31148 | this.clbCustomer.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1160 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0048_SalesPlanMonitoring.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7384d5b | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1171 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc0f0f1a | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1174 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a1581be5 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1178 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-059171dd | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1178 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf79954c | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1179 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fd381a7f | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1187 | try ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-29123791 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1187 | try ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fa1f054e | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1188 | try ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2a85a7a3 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1190 | try ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-2456baf2 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1190 | try ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-141cbb1b | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1193 | try ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-38e5b1d6 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1194 | try ▸ if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cbc27154 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1195 | try ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b62847cf | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1196 | try ▸ if (sDivision == "40") | STATE | cboUnitYN.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5ccd4024 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1198 | try ▸ if (sDivision == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-035261b4 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1199 | try ▸ if (sDivision == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-f1568ced | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1203 | try ▸ else of (sDivision == "40") | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-93e8ac04 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1204 | try ▸ else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ba9188d7 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1206 | try ▸ else of (sDivision == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-42e49d93 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1206 | try ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-871bfe42 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1209 | try ▸ else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-15fb0a47 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1210 | try ▸ else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2d10045c | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1211 | try ▸ else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5620146b | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1212 | try ▸ else of (sDivision == "40") | STATE | cboUnitYN.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d2ae428d | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1218 | try | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f47d8568 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1220 | try | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d5486d0b | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1224 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4304625a | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1224 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a7fd77dc | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1225 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-de11bb8f | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1227 | try | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-48fb7006 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1227 | try | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9cdfe3a9 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1228 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-16a3a3a1 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1230 | try | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-5f78dc4b | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1231 | try | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-5876dc06 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1232 | try | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-8a2fc230 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1238 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1f68a9a8 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1239 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-aa850003 | this.clbDivision.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1243 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0048_SalesPlanMonitoring.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb87cb4a | this.clbTeam.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1255 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-073f5fda | this.clbTeam.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1255 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2feb4c40 | this.clbTeam.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1256 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5c138e0a | this.clbTeam.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1258 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-9d440f4f | this.clbTeam.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1258 | if ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4a4a2b3b | this.clbTeam.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1262 | else of ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-1675ef5d | this.clbTeam.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1262 | else of ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c99a233e | this.clbTeam.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1263 | else of ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6e45bfc9 | this.clbTeam.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1267 | else of ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-a560ad3a | this.clbTeam.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1267 | else of ((clbDivision.SelectedValue.ToString() == "81") \|\| (clbDivision.SelectedValue.ToString() == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-132feba8 | this.clbTeam.SelectedIndexChanged | DMF0048_SalesPlanMonitoring.cs:1270 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0048_SalesPlanMonitoring.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6511dc8 | this.Load | DMF0048_SalesPlanMonitoring.cs:335 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4e5d53f3 | this.Load | DMF0048_SalesPlanMonitoring.cs:336 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2edb134c | this.Load | DMF0048_SalesPlanMonitoring.cs:337 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0048_SalesPlanMonitoring.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86d48bb2 | this.Load | DMF0048_SalesPlanMonitoring.cs:297 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-5df79083 | this.Load | DMF0048_SalesPlanMonitoring.cs:298 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-f29d2207 | this.Load | DMF0048_SalesPlanMonitoring.cs:300 |  | UI_PROP | usrConditionPanel2.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-06fdd19b | this.Load | DMF0048_SalesPlanMonitoring.cs:303 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-661a242e | this.Load | DMF0048_SalesPlanMonitoring.cs:305 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-24206a9f | this.Load | DMF0048_SalesPlanMonitoring.cs:307 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-bda17a12 | this.Load | DMF0048_SalesPlanMonitoring.cs:308 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-84de8c22 | this.Load | DMF0048_SalesPlanMonitoring.cs:309 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-fdde43e5 | this.Load | DMF0048_SalesPlanMonitoring.cs:310 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DMF0048_SalesPlanMonitoring.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-032a4ade | Dispose | DMF0048_SalesPlanMonitoring.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0048_SalesPlanMonitoring.Dsdm_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f270ef45 | dsdm.Changed | DMF0048_SalesPlanMonitoring.cs:1002 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dbc38180 | dsdm.Changed | DMF0048_SalesPlanMonitoring.cs:1007 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a31c224e | dsdm.Changed | DMF0048_SalesPlanMonitoring.cs:1008 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-af03cd55 | dsdm.Changed | DMF0048_SalesPlanMonitoring.cs:1009 | if (siMain.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5d81b91 | dsdm.Changed | DMF0048_SalesPlanMonitoring.cs:1018 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2365d158 | dsdm.Changed | DMF0048_SalesPlanMonitoring.cs:1023 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-4a451fb4 | dsdm.Changed | DMF0048_SalesPlanMonitoring.cs:1024 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2bf0b04c | dsdm.Changed | DMF0048_SalesPlanMonitoring.cs:1028 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row, e.Column, e.Row, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc2c3b54 | dsdm.Changed | DMF0048_SalesPlanMonitoring.cs:1055 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 2, iWeeklySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-adfa5cb8 | dsdm.Changed | DMF0048_SalesPlanMonitoring.cs:1079 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |

## DMF0048_SalesPlanMonitoring.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ecbb97f | FindButton | DMF0048_SalesPlanMonitoring.cs:462 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f3d3ded4 | FindButton | DMF0048_SalesPlanMonitoring.cs:469 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35d022fa | FindButton | DMF0048_SalesPlanMonitoring.cs:470 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-559a1614 | FindButton | DMF0048_SalesPlanMonitoring.cs:473 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f9d11b64 | FindButton | DMF0048_SalesPlanMonitoring.cs:482 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-529a50b5 | FindButton | DMF0048_SalesPlanMonitoring.cs:483 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45a6130b | FindButton | DMF0048_SalesPlanMonitoring.cs:489 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-97ba340c | FindButton | DMF0048_SalesPlanMonitoring.cs:491 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(3) | 속성 Value2 설정 |  |  |  |
| AC-dd492274 | FindButton | DMF0048_SalesPlanMonitoring.cs:493 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87dd1d75 | FindButton | DMF0048_SalesPlanMonitoring.cs:512 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-73620357 | FindButton | DMF0048_SalesPlanMonitoring.cs:513 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96f451c5 | FindButton | DMF0048_SalesPlanMonitoring.cs:517 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4176326c | FindButton | DMF0048_SalesPlanMonitoring.cs:527 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-042cd576 | FindButton | DMF0048_SalesPlanMonitoring.cs:528 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-92f0ff7f | FindButton | DMF0048_SalesPlanMonitoring.cs:533 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0048_GET_DM_PLN_SALES_MONITORING") ⇒ DM.DMF0048_GET_DM_PLN_SALES_MONITORING | 엔드포인트 요청 생성 |  |  |  |
| AC-cf15fedc | FindButton | DMF0048_SalesPlanMonitoring.cs:534 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9bd945aa | FindButton | DMF0048_SalesPlanMonitoring.cs:536 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ed2bb425 | FindButton | DMF0048_SalesPlanMonitoring.cs:537 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-56ad912e | FindButton | DMF0048_SalesPlanMonitoring.cs:538 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-bcc3e4cb | FindButton | DMF0048_SalesPlanMonitoring.cs:539 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-40f7a41c | FindButton | DMF0048_SalesPlanMonitoring.cs:540 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-108d1250 | FindButton | DMF0048_SalesPlanMonitoring.cs:541 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a6138c34 | FindButton | DMF0048_SalesPlanMonitoring.cs:542 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-65bb8550 | FindButton | DMF0048_SalesPlanMonitoring.cs:543 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-3f1647a6 | FindButton | DMF0048_SalesPlanMonitoring.cs:544 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e98d2183 | FindButton | DMF0048_SalesPlanMonitoring.cs:545 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-33bd7874 | FindButton | DMF0048_SalesPlanMonitoring.cs:546 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-65f85b75 | FindButton | DMF0048_SalesPlanMonitoring.cs:547 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-47c83d1a | FindButton | DMF0048_SalesPlanMonitoring.cs:548 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-989477be | FindButton | DMF0048_SalesPlanMonitoring.cs:549 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-e6ea54f0 | FindButton | DMF0048_SalesPlanMonitoring.cs:550 | try ▸ lambda | DATA_OP | request.Parameters["p_internal_yn"] | (InternalYN.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-aa88b99e | FindButton | DMF0048_SalesPlanMonitoring.cs:551 | try ▸ lambda | DATA_OP | request.Parameters["p_unit_yn"] | (cboUnitYN.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-bb6e8c0a | FindButton | DMF0048_SalesPlanMonitoring.cs:553 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7f783c78 | FindButton | DMF0048_SalesPlanMonitoring.cs:555 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c001adf8 | FindButton | DMF0048_SalesPlanMonitoring.cs:560 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad606f23 | FindButton | DMF0048_SalesPlanMonitoring.cs:566 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-13add37b | FindButton | DMF0048_SalesPlanMonitoring.cs:570 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ac15a51d | FindButton | DMF0048_SalesPlanMonitoring.cs:572 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-03a9b610 | FindButton | DMF0048_SalesPlanMonitoring.cs:573 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e661826c | FindButton | DMF0048_SalesPlanMonitoring.cs:577 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b3bc91f | FindButton | DMF0048_SalesPlanMonitoring.cs:658 | try ▸ try ▸ if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.GetMaxRowIndex(), iResultCol, Co… | 그리드 표시 설정 |  |  |  |
| AC-b0a048e8 | FindButton | DMF0048_SalesPlanMonitoring.cs:660 | try ▸ try ▸ if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-742a6e44 | FindButton | DMF0048_SalesPlanMonitoring.cs:662 | try ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4982d45f | FindButton | DMF0048_SalesPlanMonitoring.cs:672 | try ▸ try ▸ for (i <= iTotalRowCount) ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-65b4aedb | FindButton | DMF0048_SalesPlanMonitoring.cs:679 | try ▸ catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBoxForException | (e) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e5a1b9d | FindButton | DMF0048_SalesPlanMonitoring.cs:683 | try ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-50685ff8 | FindButton | DMF0048_SalesPlanMonitoring.cs:692 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-08c1fb54 | FindButton | DMF0048_SalesPlanMonitoring.cs:697 | try ▸ if (!blnInsert) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iUpdateRow, iUpdateCol) | 그리드 표시 설정 |  |  |  |
| AC-cf401bd7 | FindButton | DMF0048_SalesPlanMonitoring.cs:698 | try ▸ if (!blnInsert) | CALL_EXT | spdMain.ShowActiveCell | (FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Cente… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5844136a | FindButton | DMF0048_SalesPlanMonitoring.cs:711 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40729dce | FindButton | DMF0048_SalesPlanMonitoring.cs:713 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8ac73835 | FindButton | DMF0048_SalesPlanMonitoring.cs:717 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-4e5ac626 | FindButton | DMF0048_SalesPlanMonitoring.cs:721 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7a84db47 | FindButton | DMF0048_SalesPlanMonitoring.cs:722 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-77d63f49 | FindButton | DMF0048_SalesPlanMonitoring.cs:723 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0048_SalesPlanMonitoring.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c67ca7e | this.Load | DMF0048_SalesPlanMonitoring.cs:207 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c89cc837 | this.Load | DMF0048_SalesPlanMonitoring.cs:208 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0048_SalesPlanMonitoring.GetBizTypebyDivision

진입점: this.Load [else of (sDivision == "40")] / this.clbDivision.SelectedIndexChanged [try ▸ else of (sDivision == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3aa1f721 | this.Load [else of (sDivision == "40")] 외 1 | DMF0048_SalesPlanMonitoring.cs:781 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-698d864b | this.Load [else of (sDivision == "40")] 외 1 | DMF0048_SalesPlanMonitoring.cs:782 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-74c0a5ca | this.Load [else of (sDivision == "40")] 외 1 | DMF0048_SalesPlanMonitoring.cs:783 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d3f49b10 | this.Load [else of (sDivision == "40")] 외 1 | DMF0048_SalesPlanMonitoring.cs:785 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesPlanMonitoring.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d42129a | this.Load | DMF0048_SalesPlanMonitoring.cs:756 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-61c68796 | this.Load | DMF0048_SalesPlanMonitoring.cs:757 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5316e7f9 | this.Load | DMF0048_SalesPlanMonitoring.cs:759 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesPlanMonitoring.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-200a1c01 | this.Load | DMF0048_SalesPlanMonitoring.cs:740 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-41a902a1 | this.Load | DMF0048_SalesPlanMonitoring.cs:741 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-54357062 | this.Load | DMF0048_SalesPlanMonitoring.cs:742 |  | DATA_OP | request.Parameters["p_month"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-5719c8e8 | this.Load | DMF0048_SalesPlanMonitoring.cs:744 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e9a8d621 | this.Load | DMF0048_SalesPlanMonitoring.cs:747 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesPlanMonitoring.GetItemType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af5c525f | this.Load | DMF0048_SalesPlanMonitoring.cs:768 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-7f9f3803 | this.Load | DMF0048_SalesPlanMonitoring.cs:769 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-12f4da64 | this.Load | DMF0048_SalesPlanMonitoring.cs:770 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-323ed532 | this.Load | DMF0048_SalesPlanMonitoring.cs:772 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesPlanMonitoring.GetSALESPLAN_MEASUREInfo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-132316d4 | this.Load | DMF0048_SalesPlanMonitoring.cs:794 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0021_GET_SALES_PLAN_MEASUREINFO") ⇒ DM.DMF0021_GET_SALES_PLAN_MEASUREINFO | 엔드포인트 요청 생성 |  |  |  |
| AC-8b134101 | this.Load | DMF0048_SalesPlanMonitoring.cs:795 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d5de7b54 | this.Load | DMF0048_SalesPlanMonitoring.cs:797 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesPlanMonitoring.GetSALESPLAN_MEASUREInfo2

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e991d8a6 | this.Load | DMF0048_SalesPlanMonitoring.cs:807 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0021_GET_SALES_PLAN_MEASUREINFO2") ⇒ DM.DMF0021_GET_SALES_PLAN_MEASUREINFO2 | 엔드포인트 요청 생성 |  |  |  |
| AC-43987c97 | this.Load | DMF0048_SalesPlanMonitoring.cs:808 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-df6add4e | this.Load | DMF0048_SalesPlanMonitoring.cs:810 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesPlanMonitoring.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.Load [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.clbDivision.SelectedIndexChang…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a31d9757 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:412 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0048_GET_SPREAD_TITLE") ⇒ DM.DMF0048_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-4ba7f58c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:413 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-361582b8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:414 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-5af921d9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:415 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5335839e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:416 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-89b94fdc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:418 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-9b74c559 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:418 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f6a9562 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:421 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0048_SalesPlanMonitoring.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca486c44 | this.Load | DMF0048_SalesPlanMonitoring.cs:223 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-5a16f811 | this.Load | DMF0048_SalesPlanMonitoring.cs:223 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-22fed093 | this.Load | DMF0048_SalesPlanMonitoring.cs:224 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-add7c8d6 | this.Load | DMF0048_SalesPlanMonitoring.cs:227 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-2cedab8c | this.Load | DMF0048_SalesPlanMonitoring.cs:227 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ddd96464 | this.Load | DMF0048_SalesPlanMonitoring.cs:228 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-61a67fe4 | this.Load | DMF0048_SalesPlanMonitoring.cs:235 | if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-8bb2944c | this.Load | DMF0048_SalesPlanMonitoring.cs:235 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1adf7c52 | this.Load | DMF0048_SalesPlanMonitoring.cs:236 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6d16978f | this.Load | DMF0048_SalesPlanMonitoring.cs:238 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-a15b6f07 | this.Load | DMF0048_SalesPlanMonitoring.cs:238 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-679d90f2 | this.Load | DMF0048_SalesPlanMonitoring.cs:240 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f8289a27 | this.Load | DMF0048_SalesPlanMonitoring.cs:241 | if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f25575c2 | this.Load | DMF0048_SalesPlanMonitoring.cs:242 | if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7ab1b72a | this.Load | DMF0048_SalesPlanMonitoring.cs:243 | if (sDivision == "40") | STATE | cboUnitYN.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3f6ccea3 | this.Load | DMF0048_SalesPlanMonitoring.cs:245 | if (sDivision == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0e585f87 | this.Load | DMF0048_SalesPlanMonitoring.cs:246 | if (sDivision == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-ac65b0e1 | this.Load | DMF0048_SalesPlanMonitoring.cs:250 | else of (sDivision == "40") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-8ca3084e | this.Load | DMF0048_SalesPlanMonitoring.cs:251 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b22ad39d | this.Load | DMF0048_SalesPlanMonitoring.cs:253 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-9eb18b63 | this.Load | DMF0048_SalesPlanMonitoring.cs:253 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-73956c75 | this.Load | DMF0048_SalesPlanMonitoring.cs:255 | else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d04cce13 | this.Load | DMF0048_SalesPlanMonitoring.cs:256 | else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fd2bd4f1 | this.Load | DMF0048_SalesPlanMonitoring.cs:257 | else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7a0f1f69 | this.Load | DMF0048_SalesPlanMonitoring.cs:258 | else of (sDivision == "40") | STATE | cboUnitYN.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7e1cb735 | this.Load | DMF0048_SalesPlanMonitoring.cs:262 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e9e8e13e | this.Load | DMF0048_SalesPlanMonitoring.cs:264 |  | UI_PROP | layoutControlItem10.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3bdacfb1 | this.Load | DMF0048_SalesPlanMonitoring.cs:266 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cb46cfa3 | this.Load | DMF0048_SalesPlanMonitoring.cs:269 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0e2dc0a0 | this.Load | DMF0048_SalesPlanMonitoring.cs:269 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-099f6f2e | this.Load | DMF0048_SalesPlanMonitoring.cs:270 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8057daf5 | this.Load | DMF0048_SalesPlanMonitoring.cs:272 |  | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-31e44798 | this.Load | DMF0048_SalesPlanMonitoring.cs:272 |  | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-69ceaa19 | this.Load | DMF0048_SalesPlanMonitoring.cs:273 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-89d9ba5c | this.Load | DMF0048_SalesPlanMonitoring.cs:275 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-258b4850 | this.Load | DMF0048_SalesPlanMonitoring.cs:276 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8691520f | this.Load | DMF0048_SalesPlanMonitoring.cs:278 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-e06428ac | this.Load | DMF0048_SalesPlanMonitoring.cs:280 |  | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-b07e309f | this.Load | DMF0048_SalesPlanMonitoring.cs:281 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b5b97256 | this.Load | DMF0048_SalesPlanMonitoring.cs:283 |  | FLAG | dtITEM_ID | Data.Common(Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], Us… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-7af867d0 | this.Load | DMF0048_SalesPlanMonitoring.cs:283 |  | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-104b3d3e | this.Load | DMF0048_SalesPlanMonitoring.cs:286 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-fff70909 | this.Load | DMF0048_SalesPlanMonitoring.cs:286 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ad3d06f9 | this.Load | DMF0048_SalesPlanMonitoring.cs:289 |  | FLAG | dtMearsure | GetSALESPLAN_MEASUREInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-466568f6 | this.Load | DMF0048_SalesPlanMonitoring.cs:290 |  | FLAG | dtMearsure2 | GetSALESPLAN_MEASUREInfo2() | 화면 필드/플래그 변경 |  |  |  |

## DMF0048_SalesPlanMonitoring.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.clbDivision.SelectedIndexChanged [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1166a6e9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:357 | try ▸ if (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-83002b4d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:363 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-3b4204ab | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:364 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-8a2986e3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:369 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-5cacc824 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:378 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## DMF0048_SalesPlanMonitoring.InitSpreadFooterSum

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.Load [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.clbDivision.SelectedIndexChang…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e608a6f8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:389 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b0b9e84f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:390 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-60e63466 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:397 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fa65615 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:398 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b947161 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:399 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-9943ac71 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:400 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0048_SalesPlanMonitoring.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPerio…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a940f38b | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0048_SalesPlanMonitoring.cs:883 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f8bc8374 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0048_SalesPlanMonitoring.cs:885 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-35f99ae0 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0048_SalesPlanMonitoring.cs:890 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fbab3929 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0048_SalesPlanMonitoring.cs:892 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-398590c1 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0048_SalesPlanMonitoring.cs:895 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-819a7606 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0048_SalesPlanMonitoring.cs:900 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6a7d1434 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0048_SalesPlanMonitoring.cs:902 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0048_SalesPlanMonitoring.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.Load [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.clbDivision.SelectedIndexChang…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6f1ee81 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:934 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f738e6a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:942 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-41ef4e9b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:955 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-391c86b6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:962 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5eaaf452 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:963 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b2fe12bf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:968 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-624d0dca | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:969 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c048a8c7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:976 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd8634ae | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:977 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d3c66aa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:988 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72e65e57 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:989 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-782e48e9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:990 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7783fbe9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:991 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94a23d35 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:993 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-449adf17 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0048_SalesPlanMonitoring.cs:995 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0048_SalesPlanMonitoring.spdMain_TopChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12f8c1cb | (진입점 미연결) | DMF0048_SalesPlanMonitoring.cs:856 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |


# AS-IS 액션 대조표 — SCP0048

> 원천: `Doc/asisfacts/screens/SCP0048/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 505행 · 메서드 51 · 종류 DATA_OP 220 · FLAG 50 · RETURN 45 · GRID_SET 29 · MESSAGE 23 · ENDPOINT 19 · GRID_LOCK 15 · COMBO_DATA 11 · POPUP 11 · UI_MISC 10 · LIST_REBIND 10 · UI_PROP 10 · CALL_EXT 9 · GRID_STYLE 9 · GRID_INIT 8 · VALUE_SET 7 · GRID_COMBO 6 · STATE 5 · VALIDATE 3 · GRID_BIND 2 · STATE_RESET 2 · GRID_CLEAR 1 · ⚠ 의미 확인 필요 9


## SCP0048_ItembyDivisionPopupEx.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4eb165e1 | this.btnButtonList.UsrButtonList_Click_Detected | SCP0048_ItembyDivisionPopupEx.cs:396 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-4608e8c8 | this.btnButtonList.UsrButtonList_Click_Detected | SCP0048_ItembyDivisionPopupEx.cs:399 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10d733cc | this.clbDivision.SelectedIndexChanged | SCP0048_ItembyDivisionPopupEx.cs:406 |  | FLAG | dtScmSite | GetDivisionbyScmSite(clbDivision.ControlValues, CAppSetting.StringALL, CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-e94f847f | this.clbDivision.SelectedIndexChanged | SCP0048_ItembyDivisionPopupEx.cs:407 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.CreateSpread

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7bd0682 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:258 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-784a456d | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:259 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-579dae0b | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:260 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.DefineProperty

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30afe631 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:253 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93052fb1 | Dispose | SCP0048_ItembyDivisionPopupEx.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.FindData

진입점: this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b57797e | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:335 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-650b82d2 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:339 | lambda | ENDPOINT | new FoxDataRequest | ("DM_H.SCM0002_GET_ITEM_BY_DIVISION_POPUPEx") ⇒ DM_H.SCM0002_GET_ITEM_BY_DIVISION_POPUPEx | 엔드포인트 요청 생성 |  |  |  |
| AC-3bbcbaa3 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:341 | lambda | DATA_OP | request.Parameters["p_division_id"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-a3bc101c | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:342 | lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-4748b758 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:343 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d02dde4b | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:344 | lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-edf51f80 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:345 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbScmSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0e34f8f6 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:346 | lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d9efd80c | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:347 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-79a5ce78 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:349 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-64328658 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:353 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7f8e6051 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:354 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9497826b | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:357 |  | CALL_EXT | (new CUIControl()).SetPreferredWidth | (siMain.SpreadObject, 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2d90d18 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 2 | SCP0048_ItembyDivisionPopupEx.cs:361 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff67d18f | this.Load | SCP0048_ItembyDivisionPopupEx.cs:175 | if (division.IndexOf("82") >= 0 \|\| division == "ALL" \|\| division == "") ▸ if (sProject.Length < 3 && sItemId.Length < 3) | MESSAGE | MessageHelper.GMessageBox | ("MSG00147") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-512f66b5 | this.Load | SCP0048_ItembyDivisionPopupEx.cs:176 | if (division.IndexOf("82") >= 0 \|\| division == "ALL" \|\| division == "") ▸ if (sProject.Length < 3 && sItemId.Length < 3) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-25436eab | this.Load | SCP0048_ItembyDivisionPopupEx.cs:184 | if (!blnVali) | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d0b88680 | this.Load | SCP0048_ItembyDivisionPopupEx.cs:185 | if (!blnVali) | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-55d4df3c | this.Load | SCP0048_ItembyDivisionPopupEx.cs:194 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-a6b46a1c | this.Load | SCP0048_ItembyDivisionPopupEx.cs:195 |  | FLAG | division | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-f64456b2 | this.Load | SCP0048_ItembyDivisionPopupEx.cs:196 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-d18edabe | this.Load | SCP0048_ItembyDivisionPopupEx.cs:197 |  | FLAG | sScmSiteId | _ScmSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-d9d7ea07 | this.Load | SCP0048_ItembyDivisionPopupEx.cs:198 |  | FLAG | sItemId | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-ef5cf0c5 | this.Load | SCP0048_ItembyDivisionPopupEx.cs:200 |  | FLAG | DeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-28a2a472 | this.Load | SCP0048_ItembyDivisionPopupEx.cs:201 |  | FLAG | EndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf1bdc1d | (진입점 미연결) | SCP0048_ItembyDivisionPopupEx.cs:501 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-f8c328c3 | (진입점 미연결) | SCP0048_ItembyDivisionPopupEx.cs:503 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8af500da | (진입점 미연결) | SCP0048_ItembyDivisionPopupEx.cs:506 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.GetDivisionbyScmSite

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8c1e152 | this.clbDivision.SelectedIndexChanged | SCP0048_ItembyDivisionPopupEx.cs:515 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-9885bd4a | this.clbDivision.SelectedIndexChanged | SCP0048_ItembyDivisionPopupEx.cs:516 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-9185091c | this.clbDivision.SelectedIndexChanged | SCP0048_ItembyDivisionPopupEx.cs:517 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-afc37aef | this.clbDivision.SelectedIndexChanged | SCP0048_ItembyDivisionPopupEx.cs:518 |  | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-795ba208 | this.clbDivision.SelectedIndexChanged | SCP0048_ItembyDivisionPopupEx.cs:520 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-becb931c | this.clbDivision.SelectedIndexChanged | SCP0048_ItembyDivisionPopupEx.cs:523 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c687a8e0 | (진입점 미연결) | SCP0048_ItembyDivisionPopupEx.cs:546 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-69731244 | (진입점 미연결) | SCP0048_ItembyDivisionPopupEx.cs:547 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-330e6193 | (진입점 미연결) | SCP0048_ItembyDivisionPopupEx.cs:548 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-8907eaf2 | (진입점 미연결) | SCP0048_ItembyDivisionPopupEx.cs:549 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a2f12adc | (진입점 미연결) | SCP0048_ItembyDivisionPopupEx.cs:552 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.GetSpdTitle

진입점: this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load [if (!blnVali)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a7f95f7 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SCP0048_ItembyDivisionPopupEx.cs:422 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DM0000_GET_COMMON_SPREAD_TITLE") ⇒ DM_H.DM0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-4a356218 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SCP0048_ItembyDivisionPopupEx.cs:423 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6104ac24 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SCP0048_ItembyDivisionPopupEx.cs:424 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e68b3023 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SCP0048_ItembyDivisionPopupEx.cs:425 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b19fc71f | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SCP0048_ItembyDivisionPopupEx.cs:426 |  | DATA_OP | request.Parameters["p_program_id"] | "SCM0002" | 행/컬럼 값 대입 |  |  |  |
| AC-a21bdc5a | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SCP0048_ItembyDivisionPopupEx.cs:427 |  | DATA_OP | request.Parameters["p_sheet_name"] | "ItemPopup" | 행/컬럼 값 대입 |  |  |  |
| AC-ed4fea3c | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SCP0048_ItembyDivisionPopupEx.cs:429 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-020a2800 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SCP0048_ItembyDivisionPopupEx.cs:429 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-21923f45 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SCP0048_ItembyDivisionPopupEx.cs:432 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-955add7f | (진입점 미연결) | SCP0048_ItembyDivisionPopupEx.cs:532 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-4e8a5992 | (진입점 미연결) | SCP0048_ItembyDivisionPopupEx.cs:533 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-a357a78a | (진입점 미연결) | SCP0048_ItembyDivisionPopupEx.cs:534 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7992ecd7 | (진입점 미연결) | SCP0048_ItembyDivisionPopupEx.cs:537 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.InitControls

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8428042b | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:211 |  | FLAG | dtDivision | BLUtils.GetDivisionWithoutEE(false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-f08fe020 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:211 |  | CALL_EXT | BLUtils.GetDivisionWithoutEE | (false, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-49b560a8 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:212 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6427d519 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:217 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-5fbe94f4 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:217 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-83efb973 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:218 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a574929e | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:223 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-e437d92b | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:223 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, division, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3dc37c6a | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:225 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3de20410 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:230 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-81d3815c | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:230 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-31e1a5a9 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:231 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3b611d14 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:234 |  | VALUE_SET | clbDivision.ControlValues | division | 컨트롤 값 설정 |  |  |  |
| AC-c6f5a93b | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:235 |  | VALUE_SET | txtProject.ControlValues | sProject | 컨트롤 값 설정 |  |  |  |
| AC-303c9bf1 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:236 |  | VALUE_SET | clbScmSite.ControlValues | sScmSiteId | 컨트롤 값 설정 |  |  |  |
| AC-3b5e207f | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:237 |  | VALUE_SET | txtItemID.Text | sItemId | 컨트롤 값 설정 |  |  |  |
| AC-44beae94 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:238 |  | VALUE_SET | clbTeam.ControlValues | DeptID | 컨트롤 값 설정 |  |  |  |
| AC-9f9156b7 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:239 |  | VALUE_SET | clbEndCustomer.ControlValues | EndCustomer | 컨트롤 값 설정 |  |  |  |
| AC-339491b7 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:242 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ab00a183 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:243 |  | STATE | txtProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-283e54fa | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:244 |  | STATE | clbScmSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-463b33c5 | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:245 |  | STATE | clbTeam.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e160906e | this.Load [if (!blnVali)] | SCP0048_ItembyDivisionPopupEx.cs:246 |  | STATE | clbEndCustomer.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0048_ItembyDivisionPopupEx.InitSpread

진입점: this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load [if (!blnVali)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50f689ac | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SCP0048_ItembyDivisionPopupEx.cs:269 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.InitSpread_X

진입점: this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load [if (!blnVali)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae5023bf | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SCP0048_ItembyDivisionPopupEx.cs:296 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b219aa09 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:437 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50012d86 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:439 |  | FLAG | itemID | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d7d3725d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:455 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e14b4340 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:456 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemName | this.dtFindData.Rows[iRow][DefColumns.ItemName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-81b63fba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:457 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemType | this.dtFindData.Rows[iRow][DefColumns.ItemType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-abcdfca5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:458 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6d659b15 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:459 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemclassname | this.dtFindData.Rows[iRow][DefColumns.ItemClassName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b9924b69 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:460 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | currency | this.dtFindData.Rows[iRow][DefColumns.CURRENCY].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c8e342e6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:464 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | itemID + "," + this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a9dc0efb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:465 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemName | itemName + "," + this.dtFindData.Rows[iRow][DefColumns.ItemName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7c283957 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:466 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemType | itemType + "," + this.dtFindData.Rows[iRow][DefColumns.ItemType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-55bf4305 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:467 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | nickName + "," + this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0eae14df | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:468 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemclassname | itemclassname + "," + this.dtFindData.Rows[iRow][DefColumns.ItemClassName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a39b85f1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:469 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | currency | currency + "," + this.dtFindData.Rows[iRow][DefColumns.CURRENCY].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b5f40f48 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:477 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-716861af | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:482 | else of (bMulltiSelect) | FLAG | itemID | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-5008dc1d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:483 | else of (bMulltiSelect) | FLAG | itemName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-95fcb8f1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:484 | else of (bMulltiSelect) | FLAG | itemType | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemType)) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b7172bc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:485 | else of (bMulltiSelect) | FLAG | nickName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NickName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-ec5f5c61 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:486 | else of (bMulltiSelect) | FLAG | itemclassname | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemClassName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-db5db7ef | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:487 | else of (bMulltiSelect) | FLAG | currency | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY)) | 화면 필드/플래그 변경 |  |  |  |
| AC-e3c055fa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:488 | else of (bMulltiSelect) | FLAG | project | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project)) | 화면 필드/플래그 변경 |  |  |  |
| AC-53d08587 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0048_ItembyDivisionPopupEx.cs:489 | else of (bMulltiSelect) | FLAG | scmsiteid | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)) | 화면 필드/플래그 변경 |  |  |  |

## SCP0048_ItembyDivisionPopupEx.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba999bcf | this.spdMain.CellDoubleClick | SCP0048_ItembyDivisionPopupEx.cs:413 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0048_ProjectRoute_Warranty.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a70cbfa1 | this.btnItemId.Click | SCP0048_ProjectRoute_Warranty.cs:317 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-de76afdb | this.btnItemId.Click | SCP0048_ProjectRoute_Warranty.cs:319 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e6163b2a | this.btnItemId.Click | SCP0048_ProjectRoute_Warranty.cs:320 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d5c5035b | this.btnItemId.Click | SCP0048_ProjectRoute_Warranty.cs:321 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8d62e476 | this.btnItemId.Click | SCP0048_ProjectRoute_Warranty.cs:327 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0048_ProjectRoute_Warranty.cboOperationGroup_SelectedIndexChanged

진입점: cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24578b09 | cboOperationGroup.SelectedIndexChanged | SCP0048_ProjectRoute_Warranty.cs:1014 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0048_ProjectRoute_Warranty.checkValidN1

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6887411 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1093 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-c518461a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1096 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-08ec6f74 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1097 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e5f0605 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1098 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-8df713ce | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1099 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-915d9275 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1100 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a3717d8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1101 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3e493c0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1102 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b10af59 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1103 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f68cc81 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1105 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-269d45b5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1116 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-551301aa | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1119 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-5daa4d61 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1120 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-862d5484 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1121 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a711969b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1122 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-61806397 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1123 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3a91587 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1124 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-57082cf1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1125 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc1b679e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1148 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00212", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fbfbd16a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1151 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ProjectRoute_Warranty.checkValidN10

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c16ca60f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1679 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-b11bb81a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1682 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba50d214 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1683 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fa5ff1f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1684 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-38e7e2a4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1685 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9462294 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1686 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3b02556 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1687 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ad4372f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1688 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a343d67 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1689 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5d7ac56 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1690 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.OPERATION_GROUP) | 데이터 객체 조작/조회 |  |  |  |
| AC-aae5e147 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1692 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-19e96fa7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1714 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c628fda4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1715 | if (!isPass) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-743ee6ad | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1718 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ProjectRoute_Warranty.checkValidN11

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-499be898 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1732 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-a935e08f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1735 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc982ce8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1736 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-45ebb934 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1737 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c41a4db | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1738 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-4788971d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1739 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5cf98ea | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1740 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-924cbf39 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1741 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-f66bac42 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1742 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-f83c90af | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1743 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.OPERATION_GROUP) | 데이터 객체 조작/조회 |  |  |  |
| AC-af592cb6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1745 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3e86762 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1763 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00322", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-414dfd16 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1766 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ProjectRoute_Warranty.checkValidN2

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74523654 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1165 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-605c090b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1168 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3dbaa37 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1169 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a76352d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1170 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-107bf949 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1171 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-c202fb21 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1172 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-58fda2fc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1173 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-0655e839 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1174 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-793d1063 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1175 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-29d19f22 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1177 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-4fb62eb5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1186 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-5035248d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1189 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-413201e2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1190 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c147c58 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1191 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f107ec1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1192 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-782627fd | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1193 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-53807607 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1194 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-8cf01358 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1195 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e07c43d9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1209 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00213", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d18684ab | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1212 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ProjectRoute_Warranty.checkValidN3

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca00a7ce | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1225 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-61536ac8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1228 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-270393a8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1229 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c045194 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1230 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-02b1d172 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1231 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b63ba67 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1232 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-8764aaac | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1233 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-c81a6394 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1234 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-52cc1149 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1235 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-497e22ae | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1237 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-40b2e77f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1246 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a8a7982 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1249 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f3da11c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1250 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-161e5080 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1251 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1107f77 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1252 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-4591bf79 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1253 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5bb8fa3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1254 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-d65b964c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1255 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-03e26acf | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1256 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf471130 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1271 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00214", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d222dea8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1274 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ProjectRoute_Warranty.checkValidN4

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31e90950 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1288 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-8393b08d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1291 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba7d8807 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1292 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-94f58731 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1293 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-b674bfd6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1294 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-af1fe8cf | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1295 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d16e308 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1296 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-05843bc5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1297 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1cae5d9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1298 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-68ab354d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1299 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3666f4b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1301 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ba89e40 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1310 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6666f7d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1313 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed20ef99 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1314 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd5f2ca8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1315 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-620142a3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1316 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-29638ae5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1317 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-00a128bc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1318 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-33dde71e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1319 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-eec1ae94 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1320 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-27c5b02d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1336 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00215", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-99ec51ac | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1339 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ProjectRoute_Warranty.checkValidN5

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-349f71f2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1355 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-072be19e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1358 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-aef1a874 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1359 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae44b9f4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1360 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9c6e644 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1361 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ec58aa5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1362 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-49e4b574 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1363 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4d0065c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1364 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-25d8cfba | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1370 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-9db85a5f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1372 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-105c5fb8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1381 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e666c9b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1384 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-2444df68 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1385 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-ace623fc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1386 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-47ec4683 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1387 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-465e8ce3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1388 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-5542b5ad | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1389 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-21a262ae | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1394 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d8f2152 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1395 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9ae7b2f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1416 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) ▸ if (MERGE_DATE != cp_MERGE_DATE && ((nORG_FROM_YYYYMMDD >= n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00215", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-01ae59f0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1419 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) ▸ if (MERGE_DATE != cp_MERGE_DATE && ((nORG_FROM_YYYYMMDD >= n… | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |
| AC-e26033e4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1435 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) ▸ else of (MERGE_DATE != cp_MERGE_DATE && ((nORG_FROM_YYYYMMDD… | MESSAGE | MessageHelper.GMessageBox | ("MSG00216", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-679789d0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1438 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) ▸ else of (MERGE_DATE != cp_MERGE_DATE && ((nORG_FROM_YYYYMMDD… | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |
| AC-22ecd571 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1447 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) ▸ else of (MERGE_DATE != cp_MERGE_DATE && ((nORG_FROM_YYYYMMDD… | MESSAGE | MessageHelper.GMessageBox | ("MSG00215", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-61d0b052 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1450 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) ▸ else of (MERGE_DATE != cp_MERGE_DATE && ((nORG_FROM_YYYYMMDD… | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |
| AC-c60f26ec | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1469 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00216", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-edefc429 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1472 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ProjectRoute_Warranty.checkValidN7

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffb2571e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1487 | foreach (DataRow dr in dt.AsEnumerable()) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (initIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0b69640 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1488 | foreach (DataRow dr in dt.AsEnumerable()) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx1, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-4bead327 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1500 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-cef763a6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1503 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3f48aff | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1507 | for (i < dt.Rows.Count) ▸ if (intPRIORITY < 1) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a4f4576 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1509 | for (i < dt.Rows.Count) ▸ if (intPRIORITY < 1) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx1, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-db3ef7d9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1514 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-19ac0119 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1518 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00107", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6633793e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1521 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ProjectRoute_Warranty.checkValidN8

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3e2d483 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1541 | foreach (DataRow dr in dt.AsEnumerable()) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (initIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca57420d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1542 | foreach (DataRow dr in dt.AsEnumerable()) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-3777e330 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1553 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-bea5e11d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1556 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-217c4737 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1557 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2840082 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1561 | for (i < dt.Rows.Count) ▸ if (strORG_FROM_YYYYMMDD == string.Empty \|\| strORG_TO_YYYYMMDD == string.Empty) | GRID_STYLE | siMain.SetBGColor | (i, iColIdx1, i, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-068e5005 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1562 | for (i < dt.Rows.Count) ▸ if (strORG_FROM_YYYYMMDD == string.Empty \|\| strORG_TO_YYYYMMDD == string.Empty) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f52fe3bc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1571 | for (i < dt.Rows.Count) ▸ if (intORG_FROM_YYYYMMDD > intORG_TO_YYYYMMDD) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6df1a729 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1573 | for (i < dt.Rows.Count) ▸ if (intORG_FROM_YYYYMMDD > intORG_TO_YYYYMMDD) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-91d0681a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1579 | for (i < dt.Rows.Count) ▸ if (intORG_FROM_YYYYMMDD < 17530101 \|\| intORG_TO_YYYYMMDD < 17530101) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e303014 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1581 | for (i < dt.Rows.Count) ▸ if (intORG_FROM_YYYYMMDD < 17530101 \|\| intORG_TO_YYYYMMDD < 17530101) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-98291564 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1588 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bafaaeda | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1592 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9fdda173 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1596 | else of (!isPass) ▸ if (!isDatePass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00048", new object[] { strStartDate + "~" + strEndDate }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0dfb4e99 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1601 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ProjectRoute_Warranty.checkValidN9

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26681736 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1615 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-dafb36d8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1618 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-6feaf5aa | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1619 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6fa2c23 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1620 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-940c001b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1621 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-555f9ef9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1622 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-b36e9d34 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1623 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a82a575 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1624 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d2757ed | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1625 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-f33eff8b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1626 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.OPERATION_GROUP) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c911cb3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1628 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-405bc0ae | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1637 | for (i < dsValiChkBinding.Rows.Count) ▸ if (OPERATION_GROUP=="W") | DATA_OP | dsValiChkBinding.Select | ("PRIORITY=1 AND VALID_YN ='Y' AND ORG_FROM_YYYYMMDD='" + ORG_FROM_YYYYMMDD + "' AND ORG_T… | 데이터 객체 조작/조회 |  |  |  |
| AC-ef96a0fb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1642 | for (i < dsValiChkBinding.Rows.Count) ▸ else of (OPERATION_GROUP=="W") | DATA_OP | dsValiChkBinding.Select | ("PRIORITY=1 AND VALID_YN ='Y' AND ORG_FROM_YYYYMMDD='" + ORG_FROM_YYYYMMDD + "' AND ORG_T… | 데이터 객체 조작/조회 |  |  |  |
| AC-be3e2412 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1662 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00220", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee0ee7f9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1665 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ProjectRoute_Warranty.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e5b220e | (진입점 미연결) | SCP0048_ProjectRoute_Warranty.cs:186 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8420109f | (진입점 미연결) | SCP0048_ProjectRoute_Warranty.cs:187 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0048_ProjectRoute_Warranty.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14f17b2f | this.Load | SCP0048_ProjectRoute_Warranty.cs:206 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-96056444 | this.Load | SCP0048_ProjectRoute_Warranty.cs:207 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e34589e8 | this.Load | SCP0048_ProjectRoute_Warranty.cs:208 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0048_ProjectRoute_Warranty.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa490b5b | this.Load | SCP0048_ProjectRoute_Warranty.cs:136 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-c5775d60 | this.Load | SCP0048_ProjectRoute_Warranty.cs:138 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-1c1ab73c | this.Load | SCP0048_ProjectRoute_Warranty.cs:139 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-5bea5ec3 | this.Load | SCP0048_ProjectRoute_Warranty.cs:140 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SCP0048_ProjectRoute_Warranty.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14e54720 | DeleteButton | SCP0048_ProjectRoute_Warranty.cs:251 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a6136ab | DeleteButton | SCP0048_ProjectRoute_Warranty.cs:256 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0048_ProjectRoute_Warranty.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45148400 | Dispose | SCP0048_ProjectRoute_Warranty.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0048_ProjectRoute_Warranty.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e757eaac | EditButton | SCP0048_ProjectRoute_Warranty.cs:266 | if ((dsItemBinding == null) \|\| (dsItemBinding.Rows.Count == 0)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00259") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de9afebf | EditButton | SCP0048_ProjectRoute_Warranty.cs:267 | if ((dsItemBinding == null) \|\| (dsItemBinding.Rows.Count == 0)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1bc51820 | EditButton | SCP0048_ProjectRoute_Warranty.cs:270 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-711dfa08 | EditButton | SCP0048_ProjectRoute_Warranty.cs:271 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-0b661554 | EditButton | SCP0048_ProjectRoute_Warranty.cs:274 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-77b371ec | EditButton | SCP0048_ProjectRoute_Warranty.cs:275 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TACT_TIME_FLAG), siMain.GetColumnIndex(DefColumns.TACT_T… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f12c2795 | EditButton | SCP0048_ProjectRoute_Warranty.cs:276 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-65856503 | EditButton | SCP0048_ProjectRoute_Warranty.cs:283 | for (i < siMain.ActiveSheet.RowCount) ▸ if ((dsItemBinding == null) \|\| (dsItemBinding.Rows.Count == 0)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00259") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1abe9b3c | EditButton | SCP0048_ProjectRoute_Warranty.cs:284 | for (i < siMain.ActiveSheet.RowCount) ▸ if ((dsItemBinding == null) \|\| (dsItemBinding.Rows.Count == 0)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8daca697 | EditButton | SCP0048_ProjectRoute_Warranty.cs:290 | for (i < siMain.ActiveSheet.RowCount) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ce587b38 | EditButton | SCP0048_ProjectRoute_Warranty.cs:291 | for (i < siMain.ActiveSheet.RowCount) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TACT_TIME_FLAG), siMain.GetColumnIndex(DefColumns.TACT_T… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f6ba76b1 | EditButton | SCP0048_ProjectRoute_Warranty.cs:292 | for (i < siMain.ActiveSheet.RowCount) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2fd36be1 | EditButton | SCP0048_ProjectRoute_Warranty.cs:297 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)).ToString() != "… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), i, siMain.GetColumnIndex(DefColumns.V… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7ac9d39d | EditButton | SCP0048_ProjectRoute_Warranty.cs:303 | for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)).ToString()… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), i, siMain.GetColumnIndex(DefColumns.P… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0048_ProjectRoute_Warranty.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e21ced79 | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:336 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e42078ef | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:343 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-aff4e3dc | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:343 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bdec40a8 | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:347 | try | STATE_RESET | dsFullBinding.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-36ff614a | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:349 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-975df8f6 | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:366 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b4a129fc | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:367 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3a0e49e5 | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:371 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0048_GET_ProjectRoute_Warranty") ⇒ SCP.SCP0048_GET_ProjectRoute_Warranty | 엔드포인트 요청 생성 |  |  |  |
| AC-1fef9a3d | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:372 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b1e76dc8 | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:373 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-b1d3ce3c | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:374 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site"] | pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-0c84a78e | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:375 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | pOperationGroup | 행/컬럼 값 대입 |  |  |  |
| AC-aed3aa90 | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:376 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-59cc4159 | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:377 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0ca4d42d | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:378 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-228147b7 | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:379 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_flag"] | pValid.Equals("ALL") ? DBNull.Value : pValid | 행/컬럼 값 대입 |  |  |  |
| AC-eb7cb0a0 | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:381 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b5f7416d | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:383 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3989e55c | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:390 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-152389ad | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:391 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-80a98d72 | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:394 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-384d50b0 | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:398 | try | FLAG | dsFullBinding | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-eaeb3050 | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:399 | try | FLAG | dsItemBinding | ds.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-e1d5dfe1 | FindButton 외 1 | SCP0048_ProjectRoute_Warranty.cs:417 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0048_ProjectRoute_Warranty.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86a1e6b3 | this.Load | SCP0048_ProjectRoute_Warranty.cs:123 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0048_ProjectRoute_Warranty.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca01ca86 | this.Load | SCP0048_ProjectRoute_Warranty.cs:155 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a500a4e3 | this.Load | SCP0048_ProjectRoute_Warranty.cs:158 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-89bebeef | this.Load | SCP0048_ProjectRoute_Warranty.cs:161 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-24472d92 | this.Load | SCP0048_ProjectRoute_Warranty.cs:162 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-b569d9f5 | this.Load | SCP0048_ProjectRoute_Warranty.cs:164 |  | FLAG | dtOperationGroup | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-fcd4da2b | this.Load | SCP0048_ProjectRoute_Warranty.cs:164 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f1730c2e | this.Load | SCP0048_ProjectRoute_Warranty.cs:165 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0048_ProjectRoute_Warranty.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa30a3ac | this.Load | SCP0048_ProjectRoute_Warranty.cs:148 |  | FLAG | dsdm | (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Dat… | 화면 필드/플래그 변경 |  |  |  |

## SCP0048_ProjectRoute_Warranty.InitSpread

진입점: this.Load / cboOperationGroup.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ad425b6 | this.Load 외 3 | SCP0048_ProjectRoute_Warranty.cs:215 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-aa27dc2e | this.Load 외 3 | SCP0048_ProjectRoute_Warranty.cs:217 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## SCP0048_ProjectRoute_Warranty.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9f3533f | InsertButton | SCP0048_ProjectRoute_Warranty.cs:448 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (pValid.ToString()=="P" \|\… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4cb453bd | InsertButton | SCP0048_ProjectRoute_Warranty.cs:450 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9dfb9cfc | InsertButton | SCP0048_ProjectRoute_Warranty.cs:453 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-32ab1654 | InsertButton | SCP0048_ProjectRoute_Warranty.cs:464 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf1865d6 | InsertButton | SCP0048_ProjectRoute_Warranty.cs:465 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-e0296c3d | InsertButton | SCP0048_ProjectRoute_Warranty.cs:466 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.OPERATION_GROUP, "W") | 데이터 객체 조작/조회 |  |  |  |
| AC-57236ed8 | InsertButton | SCP0048_ProjectRoute_Warranty.cs:467 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.SCM_SITE_ID, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-2fbca121 | InsertButton | SCP0048_ProjectRoute_Warranty.cs:468 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.PROJECT_CODE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-daf11312 | InsertButton | SCP0048_ProjectRoute_Warranty.cs:469 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.OPERATION_GROUP_NAME, "Warranty") | 데이터 객체 조작/조회 |  |  |  |
| AC-d165759b | InsertButton | SCP0048_ProjectRoute_Warranty.cs:470 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.PRIORITY, "11") | 데이터 객체 조작/조회 |  |  |  |
| AC-4355d289 | InsertButton | SCP0048_ProjectRoute_Warranty.cs:472 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-3f704be1 | InsertButton | SCP0048_ProjectRoute_Warranty.cs:476 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6e61399b | InsertButton | SCP0048_ProjectRoute_Warranty.cs:478 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-11dedc3b | InsertButton | SCP0048_ProjectRoute_Warranty.cs:480 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TACT_TIME_FLAG), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5ae74520 | InsertButton | SCP0048_ProjectRoute_Warranty.cs:483 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange3 | (insCell, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |

## SCP0048_ProjectRoute_Warranty.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bbb688a | SaveButton | SCP0048_ProjectRoute_Warranty.cs:522 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-3e930f4c | SaveButton | SCP0048_ProjectRoute_Warranty.cs:522 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47018dab | SaveButton | SCP0048_ProjectRoute_Warranty.cs:530 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ad4eed05 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:531 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN1()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-538c92f8 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:532 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN2()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91f22f6d | SaveButton | SCP0048_ProjectRoute_Warranty.cs:533 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN5()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4820a8d5 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:534 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN3()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe0f3413 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:535 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN4()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-419b1c32 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:536 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN7(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed40ace9 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:537 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN8(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49ba53c7 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:538 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN9()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53b7f62f | SaveButton | SCP0048_ProjectRoute_Warranty.cs:539 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN10(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39186b4c | SaveButton | SCP0048_ProjectRoute_Warranty.cs:540 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN11()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad72ed5e | SaveButton | SCP0048_ProjectRoute_Warranty.cs:598 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0048_SAVE_PROJECTROUTE_Warranty") ⇒ SCP.SCP0048_SAVE_PROJECTROUTE_Warranty | 엔드포인트 요청 생성 |  |  |  |
| AC-ee25cb4e | SaveButton | SCP0048_ProjectRoute_Warranty.cs:602 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-45597092 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:607 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-87e6e260 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:609 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2809cdc8 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:610 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_priority_seq"] | p_priority_seq | 행/컬럼 값 대입 |  |  |  |
| AC-2925e432 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:611 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b73faa4 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:612 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-660f2580 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:613 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-6bd77acb | SaveButton | SCP0048_ProjectRoute_Warranty.cs:614 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-f68ef043 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:615 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-b074c139 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:616 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_priority"] | p_priority | 행/컬럼 값 대입 |  |  |  |
| AC-280a5e13 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:617 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4ed81c6c | SaveButton | SCP0048_ProjectRoute_Warranty.cs:618 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-14052311 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:619 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-4860adf2 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:620 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-0ba7eb49 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:621 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-e3f4c7a5 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:622 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-7ec174fc | SaveButton | SCP0048_ProjectRoute_Warranty.cs:623 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-1ea1160c | SaveButton | SCP0048_ProjectRoute_Warranty.cs:625 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8bb9237f | SaveButton | SCP0048_ProjectRoute_Warranty.cs:625 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-cb038feb | SaveButton | SCP0048_ProjectRoute_Warranty.cs:635 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-80ae6c86 | SaveButton | SCP0048_ProjectRoute_Warranty.cs:644 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0048_ProjectRoute_Warranty.set_ValidDataSet

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3331fcd3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1029 |  | FLAG | dsValiChkBinding | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6b2ee484 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1030 |  | FLAG | dsValiChkBinding | dsFullBinding.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-f474018a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1030 |  | DATA_OP | dsFullBinding.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7031524f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1045 | for (i < dt.Rows.Count) ▸ if (action == CAppSetting.FlagM) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-37fa44f5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1047 | for (i < dt.Rows.Count) ▸ if (action == CAppSetting.FlagM) ▸ if (!String.IsNullOrEmpty(PRIORITY_SEQ) && orgValidYn=="Y") | DATA_OP | dsValiChkBinding.Rows.Remove | (dsValiChkBinding.Select("PRIORITY_SEQ = '" + PRIORITY_SEQ + "'")[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-4592e841 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1047 | for (i < dt.Rows.Count) ▸ if (action == CAppSetting.FlagM) ▸ if (!String.IsNullOrEmpty(PRIORITY_SEQ) && orgValidYn=="Y") | DATA_OP | dsValiChkBinding.Select | ("PRIORITY_SEQ = '" + PRIORITY_SEQ + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-da82d326 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1050 | for (i < dt.Rows.Count) | DATA_OP | dsValiChkBinding.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7b25e748 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1052 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.ORG_FROM_YYYYMMDD] | dt.Rows[i].Field<string>(DefColumns.ORG_FROM_YYYYMMDD) | 행/컬럼 값 대입 |  |  |  |
| AC-35b5a94f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1052 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2a74f4b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1053 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.ORG_TO_YYYYMMDD] | dt.Rows[i].Field<string>(DefColumns.ORG_TO_YYYYMMDD) | 행/컬럼 값 대입 |  |  |  |
| AC-bf6ceeeb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1053 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-b57732d9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1054 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.DIVISION_ID] | dt.Rows[i].Field<string>(DefColumns.DIVISION_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-d894003e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1054 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf3ff8c7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1055 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.PRIORITY] | dt.Rows[i].Field<Int32>(DefColumns.PRIORITY) | 행/컬럼 값 대입 |  |  |  |
| AC-a28f0a47 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1055 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff803156 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1056 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.PLANT_SITE_ID_B) | 데이터 객체 조작/조회 |  |  |  |
| AC-6af94161 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1058 | for (i < dt.Rows.Count) ▸ if (plantId==null \|\| plantId=="") | DATA_OP | dt.Rows[i].Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-da152da6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1061 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.PLANT_SITE_ID] | plantId | 행/컬럼 값 대입 |  |  |  |
| AC-6b75293e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1062 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.SCM_SITE_ID] | dt.Rows[i].Field<string>(DefColumns.SCM_SITE_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-ebf48241 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1062 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-99c9f809 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1063 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.PROJECT_CODE] | dt.Rows[i].Field<string>(DefColumns.PROJECT_CODE) | 행/컬럼 값 대입 |  |  |  |
| AC-7a5ce0b8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1063 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-e270f42f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1064 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.ITEM_ID] | dt.Rows[i].Field<string>(DefColumns.ITEM_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-f251f4ac | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1064 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5eeedf9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1065 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.PRIORITY_SEQ] | dt.Rows[i].Field<string>(DefColumns.PRIORITY_SEQ) | 행/컬럼 값 대입 |  |  |  |
| AC-3220370d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1065 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe0deada | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1066 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.VALID_YN] | dt.Rows[i].Field<string>(DefColumns.VALID_YN) | 행/컬럼 값 대입 |  |  |  |
| AC-15c9aaeb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1066 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfb9855d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1067 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.OPERATION_GROUP] | dt.Rows[i].Field<string>(DefColumns.OPERATION_GROUP) | 행/컬럼 값 대입 |  |  |  |
| AC-4ddfb556 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1067 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.OPERATION_GROUP) | 데이터 객체 조작/조회 |  |  |  |
| AC-c71581fd | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1068 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.ACTION_FLAG_DIV] | action | 행/컬럼 값 대입 |  |  |  |
| AC-b0a87e56 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1069 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.ROW_COLOR_INDEX] | i | 행/컬럼 값 대입 |  |  |  |
| AC-73098889 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1071 | for (i < dt.Rows.Count) | DATA_OP | dsValiChkBinding.Rows.Add | (newDr) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4e97d5e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0048_ProjectRoute_Warranty.cs:1074 |  | DATA_OP | dsValiChkBinding.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0048_ProjectRoute_Warranty.SetChangedControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1019ccf6 | this.Load 외 1 | SCP0048_ProjectRoute_Warranty.cs:195 |  | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantSiteByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-5a7e7f4a | this.Load 외 1 | SCP0048_ProjectRoute_Warranty.cs:195 |  | COMBO_DATA | Data.Common | (Data.Type.PlantSiteByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c63f504b | this.Load 외 1 | SCP0048_ProjectRoute_Warranty.cs:196 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d0646f89 | this.Load 외 1 | SCP0048_ProjectRoute_Warranty.cs:199 |  | FLAG | dtPlantSiteByDivisionForSpread | Data_SCP.Common(Data_SCP.Type.ElecRoutePlantByOperation, false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-de96b70b | this.Load 외 1 | SCP0048_ProjectRoute_Warranty.cs:199 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ElecRoutePlantByOperation, false, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0048_ProjectRoute_Warranty.SetChangedPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b9b3a01 | this.Load | SCP0048_ProjectRoute_Warranty.cs:427 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-91d2d8b7 | this.Load | SCP0048_ProjectRoute_Warranty.cs:430 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0048_ProjectRoute_Warranty.SetImageCell

진입점: FindButton [try] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ace608b4 | FindButton [try] 외 2 | SCP0048_ProjectRoute_Warranty.cs:668 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-9814b3e5 | FindButton [try] 외 2 | SCP0048_ProjectRoute_Warranty.cs:669 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-2c3cee8f | FindButton [try] 외 2 | SCP0048_ProjectRoute_Warranty.cs:670 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SCP0048_ProjectRoute_Warranty.SetOrgData

진입점: dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD) \|\| e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b162c44f | dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColum… | SCP0048_ProjectRoute_Warranty.cs:956 |  | GRID_SET | dt.Rows[nRowIdx][DefColumns.ORG_FROM_YYYYMMDD] | strFROM_YYYYMMDD | 그리드 속성/값 설정 |  |  |  |
| AC-ed971501 | dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColum… | SCP0048_ProjectRoute_Warranty.cs:957 |  | GRID_SET | dt.Rows[nRowIdx][DefColumns.ORG_TO_YYYYMMDD] | strTO_YYYYMMDD | 그리드 속성/값 설정 |  |  |  |
| AC-f8552137 | dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColum… | SCP0048_ProjectRoute_Warranty.cs:959 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0048_ProjectRoute_Warranty.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b72e228f | spdMain.CellClick | SCP0048_ProjectRoute_Warranty.cs:969 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d9bad83 | spdMain.CellClick | SCP0048_ProjectRoute_Warranty.cs:976 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColu… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, e.Column, new DataTable()) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-14a9a48a | spdMain.CellClick | SCP0048_ProjectRoute_Warranty.cs:978 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1c4e6baa | spdMain.CellClick | SCP0048_ProjectRoute_Warranty.cs:983 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColu… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].CellType | cb | 그리드 속성/값 설정 |  |  |  |
| AC-7c94219f | spdMain.CellClick | SCP0048_ProjectRoute_Warranty.cs:994 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColu… | FLAG | dtElectPlantSiteByDivisionForSpread | Data_SCP.Common(Data_SCP.Type.ElecRoutePlantByOperation, false, division, pOperationGroup,… | 화면 필드/플래그 변경 |  |  |  |
| AC-6d617ba8 | spdMain.CellClick | SCP0048_ProjectRoute_Warranty.cs:994 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColu… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ElecRoutePlantByOperation, false, division, pOperationGroup, pItemId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4c4bbab1 | spdMain.CellClick | SCP0048_ProjectRoute_Warranty.cs:995 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColu… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, e.Column, dtElectPlantSiteByDivisionForSpread) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c8dd56e2 | spdMain.CellClick | SCP0048_ProjectRoute_Warranty.cs:1004 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ else of (e.Column == siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0048_ProjectRoute_Warranty.spdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d22984dc | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:726 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10b8c605 | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:744 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && action == CAppSetting.FlagI) ▸ if (divi… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f544ebb2 | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:749 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && action == CAppSetting.FlagI) ▸ else of … | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-982d92f4 | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:752 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && action == CAppSetting.FlagI) ▸ else of … | POPUP | popItem.Form_Load | (false, division, "", "", sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f751c85e | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:753 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && action == CAppSetting.FlagI) ▸ else of … | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2bb74fcc | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:754 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && action == CAppSetting.FlagI) ▸ else of … | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-81c4f12c | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:759 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && action == CAppSetting.FlagI) ▸ else of … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-d0d5a5df | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:777 | if (!siMain.IsLock(siMain.SheetName)) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) \|\| e.Column == siMain.GetColumnInde… | POPUP | new SCP0048_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-92165ee9 | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:779 | if (!siMain.IsLock(siMain.SheetName)) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) \|\| e.Column == siMain.GetColumnInde… | POPUP | popItem.Form_Load | (false, division, sTeam, sEndCustomer, sScmSiteId.Replace("-", ""), sProject.Replace("-", … | 팝업 초기화(인자 전달) |  |  |  |
| AC-7f3ad61a | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:780 | if (!siMain.IsLock(siMain.SheetName)) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) \|\| e.Column == siMain.GetColumnInde… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8e86fa49 | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:781 | if (!siMain.IsLock(siMain.SheetName)) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) \|\| e.Column == siMain.GetColumnInde… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6f2b8bd8 | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:783 | if (!siMain.IsLock(siMain.SheetName)) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) \|\| e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), popItem.ScmSiteId) | 그리드 값 설정 |  |  |  |
| AC-400fb3fe | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:784 | if (!siMain.IsLock(siMain.SheetName)) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) \|\| e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popItem.Project) | 그리드 값 설정 |  |  |  |
| AC-b765248a | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:788 | if (!siMain.IsLock(siMain.SheetName)) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) \|\| e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "-") | 그리드 값 설정 |  |  |  |
| AC-ffaa858a | spdMain.CellDoubleClick | SCP0048_ProjectRoute_Warranty.cs:789 | if (!siMain.IsLock(siMain.SheetName)) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) \|\| e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "-") | 그리드 값 설정 |  |  |  |

## SCP0048_ProjectRoute_Warranty.spdMain_Change

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43024dbd | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:816 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALID_YN)) | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b7e03b9 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:823 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALID_YN)) ▸ if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCe… | MESSAGE | MessageHelper.GMessageBox | ("MSG00211", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ed08d6a4 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:824 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALID_YN)) ▸ if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCe… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.VALID_YN), "N") | 그리드 값 설정 |  |  |  |
| AC-b4df3f36 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:825 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALID_YN)) ▸ if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCe… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-090e217d | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:826 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALID_YN)) ▸ if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCe… | GRID_STYLE | siMain.SetBGColor | (e.Row, siMain.GetColumnIndex(CAppSetting.StringAction), e.Row, siMain.GetColumnIndex(CApp… | 그리드 표시 설정 |  |  |  |
| AC-b21c183e | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:828 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALID_YN)) ▸ if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCe… | GRID_STYLE | siMain.SetForeColor | (e.Row, siMain.GetColumnIndex(DefColumns.VALID_YN), e.Row, siMain.GetColumnIndex(DefColumn… | 그리드 표시 설정 |  |  |  |
| AC-e56a7a2e | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:837 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-0ae8f4a1 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:838 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-daa0e623 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:839 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-bb8cbaf7 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:840 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "-") | 그리드 값 설정 |  |  |  |
| AC-baf8ffb4 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:841 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-d28232d8 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:856 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (null== pItemId \|\| ""== pItemId) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-92901364 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:860 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null== pItemId \|\| ""== pItemId) | DATA_OP | dsItemBinding.Select | ("ITEM_ID = '" + pItemId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc694e5c | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:864 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null== pItemId \|\| ""== pItemId) ▸ if (drs.Length != 0) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), strNick_Name) | 그리드 값 설정 |  |  |  |
| AC-92592587 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:871 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null== pItemId \|\| ""== pItemId) ▸ if (drs.Length != 0) ▸ if (divisio… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ElecRoutePlantByOperation, false, division, "W", pItemId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6b5dad90 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:872 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null== pItemId \|\| ""== pItemId) ▸ if (drs.Length != 0) ▸ if (divisio… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtElectPlantSiteByDivisionTMP) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3000f969 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:874 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null== pItemId \|\| ""== pItemId) ▸ if (drs.Length != 0) ▸ if (divisio… | DATA_OP | dtElectPlantSiteByDivisionTMP.Select | ("CODE = '" + pPlantSite + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-4032e2c3 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:877 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null== pItemId \|\| ""== pItemId) ▸ if (drs.Length != 0) ▸ if (divisio… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), pPlantSite) | 그리드 값 설정 |  |  |  |
| AC-61225941 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:882 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null== pItemId \|\| ""== pItemId) ▸ if (drs.Length != 0) ▸ if (divisio… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TACT_TIME_FLAG), str.Substring(str.Length - 1, 1)… | 그리드 값 설정 |  |  |  |
| AC-19eac2df | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:887 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null== pItemId \|\| ""== pItemId) ▸ if (drs.Length != 0) ▸ if (divisio… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-d94aad44 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:888 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null== pItemId \|\| ""== pItemId) ▸ if (drs.Length != 0) ▸ if (divisio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-382743f9 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:895 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null== pItemId \|\| ""== pItemId) ▸ else of (drs.Length != 0) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-51a86e4a | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:896 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null== pItemId \|\| ""== pItemId) ▸ else of (drs.Length != 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-9f3706bb | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:914 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)) ▸ if (plantId == "" && priority == "0" && fromDt == "" && toDt == "" && siM… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-1d4c73b7 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:915 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)) ▸ if (plantId == "" && priority == "0" && fromDt == "" && toDt == "" && siM… | GRID_STYLE | siMain.SetBGColor | (e.Row, siMain.GetColumnIndex(CAppSetting.StringAction), e.Row, siMain.GetColumnIndex(CApp… | 그리드 표시 설정 |  |  |  |
| AC-6d4dde3f | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:925 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)) ▸ if (division != "" && pItemId != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ElecRoutePlantByOperation, false, division, pOperationGroup, pItemId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9b040b3c | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:926 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)) ▸ if (division != "" && pItemId != "") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, e.Column, dtElectPlantSiteByDivisionTMP) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3f364813 | dsdm.Changed | SCP0048_ProjectRoute_Warranty.cs:934 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)) ▸ if (division != "" && pItemId != "") ▸ if (plantId != "") ▸ if (str != ""… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TACT_TIME_FLAG), str.Substring(str.Length - 1, 1)… | 그리드 값 설정 |  |  |  |

## SCP0048_ProjectRoute_Warranty.SpdMain_ClipboardPasted

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7caf0217 | (진입점 미연결) | SCP0048_ProjectRoute_Warranty.cs:687 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2ad1b452 | (진입점 미연결) | SCP0048_ProjectRoute_Warranty.cs:690 | if (siMain.IsLock(siMain.SheetName) == true \|\| siMain.GetText(e.CellRange.Row, siMain.GetColumnIndex(CAppSetting.StringActio…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4119a946 | (진입점 미연결) | SCP0048_ProjectRoute_Warranty.cs:711 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ElecRoutePlantByOperation, false, division, pOperationGroup, pItemId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9661a6a7 | (진입점 미연결) | SCP0048_ProjectRoute_Warranty.cs:712 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, iCol, dtElectPlantSiteByDivisionTMP) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |


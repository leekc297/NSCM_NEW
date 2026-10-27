# AS-IS 액션 대조표 — DM0002

> 원천: `Doc/asisfacts/screens/DM0002/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 602행 · 메서드 72 · 종류 DATA_OP 142 · FLAG 139 · GRID_INIT 46 · ENDPOINT 42 · UI_PROP 33 · UI_MISC 30 · GRID_SET 30 · RETURN 29 · VALUE_SET 20 · STATE 16 · GRID_LOCK 13 · MESSAGE 13 · COMBO_DATA 13 · LIST_REBIND 11 · CALL_EXT 8 · POPUP 6 · GRID_BIND 6 · GRID_STYLE 2 · STATE_RESET 1 · GRID_COMBO 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 9


## DM0002_ItembyDivisionPopupEx.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db27ab28 | this.btnButtonList.UsrButtonList_Click_Detected | DM0002_ItembyDivisionPopupEx.cs:483 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f5531aae | this.btnButtonList.UsrButtonList_Click_Detected | DM0002_ItembyDivisionPopupEx.cs:486 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0002_ItembyDivisionPopupEx.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e17bbfd | this.clbDivision.SelectedIndexChanged | DM0002_ItembyDivisionPopupEx.cs:493 |  | FLAG | dtScmSite | GetDivisionbyScmSite(clbDivision.ControlValues, CAppSetting.StringALL, CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-30698621 | this.clbDivision.SelectedIndexChanged | DM0002_ItembyDivisionPopupEx.cs:494 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0002_ItembyDivisionPopupEx.CreateSpread

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6166616 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:332 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-10193b50 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:333 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-49e775fb | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:334 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0002_ItembyDivisionPopupEx.DefineProperty

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f023c238 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:327 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DM0002_ItembyDivisionPopupEx.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-710c49c1 | Dispose | DM0002_ItembyDivisionPopupEx.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0002_ItembyDivisionPopupEx.FindData

진입점: this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load [if (!blnVali)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11f5fda9 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:407 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-245286ee | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:408 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-017e89aa | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:411 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-dc0e1220 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:413 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { //… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9157f851 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:418 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0002_GET_ITEM_BY_DIVISION_POPUPEx") ⇒ DM.DMF0002_GET_ITEM_BY_DIVISION_POPUPEx | 엔드포인트 요청 생성 |  |  |  |
| AC-49d569d4 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:420 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-68f4303b | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:422 | lambda | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-576e8bef | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:423 | lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e4ba838b | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:424 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-28bde66f | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:425 | lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-35f29c6a | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:426 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbScmSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-eb3a9127 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:427 | lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b84212ab | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:428 | lambda | DATA_OP | request.Parameters["p_mdmActive_Sw"] | mdmActive_Sw | 행/컬럼 값 대입 |  |  |  |
| AC-2f19f0c8 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:430 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3fb43e47 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:432 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-426bdf80 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:437 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ebd9ace4 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:438 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d03c1546 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:445 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-702c740a | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DM0002_ItembyDivisionPopupEx.cs:449 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DM0002_ItembyDivisionPopupEx.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75c70ed3 | this.Load | DM0002_ItembyDivisionPopupEx.cs:179 | if (sDivision.IndexOf("82") >= 0 \|\| sDivision == "ALL" \|\| sDivision == "") ▸ if (sProject.Length < 3 && sItemId.Length < 3) | MESSAGE | MessageHelper.GMessageBox | ("MSG00147") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-62138d1d | this.Load | DM0002_ItembyDivisionPopupEx.cs:180 | if (sDivision.IndexOf("82") >= 0 \|\| sDivision == "ALL" \|\| sDivision == "") ▸ if (sProject.Length < 3 && sItemId.Length < 3) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-d00f35e2 | this.Load | DM0002_ItembyDivisionPopupEx.cs:188 | if (!blnVali) | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a3ac60f1 | this.Load | DM0002_ItembyDivisionPopupEx.cs:189 | if (!blnVali) | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1b689986 | this.Load | DM0002_ItembyDivisionPopupEx.cs:198 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-4172bf9c | this.Load | DM0002_ItembyDivisionPopupEx.cs:199 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-2f69ccad | this.Load | DM0002_ItembyDivisionPopupEx.cs:200 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-ed688561 | this.Load | DM0002_ItembyDivisionPopupEx.cs:201 |  | FLAG | sScmSiteId | _ScmSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-693b334c | this.Load | DM0002_ItembyDivisionPopupEx.cs:202 |  | FLAG | sItemId | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-1ae11160 | this.Load | DM0002_ItembyDivisionPopupEx.cs:204 |  | FLAG | DeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-4d2f7212 | this.Load | DM0002_ItembyDivisionPopupEx.cs:205 |  | FLAG | EndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |
| AC-cd7ae9e8 | this.Load | DM0002_ItembyDivisionPopupEx.cs:210 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-88dbdef0 | this.Load | DM0002_ItembyDivisionPopupEx.cs:211 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-28e8fc23 | this.Load | DM0002_ItembyDivisionPopupEx.cs:212 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-29d9dd0f | this.Load | DM0002_ItembyDivisionPopupEx.cs:213 |  | FLAG | sScmSiteId | _ScmSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-85139dc0 | this.Load | DM0002_ItembyDivisionPopupEx.cs:214 |  | FLAG | sItemId | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-3c34a100 | this.Load | DM0002_ItembyDivisionPopupEx.cs:216 |  | FLAG | DeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-7179bf33 | this.Load | DM0002_ItembyDivisionPopupEx.cs:217 |  | FLAG | EndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |
| AC-7920f325 | this.Load | DM0002_ItembyDivisionPopupEx.cs:218 |  | FLAG | bCtlEnable | bEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-1a5b5ff4 | this.Load | DM0002_ItembyDivisionPopupEx.cs:225 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-96b23659 | this.Load | DM0002_ItembyDivisionPopupEx.cs:226 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-5a0205e2 | this.Load | DM0002_ItembyDivisionPopupEx.cs:227 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-1633c605 | this.Load | DM0002_ItembyDivisionPopupEx.cs:228 |  | FLAG | sScmSiteId | _ScmSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-47c7eb67 | this.Load | DM0002_ItembyDivisionPopupEx.cs:229 |  | FLAG | sItemId | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-ff2634e0 | this.Load | DM0002_ItembyDivisionPopupEx.cs:231 |  | FLAG | DeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-ec2ff47a | this.Load | DM0002_ItembyDivisionPopupEx.cs:232 |  | FLAG | EndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |
| AC-817257f4 | this.Load | DM0002_ItembyDivisionPopupEx.cs:234 |  | FLAG | mdmActive_Sw | _mdmActive_Sw | 화면 필드/플래그 변경 |  |  |  |
| AC-cb5ca20d | this.Load | DM0002_ItembyDivisionPopupEx.cs:235 |  | FLAG | chk_Measure | _Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-8bdcee0c | this.Load | DM0002_ItembyDivisionPopupEx.cs:250 | if (chk_Measure =="AS_In_Req" \|\| chk_Measure == "BNPIn") | FLAG | mdmActive_Sw | "" | 화면 필드/플래그 변경 |  |  |  |

## DM0002_ItembyDivisionPopupEx.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a4f70ba | (진입점 미연결) | DM0002_ItembyDivisionPopupEx.cs:597 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-5bcf7623 | (진입점 미연결) | DM0002_ItembyDivisionPopupEx.cs:599 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3c2ce875 | (진입점 미연결) | DM0002_ItembyDivisionPopupEx.cs:602 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0002_ItembyDivisionPopupEx.GetDivisionbyScmSite

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15b0154a | this.clbDivision.SelectedIndexChanged | DM0002_ItembyDivisionPopupEx.cs:611 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-aa718fb2 | this.clbDivision.SelectedIndexChanged | DM0002_ItembyDivisionPopupEx.cs:612 |  | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-45064038 | this.clbDivision.SelectedIndexChanged | DM0002_ItembyDivisionPopupEx.cs:613 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-930b6e83 | this.clbDivision.SelectedIndexChanged | DM0002_ItembyDivisionPopupEx.cs:614 |  | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-283bc85b | this.clbDivision.SelectedIndexChanged | DM0002_ItembyDivisionPopupEx.cs:616 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e2450a16 | this.clbDivision.SelectedIndexChanged | DM0002_ItembyDivisionPopupEx.cs:619 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0002_ItembyDivisionPopupEx.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2af81d16 | (진입점 미연결) | DM0002_ItembyDivisionPopupEx.cs:642 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-2fd6f06e | (진입점 미연결) | DM0002_ItembyDivisionPopupEx.cs:643 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-20038c60 | (진입점 미연결) | DM0002_ItembyDivisionPopupEx.cs:644 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-9eb14070 | (진입점 미연결) | DM0002_ItembyDivisionPopupEx.cs:645 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2b0bf1be | (진입점 미연결) | DM0002_ItembyDivisionPopupEx.cs:648 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0002_ItembyDivisionPopupEx.GetSpdTitle

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35962bb0 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:510 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-d332bb77 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:511 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-74190e7f | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:512 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4ba28bdd | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:513 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c287b0eb | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:515 |  | DATA_OP | request.Parameters["p_program_id"] | "SCM0002_40" | 행/컬럼 값 대입 |  |  |  |
| AC-33183061 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:516 |  | DATA_OP | request.Parameters["p_sheet_name"] | "ItemPopup" | 행/컬럼 값 대입 |  |  |  |
| AC-e992e9ec | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:517 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3f32aeca | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:519 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-22cef274 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:519 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f4a54203 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:522 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0002_ItembyDivisionPopupEx.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53316f48 | (진입점 미연결) | DM0002_ItembyDivisionPopupEx.cs:628 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-981e6cf5 | (진입점 미연결) | DM0002_ItembyDivisionPopupEx.cs:629 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ef0d60ec | (진입점 미연결) | DM0002_ItembyDivisionPopupEx.cs:630 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-268d1794 | (진입점 미연결) | DM0002_ItembyDivisionPopupEx.cs:633 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0002_ItembyDivisionPopupEx.InitControls

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90383d0e | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:262 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-d9566c02 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:262 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ac4241e3 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:263 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6c0c5396 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:270 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-ad29f36c | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:270 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-21f1647e | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:271 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1c6bf9af | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:280 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-d84aebb3 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:280 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8983df6e | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:281 | if (sDivision == "40") | UI_PROP | lblProject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b980b5d4 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:285 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c6f48538 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:285 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8fe2f761 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:286 | else of (sDivision == "40") | UI_PROP | lblProject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-89ea9ca2 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:290 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2984cedd | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:295 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-9c274c24 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:295 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-22a8ef66 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:296 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-864acc4b | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:299 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-39f8c84c | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:300 |  | VALUE_SET | txtProject.ControlValues | sProject | 컨트롤 값 설정 |  |  |  |
| AC-646ac274 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:301 |  | VALUE_SET | clbScmSite.ControlValues | sScmSiteId | 컨트롤 값 설정 |  |  |  |
| AC-c2ce8c04 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:302 |  | VALUE_SET | txtItemID.Text | sItemId | 컨트롤 값 설정 |  |  |  |
| AC-72f3086a | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:303 |  | VALUE_SET | clbTeam.ControlValues | DeptID | 컨트롤 값 설정 |  |  |  |
| AC-1f4fbbcb | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:304 |  | VALUE_SET | clbEndCustomer.ControlValues | EndCustomer | 컨트롤 값 설정 |  |  |  |
| AC-4ab4a6f9 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:309 | if (bCtlEnable == true) | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-477fae17 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:310 | if (bCtlEnable == true) | STATE | txtProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b87acd2f | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:311 | if (bCtlEnable == true) | STATE | clbScmSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-18a51c88 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:312 | if (bCtlEnable == true) | STATE | clbTeam.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4bd5dbc2 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:313 | if (bCtlEnable == true) | STATE | clbEndCustomer.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-586875a3 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:317 | else of (bCtlEnable == true) | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c7722766 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:318 | else of (bCtlEnable == true) | STATE | txtProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-62043f49 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:319 | else of (bCtlEnable == true) | STATE | clbScmSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a31af611 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:320 | else of (bCtlEnable == true) | STATE | clbTeam.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6a689924 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:321 | else of (bCtlEnable == true) | STATE | clbEndCustomer.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## DM0002_ItembyDivisionPopupEx.InitSpread

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d81ef11 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:343 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0002_ItembyDivisionPopupEx.InitSpread_X

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6213811 | this.Load [if (!blnVali)] | DM0002_ItembyDivisionPopupEx.cs:370 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0002_ItembyDivisionPopupEx.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a8d4f11 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:527 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f192ed94 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:529 |  | FLAG | itemID | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1443b4f4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:545 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3281a77b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:546 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemName | this.dtFindData.Rows[iRow][DefColumns.ItemName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3eec4f2d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:547 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemType | this.dtFindData.Rows[iRow][DefColumns.ItemType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f34a8a60 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:548 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-83be386d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:549 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemclassname | this.dtFindData.Rows[iRow][DefColumns.ItemClassName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-02aa5bd2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:550 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | currency | this.dtFindData.Rows[iRow][DefColumns.CURRENCY].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8a6c2813 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:551 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | scmSiteId | this.dtFindData.Rows[iRow][DefColumns.ScmSiteId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-db1297af | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:553 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | projectCode | this.dtFindData.Rows[iRow][DefColumns.Project].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2d7313b6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:557 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | itemID + "," + this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e3a72ece | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:558 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemName | itemName + "," + this.dtFindData.Rows[iRow][DefColumns.ItemName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-714b67f5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:559 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemType | itemType + "," + this.dtFindData.Rows[iRow][DefColumns.ItemType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-75dbcfdd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:560 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | nickName + "," + this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d7a8be05 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:561 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemclassname | itemclassname + "," + this.dtFindData.Rows[iRow][DefColumns.ItemClassName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-337010a1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:562 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | currency | currency + "," + this.dtFindData.Rows[iRow][DefColumns.CURRENCY].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-76af2281 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:563 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | scmSiteId | scmSiteId + "," + this.dtFindData.Rows[iRow][DefColumns.ScmSiteId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-573471a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:565 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | projectCode | projectCode + "," + this.dtFindData.Rows[iRow][DefColumns.Project].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e31c1db6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:573 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93573a84 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:578 | else of (bMulltiSelect) | FLAG | itemID | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-f5b7e942 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:579 | else of (bMulltiSelect) | FLAG | itemName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-2923c293 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:580 | else of (bMulltiSelect) | FLAG | itemType | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemType)) | 화면 필드/플래그 변경 |  |  |  |
| AC-41509f5e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:581 | else of (bMulltiSelect) | FLAG | nickName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NickName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-820ce2f2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:582 | else of (bMulltiSelect) | FLAG | itemclassname | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemClassName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-493c0b71 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:583 | else of (bMulltiSelect) | FLAG | currency | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY)) | 화면 필드/플래그 변경 |  |  |  |
| AC-c3177552 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:584 | else of (bMulltiSelect) | FLAG | scmSiteId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-4ca15bb9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembyDivisionPopupEx.cs:586 | else of (bMulltiSelect) ▸ if (siMain.GetColumnIndex(DefColumns.Project) >= 0) | FLAG | projectCode | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project)) | 화면 필드/플래그 변경 |  |  |  |

## DM0002_ItembyDivisionPopupEx.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90ac13ab | this.spdMain.CellDoubleClick | DM0002_ItembyDivisionPopupEx.cs:500 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0002_ItembySmallDivPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eebb9a60 | this.btnButtonList.UsrButtonList_Click_Detected | DM0002_ItembySmallDivPopup.cs:433 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-a55b3ee6 | this.btnButtonList.UsrButtonList_Click_Detected | DM0002_ItembySmallDivPopup.cs:436 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0002_ItembySmallDivPopup.CreateSpread

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49490103 | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:262 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-43ecaf07 | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:263 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e9eee328 | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:264 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0002_ItembySmallDivPopup.DefineProperty

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84779f1c | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:257 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DM0002_ItembySmallDivPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9739216b | Dispose | DM0002_ItembySmallDivPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0002_ItembySmallDivPopup.FindData

진입점: this.Load [if (!blnVali)] / this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b838b706 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:353 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-750df586 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:354 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dba2b3aa | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:360 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-3975d754 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:367 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-80f90600 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:371 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx") ⇒ DM.DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx | 엔드포인트 요청 생성 |  |  |  |
| AC-a6243744 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:373 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e035f107 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:376 | lambda | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-f9e474c7 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:377 | lambda | DATA_OP | request.Parameters["p_dept_id"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-c24a344c | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:378 | lambda | DATA_OP | request.Parameters["p_end_customer"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-79ed0bbb | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:379 | lambda | DATA_OP | request.Parameters["p_project_code"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-f1b3b93e | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:380 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-b4c5e512 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:381 | lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-ebd14d67 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:382 | lambda | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-85a65205 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:383 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fe3c7cec | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:385 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-540aead7 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:389 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-48ea52d9 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:390 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d57d7bea | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:397 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-10164764 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:399 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DM0002_ItembySmallDivPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f74f6d85 | this.Load | DM0002_ItembySmallDivPopup.cs:175 | if (sDivision.IndexOf("82") >= 0 \|\| sDivision == "ALL" \|\| sDivision == "") ▸ if (sProject.Length < 3 && sItemId.Length < 3) | MESSAGE | MessageHelper.GMessageBox | ("MSG00147") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4a3ab0a3 | this.Load | DM0002_ItembySmallDivPopup.cs:176 | if (sDivision.IndexOf("82") >= 0 \|\| sDivision == "ALL" \|\| sDivision == "") ▸ if (sProject.Length < 3 && sItemId.Length < 3) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-bd502ab2 | this.Load | DM0002_ItembySmallDivPopup.cs:184 | if (!blnVali) | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-50b262e3 | this.Load | DM0002_ItembySmallDivPopup.cs:185 | if (!blnVali) | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-09c5dac0 | this.Load | DM0002_ItembySmallDivPopup.cs:194 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-c9f15149 | this.Load | DM0002_ItembySmallDivPopup.cs:195 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-f99eed13 | this.Load | DM0002_ItembySmallDivPopup.cs:196 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-b53178f9 | this.Load | DM0002_ItembySmallDivPopup.cs:197 |  | FLAG | sScmSiteId | _ScmSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-f71b7e7b | this.Load | DM0002_ItembySmallDivPopup.cs:198 |  | FLAG | sItemId | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-f0f2493e | this.Load | DM0002_ItembySmallDivPopup.cs:200 |  | FLAG | DeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-1da605f8 | this.Load | DM0002_ItembySmallDivPopup.cs:201 |  | FLAG | EndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |

## DM0002_ItembySmallDivPopup.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65dfa6b0 | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:539 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-a18d5210 | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:541 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c1ad938a | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:544 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0002_ItembySmallDivPopup.GetDivisionbyScmSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4da099d4 | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:553 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-9726a69d | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:554 |  | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-2258b1ca | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:555 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-3d55924a | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:556 |  | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-ede66d12 | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:558 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7c48f9e3 | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:561 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0002_ItembySmallDivPopup.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4327a1f | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:584 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-58c6e702 | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:585 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-0d18092e | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:586 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-0b197d63 | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:587 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b51a8e65 | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:590 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0002_ItembySmallDivPopup.GetSpdTitle

진입점: this.Load [if (!blnVali)] / this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9195c7a2 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:459 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-049f370e | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:460 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f197eb6e | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:461 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d53e7625 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:462 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0d56592d | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:463 |  | DATA_OP | request.Parameters["p_program_id"] | "SCM0002_40" | 행/컬럼 값 대입 |  |  |  |
| AC-be353a7a | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:464 |  | DATA_OP | request.Parameters["p_sheet_name"] | "ItemPopup" | 행/컬럼 값 대입 |  |  |  |
| AC-32e8e314 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:465 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-fe5a05a2 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:467 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-afb38c45 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:467 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6d2e243b | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:470 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0002_ItembySmallDivPopup.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25ccbf86 | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:570 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-2e508e44 | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:571 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-2daca4da | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:572 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c32505b9 | (진입점 미연결) | DM0002_ItembySmallDivPopup.cs:575 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0002_ItembySmallDivPopup.InitControls

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62fd6384 | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:211 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-1ac324b1 | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:211 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1ac34a56 | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:212 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c180c6c2 | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:214 |  | FLAG | dtItemType | Data.Common(Data.Type.ItemType, false, UserInfoContext.Current["NowGroupID"], UserInfoCont… ⇒ biz:CommonData.CommonDataList [code=ItemType] | 화면 필드/플래그 변경 |  |  |  |
| AC-0f4323b4 | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:214 |  | COMBO_DATA | Data.Common | (Data.Type.ItemType, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… ⇒ biz:CommonData.CommonDataList [code=ItemType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2aada850 | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:215 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c43adedc | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:216 |  | VALUE_SET | clbItemType.ControlValues | "P" | 컨트롤 값 설정 |  |  |  |
| AC-057c2f33 | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:238 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-70563697 | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:241 |  | VALUE_SET | txtItemID.Text | sItemId | 컨트롤 값 설정 |  |  |  |
| AC-84b6f09a | this.Load [if (!blnVali)] | DM0002_ItembySmallDivPopup.cs:246 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## DM0002_ItembySmallDivPopup.InitSpread

진입점: this.Load [if (!blnVali)] / this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76df801e | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:273 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-b2cab7df | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:278 | if (siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.DEPT_ID].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-25c2bf6d | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:280 | if (siMain.GetColumnIndex(DefColumns.DEPT_NAME) != -1) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.DEPT_NAME].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5316c472 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:282 | if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) != -1) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.END_CUSTOMER].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cf3f43a8 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:284 | if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) != -1) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.END_CUSTOMER40].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fdeb1cae | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:286 | if (siMain.GetColumnIndex(DefColumns.Project) != -1) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.Project].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cdd97e1d | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:288 | if (siMain.GetColumnIndex(DefColumns.ProjectName) != -1) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.ProjectName].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b938d39f | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:290 | if (siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.ScmSiteId].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-aa5fd4b3 | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:292 | if (siMain.GetColumnIndex(DefColumns.ScmSiteDesc) != -1) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.ScmSiteDesc].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-02aa5d6c | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:294 | if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.CURRENCY].Visible | false | 그리드 속성/값 설정 |  |  |  |

## DM0002_ItembySmallDivPopup.InitSpread_X

진입점: this.Load [if (!blnVali)] / this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff3b13cb | this.Load [if (!blnVali)] 외 3 | DM0002_ItembySmallDivPopup.cs:319 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0002_ItembySmallDivPopup.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26a7ed83 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:475 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e44ba029 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:477 |  | FLAG | itemID | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-555c4acd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:493 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b8dac2d1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:494 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemName | this.dtFindData.Rows[iRow][DefColumns.ItemName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d7b7b699 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:495 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemType | this.dtFindData.Rows[iRow][DefColumns.ItemType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f948ac89 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:496 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-376c0444 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:497 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemclassname | this.dtFindData.Rows[iRow][DefColumns.ItemClassName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7aadd478 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:498 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | currency | this.dtFindData.Rows[iRow][DefColumns.CURRENCY].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-35476af5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:499 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | msScmSiteId | this.dtFindData.Rows[iRow][DefColumns.ScmSiteId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-eea95ca2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:503 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | itemID + "," + this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b3ae722f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:504 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemName | itemName + "," + this.dtFindData.Rows[iRow][DefColumns.ItemName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-84017aa0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:505 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemType | itemType + "," + this.dtFindData.Rows[iRow][DefColumns.ItemType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-de49deb0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:506 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | nickName + "," + this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-154b62ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:507 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemclassname | itemclassname + "," + this.dtFindData.Rows[iRow][DefColumns.ItemClassName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2e82d695 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:508 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | currency | currency + "," + this.dtFindData.Rows[iRow][DefColumns.CURRENCY].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-993a9458 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:509 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | msScmSiteId | msScmSiteId + "," + this.dtFindData.Rows[iRow][DefColumns.ScmSiteId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f7bafb8a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:517 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15ea8254 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:522 | else of (bMulltiSelect) | FLAG | itemID | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-be2db65d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:523 | else of (bMulltiSelect) | FLAG | itemName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-f3bbf472 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:524 | else of (bMulltiSelect) | FLAG | itemType | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemType)) | 화면 필드/플래그 변경 |  |  |  |
| AC-a9021918 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:525 | else of (bMulltiSelect) | FLAG | nickName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NickName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff70138e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:526 | else of (bMulltiSelect) | FLAG | itemclassname | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemClassName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-860bfe5c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:527 | else of (bMulltiSelect) | FLAG | currency | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY)) | 화면 필드/플래그 변경 |  |  |  |
| AC-62aeacd7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_ItembySmallDivPopup.cs:528 | else of (bMulltiSelect) | FLAG | msScmSiteId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)) | 화면 필드/플래그 변경 |  |  |  |

## DM0002_ItembySmallDivPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30c3afcb | this.spdMain.CellDoubleClick | DM0002_ItembySmallDivPopup.cs:450 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0002_MatsterChgPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13e7cc1b | this.btnButtonList.UsrButtonList_Click_Detected | DM0002_MatsterChgPopup.cs:799 | switch (buttonItem.UserType) case ButtonListType.Cancel: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0002_MatsterChgPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4462e1f6 | this.Load | DM0002_MatsterChgPopup.cs:282 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 60) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5e30ab05 | this.Load | DM0002_MatsterChgPopup.cs:283 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-fba14c09 | this.Load | DM0002_MatsterChgPopup.cs:287 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0002_MatsterChgPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54a6af26 | Dispose | DM0002_MatsterChgPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0002_MatsterChgPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-667e26ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:344 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a7fe25d3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:345 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3ecb4fe1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:353 | try | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-688e5bef | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:357 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e2c2124e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:359 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { //… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a2680271 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:364 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_MASTER_CHG_POPUP") ⇒ DM.DMF0000_GET_MASTER_CHG_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-f7e56a43 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:365 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-638a68e0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:366 | try ▸ lambda | DATA_OP | request.Parameters["p_team_id"] | CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-a1732bb7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:367 | try ▸ lambda | DATA_OP | request.Parameters["p_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-804bda3d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:368 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-4792fe88 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:369 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-54ba74f9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:370 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9c1834af | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:371 | try ▸ lambda | DATA_OP | request.Parameters["p_user_group"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c8c411c3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:372 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-48bd0512 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:374 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-10668da9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:378 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-17a3ae7a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:379 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d5965bac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:386 | try | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-add95c86 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:390 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5f1deb86 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:392 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8b2cd88f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:393 | try | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c408b263 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:395 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.FcstTypeName), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0c2797c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:396 | try | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.Incoterms), siMain.GetColumnIndex(DefColumns.Incoterms),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c797add4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:397 | try | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PlantSite), siMain.GetColumnIndex(DefColumns.PlantSite),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-074949d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:398 | try | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DomExp), siMain.GetColumnIndex(DefColumns.DomExp), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5a5c375d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:402 | try ▸ if (clbDivision.ControlValues == "40") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.NewDomExp), siMain.GetColumnIndex(DefColumns.NewDomExp),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-595457f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:405 | try ▸ else of (clbDivision.ControlValues == "40") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.NewDomExp), siMain.GetColumnIndex(DefColumns.NewDomExp),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-78565c54 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:408 | try | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.EditFlag), siMain.GetColumnIndex(DefColumns.EditFlag), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-59aab3ea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:412 | try ▸ if (clbDivision.ControlValues == "82") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.NewPlantSite), siMain.GetColumnIndex(DefColumns.NewPlant… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6c935280 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:418 | try ▸ if (clbDivision.ControlValues == "40") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.DomExp) > 0) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NewDomExp), siMain.GetValue(iRow, siMain.GetColumn… | 그리드 값 설정 |  |  |  |
| AC-a4592a23 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:501 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4bd219ea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:502 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d0649bb7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:507 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e3357133 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:511 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4c1924ac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:512 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DM0002_MatsterChgPopup.fnValidation

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK: ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ba83af4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:911 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-9adac2a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:914 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DM0002_MatsterChgPopup.fnValidation2

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK: ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25c8892b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:979 | for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (Division0 == Division1 && Team0 == Team1 && SalesSite0 == SalesSite1 && ProjectCode0 == Pro… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-77573521 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:982 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## DM0002_MatsterChgPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c58bbab7 | this.Load | DM0002_MatsterChgPopup.cs:152 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9430d26e | this.Load | DM0002_MatsterChgPopup.cs:154 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ac1a65b2 | this.Load | DM0002_MatsterChgPopup.cs:163 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-e3e82095 | this.Load | DM0002_MatsterChgPopup.cs:164 |  | UI_PROP | this.IsPopupEditCheck | false | 속성 IsPopupEditCheck 설정 |  |  |  |
| AC-a0d60a3b | this.Load | DM0002_MatsterChgPopup.cs:169 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-29005586 | this.Load | DM0002_MatsterChgPopup.cs:170 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-6365443a | this.Load | DM0002_MatsterChgPopup.cs:171 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-52bc1fc7 | this.Load | DM0002_MatsterChgPopup.cs:172 |  | FLAG | DeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-0161e89e | this.Load | DM0002_MatsterChgPopup.cs:173 |  | FLAG | EndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |
| AC-0ebaf728 | this.Load | DM0002_MatsterChgPopup.cs:174 |  | FLAG | SCM_SITE_ID | _SCM_SITE_ID | 화면 필드/플래그 변경 |  |  |  |

## DM0002_MatsterChgPopup.GetLookupValues

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-171f5df6 | this.Load | DM0002_MatsterChgPopup.cs:828 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-a426123b | this.Load | DM0002_MatsterChgPopup.cs:829 |  | DATA_OP | request.Parameters["p_lookup_type"] | sLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-2301d12f | this.Load | DM0002_MatsterChgPopup.cs:830 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6d8f203c | this.Load | DM0002_MatsterChgPopup.cs:833 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0002_MatsterChgPopup.GetSpdTitle

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e0e5ed4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:808 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM_H.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-0fb16cf8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:809 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3f617928 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:810 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b1085cc6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:811 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6d10ab04 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:812 |  | DATA_OP | request.Parameters["p_program_id"] | "SCM0002_MasterChgPopup" | 행/컬럼 값 대입 |  |  |  |
| AC-39cb8199 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:813 |  | DATA_OP | request.Parameters["p_sheet_name"] | "MasterChg Popup" | 행/컬럼 값 대입 |  |  |  |
| AC-ecdd62a9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:814 |  | DATA_OP | request.Parameters["p_division_id"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-2438172e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:816 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ded209be | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:816 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d87541c3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:819 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0002_MatsterChgPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc191cfa | this.Load | DM0002_MatsterChgPopup.cs:182 | if (sDivision == "40") | VALUE_SET | layoutControlItem1.Text | "End Customer" | 컨트롤 값 설정 |  |  |  |
| AC-7f66333e | this.Load | DM0002_MatsterChgPopup.cs:183 | if (sDivision == "40") | UI_PROP | lblEndCustomer.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-34133820 | this.Load | DM0002_MatsterChgPopup.cs:187 | else of (sDivision == "40") | VALUE_SET | layoutControlItem1.Text | "Project" | 컨트롤 값 설정 |  |  |  |
| AC-1efcd486 | this.Load | DM0002_MatsterChgPopup.cs:188 | else of (sDivision == "40") | UI_PROP | lblEndCustomer.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-693e5f6d | this.Load | DM0002_MatsterChgPopup.cs:191 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-b8d4a350 | this.Load | DM0002_MatsterChgPopup.cs:191 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ac390d55 | this.Load | DM0002_MatsterChgPopup.cs:192 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d082d6bf | this.Load | DM0002_MatsterChgPopup.cs:194 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-1a383386 | this.Load | DM0002_MatsterChgPopup.cs:194 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5ff53d44 | this.Load | DM0002_MatsterChgPopup.cs:195 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2c15fec9 | this.Load | DM0002_MatsterChgPopup.cs:198 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-2042d200 | this.Load | DM0002_MatsterChgPopup.cs:198 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4bc37e18 | this.Load | DM0002_MatsterChgPopup.cs:200 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-53220bd2 | this.Load | DM0002_MatsterChgPopup.cs:203 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-71cb17ab | this.Load | DM0002_MatsterChgPopup.cs:203 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c07e6cf8 | this.Load | DM0002_MatsterChgPopup.cs:205 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5e2c259f | this.Load | DM0002_MatsterChgPopup.cs:207 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-a2ccf40e | this.Load | DM0002_MatsterChgPopup.cs:208 |  | VALUE_SET | txtProject.Text | sProject | 컨트롤 값 설정 |  |  |  |
| AC-fa2b495a | this.Load | DM0002_MatsterChgPopup.cs:213 | if (sDivision == "40") ▸ if ((UserInfoContext.Current["NowGroupID"].ToString() == "ADMIN") \|\| (UserInfoContext.Current["NowGroupID"].ToStr… | VALUE_SET | clbTeam.ControlValues | DeptID | 컨트롤 값 설정 |  |  |  |
| AC-e0034d57 | this.Load | DM0002_MatsterChgPopup.cs:217 | if (sDivision == "40") ▸ else of ((UserInfoContext.Current["NowGroupID"].ToString() == "ADMIN") \|\| (UserInfoContext.Current["NowGroupID"].… | VALUE_SET | clbTeam.ControlValues | UserInfoContext.Current["Dept_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-4591d060 | this.Load | DM0002_MatsterChgPopup.cs:222 | else of (sDivision == "40") | VALUE_SET | clbTeam.ControlValues | DeptID | 컨트롤 값 설정 |  |  |  |
| AC-2808e6f7 | this.Load | DM0002_MatsterChgPopup.cs:224 |  | VALUE_SET | clbEndCustomer.ControlValues | EndCustomer | 컨트롤 값 설정 |  |  |  |
| AC-be3d65e8 | this.Load | DM0002_MatsterChgPopup.cs:225 |  | VALUE_SET | clbSalesSite.ControlValues | SCM_SITE_ID | 컨트롤 값 설정 |  |  |  |
| AC-fa7f5beb | this.Load | DM0002_MatsterChgPopup.cs:227 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b2e9fbd6 | this.Load | DM0002_MatsterChgPopup.cs:228 |  | STATE | clbTeam.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8c294d78 | this.Load | DM0002_MatsterChgPopup.cs:229 |  | STATE | clbEndCustomer.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5cdf58c9 | this.Load | DM0002_MatsterChgPopup.cs:230 |  | STATE | clbSalesSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7fac6537 | this.Load | DM0002_MatsterChgPopup.cs:234 |  | FLAG | dtIncoterms | GetLookupValues("INCOTERMS") | 화면 필드/플래그 변경 |  |  |  |
| AC-0ec5a43d | this.Load | DM0002_MatsterChgPopup.cs:235 |  | FLAG | dtFcstType | GetLookupValues("SALES_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-5829fd5b | this.Load | DM0002_MatsterChgPopup.cs:239 |  | FLAG | dtDomExp | GetLookupValues("DOM/EXP") | 화면 필드/플래그 변경 |  |  |  |

## DM0002_MatsterChgPopup.InitSaveDataTable

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-452a8445 | this.Load | DM0002_MatsterChgPopup.cs:255 |  | FLAG | dtSave | new DataTable("AdjstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-93ddd51b | this.Load | DM0002_MatsterChgPopup.cs:256 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4acd0c21 | this.Load | DM0002_MatsterChgPopup.cs:257 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Team, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-988b453e | this.Load | DM0002_MatsterChgPopup.cs:258 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.SalesSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8de80b1a | this.Load | DM0002_MatsterChgPopup.cs:259 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ProjectCode, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-57fd0bfe | this.Load | DM0002_MatsterChgPopup.cs:260 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Model, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b99a6017 | this.Load | DM0002_MatsterChgPopup.cs:261 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a54b3f28 | this.Load | DM0002_MatsterChgPopup.cs:262 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-837fb8d4 | this.Load | DM0002_MatsterChgPopup.cs:263 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PlantSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-db0b9053 | this.Load | DM0002_MatsterChgPopup.cs:264 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DomExp, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ba5a046 | this.Load | DM0002_MatsterChgPopup.cs:266 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.NewIncoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6cf8f47 | this.Load | DM0002_MatsterChgPopup.cs:267 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.NewFcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0b8f837 | this.Load | DM0002_MatsterChgPopup.cs:268 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.NewPlantSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e858baa4 | this.Load | DM0002_MatsterChgPopup.cs:269 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.NewDomExp, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DM0002_MatsterChgPopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-992672da | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:297 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-c156efab | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0002_MatsterChgPopup.cs:300 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0002_MatsterChgPopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8611cace | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:549 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation2() == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ffd32046 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:550 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation2() == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fdee8eb9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:555 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!fnValidation()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3673962d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:556 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!fnValidation()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-778cbdad | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:643 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0003_SAVE_MKT_FCST_PK_DATA_UPDATE | 엔드포인트 요청 생성 |  |  |  |
| AC-804e0b46 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:644 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-895bafa7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:645 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | pProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-7dbb44bb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:646 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | pSalesSite | 행/컬럼 값 대입 |  |  |  |
| AC-a0a83c1e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:647 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | pModel | 행/컬럼 값 대입 |  |  |  |
| AC-378d9d5b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:648 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dom_exp"] | pDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-845c7720 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:649 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fcst_type"] | pFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-c50437d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:650 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_incoterms"] | pIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-9d9d391d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:651 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_site_id"] | pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-302ecac4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:653 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dom_exp_new"] | pNewDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-17dedb23 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:654 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fcst_type_new"] | pNewFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-337ef20e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:655 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_incoterms_new"] | pNewIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-83d912b0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:656 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_site_id_new"] | pNewPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-03b8e2c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:657 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_site_id_new"] | pNewPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-5ab39449 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:659 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | pUserId | 행/컬럼 값 대입 |  |  |  |
| AC-8665681a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:661 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4e0eee2a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:663 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-de8776d8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:667 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-566524c8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:673 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00343") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c507184 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:675 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-63c12b26 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:679 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-abbf8fdf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:681 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | UI_PROP | this.IsPopupEditCheck | false | 속성 IsPopupEditCheck 설정 |  |  |  |
| AC-18d63b41 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:682 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c15ef53f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:683 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-442a13cb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:690 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-07eb9013 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0002_MatsterChgPopup.cs:698 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0002_MatsterChgPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d685b35 | this.spdMain.CellClick | DM0002_MatsterChgPopup.cs:997 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.NewPlantSite) \|\| sDivision == "81") | FLAG | sDivision | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0a8c77f0 | this.spdMain.CellClick | DM0002_MatsterChgPopup.cs:998 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.NewPlantSite) \|\| sDivision == "81") | FLAG | sProject | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ProjectCode)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f29220ca | this.spdMain.CellClick | DM0002_MatsterChgPopup.cs:1001 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.NewPlantSite) \|\| sDivision == "81") | FLAG | dtPlantSite | Data.Common(Data.Type.PlantSiteByItem, false, "", sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByItem] | 화면 필드/플래그 변경 |  |  |  |
| AC-f06454c4 | this.spdMain.CellClick | DM0002_MatsterChgPopup.cs:1001 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.NewPlantSite) \|\| sDivision == "81") | COMBO_DATA | Data.Common | (Data.Type.PlantSiteByItem, false, "", sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByItem] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-811a2fd9 | this.spdMain.CellClick | DM0002_MatsterChgPopup.cs:1002 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.NewPlantSite) \|\| sDivision == "81") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.NewPlantSite), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0002_MatsterChgPopup.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbd24513 | dsdm.Changed | DM0002_MatsterChgPopup.cs:710 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf366aa7 | dsdm.Changed | DM0002_MatsterChgPopup.cs:749 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-551f90ba | dsdm.Changed | DM0002_MatsterChgPopup.cs:753 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b7547f7d | dsdm.Changed | DM0002_MatsterChgPopup.cs:754 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | tempDivision | 행/컬럼 값 대입 |  |  |  |
| AC-f3475693 | dsdm.Changed | DM0002_MatsterChgPopup.cs:755 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Team] | tempTeam | 행/컬럼 값 대입 |  |  |  |
| AC-a60ee8ba | dsdm.Changed | DM0002_MatsterChgPopup.cs:756 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.SalesSite] | tempSalesSite | 행/컬럼 값 대입 |  |  |  |
| AC-1926063b | dsdm.Changed | DM0002_MatsterChgPopup.cs:757 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ProjectCode] | tempProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-5951f7ae | dsdm.Changed | DM0002_MatsterChgPopup.cs:758 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Model] | tempModel | 행/컬럼 값 대입 |  |  |  |
| AC-31924f86 | dsdm.Changed | DM0002_MatsterChgPopup.cs:759 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | tempFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-28e8b80c | dsdm.Changed | DM0002_MatsterChgPopup.cs:760 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | tempIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-cfdab515 | dsdm.Changed | DM0002_MatsterChgPopup.cs:761 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.PlantSite] | tempPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-29de4e8b | dsdm.Changed | DM0002_MatsterChgPopup.cs:762 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DomExp] | tempDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-711e1bbe | dsdm.Changed | DM0002_MatsterChgPopup.cs:764 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.NewIncoterms] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.NewIncoterms)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-61efb6e5 | dsdm.Changed | DM0002_MatsterChgPopup.cs:765 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.NewFcstType] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.NewFcstType)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a75a5ef1 | dsdm.Changed | DM0002_MatsterChgPopup.cs:767 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) ▸ if (sDivision != "40") | DATA_OP | drNew[DefColumns.NewPlantSite] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.NewPlantSite)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c4ceb976 | dsdm.Changed | DM0002_MatsterChgPopup.cs:768 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.NewDomExp] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.NewDomExp)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dbc9785c | dsdm.Changed | DM0002_MatsterChgPopup.cs:770 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-80f9c31f | dsdm.Changed | DM0002_MatsterChgPopup.cs:771 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-89f65628 | dsdm.Changed | DM0002_MatsterChgPopup.cs:772 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (drFind.Length == 0) | UI_PROP | this.IsPopupEditCheck | true | 속성 IsPopupEditCheck 설정 |  |  |  |
| AC-85f1027a | dsdm.Changed | DM0002_MatsterChgPopup.cs:776 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.NewIncoterms] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.NewIncoterms)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-45780f86 | dsdm.Changed | DM0002_MatsterChgPopup.cs:777 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.NewFcstType] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.NewFcstType)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8208e0a7 | dsdm.Changed | DM0002_MatsterChgPopup.cs:779 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (drFind.Length == 0) ▸ if (sDivision != "40") | DATA_OP | drFind[0][DefColumns.NewPlantSite] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.NewPlantSite)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-baadf2ca | dsdm.Changed | DM0002_MatsterChgPopup.cs:780 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.NewDomExp] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.NewDomExp)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a300b35f | dsdm.Changed | DM0002_MatsterChgPopup.cs:781 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DM0002_OwnerInfoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7490bad0 | this.Load | DM0002_OwnerInfoPopup.cs:124 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-16f761cf | this.Load | DM0002_OwnerInfoPopup.cs:125 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5028290f | this.Load | DM0002_OwnerInfoPopup.cs:126 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0002_OwnerInfoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dca494ce | this.Load | DM0002_OwnerInfoPopup.cs:109 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-427a237d | this.Load | DM0002_OwnerInfoPopup.cs:116 | if (SSOUserYN \|\| SingleSelectYn) | DATA_OP | list.Add | (ButtonListType.OK) | 데이터 객체 조작/조회 |  |  |  |
| AC-d80dd0a6 | this.Load | DM0002_OwnerInfoPopup.cs:119 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |

## DM0002_OwnerInfoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc613df7 | Dispose | DM0002_OwnerInfoPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0002_OwnerInfoPopup.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecf9c10a | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:170 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.DM.Master.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-81191061 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:174 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0005_GET_OWNERINFO") ⇒ DM.DMF0005_GET_OWNERINFO | 엔드포인트 요청 생성 |  |  |  |
| AC-6ef0f7e9 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:175 | lambda | DATA_OP | request.Parameters["Search"] | this.txtSearch.Text | 행/컬럼 값 대입 |  |  |  |
| AC-5b9bf210 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:176 | lambda | DATA_OP | request.Parameters["Language"] | Language | 행/컬럼 값 대입 |  |  |  |
| AC-296ebb17 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:178 | lambda | DATA_OP | request.Parameters["p_created_by"] | p_CreatedBy | 행/컬럼 값 대입 |  |  |  |
| AC-1d139645 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:179 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5e62977b | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:181 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-cb857f08 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:185 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2aaa4f77 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:186 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-46d47861 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:189 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0002_OwnerInfoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-569f6746 | this.Load | DM0002_OwnerInfoPopup.cs:92 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c04d65ea | this.Load | DM0002_OwnerInfoPopup.cs:93 |  | VALUE_SET | this.txtSearch.Text | p_Owner | 컨트롤 값 설정 |  |  |  |

## DM0002_OwnerInfoPopup.InitSpread

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0cf6dbf | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:133 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7e927657 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:136 | if (!SSOUserYN && !SingleSelectYn) | CALL_EXT | siMain.AddSelectionCheckBox | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc4732a2 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:138 |  | GRID_INIT | siMain.AddTextColumn | ("UserID", DefColumns.UserID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6640e931 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:139 |  | GRID_INIT | siMain.AddTextColumn | ("UserName", DefColumns.UserName, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eab9537b | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:140 |  | GRID_INIT | siMain.AddTextColumn | ("EnglishName", DefColumns.UserName_E, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b6dd0e16 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:142 | if (!SSOUserYN && !SingleSelectYn) | GRID_INIT | siMain.AddTextColumn | ("Email", DefColumns.Email, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d22b73e | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:143 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_ID", DefColumns.Dept_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2cad30c1 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:144 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_Name", DefColumns.Dept_Name, FPMerge.None, 240, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59c52651 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:146 | if (!SSOUserYN && !SingleSelectYn) | GRID_INIT | siMain.AddComboColumn | ("UseYN", DefColumns.UseYN, FPMerge.None, 60, true, Data.Common(Data.Type.YesOrNo), FPHAli… ⇒ biz:CommonData.YesOrNo | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9cbdca9 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:146 | if (!SSOUserYN && !SingleSelectYn) | COMBO_DATA | Data.Common | (Data.Type.YesOrNo) ⇒ biz:CommonData.YesOrNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-47ee0185 | this.Load 외 2 | DM0002_OwnerInfoPopup.cs:148 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.UserID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0002_OwnerInfoPopup.OkButtonClick

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1018c3a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0002_OwnerInfoPopup.cs:242 | for (i <= siMain.GetMaxRowIndex()) ▸ if (chk.Equals("True")) | DATA_OP | lstUserInfo.Add | (new SelectedUserInfo() { UserID = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.User… | 데이터 객체 조작/조회 |  |  |  |
| AC-5d440710 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0002_OwnerInfoPopup.cs:259 |  | FLAG | SelectedUserInfoList | lstUserInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-fe5fe76f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0002_OwnerInfoPopup.cs:262 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0002_OwnerInfoPopup.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6616f501 | this.spdMain.CellClick | DM0002_OwnerInfoPopup.cs:219 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-13daccb9 | this.spdMain.CellClick | DM0002_OwnerInfoPopup.cs:220 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-fa54ccd6 | this.spdMain.CellClick | DM0002_OwnerInfoPopup.cs:224 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-d7928fc9 | this.spdMain.CellClick | DM0002_OwnerInfoPopup.cs:225 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |

## DM0002_OwnerInfoPopup.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-994f6567 | spdMain.CellDoubleClick | DM0002_OwnerInfoPopup.cs:269 |  | DATA_OP | lstUserInfo.Add | (new SelectedUserInfo() { UserID = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.… | 데이터 객체 조작/조회 |  |  |  |
| AC-440bb0d7 | spdMain.CellDoubleClick | DM0002_OwnerInfoPopup.cs:283 |  | FLAG | SelectedUserInfoList | lstUserInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-ad7f08f1 | spdMain.CellDoubleClick | DM0002_OwnerInfoPopup.cs:286 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0002_TitleSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d15f83bb | .ctor | DM0002_TitleSetForm_Popup.cs:65 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-2be715ab | .ctor | DM0002_TitleSetForm_Popup.cs:66 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-52b429cb | .ctor | DM0002_TitleSetForm_Popup.cs:67 |  | FLAG | _sTitleSetType | isColumn ? "C" : "M" | 화면 필드/플래그 변경 |  |  |  |
| AC-b36cfb85 | .ctor | DM0002_TitleSetForm_Popup.cs:77 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-faf723d2 | .ctor | DM0002_TitleSetForm_Popup.cs:78 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-5b4054b2 | .ctor | DM0002_TitleSetForm_Popup.cs:79 |  | FLAG | _sTitleSetType | isColumn ? "C" : "M" | 화면 필드/플래그 변경 |  |  |  |
| AC-f60f752a | .ctor | DM0002_TitleSetForm_Popup.cs:80 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |
| AC-e3c58401 | .ctor | DM0002_TitleSetForm_Popup.cs:88 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-0cafce62 | .ctor | DM0002_TitleSetForm_Popup.cs:89 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-87b1245a | .ctor | DM0002_TitleSetForm_Popup.cs:90 |  | FLAG | _sTitleSetType | isColumn ? "C" : "M" | 화면 필드/플래그 변경 |  |  |  |
| AC-f18d51f1 | .ctor | DM0002_TitleSetForm_Popup.cs:92 |  | FLAG | _dtTitleSet | dt | 화면 필드/플래그 변경 |  |  |  |
| AC-9d0732b8 | .ctor | DM0002_TitleSetForm_Popup.cs:98 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-b205fc09 | .ctor | DM0002_TitleSetForm_Popup.cs:99 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-6d741e64 | .ctor | DM0002_TitleSetForm_Popup.cs:100 |  | FLAG | _sTitleSetType | isColumn ? "C" : "M" | 화면 필드/플래그 변경 |  |  |  |
| AC-5e5b2b93 | .ctor | DM0002_TitleSetForm_Popup.cs:102 |  | FLAG | _dtTitleSet | dt | 화면 필드/플래그 변경 |  |  |  |
| AC-508102a9 | .ctor | DM0002_TitleSetForm_Popup.cs:108 | for (k < sBtnList.Length) | DATA_OP | usrButtonList2.UsrButtonItems.Add | (new ButtonItem(ButtonListType.Default, sBtnList[k], false, true, false)) | 데이터 객체 조작/조회 |  |  |  |
| AC-45b18670 | .ctor | DM0002_TitleSetForm_Popup.cs:110 |  | STATE | usrButtonList2.Visible | true | 컨트롤 상태 Visible |  |  |  |

## DM0002_TitleSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a00852d | Dispose | DM0002_TitleSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0002_TitleSetForm_Popup.GetTitleSet

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bd1d3e1 | .ctor | DM0002_TitleSetForm_Popup.cs:244 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0002_GET_TITLESET_POPUP") ⇒ DM.DMF0002_GET_TITLESET_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-bad5a3b3 | .ctor | DM0002_TitleSetForm_Popup.cs:245 |  | DATA_OP | request.Parameters["p_program_id"] | _sProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-2ea7c5ce | .ctor | DM0002_TitleSetForm_Popup.cs:246 |  | DATA_OP | request.Parameters["p_sheet_name"] | _sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-e503b326 | .ctor | DM0002_TitleSetForm_Popup.cs:247 |  | DATA_OP | request.Parameters["p_column_type"] | _sTitleSetType | 행/컬럼 값 대입 |  |  |  |
| AC-756cb9b1 | .ctor | DM0002_TitleSetForm_Popup.cs:248 |  | DATA_OP | request.Parameters["p_user_id"] | _sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-5f1b2146 | .ctor | DM0002_TitleSetForm_Popup.cs:249 |  | DATA_OP | request.Parameters["p_division_id"] | _sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-d3d468a3 | .ctor | DM0002_TitleSetForm_Popup.cs:250 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e0060db | .ctor | DM0002_TitleSetForm_Popup.cs:251 |  | FLAG | _dtTitleSet | response.DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## DM0002_TitleSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36993a67 | this.Load | DM0002_TitleSetForm_Popup.cs:130 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## DM0002_TitleSetForm_Popup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dae85df5 | this.Load | DM0002_TitleSetForm_Popup.cs:134 |  | UI_PROP | pnlBottom.Dock | DockStyle.Bottom | 속성 Dock 설정 |  |  |  |
| AC-533d9a27 | this.Load | DM0002_TitleSetForm_Popup.cs:136 |  | UI_PROP | pnlCenter.Dock | DockStyle.Left | 속성 Dock 설정 |  |  |  |
| AC-ca997f81 | this.Load | DM0002_TitleSetForm_Popup.cs:138 |  | UI_PROP | spdBase.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-404ead0d | this.Load | DM0002_TitleSetForm_Popup.cs:139 |  | UI_PROP | spdUser.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-25eeba5d | this.Load | DM0002_TitleSetForm_Popup.cs:140 |  | UI_PROP | splMain.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-0b8f6701 | this.Load | DM0002_TitleSetForm_Popup.cs:142 |  | VALUE_SET | this.Text | _sTitleSetType == "C" ? "Column Setting" : "Measure Setting" | 컨트롤 값 설정 |  |  |  |
| AC-ee9a3f24 | this.Load | DM0002_TitleSetForm_Popup.cs:143 |  | UI_PROP | this.Size | new Size(440, 400) | 속성 Size 설정 |  |  |  |
| AC-8ae86ed6 | this.Load | DM0002_TitleSetForm_Popup.cs:146 |  | UI_PROP | this.Size | new Size(_sTitleSetType == "C" ? 600 : 600, 400) | 속성 Size 설정 |  |  |  |
| AC-f321ccfb | this.Load | DM0002_TitleSetForm_Popup.cs:149 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth)) | 속성 SplitterDistance 설정 |  |  |  |
| AC-856e3181 | this.Load | DM0002_TitleSetForm_Popup.cs:150 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth) / 2) | 속성 SplitterDistance 설정 |  |  |  |

## DM0002_TitleSetForm_Popup.InitSheet

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f0752b7 | this.Load | DM0002_TitleSetForm_Popup.cs:157 |  | DATA_OP | dt.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e346031 | this.Load | DM0002_TitleSetForm_Popup.cs:158 |  | DATA_OP | dt.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f48e949 | this.Load | DM0002_TitleSetForm_Popup.cs:159 |  | DATA_OP | dt.Rows.Add | (new object[] { "ASC", "ASC" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-45005bfa | this.Load | DM0002_TitleSetForm_Popup.cs:160 |  | DATA_OP | dt.Rows.Add | (new object[] { "DESC", "DESC" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2f085e5 | this.Load | DM0002_TitleSetForm_Popup.cs:176 |  | GRID_INIT | this.AddSheet | (spdBase, "Base", "Base", 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f70dee75 | this.Load | DM0002_TitleSetForm_Popup.cs:178 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-389186f2 | this.Load | DM0002_TitleSetForm_Popup.cs:179 |  | UI_PROP | si.IsRowMove | !_isBaseSort | 속성 IsRowMove 설정 |  |  |  |
| AC-c6b4ebe0 | this.Load | DM0002_TitleSetForm_Popup.cs:180 |  | GRID_INIT | si.AddTextColumn | ("ColumnName", "COLUMN_NAME", FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a9d0c70 | this.Load | DM0002_TitleSetForm_Popup.cs:182 |  | GRID_INIT | si.AddTextColumn | ("LargeClass", "LARGE_CLASS_LABEL_NAME", FPMerge.Always, 80, isLarge) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a1bf1221 | this.Load | DM0002_TitleSetForm_Popup.cs:183 |  | GRID_INIT | si.AddTextColumn | ("SmallClass", "SMALL_CLASS_LABEL_NAME", FPMerge.Always, 80, isSmall) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d963fa05 | this.Load | DM0002_TitleSetForm_Popup.cs:184 |  | GRID_INIT | si.AddTextColumn | (columnTitle, "COLUMN_LABEL_NAME", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0edcc5f7 | this.Load | DM0002_TitleSetForm_Popup.cs:185 |  | GRID_INIT | si.AddTextColumn | ("Sort", "SORT_METHOD_CODE", FPMerge.None, 45, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-60866731 | this.Load | DM0002_TitleSetForm_Popup.cs:186 |  | GRID_INIT | si.AddNumColumn | ("Seq", "SORT_ORDER_NO", FPMerge.None, 20, false, FPHAlign.Right, FPVAlign.Center, 2, fals… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d0c4da51 | this.Load | DM0002_TitleSetForm_Popup.cs:187 |  | GRID_INIT | si.AddTextColumn | ("Sort", "USER_SORT_METHOD_CODE", FPMerge.None, 45, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-58676ae3 | this.Load | DM0002_TitleSetForm_Popup.cs:188 |  | GRID_INIT | si.AddCheckColumn | ("Sub Total", "SUB_TOTAL_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-983017f3 | this.Load | DM0002_TitleSetForm_Popup.cs:189 |  | GRID_INIT | si.AddTextColumn | ("USER_SELECTABLE_FLAG", "USER_SELECTABLE_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-682bc7db | this.Load | DM0002_TitleSetForm_Popup.cs:191 |  | GRID_SET | spdBase.Sheets[0].Columns[0, spdBase.Sheets[0].ColumnCount - 1].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-1485f02b | this.Load | DM0002_TitleSetForm_Popup.cs:194 |  | GRID_INIT | this.AddSheet | (spdUser, "User", "User", 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fcb92bd0 | this.Load | DM0002_TitleSetForm_Popup.cs:196 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-31e10245 | this.Load | DM0002_TitleSetForm_Popup.cs:197 |  | UI_PROP | si.IsRowMove | !_isBaseSort | 속성 IsRowMove 설정 |  |  |  |
| AC-9617c199 | this.Load | DM0002_TitleSetForm_Popup.cs:198 |  | GRID_INIT | si.AddTextColumn | ("ColumnName", "COLUMN_NAME", FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-132734c6 | this.Load | DM0002_TitleSetForm_Popup.cs:200 |  | GRID_INIT | si.AddTextColumn | ("LargeClass", "LARGE_CLASS_LABEL_NAME", FPMerge.Always, 80, isLarge) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-21794b0c | this.Load | DM0002_TitleSetForm_Popup.cs:201 |  | GRID_INIT | si.AddTextColumn | ("SmallClass", "SMALL_CLASS_LABEL_NAME", FPMerge.Always, 80, isSmall) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e470c97 | this.Load | DM0002_TitleSetForm_Popup.cs:202 |  | GRID_INIT | si.AddTextColumn | (columnTitle, "COLUMN_LABEL_NAME", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37900637 | this.Load | DM0002_TitleSetForm_Popup.cs:203 |  | GRID_INIT | si.AddTextColumn | ("Sort", "SORT_METHOD_CODE", FPMerge.None, 45, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a072a56b | this.Load | DM0002_TitleSetForm_Popup.cs:204 |  | GRID_INIT | si.AddNumColumn | ("Seq", "SORT_ORDER_NO", FPMerge.None, 20, false, FPHAlign.Right, FPVAlign.Center, 2, fals… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2200ff69 | this.Load | DM0002_TitleSetForm_Popup.cs:205 |  | GRID_INIT | si.AddComboColumn | ("Sort", "USER_SORT_METHOD_CODE", FPMerge.None, 45, isColumn, dt) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66094890 | this.Load | DM0002_TitleSetForm_Popup.cs:206 |  | GRID_INIT | si.AddCheckColumn | ("Sub Total", "SUB_TOTAL_FLAG", FPMerge.None, 40, _isSubTotal, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-747b28e7 | this.Load | DM0002_TitleSetForm_Popup.cs:207 |  | GRID_INIT | si.AddTextColumn | ("USER_SELECTABLE_FLAG", "USER_SELECTABLE_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-69b4abc0 | this.Load | DM0002_TitleSetForm_Popup.cs:209 |  | GRID_SET | spdUser.Sheets[0].Columns[0, spdUser.Sheets[0].Columns["COLUMN_LABEL_NAME"].Index].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-d5b553fe | this.Load | DM0002_TitleSetForm_Popup.cs:210 |  | GRID_SET | spdUser.Sheets[0].Columns[spdUser.Sheets[0].Columns["USER_SORT_METHOD_CODE"].Index, spdUse… | ControlColor.UnLockColor | 그리드 속성/값 설정 |  |  |  |

## DM0002_TitleSetForm_Popup.ResetWidth

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9be2492 | this.Load | DM0002_TitleSetForm_Popup.cs:232 |  | UI_PROP | this.Width | += iWidth | 속성 Width 설정 |  |  |  |
| AC-c148fcd6 | this.Load | DM0002_TitleSetForm_Popup.cs:233 |  | UI_PROP | splMain.SplitterDistance | this.Width / 2 - iWidth2 | 속성 SplitterDistance 설정 |  |  |  |

## DM0002_TitleSetForm_Popup.SaveTitleSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7637e279 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:510 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ SCM.SCM0002_SET_TITLESET_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-79ff48b0 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:511 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_program_id"] | sProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-4816590e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:512 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sheet_name"] | sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-190c82ce | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:513 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_column_type"] | sTitleSetType | 행/컬럼 값 대입 |  |  |  |
| AC-9c3c2c0a | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:514 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActive_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2790e094 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:515 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_column_name"] | sColumnName | 행/컬럼 값 대입 |  |  |  |
| AC-d14bcf37 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:516 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sort_order_no"] | sSortOrderNo | 행/컬럼 값 대입 |  |  |  |
| AC-06051b67 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:517 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sub_total_flag"] | sSubTotalFlag | 행/컬럼 값 대입 |  |  |  |
| AC-6f9cc909 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:518 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sort_method_code"] | sSortMethod | 행/컬럼 값 대입 |  |  |  |
| AC-c7b9aab8 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:519 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-0dc1d946 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:521 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5279268e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:526 | try ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ca635d79 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:530 | try ▸ if (iCount > 0) ▸ finally | MESSAGE | MessageHelper.GMessageBox | ("MSG00020", new object[] { _sTitleSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd673a14 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:531 | try ▸ if (iCount > 0) ▸ finally | CALL_BASE | FindButton | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6cdae34c | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:544 | try ▸ if (iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { _sTitleSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c6fded61 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:545 | try ▸ if (iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cb182f06 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DM0002_TitleSetForm_Popup.cs:565 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006", new object[] { _sTitleSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0002_TitleSetForm_Popup.setBaseSort

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d74ae4eb | (진입점 미연결) | DM0002_TitleSetForm_Popup.cs:55 |  | FLAG | _isBaseSort | isBool | 화면 필드/플래그 변경 |  |  |  |

## DM0002_TitleSetForm_Popup.SetTitleSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Default:] / this.spdBase.CellDoubleClick / this.spdUser.CellDoubleClick / this.btnRight.Click / this.btnLeft.Click / this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-702668af | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:270 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'N'", "SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-444de2ba | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:270 |  | DATA_OP | _dtTitleSet.Select(sFilterColumn + " = 'N'", "SORT_ORDER_NO").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e79eb8c2 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:270 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'N'", "SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-50537a7f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:271 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'Y'", sSortColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-4696313d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:271 |  | DATA_OP | _dtTitleSet.Select(sFilterColumn + " = 'Y'", sSortColumn).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4c728815 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:271 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'Y'", sSortColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-c607383f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:275 | if (dtBase == null) | GRID_SET | spdBase.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-49308c1f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:277 | else of (dtBase == null) | GRID_BIND | si.Query | (dtBase) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8cc616d6 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:281 | if (dtUser == null) | GRID_SET | spdUser.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-19b08c7f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:283 | else of (dtUser == null) | GRID_BIND | si.Query | (dtUser) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5ce57d01 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:292 | for (r < svSource.Rows.Count) ▸ if (svSource.Cells[r, svSource.Columns["SUB_TOTAL_FLAG"].Index].Text == "Y") | GRID_SET | svSource.Cells[r, svSource.Columns["SUB_TOTAL_FLAG"].Index].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-5aac969b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:296 | if (spdUser.Sheets[0].RowCount > 0) | GRID_SET | spdUser.Sheets[0].ActiveRowIndex | spdUser.Sheets[0].RowCount - 1 | 그리드 속성/값 설정 |  |  |  |
| AC-04635690 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:302 |  | CALL_EXT | svSource.GetSelections().GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7ed2a67 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:303 | if (svSource.GetSelections().GetLength(0) == 0) | CALL_EXT | svSource.AddSelection | (svSource.ActiveRowIndex, svSource.ActiveColumnIndex, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57e55d86 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:326 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b08c3ed | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:329 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-ef48e66e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:331 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-8987893b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:332 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-c93a6f5f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:343 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffc2548a | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:344 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-4fc05ea1 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:346 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-30191ac6 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:347 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-3d84f237 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:380 | foreach (int i in selectIndex.Keys) ▸ else of (activeRow + 1 >= svTarget.RowCount) | DATA_OP | svTarget.Rows.Add | (activeRow + 1, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-01dedc8a | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:383 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["COLUMN_NAME"].Index].Text | sColumnName | 그리드 속성/값 설정 |  |  |  |
| AC-1ce3efb0 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:384 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["COLUMN_LABEL_NAME"].Index].Text | sLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-c689af68 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:385 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SMALL_CLASS_LABEL_NAME"].Index].Text | sSLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-5250460b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:386 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["LARGE_CLASS_LABEL_NAME"].Index].Text | sLLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-2b496360 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:387 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SORT_METHOD_CODE"].Index].Text | sSortMethod | 그리드 속성/값 설정 |  |  |  |
| AC-3bb91d91 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:388 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SORT_ORDER_NO"].Index].Text | sSortOrderNo | 그리드 속성/값 설정 |  |  |  |
| AC-c888a917 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:389 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["USER_SORT_METHOD_CODE"].Index].Text | sUSortMethod | 그리드 속성/값 설정 |  |  |  |
| AC-9b98086b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:390 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["USER_SELECTABLE_FLAG"].Index].Text | sUserSelectedFlag | 그리드 속성/값 설정 |  |  |  |
| AC-f1bfad49 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:396 |  | GRID_STYLE | svTarget.SetActiveCell | (activeRow, -1) | 그리드 표시 설정 |  |  |  |
| AC-2a22e153 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:401 | for (i >= 0) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-084fea91 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:403 | for (i >= 0) ▸ if (selectIndex.ContainsKey(i)) | CALL_EXT | svSource.RemoveRows | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-54a65aab | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:408 | if (_isBaseSort == true) | CALL_EXT | svTarget.SortRows | (svTarget.Columns["SORT_ORDER_NO"].Index, true, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0bb8fe91 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | DM0002_TitleSetForm_Popup.cs:412 | else of (_isBaseSort == true) ▸ if (svTarget == spdBase.Sheets[0]) | CALL_EXT | svTarget.SortRows | (svTarget.Columns["SORT_ORDER_NO"].Index, true, false) | ⚠ 의미 확인 필요 |  |  |  |

## DM0002_TitleSetForm_Popup.spdUser_ButtonClicked

진입점: this.spdUser.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad92db2e | this.spdUser.ButtonClicked | DM0002_TitleSetForm_Popup.cs:593 | if (e.Column != sv.Columns["SUB_TOTAL_FLAG"].Index) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0442ecb | this.spdUser.ButtonClicked | DM0002_TitleSetForm_Popup.cs:597 | for (i < sv.RowCount) | GRID_SET | sv.Cells[i, e.Column].Value | "false" | 그리드 속성/값 설정 |  |  |  |

## DM0002_TitleSetForm_Popup.spdUser_RowDragMove

진입점: this.spdUser.RowDragMove

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac636e14 | this.spdUser.RowDragMove | DM0002_TitleSetForm_Popup.cs:633 | if (sUserSelect != "Y") | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## DM0002_TitleSetForm_Popup.TitleSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9e13b5c | this.Load | DM0002_TitleSetForm_Popup.cs:117 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-73650f15 | this.Load | DM0002_TitleSetForm_Popup.cs:125 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DM0002_TitleSetForm_Popup.TitleSetForm_SizeChanged

진입점: this.SizeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e8abbac | this.SizeChanged | DM0002_TitleSetForm_Popup.cs:603 |  | UI_PROP | pnlCenterButton.Top | (pnlCenter.Height - pnlCenterButton.Height) / 2 | 속성 Top 설정 |  |  |  |

## DM0002_TitleSetForm_Popup.usrButtonList1_UsrButtonList_Click_Detected

진입점: this.usrButtonList1.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22ed7116 | this.usrButtonList1.UsrButtonList_Click_Detected | DM0002_TitleSetForm_Popup.cs:618 | switch (buttonItem.UserType) case ButtonListType.Cancel: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |


# AS-IS 액션 대조표 — DMF0047

> 원천: `Doc/asisfacts/screens/DMF0047/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 134행 · 메서드 17 · 종류 FLAG 46 · DATA_OP 19 · ENDPOINT 13 · STATE 10 · UI_MISC 8 · RETURN 8 · VALUE_SET 6 · LIST_REBIND 5 · UI_PROP 5 · COMBO_DATA 5 · GRID_INIT 4 · POPUP 2 · GRID_BIND 1 · GRID_LOCK 1 · MESSAGE 1 · ⚠ 의미 확인 필요 0


## DMF0047_ItembyDivisionPopupEx.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54bb4362 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0047_ItembyDivisionPopupEx.cs:449 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-0546b2fe | this.btnButtonList.UsrButtonList_Click_Detected | DMF0047_ItembyDivisionPopupEx.cs:452 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-533d80db | this.clbDivision.SelectedIndexChanged | DMF0047_ItembyDivisionPopupEx.cs:459 |  | FLAG | dtScmSite | GetDivisionbyScmSite(clbDivision.ControlValues, CAppSetting.StringALL, CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-a88c40e3 | this.clbDivision.SelectedIndexChanged | DMF0047_ItembyDivisionPopupEx.cs:460 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.CreateSpread

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bed7621 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:288 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6df52062 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:289 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7028b57a | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:290 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.DefineProperty

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26fc556d | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:283 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0050974 | Dispose | DMF0047_ItembyDivisionPopupEx.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.FindData

진입점: this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load [if (!blnVali)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee71eb1c | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:363 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a5b1adef | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:368 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c51a2772 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:374 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-48c5c649 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:376 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { //… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1fe8ff80 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:381 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0047_GET_ITEM_BY_DIVISION_POPUPEx") ⇒ DM.DMF0047_GET_ITEM_BY_DIVISION_POPUPEx | 엔드포인트 요청 생성 |  |  |  |
| AC-e25e3f1a | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:383 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9c011310 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:385 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0d47243c | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:386 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-408c0dcf | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:387 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-5e75031d | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:388 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-a3adb4e8 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:389 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbScmSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-665a604b | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:390 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-0b2b3fd2 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:391 | try ▸ lambda | DATA_OP | request.Parameters["p_biz_type"] | sBizType | 행/컬럼 값 대입 |  |  |  |
| AC-7667725f | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:392 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d42943ee | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:394 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e2004bf7 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:401 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8cca9afc | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:403 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-00a430a2 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:404 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fcf90a1d | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:412 | try | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-6508f953 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:419 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ddd2755a | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:423 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0a66e68d | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:425 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13cb5f39 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:176 | if (!blnVali) | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-330b877c | this.Load | DMF0047_ItembyDivisionPopupEx.cs:177 | if (!blnVali) | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d86cbf9e | this.Load | DMF0047_ItembyDivisionPopupEx.cs:186 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-1aad08b0 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:187 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-dceffea6 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:188 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-003f69b0 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:189 |  | FLAG | sScmSiteId | _ScmSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-21bb3749 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:190 |  | FLAG | sItemId | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-f92b0e83 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:191 |  | FLAG | sBizType | _BizType | 화면 필드/플래그 변경 |  |  |  |
| AC-cb332c08 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:193 |  | FLAG | DeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-4f7acf72 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:194 |  | FLAG | EndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |
| AC-55ab1653 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:199 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-ec2b993c | this.Load | DMF0047_ItembyDivisionPopupEx.cs:200 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-07ebbe24 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:201 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-13701ce9 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:202 |  | FLAG | sScmSiteId | _ScmSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-05c60bfc | this.Load | DMF0047_ItembyDivisionPopupEx.cs:203 |  | FLAG | sItemId | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-199fde9f | this.Load | DMF0047_ItembyDivisionPopupEx.cs:204 |  | FLAG | sBizType | _BizType | 화면 필드/플래그 변경 |  |  |  |
| AC-307682e4 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:206 |  | FLAG | DeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-5da6dae0 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:207 |  | FLAG | EndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |
| AC-bfc0df57 | this.Load | DMF0047_ItembyDivisionPopupEx.cs:208 |  | FLAG | bCtlEnable | bEnable | 화면 필드/플래그 변경 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9b75171 | (진입점 미연결) | DMF0047_ItembyDivisionPopupEx.cs:554 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-fb4caf34 | (진입점 미연결) | DMF0047_ItembyDivisionPopupEx.cs:556 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e0dd0784 | (진입점 미연결) | DMF0047_ItembyDivisionPopupEx.cs:559 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.GetDivisionbyScmSite

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d4266d0 | this.clbDivision.SelectedIndexChanged | DMF0047_ItembyDivisionPopupEx.cs:568 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-224054f8 | this.clbDivision.SelectedIndexChanged | DMF0047_ItembyDivisionPopupEx.cs:569 |  | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-4c99e4d5 | this.clbDivision.SelectedIndexChanged | DMF0047_ItembyDivisionPopupEx.cs:570 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-6a91b7f1 | this.clbDivision.SelectedIndexChanged | DMF0047_ItembyDivisionPopupEx.cs:571 |  | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-81bd285f | this.clbDivision.SelectedIndexChanged | DMF0047_ItembyDivisionPopupEx.cs:573 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4195ef19 | this.clbDivision.SelectedIndexChanged | DMF0047_ItembyDivisionPopupEx.cs:576 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcd32ea8 | (진입점 미연결) | DMF0047_ItembyDivisionPopupEx.cs:599 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-21c9c26e | (진입점 미연결) | DMF0047_ItembyDivisionPopupEx.cs:600 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-66e92e1b | (진입점 미연결) | DMF0047_ItembyDivisionPopupEx.cs:601 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-e9e2f9e5 | (진입점 미연결) | DMF0047_ItembyDivisionPopupEx.cs:602 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-91faa667 | (진입점 미연결) | DMF0047_ItembyDivisionPopupEx.cs:605 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.GetSpdTitle

진입점: this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load [if (!blnVali)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b740218 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:476 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM_H.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-ff0aa21b | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:477 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0672d7c2 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:478 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-816823c2 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:479 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e070dead | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:481 |  | DATA_OP | request.Parameters["p_program_id"] | "SCM0002_40" | 행/컬럼 값 대입 |  |  |  |
| AC-638ef825 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:482 |  | DATA_OP | request.Parameters["p_sheet_name"] | "ItemPopup" | 행/컬럼 값 대입 |  |  |  |
| AC-32006eb1 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:483 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d1e6dbca | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:485 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8fe44d9d | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:485 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c568b44 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:488 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e1dddaf | (진입점 미연결) | DMF0047_ItembyDivisionPopupEx.cs:585 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-e54ed031 | (진입점 미연결) | DMF0047_ItembyDivisionPopupEx.cs:586 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a766e2b9 | (진입점 미연결) | DMF0047_ItembyDivisionPopupEx.cs:587 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b89046cb | (진입점 미연결) | DMF0047_ItembyDivisionPopupEx.cs:590 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.InitControls

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57f122a8 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:218 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-9c07cc27 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:218 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-83450d30 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:219 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0a2fa014 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:226 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-f2c02e77 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:226 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3c5fd99f | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:227 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-52a4603e | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:236 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-586e6d51 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:236 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d1f26a9 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:237 | if (sDivision == "40") | UI_PROP | lblProject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4e1f8e4f | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:241 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-1b64b1d4 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:241 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5a4a0f45 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:242 | else of (sDivision == "40") | UI_PROP | lblProject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5d7f35a1 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:246 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2cee6955 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:251 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7e7a405c | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:251 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fdce7f23 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:252 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-df4bc8a0 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:255 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-230ccf4f | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:256 |  | VALUE_SET | txtProject.ControlValues | sProject | 컨트롤 값 설정 |  |  |  |
| AC-734a7300 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:257 |  | VALUE_SET | clbScmSite.ControlValues | sScmSiteId | 컨트롤 값 설정 |  |  |  |
| AC-97060708 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:258 |  | VALUE_SET | txtItemID.Text | sItemId | 컨트롤 값 설정 |  |  |  |
| AC-6eda3e31 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:259 |  | VALUE_SET | clbTeam.ControlValues | DeptID | 컨트롤 값 설정 |  |  |  |
| AC-dd110f2c | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:260 |  | VALUE_SET | clbEndCustomer.ControlValues | EndCustomer | 컨트롤 값 설정 |  |  |  |
| AC-3d0e4394 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:265 | if (bCtlEnable == true) | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d85fd6ca | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:266 | if (bCtlEnable == true) | STATE | txtProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-790c278b | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:267 | if (bCtlEnable == true) | STATE | clbScmSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a7435344 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:268 | if (bCtlEnable == true) | STATE | clbTeam.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-69e93e9b | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:269 | if (bCtlEnable == true) | STATE | clbEndCustomer.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9a27207c | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:273 | else of (bCtlEnable == true) | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d1bb94bd | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:274 | else of (bCtlEnable == true) | STATE | txtProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-45f5529f | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:275 | else of (bCtlEnable == true) | STATE | clbScmSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5bba8726 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:276 | else of (bCtlEnable == true) | STATE | clbTeam.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-02ee1d55 | this.Load [if (!blnVali)] | DMF0047_ItembyDivisionPopupEx.cs:277 | else of (bCtlEnable == true) | STATE | clbEndCustomer.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## DMF0047_ItembyDivisionPopupEx.InitSpread

진입점: this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load [if (!blnVali)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c7e1128 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:299 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.InitSpread_X

진입점: this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load [if (!blnVali)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b04f0e8f | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | DMF0047_ItembyDivisionPopupEx.cs:326 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2751d27c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:493 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0cdeb417 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:495 |  | FLAG | itemID | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c720ba24 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:511 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-341f5e7c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:512 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemName | this.dtFindData.Rows[iRow][DefColumns.ItemName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-570d3552 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:513 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemType | this.dtFindData.Rows[iRow][DefColumns.ItemType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b22d6a2f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:514 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6c9e0f75 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:515 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemclassname | this.dtFindData.Rows[iRow][DefColumns.ItemClassName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-667b8536 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:516 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | currency | this.dtFindData.Rows[iRow][DefColumns.CURRENCY].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3196e272 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:520 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | itemID + "," + this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a726a3d7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:521 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemName | itemName + "," + this.dtFindData.Rows[iRow][DefColumns.ItemName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c67e93cb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:522 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemType | itemType + "," + this.dtFindData.Rows[iRow][DefColumns.ItemType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e9d305c2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:523 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | nickName + "," + this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b23ade17 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:524 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemclassname | itemclassname + "," + this.dtFindData.Rows[iRow][DefColumns.ItemClassName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0ee5b534 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:525 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | currency | currency + "," + this.dtFindData.Rows[iRow][DefColumns.CURRENCY].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d4c62623 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:533 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c968a606 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:538 | else of (bMulltiSelect) | FLAG | itemID | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-b1b820d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:539 | else of (bMulltiSelect) | FLAG | itemName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-98ef6939 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:540 | else of (bMulltiSelect) | FLAG | itemType | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemType)) | 화면 필드/플래그 변경 |  |  |  |
| AC-bd97347b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:541 | else of (bMulltiSelect) | FLAG | nickName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NickName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-28258684 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:542 | else of (bMulltiSelect) | FLAG | itemclassname | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemClassName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-840b6571 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0047_ItembyDivisionPopupEx.cs:543 | else of (bMulltiSelect) | FLAG | currency | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY)) | 화면 필드/플래그 변경 |  |  |  |

## DMF0047_ItembyDivisionPopupEx.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da6965c4 | this.spdMain.CellDoubleClick | DMF0047_ItembyDivisionPopupEx.cs:466 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |


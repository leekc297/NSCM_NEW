# AS-IS 액션 대조표 — DM0020

> 원천: `Doc/asisfacts/screens/DM0020/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 769행 · 메서드 90 · 종류 DATA_OP 150 · FLAG 89 · RETURN 72 · ENDPOINT 71 · GRID_INIT 53 · GRID_SET 50 · GRID_LOCK 38 · CALL_EXT 36 · COMBO_DATA 33 · UI_PROP 30 · UI_MISC 24 · LIST_REBIND 20 · POPUP 20 · MESSAGE 19 · GRID_COMBO 18 · VALUE_SET 15 · STATE 7 · GRID_BIND 6 · THROW 6 · GRID_STYLE 6 · CALL_BASE 6 · ⚠ 의미 확인 필요 42


## DM0020_OwnerbyDivisionPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17835dea | this.btnButtonList.UsrButtonList_Click_Detected | DM0020_OwnerbyDivisionPopup.cs:328 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-af7c7573 | this.btnButtonList.UsrButtonList_Click_Detected | DM0020_OwnerbyDivisionPopup.cs:331 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0020_OwnerbyDivisionPopup.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc05b7db | this.clbDivision.SelectedIndexChanged | DM0020_OwnerbyDivisionPopup.cs:338 |  | FLAG | dtScmSite | GetDivisionbyScmSite(clbDivision.ControlValues, CAppSetting.StringALL, CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-c508f2c7 | this.clbDivision.SelectedIndexChanged | DM0020_OwnerbyDivisionPopup.cs:339 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0020_OwnerbyDivisionPopup.CreateSpread

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d336be46 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:218 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6949d905 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:219 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-799e0fd7 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:220 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0020_OwnerbyDivisionPopup.DefineProperty

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9305b4b5 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:213 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DM0020_OwnerbyDivisionPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-116922b8 | Dispose | DM0020_OwnerbyDivisionPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0020_OwnerbyDivisionPopup.FindData

진입점: this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load [if (!blnVali)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95a855b2 | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:273 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9729760d | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:274 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-93407e3b | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:277 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a12b7a1c | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:279 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d448a4dd | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:283 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0020_GET_OWNER_DATA") ⇒ DM.DMF0020_GET_OWNER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-157e5c70 | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:284 | lambda | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-f81713a0 | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:285 | lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-a9dd3996 | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:286 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e4265970 | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:287 | lambda | DATA_OP | request.Parameters["p_project_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8284dc84 | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:288 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbScmSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e6b25713 | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:289 | lambda | DATA_OP | request.Parameters["p_owner_id"] | txtOwner.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b3b66cad | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:290 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f7e822a9 | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:292 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2aebdbc9 | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:296 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-21024d61 | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:297 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9e239a7f | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:300 |  | CALL_EXT | (new CUIControl()).SetPreferredWidth | (siMain.SpreadObject, 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-27fffc70 | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:304 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-9c92a815 | this.txtOwner.KeyDown [if (e.KeyCode == System.Windows.Forms… 외 3 | DM0020_OwnerbyDivisionPopup.cs:305 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DM0020_OwnerbyDivisionPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06ef3985 | this.Load | DM0020_OwnerbyDivisionPopup.cs:144 | if (!blnVali) | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e94e843f | this.Load | DM0020_OwnerbyDivisionPopup.cs:145 | if (!blnVali) | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-33e36882 | this.Load | DM0020_OwnerbyDivisionPopup.cs:154 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-0530fc0d | this.Load | DM0020_OwnerbyDivisionPopup.cs:155 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-8aac07f1 | this.Load | DM0020_OwnerbyDivisionPopup.cs:156 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-ccdaeb4f | this.Load | DM0020_OwnerbyDivisionPopup.cs:157 |  | FLAG | sScmSiteId | _ScmSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-cf2f0521 | this.Load | DM0020_OwnerbyDivisionPopup.cs:158 |  | FLAG | sItemId | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-455b3117 | this.Load | DM0020_OwnerbyDivisionPopup.cs:159 |  | FLAG | sOwner | _Owner | 화면 필드/플래그 변경 |  |  |  |
| AC-02e5668a | this.Load | DM0020_OwnerbyDivisionPopup.cs:161 |  | FLAG | DeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-76c269ea | this.Load | DM0020_OwnerbyDivisionPopup.cs:162 |  | FLAG | EndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |

## DM0020_OwnerbyDivisionPopup.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02b32e47 | (진입점 미연결) | DM0020_OwnerbyDivisionPopup.cs:417 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-9498a450 | (진입점 미연결) | DM0020_OwnerbyDivisionPopup.cs:419 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9dcd98be | (진입점 미연결) | DM0020_OwnerbyDivisionPopup.cs:422 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_OwnerbyDivisionPopup.GetDivisionbyScmSite

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-340a775b | this.clbDivision.SelectedIndexChanged | DM0020_OwnerbyDivisionPopup.cs:431 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-5c200656 | this.clbDivision.SelectedIndexChanged | DM0020_OwnerbyDivisionPopup.cs:432 |  | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-d28a1131 | this.clbDivision.SelectedIndexChanged | DM0020_OwnerbyDivisionPopup.cs:433 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-88c6747f | this.clbDivision.SelectedIndexChanged | DM0020_OwnerbyDivisionPopup.cs:434 |  | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-d20135ce | this.clbDivision.SelectedIndexChanged | DM0020_OwnerbyDivisionPopup.cs:436 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-47964be2 | this.clbDivision.SelectedIndexChanged | DM0020_OwnerbyDivisionPopup.cs:439 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_OwnerbyDivisionPopup.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36e3a39e | (진입점 미연결) | DM0020_OwnerbyDivisionPopup.cs:462 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c404730b | (진입점 미연결) | DM0020_OwnerbyDivisionPopup.cs:463 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-848d46ab | (진입점 미연결) | DM0020_OwnerbyDivisionPopup.cs:464 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-23a57a7f | (진입점 미연결) | DM0020_OwnerbyDivisionPopup.cs:465 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a18daa34 | (진입점 미연결) | DM0020_OwnerbyDivisionPopup.cs:468 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_OwnerbyDivisionPopup.GetSpdTitle

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f103d53 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:355 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-1500f1f6 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:356 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-10ba36a7 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:357 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-64f7b38c | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:358 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-80a79012 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:359 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0020" | 행/컬럼 값 대입 |  |  |  |
| AC-bcbb381c | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:360 |  | DATA_OP | request.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-8baba35b | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:361 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-24dcdc47 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:363 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c0102a71 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:363 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ab0d5dda | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:366 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0020_OwnerbyDivisionPopup.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-003a41ed | (진입점 미연결) | DM0020_OwnerbyDivisionPopup.cs:448 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-887479df | (진입점 미연결) | DM0020_OwnerbyDivisionPopup.cs:449 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9753a786 | (진입점 미연결) | DM0020_OwnerbyDivisionPopup.cs:450 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fa8a35a5 | (진입점 미연결) | DM0020_OwnerbyDivisionPopup.cs:453 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_OwnerbyDivisionPopup.InitControls

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cd93af5 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:169 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-74a46d3d | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:169 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a630ae26 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:170 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a35d6cb8 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:172 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-3eb92869 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:172 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e84671f0 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:173 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7ced3e1f | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:180 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-ea37e32d | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:180 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ba5a7bb6 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:185 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-433f3386 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:185 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-339289ff | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:188 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bb79eb45 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:191 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-710e4252 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:191 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-25725f3e | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:192 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5e645bd0 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:195 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-14814019 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:197 |  | VALUE_SET | clbScmSite.ControlValues | sScmSiteId | 컨트롤 값 설정 |  |  |  |
| AC-4ae1ae84 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:198 |  | VALUE_SET | txtOwner.Text | sOwner | 컨트롤 값 설정 |  |  |  |
| AC-7bd20829 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:199 |  | VALUE_SET | clbTeam.ControlValues | DeptID | 컨트롤 값 설정 |  |  |  |
| AC-baadf598 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:200 |  | VALUE_SET | clbEndCustomer.ControlValues | EndCustomer | 컨트롤 값 설정 |  |  |  |
| AC-cee725c9 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:202 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a4bf47ba | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:204 |  | STATE | clbScmSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-40d43d6b | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:205 |  | STATE | clbTeam.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-150ed23b | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:206 |  | STATE | clbEndCustomer.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## DM0020_OwnerbyDivisionPopup.InitSpread

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd5244ff | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:229 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0020_OwnerbyDivisionPopup.InitSpread_X

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c7bf895 | this.Load [if (!blnVali)] | DM0020_OwnerbyDivisionPopup.cs:236 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0020_OwnerbyDivisionPopup.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-298d2cf3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_OwnerbyDivisionPopup.cs:371 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-add6997d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_OwnerbyDivisionPopup.cs:373 |  | FLAG | ownerID | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-44eb5941 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_OwnerbyDivisionPopup.cs:389 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | ownerID | this.dtFindData.Rows[iRow][DefColumns.OWNER_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2a0fee50 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_OwnerbyDivisionPopup.cs:393 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | ownerID | ownerID + "," + this.dtFindData.Rows[iRow][DefColumns.OWNER_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-efc5aacc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_OwnerbyDivisionPopup.cs:401 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd71a291 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_OwnerbyDivisionPopup.cs:406 | else of (bMulltiSelect) | FLAG | ownerID | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OWNER_NAME)) | 화면 필드/플래그 변경 |  |  |  |

## DM0020_OwnerbyDivisionPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c52dd4e | this.spdMain.CellDoubleClick | DM0020_OwnerbyDivisionPopup.cs:345 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0020_SalesFuturePrice.btnBatch_Click

진입점: this.btnBatch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-988ae132 | this.btnBatch.Click | DM0020_SalesFuturePrice.cs:2121 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { //… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bd11f366 | this.btnBatch.Click | DM0020_SalesFuturePrice.cs:2126 | lambda | ENDPOINT | new FoxDataRequest | ("DM_H.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW") ⇒ DM_H.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW | 엔드포인트 요청 생성 |  |  |  |
| AC-df8979ec | this.btnBatch.Click | DM0020_SalesFuturePrice.cs:2127 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f9870436 | this.btnBatch.Click | DM0020_SalesFuturePrice.cs:2128 | lambda | DATA_OP | request.Parameters["p_CREATED_BY"] | p_CREATED_BY | 행/컬럼 값 대입 |  |  |  |
| AC-57891c3f | this.btnBatch.Click | DM0020_SalesFuturePrice.cs:2129 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-69afd118 | this.btnBatch.Click | DM0020_SalesFuturePrice.cs:2131 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7f930095 | this.btnBatch.Click | DM0020_SalesFuturePrice.cs:2144 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00143", new object[] { p_division_id, sRMsg}) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0020_SalesFuturePrice.btnExchangeRate_Click

진입점: this.btnExchangeRate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dee9a74 | this.btnExchangeRate.Click | DM0020_SalesFuturePrice.cs:1282 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00142") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-664c64d6 | this.btnExchangeRate.Click | DM0020_SalesFuturePrice.cs:1283 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-968e6ada | this.btnExchangeRate.Click | DM0020_SalesFuturePrice.cs:1286 |  | POPUP | new POPUP.DM0020_SalesFuturePricePopUp | () | 팝업/폼 생성 |  |  |  |
| AC-9c3418cd | this.btnExchangeRate.Click | DM0020_SalesFuturePrice.cs:1287 |  | CALL_EXT | popup.LoadData | (drpDateTime.Value1.ToString("yyyyMM"), drpDateTime.Value1.AddYears(1).ToString("yyyyMM")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4b5887d | this.btnExchangeRate.Click | DM0020_SalesFuturePrice.cs:1288 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3a7b34c1 | this.btnExchangeRate.Click | DM0020_SalesFuturePrice.cs:1289 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ba97f46f | this.btnExchangeRate.Click | DM0020_SalesFuturePrice.cs:1294 | if (popup.blnOK) | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |

## DM0020_SalesFuturePrice.btnModelType_Click

진입점: this.btnItemId.Click / this.umltModel.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1360f92d | this.btnItemId.Click 외 1 | DM0020_SalesFuturePrice.cs:1328 |  | POPUP | new SCM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-c8e5ae9a | this.btnItemId.Click 외 1 | DM0020_SalesFuturePrice.cs:1330 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-fa3325a5 | this.btnItemId.Click 외 1 | DM0020_SalesFuturePrice.cs:1331 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-41b2ea89 | this.btnItemId.Click 외 1 | DM0020_SalesFuturePrice.cs:1332 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-40d00bda | this.btnItemId.Click 외 1 | DM0020_SalesFuturePrice.cs:1334 |  | VALUE_SET | umltModel.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DM0020_SalesFuturePrice.btnSetPrice_Click

진입점: this.btnSetPrice.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e997980f | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2155 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0cf948f | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2158 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b246db21 | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2164 | try ▸ if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00144") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd3fb4a3 | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2165 | try ▸ if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-02742a50 | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2170 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00145") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-225a1aa7 | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2175 | try | UI_PROP | Cursor.Current | Cursors.WaitCursor | 속성 Current 설정 |  |  |  |
| AC-0ef916f3 | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2178 | try | STATE | panel1.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-f6adbb3c | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2179 | try | CALL_EXT | panel1.BringToFront | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-af16a5ee | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2180 | try | UI_PROP | panel1.Left | (this.ClientSize.Width - panel1.Width) / 2 | 속성 Left 설정 |  |  |  |
| AC-4094ccfe | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2181 | try | UI_PROP | panel1.Top | (this.ClientSize.Height - panel1.Height) / 2 | 속성 Top 설정 |  |  |  |
| AC-25cb3aed | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2183 | try | VALUE_SET | lblProgress.Text | "Recalculating" | 컨트롤 값 설정 |  |  |  |
| AC-9fe4b24a | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2185 | try | UI_PROP | progressBar1.Maximum | (siMain.GetMaxRowIndex() + 1) * (siMain.GetMaxColumnIndex() + 1 - siMain.GetColumnIndex(De… | 속성 Maximum 설정 |  |  |  |
| AC-4e00b947 | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2186 | try | VALUE_SET | progressBar1.Value | 0 | 컨트롤 값 설정 |  |  |  |
| AC-e9e9791d | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2195 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sMeasure != "LOC") ▸ try | VALUE_SET | lblProgress.Text | "Recalculating" + ((sProcess.Length == 4) ? sProcess = "." : sProcess = sProcess + ".") | 컨트롤 값 설정 |  |  |  |
| AC-48982cbf | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2196 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sMeasure != "LOC") ▸ try | VALUE_SET | progressBar1.Value | += (siMain.GetMaxColumnIndex() - siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 컨트롤 값 설정 |  |  |  |
| AC-898421cf | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2206 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ try | VALUE_SET | lblProgress.Text | "Recalculating" + ((sProcess.Length == 4) ? sProcess = "." : sProcess = sProcess + ".") | 컨트롤 값 설정 |  |  |  |
| AC-95abb817 | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2207 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ try | VALUE_SET | progressBar1.Value | += 1 | 컨트롤 값 설정 |  |  |  |
| AC-bf9bac3a | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2214 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.IsLockCell | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a6c80fe | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2216 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetForeColor | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6e9646e | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2226 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.SetValue | (i, j, "0") | 그리드 값 설정 |  |  |  |
| AC-48f1d13f | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2227 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.SetValue | (i, j, sValue) | 그리드 값 설정 |  |  |  |
| AC-ac191fab | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2231 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if ((i % 2) == 0) | UI_MISC | Application.DoEvents | () | 화면 갱신/대기창 |  |  |  |
| AC-5baeaa59 | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2237 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a479d857 | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2238 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-b8885e54 | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2242 | finally | STATE | panel1.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-feb53bc1 | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2243 | finally | UI_PROP | Cursor.Current | Cursors.Default | 속성 Current 설정 |  |  |  |
| AC-8965af05 | this.btnSetPrice.Click | DM0020_SalesFuturePrice.cs:2245 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DM0020_SalesFuturePrice.clbDivisions_SelectedIndexChanged

진입점: this.clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4872c084 | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1348 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c45b2da | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1351 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ff1092cc | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1372 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-3bc1b7f3 | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1372 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-81c57235 | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1373 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bf927482 | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1377 | try | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-925dcb71 | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1377 | try | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4f7b5a93 | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1378 | try | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e58cde69 | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1382 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-6ed8bebc | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1382 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d258e20a | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1383 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ec7874fb | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1385 | try | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-5a7a27e9 | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1385 | try | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-75eb8caa | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1386 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ae6b6cc7 | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1388 | try | FLAG | dtBizType | GetBizTypebyDivision(clbDivisions.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-07aef0e8 | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1389 | try | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bbd4002c | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1393 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c2012e0f | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1394 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-0aaa28b2 | this.clbDivisions.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:1398 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DM0020_SalesFuturePrice.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91a30f1a | this.clbEndCustomer.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:2294 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-b1603b16 | this.clbEndCustomer.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:2294 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-73c9ba82 | this.clbEndCustomer.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:2295 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0020_SalesFuturePrice.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7da55539 | this.clbTeam.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:2435 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-267eced0 | this.clbTeam.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:2435 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cd815b2f | this.clbTeam.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:2436 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8fbbc5e7 | this.clbTeam.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:2440 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-fc547eab | this.clbTeam.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:2440 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9255524b | this.clbTeam.SelectedIndexChanged | DM0020_SalesFuturePrice.cs:2441 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0020_SalesFuturePrice.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2a4eaf0 | this.Load | DM0020_SalesFuturePrice.cs:361 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f9112046 | this.Load | DM0020_SalesFuturePrice.cs:362 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-aa31c6bd | this.Load | DM0020_SalesFuturePrice.cs:363 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0020_SalesFuturePrice.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5702114 | this.Load | DM0020_SalesFuturePrice.cs:249 |  | FLAG | dtStartPeriod | drpDateTime.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-889026ee | this.Load | DM0020_SalesFuturePrice.cs:250 |  | FLAG | dtEndPeriod | drpDateTime.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-098647f6 | this.Load | DM0020_SalesFuturePrice.cs:252 |  | UI_PROP | usrConditionPanel2.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-ff1d9032 | this.Load | DM0020_SalesFuturePrice.cs:254 |  | VALUE_SET | clbDivisions.ControlValues | "ALL" | 컨트롤 값 설정 |  |  |  |
| AC-dc8b7a85 | this.Load | DM0020_SalesFuturePrice.cs:256 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-70b03241 | this.Load | DM0020_SalesFuturePrice.cs:257 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-37e5f238 | this.Load | DM0020_SalesFuturePrice.cs:258 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-c0ba064e | this.Load | DM0020_SalesFuturePrice.cs:259 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-53adf331 | this.Load | DM0020_SalesFuturePrice.cs:260 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-d7f5cfb0 | this.Load | DM0020_SalesFuturePrice.cs:270 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-271cb565 | this.Load | DM0020_SalesFuturePrice.cs:271 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d3ea9055 | this.Load | DM0020_SalesFuturePrice.cs:276 | switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3ce086f8 | this.Load | DM0020_SalesFuturePrice.cs:277 | switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DM0020_SalesFuturePrice.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91c36c88 | DeleteButton | DM0020_SalesFuturePrice.cs:517 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-350ca679 | DeleteButton | DM0020_SalesFuturePrice.cs:524 | for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-790482f6 | DeleteButton | DM0020_SalesFuturePrice.cs:525 | for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0020_SalesFuturePrice.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9527d204 | Dispose | DM0020_SalesFuturePrice.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0020_SalesFuturePrice.DM0020_SalesFuturePrice_Resize

진입점: this.Resize

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b476d4a | this.Resize | DM0020_SalesFuturePrice.cs:2287 | if (panel1.Visible == true) | UI_PROP | panel1.Left | (this.ClientSize.Width - panel1.Width) / 2 | 속성 Left 설정 |  |  |  |
| AC-aad7b3ed | this.Resize | DM0020_SalesFuturePrice.cs:2288 | if (panel1.Visible == true) | UI_PROP | panel1.Top | (this.ClientSize.Height - panel1.Height) / 2 | 속성 Top 설정 |  |  |  |

## DM0020_SalesFuturePrice.Dsdm_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4ac671f | dsdm.Changed | DM0020_SalesFuturePrice.cs:1741 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e94bbe26 | dsdm.Changed | DM0020_SalesFuturePrice.cs:1746 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff915d12 | dsdm.Changed | DM0020_SalesFuturePrice.cs:1747 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-59aefabb | dsdm.Changed | DM0020_SalesFuturePrice.cs:1748 | if (siMain.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea03febf | dsdm.Changed | DM0020_SalesFuturePrice.cs:1763 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-9ae1f9a5 | dsdm.Changed | DM0020_SalesFuturePrice.cs:1764 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6e6235e | dsdm.Changed | DM0020_SalesFuturePrice.cs:1772 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row , e.Column, e.Row , e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82987621 | dsdm.Changed | DM0020_SalesFuturePrice.cs:1780 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row - i, e.Column, GetExchangeRate(sDIVISION_ID, sCurrency, sTargetER, sColumnValue.Sub… | 그리드 값 설정 |  |  |  |
| AC-24f1eec8 | dsdm.Changed | DM0020_SalesFuturePrice.cs:1781 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row - i, e.Column, e.Row - i, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-728f2873 | dsdm.Changed | DM0020_SalesFuturePrice.cs:1786 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row - i, "M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-63017670 | dsdm.Changed | DM0020_SalesFuturePrice.cs:1805 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row - i, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-7a7c4068 | dsdm.Changed | DM0020_SalesFuturePrice.cs:1808 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | (new CUIControl()).SetActionFlagEx | (siMain.SpreadObject, e.Row - i, "M") | ⚠ 의미 확인 필요 |  |  |  |

## DM0020_SalesFuturePrice.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8188feb | EditButton | DM0020_SalesFuturePrice.cs:533 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e778231c | EditButton | DM0020_SalesFuturePrice.cs:534 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-341077c5 | EditButton | DM0020_SalesFuturePrice.cs:539 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c928bb40 | EditButton | DM0020_SalesFuturePrice.cs:547 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sMeasure.ToUpper() == "KRW") | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MEASURE), i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4fd569cb | EditButton | DM0020_SalesFuturePrice.cs:549 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sMeasure.ToUpper() == "USD") | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MEASURE), i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6b87373e | EditButton | DM0020_SalesFuturePrice.cs:551 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sMeasure.ToUpper() != "LOC") | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MEASURE), i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0bbcb8e7 | EditButton | DM0020_SalesFuturePrice.cs:559 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sMeasure.ToUpper() != "LOC") ▸ if (sMeasure.ToUpper() == "LOC") ▸ if (… | GRID_LOCK | siMain.LockRange | (i, 0, i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6124dcf9 | EditButton | DM0020_SalesFuturePrice.cs:562 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sMeasure.ToUpper() != "LOC") ▸ else of (sMeasure.ToUpper() == "LOC") | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MEASURE), i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-503ab206 | EditButton | DM0020_SalesFuturePrice.cs:566 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sMeasure.ToUpper() == "KRW") | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MEASURE), i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0336d98c | EditButton | DM0020_SalesFuturePrice.cs:568 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sMeasure.ToUpper() == "USD") | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MEASURE), i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-98eb82ab | EditButton | DM0020_SalesFuturePrice.cs:587 | if (this.fps != null) ▸ if (drpDateTime.Value1 < System.DateTime.Now.AddDays(-7)) ▸ for (i <= dtWeek.Rows.Count) ▸ try ▸ if (sThisWeek != sL… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MEASURE), siMain.GetColumnIndex(sLastWeek), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-99d1e12f | EditButton | DM0020_SalesFuturePrice.cs:588 | if (this.fps != null) ▸ if (drpDateTime.Value1 < System.DateTime.Now.AddDays(-7)) ▸ for (i <= dtWeek.Rows.Count) ▸ try ▸ if (sThisWeek != sL… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.GetMaxRowIndex(), siMain.GetColu… | 그리드 편집 잠금/해제 |  |  |  |

## DM0020_SalesFuturePrice.FindData

진입점: this.btnExchangeRate.Click [if (popup.blnOK)] / FindButton / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-191ffe5b | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:610 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-fac75a5d | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:617 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8288e5a1 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:618 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-647b6849 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:621 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b9f6eccf | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:631 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0329c5cc | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:632 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ec999ef | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:650 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9fa9a9fc | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:651 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-775c9b59 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:655 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-805b9bed | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:666 | try | DATA_OP | nvc["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d04eb9da | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:667 | try | DATA_OP | nvc["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-5dbf5338 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:668 | try | DATA_OP | nvc["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-0421753a | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:669 | try | DATA_OP | nvc["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-3d10892c | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:670 | try | DATA_OP | nvc["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-bae5dfcd | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:671 | try | DATA_OP | nvc["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0d20856c | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:672 | try | DATA_OP | nvc["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-9636e83b | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:673 | try | DATA_OP | nvc["p_customer_project_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-edae592e | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:674 | try | DATA_OP | nvc["p_customer_model"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0790440b | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:675 | try | DATA_OP | nvc["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-7f0c1d29 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:676 | try | DATA_OP | nvc["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-4939e974 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:677 | try | DATA_OP | nvc["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-feec2dc9 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:678 | try | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7eb9130b | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:679 | try | DATA_OP | nvc["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-27964749 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:680 | try | ENDPOINT | (new CUIControl()).GetAsyncDataUsingByDBEx | (this, "DM.DM0020_GET_SCM_MST_FUTURE_PRICE", nvc) ⇒ DM.DM0020_GET_SCM_MST_FUTURE_PRICE | 엔드포인트 호출 |  |  |  |
| AC-08e91f86 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:680 | try | ENDPOINT | new CUIControl | () ⇒ DM.DM0020_GET_SCM_MST_FUTURE_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-5a31903b | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:683 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a461f73 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:690 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-480849fb | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:703 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Select("", sSortList).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e2f94e0a | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:703 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Select | ("", sSortList) | 데이터 객체 조작/조회 |  |  |  |
| AC-e32435ba | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:704 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables.Remove | (ds.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-a473b565 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:705 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables.Add | (dtResultSort) | 데이터 객체 조작/조회 |  |  |  |
| AC-d13de0c6 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:707 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c0e244c6 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:708 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc3e6f45 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:712 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ed12ea3 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:729 | try ▸ if (drpDateTime.Value1 < System.DateTime.Now.AddDays(-7)) ▸ for (i <= dtWeek.Rows.Count) ▸ try ▸ if (sThisWeek != sLastWeek) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.GetMaxRowIndex(), siMain.GetColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f610277a | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:755 | try ▸ catch ((Exception exl)) | THROW | throw new Exception("Join =>", exl); |  | 예외 발생 |  |  |  |
| AC-bf1f5b4a | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:761 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7dc7a76e | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:769 | try ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-33503f81 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:774 | try ▸ try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-6c3cfd14 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:781 | try ▸ catch ((Exception exi)) | THROW | throw exi; |  | 예외 발생 |  |  |  |
| AC-57c3df21 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:782 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3288b77e | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:788 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3febb715 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:801 | try ▸ if (!blnInsert) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iUpdateRow, iUpdateCol) | 그리드 표시 설정 |  |  |  |
| AC-ceeb1575 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:802 | try ▸ if (!blnInsert) | CALL_EXT | spdMain.ShowActiveCell | (FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Cente… | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf83c654 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:811 | try | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-052c18cf | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:813 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e8be64ca | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:817 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-45e37320 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:818 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2c317fbd | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:822 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-f363cf51 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:827 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e8abfc6b | this.btnExchangeRate.Click [if (popup.blnOK)] 외 2 | DM0020_SalesFuturePrice.cs:828 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DM0020_SalesFuturePrice.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb0faa77 | this.Load | DM0020_SalesFuturePrice.cs:150 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-30a4a5bc | this.Load | DM0020_SalesFuturePrice.cs:152 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0020_SalesFuturePrice.GetBizTypebyDivision

진입점: this.clbDivisions.SelectedIndexChanged [try] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11395a6f | this.clbDivisions.SelectedIndexChanged [try] 외 1 | DM0020_SalesFuturePrice.cs:2398 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-59cc8450 | this.clbDivisions.SelectedIndexChanged [try] 외 1 | DM0020_SalesFuturePrice.cs:2399 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d357abcb | this.clbDivisions.SelectedIndexChanged [try] 외 1 | DM0020_SalesFuturePrice.cs:2400 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1c2dae23 | this.clbDivisions.SelectedIndexChanged [try] 외 1 | DM0020_SalesFuturePrice.cs:2403 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d56bcc6b | (진입점 미연결) | DM0020_SalesFuturePrice.cs:1169 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetCellIndexBySpanRowCells

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column)] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58553add | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 3 | DM0020_SalesFuturePrice.cs:1693 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-338f896a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 3 | DM0020_SalesFuturePrice.cs:1694 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetCellNumbersByRow

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ebbb424 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 2 | DM0020_SalesFuturePrice.cs:1725 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-7556829c | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 2 | DM0020_SalesFuturePrice.cs:1730 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetCurrencyBySCM_MST_SITE_ITEM

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fe1d9af | (진입점 미연결) | DM0020_SalesFuturePrice.cs:1985 |  | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c663509 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:1988 | if (ds.Tables[0].Rows.Count == 0) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-b3da135c | (진입점 미연결) | DM0020_SalesFuturePrice.cs:1990 | else of (ds.Tables[0].Rows.Count == 0) | RETURN | return ds.Tables[0].Rows[0]["CURRENCY"].ToString(); |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-743b085a | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2338 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-a59f2cdf | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2339 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1f986396 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2340 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-4b745ebb | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2341 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1ce92964 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2344 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetCustomerbyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fcda7ed | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2353 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-365aa3db | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2354 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-0315a8e1 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2355 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-294ab8d7 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2356 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-acd28731 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2359 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-243c8582 | this.Load | DM0020_SalesFuturePrice.cs:233 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-6566ff20 | this.Load | DM0020_SalesFuturePrice.cs:234 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-903f79f9 | this.Load | DM0020_SalesFuturePrice.cs:235 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-39baf416 | this.Load | DM0020_SalesFuturePrice.cs:237 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e33c9d9 | this.Load | DM0020_SalesFuturePrice.cs:240 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7afe19f8 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2006 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-693d9257 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2008 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bb7008e5 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2011 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4444a2b0 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2065 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-7d90083e | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2066 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c020dae8 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2067 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-845b8a71 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2068 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4725aa57 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2071 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetExchangeRate

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column) ▸ if (!string.IsNullOrEmpty(val)) ▸ for (i > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c073fc57 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0020_SalesFuturePrice.cs:1833 | if (sBaseER == sTargetER) | RETURN | return sValue; |  | 처리 중단/반환 |  |  |  |
| AC-2d8032d8 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0020_SalesFuturePrice.cs:1836 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = '" + sTargetER + "' AND UNIT_CURRENCY = '" + sBaseER + "' AND YYYYMM = '" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-19c1b01a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0020_SalesFuturePrice.cs:1840 | if (row.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-ad761fe8 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0020_SalesFuturePrice.cs:1844 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = '" + sBaseER + "' AND UNIT_CURRENCY = '" + sTargetER + "' AND YYYYMM = '" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-66919169 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0020_SalesFuturePrice.cs:1849 | if (row1.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-a96b74da | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0020_SalesFuturePrice.cs:1853 |  | DATA_OP | dtFuturePrice.Select | (" CURRENCY = 'KRW' AND UNIT_CURRENCY = '" + sBaseER + "' AND YYYYMM = '" + sYYYYMM + "' A… | 데이터 객체 조작/조회 |  |  |  |
| AC-b24fee1d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0020_SalesFuturePrice.cs:1857 | if (row4.Length > 0) | DATA_OP | dtFuturePrice.Select | (" CURRENCY = 'KRW' AND UNIT_CURRENCY = 'USD' AND YYYYMM = '" + sYYYYMM + "' AND DIVISION_… | 데이터 객체 조작/조회 |  |  |  |
| AC-c6616845 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0020_SalesFuturePrice.cs:1862 | if (row4.Length > 0) ▸ if (row5.Length > 0) | RETURN | return dblResult.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-10565431 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0020_SalesFuturePrice.cs:1867 | if (sTargetVal == null) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-8043be92 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0020_SalesFuturePrice.cs:1869 | else of (sTargetVal == null) | RETURN | return "0"; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetFuturePriceInfo

진입점: this.btnExchangeRate.Click [if (popup.blnOK)] / this.Load / FindButton [try] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7547563 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DM0020_SalesFuturePrice.cs:351 |  | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9742ad11 | this.btnExchangeRate.Click [if (popup.blnOK)] 외 3 | DM0020_SalesFuturePrice.cs:354 |  | RETURN | return ds.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetLookupValues

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff2ea86d | this.Load | DM0020_SalesFuturePrice.cs:2080 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-d53ea576 | this.Load | DM0020_SalesFuturePrice.cs:2081 |  | DATA_OP | request.Parameters["p_lookup_type"] | sLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-cd377f95 | this.Load | DM0020_SalesFuturePrice.cs:2082 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-da8ac760 | this.Load | DM0020_SalesFuturePrice.cs:2085 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetMeasureCountInfo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b5a590c | this.Load | DM0020_SalesFuturePrice.cs:335 |  | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0132c4d6 | this.Load | DM0020_SalesFuturePrice.cs:337 |  | RETURN | return ds.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetPlantSitebyEndCustomer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10d205ab | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2094 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-c7337f96 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2095 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-fc06f4b4 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2096 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-dc0ac615 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2097 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-4f1a5fbb | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2098 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5bfb0ce7 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2101 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetPlantSitebyEndCustomerAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7de0584 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2375 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-a6b5f782 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2376 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-661a417b | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2377 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-f2722695 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2378 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-5b56d111 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2379 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c1478c1 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2382 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetScmSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38df1c42 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2020 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c619af1e | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2021 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-41ca3074 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2022 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-94b06c39 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2023 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-2f2bd6a5 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2024 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ab3e843 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2027 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetScmSitebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-989cdab5 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2412 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-0569eb18 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2413 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-cb2f1fd5 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2414 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-6b2350bc | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2415 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-e63684cc | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2416 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-51818ca3 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2419 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetScmSiteInfobyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e442b5a | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2036 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_INFO_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-0446121a | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2037 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a9bb011c | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2038 |  | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-ec37819a | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2039 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ca35f519 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2042 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetSpdTitle

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.Load [else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / FindButton [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSh…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd88fdd9 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:2301 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DM0000_GET_COMMON_SPREAD_TITLE") ⇒ DM_H.DM0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-d83ec92a | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:2302 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3c9aaccf | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:2303 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e23c4389 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:2304 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5db772c6 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:2305 |  | DATA_OP | request.Parameters["p_program_id"] | "DM0020" | 행/컬럼 값 대입 |  |  |  |
| AC-99375bbe | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:2306 |  | DATA_OP | request.Parameters["p_sheet_name"] | "Sales Price" | 행/컬럼 값 대입 |  |  |  |
| AC-a0332c87 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:2308 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-7f066408 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:2308 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b8f9e373 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:2311 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43ee8b35 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2051 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d8a731aa | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2052 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-15736fd6 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2053 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d54a3fc | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2056 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetTeambyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7399c2d7 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2320 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-a959b5db | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2321 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-60626f40 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2322 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0759bb9a | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2329 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetThisWeekMonday

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / FindButton [try] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3fa33cb | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 2 | DM0020_SalesFuturePrice.cs:2266 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.GetWeekData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c9fa58f | this.Load | DM0020_SalesFuturePrice.cs:312 |  | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7aeb203d | this.Load | DM0020_SalesFuturePrice.cs:315 |  | RETURN | return dsWeek.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePrice.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d52311d1 | this.Load | DM0020_SalesFuturePrice.cs:167 |  | VALUE_SET | drpDateTime.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-8f2b51de | this.Load | DM0020_SalesFuturePrice.cs:177 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-464080ee | this.Load | DM0020_SalesFuturePrice.cs:179 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-0cbec4f2 | this.Load | DM0020_SalesFuturePrice.cs:179 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-87376fc1 | this.Load | DM0020_SalesFuturePrice.cs:180 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b1ebcb8a | this.Load | DM0020_SalesFuturePrice.cs:184 |  | FLAG | dtDepartment | Data.Common(Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoC… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 화면 필드/플래그 변경 |  |  |  |
| AC-641bfe79 | this.Load | DM0020_SalesFuturePrice.cs:184 |  | COMBO_DATA | Data.Common | (Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-01066533 | this.Load | DM0020_SalesFuturePrice.cs:186 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-ddd879d4 | this.Load | DM0020_SalesFuturePrice.cs:186 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a2baa33 | this.Load | DM0020_SalesFuturePrice.cs:187 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3aaa0574 | this.Load | DM0020_SalesFuturePrice.cs:191 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-caea8bee | this.Load | DM0020_SalesFuturePrice.cs:191 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b1c93726 | this.Load | DM0020_SalesFuturePrice.cs:193 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-432e51c4 | this.Load | DM0020_SalesFuturePrice.cs:197 |  | FLAG | dtBizType | GetBizTypebyDivision(clbDivisions.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-e8a972da | this.Load | DM0020_SalesFuturePrice.cs:198 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f2792cc0 | this.Load | DM0020_SalesFuturePrice.cs:202 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-08caf6cd | this.Load | DM0020_SalesFuturePrice.cs:202 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e3032925 | this.Load | DM0020_SalesFuturePrice.cs:203 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-44f3a603 | this.Load | DM0020_SalesFuturePrice.cs:205 |  | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-f6bba456 | this.Load | DM0020_SalesFuturePrice.cs:205 |  | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e9d60ba8 | this.Load | DM0020_SalesFuturePrice.cs:206 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c0600b06 | this.Load | DM0020_SalesFuturePrice.cs:208 |  | FLAG | dtItemType | GetLookupValues("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-27759229 | this.Load | DM0020_SalesFuturePrice.cs:209 |  | FLAG | dtINCOTERMSType | GetLookupValues("INCOTERMS") | 화면 필드/플래그 변경 |  |  |  |
| AC-a511981c | this.Load | DM0020_SalesFuturePrice.cs:211 |  | FLAG | dtFcstType | GetLookupValues("SALES_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-317a92de | this.Load | DM0020_SalesFuturePrice.cs:212 |  | FLAG | dtDomExp | GetLookupValues("DOM/EXP") | 화면 필드/플래그 변경 |  |  |  |
| AC-78b02171 | this.Load | DM0020_SalesFuturePrice.cs:215 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-2d3d45bb | this.Load | DM0020_SalesFuturePrice.cs:215 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ebad9a56 | this.Load | DM0020_SalesFuturePrice.cs:218 |  | FLAG | dtMeasureCount | GetMeasureCountInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-9796c5e1 | this.Load | DM0020_SalesFuturePrice.cs:220 |  | FLAG | dtFuturePrice | GetFuturePriceInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-81c2b70a | this.Load | DM0020_SalesFuturePrice.cs:224 |  | FLAG | dtWeek | GetWeekData() | 화면 필드/플래그 변경 |  |  |  |

## DM0020_SalesFuturePrice.InitSpread

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] / this.Load / FindButton [try] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59f13966 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 3 | DM0020_SalesFuturePrice.cs:393 | if (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dec623be | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 3 | DM0020_SalesFuturePrice.cs:398 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | FLAG | dtStartPeriod | drpDateTime.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-4d15d9f6 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 3 | DM0020_SalesFuturePrice.cs:399 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | FLAG | dtEndPeriod | drpDateTime.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-c228afb9 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try] 외 3 | DM0020_SalesFuturePrice.cs:403 | else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0020_SalesFuturePrice.InitSpread_X

진입점: this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / this.Load [else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / FindButton [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drp…)] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSh…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dca50bc | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:439 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.MEASURE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f9f0a62 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:455 |  | DATA_OP | nvc["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-2151dbad | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:456 |  | DATA_OP | nvc["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-577c9bdc | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:457 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cd6e44df | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:459 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM_H.DM0020_GET_SPREAD_TITLE_DATE", nvc) ⇒ DM_H.DM0020_GET_SPREAD_TITLE_DATE | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-54f8bec1 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:459 |  | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0020_GET_SPREAD_TITLE_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-d9497ea2 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:474 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["DATE_SHORT1_NAME"].ToString(), dt.Rows[i]["BASIS_START_DATE"].ToString(), FPM… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e77e909 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:476 | for (i < dt.Rows.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.MEASURE) + iWeek, 1, 1, 25, dt.Rows[i]["WEEK_NAME"].T… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59ce8afb | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:482 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow - 1, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca39b87a | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:491 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-86585256 | this.btnExchangeRate.Click [if (popup.blnOK) ▸ try ▸ else of… 외 3 | DM0020_SalesFuturePrice.cs:497 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) +1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0020_SalesFuturePrice.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-523087e3 | InsertButton | DM0020_SalesFuturePrice.cs:1183 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iArray[0], 2) | 그리드 표시 설정 |  |  |  |
| AC-14c71a03 | InsertButton | DM0020_SalesFuturePrice.cs:1186 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | (dtMeasureCount.Rows.Count) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d9a9931 | InsertButton | DM0020_SalesFuturePrice.cs:1194 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f577e9cf | InsertButton | DM0020_SalesFuturePrice.cs:1195 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-261a7df0 | InsertButton | DM0020_SalesFuturePrice.cs:1196 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-28c3b988 | InsertButton | DM0020_SalesFuturePrice.cs:1197 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2c90a59d | InsertButton | DM0020_SalesFuturePrice.cs:1198 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-172a369b | InsertButton | DM0020_SalesFuturePrice.cs:1199 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1298b531 | InsertButton | DM0020_SalesFuturePrice.cs:1201 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-e0900a79 | InsertButton | DM0020_SalesFuturePrice.cs:1202 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-feb91481 | InsertButton | DM0020_SalesFuturePrice.cs:1203 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-40a74d4b | InsertButton | DM0020_SalesFuturePrice.cs:1204 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0d914e40 | InsertButton | DM0020_SalesFuturePrice.cs:1207 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.PROJE… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-5518fe3b | InsertButton | DM0020_SalesFuturePrice.cs:1208 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-174b5303 | InsertButton | DM0020_SalesFuturePrice.cs:1209 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-18b268ef | InsertButton | DM0020_SalesFuturePrice.cs:1210 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-caab4ac1 | InsertButton | DM0020_SalesFuturePrice.cs:1212 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5c30d434 | InsertButton | DM0020_SalesFuturePrice.cs:1213 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerA… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8d4334f4 | InsertButton | DM0020_SalesFuturePrice.cs:1214 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7b3cc0a1 | InsertButton | DM0020_SalesFuturePrice.cs:1216 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_SET | siMain.SetText | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasureCount.Rows… | 그리드 값 설정 |  |  |  |
| AC-8e4843c1 | InsertButton | DM0020_SalesFuturePrice.cs:1217 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8937fe18 | InsertButton | DM0020_SalesFuturePrice.cs:1218 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.UPPER_DEPT_ID), siMain.Active… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a79e0ffb | InsertButton | DM0020_SalesFuturePrice.cs:1219 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DEPT_ID), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bfac0ccd | InsertButton | DM0020_SalesFuturePrice.cs:1223 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f40906d5 | InsertButton | DM0020_SalesFuturePrice.cs:1224 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ProjectStatus), siMain.Active… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b8955bab | InsertButton | DM0020_SalesFuturePrice.cs:1225 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.BizTypeName), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-de1630fd | InsertButton | DM0020_SalesFuturePrice.cs:1227 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), siMain.Acti… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b9562d28 | InsertButton | DM0020_SalesFuturePrice.cs:1228 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_NAME), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0fbe8635 | InsertButton | DM0020_SalesFuturePrice.cs:1229 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-704c631f | InsertButton | DM0020_SalesFuturePrice.cs:1232 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-320338ed | InsertButton | DM0020_SalesFuturePrice.cs:1250 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < dtMeasureCount.Rows.C… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f195e6b2 | InsertButton | DM0020_SalesFuturePrice.cs:1261 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | CUIControl.SetRowSpanFuc | (siMain, siMain.ActiveRowIndex, dtMeasureCount.Rows.Count - 1, 1, siMain.GetColumnIndex(De… | ⚠ 의미 확인 필요 |  |  |  |

## DM0020_SalesFuturePrice.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a33162a | SaveButton | DM0020_SalesFuturePrice.cs:834 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0165689a | SaveButton | DM0020_SalesFuturePrice.cs:845 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-50cb81fd | SaveButton | DM0020_SalesFuturePrice.cs:846 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e067e75b | SaveButton | DM0020_SalesFuturePrice.cs:849 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-eb1a7b6a | SaveButton | DM0020_SalesFuturePrice.cs:938 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cf58af83 | SaveButton | DM0020_SalesFuturePrice.cs:941 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-8a0ecec4 | SaveButton | DM0020_SalesFuturePrice.cs:943 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89bc6076 | SaveButton | DM0020_SalesFuturePrice.cs:979 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("ACTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-33ca9f4a | SaveButton | DM0020_SalesFuturePrice.cs:980 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b4aa42ab | SaveButton | DM0020_SalesFuturePrice.cs:981 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("PROJECT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7afc546c | SaveButton | DM0020_SalesFuturePrice.cs:982 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("SCM_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-625ad28b | SaveButton | DM0020_SalesFuturePrice.cs:983 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("PLANT_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b6283bde | SaveButton | DM0020_SalesFuturePrice.cs:984 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-39a07708 | SaveButton | DM0020_SalesFuturePrice.cs:985 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("CURRENCY") | 데이터 객체 조작/조회 |  |  |  |
| AC-b3b08016 | SaveButton | DM0020_SalesFuturePrice.cs:986 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-37830b28 | SaveButton | DM0020_SalesFuturePrice.cs:987 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("DOM_EXP") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c0c6bcd | SaveButton | DM0020_SalesFuturePrice.cs:988 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("FCST_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d282c5f | SaveButton | DM0020_SalesFuturePrice.cs:989 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | dr.Field | ("INCOTERMS") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe7d2726 | SaveButton | DM0020_SalesFuturePrice.cs:997 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { msg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dfe720fc | SaveButton | DM0020_SalesFuturePrice.cs:1000 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-63576133 | SaveButton | DM0020_SalesFuturePrice.cs:1001 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87424cc9 | SaveButton | DM0020_SalesFuturePrice.cs:1014 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6976584d | SaveButton | DM0020_SalesFuturePrice.cs:1057 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | CALL_EXT | siMain.GetForeColor | (iArray[iArray.Length - 1],j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-673d933e | SaveButton | DM0020_SalesFuturePrice.cs:1077 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], stempAction, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-940a1472 | SaveButton | DM0020_SalesFuturePrice.cs:1078 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_DIVISION_ID"] | CString.AppendStringEx(nvc["p_DIVISION_ID"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-e686c0e3 | SaveButton | DM0020_SalesFuturePrice.cs:1079 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_PROJECT_CODE"] | CString.AppendStringEx(nvc["p_PROJECT_CODE"], sPROJECT_CODE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-c738371e | SaveButton | DM0020_SalesFuturePrice.cs:1080 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_SCM_SITE_ID"] | CString.AppendStringEx(nvc["p_SCM_SITE_ID"], sSCM_SITE_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-2b80060c | SaveButton | DM0020_SalesFuturePrice.cs:1081 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_PLANT_SITE_ID"] | CString.AppendStringEx(nvc["p_PLANT_SITE_ID"], p_plant_site_id, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-ae87a079 | SaveButton | DM0020_SalesFuturePrice.cs:1082 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_ITEM_ID"] | CString.AppendStringEx(nvc["p_ITEM_ID"], sITEM_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-b772ed22 | SaveButton | DM0020_SalesFuturePrice.cs:1083 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], sYYYYMMDD, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-ad10c7a5 | SaveButton | DM0020_SalesFuturePrice.cs:1084 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_CURRENCY"] | CString.AppendStringEx(nvc["p_CURRENCY"], sCURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-8fe6981f | SaveButton | DM0020_SalesFuturePrice.cs:1086 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_MEASURE"] | CString.AppendStringEx(nvc["p_MEASURE"], sMEASURE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-2072d67f | SaveButton | DM0020_SalesFuturePrice.cs:1087 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_DOM_EXP"] | CString.AppendStringEx(nvc["p_DOM_EXP"], sDomExp, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-7bdf1e60 | SaveButton | DM0020_SalesFuturePrice.cs:1088 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_FCST_TYPE"] | CString.AppendStringEx(nvc["p_FCST_TYPE"], sFcstType, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-8e06a25c | SaveButton | DM0020_SalesFuturePrice.cs:1089 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_INCOTERMS"] | CString.AppendStringEx(nvc["p_INCOTERMS"], sINCOTERMS, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-3f783d45 | SaveButton | DM0020_SalesFuturePrice.cs:1090 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_PRICE"] | CString.AppendStringEx(nvc["p_PRICE"], sPRICE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-7316810d | SaveButton | DM0020_SalesFuturePrice.cs:1091 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-5034aa29 | SaveButton | DM0020_SalesFuturePrice.cs:1092 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_CREATION_DATE"] | CString.AppendStringEx(nvc["p_CREATION_DATE"], System.DateTime.Now.ToString(), iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-de7aab22 | SaveButton | DM0020_SalesFuturePrice.cs:1093 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-dd357485 | SaveButton | DM0020_SalesFuturePrice.cs:1096 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | UI_MISC | Application.DoEvents | () | 화면 갱신/대기창 |  |  |  |
| AC-1436bb76 | SaveButton | DM0020_SalesFuturePrice.cs:1105 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2bde8658 | SaveButton | DM0020_SalesFuturePrice.cs:1108 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | (new CUIControl()).GetAsyncDataUsingByDB | (this, "DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL", nvc) ⇒ DM_H.DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL | 엔드포인트 호출 |  |  |  |
| AC-8b6c6750 | SaveButton | DM0020_SalesFuturePrice.cs:1108 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL | 엔드포인트 요청 생성 |  |  |  |
| AC-1cf568d1 | SaveButton | DM0020_SalesFuturePrice.cs:1120 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "succe… | MESSAGE | MessageBox.Show | (sErrMsg, "Error!") | 메시지 표시 |  |  |  |
| AC-61f942f5 | SaveButton | DM0020_SalesFuturePrice.cs:1121 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "succe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4bc81345 | SaveButton | DM0020_SalesFuturePrice.cs:1126 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | STATE | panel1.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-35d2ac6e | SaveButton | DM0020_SalesFuturePrice.cs:1127 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD_R }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3c173392 | SaveButton | DM0020_SalesFuturePrice.cs:1130 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a84c68e7 | SaveButton | DM0020_SalesFuturePrice.cs:1143 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-b9a3c1b9 | SaveButton | DM0020_SalesFuturePrice.cs:1147 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9e6dc32c | SaveButton | DM0020_SalesFuturePrice.cs:1149 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DM0020_SalesFuturePrice.SetTextCellsToRowSpanRange

진입점: this.spdMain.CellDoubleClick [else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siMain.GetColumn…) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME)) \|\| siMain.GetCol…) ▸ if (popItem.ItemID != "" \|\| popItem.ItemID != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-628c5f1a | this.spdMain.CellDoubleClick [else of (siMain.IsLock(siMain.… | DM0020_SalesFuturePrice.cs:1679 | for (i < iMeasureCount) | GRID_SET | siMain.SetValue | (iActiveRow + i, siMain.GetColumnIndex(sColName), objValue) | 그리드 값 설정 |  |  |  |
| AC-732c9e8b | this.spdMain.CellDoubleClick [else of (siMain.IsLock(siMain.… | DM0020_SalesFuturePrice.cs:1680 | for (i < iMeasureCount) | GRID_SET | siMain.SetText | (iActiveRow + i, siMain.GetColumnIndex(sColName), objValue.ToString()) | 그리드 값 설정 |  |  |  |

## DM0020_SalesFuturePrice.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6e3461b | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1875 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3146f8c | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1885 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b76c3c9d | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1909 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-e0ab0595 | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1910 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-bedb3ca4 | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1911 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dca42270 | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1912 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2580c9b7 | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1930 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode) | 그리드 값 설정 |  |  |  |
| AC-fb19b4ef | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1932 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), popProject.ProjectName) | 그리드 값 설정 |  |  |  |
| AC-42af4b11 | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1934 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), popProject.ProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-7098b1b6 | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1936 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizTypeName), popProject.BizTypeName) | 그리드 값 설정 |  |  |  |
| AC-552f1df3 | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1941 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-6c366421 | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1943 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-3524e9fd | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1949 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | new SCM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-0dd18a90 | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1951 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-2859449c | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1952 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0bd1cdb0 | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1953 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a738eef6 | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1957 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), popItem.ItemID) | 그리드 값 설정 |  |  |  |
| AC-1a1c839e | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1958 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), popItem.ItemClassName) | 그리드 값 설정 |  |  |  |
| AC-79175f26 | this.spdMain.CellDoubleClick | DM0020_SalesFuturePrice.cs:1959 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), popItem.ItemName) | 그리드 값 설정 |  |  |  |

## DM0020_SalesFuturePrice.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8490071b | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1417 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtTeam | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-30ed8a67 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1417 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8f5d1f28 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1418 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b7d9ef16 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1419 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), e.Row + 2, siMain.GetColumnInde… | ⚠ 의미 확인 필요 |  |  |  |
| AC-dcea2ac9 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1426 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-58f378b2 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1426 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-651b8dcc | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1427 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d2992ae9 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1428 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row + 2, siMain.GetColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea64a7e6 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1434 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-80787900 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1434 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-57799020 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1436 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d3df2c32 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1437 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), e.Row + 2, siMain.GetColumn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-147ab4e9 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1440 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-292871ce | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1440 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4e661f56 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1442 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-fed64856 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1443 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row + 2, siMain.GetColu… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0eb3b9a | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1452 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (sDivision != "81") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bf59f8c7 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1454 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (sDivision != "81") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e06f9c4a | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1474 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-3ccacf9d | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1476 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-832d0ee7 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1478 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-142e2c03 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1480 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-ae05ba1f | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1482 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-2be2c47c | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1484 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-66fccb61 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1486 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-15caf025 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1493 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-26658275 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1493 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-de98ac5e | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1494 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5810771e | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1495 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row + 2, siMain.GetColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e78fa27c | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1499 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-7d1c3dd4 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1499 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6f553063 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1501 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-53c25172 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1502 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), e.Row + 2, siMain.GetColumn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd452003 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1530 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-e04ec42f | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1532 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-6650414c | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1534 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-c25fdd0b | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1536 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-8f7b27ed | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1538 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-23980034 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1540 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-3644d578 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1551 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-9b74e06c | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1551 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e0815f04 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1552 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d6d81a25 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1553 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), e.Row + 2, siMain.GetColumn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8fd008f6 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1559 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-57c1cb4e | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1561 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-9abcc64d | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1563 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-013cbe66 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1565 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-3b437ea9 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1567 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-843de545 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1576 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-d3fc0c62 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1578 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-ef44c6ca | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1580 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-126c4a61 | this.spdMain.ComboSelChange | DM0020_SalesFuturePrice.cs:1582 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |

## DM0020_SalesFuturePrice.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-719b30c6 | this.spdMain.KeyUp | DM0020_SalesFuturePrice.cs:2451 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9260fdcd | this.spdMain.KeyUp | DM0020_SalesFuturePrice.cs:2455 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2203c946 | this.spdMain.KeyUp | DM0020_SalesFuturePrice.cs:2461 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-88865970 | this.spdMain.KeyUp | DM0020_SalesFuturePrice.cs:2462 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DM0020_SalesFuturePrice.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-696d10fe | this.spdMain.TopChange | DM0020_SalesFuturePrice.cs:1996 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0020_SalesFuturePrice.usrButton1_Click

진입점: this.usrButton1.Click / this.umltProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95502020 | this.usrButton1.Click 외 1 | DM0020_SalesFuturePrice.cs:1309 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-01557082 | this.usrButton1.Click 외 1 | DM0020_SalesFuturePrice.cs:1310 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-45aaa42c | this.usrButton1.Click 외 1 | DM0020_SalesFuturePrice.cs:1311 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-97ce6928 | this.usrButton1.Click 외 1 | DM0020_SalesFuturePrice.cs:1312 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-778808cf | this.usrButton1.Click 외 1 | DM0020_SalesFuturePrice.cs:1314 |  | VALUE_SET | umltProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DM0020_SalesFuturePricePopUp.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3241d413 | this.btnButtonList.UsrButtonList_Click_Detected | DM0020_SalesFuturePricePopUp.cs:485 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-5f3aed6b | this.btnButtonList.UsrButtonList_Click_Detected | DM0020_SalesFuturePricePopUp.cs:488 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-9de2947c | this.btnButtonList.UsrButtonList_Click_Detected | DM0020_SalesFuturePricePopUp.cs:491 | switch (buttonItem.UserType) case ButtonListType.Excel: | CALL_BASE | ExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-40061132 | this.btnButtonList.UsrButtonList_Click_Detected | DM0020_SalesFuturePricePopUp.cs:655 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-35715615 | this.btnButtonList.UsrButtonList_Click_Detected | DM0020_SalesFuturePricePopUp.cs:658 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-d4974c89 | this.btnButtonList.UsrButtonList_Click_Detected | DM0020_SalesFuturePricePopUp.cs:661 | switch (buttonItem.UserType) case ButtonListType.Excel: | CALL_BASE | ExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## DM0020_SalesFuturePricePopUp.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f19cec4 | this.Load | DM0020_SalesFuturePricePopUp.cs:117 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2a21ce2c | this.Load | DM0020_SalesFuturePricePopUp.cs:118 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-768cdc9a | this.Load | DM0020_SalesFuturePricePopUp.cs:119 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4df0ab31 | this.Load | DM0020_SalesFuturePricePopUp.cs:136 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fbb607ae | this.Load | DM0020_SalesFuturePricePopUp.cs:137 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-436e91eb | this.Load | DM0020_SalesFuturePricePopUp.cs:138 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0020_SalesFuturePricePopUp.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e564e40 | this.Load | DM0020_SalesFuturePricePopUp.cs:110 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-15fe6931 | this.Load | DM0020_SalesFuturePricePopUp.cs:129 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DM0020_SalesFuturePricePopUp.DeleteButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Delete:] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39ee4957 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:268 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7f1a8fe9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:232 | if (vAction1 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f35efdc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:234 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0020_SalesFuturePricePopUp.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23c5049e | Dispose | DM0020_SalesFuturePricePopUp.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-0672849a | Dispose | DM0020_SalesFuturePricePopUp.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0020_SalesFuturePricePopUp.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35f35d36 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:275 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-351280d1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:276 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-89e08c2f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:279 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CURRENCY), siMain.GetColumnIndex(sColName), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4d609931 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:293 | if (this.fps != null) ▸ if (iMonth < iTime) ▸ for (i <= siMain.GetMaxColumnIndex()) ▸ if (iLockMonth >= iTime) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CURRENCY), i - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-314956d5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:249 | if (this.fps != null) ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | MESSAGE | MessageBox.Show | (" You don't have the permissions to access it", "Information.") | 메시지 표시 |  |  |  |
| AC-908f0413 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:250 | if (this.fps != null) ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6342b3e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:253 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-809e96c1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:254 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-2189a6a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:257 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(sColName), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9f0088a0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:271 | if (this.fps != null) ▸ if (iMonth < iTime) ▸ for (i <= siMain.GetMaxColumnIndex()) ▸ if (iLockMonth >= iTime) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CURRENCY), i - 1, true) | 그리드 편집 잠금/해제 |  |  |  |

## DM0020_SalesFuturePricePopUp.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f1fd504 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:324 |  | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4ed22950 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:326 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9e9667e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:327 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4da4b9a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:330 |  | GRID_BIND | siMain.Query | (CUIControl.GetDatatableFromSpread(siMain,"")) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0ad1ca73 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:330 |  | ENDPOINT | CUIControl.GetDatatableFromSpread | (siMain,"") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8f040c12 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:343 |  | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-adff31ac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:351 | for (i < dt.Rows.Count) | DATA_OP | dsSpread.Tables[0].Select | (" CURRENCY = '" + sCURRENCY + "' AND [UNIT_CURRENCY] = '" + sUNIT_CURRENCY.Trim() + "' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-40536bec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:353 | for (i < dt.Rows.Count) | GRID_SET | siMain.SetText | (iRowindex, siMain.GetColumnIndex(sYYYYMMDD), sEXCHANGE_PRICE) | 그리드 값 설정 |  |  |  |
| AC-86459c88 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:357 |  | DATA_OP | dsSpread.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9e52df9f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:363 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8967265b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:366 |  | CALL_EXT | CUIControl.SetPreferredWidth | (siMain.SpreadObject) | ⚠ 의미 확인 필요 |  |  |  |
| AC-13032ac0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:319 |  | DATA_OP | nvc["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b2401c77 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:320 |  | DATA_OP | nvc["p_from_yyyymmdd"] | usrMonthFrom.MonthText.Replace("-", "") + "01" | 행/컬럼 값 대입 |  |  |  |
| AC-6f8355ef | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:321 |  | DATA_OP | nvc["p_to_yyyymmdd"] | usrMonthTo.MonthText.Replace("-", "") + "02" | 행/컬럼 값 대입 |  |  |  |
| AC-df0f48e7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:322 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-521f4bfe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:323 |  | ENDPOINT | (new CUIControl()).GetAsyncDataUsingByDB | (this, "DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP", nvc) ⇒ DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP | 엔드포인트 호출 |  |  |  |
| AC-d40ccf15 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:323 |  | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-c2d42954 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:325 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4169fcec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:326 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f930e488 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:329 |  | GRID_BIND | siMain.Query | (CUIControl.GetDatatableFromSpread(siMain,"")) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d76206b1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:329 |  | ENDPOINT | CUIControl.GetDatatableFromSpread | (siMain,"") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0589f431 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:343 |  | CALL_EXT | nvc.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2fdf78d7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:344 |  | DATA_OP | nvc["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-bfb0c964 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:345 |  | DATA_OP | nvc["p_from_yyyymmdd"] | usrMonthFrom.MonthText.Replace("-", "") + "01" | 행/컬럼 값 대입 |  |  |  |
| AC-c1b68d0d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:346 |  | DATA_OP | nvc["p_to_yyyymmdd"] | usrMonthTo.MonthText.Replace("-", "") + "02" | 행/컬럼 값 대입 |  |  |  |
| AC-4d6fef39 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:347 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9d1ab105 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:348 |  | ENDPOINT | (new CUIControl()).GetAsyncDataUsingByDB | (this, "DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA", nvc) ⇒ DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA | 엔드포인트 호출 |  |  |  |
| AC-48efca3f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:348 |  | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-4b5ba7a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:357 | for (i < dt.Rows.Count) | DATA_OP | dsSpread.Tables[0].Select | (" CURRENCY = '" + sCURRENCY.Trim() + "' AND [UNIT_CURRENCY] = '" + sUNIT_CURRENCY.Trim() … | 데이터 객체 조작/조회 |  |  |  |
| AC-a62d9274 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:361 | for (i < dt.Rows.Count) | GRID_SET | siMain.SetText | (iRowindex, siMain.GetColumnIndex(sYYYYMMDD), sEXCHANGE_PRICE) | 그리드 값 설정 |  |  |  |
| AC-0ec965f6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:364 |  | DATA_OP | dsSpread.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1b3ee5e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:367 |  | DATA_OP | dsSpread.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a49095ba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:375 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b92f679 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:378 |  | CALL_EXT | (new CUIControl()).SetPreferredWidth | (siMain.SpreadObject, 3, true) | ⚠ 의미 확인 필요 |  |  |  |

## DM0020_SalesFuturePricePopUp.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfcf1ef0 | this.Load | DM0020_SalesFuturePricePopUp.cs:78 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-076e0afd | this.Load | DM0020_SalesFuturePricePopUp.cs:80 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4e24d05b | this.Load | DM0020_SalesFuturePricePopUp.cs:89 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d7822b5f | this.Load | DM0020_SalesFuturePricePopUp.cs:91 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0020_SalesFuturePricePopUp.GetCellColor

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f90ba873 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:626 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePricePopUp.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f4d9167 | this.Load | DM0020_SalesFuturePricePopUp.cs:117 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8ce196f0 | this.Load | DM0020_SalesFuturePricePopUp.cs:118 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-f54c2291 | this.Load | DM0020_SalesFuturePricePopUp.cs:118 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-31fb30ce | this.Load | DM0020_SalesFuturePricePopUp.cs:119 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6a3c744c | this.Load | DM0020_SalesFuturePricePopUp.cs:121 |  | FLAG | dtDivision2 | Data.Common(Data.Type.Division) ⇒ biz:CommonData.CommonDataList [code=Division] | 화면 필드/플래그 변경 |  |  |  |
| AC-b5ec1653 | this.Load | DM0020_SalesFuturePricePopUp.cs:121 |  | COMBO_DATA | Data.Common | (Data.Type.Division) ⇒ biz:CommonData.CommonDataList [code=Division] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2bdfdcd7 | this.Load | DM0020_SalesFuturePricePopUp.cs:122 |  | FLAG | dtCurrency | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-7462134f | this.Load | DM0020_SalesFuturePricePopUp.cs:122 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DM0020_SalesFuturePricePopUp.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f325757 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:198 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-43434a28 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:200 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-69c52537 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:201 |  | GRID_INIT | siMain.AddTextColumn | ("CURRENCY", DefColumns.CURRENCY, FPMerge.Restricted, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1d004066 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:202 |  | GRID_INIT | siMain.AddTextColumn | ("UNIT_CURRENCY", DefColumns.UNIT_CURRENCY, FPMerge.Restricted, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-061076d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:203 |  | GRID_INIT | siMain.AddTextColumn | ("CURRENCY", DefColumns.CURRENCY_UNITCURRENCY, FPMerge.Restricted, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7120ff0f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:204 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.CURRENCY_UNITCURRENCY)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-93dd56fb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:205 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, 1, 2, 2, 40, "Currency", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7a988dfd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:216 |  | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-44d126c8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:229 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["CALENDAR_MONTH"].ToString(), "D" + dt.Rows[i]["BASIS_START_DATE"].ToString(),… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c1868ac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:234 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["CALENDAR_YYYY"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow - 1, 25, sFYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0cc327d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:242 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, sFYear , FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1345b7b4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:247 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63717830 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:248 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.CURRENCY_UNITCURRENCY)+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b6593c1d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:145 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-aac55a3c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:147 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c06b32fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:148 |  | GRID_INIT | siMain.AddComboColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.Restricted, 120, true, dtDivision2, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0699cf71 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:149 |  | GRID_INIT | siMain.AddTextColumn | ("Currency", DefColumns.CURRENCY, FPMerge.Restricted, 70, true, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-82c772d0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:151 |  | GRID_INIT | siMain.AddComboColumn | ("Unit", DefColumns.UNIT_CURRENCY, FPMerge.None, 50, true, dtCurrency, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5d30e0df | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:152 |  | GRID_INIT | siMain.AddTextColumn | ("Currency", DefColumns.CURRENCY_UNITCURRENCY, FPMerge.Restricted, 50, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a11499d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:153 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.CURRENCY_UNITCURRENCY)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-606d76cc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:172 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE") ⇒ DM.DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-43054856 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:173 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | usrMonthFrom.MonthText.Replace("-", "") + "01" | 행/컬럼 값 대입 |  |  |  |
| AC-3d41ea48 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:174 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | usrMonthTo.MonthText.Replace("-", "") + "02" | 행/컬럼 값 대입 |  |  |  |
| AC-7703c950 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:175 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0024500b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:189 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["CALENDAR_MONTH"].ToString(), "D" + dt.Rows[i]["BASIS_START_DATE"].ToString(),… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-82d58a6d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:194 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["CALENDAR_YYYY"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow - 1, 25, sFYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b590b3f7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:202 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, sFYear , FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bebf50c1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:207 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9ebaf529 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0020_SalesFuturePricePopUp.cs:209 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.UNIT_CURRENCY)+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0020_SalesFuturePricePopUp.InitSpread_X

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a231cc19 | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:126 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-eae042f9 | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:128 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-17792ee2 | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:129 |  | GRID_INIT | siMain.AddTextColumn | ("Currency", DefColumns.CURRENCY, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7da39f65 | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:130 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.CURRENCY)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2de61591 | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:139 |  | ENDPOINT | CUIControl.GetDataUsingSQLByDB | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-60e3f7ab | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:156 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["WEEK_NAME"].ToString(), dt.Rows[i]["BASIS_START_DATE"].ToString(), FPMerge.No… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2400dc21 | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:161 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["CALENDAR_YYYY"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow-1, 25, sFYear + "년", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-99ad004a | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:169 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count-1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, sFYear + "년", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bdaf844d | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:181 | for (i < dt.Rows.Count) ▸ if (sFMonth != dt.Rows[i]["CALENDAR_MONTH"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iMonthFRow, 1, iMonthLRow - 1, 25, sFMonth + "월", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d03db8d0 | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:188 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iMonthFRow, 1, iMonthLRow, 25, sFMonth + "월", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0020_SalesFuturePricePopUp.InsertRow

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Insert:] / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74cb643e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:428 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fb564701 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:431 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column1, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-f79ef380 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:432 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column2, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-082e21cb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:433 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column3, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef2bd740 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:435 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-2b1583ea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:450 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iMonth < iTime) ▸ for (i <… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY_UNITCURRENCY), siMain.Ac… | 그리드 편집 잠금/해제 |  |  |  |
| AC-edc1cd18 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:579 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-91d8cc94 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:582 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CURRENCY, "KRW") | 데이터 객체 조작/조회 |  |  |  |
| AC-3c4bc132 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:585 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-b0604618 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:586 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-17c3ced4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:587 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d950401 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:602 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iMonth < iTime) ▸ for (i <… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY_UNITCURRENCY), siMain.Ac… | 그리드 편집 잠금/해제 |  |  |  |

## DM0020_SalesFuturePricePopUp.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9911928b | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:90 |  | UI_PROP | usrMonthFrom.MonthText | sFromYYYYMM | 속성 MonthText 설정 |  |  |  |
| AC-735ae042 | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:91 |  | UI_PROP | usrMonthTo.MonthText | sToYYYYMM | 속성 MonthText 설정 |  |  |  |
| AC-5982266c | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:101 |  | UI_PROP | usrMonthFrom.MonthText | sFromYYYYMM | 속성 MonthText 설정 |  |  |  |
| AC-2c08ea2f | (진입점 미연결) | DM0020_SalesFuturePricePopUp.cs:102 |  | UI_PROP | usrMonthTo.MonthText | sToYYYYMM | 속성 MonthText 설정 |  |  |  |

## DM0020_SalesFuturePricePopUp.mOK

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8d6a373 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0020_SalesFuturePricePopUp.cs:668 |  | FLAG | blnOK | true | 화면 필드/플래그 변경 |  |  |  |

## DM0020_SalesFuturePricePopUp.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caf15376 | SaveButton | DM0020_SalesFuturePricePopUp.cs:290 | switch (UserInfoContext.Current["NowGroupID"]) default: | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f5f9147 | SaveButton | DM0020_SalesFuturePricePopUp.cs:291 | switch (UserInfoContext.Current["NowGroupID"]) default: | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0020_SalesFuturePricePopUp.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-388788aa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:408 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | COMBO_DATA | (new CUIControl()).GetComboDataUsingFoxQueryByDB2 | ("DM_H.DM0020_SAVE_DM_MST_EXCHANGE_RATE", action, sCURRENCY, sUNIT_CURRENCY, sYYYYMMDD, sE… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f5c7eb8f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:415 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3dc5c3ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:427 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d3391421 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:430 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-fe1c5598 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:432 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2eb42919 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:504 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], action, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-367b2dca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:505 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_division_id"] | CString.AppendStringEx(nvc["p_division_id"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-eacdfe62 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:506 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], sYYYYMMDD, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-8266f81a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:507 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_CURRENCY"] | CString.AppendStringEx(nvc["p_CURRENCY"], sCURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-38441c95 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:508 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_UNIT_CURRENCY"] | CString.AppendStringEx(nvc["p_UNIT_CURRENCY"], sUNIT_CURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-c9cfb105 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:509 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_EXCHANGE_PRICE"] | CString.AppendStringEx(nvc["p_EXCHANGE_PRICE"], sEXCHANGE_PRICE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-b0cec6b9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:510 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-54061e8c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:512 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-cf4724ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:528 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(sPric… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[EXCHANGE_PRICE]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-257efde0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:529 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(sPric… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afbdc6dc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:534 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-57ce393e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:538 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0020_SAVE_DM_MST_EXCHANGE_RATE_ALL") ⇒ DM.DM0020_SAVE_DM_MST_EXCHANGE_RATE_ALL | 엔드포인트 요청 생성 |  |  |  |
| AC-bada4ed4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:542 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Count) | DATA_OP | request.Parameters[nvc.GetKey(i)] | nvc[i] | 행/컬럼 값 대입 |  |  |  |
| AC-47ec1e25 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:542 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Count) | CALL_EXT | nvc.GetKey | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c0a789f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:544 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e292427e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:546 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ba17d37a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:560 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | MESSAGE | MessageBox.Show | (sErrMsg, "Error!") | 메시지 표시 |  |  |  |
| AC-c9eafa31 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:561 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61c9999e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0020_SalesFuturePricePopUp.cs:566 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD_R }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0020_SalesFuturePricePopUp.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a450762e | this.spdMain.TopChange | DM0020_SalesFuturePricePopUp.cs:499 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1cb56a93 | this.spdMain.TopChange | DM0020_SalesFuturePricePopUp.cs:674 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## ext.DTJoin

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0f1d0df | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2482 | lambda | DATA_OP | onCol.Select | (str => row[str]) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e58ddb1 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2483 | lambda | RETURN | return o; |  | 처리 중단/반환 |  |  |  |
| AC-bdc8c1ee | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2491 | foreach (DataColumn col in left.Columns) ▸ if (dt.Columns[col.ColumnName] == null) | DATA_OP | dt.Columns.Add | (new DataColumn(col.ColumnName.ToUpper(), col.DataType, col.Expression, col.ColumnMapping)… | 데이터 객체 조작/조회 |  |  |  |
| AC-8c57fbba | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2495 | for (colIdx < right.Columns.Count) | DATA_OP | right.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f511e18c | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2499 | for (colIdx < right.Columns.Count) | DATA_OP | onCol.Contains | (col.ColumnName.ToUpper()) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3ecc72b | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2501 | for (colIdx < right.Columns.Count) ▸ if (onCol.Contains(col.ColumnName.ToUpper())) | DATA_OP | colNumbersToRemove.Add | (col.ColumnName + "_2") | 데이터 객체 조작/조회 |  |  |  |
| AC-017d31e2 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2511 | for (colIdx < right.Columns.Count) ▸ if (dt.Columns[col.ColumnName] != null) ▸ if (!blnNoKeyOverlap) | UI_PROP | col.ColumnName | += "_2" | 속성 ColumnName 설정 |  |  |  |
| AC-3316f887 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2516 | for (colIdx < right.Columns.Count) ▸ if (dt.Columns[col.ColumnName] != null) ▸ else of (!blnNoKeyOverlap) | GRID_SET | dt.Columns[col.ColumnName].ColumnName | col.ColumnName + "_2" | 그리드 속성/값 설정 |  |  |  |
| AC-2fdf90b3 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2521 | for (colIdx < right.Columns.Count) | DATA_OP | dt.Columns.Add | (new DataColumn(col.ColumnName, col.DataType, col.Expression, col.ColumnMapping)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b18eebeb | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2529 | if (joinType == JoinType.Left) | CALL_BASE | getKey | (l) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eeec52d0 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2529 | if (joinType == JoinType.Left) | CALL_BASE | getKey | (r) | ⚠ 의미 확인 필요 |  |  |  |
| AC-955fcda2 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2530 | if (joinType == JoinType.Left) | CALL_EXT | temp.DefaultIfEmpty | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-07b4624d | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2531 | if (joinType == JoinType.Left) | DATA_OP | right.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f5286927 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2534 | if (joinType == JoinType.Left) ▸ foreach (var values in res) | DATA_OP | dt.Rows.Add | (values) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad9754e7 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2542 | else of (joinType == JoinType.Left) | CALL_BASE | getKey | (l) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8602e0db | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2542 | else of (joinType == JoinType.Left) | CALL_BASE | getKey | (r) | ⚠ 의미 확인 필요 |  |  |  |
| AC-480be81f | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2544 | else of (joinType == JoinType.Left) | DATA_OP | right.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-98951ff4 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2547 | else of (joinType == JoinType.Left) ▸ foreach (object[] values in res) | DATA_OP | dt.Rows.Add | (values) | 데이터 객체 조작/조회 |  |  |  |
| AC-385c4878 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2554 | if (!blnKeyOverlap) ▸ foreach (string col in colNumbersToRemove) | DATA_OP | dt.Columns.Remove | (col) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d7e2df6 | (진입점 미연결) | DM0020_SalesFuturePrice.cs:2557 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## JoinKey..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44e1b41f | .ctor | DM0020_SalesFuturePrice.cs:2567 |  | FLAG | this.objects | objects | 화면 필드/플래그 변경 |  |  |  |

## JoinKey.Equals

진입점: Equals

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70c6d1f6 | Equals | DM0020_SalesFuturePrice.cs:2574 | if (obj == null \|\| obj.GetType() != typeof(JoinKey)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5b214eee | Equals | DM0020_SalesFuturePrice.cs:2575 |  | CALL_EXT | objects.SequenceEqual | (((JoinKey)obj).objects) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1cc3ef0c | Equals | DM0020_SalesFuturePrice.cs:2575 |  | RETURN | return objects.SequenceEqual(((JoinKey)obj).objects); |  | 처리 중단/반환 |  |  |  |

## JoinKey.GetHashCode

진입점: GetHashCode

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d8dc927 | GetHashCode | DM0020_SalesFuturePrice.cs:2584 | foreach (var foo in objects) | CALL_EXT | foo.GetHashCode | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fcb90601 | GetHashCode | DM0020_SalesFuturePrice.cs:2586 |  | RETURN | return hash; |  | 처리 중단/반환 |  |  |  |


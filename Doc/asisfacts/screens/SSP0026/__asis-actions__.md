# AS-IS 액션 대조표 — SSP0026

> 원천: `Doc/asisfacts/screens/SSP0026/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1070행 · 메서드 84 · 종류 DATA_OP 242 · FLAG 121 · RETURN 82 · GRID_SET 79 · UI_PROP 78 · GRID_INIT 77 · ENDPOINT 67 · MESSAGE 56 · POPUP 46 · UI_MISC 39 · COMBO_DATA 35 · GRID_LOCK 32 · CALL_EXT 25 · LIST_REBIND 20 · VALUE_SET 16 · GRID_STYLE 15 · GRID_BIND 10 · VALIDATE 10 · GRID_COMBO 9 · STATE 7 · CALL_BASE 4 · ⚠ 의미 확인 필요 29


## SSP0026_BodItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46e7686b | this.btnButtonList.UsrButtonList_Click_Detected | SSP0026_BodItemPopup.cs:309 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-18018d9c | this.btnButtonList.UsrButtonList_Click_Detected | SSP0026_BodItemPopup.cs:312 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0026_BodItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6dfbed7a | this.Load | SSP0026_BodItemPopup.cs:192 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7f258ed7 | this.Load | SSP0026_BodItemPopup.cs:193 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7b330236 | this.Load | SSP0026_BodItemPopup.cs:194 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0026_BodItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bddeac5 | this.Load | SSP0026_BodItemPopup.cs:187 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0026_BodItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da2df370 | Dispose | SSP0026_BodItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0026_BodItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ee92474 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:250 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aacfdc12 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:254 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_BOD_ITEM") ⇒ SSP.SSP0026_GET_BOD_ITEM | 엔드포인트 요청 생성 |  |  |  |
| AC-ea079220 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:255 | lambda | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-4fa55587 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:256 | lambda | DATA_OP | request.Parameters["p_from_site_id"] | clbFromSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3dccfddf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:257 | lambda | DATA_OP | request.Parameters["p_to_site_id"] | txtToSite.Text | 행/컬럼 값 대입 |  |  |  |
| AC-27a35934 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:258 | lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-0ab05d1c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:259 | lambda | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-e71d7865 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:261 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cc925cdf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:263 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c8cb410c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:267 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-bffe32e7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:268 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ae80e97 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:272 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-d94e2f07 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:278 | if (!string.IsNullOrEmpty(txtItemID.Text)) ▸ if (ds.Tables[0].Rows.Count == 1) | FLAG | itemID | this.dtFindData.Rows[0][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-22ab91be | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:280 | if (!string.IsNullOrEmpty(txtItemID.Text)) ▸ if (ds.Tables[0].Rows.Count == 1) | FLAG | incoterms | this.dtFindData.Rows[0][DefColumns.Incoterms].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-158a2ef9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:281 | if (!string.IsNullOrEmpty(txtItemID.Text)) ▸ if (ds.Tables[0].Rows.Count == 1) | FLAG | transport | this.dtFindData.Rows[0][DefColumns.Transport].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7482758e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:282 | if (!string.IsNullOrEmpty(txtItemID.Text)) ▸ if (ds.Tables[0].Rows.Count == 1) | FLAG | bodId | this.dtFindData.Rows[0][DefColumns.BodId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e358aae2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:284 | if (!string.IsNullOrEmpty(txtItemID.Text)) ▸ if (ds.Tables[0].Rows.Count == 1) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0026_BodItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63805b23 | this.Load | SSP0026_BodItemPopup.cs:141 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1eafdf70 | this.Load | SSP0026_BodItemPopup.cs:142 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-77174e9e | this.Load | SSP0026_BodItemPopup.cs:150 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-e71287c2 | this.Load | SSP0026_BodItemPopup.cs:151 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-21d7287c | this.Load | SSP0026_BodItemPopup.cs:152 |  | FLAG | sFromSiteId | _FromSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-53611904 | this.Load | SSP0026_BodItemPopup.cs:153 |  | FLAG | sToSiteId | _ToSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-0fbce1d0 | this.Load | SSP0026_BodItemPopup.cs:154 |  | FLAG | sItemId | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-ede03c1c | this.Load | SSP0026_BodItemPopup.cs:155 |  | FLAG | sBodId | _bodId | 화면 필드/플래그 변경 |  |  |  |

## SSP0026_BodItemPopup.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-816c73bc | this.Load | SSP0026_BodItemPopup.cs:388 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-70645721 | this.Load | SSP0026_BodItemPopup.cs:390 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6bbd2169 | this.Load | SSP0026_BodItemPopup.cs:393 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0026_BodItemPopup.GetDivisionbyScmSite

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7d3d0d1 | this.Load | SSP0026_BodItemPopup.cs:402 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-2c8b7260 | this.Load | SSP0026_BodItemPopup.cs:403 |  | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-2c528985 | this.Load | SSP0026_BodItemPopup.cs:404 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-097c8769 | this.Load | SSP0026_BodItemPopup.cs:405 |  | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-f7d80481 | this.Load | SSP0026_BodItemPopup.cs:407 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c4a3481 | this.Load | SSP0026_BodItemPopup.cs:410 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0026_BodItemPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c060ea12 | this.Load | SSP0026_BodItemPopup.cs:163 |  | FLAG | dtDivision | GetDivision() | 화면 필드/플래그 변경 |  |  |  |
| AC-1d6b54c4 | this.Load | SSP0026_BodItemPopup.cs:164 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c46879dd | this.Load | SSP0026_BodItemPopup.cs:166 |  | FLAG | dtScmSite | GetDivisionbyScmSite(sDivision, CAppSetting.StringALL, CAppSetting.StringALL) | 화면 필드/플래그 변경 |  |  |  |
| AC-634669a1 | this.Load | SSP0026_BodItemPopup.cs:168 |  | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.Com_FromSite, false, sDivision, null) | 화면 필드/플래그 변경 |  |  |  |
| AC-5cc85f6f | this.Load | SSP0026_BodItemPopup.cs:168 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Com_FromSite, false, sDivision, null) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ace4c98b | this.Load | SSP0026_BodItemPopup.cs:169 |  | FLAG | dtToSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-e318c6f8 | this.Load | SSP0026_BodItemPopup.cs:169 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sToSite… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3f61fd97 | this.Load | SSP0026_BodItemPopup.cs:170 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-efc14d6d | this.Load | SSP0026_BodItemPopup.cs:173 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-ab53a921 | this.Load | SSP0026_BodItemPopup.cs:174 |  | VALUE_SET | clbFromSite.ControlValues | sFromSiteId | 컨트롤 값 설정 |  |  |  |
| AC-6fcac2c7 | this.Load | SSP0026_BodItemPopup.cs:175 |  | VALUE_SET | txtToSite.Text | sToSiteId | 컨트롤 값 설정 |  |  |  |
| AC-3d0bea60 | this.Load | SSP0026_BodItemPopup.cs:176 |  | VALUE_SET | clbToSite.ControlValues | sToSiteId | 컨트롤 값 설정 |  |  |  |
| AC-2fc424f9 | this.Load | SSP0026_BodItemPopup.cs:177 |  | VALUE_SET | txtItemID.Text | sItemId | 컨트롤 값 설정 |  |  |  |
| AC-de41a154 | this.Load | SSP0026_BodItemPopup.cs:179 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-be3844d0 | this.Load | SSP0026_BodItemPopup.cs:180 |  | STATE | clbFromSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5739ec98 | this.Load | SSP0026_BodItemPopup.cs:181 |  | STATE | clbToSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0026_BodItemPopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6c0bd1f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:201 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-15076118 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:203 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dc815d4f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:204 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DivisionName, DefColumns.Division, FPMerge.None, 60, true ,FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1a5cdf37 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:205 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DivisionName, DefColumns.DivisionName, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-254a82fc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:207 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ItemId, DefColumns.ItemId, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2500844c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:208 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.Incoterms, DefColumns.Incoterms, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b7a0012 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:209 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.Transport, DefColumns.Transport, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c365fff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_BodItemPopup.cs:210 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.BodId, DefColumns.BodId, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0026_BodItemPopup.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e5a5d32 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_BodItemPopup.cs:333 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afa986af | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_BodItemPopup.cs:335 |  | FLAG | itemID | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c840ad3d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_BodItemPopup.cs:336 |  | FLAG | modelID | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-34785ef2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_BodItemPopup.cs:337 |  | FLAG | incoterms | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-926653ac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_BodItemPopup.cs:338 |  | FLAG | transport | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-42f42e08 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_BodItemPopup.cs:354 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e39e703f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_BodItemPopup.cs:358 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | itemID + "," + this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e76668ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_BodItemPopup.cs:366 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-34fd22c3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_BodItemPopup.cs:371 | else of (bMulltiSelect) | FLAG | itemID | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-9aeb62c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_BodItemPopup.cs:373 | else of (bMulltiSelect) | FLAG | incoterms | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Incoterms)) | 화면 필드/플래그 변경 |  |  |  |
| AC-f2b9e21f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_BodItemPopup.cs:374 | else of (bMulltiSelect) | FLAG | transport | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Transport)) | 화면 필드/플래그 변경 |  |  |  |
| AC-57df4c8f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_BodItemPopup.cs:375 | else of (bMulltiSelect) | FLAG | bodId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BodId)) | 화면 필드/플래그 변경 |  |  |  |

## SSP0026_BodItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3992b63c | this.spdMain.CellDoubleClick | SSP0026_BodItemPopup.cs:326 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0026_ItembyDivisionPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-351e53cf | this.btnButtonList.UsrButtonList_Click_Detected | SSP0026_ItembyDivisionPopup.cs:292 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-c70242b2 | this.btnButtonList.UsrButtonList_Click_Detected | SSP0026_ItembyDivisionPopup.cs:295 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0026_ItembyDivisionPopup.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06ab6109 | this.clbDivision.SelectedIndexChanged | SSP0026_ItembyDivisionPopup.cs:302 |  | FLAG | dtScmSite | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-d7b18122 | this.clbDivision.SelectedIndexChanged | SSP0026_ItembyDivisionPopup.cs:302 |  | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "40") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-50431e4c | this.clbDivision.SelectedIndexChanged | SSP0026_ItembyDivisionPopup.cs:303 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0026_ItembyDivisionPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4978f70 | this.Load | SSP0026_ItembyDivisionPopup.cs:177 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-aa65a714 | this.Load | SSP0026_ItembyDivisionPopup.cs:178 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b8834f7 | this.Load | SSP0026_ItembyDivisionPopup.cs:179 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0026_ItembyDivisionPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b888306b | this.Load | SSP0026_ItembyDivisionPopup.cs:172 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0026_ItembyDivisionPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2c9933e | Dispose | SSP0026_ItembyDivisionPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0026_ItembyDivisionPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a8071ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:238 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-66c008c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:242 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP") ⇒ SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-1b920b35 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:243 | lambda | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-8d163a36 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:244 | lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-ae69ef7f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:245 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbScmSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-2799934e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:246 | lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-115a73d0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:247 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9b73f762 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:249 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7dc60566 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:253 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2f45e4c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:254 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f876e0c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:258 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-be7c6a2c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:262 | if (ds.Tables[0].Rows.Count == 1) | FLAG | itemID | this.dtFindData.Rows[0][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6a68f1bf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:263 | if (ds.Tables[0].Rows.Count == 1) | FLAG | itemName | this.dtFindData.Rows[0][DefColumns.ItemName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5a5990ea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:264 | if (ds.Tables[0].Rows.Count == 1) | FLAG | itemType | this.dtFindData.Rows[0][DefColumns.ItemType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-eb798e32 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:265 | if (ds.Tables[0].Rows.Count == 1) | FLAG | nickName | this.dtFindData.Rows[0][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5fff82e9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:266 | if (ds.Tables[0].Rows.Count == 1) | FLAG | itemclassname | this.dtFindData.Rows[0][DefColumns.ItemClassName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1eb63439 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:268 | if (ds.Tables[0].Rows.Count == 1) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0026_ItembyDivisionPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ee0ddd1 | this.Load | SSP0026_ItembyDivisionPopup.cs:131 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-340ea8da | this.Load | SSP0026_ItembyDivisionPopup.cs:132 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e0eb72c4 | this.Load | SSP0026_ItembyDivisionPopup.cs:140 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-b14e18f8 | this.Load | SSP0026_ItembyDivisionPopup.cs:141 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-dff247c6 | this.Load | SSP0026_ItembyDivisionPopup.cs:142 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-c4adf5a2 | this.Load | SSP0026_ItembyDivisionPopup.cs:143 |  | FLAG | sScmSiteId | _ScmSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-3d3c5250 | this.Load | SSP0026_ItembyDivisionPopup.cs:144 |  | FLAG | sItemId | _ItemID | 화면 필드/플래그 변경 |  |  |  |

## SSP0026_ItembyDivisionPopup.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d846987 | this.Load | SSP0026_ItembyDivisionPopup.cs:374 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-3c03cdb6 | this.Load | SSP0026_ItembyDivisionPopup.cs:376 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-12af5bd5 | this.Load | SSP0026_ItembyDivisionPopup.cs:379 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0026_ItembyDivisionPopup.GetDivisionbyScmSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a940aa7d | (진입점 미연결) | SSP0026_ItembyDivisionPopup.cs:388 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-6ed603dd | (진입점 미연결) | SSP0026_ItembyDivisionPopup.cs:389 |  | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-5376a235 | (진입점 미연결) | SSP0026_ItembyDivisionPopup.cs:390 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-6426c49f | (진입점 미연결) | SSP0026_ItembyDivisionPopup.cs:391 |  | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-039854cb | (진입점 미연결) | SSP0026_ItembyDivisionPopup.cs:393 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4c6e222b | (진입점 미연결) | SSP0026_ItembyDivisionPopup.cs:396 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0026_ItembyDivisionPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31a4bb86 | this.Load | SSP0026_ItembyDivisionPopup.cs:151 |  | FLAG | dtDivision | GetDivision() | 화면 필드/플래그 변경 |  |  |  |
| AC-84a8a8ec | this.Load | SSP0026_ItembyDivisionPopup.cs:152 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b90a5ac8 | this.Load | SSP0026_ItembyDivisionPopup.cs:155 |  | FLAG | dtScmSite | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-eb55133e | this.Load | SSP0026_ItembyDivisionPopup.cs:155 |  | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "40") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-536d543e | this.Load | SSP0026_ItembyDivisionPopup.cs:157 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ff2b8c9c | this.Load | SSP0026_ItembyDivisionPopup.cs:159 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-a33b769b | this.Load | SSP0026_ItembyDivisionPopup.cs:160 |  | VALUE_SET | txtProject.ControlValues | sProject | 컨트롤 값 설정 |  |  |  |
| AC-a92aca02 | this.Load | SSP0026_ItembyDivisionPopup.cs:161 |  | VALUE_SET | clbScmSite.ControlValues | sScmSiteId | 컨트롤 값 설정 |  |  |  |
| AC-977d0e74 | this.Load | SSP0026_ItembyDivisionPopup.cs:162 |  | VALUE_SET | txtItemID.Text | sItemId | 컨트롤 값 설정 |  |  |  |
| AC-61ed45a4 | this.Load | SSP0026_ItembyDivisionPopup.cs:164 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-27c6870d | this.Load | SSP0026_ItembyDivisionPopup.cs:165 |  | STATE | txtProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-44445da6 | this.Load | SSP0026_ItembyDivisionPopup.cs:166 |  | STATE | clbScmSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0026_ItembyDivisionPopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0a5c6f4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:186 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-54f3ca20 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:188 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-35ce70c1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:189 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DivisionName, DefColumns.Division, FPMerge.None, 60, true ,FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e801e55 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:190 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DivisionName, DefColumns.DivisionName, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-745b2565 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:191 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.Project, DefColumns.Project, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ff79c6b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:192 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ProjectName, DefColumns.ProjectName, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71005973 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:193 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ScmSiteId, DefColumns.ScmSiteId, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6d08532 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:194 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ScmSiteDesc, DefColumns.ScmSiteDesc, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b134dd5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:195 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ItemId, DefColumns.ItemId, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5909afec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:196 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ItemName, DefColumns.ItemName, FPMerge.None, 130, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-75f131bb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:197 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ItemType, DefColumns.ItemType, FPMerge.None, 40, true, FPHAlign.Center, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb2eded9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:198 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.NickName, DefColumns.NickName, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c23a75d8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0026_ItembyDivisionPopup.cs:199 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ItemClassName, DefColumns.ItemClassName, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0026_ItembyDivisionPopup.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af6ea447 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:316 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-defb580c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:318 |  | FLAG | itemID | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-55cf4403 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:334 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-616a813a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:335 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemName | this.dtFindData.Rows[iRow][DefColumns.ItemName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c1d6df7d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:336 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemType | this.dtFindData.Rows[iRow][DefColumns.ItemType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d3bc3fab | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:337 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d8351de8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:338 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemclassname | this.dtFindData.Rows[iRow][DefColumns.ItemClassName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4183a795 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:342 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | itemID + "," + this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8fcd2184 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:343 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemName | itemName + "," + this.dtFindData.Rows[iRow][DefColumns.ItemName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-82793b64 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:344 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemType | itemType + "," + this.dtFindData.Rows[iRow][DefColumns.ItemType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2376d73a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:345 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | nickName + "," + this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c70b1dff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:346 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemclassname | itemclassname + "," + this.dtFindData.Rows[iRow][DefColumns.ItemClassName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6a0aebf9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:354 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef5f2e9c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:359 | else of (bMulltiSelect) | FLAG | itemID | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-73acc3e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:360 | else of (bMulltiSelect) | FLAG | itemName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-20aafbdc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:361 | else of (bMulltiSelect) | FLAG | itemType | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemType)) | 화면 필드/플래그 변경 |  |  |  |
| AC-246e6a5a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:362 | else of (bMulltiSelect) | FLAG | nickName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NickName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-0072fa17 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0026_ItembyDivisionPopup.cs:363 | else of (bMulltiSelect) | FLAG | itemclassname | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemClassName)) | 화면 필드/플래그 변경 |  |  |  |

## SSP0026_ItembyDivisionPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33c9b951 | this.spdMain.CellDoubleClick | SSP0026_ItembyDivisionPopup.cs:309 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0026_ShipmentRequestPack.BodValidChk

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7cb90e3 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3862 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_BOD_VALID_CHECK") ⇒ SSP.SSP0002_GET_BOD_VALID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-08606ecd | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3863 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-bd03c0b8 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3864 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-736c4996 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3865 | try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-d4f250d5 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3866 | try | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-2e63f48d | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3867 | try | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-0c57c1e1 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3868 | try | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-be36a7d3 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3870 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b74660af | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3883 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c3e89e0d | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3885 | try ▸ else of (ds.Tables[0].Rows.Count > 0) ▸ if (MessageHelper.GMessageBox("MSG00324") == DialogResult.Yes) | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c1b72cd | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3890 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-53562e0c | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3900 | try ▸ else of (ds.Tables[1].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-10946e36 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3902 | try ▸ else of (ds.Tables[1].Rows.Count > 0) ▸ if (MessageHelper.GMessageBox("MSG00324") == DialogResult.Yes) | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce70a4e7 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3906 | try ▸ else of (ds.Tables[1].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-204a5e3b | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3910 | catch ((Exception )) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-45b9cd0f | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3912 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0026_ShipmentRequestPack.BodValidChk_Main

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5db5838a | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3794 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_BOD_VALID_CHECK") ⇒ SSP.SSP0002_GET_BOD_VALID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-15587bb4 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3795 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d7425df1 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3796 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-eee64ccf | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3797 | try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-22203cda | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3798 | try | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-3c26f45e | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3799 | try | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-7d4111cc | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3800 | try | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-89235ae1 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3802 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-997b9fca | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3815 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bf8ad6eb | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3817 | try ▸ else of (ds.Tables[0].Rows.Count > 0) ▸ if (MessageHelper.GMessageBox("MSG00324") == DialogResult.Yes) | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ffc5186 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3822 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-46bf7656 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3832 | try ▸ else of (ds.Tables[1].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-895d66db | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3834 | try ▸ else of (ds.Tables[1].Rows.Count > 0) ▸ if (MessageHelper.GMessageBox("MSG00324") == DialogResult.Yes) | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fff8479f | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3838 | try ▸ else of (ds.Tables[1].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-292957aa | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3842 | catch ((Exception )) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-408003fa | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3844 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0026_ShipmentRequestPack.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d83d2b1 | this.btnColumn.Click | SSP0026_ShipmentRequestPack.cs:2879 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DMF0045", SpdSheet.shtPack, true) | 팝업/폼 생성 |  |  |  |
| AC-fe4c3f35 | this.btnColumn.Click | SSP0026_ShipmentRequestPack.cs:2880 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7700e5c2 | this.btnColumn.Click | SSP0026_ShipmentRequestPack.cs:2881 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0026_ShipmentRequestPack.btnExcelFormDownload_Click

진입점: this.formDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70dfaff4 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4374 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtRequestDetail_Excel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cc2032ef | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4375 |  | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtRequestDetail_Excel) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0026_ShipmentRequestPack.btnExcelUpload_Click

진입점: this.btnExcelUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57ce6286 | this.btnExcelUpload.Click | SSP0026_ShipmentRequestPack.cs:4353 |  | POPUP | new ExcelUploadForm | ("SSP0026", "Shipment Request(IT & Mobile)") | 팝업/폼 생성 |  |  |  |
| AC-7b10334e | this.btnExcelUpload.Click | SSP0026_ShipmentRequestPack.cs:4354 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-190cfda5 | this.btnExcelUpload.Click | SSP0026_ShipmentRequestPack.cs:4355 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f776d20e | this.btnExcelUpload.Click | SSP0026_ShipmentRequestPack.cs:4356 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7e8b6388 | this.btnExcelUpload.Click | SSP0026_ShipmentRequestPack.cs:4358 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-37bc8f4e | this.btnExcelUpload.Click | SSP0026_ShipmentRequestPack.cs:4360 | if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7d34faa2 | this.btnExcelUpload.Click | SSP0026_ShipmentRequestPack.cs:4361 | if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtRequestDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0026_ShipmentRequestPack.BtnItemID_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2358bf73 | this.btnItemId.Click | SSP0026_ShipmentRequestPack.cs:3512 |  | POPUP | new SSP0026_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5769f0b0 | this.btnItemId.Click | SSP0026_ShipmentRequestPack.cs:3514 |  | POPUP | popItem.Form_Load | (true, sDivision_ID, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-045fb973 | this.btnItemId.Click | SSP0026_ShipmentRequestPack.cs:3515 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f21b155b | this.btnItemId.Click | SSP0026_ShipmentRequestPack.cs:3516 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fb3a00bb | this.btnItemId.Click | SSP0026_ShipmentRequestPack.cs:3522 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.BtnItemID2_Click

진입점: this.btnItemID2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6aee780 | this.btnItemID2.Click | SSP0026_ShipmentRequestPack.cs:3532 |  | POPUP | new SSP0026_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e596ddcf | this.btnItemID2.Click | SSP0026_ShipmentRequestPack.cs:3534 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-51ebf22d | this.btnItemID2.Click | SSP0026_ShipmentRequestPack.cs:3535 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6d695a15 | this.btnItemID2.Click | SSP0026_ShipmentRequestPack.cs:3536 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0106dc3e | this.btnItemID2.Click | SSP0026_ShipmentRequestPack.cs:3542 | if (popItem.ItemID != "") | VALUE_SET | txtItemld2.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eee4773b | this.btnMeasure.Click | SSP0026_ShipmentRequestPack.cs:3085 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0affe9bc | this.btnMeasure.Click | SSP0026_ShipmentRequestPack.cs:3089 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-baf57a91 | this.btnMeasure.Click | SSP0026_ShipmentRequestPack.cs:3090 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03887221 | this.btnMeasure.Click | SSP0026_ShipmentRequestPack.cs:3095 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33de29c1 | this.btnMeasure.Click | SSP0026_ShipmentRequestPack.cs:3096 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-37e88fa4 | this.btnMeasure.Click | SSP0026_ShipmentRequestPack.cs:3099 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0026", strSheetName, false) | 팝업/폼 생성 |  |  |  |
| AC-92f07361 | this.btnMeasure.Click | SSP0026_ShipmentRequestPack.cs:3100 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9f0bd74e | this.btnMeasure.Click | SSP0026_ShipmentRequestPack.cs:3101 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0026_ShipmentRequestPack.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8571ca59 | this.btnProject.Click | SSP0026_ShipmentRequestPack.cs:2840 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-b90af857 | this.btnProject.Click | SSP0026_ShipmentRequestPack.cs:2842 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c8582219 | this.btnProject.Click | SSP0026_ShipmentRequestPack.cs:2843 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-68bc5c52 | this.btnProject.Click | SSP0026_ShipmentRequestPack.cs:2844 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-19e25a21 | this.btnProject.Click | SSP0026_ShipmentRequestPack.cs:2850 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.BtnRequestor_Click

진입점: this.btnRequestor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35982146 | this.btnRequestor.Click | SSP0026_ShipmentRequestPack.cs:3547 |  | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5445f5d0 | this.btnRequestor.Click | SSP0026_ShipmentRequestPack.cs:3549 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-d607c37d | this.btnRequestor.Click | SSP0026_ShipmentRequestPack.cs:3550 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-c34fa86d | this.btnRequestor.Click | SSP0026_ShipmentRequestPack.cs:3551 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ed1387a5 | this.btnRequestor.Click | SSP0026_ShipmentRequestPack.cs:3552 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-2098dbb3 | this.btnRequestor.Click | SSP0026_ShipmentRequestPack.cs:3553 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-a4b77195 | this.btnRequestor.Click | SSP0026_ShipmentRequestPack.cs:3555 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-3addaf9e | this.btnRequestor.Click | SSP0026_ShipmentRequestPack.cs:3557 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4d6cd98b | this.btnRequestor.Click | SSP0026_ShipmentRequestPack.cs:3563 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sRequestor | item.UserID | 화면 필드/플래그 변경 |  |  |  |
| AC-c849866e | this.btnRequestor.Click | SSP0026_ShipmentRequestPack.cs:3567 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName | 컨트롤 값 설정 |  |  |  |
| AC-58c2b6d3 | this.btnRequestor.Click | SSP0026_ShipmentRequestPack.cs:3571 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName_E | 컨트롤 값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.BtnSearch_Click

진입점: this.btnSearch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6304a719 | this.btnSearch.Click | SSP0026_ShipmentRequestPack.cs:3112 | if (spdDetail.ActiveSheetIndex == 0) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc85b7b3 | this.btnSearch.Click | SSP0026_ShipmentRequestPack.cs:3120 | else of (spdDetail.ActiveSheetIndex == 0) ▸ if (spdDetail.ActiveSheetIndex == 1) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtResultDetail) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0026_ShipmentRequestPack.cboDivision_SelectedIndexChanged

진입점: this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1f01849 | this.cboDivision.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2082 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-0a16518a | this.cboDivision.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2082 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1bed74b4 | this.cboDivision.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2083 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-69a841c8 | this.cboDivision.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2087 |  | FLAG | dtCustomer | Data.UserSoldToCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoConte… | 화면 필드/플래그 변경 |  |  |  |
| AC-e4ed6f8e | this.cboDivision.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2087 |  | COMBO_DATA | Data.UserSoldToCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d71b4dbe | this.cboDivision.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2088 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c5e7ab7c | this.cboDivision.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2092 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-775ad120 | this.cboDivision.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2092 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0beea0d3 | this.cboDivision.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2093 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a68adbe1 | this.cboDivision.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2095 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-bea300a3 | this.cboDivision.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2095 |  | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3d70ff68 | this.cboDivision.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2096 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0026_ShipmentRequestPack.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be83f5e1 | this.clbCustomer.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2116 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-6d28b904 | this.clbCustomer.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2116 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d032e33c | this.clbCustomer.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2117 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0026_ShipmentRequestPack.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a904042 | this.clbTeam.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2104 |  | FLAG | dtCustomer | Data.UserSoldToCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoConte… | 화면 필드/플래그 변경 |  |  |  |
| AC-d2e28e38 | this.clbTeam.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2104 |  | COMBO_DATA | Data.UserSoldToCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-317a6088 | this.clbTeam.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2105 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-16335685 | this.clbTeam.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2108 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-be14199d | this.clbTeam.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2108 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cceb709a | this.clbTeam.SelectedIndexChanged | SSP0026_ShipmentRequestPack.cs:2109 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0026_ShipmentRequestPack.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84b30df2 | this.Load | SSP0026_ShipmentRequestPack.cs:331 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPack, SpdSheet.shtPack, 3, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-34825780 | this.Load | SSP0026_ShipmentRequestPack.cs:332 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPack) | 화면 필드/플래그 변경 |  |  |  |
| AC-960f3306 | this.Load | SSP0026_ShipmentRequestPack.cs:335 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPack) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0cc6eac0 | this.Load | SSP0026_ShipmentRequestPack.cs:340 | if (drPgmAuthId != null) | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtCell, SpdSheet.shtCell, 3, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-00dc7a58 | this.Load | SSP0026_ShipmentRequestPack.cs:341 | if (drPgmAuthId != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtCell) | 화면 필드/플래그 변경 |  |  |  |
| AC-e1decd63 | this.Load | SSP0026_ShipmentRequestPack.cs:343 | if (drPgmAuthId != null) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtCell) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b4f61635 | this.Load | SSP0026_ShipmentRequestPack.cs:351 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtRequestDetail, SpdSheet.shtRequestDetail, 1, 1, 60) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e5010e2a | this.Load | SSP0026_ShipmentRequestPack.cs:352 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtRequestDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-d4ca9376 | this.Load | SSP0026_ShipmentRequestPack.cs:353 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4f19da1b | this.Load | SSP0026_ShipmentRequestPack.cs:356 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-779e9021 | this.Load | SSP0026_ShipmentRequestPack.cs:358 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtResultDetail, SpdSheet.shtResultDetail, 1, 1, 60) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8edb3249 | this.Load | SSP0026_ShipmentRequestPack.cs:359 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtResultDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-0cd76c6a | this.Load | SSP0026_ShipmentRequestPack.cs:360 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtResultDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e87c7073 | this.Load | SSP0026_ShipmentRequestPack.cs:363 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtRequestDetail_Excel, SpdSheet.shtRequestDetail_Excel, 1, 1, 60) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2756988a | this.Load | SSP0026_ShipmentRequestPack.cs:365 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtRequestDetail_Excel) | 화면 필드/플래그 변경 |  |  |  |
| AC-c4e0ef49 | this.Load | SSP0026_ShipmentRequestPack.cs:366 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtRequestDetail_Excel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49ad290c | this.Load | SSP0026_ShipmentRequestPack.cs:369 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d393d3e3 | this.Load | SSP0026_ShipmentRequestPack.cs:373 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPack) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0026_ShipmentRequestPack.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-248be394 | this.Load | SSP0026_ShipmentRequestPack.cs:316 |  | UI_PROP | usrConditionPanel1.Height | 108 | 속성 Height 설정 |  |  |  |
| AC-0ea32ff8 | this.Load | SSP0026_ShipmentRequestPack.cs:317 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-c3b61c83 | this.Load | SSP0026_ShipmentRequestPack.cs:319 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-5ae466b0 | this.Load | SSP0026_ShipmentRequestPack.cs:320 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-e2268fcd | this.Load | SSP0026_ShipmentRequestPack.cs:321 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-87aea676 | this.Load | SSP0026_ShipmentRequestPack.cs:322 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-4938a931 | this.Load | SSP0026_ShipmentRequestPack.cs:325 |  | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4971ee48 | DeleteButton | SSP0026_ShipmentRequestPack.cs:624 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## SSP0026_ShipmentRequestPack.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89a50fd9 | Dispose | SSP0026_ShipmentRequestPack.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0026_ShipmentRequestPack.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d020af3 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:633 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9cc83a2e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:639 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.SheetName == "Cell Biz") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7df7f142 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:640 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.SheetName == "Cell Biz") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-8c5f3d36 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:648 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.SheetName == "Cell Biz") ▸ if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-52006d44 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:653 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.SheetName == "Cell Biz") ▸ else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-edcf7d81 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:662 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtResultDetail) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6e7d1f1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:663 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtResultDetail) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce41bb80 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:675 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode_Detail == false) ▸ if (siDetail.ActiveSheet.SheetName == Spd… | FLAG | siDetail | GetSheetInfo(spdDetail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0a3af72e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:676 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode_Detail == false) ▸ if (siDetail.ActiveSheet.SheetName == Spd… | GRID_LOCK | siDetail.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-6797c2e1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:686 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode_Detail == false) ▸ if (siDetail.ActiveSheet.SheetName == Spd… | GRID_LOCK | siDetail.LockRange | (i, 0, i, siDetail.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e585420 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:692 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode_Detail == false) ▸ if (siDetail.ActiveSheet.SheetName == Spd… | GRID_LOCK | siDetail.LockRange | (i, siDetail.GetColumnIndex(DefColumns.Qty), i, siDetail.GetColumnIndex(DefColumns.REMARK)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6928fe67 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:697 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode_Detail == false) ▸ if (siDetail.ActiveSheet.SheetName == Spd… | GRID_LOCK | siDetail.LockRange | (i, 0, i, siDetail.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-de8a3acc | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:702 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode_Detail == false) ▸ if (siDetail.ActiveSheet.SheetName == Spd… | FLAG | bEdit_Mode_Detail | true | 화면 필드/플래그 변경 |  |  |  |
| AC-74b7bb18 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:714 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (bEdit_Mode_Detail == false) ▸ if (siDetail.ActiveSheet.SheetName =… | FLAG | siDetail | GetSheetInfo(spdDetail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-18eee1ee | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:715 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (bEdit_Mode_Detail == false) ▸ if (siDetail.ActiveSheet.SheetName =… | GRID_LOCK | siDetail.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-eb036e54 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:724 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (bEdit_Mode_Detail == false) ▸ if (siDetail.ActiveSheet.SheetName =… | GRID_LOCK | siDetail.LockRange | (i, 0, i, siDetail.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-47cf586a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0026_ShipmentRequestPack.cs:727 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (bEdit_Mode_Detail == false) ▸ if (siDetail.ActiveSheet.SheetName =… | FLAG | bEdit_Mode_Detail | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0026_ShipmentRequestPack.ExportExcel

진입점: this.formDown.Click [finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86cb38bd | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4385 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c90ea0a | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4392 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6e012714 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4399 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c56c7aea | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4406 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-29cad16a | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4408 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15da32c0 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4411 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c40e0ba | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4447 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sv.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b4a9ec9b | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4452 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-5efed4e3 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4457 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a46a0b7a | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4459 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6eff2768 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4472 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-531841df | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4484 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-8773f863 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4485 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-e8e0322a | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4494 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-0ba6779f | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4495 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-06a79825 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4501 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-f63c42a7 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4514 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-6702d79e | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4523 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-905a0308 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4530 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ec7ffdd | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4535 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-6cdfa6ef | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4537 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-5f7fb770 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4541 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-9f97f892 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4543 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-ac4e5f25 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4546 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-87ce940b | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4548 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-5572a635 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4553 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-707838b5 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4564 | try ▸ if (isOpen) | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-48f38c2f | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4566 | try ▸ if (isOpen) | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-92ba222e | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4570 | try ▸ else of (isOpen) | POPUP | new SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-2be026f7 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4571 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Filter | "Excel files (*.xls or .xlsx)\|*.xls;*.xlsx" | 속성 Filter 설정 |  |  |  |
| AC-493884c2 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4572 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Title | "Save an Excel File" | 속성 Title 설정 |  |  |  |
| AC-24870639 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4573 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.FileName | sExcelFileName | 속성 FileName 설정 |  |  |  |
| AC-9144bf29 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4574 | try ▸ else of (isOpen) | POPUP | saveFileDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5de4eab1 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4581 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") | CALL_EXT | sFileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc0ce65e | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4582 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ if (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUpper() =… | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-da78cef1 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4584 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ else of (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUppe… | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d08ee29f | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4588 | try | CALL_EXT | GC.GetGeneration | ((object)sp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb510ed4 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4594 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e25bc816 | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4598 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f12d7a0a | this.formDown.Click [finally] | SSP0026_ShipmentRequestPack.cs:4601 | finally ▸ if (ver >= 0) | CALL_EXT | GC.Collect | (ver) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0026_ShipmentRequestPack.FindData

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)] / FindButton / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43a183f0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:753 |  | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-44eb17a4 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:755 |  | FLAG | dtMeasure | Data.Common(Data.Type.Measure, false, "SSP0026", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-46d55e17 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:755 |  | COMBO_DATA | Data.Common | (Data.Type.Measure, false, "SSP0026", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-590a0a10 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:757 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5a3ea404 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:766 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-28d045a6 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:767 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5503d431 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:771 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d30acb53 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:776 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-85037f32 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:783 | try ▸ if (spdMain.ActiveSheetIndex == 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-09415bed | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:787 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK") ⇒ SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK | 엔드포인트 요청 생성 |  |  |  |
| AC-e13eb44c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:789 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9ff90f0a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:791 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_sheet_name"] | siMain.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-f500d27d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:792 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a5cf9b46 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:793 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_team_id"] | (sTeam == "ALL") ? "" : sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-88e48087 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:794 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_customer"] | (clbCustomer.ControlValues == "ALL") ? "" : clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-915766e3 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:795 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | (clbSalesSite.ControlValues == "ALL") ? "" : clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-fe4ba39f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:797 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | sPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-6d78a39c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:798 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-f977d563 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:799 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b87eda01 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:801 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-91a1cc53 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:802 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-fb0ae686 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:803 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8fa66639 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:804 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-5d78fca7 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:806 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-48b156f7 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:808 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-753ca7e7 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:825 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (ds.Tables[0] != null) | GRID_BIND | siMain.Query | (ds,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-11cbe1a7 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:826 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (ds.Tables[0] != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f1191832 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:827 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (ds.Tables[0] != null) | GRID_LOCK | siMain.LockColumn2 | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-73ac7f2a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:835 | try ▸ if (spdMain.ActiveSheetIndex == 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c3ec708e | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:844 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1084a719 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:848 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL") ⇒ SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL | 엔드포인트 요청 생성 |  |  |  |
| AC-e52d70e1 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:850 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cdded830 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:852 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_sheet_name"] | siMain.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-9c6e8a8b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:853 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-4ed3142f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:854 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_team_id"] | (sTeam == "ALL") ? "" : sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-98d22a2d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:855 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_customer"] | (clbCustomer.ControlValues == "ALL") ? "" : clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e2983a21 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:856 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | (clbSalesSite.ControlValues == "ALL") ? "" : clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-feefd7f0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:858 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | sPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-403ab0bf | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:859 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d361e4b0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:860 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-972a851f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:861 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-b7cbfb69 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:862 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-47924631 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:863 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9c3c3c21 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:864 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-5cbc8c64 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:866 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d75625d1 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:868 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5cd2c7d6 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:878 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (ds.Tables[0] != null) | GRID_BIND | siMain.Query | (ds,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f1bbe839 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:879 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (ds.Tables[0] != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c740a2f4 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:880 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (ds.Tables[0] != null) | GRID_LOCK | siMain.LockColumn2 | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-ff745834 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:904 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c78f9dbc | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:905 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3c806ecb | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:913 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9aff368c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:915 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0026_ShipmentRequestPack.FindData_BOD

진입점: this.spdDetail.ComboSelChange [else of (e.Column == siDetail.GetColumnIndex(DefColumns.FromSite)) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ToSite)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.Incoterms))] / this.spdDetail.ClipboardPasted [if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siDetail.ActiveSheet.Cells[iRow, iCol].Text != "") ▸ else of (iCol == siDetail.GetColumnIndex(DefC…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c39a3f4 | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:3978 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0dec0c0c | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:3982 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_BOD_ITEM") ⇒ SSP.SSP0026_GET_BOD_ITEM | 엔드포인트 요청 생성 |  |  |  |
| AC-391134b4 | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:3983 | lambda | DATA_OP | request.Parameters["p_division_id"] | sdivision | 행/컬럼 값 대입 |  |  |  |
| AC-8b0730ee | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:3984 | lambda | DATA_OP | request.Parameters["p_from_site_id"] | sFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-9408b991 | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:3985 | lambda | DATA_OP | request.Parameters["p_to_site_id"] | sToSite | 행/컬럼 값 대입 |  |  |  |
| AC-844ca67a | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:3986 | lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-f06a222d | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:3987 | lambda | DATA_OP | request.Parameters["p_bod_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9eff4f73 | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:3988 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8816493f | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:3990 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b4b55d7d | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:3994 |  | FLAG | dtFindData_BOD | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-f89fba3e | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:4003 | if (dtFindData_BOD.Rows.Count > 0) | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sdivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-fb40450c | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:4003 | if (dtFindData_BOD.Rows.Count > 0) | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sdivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-62c0c438 | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:4007 | if (dtFindData_BOD.Rows.Count > 0) | GRID_SET | siDetail.SetValue | (row, siDetail.GetColumnIndex(DefColumns.BodId), sBodId) | 그리드 값 설정 |  |  |  |
| AC-b15b1f48 | this.spdDetail.ComboSelChange [else of (e.Column == siDetail… 외 1 | SSP0026_ShipmentRequestPack.cs:4014 | else of (dtFindData_BOD.Rows.Count > 0) | GRID_SET | siDetail.SetValue | (row, siDetail.GetColumnIndex(DefColumns.BodId), "") | 그리드 값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.FindData_BOD_Main

진입점: this.spdMain.ComboSelChange [else of (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ToSite)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Incoterms))] / this.spdMain.ClipboardPasted [if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ▸ else of (iCol == siMain.GetColumnIndex(DefColumns.ItemId)) ▸ else of (iC…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd68704a | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3926 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fac7fe3c | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3930 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_BOD_ITEM") ⇒ SSP.SSP0026_GET_BOD_ITEM | 엔드포인트 요청 생성 |  |  |  |
| AC-4a314811 | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3931 | lambda | DATA_OP | request.Parameters["p_division_id"] | sdivision | 행/컬럼 값 대입 |  |  |  |
| AC-1e65347f | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3932 | lambda | DATA_OP | request.Parameters["p_from_site_id"] | sFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-c3a5b733 | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3933 | lambda | DATA_OP | request.Parameters["p_to_site_id"] | sToSite | 행/컬럼 값 대입 |  |  |  |
| AC-3ef3e178 | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3934 | lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-15c4b10b | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3935 | lambda | DATA_OP | request.Parameters["p_bod_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b7cfe7f9 | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3936 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-89a181bd | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3938 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e873dbe6 | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3942 |  | FLAG | dtFindData_BOD | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-70334867 | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3951 | if (dtFindData_BOD.Rows.Count > 0) | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sdivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-7f0c43e6 | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3951 | if (dtFindData_BOD.Rows.Count > 0) | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sdivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f1bc687c | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3955 | if (dtFindData_BOD.Rows.Count > 0) | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.BodId), sBodId) | 그리드 값 설정 |  |  |  |
| AC-971a0199 | this.spdMain.ComboSelChange [else of (e.Column == siMain.Get… 외 1 | SSP0026_ShipmentRequestPack.cs:3962 | else of (dtFindData_BOD.Rows.Count > 0) | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.BodId), "") | 그리드 값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.FindData_Detail

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] / SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd9628ae | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1023 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-06e997b0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1033 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-e7eac5fb | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1033 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da8b5a48 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1036 | try | FLAG | iTopRow | siDetail.SpreadObject.GetViewportTopRow(0) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b2bd8a4 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1036 | try | CALL_EXT | siDetail.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb632cde | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1038 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-14114345 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1040 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod2) | 프레임워크 검증 |  |  |  |
| AC-f93b67bf | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1040 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afaf835d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1066 | try ▸ if (spdMain.ActiveSheetIndex == 0) | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fd669b16 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1067 | try ▸ if (spdMain.ActiveSheetIndex == 0) | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-76a9015d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1071 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_REQUEST_DETAIL_PACK") ⇒ SSP.SSP0026_GET_REQUEST_DETAIL_PACK | 엔드포인트 요청 생성 |  |  |  |
| AC-35961510 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1073 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-65b6cf0e | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1075 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | siDetail.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-dd6e588b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1076 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-13c4937f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1077 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_team_id"] | (sTeam == "ALL") ? "" : sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-85b5c034 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1078 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_customer"] | (clbCustomer.ControlValues == "ALL") ? "" : clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-ee4d9a5c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1079 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | (clbSalesSite.ControlValues == "ALL") ? "" : clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e12e8762 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1081 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | sPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-7964d62b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1082 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-8daa4cfe | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1083 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-3dcf7e0d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1084 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1d499002 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1085 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0a256f8e | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1086 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d5b38a5c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1087 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_requestor_id"] | p_requestor_id | 행/컬럼 값 대입 |  |  |  |
| AC-888b8d78 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1088 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-788c8a6f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1089 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7749a28e | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1091 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c20ebde8 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1092 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fc0930ff | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1102 | try ▸ if (spdMain.ActiveSheetIndex == 0) | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-28fc68ce | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1104 | try ▸ if (spdMain.ActiveSheetIndex == 0) | GRID_BIND | siDetail.Query | (dsBinding,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-037e2cf3 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1110 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a36706ef | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1111 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dbb72a5f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1115 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_REQUEST_DETAIL_CELL") ⇒ SSP.SSP0026_GET_REQUEST_DETAIL_CELL | 엔드포인트 요청 생성 |  |  |  |
| AC-54b2c51b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1117 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-931c34e1 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1119 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | siDetail.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-44a6ea2a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1120 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c00f7dbd | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1121 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_team_id"] | (sTeam == "ALL") ? "" : sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-d4f4cf59 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1122 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_customer"] | (clbCustomer.ControlValues == "ALL") ? "" : clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-95b24cf7 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1123 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | (clbSalesSite.ControlValues == "ALL") ? "" : clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e0b435bc | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1125 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | sPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-817cb2f0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1126 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-e6aefe0a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1127 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-3fbfca25 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1128 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bb38fcec | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1129 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-fbde3347 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1130 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5c53addc | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1131 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_requestor_id"] | p_requestor_id | 행/컬럼 값 대입 |  |  |  |
| AC-f3602914 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1132 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-76544178 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1133 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-0169b721 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1135 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f4e03af | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1136 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3f77198f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1145 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4a711bc5 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1147 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | GRID_BIND | siDetail.Query | (dsBinding,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-961f3ca8 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1149 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0580acd5 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1152 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-19d8f468 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1166 | finally | GRID_STYLE | siDetail.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-4aa2010c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:1167 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0026_ShipmentRequestPack.FindData_Detail_DblClick

진입점: this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPack) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Measure)) ▸ if (sMeasure == "SHIP_REQ" \|\| sMeasure == "Ship Req")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-513bba38 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1172 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e3a4c4a2 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1181 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b05c4d7f | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1181 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ada4b77b | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1184 | try | FLAG | iTopRow | siDetail.SpreadObject.GetViewportTopRow(0) | 화면 필드/플래그 변경 |  |  |  |
| AC-c294db7e | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1184 | try | CALL_EXT | siDetail.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c9954978 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1186 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-796ab6d2 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1188 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-cc0f13ad | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1188 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1d9713d | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1227 | try ▸ if (spdMain.ActiveSheetIndex == 0) | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-bd4337bf | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1228 | try ▸ if (spdMain.ActiveSheetIndex == 0) | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9f6ee75c | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1232 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_REQUEST_DETAIL_PACK") ⇒ SSP.SSP0026_GET_REQUEST_DETAIL_PACK | 엔드포인트 요청 생성 |  |  |  |
| AC-9831be63 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1234 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7d7aaea3 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1236 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | siDetail.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-349c2983 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1237 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5d2ca9a9 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1238 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_team_id"] | (sTeam == "ALL") ? "" : sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-e8deec18 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1239 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_customer"] | (clbCustomer.ControlValues == "ALL") ? "" : clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7a16d400 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1240 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | vToSite | 행/컬럼 값 대입 |  |  |  |
| AC-2f3df71b | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1242 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | sPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-11ebfcea | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1243 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-2bcb7949 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1244 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | vItem | 행/컬럼 값 대입 |  |  |  |
| AC-9ab7c288 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1245 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-fa3b6ed9 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1246 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7dafbf21 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1247 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aab4640a | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1248 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_requestor_id"] | p_requestor_id | 행/컬럼 값 대입 |  |  |  |
| AC-1a4b50f9 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1249 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-aab80735 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1250 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-acb51088 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1252 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-372bab0a | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1253 | try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4cc3f28e | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1262 | try ▸ if (spdMain.ActiveSheetIndex == 0) | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a503134f | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1264 | try ▸ if (spdMain.ActiveSheetIndex == 0) | GRID_BIND | siDetail.Query | (dsBinding,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d5a60220 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1269 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-aaa1a424 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1270 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9a1f225e | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1274 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_REQUEST_DETAIL_CELL") ⇒ SSP.SSP0026_GET_REQUEST_DETAIL_CELL | 엔드포인트 요청 생성 |  |  |  |
| AC-878bc6b2 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1276 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-27ef8458 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1278 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | siDetail.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-4f950741 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1279 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | cboDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-9626711e | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1280 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_team_id"] | (sTeam == "ALL") ? "" : sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-0a80639c | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1281 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_customer"] | (clbCustomer.ControlValues == "ALL") ? "" : clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-cf54cd05 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1282 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | vToSite | 행/컬럼 값 대입 |  |  |  |
| AC-d2794613 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1284 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | sPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-be4d0673 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1285 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-326779e1 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1286 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | vItem | 행/컬럼 값 대입 |  |  |  |
| AC-c3b2c386 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1287 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-de88eabb | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1288 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f470c18e | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1289 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e17282ba | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1290 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_requestor_id"] | p_requestor_id | 행/컬럼 값 대입 |  |  |  |
| AC-9693d279 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1291 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-16f187a5 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1292 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-984ffb1e | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1294 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-48c62d92 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1295 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e5f1b0a9 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1304 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f99a0160 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1306 | try ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | GRID_BIND | siDetail.Query | (dsBinding,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ac88ebdb | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1310 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5b7e28bb | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1312 | try | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d9a4ffe9 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1323 | finally | GRID_STYLE | siDetail.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-9731fa8a | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.Sh… | SSP0026_ShipmentRequestPack.cs:1324 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0026_ShipmentRequestPack.FindData_Request_Detail_DownLoad

진입점: this.formDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2198117 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4276 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7c9d8e3b | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4281 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-e0c4b3dc | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4281 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4cc43e1 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4283 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-df72c13c | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4284 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod2) | 프레임워크 검증 |  |  |  |
| AC-7691be88 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4284 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1f56f58 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4304 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8ad48b14 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4305 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0b7dd382 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4309 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN") ⇒ SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN | 엔드포인트 요청 생성 |  |  |  |
| AC-d8b92912 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4311 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f847571f | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4313 | try ▸ lambda | DATA_OP | req.Parameters["P_DIVISION_ID"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-91f0b662 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4314 | try ▸ lambda | DATA_OP | req.Parameters["P_FROM_YYYYMMDD"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-10931e22 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4315 | try ▸ lambda | DATA_OP | req.Parameters["P_TO_YYYYMMDD"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c4647f66 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4317 | try ▸ lambda | DATA_OP | req.Parameters["P_PLANT_SITE_ID"] | p_PlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-65eb7ee7 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4318 | try ▸ lambda | DATA_OP | req.Parameters["P_SCM_SITE_ID"] | (clbSalesSite.ControlValues == "ALL") ? "" : clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0ca6b76d | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4319 | try ▸ lambda | DATA_OP | req.Parameters["P_LOT_ID"] | p_lot_id | 행/컬럼 값 대입 |  |  |  |
| AC-bf12119a | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4320 | try ▸ lambda | DATA_OP | req.Parameters["P_ITEM_ID"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-eeac271a | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4321 | try ▸ lambda | DATA_OP | req.Parameters["P_NICK_NAME"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-c5523faa | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4322 | try ▸ lambda | DATA_OP | req.Parameters["P_USER_ID"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a7b13ba9 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4323 | try ▸ lambda | DATA_OP | req.Parameters["P_REQUESTOR_ID"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-5d089c7e | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4324 | try ▸ lambda | DATA_OP | req.Parameters["P_PROGRAM_ID"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-84a8ff80 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4325 | try ▸ lambda | DATA_OP | req.Parameters["P_SHEET_NAME"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-520555c8 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4329 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cbfaea61 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4330 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fd83fe65 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4336 | try | GRID_BIND | siSub.Query | (dsBinding,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1a5f378b | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4341 | catch ((Exception )) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0db2bd47 | this.formDown.Click | SSP0026_ShipmentRequestPack.cs:4345 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0026_ShipmentRequestPack.FindData_Result_Detail

진입점: this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex == 0) ▸ if (spdDetail.ActiveSheetIndex == 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-258b10af | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:925 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d686bf1d | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:934 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-7195bd4b | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:934 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a81a67a0 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:937 | try | FLAG | iTopRow | siDetail.SpreadObject.GetViewportTopRow(0) | 화면 필드/플래그 변경 |  |  |  |
| AC-04bed3e8 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:937 | try | CALL_EXT | siDetail.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-843f5285 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:939 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b00f8e99 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:941 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod2) | 프레임워크 검증 |  |  |  |
| AC-4f4e5b32 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:941 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4214462 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:964 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-cb04b034 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:965 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fa4b1136 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:969 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_RESULT_DETAIL") ⇒ SSP.SSP0026_GET_RESULT_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-fa87da9d | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:971 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8d30ba86 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:973 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | siDetail.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-96ce659d | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:974 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-23e8d970 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:975 | try ▸ lambda | DATA_OP | req.Parameters["p_team_id"] | (sTeam == "ALL") ? "" : sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-e0a3a94c | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:976 | try ▸ lambda | DATA_OP | req.Parameters["p_customer"] | (clbCustomer.ControlValues == "ALL") ? "" : clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-ee18a3d2 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:977 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | (clbSalesSite.ControlValues == "ALL") ? "" : clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-65dfe29c | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:979 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | sPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-4ec05338 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:980 | try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-19fb1800 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:981 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-67a5a8e8 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:982 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-78a8d165 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:983 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1f4aaea1 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:984 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b7375ca2 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:985 | try ▸ lambda | DATA_OP | req.Parameters["p_requestor_id"] | p_requestor_id | 행/컬럼 값 대입 |  |  |  |
| AC-351d5900 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:986 | try ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ec3effab | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:987 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-2408fd7e | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:989 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4ad3e7f6 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:990 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9d49ccea | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:998 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9f211198 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:1000 | try | GRID_BIND | siDetail.Query | (dsBinding,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-45c8e0d7 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:1002 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b5cfdcb2 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:1017 | finally | GRID_STYLE | siDetail.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-fa525f46 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… | SSP0026_ShipmentRequestPack.cs:1018 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0026_ShipmentRequestPack.fnValidation

진입점: SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8eaab59b | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (fps.Name … | SSP0026_ShipmentRequestPack.cs:3016 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-dcfae280 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (fps.Name … | SSP0026_ShipmentRequestPack.cs:3019 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## SSP0026_ShipmentRequestPack.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebd66641 | this.Load | SSP0026_ShipmentRequestPack.cs:208 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-41964d49 | this.Load | SSP0026_ShipmentRequestPack.cs:209 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0026_ShipmentRequestPack.GetBizTypebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7e17c50 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3056 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-a9d3810c | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3057 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e3a938b2 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3058 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fba32f52 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:3061 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0026_ShipmentRequestPack.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d442940d | this.Load | SSP0026_ShipmentRequestPack.cs:3044 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-ec190550 | this.Load | SSP0026_ShipmentRequestPack.cs:3045 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1a2c9900 | this.Load | SSP0026_ShipmentRequestPack.cs:3047 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0026_ShipmentRequestPack.GetSpdTitle

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboDivision.SelectedIndexChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPack) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Measure)) ▸ if (sMeasure == "SHIP…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-973c9ac8 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:3027 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_SPREAD_TITLE") ⇒ SSP.SSP0026_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-4118bdcd | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:3028 |  | DATA_OP | request.Parameters["p_division_id"] | "40" | 행/컬럼 값 대입 |  |  |  |
| AC-47cc2454 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:3029 |  | DATA_OP | request.Parameters["p_sheet_name"] | sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-da177faa | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:3030 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d12d1689 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:3031 |  | DATA_OP | request.Parameters["p_start_dt"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-ea13b645 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:3032 |  | DATA_OP | request.Parameters["p_end_dt"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-027a50c3 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:3034 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-3529a2f8 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:3034 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ef17f618 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:3035 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-ad919a8d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:3035 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0026_ShipmentRequestPack.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd147e1d | this.Load | SSP0026_ShipmentRequestPack.cs:231 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-3e6acd8b | this.Load | SSP0026_ShipmentRequestPack.cs:231 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8a94a838 | this.Load | SSP0026_ShipmentRequestPack.cs:236 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Plan_InforPacker, false, null) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7068dcf8 | this.Load | SSP0026_ShipmentRequestPack.cs:238 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-61c81d0a | this.Load | SSP0026_ShipmentRequestPack.cs:241 |  | VALUE_SET | cboDivision.ControlValues | "40" | 컨트롤 값 설정 |  |  |  |
| AC-f68ada01 | this.Load | SSP0026_ShipmentRequestPack.cs:243 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b671d06b | this.Load | SSP0026_ShipmentRequestPack.cs:247 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-95dabd2d | this.Load | SSP0026_ShipmentRequestPack.cs:247 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-be5452bc | this.Load | SSP0026_ShipmentRequestPack.cs:248 |  | FLAG | dtTeamSpr | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-b69d6cd1 | this.Load | SSP0026_ShipmentRequestPack.cs:248 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0c65836a | this.Load | SSP0026_ShipmentRequestPack.cs:249 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cebabb9d | this.Load | SSP0026_ShipmentRequestPack.cs:252 |  | FLAG | dtCustomer | Data.UserSoldToCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoConte… | 화면 필드/플래그 변경 |  |  |  |
| AC-03c96bb6 | this.Load | SSP0026_ShipmentRequestPack.cs:252 |  | COMBO_DATA | Data.UserSoldToCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-25308365 | this.Load | SSP0026_ShipmentRequestPack.cs:253 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8f05cf24 | this.Load | SSP0026_ShipmentRequestPack.cs:257 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-116d8cc2 | this.Load | SSP0026_ShipmentRequestPack.cs:257 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5c0704b3 | this.Load | SSP0026_ShipmentRequestPack.cs:258 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e8d92ee8 | this.Load | SSP0026_ShipmentRequestPack.cs:260 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-ba17a01b | this.Load | SSP0026_ShipmentRequestPack.cs:260 |  | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f7da0f93 | this.Load | SSP0026_ShipmentRequestPack.cs:261 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-409f7a25 | this.Load | SSP0026_ShipmentRequestPack.cs:265 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-e2f89674 | this.Load | SSP0026_ShipmentRequestPack.cs:266 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-473ce33a | this.Load | SSP0026_ShipmentRequestPack.cs:267 |  | FLAG | drPgmAuthId | dtPgmAuthId.Select().Where(c => c["CODE"].ToString() == "SSP0026" && c["NAME"].ToString() … | 화면 필드/플래그 변경 |  |  |  |
| AC-4b72cf1e | this.Load | SSP0026_ShipmentRequestPack.cs:267 |  | DATA_OP | dtPgmAuthId.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2fa1a0f1 | this.Load | SSP0026_ShipmentRequestPack.cs:269 |  | DATA_OP | Tmp_dtPlanDate.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-76dfc6ba | this.Load | SSP0026_ShipmentRequestPack.cs:278 | if (dr.ItemArray.Count() > 0) ▸ if (sPlanDate.Length == 10) | FLAG | sStartDay | sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-e2de9345 | this.Load | SSP0026_ShipmentRequestPack.cs:286 | if (dr.ItemArray.Count() > 0) ▸ if (sPlanDate.Length == 10) | FLAG | sFirstDay | sPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-6eef05b0 | this.Load | SSP0026_ShipmentRequestPack.cs:292 | if (dr.ItemArray.Count() > 0) ▸ if (sPlanDate.Length == 10) | FLAG | sConfirmDay | sPlanDate.Replace("-","") | 화면 필드/플래그 변경 |  |  |  |
| AC-e11d7806 | this.Load | SSP0026_ShipmentRequestPack.cs:298 | if (dr.ItemArray.Count() > 0) ▸ if (sPlanDate.Length == 10) | FLAG | sConfirmDay_cell | sPlanDate.Replace("-", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-32e65127 | this.Load | SSP0026_ShipmentRequestPack.cs:300 | if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod.Value1 | Convert.ToDateTime(sStartDay) | 속성 Value1 설정 |  |  |  |
| AC-c6dc986f | this.Load | SSP0026_ShipmentRequestPack.cs:301 | if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod.Value2 | Convert.ToDateTime(dr["TO_DATE"].ToString()) | 속성 Value2 설정 |  |  |  |
| AC-86d7a8eb | this.Load | SSP0026_ShipmentRequestPack.cs:302 | if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod2.Value1 | Convert.ToDateTime(dr["NAME"].ToString()) | 속성 Value1 설정 |  |  |  |
| AC-a0eecc46 | this.Load | SSP0026_ShipmentRequestPack.cs:303 | if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod2.Value2 | Convert.ToDateTime(dr["TO_DATE"].ToString()) | 속성 Value2 설정 |  |  |  |
| AC-dc66a5e7 | this.Load | SSP0026_ShipmentRequestPack.cs:306 |  | FLAG | dtMeasure | Data.Common(Data.Type.Measure) ⇒ biz:CommonData.CommonDataList [code=Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-fb6c4fcf | this.Load | SSP0026_ShipmentRequestPack.cs:306 |  | COMBO_DATA | Data.Common | (Data.Type.Measure) ⇒ biz:CommonData.CommonDataList [code=Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-31234c66 | this.Load | SSP0026_ShipmentRequestPack.cs:308 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7553784 | this.Load | SSP0026_ShipmentRequestPack.cs:309 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-12d70322 | this.Load | SSP0026_ShipmentRequestPack.cs:311 |  | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.InitSpread

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboDivision.SelectedIndexChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPack) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Measure)) ▸ if (sMeasure == "SHIP…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d05b22e2 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:386 | if (sSheetName == SpdSheet.shtRequestDetail) | GRID_INIT | siDetail.SetSheetHeaderColumn | (siDetail, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-01878b94 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:387 | if (sSheetName == SpdSheet.shtRequestDetail) | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-69c1b3db | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:388 | if (sSheetName == SpdSheet.shtRequestDetail) | GRID_INIT | siDetail.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-398579e4 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:392 | if (sSheetName == SpdSheet.shtRequestDetail) | GRID_SET | siDetail.ActiveSheet.Columns[DefColumns.STATUS].MergePolicy | MergePolicy.None | 그리드 속성/값 설정 |  |  |  |
| AC-b08560f3 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:398 | else of (sSheetName == SpdSheet.shtRequestDetail) ▸ if (sSheetName == SpdSheet.shtResultDetail) | GRID_INIT | siDetail.SetSheetHeaderColumn | (siDetail, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-6959aeff | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:405 | else of (sSheetName == SpdSheet.shtRequestDetail) ▸ else of (sSheetName == SpdSheet.shtResultDetail) ▸ if (sSheetName == SpdSheet.shtRequest… | GRID_INIT | siSub.InitSheet | (siSub.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-6f4e0ce4 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:407 | else of (sSheetName == SpdSheet.shtRequestDetail) ▸ else of (sSheetName == SpdSheet.shtResultDetail) ▸ if (sSheetName == SpdSheet.shtRequest… | GRID_INIT | siSub.SetSheetHeaderColumn | (siSub, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-29a1e07d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:409 | else of (sSheetName == SpdSheet.shtRequestDetail) ▸ else of (sSheetName == SpdSheet.shtResultDetail) ▸ if (sSheetName == SpdSheet.shtRequest… | GRID_INIT | siSub.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e828c7ef | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:413 | else of (sSheetName == SpdSheet.shtRequestDetail) ▸ else of (sSheetName == SpdSheet.shtResultDetail) ▸ else of (sSheetName == SpdSheet.shtRe… | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-ac93821c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:421 | else of (sSheetName == SpdSheet.shtRequestDetail) ▸ else of (sSheetName == SpdSheet.shtResultDetail) ▸ else of (sSheetName == SpdSheet.shtRe… | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d1ed787f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:425 | else of (sSheetName == SpdSheet.shtRequestDetail) ▸ else of (sSheetName == SpdSheet.shtResultDetail) ▸ else of (sSheetName == SpdSheet.shtRe… | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-35742ce3 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:433 | else of (sSheetName == SpdSheet.shtRequestDetail) ▸ else of (sSheetName == SpdSheet.shtResultDetail) ▸ else of (sSheetName == SpdSheet.shtRe… | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0026_ShipmentRequestPack.InitSpreadFooterSum

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c9b707a | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:443 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-4acc6cf9 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:444 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-51d15581 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:451 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf30fc3c | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:452 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-56371eed | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:453 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-3784da48 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:454 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.InitSpreadFooterSum_Detail

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (sSheetName == SpdSheet.shtRequestDetail)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (sSheetName == SpdSheet.shtRequestDetail)] / this.cboDivision.SelectedIndexChanged [if (siMain != null) ▸ if (sSheetName == SpdSheet.shtRequestDetail)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (sSheetName == SpdSheet.shtRequestDetail)] / this.Load [if (sSheetName == SpdSheet.shtRequestDetail)] / this.spdMain.CellDoubleClick [else of (siMain.ActiveSheet.S…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b373715a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:472 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-cbf7e80c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:473 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-786afa7a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:490 | for (iCol <= siDetail.GetMaxColumnIndex()) | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d108b01 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:491 | for (iCol <= siDetail.GetMaxColumnIndex()) | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d2310dbf | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:492 | for (iCol <= siDetail.GetMaxColumnIndex()) | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-bac0147c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:493 | for (iCol <= siDetail.GetMaxColumnIndex()) | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abbde072 | InsertButton | SSP0026_ShipmentRequestPack.cs:1962 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8320545d | InsertButton | SSP0026_ShipmentRequestPack.cs:1964 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), CString.GetCheckedList… | 그리드 값 설정 |  |  |  |
| AC-3777e7cd | InsertButton | SSP0026_ShipmentRequestPack.cs:1965 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FromSite), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1886d47b | InsertButton | SSP0026_ShipmentRequestPack.cs:1966 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ToSite), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-965eba7a | InsertButton | SSP0026_ShipmentRequestPack.cs:1967 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), "SHIP_REQ") | 그리드 값 설정 |  |  |  |
| AC-f2747704 | InsertButton | SSP0026_ShipmentRequestPack.cs:1968 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)].… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-fe3e722f | InsertButton | SSP0026_ShipmentRequestPack.cs:1976 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (siMain.Sheet(fps.ActiveSheet… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cc3985ca | InsertButton | SSP0026_ShipmentRequestPack.cs:1994 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (siMain.Sheet(fps.ActiveSheet… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId), siMain.ActiveRowIndex, s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-039ed032 | InsertButton | SSP0026_ShipmentRequestPack.cs:1995 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (siMain.Sheet(fps.ActiveSheet… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FromSite), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-391533d3 | InsertButton | SSP0026_ShipmentRequestPack.cs:1996 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (siMain.Sheet(fps.ActiveSheet… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ToSite), siMain.ActiveRowIndex, s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1a7c8934 | InsertButton | SSP0026_ShipmentRequestPack.cs:1997 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (siMain.Sheet(fps.ActiveSheet… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FcstType), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ea95f95 | InsertButton | SSP0026_ShipmentRequestPack.cs:1998 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (siMain.Sheet(fps.ActiveSheet… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TrMode), siMain.ActiveRowIndex, s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fa5b645a | InsertButton | SSP0026_ShipmentRequestPack.cs:1999 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (siMain.Sheet(fps.ActiveSheet… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Incoterms), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0afe442c | InsertButton | SSP0026_ShipmentRequestPack.cs:2008 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (siMain.Sheet(fps.ActiveSheet… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, j, siMain.ActiveRowIndex, j, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0e6df0ee | InsertButton | SSP0026_ShipmentRequestPack.cs:2013 | if (fps.Name == "spdMain") ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (siMain.Sheet(fps.ActiveSheet… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, j, siMain.ActiveRowIndex, j, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-297f3b8e | InsertButton | SSP0026_ShipmentRequestPack.cs:2026 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | DATA_OP | siDetail.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-df62eadd | InsertButton | SSP0026_ShipmentRequestPack.cs:2034 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | FLAG | dtPlantSite | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-f68050e9 | InsertButton | SSP0026_ShipmentRequestPack.cs:2034 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8e197833 | InsertButton | SSP0026_ShipmentRequestPack.cs:2035 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-79f26129 | InsertButton | SSP0026_ShipmentRequestPack.cs:2035 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d0b94ad6 | InsertButton | SSP0026_ShipmentRequestPack.cs:2039 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | FLAG | dtPlantSite | Data_SCP.Common(Data_SCP.Type.ShipmentRequestPlantSite, false, cboDivision.ControlValues, … | 화면 필드/플래그 변경 |  |  |  |
| AC-48498a54 | InsertButton | SSP0026_ShipmentRequestPack.cs:2039 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentRequestPlantSite, false, cboDivision.ControlValues, "P", "E") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9bc8a738 | InsertButton | SSP0026_ShipmentRequestPack.cs:2040 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-59029400 | InsertButton | SSP0026_ShipmentRequestPack.cs:2040 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-30baa70b | InsertButton | SSP0026_ShipmentRequestPack.cs:2043 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.ShipToCode), "-") | 그리드 값 설정 |  |  |  |
| AC-0bb5aea6 | InsertButton | SSP0026_ShipmentRequestPack.cs:2047 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.Division), CString.GetChecked… | 그리드 값 설정 |  |  |  |
| AC-a4876d02 | InsertButton | SSP0026_ShipmentRequestPack.cs:2049 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | GRID_COMBO | siDetail.SetCellTypeCombo | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.FromSite), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-82c13f75 | InsertButton | SSP0026_ShipmentRequestPack.cs:2050 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | GRID_COMBO | siDetail.SetCellTypeCombo | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.ToSite), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b32c7756 | InsertButton | SSP0026_ShipmentRequestPack.cs:2052 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | GRID_SET | siDetail.ActiveSheet.Cells[siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.Ite… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-b2ba036e | InsertButton | SSP0026_ShipmentRequestPack.cs:2054 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.Division), siDetail.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ed97d913 | InsertButton | SSP0026_ShipmentRequestPack.cs:2055 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.ShipToCode) + 2, siDetail.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-48a7fac1 | InsertButton | SSP0026_ShipmentRequestPack.cs:2056 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.NickName), siDetail.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2474d068 | InsertButton | SSP0026_ShipmentRequestPack.cs:2058 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.Requestor), siDetail.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b861982c | InsertButton | SSP0026_ShipmentRequestPack.cs:2059 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.FromSite) + 1, siDetail.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-39555159 | InsertButton | SSP0026_ShipmentRequestPack.cs:2060 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siD… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.REMARK) + 1, siDetail.ActiveSheet.ColumnCount… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0026_ShipmentRequestPack.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7918cda4 | OnShown | SSP0026_ShipmentRequestPack.cs:223 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.Re_Design

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ finally] / FindButton [finally] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2d638f5 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:4026 | if (siMain.GetMaxRowIndex() >= 0) ▸ if (siMain.ActiveSheetIndex == 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b59b13a3 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:4073 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (AddCnt > 0) ▸ if (siMain.ActiveSheetIndex == 1) | DATA_OP | siMain.GetBindingRow | (iRow) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4c09df48 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:4080 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (AddCnt > 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (ro != … | GRID_STYLE | siMain.SetBGColor | (iRow, iStartCol, iRow, AddCnt, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-5c07cbb1 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:4085 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (AddCnt > 0) ▸ else of (siMain.ActiveSheetIndex == 1) | DATA_OP | siMain.GetBindingRow | (iRow) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fd8673ba | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:4092 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (AddCnt > 0) ▸ else of (siMain.ActiveSheetIndex == 1) ▸ if (r… | GRID_STYLE | siMain.SetBGColor | (iRow, iStartCol, iRow, AddCnt, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-d067a670 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:4102 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sMeasure == "PACK_FP" \|\| sMeasure == "POSTP_PLAN" \|\| sMe… | GRID_STYLE | siMain.SetBGColor | (iRow, IndexBlueFrom, iRow, IndexBlueTo, Color.FromArgb(219, 229, 241)) | 그리드 표시 설정 |  |  |  |
| AC-9ce17c69 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:4106 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (sMeasure == "PACK_FP" \|\| sMeasure == "POSTP_PLAN" \|\… | GRID_STYLE | siMain.SetBGColor | (iRow, IndexMeasure, iRow, IndexMeasure, Color.FromArgb(255, 193, 158)) | 그리드 표시 설정 |  |  |  |
| AC-59d08e93 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0026_ShipmentRequestPack.cs:4110 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (sMeasure == "PACK_FP" \|\| sMeasure == "POSTP_PLAN" \|\… | GRID_STYLE | siMain.SetBGColor | (iRow, IndexMeasure, iRow, IndexMeasure, Color.FromArgb(228, 247, 186)) | 그리드 표시 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.SaveData

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bae5b185 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1403 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-531c4c33 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1407 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e589745f | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1413 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48260ac5 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1416 | try ▸ if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-c167f6db | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1416 | try ▸ if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21f49481 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1421 | try ▸ if (fps.Name == "spdMain") ▸ if (!fnValidation()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fbfc8231 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1422 | try ▸ if (fps.Name == "spdMain") ▸ if (!fnValidation()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d663af51 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1471 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | GRID_STYLE | siMain.SetBGColor2 | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-c7b9d5c2 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1472 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-52f26f7b | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1473 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc88e63c | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1502 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c9ca9726 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1508 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_SAVE_SHIP_REQ_PACK") ⇒ SSP.SSP0026_SAVE_SHIP_REQ_PACK | 엔드포인트 요청 생성 |  |  |  |
| AC-32259266 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1511 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f58e1248 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1513 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { re… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e598f46 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1517 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9007b2b1 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1519 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-c60606b8 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1520 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-92aa7736 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1521 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-f2a86490 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1522 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | sFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-74ac9064 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1523 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | sToSite | 행/컬럼 값 대입 |  |  |  |
| AC-20a856df | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1524 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-18d55db6 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1525 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-498198b6 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1526 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_fcst_type"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-fec470e7 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1527 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | sTransportMode | 행/컬럼 값 대입 |  |  |  |
| AC-99e6a5b1 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1528 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-19d5640c | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1529 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-90fb82d4 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1530 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-10c0f506 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1531 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-a9e19293 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1532 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c196a7cc | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1533 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-ab19dd29 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1535 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a134762a | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1535 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-ba5ae4eb | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1546 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b9916ab4 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1547 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-99914ade | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1549 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0… | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-de76b6cd | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1551 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-46e4e3d8 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1552 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0… | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bf344b45 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1562 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-271d11b4 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1563 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93d17e6a | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1568 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows… | MESSAGE | MessageHelper.GMessageBox | ("MSG00293", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c237c806 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1573 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-35ed749d | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1574 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows… | MESSAGE | MessageHelper.GMessageBox | ("MSG00042") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc8d579e | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1580 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_SAVE_SHIP_REQ_CELL") ⇒ SSP.SSP0026_SAVE_SHIP_REQ_CELL | 엔드포인트 요청 생성 |  |  |  |
| AC-25af1ee9 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1583 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5729ca67 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1585 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { re… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c2b14cf5 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1589 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8c850b20 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1591 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-0e8b3cbf | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1592 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-87f636e9 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1593 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-84b7a278 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1594 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | sFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-7d1d2b39 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1595 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | sToSite | 행/컬럼 값 대입 |  |  |  |
| AC-36203a4f | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1596 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-beda77c6 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1597 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-d73e30b2 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1598 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_fcst_type"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-95f2a52c | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1599 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | sTransportMode | 행/컬럼 값 대입 |  |  |  |
| AC-3f46df4b | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1600 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-5d28a40d | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1601 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-0e0d4088 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1602 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-dc611cdc | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1603 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-c4efa065 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1604 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_remark"] | sRemark | 행/컬럼 값 대입 |  |  |  |
| AC-2e1d675c | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1605 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f9676309 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1606 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-ef5b9bd5 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1608 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ec99c647 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1608 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-f6e7c635 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1619 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (t.Su… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2e39c965 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1620 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (t.Su… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-66d1f644 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1622 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (t.Su… | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3290482 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1624 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (t.Su… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-86dae33f | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1625 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (t.Su… | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5bea115b | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1635 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (t.Su… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-857f0664 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1636 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (t.Su… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee8ea36d | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1641 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (t.Su… | MESSAGE | MessageHelper.GMessageBox | ("MSG00293", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f8786362 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1646 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (t.Su… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-936007da | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1647 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) ▸ if (t.Su… | MESSAGE | MessageHelper.GMessageBox | ("MSG00042") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9590239 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1654 | try ▸ if (fps.Name == "spdMain") ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fcaaf216 | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1661 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9f8ac07c | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1662 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54c3352a | SaveButton [if (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1668 | finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0026_ShipmentRequestPack.SaveData_Detail

진입점: SaveButton [else of (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c05e1416 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1676 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f71417d2 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1680 | try | FLAG | siDetail | GetSheetInfo(spdDetail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-50d6d28c | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1684 | try ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf298b05 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1687 | try ▸ if (fps.Name == "spdDetail") | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-8d12610f | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1687 | try ▸ if (fps.Name == "spdDetail") ▸ if (!DataUtil.checkRequiredOfSpread(siDetail)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74d8218e | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1736 | try ▸ if (fps.Name == "spdDetail") ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ else of (DateTime.TryParse(siDetail.GetText(i, siDetail.… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-793458d9 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1737 | try ▸ if (fps.Name == "spdDetail") ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ else of (DateTime.TryParse(siDetail.GetText(i, siDetail.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd9d3bad | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1777 | try ▸ if (fps.Name == "spdDetail") | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b89fae4f | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1783 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK") ⇒ SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK | 엔드포인트 요청 생성 |  |  |  |
| AC-0029b19b | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1786 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f954be86 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1787 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { re… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c001690e | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1791 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-817c0c05 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1793 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-3bc3b31b | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1794 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-bc2e1e79 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1795 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-5033bb23 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1796 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_from_site"] | sFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-52134f64 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1797 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_to_site"] | sToSite | 행/컬럼 값 대입 |  |  |  |
| AC-21e53bd5 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1798 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_shipto_code"] | sShipToCode | 행/컬럼 값 대입 |  |  |  |
| AC-82c0f88b | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1799 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-90535e5a | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1800 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_transport_mode"] | sTransportMode | 행/컬럼 값 대입 |  |  |  |
| AC-fc7121a8 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1801 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_fcst_type"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-8b78fa5b | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1802 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-6e7d84c4 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1803 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-eb8c8a84 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1804 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-bbfe5235 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1805 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_remark"] | sRemark | 행/컬럼 값 대입 |  |  |  |
| AC-3aadf050 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1806 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_order_type_detail"] | sOrderTypeDetail | 행/컬럼 값 대입 |  |  |  |
| AC-908bc676 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1807 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["p_created_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-baaf3f13 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1808 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-3599990a | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1810 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a5bda548 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1810 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ l… | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-8832946d | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1821 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8075b746 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1833 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ i… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5944f337 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1838 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00293", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-74b9288e | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1843 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00323", new object[] { t.DataSet.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ff5a57d3 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1852 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (spdMain.ActiveSheetIndex == 0) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00042") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0fd8fc13 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1860 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL") ⇒ SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL | 엔드포인트 요청 생성 |  |  |  |
| AC-88bc8b82 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1863 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-dc91e0c4 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1864 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { re… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ef43b0c4 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1868 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-dc1e510e | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1870 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-9ac3f5f7 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1871 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-228172c1 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1872 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-b1707d70 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1873 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_from_site"] | sFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-931c0185 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1874 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_to_site"] | sToSite | 행/컬럼 값 대입 |  |  |  |
| AC-04712163 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1875 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_shipto_code"] | sShipToCode | 행/컬럼 값 대입 |  |  |  |
| AC-4f8901cd | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1876 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-dffb907d | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1877 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_transport_mode"] | sTransportMode | 행/컬럼 값 대입 |  |  |  |
| AC-82b895b6 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1878 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_fcst_type"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-24c89dd7 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1879 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-79e1bf80 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1880 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-af4a95a0 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1881 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-a2c0f253 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1882 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_remark"] | sRemark | 행/컬럼 값 대입 |  |  |  |
| AC-e0c550b5 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1883 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_order_type_detail"] | sOrderTypeDetail | 행/컬럼 값 대입 |  |  |  |
| AC-0c840afb | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1884 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["p_created_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2baaebf0 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1885 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-5b31d913 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1887 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a7b63744 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1887 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-722cefe9 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1897 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54ba9b6a | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1909 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-58a6d462 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1914 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00293", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dce825e7 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1923 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ else of (spdMain.ActiveSheetIndex == 0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00042") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4958b648 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1932 | try ▸ if (fps.Name == "spdDetail") ▸ else of (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-282372db | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1938 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-23b50a71 | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1939 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-972d4e3c | SaveButton [else of (fps.Name == "spdMain")] | SSP0026_ShipmentRequestPack.cs:1945 | finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0026_ShipmentRequestPack.Set_SumValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a9d13fb | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:1344 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa547b4a | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:1348 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-220564cf | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:1383 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_BOH_PLAN") \|\| measure.Equals("WH_BOH_REQ")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][iCol] | 그리드 속성/값 설정 |  |  |  |
| AC-00b2a75c | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:1388 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_BOH_PLAN") \|\| measure.Equals("WH_BOH_REQ")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][iCol] | 그리드 속성/값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.SetImageCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3340cc2f | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2202 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TrMode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.SetSaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-372e4ef4 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2773 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-83c67705 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2777 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3c64d471 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2778 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-14ccc51d | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2779 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Project] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-a2ff976a | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2780 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FromSite] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-1f8f5432 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2781 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ItemId] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-e3e661b0 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2782 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-44c93243 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2783 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-426ec310 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2784 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Measure] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-4ed326eb | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2785 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ToSite] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-c707c90b | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2786 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-1cc57e5e | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2787 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-77920b27 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2789 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-9fdfb6e4 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2790 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-16e8ee2b | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2794 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-06482ca4 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2795 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0026_ShipmentRequestPack.SetSpreadColumn

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (spdMain.ActiveSheetIndex == 0) ▸ if (siMain.GetMaxRowIndex() >= 0)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (sSheetName == SpdSheet.shtRequestDetail) ▸ else of (sSheetName == SpdSheet.shtResultDetail) ▸ else of (sSheetName == SpdSheet.shtRequestDetail_Excel) ▸ if (sSheetName == SpdSheet.shtPack) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboDivision.SelectedIndexChanged [if (siMain != null) ▸ else of (sSheetName == SpdSheet.shtRequestDetail) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-249a7a9f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 12 | SSP0026_ShipmentRequestPack.cs:2909 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-be603044 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 12 | SSP0026_ShipmentRequestPack.cs:2914 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-9080364f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 12 | SSP0026_ShipmentRequestPack.cs:2921 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0f96da0e | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 12 | SSP0026_ShipmentRequestPack.cs:2925 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-30880985 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 12 | SSP0026_ShipmentRequestPack.cs:2930 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-e8decdef | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 12 | SSP0026_ShipmentRequestPack.cs:2937 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9bab8046 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 12 | SSP0026_ShipmentRequestPack.cs:2941 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-69b3a68f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 12 | SSP0026_ShipmentRequestPack.cs:2960 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (!chkPastPeriod.Checked) ▸ else of (siMain.ActiveSheet.ColumnHeader.Cells[2, iCol].Value.ToStr… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkPastPeriod.Checked | 그리드 속성/값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.SetSpreadHeaderSpan

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ else of (sSheetName == SpdSheet.shtRequestDetail) ▸ else of (sSheetName == SpdSheet.shtResultDetail) ▸ else of (sSheetName == SpdSheet.shtRequestDetail_Excel) ▸ if (sSheetName == SpdSheet.shtPack) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (sSheetName == SpdSheet.shtRequestDetail) ▸ else of (sSheetName == SpdSheet.shtResultDetail) ▸ else of (sSheetName == SpdSheet.shtRequestDetail_Excel) ▸ if (sSheetName == SpdSheet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5be2a12a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:523 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-294eca61 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:531 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-31dd5a6e | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:542 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-9f230199 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:548 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-236886d9 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:549 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-18aff4ef | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:554 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-613f0597 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:555 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3c071f6 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:562 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-767895ea | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:563 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-07a83166 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:574 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf13006e | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:575 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e997e511 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:576 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc98db93 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:577 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dcacd5cb | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:579 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Requestor) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-788a1468 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 9 | SSP0026_ShipmentRequestPack.cs:581 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0026_ShipmentRequestPack.ShowCell

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ finally ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (siMain.ActiveSheetIndex == 1)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.SheetName == "Cell Biz") ▸ if (bEdit_Mode == false)] / FindButton [finally ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (siMain.ActiveSheetIndex == 1)] / EditButton [if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.SheetName == "Cell Biz") ▸ if (bEdit_Mode == false)] / S…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94ef4462 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 4 | SSP0026_ShipmentRequestPack.cs:4223 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (edit == true) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3ac53dcd | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 4 | SSP0026_ShipmentRequestPack.cs:4233 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (AddCnt > 0) ▸ if (siMain.ActiveSheetIndex == 1) | DATA_OP | siMain.GetBindingRow | (iRow) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0c999636 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 4 | SSP0026_ShipmentRequestPack.cs:4244 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (AddCnt > 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (ro != … | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, siMain.ActiveSheet.ColumnCount - 1, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1f56ea5b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 4 | SSP0026_ShipmentRequestPack.cs:4249 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (AddCnt > 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (ro != … | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-79e933d4 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 4 | SSP0026_ShipmentRequestPack.cs:4253 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (AddCnt > 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (ro != … | GRID_STYLE | siMain.SetBGColor | (iRow, iStartCol, iRow, AddCnt, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-0fa5a642 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 4 | SSP0026_ShipmentRequestPack.cs:4260 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sMeasure == "PACK_FP" \|\| sMeasure == "POSTP_PLAN" \|\| sMe… | GRID_STYLE | siMain.SetBGColor | (iRow, IndexBlueFrom, iRow, IndexBlueTo, Color.FromArgb(219, 229, 241)) | 그리드 표시 설정 |  |  |  |
| AC-9269344e | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 4 | SSP0026_ShipmentRequestPack.cs:4264 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (sMeasure == "PACK_FP" \|\| sMeasure == "POSTP_PLAN" \|\… | GRID_STYLE | siMain.SetBGColor | (iRow, IndexMeasure, iRow, IndexMeasure, Color.FromArgb(255, 193, 158)) | 그리드 표시 설정 |  |  |  |
| AC-f934d00c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 4 | SSP0026_ShipmentRequestPack.cs:4268 | if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (sMeasure == "PACK_FP" \|\| sMeasure == "POSTP_PLAN" \|\… | GRID_STYLE | siMain.SetBGColor | (iRow, IndexMeasure, iRow, IndexMeasure, Color.FromArgb(228, 247, 186)) | 그리드 표시 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.SpdDetail_ActiveSheetChanged

진입점: this.spdDetail.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b94449a9 | this.spdDetail.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3642 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Result Detail") | UI_PROP | layoutControlItem25.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b74bbc44 | this.spdDetail.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3643 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Result Detail") | UI_PROP | layoutControlItem26.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-287f6c07 | this.spdDetail.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3644 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Result Detail") | UI_PROP | layoutControlItem28.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-255998a9 | this.spdDetail.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3645 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Result Detail") | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-174ff6b6 | this.spdDetail.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3652 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Result Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)send… | UI_PROP | layoutControlItem25.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e546fb13 | this.spdDetail.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3653 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Result Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)send… | UI_PROP | layoutControlItem26.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ceff5489 | this.spdDetail.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3654 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Result Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)send… | UI_PROP | layoutControlItem28.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1d869dac | this.spdDetail.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3655 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Result Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)send… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.SpdDetail_CellDoubleClick

진입점: this.spdDetail.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3d151b9 | this.spdDetail.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3228 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ItemId)) ▸ if (string.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fc741ce6 | this.spdDetail.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3230 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ItemId)) ▸ if (string.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-045d634d | this.spdDetail.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3235 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ItemId)) ▸ if (string.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2cc6cf0d | this.spdDetail.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3237 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ItemId)) ▸ if (string.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d42dbadb | this.spdDetail.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3252 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ItemId)) ▸ if ((sFromS… | POPUP | new SSP0026_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0ff7582a | this.spdDetail.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3254 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ItemId)) ▸ if ((sFromS… | POPUP | popItem.Form_Load | (true, sdivision, sFromSite, "", sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-5508c0e2 | this.spdDetail.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3255 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ItemId)) ▸ if ((sFromS… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-21149151 | this.spdDetail.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3256 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ItemId)) ▸ if ((sFromS… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6826d67a | this.spdDetail.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3262 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ItemId)) ▸ if ((sFromS… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.ItemId), sItemId) | 그리드 값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.SpdDetail_ClipboardPasted

진입점: this.spdDetail.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab9dde7c | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3417 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee9ebcba | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3419 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e06fce18 | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3424 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-24f65757 | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3426 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f41fb44c | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3442 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | POPUP | new SSP0026_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5b2ac09c | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3444 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | POPUP | popItem.Form_Load | (true, sdivision, sFromSite, "", sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-03f7a98d | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3445 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e1029aae | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3446 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-37424127 | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3452 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.ItemId), sItemId) | 그리드 값 설정 |  |  |  |
| AC-42d63d63 | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3464 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | FLAG | dtShipToCode | Data.Common(Data.Type.ShipToCodeByDivision, false, cboDivision.ControlValues, sToSite, "",… ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-117abef8 | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3464 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | COMBO_DATA | Data.Common | (Data.Type.ShipToCodeByDivision, false, cboDivision.ControlValues, sToSite, "", "", "") ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-575d44bd | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3466 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_COMBO | siDetail.SetCellTypeCombo | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.ShipToCode), dtShipToCode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a4a3d78c | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3477 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fa8c7930 | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3479 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33aaa3d6 | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3482 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | FLAG | dtShipToCode | Data.Common(Data.Type.ShipToCodeByDivision, false, cboDivision.ControlValues, sToSite, "",… ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-d4b8ac44 | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3482 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | COMBO_DATA | Data.Common | (Data.Type.ShipToCodeByDivision, false, cboDivision.ControlValues, sToSite, "", "", "") ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e291bda9 | this.spdDetail.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3484 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_COMBO | siDetail.SetCellTypeCombo | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.ShipToCode), dtShipToCode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.SpdDetail_ComboSelChange

진입점: this.spdDetail.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b60f6686 | this.spdDetail.ComboSelChange | SSP0026_ShipmentRequestPack.cs:3184 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.FromSite)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ToSite)) ▸ if (strin… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54f8b39c | this.spdDetail.ComboSelChange | SSP0026_ShipmentRequestPack.cs:3186 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.FromSite)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ToSite)) ▸ if (strin… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e10dd2d9 | this.spdDetail.ComboSelChange | SSP0026_ShipmentRequestPack.cs:3191 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.FromSite)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ToSite)) | FLAG | dtShipToCode | Data.Common(Data.Type.ShipToCodeByDivision, false, cboDivision.ControlValues, sToSite, "",… ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-a16cd902 | this.spdDetail.ComboSelChange | SSP0026_ShipmentRequestPack.cs:3191 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.FromSite)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ToSite)) | COMBO_DATA | Data.Common | (Data.Type.ShipToCodeByDivision, false, cboDivision.ControlValues, sToSite, "", "", "") ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-177bb92c | this.spdDetail.ComboSelChange | SSP0026_ShipmentRequestPack.cs:3193 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.FromSite)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ToSite)) | GRID_COMBO | siDetail.SetCellTypeCombo | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.ShipToCode), dtShipToCode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdfaef62 | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3583 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") | FLAG | dtPlantSite | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-653aac8e | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3583 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, cboDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-552a96fd | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3584 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-44733b9e | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3587 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7c3ead08 | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3588 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-857286b0 | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3590 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") | UI_PROP | this.splitContainer1.Panel2Collapsed | false | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-01bf1aeb | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3592 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") | GRID_SET | siDetail.ActiveSheet.Columns[siDetail.GetColumnIndex(DefColumns.ShipToCode)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-13d16053 | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3593 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") | GRID_SET | siDetail.ActiveSheet.Columns[siDetail.GetColumnIndex(DefColumns.ShipToCode) + 1].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-351ac9f7 | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3594 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") | GRID_SET | siDetail.ActiveSheet.Columns[siDetail.GetColumnIndex(DefColumns.ORDER_TYPE_DETAIL)].Visibl… | true | 그리드 속성/값 설정 |  |  |  |
| AC-2d97aa29 | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3595 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") | GRID_SET | siDetail.ActiveSheet.Columns[siDetail.GetColumnIndex(DefColumns.FcstType)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5347d9bd | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3600 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPack) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a97ec42f | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3604 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") ▸ if (siDetail.Sheet("Shipment Result Detail") == null) | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtResultDetail, SpdSheet.shtResultDetail, 1, 1, 60) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4c309eb4 | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3605 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") ▸ if (siDetail.Sheet("Shipment Result Detail") == null) | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtResultDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-3520c50d | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3613 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveShee… | FLAG | dtPlantSite | Data_SCP.Common(Data_SCP.Type.ShipmentRequestPlantSite, false, cboDivision.ControlValues, … | 화면 필드/플래그 변경 |  |  |  |
| AC-dc560f3e | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3613 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveShee… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentRequestPlantSite, false, cboDivision.ControlValues, "P", "E") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ab664ce9 | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3615 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveShee… | DATA_OP | dtPlantSite.Rows.RemoveAt | (0) | 데이터 객체 조작/조회 |  |  |  |
| AC-15c1efd7 | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3617 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveShee… | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5cb09bac | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3620 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveShee… | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-068a5d6b | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3621 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveShee… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4777d2b5 | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3623 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveShee… | UI_PROP | this.splitContainer1.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-5208e4e5 | this.spdMain.ActiveSheetChanged | SSP0026_ShipmentRequestPack.cs:3629 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Pack Biz") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveShee… | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtCell) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0026_ShipmentRequestPack.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1dcf3bd5 | this.spdMain.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3688 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) ▸ if (string.IsNullOrEmpty… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39620a23 | this.spdMain.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3690 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) ▸ if (string.IsNullOrEmpty… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ad66525 | this.spdMain.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3695 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) ▸ if (string.IsNullOrEmpty… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3abd34d8 | this.spdMain.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3697 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) ▸ if (string.IsNullOrEmpty… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3856066c | this.spdMain.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3704 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) ▸ if ((sFromSite != "" && … | POPUP | new SSP0026_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b4bf6080 | this.spdMain.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3706 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) ▸ if ((sFromSite != "" && … | POPUP | popItem.Form_Load | (true, sdivision, sFromSite, "", sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c2a9475a | this.spdMain.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3707 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) ▸ if ((sFromSite != "" && … | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-173dc52b | this.spdMain.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3708 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) ▸ if ((sFromSite != "" && … | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-45b09455 | this.spdMain.CellDoubleClick | SSP0026_ShipmentRequestPack.cs:3714 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId)) ▸ if ((sFromSite != "" && … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ItemId), sItemId) | 그리드 값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.spdMain_Changed

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74898495 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2210 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0d4af9f | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2245 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Division ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3a92f5e5 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2247 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-5ee24731 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2249 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac6405c8 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2253 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Project Code" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1c643407 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2255 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-34917a31 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2257 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c54f9df8 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2261 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Sales Site ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7b0b9b59 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2263 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-4c78ef9b | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2265 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94273dae | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2269 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Item ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39fa6572 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2271 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-e3c98e51 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2273 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5c1fe6a | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2277 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "FCST Type" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1199daa3 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2279 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-f9edd11a | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2281 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ee825e0 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2285 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Incoterms" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6ded7e5 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2287 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-d83e5b42 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2289 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f479860 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2293 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f3fda57 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2295 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-a2f9abe8 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2297 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc6fb381 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2301 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plant Site ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d389a0e5 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2303 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-2595844f | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2305 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9060f764 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2332 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 2, iWeeklySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b2e015d5 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2355 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-8d5cbe72 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2369 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.ActiveSheet.SetText | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-087a90eb | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2435 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-1b2e833f | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2443 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b1b81fda | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2458 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-3bf1b341 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2466 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-bd51984c | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2488 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-5ca17984 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2499 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | COMBO_DATA | Data.Common | (Data.Type.DefaultBucketDay, false, sDivision, sBucketType) ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-20b0fbf4 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2513 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-e7b73d9e | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2523 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iSetCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-24066582 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2551 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-e75c9f58 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2561 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | COMBO_DATA | Data.Common | (Data.Type.DefaultBucketDay, false, sDivision, sBucketType) ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e40df48a | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2642 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-6bdffb2e | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2650 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-56fe92c1 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2664 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-2cbc023d | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2672 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-e54c4399 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2689 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-eff280c9 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2719 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-e64edf34 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2724 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-fe70580c | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2750 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iWeekCol, iWeeklySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8b8cf86 | this.spdMain.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3298 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ for (iRow < e.CellRange.Row + e.Cell… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d46400e | this.spdMain.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3300 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ for (iRow < e.CellRange.Row + e.Cell… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e69511c2 | this.spdMain.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3305 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ for (iRow < e.CellRange.Row + e.Cell… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c098d19 | this.spdMain.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3307 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ for (iRow < e.CellRange.Row + e.Cell… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96e23ec7 | this.spdMain.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3323 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ for (iRow < e.CellRange.Row + e.Cell… | POPUP | new SSP0026_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8947901c | this.spdMain.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3325 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ for (iRow < e.CellRange.Row + e.Cell… | POPUP | popItem.Form_Load | (true, sdivision, sFromSite, "", sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-65b0855b | this.spdMain.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3326 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ for (iRow < e.CellRange.Row + e.Cell… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-159af954 | this.spdMain.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3327 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ for (iRow < e.CellRange.Row + e.Cell… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f82fd2f9 | this.spdMain.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3333 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ItemId), sItemId) | 그리드 값 설정 |  |  |  |
| AC-8a989e5e | this.spdMain.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3359 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ for (iRow < e.CellRange.Row + e.Cell… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b069c4a6 | this.spdMain.ClipboardPasted | SSP0026_ShipmentRequestPack.cs:3361 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtCell) ▸ for (iRow < e.CellRange.Row + e.Cell… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0026_ShipmentRequestPack.spdMain_ComboSelChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b426d335 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2145 | if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-47ee507c | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2145 | if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4414906 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2146 | if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FromSite), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6a2f7090 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2150 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-d3858fb1 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2154 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), "") | 그리드 값 설정 |  |  |  |
| AC-7c492812 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2159 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), "") | 그리드 값 설정 |  |  |  |
| AC-31fa50e8 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2164 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizType), "") | 그리드 값 설정 |  |  |  |
| AC-0eecc687 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2169 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-405fa121 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2174 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-babf17ce | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2182 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-6abf4373 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2182 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-86a6d41c | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2183 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SSP0026_ShipmentRequestPack.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee8e5212 | this.spdMain.ComboSelChange | SSP0026_ShipmentRequestPack.cs:3144 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ToSite)) ▸ if (string.Is… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-161d8692 | this.spdMain.ComboSelChange | SSP0026_ShipmentRequestPack.cs:3146 | else of (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ToSite)) ▸ if (string.Is… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0026_ShipmentRequestPack.spdMain_KeyUp

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2327c717 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2816 | if (siMain.GetColumnIndex(DefColumns.Requestor) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b3505fbd | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2820 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32fc8b6e | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2825 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-465052f9 | (진입점 미연결) | SSP0026_ShipmentRequestPack.cs:2826 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0026_ShipmentRequestPack.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42f62fd1 | this.spdMain.TopChange | SSP0026_ShipmentRequestPack.cs:2803 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |


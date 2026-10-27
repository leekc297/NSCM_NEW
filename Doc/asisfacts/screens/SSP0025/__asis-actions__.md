# AS-IS 액션 대조표 — SSP0025

> 원천: `Doc/asisfacts/screens/SSP0025/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 281행 · 메서드 32 · 종류 FLAG 70 · UI_PROP 29 · DATA_OP 28 · GRID_SET 22 · GRID_INIT 21 · POPUP 19 · RETURN 17 · GRID_LOCK 14 · UI_MISC 13 · ENDPOINT 13 · VALUE_SET 7 · LIST_REBIND 6 · MESSAGE 6 · COMBO_DATA 4 · VALIDATE 3 · GRID_COMBO 3 · GRID_BIND 2 · STATE 2 · CALL_EXT 2 · ⚠ 의미 확인 필요 2


## SSP0025_ItembyDivisionPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69d887d9 | this.btnButtonList.UsrButtonList_Click_Detected | SSP0025_ItembyDivisionPopup.cs:346 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-4198ccc1 | this.btnButtonList.UsrButtonList_Click_Detected | SSP0025_ItembyDivisionPopup.cs:349 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0025_ItembyDivisionPopup.clbDivision_SelectedIndexChanged

진입점: this.clbDivisionId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2d8d46e | this.clbDivisionId.SelectedIndexChanged | SSP0025_ItembyDivisionPopup.cs:357 |  | FLAG | dtFromSiteCode | Data.Common(Data.Type.FromSiteByAssembly, false, sDivisionId, "") ⇒ biz:CommonData.CommonDataList [code=FromSiteByAssembly] | 화면 필드/플래그 변경 |  |  |  |
| AC-cb7c00de | this.clbDivisionId.SelectedIndexChanged | SSP0025_ItembyDivisionPopup.cs:357 |  | COMBO_DATA | Data.Common | (Data.Type.FromSiteByAssembly, false, sDivisionId, "") ⇒ biz:CommonData.CommonDataList [code=FromSiteByAssembly] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-864adaa2 | this.clbDivisionId.SelectedIndexChanged | SSP0025_ItembyDivisionPopup.cs:358 |  | DATA_OP | dtFromSiteCode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0e168e24 | this.clbDivisionId.SelectedIndexChanged | SSP0025_ItembyDivisionPopup.cs:361 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSiteCode, clbFromSiteId, false) | 목록 컨트롤 재구성 |  |  |  |

## SSP0025_ItembyDivisionPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6b11594 | this.Load | SSP0025_ItembyDivisionPopup.cs:231 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2bf81c4f | this.Load | SSP0025_ItembyDivisionPopup.cs:232 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2f92100a | this.Load | SSP0025_ItembyDivisionPopup.cs:233 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0025_ItembyDivisionPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb7b112c | this.Load | SSP0025_ItembyDivisionPopup.cs:226 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0025_ItembyDivisionPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35a166f5 | Dispose | SSP0025_ItembyDivisionPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0025_ItembyDivisionPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c67691d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:292 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1cc12388 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:296 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP") ⇒ SSP.SSP0025_GET_ITEM_BY_DIVISION_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-449b5187 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:297 | lambda | DATA_OP | request.Parameters["p_division_id"] | (clbDivisionId.ControlValues == "ALL") ? "" : clbDivisionId.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-a1fbfd67 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:298 | lambda | DATA_OP | request.Parameters["p_from_site_id"] | (clbFromSiteId.ControlValues == "ALL") ? "" : clbFromSiteId.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7ffd410f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:299 | lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-7ada5c40 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:300 | lambda | DATA_OP | request.Parameters["p_model_id"] | txtModelId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-8ba95ee0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:301 | lambda | DATA_OP | request.Parameters["p_to_site_id"] | (sPlantSiteCode == "ALL") ? "" : sPlantSiteCode | 행/컬럼 값 대입 |  |  |  |
| AC-fe942ef1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:302 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e3524bbb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:304 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a7ded5bf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:308 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f94808a9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:309 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-54f9fefd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:313 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-86b0047a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:317 | if (ds.Tables[0].Rows.Count == 1) | FLAG | divisionId | this.dtFindData.Rows[0][DefColumns.Division].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-88cd3547 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:318 | if (ds.Tables[0].Rows.Count == 1) | FLAG | fromSiteCode | this.dtFindData.Rows[0][DefColumns.FromSiteCode].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2cf4e470 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:319 | if (ds.Tables[0].Rows.Count == 1) | FLAG | fromSite | this.dtFindData.Rows[0][DefColumns.FromSite].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-42beb08c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:320 | if (ds.Tables[0].Rows.Count == 1) | FLAG | itemId | this.dtFindData.Rows[0][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2bbe4c5b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:321 | if (ds.Tables[0].Rows.Count == 1) | FLAG | modelId | this.dtFindData.Rows[0][DefColumns.ModelId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b447fb74 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:322 | if (ds.Tables[0].Rows.Count == 1) | FLAG | cellType | this.dtFindData.Rows[0][DefColumns.CellType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a6b8c2da | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:323 | if (ds.Tables[0].Rows.Count == 1) | FLAG | nickName | this.dtFindData.Rows[0][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8451ea71 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:324 | if (ds.Tables[0].Rows.Count == 1) | FLAG | electrodeType | this.dtFindData.Rows[0][DefColumns.ElectrodeType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-febec5a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:325 | if (ds.Tables[0].Rows.Count == 1) | FLAG | itemUOM | this.dtFindData.Rows[0][DefColumns.ItemUOM].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-693301e2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:326 | if (ds.Tables[0].Rows.Count == 1) | FLAG | uomConvertInTactTime | this.dtFindData.Rows[0][DefColumns.UomConvertInTactTime].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-30c50e12 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:327 | if (ds.Tables[0].Rows.Count == 1) | FLAG | toDivisionId | this.dtFindData.Rows[0][DefColumns.ToDivision].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9b97aa8d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:328 | if (ds.Tables[0].Rows.Count == 1) | FLAG | toSiteCode | this.dtFindData.Rows[0][DefColumns.ToSiteCode].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1c444fc3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:329 | if (ds.Tables[0].Rows.Count == 1) | FLAG | toSite | this.dtFindData.Rows[0][DefColumns.ToSite].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-709f6566 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:331 | if (ds.Tables[0].Rows.Count == 1) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0025_ItembyDivisionPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af78ea28 | this.Load | SSP0025_ItembyDivisionPopup.cs:177 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0736f0a1 | this.Load | SSP0025_ItembyDivisionPopup.cs:178 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-295a17c3 | this.Load | SSP0025_ItembyDivisionPopup.cs:186 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-0fdf7f77 | this.Load | SSP0025_ItembyDivisionPopup.cs:187 |  | FLAG | sDivisionId | _DivisionId | 화면 필드/플래그 변경 |  |  |  |
| AC-bbb08d2d | this.Load | SSP0025_ItembyDivisionPopup.cs:188 |  | FLAG | sPlantSiteCode | (_PlantSiteCode == "ALL" ? "" : _PlantSiteCode) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff95adc5 | this.Load | SSP0025_ItembyDivisionPopup.cs:189 |  | FLAG | sItemId | _ItemId | 화면 필드/플래그 변경 |  |  |  |
| AC-23eecc72 | this.Load | SSP0025_ItembyDivisionPopup.cs:190 |  | FLAG | sModelId | _ModelId | 화면 필드/플래그 변경 |  |  |  |
| AC-8d77b833 | this.Load | SSP0025_ItembyDivisionPopup.cs:191 |  | FLAG | sBtnType | _BtnType | 화면 필드/플래그 변경 |  |  |  |

## SSP0025_ItembyDivisionPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84c129e2 | this.Load | SSP0025_ItembyDivisionPopup.cs:198 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivisionId, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5bc356e0 | this.Load | SSP0025_ItembyDivisionPopup.cs:199 |  | VALUE_SET | clbDivisionId.ControlValues | sDivisionId | 컨트롤 값 설정 |  |  |  |
| AC-cc103a88 | this.Load | SSP0025_ItembyDivisionPopup.cs:200 |  | VALUE_SET | clbFromSiteId.ControlValues | sPlantSiteCode | 컨트롤 값 설정 |  |  |  |
| AC-bd747423 | this.Load | SSP0025_ItembyDivisionPopup.cs:201 |  | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |
| AC-f7133295 | this.Load | SSP0025_ItembyDivisionPopup.cs:202 |  | VALUE_SET | txtModelId.Text | sModelId | 컨트롤 값 설정 |  |  |  |
| AC-20c7f232 | this.Load | SSP0025_ItembyDivisionPopup.cs:204 |  | STATE | clbDivisionId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8ea3209b | this.Load | SSP0025_ItembyDivisionPopup.cs:205 |  | STATE | clbFromSiteId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1c3027c8 | this.Load | SSP0025_ItembyDivisionPopup.cs:206 |  | FLAG | dtFromSiteCode | Data.Common(Data.Type.FromSiteByAssembly, false, sDivisionId, sPlantSiteCode) ⇒ biz:CommonData.CommonDataList [code=FromSiteByAssembly] | 화면 필드/플래그 변경 |  |  |  |
| AC-39d09c03 | this.Load | SSP0025_ItembyDivisionPopup.cs:206 |  | COMBO_DATA | Data.Common | (Data.Type.FromSiteByAssembly, false, sDivisionId, sPlantSiteCode) ⇒ biz:CommonData.CommonDataList [code=FromSiteByAssembly] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-339a57d6 | this.Load | SSP0025_ItembyDivisionPopup.cs:209 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSiteCode, clbFromSiteId, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b0fee50e | this.Load | SSP0025_ItembyDivisionPopup.cs:212 | if (dtFromSiteCode.Rows.Count == 1) | VALUE_SET | clbFromSiteId.ControlValues | dtFromSiteCode.Rows[0][0].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-190c7ad3 | this.Load | SSP0025_ItembyDivisionPopup.cs:216 | if ((PopupType.POPUP_ITEM).Equals(sBtnType)) | UI_PROP | lbModelId.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2472cee1 | this.Load | SSP0025_ItembyDivisionPopup.cs:220 | else of ((PopupType.POPUP_ITEM).Equals(sBtnType)) | UI_PROP | lbItemId.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0025_ItembyDivisionPopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9c69551 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:240 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-fde3d80b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:242 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1d69479f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:243 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DivisionName, DefColumns.Division, FPMerge.None, 60, true ,FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d516c0c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:244 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DivisionName, DefColumns.DivisionName , FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ffa714f6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:245 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.FromSiteCode, DefColumns.FromSiteCode , FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a365ee80 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:246 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.FromSite , DefColumns.FromSite , FPMerge.None, 150, true, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c94b037 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:247 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ItemId , DefColumns.ItemId , FPMerge.None, 100, true, FPHAlign.Center, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e57fb38 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:248 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ModelId , DefColumns.ModelId , FPMerge.None, 100, true, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cc0edd2f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:249 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.CellType , DefColumns.CellType, FPMerge.None, 80, true, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d30e4b4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:250 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.NickName , DefColumns.NickName, FPMerge.None, 100, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6d68996 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:251 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ElectrodeType, DefColumns.ElectrodeType , FPMerge.None, 80, true, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b1e4175b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:252 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ITEM_UOM , DefColumns.ItemUOM , FPMerge.None, 60 , true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4e0379b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0025_ItembyDivisionPopup.cs:253 |  | CALL_EXT | siMain.AddNumColumnEx | (DefColumnsLabel.UomConvertInTactTime, DefColumns.UomConvertInTactTime, FPMerge.None, 120,… | ⚠ 의미 확인 필요 |  |  |  |

## SSP0025_ItembyDivisionPopup.SetMaterial

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50d8a09f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:374 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52bb9672 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:376 |  | FLAG | itemId | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fa84f0be | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:390 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | divisionId | this.dtFindData.Rows[iRow][DefColumns.Division].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2325c635 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:391 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | fromSiteCode | this.dtFindData.Rows[iRow][DefColumns.FromSiteCode].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cf1c9a42 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:392 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | fromSite | this.dtFindData.Rows[iRow][DefColumns.FromSite].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d2775f86 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:393 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemId | this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-31c918fc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:394 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | modelId | this.dtFindData.Rows[iRow][DefColumns.ModelId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-61977555 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:395 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | cellType | this.dtFindData.Rows[iRow][DefColumns.CellType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-229bc98e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:396 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-20a3eb2a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:397 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | electrodeType | this.dtFindData.Rows[iRow][DefColumns.ElectrodeType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-423628ef | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:398 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemUOM | this.dtFindData.Rows[iRow][DefColumns.ItemUOM].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7acf0366 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:399 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | uomConvertInTactTime | this.dtFindData.Rows[iRow][DefColumns.UomConvertInTactTime].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9bbd959c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:400 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | toDivisionId | this.dtFindData.Rows[iRow][DefColumns.ToDivision].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-15d47a10 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:401 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | toSiteCode | this.dtFindData.Rows[iRow][DefColumns.ToSiteCode].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8e73dc53 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:402 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | toSite | this.dtFindData.Rows[iRow][DefColumns.ToSite].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1bd1f9c4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:406 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | divisionId | divisionId + "," + this.dtFindData.Rows[iRow][DefColumns.Division].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-47b1495a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:407 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | fromSiteCode | fromSiteCode + "," + this.dtFindData.Rows[iRow][DefColumns.FromSiteCode].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e7284a1b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:408 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | fromSite | fromSite + "," + this.dtFindData.Rows[iRow][DefColumns.FromSite].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-69dd3c71 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:409 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemId | itemId + "," + this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-09d83b83 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:410 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | modelId | modelId + "," + this.dtFindData.Rows[iRow][DefColumns.ModelId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5ebb435f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:411 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | cellType | cellType + "," + this.dtFindData.Rows[iRow][DefColumns.CellType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-908bfc0c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:412 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | nickName + "," + this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-15ee208b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:413 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | electrodeType | electrodeType + "," + this.dtFindData.Rows[iRow][DefColumns.ElectrodeType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6b1539bc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:414 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemUOM | itemUOM + "," + this.dtFindData.Rows[iRow][DefColumns.ItemUOM].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fba5a203 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:415 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | uomConvertInTactTime | uomConvertInTactTime + "," + this.dtFindData.Rows[iRow][DefColumns.UomConvertInTactTime].T… | 화면 필드/플래그 변경 |  |  |  |
| AC-520bbc16 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:416 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | toDivisionId | divisionId + "," + this.dtFindData.Rows[iRow][DefColumns.ToDivision].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ade0ed33 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:417 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | toSiteCode | fromSiteCode + "," + this.dtFindData.Rows[iRow][DefColumns.ToSiteCode].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-085a7af5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:418 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | toSite | fromSite + "," + this.dtFindData.Rows[iRow][DefColumns.ToSite].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a46cd549 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:425 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88adc58e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:430 | else of (bMulltiSelect) | FLAG | divisionId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)) | 화면 필드/플래그 변경 |  |  |  |
| AC-17c02385 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:431 | else of (bMulltiSelect) | FLAG | fromSiteCode | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FromSiteCode)) | 화면 필드/플래그 변경 |  |  |  |
| AC-8eed0a48 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:432 | else of (bMulltiSelect) | FLAG | fromSite | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FromSite)) | 화면 필드/플래그 변경 |  |  |  |
| AC-aab4f9c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:433 | else of (bMulltiSelect) | FLAG | itemId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-0102dcdc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:434 | else of (bMulltiSelect) | FLAG | modelId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ModelId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4ac45f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:435 | else of (bMulltiSelect) | FLAG | cellType | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CellType)) | 화면 필드/플래그 변경 |  |  |  |
| AC-7c4fda18 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:436 | else of (bMulltiSelect) | FLAG | nickName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NickName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-a34bca95 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:437 | else of (bMulltiSelect) | FLAG | electrodeType | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ElectrodeType)) | 화면 필드/플래그 변경 |  |  |  |
| AC-e09fd55b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:438 | else of (bMulltiSelect) | FLAG | itemUOM | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemUOM)) | 화면 필드/플래그 변경 |  |  |  |
| AC-944943e2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:439 | else of (bMulltiSelect) | FLAG | uomConvertInTactTime | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.UomConvertInTactTim… | 화면 필드/플래그 변경 |  |  |  |
| AC-6e1b4fa1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:440 | else of (bMulltiSelect) | FLAG | toDivisionId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ToDivision)) | 화면 필드/플래그 변경 |  |  |  |
| AC-61e6b111 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:441 | else of (bMulltiSelect) | FLAG | toSiteCode | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ToSiteCode)) | 화면 필드/플래그 변경 |  |  |  |
| AC-47d88f4c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0025_ItembyDivisionPopup.cs:442 | else of (bMulltiSelect) | FLAG | toSite | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ToSite)) | 화면 필드/플래그 변경 |  |  |  |

## SSP0025_ItembyDivisionPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe44920f | this.spdMain.CellDoubleClick | SSP0025_ItembyDivisionPopup.cs:367 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0025_ShipmentRequestorPIC.btnItemId_Click

진입점: btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6d3016a | btnItemId.Click | SSP0025_ShipmentRequestorPIC.cs:710 |  | POPUP | new SSP0025_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2a24a73d | btnItemId.Click | SSP0025_ShipmentRequestorPIC.cs:712 |  | POPUP | popItem.Form_Load | (true, sDivision, sToSite, sItemId,"" , PopupType.POPUP_ITEM) | 팝업 초기화(인자 전달) |  |  |  |
| AC-7c8336c8 | btnItemId.Click | SSP0025_ShipmentRequestorPIC.cs:713 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2f6ffe88 | btnItemId.Click | SSP0025_ShipmentRequestorPIC.cs:714 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3c19f85e | btnItemId.Click | SSP0025_ShipmentRequestorPIC.cs:718 | if (popItem.ItemId != "") | VALUE_SET | txtItemId.Text | popItem.ItemId | 컨트롤 값 설정 |  |  |  |

## SSP0025_ShipmentRequestorPIC.btnModelId_Click

진입점: btnModelId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9c640a5 | btnModelId.Click | SSP0025_ShipmentRequestorPIC.cs:728 |  | POPUP | new SSP0025_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-92312e55 | btnModelId.Click | SSP0025_ShipmentRequestorPIC.cs:730 |  | POPUP | popItem.Form_Load | (true, sDivision, sToSite, "", sModelId, PopupType.POPUP_MODEL) | 팝업 초기화(인자 전달) |  |  |  |
| AC-682fc2a3 | btnModelId.Click | SSP0025_ShipmentRequestorPIC.cs:731 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9e7ac6c4 | btnModelId.Click | SSP0025_ShipmentRequestorPIC.cs:732 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-50b8a790 | btnModelId.Click | SSP0025_ShipmentRequestorPIC.cs:736 | if (popItem.ModelId != "") | VALUE_SET | txtModelId.Text | popItem.ModelId | 컨트롤 값 설정 |  |  |  |

## SSP0025_ShipmentRequestorPIC.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3758ac4 | this.Load | SSP0025_ShipmentRequestorPIC.cs:146 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1f62c4e5 | this.Load | SSP0025_ShipmentRequestorPIC.cs:147 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-ba209687 | this.Load | SSP0025_ShipmentRequestorPIC.cs:149 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0025_ShipmentRequestorPIC.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5daf36e6 | this.Load | SSP0025_ShipmentRequestorPIC.cs:119 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-c397f130 | this.Load | SSP0025_ShipmentRequestorPIC.cs:121 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-7d66d571 | this.Load | SSP0025_ShipmentRequestorPIC.cs:122 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-f36b74d7 | this.Load | SSP0025_ShipmentRequestorPIC.cs:123 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SSP0025_ShipmentRequestorPIC.Delete

진입점: DeleteButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c12b1c71 | DeleteButton [if (fps.Name == "spdMain")] | SSP0025_ShipmentRequestorPIC.cs:337 |  | CALL_EXT | sv.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-46d20bf5 | DeleteButton [if (fps.Name == "spdMain")] | SSP0025_ShipmentRequestorPIC.cs:343 | if (sCellText.Trim() == CAppSetting.StringI) | DATA_OP | sv.Rows.Remove | (currentRowIndex, 1) | 데이터 객체 조작/조회 |  |  |  |

## SSP0025_ShipmentRequestorPIC.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-056de91c | Dispose | SSP0025_ShipmentRequestorPIC.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0025_ShipmentRequestorPIC.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d543979 | EditButton | SSP0025_ShipmentRequestorPIC.cs:212 | if (isOK == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1115d21e | EditButton | SSP0025_ShipmentRequestorPIC.cs:213 | if (isOK == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48c6b884 | EditButton | SSP0025_ShipmentRequestorPIC.cs:220 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-71ba714e | EditButton | SSP0025_ShipmentRequestorPIC.cs:221 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5f180537 | EditButton | SSP0025_ShipmentRequestorPIC.cs:223 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-93553319 | EditButton | SSP0025_ShipmentRequestorPIC.cs:224 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME), siMain.GetColumnIndex(DefColumns.USER_NAME),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-524be965 | EditButton | SSP0025_ShipmentRequestorPIC.cs:225 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PART_LEADER_NAME), siMain.GetColumnIndex(DefColumns.PART… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3fe7ade3 | EditButton | SSP0025_ShipmentRequestorPIC.cs:226 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TEAM_LEADER_NAME), siMain.GetColumnIndex(DefColumns.TEAM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c1055b17 | EditButton | SSP0025_ShipmentRequestorPIC.cs:227 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0025_ShipmentRequestorPIC.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0968ed5b | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:244 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ef05aa37 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:249 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-e79addea | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:249 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d686b458 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:253 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0fe37372 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:269 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-df653998 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:270 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3093a9e2 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:274 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC") ⇒ SSP.SSP0025_GET_SHIPMENT_REQUESTOR_PIC | 엔드포인트 요청 생성 |  |  |  |
| AC-456ad5e4 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:275 | try ▸ lambda | UI_PROP | req.CommandTimeout | 60 * 10 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7bfa41cd | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:276 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-460d28d1 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:277 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site"] | p_plant_site | 행/컬럼 값 대입 |  |  |  |
| AC-4a49b4b8 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:278 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-294cb170 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:279 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-e3798790 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:280 | try ▸ lambda | DATA_OP | req.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-04845698 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:281 | try ▸ lambda | DATA_OP | req.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-a131d722 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:282 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cfad4282 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:283 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b9758d5a | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:290 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-88f7c834 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:292 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-def0d880 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:294 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ac7411f6 | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:297 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-adc15fed | FindButton 외 1 | SSP0025_ShipmentRequestorPIC.cs:304 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0025_ShipmentRequestorPIC.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48198a01 | this.Load | SSP0025_ShipmentRequestorPIC.cs:108 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0025_ShipmentRequestorPIC.GetSSPUserCheck

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f7bb88c | EditButton | SSP0025_ShipmentRequestorPIC.cs:511 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_USER_INFO_LIST") ⇒ SSP.SSP0002_GET_USER_INFO_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-28cbd1e2 | EditButton | SSP0025_ShipmentRequestorPIC.cs:515 |  | DATA_OP | request.Parameters["Search"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-25321a3f | EditButton | SSP0025_ShipmentRequestorPIC.cs:516 |  | DATA_OP | request.Parameters["Language"] | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a815510d | EditButton | SSP0025_ShipmentRequestorPIC.cs:517 |  | DATA_OP | request.Parameters["SSOUserYN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-03b5e8b1 | EditButton | SSP0025_ShipmentRequestorPIC.cs:518 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-73a94529 | EditButton | SSP0025_ShipmentRequestorPIC.cs:522 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-33723cb3 | EditButton | SSP0025_ShipmentRequestorPIC.cs:526 |  | RETURN | return isResult; |  | 처리 중단/반환 |  |  |  |

## SSP0025_ShipmentRequestorPIC.GetUserIDChk

진입점: SaveButton [try ▸ if (iCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c38cbc49 | SaveButton [try ▸ if (iCount > 0)] | SSP0025_ShipmentRequestorPIC.cs:458 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0025_GET_USER_ID_CHECK") ⇒ SSP.SSP0025_GET_USER_ID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-dcc44d1d | SaveButton [try ▸ if (iCount > 0)] | SSP0025_ShipmentRequestorPIC.cs:459 | try | DATA_OP | request.Parameters["p_user_id"] | sUserID | 행/컬럼 값 대입 |  |  |  |
| AC-622ed217 | SaveButton [try ▸ if (iCount > 0)] | SSP0025_ShipmentRequestorPIC.cs:461 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a63a9ab | SaveButton [try ▸ if (iCount > 0)] | SSP0025_ShipmentRequestorPIC.cs:474 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ foreach (string user in strUSer) | DATA_OP | ds.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-68bdde28 | SaveButton [try ▸ if (iCount > 0)] | SSP0025_ShipmentRequestorPIC.cs:496 | try ▸ if (iCnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f7c28a6 | SaveButton [try ▸ if (iCount > 0)] | SSP0025_ShipmentRequestorPIC.cs:500 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a568cfea | SaveButton [try ▸ if (iCount > 0)] | SSP0025_ShipmentRequestorPIC.cs:502 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0025_ShipmentRequestorPIC.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e81f90c4 | this.Load | SSP0025_ShipmentRequestorPIC.cs:128 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-89518bf9 | this.Load | SSP0025_ShipmentRequestorPIC.cs:131 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-dc45e8ab | this.Load | SSP0025_ShipmentRequestorPIC.cs:133 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0025_ShipmentRequestorPIC.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8344ea82 | this.Load 외 2 | SSP0025_ShipmentRequestorPIC.cs:157 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-b4f06c5e | this.Load 외 2 | SSP0025_ShipmentRequestorPIC.cs:158 | if (spdInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantSiteByDivision", dtToSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-16aceb80 | this.Load 외 2 | SSP0025_ShipmentRequestorPIC.cs:159 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-8970df2d | this.Load 외 2 | SSP0025_ShipmentRequestorPIC.cs:160 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-85c0ec58 | this.Load 외 2 | SSP0025_ShipmentRequestorPIC.cs:162 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.USER_ID].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-d1ee001f | this.Load 외 2 | SSP0025_ShipmentRequestorPIC.cs:163 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.PART_LEADER].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-20ad1e41 | this.Load 외 2 | SSP0025_ShipmentRequestorPIC.cs:164 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.TEAM_LEADER].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0025_ShipmentRequestorPIC.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b0fca57 | InsertButton | SSP0025_ShipmentRequestorPIC.cs:315 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a3c26460 | InsertButton | SSP0025_ShipmentRequestorPIC.cs:318 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0672ec30 | InsertButton | SSP0025_ShipmentRequestorPIC.cs:319 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_SITE), siMain.GetColumnIndex(DefColumns.TO_S… | 그리드 편집 잠금/해제 |  |  |  |
| AC-54d1e83e | InsertButton | SSP0025_ShipmentRequestorPIC.cs:320 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e6b785bb | InsertButton | SSP0025_ShipmentRequestorPIC.cs:321 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-180f6c43 | InsertButton | SSP0025_ShipmentRequestorPIC.cs:322 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.USER_NAME), siMain.GetColumnIndex(DefColumns.US… | 그리드 편집 잠금/해제 |  |  |  |
| AC-afc56f81 | InsertButton | SSP0025_ShipmentRequestorPIC.cs:323 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.PART_LEADER_NAME), siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-91e0d426 | InsertButton | SSP0025_ShipmentRequestorPIC.cs:324 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TEAM_LEADER_NAME), siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-18f58c67 | InsertButton | SSP0025_ShipmentRequestorPIC.cs:325 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1ea4d111 | InsertButton | SSP0025_ShipmentRequestorPIC.cs:327 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, siMain.GetColumnIndex(DefColumns.VALID_YN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0025_ShipmentRequestorPIC.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81be3e2a | SaveButton | SSP0025_ShipmentRequestorPIC.cs:358 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-66305299 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:362 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-cc2e7115 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:364 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-5b6b49ac | SaveButton | SSP0025_ShipmentRequestorPIC.cs:364 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-be21bda3 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:400 | try ▸ if (iCount > 0) ▸ if (!GetUserIDChk(p_user_id)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68b17552 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:403 | try ▸ if (iCount > 0) ▸ if (p_part_leader.Replace("^", "") != null && p_part_leader.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_part_leade… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1744d372 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:407 | try ▸ if (iCount > 0) ▸ if (p_team_leader.Replace("^", "") != null && p_team_leader.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_team_leade… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88d29be7 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:410 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC") ⇒ SSP.SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC | 엔드포인트 요청 생성 |  |  |  |
| AC-2b57baea | SaveButton | SSP0025_ShipmentRequestorPIC.cs:414 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1358bf82 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:415 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0b79a921 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:416 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_to_site"] | p_plant_site | 행/컬럼 값 대입 |  |  |  |
| AC-9b8b78c7 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:417 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-512092e1 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:418 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ac1387e5 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:419 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_create_id"] | p_create_id | 행/컬럼 값 대입 |  |  |  |
| AC-8f0c2ea4 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:420 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_part_leader"] | p_part_leader | 행/컬럼 값 대입 |  |  |  |
| AC-3e1aab03 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:421 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_team_leader"] | p_team_leader | 행/컬럼 값 대입 |  |  |  |
| AC-9843a5f5 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:422 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-c22bd507 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:424 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a99e07f5 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:429 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ba01a9b2 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:431 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6dca9a99 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:436 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ca308626 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:438 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d3a3739 | SaveButton | SSP0025_ShipmentRequestorPIC.cs:446 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0025_ShipmentRequestorPIC.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66bcec89 | this.Load 외 1 | SSP0025_ShipmentRequestorPIC.cs:140 |  | FLAG | dtToSite | Data.Common(Data.Type.PlantCell, false, pDivisionID, "") ⇒ biz:CommonData.CommonDataList [code=PlantCell] | 화면 필드/플래그 변경 |  |  |  |
| AC-2ab509cd | this.Load 외 1 | SSP0025_ShipmentRequestorPIC.cs:140 |  | COMBO_DATA | Data.Common | (Data.Type.PlantCell, false, pDivisionID, "") ⇒ biz:CommonData.CommonDataList [code=PlantCell] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-adf5a388 | this.Load 외 1 | SSP0025_ShipmentRequestorPIC.cs:141 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, this.clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0025_ShipmentRequestorPIC.SetImageCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3180c175 | (진입점 미연결) | SSP0025_ShipmentRequestorPIC.cs:352 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetColumnIndex(DefColumns.USER_ID) > -1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.USER_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0025_ShipmentRequestorPIC.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9334e9f5 | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:620 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f707b3ee | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:631 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (string.IsNullOrEmpty(sDivisionId) && e.Column != siMain.GetColumnIndex(DefColumns.DIVISI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-526826f7 | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:632 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (string.IsNullOrEmpty(sDivisionId) && e.Column != siMain.GetColumnIndex(DefColumns.DIVISI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0f2e357b | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:639 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | FLAG | dtToSite | Data.Common(Data.Type.PlantCell, false, sDivisionId, "") ⇒ biz:CommonData.CommonDataList [code=PlantCell] | 화면 필드/플래그 변경 |  |  |  |
| AC-6e478cc2 | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:639 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | COMBO_DATA | Data.Common | (Data.Type.PlantCell, false, sDivisionId, "") ⇒ biz:CommonData.CommonDataList [code=PlantCell] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d468ee0 | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:640 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-bba3fc08 | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:648 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Plant Site" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-61a16d5b | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:649 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-450bede5 | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:651 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | POPUP | new SSP0025_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c414c40b | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:653 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | POPUP | popup.Form_Load | (true, sDivisionId, sPlantSite, sItemId,"",PopupType.POPUP_ITEM) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1a2d4dbf | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:655 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-18fcf4b4 | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:656 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c564473a | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:660 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), popup.DivisionId) | 그리드 값 설정 |  |  |  |
| AC-bc78440c | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:661 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), popup.ItemId) | 그리드 값 설정 |  |  |  |
| AC-6dbcab26 | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:662 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), popup.ElectrodeType) | 그리드 값 설정 |  |  |  |
| AC-6168c291 | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:663 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MODEL_ID), popup.ModelId) | 그리드 값 설정 |  |  |  |
| AC-afb9a6e7 | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:664 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), popup.NickName) | 그리드 값 설정 |  |  |  |
| AC-d77bdbd1 | spdMain.CellClick | SSP0025_ShipmentRequestorPIC.cs:665 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_TYPE), popup.CellType) | 그리드 값 설정 |  |  |  |

## SSP0025_ShipmentRequestorPIC.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfa1f1b8 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:545 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3a3f7fca | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:547 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-bff10a9b | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:548 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-2a0c0dc3 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:549 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cab61696 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:550 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-48ba7e14 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:551 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-1c8757d4 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:553 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-2723ba7a | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:555 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-27c855fe | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:561 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) ▸ if (popup.Sho… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-2030d651 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:569 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0e7c6742 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:571 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-b6461816 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:572 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-b5ee21c0 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:573 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a189ff55 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:574 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-9540dbaf | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:575 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-51fcedb2 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:577 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-99c77c4a | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:579 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9c9c4f7a | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:585 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PART_LEADER), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-a906b771 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:593 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6d419017 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:595 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-e8aac785 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:596 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-d09357d3 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:597 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8211e9f6 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:598 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-b5f3e76a | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:599 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-f82a70a8 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:601 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-a005d937 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:603 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a0a83513 | spdMain.CellDoubleClick | SSP0025_ShipmentRequestorPIC.cs:609 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TEAM_LEADER), item.UserID) | 그리드 값 설정 |  |  |  |

## SSP0025_ShipmentRequestorPIC.SpdMain_ComboSelChange

진입점: spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dc3a23e | spdMain.ComboSelChange | SSP0025_ShipmentRequestorPIC.cs:675 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8838e6f | spdMain.ComboSelChange | SSP0025_ShipmentRequestorPIC.cs:681 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE), siMain.GetValue(e.Row, siMain.GetColumn… | 그리드 값 설정 |  |  |  |
| AC-648ef6af | spdMain.ComboSelChange | SSP0025_ShipmentRequestorPIC.cs:687 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE), "") | 그리드 값 설정 |  |  |  |
| AC-38f28e98 | spdMain.ComboSelChange | SSP0025_ShipmentRequestorPIC.cs:688 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-f1597f48 | spdMain.ComboSelChange | SSP0025_ShipmentRequestorPIC.cs:689 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-f3d6f59d | spdMain.ComboSelChange | SSP0025_ShipmentRequestorPIC.cs:690 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-c33f5408 | spdMain.ComboSelChange | SSP0025_ShipmentRequestorPIC.cs:691 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MODEL_ID), "") | 그리드 값 설정 |  |  |  |
| AC-cb4bb4ef | spdMain.ComboSelChange | SSP0025_ShipmentRequestorPIC.cs:692 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-513f154c | spdMain.ComboSelChange | SSP0025_ShipmentRequestorPIC.cs:693 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_TYPE), "") | 그리드 값 설정 |  |  |  |

## SSP0025_ShipmentRequestorPIC.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec72e21d | spdMain.TopChange | SSP0025_ShipmentRequestorPIC.cs:534 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |


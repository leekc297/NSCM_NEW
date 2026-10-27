# AS-IS 액션 대조표 — SSP0024

> 원천: `Doc/asisfacts/screens/SSP0024/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 291행 · 메서드 36 · 종류 DATA_OP 62 · FLAG 58 · GRID_SET 32 · RETURN 24 · GRID_INIT 19 · ENDPOINT 14 · GRID_LOCK 12 · POPUP 11 · UI_MISC 10 · LIST_REBIND 10 · UI_PROP 7 · MESSAGE 7 · GRID_COMBO 6 · VALUE_SET 5 · VALIDATE 3 · GRID_BIND 2 · COMBO_DATA 2 · STATE 2 · CALL_EXT 2 · VALUE_CLEAR 2 · GRID_CLEAR 1 · ⚠ 의미 확인 필요 2


## SSP0024_ItembyDivisionPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7eef4508 | this.btnButtonList.UsrButtonList_Click_Detected | SSP0024_ItembyDivisionPopup.cs:312 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-caeb5aba | this.btnButtonList.UsrButtonList_Click_Detected | SSP0024_ItembyDivisionPopup.cs:315 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0024_ItembyDivisionPopup.clbDivision_SelectedIndexChanged

진입점: this.clbDivisionId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ab5169e | this.clbDivisionId.SelectedIndexChanged | SSP0024_ItembyDivisionPopup.cs:322 |  | FLAG | dtPlantSiteCode | GetDivisionbyPlantSiteCode(clbDivisionId.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-ac2db027 | this.clbDivisionId.SelectedIndexChanged | SSP0024_ItembyDivisionPopup.cs:323 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteCode, clbPlantSiteId, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0024_ItembyDivisionPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9a80b46 | this.Load | SSP0024_ItembyDivisionPopup.cs:202 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-418e592a | this.Load | SSP0024_ItembyDivisionPopup.cs:203 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-80d9fdeb | this.Load | SSP0024_ItembyDivisionPopup.cs:204 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0024_ItembyDivisionPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13cdbb5a | this.Load | SSP0024_ItembyDivisionPopup.cs:197 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0024_ItembyDivisionPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c57dfe9b | Dispose | SSP0024_ItembyDivisionPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0024_ItembyDivisionPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a85396c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:263 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bdf11d46 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:267 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP") ⇒ SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-590b6ec9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:268 | lambda | DATA_OP | request.Parameters["p_division_id"] | (clbDivisionId.ControlValues == "ALL") ? "" : clbDivisionId.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-fb180b23 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:269 | lambda | DATA_OP | request.Parameters["p_plant_site_id"] | (clbPlantSiteId.ControlValues == "ALL") ? "" : clbPlantSiteId.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-421004f5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:270 | lambda | DATA_OP | request.Parameters["p_material_id"] | txtMaterialId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-fc6f1925 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:271 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e3f31890 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:273 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-264bda44 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:277 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e0b156d5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:278 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c37c9cd5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:282 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-a13ba51c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:286 | if (ds.Tables[0].Rows.Count == 1) | FLAG | divisionId | this.dtFindData.Rows[0][DefColumns.Division].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4855571a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:287 | if (ds.Tables[0].Rows.Count == 1) | FLAG | plantSiteCode | this.dtFindData.Rows[0][DefColumns.PlantSiteCode].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8512af46 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:288 | if (ds.Tables[0].Rows.Count == 1) | FLAG | plantSiteId | this.dtFindData.Rows[0][DefColumns.PlantSiteId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1529dc65 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:289 | if (ds.Tables[0].Rows.Count == 1) | FLAG | materialId | this.dtFindData.Rows[0][DefColumns.MaterialId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d4d9fb2e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:290 | if (ds.Tables[0].Rows.Count == 1) | FLAG | modelId | this.dtFindData.Rows[0][DefColumns.ModelId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9f0eda5c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:291 | if (ds.Tables[0].Rows.Count == 1) | FLAG | cellType | this.dtFindData.Rows[0][DefColumns.CellType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-58f5b519 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:292 | if (ds.Tables[0].Rows.Count == 1) | FLAG | nickName | this.dtFindData.Rows[0][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4a456d85 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:293 | if (ds.Tables[0].Rows.Count == 1) | FLAG | electrodeType | this.dtFindData.Rows[0][DefColumns.ElectrodeType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6bf8a36a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:294 | if (ds.Tables[0].Rows.Count == 1) | FLAG | itemUOM | this.dtFindData.Rows[0][DefColumns.ItemUOM].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2430c468 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:295 | if (ds.Tables[0].Rows.Count == 1) | FLAG | uomConvertInTactTime | this.dtFindData.Rows[0][DefColumns.UomConvertInTactTime].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f61313ca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:297 | if (ds.Tables[0].Rows.Count == 1) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0024_ItembyDivisionPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d59d309 | this.Load | SSP0024_ItembyDivisionPopup.cs:161 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b8276480 | this.Load | SSP0024_ItembyDivisionPopup.cs:162 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b503e0d0 | this.Load | SSP0024_ItembyDivisionPopup.cs:170 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-6a2ea665 | this.Load | SSP0024_ItembyDivisionPopup.cs:171 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-7f5d8ec6 | this.Load | SSP0024_ItembyDivisionPopup.cs:172 |  | FLAG | sPlantSiteCode | _PlantSiteCode | 화면 필드/플래그 변경 |  |  |  |
| AC-fc7d2b07 | this.Load | SSP0024_ItembyDivisionPopup.cs:173 |  | FLAG | sMaterial | _Material | 화면 필드/플래그 변경 |  |  |  |

## SSP0024_ItembyDivisionPopup.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b729333 | this.Load | SSP0024_ItembyDivisionPopup.cs:405 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-9574fb92 | this.Load | SSP0024_ItembyDivisionPopup.cs:406 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ee09968f | this.Load | SSP0024_ItembyDivisionPopup.cs:409 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0024_ItembyDivisionPopup.GetDivisionbyPlantSiteCode

진입점: this.clbDivisionId.SelectedIndexChanged / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ab1fc43 | this.clbDivisionId.SelectedIndexChanged 외 1 | SSP0024_ItembyDivisionPopup.cs:415 |  | COMBO_DATA | Data.Common | (Data.Type.PlantSiteByDivision, false, sDivisionId) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a80b062e | this.clbDivisionId.SelectedIndexChanged 외 1 | SSP0024_ItembyDivisionPopup.cs:416 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0024_ItembyDivisionPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04d4584f | this.Load | SSP0024_ItembyDivisionPopup.cs:180 |  | FLAG | dtDivision | GetDivision() | 화면 필드/플래그 변경 |  |  |  |
| AC-6221594a | this.Load | SSP0024_ItembyDivisionPopup.cs:181 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisionId, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1618e7bd | this.Load | SSP0024_ItembyDivisionPopup.cs:183 |  | FLAG | dtPlantSiteCode | GetDivisionbyPlantSiteCode(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-791ecd18 | this.Load | SSP0024_ItembyDivisionPopup.cs:184 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteCode, clbPlantSiteId, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a6165913 | this.Load | SSP0024_ItembyDivisionPopup.cs:186 |  | VALUE_SET | clbDivisionId.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-205b9f76 | this.Load | SSP0024_ItembyDivisionPopup.cs:187 |  | VALUE_SET | clbPlantSiteId.ControlValues | sPlantSiteCode | 컨트롤 값 설정 |  |  |  |
| AC-facf2824 | this.Load | SSP0024_ItembyDivisionPopup.cs:188 |  | VALUE_SET | txtMaterialId.Text | sMaterial | 컨트롤 값 설정 |  |  |  |
| AC-d5ae7c2c | this.Load | SSP0024_ItembyDivisionPopup.cs:190 |  | STATE | clbDivisionId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5ef35774 | this.Load | SSP0024_ItembyDivisionPopup.cs:191 |  | STATE | clbPlantSiteId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0024_ItembyDivisionPopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e553f7c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:211 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-2dc8b193 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:213 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-47384d8f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:214 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DivisionName , DefColumns.Division , FPMerge.None, 60, true ,FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-82e31576 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:215 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DivisionName , DefColumns.DivisionName , FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3c43cc9e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:216 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.PlantSiteCode , DefColumns.PlantSiteCode , FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b6a9634e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:217 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.PlantSiteId , DefColumns.PlantSiteId , FPMerge.None, 80, true, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d6ad68ad | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:218 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.MaterialId , DefColumns.MaterialId , FPMerge.None, 100, true, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-65d811ab | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:219 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ModelId , DefColumns.ModelId , FPMerge.None, 150, true, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc1a37a1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:220 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.CellType , DefColumns.CellType , FPMerge.None, 80, true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0638d3f9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:221 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.NickName , DefColumns.NickName , FPMerge.None, 150, true, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e9c7c487 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:222 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ElectrodeType , DefColumns.ElectrodeType , FPMerge.None, 80, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6b9e827c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:223 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ITEM_UOM , DefColumns.ItemUOM , FPMerge.None, 60 , true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e774f88 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0024_ItembyDivisionPopup.cs:224 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.UomConvertInTactTime, DefColumns.UomConvertInTactTime, FPMerge.None, 120,… | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0024_ItembyDivisionPopup.SetMaterial

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d477274d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:336 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a247cda4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:338 |  | FLAG | materialId | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4331124a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:352 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | divisionId | this.dtFindData.Rows[iRow][DefColumns.Division].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3ed7cf0d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:353 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | plantSiteCode | this.dtFindData.Rows[iRow][DefColumns.PlantSiteCode].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7f36d781 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:354 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | plantSiteId | this.dtFindData.Rows[iRow][DefColumns.PlantSiteId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4a1d0ad4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:355 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | materialId | this.dtFindData.Rows[iRow][DefColumns.MaterialId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3c619425 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:356 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | modelId | this.dtFindData.Rows[iRow][DefColumns.ModelId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3ec7737b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:357 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | cellType | this.dtFindData.Rows[iRow][DefColumns.CellType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2053e7ac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:358 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f1d24dcb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:359 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | electrodeType | this.dtFindData.Rows[iRow][DefColumns.ElectrodeType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-93d1c7f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:360 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemUOM | this.dtFindData.Rows[iRow][DefColumns.ItemUOM].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ba073dcc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:361 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | uomConvertInTactTime | this.dtFindData.Rows[iRow][DefColumns.UomConvertInTactTime].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-65f293ab | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:365 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | divisionId | divisionId + "," + this.dtFindData.Rows[iRow][DefColumns.Division].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-800c3780 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:366 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | plantSiteCode | plantSiteCode + "," + this.dtFindData.Rows[iRow][DefColumns.PlantSiteCode].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f37e1be5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:367 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | plantSiteId | plantSiteId + "," + this.dtFindData.Rows[iRow][DefColumns.PlantSiteId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5aeaa32b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:368 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | materialId | materialId + "," + this.dtFindData.Rows[iRow][DefColumns.MaterialId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-829c61b0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:369 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | modelId | modelId + "," + this.dtFindData.Rows[iRow][DefColumns.ModelId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6adaeafd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:370 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | cellType | cellType + "," + this.dtFindData.Rows[iRow][DefColumns.CellType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9507e004 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:371 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | nickName + "," + this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6eeb75d0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:372 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | electrodeType | electrodeType + "," + this.dtFindData.Rows[iRow][DefColumns.ElectrodeType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0ca71ee0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:373 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemUOM | itemUOM + "," + this.dtFindData.Rows[iRow][DefColumns.ItemUOM].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fadd764c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:374 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | uomConvertInTactTime | uomConvertInTactTime + "," + this.dtFindData.Rows[iRow][DefColumns.UomConvertInTactTime].T… | 화면 필드/플래그 변경 |  |  |  |
| AC-a23468cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:381 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8bb00c2f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:386 | else of (bMulltiSelect) | FLAG | plantSiteCode | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteCode)) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6d35c5b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:387 | else of (bMulltiSelect) | FLAG | plantSiteId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-f0c29982 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:388 | else of (bMulltiSelect) | FLAG | materialId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MaterialId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-1285fa3b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:389 | else of (bMulltiSelect) | FLAG | modelId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ModelId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad30b6df | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:390 | else of (bMulltiSelect) | FLAG | cellType | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CellType)) | 화면 필드/플래그 변경 |  |  |  |
| AC-751438c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:391 | else of (bMulltiSelect) | FLAG | nickName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NickName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-b36f414f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:392 | else of (bMulltiSelect) | FLAG | electrodeType | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ElectrodeType)) | 화면 필드/플래그 변경 |  |  |  |
| AC-0bd19453 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:393 | else of (bMulltiSelect) | FLAG | itemUOM | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemUOM)) | 화면 필드/플래그 변경 |  |  |  |
| AC-aa560535 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0024_ItembyDivisionPopup.cs:394 | else of (bMulltiSelect) | FLAG | uomConvertInTactTime | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.UomConvertInTactTim… | 화면 필드/플래그 변경 |  |  |  |

## SSP0024_ItembyDivisionPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1a63ff3 | this.spdMain.CellDoubleClick | SSP0024_ItembyDivisionPopup.cs:329 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0024_ShipmentMasterElectrode.BtnMaterialId_Click

진입점: this.btnMaterialId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2235b755 | this.btnMaterialId.Click | SSP0024_ShipmentMasterElectrode.cs:736 |  | POPUP | new SSP0024_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-579105ba | this.btnMaterialId.Click | SSP0024_ShipmentMasterElectrode.cs:738 |  | POPUP | popup.Form_Load | (true, sdivisionId, sPlantSiteCode, sMaterialId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-dd3fd379 | this.btnMaterialId.Click | SSP0024_ShipmentMasterElectrode.cs:739 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-682622d1 | this.btnMaterialId.Click | SSP0024_ShipmentMasterElectrode.cs:740 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-38bd1efe | this.btnMaterialId.Click | SSP0024_ShipmentMasterElectrode.cs:746 | if (null != popup.MaterialId && "" != popup.MaterialId) | VALUE_SET | txtMaterialId.Text | sMaterialId | 컨트롤 값 설정 |  |  |  |

## SSP0024_ShipmentMasterElectrode.BtnModelId_Click

진입점: this.btnModelId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-959d13d7 | this.btnModelId.Click | SSP0024_ShipmentMasterElectrode.cs:757 |  | POPUP | new SSP0024_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f5d460f3 | this.btnModelId.Click | SSP0024_ShipmentMasterElectrode.cs:759 |  | POPUP | popup.Form_Load | (true, sdivisionId, sPlantSiteCode, sMaterialId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d46f52e4 | this.btnModelId.Click | SSP0024_ShipmentMasterElectrode.cs:760 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-14ef3a1a | this.btnModelId.Click | SSP0024_ShipmentMasterElectrode.cs:761 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8963efbb | this.btnModelId.Click | SSP0024_ShipmentMasterElectrode.cs:767 | if (null != popup.ModelId && "" != popup.ModelId) | VALUE_SET | txtModelId.Text | sModelId | 컨트롤 값 설정 |  |  |  |

## SSP0024_ShipmentMasterElectrode.checkValidN1

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a584134c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0024_ShipmentMasterElectrode.cs:807 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f9e5107d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SSP0024_ShipmentMasterElectrode.cs:810 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SSP0024_ShipmentMasterElectrode.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c703ccd | this.Load | SSP0024_ShipmentMasterElectrode.cs:206 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5f6e0594 | this.Load | SSP0024_ShipmentMasterElectrode.cs:207 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e2f22141 | this.Load | SSP0024_ShipmentMasterElectrode.cs:208 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0024_ShipmentMasterElectrode.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-039fc48b | this.Load | SSP0024_ShipmentMasterElectrode.cs:140 | if (dtMyDivision.Rows.Count > 0) | FLAG | dtMyDivisionIns | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-3af81c34 | this.Load | SSP0024_ShipmentMasterElectrode.cs:141 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtMyDivisionIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-91b3f450 | this.Load | SSP0024_ShipmentMasterElectrode.cs:142 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtMyDivisionIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-d8c9480d | this.Load | SSP0024_ShipmentMasterElectrode.cs:146 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dtMyDivisionIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cfd5b71e | this.Load | SSP0024_ShipmentMasterElectrode.cs:147 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-21db3e21 | this.Load | SSP0024_ShipmentMasterElectrode.cs:148 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | drRow["NAME"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b5b534e7 | this.Load | SSP0024_ShipmentMasterElectrode.cs:149 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dtMyDivisionIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-455834e3 | this.Load | SSP0024_ShipmentMasterElectrode.cs:151 | if (dtMyDivision.Rows.Count > 0) | FLAG | dtEmpty | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-52ee5526 | this.Load | SSP0024_ShipmentMasterElectrode.cs:152 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtEmpty.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef54999f | this.Load | SSP0024_ShipmentMasterElectrode.cs:153 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtEmpty.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-f49be869 | this.Load | SSP0024_ShipmentMasterElectrode.cs:155 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtBuilding.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-580dc7d3 | this.Load | SSP0024_ShipmentMasterElectrode.cs:156 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | drAllRow["CODE"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-572e95b4 | this.Load | SSP0024_ShipmentMasterElectrode.cs:157 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | drAllRow["NAME"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-8bc6539f | this.Load | SSP0024_ShipmentMasterElectrode.cs:158 | if (dtMyDivision.Rows.Count > 0) | CALL_EXT | dtBuilding.Rows.InsertAt | (drAllRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39d270b7 | this.Load | SSP0024_ShipmentMasterElectrode.cs:159 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtBuilding.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-18b08bc9 | this.Load | SSP0024_ShipmentMasterElectrode.cs:162 |  | FLAG | dtElectrodePostOperCodeForIns | dtElectrodePostOperCode.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c03967dc | this.Load | SSP0024_ShipmentMasterElectrode.cs:162 |  | DATA_OP | dtElectrodePostOperCode.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c728d1fa | this.Load | SSP0024_ShipmentMasterElectrode.cs:163 |  | FLAG | dtBuildingForIns | dtBuilding.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-03e32855 | this.Load | SSP0024_ShipmentMasterElectrode.cs:163 |  | DATA_OP | dtBuilding.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0024_ShipmentMasterElectrode.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe24da71 | DeleteButton | SSP0024_ShipmentMasterElectrode.cs:269 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8e19b2a8 | DeleteButton | SSP0024_ShipmentMasterElectrode.cs:274 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0024_ShipmentMasterElectrode.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce717578 | Dispose | SSP0024_ShipmentMasterElectrode.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0024_ShipmentMasterElectrode.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b3216a3 | EditButton | SSP0024_ShipmentMasterElectrode.cs:248 | if (isOK == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ab80822c | EditButton | SSP0024_ShipmentMasterElectrode.cs:249 | if (isOK == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1384fe10 | EditButton | SSP0024_ShipmentMasterElectrode.cs:252 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-501f9958 | EditButton | SSP0024_ShipmentMasterElectrode.cs:253 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c788916a | EditButton | SSP0024_ShipmentMasterElectrode.cs:255 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID),siMain.GetColumnIndex(DefColumns.ITEM_UOM),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-48986af6 | EditButton | SSP0024_ShipmentMasterElectrode.cs:256 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.POST_OPER_LT),siMain.GetColumnIndex(DefColumns.UOM_CONVE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f5d8001d | EditButton | SSP0024_ShipmentMasterElectrode.cs:257 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.BUILDING_DESC), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-25f69215 | EditButton | SSP0024_ShipmentMasterElectrode.cs:258 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0024_ShipmentMasterElectrode.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cc2b458 | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:291 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-78ce79dc | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:294 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d0e9bd7f | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:294 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c01f43f1 | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:298 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fd181287 | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:311 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6306d83d | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:312 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88165020 | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:316 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0024_GET_SHIP_MASTER") ⇒ SSP.SSP0024_GET_SHIP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-a601336d | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:317 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f29748e6 | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:318 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-54a4198d | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:319 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d5f2c07f | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:320 | try ▸ lambda | DATA_OP | request.Parameters["p_material_id"] | p_material_id | 행/컬럼 값 대입 |  |  |  |
| AC-c1551b99 | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:321 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-aefd5b6b | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:322 | try ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-b3165cc2 | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:324 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aa469ad2 | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:326 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-19861786 | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:333 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a0e809dd | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:334 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-59c969ff | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:337 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-58a6e32b | FindButton 외 1 | SSP0024_ShipmentMasterElectrode.cs:349 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0024_ShipmentMasterElectrode.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9724758 | this.Load | SSP0024_ShipmentMasterElectrode.cs:115 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0024_ShipmentMasterElectrode.GetSelectedListName

진입점: spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.POST_OPER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BUILDING))] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a87f6323 | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:859 | if (dt == null \|\| string.IsNullOrEmpty(controlValues)) | RETURN | return controlValues; |  | 처리 중단/반환 |  |  |  |
| AC-ce4ea425 | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:874 |  | RETURN | return rtnValue; |  | 처리 중단/반환 |  |  |  |

## SSP0024_ShipmentMasterElectrode.GetSSPUserCheck

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7c41c56 | EditButton | SSP0024_ShipmentMasterElectrode.cs:883 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_USER_INFO_LIST") ⇒ SSP.SSP0002_GET_USER_INFO_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-b5468b30 | EditButton | SSP0024_ShipmentMasterElectrode.cs:887 |  | DATA_OP | request.Parameters["Search"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-36f774c8 | EditButton | SSP0024_ShipmentMasterElectrode.cs:888 |  | DATA_OP | request.Parameters["Language"] | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e410af2a | EditButton | SSP0024_ShipmentMasterElectrode.cs:889 |  | DATA_OP | request.Parameters["SSOUserYN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-f18ce997 | EditButton | SSP0024_ShipmentMasterElectrode.cs:890 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cc71b940 | EditButton | SSP0024_ShipmentMasterElectrode.cs:894 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-05d46b3e | EditButton | SSP0024_ShipmentMasterElectrode.cs:898 |  | RETURN | return isResult; |  | 처리 중단/반환 |  |  |  |

## SSP0024_ShipmentMasterElectrode.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be66dc01 | this.Load | SSP0024_ShipmentMasterElectrode.cs:168 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-928bedee | this.Load | SSP0024_ShipmentMasterElectrode.cs:171 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-587849c1 | this.Load | SSP0024_ShipmentMasterElectrode.cs:173 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0024_ShipmentMasterElectrode.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6de44cbf | this.Load 외 2 | SSP0024_ShipmentMasterElectrode.cs:215 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-269a386e | this.Load 외 2 | SSP0024_ShipmentMasterElectrode.cs:216 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantByDivisionOperation", dtPlantSiteByFactoryForSpread) | 목록 컨트롤 재구성 |  |  |  |
| AC-f699c12d | this.Load 외 2 | SSP0024_ShipmentMasterElectrode.cs:217 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ElectrodePackageType", dtElectrodePackageType) | 목록 컨트롤 재구성 |  |  |  |
| AC-151c29a3 | this.Load 외 2 | SSP0024_ShipmentMasterElectrode.cs:218 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("DomExpTypeCode", dtDomExpTypeCode) | 목록 컨트롤 재구성 |  |  |  |
| AC-acee52f0 | this.Load 외 2 | SSP0024_ShipmentMasterElectrode.cs:219 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("BuildingByPlantSite", dtBuilding) | 목록 컨트롤 재구성 |  |  |  |
| AC-7d4d4314 | this.Load 외 2 | SSP0024_ShipmentMasterElectrode.cs:221 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## SSP0024_ShipmentMasterElectrode.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68565e26 | InsertButton | SSP0024_ShipmentMasterElectrode.cs:370 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e19b5c72 | InsertButton | SSP0024_ShipmentMasterElectrode.cs:374 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivisionIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-fe7813eb | InsertButton | SSP0024_ShipmentMasterElectrode.cs:375 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSiteByFact… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d756e8c5 | InsertButton | SSP0024_ShipmentMasterElectrode.cs:376 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.POST_OPER), dtElectrodePostOperCo… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c1413a5f | InsertButton | SSP0024_ShipmentMasterElectrode.cs:377 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BUILDING), dtBuilding) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-01269f21 | InsertButton | SSP0024_ShipmentMasterElectrode.cs:381 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, pDivisiontId) | 데이터 객체 조작/조회 |  |  |  |
| AC-41607b92 | InsertButton | SSP0024_ShipmentMasterElectrode.cs:383 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-198fe8c4 | InsertButton | SSP0024_ShipmentMasterElectrode.cs:385 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.PLANT_SITE_CODE), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4aacf38e | InsertButton | SSP0024_ShipmentMasterElectrode.cs:386 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.MODEL_ID), siMain.GetColumnIndex(DefColumns.ITE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-86b5c3e3 | InsertButton | SSP0024_ShipmentMasterElectrode.cs:387 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.POST_OPER_LT), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8322a312 | InsertButton | SSP0024_ShipmentMasterElectrode.cs:388 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.BUILDING_DESC), siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-096a9921 | InsertButton | SSP0024_ShipmentMasterElectrode.cs:389 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0024_ShipmentMasterElectrode.Re_Design

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a4347d7 | (진입점 미연결) | SSP0024_ShipmentMasterElectrode.cs:357 |  | DATA_OP | dtElectrodePostOperCode.Select().Where(c => c["DIVISION_ID"].ToString() == sDivisionId).Co… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-98de28b2 | (진입점 미연결) | SSP0024_ShipmentMasterElectrode.cs:357 |  | DATA_OP | dtElectrodePostOperCode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b0aaf5e7 | (진입점 미연결) | SSP0024_ShipmentMasterElectrode.cs:359 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ElectrodePostOperCode", dtElecOperCode) | 목록 컨트롤 재구성 |  |  |  |

## SSP0024_ShipmentMasterElectrode.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c853b76 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:401 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.Rows.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16473705 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:402 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-b34b7d1e | SaveButton | SSP0024_ShipmentMasterElectrode.cs:402 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f1a5a9c | SaveButton | SSP0024_ShipmentMasterElectrode.cs:421 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN1()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f625938b | SaveButton | SSP0024_ShipmentMasterElectrode.cs:467 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0024_SAVE_SHIP_MASTER") ⇒ SSP.SSP0024_SAVE_SHIP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-cb3f681a | SaveButton | SSP0024_ShipmentMasterElectrode.cs:471 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c4ba3e23 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:475 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-54ec1886 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:476 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d2d36343 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:477 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_plant_site_code"] | p_plant_site_code | 행/컬럼 값 대입 |  |  |  |
| AC-a64e6e42 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:478 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_material_id"] | p_material_id | 행/컬럼 값 대입 |  |  |  |
| AC-e4ef7614 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:479 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_electrode_post_oper_code"] | p_electrode_post_oper_code | 행/컬럼 값 대입 |  |  |  |
| AC-e4867f1f | SaveButton | SSP0024_ShipmentMasterElectrode.cs:480 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_pc_roll_length"] | p_pc_roll_length | 행/컬럼 값 대입 |  |  |  |
| AC-1965789b | SaveButton | SSP0024_ShipmentMasterElectrode.cs:481 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_package_type_code"] | p_package_type_code | 행/컬럼 값 대입 |  |  |  |
| AC-97286430 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:482 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_steelcrate_per_cut"] | p_steelcrate_per_cut | 행/컬럼 값 대입 |  |  |  |
| AC-3f040094 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:483 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_box_per_cut"] | p_box_per_cut | 행/컬럼 값 대입 |  |  |  |
| AC-ece81223 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:484 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_steelrack_per_cut"] | p_steelrack_per_cut | 행/컬럼 값 대입 |  |  |  |
| AC-7f1d8710 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:485 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_dom_exp_type_code"] | p_dom_exp_type_code | 행/컬럼 값 대입 |  |  |  |
| AC-48992e89 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:486 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-bd6fcf85 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:487 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-05fa48db | SaveButton | SSP0024_ShipmentMasterElectrode.cs:488 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-57b8d6ef | SaveButton | SSP0024_ShipmentMasterElectrode.cs:489 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-dd6f82e9 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:490 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-fdcf29df | SaveButton | SSP0024_ShipmentMasterElectrode.cs:492 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-be8ca232 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:492 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-a7ae643d | SaveButton | SSP0024_ShipmentMasterElectrode.cs:501 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-71495150 | SaveButton | SSP0024_ShipmentMasterElectrode.cs:513 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5232239e | SaveButton | SSP0024_ShipmentMasterElectrode.cs:517 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0024_ShipmentMasterElectrode.SetCellCombo

진입점: spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID))] / spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (rDivisionID != "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db515f0d | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:823 | if ("" != pdivision) ▸ if (dtOrgDataTable != null) ▸ if ("" != pPlantId) | DATA_OP | dtOrgDataTable.Select | ("DIVISION_ID = '" + pdivision + "' AND PLANT_ID = '" + pPlantId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a9a262a | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:827 | if ("" != pdivision) ▸ if (dtOrgDataTable != null) ▸ else of ("" != pPlantId) | DATA_OP | dtOrgDataTable.Select | ("DIVISION_ID = '" + pdivision + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-2da7761d | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:832 | if ("" != pdivision) | DATA_OP | dtRstDataTable.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9543ff5 | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:833 | if ("" != pdivision) | DATA_OP | dtRstDataTable.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-38b53429 | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:837 | if ("" != pdivision) ▸ foreach (DataRow dr in drArr) | DATA_OP | dtRstDataTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c95143e5 | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:838 | if ("" != pdivision) ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a49067d4 | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:839 | if ("" != pdivision) ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cd5a7302 | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:840 | if ("" != pdivision) ▸ foreach (DataRow dr in drArr) | DATA_OP | dtRstDataTable.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-cba1b798 | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:845 | if ("" != pdivision) ▸ if (pAllYN) | DATA_OP | dtRstDataTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-897ebfc2 | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:846 | if ("" != pdivision) ▸ if (pAllYN) | DATA_OP | drRow["CODE"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-3f3a6ebd | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:847 | if ("" != pdivision) ▸ if (pAllYN) | DATA_OP | drRow["NAME"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-70b32714 | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:848 | if ("" != pdivision) ▸ if (pAllYN) | CALL_EXT | dtRstDataTable.Rows.InsertAt | (drRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-01dee0fb | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:849 | if ("" != pdivision) ▸ if (pAllYN) | DATA_OP | dtBuilding.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d454121a | spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == fa… 외 1 | SSP0024_ShipmentMasterElectrode.cs:852 | if ("" != pdivision) | GRID_COMBO | siMain.SetCellTypeCombo | (nRow, nCol, dtRstDataTable) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SSP0024_ShipmentMasterElectrode.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31515b81 | this.Load 외 1 | SSP0024_ShipmentMasterElectrode.cs:191 |  | FLAG | dtPlantSiteByFactory | Data.Common(Data.Type.PlantSiteByFactoryEEOperation, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByFactoryEEOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-7c4d9e96 | this.Load 외 1 | SSP0024_ShipmentMasterElectrode.cs:191 |  | COMBO_DATA | Data.Common | (Data.Type.PlantSiteByFactoryEEOperation, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByFactoryEEOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4ac3d0ba | this.Load 외 1 | SSP0024_ShipmentMasterElectrode.cs:192 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByFactory, cboPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-036b5834 | this.Load 외 1 | SSP0024_ShipmentMasterElectrode.cs:194 |  | VALUE_CLEAR | txtMaterialId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a99c23e9 | this.Load 외 1 | SSP0024_ShipmentMasterElectrode.cs:195 |  | VALUE_CLEAR | txtModelId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-67103141 | this.Load 외 1 | SSP0024_ShipmentMasterElectrode.cs:199 | if (spdMain != null && spdMain.ActiveSheet != null && spdMain.ActiveSheet.Rows.Count > 0) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0024_ShipmentMasterElectrode.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d9b7982 | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:533 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c429f5c | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:544 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (string.IsNullOrEmpty(sDivisionId) && e.Column != siMain.GetColumnIndex(DefColumns.DIVISI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-79e4957f | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:545 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (string.IsNullOrEmpty(sDivisionId) && e.Column != siMain.GetColumnIndex(DefColumns.DIVISI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c667354 | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:558 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Plant Site" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18cbf804 | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:559 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2311e1a7 | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:561 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | POPUP | new SSP0024_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6a10e351 | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:563 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | POPUP | popup.Form_Load | (true, sDivisionId, sPlantSiteCode, sMaterial) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c64fed62 | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:565 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c6152298 | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:566 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-822aa11f | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:570 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), popup.DivisionId) | 그리드 값 설정 |  |  |  |
| AC-5037f07d | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:571 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_CODE), popup.PlantSiteCode) | 그리드 값 설정 |  |  |  |
| AC-8f819ff3 | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:572 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), popup.PlantSiteCode) | 그리드 값 설정 |  |  |  |
| AC-dc67a2a9 | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:573 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MATERIAL_ID), popup.MaterialId) | 그리드 값 설정 |  |  |  |
| AC-aca27e59 | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:574 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MODEL_ID), popup.ModelId) | 그리드 값 설정 |  |  |  |
| AC-77b3def1 | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:575 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_TYPE), popup.CellType) | 그리드 값 설정 |  |  |  |
| AC-c80aca28 | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:576 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), popup.NickName) | 그리드 값 설정 |  |  |  |
| AC-0a67e913 | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:577 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), popup.ElectrodeType) | 그리드 값 설정 |  |  |  |
| AC-30cd154b | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:578 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_UOM), popup.ItemUOM) | 그리드 값 설정 |  |  |  |
| AC-3e7239ea | spdMain.CellClick | SSP0024_ShipmentMasterElectrode.cs:579 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.UOM_CONVERT_IN_TACT_TIME), popup.UomConvertInTact… | 그리드 값 설정 |  |  |  |

## SSP0024_ShipmentMasterElectrode.SpdMain_ClipboardPasted

진입점: spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7de71d0b | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:662 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b035bf80 | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:665 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7883a03 | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:681 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-8c11a22e | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:682 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c73ea9e1 | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:683 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.MATERIAL_ID), "") | 그리드 값 설정 |  |  |  |
| AC-e512447b | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:684 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.MODEL_ID), "") | 그리드 값 설정 |  |  |  |
| AC-d2a74a82 | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:685 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CELL_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-c7b36dff | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:686 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-81daa19b | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:687 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-3ee976e0 | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:700 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-98bf5efa | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:705 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-5de3cf24 | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:714 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | DATA_OP | dtPlantSiteByFactoryForIns.Select | ("CODE = '" + rPlantSiteId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-05746012 | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:717 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_CODE), rPlantSiteId) | 그리드 값 설정 |  |  |  |
| AC-3085dc23 | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:718 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), rPlantSiteId) | 그리드 값 설정 |  |  |  |
| AC-9e8e09fd | spdMain.ClipboardPasted | SSP0024_ShipmentMasterElectrode.cs:722 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtEmpty) | 그리드 값 설정 |  |  |  |

## SSP0024_ShipmentMasterElectrode.SpdMain_ComboSelChange

진입점: spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7a2f985 | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:599 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-785a375a | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:605 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BUILDING)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BUILDING_DESC), siMain.GetValue(e.Row, siMain.Get… | 그리드 값 설정 |  |  |  |
| AC-d6e6195b | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:612 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BUILDING)) ▸ if (e.Column == siMain.Ge… | DATA_OP | dtElectrodePostOperCode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8aa0149a | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:616 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BUILDING)) ▸ if (e.Column == siMain.Ge… | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-49000f8e | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:617 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BUILDING)) ▸ if (e.Column == siMain.Ge… | DATA_OP | row.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-30c83aae | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:623 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BUILDING)) ▸ if (e.Column == siMain.Ge… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.POST_OPER_LT), sOperLT) | 그리드 값 설정 |  |  |  |
| AC-40e5ea99 | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:630 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-310b42f8 | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:631 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-7c016126 | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:632 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MATERIAL_ID), "") | 그리드 값 설정 |  |  |  |
| AC-0833a7b2 | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:633 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MODEL_ID), "") | 그리드 값 설정 |  |  |  |
| AC-67346d5c | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:634 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-092409fb | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:635 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-d23c3f2b | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:636 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-01b86a14 | spdMain.ComboSelChange | SSP0024_ShipmentMasterElectrode.cs:640 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_CODE), siMain.GetValue(e.Row, siMain.G… | 그리드 값 설정 |  |  |  |

## SSP0024_ShipmentMasterElectrode.SpdMain_KeyPress

진입점: spdMain.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-837309c7 | spdMain.KeyPress | SSP0024_ShipmentMasterElectrode.cs:652 | if (!fps.ActiveSheet.Cells[fps.ActiveSheet.ActiveRow.Index, fps.ActiveSheet.ActiveColumn.Index].Locked) ▸ if (fps.ActiveSheet.Columns[fps.Ac… | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-7dbd3d84 | spdMain.KeyPress | SSP0024_ShipmentMasterElectrode.cs:654 | if (!fps.ActiveSheet.Cells[fps.ActiveSheet.ActiveRow.Index, fps.ActiveSheet.ActiveColumn.Index].Locked) ▸ if (fps.ActiveSheet.Columns[fps.Ac… | RETURN | return; |  | 처리 중단/반환 |  |  |  |


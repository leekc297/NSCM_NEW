# AS-IS 액션 대조표 — FPC0624

> 원천: `Doc/asisfacts/screens/FPC0624/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 166행 · 메서드 30 · 종류 FLAG 40 · DATA_OP 37 · GRID_INIT 25 · UI_MISC 17 · UI_PROP 10 · RETURN 8 · ENDPOINT 7 · POPUP 4 · COMBO_DATA 4 · LIST_REBIND 4 · GRID_BIND 3 · GRID_LOCK 3 · LIST_BIND 2 · MESSAGE 2 · ⚠ 의미 확인 필요 0


## FPC0624_ItemByInstancePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e7e0bc5 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0624_ItemByInstancePopup.cs:268 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-24a703c2 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0624_ItemByInstancePopup.cs:271 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c7f89c34 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0624_ItemByInstancePopup.cs:272 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-41d085d4 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0624_ItemByInstancePopup.cs:268 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-3c280bcb | this.btnButtonList.UsrButtonList_Click_Detected | FPC0624_ItemByInstancePopup.cs:271 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ed34a7bf | this.btnButtonList.UsrButtonList_Click_Detected | FPC0624_ItemByInstancePopup.cs:272 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0624_ItemByInstancePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-288b0be8 | this.Load | FPC0624_ItemByInstancePopup.cs:128 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8e8030c3 | this.Load | FPC0624_ItemByInstancePopup.cs:129 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-896dd32f | this.Load | FPC0624_ItemByInstancePopup.cs:130 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f9a635e | this.Load | FPC0624_ItemByInstancePopup.cs:128 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-65ef4141 | this.Load | FPC0624_ItemByInstancePopup.cs:129 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0047f8ee | this.Load | FPC0624_ItemByInstancePopup.cs:130 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0624_ItemByInstancePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3ac3939 | this.Load | FPC0624_ItemByInstancePopup.cs:123 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-4a82f093 | this.Load | FPC0624_ItemByInstancePopup.cs:123 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0624_ItemByInstancePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9137a9d9 | Dispose | FPC0624_ItemByInstancePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-5c652279 | Dispose | FPC0624_ItemByInstancePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0624_ItemByInstancePopup.Find_Data_Item

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / this.Load [try ▸ lambda] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-415bb372 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:238 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00902_ItemSetupAttr", "get_material_list", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] \| FP\Master… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9e600800 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:239 |  | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-8c48fcec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:238 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00466_ItemSetupAttr", "get_material_list", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] \| FP\Master… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c8afbb9a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:239 |  | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |

## FPC0624_ItemByInstancePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7018cfcf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:201 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8efa4714 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:206 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Item("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6f48cce4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:213 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-55de3d82 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:216 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-30cbf741 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:218 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-ba7482a3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:226 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-fa3f2944 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:232 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-c09c1adc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:201 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-78646a1f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:206 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Item("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ab09b669 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:213 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-10ac74ba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:216 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a8c3fdc0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:218 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4c078172 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:226 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-db2c89ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0624_ItemByInstancePopup.cs:232 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FPC0624_ItemByInstancePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7318a80 | this.Load | FPC0624_ItemByInstancePopup.cs:100 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7e88b9e5 | this.Load | FPC0624_ItemByInstancePopup.cs:102 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-551aa699 | this.Load | FPC0624_ItemByInstancePopup.cs:100 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4ea72c48 | this.Load | FPC0624_ItemByInstancePopup.cs:102 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0624_ItemByInstancePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adf3068a | this.Load | FPC0624_ItemByInstancePopup.cs:140 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-24bb40fd | this.Load | FPC0624_ItemByInstancePopup.cs:141 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1ab633b0 | this.Load | FPC0624_ItemByInstancePopup.cs:140 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63f75f21 | this.Load | FPC0624_ItemByInstancePopup.cs:141 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0624_ItemByInstancePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb245bd7 | (진입점 미연결) | FPC0624_ItemByInstancePopup.cs:160 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f674f8c4 | (진입점 미연결) | FPC0624_ItemByInstancePopup.cs:160 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0624_ItemByInstancePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fb8003e | this.Load | FPC0624_ItemByInstancePopup.cs:147 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bd86b56b | this.Load | FPC0624_ItemByInstancePopup.cs:148 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-d3a94142 | this.Load | FPC0624_ItemByInstancePopup.cs:152 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-a8e18f19 | this.Load | FPC0624_ItemByInstancePopup.cs:147 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e510b760 | this.Load | FPC0624_ItemByInstancePopup.cs:148 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-4c6e6c9a | this.Load | FPC0624_ItemByInstancePopup.cs:152 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0624_ItemByInstancePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da189cdb | this.spdMain.CellClick | FPC0624_ItemByInstancePopup.cs:283 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-13a65d3d | this.spdMain.CellClick | FPC0624_ItemByInstancePopup.cs:284 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-911e3e21 | this.spdMain.CellClick | FPC0624_ItemByInstancePopup.cs:287 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-1cfeb342 | this.spdMain.CellClick | FPC0624_ItemByInstancePopup.cs:283 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b899a1e8 | this.spdMain.CellClick | FPC0624_ItemByInstancePopup.cs:284 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6b30feb8 | this.spdMain.CellClick | FPC0624_ItemByInstancePopup.cs:287 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FPC0624_ItemByInstancePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6602d76 | this.spdMain.CellDoubleClick | FPC0624_ItemByInstancePopup.cs:293 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-ac720471 | this.spdMain.CellDoubleClick | FPC0624_ItemByInstancePopup.cs:294 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-de880c99 | this.spdMain.CellDoubleClick | FPC0624_ItemByInstancePopup.cs:297 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-081d7709 | this.spdMain.CellDoubleClick | FPC0624_ItemByInstancePopup.cs:300 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7bd8f717 | this.spdMain.CellDoubleClick | FPC0624_ItemByInstancePopup.cs:310 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-b13857b4 | this.spdMain.CellDoubleClick | FPC0624_ItemByInstancePopup.cs:293 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-5898aca2 | this.spdMain.CellDoubleClick | FPC0624_ItemByInstancePopup.cs:294 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cc0a5119 | this.spdMain.CellDoubleClick | FPC0624_ItemByInstancePopup.cs:297 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-8dd05603 | this.spdMain.CellDoubleClick | FPC0624_ItemByInstancePopup.cs:300 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f0369215 | this.spdMain.CellDoubleClick | FPC0624_ItemByInstancePopup.cs:310 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0624_ItemByInstancePopup.txtMaterial_TextChanged

진입점: this.txtMaterial.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a2052df | this.txtMaterial.TextChanged | FPC0624_ItemByInstancePopup.cs:323 |  | DATA_OP | Filter["ITEM_NAME"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-1358a3d7 | this.txtMaterial.TextChanged | FPC0624_ItemByInstancePopup.cs:323 |  | DATA_OP | Filter["ITEM_NAME"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e3d32d4 | .ctor | FPC0624_WorkCenterOperationByInstPopup.cs:154 |  | FLAG | this.sInstance | pInstance | 화면 필드/플래그 변경 |  |  |  |
| AC-bcae8ad8 | .ctor | FPC0624_WorkCenterOperationByInstPopup.cs:155 |  | FLAG | this.sNoFactory | pNoFactory | 화면 필드/플래그 변경 |  |  |  |
| AC-f4f55bbd | .ctor | FPC0624_WorkCenterOperationByInstPopup.cs:156 |  | FLAG | this.bFactoryVisibility | bFactoryDisplay | 화면 필드/플래그 변경 |  |  |  |
| AC-d358cb20 | .ctor | FPC0624_WorkCenterOperationByInstPopup.cs:158 |  | UI_PROP | SpdSheet.shtMain | pSheetName | 속성 shtMain 설정 |  |  |  |
| AC-5fc0f706 | .ctor | FPC0624_WorkCenterOperationByInstPopup.cs:161 | if (pSheetName.Equals("WorkCenterOperationFactory")) | FLAG | sSysFlag | "WORKCENTER_OPERATION_FACTORY" | 화면 필드/플래그 변경 |  |  |  |
| AC-281df4d3 | .ctor | FPC0624_WorkCenterOperationByInstPopup.cs:163 | else of (pSheetName.Equals("WorkCenterOperationFactory")) | FLAG | sSysFlag | "WORKCENTER_OPERATION_FACTORY_NONE" | 화면 필드/플래그 변경 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60390d54 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0624_WorkCenterOperationByInstPopup.cs:455 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-9dc27667 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0624_WorkCenterOperationByInstPopup.cs:458 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb0677a4 | cboSite.SelectedIndexChanged | FPC0624_WorkCenterOperationByInstPopup.cs:433 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b1bb348 | cboSite.SelectedIndexChanged | FPC0624_WorkCenterOperationByInstPopup.cs:438 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-0012c0b3 | cboSite.SelectedIndexChanged | FPC0624_WorkCenterOperationByInstPopup.cs:442 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-e57d247e | cboSite.SelectedIndexChanged | FPC0624_WorkCenterOperationByInstPopup.cs:442 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-735f0c9e | cboSite.SelectedIndexChanged | FPC0624_WorkCenterOperationByInstPopup.cs:443 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, cboFactory, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0a19ed1 | clbDivision.SelectedIndexChanged | FPC0624_WorkCenterOperationByInstPopup.cs:407 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc889fec | clbDivision.SelectedIndexChanged | FPC0624_WorkCenterOperationByInstPopup.cs:410 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-995b1b91 | clbDivision.SelectedIndexChanged | FPC0624_WorkCenterOperationByInstPopup.cs:411 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-435b87f0 | clbDivision.SelectedIndexChanged | FPC0624_WorkCenterOperationByInstPopup.cs:415 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc0d1d7d | clbDivision.SelectedIndexChanged | FPC0624_WorkCenterOperationByInstPopup.cs:418 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-0a916b71 | clbDivision.SelectedIndexChanged | FPC0624_WorkCenterOperationByInstPopup.cs:418 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c473fbb6 | clbDivision.SelectedIndexChanged | FPC0624_WorkCenterOperationByInstPopup.cs:419 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, cboFactory, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a04a981c | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:271 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dac9986d | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:272 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea4f991e | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:273 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85f5fafd | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:243 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-115a12a3 | Dispose | FPC0624_WorkCenterOperationByInstPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b590d7c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:321 |  | UI_PROP | this.sDivision | CString.GetCheckedListValue(dtMyDivision, clbDivision.ControlValues) | 속성 sDivision 설정 |  |  |  |
| AC-81a4cf67 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:322 |  | UI_PROP | this.sSite | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 속성 sSite 설정 |  |  |  |
| AC-a56b2407 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:323 |  | FLAG | this.sFactory | CString.GetCheckedListValue(dtFactory, cboFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-cc26e208 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:324 |  | FLAG | this.sOperation | txtOperation.Text.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-216409d9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:329 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0db41bfe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:330 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c6d479ed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:333 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-7fde9a71 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:335 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Common.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-807ca065 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:339 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Common.PR_UI_COMMON_POPUP") ⇒ FP_Common.PR_UI_COMMON_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-a10eb6a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:341 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b9b9d0dd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:343 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-56022250 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:344 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-844b29e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:345 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d27e2e11 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:346 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6cb48f50 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:347 | lambda | DATA_OP | request.Parameters["p_non_auth"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7b4fdae8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:348 | lambda | DATA_OP | request.Parameters["p_save_auth"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a76a2973 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:349 | lambda | DATA_OP | request.Parameters["p_param1"] | sCompany | 행/컬럼 값 대입 |  |  |  |
| AC-e34a15d5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:350 | lambda | DATA_OP | request.Parameters["p_param2"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-6241760f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:351 | lambda | DATA_OP | request.Parameters["p_param3"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-5f9a3e73 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:352 | lambda | DATA_OP | request.Parameters["p_param4"] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-77fcf6b0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:353 | lambda | DATA_OP | request.Parameters["p_param5"] | sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-c6b565de | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:354 | lambda | DATA_OP | request.Parameters["p_param6"] | sNoFactory | 행/컬럼 값 대입 |  |  |  |
| AC-42b6c4c4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:355 | lambda | DATA_OP | request.Parameters["p_param7"] | sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-bcf8a4fc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:356 | lambda | DATA_OP | request.Parameters["p_param8"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-f9641fc2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:357 | lambda | DATA_OP | request.Parameters["p_param9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-67f7e24c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:358 | lambda | DATA_OP | request.Parameters["p_param10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-05742ce9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:359 | lambda | DATA_OP | request.Parameters["p_param11"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-675302a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:360 | lambda | DATA_OP | request.Parameters["p_param12"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7bff1bd2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:361 | lambda | DATA_OP | request.Parameters["p_param13"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a0fec49e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:362 | lambda | DATA_OP | request.Parameters["p_param14"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7ebb2c7a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:363 | lambda | DATA_OP | request.Parameters["p_param15"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8cd94b59 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:364 | lambda | DATA_OP | request.Parameters["p_param16"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3a8dcfc7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:365 | lambda | DATA_OP | request.Parameters["p_param17"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-289f72ea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:366 | lambda | DATA_OP | request.Parameters["p_param18"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-925ed849 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:367 | lambda | DATA_OP | request.Parameters["p_param19"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b1847c18 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:368 | lambda | DATA_OP | request.Parameters["p_param20"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-dc6e8c7d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:369 | lambda | DATA_OP | request.Parameters["TimeZone"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ec84069b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:371 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-27d6beee | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:373 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5450f4d6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:378 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8812e375 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:381 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-605aa57f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:386 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-39714afa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:388 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e080ff9 | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:172 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf77e490 | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:174 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2104de4 | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:204 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-000a4b81 | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:206 | if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-e80762a7 | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:232 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-7643da6b | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:232 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fb52eed4 | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:233 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, cboFactory, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4b41dd6a | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:237 | if (this.bFactoryVisibility==false) | UI_PROP | lblFactory.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-737b8197 | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:248 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a621be7 | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:283 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cffa5c85 | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:284 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-326d2a06 | (진입점 미연결) | FPC0624_WorkCenterOperationByInstPopup.cs:306 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.SetOperationInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-799771f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:500 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b028c49 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:501 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-290815b4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:507 |  | FLAG | _FactoryId | this.dtFindData.Rows[iClick_Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-51be7aa1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:508 |  | FLAG | _OperationId | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-063e0467 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:509 |  | FLAG | _OperationName | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-251af033 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:510 |  | FLAG | _OperationGroupId | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_GROUP_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a86adce0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0624_WorkCenterOperationByInstPopup.cs:513 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-783b7117 | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:291 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17f08a94 | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:292 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-64243d55 | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:296 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-a4126d03 | this.Load | FPC0624_WorkCenterOperationByInstPopup.cs:297 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8eca49cc | this.spdMain.CellClick | FPC0624_WorkCenterOperationByInstPopup.cs:469 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0624_WorkCenterOperationByInstPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f29b79ab | this.spdMain.CellDoubleClick | FPC0624_WorkCenterOperationByInstPopup.cs:474 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-e23e51d9 | this.spdMain.CellDoubleClick | FPC0624_WorkCenterOperationByInstPopup.cs:476 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58f7a3ff | this.spdMain.CellDoubleClick | FPC0624_WorkCenterOperationByInstPopup.cs:482 |  | FLAG | _FactoryId | this.dtFindData.Rows[e.Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-685e3c33 | this.spdMain.CellDoubleClick | FPC0624_WorkCenterOperationByInstPopup.cs:483 |  | FLAG | _OperationId | this.dtFindData.Rows[e.Row][DefColumns.OPERATION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4b1357e7 | this.spdMain.CellDoubleClick | FPC0624_WorkCenterOperationByInstPopup.cs:484 |  | FLAG | _OperationGroupId | this.dtFindData.Rows[e.Row][DefColumns.OPERATION_GROUP_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-33aa4f16 | this.spdMain.CellDoubleClick | FPC0624_WorkCenterOperationByInstPopup.cs:489 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |


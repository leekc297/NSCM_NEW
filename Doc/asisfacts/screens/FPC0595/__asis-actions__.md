# AS-IS 액션 대조표 — FPC0595

> 원천: `Doc/asisfacts/screens/FPC0595/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 71행 · 메서드 23 · 종류 FLAG 16 · GRID_INIT 16 · UI_MISC 12 · DATA_OP 10 · ENDPOINT 4 · VALUE_SET 3 · UI_PROP 2 · POPUP 2 · GRID_BIND 2 · GRID_LOCK 2 · RETURN 2 · ⚠ 의미 확인 필요 0


## FPC0595_EquipmentPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8412afb | this.btnButtonList.UsrButtonList_Click_Detected | FPC0595_EquipmentPopup.cs:257 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ef3b0c83 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0595_EquipmentPopup.cs:260 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-20b4197f | this.btnButtonList.UsrButtonList_Click_Detected | FPC0595_EquipmentPopup.cs:261 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0595_EquipmentPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c77cbe3 | this.Load | FPC0595_EquipmentPopup.cs:133 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5fa145ee | this.Load | FPC0595_EquipmentPopup.cs:134 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-71e40529 | this.Load | FPC0595_EquipmentPopup.cs:135 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0595_EquipmentPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-905a9ab8 | this.Load | FPC0595_EquipmentPopup.cs:128 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0595_EquipmentPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acbb3044 | Dispose | FPC0595_EquipmentPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0595_EquipmentPopup.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7f3036c | this.Load 외 2 | FPC0595_EquipmentPopup.cs:204 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-12b5959a | this.Load 외 2 | FPC0595_EquipmentPopup.cs:207 |  | DATA_OP | Filter["FACTORY_ID"] | txtFactory.Text | 행/컬럼 값 대입 |  |  |  |
| AC-1b9ead3f | this.Load 외 2 | FPC0595_EquipmentPopup.cs:208 |  | DATA_OP | Filter["OPERATION_ID"] | txtOperation.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b5b80b9d | this.Load 외 2 | FPC0595_EquipmentPopup.cs:209 |  | DATA_OP | Filter["LINE_ID"] | txtLine.Text | 행/컬럼 값 대입 |  |  |  |
| AC-81b0d9de | this.Load 외 2 | FPC0595_EquipmentPopup.cs:210 |  | DATA_OP | Filter["EQUIPMENT_ID"] | txtEquipment.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d5b69b19 | this.Load 외 2 | FPC0595_EquipmentPopup.cs:213 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => Data_FP.CallGeneralProcedure("PR_UI_FP00595_EQUIPMENT", Filter, UserInfoContext.Cur… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3148156a | this.Load 외 2 | FPC0595_EquipmentPopup.cs:214 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00595_EQUIPMENT", Filter, UserInfoContext.Current.UserId, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e2b1cc6c | this.Load 외 2 | FPC0595_EquipmentPopup.cs:220 | if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c546cdca | this.Load 외 2 | FPC0595_EquipmentPopup.cs:223 | if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-69bc1555 | this.Load 외 2 | FPC0595_EquipmentPopup.cs:225 | if (ds.Tables[0].Rows.Count > 0) | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-8f333114 | this.Load 외 2 | FPC0595_EquipmentPopup.cs:229 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0595_EquipmentPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75aae55c | this.Load | FPC0595_EquipmentPopup.cs:103 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4a1d8dbe | this.Load | FPC0595_EquipmentPopup.cs:105 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0595_EquipmentPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43d29173 | this.Load | FPC0595_EquipmentPopup.cs:120 |  | VALUE_SET | txtFactory.Text | Filter["FACTORY_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-d4f71f88 | this.Load | FPC0595_EquipmentPopup.cs:121 |  | VALUE_SET | txtOperation.Text | Filter["OPERATION_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-6859a147 | this.Load | FPC0595_EquipmentPopup.cs:122 |  | VALUE_SET | txtLine.Text | Filter["LINE_ID"] | 컨트롤 값 설정 |  |  |  |

## FPC0595_EquipmentPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-088ccb8f | this.Load | FPC0595_EquipmentPopup.cs:145 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d5690878 | this.Load | FPC0595_EquipmentPopup.cs:146 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0595_EquipmentPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdb8e1a4 | (진입점 미연결) | FPC0595_EquipmentPopup.cs:165 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0595_EquipmentPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19e1494f | this.Load | FPC0595_EquipmentPopup.cs:152 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61fa7261 | this.Load | FPC0595_EquipmentPopup.cs:153 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-1b38a205 | this.Load | FPC0595_EquipmentPopup.cs:157 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0595_EquipmentPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39b2c31c | this.spdMain.CellClick | FPC0595_EquipmentPopup.cs:272 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-48c1c75f | this.spdMain.CellClick | FPC0595_EquipmentPopup.cs:273 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-20f506b0 | this.spdMain.CellClick | FPC0595_EquipmentPopup.cs:276 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FPC0595_EquipmentPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-366362b1 | this.spdMain.CellDoubleClick | FPC0595_EquipmentPopup.cs:282 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-0f83062f | this.spdMain.CellDoubleClick | FPC0595_EquipmentPopup.cs:283 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5c83fb08 | this.spdMain.CellDoubleClick | FPC0595_EquipmentPopup.cs:286 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-248a3f2f | this.spdMain.CellDoubleClick | FPC0595_EquipmentPopup.cs:289 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb1cc554 | this.spdMain.CellDoubleClick | FPC0595_EquipmentPopup.cs:299 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0595_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d890aa6 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0595_ItemPopup.cs:250 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-2ef3f0cd | this.btnButtonList.UsrButtonList_Click_Detected | FPC0595_ItemPopup.cs:253 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-00c2fe84 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0595_ItemPopup.cs:254 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0595_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c2b17be | this.Load | FPC0595_ItemPopup.cs:129 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-04b28e3b | this.Load | FPC0595_ItemPopup.cs:130 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1c1aadd0 | this.Load | FPC0595_ItemPopup.cs:131 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0595_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90653e8a | this.Load | FPC0595_ItemPopup.cs:124 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0595_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f674de45 | Dispose | FPC0595_ItemPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0595_ItemPopup.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-764d335c | this.Load 외 2 | FPC0595_ItemPopup.cs:200 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1f6adce4 | this.Load 외 2 | FPC0595_ItemPopup.cs:203 |  | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-5f6a7f2b | this.Load 외 2 | FPC0595_ItemPopup.cs:204 |  | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b1ebc680 | this.Load 외 2 | FPC0595_ItemPopup.cs:207 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => Data_FP.CallGeneralProcedure("PR_UI_FP00595_ITEM", Filter, UserInfoContext.Current.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a7adfedd | this.Load 외 2 | FPC0595_ItemPopup.cs:208 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00595_ITEM", Filter, UserInfoContext.Current.UserId, "SELECT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9bb47e44 | this.Load 외 2 | FPC0595_ItemPopup.cs:213 | if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-10891a42 | this.Load 외 2 | FPC0595_ItemPopup.cs:216 | if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-41021272 | this.Load 외 2 | FPC0595_ItemPopup.cs:218 | if (ds.Tables[0].Rows.Count > 0) | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-92af83bd | this.Load 외 2 | FPC0595_ItemPopup.cs:222 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0595_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c651f87c | this.Load | FPC0595_ItemPopup.cs:102 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7eb40518 | this.Load | FPC0595_ItemPopup.cs:104 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0595_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-929fb3f2 | this.Load | FPC0595_ItemPopup.cs:141 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-08af5157 | this.Load | FPC0595_ItemPopup.cs:142 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0595_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f66606b | (진입점 미연결) | FPC0595_ItemPopup.cs:161 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0595_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc632ec2 | this.Load | FPC0595_ItemPopup.cs:148 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a27da434 | this.Load | FPC0595_ItemPopup.cs:149 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-b18c49df | this.Load | FPC0595_ItemPopup.cs:153 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0595_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-826c9db9 | this.spdMain.CellClick | FPC0595_ItemPopup.cs:265 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-3eaaca42 | this.spdMain.CellClick | FPC0595_ItemPopup.cs:266 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c4365850 | this.spdMain.CellClick | FPC0595_ItemPopup.cs:269 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FPC0595_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb187104 | this.spdMain.CellDoubleClick | FPC0595_ItemPopup.cs:275 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-53bc6e59 | this.spdMain.CellDoubleClick | FPC0595_ItemPopup.cs:276 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-44598aac | this.spdMain.CellDoubleClick | FPC0595_ItemPopup.cs:279 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-929b4b3b | this.spdMain.CellDoubleClick | FPC0595_ItemPopup.cs:282 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63b81aaf | this.spdMain.CellDoubleClick | FPC0595_ItemPopup.cs:292 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |


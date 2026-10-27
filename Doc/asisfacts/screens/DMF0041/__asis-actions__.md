# AS-IS 액션 대조표 — DMF0041

> 원천: `Doc/asisfacts/screens/DMF0041/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 360행 · 메서드 43 · 종류 DATA_OP 76 · GRID_SET 38 · RETURN 35 · FLAG 32 · UI_PROP 27 · MESSAGE 22 · POPUP 20 · ENDPOINT 19 · CALL_EXT 17 · GRID_LOCK 16 · GRID_INIT 11 · UI_MISC 11 · GRID_BIND 7 · GRID_COMBO 7 · COMBO_DATA 7 · VALUE_SET 5 · GRID_STYLE 5 · LIST_REBIND 4 · THROW 1 · ⚠ 의미 확인 필요 17


## DMF0041_DMS_SalesSet_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbbc0086 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:159 | if (_Flag == "") | GRID_INIT | this.AddSheet | (spdBase, SpdSheet.shtBase, SpdSheet.shtBase, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cac9ef75 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:160 | if (_Flag == "") | GRID_INIT | this.AddSheet | (spdUser, SpdSheet.shtUser, SpdSheet.shtUser, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0fef2a93 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:164 | else of (_Flag == "") | GRID_INIT | this.AddSheet | (spdBase, SpdSheet.shtAppBase, SpdSheet.shtAppBase, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b2b99af4 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:165 | else of (_Flag == "") | GRID_INIT | this.AddSheet | (spdUser, SpdSheet.shtAppUser, SpdSheet.shtAppUser, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0334f354 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:168 |  | FLAG | siBase | GetSheetInfo(spdBase.Name, spdBase.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-04ef6286 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:169 |  | FLAG | siUser | GetSheetInfo(spdUser.Name, spdUser.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e171ec9 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:171 |  | GRID_INIT | siBase.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f93098c5 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:172 |  | GRID_INIT | siUser.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc993781 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:150 | if (_Flag == "") | VALUE_SET | this.usrLabel1.Text | "Dms Sales : " | 컨트롤 값 설정 |  |  |  |
| AC-1a2d9375 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:152 | else of (_Flag == "") | VALUE_SET | this.usrLabel1.Text | "Application : " | 컨트롤 값 설정 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be7641bf | Dispose | DMF0041_DMS_SalesSet_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82602dc7 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:115 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1883ef91 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:117 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a1a791b4 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:128 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-bea31809 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:133 |  | FLAG | _Division | sDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-7c5492f8 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:134 |  | FLAG | _Dms_sales | sDmsSales | 화면 필드/플래그 변경 |  |  |  |
| AC-7c03f0dc | this.Load | DMF0041_DMS_SalesSet_Popup.cs:139 |  | FLAG | _Division | sDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-3fdd3b58 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:140 |  | FLAG | _Dms_sales | sDmsSales | 화면 필드/플래그 변경 |  |  |  |
| AC-470510c8 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:141 |  | FLAG | _Flag | strFlag | 화면 필드/플래그 변경 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.GetApplication

진입점: this.Load [else of (_Flag == "")] / FindButton [else of (_Flag == "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-597177a1 | this.Load [else of (_Flag == "")] 외 1 | DMF0041_DMS_SalesSet_Popup.cs:338 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0041_GET_APPLICATION_POPUP") ⇒ DM.DMF0041_GET_APPLICATION_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-50ab3cdf | this.Load [else of (_Flag == "")] 외 1 | DMF0041_DMS_SalesSet_Popup.cs:339 |  | DATA_OP | request.Parameters["p_division_id"] | _Division | 행/컬럼 값 대입 |  |  |  |
| AC-f5d6e013 | this.Load [else of (_Flag == "")] 외 1 | DMF0041_DMS_SalesSet_Popup.cs:340 |  | DATA_OP | request.Parameters["p_app"] | _Dms_sales | 행/컬럼 값 대입 |  |  |  |
| AC-f19330be | this.Load [else of (_Flag == "")] 외 1 | DMF0041_DMS_SalesSet_Popup.cs:341 |  | DATA_OP | request.Parameters["p_search"] | sSearch | 행/컬럼 값 대입 |  |  |  |
| AC-5cf93090 | this.Load [else of (_Flag == "")] 외 1 | DMF0041_DMS_SalesSet_Popup.cs:343 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-46b0b5c4 | this.Load [else of (_Flag == "")] 외 1 | DMF0041_DMS_SalesSet_Popup.cs:351 | if ((ds != null)) | GRID_BIND | siBase.Query | (ds.Tables[0]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fb37e806 | this.Load [else of (_Flag == "")] 외 1 | DMF0041_DMS_SalesSet_Popup.cs:356 | if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[1].Rows.Count > 0)) | GRID_BIND | siUser.Query | (ds.Tables[1]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-233bcb49 | this.Load [else of (_Flag == "")] 외 1 | DMF0041_DMS_SalesSet_Popup.cs:359 |  | GRID_LOCK | siBase.LockColumn | (0, siBase.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-851c9fc5 | this.Load [else of (_Flag == "")] 외 1 | DMF0041_DMS_SalesSet_Popup.cs:360 |  | GRID_LOCK | siUser.LockColumn | (0, siUser.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.GetOwnerData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load [if (_Flag == "")] / FindButton [if (_Flag == "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e76adc52 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0041_DMS_SalesSet_Popup.cs:281 | if (!Flag) | FLAG | DMS_Sales | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-d57e85ca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0041_DMS_SalesSet_Popup.cs:285 | if (!Flag) ▸ for (iRow <= siUser.GetMaxRowIndex()) ▸ if (iRow == 0) | FLAG | DMS_Sales | siUser.GetValue(iRow, siUser.GetColumnIndex(DefColumns.DMS_SALES)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-69a689b6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0041_DMS_SalesSet_Popup.cs:287 | if (!Flag) ▸ for (iRow <= siUser.GetMaxRowIndex()) ▸ else of (iRow == 0) | FLAG | DMS_Sales | DMS_Sales + "," + siUser.GetValue(iRow, siUser.GetColumnIndex(DefColumns.DMS_SALES)).ToStr… | 화면 필드/플래그 변경 |  |  |  |
| AC-3d051507 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0041_DMS_SalesSet_Popup.cs:301 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0041_GET_DMS_SAELS_POPUP") ⇒ DM.DMF0041_GET_DMS_SAELS_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-9089cfad | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0041_DMS_SalesSet_Popup.cs:302 |  | DATA_OP | request.Parameters["p_division_id"] | _Division | 행/컬럼 값 대입 |  |  |  |
| AC-1e7d6b62 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0041_DMS_SalesSet_Popup.cs:303 |  | DATA_OP | request.Parameters["p_dms_sales"] | _Dms_sales | 행/컬럼 값 대입 |  |  |  |
| AC-c7346b69 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0041_DMS_SalesSet_Popup.cs:304 |  | DATA_OP | request.Parameters["p_search"] | sSearch | 행/컬럼 값 대입 |  |  |  |
| AC-1e82ca4d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0041_DMS_SalesSet_Popup.cs:306 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-df4ff12f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0041_DMS_SalesSet_Popup.cs:314 | if ((ds != null)) | GRID_BIND | siBase.Query | (ds.Tables[0]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-22df2555 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0041_DMS_SalesSet_Popup.cs:319 | if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[1].Rows.Count > 0) && (Flag == true)) | GRID_BIND | siUser.Query | (ds.Tables[1]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b19c8283 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0041_DMS_SalesSet_Popup.cs:322 |  | GRID_LOCK | siBase.LockColumn | (0, siBase.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2d728211 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0041_DMS_SalesSet_Popup.cs:323 |  | GRID_LOCK | siUser.LockColumn | (0, siUser.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.GetSpdTitle

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a68bddf | this.Load | DMF0041_DMS_SalesSet_Popup.cs:240 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-310d5809 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:241 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9a5a0773 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:242 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c804f990 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:243 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f9a5ab9d | this.Load | DMF0041_DMS_SalesSet_Popup.cs:244 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0041" | 행/컬럼 값 대입 |  |  |  |
| AC-a6495abe | this.Load | DMF0041_DMS_SalesSet_Popup.cs:245 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-b95a770e | this.Load | DMF0041_DMS_SalesSet_Popup.cs:246 |  | DATA_OP | request.Parameters["p_division_id"] | _Division | 행/컬럼 값 대입 |  |  |  |
| AC-a09fdc24 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:248 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-52b52304 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:250 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c47f5a30 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:188 |  | UI_PROP | pnlBottom.Dock | DockStyle.Bottom | 속성 Dock 설정 |  |  |  |
| AC-05efd1e5 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:190 |  | UI_PROP | pnlCenter.Dock | DockStyle.Left | 속성 Dock 설정 |  |  |  |
| AC-3d071833 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:192 |  | UI_PROP | pnlSearch.Dock | DockStyle.Top | 속성 Dock 설정 |  |  |  |
| AC-188b2935 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:194 |  | UI_PROP | spdBase.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-da6a5b74 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:195 |  | UI_PROP | spdUser.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-7b5fb071 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:196 |  | UI_PROP | splMain.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-988206d0 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:198 |  | UI_PROP | this.Size | new Size(850, 400) | 속성 Size 설정 |  |  |  |
| AC-6b4f8e46 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:202 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth)) | 속성 SplitterDistance 설정 |  |  |  |
| AC-2b024374 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:203 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth) / 2) | 속성 SplitterDistance 설정 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96ca1124 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:182 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-dc5e1606 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:183 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.ResetWidth

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17a8dc14 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:273 |  | UI_PROP | this.Width | += iWidth | 속성 Width 설정 |  |  |  |
| AC-33470163 | this.Load | DMF0041_DMS_SalesSet_Popup.cs:274 |  | UI_PROP | splMain.SplitterDistance | this.Width / 2 - iWidth2 | 속성 SplitterDistance 설정 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.SaveTitleSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccd6e743 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DMF0041_DMS_SalesSet_Popup.cs:528 | if (siUser.GetMaxRowIndex() != -1) ▸ if (_Flag == "") ▸ for (i <= siUser.GetMaxRowIndex()) ▸ if (DMS_Sales == "") | FLAG | DMS_Sales | siUser.GetValue(i, siUser.GetColumnIndex(DefColumns.DMS_SALES)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-64fffcb4 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DMF0041_DMS_SalesSet_Popup.cs:530 | if (siUser.GetMaxRowIndex() != -1) ▸ if (_Flag == "") ▸ for (i <= siUser.GetMaxRowIndex()) ▸ else of (DMS_Sales == "") | FLAG | DMS_Sales | DMS_Sales + "," + siUser.GetValue(i, siUser.GetColumnIndex(DefColumns.DMS_SALES)).ToString… | 화면 필드/플래그 변경 |  |  |  |
| AC-ee9119a9 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DMF0041_DMS_SalesSet_Popup.cs:538 | if (siUser.GetMaxRowIndex() != -1) ▸ else of (_Flag == "") ▸ for (i <= siUser.GetMaxRowIndex()) ▸ if (DMS_Sales == "") | FLAG | DMS_Sales | siUser.GetValue(i, siUser.GetColumnIndex(DefColumns.APPLICATION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-59c86bbc | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DMF0041_DMS_SalesSet_Popup.cs:540 | if (siUser.GetMaxRowIndex() != -1) ▸ else of (_Flag == "") ▸ for (i <= siUser.GetMaxRowIndex()) ▸ else of (DMS_Sales == "") | FLAG | DMS_Sales | DMS_Sales + "," + siUser.GetValue(i, siUser.GetColumnIndex(DefColumns.APPLICATION)).ToStri… | 화면 필드/플래그 변경 |  |  |  |
| AC-83bb8c03 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DMF0041_DMS_SalesSet_Popup.cs:546 | else of (siUser.GetMaxRowIndex() != -1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-75cc2ab5 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | DMF0041_DMS_SalesSet_Popup.cs:547 | else of (siUser.GetMaxRowIndex() != -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.setBaseSort

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f42c020a | (진입점 미연결) | DMF0041_DMS_SalesSet_Popup.cs:98 |  | FLAG | _isBaseSort | isBool | 화면 필드/플래그 변경 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.SetTitleSet

진입점: this.spdBase.CellDoubleClick / this.spdUser.CellDoubleClick / this.btnRight.Click / this.btnLeft.Click / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b48118c | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:376 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'N'", DefColumns.SORT_ORDER_NO) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8dfe28c | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:376 |  | DATA_OP | _dtTitleSet.Select(sFilterColumn + " = 'N'", DefColumns.SORT_ORDER_NO).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b75cc458 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:376 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'N'", DefColumns.SORT_ORDER_NO) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c48174c | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:377 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'Y'", sSortColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-b49c7e2a | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:377 |  | DATA_OP | _dtTitleSet.Select(sFilterColumn + " = 'Y'", sSortColumn).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a19e2218 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:377 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'Y'", sSortColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f7b4bb3 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:381 | if (dtBase == null) | GRID_SET | spdBase.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-dc3347d5 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:383 | else of (dtBase == null) | GRID_BIND | si.Query | (dtBase) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f7eaea7c | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:387 | if (dtUser == null) | GRID_SET | spdUser.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-2831931d | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:389 | else of (dtUser == null) | GRID_BIND | si.Query | (dtUser) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-99e3e453 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:398 | for (r < svSource.Rows.Count) ▸ if (svSource.Cells[r, svSource.Columns["SUB_TOTAL_FLAG"].Index].Text == "Y") | GRID_SET | svSource.Cells[r, svSource.Columns["SUB_TOTAL_FLAG"].Index].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-bc69e252 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:402 | if (spdUser.Sheets[0].RowCount > 0) | GRID_SET | spdUser.Sheets[0].ActiveRowIndex | spdUser.Sheets[0].RowCount - 1 | 그리드 속성/값 설정 |  |  |  |
| AC-4a5d24f4 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:409 |  | CALL_EXT | svSource.GetSelections().GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1206f61f | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:410 | if (svSource.GetSelections().GetLength(0) == 0) | CALL_EXT | svSource.AddSelection | (svSource.ActiveRowIndex, svSource.ActiveColumnIndex, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9dd3c196 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:422 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-17cae341 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:426 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns[DefColumns.SORT_ORDER_NO].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-ea7aed30 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:428 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef06770f | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:429 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns[DefColumns.SORT_ORDER_NO].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-9c5e97d1 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:440 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-314e699d | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:441 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns[DefColumns.SORT_ORDER_NO].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-006646f0 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:443 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-209a04c3 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:444 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns[DefColumns.SORT_ORDER_NO].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-af0fdacd | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:475 | foreach (int i in selectIndex.Keys) ▸ else of (activeRow + 1 >= svTarget.RowCount) | DATA_OP | svTarget.Rows.Add | (activeRow + 1, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-df2bb99f | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:479 | foreach (int i in selectIndex.Keys) ▸ if (_Flag == "") | GRID_SET | svTarget.Cells[iRow, svTarget.Columns[DefColumns.DMS_SALES].Index].Text | sDMS_SALES | 그리드 속성/값 설정 |  |  |  |
| AC-59ee1ce6 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:481 | foreach (int i in selectIndex.Keys) ▸ else of (_Flag == "") | GRID_SET | svTarget.Cells[iRow, svTarget.Columns[DefColumns.APPLICATION].Index].Text | sDMS_SALES | 그리드 속성/값 설정 |  |  |  |
| AC-d0f992ef | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:483 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns[DefColumns.SORT_ORDER_NO].Index].Text | sSortOrderNo | 그리드 속성/값 설정 |  |  |  |
| AC-22b9af83 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:487 |  | GRID_STYLE | svTarget.SetActiveCell | (activeRow, -1) | 그리드 표시 설정 |  |  |  |
| AC-3f6279a4 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:492 | for (i >= 0) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-619daa7f | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:494 | for (i >= 0) ▸ if (selectIndex.ContainsKey(i)) | CALL_EXT | svSource.RemoveRows | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d56928e3 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:499 | if (_isBaseSort == true) | CALL_EXT | svTarget.SortRows | (svTarget.Columns[DefColumns.SORT_ORDER_NO].Index, true, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fde58a16 | this.spdBase.CellDoubleClick 외 4 | DMF0041_DMS_SalesSet_Popup.cs:503 | else of (_isBaseSort == true) ▸ if (svTarget == spdBase.Sheets[0]) | CALL_EXT | svTarget.SortRows | (svTarget.Columns[DefColumns.SORT_ORDER_NO].Index, true, false) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.spdUser_ButtonClicked

진입점: this.spdUser.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c09617f | this.spdUser.ButtonClicked | DMF0041_DMS_SalesSet_Popup.cs:583 | if (e.Column != sv.Columns["SUB_TOTAL_FLAG"].Index) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b2801447 | this.spdUser.ButtonClicked | DMF0041_DMS_SalesSet_Popup.cs:587 | for (i < sv.RowCount) | GRID_SET | sv.Cells[i, e.Column].Value | "false" | 그리드 속성/값 설정 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.spdUser_RowDragMove

진입점: this.spdUser.RowDragMove

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d32ef3ae | this.spdUser.RowDragMove | DMF0041_DMS_SalesSet_Popup.cs:606 | if (sUserSelect != "Y") | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.TitleSetForm_SizeChanged

진입점: this.SizeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72f332e1 | this.SizeChanged | DMF0041_DMS_SalesSet_Popup.cs:593 |  | UI_PROP | pnlCenterButton.Top | (pnlCenter.Height - pnlCenterButton.Height) / 2 | 속성 Top 설정 |  |  |  |

## DMF0041_DMS_SalesSet_Popup.usrButtonList1_UsrButtonList_Click_Detected

진입점: this.usrButtonList1.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05b6ea42 | this.usrButtonList1.UsrButtonList_Click_Detected | DMF0041_DMS_SalesSet_Popup.cs:226 | switch (buttonItem.UserType) case ButtonListType.Cancel: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0041_MDF_Simulator.btnMDFVer_Click

진입점: this.btnMDFVer.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b25e2b48 | this.btnMDFVer.Click | DMF0041_MDF_Simulator.cs:805 |  | POPUP | new DM0041_MDFVersionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5a5d2bb7 | this.btnMDFVer.Click | DMF0041_MDF_Simulator.cs:806 |  | POPUP | popVersion.Form_Load | (true, "MDF", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ab0679be | this.btnMDFVer.Click | DMF0041_MDF_Simulator.cs:807 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6bc06294 | this.btnMDFVer.Click | DMF0041_MDF_Simulator.cs:808 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b178e0a3 | this.btnMDFVer.Click | DMF0041_MDF_Simulator.cs:812 | if (popVersion.sVersions != "") | VALUE_SET | txtMDFVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |

## DMF0041_MDF_Simulator.btnMDFVersion_Click

진입점: this.btnMDFVersion.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e9b6310 | this.btnMDFVersion.Click | DMF0041_MDF_Simulator.cs:1159 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00266") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc5a9d52 | this.btnMDFVersion.Click | DMF0041_MDF_Simulator.cs:1160 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f7c203f | this.btnMDFVersion.Click | DMF0041_MDF_Simulator.cs:1168 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.VersionCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-772bbece | this.btnMDFVersion.Click | DMF0041_MDF_Simulator.cs:1170 |  | CALL_EXT | popup.LoadData | (sVersion_Type, sFoxData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-89f10cff | this.btnMDFVersion.Click | DMF0041_MDF_Simulator.cs:1171 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e74e1436 | this.btnMDFVersion.Click | DMF0041_MDF_Simulator.cs:1172 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0041_MDF_Simulator.btnSPVer_Click

진입점: this.btnSPVer.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83bce9a9 | this.btnSPVer.Click | DMF0041_MDF_Simulator.cs:822 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dffea2e0 | this.btnSPVer.Click | DMF0041_MDF_Simulator.cs:823 |  | POPUP | popVersion.Form_Load | (true, "SP", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6691f58d | this.btnSPVer.Click | DMF0041_MDF_Simulator.cs:824 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b352f859 | this.btnSPVer.Click | DMF0041_MDF_Simulator.cs:825 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dbc2ee22 | this.btnSPVer.Click | DMF0041_MDF_Simulator.cs:829 | if (popVersion.sVersions != "") | VALUE_SET | txtSPVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |

## DMF0041_MDF_Simulator.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e20bedc | this.Load | DMF0041_MDF_Simulator.cs:149 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ad3ac341 | this.Load | DMF0041_MDF_Simulator.cs:150 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-49989d92 | this.Load | DMF0041_MDF_Simulator.cs:151 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0041_MDF_Simulator.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-488fb149 | this.Load | DMF0041_MDF_Simulator.cs:140 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-e94a3f69 | this.Load | DMF0041_MDF_Simulator.cs:141 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-f6aeeaf2 | this.Load | DMF0041_MDF_Simulator.cs:142 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-bb3d9d20 | this.Load | DMF0041_MDF_Simulator.cs:143 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## DMF0041_MDF_Simulator.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d36bf7b1 | DeleteButton | DMF0041_MDF_Simulator.cs:252 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸ for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-16b61cfb | DeleteButton | DMF0041_MDF_Simulator.cs:253 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸ for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d43aa2d1 | DeleteButton | DMF0041_MDF_Simulator.cs:262 | else of (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸ for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-1fe1b87e | DeleteButton | DMF0041_MDF_Simulator.cs:263 | else of (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸ for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0041_MDF_Simulator.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e39eba65 | Dispose | DMF0041_MDF_Simulator.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0041_MDF_Simulator.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-447c2f44 | EditButton | DMF0041_MDF_Simulator.cs:276 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-415a8b02 | EditButton | DMF0041_MDF_Simulator.cs:277 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4a24f39 | EditButton | DMF0041_MDF_Simulator.cs:281 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a51ce772 | EditButton | DMF0041_MDF_Simulator.cs:282 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-d064403c | EditButton | DMF0041_MDF_Simulator.cs:291 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sEdit == CAppSetting.StringY) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b02021eb | EditButton | DMF0041_MDF_Simulator.cs:292 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sEdit == CAppSetting.StringY) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.APPLICATION), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-328e2754 | EditButton | DMF0041_MDF_Simulator.cs:294 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sEdit == CAppSetting.StringY) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DMS_SALES), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0521a126 | EditButton | DMF0041_MDF_Simulator.cs:299 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (sEdit == CAppSetting.StringY) ▸ if (String.IsNullOrEmpty(siMain.Get… | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a2e80fa | EditButton | DMF0041_MDF_Simulator.cs:306 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (sEdit == CAppSetting.StringY) ▸ else of (String.IsNullOrEmpty(siMai… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivision.ControlValues) | 그리드 값 설정 |  |  |  |
| AC-7368f7b6 | EditButton | DMF0041_MDF_Simulator.cs:307 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (sEdit == CAppSetting.StringY) ▸ else of (String.IsNullOrEmpty(siMai… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-59fcaf49 | EditButton | DMF0041_MDF_Simulator.cs:309 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (sEdit == CAppSetting.StringY) ▸ else of (String.IsNullOrEmpty(siMai… | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasureCount.Rows[i]["NAME"].ToStrin… | 그리드 값 설정 |  |  |  |
| AC-2673493e | EditButton | DMF0041_MDF_Simulator.cs:310 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (sEdit == CAppSetting.StringY) ▸ else of (String.IsNullOrEmpty(siMai… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), iRowNo, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a58d0b9e | EditButton | DMF0041_MDF_Simulator.cs:312 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (sEdit == CAppSetting.StringY) ▸ else of (String.IsNullOrEmpty(siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (iRowNo, siMain.GetColumnIndex(DefColumns.UNIT_CURRENCY), dtUnitCurrency) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a02c9a11 | EditButton | DMF0041_MDF_Simulator.cs:317 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (sEdit == CAppSetting.StringY) ▸ else of (String.IsNullOrEmpty(siMai… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.UNIT_CURRENCY), iRowNo, siMain.GetMaxColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0041_MDF_Simulator.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-179a3329 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:339 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9a961660 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:354 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eecb4685 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:355 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e0720eb | FindButton 외 1 | DMF0041_MDF_Simulator.cs:359 | try ▸ if (Convert.ToDateTime(drpDateTime.MonthText1 + "-01") >= Convert.ToDateTime(drpDateTime.MonthText2 + "-01")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00048") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2bbae2ba | FindButton 외 1 | DMF0041_MDF_Simulator.cs:360 | try ▸ if (Convert.ToDateTime(drpDateTime.MonthText1 + "-01") >= Convert.ToDateTime(drpDateTime.MonthText2 + "-01")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7791483 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:364 | try ▸ if (sMDFVersion == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00262", new object[] { "MDF" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b1ed7c5d | FindButton 외 1 | DMF0041_MDF_Simulator.cs:365 | try ▸ if (sMDFVersion == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47228239 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:369 | try ▸ if (sSPVersion == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00262", new object[] { "SP" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6810d2d | FindButton 외 1 | DMF0041_MDF_Simulator.cs:370 | try ▸ if (sSPVersion == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-230979ad | FindButton 외 1 | DMF0041_MDF_Simulator.cs:373 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f19e2ad3 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:375 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c0df4667 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:382 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ee2edd18 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:384 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e873b4af | FindButton 외 1 | DMF0041_MDF_Simulator.cs:388 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0041_GET_MDF_SIMULTATOR") ⇒ DM.DMF0041_GET_MDF_SIMULTATOR | 엔드포인트 요청 생성 |  |  |  |
| AC-7c807a01 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:389 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d5397588 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:390 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-5dbf7173 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:391 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-e64909e4 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:392 | try ▸ lambda | DATA_OP | request.Parameters["p_application"] | sApplication | 행/컬럼 값 대입 |  |  |  |
| AC-b355e365 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:393 | try ▸ lambda | DATA_OP | request.Parameters["p_model_type"] | sModelType | 행/컬럼 값 대입 |  |  |  |
| AC-9aa0b7af | FindButton 외 1 | DMF0041_MDF_Simulator.cs:394 | try ▸ lambda | DATA_OP | request.Parameters["p_mdf_version_no"] | sMDFVersion | 행/컬럼 값 대입 |  |  |  |
| AC-583b7d59 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:395 | try ▸ lambda | DATA_OP | request.Parameters["p_sp_version_no"] | sSPVersion | 행/컬럼 값 대입 |  |  |  |
| AC-c86bdc67 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:396 | try ▸ lambda | DATA_OP | request.Parameters["p_start_dt"] | sStartdt | 행/컬럼 값 대입 |  |  |  |
| AC-93c605cf | FindButton 외 1 | DMF0041_MDF_Simulator.cs:397 | try ▸ lambda | DATA_OP | request.Parameters["p_end_dt"] | sEnddt | 행/컬럼 값 대입 |  |  |  |
| AC-a5c5cd89 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:398 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b049c2f6 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:399 | try ▸ lambda | DATA_OP | request.Parameters["p_user_group"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ffc647f3 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:400 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6e23e173 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:403 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3eeb0fe7 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:410 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4a8f8c0c | FindButton 외 1 | DMF0041_MDF_Simulator.cs:411 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-26bd0727 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:413 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-407a01f3 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:422 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-46ac3e38 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:428 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-06e44319 | FindButton 외 1 | DMF0041_MDF_Simulator.cs:430 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0041_MDF_Simulator.fnValidation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c372fb54 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0041_MDF_Simulator.cs:1097 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-0e48bbb9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0041_MDF_Simulator.cs:1100 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0041_MDF_Simulator.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fe5267b | this.Load | DMF0041_MDF_Simulator.cs:94 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3c0bb93f | this.Load | DMF0041_MDF_Simulator.cs:95 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0041_MDF_Simulator.GetCellIndexBySpanRowCells

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sColName == "BIZ_TYPE") && sAction == CAppSetting.StringI)] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false)] / DeleteButton [if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3b2811b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | DMF0041_MDF_Simulator.cs:1048 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-81ca4c0d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | DMF0041_MDF_Simulator.cs:1049 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0041_MDF_Simulator.GetCellNumbersByRow

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sColName == "BIZ_TYPE") && sAction == CAppSetting.StringI)] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false)] / DeleteButton [if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea126218 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | DMF0041_MDF_Simulator.cs:1036 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-a3dd0e9b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | DMF0041_MDF_Simulator.cs:1041 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DMF0041_MDF_Simulator.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a849c79 | this.Load | DMF0041_MDF_Simulator.cs:995 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-b8b38801 | this.Load | DMF0041_MDF_Simulator.cs:996 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5ec36c19 | this.Load | DMF0041_MDF_Simulator.cs:997 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-b003031f | this.Load | DMF0041_MDF_Simulator.cs:999 |  | VALUE_SET | drpDateTime.InitValue | client.ExecuteDataSet(request).DataSet.Tables[1].Rows[0][0].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-7bb5e260 | this.Load | DMF0041_MDF_Simulator.cs:999 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0041_MDF_Simulator.GetItemType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-630a6827 | this.Load | DMF0041_MDF_Simulator.cs:981 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-23f82047 | this.Load | DMF0041_MDF_Simulator.cs:982 |  | DATA_OP | request.Parameters["p_lookup_type"] | "MDF_MODEL_TYPE" | 행/컬럼 값 대입 |  |  |  |
| AC-681ede1f | this.Load | DMF0041_MDF_Simulator.cs:983 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6ddaef07 | this.Load | DMF0041_MDF_Simulator.cs:986 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0041_MDF_Simulator.GetSpdTitle

진입점: this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b74152e | this.Load 외 2 | DMF0041_MDF_Simulator.cs:964 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0041_GET_SPREAD_TITLE") ⇒ DM.DMF0041_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-ac6cc13b | this.Load 외 2 | DMF0041_MDF_Simulator.cs:965 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-163ad5ba | this.Load 외 2 | DMF0041_MDF_Simulator.cs:966 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ce2d1ca3 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:967 |  | DATA_OP | request.Parameters["p_start_dt"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-07d7135b | this.Load 외 2 | DMF0041_MDF_Simulator.cs:968 |  | DATA_OP | request.Parameters["p_end_dt"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-94adfd10 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:970 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4f50e75a | this.Load 외 2 | DMF0041_MDF_Simulator.cs:972 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0041_MDF_Simulator.GetUnitCurrency

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8de8267f | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0041_MDF_Simulator.cs:1009 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0041_GET_MEASURE_UNIT_CURRENCY") ⇒ DM.DMF0041_GET_MEASURE_UNIT_CURRENCY | 엔드포인트 요청 생성 |  |  |  |
| AC-fb9afb1f | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0041_MDF_Simulator.cs:1010 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-09eb5a0b | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0041_MDF_Simulator.cs:1012 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0041_MDF_Simulator.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e228b8b | this.Load | DMF0041_MDF_Simulator.cs:108 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-995e3f28 | this.Load | DMF0041_MDF_Simulator.cs:108 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-df35e1ee | this.Load | DMF0041_MDF_Simulator.cs:109 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-92afdd4f | this.Load | DMF0041_MDF_Simulator.cs:113 |  | FLAG | dtTeam | Data.Common(Data.Type.DMF0041_MDF_Team, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0041_MDF_Team] | 화면 필드/플래그 변경 |  |  |  |
| AC-4a682991 | this.Load | DMF0041_MDF_Simulator.cs:113 |  | COMBO_DATA | Data.Common | (Data.Type.DMF0041_MDF_Team, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0041_MDF_Team] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5796091e | this.Load | DMF0041_MDF_Simulator.cs:114 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-30929604 | this.Load | DMF0041_MDF_Simulator.cs:116 |  | FLAG | dtApplication | Data.Common(Data.Type.APPLICATION, false) ⇒ biz:CommonData.CommonDataList [code=APPLICATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-7a45146a | this.Load | DMF0041_MDF_Simulator.cs:116 |  | COMBO_DATA | Data.Common | (Data.Type.APPLICATION, false) ⇒ biz:CommonData.CommonDataList [code=APPLICATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ec8d3256 | this.Load | DMF0041_MDF_Simulator.cs:117 |  | LIST_REBIND | clsCtrl.setListBox | (dtApplication, clbApplication, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2525f19a | this.Load | DMF0041_MDF_Simulator.cs:119 |  | FLAG | dtModelType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-ab40b516 | this.Load | DMF0041_MDF_Simulator.cs:120 |  | LIST_REBIND | clsCtrl.setListBox | (dtModelType, clbModelType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3a7b0a56 | this.Load | DMF0041_MDF_Simulator.cs:122 |  | FLAG | dtMeasureCount | Data.Common(Data.Type.DMF0041_MDF_Measure, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0041_MDF_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-fc25d6c8 | this.Load | DMF0041_MDF_Simulator.cs:122 |  | COMBO_DATA | Data.Common | (Data.Type.DMF0041_MDF_Measure, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0041_MDF_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DMF0041_MDF_Simulator.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6553526 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:158 |  | FLAG | dtTitle | GetSpdTitle() | 화면 필드/플래그 변경 |  |  |  |
| AC-673d7c8f | this.Load 외 2 | DMF0041_MDF_Simulator.cs:159 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0041_MDF_Simulator.InitSpreadFooterSum

진입점: this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d2243c2 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:168 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6ea8a799 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:169 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.RowCount | 4 | 그리드 속성/값 설정 |  |  |  |
| AC-7c89e5c1 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:171 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iMasCol].Value | dtModelType.Rows[0][0] | 그리드 속성/값 설정 |  |  |  |
| AC-2c71d2a6 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:172 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[1, iMasCol].Value | dtModelType.Rows[1][0] | 그리드 속성/값 설정 |  |  |  |
| AC-e0b97871 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:173 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[2, iMasCol].Value | dtModelType.Rows[2][0] | 그리드 속성/값 설정 |  |  |  |
| AC-a29a0fe6 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:174 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[3, iMasCol].Value | "SUM" | 그리드 속성/값 설정 |  |  |  |
| AC-449c62e2 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:185 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0d6c85c4 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:187 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-fde9b438 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:188 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-25e50ed9 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:198 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (1, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-60e98786 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:200 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[1, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-721a3a9e | this.Load 외 2 | DMF0041_MDF_Simulator.cs:201 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[1, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-01b848d9 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:205 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (2, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a5891125 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:207 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[2, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-e6f76d5d | this.Load 외 2 | DMF0041_MDF_Simulator.cs:208 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[2, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-c0fb006f | this.Load 외 2 | DMF0041_MDF_Simulator.cs:212 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (3, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-69832e0f | this.Load 외 2 | DMF0041_MDF_Simulator.cs:214 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[3, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-b95e5301 | this.Load 외 2 | DMF0041_MDF_Simulator.cs:215 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[3, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0041_MDF_Simulator.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aee21896 | InsertButton | DMF0041_MDF_Simulator.cs:642 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7b23dc98 | InsertButton | DMF0041_MDF_Simulator.cs:645 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iArray[0], 2) | 그리드 표시 설정 |  |  |  |
| AC-ceddcfd0 | InsertButton | DMF0041_MDF_Simulator.cs:647 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | (6) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8678a0d | InsertButton | DMF0041_MDF_Simulator.cs:653 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MDF_VERSI… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-f2ddd302 | InsertButton | DMF0041_MDF_Simulator.cs:654 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DMS_SALES… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-f420ef49 | InsertButton | DMF0041_MDF_Simulator.cs:655 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.APPLICATI… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-3d6f8d68 | InsertButton | DMF0041_MDF_Simulator.cs:658 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPARTMENT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a71278f2 | InsertButton | DMF0041_MDF_Simulator.cs:660 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | FLAG | dtUnitCurrency | GetUnitCurrency() | 화면 필드/플래그 변경 |  |  |  |
| AC-f11c6ff6 | InsertButton | DMF0041_MDF_Simulator.cs:667 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-418b6e24 | InsertButton | DMF0041_MDF_Simulator.cs:667 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8de700d7 | InsertButton | DMF0041_MDF_Simulator.cs:668 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-73b62da5 | InsertButton | DMF0041_MDF_Simulator.cs:670 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-e0692e60 | InsertButton | DMF0041_MDF_Simulator.cs:670 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3fea79d2 | InsertButton | DMF0041_MDF_Simulator.cs:671 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BIZ_TYPE), dtBizType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2c41dedb | InsertButton | DMF0041_MDF_Simulator.cs:673 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), dtModelType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-aa27730c | InsertButton | DMF0041_MDF_Simulator.cs:681 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= 5) | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivision.ControlValues) | 그리드 값 설정 |  |  |  |
| AC-ca4dbc25 | InsertButton | DMF0041_MDF_Simulator.cs:682 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= 5) | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-db434a6a | InsertButton | DMF0041_MDF_Simulator.cs:684 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= 5) | GRID_SET | siMain.SetText | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasureCount.Rows[i]["NAME"].ToStrin… | 그리드 값 설정 |  |  |  |
| AC-df0fc464 | InsertButton | DMF0041_MDF_Simulator.cs:685 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= 5) | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), iRowNo, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c99f90eb | InsertButton | DMF0041_MDF_Simulator.cs:687 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= 5) | GRID_COMBO | siMain.SetCellTypeCombo | (iRowNo, siMain.GetColumnIndex(DefColumns.UNIT_CURRENCY), dtUnitCurrency) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3835861c | InsertButton | DMF0041_MDF_Simulator.cs:692 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= 5) ▸ if ((sMeasure == "Cell_Qty") \|\| (sMeasure == "Amt") \|\| … | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.UNIT_CURRENCY), iRowNo, siMain.GetMaxColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-16b25bb7 | InsertButton | DMF0041_MDF_Simulator.cs:696 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | CALL_EXT | CUIControl.SetRowSpanFuc | (siMain, siMain.ActiveRowIndex, 5, 1, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), FarPoin… | ⚠ 의미 확인 필요 |  |  |  |
| AC-dede63a4 | InsertButton | DMF0041_MDF_Simulator.cs:698 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0041_MDF_Simulator.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bed41738 | SaveButton | DMF0041_MDF_Simulator.cs:442 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-770caa10 | SaveButton | DMF0041_MDF_Simulator.cs:463 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[MDF Version No]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f12cbfa | SaveButton | DMF0041_MDF_Simulator.cs:464 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3d87dfc | SaveButton | DMF0041_MDF_Simulator.cs:468 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[Division]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-77abaa34 | SaveButton | DMF0041_MDF_Simulator.cs:469 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf732c49 | SaveButton | DMF0041_MDF_Simulator.cs:473 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[Team]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4656bd4 | SaveButton | DMF0041_MDF_Simulator.cs:474 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47a52093 | SaveButton | DMF0041_MDF_Simulator.cs:478 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[DMS Customer]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d8158850 | SaveButton | DMF0041_MDF_Simulator.cs:479 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc3e7cdc | SaveButton | DMF0041_MDF_Simulator.cs:483 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[DMS Sales]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba5483a7 | SaveButton | DMF0041_MDF_Simulator.cs:484 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4d0593b | SaveButton | DMF0041_MDF_Simulator.cs:488 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[Application]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9ab1b10 | SaveButton | DMF0041_MDF_Simulator.cs:489 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c2161dd1 | SaveButton | DMF0041_MDF_Simulator.cs:493 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[BIZ TYPE]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b0bbe5ce | SaveButton | DMF0041_MDF_Simulator.cs:494 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49809a26 | SaveButton | DMF0041_MDF_Simulator.cs:498 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[ITEM TYPE]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ac329458 | SaveButton | DMF0041_MDF_Simulator.cs:499 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38d73323 | SaveButton | DMF0041_MDF_Simulator.cs:503 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(sUNIT_… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[UNIT Currency]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dbc3e7aa | SaveButton | DMF0041_MDF_Simulator.cs:504 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(sUNIT_… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b68c51f | SaveButton | DMF0041_MDF_Simulator.cs:508 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(sUNIT_… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[UNIT Currency]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14468b08 | SaveButton | DMF0041_MDF_Simulator.cs:509 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(sUNIT_… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d4614c6f | SaveButton | DMF0041_MDF_Simulator.cs:515 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (fnValidation(out string sDo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { sDouble }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f1cabb69 | SaveButton | DMF0041_MDF_Simulator.cs:516 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (fnValidation(out string sDo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3eb8cd9 | SaveButton | DMF0041_MDF_Simulator.cs:541 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | CALL_EXT | siMain.GetForeColor | (i + 2, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3234b985 | SaveButton | DMF0041_MDF_Simulator.cs:542 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | CALL_EXT | siMain.GetForeColor | (i + 4, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-66779856 | SaveButton | DMF0041_MDF_Simulator.cs:550 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], action, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-ad489c6a | SaveButton | DMF0041_MDF_Simulator.cs:551 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_MDF_VERSION_NO"] | CString.AppendStringEx(nvc["p_MDF_VERSION_NO"], sMDF_VERSION_NO, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-066628d0 | SaveButton | DMF0041_MDF_Simulator.cs:552 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_DIVISION_ID"] | CString.AppendStringEx(nvc["p_DIVISION_ID"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-518848a3 | SaveButton | DMF0041_MDF_Simulator.cs:553 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_DEPARTMENT_ID"] | CString.AppendStringEx(nvc["p_DEPARTMENT_ID"], sDEPARTMENT_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-68a5f99c | SaveButton | DMF0041_MDF_Simulator.cs:554 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_DMS_CUSTOMER"] | CString.AppendStringEx(nvc["p_DMS_CUSTOMER"], sDMS_CUSTOMER, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-99348f13 | SaveButton | DMF0041_MDF_Simulator.cs:555 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_DMS_SALES"] | CString.AppendStringEx(nvc["p_DMS_SALES"], sDMS_SALES, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-f7d3b412 | SaveButton | DMF0041_MDF_Simulator.cs:556 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_APPLICATION"] | CString.AppendStringEx(nvc["p_APPLICATION"], sAPPLICATION, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-4eaa0233 | SaveButton | DMF0041_MDF_Simulator.cs:557 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_BIZ_TYPE"] | CString.AppendStringEx(nvc["p_BIZ_TYPE"], sBIZ_TYPE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-26a0516e | SaveButton | DMF0041_MDF_Simulator.cs:558 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_ITEM_TYPE"] | CString.AppendStringEx(nvc["p_ITEM_TYPE"], sITEM_TYPE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-11eea690 | SaveButton | DMF0041_MDF_Simulator.cs:559 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_MEASURE"] | CString.AppendStringEx(nvc["p_MEASURE"], sMEASURE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-ed685b85 | SaveButton | DMF0041_MDF_Simulator.cs:560 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_UNIT_CURRENCY"] | CString.AppendStringEx(nvc["p_UNIT_CURRENCY"], sUNIT_CURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-2c8af2ed | SaveButton | DMF0041_MDF_Simulator.cs:561 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_YYYYMM"] | CString.AppendStringEx(nvc["p_YYYYMM"], sYYYYMM, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-8bde0296 | SaveButton | DMF0041_MDF_Simulator.cs:562 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_QTY"] | CString.AppendStringEx(nvc["p_QTY"], sQTY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-1d16aeb3 | SaveButton | DMF0041_MDF_Simulator.cs:564 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], action, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-fcace43e | SaveButton | DMF0041_MDF_Simulator.cs:565 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_MDF_VERSION_NO"] | CString.AppendStringEx(nvc["p_MDF_VERSION_NO"], sMDF_VERSION_NO, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-dc1382e0 | SaveButton | DMF0041_MDF_Simulator.cs:566 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_DIVISION_ID"] | CString.AppendStringEx(nvc["p_DIVISION_ID"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-6721960b | SaveButton | DMF0041_MDF_Simulator.cs:567 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_DEPARTMENT_ID"] | CString.AppendStringEx(nvc["p_DEPARTMENT_ID"], sDEPARTMENT_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-1b0c95ba | SaveButton | DMF0041_MDF_Simulator.cs:568 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_DMS_CUSTOMER"] | CString.AppendStringEx(nvc["p_DMS_CUSTOMER"], sDMS_CUSTOMER, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-44705667 | SaveButton | DMF0041_MDF_Simulator.cs:569 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_DMS_SALES"] | CString.AppendStringEx(nvc["p_DMS_SALES"], sDMS_SALES, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-404b01b1 | SaveButton | DMF0041_MDF_Simulator.cs:570 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_APPLICATION"] | CString.AppendStringEx(nvc["p_APPLICATION"], sAPPLICATION, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-f0dbf550 | SaveButton | DMF0041_MDF_Simulator.cs:571 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_BIZ_TYPE"] | CString.AppendStringEx(nvc["p_BIZ_TYPE"], sBIZ_TYPE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-fc5a7d4f | SaveButton | DMF0041_MDF_Simulator.cs:572 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_ITEM_TYPE"] | CString.AppendStringEx(nvc["p_ITEM_TYPE"], sITEM_TYPE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-6d1845ba | SaveButton | DMF0041_MDF_Simulator.cs:573 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_MEASURE"] | CString.AppendStringEx(nvc["p_MEASURE"], sMEASURE2, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-0bb9917a | SaveButton | DMF0041_MDF_Simulator.cs:574 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_UNIT_CURRENCY"] | CString.AppendStringEx(nvc["p_UNIT_CURRENCY"], sUNIT_CURRENCY2, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-728ae2ac | SaveButton | DMF0041_MDF_Simulator.cs:575 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_YYYYMM"] | CString.AppendStringEx(nvc["p_YYYYMM"], sYYYYMM, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-3e62ee37 | SaveButton | DMF0041_MDF_Simulator.cs:576 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIn… | DATA_OP | nvc["p_QTY"] | CString.AppendStringEx(nvc["p_QTY"], sQTY2, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-eabfe4a2 | SaveButton | DMF0041_MDF_Simulator.cs:584 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if ((iBasicCnt == 0) \|\| (iCUD… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[기본계약조건], [MDF(추가)]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-197a661e | SaveButton | DMF0041_MDF_Simulator.cs:585 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if ((iBasicCnt == 0) \|\| (iCUD… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c19dc8ff | SaveButton | DMF0041_MDF_Simulator.cs:596 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-48171341 | SaveButton | DMF0041_MDF_Simulator.cs:600 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) | ENDPOINT | new FoxDataRequest | ("DM.DMF0041_SAVE_MDF_SIMULTATOR") ⇒ DM.DMF0041_SAVE_MDF_SIMULTATOR | 엔드포인트 요청 생성 |  |  |  |
| AC-afa27460 | SaveButton | DMF0041_MDF_Simulator.cs:601 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) | UI_PROP | request.CommandTimeout | 90 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f8f2c71f | SaveButton | DMF0041_MDF_Simulator.cs:604 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) ▸ for (i < nvc.Count) | DATA_OP | request.Parameters[nvc.GetKey(i)] | nvc[i] | 행/컬럼 값 대입 |  |  |  |
| AC-701b84cc | SaveButton | DMF0041_MDF_Simulator.cs:604 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) ▸ for (i < nvc.Count) | CALL_EXT | nvc.GetKey | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1754d6f5 | SaveButton | DMF0041_MDF_Simulator.cs:606 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-07867a5b | SaveButton | DMF0041_MDF_Simulator.cs:610 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fbff559d | SaveButton | DMF0041_MDF_Simulator.cs:614 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD_Total }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-90924b21 | SaveButton | DMF0041_MDF_Simulator.cs:616 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) ▸ else of (response.DataSet.Tables.Count != 0) | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9b3c663 | SaveButton | DMF0041_MDF_Simulator.cs:620 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) ▸ else of (response.DataSet.Tables.Count != 0) | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-2e9b13ff | SaveButton | DMF0041_MDF_Simulator.cs:622 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) ▸ else of (response.DataSet.Tables.Count != 0) | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1f9168ee | SaveButton | DMF0041_MDF_Simulator.cs:629 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-e779427c | SaveButton | DMF0041_MDF_Simulator.cs:633 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0041_MDF_Simulator.shtMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d7bba09 | dsdm.Changed | DMF0041_MDF_Simulator.cs:707 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9962a009 | dsdm.Changed | DMF0041_MDF_Simulator.cs:761 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sColName.IndexOf("M_") == 0) && sAction == CAppS… | GRID_SET | siMain.SetValue | (iBasicRowNo, siMain.GetColumnIndex(sColName), dMDFBasic.ToString()) | 그리드 값 설정 |  |  |  |
| AC-a91f7681 | dsdm.Changed | DMF0041_MDF_Simulator.cs:762 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sColName.IndexOf("M_") == 0) && sAction == CAppS… | GRID_SET | siMain.SetValue | (iTotalRowNo, siMain.GetColumnIndex(sColName), (dMDFBasic + dMDFAdd).ToString()) | 그리드 값 설정 |  |  |  |

## DMF0041_MDF_Simulator.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-040f7191 | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:839 | if (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ if (sAction != CAppSetting.StringI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ab4084c | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:845 | if (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) | POPUP | new DM0041_MDFVersionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8b1118ff | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:846 | if (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) | POPUP | popVersion.Form_Load | (true, "MDF", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9d5dfb02 | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:847 | if (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-218dd699 | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:848 | if (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e04751ad | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:851 | if (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ if (popVersion.sVersions != "") | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO), popVersion.sVersions) | 그리드 값 설정 |  |  |  |
| AC-7b3632db | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:856 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) ▸ if (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b48606d1 | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:859 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) ▸ if (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88cf4389 | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:866 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) | POPUP | new DMF0041_DMS_SalesSet_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-8af51c3d | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:867 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) | POPUP | salespop.Form_Load | (sDivision, sDmsSales) | 팝업 초기화(인자 전달) |  |  |  |
| AC-3c39f56b | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:868 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) | UI_PROP | salespop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7921bacd | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:869 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) | POPUP | salespop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ccc042e8 | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:890 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) ▸ if (… | GRID_SET | siMain.SetText | (iEventRow + i, siMain.GetColumnIndex(DefColumns.DMS_SALES), salespop.DMS_Sales) | 그리드 값 설정 |  |  |  |
| AC-686926c4 | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:897 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) ▸… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26744a83 | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:900 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) ▸… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a97cdbb8 | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:907 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) ▸… | POPUP | new DMF0041_DMS_SalesSet_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-72c31d82 | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:908 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) ▸… | POPUP | salespop.Form_Load | (sDivision, sApp, "App") | 팝업 초기화(인자 전달) |  |  |  |
| AC-c288aefb | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:909 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) ▸… | UI_PROP | salespop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-432067c7 | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:910 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) ▸… | POPUP | salespop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-77acda1c | this.spdMain.CellDoubleClick | DMF0041_MDF_Simulator.cs:928 | else of (e.Column == siMain.GetColumnIndex(DefColumns.MDF_VERSION_NO)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DMS_SALES)) ▸… | GRID_SET | siMain.SetText | (iEventRow + i, siMain.GetColumnIndex(DefColumns.APPLICATION), salespop.DMS_Sales) | 그리드 값 설정 |  |  |  |

## DMF0041_MDF_Simulator.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f57593b | this.spdMain.ComboSelChange | DMF0041_MDF_Simulator.cs:946 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPARTMENT_ID)) | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-eaadd524 | this.spdMain.ComboSelChange | DMF0041_MDF_Simulator.cs:946 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPARTMENT_ID)) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4dd3c1dc | this.spdMain.ComboSelChange | DMF0041_MDF_Simulator.cs:947 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPARTMENT_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c3572cd0 | this.spdMain.ComboSelChange | DMF0041_MDF_Simulator.cs:949 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPARTMENT_ID)) | CALL_EXT | CUIControl.SetCellRangeAligement | (siMain, e.Row, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), e.Row + 1, siMain.GetColum… | ⚠ 의미 확인 필요 |  |  |  |

## DMF0041_MDF_Simulator.TotalSum

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetMaxRowIndex() > 0)] / FindButton [finally ▸ if (siMain.GetMaxRowIndex() > 0)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (iCUD_Total != 0) ▸ else of (response.DataSet.Tables.Count != 0) ▸ finally ▸ if (siMain.GetMaxRowIndex() > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eda10f9d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | DMF0041_MDF_Simulator.cs:1145 | for (i <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, i].Value | dCylSum | 그리드 속성/값 설정 |  |  |  |
| AC-ad1860a1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | DMF0041_MDF_Simulator.cs:1146 | for (i <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[1, i].Value | dPouSum | 그리드 속성/값 설정 |  |  |  |
| AC-8602aecf | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | DMF0041_MDF_Simulator.cs:1147 | for (i <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[2, i].Value | dPriSum | 그리드 속성/값 설정 |  |  |  |
| AC-6768bf51 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 2 | DMF0041_MDF_Simulator.cs:1148 | for (i <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[3, i].Value | dPouSum + dPriSum + dCylSum | 그리드 속성/값 설정 |  |  |  |


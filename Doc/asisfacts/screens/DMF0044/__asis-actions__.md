# AS-IS 액션 대조표 — DMF0044

> 원천: `Doc/asisfacts/screens/DMF0044/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 930행 · 메서드 129 · 종류 DATA_OP 251 · UI_PROP 87 · MESSAGE 69 · ENDPOINT 68 · GRID_INIT 64 · FLAG 62 · RETURN 60 · UI_MISC 45 · GRID_SET 44 · GRID_LOCK 33 · VALUE_SET 22 · POPUP 22 · CALL_EXT 17 · STATE 16 · COMBO_DATA 15 · GRID_COMBO 13 · LIST_REBIND 12 · GRID_BIND 9 · VALUE_CLEAR 9 · GRID_STYLE 9 · CALL_BASE 2 · THROW 1 · ⚠ 의미 확인 필요 19


## DMF0044_MDFVersionPopUp.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf8459bb | this.btnButtonList.UsrButtonList_Click_Detected | DMF0044_MDFVersionPopUp.cs:417 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0044_MDFVersionPopUp.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64a9becd | this.Load | DMF0044_MDFVersionPopUp.cs:156 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0cc9527f | this.Load | DMF0044_MDFVersionPopUp.cs:157 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-343ee56e | this.Load | DMF0044_MDFVersionPopUp.cs:158 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_MDFVersionPopUp.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85051584 | this.Load | DMF0044_MDFVersionPopUp.cs:149 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0044_MDFVersionPopUp.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c57648f | DeleteButton | DMF0044_MDFVersionPopUp.cs:203 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0044_MDFVersionPopUp.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-472e86d9 | Dispose | DMF0044_MDFVersionPopUp.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0044_MDFVersionPopUp.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01429f88 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:263 |  | DATA_OP | nvc["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9948ee06 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:264 |  | DATA_OP | nvc["p_version_description"] | txtDes.Text | 행/컬럼 값 대입 |  |  |  |
| AC-25d18a5b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:265 |  | DATA_OP | nvc["p_version_type"] | txtType.Text | 행/컬럼 값 대입 |  |  |  |
| AC-18c13446 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:266 |  | DATA_OP | nvc["p_from_yyyymmdd"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-26cb9e6d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:267 |  | DATA_OP | nvc["p_to_yyyymmdd"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b4f55eb7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:268 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-916c2dd2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:269 |  | ENDPOINT | (new CUIControl()).GetAsyncDataUsingByDB | (this, "DM0021_GET_DM_MST_VERSION", nvc) ⇒ DM_H.DM0021_GET_DM_MST_VERSION | 엔드포인트 호출 |  |  |  |
| AC-92d26eb5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:269 |  | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0021_GET_DM_MST_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-c5881804 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:271 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-923fa133 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:272 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-07183fd5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:275 |  | GRID_BIND | siMain.Query | (CUIControl.GetDatatableFromSpread(siMain, "")) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-69ec443f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:275 |  | ENDPOINT | CUIControl.GetDatatableFromSpread | (siMain, "") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ec642954 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:280 |  | DATA_OP | dsSpread.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bc561b8d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:288 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b5d09e1d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:291 |  | CALL_EXT | CUIControl.SetPreferredWidth | (siMain.SpreadObject) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0044_MDFVersionPopUp.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee9e2e29 | this.Load | DMF0044_MDFVersionPopUp.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-266c638f | this.Load | DMF0044_MDFVersionPopUp.cs:105 |  | VALUE_SET | drpPeriod.InitValue | sStartDate + ":" + sEndDate | 컨트롤 값 설정 |  |  |  |
| AC-698ee106 | this.Load | DMF0044_MDFVersionPopUp.cs:107 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0044_MDFVersionPopUp.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c983edbb | this.Load | DMF0044_MDFVersionPopUp.cs:140 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-09e96c31 | this.Load | DMF0044_MDFVersionPopUp.cs:141 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-440ed14f | this.Load | DMF0044_MDFVersionPopUp.cs:141 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1ee44ac5 | this.Load | DMF0044_MDFVersionPopUp.cs:142 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0044_MDFVersionPopUp.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c20d6edc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:165 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8f2eac27 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:167 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b33a25d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:168 |  | GRID_INIT | siMain.AddComboColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.Restricted, 120, true, dtDivision, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-531eb547 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:169 |  | GRID_INIT | siMain.AddTextColumn | ("Version NO", DefColumns.VERSION_NO, FPMerge.Restricted, 120, true, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8dfc47a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:170 |  | GRID_INIT | siMain.AddTextColumn | ("Type", DefColumns.VERSION_TYPE, FPMerge.Restricted, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a48753e0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:172 |  | GRID_INIT | siMain.AddTextColumn | ("Description", DefColumns.VERSION_DESCRIPTION, FPMerge.Restricted, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e0ae165f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:173 |  | GRID_INIT | siMain.AddTextColumn | ("yyyyMMdd", DefColumns.YYYYMMDD, FPMerge.Restricted, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a6f13bf0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:175 |  | GRID_INIT | siMain.AddTextColumn | ("Ver Seq", DefColumns.VER_CRE_SEQ, FPMerge.Restricted, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4327dd74 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:176 |  | GRID_INIT | siMain.AddTextColumn | ("Update By", DefColumns.LAST_UPDATED_BY, FPMerge.Restricted, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17dabdc7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:177 |  | GRID_INIT | siMain.AddTextColumn | ("Update Date", DefColumns.LAST_UPDATE_DATE, FPMerge.Restricted, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a1d49aef | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:179 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.YYYYMMDD)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-69cf0d07 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_MDFVersionPopUp.cs:182 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_MDFVersionPopUp.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fda47eb | (진입점 미연결) | DMF0044_MDFVersionPopUp.cs:118 |  | VALUE_SET | this.Text | "Ver. Cut-Off [" + sVersion_Type + "]" | 컨트롤 값 설정 |  |  |  |
| AC-ccbe5ee9 | (진입점 미연결) | DMF0044_MDFVersionPopUp.cs:120 |  | FLAG | this.sVersion_Type | sVersion_Type | 화면 필드/플래그 변경 |  |  |  |
| AC-959cdb93 | (진입점 미연결) | DMF0044_MDFVersionPopUp.cs:121 |  | VALUE_SET | txtType.Text | sVersion_Type | 컨트롤 값 설정 |  |  |  |
| AC-ca385b43 | (진입점 미연결) | DMF0044_MDFVersionPopUp.cs:122 |  | FLAG | this.sFoxData | sFoxData | 화면 필드/플래그 변경 |  |  |  |

## DMF0044_MDFVersionPopUp.mOK

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fdde533 | (진입점 미연결) | DMF0044_MDFVersionPopUp.cs:430 |  | FLAG | blnOK | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0044_MDFVersionPopUp.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Confirm:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f045b9bc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_MDFVersionPopUp.cs:314 | if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-379c7ac5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_MDFVersionPopUp.cs:323 | for (i < asDivision.Length) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sPlanBinding)) … | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c684bf6e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_MDFVersionPopUp.cs:327 | for (i < asDivision.Length) ▸ lambda | ENDPOINT | new FoxDataRequest | (sFoxData) ⇒ DM_H.PR_DM_PLN_SALES_PLAN_CUTOFF \| {?DMF0044_MDFVersionPopUp.sFoxData} | 엔드포인트 요청 생성 |  |  |  |
| AC-9153a3cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_MDFVersionPopUp.cs:328 | for (i < asDivision.Length) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | asDivision[i] | 행/컬럼 값 대입 |  |  |  |
| AC-44aae319 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_MDFVersionPopUp.cs:329 | for (i < asDivision.Length) ▸ lambda | DATA_OP | request.Parameters["p_version_description"] | p_version_description | 행/컬럼 값 대입 |  |  |  |
| AC-1558533a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_MDFVersionPopUp.cs:330 | for (i < asDivision.Length) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3c32b970 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_MDFVersionPopUp.cs:332 | for (i < asDivision.Length) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-72aad318 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_MDFVersionPopUp.cs:345 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00143", new object[] { p_division_id, sRMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0044_MDFVersionPopUp.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb5aca2a | this.spdMain.TopChange | DMF0044_MDFVersionPopUp.cs:436 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_Sales_Reports.btnExchangeRate_Click

진입점: this.btnExchangeRate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92c9bb3b | this.btnExchangeRate.Click | DMF0044_Sales_Reports.cs:1431 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00142") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0f0a7b91 | this.btnExchangeRate.Click | DMF0044_Sales_Reports.cs:1432 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7db4bec8 | this.btnExchangeRate.Click | DMF0044_Sales_Reports.cs:1437 | if (txtSPVersion.Text == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00281") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c4df470 | this.btnExchangeRate.Click | DMF0044_Sales_Reports.cs:1438 | if (txtSPVersion.Text == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e7847c5 | this.btnExchangeRate.Click | DMF0044_Sales_Reports.cs:1441 |  | POPUP | new DMF0044_SalesReportExchangePopup | () | 팝업/폼 생성 |  |  |  |
| AC-eabb85ca | this.btnExchangeRate.Click | DMF0044_Sales_Reports.cs:1442 |  | CALL_EXT | popup.LoadData | (usrYear.ControlValues, txtSPVersion.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c04eb0e1 | this.btnExchangeRate.Click | DMF0044_Sales_Reports.cs:1443 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3f34a7bd | this.btnExchangeRate.Click | DMF0044_Sales_Reports.cs:1444 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0044_Sales_Reports.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c641a19e | this.btnMeasure.Click | DMF0044_Sales_Reports.cs:1409 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0044", siMain.SheetName, false) | 팝업/폼 생성 |  |  |  |
| AC-2da60b01 | this.btnMeasure.Click | DMF0044_Sales_Reports.cs:1411 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-909e68bf | this.btnMeasure.Click | DMF0044_Sales_Reports.cs:1412 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0044_Sales_Reports.btnSPVer_Click

진입점: this.btnSPVer.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a990ea77 | this.btnSPVer.Click | DMF0044_Sales_Reports.cs:1150 |  | POPUP | new DMF0044_United_VersionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b3cbb451 | this.btnSPVer.Click | DMF0044_Sales_Reports.cs:1151 |  | POPUP | pop.Form_Load | (clbDivision.ControlValues, clbType.ControlValues) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8e93718e | this.btnSPVer.Click | DMF0044_Sales_Reports.cs:1152 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-825e78a4 | this.btnSPVer.Click | DMF0044_Sales_Reports.cs:1154 |  | VALUE_SET | txtSPVersion.Text | pop.sVersions | 컨트롤 값 설정 |  |  |  |

## DMF0044_Sales_Reports.btnTextbox_Click

진입점: this.btnTextbox.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a159b499 | this.btnTextbox.Click | DMF0044_Sales_Reports.cs:1472 | if (txtSPVersion.Text == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00281") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-451ff747 | this.btnTextbox.Click | DMF0044_Sales_Reports.cs:1473 | if (txtSPVersion.Text == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77cee7d2 | this.btnTextbox.Click | DMF0044_Sales_Reports.cs:1476 |  | POPUP | new DMF0044_SalesReport_TextboxPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2d1249ea | this.btnTextbox.Click | DMF0044_Sales_Reports.cs:1477 |  | CALL_EXT | popup.LoadData | (txtSPVersion.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-266aa09e | this.btnTextbox.Click | DMF0044_Sales_Reports.cs:1478 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-18de2196 | this.btnTextbox.Click | DMF0044_Sales_Reports.cs:1479 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0044_Sales_Reports.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f97d0301 | this.clbDivision.SelectedIndexChanged | DMF0044_Sales_Reports.cs:1462 | if (siMain != null) | VALUE_CLEAR | txtSPVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0e478497 | this.clbDivision.SelectedIndexChanged | DMF0044_Sales_Reports.cs:1464 | if (siMain != null) | UI_PROP | lci_btnTextBox.Visibility | (sDivision == "82") ? DevExpress.XtraLayout.Utils.LayoutVisibility.Always : DevExpress.Xtr… | 속성 Visibility 설정 |  |  |  |

## DMF0044_Sales_Reports.clbType_SelectedIndexChanged

진입점: this.clbType.SelectedIndexChanged / clbType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98a1cd05 | this.clbType.SelectedIndexChanged 외 1 | DMF0044_Sales_Reports.cs:1397 |  | VALUE_CLEAR | txtSPVersion.Text | null | 컨트롤 값 비움 |  |  |  |
| AC-27252393 | this.clbType.SelectedIndexChanged 외 1 | DMF0044_Sales_Reports.cs:1400 | if (clbType.ControlValues == "REPORT_SP_W") | VALUE_SET | lblSPVersion.Text | "SP Version" | 컨트롤 값 설정 |  |  |  |
| AC-3bf190ef | this.clbType.SelectedIndexChanged 외 1 | DMF0044_Sales_Reports.cs:1402 | else of (clbType.ControlValues == "REPORT_SP_W") | VALUE_SET | lblSPVersion.Text | "BP Version" | 컨트롤 값 설정 |  |  |  |

## DMF0044_Sales_Reports.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1e34c89 | this.Load | DMF0044_Sales_Reports.cs:213 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cf563ee7 | this.Load | DMF0044_Sales_Reports.cs:214 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d127f4a | this.Load | DMF0044_Sales_Reports.cs:215 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_Sales_Reports.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac077457 | this.Load | DMF0044_Sales_Reports.cs:202 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-a98c334d | this.Load | DMF0044_Sales_Reports.cs:203 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-d815bad4 | this.Load | DMF0044_Sales_Reports.cs:204 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## DMF0044_Sales_Reports.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2658e6c2 | DeleteButton | DMF0044_Sales_Reports.cs:265 | for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-fb5de5e5 | DeleteButton | DMF0044_Sales_Reports.cs:266 | for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0044_Sales_Reports.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6dc8748 | Dispose | DMF0044_Sales_Reports.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0044_Sales_Reports.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5666705 | EditButton | DMF0044_Sales_Reports.cs:274 | if (sDataType == "ALL") | MESSAGE | MessageHelper.GMessageBox | ("MSG00321") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-744a2057 | EditButton | DMF0044_Sales_Reports.cs:275 | if (sDataType == "ALL") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75addd5a | EditButton | DMF0044_Sales_Reports.cs:279 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-866913f8 | EditButton | DMF0044_Sales_Reports.cs:280 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-17c4426b | EditButton | DMF0044_Sales_Reports.cs:284 | if (this.fps != null) ▸ if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ee5cdb2 | EditButton | DMF0044_Sales_Reports.cs:327 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)).ToStr… | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a51f745d | EditButton | DMF0044_Sales_Reports.cs:333 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)).… | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-205fd59f | EditButton | DMF0044_Sales_Reports.cs:337 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)).… | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, iCurCol - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-70d644bc | EditButton | DMF0044_Sales_Reports.cs:346 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)).… | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb914dec | EditButton | DMF0044_Sales_Reports.cs:350 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)).… | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-129a1604 | EditButton | DMF0044_Sales_Reports.cs:358 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)).… | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5f8e730d | EditButton | DMF0044_Sales_Reports.cs:359 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)).… | GRID_LOCK | siMain.LockRange | (iRow, iCurCol, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7a82c43a | EditButton | DMF0044_Sales_Reports.cs:363 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)).… | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0044_Sales_Reports.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7352199 | ExcelButton | DMF0044_Sales_Reports.cs:386 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-ee83e33d | ExcelButton | DMF0044_Sales_Reports.cs:387 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-5c96bec9 | ExcelButton | DMF0044_Sales_Reports.cs:388 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-79b7a213 | ExcelButton | DMF0044_Sales_Reports.cs:389 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-3b05d813 | ExcelButton | DMF0044_Sales_Reports.cs:390 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-d5bbe17f | ExcelButton | DMF0044_Sales_Reports.cs:391 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-3530e6dc | ExcelButton | DMF0044_Sales_Reports.cs:393 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-24ad991a | ExcelButton | DMF0044_Sales_Reports.cs:394 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-f8a562a7 | ExcelButton | DMF0044_Sales_Reports.cs:396 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.000;[Red]-#,##0.000" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-a5ed77ac | ExcelButton | DMF0044_Sales_Reports.cs:405 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-868c8637 | ExcelButton | DMF0044_Sales_Reports.cs:410 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-67a0d71b | ExcelButton | DMF0044_Sales_Reports.cs:414 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0044_Sales_Reports.FindData

진입점: FindButton / SaveButton [else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "success")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-037f046a | FindButton 외 1 | DMF0044_Sales_Reports.cs:437 | if (txtSPVersion.Text == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00283") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a1289dc3 | FindButton 외 1 | DMF0044_Sales_Reports.cs:438 | if (txtSPVersion.Text == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dd3b08fd | FindButton 외 1 | DMF0044_Sales_Reports.cs:441 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8cd8bcbf | FindButton 외 1 | DMF0044_Sales_Reports.cs:444 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7e8208c5 | FindButton 외 1 | DMF0044_Sales_Reports.cs:445 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-04255450 | FindButton 외 1 | DMF0044_Sales_Reports.cs:453 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0e256576 | FindButton 외 1 | DMF0044_Sales_Reports.cs:454 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e3c33f4e | FindButton 외 1 | DMF0044_Sales_Reports.cs:458 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0044_GET_SALES_REPORTS_DATA") ⇒ DM.DMF0044_GET_SALES_REPORTS_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-74cd13ed | FindButton 외 1 | DMF0044_Sales_Reports.cs:459 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-afbd259b | FindButton 외 1 | DMF0044_Sales_Reports.cs:460 | try ▸ lambda | DATA_OP | request.Parameters["division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-a9381360 | FindButton 외 1 | DMF0044_Sales_Reports.cs:461 | try ▸ lambda | DATA_OP | request.Parameters["p_mdf_type"] | clbType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-ba3ba953 | FindButton 외 1 | DMF0044_Sales_Reports.cs:462 | try ▸ lambda | DATA_OP | request.Parameters["p_yyyy"] | usrYear.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-1f4b4270 | FindButton 외 1 | DMF0044_Sales_Reports.cs:463 | try ▸ lambda | DATA_OP | request.Parameters["p_sp_version_no"] | txtSPVersion.Text | 행/컬럼 값 대입 |  |  |  |
| AC-41599710 | FindButton 외 1 | DMF0044_Sales_Reports.cs:464 | try ▸ lambda | DATA_OP | request.Parameters["p_data_type"] | usrDataType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-89d6d8f3 | FindButton 외 1 | DMF0044_Sales_Reports.cs:465 | try ▸ lambda | DATA_OP | request.Parameters["p_user_group"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4a79c200 | FindButton 외 1 | DMF0044_Sales_Reports.cs:466 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-dc22830a | FindButton 외 1 | DMF0044_Sales_Reports.cs:469 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5cf41cd6 | FindButton 외 1 | DMF0044_Sales_Reports.cs:471 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e5853412 | FindButton 외 1 | DMF0044_Sales_Reports.cs:479 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d638c5db | FindButton 외 1 | DMF0044_Sales_Reports.cs:480 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-421691e6 | FindButton 외 1 | DMF0044_Sales_Reports.cs:482 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b3558889 | FindButton 외 1 | DMF0044_Sales_Reports.cs:483 | try | FLAG | sDataType | usrDataType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-c5c1b288 | FindButton 외 1 | DMF0044_Sales_Reports.cs:492 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f4672ab4 | FindButton 외 1 | DMF0044_Sales_Reports.cs:496 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dddc0111 | FindButton 외 1 | DMF0044_Sales_Reports.cs:498 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0044_Sales_Reports.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-394085cd | this.Load | DMF0044_Sales_Reports.cs:134 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5dbeef76 | this.Load | DMF0044_Sales_Reports.cs:136 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0044_Sales_Reports.GetCalendarYYYY

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9707fe0 | this.Load | DMF0044_Sales_Reports.cs:1098 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-047a59c7 | this.Load | DMF0044_Sales_Reports.cs:1099 |  | DATA_OP | request.Parameters["CODE"] | "CALENDAR_YYYY" | 행/컬럼 값 대입 |  |  |  |
| AC-cf213ba8 | this.Load | DMF0044_Sales_Reports.cs:1100 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eaae7a5d | this.Load | DMF0044_Sales_Reports.cs:1101 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-572db202 | this.Load | DMF0044_Sales_Reports.cs:1102 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fdd82fef | this.Load | DMF0044_Sales_Reports.cs:1103 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e1568d5e | this.Load | DMF0044_Sales_Reports.cs:1104 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-954688a8 | this.Load | DMF0044_Sales_Reports.cs:1105 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a700aea5 | this.Load | DMF0044_Sales_Reports.cs:1107 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0044_Sales_Reports.GetCellColor

진입점: SaveButton [else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3432192 | SaveButton [else of (sDataType == "ALL") ▸ if (sDataType == … | DMF0044_Sales_Reports.cs:1345 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0044_Sales_Reports.GetCellIndexBySpanRowCells

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e4a4739 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0044_Sales_Reports.cs:1144 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7de1375 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0044_Sales_Reports.cs:1145 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0044_Sales_Reports.GetCellNumbersByRow

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9c11d47 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0044_Sales_Reports.cs:1132 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-3c1e0f1b | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0044_Sales_Reports.cs:1137 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DMF0044_Sales_Reports.GetLookupData

진입점: this.Load / dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49e93c10 | this.Load 외 1 | DMF0044_Sales_Reports.cs:1046 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-2be4dc6b | this.Load 외 1 | DMF0044_Sales_Reports.cs:1047 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-ee40a36b | this.Load 외 1 | DMF0044_Sales_Reports.cs:1048 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6008a983 | this.Load 외 1 | DMF0044_Sales_Reports.cs:1050 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0044_Sales_Reports.GetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-885af904 | this.Load | DMF0044_Sales_Reports.cs:1060 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0044_GET_MEASURE") ⇒ DM.DMF0044_GET_MEASURE | 엔드포인트 요청 생성 |  |  |  |
| AC-c21452a5 | this.Load | DMF0044_Sales_Reports.cs:1061 |  | DATA_OP | request.Parameters["p_Data_Type"] | sDataType | 행/컬럼 값 대입 |  |  |  |
| AC-243eaf33 | this.Load | DMF0044_Sales_Reports.cs:1062 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3ce450ba | this.Load | DMF0044_Sales_Reports.cs:1064 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0044_Sales_Reports.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e95eb7fa | this.Load | DMF0044_Sales_Reports.cs:178 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-56b4d1a3 | this.Load | DMF0044_Sales_Reports.cs:181 |  | UI_PROP | lci_btnTextBox.Visibility | (sDivision == "82") ? DevExpress.XtraLayout.Utils.LayoutVisibility.Always : DevExpress.Xtr… | 속성 Visibility 설정 |  |  |  |
| AC-b1005ecc | this.Load | DMF0044_Sales_Reports.cs:188 |  | LIST_REBIND | clsCtrl.setListBox | (dtLook, clbType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9458a3c1 | this.Load | DMF0044_Sales_Reports.cs:191 |  | FLAG | dtMeasure | GetMeasure() | 화면 필드/플래그 변경 |  |  |  |
| AC-b45af6b7 | this.Load | DMF0044_Sales_Reports.cs:194 |  | LIST_REBIND | clsCtrl.setListBox | (dt2, usrDataType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f3a4ff62 | this.Load | DMF0044_Sales_Reports.cs:196 |  | FLAG | dtCompanyid | GetLookupData("DM_COMPANY") | 화면 필드/플래그 변경 |  |  |  |

## DMF0044_Sales_Reports.InitSpread

진입점: this.clbType.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.clbDivision.SelectedIndexChanged [if (siMain != null)] / this.Load / clbType.SelectedIndexChanged / FindButton / SaveButton [else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "success")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fca23a4 | this.clbType.SelectedIndexChanged 외 6 | DMF0044_Sales_Reports.cs:225 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0044_GET_SPREAD_TITLE") ⇒ DM.DMF0044_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-97d18b6f | this.clbType.SelectedIndexChanged 외 6 | DMF0044_Sales_Reports.cs:227 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-da004586 | this.clbType.SelectedIndexChanged 외 6 | DMF0044_Sales_Reports.cs:228 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2d3473f6 | this.clbType.SelectedIndexChanged 외 6 | DMF0044_Sales_Reports.cs:229 |  | DATA_OP | request.Parameters["p_start_dt"] | usrYear.SelectedValue + "0101" | 행/컬럼 값 대입 |  |  |  |
| AC-e9a414f2 | this.clbType.SelectedIndexChanged 외 6 | DMF0044_Sales_Reports.cs:230 |  | DATA_OP | request.Parameters["p_end_dt"] | usrYear.SelectedValue + "1231" | 행/컬럼 값 대입 |  |  |  |
| AC-012bb7b9 | this.clbType.SelectedIndexChanged 외 6 | DMF0044_Sales_Reports.cs:232 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0cb67df7 | this.clbType.SelectedIndexChanged 외 6 | DMF0044_Sales_Reports.cs:234 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f2cf9656 | this.clbType.SelectedIndexChanged 외 6 | DMF0044_Sales_Reports.cs:235 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-5dbf4476 | this.clbType.SelectedIndexChanged 외 6 | DMF0044_Sales_Reports.cs:236 |  | GRID_INIT | siMain.CreateSheetHeaderColumnDtDiv | (siMain, 1, dt, clbDivision.SelectedValue.ToString()) | 그리드 재구성/초기화 |  |  |  |

## DMF0044_Sales_Reports.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-faf88cad | InsertButton | DMF0044_Sales_Reports.cs:974 | if (usrDataType.ControlValues != "2") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f86a951 | InsertButton | DMF0044_Sales_Reports.cs:983 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iArray[0], 2) | 그리드 표시 설정 |  |  |  |
| AC-592d82ea | InsertButton | DMF0044_Sales_Reports.cs:984 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | (2) | 데이터 객체 조작/조회 |  |  |  |
| AC-1de47797 | InsertButton | DMF0044_Sales_Reports.cs:990 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.DMF0044_DEPARTMENT_TEAM2, false, "", "", "", "Y") ⇒ biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM2] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-530a3c66 | InsertButton | DMF0044_Sales_Reports.cs:991 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-26da9b32 | InsertButton | DMF0044_Sales_Reports.cs:997 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DEPARTMENT_NAME), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c79ec878 | InsertButton | DMF0044_Sales_Reports.cs:999 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DEPT_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-54bad5d7 | InsertButton | DMF0044_Sales_Reports.cs:1001 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CUTOFF_YYYYMMDD), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-01fe7189 | InsertButton | DMF0044_Sales_Reports.cs:1003 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9680a36d | InsertButton | DMF0044_Sales_Reports.cs:1007 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9dfb90ff | InsertButton | DMF0044_Sales_Reports.cs:1009 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4651b5b0 | InsertButton | DMF0044_Sales_Reports.cs:1011 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.APPLICATION), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ad4743d | InsertButton | DMF0044_Sales_Reports.cs:1013 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-179e6515 | InsertButton | DMF0044_Sales_Reports.cs:1015 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME40), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7d7d4a0e | InsertButton | DMF0044_Sales_Reports.cs:1017 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DMS_SALES), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bbefc407 | InsertButton | DMF0044_Sales_Reports.cs:1019 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee1834ed | InsertButton | DMF0044_Sales_Reports.cs:1023 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), iRowNo, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f9dae7dd | InsertButton | DMF0044_Sales_Reports.cs:1024 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) ▸ if (siMain.GetCo… | GRID_SET | siMain.SetValue | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasure.Rows[i]["CODE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-16310ee1 | InsertButton | DMF0044_Sales_Reports.cs:1027 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < 2) | GRID_SET | siMain.ActiveSheet.Cells[iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## DMF0044_Sales_Reports.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcde2e88 | SaveButton | DMF0044_Sales_Reports.cs:506 | if (txtSPVersion.Text == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00281") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81f7a413 | SaveButton | DMF0044_Sales_Reports.cs:507 | if (txtSPVersion.Text == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63dc9280 | SaveButton | DMF0044_Sales_Reports.cs:512 | if (sDataType == "ALL") | MESSAGE | MessageHelper.GMessageBox | ("MSG00321") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-62266869 | SaveButton | DMF0044_Sales_Reports.cs:513 | if (sDataType == "ALL") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f25965f | SaveButton | DMF0044_Sales_Reports.cs:521 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e4fcb539 | SaveButton | DMF0044_Sales_Reports.cs:522 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-06c04e29 | SaveButton | DMF0044_Sales_Reports.cs:572 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Department" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b943a956 | SaveButton | DMF0044_Sales_Reports.cs:573 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d8389eee | SaveButton | DMF0044_Sales_Reports.cs:574 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-771187e6 | SaveButton | DMF0044_Sales_Reports.cs:656 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | ENDPOINT | new FoxDataRequest | ("DM.DMF0044_SAVE_SALES_PLAN_REPORT_C") ⇒ DM.DMF0044_SAVE_SALES_PLAN_REPORT_C | 엔드포인트 요청 생성 |  |  |  |
| AC-707990c1 | SaveButton | DMF0044_Sales_Reports.cs:657 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-a98d17f0 | SaveButton | DMF0044_Sales_Reports.cs:657 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_active_flag.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f91ed42 | SaveButton | DMF0044_Sales_Reports.cs:658 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_division_id"] | p_division_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4098a5c8 | SaveButton | DMF0044_Sales_Reports.cs:658 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_division_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-021c27e9 | SaveButton | DMF0044_Sales_Reports.cs:659 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_version_no"] | p_version_no.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-7a5ef1c9 | SaveButton | DMF0044_Sales_Reports.cs:659 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_version_no.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-b986de5a | SaveButton | DMF0044_Sales_Reports.cs:660 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_cutoff_type"] | p_cutoff_type.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-2b63e5f5 | SaveButton | DMF0044_Sales_Reports.cs:660 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_cutoff_type.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-18ea540b | SaveButton | DMF0044_Sales_Reports.cs:661 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_cutoff_yyyymmdd"] | p_cutoff_yyyymmdd.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-8fe62989 | SaveButton | DMF0044_Sales_Reports.cs:661 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_cutoff_yyyymmdd.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d79cb82 | SaveButton | DMF0044_Sales_Reports.cs:662 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_department_id"] | p_department_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-f1016eef | SaveButton | DMF0044_Sales_Reports.cs:662 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_department_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e361eed2 | SaveButton | DMF0044_Sales_Reports.cs:663 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_department_name"] | p_department_name.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-83f1f33e | SaveButton | DMF0044_Sales_Reports.cs:663 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_department_name.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0b31af2 | SaveButton | DMF0044_Sales_Reports.cs:664 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-3074ec86 | SaveButton | DMF0044_Sales_Reports.cs:664 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_dept_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6237ab58 | SaveButton | DMF0044_Sales_Reports.cs:665 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_dept_name"] | p_dept_name.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-e49589ac | SaveButton | DMF0044_Sales_Reports.cs:665 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_dept_name.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-309a84d7 | SaveButton | DMF0044_Sales_Reports.cs:666 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_end_cust_report"] | p_end_cust_report.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-56ea739e | SaveButton | DMF0044_Sales_Reports.cs:666 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_end_cust_report.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cc6be87 | SaveButton | DMF0044_Sales_Reports.cs:667 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_cust_report"] | p_cust_report.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-15feb616 | SaveButton | DMF0044_Sales_Reports.cs:667 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_cust_report.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1e99975 | SaveButton | DMF0044_Sales_Reports.cs:668 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_product_group"] | p_product_group.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4897d6f9 | SaveButton | DMF0044_Sales_Reports.cs:668 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_product_group.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4111ba0 | SaveButton | DMF0044_Sales_Reports.cs:669 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_item_id"] | p_item_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-35ad5bcf | SaveButton | DMF0044_Sales_Reports.cs:669 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_item_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-103c3382 | SaveButton | DMF0044_Sales_Reports.cs:670 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_measure"] | p_measure.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-25b3102e | SaveButton | DMF0044_Sales_Reports.cs:670 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_measure.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-5319211d | SaveButton | DMF0044_Sales_Reports.cs:671 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b0470449 | SaveButton | DMF0044_Sales_Reports.cs:671 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_yyyymmdd.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-46cbda9b | SaveButton | DMF0044_Sales_Reports.cs:672 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_currency"] | p_currency.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-252d9ec9 | SaveButton | DMF0044_Sales_Reports.cs:672 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_currency.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7fc23f9 | SaveButton | DMF0044_Sales_Reports.cs:673 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_company_id"] | p_company_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-2d433b14 | SaveButton | DMF0044_Sales_Reports.cs:673 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_company_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-28b37404 | SaveButton | DMF0044_Sales_Reports.cs:674 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_qty"] | p_qty.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-66a285ed | SaveButton | DMF0044_Sales_Reports.cs:674 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_qty.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-368a0213 | SaveButton | DMF0044_Sales_Reports.cs:675 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_created_by"] | p_created_by.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-1f6148bb | SaveButton | DMF0044_Sales_Reports.cs:675 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_created_by.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-81cb77ca | SaveButton | DMF0044_Sales_Reports.cs:676 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_cell_model_info"] | p_cell_model_info.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4c781436 | SaveButton | DMF0044_Sales_Reports.cs:676 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_cell_model_info.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd56c276 | SaveButton | DMF0044_Sales_Reports.cs:677 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | request.Parameters["p_cell_model"] | p_cell_model.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-41479405 | SaveButton | DMF0044_Sales_Reports.cs:677 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | DATA_OP | p_cell_model.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-24e4dd44 | SaveButton | DMF0044_Sales_Reports.cs:679 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f59c9a1f | SaveButton | DMF0044_Sales_Reports.cs:681 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a00fbb8a | SaveButton | DMF0044_Sales_Reports.cs:685 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3158ee64 | SaveButton | DMF0044_Sales_Reports.cs:690 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c9362941 | SaveButton | DMF0044_Sales_Reports.cs:694 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fb48fb67 | SaveButton | DMF0044_Sales_Reports.cs:696 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f32e15d | SaveButton | DMF0044_Sales_Reports.cs:698 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-3f56628e | SaveButton | DMF0044_Sales_Reports.cs:706 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-78942dd5 | SaveButton | DMF0044_Sales_Reports.cs:710 | else of (sDataType == "ALL") ▸ if (sDataType == "2") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetNam… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a853f5fb | SaveButton | DMF0044_Sales_Reports.cs:722 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f71b499a | SaveButton | DMF0044_Sales_Reports.cs:723 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-253110c3 | SaveButton | DMF0044_Sales_Reports.cs:778 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Department" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e38eeb86 | SaveButton | DMF0044_Sales_Reports.cs:779 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2cc9f099 | SaveButton | DMF0044_Sales_Reports.cs:780 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7fc7df68 | SaveButton | DMF0044_Sales_Reports.cs:904 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | ENDPOINT | new FoxDataRequest | ("DM.DMF0044_SAVE_SALES_PLAN_REPORT_C_CF") ⇒ DM.DMF0044_SAVE_SALES_PLAN_REPORT_C_CF | 엔드포인트 요청 생성 |  |  |  |
| AC-6487b87f | SaveButton | DMF0044_Sales_Reports.cs:905 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-5bf2936d | SaveButton | DMF0044_Sales_Reports.cs:905 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_active_flag.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-00a066ee | SaveButton | DMF0044_Sales_Reports.cs:906 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_division_id"] | p_division_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-420ba05b | SaveButton | DMF0044_Sales_Reports.cs:906 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_division_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f309aa1 | SaveButton | DMF0044_Sales_Reports.cs:907 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_version_no"] | p_version_no.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-8e943d44 | SaveButton | DMF0044_Sales_Reports.cs:907 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_version_no.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-5663dc3a | SaveButton | DMF0044_Sales_Reports.cs:908 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_cutoff_type"] | p_cutoff_type.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-81f10a14 | SaveButton | DMF0044_Sales_Reports.cs:908 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_cutoff_type.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7381e00 | SaveButton | DMF0044_Sales_Reports.cs:909 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_cutoff_yyyymmdd"] | p_cutoff_yyyymmdd.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-a75a9e5d | SaveButton | DMF0044_Sales_Reports.cs:909 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_cutoff_yyyymmdd.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1736b98d | SaveButton | DMF0044_Sales_Reports.cs:910 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_department_id"] | p_department_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-44f2df76 | SaveButton | DMF0044_Sales_Reports.cs:910 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_department_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-3596fcdf | SaveButton | DMF0044_Sales_Reports.cs:911 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_department_name"] | p_department_name.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-6e502a48 | SaveButton | DMF0044_Sales_Reports.cs:911 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_department_name.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-752245ff | SaveButton | DMF0044_Sales_Reports.cs:912 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-20e1e5dc | SaveButton | DMF0044_Sales_Reports.cs:912 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_dept_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-42821732 | SaveButton | DMF0044_Sales_Reports.cs:913 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_dept_name"] | p_dept_name.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-76283f3c | SaveButton | DMF0044_Sales_Reports.cs:913 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_dept_name.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-854e9b0f | SaveButton | DMF0044_Sales_Reports.cs:914 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_end_cust_report"] | p_end_cust_report.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-83864841 | SaveButton | DMF0044_Sales_Reports.cs:914 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_end_cust_report.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-96f75d56 | SaveButton | DMF0044_Sales_Reports.cs:915 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_cust_report"] | p_cust_report.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-71a6602b | SaveButton | DMF0044_Sales_Reports.cs:915 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_cust_report.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-61023abd | SaveButton | DMF0044_Sales_Reports.cs:916 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_product_group"] | p_product_group.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-fb775b56 | SaveButton | DMF0044_Sales_Reports.cs:916 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_product_group.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e862eb5 | SaveButton | DMF0044_Sales_Reports.cs:917 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_item_id"] | p_item_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-41facbdd | SaveButton | DMF0044_Sales_Reports.cs:917 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_item_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab6c8fdd | SaveButton | DMF0044_Sales_Reports.cs:918 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_measure"] | p_measure.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-19744856 | SaveButton | DMF0044_Sales_Reports.cs:918 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_measure.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fb371e2 | SaveButton | DMF0044_Sales_Reports.cs:919 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-2d809a3c | SaveButton | DMF0044_Sales_Reports.cs:919 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_yyyymmdd.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-742c57dc | SaveButton | DMF0044_Sales_Reports.cs:920 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_currency"] | p_currency.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-e4b73bdd | SaveButton | DMF0044_Sales_Reports.cs:920 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_currency.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-838b9955 | SaveButton | DMF0044_Sales_Reports.cs:921 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-854b988e | SaveButton | DMF0044_Sales_Reports.cs:921 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_scm_site_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf8650c8 | SaveButton | DMF0044_Sales_Reports.cs:922 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_project_code"] | p_project_code.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-d9104645 | SaveButton | DMF0044_Sales_Reports.cs:922 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_project_code.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-86568083 | SaveButton | DMF0044_Sales_Reports.cs:923 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_company_id"] | p_company_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-3a3d21f6 | SaveButton | DMF0044_Sales_Reports.cs:923 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_company_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2f74b3d | SaveButton | DMF0044_Sales_Reports.cs:924 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-efb1c095 | SaveButton | DMF0044_Sales_Reports.cs:924 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_fcst_type.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-fcb95d0b | SaveButton | DMF0044_Sales_Reports.cs:925 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-69fb3b67 | SaveButton | DMF0044_Sales_Reports.cs:925 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_incoterms.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c1ef1fc | SaveButton | DMF0044_Sales_Reports.cs:926 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_qty"] | p_qty.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-599fa06b | SaveButton | DMF0044_Sales_Reports.cs:926 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_qty.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-408a49a1 | SaveButton | DMF0044_Sales_Reports.cs:927 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_created_by"] | p_created_by.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-bde4a41b | SaveButton | DMF0044_Sales_Reports.cs:927 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_created_by.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-0998e2eb | SaveButton | DMF0044_Sales_Reports.cs:928 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_cell_model_info"] | p_cell_model_info.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-bbacf606 | SaveButton | DMF0044_Sales_Reports.cs:928 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_cell_model_info.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e424a71f | SaveButton | DMF0044_Sales_Reports.cs:929 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | request.Parameters["p_cell_model"] | p_cell_model.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-a4d0a988 | SaveButton | DMF0044_Sales_Reports.cs:929 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | DATA_OP | p_cell_model.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-77608432 | SaveButton | DMF0044_Sales_Reports.cs:931 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6476bbc1 | SaveButton | DMF0044_Sales_Reports.cs:933 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eb2fb350 | SaveButton | DMF0044_Sales_Reports.cs:937 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e3847d46 | SaveButton | DMF0044_Sales_Reports.cs:942 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3adf41ba | SaveButton | DMF0044_Sales_Reports.cs:946 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-45efef61 | SaveButton | DMF0044_Sales_Reports.cs:948 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0ccf730 | SaveButton | DMF0044_Sales_Reports.cs:950 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-d02b99d6 | SaveButton | DMF0044_Sales_Reports.cs:958 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b6c5c42c | SaveButton | DMF0044_Sales_Reports.cs:962 | else of (sDataType == "ALL") ▸ else of (sDataType == "2") ▸ if (sDataType == "1") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0044_Sales_Reports.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c41f05b | this.Load | DMF0044_Sales_Reports.cs:153 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c340726b | this.Load | DMF0044_Sales_Reports.cs:154 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f2605287 | this.Load | DMF0044_Sales_Reports.cs:160 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1332016e | this.Load | DMF0044_Sales_Reports.cs:160 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0044_Sales_Reports.SetRowSpanFucTwo

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a36a9c7e | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0044_Sales_Reports.cs:1369 | for (i <= iEndCol) ▸ for (j <= iEndRow) ▸ if (sFYear != siSpread.GetText(j, i)) | GRID_STYLE | siSpread.SpreadObject.Sheets[0].AddSpanCell | (iFRow, i, iLRow - 1, 1) | 그리드 표시 설정 |  |  |  |
| AC-e5c67530 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0044_Sales_Reports.cs:1377 | for (i <= iEndCol) ▸ for (j <= iEndRow) ▸ if (j == iEndRow) | GRID_STYLE | siSpread.SpreadObject.Sheets[0].AddSpanCell | (iFRow, i, iLRow, 1) | 그리드 표시 설정 |  |  |  |
| AC-bb011465 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0044_Sales_Reports.cs:1390 | for (i <= iEndCol) | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-af8db04d | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0044_Sales_Reports.cs:1391 | for (i <= iEndCol) | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |

## DMF0044_Sales_Reports.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a442d2d | this.spdMain.CellDoubleClick | DMF0044_Sales_Reports.cs:1317 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (sITEM_ID != "기타매출") | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-ec3bcc95 | this.spdMain.CellDoubleClick | DMF0044_Sales_Reports.cs:1319 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (sITEM_ID != "기타매출") | POPUP | popItem.Form_Load | (false, sDiv, sTeam, "", "", "", "") | 팝업 초기화(인자 전달) |  |  |  |
| AC-e6d234aa | this.spdMain.CellDoubleClick | DMF0044_Sales_Reports.cs:1320 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (sITEM_ID != "기타매출") | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-01a0a8c9 | this.spdMain.CellDoubleClick | DMF0044_Sales_Reports.cs:1321 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (sITEM_ID != "기타매출") | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0fc76c5b | this.spdMain.CellDoubleClick | DMF0044_Sales_Reports.cs:1323 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (sITEM_ID != "기타매출") | GRID_SET | siMain.SetText | (e.Row, e.Column, popItem.ItemID) | 그리드 값 설정 |  |  |  |
| AC-26403b6b | this.spdMain.CellDoubleClick | DMF0044_Sales_Reports.cs:1324 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (sITEM_ID != "기타매출") | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), popItem.ItemName) | 그리드 값 설정 |  |  |  |

## DMF0044_Sales_Reports.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b96b47f0 | dsdm.Changed | DMF0044_Sales_Reports.cs:1180 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | COMBO_DATA | Data.Common | (Data.Type.DMF0044_DEPARTMENT_TEAM, false, sDEPT_NAME, "") ⇒ biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7840c52a | dsdm.Changed | DMF0044_Sales_Reports.cs:1181 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f1848e6d | dsdm.Changed | DMF0044_Sales_Reports.cs:1184 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-b06bfa5e | dsdm.Changed | DMF0044_Sales_Reports.cs:1185 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |
| AC-2cf2d757 | dsdm.Changed | DMF0044_Sales_Reports.cs:1187 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-ae31b03b | dsdm.Changed | DMF0044_Sales_Reports.cs:1188 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-0677c121 | dsdm.Changed | DMF0044_Sales_Reports.cs:1189 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-7fcc7842 | dsdm.Changed | DMF0044_Sales_Reports.cs:1190 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-a0ac56b5 | dsdm.Changed | DMF0044_Sales_Reports.cs:1191 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-fae4a639 | dsdm.Changed | DMF0044_Sales_Reports.cs:1195 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | COMBO_DATA | Data.Common | (Data.Type.DMF0044_ETC_SALE_RESULT_TYPE_40, false, "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0044_ETC_SALE_RESULT_TYPE_40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d715fbc7 | dsdm.Changed | DMF0044_Sales_Reports.cs:1196 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c042e500 | dsdm.Changed | DMF0044_Sales_Reports.cs:1199 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-24b3c689 | dsdm.Changed | DMF0044_Sales_Reports.cs:1200 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |
| AC-dac86a09 | dsdm.Changed | DMF0044_Sales_Reports.cs:1203 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | DATA_OP | dtNull.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-035ab9b2 | dsdm.Changed | DMF0044_Sales_Reports.cs:1204 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | DATA_OP | dtNull.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d72d608 | dsdm.Changed | DMF0044_Sales_Reports.cs:1205 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | DATA_OP | dtNull.Rows.Add | ("", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ab69b42 | dsdm.Changed | DMF0044_Sales_Reports.cs:1207 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), dtNull) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a1429b7d | dsdm.Changed | DMF0044_Sales_Reports.cs:1208 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), dtNull) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-07b5ffe0 | dsdm.Changed | DMF0044_Sales_Reports.cs:1209 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), dtNull) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-655c564e | dsdm.Changed | DMF0044_Sales_Reports.cs:1211 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-13c38f7f | dsdm.Changed | DMF0044_Sales_Reports.cs:1212 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-d3b39495 | dsdm.Changed | DMF0044_Sales_Reports.cs:1213 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-66a0709a | dsdm.Changed | DMF0044_Sales_Reports.cs:1214 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-9cf94885 | dsdm.Changed | DMF0044_Sales_Reports.cs:1215 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-61bae2bc | dsdm.Changed | DMF0044_Sales_Reports.cs:1224 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | COMBO_DATA | Data.Common | (Data.Type.DMF0044_MDF_ENDCUST_REPORT, false, "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0044_MDF_ENDCUST_REPORT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-70c2f531 | dsdm.Changed | DMF0044_Sales_Reports.cs:1231 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-80ae5c63 | dsdm.Changed | DMF0044_Sales_Reports.cs:1232 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), dtProduct) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-21cef103 | dsdm.Changed | DMF0044_Sales_Reports.cs:1235 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-67a712ab | dsdm.Changed | DMF0044_Sales_Reports.cs:1236 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |
| AC-615b9e42 | dsdm.Changed | DMF0044_Sales_Reports.cs:1239 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-4c182955 | dsdm.Changed | DMF0044_Sales_Reports.cs:1240 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |
| AC-df47d2c7 | dsdm.Changed | DMF0044_Sales_Reports.cs:1244 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | COMBO_DATA | Data.Common | (Data.Type.DMF0005_REPORT_GROUP2, false, "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0005_REPORT_GROUP2] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ec432296 | dsdm.Changed | DMF0044_Sales_Reports.cs:1245 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CUST_REPORT), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-46c84f76 | dsdm.Changed | DMF0044_Sales_Reports.cs:1248 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-a4f806b3 | dsdm.Changed | DMF0044_Sales_Reports.cs:1249 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |
| AC-63f48d37 | dsdm.Changed | DMF0044_Sales_Reports.cs:1251 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "기타매출") | 그리드 값 설정 |  |  |  |
| AC-c4a7bb76 | dsdm.Changed | DMF0044_Sales_Reports.cs:1252 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "기타매출") | 그리드 값 설정 |  |  |  |
| AC-e769f36d | dsdm.Changed | DMF0044_Sales_Reports.cs:1253 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-db9ccd99 | dsdm.Changed | DMF0044_Sales_Reports.cs:1254 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-1dcc90e6 | dsdm.Changed | DMF0044_Sales_Reports.cs:1255 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-16b0466f | dsdm.Changed | DMF0044_Sales_Reports.cs:1260 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | DATA_OP | dtCustomer.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ea3431d | dsdm.Changed | DMF0044_Sales_Reports.cs:1261 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | DATA_OP | dtCustomer.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d464761 | dsdm.Changed | DMF0044_Sales_Reports.cs:1262 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | DATA_OP | dtCustomer.Rows.Add | ("", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-da93e847 | dsdm.Changed | DMF0044_Sales_Reports.cs:1264 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ac26eccd | dsdm.Changed | DMF0044_Sales_Reports.cs:1267 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-4defbb91 | dsdm.Changed | DMF0044_Sales_Reports.cs:1268 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |
| AC-1e64fa68 | dsdm.Changed | DMF0044_Sales_Reports.cs:1270 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-a19afe30 | dsdm.Changed | DMF0044_Sales_Reports.cs:1271 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-0ecfcb95 | dsdm.Changed | DMF0044_Sales_Reports.cs:1272 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-dec1dc40 | dsdm.Changed | DMF0044_Sales_Reports.cs:1273 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-9f5bc5ea | dsdm.Changed | DMF0044_Sales_Reports.cs:1274 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-e4b0fe0d | dsdm.Changed | DMF0044_Sales_Reports.cs:1281 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | DATA_OP | dtNull.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-106b5264 | dsdm.Changed | DMF0044_Sales_Reports.cs:1282 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | DATA_OP | dtNull.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f93f51b0 | dsdm.Changed | DMF0044_Sales_Reports.cs:1283 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | DATA_OP | dtNull.Rows.Add | ("", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-5fd6a0f9 | dsdm.Changed | DMF0044_Sales_Reports.cs:1286 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), dtNull) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-35e1de53 | dsdm.Changed | DMF0044_Sales_Reports.cs:1287 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), dtProduct) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-aab3865f | dsdm.Changed | DMF0044_Sales_Reports.cs:1289 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-20a5e8d1 | dsdm.Changed | DMF0044_Sales_Reports.cs:1290 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-7e918377 | dsdm.Changed | DMF0044_Sales_Reports.cs:1291 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-d890a853 | dsdm.Changed | DMF0044_Sales_Reports.cs:1299 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) > 0) &… | GRID_SET | siMain.SetText | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |

## DMF0044_Sales_Reports.YearSet

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9934ef59 | this.Load | DMF0044_Sales_Reports.cs:1087 |  | LIST_REBIND | clsCtrl.setListBox | (dtYYYY, usrYear, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3c9f3004 | this.Load | DMF0044_Sales_Reports.cs:1088 |  | VALUE_SET | usrYear.SelectedValue | DateTime.Now.Year | 컨트롤 값 설정 |  |  |  |

## DMF0044_Sales_VersionCopyPopUp.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-599cdfc8 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0044_Sales_VersionCopyPopUp.cs:360 | switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (sTransferFlag == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00280") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4be29494 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0044_Sales_VersionCopyPopUp.cs:361 | switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (sTransferFlag == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc2cff12 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0044_Sales_VersionCopyPopUp.cs:366 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0044_Sales_VersionCopyPopUp.btnTransfer_Click

진입점: this.btnTransfer.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cda91c7e | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:397 | try ▸ if (cellRange.LongLength > 0) ▸ if (iCount > 1) | FLAG | sVersions | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-abd7706d | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:398 | try ▸ if (cellRange.LongLength > 0) ▸ if (iCount > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00279", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cf4cd748 | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:399 | try ▸ if (cellRange.LongLength > 0) ▸ if (iCount > 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cec8ec7b | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:404 | try ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13da5a9c | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:411 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0044_MOBILE_REPORT_CREATE") ⇒ DM.DMF0044_MOBILE_REPORT_CREATE | 엔드포인트 요청 생성 |  |  |  |
| AC-564330fe | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:412 | try | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3960cfd0 | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:413 | try | DATA_OP | request.Parameters["p_version_no"] | strVersion | 행/컬럼 값 대입 |  |  |  |
| AC-3e950b86 | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:414 | try | DATA_OP | request.Parameters["p_version_type"] | this.sVersion_Type | 행/컬럼 값 대입 |  |  |  |
| AC-66955624 | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:415 | try | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a70d6966 | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:416 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fe0d6332 | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:425 | try ▸ if (ds.Tables.Count != 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "MSG00156") | MESSAGE | MessageHelper.GMessageBox | ("MSG00156") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ea6b852d | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:429 | try ▸ if (ds.Tables.Count != 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "MSG00156") | MESSAGE | MessageHelper.GMessageBox | (ds.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1388db6b | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:434 | try ▸ else of (ds.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f78fcbe | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:435 | try ▸ else of (ds.Tables.Count != 0) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-b76bb76b | this.btnTransfer.Click | DMF0044_Sales_VersionCopyPopUp.cs:440 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0044_Sales_VersionCopyPopUp.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-770b326f | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:149 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-43783c2c | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:150 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5fcfc8a7 | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:151 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_Sales_VersionCopyPopUp.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a264e84 | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:144 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0044_Sales_VersionCopyPopUp.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-789765a0 | Dispose | DMF0044_Sales_VersionCopyPopUp.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0044_Sales_VersionCopyPopUp.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f69e738 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:190 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7309c03b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:206 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8e319bdf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:210 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0044_GET_COPY_VERSION_POPUP") ⇒ DM.DMF0044_GET_COPY_VERSION_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-147a6e3e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:211 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e4ad7fb8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:212 | try ▸ lambda | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-62b16e56 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:213 | try ▸ lambda | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-59ab86a5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:214 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-5ed0c955 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:215 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4925b08d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:216 | try ▸ lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-5a5fb3e5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:217 | try ▸ lambda | DATA_OP | request.Parameters["p_version_no"] | p_version_no | 행/컬럼 값 대입 |  |  |  |
| AC-848ed166 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:218 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-db77c905 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:220 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-79428ca5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:224 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9c6d9a59 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:225 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-23bac3f2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:234 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c77a933 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:239 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0044_Sales_VersionCopyPopUp.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff09cd5e | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:89 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8293b7c5 | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:93 |  | VALUE_SET | drpPeriod.InitValue | sStartDate + ":" + sEndDate | 컨트롤 값 설정 |  |  |  |
| AC-b4f22970 | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:95 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0044_Sales_VersionCopyPopUp.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b6ed7b8 | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:129 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c9eb732d | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:130 |  | FLAG | dtDivision | Data.Common(Data.Type.Division, false,"" , "") ⇒ biz:CommonData.CommonDataList [code=Division] | 화면 필드/플래그 변경 |  |  |  |
| AC-a7845f5c | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:130 |  | COMBO_DATA | Data.Common | (Data.Type.Division, false,"" , "") ⇒ biz:CommonData.CommonDataList [code=Division] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-02d9aafd | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:133 |  | FLAG | dtDivision2 | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-07bbc41b | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:133 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c343baaa | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:134 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision2, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-38c6067b | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:136 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-871c50ee | this.Load | DMF0044_Sales_VersionCopyPopUp.cs:138 |  | VALUE_SET | txtType.Text | sVersion_Type | 컨트롤 값 설정 |  |  |  |

## DMF0044_Sales_VersionCopyPopUp.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a49e25c1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:161 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-3e2f3f9f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:162 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-62af1fe2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:163 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-91b65515 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:164 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cefa75c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:165 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0044" | 행/컬럼 값 대입 |  |  |  |
| AC-428c7166 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:166 |  | DATA_OP | request.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-7a41f32e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:167 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-d113d79a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:169 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f9ed7582 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_Sales_VersionCopyPopUp.cs:172 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dt) | 그리드 재구성/초기화 |  |  |  |

## DMF0044_Sales_VersionCopyPopUp.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-001fd07a | (진입점 미연결) | DMF0044_Sales_VersionCopyPopUp.cs:105 |  | FLAG | this.sVersion_Type | (sVersion_Type == "REPORT_SP_W") ? "SP_W" : "BP_M" | 화면 필드/플래그 변경 |  |  |  |
| AC-6558bf19 | (진입점 미연결) | DMF0044_Sales_VersionCopyPopUp.cs:107 |  | FLAG | sTransferFlag | sFlag | 화면 필드/플래그 변경 |  |  |  |
| AC-86267b03 | (진입점 미연결) | DMF0044_Sales_VersionCopyPopUp.cs:111 | if (sTransferFlag == true) | VALUE_SET | this.Text | "MDF Version[전송]" | 컨트롤 값 설정 |  |  |  |
| AC-43f0cf87 | (진입점 미연결) | DMF0044_Sales_VersionCopyPopUp.cs:113 | if (sTransferFlag == true) | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-df97018a | (진입점 미연결) | DMF0044_Sales_VersionCopyPopUp.cs:117 | else of (sTransferFlag == true) | VALUE_SET | this.Text | "Version Copy" | 컨트롤 값 설정 |  |  |  |
| AC-255923c4 | (진입점 미연결) | DMF0044_Sales_VersionCopyPopUp.cs:119 | else of (sTransferFlag == true) | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DMF0044_Sales_VersionCopyPopUp.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9aeed373 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:245 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3ce0688f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:246 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ffbd0303 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:270 | try ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr.RowCount) ▸ if… | FLAG | sVersions | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-d42a2bfd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:277 | try ▸ if (cellRange.LongLength > 0) ▸ if (iCount > 1) | FLAG | sVersions | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b70f566f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:278 | try ▸ if (cellRange.LongLength > 0) ▸ if (iCount > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00279", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-692ab778 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:279 | try ▸ if (cellRange.LongLength > 0) ▸ if (iCount > 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3471c2b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:284 | try ▸ else of (cellRange.LongLength > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00279", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1eef5b63 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:285 | try ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d77d0fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:290 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-922bbceb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:306 | try ▸ for (i < asDivision.Length) | ENDPOINT | new FoxDataRequest | (strQuery) ⇒ DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY \| DM.DMF0044_SAVE_BIZ_PLAN_VERSION_COPY | 엔드포인트 요청 생성 |  |  |  |
| AC-79e6edbb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:307 | try ▸ for (i < asDivision.Length) | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e7026806 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:308 | try ▸ for (i < asDivision.Length) | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-22fbbeb8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:309 | try ▸ for (i < asDivision.Length) | DATA_OP | request.Parameters["p_version_no"] | sVersions | 행/컬럼 값 대입 |  |  |  |
| AC-0b95dd59 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:310 | try ▸ for (i < asDivision.Length) | DATA_OP | request.Parameters["p_version_description"] | txtDes.Text | 행/컬럼 값 대입 |  |  |  |
| AC-8822cf4f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:311 | try ▸ for (i < asDivision.Length) | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-57313e9d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:312 | try ▸ for (i < asDivision.Length) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-615775eb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:318 | try ▸ for (i < asDivision.Length) ▸ if (response.DataSet.Tables.Count != 0) ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "MSG00… | MESSAGE | MessageHelper.GMessageBox | ("MSG00156") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-692525d2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:322 | try ▸ for (i < asDivision.Length) ▸ if (response.DataSet.Tables.Count != 0) ▸ else of (response.DataSet.Tables[0].Rows[0][0].ToString() == "… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f7236bd4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:323 | try ▸ for (i < asDivision.Length) ▸ if (response.DataSet.Tables.Count != 0) ▸ else of (response.DataSet.Tables[0].Rows[0][0].ToString() == "… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-168ecdec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:327 | try ▸ for (i < asDivision.Length) ▸ if (response.DataSet.Tables.Count != 0) ▸ else of (response.DataSet.Tables[0].Rows[0][0].ToString() == "… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c91a1b55 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:332 | try ▸ for (i < asDivision.Length) ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd0b9753 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:333 | try ▸ for (i < asDivision.Length) ▸ else of (response.DataSet.Tables.Count != 0) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-5e26f98e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:340 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-154ecef3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_Sales_VersionCopyPopUp.cs:344 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0044_Sales_VersionCopyPopUp.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41cd29c5 | this.spdMain.TopChange | DMF0044_Sales_VersionCopyPopUp.cs:374 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_Sales_VersionPopUp.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f15cd94 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0044_Sales_VersionPopUp.cs:306 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0044_Sales_VersionPopUp.btnCopy_Click

진입점: this.btnCopy.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6dc32d39 | this.btnCopy.Click | DMF0044_Sales_VersionPopUp.cs:363 |  | POPUP | new DMF0044_Sales_VersionCopyPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-4fcca1fd | this.btnCopy.Click | DMF0044_Sales_VersionPopUp.cs:365 |  | CALL_EXT | pop.LoadData | (sVersion_Type, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9de9457f | this.btnCopy.Click | DMF0044_Sales_VersionPopUp.cs:366 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e199ea20 | this.btnCopy.Click | DMF0044_Sales_VersionPopUp.cs:367 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0044_Sales_VersionPopUp.btnTransfer_Click

진입점: this.btnTransfer.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c2af446 | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:392 | try ▸ if (cellRange.LongLength > 0) ▸ if (iCount > 1) | FLAG | sVersions | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-71a87792 | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:393 | try ▸ if (cellRange.LongLength > 0) ▸ if (iCount > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00279", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-829f7d40 | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:394 | try ▸ if (cellRange.LongLength > 0) ▸ if (iCount > 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ffa9c369 | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:399 | try ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fcb486e6 | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:406 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0044_MOBILE_REPORT_CREATE") ⇒ DM.DMF0044_MOBILE_REPORT_CREATE | 엔드포인트 요청 생성 |  |  |  |
| AC-3a995eb8 | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:407 | try | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-eab98d76 | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:408 | try | DATA_OP | request.Parameters["p_version_no"] | strVersion | 행/컬럼 값 대입 |  |  |  |
| AC-def2c7dd | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:409 | try | DATA_OP | request.Parameters["p_version_type"] | this.sVersion_Type | 행/컬럼 값 대입 |  |  |  |
| AC-232bea31 | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:410 | try | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1b4c96d4 | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:411 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bd0d8367 | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:420 | try ▸ if (ds.Tables.Count != 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "MSG00156") | MESSAGE | MessageHelper.GMessageBox | ("MSG00156") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-993a94ad | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:424 | try ▸ if (ds.Tables.Count != 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "MSG00156") | MESSAGE | MessageHelper.GMessageBox | (ds.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cff6773d | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:429 | try ▸ else of (ds.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2cef6fa6 | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:430 | try ▸ else of (ds.Tables.Count != 0) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-edb02b32 | this.btnTransfer.Click | DMF0044_Sales_VersionPopUp.cs:435 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0044_Sales_VersionPopUp.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd1c8613 | this.Load | DMF0044_Sales_VersionPopUp.cs:155 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e462446f | this.Load | DMF0044_Sales_VersionPopUp.cs:156 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf62bd28 | this.Load | DMF0044_Sales_VersionPopUp.cs:157 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_Sales_VersionPopUp.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a006efe0 | this.Load | DMF0044_Sales_VersionPopUp.cs:148 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0044_Sales_VersionPopUp.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb2b6bf2 | Dispose | DMF0044_Sales_VersionPopUp.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0044_Sales_VersionPopUp.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.btnCopy.Click / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8081b56 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:197 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0b72e2b2 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:208 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0044_GET_SALES_VERSION_POPUP") ⇒ DM.DMF0044_GET_SALES_VERSION_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-354e92db | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:209 | try | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4d3a1e7e | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:210 | try | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-c26b7763 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:211 | try | DATA_OP | request.Parameters["p_sdt"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-454fea29 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:212 | try | DATA_OP | request.Parameters["p_edt"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-6d7255ab | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:213 | try | DATA_OP | request.Parameters["p_version_type"] | this.sVersion_Type | 행/컬럼 값 대입 |  |  |  |
| AC-498abed6 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:214 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a4242011 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:222 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-79890752 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:223 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-126c1433 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:225 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-40d820b6 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:232 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-92d4264d | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:237 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0044_Sales_VersionPopUp.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8b57950 | this.Load | DMF0044_Sales_VersionPopUp.cs:90 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-612f8b2e | this.Load | DMF0044_Sales_VersionPopUp.cs:94 |  | VALUE_SET | drpPeriod.InitValue | sStartDate + ":" + sEndDate | 컨트롤 값 설정 |  |  |  |
| AC-8017280c | this.Load | DMF0044_Sales_VersionPopUp.cs:96 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0044_Sales_VersionPopUp.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9730e440 | this.Load | DMF0044_Sales_VersionPopUp.cs:134 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d93ea99b | this.Load | DMF0044_Sales_VersionPopUp.cs:135 |  | FLAG | dtDivision | Data.Common(Data.Type.Division, false,"" , "") ⇒ biz:CommonData.CommonDataList [code=Division] | 화면 필드/플래그 변경 |  |  |  |
| AC-af97ab49 | this.Load | DMF0044_Sales_VersionPopUp.cs:135 |  | COMBO_DATA | Data.Common | (Data.Type.Division, false,"" , "") ⇒ biz:CommonData.CommonDataList [code=Division] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ba903bb0 | this.Load | DMF0044_Sales_VersionPopUp.cs:136 |  | FLAG | dtDivision2 | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-0eca8268 | this.Load | DMF0044_Sales_VersionPopUp.cs:136 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-02f1a30b | this.Load | DMF0044_Sales_VersionPopUp.cs:137 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision2, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d38898e3 | this.Load | DMF0044_Sales_VersionPopUp.cs:139 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## DMF0044_Sales_VersionPopUp.InitSpread

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.btnCopy.Click / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-043fdb63 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:167 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-454e6de9 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:168 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-be8c701f | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:169 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0a9abc5f | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:170 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e3d6227d | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:171 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0044" | 행/컬럼 값 대입 |  |  |  |
| AC-37d8bfc3 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:172 |  | DATA_OP | request.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-9b3c3112 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:173 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-1bec2dcd | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:175 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-591acd91 | this.Load 외 4 | DMF0044_Sales_VersionPopUp.cs:178 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dt) | 그리드 재구성/초기화 |  |  |  |

## DMF0044_Sales_VersionPopUp.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f0e1674 | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:106 |  | FLAG | this.sVersion_Type | sVersion_Type | 화면 필드/플래그 변경 |  |  |  |
| AC-70482a8a | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:108 |  | FLAG | sTransferFlag | sFlag | 화면 필드/플래그 변경 |  |  |  |
| AC-9559502b | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:112 | if (sTransferFlag == true) | VALUE_SET | this.Text | "MDF Version[전송]" | 컨트롤 값 설정 |  |  |  |
| AC-9d79fccb | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:113 | if (sTransferFlag == true) | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a6b75ce6 | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:114 | if (sTransferFlag == true) | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5961c072 | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:118 | else of (sTransferFlag == true) | VALUE_SET | this.Text | "MDF Version" | 컨트롤 값 설정 |  |  |  |
| AC-0d36ee4e | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:119 | else of (sTransferFlag == true) | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8f9d85d8 | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:122 | else of (sTransferFlag == true) | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## DMF0044_Sales_VersionPopUp.SaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-456723ab | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:254 | if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1108873a | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:263 | for (i < asDivision.Length) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sPlanBinding)) … | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b40b2468 | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:272 | for (i < asDivision.Length) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | asDivision[i] | 행/컬럼 값 대입 |  |  |  |
| AC-fb54887b | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:273 | for (i < asDivision.Length) ▸ lambda | DATA_OP | request.Parameters["p_version_description"] | p_version_description | 행/컬럼 값 대입 |  |  |  |
| AC-4c54473e | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:274 | for (i < asDivision.Length) ▸ lambda | DATA_OP | request.Parameters["p_ver_type"] | p_ver_type | 행/컬럼 값 대입 |  |  |  |
| AC-f4ba99a7 | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:275 | for (i < asDivision.Length) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-06080168 | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:276 | for (i < asDivision.Length) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bcf18903 | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:278 | for (i < asDivision.Length) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1ffe8ebd | (진입점 미연결) | DMF0044_Sales_VersionPopUp.cs:288 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00151", new object[] { p_division_id, sRMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0044_Sales_VersionPopUp.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21bf1388 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_Sales_VersionPopUp.cs:328 | if (sTransferFlag == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00280") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5eea286d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_Sales_VersionPopUp.cs:329 | if (sTransferFlag == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bae181fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_Sales_VersionPopUp.cs:339 | if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ if (cr.RowCount > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00279") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c461cc6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_Sales_VersionPopUp.cs:340 | if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ if (cr.RowCount > 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97e8134c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_Sales_VersionPopUp.cs:346 | if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr.RowCount) ▸ if (sVer… | FLAG | sVersions | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-207dc492 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_Sales_VersionPopUp.cs:347 | if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr.RowCount) ▸ if (sVer… | FLAG | sCUTOFF_YYYYMMDD | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.YYYYMMDD)) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b5a9550 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_Sales_VersionPopUp.cs:349 | if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr.RowCount) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-907f937c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_Sales_VersionPopUp.cs:355 | else of (cellRange.LongLength > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00279") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-82738aa0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_Sales_VersionPopUp.cs:356 | else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0044_Sales_VersionPopUp.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d1a2070 | this.spdMain.CellDoubleClick | DMF0044_Sales_VersionPopUp.cs:321 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0044_Sales_VersionPopUp.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-363d6ef6 | this.spdMain.TopChange | DMF0044_Sales_VersionPopUp.cs:314 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8324c5d | this.btnButtonList.UsrButtonList_Click_Detected | DMF0044_SalesReport_TextboxPopup.cs:404 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-78e93384 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0044_SalesReport_TextboxPopup.cs:407 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-3683e1c4 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0044_SalesReport_TextboxPopup.cs:410 | switch (buttonItem.UserType) case ButtonListType.Excel: | CALL_BASE | ExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-725f90c0 | this.Load | DMF0044_SalesReport_TextboxPopup.cs:133 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f35e40e7 | this.Load | DMF0044_SalesReport_TextboxPopup.cs:134 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-16f289f9 | this.Load | DMF0044_SalesReport_TextboxPopup.cs:135 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bf56fb3 | this.Load | DMF0044_SalesReport_TextboxPopup.cs:112 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-c8868060 | this.Load | DMF0044_SalesReport_TextboxPopup.cs:123 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Edit) | 데이터 객체 조작/조회 |  |  |  |
| AC-41b89802 | this.Load | DMF0044_SalesReport_TextboxPopup.cs:124 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Insert) | 데이터 객체 조작/조회 |  |  |  |
| AC-21c5209b | this.Load | DMF0044_SalesReport_TextboxPopup.cs:125 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Save) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfa32001 | this.Load | DMF0044_SalesReport_TextboxPopup.cs:128 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a111481c | DeleteButton | DMF0044_SalesReport_TextboxPopup.cs:182 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e35afd3a | Dispose | DMF0044_SalesReport_TextboxPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6305a4d6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:196 | if (this.fps != null) ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | MESSAGE | MessageBox.Show | (" You don't have the permissions to access it", "Information.") | 메시지 표시 |  |  |  |
| AC-ccb20b0e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:197 | if (this.fps != null) ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-104039fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:200 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d7a4e6e5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:201 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-aca9e653 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:206 | if (this.fps != null) ▸ if (siMain.GetMaxRowIndex() == -1) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if ((response.DataSet.Tables.Count != 0) && (response.DataSet.Tables[0].Rows[0][0].ToString() == "success"))] / this.Load / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if ((response.DataSet.Tables.Count != 0) && (response.DataSet.Tables[0].Rows[0][0].ToString() == "success"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f77d19c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_SalesReport_TextboxPopup.cs:243 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3e37a86e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_SalesReport_TextboxPopup.cs:247 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0044_GET_TEXTBOX") ⇒ DM.DMF0044_GET_TEXTBOX | 엔드포인트 요청 생성 |  |  |  |
| AC-1f4c09a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_SalesReport_TextboxPopup.cs:248 | lambda | DATA_OP | request.Parameters["P_VERSION_NO"] | _sVersionNo | 행/컬럼 값 대입 |  |  |  |
| AC-3227d2b9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_SalesReport_TextboxPopup.cs:250 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d03e7b78 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_SalesReport_TextboxPopup.cs:252 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-beb97ed2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_SalesReport_TextboxPopup.cs:261 | if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0) | FLAG | sStartYYYYMM | ds.Tables[1].Rows[0]["MONDAY"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-37fda525 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_SalesReport_TextboxPopup.cs:265 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-136042c1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_SalesReport_TextboxPopup.cs:266 |  | GRID_LOCK | siMain.LockColumn | (1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-177a2b69 | this.Load | DMF0044_SalesReport_TextboxPopup.cs:85 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.GetCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f242c34 | (진입점 미연결) | DMF0044_SalesReport_TextboxPopup.cs:384 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if ((response.DataSet.Tables.Count != 0) && (response.DataSet.Tables[0].Rows[0][0].ToString() == "success"))] / this.Load / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if ((response.DataSet.Tables.Count != 0) && (response.DataSet.Tables[0].Rows[0][0].ToString() == "success"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99a9fcec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_SalesReport_TextboxPopup.cs:142 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-e21054e9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_SalesReport_TextboxPopup.cs:144 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0032436a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_SalesReport_TextboxPopup.cs:148 | if (sStartYYYYMM != "") | FLAG | sMonday | DateTime.Parse(sStartYYYYMM) | 화면 필드/플래그 변경 |  |  |  |
| AC-604993a5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_SalesReport_TextboxPopup.cs:153 | else of (sStartYYYYMM != "") ▸ if (sStartYYYYMM == "") | FLAG | sMonday | sDatetime.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(sDatetime.DayOfWeek)… | 화면 필드/플래그 변경 |  |  |  |
| AC-62aee9be | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DMF0044_SalesReport_TextboxPopup.cs:162 | for (i < 13) | GRID_INIT | siMain.AddTextColumn | (sYYYYMM, "DESCRIPTION" + (i + 1), FPMerge.None, 290, true, FPHAlign.Left, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-813f3e4e | InsertButton | DMF0044_SalesReport_TextboxPopup.cs:177 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4c7a40a | (진입점 미연결) | DMF0044_SalesReport_TextboxPopup.cs:96 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0fd23755 | (진입점 미연결) | DMF0044_SalesReport_TextboxPopup.cs:98 |  | FLAG | _sVersionNo | sVersionNo | 화면 필드/플래그 변경 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.mOK

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1b4f8d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_SalesReport_TextboxPopup.cs:417 |  | FLAG | blnOK | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80240b28 | SaveButton | DMF0044_SalesReport_TextboxPopup.cs:222 | switch (UserInfoContext.Current["NowGroupID"]) default: | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-27faed2d | SaveButton | DMF0044_SalesReport_TextboxPopup.cs:223 | switch (UserInfoContext.Current["NowGroupID"]) default: | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e75cb630 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:325 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0044_SAVE_TEXTBOX | 엔드포인트 요청 생성 |  |  |  |
| AC-75f1e649 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:326 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_VERSION_NO"] | sVERSION_NO | 행/컬럼 값 대입 |  |  |  |
| AC-82fe330d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:327 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_YYYYMM"] | sYYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-7837e150 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:328 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_DESCRIPTION1"] | sDescription1 | 행/컬럼 값 대입 |  |  |  |
| AC-4004dfed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:329 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_DESCRIPTION2"] | sDescription2 | 행/컬럼 값 대입 |  |  |  |
| AC-5ee5fdc8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:330 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_DESCRIPTION3"] | sDescription3 | 행/컬럼 값 대입 |  |  |  |
| AC-5b6fb03a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:331 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_DESCRIPTION4"] | sDescription4 | 행/컬럼 값 대입 |  |  |  |
| AC-41a073f8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:332 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_DESCRIPTION5"] | sDescription5 | 행/컬럼 값 대입 |  |  |  |
| AC-8b9402fa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:333 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_DESCRIPTION6"] | sDescription6 | 행/컬럼 값 대입 |  |  |  |
| AC-800c4f9e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:334 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_DESCRIPTION7"] | sDescription7 | 행/컬럼 값 대입 |  |  |  |
| AC-59191d98 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:335 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_DESCRIPTION8"] | sDescription8 | 행/컬럼 값 대입 |  |  |  |
| AC-7f6a54b5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:336 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_DESCRIPTION9"] | sDescription9 | 행/컬럼 값 대입 |  |  |  |
| AC-d4562b9d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:337 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_DESCRIPTION10"] | sDescription10 | 행/컬럼 값 대입 |  |  |  |
| AC-edbb9dc1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:338 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_DESCRIPTION11"] | sDescription11 | 행/컬럼 값 대입 |  |  |  |
| AC-6d360b52 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:339 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_DESCRIPTION12"] | sDescription12 | 행/컬럼 값 대입 |  |  |  |
| AC-7c926c96 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:340 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_DESCRIPTION13"] | sDescription13 | 행/컬럼 값 대입 |  |  |  |
| AC-68f023a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:341 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["P_CREATED_BY"] | sCREATED_BY | 행/컬럼 값 대입 |  |  |  |
| AC-43524d8d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:343 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0713ca1f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:348 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if ((response.DataSet.Ta… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { 1 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1f077d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:353 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ else of ((response.DataS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8366352d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:358 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ else of ((response.DataS… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9e7eda98 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:362 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ else of ((response.DataS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2256b2eb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReport_TextboxPopup.cs:369 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0044_SalesReport_TextboxPopup.SetChangeRequestInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit: ▸ if (this.fps != null)] / this.Load / EditButton [if (this.fps != null)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if ((response.DataSet.Tables.Count != 0) && (response.DataSet.Tables[0].Rows[0][0].ToString() == "success"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c9aaf7e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:430 |  | UI_PROP | cellTypeImage.Multiline | true | 속성 Multiline 설정 |  |  |  |
| AC-8f0ddd02 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:431 |  | UI_PROP | cellTypeImage.MaxLength | 8000 | 속성 MaxLength 설정 |  |  |  |
| AC-7bb66105 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:435 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION1)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-38ccdf17 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:436 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION2)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-cd654904 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:437 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION3)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-51a59e76 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:438 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION4)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-30c2e737 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:439 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION5)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-a1fbf9fa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:440 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION6)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-6bf94496 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:441 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION7)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-e58e7c2c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:442 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION8)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-227f72fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:443 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION9)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-09531180 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:444 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION10)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-9e8e06ef | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:445 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION11)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-5c7e8bc0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:446 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION12)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-1923c727 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:447 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION13)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-e3bfdbe8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReport_TextboxPopup.cs:449 | for (j <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[j, siMain.GetColumnIndex(DefColumns.DESCRIPTION1)].Row.Height | 300 | 그리드 속성/값 설정 |  |  |  |

## DMF0044_SalesReport_TextboxPopup.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99ea9a6b | this.spdMain.TopChange | DMF0044_SalesReport_TextboxPopup.cs:423 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_SalesReportExchangePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f55549e | this.btnButtonList.UsrButtonList_Click_Detected | DMF0044_SalesReportExchangePopup.cs:698 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-3e62300c | this.btnButtonList.UsrButtonList_Click_Detected | DMF0044_SalesReportExchangePopup.cs:701 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f762839e | this.btnButtonList.UsrButtonList_Click_Detected | DMF0044_SalesReportExchangePopup.cs:704 | switch (buttonItem.UserType) case ButtonListType.Excel: | CALL_BASE | ExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0044_SalesReportExchangePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63abc529 | this.Load | DMF0044_SalesReportExchangePopup.cs:169 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ed57f161 | this.Load | DMF0044_SalesReportExchangePopup.cs:170 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0f6d9083 | this.Load | DMF0044_SalesReportExchangePopup.cs:171 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_SalesReportExchangePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-194c18ab | this.Load | DMF0044_SalesReportExchangePopup.cs:143 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-ae407082 | this.Load | DMF0044_SalesReportExchangePopup.cs:157 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Edit) | 데이터 객체 조작/조회 |  |  |  |
| AC-84b94744 | this.Load | DMF0044_SalesReportExchangePopup.cs:158 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Insert) | 데이터 객체 조작/조회 |  |  |  |
| AC-e04385e1 | this.Load | DMF0044_SalesReportExchangePopup.cs:159 | switch (UserInfoContext.Current["NowGroupID"]) default: | DATA_OP | list.Add | (ButtonListType.Save) | 데이터 객체 조작/조회 |  |  |  |
| AC-a35a084f | this.Load | DMF0044_SalesReportExchangePopup.cs:162 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0044_SalesReportExchangePopup.DeleteButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Delete:] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-413c01ca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:322 | if (vAction1 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d10a905 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:324 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0044_SalesReportExchangePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40fbb4d8 | Dispose | DMF0044_SalesReportExchangePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0044_SalesReportExchangePopup.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49521bbd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:338 | if (this.fps != null) ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | MESSAGE | MessageBox.Show | (" You don't have the permissions to access it", "Information.") | 메시지 표시 |  |  |  |
| AC-74cd7c72 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:339 | if (this.fps != null) ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c339f56 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:342 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-43f66362 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:343 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-9e6636c1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:346 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(sColName), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0044_SalesReportExchangePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9cbce10 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:421 |  | DATA_OP | nvc["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-69025785 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:422 |  | DATA_OP | nvc["p_year"] | usrYear.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-9f95d381 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:423 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-94c5502a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:424 |  | DATA_OP | nvc["p_version_no"] | _sVersionNo | 행/컬럼 값 대입 |  |  |  |
| AC-dd05021e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:426 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP", nvc) ⇒ DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-89577165 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:426 |  | ENDPOINT | new CUIControl | () ⇒ DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-358dde55 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:428 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-540cc011 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:429 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1a1d3495 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:432 |  | GRID_BIND | siMain.Query | (CUIControl.GetDatatableFromSpread(siMain, "")) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8880ef40 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:432 |  | ENDPOINT | CUIControl.GetDatatableFromSpread | (siMain, "") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c0e2f177 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:435 |  | CALL_EXT | nvc.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b80ccdd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:436 |  | DATA_OP | nvc["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-eebba683 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:437 |  | DATA_OP | nvc["p_year"] | usrYear.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0fc4b790 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:438 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-561bf0d1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:439 |  | DATA_OP | nvc["p_version_no"] | _sVersionNo | 행/컬럼 값 대입 |  |  |  |
| AC-5a0665c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:441 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA", nvc) ⇒ DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-952f8363 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:441 |  | ENDPOINT | new CUIControl | () ⇒ DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-1cb2867e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:451 | for (i < dt.Rows.Count) | DATA_OP | dsSpread.Tables[0].Select | (" CURRENCY = '" + sCURRENCY.Trim() + "' AND [UNIT_CURRENCY] = '" + sUNIT_CURRENCY.Trim() … | 데이터 객체 조작/조회 |  |  |  |
| AC-ffd3d9ba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:456 | for (i < dt.Rows.Count) ▸ if (rows.Length > 0) | GRID_SET | siMain.SetText | (iRowindex, siMain.GetColumnIndex(sYYYYMMDD), sEXCHANGE_PRICE) | 그리드 값 설정 |  |  |  |
| AC-d2c1cc1e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:460 |  | DATA_OP | dsSpread.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cc35143 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:461 |  | DATA_OP | dsSpread.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-89da9db7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:462 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d714580 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:463 |  | CALL_EXT | (new CUIControl()).SetPreferredWidth | (siMain.SpreadObject, 3, true) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0044_SalesReportExchangePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adb926ec | this.Load | DMF0044_SalesReportExchangePopup.cs:83 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0044_SalesReportExchangePopup.GetCellColor

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fd61002 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:669 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0044_SalesReportExchangePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaaf2c3b | this.Load | DMF0044_SalesReportExchangePopup.cs:131 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-86e6d294 | this.Load | DMF0044_SalesReportExchangePopup.cs:132 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-463e54a5 | this.Load | DMF0044_SalesReportExchangePopup.cs:132 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4aa788e8 | this.Load | DMF0044_SalesReportExchangePopup.cs:133 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-be1e74f1 | this.Load | DMF0044_SalesReportExchangePopup.cs:135 |  | FLAG | dtDivision2 | Data.Common(Data.Type.Division) ⇒ biz:CommonData.CommonDataList [code=Division] | 화면 필드/플래그 변경 |  |  |  |
| AC-b05c090c | this.Load | DMF0044_SalesReportExchangePopup.cs:135 |  | COMBO_DATA | Data.Common | (Data.Type.Division) ⇒ biz:CommonData.CommonDataList [code=Division] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ce007cc3 | this.Load | DMF0044_SalesReportExchangePopup.cs:136 |  | FLAG | dtCurrency | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-93009e3c | this.Load | DMF0044_SalesReportExchangePopup.cs:136 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DMF0044_SalesReportExchangePopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d079ba5f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:250 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-1efa6c01 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:252 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9bd4065c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:253 |  | GRID_INIT | siMain.AddComboColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.Restricted, 120, true, dtDivision2, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-18bb88cf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:254 |  | GRID_INIT | siMain.AddTextColumn | ("Currency", DefColumns.CURRENCY, FPMerge.Restricted, 70, true, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aa91eb2b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:255 |  | GRID_INIT | siMain.AddComboColumn | ("Unit", DefColumns.UNIT_CURRENCY, FPMerge.None, 50, true, dtCurrency, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ee8cca5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:256 |  | GRID_INIT | siMain.AddTextColumn | ("Currency", DefColumns.CURRENCY_UNITCURRENCY, FPMerge.Restricted, 50, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-85230a8b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:257 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.CURRENCY_UNITCURRENCY)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9dfa653 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:263 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE") ⇒ DM.DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-ec36d705 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:264 |  | DATA_OP | request.Parameters["p_year"] | usrYear.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-adb73921 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:265 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a5036456 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:279 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["CALENDAR_MONTH"].ToString(), "D" + dt.Rows[i]["BASIS_START_DATE"].ToString(),… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b1c9b94 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:284 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["CALENDAR_YYYY"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow - 1, 25, sFYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f8c8f186 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:292 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, sFYear , FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5076b103 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:297 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-752f2f03 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DMF0044_SalesReportExchangePopup.cs:299 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.UNIT_CURRENCY)+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0044_SalesReportExchangePopup.InitSpread_X

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5bf3a0b | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:178 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-c18686b3 | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:180 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c084f756 | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:181 |  | GRID_INIT | siMain.AddTextColumn | ("Currency", DefColumns.CURRENCY, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8cf29cfe | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:182 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.CURRENCY)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-422391b6 | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:191 |  | ENDPOINT | CUIControl.GetDataUsingSQLByDB | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1493c5c1 | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:208 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["WEEK_NAME"].ToString(), dt.Rows[i]["BASIS_START_DATE"].ToString(), FPMerge.No… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d941fe72 | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:213 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["CALENDAR_YYYY"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow-1, 25, sFYear + "년", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17be5823 | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:221 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count-1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, sFYear + "년", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d84a13f | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:233 | for (i < dt.Rows.Count) ▸ if (sFMonth != dt.Rows[i]["CALENDAR_MONTH"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iMonthFRow, 1, iMonthLRow - 1, 25, sFMonth + "월", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a839b549 | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:240 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iMonthFRow, 1, iMonthLRow, 25, sFMonth + "월", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_SalesReportExchangePopup.InsertRow

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Insert:] / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-232941cc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:620 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1282cc61 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:623 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CURRENCY, "KRW") | 데이터 객체 조작/조회 |  |  |  |
| AC-37ab6b22 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:626 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-f65986e8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:627 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-625e72bf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:628 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d073c9c1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:645 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iMonth < iTime) ▸ for (i <… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY_UNITCURRENCY), siMain.Ac… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0044_SalesReportExchangePopup.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d81d9e2 | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:94 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f852f7a1 | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:97 |  | VALUE_SET | usrYear.ControlValues | sYear | 컨트롤 값 설정 |  |  |  |
| AC-0115799d | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:100 |  | FLAG | _sVersionNo | sVersionNo | 화면 필드/플래그 변경 |  |  |  |

## DMF0044_SalesReportExchangePopup.mOK

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75f0d00d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0044_SalesReportExchangePopup.cs:711 |  | FLAG | blnOK | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0044_SalesReportExchangePopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbf87d32 | SaveButton | DMF0044_SalesReportExchangePopup.cs:402 | switch (UserInfoContext.Current["NowGroupID"]) default: | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2c91d3bc | SaveButton | DMF0044_SalesReportExchangePopup.cs:403 | switch (UserInfoContext.Current["NowGroupID"]) default: | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0044_SalesReportExchangePopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d86af0b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:507 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a0c5dace | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:510 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-ff989076 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:512 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-364e9fec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:546 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], action, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-03f82f28 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:547 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_division_id"] | CString.AppendStringEx(nvc["p_division_id"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-744bf3bf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:548 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_version_no"] | CString.AppendStringEx(nvc["p_version_no"], _sVersionNo, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-ef964a94 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:549 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], sYYYYMMDD, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-749fe10d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:550 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_CURRENCY"] | CString.AppendStringEx(nvc["p_CURRENCY"], sCURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-e318dad0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:551 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_UNIT_CURRENCY"] | CString.AppendStringEx(nvc["p_UNIT_CURRENCY"], sUNIT_CURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-67d8c52f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:552 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_EXCHANGE_PRICE"] | CString.AppendStringEx(nvc["p_EXCHANGE_PRICE"], sEXCHANGE_PRICE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-3ba47fee | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:553 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-e9ec617f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:554 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-933dd36f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:569 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(sPric… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[EXCHANGE_PRICE]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c00e202c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:570 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (string.IsNullOrEmpty(sPric… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3930485 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:575 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-590501d1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:579 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT") ⇒ DM.DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT | 엔드포인트 요청 생성 |  |  |  |
| AC-1dd19f42 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:583 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Count) | DATA_OP | request.Parameters[nvc.GetKey(i)] | nvc[i] | 행/컬럼 값 대입 |  |  |  |
| AC-26527882 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:583 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda ▸ for (i < nvc.Count) | CALL_EXT | nvc.GetKey | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6507c196 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:585 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-71e39461 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:587 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6ab5cbb9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:601 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | MESSAGE | MessageBox.Show | (sErrMsg, "Error!") | 메시지 표시 |  |  |  |
| AC-64e3132c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:602 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b10ac96 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0044_SalesReportExchangePopup.cs:607 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD_R }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0044_SalesReportExchangePopup.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3d43ea6 | this.spdMain.TopChange | DMF0044_SalesReportExchangePopup.cs:717 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_SalesReportExchangePopup.YearSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cceea6dc | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:107 |  | DATA_OP | dt.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7ca3158 | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:108 |  | DATA_OP | dt.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f090bf1 | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:115 | for (i <= iToYear) | DATA_OP | dt.Rows.Add | (i, i) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ec53cde | (진입점 미연결) | DMF0044_SalesReportExchangePopup.cs:117 |  | LIST_REBIND | clsCtrl.setListBox | (dt, usrYear, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## DMF0044_United_VersionPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-875d8c0e | this.btnClose.Click | DMF0044_United_VersionPopup.cs:493 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0044_United_VersionPopup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a96ccd75 | this.btnOK.Click | DMF0044_United_VersionPopup.cs:486 | if (iSelectedRow != -1) | FLAG | sVersions | siMain.GetValue(iSelectedRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-109da674 | this.btnOK.Click | DMF0044_United_VersionPopup.cs:487 | if (iSelectedRow != -1) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0044_United_VersionPopup.btnTranCancel_Click

진입점: this.btnTranCancel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b4efed5 | this.btnTranCancel.Click | DMF0044_United_VersionPopup.cs:406 | if (iSelectedRow != -1) ▸ if (strSendYN == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00195") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-733799a8 | this.btnTranCancel.Click | DMF0044_United_VersionPopup.cs:407 | if (iSelectedRow != -1) ▸ if (strSendYN == "Y") ▸ if (MessageHelper.GMessageBox("MSG00195") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16bf3394 | this.btnTranCancel.Click | DMF0044_United_VersionPopup.cs:413 | if (iSelectedRow != -1) ▸ else of (strSendYN == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00319") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7fda50fa | this.btnTranCancel.Click | DMF0044_United_VersionPopup.cs:414 | if (iSelectedRow != -1) ▸ else of (strSendYN == "Y") ▸ if (MessageHelper.GMessageBox("MSG00319") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0044_United_VersionPopup.btnTransfer_Click

진입점: this.btnTransfer.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7045625c | this.btnTransfer.Click | DMF0044_United_VersionPopup.cs:390 | if (iSelectedRow != -1) ▸ else of (strSendYN == "N") | MESSAGE | MessageHelper.GMessageBox | ("MSG00318") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df3c37dd | this.btnTransfer.Click | DMF0044_United_VersionPopup.cs:391 | if (iSelectedRow != -1) ▸ else of (strSendYN == "N") ▸ if (MessageHelper.GMessageBox("MSG00318") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0044_United_VersionPopup.btnVerCopy_Click

진입점: this.btnVerCopy.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d357a573 | this.btnVerCopy.Click | DMF0044_United_VersionPopup.cs:458 | if (iSelectedRow != -1) ▸ if (chkResult.Checked == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00314") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2f42a589 | this.btnVerCopy.Click | DMF0044_United_VersionPopup.cs:459 | if (iSelectedRow != -1) ▸ if (chkResult.Checked == false) ▸ if (MessageHelper.GMessageBox("MSG00314") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0044_United_VersionPopup.btnVerDel_Click

진입점: this.btnVerDel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56f8d608 | this.btnVerDel.Click | DMF0044_United_VersionPopup.cs:430 | if (iSelectedRow != -1) ▸ if (strSendYN == "N" \|\| strSendYN == "C") | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-24d84ba5 | this.btnVerDel.Click | DMF0044_United_VersionPopup.cs:431 | if (iSelectedRow != -1) ▸ if (strSendYN == "N" \|\| strSendYN == "C") ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b027371e | this.btnVerDel.Click | DMF0044_United_VersionPopup.cs:437 | if (iSelectedRow != -1) ▸ else of (strSendYN == "N" \|\| strSendYN == "C") | MESSAGE | MessageHelper.GMessageBox | ("MSG00320") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da6fe4d8 | this.btnVerDel.Click | DMF0044_United_VersionPopup.cs:438 | if (iSelectedRow != -1) ▸ else of (strSendYN == "N" \|\| strSendYN == "C") ▸ if (MessageHelper.GMessageBox("MSG00320") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0044_United_VersionPopup.chkMV_CheckedChanged

진입점: this.chkMV.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f31db9fb | this.chkMV.CheckedChanged | DMF0044_United_VersionPopup.cs:717 | if (chkMV.Checked == true) | STATE | MvMonth.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-60a6d6a4 | this.chkMV.CheckedChanged | DMF0044_United_VersionPopup.cs:718 | if (chkMV.Checked == true) | UI_PROP | MvMonth.MonthText | DateTime.Now.AddMonths(-1).ToString("yyyyMM") | 속성 MonthText 설정 |  |  |  |
| AC-997a640f | this.chkMV.CheckedChanged | DMF0044_United_VersionPopup.cs:722 | else of (chkMV.Checked == true) | STATE | MvMonth.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5b4f994d | this.chkMV.CheckedChanged | DMF0044_United_VersionPopup.cs:723 | else of (chkMV.Checked == true) | UI_PROP | MvMonth.MonthText | "" | 속성 MonthText 설정 |  |  |  |

## DMF0044_United_VersionPopup.chkResult_CheckedChanged

진입점: this.chkResult.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0de67a5 | this.chkResult.CheckedChanged | DMF0044_United_VersionPopup.cs:306 | if (chkResult.Checked == true) | STATE | BasicDate.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-24327ead | this.chkResult.CheckedChanged | DMF0044_United_VersionPopup.cs:307 | if (chkResult.Checked == true) | VALUE_SET | BasicDate.Value | System.DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-79b82c3e | this.chkResult.CheckedChanged | DMF0044_United_VersionPopup.cs:309 | if (chkResult.Checked == true) | VALUE_SET | chkUpdate.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-ff80ad71 | this.chkResult.CheckedChanged | DMF0044_United_VersionPopup.cs:310 | if (chkResult.Checked == true) | STATE | chkUpdate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2c817f4d | this.chkResult.CheckedChanged | DMF0044_United_VersionPopup.cs:315 | else of (chkResult.Checked == true) | STATE | BasicDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ea87f6d1 | this.chkResult.CheckedChanged | DMF0044_United_VersionPopup.cs:316 | else of (chkResult.Checked == true) | VALUE_CLEAR | BasicDate.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-cd5967c5 | this.chkResult.CheckedChanged | DMF0044_United_VersionPopup.cs:318 | else of (chkResult.Checked == true) | VALUE_SET | chkUpdate.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-a5186700 | this.chkResult.CheckedChanged | DMF0044_United_VersionPopup.cs:319 | else of (chkResult.Checked == true) | STATE | chkUpdate.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## DMF0044_United_VersionPopup.clbType_SelectedIndexChanged

진입점: this.clbType.SelectedIndexChanged / clbType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31370f4a | this.clbType.SelectedIndexChanged 외 1 | DMF0044_United_VersionPopup.cs:499 |  | VALUE_SET | chkResult.Checked | false | 컨트롤 값 설정 |  |  |  |

## DMF0044_United_VersionPopup.ControlDisplay

진입점: this.clbType.SelectedIndexChanged / this.Load / clbType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f61d63ff | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:507 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_Transfer.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ef9737ea | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:508 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_Cancel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-90dff04a | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:509 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_VersionCopy.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a5c967c7 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:510 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_VersionDelete.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-16100f5f | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:511 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_OK.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-12157ee5 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:512 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_Result.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ccf6af16 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:513 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_BasicDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2bd8a3b1 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:515 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_VersionCreate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6fac1cba | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:517 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_Update.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bb7f1a64 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:522 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) ▸ if ((clbType.ControlV… | UI_PROP | LayoutControl_MV.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-906e1cae | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:523 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) ▸ if ((clbType.ControlV… | UI_PROP | LayoutControl_MVDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7501af79 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:527 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) ▸ else of ((clbType.Con… | UI_PROP | LayoutControl_MV.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4c3a11f5 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:528 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) ▸ else of ((clbType.Con… | UI_PROP | LayoutControl_MVDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ec7ff259 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:531 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | STATE | txtDesc.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-88395127 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:532 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-27810c8f | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:534 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | STATE | BasicDate.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4a073db9 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:535 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | VALUE_CLEAR | BasicDate.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a52a3f06 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:537 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | STATE | MvMonth.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-09958faf | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:538 | if ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | VALUE_CLEAR | MvMonth.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2b561bfc | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:543 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_Transfer.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-297bd2b1 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:544 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_Cancel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-2cd19c87 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:545 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_VersionCopy.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-df53e2c8 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:546 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_VersionDelete.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e7255e02 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:547 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_Result.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-85a8d98d | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:548 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_OK.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8cb63584 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:549 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_BasicDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9a46a78b | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:551 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_VersionCreate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-151beccd | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:552 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_MV.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b17a2f04 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:553 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_MVDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-96fe23e2 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:555 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | UI_PROP | LayoutControl_Update.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f409f41a | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:559 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) ▸ if (clbType.Cont… | UI_PROP | LayoutControl_MV.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0ab39b53 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:560 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) ▸ if (clbType.Cont… | UI_PROP | LayoutControl_MVDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-612bd989 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:564 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) ▸ else of (clbType… | UI_PROP | LayoutControl_MV.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-83ddbfef | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:565 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) ▸ else of (clbType… | UI_PROP | LayoutControl_MVDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-733c8898 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:569 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | STATE | txtDesc.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c2c58c23 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:570 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a5da2ad9 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:572 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | STATE | BasicDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c65888aa | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:573 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | VALUE_CLEAR | BasicDate.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e0345a8d | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:575 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | STATE | MvMonth.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-af324436 | this.clbType.SelectedIndexChanged 외 2 | DMF0044_United_VersionPopup.cs:576 | else of ((clbType.ControlValues == "SP_W") \|\| (clbType.ControlValues == "BP_M") \|\| (clbType.ControlValues == "SP_M")) | VALUE_CLEAR | MvMonth.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0044_United_VersionPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11822ba0 | this.Load | DMF0044_United_VersionPopup.cs:157 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-43a983ff | this.Load | DMF0044_United_VersionPopup.cs:158 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-295b326c | this.Load | DMF0044_United_VersionPopup.cs:164 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0044_United_VersionPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aee68d24 | Dispose | DMF0044_United_VersionPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0044_United_VersionPopup.DMF0044_MOBILE_REPORT_CREATE

진입점: this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strSendYN == "Y")] / this.btnTransfer.Click [if (iSelectedRow != -1) ▸ if (strSendYN == "N")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e4b249d | this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strS… 외 1 | DMF0044_United_VersionPopup.cs:589 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { st… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-66e1833e | this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strS… 외 1 | DMF0044_United_VersionPopup.cs:595 | try ▸ lambda | ENDPOINT | new FoxDataRequest | (strQuery) ⇒ DM.DMF0044_MOBILE_REPORT_CREATE | 엔드포인트 요청 생성 |  |  |  |
| AC-88a373e6 | this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strS… 외 1 | DMF0044_United_VersionPopup.cs:596 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-da23eea3 | this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strS… 외 1 | DMF0044_United_VersionPopup.cs:597 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-009f5f79 | this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strS… 외 1 | DMF0044_United_VersionPopup.cs:598 | try ▸ lambda | DATA_OP | request.Parameters["p_version_no"] | siMain.GetValue(iSelectedRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b434b95d | this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strS… 외 1 | DMF0044_United_VersionPopup.cs:599 | try ▸ lambda | DATA_OP | request.Parameters["p_version_type"] | clbType.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-eb0697c0 | this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strS… 외 1 | DMF0044_United_VersionPopup.cs:600 | try ▸ lambda | DATA_OP | request.Parameters["p_action_type"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-a5d9f0ec | this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strS… 외 1 | DMF0044_United_VersionPopup.cs:601 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b793a5a2 | this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strS… 외 1 | DMF0044_United_VersionPopup.cs:603 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e21b8709 | this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strS… 외 1 | DMF0044_United_VersionPopup.cs:604 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-671da9bc | this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strS… 외 1 | DMF0044_United_VersionPopup.cs:610 | try ▸ if ((dsMain.Tables.Count != 0) && (dsMain.Tables[0].Rows[0][0].ToString() == "success")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { 1 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ac74ed54 | this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strS… 외 1 | DMF0044_United_VersionPopup.cs:615 | try ▸ else of ((dsMain.Tables.Count != 0) && (dsMain.Tables[0].Rows[0][0].ToString() == "success")) | MESSAGE | MessageHelper.GMessageBox | (dsMain.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3a61129d | this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strS… 외 1 | DMF0044_United_VersionPopup.cs:621 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0044_United_VersionPopup.DMF0044_SAVE_SALES_PLAN_VERSION_COPY

진입점: this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResult.Checked == false)] / this.btnVerDel.Click [if (iSelectedRow != -1) ▸ if (strSendYN == "N" \|\| strSendYN == "C")] / this.btnVerCre.Click [if (iSelectedRow != -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37b8062c | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:638 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { st… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-83204350 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:644 | try ▸ lambda | CALL_EXT | BasicDate.Value.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-aac8197f | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:647 | try ▸ lambda | ENDPOINT | new FoxDataRequest | (strQuery) ⇒ DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY | 엔드포인트 요청 생성 |  |  |  |
| AC-b35377de | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:648 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-17cb4d52 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:649 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-97334ea2 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:650 | try ▸ lambda | DATA_OP | request.Parameters["p_version_no"] | siMain.GetValue(iSelectedRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-11906e8b | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:651 | try ▸ lambda | DATA_OP | request.Parameters["p_version_description"] | txtDesc.Text | 행/컬럼 값 대입 |  |  |  |
| AC-4ebfea04 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:652 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4ffc192e | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:653 | try ▸ lambda | DATA_OP | request.Parameters["p_result_date"] | strBasicDate | 행/컬럼 값 대입 |  |  |  |
| AC-6a451f7c | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:654 | try ▸ lambda | DATA_OP | request.Parameters["p_action_type"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-61abf220 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:655 | try ▸ lambda | DATA_OP | request.Parameters["p_mv_plan_yyyymm"] | str_mv_plan_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-d3f03160 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:656 | try ▸ lambda | DATA_OP | request.Parameters["p_update_yn"] | str_update_yn | 행/컬럼 값 대입 |  |  |  |
| AC-1f3b3f83 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:658 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d2ba4a9b | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:659 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-dffa9570 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:666 | try ▸ if ((dsMain.Tables.Count != 0) && (dsMain.Tables[0].Rows[0][0].ToString() == "success")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { 1 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3c82f6f3 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:671 | try ▸ else of ((dsMain.Tables.Count != 0) && (dsMain.Tables[0].Rows[0][0].ToString() == "success")) | MESSAGE | MessageHelper.GMessageBox | (dsMain.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-359d77e0 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 2 | DMF0044_United_VersionPopup.cs:676 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0044_United_VersionPopup.FindData

진입점: this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResult.Checked == false) ▸ try ▸ if ((dsMain.Tables.Count != 0) && (dsMain.Tables[0].Rows[0][0].ToString() == "success"))] / this.btnVerDel.Click [if (iSelectedRow != -1) ▸ if (strSendYN == "N" \|\| strSendYN == "C") ▸ try ▸ if ((dsMain.Tables.Count != 0) && (dsMain.Tables[0].Rows[0][0].ToString() == "success"))] / this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strSendYN == "Y") ▸ try ▸ if ((dsMain.Tables.Count != 0) && (dsMain.Tables[0].Rows[0][0].ToString() == "success"))] / this.btnTransfer.Click [if (iSelectedRow != -1) ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71c66c0f | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:222 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-306e87d6 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:233 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0044_GET_SALES_VERSION_POPUP") ⇒ DM.DMF0044_GET_SALES_VERSION_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-c45413f2 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:234 | try | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-98ca614f | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:235 | try | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e59c0e6d | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:236 | try | DATA_OP | request.Parameters["p_sdt"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-7232a054 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:237 | try | DATA_OP | request.Parameters["p_edt"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-9b0928e0 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:238 | try | DATA_OP | request.Parameters["p_version_type"] | clbType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-023d6c00 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:239 | try | DATA_OP | request.Parameters["p_Description"] | txtDesc.Text | 행/컬럼 값 대입 |  |  |  |
| AC-fd483b94 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:240 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a843eb8 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:245 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a7b43f60 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:246 | try | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-388f8c07 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:248 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff333af2 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:252 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7f1e78f | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 8 | DMF0044_United_VersionPopup.cs:257 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0044_United_VersionPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c47c232a | this.Load | DMF0044_United_VersionPopup.cs:94 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f7562d8 | this.Load | DMF0044_United_VersionPopup.cs:96 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4a9adf6b | this.Load | DMF0044_United_VersionPopup.cs:105 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-53402069 | this.Load | DMF0044_United_VersionPopup.cs:106 |  | UI_PROP | this.IsPopupEditCheck | false | 속성 IsPopupEditCheck 설정 |  |  |  |
| AC-5a1a25b8 | this.Load | DMF0044_United_VersionPopup.cs:111 |  | FLAG | _sType | strType | 화면 필드/플래그 변경 |  |  |  |
| AC-67f8dac5 | this.Load | DMF0044_United_VersionPopup.cs:112 |  | FLAG | _sDiv | strDiv | 화면 필드/플래그 변경 |  |  |  |

## DMF0044_United_VersionPopup.GetLookupData

진입점: this.Load [if (_sType == "REPORT_SP_W")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1205b40d | this.Load [if (_sType == "REPORT_SP_W")] | DMF0044_United_VersionPopup.cs:364 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-a3905ef6 | this.Load [if (_sType == "REPORT_SP_W")] | DMF0044_United_VersionPopup.cs:365 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-8d14072d | this.Load [if (_sType == "REPORT_SP_W")] | DMF0044_United_VersionPopup.cs:366 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bd010696 | this.Load [if (_sType == "REPORT_SP_W")] | DMF0044_United_VersionPopup.cs:368 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0044_United_VersionPopup.GetLookupValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb36d6f7 | (진입점 미연결) | DMF0044_United_VersionPopup.cs:294 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-14a4f3bb | (진입점 미연결) | DMF0044_United_VersionPopup.cs:295 |  | DATA_OP | request.Parameters["p_lookup_type"] | sLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-1c693ca8 | (진입점 미연결) | DMF0044_United_VersionPopup.cs:296 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-66997cf9 | (진입점 미연결) | DMF0044_United_VersionPopup.cs:299 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0044_United_VersionPopup.GetSpdTitle

진입점: this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResult.Checked == false) ▸ try ▸ if ((dsMain.Tables.Count != 0) && (dsMain.Tables[0].Rows[0][0].ToString() == "success"))] / this.btnVerDel.Click [if (iSelectedRow != -1) ▸ if (strSendYN == "N" \|\| strSendYN == "C") ▸ try ▸ if ((dsMain.Tables.Count != 0) && (dsMain.Tables[0].Rows[0][0].ToString() == "success"))] / this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strSendYN == "Y") ▸ try ▸ if ((dsMain.Tables.Count != 0) && (dsMain.Tables[0].Rows[0][0].ToString() == "success"))] / this.btnTransfer.Click [if (iSelectedRow != -1) ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17c476f9 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 10 | DMF0044_United_VersionPopup.cs:274 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-b9a11dc8 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 10 | DMF0044_United_VersionPopup.cs:275 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1ced317b | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 10 | DMF0044_United_VersionPopup.cs:276 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-096a0c58 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 10 | DMF0044_United_VersionPopup.cs:277 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fbaa4d71 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 10 | DMF0044_United_VersionPopup.cs:278 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0044" | 행/컬럼 값 대입 |  |  |  |
| AC-bc227835 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 10 | DMF0044_United_VersionPopup.cs:279 |  | DATA_OP | request.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-6ecdf583 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 10 | DMF0044_United_VersionPopup.cs:280 |  | DATA_OP | request.Parameters["p_division_id"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-259ea3f5 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 10 | DMF0044_United_VersionPopup.cs:282 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-cb5fdaea | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 10 | DMF0044_United_VersionPopup.cs:282 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-80056d5b | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 10 | DMF0044_United_VersionPopup.cs:285 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0044_United_VersionPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4278dcf9 | this.Load | DMF0044_United_VersionPopup.cs:117 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-3835bc99 | this.Load | DMF0044_United_VersionPopup.cs:117 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8c301f86 | this.Load | DMF0044_United_VersionPopup.cs:118 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e703dd49 | this.Load | DMF0044_United_VersionPopup.cs:119 |  | VALUE_SET | clbDivision.SelectedValue | _sDiv | 컨트롤 값 설정 |  |  |  |
| AC-0e6d9190 | this.Load | DMF0044_United_VersionPopup.cs:120 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b3e7c9dd | this.Load | DMF0044_United_VersionPopup.cs:124 |  | VALUE_SET | drpPeriod.InitValue | sStartDate + ":" + sEndDate | 컨트롤 값 설정 |  |  |  |
| AC-9d648ed5 | this.Load | DMF0044_United_VersionPopup.cs:126 |  | STATE | BasicDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-115fe5dd | this.Load | DMF0044_United_VersionPopup.cs:127 |  | VALUE_SET | chkUpdate.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-56b4a657 | this.Load | DMF0044_United_VersionPopup.cs:132 | if (_sType == "REPORT_SP_W") | LIST_REBIND | clsCtrl.setListBox | (GetLookupData("MDF_TYPE_SP_POPUP"), clbType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1ff68743 | this.Load | DMF0044_United_VersionPopup.cs:136 | else of (_sType == "REPORT_SP_W") | LIST_REBIND | clsCtrl.setListBox | (GetLookupData("MDF_TYPE_BP_POPUP"), clbType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## DMF0044_United_VersionPopup.InitSpread

진입점: this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResult.Checked == false) ▸ try ▸ if ((dsMain.Tables.Count != 0) && (dsMain.Tables[0].Rows[0][0].ToString() == "success"))] / this.btnVerDel.Click [if (iSelectedRow != -1) ▸ if (strSendYN == "N" \|\| strSendYN == "C") ▸ try ▸ if ((dsMain.Tables.Count != 0) && (dsMain.Tables[0].Rows[0][0].ToString() == "success"))] / this.btnTranCancel.Click [if (iSelectedRow != -1) ▸ if (strSendYN == "Y") ▸ try ▸ if ((dsMain.Tables.Count != 0) && (dsMain.Tables[0].Rows[0][0].ToString() == "success"))] / this.btnTransfer.Click [if (iSelectedRow != -1) ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e99606bd | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 10 | DMF0044_United_VersionPopup.cs:171 |  | FLAG | giRowIndex | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-4f2685bb | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 10 | DMF0044_United_VersionPopup.cs:175 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-c26c12f5 | this.btnVerCopy.Click [if (iSelectedRow != -1) ▸ if (chkResu… 외 10 | DMF0044_United_VersionPopup.cs:178 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0044_United_VersionPopup.SingleCheck

진입점: this.btnVerCopy.Click / this.btnVerDel.Click / this.btnTranCancel.Click / this.btnTransfer.Click / this.btnVerCre.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d6e46a1 | this.btnVerCopy.Click 외 5 | DMF0044_United_VersionPopup.cs:346 |  | RETURN | return giRowIndex; |  | 처리 중단/반환 |  |  |  |

## DMF0044_United_VersionPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9caffbf7 | this.spdMain.CellClick | DMF0044_United_VersionPopup.cs:702 | if (e.ColumnHeader == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i == e.Row) | GRID_STYLE | siMain.SetBGColor | (e.Row, 1, e.Row, siMain.GetMaxColumnIndex(), System.Drawing.Color.FromArgb(215, 227, 188)… | 그리드 표시 설정 |  |  |  |
| AC-23d843a1 | this.spdMain.CellClick | DMF0044_United_VersionPopup.cs:703 | if (e.ColumnHeader == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i == e.Row) | FLAG | giRowIndex | i | 화면 필드/플래그 변경 |  |  |  |
| AC-51afe1f0 | this.spdMain.CellClick | DMF0044_United_VersionPopup.cs:707 | if (e.ColumnHeader == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (i == e.Row) | GRID_STYLE | siMain.SetBGColor | (i, 1, i, siMain.GetMaxColumnIndex(), System.Drawing.Color.FromArgb(255, 255, 255)) | 그리드 표시 설정 |  |  |  |

## DMF0044_United_VersionPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08139023 | this.spdMain.CellDoubleClick | DMF0044_United_VersionPopup.cs:353 | if ((clbType.ControlValues == "REPORT_BP_M") \|\| (clbType.ControlValues == "REPORT_SP_W")) | FLAG | sVersions | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.VERSION_NO)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f0fcbdf8 | this.spdMain.CellDoubleClick | DMF0044_United_VersionPopup.cs:354 | if ((clbType.ControlValues == "REPORT_BP_M") \|\| (clbType.ControlValues == "REPORT_SP_W")) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |


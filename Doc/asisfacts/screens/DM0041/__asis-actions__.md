# AS-IS 액션 대조표 — DM0041

> 원천: `Doc/asisfacts/screens/DM0041/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 48행 · 메서드 11 · 종류 FLAG 12 · DATA_OP 11 · UI_MISC 5 · ENDPOINT 5 · RETURN 4 · GRID_INIT 3 · UI_PROP 2 · VALUE_SET 2 · GRID_BIND 1 · GRID_LOCK 1 · COMBO_DATA 1 · LIST_REBIND 1 · ⚠ 의미 확인 필요 0


## DM0041_MDFVersionPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3ff9907 | this.btnButtonList.UsrButtonList_Click_Detected | DM0041_MDFVersionPopup.cs:241 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-7eaffb80 | this.btnButtonList.UsrButtonList_Click_Detected | DM0041_MDFVersionPopup.cs:244 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0041_MDFVersionPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a9a6bba | this.Load | DM0041_MDFVersionPopup.cs:127 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b789ea6e | this.Load | DM0041_MDFVersionPopup.cs:128 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5056f4a3 | this.Load | DM0041_MDFVersionPopup.cs:129 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0041_MDFVersionPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1728061f | this.Load | DM0041_MDFVersionPopup.cs:119 |  | UI_PROP | usrConditionPanel1.Height | 70 | 속성 Height 설정 |  |  |  |
| AC-ac4a55fe | this.Load | DM0041_MDFVersionPopup.cs:122 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DM0041_MDFVersionPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fdfd313 | Dispose | DM0041_MDFVersionPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0041_MDFVersionPopup.FindData

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-350b2917 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:193 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e2f3474a | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:197 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0041_GET_MDF_VERSIONPOPUP") ⇒ DM.DMF0041_GET_MDF_VERSIONPOPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-7dd3708c | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:198 | lambda | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-0908b594 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:199 | lambda | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-071da6e5 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:200 | lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-3e547fa6 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:201 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-96b8d8ca | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:202 | lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-2f053475 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:203 | lambda | DATA_OP | request.Parameters["p_version_no"] | p_version_no | 행/컬럼 값 대입 |  |  |  |
| AC-cc9631e2 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:204 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-04100c0c | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:206 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-27f93a7c | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:210 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-179ecf15 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:211 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dfd53e3d | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:218 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## DM0041_MDFVersionPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ece6f5db | this.Load | DM0041_MDFVersionPopup.cs:91 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ce8d3db4 | this.Load | DM0041_MDFVersionPopup.cs:92 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9d36a81d | this.Load | DM0041_MDFVersionPopup.cs:100 |  | FLAG | sCode | _Code | 화면 필드/플래그 변경 |  |  |  |
| AC-39ca8102 | this.Load | DM0041_MDFVersionPopup.cs:101 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-eca8ef01 | this.Load | DM0041_MDFVersionPopup.cs:102 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-3584dd93 | this.Load | DM0041_MDFVersionPopup.cs:103 |  | VALUE_SET | drpPeriod.InitValue | sStartDate + ":" + sEndDate | 컨트롤 값 설정 |  |  |  |

## DM0041_MDFVersionPopup.GetSpdTitle

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81801e41 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:267 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DM0000_GET_COMMON_SPREAD_TITLE") ⇒ DM_H.DM0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-b3b2864f | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:268 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5c275b77 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:269 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-add325f1 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:270 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0f085893 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:271 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0041" | 행/컬럼 값 대입 |  |  |  |
| AC-862e7e50 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:272 |  | DATA_OP | request.Parameters["p_sheet_name"] | "MDFVerpopup" | 행/컬럼 값 대입 |  |  |  |
| AC-0c16b2a0 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:274 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-0f40890a | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:274 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a45da63 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:277 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0041_MDFVersionPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf19004a | this.Load | DM0041_MDFVersionPopup.cs:111 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-ba3e486e | this.Load | DM0041_MDFVersionPopup.cs:111 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-53862720 | this.Load | DM0041_MDFVersionPopup.cs:112 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-883f0dad | this.Load | DM0041_MDFVersionPopup.cs:114 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |

## DM0041_MDFVersionPopup.InitSpread

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15b07ab3 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DM0041_MDFVersionPopup.cs:137 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0041_MDFVersionPopup.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5aa3c12a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0041_MDFVersionPopup.cs:282 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c352c4a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0041_MDFVersionPopup.cs:284 |  | FLAG | sPeriod | drpPeriod.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-706b5b28 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0041_MDFVersionPopup.cs:297 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | sVersions | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-504dbdac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0041_MDFVersionPopup.cs:301 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | sVersions | sVersions + "," + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-d5809a82 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0041_MDFVersionPopup.cs:308 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c43801e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0041_MDFVersionPopup.cs:313 | else of (bMulltiSelect) | FLAG | sVersions | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |

## DM0041_MDFVersionPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc4b492f | this.spdMain.CellDoubleClick | DM0041_MDFVersionPopup.cs:258 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |


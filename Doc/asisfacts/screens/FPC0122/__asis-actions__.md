# AS-IS 액션 대조표 — FPC0122

> 원천: `Doc/asisfacts/screens/FPC0122/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 59행 · 메서드 13 · 종류 FLAG 18 · GRID_INIT 10 · UI_MISC 8 · RETURN 7 · GRID_STYLE 3 · UI_PROP 2 · ENDPOINT 2 · POPUP 2 · CALL_EXT 2 · DATA_OP 1 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · GRID_SET 1 · ⚠ 의미 확인 필요 2


## FPC0122_InstancePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0725c48 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0122_InstancePopup.cs:362 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-3722ceb6 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0122_InstancePopup.cs:365 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0122_InstancePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4371a294 | this.Load | FPC0122_InstancePopup.cs:182 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f482d061 | this.Load | FPC0122_InstancePopup.cs:183 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-75253d54 | this.Load | FPC0122_InstancePopup.cs:184 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0122_InstancePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4ac64a2 | this.Load | FPC0122_InstancePopup.cs:177 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0122_InstancePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebd3c367 | Dispose | FPC0122_InstancePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0122_InstancePopup.Find_Data_Instance

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / this.Load [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b3e5b29 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:338 | try | DATA_OP | filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-190e2ae6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:339 | try | ENDPOINT | GSCM.FP.Common.UIL.Service.DataService.FP_ExecuteQuery | ("Instance", "list_instance", filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_instance] \| FP\Common\Ins… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e87201e8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:339 | try | RETURN | return GSCM.FP.Common.UIL.Service.DataService.FP_ExecuteQuery("Instance", "list_… |  | 처리 중단/반환 |  |  |  |
| AC-7b65c050 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:343 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FPC0122_InstancePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcee491d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:231 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a7abcc37 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:235 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f8d2f0c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:238 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-57c0a0a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:238 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2967e388 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:244 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5e30f581 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:247 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-deed52fb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:253 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0d25ce38 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:254 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Instance("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-03bc1407 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:265 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-47a9cb7c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:267 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e58555e1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:270 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1658682b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:273 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ec03ec99 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:281 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-1b62324e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:283 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | iClick_Row | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-91cb7aca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:290 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ad787960 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:292 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-dcd2b7e2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0122_InstancePopup.cs:292 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0122_InstancePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e376a0a7 | this.Load | FPC0122_InstancePopup.cs:152 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee849f66 | this.Load | FPC0122_InstancePopup.cs:154 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0122_InstancePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9d4213a | this.Load | FPC0122_InstancePopup.cs:194 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b721fe68 | this.Load | FPC0122_InstancePopup.cs:195 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0122_InstancePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16cd06f5 | (진입점 미연결) | FPC0122_InstancePopup.cs:218 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0122_InstancePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05c7d2e7 | this.Load | FPC0122_InstancePopup.cs:202 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b26e3e2 | this.Load | FPC0122_InstancePopup.cs:203 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-64d0f767 | this.Load | FPC0122_InstancePopup.cs:207 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-48cc56bf | this.Load | FPC0122_InstancePopup.cs:210 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.SHOP_GROUP_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-607838a7 | this.Load | FPC0122_InstancePopup.cs:211 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.ROLE_NAME), false) | 그리드 표시 설정 |  |  |  |

## FPC0122_InstancePopup.SetUserInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb143ec6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0122_InstancePopup.cs:408 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da7108d6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0122_InstancePopup.cs:409 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27a28fa5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0122_InstancePopup.cs:411 |  | FLAG | _InstanceId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4cc7a9c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0122_InstancePopup.cs:412 |  | FLAG | _CompanyId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3df09673 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0122_InstancePopup.cs:413 |  | FLAG | _DivisionId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-eda92f96 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0122_InstancePopup.cs:414 |  | FLAG | _SiteId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-79b360f9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0122_InstancePopup.cs:415 |  | FLAG | _PlantId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-89be460b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0122_InstancePopup.cs:416 |  | FLAG | _FactoryId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d504cac4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0122_InstancePopup.cs:417 |  | FLAG | _PlanGroupId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLAN_GROUP_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f046371a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0122_InstancePopup.cs:418 |  | FLAG | _ShopGroupId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.SHOP_GROUP_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f6efd475 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0122_InstancePopup.cs:421 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0122_InstancePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6b8550c | this.spdMain.CellClick | FPC0122_InstancePopup.cs:375 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ddd2c78d | this.spdMain.CellClick | FPC0122_InstancePopup.cs:377 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0122_InstancePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d85a3e5e | this.spdMain.CellDoubleClick | FPC0122_InstancePopup.cs:381 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-1cebf2f5 | this.spdMain.CellDoubleClick | FPC0122_InstancePopup.cs:383 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c882e1b1 | this.spdMain.CellDoubleClick | FPC0122_InstancePopup.cs:385 |  | FLAG | _InstanceId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4eac177a | this.spdMain.CellDoubleClick | FPC0122_InstancePopup.cs:386 |  | FLAG | _CompanyId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7b803903 | this.spdMain.CellDoubleClick | FPC0122_InstancePopup.cs:387 |  | FLAG | _DivisionId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4ac71b7a | this.spdMain.CellDoubleClick | FPC0122_InstancePopup.cs:388 |  | FLAG | _SiteId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4fba2ccd | this.spdMain.CellDoubleClick | FPC0122_InstancePopup.cs:389 |  | FLAG | _PlantId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5718a0bb | this.spdMain.CellDoubleClick | FPC0122_InstancePopup.cs:397 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |


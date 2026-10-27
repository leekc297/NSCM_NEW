# AS-IS 액션 대조표 — DM0098

> 원천: `Doc/asisfacts/screens/DM0098/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 216행 · 메서드 24 · 종류 GRID_INIT 56 · DATA_OP 42 · ENDPOINT 20 · UI_PROP 16 · FLAG 14 · RETURN 14 · CALL_EXT 12 · GRID_LOCK 10 · UI_MISC 8 · MESSAGE 6 · GRID_BIND 4 · LIST_REBIND 4 · GRID_SET 4 · STATE_RESET 4 · COMBO_DATA 2 · ⚠ 의미 확인 필요 12


## DM0098_ScmMstCustomerTest.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e77661e | this.Load | DM0098_ScmMstCustomerTest.cs:151 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3067d2a8 | this.Load | DM0098_ScmMstCustomerTest.cs:152 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-47aa41e5 | this.Load | DM0098_ScmMstCustomerTest.cs:154 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-693cbca3 | this.Load | DM0098_ScmMstCustomerTest.cs:155 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d312ab94 | this.Load | DM0098_ScmMstCustomerTest.cs:157 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0098_ScmMstCustomerTest.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-503c7aee | DeleteButton | DM0098_ScmMstCustomerTest.cs:219 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0098_ScmMstCustomerTest.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7925e0f5 | Dispose | DM0098_ScmMstCustomerTest.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0098_ScmMstCustomerTest.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1860576d | EditButton | DM0098_ScmMstCustomerTest.cs:228 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0718d01a | EditButton | DM0098_ScmMstCustomerTest.cs:229 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-2568dcfc | EditButton | DM0098_ScmMstCustomerTest.cs:231 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DivisionId), siMain.GetColumnIndex(DefColumns.ShiptoCode… | 그리드 편집 잠금/해제 |  |  |  |
| AC-66b6db76 | EditButton | DM0098_ScmMstCustomerTest.cs:236 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-59530d20 | EditButton | DM0098_ScmMstCustomerTest.cs:237 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f384c118 | EditButton | DM0098_ScmMstCustomerTest.cs:239 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.DivisionId2), siSub.GetColumnIndex(DefColumns.ShiptoCode2… | 그리드 편집 잠금/해제 |  |  |  |

## DM0098_ScmMstCustomerTest.FindData_Main

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a1865c9 | FindButton 외 1 | DM0098_ScmMstCustomerTest.cs:257 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ca08d28b | FindButton 외 1 | DM0098_ScmMstCustomerTest.cs:266 | if (sDivId == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-078c3437 | FindButton 외 1 | DM0098_ScmMstCustomerTest.cs:268 | if (sDivId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ca8bd11 | FindButton 외 1 | DM0098_ScmMstCustomerTest.cs:276 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-312a6449 | FindButton 외 1 | DM0098_ScmMstCustomerTest.cs:280 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0098_GET_SCM_MST_CUSTOMER_TEST") ⇒ DM.DM0098_GET_SCM_MST_CUSTOMER_TEST | 엔드포인트 요청 생성 |  |  |  |
| AC-03373e13 | FindButton 외 1 | DM0098_ScmMstCustomerTest.cs:281 | lambda | DATA_OP | request.Parameters["P_DIVISION_ID"] | sDivId | 행/컬럼 값 대입 |  |  |  |
| AC-2c767021 | FindButton 외 1 | DM0098_ScmMstCustomerTest.cs:282 | lambda | DATA_OP | request.Parameters["P_ACTIVE_FLAG"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-f5ab7f59 | FindButton 외 1 | DM0098_ScmMstCustomerTest.cs:287 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e0b3ce4f | FindButton 외 1 | DM0098_ScmMstCustomerTest.cs:289 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f5b7cd18 | FindButton 외 1 | DM0098_ScmMstCustomerTest.cs:296 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-25004358 | FindButton 외 1 | DM0098_ScmMstCustomerTest.cs:297 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c0695620 | FindButton 외 1 | DM0098_ScmMstCustomerTest.cs:313 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e459ff3f | FindButton 외 1 | DM0098_ScmMstCustomerTest.cs:320 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0098_ScmMstCustomerTest.FindData_Sub

진입점: this.spdMain.CellClick / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8e21337 | this.spdMain.CellClick 외 1 | DM0098_ScmMstCustomerTest.cs:334 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { ch… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-13dc9969 | this.spdMain.CellClick 외 1 | DM0098_ScmMstCustomerTest.cs:341 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0098_GET_SCM_MST_SITE_CUSTOMER_TEST") ⇒ DM.DM0098_GET_SCM_MST_SITE_CUSTOMER_TEST | 엔드포인트 요청 생성 |  |  |  |
| AC-2e74126a | this.spdMain.CellClick 외 1 | DM0098_ScmMstCustomerTest.cs:342 | lambda | DATA_OP | request.Parameters["P_DIVISION_ID"] | mainID[0] | 행/컬럼 값 대입 |  |  |  |
| AC-be89fdfc | this.spdMain.CellClick 외 1 | DM0098_ScmMstCustomerTest.cs:343 | lambda | DATA_OP | request.Parameters["SHIPTO_CODE"] | "BG000012" | 행/컬럼 값 대입 |  |  |  |
| AC-dceae63c | this.spdMain.CellClick 외 1 | DM0098_ScmMstCustomerTest.cs:345 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-51f7db46 | this.spdMain.CellClick 외 1 | DM0098_ScmMstCustomerTest.cs:347 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8f48e641 | this.spdMain.CellClick 외 1 | DM0098_ScmMstCustomerTest.cs:351 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5b9cb02c | this.spdMain.CellClick 외 1 | DM0098_ScmMstCustomerTest.cs:355 |  | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0098_ScmMstCustomerTest.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e0e18fa | this.Load | DM0098_ScmMstCustomerTest.cs:126 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6ebb877f | this.Load | DM0098_ScmMstCustomerTest.cs:127 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0098_ScmMstCustomerTest.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5036dd7 | this.Load | DM0098_ScmMstCustomerTest.cs:139 |  | FLAG | dtDiv | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-50cb6c65 | this.Load | DM0098_ScmMstCustomerTest.cs:139 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-009c5b64 | this.Load | DM0098_ScmMstCustomerTest.cs:140 |  | LIST_REBIND | clsCtrl.setListBox | (dtDiv, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8d4714aa | this.Load | DM0098_ScmMstCustomerTest.cs:142 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cmbActive, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0098_ScmMstCustomerTest.InitSpread

진입점: this.Load / this.spdMain.CellClick / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbe0015f | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:167 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-0d5241f5 | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:169 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8fc6c220 | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:170 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Div", DefColumns.DivisionId, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.Top) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a23ad8c3 | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:171 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Sold To Code", DefColumns.SoldtoCode, FPMerge.Always, 80, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37d6a1df | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:172 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Ship To Code", DefColumns.ShiptoCode, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c7389f0a | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:173 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Sold To Description", DefColumns.SoldtoDescription, FPMerge.None, 180, true, FPHAlign.Le… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aa1b18c4 | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:174 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Sold To Address", DefColumns.SoldtoAddress, FPMerge.None, 180, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d6a7e4b | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:175 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Sold To Country", DefColumns.SoldtoCountry, FPMerge.None, 100, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-84e39325 | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:176 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Region", DefColumns.SoldtoRegion, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8cb12111 | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:177 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Region Name", DefColumns.SoldtoRegionName, FPMerge.None, 120, true, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc360058 | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:178 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Valid YN", DefColumns.ValidYn, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80231f1b | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:180 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.ShiptoCode)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ee3df329 | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:182 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-38ca5381 | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:186 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7fc1ceee | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:188 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7e412b92 | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:189 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Division Id", DefColumns.DivisionId2, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66a91edb | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:190 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Scm Site Id", DefColumns.ScmSiteId2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb122458 | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:191 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Soldto Code", DefColumns.SoldtoCode2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c836b41c | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:192 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Shipto Code", DefColumns.ShiptoCode2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8594585f | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:193 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Rep YN", DefColumns.RepYn2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f10db5a8 | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:194 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Valid YN", DefColumns.ValidYn, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1bf0ecff | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:196 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.ScmSiteId2)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-703be2f0 | this.Load 외 3 | DM0098_ScmMstCustomerTest.cs:198 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0098_ScmMstCustomerTest.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f136b282 | InsertButton | DM0098_ScmMstCustomerTest.cs:533 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-44cb1ca7 | InsertButton | DM0098_ScmMstCustomerTest.cs:536 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.DivisionId, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-2eceadc8 | InsertButton | DM0098_ScmMstCustomerTest.cs:540 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-e54c73ac | InsertButton | DM0098_ScmMstCustomerTest.cs:548 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c6bfc2e4 | InsertButton | DM0098_ScmMstCustomerTest.cs:551 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | defaultData.Add | (DefColumns.DivisionId, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-6021c8ea | InsertButton | DM0098_ScmMstCustomerTest.cs:555 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## DM0098_ScmMstCustomerTest.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-196f75e1 | SaveButton | DM0098_ScmMstCustomerTest.cs:372 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-99ee74ee | SaveButton | DM0098_ScmMstCustomerTest.cs:381 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a481f9cd | SaveButton | DM0098_ScmMstCustomerTest.cs:383 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-a0c01ea1 | SaveButton | DM0098_ScmMstCustomerTest.cs:387 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2ff82fd8 | SaveButton | DM0098_ScmMstCustomerTest.cs:389 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-6693c89d | SaveButton | DM0098_ScmMstCustomerTest.cs:392 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9af5792f | SaveButton | DM0098_ScmMstCustomerTest.cs:417 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d060b0a | SaveButton | DM0098_ScmMstCustomerTest.cs:418 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-eccc28b2 | SaveButton | DM0098_ScmMstCustomerTest.cs:419 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | DATA_OP | saveDS.Tables[0].Rows[i].Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fd74e469 | SaveButton | DM0098_ScmMstCustomerTest.cs:423 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.InsertQueryId | "xxxx.InsertQueryId" | 속성 InsertQueryId 설정 |  |  |  |
| AC-102b5283 | SaveButton | DM0098_ScmMstCustomerTest.cs:424 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DeleteQueryId | "xxxx.DeleteQueryId" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-5cd44e33 | SaveButton | DM0098_ScmMstCustomerTest.cs:425 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.UpdateQueryId | "xxxx.UpdateQueryId" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-c24db76f | SaveButton | DM0098_ScmMstCustomerTest.cs:427 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-149a9d1d | SaveButton | DM0098_ScmMstCustomerTest.cs:427 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5360e2d | SaveButton | DM0098_ScmMstCustomerTest.cs:431 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.xxxx.WSL/FoxDataService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-24de07fa | SaveButton | DM0098_ScmMstCustomerTest.cs:435 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d0bb7707 | SaveButton | DM0098_ScmMstCustomerTest.cs:435 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-cd74c4d9 | SaveButton | DM0098_ScmMstCustomerTest.cs:440 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b6eda659 | SaveButton | DM0098_ScmMstCustomerTest.cs:452 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (saveDSSub != null) | STATE_RESET | saveDSSub.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-243ff04d | SaveButton | DM0098_ScmMstCustomerTest.cs:461 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9cd942c9 | SaveButton | DM0098_ScmMstCustomerTest.cs:463 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-043c35bc | SaveButton | DM0098_ScmMstCustomerTest.cs:467 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e783f82b | SaveButton | DM0098_ScmMstCustomerTest.cs:469 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | saveDSSub.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c1e8a31 | SaveButton | DM0098_ScmMstCustomerTest.cs:472 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | saveDSSub.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-20c84746 | SaveButton | DM0098_ScmMstCustomerTest.cs:488 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e0b4112 | SaveButton | DM0098_ScmMstCustomerTest.cs:497 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < saveDSSub.Tables[0].Rows.C… | CALL_EXT | saveDSSub.Tables[0].Rows[i].SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f874292 | SaveButton | DM0098_ScmMstCustomerTest.cs:498 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < saveDSSub.Tables[0].Rows.C… | CALL_EXT | saveDSSub.Tables[0].Rows[i].SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e6838d5 | SaveButton | DM0098_ScmMstCustomerTest.cs:499 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < saveDSSub.Tables[0].Rows.C… | DATA_OP | saveDSSub.Tables[0].Rows[i].Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9f906dae | SaveButton | DM0098_ScmMstCustomerTest.cs:503 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.InsertQueryId | "xxxx.InsertQueryId" | 속성 InsertQueryId 설정 |  |  |  |
| AC-f559916f | SaveButton | DM0098_ScmMstCustomerTest.cs:504 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.DeleteQueryId | "xxxx.DeleteQueryId" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-6e6dc5f2 | SaveButton | DM0098_ScmMstCustomerTest.cs:505 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.UpdateQueryId | "xxxx.UpdateQueryId" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-8f03b633 | SaveButton | DM0098_ScmMstCustomerTest.cs:507 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.DataSet | saveDSSub.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-f3522f49 | SaveButton | DM0098_ScmMstCustomerTest.cs:507 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | CALL_EXT | saveDSSub.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a094f07 | SaveButton | DM0098_ScmMstCustomerTest.cs:511 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.xxxx.WSL/FoxDataService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d302b4e4 | SaveButton | DM0098_ScmMstCustomerTest.cs:515 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c685467c | SaveButton | DM0098_ScmMstCustomerTest.cs:515 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-7753134f | SaveButton | DM0098_ScmMstCustomerTest.cs:520 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0098_ScmMstCustomerTest.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d19b790 | this.spdMain.CellClick | DM0098_ScmMstCustomerTest.cs:567 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c156c94 | this.spdMain.CellClick | DM0098_ScmMstCustomerTest.cs:569 |  | FLAG | mainID | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.DivisionId)) + "," + siMain.GetText… | 화면 필드/플래그 변경 |  |  |  |

## DM0098_ScmMstCustomerTest2.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d225670 | this.Load | DM0098_ScmMstCustomerTest2.cs:150 |  | GRID_INIT | this.AddSheet | (spdMain2, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3781ff6a | this.Load | DM0098_ScmMstCustomerTest2.cs:151 |  | FLAG | siMain | GetSheetInfo(spdMain2.Name, spdMain2.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5754238a | this.Load | DM0098_ScmMstCustomerTest2.cs:153 |  | GRID_INIT | this.AddSheet | (spdSub2, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-055d3477 | this.Load | DM0098_ScmMstCustomerTest2.cs:154 |  | FLAG | siSub | GetSheetInfo(spdSub2.Name, spdSub2.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-295c70c5 | this.Load | DM0098_ScmMstCustomerTest2.cs:156 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0098_ScmMstCustomerTest2.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fb6a1da | DeleteButton | DM0098_ScmMstCustomerTest2.cs:218 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0098_ScmMstCustomerTest2.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3339e5e | Dispose | DM0098_ScmMstCustomerTest2.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0098_ScmMstCustomerTest2.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e09f72e | EditButton | DM0098_ScmMstCustomerTest2.cs:227 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain2.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-412ac0eb | EditButton | DM0098_ScmMstCustomerTest2.cs:228 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-0e13accf | EditButton | DM0098_ScmMstCustomerTest2.cs:230 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DivisionId), siMain.GetColumnIndex(DefColumns.ShiptoCode… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fda906d2 | EditButton | DM0098_ScmMstCustomerTest2.cs:235 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub2.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a65c363e | EditButton | DM0098_ScmMstCustomerTest2.cs:236 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c2dc7f04 | EditButton | DM0098_ScmMstCustomerTest2.cs:238 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.DivisionId2), siSub.GetColumnIndex(DefColumns.ShiptoCode2… | 그리드 편집 잠금/해제 |  |  |  |

## DM0098_ScmMstCustomerTest2.FindData_Main

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98c75553 | FindButton 외 1 | DM0098_ScmMstCustomerTest2.cs:256 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f7813585 | FindButton 외 1 | DM0098_ScmMstCustomerTest2.cs:265 | if (sDivId == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5a9e7ab1 | FindButton 외 1 | DM0098_ScmMstCustomerTest2.cs:267 | if (sDivId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3177af2c | FindButton 외 1 | DM0098_ScmMstCustomerTest2.cs:275 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3b277c7a | FindButton 외 1 | DM0098_ScmMstCustomerTest2.cs:279 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0098_GET_SCM_MST_CUSTOMER_TEST") ⇒ DM.DM0098_GET_SCM_MST_CUSTOMER_TEST | 엔드포인트 요청 생성 |  |  |  |
| AC-c400b44b | FindButton 외 1 | DM0098_ScmMstCustomerTest2.cs:280 | lambda | DATA_OP | request.Parameters["P_DIVISION_ID"] | sDivId | 행/컬럼 값 대입 |  |  |  |
| AC-e3db79ae | FindButton 외 1 | DM0098_ScmMstCustomerTest2.cs:281 | lambda | DATA_OP | request.Parameters["P_ACTIVE_FLAG"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-9453367d | FindButton 외 1 | DM0098_ScmMstCustomerTest2.cs:286 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7e86c587 | FindButton 외 1 | DM0098_ScmMstCustomerTest2.cs:288 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-42a48682 | FindButton 외 1 | DM0098_ScmMstCustomerTest2.cs:295 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-740c13d6 | FindButton 외 1 | DM0098_ScmMstCustomerTest2.cs:296 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-34b0aa1a | FindButton 외 1 | DM0098_ScmMstCustomerTest2.cs:312 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a69fa146 | FindButton 외 1 | DM0098_ScmMstCustomerTest2.cs:319 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0098_ScmMstCustomerTest2.FindData_Sub

진입점: this.spdMain2.CellClick / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-036b9722 | this.spdMain2.CellClick 외 1 | DM0098_ScmMstCustomerTest2.cs:333 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { st… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4e855080 | this.spdMain2.CellClick 외 1 | DM0098_ScmMstCustomerTest2.cs:339 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0098_GET_SCM_MST_SITE_CUSTOMER_TEST") ⇒ DM.DM0098_GET_SCM_MST_SITE_CUSTOMER_TEST | 엔드포인트 요청 생성 |  |  |  |
| AC-3e3bc11b | this.spdMain2.CellClick 외 1 | DM0098_ScmMstCustomerTest2.cs:340 | lambda | DATA_OP | request.Parameters["P_DIVISION_ID"] | sPara[0] | 행/컬럼 값 대입 |  |  |  |
| AC-d5063197 | this.spdMain2.CellClick 외 1 | DM0098_ScmMstCustomerTest2.cs:341 | lambda | DATA_OP | request.Parameters["SHIPTO_CODE"] | sPara[1] | 행/컬럼 값 대입 |  |  |  |
| AC-6bbf7107 | this.spdMain2.CellClick 외 1 | DM0098_ScmMstCustomerTest2.cs:343 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f6387927 | this.spdMain2.CellClick 외 1 | DM0098_ScmMstCustomerTest2.cs:345 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-eb7d7917 | this.spdMain2.CellClick 외 1 | DM0098_ScmMstCustomerTest2.cs:349 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f532384e | this.spdMain2.CellClick 외 1 | DM0098_ScmMstCustomerTest2.cs:353 |  | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0098_ScmMstCustomerTest2.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1d33784 | this.Load | DM0098_ScmMstCustomerTest2.cs:125 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1128f857 | this.Load | DM0098_ScmMstCustomerTest2.cs:126 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0098_ScmMstCustomerTest2.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b37e0130 | this.Load | DM0098_ScmMstCustomerTest2.cs:138 |  | FLAG | dtDiv | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-ffbb1e33 | this.Load | DM0098_ScmMstCustomerTest2.cs:138 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c0883f34 | this.Load | DM0098_ScmMstCustomerTest2.cs:139 |  | LIST_REBIND | clsCtrl.setListBox | (dtDiv, clbDivision2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0c401f57 | this.Load | DM0098_ScmMstCustomerTest2.cs:141 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cmbActive2, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0098_ScmMstCustomerTest2.InitSpread

진입점: this.Load / this.spdMain2.CellClick / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-581deca9 | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:166 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a6b8bab1 | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:168 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a7c3f7cb | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:169 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Div", DefColumns.DivisionId, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.Top) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-03690ffb | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:170 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Sold To Code", DefColumns.SoldtoCode, FPMerge.Always, 80, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c2db3b57 | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:171 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Ship To Code", DefColumns.ShiptoCode, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ebbef9f8 | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:172 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Sold To Description", DefColumns.SoldtoDescription, FPMerge.None, 180, true, FPHAlign.Le… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81cdaca4 | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:173 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Sold To Address", DefColumns.SoldtoAddress, FPMerge.None, 180, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6be4dc37 | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:174 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Sold To Country", DefColumns.SoldtoCountry, FPMerge.None, 100, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9c98841 | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:175 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Region", DefColumns.SoldtoRegion, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d84a19c8 | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:176 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Region Name", DefColumns.SoldtoRegionName, FPMerge.None, 120, true, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a563de7f | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:177 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Valid YN", DefColumns.ValidYn, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-78aa2d4b | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:179 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.ShiptoCode)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-14d63874 | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:181 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2f2c656d | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:186 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-1f0f638d | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:188 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a68ded1b | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:189 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Division Id", DefColumns.DivisionId2, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c37ea5c | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:190 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Scm Site Id", DefColumns.ScmSiteId2, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3a1289b8 | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:191 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Soldto Code", DefColumns.SoldtoCode2, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f96aadad | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:192 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Shipto Code", DefColumns.ShiptoCode2, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d1394f9b | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:193 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Rep YN", DefColumns.RepYn2, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff4cbfd7 | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:194 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Valid YN", DefColumns.ValidYn, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f63c34f5 | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:196 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.Freeze | (0, siSub.GetColumnIndex(DefColumns.ScmSiteId2)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4f0f6031 | this.Load 외 3 | DM0098_ScmMstCustomerTest2.cs:198 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0098_ScmMstCustomerTest2.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed693d21 | InsertButton | DM0098_ScmMstCustomerTest2.cs:531 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ac7f8193 | InsertButton | DM0098_ScmMstCustomerTest2.cs:534 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.DivisionId, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-93a80933 | InsertButton | DM0098_ScmMstCustomerTest2.cs:538 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-b55a8188 | InsertButton | DM0098_ScmMstCustomerTest2.cs:546 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-381f1f1a | InsertButton | DM0098_ScmMstCustomerTest2.cs:549 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | defaultData.Add | (DefColumns.DivisionId, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-9136c614 | InsertButton | DM0098_ScmMstCustomerTest2.cs:553 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## DM0098_ScmMstCustomerTest2.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f14c234 | SaveButton | DM0098_ScmMstCustomerTest2.cs:370 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-994c7ea3 | SaveButton | DM0098_ScmMstCustomerTest2.cs:379 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b9294857 | SaveButton | DM0098_ScmMstCustomerTest2.cs:381 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-8359cba0 | SaveButton | DM0098_ScmMstCustomerTest2.cs:385 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e8f17710 | SaveButton | DM0098_ScmMstCustomerTest2.cs:387 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-4055a6df | SaveButton | DM0098_ScmMstCustomerTest2.cs:390 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fbe989c1 | SaveButton | DM0098_ScmMstCustomerTest2.cs:415 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd895ebf | SaveButton | DM0098_ScmMstCustomerTest2.cs:416 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3e4bf9c8 | SaveButton | DM0098_ScmMstCustomerTest2.cs:417 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | DATA_OP | saveDS.Tables[0].Rows[i].Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fc880b6c | SaveButton | DM0098_ScmMstCustomerTest2.cs:421 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.InsertQueryId | "xxxx.InsertQueryId" | 속성 InsertQueryId 설정 |  |  |  |
| AC-316d3c34 | SaveButton | DM0098_ScmMstCustomerTest2.cs:422 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DeleteQueryId | "xxxx.DeleteQueryId" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-a9660ebc | SaveButton | DM0098_ScmMstCustomerTest2.cs:423 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.UpdateQueryId | "xxxx.UpdateQueryId" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-5876a7dd | SaveButton | DM0098_ScmMstCustomerTest2.cs:425 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-01e76820 | SaveButton | DM0098_ScmMstCustomerTest2.cs:425 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0416fa48 | SaveButton | DM0098_ScmMstCustomerTest2.cs:429 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.xxxx.WSL/FoxDataService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d382595b | SaveButton | DM0098_ScmMstCustomerTest2.cs:433 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-29fc1705 | SaveButton | DM0098_ScmMstCustomerTest2.cs:433 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-2272c27f | SaveButton | DM0098_ScmMstCustomerTest2.cs:438 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d24f8989 | SaveButton | DM0098_ScmMstCustomerTest2.cs:450 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (saveDSSub != null) | STATE_RESET | saveDSSub.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-afb88ba3 | SaveButton | DM0098_ScmMstCustomerTest2.cs:459 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-41bed305 | SaveButton | DM0098_ScmMstCustomerTest2.cs:461 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-a5c33a82 | SaveButton | DM0098_ScmMstCustomerTest2.cs:465 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6dae3f08 | SaveButton | DM0098_ScmMstCustomerTest2.cs:467 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | saveDSSub.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-24ee0a3f | SaveButton | DM0098_ScmMstCustomerTest2.cs:470 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | saveDSSub.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-49412328 | SaveButton | DM0098_ScmMstCustomerTest2.cs:486 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-978b9505 | SaveButton | DM0098_ScmMstCustomerTest2.cs:495 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < saveDSSub.Tables[0].Rows.C… | CALL_EXT | saveDSSub.Tables[0].Rows[i].SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-87fdba40 | SaveButton | DM0098_ScmMstCustomerTest2.cs:496 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < saveDSSub.Tables[0].Rows.C… | CALL_EXT | saveDSSub.Tables[0].Rows[i].SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b5b01cf | SaveButton | DM0098_ScmMstCustomerTest2.cs:497 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < saveDSSub.Tables[0].Rows.C… | DATA_OP | saveDSSub.Tables[0].Rows[i].Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b6045131 | SaveButton | DM0098_ScmMstCustomerTest2.cs:501 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.InsertQueryId | "xxxx.InsertQueryId" | 속성 InsertQueryId 설정 |  |  |  |
| AC-abffe637 | SaveButton | DM0098_ScmMstCustomerTest2.cs:502 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.DeleteQueryId | "xxxx.DeleteQueryId" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-fbc6bbfb | SaveButton | DM0098_ScmMstCustomerTest2.cs:503 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.UpdateQueryId | "xxxx.UpdateQueryId" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-d72c0b32 | SaveButton | DM0098_ScmMstCustomerTest2.cs:505 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | UI_PROP | request.DataSet | saveDSSub.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-2f14a554 | SaveButton | DM0098_ScmMstCustomerTest2.cs:505 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | CALL_EXT | saveDSSub.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a82c8398 | SaveButton | DM0098_ScmMstCustomerTest2.cs:509 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.xxxx.WSL/FoxDataService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e0e89aa | SaveButton | DM0098_ScmMstCustomerTest2.cs:513 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-73803d6d | SaveButton | DM0098_ScmMstCustomerTest2.cs:513 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-45532fac | SaveButton | DM0098_ScmMstCustomerTest2.cs:518 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0098_ScmMstCustomerTest2.SpdMain_CellClick

진입점: this.spdMain2.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84019bce | this.spdMain2.CellClick | DM0098_ScmMstCustomerTest2.cs:565 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1aaddf18 | this.spdMain2.CellClick | DM0098_ScmMstCustomerTest2.cs:567 |  | FLAG | mainID | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.DivisionId)) + "\|" + siMain.GetTex… | 화면 필드/플래그 변경 |  |  |  |


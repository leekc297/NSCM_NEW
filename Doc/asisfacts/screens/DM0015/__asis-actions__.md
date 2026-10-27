# AS-IS 액션 대조표 — DM0015

> 원천: `Doc/asisfacts/screens/DM0015/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 264행 · 메서드 31 · 종류 GRID_INIT 87 · DATA_OP 53 · RETURN 24 · FLAG 21 · MESSAGE 15 · GRID_LOCK 15 · COMBO_DATA 12 · ENDPOINT 10 · LIST_REBIND 7 · GRID_SET 6 · UI_PROP 3 · POPUP 3 · UI_MISC 2 · GRID_BIND 2 · GRID_COMBO 2 · CALL_EXT 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 1


## DM0015_BOD.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e357cc28 | this.clbDivision.SelectedIndexChanged | DM0015_BOD.cs:1313 |  | FLAG | dtFromSite | GetFromSitebyDivision(clbDivision.ControlValues.ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-4aad4e19 | this.clbDivision.SelectedIndexChanged | DM0015_BOD.cs:1314 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-23a54fc4 | this.clbDivision.SelectedIndexChanged | DM0015_BOD.cs:1315 |  | FLAG | dtToSite | GetFromSitebyDivision( clbDivision.ControlValues.ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-9ce55bbc | this.clbDivision.SelectedIndexChanged | DM0015_BOD.cs:1316 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0015_BOD.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b76f974 | this.Load | DM0015_BOD.cs:279 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-675765d1 | this.Load | DM0015_BOD.cs:280 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-26eaa14c | this.Load | DM0015_BOD.cs:282 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c867a348 | this.Load | DM0015_BOD.cs:284 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d9fa3e89 | this.Load | DM0015_BOD.cs:285 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## DM0015_BOD.CSafeSetText

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5034c77a | (진입점 미연결) | DM0015_BOD.cs:212 | if (ctl.InvokeRequired) | CALL_EXT | ctl.Invoke | (new CrossThreadSafetySetText(CSafeSetText), ctl, text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6cbfde2c | (진입점 미연결) | DM0015_BOD.cs:214 | else of (ctl.InvokeRequired) | VALUE_SET | ctl.Text | text | 컨트롤 값 설정 |  |  |  |

## DM0015_BOD.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6748891 | this.Load | DM0015_BOD.cs:269 |  | UI_PROP | usrConditionPanel1.Height | 45 | 속성 Height 설정 |  |  |  |

## DM0015_BOD.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c5ef74d | DeleteButton | DM0015_BOD.cs:478 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0015_BOD.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b619f0e | Dispose | DM0015_BOD.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0015_BOD.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-676d40fc | EditButton | DM0015_BOD.cs:490 | if (this.fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siSub.ActiveSheet.SheetName, siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b5af46fc | EditButton | DM0015_BOD.cs:491 | if (this.fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f377f53 | EditButton | DM0015_BOD.cs:494 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-fc40dfac | EditButton | DM0015_BOD.cs:495 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-1bc9b1e5 | EditButton | DM0015_BOD.cs:498 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.BodID), siMain.GetColumnIndex(DefColumns.ToSite), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b10eeb00 | EditButton | DM0015_BOD.cs:499 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FromSite), siMain.GetColumnIndex(DefColumns.FromSite), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb84bd46 | EditButton | DM0015_BOD.cs:500 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.UpdateUser), siMain.GetColumnIndex(DefColumns.UpdateDate… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d5102ad3 | EditButton | DM0015_BOD.cs:501 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.Incoterms), siMain.GetColumnIndex(DefColumns.Incoterms),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-61d3408e | EditButton | DM0015_BOD.cs:502 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LtTotal), siMain.GetColumnIndex(DefColumns.LtTotal), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0b6d571f | EditButton | DM0015_BOD.cs:508 | if (this.fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-94e1d83a | EditButton | DM0015_BOD.cs:509 | if (this.fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-99e0d556 | EditButton | DM0015_BOD.cs:512 | if (this.fps != null) ▸ else of (fps.Name == "spdMain") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8f6018d6 | EditButton | DM0015_BOD.cs:513 | if (this.fps != null) ▸ else of (fps.Name == "spdMain") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-9f8a5360 | EditButton | DM0015_BOD.cs:515 | if (this.fps != null) ▸ else of (fps.Name == "spdMain") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.BodID) , siSub.GetColumnIndex(DefColumns.ItemId), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-85fd2877 | EditButton | DM0015_BOD.cs:517 | if (this.fps != null) ▸ else of (fps.Name == "spdMain") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.UpdateDate) , siSub.GetColumnIndex(DefColumns.UpdateUser)… | 그리드 편집 잠금/해제 |  |  |  |

## DM0015_BOD.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb0ac7b8 | FindButton | DM0015_BOD.cs:456 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siMain.ActiveRowIndex == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0015_BOD.FindDataMain

진입점: FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58ed8c89 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0015_BOD.cs:558 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b228c509 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0015_BOD.cs:562 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0015_GET_BOD_DATA") ⇒ DM.DM0015_GET_BOD_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-8302b44e | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0015_BOD.cs:563 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1fc486c0 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0015_BOD.cs:564 | lambda | DATA_OP | request.Parameters["p_bod_type"] | sBodType | 행/컬럼 값 대입 |  |  |  |
| AC-86d31c49 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0015_BOD.cs:565 | lambda | DATA_OP | request.Parameters["p_from_site_id"] | sFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-64bff58c | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0015_BOD.cs:566 | lambda | DATA_OP | request.Parameters["p_to_site_id"] | sToSite | 행/컬럼 값 대입 |  |  |  |
| AC-cacdbc86 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0015_BOD.cs:567 | lambda | DATA_OP | request.Parameters["p_group"] | UserGroup | 행/컬럼 값 대입 |  |  |  |
| AC-dc6e963e | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0015_BOD.cs:568 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserId | 행/컬럼 값 대입 |  |  |  |
| AC-facd08dd | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0015_BOD.cs:570 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-c8e3ae9c | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0015_BOD.cs:572 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ea16e007 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0015_BOD.cs:574 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3932bcd9 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0015_BOD.cs:578 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-999c8ec8 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0015_BOD.cs:579 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DM0015_BOD.FindDataSub

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub")] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fb4eb80 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0015_BOD.cs:602 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-736d45fe | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0015_BOD.cs:606 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0015_GET_BOD_ITEM_DATA") ⇒ DM.DM0015_GET_BOD_ITEM_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-b5a4c43a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0015_BOD.cs:607 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c5868923 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0015_BOD.cs:608 | lambda | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-5ff2c63e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0015_BOD.cs:609 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-25c8a0a5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0015_BOD.cs:611 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-82e3b6d6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0015_BOD.cs:617 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d472e760 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0015_BOD.cs:618 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DM0015_BOD.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2babf73e | this.Load | DM0015_BOD.cs:221 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-14bb4dc4 | this.Load | DM0015_BOD.cs:222 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0015_BOD.GetBodType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8728a72c | this.Load | DM0015_BOD.cs:1167 |  | COMBO_DATA | Data.Common | (Data.Type.BodType, false) ⇒ biz:CommonData.CommonDataList [code=BodType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-59768910 | this.Load | DM0015_BOD.cs:1169 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0015_BOD.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cdb0cf2 | this.Load | DM0015_BOD.cs:1138 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserGroup, UserId) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-856ac94d | this.Load | DM0015_BOD.cs:1140 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0015_BOD.GetEndCustomerByDivision

진입점: this.spdMain.ComboSelChange [if (siMain.GetColumnTag(e.Column) == "DIVISION_ID"\|\| siMain.GetColumnTag(e.Column) == "END_CUSTOMER")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e20b3a1b | this.spdMain.ComboSelChange [if (siMain.GetColumnTag(e.Colum… | DM0015_BOD.cs:1196 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-3c7224e1 | this.spdMain.ComboSelChange [if (siMain.GetColumnTag(e.Colum… | DM0015_BOD.cs:1196 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a4dbec3e | this.spdMain.ComboSelChange [if (siMain.GetColumnTag(e.Colum… | DM0015_BOD.cs:1198 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0015_BOD.GetFromSitebyDivision

진입점: this.clbDivision.SelectedIndexChanged / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52e0e2e8 | this.clbDivision.SelectedIndexChanged 외 1 | DM0015_BOD.cs:1147 |  | COMBO_DATA | Data.Common | (Data.Type.FromSiteByDivision, false, sDivision, UserGroup, UserId) ⇒ biz:CommonData.CommonDataList [code=FromSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-55b71047 | this.clbDivision.SelectedIndexChanged 외 1 | DM0015_BOD.cs:1148 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0015_BOD.GetIncoterms

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70d87dd2 | this.Load | DM0015_BOD.cs:1186 |  | COMBO_DATA | Data.Common | (Data.Type.Incoterms, false) ⇒ biz:CommonData.CommonDataList [code=Incoterms] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2bef4311 | this.Load | DM0015_BOD.cs:1188 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0015_BOD.GetItemBySite

진입점: this.Load / InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-711d449b | this.Load 외 1 | DM0015_BOD.cs:1222 |  | COMBO_DATA | Data.Common | (Data.Type.ItemBySite, false, Division,Site) ⇒ biz:CommonData.CommonDataList [code=ItemBySite] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a22a822a | this.Load 외 1 | DM0015_BOD.cs:1223 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0015_BOD.GetPortBySite

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6887a931 | this.Load | DM0015_BOD.cs:1206 |  | COMBO_DATA | Data.Common | (Data.Type.PortBySite, false, Site, "ALL") ⇒ biz:CommonData.CommonDataList [code=PortBySite] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-41c6b0a8 | this.Load | DM0015_BOD.cs:1208 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0015_BOD.GetSiteByEndCustomer

진입점: this.spdMain.ComboSelChange [else of (siMain.GetColumnTag(e.Column) == "DIVISION_ID"\|\| siMain.GetColumnTag(e.Column) == "END_CUSTOMER") ▸ if (siMain.GetColumnTag(e.Column) == "END_CUSTOMER")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fa1c539 | this.spdMain.ComboSelChange [else of (siMain.GetColumnTag(e.… | DM0015_BOD.cs:1214 |  | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer, false, Division, EndCustomer) ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1699eb5f | this.spdMain.ComboSelChange [else of (siMain.GetColumnTag(e.… | DM0015_BOD.cs:1215 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0015_BOD.GetSpdTitle

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (spreadInf.SheetName == SpdSheet.shtMain)] / this.Load [if (spreadInf.SheetName == SpdSheet.shtMain)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spreadInf.SheetName == SpdSheet.shtMain)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ if (spreadInf.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d7d737f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0015_BOD.cs:1304 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DM0015", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-80415a54 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0015_BOD.cs:1305 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0015_BOD.GetToSitebyDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1639aea8 | this.Load | DM0015_BOD.cs:1155 |  | COMBO_DATA | Data.Common | (Data.Type.ToSiteByDivision, false, sDivision, UserGroup, UserId) ⇒ biz:CommonData.CommonDataList [code=ToSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-89a8b6f9 | this.Load | DM0015_BOD.cs:1157 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0015_BOD.GetTransMode

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-468e09bb | this.Load | DM0015_BOD.cs:1177 |  | COMBO_DATA | Data.Common | (Data.Type.TransportMode, false) ⇒ biz:CommonData.CommonDataList [code=TransportMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-253722a6 | this.Load | DM0015_BOD.cs:1178 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0015_BOD.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d83cf03 | this.Load | DM0015_BOD.cs:237 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2f7e772d | this.Load | DM0015_BOD.cs:238 |  | FLAG | dtDivision | GetDivision() | 화면 필드/플래그 변경 |  |  |  |
| AC-b229bb7f | this.Load | DM0015_BOD.cs:239 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e5a498a6 | this.Load | DM0015_BOD.cs:241 |  | FLAG | dtFromSite | GetFromSitebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-97358429 | this.Load | DM0015_BOD.cs:242 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-afcb4e86 | this.Load | DM0015_BOD.cs:244 |  | FLAG | dtToSite | GetToSitebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-f417683d | this.Load | DM0015_BOD.cs:245 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-081733c3 | this.Load | DM0015_BOD.cs:246 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, clbActive, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4eb0594c | this.Load | DM0015_BOD.cs:247 |  | FLAG | dtBodType | GetBodType() | 화면 필드/플래그 변경 |  |  |  |
| AC-37406c8c | this.Load | DM0015_BOD.cs:248 |  | LIST_REBIND | clsCtrl.setListBox | (dtBodType, clbBodType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2d363bf0 | this.Load | DM0015_BOD.cs:250 |  | FLAG | dtTransMode | GetTransMode() | 화면 필드/플래그 변경 |  |  |  |
| AC-3bee85ce | this.Load | DM0015_BOD.cs:252 |  | FLAG | dtIncoterms | GetIncoterms() | 화면 필드/플래그 변경 |  |  |  |
| AC-e29ed55a | this.Load | DM0015_BOD.cs:255 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-3442b79f | this.Load | DM0015_BOD.cs:255 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-93c9830b | this.Load | DM0015_BOD.cs:256 |  | FLAG | dtPort | GetPortBySite("All") | 화면 필드/플래그 변경 |  |  |  |
| AC-55b36b50 | this.Load | DM0015_BOD.cs:257 |  | FLAG | dtBodItem | GetItemBySite("All", "All") | 화면 필드/플래그 변경 |  |  |  |

## DM0015_BOD.InitSpread

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / this.Load / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abc8edb8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0015_BOD.cs:425 | if (spreadInf.SheetName == SpdSheet.shtMain) | FLAG | dtTitle | GetSpdTitle(SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-069bbbda | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0015_BOD.cs:426 | if (spreadInf.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-cd99a4cc | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0015_BOD.cs:430 | else of (spreadInf.SheetName == SpdSheet.shtMain) ▸ if (spreadInf.SheetName == SpdSheet.shtSub) | FLAG | dtTitle | GetSpdTitle(SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-152dd307 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0015_BOD.cs:431 | else of (spreadInf.SheetName == SpdSheet.shtMain) ▸ if (spreadInf.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.CreateSheetHeaderColumn | (siSub, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0015_BOD.InitSpread2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9c71a0a | (진입점 미연결) | DM0015_BOD.cs:295 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f457ba06 | (진입점 미연결) | DM0015_BOD.cs:299 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4bd035f1 | (진입점 미연결) | DM0015_BOD.cs:300 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabels.BodID, DefColumns.BodID, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2b4f5737 | (진입점 미연결) | DM0015_BOD.cs:301 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.Division, DefColumns.Division, FPMerge.None, 80, true, dtDivision, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8402384a | (진입점 미연결) | DM0015_BOD.cs:302 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.BodType, DefColumns.BodType, FPMerge.None, 120, true, dtBodType, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7472b5c2 | (진입점 미연결) | DM0015_BOD.cs:303 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.EndCustomer, DefColumns.EndCustomer, FPMerge.None, 220, true,dtEndCustom… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bdfb702a | (진입점 미연결) | DM0015_BOD.cs:304 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.ToSite, DefColumns.ToSite, FPMerge.None, 220, true, dtToSite,FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e719c03 | (진입점 미연결) | DM0015_BOD.cs:305 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabels.HubSloc, DefColumns.HubSloc, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1bd324bd | (진입점 미연결) | DM0015_BOD.cs:306 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.Incoterms, DefColumns.Incoterms, FPMerge.None, 120, true, dtIncoterms) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e51fc03e | (진입점 미연결) | DM0015_BOD.cs:307 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.FromSite, DefColumns.FromSite, FPMerge.None, 220, true, dtFromSite, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f5cdeab5 | (진입점 미연결) | DM0015_BOD.cs:308 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumColumn | (DefColumnsLabels.Priority, DefColumns.Priority, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-720f22c5 | (진입점 미연결) | DM0015_BOD.cs:309 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.TransportMode, DefColumns.TransportMode, FPMerge.None, 120, true,dtTrans… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bfce764e | (진입점 미연결) | DM0015_BOD.cs:310 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.PerMon, DefColumns.PerMon, FPMerge.None, 40, true,dtYesOrNo, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a032c8e1 | (진입점 미연결) | DM0015_BOD.cs:311 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.PerTue, DefColumns.PerTue, FPMerge.None, 40, true,dtYesOrNo, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-70a6252c | (진입점 미연결) | DM0015_BOD.cs:312 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.PerWed, DefColumns.PerWed, FPMerge.None, 40, true,dtYesOrNo, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-363927b9 | (진입점 미연결) | DM0015_BOD.cs:313 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.PerThu, DefColumns.PerThu, FPMerge.None, 40, true,dtYesOrNo, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80e6f522 | (진입점 미연결) | DM0015_BOD.cs:314 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.PerFri, DefColumns.PerFri, FPMerge.None, 40, true,dtYesOrNo, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-146ffa3e | (진입점 미연결) | DM0015_BOD.cs:315 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.PerSat, DefColumns.PerSat, FPMerge.None, 40, true,dtYesOrNo, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09f69d11 | (진입점 미연결) | DM0015_BOD.cs:316 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.PerSun, DefColumns.PerSun, FPMerge.None, 40, true,dtYesOrNo, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ead93398 | (진입점 미연결) | DM0015_BOD.cs:317 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.POL, DefColumns.POL, FPMerge.None, 60, true, dtPort) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a10d117 | (진입점 미연결) | DM0015_BOD.cs:318 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabels.POD, DefColumns.POD, FPMerge.None, 60, true, dtPort) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb796b8e | (진입점 미연결) | DM0015_BOD.cs:319 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabels.FreightForwarder, DefColumns.FreightForwarder, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37f32193 | (진입점 미연결) | DM0015_BOD.cs:320 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumColumn | (DefColumnsLabels.SafetyStock, DefColumns.SafetyStock, FPMerge.None, 80, true,FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-152d445b | (진입점 미연결) | DM0015_BOD.cs:321 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumColumn | (DefColumnsLabels.Period1Lt, DefColumns.Period1Lt, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-31ff7e8d | (진입점 미연결) | DM0015_BOD.cs:322 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumColumn | (DefColumnsLabels.PolClearanceLt, DefColumns.PolClearanceLt, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e1772864 | (진입점 미연결) | DM0015_BOD.cs:323 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumColumn | (DefColumnsLabels.Period2Lt, DefColumns.Period2Lt, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f5c7f4b | (진입점 미연결) | DM0015_BOD.cs:324 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumColumn | (DefColumnsLabels.PodClearanceLt, DefColumns.PodClearanceLt, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fcffa5a7 | (진입점 미연결) | DM0015_BOD.cs:325 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumColumn | (DefColumnsLabels.Period3Lt, DefColumns.Period3Lt, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37b84586 | (진입점 미연결) | DM0015_BOD.cs:326 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumColumn | (DefColumnsLabels.LtTotal, DefColumns.LtTotal, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33a7d84e | (진입점 미연결) | DM0015_BOD.cs:327 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddNumColumn | (DefColumnsLabels.CustomerLt, DefColumns.CustomerLt, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1048aee6 | (진입점 미연결) | DM0015_BOD.cs:328 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabels.ValidYn, DefColumns.ValidYn, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a808a8e | (진입점 미연결) | DM0015_BOD.cs:329 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabels.UpdateDate, DefColumns.UpdateDate, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cdf80ce7 | (진입점 미연결) | DM0015_BOD.cs:330 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabels.UpdateUser, DefColumns.UpdateUser, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81f99318 | (진입점 미연결) | DM0015_BOD.cs:338 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(CAppSetting.StringAction), 2, 1, 30, "A", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66086426 | (진입점 미연결) | DM0015_BOD.cs:340 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.BodID ), 2, 1, 30, DefColumnsLabels.BodID, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d7be3e34 | (진입점 미연결) | DM0015_BOD.cs:341 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.Division ), 2, 1, 30, DefColumnsLabels.Division, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f4477fa3 | (진입점 미연결) | DM0015_BOD.cs:342 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.BodType ) , 2, 1, 30, DefColumnsLabels.BodType, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d02f2fe4 | (진입점 미연결) | DM0015_BOD.cs:343 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.EndCustomer), 2, 1, 30, DefColumnsLabels.EndCustomer,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-01aba889 | (진입점 미연결) | DM0015_BOD.cs:344 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ToSite ), 2, 1, 30, DefColumnsLabels.ToSite, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b70d600 | (진입점 미연결) | DM0015_BOD.cs:345 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.HubSloc ), 2, 1, 30, DefColumnsLabels.HubSloc, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50e8582b | (진입점 미연결) | DM0015_BOD.cs:346 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.Incoterms), 2, 1, 30, DefColumnsLabels.Incoterms, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9252ee5 | (진입점 미연결) | DM0015_BOD.cs:347 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FromSite ), 2, 1, 30, DefColumnsLabels.FromSite, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-444e67b0 | (진입점 미연결) | DM0015_BOD.cs:348 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.Priority ), 2, 1, 30, DefColumnsLabels.Priority, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4101c8f4 | (진입점 미연결) | DM0015_BOD.cs:349 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TransportMode ), 2, 1, 30, DefColumnsLabels.Transport… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7bc3fe21 | (진입점 미연결) | DM0015_BOD.cs:350 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.POL ), 2, 1, 30, DefColumnsLabels.POL, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-96d57868 | (진입점 미연결) | DM0015_BOD.cs:351 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.POD ), 2, 1, 30, DefColumnsLabels.POD, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-745a905d | (진입점 미연결) | DM0015_BOD.cs:352 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FreightForwarder ), 2, 1, 30, DefColumnsLabels.Freigh… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8753e2fb | (진입점 미연결) | DM0015_BOD.cs:353 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.SafetyStock ), 2, 1, 30, DefColumnsLabels.SafetyStock… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8be9bcd7 | (진입점 미연결) | DM0015_BOD.cs:355 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.CustomerLt), 2, 1, 30, DefColumnsLabels.CustomerLt, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9c97b83 | (진입점 미연결) | DM0015_BOD.cs:356 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ValidYn), 2, 1, 30, DefColumnsLabels.ValidYn, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c4f61cb | (진입점 미연결) | DM0015_BOD.cs:357 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.UpdateDate), 2, 1, 30, DefColumnsLabels.UpdateDate, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b5b8b77 | (진입점 미연결) | DM0015_BOD.cs:358 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.UpdateUser), 2, 1, 30, DefColumnsLabels.UpdateUser, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-70cd7e2b | (진입점 미연결) | DM0015_BOD.cs:364 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.PerMon), 1, 7, 30, "Days", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e654a5fd | (진입점 미연결) | DM0015_BOD.cs:365 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.PerMon), 1, 1, 30, DefColumnsLabels.PerMon, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f8bc90e7 | (진입점 미연결) | DM0015_BOD.cs:366 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.PerTue), 1, 1, 30, DefColumnsLabels.PerTue, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b1402e2 | (진입점 미연결) | DM0015_BOD.cs:367 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.PerWed), 1, 1, 30, DefColumnsLabels.PerWed, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a301a8a4 | (진입점 미연결) | DM0015_BOD.cs:368 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.PerThu), 1, 1, 30, DefColumnsLabels.PerThu, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e67e0032 | (진입점 미연결) | DM0015_BOD.cs:369 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.PerFri), 1, 1, 30, DefColumnsLabels.PerFri, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6050a6f1 | (진입점 미연결) | DM0015_BOD.cs:370 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.PerSat), 1, 1, 30, DefColumnsLabels.PerSat, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b290bf50 | (진입점 미연결) | DM0015_BOD.cs:371 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.PerSun), 1, 1, 30, DefColumnsLabels.PerSun, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4f40a02 | (진입점 미연결) | DM0015_BOD.cs:373 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.Period1Lt), 1, 6, 30, "Lead Time", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3269bdec | (진입점 미연결) | DM0015_BOD.cs:375 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.Period1Lt), 1, 1, 30, DefColumnsLabels.Period1Lt, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f3d840c | (진입점 미연결) | DM0015_BOD.cs:376 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.PolClearanceLt), 1, 1, 30, DefColumnsLabels.PolCleara… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5c98cdf1 | (진입점 미연결) | DM0015_BOD.cs:377 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.Period2Lt), 1, 1, 30, DefColumnsLabels.Period2Lt, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8c398d34 | (진입점 미연결) | DM0015_BOD.cs:378 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.PodClearanceLt), 1, 1, 30, DefColumnsLabels.PodCleara… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-39d155d0 | (진입점 미연결) | DM0015_BOD.cs:379 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.Period3Lt), 1, 1, 30, DefColumnsLabels.Period3Lt, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ad223b9 | (진입점 미연결) | DM0015_BOD.cs:380 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.LtTotal), 1, 1, 30, DefColumnsLabels.LtTotal, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8a992ce | (진입점 미연결) | DM0015_BOD.cs:391 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1d2baa3e | (진입점 미연결) | DM0015_BOD.cs:395 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-58c9345b | (진입점 미연결) | DM0015_BOD.cs:397 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8fdcaec2 | (진입점 미연결) | DM0015_BOD.cs:398 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddTextColumn | (DefColumnsLabels.BodID, DefColumns.BodID, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-22cdecb9 | (진입점 미연결) | DM0015_BOD.cs:399 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddComboColumn | (DefColumnsLabels.Division, DefColumns.Division, FPMerge.None, 80, true,dtDivision) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e874b233 | (진입점 미연결) | DM0015_BOD.cs:400 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddTextColumn | (DefColumnsLabels.ItemId, DefColumns.ItemId, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-03a5bfd4 | (진입점 미연결) | DM0015_BOD.cs:401 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddTextColumn | (DefColumnsLabels.LotSize, DefColumns.LotSize, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4fb4fc7b | (진입점 미연결) | DM0015_BOD.cs:402 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddTextColumn | (DefColumnsLabels.FrozenPeriod, DefColumns.FrozenPeriod, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-24c9b87b | (진입점 미연결) | DM0015_BOD.cs:403 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddTextColumn | (DefColumnsLabels.EffStartDate, DefColumns.EffStartDate, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e48ff97b | (진입점 미연결) | DM0015_BOD.cs:404 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddTextColumn | (DefColumnsLabels.EffEndDate, DefColumns.EffEndDate, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48c94acc | (진입점 미연결) | DM0015_BOD.cs:405 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddTextColumn | (DefColumnsLabels.ValidYn, DefColumns.ValidYn, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-253c8c7c | (진입점 미연결) | DM0015_BOD.cs:407 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddTextColumn | (DefColumnsLabels.UpdateDate, DefColumns.UpdateDate, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f51d3cec | (진입점 미연결) | DM0015_BOD.cs:408 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddTextColumn | (DefColumnsLabels.UpdateUser, DefColumns.UpdateUser, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d81f6579 | (진입점 미연결) | DM0015_BOD.cs:410 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0015_BOD.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9ccc4f7 | InsertButton | DM0015_BOD.cs:1020 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-65c66e3f | InsertButton | DM0015_BOD.cs:1034 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LtTotal), siMain.GetColumnIndex(DefColumns.LtTo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0be0109b | InsertButton | DM0015_BOD.cs:1035 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.BodID), siMain.GetColumnIndex(DefColumns.BodID)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0120c8f8 | InsertButton | DM0015_BOD.cs:1036 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.UpdateUser), siMain.GetColumnIndex(DefColumns.U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-11eab557 | InsertButton | DM0015_BOD.cs:1037 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ValidYn), "Y") | 그리드 값 설정 |  |  |  |
| AC-3c5ffe40 | InsertButton | DM0015_BOD.cs:1049 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siMain.ActiveRowIndex == -1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d29a7d1 | InsertButton | DM0015_BOD.cs:1050 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siMain.ActiveRowIndex == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f79c17a | InsertButton | DM0015_BOD.cs:1053 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-04bedc2a | InsertButton | DM0015_BOD.cs:1060 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | FLAG | dtBodItem | GetItemBySite(mainDiv, mainSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-41b73f61 | InsertButton | DM0015_BOD.cs:1073 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.Division, mainDiv) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb841708 | InsertButton | DM0015_BOD.cs:1074 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.BodID, mainBodId) | 데이터 객체 조작/조회 |  |  |  |
| AC-d558fe5e | InsertButton | DM0015_BOD.cs:1077 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-e0b4e440 | InsertButton | DM0015_BOD.cs:1078 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siMain.GetValue(siMain.A… | 그리드 값 설정 |  |  |  |
| AC-4f55625e | InsertButton | DM0015_BOD.cs:1079 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.BodID), siMain.GetValue(siMain.Acti… | 그리드 값 설정 |  |  |  |
| AC-1b7b55e9 | InsertButton | DM0015_BOD.cs:1080 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ValidYn), "Y") | 그리드 값 설정 |  |  |  |
| AC-1166ab50 | InsertButton | DM0015_BOD.cs:1085 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.GetColumnIndex(DefColumns.Upd… | 그리드 편집 잠금/해제 |  |  |  |

## DM0015_BOD.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2855d4b1 | SaveButton | DM0015_BOD.cs:639 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2e09c85d | SaveButton | DM0015_BOD.cs:693 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMa… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db23f040 | SaveButton | DM0015_BOD.cs:706 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (int.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00118") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e29c64eb | SaveButton | DM0015_BOD.cs:726 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00117") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-859f19e4 | SaveButton | DM0015_BOD.cs:813 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0015_SAVE_BOD_DATA \| DM.DM0015_SAVE_BOD_ITEM_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-f8a59843 | SaveButton | DM0015_BOD.cs:814 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-326b131e | SaveButton | DM0015_BOD.cs:815 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-d1f867d6 | SaveButton | DM0015_BOD.cs:816 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-813219f7 | SaveButton | DM0015_BOD.cs:817 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bod_type"] | sBodType | 행/컬럼 값 대입 |  |  |  |
| AC-476bc871 | SaveButton | DM0015_BOD.cs:818 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_site"] | sFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-009f302a | SaveButton | DM0015_BOD.cs:819 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_pol"] | sPol | 행/컬럼 값 대입 |  |  |  |
| AC-a9517e72 | SaveButton | DM0015_BOD.cs:820 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_pod"] | sPod | 행/컬럼 값 대입 |  |  |  |
| AC-0069415c | SaveButton | DM0015_BOD.cs:821 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_hub_sloc"] | sHubSloc | 행/컬럼 값 대입 |  |  |  |
| AC-1bdc73b0 | SaveButton | DM0015_BOD.cs:822 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_site"] | sToSite | 행/컬럼 값 대입 |  |  |  |
| AC-a4ac2173 | SaveButton | DM0015_BOD.cs:823 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-9a96eb0d | SaveButton | DM0015_BOD.cs:824 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_transport_mode"] | sTransportMode | 행/컬럼 값 대입 |  |  |  |
| AC-9b8bcd2b | SaveButton | DM0015_BOD.cs:825 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_priority"] | sPriority | 행/컬럼 값 대입 |  |  |  |
| AC-0dd278fa | SaveButton | DM0015_BOD.cs:826 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_per_mon"] | sPerMon | 행/컬럼 값 대입 |  |  |  |
| AC-85258f81 | SaveButton | DM0015_BOD.cs:827 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_per_tue"] | sPerTue | 행/컬럼 값 대입 |  |  |  |
| AC-077f6ada | SaveButton | DM0015_BOD.cs:828 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_per_wed"] | sPerWed | 행/컬럼 값 대입 |  |  |  |
| AC-76102c69 | SaveButton | DM0015_BOD.cs:829 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_per_thu"] | sPerThu | 행/컬럼 값 대입 |  |  |  |
| AC-2f816187 | SaveButton | DM0015_BOD.cs:830 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_per_fri"] | sPerFri | 행/컬럼 값 대입 |  |  |  |
| AC-df359228 | SaveButton | DM0015_BOD.cs:831 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_per_sat"] | sPerSat | 행/컬럼 값 대입 |  |  |  |
| AC-537eb494 | SaveButton | DM0015_BOD.cs:832 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_per_sun"] | sPerSun | 행/컬럼 값 대입 |  |  |  |
| AC-ab335f85 | SaveButton | DM0015_BOD.cs:833 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fre_forwarder"] | sFreForwarder | 행/컬럼 값 대입 |  |  |  |
| AC-1ba99230 | SaveButton | DM0015_BOD.cs:834 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_safety_stock"] | sSafetyStock | 행/컬럼 값 대입 |  |  |  |
| AC-a3d1999e | SaveButton | DM0015_BOD.cs:835 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_pe1_lt"] | sPe1Lt | 행/컬럼 값 대입 |  |  |  |
| AC-074ebf4b | SaveButton | DM0015_BOD.cs:836 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_pol_clr_lt"] | sPolClrLt | 행/컬럼 값 대입 |  |  |  |
| AC-3a857d37 | SaveButton | DM0015_BOD.cs:837 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_pe2_lt"] | sPe2Lt | 행/컬럼 값 대입 |  |  |  |
| AC-a6d67ac7 | SaveButton | DM0015_BOD.cs:838 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_pod_lt"] | sPodLt | 행/컬럼 값 대입 |  |  |  |
| AC-80861efa | SaveButton | DM0015_BOD.cs:839 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_pe3_lt"] | sPe3Lt | 행/컬럼 값 대입 |  |  |  |
| AC-c94dbfd3 | SaveButton | DM0015_BOD.cs:840 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cust_lt"] | sCustLt | 행/컬럼 값 대입 |  |  |  |
| AC-d810e6c4 | SaveButton | DM0015_BOD.cs:841 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sActiveFlag | 행/컬럼 값 대입 |  |  |  |
| AC-cc018dd0 | SaveButton | DM0015_BOD.cs:842 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-9d5fc4bb | SaveButton | DM0015_BOD.cs:844 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a220b64 | SaveButton | DM0015_BOD.cs:848 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-960e9960 | SaveButton | DM0015_BOD.cs:852 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2b78fd12 | SaveButton | DM0015_BOD.cs:860 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e77856d4 | SaveButton | DM0015_BOD.cs:872 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3030115c | SaveButton | DM0015_BOD.cs:883 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (siSub.Activ… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee7ebd1d | SaveButton | DM0015_BOD.cs:911 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ for (i <= siSub… | MESSAGE | MessageHelper.GMessageBox | ("MSG00118") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-97386725 | SaveButton | DM0015_BOD.cs:959 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0015_SAVE_BOD_DATA \| DM.DM0015_SAVE_BOD_ITEM_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-c6b113d0 | SaveButton | DM0015_BOD.cs:960 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-27ff544e | SaveButton | DM0015_BOD.cs:961 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-d1b091ab | SaveButton | DM0015_BOD.cs:962 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-ccdfaeaa | SaveButton | DM0015_BOD.cs:963 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-399f01a0 | SaveButton | DM0015_BOD.cs:964 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | DATA_OP | request.Parameters["p_eff_start_date"] | sEffStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-330d7511 | SaveButton | DM0015_BOD.cs:965 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | DATA_OP | request.Parameters["p_lot_size"] | sLotSize | 행/컬럼 값 대입 |  |  |  |
| AC-2eb30d55 | SaveButton | DM0015_BOD.cs:966 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | DATA_OP | request.Parameters["p_frozen_period"] | sFrozenPeriod | 행/컬럼 값 대입 |  |  |  |
| AC-2fe2b1fc | SaveButton | DM0015_BOD.cs:967 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | DATA_OP | request.Parameters["p_eff_end_date"] | sEffEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-1695e40a | SaveButton | DM0015_BOD.cs:968 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | DATA_OP | request.Parameters["p_valid_yn"] | sActiveFlag | 행/컬럼 값 대입 |  |  |  |
| AC-784d0b47 | SaveButton | DM0015_BOD.cs:969 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-58bb4339 | SaveButton | DM0015_BOD.cs:971 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-48efdd2e | SaveButton | DM0015_BOD.cs:975 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-11fb1e9b | SaveButton | DM0015_BOD.cs:979 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-289de857 | SaveButton | DM0015_BOD.cs:991 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSub) == false) ▸ if (iCount > 0)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0015_BOD.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b407ad51 | this.spdMain.CellDoubleClick | DM0015_BOD.cs:1099 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1f321dd | this.spdMain.CellDoubleClick | DM0015_BOD.cs:1105 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44db34d8 | this.spdMain.CellDoubleClick | DM0015_BOD.cs:1106 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52646cd5 | this.spdMain.CellDoubleClick | DM0015_BOD.cs:1112 | if (siMain.IsLock(siMain.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0015_BOD.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-403b1f76 | this.spdMain.ComboSelChange | DM0015_BOD.cs:1237 | if (siMain.GetColumnTag(e.Column) == "DIVISION_ID"\|\| siMain.GetColumnTag(e.Column) == "END_CUSTOMER") ▸ if (dt.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27d79ea7 | this.spdMain.ComboSelChange | DM0015_BOD.cs:1238 | if (siMain.GetColumnTag(e.Column) == "DIVISION_ID"\|\| siMain.GetColumnTag(e.Column) == "END_CUSTOMER") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.EndCustomer), dt) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f36ce9b2 | this.spdMain.ComboSelChange | DM0015_BOD.cs:1255 | else of (siMain.GetColumnTag(e.Column) == "DIVISION_ID"\|\| siMain.GetColumnTag(e.Column) == "END_CUSTOMER") ▸ if (siMain.GetColumnTag(e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-639acb06 | this.spdMain.ComboSelChange | DM0015_BOD.cs:1257 | else of (siMain.GetColumnTag(e.Column) == "DIVISION_ID"\|\| siMain.GetColumnTag(e.Column) == "END_CUSTOMER") ▸ if (siMain.GetColumnTag(e.Col… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ToSite), dt) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0015_BOD.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ce5bead | this.spdMain.LeaveCell | DM0015_BOD.cs:1126 | if (e.Row != e.NewRow) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.NewRow | iRow | 속성 NewRow 설정 |  |  |  |

## DM0015_BOD.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4d17d22 | this.spdSub.CellDoubleClick | DM0015_BOD.cs:1269 | if (siSub.IsLock(siSub.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a6787a9 | this.spdSub.CellDoubleClick | DM0015_BOD.cs:1280 | if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.ItemId))) | POPUP | new SCM0002_ItembySitePopup | () | 팝업/폼 생성 |  |  |  |
| AC-24bb30a2 | this.spdSub.CellDoubleClick | DM0015_BOD.cs:1282 | if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.ItemId))) | POPUP | popItem.Form_Load | (false, sDivision, sScmSiteId, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-429b4957 | this.spdSub.CellDoubleClick | DM0015_BOD.cs:1283 | if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.ItemId))) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7e9570b1 | this.spdSub.CellDoubleClick | DM0015_BOD.cs:1284 | if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.ItemId))) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5bdfee01 | this.spdSub.CellDoubleClick | DM0015_BOD.cs:1288 | if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.ItemId))) ▸ if (popItem.ItemID != "" \|\| popItem.Ite… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ItemId), popItem.ItemID) | 그리드 값 설정 |  |  |  |


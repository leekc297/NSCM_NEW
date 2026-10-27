# AS-IS 액션 대조표 — GSCM_MESSAGEINFO

> 원천: `Doc/asisfacts/screens/GSCM_MESSAGEINFO/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 73행 · 메서드 10 · 종류 DATA_OP 30 · GRID_INIT 13 · ENDPOINT 5 · UI_PROP 4 · FLAG 3 · UI_MISC 3 · GRID_LOCK 3 · RETURN 3 · CALL_EXT 3 · MESSAGE 2 · GRID_BIND 1 · LIST_REBIND 1 · GRID_SET 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 3


## MessageInfo.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-685d7ab9 | this.Load | MessageInfo.cs:119 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fe801aeb | this.Load | MessageInfo.cs:120 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea2c92d1 | this.Load | MessageInfo.cs:121 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## MessageInfo.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a535221b | DeleteButton | MessageInfo.cs:158 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## MessageInfo.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f455869b | Dispose | MessageInfo.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## MessageInfo.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27d35b27 | EditButton | MessageInfo.cs:163 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-fb3d4fa9 | EditButton | MessageInfo.cs:164 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-cb452768 | EditButton | MessageInfo.cs:166 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MessageID), siMain.GetColumnIndex(DefColumns.MessageID),… | 그리드 편집 잠금/해제 |  |  |  |

## MessageInfo.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff623276 | FindButton 외 1 | MessageInfo.cs:194 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-694f04f2 | FindButton 외 1 | MessageInfo.cs:198 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetMessageInfoSearchList") ⇒ SystemManager.UP_FX_GetMessageInfoSearchList | 엔드포인트 요청 생성 |  |  |  |
| AC-ac39af2b | FindButton 외 1 | MessageInfo.cs:199 | lambda | DATA_OP | request.Parameters["MessageType"] | messageType | 행/컬럼 값 대입 |  |  |  |
| AC-08bb0f91 | FindButton 외 1 | MessageInfo.cs:200 | lambda | DATA_OP | request.Parameters["Search"] | search | 행/컬럼 값 대입 |  |  |  |
| AC-b56933e4 | FindButton 외 1 | MessageInfo.cs:201 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-34ea8e83 | FindButton 외 1 | MessageInfo.cs:203 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-69e0c661 | FindButton 외 1 | MessageInfo.cs:207 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8e3df522 | FindButton 외 1 | MessageInfo.cs:208 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9ad3d38b | FindButton 외 1 | MessageInfo.cs:211 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-13d61452 | FindButton 외 1 | MessageInfo.cs:214 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cb969549 | FindButton 외 1 | MessageInfo.cs:219 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-22551a14 | FindButton 외 1 | MessageInfo.cs:219 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0038bd99 | FindButton 외 1 | MessageInfo.cs:220 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## MessageInfo.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9599651 | this.Load | MessageInfo.cs:83 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## MessageInfo.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43fff623 | this.Load | MessageInfo.cs:114 |  | LIST_REBIND | cmbType.DataBind | (Data.Type.MessageType, true) ⇒ biz:CommonData.BaseCode [baseCode=0201000] | 목록 컨트롤 재구성 |  |  |  |

## MessageInfo.InitSpread

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01bbe778 | this.Load 외 2 | MessageInfo.cs:128 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-245fad69 | this.Load 외 2 | MessageInfo.cs:130 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9755dda5 | this.Load 외 2 | MessageInfo.cs:131 |  | GRID_INIT | siMain.AddTextColumn | ("MessageID*", DefColumns.MessageID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3981f688 | this.Load 외 2 | MessageInfo.cs:132 |  | GRID_INIT | siMain.AddTextColumn | ("Ko*", DefColumns.Ko, FPMerge.None, 250, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71ada7ce | this.Load 외 2 | MessageInfo.cs:133 |  | GRID_INIT | siMain.AddTextColumn | ("En*", DefColumns.En, FPMerge.None, 250, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7af6a917 | this.Load 외 2 | MessageInfo.cs:134 |  | GRID_INIT | siMain.AddTextColumn | ("Ch*", DefColumns.Ch, FPMerge.None, 250, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ee274c99 | this.Load 외 2 | MessageInfo.cs:135 |  | GRID_INIT | siMain.AddComboColumn | ("Type*", DefColumns.Type, FPMerge.None, 120, true, dtMessageType, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb2fbaae | this.Load 외 2 | MessageInfo.cs:136 |  | GRID_INIT | siMain.AddComboColumn | ("Button*", DefColumns.Button, FPMerge.None, 120, true, dtMessageButton, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ffc85671 | this.Load 외 2 | MessageInfo.cs:137 |  | GRID_INIT | siMain.AddComboColumn | ("UseYN*", DefColumns.UseYN, FPMerge.None, 80, true, dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a56aa38f | this.Load 외 2 | MessageInfo.cs:139 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MessageID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## MessageInfo.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0b92ccb | InsertButton | MessageInfo.cs:316 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e21e7d79 | InsertButton | MessageInfo.cs:319 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.MessageID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-2dbda73b | InsertButton | MessageInfo.cs:320 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.Ko, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef62a58e | InsertButton | MessageInfo.cs:321 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.En, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-04ed8210 | InsertButton | MessageInfo.cs:322 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.Ch, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea9db890 | InsertButton | MessageInfo.cs:323 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.Type, "0201001") | 데이터 객체 조작/조회 |  |  |  |
| AC-eb989de6 | InsertButton | MessageInfo.cs:324 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.Button, "0202001") | 데이터 객체 조작/조회 |  |  |  |
| AC-daa8c696 | InsertButton | MessageInfo.cs:325 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.UseYN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-7f2b10fd | InsertButton | MessageInfo.cs:327 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## MessageInfo.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac0e9a83 | SaveButton | MessageInfo.cs:230 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-975af4de | SaveButton | MessageInfo.cs:239 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e448941b | SaveButton | MessageInfo.cs:241 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-546a9caa | SaveButton | MessageInfo.cs:242 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.MessageID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MessageID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-58b08e20 | SaveButton | MessageInfo.cs:243 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Ko] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Ko)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9eb0ef5d | SaveButton | MessageInfo.cs:244 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.En] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.En)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c5a72657 | SaveButton | MessageInfo.cs:245 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Ch] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Ch)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0eb1276b | SaveButton | MessageInfo.cs:246 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Type] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Type)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3ebeb507 | SaveButton | MessageInfo.cs:247 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Button] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Button)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4aa6bb18 | SaveButton | MessageInfo.cs:248 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.UseYN] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.UseYN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-52f176fc | SaveButton | MessageInfo.cs:249 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6ccced28 | SaveButton | MessageInfo.cs:251 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a6f2cd5 | SaveButton | MessageInfo.cs:254 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-393fb50c | SaveButton | MessageInfo.cs:257 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.MessageID) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f6c3149 | SaveButton | MessageInfo.cs:258 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.Ko) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6a2a716 | SaveButton | MessageInfo.cs:259 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.En) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1bafb96 | SaveButton | MessageInfo.cs:260 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.Ch) | 데이터 객체 조작/조회 |  |  |  |
| AC-89bd82e5 | SaveButton | MessageInfo.cs:273 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8327cb4b | SaveButton | MessageInfo.cs:274 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92a04a66 | SaveButton | MessageInfo.cs:283 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-924d732c | SaveButton | MessageInfo.cs:284 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-929c4786 | SaveButton | MessageInfo.cs:285 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d01600dd | SaveButton | MessageInfo.cs:289 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.InsertQueryId | "SystemManager.UP_FX_SaveMessageInfo" | 속성 InsertQueryId 설정 |  |  |  |
| AC-08ce5427 | SaveButton | MessageInfo.cs:290 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DeleteQueryId | "SystemManager.UP_FX_DeleteMessageInfo" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-e7afa3e9 | SaveButton | MessageInfo.cs:291 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.UpdateQueryId | "SystemManager.UP_FX_SaveMessageInfo" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-0ff34f6b | SaveButton | MessageInfo.cs:292 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-76819d87 | SaveButton | MessageInfo.cs:292 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a5fe882 | SaveButton | MessageInfo.cs:296 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3fa42d91 | SaveButton | MessageInfo.cs:300 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5bdbbead | SaveButton | MessageInfo.cs:300 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-fd4ae355 | SaveButton | MessageInfo.cs:305 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |


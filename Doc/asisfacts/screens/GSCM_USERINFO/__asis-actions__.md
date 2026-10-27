# AS-IS 액션 대조표 — GSCM_USERINFO

> 원천: `Doc/asisfacts/screens/GSCM_USERINFO/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 201행 · 메서드 23 · 종류 DATA_OP 66 · GRID_INIT 41 · ENDPOINT 16 · RETURN 15 · UI_PROP 13 · GRID_LOCK 9 · GRID_SET 9 · MESSAGE 7 · CALL_EXT 7 · FLAG 4 · POPUP 4 · UI_MISC 3 · LIST_REBIND 2 · GRID_BIND 1 · VALUE_SET 1 · STATE_RESET 1 · VALIDATE 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 7


## UserInfo.CheckValidation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-138a27eb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | UserInfo.cs:550 | try ▸ if (spd.SpreadObject.DataSource == null) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-d6635584 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | UserInfo.cs:579 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (!string.IsNullOrWhiteSpace(sUserID)) ▸ if (sUserID == schkUserID) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1c4b2691 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | UserInfo.cs:580 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (!string.IsNullOrWhiteSpace(sUserID)) ▸ if (sUserID == schkUserID) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-273ff1e0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | UserInfo.cs:588 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-72aacd63 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | UserInfo.cs:590 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## UserInfo.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70d18527 | this.Load | UserInfo.cs:137 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-872a7193 | this.Load | UserInfo.cs:138 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-576d1788 | this.Load | UserInfo.cs:139 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## UserInfo.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fda18927 | DeleteButton | UserInfo.cs:209 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## UserInfo.DeleteFavorite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61847d5d | (진입점 미연결) | UserInfo.cs:64 |  | ENDPOINT | this.DbAccess.ExecuteQueryNonQuery | ("MenuContainer.UP_FX_DeleteFavorite", parameter) ⇒ MenuContainer.UP_FX_DeleteFavorite | 엔드포인트 호출 |  |  |  |

## UserInfo.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95a160cc | Dispose | UserInfo.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## UserInfo.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42bba824 | EditButton | UserInfo.cs:214 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-73704d6f | EditButton | UserInfo.cs:215 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-832482f1 | EditButton | UserInfo.cs:217 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.UserID), siMain.GetColumnIndex(DefColumns.UserName_E), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1fd195fd | EditButton | UserInfo.cs:218 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.Dept_ID), siMain.GetColumnIndex(DefColumns.Dept_Name), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d41f7d83 | EditButton | UserInfo.cs:219 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LastLoginDateTime), siMain.GetColumnIndex(DefColumns.Las… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3afedc9c | EditButton | UserInfo.cs:220 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.RegtUserID), siMain.GetColumnIndex(DefColumns.UpdateDate… | 그리드 편집 잠금/해제 |  |  |  |

## UserInfo.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b453ef1 | FindButton 외 1 | UserInfo.cs:256 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-10cfbfa3 | FindButton 외 1 | UserInfo.cs:260 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserInfoSearchList") ⇒ SystemManager.UP_FX_GetUserInfoSearchList | 엔드포인트 요청 생성 |  |  |  |
| AC-a73d3c10 | FindButton 외 1 | UserInfo.cs:261 | lambda | DATA_OP | request.Parameters["Search"] | search | 행/컬럼 값 대입 |  |  |  |
| AC-aa5d9c97 | FindButton 외 1 | UserInfo.cs:262 | lambda | DATA_OP | request.Parameters["DeptName"] | deptName | 행/컬럼 값 대입 |  |  |  |
| AC-4565ca0e | FindButton 외 1 | UserInfo.cs:263 | lambda | DATA_OP | request.Parameters["GroupID"] | group | 행/컬럼 값 대입 |  |  |  |
| AC-28aaefb7 | FindButton 외 1 | UserInfo.cs:264 | lambda | DATA_OP | request.Parameters["UseYN"] | useYN | 행/컬럼 값 대입 |  |  |  |
| AC-7538a57a | FindButton 외 1 | UserInfo.cs:266 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d8b76cd8 | FindButton 외 1 | UserInfo.cs:268 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f1dbe8c4 | FindButton 외 1 | UserInfo.cs:272 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-19341131 | FindButton 외 1 | UserInfo.cs:273 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a0c0c285 | FindButton 외 1 | UserInfo.cs:276 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6fb21f28 | FindButton 외 1 | UserInfo.cs:279 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-af3b1bd5 | FindButton 외 1 | UserInfo.cs:284 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-97318493 | FindButton 외 1 | UserInfo.cs:284 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1d8dada6 | FindButton 외 1 | UserInfo.cs:285 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## UserInfo.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7defac0 | this.Load | UserInfo.cs:112 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## UserInfo.GetSecurityACL

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2151455a | (진입점 미연결) | UserInfo.cs:48 |  | ENDPOINT | this.DbAccess.ExecuteQueryDataSet | ("MenuContainer.UP_FX_GetGSCMSecurityACL", parameter) ⇒ MenuContainer.UP_FX_GetGSCMSecurityACL | 엔드포인트 호출 |  |  |  |
| AC-8e12a6c9 | (진입점 미연결) | UserInfo.cs:49 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## UserInfo.GetUserAuthenctication

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0a11647 | (진입점 미연결) | UserInfo.cs:29 |  | ENDPOINT | this.DbAccess.CreateCommand | ("MenuContainer.UP_FX_GetGSCMUserAuthenctication", parameter) ⇒ MenuContainer.UP_FX_GetGSCMUserAuthenctication | 엔드포인트 호출 |  |  |  |
| AC-a7fc8393 | (진입점 미연결) | UserInfo.cs:30 |  | CALL_EXT | this.DbAccess.ExecuteCommandDataSet | (command) | ⚠ 의미 확인 필요 |  |  |  |
| AC-63238fa8 | (진입점 미연결) | UserInfo.cs:32 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## UserInfo.GetUserGuestAuthenctication

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40b52085 | (진입점 미연결) | UserInfo.cs:42 |  | ENDPOINT | this.DbAccess.ExecuteQueryDataSet | ("MenuContainer.UP_FX_GetGSCMGuestUserAuthenctication", parameter) ⇒ MenuContainer.UP_FX_GetGSCMGuestUserAuthenctication | 엔드포인트 호출 |  |  |  |
| AC-cf51329e | (진입점 미연결) | UserInfo.cs:43 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## UserInfo.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb22e0dd | this.Load | UserInfo.cs:129 |  | LIST_REBIND | cmbGroup.DataBind | (Data.Type.GroupID, true) ⇒ biz:CommonData.CommonDataList [code=GroupID] | 목록 컨트롤 재구성 |  |  |  |
| AC-13e04af5 | this.Load | UserInfo.cs:130 |  | LIST_REBIND | cmbUseYN.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-64af9b4a | this.Load | UserInfo.cs:132 |  | VALUE_SET | cmbUseYN.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |

## UserInfo.InitSpread

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b67731c8 | this.Load 외 2 | UserInfo.cs:146 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-75afcc2a | this.Load 외 2 | UserInfo.cs:148 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b0bd43b6 | this.Load 외 2 | UserInfo.cs:149 |  | GRID_INIT | siMain.AddTextColumn | ("UserID*", DefColumns.UserID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11f530fa | this.Load 외 2 | UserInfo.cs:150 |  | GRID_INIT | siMain.AddTextColumn | ("UserName*", DefColumns.UserName, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e4b9a3f8 | this.Load 외 2 | UserInfo.cs:151 |  | GRID_INIT | siMain.AddTextColumn | ("EnglishName", DefColumns.UserName_E, FPMerge.None, 130, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3e5fab9c | this.Load 외 2 | UserInfo.cs:152 |  | GRID_INIT | siMain.AddButtonColumn | ("Search", DefColumns.UserPopup, "...", FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2fd003b6 | this.Load 외 2 | UserInfo.cs:153 |  | GRID_INIT | siMain.AddTextColumn | ("Email", DefColumns.Email, FPMerge.None, 180, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-23dbea5c | this.Load 외 2 | UserInfo.cs:154 |  | GRID_INIT | siMain.AddTextColumn | ("TempDept_ID", DefColumns.TempDept_ID, FPMerge.None, 70, false, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b779b2e | this.Load 외 2 | UserInfo.cs:155 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_ID", DefColumns.Dept_ID, FPMerge.None, 70, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2a70f6e8 | this.Load 외 2 | UserInfo.cs:156 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_Name", DefColumns.Dept_Name, FPMerge.None, 230, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bcafe8b9 | this.Load 외 2 | UserInfo.cs:157 |  | GRID_INIT | siMain.AddButtonColumn | ("Search", DefColumns.DeptPopup, "...", FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d4d98642 | this.Load 외 2 | UserInfo.cs:158 |  | GRID_INIT | siMain.AddTextColumn | ("OfficePhoneNum", DefColumns.OfficePhoneNum, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc0b38d1 | this.Load 외 2 | UserInfo.cs:159 |  | GRID_INIT | siMain.AddTextColumn | ("CellPhoneNum", DefColumns.CellPhoneNum, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7419a61d | this.Load 외 2 | UserInfo.cs:160 |  | GRID_INIT | siMain.AddComboColumn | ("Language*", DefColumns.Language, FPMerge.None, 80, true, dtLanguage, FPHAlign.Center, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37531e50 | this.Load 외 2 | UserInfo.cs:161 |  | GRID_INIT | siMain.AddComboColumn | ("Default Group*", DefColumns.DefaultGroupID, FPMerge.None, 140, true, dtGroupID, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81631be5 | this.Load 외 2 | UserInfo.cs:162 |  | GRID_INIT | siMain.AddButtonColumn | ("Assign Group", DefColumns.MyGroupID, "View", FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae18cfce | this.Load 외 2 | UserInfo.cs:163 |  | GRID_INIT | siMain.AddComboColumn | ("Time Zone*", DefColumns.TimeZone, FPMerge.None, 120, true, dtTimeZone, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b5e7993 | this.Load 외 2 | UserInfo.cs:164 |  | GRID_INIT | siMain.AddDateTimeColumn | ("LastLogin", DefColumns.LastLoginDateTime, FPMerge.None, 170, true, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c2916e3 | this.Load 외 2 | UserInfo.cs:165 |  | GRID_INIT | siMain.AddComboColumn | ("PermanentYN", DefColumns.PermanentYN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4fc8707b | this.Load 외 2 | UserInfo.cs:166 |  | GRID_INIT | siMain.AddComboColumn | ("UseYN*", DefColumns.UseYN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf43a38e | this.Load 외 2 | UserInfo.cs:167 |  | GRID_INIT | siMain.AddTextColumn | ("Created By", DefColumns.RegtUserID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-136b6e92 | this.Load 외 2 | UserInfo.cs:168 |  | GRID_INIT | siMain.AddDateTimeColumn | ("Creation Date", DefColumns.RegtDateTime, FPMerge.None, 170, true, FPHAlign.Center, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-22ab923f | this.Load 외 2 | UserInfo.cs:169 |  | GRID_INIT | siMain.AddTextColumn | ("Updated By", DefColumns.UpdateUserID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f5ae90b8 | this.Load 외 2 | UserInfo.cs:170 |  | GRID_INIT | siMain.AddDateTimeColumn | ("Update Date ", DefColumns.UpdateDateTime, FPMerge.None, 170, true, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2b5fec7b | this.Load 외 2 | UserInfo.cs:171 |  | GRID_INIT | siMain.AddTextColumn | ("Attribute1", DefColumns.Attribute1, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6709e9e9 | this.Load 외 2 | UserInfo.cs:172 |  | GRID_INIT | siMain.AddTextColumn | ("Attribute2", DefColumns.Attribute2, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd857a05 | this.Load 외 2 | UserInfo.cs:173 |  | GRID_INIT | siMain.AddTextColumn | ("Attribute3", DefColumns.Attribute3, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-55dbe9a1 | this.Load 외 2 | UserInfo.cs:174 |  | GRID_INIT | siMain.AddTextColumn | ("Attribute4", DefColumns.Attribute4, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-021922a3 | this.Load 외 2 | UserInfo.cs:175 |  | GRID_INIT | siMain.AddTextColumn | ("Attribute5", DefColumns.Attribute5, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a30c517d | this.Load 외 2 | UserInfo.cs:176 |  | GRID_INIT | siMain.AddTextColumn | ("Attribute6", DefColumns.Attribute6, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff1d9095 | this.Load 외 2 | UserInfo.cs:177 |  | GRID_INIT | siMain.AddTextColumn | ("Attribute7", DefColumns.Attribute7, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-147be517 | this.Load 외 2 | UserInfo.cs:178 |  | GRID_INIT | siMain.AddTextColumn | ("Attribute8", DefColumns.Attribute8, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d2031489 | this.Load 외 2 | UserInfo.cs:179 |  | GRID_INIT | siMain.AddTextColumn | ("Attribute9", DefColumns.Attribute9, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63f22864 | this.Load 외 2 | UserInfo.cs:180 |  | GRID_INIT | siMain.AddTextColumn | ("Attribute10", DefColumns.Attribute10, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d4af7e7 | this.Load 외 2 | UserInfo.cs:182 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.Email)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-64bf3be1 | this.Load 외 2 | UserInfo.cs:183 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (siMain.GetColumnIndex(DefColumns.OfficePhoneNum), siMain.GetColumnIndex(DefColumns.Langua… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2dcfba68 | this.Load 외 2 | UserInfo.cs:184 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (siMain.GetColumnIndex(DefColumns.TimeZone), siMain.GetColumnIndex(DefColumns.Attribute10)… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9dddf45 | this.Load 외 2 | UserInfo.cs:186 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.UserID), 1, 4, 25, "User", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-812010bf | this.Load 외 2 | UserInfo.cs:187 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.Dept_ID), 1, 3, 25, "Dept", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d6f9529 | this.Load 외 2 | UserInfo.cs:188 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.DefaultGroupID), 1, 2, 25, "Group", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ffb19aa | this.Load 외 2 | UserInfo.cs:190 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.UserID) + 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## UserInfo.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e336134 | InsertButton | UserInfo.cs:431 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6d39a4c2 | InsertButton | UserInfo.cs:434 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Language, "KO") | 데이터 객체 조작/조회 |  |  |  |
| AC-6d1479cf | InsertButton | UserInfo.cs:435 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.TimeZone, "AS054") | 데이터 객체 조작/조회 |  |  |  |
| AC-d21dbe10 | InsertButton | UserInfo.cs:436 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.UseYN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-1dd55c33 | InsertButton | UserInfo.cs:438 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-99ff89a7 | InsertButton | UserInfo.cs:441 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.Dept_ID), siMain.GetColumnIndex(DefColumns.Dept… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7c03fc06 | InsertButton | UserInfo.cs:442 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LastLoginDateTime), siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5518445b | InsertButton | UserInfo.cs:443 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.RegtUserID), siMain.GetColumnIndex(DefColumns.U… | 그리드 편집 잠금/해제 |  |  |  |

## UserInfo.ResetSearchCondition

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de0b98b1 | (진입점 미연결) | UserInfo.cs:75 |  | ENDPOINT | this.DbAccess.ExecuteQueryNonQuery | ("MenuContainer.UP_FX_ResetSearchCondition", parameter) ⇒ MenuContainer.UP_FX_ResetSearchCondition | 엔드포인트 호출 |  |  |  |

## UserInfo.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ede907b9 | SaveButton | UserInfo.cs:295 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-30506448 | SaveButton | UserInfo.cs:298 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | FLAG | saveDS | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-8e2fd6e7 | SaveButton | UserInfo.cs:301 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-79fdf800 | SaveButton | UserInfo.cs:302 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.UserID) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a18294b | SaveButton | UserInfo.cs:303 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.UserName) | 데이터 객체 조작/조회 |  |  |  |
| AC-3408d922 | SaveButton | UserInfo.cs:304 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.UserName_E) | 데이터 객체 조작/조회 |  |  |  |
| AC-e830202d | SaveButton | UserInfo.cs:305 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.Email) | 데이터 객체 조작/조회 |  |  |  |
| AC-1aef60fa | SaveButton | UserInfo.cs:306 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.Dept_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-858031e9 | SaveButton | UserInfo.cs:307 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.DefaultGroupID) | 데이터 객체 조작/조회 |  |  |  |
| AC-d481f82e | SaveButton | UserInfo.cs:308 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.OfficePhoneNum) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d20eb25 | SaveButton | UserInfo.cs:309 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.CellPhoneNum) | 데이터 객체 조작/조회 |  |  |  |
| AC-4961b361 | SaveButton | UserInfo.cs:310 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.Language) | 데이터 객체 조작/조회 |  |  |  |
| AC-3460ff10 | SaveButton | UserInfo.cs:311 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.TimeZone) | 데이터 객체 조작/조회 |  |  |  |
| AC-8188fe8c | SaveButton | UserInfo.cs:312 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.PermanentYN) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba5e4874 | SaveButton | UserInfo.cs:313 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.UseYN) | 데이터 객체 조작/조회 |  |  |  |
| AC-4dd4a72d | SaveButton | UserInfo.cs:314 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.Attribute1) | 데이터 객체 조작/조회 |  |  |  |
| AC-f19d921d | SaveButton | UserInfo.cs:315 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.Attribute2) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d5b044a | SaveButton | UserInfo.cs:316 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.Attribute3) | 데이터 객체 조작/조회 |  |  |  |
| AC-607ac39c | SaveButton | UserInfo.cs:317 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.Attribute4) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc8bea0a | SaveButton | UserInfo.cs:318 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.Attribute5) | 데이터 객체 조작/조회 |  |  |  |
| AC-d39a3b6e | SaveButton | UserInfo.cs:319 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.Attribute6) | 데이터 객체 조작/조회 |  |  |  |
| AC-d85ab21a | SaveButton | UserInfo.cs:320 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.Attribute7) | 데이터 객체 조작/조회 |  |  |  |
| AC-3caa5d42 | SaveButton | UserInfo.cs:321 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.Attribute8) | 데이터 객체 조작/조회 |  |  |  |
| AC-fbfb7db2 | SaveButton | UserInfo.cs:322 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.Attribute9) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd4c080c | SaveButton | UserInfo.cs:323 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | (DefColumns.Attribute10) | 데이터 객체 조작/조회 |  |  |  |
| AC-91c84e0e | SaveButton | UserInfo.cs:324 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | dt.Columns.Add | ("RegtUserID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a222291 | SaveButton | UserInfo.cs:326 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (saveDS != null) | DATA_OP | saveDS.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-64bb982a | SaveButton | UserInfo.cs:329 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-0d799f38 | SaveButton | UserInfo.cs:329 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e53737d5 | SaveButton | UserInfo.cs:332 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!CheckValidation(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe955c63 | SaveButton | UserInfo.cs:341 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ea50f54f | SaveButton | UserInfo.cs:343 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-720dfdba | SaveButton | UserInfo.cs:344 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.UserID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.UserID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-17f877c7 | SaveButton | UserInfo.cs:345 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.UserName] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.UserName)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0f863df2 | SaveButton | UserInfo.cs:346 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.UserName_E] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.UserName_E)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fbf4cf44 | SaveButton | UserInfo.cs:347 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Email] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Email)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6212fd16 | SaveButton | UserInfo.cs:348 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Dept_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Dept_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6923439e | SaveButton | UserInfo.cs:349 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.DefaultGroupID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DefaultGroupID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9f142a78 | SaveButton | UserInfo.cs:350 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.OfficePhoneNum] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OfficePhoneNum)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fca11757 | SaveButton | UserInfo.cs:351 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.CellPhoneNum] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CellPhoneNum)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-15ec7070 | SaveButton | UserInfo.cs:352 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Language] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Language)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4b99c654 | SaveButton | UserInfo.cs:353 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.TimeZone] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.TimeZone)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4c993e67 | SaveButton | UserInfo.cs:354 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.PermanentYN] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PermanentYN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7888afd1 | SaveButton | UserInfo.cs:355 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.UseYN] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.UseYN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-943dd35b | SaveButton | UserInfo.cs:356 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Attribute1] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Attribute1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aff4e765 | SaveButton | UserInfo.cs:357 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Attribute2] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Attribute2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d42b6bd5 | SaveButton | UserInfo.cs:358 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Attribute3] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Attribute3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c09c829a | SaveButton | UserInfo.cs:359 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Attribute4] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Attribute4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8c5cc721 | SaveButton | UserInfo.cs:360 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Attribute5] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Attribute5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8973c615 | SaveButton | UserInfo.cs:361 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Attribute6] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Attribute6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-591efcae | SaveButton | UserInfo.cs:362 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Attribute7] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Attribute7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f2787008 | SaveButton | UserInfo.cs:363 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Attribute8] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Attribute8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-56cb7817 | SaveButton | UserInfo.cs:364 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Attribute9] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Attribute9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b1894eb | SaveButton | UserInfo.cs:365 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Attribute10] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Attribute10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0f62dc8c | SaveButton | UserInfo.cs:366 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4d702700 | SaveButton | UserInfo.cs:368 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ec5e48e | SaveButton | UserInfo.cs:371 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-43ffaea6 | SaveButton | UserInfo.cs:374 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.UserID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5c82e82 | SaveButton | UserInfo.cs:375 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.UserName) | 데이터 객체 조작/조회 |  |  |  |
| AC-af2ce5e6 | SaveButton | UserInfo.cs:386 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d734f0ca | SaveButton | UserInfo.cs:387 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba8da0f6 | SaveButton | UserInfo.cs:396 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e05ca25a | SaveButton | UserInfo.cs:397 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac3dd121 | SaveButton | UserInfo.cs:398 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in saveDS… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-214b85ed | SaveButton | UserInfo.cs:402 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.InsertQueryId | "SystemManager.UP_FX_SaveUserInfo" | 속성 InsertQueryId 설정 |  |  |  |
| AC-b057d730 | SaveButton | UserInfo.cs:403 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DeleteQueryId | "SystemManager.UP_FX_DeleteUserInfo" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-0876ce03 | SaveButton | UserInfo.cs:404 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.UpdateQueryId | "SystemManager.UP_FX_SaveUserInfo" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-7fd70f09 | SaveButton | UserInfo.cs:405 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-ef90cb9f | SaveButton | UserInfo.cs:405 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-85135102 | SaveButton | UserInfo.cs:409 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fb650d82 | SaveButton | UserInfo.cs:413 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0343b867 | SaveButton | UserInfo.cs:413 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-a361d471 | SaveButton | UserInfo.cs:418 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## UserInfo.SaveFavorite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb741305 | (진입점 미연결) | UserInfo.cs:59 |  | ENDPOINT | this.DbAccess.ExecuteQueryNonQuery | ("MenuContainer.UP_FX_SaveFavorite", parameter) ⇒ MenuContainer.UP_FX_SaveFavorite | 엔드포인트 호출 |  |  |  |

## UserInfo.SaveMenuConnect

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db10b40a | (진입점 미연결) | UserInfo.cs:91 |  | ENDPOINT | this.DbAccess.ExecuteQueryNonQuery | ("MenuContainer.UP_FX_SaveMenuConnect", parameter) ⇒ MenuContainer.UP_FX_SaveMenuConnect | 엔드포인트 호출 |  |  |  |

## UserInfo.SaveNoticeConfirm

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adf226f6 | (진입점 미연결) | UserInfo.cs:81 |  | ENDPOINT | this.DbAccess.ExecuteQueryNonQuery | ("SCM.SCM_ADM_SAVE_NOTICE_CONFIRM", parameter) ⇒ SCM.SCM_ADM_SAVE_NOTICE_CONFIRM | 엔드포인트 호출 |  |  |  |

## UserInfo.SavePersonalSetting

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7cb19d6 | (진입점 미연결) | UserInfo.cs:54 |  | ENDPOINT | this.DbAccess.ExecuteQueryNonQuery | ("SystemManager.UP_FX_SavePersonalSetting", parameter) ⇒ SystemManager.UP_FX_SavePersonalSetting | 엔드포인트 호출 |  |  |  |

## UserInfo.SaveSearchCondition

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4602a406 | (진입점 미연결) | UserInfo.cs:69 |  | ENDPOINT | this.DbAccess.ExecuteQueryNonQuery | ("MenuContainer.UP_FX_SaveSearchCondition", parameter) ⇒ MenuContainer.UP_FX_SaveSearchCondition | 엔드포인트 호출 |  |  |  |

## UserInfo.SaveUserConnect

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d47d2a7 | (진입점 미연결) | UserInfo.cs:86 |  | ENDPOINT | this.DbAccess.ExecuteQueryNonQuery | ("MenuContainer.UP_FX_SaveUserConnect", parameter) ⇒ MenuContainer.UP_FX_SaveUserConnect | 엔드포인트 호출 |  |  |  |

## UserInfo.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8494f428 | this.spdMain.CellClick | UserInfo.cs:455 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5af8bfd1 | this.spdMain.CellClick | UserInfo.cs:466 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) ▸ if (strin… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Language") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cc5da29b | this.spdMain.CellClick | UserInfo.cs:467 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) ▸ if (strin… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09f26e33 | this.spdMain.CellClick | UserInfo.cs:470 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-039e5873 | this.spdMain.CellClick | UserInfo.cs:472 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-3ed4a4b6 | this.spdMain.CellClick | UserInfo.cs:473 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-953fbe94 | this.spdMain.CellClick | UserInfo.cs:474 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3eab295e | this.spdMain.CellClick | UserInfo.cs:475 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) | UI_PROP | popup.SSOUserYN | true | 속성 SSOUserYN 설정 |  |  |  |
| AC-c80fcae6 | this.spdMain.CellClick | UserInfo.cs:476 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) | UI_PROP | popup.Language | language | 속성 Language 설정 |  |  |  |
| AC-7dae0448 | this.spdMain.CellClick | UserInfo.cs:478 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d016fda7 | this.spdMain.CellClick | UserInfo.cs:484 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.UserID), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-c4af156a | this.spdMain.CellClick | UserInfo.cs:485 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.UserName), item.UserName) | 그리드 값 설정 |  |  |  |
| AC-b38c5ee7 | this.spdMain.CellClick | UserInfo.cs:486 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.UserName_E), item.UserName_E) | 그리드 값 설정 |  |  |  |
| AC-991fe5f6 | this.spdMain.CellClick | UserInfo.cs:487 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.Dept_ID), item.Dept_ID) | 그리드 값 설정 |  |  |  |
| AC-84bc95d9 | this.spdMain.CellClick | UserInfo.cs:488 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.UserPopup)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.Dept_Name), item.Dept_Name) | 그리드 값 설정 |  |  |  |
| AC-cc6cde58 | this.spdMain.CellClick | UserInfo.cs:501 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptPopup)) ▸ if (strin… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Language") } ) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4ec85b4d | this.spdMain.CellClick | UserInfo.cs:502 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptPopup)) ▸ if (strin… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-155d8e8c | this.spdMain.CellClick | UserInfo.cs:505 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptPopup)) | POPUP | new DeptPopup | () | 팝업/폼 생성 |  |  |  |
| AC-286229b5 | this.spdMain.CellClick | UserInfo.cs:508 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptPopup)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-104cadbd | this.spdMain.CellClick | UserInfo.cs:509 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptPopup)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-cbb7a557 | this.spdMain.CellClick | UserInfo.cs:510 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptPopup)) | UI_PROP | popup.Language | language | 속성 Language 설정 |  |  |  |
| AC-c41de73a | this.spdMain.CellClick | UserInfo.cs:511 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptPopup)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-14e00e9b | this.spdMain.CellClick | UserInfo.cs:513 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptPopup)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4113c36a | this.spdMain.CellClick | UserInfo.cs:515 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptPopup)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TempDept_ID), popup.Code) | 그리드 값 설정 |  |  |  |
| AC-bb850df6 | this.spdMain.CellClick | UserInfo.cs:516 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptPopup)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.Dept_ID), popup.Code) | 그리드 값 설정 |  |  |  |
| AC-03357163 | this.spdMain.CellClick | UserInfo.cs:517 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptPopup)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.Dept_Name), popup.Name) | 그리드 값 설정 |  |  |  |
| AC-e5e9b606 | this.spdMain.CellClick | UserInfo.cs:527 | if (e.Column == siMain.GetColumnIndex(DefColumns.MyGroupID)) | COMBO_DATA | Data.Common | (Data.Type.MyGroupIDALL, false, userID, string.Empty) ⇒ biz:CommonData.CommonDataList [code=MyGroupIDALL] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b0e029d2 | this.spdMain.CellClick | UserInfo.cs:536 | if (e.Column == siMain.GetColumnIndex(DefColumns.MyGroupID)) ▸ if (dt.Rows.Count > 0) | MESSAGE | MessageBox.Show | (myGroup, "Assign Group") | 메시지 표시 |  |  |  |
| AC-6e8fddcd | this.spdMain.CellClick | UserInfo.cs:540 | if (e.Column == siMain.GetColumnIndex(DefColumns.MyGroupID)) ▸ else of (dt.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |


# AS-IS 액션 대조표 — SCM0008

> 원천: `Doc/asisfacts/screens/SCM0008/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 225행 · 메서드 28 · 종류 DATA_OP 52 · UI_PROP 35 · GRID_INIT 32 · ENDPOINT 22 · RETURN 19 · GRID_SET 11 · CALL_EXT 10 · VALUE_SET 9 · FLAG 8 · GRID_LOCK 6 · MESSAGE 5 · STATE 5 · GRID_BIND 4 · UI_MISC 2 · COMBO_DATA 2 · LIST_REBIND 2 · GRID_STYLE 1 · ⚠ 의미 확인 필요 10


## SCM0008_Auth_Request.AddBlankRow

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0368bb54 | this.Load | SCM0008_Auth_Request.cs:167 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4ffb8510 | this.Load | SCM0008_Auth_Request.cs:168 |  | DATA_OP | dr[0] | " " | 행/컬럼 값 대입 |  |  |  |
| AC-508f6a9d | this.Load | SCM0008_Auth_Request.cs:169 |  | DATA_OP | dr[1] | " " | 행/컬럼 값 대입 |  |  |  |
| AC-2f99f993 | this.Load | SCM0008_Auth_Request.cs:170 |  | CALL_EXT | dt.Rows.InsertAt | (dr, 0) | ⚠ 의미 확인 필요 |  |  |  |

## SCM0008_Auth_Request.AddMyAuthList

진입점: this.btnAdd.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7b9335f | this.btnAdd.Click | SCM0008_Auth_Request.cs:700 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_SaveReqAuthAddMyList") ⇒ SystemManager.UP_FX_SaveReqAuthAddMyList | 엔드포인트 요청 생성 |  |  |  |
| AC-5a25c7a9 | this.btnAdd.Click | SCM0008_Auth_Request.cs:702 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-57c2a22e | this.btnAdd.Click | SCM0008_Auth_Request.cs:706 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f33ee9d3 | this.btnAdd.Click | SCM0008_Auth_Request.cs:707 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_User_ID"] | p_User_ID | 행/컬럼 값 대입 |  |  |  |
| AC-083c3515 | this.btnAdd.Click | SCM0008_Auth_Request.cs:708 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_Group_ID"] | p_Group_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f8cb21d7 | this.btnAdd.Click | SCM0008_Auth_Request.cs:709 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_Division_ID"] | p_Division_ID | 행/컬럼 값 대입 |  |  |  |
| AC-757b5814 | this.btnAdd.Click | SCM0008_Auth_Request.cs:710 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_Plant_ID"] | p_Plant_ID | 행/컬럼 값 대입 |  |  |  |
| AC-3fd0e522 | this.btnAdd.Click | SCM0008_Auth_Request.cs:711 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_Customer_Code"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f54a57a9 | this.btnAdd.Click | SCM0008_Auth_Request.cs:712 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_Approval_Result"] | p_Approval_Result | 행/컬럼 값 대입 |  |  |  |
| AC-660cc96e | this.btnAdd.Click | SCM0008_Auth_Request.cs:713 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_Created_By"] | p_Created_By | 행/컬럼 값 대입 |  |  |  |
| AC-1b1ef0a5 | this.btnAdd.Click | SCM0008_Auth_Request.cs:714 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_Last_Updated_By"] | p_Last_Updated_By | 행/컬럼 값 대입 |  |  |  |
| AC-08ef0a6a | this.btnAdd.Click | SCM0008_Auth_Request.cs:716 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-317e5e21 | this.btnAdd.Click | SCM0008_Auth_Request.cs:716 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |

## SCM0008_Auth_Request.BtnAdd_Click

진입점: this.btnAdd.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ef75742 | this.btnAdd.Click | SCM0008_Auth_Request.cs:588 | if (InterlockTotalMiss("ADD")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCM0008_Auth_Request.BtnAuthRemove_Click

진입점: this.btnAuthDelete.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37936b63 | this.btnAuthDelete.Click | SCM0008_Auth_Request.cs:394 | if (InterlockTotalMiss("REM")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCM0008_Auth_Request.BtnRequest_Click

진입점: this.btnRequest.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-467c8126 | this.btnRequest.Click | SCM0008_Auth_Request.cs:455 | if (InterlockTotalMiss("REQ")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d158c976 | this.btnRequest.Click | SCM0008_Auth_Request.cs:462 | if (message.ToString() != string.Empty) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fe6ee6b4 | this.btnRequest.Click | SCM0008_Auth_Request.cs:463 | if (message.ToString() != string.Empty) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCM0008_Auth_Request.ChangeAllCheckboxes

진입점: this.Load / this.spdMyAuthList.CellClick / this.btnAdd.Click [if (iCount > 0) ▸ try ▸ if (tran.Success)] / this.btnAuthDelete.Click / this.btnRequest.Click [if (tran.Success)] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-610fe2a3 | this.Load 외 6 | SCM0008_Auth_Request.cs:377 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("chk")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.IsLockCell | (i, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ffa49b5 | this.Load 외 6 | SCM0008_Auth_Request.cs:385 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("chk")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.IsLockCell | (i, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-056a3acd | this.Load 외 6 | SCM0008_Auth_Request.cs:386 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("chk")) ▸ for (i <= spread.GetMaxRowIndex()) ▸ if (!spread.IsLockCell(… | GRID_SET | spread.SetText | (i, 0, AllCheck.ToString()) | 그리드 값 설정 |  |  |  |

## SCM0008_Auth_Request.CheckIsNormalUser

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e3bf930 | (진입점 미연결) | SCM0008_Auth_Request.cs:1119 | if (_userinfo.UserID != null) ▸ if (_userinfo.Dept_ID == null \|\| _userinfo.Dept_ID.Length <= 0) | FLAG | this.IsAuthUser | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5f55b3a8 | (진입점 미연결) | SCM0008_Auth_Request.cs:1121 | if (_userinfo.UserID != null) ▸ if (_userinfo.Dept_ID == null \|\| _userinfo.Dept_ID.Length <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00154", new object[] { "PI" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1de1622 | (진입점 미연결) | SCM0008_Auth_Request.cs:1122 | if (_userinfo.UserID != null) ▸ if (_userinfo.Dept_ID == null \|\| _userinfo.Dept_ID.Length <= 0) | STATE | this.btnAdd.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4658310e | (진입점 미연결) | SCM0008_Auth_Request.cs:1123 | if (_userinfo.UserID != null) ▸ if (_userinfo.Dept_ID == null \|\| _userinfo.Dept_ID.Length <= 0) | STATE | this.btnAuthDelete.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-222a62dc | (진입점 미연결) | SCM0008_Auth_Request.cs:1124 | if (_userinfo.UserID != null) ▸ if (_userinfo.Dept_ID == null \|\| _userinfo.Dept_ID.Length <= 0) | STATE | this.btnRequest.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCM0008_Auth_Request.CheckUserinfoInput

진입점: this.btnRequest.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1962d2ea | this.btnRequest.Click | SCM0008_Auth_Request.cs:581 | if (sb.Length > 0) | RETURN | return sb.ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-fa229008 | this.btnRequest.Click | SCM0008_Auth_Request.cs:583 |  | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## SCM0008_Auth_Request.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f434106 | this.Load | SCM0008_Auth_Request.cs:212 |  | GRID_INIT | AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d8f3fc7b | this.Load | SCM0008_Auth_Request.cs:213 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ab014a90 | this.Load | SCM0008_Auth_Request.cs:216 |  | GRID_INIT | AddSheet | (spdDivision, SpdSheet.shtDivision , SpdSheet.shtDivision, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a338e0ab | this.Load | SCM0008_Auth_Request.cs:217 |  | FLAG | siDivision | GetSheetInfo(spdDivision.Name, spdDivision.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d911cf5e | this.Load | SCM0008_Auth_Request.cs:228 |  | GRID_INIT | AddSheet | (spdMyAuthList, SpdSheet.shtMyAuthList, SpdSheet.shtMyAuthList, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b7315ea3 | this.Load | SCM0008_Auth_Request.cs:229 |  | FLAG | siMyAuthList | GetSheetInfo(spdMyAuthList.Name, spdMyAuthList.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-869207bc | this.Load | SCM0008_Auth_Request.cs:232 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0008_Auth_Request.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4015f0e | this.Load | SCM0008_Auth_Request.cs:187 | else of (CurUserID == null) | UI_PROP | _userinfo.UserID | CurUserID | 속성 UserID 설정 |  |  |  |
| AC-3b502d7a | this.Load | SCM0008_Auth_Request.cs:188 | else of (CurUserID == null) | UI_PROP | _userinfo.UserName | UserInfoContext.Current["NewUserName"] | 속성 UserName 설정 |  |  |  |
| AC-a674e131 | this.Load | SCM0008_Auth_Request.cs:191 | else of (CurUserID == null) ▸ if (UserInfoContext.Current["NewUserNameE"] == null) | UI_PROP | _userinfo.UserNameE | UserInfoContext.Current["NewUserName"] | 속성 UserNameE 설정 |  |  |  |
| AC-660e6123 | this.Load | SCM0008_Auth_Request.cs:193 | else of (CurUserID == null) ▸ else of (UserInfoContext.Current["NewUserNameE"] == null) | UI_PROP | _userinfo.UserNameE | UserInfoContext.Current["NewUserNameE"] | 속성 UserNameE 설정 |  |  |  |
| AC-6a110591 | this.Load | SCM0008_Auth_Request.cs:196 | else of (CurUserID == null) | UI_PROP | _userinfo.Email | CurUserID + @"@lgensol.com" | 속성 Email 설정 |  |  |  |
| AC-af5bc4f1 | this.Load | SCM0008_Auth_Request.cs:197 | else of (CurUserID == null) | UI_PROP | _userinfo.Dept_ID | UserInfoContext.Current["NewDeptID"] | 속성 Dept_ID 설정 |  |  |  |
| AC-5ecb7bdb | this.Load | SCM0008_Auth_Request.cs:198 | else of (CurUserID == null) | UI_PROP | _userinfo.Dept_NameK | UserInfoContext.Current["NewDeptNameK"] | 속성 Dept_NameK 설정 |  |  |  |
| AC-562f3609 | this.Load | SCM0008_Auth_Request.cs:199 | else of (CurUserID == null) | UI_PROP | _userinfo.Dept_NameE | UserInfoContext.Current["NewDeptNameE"] | 속성 Dept_NameE 설정 |  |  |  |
| AC-0c17ca93 | this.Load | SCM0008_Auth_Request.cs:200 | else of (CurUserID == null) | UI_PROP | _userinfo.Dept_NameC | UserInfoContext.Current["NewDeptNameC"] | 속성 Dept_NameC 설정 |  |  |  |
| AC-2b76ed8b | this.Load | SCM0008_Auth_Request.cs:201 | else of (CurUserID == null) | UI_PROP | _userinfo.UserExistYN | UserInfoContext.Current["NewUserExistYN"] | 속성 UserExistYN 설정 |  |  |  |
| AC-7cc24cfa | this.Load | SCM0008_Auth_Request.cs:202 | else of (CurUserID == null) | UI_PROP | _userinfo.Default_Grp_ID | "Guest" | 속성 Default_Grp_ID 설정 |  |  |  |
| AC-8211af38 | this.Load | SCM0008_Auth_Request.cs:203 | else of (CurUserID == null) | UI_PROP | _userinfo.Language | "EN" | 속성 Language 설정 |  |  |  |
| AC-21125961 | this.Load | SCM0008_Auth_Request.cs:204 | else of (CurUserID == null) | UI_PROP | _userinfo.IsNewUser | "Y" | 속성 IsNewUser 설정 |  |  |  |

## SCM0008_Auth_Request.DelMyAuthList

진입점: this.btnAuthDelete.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6a6d95c | this.btnAuthDelete.Click | SCM0008_Auth_Request.cs:412 | for (p <= siMyAuthList.GetMaxRowIndex()) | CALL_EXT | siMyAuthList.IsLockCell | (p, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0921a767 | this.btnAuthDelete.Click | SCM0008_Auth_Request.cs:423 |  | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_DeleteReqAuthAddedMyList") ⇒ SystemManager.UP_FX_DeleteReqAuthAddedMyList | 엔드포인트 요청 생성 |  |  |  |
| AC-bca49367 | this.btnAuthDelete.Click | SCM0008_Auth_Request.cs:425 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-96cbe221 | this.btnAuthDelete.Click | SCM0008_Auth_Request.cs:427 | lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d2b35003 | this.btnAuthDelete.Click | SCM0008_Auth_Request.cs:428 | lambda | DATA_OP | req.Parameters["p_User_ID"] | p_User_ID | 행/컬럼 값 대입 |  |  |  |
| AC-dab1a7fa | this.btnAuthDelete.Click | SCM0008_Auth_Request.cs:429 | lambda | DATA_OP | req.Parameters["p_Group_ID"] | p_Group_ID | 행/컬럼 값 대입 |  |  |  |
| AC-3f52fd40 | this.btnAuthDelete.Click | SCM0008_Auth_Request.cs:430 | lambda | DATA_OP | req.Parameters["p_Division_ID"] | p_Division_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f8fbc3f2 | this.btnAuthDelete.Click | SCM0008_Auth_Request.cs:431 | lambda | DATA_OP | req.Parameters["p_Plant_ID"] | p_Plant_ID | 행/컬럼 값 대입 |  |  |  |
| AC-faa48428 | this.btnAuthDelete.Click | SCM0008_Auth_Request.cs:432 | lambda | DATA_OP | req.Parameters["p_Customer_Code"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-803d7ca8 | this.btnAuthDelete.Click | SCM0008_Auth_Request.cs:433 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-24ef8e59 | this.btnAuthDelete.Click | SCM0008_Auth_Request.cs:433 | lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-8e552b66 | this.btnAuthDelete.Click | SCM0008_Auth_Request.cs:438 | if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00031") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCM0008_Auth_Request.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a68b33c | Dispose | SCM0008_Auth_Request.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0008_Auth_Request.FindData

진입점: this.Load / this.btnAuthDelete.Click / this.btnRequest.Click [if (tran.Success)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4aa6c401 | this.Load 외 3 | SCM0008_Auth_Request.cs:842 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a9d54cd2 | this.Load 외 3 | SCM0008_Auth_Request.cs:845 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetReqAuthGroupInfo") ⇒ SystemManager.UP_FX_GetReqAuthGroupInfo | 엔드포인트 요청 생성 |  |  |  |
| AC-0b5a7a6a | this.Load 외 3 | SCM0008_Auth_Request.cs:846 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5d9bc44e | this.Load 외 3 | SCM0008_Auth_Request.cs:848 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3604f54a | this.Load 외 3 | SCM0008_Auth_Request.cs:854 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c25ec5b3 | this.Load 외 3 | SCM0008_Auth_Request.cs:855 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3ba3a309 | this.Load 외 3 | SCM0008_Auth_Request.cs:858 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c4b416ae | this.Load 외 3 | SCM0008_Auth_Request.cs:866 |  | GRID_SET | spdMain.ActiveSheet.ActiveRowIndex | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-382237b6 | this.Load 외 3 | SCM0008_Auth_Request.cs:867 |  | GRID_SET | spdDivision.ActiveSheet.ActiveRowIndex | 0 | 그리드 속성/값 설정 |  |  |  |

## SCM0008_Auth_Request.FindData_Division

진입점: this.Load / this.btnAuthDelete.Click / this.btnRequest.Click [if (tran.Success)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cb68167 | this.Load 외 3 | SCM0008_Auth_Request.cs:942 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7bf3632a | this.Load 외 3 | SCM0008_Auth_Request.cs:944 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetNewUserAuthRequestList") ⇒ SystemManager.UP_FX_GetNewUserAuthRequestList | 엔드포인트 요청 생성 |  |  |  |
| AC-3be4dc88 | this.Load 외 3 | SCM0008_Auth_Request.cs:945 | lambda | DATA_OP | request.Parameters["GroupID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-abfaab16 | this.Load 외 3 | SCM0008_Auth_Request.cs:946 | lambda | DATA_OP | request.Parameters["UserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4329cb36 | this.Load 외 3 | SCM0008_Auth_Request.cs:947 | lambda | DATA_OP | request.Parameters["AuthType"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-62239122 | this.Load 외 3 | SCM0008_Auth_Request.cs:948 | lambda | DATA_OP | request.Parameters["DivisionID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-bff520e8 | this.Load 외 3 | SCM0008_Auth_Request.cs:949 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a35955f | this.Load 외 3 | SCM0008_Auth_Request.cs:951 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-bf977733 | this.Load 외 3 | SCM0008_Auth_Request.cs:955 |  | GRID_BIND | siDivision.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-376ecaf7 | this.Load 외 3 | SCM0008_Auth_Request.cs:956 |  | GRID_LOCK | siDivision.SetLockFlag | (SpdSheet.shtDivision, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-beedbd36 | this.Load 외 3 | SCM0008_Auth_Request.cs:957 |  | GRID_LOCK | siDivision.LockColumn | (1, siDivision.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCM0008_Auth_Request.FindData_MyAddedAuthList

진입점: this.Load / this.btnAdd.Click [if (iCount > 0) ▸ try ▸ if (tran.Success)] / this.btnAuthDelete.Click / this.btnRequest.Click [if (tran.Success)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ae40ce2 | this.Load 외 4 | SCM0008_Auth_Request.cs:884 | if (_userinfo.UserID == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00eb7b33 | this.Load 외 4 | SCM0008_Auth_Request.cs:893 |  | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetReqAuthMyListAdded") ⇒ SystemManager.UP_FX_GetReqAuthMyListAdded | 엔드포인트 요청 생성 |  |  |  |
| AC-e3e093b7 | this.Load 외 4 | SCM0008_Auth_Request.cs:894 |  | DATA_OP | request.Parameters["p_UserID"] | p_UserID | 행/컬럼 값 대입 |  |  |  |
| AC-7ace307e | this.Load 외 4 | SCM0008_Auth_Request.cs:896 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a9925162 | this.Load 외 4 | SCM0008_Auth_Request.cs:902 |  | FLAG | dtMyAuthList | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-80a036d1 | this.Load 외 4 | SCM0008_Auth_Request.cs:904 |  | GRID_BIND | siMyAuthList.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4857e434 | this.Load 외 4 | SCM0008_Auth_Request.cs:905 |  | GRID_INIT | siMyAuthList.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5c5af0d5 | this.Load 외 4 | SCM0008_Auth_Request.cs:917 | for (i <= siMyAuthList.GetMaxRowIndex()) ▸ if (!result.Equals("REQUESTING") && result.Length > 0) ▸ if (result.Equals("REJECT")) | GRID_SET | siMyAuthList.SetText | (i, siMyAuthList.GetColumnIndex(DefMyAuthList.CHK), "false") | 그리드 값 설정 |  |  |  |
| AC-5aae7fc4 | this.Load 외 4 | SCM0008_Auth_Request.cs:921 | for (i <= siMyAuthList.GetMaxRowIndex()) ▸ if (!result.Equals("REQUESTING") && result.Length > 0) ▸ else of (result.Equals("REJECT")) | GRID_SET | siMyAuthList.SetText | (i, siMyAuthList.GetColumnIndex(DefMyAuthList.CHK), "True") | 그리드 값 설정 |  |  |  |
| AC-f8105312 | this.Load 외 4 | SCM0008_Auth_Request.cs:922 | for (i <= siMyAuthList.GetMaxRowIndex()) ▸ if (!result.Equals("REQUESTING") && result.Length > 0) ▸ else of (result.Equals("REJECT")) | GRID_LOCK | siMyAuthList.LockRange | (i, 0, i, siMyAuthList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCM0008_Auth_Request.FindData_Plant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c8fe83d | (진입점 미연결) | SCM0008_Auth_Request.cs:969 |  | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetNewUserAuthRequestList") ⇒ SystemManager.UP_FX_GetNewUserAuthRequestList | 엔드포인트 요청 생성 |  |  |  |
| AC-7b022f2d | (진입점 미연결) | SCM0008_Auth_Request.cs:970 |  | DATA_OP | request.Parameters["GroupID"] | groupId | 행/컬럼 값 대입 |  |  |  |
| AC-927cfd0d | (진입점 미연결) | SCM0008_Auth_Request.cs:971 |  | DATA_OP | request.Parameters["UserID"] | userId | 행/컬럼 값 대입 |  |  |  |
| AC-f4c104e8 | (진입점 미연결) | SCM0008_Auth_Request.cs:972 |  | DATA_OP | request.Parameters["AuthType"] | "P" | 행/컬럼 값 대입 |  |  |  |
| AC-79dc0112 | (진입점 미연결) | SCM0008_Auth_Request.cs:973 |  | DATA_OP | request.Parameters["DivisionID"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-6884c4e6 | (진입점 미연결) | SCM0008_Auth_Request.cs:974 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ebfccb8d | (진입점 미연결) | SCM0008_Auth_Request.cs:979 |  | GRID_BIND | siPlant.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-06560b40 | (진입점 미연결) | SCM0008_Auth_Request.cs:980 |  | GRID_LOCK | siPlant.LockColumn | (1, siPlant.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCM0008_Auth_Request.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f95a979 | this.Load | SCM0008_Auth_Request.cs:143 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0008_Auth_Request.GetInsertedUserInfo

진입점: this.Load [if (CurUserID == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de2d1855 | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:799 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-465fbcee | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:802 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetReqAuthCurrentUser") ⇒ SystemManager.UP_FX_GetReqAuthCurrentUser | 엔드포인트 요청 생성 |  |  |  |
| AC-1a4da3d6 | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:803 | lambda | DATA_OP | req.Parameters["p_UserID"] | User_ID | 행/컬럼 값 대입 |  |  |  |
| AC-ff8b3417 | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:805 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1c1883db | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:806 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e5bec7e0 | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:810 |  | CALL_EXT | Thread.Sleep | (2000) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae4feb8c | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:814 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.UserID | ds.Tables[0].Rows[0]["USERID"].ToString() | 속성 UserID 설정 |  |  |  |
| AC-095334b8 | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:815 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.UserName | ds.Tables[0].Rows[0]["USERNAME"].ToString() | 속성 UserName 설정 |  |  |  |
| AC-a3425018 | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:817 | if (ds.Tables[0].Rows.Count >= 0) ▸ if (ds.Tables[0].Rows[0]["USERNAME_E"].ToString() == "") | UI_PROP | _userinfo.UserNameE | ds.Tables[0].Rows[0]["USERNAME"].ToString() | 속성 UserNameE 설정 |  |  |  |
| AC-6d21172e | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:819 | if (ds.Tables[0].Rows.Count >= 0) ▸ else of (ds.Tables[0].Rows[0]["USERNAME_E"].ToString() == "") | UI_PROP | _userinfo.UserNameE | ds.Tables[0].Rows[0]["USERNAME_E"].ToString() | 속성 UserNameE 설정 |  |  |  |
| AC-44f2aa27 | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:821 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Email | ds.Tables[0].Rows[0]["EMAIL"].ToString() | 속성 Email 설정 |  |  |  |
| AC-dad3570a | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:822 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Dept_ID | ds.Tables[0].Rows[0]["DEPT_ID"].ToString() | 속성 Dept_ID 설정 |  |  |  |
| AC-f48606c3 | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:823 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.CellPhoneNum | ds.Tables[0].Rows[0]["CELLPHONENUM"].ToString() | 속성 CellPhoneNum 설정 |  |  |  |
| AC-5997932e | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:824 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Language | ds.Tables[0].Rows[0]["LANGUAGE"].ToString() | 속성 Language 설정 |  |  |  |
| AC-d52d9fc7 | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:825 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Default_Grp_ID | ds.Tables[0].Rows[0]["DEFAULTGROUPID"].ToString() | 속성 Default_Grp_ID 설정 |  |  |  |
| AC-2afe8833 | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:826 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.TimeZone | ds.Tables[0].Rows[0]["TIMEZONE"].ToString() | 속성 TimeZone 설정 |  |  |  |
| AC-bc205da0 | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:827 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Dept_NameK | ds.Tables[0].Rows[0]["DEPT_NAME_KO"].ToString() | 속성 Dept_NameK 설정 |  |  |  |
| AC-d11fdd1a | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:828 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Dept_NameE | ds.Tables[0].Rows[0]["DEPT_NAME_EN"].ToString() | 속성 Dept_NameE 설정 |  |  |  |
| AC-38660b71 | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:829 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Dept_NameC | ds.Tables[0].Rows[0]["DEPT_NAME_CN"].ToString() | 속성 Dept_NameC 설정 |  |  |  |
| AC-6acf2cff | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:830 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.UserExistYN | UserInfoContext.Current["NewUserExistYN"] ?? "Y" | 속성 UserExistYN 설정 |  |  |  |
| AC-e9fae15c | this.Load [if (CurUserID == null)] | SCM0008_Auth_Request.cs:831 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.IsNewUser | "N" | 속성 IsNewUser 설정 |  |  |  |

## SCM0008_Auth_Request.GetTopAuthorityGroupID

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-418c5390 | (진입점 미연결) | SCM0008_Auth_Request.cs:556 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCM0008_Auth_Request.HasNoDuplicationAuth

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4714de57 | (진입점 미연결) | SCM0008_Auth_Request.cs:736 | if (lstPlant.Count > 0) ▸ foreach (string plant in lstPlant) ▸ lambda | DATA_OP | a.Field | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0987bbc2 | (진입점 미연결) | SCM0008_Auth_Request.cs:737 | if (lstPlant.Count > 0) ▸ foreach (string plant in lstPlant) ▸ lambda | DATA_OP | a.Field | ("GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd3fa252 | (진입점 미연결) | SCM0008_Auth_Request.cs:738 | if (lstPlant.Count > 0) ▸ foreach (string plant in lstPlant) ▸ lambda | DATA_OP | a.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-727a47bf | (진입점 미연결) | SCM0008_Auth_Request.cs:739 | if (lstPlant.Count > 0) ▸ foreach (string plant in lstPlant) ▸ lambda | DATA_OP | a.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c26f23fa | (진입점 미연결) | SCM0008_Auth_Request.cs:748 | else of (lstPlant.Count > 0) ▸ lambda | DATA_OP | a.Field | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ff309de | (진입점 미연결) | SCM0008_Auth_Request.cs:749 | else of (lstPlant.Count > 0) ▸ lambda | DATA_OP | a.Field | ("GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e5fa3fa9 | (진입점 미연결) | SCM0008_Auth_Request.cs:750 | else of (lstPlant.Count > 0) ▸ lambda | DATA_OP | a.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7f24ed96 | (진입점 미연결) | SCM0008_Auth_Request.cs:751 | else of (lstPlant.Count > 0) ▸ lambda | DATA_OP | a.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-05a49b1c | (진입점 미연결) | SCM0008_Auth_Request.cs:757 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCM0008_Auth_Request.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7d2cbbf | this.Load | SCM0008_Auth_Request.cs:153 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-34728429 | this.Load | SCM0008_Auth_Request.cs:155 |  | FLAG | dtLanguage | Data.Common(Data.Type.Language) ⇒ biz:CommonData.CommonDataList [code=Language] | 화면 필드/플래그 변경 |  |  |  |
| AC-b67e14f7 | this.Load | SCM0008_Auth_Request.cs:155 |  | COMBO_DATA | Data.Common | (Data.Type.Language) ⇒ biz:CommonData.CommonDataList [code=Language] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1ed3e2ee | this.Load | SCM0008_Auth_Request.cs:157 |  | LIST_REBIND | clsCtrl.setListBox | (dtLanguage, cboLanguage, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6a3455d3 | this.Load | SCM0008_Auth_Request.cs:159 |  | FLAG | dtTimeZone | Data.Common(Data.Type.TimeZone) ⇒ biz:CommonData.CommonDataList [code=TimeZone] | 화면 필드/플래그 변경 |  |  |  |
| AC-dc1fb5f1 | this.Load | SCM0008_Auth_Request.cs:159 |  | COMBO_DATA | Data.Common | (Data.Type.TimeZone) ⇒ biz:CommonData.CommonDataList [code=TimeZone] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dbcc29bd | this.Load | SCM0008_Auth_Request.cs:161 |  | LIST_REBIND | clsCtrl.setListBox | (dtTimeZone, cboTimeZone , false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCM0008_Auth_Request.InitSpread

진입점: this.Load / this.btnAdd.Click [if (iCount > 0) ▸ try ▸ if (tran.Success)] / this.btnAuthDelete.Click / this.btnRequest.Click [if (tran.Success)] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99c798b3 | this.Load 외 5 | SCM0008_Auth_Request.cs:239 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.InitSheet | (spread.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7e2a9b5d | this.Load 외 5 | SCM0008_Auth_Request.cs:240 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddTextColumn | ("GroupID", DefMain.GROUP_ID, FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c926232 | this.Load 외 5 | SCM0008_Auth_Request.cs:241 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddTextColumn | ("E-MAIL", DefMain.GRP_MAIL, FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-917acdd3 | this.Load 외 5 | SCM0008_Auth_Request.cs:242 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddTextColumn | ("Authority", DefMain.GRP_NAME, FPMerge.None, 130, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28350390 | this.Load 외 5 | SCM0008_Auth_Request.cs:243 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.AddTextColumn | ("Description", DefMain.GRP_DESCRIPTION, FPMerge.None, 340, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a8e511d5 | this.Load 외 5 | SCM0008_Auth_Request.cs:246 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.Freeze | (0, siMain.GetColumnIndex(DefMain.GRP_NAME)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-62cfaeaa | this.Load 외 5 | SCM0008_Auth_Request.cs:247 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | spread.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-021ca599 | this.Load 외 5 | SCM0008_Auth_Request.cs:252 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtDivision) | GRID_INIT | spread.InitSheet | (spread.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-72472796 | this.Load 외 5 | SCM0008_Auth_Request.cs:253 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtDivision) | GRID_INIT | spread.AddCheckColumn | ("ALL", DefCheck.CHK, FPMerge.None, 25, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa9d18fd | this.Load 외 5 | SCM0008_Auth_Request.cs:254 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtDivision) | GRID_INIT | spread.AddTextColumn | ("Division", DefDivision.DIVISION_ID, FPMerge.None, 40, false, FPHAlign.Left, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-839e1fde | this.Load 외 5 | SCM0008_Auth_Request.cs:255 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtDivision) | GRID_INIT | spread.AddTextColumn | ("Division", DefDivision.DIVISION_NAME, FPMerge.None, 250, true , FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9867950 | this.Load 외 5 | SCM0008_Auth_Request.cs:263 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtDivision) | GRID_SET | spread.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefCheck.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-2f3e967e | this.Load 외 5 | SCM0008_Auth_Request.cs:264 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtDivision) | GRID_SET | spread.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefCheck.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-5043d8a8 | this.Load 외 5 | SCM0008_Auth_Request.cs:265 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtDivision) | GRID_SET | spread.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefCheck.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-66184ee4 | this.Load 외 5 | SCM0008_Auth_Request.cs:268 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtDivision) | GRID_INIT | spread.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-04f1e384 | this.Load 외 5 | SCM0008_Auth_Request.cs:303 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.InitSheet | (spread.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-e2b870ca | this.Load 외 5 | SCM0008_Auth_Request.cs:305 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.AddCheckColumn | ("ALL", DefMyAuthList.CHK, FPMerge.None, 25, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6bd90dcb | this.Load 외 5 | SCM0008_Auth_Request.cs:306 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.AddTextColumn | ("Authority_code", DefMyAuthList.AUTHORITY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d4d4cb8d | this.Load 외 5 | SCM0008_Auth_Request.cs:307 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.AddTextColumn | ("Authority", DefMyAuthList.AUTHORITY_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d7484636 | this.Load 외 5 | SCM0008_Auth_Request.cs:309 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.AddTextColumn | ("Division", DefMyAuthList.DIVISION_ID, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7d1170f1 | this.Load 외 5 | SCM0008_Auth_Request.cs:310 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.AddTextColumn | ("Division", DefMyAuthList.DIVISION_NAME, FPMerge.None, 160, true , FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-313ec53f | this.Load 외 5 | SCM0008_Auth_Request.cs:312 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.AddTextColumn | ("PLANT_ID", DefMyAuthList.PLANT_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8fedc74a | this.Load 외 5 | SCM0008_Auth_Request.cs:313 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.AddTextColumn | ("Plant", DefMyAuthList.PLANT_NAME, FPMerge.None, 200, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-abea7e2d | this.Load 외 5 | SCM0008_Auth_Request.cs:318 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.AddDateTimeColumn | ("Request Date", DefMyAuthList.REQUEST_DATE, FPMerge.None, 165, true, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e860883 | this.Load 외 5 | SCM0008_Auth_Request.cs:319 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.AddTextColumn | ("Approval Result", DefMyAuthList.APPROVAL_RESULT, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9414d0e9 | this.Load 외 5 | SCM0008_Auth_Request.cs:320 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.AddTextColumn | ("Approval User", DefMyAuthList.APPROVAL_USER, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-58bbbd6e | this.Load 외 5 | SCM0008_Auth_Request.cs:321 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.AddDateTimeColumn | ("Approval Date", DefMyAuthList.APPROVAL_DATE, FPMerge.None, 165, true, FPHAlign.Center, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3694ed62 | this.Load 외 5 | SCM0008_Auth_Request.cs:322 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.AddTextColumn | ("Reject Reason", DefMyAuthList.REJECT_REASON, FPMerge.None, 110, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f0c127f | this.Load 외 5 | SCM0008_Auth_Request.cs:324 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_LOCK | spread.LockColumn | (siMyAuthList.GetColumnIndex(DefMyAuthList.AUTHORITY) , siMyAuthList.GetColumnIndex(DefMyA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ba870dac | this.Load 외 5 | SCM0008_Auth_Request.cs:333 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_SET | spread.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefMyAuthList.CHK)].CellTyp… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-fd63292c | this.Load 외 5 | SCM0008_Auth_Request.cs:334 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_SET | spread.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefMyAuthList.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-77401560 | this.Load 외 5 | SCM0008_Auth_Request.cs:335 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_SET | spread.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefMyAuthList.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-1326feb4 | this.Load 외 5 | SCM0008_Auth_Request.cs:337 | else of (sheetName == SpdSheet.shtMain) ▸ else of (sheetName == SpdSheet.shtDivision) ▸ if (sheetName == SpdSheet.shtMyAuthList) | GRID_INIT | spread.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0008_Auth_Request.InterlockTotalMiss

진입점: this.btnAdd.Click / this.btnAuthDelete.Click / this.btnRequest.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0974376e | this.btnAdd.Click 외 2 | SCM0008_Auth_Request.cs:997 | if (btnEvent.Equals("REQ") \|\| btnEvent.Equals("REM")) ▸ if (siMyAuthList.GetMaxRowIndex()<0) | DATA_OP | lstMessage.Add | (MessageHelper.GetMessageInfo("MSG00005", _userinfo.Language.Trim().Length < 1 ? "EN" : _u… | 데이터 객체 조작/조회 |  |  |  |
| AC-d19b71d2 | this.btnAdd.Click 외 2 | SCM0008_Auth_Request.cs:997 | if (btnEvent.Equals("REQ") \|\| btnEvent.Equals("REM")) ▸ if (siMyAuthList.GetMaxRowIndex()<0) | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00005", _userinfo.Language.Trim().Length < 1 ? "EN" : _userinfo.Language) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8d74b506 | this.btnAdd.Click 외 2 | SCM0008_Auth_Request.cs:1002 | if (btnEvent.Equals("REQ") \|\| btnEvent.Equals("REM")) ▸ else of (siMyAuthList.GetMaxRowIndex()<0) ▸ if (NoCheckedBoxes(siMyAuthList)) | DATA_OP | lstMessage.Add | (MessageHelper.GetMessageInfo("MSG00021", _userinfo.Language.Trim().Length < 1 ? "EN" : _u… | 데이터 객체 조작/조회 |  |  |  |
| AC-79c128d6 | this.btnAdd.Click 외 2 | SCM0008_Auth_Request.cs:1002 | if (btnEvent.Equals("REQ") \|\| btnEvent.Equals("REM")) ▸ else of (siMyAuthList.GetMaxRowIndex()<0) ▸ if (NoCheckedBoxes(siMyAuthList)) | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00021", _userinfo.Language.Trim().Length < 1 ? "EN" : _userinfo.Language) | ⚠ 의미 확인 필요 |  |  |  |
| AC-55a862f9 | this.btnAdd.Click 외 2 | SCM0008_Auth_Request.cs:1014 | if (lstMessage.Count>0) | MESSAGE | MessageHelper.GMessageBox | (sb.ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb646a81 | this.btnAdd.Click 외 2 | SCM0008_Auth_Request.cs:1018 |  | CALL_EXT | lstMessage.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f8be9e7 | this.btnAdd.Click 외 2 | SCM0008_Auth_Request.cs:1019 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCM0008_Auth_Request.LockUserInfoBoxes

진입점: this.Load / this.btnAuthDelete.Click / this.btnRequest.Click [if (tran.Success)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2da5012d | this.Load 외 3 | SCM0008_Auth_Request.cs:930 |  | STATE | txtUserId.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-7586d277 | this.Load 외 3 | SCM0008_Auth_Request.cs:931 |  | STATE | txtUserName.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |

## SCM0008_Auth_Request.NoCheckedBoxes

진입점: this.btnAdd.Click [if (btnEvent.Equals("REQ") \|\| btnEvent.Equals("REM")) ▸ else of (siMyAuthList.GetMaxRowIndex()<0)] / this.btnAuthDelete.Click [if (btnEvent.Equals("REQ") \|\| btnEvent.Equals("REM")) ▸ else of (siMyAuthList.GetMaxRowIndex()<0)] / this.btnRequest.Click [if (btnEvent.Equals("REQ") \|\| btnEvent.Equals("REM")) ▸ else of (siMyAuthList.GetMaxRowIndex()<0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2e77bbc | this.btnAdd.Click [if (btnEvent.Equals("REQ") \|\| btnEvent.… 외 2 | SCM0008_Auth_Request.cs:1025 | for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.IsLockCell | (i, spread.GetColumnIndex(DefCheck.CHK)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c5e6d6b | this.btnAdd.Click [if (btnEvent.Equals("REQ") \|\| btnEvent.… 외 2 | SCM0008_Auth_Request.cs:1029 | for (i <= spread.GetMaxRowIndex()) ▸ if (CHK.ToUpper().Equals("TRUE")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-65c9fe5e | this.btnAdd.Click [if (btnEvent.Equals("REQ") \|\| btnEvent.… 외 2 | SCM0008_Auth_Request.cs:1031 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCM0008_Auth_Request.RequestAuthList

진입점: this.btnRequest.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10c564a3 | this.btnRequest.Click | SCM0008_Auth_Request.cs:479 |  | UI_PROP | _userinfo.Email | txtEMail.Text.Trim() | 속성 Email 설정 |  |  |  |
| AC-982f124a | this.btnRequest.Click | SCM0008_Auth_Request.cs:480 |  | UI_PROP | _userinfo.CellPhoneNum | txtCellPhone.Text.Trim() | 속성 CellPhoneNum 설정 |  |  |  |
| AC-b0ddeaf7 | this.btnRequest.Click | SCM0008_Auth_Request.cs:481 |  | UI_PROP | _userinfo.Language | cboLanguage.ControlValues | 속성 Language 설정 |  |  |  |
| AC-01be2168 | this.btnRequest.Click | SCM0008_Auth_Request.cs:482 |  | UI_PROP | _userinfo.TimeZone | cboTimeZone.ControlValues | 속성 TimeZone 설정 |  |  |  |
| AC-82c7b112 | this.btnRequest.Click | SCM0008_Auth_Request.cs:499 | for (p <= siMyAuthList.GetMaxRowIndex()) | CALL_EXT | siMyAuthList.IsLockCell | (p, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b358c7a | this.btnRequest.Click | SCM0008_Auth_Request.cs:512 | if (iCount <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62fae3c9 | this.btnRequest.Click | SCM0008_Auth_Request.cs:514 |  | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_SaveReqAuthRequestMyList") ⇒ SystemManager.UP_FX_SaveReqAuthRequestMyList | 엔드포인트 요청 생성 |  |  |  |
| AC-4dde1e10 | this.btnRequest.Click | SCM0008_Auth_Request.cs:516 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-23b00dbe | this.btnRequest.Click | SCM0008_Auth_Request.cs:518 | lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-24a18571 | this.btnRequest.Click | SCM0008_Auth_Request.cs:519 | lambda | DATA_OP | req.Parameters["p_User_ID"] | _userinfo.UserID | 행/컬럼 값 대입 |  |  |  |
| AC-65e8f4c9 | this.btnRequest.Click | SCM0008_Auth_Request.cs:520 | lambda | DATA_OP | req.Parameters["p_User_Name"] | _userinfo.UserName | 행/컬럼 값 대입 |  |  |  |
| AC-ad62faee | this.btnRequest.Click | SCM0008_Auth_Request.cs:521 | lambda | DATA_OP | req.Parameters["p_Group_ID"] | p_Group_ID | 행/컬럼 값 대입 |  |  |  |
| AC-53911af2 | this.btnRequest.Click | SCM0008_Auth_Request.cs:522 | lambda | DATA_OP | req.Parameters["p_Division_ID"] | p_Division_ID | 행/컬럼 값 대입 |  |  |  |
| AC-16cf8464 | this.btnRequest.Click | SCM0008_Auth_Request.cs:523 | lambda | DATA_OP | req.Parameters["p_Plant_ID"] | p_Plant_ID | 행/컬럼 값 대입 |  |  |  |
| AC-8e757d9e | this.btnRequest.Click | SCM0008_Auth_Request.cs:524 | lambda | DATA_OP | req.Parameters["p_Customer_Code"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e77d2b52 | this.btnRequest.Click | SCM0008_Auth_Request.cs:525 | lambda | DATA_OP | req.Parameters["p_User_NameE"] | _userinfo.UserNameE | 행/컬럼 값 대입 |  |  |  |
| AC-e88c26e3 | this.btnRequest.Click | SCM0008_Auth_Request.cs:526 | lambda | DATA_OP | req.Parameters["p_Default_Group_ID"] | _userinfo.Default_Grp_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f3afcff1 | this.btnRequest.Click | SCM0008_Auth_Request.cs:527 | lambda | DATA_OP | req.Parameters["p_Dept_ID"] | p_Deft_ID | 행/컬럼 값 대입 |  |  |  |
| AC-55a98bd0 | this.btnRequest.Click | SCM0008_Auth_Request.cs:528 | lambda | DATA_OP | req.Parameters["p_Email"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0733fbdc | this.btnRequest.Click | SCM0008_Auth_Request.cs:529 | lambda | DATA_OP | req.Parameters["p_CellPhone"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1491001f | this.btnRequest.Click | SCM0008_Auth_Request.cs:530 | lambda | DATA_OP | req.Parameters["p_Language"] | _userinfo.Language | 행/컬럼 값 대입 |  |  |  |
| AC-307b7321 | this.btnRequest.Click | SCM0008_Auth_Request.cs:531 | lambda | DATA_OP | req.Parameters["p_TimeZone"] | _userinfo.TimeZone | 행/컬럼 값 대입 |  |  |  |
| AC-0dc4ee16 | this.btnRequest.Click | SCM0008_Auth_Request.cs:533 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7b183d29 | this.btnRequest.Click | SCM0008_Auth_Request.cs:533 | lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-cd2268e8 | this.btnRequest.Click | SCM0008_Auth_Request.cs:538 | if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00158") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCM0008_Auth_Request.SetSpreadWidth

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ea62b2f | (진입점 미연결) | SCM0008_Auth_Request.cs:1109 | if (spread != null) | GRID_STYLE | spread.setColumnWidth | (spread.GetMaxColumnIndex(), (int)pnlWidth) | 그리드 표시 설정 |  |  |  |

## SCM0008_Auth_Request.SetUserinfo

진입점: this.Load / this.btnAuthDelete.Click / this.btnRequest.Click [if (tran.Success)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fb9a700 | this.Load 외 3 | SCM0008_Auth_Request.cs:1035 |  | VALUE_SET | txtUserId.Text | _userinfo.UserID | 컨트롤 값 설정 |  |  |  |
| AC-84d8adcf | this.Load 외 3 | SCM0008_Auth_Request.cs:1036 |  | VALUE_SET | txtUserName.Text | _userinfo.UserName | 컨트롤 값 설정 |  |  |  |
| AC-e704fa99 | this.Load 외 3 | SCM0008_Auth_Request.cs:1037 |  | VALUE_SET | txtDeptName.Text | _userinfo.Dept_NameK | 컨트롤 값 설정 |  |  |  |
| AC-3255b57b | this.Load 외 3 | SCM0008_Auth_Request.cs:1038 |  | VALUE_SET | txtEMail.Text | _userinfo.Email | 컨트롤 값 설정 |  |  |  |
| AC-ca16b20f | this.Load 외 3 | SCM0008_Auth_Request.cs:1039 |  | VALUE_SET | txtCellPhone.Text | _userinfo.CellPhoneNum | 컨트롤 값 설정 |  |  |  |
| AC-3b585cf6 | this.Load 외 3 | SCM0008_Auth_Request.cs:1048 | if (dtMyAuthList.Rows.Count > 0) ▸ if (!string.IsNullOrWhiteSpace(sLanguage)) | UI_PROP | _userinfo.Language | sLanguage | 속성 Language 설정 |  |  |  |
| AC-1b48ebbe | this.Load 외 3 | SCM0008_Auth_Request.cs:1049 | if (dtMyAuthList.Rows.Count > 0) ▸ if (!string.IsNullOrWhiteSpace(sLanguage)) | UI_PROP | _userinfo.IsNewUser | "N" | 속성 IsNewUser 설정 |  |  |  |
| AC-00ad2687 | this.Load 외 3 | SCM0008_Auth_Request.cs:1052 | if (dtMyAuthList.Rows.Count > 0) ▸ if (!string.IsNullOrWhiteSpace(sTimeZone)) | UI_PROP | _userinfo.TimeZone | sTimeZone | 속성 TimeZone 설정 |  |  |  |
| AC-8ff7f3b8 | this.Load 외 3 | SCM0008_Auth_Request.cs:1057 | if (_userinfo.Language == null \|\| _userinfo.IsNewUser == "Y") | VALUE_SET | cboLanguage.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-fb59d783 | this.Load 외 3 | SCM0008_Auth_Request.cs:1060 | else of (_userinfo.Language == null \|\| _userinfo.IsNewUser == "Y") | VALUE_SET | cboLanguage.SelectedValue | _userinfo.Language | 컨트롤 값 설정 |  |  |  |
| AC-26456440 | this.Load 외 3 | SCM0008_Auth_Request.cs:1064 | if (_userinfo.TimeZone == null \|\| _userinfo.IsNewUser == "Y") | VALUE_SET | cboTimeZone.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-81f210a8 | this.Load 외 3 | SCM0008_Auth_Request.cs:1067 | else of (_userinfo.TimeZone == null \|\| _userinfo.IsNewUser == "Y") | VALUE_SET | cboTimeZone.SelectedValue | _userinfo.TimeZone | 컨트롤 값 설정 |  |  |  |


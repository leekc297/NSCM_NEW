# AS-IS 액션 대조표 — SCP0039

> 원천: `Doc/asisfacts/screens/SCP0039/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 160행 · 메서드 23 · 종류 DATA_OP 41 · UI_PROP 17 · GRID_INIT 14 · FLAG 13 · STATE 12 · CALL_EXT 11 · ENDPOINT 10 · POPUP 8 · GRID_SET 7 · RETURN 7 · UI_MISC 5 · VALUE_SET 4 · GRID_BIND 2 · GRID_LOCK 2 · LIST_REBIND 2 · COMBO_DATA 2 · GRID_CLEAR 1 · CALL_BASE 1 · VALIDATE 1 · ⚠ 의미 확인 필요 12


## SCP0039_ValidationMaster..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06915f25 | .ctor | SCP0039_ValidationMaster.cs:154 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-02a1f820 | .ctor | SCP0039_ValidationMaster.cs:157 |  | FLAG | this._division_id | division_id | 화면 필드/플래그 변경 |  |  |  |
| AC-6c45361b | .ctor | SCP0039_ValidationMaster.cs:158 |  | FLAG | this._plan_group_id | plan_group_id | 화면 필드/플래그 변경 |  |  |  |

## SCP0039_ValidationMaster.btnItemId_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1355042a | (진입점 미연결) | SCP0039_ValidationMaster.cs:1297 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-8cc19d45 | (진입점 미연결) | SCP0039_ValidationMaster.cs:1299 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-06aa7dde | (진입점 미연결) | SCP0039_ValidationMaster.cs:1300 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7a52ae99 | (진입점 미연결) | SCP0039_ValidationMaster.cs:1301 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-19d8d25a | (진입점 미연결) | SCP0039_ValidationMaster.cs:1307 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0039_ValidationMaster.btnItemId_Click_1

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bf079ae | this.btnItemId.Click | SCP0039_ValidationMaster.cs:1323 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-92fd490c | this.btnItemId.Click | SCP0039_ValidationMaster.cs:1325 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e32a5770 | this.btnItemId.Click | SCP0039_ValidationMaster.cs:1326 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-682efbe5 | this.btnItemId.Click | SCP0039_ValidationMaster.cs:1327 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7cc92a0b | this.btnItemId.Click | SCP0039_ValidationMaster.cs:1333 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0039_ValidationMaster.BtnSearch_Click

진입점: btnSearch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42663f82 | btnSearch.Click | SCP0039_ValidationMaster.cs:1342 |  | FLAG | this.isSearch | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0039_ValidationMaster.ClearSheet

진입점: cboDivision.SelectedIndexChanged / clbPlanGroup.SelectedIndexChanged / btnSearch.Click [for (nRow < siMain.ActiveSheet.Rows.Count)] / FindButton [for (nRow < siMain.ActiveSheet.Rows.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c4c9141 | cboDivision.SelectedIndexChanged 외 3 | SCP0039_ValidationMaster.cs:1224 | for (i < siMain.ActiveSheet.RowCount) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.COUNT), "") | 그리드 값 설정 |  |  |  |
| AC-4cc5702d | cboDivision.SelectedIndexChanged 외 3 | SCP0039_ValidationMaster.cs:1229 | for (i < siMain.ActiveSheet.RowCount) ▸ if (SvSheet.RowCount > 0) | UI_PROP | SvSheet.RowCount | 0 | 속성 RowCount 설정 |  |  |  |
| AC-40b7efe4 | cboDivision.SelectedIndexChanged 외 3 | SCP0039_ValidationMaster.cs:1232 | for (i < siMain.ActiveSheet.RowCount) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdProjectRouteInfo) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0039_ValidationMaster.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6593bc2e | this.Load | SCP0039_ValidationMaster.cs:269 |  | GRID_INIT | AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2119661c | this.Load | SCP0039_ValidationMaster.cs:270 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## SCP0039_ValidationMaster.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e57fd9a3 | Dispose | SCP0039_ValidationMaster.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0039_ValidationMaster.FindData

진입점: spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColumns.QUERY) && !e.ColumnHeader)] / btnSearch.Click [for (nRow < siMain.ActiveSheet.Rows.Count)] / FindButton [for (nRow < siMain.ActiveSheet.Rows.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0bcbbb4 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:589 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6437c11e | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:592 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9ae8def1 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:606 | try ▸ else of (!pProcedureNm.Equals("-")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2361e10 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:618 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d29f58c0 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:619 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dd6ad888 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:623 | try ▸ lambda | ENDPOINT | new FoxDataRequest | (procNm) ⇒ {p:pProcedureNm} | 엔드포인트 요청 생성 |  |  |  |
| AC-bc2e949b | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:625 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-10f21ebf | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:626 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-47d5e954 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:627 | try ▸ lambda | DATA_OP | request.Parameters["p_search_type"] | p_search_type | 행/컬럼 값 대입 |  |  |  |
| AC-6186803d | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:630 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_group_id"] | p_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-5f391a80 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:633 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a92ba11d | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:635 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7ae67e5c | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:637 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-235c9ea6 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:646 | try ▸ if (ds.Tables.Count > 0) | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.COUNT), ds.Tables[0].Rows.Count.ToString()) | 그리드 값 설정 |  |  |  |
| AC-9ba49914 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:648 | try ▸ if (ds.Tables.Count > 0) | GRID_INIT | siProjectRoute.ChangeSheet | (sheetName) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bfce7f59 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:649 | try ▸ if (ds.Tables.Count > 0) | GRID_INIT | siProjectRoute.ChangeActiveSheet | (sheetName) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-be77e8e5 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:651 | try ▸ if (ds.Tables.Count > 0) | GRID_BIND | siProjectRoute.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4c0b7a82 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:652 | try ▸ if (ds.Tables.Count > 0) | GRID_LOCK | siProjectRoute.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a3a77640 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:779 | try ▸ else of (ds.Tables.Count > 0) | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.COUNT), "0") | 그리드 값 설정 |  |  |  |
| AC-527b5c7e | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:783 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-199755f1 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:789 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0f4a1587 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… 외 2 | SCP0039_ValidationMaster.cs:794 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0039_ValidationMaster.FindDataAll

진입점: btnSearch.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67de9567 | btnSearch.Click 외 1 | SCP0039_ValidationMaster.cs:540 | for (nRow < siMain.ActiveSheet.Rows.Count) | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.COUNT), "") | 그리드 값 설정 |  |  |  |
| AC-dbb371d9 | btnSearch.Click 외 1 | SCP0039_ValidationMaster.cs:557 | for (nRow < siMain.ActiveSheet.Rows.Count) | CALL_EXT | Thread.Sleep | (100) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0039_ValidationMaster.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52175a3d | this.Load | SCP0039_ValidationMaster.cs:167 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0039_ValidationMaster.GetDicToValue

진입점: spdMain.CellClick / btnSearch.Click [for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (!string.IsNullOrEmpty(sConst))] / FindButton [for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (!string.IsNullOrEmpty(sConst))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7e97ede | spdMain.CellClick 외 2 | SCP0039_ValidationMaster.cs:572 | foreach (string pair in pairs) ▸ if (keyValue.Length == 2) | DATA_OP | dict[keyValue[0]] | keyValue[1] | 행/컬럼 값 대입 |  |  |  |
| AC-cc04bd16 | spdMain.CellClick 외 2 | SCP0039_ValidationMaster.cs:581 |  | CALL_EXT | dict.TryGetValue | (pDiv, out string sResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9017ee11 | spdMain.CellClick 외 2 | SCP0039_ValidationMaster.cs:583 |  | RETURN | return sResult; |  | 처리 중단/반환 |  |  |  |

## SCP0039_ValidationMaster.getLookupMasterValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1657a87 | (진입점 미연결) | SCP0039_ValidationMaster.cs:520 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL") ⇒ SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-12a8eb9b | (진입점 미연결) | SCP0039_ValidationMaster.cs:522 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-35e25eaf | (진입점 미연결) | SCP0039_ValidationMaster.cs:523 |  | DATA_OP | request.Parameters["p_lookup_type"] | "MASTER_VALIDATION" | 행/컬럼 값 대입 |  |  |  |
| AC-8bbc43e2 | (진입점 미연결) | SCP0039_ValidationMaster.cs:526 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ebe27b97 | (진입점 미연결) | SCP0039_ValidationMaster.cs:530 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0039_ValidationMaster.GetSearchInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cb47534 | (진입점 미연결) | SCP0039_ValidationMaster.cs:248 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0121_GET_SEARCH_INFO") ⇒ SCP.SCP0121_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-d841e210 | (진입점 미연결) | SCP0039_ValidationMaster.cs:250 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-87bf0b95 | (진입점 미연결) | SCP0039_ValidationMaster.cs:251 |  | DATA_OP | request.Parameters["p_user_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7d6f17db | (진입점 미연결) | SCP0039_ValidationMaster.cs:254 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2e92c3e8 | (진입점 미연결) | SCP0039_ValidationMaster.cs:258 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0039_ValidationMaster.GoPage

진입점: spdMain.CellClick [else of (nCol == siMain.GetColumnIndex(DefColumns.QUERY) && !e.ColumnHeader) ▸ if (nCol == siMain.GetColumnIndex(DefColumns.OPEN) && !e.ColumnHeader)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea819f65 | spdMain.CellClick [else of (nCol == siMain.GetColumnIndex(De… | SCP0039_ValidationMaster.cs:1139 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-be3bbd71 | spdMain.CellClick [else of (nCol == siMain.GetColumnIndex(De… | SCP0039_ValidationMaster.cs:1140 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.DataService.WSL/FoxDataServic… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e4de382a | spdMain.CellClick [else of (nCol == siMain.GetColumnIndex(De… | SCP0039_ValidationMaster.cs:1144 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("MenuContainer.UP_FX_GetGSCMAuthenticationMenuList") ⇒ MenuContainer.UP_FX_GetGSCMAuthenticationMenuList | 엔드포인트 요청 생성 |  |  |  |
| AC-728d2236 | spdMain.CellClick [else of (nCol == siMain.GetColumnIndex(De… | SCP0039_ValidationMaster.cs:1145 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ab8ebd9f | spdMain.CellClick [else of (nCol == siMain.GetColumnIndex(De… | SCP0039_ValidationMaster.cs:1146 | try ▸ lambda | DATA_OP | request.Parameters["UserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0de9724d | spdMain.CellClick [else of (nCol == siMain.GetColumnIndex(De… | SCP0039_ValidationMaster.cs:1147 | try ▸ lambda | DATA_OP | request.Parameters["GroupID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-78b1a6be | spdMain.CellClick [else of (nCol == siMain.GetColumnIndex(De… | SCP0039_ValidationMaster.cs:1148 | try ▸ lambda | DATA_OP | request.Parameters["ProgramId"] | pageNm | 행/컬럼 값 대입 |  |  |  |
| AC-af71a5d6 | spdMain.CellClick [else of (nCol == siMain.GetColumnIndex(De… | SCP0039_ValidationMaster.cs:1150 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-96cb4d1a | spdMain.CellClick [else of (nCol == siMain.GetColumnIndex(De… | SCP0039_ValidationMaster.cs:1152 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-96ce42ea | spdMain.CellClick [else of (nCol == siMain.GetColumnIndex(De… | SCP0039_ValidationMaster.cs:1161 | finally ▸ if (prgId.Substring(0, 4) == "http") | CALL_EXT | System.Diagnostics.Process.Start | (prgId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c43cba4 | spdMain.CellClick [else of (nCol == siMain.GetColumnIndex(De… | SCP0039_ValidationMaster.cs:1165 | finally ▸ else of (prgId.Substring(0, 4) == "http") | CALL_BASE | openSubMenu | (prgId) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0039_ValidationMaster.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-539e7c91 | this.Load | SCP0039_ValidationMaster.cs:193 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1246e08a | this.Load | SCP0039_ValidationMaster.cs:196 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-b03dd1c5 | this.Load | SCP0039_ValidationMaster.cs:198 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-722001d0 | this.Load | SCP0039_ValidationMaster.cs:203 | if (this.IsPopup) | VALUE_SET | cboDivision.ControlValues | this._division_id | 컨트롤 값 설정 |  |  |  |
| AC-55c0ccee | this.Load | SCP0039_ValidationMaster.cs:207 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-35987230 | this.Load | SCP0039_ValidationMaster.cs:212 | if (this.IsPopup) | VALUE_SET | clbPlanGroup.ControlValues | this._plan_group_id | 컨트롤 값 설정 |  |  |  |
| AC-27405526 | this.Load | SCP0039_ValidationMaster.cs:214 | if (this.IsPopup) | STATE | Division.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-210585cd | this.Load | SCP0039_ValidationMaster.cs:215 | if (this.IsPopup) | STATE | lciPlanGroup.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-92a7f476 | this.Load | SCP0039_ValidationMaster.cs:216 | if (this.IsPopup) | UI_PROP | lblModel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8fcc6f6b | this.Load | SCP0039_ValidationMaster.cs:217 | if (this.IsPopup) | UI_PROP | lciBtnItem.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-88fdec24 | this.Load | SCP0039_ValidationMaster.cs:219 | if (this.IsPopup) | UI_PROP | lciBtnSearch.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-364c885a | this.Load | SCP0039_ValidationMaster.cs:223 | else of (this.IsPopup) | STATE | Division.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-578ddcb3 | this.Load | SCP0039_ValidationMaster.cs:224 | else of (this.IsPopup) | STATE | lciPlanGroup.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e1c9cdff | this.Load | SCP0039_ValidationMaster.cs:225 | else of (this.IsPopup) | UI_PROP | lblModel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0558b00c | this.Load | SCP0039_ValidationMaster.cs:226 | else of (this.IsPopup) | UI_PROP | lciBtnItem.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-edb6c835 | this.Load | SCP0039_ValidationMaster.cs:228 | else of (this.IsPopup) | UI_PROP | lciBtnSearch.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0039_ValidationMaster.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbc60915 | this.Load | SCP0039_ValidationMaster.cs:382 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f5fbaddb | this.Load | SCP0039_ValidationMaster.cs:383 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-1c9976da | this.Load | SCP0039_ValidationMaster.cs:384 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d0a0e86a | this.Load | SCP0039_ValidationMaster.cs:426 | else of (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b8545053 | this.Load | SCP0039_ValidationMaster.cs:427 | else of (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-9f1c1c6d | this.Load | SCP0039_ValidationMaster.cs:428 | else of (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0039_ValidationMaster.InsertBaseRow

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80332a9e | this.Load | SCP0039_ValidationMaster.cs:807 |  | DATA_OP | table.Columns.Add | ("VALIDATION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-15eb89ec | this.Load | SCP0039_ValidationMaster.cs:808 |  | DATA_OP | table.Columns.Add | ("COUNT", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-70d2d4a5 | this.Load | SCP0039_ValidationMaster.cs:809 |  | DATA_OP | table.Columns.Add | ("IMPACT", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f2ed19f | this.Load | SCP0039_ValidationMaster.cs:810 |  | DATA_OP | table.Columns.Add | ("QUERY") | 데이터 객체 조작/조회 |  |  |  |
| AC-1ea09546 | this.Load | SCP0039_ValidationMaster.cs:811 |  | DATA_OP | table.Columns.Add | ("OPEN") | 데이터 객체 조작/조회 |  |  |  |
| AC-580c8719 | this.Load | SCP0039_ValidationMaster.cs:812 |  | DATA_OP | table.Columns.Add | ("SHEET_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4f62d79 | this.Load | SCP0039_ValidationMaster.cs:813 |  | DATA_OP | table.Columns.Add | ("PROGRAM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c674bc5 | this.Load | SCP0039_ValidationMaster.cs:814 |  | DATA_OP | table.Columns.Add | ("PROCEDURE_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9edbc8d0 | this.Load | SCP0039_ValidationMaster.cs:815 |  | DATA_OP | table.Columns.Add | ("CONSTRAINTS01", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-adc3da1e | this.Load | SCP0039_ValidationMaster.cs:825 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ if (!this.IsPopup) | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f61e82d4 | this.Load | SCP0039_ValidationMaster.cs:827 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ if (!this.IsPopup) | DATA_OP | dr["VALIDATION_TYPE"] | dtMasterValidation.Rows[i]["SEGMENT2"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a299946c | this.Load | SCP0039_ValidationMaster.cs:828 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ if (!this.IsPopup) | DATA_OP | dr["COUNT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d5b43ed | this.Load | SCP0039_ValidationMaster.cs:829 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ if (!this.IsPopup) | DATA_OP | dr["IMPACT"] | dtMasterValidation.Rows[i]["ATTRIBUTE3"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ae09db17 | this.Load | SCP0039_ValidationMaster.cs:830 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ if (!this.IsPopup) | DATA_OP | dr["SHEET_NAME"] | dtMasterValidation.Rows[i]["SEGMENT2"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3127d00f | this.Load | SCP0039_ValidationMaster.cs:831 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ if (!this.IsPopup) | DATA_OP | dr["PROGRAM_ID"] | dtMasterValidation.Rows[i]["SEGMENT4"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9a25f5d5 | this.Load | SCP0039_ValidationMaster.cs:832 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ if (!this.IsPopup) | DATA_OP | dr["PROCEDURE_NAME"] | dtMasterValidation.Rows[i]["SEGMENT5"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5a1a8e04 | this.Load | SCP0039_ValidationMaster.cs:833 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ if (!this.IsPopup) | DATA_OP | dr["CONSTRAINTS01"] | dtMasterValidation.Rows[i]["ATTRIBUTE1"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-350731ec | this.Load | SCP0039_ValidationMaster.cs:834 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ if (!this.IsPopup) | DATA_OP | table.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-7740066e | this.Load | SCP0039_ValidationMaster.cs:844 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ else of (!this.IsPopup) ▸ if (isFo… | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6a465f87 | this.Load | SCP0039_ValidationMaster.cs:845 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ else of (!this.IsPopup) ▸ if (isFo… | DATA_OP | dr["VALIDATION_TYPE"] | dtMasterValidation.Rows[i]["SEGMENT2"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-edc09f41 | this.Load | SCP0039_ValidationMaster.cs:846 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ else of (!this.IsPopup) ▸ if (isFo… | DATA_OP | dr["COUNT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8b951f35 | this.Load | SCP0039_ValidationMaster.cs:847 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ else of (!this.IsPopup) ▸ if (isFo… | DATA_OP | dr["IMPACT"] | dtMasterValidation.Rows[i]["ATTRIBUTE3"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c9bb2ddd | this.Load | SCP0039_ValidationMaster.cs:848 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ else of (!this.IsPopup) ▸ if (isFo… | DATA_OP | dr["SHEET_NAME"] | dtMasterValidation.Rows[i]["SEGMENT2"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1cc158ea | this.Load | SCP0039_ValidationMaster.cs:849 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ else of (!this.IsPopup) ▸ if (isFo… | DATA_OP | dr["PROGRAM_ID"] | dtMasterValidation.Rows[i]["SEGMENT4"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4d0fe01b | this.Load | SCP0039_ValidationMaster.cs:850 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ else of (!this.IsPopup) ▸ if (isFo… | DATA_OP | dr["PROCEDURE_NAME"] | dtMasterValidation.Rows[i]["SEGMENT5"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-05a085e5 | this.Load | SCP0039_ValidationMaster.cs:851 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ else of (!this.IsPopup) ▸ if (isFo… | DATA_OP | dr["CONSTRAINTS01"] | dtMasterValidation.Rows[i]["ATTRIBUTE1"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-27f33e3a | this.Load | SCP0039_ValidationMaster.cs:852 | for (i < dtMasterValidation.Rows.Count) ▸ if (dtMasterValidation.Rows[i]["VALID_YN"].ToString() == "Y") ▸ else of (!this.IsPopup) ▸ if (isFo… | DATA_OP | table.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-8dd4ca8f | this.Load | SCP0039_ValidationMaster.cs:859 |  | DATA_OP | ds.Tables.Add | (table) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1ad0ee8 | this.Load | SCP0039_ValidationMaster.cs:861 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2d1c8247 | this.Load | SCP0039_ValidationMaster.cs:862 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-02ce2e76 | this.Load | SCP0039_ValidationMaster.cs:867 | for (i < ds.Tables[0].Rows.Count) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.QUERY)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-c4283946 | this.Load | SCP0039_ValidationMaster.cs:874 | for (nRow < siMain.ActiveSheet.Rows.Count) | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.COUNT), "") | 그리드 값 설정 |  |  |  |
| AC-b2e55868 | this.Load | SCP0039_ValidationMaster.cs:876 | for (nRow < siMain.ActiveSheet.Rows.Count) | GRID_INIT | AddSheet | (spdProjectRouteInfo, sSheetName, sSheetName, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-de4287cf | this.Load | SCP0039_ValidationMaster.cs:878 | for (nRow < siMain.ActiveSheet.Rows.Count) | FLAG | siProjectRoute | GetSheetInfo(spdProjectRouteInfo.Name, sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-614dabf3 | this.Load | SCP0039_ValidationMaster.cs:879 | for (nRow < siMain.ActiveSheet.Rows.Count) | GRID_INIT | siProjectRoute.ChangeSheet | (sSheetName) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0039_ValidationMaster.RefreshPlanGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3509d0d | this.Load 외 1 | SCP0039_ValidationMaster.cs:453 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-7f386b54 | this.Load 외 1 | SCP0039_ValidationMaster.cs:453 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5644aa94 | this.Load 외 1 | SCP0039_ValidationMaster.cs:455 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0039_ValidationMaster.SCP0039_ValidationMaster_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12c87859 | this.FormClosing | SCP0039_ValidationMaster.cs:1349 | if (this.IsPopup && this.isSearch) | FLAG | this.iCriticalCnt | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-23e47a0d | this.FormClosing | SCP0039_ValidationMaster.cs:1350 | if (this.IsPopup && this.isSearch) | FLAG | this.iWarningCnt | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-49ffd119 | this.FormClosing | SCP0039_ValidationMaster.cs:1362 | if (this.IsPopup && this.isSearch) ▸ for (i < siMain.GetMaxRowIndex()) ▸ if (impact == "Critical") | FLAG | this.iCriticalCnt | += iCnt | 화면 필드/플래그 변경 |  |  |  |
| AC-2f5fcffc | this.FormClosing | SCP0039_ValidationMaster.cs:1366 | if (this.IsPopup && this.isSearch) ▸ for (i < siMain.GetMaxRowIndex()) ▸ else of (impact == "Critical") | FLAG | this.iWarningCnt | += iCnt | 화면 필드/플래그 변경 |  |  |  |
| AC-bb45cb62 | this.FormClosing | SCP0039_ValidationMaster.cs:1370 | if (this.IsPopup && this.isSearch) | UI_PROP | this.DialogResult | System.Windows.Forms.DialogResult.OK | 속성 DialogResult 설정 |  |  |  |

## SCP0039_ValidationMaster.SetCalendar

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9dc5e2e8 | (진입점 미연결) | SCP0039_ValidationMaster.cs:1238 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_DEFAULT") ⇒ biz:CommonData.CommonDataList [code=PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ba14e1ed | (진입점 미연결) | SCP0039_ValidationMaster.cs:1243 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1880e6d9 | (진입점 미연결) | SCP0039_ValidationMaster.cs:1255 |  | FLAG | dtCalendar | Data.Common(Data.Type.CalendarMonth, false, MonthText1.Replace("-", ""), MonthText2.Replac… ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 화면 필드/플래그 변경 |  |  |  |
| AC-8e505fdc | (진입점 미연결) | SCP0039_ValidationMaster.cs:1255 |  | COMBO_DATA | Data.Common | (Data.Type.CalendarMonth, false, MonthText1.Replace("-", ""), MonthText2.Replace("-", "")) ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a478b314 | (진입점 미연결) | SCP0039_ValidationMaster.cs:1261 | foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefColumns.YYYYMM) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1c2434d | (진입점 미연결) | SCP0039_ValidationMaster.cs:1262 | foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefColumns.YYYYMM_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ff5dcaa | (진입점 미연결) | SCP0039_ValidationMaster.cs:1264 | foreach (var a in dtCalendar.AsEnumerable()) | GRID_INIT | spreadinfo.AddNumColumn | (sYYYYMM_NAME, sYYYYMM, FPMerge.None, 75, true) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0039_ValidationMaster.SetVisibleSheetColumns

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aacf057f | this.Load | SCP0039_ValidationMaster.cs:463 | if (!this.IsPopup) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.IMPACT, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-874a5694 | this.Load | SCP0039_ValidationMaster.cs:464 | if (!this.IsPopup) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.QUERY, 70, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-14ab9b83 | this.Load | SCP0039_ValidationMaster.cs:465 | if (!this.IsPopup) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.OPEN, 70, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-25f84228 | this.Load | SCP0039_ValidationMaster.cs:469 | else of (!this.IsPopup) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.IMPACT, 70, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c39a533 | this.Load | SCP0039_ValidationMaster.cs:470 | else of (!this.IsPopup) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.QUERY, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9581a418 | this.Load | SCP0039_ValidationMaster.cs:471 | else of (!this.IsPopup) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefColumns.OPEN, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-36ebeb0a | this.Load | SCP0039_ValidationMaster.cs:474 |  | CALL_EXT | SheetUtils.SetColumHide | (siMain) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0039_ValidationMaster.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecdc434e | spdMain.CellClick | SCP0039_ValidationMaster.cs:989 | if (nCol == siMain.GetColumnIndex(DefColumns.QUERY) && !e.ColumnHeader) | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.COUNT), "") | 그리드 값 설정 |  |  |  |
| AC-c9ffd56d | spdMain.CellClick | SCP0039_ValidationMaster.cs:1000 | else of (nCol == siMain.GetColumnIndex(DefColumns.QUERY) && !e.ColumnHeader) ▸ else of (nCol == siMain.GetColumnIndex(DefColumns.OPEN) && !e… | GRID_INIT | siProjectRoute.ChangeSheet | (sSheetName) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e73c327b | spdMain.CellClick | SCP0039_ValidationMaster.cs:1001 | else of (nCol == siMain.GetColumnIndex(DefColumns.QUERY) && !e.ColumnHeader) ▸ else of (nCol == siMain.GetColumnIndex(DefColumns.OPEN) && !e… | GRID_INIT | siProjectRoute.ChangeActiveSheet | (sSheetName) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a12c98b5 | spdMain.CellClick | SCP0039_ValidationMaster.cs:1011 |  | STATE | cboDivision.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dee09e69 | spdMain.CellClick | SCP0039_ValidationMaster.cs:1012 |  | STATE | clbPlanGroup.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-83e129db | spdMain.CellClick | SCP0039_ValidationMaster.cs:1013 |  | STATE | txtItemId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-305dbb13 | spdMain.CellClick | SCP0039_ValidationMaster.cs:1014 |  | STATE | btnItemId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0a33a9d4 | spdMain.CellClick | SCP0039_ValidationMaster.cs:1027 | if (!string.IsNullOrEmpty(sDiv)) ▸ foreach (string sPart in result) ▸ if (sPart.Equals("Division")) | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e4f224f2 | spdMain.CellClick | SCP0039_ValidationMaster.cs:1032 | if (!string.IsNullOrEmpty(sDiv)) ▸ foreach (string sPart in result) ▸ if (sPart.Equals("PlanGroup")) | STATE | clbPlanGroup.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f81e4830 | spdMain.CellClick | SCP0039_ValidationMaster.cs:1036 | if (!string.IsNullOrEmpty(sDiv)) ▸ foreach (string sPart in result) ▸ if (sPart.Equals("Name")) | STATE | txtItemId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8469f064 | spdMain.CellClick | SCP0039_ValidationMaster.cs:1037 | if (!string.IsNullOrEmpty(sDiv)) ▸ foreach (string sPart in result) ▸ if (sPart.Equals("Name")) | STATE | btnItemId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0039_ValidationMaster.SpdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5a9bd99 | (진입점 미연결) | SCP0039_ValidationMaster.cs:1056 | if (nCol == siMain.GetColumnIndex(DefColumns.COUNT) && !e.ColumnHeader) | CALL_EXT | Convert.ToInt64 | (cnt) | ⚠ 의미 확인 필요 |  |  |  |


# AS-IS 액션 대조표 — DM0036

> 원천: `Doc/asisfacts/screens/DM0036/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 218행 · 메서드 20 · 종류 DATA_OP 72 · UI_PROP 29 · UI_MISC 19 · POPUP 17 · GRID_INIT 10 · ENDPOINT 10 · RETURN 10 · GRID_SET 8 · MESSAGE 8 · FLAG 6 · CALL_EXT 6 · GRID_LOCK 5 · VALUE_SET 3 · VALIDATE 3 · LIST_REBIND 3 · GRID_CLEAR 2 · GRID_BIND 2 · COMBO_DATA 2 · GRID_STYLE 2 · STATE 1 · ⚠ 의미 확인 필요 6


## DM0036_Capacity_Allocation..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30c891dc | .ctor | DM0036_Capacity_Allocation.cs:94 |  | FLAG | division_id | "40" | 화면 필드/플래그 변경 |  |  |  |

## DM0036_Capacity_Allocation.btnDelete_Click

진입점: this.btnDelete.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61624686 | this.btnDelete.Click | DM0036_Capacity_Allocation.cs:282 |  | POPUP | new SCM0002_CapacityAllocationPopup | () | 팝업/폼 생성 |  |  |  |
| AC-794d9166 | this.btnDelete.Click | DM0036_Capacity_Allocation.cs:283 |  | POPUP | popItem.Form_Load | (pDivisionID.ToString(), "D") | 팝업 초기화(인자 전달) |  |  |  |
| AC-24eb6be2 | this.btnDelete.Click | DM0036_Capacity_Allocation.cs:284 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c74b4c18 | this.btnDelete.Click | DM0036_Capacity_Allocation.cs:285 |  | UI_PROP | popItem.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-d1c60206 | this.btnDelete.Click | DM0036_Capacity_Allocation.cs:286 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0036_Capacity_Allocation.btnInput_Click

진입점: this.btnInput.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-612d2edd | this.btnInput.Click | DM0036_Capacity_Allocation.cs:262 |  | POPUP | new SCM0002_CapacityAllocationPopup | () | 팝업/폼 생성 |  |  |  |
| AC-bd848b99 | this.btnInput.Click | DM0036_Capacity_Allocation.cs:263 |  | POPUP | popItem.Form_Load | (pDivisionID.ToString(), "I") | 팝업 초기화(인자 전달) |  |  |  |
| AC-8bb61f8d | this.btnInput.Click | DM0036_Capacity_Allocation.cs:264 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2cdff758 | this.btnInput.Click | DM0036_Capacity_Allocation.cs:265 |  | UI_PROP | popItem.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-b48a4f0b | this.btnInput.Click | DM0036_Capacity_Allocation.cs:266 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0036_Capacity_Allocation.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43cafb1c | this.btnItemId.Click | DM0036_Capacity_Allocation.cs:306 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-b84e579c | this.btnItemId.Click | DM0036_Capacity_Allocation.cs:308 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-bdc56b8f | this.btnItemId.Click | DM0036_Capacity_Allocation.cs:309 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-db0d5dd9 | this.btnItemId.Click | DM0036_Capacity_Allocation.cs:310 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8d8251ed | this.btnItemId.Click | DM0036_Capacity_Allocation.cs:316 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DM0036_Capacity_Allocation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8200cc16 | this.Load | DM0036_Capacity_Allocation.cs:159 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dde01bb2 | this.Load | DM0036_Capacity_Allocation.cs:160 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-639a5be7 | this.Load | DM0036_Capacity_Allocation.cs:161 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0036_Capacity_Allocation.DeleteData

진입점: this.btnDelete.Click [if (InputSucs)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-912f55f9 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:434 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e75c8124 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:442 | try | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b469b8b | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:443 | try | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-be2c5665 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:444 | try | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6f6a3b0 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:445 | try | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-4830e133 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:446 | try | DATA_OP | dt.Columns.Add | ("p_yyyymm") | 데이터 객체 조작/조회 |  |  |  |
| AC-adbd6b03 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:447 | try | DATA_OP | dt.Columns.Add | ("p_capacity_rate") | 데이터 객체 조작/조회 |  |  |  |
| AC-6d215987 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:448 | try | DATA_OP | dt.Columns.Add | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-f941e70a | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:449 | try | DATA_OP | dt.Columns.Add | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-f09d0cbe | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:450 | try | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-de29ad8d | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:451 | try | DATA_OP | dt.Columns.Add | ("p_program_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-009c19b4 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:452 | try | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-8aef62fa | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:453 | try | DATA_OP | dt.Columns.Add | ("p_loc_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf435819 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:454 | try | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-94d498c6 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:463 | try ▸ for (i < delItems.Length) | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-00763b05 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:464 | try ▸ for (i < delItems.Length) | DATA_OP | dr["A"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-da7b2580 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:465 | try ▸ for (i < delItems.Length) | DATA_OP | dr["p_active_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-fd9da2fc | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:466 | try ▸ for (i < delItems.Length) | DATA_OP | dr["p_division_id"] | div | 행/컬럼 값 대입 |  |  |  |
| AC-d6fee1f2 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:467 | try ▸ for (i < delItems.Length) | DATA_OP | dr["p_item_id"] | itemId | 행/컬럼 값 대입 |  |  |  |
| AC-f5c0200a | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:468 | try ▸ for (i < delItems.Length) | DATA_OP | dr["p_yyyymm"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6d336a30 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:469 | try ▸ for (i < delItems.Length) | DATA_OP | dr["p_capacity_rate"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-19ba11d8 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:470 | try ▸ for (i < delItems.Length) | DATA_OP | dr["p_project_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dbc7d7c2 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:471 | try ▸ for (i < delItems.Length) | DATA_OP | dr["p_scm_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bba052a0 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:472 | try ▸ for (i < delItems.Length) | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0b9eba82 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:473 | try ▸ for (i < delItems.Length) | DATA_OP | dr["p_program_id"] | "DM0036" | 행/컬럼 값 대입 |  |  |  |
| AC-42f1bcfd | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:474 | try ▸ for (i < delItems.Length) | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-2acb1aea | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:475 | try ▸ for (i < delItems.Length) | DATA_OP | dr["p_loc_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-59890b90 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:476 | try ▸ for (i < delItems.Length) | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f9bc683 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:485 | try ▸ if (iCount > 0) | GRID_SET | dsInput.Tables[0].Rows[0]["p_loc_flag"] | "F" | 그리드 속성/값 설정 |  |  |  |
| AC-5dab464f | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:486 | try ▸ if (iCount > 0) | GRID_SET | dsInput.Tables[0].Rows[nRowCnt - 1]["p_loc_flag"] | "L" | 그리드 속성/값 설정 |  |  |  |
| AC-69f60bb7 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:489 | try ▸ if (iCount > 0) ▸ if (nRowCnt == 1) | GRID_SET | dsInput.Tables[0].Rows[0]["p_loc_flag"] | "A" | 그리드 속성/값 설정 |  |  |  |
| AC-2f0abed8 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:491 | try ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a2f6e96a | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:493 | try ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c1fe5068 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:503 | try ▸ if (iCount > 0) ▸ try ▸ foreach (DataRow row in dsInput.Tables[0].Rows) ▸ switch (row["A"].ToString()) case CAppSetting.FlagI: | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a5452dcf | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:504 | try ▸ if (iCount > 0) ▸ try ▸ foreach (DataRow row in dsInput.Tables[0].Rows) ▸ switch (row["A"].ToString()) case CAppSetting.FlagM: | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f2d00872 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:505 | try ▸ if (iCount > 0) ▸ try ▸ foreach (DataRow row in dsInput.Tables[0].Rows) ▸ switch (row["A"].ToString()) case CAppSetting.FlagD: | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-168d9609 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:509 | try ▸ if (iCount > 0) ▸ try | UI_PROP | request.InsertQueryId | "DM.DM0036_SAVE_CAPACITY_ALLOCATION_RATE" | 속성 InsertQueryId 설정 |  |  |  |
| AC-76e4b2b1 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:510 | try ▸ if (iCount > 0) ▸ try | UI_PROP | request.DeleteQueryId | "DM.DM0036_SAVE_CAPACITY_ALLOCATION_RATE" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-ce010746 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:511 | try ▸ if (iCount > 0) ▸ try | UI_PROP | request.UpdateQueryId | "DM.DM0036_SAVE_CAPACITY_ALLOCATION_RATE" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-af071c4d | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:512 | try ▸ if (iCount > 0) ▸ try | UI_PROP | request.DataSet | dsInput.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-6bc4edd0 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:512 | try ▸ if (iCount > 0) ▸ try | CALL_EXT | dsInput.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b57d41bf | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:515 | try ▸ if (iCount > 0) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-9ed57bca | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:516 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_DM_MASTER_… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ef6e3cec | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:520 | try ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e82ea5c1 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:520 | try ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-b1cace1f | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:523 | try ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-67672b49 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:528 | try ▸ if (iCount > 0) ▸ try ▸ if (t.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00031", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-abc73cdc | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:538 | try ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-282b2913 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:539 | try ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3627ac4 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:543 | try ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ad75ec73 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:549 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ab374ec7 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:550 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9dd74ae3 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:554 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-45541752 | this.btnDelete.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:556 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0036_Capacity_Allocation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-444bfbf6 | Dispose | DM0036_Capacity_Allocation.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0036_Capacity_Allocation.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1e0b830 | EditButton | DM0036_Capacity_Allocation.cs:225 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0f492c10 | EditButton | DM0036_Capacity_Allocation.cs:226 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c925ebda | EditButton | DM0036_Capacity_Allocation.cs:228 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.nIdxData, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-73bedfed | EditButton | DM0036_Capacity_Allocation.cs:242 | for (i < dt.Rows.Count) ▸ if (level == "2" \|\| (level=="1" && dr[DefColumns.PROJECT_CODE].ToString()=="-")) | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.LEVEL) + 1, i, siMain.ActiveSheet.ColumnCount - 1, tr… | 그리드 편집 잠금/해제 |  |  |  |

## DM0036_Capacity_Allocation.FindData

진입점: this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0) ▸ try ▸ if (t.Success)] / FindButton / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try ▸ if (t.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-550a22d7 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:350 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-11486319 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:351 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f08ef110 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:355 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-eff9e647 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:355 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a1d59633 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:359 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7363330e | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:376 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-3fdd57ea | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:378 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_DM_MASTER_SVC)) { var request … | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a1fc401 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:382 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0036_GET_CAPACITY_ALLOCATION_RATE") ⇒ DM.DM0036_GET_CAPACITY_ALLOCATION_RATE | 엔드포인트 요청 생성 |  |  |  |
| AC-3242cbe3 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:384 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1e0104e8 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:386 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-35115a6d | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:387 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | pFromYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-a779c425 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:388 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | pToYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-ac8cbf10 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:389 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-4968235d | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:390 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | pEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-8bf8694c | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:391 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | pSalesSite | 행/컬럼 값 대입 |  |  |  |
| AC-fe0a3c3d | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:392 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-d81b52d4 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:394 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6ceb2384 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:396 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-68ba5c6a | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:403 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-64ef5fca | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:404 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f097c69e | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:407 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d9218ab6 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:409 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4c31f8df | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:410 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d5886db5 | this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0)… 외 2 | DM0036_Capacity_Allocation.cs:425 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DM0036_Capacity_Allocation.FindInput

진입점: this.btnInput.Click [if (InputSucs)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c222c586 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:842 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-4a475aa4 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:844 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-02335f1e | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:847 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-5c7fd6a5 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:847 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2936be23 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:851 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c0ee3dfe | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:862 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-594c14da | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:864 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_DM_MASTER_SVC)) { var request … | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-56b21844 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:868 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0036_GET_CAPACITY_ALLOCATION_RATE_INPUT") ⇒ DM.DM0036_GET_CAPACITY_ALLOCATION_RATE_INPUT | 엔드포인트 요청 생성 |  |  |  |
| AC-c31b623f | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:870 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-41c7e934 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:872 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-bd1ffd70 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:873 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | pFromYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-474a7a22 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:874 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | pToYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-e89ac7a2 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:875 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | itemList | 행/컬럼 값 대입 |  |  |  |
| AC-cd5403f0 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:876 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-0dd76ad2 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:878 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3ec4196b | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:880 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-056c2d32 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:887 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d9461ff3 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:888 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8e4a1c9c | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:891 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8fae625e | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:893 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7e59bf1a | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:894 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c0aa8d02 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:900 | try ▸ else of (siMain.GetMaxRowIndex() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00234") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1dc04db7 | this.btnInput.Click [if (InputSucs)] | DM0036_Capacity_Allocation.cs:912 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DM0036_Capacity_Allocation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3f9a160 | this.Load | DM0036_Capacity_Allocation.cs:99 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0036_Capacity_Allocation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e396ebc | this.Load | DM0036_Capacity_Allocation.cs:134 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-2ec5ba5e | this.Load | DM0036_Capacity_Allocation.cs:136 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a9195366 | this.Load | DM0036_Capacity_Allocation.cs:138 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-55fb7c99 | this.Load | DM0036_Capacity_Allocation.cs:139 |  | VALUE_SET | cboDivision.ControlValues | this.division_id | 컨트롤 값 설정 |  |  |  |
| AC-e16720c5 | this.Load | DM0036_Capacity_Allocation.cs:140 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8a800e54 | this.Load | DM0036_Capacity_Allocation.cs:142 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6a6a3397 | this.Load | DM0036_Capacity_Allocation.cs:143 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-722717a0 | this.Load | DM0036_Capacity_Allocation.cs:150 |  | UI_PROP | drpPeriod.MonthText2 | toDate | 속성 MonthText2 설정 |  |  |  |
| AC-7acb80c1 | this.Load | DM0036_Capacity_Allocation.cs:152 |  | UI_PROP | drpPeriod.MonthMin1 | strStartYYYYMM + "01" | 속성 MonthMin1 설정 |  |  |  |
| AC-0f686353 | this.Load | DM0036_Capacity_Allocation.cs:153 |  | UI_PROP | drpPeriod.MonthMax1 | strStartYYYYMM + "01" | 속성 MonthMax1 설정 |  |  |  |

## DM0036_Capacity_Allocation.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32081d27 | this.Load | DM0036_Capacity_Allocation.cs:118 |  | FLAG | dsdm | (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Dat… | 화면 필드/플래그 변경 |  |  |  |

## DM0036_Capacity_Allocation.InitSpread

진입점: this.Load / this.btnInput.Click [if (InputSucs) ▸ try] / this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try] / FindButton [try] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try ▸ if (t.Success) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fffdc6f | this.Load 외 4 | DM0036_Capacity_Allocation.cs:170 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b70c4e3f | this.Load 외 4 | DM0036_Capacity_Allocation.cs:171 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-54cce88c | this.Load 외 4 | DM0036_Capacity_Allocation.cs:174 | if (spreadInfo.SheetName == SpdSheet.shtMain) | UI_PROP | spreadInfo.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |

## DM0036_Capacity_Allocation.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46c258fb | SaveButton | DM0036_Capacity_Allocation.cs:564 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0a95f2b8 | SaveButton | DM0036_Capacity_Allocation.cs:570 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5bf95766 | SaveButton | DM0036_Capacity_Allocation.cs:577 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c83f8fe6 | SaveButton | DM0036_Capacity_Allocation.cs:578 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3da704d | SaveButton | DM0036_Capacity_Allocation.cs:579 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-d463472c | SaveButton | DM0036_Capacity_Allocation.cs:580 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-40bff1ea | SaveButton | DM0036_Capacity_Allocation.cs:581 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_yyyymm") | 데이터 객체 조작/조회 |  |  |  |
| AC-016302dc | SaveButton | DM0036_Capacity_Allocation.cs:582 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_capacity_rate") | 데이터 객체 조작/조회 |  |  |  |
| AC-359f6052 | SaveButton | DM0036_Capacity_Allocation.cs:583 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-68028f84 | SaveButton | DM0036_Capacity_Allocation.cs:584 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b33d20fe | SaveButton | DM0036_Capacity_Allocation.cs:585 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-848c5e65 | SaveButton | DM0036_Capacity_Allocation.cs:586 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_program_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-e4be67fe | SaveButton | DM0036_Capacity_Allocation.cs:587 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-b7470830 | SaveButton | DM0036_Capacity_Allocation.cs:588 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_loc_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-9509974f | SaveButton | DM0036_Capacity_Allocation.cs:590 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-58f9b2c9 | SaveButton | DM0036_Capacity_Allocation.cs:624 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bcd691d7 | SaveButton | DM0036_Capacity_Allocation.cs:625 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-45ca178c | SaveButton | DM0036_Capacity_Allocation.cs:626 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-0e260bf5 | SaveButton | DM0036_Capacity_Allocation.cs:627 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a04ba335 | SaveButton | DM0036_Capacity_Allocation.cs:628 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f06b2c7c | SaveButton | DM0036_Capacity_Allocation.cs:629 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_yyyymm"] | strMonthName | 행/컬럼 값 대입 |  |  |  |
| AC-16cf8bdf | SaveButton | DM0036_Capacity_Allocation.cs:630 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_capacity_rate"] | strMonthRate | 행/컬럼 값 대입 |  |  |  |
| AC-c5bf6042 | SaveButton | DM0036_Capacity_Allocation.cs:631 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ebfbfbf6 | SaveButton | DM0036_Capacity_Allocation.cs:632 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_scm_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-173ec932 | SaveButton | DM0036_Capacity_Allocation.cs:633 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-985cb9f9 | SaveButton | DM0036_Capacity_Allocation.cs:634 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_program_id"] | "DM0036" | 행/컬럼 값 대입 |  |  |  |
| AC-eb698906 | SaveButton | DM0036_Capacity_Allocation.cs:635 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-325fdae5 | SaveButton | DM0036_Capacity_Allocation.cs:636 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_loc_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d7f503e | SaveButton | DM0036_Capacity_Allocation.cs:637 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-c14e9edb | SaveButton | DM0036_Capacity_Allocation.cs:650 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00230", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1b8fa41f | SaveButton | DM0036_Capacity_Allocation.cs:669 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) | GRID_SET | dsInput.Tables[0].Rows[0]["p_loc_flag"] | "F" | 그리드 속성/값 설정 |  |  |  |
| AC-48455caa | SaveButton | DM0036_Capacity_Allocation.cs:670 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) | GRID_SET | dsInput.Tables[0].Rows[nRowCnt - 1]["p_loc_flag"] | "L" | 그리드 속성/값 설정 |  |  |  |
| AC-f17f1917 | SaveButton | DM0036_Capacity_Allocation.cs:673 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ if (nRowCnt==1) | GRID_SET | dsInput.Tables[0].Rows[0]["p_loc_flag"] | "A" | 그리드 속성/값 설정 |  |  |  |
| AC-900636d2 | SaveButton | DM0036_Capacity_Allocation.cs:675 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8ae0e72f | SaveButton | DM0036_Capacity_Allocation.cs:677 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-789f24a3 | SaveButton | DM0036_Capacity_Allocation.cs:688 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try ▸ foreach (DataRow row in dsInp… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff669541 | SaveButton | DM0036_Capacity_Allocation.cs:689 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try ▸ foreach (DataRow row in dsInp… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce0d4079 | SaveButton | DM0036_Capacity_Allocation.cs:690 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try ▸ foreach (DataRow row in dsInp… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-05b393c4 | SaveButton | DM0036_Capacity_Allocation.cs:694 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try | UI_PROP | request.InsertQueryId | "DM.DM0036_SAVE_CAPACITY_ALLOCATION_RATE" | 속성 InsertQueryId 설정 |  |  |  |
| AC-8f34269d | SaveButton | DM0036_Capacity_Allocation.cs:695 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try | UI_PROP | request.DeleteQueryId | "DM.DM0036_SAVE_CAPACITY_ALLOCATION_RATE" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-49976053 | SaveButton | DM0036_Capacity_Allocation.cs:696 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try | UI_PROP | request.UpdateQueryId | "DM.DM0036_SAVE_CAPACITY_ALLOCATION_RATE" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-0f23eda6 | SaveButton | DM0036_Capacity_Allocation.cs:697 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try | UI_PROP | request.DataSet | dsInput.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-97d9924f | SaveButton | DM0036_Capacity_Allocation.cs:697 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try | CALL_EXT | dsInput.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2bf85c49 | SaveButton | DM0036_Capacity_Allocation.cs:700 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-17b80bf5 | SaveButton | DM0036_Capacity_Allocation.cs:701 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_DM_MASTER_… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8cc4a9b7 | SaveButton | DM0036_Capacity_Allocation.cs:705 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-522eae34 | SaveButton | DM0036_Capacity_Allocation.cs:705 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-fd2f39df | SaveButton | DM0036_Capacity_Allocation.cs:708 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-05ed78cf | SaveButton | DM0036_Capacity_Allocation.cs:713 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try ▸ if (t.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8e0925fe | SaveButton | DM0036_Capacity_Allocation.cs:723 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f6317013 | SaveButton | DM0036_Capacity_Allocation.cs:724 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-269fcdd5 | SaveButton | DM0036_Capacity_Allocation.cs:728 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-837719f9 | SaveButton | DM0036_Capacity_Allocation.cs:737 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3a7b42d0 | SaveButton | DM0036_Capacity_Allocation.cs:738 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e2878823 | SaveButton | DM0036_Capacity_Allocation.cs:742 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DM0036_Capacity_Allocation.SetCalendar

진입점: this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] / this.btnInput.Click [if (InputSucs) ▸ try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try ▸ if (t.Success) ▸ try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33f916f1 | this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] 외 4 | DM0036_Capacity_Allocation.cs:182 |  | FLAG | dtCalendar | Data.Common(Data.Type.CalendarMonth, false, drpPeriod.MonthText1.Replace("-", ""), drpPeri… ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 화면 필드/플래그 변경 |  |  |  |
| AC-37cec57a | this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] 외 4 | DM0036_Capacity_Allocation.cs:182 |  | COMBO_DATA | Data.Common | (Data.Type.CalendarMonth, false, drpPeriod.MonthText1.Replace("-", ""), drpPeriod.MonthTex… ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9ab920ba | this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] 외 4 | DM0036_Capacity_Allocation.cs:188 | foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefColumns.YYYYMM) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ef1438c | this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] 외 4 | DM0036_Capacity_Allocation.cs:189 | foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefColumns.YYYYMM_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-f86914cb | this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] 외 4 | DM0036_Capacity_Allocation.cs:191 | foreach (var a in dtCalendar.AsEnumerable()) | GRID_INIT | spreadinfo.AddNumColumn | (sYYYYMM_NAME, sYYYYMM, FPMerge.None, 75, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1300fea3 | this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] 외 4 | DM0036_Capacity_Allocation.cs:192 | foreach (var a in dtCalendar.AsEnumerable()) | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(sYYYYMM), 0, 2, 100) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0036_Capacity_Allocation.SetChangedPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b64d1c21 | this.Load | DM0036_Capacity_Allocation.cs:793 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7b16f967 | this.Load | DM0036_Capacity_Allocation.cs:796 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d57b9b87 | this.Load | DM0036_Capacity_Allocation.cs:800 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.MonthText1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthText1 설정 |  |  |  |
| AC-de2b2f90 | this.Load | DM0036_Capacity_Allocation.cs:801 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.MonthText2 | dt.Rows[0]["TO_VALUE"].ToString().Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |

## DM0036_Capacity_Allocation.spdMain_Change

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d68e8f84 | dsdm.Changed | DM0036_Capacity_Allocation.cs:921 | if (!this.CanModelChange \|\| e.Row == -1 \|\| e.Column == 0 \|\| e.Column == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b51372b | dsdm.Changed | DM0036_Capacity_Allocation.cs:922 | if (siMain.ActiveSheet.Columns[e.Column].Tag.ToString().IndexOf("M_") < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1503adf | dsdm.Changed | DM0036_Capacity_Allocation.cs:935 | else of (siMain.GetValue(nRow, nCol).ToString() != "") | GRID_SET | siMain.SetValue | (nRow, nCol, 0) | 그리드 값 설정 |  |  |  |
| AC-d17d9faa | dsdm.Changed | DM0036_Capacity_Allocation.cs:961 | if (colSum > 100) | GRID_INIT | siMain.SetReNumerCellType | (siMain, sumRow, nCol, 0, 2, (long)(colSum+1)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1664b4b0 | dsdm.Changed | DM0036_Capacity_Allocation.cs:963 |  | GRID_SET | siMain.SetValue | (sumRow, nCol, colSum) | 그리드 값 설정 |  |  |  |
| AC-5274512f | dsdm.Changed | DM0036_Capacity_Allocation.cs:966 | if (colSum != 100) | GRID_STYLE | siMain.SetFGColor2 | (sumRow, nCol, sumRow, nCol, Color.Red) | 그리드 표시 설정 |  |  |  |
| AC-1f26e994 | dsdm.Changed | DM0036_Capacity_Allocation.cs:968 | else of (colSum != 100) | GRID_STYLE | siMain.SetFGColor2 | (sumRow, nCol, sumRow, nCol, Color.Black) | 그리드 표시 설정 |  |  |  |

## DM0036_Capacity_Allocation.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f6cd987 | this.spdMain.TopChange | DM0036_Capacity_Allocation.cs:199 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0036_Capacity_Allocation.TotalMerge

진입점: this.btnInput.Click [if (InputSucs) ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / this.btnDelete.Click [if (InputSucs) ▸ try ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / FindButton [try ▸ if (siMain.GetMaxRowIndex() > 0)] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount>0) ▸ try ▸ if (t.Success) ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d14899ec | this.btnInput.Click [if (InputSucs) ▸ try ▸ if (siMain.GetMa… 외 3 | DM0036_Capacity_Allocation.cs:819 | for (i < dt.Rows.Count) ▸ if (level == "2") | VALUE_SET | cells.Text | "Total" | 컨트롤 값 설정 |  |  |  |
| AC-89e50d6a | this.btnInput.Click [if (InputSucs) ▸ try ▸ if (siMain.GetMa… 외 3 | DM0036_Capacity_Allocation.cs:820 | for (i < dt.Rows.Count) ▸ if (level == "2") | UI_PROP | cells.ColumnSpan | 4 | 속성 ColumnSpan 설정 |  |  |  |
| AC-de074298 | this.btnInput.Click [if (InputSucs) ▸ try ▸ if (siMain.GetMa… 외 3 | DM0036_Capacity_Allocation.cs:821 | for (i < dt.Rows.Count) ▸ if (level == "2") | UI_PROP | cells.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-7bf13346 | this.btnInput.Click [if (InputSucs) ▸ try ▸ if (siMain.GetMa… 외 3 | DM0036_Capacity_Allocation.cs:822 | for (i < dt.Rows.Count) ▸ if (level == "2") | UI_PROP | cells.BackColor | Color.LightGray | 속성 BackColor 설정 |  |  |  |
| AC-5a676ec3 | this.btnInput.Click [if (InputSucs) ▸ try ▸ if (siMain.GetMa… 외 3 | DM0036_Capacity_Allocation.cs:823 | for (i < dt.Rows.Count) ▸ if (level == "2") | UI_PROP | cells.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |


# AS-IS 액션 대조표 — SCP0109

> 원천: `Doc/asisfacts/screens/SCP0109/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 102행 · 메서드 34 · 종류 DATA_OP 33 · RETURN 20 · CALL_EXT 9 · UI_PROP 9 · UI_MISC 5 · ENDPOINT 4 · LIST_REBIND 4 · FLAG 3 · GRID_LOCK 3 · MESSAGE 3 · GRID_INIT 3 · VALIDATE 3 · GRID_BIND 1 · STATE_RESET 1 · GRID_SET 1 · ⚠ 의미 확인 필요 9


## SCP0109_CAPA_Version.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a80778d4 | (진입점 미연결) | SCP0109_CAPA_Version.cs:539 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-50933751 | (진입점 미연결) | SCP0109_CAPA_Version.cs:541 |  | FLAG | _tblOriginal | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-48f15653 | (진입점 미연결) | SCP0109_CAPA_Version.cs:541 |  | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-75c51c2c | (진입점 미연결) | SCP0109_CAPA_Version.cs:543 |  | CALL_EXT | siMain.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b42a1014 | (진입점 미연결) | SCP0109_CAPA_Version.cs:545 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5427bdb0 | (진입점 미연결) | SCP0109_CAPA_Version.cs:548 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b503a73c | (진입점 미연결) | SCP0109_CAPA_Version.cs:552 | if (this.IsEditMode) | UI_PROP | this.IsEditMode | false | 속성 IsEditMode 설정 |  |  |  |

## SCP0109_CAPA_Version.AfterSaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f7a0595 | (진입점 미연결) | SCP0109_CAPA_Version.cs:562 | if (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Tables[0].Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f0ffa1ba | (진입점 미연결) | SCP0109_CAPA_Version.cs:570 | else of (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0109_CAPA_Version.CheckChangedValues

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ac75f72 | SaveButton | SCP0109_CAPA_Version.cs:488 | else of (_si.ActiveSheet.RowCount != _tblOriginal.Rows.Count) ▸ for (r <= _si.ActiveSheet.RowCount - 1) ▸ for (c <= _si.ActiveSheet.ColumnCo… | DATA_OP | _tblOriginal.Columns.Contains | (colName) | 데이터 객체 조작/조회 |  |  |  |
| AC-c30e7d70 | SaveButton | SCP0109_CAPA_Version.cs:501 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0109_CAPA_Version.CheckNameOnDummyCodeDB

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cd1aae6 | (진입점 미연결) | SCP0109_CAPA_Version.cs:353 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0104_CHECK_NAME_ON_DUMMY_CODE") ⇒ SCP.SCP0104_CHECK_NAME_ON_DUMMY_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-b6f0e29a | (진입점 미연결) | SCP0109_CAPA_Version.cs:355 | try | DATA_OP | request.Parameters["p_code_tp"] | codeType | 행/컬럼 값 대입 |  |  |  |
| AC-9cca09ff | (진입점 미연결) | SCP0109_CAPA_Version.cs:356 | try | DATA_OP | request.Parameters["p_name"] | name | 행/컬럼 값 대입 |  |  |  |
| AC-ff58aab2 | (진입점 미연결) | SCP0109_CAPA_Version.cs:357 | try | DATA_OP | request.Parameters["p_program_id"] | "SCP0104" | 행/컬럼 값 대입 |  |  |  |
| AC-755efb31 | (진입점 미연결) | SCP0109_CAPA_Version.cs:358 | try | DATA_OP | request.Parameters["p_sheet_name"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-8fab8645 | (진입점 미연결) | SCP0109_CAPA_Version.cs:359 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-75bd81da | (진입점 미연결) | SCP0109_CAPA_Version.cs:360 | try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-63e073cf | (진입점 미연결) | SCP0109_CAPA_Version.cs:362 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9d515438 | (진입점 미연결) | SCP0109_CAPA_Version.cs:382 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0109_CAPA_Version.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a47f9de1 | (진입점 미연결) | SCP0109_CAPA_Version.cs:300 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-beee5feb | (진입점 미연결) | SCP0109_CAPA_Version.cs:301 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0109_CAPA_Version.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67faf0f2 | this.Load | SCP0109_CAPA_Version.cs:307 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5068f2d7 | this.Load | SCP0109_CAPA_Version.cs:308 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |

## SCP0109_CAPA_Version.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64fdbb86 | DeleteButton | SCP0109_CAPA_Version.cs:445 | if (spdMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47c014dd | DeleteButton | SCP0109_CAPA_Version.cs:448 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a8b152d | DeleteButton | SCP0109_CAPA_Version.cs:451 | if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b2f5f9a | DeleteButton | SCP0109_CAPA_Version.cs:458 | if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0109_CAPA_Version.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b73e85eb | Dispose | SCP0109_CAPA_Version.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0109_CAPA_Version.Edit_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a6628f0 | InsertButton | SCP0109_CAPA_Version.cs:666 |  | DATA_OP | dic.Add | (DefColumns.DIVISION_ID, _division) | 데이터 객체 조작/조회 |  |  |  |
| AC-d63543b7 | InsertButton | SCP0109_CAPA_Version.cs:673 | if (action == CAppSetting.FlagI) | GRID_SET | siMain.SetValue | (cell, dic) | 그리드 값 설정 |  |  |  |

## SCP0109_CAPA_Version.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f663568b | EditButton | SCP0109_CAPA_Version.cs:424 | if (spdMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c68533f | EditButton | SCP0109_CAPA_Version.cs:426 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-7e0231c6 | EditButton | SCP0109_CAPA_Version.cs:428 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.VER_ID), siMain.GetColumnIndex(DefColumns.DIVISION_ID), … | 그리드 편집 잠금/해제 |  |  |  |
| AC-8b70fcfa | EditButton | SCP0109_CAPA_Version.cs:432 | if (this.IsEditMode) | CALL_EXT | siMain.UnMerge | (spdMain.ActiveSheet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-74212d96 | EditButton | SCP0109_CAPA_Version.cs:436 | else of (this.IsEditMode) | CALL_EXT | siMain.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0109_CAPA_Version.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c21c2664 | FindButton | SCP0109_CAPA_Version.cs:390 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-43a0157f | FindButton | SCP0109_CAPA_Version.cs:391 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0109_CAPA_Version.FindDataMain

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a3e6126 | FindButton | SCP0109_CAPA_Version.cs:653 |  | ENDPOINT | this.ExecuteSQL | (siMain, DIC_GET_CAPA_VERSION, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0109_CAPA_Version.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-103544c3 | this.Load | SCP0109_CAPA_Version.cs:252 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0109_CAPA_Version.getCurrAction

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63931f57 | (진입점 미연결) | SCP0109_CAPA_Version.cs:193 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0109_CAPA_Version.getCurrDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4baee5a4 | (진입점 미연결) | SCP0109_CAPA_Version.cs:213 | try | CALL_EXT | _curr_row.Columns | (DefColumns.DIVISION_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-89d51c2c | (진입점 미연결) | SCP0109_CAPA_Version.cs:219 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0109_CAPA_Version.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-085a02e9 | (진입점 미연결) | SCP0109_CAPA_Version.cs:97 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0109_CAPA_Version.getFromVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-022ffb00 | (진입점 미연결) | SCP0109_CAPA_Version.cs:121 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0109_CAPA_Version.getToVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4be49eb | (진입점 미연결) | SCP0109_CAPA_Version.cs:145 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0109_CAPA_Version.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f377fcfe | this.Load | SCP0109_CAPA_Version.cs:284 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2c6052b3 | this.Load | SCP0109_CAPA_Version.cs:287 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c5122b7 | this.Load | SCP0109_CAPA_Version.cs:290 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |

## SCP0109_CAPA_Version.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a13edf9 | this.Load | SCP0109_CAPA_Version.cs:246 |  | DATA_OP | QueryDics.Add | (DIC_GET_CAPA_VERSION, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-cdce2895 | this.Load | SCP0109_CAPA_Version.cs:247 |  | DATA_OP | QueryDics.Add | (DIC_SAVE_CAPA_VERSION, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0109_CAPA_Version.InitSpread

진입점: this.Load / this.cboFromVersion.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0926eb7f | this.Load 외 2 | SCP0109_CAPA_Version.cs:317 |  | GRID_INIT | siMain.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-7cdfa4cf | this.Load 외 2 | SCP0109_CAPA_Version.cs:318 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0109_CAPA_Version.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bfe8045 | InsertButton | SCP0109_CAPA_Version.cs:686 |  | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0109_CAPA_Version.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d2e104b | InsertButton | SCP0109_CAPA_Version.cs:399 | if (spdMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07a73750 | InsertButton | SCP0109_CAPA_Version.cs:402 | if (siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0109_CAPA_Version.RefreshDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32318f50 | this.Load | SCP0109_CAPA_Version.cs:266 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0109_CAPA_Version.RefreshFromVersion

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a55b1bb0 | this.Load | SCP0109_CAPA_Version.cs:272 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromVersion, cboFromVersion, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0109_CAPA_Version.RefreshSheetHeader

진입점: this.Load / this.cboFromVersion.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c94ae6f | this.Load 외 2 | SCP0109_CAPA_Version.cs:324 |  | CALL_EXT | siMain.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0109_CAPA_Version.RefreshToVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1405a16 | (진입점 미연결) | SCP0109_CAPA_Version.cs:277 |  | LIST_REBIND | clsCtrl.setListBox | (dtToVersion, cboFromVersion, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0109_CAPA_Version.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4810003f | SaveButton | SCP0109_CAPA_Version.cs:507 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23d0a065 | SaveButton | SCP0109_CAPA_Version.cs:511 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bade034b | SaveButton | SCP0109_CAPA_Version.cs:514 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c31a2867 | SaveButton | SCP0109_CAPA_Version.cs:517 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-32d311eb | SaveButton | SCP0109_CAPA_Version.cs:518 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0109_CAPA_Version.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bd8854f | SaveButton | SCP0109_CAPA_Version.cs:706 | if (!CheckChangedValues(ref changedCnt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-115869a3 | SaveButton | SCP0109_CAPA_Version.cs:710 | if (changedCnt == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-79e54443 | SaveButton | SCP0109_CAPA_Version.cs:712 | if (changedCnt == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0109_CAPA_Version.SaveDataMain

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f84899d0 | SaveButton | SCP0109_CAPA_Version.cs:696 |  | ENDPOINT | this.ExecuteSQL | (new List<SpreadInfo>() { _si, _si } , new List<string>() { DIC_SAVE_CAPA_VERSION, DIC_GET… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0109_CAPA_Version.SetLockColumns

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3bd7fec | EditButton | SCP0109_CAPA_Version.cs:410 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2f1172c0 | EditButton | SCP0109_CAPA_Version.cs:417 | finally | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0109_CAPA_Version.SetQueryInfoGet

진입점: FindButton / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d37779e | FindButton 외 1 | SCP0109_CAPA_Version.cs:579 | if (this.QueryDics[DIC_GET_CAPA_VERSION].Count > 0) | CALL_EXT | this.QueryDics[DIC_GET_CAPA_VERSION].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7541ff80 | FindButton 외 1 | SCP0109_CAPA_Version.cs:584 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.BeforeFindData | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-0b047d4c | FindButton 외 1 | SCP0109_CAPA_Version.cs:585 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-1714876d | FindButton 외 1 | SCP0109_CAPA_Version.cs:586 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-19575d2e | FindButton 외 1 | SCP0109_CAPA_Version.cs:587 |  | UI_PROP | qi.QueryId | "SCP.SCP0104_GET_CAPA_VERSION" | 속성 QueryId 설정 |  |  |  |
| AC-e392e5c4 | FindButton 외 1 | SCP0109_CAPA_Version.cs:589 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-44ea7d67 | FindButton 외 1 | SCP0109_CAPA_Version.cs:590 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_version", this._from_version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0a4a617 | FindButton 외 1 | SCP0109_CAPA_Version.cs:591 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_version", this._to_version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ca42178 | FindButton 외 1 | SCP0109_CAPA_Version.cs:592 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0109")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f55cab60 | FindButton 외 1 | SCP0109_CAPA_Version.cs:593 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", "MAIN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b30dda9f | FindButton 외 1 | SCP0109_CAPA_Version.cs:594 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dae766a6 | FindButton 외 1 | SCP0109_CAPA_Version.cs:595 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2782b94d | FindButton 외 1 | SCP0109_CAPA_Version.cs:597 |  | DATA_OP | this.QueryDics[DIC_GET_CAPA_VERSION] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0109_CAPA_Version.SetQueryInfoSave

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec05c3d7 | SaveButton | SCP0109_CAPA_Version.cs:604 | if (this.QueryDics[DIC_SAVE_CAPA_VERSION].Count > 0) | CALL_EXT | this.QueryDics[DIC_SAVE_CAPA_VERSION].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d29cd89 | SaveButton | SCP0109_CAPA_Version.cs:609 |  | UI_PROP | qi.BeforeExecuteSQLProc | null | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-048cb2e3 | SaveButton | SCP0109_CAPA_Version.cs:610 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterSaveData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-4d01a7aa | SaveButton | SCP0109_CAPA_Version.cs:611 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-1c5e3461 | SaveButton | SCP0109_CAPA_Version.cs:612 |  | UI_PROP | qi.QueryId | "SCP.SCP0109_SAVE_CAPA_VERSION" | 속성 QueryId 설정 |  |  |  |
| AC-c4a1cf2c | SaveButton | SCP0109_CAPA_Version.cs:622 |  | CALL_EXT | SheetUtils.GetChangedData | (_si, _tblOriginal) | ⚠ 의미 확인 필요 |  |  |  |
| AC-91ace42b | SaveButton | SCP0109_CAPA_Version.cs:634 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", VER_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8099ece8 | SaveButton | SCP0109_CAPA_Version.cs:635 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", VER_SEQ)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4c955ae | SaveButton | SCP0109_CAPA_Version.cs:636 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", DIVISION_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-94f97b8e | SaveButton | SCP0109_CAPA_Version.cs:637 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_scp_fin_plan_id", SCP_FIN_PLAN_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d38e7bd6 | SaveButton | SCP0109_CAPA_Version.cs:638 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_scp_prdn_plan_ref_st_ym", SCP_PRDN_PLAN_REF_ST_YM)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7144c995 | SaveButton | SCP0109_CAPA_Version.cs:639 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_scp_prdn_plan_ref_end_ym", SCP_PRDN_PLAN_REF_END_YM)) | 데이터 객체 조작/조회 |  |  |  |
| AC-25ef59ef | SaveButton | SCP0109_CAPA_Version.cs:640 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0104")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4619b26 | SaveButton | SCP0109_CAPA_Version.cs:641 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", "MAIN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-52acea73 | SaveButton | SCP0109_CAPA_Version.cs:642 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4e2ae69 | SaveButton | SCP0109_CAPA_Version.cs:643 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6b2451c | SaveButton | SCP0109_CAPA_Version.cs:645 |  | DATA_OP | this.QueryDics[DIC_SAVE_CAPA_VERSION] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0109_CAPA_Version.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8bd4a5f | this.spdMain.TopChange | SCP0109_CAPA_Version.cs:338 |  | CALL_EXT | siMain.RightColMerge2 | () | ⚠ 의미 확인 필요 |  |  |  |


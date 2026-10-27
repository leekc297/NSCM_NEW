# AS-IS 액션 대조표 — SCP0122

> 원천: `Doc/asisfacts/screens/SCP0122/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 102행 · 메서드 19 · 종류 DATA_OP 23 · RETURN 10 · GRID_INIT 8 · FLAG 8 · GRID_LOCK 8 · ENDPOINT 8 · GRID_SET 8 · UI_MISC 7 · MESSAGE 5 · POPUP 4 · UI_PROP 4 · LIST_REBIND 4 · GRID_CLEAR 2 · VALIDATE 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 0


## SCP0122_PlanActivityMgmt.CboPlanGroup_SelectedIndexChanged

진입점: cboPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aac8daf9 | cboPlanGroup.SelectedIndexChanged | SCP0122_PlanActivityMgmt.cs:553 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0122_PlanActivityMgmt.ClbDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54508141 | cboDivision.SelectedIndexChanged | SCP0122_PlanActivityMgmt.cs:548 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0122_PlanActivityMgmt.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9501d7c4 | this.Load | SCP0122_PlanActivityMgmt.cs:185 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-25c64824 | this.Load | SCP0122_PlanActivityMgmt.cs:186 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ccd1669e | this.Load | SCP0122_PlanActivityMgmt.cs:188 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0122_PlanActivityMgmt.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3aecf00 | DeleteButton | SCP0122_PlanActivityMgmt.cs:265 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e969af1c | DeleteButton | SCP0122_PlanActivityMgmt.cs:268 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0122_PlanActivityMgmt.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00c0c1bf | Dispose | SCP0122_PlanActivityMgmt.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0122_PlanActivityMgmt.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da64a917 | EditButton | SCP0122_PlanActivityMgmt.cs:275 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2484872a | EditButton | SCP0122_PlanActivityMgmt.cs:276 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ddb6b334 | EditButton | SCP0122_PlanActivityMgmt.cs:277 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.OPMZ_PLAN… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4309975d | EditButton | SCP0122_PlanActivityMgmt.cs:278 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_CD), siMain.GetColumnIndex(DefColumns.OPMZ_ACT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-93a3ee53 | EditButton | SCP0122_PlanActivityMgmt.cs:279 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LINK_UI_TYPE), siMain.GetColumnIndex(DefColumns.OPTION_Y… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0122_PlanActivityMgmt.FindData_Main

진입점: FindButton / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ada0423 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:296 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3e1806fa | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:299 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-834f6ac8 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:299 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea73b111 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:303 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-160ffa2a | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:306 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d28725e8 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:316 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4d38ecc6 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:317 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-540ba4e7 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:321 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT") ⇒ SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT | 엔드포인트 요청 생성 |  |  |  |
| AC-e6968c6f | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:322 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9d756c73 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:323 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-d8548cf7 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:324 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_group_id"] | p_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-01567f0c | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:325 | try ▸ lambda | DATA_OP | request.Parameters["p_prs_cd"] | p_prs_cd | 행/컬럼 값 대입 |  |  |  |
| AC-8d483814 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:327 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-202c0d4d | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:329 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-037cab0b | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:338 | try ▸ if (ds.Tables.Count > 0) | FLAG | this.dtPlanActivityAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-33d7b397 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:338 | try ▸ if (ds.Tables.Count > 0) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f07a5db4 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:341 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c320c023 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:342 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6f5fe395 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:345 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3f040b21 | FindButton 외 1 | SCP0122_PlanActivityMgmt.cs:355 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0122_PlanActivityMgmt.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5614bab | this.Load | SCP0122_PlanActivityMgmt.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0122_PlanActivityMgmt.GetPlanGroupByUserID

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2df87320 | (진입점 미연결) | SCP0122_PlanActivityMgmt.cs:155 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0121_GET_SEARCH_INFO") ⇒ SCP.SCP0121_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-01ed909b | (진입점 미연결) | SCP0122_PlanActivityMgmt.cs:157 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-91277cc5 | (진입점 미연결) | SCP0122_PlanActivityMgmt.cs:158 |  | DATA_OP | request.Parameters["p_user_id"] | userId | 행/컬럼 값 대입 |  |  |  |
| AC-c1f36737 | (진입점 미연결) | SCP0122_PlanActivityMgmt.cs:161 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e4ae7576 | (진입점 미연결) | SCP0122_PlanActivityMgmt.cs:165 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0122_PlanActivityMgmt.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05ed9e20 | this.Load | SCP0122_PlanActivityMgmt.cs:121 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c5349069 | this.Load | SCP0122_PlanActivityMgmt.cs:124 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-ccc5e938 | this.Load | SCP0122_PlanActivityMgmt.cs:126 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-55f42dda | this.Load | SCP0122_PlanActivityMgmt.cs:127 |  | LIST_REBIND | clsCtrl.setListBox | (dtProcessCdAll, cboProcess, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-487924df | this.Load | SCP0122_PlanActivityMgmt.cs:129 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |

## SCP0122_PlanActivityMgmt.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f458a29 | this.Load | SCP0122_PlanActivityMgmt.cs:197 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-501811fe | this.Load | SCP0122_PlanActivityMgmt.cs:198 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0122_PlanActivityMgmt.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-359cc9f0 | InsertButton | SCP0122_PlanActivityMgmt.cs:364 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-00246693 | InsertButton | SCP0122_PlanActivityMgmt.cs:373 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d4997bf | InsertButton | SCP0122_PlanActivityMgmt.cs:374 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.OPMZ_PRS_CD, p_prs_cd) | 데이터 객체 조작/조회 |  |  |  |
| AC-f519160e | InsertButton | SCP0122_PlanActivityMgmt.cs:375 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.OPMZ_PRS_NAME, p_prs_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c0183e8 | InsertButton | SCP0122_PlanActivityMgmt.cs:376 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.OPMZ_PLAN_GR_ID, p_plan_group_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-dbd3d0f1 | InsertButton | SCP0122_PlanActivityMgmt.cs:377 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.OPMZ_PLAN_GR_NAME, p_plan_group_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-fbdbaad9 | InsertButton | SCP0122_PlanActivityMgmt.cs:379 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-da8fa253 | InsertButton | SCP0122_PlanActivityMgmt.cs:381 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f7f2ff28 | InsertButton | SCP0122_PlanActivityMgmt.cs:382 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_CD), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6b709c05 | InsertButton | SCP0122_PlanActivityMgmt.cs:383 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LINK_UI_TYPE), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0122_PlanActivityMgmt.RefreshPlanGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4cf24d3 | this.Load 외 1 | SCP0122_PlanActivityMgmt.cs:172 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-d340cc04 | this.Load 외 1 | SCP0122_PlanActivityMgmt.cs:172 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ed30926e | this.Load 외 1 | SCP0122_PlanActivityMgmt.cs:174 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, cboPlanGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0122_PlanActivityMgmt.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fc6c5bd | SaveButton | SCP0122_PlanActivityMgmt.cs:389 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6452f949 | SaveButton | SCP0122_PlanActivityMgmt.cs:391 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4f64fc8 | SaveButton | SCP0122_PlanActivityMgmt.cs:435 | for (i <= siMain.GetMaxRowIndex()) ▸ if (actv_cd == string.Empty \|\| actv_seq == string.Empty) | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2d5b6b2a | SaveButton | SCP0122_PlanActivityMgmt.cs:436 | for (i <= siMain.GetMaxRowIndex()) ▸ if (actv_cd == string.Empty \|\| actv_seq == string.Empty) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d4d3c9e | SaveButton | SCP0122_PlanActivityMgmt.cs:453 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ if (dtPlanActivityAll != null) | DATA_OP | DBUtils.Filter | (dtPlanActivityAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2006b5b6 | SaveButton | SCP0122_PlanActivityMgmt.cs:457 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ if (dtPlanActivityAll != null) ▸ if (dtPlanActivity.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00443") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5dfa5206 | SaveButton | SCP0122_PlanActivityMgmt.cs:458 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ if (dtPlanActivityAll != null) ▸ if (dtPlanActivity.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5ca30c5 | SaveButton | SCP0122_PlanActivityMgmt.cs:475 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d861ca32 | SaveButton | SCP0122_PlanActivityMgmt.cs:476 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-beecefff | SaveButton | SCP0122_PlanActivityMgmt.cs:480 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT") ⇒ SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT | 엔드포인트 요청 생성 |  |  |  |
| AC-8c0b154b | SaveButton | SCP0122_PlanActivityMgmt.cs:483 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fef93c02 | SaveButton | SCP0122_PlanActivityMgmt.cs:487 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2eb90aff | SaveButton | SCP0122_PlanActivityMgmt.cs:489 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-3d5f6415 | SaveButton | SCP0122_PlanActivityMgmt.cs:490 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_prs_cd"] | p_prs_cd | 행/컬럼 값 대입 |  |  |  |
| AC-b93f9f8b | SaveButton | SCP0122_PlanActivityMgmt.cs:491 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_plan_gr_id"] | p_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-ceba26f6 | SaveButton | SCP0122_PlanActivityMgmt.cs:492 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_actv_cd"] | p_actv_cd | 행/컬럼 값 대입 |  |  |  |
| AC-7f713d4b | SaveButton | SCP0122_PlanActivityMgmt.cs:493 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_actv_seq"] | p_actv_seq | 행/컬럼 값 대입 |  |  |  |
| AC-d5248886 | SaveButton | SCP0122_PlanActivityMgmt.cs:494 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_actv_cd"] | p_pre_actv_cd | 행/컬럼 값 대입 |  |  |  |
| AC-a177d00c | SaveButton | SCP0122_PlanActivityMgmt.cs:495 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-46ca280d | SaveButton | SCP0122_PlanActivityMgmt.cs:497 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c3102940 | SaveButton | SCP0122_PlanActivityMgmt.cs:497 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-2be52066 | SaveButton | SCP0122_PlanActivityMgmt.cs:501 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fe26d15c | SaveButton | SCP0122_PlanActivityMgmt.cs:508 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c45d88cd | SaveButton | SCP0122_PlanActivityMgmt.cs:517 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ff975ce4 | SaveButton | SCP0122_PlanActivityMgmt.cs:524 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-54d66267 | SaveButton | SCP0122_PlanActivityMgmt.cs:525 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a276a507 | SaveButton | SCP0122_PlanActivityMgmt.cs:529 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0122_PlanActivityMgmt.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-716c30a0 | SaveButton | SCP0122_PlanActivityMgmt.cs:285 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0122_PlanActivityMgmt.SetSpreadInit

진입점: this.Load / FindButton [try] / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-339cf51d | this.Load 외 2 | SCP0122_PlanActivityMgmt.cs:205 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4f9f09d9 | this.Load 외 2 | SCP0122_PlanActivityMgmt.cs:206 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-e5b617f7 | this.Load 외 2 | SCP0122_PlanActivityMgmt.cs:210 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ActivityCode", dtActivityCdAll) | 목록 컨트롤 재구성 |  |  |  |
| AC-155e71d6 | this.Load 외 2 | SCP0122_PlanActivityMgmt.cs:212 |  | GRID_INIT | siObj.SetSheetHeaderColumnSCP | (siObj, 1, false, "") | 그리드 재구성/초기화 |  |  |  |

## SCP0122_PlanActivityMgmt.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd4726a5 | this.spdMain.CellClick | SCP0122_PlanActivityMgmt.cs:558 |  | FLAG | this._currRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |

## SCP0122_PlanActivityMgmt.SpdMain_ClipboardPasted

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-565b3e04 | (진입점 미연결) | SCP0122_PlanActivityMgmt.cs:574 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | DATA_OP | dtPlanGroup.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2df250b3 | (진입점 미연결) | SCP0122_PlanActivityMgmt.cs:576 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID), codeVal) | 그리드 값 설정 |  |  |  |

## SCP0122_PlanActivityMgmt.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca2a3a79 | this.spdMain.ComboSelChange | SCP0122_PlanActivityMgmt.cs:233 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_NAME)) | FLAG | dtActivityCd | DBUtils.Filter(dtActivityCdAll, "CODE = '" + actv_cd + "' ", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-b2a9f2ac | this.spdMain.ComboSelChange | SCP0122_PlanActivityMgmt.cs:233 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_NAME)) | DATA_OP | DBUtils.Filter | (dtActivityCdAll, "CODE = '" + actv_cd + "' ", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-51148eb7 | this.spdMain.ComboSelChange | SCP0122_PlanActivityMgmt.cs:238 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_NAME)) ▸ if (dt… | GRID_SET | siMain.SetValue | (this._currRowIdx, siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_CD), actv_cd) | 그리드 값 설정 |  |  |  |
| AC-fdc53407 | this.spdMain.ComboSelChange | SCP0122_PlanActivityMgmt.cs:239 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_NAME)) ▸ if (dt… | GRID_SET | siMain.SetValue | (this._currRowIdx, siMain.GetColumnIndex(DefColumns.LINK_UI_TYPE), dtActivityCd.Rows[0][De… | 그리드 값 설정 |  |  |  |
| AC-7c765c32 | this.spdMain.ComboSelChange | SCP0122_PlanActivityMgmt.cs:240 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_NAME)) ▸ if (dt… | GRID_SET | siMain.SetValue | (this._currRowIdx, siMain.GetColumnIndex(DefColumns.PROGRAM_NAME), dtActivityCd.Rows[0][De… | 그리드 값 설정 |  |  |  |
| AC-240ba716 | this.spdMain.ComboSelChange | SCP0122_PlanActivityMgmt.cs:241 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_NAME)) ▸ if (dt… | GRID_SET | siMain.SetValue | (this._currRowIdx, siMain.GetColumnIndex(DefColumns.CONFIRM_YN), dtActivityCd.Rows[0][DefC… | 그리드 값 설정 |  |  |  |
| AC-4848d5a2 | this.spdMain.ComboSelChange | SCP0122_PlanActivityMgmt.cs:242 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_NAME)) ▸ if (dt… | GRID_SET | siMain.SetValue | (this._currRowIdx, siMain.GetColumnIndex(DefColumns.AUTO_YN), dtActivityCd.Rows[0][DefColu… | 그리드 값 설정 |  |  |  |
| AC-7370bbe5 | this.spdMain.ComboSelChange | SCP0122_PlanActivityMgmt.cs:243 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_NAME)) ▸ if (dt… | GRID_SET | siMain.SetValue | (this._currRowIdx, siMain.GetColumnIndex(DefColumns.OPTION_YN), dtActivityCd.Rows[0][DefCo… | 그리드 값 설정 |  |  |  |


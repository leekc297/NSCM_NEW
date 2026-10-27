# AS-IS 액션 대조표 — SCP0110

> 원천: `Doc/asisfacts/screens/SCP0110/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 205행 · 메서드 23 · 종류 DATA_OP 51 · ENDPOINT 18 · GRID_INIT 17 · POPUP 16 · RETURN 16 · UI_MISC 15 · UI_PROP 13 · MESSAGE 13 · FLAG 12 · GRID_LOCK 9 · CALL_EXT 6 · VALIDATE 4 · GRID_BIND 4 · LIST_REBIND 4 · COMBO_DATA 3 · VALUE_SET 2 · STATE_RESET 1 · GRID_SET 1 · ⚠ 의미 확인 필요 6


## SCP0110_GroupModelMapping.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-492231e1 | this.btnItemId.Click | SCP0110_GroupModelMapping.cs:1000 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8ab2e152 | this.btnItemId.Click | SCP0110_GroupModelMapping.cs:1002 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-25f7df4a | this.btnItemId.Click | SCP0110_GroupModelMapping.cs:1003 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-135fa559 | this.btnItemId.Click | SCP0110_GroupModelMapping.cs:1004 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9944810c | this.btnItemId.Click | SCP0110_GroupModelMapping.cs:1010 | if (popItem.ItemID != string.Empty) | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0110_GroupModelMapping.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be2e59e7 | this.btnProject.Click | SCP0110_GroupModelMapping.cs:979 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7eafda3b | this.btnProject.Click | SCP0110_GroupModelMapping.cs:980 |  | POPUP | popItem.Form_Load | (true, division, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c697a446 | this.btnProject.Click | SCP0110_GroupModelMapping.cs:981 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d332984d | this.btnProject.Click | SCP0110_GroupModelMapping.cs:982 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-06dcff3b | this.btnProject.Click | SCP0110_GroupModelMapping.cs:988 | if (popItem.ProjectCode != string.Empty) | VALUE_SET | txtProject.Text | sProject | 컨트롤 값 설정 |  |  |  |

## SCP0110_GroupModelMapping.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58f4b8af | this.Load | SCP0110_GroupModelMapping.cs:243 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3c4d5d85 | this.Load | SCP0110_GroupModelMapping.cs:244 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1901dd32 | this.Load | SCP0110_GroupModelMapping.cs:247 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5df7ac5b | this.Load | SCP0110_GroupModelMapping.cs:249 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-afc8f81a | this.Load | SCP0110_GroupModelMapping.cs:251 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51da17d2 | this.Load | SCP0110_GroupModelMapping.cs:254 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8828f53c | this.Load | SCP0110_GroupModelMapping.cs:258 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0110_GroupModelMapping.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be190c23 | this.Load | SCP0110_GroupModelMapping.cs:152 |  | FLAG | dtLineByOperationOfSpdAll | Data.Common(Data.Type.LineByOperation, false, division, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-735b3377 | this.Load | SCP0110_GroupModelMapping.cs:152 |  | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-451ccb0d | this.Load | SCP0110_GroupModelMapping.cs:154 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-b5e8cded | this.Load | SCP0110_GroupModelMapping.cs:156 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-69a24fb1 | this.Load | SCP0110_GroupModelMapping.cs:157 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-2ff8b771 | this.Load | SCP0110_GroupModelMapping.cs:158 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SCP0110_GroupModelMapping.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f65dee7 | DeleteButton | SCP0110_GroupModelMapping.cs:322 | if (fps != null) ▸ if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0110_GroupModelMapping.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9224a5f3 | Dispose | SCP0110_GroupModelMapping.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0110_GroupModelMapping.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cea2cd3c | EditButton | SCP0110_GroupModelMapping.cs:333 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0ef62130 | EditButton | SCP0110_GroupModelMapping.cs:334 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e2120625 | EditButton | SCP0110_GroupModelMapping.cs:338 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.GROUP_ID)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d34089c0 | EditButton | SCP0110_GroupModelMapping.cs:345 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a2f8fa74 | EditButton | SCP0110_GroupModelMapping.cs:346 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-156fd00d | EditButton | SCP0110_GroupModelMapping.cs:349 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-733da492 | EditButton | SCP0110_GroupModelMapping.cs:350 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e906b2f2 | EditButton | SCP0110_GroupModelMapping.cs:354 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.DIVISION_ID), siSub.GetColumnIndex(DefColumns.ITEM_ID), t… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0110_GroupModelMapping.FindData_Main

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6728b31d | (진입점 미연결) | SCP0110_GroupModelMapping.cs:475 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-38e67e16 | (진입점 미연결) | SCP0110_GroupModelMapping.cs:479 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-89c09c33 | (진입점 미연결) | SCP0110_GroupModelMapping.cs:479 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62c67f67 | (진입점 미연결) | SCP0110_GroupModelMapping.cs:482 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e32ac5dc | (진입점 미연결) | SCP0110_GroupModelMapping.cs:493 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ea5c9e5c | (진입점 미연결) | SCP0110_GroupModelMapping.cs:494 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8b91baae | (진입점 미연결) | SCP0110_GroupModelMapping.cs:498 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0110_GET_GROUP_MASTER") ⇒ SCP.SCP0110_GET_GROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-ae2f1c3a | (진입점 미연결) | SCP0110_GroupModelMapping.cs:499 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-333cf5e3 | (진입점 미연결) | SCP0110_GroupModelMapping.cs:500 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d0b78678 | (진입점 미연결) | SCP0110_GroupModelMapping.cs:501 | try ▸ lambda | DATA_OP | request.Parameters["p_group_name"] | p_group_name | 행/컬럼 값 대입 |  |  |  |
| AC-0bd52af0 | (진입점 미연결) | SCP0110_GroupModelMapping.cs:503 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5e7b6d45 | (진입점 미연결) | SCP0110_GroupModelMapping.cs:505 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-627b08d8 | (진입점 미연결) | SCP0110_GroupModelMapping.cs:512 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2d6d6924 | (진입점 미연결) | SCP0110_GroupModelMapping.cs:513 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b940228d | (진입점 미연결) | SCP0110_GroupModelMapping.cs:516 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5af565b1 | (진입점 미연결) | SCP0110_GroupModelMapping.cs:519 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4ecf299f | (진입점 미연결) | SCP0110_GroupModelMapping.cs:535 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0110_GroupModelMapping.FindData_Main_Sub

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a70c048d | FindButton 외 1 | SCP0110_GroupModelMapping.cs:371 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2232c61c | FindButton 외 1 | SCP0110_GroupModelMapping.cs:375 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-40d3bc85 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:375 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c87766d6 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:378 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-983fdbbf | FindButton 외 1 | SCP0110_GroupModelMapping.cs:392 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-10c11dc3 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:393 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0420788c | FindButton 외 1 | SCP0110_GroupModelMapping.cs:397 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0110_GET_GROUP_MASTER") ⇒ SCP.SCP0110_GET_GROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-9a207e7d | FindButton 외 1 | SCP0110_GroupModelMapping.cs:398 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3ff48e2b | FindButton 외 1 | SCP0110_GroupModelMapping.cs:399 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-dde225dd | FindButton 외 1 | SCP0110_GroupModelMapping.cs:400 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-f7daf501 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:401 | try ▸ lambda | DATA_OP | request.Parameters["p_group_name"] | p_group_name | 행/컬럼 값 대입 |  |  |  |
| AC-cffbc8ff | FindButton 외 1 | SCP0110_GroupModelMapping.cs:403 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6ab96879 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:405 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8d338f27 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:412 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1def0cec | FindButton 외 1 | SCP0110_GroupModelMapping.cs:413 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-03d790e6 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:416 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-019c10cf | FindButton 외 1 | SCP0110_GroupModelMapping.cs:419 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4bd56798 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:434 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0110_GET_MODEL_LIST") ⇒ SCP.SCP0110_GET_MODEL_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-26944cd4 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:435 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-869ea0f3 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:436 | try | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-467f1ea8 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:437 | try | DATA_OP | request.Parameters["p_group_id"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-10195cca | FindButton 외 1 | SCP0110_GroupModelMapping.cs:438 | try | DATA_OP | request.Parameters["p_group_name"] | p_group_name | 행/컬럼 값 대입 |  |  |  |
| AC-ca3bda00 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:439 | try | DATA_OP | request.Parameters["p_project_id"] | p_project_id | 행/컬럼 값 대입 |  |  |  |
| AC-10701711 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:440 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-935cd8c3 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:442 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c953488 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:450 | try | GRID_BIND | siSub.Query | (dsSub) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8ffd2559 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:451 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-310552e1 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:454 | try | UI_MISC | SetSearchCount | (dsSub) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8e3698e5 | FindButton 외 1 | SCP0110_GroupModelMapping.cs:457 | try | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-472ba9ff | FindButton 외 1 | SCP0110_GroupModelMapping.cs:469 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0110_GroupModelMapping.FindData_Sub

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75facfac | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:546 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7d36668c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:551 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8ae970bd | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:569 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0577b78f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:573 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0110_GET_MODEL_LIST") ⇒ SCP.SCP0110_GET_MODEL_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-d923fdf4 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:574 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f649b770 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:575 | try | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-62c4cd05 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:576 | try | DATA_OP | request.Parameters["p_group_id"] | p_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-628f7480 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:577 | try | DATA_OP | request.Parameters["p_group_name"] | p_group_name | 행/컬럼 값 대입 |  |  |  |
| AC-6220c2e2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:578 | try | DATA_OP | request.Parameters["p_project_id"] | p_project_id | 행/컬럼 값 대입 |  |  |  |
| AC-7999d743 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:579 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e9c91945 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:581 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-434004b2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:589 | try | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-614dc72e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:590 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ae374fc9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:593 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-76168717 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:596 | try | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-71f2eb42 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0110_GroupModelMapping.cs:606 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0110_GroupModelMapping.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2af87090 | this.Load | SCP0110_GroupModelMapping.cs:133 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0110_GroupModelMapping.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c50ebf2 | this.Load | SCP0110_GroupModelMapping.cs:164 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7a79c09a | this.Load | SCP0110_GroupModelMapping.cs:169 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtMyDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-411e1d5d | this.Load | SCP0110_GroupModelMapping.cs:170 | if (dtMyDivision.Rows.Count > 0) | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-21978f27 | this.Load | SCP0110_GroupModelMapping.cs:176 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) ▸ if (dr["CODE"].ToString().IndexOf("81") >= 0) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-89512a2b | this.Load | SCP0110_GroupModelMapping.cs:177 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) ▸ if (dr["CODE"].ToString().IndexOf("81") >= 0) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a526cfde | this.Load | SCP0110_GroupModelMapping.cs:178 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) ▸ if (dr["CODE"].ToString().IndexOf("81") >= 0) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-6d5391ea | this.Load | SCP0110_GroupModelMapping.cs:180 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) ▸ if (dr["CODE"].ToString().IndexOf("81") >= 0) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6f04c5e | this.Load | SCP0110_GroupModelMapping.cs:184 | if (dtMyDivision.Rows.Count > 0) | UI_PROP | tmpDivision.DefaultView.Sort | "CODE Asc" | 속성 Sort 설정 |  |  |  |
| AC-f579e215 | this.Load | SCP0110_GroupModelMapping.cs:185 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0ec4ae0f | this.Load | SCP0110_GroupModelMapping.cs:187 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0daccda8 | this.Load | SCP0110_GroupModelMapping.cs:189 | if (dtMyDivision.Rows.Count > 0) | STATE_RESET | dtMyDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-450f9e0a | this.Load | SCP0110_GroupModelMapping.cs:190 | if (dtMyDivision.Rows.Count > 0) | FLAG | dtMyDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-15c7ce1f | this.Load | SCP0110_GroupModelMapping.cs:190 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-07e3e404 | this.Load | SCP0110_GroupModelMapping.cs:195 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl1) | 권한 검사/설정 |  |  |  |
| AC-51351ff2 | this.Load | SCP0110_GroupModelMapping.cs:197 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-eb935211 | this.Load | SCP0110_GroupModelMapping.cs:201 |  | FLAG | dtOperationGroup | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-fcff9689 | this.Load | SCP0110_GroupModelMapping.cs:201 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4eddfe6 | this.Load | SCP0110_GroupModelMapping.cs:202 |  | DATA_OP | dtOperationGroup.Rows.RemoveAt | (2) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee21a710 | this.Load | SCP0110_GroupModelMapping.cs:204 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0110_GroupModelMapping.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f77b2ea | this.Load 외 4 | SCP0110_GroupModelMapping.cs:271 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ce80f904 | this.Load 외 4 | SCP0110_GroupModelMapping.cs:273 | if (spreadInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("LookupCommon", dtOperationGroup) | 목록 컨트롤 재구성 |  |  |  |
| AC-e4bea34d | this.Load 외 4 | SCP0110_GroupModelMapping.cs:274 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-54b3e11f | this.Load 외 4 | SCP0110_GroupModelMapping.cs:275 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6177fa12 | this.Load 외 4 | SCP0110_GroupModelMapping.cs:280 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-12ac4998 | this.Load 외 4 | SCP0110_GroupModelMapping.cs:286 | if (spreadInfo.SheetName == SpdSheet.shtSub) | DATA_OP | DBUtils.Filter | (dtGroupMaster, "DIVISION_ID = '" + division + "' AND OPERATION_GROUP = '" + operationGrou… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ef6b889d | this.Load 외 4 | SCP0110_GroupModelMapping.cs:289 | if (spreadInfo.SheetName == SpdSheet.shtSub) | LIST_REBIND | SpreadInfo.SetComBoParam | ("GroupMaster", dtGruop) | 목록 컨트롤 재구성 |  |  |  |
| AC-da962d7d | this.Load 외 4 | SCP0110_GroupModelMapping.cs:290 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumnSCP | (spreadInfo, 1, false, "") | 그리드 재구성/초기화 |  |  |  |
| AC-535bb7fa | this.Load 외 4 | SCP0110_GroupModelMapping.cs:292 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0110_GroupModelMapping.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bb3cb9f | InsertButton | SCP0110_GroupModelMapping.cs:945 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f907fd1 | InsertButton | SCP0110_GroupModelMapping.cs:951 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7469871 | InsertButton | SCP0110_GroupModelMapping.cs:952 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.OPERATION_GROUP, operationGroup) | 데이터 객체 조작/조회 |  |  |  |
| AC-076ea5af | InsertButton | SCP0110_GroupModelMapping.cs:953 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.GROUP_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-dee7f0e0 | InsertButton | SCP0110_GroupModelMapping.cs:955 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-a3a8ef63 | InsertButton | SCP0110_GroupModelMapping.cs:959 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0110_GroupModelMapping.RefreshModelList

진입점: this.Load / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee4e183c | this.Load 외 1 | SCP0110_GroupModelMapping.cs:219 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0110_GET_MODEL_LIST") ⇒ SCP.SCP0110_GET_MODEL_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-8db764f0 | this.Load 외 1 | SCP0110_GroupModelMapping.cs:220 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0e6e965f | this.Load 외 1 | SCP0110_GroupModelMapping.cs:221 |  | DATA_OP | request.Parameters["p_operation_group"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-ae12e41e | this.Load 외 1 | SCP0110_GroupModelMapping.cs:222 |  | DATA_OP | request.Parameters["p_group_id"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-b89bb146 | this.Load 외 1 | SCP0110_GroupModelMapping.cs:223 |  | DATA_OP | request.Parameters["p_group_name"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-c131f5e5 | this.Load 외 1 | SCP0110_GroupModelMapping.cs:224 |  | DATA_OP | request.Parameters["p_project_id"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-603e18a3 | this.Load 외 1 | SCP0110_GroupModelMapping.cs:225 |  | DATA_OP | request.Parameters["p_item_id"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-2514b7d9 | this.Load 외 1 | SCP0110_GroupModelMapping.cs:227 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-988893c9 | this.Load 외 1 | SCP0110_GroupModelMapping.cs:232 |  | FLAG | this.dtModelListAll | dsSub.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0110_GroupModelMapping.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdfdd6ab | SaveButton | SCP0110_GroupModelMapping.cs:615 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c46629f4 | SaveButton | SCP0110_GroupModelMapping.cs:635 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-ea537370 | SaveButton | SCP0110_GroupModelMapping.cs:635 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-467373eb | SaveButton | SCP0110_GroupModelMapping.cs:665 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { " Group Name : " + groupName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5746af97 | SaveButton | SCP0110_GroupModelMapping.cs:666 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ca1d78f | SaveButton | SCP0110_GroupModelMapping.cs:682 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { " Group Name : " + groupName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-37360fb7 | SaveButton | SCP0110_GroupModelMapping.cs:683 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0cce046 | SaveButton | SCP0110_GroupModelMapping.cs:694 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { " Group Name : " + groupName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f7c71e8 | SaveButton | SCP0110_GroupModelMapping.cs:695 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d39deeb2 | SaveButton | SCP0110_GroupModelMapping.cs:729 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e1e80bc8 | SaveButton | SCP0110_GroupModelMapping.cs:733 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0110_SAVE_GROUP_MASTER") ⇒ SCP.SCP0110_SAVE_GROUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-03d27d98 | SaveButton | SCP0110_GroupModelMapping.cs:737 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4e4bc435 | SaveButton | SCP0110_GroupModelMapping.cs:741 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-fb2564f9 | SaveButton | SCP0110_GroupModelMapping.cs:742 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-cb429ad6 | SaveButton | SCP0110_GroupModelMapping.cs:743 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-db9af2ea | SaveButton | SCP0110_GroupModelMapping.cs:744 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_group_id"] | p_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-cbddf53c | SaveButton | SCP0110_GroupModelMapping.cs:745 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_group_name"] | p_group_name | 행/컬럼 값 대입 |  |  |  |
| AC-7d7df8d3 | SaveButton | SCP0110_GroupModelMapping.cs:746 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-738412a8 | SaveButton | SCP0110_GroupModelMapping.cs:747 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-bfc5c9dc | SaveButton | SCP0110_GroupModelMapping.cs:748 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_only_stock"] | p_only_stock | 행/컬럼 값 대입 |  |  |  |
| AC-959bfaec | SaveButton | SCP0110_GroupModelMapping.cs:750 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2bbc8480 | SaveButton | SCP0110_GroupModelMapping.cs:750 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-c9114fec | SaveButton | SCP0110_GroupModelMapping.cs:754 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-38a0cfd1 | SaveButton | SCP0110_GroupModelMapping.cs:761 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (t.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-653d7646 | SaveButton | SCP0110_GroupModelMapping.cs:763 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (t.… | FLAG | dtGroupMaster | Data_SCP.CommonAll(Data_SCP.Type.GroupMaster, false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-3b458d51 | SaveButton | SCP0110_GroupModelMapping.cs:763 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (t.… | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.GroupMaster, false, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e42ea213 | SaveButton | SCP0110_GroupModelMapping.cs:770 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (t.… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93443ea3 | SaveButton | SCP0110_GroupModelMapping.cs:777 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-807fce15 | SaveButton | SCP0110_GroupModelMapping.cs:778 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9574239c | SaveButton | SCP0110_GroupModelMapping.cs:782 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-10e7742f | SaveButton | SCP0110_GroupModelMapping.cs:793 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-bf8f5ca6 | SaveButton | SCP0110_GroupModelMapping.cs:817 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < siSub.GetMaxRowIndex()) | CALL_EXT | siSub.GetValueObject(i, siSub.GetColumnIndex(DefColumns.GROUP_ID)).ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-21b3f09f | SaveButton | SCP0110_GroupModelMapping.cs:817 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < siSub.GetMaxRowIndex()) | CALL_EXT | siSub.GetValueObject | (i, siSub.GetColumnIndex(DefColumns.GROUP_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5994cf07 | SaveButton | SCP0110_GroupModelMapping.cs:831 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < siSub.GetMaxRowIndex()) ▸ … | CALL_EXT | siSub.GetValueObject | (m, siSub.GetColumnIndex(DefColumns.GROUP_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f92265f0 | SaveButton | SCP0110_GroupModelMapping.cs:839 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < siSub.GetMaxRowIndex()) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("복수의 Project를 같은 그룹으로 저장할 수 없습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-02fc35a3 | SaveButton | SCP0110_GroupModelMapping.cs:841 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < siSub.GetMaxRowIndex()) ▸ … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-819fcca7 | SaveButton | SCP0110_GroupModelMapping.cs:855 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < siSub.GetMaxRowIndex()) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("복수의 Project를 같은 그룹으로 저장할 수 없습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1c4f106a | SaveButton | SCP0110_GroupModelMapping.cs:857 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i < siSub.GetMaxRowIndex()) ▸ … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5bcc00c6 | SaveButton | SCP0110_GroupModelMapping.cs:873 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) | CALL_EXT | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.GROUP_ID)).ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f6a400b4 | SaveButton | SCP0110_GroupModelMapping.cs:880 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-96ec7211 | SaveButton | SCP0110_GroupModelMapping.cs:884 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0110_SAVE_MODEL_LIST") ⇒ SCP.SCP0110_SAVE_MODEL_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-ae62f84f | SaveButton | SCP0110_GroupModelMapping.cs:888 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-90bc96f5 | SaveButton | SCP0110_GroupModelMapping.cs:892 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f91a12a1 | SaveButton | SCP0110_GroupModelMapping.cs:893 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c7729eb8 | SaveButton | SCP0110_GroupModelMapping.cs:894 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-13482759 | SaveButton | SCP0110_GroupModelMapping.cs:895 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ea5462a2 | SaveButton | SCP0110_GroupModelMapping.cs:896 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_group_id"] | p_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-0cd8e177 | SaveButton | SCP0110_GroupModelMapping.cs:897 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-fdc2260c | SaveButton | SCP0110_GroupModelMapping.cs:899 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-215da7c0 | SaveButton | SCP0110_GroupModelMapping.cs:899 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-54a411f0 | SaveButton | SCP0110_GroupModelMapping.cs:903 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fc064336 | SaveButton | SCP0110_GroupModelMapping.cs:910 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ if (t.Succe… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c25d215 | SaveButton | SCP0110_GroupModelMapping.cs:920 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ if (t.Succe… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-905a12d4 | SaveButton | SCP0110_GroupModelMapping.cs:926 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ catch ((Exception… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0685ad77 | SaveButton | SCP0110_GroupModelMapping.cs:927 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ catch ((Exception… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-960d2870 | SaveButton | SCP0110_GroupModelMapping.cs:931 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0110_GroupModelMapping.SpdMain_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de8ec5b8 | (진입점 미연결) | SCP0110_GroupModelMapping.cs:1022 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0110_GroupModelMapping.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68f4aa2f | this.spdMain.CellDoubleClick | SCP0110_GroupModelMapping.cs:1029 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0110_GroupModelMapping.SpdMain_KeyPress

진입점: this.spdMain.KeyPress / this.spdSub.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7763130 | this.spdMain.KeyPress 외 1 | SCP0110_GroupModelMapping.cs:126 | if (!fps.ActiveSheet.Cells[fps.ActiveSheet.ActiveRow.Index, fps.ActiveSheet.ActiveColumn.Index].Locked) ▸ if (fps.ActiveSheet.Columns[fps.Ac… | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |

## SCP0110_GroupModelMapping.SpdSub_ActiveSheetChanged

진입점: spdSub.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4899b8ec | spdSub.ActiveSheetChanged | SCP0110_GroupModelMapping.cs:1063 | if (sender != null && !bCheck) | FLAG | _sActiveSheetName | ((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName | 화면 필드/플래그 변경 |  |  |  |

## SCP0110_GroupModelMapping.spdSub_ActiveSheetChanging

진입점: this.spdSub.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a5b22e2 | this.spdSub.ActiveSheetChanging | SCP0110_GroupModelMapping.cs:1053 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siSub.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-ca87f30e | this.spdSub.ActiveSheetChanging | SCP0110_GroupModelMapping.cs:1055 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c36a266e | this.spdSub.ActiveSheetChanging | SCP0110_GroupModelMapping.cs:1056 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0110_GroupModelMapping.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e219022a | this.spdSub.CellDoubleClick | SCP0110_GroupModelMapping.cs:1070 | if (!siSub.IsLock(siSub.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0110_GroupModelMapping.spdSub_TopChange

진입점: this.spdSub.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1599190b | this.spdSub.TopChange | SCP0110_GroupModelMapping.cs:1082 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |


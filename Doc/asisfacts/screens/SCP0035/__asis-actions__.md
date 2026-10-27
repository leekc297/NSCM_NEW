# AS-IS 액션 대조표 — SCP0035

> 원천: `Doc/asisfacts/screens/SCP0035/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 136행 · 메서드 16 · 종류 DATA_OP 52 · GRID_SET 17 · RETURN 11 · FLAG 9 · MESSAGE 6 · GRID_LOCK 6 · ENDPOINT 6 · LIST_REBIND 6 · GRID_INIT 4 · UI_MISC 4 · GRID_COMBO 4 · VALIDATE 3 · COMBO_DATA 3 · POPUP 2 · UI_PROP 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 0


## SCP0035_JigMaster.checkValidN1

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-246eecab | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:628 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2b92915 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:631 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-951f9dfb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:632 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-47cd31b7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:633 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.OPERATION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-61136fd1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:634 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.JIG_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c96d23b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:647 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-4bfa0080 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:648 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-159f0e8a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:649 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.OPERATION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-65356942 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:650 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.JIG_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c95be4f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:668 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9b7cb72b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:671 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0035_JigMaster.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff5221f6 | this.Load | SCP0035_JigMaster.cs:140 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dba8f71a | this.Load | SCP0035_JigMaster.cs:141 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a7294364 | this.Load | SCP0035_JigMaster.cs:142 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0035_JigMaster.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abd9fa2d | DeleteButton | SCP0035_JigMaster.cs:187 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc0246c9 | DeleteButton | SCP0035_JigMaster.cs:192 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0035_JigMaster.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f503faf2 | Dispose | SCP0035_JigMaster.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0035_JigMaster.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06c523c1 | EditButton | SCP0035_JigMaster.cs:173 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7f704140 | EditButton | SCP0035_JigMaster.cs:174 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e70334b1 | EditButton | SCP0035_JigMaster.cs:176 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.OPERATION… | 그리드 편집 잠금/해제 |  |  |  |
| AC-28028899 | EditButton | SCP0035_JigMaster.cs:177 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0035_JigMaster.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd6717b8 | FindButton 외 1 | SCP0035_JigMaster.cs:209 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-47496f29 | FindButton 외 1 | SCP0035_JigMaster.cs:212 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-777250ba | FindButton 외 1 | SCP0035_JigMaster.cs:212 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1f070da3 | FindButton 외 1 | SCP0035_JigMaster.cs:216 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ec5ce2f6 | FindButton 외 1 | SCP0035_JigMaster.cs:229 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-87bb5631 | FindButton 외 1 | SCP0035_JigMaster.cs:230 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a15749e0 | FindButton 외 1 | SCP0035_JigMaster.cs:234 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0035_GET_JIG_MASTER") ⇒ SCP.SCP0035_GET_JIG_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-aa610247 | FindButton 외 1 | SCP0035_JigMaster.cs:235 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2a65457e | FindButton 외 1 | SCP0035_JigMaster.cs:236 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-67cc1df7 | FindButton 외 1 | SCP0035_JigMaster.cs:237 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-ec2f0bc6 | FindButton 외 1 | SCP0035_JigMaster.cs:238 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group.Equals("ALL") ? DBNull.Value : p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-13b48b19 | FindButton 외 1 | SCP0035_JigMaster.cs:239 | try ▸ lambda | DATA_OP | request.Parameters["p_jig_name"] | p_jig_name | 행/컬럼 값 대입 |  |  |  |
| AC-30a1aad7 | FindButton 외 1 | SCP0035_JigMaster.cs:240 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn.Equals("ALL") ? DBNull.Value : p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-d4bbc579 | FindButton 외 1 | SCP0035_JigMaster.cs:242 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-57617592 | FindButton 외 1 | SCP0035_JigMaster.cs:244 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c4526d49 | FindButton 외 1 | SCP0035_JigMaster.cs:251 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8920ebca | FindButton 외 1 | SCP0035_JigMaster.cs:252 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e26fd745 | FindButton 외 1 | SCP0035_JigMaster.cs:255 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0c722cc4 | FindButton 외 1 | SCP0035_JigMaster.cs:260 | try | FLAG | dsFullBinding | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-f715663e | FindButton 외 1 | SCP0035_JigMaster.cs:270 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0035_JigMaster.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0eed228 | this.Load | SCP0035_JigMaster.cs:92 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0035_JigMaster.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-971fe9f3 | this.Load | SCP0035_JigMaster.cs:108 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a64b0127 | this.Load | SCP0035_JigMaster.cs:111 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-f9a53882 | this.Load | SCP0035_JigMaster.cs:113 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-45e29d2a | this.Load | SCP0035_JigMaster.cs:114 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-6f638cd8 | this.Load | SCP0035_JigMaster.cs:116 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0035_JigMaster.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e275f13a | this.Load 외 2 | SCP0035_JigMaster.cs:149 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-2a0a3cbb | this.Load 외 2 | SCP0035_JigMaster.cs:150 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantByDivisionOperation", dtPlantSiteByDivisionForSpread) | 목록 컨트롤 재구성 |  |  |  |
| AC-df7283e9 | this.Load 외 2 | SCP0035_JigMaster.cs:151 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("OperationIdByPlant", dtOperationId) | 목록 컨트롤 재구성 |  |  |  |
| AC-c136c529 | this.Load 외 2 | SCP0035_JigMaster.cs:152 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## SCP0035_JigMaster.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60e7767c | InsertButton | SCP0035_JigMaster.cs:285 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2fa54114 | InsertButton | SCP0035_JigMaster.cs:288 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7c85d3f5 | InsertButton | SCP0035_JigMaster.cs:292 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1e09cc2 | InsertButton | SCP0035_JigMaster.cs:293 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-4eaea8dd | InsertButton | SCP0035_JigMaster.cs:295 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-56195f01 | InsertButton | SCP0035_JigMaster.cs:297 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-743dfad0 | InsertButton | SCP0035_JigMaster.cs:298 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0035_JigMaster.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f17480be | SaveButton | SCP0035_JigMaster.cs:312 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.Rows.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-99988bd2 | SaveButton | SCP0035_JigMaster.cs:313 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-fade4bea | SaveButton | SCP0035_JigMaster.cs:313 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82662471 | SaveButton | SCP0035_JigMaster.cs:330 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN1()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7775f664 | SaveButton | SCP0035_JigMaster.cs:370 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0035_SAVE_JIG_MASTER") ⇒ SCP.SCP0035_SAVE_JIG_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-1e5ac9ec | SaveButton | SCP0035_JigMaster.cs:374 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8db86bc0 | SaveButton | SCP0035_JigMaster.cs:378 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-cc365c50 | SaveButton | SCP0035_JigMaster.cs:379 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_jig_seq"] | p_jig_seq | 행/컬럼 값 대입 |  |  |  |
| AC-be897317 | SaveButton | SCP0035_JigMaster.cs:380 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-be8680c0 | SaveButton | SCP0035_JigMaster.cs:381 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-8732954c | SaveButton | SCP0035_JigMaster.cs:382 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-8a4fd809 | SaveButton | SCP0035_JigMaster.cs:383 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_jig_name"] | p_jig_name | 행/컬럼 값 대입 |  |  |  |
| AC-424b1691 | SaveButton | SCP0035_JigMaster.cs:384 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-8886a222 | SaveButton | SCP0035_JigMaster.cs:385 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_s_valid_yn"] | p_s_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-5c55a307 | SaveButton | SCP0035_JigMaster.cs:386 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-72cb5af6 | SaveButton | SCP0035_JigMaster.cs:387 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-93145cc9 | SaveButton | SCP0035_JigMaster.cs:388 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-b566810d | SaveButton | SCP0035_JigMaster.cs:389 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-2e38f668 | SaveButton | SCP0035_JigMaster.cs:391 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-94ac7aaa | SaveButton | SCP0035_JigMaster.cs:391 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-2b272024 | SaveButton | SCP0035_JigMaster.cs:401 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1dee02bc | SaveButton | SCP0035_JigMaster.cs:410 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0035_JigMaster.set_ValidDataSet

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d43b36d1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:574 |  | FLAG | dsValiChkBinding | null | 화면 필드/플래그 변경 |  |  |  |
| AC-691d47ba | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:575 |  | FLAG | dsValiChkBinding | dsFullBinding.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-99ab2ef5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:575 |  | DATA_OP | dsFullBinding.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-26f255a2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:579 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.Columns.Add | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-927ec512 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:580 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.Columns.Add | ("SCM_SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5897f943 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:581 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.Columns.Add | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-249679b9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:582 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.Columns.Add | ("JIG_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac18308b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:583 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.Columns.Add | ("JIG_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0bfed944 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:584 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.Columns.Add | ("ACTION_FLAG_DIV", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6853c78d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:585 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eda16ed5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:597 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagM) ▸ if (!String.IsNullOrEmpty(JIG_SEQ)) | DATA_OP | dsValiChkBinding.Rows.Remove | (dsValiChkBinding.Select("JIG_SEQ = '" + JIG_SEQ + "'")[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-4377decb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:597 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagM) ▸ if (!String.IsNullOrEmpty(JIG_SEQ)) | DATA_OP | dsValiChkBinding.Select | ("JIG_SEQ = '" + JIG_SEQ + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-a4b570f5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:600 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsValiChkBinding.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f5ec0e1b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:602 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newDr[DefColumns.DIVISION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6f58558f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:603 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newDr[DefColumns.SCM_SITE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-162cf033 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:604 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newDr[DefColumns.OPERATION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-090b468a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:605 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newDr[DefColumns.JIG_NAME] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.JIG_NAME)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ed1b3780 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:607 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagM) | DATA_OP | newDr[DefColumns.JIG_SEQ] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.JIG_SEQ)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fd6eaef0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:608 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newDr[DefColumns.ACTION_FLAG_DIV] | action | 행/컬럼 값 대입 |  |  |  |
| AC-b9ab65bf | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:610 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsValiChkBinding.Rows.Add | (newDr) | 데이터 객체 조작/조회 |  |  |  |
| AC-9597fc1c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0035_JigMaster.cs:613 |  | DATA_OP | dsValiChkBinding.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0035_JigMaster.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59db4461 | this.Load 외 1 | SCP0035_JigMaster.cs:129 |  | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantByDivisionOperNonOsp, false, division, "A") | 화면 필드/플래그 변경 |  |  |  |
| AC-df01d1a4 | this.Load 외 1 | SCP0035_JigMaster.cs:129 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByDivisionOperNonOsp, false, division, "A") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d83d5a7a | this.Load 외 1 | SCP0035_JigMaster.cs:130 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0035_JigMaster.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-964c41c8 | spdMain.CellClick | SCP0035_JigMaster.cs:426 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-08341d94 | spdMain.CellClick | SCP0035_JigMaster.cs:438 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ if (e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a351c3da | spdMain.CellClick | SCP0035_JigMaster.cs:441 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ if (e.Colum… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].CellType | cb | 그리드 속성/값 설정 |  |  |  |
| AC-0a95343a | spdMain.CellClick | SCP0035_JigMaster.cs:445 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ if (e.Colum… | FLAG | dtPlantSiteByDivisionForIns | Data_SCP.Common(Data_SCP.Type.PlantByDivisionOperNonOsp2, false, division, "A") | 화면 필드/플래그 변경 |  |  |  |
| AC-09986eac | spdMain.CellClick | SCP0035_JigMaster.cs:445 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ if (e.Colum… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByDivisionOperNonOsp2, false, division, "A") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ecaf495b | spdMain.CellClick | SCP0035_JigMaster.cs:446 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ if (e.Colum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, e.Column, dtPlantSiteByDivisionForIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a6e02552 | spdMain.CellClick | SCP0035_JigMaster.cs:451 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ else of (e.… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9e63355b | spdMain.CellClick | SCP0035_JigMaster.cs:452 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), divisionId) | 그리드 값 설정 |  |  |  |
| AC-1ab23d5b | spdMain.CellClick | SCP0035_JigMaster.cs:461 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ else of (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Plant Site" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6b276567 | spdMain.CellClick | SCP0035_JigMaster.cs:465 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ else of (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cd5ebfd2 | spdMain.CellClick | SCP0035_JigMaster.cs:469 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ else of (e.… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].CellType | cb | 그리드 속성/값 설정 |  |  |  |
| AC-45b52bd3 | spdMain.CellClick | SCP0035_JigMaster.cs:472 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ else of (e.… | FLAG | dtOperationIdIns | Data_SCP.Common(Data_SCP.Type.JIGOperationId, false, divisionId, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-450dd4ba | spdMain.CellClick | SCP0035_JigMaster.cs:472 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ else of (e.… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.JIGOperationId, false, divisionId, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-244974ec | spdMain.CellClick | SCP0035_JigMaster.cs:473 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ else of (e.… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, e.Column, dtOperationIdIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-48540c97 | spdMain.CellClick | SCP0035_JigMaster.cs:477 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, e.Column, dtOperationIdIns.Rows[0].Field<string>("CODE")) | 그리드 값 설정 |  |  |  |
| AC-04ef8813 | spdMain.CellClick | SCP0035_JigMaster.cs:477 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction))==CApp…) ▸ else of (e.… | DATA_OP | dtOperationIdIns.Rows[0].Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |

## SCP0035_JigMaster.SpdMain_ClipboardPasted

진입점: spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-890366af | spdMain.ClipboardPasted | SCP0035_JigMaster.cs:526 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e97e813e | spdMain.ClipboardPasted | SCP0035_JigMaster.cs:537 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.CellRange.Row, siMain.GetColumnIndex(CAppSetting.StringActi…) ▸ if (e.CellR… | GRID_SET | siMain.SetValue | (e.CellRange.Row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-e8505664 | spdMain.ClipboardPasted | SCP0035_JigMaster.cs:541 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.CellRange.Row, siMain.GetColumnIndex(CAppSetting.StringActi…) ▸ if (e.CellR… | DATA_OP | dtPlantSiteAll.Select | ("CODE = '" + scmSiteId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-19f2ee7e | spdMain.ClipboardPasted | SCP0035_JigMaster.cs:545 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.CellRange.Row, siMain.GetColumnIndex(CAppSetting.StringActi…) ▸ if (e.CellR… | GRID_SET | siMain.SetValue | (e.CellRange.Row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), sOperation) | 그리드 값 설정 |  |  |  |
| AC-a29abbb4 | spdMain.ClipboardPasted | SCP0035_JigMaster.cs:548 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.CellRange.Row, siMain.GetColumnIndex(CAppSetting.StringActi…) ▸ if (e.CellR… | GRID_SET | siMain.SetValue | (e.CellRange.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-7c9dd72c | spdMain.ClipboardPasted | SCP0035_JigMaster.cs:553 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.CellRange.Row, siMain.GetColumnIndex(CAppSetting.StringActi…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.CellRange.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c46bbd2d | spdMain.ClipboardPasted | SCP0035_JigMaster.cs:554 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.CellRange.Row, siMain.GetColumnIndex(CAppSetting.StringActi…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.CellRange.Row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-3c9a2716 | spdMain.ClipboardPasted | SCP0035_JigMaster.cs:555 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.CellRange.Row, siMain.GetColumnIndex(CAppSetting.StringActi…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.CellRange.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |

## SCP0035_JigMaster.SpdMain_ComboSelChange

진입점: spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d40a8118 | spdMain.ComboSelChange | SCP0035_JigMaster.cs:488 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31e2b9bc | spdMain.ComboSelChange | SCP0035_JigMaster.cs:499 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-9eac5818 | spdMain.ComboSelChange | SCP0035_JigMaster.cs:504 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteAll.Select | ("CODE = '" + scmSiteId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc16757c | spdMain.ComboSelChange | SCP0035_JigMaster.cs:508 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), sOperation) | 그리드 값 설정 |  |  |  |
| AC-262ffd97 | spdMain.ComboSelChange | SCP0035_JigMaster.cs:511 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-5612291f | spdMain.ComboSelChange | SCP0035_JigMaster.cs:516 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-28154bf0 | spdMain.ComboSelChange | SCP0035_JigMaster.cs:517 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-98e4569d | spdMain.ComboSelChange | SCP0035_JigMaster.cs:518 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |


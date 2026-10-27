# AS-IS 액션 대조표 — SCP0123

> 원천: `Doc/asisfacts/screens/SCP0123/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 386행 · 메서드 40 · 종류 DATA_OP 76 · RETURN 38 · VALUE_SET 38 · FLAG 33 · UI_PROP 31 · MESSAGE 27 · STATE 27 · ENDPOINT 17 · GRID_SET 16 · UI_MISC 15 · CALL_EXT 13 · POPUP 12 · GRID_INIT 11 · LIST_REBIND 9 · GRID_CLEAR 8 · GRID_LOCK 3 · VALUE_CLEAR 3 · VALIDATE 2 · GRID_BIND 2 · GRID_STYLE 2 · COMBO_DATA 2 · CALL_BASE 1 · ⚠ 의미 확인 필요 14


## SCP0123_PlanControl.cboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d26bf7b | cboDivision.SelectedIndexChanged | SCP0123_PlanControl.cs:857 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-b30d4965 | cboDivision.SelectedIndexChanged | SCP0123_PlanControl.cs:858 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdSub) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0123_PlanControl.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb978be2 | cboPlanDate.SelectedIndexChanged | SCP0123_PlanControl.cs:873 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-0d6d40cc | cboPlanDate.SelectedIndexChanged | SCP0123_PlanControl.cs:874 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdSub) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0123_PlanControl.CboPlanGroup_SelectedIndexChanged

진입점: cboPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-690c1b6b | cboPlanGroup.SelectedIndexChanged | SCP0123_PlanControl.cs:865 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-c814f07d | cboPlanGroup.SelectedIndexChanged | SCP0123_PlanControl.cs:866 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdSub) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0123_PlanControl.CheckPreStepCompleted

진입점: this.spdMain.CellClick [else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CONFIRM)) ▸ if (seq != "1") ▸ if (actv_cd != "A004" && actv_cd != "A005")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9debe027 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:1197 | if (dsReview == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-54ae59ac | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:1218 | for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.OPMZ_ACTV_CD].ToString() == actv_cd) ▸ else of (pre_stat_cd == "C") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-eb5c0246 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:1257 |  | RETURN | return isCompleted; |  | 처리 중단/반환 |  |  |  |

## SCP0123_PlanControl.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4fe7214 | this.Load | SCP0123_PlanControl.cs:282 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-15ea20a0 | this.Load | SCP0123_PlanControl.cs:283 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-74f7c7b9 | this.Load | SCP0123_PlanControl.cs:286 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-19287a07 | this.Load | SCP0123_PlanControl.cs:287 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-7f0a8aa9 | this.Load | SCP0123_PlanControl.cs:288 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0886ee08 | this.Load | SCP0123_PlanControl.cs:291 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6a76c103 | this.Load | SCP0123_PlanControl.cs:295 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0123_PlanControl.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-417325d1 | this.Load | SCP0123_PlanControl.cs:162 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-2b8a0e23 | this.Load | SCP0123_PlanControl.cs:164 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-3a31b23a | this.Load | SCP0123_PlanControl.cs:165 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-43386d86 | this.Load | SCP0123_PlanControl.cs:166 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SCP0123_PlanControl.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e7d9bef | Dispose | SCP0123_PlanControl.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0123_PlanControl.DpPlanDate_Days_ValueChanged

진입점: dpPlanDate_Days.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05f5ae57 | dpPlanDate_Days.ValueChanged | SCP0123_PlanControl.cs:882 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-4f04aae8 | dpPlanDate_Days.ValueChanged | SCP0123_PlanControl.cs:883 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdSub) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0123_PlanControl.FindData_Main

진입점: this.spdMain.CellClick [else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CONFIRM)) ▸ else of (plan_id_indp_yn == "Y") ▸ if (actv_cd == "A002") ▸ if (popup.ShowDialog() == DialogResult.OK)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-835bb508 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:367 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a7676059 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:371 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-7bb75300 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:371 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b49cffbb | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:374 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-740bd2c5 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:376 | try | CALL_EXT | timerStatus.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-88c4c64b | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:385 | try | DATA_OP | DBUtils.Filter | (dtDivision_GM, "CODE = '" + p_division_id + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-62508bad | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:411 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-da96ccf9 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:412 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID_INDP_YN), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5ee274d8 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:413 | try | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_RUN_STAT_CD), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-644895e3 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:416 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ce411c88 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:439 | try ▸ if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (actv_cd == "A001") ▸ if (this.isVali… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex("DETAIL"), sDetail) | 그리드 값 설정 |  |  |  |
| AC-b60b9cee | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:447 | try ▸ if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (plan_id_indp_yn != "Y") | GRID_STYLE | siMain.SetBGColor2 | (i, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID), i, siMain.GetColumnIndex(DefColumns.OP… | 그리드 표시 설정 |  |  |  |
| AC-38b68b28 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:452 | try ▸ if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (plan_id_indp_yn != "Y") | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-455e1b11 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:458 | try ▸ if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) | GRID_SET | siMain.ActiveSheet.Cells[i, colIndex].Font | new Font(xFont, xFont.Style \| FontStyle.Underline) | 그리드 속성/값 설정 |  |  |  |
| AC-adddcb98 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:459 | try ▸ if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) | GRID_SET | siMain.SetValue | (i, colIndex, link_Text) | 그리드 값 설정 |  |  |  |
| AC-e572bb22 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:460 | try ▸ if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) | GRID_STYLE | siMain.SetForeColor | (i, colIndex, i, colIndex, Color.Blue, false) | 그리드 표시 설정 |  |  |  |
| AC-4e2f1a3c | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:462 | try ▸ if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0) ▸ for (i < ds.Tables[0].Rows.Count) | GRID_INIT | siMain.SetCellTypeButtonByText | (i, siMain.GetColumnIndex(DefColumns.CONFIRM), btn_Text) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-af7cfcf6 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 1 | SCP0123_PlanControl.cs:478 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0123_PlanControl.FindData_Sub

진입점: this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (actv_cd == "A001") ▸ else of (actv_cd == "A002") ▸ if (actv_cd == "A003")] / this.spdMain.CellDoubleClick [if (actv_cd == "A003")] / timerStatus.Tick [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb835028 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:506 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-bbf0ee96 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:526 | try ▸ if (nRowIdx != -1) | DATA_OP | DBUtils.Filter | (dtDivision_GM, "CODE = '" + division_id + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e7885b79 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:546 | try ▸ if (!isStatusCheck) | CALL_EXT | timerStatus.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-838bbbe5 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:554 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-379405f9 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:557 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0123_GET_PLAN_ENGINE_RUN") ⇒ SCP.SCP0123_GET_PLAN_ENGINE_RUN | 엔드포인트 요청 생성 |  |  |  |
| AC-b97a651b | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:558 | try | DATA_OP | request.Parameters["p_division_id"] | division_id | 행/컬럼 값 대입 |  |  |  |
| AC-22960242 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:559 | try | DATA_OP | request.Parameters["p_plan_group_id"] | plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-0b81c528 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:560 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-34b722fb | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:561 | try | DATA_OP | request.Parameters["p_actv_cd"] | actv_cd | 행/컬럼 값 대입 |  |  |  |
| AC-d0b3dcc7 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:562 | try | DATA_OP | request.Parameters["p_plan_id"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-fb865409 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:564 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0b548823 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:574 | try ▸ if (!isStatusCheck) | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f8662bd0 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:575 | try ▸ if (!isStatusCheck) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5c7ba2bd | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:578 | try ▸ if (!isStatusCheck) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e088737c | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:600 | try ▸ if (nRowIdx != -1) ▸ if (dsMain.Tables.Count > 0 && dsMain.Tables[0].Rows.Count > 0) ▸ if (strACTV_RUN_STAT_CD != strNew_ACTV_RUN_STAT… | GRID_SET | siMain.SetText | (nRowIdx, siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_RUN_STAT_CD), strNew_ACTV_RUN_STAT_CD… | 그리드 값 설정 |  |  |  |
| AC-7e0ccdd1 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:601 | try ▸ if (nRowIdx != -1) ▸ if (dsMain.Tables.Count > 0 && dsMain.Tables[0].Rows.Count > 0) ▸ if (strACTV_RUN_STAT_CD != strNew_ACTV_RUN_STAT… | GRID_SET | siMain.SetText | (nRowIdx, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), strNew_LAST_UPDATE_DATE) | 그리드 값 설정 |  |  |  |
| AC-d2fa4e36 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:602 | try ▸ if (nRowIdx != -1) ▸ if (dsMain.Tables.Count > 0 && dsMain.Tables[0].Rows.Count > 0) ▸ if (strACTV_RUN_STAT_CD != strNew_ACTV_RUN_STAT… | GRID_SET | siMain.SetText | (nRowIdx, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), strLAST_UPDATED_BY) | 그리드 값 설정 |  |  |  |
| AC-81ff3e2e | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:641 | try ▸ if (strACTV_RUN_STAT_CD == "C" \|\| strACTV_RUN_STAT_CD == "E" \|\| strACTV_RUN_STAT_CD == "") | CALL_EXT | timerStatus.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f8f8110 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:646 | try ▸ else of (strACTV_RUN_STAT_CD == "C" \|\| strACTV_RUN_STAT_CD == "E" \|\| strACTV_RUN_STAT_CD == "") ▸ if (!isStatusCheck) | CALL_EXT | timerStatus.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1cff4a8e | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:656 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0123_PlanControl.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8a52236 | this.Load | SCP0123_PlanControl.cs:139 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0123_PlanControl.GetDataSet_Main

진입점: this.spdMain.CellClick [else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CONFIRM)) ▸ else of (plan_id_indp_yn == "Y") ▸ else of (actv_cd == "A002") ▸ else of (actv_cd == "A003") ▸ if (actv_cd == "A004")] / this.spdMain.CellDoubleClick [if (actv_cd == "A003") ▸ try ▸ if (nRowIdx != -1)] / this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID))] / timerStatus.Tick [try ▸ try ▸ if (nRowIdx != -1)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-727c477d | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 4 | SCP0123_PlanControl.cs:488 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0123_GET_PLAN_CONTROL") ⇒ SCP.SCP0123_GET_PLAN_CONTROL | 엔드포인트 요청 생성 |  |  |  |
| AC-e22178bc | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 4 | SCP0123_PlanControl.cs:490 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a2a38243 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 4 | SCP0123_PlanControl.cs:491 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-976b20b7 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 4 | SCP0123_PlanControl.cs:492 |  | DATA_OP | request.Parameters["p_plan_group_id"] | p_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-87620728 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 4 | SCP0123_PlanControl.cs:493 |  | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-47c2530b | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 4 | SCP0123_PlanControl.cs:494 |  | DATA_OP | request.Parameters["p_actv_cd"] | actv_cd | 행/컬럼 값 대입 |  |  |  |
| AC-36f6b994 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 4 | SCP0123_PlanControl.cs:495 |  | DATA_OP | request.Parameters["p_plan_id"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-73117963 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 4 | SCP0123_PlanControl.cs:497 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dcf1e30b | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… 외 4 | SCP0123_PlanControl.cs:501 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0123_PlanControl.GetPlanGroupByUserID

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbccbfc2 | (진입점 미연결) | SCP0123_PlanControl.cs:338 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0121_GET_SEARCH_INFO") ⇒ SCP.SCP0121_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-80d64be9 | (진입점 미연결) | SCP0123_PlanControl.cs:340 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a3586fe7 | (진입점 미연결) | SCP0123_PlanControl.cs:341 |  | DATA_OP | request.Parameters["p_user_id"] | userId | 행/컬럼 값 대입 |  |  |  |
| AC-c0101d30 | (진입점 미연결) | SCP0123_PlanControl.cs:344 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-95d85495 | (진입점 미연결) | SCP0123_PlanControl.cs:348 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0123_PlanControl.GoPage

진입점: this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (actv_cd == "A001") ▸ else of (actv_cd == "A002") ▸ else of (actv_cd == "A003") ▸ if (!string.IsNullOrEmpty(link_adress))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78b627e7 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0123_PlanControl.cs:811 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f186758e | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0123_PlanControl.cs:812 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.DataService.WSL/FoxDataServic… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a8c745fb | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0123_PlanControl.cs:816 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("MenuContainer.UP_FX_GetGSCMAuthenticationMenuList") ⇒ MenuContainer.UP_FX_GetGSCMAuthenticationMenuList | 엔드포인트 요청 생성 |  |  |  |
| AC-d554468f | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0123_PlanControl.cs:817 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-50355935 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0123_PlanControl.cs:818 | try ▸ lambda | DATA_OP | request.Parameters["UserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-66efa946 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0123_PlanControl.cs:819 | try ▸ lambda | DATA_OP | request.Parameters["GroupID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5a4ab906 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0123_PlanControl.cs:820 | try ▸ lambda | DATA_OP | request.Parameters["ProgramId"] | pageID | 행/컬럼 값 대입 |  |  |  |
| AC-50124e3e | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0123_PlanControl.cs:822 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4c8458e5 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0123_PlanControl.cs:824 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8dbce89f | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0123_PlanControl.cs:831 | finally | CALL_BASE | openSubMenu | (pageID) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0123_PlanControl.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4550358a | this.Load | SCP0123_PlanControl.cs:172 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-53e3b348 | this.Load | SCP0123_PlanControl.cs:175 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl1) | 권한 검사/설정 |  |  |  |
| AC-1d073224 | this.Load | SCP0123_PlanControl.cs:178 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0801122 | this.Load | SCP0123_PlanControl.cs:180 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-abde0e13 | this.Load | SCP0123_PlanControl.cs:183 |  | DATA_OP | dtPlanGroupAll.DefaultView.ToTable | (true, new string[] { DefColumns.DIVISION_ID }) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b33e85e | this.Load | SCP0123_PlanControl.cs:196 |  | DATA_OP | DBUtils.Filter | (dtMyDivision, "CODE IN ( " + strValue + " )") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-28964d99 | this.Load | SCP0123_PlanControl.cs:200 |  | LIST_REBIND | clsCtrl.setListBox | (dtNewDiv, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0123_PlanControl.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebab6542 | this.Load | SCP0123_PlanControl.cs:156 |  | UI_PROP | timerStatus.Interval | 1000 * 2 | 속성 Interval 설정 |  |  |  |

## SCP0123_PlanControl.InitSpread

진입점: this.Load / this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (actv_cd == "A001") ▸ else of (actv_cd == "A002") ▸ if (actv_cd == "A003") ▸ try ▸ if (!isStatusCheck)] / this.spdMain.CellDoubleClick [if (actv_cd == "A003") ▸ try ▸ if (!isStatusCheck)] / timerStatus.Tick [try ▸ try ▸ if (!isStatusCheck)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5d99f90 | this.Load 외 4 | SCP0123_PlanControl.cs:302 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-3e116f02 | this.Load 외 4 | SCP0123_PlanControl.cs:304 | if (spreadInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlanID", dtPlanID) | 목록 컨트롤 재구성 |  |  |  |
| AC-d0768652 | this.Load 외 4 | SCP0123_PlanControl.cs:305 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumnSCP | (spreadInfo, 1, false, "") | 그리드 재구성/초기화 |  |  |  |
| AC-f4b9b273 | this.Load 외 4 | SCP0123_PlanControl.cs:311 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b16afab5 | this.Load 외 4 | SCP0123_PlanControl.cs:313 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-e3644f06 | this.Load 외 4 | SCP0123_PlanControl.cs:314 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0123_PlanControl.RefreshPlanDate

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61e871fa | this.Load 외 1 | SCP0123_PlanControl.cs:223 |  | DATA_OP | DBUtils.Filter | (dtDivision_GM, "CODE = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6086579f | this.Load 외 1 | SCP0123_PlanControl.cs:227 | if (dtGM.Rows.Count > 0) | UI_PROP | lciPlanDate_Days.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-254e4f64 | this.Load 외 1 | SCP0123_PlanControl.cs:228 | if (dtGM.Rows.Count > 0) | UI_PROP | lciPlanDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-82c0a3f2 | this.Load 외 1 | SCP0123_PlanControl.cs:230 | if (dtGM.Rows.Count > 0) | VALUE_SET | dpPlanDate_Days.Text | DateTime.Now.ToShortDateString() | 컨트롤 값 설정 |  |  |  |
| AC-a166618e | this.Load 외 1 | SCP0123_PlanControl.cs:230 | if (dtGM.Rows.Count > 0) | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0d3c2af | this.Load 외 1 | SCP0123_PlanControl.cs:234 | else of (dtGM.Rows.Count > 0) | UI_PROP | lciPlanDate_Days.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2b72fec1 | this.Load 외 1 | SCP0123_PlanControl.cs:235 | else of (dtGM.Rows.Count > 0) | UI_PROP | lciPlanDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9fbe237c | this.Load 외 1 | SCP0123_PlanControl.cs:237 | else of (dtGM.Rows.Count > 0) | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-fb6fe14c | this.Load 외 1 | SCP0123_PlanControl.cs:237 | else of (dtGM.Rows.Count > 0) | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-45190dee | this.Load 외 1 | SCP0123_PlanControl.cs:238 | else of (dtGM.Rows.Count > 0) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0123_PlanControl.RefreshPlanGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9649b45b | this.Load 외 1 | SCP0123_PlanControl.cs:212 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-b98ac80a | this.Load 외 1 | SCP0123_PlanControl.cs:212 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-aa8904f1 | this.Load 외 1 | SCP0123_PlanControl.cs:214 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, cboPlanGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0123_PlanControl.RefreshPlanID

진입점: this.Load / this.spdMain.CellClick [else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CONFIRM)) ▸ else of (plan_id_indp_yn == "Y") ▸ if (actv_cd == "A002") ▸ if (popup.ShowDialog() == DialogResult.OK)] / cboDivision.SelectedIndexChanged / cboPlanGroup.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged / dpPlanDate_Days.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5852b57 | this.Load 외 5 | SCP0123_PlanControl.cs:246 |  | CALL_EXT | cboPlanGroup.SelectedValue.ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-92a1c43a | this.Load 외 5 | SCP0123_PlanControl.cs:251 |  | DATA_OP | DBUtils.Filter | (dtDivision_GM, "CODE = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-62c3bd5f | this.Load 외 5 | SCP0123_PlanControl.cs:259 | else of (dtGM.Rows.Count > 0) | CALL_EXT | cboPlanDate.SelectedValue.ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-14d1a0cf | this.Load 외 5 | SCP0123_PlanControl.cs:262 |  | FLAG | dtPlanID | DBUtils.Filter(dtPlanIDAll, "DIVISION_ID = '" + division + "' AND OPMZ_PLAN_GR_ID = '" + p… | 화면 필드/플래그 변경 |  |  |  |
| AC-2cbbd03f | this.Load 외 5 | SCP0123_PlanControl.cs:262 |  | DATA_OP | DBUtils.Filter | (dtPlanIDAll, "DIVISION_ID = '" + division + "' AND OPMZ_PLAN_GR_ID = '" + plan_group_id +… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d9bc31c1 | this.Load 외 5 | SCP0123_PlanControl.cs:266 |  | UI_PROP | dv.Sort | "CODE DESC" | 속성 Sort 설정 |  |  |  |
| AC-b2eb984b | this.Load 외 5 | SCP0123_PlanControl.cs:267 |  | FLAG | dtPlanID | dv.ToTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-143566d5 | this.Load 외 5 | SCP0123_PlanControl.cs:267 |  | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0123_PlanControl.SaveData

진입점: this.spdMain.CellClick [else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CONFIRM)) ▸ if (plan_id_indp_yn == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e9ff784 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:703 |  | DATA_OP | DBUtils.Filter | (dtDivision_GM, "CODE = '" + p_division_id + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5b832e8b | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:728 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f938ab6b | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:729 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-90bb4279 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:733 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0123_SAVE_PLAN_CTRL_ACTV_RUN") ⇒ SCP.SCP0123_SAVE_PLAN_CTRL_ACTV_RUN | 엔드포인트 요청 생성 |  |  |  |
| AC-36d663bb | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:736 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", BLUtils.GSCM_SCP_MASTER_SVC)) { req… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-55131a5a | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:740 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1122e5de | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:742 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fcce0ece | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:743 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-73ab0c97 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:744 | try ▸ lambda | DATA_OP | req.Parameters["p_prs_cd"] | p_prs_cd | 행/컬럼 값 대입 |  |  |  |
| AC-fd9631dd | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:745 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_gr_id"] | p_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-9fb141fa | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:746 | try ▸ lambda | DATA_OP | req.Parameters["p_actv_cd"] | actv_cd | 행/컬럼 값 대입 |  |  |  |
| AC-996b81d7 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:747 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-627473e4 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:748 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c756c116 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:750 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f53a531 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:750 | try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-d2cbad56 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:754 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ff893aff | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:780 | try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (saveMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40662acd | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:789 | try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e2597900 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:795 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-07b60005 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:796 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-87fe7421 | this.spdMain.CellClick [else of (e.Column == siMain.GetColum… | SCP0123_PlanControl.cs:800 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0123_PlanControl.SetEngineStatus

진입점: this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (actv_cd == "A001") ▸ else of (actv_cd == "A002") ▸ if (actv_cd == "A003") ▸ try ▸ else of (!isStatusCheck)] / this.spdMain.CellDoubleClick [if (actv_cd == "A003") ▸ try ▸ else of (!isStatusCheck)] / timerStatus.Tick [try ▸ try ▸ else of (!isStatusCheck)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77a83dd7 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:672 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00a7d6cc | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:675 | try ▸ if (dt.Rows.Count != dtStatus.Rows.Count) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-057009c4 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:679 | try ▸ for (i < dtStatus.Rows.Count) | GRID_SET | dt.Rows[i][DefColumns.STATUS] | dtStatus.Rows[i][DefColumns.STATUS].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-585c5204 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:680 | try ▸ for (i < dtStatus.Rows.Count) | GRID_SET | dt.Rows[i][DefColumns.START_DATE] | dtStatus.Rows[i][DefColumns.START_DATE].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-559b5d50 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:681 | try ▸ for (i < dtStatus.Rows.Count) | GRID_SET | dt.Rows[i][DefColumns.END_DATE] | dtStatus.Rows[i][DefColumns.END_DATE].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-7067435a | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:682 | try ▸ for (i < dtStatus.Rows.Count) | GRID_SET | dt.Rows[i][DefColumns.DETAILS] | dtStatus.Rows[i][DefColumns.DETAILS].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-af9434f7 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 2 | SCP0123_PlanControl.cs:691 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0123_PlanControl.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-357f4827 | this.spdMain.CellClick | SCP0123_PlanControl.cs:890 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf677b08 | this.spdMain.CellClick | SCP0123_PlanControl.cs:902 |  | DATA_OP | DBUtils.Filter | (dtDivision_GM, "CODE = '" + division_id + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8ffad4f6 | this.spdMain.CellClick | SCP0123_PlanControl.cs:927 | if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ if (actv_cd == "A001") | UI_PROP | popupSCP0039.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-26680208 | this.spdMain.CellClick | SCP0123_PlanControl.cs:928 | if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ if (actv_cd == "A001") | POPUP | popupSCP0039.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-80e3188b | this.spdMain.CellClick | SCP0123_PlanControl.cs:930 | if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ if (actv_cd == "A001") ▸ if (popupSCP0039.ShowDialog() == DialogResult.OK) | FLAG | this.isValidSearch | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8ec49c1e | this.spdMain.CellClick | SCP0123_PlanControl.cs:931 | if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ if (actv_cd == "A001") ▸ if (popupSCP0039.ShowDialog() == DialogResult.OK) | FLAG | this.iCriticalCnt | popupSCP0039.CriticalCnt | 화면 필드/플래그 변경 |  |  |  |
| AC-d5b589c6 | this.spdMain.CellClick | SCP0123_PlanControl.cs:932 | if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ if (actv_cd == "A001") ▸ if (popupSCP0039.ShowDialog() == DialogResult.OK) | FLAG | this.iWarningCng | popupSCP0039.WarningCnt | 화면 필드/플래그 변경 |  |  |  |
| AC-ad04da4d | this.spdMain.CellClick | SCP0123_PlanControl.cs:935 | if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ if (actv_cd == "A001") ▸ if (popupSCP0039.ShowDialog() == DialogResult.OK) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex("DETAIL"), sDetail) | 그리드 값 설정 |  |  |  |
| AC-fec230b9 | this.spdMain.CellClick | SCP0123_PlanControl.cs:943 | if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (actv_cd == "A001") ▸ if (actv_cd == "A002") ▸ if (string.IsNullOrEmpty(pl… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44cfb8c2 | this.spdMain.CellClick | SCP0123_PlanControl.cs:945 | if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (actv_cd == "A001") ▸ if (actv_cd == "A002") | POPUP | new SCP0123_PlanIDCreatePopup | (division_id, prs_cd, plan_group_id, plan_group_name, plan_start_yyyymmdd, plan_id, tgt_di… | 팝업/폼 생성 |  |  |  |
| AC-ac4639af | this.spdMain.CellClick | SCP0123_PlanControl.cs:946 | if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (actv_cd == "A001") ▸ if (actv_cd == "A002") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e65e887e | this.spdMain.CellClick | SCP0123_PlanControl.cs:947 | if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (actv_cd == "A001") ▸ if (actv_cd == "A002") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-07f38f3e | this.spdMain.CellClick | SCP0123_PlanControl.cs:952 | if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (actv_cd == "A001") ▸ else of (actv_cd == "A002") ▸ if (actv_cd == "A003") | FLAG | this.nSelRowSpdMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-22e9b28c | this.spdMain.CellClick | SCP0123_PlanControl.cs:957 | if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (actv_cd == "A001") ▸ else of (actv_cd == "A002") ▸ if (actv_cd == "A003")… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-68f64ba3 | this.spdMain.CellClick | SCP0123_PlanControl.cs:958 | if (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (actv_cd == "A001") ▸ else of (actv_cd == "A002") ▸ if (actv_cd == "A003")… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-65e42b0a | this.spdMain.CellClick | SCP0123_PlanControl.cs:995 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("이전 Activity가 수행되지 않았습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-117911be | this.spdMain.CellClick | SCP0123_PlanControl.cs:996 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e63665ec | this.spdMain.CellClick | SCP0123_PlanControl.cs:1006 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fbcdc3db | this.spdMain.CellClick | SCP0123_PlanControl.cs:1017 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00469") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-08033f0b | this.spdMain.CellClick | SCP0123_PlanControl.cs:1018 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1992ece7 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1025 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00470") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-89202a71 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1026 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc4fd5cc | this.spdMain.CellClick | SCP0123_PlanControl.cs:1033 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00184") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e11cf8cd | this.spdMain.CellClick | SCP0123_PlanControl.cs:1034 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f295e954 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1042 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00465") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0fa04548 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1043 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90b0010b | this.spdMain.CellClick | SCP0123_PlanControl.cs:1048 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00183") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3a421679 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1049 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00ddb44a | this.spdMain.CellClick | SCP0123_PlanControl.cs:1061 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | POPUP | new SCP0123_PlanIDCreatePopup | (division_id, prs_cd, plan_group_id, plan_group_name, plan_start_yyyymmdd, "", tgt_divs_cd… | 팝업/폼 생성 |  |  |  |
| AC-eba19772 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1062 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ed17c7a5 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1064 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-de5e5d6d | this.spdMain.CellClick | SCP0123_PlanControl.cs:1067 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | FLAG | dtPlanIDAll | Data_SCP.CommonAll(Data_SCP.Type.PlanID, false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-df424f6a | this.spdMain.CellClick | SCP0123_PlanControl.cs:1067 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.PlanID, false, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5a5f389f | this.spdMain.CellClick | SCP0123_PlanControl.cs:1080 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("이미 처리된 Plan ID 입니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de4d72b7 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1081 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7da2dd9 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1087 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d3553706 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1088 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-51c5266f | this.spdMain.CellClick | SCP0123_PlanControl.cs:1092 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00183") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5e2319d1 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1093 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-414e1ad5 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1103 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d2bfc070 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1104 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-743f62af | this.spdMain.CellClick | SCP0123_PlanControl.cs:1123 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("선택된 Plan ID의 Engine Run이 실행되지 않았습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-920b0fe4 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1124 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f3d14b3 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1132 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00466") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8bfca8ae | this.spdMain.CellClick | SCP0123_PlanControl.cs:1133 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11df4361 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1138 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00183") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4679ee33 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1139 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c2ca8c4 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1151 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9fd7ac39 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1152 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8ff89b3 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1171 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("선택된 Plan ID의 Engine Run이 실행되지 않았습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df060838 | this.spdMain.CellClick | SCP0123_PlanControl.cs:1172 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1379fe6a | this.spdMain.CellClick | SCP0123_PlanControl.cs:1177 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00183") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-084f9dcc | this.spdMain.CellClick | SCP0123_PlanControl.cs:1178 | else of (e.Column == siMain.GetColumnIndex(DefColumns.LINK)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0123_PlanControl.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ed73e76 | this.spdMain.CellDoubleClick | SCP0123_PlanControl.cs:1263 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2843a49e | this.spdMain.CellDoubleClick | SCP0123_PlanControl.cs:1272 | if (actv_cd == "A003") | FLAG | this.nSelRowSpdMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-6e672146 | this.spdMain.CellDoubleClick | SCP0123_PlanControl.cs:1277 | if (actv_cd == "A003") ▸ if (string.IsNullOrEmpty(plan_id)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6b58ad69 | this.spdMain.CellDoubleClick | SCP0123_PlanControl.cs:1278 | if (actv_cd == "A003") ▸ if (string.IsNullOrEmpty(plan_id)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4533b3b | this.spdMain.CellDoubleClick | SCP0123_PlanControl.cs:1286 | else of (actv_cd == "A003") | FLAG | this.nSelRowSpdMain | -1 | 화면 필드/플래그 변경 |  |  |  |

## SCP0123_PlanControl.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f12c576e | this.spdMain.ComboSelChange | SCP0123_PlanControl.cs:1305 | if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_RUN_STAT_CD), ds.Tables[0].Rows[0][DefC… | 그리드 값 설정 |  |  |  |
| AC-b640f36b | this.spdMain.ComboSelChange | SCP0123_PlanControl.cs:1306 | if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPMZ_ACTV_RUN_STAT_NAME), ds.Tables[0].Rows[0][De… | 그리드 값 설정 |  |  |  |
| AC-5339b20b | this.spdMain.ComboSelChange | SCP0123_PlanControl.cs:1307 | if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), ds.Tables[0].Rows[0][DefColumns… | 그리드 값 설정 |  |  |  |
| AC-e3acdfcb | this.spdMain.ComboSelChange | SCP0123_PlanControl.cs:1308 | if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_ID)) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), ds.Tables[0].Rows[0][DefColumn… | 그리드 값 설정 |  |  |  |

## SCP0123_PlanControl.SpdMain_KeyPress

진입점: this.spdMain.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee8644cf | this.spdMain.KeyPress | SCP0123_PlanControl.cs:1319 | if (!fps.ActiveSheet.Cells[fps.ActiveSheet.ActiveRow.Index, fps.ActiveSheet.ActiveColumn.Index].Locked) ▸ if (fps.ActiveSheet.Columns[fps.Ac… | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |

## SCP0123_PlanIDCreatePopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd8351aa | .ctor | SCP0123_PlanIDCreatePopup.cs:77 |  | FLAG | this.division_id | p_division_id | 화면 필드/플래그 변경 |  |  |  |
| AC-ab071ce0 | .ctor | SCP0123_PlanIDCreatePopup.cs:78 |  | FLAG | this.prs_cd | p_prs_cd | 화면 필드/플래그 변경 |  |  |  |
| AC-7b83066c | .ctor | SCP0123_PlanIDCreatePopup.cs:79 |  | FLAG | this.plan_group_id | p_plan_group_id | 화면 필드/플래그 변경 |  |  |  |
| AC-98858a61 | .ctor | SCP0123_PlanIDCreatePopup.cs:80 |  | FLAG | this.plan_group_name | p_plan_group_name | 화면 필드/플래그 변경 |  |  |  |
| AC-837e83fb | .ctor | SCP0123_PlanIDCreatePopup.cs:81 |  | FLAG | this.plan_start_yyyymmdd | p_plan_start_yyyymmdd | 화면 필드/플래그 변경 |  |  |  |
| AC-a5a5c1d2 | .ctor | SCP0123_PlanIDCreatePopup.cs:82 |  | FLAG | this.plan_id | p_plan_id | 화면 필드/플래그 변경 |  |  |  |
| AC-17862697 | .ctor | SCP0123_PlanIDCreatePopup.cs:83 |  | FLAG | this.tgt_divis_cd | p_tgt_divs_cd | 화면 필드/플래그 변경 |  |  |  |

## SCP0123_PlanIDCreatePopup.BtnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be5b8aba | this.btnClose.Click | SCP0123_PlanIDCreatePopup.cs:435 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0123_PlanIDCreatePopup.CboProdCd_SelectedIndexChanged

진입점: this.cboProdCd.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee449a73 | this.cboProdCd.SelectedIndexChanged | SCP0123_PlanIDCreatePopup.cs:423 |  | DATA_OP | this.dtInitSCPPlanID.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0123_PlanIDCreatePopup.CboShipCd_SelectedIndexChanged

진입점: this.cboShipCd.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd409290 | this.cboShipCd.SelectedIndexChanged | SCP0123_PlanIDCreatePopup.cs:417 |  | DATA_OP | this.dtInitSCPPlanID.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0123_PlanIDCreatePopup.ChkCellNoFrozen_CheckedChanged

진입점: this.chkCellNoFrozen.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e85e569c | this.chkCellNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:338 | if (chkCellNoFrozen.Checked == true) | UI_PROP | dpCellEnd.nullValueYN | true | 속성 nullValueYN 설정 |  |  |  |
| AC-4ad9969c | this.chkCellNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:339 | if (chkCellNoFrozen.Checked == true) | VALUE_CLEAR | dpCellEnd.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1d6a3019 | this.chkCellNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:340 | if (chkCellNoFrozen.Checked == true) | STATE | dpCellEnd.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b5520a6f | this.chkCellNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:344 | else of (chkCellNoFrozen.Checked == true) | UI_PROP | dpCellEnd.nullValueYN | false | 속성 nullValueYN 설정 |  |  |  |
| AC-d92134e9 | this.chkCellNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:345 | else of (chkCellNoFrozen.Checked == true) | STATE | dpCellEnd.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c2a8b9a8 | this.chkCellNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:353 | else of (chkCellNoFrozen.Checked == true) ▸ if (dtInitDate != null) ▸ for (i < dtInitDate.Rows.Count) ▸ if (this.tgt_divis_cd == this.dtInit… | VALUE_SET | dpCellEnd.Text | this.dtInitDate.Rows[i][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-94a0529c | this.chkCellNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:359 | else of (chkCellNoFrozen.Checked == true) ▸ else of (dtInitDate != null) | VALUE_SET | dpCellEnd.Text | DateTime.Now.ToShortDateString() | 컨트롤 값 설정 |  |  |  |
| AC-64935e42 | this.chkCellNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:359 | else of (chkCellNoFrozen.Checked == true) ▸ else of (dtInitDate != null) | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0123_PlanIDCreatePopup.ChkProdNoFrozen_CheckedChanged

진입점: this.chkProdNoFrozen.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62612820 | this.chkProdNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:308 | if (chkProdNoFrozen.Checked == true) | UI_PROP | dpProdEnd.nullValueYN | true | 속성 nullValueYN 설정 |  |  |  |
| AC-0032f81e | this.chkProdNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:309 | if (chkProdNoFrozen.Checked == true) | VALUE_CLEAR | dpProdEnd.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9d2e17c7 | this.chkProdNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:310 | if (chkProdNoFrozen.Checked == true) | STATE | dpProdEnd.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d6019d3a | this.chkProdNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:314 | else of (chkProdNoFrozen.Checked == true) | UI_PROP | dpProdEnd.nullValueYN | false | 속성 nullValueYN 설정 |  |  |  |
| AC-b6cdbb8b | this.chkProdNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:315 | else of (chkProdNoFrozen.Checked == true) | STATE | dpProdEnd.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4c9922de | this.chkProdNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:323 | else of (chkProdNoFrozen.Checked == true) ▸ if (dtInitDate != null) ▸ for (i < dtInitDate.Rows.Count) ▸ if (this.tgt_divis_cd == this.dtInit… | VALUE_SET | dpProdEnd.Text | this.dtInitDate.Rows[i][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-312cdaaa | this.chkProdNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:329 | else of (chkProdNoFrozen.Checked == true) ▸ else of (dtInitDate != null) | VALUE_SET | dpProdEnd.Text | DateTime.Now.ToShortDateString() | 컨트롤 값 설정 |  |  |  |
| AC-35578e41 | this.chkProdNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:329 | else of (chkProdNoFrozen.Checked == true) ▸ else of (dtInitDate != null) | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0123_PlanIDCreatePopup.ChkShipNoFrozen_CheckedChanged

진입점: this.chkShipNoFrozen.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b86c6f6f | this.chkShipNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:368 | if (chkShipNoFrozen.Checked == true) | UI_PROP | dpShipEnd.nullValueYN | true | 속성 nullValueYN 설정 |  |  |  |
| AC-1b8f9d50 | this.chkShipNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:369 | if (chkShipNoFrozen.Checked == true) | VALUE_CLEAR | dpShipEnd.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-56607467 | this.chkShipNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:370 | if (chkShipNoFrozen.Checked == true) | STATE | dpShipEnd.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bae89058 | this.chkShipNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:374 | else of (chkShipNoFrozen.Checked == true) | UI_PROP | dpShipEnd.nullValueYN | false | 속성 nullValueYN 설정 |  |  |  |
| AC-66799ec4 | this.chkShipNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:375 | else of (chkShipNoFrozen.Checked == true) | STATE | dpShipEnd.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-21c29ac1 | this.chkShipNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:383 | else of (chkShipNoFrozen.Checked == true) ▸ if (dtInitDate != null) ▸ for (i < dtInitDate.Rows.Count) ▸ if (this.tgt_divis_cd == this.dtInit… | VALUE_SET | dpShipEnd.Text | this.dtInitDate.Rows[i][2].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-863d88c6 | this.chkShipNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:389 | else of (chkShipNoFrozen.Checked == true) ▸ else of (dtInitDate != null) | VALUE_SET | dpShipEnd.Text | DateTime.Now.ToShortDateString() | 컨트롤 값 설정 |  |  |  |
| AC-8658dc9f | this.chkShipNoFrozen.CheckedChanged | SCP0123_PlanIDCreatePopup.cs:389 | else of (chkShipNoFrozen.Checked == true) ▸ else of (dtInitDate != null) | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0123_PlanIDCreatePopup.ConvertToDateString

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-951c0d6c | this.Load | SCP0123_PlanIDCreatePopup.cs:454 |  | RETURN | return rtn; |  | 처리 중단/반환 |  |  |  |

## SCP0123_PlanIDCreatePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5237a26c | Dispose | SCP0123_PlanIDCreatePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0123_PlanIDCreatePopup.GetInitInfo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e946b7e5 | this.Load | SCP0123_PlanIDCreatePopup.cs:276 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0123_GET_PLAN_ID_CREATE_INFO") ⇒ SCP.SCP0123_GET_PLAN_ID_CREATE_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-8606dacf | this.Load | SCP0123_PlanIDCreatePopup.cs:278 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4647fafc | this.Load | SCP0123_PlanIDCreatePopup.cs:279 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-25f365e8 | this.Load | SCP0123_PlanIDCreatePopup.cs:280 |  | DATA_OP | request.Parameters["p_plan_group_id"] | p_plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-7f721c81 | this.Load | SCP0123_PlanIDCreatePopup.cs:281 |  | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6e2bcd0e | this.Load | SCP0123_PlanIDCreatePopup.cs:282 |  | DATA_OP | request.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-dbe9dca9 | this.Load | SCP0123_PlanIDCreatePopup.cs:284 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6bfd05d4 | this.Load | SCP0123_PlanIDCreatePopup.cs:288 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0123_PlanIDCreatePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32208569 | this.Load | SCP0123_PlanIDCreatePopup.cs:106 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-dc26a2d6 | this.Load | SCP0123_PlanIDCreatePopup.cs:108 |  | FLAG | dsInitInfo | GetInitInfo(this.division_id, this.plan_group_id, this.plan_start_yyyymmdd, this.plan_id) | 화면 필드/플래그 변경 |  |  |  |
| AC-92b7a33f | this.Load | SCP0123_PlanIDCreatePopup.cs:109 |  | FLAG | this.dtInitInfo1 | dsInitInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4ffc5045 | this.Load | SCP0123_PlanIDCreatePopup.cs:110 |  | FLAG | this.dtInitDate | dsInitInfo.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-702a2d78 | this.Load | SCP0123_PlanIDCreatePopup.cs:111 |  | FLAG | this.dtInitInfo2 | dsInitInfo.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-ffcd485a | this.Load | SCP0123_PlanIDCreatePopup.cs:112 |  | FLAG | this.dtInitSCPPlanID | dsInitInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-581fccbd | this.Load | SCP0123_PlanIDCreatePopup.cs:113 |  | FLAG | this.dtPlanIDInfo | dsInitInfo.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-ea0e9a3d | this.Load | SCP0123_PlanIDCreatePopup.cs:116 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPMZ_DIVISION_GM") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-752b96ea | this.Load | SCP0123_PlanIDCreatePopup.cs:117 |  | DATA_OP | DBUtils.Filter | (dtDivision_GM, "CODE = '" + this.division_id + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-463c8c70 | this.Load | SCP0123_PlanIDCreatePopup.cs:122 | if (dtGM.Rows.Count > 0) | FLAG | dtSysProdCd | DBUtils.Filter(dtSysProdCd, "CODE <> 'SCP'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-44a4a396 | this.Load | SCP0123_PlanIDCreatePopup.cs:122 | if (dtGM.Rows.Count > 0) | DATA_OP | DBUtils.Filter | (dtSysProdCd, "CODE <> 'SCP'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8cbfecd7 | this.Load | SCP0123_PlanIDCreatePopup.cs:123 | if (dtGM.Rows.Count > 0) | FLAG | dtSysShipCd | DBUtils.Filter(dtSysShipCd, "CODE <> 'SCP'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-b7441649 | this.Load | SCP0123_PlanIDCreatePopup.cs:123 | if (dtGM.Rows.Count > 0) | DATA_OP | DBUtils.Filter | (dtSysShipCd, "CODE <> 'SCP'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6c671a8d | this.Load | SCP0123_PlanIDCreatePopup.cs:127 |  | LIST_REBIND | clsCtrl.setListBox | (dtSysProdCd, cboProdCd, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-898c6111 | this.Load | SCP0123_PlanIDCreatePopup.cs:128 |  | LIST_REBIND | clsCtrl.setListBox | (dtSysShipCd, cboShipCd, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-37a52246 | this.Load | SCP0123_PlanIDCreatePopup.cs:129 |  | VALUE_SET | cboProdCd.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-3691899a | this.Load | SCP0123_PlanIDCreatePopup.cs:130 |  | VALUE_SET | cboShipCd.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-07b65aa2 | this.Load | SCP0123_PlanIDCreatePopup.cs:133 |  | DATA_OP | this.dtInitSCPPlanID.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8705596f | this.Load | SCP0123_PlanIDCreatePopup.cs:136 |  | DATA_OP | this.dtInitSCPPlanID.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-59ceaa5d | this.Load | SCP0123_PlanIDCreatePopup.cs:140 |  | DATA_OP | dtParameter.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-31f77547 | this.Load | SCP0123_PlanIDCreatePopup.cs:141 |  | DATA_OP | dtParameter.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3242e05 | this.Load | SCP0123_PlanIDCreatePopup.cs:143 |  | DATA_OP | dtParameter.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f403f91a | this.Load | SCP0123_PlanIDCreatePopup.cs:144 |  | DATA_OP | drRow1["CODE"] | "Normal" | 행/컬럼 값 대입 |  |  |  |
| AC-77394567 | this.Load | SCP0123_PlanIDCreatePopup.cs:145 |  | DATA_OP | drRow1["NAME"] | "Normal" | 행/컬럼 값 대입 |  |  |  |
| AC-3548a85d | this.Load | SCP0123_PlanIDCreatePopup.cs:146 |  | DATA_OP | dtParameter.Rows.Add | (drRow1) | 데이터 객체 조작/조회 |  |  |  |
| AC-07478adb | this.Load | SCP0123_PlanIDCreatePopup.cs:148 |  | LIST_REBIND | clsCtrl.setListBox | (dtParameter, cboParameter, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1326b8c0 | this.Load | SCP0123_PlanIDCreatePopup.cs:149 |  | STATE | cboParameter.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-78ec4e6e | this.Load | SCP0123_PlanIDCreatePopup.cs:151 |  | VALUE_SET | txtPlanGroup.Text | this.plan_group_name | 컨트롤 값 설정 |  |  |  |
| AC-2c86ddff | this.Load | SCP0123_PlanIDCreatePopup.cs:155 |  | VALUE_SET | txtHorizonStart.Text | start_date | 컨트롤 값 설정 |  |  |  |
| AC-65e99d9f | this.Load | SCP0123_PlanIDCreatePopup.cs:156 |  | VALUE_SET | txtProdStart.Text | start_date | 컨트롤 값 설정 |  |  |  |
| AC-a3c243ba | this.Load | SCP0123_PlanIDCreatePopup.cs:157 |  | VALUE_SET | txtCellStart.Text | start_date | 컨트롤 값 설정 |  |  |  |
| AC-1e4b7b29 | this.Load | SCP0123_PlanIDCreatePopup.cs:158 |  | VALUE_SET | txtShipStart.Text | start_date | 컨트롤 값 설정 |  |  |  |
| AC-18aab240 | this.Load | SCP0123_PlanIDCreatePopup.cs:162 | if (dtInitInfo1 != null && this.dtInitInfo1.Rows.Count > 0) | VALUE_SET | dpHorizonEnd.Text | this.dtInitInfo1.Rows[0][0].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-feb6c80d | this.Load | SCP0123_PlanIDCreatePopup.cs:163 | if (dtInitInfo1 != null && this.dtInitInfo1.Rows.Count > 0) | VALUE_SET | txtFcstVersion.Text | this.dtInitInfo1.Rows[0][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-de27d966 | this.Load | SCP0123_PlanIDCreatePopup.cs:172 | if (dtInitDate != null) ▸ for (i < dtInitDate.Rows.Count) ▸ if (this.tgt_divis_cd == this.dtInitDate.Rows[i][0].ToString()) | VALUE_SET | dpProdEnd.Text | this.dtInitDate.Rows[i][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-30447049 | this.Load | SCP0123_PlanIDCreatePopup.cs:173 | if (dtInitDate != null) ▸ for (i < dtInitDate.Rows.Count) ▸ if (this.tgt_divis_cd == this.dtInitDate.Rows[i][0].ToString()) | VALUE_SET | dpCellEnd.Text | this.dtInitDate.Rows[i][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-bb440c01 | this.Load | SCP0123_PlanIDCreatePopup.cs:174 | if (dtInitDate != null) ▸ for (i < dtInitDate.Rows.Count) ▸ if (this.tgt_divis_cd == this.dtInitDate.Rows[i][0].ToString()) | VALUE_SET | dpShipEnd.Text | this.dtInitDate.Rows[i][2].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-06b5533c | this.Load | SCP0123_PlanIDCreatePopup.cs:180 | else of (dtInitDate != null) | VALUE_SET | dpProdEnd.Text | DateTime.Now.ToShortDateString() | 컨트롤 값 설정 |  |  |  |
| AC-e979346c | this.Load | SCP0123_PlanIDCreatePopup.cs:180 | else of (dtInitDate != null) | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c9328745 | this.Load | SCP0123_PlanIDCreatePopup.cs:181 | else of (dtInitDate != null) | VALUE_SET | dpCellEnd.Text | DateTime.Now.ToShortDateString() | 컨트롤 값 설정 |  |  |  |
| AC-ffd81e56 | this.Load | SCP0123_PlanIDCreatePopup.cs:181 | else of (dtInitDate != null) | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-824f0eac | this.Load | SCP0123_PlanIDCreatePopup.cs:182 | else of (dtInitDate != null) | VALUE_SET | dpShipEnd.Text | DateTime.Now.ToShortDateString() | 컨트롤 값 설정 |  |  |  |
| AC-2f40fbfe | this.Load | SCP0123_PlanIDCreatePopup.cs:182 | else of (dtInitDate != null) | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-344c2c50 | this.Load | SCP0123_PlanIDCreatePopup.cs:187 | if (this.tgt_divis_cd != "P") | VALUE_SET | this.lciProdStart.Text | "Period" | 컨트롤 값 설정 |  |  |  |
| AC-3e95d810 | this.Load | SCP0123_PlanIDCreatePopup.cs:188 | if (this.tgt_divis_cd != "P") | UI_PROP | this.lciCellStart.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-02131bc9 | this.Load | SCP0123_PlanIDCreatePopup.cs:189 | if (this.tgt_divis_cd != "P") | UI_PROP | this.lciCellEnd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3d074691 | this.Load | SCP0123_PlanIDCreatePopup.cs:190 | if (this.tgt_divis_cd != "P") | UI_PROP | this.lciCellNoFroaen.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-aafabc4c | this.Load | SCP0123_PlanIDCreatePopup.cs:193 |  | STATE | txtPlanGroup.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-64df169b | this.Load | SCP0123_PlanIDCreatePopup.cs:194 |  | STATE | txtHorizonStart.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3eda3efe | this.Load | SCP0123_PlanIDCreatePopup.cs:196 |  | STATE | txtFcstVersion.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-616464e5 | this.Load | SCP0123_PlanIDCreatePopup.cs:197 |  | STATE | txtProdStart.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-572556a7 | this.Load | SCP0123_PlanIDCreatePopup.cs:198 |  | STATE | txtCellStart.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-aac7515d | this.Load | SCP0123_PlanIDCreatePopup.cs:199 |  | STATE | txtShipStart.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0123_PlanIDCreatePopup.RefreshPlanId

진입점: this.Load / this.cboProdCd.SelectedIndexChanged / this.cboShipCd.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dc9a065 | this.Load 외 2 | SCP0123_PlanIDCreatePopup.cs:405 | if (plan_type == "SCP") | LIST_REBIND | clsCtrl.setListBox | (dtPlanID, cboPlanID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b5e99c3c | this.Load 외 2 | SCP0123_PlanIDCreatePopup.cs:409 | else of (plan_type == "SCP") | FLAG | dtPlan | DBUtils.Filter(this.dtInitInfo2, "PLAN_TYPE = '" + plan_type + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-371d17d5 | this.Load 외 2 | SCP0123_PlanIDCreatePopup.cs:409 | else of (plan_type == "SCP") | DATA_OP | DBUtils.Filter | (this.dtInitInfo2, "PLAN_TYPE = '" + plan_type + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-99f0ddab | this.Load 외 2 | SCP0123_PlanIDCreatePopup.cs:410 | else of (plan_type == "SCP") | LIST_REBIND | clsCtrl.setListBox | (dtPlan, cboPlanID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0123_PlanIDCreatePopup.SaveData

진입점: this.btnCreatePlan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8cffdaf | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:498 | if (p_prod_frz_start_yyyymmdd != "" && p_prod_frz_end_yyyymmdd != "") ▸ if (DateTime.Compare(dtStart, dtEnd) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-41def45e | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:499 | if (p_prod_frz_start_yyyymmdd != "" && p_prod_frz_end_yyyymmdd != "") ▸ if (DateTime.Compare(dtStart, dtEnd) > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a68e505e | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:510 | if (p_cell_prod_frz_start_yyyymmdd != "" && p_cell_prod_frz_end_yyyymmdd != "") ▸ if (DateTime.Compare(dtStart, dtEnd) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6f13488 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:511 | if (p_cell_prod_frz_start_yyyymmdd != "" && p_cell_prod_frz_end_yyyymmdd != "") ▸ if (DateTime.Compare(dtStart, dtEnd) > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0bc178e1 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:522 | if (p_ship_frz_start_yyyymmdd != "" && p_ship_frz_end_yyyymmdd != "") ▸ if (DateTime.Compare(dtStart, dtEnd) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d0547f2d | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:523 | if (p_ship_frz_start_yyyymmdd != "" && p_ship_frz_end_yyyymmdd != "") ▸ if (DateTime.Compare(dtStart, dtEnd) > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5236fa0 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:528 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f23749b2 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:529 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-301561ea | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:533 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0123_SAVE_PLAN_ID_CREATE") ⇒ SCP.SCP0123_SAVE_PLAN_ID_CREATE | 엔드포인트 요청 생성 |  |  |  |
| AC-29989c2e | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:536 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", BLUtils.GSCM_SCP_MASTER_SVC)) { req… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b87556c8 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:540 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-89030237 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:542 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | this.division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8fac8af7 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:543 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_gr_id"] | this.plan_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-69294f40 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:544 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_gr_name"] | this.plan_group_name | 행/컬럼 값 대입 |  |  |  |
| AC-3b5113a8 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:545 | try ▸ lambda | DATA_OP | req.Parameters["p_prs_cd"] | this.prs_cd | 행/컬럼 값 대입 |  |  |  |
| AC-a28a4912 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:546 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-003dd67d | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:547 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_end_yyyymmdd"] | p_plan_end_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f4bd3691 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:548 | try ▸ lambda | DATA_OP | req.Parameters["p_dmd_ver_id"] | p_dmd_ver_id | 행/컬럼 값 대입 |  |  |  |
| AC-8d841bad | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:549 | try ▸ lambda | DATA_OP | req.Parameters["p_prod_ref_sys_divs_cd"] | p_prod_ref_sys_divs_cd | 행/컬럼 값 대입 |  |  |  |
| AC-5744e858 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:550 | try ▸ lambda | DATA_OP | req.Parameters["p_prod_ref_sys_plan_id"] | p_prod_ref_sys_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-b1d6f6a2 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:551 | try ▸ lambda | DATA_OP | req.Parameters["p_prod_frz_start_yyyymmdd"] | p_prod_frz_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-79b4f24f | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:552 | try ▸ lambda | DATA_OP | req.Parameters["p_prod_frz_end_yyyymmdd"] | p_prod_frz_end_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-85f3d98e | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:553 | try ▸ lambda | DATA_OP | req.Parameters["p_cell_prod_frz_start_yyyymmdd"] | p_cell_prod_frz_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cac9264a | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:554 | try ▸ lambda | DATA_OP | req.Parameters["p_cell_prod_frz_end_yyyymmdd"] | p_cell_prod_frz_end_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2e83d151 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:555 | try ▸ lambda | DATA_OP | req.Parameters["p_ship_ref_sys_divs_cd"] | p_ship_ref_sys_divs_cd | 행/컬럼 값 대입 |  |  |  |
| AC-654422ee | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:556 | try ▸ lambda | DATA_OP | req.Parameters["p_ship_ref_sys_plan_id"] | p_ship_ref_sys_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-dd202326 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:557 | try ▸ lambda | DATA_OP | req.Parameters["p_ship_frz_start_yyyymmdd"] | p_ship_frz_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3cda52a1 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:558 | try ▸ lambda | DATA_OP | req.Parameters["p_ship_frz_end_yyyymmdd"] | p_ship_frz_end_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4b40b9a0 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:559 | try ▸ lambda | DATA_OP | req.Parameters["p_pram_ty_cd"] | p_pram_ty_cd | 행/컬럼 값 대입 |  |  |  |
| AC-70fd4dfa | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:560 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_desc"] | p_plan_desc | 행/컬럼 값 대입 |  |  |  |
| AC-22d911d3 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:561 | try ▸ lambda | DATA_OP | req.Parameters["p_prod_no_frz_yn"] | p_prod_no_frz_yn | 행/컬럼 값 대입 |  |  |  |
| AC-92d35761 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:562 | try ▸ lambda | DATA_OP | req.Parameters["p_cell_no_frz_yn"] | p_cell_no_frz_yn | 행/컬럼 값 대입 |  |  |  |
| AC-b8386227 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:563 | try ▸ lambda | DATA_OP | req.Parameters["p_ship_no_frz_yn"] | p_ship_no_frz_yn | 행/컬럼 값 대입 |  |  |  |
| AC-a09c98e4 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:564 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c3ed6842 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:566 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a8794d4 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:566 | try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-7575e350 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:570 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fa46be28 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:576 | try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-f2e7f0eb | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:579 | try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (saveMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fb5a95f6 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:586 | try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a5cfcec2 | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:593 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bd60153e | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:594 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f948832d | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:598 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2d450d2b | this.btnCreatePlan.Click | SCP0123_PlanIDCreatePopup.cs:600 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0123_PlanIDCreatePopup.Set_PlanID_Info

진입점: this.Load [if (!string.IsNullOrEmpty(this.plan_id))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b08085e1 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:206 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | VALUE_SET | cboProdCd.SelectedValue | this.dtPlanIDInfo.Rows[0]["PROD_REF_SYS_DIVS_CD"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-3cf983cb | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:207 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | VALUE_SET | cboProdPlanID.SelectedValue | this.dtPlanIDInfo.Rows[0]["PROD_REF_SYS_PLAN_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-0ee42a05 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:208 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | VALUE_SET | dpProdEnd.Text | this.dtPlanIDInfo.Rows[0]["PMDU_PROD_FRZ_END_YYYYMMDD"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-15192423 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:209 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | VALUE_SET | dpCellEnd.Text | this.dtPlanIDInfo.Rows[0]["CELL_PROD_FRZ_END_YYYYMMDD"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-3d701711 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:211 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | VALUE_SET | cboShipCd.SelectedValue | this.dtPlanIDInfo.Rows[0]["SHIP_REF_SYS_DIVS_CD"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5717fa0b | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:212 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | VALUE_SET | cboShipPlanID.SelectedValue | this.dtPlanIDInfo.Rows[0]["SHIP_REF_SYS_PLAN_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-20123f12 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:213 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | VALUE_SET | dpShipEnd.Text | this.dtPlanIDInfo.Rows[0]["SHIP_FRZ_END_YYYYMMDD"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-11b55184 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:215 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | VALUE_SET | cboParameter.SelectedValue | this.dtPlanIDInfo.Rows[0]["OPMZ_PRAM_TP_CD"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-6359b156 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:216 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | VALUE_SET | txtDesc.Text | this.dtPlanIDInfo.Rows[0]["OPMZ_PLAN_DESC"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ad632f79 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:219 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | VALUE_SET | dpHorizonEnd.Text | this.dtPlanIDInfo.Rows[0]["PLAN_END_YYYYMMDD"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-e278ec27 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:220 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | dpHorizonEnd.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6422999b | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:225 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) ▸ if (this.dtPlanIDInfo.Rows[0]["PROD_NO_FROZEN_YN"].ToString() == "Y") | VALUE_SET | chkProdNoFrozen.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-2c435bc1 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:230 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) ▸ if (this.dtPlanIDInfo.Rows[0]["CELL_NO_FROZEN_YN"].ToString() == "Y") | VALUE_SET | chkCellNoFrozen.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-e3a01eae | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:235 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) ▸ if (this.dtPlanIDInfo.Rows[0]["SHIP_NO_FROZEN_YN"].ToString() == "Y") | VALUE_SET | chkShipNoFrozen.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-9492967a | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:238 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | chkProdNoFrozen.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-61cb3f22 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:239 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | chkCellNoFrozen.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e6bd9f97 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:240 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | chkShipNoFrozen.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e1491e44 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:246 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) ▸ if (this.tgt_divis_cd != "P") | VALUE_SET | dpProdEnd.Text | dpCellEnd.Text | 컨트롤 값 설정 |  |  |  |
| AC-d2aeb0ba | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:247 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) ▸ if (this.tgt_divis_cd != "P") | VALUE_SET | chkProdNoFrozen.Checked | chkCellNoFrozen.Checked | 컨트롤 값 설정 |  |  |  |
| AC-60bab5c8 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:250 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | btnCreatePlan.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-db5570c9 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:252 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | cboProdCd.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ec1b05fe | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:253 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | cboProdPlanID.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-be7152b2 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:254 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | dpProdEnd.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ecc4f3e4 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:255 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | dpCellEnd.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f33aa2c3 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:257 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | cboShipCd.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e7f9d649 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:258 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | cboShipPlanID.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-36a1409c | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:259 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | dpShipEnd.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e5da0c6a | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:261 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | cboParameter.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-dccf93c7 | this.Load [if (!string.IsNullOrEmpty(this.plan_id))] | SCP0123_PlanIDCreatePopup.cs:262 | if (this.dtPlanIDInfo != null && this.dtPlanIDInfo.Rows.Count > 0) | STATE | txtDesc.Enabled | false | 컨트롤 상태 Enabled |  |  |  |


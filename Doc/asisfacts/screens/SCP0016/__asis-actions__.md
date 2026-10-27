# AS-IS 액션 대조표 — SCP0016

> 원천: `Doc/asisfacts/screens/SCP0016/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 166행 · 메서드 28 · 종류 DATA_OP 32 · GRID_INIT 27 · GRID_SET 18 · POPUP 12 · UI_PROP 11 · FLAG 10 · CALL_EXT 10 · ENDPOINT 8 · UI_MISC 7 · RETURN 7 · LIST_REBIND 6 · VALUE_SET 5 · VALIDATE 3 · COMBO_DATA 3 · MESSAGE 2 · STATE 2 · GRID_BIND 1 · GRID_LOCK 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 10


## SCP0016_WaterfallShipmentPlanFG.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-980987db | this.btnColumn.Click | SCP0016_WaterfallShipmentPlanFG.cs:585 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0016", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-5f803eae | this.btnColumn.Click | SCP0016_WaterfallShipmentPlanFG.cs:586 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b2aa8597 | this.btnColumn.Click | SCP0016_WaterfallShipmentPlanFG.cs:587 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51bee1ef | this.btnItem_Id.Click | SCP0016_WaterfallShipmentPlanFG.cs:1293 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-39e39e5d | this.btnItem_Id.Click | SCP0016_WaterfallShipmentPlanFG.cs:1295 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-906817fa | this.btnItem_Id.Click | SCP0016_WaterfallShipmentPlanFG.cs:1296 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a5db76cd | this.btnItem_Id.Click | SCP0016_WaterfallShipmentPlanFG.cs:1297 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-25c2c677 | this.btnItem_Id.Click | SCP0016_WaterfallShipmentPlanFG.cs:1303 | if (popItem.ItemID != "") | VALUE_SET | txtItem_Id.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f985bb3 | this.btnMeasure.Click | SCP0016_WaterfallShipmentPlanFG.cs:1331 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0016", measure, false) | 팝업/폼 생성 |  |  |  |
| AC-eea78d35 | this.btnMeasure.Click | SCP0016_WaterfallShipmentPlanFG.cs:1333 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fb2e8944 | this.btnMeasure.Click | SCP0016_WaterfallShipmentPlanFG.cs:1335 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-884bf2d8 | this.btnMeasure.Click | SCP0016_WaterfallShipmentPlanFG.cs:1339 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-cc6d7c04 | this.btnMeasure.Click | SCP0016_WaterfallShipmentPlanFG.cs:1343 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.BtnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f941366c | this.btnProject.Click | SCP0016_WaterfallShipmentPlanFG.cs:1313 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-bfbed4b1 | this.btnProject.Click | SCP0016_WaterfallShipmentPlanFG.cs:1315 |  | POPUP | popProject.Form_Load | (true, division, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-193012aa | this.btnProject.Click | SCP0016_WaterfallShipmentPlanFG.cs:1316 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-13f4436b | this.btnProject.Click | SCP0016_WaterfallShipmentPlanFG.cs:1317 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-50b01acc | this.btnProject.Click | SCP0016_WaterfallShipmentPlanFG.cs:1323 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.ClbVersion_SelectedIndexChanged

진입점: clbVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-939ca41f | clbVersion.SelectedIndexChanged | SCP0016_WaterfallShipmentPlanFG.cs:612 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59d616bb | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:294 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-58fe9128 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:295 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1a944c36 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:296 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63170e90 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:188 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-f8395c20 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:189 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac0459fa | Dispose | SCP0016_WaterfallShipmentPlanFG.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2f78afa | EditButton | SCP0016_WaterfallShipmentPlanFG.cs:647 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33e1dc4f | EditButton | SCP0016_WaterfallShipmentPlanFG.cs:648 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-922d5b7f | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:661 |  | VALIDATE | DataUtil.checkRequired | (this.usrConditionPanel1) | 프레임워크 검증 |  |  |  |
| AC-b939d5dc | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:661 | if (!DataUtil.checkRequired(this.usrConditionPanel1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cb19bb13 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:663 |  | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-d19abbed | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:663 | if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-abd926e8 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:689 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b211c265 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:693 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8b96077d | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:696 | try | CALL_EXT | DateUtil.MonthDiff | (p_to_yyyymmdd.ToString(), p_from_yyyymmdd.ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0e73d94b | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:711 | try | CALL_EXT | Parallel.For | (0, (nCnt), (i) => { if (i != nCnt-1) { string strStartDate = DateUtil.GetDateAdd(p_from_y… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4119518 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:735 | try ▸ lambda ▸ if (i != nCnt-1) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-93547dfa | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:739 | try ▸ lambda ▸ if (i != nCnt-1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL") ⇒ SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-8a6be93e | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:741 | try ▸ lambda ▸ if (i != nCnt-1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bbc87382 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:743 | try ▸ lambda ▸ if (i != nCnt-1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-adb9aee1 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:745 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | strStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-f12a89fa | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:746 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | strEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-c5add3f7 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:747 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-1d95c1a6 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:748 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-6493aa94 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:749 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-f049f106 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:750 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-db655ad5 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:751 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_version_no"] | p_version_no | 행/컬럼 값 대입 |  |  |  |
| AC-b3ee27ac | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:752 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-a55368d7 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:753 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_program_id"] | "SCP0016" | 행/컬럼 값 대입 |  |  |  |
| AC-202f2cc1 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:754 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-c4948c55 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:755 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-9befc836 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:756 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-3f8cad81 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:762 | try ▸ lambda ▸ if (i != nCnt-1) ▸ if (i == 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-812bd4a1 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:766 | try ▸ lambda ▸ if (i != nCnt-1) ▸ else of (i == 0) ▸ if (i == 1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-22dc585a | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:770 | try ▸ lambda ▸ if (i != nCnt-1) ▸ else of (i == 0) ▸ else of (i == 1) ▸ if (i == 2) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9f750e48 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:778 | try ▸ lambda ▸ else of (i != nCnt-1) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1a18c16 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:782 | try ▸ lambda ▸ else of (i != nCnt-1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL") ⇒ SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | 엔드포인트 요청 생성 |  |  |  |
| AC-c8a37103 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:784 | try ▸ lambda ▸ else of (i != nCnt-1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-37fdbc2e | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:785 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d61c5e10 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:786 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-483d11ee | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:787 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-88c6e640 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:788 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-3dd1d452 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:789 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-bbc414df | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:790 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d307dae4 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:791 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_version_no"] | p_version_no | 행/컬럼 값 대입 |  |  |  |
| AC-532b615c | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:792 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-b13236f3 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:793 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_iso"] | p_iso | 행/컬럼 값 대입 |  |  |  |
| AC-5ee6fc1d | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:794 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_program_id"] | "SCP0016" | 행/컬럼 값 대입 |  |  |  |
| AC-cc0a2936 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:795 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-1b1cce25 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:796 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e3d0cff8 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:797 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-36d62c85 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:799 | try ▸ lambda ▸ else of (i != nCnt-1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c4e7bb38 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:806 | try | FLAG | dsBinding | dsTitle.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-57cbd397 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:806 | try | DATA_OP | dsTitle.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c580de9f | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:807 | try | UI_MISC | dsTitle.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-4b53915c | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:813 | try ▸ if (dsBinding1 != null) | CALL_EXT | DataUtil.SetDataTableQtyData | (dsBinding.Tables[0], dsBinding1.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4b032f1 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:814 | try ▸ if (dsBinding2 != null) | CALL_EXT | DataUtil.SetDataTableQtyData | (dsBinding.Tables[0], dsBinding2.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-585389e8 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:815 | try ▸ if (dsBinding3 != null) | CALL_EXT | DataUtil.SetDataTableQtyData | (dsBinding.Tables[0], dsBinding3.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b566d67 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:850 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-760642df | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:851 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2c7fbfdd | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:903 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4e4a9d52 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:904 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e81028e0 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:909 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8afb8af6 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:911 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ef79e456 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:915 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-17b528e3 | FindButton | SCP0016_WaterfallShipmentPlanFG.cs:917 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec6e1dbc | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:176 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-daf417a2 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:225 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BucketISO, false, "", "", "", "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-439a2e62 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:227 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.GetDayRange

진입점: this.Load / clbVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72820601 | this.Load 외 1 | SCP0016_WaterfallShipmentPlanFG.cs:1165 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, strFromDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d668645e | this.Load 외 1 | SCP0016_WaterfallShipmentPlanFG.cs:1167 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.GetSpdTitle

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.dCalendar.ValueChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05ba36ec | this.Load 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:1123 |  | ENDPOINT | new FoxDataRequest | (procName) ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO \| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-c8c11a5f | this.Load 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:1125 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-474a8d10 | this.Load 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:1126 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6a6b5ba2 | this.Load 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:1128 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-efeab42f | this.Load 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:1128 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-800bd7d7 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:195 |  | DATA_OP | this.ConditionNotUseList.Add | (clbVersion) | 데이터 객체 조작/조회 |  |  |  |
| AC-f46d8e5a | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:198 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-77d2d796 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:201 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-4ac78e8a | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:203 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-883f2888 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:205 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-288a5817 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:207 |  | FLAG | dtBizType | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-c8241ebc | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:207 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-03dd70f9 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:208 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0ccd8b11 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:210 |  | FLAG | dtElecType | Data.Common(Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-5ac3b261 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:210 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7f3b3556 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:211 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-78a4f41c | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:215 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-e66a4dba | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:216 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f25158d8 | this.Load | SCP0016_WaterfallShipmentPlanFG.cs:218 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.InitSpread_2

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.dCalendar.ValueChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89f3120c | this.Load 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:304 |  | GRID_INIT | siMain.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-0cf3fdd8 | this.Load 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:308 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spreadInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-16a09d8f | this.Load 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:314 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.InitSpreadDateColumnISO

진입점: this.Load [if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.dCalendar.ValueChanged [if (siMain != null) ▸ if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / FindButton [if (cboBucketType.ControlValues …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33181675 | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:420 | for (i <= dsSpdTitle.Tables[0].Rows.Count-1) | GRID_INIT | spdInfo.AddNumColumn | (cCOLUMN_LABEL_NAME, cCOLUMN_NAME, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b1faa8b6 | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:422 | for (i <= dsSpdTitle.Tables[0].Rows.Count-1) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(cCOLUMN_NAME), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c6862205 | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:424 | for (i <= dsSpdTitle.Tables[0].Rows.Count-1) | CALL_EXT | Debug.Print | (string.Format("All Rows {0} : cCOLUMN_NAME : {1}", i, cCOLUMN_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-86b0ea56 | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:426 | for (i <= dsSpdTitle.Tables[0].Rows.Count-1) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iSmallStartCol + i, 1, 1, 20, cMMDD_LABEL_NAME, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eccdc1d8 | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:427 | for (i <= dsSpdTitle.Tables[0].Rows.Count-1) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol + i, 1, 1, 20, cCOLUMN_LABEL_NAME, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f23962e1 | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:428 | for (i <= dsSpdTitle.Tables[0].Rows.Count-1) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol + i, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.InitSpreadDateColumnNotISO

진입점: this.Load [else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.dCalendar.ValueChanged [if (siMain != null) ▸ else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / FindButton [else of…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eadb0c18 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:493 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (cCOLUMN_NAME.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (cCOLUMN_LABEL_NAME, cCOLUMN_NAME, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a5a5a6b | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:495 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (cCOLUMN_NAME.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(cCOLUMN_NAME), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-62d5957d | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:501 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (cCOLUMN_NAME.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (cCOLUMN_LABEL_NAME, cCOLUMN_NAME, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d9c9c89 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:503 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (cCOLUMN_NAME.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(cCOLUMN_NAME), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1dd34b41 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:507 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (cCOLUMN_NAME.IndexOf("B_") > 0) ▸ if (cDAY_CODE == DefColumnsLabel.Saturday \|\… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | cDAY_CODE == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-ceadaa43 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:515 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != cLARGE_CLASS_LABEL_NAME) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-120240fa | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:516 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != cLARGE_CLASS_LABEL_NAME) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d00d6474 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:522 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != cLARGE_CLASS_LABEL_NAME) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8319a61 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:523 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != cLARGE_CLASS_LABEL_NAME) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf372229 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:532 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != cLARGE_CLASS_LABEL_NAME) ▸ if (sSmallSpanName != cSMALL_CLASS… | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51690d32 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:533 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != cLARGE_CLASS_LABEL_NAME) ▸ if (sSmallSpanName != cSMALL_CLASS… | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ac55a68d | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:544 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0bbb50af | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:545 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf70a5ee | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:546 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-406066e1 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0016_WaterfallShipmentPlanFG.cs:547 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.RetValue

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_month_idx != 0) ▸ else of (!measure.Equals("BALANCE"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68d34bcb | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … | SCP0016_WaterfallShipmentPlanFG.cs:1047 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27ad0fc9 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0016_WaterfallShipmentPlanFG.cs:970 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_month… | GRID_SET | siMain.SetValue | (iRow, bef_month_idx, sum_month) | 그리드 값 설정 |  |  |  |
| AC-e9541e88 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0016_WaterfallShipmentPlanFG.cs:978 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_month… | GRID_SET | siMain.SetValue | (iRow, bef_month_idx, val) | 그리드 값 설정 |  |  |  |
| AC-5d98e770 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0016_WaterfallShipmentPlanFG.cs:991 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (colN… | GRID_SET | siMain.SetValue | (iRow, bef_week_idx, sum_week) | 그리드 값 설정 |  |  |  |
| AC-1c8b17d4 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0016_WaterfallShipmentPlanFG.cs:999 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (colN… | GRID_SET | siMain.SetValue | (iRow, bef_week_idx, val) | 그리드 값 설정 |  |  |  |
| AC-02125eb7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0016_WaterfallShipmentPlanFG.cs:1020 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else of … | GRID_SET | siMain.SetValue | (iRow, bef_week_idx, sum_week) | 그리드 값 설정 |  |  |  |
| AC-6b52237a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0016_WaterfallShipmentPlanFG.cs:1021 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else of … | GRID_SET | siMain.SetValue | (iRow, bef_month_idx, sum_month) | 그리드 값 설정 |  |  |  |
| AC-b8aaf9a3 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0016_WaterfallShipmentPlanFG.cs:1026 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else of … | GRID_SET | siMain.SetValue | (iRow, bef_week_idx, val) | 그리드 값 설정 |  |  |  |
| AC-77dce858 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0016_WaterfallShipmentPlanFG.cs:1027 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else of … | GRID_SET | siMain.SetValue | (iRow, bef_month_idx, val) | 그리드 값 설정 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e98013b1 | this.Load 외 1 | SCP0016_WaterfallShipmentPlanFG.cs:237 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtVersion | DBUtils.Filter(dtVersionAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-4f007852 | this.Load 외 1 | SCP0016_WaterfallShipmentPlanFG.cs:237 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | DBUtils.Filter | (dtVersionAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-61837e1e | this.Load 외 1 | SCP0016_WaterfallShipmentPlanFG.cs:239 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtVersion, clbVersion, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-595775b4 | this.Load 외 1 | SCP0016_WaterfallShipmentPlanFG.cs:244 | if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-65ccb9a8 | this.Load 외 1 | SCP0016_WaterfallShipmentPlanFG.cs:245 | if (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4ea8dbec | this.Load 외 1 | SCP0016_WaterfallShipmentPlanFG.cs:249 | else of (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.SetDataTableQtyData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a997b44b | (진입점 미연결) | SCP0016_WaterfallShipmentPlanFG.cs:627 | for (i < source.Rows.Count) ▸ for (j < source.Columns.Count) ▸ if (columnName.IndexOf("D_") == 0) | GRID_SET | target.Rows[i][columnName] | source.Rows[i][columnName] | 그리드 속성/값 설정 |  |  |  |
| AC-afdf3ac1 | (진입점 미연결) | SCP0016_WaterfallShipmentPlanFG.cs:632 |  | DATA_OP | target.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.SetOperationGroupByDivision

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-274ca0ed | cboDivision.SelectedIndexChanged | SCP0016_WaterfallShipmentPlanFG.cs:931 | if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtBizType | dtBizTypeAll | 화면 필드/플래그 변경 |  |  |  |
| AC-81546923 | cboDivision.SelectedIndexChanged | SCP0016_WaterfallShipmentPlanFG.cs:935 | else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtBizType | dtBizTypeEEAll | 화면 필드/플래그 변경 |  |  |  |
| AC-723f586e | cboDivision.SelectedIndexChanged | SCP0016_WaterfallShipmentPlanFG.cs:938 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.SetSpreadColumn

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.dCalendar.ValueChanged [if (siMain != null)] / this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-600d7632 | this.Load 외 6 | SCP0016_WaterfallShipmentPlanFG.cs:1235 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ if (isDaily \|\| isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-458685e2 | this.Load 외 6 | SCP0016_WaterfallShipmentPlanFG.cs:1240 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ if (isMonthly \|\| isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-a9c8561e | this.Load 외 6 | SCP0016_WaterfallShipmentPlanFG.cs:1249 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Weekly: ▸ if (isDaily) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d9d86545 | this.Load 외 6 | SCP0016_WaterfallShipmentPlanFG.cs:1253 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Weekly: ▸ else of (isDaily) ▸ if (isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6b5bdd5d | this.Load 외 6 | SCP0016_WaterfallShipmentPlanFG.cs:1258 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Weekly: ▸ if (isMonthly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-739ad48b | this.Load 외 6 | SCP0016_WaterfallShipmentPlanFG.cs:1265 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.WeeklyISO: | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | isWeeklyISO | 그리드 속성/값 설정 |  |  |  |
| AC-3498476d | this.Load 외 6 | SCP0016_WaterfallShipmentPlanFG.cs:1273 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Monthly: ▸ if (isDaily \|\| isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a1b71cc6 | this.Load 외 6 | SCP0016_WaterfallShipmentPlanFG.cs:1277 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Monthly: ▸ else of (isDaily \|\| isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.SetVisibleMontColumns

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.dCalendar.ValueChanged [if (siMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eef154bc | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SCP0016_WaterfallShipmentPlanFG.cs:1178 |  | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.SetVisibleSum

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.dCalendar.ValueChanged [if (siMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87800688 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SCP0016_WaterfallShipmentPlanFG.cs:1351 |  | UI_PROP | lciSum.Visibility | cboBucketType.ControlValues == BucketType.WeeklyISO ? LayoutVisibility.Never : LayoutVisib… | 속성 Visibility 설정 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5aa3c5cd | this.spdMain.CellDoubleClick | SCP0016_WaterfallShipmentPlanFG.cs:1057 | if (cboBucketType.ControlValues == BucketType.WeeklyISO) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8e33b3b9 | this.spdMain.CellDoubleClick | SCP0016_WaterfallShipmentPlanFG.cs:1101 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0016_WaterfallShipmentPlanFG.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc37fd09 | this.spdMain.TopChange | SCP0016_WaterfallShipmentPlanFG.cs:599 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |


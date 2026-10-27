# AS-IS 액션 대조표 — SCP0098

> 원천: `Doc/asisfacts/screens/SCP0098/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 910행 · 메서드 57 · 종류 FLAG 362 · DATA_OP 135 · RETURN 77 · CALL_EXT 56 · MESSAGE 52 · GRID_SET 38 · ENDPOINT 35 · UI_PROP 34 · UI_MISC 28 · GRID_INIT 20 · POPUP 19 · GRID_LOCK 11 · VALUE_SET 8 · FOCUS 8 · COMBO_DATA 8 · LIST_REBIND 6 · VALIDATE 4 · STATE_RESET 3 · THROW 2 · GRID_CLEAR 1 · GRID_BIND 1 · GRID_STYLE 1 · STATE 1 · ⚠ 의미 확인 필요 56


## SCP0098_CAPAReprotSmall.btnCopyData_Click

진입점: this.btnCopyData.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e123e19 | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3732 |  | POPUP | new SCP0098_CopySelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-4af3d70b | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3733 |  | VALUE_SET | select_popup.Text | "Copy Type" | 컨트롤 값 설정 |  |  |  |
| AC-4b55de14 | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3734 |  | CALL_EXT | select_popup.SetOption | (0, "Week") | ⚠ 의미 확인 필요 |  |  |  |
| AC-90756181 | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3735 |  | CALL_EXT | select_popup.SetOption | (1, "Month") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b510bf0e | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3737 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4242ac9e | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3745 | if (select_popup.ShowDialog() == DialogResult.OK) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-79120bdf | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3751 | if (select_popup.ShowDialog() == DialogResult.OK) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c22583fc | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3758 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | sql.AddParameter | ("@p_user_id" , UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8f4a2b8 | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3759 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | sql.AddParameter | ("@p_day_type", sDayType) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc8e7b12 | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3760 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | sql.AddParameter | ("@debug_mode", "F") | ⚠ 의미 확인 필요 |  |  |  |
| AC-14752c9a | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3762 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SCP0098_COPY_MONTH_WEEK") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SCP0098_COPY_MONTH_WEEK… | 엔드포인트 호출 |  |  |  |
| AC-d5e8487f | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3764 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-25fe5b16 | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3768 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToStr… | MESSAGE | MessageHelper.GMessageBox | ("복사 완료되었습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c78803f2 | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3776 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ else of (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f2ebb9ec | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3785 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d47fbaf3 | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3786 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eff74059 | this.btnCopyData.Click | SCP0098_CAPAReprotSmall.cs:3790 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0098_CAPAReprotSmall.btnInput_Click

진입점: this.btnInput.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a81ba257 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3800 |  | CALL_EXT | siMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-918eacf6 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3803 | if (siMain.ActiveSheet.Columns.Get(0).Visible == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00135", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e060277a | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3804 | if (siMain.ActiveSheet.Columns.Get(0).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78e9ad02 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3807 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac5cc751 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3820 | if (pDayWeekCode == "SelectDay") ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72babd22 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3821 | if (pDayWeekCode == "SelectDay") ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b71727f | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3826 | if (string.IsNullOrEmpty(pDayWeekCode)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-693c2c8c | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3839 | if (pCategoryCode == "NO_WORK") ▸ if (checkValue != "Y" && checkValue != "N") | MESSAGE | MessageHelper.GMessageBox | ("비조업은 Y 혹은 N 을 입력하시오.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c3a2ad70 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3840 | if (pCategoryCode == "NO_WORK") ▸ if (checkValue != "Y" && checkValue != "N") | FOCUS | txtInpuValue.Focus | () | 포커스 이동 |  |  |  |
| AC-8c53872c | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3841 | if (pCategoryCode == "NO_WORK") ▸ if (checkValue != "Y" && checkValue != "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e566d31d | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3850 | else of (pCategoryCode == "NO_WORK") ▸ if (pCategoryCode == "LOAD_RATE") ▸ try ▸ if (!(flt >= 0.0 && flt <= 100.0)) | MESSAGE | MessageHelper.GMessageBox | ("가동율(%)은 0.0~100.0 사이의 값을 입력하시오.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d3a48b6e | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3851 | else of (pCategoryCode == "NO_WORK") ▸ if (pCategoryCode == "LOAD_RATE") ▸ try ▸ if (!(flt >= 0.0 && flt <= 100.0)) | FOCUS | txtInpuValue.Focus | () | 포커스 이동 |  |  |  |
| AC-2a28fddc | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3852 | else of (pCategoryCode == "NO_WORK") ▸ if (pCategoryCode == "LOAD_RATE") ▸ try ▸ if (!(flt >= 0.0 && flt <= 100.0)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-56869705 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3857 | else of (pCategoryCode == "NO_WORK") ▸ if (pCategoryCode == "LOAD_RATE") ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("수량을 입력하시오.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-27e4e1cb | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3858 | else of (pCategoryCode == "NO_WORK") ▸ if (pCategoryCode == "LOAD_RATE") ▸ catch ((Exception ex)) | FOCUS | txtInpuValue.Focus | () | 포커스 이동 |  |  |  |
| AC-ce84d966 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3859 | else of (pCategoryCode == "NO_WORK") ▸ if (pCategoryCode == "LOAD_RATE") ▸ catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7949d198 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3869 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ if (pCategoryCode == "RAMP_UP") ▸ try ▸ if (!(flt >= 0.0 && … | MESSAGE | MessageHelper.GMessageBox | ("Ramp-up은 0.0~1.0 사이의 값을 입력하시오.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-94181d6b | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3870 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ if (pCategoryCode == "RAMP_UP") ▸ try ▸ if (!(flt >= 0.0 && … | FOCUS | txtInpuValue.Focus | () | 포커스 이동 |  |  |  |
| AC-32b32e85 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3871 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ if (pCategoryCode == "RAMP_UP") ▸ try ▸ if (!(flt >= 0.0 && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23df49e9 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3876 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ if (pCategoryCode == "RAMP_UP") ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("수량을 입력하시오.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-32d23b0f | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3877 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ if (pCategoryCode == "RAMP_UP") ▸ catch ((Exception ex)) | FOCUS | txtInpuValue.Focus | () | 포커스 이동 |  |  |  |
| AC-0a7b31ff | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3878 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ if (pCategoryCode == "RAMP_UP") ▸ catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-889dd233 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3888 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ else of (pCategoryCode == "RAMP_UP") ▸ if (pCategoryCode == … | MESSAGE | MessageHelper.GMessageBox | ("Daily Capa 는 0보다 큰 값을 입력하시오.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c5334d0 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3889 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ else of (pCategoryCode == "RAMP_UP") ▸ if (pCategoryCode == … | FOCUS | txtInpuValue.Focus | () | 포커스 이동 |  |  |  |
| AC-ecf14e0e | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3890 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ else of (pCategoryCode == "RAMP_UP") ▸ if (pCategoryCode == … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-134a4c3c | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3896 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ else of (pCategoryCode == "RAMP_UP") ▸ if (pCategoryCode == … | MESSAGE | MessageHelper.GMessageBox | ("Daily Capa 는 요일입력을 허용하지 않습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-41f690f7 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3897 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ else of (pCategoryCode == "RAMP_UP") ▸ if (pCategoryCode == … | FOCUS | txtInpuValue.Focus | () | 포커스 이동 |  |  |  |
| AC-c9e9e632 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3898 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ else of (pCategoryCode == "RAMP_UP") ▸ if (pCategoryCode == … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75dfd705 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3903 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ else of (pCategoryCode == "RAMP_UP") ▸ if (pCategoryCode == … | MESSAGE | MessageHelper.GMessageBox | ("수량을 입력하시오.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd2806df | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3904 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ else of (pCategoryCode == "RAMP_UP") ▸ if (pCategoryCode == … | FOCUS | txtInpuValue.Focus | () | 포커스 이동 |  |  |  |
| AC-c7bb5986 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3905 | else of (pCategoryCode == "NO_WORK") ▸ else of (pCategoryCode == "LOAD_RATE") ▸ else of (pCategoryCode == "RAMP_UP") ▸ if (pCategoryCode == … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d3bb7dd | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3914 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d4167ceb | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3927 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2745b0c7 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3943 | if (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) | CALL_EXT | spdMain.ActiveSheet.GetModelColumnFromViewColumn | (row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-118220d5 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3944 | if (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) | CALL_EXT | spdMain.ActiveSheet.GetModelColumnFromViewColumn | (col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d022c36 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3949 | if (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ if (row >= 0 && col < 0) ▸ f… | CALL_EXT | (siMain.ActiveSheet.GetValue(i, nCateIdx)).ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-58dfd754 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3956 | if (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ if (row >= 0 && col < 0) ▸ f… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-81fdb154 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3966 | if (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && col < 0… | CALL_EXT | (siMain.ActiveSheet.GetValue(i, nCateIdx)).ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3330400f | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3973 | if (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && col < 0… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-d2097605 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3983 | if (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && col < 0… | CALL_EXT | (siMain.ActiveSheet.GetValue(i, nCateIdx)).ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd66537f | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:3990 | if (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && col < 0… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-70378e62 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4005 | if (pCategoryCode == "DAILY_CAPA") ▸ else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) | CALL_EXT | (siMain.ActiveSheet.GetValue(i, nCateIdx)).ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a98a7737 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4014 | if (pCategoryCode == "DAILY_CAPA") ▸ else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ if (sCateTmp == pCate… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-a315dbb1 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4035 | else of (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) | CALL_EXT | spdMain.ActiveSheet.GetModelColumnFromViewColumn | (row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-da162ef4 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4036 | else of (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) | CALL_EXT | spdMain.ActiveSheet.GetModelColumnFromViewColumn | (col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8fdbb93c | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4041 | else of (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ if (row >= 0 && col < 0… | CALL_EXT | (siMain.ActiveSheet.GetValue(i, nCateIdx)).ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b97dab6 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4048 | else of (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ if (row >= 0 && col < 0… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-4cdc8998 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4058 | else of (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && co… | CALL_EXT | (siMain.ActiveSheet.GetValue(i, nCateIdx)).ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ab3b6d59 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4065 | else of (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && co… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-5fceb28d | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4075 | else of (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && co… | CALL_EXT | (siMain.ActiveSheet.GetValue(i, nCateIdx)).ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f616f849 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4082 | else of (pCategoryCode == "DAILY_CAPA") ▸ if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && co… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-20bb0e02 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4097 | else of (pCategoryCode == "DAILY_CAPA") ▸ else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) | CALL_EXT | (siMain.ActiveSheet.GetValue(i, nCateIdx)).ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8c2d620 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4106 | else of (pCategoryCode == "DAILY_CAPA") ▸ else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ if (sCateTmp == … | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-8a7f3564 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4114 | else of (pCategoryCode == "DAILY_CAPA") ▸ else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ if (sCateTmp == … | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-7d6c5434 | this.btnInput.Click | SCP0098_CAPAReprotSmall.cs:4127 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0098_CAPAReprotSmall.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d892999 | this.btnItemId.Click | SCP0098_CAPAReprotSmall.cs:3394 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1799f586 | this.btnItemId.Click | SCP0098_CAPAReprotSmall.cs:3401 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-382b2526 | this.btnItemId.Click | SCP0098_CAPAReprotSmall.cs:3403 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d1fec520 | this.btnItemId.Click | SCP0098_CAPAReprotSmall.cs:3404 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e914d251 | this.btnItemId.Click | SCP0098_CAPAReprotSmall.cs:3405 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-23ba86e3 | this.btnItemId.Click | SCP0098_CAPAReprotSmall.cs:3411 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0098_CAPAReprotSmall.BtnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c8019f3 | this.btnMeasure.Click | SCP0098_CAPAReprotSmall.cs:3426 | if (fps != null) ▸ else of (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f9626e0c | this.btnMeasure.Click | SCP0098_CAPAReprotSmall.cs:3427 | if (fps != null) ▸ else of (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e495e54 | this.btnMeasure.Click | SCP0098_CAPAReprotSmall.cs:3432 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c2a580d | this.btnMeasure.Click | SCP0098_CAPAReprotSmall.cs:3433 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6cc5884 | this.btnMeasure.Click | SCP0098_CAPAReprotSmall.cs:3436 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0098", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-eb27da5c | this.btnMeasure.Click | SCP0098_CAPAReprotSmall.cs:3437 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3321efa0 | this.btnMeasure.Click | SCP0098_CAPAReprotSmall.cs:3438 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c488035f | this.btnMeasure.Click | SCP0098_CAPAReprotSmall.cs:3442 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-315329bc | this.btnMeasure.Click | SCP0098_CAPAReprotSmall.cs:3447 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0098_CAPAReprotSmall.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-437ee84f | this.cboBucketType.SelectedIndexChanged | SCP0098_CAPAReprotSmall.cs:3388 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0098_CAPAReprotSmall.CheckValidationSave

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a331f1b | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0098_CAPAReprotSmall.cs:2486 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0098_CAPAReprotSmall.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdc612a8 | this.Load | SCP0098_CAPAReprotSmall.cs:247 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9344de42 | this.Load | SCP0098_CAPAReprotSmall.cs:248 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb6c2afa | this.Load | SCP0098_CAPAReprotSmall.cs:250 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0098_CAPAReprotSmall.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfabbbe7 | this.Load | SCP0098_CAPAReprotSmall.cs:215 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0098_CAPAReprotSmall.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae82edd6 | Dispose | SCP0098_CAPAReprotSmall.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0098_CAPAReprotSmall.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-831a8dca | EditButton | SCP0098_CAPAReprotSmall.cs:420 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ded8ae83 | EditButton | SCP0098_CAPAReprotSmall.cs:421 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0f6fb3ce | EditButton | SCP0098_CAPAReprotSmall.cs:424 | try ▸ if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-258f5d8c | EditButton | SCP0098_CAPAReprotSmall.cs:428 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-513d0fa6 | EditButton | SCP0098_CAPAReprotSmall.cs:429 | try ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-319596f9 | EditButton | SCP0098_CAPAReprotSmall.cs:430 | try ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-d10da8c8 | EditButton | SCP0098_CAPAReprotSmall.cs:435 | try ▸ if (fps.Name == "spdMain") ▸ if (IsEditMode == false) | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, i_ColCount, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b7301fe7 | EditButton | SCP0098_CAPAReprotSmall.cs:436 | try ▸ if (fps.Name == "spdMain") ▸ if (IsEditMode == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45593004 | EditButton | SCP0098_CAPAReprotSmall.cs:463 | try ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, i_MEASURE_NAME, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-256bdc8d | EditButton | SCP0098_CAPAReprotSmall.cs:464 | try ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockRange | (0, i_PRODUCT_READY, siMain.ActiveSheet.RowCount - 1, i_PRODUCT_READY, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-35a10085 | EditButton | SCP0098_CAPAReprotSmall.cs:468 | try ▸ if (fps.Name == "spdMain") | UI_MISC | SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-745c84ac | EditButton | SCP0098_CAPAReprotSmall.cs:477 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (measure) case "DAILY_CAPA": | GRID_LOCK | siMain.LockRange2 | (i, i_MEASURE_NAME_NEXT, i, i_MEASURE_NAME_NEXT, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-45ea5155 | EditButton | SCP0098_CAPAReprotSmall.cs:478 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (measure) case "DAILY_CAPA": | GRID_LOCK | siMain.LockRange2 | (i, i_OEE_NEXT, i, i_ColCount, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-e533dad8 | EditButton | SCP0098_CAPAReprotSmall.cs:485 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (measure) case "DAILY_CAPA": ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange2 | (i, iCol, i, iCol, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-9d7f44f4 | EditButton | SCP0098_CAPAReprotSmall.cs:492 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (measure) case "NO_WORK": case "LOAD_RATE": case "RAMP_UP": | GRID_LOCK | siMain.LockRange | (i, i_MEASURE_NAME_NEXT, i, i_MEASURE_NAME_NEXT, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b76690b4 | EditButton | SCP0098_CAPAReprotSmall.cs:499 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (measure) case "NO_WORK": case "LOAD_RATE": case "RAMP_UP": ▸… | GRID_LOCK | siMain.LockRange2 | (i, iCol, i, iCol, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-4c26ac97 | EditButton | SCP0098_CAPAReprotSmall.cs:503 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (measure) case "NO_WORK": case "LOAD_RATE": case "RAMP_UP": ▸… | GRID_LOCK | siMain.LockRange2 | (i, iCol, i, iCol, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-1f83f555 | EditButton | SCP0098_CAPAReprotSmall.cs:515 | try ▸ if (fps.Name == "spdMain") | UI_MISC | ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e9c5abf3 | EditButton | SCP0098_CAPAReprotSmall.cs:522 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0098_CAPAReprotSmall.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7facf5c0 | ExcelButton | SCP0098_CAPAReprotSmall.cs:546 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-5131a077 | ExcelButton | SCP0098_CAPAReprotSmall.cs:547 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-aceb24bb | ExcelButton | SCP0098_CAPAReprotSmall.cs:549 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7eda523b | ExcelButton | SCP0098_CAPAReprotSmall.cs:553 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-aa550abf | ExcelButton | SCP0098_CAPAReprotSmall.cs:554 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-a08f4fdd | ExcelButton | SCP0098_CAPAReprotSmall.cs:555 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-af7b6cc9 | ExcelButton | SCP0098_CAPAReprotSmall.cs:558 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-db3302f1 | ExcelButton | SCP0098_CAPAReprotSmall.cs:559 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-e52adbc1 | ExcelButton | SCP0098_CAPAReprotSmall.cs:560 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-fea8114a | ExcelButton | SCP0098_CAPAReprotSmall.cs:562 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-b3204a7c | ExcelButton | SCP0098_CAPAReprotSmall.cs:563 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-ebb776e4 | ExcelButton | SCP0098_CAPAReprotSmall.cs:570 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e9df3b2 | ExcelButton | SCP0098_CAPAReprotSmall.cs:574 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-bff52128 | ExcelButton | SCP0098_CAPAReprotSmall.cs:578 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0098_CAPAReprotSmall.FinColIndexdOEE

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12531b6d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:3303 |  | RETURN | return index; |  | 처리 중단/반환 |  |  |  |

## SCP0098_CAPAReprotSmall.FindData_Main

진입점: this.btnCopyData.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / FindButton / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ finally ▸ if (isSuccess)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d69cf880 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:638 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-719fe836 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:645 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-4d746bc9 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:645 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f32c8ea | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:649 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7c6a8ecf | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:676 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-32ff243c | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:699 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCM_MASTER… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-16fa3d11 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:702 | try ▸ lambda | ENDPOINT | new FoxDataRequest | (CallSP) ⇒ SCP.SCP0098_GET_CAPA_MobilityIT | 엔드포인트 요청 생성 |  |  |  |
| AC-ceeff1c0 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:703 | try ▸ lambda | UI_PROP | req.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7f46c2c0 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:704 | try ▸ lambda | DATA_OP | req.Parameters["p_today_yyyymmdd"] | p_today_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f2d3bd4c | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:705 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0672459c | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:706 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e77e3a3e | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:707 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ec64bb74 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:708 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_site | 행/컬럼 값 대입 |  |  |  |
| AC-cb917f81 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:709 | try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-89de4fca | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:710 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-a92d9865 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:711 | try ▸ lambda | DATA_OP | req.Parameters["p_model_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-305f77a6 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:712 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-78d67de4 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:713 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-fc4ed89b | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:714 | try ▸ lambda | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-5bca2824 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:715 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-7d1577b6 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:716 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-f2b92659 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:717 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4f7e120d | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:718 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8ac14eef | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:742 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-86b57c16 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:745 | try | GRID_LOCK | siMain.LockColumn | (0, RowCount, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb0c1a65 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:746 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c5de034c | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:747 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-734c3bc2 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:754 | try ▸ if (RowCount > 0) | UI_MISC | SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-eefe1906 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:756 | try ▸ if (RowCount > 0) | UI_MISC | ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1bde4630 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:757 | try ▸ if (RowCount > 0) | FLAG | dtOriginal | null | 화면 필드/플래그 변경 |  |  |  |
| AC-218305cd | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:758 | try ▸ if (RowCount > 0) | FLAG | dtOriginal | dsBinding.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-406bb6fe | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:758 | try ▸ if (RowCount > 0) | DATA_OP | dsBinding.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d7a66cf3 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:766 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-5a67054c | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:767 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4fb24048 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:770 | try | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-340dc360 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:775 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-96c6007d | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:782 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0098_CAPAReprotSmall.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da2414a0 | this.Load | SCP0098_CAPAReprotSmall.cs:168 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-eaf94dc3 | this.Load | SCP0098_CAPAReprotSmall.cs:178 |  | FLAG | dtSpdTitle | GetSpdTitle2("SCP0098", UserInfo.UserId, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-c6a4b2bf | this.Load | SCP0098_CAPAReprotSmall.cs:182 |  | VALUE_SET | cboDivision.ControlValues | defaultDivision | 컨트롤 값 설정 |  |  |  |
| AC-ef1d53a5 | this.Load | SCP0098_CAPAReprotSmall.cs:183 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-16a4fae7 | this.Load | SCP0098_CAPAReprotSmall.cs:186 |  | DATA_OP | dtCategoryList.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a88fe12 | this.Load | SCP0098_CAPAReprotSmall.cs:187 |  | DATA_OP | dtCategoryList.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-937fadb1 | this.Load | SCP0098_CAPAReprotSmall.cs:188 |  | DATA_OP | dtCategoryList.Rows.Add | ("NO_WORK" , "비조업") | 데이터 객체 조작/조회 |  |  |  |
| AC-26f671a7 | this.Load | SCP0098_CAPAReprotSmall.cs:189 |  | DATA_OP | dtCategoryList.Rows.Add | ("LOAD_RATE" , "가동율(%)") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd5a8833 | this.Load | SCP0098_CAPAReprotSmall.cs:190 |  | DATA_OP | dtCategoryList.Rows.Add | ("RAMP_UP" , "Ramp-up(0.0~1.0)") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea364e18 | this.Load | SCP0098_CAPAReprotSmall.cs:191 |  | DATA_OP | dtCategoryList.Rows.Add | ("DAILY_CAPA", "Daily Capa") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a54eaa6 | this.Load | SCP0098_CAPAReprotSmall.cs:192 |  | LIST_REBIND | clsCtrl.setListBox | (dtCategoryList, cboCategory, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-16120f90 | this.Load | SCP0098_CAPAReprotSmall.cs:194 |  | DATA_OP | dtDayType.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee61b54d | this.Load | SCP0098_CAPAReprotSmall.cs:195 |  | DATA_OP | dtDayType.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-f91ddb9e | this.Load | SCP0098_CAPAReprotSmall.cs:196 |  | DATA_OP | dtDayType.Rows.Add | ("EveryDay" , "EveryDay") | 데이터 객체 조작/조회 |  |  |  |
| AC-a7e2ea4b | this.Load | SCP0098_CAPAReprotSmall.cs:197 |  | DATA_OP | dtDayType.Rows.Add | ("SelectDay" , "SelectDay") | 데이터 객체 조작/조회 |  |  |  |
| AC-61a85f8d | this.Load | SCP0098_CAPAReprotSmall.cs:198 |  | DATA_OP | dtDayType.Rows.Add | ("Mon" , "Mon") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a4ef5d6 | this.Load | SCP0098_CAPAReprotSmall.cs:199 |  | DATA_OP | dtDayType.Rows.Add | ("Tue" , "Tue") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8090b01 | this.Load | SCP0098_CAPAReprotSmall.cs:200 |  | DATA_OP | dtDayType.Rows.Add | ("Wed" , "Wed") | 데이터 객체 조작/조회 |  |  |  |
| AC-78992c47 | this.Load | SCP0098_CAPAReprotSmall.cs:201 |  | DATA_OP | dtDayType.Rows.Add | ("Thu" , "Thu") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ecc514e | this.Load | SCP0098_CAPAReprotSmall.cs:202 |  | DATA_OP | dtDayType.Rows.Add | ("Fri" , "Fri") | 데이터 객체 조작/조회 |  |  |  |
| AC-29f9d15e | this.Load | SCP0098_CAPAReprotSmall.cs:203 |  | DATA_OP | dtDayType.Rows.Add | ("Sat" , "Sat") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f802868 | this.Load | SCP0098_CAPAReprotSmall.cs:204 |  | DATA_OP | dtDayType.Rows.Add | ("Sun" , "Sun") | 데이터 객체 조작/조회 |  |  |  |
| AC-d12bdc72 | this.Load | SCP0098_CAPAReprotSmall.cs:205 |  | LIST_REBIND | clsCtrl.setListBox | (dtDayType, cboDayWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0098_CAPAReprotSmall.GetDayOfWeek

진입점: this.btnInput.Click [else of (pCategoryCode == "DAILY_CAPA") ▸ else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ if (sCateTmp == pCategoryName) ▸ for (j < siMain.ActiveSheet.Columns.Count) ▸ if (siMain.ActiveSheet.Columns[j].Tag.ToString().IndexOf("D_") == 0) ▸ else of (pDayWeekCode == "EveryDay")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c1a568f | this.btnInput.Click [else of (pCategoryCode == "DAILY_CAPA")… | SCP0098_CAPAReprotSmall.cs:4134 |  | DATA_OP | dt.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-24a227ee | this.btnInput.Click [else of (pCategoryCode == "DAILY_CAPA")… | SCP0098_CAPAReprotSmall.cs:4134 | lambda | DATA_OP | row.Field | ("COLUMN_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-5786d572 | this.btnInput.Click [else of (pCategoryCode == "DAILY_CAPA")… | SCP0098_CAPAReprotSmall.cs:4136 |  | RETURN | return returnDay; |  | 처리 중단/반환 |  |  |  |

## SCP0098_CAPAReprotSmall.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b7f566d | this.Load | SCP0098_CAPAReprotSmall.cs:3095 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-ad6a0f72 | this.Load | SCP0098_CAPAReprotSmall.cs:3096 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-05eb3cdf | this.Load | SCP0098_CAPAReprotSmall.cs:3097 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-44d037b4 | this.Load | SCP0098_CAPAReprotSmall.cs:3098 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-2e472209 | this.Load | SCP0098_CAPAReprotSmall.cs:3099 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a9bd7b8b | this.Load | SCP0098_CAPAReprotSmall.cs:3104 |  | DATA_OP | sDayRange.Contains | (":") | 데이터 객체 조작/조회 |  |  |  |
| AC-9bd71e5f | this.Load | SCP0098_CAPAReprotSmall.cs:3138 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0098_CAPAReprotSmall.GetLastRange

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5523a3b6 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:3075 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-513e5331 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:3076 |  | DATA_OP | request.Parameters["p_division_id"] | divisionId | 행/컬럼 값 대입 |  |  |  |
| AC-ef3f0143 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:3077 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a86595eb | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:3079 |  | RETURN | return dailyPlanPeriod; |  | 처리 중단/반환 |  |  |  |

## SCP0098_CAPAReprotSmall.GetLastWeek

진입점: this.btnCopyData.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.Load / this.cboBucketType.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ finally ▸ if (isSuccess) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9be9d739 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3175 | if (CommonUtils.CheckDataEmpty(dtSpdTitle)) | RETURN | return Week; |  | 처리 중단/반환 |  |  |  |
| AC-d782e64e | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3184 |  | RETURN | return Week; |  | 처리 중단/반환 |  |  |  |

## SCP0098_CAPAReprotSmall.GetLastYYYYMM

진입점: this.btnCopyData.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.Load / this.cboBucketType.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ finally ▸ if (isSuccess) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90637f03 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3157 | if (CommonUtils.CheckDataEmpty(dtSpdTitle)) | RETURN | return YYYYMM; |  | 처리 중단/반환 |  |  |  |
| AC-cffb1afb | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3166 |  | RETURN | return YYYYMM; |  | 처리 중단/반환 |  |  |  |

## SCP0098_CAPAReprotSmall.GetNextDayColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec9eb97f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:3321 | if (ColumnNameNext.StartsWith("D_") == false) ▸ if (loop > 12) | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-6e92be12 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:3326 |  | RETURN | return colIndex; |  | 처리 중단/반환 |  |  |  |

## SCP0098_CAPAReprotSmall.GetNowMonth

진입점: this.btnCopyData.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.Load / this.cboBucketType.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ finally ▸ if (isSuccess) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3261128d | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3147 |  | RETURN | return dCalendar.Text1.Replace("-", "").Substring(4, 2); |  | 처리 중단/반환 |  |  |  |

## SCP0098_CAPAReprotSmall.GetSpdTitle

진입점: this.btnCopyData.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.Load / this.cboBucketType.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ finally ▸ if (isSuccess) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4145bdc9 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3040 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-45430c8f | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3045 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | dCalendar.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-d067c7b0 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3046 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | dCalendar.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-0f159de3 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3048 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-af21b377 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3048 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0098_CAPAReprotSmall.GetSpdTitle2

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19acc168 | this.Load | SCP0098_CAPAReprotSmall.cs:3363 | try | ENDPOINT | new FoxDataRequest | ("SCM.SCM_SYS_GET_SPREAD_TITLE") ⇒ SCM.SCM_SYS_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-b93ada22 | this.Load | SCP0098_CAPAReprotSmall.cs:3364 | try | DATA_OP | request.Parameters["p_program_id"] | programID | 행/컬럼 값 대입 |  |  |  |
| AC-0ce626c3 | this.Load | SCP0098_CAPAReprotSmall.cs:3365 | try | DATA_OP | request.Parameters["p_user_id"] | userID | 행/컬럼 값 대입 |  |  |  |
| AC-5faa5a30 | this.Load | SCP0098_CAPAReprotSmall.cs:3366 | try | DATA_OP | request.Parameters["p_sheet_name"] | sheetName | 행/컬럼 값 대입 |  |  |  |
| AC-1e2ec29a | this.Load | SCP0098_CAPAReprotSmall.cs:3368 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d898912d | this.Load | SCP0098_CAPAReprotSmall.cs:3378 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0098_CAPAReprotSmall.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32b913d5 | this.Load | SCP0098_CAPAReprotSmall.cs:223 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-8fb0d736 | this.Load | SCP0098_CAPAReprotSmall.cs:226 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-dcf4d7c4 | this.Load | SCP0098_CAPAReprotSmall.cs:230 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-032a459f | this.Load | SCP0098_CAPAReprotSmall.cs:234 |  | FLAG | dtBucketType | CommonUtils.GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-5a69aa0b | this.Load | SCP0098_CAPAReprotSmall.cs:234 |  | CALL_EXT | CommonUtils.GetBucketType | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4199567 | this.Load | SCP0098_CAPAReprotSmall.cs:235 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-135c78e1 | this.Load | SCP0098_CAPAReprotSmall.cs:238 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0098_CAPAReprotSmall.InitSpread

진입점: this.btnCopyData.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.Load / this.cboBucketType.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ finally ▸ if (isSuccess) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4fdc4b9 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:259 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4c1097c3 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:260 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0098_CAPAReprotSmall.InitSpreadDateColumn

진입점: this.btnCopyData.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.Load / this.cboBucketType.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ finally ▸ if (isSuccess) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f46dbd6 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:336 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 75, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e645bfe | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:340 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-2b8126e2 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:348 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d4e26fe | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:349 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, prHeaderString, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9aa11f7 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:355 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-82304d02 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:356 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, prHeaderString, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9406ca1a | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:364 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d174c66c | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:365 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-440f5688 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:378 | if (sLargeLabelName.Equals(sLargeSpanName_last)) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f5dff4ff | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:379 | if (sLargeLabelName.Equals(sLargeSpanName_last)) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, prHeaderString, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c36c48a1 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:383 | if (sSmallLabelName.Equals(sSmallSpanName_last)) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0098_CAPAReprotSmall.isCellValueChange

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) && row_MEASURE_UI.Equals("NO_WORK"))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c01ebab8 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0098_CAPAReprotSmall.cs:2424 | if (CommonUtils.CheckDataEmpty(dtOriginal) == false) | DATA_OP | dtOriginal.Select | (condition) | 데이터 객체 조작/조회 |  |  |  |
| AC-d402785c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0098_CAPAReprotSmall.cs:2439 |  | RETURN | return checkChange; |  | 처리 중단/반환 |  |  |  |

## SCP0098_CAPAReprotSmall.isCellValueChangeItem

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (colName.StartsWith("M_"))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee9ddd40 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0098_CAPAReprotSmall.cs:2453 | if (CommonUtils.CheckDataEmpty(dtOriginal) == false) | DATA_OP | dtOriginal.Select | (condition) | 데이터 객체 조작/조회 |  |  |  |
| AC-2393dcc4 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0098_CAPAReprotSmall.cs:2468 |  | RETURN | return checkChange; |  | 처리 중단/반환 |  |  |  |

## SCP0098_CAPAReprotSmall.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d66df6d | SaveButton | SCP0098_CAPAReprotSmall.cs:529 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ffac0ea3 | SaveButton | SCP0098_CAPAReprotSmall.cs:531 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d50ef4c | SaveButton | SCP0098_CAPAReprotSmall.cs:536 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (save_status == "RUN") | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4112a64c | SaveButton | SCP0098_CAPAReprotSmall.cs:537 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (save_status == "RUN") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0098_CAPAReprotSmall.SaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ee7b355 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2497 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c1cf9cdb | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2500 | try ▸ if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0998ed94 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2502 | try ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-64b66946 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2504 | try ▸ if (siMain.SheetName != SpdSheet.shtMain) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4bf39154 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2506 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-23892130 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2508 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-666c13e9 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2511 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3ee9d511 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2516 | try | FLAG | iCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-3b80f92e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2517 | try | FLAG | iCount_CAPA | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-efbb9906 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2518 | try | FLAG | iCount_CAPA_WORK | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-2145aeb2 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2519 | try | FLAG | iCount_PROD | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-ac254a31 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2554 | try ▸ if (checkResult == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1369d934 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2567 | try ▸ for (i <= siMain.GetMaxRowIndex()) | UI_PROP | capa_prod.row_index | i | 속성 row_index 설정 |  |  |  |
| AC-547f0cd0 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2573 | try ▸ for (i <= siMain.GetMaxRowIndex()) | FLAG | iCount | iCount++ | 화면 필드 증감 |  |  |  |
| AC-53648a87 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2600 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) && row_MEASURE_UI.Equals("NO_WORK")) | FLAG | iCount_PROD | iCount_PROD++ | 화면 필드 증감 |  |  |  |
| AC-295e62b6 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2609 | try ▸ for (i <= siMain.GetMaxRowIndex()) | UI_PROP | capa_prod.row_index | i | 속성 row_index 설정 |  |  |  |
| AC-85fbc5c1 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2615 | try ▸ for (i <= siMain.GetMaxRowIndex()) | FLAG | iCount | iCount++ | 화면 필드 증감 |  |  |  |
| AC-6ca7cf78 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2653 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) ▸ for… | FLAG | iCount_CAPA | iCount_CAPA++ | 화면 필드 증감 |  |  |  |
| AC-391c2c56 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2701 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) && row_MEASURE_UI.Equals("DAILY_CAPA") == false) ▸ for… | FLAG | iCount_CAPA_WORK | iCount_CAPA_WORK++ | 화면 필드 증감 |  |  |  |
| AC-10bf7d3d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2705 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) && row_MEASURE_UI.Equals("DAILY_CAPA") == false) ▸ for… | MESSAGE | MessageHelper.GMessageBox | ("10000 건 이상의 데이터를 저장 할 수 없습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e93c9605 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2736 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d3d2a105 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2737 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb4c2838 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2744 | finally ▸ if (iCount_PROD + iCount_CAPA + iCount_CAPA_WORK > 0) | CALL_EXT | siMain.SwitchLockEx | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd4f596e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2745 | finally ▸ if (iCount_PROD + iCount_CAPA + iCount_CAPA_WORK > 0) | MESSAGE | MessageHelper.GMessageBox | ("처리 완료되었습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c760767 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2750 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-748b16d6 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2751 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0098_CAPAReprotSmall.SaveData_CAPA

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c755bf4 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2764 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0098_SAVE_SCP_CAPA") ⇒ SCP.SCP0098_SAVE_SCP_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-652c1c43 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2767 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCM_MASTER_SVC)) { req.Command… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-de879f6c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2771 | try ▸ lambda | UI_PROP | req.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6a02720b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2772 | try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | capa.action_flag | 행/컬럼 값 대입 |  |  |  |
| AC-207a5a80 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2773 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | capa.DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-46cf26fd | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2774 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | capa.PLANT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-49dd79f1 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2775 | try ▸ lambda | DATA_OP | req.Parameters["p_factory_id"] | capa.FACTORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-22356d6b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2776 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | capa.OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-28c086c3 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2777 | try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | capa.LINE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-09c1fb3f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2778 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | capa.ITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-13e51685 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2779 | try ▸ lambda | DATA_OP | req.Parameters["p_yyyymm"] | capa.YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-64158f16 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2780 | try ▸ lambda | DATA_OP | req.Parameters["p_value"] | capa.VALUE | 행/컬럼 값 대입 |  |  |  |
| AC-be99ae2b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2781 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1397ca30 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2783 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a2862aee | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2783 | try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-520889e0 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2806 | try ▸ if (tran.Success) ▸ else of (tranResult == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9e42f98e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2813 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## SCP0098_CAPAReprotSmall.SaveData_CAPA_PRODUCT_RATE

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e498038 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2832 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE") ⇒ SCP.SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE | 엔드포인트 요청 생성 |  |  |  |
| AC-a76b3756 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2835 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCM_MASTER_SVC)) { req.Command… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-85907581 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2839 | try ▸ lambda | UI_PROP | req.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ee2d8496 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2841 | try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | capa_work.action_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e0dadacb | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2842 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | capa_work.DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-8775c656 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2843 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | capa_work.PLANT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-8c578c03 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2844 | try ▸ lambda | DATA_OP | req.Parameters["p_factory_id"] | capa_work.FACTORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-44ebbfda | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2845 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | capa_work.OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-bed3ae6f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2846 | try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | capa_work.LINE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-fcd9f24d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2847 | try ▸ lambda | DATA_OP | req.Parameters["p_start_yyyymmdd"] | dCalendar.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-b6b45314 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2848 | try ▸ lambda | DATA_OP | req.Parameters["p_end_yyyymmdd"] | dCalendar.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-2286b04d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2849 | try ▸ lambda | DATA_OP | req.Parameters["p_product_rate"] | capa_work.PROD_READY_RATE | 행/컬럼 값 대입 |  |  |  |
| AC-a5ba04b0 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2850 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-14a63f1c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2852 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e724da78 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2852 | try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-5e28e7dd | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2875 | try ▸ if (tran.Success) ▸ else of (tranResult == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f60fad3 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2880 | try ▸ else of (tran.Success) | MESSAGE | MessageHelper.GMessageBox | (tran.ErrorInfo.MessageDetail) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-12614445 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2886 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## SCP0098_CAPAReprotSmall.SaveData_CAPA_PRODUCT_RATE_OLD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbbf2d8c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2900 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE") ⇒ SCP.SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE | 엔드포인트 요청 생성 |  |  |  |
| AC-da0a9e21 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2903 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCM_MASTER_SVC)) { req.Command… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-52ece9c5 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2907 | try ▸ lambda | UI_PROP | req.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0235e055 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2909 | try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | capa_work.action_flag | 행/컬럼 값 대입 |  |  |  |
| AC-78b3f05d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2910 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | capa_work.DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-a9d956e4 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2911 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | capa_work.PLANT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-bffe41b8 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2912 | try ▸ lambda | DATA_OP | req.Parameters["p_factory_id"] | capa_work.FACTORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-3ddf93da | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2913 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | capa_work.OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-4c25ff35 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2914 | try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | capa_work.LINE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-39a0c8a6 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2915 | try ▸ lambda | DATA_OP | req.Parameters["p_yyyymmdd"] | capa_work.YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-654db36f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2916 | try ▸ lambda | DATA_OP | req.Parameters["p_product_rate"] | capa_work.PROD_READY_RATE | 행/컬럼 값 대입 |  |  |  |
| AC-fcc2138d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2917 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e92abe06 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2919 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c1aa9e8c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2919 | try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-2c93078f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2942 | try ▸ if (tran.Success) ▸ else of (tranResult == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cadf6b82 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2947 | try ▸ else of (tran.Success) | MESSAGE | MessageHelper.GMessageBox | (tran.ErrorInfo.MessageDetail) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a260616 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2953 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## SCP0098_CAPAReprotSmall.SaveData_CAPA_WORK

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d99baed | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2969 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0098_SAVE_SCP_CAPA_WORK") ⇒ SCP.SCP0098_SAVE_SCP_CAPA_WORK | 엔드포인트 요청 생성 |  |  |  |
| AC-5179ca67 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2972 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCM_MASTER_SVC)) { req.Command… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-051a47d1 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2976 | try ▸ lambda | UI_PROP | req.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bc402ca9 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2978 | try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | capa_work.action_flag | 행/컬럼 값 대입 |  |  |  |
| AC-531b9f3b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2979 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | capa_work.DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-882bd35e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2980 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | capa_work.PLANT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-d1eabe32 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2981 | try ▸ lambda | DATA_OP | req.Parameters["p_factory_id"] | capa_work.FACTORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-c8c96c7e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2982 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | capa_work.OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-ace0d32f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2983 | try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | capa_work.LINE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-951335aa | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2984 | try ▸ lambda | DATA_OP | req.Parameters["p_measure"] | capa_work.MEASURE | 행/컬럼 값 대입 |  |  |  |
| AC-d6176a78 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2985 | try ▸ lambda | DATA_OP | req.Parameters["p_yyyymmdd"] | capa_work.YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-1829f127 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2986 | try ▸ lambda | DATA_OP | req.Parameters["p_value"] | capa_work.VALUE | 행/컬럼 값 대입 |  |  |  |
| AC-599c1476 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2987 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7853a193 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2989 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-594daa8f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:2989 | try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-efcdcee4 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:3010 | try ▸ if (tran.Success) ▸ else of (tranResult == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-37341c59 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:3015 | try ▸ else of (tran.Success) | MESSAGE | MessageHelper.GMessageBox | (tran.ErrorInfo.MessageDetail) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d08221e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:3021 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## SCP0098_CAPAReprotSmall.SaveDataFull

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c5924ed | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1904 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-31b246a0 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1907 | try ▸ if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7d9ffed | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1909 | try ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3eb1bc14 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1911 | try ▸ if (siMain.SheetName != SpdSheet.shtMain) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29125873 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1913 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-7ac3404d | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1915 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfa75f72 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1918 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b6a04fce | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1923 | try | FLAG | iCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-cf14b7d4 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1924 | try | FLAG | iCount_CAPA | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-1a32e6a6 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1925 | try | FLAG | iCount_CAPA_WORK | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-33b81e98 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1926 | try | FLAG | iCount_PROD | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-140694e7 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1962 | try ▸ if (checkResult == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05d9c1e9 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1975 | try ▸ for (i <= siMain.GetMaxRowIndex()) | UI_PROP | capa_prod.row_index | i | 속성 row_index 설정 |  |  |  |
| AC-c39a27e8 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:1981 | try ▸ for (i <= siMain.GetMaxRowIndex()) | FLAG | iCount | iCount++ | 화면 필드 증감 |  |  |  |
| AC-f116bfd8 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2000 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CommonUtils.CheckDataEmpty(row_PROD_READY_RATE)) | MESSAGE | MessageHelper.GMessageBox | (string.Format("[ {0} ] 생산준비율 값이 없습니다.", row_LINE_ID)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-915435e6 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2002 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CommonUtils.CheckDataEmpty(row_PROD_READY_RATE)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a63ec2b | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2004 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (CommonUtils.CheckDataEmpty(row_PROD_READY_RATE)) | CALL_EXT | CommonUtils.IsNumeric | (row_PROD_READY_RATE) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9179391a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2006 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (CommonUtils.CheckDataEmpty(row_PROD_READY_RATE)) ▸ if (CommonUtils.IsNumeric(row_PROD_RE… | MESSAGE | MessageHelper.GMessageBox | (string.Format("[ {0} ] 생산준비율 값에 숫자(양수)를 입력해 주세요.", row_LINE_ID)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47a89ca2 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2008 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (CommonUtils.CheckDataEmpty(row_PROD_READY_RATE)) ▸ if (CommonUtils.IsNumeric(row_PROD_RE… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-950ae94b | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2010 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (CommonUtils.CheckDataEmpty(row_PROD_READY_RATE)) ▸ else of (CommonUtils.IsNumeric(row_PR… | CALL_EXT | CommonUtils.CheckNumberRange | (row_PROD_READY_RATE, 0, 100) | ⚠ 의미 확인 필요 |  |  |  |
| AC-92882efd | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2012 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (CommonUtils.CheckDataEmpty(row_PROD_READY_RATE)) ▸ else of (CommonUtils.IsNumeric(row_PR… | MESSAGE | MessageHelper.GMessageBox | (string.Format("[ {0} ] 생산준비율 값 허용 범위 오류 (0 ~ 100).", row_LINE_ID)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd2cc0b3 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2014 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (CommonUtils.CheckDataEmpty(row_PROD_READY_RATE)) ▸ else of (CommonUtils.IsNumeric(row_PR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2b7508c8 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2032 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) && row_MEASURE_UI.Equals("NO_WORK")) | FLAG | iCount_PROD | iCount_PROD++ | 화면 필드 증감 |  |  |  |
| AC-c8c97e49 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2041 | try ▸ for (i <= siMain.GetMaxRowIndex()) | UI_PROP | capa_prod.row_index | i | 속성 row_index 설정 |  |  |  |
| AC-3d2bc114 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2047 | try ▸ for (i <= siMain.GetMaxRowIndex()) | FLAG | iCount | iCount++ | 화면 필드 증감 |  |  |  |
| AC-bef1fc1f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2074 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) ▸ for… | CALL_EXT | CommonUtils.IsNumeric | (col_VALUE) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d41466c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2076 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) ▸ for… | MESSAGE | MessageHelper.GMessageBox | (string.Format("[ {0} {1} {2} ]\r\n값에 숫자(양수)를 입력해 주세요.", row_LINE_ID, row_ITEM_ID, col_YYY… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9154019c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2078 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) ▸ for… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9dd3fbf | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2080 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) ▸ for… | CALL_EXT | CommonUtils.CheckNumberRange | (col_VALUE, 0, 1000000) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1d82e0db | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2082 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) ▸ for… | MESSAGE | MessageHelper.GMessageBox | (string.Format("[ {0} {1} {2} ]\r\n값 허용 범위 오류 (0 ~ 1000000).", row_LINE_ID, row_ITEM_ID, c… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3abc561 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2084 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) ▸ for… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20622ca5 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2094 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) ▸ for… | MESSAGE | MessageHelper.GMessageBox | (string.Format("[ {0} {1} {2} ]\r\n값이 없습니다.", row_LINE_ID, row_ITEM_ID, col_YYYYMM)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-42d650dc | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2096 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) ▸ for… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4631f8c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2109 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) ▸ for… | FLAG | iCount_CAPA | iCount_CAPA++ | 화면 필드 증감 |  |  |  |
| AC-96ff0162 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2144 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | MESSAGE | MessageHelper.GMessageBox | (string.Format("[ {0} {1} ] Load Rate 값이 없습니다.", row_LINE_ID, col_YYYYMMDD)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-08a6da42 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2146 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09d5ddcd | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2148 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | CALL_EXT | CommonUtils.IsNumeric | (col_VALUE) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eaee2add | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2150 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | MESSAGE | MessageHelper.GMessageBox | (string.Format("[ {0} {1} ]\r\nLoad Rate 값에 숫자(양수)를 입력해 주세요.", row_LINE_ID, col_YYYYMMDD)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3c90ca1 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2152 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-362b6497 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2154 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | CALL_EXT | CommonUtils.CheckNumberRange | (col_VALUE, 0, 100) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0781525 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2156 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | MESSAGE | MessageHelper.GMessageBox | (string.Format("[ {0} {1} ] Load Rate 값 허용 범위 오류 (0 ~ 100).", row_LINE_ID, col_YYYYMMDD)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6140e019 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2158 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0670ba9 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2165 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | MESSAGE | MessageHelper.GMessageBox | (string.Format("[ {0} {1} ] Ramp UP 값이 없습니다.", row_LINE_ID, col_YYYYMMDD)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c0706d4c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2167 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e209da9 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2169 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | CALL_EXT | CommonUtils.IsNumeric | (col_VALUE) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf148af0 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2171 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | MESSAGE | MessageHelper.GMessageBox | (string.Format("[ {0} {1} ]\r\nRamp UP 값에 숫자(양수)를 입력해 주세요.", row_LINE_ID, col_YYYYMMDD)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-52c22e82 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2173 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cab0c602 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2175 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | CALL_EXT | CommonUtils.CheckNumberRange | (col_VALUE, 0, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-127a4906 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2177 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | MESSAGE | MessageHelper.GMessageBox | (string.Format("[ {0} {1} ] Ramp UP 값 허용 범위 오류 (0 ~ 1).", row_LINE_ID, col_YYYYMMDD)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-57315e25 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2179 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b510c87a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2197 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | FLAG | iCount_CAPA_WORK | iCount_CAPA_WORK++ | 화면 필드 증감 |  |  |  |
| AC-91c0cb46 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2201 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_ITEM_ID) == false && row_MEASURE_UI.Equals("DAILY_CAPA")) … | MESSAGE | MessageHelper.GMessageBox | ("10000 건 이상의 데이터를 저장 할 수 없습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8cb0d69f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2219 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE") ⇒ SCP.SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE | 엔드포인트 요청 생성 |  |  |  |
| AC-704f268e | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2221 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCM_MASTER_SVC)) { req1.Comman… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-763408fe | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2225 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try ▸ lambda | UI_PROP | req1.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9ff0b623 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2227 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try ▸ lambda | DATA_OP | req1.Parameters["p_active_flag"] | capa_prod.action_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b911c66c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2228 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try ▸ lambda | DATA_OP | req1.Parameters["p_division_id"] | capa_prod.DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-2922a8f3 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2229 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try ▸ lambda | DATA_OP | req1.Parameters["p_plant_id"] | capa_prod.PLANT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-b6c9ebca | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2230 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try ▸ lambda | DATA_OP | req1.Parameters["p_factory_id"] | capa_prod.FACTORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-cb2fa687 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2231 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try ▸ lambda | DATA_OP | req1.Parameters["p_operation_id"] | capa_prod.OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-b49d77d5 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2232 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try ▸ lambda | DATA_OP | req1.Parameters["p_line_id"] | capa_prod.LINE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-3293846b | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2233 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try ▸ lambda | DATA_OP | req1.Parameters["p_start_yyyymmdd"] | dCalendar.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-784839a3 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2234 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try ▸ lambda | DATA_OP | req1.Parameters["p_end_yyyymmdd"] | dCalendar.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-bd79a752 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2235 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try ▸ lambda | DATA_OP | req1.Parameters["p_product_rate"] | capa_prod.PROD_READY_RATE | 행/컬럼 값 대입 |  |  |  |
| AC-56e475e1 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2236 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try ▸ lambda | DATA_OP | req1.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7319b2f4 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2238 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req1) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-733c42f2 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2238 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req1); |  | 처리 중단/반환 |  |  |  |
| AC-7cf49a8b | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2264 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ if (isSuccess == false) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3a2ee6eb | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2265 | try ▸ if (isSuccess && iCount_PROD > 0) ▸ if (isSuccess == false) | MESSAGE | MessageHelper.GMessageBox | ("[생산준비율] 저장에 실패하였습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a0af61cd | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2275 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0098_SAVE_SCP_CAPA") ⇒ SCP.SCP0098_SAVE_SCP_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-baf3c32a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2278 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCM_MASTER_SVC)) { req2.Comman… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4e328854 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2282 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try ▸ lambda | UI_PROP | req2.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f49f1a57 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2283 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try ▸ lambda | DATA_OP | req2.Parameters["p_active_flag"] | capa.action_flag | 행/컬럼 값 대입 |  |  |  |
| AC-09704015 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2284 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try ▸ lambda | DATA_OP | req2.Parameters["p_division_id"] | capa.DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-7bf6005b | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2285 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try ▸ lambda | DATA_OP | req2.Parameters["p_plant_id"] | capa.PLANT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f36443c7 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2286 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try ▸ lambda | DATA_OP | req2.Parameters["p_factory_id"] | capa.FACTORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-8457d636 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2287 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try ▸ lambda | DATA_OP | req2.Parameters["p_operation_id"] | capa.OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-4decf4a6 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2288 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try ▸ lambda | DATA_OP | req2.Parameters["p_line_id"] | capa.LINE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-bb572201 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2289 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try ▸ lambda | DATA_OP | req2.Parameters["p_item_id"] | capa.ITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-175b6e6c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2290 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try ▸ lambda | DATA_OP | req2.Parameters["p_yyyymm"] | capa.YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-0d11bd01 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2291 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try ▸ lambda | DATA_OP | req2.Parameters["p_value"] | capa.VALUE | 행/컬럼 값 대입 |  |  |  |
| AC-4a677a7f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2292 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try ▸ lambda | DATA_OP | req2.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bbb1694d | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2294 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req2) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-445888b6 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2294 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req2); |  | 처리 중단/반환 |  |  |  |
| AC-782f8e2b | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2321 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ if (isSuccess == false) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b5e8be46 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2322 | try ▸ if (isSuccess && iCount_CAPA > 0) ▸ if (isSuccess == false) | MESSAGE | MessageHelper.GMessageBox | ("[Capa/일] 저장에 실패하였습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00c70d52 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2332 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0098_SAVE_SCP_CAPA_WORK") ⇒ SCP.SCP0098_SAVE_SCP_CAPA_WORK | 엔드포인트 요청 생성 |  |  |  |
| AC-5319460d | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2335 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCM_MASTER_SVC)) { req3.Comman… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f268c1c0 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2339 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try ▸ lambda | UI_PROP | req3.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7980b022 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2341 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try ▸ lambda | DATA_OP | req3.Parameters["p_active_flag"] | capa_work.action_flag | 행/컬럼 값 대입 |  |  |  |
| AC-80a92838 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2342 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try ▸ lambda | DATA_OP | req3.Parameters["p_division_id"] | capa_work.DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-ca6022f2 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2343 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try ▸ lambda | DATA_OP | req3.Parameters["p_plant_id"] | capa_work.PLANT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-fd0173f0 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2344 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try ▸ lambda | DATA_OP | req3.Parameters["p_factory_id"] | capa_work.FACTORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f5c6c87c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2345 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try ▸ lambda | DATA_OP | req3.Parameters["p_operation_id"] | capa_work.OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-4f568934 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2346 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try ▸ lambda | DATA_OP | req3.Parameters["p_line_id"] | capa_work.LINE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-090f1442 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2347 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try ▸ lambda | DATA_OP | req3.Parameters["p_measure"] | capa_work.MEASURE | 행/컬럼 값 대입 |  |  |  |
| AC-d0dd3b6f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2348 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try ▸ lambda | DATA_OP | req3.Parameters["p_yyyymmdd"] | capa_work.YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-224c9168 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2349 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try ▸ lambda | DATA_OP | req3.Parameters["p_value"] | capa_work.VALUE | 행/컬럼 값 대입 |  |  |  |
| AC-1121d1c4 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2350 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try ▸ lambda | DATA_OP | req3.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2ab5561a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2352 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req3) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4e460ac2 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2352 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req3); |  | 처리 중단/반환 |  |  |  |
| AC-d1e06f9b | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2378 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ if (isSuccess == false) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8412836b | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2379 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ if (isSuccess == false) | MESSAGE | MessageHelper.GMessageBox | ("[Capa Work] 저장에 실패하였습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6a304b0e | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2380 | try ▸ if (isSuccess && iCount_CAPA_WORK > 0) ▸ if (isSuccess == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-362f1585 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2387 | try ▸ if (iCount_PROD + iCount_CAPA + iCount_CAPA_WORK == 0) | MESSAGE | MessageHelper.GMessageBox | ("저장 할 데이터가 없습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7e13a9e4 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2389 | try ▸ if (iCount_PROD + iCount_CAPA + iCount_CAPA_WORK == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-08f4ed86 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2394 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8b96ff4a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2395 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c6284a7 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2399 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4d02b4b0 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2405 | finally ▸ if (isSuccess) | CALL_EXT | siMain.SwitchLockEx | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-76232bf2 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2406 | finally ▸ if (isSuccess) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-95ba9072 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0098_CAPAReprotSmall.cs:2407 | finally ▸ if (isSuccess) | MESSAGE | MessageHelper.GMessageBox | ("처리 완료 하였습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0098_CAPAReprotSmall.SCM_SYS_LOG_BATCH

진입점: this.btnCopyData.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception ex))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c16349c | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… | SCP0098_CAPAReprotSmall.cs:3336 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-841f1520 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… | SCP0098_CAPAReprotSmall.cs:3337 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-64439605 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… | SCP0098_CAPAReprotSmall.cs:3338 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-70bce347 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… | SCP0098_CAPAReprotSmall.cs:3339 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-584e9a88 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… | SCP0098_CAPAReprotSmall.cs:3340 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-9c9cb73b | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… | SCP0098_CAPAReprotSmall.cs:3341 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-c6e95db5 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… | SCP0098_CAPAReprotSmall.cs:3342 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-51922a23 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… | SCP0098_CAPAReprotSmall.cs:3344 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0098_CAPAReprotSmall.SetCellFormat

진입점: this.btnCopyData.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (RowCount > 0)] / FindButton [try ▸ if (RowCount > 0)] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ finally ▸ if (isSuccess) ▸ try ▸ if (RowCount > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6ea80c5 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:789 |  | FLAG | iCellValue | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-9fcaf95e | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:790 |  | FLAG | iStartCol | 15 | 화면 필드/플래그 변경 |  |  |  |
| AC-32950714 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:791 |  | FLAG | iCol_OEE | Col_OEE | 화면 필드/플래그 변경 |  |  |  |
| AC-f707fc32 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:792 |  | FLAG | iCol_NO_WORK | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-d9ce7758 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:793 |  | FLAG | iCol_NO_WORK_CALC | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-c45eac53 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:794 |  | FLAG | iCol_LOAD_RATE | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-2e2b8af0 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:795 |  | FLAG | iCol_RAMP_UP | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-9bedb878 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:796 |  | FLAG | iCol_MEASURE_UI | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-479c0e92 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:797 |  | FLAG | iCol_LINE_ID | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-3553d77e | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:798 |  | FLAG | iCol_PRODUCT_READY | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-10d423f4 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:799 |  | FLAG | iRow_NoWork | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-1a873b4f | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:800 |  | FLAG | iRow_LoadRate | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-ecb018d4 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:801 |  | FLAG | iRow_RampUp | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-f402e8c7 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:802 |  | FLAG | iNext | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-49703a51 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:803 |  | FLAG | isNoWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b7a78195 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:804 |  | FLAG | drow_OEE | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-86d454aa | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:805 |  | FLAG | drow_NoWork | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-0954d999 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:806 |  | FLAG | drow_NoWorkCalc | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-39eff00c | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:807 |  | FLAG | drow_LoadRate | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-d3e7455d | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:808 |  | FLAG | drow_RampUp | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-bd0ec756 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:809 |  | FLAG | dCellValue | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-ba698a11 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:810 |  | FLAG | drow_prodReady | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b86b51f0 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:811 |  | FLAG | RowCount | siMain.GetMaxRowIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-4e12dba8 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:812 |  | FLAG | ColCount | siMain.ActiveSheet.ColumnCount | 화면 필드/플래그 변경 |  |  |  |
| AC-ea14ab86 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:815 | if (RowCount < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1e07e4c | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:819 |  | UI_PROP | numCell.DecimalPlaces | 0 | 속성 DecimalPlaces 설정 |  |  |  |
| AC-6b473569 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:820 |  | UI_PROP | numCell.Separator | "," | 속성 Separator 설정 |  |  |  |
| AC-73f057c5 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:821 |  | UI_PROP | numCell.ShowSeparator | true | 속성 ShowSeparator 설정 |  |  |  |
| AC-edbfa1b7 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:825 |  | FLAG | iCol_NO_WORK | siMain.GetColumnIndex("NO_WORK") | 화면 필드/플래그 변경 |  |  |  |
| AC-102d006e | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:826 |  | FLAG | iCol_NO_WORK_CALC | siMain.GetColumnIndex("NO_WORK_CALC") | 화면 필드/플래그 변경 |  |  |  |
| AC-700673d7 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:827 |  | FLAG | iCol_LOAD_RATE | siMain.GetColumnIndex("LOAD_RATE") | 화면 필드/플래그 변경 |  |  |  |
| AC-7460b998 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:828 |  | FLAG | iCol_RAMP_UP | siMain.GetColumnIndex("RAMP_UP") | 화면 필드/플래그 변경 |  |  |  |
| AC-aaca65b5 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:829 |  | FLAG | iCol_MEASURE_UI | siMain.GetColumnIndex(DefColumns.MEASURE_UI) | 화면 필드/플래그 변경 |  |  |  |
| AC-fcc27872 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:830 |  | FLAG | iCol_LINE_ID | siMain.GetColumnIndex(DefColumns.LINE_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-a76e8b3d | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:831 |  | FLAG | iCol_PRODUCT_READY | siMain.GetColumnIndex(DefColumns.PRODUCT_READY) | 화면 필드/플래그 변경 |  |  |  |
| AC-7ede7c7c | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:837 | for (i <= RowCount) ▸ for (j < ColCount) | FLAG | sMeasure | CommonUtils.GetCellValue(siMain, i, iCol_MEASURE_UI) | 화면 필드/플래그 변경 |  |  |  |
| AC-7fe3e73c | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:838 | for (i <= RowCount) ▸ for (j < ColCount) | FLAG | ColumnName | CommonUtils.GetColumnName(siMain, j) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef449319 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:838 | for (i <= RowCount) ▸ for (j < ColCount) | CALL_EXT | CommonUtils.GetColumnName | (siMain, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c554fe99 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:842 | for (i <= RowCount) ▸ for (j < ColCount) ▸ if (ColumnName.StartsWith("D_") == true) | FLAG | CellValue | CommonUtils.GetCellValue(siMain, i, j) | 화면 필드/플래그 변경 |  |  |  |
| AC-5962d5db | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:847 | for (i <= RowCount) ▸ for (j < ColCount) ▸ if (ColumnName.StartsWith("D_") == true) ▸ switch (sMeasure) case "NO_WORK": | GRID_SET | siMain.ActiveSheet.Cells[i, j].HorizontalAlignment | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-f5620199 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:848 | for (i <= RowCount) ▸ for (j < ColCount) ▸ if (ColumnName.StartsWith("D_") == true) ▸ switch (sMeasure) case "NO_WORK": | GRID_SET | siMain.ActiveSheet.Cells[i, j].ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-d01918ad | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:849 | for (i <= RowCount) ▸ for (j < ColCount) ▸ if (ColumnName.StartsWith("D_") == true) ▸ switch (sMeasure) case "NO_WORK": | GRID_SET | siMain.ActiveSheet.Cells[i, j].Value | CellValue | 그리드 속성/값 설정 |  |  |  |
| AC-1fbcc643 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:853 | for (i <= RowCount) ▸ for (j < ColCount) ▸ if (ColumnName.StartsWith("D_") == true) ▸ switch (sMeasure) case "DAILY_CAPA": | GRID_SET | siMain.ActiveSheet.Cells[i,j].CellType | numCell | 그리드 속성/값 설정 |  |  |  |
| AC-5aae7359 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:854 | for (i <= RowCount) ▸ for (j < ColCount) ▸ if (ColumnName.StartsWith("D_") == true) ▸ switch (sMeasure) case "DAILY_CAPA": | GRID_SET | siMain.ActiveSheet.Cells[i, j].Value | CellValue | 그리드 속성/값 설정 |  |  |  |
| AC-a6d14887 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:858 | for (i <= RowCount) ▸ for (j < ColCount) ▸ if (ColumnName.StartsWith("D_") == true) ▸ switch (sMeasure) default: | GRID_SET | siMain.ActiveSheet.Cells[i, j].Value | CellValue | 그리드 속성/값 설정 |  |  |  |

## SCP0098_CAPAReprotSmall.SetCellFormat_0909

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af4b38ae | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1607 |  | FLAG | ColumnNameMonth | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-60612060 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1608 |  | FLAG | ColumnName | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-07e6ece7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1609 |  | FLAG | ColumnNameNext | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-9ab3a034 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1610 |  | FLAG | sMeasure | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-dce68d24 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1611 |  | FLAG | CellValue | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-2ad479b3 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1612 |  | FLAG | sLine_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-4389ce71 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1613 |  | FLAG | sLine_id_before | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-277ce54c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1614 |  | FLAG | iCellValue | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-a3f36b9e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1615 |  | FLAG | row_OEE | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-408c117b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1616 |  | FLAG | row_NoWork | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-5a9fe39a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1617 |  | FLAG | row_NoWorkCalc | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c0913c43 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1618 |  | FLAG | row_LoadRate | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-3d95cb3f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1619 |  | FLAG | row_RampUp | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-ae41dab2 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1620 |  | FLAG | iStartCol | 15 | 화면 필드/플래그 변경 |  |  |  |
| AC-6cb64c8c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1621 |  | FLAG | iCol_OEE | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-54b1333c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1622 |  | FLAG | iCol_NO_WORK | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-213aa8b1 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1623 |  | FLAG | iCol_NO_WORK_CALC | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-70ad1a7c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1624 |  | FLAG | iCol_LOAD_RATE | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-742925d5 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1625 |  | FLAG | iCol_RAMP_UP | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-be7c3eb6 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1626 |  | FLAG | iCol_MEASURE_UI | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-8fdc6535 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1627 |  | FLAG | iCol_LINE_ID | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-2bc88bb6 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1628 |  | FLAG | iCol_PRODUCT_READY | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b7e0d36c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1629 |  | FLAG | iRow_NoWork | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-55e871a8 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1630 |  | FLAG | iRow_LoadRate | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-0226bb89 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1631 |  | FLAG | iRow_RampUp | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-70d68285 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1632 |  | FLAG | iNext | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-be48200d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1633 |  | FLAG | iCol_FOCUS | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-eb692ee2 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1634 |  | FLAG | isNoWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-03d5f38a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1635 |  | FLAG | isNoWorkValue | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-deb09744 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1636 |  | FLAG | drow_OEE | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-eef70384 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1637 |  | FLAG | drow_NoWork | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-73d12b0e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1638 |  | FLAG | drow_NoWorkCalc | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-e169528e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1639 |  | FLAG | drow_LoadRate | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b1843b44 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1640 |  | FLAG | drow_RampUp | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-3fb1738f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1641 |  | FLAG | dCellValue | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-d17c14ac | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1642 |  | FLAG | drow_prodReady | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-23a95d46 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1644 |  | FLAG | dtColCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-dcce2b5d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1645 |  | FLAG | dtRowCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-2c99566c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1653 | try | STATE_RESET | dtBindingCopy.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-294e4909 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1654 | try | FLAG | dsBindingCopy | dsBinding.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-0a02b37d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1654 | try | DATA_OP | dsBinding.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bc6a938e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1655 | try | FLAG | dtBindingCopy | dsBinding.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-9a120285 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1655 | try | DATA_OP | dsBinding.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5444f471 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1658 | try ▸ if (CommonUtils.CheckDataEmpty(dsBindingCopy)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-845e289e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1664 | try | FLAG | iCol_MEASURE_UI | dtBindingCopy.Columns[DefColumns.MEASURE_UI].Ordinal | 화면 필드/플래그 변경 |  |  |  |
| AC-9cbecad7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1665 | try | FLAG | iCol_LINE_ID | dtBindingCopy.Columns[DefColumns.LINE_ID].Ordinal | 화면 필드/플래그 변경 |  |  |  |
| AC-03640d96 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1666 | try | FLAG | iCol_PRODUCT_READY | dtBindingCopy.Columns[DefColumns.PRODUCT_READY].Ordinal | 화면 필드/플래그 변경 |  |  |  |
| AC-ea4e6877 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1668 | try | FLAG | dtColCount | dtBindingCopy.Columns.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-f18fc689 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1669 | try | FLAG | dtRowCount | dtBindingCopy.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-417fc3ff | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1673 | try ▸ for (iCol < dtColCount) | FLAG | ColumnName | dtBindingCopy.Columns[iCol].ColumnName | 화면 필드/플래그 변경 |  |  |  |
| AC-c6bc2c2d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1678 | try ▸ for (iCol < dtColCount) ▸ if (iCol_OEE == 0) ▸ if (ColumnName.IndexOf("M_") == 0 \|\| ColumnName.IndexOf("D_") == 0) | FLAG | Col_OEE | iCol | 화면 필드/플래그 변경 |  |  |  |
| AC-ff84b2d7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1679 | try ▸ for (iCol < dtColCount) ▸ if (iCol_OEE == 0) ▸ if (ColumnName.IndexOf("M_") == 0 \|\| ColumnName.IndexOf("D_") == 0) | FLAG | iCol_OEE | iCol | 화면 필드/플래그 변경 |  |  |  |
| AC-a37f57f9 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1685 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("M_") == 0) | DATA_OP | listOEE.Add | (ColumnName, iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-84c1a82f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1693 | try ▸ for (iCol < dtColCount) | FLAG | isNoWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cc54cd9f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1694 | try ▸ for (iCol < dtColCount) | FLAG | ColumnName | dtBindingCopy.Columns[iCol].ColumnName | 화면 필드/플래그 변경 |  |  |  |
| AC-eb6897fa | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1702 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | CellValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-612007d7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1703 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | sMeasure | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol_MEASURE_UI]) | 화면 필드/플래그 변경 |  |  |  |
| AC-47a29fcd | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1704 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | sLine_id | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol_LINE_ID]) | 화면 필드/플래그 변경 |  |  |  |
| AC-546228b4 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1708 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | isNoWorkValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-f55fd783 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1709 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | sLine_id_before | sLine_id | 화면 필드/플래그 변경 |  |  |  |
| AC-5e59cc38 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1710 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | iRow_NoWork | iRow | 화면 필드/플래그 변경 |  |  |  |
| AC-36425aaf | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1711 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | iRow_LoadRate | iRow + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-2823203a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1712 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | iRow_RampUp | iRow + 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-b4c52c86 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1718 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | GRID_SET | dtBindingCopy.Rows[iRow][iCol] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-d2a2261a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1722 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_LoadRate | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_LoadRate][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-515f2c20 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1722 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_LoadRate][iCol]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9ceead8 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1723 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_RampUp | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_RampUp][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-ba2639f9 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1723 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_RampUp][iCol]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b093cf7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1727 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_LoadRate | drow_LoadRate / 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-63eb4306 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1730 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | ColumnNameMonth | ColumnName.Replace("D_", "M_").Substring(0, 8) | 화면 필드/플래그 변경 |  |  |  |
| AC-a04a93f2 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1731 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | iCol_OEE | FinColIndexdOEE(listOEE, ColumnNameMonth) | 화면 필드/플래그 변경 |  |  |  |
| AC-68de76cd | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1732 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_OEE | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow][iCol_OEE]) | 화면 필드/플래그 변경 |  |  |  |
| AC-aa453289 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1732 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow][iCol_OEE]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-66241c5b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1733 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | drow_OEE * drow_LoadRate * drow_RampUp | 화면 필드/플래그 변경 |  |  |  |
| AC-df56416f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1734 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | Math.Round(dCellValue, 3) | 화면 필드/플래그 변경 |  |  |  |
| AC-11fe2064 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1735 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | GRID_SET | dtBindingCopy.Rows[iRow][iCol] | dCellValue | 그리드 속성/값 설정 |  |  |  |
| AC-018fc51a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1751 | try | FLAG | iCol_FOCUS | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-f12222e0 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1755 | try ▸ for (iCol < dtColCount) | FLAG | iCol_FOCUS | iCol | 화면 필드/플래그 변경 |  |  |  |
| AC-0ce9e5a8 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1756 | try ▸ for (iCol < dtColCount) | FLAG | isNoWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-51e669f5 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1757 | try ▸ for (iCol < dtColCount) | FLAG | ColumnName | dtBindingCopy.Columns[iCol].ColumnName | 화면 필드/플래그 변경 |  |  |  |
| AC-756e4cbf | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1766 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | sMeasure | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol_MEASURE_UI]) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f92cd69 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1767 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | sLine_id | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol_LINE_ID]) | 화면 필드/플래그 변경 |  |  |  |
| AC-9c70a311 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1770 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | CellValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd4518b7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1773 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | isNoWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c89b7f7d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1774 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | iRow_NoWork | iRow | 화면 필드/플래그 변경 |  |  |  |
| AC-1dca4382 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1775 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | iRow_LoadRate | iRow + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-03e4c730 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1776 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | iRow_RampUp | iRow + 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-2ad2319a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1778 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | sLine_id_before | sLine_id | 화면 필드/플래그 변경 |  |  |  |
| AC-fc59276e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1791 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | iNext | GetNextDayColumn(iCol_FOCUS, 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-b2141716 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1792 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | ColumnNameNext | siMain.GetColumnTag(iNext) | 화면 필드/플래그 변경 |  |  |  |
| AC-fcaf3802 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1793 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | isNoWorkValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow_NoWork][iNext]) | 화면 필드/플래그 변경 |  |  |  |
| AC-2519d128 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1798 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | ColumnNameMonth | ColumnName.Replace("D_", "M_").Substring(0, 8) | 화면 필드/플래그 변경 |  |  |  |
| AC-f5d15508 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1799 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | iCol_OEE | FinColIndexdOEE(listOEE, ColumnNameMonth) | 화면 필드/플래그 변경 |  |  |  |
| AC-d7836187 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1800 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_OEE | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow][iCol_OEE]) | 화면 필드/플래그 변경 |  |  |  |
| AC-cb625ac7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1800 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow][iCol_OEE]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a5f9d018 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1801 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_LoadRate | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_LoadRate][iNext]) | 화면 필드/플래그 변경 |  |  |  |
| AC-7df4c42b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1801 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_LoadRate][iNext]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e88297e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1802 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_RampUp | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_RampUp][iNext]) | 화면 필드/플래그 변경 |  |  |  |
| AC-74ae20c7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1802 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_RampUp][iNext]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-62dfa083 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1803 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_prodReady | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_RampUp][iCol_PRODUCT_READY]) | 화면 필드/플래그 변경 |  |  |  |
| AC-37524959 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1803 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_RampUp][iCol_PRODUCT_READY]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6a5aa02 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1807 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_LoadRate | drow_LoadRate / 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-a1135ef2 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1811 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_prodReady | drow_prodReady / 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-197ddf3f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1814 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | CellValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][Col_OEE]) | 화면 필드/플래그 변경 |  |  |  |
| AC-e4fd6402 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1815 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | CommonUtils.GetValueDouble(CellValue) | 화면 필드/플래그 변경 |  |  |  |
| AC-7d60d908 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1815 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (CellValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-abcd5ec5 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1816 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | drow_OEE * drow_LoadRate * drow_RampUp * drow_prodReady | 화면 필드/플래그 변경 |  |  |  |
| AC-b4af2fc5 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1817 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | Math.Round(dCellValue, 3) | 화면 필드/플래그 변경 |  |  |  |
| AC-1b62ac5e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1819 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | GRID_SET | dtBindingCopy.Rows[iRow][iNext] | CommonUtils.GetValue(dCellValue) | 그리드 속성/값 설정 |  |  |  |
| AC-06587c09 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1836 |  | DATA_OP | dsBinding.Tables.RemoveAt | (0) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ce3bb19 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1837 |  | DATA_OP | dsBinding.Tables.Add | (dtBindingCopy) | 데이터 객체 조작/조회 |  |  |  |

## SCP0098_CAPAReprotSmall.SetCellFormat_LINE

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d9f4f09 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1343 |  | FLAG | ColumnNameMonth | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-0cd66f71 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1344 |  | FLAG | ColumnName | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-1fd36dd3 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1345 |  | FLAG | ColumnNameNext | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-0281eafe | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1346 |  | FLAG | sMeasure | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-56ed6322 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1347 |  | FLAG | CellValue | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c41935e8 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1348 |  | FLAG | sLine_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-399cc20e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1349 |  | FLAG | sLine_id_before | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-8667a29a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1350 |  | FLAG | iCellValue | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-27521265 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1351 |  | FLAG | row_OEE | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-e6b62af6 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1352 |  | FLAG | row_NoWork | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-04c1b149 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1353 |  | FLAG | row_NoWorkCalc | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-e5b5707c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1354 |  | FLAG | row_LoadRate | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-83a64d71 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1355 |  | FLAG | row_RampUp | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-79692db4 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1356 |  | FLAG | iStartCol | 15 | 화면 필드/플래그 변경 |  |  |  |
| AC-9928c126 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1357 |  | FLAG | iCol_OEE | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-7d09fd6a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1358 |  | FLAG | iCol_NO_WORK | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b0c11bfa | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1359 |  | FLAG | iCol_NO_WORK_CALC | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-31d5e084 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1360 |  | FLAG | iCol_LOAD_RATE | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-fd890f9b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1361 |  | FLAG | iCol_RAMP_UP | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-9be250eb | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1362 |  | FLAG | iCol_MEASURE_UI | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-dd69b471 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1363 |  | FLAG | iCol_LINE_ID | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-8e0e49a5 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1364 |  | FLAG | iCol_PRODUCT_READY | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-81ac8b49 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1365 |  | FLAG | iRow_NoWork | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-2f47e016 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1366 |  | FLAG | iRow_LoadRate | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-6c58d3d1 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1367 |  | FLAG | iRow_RampUp | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-a657a62c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1368 |  | FLAG | iNext | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-781d035e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1369 |  | FLAG | iCol_FOCUS | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-2a6ea6cb | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1370 |  | FLAG | isNoWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9a953604 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1371 |  | FLAG | isNoWorkValue | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-fa67c8a7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1372 |  | FLAG | drow_OEE | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-26c8c412 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1373 |  | FLAG | drow_NoWork | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-a429973a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1374 |  | FLAG | drow_NoWorkCalc | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b9f51be0 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1375 |  | FLAG | drow_LoadRate | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-4973486d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1376 |  | FLAG | drow_RampUp | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-280cb566 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1377 |  | FLAG | dCellValue | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b2e9bbc0 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1378 |  | FLAG | drow_prodReady | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-ab5668c0 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1380 |  | FLAG | dtColCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-a08d736e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1381 |  | FLAG | dtRowCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-ea0d3f41 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1389 | try | STATE_RESET | dtBindingCopy.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ee747a7d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1390 | try | FLAG | dsBindingCopy | dsBinding.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-e0f608c7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1390 | try | DATA_OP | dsBinding.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4a01fc3c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1391 | try | FLAG | dtBindingCopy | dsBinding.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c43c0210 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1391 | try | DATA_OP | dsBinding.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-be609c5d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1394 | try ▸ if (CommonUtils.CheckDataEmpty(dsBindingCopy)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-28dcc0ee | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1400 | try | FLAG | iCol_MEASURE_UI | dtBindingCopy.Columns[DefColumns.MEASURE_UI].Ordinal | 화면 필드/플래그 변경 |  |  |  |
| AC-9734000b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1401 | try | FLAG | iCol_LINE_ID | dtBindingCopy.Columns[DefColumns.LINE_ID].Ordinal | 화면 필드/플래그 변경 |  |  |  |
| AC-a6e04e9d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1402 | try | FLAG | iCol_PRODUCT_READY | dtBindingCopy.Columns[DefColumns.PRODUCT_READY].Ordinal | 화면 필드/플래그 변경 |  |  |  |
| AC-e3dba9cc | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1404 | try | FLAG | dtColCount | dtBindingCopy.Columns.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-3b899dfa | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1405 | try | FLAG | dtRowCount | dtBindingCopy.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-e4851b6d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1408 | try | FLAG | iStartCol | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-96b21f99 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1411 | try ▸ for (iCol < dtColCount) | FLAG | ColumnName | dtBindingCopy.Columns[iCol].ColumnName | 화면 필드/플래그 변경 |  |  |  |
| AC-fb222cbd | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1416 | try ▸ for (iCol < dtColCount) ▸ if (iCol_OEE == 0) ▸ if (ColumnName.IndexOf("M_") == 0 \|\| ColumnName.IndexOf("D_") == 0) | FLAG | Col_OEE | iCol | 화면 필드/플래그 변경 |  |  |  |
| AC-d5c644bf | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1417 | try ▸ for (iCol < dtColCount) ▸ if (iCol_OEE == 0) ▸ if (ColumnName.IndexOf("M_") == 0 \|\| ColumnName.IndexOf("D_") == 0) | FLAG | iCol_OEE | iCol | 화면 필드/플래그 변경 |  |  |  |
| AC-2945e740 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1424 | try ▸ for (iCol < dtColCount) ▸ if (iStartCol == 0) ▸ if (ColumnName.IndexOf("D_") == 0) | FLAG | iStartCol | iCol | 화면 필드/플래그 변경 |  |  |  |
| AC-87a41a95 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1430 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("M_") == 0) | DATA_OP | listOEE.Add | (ColumnName, iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e514cc4 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1440 | try ▸ for (iCol < dtColCount) | FLAG | isNoWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a3cdb243 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1441 | try ▸ for (iCol < dtColCount) | FLAG | ColumnName | dtBindingCopy.Columns[iCol].ColumnName | 화면 필드/플래그 변경 |  |  |  |
| AC-af92e1b5 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1449 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | CellValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-37777de7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1450 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | sMeasure | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol_MEASURE_UI]) | 화면 필드/플래그 변경 |  |  |  |
| AC-4db3bff3 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1451 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | sLine_id | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol_LINE_ID]) | 화면 필드/플래그 변경 |  |  |  |
| AC-68486ee2 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1455 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | isNoWorkValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-33748b41 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1456 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | sLine_id_before | sLine_id | 화면 필드/플래그 변경 |  |  |  |
| AC-40d1823b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1457 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | iRow_NoWork | iRow | 화면 필드/플래그 변경 |  |  |  |
| AC-95c83fba | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1458 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | iRow_LoadRate | iRow + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-49efcd67 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1459 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | iRow_RampUp | iRow + 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-73b0a700 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1465 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | GRID_SET | dtBindingCopy.Rows[iRow][iCol] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-6701914d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1469 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | ColumnNameMonth | ColumnName.Replace("D_", "M_").Substring(0, 8) | 화면 필드/플래그 변경 |  |  |  |
| AC-4ad5ffcd | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1470 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | iCol_OEE | FinColIndexdOEE(listOEE, ColumnNameMonth) | 화면 필드/플래그 변경 |  |  |  |
| AC-763c1cd3 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1471 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_OEE | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow][iCol_OEE]) | 화면 필드/플래그 변경 |  |  |  |
| AC-52d95a1a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1471 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow][iCol_OEE]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0577e82e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1473 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_LoadRate | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_LoadRate][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-9e51c625 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1473 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_LoadRate][iCol]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-64d2a766 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1474 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_RampUp | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_RampUp][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-2599c411 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1474 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_RampUp][iCol]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-faa783c9 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1478 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | GRID_SET | dtBindingCopy.Rows[iRow][iCol] | CommonUtils.GetValue(drow_OEE) | 그리드 속성/값 설정 |  |  |  |
| AC-c3e6632e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1484 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_LoadRate | drow_LoadRate / 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-fbee3aaa | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1487 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | drow_OEE * drow_LoadRate * drow_RampUp | 화면 필드/플래그 변경 |  |  |  |
| AC-65cb09d4 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1488 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | Math.Round(dCellValue, 2) | 화면 필드/플래그 변경 |  |  |  |
| AC-b8434668 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1489 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | GRID_SET | dtBindingCopy.Rows[iRow][iCol] | CommonUtils.GetValue(dCellValue) | 그리드 속성/값 설정 |  |  |  |
| AC-e0dcc628 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1506 | try | FLAG | iCol_FOCUS | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-6ea87bf7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1510 | try ▸ for (iCol < dtColCount) | FLAG | iCol_FOCUS | iCol | 화면 필드/플래그 변경 |  |  |  |
| AC-adc98b19 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1511 | try ▸ for (iCol < dtColCount) | FLAG | isNoWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d00a6ab0 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1512 | try ▸ for (iCol < dtColCount) | FLAG | ColumnName | dtBindingCopy.Columns[iCol].ColumnName | 화면 필드/플래그 변경 |  |  |  |
| AC-ef092e0e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1521 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | sMeasure | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol_MEASURE_UI]) | 화면 필드/플래그 변경 |  |  |  |
| AC-66a77c7c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1522 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | sLine_id | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol_LINE_ID]) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f7a6bab | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1525 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | CellValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-05f34a24 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1528 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | isNoWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-29e60243 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1529 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | iRow_NoWork | iRow | 화면 필드/플래그 변경 |  |  |  |
| AC-3a6ab2c1 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1530 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | iRow_LoadRate | iRow + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-b9ab0d5f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1531 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | iRow_RampUp | iRow + 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-1e9b359e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1533 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | sLine_id_before | sLine_id | 화면 필드/플래그 변경 |  |  |  |
| AC-cf354edc | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1546 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | iNext | GetNextDayColumn(iCol_FOCUS, 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-46a9212a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1547 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | ColumnNameNext | siMain.GetColumnTag(iNext) | 화면 필드/플래그 변경 |  |  |  |
| AC-3cf2475b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1548 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | isNoWorkValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow_NoWork][iNext]) | 화면 필드/플래그 변경 |  |  |  |
| AC-0415bd3a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1553 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | ColumnNameMonth | ColumnName.Replace("D_", "M_").Substring(0, 8) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef914b6c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1554 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | iCol_OEE | FinColIndexdOEE(listOEE, ColumnNameMonth) | 화면 필드/플래그 변경 |  |  |  |
| AC-b3e3155a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1555 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_OEE | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow][iCol_OEE]) | 화면 필드/플래그 변경 |  |  |  |
| AC-a85a2760 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1555 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow][iCol_OEE]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aad7a448 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1556 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_LoadRate | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_LoadRate][iNext]) | 화면 필드/플래그 변경 |  |  |  |
| AC-6678a6b9 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1556 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_LoadRate][iNext]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b5e25e5 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1557 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_RampUp | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_RampUp][iNext]) | 화면 필드/플래그 변경 |  |  |  |
| AC-efab53dc | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1557 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_RampUp][iNext]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5eeda26 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1561 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | GRID_SET | dtBindingCopy.Rows[iRow][iCol] | CommonUtils.GetValue(drow_OEE) | 그리드 속성/값 설정 |  |  |  |
| AC-51cf0f97 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1565 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_prodReady | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_RampUp][iCol_PRODUCT_READY]) | 화면 필드/플래그 변경 |  |  |  |
| AC-613838cb | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1565 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_RampUp][iCol_PRODUCT_READY]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff6e0e6a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1569 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_LoadRate | drow_LoadRate / 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-66697982 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1573 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_prodReady | drow_prodReady / 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-1b0d6b0d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1576 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | CellValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][Col_OEE]) | 화면 필드/플래그 변경 |  |  |  |
| AC-338b5ebf | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1577 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | CommonUtils.GetValueDouble(CellValue) | 화면 필드/플래그 변경 |  |  |  |
| AC-56d1568f | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1577 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (CellValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4894fda0 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1578 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | drow_OEE * drow_LoadRate * drow_RampUp * drow_prodReady | 화면 필드/플래그 변경 |  |  |  |
| AC-58c67fd4 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1579 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | Math.Round(dCellValue, 2) | 화면 필드/플래그 변경 |  |  |  |
| AC-620e4613 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1581 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | GRID_SET | dtBindingCopy.Rows[iRow][iNext] | CommonUtils.GetValue(dCellValue) | 그리드 속성/값 설정 |  |  |  |
| AC-b7746965 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1599 |  | DATA_OP | dsBinding.Tables.RemoveAt | (0) | 데이터 객체 조작/조회 |  |  |  |
| AC-76f56cd7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1600 |  | DATA_OP | dsBinding.Tables.Add | (dtBindingCopy) | 데이터 객체 조작/조회 |  |  |  |

## SCP0098_CAPAReprotSmall.SetCellFormatNeo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-094165bf | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1096 |  | FLAG | ColumnNameMonth | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-34677ff2 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1097 |  | FLAG | ColumnName | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-dae13c8d | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1098 |  | FLAG | ColumnNameNext | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-b6395ba1 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1099 |  | FLAG | sMeasure | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-d20824a2 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1100 |  | FLAG | CellValue | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-9959c395 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1101 |  | FLAG | sLine_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-0302b5dc | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1102 |  | FLAG | sLine_id_before | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-bf196172 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1103 |  | FLAG | iCellValue | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-a16feede | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1104 |  | FLAG | row_OEE | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-db7ef0eb | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1105 |  | FLAG | row_NoWork | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-49247bc3 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1106 |  | FLAG | row_NoWorkCalc | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-17e9a6ee | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1107 |  | FLAG | row_LoadRate | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-444a7bb7 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1108 |  | FLAG | row_RampUp | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-8d68e963 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1109 |  | FLAG | iStartCol | 15 | 화면 필드/플래그 변경 |  |  |  |
| AC-88157e99 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1110 |  | FLAG | iCol_OEE | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-950f336b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1111 |  | FLAG | iCol_NO_WORK | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-a4ecc421 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1112 |  | FLAG | iCol_NO_WORK_CALC | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-bcc90b1c | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1113 |  | FLAG | iCol_LOAD_RATE | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-acb69cb9 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1114 |  | FLAG | iCol_RAMP_UP | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-a063a98b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1115 |  | FLAG | iCol_MEASURE_UI | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-22bc94ec | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1116 |  | FLAG | iCol_LINE_ID | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b45983bc | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1117 |  | FLAG | iCol_PRODUCT_READY | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-782c1520 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1118 |  | FLAG | iRow_NoWork | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-c8fe2e32 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1119 |  | FLAG | iRow_LoadRate | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-0d305519 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1120 |  | FLAG | iRow_RampUp | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-45fb3539 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1121 |  | FLAG | iNext | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-ab2379f5 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1122 |  | FLAG | iCol_FOCUS | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-6ec2d78e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1123 |  | FLAG | isNoWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8f3f697b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1124 |  | FLAG | isNoWorkValue | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-7a63e6a5 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1125 |  | FLAG | drow_OEE | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-5cfc0c38 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1126 |  | FLAG | drow_NoWork | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-0a76fd48 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1127 |  | FLAG | drow_NoWorkCalc | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-e1688352 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1128 |  | FLAG | drow_LoadRate | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-9feb94c3 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1129 |  | FLAG | drow_RampUp | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-6d3ac9d2 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1130 |  | FLAG | dCellValue | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-1ee4bf32 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1131 |  | FLAG | drow_prodReady | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b544a6b9 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1133 |  | FLAG | dtColCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-dec87312 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1134 |  | FLAG | dtRowCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-c344e976 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1142 | try | STATE_RESET | dtBindingCopy.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-0a856111 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1143 | try | FLAG | dsBindingCopy | dsBinding.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-16f009db | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1143 | try | DATA_OP | dsBinding.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-33cf5d32 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1144 | try | FLAG | dtBindingCopy | dsBinding.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-815234dc | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1144 | try | DATA_OP | dsBinding.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f305920 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1147 | try ▸ if (CommonUtils.CheckDataEmpty(dsBindingCopy)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3618fdbc | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1153 | try | FLAG | iCol_MEASURE_UI | dtBindingCopy.Columns[DefColumns.MEASURE_UI].Ordinal | 화면 필드/플래그 변경 |  |  |  |
| AC-d85a70eb | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1154 | try | FLAG | iCol_LINE_ID | dtBindingCopy.Columns[DefColumns.LINE_ID].Ordinal | 화면 필드/플래그 변경 |  |  |  |
| AC-372b83fa | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1155 | try | FLAG | iCol_PRODUCT_READY | dtBindingCopy.Columns[DefColumns.PRODUCT_READY].Ordinal | 화면 필드/플래그 변경 |  |  |  |
| AC-895decb9 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1157 | try | FLAG | dtColCount | dtBindingCopy.Columns.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-2d05c82e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1158 | try | FLAG | dtRowCount | dtBindingCopy.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-a2b93921 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1161 | try | FLAG | iStartCol | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-0d4087b3 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1164 | try ▸ for (iCol < dtColCount) | FLAG | ColumnName | dtBindingCopy.Columns[iCol].ColumnName | 화면 필드/플래그 변경 |  |  |  |
| AC-08c9f7ed | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1169 | try ▸ for (iCol < dtColCount) ▸ if (iStartCol == 0) ▸ if (ColumnName.IndexOf("D_") == 0) | FLAG | iStartCol | iCol | 화면 필드/플래그 변경 |  |  |  |
| AC-2689fb80 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1179 | try ▸ for (iCol < dtColCount) | FLAG | isNoWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-af5b779e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1180 | try ▸ for (iCol < dtColCount) | FLAG | ColumnName | dtBindingCopy.Columns[iCol].ColumnName | 화면 필드/플래그 변경 |  |  |  |
| AC-62e5fcd4 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1188 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | CellValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-2855ca27 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1189 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | sMeasure | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol_MEASURE_UI]) | 화면 필드/플래그 변경 |  |  |  |
| AC-3d1ec217 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1190 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | sLine_id | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol_LINE_ID]) | 화면 필드/플래그 변경 |  |  |  |
| AC-fb8d8e97 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1194 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | isNoWorkValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-9c326fa2 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1195 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | sLine_id_before | sLine_id | 화면 필드/플래그 변경 |  |  |  |
| AC-85e77f7b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1196 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | iRow_NoWork | iRow | 화면 필드/플래그 변경 |  |  |  |
| AC-20df4754 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1197 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | iRow_LoadRate | iRow + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-74582cb1 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1198 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | iRow_RampUp | iRow + 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-93219dd6 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1204 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | GRID_SET | dtBindingCopy.Rows[iRow][iCol] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-72f2440a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1208 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | CellValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-f323b875 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1210 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_LoadRate | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_LoadRate][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-47a0d6b0 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1210 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_LoadRate][iCol]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-15a580ec | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1211 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_RampUp | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_RampUp][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-2f4cd4e2 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1211 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_RampUp][iCol]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f321406 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1215 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | GRID_SET | dtBindingCopy.Rows[iRow][iCol] | CommonUtils.GetValue(CellValue) | 그리드 속성/값 설정 |  |  |  |
| AC-91962571 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1221 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_LoadRate | drow_LoadRate / 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-567d51c5 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1224 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | drow_OEE * drow_LoadRate * drow_RampUp | 화면 필드/플래그 변경 |  |  |  |
| AC-f13040be | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1225 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | Math.Round(dCellValue, 2) | 화면 필드/플래그 변경 |  |  |  |
| AC-d0c67277 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1226 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | GRID_SET | dtBindingCopy.Rows[iRow][iCol] | CommonUtils.GetValue(dCellValue) | 그리드 속성/값 설정 |  |  |  |
| AC-370dd2a1 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1243 | try | FLAG | iCol_FOCUS | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-2ee6df33 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1247 | try ▸ for (iCol < dtColCount) | FLAG | iCol_FOCUS | iCol | 화면 필드/플래그 변경 |  |  |  |
| AC-bcf56d48 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1248 | try ▸ for (iCol < dtColCount) | FLAG | isNoWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e4c06084 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1249 | try ▸ for (iCol < dtColCount) | FLAG | ColumnName | dtBindingCopy.Columns[iCol].ColumnName | 화면 필드/플래그 변경 |  |  |  |
| AC-12fa4f50 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1258 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | sMeasure | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol_MEASURE_UI]) | 화면 필드/플래그 변경 |  |  |  |
| AC-f757bfb5 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1259 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try | FLAG | sLine_id | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol_LINE_ID]) | 화면 필드/플래그 변경 |  |  |  |
| AC-89d6b24b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1262 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) | FLAG | CellValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-bf5503a1 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1265 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | isNoWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e86610d3 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1266 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | iRow_NoWork | iRow | 화면 필드/플래그 변경 |  |  |  |
| AC-ef934ef6 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1267 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | iRow_LoadRate | iRow + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-ade4af54 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1268 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | iRow_RampUp | iRow + 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-c3938b20 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1270 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ if (sMeasure.Equals("NO_WORK")) ▸ if (… | FLAG | sLine_id_before | sLine_id | 화면 필드/플래그 변경 |  |  |  |
| AC-1bfdf0aa | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1283 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | iNext | GetNextDayColumn(iCol_FOCUS, 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-383e0f47 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1284 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | ColumnNameNext | siMain.GetColumnTag(iNext) | 화면 필드/플래그 변경 |  |  |  |
| AC-7d96e4ec | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1285 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | isNoWorkValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow_NoWork][iNext]) | 화면 필드/플래그 변경 |  |  |  |
| AC-e0302fd4 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1290 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | CellValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][iCol]) | 화면 필드/플래그 변경 |  |  |  |
| AC-bb358dca | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1291 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_LoadRate | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_LoadRate][iNext]) | 화면 필드/플래그 변경 |  |  |  |
| AC-9ae51200 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1291 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_LoadRate][iNext]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce6c291b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1292 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_RampUp | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_RampUp][iNext]) | 화면 필드/플래그 변경 |  |  |  |
| AC-01bc2ded | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1292 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_RampUp][iNext]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-135fe75e | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1296 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | GRID_SET | dtBindingCopy.Rows[iRow][iCol] | CommonUtils.GetValue(CellValue) | 그리드 속성/값 설정 |  |  |  |
| AC-821cf9ee | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1300 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_prodReady | CommonUtils.GetValueDouble(dtBindingCopy.Rows[iRow_RampUp][iCol_PRODUCT_READY]) | 화면 필드/플래그 변경 |  |  |  |
| AC-dab9c875 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1300 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (dtBindingCopy.Rows[iRow_RampUp][iCol_PRODUCT_READY]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3071ba3 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1304 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_LoadRate | drow_LoadRate / 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-a70e05ba | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1308 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | drow_prodReady | drow_prodReady / 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-fb6ee28b | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1311 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | CellValue | CommonUtils.GetValue(dtBindingCopy.Rows[iRow][Col_OEE]) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d021835 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1312 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | CommonUtils.GetValueDouble(CellValue) | 화면 필드/플래그 변경 |  |  |  |
| AC-47d6c67a | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1312 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | CALL_EXT | CommonUtils.GetValueDouble | (CellValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f7c6a89 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1313 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | drow_OEE * drow_LoadRate * drow_RampUp * drow_prodReady | 화면 필드/플래그 변경 |  |  |  |
| AC-3147c1c4 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1314 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | FLAG | dCellValue | Math.Round(dCellValue, 3) | 화면 필드/플래그 변경 |  |  |  |
| AC-b78b7362 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1316 | try ▸ for (iCol < dtColCount) ▸ if (ColumnName.IndexOf("D_") == 0) ▸ for (iRow <= dtRowCount) ▸ try ▸ else of (sMeasure.Equals("NO_WORK")) ▸… | GRID_SET | dtBindingCopy.Rows[iRow][iNext] | CommonUtils.GetValue(dCellValue) | 그리드 속성/값 설정 |  |  |  |
| AC-b90ddad8 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1335 |  | DATA_OP | dsBinding.Tables.RemoveAt | (0) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2a27305 | (진입점 미연결) | SCP0098_CAPAReprotSmall.cs:1336 |  | DATA_OP | dsBinding.Tables.Add | (dtBindingCopy) | 데이터 객체 조작/조회 |  |  |  |

## SCP0098_CAPAReprotSmall.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-975721bb | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1864 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-424ae2a6 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1864 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-35c632bd | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1866 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-628ca2de | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1866 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1a0a5493 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1872 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-344cd9d1 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1872 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3b2ea8ce | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1874 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-5410add2 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1874 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a78254d8 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1876 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3ab0b119 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1883 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 화면 필드/플래그 변경 |  |  |  |
| AC-16dc224b | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1883 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a6b0e1e8 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1886 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-0a0f35d1 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1886 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-709665f5 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1888 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineByOperationAddOSP, false, division, "", "", "", pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-31e37247 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1888 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationAddOSP, false, division, "", "", "", pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8e7ab0d6 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1890 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtLine | Data.Common(Data.Type.LineByOperation, false, division, "", "", "", pPlantSite) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-f87070e5 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1890 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", "", "", pPlantSite) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7f236768 | this.Load 외 1 | SCP0098_CAPAReprotSmall.cs:1893 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0098_CAPAReprotSmall.SetLayout

진입점: this.btnCopyData.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (RowCount > 0)] / this.Load / this.cboBucketType.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / chkDetail.CheckedChanged / FindButton [try ▸ if (RowCount > 0)] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ finally ▸ if (isSuccess) ▸ try ▸ if (RowCount > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7f298db | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 7 | SCP0098_CAPAReprotSmall.cs:3202 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ if (colName.IndexOf("D_") == … | GRID_INIT | siMain.VisibleColumns | (iCol, isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-171096c9 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 7 | SCP0098_CAPAReprotSmall.cs:3204 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ if (colName.IndexOf("M_") == … | GRID_INIT | siMain.VisibleColumns | (iCol, !isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0098_CAPAReprotSmall.SetReTextCellType

진입점: this.btnCopyData.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (RowCount > 0) ▸ for (i <= RowCount) ▸ for (j < ColCount) ▸ if (ColumnName.StartsWith("D_") == true)] / FindButton [try ▸ if (RowCount > 0) ▸ for (i <= RowCount) ▸ for (j < ColCount) ▸ if (ColumnName.StartsWith("D_") == true)] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ finally ▸ if (isSuccess) ▸ try ▸ if (RowCount > 0) ▸ for (i <= RowCount) ▸ for (j < ColCount) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22db2d35 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:1849 | try | UI_PROP | cell.CellType | textType | 속성 CellType 설정 |  |  |  |
| AC-be9f0369 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 3 | SCP0098_CAPAReprotSmall.cs:1850 | try | UI_PROP | cell.HorizontalAlignment | CellHorizontalAlignment.Right | 속성 HorizontalAlignment 설정 |  |  |  |

## SCP0098_CAPAReprotSmall.SetSaveStatus

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1b28a16 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0098_CAPAReprotSmall.cs:3143 |  | FLAG | save_status | status | 화면 필드/플래그 변경 |  |  |  |

## SCP0098_CAPAReprotSmall.SetSpreadColumn

진입점: this.btnCopyData.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (RowCount > 0)] / this.Load / this.cboBucketType.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try ▸ if (RowCount > 0)] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ finally ▸ if (isSuccess) ▸ try ▸ if (RowCount > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d5ac735 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3234 | for (iCol <= RowCount) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ if (colName.IndexOf("D_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b02ccc15 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3235 | for (iCol <= RowCount) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ if (colName.IndexOf("D_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].CellType | textType | 그리드 속성/값 설정 |  |  |  |
| AC-7d32e2b8 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3236 | for (iCol <= RowCount) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ if (colName.IndexOf("D_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].HorizontalAlignment | CellHorizontalAlignment.Right | 그리드 속성/값 설정 |  |  |  |
| AC-6a7c7e6e | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3241 | for (iCol <= RowCount) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ else of (colName.IndexOf("D_") == 0) ▸ if (colName.In… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-91d8faf7 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3245 | for (iCol <= RowCount) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ else of (colName.IndexOf("D_") == 0) ▸ else of (colNa… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9178d4d5 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:3249 | for (iCol <= RowCount) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ else of (colName.IndexOf("D_") == 0) ▸ else of (colNa… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0098_CAPAReprotSmall.SetSpreadInit

진입점: this.btnCopyData.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.Load / this.cboBucketType.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ finally ▸ if (isSuccess) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2963297 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:267 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-cf2ade25 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:269 |  | FLAG | nIdxDataMain | spdInfo.GetMaxColumnIndex() + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-2190bbe1 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:270 |  | UI_PROP | spdInfo.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |
| AC-9dbc94c9 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:275 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e69e5b0 | this.btnCopyData.Click [if (select_popup.ShowDialog() == Dia… 외 6 | SCP0098_CAPAReprotSmall.cs:279 |  | GRID_SET | spdInfo.ActiveSheet.ColumnHeader.Columns[iColOEE].Tag | string.Format(GetNowMonth(), strOEE_Header) | 그리드 속성/값 설정 |  |  |  |

## SCP0098_CAPAReprotSmall.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e4aa4dd | this.spdMain.CellClick | SCP0098_CAPAReprotSmall.cs:3470 | if (spdMain.ActiveSheet.ActiveRowIndex > 0) | FLAG | this.nSelRowOfMain | spdMain.ActiveSheet.ActiveRowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-07098fad | this.spdMain.CellClick | SCP0098_CAPAReprotSmall.cs:3471 | if (spdMain.ActiveSheet.ActiveRowIndex > 0) | FLAG | this.nSelColOfMain | spdMain.ActiveSheet.ActiveColumnIndex | 화면 필드/플래그 변경 |  |  |  |

## SCP0098_CAPAReprotSmall.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-195661a6 | this.spdMain.CellDoubleClick | SCP0098_CAPAReprotSmall.cs:3719 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ad379c2b | this.spdMain.CellDoubleClick | SCP0098_CAPAReprotSmall.cs:3723 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-578a4d50 | this.spdMain.CellDoubleClick | SCP0098_CAPAReprotSmall.cs:3724 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0098_CAPAReprotSmall.SpdMain_Changed

진입점: dsdmLine.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-702a3100 | dsdmLine.Changed | SCP0098_CAPAReprotSmall.cs:3484 |  | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0cc3a69d | dsdmLine.Changed | SCP0098_CAPAReprotSmall.cs:3486 | if (!this.CanModelChange \|\| e.Row == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea38721f | dsdmLine.Changed | SCP0098_CAPAReprotSmall.cs:3487 | if (cellclipboardPast) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3be57ce9 | dsdmLine.Changed | SCP0098_CAPAReprotSmall.cs:3497 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f63f686f | dsdmLine.Changed | SCP0098_CAPAReprotSmall.cs:3532 | if (strColName == "Action") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-826f95da | dsdmLine.Changed | SCP0098_CAPAReprotSmall.cs:3538 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c2c2b3d5 | dsdmLine.Changed | SCP0098_CAPAReprotSmall.cs:3591 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (!cellclipboardPast) ▸ if (strColName.Equals… | GRID_SET | siMain.SetValue | (x, nCol, cellValue) | 그리드 값 설정 |  |  |  |
| AC-a6246d99 | dsdmLine.Changed | SCP0098_CAPAReprotSmall.cs:3621 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (!cellclipboardPast) ▸ else of (strColName.E… | MESSAGE | MessageHelper.GMessageBox | ("[Y,N] 만 입력 가능합니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e98a93bc | dsdmLine.Changed | SCP0098_CAPAReprotSmall.cs:3622 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (!cellclipboardPast) ▸ else of (strColName.E… | GRID_SET | siMain.SetValue | (nRow, nCol, setValue) | 그리드 값 설정 |  |  |  |
| AC-0bb562c5 | dsdmLine.Changed | SCP0098_CAPAReprotSmall.cs:3654 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-748f6568 | dsdmLine.Changed | SCP0098_CAPAReprotSmall.cs:3658 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0098_CAPAReprotSmall.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-153cb721 | this.spdMain.TopChange | SCP0098_CAPAReprotSmall.cs:3478 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0098_CopySelect_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de2ee3ed | .ctor | SCP0098_CopySelect_Popup.cs:62 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-14a2498a | .ctor | SCP0098_CopySelect_Popup.cs:63 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-879a299f | .ctor | SCP0098_CopySelect_Popup.cs:64 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-da410235 | .ctor | SCP0098_CopySelect_Popup.cs:66 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## SCP0098_CopySelect_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25f7e981 | Dispose | SCP0098_CopySelect_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0098_CopySelect_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ada632fa | this.Load | SCP0098_CopySelect_Popup.cs:93 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## SCP0098_CopySelect_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a60f9104 | this.Load | SCP0098_CopySelect_Popup.cs:77 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-31a7865d | this.Load | SCP0098_CopySelect_Popup.cs:85 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-aeb0f945 | this.Load | SCP0098_CopySelect_Popup.cs:88 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0098_CopySelect_Popup.rbOpt1_Click

진입점: rbOpt1.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80e0e1a8 | rbOpt1.CheckedChanged | SCP0098_CopySelect_Popup.cs:122 | if (loaded) | FLAG | Selection | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-004b75d2 | rbOpt1.CheckedChanged | SCP0098_CopySelect_Popup.cs:123 | if (loaded) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-8bf4e76f | rbOpt1.CheckedChanged | SCP0098_CopySelect_Popup.cs:124 | if (loaded) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-097174f4 | rbOpt1.CheckedChanged | SCP0098_CopySelect_Popup.cs:126 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0098_CopySelect_Popup.rbOpt2_Click

진입점: rbOpt2.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99f4e6a7 | rbOpt2.CheckedChanged | SCP0098_CopySelect_Popup.cs:133 | if (loaded) | FLAG | Selection | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-d6fb7162 | rbOpt2.CheckedChanged | SCP0098_CopySelect_Popup.cs:134 | if (loaded) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-57193016 | rbOpt2.CheckedChanged | SCP0098_CopySelect_Popup.cs:135 | if (loaded) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0098_CopySelect_Popup.SetOption

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b97a73cc | (진입점 미연결) | SCP0098_CopySelect_Popup.cs:100 | if (index == 0) | VALUE_SET | rbOpt1.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-95284fa5 | (진입점 미연결) | SCP0098_CopySelect_Popup.cs:102 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rbOpt2.Text | option_name | 컨트롤 값 설정 |  |  |  |


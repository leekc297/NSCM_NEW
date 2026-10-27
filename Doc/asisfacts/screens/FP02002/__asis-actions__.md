# AS-IS 액션 대조표 — FP02002

> 원천: `Doc/asisfacts/screens/FP02002/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 107행 · 메서드 31 · 종류 DATA_OP 20 · UI_PROP 15 · UI_MISC 11 · FLAG 9 · RETURN 8 · GRID_SET 8 · POPUP 7 · CALL_EXT 6 · VALUE_SET 6 · GRID_INIT 5 · STATE 3 · COMBO_DATA 2 · CALL_BASE 2 · MESSAGE 2 · LIST_BIND 1 · THROW 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 8


## FP02002_Job_Moniter_RECIPIENT..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f56d078 | .ctor | FP02002_Job_Moniter_RECIPIENT.cs:121 |  | FLAG | INSTANCE_ID | param | 화면 필드/플래그 변경 |  |  |  |
| AC-311e3891 | .ctor | FP02002_Job_Moniter_RECIPIENT.cs:123 |  | FLAG | this.Title | "Job Monitor Recipient" | 화면 필드/플래그 변경 |  |  |  |

## FP02002_Job_Moniter_RECIPIENT.btnClose_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecc1a94f | (진입점 미연결) | FP02002_Job_Moniter_RECIPIENT.cs:323 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02002_Job_Moniter_RECIPIENT.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e0fc50e | this.Load | FP02002_Job_Moniter_RECIPIENT.cs:158 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02002_Job_Moniter_RECIPIENT.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6341c914 | (진입점 미연결) | FP02002_Job_Moniter_RECIPIENT.cs:295 | if (!string.IsNullOrWhiteSpace(error_message)) | DATA_OP | row["MESSAGE"] | error_message | 행/컬럼 값 대입 |  |  |  |
| AC-81c88a31 | (진입점 미연결) | FP02002_Job_Moniter_RECIPIENT.cs:296 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02002_Job_Moniter_RECIPIENT.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1995a4d | this.Load | FP02002_Job_Moniter_RECIPIENT.cs:153 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02002_Job_Moniter_RECIPIENT.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20a7229d | Dispose | FP02002_Job_Moniter_RECIPIENT.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02002_Job_Moniter_RECIPIENT.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-245d010a | FindButton | FP02002_Job_Moniter_RECIPIENT.cs:175 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-dbdbafc7 | FindButton | FP02002_Job_Moniter_RECIPIENT.cs:176 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-41752274 | FindButton | FP02002_Job_Moniter_RECIPIENT.cs:178 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP02002_Job_Moniter_RECIPIENT.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87fde245 | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:212 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-6d31c0cf | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:212 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e3371ac | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:216 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0eedc2f9 | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:224 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a22b9065 | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:229 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "SYSTEM_CALL_RECIPIENT", "", "") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3fc6f229 | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:231 | try | DATA_OP | dtsResult.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-68645dcb | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:233 | try | DATA_OP | dsResult_.Tables.Add | (dtsResult_TMP) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e097932 | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:235 | try | LIST_BIND | spdMain.DataSource | dsResult_ | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-37b480a5 | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:237 | try | GRID_SET | spdMain.ActiveSheet.Columns[0].Width | 100 | 그리드 속성/값 설정 |  |  |  |
| AC-9ded9618 | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:238 | try | GRID_SET | spdMain.ActiveSheet.Columns[1].Width | 250 | 그리드 속성/값 설정 |  |  |  |
| AC-948dcb9f | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:240 | try | GRID_SET | spdMain.ActiveSheet.RowHeader.Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a07223e0 | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:242 | try | GRID_SET | spdMain.ActiveSheet.Columns[0].HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-08a57003 | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:243 | try | GRID_SET | spdMain.ActiveSheet.Columns[0].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-47017503 | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:244 | try | GRID_SET | spdMain.ActiveSheet.Columns[1].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-d16da75a | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:248 | try ▸ if (dtsResult_TMP.Rows.Count > 1) | UI_PROP | this.Height | 60 + dtsResult_TMP.Rows.Count * _Height | 속성 Height 설정 |  |  |  |
| AC-418a05d3 | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:258 | finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; //this.btnC… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f55dff9 | this.Load 외 1 | FP02002_Job_Moniter_RECIPIENT.cs:261 | finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02002_Job_Moniter_RECIPIENT.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33392015 | this.Load | FP02002_Job_Moniter_RECIPIENT.cs:129 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-94a2864b | this.Load | FP02002_Job_Moniter_RECIPIENT.cs:131 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02002_Job_Moniter..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bce6d7f | .ctor | FP02002_Job_Moniter.cs:83 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-4b25eafb | .ctor | FP02002_Job_Moniter.cs:86 |  | VALUE_SET | layoutControlItem5.Text | "yyyyMMdd hh:mm:ss" | 컨트롤 값 설정 |  |  |  |

## FP02002_Job_Moniter.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fda3b8d | this.btnSql.Click | FP02002_Job_Moniter.cs:456 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-390e4311 | this.btnSql.Click | FP02002_Job_Moniter.cs:459 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5366a4c1 | this.btnSql.Click | FP02002_Job_Moniter.cs:460 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-56a0e96c | this.btnSql.Click | FP02002_Job_Moniter.cs:462 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02002_Job_Moniter") | 데이터 객체 조작/조회 |  |  |  |
| AC-750bbc7f | this.btnSql.Click | FP02002_Job_Moniter.cs:464 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02002_Job_Moniter.cboTimerONOFF_SelectedIndexChanged

진입점: this.cboTimerONOFF.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b431639c | this.cboTimerONOFF.SelectedIndexChanged | FP02002_Job_Moniter.cs:528 | if (cboTimerONOFF.SelectedItem.ToString() == "ON") ▸ if (this.ParentForm.ActiveControl == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-043b3fa2 | this.cboTimerONOFF.SelectedIndexChanged | FP02002_Job_Moniter.cs:529 | if (cboTimerONOFF.SelectedItem.ToString() == "ON") | DATA_OP | this.ParentForm.ActiveControl.Text.Contains | ("Job Monitor") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d3f49fa | this.cboTimerONOFF.SelectedIndexChanged | FP02002_Job_Moniter.cs:531 | if (cboTimerONOFF.SelectedItem.ToString() == "ON") ▸ if (this.ParentForm.ActiveControl.Text.Contains("Job Monitor")) | UI_PROP | timer.Interval | Convert.ToInt32(usrComboBox_Interval.Text) * Interval_Value | 속성 Interval 설정 |  |  |  |

## FP02002_Job_Moniter.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52d6be17 | this.Load | FP02002_Job_Moniter.cs:217 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1e580ccc | this.Load | FP02002_Job_Moniter.cs:218 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## FP02002_Job_Moniter.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a97361c7 | this.Load | FP02002_Job_Moniter.cs:190 |  | DATA_OP | cboTimerONOFF.Items.Add | ("ON") | 데이터 객체 조작/조회 |  |  |  |
| AC-a76ccb2c | this.Load | FP02002_Job_Moniter.cs:191 |  | DATA_OP | cboTimerONOFF.Items.Add | ("OFF") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e478963 | this.Load | FP02002_Job_Moniter.cs:193 |  | VALUE_SET | cboTimerONOFF.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-41814b08 | this.Load | FP02002_Job_Moniter.cs:196 |  | DATA_OP | usrComboBox_Interval.Items.Add | ("2") | 데이터 객체 조작/조회 |  |  |  |
| AC-b73faaa2 | this.Load | FP02002_Job_Moniter.cs:197 |  | DATA_OP | usrComboBox_Interval.Items.Add | ("3") | 데이터 객체 조작/조회 |  |  |  |
| AC-81c6b396 | this.Load | FP02002_Job_Moniter.cs:198 |  | DATA_OP | usrComboBox_Interval.Items.Add | ("4") | 데이터 객체 조작/조회 |  |  |  |
| AC-bec92a3e | this.Load | FP02002_Job_Moniter.cs:199 |  | DATA_OP | usrComboBox_Interval.Items.Add | ("5") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a3af1b4 | this.Load | FP02002_Job_Moniter.cs:200 |  | DATA_OP | usrComboBox_Interval.Items.Add | ("6") | 데이터 객체 조작/조회 |  |  |  |
| AC-d3910d37 | this.Load | FP02002_Job_Moniter.cs:201 |  | DATA_OP | usrComboBox_Interval.Items.Add | ("7") | 데이터 객체 조작/조회 |  |  |  |
| AC-429b9bdd | this.Load | FP02002_Job_Moniter.cs:202 |  | DATA_OP | usrComboBox_Interval.Items.Add | ("8") | 데이터 객체 조작/조회 |  |  |  |
| AC-60dddfa2 | this.Load | FP02002_Job_Moniter.cs:203 |  | DATA_OP | usrComboBox_Interval.Items.Add | ("9") | 데이터 객체 조작/조회 |  |  |  |
| AC-4d95e1f7 | this.Load | FP02002_Job_Moniter.cs:204 |  | DATA_OP | usrComboBox_Interval.Items.Add | ("10") | 데이터 객체 조작/조회 |  |  |  |
| AC-154bba41 | this.Load | FP02002_Job_Moniter.cs:206 |  | VALUE_SET | usrComboBox_Interval.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP02002_Job_Moniter.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a71fb8d5 | DeleteButton | FP02002_Job_Moniter.cs:367 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a5b8ec7 | DeleteButton | FP02002_Job_Moniter.cs:370 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP02002_Job_Moniter.Dispose

진입점: this.FormClosed / Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff8edc61 | this.FormClosed 외 1 | FP02002_Job_Moniter.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02002_Job_Moniter.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1c25b5e | ExcelButton | FP02002_Job_Moniter.cs:247 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-d8c6f2ca | ExcelButton | FP02002_Job_Moniter.cs:248 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-b765c504 | ExcelButton | FP02002_Job_Moniter.cs:250 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-65bd16fe | ExcelButton | FP02002_Job_Moniter.cs:254 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-43c5ca55 | ExcelButton | FP02002_Job_Moniter.cs:255 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-d1748fdf | ExcelButton | FP02002_Job_Moniter.cs:256 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-08a9e652 | ExcelButton | FP02002_Job_Moniter.cs:259 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-72b57411 | ExcelButton | FP02002_Job_Moniter.cs:260 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-05aace71 | ExcelButton | FP02002_Job_Moniter.cs:261 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-e923e887 | ExcelButton | FP02002_Job_Moniter.cs:263 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-23cfd037 | ExcelButton | FP02002_Job_Moniter.cs:264 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-5b690833 | ExcelButton | FP02002_Job_Moniter.cs:271 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c36ca323 | ExcelButton | FP02002_Job_Moniter.cs:275 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-80124356 | ExcelButton | FP02002_Job_Moniter.cs:279 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02002_Job_Moniter.Find_Data_Amend

진입점: this.Load [try] / timer.Tick [if (cboTimerONOFF.SelectedItem.ToString() == "ON") ▸ if (this.ParentForm.ActiveControl.Text.Contains("Job Monitor")) ▸ try] / this.Activated [if (cboTimerONOFF.SelectedItem.ToString() == "ON") ▸ if (!this.GetTopLevel()) ▸ try] / popSql.OnSql [if (fps.Name == "spdMain")] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84a4e381 | this.Load [try] 외 4 | FP02002_Job_Moniter.cs:408 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "JOB_MONITER", "", "") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0f7ce9c7 | this.Load [try] 외 4 | FP02002_Job_Moniter.cs:410 | try | DATA_OP | dtsResult.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e3e9a36 | this.Load [try] 외 4 | FP02002_Job_Moniter.cs:412 | try | DATA_OP | dsResult_.Tables.Add | (dtsResult_TMP) | 데이터 객체 조작/조회 |  |  |  |
| AC-526a30ec | this.Load [try] 외 4 | FP02002_Job_Moniter.cs:415 | try | RETURN | return dsResult_; |  | 처리 중단/반환 |  |  |  |
| AC-fe30d36d | this.Load [try] 외 4 | FP02002_Job_Moniter.cs:419 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02002_Job_Moniter.Find_Timer_Tick

진입점: timer.Tick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d9effda | timer.Tick | FP02002_Job_Moniter.cs:108 | if (this.ParentForm == null) | VALUE_SET | cboTimerONOFF.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |
| AC-19bbcde9 | timer.Tick | FP02002_Job_Moniter.cs:109 | if (this.ParentForm == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df7ccc23 | timer.Tick | FP02002_Job_Moniter.cs:118 | if (cboTimerONOFF.SelectedItem.ToString() == "ON") | DATA_OP | this.ParentForm.ActiveControl.Text.Contains | ("Job Monitor") | 데이터 객체 조작/조회 |  |  |  |

## FP02002_Job_Moniter.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5cd139b | this.Load | FP02002_Job_Moniter.cs:130 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02002_Job_Moniter.FP02002_Job_Moniter_Activated

진입점: this.Activated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64e9bf28 | this.Activated | FP02002_Job_Moniter.cs:159 | if (cboTimerONOFF.SelectedItem.ToString() == "ON") | CALL_BASE | this.GetTopLevel | () | ⚠ 의미 확인 필요 |  |  |  |

## FP02002_Job_Moniter.FP02002_Job_Moniter_FormClosed

진입점: this.FormClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c90342a7 | this.FormClosed | FP02002_Job_Moniter.cs:149 |  | UI_MISC | timer.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-413db9a9 | this.FormClosed | FP02002_Job_Moniter.cs:150 |  | CALL_EXT | timer.Stop | () | ⚠ 의미 확인 필요 |  |  |  |

## FP02002_Job_Moniter.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03bb8c32 | this.Load | FP02002_Job_Moniter.cs:211 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP02002_Job_Moniter.RECIPIENT_Click

진입점: this.RECIPIENT.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95a57f1f | this.RECIPIENT.Click | FP02002_Job_Moniter.cs:502 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-13659bd8 | this.RECIPIENT.Click | FP02002_Job_Moniter.cs:507 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8e03f9a4 | this.RECIPIENT.Click | FP02002_Job_Moniter.cs:508 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02002_Job_Moniter.RefreshSpreadSheet

진입점: this.Load [try] / timer.Tick [if (cboTimerONOFF.SelectedItem.ToString() == "ON") ▸ if (this.ParentForm.ActiveControl.Text.Contains("Job Monitor")) ▸ try] / this.Activated [if (cboTimerONOFF.SelectedItem.ToString() == "ON") ▸ if (!this.GetTopLevel()) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc455c85 | this.Load [try] 외 3 | FP02002_Job_Moniter.cs:355 |  | CALL_EXT | siMain.EditQuery | (dsMain) | ⚠ 의미 확인 필요 |  |  |  |

## FP02002_Job_Moniter.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38f90b6c | popSql.OnSql | FP02002_Job_Moniter.cs:471 | if (fps.Name == "spdMain") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-26ee6dd2 | popSql.OnSql | FP02002_Job_Moniter.cs:474 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02002_Job_Moniter.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2412575 | this.Load | FP02002_Job_Moniter.cs:175 |  | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP02002_Job_Moniter.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-156529df | this.Load | FP02002_Job_Moniter.cs:228 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ba82a9ac | this.Load | FP02002_Job_Moniter.cs:229 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-e0fe9a7a | this.Load | FP02002_Job_Moniter.cs:232 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP02002_Job_Moniter.timerEngine

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f45c8a76 | this.Load | FP02002_Job_Moniter.cs:94 |  | UI_PROP | timer.Interval | Convert.ToInt32(usrComboBox_Interval.Text) * Interval_Value | 속성 Interval 설정 |  |  |  |
| AC-c1ef15d2 | this.Load | FP02002_Job_Moniter.cs:98 |  | CALL_EXT | timer.Start | () | ⚠ 의미 확인 필요 |  |  |  |

## FP02002_Job_Moniter.UIFindData

진입점: this.Load / timer.Tick [if (cboTimerONOFF.SelectedItem.ToString() == "ON") ▸ if (this.ParentForm.ActiveControl.Text.Contains("Job Monitor"))] / this.Activated [if (cboTimerONOFF.SelectedItem.ToString() == "ON") ▸ if (!this.GetTopLevel())] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a45b7292 | this.Load 외 3 | FP02002_Job_Moniter.cs:294 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-68bf0bea | this.Load 외 3 | FP02002_Job_Moniter.cs:301 | try | FLAG | dsMain | Find_Data_Amend("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-59fb8f32 | this.Load 외 3 | FP02002_Job_Moniter.cs:313 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-086d036d | this.Load 외 3 | FP02002_Job_Moniter.cs:314 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-30cc7373 | this.Load 외 3 | FP02002_Job_Moniter.cs:315 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-28eef330 | this.Load 외 3 | FP02002_Job_Moniter.cs:320 | try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-aa41c5fd | this.Load 외 3 | FP02002_Job_Moniter.cs:321 | try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-b7b61790 | this.Load 외 3 | FP02002_Job_Moniter.cs:341 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c33e737f | this.Load 외 3 | FP02002_Job_Moniter.cs:348 | finally | VALUE_SET | layoutControlItem5.Text | DateTime.Now.ToString("yyyy.MM.dd hh:mm:ss tt") | 컨트롤 값 설정 |  |  |  |

## FP02002_Job_Moniter.UsrComboBox_Interval_SelectedIndexChanged

진입점: usrComboBox_Interval.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-153b4ba1 | usrComboBox_Interval.SelectedIndexChanged | FP02002_Job_Moniter.cs:429 |  | UI_PROP | timer.Interval | Convert.ToInt32(usrComboBox_Interval.Text) * Interval_Value | 속성 Interval 설정 |  |  |  |


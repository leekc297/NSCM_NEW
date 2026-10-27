# AS-IS 액션 대조표 — FPC0121

> 원천: `Doc/asisfacts/screens/FPC0121/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 330행 · 메서드 23 · 종류 DATA_OP 161 · UI_PROP 17 · CALL_EXT 16 · VALUE_SET 16 · GRID_SET 16 · RETURN 14 · STATE 14 · ENDPOINT 13 · GRID_LOCK 13 · FLAG 12 · UI_MISC 9 · POPUP 8 · MESSAGE 6 · VALUE_CLEAR 4 · GRID_INIT 4 · COMBO_DATA 2 · STATE_RESET 2 · GRID_BIND 1 · LIST_REBIND 1 · LIST_CLEAR 1 · ⚠ 의미 확인 필요 16


## FPC0121_AlarmEditPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-812bc759 | .ctor | FPC0121_AlarmEditPopup.cs:126 |  | FLAG | SrcRow | row | 화면 필드/플래그 변경 |  |  |  |
| AC-51d2874f | .ctor | FPC0121_AlarmEditPopup.cs:129 |  | FLAG | Day | date | 화면 필드/플래그 변경 |  |  |  |
| AC-8c99ab11 | .ctor | FPC0121_AlarmEditPopup.cs:133 |  | FLAG | this.sDivisionId | "ALL" | 화면 필드/플래그 변경 |  |  |  |

## FPC0121_AlarmEditPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f535aff6 | (진입점 미연결) | FPC0121_AlarmEditPopup.cs:808 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-1feae92d | (진입점 미연결) | FPC0121_AlarmEditPopup.cs:811 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0121_AlarmEditPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa62c4eb | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1064 | try | DATA_OP | Filter["BUCKET_FROM"] | Filter["BUCKET_TO"] = dpPlanDate.Text | 행/컬럼 값 대입 |  |  |  |
| AC-576078d9 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1064 | try | DATA_OP | Filter["BUCKET_TO"] | dpPlanDate.Text | 행/컬럼 값 대입 |  |  |  |
| AC-f1296e15 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1066 | try | DATA_OP | Filter["MEMO"] | txtMemo.Text | 행/컬럼 값 대입 |  |  |  |
| AC-9304a7f9 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1067 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f46170be | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1068 | try | DATA_OP | Filter["ALARM_TIME"] | dtAlarm.Text | 행/컬럼 값 대입 |  |  |  |
| AC-02f88aef | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1071 | try ▸ if (old_alarm_time == dtAlarm.Text) | DATA_OP | Filter["ALARM_YN"] | old_alarm_yn | 행/컬럼 값 대입 |  |  |  |
| AC-c6ac71dc | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1075 | try ▸ else of (old_alarm_time == dtAlarm.Text) | DATA_OP | Filter["ALARM_YN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-84857712 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1078 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("PICAlarm", "max_pic_ref", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=max_pic_ref] \| FP\Common\PICAl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3eea0650 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1081 | try ▸ if (max_pic_ref.Good()) | DATA_OP | Filter["PIC_REF"] | max_pic_ref.Tables[0].Rows[0]["PIC_REF"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e52e4cc4 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1084 | try | UI_PROP | alarm.TableName | "AlarmData" | 속성 TableName 설정 |  |  |  |
| AC-3754ebb5 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1085 | try | DATA_OP | alarm.Columns.SafeAdd | ("P_USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-98e29209 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1086 | try | DATA_OP | alarm.Columns.SafeAdd | ("PIC_REF", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4892b65 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1087 | try | DATA_OP | alarm.Columns.SafeAdd | ("EMAIL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-226d2192 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1088 | try | DATA_OP | alarm.Columns.SafeAdd | ("PHONE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a88d547 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1089 | try | DATA_OP | alarm.Columns.SafeAdd | ("DEPT_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8be8c2a | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1090 | try | DATA_OP | alarm.Columns.SafeAdd | ("USER_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d5ede5b | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1091 | try | DATA_OP | alarm.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-160a3e5c | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1100 | try ▸ for (i<len) ▸ if (string.IsNullOrWhiteSpace(picuser)) | MESSAGE | MessageBox.Show | ("Need to specify PIC user id") | 메시지 표시 |  |  |  |
| AC-80ab817d | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1101 | try ▸ for (i<len) ▸ if (string.IsNullOrWhiteSpace(picuser)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-096a3f3a | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1107 | try ▸ for (i<len) | DATA_OP | alarm.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-476f5761 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1108 | try ▸ for (i<len) | DATA_OP | insRow["PIC_REF"] | Filter["PIC_REF"] | 행/컬럼 값 대입 |  |  |  |
| AC-66e66330 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1109 | try ▸ for (i<len) | DATA_OP | insRow["P_USER_ID"] | picuser | 행/컬럼 값 대입 |  |  |  |
| AC-76545c70 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1110 | try ▸ for (i<len) | DATA_OP | insRow["USER_NAME"] | siMain.ActiveSheet.Cells[i, 3].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0cb803b6 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1111 | try ▸ for (i<len) | DATA_OP | insRow["DEPT_NAME"] | siMain.ActiveSheet.Cells[i, 2].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-509f11ef | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1112 | try ▸ for (i<len) | DATA_OP | insRow["EMAIL"] | siMain.ActiveSheet.Cells[i, 4].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7a23806c | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1113 | try ▸ for (i<len) | DATA_OP | insRow["PHONE"] | phone | 행/컬럼 값 대입 |  |  |  |
| AC-d7b2fbf3 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1114 | try ▸ for (i<len) | DATA_OP | insRow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5ea191f4 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1116 | try ▸ for (i<len) | DATA_OP | alarm.Rows.Add | (insRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-f642a9ea | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1124 | try ▸ if (dtEtcColorInfo.Good()) | CALL_EXT | dtEtcColorInfo.findRow | ("UI_DESC", cboColorBox.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a5cc425 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1146 | try | DATA_OP | Filter["SETUP_COLOR_CODE"] | getColorParam | 행/컬럼 값 대입 |  |  |  |
| AC-7babeb07 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1147 | try | DATA_OP | Filter["ATTR1"] | getColorParam | 행/컬럼 값 대입 |  |  |  |
| AC-ca77575c | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1148 | try | DATA_OP | Filter["ATTR2"] | getCategoryParam | 행/컬럼 값 대입 |  |  |  |
| AC-b460e4d6 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1149 | try | DATA_OP | Filter["ATTR3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-28137bb0 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1150 | try | DATA_OP | Filter["ATTR4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c8389bf0 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1151 | try | DATA_OP | Filter["ATTR5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-70df1924 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1154 | try | ENDPOINT | DataService.FP_PseudoBatch2 | ("PICAlarm", "save_alarm", alarm) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_alarm] \| FP\Common\PICAlar… | 엔드포인트 호출 |  |  |  |
| AC-e9d26ea5 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1155 | try | CALL_EXT | DataService.ReadResult | (res) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3b73aa6 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1158 | try ▸ if (result.Success) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("PICAlarm", "save_pic_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_pic_memo] \| FP\Common\… | 엔드포인트 호출 |  |  |  |
| AC-aa048153 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1160 | try ▸ if (result.Success) | MESSAGE | MessageBox.Show | ("Save alarm success") | 메시지 표시 |  |  |  |
| AC-601d88d1 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1161 | try ▸ if (result.Success) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-c1550e95 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1162 | try ▸ if (result.Success) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-b624b6f0 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1166 | try ▸ else of (result.Success) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("PICAlarm", "save_pic_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_pic_memo] \| FP\Common\… | 엔드포인트 호출 |  |  |  |
| AC-8fc47c4c | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1168 | try ▸ else of (result.Success) | MESSAGE | MessageBox.Show | ("Save as memo") | 메시지 표시 |  |  |  |
| AC-3426a827 | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1169 | try ▸ else of (result.Success) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-b2a1543c | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1170 | try ▸ else of (result.Success) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-1275350f | this.btnSave.Click | FPC0121_AlarmEditPopup.cs:1175 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Save Error: " + xe.Message) | 메시지 표시 |  |  |  |

## FPC0121_AlarmEditPopup.cboColorBox_DrawItem

진입점: this.cboColorBox.DrawItem

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c53d7b4a | this.cboColorBox.DrawItem | FPC0121_AlarmEditPopup.cs:1353 | if (e.Index >= 0) | CALL_EXT | g.FillRectangle | (new SolidBrush(BackColor), rect) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e58ec70 | this.cboColorBox.DrawItem | FPC0121_AlarmEditPopup.cs:1356 | if (e.Index >= 0) | CALL_EXT | g.DrawString | (n, f, Brushes.Black, rect.X, rect.Top) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20eef8a2 | this.cboColorBox.DrawItem | FPC0121_AlarmEditPopup.cs:1363 | if (e.Index >= 0) ▸ try ▸ if (dictColor != null && dictColor.Count > 0) | CALL_EXT | g.FillRectangle | (b, rect.X + 110, rect.Y + 3, rect.Width - 10, rect.Height - 3) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0121_AlarmEditPopup.clbCategory_GetRectangleColor

진입점: this.clbCategory.GetRectangleColor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3968cdb1 | this.clbCategory.GetRectangleColor | FPC0121_AlarmEditPopup.cs:1334 | if (e.Index >= 0) ▸ if (dtCategoryColorInfo.Good()) ▸ if (e.Index < dtCategoryColorInfo.Rows.Count) ▸ try | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (dtCategoryColorInfo.Rows[e.Index]["UI_COLOR"].SafeString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a69bbad5 | this.clbCategory.GetRectangleColor | FPC0121_AlarmEditPopup.cs:1335 | if (e.Index >= 0) ▸ if (dtCategoryColorInfo.Good()) ▸ if (e.Index < dtCategoryColorInfo.Rows.Count) ▸ try | RETURN | return color; |  | 처리 중단/반환 |  |  |  |
| AC-158bcb39 | this.clbCategory.GetRectangleColor | FPC0121_AlarmEditPopup.cs:1339 | if (e.Index >= 0) ▸ if (dtCategoryColorInfo.Good()) ▸ if (e.Index < dtCategoryColorInfo.Rows.Count) ▸ catch () | RETURN | return MemoService.DefaultCateColor; |  | 처리 중단/반환 |  |  |  |
| AC-fdaa7743 | this.clbCategory.GetRectangleColor | FPC0121_AlarmEditPopup.cs:1344 |  | RETURN | return MemoService.DefaultCateColor; |  | 처리 중단/반환 |  |  |  |

## FPC0121_AlarmEditPopup.ClbCategory_SelectedIndexChanged

진입점: clbCategory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a7812b8 | clbCategory.SelectedIndexChanged | FPC0121_AlarmEditPopup.cs:397 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) | DATA_OP | color_infos.Contains | (value) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d3581db | clbCategory.SelectedIndexChanged | FPC0121_AlarmEditPopup.cs:399 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) ▸ if (color_infos.Contains(v… | CALL_EXT | clbCategory.SetItemChecked | (idx, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-115df248 | clbCategory.SelectedIndexChanged | FPC0121_AlarmEditPopup.cs:400 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) ▸ if (color_infos.Contains(v… | DATA_OP | name.ToUpper().Contains | ("MODEL CHANGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-776f8069 | clbCategory.SelectedIndexChanged | FPC0121_AlarmEditPopup.cs:408 | if (dtCategoryColorInfo.Good()) ▸ if (ModelChangeSelected) | STATE | cboColorBox.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-be9e1c8c | clbCategory.SelectedIndexChanged | FPC0121_AlarmEditPopup.cs:413 | if (dtCategoryColorInfo.Good()) ▸ else of (ModelChangeSelected) | STATE | cboColorBox.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fd68eb4a | clbCategory.SelectedIndexChanged | FPC0121_AlarmEditPopup.cs:414 | if (dtCategoryColorInfo.Good()) ▸ else of (ModelChangeSelected) | VALUE_CLEAR | cboColorBox.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |

## FPC0121_AlarmEditPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-524171fe | this.Load | FPC0121_AlarmEditPopup.cs:649 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b18e5780 | this.Load | FPC0121_AlarmEditPopup.cs:650 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-78898722 | this.Load | FPC0121_AlarmEditPopup.cs:651 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0121_AlarmEditPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-327b95ca | this.Load | FPC0121_AlarmEditPopup.cs:644 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0121_AlarmEditPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fd46c6f | Dispose | FPC0121_AlarmEditPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0121_AlarmEditPopup.FindData

진입점: FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6ee505b | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:718 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-91203fbc | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:719 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e77a2fd7 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:722 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-072b3cbe | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:724 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Common.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7ed573e0 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:728 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Common.PR_UI_COMMON_POPUP") ⇒ FP_Common.PR_UI_COMMON_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-1706aff0 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:730 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-25b87583 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:732 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-b73383cf | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:733 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | "ITEM_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-337f7071 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:734 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-45830334 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:735 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a422bfa9 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:736 | lambda | DATA_OP | request.Parameters["p_non_auth"] | _sNonAuth | 행/컬럼 값 대입 |  |  |  |
| AC-1dde470f | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:737 | lambda | DATA_OP | request.Parameters["p_save_auth"] | _sSaveAuth | 행/컬럼 값 대입 |  |  |  |
| AC-d75d1d4d | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:739 | lambda | DATA_OP | request.Parameters["p_param1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-631ad09f | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:740 | lambda | DATA_OP | request.Parameters["p_param2"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-0e2e02d2 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:741 | lambda | DATA_OP | request.Parameters["p_param3"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-914731a3 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:742 | lambda | DATA_OP | request.Parameters["p_param4"] | pItemID.Equals("ALL") ? DBNull.Value : pItemID | 행/컬럼 값 대입 |  |  |  |
| AC-794758de | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:743 | lambda | DATA_OP | request.Parameters["p_param5"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-d5430171 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:744 | lambda | DATA_OP | request.Parameters["p_param6"] | (string.IsNullOrEmpty(sLevel2CodeFlag)) ? DBNull.Value : sLevel2CodeFlag as object | 행/컬럼 값 대입 |  |  |  |
| AC-64d93121 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:745 | lambda | DATA_OP | request.Parameters["p_param7"] | (string.IsNullOrEmpty(sLevel2Code)) ? DBNull.Value : sLevel2Code as object | 행/컬럼 값 대입 |  |  |  |
| AC-cc6e2a20 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:746 | lambda | DATA_OP | request.Parameters["p_param8"] | (string.IsNullOrEmpty(sIsFormationFlowIdExists)) ? DBNull.Value : sIsFormationFlowIdExists… | 행/컬럼 값 대입 |  |  |  |
| AC-80ff9aac | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:747 | lambda | DATA_OP | request.Parameters["p_param9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8b386e58 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:748 | lambda | DATA_OP | request.Parameters["p_param10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3c717dd0 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:750 | lambda | DATA_OP | request.Parameters["p_param11"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c284f950 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:751 | lambda | DATA_OP | request.Parameters["p_param12"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-25e4f9b2 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:752 | lambda | DATA_OP | request.Parameters["p_param13"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-151ffa6e | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:753 | lambda | DATA_OP | request.Parameters["p_param14"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-26581608 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:754 | lambda | DATA_OP | request.Parameters["p_param15"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e218b786 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:755 | lambda | DATA_OP | request.Parameters["p_param16"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3950bde4 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:756 | lambda | DATA_OP | request.Parameters["p_param17"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fff8e3ae | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:757 | lambda | DATA_OP | request.Parameters["p_param18"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-156070e3 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:758 | lambda | DATA_OP | request.Parameters["p_param19"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-316bcec6 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:759 | lambda | DATA_OP | request.Parameters["p_param20"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cd6bc920 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:760 | lambda | DATA_OP | request.Parameters["TimeZone"] | TimeZone | 행/컬럼 값 대입 |  |  |  |
| AC-b8435d8f | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:762 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-da5dd289 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:764 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-82e0dd3c | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:769 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6167203c | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:773 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-68530e53 | FindButton 외 1 | FPC0121_AlarmEditPopup.cs:779 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0121_AlarmEditPopup.fn_setRowInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f3986bd | (진입점 미연결) | FPC0121_AlarmEditPopup.cs:848 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7499ba4f | (진입점 미연결) | FPC0121_AlarmEditPopup.cs:849 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ce15d3a | (진입점 미연결) | FPC0121_AlarmEditPopup.cs:858 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0121_AlarmEditPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba64f0e0 | this.Load | FPC0121_AlarmEditPopup.cs:142 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d572380e | this.Load | FPC0121_AlarmEditPopup.cs:144 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-66296fe2 | this.Load | FPC0121_AlarmEditPopup.cs:147 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |

## FPC0121_AlarmEditPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b8d6b2e | this.Load | FPC0121_AlarmEditPopup.cs:165 |  | UI_PROP | clbCategory.UserRvSearch | true | 속성 UserRvSearch 설정 |  |  |  |
| AC-a13b2bc0 | this.Load | FPC0121_AlarmEditPopup.cs:166 |  | UI_PROP | clbCategory.NoneString | "None" | 속성 NoneString 설정 |  |  |  |
| AC-3d6da9c8 | this.Load | FPC0121_AlarmEditPopup.cs:170 |  | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6e1d139 | this.Load | FPC0121_AlarmEditPopup.cs:173 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2f24adcb | this.Load | FPC0121_AlarmEditPopup.cs:174 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnInsert.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f0789849 | this.Load | FPC0121_AlarmEditPopup.cs:175 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnDelete.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d849144a | this.Load | FPC0121_AlarmEditPopup.cs:176 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | txtMemo.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-27c25854 | this.Load | FPC0121_AlarmEditPopup.cs:177 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | txtMemo.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-914052bb | this.Load | FPC0121_AlarmEditPopup.cs:182 | else of (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ab2b8c19 | this.Load | FPC0121_AlarmEditPopup.cs:183 | else of (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnInsert.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fc392e11 | this.Load | FPC0121_AlarmEditPopup.cs:184 | else of (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnDelete.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-025a3ea0 | this.Load | FPC0121_AlarmEditPopup.cs:185 | else of (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | txtMemo.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-8b0f7c0e | this.Load | FPC0121_AlarmEditPopup.cs:186 | else of (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | txtMemo.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4dd6c274 | this.Load | FPC0121_AlarmEditPopup.cs:190 | if (SrcRow!=null) | VALUE_SET | dpPlanDate.Text | Day.Date.ToString("yyyyMMdd") | 컨트롤 값 설정 |  |  |  |
| AC-11ba3025 | this.Load | FPC0121_AlarmEditPopup.cs:191 | if (SrcRow!=null) | VALUE_SET | txtProdType.Text | SrcRow["PRODUCTION_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-6cdcf9a0 | this.Load | FPC0121_AlarmEditPopup.cs:192 | if (SrcRow!=null) | VALUE_SET | txtModel.Text | SrcRow["TOP_ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f26584f8 | this.Load | FPC0121_AlarmEditPopup.cs:193 | if (SrcRow!=null) | VALUE_SET | txtItem.Text | SrcRow["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-fff311e2 | this.Load | FPC0121_AlarmEditPopup.cs:194 | if (SrcRow!=null) | DATA_OP | SrcRow.Table.Columns.Contains | ("NICK_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a39584e | this.Load | FPC0121_AlarmEditPopup.cs:195 | if (SrcRow!=null) ▸ if (SrcRow.Table.Columns.Contains("NICK_NAME")) | VALUE_SET | txtNickName.Text | SrcRow["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a97a81ae | this.Load | FPC0121_AlarmEditPopup.cs:197 | if (SrcRow!=null) ▸ else of (SrcRow.Table.Columns.Contains("NICK_NAME")) | VALUE_CLEAR | txtNickName.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c10ac673 | this.Load | FPC0121_AlarmEditPopup.cs:198 | if (SrcRow!=null) | DATA_OP | SrcRow.Table.Columns.Contains | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc1ab855 | this.Load | FPC0121_AlarmEditPopup.cs:199 | if (SrcRow!=null) ▸ if (SrcRow.Table.Columns.Contains("ITEM_TYPE")) | VALUE_SET | txtItemType.Text | SrcRow["ITEM_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-76bf49c2 | this.Load | FPC0121_AlarmEditPopup.cs:200 | if (SrcRow!=null) | VALUE_SET | txtFactory.Text | SrcRow["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-15500ac9 | this.Load | FPC0121_AlarmEditPopup.cs:201 | if (SrcRow!=null) | VALUE_SET | txtMarket.Text | SrcRow["MARKET"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-53c20f85 | this.Load | FPC0121_AlarmEditPopup.cs:202 | if (SrcRow!=null) | VALUE_SET | txtOperation.Text | SrcRow["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-09abfb5a | this.Load | FPC0121_AlarmEditPopup.cs:203 | if (SrcRow!=null) | DATA_OP | SrcRow.Table.Columns.Contains | ("LINE_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-1fba43b0 | this.Load | FPC0121_AlarmEditPopup.cs:204 | if (SrcRow!=null) ▸ if (SrcRow.Table.Columns.Contains("LINE_NAME")) | VALUE_SET | txtLine.Text | SrcRow["LINE_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-3c462f5b | this.Load | FPC0121_AlarmEditPopup.cs:205 | if (SrcRow!=null) | VALUE_SET | txtElectrode.Text | SrcRow["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-fd4a8651 | this.Load | FPC0121_AlarmEditPopup.cs:206 | if (SrcRow!=null) | DATA_OP | SrcRow.Table.Columns.Contains | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f9eb8be | this.Load | FPC0121_AlarmEditPopup.cs:207 | if (SrcRow!=null) ▸ if (SrcRow.Table.Columns.Contains("LOCATION")) | VALUE_SET | txtLocation.Text | SrcRow["LOCATION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-3d9937e1 | this.Load | FPC0121_AlarmEditPopup.cs:213 | else of (SrcRow!=null) ▸ if (HasRole == false) | MESSAGE | MessageBox.Show | ("You have no right to add memo") | 메시지 표시 |  |  |  |
| AC-159f9a63 | this.Load | FPC0121_AlarmEditPopup.cs:214 | else of (SrcRow!=null) ▸ if (HasRole == false) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-08797f0f | this.Load | FPC0121_AlarmEditPopup.cs:215 | else of (SrcRow!=null) ▸ if (HasRole == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7bcc3a0a | this.Load | FPC0121_AlarmEditPopup.cs:223 | if (SrcRow != null) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c2569184 | this.Load | FPC0121_AlarmEditPopup.cs:225 | if (SrcRow != null) | DATA_OP | Filter["COMPANY_ID"] | SrcRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-043062b7 | this.Load | FPC0121_AlarmEditPopup.cs:226 | if (SrcRow != null) | DATA_OP | Filter["DIVISION_ID"] | SrcRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-358edd94 | this.Load | FPC0121_AlarmEditPopup.cs:227 | if (SrcRow != null) | DATA_OP | Filter["SITE_ID"] | SrcRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ed3511e7 | this.Load | FPC0121_AlarmEditPopup.cs:228 | if (SrcRow != null) | DATA_OP | Filter["LINE_ID"] | SrcRow["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eae8694e | this.Load | FPC0121_AlarmEditPopup.cs:229 | if (SrcRow != null) | DATA_OP | Filter["PLANT_ID"] | SrcRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c52f2945 | this.Load | FPC0121_AlarmEditPopup.cs:230 | if (SrcRow != null) | DATA_OP | Filter["FACTORY_ID"] | SrcRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-27e48b79 | this.Load | FPC0121_AlarmEditPopup.cs:231 | if (SrcRow != null) | DATA_OP | Filter["OPERATION_ID"] | SrcRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-46bb1170 | this.Load | FPC0121_AlarmEditPopup.cs:232 | if (SrcRow != null) | DATA_OP | Filter["TOP_ITEM_ID"] | SrcRow["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a4b4a7fc | this.Load | FPC0121_AlarmEditPopup.cs:233 | if (SrcRow != null) | DATA_OP | Filter["PRODUCTION_TYPE"] | SrcRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2d5cea0f | this.Load | FPC0121_AlarmEditPopup.cs:234 | if (SrcRow != null) | DATA_OP | Filter["MARKET"] | SrcRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-959f5618 | this.Load | FPC0121_AlarmEditPopup.cs:235 | if (SrcRow != null) | DATA_OP | Filter["PLAN_DATE"] | Day.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-858ff3e8 | this.Load | FPC0121_AlarmEditPopup.cs:236 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b755592a | this.Load | FPC0121_AlarmEditPopup.cs:237 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | SrcRow["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c1490e27 | this.Load | FPC0121_AlarmEditPopup.cs:239 | if (SrcRow != null) ▸ else of (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-cd6be7e9 | this.Load | FPC0121_AlarmEditPopup.cs:240 | if (SrcRow != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | SrcRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c6319e90 | this.Load | FPC0121_AlarmEditPopup.cs:241 | if (SrcRow != null) | DATA_OP | Filter["ITEM_ID"] | SrcRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-84633cb8 | this.Load | FPC0121_AlarmEditPopup.cs:243 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_FROM"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1d643540 | this.Load | FPC0121_AlarmEditPopup.cs:244 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_TO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eaba2c30 | this.Load | FPC0121_AlarmEditPopup.cs:246 | if (SrcRow != null) | ENDPOINT | DataService.FP_ExecuteQuery | ("PICAlarm", "find_color_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_color_memo] \| FP\Common\P… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c57974ad | this.Load | FPC0121_AlarmEditPopup.cs:254 | if (SrcRow != null) ▸ if (memoInfo.Good()) | DATA_OP | memoInfo.Tables[0].Columns.Contains | ("ATTR1") | 데이터 객체 조작/조회 |  |  |  |
| AC-c0e5b348 | this.Load | FPC0121_AlarmEditPopup.cs:256 | if (SrcRow != null) ▸ if (memoInfo.Good()) | DATA_OP | memoInfo.Tables[0].Columns.Contains | ("ATTR2") | 데이터 객체 조작/조회 |  |  |  |
| AC-5654fa9f | this.Load | FPC0121_AlarmEditPopup.cs:267 | if (SrcRow != null) ▸ if (memoInfo.Good()) | VALUE_SET | txtMemo.Text | memo | 컨트롤 값 설정 |  |  |  |
| AC-3799ed39 | this.Load | FPC0121_AlarmEditPopup.cs:268 | if (SrcRow != null) ▸ if (memoInfo.Good()) | FLAG | old_alarm_yn | memoInfo.Tables[0].Rows[0]["ALARM_YN"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b7865fab | this.Load | FPC0121_AlarmEditPopup.cs:289 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmTime!=null) | VALUE_SET | dtAlarm.Value | alarmTime.Value | 컨트롤 값 설정 |  |  |  |
| AC-3f381c19 | this.Load | FPC0121_AlarmEditPopup.cs:291 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmTime!=null) | FLAG | old_alarm_time | alarmTime.Value.ToString("yyyy-MM-dd HH:mmm") | 화면 필드/플래그 변경 |  |  |  |
| AC-830f9117 | this.Load | FPC0121_AlarmEditPopup.cs:297 | if (SrcRow != null) ▸ if (memoInfo.Good()) | DATA_OP | Filter["OLD_PIC_REF"] | Filter["PIC_REF"] = memoInfo.Tables[0].Rows[0]["PIC_REF"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c2b94a0a | this.Load | FPC0121_AlarmEditPopup.cs:297 | if (SrcRow != null) ▸ if (memoInfo.Good()) | DATA_OP | Filter["PIC_REF"] | memoInfo.Tables[0].Rows[0]["PIC_REF"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d2b247c7 | this.Load | FPC0121_AlarmEditPopup.cs:298 | if (SrcRow != null) ▸ if (memoInfo.Good()) | ENDPOINT | DataService.FP_ExecuteQuery | ("PICAlarm", "find_alarm", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] \| FP\Common\PICAla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-84019b72 | this.Load | FPC0121_AlarmEditPopup.cs:311 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | CALL_EXT | siMain.AddRows | (row_index, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6cd702c2 | this.Load | FPC0121_AlarmEditPopup.cs:317 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-057d3b38 | this.Load | FPC0121_AlarmEditPopup.cs:319 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.USER_ID), row_index, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f3cf1b7f | this.Load | FPC0121_AlarmEditPopup.cs:320 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.TEAM_NAME), row_index, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c5201ac | this.Load | FPC0121_AlarmEditPopup.cs:321 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.PHONE), row_index, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f967f4b9 | this.Load | FPC0121_AlarmEditPopup.cs:325 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.USER_ID, ro["USERID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8fa36c4 | this.Load | FPC0121_AlarmEditPopup.cs:326 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.TEAM_NAME, ro["DEPT_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c4b8cf0 | this.Load | FPC0121_AlarmEditPopup.cs:327 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.USER_NAME, ro["USER_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f8f3b0f | this.Load | FPC0121_AlarmEditPopup.cs:328 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.EMAIL, ro["EMAIL"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b77caf22 | this.Load | FPC0121_AlarmEditPopup.cs:329 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.PHONE, ro["PHONE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa70a05a | this.Load | FPC0121_AlarmEditPopup.cs:331 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-c69078bb | this.Load | FPC0121_AlarmEditPopup.cs:343 | if (SrcRow != null) ▸ else of (memoInfo.Good()) | VALUE_CLEAR | txtMemo.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-20553a82 | this.Load | FPC0121_AlarmEditPopup.cs:361 | if (SrcRow != null) ▸ if (!string.IsNullOrWhiteSpace(attr1_etc_color_info) && string.IsNullOrWhiteSpace(attr2_category_color_info)) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_CurColor", Filter["INSTANCE_ID"].ToString(), Filter["COMPANY_ID"].T… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FPC0121_AlarmEditPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b732f4b1 | this.Load | FPC0121_AlarmEditPopup.cs:661 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-eb61bb0d | this.Load | FPC0121_AlarmEditPopup.cs:663 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0121_AlarmEditPopup.RefreshCateCombo

진입점: this.Load [if (SrcRow != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-758fc9fd | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:421 |  | FLAG | dtCategoryColorInfo | dtEtcColorInfo.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-802d68df | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:421 |  | DATA_OP | dtEtcColorInfo.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5761635c | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:422 |  | DATA_OP | dtCategoryColorInfo.Columns.SafeAdd | ("COLOR_A", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc21ab68 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:423 |  | DATA_OP | dtCategoryColorInfo.Columns.SafeAdd | ("COLOR_B", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca981624 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:425 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4cce5a2f | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:426 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4de1a50e | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:431 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | dtCategoryColorInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d9a70651 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:435 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["UI_PARAM"] | cate["SEGMENT1"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-333e32b2 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:436 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["UI_DESC"] | cate["ATTRIBUTE2"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-466d919c | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:438 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["UI_COLOR"] | cate["ATTRIBUTE10"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-50d78212 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:439 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["COLOR_A"] | cate["ATTRIBUTE10"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-98a45583 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:440 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["COLOR_B"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-545acba2 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:441 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | dtCategoryColorInfo.Rows.Add | (nn) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d13aee5 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:442 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | cate["ATTRIBUTE2"].SafeString().ToUpper().Contains | ("MODEL CHANGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-51346ac5 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:443 | foreach (DataRow cate in coteInfo.Rows) ▸ if (cate["ATTRIBUTE2"].SafeString().ToUpper().Contains("MODEL CHANGE")) | FLAG | ChangeModelCateKey | cate["SEGMENT1"].SafeString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3b09eb76 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:447 |  | DATA_OP | dtCategoryColorInfo.Select | ("UI_PARAM = 'ETC'") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d56d89b | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:450 | if (rowsEtc.Length < 1) | DATA_OP | dtCategoryColorInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-68aec56a | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:454 | if (rowsEtc.Length < 1) | DATA_OP | nn["UI_PARAM"] | "Etc" | 행/컬럼 값 대입 |  |  |  |
| AC-b6bb98a1 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:455 | if (rowsEtc.Length < 1) | DATA_OP | nn["UI_DESC"] | "Etc" | 행/컬럼 값 대입 |  |  |  |
| AC-d5e9964c | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:456 | if (rowsEtc.Length < 1) | DATA_OP | nn["UI_COLOR"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3fbd51a4 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:457 | if (rowsEtc.Length < 1) | DATA_OP | nn["COLOR_A"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-472bd0fe | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:458 | if (rowsEtc.Length < 1) | DATA_OP | nn["COLOR_B"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2a0139cb | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:459 | if (rowsEtc.Length < 1) | DATA_OP | dtCategoryColorInfo.Rows.Add | (nn) | 데이터 객체 조작/조회 |  |  |  |
| AC-4412e42e | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:466 | foreach (DataRow arow in cateInstanceColorInfo.Rows) | DATA_OP | dtCategoryColorInfo.Select | ("UI_PARAM='" + key + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ee7654b | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:472 | foreach (DataRow arow in cateInstanceColorInfo.Rows) ▸ if (ress.Length > 0) ▸ if (!string.IsNullOrWhiteSpace(colorv)) | DATA_OP | ress[0]["UI_COLOR"] | colorv | 행/컬럼 값 대입 |  |  |  |
| AC-875162f6 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:473 | foreach (DataRow arow in cateInstanceColorInfo.Rows) ▸ if (ress.Length > 0) ▸ if (!string.IsNullOrWhiteSpace(colorv)) | DATA_OP | ress[0]["COLOR_B"] | colorv | 행/컬럼 값 대입 |  |  |  |
| AC-2e663e37 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:490 | if (dtCategoryColorInfo != null) | DATA_OP | dtCategoryColorInfo.Columns.SafeAdd | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5621e087 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:491 | if (dtCategoryColorInfo != null) | DATA_OP | dtCategoryColorInfo.Columns.SafeAdd | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-815e7bea | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:494 | if (dtCategoryColorInfo != null) ▸ foreach (DataRow ro in dtCategoryColorInfo.Rows) | DATA_OP | ro["CODE"] | ro["UI_PARAM"] | 행/컬럼 값 대입 |  |  |  |
| AC-bf1998f6 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:495 | if (dtCategoryColorInfo != null) ▸ foreach (DataRow ro in dtCategoryColorInfo.Rows) | DATA_OP | ro["NAME"] | ro["UI_DESC"] | 행/컬럼 값 대입 |  |  |  |
| AC-bd619c7b | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:500 |  | LIST_REBIND | clsCtrl.setListBox | (dtCategoryColorInfo, clbCategory, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-478ca622 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:502 |  | STATE_RESET | dictCateColor.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-dd840f75 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:504 |  | DATA_OP | dictCateColor["Default"] | MemoService.DefaultCateColor | 행/컬럼 값 대입 |  |  |  |
| AC-7a9fe09a | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:513 | for (i < dtCategoryColorInfo.Rows.Count) ▸ try ▸ if (!string.IsNullOrWhiteSpace(coltxt)) | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (coltxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f27fdc2 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:519 | for (i < dtCategoryColorInfo.Rows.Count) | DATA_OP | dictCateColor[key] | color2 | 행/컬럼 값 대입 |  |  |  |

## FPC0121_AlarmEditPopup.RefreshColorCombo

진입점: this.Load [if (SrcRow != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70f233ee | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:592 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_SetupColor_P", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b0c65db9 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:593 |  | FLAG | dtEtcColorInfo | colorInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-f51af3e1 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:601 |  | LIST_CLEAR | cboColorBox.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-16763174 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:604 | for (i < dtEtcColorInfo.Rows.Count) | DATA_OP | cboColorBox.Items.Add | (dtEtcColorInfo.Rows[i]["UI_DESC"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-578559c7 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:608 |  | STATE_RESET | dictColor.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-625a95f5 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:616 | for (i < dtEtcColorInfo.Rows.Count) ▸ try | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (coltxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1d3c5d1b | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:621 | for (i < dtEtcColorInfo.Rows.Count) | DATA_OP | dictColor[key] | color2 | 행/컬럼 값 대입 |  |  |  |

## FPC0121_AlarmEditPopup.SelectCateCombo

진입점: this.Load [if (SrcRow != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b4cda49 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:545 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) | DATA_OP | color_infos.Contains | (value) | 데이터 객체 조작/조회 |  |  |  |
| AC-623960c7 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:547 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) ▸ if (color_infos.Contains(v… | CALL_EXT | clbCategory.SetItemChecked | (idx, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4148be0d | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:548 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) ▸ if (color_infos.Contains(v… | DATA_OP | name.ToUpper().Contains | ("MODEL CHANGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6aac2ca2 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:556 | if (dtCategoryColorInfo.Good()) | CALL_EXT | clbCategory.CboReset | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b74eef2 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:559 | if (dtCategoryColorInfo.Good()) ▸ if (ModelChangeSelected == false) | VALUE_CLEAR | cboColorBox.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-6ff098d6 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:560 | if (dtCategoryColorInfo.Good()) ▸ if (ModelChangeSelected == false) | STATE | cboColorBox.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-62a6d1c4 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:564 | if (dtCategoryColorInfo.Good()) ▸ else of (ModelChangeSelected == false) | STATE | cboColorBox.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FPC0121_AlarmEditPopup.SelectColorCombo

진입점: this.Load [if (SrcRow != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f324b072 | this.Load [if (SrcRow != null)] | FPC0121_AlarmEditPopup.cs:634 | if (dtEtcColorInfo.Rows.Count != 0) ▸ for (i < dtEtcColorInfo.Rows.Count) ▸ if (dtEtcColorInfo.Rows[i]["UI_PARAM"].ToString().ToUpper() == a… | VALUE_SET | cboColorBox.SelectedIndex | i | 컨트롤 값 설정 |  |  |  |

## FPC0121_AlarmEditPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbccfffe | this.spdMain.CellClick | FPC0121_AlarmEditPopup.cs:822 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0121_AlarmEditPopup.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fc332dc | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:940 | if (this.IsEditMode != true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2e71b3e9 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:942 | if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.RowsAdded) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6163e2c7 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:955 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ed930d89 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:960 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (cRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7795311f | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:967 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) | DATA_OP | param["USER_ID"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-520840ce | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:972 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | POPUP | new FP00602_UserFindPopup | () | 팝업/폼 생성 |  |  |  |
| AC-aaca8074 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:973 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | UI_PROP | UserPopup._UserId | user_id | 속성 _UserId 설정 |  |  |  |
| AC-d52b7819 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:975 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | UI_PROP | UserPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-611a5e01 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:976 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | UI_PROP | UserPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-786194b6 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:979 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | POPUP | UserPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-93252d78 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:988 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 3].Value | user_name | 그리드 속성/값 설정 |  |  |  |
| AC-3e7f9322 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:989 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 2].Value | dept_name | 그리드 속성/값 설정 |  |  |  |
| AC-4d90bc84 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:990 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | DATA_OP | dept_name.ToUpper().Contains | ("LG CNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-374a7272 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:990 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | DATA_OP | dept_name.ToUpper().Contains | ("LGCNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-0596fb50 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:991 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | DATA_OP | dept_name.ToUpper().Contains | ("DEV") | 데이터 객체 조작/조회 |  |  |  |
| AC-442921e0 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:993 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) ▸ i… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgespartner.com" | 그리드 속성/값 설정 |  |  |  |
| AC-7415c4fc | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:997 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) ▸ e… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgensol.com" | 그리드 속성/값 설정 |  |  |  |
| AC-b0e2f73d | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1003 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ else of (UserPopup.ShowDialog() == DialogResult.OK… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c3c576c4 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1011 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "get_userinfo", param.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_userinfo] \| FP\Common\PICA… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-89b7a1e0 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1015 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ catch () | MESSAGE | MessageBox.Show | ("Cannot find user") | 메시지 표시 |  |  |  |
| AC-41095ae0 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1016 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-652f306b | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1025 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 3].Value | user_name = dsUser.Rows[0]["UserName"].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-3149fe13 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1026 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 2].Value | dept_name = dsUser.Rows[0]["Dept_Name"].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-3b533b12 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1027 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) | DATA_OP | dept_name.ToUpper().Contains | ("LG CNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-bdfe496f | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1027 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) | DATA_OP | dept_name.ToUpper().Contains | ("LGCNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-037b3bfe | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1029 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) ▸ if (dept_name.ToUpper().… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgespartner.com" | 그리드 속성/값 설정 |  |  |  |
| AC-98c5d2bc | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1033 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) ▸ else of (dept_name.ToUpp… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgensol.com" | 그리드 속성/값 설정 |  |  |  |
| AC-8ad62f9a | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1041 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 1].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-b8b195fe | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1042 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 2].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-b88e6cd0 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1043 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 3].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-ea3036e8 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1044 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-84e62de9 | dsdmMain.Changed | FPC0121_AlarmEditPopup.cs:1045 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 5].Value | "" | 그리드 속성/값 설정 |  |  |  |

## FPC0121_AlarmEditPopup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c51adb27 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1194 |  | POPUP | new FPC0112_AlarmPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b7a540e6 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1195 |  | UI_PROP | memoPopup.IsRef | true | 속성 IsRef 설정 |  |  |  |
| AC-382c0cbe | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1196 |  | UI_PROP | memoPopup.CanSave | false | 속성 CanSave 설정 |  |  |  |
| AC-fa69b927 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1197 |  | VALUE_SET | memoPopup.Text | "Alarm / Memo" | 컨트롤 값 설정 |  |  |  |
| AC-d91fa2b4 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1198 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-24a6089a | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1198 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4e0ce3d1 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1199 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | DateTime.Now.AddDays(-8).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-92ea164b | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1200 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | DateTime.Now.AddDays(8).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-8a830bc5 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1203 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1b0568ca | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1205 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6145d61a | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1206 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ca7023f3 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1207 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f180fa7b | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1208 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4f8d4452 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1209 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8cf12eb1 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1210 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b1dfcb07 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1212 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e246f97f | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1213 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-1875c735 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1214 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-8e12f74d | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1215 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2e1ba69b | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1229 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) | DATA_OP | Filter["PIC_REF"] | pic_ref | 행/컬럼 값 대입 |  |  |  |
| AC-7c92f8e3 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1230 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) | ENDPOINT | DataService.FP_ExecuteQuery | ("PICAlarm", "find_alarm", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] \| FP\Common\PICAla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8addaa5c | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1240 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | userids.Contains | (auser) | 데이터 객체 조작/조회 |  |  |  |
| AC-58f93d2c | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1242 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | userids.Add | (auser) | 데이터 객체 조작/조회 |  |  |  |
| AC-a577be3c | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1243 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | username.Add | (aname) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7651963 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1244 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | team.Add | (ateam) | 데이터 객체 조작/조회 |  |  |  |
| AC-37d2db29 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1245 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | mail.Add | (amail) | 데이터 객체 조작/조회 |  |  |  |
| AC-33d3f60e | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1246 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | phone.Add | (aphone) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1d69919 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1286 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | CALL_EXT | siMain.AddRows | (row_index, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9cc4b209 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1295 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.USER_ID, userid) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fabbe9c | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1296 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.TEAM_NAME, adeptname) | 데이터 객체 조작/조회 |  |  |  |
| AC-aca12548 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1298 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.USER_NAME, ausername) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e00f0e2 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1299 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.EMAIL, email) | 데이터 객체 조작/조회 |  |  |  |
| AC-327c3060 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1300 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.PHONE, aphone) | 데이터 객체 조작/조회 |  |  |  |
| AC-e03fa106 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1302 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-f9ee7c13 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1304 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b2abda86 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1306 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.USER_ID), row_index, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-46434008 | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1307 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.TEAM_NAME), row_index, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d624fd0e | this.usrButton2.Click | FPC0121_AlarmEditPopup.cs:1308 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.PHONE), row_index, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |

## FPC0121_AlarmEditPopup.usrButton4_Click

진입점: this.btnInsert.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-871971b9 | this.btnInsert.Click | FPC0121_AlarmEditPopup.cs:1188 | if (rowindex >= 0) | CALL_EXT | siMain.ActiveSheet.RemoveRows | (rowindex, 1) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0121_AlarmEditPopup.usrButton5_Click

진입점: this.btnDelete.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73d03022 | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:875 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | new FP00602_UserFindPopup | () | 팝업/폼 생성 |  |  |  |
| AC-923ac9a5 | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:877 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | UserPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-0ae1efdd | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:878 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | UserPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-9d6a92e3 | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:882 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | UserPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3d07dcfe | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:891 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (UserPopup.ShowDialog(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca14a9f1 | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:898 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.AddRows | (row_index, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d74a79f1 | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:907 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.USER_ID, user_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc11644d | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:908 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.TEAM_NAME, team_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-54255437 | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:910 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | team_name.ToUpper().Contains | ("LG CNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-f7c17945 | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:910 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | team_name.ToUpper().Contains | ("LGCNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-ebf0d70c | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:916 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.USER_NAME, user_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c4219b2 | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:917 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.EMAIL, email) | 데이터 객체 조작/조회 |  |  |  |
| AC-579db081 | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:918 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.PHONE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ed23dbc | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:920 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-d1cf7dd3 | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:922 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab29f281 | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:924 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.USER_ID), row_index, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-240b8051 | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:925 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.TEAM_NAME), row_index, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c56b88ce | this.btnDelete.Click | FPC0121_AlarmEditPopup.cs:926 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.PHONE), row_index, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |


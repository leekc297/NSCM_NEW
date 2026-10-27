# AS-IS 액션 대조표 — FPC0124

> 원천: `Doc/asisfacts/screens/FPC0124/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 137행 · 메서드 18 · 종류 DATA_OP 74 · CALL_EXT 15 · FLAG 11 · RETURN 9 · UI_MISC 4 · STATE 4 · ENDPOINT 3 · UI_PROP 3 · COMBO_DATA 3 · STATE_RESET 3 · MESSAGE 2 · VALUE_CLEAR 2 · VALUE_SET 2 · LIST_REBIND 1 · LIST_CLEAR 1 · ⚠ 의미 확인 필요 15


## FPC0124_CateColorEditPopup.btnClose_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69e6c6e3 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:439 | try | DATA_OP | Filter["BUCKET_FROM"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ac69d622 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:442 | try ▸ if (IsLine) | DATA_OP | Filter["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-9d21566b | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:443 | try ▸ if (IsLine) | DATA_OP | Filter["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-b32b6562 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:444 | try ▸ if (IsLine) | DATA_OP | Filter["TOP_ITEM_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-7bb3ca06 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:445 | try ▸ if (IsLine) | DATA_OP | Filter["ITEM_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-d6c7efa4 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:446 | try ▸ if (IsLine) | DATA_OP | Filter["PRODUCTION_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-721da472 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:447 | try ▸ if (IsLine) | DATA_OP | Filter["MARKET"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-53aa394b | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:449 | try | DATA_OP | Filter["BUCKET_TO"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e1e11781 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:450 | try | DATA_OP | Filter["MEMO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-59adb55f | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:451 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-77061f64 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:452 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "delete_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_memo] \| FP\Common\Am… | 엔드포인트 호출 |  |  |  |
| AC-6aa6a787 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:456 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Delete Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-9fe9b060 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:460 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-8e5e524a | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:461 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0124_CateColorEditPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ffd56df | this.btnSave.Click | FPC0124_CateColorEditPopup.cs:345 | try ▸ if (dtEtcColorInfo.Good()) | CALL_EXT | dtEtcColorInfo.findRow | ("UI_DESC", cboColorBox.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2efd471 | this.btnSave.Click | FPC0124_CateColorEditPopup.cs:374 | try | FLAG | ModelChange | Filter["ATTR1"] = getColorParam | 화면 필드/플래그 변경 |  |  |  |
| AC-3c2100d6 | this.btnSave.Click | FPC0124_CateColorEditPopup.cs:374 | try | DATA_OP | Filter["ATTR1"] | getColorParam | 행/컬럼 값 대입 |  |  |  |
| AC-05b17dfd | this.btnSave.Click | FPC0124_CateColorEditPopup.cs:375 | try | FLAG | Category | Filter["ATTR2"] = getCategoryParam | 화면 필드/플래그 변경 |  |  |  |
| AC-1b0801da | this.btnSave.Click | FPC0124_CateColorEditPopup.cs:375 | try | DATA_OP | Filter["ATTR2"] | getCategoryParam | 행/컬럼 값 대입 |  |  |  |
| AC-eff5cff5 | this.btnSave.Click | FPC0124_CateColorEditPopup.cs:376 | try | FLAG | ModelChangeText | Filter["ATTR1_TXT"] = getColorParamTxt | 화면 필드/플래그 변경 |  |  |  |
| AC-fbb95800 | this.btnSave.Click | FPC0124_CateColorEditPopup.cs:376 | try | DATA_OP | Filter["ATTR1_TXT"] | getColorParamTxt | 행/컬럼 값 대입 |  |  |  |
| AC-117134a0 | this.btnSave.Click | FPC0124_CateColorEditPopup.cs:377 | try | FLAG | CategoryText | Filter["ATTR2_TXT"] = getCategoryParamTxt | 화면 필드/플래그 변경 |  |  |  |
| AC-eb7000af | this.btnSave.Click | FPC0124_CateColorEditPopup.cs:377 | try | DATA_OP | Filter["ATTR2_TXT"] | getCategoryParamTxt | 행/컬럼 값 대입 |  |  |  |
| AC-b8a4fdf0 | this.btnSave.Click | FPC0124_CateColorEditPopup.cs:425 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Save Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-50e23ccd | this.btnSave.Click | FPC0124_CateColorEditPopup.cs:429 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-30c7423d | this.btnSave.Click | FPC0124_CateColorEditPopup.cs:430 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0124_CateColorEditPopup.cboCategory_DrawItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b628d452 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:499 | if (e.Index >= 0) | CALL_EXT | g.FillRectangle | (new SolidBrush(BackColor), rect) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5284c33 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:502 | if (e.Index >= 0) | CALL_EXT | g.DrawString | (n, f, Brushes.Black, rect.X, rect.Top) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1336e1e0 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:509 | if (e.Index >= 0) ▸ try ▸ if (dictCateColor != null && dictCateColor.Count > 0) | CALL_EXT | g.FillRectangle | (b, rect.X + 110, rect.Y + 3, rect.Width - 10, rect.Height - 3) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0124_CateColorEditPopup.cboColorBox_DrawItem

진입점: this.cboColorBox.DrawItem

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cb402ee | this.cboColorBox.DrawItem | FPC0124_CateColorEditPopup.cs:528 | if (e.Index >= 0) | CALL_EXT | g.FillRectangle | (new SolidBrush(BackColor), rect) | ⚠ 의미 확인 필요 |  |  |  |
| AC-97a64ff8 | this.cboColorBox.DrawItem | FPC0124_CateColorEditPopup.cs:531 | if (e.Index >= 0) | CALL_EXT | g.DrawString | (n, f, Brushes.Black, rect.X, rect.Top) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb0399b3 | this.cboColorBox.DrawItem | FPC0124_CateColorEditPopup.cs:538 | if (e.Index >= 0) ▸ try ▸ if (dictColor != null && dictColor.Count > 0) | CALL_EXT | g.FillRectangle | (b, rect.X + 110, rect.Y + 3, rect.Width - 10, rect.Height - 3) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0124_CateColorEditPopup.clbCategory_GetBackColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16540131 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:821 |  | RETURN | return Color.Red; |  | 처리 중단/반환 |  |  |  |

## FPC0124_CateColorEditPopup.clbCategory_GetFont

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16b63a60 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:810 |  | RETURN | return this.Font; |  | 처리 중단/반환 |  |  |  |

## FPC0124_CateColorEditPopup.clbCategory_GetForeColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73548248 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:815 |  | RETURN | return Color.Blue; |  | 처리 중단/반환 |  |  |  |

## FPC0124_CateColorEditPopup.clbCategory_GetRectangleColor

진입점: this.clbCategory.GetRectangleColor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-207ad87f | this.clbCategory.GetRectangleColor | FPC0124_CateColorEditPopup.cs:834 | if (e.Index >= 0) ▸ if (dtCategoryColorInfo.Good()) ▸ if (e.Index < dtCategoryColorInfo.Rows.Count) ▸ try | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (dtCategoryColorInfo.Rows[e.Index]["UI_COLOR"].SafeString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f85ec6f4 | this.clbCategory.GetRectangleColor | FPC0124_CateColorEditPopup.cs:835 | if (e.Index >= 0) ▸ if (dtCategoryColorInfo.Good()) ▸ if (e.Index < dtCategoryColorInfo.Rows.Count) ▸ try | RETURN | return color; |  | 처리 중단/반환 |  |  |  |
| AC-0b0d7e1a | this.clbCategory.GetRectangleColor | FPC0124_CateColorEditPopup.cs:839 | if (e.Index >= 0) ▸ if (dtCategoryColorInfo.Good()) ▸ if (e.Index < dtCategoryColorInfo.Rows.Count) ▸ catch () | RETURN | return MemoService.DefaultCateColor; |  | 처리 중단/반환 |  |  |  |
| AC-29b08961 | this.clbCategory.GetRectangleColor | FPC0124_CateColorEditPopup.cs:844 |  | RETURN | return MemoService.DefaultCateColor; |  | 처리 중단/반환 |  |  |  |

## FPC0124_CateColorEditPopup.ClbCategory_SelectedIndexChanged

진입점: clbCategory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1af12ff6 | clbCategory.SelectedIndexChanged | FPC0124_CateColorEditPopup.cs:249 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) | DATA_OP | color_infos.Contains | (value) | 데이터 객체 조작/조회 |  |  |  |
| AC-08c49f00 | clbCategory.SelectedIndexChanged | FPC0124_CateColorEditPopup.cs:251 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) ▸ if (color_infos.Contains(v… | CALL_EXT | clbCategory.SetItemChecked | (idx, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ebcef7c0 | clbCategory.SelectedIndexChanged | FPC0124_CateColorEditPopup.cs:252 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) ▸ if (color_infos.Contains(v… | DATA_OP | name.ToUpper().Contains | ("MODEL CHANGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d816fdc8 | clbCategory.SelectedIndexChanged | FPC0124_CateColorEditPopup.cs:260 | if (dtCategoryColorInfo.Good()) ▸ if (ModelChangeSelected) | STATE | cboColorBox.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0ea58da2 | clbCategory.SelectedIndexChanged | FPC0124_CateColorEditPopup.cs:265 | if (dtCategoryColorInfo.Good()) ▸ else of (ModelChangeSelected) | STATE | cboColorBox.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d04938c6 | clbCategory.SelectedIndexChanged | FPC0124_CateColorEditPopup.cs:266 | if (dtCategoryColorInfo.Good()) ▸ else of (ModelChangeSelected) | VALUE_CLEAR | cboColorBox.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |

## FPC0124_CateColorEditPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-715a3f70 | Dispose | FPC0124_CateColorEditPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0124_CateColorEditPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b6ccbc5 | this.Load | FPC0124_CateColorEditPopup.cs:139 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-fc90ed99 | this.Load | FPC0124_CateColorEditPopup.cs:141 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0124_CateColorEditPopup.GetCheckedListValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3421193e | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:287 | if (control == null) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-b98bd2b3 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:291 | if (dt == null \|\| string.IsNullOrEmpty(controlValues)) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-69a4d47c | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:300 | if (strValue.Equals("ALL")) ▸ for (i < dt.Rows.Count) | DATA_OP | ret.Add | (dt.Rows[i]["CODE"].SafeString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc050264 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:314 | else of (strValue.Equals("ALL")) ▸ if (splits != null && splits.Length > 0) ▸ for (i < splits.Length) | DATA_OP | ret.Add | (splits[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1153568 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:319 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FPC0124_CateColorEditPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f286fba7 | this.Load | FPC0124_CateColorEditPopup.cs:156 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-66f59dc0 | this.Load | FPC0124_CateColorEditPopup.cs:158 |  | UI_PROP | clbCategory.UserRvSearch | true | 속성 UserRvSearch 설정 |  |  |  |
| AC-6c51133a | this.Load | FPC0124_CateColorEditPopup.cs:162 |  | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a69e746 | this.Load | FPC0124_CateColorEditPopup.cs:175 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-91b68c90 | this.Load | FPC0124_CateColorEditPopup.cs:176 |  | FLAG | _instance_id | Filter["INSTANCE_ID"] | 화면 필드/플래그 변경 |  |  |  |
| AC-28b69924 | this.Load | FPC0124_CateColorEditPopup.cs:177 |  | DATA_OP | Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-24c54fe5 | this.Load | FPC0124_CateColorEditPopup.cs:190 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_CurColor", Filter["INSTANCE_ID"].ToString(), Filter["COMPANY_ID"].T… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9c7e8b53 | this.Load | FPC0124_CateColorEditPopup.cs:198 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_SetupColor_P", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ddb5aab3 | this.Load | FPC0124_CateColorEditPopup.cs:199 |  | FLAG | dtEtcColorInfo | colorInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-4b0ad22b | this.Load | FPC0124_CateColorEditPopup.cs:201 |  | STATE_RESET | dictColor.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-3410a43d | this.Load | FPC0124_CateColorEditPopup.cs:209 | for (i < dtEtcColorInfo.Rows.Count) ▸ try | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (coltxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-612d8870 | this.Load | FPC0124_CateColorEditPopup.cs:216 | for (i < dtEtcColorInfo.Rows.Count) | DATA_OP | dictColor[key] | color | 행/컬럼 값 대입 |  |  |  |
| AC-01b5ce5e | this.Load | FPC0124_CateColorEditPopup.cs:225 | if (dtMap.Rows.Count != 0) ▸ for (i < dtEtcColorInfo.Rows.Count) ▸ if (dtEtcColorInfo.Rows[i]["UI_PARAM"].ToString().ToUpper() == dtMap.Rows… | VALUE_SET | cboColorBox.SelectedIndex | i | 컨트롤 값 설정 |  |  |  |

## FPC0124_CateColorEditPopup.RefreshCateCombo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56779df0 | this.Load | FPC0124_CateColorEditPopup.cs:554 |  | FLAG | dtCategoryColorInfo | dtEtcColorInfo.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-e9d96dd5 | this.Load | FPC0124_CateColorEditPopup.cs:554 |  | DATA_OP | dtEtcColorInfo.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9499214a | this.Load | FPC0124_CateColorEditPopup.cs:555 |  | DATA_OP | dtCategoryColorInfo.Columns.SafeAdd | ("COLOR_A", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-78558622 | this.Load | FPC0124_CateColorEditPopup.cs:556 |  | DATA_OP | dtCategoryColorInfo.Columns.SafeAdd | ("COLOR_B", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5957d62f | this.Load | FPC0124_CateColorEditPopup.cs:558 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6513e48c | this.Load | FPC0124_CateColorEditPopup.cs:559 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4e2340da | this.Load | FPC0124_CateColorEditPopup.cs:561 |  | DATA_OP | coteInfo.Select | ("SEGMENT1 = 'ETC'") | 데이터 객체 조작/조회 |  |  |  |
| AC-d9c837a7 | this.Load | FPC0124_CateColorEditPopup.cs:564 | if (etcs.Length < 1) | DATA_OP | coteInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f11aed1 | this.Load | FPC0124_CateColorEditPopup.cs:568 | if (etcs.Length < 1) | DATA_OP | nn["LOOKUP_TYPE_CODE"] | "CAPA_UI_LOSS_TYPE_DEFINIT" | 행/컬럼 값 대입 |  |  |  |
| AC-918581ae | this.Load | FPC0124_CateColorEditPopup.cs:569 | if (etcs.Length < 1) | DATA_OP | nn["SEGMENT1"] | "Etc" | 행/컬럼 값 대입 |  |  |  |
| AC-088ef689 | this.Load | FPC0124_CateColorEditPopup.cs:570 | if (etcs.Length < 1) | DATA_OP | nn["SEGMENT2"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-ceb39d2f | this.Load | FPC0124_CateColorEditPopup.cs:571 | if (etcs.Length < 1) | DATA_OP | nn["SEGMENT3"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-4f37a4c8 | this.Load | FPC0124_CateColorEditPopup.cs:572 | if (etcs.Length < 1) | DATA_OP | nn["SEGMENT4"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-b9468154 | this.Load | FPC0124_CateColorEditPopup.cs:573 | if (etcs.Length < 1) | DATA_OP | nn["SEGMENT5"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-83181cf8 | this.Load | FPC0124_CateColorEditPopup.cs:574 | if (etcs.Length < 1) | DATA_OP | nn["SORT_ORDER"] | "900" | 행/컬럼 값 대입 |  |  |  |
| AC-9f75611b | this.Load | FPC0124_CateColorEditPopup.cs:575 | if (etcs.Length < 1) | DATA_OP | nn["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-893c2880 | this.Load | FPC0124_CateColorEditPopup.cs:576 | if (etcs.Length < 1) | DATA_OP | nn["VALUE_DESCRIPTION"] | "Etc" | 행/컬럼 값 대입 |  |  |  |
| AC-5a720cde | this.Load | FPC0124_CateColorEditPopup.cs:577 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE1"] | "No-Load" | 행/컬럼 값 대입 |  |  |  |
| AC-93ed1254 | this.Load | FPC0124_CateColorEditPopup.cs:578 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE2"] | "Etc" | 행/컬럼 값 대입 |  |  |  |
| AC-0c8c006c | this.Load | FPC0124_CateColorEditPopup.cs:579 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d06312a7 | this.Load | FPC0124_CateColorEditPopup.cs:580 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE4"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-60923053 | this.Load | FPC0124_CateColorEditPopup.cs:581 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-94aebdbf | this.Load | FPC0124_CateColorEditPopup.cs:582 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE6"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-06bc50ce | this.Load | FPC0124_CateColorEditPopup.cs:583 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE7"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-eaa5b16b | this.Load | FPC0124_CateColorEditPopup.cs:584 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE8"] | "60" | 행/컬럼 값 대입 |  |  |  |
| AC-4ec13bc3 | this.Load | FPC0124_CateColorEditPopup.cs:585 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE9"] | "Min" | 행/컬럼 값 대입 |  |  |  |
| AC-597fa2f8 | this.Load | FPC0124_CateColorEditPopup.cs:586 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE10"] | "#F1F1F1" | 행/컬럼 값 대입 |  |  |  |
| AC-7740e965 | this.Load | FPC0124_CateColorEditPopup.cs:587 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE11"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-87fb9dc2 | this.Load | FPC0124_CateColorEditPopup.cs:588 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE12"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-15475bb0 | this.Load | FPC0124_CateColorEditPopup.cs:589 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE13"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-273b6313 | this.Load | FPC0124_CateColorEditPopup.cs:590 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE14"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d54af13 | this.Load | FPC0124_CateColorEditPopup.cs:591 | if (etcs.Length < 1) | DATA_OP | nn["ATTRIBUTE15"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-df048290 | this.Load | FPC0124_CateColorEditPopup.cs:592 | if (etcs.Length < 1) | DATA_OP | nn["PLANT_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-06573058 | this.Load | FPC0124_CateColorEditPopup.cs:593 | if (etcs.Length < 1) | DATA_OP | coteInfo.Rows.Add | (nn) | 데이터 객체 조작/조회 |  |  |  |
| AC-11d89984 | this.Load | FPC0124_CateColorEditPopup.cs:599 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | dtCategoryColorInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6482392b | this.Load | FPC0124_CateColorEditPopup.cs:603 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["UI_PARAM"] | cate["SEGMENT1"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-d8710342 | this.Load | FPC0124_CateColorEditPopup.cs:604 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["UI_DESC"] | cate["ATTRIBUTE2"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-fca51580 | this.Load | FPC0124_CateColorEditPopup.cs:606 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["UI_COLOR"] | cate["ATTRIBUTE10"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-87a155b3 | this.Load | FPC0124_CateColorEditPopup.cs:607 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["COLOR_A"] | cate["ATTRIBUTE10"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-20f3c830 | this.Load | FPC0124_CateColorEditPopup.cs:608 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["COLOR_B"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4f4c9900 | this.Load | FPC0124_CateColorEditPopup.cs:609 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | dtCategoryColorInfo.Rows.Add | (nn) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f4feedc | this.Load | FPC0124_CateColorEditPopup.cs:610 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | cate["ATTRIBUTE2"].SafeString().ToUpper().Contains | ("MODEL CHANGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2102a2c7 | this.Load | FPC0124_CateColorEditPopup.cs:611 | foreach (DataRow cate in coteInfo.Rows) ▸ if (cate["ATTRIBUTE2"].SafeString().ToUpper().Contains("MODEL CHANGE")) | FLAG | ChangeModelCateKey | cate["SEGMENT1"].SafeString() | 화면 필드/플래그 변경 |  |  |  |
| AC-81baf17d | this.Load | FPC0124_CateColorEditPopup.cs:634 | foreach (DataRow arow in cateInstanceColorInfo.Rows) | DATA_OP | dtCategoryColorInfo.Select | ("UI_PARAM='" + key + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd94ed6f | this.Load | FPC0124_CateColorEditPopup.cs:640 | foreach (DataRow arow in cateInstanceColorInfo.Rows) ▸ if (ress.Length > 0) ▸ if (!string.IsNullOrWhiteSpace(colorv)) | DATA_OP | ress[0]["UI_COLOR"] | colorv | 행/컬럼 값 대입 |  |  |  |
| AC-b01d5120 | this.Load | FPC0124_CateColorEditPopup.cs:641 | foreach (DataRow arow in cateInstanceColorInfo.Rows) ▸ if (ress.Length > 0) ▸ if (!string.IsNullOrWhiteSpace(colorv)) | DATA_OP | ress[0]["COLOR_B"] | colorv | 행/컬럼 값 대입 |  |  |  |
| AC-bb2e3ea6 | this.Load | FPC0124_CateColorEditPopup.cs:658 | if (dtCategoryColorInfo != null) | DATA_OP | dtCategoryColorInfo.Columns.SafeAdd | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f7a22d4 | this.Load | FPC0124_CateColorEditPopup.cs:659 | if (dtCategoryColorInfo != null) | DATA_OP | dtCategoryColorInfo.Columns.SafeAdd | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-411d79a6 | this.Load | FPC0124_CateColorEditPopup.cs:662 | if (dtCategoryColorInfo != null) ▸ foreach (DataRow ro in dtCategoryColorInfo.Rows) | DATA_OP | ro["CODE"] | ro["UI_PARAM"] | 행/컬럼 값 대입 |  |  |  |
| AC-e2e37e18 | this.Load | FPC0124_CateColorEditPopup.cs:663 | if (dtCategoryColorInfo != null) ▸ foreach (DataRow ro in dtCategoryColorInfo.Rows) | DATA_OP | ro["NAME"] | ro["UI_DESC"] | 행/컬럼 값 대입 |  |  |  |
| AC-49b7fc8d | this.Load | FPC0124_CateColorEditPopup.cs:668 |  | LIST_REBIND | clsCtrl.setListBox | (dtCategoryColorInfo, clbCategory, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-30543323 | this.Load | FPC0124_CateColorEditPopup.cs:670 |  | STATE_RESET | dictCateColor.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1a544a23 | this.Load | FPC0124_CateColorEditPopup.cs:672 |  | DATA_OP | dictCateColor["Default"] | MemoService.DefaultCateColor | 행/컬럼 값 대입 |  |  |  |
| AC-442eaa40 | this.Load | FPC0124_CateColorEditPopup.cs:681 | for (i < dtCategoryColorInfo.Rows.Count) ▸ try ▸ if (!string.IsNullOrWhiteSpace(coltxt)) | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (coltxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ff0e123 | this.Load | FPC0124_CateColorEditPopup.cs:687 | for (i < dtCategoryColorInfo.Rows.Count) | DATA_OP | dictCateColor[key] | color2 | 행/컬럼 값 대입 |  |  |  |

## FPC0124_CateColorEditPopup.RefreshColorCombo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-498f70b5 | this.Load | FPC0124_CateColorEditPopup.cs:760 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_SetupColor_P", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e10e3284 | this.Load | FPC0124_CateColorEditPopup.cs:761 |  | FLAG | dtEtcColorInfo | colorInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-41336a19 | this.Load | FPC0124_CateColorEditPopup.cs:769 |  | LIST_CLEAR | cboColorBox.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-55a9ec39 | this.Load | FPC0124_CateColorEditPopup.cs:772 | for (i < dtEtcColorInfo.Rows.Count) | DATA_OP | cboColorBox.Items.Add | (dtEtcColorInfo.Rows[i]["UI_DESC"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-968e2541 | this.Load | FPC0124_CateColorEditPopup.cs:776 |  | STATE_RESET | dictColor.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-79d22c6b | this.Load | FPC0124_CateColorEditPopup.cs:784 | for (i < dtEtcColorInfo.Rows.Count) ▸ try | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (coltxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3773446 | this.Load | FPC0124_CateColorEditPopup.cs:789 | for (i < dtEtcColorInfo.Rows.Count) | DATA_OP | dictColor[key] | color2 | 행/컬럼 값 대입 |  |  |  |

## FPC0124_CateColorEditPopup.SelectCateCombo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-479ec7e5 | this.Load | FPC0124_CateColorEditPopup.cs:713 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) | DATA_OP | color_infos.Contains | (value) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b5c9714 | this.Load | FPC0124_CateColorEditPopup.cs:715 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) ▸ if (color_infos.Contains(v… | CALL_EXT | clbCategory.SetItemChecked | (idx, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c70c441 | this.Load | FPC0124_CateColorEditPopup.cs:716 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) ▸ if (color_infos.Contains(v… | DATA_OP | name.ToUpper().Contains | ("MODEL CHANGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-00607ee6 | this.Load | FPC0124_CateColorEditPopup.cs:724 | if (dtCategoryColorInfo.Good()) | CALL_EXT | clbCategory.CboReset | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8aed9650 | this.Load | FPC0124_CateColorEditPopup.cs:727 | if (dtCategoryColorInfo.Good()) ▸ if (ModelChangeSelected == false) | VALUE_CLEAR | cboColorBox.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-be074b02 | this.Load | FPC0124_CateColorEditPopup.cs:728 | if (dtCategoryColorInfo.Good()) ▸ if (ModelChangeSelected == false) | STATE | cboColorBox.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-48b903a0 | this.Load | FPC0124_CateColorEditPopup.cs:732 | if (dtCategoryColorInfo.Good()) ▸ else of (ModelChangeSelected == false) | STATE | cboColorBox.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FPC0124_CateColorEditPopup.SelectColorCombo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51f6750a | this.Load | FPC0124_CateColorEditPopup.cs:802 | if (dtEtcColorInfo.Rows.Count != 0) ▸ for (i < dtEtcColorInfo.Rows.Count) ▸ if (dtEtcColorInfo.Rows[i]["UI_PARAM"].ToString().ToUpper() == a… | VALUE_SET | cboColorBox.SelectedIndex | i | 컨트롤 값 설정 |  |  |  |

## FPC0124_CateColorEditPopup.SetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf559555 | (진입점 미연결) | FPC0124_CateColorEditPopup.cs:276 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |


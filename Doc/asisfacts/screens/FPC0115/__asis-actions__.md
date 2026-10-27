# AS-IS 액션 대조표 — FPC0115

> 원천: `Doc/asisfacts/screens/FPC0115/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 296행 · 메서드 24 · 종류 DATA_OP 133 · UI_PROP 24 · CALL_EXT 23 · VALUE_SET 17 · RETURN 16 · STATE 16 · FLAG 15 · ENDPOINT 13 · MESSAGE 9 · UI_MISC 7 · VALUE_CLEAR 5 · POPUP 4 · FOCUS 4 · COMBO_DATA 4 · STATE_RESET 3 · LIST_REBIND 2 · LIST_CLEAR 1 · ⚠ 의미 확인 필요 23


## FPC0115_MemoColorEditPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b798a8a4 | .ctor | FPC0115_MemoColorEditPopup.cs:131 |  | FLAG | SrcRow | row | 화면 필드/플래그 변경 |  |  |  |
| AC-df4e4b1c | .ctor | FPC0115_MemoColorEditPopup.cs:133 |  | FLAG | IsLine | isLine | 화면 필드/플래그 변경 |  |  |  |
| AC-08e84d5a | .ctor | FPC0115_MemoColorEditPopup.cs:135 |  | FLAG | Day | date | 화면 필드/플래그 변경 |  |  |  |
| AC-434b2de9 | .ctor | FPC0115_MemoColorEditPopup.cs:140 | if (IsLine) | VALUE_SET | this.Text | "Line Memo" | 컨트롤 값 설정 |  |  |  |
| AC-6cc28b06 | .ctor | FPC0115_MemoColorEditPopup.cs:142 | else of (IsLine) | VALUE_SET | this.Text | "Material Memo" | 컨트롤 값 설정 |  |  |  |

## FPC0115_MemoColorEditPopup.btnCateAdd_Click

진입점: this.btnCateAdd.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3b234e5 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:847 | foreach (DataRow row in dtCategoryColorInfo.Rows) ▸ if (ui_color_desc.ToUpper() == txtDelete.ToUpper()) | DATA_OP | Filter["setup_color_id"] | ui_param | 행/컬럼 값 대입 |  |  |  |
| AC-7708872b | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:858 |  | POPUP | new FPC0118_CateColorEditPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6c8c18d5 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:862 | if (string.IsNullOrWhiteSpace(paramName)) | UI_PROP | colorPopup.ParamName | "Etc" | 속성 ParamName 설정 |  |  |  |
| AC-a69f8975 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:863 | if (string.IsNullOrWhiteSpace(paramName)) | UI_PROP | colorPopup.IsDefault | false | 속성 IsDefault 설정 |  |  |  |
| AC-426776c4 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:867 | else of (string.IsNullOrWhiteSpace(paramName)) | UI_PROP | colorPopup.ParamName | paramName | 속성 ParamName 설정 |  |  |  |
| AC-000bd5d9 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:868 | else of (string.IsNullOrWhiteSpace(paramName)) | UI_PROP | colorPopup.IsDefault | isDefault | 속성 IsDefault 설정 |  |  |  |
| AC-17937874 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:870 |  | UI_PROP | colorPopup.ParamDesc | paramDesc | 속성 ParamDesc 설정 |  |  |  |
| AC-1e10f36f | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:871 |  | UI_PROP | colorPopup.ColorDesc | paramColor | 속성 ColorDesc 설정 |  |  |  |
| AC-8876dbea | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:872 |  | UI_PROP | colorPopup.UIDesc | uiDesc | 속성 UIDesc 설정 |  |  |  |
| AC-bd46983e | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:874 |  | UI_PROP | colorPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b3088e8c | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:875 |  | POPUP | colorPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9d75bf44 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:877 | if (colorPopup.ShowDialog() == DialogResult.OK) | DATA_OP | Filter["setup_color_id"] | colorPopup.ParamName | 행/컬럼 값 대입 |  |  |  |
| AC-7a542205 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:878 | if (colorPopup.ShowDialog() == DialogResult.OK) | DATA_OP | Filter["setup_color_name"] | colorPopup.ParamDesc | 행/컬럼 값 대입 |  |  |  |
| AC-0c6e1e07 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:879 | if (colorPopup.ShowDialog() == DialogResult.OK) | DATA_OP | Filter["color"] | colorPopup.ColorDesc | 행/컬럼 값 대입 |  |  |  |
| AC-e0ec6f93 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:880 | if (colorPopup.ShowDialog() == DialogResult.OK) | DATA_OP | Filter["ATTRIBUTE1"] | "ENG" | 행/컬럼 값 대입 |  |  |  |
| AC-c8f39e99 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:881 | if (colorPopup.ShowDialog() == DialogResult.OK) | DATA_OP | Filter["ATTRIBUTE2"] | colorPopup.ParamDesc | 행/컬럼 값 대입 |  |  |  |
| AC-72d69e12 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:886 | if (colorPopup.ShowDialog() == DialogResult.OK) ▸ if (isDefault) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "edit_cate_default_color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=edit_cate_default_color] \| FP\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9695bc74 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:890 | if (colorPopup.ShowDialog() == DialogResult.OK) ▸ else of (isDefault) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "get_cate_color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_cate_color] \| FP\Common\PI… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d32c14ea | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:893 | if (colorPopup.ShowDialog() == DialogResult.OK) ▸ else of (isDefault) ▸ if (r1.Good()) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "edit_cate_color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=edit_cate_color] \| FP\Common\P… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e59b4010 | this.btnCateAdd.Click | FPC0115_MemoColorEditPopup.cs:898 | if (colorPopup.ShowDialog() == DialogResult.OK) ▸ else of (isDefault) ▸ else of (r1.Good()) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "insert_cate_color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=insert_cate_color] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FPC0115_MemoColorEditPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48c8300b | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:671 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00407") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0a2ed6de | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:674 | if (MessageHelper.GMessageBox("MSG00407") == DialogResult.Cancel) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-83dcc454 | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:681 | try | DATA_OP | Filter["BUCKET_FROM"] | arrRetStart | 행/컬럼 값 대입 |  |  |  |
| AC-fa1f5032 | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:684 | try ▸ if (IsLine) | DATA_OP | Filter["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-6f2941a6 | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:685 | try ▸ if (IsLine) | DATA_OP | Filter["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-bcc935aa | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:686 | try ▸ if (IsLine) | DATA_OP | Filter["TOP_ITEM_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-935ec80b | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:687 | try ▸ if (IsLine) | DATA_OP | Filter["ITEM_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-e38608aa | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:688 | try ▸ if (IsLine) | DATA_OP | Filter["PRODUCTION_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-3ca3dd84 | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:689 | try ▸ if (IsLine) | DATA_OP | Filter["MARKET"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-32a0aa8d | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:691 | try | DATA_OP | Filter["BUCKET_TO"] | arrRetEnd | 행/컬럼 값 대입 |  |  |  |
| AC-e39c90ff | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:692 | try | DATA_OP | Filter["MEMO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d474f7f | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:693 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-da563b41 | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:694 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "delete_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_memo] \| FP\Common\Am… | 엔드포인트 호출 |  |  |  |
| AC-b9580032 | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:698 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Delete Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-4f977fbf | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:702 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-9f9541c8 | this.btnClose.Click | FPC0115_MemoColorEditPopup.cs:703 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0115_MemoColorEditPopup.btnColorAdd_Click

진입점: this.btnColorAdd.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d7f6f99 | this.btnColorAdd.Click | FPC0115_MemoColorEditPopup.cs:935 |  | POPUP | new FPC0117_ColorEditPopup | () | 팝업/폼 생성 |  |  |  |
| AC-51042103 | this.btnColorAdd.Click | FPC0115_MemoColorEditPopup.cs:937 |  | UI_PROP | colorPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b462efc9 | this.btnColorAdd.Click | FPC0115_MemoColorEditPopup.cs:938 |  | POPUP | colorPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-13a30efd | this.btnColorAdd.Click | FPC0115_MemoColorEditPopup.cs:943 | if (colorPopup.ShowDialog() == DialogResult.OK) | DATA_OP | Filter["setup_color_id"] | paramName | 행/컬럼 값 대입 |  |  |  |
| AC-5f23b5d6 | this.btnColorAdd.Click | FPC0115_MemoColorEditPopup.cs:944 | if (colorPopup.ShowDialog() == DialogResult.OK) | DATA_OP | Filter["setup_color_name"] | paramDesc | 행/컬럼 값 대입 |  |  |  |
| AC-3e69071b | this.btnColorAdd.Click | FPC0115_MemoColorEditPopup.cs:945 | if (colorPopup.ShowDialog() == DialogResult.OK) | DATA_OP | Filter["color"] | paramColor | 행/컬럼 값 대입 |  |  |  |
| AC-af32c67f | this.btnColorAdd.Click | FPC0115_MemoColorEditPopup.cs:946 | if (colorPopup.ShowDialog() == DialogResult.OK) | DATA_OP | Filter["ATTRIBUTE1"] | "ENG" | 행/컬럼 값 대입 |  |  |  |
| AC-4bfade6f | this.btnColorAdd.Click | FPC0115_MemoColorEditPopup.cs:947 | if (colorPopup.ShowDialog() == DialogResult.OK) | DATA_OP | Filter["ATTRIBUTE2"] | paramDesc | 행/컬럼 값 대입 |  |  |  |
| AC-e6b89dc8 | this.btnColorAdd.Click | FPC0115_MemoColorEditPopup.cs:949 | if (colorPopup.ShowDialog() == DialogResult.OK) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "insert_amend_color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=insert_amend_color] \| FP\Commo… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FPC0115_MemoColorEditPopup.btnColorDelete_Click

진입점: this.btnColorDelete.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49e8f1ac | this.btnColorDelete.Click | FPC0115_MemoColorEditPopup.cs:914 | if (cboColorBox.SelectedIndex < 0) | MESSAGE | MessageBox.Show | ("You must select an item to delete first") | 메시지 표시 |  |  |  |
| AC-d577a276 | this.btnColorDelete.Click | FPC0115_MemoColorEditPopup.cs:915 | if (cboColorBox.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-399d1516 | this.btnColorDelete.Click | FPC0115_MemoColorEditPopup.cs:925 | foreach (DataRow row in dtEtcColorInfo.Rows) ▸ if (ui_color_desc.ToUpper() == txtDelete.ToUpper()) | DATA_OP | Filter["setup_color_id"] | ui_param | 행/컬럼 값 대입 |  |  |  |
| AC-6323e8a5 | this.btnColorDelete.Click | FPC0115_MemoColorEditPopup.cs:927 | foreach (DataRow row in dtEtcColorInfo.Rows) ▸ if (ui_color_desc.ToUpper() == txtDelete.ToUpper()) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "delete_amend_color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=delete_amend_color] \| FP\Commo… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FPC0115_MemoColorEditPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f165fbd3 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:539 | if (string.IsNullOrWhiteSpace(memo)) | MESSAGE | MessageBox.Show | ("You need memo to save") | 메시지 표시 |  |  |  |
| AC-7e38d14c | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:540 | if (string.IsNullOrWhiteSpace(memo)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a28b3586 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:542 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00407") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-286009a1 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:545 | if (MessageHelper.GMessageBox("MSG00407") == DialogResult.Cancel) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b59b7484 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:559 | try | DATA_OP | Filter["BUCKET_FROM"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-9bdd7382 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:562 | try ▸ if (IsLine) | DATA_OP | Filter["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-ea2a7936 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:563 | try ▸ if (IsLine) | DATA_OP | Filter["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-a75fa6e7 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:564 | try ▸ if (IsLine) | DATA_OP | Filter["TOP_ITEM_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-2c286c13 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:565 | try ▸ if (IsLine) | DATA_OP | Filter["ITEM_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-cd8dc7e3 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:566 | try ▸ if (IsLine) | DATA_OP | Filter["PRODUCTION_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-d058a33f | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:567 | try ▸ if (IsLine) | DATA_OP | Filter["MARKET"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-2d82edcc | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:569 | try | DATA_OP | Filter["BUCKET_TO"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-01b2c4df | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:570 | try | DATA_OP | Filter["MEMO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-35c15686 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:571 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-31d74e0f | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:572 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "delete_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_memo] \| FP\Common\Am… | 엔드포인트 호출 |  |  |  |
| AC-dc946fae | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:575 | try | DATA_OP | Filter["BUCKET_FROM"] | Filter["PLAN_DATE"] = arrRetStart | 행/컬럼 값 대입 |  |  |  |
| AC-29002e05 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:575 | try | DATA_OP | Filter["PLAN_DATE"] | arrRetStart | 행/컬럼 값 대입 |  |  |  |
| AC-94dd7435 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:576 | try | DATA_OP | Filter["BUCKET_TO"] | arrRetEnd | 행/컬럼 값 대입 |  |  |  |
| AC-63f779e0 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:577 | try | DATA_OP | Filter["MEMO"] | txtMemo.Text | 행/컬럼 값 대입 |  |  |  |
| AC-6144f12f | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:578 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ef56d3af | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:579 | try | DATA_OP | Filter["INSTANCE_ID"] | _instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-57d45a77 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:584 | try ▸ if (dtEtcColorInfo.Good()) | CALL_EXT | dtEtcColorInfo.findRow | ("UI_DESC", cboColorBox.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce8dc30f | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:609 | try | DATA_OP | Filter["SETUP_COLOR_CODE"] | getColorParam | 행/컬럼 값 대입 |  |  |  |
| AC-96c8e473 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:610 | try | DATA_OP | Filter["ATTR1"] | getColorParam | 행/컬럼 값 대입 |  |  |  |
| AC-b748648f | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:611 | try | DATA_OP | Filter["ATTR2"] | getCategoryParam | 행/컬럼 값 대입 |  |  |  |
| AC-38acabe0 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:612 | try | DATA_OP | Filter["ATTR3"] | start | 행/컬럼 값 대입 |  |  |  |
| AC-9c808234 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:613 | try | DATA_OP | Filter["ATTR4"] | end | 행/컬럼 값 대입 |  |  |  |
| AC-02a6116e | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:614 | try | DATA_OP | Filter["ATTR5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-18f2b327 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:617 | try ▸ if (IsLine) | DATA_OP | Filter["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-88b1d222 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:618 | try ▸ if (IsLine) | DATA_OP | Filter["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-f4bbe650 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:619 | try ▸ if (IsLine) | DATA_OP | Filter["TOP_ITEM_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-9f4997a0 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:620 | try ▸ if (IsLine) | DATA_OP | Filter["ITEM_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-6505abed | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:621 | try ▸ if (IsLine) | DATA_OP | Filter["PRODUCTION_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-0febb9ae | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:622 | try ▸ if (IsLine) | DATA_OP | Filter["MARKET"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-48021a3d | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:629 | try ▸ foreach (string each_oper in val) | DATA_OP | Filter["OPERATION_ID"] | each_oper | 행/컬럼 값 대입 |  |  |  |
| AC-a8b62784 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:630 | try ▸ foreach (string each_oper in val) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("PICAlarm", "save_option_menu", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_option_menu] \| FP\Comm… | 엔드포인트 호출 |  |  |  |
| AC-31b0f668 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:635 | try | DATA_OP | Filter["OPERATION_ID"] | oldOperation | 행/컬럼 값 대입 |  |  |  |
| AC-a20b56d2 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:655 | try | CALL_EXT | Thread.Sleep | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-67345a50 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:659 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Save Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-196fd9cb | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:663 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-a79dcac1 | this.btnSave.Click | FPC0115_MemoColorEditPopup.cs:664 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0115_MemoColorEditPopup.cbAllDay_CheckedChanged

진입점: this.cbAllDay.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d626aab6 | this.cbAllDay.CheckedChanged | FPC0115_MemoColorEditPopup.cs:813 | if (cbAllDay.Checked) | VALUE_SET | tmStart.Value | DateTime.ParseExact("00:00", "HH:mmm", null) | 컨트롤 값 설정 |  |  |  |
| AC-973a430f | this.cbAllDay.CheckedChanged | FPC0115_MemoColorEditPopup.cs:814 | if (cbAllDay.Checked) | VALUE_SET | tmEnd.Value | DateTime.ParseExact("00:00", "HH:mmm", null) | 컨트롤 값 설정 |  |  |  |
| AC-88dd1f55 | this.cbAllDay.CheckedChanged | FPC0115_MemoColorEditPopup.cs:815 | if (cbAllDay.Checked) | STATE | tmStart.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-076e882e | this.cbAllDay.CheckedChanged | FPC0115_MemoColorEditPopup.cs:816 | if (cbAllDay.Checked) | STATE | tmEnd.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-73bbfc08 | this.cbAllDay.CheckedChanged | FPC0115_MemoColorEditPopup.cs:820 | else of (cbAllDay.Checked) | STATE | tmStart.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a3aef9ce | this.cbAllDay.CheckedChanged | FPC0115_MemoColorEditPopup.cs:821 | else of (cbAllDay.Checked) | STATE | tmEnd.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FPC0115_MemoColorEditPopup.cboCategory_DrawItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be691c0d | (진입점 미연결) | FPC0115_MemoColorEditPopup.cs:741 | if (e.Index >= 0) | CALL_EXT | g.FillRectangle | (new SolidBrush(BackColor), rect) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32ba5918 | (진입점 미연결) | FPC0115_MemoColorEditPopup.cs:744 | if (e.Index >= 0) | CALL_EXT | g.DrawString | (n, f, Brushes.Black, rect.X, rect.Top) | ⚠ 의미 확인 필요 |  |  |  |
| AC-66dd5bd6 | (진입점 미연결) | FPC0115_MemoColorEditPopup.cs:751 | if (e.Index >= 0) ▸ try ▸ if (dictCateColor != null && dictCateColor.Count > 0) | CALL_EXT | g.FillRectangle | (b, rect.X + 110, rect.Y + 3, rect.Width - 10, rect.Height - 3) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0115_MemoColorEditPopup.cboColorBox_DrawItem

진입점: this.cboColorBox.DrawItem

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11ba7a10 | this.cboColorBox.DrawItem | FPC0115_MemoColorEditPopup.cs:770 | if (e.Index >= 0) | CALL_EXT | g.FillRectangle | (new SolidBrush(BackColor), rect) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2409607d | this.cboColorBox.DrawItem | FPC0115_MemoColorEditPopup.cs:773 | if (e.Index >= 0) | CALL_EXT | g.DrawString | (n, f, Brushes.Black, rect.X, rect.Top) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f4e8847 | this.cboColorBox.DrawItem | FPC0115_MemoColorEditPopup.cs:780 | if (e.Index >= 0) ▸ try ▸ if (dictColor != null && dictColor.Count > 0) | CALL_EXT | g.FillRectangle | (b, rect.X + 110, rect.Y + 3, rect.Width - 10, rect.Height - 3) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0115_MemoColorEditPopup.clbCategory_GetBackColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd06ffb1 | (진입점 미연결) | FPC0115_MemoColorEditPopup.cs:1191 |  | RETURN | return Color.Red; |  | 처리 중단/반환 |  |  |  |

## FPC0115_MemoColorEditPopup.clbCategory_GetFont

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-481a0db7 | (진입점 미연결) | FPC0115_MemoColorEditPopup.cs:1180 |  | RETURN | return this.Font; |  | 처리 중단/반환 |  |  |  |

## FPC0115_MemoColorEditPopup.clbCategory_GetForeColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6afe225a | (진입점 미연결) | FPC0115_MemoColorEditPopup.cs:1185 |  | RETURN | return Color.Blue; |  | 처리 중단/반환 |  |  |  |

## FPC0115_MemoColorEditPopup.clbCategory_GetRectangleColor

진입점: this.clbCategory.GetRectangleColor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-535e0db3 | this.clbCategory.GetRectangleColor | FPC0115_MemoColorEditPopup.cs:1204 | if (e.Index >= 0) ▸ if (dtCategoryColorInfo.Good()) ▸ if (e.Index < dtCategoryColorInfo.Rows.Count) ▸ try | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (dtCategoryColorInfo.Rows[e.Index]["UI_COLOR"].SafeString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0cffcc7 | this.clbCategory.GetRectangleColor | FPC0115_MemoColorEditPopup.cs:1205 | if (e.Index >= 0) ▸ if (dtCategoryColorInfo.Good()) ▸ if (e.Index < dtCategoryColorInfo.Rows.Count) ▸ try | RETURN | return color; |  | 처리 중단/반환 |  |  |  |
| AC-50548d93 | this.clbCategory.GetRectangleColor | FPC0115_MemoColorEditPopup.cs:1209 | if (e.Index >= 0) ▸ if (dtCategoryColorInfo.Good()) ▸ if (e.Index < dtCategoryColorInfo.Rows.Count) ▸ catch () | RETURN | return MemoService.DefaultCateColor; |  | 처리 중단/반환 |  |  |  |
| AC-ac4b8ba2 | this.clbCategory.GetRectangleColor | FPC0115_MemoColorEditPopup.cs:1214 |  | RETURN | return MemoService.DefaultCateColor; |  | 처리 중단/반환 |  |  |  |

## FPC0115_MemoColorEditPopup.ClbCategory_SelectedIndexChanged

진입점: clbCategory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9274fdaf | clbCategory.SelectedIndexChanged | FPC0115_MemoColorEditPopup.cs:461 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) | DATA_OP | color_infos.Contains | (value) | 데이터 객체 조작/조회 |  |  |  |
| AC-872d35cc | clbCategory.SelectedIndexChanged | FPC0115_MemoColorEditPopup.cs:463 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) ▸ if (color_infos.Contains(v… | CALL_EXT | clbCategory.SetItemChecked | (idx, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2351dbc | clbCategory.SelectedIndexChanged | FPC0115_MemoColorEditPopup.cs:464 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) ▸ if (color_infos.Contains(v… | DATA_OP | name.ToUpper().Contains | ("MODEL CHANGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d776916 | clbCategory.SelectedIndexChanged | FPC0115_MemoColorEditPopup.cs:472 | if (dtCategoryColorInfo.Good()) ▸ if (ModelChangeSelected) | STATE | cboColorBox.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a18344eb | clbCategory.SelectedIndexChanged | FPC0115_MemoColorEditPopup.cs:477 | if (dtCategoryColorInfo.Good()) ▸ else of (ModelChangeSelected) | STATE | cboColorBox.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8756cfa1 | clbCategory.SelectedIndexChanged | FPC0115_MemoColorEditPopup.cs:478 | if (dtCategoryColorInfo.Good()) ▸ else of (ModelChangeSelected) | VALUE_CLEAR | cboColorBox.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |

## FPC0115_MemoColorEditPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8a37ac0 | Dispose | FPC0115_MemoColorEditPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0115_MemoColorEditPopup.drpPeriod_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93bb7b75 | drpPeriod.ValueChanged | FPC0115_MemoColorEditPopup.cs:799 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-558172af | drpPeriod.ValueChanged | FPC0115_MemoColorEditPopup.cs:803 | if (dayCount > 1) | VALUE_SET | cbAllDay.Checked | true | 컨트롤 값 설정 |  |  |  |

## FPC0115_MemoColorEditPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9cf9dd8 | this.Load | FPC0115_MemoColorEditPopup.cs:149 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f9b8f8ee | this.Load | FPC0115_MemoColorEditPopup.cs:151 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6faa4373 | this.Load | FPC0115_MemoColorEditPopup.cs:156 |  | FOCUS | txtMemo.Focus | () | 포커스 이동 |  |  |  |

## FPC0115_MemoColorEditPopup.GetCheckedListValues

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-089c7d6f | this.btnSave.Click [try] | FPC0115_MemoColorEditPopup.cs:499 | if (control == null) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-ef762031 | this.btnSave.Click [try] | FPC0115_MemoColorEditPopup.cs:503 | if (dt == null \|\| string.IsNullOrEmpty(controlValues)) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-f42ba19e | this.btnSave.Click [try] | FPC0115_MemoColorEditPopup.cs:512 | if (strValue.Equals("ALL")) ▸ for (i < dt.Rows.Count) | DATA_OP | ret.Add | (dt.Rows[i]["CODE"].SafeString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f6f7250 | this.btnSave.Click [try] | FPC0115_MemoColorEditPopup.cs:526 | else of (strValue.Equals("ALL")) ▸ if (splits != null && splits.Length > 0) ▸ for (i < splits.Length) | DATA_OP | ret.Add | (splits[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f1f5a76 | this.btnSave.Click [try] | FPC0115_MemoColorEditPopup.cs:531 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FPC0115_MemoColorEditPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfbdad33 | this.Load | FPC0115_MemoColorEditPopup.cs:169 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-146fa1ae | this.Load | FPC0115_MemoColorEditPopup.cs:172 |  | CALL_EXT | UserService.HasExtraRole | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf8096e3 | this.Load | FPC0115_MemoColorEditPopup.cs:174 | if (UserService.HasExtraRole(UserInfoContext.Current.UserId)) | UI_PROP | lcCateAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-066c6829 | this.Load | FPC0115_MemoColorEditPopup.cs:176 | if (UserService.HasExtraRole(UserInfoContext.Current.UserId)) | UI_PROP | lcColorAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6470088a | this.Load | FPC0115_MemoColorEditPopup.cs:177 | if (UserService.HasExtraRole(UserInfoContext.Current.UserId)) | UI_PROP | lcColorDelete.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ad8ca0a1 | this.Load | FPC0115_MemoColorEditPopup.cs:181 | else of (UserService.HasExtraRole(UserInfoContext.Current.UserId)) | UI_PROP | lcCateAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a06236f7 | this.Load | FPC0115_MemoColorEditPopup.cs:183 | else of (UserService.HasExtraRole(UserInfoContext.Current.UserId)) | UI_PROP | lcColorAdd.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7159e4b8 | this.Load | FPC0115_MemoColorEditPopup.cs:184 | else of (UserService.HasExtraRole(UserInfoContext.Current.UserId)) | UI_PROP | lcColorDelete.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5abfe1f0 | this.Load | FPC0115_MemoColorEditPopup.cs:186 |  | VALUE_SET | cbAllDay.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-7c3119ba | this.Load | FPC0115_MemoColorEditPopup.cs:187 |  | UI_PROP | clbOperation.UserRvSearch | true | 속성 UserRvSearch 설정 |  |  |  |
| AC-288fcb07 | this.Load | FPC0115_MemoColorEditPopup.cs:188 |  | UI_PROP | clbCategory.UserRvSearch | true | 속성 UserRvSearch 설정 |  |  |  |
| AC-0fe4610b | this.Load | FPC0115_MemoColorEditPopup.cs:189 |  | UI_PROP | clbCategory.NoneString | "None" | 속성 NoneString 설정 |  |  |  |
| AC-a06bd0cf | this.Load | FPC0115_MemoColorEditPopup.cs:190 |  | FOCUS | txtMemo.Focus | () | 포커스 이동 |  |  |  |
| AC-e62b4a51 | this.Load | FPC0115_MemoColorEditPopup.cs:191 |  | UI_PROP | this.tmStart.CustomFormat | this.tmEnd.CustomFormat = "HH:mmm" | 속성 CustomFormat 설정 |  |  |  |
| AC-d09ac1d0 | this.Load | FPC0115_MemoColorEditPopup.cs:191 |  | UI_PROP | this.tmEnd.CustomFormat | "HH:mmm" | 속성 CustomFormat 설정 |  |  |  |
| AC-6621f6d3 | this.Load | FPC0115_MemoColorEditPopup.cs:192 |  | VALUE_SET | tmStart.Value | DateTime.ParseExact("00:00", "HH:mmm", null) | 컨트롤 값 설정 |  |  |  |
| AC-1e4e52a9 | this.Load | FPC0115_MemoColorEditPopup.cs:193 |  | VALUE_SET | tmEnd.Value | DateTime.ParseExact("00:00", "HH:mmm", null) | 컨트롤 값 설정 |  |  |  |
| AC-9ee00a5b | this.Load | FPC0115_MemoColorEditPopup.cs:194 |  | UI_PROP | this.drpPeriod.Value1 | this.drpPeriod.Value2 = Day.Date | 속성 Value1 설정 |  |  |  |
| AC-48140be9 | this.Load | FPC0115_MemoColorEditPopup.cs:194 |  | UI_PROP | this.drpPeriod.Value2 | Day.Date | 속성 Value2 설정 |  |  |  |
| AC-4fa2d50c | this.Load | FPC0115_MemoColorEditPopup.cs:196 |  | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-47882df3 | this.Load | FPC0115_MemoColorEditPopup.cs:199 | if (UserInfoContext.Current != null && UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | txtMemo.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-35f39440 | this.Load | FPC0115_MemoColorEditPopup.cs:200 | if (UserInfoContext.Current != null && UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | txtMemo.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7012a391 | this.Load | FPC0115_MemoColorEditPopup.cs:201 | if (UserInfoContext.Current != null && UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8dcbf3fe | this.Load | FPC0115_MemoColorEditPopup.cs:202 | if (UserInfoContext.Current != null && UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fd6d9f1e | this.Load | FPC0115_MemoColorEditPopup.cs:207 | else of (UserInfoContext.Current != null && UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | txtMemo.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-ad151bcd | this.Load | FPC0115_MemoColorEditPopup.cs:208 | else of (UserInfoContext.Current != null && UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | txtMemo.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-98cc5147 | this.Load | FPC0115_MemoColorEditPopup.cs:209 | else of (UserInfoContext.Current != null && UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e9f97c49 | this.Load | FPC0115_MemoColorEditPopup.cs:210 | else of (UserInfoContext.Current != null && UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-80c4b1b3 | this.Load | FPC0115_MemoColorEditPopup.cs:214 | if (SrcRow != null) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6ec4d657 | this.Load | FPC0115_MemoColorEditPopup.cs:215 | if (SrcRow != null) | DATA_OP | Filter["INSTANCE_ID"] | _instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-f4b3e1e9 | this.Load | FPC0115_MemoColorEditPopup.cs:216 | if (SrcRow != null) | DATA_OP | Filter["COMPANY_ID"] | SrcRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3583b6c6 | this.Load | FPC0115_MemoColorEditPopup.cs:217 | if (SrcRow != null) | DATA_OP | Filter["DIVISION_ID"] | SrcRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0fcb8cfd | this.Load | FPC0115_MemoColorEditPopup.cs:218 | if (SrcRow != null) | DATA_OP | Filter["SITE_ID"] | SrcRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e4d8ee13 | this.Load | FPC0115_MemoColorEditPopup.cs:219 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6cd09608 | this.Load | FPC0115_MemoColorEditPopup.cs:220 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("LINE_ID")) | DATA_OP | Filter["LINE_ID"] | SrcRow["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ca619ba | this.Load | FPC0115_MemoColorEditPopup.cs:224 | if (SrcRow != null) ▸ if (line == "" \|\| line == "-") | MESSAGE | MessageBox.Show | ("Selected row has no line information. Please check and try again.") | 메시지 표시 |  |  |  |
| AC-1888d90f | this.Load | FPC0115_MemoColorEditPopup.cs:225 | if (SrcRow != null) ▸ if (line == "" \|\| line == "-") | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |
| AC-9be1f805 | this.Load | FPC0115_MemoColorEditPopup.cs:226 | if (SrcRow != null) ▸ if (line == "" \|\| line == "-") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b09893e1 | this.Load | FPC0115_MemoColorEditPopup.cs:230 | if (SrcRow != null) | DATA_OP | Filter["PLANT_ID"] | SrcRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fc55169f | this.Load | FPC0115_MemoColorEditPopup.cs:231 | if (SrcRow != null) | DATA_OP | Filter["FACTORY_ID"] | SrcRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b82067ec | this.Load | FPC0115_MemoColorEditPopup.cs:232 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-acecb4d4 | this.Load | FPC0115_MemoColorEditPopup.cs:233 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("OPERATION_ID")) | DATA_OP | Filter["OPERATION_ID"] | SrcRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b4778a37 | this.Load | FPC0115_MemoColorEditPopup.cs:235 | if (SrcRow != null) ▸ else of (SrcRow.Table.Columns.Contains("OPERATION_ID")) | DATA_OP | Filter["OPERATION_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-cf1d2a4e | this.Load | FPC0115_MemoColorEditPopup.cs:236 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-615b243a | this.Load | FPC0115_MemoColorEditPopup.cs:237 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("TOP_ITEM_ID")) | DATA_OP | Filter["TOP_ITEM_ID"] | SrcRow["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9ba98785 | this.Load | FPC0115_MemoColorEditPopup.cs:239 | if (SrcRow != null) ▸ else of (SrcRow.Table.Columns.Contains("TOP_ITEM_ID")) | DATA_OP | Filter["TOP_ITEM_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-8beeed4e | this.Load | FPC0115_MemoColorEditPopup.cs:240 | if (SrcRow != null) | DATA_OP | Filter["PRODUCTION_TYPE"] | SrcRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8c87adef | this.Load | FPC0115_MemoColorEditPopup.cs:241 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-022f0ba1 | this.Load | FPC0115_MemoColorEditPopup.cs:242 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("MARKET")) | DATA_OP | Filter["MARKET"] | SrcRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-04a7a2fa | this.Load | FPC0115_MemoColorEditPopup.cs:244 | if (SrcRow != null) ▸ else of (SrcRow.Table.Columns.Contains("MARKET")) | DATA_OP | Filter["MARKET"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-615eefeb | this.Load | FPC0115_MemoColorEditPopup.cs:245 | if (SrcRow != null) | DATA_OP | Filter["PLAN_DATE"] | Day.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-34927006 | this.Load | FPC0115_MemoColorEditPopup.cs:246 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-10f690ef | this.Load | FPC0115_MemoColorEditPopup.cs:247 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | SrcRow["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3566219b | this.Load | FPC0115_MemoColorEditPopup.cs:249 | if (SrcRow != null) ▸ else of (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-32a54268 | this.Load | FPC0115_MemoColorEditPopup.cs:250 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef058141 | this.Load | FPC0115_MemoColorEditPopup.cs:251 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("ELECTRODE_TYPE")) | DATA_OP | Filter["ELECTRODE_TYPE"] | SrcRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-29b9ad74 | this.Load | FPC0115_MemoColorEditPopup.cs:253 | if (SrcRow != null) ▸ else of (SrcRow.Table.Columns.Contains("ELECTRODE_TYPE")) | DATA_OP | Filter["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-0a9f8cf8 | this.Load | FPC0115_MemoColorEditPopup.cs:254 | if (SrcRow != null) | DATA_OP | Filter["ITEM_ID"] | SrcRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cc491f3b | this.Load | FPC0115_MemoColorEditPopup.cs:255 | if (SrcRow != null) | DATA_OP | Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-5040eb93 | this.Load | FPC0115_MemoColorEditPopup.cs:256 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_FROM"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bad8ea7a | this.Load | FPC0115_MemoColorEditPopup.cs:257 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_TO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fdabb5b5 | this.Load | FPC0115_MemoColorEditPopup.cs:271 | if (SrcRow != null) ▸ if (IsLine) | DATA_OP | Filter["ITEM_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-aa1c5ab4 | this.Load | FPC0115_MemoColorEditPopup.cs:272 | if (SrcRow != null) ▸ if (IsLine) | DATA_OP | Filter["TOP_ITEM_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-5fad1bb5 | this.Load | FPC0115_MemoColorEditPopup.cs:273 | if (SrcRow != null) ▸ if (IsLine) | DATA_OP | Filter["PRODUCTION_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-3f48ab98 | this.Load | FPC0115_MemoColorEditPopup.cs:274 | if (SrcRow != null) ▸ if (IsLine) | DATA_OP | Filter["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-20a0d1f6 | this.Load | FPC0115_MemoColorEditPopup.cs:275 | if (SrcRow != null) ▸ if (IsLine) | DATA_OP | Filter["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-0a2325c7 | this.Load | FPC0115_MemoColorEditPopup.cs:276 | if (SrcRow != null) ▸ if (IsLine) | DATA_OP | Filter["MARKET"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-01fca879 | this.Load | FPC0115_MemoColorEditPopup.cs:277 | if (SrcRow != null) ▸ if (IsLine) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "find_memo_line_type", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo_line_type] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1617a003 | this.Load | FPC0115_MemoColorEditPopup.cs:281 | if (SrcRow != null) ▸ else of (IsLine) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "find_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5523515b | this.Load | FPC0115_MemoColorEditPopup.cs:285 | if (SrcRow != null) ▸ if (memoInfo.Good()) | FLAG | MemoRow | memoInfo.Tables[0].Rows[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-e8d4ba25 | this.Load | FPC0115_MemoColorEditPopup.cs:291 | if (SrcRow != null) ▸ if (MemoRow != null) | DATA_OP | memoInfo.Tables[0].Columns.Contains | ("ATTR1") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c007779 | this.Load | FPC0115_MemoColorEditPopup.cs:293 | if (SrcRow != null) ▸ if (MemoRow != null) | DATA_OP | memoInfo.Tables[0].Columns.Contains | ("ATTR2") | 데이터 객체 조작/조회 |  |  |  |
| AC-14cf9d09 | this.Load | FPC0115_MemoColorEditPopup.cs:295 | if (SrcRow != null) ▸ if (MemoRow != null) | DATA_OP | memoInfo.Tables[0].Columns.Contains | ("ATTR3") | 데이터 객체 조작/조회 |  |  |  |
| AC-92e8fcd2 | this.Load | FPC0115_MemoColorEditPopup.cs:297 | if (SrcRow != null) ▸ if (MemoRow != null) | DATA_OP | memoInfo.Tables[0].Columns.Contains | ("ATTR4") | 데이터 객체 조작/조회 |  |  |  |
| AC-b42fdefd | this.Load | FPC0115_MemoColorEditPopup.cs:300 | if (SrcRow != null) ▸ if (MemoRow != null) | FLAG | memo_user | MemoRow["CREATOR"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-50dcd902 | this.Load | FPC0115_MemoColorEditPopup.cs:301 | if (SrcRow != null) ▸ if (MemoRow != null) | FLAG | memo_date | MemoRow["CREATION"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-988584f2 | this.Load | FPC0115_MemoColorEditPopup.cs:302 | if (SrcRow != null) ▸ if (MemoRow != null) | FLAG | memo | MemoRow["MEMO"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cf9e1f8f | this.Load | FPC0115_MemoColorEditPopup.cs:303 | if (SrcRow != null) ▸ if (MemoRow != null) | FLAG | bucket_from | MemoRow["BUCKET_FROM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d6e8260e | this.Load | FPC0115_MemoColorEditPopup.cs:304 | if (SrcRow != null) ▸ if (MemoRow != null) | FLAG | bucket_to | MemoRow["BUCKET_TO"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1b1d785d | this.Load | FPC0115_MemoColorEditPopup.cs:308 | if (SrcRow != null) ▸ if (MemoRow != null) ▸ if (attr3_start_time == "00:00" && attr4_end_time == "00:00") | VALUE_SET | cbAllDay.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-54e8972b | this.Load | FPC0115_MemoColorEditPopup.cs:313 | if (SrcRow != null) ▸ if (MemoRow != null) ▸ else of (attr3_start_time == "00:00" && attr4_end_time == "00:00") | CALL_EXT | DateTime.TryParseExact | (attr3_start_time, "HH:mmm", enUS, System.Globalization.DateTimeStyles.None, out dt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-51489043 | this.Load | FPC0115_MemoColorEditPopup.cs:315 | if (SrcRow != null) ▸ if (MemoRow != null) ▸ else of (attr3_start_time == "00:00" && attr4_end_time == "00:00") ▸ if (DateTime.TryParseExact… | VALUE_SET | tmStart.Value | dt | 컨트롤 값 설정 |  |  |  |
| AC-214372b4 | this.Load | FPC0115_MemoColorEditPopup.cs:317 | if (SrcRow != null) ▸ if (MemoRow != null) ▸ else of (attr3_start_time == "00:00" && attr4_end_time == "00:00") | CALL_EXT | DateTime.TryParseExact | (attr4_end_time, "HH:mmm", enUS, System.Globalization.DateTimeStyles.None, out dt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d2ebb37 | this.Load | FPC0115_MemoColorEditPopup.cs:319 | if (SrcRow != null) ▸ if (MemoRow != null) ▸ else of (attr3_start_time == "00:00" && attr4_end_time == "00:00") ▸ if (DateTime.TryParseExact… | VALUE_SET | tmEnd.Value | dt | 컨트롤 값 설정 |  |  |  |
| AC-c7614d38 | this.Load | FPC0115_MemoColorEditPopup.cs:321 | if (SrcRow != null) ▸ if (MemoRow != null) ▸ else of (attr3_start_time == "00:00" && attr4_end_time == "00:00") | VALUE_SET | cbAllDay.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-5183f1b8 | this.Load | FPC0115_MemoColorEditPopup.cs:324 | if (SrcRow != null) ▸ if (MemoRow != null) | VALUE_SET | txtCreator.Text | memo_user | 컨트롤 값 설정 |  |  |  |
| AC-4fa26b60 | this.Load | FPC0115_MemoColorEditPopup.cs:325 | if (SrcRow != null) ▸ if (MemoRow != null) | VALUE_SET | txtCreation.Text | memo_date | 컨트롤 값 설정 |  |  |  |
| AC-d9c9dab2 | this.Load | FPC0115_MemoColorEditPopup.cs:326 | if (SrcRow != null) ▸ if (MemoRow != null) | VALUE_SET | txtMemo.Text | memo | 컨트롤 값 설정 |  |  |  |
| AC-e5b3a2d1 | this.Load | FPC0115_MemoColorEditPopup.cs:327 | if (SrcRow != null) ▸ if (MemoRow != null) | FOCUS | txtMemo.Focus | () | 포커스 이동 |  |  |  |
| AC-57e8333d | this.Load | FPC0115_MemoColorEditPopup.cs:333 | if (SrcRow != null) ▸ else of (MemoRow != null) ▸ if (HasRole == false) | MESSAGE | MessageBox.Show | ("You have no right to add memo") | 메시지 표시 |  |  |  |
| AC-63e75d08 | this.Load | FPC0115_MemoColorEditPopup.cs:334 | if (SrcRow != null) ▸ else of (MemoRow != null) ▸ if (HasRole == false) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f899eb26 | this.Load | FPC0115_MemoColorEditPopup.cs:335 | if (SrcRow != null) ▸ else of (MemoRow != null) ▸ if (HasRole == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03e7ea62 | this.Load | FPC0115_MemoColorEditPopup.cs:337 | if (SrcRow != null) ▸ else of (MemoRow != null) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-681c97d7 | this.Load | FPC0115_MemoColorEditPopup.cs:338 | if (SrcRow != null) ▸ else of (MemoRow != null) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a7c861b6 | this.Load | FPC0115_MemoColorEditPopup.cs:339 | if (SrcRow != null) ▸ else of (MemoRow != null) | VALUE_CLEAR | txtMemo.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-fc4573fa | this.Load | FPC0115_MemoColorEditPopup.cs:351 | if (SrcRow != null) ▸ if (!string.IsNullOrWhiteSpace(attr1_etc_color_info) && string.IsNullOrWhiteSpace(attr2_category_color_info)) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_CurColor", Filter["INSTANCE_ID"].ToString(), Filter["COMPANY_ID"].T… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-538cd555 | this.Load | FPC0115_MemoColorEditPopup.cs:366 | if (SrcRow != null) ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-313640fd | this.Load | FPC0115_MemoColorEditPopup.cs:374 | if (SrcRow != null) ▸ if (dtOperation.Good()) ▸ foreach (DataRow dr in dtOperation.Rows) ▸ if (operation == value) | CALL_EXT | clbOperation.SetItemChecked | (idx, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a69e1a86 | this.Load | FPC0115_MemoColorEditPopup.cs:378 | if (SrcRow != null) ▸ if (dtOperation.Good()) | CALL_EXT | clbOperation.SetValues | (operation) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd1132c5 | this.Load | FPC0115_MemoColorEditPopup.cs:379 | if (SrcRow != null) ▸ if (dtOperation.Good()) | CALL_EXT | clbOperation.CboReset | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8004b3a | this.Load | FPC0115_MemoColorEditPopup.cs:390 | else of (SrcRow != null) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0394d7b2 | this.Load | FPC0115_MemoColorEditPopup.cs:391 | else of (SrcRow != null) | DATA_OP | Filter["INSTANCE_ID"] | _instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-920115dc | this.Load | FPC0115_MemoColorEditPopup.cs:392 | else of (SrcRow != null) | DATA_OP | Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-ce694d5d | this.Load | FPC0115_MemoColorEditPopup.cs:397 | else of (SrcRow != null) ▸ if (line == "-" \|\| line == "") | MESSAGE | MessageBox.Show | ("Selected row has no line information. Please check and try again.") | 메시지 표시 |  |  |  |
| AC-0586d0fe | this.Load | FPC0115_MemoColorEditPopup.cs:398 | else of (SrcRow != null) ▸ if (line == "-" \|\| line == "") | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |
| AC-e67fee84 | this.Load | FPC0115_MemoColorEditPopup.cs:399 | else of (SrcRow != null) ▸ if (line == "-" \|\| line == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6864468 | this.Load | FPC0115_MemoColorEditPopup.cs:402 | else of (SrcRow != null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_CurColor", Filter["INSTANCE_ID"].ToString(), Filter["COMPANY_ID"].T… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d2790388 | this.Load | FPC0115_MemoColorEditPopup.cs:409 | else of (SrcRow != null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_SetupColor_P", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-966a178f | this.Load | FPC0115_MemoColorEditPopup.cs:414 | else of (SrcRow != null) | FLAG | dtEtcColorInfo | colorInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-6507ae35 | this.Load | FPC0115_MemoColorEditPopup.cs:423 | else of (SrcRow != null) | STATE_RESET | dictColor.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-10c9388e | this.Load | FPC0115_MemoColorEditPopup.cs:428 | else of (SrcRow != null) ▸ for (i < dtEtcColorInfo.Rows.Count) | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (coltxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-606cc279 | this.Load | FPC0115_MemoColorEditPopup.cs:429 | else of (SrcRow != null) ▸ for (i < dtEtcColorInfo.Rows.Count) | DATA_OP | dictColor[key] | color | 행/컬럼 값 대입 |  |  |  |
| AC-44730e0d | this.Load | FPC0115_MemoColorEditPopup.cs:438 | else of (SrcRow != null) ▸ if (dtMap.Rows.Count != 0) ▸ for (i < dtEtcColorInfo.Rows.Count) ▸ if (dtEtcColorInfo.Rows[i]["UI_PARAM"].ToStrin… | VALUE_SET | cboColorBox.SelectedIndex | i | 컨트롤 값 설정 |  |  |  |
| AC-71a6f930 | this.Load | FPC0115_MemoColorEditPopup.cs:443 |  | FOCUS | txtMemo.Focus | () | 포커스 이동 |  |  |  |

## FPC0115_MemoColorEditPopup.RefreshCateCombo

진입점: this.Load [if (SrcRow != null)] / this.btnCateAdd.Click [if (colorPopup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b6df18e | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:959 |  | FLAG | dtCategoryColorInfo | dtEtcColorInfo.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-48984a33 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:959 |  | DATA_OP | dtEtcColorInfo.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9d1adedf | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:960 |  | DATA_OP | dtCategoryColorInfo.Columns.SafeAdd | ("COLOR_A", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-98205364 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:961 |  | DATA_OP | dtCategoryColorInfo.Columns.SafeAdd | ("COLOR_B", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a3b94aa | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:963 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-24938f80 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:964 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-81ea3402 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:969 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | dtCategoryColorInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a63d2c0d | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:973 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["UI_PARAM"] | cate["SEGMENT1"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-dac1ba62 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:974 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["UI_DESC"] | cate["ATTRIBUTE2"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-6a4bebce | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:976 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["UI_COLOR"] | cate["ATTRIBUTE10"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-c7ad9c07 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:977 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["COLOR_A"] | cate["ATTRIBUTE10"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-998d1faa | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:978 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | nn["COLOR_B"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c6f92a05 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:979 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | dtCategoryColorInfo.Rows.Add | (nn) | 데이터 객체 조작/조회 |  |  |  |
| AC-18982286 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:980 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | cate["ATTRIBUTE2"].SafeString().ToUpper().Contains | ("MODEL CHANGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-afac02ca | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:981 | foreach (DataRow cate in coteInfo.Rows) ▸ if (cate["ATTRIBUTE2"].SafeString().ToUpper().Contains("MODEL CHANGE")) | FLAG | ChangeModelCateKey | cate["SEGMENT1"].SafeString() | 화면 필드/플래그 변경 |  |  |  |
| AC-98f05d15 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:985 |  | DATA_OP | dtCategoryColorInfo.Select | ("UI_PARAM = 'ETC'") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e4798d7 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:988 | if (rowsEtc.Length < 1) | DATA_OP | dtCategoryColorInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-863e3792 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:992 | if (rowsEtc.Length < 1) | DATA_OP | nn["UI_PARAM"] | "Etc" | 행/컬럼 값 대입 |  |  |  |
| AC-f9b58b98 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:993 | if (rowsEtc.Length < 1) | DATA_OP | nn["UI_DESC"] | "Etc" | 행/컬럼 값 대입 |  |  |  |
| AC-5fc7f9ef | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:994 | if (rowsEtc.Length < 1) | DATA_OP | nn["UI_COLOR"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b77142f0 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:995 | if (rowsEtc.Length < 1) | DATA_OP | nn["COLOR_A"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4bfd133b | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:996 | if (rowsEtc.Length < 1) | DATA_OP | nn["COLOR_B"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e43e3ed5 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:997 | if (rowsEtc.Length < 1) | DATA_OP | dtCategoryColorInfo.Rows.Add | (nn) | 데이터 객체 조작/조회 |  |  |  |
| AC-670cec00 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1004 | foreach (DataRow arow in cateInstanceColorInfo.Rows) | DATA_OP | dtCategoryColorInfo.Select | ("UI_PARAM='" + key + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-09b22d06 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1010 | foreach (DataRow arow in cateInstanceColorInfo.Rows) ▸ if (ress.Length > 0) ▸ if (!string.IsNullOrWhiteSpace(colorv)) | DATA_OP | ress[0]["UI_COLOR"] | colorv | 행/컬럼 값 대입 |  |  |  |
| AC-dc06b031 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1011 | foreach (DataRow arow in cateInstanceColorInfo.Rows) ▸ if (ress.Length > 0) ▸ if (!string.IsNullOrWhiteSpace(colorv)) | DATA_OP | ress[0]["COLOR_B"] | colorv | 행/컬럼 값 대입 |  |  |  |
| AC-f5fb3213 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1028 | if (dtCategoryColorInfo != null) | DATA_OP | dtCategoryColorInfo.Columns.SafeAdd | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc230760 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1029 | if (dtCategoryColorInfo != null) | DATA_OP | dtCategoryColorInfo.Columns.SafeAdd | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7eeb3aff | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1032 | if (dtCategoryColorInfo != null) ▸ foreach (DataRow ro in dtCategoryColorInfo.Rows) | DATA_OP | ro["CODE"] | ro["UI_PARAM"] | 행/컬럼 값 대입 |  |  |  |
| AC-538ad59e | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1033 | if (dtCategoryColorInfo != null) ▸ foreach (DataRow ro in dtCategoryColorInfo.Rows) | DATA_OP | ro["NAME"] | ro["UI_DESC"] | 행/컬럼 값 대입 |  |  |  |
| AC-fb4191a6 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1038 |  | LIST_REBIND | clsCtrl.setListBox | (dtCategoryColorInfo, clbCategory, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-a6dea57e | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1040 |  | STATE_RESET | dictCateColor.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8771ca7d | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1042 |  | DATA_OP | dictCateColor["Default"] | MemoService.DefaultCateColor | 행/컬럼 값 대입 |  |  |  |
| AC-9a18f1d2 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1051 | for (i < dtCategoryColorInfo.Rows.Count) ▸ try ▸ if (!string.IsNullOrWhiteSpace(coltxt)) | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (coltxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6f6cc92 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1057 | for (i < dtCategoryColorInfo.Rows.Count) | DATA_OP | dictCateColor[key] | color2 | 행/컬럼 값 대입 |  |  |  |

## FPC0115_MemoColorEditPopup.RefreshColorCombo

진입점: this.Load [if (SrcRow != null)] / this.btnColorDelete.Click [foreach (DataRow row in dtEtcColorInfo.Rows) ▸ if (ui_color_desc.ToUpper() == txtDelete.ToUpper())] / this.btnColorAdd.Click [if (colorPopup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acfd8701 | this.Load [if (SrcRow != null)] 외 2 | FPC0115_MemoColorEditPopup.cs:1130 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_SetupColor_P", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4bd43d9e | this.Load [if (SrcRow != null)] 외 2 | FPC0115_MemoColorEditPopup.cs:1131 |  | FLAG | dtEtcColorInfo | colorInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-57895748 | this.Load [if (SrcRow != null)] 외 2 | FPC0115_MemoColorEditPopup.cs:1139 |  | LIST_CLEAR | cboColorBox.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-a28ae27f | this.Load [if (SrcRow != null)] 외 2 | FPC0115_MemoColorEditPopup.cs:1142 | for (i < dtEtcColorInfo.Rows.Count) | DATA_OP | cboColorBox.Items.Add | (dtEtcColorInfo.Rows[i]["UI_DESC"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e72f8ec4 | this.Load [if (SrcRow != null)] 외 2 | FPC0115_MemoColorEditPopup.cs:1146 |  | STATE_RESET | dictColor.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1863e6f9 | this.Load [if (SrcRow != null)] 외 2 | FPC0115_MemoColorEditPopup.cs:1154 | for (i < dtEtcColorInfo.Rows.Count) ▸ try | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (coltxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-69a3bfa2 | this.Load [if (SrcRow != null)] 외 2 | FPC0115_MemoColorEditPopup.cs:1159 | for (i < dtEtcColorInfo.Rows.Count) | DATA_OP | dictColor[key] | color2 | 행/컬럼 값 대입 |  |  |  |

## FPC0115_MemoColorEditPopup.SelectCateCombo

진입점: this.Load [if (SrcRow != null)] / this.btnCateAdd.Click [if (colorPopup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0fa2c51 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1083 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) | DATA_OP | color_infos.Contains | (value) | 데이터 객체 조작/조회 |  |  |  |
| AC-51397824 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1085 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) ▸ if (color_infos.Contains(v… | CALL_EXT | clbCategory.SetItemChecked | (idx, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bafdd3bc | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1086 | if (dtCategoryColorInfo.Good()) ▸ if (color_info.Length > 0) ▸ foreach (DataRow dr in dtCategoryColorInfo.Rows) ▸ if (color_infos.Contains(v… | DATA_OP | name.ToUpper().Contains | ("MODEL CHANGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a8016e8 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1094 | if (dtCategoryColorInfo.Good()) | CALL_EXT | clbCategory.CboReset | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8b2117f | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1097 | if (dtCategoryColorInfo.Good()) ▸ if (ModelChangeSelected == false) | VALUE_CLEAR | cboColorBox.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-b1a89983 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1098 | if (dtCategoryColorInfo.Good()) ▸ if (ModelChangeSelected == false) | STATE | cboColorBox.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-dfa23167 | this.Load [if (SrcRow != null)] 외 1 | FPC0115_MemoColorEditPopup.cs:1102 | if (dtCategoryColorInfo.Good()) ▸ else of (ModelChangeSelected == false) | STATE | cboColorBox.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FPC0115_MemoColorEditPopup.SelectColorCombo

진입점: this.Load [if (SrcRow != null)] / this.btnColorAdd.Click [if (colorPopup.ShowDialog() == DialogResult.OK)] / this.btnCateAdd.Click [if (colorPopup.ShowDialog() == DialogResult.OK) ▸ if (dtCategoryColorInfo.Good()) ▸ else of (ModelChangeSelected == false) ▸ if (!string.IsNullOrWhiteSpace(attr1_model_change))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a94abead | this.Load [if (SrcRow != null)] 외 2 | FPC0115_MemoColorEditPopup.cs:1172 | if (dtEtcColorInfo.Rows.Count != 0) ▸ for (i < dtEtcColorInfo.Rows.Count) ▸ if (dtEtcColorInfo.Rows[i]["UI_PARAM"].ToString().ToUpper() == a… | VALUE_SET | cboColorBox.SelectedIndex | i | 컨트롤 값 설정 |  |  |  |

## FPC0115_MemoColorEditPopup.SetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9974206b | (진입점 미연결) | FPC0115_MemoColorEditPopup.cs:488 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |


# AS-IS 액션 대조표 — FPC0110

> 원천: `Doc/asisfacts/screens/FPC0110/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 114행 · 메서드 7 · 종류 DATA_OP 70 · FLAG 15 · VALUE_SET 5 · ENDPOINT 4 · UI_MISC 4 · COMBO_DATA 4 · CALL_EXT 3 · VALUE_CLEAR 3 · MESSAGE 2 · UI_PROP 2 · LIST_CLEAR 2 · ⚠ 의미 확인 필요 3


## FPC0110_MemoEditColorPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a94d4a9 | .ctor | FPC0110_MemoEditColorPopup.cs:110 |  | FLAG | SrcRow | row | 화면 필드/플래그 변경 |  |  |  |
| AC-974547a6 | .ctor | FPC0110_MemoEditColorPopup.cs:111 |  | FLAG | iColumn | colindex | 화면 필드/플래그 변경 |  |  |  |
| AC-ba6a5bc1 | .ctor | FPC0110_MemoEditColorPopup.cs:112 |  | FLAG | iRow | rowindex | 화면 필드/플래그 변경 |  |  |  |
| AC-6c806ade | .ctor | FPC0110_MemoEditColorPopup.cs:113 |  | FLAG | Day | date | 화면 필드/플래그 변경 |  |  |  |
| AC-9d86419b | .ctor | FPC0110_MemoEditColorPopup.cs:114 |  | FLAG | _instance_id | filterdataset["INSTANCE_ID"] | 화면 필드/플래그 변경 |  |  |  |
| AC-f295ba30 | .ctor | FPC0110_MemoEditColorPopup.cs:115 |  | FLAG | Filter_param | filterdataset | 화면 필드/플래그 변경 |  |  |  |
| AC-1cba069b | .ctor | FPC0110_MemoEditColorPopup.cs:117 |  | DATA_OP | Filter_param["BUCKET_FROM"] | Filter_param["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-8cb32f76 | .ctor | FPC0110_MemoEditColorPopup.cs:118 |  | DATA_OP | Filter_param["BUCKET_TO"] | Filter_param["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |

## FPC0110_MemoEditColorPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51dff0f9 | this.btnClose.Click | FPC0110_MemoEditColorPopup.cs:365 | try | DATA_OP | Filter["BUCKET_FROM"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-8144daf2 | this.btnClose.Click | FPC0110_MemoEditColorPopup.cs:366 | try | DATA_OP | Filter["BUCKET_TO"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-5c5b9023 | this.btnClose.Click | FPC0110_MemoEditColorPopup.cs:367 | try | DATA_OP | Filter["MEMO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1113b390 | this.btnClose.Click | FPC0110_MemoEditColorPopup.cs:368 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-075dfc8c | this.btnClose.Click | FPC0110_MemoEditColorPopup.cs:369 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "delete_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_memo] \| FP\Common\Am… | 엔드포인트 호출 |  |  |  |
| AC-99754725 | this.btnClose.Click | FPC0110_MemoEditColorPopup.cs:373 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Delete Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-6cad05bc | this.btnClose.Click | FPC0110_MemoEditColorPopup.cs:377 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-4530aea4 | this.btnClose.Click | FPC0110_MemoEditColorPopup.cs:378 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0110_MemoEditColorPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a288d57 | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:311 | try | DATA_OP | Filter["BUCKET_FROM"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-213dd1a0 | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:312 | try | DATA_OP | Filter["BUCKET_TO"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-bb86a005 | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:313 | try | DATA_OP | Filter["MEMO"] | usrTextBox1.Text | 행/컬럼 값 대입 |  |  |  |
| AC-a0f518ae | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:314 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-544ffc56 | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:315 | try | DATA_OP | Filter["INSTANCE_ID"] | _instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-b14cbd9e | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:316 | try | DATA_OP | Filter_param["MEMO"] | usrTextBox1.Text | 행/컬럼 값 대입 |  |  |  |
| AC-24e629e2 | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:317 | try | DATA_OP | Filter_param["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6905b3d9 | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:318 | try | DATA_OP | Filter["SEQ"] | Filter_param["SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-30f9605d | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:319 | try | DATA_OP | Filter["COMPANY_ID"] | Filter_param["COMPANY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e30dccb7 | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:324 | try ▸ if (dtColor != null) | CALL_EXT | dtColor.findRow | ("UI_DESC", cbo_Color.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-161f0062 | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:333 | try | DATA_OP | Filter["SETUP_COLOR_CODE"] | getColorParam | 행/컬럼 값 대입 |  |  |  |
| AC-023d4471 | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:335 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "save_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] \| FP\Common\Amen… | 엔드포인트 호출 |  |  |  |
| AC-634c96eb | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:337 | try | CALL_EXT | Thread.Sleep | (300) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8f5e707 | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:346 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "save_SetupColor", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_SetupColor] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-9c86701d | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:347 | try | CALL_EXT | Thread.Sleep | (300) | ⚠ 의미 확인 필요 |  |  |  |
| AC-588fee89 | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:351 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Save Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-5fa5c96c | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:355 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-8a2bcbb7 | this.btnSave.Click | FPC0110_MemoEditColorPopup.cs:356 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0110_MemoEditColorPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-532c905f | Dispose | FPC0110_MemoEditColorPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0110_MemoEditColorPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39ef4367 | this.Load | FPC0110_MemoEditColorPopup.cs:128 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-804fe34f | this.Load | FPC0110_MemoEditColorPopup.cs:130 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0110_MemoEditColorPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e98e1ec | this.Load | FPC0110_MemoEditColorPopup.cs:140 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c7bf7c9c | this.Load | FPC0110_MemoEditColorPopup.cs:143 | if (SrcRow != null) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b7259920 | this.Load | FPC0110_MemoEditColorPopup.cs:144 | if (SrcRow != null) | DATA_OP | Filter["INSTANCE_ID"] | _instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-e80625e0 | this.Load | FPC0110_MemoEditColorPopup.cs:145 | if (SrcRow != null) | DATA_OP | Filter["COMPANY_ID"] | SrcRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0755d219 | this.Load | FPC0110_MemoEditColorPopup.cs:146 | if (SrcRow != null) | DATA_OP | Filter["DIVISION_ID"] | SrcRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9b7f87d0 | this.Load | FPC0110_MemoEditColorPopup.cs:147 | if (SrcRow != null) | DATA_OP | Filter["SITE_ID"] | SrcRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fb1a45d9 | this.Load | FPC0110_MemoEditColorPopup.cs:148 | if (SrcRow != null) | DATA_OP | Filter["LINE_ID"] | SrcRow["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc0a30e0 | this.Load | FPC0110_MemoEditColorPopup.cs:149 | if (SrcRow != null) | DATA_OP | Filter["PLANT_ID"] | SrcRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ebb9b1f0 | this.Load | FPC0110_MemoEditColorPopup.cs:150 | if (SrcRow != null) | DATA_OP | Filter["FACTORY_ID"] | SrcRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d6220108 | this.Load | FPC0110_MemoEditColorPopup.cs:151 | if (SrcRow != null) | DATA_OP | Filter["OPERATION_ID"] | SrcRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d63b9e7c | this.Load | FPC0110_MemoEditColorPopup.cs:152 | if (SrcRow != null) | DATA_OP | Filter["TOP_ITEM_ID"] | SrcRow["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2586a3cd | this.Load | FPC0110_MemoEditColorPopup.cs:153 | if (SrcRow != null) | DATA_OP | Filter["PRODUCTION_TYPE"] | SrcRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-96756c17 | this.Load | FPC0110_MemoEditColorPopup.cs:154 | if (SrcRow != null) | DATA_OP | Filter["MARKET"] | SrcRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fc4c4f74 | this.Load | FPC0110_MemoEditColorPopup.cs:155 | if (SrcRow != null) | DATA_OP | Filter["PLAN_DATE"] | Filter_param["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6b0f12e6 | this.Load | FPC0110_MemoEditColorPopup.cs:156 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-54ed80d2 | this.Load | FPC0110_MemoEditColorPopup.cs:157 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | SrcRow["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c8cbe334 | this.Load | FPC0110_MemoEditColorPopup.cs:159 | if (SrcRow != null) ▸ else of (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-1ec85191 | this.Load | FPC0110_MemoEditColorPopup.cs:160 | if (SrcRow != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | SrcRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-75ff3d09 | this.Load | FPC0110_MemoEditColorPopup.cs:161 | if (SrcRow != null) | DATA_OP | Filter["ITEM_ID"] | SrcRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-87ebbff9 | this.Load | FPC0110_MemoEditColorPopup.cs:162 | if (SrcRow != null) | DATA_OP | Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-bd167e63 | this.Load | FPC0110_MemoEditColorPopup.cs:163 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_FROM"] | Filter_param["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-975656bf | this.Load | FPC0110_MemoEditColorPopup.cs:164 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_TO"] | Filter_param["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-00a6ea5c | this.Load | FPC0110_MemoEditColorPopup.cs:165 | if (SrcRow != null) | DATA_OP | Filter["SEQ"] | Filter_param["SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-a2c1953b | this.Load | FPC0110_MemoEditColorPopup.cs:167 | if (SrcRow != null) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "find_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-72a84fa9 | this.Load | FPC0110_MemoEditColorPopup.cs:171 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo_user | memoInfo.Tables[0].Rows[0]["CREATOR"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-71b929a1 | this.Load | FPC0110_MemoEditColorPopup.cs:172 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo_date | memoInfo.Tables[0].Rows[0]["CREATION"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-baa661b2 | this.Load | FPC0110_MemoEditColorPopup.cs:173 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo | memoInfo.Tables[0].Rows[0]["MEMO"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d4465a42 | this.Load | FPC0110_MemoEditColorPopup.cs:174 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | bucket_from | memoInfo.Tables[0].Rows[0]["BUCKET_FROM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-daa4bd0c | this.Load | FPC0110_MemoEditColorPopup.cs:175 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | bucket_to | memoInfo.Tables[0].Rows[0]["BUCKET_TO"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0845863d | this.Load | FPC0110_MemoEditColorPopup.cs:177 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | txtCreator.Text | memo_user | 컨트롤 값 설정 |  |  |  |
| AC-f89fd779 | this.Load | FPC0110_MemoEditColorPopup.cs:178 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | txtCreation.Text | memo_date | 컨트롤 값 설정 |  |  |  |
| AC-fc12fce1 | this.Load | FPC0110_MemoEditColorPopup.cs:179 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | usrTextBox1.Text | memo | 컨트롤 값 설정 |  |  |  |
| AC-64c3a9c0 | this.Load | FPC0110_MemoEditColorPopup.cs:185 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-08fa7103 | this.Load | FPC0110_MemoEditColorPopup.cs:186 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-35fcd9e6 | this.Load | FPC0110_MemoEditColorPopup.cs:187 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | usrTextBox1.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-be2d9f5d | this.Load | FPC0110_MemoEditColorPopup.cs:197 | if (SrcRow != null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_CurColor", Filter["INSTANCE_ID"].ToString(), Filter["COMPANY_ID"].T… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8d84b4a1 | this.Load | FPC0110_MemoEditColorPopup.cs:205 | if (SrcRow != null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_SetupColor_P", Filter["INSTANCE_ID"].ToString() ) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8759e08a | this.Load | FPC0110_MemoEditColorPopup.cs:210 | if (SrcRow != null) | FLAG | dtColor | colorInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-11c491cf | this.Load | FPC0110_MemoEditColorPopup.cs:212 | if (SrcRow != null) | LIST_CLEAR | cbo_Color.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-a671d4ab | this.Load | FPC0110_MemoEditColorPopup.cs:215 | if (SrcRow != null) ▸ for (i < dtColor.Rows.Count) | DATA_OP | cbo_Color.Items.Add | (dtColor.Rows[i]["UI_DESC"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c764535c | this.Load | FPC0110_MemoEditColorPopup.cs:217 | if (SrcRow != null) | DATA_OP | cbo_Color.Items.Add | ("") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d166fe6 | this.Load | FPC0110_MemoEditColorPopup.cs:224 | if (SrcRow != null) ▸ if (dtMap.Rows.Count != 0) ▸ for (i < dtColor.Rows.Count) ▸ if (dtColor.Rows[i]["UI_PARAM"].ToString().ToUpper() == dt… | VALUE_SET | cbo_Color.SelectedIndex | i | 컨트롤 값 설정 |  |  |  |
| AC-17484706 | this.Load | FPC0110_MemoEditColorPopup.cs:236 | else of (SrcRow != null) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4f0fd718 | this.Load | FPC0110_MemoEditColorPopup.cs:237 | else of (SrcRow != null) | DATA_OP | Filter["INSTANCE_ID"] | _instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-fc848327 | this.Load | FPC0110_MemoEditColorPopup.cs:238 | else of (SrcRow != null) | DATA_OP | Filter["COMPANY_ID"] | Filter_param["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a32b31b3 | this.Load | FPC0110_MemoEditColorPopup.cs:239 | else of (SrcRow != null) | DATA_OP | Filter["DIVISION_ID"] | Filter_param["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d54aea7b | this.Load | FPC0110_MemoEditColorPopup.cs:240 | else of (SrcRow != null) | DATA_OP | Filter["SITE_ID"] | Filter_param["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e184fd31 | this.Load | FPC0110_MemoEditColorPopup.cs:241 | else of (SrcRow != null) | DATA_OP | Filter["LINE_ID"] | Filter_param["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-faa9019a | this.Load | FPC0110_MemoEditColorPopup.cs:242 | else of (SrcRow != null) | DATA_OP | Filter["PLANT_ID"] | Filter_param["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aa24de25 | this.Load | FPC0110_MemoEditColorPopup.cs:243 | else of (SrcRow != null) | DATA_OP | Filter["FACTORY_ID"] | Filter_param["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-816ffab6 | this.Load | FPC0110_MemoEditColorPopup.cs:244 | else of (SrcRow != null) | DATA_OP | Filter["OPERATION_ID"] | Filter_param["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ff11d171 | this.Load | FPC0110_MemoEditColorPopup.cs:245 | else of (SrcRow != null) | DATA_OP | Filter["TOP_ITEM_ID"] | Filter_param["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-37203941 | this.Load | FPC0110_MemoEditColorPopup.cs:246 | else of (SrcRow != null) | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter_param["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9f0d1524 | this.Load | FPC0110_MemoEditColorPopup.cs:247 | else of (SrcRow != null) | DATA_OP | Filter["MARKET"] | Filter_param["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-41cd2173 | this.Load | FPC0110_MemoEditColorPopup.cs:248 | else of (SrcRow != null) | DATA_OP | Filter["PLAN_DATE"] | Filter_param["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2d48fd2c | this.Load | FPC0110_MemoEditColorPopup.cs:249 | else of (SrcRow != null) | DATA_OP | Filter["EQUIPMENT_ID"] | Filter_param["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b2d1a59a | this.Load | FPC0110_MemoEditColorPopup.cs:250 | else of (SrcRow != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | Filter_param["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a28d0f11 | this.Load | FPC0110_MemoEditColorPopup.cs:251 | else of (SrcRow != null) | DATA_OP | Filter["ITEM_ID"] | Filter_param["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4d139159 | this.Load | FPC0110_MemoEditColorPopup.cs:252 | else of (SrcRow != null) | DATA_OP | Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-5c7483e5 | this.Load | FPC0110_MemoEditColorPopup.cs:253 | else of (SrcRow != null) | DATA_OP | Filter["BUCKET_FROM"] | Filter_param["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2ba9a64c | this.Load | FPC0110_MemoEditColorPopup.cs:254 | else of (SrcRow != null) | DATA_OP | Filter["BUCKET_TO"] | Filter_param["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-69154617 | this.Load | FPC0110_MemoEditColorPopup.cs:256 | else of (SrcRow != null) | DATA_OP | Filter["LINE_ID"] | Filter_param["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-10b7e5b3 | this.Load | FPC0110_MemoEditColorPopup.cs:257 | else of (SrcRow != null) | DATA_OP | Filter["OPERATION_ID"] | Filter_param["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e000c2de | this.Load | FPC0110_MemoEditColorPopup.cs:258 | else of (SrcRow != null) | DATA_OP | Filter["TOP_ITEM_ID"] | Filter_param["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b41d81ef | this.Load | FPC0110_MemoEditColorPopup.cs:259 | else of (SrcRow != null) | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter_param["PRODUCTION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-78af0eb3 | this.Load | FPC0110_MemoEditColorPopup.cs:260 | else of (SrcRow != null) | DATA_OP | Filter["EQUIPMENT_ID"] | Filter_param["EQUIPMENT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-da8969e5 | this.Load | FPC0110_MemoEditColorPopup.cs:261 | else of (SrcRow != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | Filter_param["ELECTRODE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f3111041 | this.Load | FPC0110_MemoEditColorPopup.cs:262 | else of (SrcRow != null) | DATA_OP | Filter["ITEM_ID"] | Filter_param["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6d0cd67b | this.Load | FPC0110_MemoEditColorPopup.cs:263 | else of (SrcRow != null) | DATA_OP | Filter["MARKET"] | Filter_param["MARKET"] | 행/컬럼 값 대입 |  |  |  |
| AC-77bb7626 | this.Load | FPC0110_MemoEditColorPopup.cs:266 | else of (SrcRow != null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_CurColor", Filter["INSTANCE_ID"].ToString(), Filter["COMPANY_ID"].T… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-79b75e0c | this.Load | FPC0110_MemoEditColorPopup.cs:273 | else of (SrcRow != null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_SetupColor_P", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8bc65812 | this.Load | FPC0110_MemoEditColorPopup.cs:278 | else of (SrcRow != null) | FLAG | dtColor | colorInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-8d703b3e | this.Load | FPC0110_MemoEditColorPopup.cs:280 | else of (SrcRow != null) | LIST_CLEAR | cbo_Color.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-c955a89f | this.Load | FPC0110_MemoEditColorPopup.cs:283 | else of (SrcRow != null) ▸ for (i < dtColor.Rows.Count) | DATA_OP | cbo_Color.Items.Add | (dtColor.Rows[i]["UI_DESC"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8382836 | this.Load | FPC0110_MemoEditColorPopup.cs:285 | else of (SrcRow != null) | DATA_OP | cbo_Color.Items.Add | ("") | 데이터 객체 조작/조회 |  |  |  |
| AC-730ac553 | this.Load | FPC0110_MemoEditColorPopup.cs:292 | else of (SrcRow != null) ▸ if (dtMap.Rows.Count != 0) ▸ for (i < dtColor.Rows.Count) ▸ if (dtColor.Rows[i]["UI_PARAM"].ToString().ToUpper() … | VALUE_SET | cbo_Color.SelectedIndex | i | 컨트롤 값 설정 |  |  |  |

## FPC0110_MemoEditColorPopup.SetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b5efff0 | (진입점 미연결) | FPC0110_MemoEditColorPopup.cs:300 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |


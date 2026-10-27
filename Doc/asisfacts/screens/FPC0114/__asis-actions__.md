# AS-IS 액션 대조표 — FPC0114

> 원천: `Doc/asisfacts/screens/FPC0114/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 109행 · 메서드 9 · 종류 DATA_OP 52 · FLAG 13 · CALL_EXT 8 · UI_MISC 5 · VALUE_SET 5 · STATE 4 · ENDPOINT 3 · MESSAGE 3 · UI_PROP 3 · VALUE_CLEAR 3 · COMBO_DATA 3 · LIST_CLEAR 2 · STATE_RESET 2 · POPUP 2 · RETURN 1 · ⚠ 의미 확인 필요 8


## FPC0114_MemoColorEditPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee1862f8 | .ctor | FPC0114_MemoColorEditPopup.cs:124 |  | FLAG | SrcRow | row | 화면 필드/플래그 변경 |  |  |  |
| AC-f54aaaca | .ctor | FPC0114_MemoColorEditPopup.cs:125 |  | FLAG | iColumn | colindex | 화면 필드/플래그 변경 |  |  |  |
| AC-90dd401f | .ctor | FPC0114_MemoColorEditPopup.cs:126 |  | FLAG | iRow | rowindex | 화면 필드/플래그 변경 |  |  |  |
| AC-3a0cca3b | .ctor | FPC0114_MemoColorEditPopup.cs:127 |  | FLAG | Day | date | 화면 필드/플래그 변경 |  |  |  |

## FPC0114_MemoColorEditPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b21bd9c9 | this.btnClose.Click | FPC0114_MemoColorEditPopup.cs:400 | try | DATA_OP | Filter["BUCKET_FROM"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-907e9066 | this.btnClose.Click | FPC0114_MemoColorEditPopup.cs:401 | try | DATA_OP | Filter["BUCKET_TO"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f95e6c99 | this.btnClose.Click | FPC0114_MemoColorEditPopup.cs:402 | try | DATA_OP | Filter["MEMO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-310fc4c6 | this.btnClose.Click | FPC0114_MemoColorEditPopup.cs:403 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0e664680 | this.btnClose.Click | FPC0114_MemoColorEditPopup.cs:404 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "delete_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_memo] \| FP\Common\Am… | 엔드포인트 호출 |  |  |  |
| AC-374449e3 | this.btnClose.Click | FPC0114_MemoColorEditPopup.cs:408 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Delete Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-d7c2dbaa | this.btnClose.Click | FPC0114_MemoColorEditPopup.cs:412 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-204f1d38 | this.btnClose.Click | FPC0114_MemoColorEditPopup.cs:413 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0114_MemoColorEditPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b2efcce | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:346 | try | DATA_OP | Filter["BUCKET_FROM"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-94c0c765 | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:347 | try | DATA_OP | Filter["BUCKET_TO"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e228cd46 | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:348 | try | DATA_OP | Filter["MEMO"] | usrTextBox1.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d63e72fa | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:349 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-09dd3ecd | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:350 | try | DATA_OP | Filter["INSTANCE_ID"] | _instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-e9950b01 | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:351 | try | DATA_OP | Filter["MEMO"] | usrTextBox1.Text | 행/컬럼 값 대입 |  |  |  |
| AC-0d301975 | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:352 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-24d75ac2 | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:357 | try ▸ if (dtColor != null) | CALL_EXT | dtColor.findRow | ("UI_DESC", cbo_Color.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f9acb27b | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:366 | try | DATA_OP | Filter["SETUP_COLOR_CODE"] | getColorParam | 행/컬럼 값 대입 |  |  |  |
| AC-dc301c20 | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:367 | try | DATA_OP | Filter["ATTR1"] | getColorParam | 행/컬럼 값 대입 |  |  |  |
| AC-cb9aa269 | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:368 | try | DATA_OP | Filter["ATTR2"] | Filter["ATTR3"] = Filter["ATTR4"] = Filter["ATTR5"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-cfc07d65 | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:368 | try | DATA_OP | Filter["ATTR3"] | Filter["ATTR4"] = Filter["ATTR5"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-d1145aba | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:368 | try | DATA_OP | Filter["ATTR4"] | Filter["ATTR5"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d0601b0 | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:368 | try | DATA_OP | Filter["ATTR5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-da42c46d | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:370 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "save_memo_color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo_color] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-8971030f | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:372 | try | CALL_EXT | Thread.Sleep | (300) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99b67b60 | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:382 | try | CALL_EXT | Thread.Sleep | (300) | ⚠ 의미 확인 필요 |  |  |  |
| AC-be016137 | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:386 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Save Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-0dc037f7 | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:390 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-4031f63a | this.btnSave.Click | FPC0114_MemoColorEditPopup.cs:391 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0114_MemoColorEditPopup.cboColorBox_DrawItem

진입점: this.cboColorBox.DrawItem

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5ef89c7 | this.cboColorBox.DrawItem | FPC0114_MemoColorEditPopup.cs:464 | if (e.Index >=0) | CALL_EXT | g.DrawString | (n, f, Brushes.Black, rect.X, rect.Top) | ⚠ 의미 확인 필요 |  |  |  |
| AC-383a713a | this.cboColorBox.DrawItem | FPC0114_MemoColorEditPopup.cs:465 | if (e.Index >=0) | CALL_EXT | g.FillRectangle | (b, rect.X + 110, rect.Y + 3, rect.Width - 10, rect.Height - 3) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0114_MemoColorEditPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2c691d1 | Dispose | FPC0114_MemoColorEditPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0114_MemoColorEditPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-660894f7 | this.Load | FPC0114_MemoColorEditPopup.cs:138 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d9d4869e | this.Load | FPC0114_MemoColorEditPopup.cs:140 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0114_MemoColorEditPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d750815 | this.Load | FPC0114_MemoColorEditPopup.cs:153 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-dbd4da89 | this.Load | FPC0114_MemoColorEditPopup.cs:155 |  | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-87ab37dd | this.Load | FPC0114_MemoColorEditPopup.cs:158 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | usrTextBox1.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-2d5c9888 | this.Load | FPC0114_MemoColorEditPopup.cs:159 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | usrTextBox1.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1b154a0e | this.Load | FPC0114_MemoColorEditPopup.cs:160 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0377dd24 | this.Load | FPC0114_MemoColorEditPopup.cs:161 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-19d7eb13 | this.Load | FPC0114_MemoColorEditPopup.cs:165 | if (SrcRow != null) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0960fd86 | this.Load | FPC0114_MemoColorEditPopup.cs:166 | if (SrcRow != null) | DATA_OP | Filter["INSTANCE_ID"] | _instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-a167e1e6 | this.Load | FPC0114_MemoColorEditPopup.cs:167 | if (SrcRow != null) | DATA_OP | Filter["COMPANY_ID"] | SrcRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5105e056 | this.Load | FPC0114_MemoColorEditPopup.cs:168 | if (SrcRow != null) | DATA_OP | Filter["DIVISION_ID"] | SrcRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-78af2844 | this.Load | FPC0114_MemoColorEditPopup.cs:169 | if (SrcRow != null) | DATA_OP | Filter["SITE_ID"] | SrcRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7591633a | this.Load | FPC0114_MemoColorEditPopup.cs:170 | if (SrcRow != null) | DATA_OP | Filter["LINE_ID"] | SrcRow["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3017e739 | this.Load | FPC0114_MemoColorEditPopup.cs:171 | if (SrcRow != null) | DATA_OP | Filter["PLANT_ID"] | SrcRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ec0659c6 | this.Load | FPC0114_MemoColorEditPopup.cs:172 | if (SrcRow != null) | DATA_OP | Filter["FACTORY_ID"] | SrcRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-404774f9 | this.Load | FPC0114_MemoColorEditPopup.cs:173 | if (SrcRow != null) | DATA_OP | Filter["OPERATION_ID"] | SrcRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2d2bd060 | this.Load | FPC0114_MemoColorEditPopup.cs:174 | if (SrcRow != null) | DATA_OP | Filter["TOP_ITEM_ID"] | SrcRow["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5aef2b7 | this.Load | FPC0114_MemoColorEditPopup.cs:175 | if (SrcRow != null) | DATA_OP | Filter["PRODUCTION_TYPE"] | SrcRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-13b3b650 | this.Load | FPC0114_MemoColorEditPopup.cs:176 | if (SrcRow != null) | DATA_OP | Filter["MARKET"] | SrcRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-36861076 | this.Load | FPC0114_MemoColorEditPopup.cs:177 | if (SrcRow != null) | DATA_OP | Filter["PLAN_DATE"] | Day.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-567985fc | this.Load | FPC0114_MemoColorEditPopup.cs:178 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3fdadb7a | this.Load | FPC0114_MemoColorEditPopup.cs:179 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | SrcRow["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-414800d6 | this.Load | FPC0114_MemoColorEditPopup.cs:181 | if (SrcRow != null) ▸ else of (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-03398e3c | this.Load | FPC0114_MemoColorEditPopup.cs:182 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-79847b34 | this.Load | FPC0114_MemoColorEditPopup.cs:183 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("ELECTRODE_TYPE")) | DATA_OP | Filter["ELECTRODE_TYPE"] | SrcRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-252fca1b | this.Load | FPC0114_MemoColorEditPopup.cs:185 | if (SrcRow != null) ▸ else of (SrcRow.Table.Columns.Contains("ELECTRODE_TYPE")) | DATA_OP | Filter["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-433ae3cc | this.Load | FPC0114_MemoColorEditPopup.cs:186 | if (SrcRow != null) | DATA_OP | Filter["ITEM_ID"] | SrcRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d07b21dc | this.Load | FPC0114_MemoColorEditPopup.cs:187 | if (SrcRow != null) | DATA_OP | Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-b57b1e26 | this.Load | FPC0114_MemoColorEditPopup.cs:188 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_FROM"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b97b28cf | this.Load | FPC0114_MemoColorEditPopup.cs:189 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_TO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7c0beb46 | this.Load | FPC0114_MemoColorEditPopup.cs:191 | if (SrcRow != null) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "find_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4b2f5b95 | this.Load | FPC0114_MemoColorEditPopup.cs:196 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | DATA_OP | memoInfo.Tables[0].Columns.Contains | ("ATTR1") | 데이터 객체 조작/조회 |  |  |  |
| AC-20a4ccf0 | this.Load | FPC0114_MemoColorEditPopup.cs:198 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo_user | memoInfo.Tables[0].Rows[0]["CREATOR"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1789cf58 | this.Load | FPC0114_MemoColorEditPopup.cs:199 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo_date | memoInfo.Tables[0].Rows[0]["CREATION"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2e5b8bdd | this.Load | FPC0114_MemoColorEditPopup.cs:200 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo | memoInfo.Tables[0].Rows[0]["MEMO"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-439f21e4 | this.Load | FPC0114_MemoColorEditPopup.cs:201 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | bucket_from | memoInfo.Tables[0].Rows[0]["BUCKET_FROM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8f0395d8 | this.Load | FPC0114_MemoColorEditPopup.cs:202 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | bucket_to | memoInfo.Tables[0].Rows[0]["BUCKET_TO"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e7649685 | this.Load | FPC0114_MemoColorEditPopup.cs:204 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | txtCreator.Text | memo_user | 컨트롤 값 설정 |  |  |  |
| AC-f495a77b | this.Load | FPC0114_MemoColorEditPopup.cs:205 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | txtCreation.Text | memo_date | 컨트롤 값 설정 |  |  |  |
| AC-67f022af | this.Load | FPC0114_MemoColorEditPopup.cs:206 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | usrTextBox1.Text | memo | 컨트롤 값 설정 |  |  |  |
| AC-058ab894 | this.Load | FPC0114_MemoColorEditPopup.cs:214 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | MESSAGE | MessageBox.Show | ("You have no right to add memo") | 메시지 표시 |  |  |  |
| AC-45eb0d5d | this.Load | FPC0114_MemoColorEditPopup.cs:215 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-4df17da7 | this.Load | FPC0114_MemoColorEditPopup.cs:216 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f3d01a1 | this.Load | FPC0114_MemoColorEditPopup.cs:218 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-ae971f28 | this.Load | FPC0114_MemoColorEditPopup.cs:219 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-16c221fe | this.Load | FPC0114_MemoColorEditPopup.cs:220 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | usrTextBox1.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-156cac4b | this.Load | FPC0114_MemoColorEditPopup.cs:238 | if (SrcRow != null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_SetupColor_P", Filter["INSTANCE_ID"].ToString() ) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bb010639 | this.Load | FPC0114_MemoColorEditPopup.cs:243 | if (SrcRow != null) | FLAG | dtColor | colorInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-6fe058f1 | this.Load | FPC0114_MemoColorEditPopup.cs:245 | if (SrcRow != null) | LIST_CLEAR | cbo_Color.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-9eb6447e | this.Load | FPC0114_MemoColorEditPopup.cs:248 | if (SrcRow != null) ▸ for (i < dtColor.Rows.Count) | DATA_OP | cbo_Color.Items.Add | (dtColor.Rows[i]["UI_DESC"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b56a82a | this.Load | FPC0114_MemoColorEditPopup.cs:250 | if (SrcRow != null) | DATA_OP | cbo_Color.Items.Add | ("") | 데이터 객체 조작/조회 |  |  |  |
| AC-9493276a | this.Load | FPC0114_MemoColorEditPopup.cs:253 | if (SrcRow != null) ▸ for (i < dtColor.Rows.Count) | DATA_OP | cboColorBox.Items.Add | (dtColor.Rows[i]["UI_DESC"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e66ce7ee | this.Load | FPC0114_MemoColorEditPopup.cs:257 | if (SrcRow != null) | STATE_RESET | dictColor.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ac02c7bf | this.Load | FPC0114_MemoColorEditPopup.cs:262 | if (SrcRow != null) ▸ for (i < dtColor.Rows.Count) | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (coltxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-219feb12 | this.Load | FPC0114_MemoColorEditPopup.cs:263 | if (SrcRow != null) ▸ for (i < dtColor.Rows.Count) | DATA_OP | dictColor[key] | color | 행/컬럼 값 대입 |  |  |  |
| AC-7ceeb296 | this.Load | FPC0114_MemoColorEditPopup.cs:273 | if (SrcRow != null) ▸ for (i < dtColor.Rows.Count) ▸ if (dtColor.Rows[i]["UI_PARAM"].ToString().ToUpper() == memo_color_tag.ToUpper()) | VALUE_SET | cbo_Color.SelectedIndex | i | 컨트롤 값 설정 |  |  |  |
| AC-e00a6d50 | this.Load | FPC0114_MemoColorEditPopup.cs:285 | else of (SrcRow != null) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e9f88f5c | this.Load | FPC0114_MemoColorEditPopup.cs:286 | else of (SrcRow != null) | DATA_OP | Filter["INSTANCE_ID"] | _instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-d792189f | this.Load | FPC0114_MemoColorEditPopup.cs:287 | else of (SrcRow != null) | DATA_OP | Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-e7a1d1e9 | this.Load | FPC0114_MemoColorEditPopup.cs:289 | else of (SrcRow != null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_CurColor", Filter["INSTANCE_ID"].ToString(), Filter["COMPANY_ID"].T… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-42559815 | this.Load | FPC0114_MemoColorEditPopup.cs:296 | else of (SrcRow != null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_SetupColor_P", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-328eabcd | this.Load | FPC0114_MemoColorEditPopup.cs:301 | else of (SrcRow != null) | FLAG | dtColor | colorInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-5adc0820 | this.Load | FPC0114_MemoColorEditPopup.cs:303 | else of (SrcRow != null) | LIST_CLEAR | cbo_Color.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-d10c5931 | this.Load | FPC0114_MemoColorEditPopup.cs:306 | else of (SrcRow != null) ▸ for (i < dtColor.Rows.Count) | DATA_OP | cbo_Color.Items.Add | (dtColor.Rows[i]["UI_DESC"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a9a52e3 | this.Load | FPC0114_MemoColorEditPopup.cs:308 | else of (SrcRow != null) | DATA_OP | cbo_Color.Items.Add | ("") | 데이터 객체 조작/조회 |  |  |  |
| AC-afc71aa7 | this.Load | FPC0114_MemoColorEditPopup.cs:310 | else of (SrcRow != null) | STATE_RESET | dictColor.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7b3ad73b | this.Load | FPC0114_MemoColorEditPopup.cs:315 | else of (SrcRow != null) ▸ for (i < dtColor.Rows.Count) | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (coltxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b901c77 | this.Load | FPC0114_MemoColorEditPopup.cs:316 | else of (SrcRow != null) ▸ for (i < dtColor.Rows.Count) | DATA_OP | dictColor[key] | color | 행/컬럼 값 대입 |  |  |  |
| AC-be7ebb17 | this.Load | FPC0114_MemoColorEditPopup.cs:325 | else of (SrcRow != null) ▸ if (dtMap.Rows.Count != 0) ▸ for (i < dtColor.Rows.Count) ▸ if (dtColor.Rows[i]["UI_PARAM"].ToString().ToUpper() … | VALUE_SET | cbo_Color.SelectedIndex | i | 컨트롤 값 설정 |  |  |  |

## FPC0114_MemoColorEditPopup.SetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7e4772a | (진입점 미연결) | FPC0114_MemoColorEditPopup.cs:335 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FPC0114_MemoColorEditPopup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70c6655f | this.usrButton1.Click | FPC0114_MemoColorEditPopup.cs:445 |  | POPUP | new FPC0108_btn_setupinfoPopup | (Filter["INSTANCE_ID"]) | 팝업/폼 생성 |  |  |  |
| AC-83fc9d62 | this.usrButton1.Click | FPC0114_MemoColorEditPopup.cs:447 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0f14c2ee | this.usrButton1.Click | FPC0114_MemoColorEditPopup.cs:448 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |


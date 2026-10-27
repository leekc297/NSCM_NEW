# AS-IS 액션 대조표 — FPC0096

> 원천: `Doc/asisfacts/screens/FPC0096/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 76행 · 메서드 6 · 종류 DATA_OP 31 · FLAG 11 · UI_PROP 6 · UI_MISC 5 · CALL_EXT 5 · ENDPOINT 4 · STATE 4 · MESSAGE 3 · VALUE_SET 3 · VALUE_CLEAR 3 · RETURN 1 · ⚠ 의미 확인 필요 5


## FPC0096_MemoEditPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe50e3e7 | .ctor | FPC0096_MemoEditPopup.cs:104 |  | FLAG | SrcRow | row | 화면 필드/플래그 변경 |  |  |  |
| AC-c8b619f5 | .ctor | FPC0096_MemoEditPopup.cs:105 |  | FLAG | iColumn | colindex | 화면 필드/플래그 변경 |  |  |  |
| AC-2b791448 | .ctor | FPC0096_MemoEditPopup.cs:106 |  | FLAG | iRow | rowindex | 화면 필드/플래그 변경 |  |  |  |
| AC-8cd29ccf | .ctor | FPC0096_MemoEditPopup.cs:107 |  | FLAG | Day | date | 화면 필드/플래그 변경 |  |  |  |

## FPC0096_MemoEditPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11b4dfc6 | this.btnClose.Click | FPC0096_MemoEditPopup.cs:236 | try | DATA_OP | Filter["BUCKET_FROM"] | usrDateRangePicker1.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-0a4a70c9 | this.btnClose.Click | FPC0096_MemoEditPopup.cs:237 | try | DATA_OP | Filter["BUCKET_TO"] | usrDateRangePicker1.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-17bef162 | this.btnClose.Click | FPC0096_MemoEditPopup.cs:238 | try | DATA_OP | Filter["MEMO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0f1dbd50 | this.btnClose.Click | FPC0096_MemoEditPopup.cs:239 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bbb04efe | this.btnClose.Click | FPC0096_MemoEditPopup.cs:240 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "delete_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_memo] \| FP\Common\Am… | 엔드포인트 호출 |  |  |  |
| AC-4fa7c8bc | this.btnClose.Click | FPC0096_MemoEditPopup.cs:244 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Delete Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-4870eae9 | this.btnClose.Click | FPC0096_MemoEditPopup.cs:248 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-2cf49904 | this.btnClose.Click | FPC0096_MemoEditPopup.cs:249 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0096_MemoEditPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4be0c606 | this.btnSave.Click | FPC0096_MemoEditPopup.cs:207 | try | DATA_OP | Filter["BUCKET_FROM"] | usrDateRangePicker1.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-3cba1033 | this.btnSave.Click | FPC0096_MemoEditPopup.cs:208 | try | DATA_OP | Filter["BUCKET_TO"] | usrDateRangePicker1.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-cba8a7cb | this.btnSave.Click | FPC0096_MemoEditPopup.cs:209 | try | DATA_OP | Filter["MEMO"] | usrTextBox1.Text | 행/컬럼 값 대입 |  |  |  |
| AC-2da834e6 | this.btnSave.Click | FPC0096_MemoEditPopup.cs:210 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2b7ef201 | this.btnSave.Click | FPC0096_MemoEditPopup.cs:212 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "save_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] \| FP\Common\Amen… | 엔드포인트 호출 |  |  |  |
| AC-3a322b58 | this.btnSave.Click | FPC0096_MemoEditPopup.cs:215 | try | DATA_OP | Filter["SEQ"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-ab0f76d5 | this.btnSave.Click | FPC0096_MemoEditPopup.cs:216 | try | DATA_OP | Filter["SETUP_COLOR_CODE"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-3ff2633c | this.btnSave.Click | FPC0096_MemoEditPopup.cs:218 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "save_SetupColor", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_SetupColor] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-436caf70 | this.btnSave.Click | FPC0096_MemoEditPopup.cs:222 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Save Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-e38f81ba | this.btnSave.Click | FPC0096_MemoEditPopup.cs:226 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-48297f1c | this.btnSave.Click | FPC0096_MemoEditPopup.cs:227 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0096_MemoEditPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5e40c0c | Dispose | FPC0096_MemoEditPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0096_MemoEditPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5651287b | this.Load | FPC0096_MemoEditPopup.cs:117 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2ea5d0aa | this.Load | FPC0096_MemoEditPopup.cs:119 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0096_MemoEditPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db5d70ff | this.Load | FPC0096_MemoEditPopup.cs:129 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-610d04ea | this.Load | FPC0096_MemoEditPopup.cs:131 |  | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac575fc7 | this.Load | FPC0096_MemoEditPopup.cs:134 | if (UserInfoContext.Current!=null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | usrTextBox1.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-b5fe8732 | this.Load | FPC0096_MemoEditPopup.cs:135 | if (UserInfoContext.Current!=null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | usrTextBox1.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b54dbeaa | this.Load | FPC0096_MemoEditPopup.cs:136 | if (UserInfoContext.Current!=null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-eec01224 | this.Load | FPC0096_MemoEditPopup.cs:137 | if (UserInfoContext.Current!=null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4d8ff245 | this.Load | FPC0096_MemoEditPopup.cs:141 | if (SrcRow != null) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-944900b1 | this.Load | FPC0096_MemoEditPopup.cs:143 | if (SrcRow != null) | DATA_OP | Filter["COMPANY_ID"] | SrcRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b81ac4d7 | this.Load | FPC0096_MemoEditPopup.cs:144 | if (SrcRow != null) | DATA_OP | Filter["DIVISION_ID"] | SrcRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-51554902 | this.Load | FPC0096_MemoEditPopup.cs:145 | if (SrcRow != null) | DATA_OP | Filter["SITE_ID"] | SrcRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dbe8ee75 | this.Load | FPC0096_MemoEditPopup.cs:146 | if (SrcRow != null) | DATA_OP | Filter["LINE_ID"] | SrcRow["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d345aaf9 | this.Load | FPC0096_MemoEditPopup.cs:147 | if (SrcRow != null) | DATA_OP | Filter["PLANT_ID"] | SrcRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-17fb0e8e | this.Load | FPC0096_MemoEditPopup.cs:148 | if (SrcRow != null) | DATA_OP | Filter["FACTORY_ID"] | SrcRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9717922a | this.Load | FPC0096_MemoEditPopup.cs:149 | if (SrcRow != null) | DATA_OP | Filter["OPERATION_ID"] | SrcRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-52201fe2 | this.Load | FPC0096_MemoEditPopup.cs:150 | if (SrcRow != null) | DATA_OP | Filter["TOP_ITEM_ID"] | SrcRow["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-986da521 | this.Load | FPC0096_MemoEditPopup.cs:151 | if (SrcRow != null) | DATA_OP | Filter["PRODUCTION_TYPE"] | SrcRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-32ff5e57 | this.Load | FPC0096_MemoEditPopup.cs:152 | if (SrcRow != null) | DATA_OP | Filter["MARKET"] | SrcRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-79de87d4 | this.Load | FPC0096_MemoEditPopup.cs:153 | if (SrcRow != null) | DATA_OP | Filter["PLAN_DATE"] | Day.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-76ec8899 | this.Load | FPC0096_MemoEditPopup.cs:154 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3acac57c | this.Load | FPC0096_MemoEditPopup.cs:155 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | SrcRow["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-55684d8b | this.Load | FPC0096_MemoEditPopup.cs:157 | if (SrcRow != null) ▸ else of (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-b30a2b56 | this.Load | FPC0096_MemoEditPopup.cs:158 | if (SrcRow != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | SrcRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f012c6df | this.Load | FPC0096_MemoEditPopup.cs:159 | if (SrcRow != null) | DATA_OP | Filter["ITEM_ID"] | SrcRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-44019346 | this.Load | FPC0096_MemoEditPopup.cs:161 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_FROM"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e1a87dbf | this.Load | FPC0096_MemoEditPopup.cs:162 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_TO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e7ec62e1 | this.Load | FPC0096_MemoEditPopup.cs:164 | if (SrcRow != null) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "find_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-97b42c09 | this.Load | FPC0096_MemoEditPopup.cs:168 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo_user | memoInfo.Tables[0].Rows[0]["CREATOR"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-181fd773 | this.Load | FPC0096_MemoEditPopup.cs:169 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo_date | memoInfo.Tables[0].Rows[0]["CREATION"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cd5099d9 | this.Load | FPC0096_MemoEditPopup.cs:170 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo | memoInfo.Tables[0].Rows[0]["MEMO"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0268e068 | this.Load | FPC0096_MemoEditPopup.cs:171 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | bucket_from | memoInfo.Tables[0].Rows[0]["BUCKET_FROM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0bed584e | this.Load | FPC0096_MemoEditPopup.cs:172 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | bucket_to | memoInfo.Tables[0].Rows[0]["BUCKET_TO"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1a069a2e | this.Load | FPC0096_MemoEditPopup.cs:174 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | txtCreator.Text | memo_user | 컨트롤 값 설정 |  |  |  |
| AC-bcc048c7 | this.Load | FPC0096_MemoEditPopup.cs:175 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | txtCreation.Text | memo_date | 컨트롤 값 설정 |  |  |  |
| AC-cde0ce1b | this.Load | FPC0096_MemoEditPopup.cs:176 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | usrTextBox1.Text | memo | 컨트롤 값 설정 |  |  |  |
| AC-04194ba2 | this.Load | FPC0096_MemoEditPopup.cs:177 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | UI_PROP | usrDateRangePicker1.Value1 | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date(bucket_from).DateTime | 속성 Value1 설정 |  |  |  |
| AC-f87fbc58 | this.Load | FPC0096_MemoEditPopup.cs:177 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | CALL_EXT | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date | (bucket_from) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a04d8ef | this.Load | FPC0096_MemoEditPopup.cs:178 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | UI_PROP | usrDateRangePicker1.Value2 | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date(bucket_to).DateTime | 속성 Value2 설정 |  |  |  |
| AC-d17a9939 | this.Load | FPC0096_MemoEditPopup.cs:178 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | CALL_EXT | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date | (bucket_to) | ⚠ 의미 확인 필요 |  |  |  |
| AC-86f6fc8a | this.Load | FPC0096_MemoEditPopup.cs:184 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | MESSAGE | MessageBox.Show | ("You have no right to add memo") | 메시지 표시 |  |  |  |
| AC-916ba2e0 | this.Load | FPC0096_MemoEditPopup.cs:185 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-d39768d3 | this.Load | FPC0096_MemoEditPopup.cs:186 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-331957d1 | this.Load | FPC0096_MemoEditPopup.cs:188 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-308f9421 | this.Load | FPC0096_MemoEditPopup.cs:189 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a21c5547 | this.Load | FPC0096_MemoEditPopup.cs:190 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | usrTextBox1.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-fc7e01ed | this.Load | FPC0096_MemoEditPopup.cs:191 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | UI_PROP | usrDateRangePicker1.Value1 | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date(Filter["PLAN_DATE"]).DateTime | 속성 Value1 설정 |  |  |  |
| AC-b1a4127a | this.Load | FPC0096_MemoEditPopup.cs:191 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | CALL_EXT | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date | (Filter["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9d456352 | this.Load | FPC0096_MemoEditPopup.cs:192 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | UI_PROP | usrDateRangePicker1.Value2 | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date(Filter["PLAN_DATE"]).DateTime | 속성 Value2 설정 |  |  |  |
| AC-a58fc9d9 | this.Load | FPC0096_MemoEditPopup.cs:192 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | CALL_EXT | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date | (Filter["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0087afd | this.Load | FPC0096_MemoEditPopup.cs:193 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | DATA_OP | Filter["BUCKET_FROM"] | usrDateRangePicker1.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b06fd861 | this.Load | FPC0096_MemoEditPopup.cs:194 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | DATA_OP | Filter["BUCKET_TO"] | usrDateRangePicker1.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |


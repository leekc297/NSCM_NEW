# AS-IS 액션 대조표 — FPC0107

> 원천: `Doc/asisfacts/screens/FPC0107/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 66행 · 메서드 6 · 종류 DATA_OP 30 · FLAG 11 · UI_PROP 6 · UI_MISC 4 · CALL_EXT 4 · ENDPOINT 3 · VALUE_SET 3 · VALUE_CLEAR 3 · MESSAGE 2 · ⚠ 의미 확인 필요 4


## FPC0107_MemoReadOnlyPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10f6712e | .ctor | FPC0107_MemoReadOnlyPopup.cs:104 |  | FLAG | SrcRow | row | 화면 필드/플래그 변경 |  |  |  |
| AC-5002fb16 | .ctor | FPC0107_MemoReadOnlyPopup.cs:105 |  | FLAG | iColumn | colindex | 화면 필드/플래그 변경 |  |  |  |
| AC-12b341c8 | .ctor | FPC0107_MemoReadOnlyPopup.cs:106 |  | FLAG | iRow | rowindex | 화면 필드/플래그 변경 |  |  |  |
| AC-0385e3c4 | .ctor | FPC0107_MemoReadOnlyPopup.cs:107 |  | FLAG | Day | date | 화면 필드/플래그 변경 |  |  |  |

## FPC0107_MemoReadOnlyPopup.btnClose_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd137c5f | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:217 | try | DATA_OP | set["BUCKET_FROM"] | usrDateRangePicker1.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-d3df8941 | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:218 | try | DATA_OP | set["BUCKET_TO"] | usrDateRangePicker1.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-464b991a | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:219 | try | DATA_OP | set["MEMO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-98d9da8c | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:220 | try | DATA_OP | set["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7244cf0c | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:221 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "delete_memo", set.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_memo] \| FP\Common\Am… | 엔드포인트 호출 |  |  |  |
| AC-47b008d9 | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:225 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Delete Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-f9d16c52 | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:229 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-e6163bba | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:230 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0107_MemoReadOnlyPopup.btnSave_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63d4661f | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:195 | try | DATA_OP | set["BUCKET_FROM"] | usrDateRangePicker1.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-5f11bae7 | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:196 | try | DATA_OP | set["BUCKET_TO"] | usrDateRangePicker1.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-98be85f1 | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:197 | try | DATA_OP | set["MEMO"] | usrTextBox1.Text | 행/컬럼 값 대입 |  |  |  |
| AC-db1c20fc | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:198 | try | DATA_OP | set["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8b068720 | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:199 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "save_memo", set.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] \| FP\Common\Amen… | 엔드포인트 호출 |  |  |  |
| AC-84b7a564 | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:203 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Save Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-54586167 | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:207 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-293b7f85 | (진입점 미연결) | FPC0107_MemoReadOnlyPopup.cs:208 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0107_MemoReadOnlyPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5acbb867 | Dispose | FPC0107_MemoReadOnlyPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0107_MemoReadOnlyPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48f289cd | this.Load | FPC0107_MemoReadOnlyPopup.cs:117 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e5c964b1 | this.Load | FPC0107_MemoReadOnlyPopup.cs:119 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0107_MemoReadOnlyPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-522fe5ca | this.Load | FPC0107_MemoReadOnlyPopup.cs:129 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb8b1c5f | this.Load | FPC0107_MemoReadOnlyPopup.cs:132 | if (SrcRow != null) | DATA_OP | set["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-948313e3 | this.Load | FPC0107_MemoReadOnlyPopup.cs:133 | if (SrcRow != null) | DATA_OP | set["INSTANCE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0e8452c4 | this.Load | FPC0107_MemoReadOnlyPopup.cs:134 | if (SrcRow != null) | DATA_OP | set["COMPANY_ID"] | SrcRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ae9ad05d | this.Load | FPC0107_MemoReadOnlyPopup.cs:135 | if (SrcRow != null) | DATA_OP | set["DIVISION_ID"] | SrcRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9b25a980 | this.Load | FPC0107_MemoReadOnlyPopup.cs:136 | if (SrcRow != null) | DATA_OP | set["SITE_ID"] | SrcRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e553be94 | this.Load | FPC0107_MemoReadOnlyPopup.cs:137 | if (SrcRow != null) | DATA_OP | set["LINE_ID"] | SrcRow["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-81968e5e | this.Load | FPC0107_MemoReadOnlyPopup.cs:138 | if (SrcRow != null) | DATA_OP | set["PLANT_ID"] | SrcRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-209ea554 | this.Load | FPC0107_MemoReadOnlyPopup.cs:139 | if (SrcRow != null) | DATA_OP | set["FACTORY_ID"] | SrcRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d27b3e1b | this.Load | FPC0107_MemoReadOnlyPopup.cs:140 | if (SrcRow != null) | DATA_OP | set["OPERATION_ID"] | SrcRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-df0c2e0b | this.Load | FPC0107_MemoReadOnlyPopup.cs:141 | if (SrcRow != null) | DATA_OP | set["TOP_ITEM_ID"] | SrcRow["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-47ef6fc0 | this.Load | FPC0107_MemoReadOnlyPopup.cs:142 | if (SrcRow != null) | DATA_OP | set["PRODUCTION_TYPE"] | SrcRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9c068686 | this.Load | FPC0107_MemoReadOnlyPopup.cs:143 | if (SrcRow != null) | DATA_OP | set["MARKET"] | SrcRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-562ae3a3 | this.Load | FPC0107_MemoReadOnlyPopup.cs:144 | if (SrcRow != null) | DATA_OP | set["PLAN_DATE"] | Day.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-e691fb36 | this.Load | FPC0107_MemoReadOnlyPopup.cs:145 | if (SrcRow != null) | DATA_OP | set["EQUIPMENT_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d099b317 | this.Load | FPC0107_MemoReadOnlyPopup.cs:146 | if (SrcRow != null) | DATA_OP | set["ELECTRODE_TYPE"] | SrcRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d6101556 | this.Load | FPC0107_MemoReadOnlyPopup.cs:147 | if (SrcRow != null) | DATA_OP | set["ITEM_ID"] | SrcRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e4570e59 | this.Load | FPC0107_MemoReadOnlyPopup.cs:150 | if (SrcRow != null) ▸ try | DATA_OP | set["MEMO_TYPE"] | SrcRow["MEMO_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0aca9779 | this.Load | FPC0107_MemoReadOnlyPopup.cs:153 | if (SrcRow != null) ▸ catch () | DATA_OP | set["MEMO_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-93e1e60b | this.Load | FPC0107_MemoReadOnlyPopup.cs:155 | if (SrcRow != null) | DATA_OP | set["BUCKET_FROM"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-de3b658c | this.Load | FPC0107_MemoReadOnlyPopup.cs:156 | if (SrcRow != null) | DATA_OP | set["BUCKET_TO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3cefa689 | this.Load | FPC0107_MemoReadOnlyPopup.cs:158 | if (SrcRow != null) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "find_memo", set.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f58d3dc6 | this.Load | FPC0107_MemoReadOnlyPopup.cs:162 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo_user | memoInfo.Tables[0].Rows[0]["CREATOR"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8ae76121 | this.Load | FPC0107_MemoReadOnlyPopup.cs:163 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo_date | memoInfo.Tables[0].Rows[0]["CREATION"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fc2d3435 | this.Load | FPC0107_MemoReadOnlyPopup.cs:164 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo | memoInfo.Tables[0].Rows[0]["MEMO"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-dc835b78 | this.Load | FPC0107_MemoReadOnlyPopup.cs:165 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | bucket_from | memoInfo.Tables[0].Rows[0]["BUCKET_FROM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ee70f107 | this.Load | FPC0107_MemoReadOnlyPopup.cs:166 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | bucket_to | memoInfo.Tables[0].Rows[0]["BUCKET_TO"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-848132c9 | this.Load | FPC0107_MemoReadOnlyPopup.cs:168 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | txtCreator.Text | memo_user | 컨트롤 값 설정 |  |  |  |
| AC-57d07e98 | this.Load | FPC0107_MemoReadOnlyPopup.cs:169 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | txtCreation.Text | memo_date | 컨트롤 값 설정 |  |  |  |
| AC-fd8c548e | this.Load | FPC0107_MemoReadOnlyPopup.cs:170 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | usrTextBox1.Text | memo | 컨트롤 값 설정 |  |  |  |
| AC-bd491fed | this.Load | FPC0107_MemoReadOnlyPopup.cs:171 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | UI_PROP | usrDateRangePicker1.Value1 | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date(bucket_from).DateTime | 속성 Value1 설정 |  |  |  |
| AC-912ac771 | this.Load | FPC0107_MemoReadOnlyPopup.cs:171 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | CALL_EXT | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date | (bucket_from) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0e9dd649 | this.Load | FPC0107_MemoReadOnlyPopup.cs:172 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | UI_PROP | usrDateRangePicker1.Value2 | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date(bucket_to).DateTime | 속성 Value2 설정 |  |  |  |
| AC-e7f8f8a2 | this.Load | FPC0107_MemoReadOnlyPopup.cs:172 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | CALL_EXT | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date | (bucket_to) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f706bb2 | this.Load | FPC0107_MemoReadOnlyPopup.cs:176 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-25420337 | this.Load | FPC0107_MemoReadOnlyPopup.cs:177 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-436056b9 | this.Load | FPC0107_MemoReadOnlyPopup.cs:178 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | usrTextBox1.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c328e25f | this.Load | FPC0107_MemoReadOnlyPopup.cs:179 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | UI_PROP | usrDateRangePicker1.Value1 | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date(set["PLAN_DATE"]).DateTime | 속성 Value1 설정 |  |  |  |
| AC-3e65611a | this.Load | FPC0107_MemoReadOnlyPopup.cs:179 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | CALL_EXT | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date | (set["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f618882c | this.Load | FPC0107_MemoReadOnlyPopup.cs:180 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | UI_PROP | usrDateRangePicker1.Value2 | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date(set["PLAN_DATE"]).DateTime | 속성 Value2 설정 |  |  |  |
| AC-b767489b | this.Load | FPC0107_MemoReadOnlyPopup.cs:180 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | CALL_EXT | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date | (set["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-73838a7a | this.Load | FPC0107_MemoReadOnlyPopup.cs:181 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | DATA_OP | set["BUCKET_FROM"] | usrDateRangePicker1.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-eb89e335 | this.Load | FPC0107_MemoReadOnlyPopup.cs:182 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | DATA_OP | set["BUCKET_TO"] | usrDateRangePicker1.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |


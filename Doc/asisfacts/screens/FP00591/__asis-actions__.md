# AS-IS 액션 대조표 — FP00591

> 원천: `Doc/asisfacts/screens/FP00591/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 620행 · 메서드 42 · 종류 DATA_OP 137 · FLAG 89 · UI_PROP 72 · GRID_SET 70 · RETURN 56 · MESSAGE 46 · ENDPOINT 28 · CALL_EXT 18 · VALUE_SET 15 · UI_MISC 14 · POPUP 14 · COMBO_DATA 13 · GRID_INIT 12 · GRID_LOCK 12 · STATE 5 · THROW 4 · VALIDATE 3 · CALL_BASE 3 · LIST_REBIND 3 · GRID_BIND 2 · GRID_COMBO 2 · EXCEL 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 21


## FP00591_fixOption_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c39f5be2 | .ctor | FP00591_fixOption_Popup.cs:66 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-125f2170 | .ctor | FP00591_fixOption_Popup.cs:67 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-ab2fdee0 | .ctor | FP00591_fixOption_Popup.cs:68 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-67eabdbf | .ctor | FP00591_fixOption_Popup.cs:70 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00591_fixOption_Popup.btnRun_Click

진입점: this.btnRun.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59d1051b | this.btnRun.Click | FP00591_fixOption_Popup.cs:255 | if (rbOpt2.Checked) | FLAG | Selection | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-0c7e2cfe | this.btnRun.Click | FP00591_fixOption_Popup.cs:257 | else of (rbOpt2.Checked) | FLAG | Selection | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-015aa615 | this.btnRun.Click | FP00591_fixOption_Popup.cs:261 | if (string.IsNullOrEmpty(dtpFixDate1.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Fix Date" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a44635fb | this.btnRun.Click | FP00591_fixOption_Popup.cs:262 | if (string.IsNullOrEmpty(dtpFixDate1.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-673d31aa | this.btnRun.Click | FP00591_fixOption_Popup.cs:266 | if (string.IsNullOrEmpty(txt_cellDesc.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Cell Description" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-16b17edc | this.btnRun.Click | FP00591_fixOption_Popup.cs:267 | if (string.IsNullOrEmpty(txt_cellDesc.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-264d1ccd | this.btnRun.Click | FP00591_fixOption_Popup.cs:271 | if (string.IsNullOrEmpty(txt_formDesc.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Form Description" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ee009fe | this.btnRun.Click | FP00591_fixOption_Popup.cs:272 | if (string.IsNullOrEmpty(txt_formDesc.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-646095e7 | this.btnRun.Click | FP00591_fixOption_Popup.cs:276 | if (string.IsNullOrEmpty(txt_elecDesc.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Elec Description" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2820f4bc | this.btnRun.Click | FP00591_fixOption_Popup.cs:277 | if (string.IsNullOrEmpty(txt_elecDesc.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57c2238e | this.btnRun.Click | FP00591_fixOption_Popup.cs:285 | if (int.Parse(sDate1) > int.Parse(sDate2)) | MESSAGE | MessageHelper.GMessageBox | ("Only enter up to the date. : " + dtDefaultDate.Rows[0]["LIMIT_DATE"].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f2d21acd | this.btnRun.Click | FP00591_fixOption_Popup.cs:286 | if (int.Parse(sDate1) > int.Parse(sDate2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0137059d | this.btnRun.Click | FP00591_fixOption_Popup.cs:290 |  | FLAG | FixDate | dtpFixDate1.Value.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-6c837165 | this.btnRun.Click | FP00591_fixOption_Popup.cs:291 |  | FLAG | DescCell | txt_cellDesc.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-2c3a7ae4 | this.btnRun.Click | FP00591_fixOption_Popup.cs:292 |  | FLAG | DescForm | txt_formDesc.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-e504b502 | this.btnRun.Click | FP00591_fixOption_Popup.cs:293 |  | FLAG | DescElec | txt_elecDesc.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-3080d76d | this.btnRun.Click | FP00591_fixOption_Popup.cs:295 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-0da3515e | this.btnRun.Click | FP00591_fixOption_Popup.cs:296 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00591_fixOption_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0ed4b4c | Dispose | FP00591_fixOption_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00591_fixOption_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d803b29 | this.Load | FP00591_fixOption_Popup.cs:113 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00591_fixOption_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed03efba | this.Load | FP00591_fixOption_Popup.cs:81 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0d4ee378 | this.Load | FP00591_fixOption_Popup.cs:89 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-7f5e2066 | this.Load | FP00591_fixOption_Popup.cs:92 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4e55a4c8 | this.Load | FP00591_fixOption_Popup.cs:94 |  | DATA_OP | Filter["PLAN_DATE"] | _PLAN_DATE | 행/컬럼 값 대입 |  |  |  |
| AC-47143c05 | this.Load | FP00591_fixOption_Popup.cs:95 |  | DATA_OP | Filter["TOTAL_INSTANCE_ID"] | _TOTAL_INSTANCE | 행/컬럼 값 대입 |  |  |  |
| AC-619425cf | this.Load | FP00591_fixOption_Popup.cs:97 |  | FLAG | dtDefaultDate | Data_FP.CallGeneralProcedure2(("PR_UI_FP00591_ETC").ToUpper(), Filter, UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-110de929 | this.Load | FP00591_fixOption_Popup.cs:97 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00591_ETC").ToUpper(), Filter, UserInfoContext.Current.UserId, "SELECT", "FIX_D… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a4c067e4 | this.Load | FP00591_fixOption_Popup.cs:108 |  | VALUE_SET | dtpFixDate1.Value | dDate | 컨트롤 값 설정 |  |  |  |

## FP00591_fixOption_Popup.rbOpt1_Click

진입점: rbOpt1.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01ddb46b | rbOpt1.CheckedChanged | FP00591_fixOption_Popup.cs:194 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## FP00591_fixOption_Popup.SetOption

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-347533b9 | (진입점 미연결) | FP00591_fixOption_Popup.cs:120 | if (index == 0) | VALUE_SET | rbOpt1.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-3f7f9eda | (진입점 미연결) | FP00591_fixOption_Popup.cs:122 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rbOpt2.Text | option_name | 컨트롤 값 설정 |  |  |  |

## FP00591_Plan_Control_Integration.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12113e92 | this.btnPlanInfo.Click | FP00591_Plan_Control_Integration.cs:1145 |  | CALL_EXT | dtRevisionDetail.Lookup | ("PLAN_ID", sPlanID, "INSTANCE_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5cb2a96e | this.btnPlanInfo.Click | FP00591_Plan_Control_Integration.cs:1151 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-c934a07d | this.btnPlanInfo.Click | FP00591_Plan_Control_Integration.cs:1152 | if (fc != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d554656 | this.btnPlanInfo.Click | FP00591_Plan_Control_Integration.cs:1155 |  | POPUP | new FP00590_PlanInfoPopup | (sSite, sPlanGroup, sPlanDate, sPlanID) | 팝업/폼 생성 |  |  |  |
| AC-81c7f37b | this.btnPlanInfo.Click | FP00591_Plan_Control_Integration.cs:1156 |  | UI_PROP | popPlanInfo.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-83dcbf99 | this.btnPlanInfo.Click | FP00591_Plan_Control_Integration.cs:1157 |  | POPUP | popPlanInfo.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00591_Plan_Control_Integration.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4580f60 | this.btnSql.Click | FP00591_Plan_Control_Integration.cs:1170 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-491b6ee7 | this.btnSql.Click | FP00591_Plan_Control_Integration.cs:1171 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f0c6a2e8 | this.btnSql.Click | FP00591_Plan_Control_Integration.cs:1173 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00591_PLAN_CONTROL_INTEGRATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-19b9525d | this.btnSql.Click | FP00591_Plan_Control_Integration.cs:1174 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00590_VALIDATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-e97a2415 | this.btnSql.Click | FP00591_Plan_Control_Integration.cs:1175 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00590_ENGINE_RUN") | 데이터 객체 조작/조회 |  |  |  |
| AC-b09129ed | this.btnSql.Click | FP00591_Plan_Control_Integration.cs:1176 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00591_Plan_Control_Integration.CboPlanGroup_SelectedIndexChanged

진입점: cboPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bbff25b | cboPlanGroup.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:1212 | try | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-900ce224 | cboPlanGroup.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:1213 | try | DATA_OP | Filter["INTG_PLAN_ID"] | cboPlanGroup.Text | 행/컬럼 값 대입 |  |  |  |
| AC-7e930fc1 | cboPlanGroup.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:1214 | try | FLAG | dtLocalPlanGroupDetail | DataService.FP_ExecuteQuery2("FP00591", "findInstanceList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] \| FP\Plannin… | 화면 필드/플래그 변경 |  |  |  |
| AC-ada3b345 | cboPlanGroup.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:1214 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findInstanceList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-97fa7967 | cboPlanGroup.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:1219 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", sDataID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c413ce76 | cboPlanGroup.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:1224 | try | VALUE_SET | dtpPlanDate.Value | DateTime.ParseExact(sDate, "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |

## FP00591_Plan_Control_Integration.ChartThread_Start

진입점: this.chkStatus.CheckedChanged [if (chkStatus.Checked == true)] / this.Activated [if (chkStatus.Checked == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df1d9e66 | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00591_Plan_Control_Integration.cs:1295 | try ▸ if (siMain.ActiveSheet.Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43512e72 | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00591_Plan_Control_Integration.cs:1297 | try ▸ if (string.IsNullOrEmpty(siMain.GetValue(3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)).ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e43e03f9 | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00591_Plan_Control_Integration.cs:1299 | try | FLAG | _DoEngineRunSelectEvent1 | null | 화면 필드/플래그 변경 |  |  |  |
| AC-931cc78b | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00591_Plan_Control_Integration.cs:1305 | try ▸ if (_EngineRunthread != null) | CALL_EXT | _EngineRunthread.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ee0f9cb | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00591_Plan_Control_Integration.cs:1306 | try ▸ if (_EngineRunthread != null) | FLAG | _EngineRunthread | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6250a918 | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00591_Plan_Control_Integration.cs:1308 | try | FLAG | _EngineRunthread | new Thread(new ThreadStart(ExcuteEventEngineRunThread)) | 화면 필드/플래그 변경 |  |  |  |
| AC-1963d715 | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00591_Plan_Control_Integration.cs:1309 | try | CALL_EXT | _EngineRunthread.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-921661ad | this.chkStatus.CheckedChanged [if (chkStatus.Checked == true… 외 1 | FP00591_Plan_Control_Integration.cs:1310 | try | UI_PROP | _EngineRunthread.IsBackground | true | 속성 IsBackground 설정 |  |  |  |

## FP00591_Plan_Control_Integration.chkStatus_CheckedChanged

진입점: this.chkStatus.CheckedChanged / this.Activated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-332e9a70 | this.chkStatus.CheckedChanged 외 1 | FP00591_Plan_Control_Integration.cs:1282 | else of (chkStatus.Checked == true) ▸ if (_EngineRunthread != null) | CALL_EXT | _EngineRunthread.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-411922fc | this.chkStatus.CheckedChanged 외 1 | FP00591_Plan_Control_Integration.cs:1283 | else of (chkStatus.Checked == true) ▸ if (_EngineRunthread != null) | FLAG | _EngineRunthread | null | 화면 필드/플래그 변경 |  |  |  |

## FP00591_Plan_Control_Integration.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-588e3189 | this.Load | FP00591_Plan_Control_Integration.cs:341 | try | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-01f3c5a5 | this.Load | FP00591_Plan_Control_Integration.cs:342 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-6d0e5880 | this.Load | FP00591_Plan_Control_Integration.cs:343 | try | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c20083f | this.Load | FP00591_Plan_Control_Integration.cs:347 | try | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cf768949 | this.Load | FP00591_Plan_Control_Integration.cs:348 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-f80fa1df | this.Load | FP00591_Plan_Control_Integration.cs:349 | try | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5bb03bbb | this.Load | FP00591_Plan_Control_Integration.cs:357 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-653adeca | this.Load | FP00591_Plan_Control_Integration.cs:358 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00591_Plan_Control_Integration.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05c01cd2 | this.Load | FP00591_Plan_Control_Integration.cs:217 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-ee56d65e | this.Load | FP00591_Plan_Control_Integration.cs:219 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-ce82f095 | this.Load | FP00591_Plan_Control_Integration.cs:220 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-6c067733 | this.Load | FP00591_Plan_Control_Integration.cs:221 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP00591_Plan_Control_Integration.DisplayEngineRunData

진입점: this._DoEngineRunSelectEvent1

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fffe292c | this._DoEngineRunSelectEvent1 | FP00591_Plan_Control_Integration.cs:1352 | try | CALL_EXT | spdMain.Invoke | (new MethodInvoker(delegate () { FindData_Sub(sPlanGroup, sPlanId); })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2a12c0c | this._DoEngineRunSelectEvent1 | FP00591_Plan_Control_Integration.cs:1360 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00591_Plan_Control_Integration.Dispose

진입점: this.FormClosing / Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86a50f00 | this.FormClosing 외 1 | FP00591_Plan_Control_Integration.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00591_Plan_Control_Integration.dtpPlanDate_ValueChanged

진입점: this.dtpPlanDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2102f4f9 | this.dtpPlanDate.ValueChanged | FP00591_Plan_Control_Integration.cs:1191 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-69420f7a | this.dtpPlanDate.ValueChanged | FP00591_Plan_Control_Integration.cs:1199 | if (Convert.ToDecimal(sPlanData) > Convert.ToDecimal(sUTDate)) | MESSAGE | MessageBox.Show | ("Future dates can not be selected. (Including basis time)") | 메시지 표시 |  |  |  |
| AC-c839fd2d | this.dtpPlanDate.ValueChanged | FP00591_Plan_Control_Integration.cs:1201 | if (Convert.ToDecimal(sPlanData) > Convert.ToDecimal(sUTDate)) | VALUE_SET | dtpPlanDate.Value | DateTime.ParseExact(sSetDate, "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |

## FP00591_Plan_Control_Integration.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fa0e1b6 | EditButton | FP00591_Plan_Control_Integration.cs:451 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5f23d40 | EditButton | FP00591_Plan_Control_Integration.cs:455 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |

## FP00591_Plan_Control_Integration.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a89d521 | ExcelButton | FP00591_Plan_Control_Integration.cs:501 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00591_Plan_Control_Integration.Excute_Valid

진입점: this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes)] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-210288b6 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:839 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d889fbb5 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:841 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f79fc59 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:846 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb9086f4 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:847 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3fc6d178 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:850 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-45575797 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:857 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-8594499a | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:859 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5810cc32 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:860 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38761233 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:874 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | proxyPivot.ExecuteAsync | (() => ExcuteRunValidation(pProcName, pSite, pPlanGroup, pPlanID, pPlanDate) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a32b9f10 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:879 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9d243cbf | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:886 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "1") | MESSAGE | MessageBox.Show | ("Validation Execute Complete!", "Confrim", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-286a0536 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:898 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "1") | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0faf9ee3 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:904 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6eb55677 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:909 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-df74b5bf | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:910 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9dcdeb1c | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:915 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-70d289f4 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:916 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00591_Plan_Control_Integration.ExcuteEventEngineRunThread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcb465fd | (진입점 미연결) | FP00591_Plan_Control_Integration.cs:1328 | while (true) ▸ try | CALL_EXT | spdMain.Invoke | (new MethodInvoker(delegate () { pPlanGroup = CString.GetCheckedListValue(dtLocalPlanGroup… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2b2a5be | (진입점 미연결) | FP00591_Plan_Control_Integration.cs:1333 | while (true) ▸ try ▸ lambda | CALL_BASE | _DoEngineRunSelectEvent1 | (pPlanGroup, pPlanID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4beda588 | (진입점 미연결) | FP00591_Plan_Control_Integration.cs:1337 | while (true) ▸ try | CALL_EXT | Thread.Sleep | (5000) | ⚠ 의미 확인 필요 |  |  |  |

## FP00591_Plan_Control_Integration.ExcuteRunValidation

진입점: this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f69b8c6a | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:928 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00591_Plan_Control_Integration") ⇒ FP_Planning.PR_UI_FP00591_Plan_Control_Integration | 엔드포인트 요청 생성 |  |  |  |
| AC-633fc172 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:929 | try | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ddd6edba | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:931 | try | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-f434b268 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:932 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_VALIDATION" | 행/컬럼 값 대입 |  |  |  |
| AC-164e7348 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:933 | try | DATA_OP | request.Parameters["p_sys_gubun"] | pProcName | 행/컬럼 값 대입 |  |  |  |
| AC-bcb19692 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:934 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-058826c7 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:935 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-eb8565ec | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:936 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-2f9faa4f | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:937 | try | DATA_OP | request.Parameters["p_plan_date"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-56c78c61 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:938 | try | DATA_OP | request.Parameters["p_plan_id"] | pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-ffbb1c26 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:939 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-532efeb6 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:940 | try | DATA_OP | request.Parameters["p_plan_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b7016cce | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:941 | try | DATA_OP | request.Parameters["p_demand_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d4fb4541 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:942 | try | DATA_OP | request.Parameters["p_basis_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-47936563 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:943 | try | DATA_OP | request.Parameters["p_pre_fix_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f3b77571 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:944 | try | DATA_OP | request.Parameters["p_pre_fix_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f9d25388 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:945 | try | DATA_OP | request.Parameters["p_sync_operation"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a82ae174 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:946 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8ce0ab62 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:947 | try | DATA_OP | request.Parameters["p_pre_fix_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-76740b8d | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:948 | try | DATA_OP | request.Parameters["p_pre_fix_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6aef02a9 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:949 | try | DATA_OP | request.Parameters["p_pre_fix_2_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3fda1668 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:950 | try | DATA_OP | request.Parameters["p_pre_fix_date2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1b162add | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:951 | try | DATA_OP | request.Parameters["p_pre_fix_type2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7cfc5953 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:952 | try | DATA_OP | request.Parameters["p_wow_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-90a76048 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:954 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-490ddcdf | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:955 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-005a91e6 | this.spdMain.CellClick [if (siMain != null) ▸ if (e.Row == 1… 외 1 | FP00591_Plan_Control_Integration.cs:960 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00591_Plan_Control_Integration.Find_Data_Main

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ else of (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_05_NAME)) ▸ if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4da3c4e4 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:638 |  | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00591_PLAN_CONTROL_INTEGRATION") ⇒ FP_Planning.PR_UI_FP00591_PLAN_CONTROL_INTEGRATION | 엔드포인트 요청 생성 |  |  |  |
| AC-0bf32eed | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:640 |  | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3e1c5d9b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:642 |  | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-b5a150fe | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:643 |  | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_CONTROL" | 행/컬럼 값 대입 |  |  |  |
| AC-97985acf | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:644 |  | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cf16cd44 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:645 |  | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-39f0ba86 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:646 |  | DATA_OP | request.Parameters["p_site_id"] | pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-cf15f803 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:647 |  | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-4b0a73c9 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:648 |  | DATA_OP | request.Parameters["p_plan_date"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-42935858 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:649 |  | DATA_OP | request.Parameters["p_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e28140e2 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:650 |  | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-af4999b4 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:651 |  | DATA_OP | request.Parameters["p_plan_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9a522208 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:652 |  | DATA_OP | request.Parameters["p_demand_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ba3113b3 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:653 |  | DATA_OP | request.Parameters["p_basis_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-458b647d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:654 |  | DATA_OP | request.Parameters["p_pre_fix_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-55cab909 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:655 |  | DATA_OP | request.Parameters["p_pre_fix_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-06e26863 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:656 |  | DATA_OP | request.Parameters["p_sync_operation"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3213957a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:657 |  | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-363fb637 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:658 |  | DATA_OP | request.Parameters["p_pre_fix_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4ab8010c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:659 |  | DATA_OP | request.Parameters["p_pre_fix_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a0a060a6 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:660 |  | DATA_OP | request.Parameters["p_pre_fix_2_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-01ff2f0d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:661 |  | DATA_OP | request.Parameters["p_pre_fix_date2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-51f0d2c6 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:662 |  | DATA_OP | request.Parameters["p_pre_fix_type2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5561a135 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:663 |  | DATA_OP | request.Parameters["p_wow_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2b937992 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:665 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6482259f | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 3 | FP00591_Plan_Control_Integration.cs:667 |  | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |

## FP00591_Plan_Control_Integration.Find_Data_Sub

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (dtRevision.Rows.Count > 0) ▸ try ▸ lambda] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (dtRevision.Rows.Count > 0) ▸ try ▸ lambda] / this.spdMain.ComboSelChange [if (e.Row == 3 && e.Column == siMain.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bd56911 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00591_Plan_Control_Integration.cs:824 | try | DATA_OP | Filter["INTG_PLAN_ID"] | pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-8af57d36 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00591_Plan_Control_Integration.cs:826 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00591", "findEngineRun", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findEngineRun] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f48c8195 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00591_Plan_Control_Integration.cs:828 | try | RETURN | return dsTmp; |  | 처리 중단/반환 |  |  |  |
| AC-216e87ce | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 6 | FP00591_Plan_Control_Integration.cs:832 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00591_Plan_Control_Integration.FindData_Main

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ else of (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_05_NAME)) ▸ if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-262918bb | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:512 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b97d9616 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:517 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b8da2c5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:518 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b795bfb | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:521 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2a58aaa5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:522 | try | FLAG | blnCreateRun | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c257fb31 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:528 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-80c7f5e6 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:528 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6915fc82 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:534 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e8a6027b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:537 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-95512214 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:548 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Main(pSiteID, pPlanGroup, pPlanDate, "SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a270e434 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:553 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (ds != null) { //조회 End 시간 및 UI 시작 시간 SearchEndTime();… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ddace8d4 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:561 | try ▸ lambda ▸ if (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9f37592d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:566 | try ▸ lambda ▸ if (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b0638293 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:581 | try ▸ lambda ▸ if (ds != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.Rows[0, siMain.GetMaxRowIndex()].Height | 40 | 그리드 속성/값 설정 |  |  |  |
| AC-f0a36476 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:592 | try ▸ lambda ▸ if (ds != null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_runValidationMaster", pPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4cae4c7a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:596 | try ▸ lambda ▸ if (ds != null) ▸ if (dtValidation.Rows.Count == 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a5a24251 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:598 | try ▸ lambda ▸ if (ds != null) ▸ if (dtValidation.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc204c17 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:613 | try ▸ lambda ▸ if (ds != null) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-fc11e631 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:614 | try ▸ lambda ▸ if (ds != null) | DATA_OP | Filter["INTG_PLAN_ID"] | CString.GetCheckedListValue(dtLocalPlanGroup, cboPlanGroup.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-6cb98326 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:615 | try ▸ lambda ▸ if (ds != null) | FLAG | dtLocalPlanGroupDetail | DataService.FP_ExecuteQuery2("FP00591", "findInstanceList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] \| FP\Plannin… | 화면 필드/플래그 변경 |  |  |  |
| AC-3318127e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:615 | try ▸ lambda ▸ if (ds != null) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findInstanceList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-88304c23 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:626 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-adf4f853 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:627 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-39575e3e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:628 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00591_Plan_Control_Integration.FindData_Sub

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (dtRevision.Rows.Count > 0)] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (dtRevision.Rows.Count > 0)] / this.spdMain.ComboSelChange [if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTI…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-942bac88 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:675 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-10891c0c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:680 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-bcaa0ad3 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:680 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d474672 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:689 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53b3ba83 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:694 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { ds = Find_Data_Sub("SELECT", pPlanGroup, pPlanID); ////조회… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f6ce7bc2 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:702 | try ▸ lambda | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8a34346b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:716 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ if (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-423bb29b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:720 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-38cf75b0 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:721 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP2)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-39de158d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:725 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-7b2ad357 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:726 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP2)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-5ba46968 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:727 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP3)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-9c227ba8 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:731 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP1)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-f322de54 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:732 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP2)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-72ddb09c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:733 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP3)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-3509888d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:734 | try ▸ lambda ▸ if (ds != null) ▸ for (i < ds.Tables[0].Rows.Count) ▸ else of (ds.Tables[0].Rows[i]["STATUS_STEP"].ToString().Equals("1")) ▸ … | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.STATUS_STEP4)].BackColor | System.Drawing.Color.Lime | 그리드 속성/값 설정 |  |  |  |
| AC-4fb21c5a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:746 | try ▸ lambda ▸ if (ds != null) ▸ if (blnCreateRun == true) ▸ if (ds.Tables[0].Rows[0]["STATUS_FLAG"].ToString() == "C" && ds.Tables[0].Rows[… | VALUE_SET | chkStatus.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-0c8f4e5c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:747 | try ▸ lambda ▸ if (ds != null) ▸ if (blnCreateRun == true) ▸ if (ds.Tables[0].Rows[0]["STATUS_FLAG"].ToString() == "C" && ds.Tables[0].Rows[… | FLAG | blnCreateRun | false | 화면 필드/플래그 변경 |  |  |  |
| AC-907ff5a2 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:749 | try ▸ lambda ▸ if (ds != null) ▸ if (blnCreateRun == true) ▸ if (ds.Tables[0].Rows[0]["STATUS_FLAG"].ToString() == "C" && ds.Tables[0].Rows[… | MESSAGE | MessageBox.Show | ("FP Engine Completed!", "Complete", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-918f68ba | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 5 | FP00591_Plan_Control_Integration.cs:777 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00591_Plan_Control_Integration.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-922cab93 | this.Load | FP00591_Plan_Control_Integration.cs:192 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00591_Plan_Control_Integration.FP00591_Plan_Control_Integration_Deactivate

진입점: this.Deactivate

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6ecbbb8 | this.Deactivate | FP00591_Plan_Control_Integration.cs:2186 | if (_EngineRunthread != null) | CALL_EXT | _EngineRunthread.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-25b1e459 | this.Deactivate | FP00591_Plan_Control_Integration.cs:2187 | if (_EngineRunthread != null) | FLAG | _EngineRunthread | null | 화면 필드/플래그 변경 |  |  |  |

## FP00591_Plan_Control_Integration.FP00591_Plan_Control_Integration_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-767ecdf8 | this.FormClosing | FP00591_Plan_Control_Integration.cs:2195 | if (_EngineRunthread != null) ▸ if (!_EngineRunthread.Join(500)) | CALL_EXT | _EngineRunthread.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d95308bb | this.FormClosing | FP00591_Plan_Control_Integration.cs:2197 | if (_EngineRunthread != null) | FLAG | _EngineRunthread | null | 화면 필드/플래그 변경 |  |  |  |
| AC-19c641d5 | this.FormClosing | FP00591_Plan_Control_Integration.cs:2203 | if (EngineRunTimer != null) | CALL_EXT | EngineRunTimer.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7cb8b80 | this.FormClosing | FP00591_Plan_Control_Integration.cs:2204 | if (EngineRunTimer != null) | UI_MISC | EngineRunTimer.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-1c183b77 | this.FormClosing | FP00591_Plan_Control_Integration.cs:2205 | if (EngineRunTimer != null) | FLAG | EngineRunTimer | null | 화면 필드/플래그 변경 |  |  |  |

## FP00591_Plan_Control_Integration.GetStepValid

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ else of (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_05_NAME)) ▸ if (sConfirmArea == "PLAN GROUP") ▸ if (sUseWoWStatus.Equals("Y"))] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ el…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3a732d3 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:2463 |  | FLAG | dtStepValid | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_getStepValid", pPlanG… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-9af6f557 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:2463 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_getStepValid", pPlanGroup, pPlanDate, pStep) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-36a86e4e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:2477 | else of (UserInfoContext.Current.UserId == "pangaowei") ▸ if (dtStepValid.Rows.Count > 0) ▸ if (dtStepValid.Rows[0]["CHECK_FLAG"].ToString()… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-beebf30a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:2489 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## FP00591_Plan_Control_Integration.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4408723 | this.Load | FP00591_Plan_Control_Integration.cs:230 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c64f18d1 | this.Load | FP00591_Plan_Control_Integration.cs:236 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b8752c2e | this.Load | FP00591_Plan_Control_Integration.cs:237 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-cf6314b2 | this.Load | FP00591_Plan_Control_Integration.cs:242 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-cda167ec | this.Load | FP00591_Plan_Control_Integration.cs:244 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-37679eee | this.Load | FP00591_Plan_Control_Integration.cs:247 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e7efd005 | this.Load | FP00591_Plan_Control_Integration.cs:251 | try | FLAG | dtSite | DataService.FP_ExecuteQuery2("FP00591", "findSiteList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSiteList] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-7ef88c12 | this.Load | FP00591_Plan_Control_Integration.cs:251 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findSiteList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSiteList] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3ccde100 | this.Load | FP00591_Plan_Control_Integration.cs:252 | try | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-19d02889 | this.Load | FP00591_Plan_Control_Integration.cs:255 | try | DATA_OP | Filter["SITE_ID"] | sDataID | 행/컬럼 값 대입 |  |  |  |
| AC-16c2e5c8 | this.Load | FP00591_Plan_Control_Integration.cs:259 | try | FLAG | dtLocalPlanGroup | DataService.FP_ExecuteQuery2("FP00591", "findTotalInstanceList", Filter.Dictionary, "Plann… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalInstanceList] \| FP\Pl… | 화면 필드/플래그 변경 |  |  |  |
| AC-40f5c7c8 | this.Load | FP00591_Plan_Control_Integration.cs:259 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findTotalInstanceList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalInstanceList] \| FP\Pl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-32c5408d | this.Load | FP00591_Plan_Control_Integration.cs:260 | try | LIST_REBIND | clsCtrl.setListBox | (dtLocalPlanGroup, cboPlanGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8c54b5c8 | this.Load | FP00591_Plan_Control_Integration.cs:267 | try | DATA_OP | Filter["INTG_PLAN_ID"] | sDataID | 행/컬럼 값 대입 |  |  |  |
| AC-4d15198f | this.Load | FP00591_Plan_Control_Integration.cs:268 | try | FLAG | dtLocalPlanGroupDetail | DataService.FP_ExecuteQuery2("FP00591", "findInstanceList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] \| FP\Plannin… | 화면 필드/플래그 변경 |  |  |  |
| AC-7f73f433 | this.Load | FP00591_Plan_Control_Integration.cs:268 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findInstanceList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-97e8bc6d | this.Load | FP00591_Plan_Control_Integration.cs:270 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", sDataID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c2e52dcf | this.Load | FP00591_Plan_Control_Integration.cs:274 | try | VALUE_SET | dtpPlanDate.Value | DateTime.ParseExact(sDate, "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-7b233c31 | this.Load | FP00591_Plan_Control_Integration.cs:280 | try ▸ if (_EngineRunthread != null) | CALL_EXT | _EngineRunthread.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-30e46ead | this.Load | FP00591_Plan_Control_Integration.cs:281 | try ▸ if (_EngineRunthread != null) | FLAG | _EngineRunthread | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f57e408c | this.Load | FP00591_Plan_Control_Integration.cs:288 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-d3c96035 | this.Load | FP00591_Plan_Control_Integration.cs:289 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e7f4c696 | this.Load | FP00591_Plan_Control_Integration.cs:290 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9940b03f | this.Load | FP00591_Plan_Control_Integration.cs:296 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-a6909306 | this.Load | FP00591_Plan_Control_Integration.cs:297 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00591_Plan_Control_Integration.InitSpread

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd756fe9 | this.Load [try] | FP00591_Plan_Control_Integration.cs:370 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-fdaf2f1f | this.Load [try] | FP00591_Plan_Control_Integration.cs:373 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-c60d86c3 | this.Load [try] | FP00591_Plan_Control_Integration.cs:378 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bae9b16e | this.Load [try] | FP00591_Plan_Control_Integration.cs:381 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a48d4816 | this.Load [try] | FP00591_Plan_Control_Integration.cs:382 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INSTANCE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c9baa839 | this.Load [try] | FP00591_Plan_Control_Integration.cs:383 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.WOW_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3e4c5886 | this.Load [try] | FP00591_Plan_Control_Integration.cs:384 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ROLE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-158343e2 | this.Load [try] | FP00591_Plan_Control_Integration.cs:385 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ROLE_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-576c25e4 | this.Load [try] | FP00591_Plan_Control_Integration.cs:386 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_SEQ)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c9ad264e | this.Load [try] | FP00591_Plan_Control_Integration.cs:387 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_01_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ba8b1406 | this.Load [try] | FP00591_Plan_Control_Integration.cs:388 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_01_VALUE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2179fc73 | this.Load [try] | FP00591_Plan_Control_Integration.cs:389 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_02_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7c3373b6 | this.Load [try] | FP00591_Plan_Control_Integration.cs:390 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_02_VALUE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ecd2f66a | this.Load [try] | FP00591_Plan_Control_Integration.cs:391 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_03_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-27aaba90 | this.Load [try] | FP00591_Plan_Control_Integration.cs:392 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_03_VALUE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cc3c42a2 | this.Load [try] | FP00591_Plan_Control_Integration.cs:393 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_03_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-88895139 | this.Load [try] | FP00591_Plan_Control_Integration.cs:394 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_04_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fbf8155e | this.Load [try] | FP00591_Plan_Control_Integration.cs:395 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_04_VALUE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c3438a65 | this.Load [try] | FP00591_Plan_Control_Integration.cs:396 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_05_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6e90f28b | this.Load [try] | FP00591_Plan_Control_Integration.cs:397 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_05_VALUE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8461767c | this.Load [try] | FP00591_Plan_Control_Integration.cs:398 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_06_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a6e2a7f9 | this.Load [try] | FP00591_Plan_Control_Integration.cs:399 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_06_VALUE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4908d009 | this.Load [try] | FP00591_Plan_Control_Integration.cs:400 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ACTION_06_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2e0abf15 | this.Load [try] | FP00591_Plan_Control_Integration.cs:401 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_DATE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c8a17524 | this.Load [try] | FP00591_Plan_Control_Integration.cs:402 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_USER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e54e92df | this.Load [try] | FP00591_Plan_Control_Integration.cs:409 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8febc3c6 | this.Load [try] | FP00591_Plan_Control_Integration.cs:412 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-53b308af | this.Load [try] | FP00591_Plan_Control_Integration.cs:414 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7236b904 | this.Load [try] | FP00591_Plan_Control_Integration.cs:417 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ENGINE_STATUS)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-19292efd | this.Load [try] | FP00591_Plan_Control_Integration.cs:418 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.STATUS_FLAG)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3749964b | this.Load [try] | FP00591_Plan_Control_Integration.cs:419 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-606e19e8 | this.Load [try] | FP00591_Plan_Control_Integration.cs:420 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.STATUS_START)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-87b2e6bc | this.Load [try] | FP00591_Plan_Control_Integration.cs:421 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.STATUS_END)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fa1dabf6 | this.Load [try] | FP00591_Plan_Control_Integration.cs:424 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.ENGINE_STATUS), siSub.GetColumnIndex(DefColumns.STATUS_MS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4c7f6243 | this.Load [try] | FP00591_Plan_Control_Integration.cs:432 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00591_Plan_Control_Integration.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50124293 | popSql.OnSql | FP00591_Plan_Control_Integration.cs:2234 | if (programID == "PR_UI_FP00591_PLAN_CONTROL_INTEGRATION") | RETURN | return Find_Data_Main(pSiteID, pPlanGroup, pPlanDate, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-b584feae | popSql.OnSql | FP00591_Plan_Control_Integration.cs:2242 | else of (programID == "PR_UI_FP00591_PLAN_CONTROL_INTEGRATION") ▸ if (programID == "PR_UI_FP00590_VALIDATION") | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc4e7112 | popSql.OnSql | FP00591_Plan_Control_Integration.cs:2243 | else of (programID == "PR_UI_FP00591_PLAN_CONTROL_INTEGRATION") ▸ if (programID == "PR_UI_FP00590_VALIDATION") | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_AF_MASTER_VALIDATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-e0ac673f | popSql.OnSql | FP00591_Plan_Control_Integration.cs:2244 | else of (programID == "PR_UI_FP00591_PLAN_CONTROL_INTEGRATION") ▸ if (programID == "PR_UI_FP00590_VALIDATION") | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-f20bc39e | popSql.OnSql | FP00591_Plan_Control_Integration.cs:2245 | else of (programID == "PR_UI_FP00591_PLAN_CONTROL_INTEGRATION") ▸ if (programID == "PR_UI_FP00590_VALIDATION") | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-48aa7a12 | popSql.OnSql | FP00591_Plan_Control_Integration.cs:2256 | else of (programID == "PR_UI_FP00591_PLAN_CONTROL_INTEGRATION") ▸ else of (programID == "PR_UI_FP00590_VALIDATION") ▸ if (programID == "PR_U… | RETURN | return Find_Data_Sub("SQL", pPlanGroup, pPlanID); |  | 처리 중단/반환 |  |  |  |
| AC-e1f87828 | popSql.OnSql | FP00591_Plan_Control_Integration.cs:2260 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00591_Plan_Control_Integration.Save_End_Action

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ else of (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_05_NAME)) ▸ if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.A…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c06449cc | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:972 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c1b5af18 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:973 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4572b9ae | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:976 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-108fd18d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:986 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9276f063 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1002 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-169c0803 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1008 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-924b0cfd | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1012 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-10345469 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1013 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { ex.Message.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c2d9a4d4 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1018 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e83009fb | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1019 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00591_Plan_Control_Integration.Save_End_Action_Run

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ else of (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_05_NAME)) ▸ if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (siMain != null) ▸ else of (e.Row == 1…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ed6dd83 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1069 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00591_Plan_Control_Integration") ⇒ FP_Planning.PR_UI_FP00591_Plan_Control_Integration | 엔드포인트 요청 생성 |  |  |  |
| AC-bf447022 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1070 | try | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2f05bf5f | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1072 | try | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-570ac292 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1073 | try | DATA_OP | request.Parameters["p_sys_flag"] | "UPDATE_STATUS" | 행/컬럼 값 대입 |  |  |  |
| AC-daa95ec0 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1074 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-25485cab | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1075 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-55f1f0bf | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1076 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-4b4ac27b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1077 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-0d906b06 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1078 | try | DATA_OP | request.Parameters["p_plan_date"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-bdec1120 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1079 | try | DATA_OP | request.Parameters["p_plan_id"] | pPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-9f109f8f | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1080 | try | DATA_OP | request.Parameters["p_plan_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-38e377e9 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1081 | try | DATA_OP | request.Parameters["p_plan_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e0021138 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1082 | try | DATA_OP | request.Parameters["p_demand_horizon"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5b4dd300 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1083 | try | DATA_OP | request.Parameters["p_basis_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7c10549e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1084 | try | DATA_OP | request.Parameters["p_pre_fix_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c90c05f5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1085 | try | DATA_OP | request.Parameters["p_pre_fix_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2c94d908 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1086 | try | DATA_OP | request.Parameters["p_sync_operation"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a68f5349 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1087 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-24aba416 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1088 | try | DATA_OP | request.Parameters["p_pre_fix_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-810412dd | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1089 | try | DATA_OP | request.Parameters["p_pre_fix_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-07356f7b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1090 | try | DATA_OP | request.Parameters["p_pre_fix_2_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-38be9d2e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1091 | try | DATA_OP | request.Parameters["p_pre_fix_date2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e70f9c4a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1092 | try | DATA_OP | request.Parameters["p_pre_fix_type2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b8a2300a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1093 | try | DATA_OP | request.Parameters["p_wow_id"] | p_wow_id | 행/컬럼 값 대입 |  |  |  |
| AC-b55ebea0 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1095 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b62f39d6 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1096 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b0576edf | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 1 | FP00591_Plan_Control_Integration.cs:1108 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00591_Plan_Control_Integration.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4766ee3 | SaveButton | FP00591_Plan_Control_Integration.cs:487 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9354ee91 | SaveButton | FP00591_Plan_Control_Integration.cs:488 |  | MESSAGE | MessageBox.Show | ("Save button[F7] can't use!") | 메시지 표시 |  |  |  |

## FP00591_Plan_Control_Integration.SetChangedControl

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c16fec9 | cboSite.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:313 | try | FLAG | dtLocalPlanGroup | DataService.FP_ExecuteQuery2("FP00591", "findTotalInstanceList", Filter.Dictionary, "Plann… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalInstanceList] \| FP\Pl… | 화면 필드/플래그 변경 |  |  |  |
| AC-840b4d8b | cboSite.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:313 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findTotalInstanceList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalInstanceList] \| FP\Pl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fe6afaa5 | cboSite.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:314 | try | LIST_REBIND | clsCtrl.setListBox | (dtLocalPlanGroup, cboPlanGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8b117622 | cboSite.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:317 | try | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-c20dbea9 | cboSite.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:318 | try | DATA_OP | Filter["INTG_PLAN_ID"] | dtLocalPlanGroup.Rows[0]["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c0382567 | cboSite.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:319 | try | FLAG | dtLocalPlanGroupDetail | DataService.FP_ExecuteQuery2("FP00591", "findInstanceList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] \| FP\Plannin… | 화면 필드/플래그 변경 |  |  |  |
| AC-4f16012d | cboSite.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:319 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findInstanceList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-addf8f7b | cboSite.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:324 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-69519e38 | cboSite.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:329 | try | VALUE_SET | dtpPlanDate.Value | DateTime.ParseExact(sDate, "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-1e435461 | cboSite.SelectedIndexChanged | FP00591_Plan_Control_Integration.cs:333 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |

## FP00591_Plan_Control_Integration.SetInitMainSheetByRevision

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ else of (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_05_NAME)) ▸ if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3711742 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2276 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) | DATA_OP | dtResult.Columns.Add | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-653ce89d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2277 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) | DATA_OP | dtResult.Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-68366dcd | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2278 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) | DATA_OP | dtResult.Columns.Add | ("PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-541cd31c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2279 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) | DATA_OP | dtResult.Columns.Add | ("PLAN_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-198ff558 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2280 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) | DATA_OP | dtResult.Columns.Add | ("DESCRIPTION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-53dbc1f8 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2281 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) | DATA_OP | dtResult.Columns.Add | ("INSERT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d2bda1a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2282 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) | DATA_OP | dtResult.Columns.Add | ("INSERT_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f216310b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2283 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) | DATA_OP | dtResult.Columns.Add | ("CONFIRM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ac74fd9 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2284 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) | DATA_OP | dtResult.Columns.Add | ("CONFIRM_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bbd6875b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2287 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) | DATA_OP | dRow.Field | ("PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2c3f4a6a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2303 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString(), row.col3.ToString(), row.col4.ToString(), row.c… | 데이터 객체 조작/조회 |  |  |  |
| AC-bf7ba5af | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2308 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) ▸ if (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.INSERT_ID), dtResult.Rows[0]["INSERT_ID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-ddaada23 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2309 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) ▸ if (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.DESCRIPTION), dtResult.Rows[0]["DESCRIPTION"].ToStrin… | 그리드 값 설정 |  |  |  |
| AC-2f2f4658 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2310 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) ▸ if (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.CONFIRM_ID), dtResult.Rows[0]["CONFIRM_ID"].ToString(… | 그리드 값 설정 |  |  |  |
| AC-db587193 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2311 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) ▸ if (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.CONFIRM_DATE), dtResult.Rows[0]["CONFIRM_TIME"].ToStr… | 그리드 값 설정 |  |  |  |
| AC-2c318a09 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2315 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) ▸ else of (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.INSERT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-649ee282 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2316 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) ▸ else of (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-d4d419d8 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2317 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) ▸ else of (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.CONFIRM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-60862c3e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2318 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) ▸ else of (dtResult.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.CONFIRM_DATE), "") | 그리드 값 설정 |  |  |  |
| AC-7787167b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2320 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) | CALL_EXT | spdMain.Update | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a74c6578 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2321 | if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail != null) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |

## FP00591_Plan_Control_Integration.SetMainSheetControl

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ else of (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_05_NAME)) ▸ if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-305dd5e4 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2332 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | _sPlanGroup | siMain.GetValue(3, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3922955a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2333 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | _sScpProductTarget | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1ae65f5b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2334 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | _sMasterValidation | siMain.GetValue(1, siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-22200f29 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2335 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | _sPlanIDCreate | siMain.GetValue(2, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-af789fb3 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2336 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | _sRevision | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-3a4716bb | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2337 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | _sRelease | siMain.GetValue(3, siMain.GetColumnIndex(DefColumns.ACTION_05_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9449f8d1 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2341 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | btncellType | new FarPoint.Win.Spread.CellType.ButtonCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-c52eeeb1 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2342 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.ButtonColor | Color.DarkGray | 속성 ButtonColor 설정 |  |  |  |
| AC-f2042279 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2343 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.DarkColor | Color.DarkCyan | 속성 DarkColor 설정 |  |  |  |
| AC-7472ca5b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2344 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.LightColor | Color.AliceBlue | 속성 LightColor 설정 |  |  |  |
| AC-62aa3960 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2345 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.TwoState | false | 속성 TwoState 설정 |  |  |  |
| AC-7f486e6a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2346 | if (siMain.ActiveSheet.RowCount > 0) | VALUE_SET | btncellType.Text | _sMasterValidation | 컨트롤 값 설정 |  |  |  |
| AC-0125d191 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2347 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.TextDown | _sMasterValidation | 속성 TextDown 설정 |  |  |  |
| AC-73d62ad8 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2348 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.ShadowSize | 3 | 속성 ShadowSize 설정 |  |  |  |
| AC-c94780b8 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2349 | if (siMain.ActiveSheet.RowCount > 0) | GRID_SET | siMain.ActiveSheet.Cells[1, siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)].CellType | btncellType | 그리드 속성/값 설정 |  |  |  |
| AC-f5d71563 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2352 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | btncellType | new FarPoint.Win.Spread.CellType.ButtonCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-4744b425 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2353 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.ButtonColor | Color.DarkGray | 속성 ButtonColor 설정 |  |  |  |
| AC-b8a0586b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2354 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.DarkColor | Color.DarkCyan | 속성 DarkColor 설정 |  |  |  |
| AC-ce2c464b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2355 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.LightColor | Color.AliceBlue | 속성 LightColor 설정 |  |  |  |
| AC-6f13e688 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2356 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.TwoState | false | 속성 TwoState 설정 |  |  |  |
| AC-51327513 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2357 | if (siMain.ActiveSheet.RowCount > 0) | VALUE_SET | btncellType.Text | _sPlanIDCreate | 컨트롤 값 설정 |  |  |  |
| AC-ad046668 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2358 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.TextDown | _sPlanIDCreate | 속성 TextDown 설정 |  |  |  |
| AC-dca5df1b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2359 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.ShadowSize | 3 | 속성 ShadowSize 설정 |  |  |  |
| AC-4b34c1f4 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2360 | if (siMain.ActiveSheet.RowCount > 0) | GRID_SET | siMain.ActiveSheet.Cells[2, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)].CellType | btncellType | 그리드 속성/값 설정 |  |  |  |
| AC-03d4b828 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2363 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | btncellType | new FarPoint.Win.Spread.CellType.ButtonCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d0d79c4d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2364 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.ButtonColor | Color.DarkGray | 속성 ButtonColor 설정 |  |  |  |
| AC-0a4300b0 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2365 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.DarkColor | Color.DarkCyan | 속성 DarkColor 설정 |  |  |  |
| AC-23898abf | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2366 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.LightColor | Color.AliceBlue | 속성 LightColor 설정 |  |  |  |
| AC-0639ce8c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2367 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.TwoState | false | 속성 TwoState 설정 |  |  |  |
| AC-a274e450 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2368 | if (siMain.ActiveSheet.RowCount > 0) | VALUE_SET | btncellType.Text | _sRelease | 컨트롤 값 설정 |  |  |  |
| AC-dbcee180 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2369 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.TextDown | _sRelease | 속성 TextDown 설정 |  |  |  |
| AC-8f4131f4 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2370 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | btncellType.ShadowSize | 3 | 속성 ShadowSize 설정 |  |  |  |
| AC-3d64de67 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2371 | if (siMain.ActiveSheet.RowCount > 0) | GRID_SET | siMain.ActiveSheet.Cells[3, siMain.GetColumnIndex(DefColumns.ACTION_05_NAME)].CellType | btncellType | 그리드 속성/값 설정 |  |  |  |
| AC-83390772 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2374 | if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | Filter["INSTANCE_ID"] | _sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-c2577090 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2375 | if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | Filter["PLAN_DATE"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-b7d2971e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2377 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | dtRevision | DataService.FP_ExecuteQuery2("FP00591", "findTotalPlanList", Filter.Dictionary, "Planning"… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalPlanList] \| FP\Planni… | 화면 필드/플래그 변경 |  |  |  |
| AC-ccbd30ff | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2377 | if (siMain.ActiveSheet.RowCount > 0) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findTotalPlanList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalPlanList] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7914ba5a | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2383 | if (siMain.ActiveSheet.RowCount > 0) ▸ foreach (DataRow dr in dtRevision.Rows) | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fd92ca3 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2384 | if (siMain.ActiveSheet.RowCount > 0) ▸ foreach (DataRow dr in dtRevision.Rows) | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b132f68 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2386 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | combocellType | new FarPoint.Win.Spread.CellType.ComboBoxCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d337eae8 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2387 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.ItemData | (string[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-7ff7d0e0 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2388 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.Items | (string[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-40edc650 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2389 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-a5a4a801 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2390 | if (siMain.ActiveSheet.RowCount > 0) | STATE | combocellType.Editable | false | 컨트롤 상태 Editable |  |  |  |
| AC-7f866c82 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2391 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.MaxDrop | 10 | 속성 MaxDrop 설정 |  |  |  |
| AC-4b458d12 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2392 | if (siMain.ActiveSheet.RowCount > 0) | GRID_SET | this.siMain.ActiveSheet.Cells.Get(3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)).Bac… | Color.Aqua | 그리드 속성/값 설정 |  |  |  |
| AC-be9c2d5e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2392 | if (siMain.ActiveSheet.RowCount > 0) | CALL_EXT | this.siMain.ActiveSheet.Cells.Get | (3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a33ab56 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2394 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.ButtonAlign | FarPoint.Win.ButtonAlign.Right | 속성 ButtonAlign 설정 |  |  |  |
| AC-1a19ec1e | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2395 | if (siMain.ActiveSheet.RowCount > 0) | GRID_SET | siMain.ActiveSheet.Cells[3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)].CellType | combocellType | 그리드 속성/값 설정 |  |  |  |
| AC-afd6da02 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2399 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRevision.Rows.Count > 0) | FLAG | _sRevision | dtRevision.Rows[0]["CODE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5ccc4640 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2400 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRevision.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME), _sRevision) | 그리드 값 설정 |  |  |  |
| AC-65f6634d | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2407 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (dtRevision.Rows.Count > 0) | FLAG | _sRevision | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0982e756 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2409 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (dtRevision.Rows.Count > 0) | GRID_SET | siSub.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-2deab4dd | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2412 | if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | Filter["INTG_PLAN_ID"] | _sRevision | 행/컬럼 값 대입 |  |  |  |
| AC-df56eed3 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2413 | if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | Filter["PLAN_DATE"] | pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-8615db6c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2416 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | dtRevisionDetail | DataService.FP_ExecuteQuery2("FP00591", "findPlanList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanList] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-c3dc5ca1 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2416 | if (siMain.ActiveSheet.RowCount > 0) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findPlanList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanList] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d3222611 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2422 | if (siMain.ActiveSheet.RowCount > 0) ▸ foreach (DataRow dr in dtRevisionDetail.Rows) | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-7804b2a2 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2423 | if (siMain.ActiveSheet.RowCount > 0) ▸ foreach (DataRow dr in dtRevisionDetail.Rows) | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-158bfad7 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2426 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | combocellType | new FarPoint.Win.Spread.CellType.ComboBoxCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-ea874491 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2427 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.ItemData | (string[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-313ecc69 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2428 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.Items | (string[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-089319b3 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2429 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-318466a8 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2430 | if (siMain.ActiveSheet.RowCount > 0) | STATE | combocellType.Editable | false | 컨트롤 상태 Editable |  |  |  |
| AC-af4fc287 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2431 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.MaxDrop | 10 | 속성 MaxDrop 설정 |  |  |  |
| AC-1aa0d47b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2432 | if (siMain.ActiveSheet.RowCount > 0) | GRID_SET | this.siMain.ActiveSheet.Cells.Get(3, siMain.GetColumnIndex(DefColumns.ACTION_04_NAME)).Bac… | Color.Orange | 그리드 속성/값 설정 |  |  |  |
| AC-8466b10c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2432 | if (siMain.ActiveSheet.RowCount > 0) | CALL_EXT | this.siMain.ActiveSheet.Cells.Get | (3, siMain.GetColumnIndex(DefColumns.ACTION_04_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ecd12c75 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2434 | if (siMain.ActiveSheet.RowCount > 0) | UI_PROP | combocellType.ButtonAlign | FarPoint.Win.ButtonAlign.Right | 속성 ButtonAlign 설정 |  |  |  |
| AC-07b63935 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2435 | if (siMain.ActiveSheet.RowCount > 0) | GRID_SET | siMain.ActiveSheet.Cells[3, siMain.GetColumnIndex(DefColumns.ACTION_04_NAME)].CellType | combocellType | 그리드 속성/값 설정 |  |  |  |
| AC-6355b615 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2440 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRevisionDetail.Rows.Count > 0) | FLAG | _sRevisionDetail | dtRevisionDetail.Rows[0]["CODE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-785bd590 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2441 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRevisionDetail.Rows.Count > 0) | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.ACTION_04_NAME), _sRevisionDetail) | 그리드 값 설정 |  |  |  |
| AC-030069f2 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2445 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (dtRevisionDetail.Rows.Count > 0) | FLAG | _sRevisionDetail | "" | 화면 필드/플래그 변경 |  |  |  |

## FP00591_Plan_Control_Integration.SetspdMainLock

진입점: this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ else of (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_05_NAME)) ▸ if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0ef3006 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2512 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.WOW_NAME), 3, siMain.GetColumnIndex(DefColumns.WOW_NA… | 그리드 편집 잠금 전환 |  |  |  |
| AC-cd15a7c1 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2514 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.ACTION_01_NAME), 0, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |
| AC-e5582233 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2515 |  | GRID_LOCK | siMain.LockRange2 | (2, siMain.GetColumnIndex(DefColumns.ACTION_01_NAME), 2, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |
| AC-e75c337b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2516 |  | GRID_LOCK | siMain.LockRange2 | (3, siMain.GetColumnIndex(DefColumns.ACTION_01_NAME), 3, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |
| AC-f78d5c59 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2518 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME), 1, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |
| AC-7b3faabe | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2521 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.ACTION_05_NAME), 3, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |
| AC-aafe2a9b | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2522 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.STATUS), 2, siMain.GetColumnIndex(DefColumns.STATUS),… | 그리드 편집 잠금 전환 |  |  |  |
| AC-304571f4 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2523 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.INSERT_ID), 3, siMain.GetColumnIndex(DefColumns.INSER… | 그리드 편집 잠금 전환 |  |  |  |
| AC-d32b7da5 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2524 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.DESCRIPTION), 3, siMain.GetColumnIndex(DefColumns.DES… | 그리드 편집 잠금 전환 |  |  |  |
| AC-096e11b2 | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2525 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.CONFIRM_ID), 3, siMain.GetColumnIndex(DefColumns.CONF… | 그리드 편집 잠금 전환 |  |  |  |
| AC-aa2f298c | this.spdMain.CellClick [if (siMain != null) ▸ else of (e.Row… 외 2 | FP00591_Plan_Control_Integration.cs:2526 |  | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.CONFIRM_DATE), 3, siMain.GetColumnIndex(DefColumns.CO… | 그리드 편집 잠금 전환 |  |  |  |

## FP00591_Plan_Control_Integration.SpdMain_CellClick

진입점: this.spdMain.CellClick / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ff8a8b2 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1511 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-5536bc31 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1512 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bac36913 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1527 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (this.ViewModel != null) ▸ if (!V… | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-43ed1aa9 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1528 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (this.ViewModel != null) ▸ if (!V… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32b437a3 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1540 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (sBeforSite != sSite) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Try Again, After Search(F5)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a5f1f80 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1541 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (sBeforSite != sSite) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43159518 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1545 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (sBeforePlanDate != sPlanDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Try Again, After Search(F5)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-948e8cef | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1546 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (sBeforePlanDate != sPlanDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-413ccbc9 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1549 | if (siMain != null) ▸ if (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00183", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a59915d3 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1563 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f7a612a | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1564 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b921de7 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1569 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | POPUP | new FP00591_fixOption_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-0d6fed23 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1570 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | CALL_EXT | select_popup.SetOption | (0, "Qty Keep") | ⚠ 의미 확인 필요 |  |  |  |
| AC-01bb4d2c | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1571 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | CALL_EXT | select_popup.SetOption | (1, "Qty Fix") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca3034c2 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1572 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | select_popup._PLAN_DATE | siMain.GetValue(3, siMain.GetColumnIndex(DefColumns.PLAN_DATE)).ToString() | 속성 _PLAN_DATE 설정 |  |  |  |
| AC-eb397079 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1573 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | select_popup._TOTAL_INSTANCE | siMain.GetValue(3, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 속성 _TOTAL_INSTANCE 설정 |  |  |  |
| AC-61383dec | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1575 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-11b3d842 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1591 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b3525565 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1608 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Try Again, After Search(F5)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-73c3177b | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1609 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ecc2dc80 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1613 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Try Again, After Search(F5)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-824c277a | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1614 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71a90b75 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1618 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | FLAG | dtPlanRunFlag | DataService.FP_ExecuteQuery2("FP00591", "findIsRunningPlan", Filter.Dictionary, "Planning"… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findIsRunningPlan] \| FP\Planni… | 화면 필드/플래그 변경 |  |  |  |
| AC-6d28a644 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1618 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findIsRunningPlan", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findIsRunningPlan] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8e638516 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1625 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d7a73f6f | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1626 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97687034 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1630 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | VALUE_SET | chkStatus.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-dc2e5f87 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1641 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-759fcad2 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1642 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-14de0324 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1650 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.SITE_ID | sSite | 속성 SITE_ID 설정 |  |  |  |
| AC-1663dc73 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1651 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.INSTANCE_ID | dtLocalPlanGroup.Rows[0]["CODE"].ToString() | 속성 INSTANCE_ID 설정 |  |  |  |
| AC-aa536d11 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1652 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.INSTANCE_NAME | dtLocalPlanGroup.Rows[0]["NAME"].ToString() | 속성 INSTANCE_NAME 설정 |  |  |  |
| AC-a5288ab1 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1653 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.PLAN_DATE | sPlanDate | 속성 PLAN_DATE 설정 |  |  |  |
| AC-bf81fe07 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1654 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.PLAN_ID | sPlanID | 속성 PLAN_ID 설정 |  |  |  |
| AC-bc50e092 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1659 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.FIX_DATE_SYNC | "" | 속성 FIX_DATE_SYNC 설정 |  |  |  |
| AC-f8c613d7 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1660 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.SYNC_YN | "N" | 속성 SYNC_YN 설정 |  |  |  |
| AC-a20759e9 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1661 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.PRE_FIX_TARGET_ID | "" | 속성 PRE_FIX_TARGET_ID 설정 |  |  |  |
| AC-6e2ebfa8 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1662 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.PRE_FIX_FLAG | "N" | 속성 PRE_FIX_FLAG 설정 |  |  |  |
| AC-217bd6eb | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1663 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.PRE_FIX_TYPE | sFixOption | 속성 PRE_FIX_TYPE 설정 |  |  |  |
| AC-c1f774d8 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1664 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.PRE_FIX_DATE | "" | 속성 PRE_FIX_DATE 설정 |  |  |  |
| AC-662da2a7 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1665 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.PLAN_TYPE | "PRE" | 속성 PLAN_TYPE 설정 |  |  |  |
| AC-80bdd723 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1666 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.PLAN_END_TIME | "" | 속성 PLAN_END_TIME 설정 |  |  |  |
| AC-3957850f | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1667 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.PLAN_HORIZON | "" | 속성 PLAN_HORIZON 설정 |  |  |  |
| AC-25713343 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1668 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.DEMAND_HORIZON | "" | 속성 DEMAND_HORIZON 설정 |  |  |  |
| AC-795712a2 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1669 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.DESCRIPTION | "" | 속성 DESCRIPTION 설정 |  |  |  |
| AC-87e52213 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1670 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.BASIS_PLAN_ID | "" | 속성 BASIS_PLAN_ID 설정 |  |  |  |
| AC-0a8d1be0 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1671 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.SYNC_OPERATION_ID | "" | 속성 SYNC_OPERATION_ID 설정 |  |  |  |
| AC-8d9f4c18 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1672 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.PRE_FIX_DATE2 | "" | 속성 PRE_FIX_DATE2 설정 |  |  |  |
| AC-61c84141 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1673 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.PRE_FIX_TYPE2 | "" | 속성 PRE_FIX_TYPE2 설정 |  |  |  |
| AC-5cefd047 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1674 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.PRE_FIX_2_FLAG | "" | 속성 PRE_FIX_2_FLAG 설정 |  |  |  |
| AC-4a37fb77 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1675 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | DsinData.ALLOWFIXDATENULL | "" | 속성 ALLOWFIXDATENULL 설정 |  |  |  |
| AC-ed93bba7 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1679 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "CONTROL_PLAN_CREATE_RELEASE_BY_INSTANCE", DsinData.INSTANCE_ID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3a9a09a1 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1692 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("Unable to create a FP plan ID. Contact GSCM.FP PI representative for details.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e761946 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1693 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87e7729e | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1700 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("Enter the fix date below. : " + _CREATE_PLAN_FIX_DATE) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-67c78285 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1701 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3bd1491 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1709 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("Enter the fix date below. : " + _CREATE_PLAN_FIX_DATE) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ccd21ff5 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1710 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c2567d5c | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1734 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_checkMasterInfo", sFormInst, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4219e2bb | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1741 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8717fe1c | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1742 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7cfaf568 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1747 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dde25a69 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1748 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-398c0c7f | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1752 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_formAging", sSite, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-781e287e | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1760 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Aging Stock is not available yet. (Formation)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-22d892f7 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1761 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-409b3c3d | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1768 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", sPlanGroupDetall) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1bfbfdf6 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1777 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageBox.Show | ("A plan of the past date will be created. Will you proceed?", "Excute", MessageBoxButtons… | 메시지 표시 |  |  |  |
| AC-b7fd5b43 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1779 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e6f6391 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1786 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_refInfo", sSite, sPlanGroupDetall, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-63880947 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1795 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "The engine can not be started before the reference data(open … | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bc7daa2a | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1796 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6fa5a248 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1802 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_isSaveAuth", sPlanGroupDetall, UserInfoContext.Current.User… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4a42c8c | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1810 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "You don't have 'Save' permission for this instance!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1146216 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1811 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0bbf6c5 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1819 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | UI_PROP | dtSave.TableName | "test" | 속성 TableName 설정 |  |  |  |
| AC-286cdfc3 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1820 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtSave.Columns.Add | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-751d6a47 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1821 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtSave.Columns.Add | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7387eb7a | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1822 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtSave.Columns.Add | ("TOTAL_INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b14626b5 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1823 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtSave.Columns.Add | ("FIX_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4c2e4fb | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1825 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtSave.Columns.Add | ("FIX_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb636cbf | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1826 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtSave.Columns.Add | ("DESC_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5275ddc | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1827 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtSave.Columns.Add | ("DESC_FORM", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-769af2e4 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1828 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtSave.Columns.Add | ("DESC_ELEC", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4314c66e | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1830 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtSave.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5991e116 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1832 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_SET | dtSave.Rows[0]["PLAN_DATE"] | sPlanDate | 그리드 속성/값 설정 |  |  |  |
| AC-563b492d | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1833 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_SET | dtSave.Rows[0]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-90266363 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1834 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_SET | dtSave.Rows[0]["TOTAL_INSTANCE_ID"] | sPlanGroup | 그리드 속성/값 설정 |  |  |  |
| AC-da0fd952 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1835 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_SET | dtSave.Rows[0]["FIX_TYPE"] | sFixOption | 그리드 속성/값 설정 |  |  |  |
| AC-08efb02b | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1837 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_SET | dtSave.Rows[0]["FIX_DATE"] | sFixDate | 그리드 속성/값 설정 |  |  |  |
| AC-0390a8c5 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1838 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_SET | dtSave.Rows[0]["DESC_CELL"] | sDescCell | 그리드 속성/값 설정 |  |  |  |
| AC-153a5dcd | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1839 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_SET | dtSave.Rows[0]["DESC_FORM"] | sDescForm | 그리드 속성/값 설정 |  |  |  |
| AC-94bbb58b | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1840 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_SET | dtSave.Rows[0]["DESC_ELEC"] | sDescElec | 그리드 속성/값 설정 |  |  |  |
| AC-8d9e536e | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1843 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP00591", "createPlan", dtSave, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=createPlan] \| FP\Planning\FP005… | 엔드포인트 호출 |  |  |  |
| AC-14785ff8 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1846 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findLatestPlan", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLatestPlan] \| FP\Planning\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6ccb1449 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1849 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtLatestPlan.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b4bdae40 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1850 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtNew.Columns.Add | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-27b4cfed | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1854 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtNew.Rows.Add | ( dr["INSTANCE_ID"].ToString(), dr["PLAN_ID"].ToString(), UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-512f2c07 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1857 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP00591", "updateClearStatus", dtNew, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=updateClearStatus] \| FP\Plannin… | 엔드포인트 호출 |  |  |  |
| AC-e8799869 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1862 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | STATE_RESET | dtNew.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-3442f1fa | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1865 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtNew.Rows.Add | (dr["INSTANCE_ID"].ToString(), dr["PLAN_ID"].ToString(), UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8cfecfe | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1868 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP00591", "updateEngineRun", dtNew, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=updateEngineRun] \| FP\Planning\… | 엔드포인트 호출 |  |  |  |
| AC-5f306e9d | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1873 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | FLAG | dtRevision | DataService.FP_ExecuteQuery2("FP00591", "findTotalPlanList", Filter.Dictionary, "Planning"… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalPlanList] \| FP\Planni… | 화면 필드/플래그 변경 |  |  |  |
| AC-129e123e | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1873 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findTotalPlanList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findTotalPlanList] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-42f2f581 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1876 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4fd199da | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1877 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4cd156c1 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1881 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtResult.Rows.Add | (dr["CODE"].ToString(), dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b0b068f | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1886 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c0463baa | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1887 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | FLAG | _sRevision | dtRevision.Rows[0]["CODE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4e953aa1 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1888 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.ACTION_02_NAME), _sRevision) | 그리드 값 설정 |  |  |  |
| AC-7084a4d8 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1895 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_SET | siSub.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-99da6a2a | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1898 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | Filter["INTG_PLAN_ID"] | _sRevision | 행/컬럼 값 대입 |  |  |  |
| AC-7db11f5e | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1899 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | Filter["PLAN_DATE"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-023955be | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1902 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | FLAG | dtRevisionDetail | DataService.FP_ExecuteQuery2("FP00591", "findPlanList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanList] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-3e86a45a | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1902 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findPlanList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanList] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d81aeee6 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1905 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f82a39d | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1906 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-90ada325 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1910 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | DATA_OP | dtResult.Rows.Add | (dr["CODE"].ToString(), dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8af4ca8 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1915 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (3, siMain.GetColumnIndex(DefColumns.ACTION_04_NAME), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-02062c32 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1916 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | FLAG | _sRevisionDetail | dtRevisionDetail.Rows[0]["CODE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8dadea6d | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1917 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.ACTION_04_NAME), _sRevisionDetail) | 그리드 값 설정 |  |  |  |
| AC-ba4f3203 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1921 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | FLAG | _sRevisionDetail | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2a246762 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1924 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | VALUE_SET | chkStatus.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-38dab1c8 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:1927 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ if (e.Row == 2 && e.Column == s… | FLAG | blnCreateRun | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c86fd9e6 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2016 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c9edd2f | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2017 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6ba3294 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2024 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | CALL_EXT | dtRevisionDetail.Lookup | ("PLAN_ID", sPlanID, "INSTANCE_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b3629517 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2029 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Try Again, After Search(F5)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2eac72d3 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2030 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bba26fd1 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2034 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Try Again, After Search(F5)!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd2f28fc | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2035 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60034255 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2041 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ab9dceb9 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2042 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2dabc805 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2046 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | FLAG | dtEngineFlag | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_findEngineFlag", sPlanGrou… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-9ba1e0d2 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2046 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-24d36e4a | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2053 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3106242f | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2054 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fae6ee76 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2061 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4a90347 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2062 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5f079ec | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2068 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | Filter["_RECAL_INSTANCE_ID"] | sPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-f35b7930 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2069 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | Filter["_RECAL_PLAN_ID"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-9752647b | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2070 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findRelease_isRecalculation", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findRelease_isRecalculation] \|… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4d1824fb | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2073 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | MESSAGE | MessageHelper.GMessageBox | ("If recalculation is not performed, release is restricted.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e17fd779 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2074 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3df4432a | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2087 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | dtLocalPlanGroupDetail.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6af6877 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2088 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ae17c8da | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2095 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | dtRevisionDetail.Select | (string.Format("PLAN_ID = '{0}'", sPlanID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b4a9d66 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2096 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | drs3.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bceed22d | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2098 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | dtResult.Columns.Add | ("DESCRIPTION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9fdcd25 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2102 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | dRow.Field | ("PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ebfd492 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2107 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1ef186a | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2122 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-84ac65b8 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2128 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-b369980d | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2132 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | VALUE_SET | chkStatus.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-e7fdc79e | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2134 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-e657563a | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2135 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5628fd0a | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2136 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-53603353 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2149 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-659ca0a0 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2152 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-a1341435 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2153 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-aae55c4a | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2154 | if (siMain != null) ▸ else of (e.Row == 1 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_01_NAME)) ▸ else of (e.Row == 2 && e.Column… | POPUP | popReleaseTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-58f54954 | this.spdMain.CellClick 외 1 | FP00591_Plan_Control_Integration.cs:2166 | if (siMain != null) | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00591_Plan_Control_Integration.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-baab5697 | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1381 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (chkStatus.Checked == true) | VALUE_SET | chkStatus.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-c7f3fc3b | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1434 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | DATA_OP | Filter["INTG_PLAN_ID"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-6ecc6178 | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1435 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | DATA_OP | Filter["PLAN_DATE"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-65c85a4f | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1437 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | FLAG | dtRevisionDetail | DataService.FP_ExecuteQuery2("FP00591", "findPlanList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanList] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-3956205c | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1437 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00591", "findPlanList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanList] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7325a0ac | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1443 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ foreach (DataRow dr … | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0d439f8 | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1444 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ foreach (DataRow dr … | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a782cc7 | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1447 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | FLAG | combocellType | new FarPoint.Win.Spread.CellType.ComboBoxCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d80a9204 | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1448 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | UI_PROP | combocellType.ItemData | (string[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-872ceef2 | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1449 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | UI_PROP | combocellType.Items | (string[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-1a075fa0 | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1450 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | UI_PROP | combocellType.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-f75ffcc6 | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1451 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | STATE | combocellType.Editable | false | 컨트롤 상태 Editable |  |  |  |
| AC-2d11c550 | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1452 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | UI_PROP | combocellType.MaxDrop | 10 | 속성 MaxDrop 설정 |  |  |  |
| AC-939e287d | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1453 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | GRID_SET | this.siMain.ActiveSheet.Cells.Get(3, siMain.GetColumnIndex(DefColumns.ACTION_04_NAME)).Bac… | Color.Orange | 그리드 속성/값 설정 |  |  |  |
| AC-5bd0ea1a | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1453 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | CALL_EXT | this.siMain.ActiveSheet.Cells.Get | (3, siMain.GetColumnIndex(DefColumns.ACTION_04_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0dfa622 | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1455 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | UI_PROP | combocellType.ButtonAlign | FarPoint.Win.ButtonAlign.Right | 속성 ButtonAlign 설정 |  |  |  |
| AC-91049d8f | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1456 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) | GRID_SET | siMain.ActiveSheet.Cells[3, siMain.GetColumnIndex(DefColumns.ACTION_04_NAME)].CellType | combocellType | 그리드 속성/값 설정 |  |  |  |
| AC-13f0af2d | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1460 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail… | FLAG | _sRevisionDetail | dtRevisionDetail.Rows[0]["CODE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8f14bd45 | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1461 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ if (dtRevisionDetail… | GRID_SET | siMain.SetText | (3, siMain.GetColumnIndex(DefColumns.ACTION_04_NAME), _sRevisionDetail) | 그리드 값 설정 |  |  |  |
| AC-f02b90fd | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1465 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_02_NAME)) ▸ if (!string.IsNullOrEmpty(sPlanID)) ▸ else of (dtRevisionD… | FLAG | _sRevisionDetail | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-52ec2148 | this.spdMain.ComboSelChange | FP00591_Plan_Control_Integration.cs:1478 | if (e.Row == 3 && e.Column == siMain.GetColumnIndex(DefColumns.ACTION_04_NAME)) | FLAG | _sRevisionDetail | siMain.GetText(3, siMain.GetColumnIndex(DefColumns.ACTION_04_NAME)) | 화면 필드/플래그 변경 |  |  |  |


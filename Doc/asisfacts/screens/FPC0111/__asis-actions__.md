# AS-IS 액션 대조표 — FPC0111

> 원천: `Doc/asisfacts/screens/FPC0111/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 428행 · 메서드 30 · 종류 DATA_OP 197 · VALUE_SET 30 · GRID_SET 27 · FLAG 26 · GRID_LOCK 22 · CALL_EXT 21 · UI_PROP 20 · ENDPOINT 20 · RETURN 17 · UI_MISC 16 · POPUP 10 · GRID_INIT 8 · MESSAGE 7 · STATE 3 · GRID_BIND 2 · VALUE_CLEAR 2 · ⚠ 의미 확인 필요 21


## FPC0111_AlarmEditPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40f51765 | .ctor | FPC0111_AlarmEditPopup.cs:127 |  | FLAG | SrcRow | row | 화면 필드/플래그 변경 |  |  |  |
| AC-934e4289 | .ctor | FPC0111_AlarmEditPopup.cs:128 |  | FLAG | iColumn | colindex | 화면 필드/플래그 변경 |  |  |  |
| AC-f82b313b | .ctor | FPC0111_AlarmEditPopup.cs:129 |  | FLAG | iRow | rowindex | 화면 필드/플래그 변경 |  |  |  |
| AC-8609e8ab | .ctor | FPC0111_AlarmEditPopup.cs:130 |  | FLAG | Day | date | 화면 필드/플래그 변경 |  |  |  |
| AC-abe3bba9 | .ctor | FPC0111_AlarmEditPopup.cs:132 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ce0e0952 | .ctor | FPC0111_AlarmEditPopup.cs:133 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-754c9781 | .ctor | FPC0111_AlarmEditPopup.cs:134 |  | FLAG | this.sDivisionId | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-c1216daa | .ctor | FPC0111_AlarmEditPopup.cs:142 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-612310da | .ctor | FPC0111_AlarmEditPopup.cs:143 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-b9d2d1ff | .ctor | FPC0111_AlarmEditPopup.cs:145 |  | CALL_EXT | searchParam.TryGetValue | ("COMPANY_ID", out this.sCompanyId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-708ea719 | .ctor | FPC0111_AlarmEditPopup.cs:146 |  | CALL_EXT | searchParam.TryGetValue | ("DIVISION_ID", out this.sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32b36be3 | .ctor | FPC0111_AlarmEditPopup.cs:147 |  | CALL_EXT | searchParam.TryGetValue | ("SITE_ID", out sSiteId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe8d7826 | .ctor | FPC0111_AlarmEditPopup.cs:148 |  | CALL_EXT | searchParam.TryGetValue | ("LEVEL_2_CODE", out sLevel2Code) | ⚠ 의미 확인 필요 |  |  |  |
| AC-284c86e1 | .ctor | FPC0111_AlarmEditPopup.cs:149 |  | CALL_EXT | searchParam.TryGetValue | ("LEVEL_2_CODE_FLAG", out sLevel2CodeFlag) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aef824de | .ctor | FPC0111_AlarmEditPopup.cs:150 |  | CALL_EXT | searchParam.TryGetValue | ("IS_FORMATION_FLOW_ID_EXISTS", out sIsFormationFlowIdExists) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0111_AlarmEditPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42c4a586 | (진입점 미연결) | FPC0111_AlarmEditPopup.cs:505 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-98161b20 | (진입점 미연결) | FPC0111_AlarmEditPopup.cs:508 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0111_AlarmEditPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c2f65e2 | this.Load | FPC0111_AlarmEditPopup.cs:346 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a7c30182 | this.Load | FPC0111_AlarmEditPopup.cs:347 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6f753bb2 | this.Load | FPC0111_AlarmEditPopup.cs:348 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0111_AlarmEditPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4ef4357 | this.Load | FPC0111_AlarmEditPopup.cs:341 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0111_AlarmEditPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d694e91 | Dispose | FPC0111_AlarmEditPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0111_AlarmEditPopup.FindData

진입점: FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2b28e7c | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:415 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1472828c | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:416 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-579eb7b4 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:419 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fdcad304 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:421 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Common.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a805b2db | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:425 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Common.PR_UI_COMMON_POPUP") ⇒ FP_Common.PR_UI_COMMON_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-6ce71eb6 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:427 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c5ebf2ae | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:429 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-03e497f9 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:430 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | "ITEM_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-7094dde3 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:431 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b5b79a65 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:432 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6ab60ecd | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:433 | lambda | DATA_OP | request.Parameters["p_non_auth"] | _sNonAuth | 행/컬럼 값 대입 |  |  |  |
| AC-89589949 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:434 | lambda | DATA_OP | request.Parameters["p_save_auth"] | _sSaveAuth | 행/컬럼 값 대입 |  |  |  |
| AC-e4300012 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:436 | lambda | DATA_OP | request.Parameters["p_param1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-273c3e72 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:437 | lambda | DATA_OP | request.Parameters["p_param2"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-ee00e637 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:438 | lambda | DATA_OP | request.Parameters["p_param3"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-e23d317c | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:439 | lambda | DATA_OP | request.Parameters["p_param4"] | pItemID.Equals("ALL") ? DBNull.Value : pItemID | 행/컬럼 값 대입 |  |  |  |
| AC-cab76167 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:440 | lambda | DATA_OP | request.Parameters["p_param5"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-0e1d8264 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:441 | lambda | DATA_OP | request.Parameters["p_param6"] | (string.IsNullOrEmpty(sLevel2CodeFlag)) ? DBNull.Value : sLevel2CodeFlag as object | 행/컬럼 값 대입 |  |  |  |
| AC-1594e110 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:442 | lambda | DATA_OP | request.Parameters["p_param7"] | (string.IsNullOrEmpty(sLevel2Code)) ? DBNull.Value : sLevel2Code as object | 행/컬럼 값 대입 |  |  |  |
| AC-6e9241ec | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:443 | lambda | DATA_OP | request.Parameters["p_param8"] | (string.IsNullOrEmpty(sIsFormationFlowIdExists)) ? DBNull.Value : sIsFormationFlowIdExists… | 행/컬럼 값 대입 |  |  |  |
| AC-fee80c5e | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:444 | lambda | DATA_OP | request.Parameters["p_param9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f65ef271 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:445 | lambda | DATA_OP | request.Parameters["p_param10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8769d116 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:447 | lambda | DATA_OP | request.Parameters["p_param11"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3b366e10 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:448 | lambda | DATA_OP | request.Parameters["p_param12"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cd135f69 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:449 | lambda | DATA_OP | request.Parameters["p_param13"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-459729cd | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:450 | lambda | DATA_OP | request.Parameters["p_param14"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-00a456c2 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:451 | lambda | DATA_OP | request.Parameters["p_param15"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7ccd0324 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:452 | lambda | DATA_OP | request.Parameters["p_param16"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-21eed296 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:453 | lambda | DATA_OP | request.Parameters["p_param17"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-07cc06a8 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:454 | lambda | DATA_OP | request.Parameters["p_param18"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b513ea22 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:455 | lambda | DATA_OP | request.Parameters["p_param19"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a008ae9d | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:456 | lambda | DATA_OP | request.Parameters["p_param20"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-db5ee7a0 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:457 | lambda | DATA_OP | request.Parameters["TimeZone"] | TimeZone | 행/컬럼 값 대입 |  |  |  |
| AC-6775ff08 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:459 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2bcbc1f6 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:461 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a7433e0e | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:466 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-705313e9 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:470 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-39e77838 | FindButton 외 1 | FPC0111_AlarmEditPopup.cs:476 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0111_AlarmEditPopup.fn_setRowInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bb3df9e | (진입점 미연결) | FPC0111_AlarmEditPopup.cs:545 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd7f6fe8 | (진입점 미연결) | FPC0111_AlarmEditPopup.cs:546 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-01d42453 | (진입점 미연결) | FPC0111_AlarmEditPopup.cs:555 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0111_AlarmEditPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52d30c13 | this.Load | FPC0111_AlarmEditPopup.cs:161 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-04874964 | this.Load | FPC0111_AlarmEditPopup.cs:163 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3a40a9e9 | this.Load | FPC0111_AlarmEditPopup.cs:169 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |

## FPC0111_AlarmEditPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bc59de0 | this.Load | FPC0111_AlarmEditPopup.cs:188 |  | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba82964f | this.Load | FPC0111_AlarmEditPopup.cs:191 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-339a717c | this.Load | FPC0111_AlarmEditPopup.cs:192 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | usrButton4.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e5d7042d | this.Load | FPC0111_AlarmEditPopup.cs:193 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | usrButton5.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bd3248aa | this.Load | FPC0111_AlarmEditPopup.cs:197 | if (SrcRow!=null) | VALUE_SET | dpPlanDate.Text | Day.Date.ToString("yyyyMMdd") | 컨트롤 값 설정 |  |  |  |
| AC-6cb71270 | this.Load | FPC0111_AlarmEditPopup.cs:198 | if (SrcRow!=null) | VALUE_SET | txtProdType.Text | SrcRow["PRODUCTION_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b0c2dfbc | this.Load | FPC0111_AlarmEditPopup.cs:199 | if (SrcRow!=null) | VALUE_SET | txtModel.Text | SrcRow["TOP_ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-6757a9c7 | this.Load | FPC0111_AlarmEditPopup.cs:200 | if (SrcRow!=null) | VALUE_SET | txtItem.Text | SrcRow["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a8034cc5 | this.Load | FPC0111_AlarmEditPopup.cs:201 | if (SrcRow!=null) | VALUE_SET | txtNickName.Text | SrcRow["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-e2f1cf5d | this.Load | FPC0111_AlarmEditPopup.cs:202 | if (SrcRow!=null) | VALUE_SET | txtItemType.Text | SrcRow["ITEM_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ce5c3942 | this.Load | FPC0111_AlarmEditPopup.cs:203 | if (SrcRow!=null) | VALUE_SET | txtFactory.Text | SrcRow["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-05d48748 | this.Load | FPC0111_AlarmEditPopup.cs:204 | if (SrcRow!=null) | VALUE_SET | txtMarket.Text | SrcRow["MARKET"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f7e9dde7 | this.Load | FPC0111_AlarmEditPopup.cs:205 | if (SrcRow!=null) | VALUE_SET | txtOperation.Text | SrcRow["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-81a0fa70 | this.Load | FPC0111_AlarmEditPopup.cs:206 | if (SrcRow!=null) | VALUE_SET | txtLine.Text | SrcRow["LINE_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8a030743 | this.Load | FPC0111_AlarmEditPopup.cs:207 | if (SrcRow!=null) | VALUE_SET | txtElectrode.Text | SrcRow["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-aee0d00c | this.Load | FPC0111_AlarmEditPopup.cs:208 | if (SrcRow!=null) | VALUE_SET | txtLocation.Text | SrcRow["LOCATION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-632165e4 | this.Load | FPC0111_AlarmEditPopup.cs:214 | else of (SrcRow!=null) ▸ if (HasRole == false) | MESSAGE | MessageBox.Show | ("You have no right to add memo") | 메시지 표시 |  |  |  |
| AC-214ffa80 | this.Load | FPC0111_AlarmEditPopup.cs:215 | else of (SrcRow!=null) ▸ if (HasRole == false) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-5887233a | this.Load | FPC0111_AlarmEditPopup.cs:216 | else of (SrcRow!=null) ▸ if (HasRole == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6497de28 | this.Load | FPC0111_AlarmEditPopup.cs:222 | if (SrcRow != null) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4d9dbca5 | this.Load | FPC0111_AlarmEditPopup.cs:224 | if (SrcRow != null) | DATA_OP | Filter["COMPANY_ID"] | SrcRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ac3226d1 | this.Load | FPC0111_AlarmEditPopup.cs:225 | if (SrcRow != null) | DATA_OP | Filter["DIVISION_ID"] | SrcRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-816dc23e | this.Load | FPC0111_AlarmEditPopup.cs:226 | if (SrcRow != null) | DATA_OP | Filter["SITE_ID"] | SrcRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-22102850 | this.Load | FPC0111_AlarmEditPopup.cs:227 | if (SrcRow != null) | DATA_OP | Filter["LINE_ID"] | SrcRow["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f3ce0593 | this.Load | FPC0111_AlarmEditPopup.cs:228 | if (SrcRow != null) | DATA_OP | Filter["PLANT_ID"] | SrcRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-961f5503 | this.Load | FPC0111_AlarmEditPopup.cs:229 | if (SrcRow != null) | DATA_OP | Filter["FACTORY_ID"] | SrcRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6f8918fb | this.Load | FPC0111_AlarmEditPopup.cs:230 | if (SrcRow != null) | DATA_OP | Filter["OPERATION_ID"] | SrcRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4327ba69 | this.Load | FPC0111_AlarmEditPopup.cs:231 | if (SrcRow != null) | DATA_OP | Filter["TOP_ITEM_ID"] | SrcRow["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a8708a17 | this.Load | FPC0111_AlarmEditPopup.cs:232 | if (SrcRow != null) | DATA_OP | Filter["PRODUCTION_TYPE"] | SrcRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-575ffe57 | this.Load | FPC0111_AlarmEditPopup.cs:233 | if (SrcRow != null) | DATA_OP | Filter["MARKET"] | SrcRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5a385975 | this.Load | FPC0111_AlarmEditPopup.cs:234 | if (SrcRow != null) | DATA_OP | Filter["PLAN_DATE"] | Day.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-bca3cfb0 | this.Load | FPC0111_AlarmEditPopup.cs:235 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-86cf1067 | this.Load | FPC0111_AlarmEditPopup.cs:236 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | SrcRow["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e4cf279f | this.Load | FPC0111_AlarmEditPopup.cs:238 | if (SrcRow != null) ▸ else of (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-412eec30 | this.Load | FPC0111_AlarmEditPopup.cs:239 | if (SrcRow != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | SrcRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1974da0b | this.Load | FPC0111_AlarmEditPopup.cs:240 | if (SrcRow != null) | DATA_OP | Filter["ITEM_ID"] | SrcRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-834a43c9 | this.Load | FPC0111_AlarmEditPopup.cs:242 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_FROM"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3419d884 | this.Load | FPC0111_AlarmEditPopup.cs:243 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_TO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a1b44138 | this.Load | FPC0111_AlarmEditPopup.cs:245 | if (SrcRow != null) | ENDPOINT | DataService.FP_ExecuteQuery | ("PICAlarm", "find_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] \| FP\Common\PICAlar… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-27a14fe9 | this.Load | FPC0111_AlarmEditPopup.cs:257 | if (SrcRow != null) ▸ if (memoInfo.Good()) | VALUE_SET | txtMemo.Text | memo | 컨트롤 값 설정 |  |  |  |
| AC-a7241dec | this.Load | FPC0111_AlarmEditPopup.cs:261 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmTime ==null) | VALUE_SET | txtAlarm.Text | "N/A" | 컨트롤 값 설정 |  |  |  |
| AC-effff277 | this.Load | FPC0111_AlarmEditPopup.cs:267 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ else of (alarmTime ==null) ▸ if (alarmTime.Value.Year < 1901) | VALUE_SET | txtAlarm.Text | "N/A" | 컨트롤 값 설정 |  |  |  |
| AC-492d9a8e | this.Load | FPC0111_AlarmEditPopup.cs:272 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ else of (alarmTime ==null) ▸ else of (alarmTime.Value.Year < 1901) | VALUE_SET | txtAlarm.Text | alarmTime.Value.ToString("yyyy-MM-dd hh:mm:ss") | 컨트롤 값 설정 |  |  |  |
| AC-48449b1b | this.Load | FPC0111_AlarmEditPopup.cs:278 | if (SrcRow != null) ▸ if (memoInfo.Good()) | DATA_OP | Filter["OLD_PIC_REF"] | Filter["PIC_REF"] = memoInfo.Tables[0].Rows[0]["PIC_REF"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-484d6897 | this.Load | FPC0111_AlarmEditPopup.cs:278 | if (SrcRow != null) ▸ if (memoInfo.Good()) | DATA_OP | Filter["PIC_REF"] | memoInfo.Tables[0].Rows[0]["PIC_REF"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-05523933 | this.Load | FPC0111_AlarmEditPopup.cs:279 | if (SrcRow != null) ▸ if (memoInfo.Good()) | ENDPOINT | DataService.FP_ExecuteQuery | ("PICAlarm", "find_alarm", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] \| FP\Common\PICAla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2d43ecb7 | this.Load | FPC0111_AlarmEditPopup.cs:292 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | CALL_EXT | siMain.AddRows | (row_index, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d4b2d00 | this.Load | FPC0111_AlarmEditPopup.cs:298 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-09ed2d9a | this.Load | FPC0111_AlarmEditPopup.cs:300 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.USER_ID), row_index, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bb38f351 | this.Load | FPC0111_AlarmEditPopup.cs:301 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.TEAM_NAME), row_index, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-406ce6e1 | this.Load | FPC0111_AlarmEditPopup.cs:302 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.PHONE), row_index, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d5eed927 | this.Load | FPC0111_AlarmEditPopup.cs:306 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.USER_ID, ro["USERID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-afca239f | this.Load | FPC0111_AlarmEditPopup.cs:307 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.TEAM_NAME, ro["DEPT_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-8184d9a7 | this.Load | FPC0111_AlarmEditPopup.cs:308 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.USER_NAME, ro["USER_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-08841b3b | this.Load | FPC0111_AlarmEditPopup.cs:309 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.EMAIL, ro["EMAIL"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-38997f29 | this.Load | FPC0111_AlarmEditPopup.cs:310 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.PHONE, ro["PHONE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-78287de1 | this.Load | FPC0111_AlarmEditPopup.cs:312 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-45821767 | this.Load | FPC0111_AlarmEditPopup.cs:324 | if (SrcRow != null) ▸ else of (memoInfo.Good()) | VALUE_CLEAR | txtMemo.Text | "" | 컨트롤 값 비움 |  |  |  |

## FPC0111_AlarmEditPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8b17235 | this.Load | FPC0111_AlarmEditPopup.cs:358 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7f66592c | this.Load | FPC0111_AlarmEditPopup.cs:360 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0111_AlarmEditPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5781139 | this.spdMain.CellClick | FPC0111_AlarmEditPopup.cs:519 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0111_AlarmEditPopup.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccb5b3da | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:637 | if (this.IsEditMode != true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae6790e6 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:639 | if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.RowsAdded) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5ff37fe | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:652 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c9880f4d | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:657 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (cRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1fa9ccf | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:664 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) | DATA_OP | param["USER_ID"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ca7349f7 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:669 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | POPUP | new FP00602_UserFindPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e559e49c | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:670 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | UI_PROP | UserPopup._UserId | user_id | 속성 _UserId 설정 |  |  |  |
| AC-f78711ed | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:672 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | UI_PROP | UserPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-1cf50603 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:673 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | UI_PROP | UserPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-dd8274e3 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:676 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | POPUP | UserPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-29f2f908 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:685 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 3].Value | user_name | 그리드 속성/값 설정 |  |  |  |
| AC-ac9446f9 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:686 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 2].Value | dept_name | 그리드 속성/값 설정 |  |  |  |
| AC-3e92f866 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:687 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | DATA_OP | dept_name.ToUpper().Contains | ("LG CNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-86724004 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:687 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | DATA_OP | dept_name.ToUpper().Contains | ("LGCNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a96b4dd | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:688 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | DATA_OP | dept_name.ToUpper().Contains | ("DEV") | 데이터 객체 조작/조회 |  |  |  |
| AC-f90bb262 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:690 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) ▸ i… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgespartner.com" | 그리드 속성/값 설정 |  |  |  |
| AC-26d4a246 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:694 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) ▸ e… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgensol.com" | 그리드 속성/값 설정 |  |  |  |
| AC-c5d1150d | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:700 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ else of (UserPopup.ShowDialog() == DialogResult.OK… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-400a623d | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:708 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "get_userinfo", param.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_userinfo] \| FP\Common\PICA… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bb049aeb | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:712 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ catch () | MESSAGE | MessageBox.Show | ("Cannot find user") | 메시지 표시 |  |  |  |
| AC-706d6c1d | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:713 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad93a19c | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:722 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 3].Value | user_name = dsUser.Rows[0]["UserName"].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-839d9441 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:723 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 2].Value | dept_name = dsUser.Rows[0]["Dept_Name"].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-c31b80df | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:724 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) | DATA_OP | dept_name.ToUpper().Contains | ("LG CNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6d98f62 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:724 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) | DATA_OP | dept_name.ToUpper().Contains | ("LGCNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-273128b1 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:726 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) ▸ if (dept_name.ToUpper().… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgespartner.com" | 그리드 속성/값 설정 |  |  |  |
| AC-99a91647 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:730 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) ▸ else of (dept_name.ToUpp… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgensol.com" | 그리드 속성/값 설정 |  |  |  |
| AC-c5e096b7 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:738 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 1].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-f2e1b839 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:739 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 2].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-f99ae5f9 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:740 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 3].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-a4bbe048 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:741 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-20be11e8 | dsdmMain.Changed | FPC0111_AlarmEditPopup.cs:742 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 5].Value | "" | 그리드 속성/값 설정 |  |  |  |

## FPC0111_AlarmEditPopup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6776ef24 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:849 |  | POPUP | new FPC0112_AlarmPopup | () | 팝업/폼 생성 |  |  |  |
| AC-72805afd | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:850 |  | UI_PROP | memoPopup.IsRef | true | 속성 IsRef 설정 |  |  |  |
| AC-9d8cff91 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:851 |  | UI_PROP | memoPopup.CanSave | false | 속성 CanSave 설정 |  |  |  |
| AC-85935387 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:852 |  | VALUE_SET | memoPopup.Text | "Alarm / Memo" | 컨트롤 값 설정 |  |  |  |
| AC-4f5dfbc3 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:853 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b6d1d2d6 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:853 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-df68344f | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:854 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | DateTime.Now.AddDays(-8).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-cd1a8ff1 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:855 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | DateTime.Now.AddDays(8).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b1c8d18f | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:858 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4cd4d82a | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:860 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6a5b45b0 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:861 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7ca905c2 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:862 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2116c6fc | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:863 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-132cf22f | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:864 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1f9c50e1 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:865 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-244832ba | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:867 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2322798f | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:868 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-e5f15c2e | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:869 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-fb84dc7d | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:870 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-50f59fed | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:884 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) | DATA_OP | Filter["PIC_REF"] | pic_ref | 행/컬럼 값 대입 |  |  |  |
| AC-6b1a187e | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:885 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) | ENDPOINT | DataService.FP_ExecuteQuery | ("PICAlarm", "find_alarm", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] \| FP\Common\PICAla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3792ecac | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:895 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | userids.Contains | (auser) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0049dc0 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:897 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | userids.Add | (auser) | 데이터 객체 조작/조회 |  |  |  |
| AC-689a2240 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:898 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | username.Add | (aname) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0f7f635 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:899 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | team.Add | (ateam) | 데이터 객체 조작/조회 |  |  |  |
| AC-624fdc9e | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:900 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | mail.Add | (amail) | 데이터 객체 조작/조회 |  |  |  |
| AC-26b10154 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:901 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | phone.Add | (aphone) | 데이터 객체 조작/조회 |  |  |  |
| AC-8add7e31 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:941 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | CALL_EXT | siMain.AddRows | (row_index, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b48ddeca | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:950 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.USER_ID, userid) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0822508 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:951 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.TEAM_NAME, adeptname) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee1d6c4c | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:953 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.USER_NAME, ausername) | 데이터 객체 조작/조회 |  |  |  |
| AC-a29bebd4 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:954 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.EMAIL, email) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f1ab11b | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:955 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.PHONE, aphone) | 데이터 객체 조작/조회 |  |  |  |
| AC-74013bf8 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:957 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-c94ecaad | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:959 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5e1ddac7 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:961 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.USER_ID), row_index, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eecec284 | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:962 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.TEAM_NAME), row_index, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e4bcd4ad | this.usrButton2.Click | FPC0111_AlarmEditPopup.cs:963 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.PHONE), row_index, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |

## FPC0111_AlarmEditPopup.usrButton3_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fa2ac45 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:761 | try | DATA_OP | Filter["BUCKET_FROM"] | Filter["BUCKET_TO"] = dpPlanDate.Text | 행/컬럼 값 대입 |  |  |  |
| AC-e1600246 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:761 | try | DATA_OP | Filter["BUCKET_TO"] | dpPlanDate.Text | 행/컬럼 값 대입 |  |  |  |
| AC-a79ee9e4 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:763 | try | DATA_OP | Filter["MEMO"] | txtMemo.Text | 행/컬럼 값 대입 |  |  |  |
| AC-a703f201 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:764 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b866bf69 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:766 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("PICAlarm", "max_pic_ref", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=max_pic_ref] \| FP\Common\PICAl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-37d52466 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:769 | try ▸ if (max_pic_ref.Good()) | DATA_OP | Filter["PIC_REF"] | max_pic_ref.Tables[0].Rows[0]["PIC_REF"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-173659e2 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:772 | try | UI_PROP | alarm.TableName | "AlarmData" | 속성 TableName 설정 |  |  |  |
| AC-03c405d0 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:773 | try | DATA_OP | alarm.Columns.SafeAdd | ("P_USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-07fb8aa1 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:774 | try | DATA_OP | alarm.Columns.SafeAdd | ("PIC_REF", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ecaa7af | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:775 | try | DATA_OP | alarm.Columns.SafeAdd | ("EMAIL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd85128a | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:776 | try | DATA_OP | alarm.Columns.SafeAdd | ("PHONE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd0de4e2 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:777 | try | DATA_OP | alarm.Columns.SafeAdd | ("DEPT_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e093a58 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:778 | try | DATA_OP | alarm.Columns.SafeAdd | ("USER_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-79cfb8fa | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:779 | try | DATA_OP | alarm.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-16abf799 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:788 | try ▸ for (i<len) ▸ if (string.IsNullOrWhiteSpace(picuser)) | MESSAGE | MessageBox.Show | ("Need to specify PIC user id") | 메시지 표시 |  |  |  |
| AC-380f7222 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:789 | try ▸ for (i<len) ▸ if (string.IsNullOrWhiteSpace(picuser)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a96ad92 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:795 | try ▸ for (i<len) | DATA_OP | alarm.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6c7021f0 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:796 | try ▸ for (i<len) | DATA_OP | insRow["PIC_REF"] | Filter["PIC_REF"] | 행/컬럼 값 대입 |  |  |  |
| AC-1f33e956 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:797 | try ▸ for (i<len) | DATA_OP | insRow["P_USER_ID"] | picuser | 행/컬럼 값 대입 |  |  |  |
| AC-337bc357 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:798 | try ▸ for (i<len) | DATA_OP | insRow["USER_NAME"] | siMain.ActiveSheet.Cells[i, 3].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5bf61cb6 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:799 | try ▸ for (i<len) | DATA_OP | insRow["DEPT_NAME"] | siMain.ActiveSheet.Cells[i, 2].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-82238548 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:800 | try ▸ for (i<len) | DATA_OP | insRow["EMAIL"] | siMain.ActiveSheet.Cells[i, 4].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-68be01de | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:801 | try ▸ for (i<len) | DATA_OP | insRow["PHONE"] | phone | 행/컬럼 값 대입 |  |  |  |
| AC-92d34dd3 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:802 | try ▸ for (i<len) | DATA_OP | insRow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6bc1de99 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:804 | try ▸ for (i<len) | DATA_OP | alarm.Rows.Add | (insRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-584d214e | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:809 | try | ENDPOINT | DataService.FP_PseudoBatch2 | ("PICAlarm", "save_alarm", alarm) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_alarm] \| FP\Common\PICAlar… | 엔드포인트 호출 |  |  |  |
| AC-5ee74a7a | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:810 | try | CALL_EXT | DataService.ReadResult | (res) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e94a88fc | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:813 | try ▸ if (result.Success) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("PICAlarm", "save_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] \| FP\Common\PICA… | 엔드포인트 호출 |  |  |  |
| AC-f602af1b | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:815 | try ▸ if (result.Success) | MESSAGE | MessageBox.Show | ("Save alarm success") | 메시지 표시 |  |  |  |
| AC-a6c1ab00 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:816 | try ▸ if (result.Success) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-759e1b4b | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:817 | try ▸ if (result.Success) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-6b6a4808 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:821 | try ▸ else of (result.Success) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("PICAlarm", "save_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] \| FP\Common\PICA… | 엔드포인트 호출 |  |  |  |
| AC-02ce6f52 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:823 | try ▸ else of (result.Success) | MESSAGE | MessageBox.Show | ("Save as memo") | 메시지 표시 |  |  |  |
| AC-abf01293 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:824 | try ▸ else of (result.Success) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-913c4173 | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:825 | try ▸ else of (result.Success) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-d6fada4c | this.btnSave.Click | FPC0111_AlarmEditPopup.cs:830 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Save Error: " + xe.Message) | 메시지 표시 |  |  |  |

## FPC0111_AlarmEditPopup.usrButton4_Click

진입점: this.usrButton4.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5eeb5714 | this.usrButton4.Click | FPC0111_AlarmEditPopup.cs:843 | if (rowindex >= 0) | CALL_EXT | siMain.ActiveSheet.RemoveRows | (rowindex, 1) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0111_AlarmEditPopup.usrButton5_Click

진입점: this.usrButton5.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0385c92a | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:572 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | new FP00602_UserFindPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7810447d | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:574 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | UserPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-5bb812ff | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:575 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | UserPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-9576a2b3 | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:579 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | UserPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1bafeeb9 | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:588 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (UserPopup.ShowDialog(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f0d211e4 | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:595 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.AddRows | (row_index, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f96b168 | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:604 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.USER_ID, user_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-057a05dc | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:605 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.TEAM_NAME, team_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfae1f8c | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:607 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | team_name.ToUpper().Contains | ("LG CNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb9f04b3 | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:607 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | team_name.ToUpper().Contains | ("LGCNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7e73623 | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:613 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.USER_NAME, user_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-24b569ee | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:614 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.EMAIL, email) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf3c1266 | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:615 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.PHONE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ffd8519 | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:617 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-b0edee83 | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:619 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9bbc913c | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:621 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.USER_ID), row_index, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-38851aeb | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:622 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.TEAM_NAME), row_index, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-72df1547 | this.usrButton5.Click | FPC0111_AlarmEditPopup.cs:623 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.PHONE), row_index, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |

## FPC0111_AlarmEditPopup2..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52a7441b | .ctor | FPC0111_AlarmEditPopup2.cs:127 |  | FLAG | SrcRow | row | 화면 필드/플래그 변경 |  |  |  |
| AC-04e4c6a3 | .ctor | FPC0111_AlarmEditPopup2.cs:128 |  | FLAG | iColumn | colindex | 화면 필드/플래그 변경 |  |  |  |
| AC-ddffb520 | .ctor | FPC0111_AlarmEditPopup2.cs:129 |  | FLAG | iRow | rowindex | 화면 필드/플래그 변경 |  |  |  |
| AC-f6423efb | .ctor | FPC0111_AlarmEditPopup2.cs:130 |  | FLAG | Day | date | 화면 필드/플래그 변경 |  |  |  |
| AC-cde3a73a | .ctor | FPC0111_AlarmEditPopup2.cs:132 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ccd7d560 | .ctor | FPC0111_AlarmEditPopup2.cs:133 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-034b05cc | .ctor | FPC0111_AlarmEditPopup2.cs:134 |  | FLAG | this.sDivisionId | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-71d4ba8a | .ctor | FPC0111_AlarmEditPopup2.cs:142 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-6a3deb0b | .ctor | FPC0111_AlarmEditPopup2.cs:143 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-b2a3f798 | .ctor | FPC0111_AlarmEditPopup2.cs:145 |  | CALL_EXT | searchParam.TryGetValue | ("COMPANY_ID", out this.sCompanyId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b770abe7 | .ctor | FPC0111_AlarmEditPopup2.cs:146 |  | CALL_EXT | searchParam.TryGetValue | ("DIVISION_ID", out this.sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0ea81b3 | .ctor | FPC0111_AlarmEditPopup2.cs:147 |  | CALL_EXT | searchParam.TryGetValue | ("SITE_ID", out sSiteId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-418364b2 | .ctor | FPC0111_AlarmEditPopup2.cs:148 |  | CALL_EXT | searchParam.TryGetValue | ("LEVEL_2_CODE", out sLevel2Code) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe2d5624 | .ctor | FPC0111_AlarmEditPopup2.cs:149 |  | CALL_EXT | searchParam.TryGetValue | ("LEVEL_2_CODE_FLAG", out sLevel2CodeFlag) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0770ac4 | .ctor | FPC0111_AlarmEditPopup2.cs:150 |  | CALL_EXT | searchParam.TryGetValue | ("IS_FORMATION_FLOW_ID_EXISTS", out sIsFormationFlowIdExists) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0111_AlarmEditPopup2.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bf24653 | (진입점 미연결) | FPC0111_AlarmEditPopup2.cs:471 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-a97b7a1f | (진입점 미연결) | FPC0111_AlarmEditPopup2.cs:474 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0111_AlarmEditPopup2.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c93d3544 | this.Load | FPC0111_AlarmEditPopup2.cs:312 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d5234be8 | this.Load | FPC0111_AlarmEditPopup2.cs:313 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-76db2ec7 | this.Load | FPC0111_AlarmEditPopup2.cs:314 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0111_AlarmEditPopup2.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b69ec8bf | this.Load | FPC0111_AlarmEditPopup2.cs:307 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0111_AlarmEditPopup2.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45a0a527 | Dispose | FPC0111_AlarmEditPopup2.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0111_AlarmEditPopup2.FindData

진입점: FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7b592ef | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:381 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-db07c9c6 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:382 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-38f358b0 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:385 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4921c23c | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:387 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Common.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b2646e68 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:391 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Common.PR_UI_COMMON_POPUP") ⇒ FP_Common.PR_UI_COMMON_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-4969103f | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:393 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4c05526f | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:395 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-6d9990cc | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:396 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | "ITEM_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-e09d2ba4 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:397 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1c48d550 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:398 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-635da1ed | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:399 | lambda | DATA_OP | request.Parameters["p_non_auth"] | _sNonAuth | 행/컬럼 값 대입 |  |  |  |
| AC-edfc2bab | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:400 | lambda | DATA_OP | request.Parameters["p_save_auth"] | _sSaveAuth | 행/컬럼 값 대입 |  |  |  |
| AC-e4b5626e | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:402 | lambda | DATA_OP | request.Parameters["p_param1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1cb2ce79 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:403 | lambda | DATA_OP | request.Parameters["p_param2"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-184ef465 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:404 | lambda | DATA_OP | request.Parameters["p_param3"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-f5182965 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:405 | lambda | DATA_OP | request.Parameters["p_param4"] | pItemID.Equals("ALL") ? DBNull.Value : pItemID | 행/컬럼 값 대입 |  |  |  |
| AC-f21c7735 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:406 | lambda | DATA_OP | request.Parameters["p_param5"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-31d30414 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:407 | lambda | DATA_OP | request.Parameters["p_param6"] | (string.IsNullOrEmpty(sLevel2CodeFlag)) ? DBNull.Value : sLevel2CodeFlag as object | 행/컬럼 값 대입 |  |  |  |
| AC-13ebebed | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:408 | lambda | DATA_OP | request.Parameters["p_param7"] | (string.IsNullOrEmpty(sLevel2Code)) ? DBNull.Value : sLevel2Code as object | 행/컬럼 값 대입 |  |  |  |
| AC-615e1d5c | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:409 | lambda | DATA_OP | request.Parameters["p_param8"] | (string.IsNullOrEmpty(sIsFormationFlowIdExists)) ? DBNull.Value : sIsFormationFlowIdExists… | 행/컬럼 값 대입 |  |  |  |
| AC-7739cf50 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:410 | lambda | DATA_OP | request.Parameters["p_param9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a8bcbfff | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:411 | lambda | DATA_OP | request.Parameters["p_param10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7f7e7b2e | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:413 | lambda | DATA_OP | request.Parameters["p_param11"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bcef7bfd | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:414 | lambda | DATA_OP | request.Parameters["p_param12"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bd12d3c0 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:415 | lambda | DATA_OP | request.Parameters["p_param13"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-00495e5d | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:416 | lambda | DATA_OP | request.Parameters["p_param14"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-06bb0c98 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:417 | lambda | DATA_OP | request.Parameters["p_param15"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-04a79ebc | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:418 | lambda | DATA_OP | request.Parameters["p_param16"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6143a536 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:419 | lambda | DATA_OP | request.Parameters["p_param17"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8d7f4f21 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:420 | lambda | DATA_OP | request.Parameters["p_param18"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-33904ade | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:421 | lambda | DATA_OP | request.Parameters["p_param19"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1713b7b1 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:422 | lambda | DATA_OP | request.Parameters["p_param20"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c193697b | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:423 | lambda | DATA_OP | request.Parameters["TimeZone"] | TimeZone | 행/컬럼 값 대입 |  |  |  |
| AC-a5611023 | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:425 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-36d34efc | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:427 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6b57f2ac | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:432 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d8464a9b | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:436 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-b1c2c3de | FindButton 외 1 | FPC0111_AlarmEditPopup2.cs:442 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0111_AlarmEditPopup2.fn_setRowInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72606071 | (진입점 미연결) | FPC0111_AlarmEditPopup2.cs:511 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d1d2653 | (진입점 미연결) | FPC0111_AlarmEditPopup2.cs:512 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-543bcc22 | (진입점 미연결) | FPC0111_AlarmEditPopup2.cs:521 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0111_AlarmEditPopup2.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2414162 | this.Load | FPC0111_AlarmEditPopup2.cs:161 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7a651524 | this.Load | FPC0111_AlarmEditPopup2.cs:163 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-07b6b942 | this.Load | FPC0111_AlarmEditPopup2.cs:169 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |

## FPC0111_AlarmEditPopup2.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62bd9aa4 | this.Load | FPC0111_AlarmEditPopup2.cs:189 | if (SrcRow!=null) | VALUE_SET | dpPlanDate.Text | Day.Date.ToString("yyyyMMdd") | 컨트롤 값 설정 |  |  |  |
| AC-d8c9edd5 | this.Load | FPC0111_AlarmEditPopup2.cs:190 | if (SrcRow!=null) | VALUE_SET | txtProdType.Text | SrcRow["PRODUCTION_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-3bb37069 | this.Load | FPC0111_AlarmEditPopup2.cs:191 | if (SrcRow!=null) | VALUE_SET | txtModel.Text | SrcRow["TOP_ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-55746206 | this.Load | FPC0111_AlarmEditPopup2.cs:192 | if (SrcRow!=null) | VALUE_SET | txtItem.Text | SrcRow["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-12cb5732 | this.Load | FPC0111_AlarmEditPopup2.cs:193 | if (SrcRow!=null) | VALUE_SET | txtNickName.Text | SrcRow["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-3b44d983 | this.Load | FPC0111_AlarmEditPopup2.cs:194 | if (SrcRow!=null) | VALUE_SET | txtItemType.Text | SrcRow["ITEM_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-4d6683d4 | this.Load | FPC0111_AlarmEditPopup2.cs:195 | if (SrcRow!=null) | VALUE_SET | txtFactory.Text | SrcRow["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b1e1af89 | this.Load | FPC0111_AlarmEditPopup2.cs:196 | if (SrcRow!=null) | VALUE_SET | txtMarket.Text | SrcRow["MARKET"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-86be2e97 | this.Load | FPC0111_AlarmEditPopup2.cs:197 | if (SrcRow!=null) | VALUE_SET | txtOperation.Text | SrcRow["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-0609ab90 | this.Load | FPC0111_AlarmEditPopup2.cs:198 | if (SrcRow!=null) | VALUE_SET | txtLine.Text | SrcRow["LINE_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-4a0c68ef | this.Load | FPC0111_AlarmEditPopup2.cs:199 | if (SrcRow!=null) | VALUE_SET | txtElectrode.Text | SrcRow["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-9f34ccb8 | this.Load | FPC0111_AlarmEditPopup2.cs:200 | if (SrcRow!=null) | VALUE_SET | txtLocation.Text | SrcRow["LOCATION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-fe384565 | this.Load | FPC0111_AlarmEditPopup2.cs:206 | if (SrcRow != null) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0b17a6ef | this.Load | FPC0111_AlarmEditPopup2.cs:208 | if (SrcRow != null) | DATA_OP | Filter["COMPANY_ID"] | SrcRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1f15efc3 | this.Load | FPC0111_AlarmEditPopup2.cs:209 | if (SrcRow != null) | DATA_OP | Filter["DIVISION_ID"] | SrcRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-39fec371 | this.Load | FPC0111_AlarmEditPopup2.cs:210 | if (SrcRow != null) | DATA_OP | Filter["SITE_ID"] | SrcRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f77157d4 | this.Load | FPC0111_AlarmEditPopup2.cs:211 | if (SrcRow != null) | DATA_OP | Filter["LINE_ID"] | SrcRow["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d02672e3 | this.Load | FPC0111_AlarmEditPopup2.cs:212 | if (SrcRow != null) | DATA_OP | Filter["PLANT_ID"] | SrcRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f533fd2b | this.Load | FPC0111_AlarmEditPopup2.cs:213 | if (SrcRow != null) | DATA_OP | Filter["FACTORY_ID"] | SrcRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4f560331 | this.Load | FPC0111_AlarmEditPopup2.cs:214 | if (SrcRow != null) | DATA_OP | Filter["OPERATION_ID"] | SrcRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5b63390b | this.Load | FPC0111_AlarmEditPopup2.cs:215 | if (SrcRow != null) | DATA_OP | Filter["TOP_ITEM_ID"] | SrcRow["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-33e7ea25 | this.Load | FPC0111_AlarmEditPopup2.cs:216 | if (SrcRow != null) | DATA_OP | Filter["PRODUCTION_TYPE"] | SrcRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b09ec370 | this.Load | FPC0111_AlarmEditPopup2.cs:217 | if (SrcRow != null) | DATA_OP | Filter["MARKET"] | SrcRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4be4a468 | this.Load | FPC0111_AlarmEditPopup2.cs:218 | if (SrcRow != null) | DATA_OP | Filter["PLAN_DATE"] | Day.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-e80570d9 | this.Load | FPC0111_AlarmEditPopup2.cs:219 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c9655b7 | this.Load | FPC0111_AlarmEditPopup2.cs:220 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | SrcRow["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d737992a | this.Load | FPC0111_AlarmEditPopup2.cs:222 | if (SrcRow != null) ▸ else of (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-4fcba74d | this.Load | FPC0111_AlarmEditPopup2.cs:223 | if (SrcRow != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | SrcRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a02ea5b7 | this.Load | FPC0111_AlarmEditPopup2.cs:224 | if (SrcRow != null) | DATA_OP | Filter["ITEM_ID"] | SrcRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ee655cd9 | this.Load | FPC0111_AlarmEditPopup2.cs:226 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_FROM"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3706399b | this.Load | FPC0111_AlarmEditPopup2.cs:227 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_TO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-be835392 | this.Load | FPC0111_AlarmEditPopup2.cs:229 | if (SrcRow != null) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "find_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5461c4ef | this.Load | FPC0111_AlarmEditPopup2.cs:241 | if (SrcRow != null) ▸ if (memoInfo.Good()) | VALUE_SET | txtMemo.Text | memo | 컨트롤 값 설정 |  |  |  |
| AC-d107d8a9 | this.Load | FPC0111_AlarmEditPopup2.cs:244 | if (SrcRow != null) ▸ if (memoInfo.Good()) | DATA_OP | Filter["OLD_PIC_REF"] | Filter["PIC_REF"] = memoInfo.Tables[0].Rows[0]["PIC_REF"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-26a26ea3 | this.Load | FPC0111_AlarmEditPopup2.cs:244 | if (SrcRow != null) ▸ if (memoInfo.Good()) | DATA_OP | Filter["PIC_REF"] | memoInfo.Tables[0].Rows[0]["PIC_REF"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0cfdd0f6 | this.Load | FPC0111_AlarmEditPopup2.cs:245 | if (SrcRow != null) ▸ if (memoInfo.Good()) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "find_alarm", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] \| FP\{?default:par… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-06310c87 | this.Load | FPC0111_AlarmEditPopup2.cs:258 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | CALL_EXT | siMain.AddRows | (row_index, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e985f224 | this.Load | FPC0111_AlarmEditPopup2.cs:264 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1d832f04 | this.Load | FPC0111_AlarmEditPopup2.cs:266 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.USER_ID), row_index, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc19240b | this.Load | FPC0111_AlarmEditPopup2.cs:267 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.TEAM_NAME), row_index, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-17a643af | this.Load | FPC0111_AlarmEditPopup2.cs:268 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.PHONE), row_index, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1be2b904 | this.Load | FPC0111_AlarmEditPopup2.cs:272 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.USER_ID, ro["USERID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c8c5823 | this.Load | FPC0111_AlarmEditPopup2.cs:273 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.TEAM_NAME, ro["DEPT_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c614402 | this.Load | FPC0111_AlarmEditPopup2.cs:274 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.USER_NAME, ro["USER_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-0087e068 | this.Load | FPC0111_AlarmEditPopup2.cs:275 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.EMAIL, ro["EMAIL"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-7795314c | this.Load | FPC0111_AlarmEditPopup2.cs:276 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.PHONE, ro["PHONE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e976a8bb | this.Load | FPC0111_AlarmEditPopup2.cs:278 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-9a6d1760 | this.Load | FPC0111_AlarmEditPopup2.cs:290 | if (SrcRow != null) ▸ else of (memoInfo.Good()) | VALUE_CLEAR | txtMemo.Text | "" | 컨트롤 값 비움 |  |  |  |

## FPC0111_AlarmEditPopup2.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-369bdaf7 | this.Load | FPC0111_AlarmEditPopup2.cs:324 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-79838396 | this.Load | FPC0111_AlarmEditPopup2.cs:326 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0111_AlarmEditPopup2.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66070313 | this.spdMain.CellClick | FPC0111_AlarmEditPopup2.cs:485 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0111_AlarmEditPopup2.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75298e41 | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:575 | if (this.IsEditMode != true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f99f0f9 | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:577 | if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.RowsAdded) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17b6fa56 | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:590 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-40816a53 | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:595 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (cRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-111a0236 | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:602 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) | DATA_OP | param["USER_ID"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-003ef46c | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:604 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("AmendMemo", "get_userinfo", param.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_userinfo] \| FP\{?default:p… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4d0f669f | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:631 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 3].Value | user_name = dsUser.Rows[0]["UserName"].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-8f06b17f | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:632 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 2].Value | dept_name = dsUser.Rows[0]["Dept_Name"].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-edf84ffc | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:633 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (dsUser.Good()) | DATA_OP | dept_name.ToUpper().Contains | ("LG CNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ab18915 | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:633 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (dsUser.Good()) | DATA_OP | dept_name.ToUpper().Contains | ("LGCNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a5f7932 | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:635 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (dsUser.Good()) ▸ if (dept_name.ToUpper().Contains("LG CNS") \|\… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgespartner.com" | 그리드 속성/값 설정 |  |  |  |
| AC-9cf29ffc | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:638 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (dsUser.Good()) ▸ else of (dept_name.ToUpper().Contains("LG CNS"… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgensol.com" | 그리드 속성/값 설정 |  |  |  |
| AC-1f929ce9 | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:645 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 1].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-4c03a79e | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:646 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 2].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-5da11559 | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:647 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 3].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-b5805baf | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:648 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-b76a70da | dsdmMain.Changed | FPC0111_AlarmEditPopup2.cs:649 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 5].Value | "" | 그리드 속성/값 설정 |  |  |  |

## FPC0111_AlarmEditPopup2.usrButton3_Click

진입점: this.usrButton3.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab46283e | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:752 | try | DATA_OP | Filter["BUCKET_FROM"] | Filter["BUCKET_TO"] = dpPlanDate.Text | 행/컬럼 값 대입 |  |  |  |
| AC-7da5294c | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:752 | try | DATA_OP | Filter["BUCKET_TO"] | dpPlanDate.Text | 행/컬럼 값 대입 |  |  |  |
| AC-e571a925 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:754 | try | DATA_OP | Filter["MEMO"] | txtMemo.Text | 행/컬럼 값 대입 |  |  |  |
| AC-541182ad | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:755 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-67095d6c | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:757 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "max_pic_ref", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=max_pic_ref] \| FP\{?default:pa… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-390e7e3f | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:760 | try ▸ if (max_pic_ref.Good()) | DATA_OP | Filter["PIC_REF"] | max_pic_ref.Tables[0].Rows[0]["PIC_REF"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eb3833bd | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:763 | try | UI_PROP | alarm.TableName | "AlarmData" | 속성 TableName 설정 |  |  |  |
| AC-4873cd92 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:764 | try | DATA_OP | alarm.Columns.SafeAdd | ("P_USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ae4f9e5 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:765 | try | DATA_OP | alarm.Columns.SafeAdd | ("PIC_REF", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-adecf7b7 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:766 | try | DATA_OP | alarm.Columns.SafeAdd | ("EMAIL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfff383d | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:767 | try | DATA_OP | alarm.Columns.SafeAdd | ("PHONE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a367ea0e | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:768 | try | DATA_OP | alarm.Columns.SafeAdd | ("DEPT_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c5736e4 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:769 | try | DATA_OP | alarm.Columns.SafeAdd | ("USER_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-84e38259 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:770 | try | DATA_OP | alarm.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e479142 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:775 | try ▸ for (i<len) | DATA_OP | alarm.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f7b4a4fe | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:776 | try ▸ for (i<len) | DATA_OP | insRow["PIC_REF"] | Filter["PIC_REF"] | 행/컬럼 값 대입 |  |  |  |
| AC-7d4fd642 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:777 | try ▸ for (i<len) | DATA_OP | insRow["P_USER_ID"] | siMain.ActiveSheet.Cells[i, 1].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-77888972 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:778 | try ▸ for (i<len) | DATA_OP | insRow["USER_NAME"] | siMain.ActiveSheet.Cells[i, 3].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0b4e26ba | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:779 | try ▸ for (i<len) | DATA_OP | insRow["DEPT_NAME"] | siMain.ActiveSheet.Cells[i, 2].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4ff6dedc | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:780 | try ▸ for (i<len) | DATA_OP | insRow["EMAIL"] | siMain.ActiveSheet.Cells[i, 4].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a0f36b87 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:781 | try ▸ for (i<len) | DATA_OP | insRow["PHONE"] | siMain.ActiveSheet.Cells[i, 5].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2e5fe7de | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:782 | try ▸ for (i<len) | DATA_OP | insRow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b461d66c | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:784 | try ▸ for (i<len) | DATA_OP | alarm.Rows.Add | (insRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae742f49 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:789 | try | ENDPOINT | DataService.FP_PseudoBatch2 | ("AmendMemo", "save_alarm", alarm) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_alarm] \| FP\{?default:part… | 엔드포인트 호출 |  |  |  |
| AC-d8a32d1a | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:790 | try | CALL_EXT | DataService.ReadResult | (res) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9aae6fbe | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:791 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "save_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] \| FP\Common\Amen… | 엔드포인트 호출 |  |  |  |
| AC-468216a4 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:794 | try | DATA_OP | Filter["SEQ"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-e8577bc1 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:795 | try | DATA_OP | Filter["SETUP_COLOR_CODE"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-c946ad7e | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:798 | try | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-12fd1641 | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:799 | try | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-40ea33cf | this.usrButton3.Click | FPC0111_AlarmEditPopup2.cs:803 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Save Error: " + xe.Message) | 메시지 표시 |  |  |  |

## FPC0111_AlarmEditPopup2.usrButton5_Click

진입점: this.usrButton5.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0afd78ad | this.usrButton5.Click | FPC0111_AlarmEditPopup2.cs:537 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.AddRows | (row_index, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a411b63f | this.usrButton5.Click | FPC0111_AlarmEditPopup2.cs:549 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.USER_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-7810c9dd | this.usrButton5.Click | FPC0111_AlarmEditPopup2.cs:550 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.TEAM_NAME, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b99f43d | this.usrButton5.Click | FPC0111_AlarmEditPopup2.cs:551 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.USER_NAME, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-2311da96 | this.usrButton5.Click | FPC0111_AlarmEditPopup2.cs:552 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.EMAIL, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4fd9806 | this.usrButton5.Click | FPC0111_AlarmEditPopup2.cs:553 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.PHONE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-12a8388a | this.usrButton5.Click | FPC0111_AlarmEditPopup2.cs:555 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-95879216 | this.usrButton5.Click | FPC0111_AlarmEditPopup2.cs:557 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cf962153 | this.usrButton5.Click | FPC0111_AlarmEditPopup2.cs:559 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.USER_ID), row_index, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d7d34d79 | this.usrButton5.Click | FPC0111_AlarmEditPopup2.cs:560 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.TEAM_NAME), row_index, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-51a0bb0d | this.usrButton5.Click | FPC0111_AlarmEditPopup2.cs:561 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.PHONE), row_index, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |


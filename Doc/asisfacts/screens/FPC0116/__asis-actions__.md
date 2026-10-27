# AS-IS 액션 대조표 — FPC0116

> 원천: `Doc/asisfacts/screens/FPC0116/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 242행 · 메서드 16 · 종류 DATA_OP 112 · VALUE_SET 17 · GRID_SET 16 · UI_PROP 15 · GRID_LOCK 13 · ENDPOINT 11 · RETURN 11 · FLAG 9 · UI_MISC 9 · POPUP 8 · CALL_EXT 6 · MESSAGE 6 · GRID_INIT 4 · STATE 3 · GRID_BIND 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 6


## FPC0116_AlarmEditPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb096018 | .ctor | FPC0116_AlarmEditPopup.cs:127 |  | FLAG | SrcRow | row | 화면 필드/플래그 변경 |  |  |  |
| AC-1d5218b9 | .ctor | FPC0116_AlarmEditPopup.cs:128 |  | FLAG | iColumn | colindex | 화면 필드/플래그 변경 |  |  |  |
| AC-0fc2e0d7 | .ctor | FPC0116_AlarmEditPopup.cs:129 |  | FLAG | iRow | rowindex | 화면 필드/플래그 변경 |  |  |  |
| AC-c6206a32 | .ctor | FPC0116_AlarmEditPopup.cs:130 |  | FLAG | Day | date | 화면 필드/플래그 변경 |  |  |  |
| AC-f811ffa3 | .ctor | FPC0116_AlarmEditPopup.cs:134 |  | FLAG | this.sDivisionId | "ALL" | 화면 필드/플래그 변경 |  |  |  |

## FPC0116_AlarmEditPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c21c95a | (진입점 미연결) | FPC0116_AlarmEditPopup.cs:484 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-0853bcb4 | (진입점 미연결) | FPC0116_AlarmEditPopup.cs:487 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0116_AlarmEditPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09a887bf | this.Load | FPC0116_AlarmEditPopup.cs:325 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-34b14c00 | this.Load | FPC0116_AlarmEditPopup.cs:326 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d4fd1304 | this.Load | FPC0116_AlarmEditPopup.cs:327 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0116_AlarmEditPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61a4be0b | this.Load | FPC0116_AlarmEditPopup.cs:320 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0116_AlarmEditPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e384cedf | Dispose | FPC0116_AlarmEditPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0116_AlarmEditPopup.FindData

진입점: FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e8acc44 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:394 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-dc5fd59b | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:395 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fb7677ee | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:398 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-7e73a974 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:400 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Common.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88fffbcc | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:404 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Common.PR_UI_COMMON_POPUP") ⇒ FP_Common.PR_UI_COMMON_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-f7e6948e | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:406 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c580c86e | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:408 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-9d81af35 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:409 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | "ITEM_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-439507b7 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:410 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-73011e3a | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:411 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2463946b | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:412 | lambda | DATA_OP | request.Parameters["p_non_auth"] | _sNonAuth | 행/컬럼 값 대입 |  |  |  |
| AC-b54ab71f | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:413 | lambda | DATA_OP | request.Parameters["p_save_auth"] | _sSaveAuth | 행/컬럼 값 대입 |  |  |  |
| AC-8aeab5c2 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:415 | lambda | DATA_OP | request.Parameters["p_param1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cbd51f5c | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:416 | lambda | DATA_OP | request.Parameters["p_param2"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-cc288a72 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:417 | lambda | DATA_OP | request.Parameters["p_param3"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-eb3c57b9 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:418 | lambda | DATA_OP | request.Parameters["p_param4"] | pItemID.Equals("ALL") ? DBNull.Value : pItemID | 행/컬럼 값 대입 |  |  |  |
| AC-8f063578 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:419 | lambda | DATA_OP | request.Parameters["p_param5"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-cf3361c3 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:420 | lambda | DATA_OP | request.Parameters["p_param6"] | (string.IsNullOrEmpty(sLevel2CodeFlag)) ? DBNull.Value : sLevel2CodeFlag as object | 행/컬럼 값 대입 |  |  |  |
| AC-91938dc3 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:421 | lambda | DATA_OP | request.Parameters["p_param7"] | (string.IsNullOrEmpty(sLevel2Code)) ? DBNull.Value : sLevel2Code as object | 행/컬럼 값 대입 |  |  |  |
| AC-9132368e | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:422 | lambda | DATA_OP | request.Parameters["p_param8"] | (string.IsNullOrEmpty(sIsFormationFlowIdExists)) ? DBNull.Value : sIsFormationFlowIdExists… | 행/컬럼 값 대입 |  |  |  |
| AC-21063ea9 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:423 | lambda | DATA_OP | request.Parameters["p_param9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2c4a952e | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:424 | lambda | DATA_OP | request.Parameters["p_param10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6625381f | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:426 | lambda | DATA_OP | request.Parameters["p_param11"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-52d3e6a5 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:427 | lambda | DATA_OP | request.Parameters["p_param12"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b365f1c7 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:428 | lambda | DATA_OP | request.Parameters["p_param13"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-004e1d7e | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:429 | lambda | DATA_OP | request.Parameters["p_param14"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9d88e36f | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:430 | lambda | DATA_OP | request.Parameters["p_param15"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-adfe4de3 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:431 | lambda | DATA_OP | request.Parameters["p_param16"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-58d1f14f | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:432 | lambda | DATA_OP | request.Parameters["p_param17"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0341c3b6 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:433 | lambda | DATA_OP | request.Parameters["p_param18"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9b0fae3a | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:434 | lambda | DATA_OP | request.Parameters["p_param19"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ca242d38 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:435 | lambda | DATA_OP | request.Parameters["p_param20"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-291fe896 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:436 | lambda | DATA_OP | request.Parameters["TimeZone"] | TimeZone | 행/컬럼 값 대입 |  |  |  |
| AC-1ec6e72a | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:438 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-11f3b4f9 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:440 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0c4c18af | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:445 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3df59aaf | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:449 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-b08ec3f5 | FindButton 외 1 | FPC0116_AlarmEditPopup.cs:455 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0116_AlarmEditPopup.fn_setRowInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c936c85 | (진입점 미연결) | FPC0116_AlarmEditPopup.cs:524 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b710a34 | (진입점 미연결) | FPC0116_AlarmEditPopup.cs:525 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7617ba30 | (진입점 미연결) | FPC0116_AlarmEditPopup.cs:534 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0116_AlarmEditPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c64fa7de | this.Load | FPC0116_AlarmEditPopup.cs:143 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c87523a3 | this.Load | FPC0116_AlarmEditPopup.cs:145 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9890c244 | this.Load | FPC0116_AlarmEditPopup.cs:148 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |

## FPC0116_AlarmEditPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1b1409e | this.Load | FPC0116_AlarmEditPopup.cs:167 |  | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2cefb4b5 | this.Load | FPC0116_AlarmEditPopup.cs:170 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ca16d795 | this.Load | FPC0116_AlarmEditPopup.cs:171 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | usrButton4.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8390089f | this.Load | FPC0116_AlarmEditPopup.cs:172 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | usrButton5.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-44b95b00 | this.Load | FPC0116_AlarmEditPopup.cs:176 | if (SrcRow!=null) | VALUE_SET | dpPlanDate.Text | Day.Date.ToString("yyyyMMdd") | 컨트롤 값 설정 |  |  |  |
| AC-7e8a5854 | this.Load | FPC0116_AlarmEditPopup.cs:177 | if (SrcRow!=null) | VALUE_SET | txtProdType.Text | SrcRow["PRODUCTION_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-3cbd82e3 | this.Load | FPC0116_AlarmEditPopup.cs:178 | if (SrcRow!=null) | VALUE_SET | txtModel.Text | SrcRow["TOP_ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-50b12364 | this.Load | FPC0116_AlarmEditPopup.cs:179 | if (SrcRow!=null) | VALUE_SET | txtItem.Text | SrcRow["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-defe35cf | this.Load | FPC0116_AlarmEditPopup.cs:180 | if (SrcRow!=null) | VALUE_SET | txtNickName.Text | SrcRow["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-9a442114 | this.Load | FPC0116_AlarmEditPopup.cs:181 | if (SrcRow!=null) | VALUE_SET | txtItemType.Text | SrcRow["ITEM_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-e45591cb | this.Load | FPC0116_AlarmEditPopup.cs:182 | if (SrcRow!=null) | VALUE_SET | txtFactory.Text | SrcRow["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-c63a04e8 | this.Load | FPC0116_AlarmEditPopup.cs:183 | if (SrcRow!=null) | VALUE_SET | txtMarket.Text | SrcRow["MARKET"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b3c89425 | this.Load | FPC0116_AlarmEditPopup.cs:184 | if (SrcRow!=null) | VALUE_SET | txtOperation.Text | SrcRow["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-41890cbf | this.Load | FPC0116_AlarmEditPopup.cs:185 | if (SrcRow!=null) | VALUE_SET | txtLine.Text | SrcRow["LINE_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8d3ff724 | this.Load | FPC0116_AlarmEditPopup.cs:186 | if (SrcRow!=null) | VALUE_SET | txtElectrode.Text | SrcRow["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-375f484c | this.Load | FPC0116_AlarmEditPopup.cs:187 | if (SrcRow!=null) | VALUE_SET | txtLocation.Text | SrcRow["LOCATION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-2c80aec2 | this.Load | FPC0116_AlarmEditPopup.cs:193 | else of (SrcRow!=null) ▸ if (HasRole == false) | MESSAGE | MessageBox.Show | ("You have no right to add memo") | 메시지 표시 |  |  |  |
| AC-88ed62af | this.Load | FPC0116_AlarmEditPopup.cs:194 | else of (SrcRow!=null) ▸ if (HasRole == false) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-9a7f73ff | this.Load | FPC0116_AlarmEditPopup.cs:195 | else of (SrcRow!=null) ▸ if (HasRole == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea14011a | this.Load | FPC0116_AlarmEditPopup.cs:201 | if (SrcRow != null) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e32f0e24 | this.Load | FPC0116_AlarmEditPopup.cs:203 | if (SrcRow != null) | DATA_OP | Filter["COMPANY_ID"] | SrcRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1cd528f8 | this.Load | FPC0116_AlarmEditPopup.cs:204 | if (SrcRow != null) | DATA_OP | Filter["DIVISION_ID"] | SrcRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-66c9a000 | this.Load | FPC0116_AlarmEditPopup.cs:205 | if (SrcRow != null) | DATA_OP | Filter["SITE_ID"] | SrcRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9b3fab98 | this.Load | FPC0116_AlarmEditPopup.cs:206 | if (SrcRow != null) | DATA_OP | Filter["LINE_ID"] | SrcRow["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e3104116 | this.Load | FPC0116_AlarmEditPopup.cs:207 | if (SrcRow != null) | DATA_OP | Filter["PLANT_ID"] | SrcRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-76def61e | this.Load | FPC0116_AlarmEditPopup.cs:208 | if (SrcRow != null) | DATA_OP | Filter["FACTORY_ID"] | SrcRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a2192f45 | this.Load | FPC0116_AlarmEditPopup.cs:209 | if (SrcRow != null) | DATA_OP | Filter["OPERATION_ID"] | SrcRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9b4f0374 | this.Load | FPC0116_AlarmEditPopup.cs:210 | if (SrcRow != null) | DATA_OP | Filter["TOP_ITEM_ID"] | SrcRow["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ee5b0efa | this.Load | FPC0116_AlarmEditPopup.cs:211 | if (SrcRow != null) | DATA_OP | Filter["PRODUCTION_TYPE"] | SrcRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-637a75ea | this.Load | FPC0116_AlarmEditPopup.cs:212 | if (SrcRow != null) | DATA_OP | Filter["MARKET"] | SrcRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-81dd2535 | this.Load | FPC0116_AlarmEditPopup.cs:213 | if (SrcRow != null) | DATA_OP | Filter["PLAN_DATE"] | Day.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-c57fc9c1 | this.Load | FPC0116_AlarmEditPopup.cs:214 | if (SrcRow != null) | DATA_OP | SrcRow.Table.Columns.Contains | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d651f70d | this.Load | FPC0116_AlarmEditPopup.cs:215 | if (SrcRow != null) ▸ if (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | SrcRow["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-07ae1a2b | this.Load | FPC0116_AlarmEditPopup.cs:217 | if (SrcRow != null) ▸ else of (SrcRow.Table.Columns.Contains("EQUIPMENT_ID")) | DATA_OP | Filter["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-fad676a3 | this.Load | FPC0116_AlarmEditPopup.cs:218 | if (SrcRow != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | SrcRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-db992bf9 | this.Load | FPC0116_AlarmEditPopup.cs:219 | if (SrcRow != null) | DATA_OP | Filter["ITEM_ID"] | SrcRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1506c8e1 | this.Load | FPC0116_AlarmEditPopup.cs:221 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_FROM"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-84d375f1 | this.Load | FPC0116_AlarmEditPopup.cs:222 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_TO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-79628a82 | this.Load | FPC0116_AlarmEditPopup.cs:224 | if (SrcRow != null) | ENDPOINT | DataService.FP_ExecuteQuery | ("PICAlarm", "find_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] \| FP\Common\PICAlar… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d8f4822c | this.Load | FPC0116_AlarmEditPopup.cs:236 | if (SrcRow != null) ▸ if (memoInfo.Good()) | VALUE_SET | txtMemo.Text | memo | 컨트롤 값 설정 |  |  |  |
| AC-7815bd9c | this.Load | FPC0116_AlarmEditPopup.cs:240 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmTime ==null) | VALUE_SET | txtAlarm.Text | "N/A" | 컨트롤 값 설정 |  |  |  |
| AC-a289d8d4 | this.Load | FPC0116_AlarmEditPopup.cs:246 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ else of (alarmTime ==null) ▸ if (alarmTime.Value.Year < 1901) | VALUE_SET | txtAlarm.Text | "N/A" | 컨트롤 값 설정 |  |  |  |
| AC-e2496fcd | this.Load | FPC0116_AlarmEditPopup.cs:251 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ else of (alarmTime ==null) ▸ else of (alarmTime.Value.Year < 1901) | VALUE_SET | txtAlarm.Text | alarmTime.Value.ToString("yyyy-MM-dd hh:mm:ss") | 컨트롤 값 설정 |  |  |  |
| AC-806f9efb | this.Load | FPC0116_AlarmEditPopup.cs:257 | if (SrcRow != null) ▸ if (memoInfo.Good()) | DATA_OP | Filter["OLD_PIC_REF"] | Filter["PIC_REF"] = memoInfo.Tables[0].Rows[0]["PIC_REF"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e28892e6 | this.Load | FPC0116_AlarmEditPopup.cs:257 | if (SrcRow != null) ▸ if (memoInfo.Good()) | DATA_OP | Filter["PIC_REF"] | memoInfo.Tables[0].Rows[0]["PIC_REF"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-283bb9ed | this.Load | FPC0116_AlarmEditPopup.cs:258 | if (SrcRow != null) ▸ if (memoInfo.Good()) | ENDPOINT | DataService.FP_ExecuteQuery | ("PICAlarm", "find_alarm", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] \| FP\Common\PICAla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5428f886 | this.Load | FPC0116_AlarmEditPopup.cs:271 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | CALL_EXT | siMain.AddRows | (row_index, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a4aba82 | this.Load | FPC0116_AlarmEditPopup.cs:277 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-37f9e809 | this.Load | FPC0116_AlarmEditPopup.cs:279 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.USER_ID), row_index, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2b364ea5 | this.Load | FPC0116_AlarmEditPopup.cs:280 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.TEAM_NAME), row_index, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-51304f90 | this.Load | FPC0116_AlarmEditPopup.cs:281 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.PHONE), row_index, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-259a8771 | this.Load | FPC0116_AlarmEditPopup.cs:285 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.USER_ID, ro["USERID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-2cdbea82 | this.Load | FPC0116_AlarmEditPopup.cs:286 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.TEAM_NAME, ro["DEPT_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb1aa444 | this.Load | FPC0116_AlarmEditPopup.cs:287 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.USER_NAME, ro["USER_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-d524512d | this.Load | FPC0116_AlarmEditPopup.cs:288 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.EMAIL, ro["EMAIL"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe2d84d5 | this.Load | FPC0116_AlarmEditPopup.cs:289 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | DATA_OP | defaultData.Add | (DefColumns.PHONE, ro["PHONE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-69e4df6f | this.Load | FPC0116_AlarmEditPopup.cs:291 | if (SrcRow != null) ▸ if (memoInfo.Good()) ▸ if (alarmInfo.Good()) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow ro in alar… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-ea9a5ed3 | this.Load | FPC0116_AlarmEditPopup.cs:303 | if (SrcRow != null) ▸ else of (memoInfo.Good()) | VALUE_CLEAR | txtMemo.Text | "" | 컨트롤 값 비움 |  |  |  |

## FPC0116_AlarmEditPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b6c92b5 | this.Load | FPC0116_AlarmEditPopup.cs:337 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-42baaf64 | this.Load | FPC0116_AlarmEditPopup.cs:339 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0116_AlarmEditPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63844dc4 | this.spdMain.CellClick | FPC0116_AlarmEditPopup.cs:498 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0116_AlarmEditPopup.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7a27989 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:616 | if (this.IsEditMode != true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-394597b7 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:618 | if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.RowsAdded) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d831747 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:631 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f7e0cd13 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:636 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (cRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42506633 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:643 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) | DATA_OP | param["USER_ID"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-7e82a8aa | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:648 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | POPUP | new FP00602_UserFindPopup | () | 팝업/폼 생성 |  |  |  |
| AC-09721d34 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:649 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | UI_PROP | UserPopup._UserId | user_id | 속성 _UserId 설정 |  |  |  |
| AC-e101f3ba | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:651 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | UI_PROP | UserPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-72c97299 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:652 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | UI_PROP | UserPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-85f40f26 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:655 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) | POPUP | UserPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-660da2f0 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:664 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 3].Value | user_name | 그리드 속성/값 설정 |  |  |  |
| AC-fecefe1d | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:665 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 2].Value | dept_name | 그리드 속성/값 설정 |  |  |  |
| AC-96927ea1 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:666 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | DATA_OP | dept_name.ToUpper().Contains | ("LG CNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f2f460b | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:666 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | DATA_OP | dept_name.ToUpper().Contains | ("LGCNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-cff55682 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:667 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) | DATA_OP | dept_name.ToUpper().Contains | ("DEV") | 데이터 객체 조작/조회 |  |  |  |
| AC-94b3fdfa | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:669 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) ▸ i… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgespartner.com" | 그리드 속성/값 설정 |  |  |  |
| AC-e3f95364 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:673 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ if (UserPopup.ShowDialog() == DialogResult.OK) ▸ e… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgensol.com" | 그리드 속성/값 설정 |  |  |  |
| AC-c4367f9d | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:679 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ if (useDialog) ▸ else of (UserPopup.ShowDialog() == DialogResult.OK… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04b8a959 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:687 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "get_userinfo", param.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_userinfo] \| FP\Common\PICA… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-890303e5 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:691 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ catch () | MESSAGE | MessageBox.Show | ("Cannot find user") | 메시지 표시 |  |  |  |
| AC-61ceb32a | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:692 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f20e0c85 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:701 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 3].Value | user_name = dsUser.Rows[0]["UserName"].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-b6bd1bed | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:702 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 2].Value | dept_name = dsUser.Rows[0]["Dept_Name"].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-14dac34d | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:703 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) | DATA_OP | dept_name.ToUpper().Contains | ("LG CNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f3f4352 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:703 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) | DATA_OP | dept_name.ToUpper().Contains | ("LGCNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c98d9ed | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:705 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) ▸ if (dept_name.ToUpper().… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgespartner.com" | 그리드 속성/값 설정 |  |  |  |
| AC-43f049a7 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:709 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ if (dsUser.Good()) ▸ else of (dept_name.ToUpp… | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | user_id + @"@lgensol.com" | 그리드 속성/값 설정 |  |  |  |
| AC-bd15ae30 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:717 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 1].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-51b19a00 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:718 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 2].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-0fb9d14a | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:719 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 3].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-10bb4f3e | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:720 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 4].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-f9eeaa30 | dsdmMain.Changed | FPC0116_AlarmEditPopup.cs:721 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (nCol == 1) ▸ else of (useDialog) ▸ else of (dsUser.Good()) | GRID_SET | siMain.ActiveSheet.Cells[nRow, 5].Value | "" | 그리드 속성/값 설정 |  |  |  |

## FPC0116_AlarmEditPopup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d55ce56e | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:828 |  | POPUP | new FPC0112_AlarmPopup | () | 팝업/폼 생성 |  |  |  |
| AC-314f6c3d | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:829 |  | UI_PROP | memoPopup.IsRef | true | 속성 IsRef 설정 |  |  |  |
| AC-5ca78c4c | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:830 |  | UI_PROP | memoPopup.CanSave | false | 속성 CanSave 설정 |  |  |  |
| AC-7236e8a0 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:831 |  | VALUE_SET | memoPopup.Text | "Alarm / Memo" | 컨트롤 값 설정 |  |  |  |
| AC-d1a3cf04 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:832 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1e3c2ce0 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:832 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-170a930d | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:833 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | DateTime.Now.AddDays(-8).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-784e9eed | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:834 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | DateTime.Now.AddDays(8).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-ed7faa94 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:837 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3814fec8 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:839 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-eea745cf | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:840 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d439f967 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:841 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0d7c09fc | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:842 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4af58f2e | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:843 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8f583bfd | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:844 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c48d8251 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:846 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cb88e7ad | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:847 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-809eccc1 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:848 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-1bd3c7a1 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:849 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5fef6ad2 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:863 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) | DATA_OP | Filter["PIC_REF"] | pic_ref | 행/컬럼 값 대입 |  |  |  |
| AC-4cb53e38 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:864 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) | ENDPOINT | DataService.FP_ExecuteQuery | ("PICAlarm", "find_alarm", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_alarm] \| FP\Common\PICAla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-62b8af29 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:874 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | userids.Contains | (auser) | 데이터 객체 조작/조회 |  |  |  |
| AC-e56678c2 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:876 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | userids.Add | (auser) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6a73f93 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:877 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | username.Add | (aname) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d113cac | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:878 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | team.Add | (ateam) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c316ffa | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:879 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | mail.Add | (amail) | 데이터 객체 조작/조회 |  |  |  |
| AC-792bdc11 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:880 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ for (i < selected.Count) ▸ if (alarmInfo.Good… | DATA_OP | phone.Add | (aphone) | 데이터 객체 조작/조회 |  |  |  |
| AC-c99976f1 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:920 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | CALL_EXT | siMain.AddRows | (row_index, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-09d2d845 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:929 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.USER_ID, userid) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4124d24 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:930 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.TEAM_NAME, adeptname) | 데이터 객체 조작/조회 |  |  |  |
| AC-df53f40e | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:932 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.USER_NAME, ausername) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f477f04 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:933 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.EMAIL, email) | 데이터 객체 조작/조회 |  |  |  |
| AC-671d5657 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:934 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | DATA_OP | defaultData.Add | (DefColumns.PHONE, aphone) | 데이터 객체 조작/조회 |  |  |  |
| AC-be57624a | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:936 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-188fd120 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:938 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e8bacfb1 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:940 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.USER_ID), row_index, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-991edac0 | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:941 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.TEAM_NAME), row_index, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f5ca78dc | this.usrButton2.Click | FPC0116_AlarmEditPopup.cs:942 | if (memoPopup.ShowDialog() == DialogResult.OK) ▸ if (selected != null && selected.Count > 0) ▸ if (userids.Count > 0) ▸ for (i < userids.Cou… | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.PHONE), row_index, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |

## FPC0116_AlarmEditPopup.usrButton3_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-059fa9a6 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:740 | try | DATA_OP | Filter["BUCKET_FROM"] | Filter["BUCKET_TO"] = dpPlanDate.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c35a8edd | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:740 | try | DATA_OP | Filter["BUCKET_TO"] | dpPlanDate.Text | 행/컬럼 값 대입 |  |  |  |
| AC-f6ffa87a | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:742 | try | DATA_OP | Filter["MEMO"] | txtMemo.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b7014aa7 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:743 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0c7fcbdc | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:745 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("PICAlarm", "max_pic_ref", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=max_pic_ref] \| FP\Common\PICAl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d5da10cb | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:748 | try ▸ if (max_pic_ref.Good()) | DATA_OP | Filter["PIC_REF"] | max_pic_ref.Tables[0].Rows[0]["PIC_REF"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-05454dc2 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:751 | try | UI_PROP | alarm.TableName | "AlarmData" | 속성 TableName 설정 |  |  |  |
| AC-ac293016 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:752 | try | DATA_OP | alarm.Columns.SafeAdd | ("P_USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c196aee | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:753 | try | DATA_OP | alarm.Columns.SafeAdd | ("PIC_REF", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-14abe428 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:754 | try | DATA_OP | alarm.Columns.SafeAdd | ("EMAIL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-31dabf1b | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:755 | try | DATA_OP | alarm.Columns.SafeAdd | ("PHONE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-94287bdb | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:756 | try | DATA_OP | alarm.Columns.SafeAdd | ("DEPT_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4151690 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:757 | try | DATA_OP | alarm.Columns.SafeAdd | ("USER_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4e934e0 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:758 | try | DATA_OP | alarm.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ac95164 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:767 | try ▸ for (i<len) ▸ if (string.IsNullOrWhiteSpace(picuser)) | MESSAGE | MessageBox.Show | ("Need to specify PIC user id") | 메시지 표시 |  |  |  |
| AC-1fbeb3be | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:768 | try ▸ for (i<len) ▸ if (string.IsNullOrWhiteSpace(picuser)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8aa82391 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:774 | try ▸ for (i<len) | DATA_OP | alarm.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7a4b4f79 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:775 | try ▸ for (i<len) | DATA_OP | insRow["PIC_REF"] | Filter["PIC_REF"] | 행/컬럼 값 대입 |  |  |  |
| AC-ed4b40fa | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:776 | try ▸ for (i<len) | DATA_OP | insRow["P_USER_ID"] | picuser | 행/컬럼 값 대입 |  |  |  |
| AC-a51a2e3a | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:777 | try ▸ for (i<len) | DATA_OP | insRow["USER_NAME"] | siMain.ActiveSheet.Cells[i, 3].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0f41f69a | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:778 | try ▸ for (i<len) | DATA_OP | insRow["DEPT_NAME"] | siMain.ActiveSheet.Cells[i, 2].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dd746cdf | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:779 | try ▸ for (i<len) | DATA_OP | insRow["EMAIL"] | siMain.ActiveSheet.Cells[i, 4].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-efffcb7c | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:780 | try ▸ for (i<len) | DATA_OP | insRow["PHONE"] | phone | 행/컬럼 값 대입 |  |  |  |
| AC-25114763 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:781 | try ▸ for (i<len) | DATA_OP | insRow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a891683d | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:783 | try ▸ for (i<len) | DATA_OP | alarm.Rows.Add | (insRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-095c0497 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:788 | try | ENDPOINT | DataService.FP_PseudoBatch2 | ("PICAlarm", "save_alarm", alarm) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_alarm] \| FP\Common\PICAlar… | 엔드포인트 호출 |  |  |  |
| AC-26ecae51 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:789 | try | CALL_EXT | DataService.ReadResult | (res) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2038b44 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:792 | try ▸ if (result.Success) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("PICAlarm", "save_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] \| FP\Common\PICA… | 엔드포인트 호출 |  |  |  |
| AC-fcb2973f | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:794 | try ▸ if (result.Success) | MESSAGE | MessageBox.Show | ("Save alarm success") | 메시지 표시 |  |  |  |
| AC-762b504e | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:795 | try ▸ if (result.Success) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-b4a18f19 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:796 | try ▸ if (result.Success) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-608ddf8e | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:800 | try ▸ else of (result.Success) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("PICAlarm", "save_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] \| FP\Common\PICA… | 엔드포인트 호출 |  |  |  |
| AC-647c3e3e | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:802 | try ▸ else of (result.Success) | MESSAGE | MessageBox.Show | ("Save as memo") | 메시지 표시 |  |  |  |
| AC-90674bd0 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:803 | try ▸ else of (result.Success) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-8683cf07 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:804 | try ▸ else of (result.Success) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-8041d067 | this.btnSave.Click | FPC0116_AlarmEditPopup.cs:809 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Save Error: " + xe.Message) | 메시지 표시 |  |  |  |

## FPC0116_AlarmEditPopup.usrButton4_Click

진입점: this.usrButton4.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ec6ee81 | this.usrButton4.Click | FPC0116_AlarmEditPopup.cs:822 | if (rowindex >= 0) | CALL_EXT | siMain.ActiveSheet.RemoveRows | (rowindex, 1) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0116_AlarmEditPopup.usrButton5_Click

진입점: this.usrButton5.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2382727 | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:551 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | new FP00602_UserFindPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4b927fc3 | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:553 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | UserPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-07f82c0c | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:554 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | UserPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-347b3ebb | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:558 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | UserPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d6607575 | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:567 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (UserPopup.ShowDialog(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3cde82d1 | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:574 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.AddRows | (row_index, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ac4d6d0 | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:583 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.USER_ID, user_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-3afccd6c | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:584 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.TEAM_NAME, team_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-193e6ced | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:586 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | team_name.ToUpper().Contains | ("LG CNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba5b16e2 | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:586 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | team_name.ToUpper().Contains | ("LGCNS") | 데이터 객체 조작/조회 |  |  |  |
| AC-f9f60127 | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:592 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.USER_NAME, user_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6dc44c1 | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:593 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.EMAIL, email) | 데이터 객체 조작/조회 |  |  |  |
| AC-33a4ffae | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:594 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.PHONE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-da163dfb | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:596 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-75f0e5a5 | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:598 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fa78665c | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:600 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.USER_ID), row_index, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-83934418 | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:601 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.TEAM_NAME), row_index, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fe7e5d4b | this.usrButton5.Click | FPC0116_AlarmEditPopup.cs:602 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (row_index, siMain.GetColumnIndex(DefColumns.PHONE), row_index, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |


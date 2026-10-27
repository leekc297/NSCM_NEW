# AS-IS 액션 대조표 — FP01886

> 원천: `Doc/asisfacts/screens/FP01886/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 857행 · 메서드 89 · 종류 DATA_OP 161 · FLAG 107 · RETURN 101 · UI_PROP 78 · GRID_SET 66 · MESSAGE 63 · GRID_INIT 38 · COMBO_DATA 31 · LIST_REBIND 27 · ENDPOINT 26 · VALUE_SET 26 · UI_MISC 20 · THROW 18 · GRID_STYLE 18 · CALL_EXT 15 · GRID_LOCK 15 · POPUP 14 · VALIDATE 11 · GRID_BIND 7 · STATE 6 · CALL_BASE 5 · EXCEL 2 · FOCUS 2 · ⚠ 의미 확인 필요 20


## FP01886_Authority_Request..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41409828 | .ctor | FP01886_Authority_Request.cs:143 |  | FLAG | this._sAuthority | pAuthority | 화면 필드/플래그 변경 |  |  |  |
| AC-72cad240 | .ctor | FP01886_Authority_Request.cs:144 |  | FLAG | this._sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |

## FP01886_Authority_Request.AddBlankRow

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63ce7d9c | this.Load | FP01886_Authority_Request.cs:506 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c037a61a | this.Load | FP01886_Authority_Request.cs:507 |  | DATA_OP | dr[0] | " " | 행/컬럼 값 대입 |  |  |  |
| AC-0a373a5d | this.Load | FP01886_Authority_Request.cs:508 |  | DATA_OP | dr[1] | " " | 행/컬럼 값 대입 |  |  |  |
| AC-5dbeff01 | this.Load | FP01886_Authority_Request.cs:509 |  | CALL_EXT | dt.Rows.InsertAt | (dr, 0) | ⚠ 의미 확인 필요 |  |  |  |

## FP01886_Authority_Request.ApplyPseudoDivision

진입점: this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResult.OK)] / this.Load [try] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05fc9bfa | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1130 | if (dtPeusdoInfo.Good()) | DATA_OP | dtDivision.Columns.SafeAdd | ("MM", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7895ba9a | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1139 | if (dtPeusdoInfo.Good()) ▸ for (i < dcnt) ▸ for (j < cnt) ▸ if (divRow["CODE"].ToString().ToLower() == pRow["DIVISION_ID"].ToString().ToLowe… | DATA_OP | divRow["MM"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-b53e3ebd | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1149 | if (dtPeusdoInfo.Good()) ▸ for (i < dcnt) ▸ if (divRow["MM"].ToString() != "Y") | DATA_OP | dtDivision.Rows.Remove | (divRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb7b60cc | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1150 | if (dtPeusdoInfo.Good()) ▸ for (i < dcnt) ▸ if (divRow["MM"].ToString() != "Y") | DATA_OP | dtDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## FP01886_Authority_Request.ApplyPseudoInstance

진입점: this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResult.OK) ▸ try] / this.Load [try ▸ try] / clbShopGroup.SelectedIndexChanged [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-039aeb3a | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1091 | if (dtPeusdoInfo.Good() && dtInstance.Good()) | DATA_OP | Filter["COMPANY_LT"] | companys | 행/컬럼 값 대입 |  |  |  |
| AC-d353a5d9 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1092 | if (dtPeusdoInfo.Good() && dtInstance.Good()) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01886_Authority_Request", "get_company_instance", Filter.Dictionary, "Admin") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_company_instance] \| FP\Adm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d3bf8fdc | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1096 | if (dtPeusdoInfo.Good() && dtInstance.Good()) | DATA_OP | dtInstance.Columns.SafeAdd | ("MM", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-060841b8 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1105 | if (dtPeusdoInfo.Good() && dtInstance.Good()) ▸ for (i < dcnt) ▸ for (j < cnt) ▸ if (divRow["CODE"].ToString().ToLower() == pRow["INSTANCE_I… | DATA_OP | divRow["MM"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-082fb00b | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1115 | if (dtPeusdoInfo.Good() && dtInstance.Good()) ▸ for (i < dcnt) ▸ if (divRow["MM"].ToString() != "Y") | DATA_OP | dtInstance.Rows.Remove | (divRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d529c74 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1116 | if (dtPeusdoInfo.Good() && dtInstance.Good()) ▸ for (i < dcnt) ▸ if (divRow["MM"].ToString() != "Y") | DATA_OP | dtInstance.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## FP01886_Authority_Request.btnClose_Click

진입점: this.btnClose.Click / this.layoutControlItem11.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1343acc | this.btnClose.Click 외 1 | FP01886_Authority_Request.cs:1733 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01886_Authority_Request.btnRequest_Click

진입점: this.btnRequest.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21c439e4 | this.btnRequest.Click | FP01886_Authority_Request.cs:797 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-8750f807 | this.btnRequest.Click | FP01886_Authority_Request.cs:797 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42f1a655 | this.btnRequest.Click | FP01886_Authority_Request.cs:841 | if (defaultRole.ToUpper() != "GUEST" && defaultRole != "") | ENDPOINT | new TheOne.ServiceModel.Biz.FoxBizRequest | ("Authentication", "SavePersonalSetting") ⇒ biz:Authentication.SavePersonalSetting | 엔드포인트 요청 생성 |  |  |  |
| AC-5dfa5ab9 | this.btnRequest.Click | FP01886_Authority_Request.cs:843 | if (defaultRole.ToUpper() != "GUEST" && defaultRole != "") | DATA_OP | request.Parameters["id"] | userID | 행/컬럼 값 대입 |  |  |  |
| AC-eb3bdf8f | this.btnRequest.Click | FP01886_Authority_Request.cs:844 | if (defaultRole.ToUpper() != "GUEST" && defaultRole != "") | DATA_OP | request.Parameters["language"] | language | 행/컬럼 값 대입 |  |  |  |
| AC-6502353e | this.btnRequest.Click | FP01886_Authority_Request.cs:845 | if (defaultRole.ToUpper() != "GUEST" && defaultRole != "") | DATA_OP | request.Parameters["defaultGroupID"] | defaultRole | 행/컬럼 값 대입 |  |  |  |
| AC-80ed13b0 | this.btnRequest.Click | FP01886_Authority_Request.cs:846 | if (defaultRole.ToUpper() != "GUEST" && defaultRole != "") | DATA_OP | request.Parameters["timeZone"] | timeZone | 행/컬럼 값 대입 |  |  |  |
| AC-a989f03e | this.btnRequest.Click | FP01886_Authority_Request.cs:848 | if (defaultRole.ToUpper() != "GUEST" && defaultRole != "") | ENDPOINT | client.Execute | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-432144da | this.btnRequest.Click | FP01886_Authority_Request.cs:891 | try ▸ if (iChkCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9889896 | this.btnRequest.Click | FP01886_Authority_Request.cs:892 | try ▸ if (iChkCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93fa1e0b | this.btnRequest.Click | FP01886_Authority_Request.cs:898 | try ▸ if (bCurrAuth) | MESSAGE | MessageBox.Show | ("Planner권한이 이미 있습니다.\r\nVIewer권한 승인 시 Planner 권한은 사라지고 VIewer 권한만 남게 됩니다.\r\n그래도 요청하시겠습니까… | 메시지 표시 |  |  |  |
| AC-9c9a6f79 | this.btnRequest.Click | FP01886_Authority_Request.cs:900 | try ▸ if (bCurrAuth) ▸ if (MessageBox.Show("Planner권한이 이미 있습니다.\r\nVIewer권한 승인 시 Planner 권한은 사라지고 VIewer 권한만 남게 됩니다.\r\n그래도 요청하시겠습니까?", "Con… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b654eb5 | this.btnRequest.Click | FP01886_Authority_Request.cs:904 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_is_exists_request", sUserID, sList) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a36662a7 | this.btnRequest.Click | FP01886_Authority_Request.cs:909 | try ▸ if (dtExist.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fecf8eb1 | this.btnRequest.Click | FP01886_Authority_Request.cs:910 | try ▸ if (dtExist.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25495d94 | this.btnRequest.Click | FP01886_Authority_Request.cs:913 | try | MESSAGE | MessageBox.Show | ("Do you want to request authority?", "Request", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-7a3db54a | this.btnRequest.Click | FP01886_Authority_Request.cs:921 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | ("btnRequest_Click:" + ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-0117b15e | this.btnRequest.Click | FP01886_Authority_Request.cs:922 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_Authority_Request.btnSelect_Click

진입점: this.btnSelect.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ea5826d | this.btnSelect.Click | FP01886_Authority_Request.cs:789 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | ("btnSelect_Click:" + ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-efd67fdc | this.btnSelect.Click | FP01886_Authority_Request.cs:790 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_Authority_Request.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-218e0523 | this.btnSql.Click | FP01886_Authority_Request.cs:937 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-507b702b | this.btnSql.Click | FP01886_Authority_Request.cs:938 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ab3723ad | this.btnSql.Click | FP01886_Authority_Request.cs:940 |  | DATA_OP | popSql.Services.Add | ("SELECT_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-a34f964d | this.btnSql.Click | FP01886_Authority_Request.cs:941 |  | DATA_OP | popSql.Services.Add | ("SELECT_REQUEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd58e8b1 | this.btnSql.Click | FP01886_Authority_Request.cs:942 |  | DATA_OP | popSql.Services.Add | ("SAVE_REQUEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-912ab5e3 | this.btnSql.Click | FP01886_Authority_Request.cs:943 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01886_Authority_Request.btnUser_Click

진입점: this.btnUser.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68536f6f | this.btnUser.Click | FP01886_Authority_Request.cs:752 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-72f3885e | this.btnUser.Click | FP01886_Authority_Request.cs:755 |  | POPUP | new FP01886_UserFindPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a466bc54 | this.btnUser.Click | FP01886_Authority_Request.cs:757 |  | UI_PROP | UserPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-9bdcb602 | this.btnUser.Click | FP01886_Authority_Request.cs:758 |  | UI_PROP | UserPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-cdbcc340 | this.btnUser.Click | FP01886_Authority_Request.cs:759 |  | POPUP | UserPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-880ca6f2 | this.btnUser.Click | FP01886_Authority_Request.cs:762 | if (UserPopup.ShowDialog() == DialogResult.OK) | VALUE_SET | txtUserID.Text | UserPopup._UserId | 컨트롤 값 설정 |  |  |  |
| AC-de0f71bf | this.btnUser.Click | FP01886_Authority_Request.cs:763 | if (UserPopup.ShowDialog() == DialogResult.OK) | VALUE_SET | txtUserName.Text | UserPopup._UserName | 컨트롤 값 설정 |  |  |  |
| AC-960dc5e0 | this.btnUser.Click | FP01886_Authority_Request.cs:764 | if (UserPopup.ShowDialog() == DialogResult.OK) | VALUE_SET | txtDepartment.Text | UserPopup._Department | 컨트롤 값 설정 |  |  |  |

## FP01886_Authority_Request.CheckValidationControl

진입점: this.btnSelect.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64da69c7 | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1242 | try ▸ if (string.IsNullOrEmpty(pMenuAuthorityID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8bb9c867 | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1243 | try ▸ if (string.IsNullOrEmpty(pMenuAuthorityID)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-68cbe4fc | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1249 | try ▸ if (string.IsNullOrEmpty(pDivision) \|\| pDivision.Equals("ALL")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9815542e | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1250 | try ▸ if (string.IsNullOrEmpty(pDivision) \|\| pDivision.Equals("ALL")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-12899acb | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1255 | try ▸ if (string.IsNullOrEmpty(pPlant) \|\| pPlant.Equals("ALL")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e6d9248 | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1256 | try ▸ if (string.IsNullOrEmpty(pPlant) \|\| pPlant.Equals("ALL")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b60221f3 | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1261 | try ▸ if (string.IsNullOrEmpty(pShopGroup) \|\| pShopGroup.Equals("ALL")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c1d36a6d | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1262 | try ▸ if (string.IsNullOrEmpty(pShopGroup) \|\| pShopGroup.Equals("ALL")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-56d42e59 | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1269 | try ▸ if (string.IsNullOrEmpty(pInstance) \|\| pInstance.Equals("ALL")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a6cee2bb | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1270 | try ▸ if (string.IsNullOrEmpty(pInstance) \|\| pInstance.Equals("ALL")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2528fcf3 | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1275 | try ▸ if (string.IsNullOrEmpty(pFactory) \|\| pFactory.Equals("ALL")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-942140ee | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1276 | try ▸ if (string.IsNullOrEmpty(pFactory) \|\| pFactory.Equals("ALL")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-927f3920 | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1281 | try ▸ if (string.IsNullOrEmpty(pPlanGroup) \|\| pPlanGroup.Equals("ALL")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-746d5ac7 | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1282 | try ▸ if (string.IsNullOrEmpty(pPlanGroup) \|\| pPlanGroup.Equals("ALL")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5357d473 | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1285 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-9f117008 | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1289 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | ("CheckValidationControl:" + ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-d1f650ac | this.btnSelect.Click [try] | FP01886_Authority_Request.cs:1290 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01886_Authority_Request.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a25543c | clbDivision.SelectedIndexChanged | FP01886_Authority_Request.cs:1751 | try | FLAG | dtPlant | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_plant", sDivision) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-305c9b4c | clbDivision.SelectedIndexChanged | FP01886_Authority_Request.cs:1751 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_plant", sDivision) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b1d3be93 | clbDivision.SelectedIndexChanged | FP01886_Authority_Request.cs:1752 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-ff6e51c6 | clbDivision.SelectedIndexChanged | FP01886_Authority_Request.cs:1758 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_Authority_Request.ClbFactory_SelectedIndexChanged

진입점: clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-506bf211 | clbFactory.SelectedIndexChanged | FP01886_Authority_Request.cs:1868 | try | FLAG | dtPlanGroup | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_plangroup", sInstance… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-46678a71 | clbFactory.SelectedIndexChanged | FP01886_Authority_Request.cs:1868 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_plangroup", sInstance, sFactory) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40300c15 | clbFactory.SelectedIndexChanged | FP01886_Authority_Request.cs:1869 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-49f815d3 | clbFactory.SelectedIndexChanged | FP01886_Authority_Request.cs:1874 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_Authority_Request.ClbInstance_SelectedIndexChanged

진입점: clbInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95a4cba5 | clbInstance.SelectedIndexChanged | FP01886_Authority_Request.cs:1842 | try | FLAG | dtFactory | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_factory", sDivision, … ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-ec808442 | clbInstance.SelectedIndexChanged | FP01886_Authority_Request.cs:1842 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_factory", sDivision, sPlant, sShopGroup, sInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d3a20862 | clbInstance.SelectedIndexChanged | FP01886_Authority_Request.cs:1843 | try | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-b590b220 | clbInstance.SelectedIndexChanged | FP01886_Authority_Request.cs:1848 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_Authority_Request.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fc217cc | clbPlant.SelectedIndexChanged | FP01886_Authority_Request.cs:1779 | try | FLAG | dtShopGroup | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_shop", sDivision, sPl… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-8aeb2796 | clbPlant.SelectedIndexChanged | FP01886_Authority_Request.cs:1779 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_shop", sDivision, sPlant) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eab155bb | clbPlant.SelectedIndexChanged | FP01886_Authority_Request.cs:1780 | try | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, clbShopGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-cd895dcc | clbPlant.SelectedIndexChanged | FP01886_Authority_Request.cs:1786 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_Authority_Request.ClbShopGroup_SelectedIndexChanged

진입점: clbShopGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d01c843 | clbShopGroup.SelectedIndexChanged | FP01886_Authority_Request.cs:1810 | try | FLAG | dtInstance | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_instance", sDivision,… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-ea196986 | clbShopGroup.SelectedIndexChanged | FP01886_Authority_Request.cs:1810 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_instance", sDivision, sPlant, sShopGroup) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-425cc15a | clbShopGroup.SelectedIndexChanged | FP01886_Authority_Request.cs:1812 | try | LIST_REBIND | clsCtrl.setListBox | (dtInstance, clbInstance, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-7b0dc5ca | clbShopGroup.SelectedIndexChanged | FP01886_Authority_Request.cs:1818 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_Authority_Request.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e05f2a3 | this.Load | FP01886_Authority_Request.cs:565 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fe4af511 | this.Load | FP01886_Authority_Request.cs:566 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bca0bb94 | this.Load | FP01886_Authority_Request.cs:569 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-72aa661d | this.Load | FP01886_Authority_Request.cs:570 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-747fc7d7 | this.Load | FP01886_Authority_Request.cs:573 |  | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-130d5f42 | this.Load | FP01886_Authority_Request.cs:577 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01886_Authority_Request.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-533902b8 | this.Load | FP01886_Authority_Request.cs:262 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-0ccc9110 | this.Load | FP01886_Authority_Request.cs:264 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-79c3f523 | this.Load | FP01886_Authority_Request.cs:265 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-d3faaba2 | this.Load | FP01886_Authority_Request.cs:266 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP01886_Authority_Request.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-daa4a3f3 | DeleteButton | FP01886_Authority_Request.cs:734 |  | MESSAGE | MessageBox.Show | ("Delete Button can't use.!") | 메시지 표시 |  |  |  |
| AC-110153f0 | DeleteButton | FP01886_Authority_Request.cs:735 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01886_Authority_Request.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7e05dbe | Dispose | FP01886_Authority_Request.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01886_Authority_Request.DsdmSub_Changed

진입점: dsdmSub.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef068492 | dsdmSub.Changed | FP01886_Authority_Request.cs:1384 | if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af047281 | dsdmSub.Changed | FP01886_Authority_Request.cs:1386 | if ((siSub.ActiveSheet.Rows.Count <= 0) \|\| siSub.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a36ab604 | dsdmSub.Changed | FP01886_Authority_Request.cs:1395 | if (e.Column == siSub.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID)) ▸ if (sData.Equals("PLANNER")) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.RELEASE_NOTIFIY_TYPE), "MAIL") | 그리드 값 설정 |  |  |  |
| AC-a6994160 | dsdmSub.Changed | FP01886_Authority_Request.cs:1399 | if (e.Column == siSub.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID)) ▸ else of (sData.Equals("PLANNER")) ▸ if (sData.Equals("VIEWER")) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.RELEASE_NOTIFIY_TYPE), "NONE") | 그리드 값 설정 |  |  |  |

## FP01886_Authority_Request.EditButton

진입점: this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you want to request authority?", "Request", MessageBoxButtons.OK) == DialogResult.OK) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds != null)] / this.btnSelect.Click [try ▸ if (bChk) ▸ try ▸ if (ds != null)] / EditButton / SaveButton [if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d66a7e45 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:663 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-c3c9189b | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:666 | try ▸ if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a341d065 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:677 | try ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() >= 0) | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-fd930719 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:678 | try ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() >= 0) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.NEW_USER_ID), siSub.GetColumnIndex(DefColumns.REQUEST_ID)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4d93ed70 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:679 | try ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() >= 0) | GRID_LOCK | siSub.LockRange2 | (0, siSub.GetColumnIndex(DefColumns.CHK), siSub.ActiveSheet.RowCount - 1, siSub.GetColumnI… | 그리드 편집 잠금 전환 |  |  |  |
| AC-9f065674 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:685 | try ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() >= 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (i % 2 == 1) | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID), i, siSub.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-3e9e3d08 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:686 | try ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() >= 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (i % 2 == 1) | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.RELEASE_NOTIFIY_TYPE), i, siSub.GetColumnIndex(DefColu… | 그리드 표시 설정 |  |  |  |
| AC-aab71c10 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:690 | try ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() >= 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (i % 2 == 1) | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID), i, siSub.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-7a1e7e1b | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:691 | try ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() >= 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (i % 2 == 1) | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.RELEASE_NOTIFIY_TYPE), i, siSub.GetColumnIndex(DefColu… | 그리드 표시 설정 |  |  |  |
| AC-2ac23c3c | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:703 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | ("EditButton:" + ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-63e7f25b | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:704 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_Authority_Request.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd4b7da4 | ExcelButton | FP01886_Authority_Request.cs:968 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP01886_Authority_Request.Find_Data_Main

진입점: this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResult.OK) ▸ try ▸ lambda] / this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "SELECT_MAIN")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3223922 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1162 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pUserID = txtUserID.Text.ToString(); //USER… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4257221b | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1174 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST") ⇒ FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-c93b5938 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1175 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-78de4d60 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1176 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-b65a3610 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1177 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c6747e29 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1178 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5823b82a | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1179 | try | DATA_OP | request.Parameters["p_alt_user_id"] | pUserID | 행/컬럼 값 대입 |  |  |  |
| AC-65c3acc1 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1180 | try | DATA_OP | request.Parameters["p_alt_user_name"] | pUserName | 행/컬럼 값 대입 |  |  |  |
| AC-93a71146 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1181 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0af7d506 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1182 | try | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f2f88aa8 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1183 | try | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f016dc40 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1184 | try | DATA_OP | request.Parameters["p_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e29aa9f3 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1185 | try | DATA_OP | request.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c42b209d | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1186 | try | DATA_OP | request.Parameters["p_instance_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-df574950 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1187 | try | DATA_OP | request.Parameters["p_shop_group"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-799de054 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1188 | try | DATA_OP | request.Parameters["p_plan_group"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-00ef2bcf | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1189 | try | DATA_OP | request.Parameters["p_menu_authority_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d41d6856 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1190 | try | DATA_OP | request.Parameters["p_request_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-461df74f | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1191 | try | DATA_OP | request.Parameters["p_release_notifiy"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8cfad8b0 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1192 | try | DATA_OP | request.Parameters["p_new_seq"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d5c112d6 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1194 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-adac7640 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1196 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-42e89bba | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 3 | FP01886_Authority_Request.cs:1201 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01886_Authority_Request.Find_Data_Request

진입점: this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you want to request authority?", "Request", MessageBoxButtons.OK) == DialogResult.OK) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnSelect.Click [try ▸ if (bChk) ▸ try] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_REQUEST")] / SaveButton [if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72282745 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1418 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pUserID = txtUserID.Text.ToString(); //USER… | ⚠ 의미 확인 필요 |  |  |  |
| AC-fcef617e | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1439 | if (string.IsNullOrEmpty(pUserID.ToString())) | MESSAGE | MessageBox.Show | ("Select [User ID]") | 메시지 표시 |  |  |  |
| AC-8a6efaee | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1440 | if (string.IsNullOrEmpty(pUserID.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-638356f7 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1445 | if (string.IsNullOrEmpty(pDivision.ToString())) | MESSAGE | MessageBox.Show | ("Select [Division]!") | 메시지 표시 |  |  |  |
| AC-6bbda0c5 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1446 | if (string.IsNullOrEmpty(pDivision.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-00af881c | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1450 | if (string.IsNullOrEmpty(pPlant.ToString())) | MESSAGE | MessageBox.Show | ("Select [Plant]!") | 메시지 표시 |  |  |  |
| AC-43eccff8 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1451 | if (string.IsNullOrEmpty(pPlant.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8e85174e | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1455 | if (string.IsNullOrEmpty(pShopGroup.ToString())) | MESSAGE | MessageBox.Show | ("Select [Shop Group]!") | 메시지 표시 |  |  |  |
| AC-fb32d720 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1456 | if (string.IsNullOrEmpty(pShopGroup.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ff9a4681 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1463 | if (string.IsNullOrEmpty(pInstance.ToString())) | MESSAGE | MessageBox.Show | ("Select [Instance]!") | 메시지 표시 |  |  |  |
| AC-f377bb1e | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1464 | if (string.IsNullOrEmpty(pInstance.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-26884aa3 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1468 | if (string.IsNullOrEmpty(pFactory.ToString())) | MESSAGE | MessageBox.Show | ("Select [Factory]!") | 메시지 표시 |  |  |  |
| AC-693175fd | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1469 | if (string.IsNullOrEmpty(pFactory.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-99f72e61 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1473 | if (string.IsNullOrEmpty(pPlanGroup.ToString())) | MESSAGE | MessageBox.Show | ("Select [Plan Group]!") | 메시지 표시 |  |  |  |
| AC-d6bbab4b | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1474 | if (string.IsNullOrEmpty(pPlanGroup.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-18ff1adf | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1481 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST") ⇒ FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-2cfcf6de | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1483 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-81a079c2 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1484 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_SUB" | 행/컬럼 값 대입 |  |  |  |
| AC-8dfc82f6 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1485 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-56979c64 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1486 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2ca6240d | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1487 | try | DATA_OP | request.Parameters["p_alt_user_id"] | pUserID | 행/컬럼 값 대입 |  |  |  |
| AC-5a6c02bf | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1488 | try | DATA_OP | request.Parameters["p_alt_user_name"] | pUserName | 행/컬럼 값 대입 |  |  |  |
| AC-3f6baaec | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1489 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7deb8f04 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1490 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8acb5a75 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1491 | try | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8cbcf8ad | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1492 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlant | 행/컬럼 값 대입 |  |  |  |
| AC-8adb95ea | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1493 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactory | 행/컬럼 값 대입 |  |  |  |
| AC-2508e6fc | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1494 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstance | 행/컬럼 값 대입 |  |  |  |
| AC-8c20876d | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1495 | try | DATA_OP | request.Parameters["p_shop_group"] | pShopGroup | 행/컬럼 값 대입 |  |  |  |
| AC-826fa09e | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1496 | try | DATA_OP | request.Parameters["p_plan_group"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-bce1840a | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1497 | try | DATA_OP | request.Parameters["p_menu_authority_id"] | pMenuAuthorityID | 행/컬럼 값 대입 |  |  |  |
| AC-49bc2156 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1498 | try | DATA_OP | request.Parameters["p_request_id"] | pRequestID | 행/컬럼 값 대입 |  |  |  |
| AC-f28cb1c9 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1499 | try | DATA_OP | request.Parameters["p_release_notifiy"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b2f5f57d | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1500 | try | DATA_OP | request.Parameters["p_new_seq"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a5052982 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1502 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1952ef33 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1504 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-64698c1b | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1509 | catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Find_Data_Request:" + e.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-4cf4da63 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 3 | FP01886_Authority_Request.cs:1510 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01886_Authority_Request.Find_Main

진입점: this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResult.OK)] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2698c290 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:977 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8c858672 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:981 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d5ab4d7f | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:984 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-4ea180ac | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:984 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e632f0f | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:990 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2b6d8b49 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:993 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da195904 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:999 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-30d10614 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1000 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Main("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3e36bf05 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1011 | try ▸ if (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-19283b71 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1013 | try ▸ if (ds != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d3f0f90d | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1016 | try ▸ if (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f99085e7 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1019 | try ▸ if (ds != null) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-05d3ba8a | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1027 | try ▸ if (ds != null) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-26b6ae25 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1032 | try ▸ else of (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a8629274 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1033 | try ▸ else of (ds != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-c65ac912 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1041 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ac775f53 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1043 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ffeefa75 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1043 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b0effa8 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1046 |  | FLAG | dtDivision | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_div", this._sDivision… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-1d493c23 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1046 |  | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_div", this._sDivision) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-65d332d3 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1050 |  | DATA_OP | Filter["USER_ID"] | txtUserID.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2189df40 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1051 |  | FLAG | dtPeusdoInfo | DataService.FP_ExecuteQuery2("FP01886_Authority_Request", "get_pseudo_division", Filter.Di… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_pseudo_division] \| FP\Admi… | 화면 필드/플래그 변경 |  |  |  |
| AC-ca23d6f2 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1051 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01886_Authority_Request", "get_pseudo_division", Filter.Dictionary, "Admin") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_pseudo_division] \| FP\Admi… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-615bbb19 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1053 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-52f6b749 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1057 | if (!string.IsNullOrEmpty(this._sDivision)) | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-032e53d1 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1059 | if (!string.IsNullOrEmpty(this._sDivision)) | CALL_EXT | clbDivision.SetAllCheckItem | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea3e177d | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1065 | if (!string.IsNullOrEmpty(this._sDivision)) ▸ for (k < clbDivision.Items.Count) ▸ if (clbDivision.DataSource.Rows[k].ItemArray[0].ToString()… | CALL_EXT | clbDivision.SetItemChecked | (k, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d35b27d4 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1066 | if (!string.IsNullOrEmpty(this._sDivision)) ▸ for (k < clbDivision.Items.Count) ▸ if (clbDivision.DataSource.Rows[k].ItemArray[0].ToString()… | CALL_EXT | clbDivision.SetFront | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1df0239d | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:1067 | if (!string.IsNullOrEmpty(this._sDivision)) ▸ for (k < clbDivision.Items.Count) ▸ if (clbDivision.DataSource.Rows[k].ItemArray[0].ToString()… | FOCUS | clbDivision.Focus | () | 포커스 이동 |  |  |  |

## FP01886_Authority_Request.Find_Request

진입점: this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you want to request authority?", "Request", MessageBoxButtons.OK) == DialogResult.OK) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnSelect.Click [try ▸ if (bChk)] / SaveButton [if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a89ec2e1 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1310 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa2ef8e5 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1327 | try ▸ if (ds != null) | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f26dd0d8 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1334 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-71c7fba5 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1339 | try ▸ if (ds != null) ▸ else of (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("Do not have the seletable permissions. Contact administrator.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f72906ca | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1345 | try ▸ if (ds != null) | GRID_LOCK | siSub.SetLockFlag | (SpdSheet.shtSub, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-104356e9 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1358 | try ▸ else of (ds != null) | GRID_SET | siSub.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-e6fbc9d6 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1370 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | ("Find_Request:" + ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-56bda2e9 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1376 | finally | GRID_SET | this.spdSub.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7017f62e | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1376 | finally | CALL_EXT | this.spdSub.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP01886_Authority_Request.FindData_MyAddedAuthList

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79e4e020 | this.Load | FP01886_Authority_Request.cs:481 | if (UserInfoContext.Current.UserId == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78246ffa | this.Load | FP01886_Authority_Request.cs:490 |  | ENDPOINT | new TheOne.ServiceModel.Data.FoxDataRequest | ("SystemManager.UP_FX_GetReqAuthMyListAdded") ⇒ SystemManager.UP_FX_GetReqAuthMyListAdded | 엔드포인트 요청 생성 |  |  |  |
| AC-69efddc2 | this.Load | FP01886_Authority_Request.cs:491 |  | DATA_OP | request.Parameters["p_UserID"] | p_UserID | 행/컬럼 값 대입 |  |  |  |
| AC-9695a5a4 | this.Load | FP01886_Authority_Request.cs:493 |  | ENDPOINT | client.ExecuteDataSet | (request) ⇒ {?new TheOne.ServiceModel.Data.FoxDataRequest("SystemManager.UP_FX_GetReqAuthMyL… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-536ca315 | this.Load | FP01886_Authority_Request.cs:499 |  | FLAG | dtMyAuthList | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## FP01886_Authority_Request.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a97dcdb6 | this.Load | FP01886_Authority_Request.cs:150 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ea027bf2 | this.Load | FP01886_Authority_Request.cs:156 |  | FLAG | dtLanguage | Data.Common(Data.Type.Language) ⇒ biz:CommonData.CommonDataList [code=Language] | 화면 필드/플래그 변경 |  |  |  |
| AC-792ef479 | this.Load | FP01886_Authority_Request.cs:156 |  | COMBO_DATA | Data.Common | (Data.Type.Language) ⇒ biz:CommonData.CommonDataList [code=Language] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-92b8a42f | this.Load | FP01886_Authority_Request.cs:158 |  | LIST_REBIND | clsCtrl.setListBox | (dtLanguage, cboLanguage_FP, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c295c3b5 | this.Load | FP01886_Authority_Request.cs:159 |  | FLAG | dtTimeZone | Data.Common(Data.Type.TimeZone) ⇒ biz:CommonData.CommonDataList [code=TimeZone] | 화면 필드/플래그 변경 |  |  |  |
| AC-94989f1e | this.Load | FP01886_Authority_Request.cs:159 |  | COMBO_DATA | Data.Common | (Data.Type.TimeZone) ⇒ biz:CommonData.CommonDataList [code=TimeZone] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f191078a | this.Load | FP01886_Authority_Request.cs:161 |  | LIST_REBIND | clsCtrl.setListBox | (dtTimeZone, cboTimeZone_FP, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP01886_Authority_Request.GetInitUserInfo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-748f0282 | this.Load | FP01886_Authority_Request.cs:224 | else of (CurUserID == null) | UI_PROP | _userinfo.UserID | CurUserID | 속성 UserID 설정 |  |  |  |
| AC-0edc2b6a | this.Load | FP01886_Authority_Request.cs:225 | else of (CurUserID == null) | UI_PROP | _userinfo.UserName | UserInfoContext.Current["NewUserName"] | 속성 UserName 설정 |  |  |  |
| AC-af2c1327 | this.Load | FP01886_Authority_Request.cs:228 | else of (CurUserID == null) ▸ if (UserInfoContext.Current["NewUserNameE"] == null) | UI_PROP | _userinfo.UserNameE | UserInfoContext.Current["NewUserName"] | 속성 UserNameE 설정 |  |  |  |
| AC-30ad3352 | this.Load | FP01886_Authority_Request.cs:230 | else of (CurUserID == null) ▸ else of (UserInfoContext.Current["NewUserNameE"] == null) | UI_PROP | _userinfo.UserNameE | UserInfoContext.Current["NewUserNameE"] | 속성 UserNameE 설정 |  |  |  |
| AC-06c9ae79 | this.Load | FP01886_Authority_Request.cs:233 | else of (CurUserID == null) | UI_PROP | _userinfo.Email | CurUserID + @"@lgensol.com" | 속성 Email 설정 |  |  |  |
| AC-2326ce41 | this.Load | FP01886_Authority_Request.cs:234 | else of (CurUserID == null) | UI_PROP | _userinfo.Dept_ID | UserInfoContext.Current["NewDeptID"] | 속성 Dept_ID 설정 |  |  |  |
| AC-3ae6164b | this.Load | FP01886_Authority_Request.cs:235 | else of (CurUserID == null) | UI_PROP | _userinfo.Dept_NameK | UserInfoContext.Current["NewDeptNameK"] | 속성 Dept_NameK 설정 |  |  |  |
| AC-b633b8d3 | this.Load | FP01886_Authority_Request.cs:236 | else of (CurUserID == null) | UI_PROP | _userinfo.Dept_NameE | UserInfoContext.Current["NewDeptNameE"] | 속성 Dept_NameE 설정 |  |  |  |
| AC-0fe47ce9 | this.Load | FP01886_Authority_Request.cs:237 | else of (CurUserID == null) | UI_PROP | _userinfo.Dept_NameC | UserInfoContext.Current["NewDeptNameC"] | 속성 Dept_NameC 설정 |  |  |  |
| AC-1c621aa7 | this.Load | FP01886_Authority_Request.cs:238 | else of (CurUserID == null) | UI_PROP | _userinfo.UserExistYN | UserInfoContext.Current["NewUserExistYN"] | 속성 UserExistYN 설정 |  |  |  |
| AC-8c98c43e | this.Load | FP01886_Authority_Request.cs:239 | else of (CurUserID == null) | UI_PROP | _userinfo.Default_Grp_ID | "Guest" | 속성 Default_Grp_ID 설정 |  |  |  |
| AC-706ddb67 | this.Load | FP01886_Authority_Request.cs:240 | else of (CurUserID == null) | UI_PROP | _userinfo.Language | "EN" | 속성 Language 설정 |  |  |  |
| AC-02d75316 | this.Load | FP01886_Authority_Request.cs:241 | else of (CurUserID == null) | UI_PROP | _userinfo.IsNewUser | "Y" | 속성 IsNewUser 설정 |  |  |  |

## FP01886_Authority_Request.GetInsertedUserInfo

진입점: this.Load [if (CurUserID == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86321e2b | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:274 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5ce5e7f4 | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:277 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetReqAuthCurrentUser") ⇒ SystemManager.UP_FX_GetReqAuthCurrentUser | 엔드포인트 요청 생성 |  |  |  |
| AC-775400f3 | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:278 | lambda | DATA_OP | req.Parameters["p_UserID"] | User_ID | 행/컬럼 값 대입 |  |  |  |
| AC-12957144 | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:280 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a4a2619 | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:281 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d95ae2cd | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:289 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.UserID | ds.Tables[0].Rows[0]["USERID"].ToString() | 속성 UserID 설정 |  |  |  |
| AC-f430678f | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:290 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.UserName | ds.Tables[0].Rows[0]["USERNAME"].ToString() | 속성 UserName 설정 |  |  |  |
| AC-31497165 | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:292 | if (ds.Tables[0].Rows.Count >= 0) ▸ if (ds.Tables[0].Rows[0]["USERNAME_E"].ToString() == "") | UI_PROP | _userinfo.UserNameE | ds.Tables[0].Rows[0]["USERNAME"].ToString() | 속성 UserNameE 설정 |  |  |  |
| AC-909a1afe | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:294 | if (ds.Tables[0].Rows.Count >= 0) ▸ else of (ds.Tables[0].Rows[0]["USERNAME_E"].ToString() == "") | UI_PROP | _userinfo.UserNameE | ds.Tables[0].Rows[0]["USERNAME_E"].ToString() | 속성 UserNameE 설정 |  |  |  |
| AC-cbdb2d1c | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:296 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Email | ds.Tables[0].Rows[0]["EMAIL"].ToString() | 속성 Email 설정 |  |  |  |
| AC-3860e13a | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:297 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Dept_ID | ds.Tables[0].Rows[0]["DEPT_ID"].ToString() | 속성 Dept_ID 설정 |  |  |  |
| AC-cb1b5ecc | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:298 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.CellPhoneNum | ds.Tables[0].Rows[0]["CELLPHONENUM"].ToString() | 속성 CellPhoneNum 설정 |  |  |  |
| AC-061d5ebd | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:299 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Language | ds.Tables[0].Rows[0]["LANGUAGE"].ToString() | 속성 Language 설정 |  |  |  |
| AC-eac7655b | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:300 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Default_Grp_ID | ds.Tables[0].Rows[0]["DEFAULTGROUPID"].ToString() | 속성 Default_Grp_ID 설정 |  |  |  |
| AC-843633a0 | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:301 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.TimeZone | ds.Tables[0].Rows[0]["TIMEZONE"].ToString() | 속성 TimeZone 설정 |  |  |  |
| AC-f0d7e73a | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:302 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Dept_NameK | ds.Tables[0].Rows[0]["DEPT_NAME_KO"].ToString() | 속성 Dept_NameK 설정 |  |  |  |
| AC-2f080726 | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:303 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Dept_NameE | ds.Tables[0].Rows[0]["DEPT_NAME_EN"].ToString() | 속성 Dept_NameE 설정 |  |  |  |
| AC-feb66135 | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:304 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.Dept_NameC | ds.Tables[0].Rows[0]["DEPT_NAME_CN"].ToString() | 속성 Dept_NameC 설정 |  |  |  |
| AC-886f018d | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:305 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.UserExistYN | UserInfoContext.Current["NewUserExistYN"] ?? "Y" | 속성 UserExistYN 설정 |  |  |  |
| AC-0a01dc49 | this.Load [if (CurUserID == null)] | FP01886_Authority_Request.cs:306 | if (ds.Tables[0].Rows.Count >= 0) | UI_PROP | _userinfo.IsNewUser | "N" | 속성 IsNewUser 설정 |  |  |  |

## FP01886_Authority_Request.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9bd851f | this.Load | FP01886_Authority_Request.cs:316 | try ▸ if (clbDivision != null) | UI_PROP | clbDivision.NoneString | "None" | 속성 NoneString 설정 |  |  |  |
| AC-7d2f50bf | this.Load | FP01886_Authority_Request.cs:318 | try ▸ if (clbPlant != null) | UI_PROP | clbPlant.NoneString | "None" | 속성 NoneString 설정 |  |  |  |
| AC-378189a1 | this.Load | FP01886_Authority_Request.cs:320 | try ▸ if (clbShopGroup != null) | UI_PROP | clbShopGroup.NoneString | "None" | 속성 NoneString 설정 |  |  |  |
| AC-8f8a2f8f | this.Load | FP01886_Authority_Request.cs:323 | try ▸ if (clbInstance != null) | UI_PROP | clbInstance.NoneString | "None" | 속성 NoneString 설정 |  |  |  |
| AC-c47d9c0b | this.Load | FP01886_Authority_Request.cs:325 | try ▸ if (clbPlanGroup != null) | UI_PROP | clbPlanGroup.NoneString | "None" | 속성 NoneString 설정 |  |  |  |
| AC-08817ffa | this.Load | FP01886_Authority_Request.cs:327 | try ▸ if (clbFactory != null) | UI_PROP | clbFactory.NoneString | "None" | 속성 NoneString 설정 |  |  |  |
| AC-0ee36a6b | this.Load | FP01886_Authority_Request.cs:331 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0266e8fd | this.Load | FP01886_Authority_Request.cs:337 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5ce128c9 | this.Load | FP01886_Authority_Request.cs:338 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-45d3ec81 | this.Load | FP01886_Authority_Request.cs:343 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-3dbd2c97 | this.Load | FP01886_Authority_Request.cs:345 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-0c8ff078 | this.Load | FP01886_Authority_Request.cs:351 | try ▸ if (UserInfoContext.Current.UserId != "Guest") | FLAG | dtUserInfo | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_userInfo", UserInfoContext.Cu… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-bc6cacc3 | this.Load | FP01886_Authority_Request.cs:351 | try ▸ if (UserInfoContext.Current.UserId != "Guest") | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_userInfo", UserInfoContext.Current.UserId) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a5fe650d | this.Load | FP01886_Authority_Request.cs:356 | try ▸ if (UserInfoContext.Current.UserId != "Guest") ▸ if (dtUserInfo != null) ▸ if (dtUserInfo.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251", new object[] { UserInfoContext.Current.UserId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-63c5658c | this.Load | FP01886_Authority_Request.cs:360 | try ▸ if (UserInfoContext.Current.UserId != "Guest") ▸ if (dtUserInfo != null) ▸ else of (dtUserInfo.Rows.Count == 0) | VALUE_SET | txtUserID.Text | dtUserInfo.Rows[0]["NEW_USER_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a621a527 | this.Load | FP01886_Authority_Request.cs:361 | try ▸ if (UserInfoContext.Current.UserId != "Guest") ▸ if (dtUserInfo != null) ▸ else of (dtUserInfo.Rows.Count == 0) | VALUE_SET | txtUserName.Text | dtUserInfo.Rows[0]["USER_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-bff42ac7 | this.Load | FP01886_Authority_Request.cs:362 | try ▸ if (UserInfoContext.Current.UserId != "Guest") ▸ if (dtUserInfo != null) ▸ else of (dtUserInfo.Rows.Count == 0) | VALUE_SET | txtDepartment.Text | dtUserInfo.Rows[0]["DEPARTMENT"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-bc6280df | this.Load | FP01886_Authority_Request.cs:367 | try ▸ if (UserInfoContext.Current.UserId != "Guest") ▸ else of (dtUserInfo != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fcc8a889 | this.Load | FP01886_Authority_Request.cs:372 | try ▸ else of (UserInfoContext.Current.UserId != "Guest") | VALUE_SET | txtUserID.Text | UserInfoContext.Current["NewUserID"] | 컨트롤 값 설정 |  |  |  |
| AC-2ac80596 | this.Load | FP01886_Authority_Request.cs:373 | try ▸ else of (UserInfoContext.Current.UserId != "Guest") | VALUE_SET | txtUserName.Text | UserInfoContext.Current["NewUserName"] | 컨트롤 값 설정 |  |  |  |
| AC-5e20d1f6 | this.Load | FP01886_Authority_Request.cs:374 | try ▸ else of (UserInfoContext.Current.UserId != "Guest") | VALUE_SET | txtDepartment.Text | UserInfoContext.Current["NewDeptName"] | 컨트롤 값 설정 |  |  |  |
| AC-34feb104 | this.Load | FP01886_Authority_Request.cs:378 | try | FLAG | dtDivision | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_div", this._sDivision… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-0256fad8 | this.Load | FP01886_Authority_Request.cs:378 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_div", this._sDivision) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-90a9da69 | this.Load | FP01886_Authority_Request.cs:380 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-6cd78047 | this.Load | FP01886_Authority_Request.cs:385 | try ▸ if (!string.IsNullOrEmpty(this._sDivision)) | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-d34fbf37 | this.Load | FP01886_Authority_Request.cs:387 | try ▸ if (!string.IsNullOrEmpty(this._sDivision)) | CALL_EXT | clbDivision.SetAllCheckItem | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea70f141 | this.Load | FP01886_Authority_Request.cs:393 | try ▸ if (!string.IsNullOrEmpty(this._sDivision)) ▸ for (k < clbDivision.Items.Count) ▸ if (clbDivision.DataSource.Rows[k].ItemArray[0].ToSt… | CALL_EXT | clbDivision.SetItemChecked | (k, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a592d2fd | this.Load | FP01886_Authority_Request.cs:394 | try ▸ if (!string.IsNullOrEmpty(this._sDivision)) ▸ for (k < clbDivision.Items.Count) ▸ if (clbDivision.DataSource.Rows[k].ItemArray[0].ToSt… | CALL_EXT | clbDivision.SetFront | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f98f949c | this.Load | FP01886_Authority_Request.cs:395 | try ▸ if (!string.IsNullOrEmpty(this._sDivision)) ▸ for (k < clbDivision.Items.Count) ▸ if (clbDivision.DataSource.Rows[k].ItemArray[0].ToSt… | FOCUS | clbDivision.Focus | () | 포커스 이동 |  |  |  |
| AC-3d042565 | this.Load | FP01886_Authority_Request.cs:405 | try | FLAG | dtAuth | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-84c9d994 | this.Load | FP01886_Authority_Request.cs:406 | try | UI_PROP | dtAuth.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-c44753e0 | this.Load | FP01886_Authority_Request.cs:407 | try | DATA_OP | dtAuth.Columns.Add | (new DataColumn("CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a7991fc | this.Load | FP01886_Authority_Request.cs:408 | try | DATA_OP | dtAuth.Columns.Add | (new DataColumn("NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a91d9114 | this.Load | FP01886_Authority_Request.cs:409 | try | DATA_OP | dtAuth.Rows.Add | ("VIEWER", "VIEWER") | 데이터 객체 조작/조회 |  |  |  |
| AC-75b68892 | this.Load | FP01886_Authority_Request.cs:410 | try | DATA_OP | dtAuth.Rows.Add | ("PLANNER", "PLANNER") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc863707 | this.Load | FP01886_Authority_Request.cs:411 | try | LIST_REBIND | clsCtrl.setListBox | (dtAuth, cboAuth, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9530c7a2 | this.Load | FP01886_Authority_Request.cs:414 | try ▸ if (this._sAuthority.Equals("FP Planner")) | VALUE_SET | cboAuth.SelectedValue | "PLANNER" | 컨트롤 값 설정 |  |  |  |
| AC-4089cd6e | this.Load | FP01886_Authority_Request.cs:416 | try ▸ else of (this._sAuthority.Equals("FP Planner")) | VALUE_SET | cboAuth.SelectedValue | "VIEWER" | 컨트롤 값 설정 |  |  |  |
| AC-966894a2 | this.Load | FP01886_Authority_Request.cs:418 | try | FLAG | arrAuthorityCode | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-9df84d72 | this.Load | FP01886_Authority_Request.cs:419 | try | FLAG | arrAuthorityName | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-a89a6ac4 | this.Load | FP01886_Authority_Request.cs:421 | try | DATA_OP | arrAuthorityCode.Add | ("PLANNER") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a2da5f3 | this.Load | FP01886_Authority_Request.cs:422 | try | DATA_OP | arrAuthorityName.Add | ("PLANNER") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4b99bb0 | this.Load | FP01886_Authority_Request.cs:423 | try | DATA_OP | arrAuthorityCode.Add | ("VIEWER") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1aa3cd4 | this.Load | FP01886_Authority_Request.cs:424 | try | DATA_OP | arrAuthorityName.Add | ("VIEWER") | 데이터 객체 조작/조회 |  |  |  |
| AC-5613a183 | this.Load | FP01886_Authority_Request.cs:426 | try | FLAG | arrAuthorityViewerCode | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-fddfeeca | this.Load | FP01886_Authority_Request.cs:427 | try | FLAG | arrAuthorityViewerName | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-2a4d8d94 | this.Load | FP01886_Authority_Request.cs:429 | try | DATA_OP | arrAuthorityViewerCode.Add | ("VIEWER") | 데이터 객체 조작/조회 |  |  |  |
| AC-57a2b40a | this.Load | FP01886_Authority_Request.cs:430 | try | DATA_OP | arrAuthorityViewerName.Add | ("VIEWER") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ab532cb | this.Load | FP01886_Authority_Request.cs:432 | try | FLAG | cellTypeAuthorityCombo | new FarPoint.Win.Spread.CellType.ComboBoxCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-5c8f2ce7 | this.Load | FP01886_Authority_Request.cs:433 | try | UI_PROP | cellTypeAuthorityCombo.ItemData | (string[])arrAuthorityCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-8c8b6ede | this.Load | FP01886_Authority_Request.cs:434 | try | UI_PROP | cellTypeAuthorityCombo.Items | (string[])arrAuthorityName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-e28a165c | this.Load | FP01886_Authority_Request.cs:435 | try | UI_PROP | cellTypeAuthorityCombo.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-bfc51242 | this.Load | FP01886_Authority_Request.cs:437 | try | FLAG | cellTypeAuthorityCombo2 | new FarPoint.Win.Spread.CellType.ComboBoxCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-6910fb02 | this.Load | FP01886_Authority_Request.cs:438 | try | UI_PROP | cellTypeAuthorityCombo2.ItemData | (string[])arrAuthorityViewerCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-c6a3bcc0 | this.Load | FP01886_Authority_Request.cs:439 | try | UI_PROP | cellTypeAuthorityCombo2.Items | (string[])arrAuthorityViewerName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-47e63ca7 | this.Load | FP01886_Authority_Request.cs:440 | try | UI_PROP | cellTypeAuthorityCombo2.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-05dbd1cf | this.Load | FP01886_Authority_Request.cs:442 | try | UI_PROP | lblAuth.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e6bf69fe | this.Load | FP01886_Authority_Request.cs:448 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-351c1f71 | this.Load | FP01886_Authority_Request.cs:449 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7b002f70 | this.Load | FP01886_Authority_Request.cs:450 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1a7660a6 | this.Load | FP01886_Authority_Request.cs:452 | try ▸ if (adminAuth == false) | STATE | txtUserID.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a4db89be | this.Load | FP01886_Authority_Request.cs:453 | try ▸ if (adminAuth == false) | UI_PROP | lblUser.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ad5a9342 | this.Load | FP01886_Authority_Request.cs:457 | try ▸ else of (adminAuth == false) | STATE | txtUserID.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8f46ab23 | this.Load | FP01886_Authority_Request.cs:458 | try ▸ else of (adminAuth == false) | UI_PROP | lblUser.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c0009969 | this.Load | FP01886_Authority_Request.cs:472 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_Authority_Request.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ec16acf | this.Load | FP01886_Authority_Request.cs:584 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-d59fdc82 | this.Load | FP01886_Authority_Request.cs:587 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-4cc5e6d0 | this.Load | FP01886_Authority_Request.cs:593 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (idx < 0) | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0f7093d5 | this.Load | FP01886_Authority_Request.cs:595 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (idx < 0) | GRID_INIT | siMain.Freeze | (0, idx) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9627a216 | this.Load | FP01886_Authority_Request.cs:598 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-94523885 | this.Load | FP01886_Authority_Request.cs:599 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-93b0b696 | this.Load | FP01886_Authority_Request.cs:600 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLANT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6387fdbf | this.Load | FP01886_Authority_Request.cs:601 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FACTORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2689d246 | this.Load | FP01886_Authority_Request.cs:602 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INSTANCE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1de8490e | this.Load | FP01886_Authority_Request.cs:603 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SHOP_GROUP_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b225256f | this.Load | FP01886_Authority_Request.cs:605 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7646490e | this.Load | FP01886_Authority_Request.cs:606 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.APPROVAL_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1dc59ad1 | this.Load | FP01886_Authority_Request.cs:607 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.APPROVAL_TIME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-38c5363c | this.Load | FP01886_Authority_Request.cs:608 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.RELEASE_APPLY_FLAG)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ae8db114 | this.Load | FP01886_Authority_Request.cs:609 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.REQUEST_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-57ad4513 | this.Load | FP01886_Authority_Request.cs:610 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.REQUEST_TIME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-bfaae771 | this.Load | FP01886_Authority_Request.cs:615 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8435f7da | this.Load | FP01886_Authority_Request.cs:618 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-f13713c7 | this.Load | FP01886_Authority_Request.cs:621 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (idx < 0) | GRID_INIT | siSub.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7692c25d | this.Load | FP01886_Authority_Request.cs:623 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) ▸ else of (idx < 0) | GRID_INIT | siSub.Freeze | (0, idx) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-74346c13 | this.Load | FP01886_Authority_Request.cs:626 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f328b7b5 | this.Load | FP01886_Authority_Request.cs:627 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-48f590e8 | this.Load | FP01886_Authority_Request.cs:628 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.PLANT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0d2fc51d | this.Load | FP01886_Authority_Request.cs:629 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.FACTORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8bd1b2d8 | this.Load | FP01886_Authority_Request.cs:630 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.INSTANCE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2c626865 | this.Load | FP01886_Authority_Request.cs:631 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.SHOP_GROUP_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5a1d9ef6 | this.Load | FP01886_Authority_Request.cs:633 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.REQUEST_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-16eb1f2a | this.Load | FP01886_Authority_Request.cs:634 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ORG_MENU_AUTHORITY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-eef1d019 | this.Load | FP01886_Authority_Request.cs:642 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.ColumnHeader.Cells[0, siSub.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-dfb4bd8d | this.Load | FP01886_Authority_Request.cs:643 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.ColumnHeader.Cells[0, siSub.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-0bb5831c | this.Load | FP01886_Authority_Request.cs:644 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.ColumnHeader.Cells[0, siSub.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## FP01886_Authority_Request.Insert_Row_Request

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd8f13a3 | (진입점 미연결) | FP01886_Authority_Request.cs:952 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bf8af18b | (진입점 미연결) | FP01886_Authority_Request.cs:961 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.DIVISION_ID), siSub.GetColumnIndex(DefColumns.RE… | 그리드 편집 잠금/해제 |  |  |  |

## FP01886_Authority_Request.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fce4b871 | InsertButton | FP01886_Authority_Request.cs:726 |  | MESSAGE | MessageBox.Show | ("Insert Button can't use.!") | 메시지 표시 |  |  |  |
| AC-0183e81f | InsertButton | FP01886_Authority_Request.cs:727 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01886_Authority_Request.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4321f8ca | popSql.OnSql | FP01886_Authority_Request.cs:1927 | if (programID == "SELECT_MAIN") | RETURN | return Find_Data_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-186d7fae | popSql.OnSql | FP01886_Authority_Request.cs:1932 | else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_REQUEST") | RETURN | return Find_Data_Request("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-655038a8 | popSql.OnSql | FP01886_Authority_Request.cs:1937 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_REQUEST") ▸ if (programID == "SAVE_REQUEST") | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-0ccede8f | popSql.OnSql | FP01886_Authority_Request.cs:1937 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_REQUEST") ▸ if (programID == "SAVE_REQUEST") ▸ if (!DataUtil.checkRequi… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-627873a7 | popSql.OnSql | FP01886_Authority_Request.cs:1965 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_REQUEST") ▸ if (programID == "SAVE_REQUEST") ▸ if (iChkCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "After checked. Try again.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31f28313 | popSql.OnSql | FP01886_Authority_Request.cs:1966 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_REQUEST") ▸ if (programID == "SAVE_REQUEST") ▸ if (iChkCount == 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-f34f58ef | popSql.OnSql | FP01886_Authority_Request.cs:1969 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_REQUEST") ▸ if (programID == "SAVE_REQUEST") | RETURN | return Save_Data_Request("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-32fb0db4 | popSql.OnSql | FP01886_Authority_Request.cs:1972 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01886_Authority_Request.Save_Data_Request

진입점: this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you want to request authority?", "Request", MessageBoxButtons.OK) == DialogResult.OK) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub)] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_REQUEST") ▸ if (programID == "SAVE_REQUEST")] / SaveButton [if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-917fefa0 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1642 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_auth_seq") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-89270b0f | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1686 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST") ⇒ FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-0d8db825 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1687 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cf9cb2be | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1689 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-1ec316a8 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1690 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f7ef4bc7 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1691 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-4cc60fc8 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1692 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b2cd88a0 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1693 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_alt_user_id"] | p_alt_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c6740aa9 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1694 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_alt_user_name"] | p_alt_user_name | 행/컬럼 값 대입 |  |  |  |
| AC-78af5ce4 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1695 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-49f89daa | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1696 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-02017e06 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1697 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d27a7b38 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1698 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-e3666e70 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1699 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-e696dee9 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1700 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-538d5873 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1701 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_shop_group"] | p_shop_group | 행/컬럼 값 대입 |  |  |  |
| AC-b59b7a7b | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1702 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_group"] | p_plan_group | 행/컬럼 값 대입 |  |  |  |
| AC-e4a2aefa | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1703 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_menu_authority_id"] | p_menu_authority_id | 행/컬럼 값 대입 |  |  |  |
| AC-df195ce9 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1704 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-99e751d3 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1705 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_notifiy"] | p_release_notifiy | 행/컬럼 값 대입 |  |  |  |
| AC-4485fdfc | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1706 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_new_seq"] | p_new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-1c7ee7af | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1708 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-57de6bb1 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1709 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1a5da8d4 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1715 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e3b87314 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1721 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01886_Authority_Request.Save_Request

진입점: this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you want to request authority?", "Request", MessageBoxButtons.OK) == DialogResult.OK)] / SaveButton [if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-feb53470 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1547 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-5b47c5c6 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1547 | if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d817ddc9 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1549 | if (siSub == null \|\| siSub.IsLock(siSub.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d88fb66 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1551 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ee1ae97 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1556 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-20ca9dc1 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1557 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-274596ba | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1560 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c990b615 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1567 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-bf47ee0a | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1569 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-61cf23a7 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1570 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ec626b3 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1572 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-ddebf9b3 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1572 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-37a5cf36 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1576 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d576ca7a | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1581 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b35a6e0 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1586 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | FLAG | bSaveRequest | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fd660170 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1593 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8bcbcbb6 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1597 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cf63ffeb | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1601 | catch () | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d0a14e90 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1602 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-80c57b9d | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_Authority_Request.cs:1607 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01886_Authority_Request.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6711b34 | SaveButton | FP01886_Authority_Request.cs:711 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01886_Authority_Request.SetChangedControl

진입점: this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResult.OK)] / this.Load [try] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-991413d3 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:527 | try | FLAG | dtPlant | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_plant", sDivision) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-909aa744 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:527 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_plant", sDivision) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-551473ec | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:528 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-ec961f23 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:533 | try | FLAG | dtShopGroup | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_shop", sDivision, sPl… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-eda3262a | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:533 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_shop", sDivision, sPlant) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-401df3f7 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:534 | try | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, clbShopGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-bdada722 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:539 | try | FLAG | dtInstance | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_instance", sDivision,… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-03dcb734 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:539 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_instance", sDivision, sPlant, sShopGroup) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95080f05 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:541 | try | LIST_REBIND | clsCtrl.setListBox | (dtInstance, clbInstance, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-1a9c56dd | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:546 | try | FLAG | dtFactory | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_factory", sDivision, … ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-be851115 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:546 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_factory", sDivision, sPlant, sShopGroup, sInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c74f9fdd | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:547 | try | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-a3f08855 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:553 | try | FLAG | dtPlanGroup | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_plangroup", sInstance… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-8a0c547b | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:553 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_plangroup", sInstance, sFactory) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-16ab4c7b | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 2 | FP01886_Authority_Request.cs:554 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01886_Authority_Request.SetSpreadComboControl

진입점: this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you want to request authority?", "Request", MessageBoxButtons.OK) == DialogResult.OK) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.btnSelect.Click [try ▸ if (bChk) ▸ try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / SaveButton [if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SU…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db415078 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1534 | try ▸ for (i <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID), sAuthority) | 그리드 값 설정 |  |  |  |
| AC-b5dc4990 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1540 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-600ed17c | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_Authority_Request.cs:1541 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_Authority_Request.SetUserinfo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52ec3bc4 | this.Load | FP01886_Authority_Request.cs:184 | if (dtMyAuthList.Rows.Count > 0) ▸ if (!string.IsNullOrWhiteSpace(sLanguage)) | UI_PROP | _userinfo.Language | sLanguage | 속성 Language 설정 |  |  |  |
| AC-93b94244 | this.Load | FP01886_Authority_Request.cs:185 | if (dtMyAuthList.Rows.Count > 0) ▸ if (!string.IsNullOrWhiteSpace(sLanguage)) | UI_PROP | _userinfo.IsNewUser | "N" | 속성 IsNewUser 설정 |  |  |  |
| AC-2a847257 | this.Load | FP01886_Authority_Request.cs:188 | if (dtMyAuthList.Rows.Count > 0) ▸ if (!string.IsNullOrWhiteSpace(sTimeZone)) | UI_PROP | _userinfo.TimeZone | sTimeZone | 속성 TimeZone 설정 |  |  |  |
| AC-8d0d8017 | this.Load | FP01886_Authority_Request.cs:194 | if (_userinfo.Language == null \|\| _userinfo.IsNewUser == "Y") | VALUE_SET | cboLanguage_FP.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-51016b84 | this.Load | FP01886_Authority_Request.cs:198 | else of (_userinfo.Language == null \|\| _userinfo.IsNewUser == "Y") | VALUE_SET | cboLanguage_FP.SelectedValue | _userinfo.Language | 컨트롤 값 설정 |  |  |  |
| AC-76bb449a | this.Load | FP01886_Authority_Request.cs:203 | if (_userinfo.TimeZone == null \|\| _userinfo.IsNewUser == "Y") | VALUE_SET | cboTimeZone_FP.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-4b2cad90 | this.Load | FP01886_Authority_Request.cs:207 | else of (_userinfo.TimeZone == null \|\| _userinfo.IsNewUser == "Y") | VALUE_SET | cboTimeZone_FP.SelectedValue | _userinfo.TimeZone | 컨트롤 값 설정 |  |  |  |

## FP01886_Authority_Request.spdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cc06cee | this.spdSub.CellClick | FP01886_Authority_Request.cs:1884 | if (siSub.IsLock(siSub.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01886_AuthorityRequestPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c01c6e5 | .ctor | FP01886_AuthorityRequestPopup.cs:136 |  | FLAG | this._sAuthority | pAuthority | 화면 필드/플래그 변경 |  |  |  |
| AC-d1474cc6 | .ctor | FP01886_AuthorityRequestPopup.cs:137 |  | FLAG | this._sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-e0409473 | .ctor | FP01886_AuthorityRequestPopup.cs:138 |  | FLAG | this._sUserID | pUserID | 화면 필드/플래그 변경 |  |  |  |
| AC-5c05a88b | .ctor | FP01886_AuthorityRequestPopup.cs:139 |  | FLAG | this._sUserName | pUserName | 화면 필드/플래그 변경 |  |  |  |
| AC-79e9cfe0 | .ctor | FP01886_AuthorityRequestPopup.cs:140 |  | FLAG | this._sDepartment | pDepartment | 화면 필드/플래그 변경 |  |  |  |

## FP01886_AuthorityRequestPopup.btnClose_Click

진입점: this.btnClose.Click / this.layoutControlItem11.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-736ecc59 | this.btnClose.Click 외 1 | FP01886_AuthorityRequestPopup.cs:1298 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01886_AuthorityRequestPopup.btnRequest_Click

진입점: this.btnRequest.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9041a222 | this.btnRequest.Click | FP01886_AuthorityRequestPopup.cs:605 | try ▸ if (iChkCount==0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8dce0276 | this.btnRequest.Click | FP01886_AuthorityRequestPopup.cs:606 | try ▸ if (iChkCount==0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc4317a7 | this.btnRequest.Click | FP01886_AuthorityRequestPopup.cs:609 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_is_exists_request", sUserID, sList) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8fd5f966 | this.btnRequest.Click | FP01886_AuthorityRequestPopup.cs:614 | try ▸ if (dtExist.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de6cc24a | this.btnRequest.Click | FP01886_AuthorityRequestPopup.cs:615 | try ▸ if (dtExist.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47be0ade | this.btnRequest.Click | FP01886_AuthorityRequestPopup.cs:618 | try | MESSAGE | MessageBox.Show | ("Do you want to request authority?", "Request", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-1eccad7f | this.btnRequest.Click | FP01886_AuthorityRequestPopup.cs:626 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_AuthorityRequestPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cdee6a0 | this.btnSql.Click | FP01886_AuthorityRequestPopup.cs:641 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0605f33b | this.btnSql.Click | FP01886_AuthorityRequestPopup.cs:642 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-39c5a84a | this.btnSql.Click | FP01886_AuthorityRequestPopup.cs:644 |  | DATA_OP | popSql.Services.Add | ("SELECT_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-5403e76a | this.btnSql.Click | FP01886_AuthorityRequestPopup.cs:645 |  | DATA_OP | popSql.Services.Add | ("SELECT_REQUEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-68ad50cb | this.btnSql.Click | FP01886_AuthorityRequestPopup.cs:646 |  | DATA_OP | popSql.Services.Add | ("SAVE_REQUEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-03c60608 | this.btnSql.Click | FP01886_AuthorityRequestPopup.cs:647 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01886_AuthorityRequestPopup.btnUser_Click

진입점: this.btnUser.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7f0f7c3 | this.btnUser.Click | FP01886_AuthorityRequestPopup.cs:538 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-02b0a519 | this.btnUser.Click | FP01886_AuthorityRequestPopup.cs:541 |  | POPUP | new FP01886_UserFindPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0aaafb6c | this.btnUser.Click | FP01886_AuthorityRequestPopup.cs:543 |  | UI_PROP | UserPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-3c891e7e | this.btnUser.Click | FP01886_AuthorityRequestPopup.cs:544 |  | UI_PROP | UserPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-117019b0 | this.btnUser.Click | FP01886_AuthorityRequestPopup.cs:545 |  | POPUP | UserPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bb55b7bc | this.btnUser.Click | FP01886_AuthorityRequestPopup.cs:548 | if (UserPopup.ShowDialog() == DialogResult.OK) | VALUE_SET | txtUserID.Text | UserPopup._UserId | 컨트롤 값 설정 |  |  |  |
| AC-52dcd68c | this.btnUser.Click | FP01886_AuthorityRequestPopup.cs:549 | if (UserPopup.ShowDialog() == DialogResult.OK) | VALUE_SET | txtUserName.Text | UserPopup._UserName | 컨트롤 값 설정 |  |  |  |
| AC-8f086228 | this.btnUser.Click | FP01886_AuthorityRequestPopup.cs:550 | if (UserPopup.ShowDialog() == DialogResult.OK) | VALUE_SET | txtDepartment.Text | UserPopup._Department | 컨트롤 값 설정 |  |  |  |

## FP01886_AuthorityRequestPopup.CheckValidationControl

진입점: this.btnSelect.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62f9421a | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:840 | try ▸ if (string.IsNullOrEmpty(pMenuAuthorityID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-88f9ca35 | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:841 | try ▸ if (string.IsNullOrEmpty(pMenuAuthorityID)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-69cf46d2 | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:847 | try ▸ if (string.IsNullOrEmpty(pDivision)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44b27565 | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:848 | try ▸ if (string.IsNullOrEmpty(pDivision)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fecbb92d | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:853 | try ▸ if (string.IsNullOrEmpty(pPlant)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-331ec436 | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:854 | try ▸ if (string.IsNullOrEmpty(pPlant)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5b3506ff | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:859 | try ▸ if (string.IsNullOrEmpty(pShopGroup)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-292e86d4 | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:860 | try ▸ if (string.IsNullOrEmpty(pShopGroup)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-845e1d15 | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:867 | try ▸ if (string.IsNullOrEmpty(pInstance)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7425564 | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:868 | try ▸ if (string.IsNullOrEmpty(pInstance)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-85d8492e | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:873 | try ▸ if (string.IsNullOrEmpty(pFactory)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-affbc1fc | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:874 | try ▸ if (string.IsNullOrEmpty(pFactory)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5468091d | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:879 | try ▸ if (string.IsNullOrEmpty(pPlanGroup)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06204f1a | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:880 | try ▸ if (string.IsNullOrEmpty(pPlanGroup)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-bb4995d5 | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:883 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-f11d7b67 | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:887 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | ("CheckValidationControl: " + ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-b5501ab2 | this.btnSelect.Click | FP01886_AuthorityRequestPopup.cs:888 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01886_AuthorityRequestPopup.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1dadc7da | clbDivision.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1316 | try | FLAG | dtPlant | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_plant", sDivision) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-8dc4a68c | clbDivision.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1316 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_plant", sDivision) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cbb3516c | clbDivision.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1317 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-34218251 | clbDivision.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1323 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_AuthorityRequestPopup.ClbFactory_SelectedIndexChanged

진입점: clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d5e4f36 | clbFactory.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1432 | try | FLAG | dtPlanGroup | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_plangroup", sInstance… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-3f678a0f | clbFactory.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1432 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_plangroup", sInstance, sFactory) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7abe2354 | clbFactory.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1433 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-9f617dcc | clbFactory.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1438 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_AuthorityRequestPopup.ClbInstance_SelectedIndexChanged

진입점: clbInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b484b0db | clbInstance.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1406 | try | FLAG | dtFactory | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_factory", sDivision, … ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-f587d31e | clbInstance.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1406 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_factory", sDivision, sPlant, sShopGroup, sInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d4c11f8d | clbInstance.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1407 | try | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-5e1e53ab | clbInstance.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1412 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_AuthorityRequestPopup.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b096240 | clbPlant.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1344 | try | FLAG | dtShopGroup | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_shop", sDivision, sPl… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4786a1dd | clbPlant.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1344 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_shop", sDivision, sPlant) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d629a800 | clbPlant.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1345 | try | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, clbShopGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-f438ec3f | clbPlant.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1351 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_AuthorityRequestPopup.ClbShopGroup_SelectedIndexChanged

진입점: clbShopGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a310b14 | clbShopGroup.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1375 | try | FLAG | dtInstance | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_instance", sDivision,… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-ef19d21f | clbShopGroup.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1375 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_instance", sDivision, sPlant, sShopGroup) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-72187271 | clbShopGroup.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1376 | try | LIST_REBIND | clsCtrl.setListBox | (dtInstance, clbInstance, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-8d1925f7 | clbShopGroup.SelectedIndexChanged | FP01886_AuthorityRequestPopup.cs:1382 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_AuthorityRequestPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-943dd31c | this.Load | FP01886_AuthorityRequestPopup.cs:367 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-560a8add | this.Load | FP01886_AuthorityRequestPopup.cs:368 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0bf91a22 | this.Load | FP01886_AuthorityRequestPopup.cs:371 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f0f5120d | this.Load | FP01886_AuthorityRequestPopup.cs:372 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-70006de7 | this.Load | FP01886_AuthorityRequestPopup.cs:375 |  | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-146812a1 | this.Load | FP01886_AuthorityRequestPopup.cs:379 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01886_AuthorityRequestPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a409961 | this.Load | FP01886_AuthorityRequestPopup.cs:176 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-a393a54f | this.Load | FP01886_AuthorityRequestPopup.cs:178 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-095f54f3 | this.Load | FP01886_AuthorityRequestPopup.cs:179 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-e6e25be0 | this.Load | FP01886_AuthorityRequestPopup.cs:180 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP01886_AuthorityRequestPopup.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3da51ff8 | DeleteButton | FP01886_AuthorityRequestPopup.cs:520 |  | MESSAGE | MessageBox.Show | ("Delete Button can't use.!") | 메시지 표시 |  |  |  |
| AC-c21dee52 | DeleteButton | FP01886_AuthorityRequestPopup.cs:521 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01886_AuthorityRequestPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97cca922 | Dispose | FP01886_AuthorityRequestPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01886_AuthorityRequestPopup.EditButton

진입점: this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null)] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c707f507 | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null)] 외 1 | FP01886_AuthorityRequestPopup.cs:457 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7289f433 | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null)] 외 1 | FP01886_AuthorityRequestPopup.cs:465 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-fedc216d | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null)] 외 1 | FP01886_AuthorityRequestPopup.cs:466 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-1dbacae0 | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null)] 외 1 | FP01886_AuthorityRequestPopup.cs:467 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.NEW_USER_ID), siSub.GetColumnIndex(DefColumns.REQUEST_ID)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8e69f60a | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null)] 외 1 | FP01886_AuthorityRequestPopup.cs:468 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.LockRange2 | (0, siSub.GetColumnIndex(DefColumns.CHK), siSub.ActiveSheet.RowCount - 1, siSub.GetColumnI… | 그리드 편집 잠금 전환 |  |  |  |
| AC-b9275123 | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null)] 외 1 | FP01886_AuthorityRequestPopup.cs:476 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (i % 2 =… | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID), i, siSub.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-d4ec1412 | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null)] 외 1 | FP01886_AuthorityRequestPopup.cs:477 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (i % 2 =… | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.RELEASE_NOTIFIY_TYPE), i, siSub.GetColumnIndex(DefColu… | 그리드 표시 설정 |  |  |  |
| AC-c30958dd | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null)] 외 1 | FP01886_AuthorityRequestPopup.cs:481 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (i … | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID), i, siSub.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-deecc9ec | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null)] 외 1 | FP01886_AuthorityRequestPopup.cs:482 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (i … | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.RELEASE_NOTIFIY_TYPE), i, siSub.GetColumnIndex(DefColu… | 그리드 표시 설정 |  |  |  |

## FP01886_AuthorityRequestPopup.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-788786f5 | ExcelButton | FP01886_AuthorityRequestPopup.cs:672 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP01886_AuthorityRequestPopup.Find_Data_Main

진입점: this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResult.OK) ▸ try ▸ lambda] / this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you want to request authority?", "Request", MessageBoxButtons.OK) == DialogResult.OK) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "SELECT_MAIN")] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1117364a | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:760 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pUserID = txtUserID.Text.ToString(); //USER… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9bba21ac | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:772 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP") ⇒ FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-4214bf3b | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:773 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-dc17e59d | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:774 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-f1ec7f33 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:775 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8efd07ec | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:776 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-78bde951 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:777 | try | DATA_OP | request.Parameters["p_alt_user_id"] | pUserID | 행/컬럼 값 대입 |  |  |  |
| AC-2bfff218 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:778 | try | DATA_OP | request.Parameters["p_alt_user_name"] | pUserName | 행/컬럼 값 대입 |  |  |  |
| AC-7e3f9a44 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:779 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a5b9c510 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:780 | try | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-98b3a502 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:781 | try | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f27d731b | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:782 | try | DATA_OP | request.Parameters["p_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-facfc316 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:783 | try | DATA_OP | request.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d6c062b9 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:784 | try | DATA_OP | request.Parameters["p_instance_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fe29a524 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:785 | try | DATA_OP | request.Parameters["p_shop_group"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e43b9d2e | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:786 | try | DATA_OP | request.Parameters["p_plan_group"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-917f0c5b | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:787 | try | DATA_OP | request.Parameters["p_menu_authority_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f12311d7 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:788 | try | DATA_OP | request.Parameters["p_request_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d86254ab | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:789 | try | DATA_OP | request.Parameters["p_release_notifiy"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b31a1fe4 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:790 | try | DATA_OP | request.Parameters["p_new_seq"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b2367cff | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:792 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9cbed1da | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:794 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-facf6fba | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 5 | FP01886_AuthorityRequestPopup.cs:799 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01886_AuthorityRequestPopup.Find_Data_Request

진입점: this.btnSelect.Click [if (bChk) ▸ try] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_REQUEST")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5054be48 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:982 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pUserID = txtUserID.Text.ToString(); //USER… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c5fa79e0 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1003 | if (string.IsNullOrEmpty(pUserID.ToString())) | MESSAGE | MessageBox.Show | ("Select [User ID]") | 메시지 표시 |  |  |  |
| AC-a5c7d9cb | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1004 | if (string.IsNullOrEmpty(pUserID.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-408751b5 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1009 | if (string.IsNullOrEmpty(pDivision.ToString())) | MESSAGE | MessageBox.Show | ( "Select [Division]!") | 메시지 표시 |  |  |  |
| AC-34e0884b | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1010 | if (string.IsNullOrEmpty(pDivision.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-19b89909 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1014 | if (string.IsNullOrEmpty(pPlant.ToString())) | MESSAGE | MessageBox.Show | ("Select [Plant]!") | 메시지 표시 |  |  |  |
| AC-e4057373 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1015 | if (string.IsNullOrEmpty(pPlant.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-4d0c02e2 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1019 | if (string.IsNullOrEmpty(pShopGroup.ToString())) | MESSAGE | MessageBox.Show | ("Select [Shop Group]!") | 메시지 표시 |  |  |  |
| AC-b48fd8a9 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1020 | if (string.IsNullOrEmpty(pShopGroup.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e0b36d13 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1027 | if (string.IsNullOrEmpty(pInstance.ToString())) | MESSAGE | MessageBox.Show | ("Select [Instance]!") | 메시지 표시 |  |  |  |
| AC-297c6dfc | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1028 | if (string.IsNullOrEmpty(pInstance.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-df9c66aa | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1032 | if (string.IsNullOrEmpty(pFactory.ToString())) | MESSAGE | MessageBox.Show | ("Select [Factory]!") | 메시지 표시 |  |  |  |
| AC-358558b9 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1033 | if (string.IsNullOrEmpty(pFactory.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-353a55aa | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1037 | if (string.IsNullOrEmpty(pPlanGroup.ToString())) | MESSAGE | MessageBox.Show | ("Select [Plan Group]!") | 메시지 표시 |  |  |  |
| AC-a0ed94db | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1038 | if (string.IsNullOrEmpty(pPlanGroup.ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-4211ebe7 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1045 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP") ⇒ FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-cf3ee5d9 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1047 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-23fbeeab | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1048 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_SUB" | 행/컬럼 값 대입 |  |  |  |
| AC-5f7ef60c | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1049 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9b866d49 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1050 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b1002afc | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1051 | try | DATA_OP | request.Parameters["p_alt_user_id"] | pUserID | 행/컬럼 값 대입 |  |  |  |
| AC-3b236aad | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1052 | try | DATA_OP | request.Parameters["p_alt_user_name"] | pUserName | 행/컬럼 값 대입 |  |  |  |
| AC-e146b618 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1053 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-25f71b3c | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1054 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1807fd62 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1055 | try | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a03d18ad | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1056 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlant | 행/컬럼 값 대입 |  |  |  |
| AC-6dac9bef | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1057 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactory | 행/컬럼 값 대입 |  |  |  |
| AC-3ec623e7 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1058 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstance | 행/컬럼 값 대입 |  |  |  |
| AC-754d1e50 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1059 | try | DATA_OP | request.Parameters["p_shop_group"] | pShopGroup | 행/컬럼 값 대입 |  |  |  |
| AC-58a86fc5 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1060 | try | DATA_OP | request.Parameters["p_plan_group"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-6090b97f | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1061 | try | DATA_OP | request.Parameters["p_menu_authority_id"] | pMenuAuthorityID | 행/컬럼 값 대입 |  |  |  |
| AC-85d7187e | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1062 | try | DATA_OP | request.Parameters["p_request_id"] | pRequestID | 행/컬럼 값 대입 |  |  |  |
| AC-ababc1c2 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1063 | try | DATA_OP | request.Parameters["p_release_notifiy"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-014294c3 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1064 | try | DATA_OP | request.Parameters["p_new_seq"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-71cf0023 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1066 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e450d074 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1068 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-83c5e131 | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1073 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | ("Find_Data_Request: " + ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-ccb3907d | this.btnSelect.Click [if (bChk) ▸ try] 외 1 | FP01886_AuthorityRequestPopup.cs:1074 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01886_AuthorityRequestPopup.Find_Main

진입점: this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResult.OK)] / this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you want to request authority?", "Request", MessageBoxButtons.OK) == DialogResult.OK) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.Load / FindButton / SaveButton [if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77bef9e2 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:681 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-05fabbfc | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:685 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-51d38baf | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:688 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-482f4305 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:688 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa87fa7c | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:694 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fb39e6b6 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:697 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-06a9cc48 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:703 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c22d771c | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:704 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Main("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-66e5a540 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:715 | try ▸ if (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f0d8724c | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:717 | try ▸ if (ds != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ed53b79d | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:720 | try ▸ if (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9a0fad30 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:723 | try ▸ if (ds != null) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-74147280 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:731 | try ▸ if (ds != null) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-5ee55aa5 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:736 | try ▸ else of (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-95597ab7 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:737 | try ▸ else of (ds != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-6912a051 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:744 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | ("Find_Main: " + ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-30de13a4 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:748 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b7b98c84 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:750 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-103304e5 | this.btnUser.Click [if (UserPopup.ShowDialog() == DialogResu… 외 4 | FP01886_AuthorityRequestPopup.cs:750 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP01886_AuthorityRequestPopup.Find_Request

진입점: this.btnSelect.Click [if (bChk)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd79fbed | this.btnSelect.Click [if (bChk)] | FP01886_AuthorityRequestPopup.cs:908 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-57d3e600 | this.btnSelect.Click [if (bChk)] | FP01886_AuthorityRequestPopup.cs:921 | try ▸ if (ds != null) | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b5f48a4b | this.btnSelect.Click [if (bChk)] | FP01886_AuthorityRequestPopup.cs:928 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c87eecd | this.btnSelect.Click [if (bChk)] | FP01886_AuthorityRequestPopup.cs:938 | try ▸ if (ds != null) | GRID_LOCK | siSub.SetLockFlag | (SpdSheet.shtSub, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2cfee5ae | this.btnSelect.Click [if (bChk)] | FP01886_AuthorityRequestPopup.cs:947 | try ▸ else of (ds != null) | GRID_SET | siSub.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-09ceb4bb | this.btnSelect.Click [if (bChk)] | FP01886_AuthorityRequestPopup.cs:959 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | ("Find_Request: " + ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-24f92414 | this.btnSelect.Click [if (bChk)] | FP01886_AuthorityRequestPopup.cs:965 | finally | GRID_SET | this.spdSub.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e55c996b | this.btnSelect.Click [if (bChk)] | FP01886_AuthorityRequestPopup.cs:965 | finally | CALL_EXT | this.spdSub.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP01886_AuthorityRequestPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-747707fa | this.Load | FP01886_AuthorityRequestPopup.cs:146 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01886_AuthorityRequestPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82bf12a1 | this.Load | FP01886_AuthorityRequestPopup.cs:189 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-12358bb9 | this.Load | FP01886_AuthorityRequestPopup.cs:195 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2731922a | this.Load | FP01886_AuthorityRequestPopup.cs:196 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-dda2613e | this.Load | FP01886_AuthorityRequestPopup.cs:201 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-d572ad58 | this.Load | FP01886_AuthorityRequestPopup.cs:203 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-936a03d2 | this.Load | FP01886_AuthorityRequestPopup.cs:207 | try | FLAG | dtUserInfo | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_userInfo", UserInfoContext.Cu… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4007bc40 | this.Load | FP01886_AuthorityRequestPopup.cs:207 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_userInfo", UserInfoContext.Current.UserId) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-55980014 | this.Load | FP01886_AuthorityRequestPopup.cs:212 | try ▸ if (dtUserInfo != null) ▸ if (dtUserInfo.Rows.Count > 0) | VALUE_SET | txtUserID.Text | dtUserInfo.Rows[0]["NEW_USER_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-bc82050f | this.Load | FP01886_AuthorityRequestPopup.cs:213 | try ▸ if (dtUserInfo != null) ▸ if (dtUserInfo.Rows.Count > 0) | VALUE_SET | txtUserName.Text | dtUserInfo.Rows[0]["USER_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-9ef72671 | this.Load | FP01886_AuthorityRequestPopup.cs:214 | try ▸ if (dtUserInfo != null) ▸ if (dtUserInfo.Rows.Count > 0) | VALUE_SET | txtDepartment.Text | dtUserInfo.Rows[0]["DEPARTMENT"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-56dc0fa4 | this.Load | FP01886_AuthorityRequestPopup.cs:218 | try ▸ if (dtUserInfo != null) ▸ else of (dtUserInfo.Rows.Count > 0) | VALUE_SET | txtUserID.Text | _sUserID | 컨트롤 값 설정 |  |  |  |
| AC-9dc8e929 | this.Load | FP01886_AuthorityRequestPopup.cs:219 | try ▸ if (dtUserInfo != null) ▸ else of (dtUserInfo.Rows.Count > 0) | VALUE_SET | txtUserName.Text | _sUserName | 컨트롤 값 설정 |  |  |  |
| AC-a715da6f | this.Load | FP01886_AuthorityRequestPopup.cs:220 | try ▸ if (dtUserInfo != null) ▸ else of (dtUserInfo.Rows.Count > 0) | VALUE_SET | txtDepartment.Text | _sDepartment | 컨트롤 값 설정 |  |  |  |
| AC-29d89933 | this.Load | FP01886_AuthorityRequestPopup.cs:226 | try | FLAG | dtDivision | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_div") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-c06325fb | this.Load | FP01886_AuthorityRequestPopup.cs:226 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_div") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6fc335d4 | this.Load | FP01886_AuthorityRequestPopup.cs:227 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-f76e9f31 | this.Load | FP01886_AuthorityRequestPopup.cs:252 | try | FLAG | dtAuth | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-38dff4e0 | this.Load | FP01886_AuthorityRequestPopup.cs:253 | try | UI_PROP | dtAuth.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-12570136 | this.Load | FP01886_AuthorityRequestPopup.cs:254 | try | DATA_OP | dtAuth.Columns.Add | (new DataColumn("CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c46b8915 | this.Load | FP01886_AuthorityRequestPopup.cs:255 | try | DATA_OP | dtAuth.Columns.Add | (new DataColumn("NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab49cbe0 | this.Load | FP01886_AuthorityRequestPopup.cs:256 | try | DATA_OP | dtAuth.Rows.Add | ("VIEWER", "VIEWER") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec0412b5 | this.Load | FP01886_AuthorityRequestPopup.cs:257 | try | DATA_OP | dtAuth.Rows.Add | ("PLANNER", "PLANNER") | 데이터 객체 조작/조회 |  |  |  |
| AC-7237b5c9 | this.Load | FP01886_AuthorityRequestPopup.cs:258 | try | LIST_REBIND | clsCtrl.setListBox | (dtAuth, cboAuth, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-caede711 | this.Load | FP01886_AuthorityRequestPopup.cs:261 | try ▸ if (this._sAuthority.Equals("FP Planner")) | VALUE_SET | cboAuth.SelectedValue | "PLANNER" | 컨트롤 값 설정 |  |  |  |
| AC-91fed8c9 | this.Load | FP01886_AuthorityRequestPopup.cs:263 | try ▸ else of (this._sAuthority.Equals("FP Planner")) | VALUE_SET | cboAuth.SelectedValue | "VIEWER" | 컨트롤 값 설정 |  |  |  |
| AC-ae6b9e71 | this.Load | FP01886_AuthorityRequestPopup.cs:265 | try | FLAG | arrAuthorityCode | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-b44c7612 | this.Load | FP01886_AuthorityRequestPopup.cs:266 | try | FLAG | arrAuthorityName | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-c477add6 | this.Load | FP01886_AuthorityRequestPopup.cs:268 | try | DATA_OP | arrAuthorityCode.Add | ("PLANNER") | 데이터 객체 조작/조회 |  |  |  |
| AC-595cbc31 | this.Load | FP01886_AuthorityRequestPopup.cs:269 | try | DATA_OP | arrAuthorityName.Add | ("PLANNER") | 데이터 객체 조작/조회 |  |  |  |
| AC-065d21ad | this.Load | FP01886_AuthorityRequestPopup.cs:270 | try | DATA_OP | arrAuthorityCode.Add | ("VIEWER") | 데이터 객체 조작/조회 |  |  |  |
| AC-c17dc558 | this.Load | FP01886_AuthorityRequestPopup.cs:271 | try | DATA_OP | arrAuthorityName.Add | ("VIEWER") | 데이터 객체 조작/조회 |  |  |  |
| AC-db974606 | this.Load | FP01886_AuthorityRequestPopup.cs:273 | try | FLAG | arrAuthorityViewerCode | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-141546f2 | this.Load | FP01886_AuthorityRequestPopup.cs:274 | try | FLAG | arrAuthorityViewerName | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-c4707904 | this.Load | FP01886_AuthorityRequestPopup.cs:276 | try | DATA_OP | arrAuthorityViewerCode.Add | ("VIEWER") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f3f54de | this.Load | FP01886_AuthorityRequestPopup.cs:277 | try | DATA_OP | arrAuthorityViewerName.Add | ("VIEWER") | 데이터 객체 조작/조회 |  |  |  |
| AC-a637939f | this.Load | FP01886_AuthorityRequestPopup.cs:279 | try | FLAG | cellTypeAuthorityCombo | new FarPoint.Win.Spread.CellType.ComboBoxCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-581da1d0 | this.Load | FP01886_AuthorityRequestPopup.cs:280 | try | UI_PROP | cellTypeAuthorityCombo.ItemData | (string[])arrAuthorityCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-57ee3bef | this.Load | FP01886_AuthorityRequestPopup.cs:281 | try | UI_PROP | cellTypeAuthorityCombo.Items | (string[])arrAuthorityName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-419665a8 | this.Load | FP01886_AuthorityRequestPopup.cs:282 | try | UI_PROP | cellTypeAuthorityCombo.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-2d2e482e | this.Load | FP01886_AuthorityRequestPopup.cs:284 | try | FLAG | cellTypeAuthorityCombo2 | new FarPoint.Win.Spread.CellType.ComboBoxCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d49bb67b | this.Load | FP01886_AuthorityRequestPopup.cs:285 | try | UI_PROP | cellTypeAuthorityCombo2.ItemData | (string[])arrAuthorityViewerCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-9e1fd05c | this.Load | FP01886_AuthorityRequestPopup.cs:286 | try | UI_PROP | cellTypeAuthorityCombo2.Items | (string[])arrAuthorityViewerName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-eff9b202 | this.Load | FP01886_AuthorityRequestPopup.cs:287 | try | UI_PROP | cellTypeAuthorityCombo2.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-1be296b9 | this.Load | FP01886_AuthorityRequestPopup.cs:296 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-3f5e4c5d | this.Load | FP01886_AuthorityRequestPopup.cs:297 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bda58c66 | this.Load | FP01886_AuthorityRequestPopup.cs:298 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8e7b8870 | this.Load | FP01886_AuthorityRequestPopup.cs:301 | try | UI_PROP | lblUser.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b87834b3 | this.Load | FP01886_AuthorityRequestPopup.cs:311 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_AuthorityRequestPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-850527d2 | this.Load | FP01886_AuthorityRequestPopup.cs:386 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7bad6090 | this.Load | FP01886_AuthorityRequestPopup.cs:389 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-9b20de47 | this.Load | FP01886_AuthorityRequestPopup.cs:394 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4e87ca33 | this.Load | FP01886_AuthorityRequestPopup.cs:397 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-789a1fe9 | this.Load | FP01886_AuthorityRequestPopup.cs:398 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8c5375e9 | this.Load | FP01886_AuthorityRequestPopup.cs:399 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLANT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-868856ad | this.Load | FP01886_AuthorityRequestPopup.cs:400 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FACTORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ea43cdcb | this.Load | FP01886_AuthorityRequestPopup.cs:401 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INSTANCE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2f9fa609 | this.Load | FP01886_AuthorityRequestPopup.cs:402 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SHOP_GROUP_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7ed16e34 | this.Load | FP01886_AuthorityRequestPopup.cs:403 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_GROUP_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-be53f868 | this.Load | FP01886_AuthorityRequestPopup.cs:404 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-38a4d667 | this.Load | FP01886_AuthorityRequestPopup.cs:405 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.APPROVAL_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c6cc1d3c | this.Load | FP01886_AuthorityRequestPopup.cs:406 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.APPROVAL_TIME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-673f973b | this.Load | FP01886_AuthorityRequestPopup.cs:407 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.RELEASE_APPLY_FLAG)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e6765853 | this.Load | FP01886_AuthorityRequestPopup.cs:408 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.REQUEST_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5e2a41dd | this.Load | FP01886_AuthorityRequestPopup.cs:409 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.REQUEST_TIME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1c1c8451 | this.Load | FP01886_AuthorityRequestPopup.cs:414 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-4ffaa79e | this.Load | FP01886_AuthorityRequestPopup.cs:417 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-19cb9d64 | this.Load | FP01886_AuthorityRequestPopup.cs:419 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.Freeze | (0, siSub.GetColumnIndex(DefColumns.NEW_USER_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e1ed855b | this.Load | FP01886_AuthorityRequestPopup.cs:422 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1fcd3bba | this.Load | FP01886_AuthorityRequestPopup.cs:423 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8771451e | this.Load | FP01886_AuthorityRequestPopup.cs:424 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.PLANT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b4fc6412 | this.Load | FP01886_AuthorityRequestPopup.cs:425 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.FACTORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d41ff0b7 | this.Load | FP01886_AuthorityRequestPopup.cs:426 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.INSTANCE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1aa3526d | this.Load | FP01886_AuthorityRequestPopup.cs:427 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.SHOP_GROUP_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e7f4674f | this.Load | FP01886_AuthorityRequestPopup.cs:428 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.PLAN_GROUP_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7af87fbb | this.Load | FP01886_AuthorityRequestPopup.cs:429 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.REQUEST_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c1c04331 | this.Load | FP01886_AuthorityRequestPopup.cs:430 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.ORG_MENU_AUTHORITY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a8521e99 | this.Load | FP01886_AuthorityRequestPopup.cs:438 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.ColumnHeader.Cells[0, siSub.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-6ab7c5c1 | this.Load | FP01886_AuthorityRequestPopup.cs:439 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.ColumnHeader.Cells[0, siSub.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-93e117c7 | this.Load | FP01886_AuthorityRequestPopup.cs:440 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.ColumnHeader.Cells[0, siSub.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## FP01886_AuthorityRequestPopup.Insert_Row_Request

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d9b7324 | (진입점 미연결) | FP01886_AuthorityRequestPopup.cs:656 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b88cfe90 | (진입점 미연결) | FP01886_AuthorityRequestPopup.cs:665 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.DIVISION_ID), siSub.GetColumnIndex(DefColumns.RE… | 그리드 편집 잠금/해제 |  |  |  |

## FP01886_AuthorityRequestPopup.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b88ce15f | InsertButton | FP01886_AuthorityRequestPopup.cs:512 |  | MESSAGE | MessageBox.Show | ("Insert Button can't use.!") | 메시지 표시 |  |  |  |
| AC-01feaf11 | InsertButton | FP01886_AuthorityRequestPopup.cs:513 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01886_AuthorityRequestPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ea5470d | popSql.OnSql | FP01886_AuthorityRequestPopup.cs:1490 | if (programID == "SELECT_MAIN") | RETURN | return Find_Data_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-54d6d2e0 | popSql.OnSql | FP01886_AuthorityRequestPopup.cs:1495 | else of (programID == "SELECT_MAIN") ▸ if (programID == "SELECT_REQUEST") | RETURN | return Find_Data_Request("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-1345e08f | popSql.OnSql | FP01886_AuthorityRequestPopup.cs:1500 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_REQUEST") ▸ if (programID == "SAVE_REQUEST") | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-7f987965 | popSql.OnSql | FP01886_AuthorityRequestPopup.cs:1500 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_REQUEST") ▸ if (programID == "SAVE_REQUEST") ▸ if (!DataUtil.checkRequi… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-3cf21cda | popSql.OnSql | FP01886_AuthorityRequestPopup.cs:1528 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_REQUEST") ▸ if (programID == "SAVE_REQUEST") ▸ if (iChkCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "After checked. Try again.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c27a2ab0 | popSql.OnSql | FP01886_AuthorityRequestPopup.cs:1529 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_REQUEST") ▸ if (programID == "SAVE_REQUEST") ▸ if (iChkCount == 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-5818855f | popSql.OnSql | FP01886_AuthorityRequestPopup.cs:1532 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_REQUEST") ▸ if (programID == "SAVE_REQUEST") | RETURN | return Save_Data_Request("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-8b0af231 | popSql.OnSql | FP01886_AuthorityRequestPopup.cs:1535 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01886_AuthorityRequestPopup.Save_Data_Request

진입점: this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you want to request authority?", "Request", MessageBoxButtons.OK) == DialogResult.OK) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub)] / popSql.OnSql [else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_REQUEST") ▸ if (programID == "SAVE_REQUEST")] / SaveButton [if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77aea4ea | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1208 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_auth_seq") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c53231fe | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1251 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP") ⇒ FP_Master.PR_UI_FP01886_AUTHORITYREQUESTPOPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-403ad8e7 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1252 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-852cba1e | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1254 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-59aa9f32 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1255 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-11a9a631 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1256 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-dbb6fe3c | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1257 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e9a16fec | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1258 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_alt_user_id"] | p_alt_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a52f3f5d | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1259 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_alt_user_name"] | p_alt_user_name | 행/컬럼 값 대입 |  |  |  |
| AC-69209cad | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1260 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-21019604 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1261 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-cd7f43bb | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1262 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d6aaf244 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1263 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-e16be3c7 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1264 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc9d586b | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1265 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-b6eb6b60 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1266 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_shop_group"] | p_shop_group | 행/컬럼 값 대입 |  |  |  |
| AC-1d2e7e30 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1267 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_group"] | p_plan_group | 행/컬럼 값 대입 |  |  |  |
| AC-b7402e2f | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1268 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_menu_authority_id"] | p_menu_authority_id | 행/컬럼 값 대입 |  |  |  |
| AC-c34cae2c | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1269 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_request_id"] | p_request_id | 행/컬럼 값 대입 |  |  |  |
| AC-3c2f9761 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1270 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_notifiy"] | p_release_notifiy | 행/컬럼 값 대입 |  |  |  |
| AC-287c21b0 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1271 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_new_seq"] | p_new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-e40c11da | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1273 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88ea3a9d | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1274 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3ceea553 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1280 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-85fe6f41 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 2 | FP01886_AuthorityRequestPopup.cs:1286 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01886_AuthorityRequestPopup.Save_Request

진입점: this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you want to request authority?", "Request", MessageBoxButtons.OK) == DialogResult.OK)] / SaveButton [if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6802e63 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1110 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-1abce67c | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1110 | if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6d57911 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1112 | if (siSub == null \|\| siSub.IsLock(siSub.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-747a66b0 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1114 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b231264b | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1119 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b2ddc77c | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1120 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6afa25e | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1123 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a99ead41 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1130 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-48759950 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1132 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-97e03732 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1133 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa70b9af | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1138 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2bf87abe | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1143 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fb2447d0 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1150 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | GRID_SET | siSub.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-3cd4fcdb | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1152 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | FLAG | bSaveRequest | true | 화면 필드/플래그 변경 |  |  |  |
| AC-05764b92 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1159 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a22b81f9 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1163 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c07727cd | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1167 | catch () | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c45ece36 | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1168 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1e4c26c | this.btnRequest.Click [try ▸ if (MessageBox.Show("Do you wan… 외 1 | FP01886_AuthorityRequestPopup.cs:1173 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01886_AuthorityRequestPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e9e39c9 | SaveButton | FP01886_AuthorityRequestPopup.cs:497 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01886_AuthorityRequestPopup.SetChangedControl

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ceb07de | this.Load [try] | FP01886_AuthorityRequestPopup.cs:330 | try | FLAG | dtPlant | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_plant", sDivision) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-817806f2 | this.Load [try] | FP01886_AuthorityRequestPopup.cs:330 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_plant", sDivision) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-82458e79 | this.Load [try] | FP01886_AuthorityRequestPopup.cs:331 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-8a4eb802 | this.Load [try] | FP01886_AuthorityRequestPopup.cs:336 | try | FLAG | dtShopGroup | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_shop", sDivision, sPl… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-5fae8043 | this.Load [try] | FP01886_AuthorityRequestPopup.cs:336 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_shop", sDivision, sPlant) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c180bd0f | this.Load [try] | FP01886_AuthorityRequestPopup.cs:337 | try | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, clbShopGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-3e5847f1 | this.Load [try] | FP01886_AuthorityRequestPopup.cs:342 | try | FLAG | dtInstance | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_instance", sDivision,… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b3dd4b5d | this.Load [try] | FP01886_AuthorityRequestPopup.cs:342 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_instance", sDivision, sPlant, sShopGroup) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e46576c7 | this.Load [try] | FP01886_AuthorityRequestPopup.cs:343 | try | LIST_REBIND | clsCtrl.setListBox | (dtInstance, clbInstance, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-7ba4317d | this.Load [try] | FP01886_AuthorityRequestPopup.cs:348 | try | FLAG | dtFactory | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_factory", sDivision, … ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-f746433a | this.Load [try] | FP01886_AuthorityRequestPopup.cs:348 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_factory", sDivision, sPlant, sShopGroup, sInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-774106e7 | this.Load [try] | FP01886_AuthorityRequestPopup.cs:349 | try | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-7e7fe28b | this.Load [try] | FP01886_AuthorityRequestPopup.cs:355 | try | FLAG | dtPlanGroup | DataCommon.GetUserFormCodeData(_FormProcedure, "FP01886_find_newAuth_plangroup", sInstance… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-802a77db | this.Load [try] | FP01886_AuthorityRequestPopup.cs:355 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP01886_find_newAuth_plangroup", sInstance, sFactory) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e57a0fff | this.Load [try] | FP01886_AuthorityRequestPopup.cs:356 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01886_AuthorityRequestPopup.SetSpreadComboControl

진입점: this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f402066 | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null) ▸ if… | FP01886_AuthorityRequestPopup.cs:1091 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (sOrgAuthority.Equals("PLANNER")) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID)].CellType | cellTypeAuthorityCombo | 그리드 속성/값 설정 |  |  |  |
| AC-1d2c421e | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null) ▸ if… | FP01886_AuthorityRequestPopup.cs:1095 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (sOrgAuthority.Equals("PLANNER")) | GRID_SET | siSub.ActiveSheet.Cells[i, siSub.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID)].CellType | cellTypeAuthorityCombo2 | 그리드 속성/값 설정 |  |  |  |
| AC-40b3f5ab | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null) ▸ if… | FP01886_AuthorityRequestPopup.cs:1097 | try ▸ for (i <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID), sAuthority) | 그리드 값 설정 |  |  |  |
| AC-f8ef26cc | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null) ▸ if… | FP01886_AuthorityRequestPopup.cs:1103 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | ("SetSpreadComboControl: " + ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-71cc16c5 | this.btnSelect.Click [if (bChk) ▸ try ▸ if (ds != null) ▸ if… | FP01886_AuthorityRequestPopup.cs:1104 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01886_AuthorityRequestPopup.spdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef96d916 | this.spdSub.CellClick | FP01886_AuthorityRequestPopup.cs:1448 | if (siSub.IsLock(siSub.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01886_AuthorityRequestPopup.spdSub_ComboSelChange

진입점: this.spdSub.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5363062 | this.spdSub.ComboSelChange | FP01886_AuthorityRequestPopup.cs:1454 | if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26f62aec | this.spdSub.ComboSelChange | FP01886_AuthorityRequestPopup.cs:1456 | if ((siSub.ActiveSheet.Rows.Count <= 0) \|\| siSub.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5e60bb8 | this.spdSub.ComboSelChange | FP01886_AuthorityRequestPopup.cs:1465 | if (e.Column == siSub.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID)) ▸ if (sData.Equals("PLANNER")) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.RELEASE_NOTIFIY_TYPE), "MAIL") | 그리드 값 설정 |  |  |  |
| AC-d611cc93 | this.spdSub.ComboSelChange | FP01886_AuthorityRequestPopup.cs:1469 | if (e.Column == siSub.GetColumnIndex(DefColumns.MENU_AUTHORITY_ID)) ▸ else of (sData.Equals("PLANNER")) ▸ if (sData.Equals("VIEWER")) | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.RELEASE_NOTIFIY_TYPE), "NONE") | 그리드 값 설정 |  |  |  |

## FP01886_UserFindPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d12df744 | this.btnButtonList.UsrButtonList_Click_Detected | FP01886_UserFindPopup.cs:367 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-2185ccd7 | this.btnButtonList.UsrButtonList_Click_Detected | FP01886_UserFindPopup.cs:370 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01886_UserFindPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc3b317b | this.Load | FP01886_UserFindPopup.cs:193 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e0a781f3 | this.Load | FP01886_UserFindPopup.cs:194 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-14ed1ed2 | this.Load | FP01886_UserFindPopup.cs:195 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01886_UserFindPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ea6b38c | this.Load | FP01886_UserFindPopup.cs:188 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01886_UserFindPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c529fa2f | Dispose | FP01886_UserFindPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01886_UserFindPopup.Find_Data_User

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa642004 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:317 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pUserID = txtUserID.Text.ToString(); //USER… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e779c57c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:329 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01886_USER_POPUP") ⇒ FP_Master.PR_UI_FP01886_USER_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-edc28e68 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:331 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-037f6eb4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:333 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-cb9aa1cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:334 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_USER" | 행/컬럼 값 대입 |  |  |  |
| AC-295b903b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:335 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-115408fa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:336 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e785aac1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:337 | try | DATA_OP | request.Parameters["p_auth_user_id"] | pUserID | 행/컬럼 값 대입 |  |  |  |
| AC-c2964ef9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:338 | try | DATA_OP | request.Parameters["p_auth_user_name"] | pUserName | 행/컬럼 값 대입 |  |  |  |
| AC-cd8579aa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:340 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3c40f387 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:342 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1ae47c86 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:348 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01886_UserFindPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c1d6df9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:246 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6d314a0b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:250 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-187c62ed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:253 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-ba2a19cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:253 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d7f8d9a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:259 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a617f344 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:262 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8c66f0fb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:268 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-485d8d38 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:269 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_User("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d4324144 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:280 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4d33d12a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:282 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6eaeedba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:285 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a2a2b18f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:288 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0016a36d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:296 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-6690151e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:298 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | iClick_Row | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-a04ccc47 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:305 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-88bb3b1e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:307 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0cf524bf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:307 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP01886_UserFindPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c1887ef | this.Load | FP01886_UserFindPopup.cs:163 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f89b98ec | this.Load | FP01886_UserFindPopup.cs:165 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01886_UserFindPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5146a46d | this.Load | FP01886_UserFindPopup.cs:205 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e2f527e4 | this.Load | FP01886_UserFindPopup.cs:206 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01886_UserFindPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a93826d | (진입점 미연결) | FP01886_UserFindPopup.cs:233 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01886_UserFindPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1f49ed4 | this.Load | FP01886_UserFindPopup.cs:213 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f15d3457 | this.Load | FP01886_UserFindPopup.cs:214 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-5f0ed595 | this.Load | FP01886_UserFindPopup.cs:218 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-2d65fa30 | this.Load | FP01886_UserFindPopup.cs:221 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.COMPANY), false) | 그리드 표시 설정 |  |  |  |
| AC-3f1d89cf | this.Load | FP01886_UserFindPopup.cs:222 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.DIVISION), false) | 그리드 표시 설정 |  |  |  |
| AC-a9f692c2 | this.Load | FP01886_UserFindPopup.cs:223 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.CORPORATION), false) | 그리드 표시 설정 |  |  |  |
| AC-37552fe5 | this.Load | FP01886_UserFindPopup.cs:224 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.DEPARTMENT), false) | 그리드 표시 설정 |  |  |  |
| AC-53594f88 | this.Load | FP01886_UserFindPopup.cs:225 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.USER_GRAD_CODE), false) | 그리드 표시 설정 |  |  |  |
| AC-521be28d | this.Load | FP01886_UserFindPopup.cs:226 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.IP_ADRESS), false) | 그리드 표시 설정 |  |  |  |
| AC-a4cc2af5 | this.Load | FP01886_UserFindPopup.cs:227 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.PASS_CODE), false) | 그리드 표시 설정 |  |  |  |

## FP01886_UserFindPopup.SetUserInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e347308b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:415 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-100c43b1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:416 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b58906a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:418 |  | FLAG | _CompanyId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.COMPANY)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0c44118d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:419 |  | FLAG | _DivisionId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DIVISION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f903ea16 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:420 |  | FLAG | _CorporationId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.CORPORATION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-56022d74 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:421 |  | FLAG | _PlantId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLANT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-50bc3246 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:422 |  | FLAG | _Department | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DEPARTMENT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b7c7d4f8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:423 |  | FLAG | _UserId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-56921853 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:424 |  | FLAG | _UserName | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e870b78a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:425 |  | FLAG | _UserGradeCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_GRAD_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c7dc1e57 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:426 |  | FLAG | _IP | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.IP_ADRESS)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-701392d1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:427 |  | FLAG | _PassCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PASS_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0c8799e9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP01886_UserFindPopup.cs:430 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01886_UserFindPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f46f532 | this.spdMain.CellClick | FP01886_UserFindPopup.cs:380 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7582e88d | this.spdMain.CellClick | FP01886_UserFindPopup.cs:382 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP01886_UserFindPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00156500 | this.spdMain.CellDoubleClick | FP01886_UserFindPopup.cs:386 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-2e329ef0 | this.spdMain.CellDoubleClick | FP01886_UserFindPopup.cs:388 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f9ae214 | this.spdMain.CellDoubleClick | FP01886_UserFindPopup.cs:390 |  | FLAG | _CompanyId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.COMPANY)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-55f4435d | this.spdMain.CellDoubleClick | FP01886_UserFindPopup.cs:391 |  | FLAG | _DivisionId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DIVISION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1d40dc7d | this.spdMain.CellDoubleClick | FP01886_UserFindPopup.cs:392 |  | FLAG | _CorporationId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.CORPORATION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-669655b2 | this.spdMain.CellDoubleClick | FP01886_UserFindPopup.cs:393 |  | FLAG | _PlantId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLANT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8c2281a0 | this.spdMain.CellDoubleClick | FP01886_UserFindPopup.cs:394 |  | FLAG | _Department | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DEPARTMENT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1e38c79d | this.spdMain.CellDoubleClick | FP01886_UserFindPopup.cs:395 |  | FLAG | _UserId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3c786852 | this.spdMain.CellDoubleClick | FP01886_UserFindPopup.cs:396 |  | FLAG | _UserName | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-221a96df | this.spdMain.CellDoubleClick | FP01886_UserFindPopup.cs:397 |  | FLAG | _UserGradeCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_GRAD_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-64212125 | this.spdMain.CellDoubleClick | FP01886_UserFindPopup.cs:398 |  | FLAG | _IP | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.IP_ADRESS)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8b412a7a | this.spdMain.CellDoubleClick | FP01886_UserFindPopup.cs:399 |  | FLAG | _PassCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PASS_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-11c404cc | this.spdMain.CellDoubleClick | FP01886_UserFindPopup.cs:404 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |


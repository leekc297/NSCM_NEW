# AS-IS 액션 대조표 — FP03033

> 원천: `Doc/asisfacts/screens/FP03033/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1793행 · 메서드 141 · 종류 DATA_OP 790 · RETURN 186 · FLAG 105 · STATE 105 · GRID_SET 84 · MESSAGE 82 · UI_PROP 69 · GRID_INIT 48 · ENDPOINT 45 · UI_MISC 43 · CALL_EXT 40 · POPUP 35 · GRID_LOCK 28 · VALUE_SET 25 · GRID_STYLE 22 · CALL_BASE 19 · COMBO_DATA 13 · LIST_REBIND 13 · GRID_BIND 12 · THROW 7 · VALUE_CLEAR 6 · VALIDATE 4 · EXCEL 3 · STATE_RESET 3 · GRID_COMBO 2 · FOCUS 2 · LIST_BIND 1 · GRID_CLEAR 1 · ⚠ 의미 확인 필요 59


## FP03033_AddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11da6a53 | .ctor | FP03033_AddPopup.cs:114 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-08ec3d77 | .ctor | FP03033_AddPopup.cs:115 |  | FLAG | this._sPopupFlag | sPopupFlag | 화면 필드/플래그 변경 |  |  |  |

## FP03033_AddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46bcb4ef | this.btnClose.Click | FP03033_AddPopup.cs:486 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP03033_AddPopup.btnFactory_Click

진입점: this.btnFactory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc7789a3 | this.btnFactory.Click | FP03033_AddPopup.cs:501 | else of (sUserList.IndexOf(UserInfoContext.Current.UserId.ToString()) != -1) | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetCodeFp | ("FP03033_AddPopup", "DEFAULT_PLANT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-24efd776 | this.btnFactory.Click | FP03033_AddPopup.cs:509 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-ae0faa36 | this.btnFactory.Click | FP03033_AddPopup.cs:512 |  | POPUP | new FPC0001_BuildingPopup | (true, false, Filter["p_division_id"].ToString(), Filter["p_site_id"].ToString(), sPlantID… | 팝업/폼 생성 |  |  |  |
| AC-ebc3a298 | this.btnFactory.Click | FP03033_AddPopup.cs:514 |  | UI_PROP | FactoryPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-f569747d | this.btnFactory.Click | FP03033_AddPopup.cs:515 |  | UI_PROP | FactoryPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-530f0d4c | this.btnFactory.Click | FP03033_AddPopup.cs:516 |  | POPUP | FactoryPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5008a942 | this.btnFactory.Click | FP03033_AddPopup.cs:518 | if (FactoryPopup.ShowDialog() == DialogResult.OK) | UI_PROP | lblCompany.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-390c025d | this.btnFactory.Click | FP03033_AddPopup.cs:520 | if (FactoryPopup.ShowDialog() == DialogResult.OK) | VALUE_SET | txtCompany.Text | FactoryPopup._CompanyId | 컨트롤 값 설정 |  |  |  |
| AC-4eac0570 | this.btnFactory.Click | FP03033_AddPopup.cs:521 | if (FactoryPopup.ShowDialog() == DialogResult.OK) | VALUE_SET | txtDivision.Text | FactoryPopup._DivisionId | 컨트롤 값 설정 |  |  |  |
| AC-81b54d05 | this.btnFactory.Click | FP03033_AddPopup.cs:522 | if (FactoryPopup.ShowDialog() == DialogResult.OK) | VALUE_SET | txtSite.Text | FactoryPopup._SiteId | 컨트롤 값 설정 |  |  |  |
| AC-920ae504 | this.btnFactory.Click | FP03033_AddPopup.cs:523 | if (FactoryPopup.ShowDialog() == DialogResult.OK) | VALUE_SET | txtPlant.Text | FactoryPopup._PlantId | 컨트롤 값 설정 |  |  |  |
| AC-30ed7811 | this.btnFactory.Click | FP03033_AddPopup.cs:524 | if (FactoryPopup.ShowDialog() == DialogResult.OK) | VALUE_SET | txtFactory.Text | FactoryPopup._FactoryId | 컨트롤 값 설정 |  |  |  |
| AC-f2a72fb6 | this.btnFactory.Click | FP03033_AddPopup.cs:526 | if (FactoryPopup.ShowDialog() == DialogResult.OK) | STATE | cboProdVerType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-05c7365a | this.btnFactory.Click | FP03033_AddPopup.cs:528 | if (FactoryPopup.ShowDialog() == DialogResult.OK) | FLAG | dtProdVerType | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP03033_find_ConversionType", txtD… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-d947424c | this.btnFactory.Click | FP03033_AddPopup.cs:528 | if (FactoryPopup.ShowDialog() == DialogResult.OK) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP03033_find_ConversionType", txtDivision.Text, txtSite.Text, txtPlant.T… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d9393700 | this.btnFactory.Click | FP03033_AddPopup.cs:529 | if (FactoryPopup.ShowDialog() == DialogResult.OK) | LIST_REBIND | clsCtrl.setListBox | (dtProdVerType, cboProdVerType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f0217873 | this.btnFactory.Click | FP03033_AddPopup.cs:530 | if (FactoryPopup.ShowDialog() == DialogResult.OK) | VALUE_CLEAR | cboProdVerType.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-efa81d23 | this.btnFactory.Click | FP03033_AddPopup.cs:532 | if (FactoryPopup.ShowDialog() == DialogResult.OK) | VALUE_CLEAR | txtOperation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-b553c2f9 | this.btnFactory.Click | FP03033_AddPopup.cs:533 | if (FactoryPopup.ShowDialog() == DialogResult.OK) | VALUE_CLEAR | txtMaterial.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-8068d37d | this.btnFactory.Click | FP03033_AddPopup.cs:537 |  | STATE | cboProdVerType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7151c5bb | this.btnFactory.Click | FP03033_AddPopup.cs:538 |  | STATE | cboVersionType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fdbe4ce5 | this.btnFactory.Click | FP03033_AddPopup.cs:539 |  | STATE | txtVersion.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP03033_AddPopup.btnMaterial_Click

진입점: this.btnMaterial.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56e8bde8 | this.btnMaterial.Click | FP03033_AddPopup.cs:574 | if (txtOperation.Text.ToString().Equals("")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Insert Operation Value.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8cb84aa3 | this.btnMaterial.Click | FP03033_AddPopup.cs:575 | if (txtOperation.Text.ToString().Equals("")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9575e6d2 | this.btnMaterial.Click | FP03033_AddPopup.cs:578 |  | POPUP | new FP03033_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f1891675 | this.btnMaterial.Click | FP03033_AddPopup.cs:580 |  | DATA_OP | ItemPopup.Filter["p_division_id"] | txtDivision.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f93b2a94 | this.btnMaterial.Click | FP03033_AddPopup.cs:581 |  | DATA_OP | ItemPopup.Filter["p_site_id"] | txtSite.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9d1a6e81 | this.btnMaterial.Click | FP03033_AddPopup.cs:582 |  | DATA_OP | ItemPopup.Filter["p_operation_id"] | txtOperation.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fafb0be5 | this.btnMaterial.Click | FP03033_AddPopup.cs:584 |  | UI_PROP | ItemPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-755c0922 | this.btnMaterial.Click | FP03033_AddPopup.cs:585 |  | UI_PROP | ItemPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-c15347a6 | this.btnMaterial.Click | FP03033_AddPopup.cs:586 |  | POPUP | ItemPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e1eafe33 | this.btnMaterial.Click | FP03033_AddPopup.cs:592 | if (ItemPopup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtMaterial.Text | data["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-9819d5fe | this.btnMaterial.Click | FP03033_AddPopup.cs:593 | if (ItemPopup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtModel.Text | data["MODEL_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8a59de60 | this.btnMaterial.Click | FP03033_AddPopup.cs:594 | if (ItemPopup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtPjtCode.Text | data["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d89fd2f0 | this.btnMaterial.Click | FP03033_AddPopup.cs:598 | if (ItemPopup.ShowDialog() == DialogResult.OK) | FLAG | dtLastVersion | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP03033_find_LastVersion", txtDivision.T… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-591a69a0 | this.btnMaterial.Click | FP03033_AddPopup.cs:598 | if (ItemPopup.ShowDialog() == DialogResult.OK) | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP03033_find_LastVersion", txtDivision.Text, txtSite.Text, txtPlant.Text… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-07f53a0d | this.btnMaterial.Click | FP03033_AddPopup.cs:603 | if (ItemPopup.ShowDialog() == DialogResult.OK) ▸ if (dtLastVersion != null) | VALUE_SET | txtLastVersion.Text | dtLastVersion.Rows[0]["LAST_VERSION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-bfad4cd6 | this.btnMaterial.Click | FP03033_AddPopup.cs:606 | if (ItemPopup.ShowDialog() == DialogResult.OK) | STATE | cboProdVerType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9e6da95f | this.btnMaterial.Click | FP03033_AddPopup.cs:607 | if (ItemPopup.ShowDialog() == DialogResult.OK) | STATE | cboVersionType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9db76e20 | this.btnMaterial.Click | FP03033_AddPopup.cs:608 | if (ItemPopup.ShowDialog() == DialogResult.OK) | STATE | txtVersion.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP03033_AddPopup.btnOperation_Click

진입점: this.btnOperation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a784441a | this.btnOperation.Click | FP03033_AddPopup.cs:547 | if (txtFactory.Text.ToString().Equals("")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Insert Building Value.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-42cdf84f | this.btnOperation.Click | FP03033_AddPopup.cs:548 | if (txtFactory.Text.ToString().Equals("")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe383d39 | this.btnOperation.Click | FP03033_AddPopup.cs:554 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-045e91df | this.btnOperation.Click | FP03033_AddPopup.cs:557 |  | POPUP | new FPC0002_OperationPopup | (true, false, txtDivision.Text.ToString(), txtSite.Text.ToString()) | 팝업/폼 생성 |  |  |  |
| AC-d940ee41 | this.btnOperation.Click | FP03033_AddPopup.cs:559 |  | UI_PROP | OperPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-0b9ba38d | this.btnOperation.Click | FP03033_AddPopup.cs:560 |  | UI_PROP | OperPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-a03995d6 | this.btnOperation.Click | FP03033_AddPopup.cs:561 |  | POPUP | OperPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c192e5e4 | this.btnOperation.Click | FP03033_AddPopup.cs:564 | if (OperPopup.ShowDialog() == DialogResult.OK) | VALUE_SET | txtOperation.Text | OperPopup._OperationId | 컨트롤 값 설정 |  |  |  |
| AC-1e53a766 | this.btnOperation.Click | FP03033_AddPopup.cs:565 | if (OperPopup.ShowDialog() == DialogResult.OK) | VALUE_CLEAR | txtMaterial.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP03033_AddPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9312ef5 | this.btnSql.Click | FP03033_AddPopup.cs:623 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-088c4d8b | this.btnSql.Click | FP03033_AddPopup.cs:624 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e642be0c | this.btnSql.Click | FP03033_AddPopup.cs:626 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_SELECT_ADD_POPUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-ecc85bca | this.btnSql.Click | FP03033_AddPopup.cs:627 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_MERGE_ADD_POPUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-3bd35fd3 | this.btnSql.Click | FP03033_AddPopup.cs:628 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_PANCAKE_M_BATCH_ADD") | 데이터 객체 조작/조회 |  |  |  |
| AC-fcc4bbaa | this.btnSql.Click | FP03033_AddPopup.cs:629 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_PANCAKE_CELL_M_ADD") | 데이터 객체 조작/조회 |  |  |  |
| AC-6b86e4d3 | this.btnSql.Click | FP03033_AddPopup.cs:630 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_MAXVERFLAG_ADD") | 데이터 객체 조작/조회 |  |  |  |
| AC-b8049810 | this.btnSql.Click | FP03033_AddPopup.cs:631 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP03033_AddPopup.CheckSaveDataValidation

진입점: this.btnSave.Click / popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_ADD_POPUP") ▸ if (programID == "PR_UI_FP03033_MERGE_ADD_POPUP")] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17d15cd1 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1074 | if (string.IsNullOrEmpty(txtDivision.Text.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Division value is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25707ec6 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1075 | if (string.IsNullOrEmpty(txtDivision.Text.ToString())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e82ded71 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1079 | if (string.IsNullOrEmpty(txtSite.Text.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Site value is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25903a5e | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1080 | if (string.IsNullOrEmpty(txtSite.Text.ToString())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5a5a54d5 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1084 | if (string.IsNullOrEmpty(txtPlant.Text.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Plant value is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8015e09d | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1085 | if (string.IsNullOrEmpty(txtPlant.Text.ToString())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f9b1c216 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1089 | if (string.IsNullOrEmpty(txtFactory.Text.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Factory value is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1ac94c0e | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1090 | if (string.IsNullOrEmpty(txtFactory.Text.ToString())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ab43fd1c | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1095 | if (string.IsNullOrEmpty(txtOperation.Text.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Operation value is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4d23c04f | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1096 | if (string.IsNullOrEmpty(txtOperation.Text.ToString())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e58d2254 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1101 | if (string.IsNullOrEmpty(txtModel.Text.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Model value is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d8995b7 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1102 | if (string.IsNullOrEmpty(txtModel.Text.ToString())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ac6bcfdf | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1107 | if (string.IsNullOrEmpty(txtVersion.Text.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Version value is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33d97c51 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1108 | if (string.IsNullOrEmpty(txtVersion.Text.ToString())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-43f3cef2 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1113 | if (string.IsNullOrEmpty(txtMaterial.Text.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Item value is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1e209361 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1114 | if (string.IsNullOrEmpty(txtMaterial.Text.ToString())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b2aa3e9c | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1119 | if (cboProdVerType.SelectedValue == null \|\| string.IsNullOrWhiteSpace(cboProdVerType.SelectedValue.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Conversion Type value is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9e75e5a3 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1120 | if (cboProdVerType.SelectedValue == null \|\| string.IsNullOrWhiteSpace(cboProdVerType.SelectedValue.ToString())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-02c82468 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1126 | if (cboVersionType.SelectedValue == null \|\| (cboVersionType.SelectedValue.ToString() == "TEST" && txtVersion.Text.ToString()…) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Version Type - Version not matched.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-15ad3eca | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1127 | if (cboVersionType.SelectedValue == null \|\| (cboVersionType.SelectedValue.ToString() == "TEST" && txtVersion.Text.ToString()…) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f31bfdef | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1135 | if ((cboProdVerType.SelectedValue.ToString() == "PREWET_UNIT2" && txtVersion.Text.ToString().IndexOf("P2") < 0) \|\| (cboProdV…) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Conversion Type - Version not matched.\nPREWET_UNIT2 - P2 / P… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-114aa474 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1136 | if ((cboProdVerType.SelectedValue.ToString() == "PREWET_UNIT2" && txtVersion.Text.ToString().IndexOf("P2") < 0) \|\| (cboProdV…) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6bf793f1 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1144 | if (this._sPopupFlag == "UPDATE" && txtVersion.Text.ToString() == txtLastVersion.Text.ToString() && txtVersion.Text.ToString…) | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP03033_find_Lane", txtDivision.Text, txtSite.Text, txtPlant.Text , txtF… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7fad117f | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1152 | if (this._sPopupFlag == "UPDATE" && txtVersion.Text.ToString() == txtLastVersion.Text.ToString() && txtVersion.Text.ToString…) ▸ if (dtVersi… | MESSAGE | MessageBox.Show | (sMsg, "Proceed", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-dfa4e41e | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1158 | if (this._sPopupFlag == "UPDATE" && txtVersion.Text.ToString() == txtLastVersion.Text.ToString() && txtVersion.Text.ToString…) ▸ if (dtVersi… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-435f8bd6 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1166 | if (this._sPopupFlag == "INSERT") | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP03033_find_add_dupcheck", "", txtFactory.Text, txtModel.Text , txtOper… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9be97632 | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1171 | if (this._sPopupFlag == "INSERT") ▸ if (dtdupCheck.Rows[0]["CNT"].ToString() != "0") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "There is duplicate data.\r\nCheck the version or other dates.… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-96192f2c | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1172 | if (this._sPopupFlag == "INSERT") ▸ if (dtdupCheck.Rows[0]["CNT"].ToString() != "0") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-200ec6ea | this.btnSave.Click 외 2 | FP03033_AddPopup.cs:1176 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## FP03033_AddPopup.CreateSheetDataTable

진입점: this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if (dtSheet == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b5dfd7e | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:683 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-35a4d470 | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:685 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ecb9243b | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:686 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-08b1f0d0 | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:687 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-13236aef | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:688 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe387283 | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:689 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c980423b | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:690 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MODEL_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e09c5b8 | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:691 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PJT_CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3bacecb | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:692 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9a649ef | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:693 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-45b4a5a2 | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:694 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a962ab65 | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:695 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ab34a88 | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:696 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d28bafa1 | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:697 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VALUE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc0b5a21 | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:698 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6c6d7f0 | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:699 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MAX_VER_FLAG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-431617d5 | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:700 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PROD_VERSION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-66d5ee37 | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:701 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-00405c4f | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:702 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_VERSION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-656265fc | this.Load [else of (this._sPopupFlag.Equals("UPDATE")) ▸ if … | FP03033_AddPopup.cs:704 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP03033_AddPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0bf6a52 | this.Load | FP03033_AddPopup.cs:329 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b3f0c46b | this.Load | FP03033_AddPopup.cs:330 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-da9c7068 | this.Load | FP03033_AddPopup.cs:332 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP03033_AddPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f2f6cf9 | this.Load | FP03033_AddPopup.cs:314 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP03033_AddPopup.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d312a8e | DeleteButton | FP03033_AddPopup.cs:469 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "the delete can't use.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-17e7b4b1 | DeleteButton | FP03033_AddPopup.cs:470 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP03033_AddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2fb909f | Dispose | FP03033_AddPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP03033_AddPopup.EditButton

진입점: this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f9c0a4c | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 2 | FP03033_AddPopup.cs:426 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-41aa1ded | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 2 | FP03033_AddPopup.cs:428 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-91cc78f4 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 2 | FP03033_AddPopup.cs:430 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.ELECTRODE_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-aad533fc | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 2 | FP03033_AddPopup.cs:431 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MAX_VER_FLAG), siMain.GetColumnIndex(DefColumns.ORG_VERS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fa2242da | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 2 | FP03033_AddPopup.cs:437 | if (spdMain != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.VALUE), i, siMain.GetColumnIndex(DefColumns.MARK), Sy… | 그리드 표시 설정 |  |  |  |
| AC-abf21cb2 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 2 | FP03033_AddPopup.cs:441 | if (spdMain != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.VALUE), i, siMain.GetColumnIndex(DefColumns.MARK), Sy… | 그리드 표시 설정 |  |  |  |
| AC-ed4e24c9 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 2 | FP03033_AddPopup.cs:444 | if (spdMain != null) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CATEGORY), i, siMain.GetColumnIndex(DefColumns.CATEGO… | 그리드 표시 설정 |  |  |  |
| AC-11d6f576 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 2 | FP03033_AddPopup.cs:450 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 4) ▸ if (this._sPopupFlag.Equals("UPDATE")) | GRID_LOCK | siMain.LockRange | (4, siMain.GetColumnIndex(DefColumns.CATEGORY), 5, siMain.GetColumnIndex(DefColumns.VALUE)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d0bd643b | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 2 | FP03033_AddPopup.cs:451 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 4) ▸ if (this._sPopupFlag.Equals("UPDATE")) | GRID_STYLE | siMain.SetBGColor | (4, siMain.GetColumnIndex(DefColumns.CATEGORY), 5, siMain.GetColumnIndex(DefColumns.VALUE)… | 그리드 표시 설정 |  |  |  |
| AC-6e217c1c | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 2 | FP03033_AddPopup.cs:452 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 4) ▸ if (this._sPopupFlag.Equals("UPDATE")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.CATEGORY),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f5233229 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 2 | FP03033_AddPopup.cs:456 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 4) ▸ else of (this._sPopupFlag.Equals("UPDATE")) | GRID_LOCK | siMain.LockRange | (4, siMain.GetColumnIndex(DefColumns.VALUE), 5, siMain.GetColumnIndex(DefColumns.VALUE), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f9624e65 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 2 | FP03033_AddPopup.cs:457 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 4) ▸ else of (this._sPopupFlag.Equals("UPDATE")) | GRID_STYLE | siMain.SetBGColor | (4, siMain.GetColumnIndex(DefColumns.VALUE), 5, siMain.GetColumnIndex(DefColumns.VALUE), S… | 그리드 표시 설정 |  |  |  |

## FP03033_AddPopup.Find_Data

진입점: this.Load [if (this._sPopupFlag.Equals("UPDATE"))] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8281ced | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:709 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3d4d64d7 | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:714 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-80f87a8b | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:717 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d06157a8 | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:720 | try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_Add("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-553b5056 | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:720 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Add("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-025b8a0d | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:727 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5a7477a8 | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:733 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-394bcd98 | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:739 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-93971cfd | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:749 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3ec6f08d | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:756 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a1e485b4 | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:758 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-44a3fb54 | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:760 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-1504b66c | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:768 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0292fc75 | this.Load [if (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:772 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP03033_AddPopup.Find_Data_Add

진입점: this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FP03033_SELECT_ADD_POPUP")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c9134b5 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:782 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION") ⇒ FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-515f52cf | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:783 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-074e8e8b | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:784 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_ADD_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-efb384b1 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:785 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-811a1e20 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:786 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-41df6909 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:788 | try | DATA_OP | request.Parameters["p_company_id"] | Filter["p_company_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-3ba8fd5c | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:789 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["p_division_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-0c1f1e0e | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:790 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["p_site_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-d33e8b2e | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:791 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["p_plant_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-c52bfd58 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:792 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["p_factory_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-d9705972 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:794 | try | DATA_OP | request.Parameters["p_model_id"] | Filter["p_model_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-83ddd6be | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:795 | try | DATA_OP | request.Parameters["p_pjt_code"] | Filter["p_pjt_code"] | 행/컬럼 값 대입 |  |  |  |
| AC-5be5dc3f | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:796 | try | DATA_OP | request.Parameters["p_version_type"] | Filter["p_version_type"] | 행/컬럼 값 대입 |  |  |  |
| AC-6625d124 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:797 | try | DATA_OP | request.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ff317f21 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:798 | try | DATA_OP | request.Parameters["p_prod_yn"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-83315f52 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:800 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["p_operation_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-997da749 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:801 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["p_item_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-71bf21e5 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:802 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0d0e7790 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:803 | try | DATA_OP | request.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1c979270 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:804 | try | DATA_OP | request.Parameters["p_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7663d9f3 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:806 | try | DATA_OP | request.Parameters["p_prod_ver_type"] | Filter["p_prod_ver_type"] | 행/컬럼 값 대입 |  |  |  |
| AC-f3de63ce | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:807 | try | DATA_OP | request.Parameters["p_max_version"] | Filter["p_max_version"] | 행/컬럼 값 대입 |  |  |  |
| AC-a1cb17a7 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:808 | try | DATA_OP | request.Parameters["p_mark"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f4a4c983 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:809 | try | DATA_OP | request.Parameters["p_org_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fdcaf0e3 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:810 | try | DATA_OP | request.Parameters["p_job_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-77324c50 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:812 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f707a847 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:814 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1dfd6250 | this.Load [if (this._sPopupFlag.Equals("UPDATE")) ▸ try ▸ la… 외 2 | FP03033_AddPopup.cs:819 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_AddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-130312b3 | this.Load | FP03033_AddPopup.cs:125 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3a8d730a | this.Load | FP03033_AddPopup.cs:145 | else of (this._sPopupFlag.Equals("UPDATE")) | FLAG | dsMain | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-658aee87 | this.Load | FP03033_AddPopup.cs:146 | else of (this._sPopupFlag.Equals("UPDATE")) | DATA_OP | dsMain.Tables.Add | (dtSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-63463eb3 | this.Load | FP03033_AddPopup.cs:149 | else of (this._sPopupFlag.Equals("UPDATE")) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1e69812b | this.Load | FP03033_AddPopup.cs:152 | else of (this._sPopupFlag.Equals("UPDATE")) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8dd87458 | this.Load | FP03033_AddPopup.cs:159 | else of (this._sPopupFlag.Equals("UPDATE")) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP03033_AddPopup.GetToDay

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b30d0b6d | (진입점 미연결) | FP03033_AddPopup.cs:1293 |  | RETURN | return sToDay; |  | 처리 중단/반환 |  |  |  |

## FP03033_AddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-890701b1 | this.Load | FP03033_AddPopup.cs:177 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6d213358 | this.Load | FP03033_AddPopup.cs:183 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0d953b32 | this.Load | FP03033_AddPopup.cs:184 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-98c5acb5 | this.Load | FP03033_AddPopup.cs:196 | try | FLAG | dtProdVerType | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP03033_find_ConversionType", Filt… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-479ceb49 | this.Load | FP03033_AddPopup.cs:196 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP03033_find_ConversionType", Filter["p_division_id"], Filter["p_site_id… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-59549fe1 | this.Load | FP03033_AddPopup.cs:197 | try | LIST_REBIND | clsCtrl.setListBox | (dtProdVerType, cboProdVerType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-88a9576d | this.Load | FP03033_AddPopup.cs:198 | try | VALUE_CLEAR | cboProdVerType.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-2f2d192d | this.Load | FP03033_AddPopup.cs:208 | try | FLAG | dtVersionType | HardCodeService.GetAsTableFp("FP03033_Add", "VERSION_TYPE") | 화면 필드/플래그 변경 |  |  |  |
| AC-34b2437e | this.Load | FP03033_AddPopup.cs:208 | try | CALL_EXT | HardCodeService.GetAsTableFp | ("FP03033_Add", "VERSION_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d5401872 | this.Load | FP03033_AddPopup.cs:209 | try | LIST_REBIND | clsCtrl.setListBox | (dtVersionType, cboVersionType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7d2eb1d0 | this.Load | FP03033_AddPopup.cs:210 | try | VALUE_CLEAR | cboVersionType.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-3da8ca2b | this.Load | FP03033_AddPopup.cs:214 | try ▸ if (this._sPopupFlag.Equals("UPDATE")) | VALUE_SET | cboProdVerType.SelectedValue | Filter["p_prod_ver_type"] | 컨트롤 값 설정 |  |  |  |
| AC-98419f4b | this.Load | FP03033_AddPopup.cs:215 | try ▸ if (this._sPopupFlag.Equals("UPDATE")) | VALUE_SET | cboVersionType.SelectedValue | Filter["p_version_type"] | 컨트롤 값 설정 |  |  |  |
| AC-b147f4fc | this.Load | FP03033_AddPopup.cs:219 | try | UI_PROP | lblCompany.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9dafb7e6 | this.Load | FP03033_AddPopup.cs:225 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e425d6e1 | this.Load | FP03033_AddPopup.cs:226 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-49c34552 | this.Load | FP03033_AddPopup.cs:227 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7cdbb16b | this.Load | FP03033_AddPopup.cs:234 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP03033_AddPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2c66751 | this.Load | FP03033_AddPopup.cs:344 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b9fdd23 | this.Load | FP03033_AddPopup.cs:345 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-48615715 | this.Load | FP03033_AddPopup.cs:349 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP03033_AddPopup.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7076a30 | InsertButton | FP03033_AddPopup.cs:414 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "the Insert can't use.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d88b47bb | InsertButton | FP03033_AddPopup.cs:415 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP03033_AddPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6adff06 | popSql.OnSql | FP03033_AddPopup.cs:1301 | if (programID == "PR_UI_FP03033_SELECT_ADD_POPUP") | RETURN | return Find_Data_Add("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-fb86c722 | popSql.OnSql | FP03033_AddPopup.cs:1306 | else of (programID == "PR_UI_FP03033_SELECT_ADD_POPUP") ▸ if (programID == "PR_UI_FP03033_MERGE_ADD_POPUP") ▸ if (bChk == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c27576a0 | popSql.OnSql | FP03033_AddPopup.cs:1312 | else of (programID == "PR_UI_FP03033_SELECT_ADD_POPUP") ▸ if (programID == "PR_UI_FP03033_MERGE_ADD_POPUP") | RETURN | return Save_Data_Add("SQL", "MERGE_ADD_POPUP"); |  | 처리 중단/반환 |  |  |  |
| AC-ef0e76e9 | popSql.OnSql | FP03033_AddPopup.cs:1317 | else of (programID == "PR_UI_FP03033_SELECT_ADD_POPUP") ▸ else of (programID == "PR_UI_FP03033_MERGE_ADD_POPUP") ▸ if (programID == "PR_UI_F… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-69e632d1 | popSql.OnSql | FP03033_AddPopup.cs:1323 | else of (programID == "PR_UI_FP03033_SELECT_ADD_POPUP") ▸ else of (programID == "PR_UI_FP03033_MERGE_ADD_POPUP") ▸ if (programID == "PR_UI_F… | RETURN | return Save_Data_Add("SQL", "UPDATE_PANCAKE_M_BATCH_ADD"); |  | 처리 중단/반환 |  |  |  |
| AC-10befd74 | popSql.OnSql | FP03033_AddPopup.cs:1328 | else of (programID == "PR_UI_FP03033_SELECT_ADD_POPUP") ▸ else of (programID == "PR_UI_FP03033_MERGE_ADD_POPUP") ▸ else of (programID == "PR… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-03c999a8 | popSql.OnSql | FP03033_AddPopup.cs:1334 | else of (programID == "PR_UI_FP03033_SELECT_ADD_POPUP") ▸ else of (programID == "PR_UI_FP03033_MERGE_ADD_POPUP") ▸ else of (programID == "PR… | RETURN | return Save_Data_Add("SQL", "UPDATE_PANCAKE_CELL_M_ADD"); |  | 처리 중단/반환 |  |  |  |
| AC-aa8efbf6 | popSql.OnSql | FP03033_AddPopup.cs:1339 | else of (programID == "PR_UI_FP03033_SELECT_ADD_POPUP") ▸ else of (programID == "PR_UI_FP03033_MERGE_ADD_POPUP") ▸ else of (programID == "PR… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-5f0cb89d | popSql.OnSql | FP03033_AddPopup.cs:1345 | else of (programID == "PR_UI_FP03033_SELECT_ADD_POPUP") ▸ else of (programID == "PR_UI_FP03033_MERGE_ADD_POPUP") ▸ else of (programID == "PR… | RETURN | return Save_Data_Add("SQL", "UPDATE_MAXVERFLAG_ADD"); |  | 처리 중단/반환 |  |  |  |
| AC-bd9bcc22 | popSql.OnSql | FP03033_AddPopup.cs:1347 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_AddPopup.Save_Data

진입점: this.btnSave.Click / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1efb8347 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:829 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88b73db4 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:831 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d4d60647 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:836 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-99aa3812 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:837 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-efbdffae | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:842 | if (bChk == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c4febb5 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:855 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3f9d89d2 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:862 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-15f3dcad | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:864 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-20033a45 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:865 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca50cf3c | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:879 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToStr… | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-cd1acf24 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:880 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds2.Tables[0].Rows[0][0].ToStr… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1c8c90f | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:890 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds3.Tables[0].Rows[0][0].ToStr… | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f464f03d | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:891 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds3.Tables[0].Rows[0][0].ToStr… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-298c3060 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:899 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds4.Tables[0].Rows[0][0].ToStr… | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-c1e8e0f0 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:900 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (ds4.Tables[0].Rows[0][0].ToStr… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6555c38e | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:903 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds1.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-57f2c2a3 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:906 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a31321f | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:910 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-140a1b87 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:916 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds1.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6cfce38a | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:920 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-734c2596 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:924 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-88bd20a8 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:925 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-b6de1652 | this.btnSave.Click 외 1 | FP03033_AddPopup.cs:929 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP03033_AddPopup.Save_Data_Add

진입점: this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] / popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_ADD_POPUP") ▸ if (programID == "PR_UI_FP03033_MERGE_ADD_POPUP")] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9af384a | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:971 | try ▸ if (string.IsNullOrEmpty(pSysFlag)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e3b59c13 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1020 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION") ⇒ FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-bc90ee21 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1021 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-999e76d2 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1023 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-bcfd2764 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1024 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6a1f0ce6 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1025 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-5dc42cbb | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1026 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-58e94809 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1028 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-3281e46e | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1029 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ec4f3ef | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1030 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-75a89c3e | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1031 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-3b89428d | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1032 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-8dc72dea | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1034 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-c4b85e14 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1035 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pjt_code"] | p_pjt_code | 행/컬럼 값 대입 |  |  |  |
| AC-99506a90 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1036 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-500b028e | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1037 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version"] | p_version | 행/컬럼 값 대입 |  |  |  |
| AC-ab45e6c2 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1038 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_yn"] | p_prod_yn | 행/컬럼 값 대입 |  |  |  |
| AC-784977a3 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1040 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-0800ae86 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1041 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0ce1fadf | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1042 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-7f4e928a | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1043 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-b5a76281 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1044 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_value"] | p_value | 행/컬럼 값 대입 |  |  |  |
| AC-9d27e0b1 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1046 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_ver_type"] | p_prod_ver_type | 행/컬럼 값 대입 |  |  |  |
| AC-16187947 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1047 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_max_version"] | p_max_version | 행/컬럼 값 대입 |  |  |  |
| AC-8b1076d4 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1048 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mark"] | p_mark | 행/컬럼 값 대입 |  |  |  |
| AC-b54da4fd | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1049 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_version"] | p_org_version | 행/컬럼 값 대입 |  |  |  |
| AC-e76be663 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1050 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_job_type"] | p_job_type | 행/컬럼 값 대입 |  |  |  |
| AC-89518a3d | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1052 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f960fc7c | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1053 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-37465369 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1059 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-585efa32 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP03033_AddPopup.cs:1065 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_AddPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f83cbd9f | SaveButton | FP03033_AddPopup.cs:480 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP03033_AddPopup.SetDataControlsByFilter

진입점: this.Load [try ▸ if (this._sPopupFlag.Equals("UPDATE"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-295758de | this.Load [try ▸ if (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:293 |  | VALUE_SET | txtDivision.Text | Filter["p_division_id"] | 컨트롤 값 설정 |  |  |  |
| AC-5f44590a | this.Load [try ▸ if (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:294 |  | VALUE_SET | txtSite.Text | Filter["p_site_id"] | 컨트롤 값 설정 |  |  |  |
| AC-0fc32067 | this.Load [try ▸ if (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:295 |  | VALUE_SET | txtPlant.Text | Filter["p_plant_id"] | 컨트롤 값 설정 |  |  |  |
| AC-b25a3110 | this.Load [try ▸ if (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:297 |  | VALUE_SET | txtFactory.Text | Filter["p_factory_id"] | 컨트롤 값 설정 |  |  |  |
| AC-4bf7b626 | this.Load [try ▸ if (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:298 |  | VALUE_SET | txtOperation.Text | Filter["p_operation_id"] | 컨트롤 값 설정 |  |  |  |
| AC-8ee08ea0 | this.Load [try ▸ if (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:299 |  | VALUE_SET | txtMaterial.Text | Filter["p_item_id"] | 컨트롤 값 설정 |  |  |  |
| AC-422e1fdd | this.Load [try ▸ if (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:301 |  | VALUE_SET | txtModel.Text | Filter["p_model_id"] | 컨트롤 값 설정 |  |  |  |
| AC-046f45be | this.Load [try ▸ if (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:302 |  | VALUE_SET | txtPjtCode.Text | Filter["p_pjt_code"] | 컨트롤 값 설정 |  |  |  |
| AC-824ff308 | this.Load [try ▸ if (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:304 |  | VALUE_SET | cboProdVerType.SelectedValue | Filter["p_prod_ver_type"] | 컨트롤 값 설정 |  |  |  |
| AC-46f68fad | this.Load [try ▸ if (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:305 |  | VALUE_SET | cboVersionType.SelectedValue | Filter["p_version_type"] | 컨트롤 값 설정 |  |  |  |
| AC-ce193d55 | this.Load [try ▸ if (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:307 |  | VALUE_SET | txtVersion.Text | Filter["p_version"] | 컨트롤 값 설정 |  |  |  |
| AC-186715a8 | this.Load [try ▸ if (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:308 |  | VALUE_SET | txtLastVersion.Text | Filter["p_version"] | 컨트롤 값 설정 |  |  |  |

## FP03033_AddPopup.SetEnabledControls

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdc6da4b | this.Load [try] | FP03033_AddPopup.cs:242 | if (sFormFlag.Equals("UPDATE")) | STATE | txtDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-838221a8 | this.Load [try] | FP03033_AddPopup.cs:243 | if (sFormFlag.Equals("UPDATE")) | STATE | txtSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-189ac3d6 | this.Load [try] | FP03033_AddPopup.cs:244 | if (sFormFlag.Equals("UPDATE")) | STATE | txtPlant.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-993723ee | this.Load [try] | FP03033_AddPopup.cs:246 | if (sFormFlag.Equals("UPDATE")) | STATE | txtFactory.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e19d44b7 | this.Load [try] | FP03033_AddPopup.cs:247 | if (sFormFlag.Equals("UPDATE")) | STATE | btnFactory.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6fd43850 | this.Load [try] | FP03033_AddPopup.cs:249 | if (sFormFlag.Equals("UPDATE")) | STATE | txtOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-29b53b01 | this.Load [try] | FP03033_AddPopup.cs:250 | if (sFormFlag.Equals("UPDATE")) | STATE | btnOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3ca6e6ba | this.Load [try] | FP03033_AddPopup.cs:252 | if (sFormFlag.Equals("UPDATE")) | STATE | txtMaterial.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b1fab9ea | this.Load [try] | FP03033_AddPopup.cs:253 | if (sFormFlag.Equals("UPDATE")) | STATE | btnMaterial.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-00b87cd4 | this.Load [try] | FP03033_AddPopup.cs:255 | if (sFormFlag.Equals("UPDATE")) | STATE | txtModel.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-230ee60b | this.Load [try] | FP03033_AddPopup.cs:256 | if (sFormFlag.Equals("UPDATE")) | STATE | txtPjtCode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e79be89d | this.Load [try] | FP03033_AddPopup.cs:258 | if (sFormFlag.Equals("UPDATE")) | STATE | cboProdVerType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-66a1c515 | this.Load [try] | FP03033_AddPopup.cs:259 | if (sFormFlag.Equals("UPDATE")) | STATE | cboVersionType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8ac5bb50 | this.Load [try] | FP03033_AddPopup.cs:261 | if (sFormFlag.Equals("UPDATE")) | STATE | txtVersion.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-13db9f87 | this.Load [try] | FP03033_AddPopup.cs:262 | if (sFormFlag.Equals("UPDATE")) | STATE | txtLastVersion.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5f449c65 | this.Load [try] | FP03033_AddPopup.cs:266 | else of (sFormFlag.Equals("UPDATE")) | STATE | txtDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a394eaa0 | this.Load [try] | FP03033_AddPopup.cs:267 | else of (sFormFlag.Equals("UPDATE")) | STATE | txtSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-07ddffb6 | this.Load [try] | FP03033_AddPopup.cs:268 | else of (sFormFlag.Equals("UPDATE")) | STATE | txtPlant.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c1412d15 | this.Load [try] | FP03033_AddPopup.cs:270 | else of (sFormFlag.Equals("UPDATE")) | STATE | txtFactory.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c2148526 | this.Load [try] | FP03033_AddPopup.cs:271 | else of (sFormFlag.Equals("UPDATE")) | STATE | btnFactory.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-523b5827 | this.Load [try] | FP03033_AddPopup.cs:273 | else of (sFormFlag.Equals("UPDATE")) | STATE | txtOperation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-754b1c97 | this.Load [try] | FP03033_AddPopup.cs:274 | else of (sFormFlag.Equals("UPDATE")) | STATE | btnOperation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cd38a123 | this.Load [try] | FP03033_AddPopup.cs:276 | else of (sFormFlag.Equals("UPDATE")) | STATE | txtMaterial.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-03c3e005 | this.Load [try] | FP03033_AddPopup.cs:277 | else of (sFormFlag.Equals("UPDATE")) | STATE | btnMaterial.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-78fe9a86 | this.Load [try] | FP03033_AddPopup.cs:279 | else of (sFormFlag.Equals("UPDATE")) | STATE | txtModel.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6063dba1 | this.Load [try] | FP03033_AddPopup.cs:280 | else of (sFormFlag.Equals("UPDATE")) | STATE | txtPjtCode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7c58ff8f | this.Load [try] | FP03033_AddPopup.cs:282 | else of (sFormFlag.Equals("UPDATE")) | STATE | cboProdVerType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-104398a7 | this.Load [try] | FP03033_AddPopup.cs:283 | else of (sFormFlag.Equals("UPDATE")) | STATE | cboVersionType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fb9fb300 | this.Load [try] | FP03033_AddPopup.cs:284 | else of (sFormFlag.Equals("UPDATE")) | STATE | txtVersion.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-046eb3c2 | this.Load [try] | FP03033_AddPopup.cs:286 | else of (sFormFlag.Equals("UPDATE")) | STATE | txtLastVersion.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP03033_AddPopup.SetHiddenColmn

진입점: this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d458987 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:382 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e9d9f511 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:383 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3aa9492d | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:384 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ae988a0a | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:385 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLANT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a3cc558e | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:386 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FACTORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5ef821ed | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:387 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MODEL_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ea273870 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:388 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PJT_CODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-88ce9d16 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:389 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.VERSION)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-80532413 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:390 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.OPERATION)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7515f46e | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:391 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ITEM_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-34b2c0ec | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:392 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3db4f330 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:393 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MAX_VER_FLAG)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-75833a18 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:394 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROD_VERSION_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d5959d35 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:395 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.VERSION_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6fd758c3 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] 외 1 | FP03033_AddPopup.cs:396 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ORG_VERSION)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP03033_AddPopup.SetInitSheetData

진입점: this.Load [else of (this._sPopupFlag.Equals("UPDATE"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e77ceb4 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:642 | if (dtSheet == null) | FLAG | dtSheet | CreateSheetDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-b164cb58 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:644 |  | DATA_OP | dtSheet.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-93ca0225 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:645 |  | DATA_OP | dtSheet.Rows.Add | (new object[] { "", "", "", "", "", "", "", "", "", "", "", "cell/batch", "", "", "", "", … | 데이터 객체 조작/조회 |  |  |  |
| AC-7dfce9f5 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:646 |  | DATA_OP | dtSheet.Rows.Add | (new object[] { "", "", "", "", "", "", "", "", "", "", "", "Jumbo Roll (cell/m)", "", "",… | 데이터 객체 조작/조회 |  |  |  |
| AC-e725a9aa | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:647 |  | DATA_OP | dtSheet.Rows.Add | (new object[] { "", "", "", "", "", "", "", "", "", "", "", "Jumbo Roll (m/batch)", "", ""… | 데이터 객체 조작/조회 |  |  |  |
| AC-2f5befe9 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:648 |  | DATA_OP | dtSheet.Rows.Add | (new object[] { "", "", "", "", "", "", "", "", "", "", "", "Lane Number", "", "", "", "",… | 데이터 객체 조작/조회 |  |  |  |
| AC-7b10a31b | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:649 |  | DATA_OP | dtSheet.Rows.Add | (new object[] { "", "", "", "", "", "", "", "", "", "", "", "Pancake (cell/m)", "", "", ""… | 데이터 객체 조작/조회 |  |  |  |
| AC-cce72cf7 | this.Load [else of (this._sPopupFlag.Equals("UPDATE"))] | FP03033_AddPopup.cs:650 |  | DATA_OP | dtSheet.Rows.Add | (new object[] { "", "", "", "", "", "", "", "", "", "", "", "Pancake (m/batch)", "", "", "… | 데이터 객체 조작/조회 |  |  |  |

## FP03033_AddPopup.SetSheetDataByControl

진입점: this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] / popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_ADD_POPUP") ▸ if (programID == "PR_UI_FP03033_MERGE_ADD_POPUP") ▸ if (this._sPopupFlag.Equals("INSERT"))] / SaveButton [if (this._sPopupFlag.Equals("INSERT"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a4b44e3 | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:655 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cced5eae | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:660 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.COMPANY_ID), txtCompany.Text) | 그리드 값 설정 |  |  |  |
| AC-30667d4d | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:661 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), txtDivision.Text) | 그리드 값 설정 |  |  |  |
| AC-e3f89e55 | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:662 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.SITE_ID), txtSite.Text) | 그리드 값 설정 |  |  |  |
| AC-b615bfb5 | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:663 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.PLANT_ID), txtPlant.Text) | 그리드 값 설정 |  |  |  |
| AC-bc989933 | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:664 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.FACTORY_ID), txtFactory.Text) | 그리드 값 설정 |  |  |  |
| AC-1db546e3 | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:666 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.MODEL_ID), txtModel.Text) | 그리드 값 설정 |  |  |  |
| AC-516df9c9 | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:667 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.PJT_CODE), txtPjtCode.Text) | 그리드 값 설정 |  |  |  |
| AC-a6b92ce5 | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:668 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.VERSION_TYPE), cboVersionType.SelectedValue) | 그리드 값 설정 |  |  |  |
| AC-507dc40f | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:669 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.VERSION), txtVersion.Text) | 그리드 값 설정 |  |  |  |
| AC-496027b0 | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:671 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.OPERATION), txtOperation.Text) | 그리드 값 설정 |  |  |  |
| AC-2c250fb5 | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:672 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.ITEM_ID), txtMaterial.Text) | 그리드 값 설정 |  |  |  |
| AC-d09e9ca3 | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:673 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-eebaa2d9 | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:675 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.PROD_VERSION_TYPE), cboProdVerType.SelectedValue) | 그리드 값 설정 |  |  |  |
| AC-0c4ba6a2 | this.btnSave.Click [if (this._sPopupFlag.Equals("INSERT"))] 외 2 | FP03033_AddPopup.cs:677 | for (i < siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.ORG_VERSION), txtVersion.Text) | 그리드 값 설정 |  |  |  |

## FP03033_AddPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffc6980c | this.Load [try] | FP03033_AddPopup.cs:358 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e3086d9 | this.Load [try] | FP03033_AddPopup.cs:359 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-eae6719d | this.Load [try] | FP03033_AddPopup.cs:364 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-c708a76e | this.Load [try] | FP03033_AddPopup.cs:365 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP03033_AddPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a4c3425 | this.spdMain.CellClick | FP03033_AddPopup.cs:1218 | if (sCategory.Equals("Lane Number") && e.Column == siMain.GetColumnIndex(DefColumns.VALUE)) | CALL_EXT | siMain.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4eec7c2e | this.spdMain.CellClick | FP03033_AddPopup.cs:1220 | if (sCategory.Equals("Lane Number") && e.Column == siMain.GetColumnIndex(DefColumns.VALUE)) | CALL_EXT | siMain.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fef98588 | this.spdMain.CellClick | FP03033_AddPopup.cs:1245 | if (sCategory.Equals("Lane Number") && e.Column == siMain.GetColumnIndex(DefColumns.VALUE)) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visi… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Select Conversion Type is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1c66192e | this.spdMain.CellClick | FP03033_AddPopup.cs:1246 | if (sCategory.Equals("Lane Number") && e.Column == siMain.GetColumnIndex(DefColumns.VALUE)) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visi… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-313730a5 | this.spdMain.CellClick | FP03033_AddPopup.cs:1257 | if (sCategory.Equals("Lane Number") && e.Column == siMain.GetColumnIndex(DefColumns.VALUE)) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visi… | FLAG | dtLaneNumber | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP03033_find_Lane", pDivision, pSite, pP… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4e346e8d | this.spdMain.CellClick | FP03033_AddPopup.cs:1257 | if (sCategory.Equals("Lane Number") && e.Column == siMain.GetColumnIndex(DefColumns.VALUE)) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visi… | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP03033_find_Lane", pDivision, pSite, pPlant, pFactory, pItem, pProdVerT… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4cb82d5c | this.spdMain.CellClick | FP03033_AddPopup.cs:1259 | if (sCategory.Equals("Lane Number") && e.Column == siMain.GetColumnIndex(DefColumns.VALUE)) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visi… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.VALUE), dtLaneNumber) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## FP03033_AddPopup.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-284823fa | this.spdMain.Change | FP03033_AddPopup.cs:1272 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALUE)) ▸ if (pValue.IndexOf("-") != -1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "There can't input minus(-) data.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a653adbf | this.spdMain.Change | FP03033_AddPopup.cs:1273 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALUE)) ▸ if (pValue.IndexOf("-") != -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP03033_ImportExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c24c7b2 | .ctor | FP03033_ImportExcelPopup.cs:115 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cedae838 | .ctor | FP03033_ImportExcelPopup.cs:118 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-d0a9551d | .ctor | FP03033_ImportExcelPopup.cs:119 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP03033_ImportExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d195aeca | this.btnClose.Click | FP03033_ImportExcelPopup.cs:830 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP03033_ImportExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69aac2a3 | this.btnDownload.Click | FP03033_ImportExcelPopup.cs:814 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-5e1aa51c | this.btnDownload.Click | FP03033_ImportExcelPopup.cs:815 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP03033_ImportExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d030ba81 | this.btnFind.Click | FP03033_ImportExcelPopup.cs:809 |  | ENDPOINT | FindData | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## FP03033_ImportExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3402460 | this.Load | FP03033_ImportExcelPopup.cs:162 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-75d80fd1 | this.Load | FP03033_ImportExcelPopup.cs:163 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-113ace20 | this.Load | FP03033_ImportExcelPopup.cs:164 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP03033_ImportExcelPopup.DefaultLineCheck

진입점: this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ if (DoDefaultLineCheck)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6be990e | this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName… | FP03033_ImportExcelPopup.cs:798 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-45d4364d | this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName… | FP03033_ImportExcelPopup.cs:798 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP03033_ImportExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffdfde48 | this.Load | FP03033_ImportExcelPopup.cs:157 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP03033_ImportExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa307b92 | Dispose | FP03033_ImportExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP03033_ImportExcelPopup.Find_Data

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45f8f8b7 | this.Load 외 1 | FP03033_ImportExcelPopup.cs:233 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-363d9896 | this.Load 외 1 | FP03033_ImportExcelPopup.cs:236 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3535e428 | this.Load 외 1 | FP03033_ImportExcelPopup.cs:239 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Import() ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5eb288ae | this.Load 외 1 | FP03033_ImportExcelPopup.cs:246 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-41811db8 | this.Load 외 1 | FP03033_ImportExcelPopup.cs:248 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-40e109be | this.Load 외 1 | FP03033_ImportExcelPopup.cs:254 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f386703a | this.Load 외 1 | FP03033_ImportExcelPopup.cs:255 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-840aadfe | this.Load 외 1 | FP03033_ImportExcelPopup.cs:260 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5333c1f3 | this.Load 외 1 | FP03033_ImportExcelPopup.cs:264 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP03033_ImportExcelPopup.Find_Data_Import

진입점: this.Load [try ▸ lambda] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2448ab1c | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:302 | if (OnSearchData == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-b5c7896c | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:303 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-2c8431e0 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:303 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-981f4f9d | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:310 | try ▸ if (OnSearchData != null) | CALL_BASE | this.Invoke | (new Action(delegate () { this.hasError = false; this.IsExcelChanged = false; //this.Enabl… | ⚠ 의미 확인 필요 |  |  |  |
| AC-3432a17c | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:312 | try ▸ if (OnSearchData != null) ▸ lambda | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-036047e0 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:313 | try ▸ if (OnSearchData != null) ▸ lambda | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-62be60df | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:315 | try ▸ if (OnSearchData != null) ▸ lambda | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d3ba73e5 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:316 | try ▸ if (OnSearchData != null) ▸ lambda | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1c0d4490 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:317 | try ▸ if (OnSearchData != null) ▸ lambda | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-96a2b7a9 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:318 | try ▸ if (OnSearchData != null) ▸ lambda | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f4909e30 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:319 | try ▸ if (OnSearchData != null) ▸ lambda | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6b8009f2 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:320 | try ▸ if (OnSearchData != null) ▸ lambda | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fb998804 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:324 | try ▸ if (OnSearchData != null) ▸ lambda ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0618bb5a | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:327 | try ▸ if (OnSearchData != null) ▸ lambda | CALL_BASE | OnSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-356de5e4 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:336 | try ▸ if (OnSearchData != null) ▸ lambda ▸ else of (dsSet == null) | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, dsSet, ColumnWidth, ColumnTitle, KeyColumns, A… | 화면 필드/플래그 변경 |  |  |  |
| AC-31d0668c | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:336 | try ▸ if (OnSearchData != null) ▸ lambda ▸ else of (dsSet == null) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsSet, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK) | 그리드 재구성/초기화 |  |  |  |
| AC-a4923d1e | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:341 | try ▸ if (OnSearchData != null) ▸ lambda ▸ else of (dsSet == null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-d7180f1f | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:342 | try ▸ if (OnSearchData != null) ▸ lambda ▸ else of (dsSet == null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-fe8e0c36 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:343 | try ▸ if (OnSearchData != null) ▸ lambda ▸ else of (dsSet == null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-9a6e8038 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:347 | try ▸ if (OnSearchData != null) ▸ lambda ▸ else of (dsSet == null) ▸ if (dsSet != null && dsSet.Tables != null && dsSet.Tables.Count > 0) | DATA_OP | dsSet.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-149adb17 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:355 | try | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-25400688 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:358 | try ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b7c07f86 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:359 | try ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-31f70432 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:360 | try ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9f9b94e8 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:361 | try ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fccfd565 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:362 | try ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7d2958f9 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:363 | try ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ea831777 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:366 | try | RETURN | return dsSet; |  | 처리 중단/반환 |  |  |  |
| AC-2031e6d1 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:371 | catch ((Exception e)) | MESSAGE | MessageBox.Show | ( e.Message) | 메시지 표시 |  |  |  |
| AC-9d128744 | this.Load [try ▸ lambda] 외 1 | FP03033_ImportExcelPopup.cs:372 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_ImportExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0fd218c | this.Load | FP03033_ImportExcelPopup.cs:127 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c31a6abd | this.Load | FP03033_ImportExcelPopup.cs:129 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP03033_ImportExcelPopup.GetExcelFileName

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96df3ac2 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:570 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-8a6b6248 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:571 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-cd66c166 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:572 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-f44c60dc | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:573 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-862eba60 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:574 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-dac5ab5b | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:575 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-6abd30b0 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:576 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0f1d4794 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:578 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-4e931b77 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:579 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-6bb460e9 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:583 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-b63e564e | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:584 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP03033_ImportExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3362ba8c | this.Load | FP03033_ImportExcelPopup.cs:174 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb1c9df9 | this.Load | FP03033_ImportExcelPopup.cs:175 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP03033_ImportExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d32422fa | (진입점 미연결) | FP03033_ImportExcelPopup.cs:195 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP03033_ImportExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16ff26f5 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:594 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6bf465fc | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:596 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-93bb7867 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:597 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a345a7be | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:598 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE_RESET | KeyColumnList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b1574baa | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:603 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (KeyColumns != null) ▸ foreach (string keycolumn i… | DATA_OP | KeyColumnList.Add | (keycolumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-a812ef2a | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:608 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (DictColumn == null \|\| DictColumn.Count < 1) | MESSAGE | MessageBox.Show | ("There's no data to display", "Excel Import", MessageBoxButtons.OK, MessageBoxIcon.Inform… | 메시지 표시 |  |  |  |
| AC-6339fa70 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:609 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (DictColumn == null \|\| DictColumn.Count < 1) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-96502842 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:620 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d97e813e | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:624 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-10d69954 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:627 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | STATE | xlApp.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-34429f0e | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:628 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_PROP | xlApp.DisplayAlerts | false | 속성 DisplayAlerts 설정 |  |  |  |
| AC-7ecc51de | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:630 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlApp.Workbooks.Open | (FileName, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value , Mis… | ⚠ 의미 확인 필요 |  |  |  |
| AC-74b4e9e0 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:649 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlRange.get_Value | (Type.Missing) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2b3a49e | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:656 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iRCnt < 2 \|\| iCCnt < DictColumn.Count) | MESSAGE | MessageBox.Show | ("There's no data to display", "Excel Import", MessageBoxButtons.OK, MessageBoxIcon.Inform… | 메시지 표시 |  |  |  |
| AC-a0a48f6f | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:657 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iRCnt < 2 \|\| iCCnt < DictColumn.Count) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4a7ba589 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:680 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iFR == 0 \|\| iFC == 0) | MESSAGE | MessageBox.Show | ("Please check your excel file where should use same column and order as orignal file", "E… | 메시지 표시 |  |  |  |
| AC-42fbc7da | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:681 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iFR == 0 \|\| iFC == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-bfb0a3e4 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:691 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (main != null) | DATA_OP | main.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f482ce3b | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:710 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) | DATA_OP | excelData.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c2984646 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:717 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ for (j < iFC + DictColumn… | DATA_OP | row[j - iFC] | each_cell_value | 행/컬럼 값 대입 |  |  |  |
| AC-4f87ef47 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:726 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ if (this.DoLineCheck != n… | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-46deec53 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:730 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) | DATA_OP | excelData.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-429067cf | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:735 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | GRID_BIND | siMain.Query | (excelDataSet, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e2151663 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:749 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (excelDataSet != null && excelDataSet.Tables… | CALL_EXT | siMain.SetRowColor | (k, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc882483 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:750 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (excelDataSet != null && excelDataSet.Tables… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5314f737 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:768 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iSaveCnt == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c33e67f0 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:774 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-823abd88 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:778 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-4c1bc13c | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:783 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | CALL_EXT | xlApp.Quit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cbfc1a02 | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:784 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2095f73c | this.btnUpload.Click | FP03033_ImportExcelPopup.cs:789 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP03033_ImportExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b566cb36 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:384 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-52efa646 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:385 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61c095a2 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:389 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-010dd4e1 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:390 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-795672fe | this.btnSave.Click | FP03033_ImportExcelPopup.cs:393 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-7cecaeaa | this.btnSave.Click | FP03033_ImportExcelPopup.cs:393 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a18546f | this.btnSave.Click | FP03033_ImportExcelPopup.cs:402 | if (OnExcelSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-03cda6d2 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:403 | if (OnExcelSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4a77ef41 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:404 | if (OnExcelSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-28365d27 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:405 | if (OnExcelSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-beb49254 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:406 | if (OnExcelSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e7805cc8 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:407 | if (OnExcelSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4c8ad939 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:415 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-cc471114 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:416 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c7094760 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:417 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e20a9648 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:418 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ed069e5c | this.btnSave.Click | FP03033_ImportExcelPopup.cs:419 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4ee6f5b1 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:420 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e5c9e147 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:421 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-50425dce | this.btnSave.Click | FP03033_ImportExcelPopup.cs:422 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12d7634d | this.btnSave.Click | FP03033_ImportExcelPopup.cs:427 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6a4cef0 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:430 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0bb56a5 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:432 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc62b0b1 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:435 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-5feda9b9 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:440 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-aa66131f | this.btnSave.Click | FP03033_ImportExcelPopup.cs:441 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-6d5f5ba1 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:448 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | CALL_BASE | OnValidationSaveData | (dsMain, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-693a63c9 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:475 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) | CALL_BASE | OnExcelSaveData | (dsMain, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3740279e | this.btnSave.Click | FP03033_ImportExcelPopup.cs:486 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsMain.Tables[0].Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7cfe4e2d | this.btnSave.Click | FP03033_ImportExcelPopup.cs:488 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-a4fe5b7e | this.btnSave.Click | FP03033_ImportExcelPopup.cs:493 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-d157caa9 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:494 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-94ad0933 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:500 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-d2edfc0b | this.btnSave.Click | FP03033_ImportExcelPopup.cs:537 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-5ed6ea76 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:539 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-79e8e0c7 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:540 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6c67f08c | this.btnSave.Click | FP03033_ImportExcelPopup.cs:550 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-02a69958 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:551 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-eafe8610 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:555 | if (OnExcelSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-50692381 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:556 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c79adc0b | this.btnSave.Click | FP03033_ImportExcelPopup.cs:557 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8e884c8d | this.btnSave.Click | FP03033_ImportExcelPopup.cs:558 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8a4a4ee1 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:559 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e0581546 | this.btnSave.Click | FP03033_ImportExcelPopup.cs:560 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP03033_ImportExcelPopup.SetColorColumns

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3051554 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP03033_ImportExcelPopup.cs:276 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-0d0131cb | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP03033_ImportExcelPopup.cs:280 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i % 2 == 1) | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-42876d9b | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP03033_ImportExcelPopup.cs:281 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, 13, i, 13, System.Drawing.Color.FromArgb(255, 230, 170)) | 그리드 표시 설정 |  |  |  |
| AC-ae04b0bd | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP03033_ImportExcelPopup.cs:282 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, 15, i, 15, System.Drawing.Color.FromArgb(255, 230, 170)) | 그리드 표시 설정 |  |  |  |
| AC-bc505258 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP03033_ImportExcelPopup.cs:286 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (i % 2 == 1) | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-cd1cdc30 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP03033_ImportExcelPopup.cs:287 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, 13, i, 13, System.Drawing.Color.FromArgb(255, 255, 170)) | 그리드 표시 설정 |  |  |  |
| AC-f2e6803b | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP03033_ImportExcelPopup.cs:288 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, 15, i, 15, System.Drawing.Color.FromArgb(255, 255, 170)) | 그리드 표시 설정 |  |  |  |
| AC-aa510f9b | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP03033_ImportExcelPopup.cs:293 | if (siMain.GetMaxRowIndex() > 0) | GRID_STYLE | siMain.SetBGColor | (0, 0, siMain.GetMaxRowIndex(), 12, System.Drawing.Color.FromArgb(240, 248, 255)) | 그리드 표시 설정 |  |  |  |

## FP03033_ImportExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd1911be | this.Load | FP03033_ImportExcelPopup.cs:187 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d70e83ac | this.Load | FP03033_ImportExcelPopup.cs:188 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP03033_ImportExcelSubPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5098eb9a | .ctor | FP03033_ImportExcelSubPopup.cs:136 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-de389e39 | .ctor | FP03033_ImportExcelSubPopup.cs:137 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP03033_ImportExcelSubPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f1163a7 | this.btnClose.Click | FP03033_ImportExcelSubPopup.cs:841 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP03033_ImportExcelSubPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d063768 | this.btnDownload.Click | FP03033_ImportExcelSubPopup.cs:812 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-c0c5910e | this.btnDownload.Click | FP03033_ImportExcelSubPopup.cs:813 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP03033_ImportExcelSubPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-978849b7 | this.btnSave.Click | FP03033_ImportExcelSubPopup.cs:835 | if (IsExcelChanged) ▸ if (!error && !this.hasError) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |

## FP03033_ImportExcelSubPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-294bbe71 | this.Load | FP03033_ImportExcelSubPopup.cs:172 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, ColumnHeaderCount, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bb887f7c | this.Load | FP03033_ImportExcelSubPopup.cs:173 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f464f44 | this.Load | FP03033_ImportExcelSubPopup.cs:174 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP03033_ImportExcelSubPopup.DefaultLineCheck

진입점: this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ if (DoDefaultLineCheck)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49bbfb3b | this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName… | FP03033_ImportExcelSubPopup.cs:780 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f224062 | this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName… | FP03033_ImportExcelSubPopup.cs:780 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP03033_ImportExcelSubPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7444918f | this.Load | FP03033_ImportExcelSubPopup.cs:167 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP03033_ImportExcelSubPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9716b514 | Dispose | FP03033_ImportExcelSubPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP03033_ImportExcelSubPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36e35ddf | FindButton | FP03033_ImportExcelSubPopup.cs:206 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-92d4faff | FindButton | FP03033_ImportExcelSubPopup.cs:207 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-88a29100 | FindButton | FP03033_ImportExcelSubPopup.cs:209 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP03033_ImportExcelSubPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5453507 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:242 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ebc2bc6 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:243 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-f6757178 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:243 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b0bc78e | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:247 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-00e8ea05 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:248 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7896093b | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:250 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6f266660 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:251 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-be729fb4 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:252 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-253256b0 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:253 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7c6bc01b | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:254 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8596ede5 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:255 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-51e6b9bc | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:262 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-74f6e607 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:265 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1692e7b2 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:266 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = true; if (init) { if (set.Good() && !set.Tables… | ⚠ 의미 확인 필요 |  |  |  |
| AC-95d3a4a3 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:272 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0a84c69 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:273 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (set.Good() && !set.Tables[0].Columns.Contains("MESSAGE")) | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-88052168 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:274 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-e8d7cf62 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:274 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, ColumnBgColor,2,true,60) | 그리드 재구성/초기화 |  |  |  |
| AC-59da9ff5 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:280 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-48928685 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:281 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-06aae9af | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:282 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-c0f6bcea | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:286 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-620b0c56 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:293 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string, string> col in DictColumn) ▸ if (bg_color.Good() && bg_color!= Colo… | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(col.Key) , set.Tables[0].Rows.Count - 1, siMain.GetColumnIndex(c… | 그리드 표시 설정 |  |  |  |
| AC-abd1c5a6 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:298 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string, string> col in DictColumn) ▸ if (fore_color.Good() && fore_color !=… | GRID_STYLE | siMain.SetFGColor | (0, siMain.GetColumnIndex(col.Key) , set.Tables[0].Rows.Count - 1, siMain.GetColumnIndex(c… | 그리드 표시 설정 |  |  |  |
| AC-413f19cb | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:301 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-86d18bf3 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:310 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a3c41eb | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:313 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e0892ee3 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:314 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9da5eb0f | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:315 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-23fbe8d2 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:316 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-69937864 | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:317 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-715bde2d | this.Load 외 2 | FP03033_ImportExcelSubPopup.cs:318 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP03033_ImportExcelSubPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47f2d307 | this.Load | FP03033_ImportExcelSubPopup.cs:145 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a0218a41 | this.Load | FP03033_ImportExcelSubPopup.cs:147 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP03033_ImportExcelSubPopup.GetExcelFileName

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bb834e8 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:548 | try | FLAG | FileName | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-f467b1bf | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:549 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-52073c4c | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:550 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-faafec19 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:551 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-a67709fb | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:552 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-c7965713 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:553 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-bad82393 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:554 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-1b3905ac | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:555 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-92b2b97c | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:557 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-534f6e70 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:558 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-33a5ae5c | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:562 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-e14cc6c4 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:563 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP03033_ImportExcelSubPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d8ffa98 | this.Load | FP03033_ImportExcelSubPopup.cs:184 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d83a8cc4 | this.Load | FP03033_ImportExcelSubPopup.cs:185 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP03033_ImportExcelSubPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a95eb2a | (진입점 미연결) | FP03033_ImportExcelSubPopup.cs:197 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP03033_ImportExcelSubPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eed4bf7a | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:573 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6477f979 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:575 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4b034153 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:576 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b9c3895b | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:577 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE_RESET | KeyColumnList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1395529d | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:582 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (KeyColumns != null) ▸ foreach (string keycolumn i… | DATA_OP | KeyColumnList.Add | (keycolumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-e470e5a3 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:587 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (DictColumn == null \|\| DictColumn.Count < 1) | MESSAGE | MessageBox.Show | ("There's no data to display", "Excel Import", MessageBoxButtons.OK, MessageBoxIcon.Inform… | 메시지 표시 |  |  |  |
| AC-611ddef9 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:588 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (DictColumn == null \|\| DictColumn.Count < 1) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-46c4f43e | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:599 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-eb65ee75 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:603 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d1e89fca | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:606 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | STATE | xlApp.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-abca0545 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:607 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_PROP | xlApp.DisplayAlerts | false | 속성 DisplayAlerts 설정 |  |  |  |
| AC-9ad20add | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:609 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlApp.Workbooks.Open | (FileName, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value , Mis… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4d5801e | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:628 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlRange.get_Value | (Type.Missing) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5eb4057a | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:635 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iRCnt < 2 \|\| iCCnt < DictColumn.Count) | MESSAGE | MessageBox.Show | ("There's no data to display", "Excel Import", MessageBoxButtons.OK, MessageBoxIcon.Inform… | 메시지 표시 |  |  |  |
| AC-b5148794 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:636 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iRCnt < 2 \|\| iCCnt < DictColumn.Count) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2dfba9c0 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:659 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iFR == 0 \|\| iFC == 0) | MESSAGE | MessageBox.Show | ("Please check your excel file where should use same column and order as orignal file", "E… | 메시지 표시 |  |  |  |
| AC-17721910 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:660 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iFR == 0 \|\| iFC == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8633ae70 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:670 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (main != null) | DATA_OP | main.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a20b1dc0 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:679 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | DATA_OP | excelData.Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9ea945a | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:680 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (!excelData.Columns.Contains("MESSAGE")) | DATA_OP | excelData.Columns.Add | (new DataColumn("MESSAGE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb904412 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:691 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) | DATA_OP | excelData.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fbc12532 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:699 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ for (j < iFC + DictColumn… | DATA_OP | row[j - iFC] | each_cell_value | 행/컬럼 값 대입 |  |  |  |
| AC-293a6e0b | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:708 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ if (this.DoLineCheck != n… | CALL_BASE | DoLineCheck | (row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f6168882 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:712 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) | DATA_OP | excelData.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1fb6fc9 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:717 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | GRID_BIND | siMain.Query | (excelDataSet, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fe092d85 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:731 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (excelDataSet != null && excelDataSet.Tables… | CALL_EXT | siMain.SetRowColor | (k, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-96803f8f | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:732 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (excelDataSet != null && excelDataSet.Tables… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-88de78e0 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:750 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iSaveCnt == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-414e1031 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:756 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-462a4aa5 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:760 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-faa3ce53 | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:765 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | CALL_EXT | xlApp.Quit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d5d9a3ad | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:766 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9164be2b | this.btnUpload.Click | FP03033_ImportExcelSubPopup.cs:771 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP03033_ImportExcelSubPopup.SaveToDB

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f676767 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:330 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("Not Modified") | 메시지 표시 |  |  |  |
| AC-097210d6 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:331 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-614a8ede | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:335 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-a6161e92 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:336 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-371e0214 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:340 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-aa29668e | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:340 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3eea4ea4 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:345 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d08419e2 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:346 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-40075aee | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:347 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fe52872d | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:348 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f89da7df | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:349 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-38016c8d | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:350 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c5caa3e3 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:358 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-746f7ed7 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:361 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) ▸ if (!main.Tables[0].Columns.Contains("USER_ID")) | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c9f2dcb | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:363 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-a8c35670 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:366 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) ▸ if (!main.Tables[0].Columns.Contains("JOB_ORDER")) | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-cee1093f | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:371 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-3e601b2e | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:372 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-d8ee3b23 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:379 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-1bdc9bec | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:380 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8e6c8334 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:381 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-db3578bd | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:382 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4f877a3d | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:383 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-19afb64e | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:384 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ee20ab91 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:385 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-24bc129f | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:386 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f948e64 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:392 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7fb55202 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:428 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (validation.Good()) | CALL_BASE | DoSaveData | (validation) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6077401 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:432 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ else of (validation.Good()) | CALL_BASE | DoSaveData | (main) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5be3e71b | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:444 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("result_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-2d551f1f | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:447 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c5eeef0 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:450 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-73cf1b47 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:455 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-21259a0c | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:459 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-ec3a85b7 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:460 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d6fa516c | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:464 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Data saved.")) | 메시지 표시 |  |  |  |
| AC-37f8ecb4 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:465 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-8a1c04a2 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:466 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-b63bfd94 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:471 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-7318e322 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:476 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) | FLAG | IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ee263b6e | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:488 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-bb0cff54 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:489 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") | CALL_EXT | siMain.SetRowColor | (fail_count, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1426269 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:491 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b43c53e3 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:527 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4c1d0223 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:528 | if (DoSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-83a5c65e | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:532 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b6ab8f40 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:533 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7ebd48a4 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:534 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6ea610f2 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:535 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5310926f | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:536 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4b0ee1c2 | this.btnSave.Click [try] | FP03033_ImportExcelSubPopup.cs:537 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP03033_ImportExcelSubPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c530ed0 | this.Load | FP03033_ImportExcelSubPopup.cs:191 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f7a8654c | this.Load | FP03033_ImportExcelSubPopup.cs:192 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP03033_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c68fd9b2 | this.btnButtonList.UsrButtonList_Click_Detected | FP03033_ItemPopup.cs:314 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-1d11a0a2 | this.btnButtonList.UsrButtonList_Click_Detected | FP03033_ItemPopup.cs:317 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-78a228ec | this.btnButtonList.UsrButtonList_Click_Detected | FP03033_ItemPopup.cs:318 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP03033_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bba1e84 | this.Load | FP03033_ItemPopup.cs:128 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-874cb6f1 | this.Load | FP03033_ItemPopup.cs:129 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f6d1eb3c | this.Load | FP03033_ItemPopup.cs:130 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP03033_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e092e983 | this.Load | FP03033_ItemPopup.cs:123 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP03033_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c8ceca1 | Dispose | FP03033_ItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP03033_ItemPopup.Find_Data_Item

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / this.Load [try ▸ lambda] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49c0107f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:246 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION") ⇒ FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-1e7c786e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:247 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-84d9315f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:248 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_ITEM_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-8d839793 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:249 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e3335417 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:250 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a22add97 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:252 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fa0bfa28 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:253 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["p_division_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-0854ec3b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:254 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["p_site_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-abb81079 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:255 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9be58925 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:256 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0fc463ee | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:258 | try | DATA_OP | request.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-f0222798 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:259 | try | DATA_OP | request.Parameters["p_pjt_code"] | p_pjt_code | 행/컬럼 값 대입 |  |  |  |
| AC-9c8dc9d4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:260 | try | DATA_OP | request.Parameters["p_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7c952eb8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:261 | try | DATA_OP | request.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ed16aab6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:262 | try | DATA_OP | request.Parameters["p_prod_yn"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-45b699e0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:264 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["p_operation_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-2c5a6add | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:265 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-9cb7c70a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:266 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c20b8432 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:267 | try | DATA_OP | request.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ce34c205 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:268 | try | DATA_OP | request.Parameters["p_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7968b2f4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:270 | try | DATA_OP | request.Parameters["p_prod_ver_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-933fc7a7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:271 | try | DATA_OP | request.Parameters["p_max_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4facd68d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:272 | try | DATA_OP | request.Parameters["p_mark"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9a8816c8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:273 | try | DATA_OP | request.Parameters["p_org_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-72dded35 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:274 | try | DATA_OP | request.Parameters["p_job_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3e44d64b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:276 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-87084824 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:278 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1bf1e5b5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:283 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d64727d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:201 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-bf29cb13 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:206 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Item("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2489e6a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:213 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-77e8b1e5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:216 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ef8308f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:218 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-e4a74a95 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:226 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-9e2ad9f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP03033_ItemPopup.cs:232 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP03033_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-988a6b08 | this.Load | FP03033_ItemPopup.cs:100 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-dfff2f5d | this.Load | FP03033_ItemPopup.cs:102 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP03033_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5b5cd2a | this.Load | FP03033_ItemPopup.cs:140 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48288258 | this.Load | FP03033_ItemPopup.cs:141 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP03033_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ad23dc2 | (진입점 미연결) | FP03033_ItemPopup.cs:160 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP03033_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06dfd695 | this.Load | FP03033_ItemPopup.cs:147 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-25a0435f | this.Load | FP03033_ItemPopup.cs:148 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-d6251cfe | this.Load | FP03033_ItemPopup.cs:152 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP03033_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a95608b | this.spdMain.CellClick | FP03033_ItemPopup.cs:329 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-d79824a8 | this.spdMain.CellClick | FP03033_ItemPopup.cs:330 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d1b91f68 | this.spdMain.CellClick | FP03033_ItemPopup.cs:333 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP03033_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb2a1482 | this.spdMain.CellDoubleClick | FP03033_ItemPopup.cs:339 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-40f7fcbe | this.spdMain.CellDoubleClick | FP03033_ItemPopup.cs:340 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-139bed4e | this.spdMain.CellDoubleClick | FP03033_ItemPopup.cs:343 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-d0330772 | this.spdMain.CellDoubleClick | FP03033_ItemPopup.cs:346 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6edf9586 | this.spdMain.CellDoubleClick | FP03033_ItemPopup.cs:356 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP03033_Model_MeasureConversion.AddCategoryDataByEditCell

진입점: dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_BATCH) \|\| e.Column == siMain.GetColumnIndex(DefColumns.CELL_JUMBO) \|\| …)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf11d712 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2005 | if (dtCategoryData == null) | FLAG | dtCategoryData | CreateCategoryDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-a30eb21c | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2013 | lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e5f89853 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2014 | lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-05b4c61e | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2015 | lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2633d8b8 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2016 | lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a79c0f5 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2017 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-68549144 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2018 | lambda | DATA_OP | x.Field | ("MODEL_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-21bb1a50 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2019 | lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-0383d12e | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2020 | lambda | DATA_OP | x.Field | ("OPERATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e329aeb | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2021 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-03c2386e | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2022 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-825ffece | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2012 | lambda | RETURN | return (x.Field<string>("COMPANY_ID") == row["COMPANY_ID"].ToString() && x.Field… |  | 처리 중단/반환 |  |  |  |
| AC-06c619ec | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2030 | if (Matching_Row_ExistTable.Count() > 0) | DATA_OP | SelectedRow["VALUE"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-a1f3f6cf | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2034 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | dtCategoryData.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6911647c | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2036 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-338c958c | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2037 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6a5ef648 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2038 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-46588e10 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2039 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cf8ceebd | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2040 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2e8c49de | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2041 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["MODEL_ID"] | row["MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3c4888eb | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2042 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["PJT_CODE"] | row["PJT_CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ece1822a | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2043 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["VERSION_TYPE"] | row["VERSION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d77023eb | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2044 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["VERSION"] | row["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e0946ff1 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2045 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["PROD_YN"] | row["PROD_YN"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3bc19711 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2046 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["OPERATION"] | row["OPERATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e6b4c23c | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2047 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8bb55fc5 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2048 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-88a0182e | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2049 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["CATEGORY_ID"] | sCategory.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ee4a36be | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2050 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["VALUE"] | new_value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f4233f86 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2051 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["PROD_VERSION_TYPE"] | row["PROD_VERSION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-39f47e34 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2052 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["MAX_VER_FLAG"] | row["MAX_VER_FLAG"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-afc5f6da | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2053 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["APPLY_DATE"] | row["APPLY_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a6200e85 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2056 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | dtCategoryData.Rows.Add | (NewRow) | 데이터 객체 조작/조회 |  |  |  |

## FP03033_Model_MeasureConversion.AddDescDataByEditCell

진입점: dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_BATCH) \|\| e.Column == siMain.GetColumnIndex(DefColumns.CELL_JUMBO) \|\| …) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MARK))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-025b3e05 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2072 | if (dtDescData == null) | FLAG | dtDescData | CreateDescDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-0548adb3 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2080 | lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f138dcd | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2081 | lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-10a5310c | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2082 | lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-96a88d1b | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2083 | lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2cd96fd4 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2084 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b534af0e | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2085 | lambda | DATA_OP | x.Field | ("MODEL_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c64d57fc | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2086 | lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-a20531ce | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2087 | lambda | DATA_OP | x.Field | ("OPERATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae8386b9 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2088 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-740c0ff7 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2079 | lambda | RETURN | return (x.Field<string>("COMPANY_ID") == row["COMPANY_ID"].ToString() && x.Field… |  | 처리 중단/반환 |  |  |  |
| AC-243bfa39 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2096 | if (Matching_Row_ExistTable.Count() > 0) | DATA_OP | SelectedRow["MARK"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-534ed14f | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2100 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | dtDescData.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d6ea3919 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2102 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8afbdb0a | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2103 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-59f7f619 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2104 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f5246f03 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2105 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-17b92b3b | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2106 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-24c0d743 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2107 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["MODEL_ID"] | row["MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f6a8ef8b | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2108 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["PJT_CODE"] | row["PJT_CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-660a73cd | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2109 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["VERSION_TYPE"] | row["VERSION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d7581a3b | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2110 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["VERSION"] | row["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9e06e708 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2111 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["PROD_YN"] | row["PROD_YN"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e4f6400c | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2112 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["OPERATION"] | row["OPERATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e60dede7 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2113 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-04865b54 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2114 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-40bba355 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2115 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["PROD_VERSION_TYPE"] | row["PROD_VERSION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cb19767c | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2116 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["MAX_VER_FLAG"] | row["MAX_VER_FLAG"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aef47e5d | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2117 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | NewRow["MARK"] | row["MARK"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e7e8009e | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2120 | else of (Matching_Row_ExistTable.Count() > 0) | DATA_OP | dtDescData.Rows.Add | (NewRow) | 데이터 객체 조작/조회 |  |  |  |

## FP03033_Model_MeasureConversion.btnAdd_Click

진입점: this.btnAdd.Click / InsertButton [if (fps.Name == "spdMain") ▸ if (siMain.GetMaxRowIndex() > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-578ce23d | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1746 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_division_id = CString.GetCheckedListValue(dtDivision, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2c93a191 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1768 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-c7cc7011 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1771 |  | POPUP | new FP03033_AddPopup | ("INSERT") | 팝업/폼 생성 |  |  |  |
| AC-825a2d04 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1772 |  | DATA_OP | AddPopup.Filter["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f8602175 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1773 |  | DATA_OP | AddPopup.Filter["p_division_id"] | p_division_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5f4b1090 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1774 |  | DATA_OP | AddPopup.Filter["p_site_id"] | p_site_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-31d5c0b2 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1775 |  | DATA_OP | AddPopup.Filter["p_plant_id"] | p_plant_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-851a2e51 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1776 |  | DATA_OP | AddPopup.Filter["p_factory_id"] | p_factory_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-05d502d8 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1777 |  | DATA_OP | AddPopup.Filter["p_operation_id"] | p_operation_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ec641c90 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1778 |  | DATA_OP | AddPopup.Filter["p_prod_ver_type"] | p_prod_ver_type.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f9de71d5 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1779 |  | DATA_OP | AddPopup.Filter["p_model_id"] | p_model_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-53a46b04 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1780 |  | DATA_OP | AddPopup.Filter["p_item_id"] | p_item_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7ab3da81 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1781 |  | DATA_OP | AddPopup.Filter["p_pjt_code"] | p_pjt_code.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c5e4d3e | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1782 |  | DATA_OP | AddPopup.Filter["p_max_version"] | p_max_version.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-57ee0707 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1784 |  | UI_PROP | AddPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-9a66b4ad | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1785 |  | UI_PROP | AddPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-1f8218e2 | this.btnAdd.Click 외 1 | FP03033_Model_MeasureConversion.cs:1786 |  | POPUP | AddPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP03033_Model_MeasureConversion.btnGenerate_Click

진입점: this.btnGenerate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da60da57 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3718 |  | MESSAGE | MessageBox.Show | ("Generation is complete.") | 메시지 표시 |  |  |  |
| AC-32ef88dd | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3719 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d6afb49 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1632 | if (siMain.GetMaxRowIndex() < 0) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-3d17dfa2 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1633 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b3da1116 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1639 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-de0c3d17 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1655 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_division_id = CString.GetCheckedListValue(dtDivision, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f334197c | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1673 |  | DATA_OP | Filter["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-909fe469 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1674 |  | DATA_OP | Filter["p_division_id"] | p_division_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-726b6662 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1675 |  | DATA_OP | Filter["p_site_id"] | p_site_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a4db251b | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1676 |  | DATA_OP | Filter["p_plant_id"] | p_plant_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a65e238a | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1677 |  | DATA_OP | Filter["p_factory_id"] | p_factory_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c725e053 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1678 |  | DATA_OP | Filter["p_operation_id"] | p_operation_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cd0c01d2 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1679 |  | DATA_OP | Filter["p_prod_ver_type"] | p_prod_ver_type.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7cefd8f0 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1680 |  | DATA_OP | Filter["p_model_id"] | p_model_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5d7d05d3 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1681 |  | DATA_OP | Filter["p_item_id"] | p_item_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aca1a59c | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1682 |  | DATA_OP | Filter["p_pjt_code"] | p_pjt_code.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7caf5694 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1683 |  | DATA_OP | Filter["p_max_version"] | p_max_version.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b9abc64a | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1685 |  | POPUP | new FP03033_ImportExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-286683db | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1687 |  | FLAG | Filter | Filter | 화면 필드/플래그 변경 |  |  |  |
| AC-9ec40234 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1691 |  | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-50f69078 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1692 |  | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6a29352e | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1693 |  | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f965eba4 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1694 |  | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2e95bb1d | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1695 |  | GRID_SET | rowPopup.KeyColumns["MODEL_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ef3d10a4 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1696 |  | GRID_SET | rowPopup.KeyColumns["VERSION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a8e68004 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1697 |  | GRID_SET | rowPopup.KeyColumns["OPERATION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6bef8bc8 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1698 |  | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a232bd11 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1699 |  | GRID_SET | rowPopup.KeyColumns["CATEGORY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7cf02a0d | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1700 |  | GRID_SET | rowPopup.KeyColumns["VALUE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c07c9ff7 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1701 |  | GRID_SET | rowPopup.KeyColumns["PROD_VERSION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0df5eae2 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1704 |  | DATA_OP | rowPopup.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-2d4979e2 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1705 |  | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-3f358737 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1706 |  | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-2646ba50 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1707 |  | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-ab94815c | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1708 |  | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-7bb04388 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1709 |  | DATA_OP | rowPopup.ColumnTitle["MODEL_ID"] | "Model" | 행/컬럼 값 대입 |  |  |  |
| AC-aef48c43 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1710 |  | DATA_OP | rowPopup.ColumnTitle["PJT_CODE"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-a9cbaaad | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1711 |  | DATA_OP | rowPopup.ColumnTitle["VERSION_TYPE"] | "Version Type" | 행/컬럼 값 대입 |  |  |  |
| AC-9d18900e | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1712 |  | DATA_OP | rowPopup.ColumnTitle["VERSION"] | "Version" | 행/컬럼 값 대입 |  |  |  |
| AC-e0bb68f5 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1713 |  | DATA_OP | rowPopup.ColumnTitle["OPERATION"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-d7f70b05 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1714 |  | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-b1e67024 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1715 |  | DATA_OP | rowPopup.ColumnTitle["CATEGORY"] | "Category" | 행/컬럼 값 대입 |  |  |  |
| AC-64e65563 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1716 |  | DATA_OP | rowPopup.ColumnTitle["VALUE"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-4d4f9798 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1717 |  | DATA_OP | rowPopup.ColumnTitle["PROD_VERSION_TYPE"] | "Conversion Type" | 행/컬럼 값 대입 |  |  |  |
| AC-bad99868 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1718 |  | DATA_OP | rowPopup.ColumnTitle["MARK"] | "Description" | 행/컬럼 값 대입 |  |  |  |
| AC-cb259d9c | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1721 |  | UI_PROP | rowPopup.OnSearchData | ExcelPopup_Search_Data | 속성 OnSearchData 설정 |  |  |  |
| AC-41d3eec0 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1722 |  | UI_PROP | rowPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Data | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-fc1056d9 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1723 |  | UI_PROP | rowPopup.OnValidationSaveData | ExcelPopup_ImportValidation_Data | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-8be0e62e | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1725 |  | UI_PROP | rowPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-46858539 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1726 |  | UI_PROP | rowPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-8616f7e2 | this.btnImport.Click | FP03033_Model_MeasureConversion.cs:1727 |  | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP03033_Model_MeasureConversion.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8187655 | this.btnSql.Click | FP03033_Model_MeasureConversion.cs:1797 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-38ce39ff | this.btnSql.Click | FP03033_Model_MeasureConversion.cs:1798 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8dd13cda | this.btnSql.Click | FP03033_Model_MeasureConversion.cs:1800 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_SELECT_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-e13f494e | this.btnSql.Click | FP03033_Model_MeasureConversion.cs:1801 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_INSERT_EXCEL_BUFFER") | 데이터 객체 조작/조회 |  |  |  |
| AC-cdd01201 | this.btnSql.Click | FP03033_Model_MeasureConversion.cs:1802 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_INSERT_UOM_INFO") | 데이터 객체 조작/조회 |  |  |  |
| AC-b315df51 | this.btnSql.Click | FP03033_Model_MeasureConversion.cs:1803 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_UPDATE_MARK") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4d37649 | this.btnSql.Click | FP03033_Model_MeasureConversion.cs:1804 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_INSERT_LANE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1391a77 | this.btnSql.Click | FP03033_Model_MeasureConversion.cs:1805 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_UPDATE_MAXVERFLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e8ecca9 | this.btnSql.Click | FP03033_Model_MeasureConversion.cs:1806 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_UPDATE_PANCAKE_M_BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-03fa9b41 | this.btnSql.Click | FP03033_Model_MeasureConversion.cs:1807 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_UPDATE_PANCAKE_CELL_M") | 데이터 객체 조작/조회 |  |  |  |
| AC-56690b81 | this.btnSql.Click | FP03033_Model_MeasureConversion.cs:1808 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_SELECT_DETAIL") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc3db991 | this.btnSql.Click | FP03033_Model_MeasureConversion.cs:1809 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03033_SAVE_DETAIL") | 데이터 객체 조작/조회 |  |  |  |
| AC-c2890d6e | this.btnSql.Click | FP03033_Model_MeasureConversion.cs:1811 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP03033_Model_MeasureConversion.btnSubImport_Click

진입점: this.btnSubImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eded96df | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3062 |  | DATA_OP | SubFilter["p_division_id"] | p_division_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bd20bf5f | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3063 |  | DATA_OP | SubFilter["p_site_id"] | p_site_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a9eb5278 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3064 |  | DATA_OP | SubFilter["p_plant_id"] | p_plant_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-64c5211d | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3065 |  | DATA_OP | SubFilter["p_factory_id"] | p_factory_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9d6722d7 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3066 |  | DATA_OP | SubFilter["p_model_id"] | p_model_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-37a69fef | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3069 |  | POPUP | new FP03033_ImportExcelSubPopup | () | 팝업/폼 생성 |  |  |  |
| AC-46119be8 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3070 |  | UI_PROP | p.Filter | SubFilter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-ab09d26b | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3070 |  | DATA_OP | SubFilter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1aba6407 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3072 |  | GRID_SET | p.KeyColumns["COMPANY_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-a2126101 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3073 |  | GRID_SET | p.KeyColumns["DIVISION_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-568471c7 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3074 |  | GRID_SET | p.KeyColumns["SITE_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-15ab8666 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3075 |  | GRID_SET | p.KeyColumns["PLANT_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-796814a0 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3076 |  | GRID_SET | p.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c8bdf179 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3077 |  | GRID_SET | p.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8878cef6 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3078 |  | GRID_SET | p.KeyColumns["LINE_NAME"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-adf5f8b9 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3079 |  | GRID_SET | p.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2b0b0433 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3080 |  | GRID_SET | p.KeyColumns["MODEL_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-11587adf | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3081 |  | GRID_SET | p.KeyColumns["NICK_NAME"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-9a90bb20 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3082 |  | GRID_SET | p.KeyColumns["VERSION_TYPE"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-975f6dde | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3083 |  | GRID_SET | p.KeyColumns["VERSION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e618404e | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3084 |  | GRID_SET | p.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ffc0c6c0 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3085 |  | GRID_SET | p.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-77d626c4 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3086 |  | GRID_SET | p.KeyColumns["ACTIVE_FLAG"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7c3926d9 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3087 |  | GRID_SET | p.KeyColumns["PROD_VERSION_TYPE"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-e2a04bff | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3088 |  | GRID_SET | p.KeyColumns["MAX_VER_FLAG"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-25a10b27 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3089 |  | GRID_SET | p.KeyColumns["DESCRIPTION"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-b4560d79 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3093 |  | DATA_OP | p.ColumnTitle["COMPANY_ID"] | "(EN)Company" | 행/컬럼 값 대입 |  |  |  |
| AC-9b9140b9 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3094 |  | DATA_OP | p.ColumnTitle["DIVISION_ID"] | "(EN)Div" | 행/컬럼 값 대입 |  |  |  |
| AC-cbb8b8a5 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3095 |  | DATA_OP | p.ColumnTitle["SITE_ID"] | "(EN)Site" | 행/컬럼 값 대입 |  |  |  |
| AC-48f95262 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3096 |  | DATA_OP | p.ColumnTitle["PLANT_ID"] | "(EN)Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-23fafe3a | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3097 |  | DATA_OP | p.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-d1ac237f | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3098 |  | DATA_OP | p.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-fdc1393d | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3099 |  | DATA_OP | p.ColumnTitle["LINE_NAME"] | "Line Name" | 행/컬럼 값 대입 |  |  |  |
| AC-1c1cc3af | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3100 |  | DATA_OP | p.ColumnTitle["ELECTRODE_TYPE"] | "Elec.Type" | 행/컬럼 값 대입 |  |  |  |
| AC-1afa81c8 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3101 |  | DATA_OP | p.ColumnTitle["MODEL_ID"] | "*Model" | 행/컬럼 값 대입 |  |  |  |
| AC-e8d08c42 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3102 |  | DATA_OP | p.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-79461be0 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3103 |  | DATA_OP | p.ColumnTitle["VERSION_TYPE"] | "Version Type" | 행/컬럼 값 대입 |  |  |  |
| AC-b1fb789e | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3104 |  | DATA_OP | p.ColumnTitle["VERSION"] | "*Version" | 행/컬럼 값 대입 |  |  |  |
| AC-57f3d3de | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3105 |  | DATA_OP | p.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-8e482b50 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3106 |  | DATA_OP | p.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-65dc2526 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3107 |  | DATA_OP | p.ColumnTitle["ACTIVE_FLAG"] | "Use Y/N" | 행/컬럼 값 대입 |  |  |  |
| AC-20aee080 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3108 |  | DATA_OP | p.ColumnTitle["PROD_VERSION_TYPE"] | "Conversion Type" | 행/컬럼 값 대입 |  |  |  |
| AC-bd6c2d2c | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3109 |  | DATA_OP | p.ColumnTitle["MAX_VER_FLAG"] | "Max Version Type" | 행/컬럼 값 대입 |  |  |  |
| AC-65a7aaeb | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3110 |  | DATA_OP | p.ColumnTitle["DESCRIPTION"] | "Description" | 행/컬럼 값 대입 |  |  |  |
| AC-d742ea37 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3113 |  | DATA_OP | p.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-5ea45ca2 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3115 |  | DATA_OP | p.ColumnWidth["COMPANY_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-bb668dc0 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3116 |  | DATA_OP | p.ColumnWidth["DIVISION_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-9fb632c9 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3117 |  | DATA_OP | p.ColumnWidth["SITE_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-aef3e3dd | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3118 |  | DATA_OP | p.ColumnWidth["PLANT_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-03029623 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3119 |  | DATA_OP | p.ColumnWidth["FACTORY_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-84a4f6b6 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3120 |  | DATA_OP | p.ColumnWidth["LINE_ID"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-a53fab9d | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3121 |  | DATA_OP | p.ColumnWidth["LINE_NAME"] | 120 | 행/컬럼 값 대입 |  |  |  |
| AC-48375c96 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3122 |  | DATA_OP | p.ColumnWidth["ELECTRODE_TYPE"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-c5eee7b7 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3123 |  | DATA_OP | p.ColumnWidth["MODEL_ID"] | 130 | 행/컬럼 값 대입 |  |  |  |
| AC-54404250 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3124 |  | DATA_OP | p.ColumnWidth["NICK_NAME"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-0f34e3f8 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3125 |  | DATA_OP | p.ColumnWidth["VERSION_TYPE"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-f49d7ee0 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3126 |  | DATA_OP | p.ColumnWidth["VERSION"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-78f0a557 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3127 |  | DATA_OP | p.ColumnWidth["OPERATION_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-1556ea74 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3128 |  | DATA_OP | p.ColumnWidth["ITEM_ID"] | 130 | 행/컬럼 값 대입 |  |  |  |
| AC-c85de9b6 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3129 |  | DATA_OP | p.ColumnWidth["ACTIVE_FLAG"] | 60 | 행/컬럼 값 대입 |  |  |  |
| AC-19d64356 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3130 |  | DATA_OP | p.ColumnWidth["PROD_VERSION_TYPE"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-43a3d2ad | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3131 |  | DATA_OP | p.ColumnWidth["MAX_VER_FLAG"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-39dd601a | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3132 |  | DATA_OP | p.ColumnWidth["DESCRIPTION"] | 200 | 행/컬럼 값 대입 |  |  |  |
| AC-c5ab9221 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3135 |  | DATA_OP | p.ColumnWidth["MESSAGE"] | 250 | 행/컬럼 값 대입 |  |  |  |
| AC-8b70c985 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3137 |  | DATA_OP | p.ColumnBgColor["ACTIVE_FLAG"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-2cd37718 | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3138 |  | DATA_OP | p.ColumnBgColor["DESCRIPTION"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-d965bbbc | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3140 |  | UI_PROP | p.DoSearchData | ExcelPopup_Search_Sub_Data | 속성 DoSearchData 설정 |  |  |  |
| AC-20c8dcee | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3142 |  | UI_PROP | p.DoSaveData | ExcelPopup_SaveExcel_Sub_Data | 속성 DoSaveData 설정 |  |  |  |
| AC-d776288f | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3143 |  | UI_PROP | p.DoValidationData | ExcelPopup_ImportValidation_Sub_Data | 속성 DoValidationData 설정 |  |  |  |
| AC-f2a7777d | this.btnSubImport.Click | FP03033_Model_MeasureConversion.cs:3145 |  | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP03033_Model_MeasureConversion.CboPlant_SelectedIndexChanged

진입점: this.Load [try] / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c709e5b | this.Load [try] 외 1 | FP03033_Model_MeasureConversion.cs:1849 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d2f66e63 | this.Load [try] 외 1 | FP03033_Model_MeasureConversion.cs:1851 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP03033_Model_MeasureConversion.CboSite_SelectedIndexChanged

진입점: this.Load [try] / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9ed4732 | this.Load [try] 외 1 | FP03033_Model_MeasureConversion.cs:1841 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-086863b5 | this.Load [try] 외 1 | FP03033_Model_MeasureConversion.cs:1843 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP03033_Model_MeasureConversion.CreateCategoryDataTable

진입점: dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_BATCH) \|\| e.Column == siMain.GetColumnIndex(DefColumns.CELL_JUMBO) \|\| …) ▸ if (dtCategoryData == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e14bdfd9 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2127 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-1809c355 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2129 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-40156e9d | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2130 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-af3e92a2 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2131 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e4b4966 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2132 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-92713417 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2133 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b6a49c1 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2134 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MODEL_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f037736 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2135 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PJT_CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1127a01 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2136 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5802762 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2137 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8954296 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2138 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PROD_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fdc9d9a | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2139 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-208cb53e | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2140 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-96e54441 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2141 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2367d536 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2142 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a204554b | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2143 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VALUE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b91ced0 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2144 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PROD_VERSION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-659884be | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2145 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MAX_VER_FLAG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7112ce49 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2146 |  | DATA_OP | dt.Columns.Add | (new DataColumn("APPLY_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-82dfb746 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2148 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.CreateDescDataTable

진입점: dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_BATCH) \|\| e.Column == siMain.GetColumnIndex(DefColumns.CELL_JUMBO) \|\| …) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MARK)) ▸ if (dtDescData == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60df88cb | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2153 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-be18ae16 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2155 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-031b781b | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2156 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-854f219b | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2157 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-496ab198 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2158 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9aedb879 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2159 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f0e7a2d | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2160 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MODEL_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-01b7858d | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2161 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PJT_CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a639f23e | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2162 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-68b5d352 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2163 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9c540d8 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2164 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PROD_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-99f97547 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2165 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-66d49f27 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2166 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cda5bad8 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2167 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c91fc45d | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2168 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PROD_VERSION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-149421fb | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2169 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MAX_VER_FLAG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f51cbe69 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2170 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2d13d86 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… | FP03033_Model_MeasureConversion.cs:2172 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.CreateExelBufferDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c770005b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2361 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-f9bbe1c1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2363 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-df468e8d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2364 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b01b4130 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2365 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bdbca74e | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2366 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1d8858b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2367 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1742f39b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2368 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MODEL_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-16769fb6 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2369 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PJT_CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-25946dd6 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2370 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e904a61d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2371 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3b8089c | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2372 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb79c70d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2373 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-28a4b66e | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2374 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c48504a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2375 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VALUE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-884fefce | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2376 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PROD_VERSION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd47bf43 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2377 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-802d3923 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2379 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.CreateExelBufferDataTable_Sub

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22eb021a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2385 |  | UI_PROP | dt.TableName | "Table2" | 속성 TableName 설정 |  |  |  |
| AC-e8df4ace | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2387 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eeacf209 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2388 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-062d69ed | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2389 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d7a0784 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2390 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MODEL_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e621380 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2391 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-48f9d68c | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2392 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4f18ade | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2393 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-45ec054a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2394 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ACTIVE_FLAG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f784531c | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2395 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DESCRIPTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-df4cbd6d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2397 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb1b0fdb | this.Load | FP03033_Model_MeasureConversion.cs:296 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9d9d2242 | this.Load | FP03033_Model_MeasureConversion.cs:297 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-32d2f97b | this.Load | FP03033_Model_MeasureConversion.cs:299 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d07ab3b | this.Load | FP03033_Model_MeasureConversion.cs:304 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-14d3a38b | this.Load | FP03033_Model_MeasureConversion.cs:305 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-af497e6a | this.Load | FP03033_Model_MeasureConversion.cs:307 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8af13516 | this.Load | FP03033_Model_MeasureConversion.cs:310 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP03033_ModelMeasure_Conversion", "YN") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c7b7f77 | this.Load | FP03033_Model_MeasureConversion.cs:317 |  | CALL_EXT | siSub.SetColumnCombo | ("USE_YN", dtYN) | ⚠ 의미 확인 필요 |  |  |  |

## FP03033_Model_MeasureConversion.Delete_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c78f66a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2992 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_EXCEL_SAVE") ⇒ FP_Master.PR_UI_FP03033_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-547ed6da | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2993 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-671d3eaf | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2995 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-9cd47e4c | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2996 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-10a534f9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2997 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a5681e9e | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2998 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f0bd749a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3000 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e7fecf4f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3001 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dc51263f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3002 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4a2224c3 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3003 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7e333928 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3004 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-546133f3 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3006 | try | DATA_OP | req.Parameters["p_model_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ca2f2da3 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3007 | try | DATA_OP | req.Parameters["p_pjt_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8629edfd | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3008 | try | DATA_OP | req.Parameters["p_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-61fa3db9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3009 | try | DATA_OP | req.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1e3129f5 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3010 | try | DATA_OP | req.Parameters["p_prod_yn"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c64f095b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3012 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4e7aa7f7 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3013 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bd194ef3 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3014 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-62ca1ca1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3015 | try | DATA_OP | req.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6b29fe57 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3016 | try | DATA_OP | req.Parameters["p_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f76dc3a0 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3018 | try | DATA_OP | req.Parameters["p_prod_ver_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ed8bac60 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3019 | try | DATA_OP | req.Parameters["p_max_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2bdf0305 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3020 | try | DATA_OP | req.Parameters["p_mark"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4d9893da | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3021 | try | DATA_OP | req.Parameters["p_org_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a303362d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3022 | try | DATA_OP | req.Parameters["p_job_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a957a22e | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3024 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-55690c77 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3026 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-be285f44 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3030 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Delete_Data_Excel_Sub_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fef7ab1f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3522 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP3033_SAVE") ⇒ FP_Master.PR_UI_FP3033_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-8b9f5c0f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3523 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-79c8ad69 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3525 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-1395f704 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3526 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-2db6abb9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3527 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-035bafec | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3528 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-00b5c2dc | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3530 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d008941a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3531 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5303335e | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3532 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7e6c295b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3533 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7100d8d4 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3534 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dbd1c4ce | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3535 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3b96f780 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3536 | try | DATA_OP | req.Parameters["p_model_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b6dba5db | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3537 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-47db0b12 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3538 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-42728a7f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3539 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3a0cccd3 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3540 | try | DATA_OP | req.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1cf2e8b2 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3541 | try | DATA_OP | req.Parameters["p_active_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bb1c3da9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3542 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7f2bb25e | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3544 | try | DATA_OP | req.Parameters["p_attb_1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e3f78823 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3545 | try | DATA_OP | req.Parameters["p_attb_2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6ce92205 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3546 | try | DATA_OP | req.Parameters["p_attb_3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9cb0986e | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3547 | try | DATA_OP | req.Parameters["p_attb_4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fef4ff9b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3548 | try | DATA_OP | req.Parameters["p_attb_5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ced3c50b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3550 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e48d86fb | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3552 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-d715a07c | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3556 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-226c58ed | DeleteButton | FP03033_Model_MeasureConversion.cs:561 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "the delete can't use.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cac1c69c | DeleteButton | FP03033_Model_MeasureConversion.cs:563 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ac54678 | Dispose | FP03033_Model_MeasureConversion.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP03033_Model_MeasureConversion.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a83b169 | EditButton | FP03033_Model_MeasureConversion.cs:433 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4025052d | EditButton | FP03033_Model_MeasureConversion.cs:441 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-88f080b9 | EditButton | FP03033_Model_MeasureConversion.cs:443 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f33a5787 | EditButton | FP03033_Model_MeasureConversion.cs:444 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) | UI_MISC | siMain.SP.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-91253af1 | EditButton | FP03033_Model_MeasureConversion.cs:446 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) | CALL_EXT | siMain.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-79389b8b | EditButton | FP03033_Model_MeasureConversion.cs:448 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetMaxRowIndex(), siMain.GetColu… | 그리드 편집 잠금 전환 |  |  |  |
| AC-0c0bff11 | EditButton | FP03033_Model_MeasureConversion.cs:449 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.CELL_M), siMain.GetMaxRowIndex(), siMain.GetColumnInd… | 그리드 편집 잠금 전환 |  |  |  |
| AC-fc3ee171 | EditButton | FP03033_Model_MeasureConversion.cs:450 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.APPLY_DATE), siMain.GetMaxRowIndex(), siMain.GetColum… | 그리드 편집 잠금 전환 |  |  |  |
| AC-dd9dea5c | EditButton | FP03033_Model_MeasureConversion.cs:452 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) | CALL_EXT | siMain.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-73fb15a5 | EditButton | FP03033_Model_MeasureConversion.cs:462 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true… | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-a1117490 | EditButton | FP03033_Model_MeasureConversion.cs:466 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-f1f33fb6 | EditButton | FP03033_Model_MeasureConversion.cs:470 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-24fbbf53 | EditButton | FP03033_Model_MeasureConversion.cs:475 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true… | GRID_LOCK | siMain.LockRange2 | (i, siMain.GetColumnIndex(DefColumns.CELL_BATCH), i, siMain.GetColumnIndex(DefColumns.LANE… | 그리드 편집 잠금 전환 |  |  |  |
| AC-db1e6b1d | EditButton | FP03033_Model_MeasureConversion.cs:476 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true… | GRID_LOCK | siMain.LockRange2 | (i, siMain.GetColumnIndex(DefColumns.MARK), i, siMain.GetColumnIndex(DefColumns.MARK), fal… | 그리드 편집 잠금 전환 |  |  |  |
| AC-7738ba8a | EditButton | FP03033_Model_MeasureConversion.cs:480 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true… | GRID_STYLE | siMain.SetBGColor2 | (i, siMain.GetColumnIndex(DefColumns.CELL_BATCH), i, siMain.GetColumnIndex(DefColumns.LANE… | 그리드 표시 설정 |  |  |  |
| AC-1eebdcf3 | EditButton | FP03033_Model_MeasureConversion.cs:481 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true… | GRID_STYLE | siMain.SetBGColor2 | (i, siMain.GetColumnIndex(DefColumns.MARK), i, siMain.GetColumnIndex(DefColumns.MARK), Sys… | 그리드 표시 설정 |  |  |  |
| AC-7c23b34c | EditButton | FP03033_Model_MeasureConversion.cs:485 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true… | GRID_STYLE | siMain.SetBGColor2 | (i, siMain.GetColumnIndex(DefColumns.CELL_BATCH), i, siMain.GetColumnIndex(DefColumns.LANE… | 그리드 표시 설정 |  |  |  |
| AC-4a6df6a0 | EditButton | FP03033_Model_MeasureConversion.cs:486 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true… | GRID_STYLE | siMain.SetBGColor2 | (i, siMain.GetColumnIndex(DefColumns.MARK), i, siMain.GetColumnIndex(DefColumns.MARK), Sys… | 그리드 표시 설정 |  |  |  |
| AC-91e91833 | EditButton | FP03033_Model_MeasureConversion.cs:515 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) ▸ else of (siMain.ActiveSheet.Columns.Get(xCol1).Visible ==… | GRID_LOCK | siMain.LockRange2 | (i, siMain.GetColumnIndex(DefColumns.CELL_BATCH), i, siMain.GetColumnIndex(DefColumns.LANE… | 그리드 편집 잠금 전환 |  |  |  |
| AC-f35bec33 | EditButton | FP03033_Model_MeasureConversion.cs:516 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) ▸ else of (siMain.ActiveSheet.Columns.Get(xCol1).Visible ==… | GRID_STYLE | siMain.SetBGColor2 | (i, siMain.GetColumnIndex(DefColumns.CELL_BATCH), i, siMain.GetColumnIndex(DefColumns.LANE… | 그리드 표시 설정 |  |  |  |
| AC-7811899d | EditButton | FP03033_Model_MeasureConversion.cs:518 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) ▸ else of (siMain.ActiveSheet.Columns.Get(xCol1).Visible ==… | GRID_LOCK | siMain.LockRange2 | (i, siMain.GetColumnIndex(DefColumns.MARK), i, siMain.GetColumnIndex(DefColumns.MARK), tru… | 그리드 편집 잠금 전환 |  |  |  |
| AC-1a54c0eb | EditButton | FP03033_Model_MeasureConversion.cs:519 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) ▸ else of (siMain.ActiveSheet.Columns.Get(xCol1).Visible ==… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.MARK), i, siMain.GetColumnIndex(DefColumns.MARK), Sys… | 그리드 표시 설정 |  |  |  |
| AC-3c46f80a | EditButton | FP03033_Model_MeasureConversion.cs:524 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null) | UI_MISC | siMain.SP.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-951d8f87 | EditButton | FP03033_Model_MeasureConversion.cs:531 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (spdSub != null) | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-051c9418 | EditButton | FP03033_Model_MeasureConversion.cs:533 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (spdSub != null) | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ecadc2ca | EditButton | FP03033_Model_MeasureConversion.cs:535 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (spdSub != null) | CALL_EXT | siSub.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb028abd | EditButton | FP03033_Model_MeasureConversion.cs:537 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (spdSub != null) | GRID_LOCK | siSub.LockRange | (0, siSub.GetColumnIndex(DefColumns.SUB_DIVISION_ID), siSub.GetMaxRowIndex(), siSub.GetMax… | 그리드 편집 잠금/해제 |  |  |  |
| AC-08c8245f | EditButton | FP03033_Model_MeasureConversion.cs:539 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (spdSub != null) | CALL_EXT | siSub.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f45f9f2 | EditButton | FP03033_Model_MeasureConversion.cs:541 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (spdSub != null) ▸ if (siSub.ActiveSheet.Columns.Get(xCol1).Visible == true) | GRID_LOCK | siSub.LockRange | (0, siSub.GetColumnIndex(DefColumns.SUB_ACTIVE_FLAG), siSub.GetMaxRowIndex(), siSub.GetCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-717774f5 | EditButton | FP03033_Model_MeasureConversion.cs:542 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (spdSub != null) ▸ if (siSub.ActiveSheet.Columns.Get(xCol1).Visible == true) | GRID_LOCK | siSub.LockRange | (0, siSub.GetColumnIndex(DefColumns.SUB_DESCRIPTION), siSub.GetMaxRowIndex(), siSub.GetCol… | 그리드 편집 잠금/해제 |  |  |  |

## FP03033_Model_MeasureConversion.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5259a159 | ExcelButton | FP03033_Model_MeasureConversion.cs:596 |  | EXCEL | ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## FP03033_Model_MeasureConversion.ExcelPopup_ImportValidation_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59cc1a1f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2524 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1ae70db2 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2527 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | data.Tables[0].Rows[i]["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d6969973 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2528 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-89d83af9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2529 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-438aa7ff | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2530 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c71faab1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2531 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-800710b7 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2532 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MODEL_ID"] | data.Tables[0].Rows[i]["MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d8c5ea8c | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2533 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PJT_CODE"] | data.Tables[0].Rows[i]["PJT_CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b4f1131b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2534 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["VERSION_TYPE"] | data.Tables[0].Rows[i]["VERSION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-189a4cb5 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2535 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["VERSION"] | data.Tables[0].Rows[i]["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bb57a60f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2536 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION"] | data.Tables[0].Rows[i]["OPERATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-309be721 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2537 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ac112212 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2538 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["CATEGORY"] | data.Tables[0].Rows[i]["CATEGORY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f7405ae2 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2539 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["VALUE"] | data.Tables[0].Rows[i]["VALUE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-54da16b5 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2540 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PROD_VERSION_TYPE"] | data.Tables[0].Rows[i]["PROD_VERSION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fdd5953d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2541 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MARK"] | data.Tables[0].Rows[i]["MARK"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3b9dd780 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2545 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec37e86f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2548 | try | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-630d65f7 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2566 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-54c376df | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2571 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-65398480 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2573 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5a38e48 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2576 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-50d92851 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2585 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-442a4ea0 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2586 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-540a19c4 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2591 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-8c129fd0 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2596 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f9a2d4a0 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2597 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.ExcelPopup_ImportValidation_Sub_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cb9a7c1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3433 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-174a5434 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3435 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-415b7907 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3436 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f2cbe888 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3437 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a091f66e | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3438 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MODEL_ID"] | data.Tables[0].Rows[i]["MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5a178d27 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3439 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["VERSION"] | data.Tables[0].Rows[i]["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8fe6f46d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3440 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc668bb1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3441 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-732cd519 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3442 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ACTIVE_FLAG"] | data.Tables[0].Rows[i]["ACTIVE_FLAG"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2828977f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3443 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DESCRIPTION"] | data.Tables[0].Rows[i]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bf2c366a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3446 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fa49c01 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3449 | try | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-576271bb | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3467 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4f763599 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3472 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-43100551 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3474 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-65c126df | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3477 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-42512ad5 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3483 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-53b6e33a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3489 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ else of (dsValidation.Tables[0]… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-49149aab | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3495 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-274fb871 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3496 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-2598812a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3500 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-c6384db4 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3505 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d7392bd1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3506 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.ExcelPopup_SaveExcel_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c173b234 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2801 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds1.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-bf510718 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2802 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds1.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-5ee7c53c | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2810 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-eb108b8e | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2811 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8dc10ea2 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2819 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds3.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-b6c021b9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2820 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds3.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c05cea8d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2828 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds4.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-a2bcebaf | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2829 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds4.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-9855b26a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2837 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds5.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-74dfd406 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2838 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds5.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c3ccbce3 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2842 |  | RETURN | return ds1; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.ExcelPopup_SaveExcel_Sub_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-674a2861 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3356 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds1.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f51688c1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3357 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds1.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-93e2ab9d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3361 |  | RETURN | return ds1; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.ExcelPopup_Search_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78138fad | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2410 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-068f808a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2412 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.ExcelPopup_Search_Sub_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-720b7c58 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3252 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-096a31c0 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3254 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.EXECUTE_GENERATE

진입점: this.btnGenerate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65591ecc | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3727 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION") ⇒ FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-626ef172 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3728 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9bb8b166 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3729 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-066296fe | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3730 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_ITEM_LINE_VERSION" | 행/컬럼 값 대입 |  |  |  |
| AC-180972cb | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3731 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2236fc8e | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3732 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ca713e4b | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3734 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-89007307 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3735 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-df5df5df | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3736 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eed1b52b | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3737 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-df780ec0 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3738 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5dc82d27 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3740 | try | DATA_OP | request.Parameters["p_model_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dbd9fb9c | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3741 | try | DATA_OP | request.Parameters["p_pjt_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7af8952c | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3742 | try | DATA_OP | request.Parameters["p_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4d20264b | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3743 | try | DATA_OP | request.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0fe66e23 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3744 | try | DATA_OP | request.Parameters["p_prod_yn"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-284ee55f | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3746 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f76770b9 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3747 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-98e2a7e1 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3748 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e42e77a2 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3749 | try | DATA_OP | request.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8aa78031 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3750 | try | DATA_OP | request.Parameters["p_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-de964653 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3752 | try | DATA_OP | request.Parameters["p_prod_ver_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6bc8c49d | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3753 | try | DATA_OP | request.Parameters["p_max_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-499c44c9 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3754 | try | DATA_OP | request.Parameters["p_mark"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fac93723 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3755 | try | DATA_OP | request.Parameters["p_org_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f64081f3 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3756 | try | DATA_OP | request.Parameters["p_job_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-81de5941 | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3758 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3da3746f | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3760 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-86fffe9d | this.btnGenerate.Click | FP03033_Model_MeasureConversion.cs:3765 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Find_Data

진입점: this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult.OK)] / FindButton / InsertButton [if (fps.Name == "spdMain") ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (AddPopup.ShowDialog() == DialogResult.OK)] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bTrans == true && bTransMark == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e4c6f95 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:601 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d44b491c | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:606 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ced9ba5a | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:609 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d099262f | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:609 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-336570de | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:613 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c2adf6c7 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:614 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a21a661a | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:617 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9863e108 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:620 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6416e3c4 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:621 | try | FLAG | dtCategoryData | null | 화면 필드/플래그 변경 |  |  |  |
| AC-83f13c30 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:622 | try | FLAG | dtDescData | null | 화면 필드/플래그 변경 |  |  |  |
| AC-016b9e21 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:625 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-998c292c | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:631 | try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_Conversion("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-f7c2d40a | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:631 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Conversion("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a09f67e8 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:641 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | CALL_EXT | siMain.SetRightMerge | (siMain.GetColumnIndex(DefColumns.ITEM_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-352d5ee1 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:644 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9bdfdc10 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:646 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f2196fc | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:649 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e0a1e958 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:658 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-4da1f7fe | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:662 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5356c8a5 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:664 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-06c35acd | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:666 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-683f8ed0 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:674 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-180eb750 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:679 | finally | GRID_SET | siMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9854dc85 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:679 | finally | CALL_EXT | siMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6511e65c | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:680 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ff6bb04a | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:682 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-e4fb7911 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 3 | FP03033_Model_MeasureConversion.cs:685 | finally | GRID_CLEAR | SpreadInfo.ClearDataSource | (siSub.SpreadObject) | 그리드 데이터/선택 비움 |  |  |  |

## FP03033_Model_MeasureConversion.Find_Data_Conversion

진입점: this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult.OK) ▸ try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FP03033_SELECT_MAIN")] / FindButton [try ▸ lambda] / InsertButton [if (fps.Name == "spdMain") ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (AddPopup.ShowDialog() == DialogResult.OK) ▸ try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bTrans == true && bTransMark == true) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac3e5f25 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:766 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_division_id = CString.GetCheckedListValue(dtDivision, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1450b2a | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:786 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION") ⇒ FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-c2f64632 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:787 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3324d701 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:788 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-10e9d485 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:789 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-77f33db9 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:790 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8d2d959e | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:791 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3cca466b | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:793 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7c303e0a | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:794 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-15038165 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:795 | try | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-92f2813f | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:796 | try | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-0dc256ec | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:797 | try | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-d95b8b27 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:799 | try | DATA_OP | request.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-4da29f68 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:800 | try | DATA_OP | request.Parameters["p_pjt_code"] | p_pjt_code | 행/컬럼 값 대입 |  |  |  |
| AC-1d9bddbe | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:801 | try | DATA_OP | request.Parameters["p_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-24de407b | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:802 | try | DATA_OP | request.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-00a480c4 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:803 | try | DATA_OP | request.Parameters["p_prod_yn"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ef90f847 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:805 | try | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-02e0b1e2 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:806 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-61d40d0a | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:807 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3326ec3b | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:808 | try | DATA_OP | request.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7c2e9ea0 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:809 | try | DATA_OP | request.Parameters["p_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-921de7f3 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:811 | try | DATA_OP | request.Parameters["p_prod_ver_type"] | p_prod_ver_type | 행/컬럼 값 대입 |  |  |  |
| AC-d2cfdd7a | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:812 | try | DATA_OP | request.Parameters["p_max_version"] | p_max_version | 행/컬럼 값 대입 |  |  |  |
| AC-06ade9db | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:813 | try | DATA_OP | request.Parameters["p_mark"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6c9edf48 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:814 | try | DATA_OP | request.Parameters["p_org_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0145d345 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:815 | try | DATA_OP | request.Parameters["p_job_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ab5c9a2b | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:817 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-61078c2c | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:819 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b2b81f2a | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:824 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Find_Data_Detail_Conversion

진입점: this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult.OK) ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try] / this.spdMain.CellDoubleClick [if ((iClickRow != nRow) && (nRow >= 0)) ▸ try] / this.btnSearchAll.Click [try] / this.btnSubImport.Click [if (p.DialogResult == DialogResult.OK) ▸ try] / popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ else of (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER") ▸ else of (programID == "PR_UI_FP03033_INSERT_UOM_INFO") ▸ else of (programID == "PR_UI_FP03033_UPDATE_MARK") ▸ else of (programID == "PR_UI_FP03033_INSERT_LANE") ▸ el…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5294e4da | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1296 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { // 전체 조회 if (pAllType == "ALL") { p_division_id = CString… | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd290013 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1322 | lambda | FLAG | strDetail_AllType | pAllType | 화면 필드/플래그 변경 |  |  |  |
| AC-b85a857b | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1329 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION") ⇒ FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-4b3bd741 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1330 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c46d6e68 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1331 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-1308ad94 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1332 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_DETAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-893e42e4 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1333 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-077ba0a9 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1334 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-470a7346 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1336 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-751a1830 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1337 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-aaafaa3d | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1338 | try | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-58a29858 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1339 | try | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-5fc282e4 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1340 | try | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-b366b1e4 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1342 | try | DATA_OP | request.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-57ba6d28 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1343 | try | DATA_OP | request.Parameters["p_pjt_code"] | p_pjt_code | 행/컬럼 값 대입 |  |  |  |
| AC-da4f3910 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1344 | try | DATA_OP | request.Parameters["p_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5b11a3a5 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1345 | try | DATA_OP | request.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-14afafb8 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1346 | try | DATA_OP | request.Parameters["p_prod_yn"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f065664e | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1348 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-45823e88 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1349 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-7e244fbc | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1350 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e20161dc | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1351 | try | DATA_OP | request.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-89289a34 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1352 | try | DATA_OP | request.Parameters["p_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-be1db0b5 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1354 | try | DATA_OP | request.Parameters["p_prod_ver_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-27f65182 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1355 | try | DATA_OP | request.Parameters["p_max_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-452e23b7 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1356 | try | DATA_OP | request.Parameters["p_mark"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-29813f14 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1357 | try | DATA_OP | request.Parameters["p_org_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e93c8cd3 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1358 | try | DATA_OP | request.Parameters["p_job_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dca7d78b | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1360 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6f4afd41 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1362 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-efd88b17 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:1367 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Find_Data_Excel_Buffer_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42046f00 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2734 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_EXCEL_SAVE") ⇒ FP_Master.PR_UI_FP03033_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-b78169cd | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2735 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-02709e1e | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2736 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-255a46fb | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2737 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-d956d5e1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2738 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d547e168 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2739 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9d244725 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2741 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-516734b5 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2742 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b4aef1ce | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2743 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b5b4bf49 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2744 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b79755cf | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2745 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-964ccad0 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2747 | try | DATA_OP | request.Parameters["p_model_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7de9df8c | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2748 | try | DATA_OP | request.Parameters["p_pjt_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2507cf2b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2749 | try | DATA_OP | request.Parameters["p_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1aff560f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2750 | try | DATA_OP | request.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a1e02e3a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2751 | try | DATA_OP | request.Parameters["p_prod_yn"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-52cd9513 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2753 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1c95248d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2754 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e53fa9eb | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2755 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8ac5570a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2756 | try | DATA_OP | request.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b751afed | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2757 | try | DATA_OP | request.Parameters["p_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fa27d64a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2759 | try | DATA_OP | request.Parameters["p_prod_ver_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6e86d54a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2760 | try | DATA_OP | request.Parameters["p_max_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5cfc37a2 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2761 | try | DATA_OP | request.Parameters["p_mark"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-904d2764 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2762 | try | DATA_OP | request.Parameters["p_org_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ac8c9ff5 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2763 | try | DATA_OP | request.Parameters["p_job_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-04f9a9d4 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2765 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1f721fbb | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2767 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e7649eec | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2773 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Find_Data_Excel_Sub_Buffer_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e48dc100 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3675 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP3033_SAVE") ⇒ FP_Master.PR_UI_FP3033_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-4af23cc0 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3676 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1b359716 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3677 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-3107d7b7 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3678 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-5f71bcc6 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3679 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0d05aa1b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3680 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0b34ce14 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3682 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8947be13 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3683 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-179e28d2 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3684 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c31112b8 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3685 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ebf7e4a8 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3686 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eab848c1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3687 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a4a9d2d3 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3688 | try | DATA_OP | request.Parameters["p_model_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6163eb1f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3689 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-33b23aad | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3690 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-87741764 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3691 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9f7121c6 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3692 | try | DATA_OP | request.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d548c948 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3693 | try | DATA_OP | request.Parameters["p_active_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f28b0f15 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3694 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b37f7c1c | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3696 | try | DATA_OP | request.Parameters["p_attb_1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-85209cdd | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3697 | try | DATA_OP | request.Parameters["p_attb_2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1c06ac05 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3698 | try | DATA_OP | request.Parameters["p_attb_3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a22b8645 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3699 | try | DATA_OP | request.Parameters["p_attb_4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-37d94a43 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3700 | try | DATA_OP | request.Parameters["p_attb_5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d9cc3d7 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3702 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6ba8ea2f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3704 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-dfd6cd76 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3710 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Find_Data_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82f2788a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2430 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_division_id = CString.GetCheckedListValue(dtDivision, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-53cc934a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2450 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_EXCEL_SAVE") ⇒ FP_Master.PR_UI_FP03033_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-e3eacfd9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2451 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e7848a25 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2452 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-75141ec1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2453 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_IMPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-ff3bb1e0 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2454 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-936a9b78 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2455 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6ea7f567 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2457 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aa03159b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2458 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4526b8e5 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2459 | try | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-9eee1143 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2460 | try | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-32dde2b1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2461 | try | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-41aaae4e | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2463 | try | DATA_OP | request.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-db800165 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2464 | try | DATA_OP | request.Parameters["p_pjt_code"] | p_pjt_code | 행/컬럼 값 대입 |  |  |  |
| AC-c2c763b8 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2465 | try | DATA_OP | request.Parameters["p_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-950bdf65 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2466 | try | DATA_OP | request.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b3ba44d9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2467 | try | DATA_OP | request.Parameters["p_prod_yn"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dbac7b92 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2469 | try | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-277d4089 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2470 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-47d15f62 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2471 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d3fe127 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2472 | try | DATA_OP | request.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-34a83ae5 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2473 | try | DATA_OP | request.Parameters["p_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9013559e | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2475 | try | DATA_OP | request.Parameters["p_prod_ver_type"] | p_prod_ver_type | 행/컬럼 값 대입 |  |  |  |
| AC-44f25fe3 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2476 | try | DATA_OP | request.Parameters["p_max_version"] | p_max_version | 행/컬럼 값 대입 |  |  |  |
| AC-b7554c1b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2477 | try | DATA_OP | request.Parameters["p_mark"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-45542936 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2478 | try | DATA_OP | request.Parameters["p_org_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cf8cc411 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2479 | try | DATA_OP | request.Parameters["p_job_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c9043945 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2481 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3ac864f5 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2483 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8b991dd3 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2488 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Find_Data_Sub

진입점: this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult.OK) ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / this.spdMain.CellDoubleClick [if ((iClickRow != nRow) && (nRow >= 0))] / this.btnSearchAll.Click / this.btnSubImport.Click [if (p.DialogResult == DialogResult.OK)] / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / InsertButton [if (fps.Name == "spdMain") ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (AddPopup.ShowDialog() == DialogResult.OK) ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ if (!string.IsNullOrEmpty(s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85503884 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 6 | FP03033_Model_MeasureConversion.cs:695 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5868b3e9 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 6 | FP03033_Model_MeasureConversion.cs:700 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-6826a382 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 6 | FP03033_Model_MeasureConversion.cs:700 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-80ca7e7d | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 6 | FP03033_Model_MeasureConversion.cs:702 | try | FLAG | dsSub | null | 화면 필드/플래그 변경 |  |  |  |
| AC-758b80f2 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 6 | FP03033_Model_MeasureConversion.cs:706 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f2187668 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 6 | FP03033_Model_MeasureConversion.cs:709 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2beda2cf | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 6 | FP03033_Model_MeasureConversion.cs:715 | try | FLAG | dsSub | Find_Data_Detail_Conversion(row, pAllType, searchFlag) | 화면 필드/플래그 변경 |  |  |  |
| AC-a5bb0e3b | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 6 | FP03033_Model_MeasureConversion.cs:720 | try | GRID_BIND | siSub.Query | (dsSub, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-13a074c1 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 6 | FP03033_Model_MeasureConversion.cs:721 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-04027700 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 6 | FP03033_Model_MeasureConversion.cs:724 | try | UI_MISC | SetSearchCount | (dsSub) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-481d7184 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 6 | FP03033_Model_MeasureConversion.cs:738 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP03033_Model_MeasureConversion.Find_Data_Sub_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43dd23b8 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3270 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { int iRow = 0; if (iClickRow != -1) iRow = iClickRow; if (… | ⚠ 의미 확인 필요 |  |  |  |
| AC-54be072d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3299 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION") ⇒ FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-8d2bf042 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3300 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9594d37d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3301 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-7cc16eb4 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3302 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_DETAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-b2b3ebdf | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3303 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d6be4499 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3304 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-df9edd99 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3306 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e626089f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3307 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-08be30d6 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3308 | try | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-151dd921 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3309 | try | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-2eb77697 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3310 | try | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-34a508bc | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3312 | try | DATA_OP | request.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-7f922e16 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3313 | try | DATA_OP | request.Parameters["p_pjt_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e3593ef3 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3314 | try | DATA_OP | request.Parameters["p_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-81c918e9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3315 | try | DATA_OP | request.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0b990dde | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3316 | try | DATA_OP | request.Parameters["p_prod_yn"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4d287867 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3318 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-93d51aa4 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3319 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0208dc53 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3320 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-05b062f9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3321 | try | DATA_OP | request.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ac3ec454 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3322 | try | DATA_OP | request.Parameters["p_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8db357a6 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3324 | try | DATA_OP | request.Parameters["p_prod_ver_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e1091ab1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3325 | try | DATA_OP | request.Parameters["p_max_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-200fbc22 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3326 | try | DATA_OP | request.Parameters["p_mark"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4f5894cd | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3327 | try | DATA_OP | request.Parameters["p_org_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fdcc5261 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3328 | try | DATA_OP | request.Parameters["p_job_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d49d8ffe | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3330 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3507f2b2 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3332 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8fe94709 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3337 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34263604 | this.Load | FP03033_Model_MeasureConversion.cs:149 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP03033_Model_MeasureConversion.GetDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b4c2fb0 | this.Load [try] | FP03033_Model_MeasureConversion.cs:3841 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6beab5c3 | this.Load [try] | FP03033_Model_MeasureConversion.cs:3842 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-aed283bf | this.Load [try] | FP03033_Model_MeasureConversion.cs:3842 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c5d282cf | this.Load [try] | FP03033_Model_MeasureConversion.cs:3843 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP03033_Model_MeasureConversion.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbf5de6f | this.Load | FP03033_Model_MeasureConversion.cs:172 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f7e3cf4f | this.Load | FP03033_Model_MeasureConversion.cs:175 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-232a6d33 | this.Load | FP03033_Model_MeasureConversion.cs:178 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f31095c9 | this.Load | FP03033_Model_MeasureConversion.cs:179 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-3f6add10 | this.Load | FP03033_Model_MeasureConversion.cs:184 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-9387af59 | this.Load | FP03033_Model_MeasureConversion.cs:186 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-f31ac508 | this.Load | FP03033_Model_MeasureConversion.cs:194 | try ▸ for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-716634ad | this.Load | FP03033_Model_MeasureConversion.cs:197 | try | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-57b9f6e5 | this.Load | FP03033_Model_MeasureConversion.cs:217 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-d135d88d | this.Load | FP03033_Model_MeasureConversion.cs:218 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-46a54dfe | this.Load | FP03033_Model_MeasureConversion.cs:219 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-dd9a42e6 | this.Load | FP03033_Model_MeasureConversion.cs:225 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnImport.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-125fb286 | this.Load | FP03033_Model_MeasureConversion.cs:226 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1dbfff54 | this.Load | FP03033_Model_MeasureConversion.cs:227 | try ▸ if (!_sSaveAuth.Equals("Y")) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7199836c | this.Load | FP03033_Model_MeasureConversion.cs:232 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP03033_Model_MeasureConversion.InitSpread

진입점: this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult.OK) ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try] / this.spdMain.CellDoubleClick [if ((iClickRow != nRow) && (nRow >= 0)) ▸ try] / this.btnSearchAll.Click [try] / this.btnSubImport.Click [if (p.DialogResult == DialogResult.OK) ▸ try] / this.Load / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try] / InsertButton [if (fps.Name == "spdMain") ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (AddPopup.ShowDialog() == DialogResult.OK) ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try] / SaveButton [else of (fps.Name =…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e03b4c1b | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:333 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-15defa64 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:334 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-31fffa73 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:343 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-53cac3f7 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:345 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-0089489d | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:352 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP03033_Model_MeasureConversion.Insert_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02570d96 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2679 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_EXCEL_SAVE") ⇒ FP_Master.PR_UI_FP03033_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-0a5f928f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2680 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c21f4dfa | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2682 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-960a2e96 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2683 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-43092cfc | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2684 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-71efd13f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2685 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-7c7f2023 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2687 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-7ed8dd26 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2688 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-83e9c926 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2689 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-7767d307 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2690 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-4bfb03c2 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2691 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-3029eded | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2693 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-d578e40f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2694 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pjt_code"] | p_pjt_code | 행/컬럼 값 대입 |  |  |  |
| AC-35c44fc9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2695 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-ff5cc53f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2696 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version"] | p_version | 행/컬럼 값 대입 |  |  |  |
| AC-9c5697f8 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2697 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_yn"] | p_prod_yn | 행/컬럼 값 대입 |  |  |  |
| AC-23d29bf0 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2699 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-8cd68f5b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2700 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f49f2ea1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2701 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-c9e18bac | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2702 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-d02968b1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2703 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_value"] | p_value | 행/컬럼 값 대입 |  |  |  |
| AC-badb44ae | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2705 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_ver_type"] | p_prod_ver_type | 행/컬럼 값 대입 |  |  |  |
| AC-e1726269 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2706 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_max_version"] | p_max_version | 행/컬럼 값 대입 |  |  |  |
| AC-87b1c552 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2707 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mark"] | p_mark | 행/컬럼 값 대입 |  |  |  |
| AC-f337ad1d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2708 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_version"] | p_org_version | 행/컬럼 값 대입 |  |  |  |
| AC-0345a7e9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2709 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_job_type"] | p_job_type | 행/컬럼 값 대입 |  |  |  |
| AC-5e3c93bd | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2711 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-760bd4ac | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2717 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-3f745452 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2721 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-64de62fb | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2723 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Insert_Data_Excel_Sub_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7644d6a9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3628 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP3033_SAVE") ⇒ FP_Master.PR_UI_FP3033_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-9e50d7d2 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3629 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-230b1254 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3631 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-68a18af8 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3632 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1689d3ce | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3633 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-e3891370 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3634 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2e577b0b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3636 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-c5171b4c | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3637 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3eac54d2 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3638 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-5d386ca8 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3639 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-962e02f7 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3640 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-df525662 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3641 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-a9b668a6 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3642 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-3928d8de | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3643 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ecf37a0 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3644 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-9b815dd6 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3645 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-c3ffa7c5 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3646 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version"] | p_version | 행/컬럼 값 대입 |  |  |  |
| AC-ae150b8a | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3647 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-14b28f93 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3648 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-89a5363b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3650 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_attb_1"] | p_attb_1 | 행/컬럼 값 대입 |  |  |  |
| AC-3a5fd766 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3651 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_attb_2"] | p_attb_2 | 행/컬럼 값 대입 |  |  |  |
| AC-5506eb99 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3652 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_attb_3"] | p_attb_3 | 행/컬럼 값 대입 |  |  |  |
| AC-609ed947 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3653 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_attb_4"] | p_attb_4 | 행/컬럼 값 대입 |  |  |  |
| AC-a6558e8f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3654 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_attb_5"] | p_attb_5 | 행/컬럼 값 대입 |  |  |  |
| AC-21341118 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3656 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f6e41fc0 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3661 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-e9e1e18b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3665 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-cd62ae84 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3667 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44fa5960 | InsertButton | FP03033_Model_MeasureConversion.cs:406 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6037862a | InsertButton | FP03033_Model_MeasureConversion.cs:417 | if (fps.Name == "spdMain") ▸ else of (siMain.GetMaxRowIndex() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "After Search, Try again.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d2fe3cd | InsertButton | FP03033_Model_MeasureConversion.cs:418 | if (fps.Name == "spdMain") ▸ else of (siMain.GetMaxRowIndex() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.rdoGroup1_SelectedIndexChanged

진입점: this.rdoGroup1.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f75e38c3 | this.rdoGroup1.SelectedIndexChanged | FP03033_Model_MeasureConversion.cs:1826 | if (radioGroup.SelectedIndex == 0) | FLAG | _sMaxVersion | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-500c2430 | this.rdoGroup1.SelectedIndexChanged | FP03033_Model_MeasureConversion.cs:1830 | else of (radioGroup.SelectedIndex == 0) | FLAG | _sMaxVersion | "" | 화면 필드/플래그 변경 |  |  |  |

## FP03033_Model_MeasureConversion.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58a1afff | popSql.OnSql | FP03033_Model_MeasureConversion.cs:2309 | if (programID == "PR_UI_FP03033_SELECT_MAIN") | RETURN | return Find_Data_Conversion("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-8fa7a06b | popSql.OnSql | FP03033_Model_MeasureConversion.cs:2313 | else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ if (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER") | RETURN | return Save_Data_Conversion("SQL", "INSERT_EXCEL_BUFFER"); |  | 처리 중단/반환 |  |  |  |
| AC-627be356 | popSql.OnSql | FP03033_Model_MeasureConversion.cs:2317 | else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ else of (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER") ▸ if (programID == "PR_UI_FP… | RETURN | return Save_Data_Conversion("SQL", "INSERT_UOM_INFO"); |  | 처리 중단/반환 |  |  |  |
| AC-57733fbd | popSql.OnSql | FP03033_Model_MeasureConversion.cs:2321 | else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ else of (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER") ▸ else of (programID == "PR_… | RETURN | return Save_Data_Mark("SQL", "UPDATE_MARK"); |  | 처리 중단/반환 |  |  |  |
| AC-0e9d488d | popSql.OnSql | FP03033_Model_MeasureConversion.cs:2325 | else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ else of (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER") ▸ else of (programID == "PR_… | RETURN | return Save_Data_Conversion("SQL", "INSERT_LANE"); |  | 처리 중단/반환 |  |  |  |
| AC-2441717d | popSql.OnSql | FP03033_Model_MeasureConversion.cs:2329 | else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ else of (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER") ▸ else of (programID == "PR_… | RETURN | return Save_Data_Conversion("SQL", "UPDATE_MAXVERFLAG"); |  | 처리 중단/반환 |  |  |  |
| AC-45014152 | popSql.OnSql | FP03033_Model_MeasureConversion.cs:2333 | else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ else of (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER") ▸ else of (programID == "PR_… | RETURN | return Save_Data_Conversion("SQL", "UPDATE_PANCAKE_M_BATCH"); |  | 처리 중단/반환 |  |  |  |
| AC-6ba23c71 | popSql.OnSql | FP03033_Model_MeasureConversion.cs:2337 | else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ else of (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER") ▸ else of (programID == "PR_… | RETURN | return Save_Data_Conversion("SQL", "UPDATE_PANCAKE_CELL_M"); |  | 처리 중단/반환 |  |  |  |
| AC-f1f12cfa | popSql.OnSql | FP03033_Model_MeasureConversion.cs:2341 | else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ else of (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER") ▸ else of (programID == "PR_… | RETURN | return Find_Data_Detail_Conversion(iClickRow, "ITEM", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-4fc0ea59 | popSql.OnSql | FP03033_Model_MeasureConversion.cs:2346 | else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ else of (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER") ▸ else of (programID == "PR_… | CALL_EXT | dsData.Tables[0].GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1b23886 | popSql.OnSql | FP03033_Model_MeasureConversion.cs:2348 | else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ else of (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER") ▸ else of (programID == "PR_… | RETURN | return Save_Data_query(dtSaveTmp, "MERGE_DATA", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-933523a7 | popSql.OnSql | FP03033_Model_MeasureConversion.cs:2351 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Save_Data

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d75a8f02 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:835 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03262ab8 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:837 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-361dc8f9 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:842 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-292e55d8 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:843 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d99dd1aa | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:846 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1429c7ab | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:861 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-b7d8bed8 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:863 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8b6d90e1 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:864 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25693838 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:876 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtCategoryData != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-cb143fe5 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:885 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtCategoryData != null) ▸ if (ds3.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-c4f58a9e | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:886 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtCategoryData != null) ▸ if (ds3.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cedb0a29 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:898 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtDescData != null) ▸ if (dtDescData.Rows.Count > 0) ▸ if (dsMark.Tables[0].Rows[0][0]… | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-64961ddd | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:911 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtCategoryData != null && bTrans == true) ▸ if (ds4.Tables[0].Rows[0][0].ToString() !=… | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-93f6cfda | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:912 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtCategoryData != null && bTrans == true) ▸ if (ds4.Tables[0].Rows[0][0].ToString() !=… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eeed282e | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:920 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtCategoryData != null && bTrans == true) ▸ if (ds5.Tables[0].Rows[0][0].ToString() !=… | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-b0b955c6 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:921 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtCategoryData != null && bTrans == true) ▸ if (ds5.Tables[0].Rows[0][0].ToString() !=… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5bb736bd | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:929 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtCategoryData != null && bTrans == true) ▸ if (ds6.Tables[0].Rows[0][0].ToString() !=… | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-9330d028 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:930 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtCategoryData != null && bTrans == true) ▸ if (ds6.Tables[0].Rows[0][0].ToString() !=… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a3e951d | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:938 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtCategoryData != null && bTrans == true) ▸ if (ds7.Tables[0].Rows[0][0].ToString() !=… | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-ca4a5262 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:939 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtCategoryData != null && bTrans == true) ▸ if (ds7.Tables[0].Rows[0][0].ToString() !=… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed1be945 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:943 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4ff491b5 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:948 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bTrans == true && bTransMark == true) ▸ if (dtDescData != null && bTransMark == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dtDescData.Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-92c404e6 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:950 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bTrans == true && bTransMark == true) ▸ else of (dtDescData != null && bTransMark == t… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dtCategoryData.Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-422ce93d | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:956 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7b9f4798 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:960 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bfae5d96 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:961 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f2e36b18 | SaveButton [if (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:965 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP03033_Model_MeasureConversion.Save_Data_Conversion

진입점: popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ if (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER")] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtCategoryData != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3a3bb0d | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1186 | try ▸ if (string.IsNullOrEmpty(pSysFlag)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-47fc6440 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1231 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION") ⇒ FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-1e194d76 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1232 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-960a18ca | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1234 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-8873563f | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1235 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-753e5ddb | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1236 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-13a03a30 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1237 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2ceb708e | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1239 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-176c6ce6 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1240 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a7a9792d | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1241 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-728716fb | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1242 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-8e26a9e1 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1243 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-ed61812b | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1245 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-a2a9aa36 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1246 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pjt_code"] | p_pjt_code | 행/컬럼 값 대입 |  |  |  |
| AC-1f2359ca | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1247 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-d6077b7e | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1248 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version"] | p_version | 행/컬럼 값 대입 |  |  |  |
| AC-f2d8bd9b | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1249 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_yn"] | p_prod_yn | 행/컬럼 값 대입 |  |  |  |
| AC-436db269 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1251 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-fad9d921 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1252 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-686b02d3 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1253 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-121a9581 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1254 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-b008f379 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1255 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_value"] | p_value | 행/컬럼 값 대입 |  |  |  |
| AC-e533a461 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1257 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_ver_type"] | p_prod_ver_type | 행/컬럼 값 대입 |  |  |  |
| AC-0d85437c | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1258 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_max_version"] | p_max_version | 행/컬럼 값 대입 |  |  |  |
| AC-e4adce08 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1259 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mark"] | p_mark | 행/컬럼 값 대입 |  |  |  |
| AC-2a865283 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1260 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_version"] | p_org_version | 행/컬럼 값 대입 |  |  |  |
| AC-e6c89390 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1261 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_job_type"] | p_job_type | 행/컬럼 값 대입 |  |  |  |
| AC-3799c5cf | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1263 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b3345c30 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1264 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8d2cf4de | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1270 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-617053ee | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1276 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Save_Data_Delete

진입점: SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtCategoryData != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abb39595 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1107 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION") ⇒ FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-39ae5723 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1108 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9a37a33d | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1110 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-89d21b29 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1111 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-c12ecfd1 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1112 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-828324dc | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1113 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1279f609 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1115 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-747fee6d | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1116 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c01e2715 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1117 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4d0ca46b | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1118 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d2281b14 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1119 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fcbb03f5 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1121 | try | DATA_OP | req.Parameters["p_model_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6c6e0966 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1122 | try | DATA_OP | req.Parameters["p_pjt_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b3baaa7c | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1123 | try | DATA_OP | req.Parameters["p_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0aa46470 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1124 | try | DATA_OP | req.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aa0f7255 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1125 | try | DATA_OP | req.Parameters["p_prod_yn"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aa99516c | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1127 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a9cdbb47 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1128 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b96ba671 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1129 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c61c4cf0 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1130 | try | DATA_OP | req.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-459897c2 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1131 | try | DATA_OP | req.Parameters["p_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1a0d3547 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1133 | try | DATA_OP | req.Parameters["p_prod_ver_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3d9d3b4c | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1134 | try | DATA_OP | req.Parameters["p_max_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-68080ec6 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1135 | try | DATA_OP | req.Parameters["p_mark"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-66a9f0c9 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1136 | try | DATA_OP | req.Parameters["p_org_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d22a1320 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1137 | try | DATA_OP | req.Parameters["p_job_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4c3ec83b | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1139 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-285cb636 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1140 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-988bf583 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.Sh… | FP03033_Model_MeasureConversion.cs:1145 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Save_Data_Excel_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-412bb291 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2882 | try ▸ if (string.IsNullOrEmpty(pSysFlag)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ede5a172 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2927 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_EXCEL_SAVE") ⇒ FP_Master.PR_UI_FP03033_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-ea391e1f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2928 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a1e2696f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2930 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-ae8a65b8 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2931 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0af1df9b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2932 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-7a6f2d99 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2933 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-bf9d0f72 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2935 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-4f43f695 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2936 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-97e88f72 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2937 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-caa2c2d3 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2938 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-e8a728fb | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2939 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-86df9d72 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2941 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-5446575b | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2942 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pjt_code"] | p_pjt_code | 행/컬럼 값 대입 |  |  |  |
| AC-01e8c880 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2943 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-ea40e9d0 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2944 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version"] | p_version | 행/컬럼 값 대입 |  |  |  |
| AC-cc5ff374 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2945 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_yn"] | p_prod_yn | 행/컬럼 값 대입 |  |  |  |
| AC-c80e06ac | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2947 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-161a11e1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2948 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3e650c25 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2949 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-b794d5e1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2950 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-2e76c49f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2951 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_value"] | p_value | 행/컬럼 값 대입 |  |  |  |
| AC-0ad201fb | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2953 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_ver_type"] | p_prod_ver_type | 행/컬럼 값 대입 |  |  |  |
| AC-fa6c4c42 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2954 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_max_version"] | p_max_version | 행/컬럼 값 대입 |  |  |  |
| AC-812f4ca2 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2955 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mark"] | p_mark | 행/컬럼 값 대입 |  |  |  |
| AC-3cfa107e | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2956 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_version"] | p_org_version | 행/컬럼 값 대입 |  |  |  |
| AC-c6a8ea94 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2957 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_job_type"] | p_job_type | 행/컬럼 값 대입 |  |  |  |
| AC-f81174c5 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2959 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a0d14bb7 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2960 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-276a524d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2966 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ff29cfbf | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:2972 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Save_Data_Excel_Sub_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1853d1f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3367 | try ▸ if (string.IsNullOrEmpty(pSysFlag)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-93ee5ff0 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3371 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP3033_SAVE") ⇒ FP_Master.PR_UI_FP3033_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-3f01295f | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3372 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bf69c563 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3374 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-6f0da0b9 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3375 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-4476b4c8 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3376 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bedc1136 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3377 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8eecef50 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3379 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2a75561d | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3380 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ee321583 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3381 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9f316e46 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3382 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-95e72752 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3383 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f0adead4 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3384 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2dce47ea | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3385 | try | DATA_OP | req.Parameters["p_model_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ffa25526 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3386 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9dcd7957 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3387 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bd0015fa | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3388 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5637171c | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3389 | try | DATA_OP | req.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e1880c55 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3390 | try | DATA_OP | req.Parameters["p_active_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b9318d73 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3391 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-df655317 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3393 | try | DATA_OP | req.Parameters["p_attb_1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c33e3c25 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3394 | try | DATA_OP | req.Parameters["p_attb_2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8efa4463 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3395 | try | DATA_OP | req.Parameters["p_attb_3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-58607dd1 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3396 | try | DATA_OP | req.Parameters["p_attb_4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d1774723 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3397 | try | DATA_OP | req.Parameters["p_attb_5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-487e2d75 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3399 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6e3b5dad | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3400 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f33226e7 | (진입점 미연결) | FP03033_Model_MeasureConversion.cs:3405 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Save_Data_Mark

진입점: popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ else of (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER") ▸ else of (programID == "PR_UI_FP03033_INSERT_UOM_INFO") ▸ if (programID == "PR_UI_FP03033_UPDATE_MARK")] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (dtDescData != null) ▸ if (dtDescData.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbfcefc1 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1004 | try ▸ if (string.IsNullOrEmpty(pSysFlag)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-dcea6ee9 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1045 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION") ⇒ FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-9dddb9be | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1046 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-10147406 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1048 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-1523e71f | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1049 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-3e18a3d2 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1050 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-f9476e35 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1051 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-3edd296e | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1053 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-ea97a707 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1054 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7d9a7fc6 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1055 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-1eebdd59 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1056 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-34fd272b | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1057 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-98744359 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1059 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-5c29679c | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1060 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pjt_code"] | p_pjt_code | 행/컬럼 값 대입 |  |  |  |
| AC-0907afe2 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1061 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-32b75167 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1062 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version"] | p_version | 행/컬럼 값 대입 |  |  |  |
| AC-374e5d82 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1063 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_yn"] | p_prod_yn | 행/컬럼 값 대입 |  |  |  |
| AC-19d4fbd3 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1065 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-4b68b459 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1066 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f616e1e2 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1067 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-d9146924 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1068 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-09cdfc5c | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1069 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_value"] | p_value | 행/컬럼 값 대입 |  |  |  |
| AC-f4aedc0d | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1071 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_ver_type"] | p_prod_ver_type | 행/컬럼 값 대입 |  |  |  |
| AC-119c7b1f | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1072 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_max_version"] | p_max_version | 행/컬럼 값 대입 |  |  |  |
| AC-674a7835 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1073 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mark"] | p_mark | 행/컬럼 값 대입 |  |  |  |
| AC-7e57da47 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1074 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_version"] | p_org_version | 행/컬럼 값 대입 |  |  |  |
| AC-9e9d27e9 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1075 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_job_type"] | p_job_type | 행/컬럼 값 대입 |  |  |  |
| AC-aca46e03 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1077 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c51c3f14 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1078 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ce518809 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1084 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6e57523c | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1090 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Save_Data_query

진입점: popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MAIN") ▸ else of (programID == "PR_UI_FP03033_INSERT_EXCEL_BUFFER") ▸ else of (programID == "PR_UI_FP03033_INSERT_UOM_INFO") ▸ else of (programID == "PR_UI_FP03033_UPDATE_MARK") ▸ else of (programID == "PR_UI_FP03033_INSERT_LANE") ▸ else of (programID == "PR_UI_FP03033_UPDATE_MAXVERFLAG") ▸ else of (programID == "PR_UI_FP03033_UPDATE_PANCAKE_M_BATCH") ▸ else of (programID == "PR_UI_FP03033_UPDATE_PANCAKE_CELL_M") ▸ else of (programID == "PR_UI_FP03033_SELECT_DETAIL") ▸ if (programID == "PR_UI_FP03033_SAVE_DETAIL")] / SaveButton [else of…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e92d3bed | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1578 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP3033_SAVE") ⇒ FP_Master.PR_UI_FP3033_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-ac5ef689 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1579 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-dc6833ab | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1581 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-32e6e9e4 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1582 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0c5af498 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1583 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-115a4fbd | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1584 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a82a6bd9 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1586 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-b04d1eef | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1587 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b1f7df0f | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1588 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d0429cdd | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1589 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-655c946d | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1590 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-f0e16c12 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1591 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-f0568f7d | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1592 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-fea5378d | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1593 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-290b3319 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1594 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-99c2b857 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1595 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-e4d75fe2 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1596 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version"] | p_version | 행/컬럼 값 대입 |  |  |  |
| AC-20413cc0 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1597 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b92852cd | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1598 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-33b358e9 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1600 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_attb_1"] | p_attb_1 | 행/컬럼 값 대입 |  |  |  |
| AC-c2cfe6c2 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1601 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_attb_2"] | p_attb_2 | 행/컬럼 값 대입 |  |  |  |
| AC-9e9004a5 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1602 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_attb_3"] | p_attb_3 | 행/컬럼 값 대입 |  |  |  |
| AC-af1f83ff | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1603 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_attb_4"] | p_attb_4 | 행/컬럼 값 대입 |  |  |  |
| AC-46ff1ab9 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1604 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_attb_5"] | p_attb_5 | 행/컬럼 값 대입 |  |  |  |
| AC-f89d14f5 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1606 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8f56d2e4 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1607 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d502e1a7 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1612 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-9c22ea16 | popSql.OnSql [else of (programID == "PR_UI_FP03033_SELECT_MA… 외 1 | FP03033_Model_MeasureConversion.cs:1617 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.Save_Data_Sub

진입점: SaveButton [else of (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23bee6f6 | SaveButton [else of (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:1379 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44294732 | SaveButton [else of (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:1395 | try ▸ catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-c31cee8f | SaveButton [else of (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:1409 | try ▸ if (!string.IsNullOrEmpty(sMsg)) | MESSAGE | MessageBox.Show | (sMsg) | 메시지 표시 |  |  |  |
| AC-9d0e465d | SaveButton [else of (fps.Name == "spdMain")] | FP03033_Model_MeasureConversion.cs:1418 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |

## FP03033_Model_MeasureConversion.Save_Detail

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01f0f05c | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1433 | if (siMain == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-abd4d2bf | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1436 | if (dsSub == null \|\| dsSub.Tables[0].Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e245a888 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1441 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c66d69be | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1442 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-24a94bcb | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1447 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-dda6157b | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1454 | try | DATA_OP | (dsSub.Tables[0]).Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9dc2a64b | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1455 | try | STATE_RESET | dtSaveTmp.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-3b0c95b4 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1462 | try ▸ for (i < dsSub.Tables[0].Rows.Count) ▸ if (siSub.ActiveSheet.Cells[i, 0].Value != null) | CALL_EXT | dtSaveTmp.copyInsert | ((dsSub.Tables[0]).Rows[i]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-58c62368 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1468 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b495c7ba | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1484 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4e8b0157 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1485 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-942b8820 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1487 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-db45af11 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1490 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f40a8912 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1492 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-293e2434 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1496 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ec2f2559 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1497 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-38ab0c61 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1498 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-b24652f8 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1499 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5e0a714d | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1503 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-928ba5e2 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ try] | FP03033_Model_MeasureConversion.cs:1504 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP03033_Model_MeasureConversion.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51ecb6fb | SaveButton | FP03033_Model_MeasureConversion.cs:569 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP03033_Model_MeasureConversion.SetChangeControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0726ef0 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3777 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5024660c | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3777 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3eed8cff | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3782 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter["DIVISION_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-65f9447e | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3786 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d54f255 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3786 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b6c889a1 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3788 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)cboSite is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-56ab8703 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3790 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)cboSite is UsrCombo) ▸ if ((object)cboSite … | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-80336766 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3796 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-8aa56732 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3797 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-80a2a511 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3797 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3a3a794e | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3799 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1400af34 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3801 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlant is Usr… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cf629b71 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3807 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-778886bb | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3808 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-4f9857ee | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3808 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1676a696 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3810 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ if ((object)clbFactory is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bfe0f677 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3812 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ else of ((object)clbFactory is UsrCombo) ▸ if ((object)clbFactory … | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7fef0d77 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3819 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | DATA_OP | Filter["FACTORY_ID"] | sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-0aa7ab12 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3820 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5fbce831 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3820 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c5d6679d | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3822 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ if ((object)clbOperation is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, (object)clbOperation as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5e1bd905 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3824 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ else of ((object)clbOperation is UsrCombo) ▸ if ((object)clbOp… | LIST_REBIND | clsCtrl.setListBox | (dtOperation, (object)clbOperation as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5b7813f0 | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3833 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | Filter["OPERATION"] = pActive | 행/컬럼 값 대입 |  |  |  |
| AC-94dd82ec | this.Load [try] 외 5 | FP03033_Model_MeasureConversion.cs:3833 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION"] | pActive | 행/컬럼 값 대입 |  |  |  |

## FP03033_Model_MeasureConversion.SetColorSheetDefault

진입점: this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (dsMain.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] / InsertButton [if (fps.Name == "spdMain") ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (AddPopup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (dsMain.Tables[0].Rows.Count > 0)] / EditButton [if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (spdMain != null)] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (bTrans == true && bTransMark == true) ▸ try ▸ if (dsMain.Tables[0]…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f07aa4a5 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:746 |  | GRID_STYLE | siMain.SetBGColor | (0, 0, siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.ITEM_ID), System.Drawing.… | 그리드 표시 설정 |  |  |  |
| AC-bc01be8a | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:747 |  | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.PROD_VERSION_TYPE), siMain.GetMaxRowIndex(), siMain.G… | 그리드 표시 설정 |  |  |  |
| AC-f3b745fd | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 4 | FP03033_Model_MeasureConversion.cs:748 |  | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.APPLY_DATE), siMain.GetMaxRowIndex(), siMain.GetColum… | 그리드 표시 설정 |  |  |  |

## FP03033_Model_MeasureConversion.SetHiddenColmn

진입점: this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult.OK) ▸ finally] / this.spdMain.CellDoubleClick [if ((iClickRow != nRow) && (nRow >= 0)) ▸ try ▸ try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / this.btnSearchAll.Click [try ▸ try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / this.btnSubImport.Click [if (p.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / this.Load [try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / FindButton [finally] / InsertButton [if (fps.Name == "spdMain") ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (AddPo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fe17403 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:382 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-91df8221 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:383 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PROD_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4f43f7aa | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:384 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9544c504 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:385 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.EDIT_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP03033_Model_MeasureConversion.SetSpreadInit

진입점: this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult.OK) ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try ▸ try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if ((iClickRow != nRow) && (nRow >= 0)) ▸ try ▸ try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / this.btnSearchAll.Click [try ▸ try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / this.btnSubImport.Click [if (p.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / this.Load [try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / FindButton …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83cb9827 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:361 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5ca14b5f | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:362 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-85449273 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:367 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-8ea52ab7 | this.btnAdd.Click [if (AddPopup.ShowDialog() == DialogResult… 외 7 | FP03033_Model_MeasureConversion.cs:368 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.ITEM_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP03033_Model_MeasureConversion.SetWideRange

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d79c78a | this.Load [try] | FP03033_Model_MeasureConversion.cs:2287 |  | FLAG | dtWideRange | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP03033_ModelMeasure_Conversion", "… | 화면 필드/플래그 변경 |  |  |  |
| AC-b40ae8b0 | this.Load [try] | FP03033_Model_MeasureConversion.cs:2287 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP03033_ModelMeasure_Conversion", "WIDE_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1c5eec5 | this.Load [try] | FP03033_Model_MeasureConversion.cs:2296 |  | LIST_REBIND | clsCtrl.setListBox | (dtWideRange, cboWideRange, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP03033_Model_MeasureConversion.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-603834c9 | this.spdMain.CellClick | FP03033_Model_MeasureConversion.cs:1873 | if (e.Column == siMain.GetColumnIndex(DefColumns.LANE_NUMBER) && sEditFlag.Equals("Y")) | CALL_EXT | siMain.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-89ac643a | this.spdMain.CellClick | FP03033_Model_MeasureConversion.cs:1875 | if (e.Column == siMain.GetColumnIndex(DefColumns.LANE_NUMBER) && sEditFlag.Equals("Y")) | CALL_EXT | siMain.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-79f31efd | this.spdMain.CellClick | FP03033_Model_MeasureConversion.cs:1885 | if (e.Column == siMain.GetColumnIndex(DefColumns.LANE_NUMBER) && sEditFlag.Equals("Y")) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible … | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP03033_find_Lane", pDivision, pSite, pPlant, pFactory, pItem, pProdVerT… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4356a08 | this.spdMain.CellClick | FP03033_Model_MeasureConversion.cs:1887 | if (e.Column == siMain.GetColumnIndex(DefColumns.LANE_NUMBER) && sEditFlag.Equals("Y")) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible … | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.LANE_NUMBER), dtLane) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## FP03033_Model_MeasureConversion.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18a8a205 | this.spdMain.CellDoubleClick | FP03033_Model_MeasureConversion.cs:1901 |  | FLAG | iClickRow | nRow | 화면 필드/플래그 변경 |  |  |  |

## FP03033_Model_MeasureConversion.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a213a26d | dsdmMain.Changed | FP03033_Model_MeasureConversion.cs:1965 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_BATCH) \|\| e.Column == siMain… | CALL_EXT | siMain.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c8cada3 | dsdmMain.Changed | FP03033_Model_MeasureConversion.cs:1969 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_BATCH) \|\| e.Column == siMain… | GRID_SET | siMain.SetValue | (e.Row, xCol1, "M") | 그리드 값 설정 |  |  |  |
| AC-03e34559 | dsdmMain.Changed | FP03033_Model_MeasureConversion.cs:1974 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_BATCH) \|\| e.Column == s… | CALL_EXT | siMain.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-17ad7dc8 | dsdmMain.Changed | FP03033_Model_MeasureConversion.cs:1976 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CELL_BATCH) \|\| e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, xCol1, "M") | 그리드 값 설정 |  |  |  |


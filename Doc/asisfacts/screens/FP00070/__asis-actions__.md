# AS-IS 액션 대조표 — FP00070

> 원천: `Doc/asisfacts/screens/FP00070/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 108행 · 메서드 23 · 종류 DATA_OP 19 · GRID_INIT 13 · RETURN 13 · FLAG 12 · LIST_REBIND 8 · COMBO_DATA 7 · UI_PROP 6 · ENDPOINT 6 · POPUP 4 · STATE 4 · UI_MISC 4 · MESSAGE 4 · GRID_LOCK 2 · STATE_RESET 1 · EXCEL 1 · CALL_BASE 1 · THROW 1 · GRID_BIND 1 · VALIDATE 1 · ⚠ 의미 확인 필요 1


## FP00070_Operation.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1f28888 | this.btnSql.Click | FP00070_Operation.cs:309 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-74acb99f | this.btnSql.Click | FP00070_Operation.cs:310 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d38862e8 | this.btnSql.Click | FP00070_Operation.cs:312 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00070_GET_OPERATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-f7bd61c8 | this.btnSql.Click | FP00070_Operation.cs:313 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00070_Operation.CboOperationGroup_SelectedIndexChanged

진입점: cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e30726c1 | cboOperationGroup.SelectedIndexChanged | FP00070_Operation.cs:685 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, true, UserInfoContext.Current.UserId, null, null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-32cbb3b2 | cboOperationGroup.SelectedIndexChanged | FP00070_Operation.cs:685 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, true, UserInfoContext.Current.UserId, null, null , null, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-92803811 | cboOperationGroup.SelectedIndexChanged | FP00070_Operation.cs:692 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00070_Operation.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02ae0756 | cboSite.SelectedIndexChanged | FP00070_Operation.cs:669 |  | FLAG | dtOperationGroup | Data_FP.Common_FP(Data_FP.Type.OPERATION_GROUP, true, UserInfoContext.Current.UserId, null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION_GROUP] | 화면 필드/플래그 변경 |  |  |  |
| AC-0e1dfdb9 | cboSite.SelectedIndexChanged | FP00070_Operation.cs:669 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION_GROUP, true, UserInfoContext.Current.UserId, null, null , null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION_GROUP] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d259c21e | cboSite.SelectedIndexChanged | FP00070_Operation.cs:673 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00070_Operation.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8891056 | clbDivision.SelectedIndexChanged | FP00070_Operation.cs:654 |  | FLAG | dtOperationGroup | Data_FP.Common_FP(Data_FP.Type.OPERATION_GROUP, true, UserInfoContext.Current.UserId, null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION_GROUP] | 화면 필드/플래그 변경 |  |  |  |
| AC-0fce28ad | clbDivision.SelectedIndexChanged | FP00070_Operation.cs:654 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION_GROUP, true, UserInfoContext.Current.UserId, null, null , null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION_GROUP] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-16459f00 | clbDivision.SelectedIndexChanged | FP00070_Operation.cs:658 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00070_Operation.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba7680a0 | (진입점 미연결) | FP00070_Operation.cs:151 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7e7591a8 | (진입점 미연결) | FP00070_Operation.cs:152 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00070_Operation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35188e34 | this.Load | FP00070_Operation.cs:165 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e2b2baf6 | this.Load | FP00070_Operation.cs:166 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ecae8da3 | this.Load | FP00070_Operation.cs:168 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00070_Operation.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b61cbe42 | this.Load | FP00070_Operation.cs:113 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-661ed0a4 | this.Load | FP00070_Operation.cs:114 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-0c0162d2 | this.Load | FP00070_Operation.cs:115 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-14160d31 | this.Load | FP00070_Operation.cs:119 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-31a24eb2 | this.Load | FP00070_Operation.cs:120 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-78304660 | this.Load | FP00070_Operation.cs:121 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00070_Operation.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b8171da | DeleteButton | FP00070_Operation.cs:274 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c09d652 | DeleteButton | FP00070_Operation.cs:278 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c44cbb95 | DeleteButton | FP00070_Operation.cs:283 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP00070_Operation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc2b85bc | Dispose | FP00070_Operation.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00070_Operation.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51b4c656 | EditButton | FP00070_Operation.cs:251 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7139ec54 | EditButton | FP00070_Operation.cs:252 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4c7941fd | EditButton | FP00070_Operation.cs:256 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e9826d72 | EditButton | FP00070_Operation.cs:258 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |

## FP00070_Operation.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78e55609 | ExcelButton | FP00070_Operation.cs:302 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00070_Operation.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION")] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ lambda] / SaveButton [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfe8fae3 | popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION"… 외 2 | FP00070_Operation.cs:426 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pDivisionID = CString.GetCheckedListValue(dtDivision, clb… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c336bdd | popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION"… 외 2 | FP00070_Operation.cs:450 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00070_GET_OPERATION") ⇒ FP_Master.PR_UI_FP00070_GET_OPERATION | 엔드포인트 요청 생성 |  |  |  |
| AC-03b098da | popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION"… 외 2 | FP00070_Operation.cs:451 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-243b04c0 | popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION"… 외 2 | FP00070_Operation.cs:452 | try | DATA_OP | request.Parameters["p_sys_flag"] | "R" | 행/컬럼 값 대입 |  |  |  |
| AC-04597568 | popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION"… 외 2 | FP00070_Operation.cs:453 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-13bb1310 | popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION"… 외 2 | FP00070_Operation.cs:454 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2935285b | popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION"… 외 2 | FP00070_Operation.cs:455 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-145087cd | popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION"… 외 2 | FP00070_Operation.cs:456 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-17394819 | popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION"… 외 2 | FP00070_Operation.cs:457 | try | DATA_OP | request.Parameters["p_operation_group_id"] | pOperationGroupID.Equals("ALL") ? DBNull.Value : pOperationGroupID | 행/컬럼 값 대입 |  |  |  |
| AC-c77af853 | popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION"… 외 2 | FP00070_Operation.cs:458 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-670771d6 | popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION"… 외 2 | FP00070_Operation.cs:460 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-60b62050 | popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION"… 외 2 | FP00070_Operation.cs:462 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-048cf91f | popSql.OnSql [if (programID == "PR_UI_FP00070_GET_OPERATION"… 외 2 | FP00070_Operation.cs:469 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00070_Operation.FindData_Plant

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0eb21423 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | FP00070_Operation.cs:347 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-19a50b39 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | FP00070_Operation.cs:352 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d3d6a2ed | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | FP00070_Operation.cs:353 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef7d439c | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | FP00070_Operation.cs:356 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d95b74cb | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | FP00070_Operation.cs:363 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-68fb9cfb | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | FP00070_Operation.cs:367 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d876437e | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | FP00070_Operation.cs:382 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b53998b8 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | FP00070_Operation.cs:384 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a8cddebd | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | FP00070_Operation.cs:394 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1bede84c | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | FP00070_Operation.cs:395 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5a318c44 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | FP00070_Operation.cs:398 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b8268cf4 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | FP00070_Operation.cs:411 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-edd95667 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | FP00070_Operation.cs:412 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00070_Operation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d3b2981 | this.Load | FP00070_Operation.cs:95 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00070_Operation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a24898c | this.Load | FP00070_Operation.cs:127 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-34583ab9 | this.Load | FP00070_Operation.cs:130 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, true, UserInfoContext.Current.UserId) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-8fce34a1 | this.Load | FP00070_Operation.cs:130 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, true, UserInfoContext.Current.UserId) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-418c011c | this.Load | FP00070_Operation.cs:131 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-57e6ab53 | this.Load | FP00070_Operation.cs:134 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, true, UserInfoContext.Current.UserId) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-17ff439d | this.Load | FP00070_Operation.cs:134 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, true, UserInfoContext.Current.UserId) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7839faba | this.Load | FP00070_Operation.cs:135 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f1f08963 | this.Load | FP00070_Operation.cs:138 |  | FLAG | dtOperationGroup | Data_FP.Common_FP(Data_FP.Type.OPERATION_GROUP, true, UserInfoContext.Current.UserId, null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION_GROUP] | 화면 필드/플래그 변경 |  |  |  |
| AC-0fffe682 | this.Load | FP00070_Operation.cs:138 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION_GROUP, true, UserInfoContext.Current.UserId, null, null) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION_GROUP] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e9d7559c | this.Load | FP00070_Operation.cs:139 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fabf2318 | this.Load | FP00070_Operation.cs:142 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, true, UserInfoContext.Current.UserId, null, null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-ca62cbda | this.Load | FP00070_Operation.cs:142 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, true, UserInfoContext.Current.UserId, null, null) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1f1ecd0c | this.Load | FP00070_Operation.cs:143 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00070_Operation.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8ea4b9c | this.Load | FP00070_Operation.cs:201 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00070_Operation.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-422a725a | this.Load | FP00070_Operation.cs:178 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-475bb28d | this.Load | FP00070_Operation.cs:179 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00070_Operation.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77dea1f9 | popSql.OnSql | FP00070_Operation.cs:323 | if (programID == "PR_UI_FP00070_GET_OPERATION") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-5eb4443f | popSql.OnSql | FP00070_Operation.cs:326 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00070_Operation.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25ed37d3 | SaveButton | FP00070_Operation.cs:519 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35d48b0d | SaveButton | FP00070_Operation.cs:521 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33007e3f | SaveButton | FP00070_Operation.cs:523 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-205a861c | SaveButton | FP00070_Operation.cs:528 | if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-808704d1 | SaveButton | FP00070_Operation.cs:530 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6d79361 | SaveButton | FP00070_Operation.cs:584 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0002_SAVE_LINE_MASTER_OSP") ⇒ SCP.SCP0002_SAVE_LINE_MASTER_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-773251e8 | SaveButton | FP00070_Operation.cs:587 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Master.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c540d7f8 | SaveButton | FP00070_Operation.cs:591 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3938674b | SaveButton | FP00070_Operation.cs:593 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c0ec54af | SaveButton | FP00070_Operation.cs:594 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e8ecca10 | SaveButton | FP00070_Operation.cs:595 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-46d256ee | SaveButton | FP00070_Operation.cs:596 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-d815d9f7 | SaveButton | FP00070_Operation.cs:597 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-ba87fe96 | SaveButton | FP00070_Operation.cs:598 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-ab413e6a | SaveButton | FP00070_Operation.cs:599 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-91183eed | SaveButton | FP00070_Operation.cs:600 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-a7b5dfd1 | SaveButton | FP00070_Operation.cs:602 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc3fa058 | SaveButton | FP00070_Operation.cs:602 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-4b7097b7 | SaveButton | FP00070_Operation.cs:611 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a7503eb4 | SaveButton | FP00070_Operation.cs:630 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00070_Operation.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6d9a772 | SaveButton | FP00070_Operation.cs:291 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00070_Operation.SetChangedControl

진입점: this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99cdbea6 | this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.F… | FP00070_Operation.cs:160 |  | DATA_OP | dtSite.Select | ("DIVISION_ID = '" + pDivisionID + "'") | 데이터 객체 조작/조회 |  |  |  |

## FP00070_Operation.SetSpreadInit

진입점: this.Load / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58331565 | this.Load 외 2 | FP00070_Operation.cs:186 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a14a36e3 | this.Load 외 2 | FP00070_Operation.cs:187 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-064f107f | this.Load 외 2 | FP00070_Operation.cs:191 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f531b322 | this.Load 외 2 | FP00070_Operation.cs:192 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (1) | 그리드 재구성/초기화 |  |  |  |
| AC-85634329 | this.Load 외 2 | FP00070_Operation.cs:194 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-d785eeb5 | this.Load 외 2 | FP00070_Operation.cs:196 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00070_Operation.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21549a59 | this.spdMain.ActiveSheetChanged | FP00070_Operation.cs:221 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-08fecf64 | this.spdMain.ActiveSheetChanged | FP00070_Operation.cs:222 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |


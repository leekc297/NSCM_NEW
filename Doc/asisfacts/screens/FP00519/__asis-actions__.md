# AS-IS 액션 대조표 — FP00519

> 원천: `Doc/asisfacts/screens/FP00519/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 130행 · 메서드 20 · 종류 DATA_OP 27 · FLAG 27 · RETURN 17 · UI_PROP 11 · MESSAGE 5 · ENDPOINT 5 · POPUP 4 · GRID_INIT 4 · STATE 4 · UI_MISC 4 · COMBO_DATA 4 · GRID_LOCK 3 · LIST_REBIND 3 · GRID_SET 2 · VALIDATE 2 · THROW 2 · CALL_EXT 2 · EXCEL 1 · GRID_BIND 1 · CALL_BASE 1 · GRID_COMBO 1 · ⚠ 의미 확인 필요 3


## FP00519_PJT_Status_Production_Type.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcc1f2c2 | this.btnSql.Click | FP00519_PJT_Status_Production_Type.cs:299 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-21378716 | this.btnSql.Click | FP00519_PJT_Status_Production_Type.cs:300 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f24780c1 | this.btnSql.Click | FP00519_PJT_Status_Production_Type.cs:302 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3b92b00 | this.btnSql.Click | FP00519_PJT_Status_Production_Type.cs:303 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00519_PJT_Status_Production_Type.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e394b97f | (진입점 미연결) | FP00519_PJT_Status_Production_Type.cs:698 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00519_PJT_Status_Production_Type.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cae8f62 | this.Load | FP00519_PJT_Status_Production_Type.cs:217 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-31c75d16 | this.Load | FP00519_PJT_Status_Production_Type.cs:218 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4f847c68 | this.Load | FP00519_PJT_Status_Production_Type.cs:220 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00519_PJT_Status_Production_Type.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d1f2980 | this.Load | FP00519_PJT_Status_Production_Type.cs:125 |  | UI_PROP | siMain.ImagePopUp | imgList.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-f47c596d | this.Load | FP00519_PJT_Status_Production_Type.cs:127 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-e723df95 | this.Load | FP00519_PJT_Status_Production_Type.cs:128 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-1f98cc96 | this.Load | FP00519_PJT_Status_Production_Type.cs:129 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-504368d8 | this.Load | FP00519_PJT_Status_Production_Type.cs:134 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-98a48902 | this.Load | FP00519_PJT_Status_Production_Type.cs:135 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-e3c7ed79 | this.Load | FP00519_PJT_Status_Production_Type.cs:136 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-011657de | this.Load | FP00519_PJT_Status_Production_Type.cs:140 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3aab2fb3 | this.Load | FP00519_PJT_Status_Production_Type.cs:141 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-fd8a5d5b | this.Load | FP00519_PJT_Status_Production_Type.cs:142 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00519_PJT_Status_Production_Type.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54105ffe | Dispose | FP00519_PJT_Status_Production_Type.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00519_PJT_Status_Production_Type.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-418723a1 | EditButton | FP00519_PJT_Status_Production_Type.cs:250 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-48cdc70a | EditButton | FP00519_PJT_Status_Production_Type.cs:252 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-597a3734 | EditButton | FP00519_PJT_Status_Production_Type.cs:254 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.PJT_PROGR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d3ad8a65 | EditButton | FP00519_PJT_Status_Production_Type.cs:261 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-dd492bf8 | EditButton | FP00519_PJT_Status_Production_Type.cs:266 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-b7988604 | EditButton | FP00519_PJT_Status_Production_Type.cs:267 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.DefaultBackColor | 그리드 속성/값 설정 |  |  |  |

## FP00519_PJT_Status_Production_Type.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-716e2f13 | ExcelButton | FP00519_PJT_Status_Production_Type.cs:292 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00519_PJT_Status_Production_Type.Find_Data

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3f35d34 | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:311 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7408e0dd | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:317 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-edc21de5 | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:318 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e111f0e0 | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:321 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-362bfb4d | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:323 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-703bba47 | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:323 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-de10deb7 | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:329 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2045107c | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:336 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8eef8cd8 | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:337 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6c023633 | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:346 | try | GRID_BIND | siMain.Query | (ds,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a8d20ede | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:347 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4ac565ba | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:350 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fa931f07 | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:363 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-948feb6f | FindButton 외 1 | FP00519_PJT_Status_Production_Type.cs:364 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00519_PJT_Status_Production_Type.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20fb338c | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:383 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pInstanceID = CString.GetCheckedListValue(dtInstance, cbo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e265f39d | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:385 | try ▸ lambda | FLAG | pInstanceID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-69dd21a0 | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:386 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-0ad796a5 | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:388 | try ▸ lambda | FLAG | pShopGroupID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues, "SHOP_GROUP_ID", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-b0b7e62f | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:413 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE") ⇒ FP_Master.PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE | 엔드포인트 요청 생성 |  |  |  |
| AC-ae748cf1 | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:414 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-da83f720 | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:415 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-ce07677c | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:416 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-a2cc5d57 | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:417 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0492b89d | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:418 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-03176770 | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:420 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstanceID.Equals("ALL") ? DBNull.Value : pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-5e2975ad | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:421 | try | DATA_OP | request.Parameters["p_shop_group_id"] | pShopGroupID.Equals("ALL") ? DBNull.Value : pShopGroupID | 행/컬럼 값 대입 |  |  |  |
| AC-35e6d25e | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:422 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-cac020d1 | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:423 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-0c749919 | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:424 | try | DATA_OP | request.Parameters["p_nick_name"] | pNicKName.Equals("ALL") ? DBNull.Value : pNicKName | 행/컬럼 값 대입 |  |  |  |
| AC-b4ba2368 | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:425 | try | DATA_OP | request.Parameters["p_applied_model"] | pAppliedModel.Equals("ALL") ? DBNull.Value : pAppliedModel | 행/컬럼 값 대입 |  |  |  |
| AC-ae91665c | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:426 | try | DATA_OP | request.Parameters["p_item_class_id"] | pItemClassID.Equals("ALL") ? DBNull.Value : pItemClassID | 행/컬럼 값 대입 |  |  |  |
| AC-173d319c | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:427 | try | DATA_OP | request.Parameters["p_item_class_name"] | pItemClassName.Equals("ALL") ? DBNull.Value : pItemClassName | 행/컬럼 값 대입 |  |  |  |
| AC-d2664ac4 | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:428 | try | DATA_OP | request.Parameters["p_target_yn"] | pTarget | 행/컬럼 값 대입 |  |  |  |
| AC-7b4c29cd | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:430 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d6a0318e | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:432 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b3b8ba4b | popSql.OnSql [if (programID == "PR_UI_FP00519_PJT_STATUS_PRO… 외 2 | FP00519_PJT_Status_Production_Type.cs:439 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00519_PJT_Status_Production_Type.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ea8bfb3 | this.Load | FP00519_PJT_Status_Production_Type.cs:106 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00519_PJT_Status_Production_Type.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f2d223a | this.Load | FP00519_PJT_Status_Production_Type.cs:149 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-409114d0 | this.Load | FP00519_PJT_Status_Production_Type.cs:156 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-742a1a02 | this.Load | FP00519_PJT_Status_Production_Type.cs:157 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e3a97da7 | this.Load | FP00519_PJT_Status_Production_Type.cs:159 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.AMEND_INSTANCE, false, UserInfoContext.Current.UserId, _sNo… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 화면 필드/플래그 변경 |  |  |  |
| AC-c90d2c39 | this.Load | FP00519_PJT_Status_Production_Type.cs:159 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.AMEND_INSTANCE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c56afd5d | this.Load | FP00519_PJT_Status_Production_Type.cs:163 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00519_PJT_Status_Production_Type.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58fe8019 | this.Load | FP00519_PJT_Status_Production_Type.cs:202 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-879b0515 | this.Load | FP00519_PJT_Status_Production_Type.cs:203 |  | UI_PROP | clbItemClassId.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00519_PJT_Status_Production_Type.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9e310ec | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:227 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-cf0e0266 | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:229 |  | CALL_EXT | siMain.SetColumnCombo | ("PRODUCTION_TYPE", dtProductionType) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a2abdd9 | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:232 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |

## FP00519_PJT_Status_Production_Type.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6f07580 | popSql.OnSql | FP00519_PJT_Status_Production_Type.cs:711 | if (programID == "PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-9713361e | popSql.OnSql | FP00519_PJT_Status_Production_Type.cs:714 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00519_PJT_Status_Production_Type.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a21e09f7 | SaveButton | FP00519_PJT_Status_Production_Type.cs:445 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35f5adc9 | SaveButton | FP00519_PJT_Status_Production_Type.cs:447 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca606912 | SaveButton | FP00519_PJT_Status_Production_Type.cs:452 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-845554eb | SaveButton | FP00519_PJT_Status_Production_Type.cs:453 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1f0a9652 | SaveButton | FP00519_PJT_Status_Production_Type.cs:456 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-31fbdbc2 | SaveButton | FP00519_PJT_Status_Production_Type.cs:463 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-13f907d1 | SaveButton | FP00519_PJT_Status_Production_Type.cs:465 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ffee94a4 | SaveButton | FP00519_PJT_Status_Production_Type.cs:466 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68f40581 | SaveButton | FP00519_PJT_Status_Production_Type.cs:471 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-20cb0fb5 | SaveButton | FP00519_PJT_Status_Production_Type.cs:476 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3461b9d | SaveButton | FP00519_PJT_Status_Production_Type.cs:485 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd9b27c1 | SaveButton | FP00519_PJT_Status_Production_Type.cs:489 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-43d20915 | SaveButton | FP00519_PJT_Status_Production_Type.cs:493 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9e070256 | SaveButton | FP00519_PJT_Status_Production_Type.cs:494 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-5a29909c | SaveButton | FP00519_PJT_Status_Production_Type.cs:498 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00519_PJT_Status_Production_Type.Save_Data_Execute

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f5f5efc | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:550 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00519_SAVE") ⇒ FP_Master.PR_UI_FP00519_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-227f9649 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:551 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-250e2c8c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:553 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-2543d9da | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:554 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-8fda02a2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:555 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-16ee4360 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:556 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-266816d6 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:558 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7184cc3f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:559 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c247ae8d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:560 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_applied_model"] | p_applied_model | 행/컬럼 값 대입 |  |  |  |
| AC-679391d9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:561 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-da0a222c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:563 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4eba32e0 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:564 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-09d4ed0d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:570 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-910c0279 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00519_PJT_Status_Production_Type.cs:576 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00519_PJT_Status_Production_Type.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-898ec759 | SaveButton | FP00519_PJT_Status_Production_Type.cs:281 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00519_PJT_Status_Production_Type.SetChangeControl

진입점: this.Load / cboInstance.SelectedIndexChanged / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1a0faab | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:175 | if (argType == "INSTANCE") | FLAG | sDataID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-f9194122 | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:176 | if (argType == "INSTANCE") | FLAG | pInstanceID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-b711ba05 | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:177 | if (argType == "INSTANCE") | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-9eb96b73 | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:177 | if (argType == "INSTANCE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pIns… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dc8dedf4 | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:178 | if (argType == "INSTANCE") | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6fcb1d91 | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:180 | if (argType == "INSTANCE") | FLAG | sDataID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues, "SHOP_GROUP_ID") | 화면 필드/플래그 변경 |  |  |  |
| AC-c0a07dbb | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:181 | if (argType == "INSTANCE") | FLAG | pShopGroupID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-fdd515b5 | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:182 | if (argType == "INSTANCE") | FLAG | dtItemClassId | Data_FP.Common_FP(Data_FP.Type.ITEM_CLASS, false, UserInfoContext.Current.UserId, _sNonAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ITEM_CLASS] | 화면 필드/플래그 변경 |  |  |  |
| AC-6bd1efa8 | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:182 | if (argType == "INSTANCE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.ITEM_CLASS, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ITEM_CLASS] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8bfa5849 | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:186 | if (argType == "INSTANCE") | LIST_REBIND | clsCtrl.setListBox | (dtItemClassId, clbItemClassId, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ad7ad100 | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:189 | if (argType == "INSTANCE") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-948c8bd9 | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:190 | if (argType == "INSTANCE") | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-efa1627c | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:191 | if (argType == "INSTANCE") | FLAG | dtProductionType | Data_FP.Common_FP(Data_FP.Type.PRODUCTION_TYPE, false, UserInfoContext.Current.UserId, _sN… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-c58ff38d | this.Load 외 2 | FP00519_PJT_Status_Production_Type.cs:191 | if (argType == "INSTANCE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PRODUCTION_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00519_PJT_Status_Production_Type.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c874ab2 | this.spdMain.CellClick | FP00519_PJT_Status_Production_Type.cs:618 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8e01f766 | this.spdMain.CellClick | FP00519_PJT_Status_Production_Type.cs:620 | try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4d35d68 | this.spdMain.CellClick | FP00519_PJT_Status_Production_Type.cs:635 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE))… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ffe18406 | this.spdMain.CellClick | FP00519_PJT_Status_Production_Type.cs:638 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)) | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ff0c5f2 | this.spdMain.CellClick | FP00519_PJT_Status_Production_Type.cs:639 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)) | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd42f4eb | this.spdMain.CellClick | FP00519_PJT_Status_Production_Type.cs:643 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)) | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5bb0762a | this.spdMain.CellClick | FP00519_PJT_Status_Production_Type.cs:648 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE))… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-6836127e | this.spdMain.CellClick | FP00519_PJT_Status_Production_Type.cs:651 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-14242a62 | this.spdMain.CellClick | FP00519_PJT_Status_Production_Type.cs:660 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00519_PJT_Status_Production_Type.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b312aa9 | this.spdMain.Change | FP00519_PJT_Status_Production_Type.cs:600 | if (e.Row >= 0 && siMain.GetColumnTag(e.Column).Equals("PRODUCTION_TYPE")) | CALL_EXT | siMain.SetHAlign | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), e.Row, siMain.GetColumnIndex(De… | ⚠ 의미 확인 필요 |  |  |  |


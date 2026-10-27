# AS-IS 액션 대조표 — SCP0091

> 원천: `Doc/asisfacts/screens/SCP0091/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 180행 · 메서드 28 · 종류 DATA_OP 44 · GRID_INIT 22 · POPUP 15 · RETURN 14 · UI_PROP 12 · FLAG 11 · ENDPOINT 11 · UI_MISC 10 · GRID_SET 7 · VALUE_SET 6 · LIST_REBIND 6 · MESSAGE 4 · COMBO_DATA 4 · GRID_CLEAR 3 · VALIDATE 3 · GRID_BIND 2 · GRID_LOCK 2 · STATE_RESET 1 · CALL_BASE 1 · VALUE_CLEAR 1 · CALL_EXT 1 · ⚠ 의미 확인 필요 2


## SCP0091_INTRANSIT.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24860194 | this.btnColumn.Click | SCP0091_INTRANSIT.cs:1096 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0091", sSheetName, true) | 팝업/폼 생성 |  |  |  |
| AC-55ea2f7f | this.btnColumn.Click | SCP0091_INTRANSIT.cs:1097 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-aca6e160 | this.btnColumn.Click | SCP0091_INTRANSIT.cs:1098 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9af9326d | this.btnColumn.Click | SCP0091_INTRANSIT.cs:1105 | if (frm.DialogResult == DialogResult.OK) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdDetail) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0091_INTRANSIT.BtnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21de4e48 | this.btnItemId.Click | SCP0091_INTRANSIT.cs:1055 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-951a75ca | this.btnItemId.Click | SCP0091_INTRANSIT.cs:1056 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-cdd7941f | this.btnItemId.Click | SCP0091_INTRANSIT.cs:1057 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-97288829 | this.btnItemId.Click | SCP0091_INTRANSIT.cs:1058 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cfec21ce | this.btnItemId.Click | SCP0091_INTRANSIT.cs:1064 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0091_INTRANSIT.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b86c262f | this.btnProject.Click | SCP0091_INTRANSIT.cs:1155 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-e4c9c8ed | this.btnProject.Click | SCP0091_INTRANSIT.cs:1157 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-409fcbeb | this.btnProject.Click | SCP0091_INTRANSIT.cs:1158 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2ba99add | this.btnProject.Click | SCP0091_INTRANSIT.cs:1159 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b225c602 | this.btnProject.Click | SCP0091_INTRANSIT.cs:1165 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCP0091_INTRANSIT.BtnProjectID_Click

진입점: this.btnProjectID.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a304837d | this.btnProjectID.Click | SCP0091_INTRANSIT.cs:1074 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-62b0a034 | this.btnProjectID.Click | SCP0091_INTRANSIT.cs:1075 |  | POPUP | popProject.Form_Load | (true, division, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-36be33f1 | this.btnProjectID.Click | SCP0091_INTRANSIT.cs:1076 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c328e35b | this.btnProjectID.Click | SCP0091_INTRANSIT.cs:1077 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bcb3674a | this.btnProjectID.Click | SCP0091_INTRANSIT.cs:1083 | if (popProject.ProjectCode != "") | VALUE_SET | txtSaleSite.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCP0091_INTRANSIT.CboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f09e67b | this.cboBucketType.SelectedIndexChanged | SCP0091_INTRANSIT.cs:1138 | if (siMain != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdDetail) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0091_INTRANSIT.CheckPeriodDate

진입점: this.Load [try] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97bf0238 | this.Load [try] 외 2 | SCP0091_INTRANSIT.cs:966 |  | RETURN | return isCheck; |  | 처리 중단/반환 |  |  |  |

## SCP0091_INTRANSIT.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f036f5d | (진입점 미연결) | SCP0091_INTRANSIT.cs:844 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8fc563ec | (진입점 미연결) | SCP0091_INTRANSIT.cs:845 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0091_INTRANSIT.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b41786ce | this.Load | SCP0091_INTRANSIT.cs:217 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8ea66631 | this.Load | SCP0091_INTRANSIT.cs:218 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-65e66c70 | this.Load | SCP0091_INTRANSIT.cs:219 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e45275ff | this.Load | SCP0091_INTRANSIT.cs:222 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtDetail, SpdSheet.shtDetail, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e8832f7f | this.Load | SCP0091_INTRANSIT.cs:223 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, spdDetail.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a52af725 | this.Load | SCP0091_INTRANSIT.cs:224 |  | GRID_INIT | siDetail.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0091_INTRANSIT.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e4f7a53 | this.Load | SCP0091_INTRANSIT.cs:234 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-9bfc7caa | this.Load | SCP0091_INTRANSIT.cs:235 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0091_INTRANSIT.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-000a274a | Dispose | SCP0091_INTRANSIT.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0091_INTRANSIT.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e737e97 | EditButton | SCP0091_INTRANSIT.cs:545 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cf9e6be0 | EditButton | SCP0091_INTRANSIT.cs:546 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0091_INTRANSIT.Find_Data

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7161dc2b | FindButton | SCP0091_INTRANSIT.cs:555 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-313626f8 | FindButton | SCP0091_INTRANSIT.cs:555 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-615794a6 | FindButton | SCP0091_INTRANSIT.cs:590 | if (CheckPeriodDate() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cdfd30f6 | FindButton | SCP0091_INTRANSIT.cs:599 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7f5d6641 | FindButton | SCP0091_INTRANSIT.cs:602 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-04f9db7a | FindButton | SCP0091_INTRANSIT.cs:607 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1a674646 | FindButton | SCP0091_INTRANSIT.cs:609 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_MASTER_SVC)) { var req = n… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b4a43d6c | FindButton | SCP0091_INTRANSIT.cs:612 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0091_GET_VALIDATION_SHIPMENT_REPORT") ⇒ SCP.SCP0091_GET_VALIDATION_SHIPMENT_REPORT | 엔드포인트 요청 생성 |  |  |  |
| AC-e5aa91b0 | FindButton | SCP0091_INTRANSIT.cs:613 | try ▸ lambda | UI_PROP | req.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b9e1d02f | FindButton | SCP0091_INTRANSIT.cs:614 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-72301bd2 | FindButton | SCP0091_INTRANSIT.cs:615 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-8f0742dc | FindButton | SCP0091_INTRANSIT.cs:616 | try ▸ lambda | DATA_OP | req.Parameters["p_sales_site_id"] | pSalesSite | 행/컬럼 값 대입 |  |  |  |
| AC-1366a8f7 | FindButton | SCP0091_INTRANSIT.cs:617 | try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | pProject | 행/컬럼 값 대입 |  |  |  |
| AC-63d67809 | FindButton | SCP0091_INTRANSIT.cs:618 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | pItem_Id | 행/컬럼 값 대입 |  |  |  |
| AC-23b7dd70 | FindButton | SCP0091_INTRANSIT.cs:619 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | pFromYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-d5af9f34 | FindButton | SCP0091_INTRANSIT.cs:620 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | pToYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-fa70a1bc | FindButton | SCP0091_INTRANSIT.cs:621 | try ▸ lambda | DATA_OP | req.Parameters["p_result_type"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-fafa68f3 | FindButton | SCP0091_INTRANSIT.cs:622 | try ▸ lambda | DATA_OP | req.Parameters["p_bucket_type"] | pBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-dbb41ab3 | FindButton | SCP0091_INTRANSIT.cs:623 | try ▸ lambda | DATA_OP | req.Parameters["p_period_from"] | pPeriodFrom | 행/컬럼 값 대입 |  |  |  |
| AC-cf452b2d | FindButton | SCP0091_INTRANSIT.cs:624 | try ▸ lambda | DATA_OP | req.Parameters["p_period_to"] | pPeriodTo | 행/컬럼 값 대입 |  |  |  |
| AC-b17553a5 | FindButton | SCP0091_INTRANSIT.cs:625 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0bebec19 | FindButton | SCP0091_INTRANSIT.cs:626 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group.Equals("ALL") ? DBNull.Value : p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-2c71fedc | FindButton | SCP0091_INTRANSIT.cs:628 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-75eefe2c | FindButton | SCP0091_INTRANSIT.cs:629 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e218252a | FindButton | SCP0091_INTRANSIT.cs:636 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a4dd21a6 | FindButton | SCP0091_INTRANSIT.cs:641 | try ▸ if (ds != null && ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-606033db | FindButton | SCP0091_INTRANSIT.cs:644 | try ▸ if (ds != null && ds.Tables[0].Rows.Count > 0) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdDetail) | 그리드 데이터/선택 비움 |  |  |  |
| AC-50e268ce | FindButton | SCP0091_INTRANSIT.cs:652 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6e0e9d53 | FindButton | SCP0091_INTRANSIT.cs:656 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-17121343 | FindButton | SCP0091_INTRANSIT.cs:658 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1c7f1bed | FindButton | SCP0091_INTRANSIT.cs:662 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0c6824c5 | FindButton | SCP0091_INTRANSIT.cs:663 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0091_INTRANSIT.FindDetail_Data

진입점: spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(DefCols.SHIPMENT_NO) && !e.ColumnHeader)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36aa7970 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:674 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-8d0bb123 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:674 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd84cf45 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:755 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8172e833 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:758 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-97a465f3 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:761 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e39c3d7c | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:763 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_MASTER_SVC)) { var req = n… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aa9cbf88 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:766 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0091_GET_VALIDATION_SHIPMENT_DETAIL") ⇒ SCP.SCP0091_GET_VALIDATION_SHIPMENT_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-0d5d7fdb | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:768 | try ▸ lambda | DATA_OP | req.Parameters["p_result_date"] | pResultDate | 행/컬럼 값 대입 |  |  |  |
| AC-febf5249 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:769 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-53520df0 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:770 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-e3c43883 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:771 | try ▸ lambda | DATA_OP | req.Parameters["p_sales_site_id"] | pSalesSite | 행/컬럼 값 대입 |  |  |  |
| AC-66a1a824 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:772 | try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | pProject | 행/컬럼 값 대입 |  |  |  |
| AC-4a417792 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:773 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | pItem_Id | 행/컬럼 값 대입 |  |  |  |
| AC-0ce82489 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:774 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | pFromYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-74dc09c5 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:775 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | pToYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-2a919f6e | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:776 | try ▸ lambda | DATA_OP | req.Parameters["p_result_type"] | "I,C,B" | 행/컬럼 값 대입 |  |  |  |
| AC-4e846118 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:777 | try ▸ lambda | DATA_OP | req.Parameters["p_shipment_no"] | p_shipment_no | 행/컬럼 값 대입 |  |  |  |
| AC-ee5fa222 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:778 | try ▸ lambda | DATA_OP | req.Parameters["p_bucket_type"] | pBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-058a86f3 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:779 | try ▸ lambda | DATA_OP | req.Parameters["p_period_from"] | pPeriodFrom | 행/컬럼 값 대입 |  |  |  |
| AC-c0089aa4 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:780 | try ▸ lambda | DATA_OP | req.Parameters["p_period_to"] | pPeriodTo | 행/컬럼 값 대입 |  |  |  |
| AC-80d05c5c | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:781 | try ▸ lambda | DATA_OP | req.Parameters["p_trans_mode"] | pTransMode | 행/컬럼 값 대입 |  |  |  |
| AC-64c87f56 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:782 | try ▸ lambda | DATA_OP | req.Parameters["p_searchdate"] | searchDate | 행/컬럼 값 대입 |  |  |  |
| AC-665ee394 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:784 | try ▸ lambda | DATA_OP | req.Parameters["p_cell_group"] | p_cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-62b52253 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:785 | try ▸ lambda | DATA_OP | req.Parameters["p_pack_group"] | p_pack_group | 행/컬럼 값 대입 |  |  |  |
| AC-9f53b431 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:786 | try ▸ lambda | DATA_OP | req.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-4235e944 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:788 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-99eddaf3 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:789 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-17484bcc | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:790 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0e195101 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:797 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b370924e | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:801 | try ▸ if (ds != null && ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-712bf053 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:805 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f8b7d713 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:809 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2237b087 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:811 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7a62a3cd | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:815 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bb4aa040 | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:816 | finally | UI_MISC | siDetail.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0091_INTRANSIT.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5727b5b1 | this.Load | SCP0091_INTRANSIT.cs:148 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0091_INTRANSIT.GetCellValue

진입점: spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(DefCols.SHIPMENT_NO) && !e.ColumnHeader)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ab8a3bf | spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(De… | SCP0091_INTRANSIT.cs:837 |  | RETURN | return returnValue; |  | 처리 중단/반환 |  |  |  |

## SCP0091_INTRANSIT.GetDayPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6f07812 | this.Load | SCP0091_INTRANSIT.cs:1033 |  | RETURN | return sReDate; |  | 처리 중단/반환 |  |  |  |

## SCP0091_INTRANSIT.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cb17902 | this.Load | SCP0091_INTRANSIT.cs:987 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0091_INTRANSIT.GetSpdTitle

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edcee1b2 | this.Load 외 2 | SCP0091_INTRANSIT.cs:919 | try ▸ if (CheckPeriodDate() == false) | MESSAGE | MessageBox.Show | ("[Period Date] 365일 이상 조회 할 수 없습니다.\r\n또는 시작일이 종료일 보다 큽니다.") | 메시지 표시 |  |  |  |
| AC-f2754537 | this.Load 외 2 | SCP0091_INTRANSIT.cs:922 | try ▸ if (CheckPeriodDate() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91faad8b | this.Load 외 2 | SCP0091_INTRANSIT.cs:929 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-6b4091fd | this.Load 외 2 | SCP0091_INTRANSIT.cs:930 | try | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-461fe3d8 | this.Load 외 2 | SCP0091_INTRANSIT.cs:931 | try | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-69c6164b | this.Load 외 2 | SCP0091_INTRANSIT.cs:933 | try | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-00e3b0b7 | this.Load 외 2 | SCP0091_INTRANSIT.cs:933 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0091_INTRANSIT.GoPage

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc3bd33c | (진입점 미연결) | SCP0091_INTRANSIT.cs:860 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4f8b6222 | (진입점 미연결) | SCP0091_INTRANSIT.cs:861 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.DataService.WSL/FoxDataServic… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5e0c7a40 | (진입점 미연결) | SCP0091_INTRANSIT.cs:865 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("MenuContainer.UP_FX_GetGSCMAuthenticationMenuList") ⇒ MenuContainer.UP_FX_GetGSCMAuthenticationMenuList | 엔드포인트 요청 생성 |  |  |  |
| AC-799f2d90 | (진입점 미연결) | SCP0091_INTRANSIT.cs:866 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-57a84b2d | (진입점 미연결) | SCP0091_INTRANSIT.cs:867 | try ▸ lambda | DATA_OP | request.Parameters["UserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-21678ce6 | (진입점 미연결) | SCP0091_INTRANSIT.cs:868 | try ▸ lambda | DATA_OP | request.Parameters["GroupID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-854fe629 | (진입점 미연결) | SCP0091_INTRANSIT.cs:869 | try ▸ lambda | DATA_OP | request.Parameters["ProgramId"] | pageNm | 행/컬럼 값 대입 |  |  |  |
| AC-8e6b2606 | (진입점 미연결) | SCP0091_INTRANSIT.cs:871 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e87f115 | (진입점 미연결) | SCP0091_INTRANSIT.cs:873 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ffb2521e | (진입점 미연결) | SCP0091_INTRANSIT.cs:881 | finally | CALL_BASE | openSubMenu | ("SCM0014") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0091_INTRANSIT.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99f31dd0 | this.Load | SCP0091_INTRANSIT.cs:172 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-3e2f3ce8 | this.Load | SCP0091_INTRANSIT.cs:175 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-75d3a13b | this.Load | SCP0091_INTRANSIT.cs:176 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-b733df2d | this.Load | SCP0091_INTRANSIT.cs:178 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-caeebede | this.Load | SCP0091_INTRANSIT.cs:180 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3228cae0 | this.Load | SCP0091_INTRANSIT.cs:184 |  | FLAG | dtResultType | Data.Common(Data.Type.LookupCommon, false, "SHIPMENT_RESULT_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-c59956ba | this.Load | SCP0091_INTRANSIT.cs:184 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "SHIPMENT_RESULT_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b8ab6975 | this.Load | SCP0091_INTRANSIT.cs:187 |  | VALUE_SET | drpResult.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-e6b6adb9 | this.Load | SCP0091_INTRANSIT.cs:188 |  | VALUE_CLEAR | drpPeriod.InitValue | null | 컨트롤 값 비움 |  |  |  |
| AC-f464a891 | this.Load | SCP0091_INTRANSIT.cs:189 |  | VALUE_SET | drpPeriod.InitValue | GetDayPeriod() | 컨트롤 값 설정 |  |  |  |
| AC-21eda34d | this.Load | SCP0091_INTRANSIT.cs:191 |  | FLAG | dtBucketType | ScpUtils.GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-fcf504e4 | this.Load | SCP0091_INTRANSIT.cs:191 |  | CALL_EXT | ScpUtils.GetBucketType | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d065e29 | this.Load | SCP0091_INTRANSIT.cs:192 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-62422794 | this.Load | SCP0091_INTRANSIT.cs:195 |  | FLAG | dtOpGroup | Data.Common(Data.Type.LookupCommon, true, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-c35a164e | this.Load | SCP0091_INTRANSIT.cs:195 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, true, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e5482890 | this.Load | SCP0091_INTRANSIT.cs:196 |  | LIST_REBIND | clsCtrl.setListBox | (dtOpGroup, cboOpGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ada980bf | this.Load | SCP0091_INTRANSIT.cs:198 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-a8836ae8 | this.Load | SCP0091_INTRANSIT.cs:198 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, cboDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e9a63b18 | this.Load | SCP0091_INTRANSIT.cs:199 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0091_INTRANSIT.InitSpread

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c89d416 | this.Load 외 2 | SCP0091_INTRANSIT.cs:252 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a39c1529 | this.Load 외 2 | SCP0091_INTRANSIT.cs:253 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0091_INTRANSIT.InitSpreadDateColumn

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-063cd852 | this.Load 외 2 | SCP0091_INTRANSIT.cs:336 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6d3c5e7 | this.Load 외 2 | SCP0091_INTRANSIT.cs:340 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefLabels.Saturday \|\| sDayCo… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefLabels.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-b026babf | this.Load 외 2 | SCP0091_INTRANSIT.cs:347 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-75aabe03 | this.Load 외 2 | SCP0091_INTRANSIT.cs:348 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3e9b480c | this.Load 외 2 | SCP0091_INTRANSIT.cs:354 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-358f33cd | this.Load 외 2 | SCP0091_INTRANSIT.cs:355 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c387b3d | this.Load 외 2 | SCP0091_INTRANSIT.cs:363 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bab4fa2f | this.Load 외 2 | SCP0091_INTRANSIT.cs:364 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec69c24c | this.Load 외 2 | SCP0091_INTRANSIT.cs:375 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f5f20828 | this.Load 외 2 | SCP0091_INTRANSIT.cs:376 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff6e95f4 | this.Load 외 2 | SCP0091_INTRANSIT.cs:377 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9b85462 | this.Load 외 2 | SCP0091_INTRANSIT.cs:378 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0091_INTRANSIT.InitSpreadDetail

진입점: this.Load / spdMain.CellDoubleClick [if (nCol > siMain.GetColumnIndex(DefCols.SHIPMENT_NO) && !e.ColumnHeader)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c1e079d | this.Load 외 1 | SCP0091_INTRANSIT.cs:260 |  | GRID_INIT | siDetail.InitSheet | (siDetail.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-4f1ea9db | this.Load 외 1 | SCP0091_INTRANSIT.cs:261 |  | GRID_INIT | siDetail.SetSheetHeaderColumn | (siDetail, 3) | 그리드 재구성/초기화 |  |  |  |

## SCP0091_INTRANSIT.IsPartialRight

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8049e7e1 | (진입점 미연결) | SCP0091_INTRANSIT.cs:910 |  | RETURN | return s.Substring(s.Length - sub.Length, sub.Length).Equals(sub); |  | 처리 중단/반환 |  |  |  |

## SCP0091_INTRANSIT.IsVisibleCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7adf84c | (진입점 미연결) | SCP0091_INTRANSIT.cs:906 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0091_INTRANSIT.SetChangedControl

진입점: this.Load / this.cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b128295c | this.Load 외 2 | SCP0091_INTRANSIT.cs:207 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-543597e8 | this.Load 외 2 | SCP0091_INTRANSIT.cs:207 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, cboDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a47e6202 | this.Load 외 2 | SCP0091_INTRANSIT.cs:208 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0091_INTRANSIT.SetSpreadColumn

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try ▸ if (ds != null && ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-950c71d9 | this.Load 외 3 | SCP0091_INTRANSIT.cs:409 | for (ic < intColcount) | DATA_OP | strColnames[ic] | strColname | 행/컬럼 값 대입 |  |  |  |
| AC-0c55d36b | this.Load 외 3 | SCP0091_INTRANSIT.cs:410 | for (ic < intColcount) | DATA_OP | intColidxs[ic] | siObj.GetColumnIndex(strColname) | 행/컬럼 값 대입 |  |  |  |
| AC-6afba205 | this.Load 외 3 | SCP0091_INTRANSIT.cs:420 | for (iCol <= siObj.GetMaxColumnIndex()) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-749fe09b | this.Load 외 3 | SCP0091_INTRANSIT.cs:424 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) | DATA_OP | colName.Contains | ("_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4059f9b | this.Load 외 3 | SCP0091_INTRANSIT.cs:426 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (colName.IndexOf("D_") == 0 && colName.C… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-06a89c2e | this.Load 외 3 | SCP0091_INTRANSIT.cs:431 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (colName.IndexOf("W_") == 0 \|\| colName… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-58a23bc5 | this.Load 외 3 | SCP0091_INTRANSIT.cs:436 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | DATA_OP | colName.Contains | ("_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-c34e88fe | this.Load 외 3 | SCP0091_INTRANSIT.cs:438 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a18df152 | this.Load 외 3 | SCP0091_INTRANSIT.cs:443 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | DATA_OP | colName.Contains | ("_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-bffc51f6 | this.Load 외 3 | SCP0091_INTRANSIT.cs:445 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-15bfb950 | this.Load 외 3 | SCP0091_INTRANSIT.cs:490 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (colName.Substring(0, 2) == "D_") ▸ if (string.IsNul… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].BackColor | backColor | 그리드 속성/값 설정 |  |  |  |

## SCP0091_INTRANSIT.SetSpreadInit

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5230a3c9 | this.Load 외 2 | SCP0091_INTRANSIT.cs:274 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-8a7d4542 | this.Load 외 2 | SCP0091_INTRANSIT.cs:276 |  | FLAG | nIdxDataMain | spdInfo.GetMaxColumnIndex() + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-04e3324e | this.Load 외 2 | SCP0091_INTRANSIT.cs:277 |  | UI_PROP | spdInfo.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |
| AC-29d41762 | this.Load 외 2 | SCP0091_INTRANSIT.cs:280 |  | FLAG | nIdxDataMain | spdInfo.GetMaxColumnIndex() + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-ec5496e4 | this.Load 외 2 | SCP0091_INTRANSIT.cs:281 |  | UI_PROP | spdInfo.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |
| AC-4c8c76ec | this.Load 외 2 | SCP0091_INTRANSIT.cs:286 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca1263bb | this.Load 외 2 | SCP0091_INTRANSIT.cs:287 |  | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |


# AS-IS 액션 대조표 — FP01620

> 원천: `Doc/asisfacts/screens/FP01620/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 176행 · 메서드 24 · 종류 DATA_OP 39 · FLAG 35 · UI_PROP 23 · LIST_REBIND 15 · COMBO_DATA 12 · RETURN 11 · GRID_INIT 5 · GRID_STYLE 5 · POPUP 4 · STATE 4 · UI_MISC 4 · MESSAGE 4 · VALUE_SET 3 · ENDPOINT 3 · THROW 2 · CALL_EXT 2 · EXCEL 1 · CALL_BASE 1 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 3


## FP01620_WO_Create.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e050f7b | this.btnSql.Click | FP01620_WO_Create.cs:565 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c5078e6f | this.btnSql.Click | FP01620_WO_Create.cs:566 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0ccb6c9f | this.btnSql.Click | FP01620_WO_Create.cs:568 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP01620_WO_Create") | 데이터 객체 조작/조회 |  |  |  |
| AC-958457ec | this.btnSql.Click | FP01620_WO_Create.cs:569 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01620_WO_Create.CboInstance_SelectedIndexChanged

진입점: this.Load / cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c624345 | this.Load 외 1 | FP01620_WO_Create.cs:738 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-32be1b8e | this.Load 외 1 | FP01620_WO_Create.cs:740 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01620_WO_Create.CboOperation_SelectedIndexChanged

진입점: this.Load / cboOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5ed7a7d | this.Load 외 1 | FP01620_WO_Create.cs:833 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-c4cec9fd | this.Load 외 1 | FP01620_WO_Create.cs:835 |  | UI_PROP | clbLine.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01620_WO_Create.CboSite_SelectedIndexChanged

진입점: this.Load / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fefa67cf | this.Load 외 1 | FP01620_WO_Create.cs:814 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-9abd90c5 | this.Load 외 1 | FP01620_WO_Create.cs:816 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01620_WO_Create.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88be17b9 | (진입점 미연결) | FP01620_WO_Create.cs:912 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01620_WO_Create.ClbPlant_SelectedIndexChanged

진입점: this.Load / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cc5b29a | this.Load 외 1 | FP01620_WO_Create.cs:821 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-ef3d2e28 | this.Load 외 1 | FP01620_WO_Create.cs:823 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01620_WO_Create.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c676a9d2 | this.Load | FP01620_WO_Create.cs:512 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ad87874d | this.Load | FP01620_WO_Create.cs:513 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f2099976 | this.Load | FP01620_WO_Create.cs:514 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01620_WO_Create.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef254a20 | this.Load | FP01620_WO_Create.cs:165 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-16dc8044 | this.Load | FP01620_WO_Create.cs:166 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-ea2a0c54 | this.Load | FP01620_WO_Create.cs:167 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d9fc2fdd | this.Load | FP01620_WO_Create.cs:171 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-056f3be3 | this.Load | FP01620_WO_Create.cs:172 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-aec473d5 | this.Load | FP01620_WO_Create.cs:173 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP01620_WO_Create.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c04a958 | Dispose | FP01620_WO_Create.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01620_WO_Create.DrpPlanDate_ValueChanged

진입점: this.Load / drpPlanDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8194dc8e | this.Load 외 1 | FP01620_WO_Create.cs:758 | try | FLAG | sPlanDate | drpPlanDate.Value.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-18a4abe1 | this.Load 외 1 | FP01620_WO_Create.cs:764 | try ▸ if (int.Parse(sPlanDate) > int.Parse(sCurDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-65367a9d | this.Load 외 1 | FP01620_WO_Create.cs:766 | try ▸ if (int.Parse(sPlanDate) > int.Parse(sCurDate)) | VALUE_SET | drpPlanDate.Text | sPrevDate | 컨트롤 값 설정 |  |  |  |
| AC-1f022e94 | this.Load 외 1 | FP01620_WO_Create.cs:769 | try ▸ if (int.Parse(sPlanDate) > int.Parse(sCurDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-537a8e42 | this.Load 외 1 | FP01620_WO_Create.cs:774 | try ▸ else of (int.Parse(sPlanDate) > int.Parse(sCurDate)) | FLAG | sPrevDate | drpPlanDate.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-dbdad1b9 | this.Load 외 1 | FP01620_WO_Create.cs:778 | try ▸ else of (int.Parse(sPlanDate) > int.Parse(sCurDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26b152d8 | this.Load 외 1 | FP01620_WO_Create.cs:784 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01620_WO_Create.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8ab0a94 | EditButton | FP01620_WO_Create.cs:547 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-afe34d17 | EditButton | FP01620_WO_Create.cs:548 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01620_WO_Create.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5737cfb4 | ExcelButton | FP01620_WO_Create.cs:558 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP01620_WO_Create.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07f1fe61 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:665 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pInstanceID = CString.GetCheckedListValue(dtInstance, cbo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-64846f59 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:667 | try ▸ lambda | FLAG | pInstanceID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-53bc3d97 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:669 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-e848b1d7 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:670 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-bf702476 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:671 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-38900c7d | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:672 | try ▸ lambda | FLAG | pFactoryID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee612443 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:673 | try ▸ lambda | FLAG | pOperationID | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c29e236 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:674 | try ▸ lambda | FLAG | pLineID | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-d92d7403 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:698 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01620_WO_CREATE") ⇒ FP_Master.PR_UI_FP01620_WO_CREATE | 엔드포인트 요청 생성 |  |  |  |
| AC-4e255cbe | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:699 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8109aa5c | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:700 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-d1e3eb3d | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:701 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-7ae60362 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:702 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4a302a6a | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:703 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-414960a1 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:705 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstanceID.Equals("ALL") ? DBNull.Value : pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-28b5e605 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:706 | try | DATA_OP | request.Parameters["p_plan_id"] | p_plan_id.Equals("ALL") ? DBNull.Value : p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-060c6762 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:707 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-742523d6 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:708 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-d0a1f7b5 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:709 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-64cf9081 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:710 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-c83fec25 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:711 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-05a30aa9 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:712 | try | DATA_OP | request.Parameters["p_line_id"] | pLineID.Equals("ALL") ? DBNull.Value : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-a5c7dfd7 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:713 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-e04a7744 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:714 | try | DATA_OP | request.Parameters["p_work_order_id"] | pWorkOrderId.Equals("ALL") ? DBNull.Value : pWorkOrderId | 행/컬럼 값 대입 |  |  |  |
| AC-de130546 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:715 | try | DATA_OP | request.Parameters["p_from_date"] | p_from_date.Equals("ALL") ? DBNull.Value : p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-1b5a0c4d | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:716 | try | DATA_OP | request.Parameters["p_to_date"] | p_to_date.Equals("ALL") ? DBNull.Value : p_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-a47e1e43 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:717 | try | DATA_OP | request.Parameters["p_target_yn"] | pTargetYN.Equals("ALL") ? DBNull.Value : pTargetYN | 행/컬럼 값 대입 |  |  |  |
| AC-097f7551 | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:720 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-95f28afa | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:722 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2160a25a | popSql.OnSql [if (programID == "PR_UI_FP01620_WO_Create")] 외 1 | FP01620_WO_Create.cs:729 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01620_WO_Create.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1f5eb7d | FindButton | FP01620_WO_Create.cs:537 | if (string.IsNullOrWhiteSpace(cboPlanID.SelectedValue as string)) | MESSAGE | MessageHelper.GMessageBox | ("You need to select one plan to proceed") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e727cf9b | FindButton | FP01620_WO_Create.cs:538 | if (string.IsNullOrWhiteSpace(cboPlanID.SelectedValue as string)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01620_WO_Create.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8aca7eb6 | FindButton | FP01620_WO_Create.cs:577 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c6ebcc8d | FindButton | FP01620_WO_Create.cs:583 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-569d0f06 | FindButton | FP01620_WO_Create.cs:584 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4b9b0ea | FindButton | FP01620_WO_Create.cs:587 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-dc3683c7 | FindButton | FP01620_WO_Create.cs:589 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-98e997d1 | FindButton | FP01620_WO_Create.cs:589 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1afdce9 | FindButton | FP01620_WO_Create.cs:595 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a23d63ea | FindButton | FP01620_WO_Create.cs:602 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-46872d26 | FindButton | FP01620_WO_Create.cs:604 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-672c6d76 | FindButton | FP01620_WO_Create.cs:615 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-96cc26b8 | FindButton | FP01620_WO_Create.cs:617 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a90137d | FindButton | FP01620_WO_Create.cs:620 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9972679f | FindButton | FP01620_WO_Create.cs:622 | try | CALL_EXT | siMain.SetRightMerge | (siMain.GetMaxColumnIndex(), true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78119aca | FindButton | FP01620_WO_Create.cs:623 | try | CALL_EXT | siMain.SetMergeRange | (1, 7) | ⚠ 의미 확인 필요 |  |  |  |
| AC-104b6c53 | FindButton | FP01620_WO_Create.cs:630 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2241b51d | FindButton | FP01620_WO_Create.cs:641 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-afaeb29b | FindButton | FP01620_WO_Create.cs:642 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01620_WO_Create.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b852df6 | this.Load | FP01620_WO_Create.cs:144 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01620_WO_Create.GetPlanGroup

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0781c21 | this.Load | FP01620_WO_Create.cs:1130 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e9d18ce9 | this.Load | FP01620_WO_Create.cs:1131 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID_EXCEPT_POST", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] \|… | 화면 필드/플래그 변경 |  |  |  |
| AC-ac1dc8fa | this.Load | FP01620_WO_Create.cs:1131 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID_EXCEPT_POST", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] \|… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d6f8ec31 | this.Load | FP01620_WO_Create.cs:1132 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP01620_WO_Create.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed8e7a44 | this.Load | FP01620_WO_Create.cs:180 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f35b0954 | this.Load | FP01620_WO_Create.cs:182 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6b4b2bd | this.Load | FP01620_WO_Create.cs:187 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b6d910b6 | this.Load | FP01620_WO_Create.cs:188 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5044c0f0 | this.Load | FP01620_WO_Create.cs:209 |  | FLAG | sDataID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-22250298 | this.Load | FP01620_WO_Create.cs:210 |  | FLAG | dtCurDate | DataCommon.GetPlannnigUserFormCodeData("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_fin… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-67db7a94 | this.Load | FP01620_WO_Create.cs:210 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_find_CurrUTDate", sDataID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-51857ad5 | this.Load | FP01620_WO_Create.cs:212 |  | FLAG | dtTarget | Data_FP.Common_FP(Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 화면 필드/플래그 변경 |  |  |  |
| AC-06bfe178 | this.Load | FP01620_WO_Create.cs:212 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-767ec367 | this.Load | FP01620_WO_Create.cs:213 |  | LIST_REBIND | clsCtrl.setListBox | (dtTarget, cboTarget, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-04dae758 | this.Load | FP01620_WO_Create.cs:217 |  | VALUE_SET | drpPlanDate.Value | DateTime.ParseExact(dtCurDate.Rows[0]["CURR_DATE"].ToString(), "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-0c8297cb | this.Load | FP01620_WO_Create.cs:218 |  | FLAG | sPlanDate | drpPlanDate.Value.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-ea68273e | this.Load | FP01620_WO_Create.cs:219 |  | FLAG | sPrevDate | drpPlanDate.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-dcd3fe04 | this.Load | FP01620_WO_Create.cs:220 |  | FLAG | sCurDate | drpPlanDate.Value.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-b617852e | this.Load | FP01620_WO_Create.cs:224 |  | UI_PROP | drpPeriod.Text1 | DateUtil.GetDateAdd(sCurDate.Replace("-", ""), -7, "D") | 속성 Text1 설정 |  |  |  |
| AC-ecf61cef | this.Load | FP01620_WO_Create.cs:225 |  | UI_PROP | drpPeriod.Text2 | DateUtil.GetDateAdd(sCurDate.Replace("-", ""), 7, "D") | 속성 Text2 설정 |  |  |  |

## FP01620_WO_Create.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99bb07a7 | this.Load 외 1 | FP01620_WO_Create.cs:521 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-adbd252a | this.Load 외 1 | FP01620_WO_Create.cs:523 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01620_WO_Create.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8a98da8 | popSql.OnSql | FP01620_WO_Create.cs:925 | if (programID == "PR_UI_FP01620_WO_Create") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-5beccab3 | popSql.OnSql | FP01620_WO_Create.cs:928 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01620_WO_Create.Search_After

진입점: FindButton [finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54188ecd | FindButton [finally] | FP01620_WO_Create.cs:848 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f431672b | FindButton [finally] | FP01620_WO_Create.cs:855 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-adc8db66 | FindButton [finally] | FP01620_WO_Create.cs:861 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sReturn_Status.Equals("Error")) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.OPERATION_ID), i, siMain.GetColumnIndex(DefColumns.WO… | 그리드 표시 설정 |  |  |  |
| AC-de5d56ae | FindButton [finally] | FP01620_WO_Create.cs:862 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sReturn_Status.Equals("Error")) | GRID_STYLE | siMain.SetForeColor | (i, siMain.GetColumnIndex(DefColumns.RETURN_STATUS), i, siMain.GetColumnIndex(DefColumns.E… | 그리드 표시 설정 |  |  |  |
| AC-7726e01a | FindButton [finally] | FP01620_WO_Create.cs:863 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sReturn_Status.Equals("Error")) | GRID_STYLE | siMain.SetFontBold | (i, siMain.GetColumnIndex(DefColumns.RETURN_STATUS), i, siMain.GetColumnIndex(DefColumns.E… | 그리드 표시 설정 |  |  |  |
| AC-e218ab19 | FindButton [finally] | FP01620_WO_Create.cs:867 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sReturn_Status.Equals("Success")) | GRID_STYLE | siMain.SetForeColor | (i, siMain.GetColumnIndex(DefColumns.RETURN_STATUS), i, siMain.GetColumnIndex(DefColumns.R… | 그리드 표시 설정 |  |  |  |
| AC-30fdea3c | FindButton [finally] | FP01620_WO_Create.cs:868 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sReturn_Status.Equals("Success")) | GRID_STYLE | siMain.SetFontBold | (i, siMain.GetColumnIndex(DefColumns.RETURN_STATUS), i, siMain.GetColumnIndex(DefColumns.R… | 그리드 표시 설정 |  |  |  |

## FP01620_WO_Create.SetChangeControl

진입점: this.Load / cboInstance.SelectedIndexChanged / drpPlanDate.ValueChanged [try ▸ else of (int.Parse(sPlanDate) > int.Parse(sCurDate))] / cboPlanID.SelectedIndexChanged / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / cboOperation.SelectedIndexChanged / clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6014520a | this.Load 외 9 | FP01620_WO_Create.cs:1002 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID_EXCEPT_POST", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] \|… | 화면 필드/플래그 변경 |  |  |  |
| AC-7d72f818 | this.Load 외 9 | FP01620_WO_Create.cs:1002 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID_EXCEPT_POST", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_id_except_post] \|… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f92973fa | this.Load 외 9 | FP01620_WO_Create.cs:1007 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["INSTANCE_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-0fe47c0c | this.Load 외 9 | FP01620_WO_Create.cs:1011 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-66b4fd0b | this.Load 외 9 | FP01620_WO_Create.cs:1012 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f044a20f | this.Load 외 9 | FP01620_WO_Create.cs:1012 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-86e8e927 | this.Load 외 9 | FP01620_WO_Create.cs:1015 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtCurDate | DataCommon.GetPlannnigUserFormCodeData("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_fin… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4a50bad1 | this.Load 외 9 | FP01620_WO_Create.cs:1015 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_find_CurrUTDate", sInstance_id) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-274bd07e | this.Load 외 9 | FP01620_WO_Create.cs:1016 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | VALUE_SET | drpPlanDate.Value | DateTime.ParseExact(dtCurDate.Rows[0]["CURR_DATE"].ToString(), "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-5406323e | this.Load 외 9 | FP01620_WO_Create.cs:1019 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) ▸ if ((object)clbDivision is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, (object)clbDivision as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-06953221 | this.Load 외 9 | FP01620_WO_Create.cs:1021 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) ▸ else of ((object)clbDivision is UsrCombo) ▸ if ((object)clbD… | LIST_REBIND | clsCtrl.setListBox | (dtDivision, (object)clbDivision as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-75e6a90f | this.Load 외 9 | FP01620_WO_Create.cs:1027 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-b01e02c3 | this.Load 외 9 | FP01620_WO_Create.cs:1028 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f57bbdd9 | this.Load 외 9 | FP01620_WO_Create.cs:1028 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9d90a9be | this.Load 외 9 | FP01620_WO_Create.cs:1031 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)cboSite is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-82719322 | this.Load 외 9 | FP01620_WO_Create.cs:1033 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)cboSite is UsrCombo) ▸ if ((object)cboSite … | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2bc1e43a | this.Load 외 9 | FP01620_WO_Create.cs:1039 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-cbc5265f | this.Load 외 9 | FP01620_WO_Create.cs:1040 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9dbba857 | this.Load 외 9 | FP01620_WO_Create.cs:1040 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f2e6bc5c | this.Load 외 9 | FP01620_WO_Create.cs:1043 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bf6cd42d | this.Load 외 9 | FP01620_WO_Create.cs:1045 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlant is Usr… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-05b849f8 | this.Load 외 9 | FP01620_WO_Create.cs:1051 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-f246c990 | this.Load 외 9 | FP01620_WO_Create.cs:1052 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-0243deba | this.Load 외 9 | FP01620_WO_Create.cs:1052 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-16b8788c | this.Load 외 9 | FP01620_WO_Create.cs:1054 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ if ((object)clbFactory is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-50cc4045 | this.Load 외 9 | FP01620_WO_Create.cs:1056 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ else of ((object)clbFactory is UsrCombo) ▸ if ((object)clbFactory … | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-09a89f05 | this.Load 외 9 | FP01620_WO_Create.cs:1062 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-3e11b916 | this.Load 외 9 | FP01620_WO_Create.cs:1063 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-074c1d3c | this.Load 외 9 | FP01620_WO_Create.cs:1063 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-26ea537a | this.Load 외 9 | FP01620_WO_Create.cs:1065 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ if ((object)cboOperation is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, (object)cboOperation as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c78c35b6 | this.Load 외 9 | FP01620_WO_Create.cs:1067 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ else of ((object)cboOperation is UsrCombo) ▸ if ((object)cboOp… | LIST_REBIND | clsCtrl.setListBox | (dtOperation, (object)cboOperation as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1ef352cb | this.Load 외 9 | FP01620_WO_Create.cs:1073 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-1cbd30db | this.Load 외 9 | FP01620_WO_Create.cs:1074 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f2a262d | this.Load 외 9 | FP01620_WO_Create.cs:1074 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-94e2208b | this.Load 외 9 | FP01620_WO_Create.cs:1076 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) ▸ if ((object)clbLine is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtLine, (object)clbLine as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-811a40fd | this.Load 외 9 | FP01620_WO_Create.cs:1078 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) ▸ else of ((object)clbLine is UsrCombo) ▸ if ((object)clbLin… | LIST_REBIND | clsCtrl.setListBox | (dtLine, (object)clbLine as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-62445a2e | this.Load 외 9 | FP01620_WO_Create.cs:1084 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-11e906a0 | this.Load 외 9 | FP01620_WO_Create.cs:1098 | switch (triggerControl) case "PLAN_DATE": | FLAG | sPlanDate | drpPlanDate.Value.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-95e4946f | this.Load 외 9 | FP01620_WO_Create.cs:1099 | switch (triggerControl) case "PLAN_DATE": | FLAG | sDataID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-8cbaf8b3 | this.Load 외 9 | FP01620_WO_Create.cs:1100 | switch (triggerControl) case "PLAN_DATE": | FLAG | pInstanceID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-be56e566 | this.Load 외 9 | FP01620_WO_Create.cs:1101 | switch (triggerControl) case "PLAN_DATE": | FLAG | dtPlanID | Data_FP.Common_FP(Data_FP.Type.FP_PLAN_INFO, false, UserInfoContext.Current.UserId, _sNonA… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | 화면 필드/플래그 변경 |  |  |  |
| AC-cbd3e17c | this.Load 외 9 | FP01620_WO_Create.cs:1101 | switch (triggerControl) case "PLAN_DATE": | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FP_PLAN_INFO, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth ,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FP_PLAN_INFO] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-79849f7b | this.Load 외 9 | FP01620_WO_Create.cs:1105 | switch (triggerControl) case "PLAN_DATE": | LIST_REBIND | clsCtrl.setListBox | (dtPlanID, cboPlanID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6cbb02f9 | this.Load 외 9 | FP01620_WO_Create.cs:1115 | switch (triggerControl) case "PLANID": ▸ if (string.IsNullOrEmpty(sStart)) | UI_PROP | drpPeriod.Text1 | drpPlanDate.Text | 속성 Text1 설정 |  |  |  |
| AC-5a2bdba1 | this.Load 외 9 | FP01620_WO_Create.cs:1116 | switch (triggerControl) case "PLANID": ▸ if (string.IsNullOrEmpty(sStart)) | UI_PROP | drpPeriod.Text2 | DateUtil.GetDateAdd(sCurDate, 20, "D") | 속성 Text2 설정 |  |  |  |
| AC-b3ed7308 | this.Load 외 9 | FP01620_WO_Create.cs:1120 | switch (triggerControl) case "PLANID": ▸ else of (string.IsNullOrEmpty(sStart)) | UI_PROP | drpPeriod.Text1 | sStart | 속성 Text1 설정 |  |  |  |
| AC-78da174d | this.Load 외 9 | FP01620_WO_Create.cs:1121 | switch (triggerControl) case "PLANID": ▸ else of (string.IsNullOrEmpty(sStart)) | UI_PROP | drpPeriod.Text2 | sEnd | 속성 Text2 설정 |  |  |  |

## FP01620_WO_Create.tbItemId_BeforeOpenSearch

진입점: this.tbItemId.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-989ab2f5 | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:942 |  | DATA_OP | tbItemId.Filter["division_lt"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7711f3ab | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:943 |  | DATA_OP | tbItemId.Filter["site_lt"] | cboSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-58c5aeed | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:947 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 25) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d7c101d | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:948 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd977143 | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:949 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2939ca1 | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:950 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d9ea835 | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:951 |  | DATA_OP | _col_width.Add | ("item".ToUpper(), 150) | 데이터 객체 조작/조회 |  |  |  |
| AC-630ba3a1 | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:952 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 150) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ad4708e | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:953 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-32cddb3c | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:957 |  | DATA_OP | _col_title.Add | ("Material".ToUpper(), "Material") | 데이터 객체 조작/조회 |  |  |  |
| AC-58f050cd | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:959 |  | UI_PROP | tbItemId.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-437a4df4 | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:960 |  | UI_PROP | tbItemId.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |
| AC-800ca6e4 | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:962 |  | UI_PROP | tbItemId.PopupWidth | 800 | 속성 PopupWidth 설정 |  |  |  |
| AC-94a9db3e | this.tbItemId.BeforeOpenSearch | FP01620_WO_Create.cs:963 |  | UI_PROP | tbItemId.PopupHeight | 600 | 속성 PopupHeight 설정 |  |  |  |

## FP01620_WO_Create.tbItemId_OnSearchConditionChanged

진입점: this.tbItemId.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6a2e1e8 | this.tbItemId.OnSearchConditionChanged | FP01620_WO_Create.cs:977 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |


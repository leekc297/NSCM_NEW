# AS-IS 액션 대조표 — FP00514

> 원천: `Doc/asisfacts/screens/FP00514/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 957행 · 메서드 92 · 종류 DATA_OP 453 · RETURN 90 · FLAG 72 · MESSAGE 43 · UI_PROP 40 · ENDPOINT 34 · GRID_SET 33 · GRID_INIT 31 · COMBO_DATA 23 · POPUP 22 · LIST_REBIND 22 · UI_MISC 21 · GRID_LOCK 13 · CALL_EXT 9 · GRID_STYLE 8 · VALUE_SET 8 · STATE 8 · VALIDATE 7 · THROW 5 · GRID_BIND 4 · EXCEL 3 · CALL_BASE 3 · STATE_RESET 2 · FOCUS 1 · LIST_BIND 1 · GRID_COMBO 1 · ⚠ 의미 확인 필요 12


## FP00514_TEST_Target.btnAdd_Click

진입점: this.btnAdd.Click / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59ab4f33 | this.btnAdd.Click 외 1 | FP00514_TEST_Target.cs:828 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c0eb885 | this.btnAdd.Click 외 1 | FP00514_TEST_Target.cs:829 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-efed2f9c | this.btnAdd.Click 외 1 | FP00514_TEST_Target.cs:868 | try | POPUP | new FP00514_TestTargetMultiPopup | ("FP00514", "TEST_TargetMultiPopup", "FP_Master.PR_UI_FP00514_TEST_TARGET", sParamsFilter,… | 팝업/폼 생성 |  |  |  |
| AC-7efd8166 | this.btnAdd.Click 외 1 | FP00514_TEST_Target.cs:869 | try | UI_PROP | popComImport.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-54981260 | this.btnAdd.Click 외 1 | FP00514_TEST_Target.cs:870 | try | POPUP | popComImport.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00514_TEST_Target.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38e3bc24 | this.btnImport.Click | FP00514_TEST_Target.cs:929 | try ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-3d4144a7 | this.btnImport.Click | FP00514_TEST_Target.cs:933 | try | POPUP | new FP00514_TestTargetImportPopup | ("FP00514", "TEST_TargetImportPopup", "FP_Master.PR_UI_FP00514_TEST_TARGET", sParamsFilter… | 팝업/폼 생성 |  |  |  |
| AC-ca6a1f74 | this.btnImport.Click | FP00514_TEST_Target.cs:934 | try | UI_PROP | popTestImport.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-33470af4 | this.btnImport.Click | FP00514_TEST_Target.cs:935 | try | POPUP | popTestImport.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00514_TEST_Target.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3d2cac7 | this.btnSql.Click | FP00514_TEST_Target.cs:886 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ec217500 | this.btnSql.Click | FP00514_TEST_Target.cs:887 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-40aab71b | this.btnSql.Click | FP00514_TEST_Target.cs:889 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00514_TEST_TARGET") | 데이터 객체 조작/조회 |  |  |  |
| AC-07e2bbea | this.btnSql.Click | FP00514_TEST_Target.cs:890 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00514_TEST_TARGET_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e95c5e21 | this.btnSql.Click | FP00514_TEST_Target.cs:891 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00514_TEST_Target.CboSite_SelectedIndexChanged

진입점: this.Load [try] / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a3f91d7 | this.Load [try] 외 1 | FP00514_TEST_Target.cs:1068 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f88281d6 | this.Load [try] 외 1 | FP00514_TEST_Target.cs:1070 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00514_TEST_Target.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eabaca3 | (진입점 미연결) | FP00514_TEST_Target.cs:286 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-bbdbc568 | (진입점 미연결) | FP00514_TEST_Target.cs:287 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00514_TEST_Target.CreateExelBufferDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c42c04d | (진입점 미연결) | FP00514_TEST_Target.cs:1130 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-353ae9c7 | (진입점 미연결) | FP00514_TEST_Target.cs:1132 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-06f8454a | (진입점 미연결) | FP00514_TEST_Target.cs:1133 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bce11d27 | (진입점 미연결) | FP00514_TEST_Target.cs:1134 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d0767ce | (진입점 미연결) | FP00514_TEST_Target.cs:1135 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b086af77 | (진입점 미연결) | FP00514_TEST_Target.cs:1136 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TEST_TARGET_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-260cdf03 | (진입점 미연결) | FP00514_TEST_Target.cs:1137 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MODEL", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2abf7ac | (진입점 미연결) | FP00514_TEST_Target.cs:1138 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-80afcb9c | (진입점 미연결) | FP00514_TEST_Target.cs:1139 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-43e3f16d | (진입점 미연결) | FP00514_TEST_Target.cs:1140 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0f3d5c2 | (진입점 미연결) | FP00514_TEST_Target.cs:1141 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-edc2531b | (진입점 미연결) | FP00514_TEST_Target.cs:1142 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cc9d0ea | (진입점 미연결) | FP00514_TEST_Target.cs:1143 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-768a5134 | (진입점 미연결) | FP00514_TEST_Target.cs:1144 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DUE_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd371fc5 | (진입점 미연결) | FP00514_TEST_Target.cs:1145 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MFG_WEEK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-91016b8d | (진입점 미연결) | FP00514_TEST_Target.cs:1146 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MFG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d139f1a4 | (진입점 미연결) | FP00514_TEST_Target.cs:1147 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DESCRIPTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc67d134 | (진입점 미연결) | FP00514_TEST_Target.cs:1148 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NICK_NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2ee99d5 | (진입점 미연결) | FP00514_TEST_Target.cs:1149 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IS_PREV_SCHEDULE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a3ce298 | (진입점 미연결) | FP00514_TEST_Target.cs:1150 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DEMAND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-de15dd33 | (진입점 미연결) | FP00514_TEST_Target.cs:1151 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SCP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b745b1da | (진입점 미연결) | FP00514_TEST_Target.cs:1153 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a335a76 | this.Load | FP00514_TEST_Target.cs:296 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9607eb6c | this.Load | FP00514_TEST_Target.cs:297 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-108d509d | this.Load | FP00514_TEST_Target.cs:299 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00514_TEST_Target.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b02c74f9 | this.Load | FP00514_TEST_Target.cs:204 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-29cd8d6e | this.Load | FP00514_TEST_Target.cs:206 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-8c797bc1 | this.Load | FP00514_TEST_Target.cs:207 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-9c9e41ca | this.Load | FP00514_TEST_Target.cs:208 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP00514_TEST_Target.Delete_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7d73f5d | (진입점 미연결) | FP00514_TEST_Target.cs:1722 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00514_TEST_TARGET") ⇒ FP_Master.PR_UI_FP00514_TEST_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-74594e65 | (진입점 미연결) | FP00514_TEST_Target.cs:1723 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-54256c73 | (진입점 미연결) | FP00514_TEST_Target.cs:1725 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-c8f40255 | (진입점 미연결) | FP00514_TEST_Target.cs:1726 | try | DATA_OP | req.Parameters["p_sys_flag"] | "DELETE_BUFFER" | 행/컬럼 값 대입 |  |  |  |
| AC-7a19a466 | (진입점 미연결) | FP00514_TEST_Target.cs:1727 | try | DATA_OP | req.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-30b4edf0 | (진입점 미연결) | FP00514_TEST_Target.cs:1728 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a2d239e8 | (진입점 미연결) | FP00514_TEST_Target.cs:1730 | try | DATA_OP | req.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-610d4877 | (진입점 미연결) | FP00514_TEST_Target.cs:1731 | try | DATA_OP | req.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a89aa904 | (진입점 미연결) | FP00514_TEST_Target.cs:1732 | try | DATA_OP | req.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9bda319c | (진입점 미연결) | FP00514_TEST_Target.cs:1733 | try | DATA_OP | req.Parameters["p_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fc3566e0 | (진입점 미연결) | FP00514_TEST_Target.cs:1735 | try | DATA_OP | req.Parameters["p_mfg_start_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6378d960 | (진입점 미연결) | FP00514_TEST_Target.cs:1736 | try | DATA_OP | req.Parameters["p_mfg_end_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-63d6bbf8 | (진입점 미연결) | FP00514_TEST_Target.cs:1737 | try | DATA_OP | req.Parameters["p_item_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c77c1c06 | (진입점 미연결) | FP00514_TEST_Target.cs:1738 | try | DATA_OP | req.Parameters["p_model"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-52b52bd3 | (진입점 미연결) | FP00514_TEST_Target.cs:1739 | try | DATA_OP | req.Parameters["p_nick_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ff4be26a | (진입점 미연결) | FP00514_TEST_Target.cs:1740 | try | DATA_OP | req.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-51a1df43 | (진입점 미연결) | FP00514_TEST_Target.cs:1741 | try | DATA_OP | req.Parameters["p_operation_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cfb9bf9b | (진입점 미연결) | FP00514_TEST_Target.cs:1742 | try | DATA_OP | req.Parameters["p_line_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2eb8d93d | (진입점 미연결) | FP00514_TEST_Target.cs:1743 | try | DATA_OP | req.Parameters["p_line_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-dff44fda | (진입점 미연결) | FP00514_TEST_Target.cs:1744 | try | DATA_OP | req.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9180efdd | (진입점 미연결) | FP00514_TEST_Target.cs:1745 | try | DATA_OP | req.Parameters["p_production_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1623c274 | (진입점 미연결) | FP00514_TEST_Target.cs:1746 | try | DATA_OP | req.Parameters["p_due_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8fc7103c | (진입점 미연결) | FP00514_TEST_Target.cs:1747 | try | DATA_OP | req.Parameters["p_mfg_week"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fa61d25a | (진입점 미연결) | FP00514_TEST_Target.cs:1748 | try | DATA_OP | req.Parameters["p_mfg_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2d3035b9 | (진입점 미연결) | FP00514_TEST_Target.cs:1749 | try | DATA_OP | req.Parameters["p_is_prev_schedule"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b68d0ea7 | (진입점 미연결) | FP00514_TEST_Target.cs:1750 | try | DATA_OP | req.Parameters["p_demand_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-aed99392 | (진입점 미연결) | FP00514_TEST_Target.cs:1751 | try | DATA_OP | req.Parameters["p_scp_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-338f0e80 | (진입점 미연결) | FP00514_TEST_Target.cs:1752 | try | DATA_OP | req.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-12fd4c15 | (진입점 미연결) | FP00514_TEST_Target.cs:1753 | try | DATA_OP | req.Parameters["p_test_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d24885ec | (진입점 미연결) | FP00514_TEST_Target.cs:1754 | try | DATA_OP | req.Parameters["p_electrode_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4e27e0cf | (진입점 미연결) | FP00514_TEST_Target.cs:1756 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-06ecd840 | (진입점 미연결) | FP00514_TEST_Target.cs:1758 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-87611dcc | (진입점 미연결) | FP00514_TEST_Target.cs:1762 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45b67003 | DeleteButton | FP00514_TEST_Target.cs:428 |  | MESSAGE | MessageBox.Show | ("Delete Button can't use.!") | 메시지 표시 |  |  |  |
| AC-0acceb9e | DeleteButton | FP00514_TEST_Target.cs:429 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9ce5c18 | Dispose | FP00514_TEST_Target.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00514_TEST_Target.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23d0b435 | EditButton | FP00514_TEST_Target.cs:371 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5a11fc88 | EditButton | FP00514_TEST_Target.cs:373 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-11282edb | EditButton | FP00514_TEST_Target.cs:375 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.MFG_WEEK)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a0550c4f | EditButton | FP00514_TEST_Target.cs:376 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.IS_PREV_SCHEDULE), siMain.GetColumnIndex(DefColumns.UPDA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-95b8f3d0 | EditButton | FP00514_TEST_Target.cs:377 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TEST_TARGET_ID), siMain.GetColumnIndex(DefColumns.TEST_T… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c5db7d83 | EditButton | FP00514_TEST_Target.cs:387 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-d427a877 | EditButton | FP00514_TEST_Target.cs:391 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) ▸ if (i % 2 == 1) | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-a0da17bc | EditButton | FP00514_TEST_Target.cs:395 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) ▸ else of (i % 2 == … | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-b8ea7cba | EditButton | FP00514_TEST_Target.cs:403 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ if (i % 2 == … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.MFG_QTY), i, siMain.GetColumnIndex(DefColumns.MFG_QTY… | 그리드 표시 설정 |  |  |  |
| AC-2895dd23 | EditButton | FP00514_TEST_Target.cs:404 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ if (i % 2 == … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DESCRIPTION), i, siMain.GetColumnIndex(DefColumns.DES… | 그리드 표시 설정 |  |  |  |
| AC-a608d0d9 | EditButton | FP00514_TEST_Target.cs:408 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ else of (i % … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.MFG_QTY), i, siMain.GetColumnIndex(DefColumns.MFG_QTY… | 그리드 표시 설정 |  |  |  |
| AC-aa322473 | EditButton | FP00514_TEST_Target.cs:409 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ else of (i % … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DESCRIPTION), i, siMain.GetColumnIndex(DefColumns.DES… | 그리드 표시 설정 |  |  |  |

## FP00514_TEST_Target.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-daf090b7 | ExcelButton | FP00514_TEST_Target.cs:814 |  | EXCEL | ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00514_TEST_Target.ExcelPopup_ImportValidation_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-640f2782 | (진입점 미연결) | FP00514_TEST_Target.cs:1273 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7958a929 | (진입점 미연결) | FP00514_TEST_Target.cs:1275 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | data.Tables[0].Rows[i]["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7556ad60 | (진입점 미연결) | FP00514_TEST_Target.cs:1276 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2a099d7c | (진입점 미연결) | FP00514_TEST_Target.cs:1277 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0929cd39 | (진입점 미연결) | FP00514_TEST_Target.cs:1278 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-69744837 | (진입점 미연결) | FP00514_TEST_Target.cs:1279 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["TEST_TARGET_ID"] | data.Tables[0].Rows[i]["TEST_TARGET_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-70578ba3 | (진입점 미연결) | FP00514_TEST_Target.cs:1280 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MODEL"] | data.Tables[0].Rows[i]["MODEL"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ff4a778 | (진입점 미연결) | FP00514_TEST_Target.cs:1281 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e4491c0d | (진입점 미연결) | FP00514_TEST_Target.cs:1282 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-424e491d | (진입점 미연결) | FP00514_TEST_Target.cs:1283 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-35034761 | (진입점 미연결) | FP00514_TEST_Target.cs:1284 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5b34c242 | (진입점 미연결) | FP00514_TEST_Target.cs:1285 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-26563bb2 | (진입점 미연결) | FP00514_TEST_Target.cs:1286 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c018ec7d | (진입점 미연결) | FP00514_TEST_Target.cs:1287 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DUE_DATE"] | data.Tables[0].Rows[i]["DUE_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-352b6b15 | (진입점 미연결) | FP00514_TEST_Target.cs:1288 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MFG_WEEK"] | data.Tables[0].Rows[i]["MFG_WEEK"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ed73801f | (진입점 미연결) | FP00514_TEST_Target.cs:1289 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MFG_QTY"] | data.Tables[0].Rows[i]["MFG_QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cf3abaaf | (진입점 미연결) | FP00514_TEST_Target.cs:1290 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DESCRIPTION"] | data.Tables[0].Rows[i]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-efec756f | (진입점 미연결) | FP00514_TEST_Target.cs:1291 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["NICK_NAME"] | data.Tables[0].Rows[i]["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e423a750 | (진입점 미연결) | FP00514_TEST_Target.cs:1292 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["IS_PREV_SCHEDULE"] | data.Tables[0].Rows[i]["IS_PREV_SCHEDULE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e4ce1556 | (진입점 미연결) | FP00514_TEST_Target.cs:1293 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DEMAND_TYPE"] | data.Tables[0].Rows[i]["DEMAND_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7d09573d | (진입점 미연결) | FP00514_TEST_Target.cs:1294 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SCP_PLAN_ID"] | data.Tables[0].Rows[i]["SCP_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-69fda269 | (진입점 미연결) | FP00514_TEST_Target.cs:1298 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-9490fa8b | (진입점 미연결) | FP00514_TEST_Target.cs:1301 | try | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-47f30b67 | (진입점 미연결) | FP00514_TEST_Target.cs:1319 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f407772d | (진입점 미연결) | FP00514_TEST_Target.cs:1324 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-042bf78e | (진입점 미연결) | FP00514_TEST_Target.cs:1326 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-790173fa | (진입점 미연결) | FP00514_TEST_Target.cs:1329 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-41eafa46 | (진입점 미연결) | FP00514_TEST_Target.cs:1338 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4ed7480f | (진입점 미연결) | FP00514_TEST_Target.cs:1339 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-97a8e871 | (진입점 미연결) | FP00514_TEST_Target.cs:1344 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-dc0d13a1 | (진입점 미연결) | FP00514_TEST_Target.cs:1349 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ca06606 | (진입점 미연결) | FP00514_TEST_Target.cs:1350 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.ExcelPopup_SaveExcel_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c095c54 | (진입점 미연결) | FP00514_TEST_Target.cs:1559 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds1.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-15d8770d | (진입점 미연결) | FP00514_TEST_Target.cs:1560 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds1.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-2b87579e | (진입점 미연결) | FP00514_TEST_Target.cs:1565 |  | RETURN | return ds1; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.ExcelPopup_Search_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0c115d1 | (진입점 미연결) | FP00514_TEST_Target.cs:1165 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-056f23da | (진입점 미연결) | FP00514_TEST_Target.cs:1167 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.Find_Data

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2a7006e | FindButton 외 1 | FP00514_TEST_Target.cs:452 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-289a4012 | FindButton 외 1 | FP00514_TEST_Target.cs:457 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1db5f227 | FindButton 외 1 | FP00514_TEST_Target.cs:458 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5baaddb5 | FindButton 외 1 | FP00514_TEST_Target.cs:461 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-546ef2f8 | FindButton 외 1 | FP00514_TEST_Target.cs:464 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ecbb028e | FindButton 외 1 | FP00514_TEST_Target.cs:467 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-1cfb5a43 | FindButton 외 1 | FP00514_TEST_Target.cs:467 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b24f379 | FindButton 외 1 | FP00514_TEST_Target.cs:473 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-879c13fa | FindButton 외 1 | FP00514_TEST_Target.cs:476 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf6dee8a | FindButton 외 1 | FP00514_TEST_Target.cs:483 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-040b43a9 | FindButton 외 1 | FP00514_TEST_Target.cs:484 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Line("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4de4c8b6 | FindButton 외 1 | FP00514_TEST_Target.cs:495 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b26eba1f | FindButton 외 1 | FP00514_TEST_Target.cs:497 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c86c5f3 | FindButton 외 1 | FP00514_TEST_Target.cs:500 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e69e4674 | FindButton 외 1 | FP00514_TEST_Target.cs:504 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9ccd36ea | FindButton 외 1 | FP00514_TEST_Target.cs:512 | try | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-c4bf2aed | FindButton 외 1 | FP00514_TEST_Target.cs:518 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-19909594 | FindButton 외 1 | FP00514_TEST_Target.cs:519 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b7257890 | FindButton 외 1 | FP00514_TEST_Target.cs:520 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-d831124e | FindButton 외 1 | FP00514_TEST_Target.cs:521 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-35e1856a | FindButton 외 1 | FP00514_TEST_Target.cs:521 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP00514_TEST_Target.Find_Data_Excel_Buffer_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af20240d | (진입점 미연결) | FP00514_TEST_Target.cs:1494 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00514_TEST_TARGET") ⇒ FP_Master.PR_UI_FP00514_TEST_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-4b65f474 | (진입점 미연결) | FP00514_TEST_Target.cs:1495 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6b30ca9d | (진입점 미연결) | FP00514_TEST_Target.cs:1496 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-96af3c04 | (진입점 미연결) | FP00514_TEST_Target.cs:1497 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-a326be39 | (진입점 미연결) | FP00514_TEST_Target.cs:1498 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-34367d28 | (진입점 미연결) | FP00514_TEST_Target.cs:1499 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ca2fc127 | (진입점 미연결) | FP00514_TEST_Target.cs:1501 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4a024534 | (진입점 미연결) | FP00514_TEST_Target.cs:1502 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-89fbfbbc | (진입점 미연결) | FP00514_TEST_Target.cs:1503 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-650a8eee | (진입점 미연결) | FP00514_TEST_Target.cs:1504 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-99dd687c | (진입점 미연결) | FP00514_TEST_Target.cs:1505 | try | DATA_OP | request.Parameters["p_mfg_start_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5cf8b9e0 | (진입점 미연결) | FP00514_TEST_Target.cs:1506 | try | DATA_OP | request.Parameters["p_mfg_end_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-101f761c | (진입점 미연결) | FP00514_TEST_Target.cs:1507 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c5339202 | (진입점 미연결) | FP00514_TEST_Target.cs:1508 | try | DATA_OP | request.Parameters["p_model"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a3d216ec | (진입점 미연결) | FP00514_TEST_Target.cs:1509 | try | DATA_OP | request.Parameters["p_nick_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cb1b6259 | (진입점 미연결) | FP00514_TEST_Target.cs:1510 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8098b287 | (진입점 미연결) | FP00514_TEST_Target.cs:1511 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fe048f29 | (진입점 미연결) | FP00514_TEST_Target.cs:1512 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e38a1bba | (진입점 미연결) | FP00514_TEST_Target.cs:1513 | try | DATA_OP | request.Parameters["p_line_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-328459d0 | (진입점 미연결) | FP00514_TEST_Target.cs:1514 | try | DATA_OP | request.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-be6495da | (진입점 미연결) | FP00514_TEST_Target.cs:1515 | try | DATA_OP | request.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4dd8c6f3 | (진입점 미연결) | FP00514_TEST_Target.cs:1516 | try | DATA_OP | request.Parameters["p_due_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eefaff73 | (진입점 미연결) | FP00514_TEST_Target.cs:1517 | try | DATA_OP | request.Parameters["p_mfg_week"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bd9dae2e | (진입점 미연결) | FP00514_TEST_Target.cs:1518 | try | DATA_OP | request.Parameters["p_mfg_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2cd7a6f5 | (진입점 미연결) | FP00514_TEST_Target.cs:1519 | try | DATA_OP | request.Parameters["p_is_prev_schedule"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-436a782a | (진입점 미연결) | FP00514_TEST_Target.cs:1520 | try | DATA_OP | request.Parameters["p_demand_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-25316f61 | (진입점 미연결) | FP00514_TEST_Target.cs:1521 | try | DATA_OP | request.Parameters["p_scp_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-37408348 | (진입점 미연결) | FP00514_TEST_Target.cs:1522 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-de15f44b | (진입점 미연결) | FP00514_TEST_Target.cs:1523 | try | DATA_OP | request.Parameters["p_test_target_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-274de462 | (진입점 미연결) | FP00514_TEST_Target.cs:1524 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-70c68b50 | (진입점 미연결) | FP00514_TEST_Target.cs:1526 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4871ac95 | (진입점 미연결) | FP00514_TEST_Target.cs:1528 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8ad5aff8 | (진입점 미연결) | FP00514_TEST_Target.cs:1534 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.Find_Data_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7f9f492 | (진입점 미연결) | FP00514_TEST_Target.cs:1181 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_division_id = CString.GetCheckedListValue(dtDivision, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b0e3a1d | (진입점 미연결) | FP00514_TEST_Target.cs:1196 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00514_TEST_TARGET") ⇒ FP_Master.PR_UI_FP00514_TEST_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-7888564b | (진입점 미연결) | FP00514_TEST_Target.cs:1198 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d918a78a | (진입점 미연결) | FP00514_TEST_Target.cs:1199 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-dd129855 | (진입점 미연결) | FP00514_TEST_Target.cs:1200 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_IMPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-d91ede5b | (진입점 미연결) | FP00514_TEST_Target.cs:1201 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d064f74d | (진입점 미연결) | FP00514_TEST_Target.cs:1202 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-81dd0fd7 | (진입점 미연결) | FP00514_TEST_Target.cs:1204 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-266ab396 | (진입점 미연결) | FP00514_TEST_Target.cs:1205 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-61bb37fc | (진입점 미연결) | FP00514_TEST_Target.cs:1206 | try | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-01f7f2a5 | (진입점 미연결) | FP00514_TEST_Target.cs:1207 | try | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-58eb892f | (진입점 미연결) | FP00514_TEST_Target.cs:1209 | try | DATA_OP | request.Parameters["p_mfg_start_date"] | p_mfg_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-b84e8e4e | (진입점 미연결) | FP00514_TEST_Target.cs:1210 | try | DATA_OP | request.Parameters["p_mfg_end_date"] | p_mfg_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-9217160a | (진입점 미연결) | FP00514_TEST_Target.cs:1211 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-9f589cad | (진입점 미연결) | FP00514_TEST_Target.cs:1212 | try | DATA_OP | request.Parameters["p_model"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9bfcfbd5 | (진입점 미연결) | FP00514_TEST_Target.cs:1213 | try | DATA_OP | request.Parameters["p_nick_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7d6d418b | (진입점 미연결) | FP00514_TEST_Target.cs:1214 | try | DATA_OP | request.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-91bdcef4 | (진입점 미연결) | FP00514_TEST_Target.cs:1215 | try | DATA_OP | request.Parameters["p_operation_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e851636f | (진입점 미연결) | FP00514_TEST_Target.cs:1216 | try | DATA_OP | request.Parameters["p_line_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1fb47c38 | (진입점 미연결) | FP00514_TEST_Target.cs:1217 | try | DATA_OP | request.Parameters["p_line_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9b2a13a5 | (진입점 미연결) | FP00514_TEST_Target.cs:1218 | try | DATA_OP | request.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a3047d8e | (진입점 미연결) | FP00514_TEST_Target.cs:1219 | try | DATA_OP | request.Parameters["p_production_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4558fcf4 | (진입점 미연결) | FP00514_TEST_Target.cs:1220 | try | DATA_OP | request.Parameters["p_due_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2def9ec4 | (진입점 미연결) | FP00514_TEST_Target.cs:1221 | try | DATA_OP | request.Parameters["p_mfg_week"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f2a40a7d | (진입점 미연결) | FP00514_TEST_Target.cs:1222 | try | DATA_OP | request.Parameters["p_mfg_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ff28d4f3 | (진입점 미연결) | FP00514_TEST_Target.cs:1223 | try | DATA_OP | request.Parameters["p_is_prev_schedule"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-365eee8d | (진입점 미연결) | FP00514_TEST_Target.cs:1224 | try | DATA_OP | request.Parameters["p_demand_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f8c700d4 | (진입점 미연결) | FP00514_TEST_Target.cs:1225 | try | DATA_OP | request.Parameters["p_scp_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-92d94a62 | (진입점 미연결) | FP00514_TEST_Target.cs:1226 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bc2f7a1c | (진입점 미연결) | FP00514_TEST_Target.cs:1227 | try | DATA_OP | request.Parameters["p_test_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-727c6f9b | (진입점 미연결) | FP00514_TEST_Target.cs:1228 | try | DATA_OP | request.Parameters["p_electrode_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7904bb9e | (진입점 미연결) | FP00514_TEST_Target.cs:1230 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9d4602ce | (진입점 미연결) | FP00514_TEST_Target.cs:1232 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1cb13d52 | (진입점 미연결) | FP00514_TEST_Target.cs:1237 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.Find_Data_Line

진입점: popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-935881f9 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:534 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_division_id = CString.GetCheckedListValue(dtDivision, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b92530ca | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:548 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00514_TEST_TARGET") ⇒ FP_Master.PR_UI_FP00514_TEST_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-acbe49a0 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:550 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-63670d3a | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:551 | try | DATA_OP | request.Parameters["p_sys_flag"] | "S" | 행/컬럼 값 대입 |  |  |  |
| AC-3b06d3b3 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:552 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7f63c7dc | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:553 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e01bbbc2 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:555 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2d1f545f | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:556 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ff66501c | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:557 | try | DATA_OP | request.Parameters["p_site_id"] | p_site_id.Equals("ALL") ? DBNull.Value : p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-4f1ae015 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:558 | try | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id.Equals("ALL") ? DBNull.Value : p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-41567731 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:560 | try | DATA_OP | request.Parameters["p_mfg_start_date"] | p_mfg_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-898e43d8 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:561 | try | DATA_OP | request.Parameters["p_mfg_end_date"] | p_mfg_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-7029bb1f | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:562 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-efdecd04 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:563 | try | DATA_OP | request.Parameters["p_model"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fa3e43c0 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:564 | try | DATA_OP | request.Parameters["p_nick_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8d3a4209 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:565 | try | DATA_OP | request.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-65d97071 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:566 | try | DATA_OP | request.Parameters["p_operation_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fe8bd409 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:567 | try | DATA_OP | request.Parameters["p_line_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-be394aef | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:568 | try | DATA_OP | request.Parameters["p_line_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-46b86006 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:569 | try | DATA_OP | request.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a367ecd8 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:570 | try | DATA_OP | request.Parameters["p_production_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a93abeb4 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:571 | try | DATA_OP | request.Parameters["p_due_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4b3b6b48 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:572 | try | DATA_OP | request.Parameters["p_mfg_week"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4d658aa1 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:573 | try | DATA_OP | request.Parameters["p_mfg_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f7a17466 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:574 | try | DATA_OP | request.Parameters["p_is_prev_schedule"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d6027f4f | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:575 | try | DATA_OP | request.Parameters["p_demand_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cb4eb1cd | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:576 | try | DATA_OP | request.Parameters["p_scp_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b0042377 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:577 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-850ec1ec | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:578 | try | DATA_OP | request.Parameters["p_test_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a675c76f | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:579 | try | DATA_OP | request.Parameters["p_electrode_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4b92905a | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:581 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6c50b3d4 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:583 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-85542d10 | popSql.OnSql [if (programID == "PR_UI_FP00514_TEST_TARGET")] 외 2 | FP00514_TEST_Target.cs:588 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2814a753 | this.Load | FP00514_TEST_Target.cs:114 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00514_TEST_Target.GetDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f095a23 | this.Load [try] | FP00514_TEST_Target.cs:1814 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-234ab882 | this.Load [try] | FP00514_TEST_Target.cs:1815 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9aa0267d | this.Load [try] | FP00514_TEST_Target.cs:1815 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f4f1ddee | this.Load [try] | FP00514_TEST_Target.cs:1816 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00514_TEST_Target.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5df18e6 | this.Load | FP00514_TEST_Target.cs:135 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b018680 | this.Load | FP00514_TEST_Target.cs:141 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-da10bdc2 | this.Load | FP00514_TEST_Target.cs:142 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4d06c228 | this.Load | FP00514_TEST_Target.cs:147 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-31b03228 | this.Load | FP00514_TEST_Target.cs:149 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-d999e44f | this.Load | FP00514_TEST_Target.cs:153 | try | FLAG | dtMFGDate | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00514_findMFGDate") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-c055c6dc | this.Load | FP00514_TEST_Target.cs:153 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00514_findMFGDate") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a07877cc | this.Load | FP00514_TEST_Target.cs:160 | try ▸ if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-bc24f59b | this.Load | FP00514_TEST_Target.cs:170 | try ▸ if (dtMFGDate.Rows.Count > 0) | VALUE_SET | drpPeriod.InitValue | dtMFGDate.Rows[0]["MIN_DATE"].ToString() + ":" + dtMFGDate.Rows[0]["MAX_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-524aa55b | this.Load | FP00514_TEST_Target.cs:180 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-7b79d2c2 | this.Load | FP00514_TEST_Target.cs:181 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8287000c | this.Load | FP00514_TEST_Target.cs:182 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d2f3cc11 | this.Load | FP00514_TEST_Target.cs:188 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnImport.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-4bc42d22 | this.Load | FP00514_TEST_Target.cs:189 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7752119a | this.Load | FP00514_TEST_Target.cs:190 | try ▸ if (!_sSaveAuth.Equals("Y")) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d63524af | this.Load | FP00514_TEST_Target.cs:197 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00514_TEST_Target.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14ffa3b7 | this.Load | FP00514_TEST_Target.cs:311 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-006e2f4f | this.Load | FP00514_TEST_Target.cs:312 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-83c7afb1 | this.Load | FP00514_TEST_Target.cs:316 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00514_TEST_Target.Insert_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f5b9190 | (진입점 미연결) | FP00514_TEST_Target.cs:1437 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00514_TEST_TARGET") ⇒ FP_Master.PR_UI_FP00514_TEST_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-bb875f3d | (진입점 미연결) | FP00514_TEST_Target.cs:1438 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2f69f453 | (진입점 미연결) | FP00514_TEST_Target.cs:1440 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-1217bf87 | (진입점 미연결) | FP00514_TEST_Target.cs:1441 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-45084a1e | (진입점 미연결) | FP00514_TEST_Target.cs:1442 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-d07de0e2 | (진입점 미연결) | FP00514_TEST_Target.cs:1443 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-eaa3c85b | (진입점 미연결) | FP00514_TEST_Target.cs:1445 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-ff6fc286 | (진입점 미연결) | FP00514_TEST_Target.cs:1446 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-54e113f3 | (진입점 미연결) | FP00514_TEST_Target.cs:1447 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d89f2d17 | (진입점 미연결) | FP00514_TEST_Target.cs:1448 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-e5b1b16a | (진입점 미연결) | FP00514_TEST_Target.cs:1450 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_start_date"] | p_mfg_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-8646b5bd | (진입점 미연결) | FP00514_TEST_Target.cs:1451 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_end_date"] | p_mfg_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-8b431cd6 | (진입점 미연결) | FP00514_TEST_Target.cs:1452 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0ab61af9 | (진입점 미연결) | FP00514_TEST_Target.cs:1453 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model"] | p_model | 행/컬럼 값 대입 |  |  |  |
| AC-d8fe7877 | (진입점 미연결) | FP00514_TEST_Target.cs:1454 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-59c14589 | (진입점 미연결) | FP00514_TEST_Target.cs:1455 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-b8d9fd43 | (진입점 미연결) | FP00514_TEST_Target.cs:1456 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-b4c311e8 | (진입점 미연결) | FP00514_TEST_Target.cs:1457 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-ac397aa1 | (진입점 미연결) | FP00514_TEST_Target.cs:1458 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-49afa2b9 | (진입점 미연결) | FP00514_TEST_Target.cs:1459 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-e91f1de1 | (진입점 미연결) | FP00514_TEST_Target.cs:1460 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-91c3f6aa | (진입점 미연결) | FP00514_TEST_Target.cs:1461 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_due_date"] | p_due_date | 행/컬럼 값 대입 |  |  |  |
| AC-238a5c96 | (진입점 미연결) | FP00514_TEST_Target.cs:1462 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-0e0f73f0 | (진입점 미연결) | FP00514_TEST_Target.cs:1463 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_qty"] | p_mfg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-bb89e931 | (진입점 미연결) | FP00514_TEST_Target.cs:1464 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_is_prev_schedule"] | p_is_prev_schedule | 행/컬럼 값 대입 |  |  |  |
| AC-7c9ee075 | (진입점 미연결) | FP00514_TEST_Target.cs:1465 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_demand_type"] | p_demand_type | 행/컬럼 값 대입 |  |  |  |
| AC-22ead2c9 | (진입점 미연결) | FP00514_TEST_Target.cs:1466 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-d507d305 | (진입점 미연결) | FP00514_TEST_Target.cs:1467 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-e4e6baad | (진입점 미연결) | FP00514_TEST_Target.cs:1468 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_test_target_id"] | p_test_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-e4becb8d | (진입점 미연결) | FP00514_TEST_Target.cs:1469 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-3b13b78f | (진입점 미연결) | FP00514_TEST_Target.cs:1471 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2068397d | (진입점 미연결) | FP00514_TEST_Target.cs:1477 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-6a02c677 | (진입점 미연결) | FP00514_TEST_Target.cs:1481 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-23240783 | (진입점 미연결) | FP00514_TEST_Target.cs:1483 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.Insert_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4a31328 | (진입점 미연결) | FP00514_TEST_Target.cs:599 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-85580d95 | (진입점 미연결) | FP00514_TEST_Target.cs:608 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.IS_PREV_SCHEDULE, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e11c51c | (진입점 미연결) | FP00514_TEST_Target.cs:610 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-d7a4d138 | (진입점 미연결) | FP00514_TEST_Target.cs:612 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |

## FP00514_TEST_Target.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f0d8ff6 | popSql.OnSql | FP00514_TEST_Target.cs:1115 | if (programID == "PR_UI_FP00514_TEST_TARGET") | RETURN | return Find_Data_Line("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-f3f14917 | popSql.OnSql | FP00514_TEST_Target.cs:1119 | else of (programID == "PR_UI_FP00514_TEST_TARGET") ▸ if (programID == "PR_UI_FP00514_TEST_TARGET_SAVE") | RETURN | return Save_Data_Test("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-57d6da3c | popSql.OnSql | FP00514_TEST_Target.cs:1121 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-212878d6 | SaveButton | FP00514_TEST_Target.cs:620 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e6738024 | SaveButton | FP00514_TEST_Target.cs:622 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef6818c6 | SaveButton | FP00514_TEST_Target.cs:627 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-99a449ad | SaveButton | FP00514_TEST_Target.cs:628 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88c7d305 | SaveButton | FP00514_TEST_Target.cs:631 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5f9c880d | SaveButton | FP00514_TEST_Target.cs:638 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-72040ec0 | SaveButton | FP00514_TEST_Target.cs:640 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fabec1ed | SaveButton | FP00514_TEST_Target.cs:641 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-212546d3 | SaveButton | FP00514_TEST_Target.cs:646 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-35e4e800 | SaveButton | FP00514_TEST_Target.cs:651 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1326b758 | SaveButton | FP00514_TEST_Target.cs:660 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-332fc95d | SaveButton | FP00514_TEST_Target.cs:664 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7f967e71 | SaveButton | FP00514_TEST_Target.cs:668 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-278ed041 | SaveButton | FP00514_TEST_Target.cs:669 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c7a11f2 | SaveButton | FP00514_TEST_Target.cs:674 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00514_TEST_Target.Save_Data_Excel_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d9dfb18 | (진입점 미연결) | FP00514_TEST_Target.cs:1606 | try ▸ if (string.IsNullOrEmpty(pSysFlag)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-edc84e69 | (진입점 미연결) | FP00514_TEST_Target.cs:1654 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00514_TEST_TARGET") ⇒ FP_Master.PR_UI_FP00514_TEST_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-75bc870e | (진입점 미연결) | FP00514_TEST_Target.cs:1655 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d9f7c06e | (진입점 미연결) | FP00514_TEST_Target.cs:1657 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-672137e2 | (진입점 미연결) | FP00514_TEST_Target.cs:1658 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e3203246 | (진입점 미연결) | FP00514_TEST_Target.cs:1659 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-633f492e | (진입점 미연결) | FP00514_TEST_Target.cs:1660 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-f12b1343 | (진입점 미연결) | FP00514_TEST_Target.cs:1662 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-54121173 | (진입점 미연결) | FP00514_TEST_Target.cs:1663 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d7f27daf | (진입점 미연결) | FP00514_TEST_Target.cs:1664 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-c70a90ef | (진입점 미연결) | FP00514_TEST_Target.cs:1665 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-d461fab3 | (진입점 미연결) | FP00514_TEST_Target.cs:1667 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_start_date"] | p_mfg_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-fa0cd0c0 | (진입점 미연결) | FP00514_TEST_Target.cs:1668 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_end_date"] | p_mfg_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-4ccedacc | (진입점 미연결) | FP00514_TEST_Target.cs:1669 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-7a15fbbb | (진입점 미연결) | FP00514_TEST_Target.cs:1670 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model"] | p_model | 행/컬럼 값 대입 |  |  |  |
| AC-23d518bb | (진입점 미연결) | FP00514_TEST_Target.cs:1671 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-6035c143 | (진입점 미연결) | FP00514_TEST_Target.cs:1672 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-76df27c6 | (진입점 미연결) | FP00514_TEST_Target.cs:1673 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-be0b2fa7 | (진입점 미연결) | FP00514_TEST_Target.cs:1674 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-57fd2900 | (진입점 미연결) | FP00514_TEST_Target.cs:1675 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-c5ca3edb | (진입점 미연결) | FP00514_TEST_Target.cs:1676 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-9186b567 | (진입점 미연결) | FP00514_TEST_Target.cs:1677 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-cc46622e | (진입점 미연결) | FP00514_TEST_Target.cs:1678 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_due_date"] | p_due_date | 행/컬럼 값 대입 |  |  |  |
| AC-cf244bb1 | (진입점 미연결) | FP00514_TEST_Target.cs:1679 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-6c7fb690 | (진입점 미연결) | FP00514_TEST_Target.cs:1680 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_qty"] | p_mfg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-2ff7d29e | (진입점 미연결) | FP00514_TEST_Target.cs:1681 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_is_prev_schedule"] | p_is_prev_schedule | 행/컬럼 값 대입 |  |  |  |
| AC-1c37d865 | (진입점 미연결) | FP00514_TEST_Target.cs:1682 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_demand_type"] | p_demand_type | 행/컬럼 값 대입 |  |  |  |
| AC-7878bd90 | (진입점 미연결) | FP00514_TEST_Target.cs:1683 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-6f8b7b75 | (진입점 미연결) | FP00514_TEST_Target.cs:1684 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-ea83d4cb | (진입점 미연결) | FP00514_TEST_Target.cs:1685 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_test_target_id"] | p_test_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-8171a2ee | (진입점 미연결) | FP00514_TEST_Target.cs:1686 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-7fb9664a | (진입점 미연결) | FP00514_TEST_Target.cs:1689 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6fa14814 | (진입점 미연결) | FP00514_TEST_Target.cs:1690 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-49fa19e2 | (진입점 미연결) | FP00514_TEST_Target.cs:1696 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-23427db1 | (진입점 미연결) | FP00514_TEST_Target.cs:1702 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.Save_Data_Test

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARGET") ▸ if (programID == "PR_UI_FP00514_TEST_TARGET_SAVE")] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a59f6cc | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:762 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00514_TEST_TARGET") ⇒ FP_Master.PR_UI_FP00514_TEST_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-38674909 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:763 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b04e7d89 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:765 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-28c4b4f4 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:766 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2bcd23db | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:767 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-5cad22d6 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:768 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c64d4b0a | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:769 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-83fb8884 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:770 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d11549be | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:771 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-113e83ba | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:772 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-930c8555 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:773 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_start_date"] | p_mfg_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-4bd54215 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:774 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_end_date"] | p_mfg_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-b3c14e82 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:775 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-bd8113df | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:776 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model"] | p_model | 행/컬럼 값 대입 |  |  |  |
| AC-f695936f | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:777 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-f9660bd3 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:778 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-6bd36381 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:779 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-b01e1f65 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:780 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-afbe13ae | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:781 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-aeb234ca | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:782 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-ec1b6b55 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:783 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-1e21c700 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:784 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_due_date"] | p_due_date | 행/컬럼 값 대입 |  |  |  |
| AC-808999d9 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:785 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-3b07bcbc | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:786 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_qty"] | p_mfg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-68e0dbba | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:787 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_is_prev_schedule"] | p_is_prev_schedule | 행/컬럼 값 대입 |  |  |  |
| AC-3d7bea5d | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:788 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_demand_type"] | p_demand_type | 행/컬럼 값 대입 |  |  |  |
| AC-27ffe26b | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:789 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-965cda3d | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:790 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-72252f69 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:791 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_test_target_id"] | p_test_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-c863f851 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:792 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-746c09f2 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:794 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e67907f | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:795 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-24065288 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:801 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5263a705 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:802 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-5b764304 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TEST_TARG… 외 1 | FP00514_TEST_Target.cs:808 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c389009f | SaveButton | FP00514_TEST_Target.cs:435 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00514_TEST_Target.SetChangeControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a33c8c8e | this.Load [try] 외 3 | FP00514_TEST_Target.cs:1778 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f16414cb | this.Load [try] 외 3 | FP00514_TEST_Target.cs:1778 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-23b30651 | this.Load [try] 외 3 | FP00514_TEST_Target.cs:1783 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter["DIVISION_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-a87ab4dd | this.Load [try] 외 3 | FP00514_TEST_Target.cs:1784 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c5aba551 | this.Load [try] 외 3 | FP00514_TEST_Target.cs:1784 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-16710e6b | this.Load [try] 외 3 | FP00514_TEST_Target.cs:1786 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)cboSite is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-27ac816b | this.Load [try] 외 3 | FP00514_TEST_Target.cs:1788 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)cboSite is UsrCombo) ▸ if ((object)cboSite … | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ed3fcc19 | this.Load [try] 외 3 | FP00514_TEST_Target.cs:1795 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-ee526fd0 | this.Load [try] 외 3 | FP00514_TEST_Target.cs:1796 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-538f6d51 | this.Load [try] 외 3 | FP00514_TEST_Target.cs:1796 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f7004756 | this.Load [try] 외 3 | FP00514_TEST_Target.cs:1798 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6e1f4e09 | this.Load [try] 외 3 | FP00514_TEST_Target.cs:1800 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlant is Usr… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b4d0d1fb | this.Load [try] 외 3 | FP00514_TEST_Target.cs:1806 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00514_TEST_Target.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88c044b7 | this.Load [try] | FP00514_TEST_Target.cs:325 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd43d072 | this.Load [try] | FP00514_TEST_Target.cs:326 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-115137cf | this.Load [try] | FP00514_TEST_Target.cs:331 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-17d9e367 | this.Load [try] | FP00514_TEST_Target.cs:332 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.NICK_NAME)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-91b78879 | this.Load [try] | FP00514_TEST_Target.cs:335 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-11f31da6 | this.Load [try] | FP00514_TEST_Target.cs:336 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DEMAND_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ca427cd1 | this.Load [try] | FP00514_TEST_Target.cs:337 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SCP_PLAN_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-757833ae | this.Load [try] | FP00514_TEST_Target.cs:338 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MESSAGE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-74cbb51f | this.Load [try] | FP00514_TEST_Target.cs:339 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.EDIT_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00514_TEST_Target.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c393eed8 | this.spdMain.CellClick | FP00514_TEST_Target.cs:1099 | if (siMain.GetMaxRowIndex() < 0) | FLAG | iClickRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-609bc9f9 | this.spdMain.CellClick | FP00514_TEST_Target.cs:1101 | else of (siMain.GetMaxRowIndex() < 0) | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00514_TestTargetImportPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01d196f8 | .ctor | FP00514_TestTargetImportPopup.cs:114 |  | FLAG | this.sSheetName | pSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-15673f24 | .ctor | FP00514_TestTargetImportPopup.cs:115 |  | FLAG | this.sProgramId | pProgramId | 화면 필드/플래그 변경 |  |  |  |
| AC-7db14314 | .ctor | FP00514_TestTargetImportPopup.cs:116 |  | FLAG | this.sServiceCallName | pServiceCallName | 화면 필드/플래그 변경 |  |  |  |
| AC-3bd29562 | .ctor | FP00514_TestTargetImportPopup.cs:117 |  | FLAG | this.sParamsFilter | pParamsFilter | 화면 필드/플래그 변경 |  |  |  |
| AC-b28a40aa | .ctor | FP00514_TestTargetImportPopup.cs:118 |  | FLAG | this.sDbParamsList | pDbParamsList | 화면 필드/플래그 변경 |  |  |  |
| AC-3dc31d3f | .ctor | FP00514_TestTargetImportPopup.cs:120 |  | UI_PROP | SpdSheet.shtTestExcel | this.sSheetName | 속성 shtTestExcel 설정 |  |  |  |
| AC-75fa4444 | .ctor | FP00514_TestTargetImportPopup.cs:125 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d72686a2 | .ctor | FP00514_TestTargetImportPopup.cs:126 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-0b4d5f24 | .ctor | FP00514_TestTargetImportPopup.cs:131 | if (string.IsNullOrEmpty(this.sParamsFilter) \|\| string.IsNullOrEmpty(this.sDbParamsList)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ef455482 | .ctor | FP00514_TestTargetImportPopup.cs:132 | if (string.IsNullOrEmpty(this.sParamsFilter) \|\| string.IsNullOrEmpty(this.sDbParamsList)) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-09275c72 | .ctor | FP00514_TestTargetImportPopup.cs:139 |  | FLAG | iDbParmsCount | arrDbList.Length | 화면 필드/플래그 변경 |  |  |  |
| AC-9d5697ce | .ctor | FP00514_TestTargetImportPopup.cs:141 |  | UI_PROP | structParam._sParamFilter | new string[iDbParmsCount] | 속성 _sParamFilter 설정 |  |  |  |
| AC-fd28e5ad | .ctor | FP00514_TestTargetImportPopup.cs:142 |  | UI_PROP | structParam._sDbParamsList | new string[iDbParmsCount] | 속성 _sDbParamsList 설정 |  |  |  |
| AC-2239b83a | .ctor | FP00514_TestTargetImportPopup.cs:146 | for (i < iDbParmsCount) | DATA_OP | structParam._sParamFilter[i] | arrFilter[i] | 행/컬럼 값 대입 |  |  |  |
| AC-03a6abc1 | .ctor | FP00514_TestTargetImportPopup.cs:147 | for (i < iDbParmsCount) | DATA_OP | structParam._sDbParamsList[i] | arrDbList[i] | 행/컬럼 값 대입 |  |  |  |

## FP00514_TestTargetImportPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce1584de | this.btnClose.Click | FP00514_TestTargetImportPopup.cs:1069 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00514_TestTargetImportPopup.btnExport_Click

진입점: this.btnExport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7526b80e | this.btnExport.Click | FP00514_TestTargetImportPopup.cs:934 |  | FOCUS | siTestExcel.SpreadObject.Focus | () | 포커스 이동 |  |  |  |
| AC-0db94800 | this.btnExport.Click | FP00514_TestTargetImportPopup.cs:935 |  | CALL_BASE | OnClickExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00514_TestTargetImportPopup.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d99764cd | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:991 | try | CALL_EXT | siTestExcel.GetSpdTitle | ("FP00514", UserInfoContext.Current.UserId, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-30a521db | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:994 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-7bef1e82 | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:995 | try | UI_PROP | opd.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-12da05ee | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:997 | try | UI_PROP | opd.Filter | "Excel files (*.xls)\|*.xls\|All files (*.*)\|*.*" | 속성 Filter 설정 |  |  |  |
| AC-bb087843 | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:998 | try | UI_PROP | opd.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-804a6a4a | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1000 | try | POPUP | opd.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-359759dc | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1004 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | COMBO_DATA | DataCommon.GetReadExcelFile | (opd.FileName, iColCount) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-635ac718 | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1010 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (spdTestExcel.ActiveSheet.RowCount > 0) | DATA_OP | spdTestExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-67c45147 | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1010 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (spdTestExcel.ActiveSheet.RowCount > 0) | ENDPOINT | spdTestExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e366de81 | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1014 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ else of (spdTestExcel.ActiveSheet.RowCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00087") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cc4350d0 | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1015 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ else of (spdTestExcel.ActiveSheet.RowCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e580600 | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1019 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | DATA_OP | dt.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0828f9cf | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1020 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | DATA_OP | dtExcel.AsEnumerable().CopyToDataTable | (dtData, LoadOption.Upsert) | 데이터 객체 조작/조회 |  |  |  |
| AC-fda80910 | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1022 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | LIST_BIND | spdTestExcel.DataSource | dtData | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-257a68b9 | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1025 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_LOCK | siTestExcel.LockColumn | (0, siTestExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e30e5203 | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1039 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) | DATA_OP | spdTestExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-16c31986 | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1039 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) | ENDPOINT | spdTestExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-25b58fe5 | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1054 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ else of (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f60b7d56 | this.btnImport.Click | FP00514_TestTargetImportPopup.cs:1063 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00035") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00514_TestTargetImportPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-981b4774 | this.btnSave.Click | FP00514_TestTargetImportPopup.cs:956 | if (spdTestExcel.ActiveSheet.RowCount > 0) ▸ for (i <= siTestExcel.GetMaxRowIndex()) ▸ if (sValidYN.Equals("N")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00051", new object[] { "Check Validation Data" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ddea1d6 | this.btnSave.Click | FP00514_TestTargetImportPopup.cs:957 | if (spdTestExcel.ActiveSheet.RowCount > 0) ▸ for (i <= siTestExcel.GetMaxRowIndex()) ▸ if (sValidYN.Equals("N")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5326ba8 | this.btnSave.Click | FP00514_TestTargetImportPopup.cs:961 | if (spdTestExcel.ActiveSheet.RowCount > 0) | DATA_OP | spdTestExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-322d807a | this.btnSave.Click | FP00514_TestTargetImportPopup.cs:961 | if (spdTestExcel.ActiveSheet.RowCount > 0) | ENDPOINT | spdTestExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-064190bc | this.btnSave.Click | FP00514_TestTargetImportPopup.cs:965 | else of (spdTestExcel.ActiveSheet.RowCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00087") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-21b5931e | this.btnSave.Click | FP00514_TestTargetImportPopup.cs:966 | else of (spdTestExcel.ActiveSheet.RowCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1d4b0bc | this.btnSave.Click | FP00514_TestTargetImportPopup.cs:975 | else of (dtExcel != null && dtExcel.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00087") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00514_TestTargetImportPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a0226bb | this.btnSql.Click | FP00514_TestTargetImportPopup.cs:1075 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1bce72da | this.btnSql.Click | FP00514_TestTargetImportPopup.cs:1076 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ce4b42ec | this.btnSql.Click | FP00514_TestTargetImportPopup.cs:1078 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00514_TARGET_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-6dfb0f24 | this.btnSql.Click | FP00514_TestTargetImportPopup.cs:1079 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00514_TARGET_SELECT_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-95d3d608 | this.btnSql.Click | FP00514_TestTargetImportPopup.cs:1080 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00514_TARGET_SAVE_IMPORT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b333fccc | this.btnSql.Click | FP00514_TestTargetImportPopup.cs:1081 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00514_TARGET_SAVE_BUFFER") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc03d9d8 | this.btnSql.Click | FP00514_TestTargetImportPopup.cs:1083 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00514_TestTargetImportPopup.CheckNullSpreadValidation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31a1aea5 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:1212 | try ▸ for (iRow <= siTestExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(actionText.Trim())) | GRID_SET | siTestExcel.ActiveSheet.Cells[iRow, siTestExcel.GetColumnIndex(DefColumns.MESSAGE_ID)].Tex… | actionText + " Not Null" | 그리드 속성/값 설정 |  |  |  |
| AC-4ef7c1de | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:1213 | try ▸ for (iRow <= siTestExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(actionText.Trim())) | GRID_SET | siTestExcel.ActiveSheet.Cells[iRow, siTestExcel.GetColumnIndex(DefColumns.VALID_YN)].Text | "N" | 그리드 속성/값 설정 |  |  |  |
| AC-d0165dff | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:1214 | try ▸ for (iRow <= siTestExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(actionText.Trim())) | GRID_SET | siTestExcel.ActiveSheet.Cells[iRow, 0, iRow, siTestExcel.GetColumnIndex(DefColumns.DESCRIP… | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-9f7071fe | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:1219 | try ▸ for (iRow <= siTestExcel.GetMaxRowIndex()) ▸ else of (!string.IsNullOrEmpty(actionText.Trim())) | GRID_SET | siTestExcel.ActiveSheet.Cells[iRow, siTestExcel.GetColumnIndex(DefColumns.VALID_YN)].Text | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-365e25d3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:1224 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-b21729fc | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:1226 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetImportPopup.CheckValidationByDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6abcc477 | (진입점 미연결) | FP00514_TestTargetImportPopup.cs:1155 | try ▸ if (ds.Tables[0].Rows.Count > 0) | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |
| AC-f6901002 | (진입점 미연결) | FP00514_TestTargetImportPopup.cs:1159 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-448493e3 | (진입점 미연결) | FP00514_TestTargetImportPopup.cs:1164 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetImportPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2826347 | this.Load | FP00514_TestTargetImportPopup.cs:204 |  | GRID_INIT | this.AddSheet | (spdTestExcel, SpdSheet.shtTestExcel, SpdSheet.shtTestExcel, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-15b6958e | this.Load | FP00514_TestTargetImportPopup.cs:205 |  | FLAG | siTestExcel | GetSheetInfo(spdTestExcel.Name, spdTestExcel.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-990c4e38 | this.Load | FP00514_TestTargetImportPopup.cs:207 |  | GRID_INIT | siTestExcel.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00514_TestTargetImportPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00cc64a5 | this.Load | FP00514_TestTargetImportPopup.cs:197 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00514_TestTargetImportPopup.Delete_Data_Buffer

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SELECT") ▸ else of (programID == "PR_UI_FP00514_TARGET_SELECT_VALID") ▸ else of (programID == "PR_UI_FP00514_TARGET_SAVE_IMPORT") ▸ if (programID == "PR_UI_FP00514_TARGET_SAVE_BUFFER")] / this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a743dc51 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:865 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-8ba61c8f | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:869 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b938ca74 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:871 | try | DATA_OP | req.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-ee2506b7 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:872 | try | DATA_OP | req.Parameters["p_sys_flag"] | "DELETE_BUFFER" | 행/컬럼 값 대입 |  |  |  |
| AC-77682c8b | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:873 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8fd2354a | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:874 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bff46f66 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:875 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-983c6c6a | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:876 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9a5a63a9 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:877 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3343c676 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:878 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8f249d94 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:879 | try | DATA_OP | req.Parameters["p_mfg_start_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e605248f | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:880 | try | DATA_OP | req.Parameters["p_mfg_end_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aa25c751 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:881 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3f3e86fd | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:882 | try | DATA_OP | req.Parameters["p_model"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9a533cda | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:883 | try | DATA_OP | req.Parameters["p_nick_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-de6af12f | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:884 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8031bac4 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:885 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9d950b05 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:886 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2a65a44b | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:887 | try | DATA_OP | req.Parameters["p_line_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5aa68074 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:888 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-24761ba1 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:889 | try | DATA_OP | req.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-26981818 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:890 | try | DATA_OP | req.Parameters["p_due_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a6785820 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:891 | try | DATA_OP | req.Parameters["p_mfg_week"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-316c9866 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:892 | try | DATA_OP | req.Parameters["p_mfg_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-76ee2bd7 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:893 | try | DATA_OP | req.Parameters["p_is_prev_schedule"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7fcaf65b | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:894 | try | DATA_OP | req.Parameters["p_demand_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-40bf8573 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:895 | try | DATA_OP | req.Parameters["p_scp_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cf39b3ae | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:896 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d25cf74c | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:897 | try | DATA_OP | req.Parameters["p_test_target_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-edab0018 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:898 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-29ebc5fc | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:900 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5e847b7e | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:915 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-9c06c743 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:918 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-76828c57 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:922 | catch ((Exception ex)) | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetImportPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0515a3c | Dispose | FP00514_TestTargetImportPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00514_TestTargetImportPopup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcb72987 | EditButton | FP00514_TestTargetImportPopup.cs:278 | if (spdTestExcel.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b178976f | EditButton | FP00514_TestTargetImportPopup.cs:279 | if (spdTestExcel.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetImportPopup.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06dddb4b | ExcelButton | FP00514_TestTargetImportPopup.cs:298 |  | EXCEL | ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00514_TestTargetImportPopup.Find_Data

진입점: this.Load / this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ try ▸ if (siTestExcel.SheetName == SpdSheet.shtTestExcel) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnFind.Click / FindButton / SaveButton [try ▸ if (siTestExcel.SheetName == SpdSheet.shtTestExcel) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40558dfa | this.Load 외 4 | FP00514_TestTargetImportPopup.cs:309 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3ea51de1 | this.Load 외 4 | FP00514_TestTargetImportPopup.cs:314 | try | CALL_EXT | spdTestExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ce11770 | this.Load 외 4 | FP00514_TestTargetImportPopup.cs:317 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-da0f819a | this.Load 외 4 | FP00514_TestTargetImportPopup.cs:317 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88a31305 | this.Load 외 4 | FP00514_TestTargetImportPopup.cs:323 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-46efe522 | this.Load 외 4 | FP00514_TestTargetImportPopup.cs:326 | try | GRID_INIT | siTestExcel.ChangeSheet | (SpdSheet.shtTestExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-65111bb9 | this.Load 외 4 | FP00514_TestTargetImportPopup.cs:337 | try | GRID_BIND | siTestExcel.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-71e025a6 | this.Load 외 4 | FP00514_TestTargetImportPopup.cs:343 | try | GRID_LOCK | siTestExcel.LockColumn | (0, siTestExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f4bbaf7a | this.Load 외 4 | FP00514_TestTargetImportPopup.cs:346 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8e4c60e9 | this.Load 외 4 | FP00514_TestTargetImportPopup.cs:349 | try | FLAG | dtSheetData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2adbddc5 | this.Load 외 4 | FP00514_TestTargetImportPopup.cs:352 | try | GRID_INIT | siTestExcel.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cae33e02 | this.Load 외 4 | FP00514_TestTargetImportPopup.cs:363 | try | GRID_STYLE | spdTestExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-e99a7227 | this.Load 외 4 | FP00514_TestTargetImportPopup.cs:368 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00514_TestTargetImportPopup.Find_Data_Import

진입점: this.Load [try] / popSql.OnSql [if (programID == "PR_UI_FP00514_TARGET_SELECT")] / this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ try ▸ if (siTestExcel.SheetName == SpdSheet.shtTestExcel) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnFind.Click [try] / FindButton [try] / SaveButton [try ▸ if (siTestExcel.SheetName == SpdSheet.shtTestExcel) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-191039db | this.Load [try] 외 5 | FP00514_TestTargetImportPopup.cs:381 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-ab913ff5 | this.Load [try] 외 5 | FP00514_TestTargetImportPopup.cs:383 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-2e696f69 | this.Load [try] 외 5 | FP00514_TestTargetImportPopup.cs:384 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_IMPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-5f18f466 | this.Load [try] 외 5 | FP00514_TestTargetImportPopup.cs:385 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-82332b1f | this.Load [try] 외 5 | FP00514_TestTargetImportPopup.cs:386 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f09db417 | this.Load [try] 외 5 | FP00514_TestTargetImportPopup.cs:390 | try ▸ for (i < iDbParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-598035f9 | this.Load [try] 외 5 | FP00514_TestTargetImportPopup.cs:394 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0e1bc448 | this.Load [try] 외 5 | FP00514_TestTargetImportPopup.cs:398 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-ba608138 | this.Load [try] 외 5 | FP00514_TestTargetImportPopup.cs:403 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetImportPopup.Find_Data_Validation

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SELECT") ▸ if (programID == "PR_UI_FP00514_TARGET_SELECT_VALID")] / this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76570a27 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:412 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8f9428d1 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:419 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-aab34f12 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:421 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-fd4cf52f | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:422 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_VALID" | 행/컬럼 값 대입 |  |  |  |
| AC-ba0fa995 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:423 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-79fba3e7 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:424 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c9d9f4a6 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:428 | try ▸ for (i < iDbParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-14f342ca | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:432 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a9624c02 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:437 | try | RETURN | return dsv; |  | 처리 중단/반환 |  |  |  |
| AC-70accacf | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:441 | catch ((Exception ex)) | RETURN | return dsv; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetImportPopup.Find_Save_Validation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0992b533 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:450 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f370aed5 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:455 | try | CALL_EXT | spdTestExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ffb93ad | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:458 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-8a7b360b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:458 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb8685f9 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:464 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-42d50a56 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:467 | try | GRID_INIT | siTestExcel.ChangeSheet | (SpdSheet.shtTestExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7bef0e01 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:481 | try | GRID_BIND | siTestExcel.Query | (dsv) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a1ab42e7 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:487 | try | GRID_LOCK | siTestExcel.LockColumn | (0, siTestExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6efc1f84 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:490 | try | UI_MISC | SetSearchCount | (dsv) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6de1162b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:501 | try | GRID_STYLE | spdTestExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-088e53d1 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:506 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6fe1d717 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:510 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00514_TestTargetImportPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b20df624 | this.Load | FP00514_TestTargetImportPopup.cs:158 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-72ca7e80 | this.Load | FP00514_TestTargetImportPopup.cs:160 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ab996e18 | this.Load | FP00514_TestTargetImportPopup.cs:171 |  | VALUE_SET | this.lblSheetName.Text | "[ " + sSheetName + " ] Excel Import" | 컨트롤 값 설정 |  |  |  |

## FP00514_TestTargetImportPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbcea558 | this.Load | FP00514_TestTargetImportPopup.cs:179 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2d3b084f | this.Load | FP00514_TestTargetImportPopup.cs:182 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtTestExcel) | 데이터 객체 조작/조회 |  |  |  |
| AC-84014f22 | this.Load | FP00514_TestTargetImportPopup.cs:188 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-2136da35 | this.Load | FP00514_TestTargetImportPopup.cs:189 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2200e6cd | this.Load | FP00514_TestTargetImportPopup.cs:190 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00514_TestTargetImportPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35e8aaef | this.Load | FP00514_TestTargetImportPopup.cs:220 | try | GRID_INIT | siTestExcel.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2155fca4 | this.Load | FP00514_TestTargetImportPopup.cs:221 | try | GRID_INIT | siTestExcel.ChangeActiveSheet | (SpdSheet.shtTestExcel) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fa0c21e9 | this.Load | FP00514_TestTargetImportPopup.cs:226 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00514_TestTargetImportPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d31a4679 | popSql.OnSql | FP00514_TestTargetImportPopup.cs:1105 | if (programID == "PR_UI_FP00514_TARGET_SELECT") | RETURN | return Find_Data_Import("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-db6ffcf0 | popSql.OnSql | FP00514_TestTargetImportPopup.cs:1109 | else of (programID == "PR_UI_FP00514_TARGET_SELECT") ▸ if (programID == "PR_UI_FP00514_TARGET_SELECT_VALID") | RETURN | return Find_Data_Validation("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-505c1cd5 | popSql.OnSql | FP00514_TestTargetImportPopup.cs:1113 | else of (programID == "PR_UI_FP00514_TARGET_SELECT") ▸ else of (programID == "PR_UI_FP00514_TARGET_SELECT_VALID") ▸ if (programID == "PR_UI_… | RETURN | return Save_Data_Import("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-124ca131 | popSql.OnSql | FP00514_TestTargetImportPopup.cs:1121 | else of (programID == "PR_UI_FP00514_TARGET_SELECT") ▸ else of (programID == "PR_UI_FP00514_TARGET_SELECT_VALID") ▸ else of (programID == "P… | DATA_OP | spdTestExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-376365cc | popSql.OnSql | FP00514_TestTargetImportPopup.cs:1121 | else of (programID == "PR_UI_FP00514_TARGET_SELECT") ▸ else of (programID == "PR_UI_FP00514_TARGET_SELECT_VALID") ▸ else of (programID == "P… | ENDPOINT | spdTestExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9d46ee0a | popSql.OnSql | FP00514_TestTargetImportPopup.cs:1125 | else of (programID == "PR_UI_FP00514_TARGET_SELECT") ▸ else of (programID == "PR_UI_FP00514_TARGET_SELECT_VALID") ▸ else of (programID == "P… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ba3ec085 | popSql.OnSql | FP00514_TestTargetImportPopup.cs:1129 | else of (programID == "PR_UI_FP00514_TARGET_SELECT") ▸ else of (programID == "PR_UI_FP00514_TARGET_SELECT_VALID") ▸ else of (programID == "P… | RETURN | return Save_Data_Buffer(dtExcel, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-f0a75d12 | popSql.OnSql | FP00514_TestTargetImportPopup.cs:1132 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetImportPopup.Save_Data

진입점: this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Count > 0)] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f41a228 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00514_TestTargetImportPopup.cs:520 | if (siTestExcel == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7037e82 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00514_TestTargetImportPopup.cs:524 | if (siTestExcel.ActiveSheet.RowCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00019") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fe6bf201 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00514_TestTargetImportPopup.cs:525 | if (siTestExcel.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d9078e0f | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00514_TestTargetImportPopup.cs:532 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-02898c5c | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00514_TestTargetImportPopup.cs:533 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e6e12a5 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00514_TestTargetImportPopup.cs:536 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-654853a7 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00514_TestTargetImportPopup.cs:548 | try ▸ if (siTestExcel.SheetName == SpdSheet.shtTestExcel) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9d76d45 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00514_TestTargetImportPopup.cs:557 | try ▸ if (siTestExcel.SheetName == SpdSheet.shtTestExcel) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d8c55970 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00514_TestTargetImportPopup.cs:562 | try ▸ else of (siTestExcel.SheetName == SpdSheet.shtTestExcel) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Check Sheet Data" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eb22f900 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00514_TestTargetImportPopup.cs:565 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cc7d26c5 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00514_TestTargetImportPopup.cs:569 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-58ddaa70 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00514_TestTargetImportPopup.cs:570 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-4f9d625d | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00514_TestTargetImportPopup.cs:574 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00514_TestTargetImportPopup.Save_Data_Buffer

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SELECT") ▸ else of (programID == "PR_UI_FP00514_TARGET_SELECT_VALID") ▸ else of (programID == "PR_UI_FP00514_TARGET_SAVE_IMPORT") ▸ if (programID == "PR_UI_FP00514_TARGET_SAVE_BUFFER")] / this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c431aece | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:728 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-0ee84969 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:802 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-1635c043 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:806 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-edb1b899 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:808 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-75bd5cd5 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:809 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-64b30e8a | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:810 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-bfbb6f3a | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:811 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-bac2737f | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:812 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-9114962f | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:813 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7addb4d0 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:814 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-326c4fa9 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:815 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-c68a8349 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:816 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_start_date"] | p_mfg_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-6a9599a6 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:817 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_end_date"] | p_mfg_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-b9ae1643 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:818 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-9cfe12db | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:819 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model"] | p_model | 행/컬럼 값 대입 |  |  |  |
| AC-49daccce | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:820 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-3ac437b7 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:821 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-b18fa960 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:822 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb2bb442 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:823 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-c546ab77 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:824 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-39a75592 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:825 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-1fddc78c | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:826 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-981ed4b9 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:827 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_due_date"] | p_due_date | 행/컬럼 값 대입 |  |  |  |
| AC-d31e8a7c | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:828 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-08d389f3 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:829 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_qty"] | p_mfg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-aabbee31 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:830 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_is_prev_schedule"] | p_is_prev_schedule | 행/컬럼 값 대입 |  |  |  |
| AC-0592cf12 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:831 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_demand_type"] | p_demand_type | 행/컬럼 값 대입 |  |  |  |
| AC-c2a5350c | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:832 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-c0932e3f | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:833 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-c31d9b8e | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:834 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_test_target_id"] | p_test_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-a73863f8 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:835 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-f7d7b422 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:837 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-421a71a7 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:840 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-3c2dd02d | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:845 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4af9ef27 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:846 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-a8a9e331 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:851 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bf5ebc70 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 1 | FP00514_TestTargetImportPopup.cs:852 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetImportPopup.Save_Data_Import

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SELECT") ▸ else of (programID == "PR_UI_FP00514_TARGET_SELECT_VALID") ▸ if (programID == "PR_UI_FP00514_TARGET_SAVE_IMPORT")] / this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ try ▸ if (siTestExcel.SheetName == SpdSheet.shtTestExcel)] / SaveButton [try ▸ if (siTestExcel.SheetName == SpdSheet.shtTestExcel)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31480a05 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:624 | try ▸ for (i <= siTestExcel.GetMaxRowIndex()) ▸ if (sValidYN.Equals("N") \|\| string.IsNullOrEmpty(sValidYN)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00051", new object[] { sMessage }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2354a932 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:625 | try ▸ for (i <= siTestExcel.GetMaxRowIndex()) ▸ if (sValidYN.Equals("N") \|\| string.IsNullOrEmpty(sValidYN)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-0cff3709 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:669 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-fddd4fba | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:670 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-61c8d123 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:672 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-be2817fb | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:673 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-448d90e0 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:674 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-86292b07 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:675 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-7900658d | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:677 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-72a6942b | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:678 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-477415d4 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:679 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-76589a0b | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:680 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-abdf663c | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:681 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_start_date"] | p_mfg_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-b40ad880 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:682 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_end_date"] | p_mfg_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-9a705f94 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:683 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-39127b6b | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:684 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model"] | p_model | 행/컬럼 값 대입 |  |  |  |
| AC-362a68b4 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:685 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-f1f891ee | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:686 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-406aab7c | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:687 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-96fc324e | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:688 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-b33c15cf | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:689 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-e0acfa98 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:690 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-f6dad025 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:691 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-92235f58 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:692 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_due_date"] | p_due_date | 행/컬럼 값 대입 |  |  |  |
| AC-5c68eac1 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:693 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-b0bffa5d | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:694 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_qty"] | p_mfg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-7e5e6bb4 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:695 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_is_prev_schedule"] | p_is_prev_schedule | 행/컬럼 값 대입 |  |  |  |
| AC-02622b93 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:696 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_demand_type"] | p_demand_type | 행/컬럼 값 대입 |  |  |  |
| AC-5e8c0914 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:697 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-7f6658b4 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:698 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-1ea0b05c | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:699 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_test_target_id"] | p_test_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-63b0b4fe | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:700 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-2ef5c1f9 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:702 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5728da12 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:705 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-f0ca4b1e | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:711 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-79ab850d | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:712 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-08cd5674 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:717 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b65455ef | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_SE… 외 2 | FP00514_TestTargetImportPopup.cs:718 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetImportPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5c98216 | SaveButton | FP00514_TestTargetImportPopup.cs:286 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetImportPopup.SetSheetHeadColor

진입점: this.Load [try] / this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ try ▸ if (siTestExcel.SheetName == SpdSheet.shtTestExcel) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnFind.Click [try] / FindButton [try] / SaveButton [try ▸ if (siTestExcel.SheetName == SpdSheet.shtTestExcel) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8494df7d | this.Load [try] 외 5 | FP00514_TestTargetImportPopup.cs:1266 | try ▸ for (idx < siTestExcel.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*") >= 0) | GRID_SET | siTestExcel.ActiveSheet.ColumnHeader.Cells[0, idx].ForeColor | System.Drawing.Color.FromArgb(0, 113, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-11c9fc0e | this.Load [try] 외 5 | FP00514_TestTargetImportPopup.cs:1274 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00514_TestTargetImportPopup.SetSheetHeaderWidth

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d998d80 | (진입점 미연결) | FP00514_TestTargetImportPopup.cs:1286 | for (idx < siTestExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siTestExcel.ActiveSheet.Columns[idx].Width) == 0) | CALL_EXT | siTestExcel.ActiveSheet.GetPreferredCellSize | (0, idx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-15067f3c | (진입점 미연결) | FP00514_TestTargetImportPopup.cs:1287 | for (idx < siTestExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siTestExcel.ActiveSheet.Columns[idx].Width) == 0) | GRID_SET | siTestExcel.ActiveSheet.Columns[idx].Width | sz.Width | 그리드 속성/값 설정 |  |  |  |

## FP00514_TestTargetImportPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-958c8007 | this.Load [try] | FP00514_TestTargetImportPopup.cs:234 | if (sheetName.Equals(SpdSheet.shtTestExcel)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d38fd157 | this.Load [try] | FP00514_TestTargetImportPopup.cs:235 | if (sheetName.Equals(SpdSheet.shtTestExcel)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-acd108e9 | this.Load [try] | FP00514_TestTargetImportPopup.cs:239 |  | GRID_INIT | siTestExcel.SetSheetHeaderColumn_FP | (siTestExcel, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-b31bb549 | this.Load [try] | FP00514_TestTargetImportPopup.cs:240 |  | GRID_INIT | siTestExcel.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-372c3565 | this.Load [try] | FP00514_TestTargetImportPopup.cs:243 |  | GRID_SET | siTestExcel.ActiveSheet.Columns[siTestExcel.GetColumnIndex(DefColumns.NICK_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-278e46c3 | this.Load [try] | FP00514_TestTargetImportPopup.cs:244 |  | GRID_SET | siTestExcel.ActiveSheet.Columns[siTestExcel.GetColumnIndex(DefColumns.VALID_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3957cbcd | this.Load [try] | FP00514_TestTargetImportPopup.cs:245 |  | GRID_SET | siTestExcel.ActiveSheet.Columns[siTestExcel.GetColumnIndex(DefColumns.IS_PREV_SCHEDULE)].V… | false | 그리드 속성/값 설정 |  |  |  |
| AC-c9a0bda8 | this.Load [try] | FP00514_TestTargetImportPopup.cs:246 |  | GRID_SET | siTestExcel.ActiveSheet.Columns[siTestExcel.GetColumnIndex(DefColumns.DEMAND_TYPE)].Visibl… | false | 그리드 속성/값 설정 |  |  |  |
| AC-8f3a408f | this.Load [try] | FP00514_TestTargetImportPopup.cs:247 |  | GRID_SET | siTestExcel.ActiveSheet.Columns[siTestExcel.GetColumnIndex(DefColumns.SCP_PLAN_ID)].Visibl… | false | 그리드 속성/값 설정 |  |  |  |

## FP00514_TestTargetImportPopup.SetValidationResultSheetColor

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44e0f55b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:1243 | try ▸ for (iRow <= siTestExcel.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(action) \|\| action.Equals("N")) | GRID_SET | siTestExcel.ActiveSheet.Cells[iRow, 0, iRow, siTestExcel.GetColumnIndex(DefColumns.DESCRIP… | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-0ef4b936 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:1248 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-04a571de | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00514_TestTargetImportPopup.cs:1250 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetImportPopup.spdComExce_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c39dee25 | (진입점 미연결) | FP00514_TestTargetImportPopup.cs:1092 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00514_TestTargetMultiPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f8af0c3 | .ctor | FP00514_TestTargetMultiPopup.cs:119 |  | FLAG | this.sSheetName | pSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-53006e86 | .ctor | FP00514_TestTargetMultiPopup.cs:120 |  | FLAG | this.sProgramId | pProgramId | 화면 필드/플래그 변경 |  |  |  |
| AC-a955fc41 | .ctor | FP00514_TestTargetMultiPopup.cs:121 |  | FLAG | this.sServiceCallName | pServiceCallName | 화면 필드/플래그 변경 |  |  |  |
| AC-18d5ba42 | .ctor | FP00514_TestTargetMultiPopup.cs:122 |  | FLAG | this.sParamsFilter | pParamsFilter | 화면 필드/플래그 변경 |  |  |  |
| AC-093e9dcc | .ctor | FP00514_TestTargetMultiPopup.cs:123 |  | FLAG | this.sDbParamsList | pDbParamsList | 화면 필드/플래그 변경 |  |  |  |
| AC-251de05c | .ctor | FP00514_TestTargetMultiPopup.cs:125 |  | UI_PROP | SpdSheet.shtTarget | this.sSheetName | 속성 shtTarget 설정 |  |  |  |
| AC-0896624a | .ctor | FP00514_TestTargetMultiPopup.cs:129 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | MESSAGE | MessageBox.Show | ("The ProgramID/SheetName/ProcedureName[Parameters] is Null!", "FP", MessageBoxButtons.OK,… | 메시지 표시 |  |  |  |
| AC-9114254c | .ctor | FP00514_TestTargetMultiPopup.cs:130 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-786fc35c | .ctor | FP00514_TestTargetMultiPopup.cs:134 | if (string.IsNullOrEmpty(this.sParamsFilter) \|\| string.IsNullOrEmpty(this.sDbParamsList)) | MESSAGE | MessageBox.Show | ("the Filter/DB List[Parameters] is Null!", "FP", MessageBoxButtons.OK, MessageBoxIcon.Err… | 메시지 표시 |  |  |  |
| AC-da9551ea | .ctor | FP00514_TestTargetMultiPopup.cs:135 | if (string.IsNullOrEmpty(this.sParamsFilter) \|\| string.IsNullOrEmpty(this.sDbParamsList)) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-3ef65810 | .ctor | FP00514_TestTargetMultiPopup.cs:142 |  | FLAG | iDbParmsCount | arrDbList.Length | 화면 필드/플래그 변경 |  |  |  |
| AC-3b768044 | .ctor | FP00514_TestTargetMultiPopup.cs:144 |  | UI_PROP | structParam._sParamFilter | new string[iDbParmsCount] | 속성 _sParamFilter 설정 |  |  |  |
| AC-361e82cf | .ctor | FP00514_TestTargetMultiPopup.cs:145 |  | UI_PROP | structParam._sDbParamsList | new string[iDbParmsCount] | 속성 _sDbParamsList 설정 |  |  |  |
| AC-5b5bbc9a | .ctor | FP00514_TestTargetMultiPopup.cs:149 | for (i < iDbParmsCount) | DATA_OP | structParam._sParamFilter[i] | arrFilter[i] | 행/컬럼 값 대입 |  |  |  |
| AC-29564f8a | .ctor | FP00514_TestTargetMultiPopup.cs:150 | for (i < iDbParmsCount) | DATA_OP | structParam._sDbParamsList[i] | arrDbList[i] | 행/컬럼 값 대입 |  |  |  |

## FP00514_TestTargetMultiPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9046a38f | this.btnClose.Click | FP00514_TestTargetMultiPopup.cs:459 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00514_TestTargetMultiPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-392a5090 | this.btnFind.Click | FP00514_TestTargetMultiPopup.cs:444 | if (string.IsNullOrEmpty(txtModel.Text) && string.IsNullOrEmpty(txtItem.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00022", new object[] { args,"" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f21808f1 | this.btnFind.Click | FP00514_TestTargetMultiPopup.cs:445 | if (string.IsNullOrEmpty(txtModel.Text) && string.IsNullOrEmpty(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetMultiPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c312a94 | this.btnSql.Click | FP00514_TestTargetMultiPopup.cs:464 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-20646545 | this.btnSql.Click | FP00514_TestTargetMultiPopup.cs:465 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-28293d64 | this.btnSql.Click | FP00514_TestTargetMultiPopup.cs:467 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00514_TARGET_MULTI_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ad537d1 | this.btnSql.Click | FP00514_TestTargetMultiPopup.cs:468 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00514_TARGET_MULTI_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d8e338bc | this.btnSql.Click | FP00514_TestTargetMultiPopup.cs:469 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00514_TestTargetMultiPopup.CboPlant_SelectedIndexChanged

진입점: cboPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1866cf2 | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:882 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0bb283b | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:886 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a512d44 | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:891 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a4a71f1 | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:894 |  | FLAG | dtBuildingBySitePlant | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-0d17890c | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:894 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-35c3fab6 | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:895 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingBySitePlant, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-24911b63 | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:899 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-25d86575 | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:902 |  | FLAG | dtOperationByBuilding | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-54b39c85 | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:902 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2e62d08f | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:904 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByBuilding, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4fe4f518 | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:908 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3ee5a6c | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:911 |  | FLAG | dtLineByOperation | Data_FP.Common_FP(Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-eb20ca3c | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:911 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3f838923 | cboPlant.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:913 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperation, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00514_TestTargetMultiPopup.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be296de8 | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:830 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-3220ef61 | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:835 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-69af5737 | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:837 |  | FLAG | dtPlantByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-83b9d1e2 | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:837 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ce498f0d | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:838 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, cboPlant, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-48e0390b | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:842 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f64dcf4 | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:844 |  | FLAG | dtBuildingBySitePlant | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-27915fa3 | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:844 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2919160d | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:845 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingBySitePlant, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-88d530cb | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:849 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-9275dbd9 | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:851 |  | FLAG | dtOperationByBuilding | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-8e0e1e9f | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:851 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cdd4c1c7 | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:853 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByBuilding, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-02bc0fe5 | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:857 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a6fcb7f | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:859 |  | FLAG | dtLineByOperation | Data_FP.Common_FP(Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-3f415c4c | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:859 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e2bcbc76 | cboSite.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:861 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperation, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00514_TestTargetMultiPopup.ClbFactory_SelectedIndexChanged

진입점: clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb5aac3a | clbFactory.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:934 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6fbac87 | clbFactory.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:938 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad793ee1 | clbFactory.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:943 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-febc0d75 | clbFactory.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:948 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd07cf58 | clbFactory.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:952 |  | FLAG | dtOperationByBuilding | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-42198cad | clbFactory.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:952 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-838942fd | clbFactory.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:954 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByBuilding, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0793b61e | clbFactory.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:958 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a561123 | clbFactory.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:961 |  | FLAG | dtLineByOperation | Data_FP.Common_FP(Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-aab500bc | clbFactory.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:961 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3619779e | clbFactory.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:963 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperation, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00514_TestTargetMultiPopup.ClbOperation_SelectedIndexChanged

진입점: clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59972343 | clbOperation.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:983 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ed31852 | clbOperation.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:987 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0b90ced | clbOperation.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:992 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-68245c9f | clbOperation.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:997 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d61a183 | clbOperation.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:1002 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a846ad6 | clbOperation.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:1007 |  | FLAG | dtLineByOperation | Data_FP.Common_FP(Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-8046d619 | clbOperation.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:1007 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-25980b58 | clbOperation.SelectedIndexChanged | FP00514_TestTargetMultiPopup.cs:1009 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperation, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00514_TestTargetMultiPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f2069ce | this.Load | FP00514_TestTargetMultiPopup.cs:333 |  | GRID_INIT | this.AddSheet | (spdTarget, SpdSheet.shtTarget, SpdSheet.shtTarget, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-48851ccc | this.Load | FP00514_TestTargetMultiPopup.cs:334 |  | FLAG | siTarget | GetSheetInfo(spdTarget.Name, spdTarget.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-be6bfb37 | this.Load | FP00514_TestTargetMultiPopup.cs:335 |  | GRID_INIT | siTarget.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00514_TestTargetMultiPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26864f45 | this.Load | FP00514_TestTargetMultiPopup.cs:233 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00514_TestTargetMultiPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be4d27a6 | Dispose | FP00514_TestTargetMultiPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00514_TestTargetMultiPopup.EditButton

진입점: this.Load [try] / this.btnSave.Click [try ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnFind.Click [try] / FindButton [try] / EditButton / SaveButton [try ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70f0f33f | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:406 | if (spdTarget != null) | FLAG | siTarget | GetSheetInfo(spdTarget.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d5768aae | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:408 | if (spdTarget != null) | GRID_LOCK | siTarget.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-32ffe1a9 | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:410 | if (spdTarget != null) | GRID_LOCK | siTarget.LockColumn | (siTarget.GetColumnIndex(DefColumns.COMPANY_ID), siTarget.GetColumnIndex(DefColumns.MARKET… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c3e5adcd | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:411 | if (spdTarget != null) | GRID_LOCK | siTarget.LockColumn | (siTarget.GetColumnIndex(DefColumns.IS_PREV_SCHEDULE), siTarget.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |

## FP00514_TestTargetMultiPopup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01e335bb | ExcelButton | FP00514_TestTargetMultiPopup.cs:432 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00514_TestTargetMultiPopup.Find_Data

진입점: this.Load / this.btnSave.Click [try ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnFind.Click / FindButton / SaveButton [try ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7b5820b | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:480 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-eaa22e9f | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:485 | try | CALL_EXT | spdTarget.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-35537808 | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:488 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-460b1a12 | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:488 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87344eb0 | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:495 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-667f223e | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:498 | try | GRID_INIT | siTarget.ChangeSheet | (SpdSheet.shtTarget) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b565862 | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:509 | try | GRID_BIND | siTarget.Query | (dsData) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-feec821e | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:513 | try ▸ if (dsData.Tables[0].Rows.Count > 0) | GRID_LOCK | siTarget.LockColumn | (0, siTarget.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b2319580 | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:518 | try | UI_MISC | SetSearchCount | (dsData) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-42f7ef6c | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:521 | try | FLAG | dtSheetData | dsData.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-b3a7c9b8 | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:524 | try | GRID_INIT | siTarget.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0dbf07d8 | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:532 | try | GRID_STYLE | spdTarget.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-8cccd721 | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:539 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0032ac45 | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:540 | finally | GRID_SET | this.spdTarget.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-dc280b0b | this.Load 외 4 | FP00514_TestTargetMultiPopup.cs:540 | finally | CALL_EXT | this.spdTarget.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP00514_TestTargetMultiPopup.Find_Data_Multi

진입점: this.Load [try] / popSql.OnSql [if (programID == "PR_UI_FP00514_TARGET_MULTI_SELECT")] / this.btnSave.Click [try ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnFind.Click [try] / FindButton [try] / SaveButton [try ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18d4b22b | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:555 |  | DATA_OP | structParam._sParamFilter[1] | CString.GetCheckedListValue(dtMyDivision, cboDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-05b2b45e | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:556 |  | DATA_OP | structParam._sParamFilter[2] | CString.GetCheckedListValue(dtSiteByDivision, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-022d98bd | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:557 |  | DATA_OP | structParam._sParamFilter[3] | CString.GetCheckedListValue(dtPlantByDivision, cboPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-dca3ca94 | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:558 |  | DATA_OP | structParam._sParamFilter[6] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-a82506eb | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:559 |  | DATA_OP | structParam._sParamFilter[7] | txtModel.Text | 행/컬럼 값 대입 |  |  |  |
| AC-388d23d8 | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:560 |  | DATA_OP | structParam._sParamFilter[9] | CString.GetCheckedListValue(dtBuildingBySitePlant, clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-8239fc33 | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:561 |  | DATA_OP | structParam._sParamFilter[10] | CString.GetCheckedListValue(dtOperationByBuilding, clbOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-60f7e3ec | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:562 |  | DATA_OP | structParam._sParamFilter[11] | CString.GetCheckedListValue(dtLineByOperation, clbLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-6a25e792 | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:565 | if (structParam._sParamFilter[13].ToString().Equals("E")) | DATA_OP | structParam._sParamFilter[13] | "E" | 행/컬럼 값 대입 |  |  |  |
| AC-e69db6d1 | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:567 | else of (structParam._sParamFilter[13].ToString().Equals("E")) | DATA_OP | structParam._sParamFilter[13] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-328c7eef | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:569 |  | DATA_OP | structParam._sParamFilter[15] | (dtpDueDate.Text).Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-b362114b | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:574 |  | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-eca8c068 | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:576 |  | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-fdbffe6f | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:577 |  | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MULTI" | 행/컬럼 값 대입 |  |  |  |
| AC-d6949dd4 | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:578 |  | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6ff6af85 | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:579 |  | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a9e7ef87 | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:583 | for (i < iDbParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-fbd6c74e | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:587 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d7b7fcfd | this.Load [try] 외 5 | FP00514_TestTargetMultiPopup.cs:589 |  | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetMultiPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8ae291b | FindButton | FP00514_TestTargetMultiPopup.cs:395 |  | DATA_OP | structParam._sParamFilter[2] | sData | 행/컬럼 값 대입 |  |  |  |
| AC-d3bea778 | FindButton | FP00514_TestTargetMultiPopup.cs:396 |  | DATA_OP | structParam._sParamFilter[6] | txtModel.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bf0994b3 | FindButton | FP00514_TestTargetMultiPopup.cs:397 |  | DATA_OP | structParam._sParamFilter[7] | txtItem.Text.ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00514_TestTargetMultiPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea0e5d03 | this.Load | FP00514_TestTargetMultiPopup.cs:161 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7e5db3eb | this.Load | FP00514_TestTargetMultiPopup.cs:163 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00514_TestTargetMultiPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74a699aa | this.Load | FP00514_TestTargetMultiPopup.cs:181 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4acdbcc8 | this.Load | FP00514_TestTargetMultiPopup.cs:183 |  | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-fac5666c | this.Load | FP00514_TestTargetMultiPopup.cs:183 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-90734120 | this.Load | FP00514_TestTargetMultiPopup.cs:186 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-67a20c83 | this.Load | FP00514_TestTargetMultiPopup.cs:189 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-90431ff3 | this.Load | FP00514_TestTargetMultiPopup.cs:192 |  | FLAG | dtProductionType | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00514_find_ProdType") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-10e8ec83 | this.Load | FP00514_TestTargetMultiPopup.cs:192 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00514_find_ProdType") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b252a5c1 | this.Load | FP00514_TestTargetMultiPopup.cs:201 | if (!string.IsNullOrEmpty(structParam._sParamFilter[1].ToString())) | VALUE_SET | cboDivision.SelectedValue | structParam._sParamFilter[1] | 컨트롤 값 설정 |  |  |  |
| AC-826f8377 | this.Load | FP00514_TestTargetMultiPopup.cs:203 | if (!string.IsNullOrEmpty(structParam._sParamFilter[2].ToString())) | VALUE_SET | cboSite.SelectedValue | structParam._sParamFilter[2] | 컨트롤 값 설정 |  |  |  |
| AC-235d35e9 | this.Load | FP00514_TestTargetMultiPopup.cs:205 | if (!string.IsNullOrEmpty(structParam._sParamFilter[3].ToString())) | VALUE_SET | cboPlant.SelectedValue | structParam._sParamFilter[3] | 컨트롤 값 설정 |  |  |  |
| AC-21fcff7f | this.Load | FP00514_TestTargetMultiPopup.cs:209 | if (structParam._sParamFilter[13].ToString().Equals("E")) | VALUE_SET | rdoE.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-66ba6912 | this.Load | FP00514_TestTargetMultiPopup.cs:211 | else of (structParam._sParamFilter[13].ToString().Equals("E")) | VALUE_SET | rdoD.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-7992fe91 | this.Load | FP00514_TestTargetMultiPopup.cs:214 |  | VALUE_SET | dtpDueDate.Value | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-01285810 | this.Load | FP00514_TestTargetMultiPopup.cs:223 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-df25038b | this.Load | FP00514_TestTargetMultiPopup.cs:224 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-adb04a47 | this.Load | FP00514_TestTargetMultiPopup.cs:225 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00514_TestTargetMultiPopup.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84c60336 | this.Load | FP00514_TestTargetMultiPopup.cs:304 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-fffb8e10 | this.Load | FP00514_TestTargetMultiPopup.cs:305 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-b1da170f | this.Load | FP00514_TestTargetMultiPopup.cs:306 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00514_TestTargetMultiPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-831370b3 | this.Load | FP00514_TestTargetMultiPopup.cs:348 | try | GRID_INIT | siTarget.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-903ab26e | this.Load | FP00514_TestTargetMultiPopup.cs:349 | try | GRID_INIT | siTarget.ChangeActiveSheet | (SpdSheet.shtTarget) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00514_TestTargetMultiPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd97f55b | popSql.OnSql | FP00514_TestTargetMultiPopup.cs:1174 | if (programID == "PR_UI_FP00514_TARGET_MULTI_SELECT") | RETURN | return Find_Data_Multi("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-e37a973c | popSql.OnSql | FP00514_TestTargetMultiPopup.cs:1178 | else of (programID == "PR_UI_FP00514_TARGET_MULTI_SELECT") ▸ if (programID == "PR_UI_FP00514_TARGET_MULTI_SAVE") | RETURN | return Save_Data_Multi("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-308de9b4 | popSql.OnSql | FP00514_TestTargetMultiPopup.cs:1180 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetMultiPopup.Save_Data

진입점: this.btnSave.Click / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbf795cb | this.btnSave.Click 외 1 | FP00514_TestTargetMultiPopup.cs:599 | if (siTarget == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d60ee83 | this.btnSave.Click 외 1 | FP00514_TestTargetMultiPopup.cs:601 | if (siTarget.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8fac9e11 | this.btnSave.Click 외 1 | FP00514_TestTargetMultiPopup.cs:606 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d62503b | this.btnSave.Click 외 1 | FP00514_TestTargetMultiPopup.cs:607 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d29c9e5 | this.btnSave.Click 외 1 | FP00514_TestTargetMultiPopup.cs:610 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1764d303 | this.btnSave.Click 외 1 | FP00514_TestTargetMultiPopup.cs:620 | try ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsResult.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4c2e7864 | this.btnSave.Click 외 1 | FP00514_TestTargetMultiPopup.cs:630 | try ▸ else of (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cf291398 | this.btnSave.Click 외 1 | FP00514_TestTargetMultiPopup.cs:635 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |

## FP00514_TestTargetMultiPopup.Save_Data_Multi

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MULTI_SELECT") ▸ if (programID == "PR_UI_FP00514_TARGET_MULTI_SAVE")] / this.btnSave.Click [try] / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93a95e36 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:693 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ for (i <= siTarget.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siTarget.GetValue(i, s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-100a9118 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:694 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ for (i <= siTarget.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siTarget.GetValue(i, s… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-374d155f | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:702 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ for (i <= siTarget.GetMaxRowIndex()) ▸ if ((int)Convert.ToDouble(sQty) <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7053bdee | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:703 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ for (i <= siTarget.GetMaxRowIndex()) ▸ if ((int)Convert.ToDouble(sQty) <= 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-10aa0bc1 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:741 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-8c0f9faa | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:745 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-92e8b773 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:747 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-f68a2d2d | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:748 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-cf0169e8 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:749 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-389bcc11 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:750 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4bb44f1d | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:751 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-38996170 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:752 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fd634df7 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:753 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-f1b80a04 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:754 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-cb7bb058 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:756 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_start_date"] | p_mfg_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-ef9f3d50 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:757 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_end_date"] | p_mfg_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-bfe5aee0 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:758 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-2ee58761 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:759 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model"] | p_model | 행/컬럼 값 대입 |  |  |  |
| AC-62d13254 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:760 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-0b553f03 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:761 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-d6eec21a | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:762 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-c17cbc90 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:763 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-4aa50881 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:764 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-7a8bc58d | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:765 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-bbeec691 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:766 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-8f342cd3 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:767 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_due_date"] | p_due_date | 행/컬럼 값 대입 |  |  |  |
| AC-a12a4efc | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:768 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-d73a86dd | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:769 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_qty"] | p_mfg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-c7a48f6a | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:770 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_is_prev_schedule"] | p_is_prev_schedule | 행/컬럼 값 대입 |  |  |  |
| AC-b5cac200 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:771 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_demand_type"] | p_demand_type | 행/컬럼 값 대입 |  |  |  |
| AC-70a40ce2 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:772 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-e19e1f8d | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:773 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-fab9fe04 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:774 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_test_target_id"] | p_test_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-929edb8c | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:775 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-855fccb4 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:777 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-77cd94ff | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:785 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Check Sheet Data" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b1c210b4 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:786 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-fc9f9731 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:790 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fc41b0c9 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:791 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-0941a8ae | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:795 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9fa30c05 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:796 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-7e7f21c2 | popSql.OnSql [else of (programID == "PR_UI_FP00514_TARGET_MU… 외 2 | FP00514_TestTargetMultiPopup.cs:800 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00514_TestTargetMultiPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22b746fa | SaveButton | FP00514_TestTargetMultiPopup.cs:426 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00514_TestTargetMultiPopup.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fa1b185 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:256 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-340492f8 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:258 | try | FLAG | dtSiteByDivision | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", ""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-980902d6 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:258 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", "", "", "", pDivisi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3489d7fa | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:259 | try | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, cboSite, false, "CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7cbc2036 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:264 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-5505a495 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:266 | try | FLAG | dtPlantByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-5502921f | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:266 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-700b1176 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:267 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, cboPlant, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-575b0519 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:271 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-141affd2 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:273 | try | FLAG | dtBuildingBySitePlant | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-0990eccd | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:273 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-54948111 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:274 | try | LIST_REBIND | clsCtrl.setListBox | (dtBuildingBySitePlant, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4c831cf3 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:278 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-8cab07c1 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:280 | try | FLAG | dtOperationByBuilding | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-fe6d9ade | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:280 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6981c625 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:282 | try | LIST_REBIND | clsCtrl.setListBox | (dtOperationByBuilding, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5a96893c | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:286 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-435bba40 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:288 | try | FLAG | dtLineByOperation | Data_FP.Common_FP(Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-69890c2d | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:288 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a7abbd15 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:290 | try | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperation, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-51a8e553 | this.Load 외 1 | FP00514_TestTargetMultiPopup.cs:296 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00514_TestTargetMultiPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-328f8ffe | this.Load [try] | FP00514_TestTargetMultiPopup.cs:361 | if (sheetName.Equals(SpdSheet.shtTarget)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4af8a76 | this.Load [try] | FP00514_TestTargetMultiPopup.cs:362 | if (sheetName.Equals(SpdSheet.shtTarget)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-5f74d452 | this.Load [try] | FP00514_TestTargetMultiPopup.cs:366 |  | GRID_INIT | siTarget.SetSheetHeaderColumn_FP | (siTarget, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-79642304 | this.Load [try] | FP00514_TestTargetMultiPopup.cs:367 |  | GRID_INIT | siTarget.Freeze | (0, 7) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b8ced59b | this.Load [try] | FP00514_TestTargetMultiPopup.cs:369 |  | GRID_SET | siTarget.ActiveSheet.Columns[siTarget.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f8823250 | this.Load [try] | FP00514_TestTargetMultiPopup.cs:370 |  | GRID_SET | siTarget.ActiveSheet.Columns[siTarget.GetColumnIndex(DefColumns.IS_PREV_SCHEDULE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e9740d26 | this.Load [try] | FP00514_TestTargetMultiPopup.cs:371 |  | GRID_SET | siTarget.ActiveSheet.Columns[siTarget.GetColumnIndex(DefColumns.DEMAND_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4e7f7fe8 | this.Load [try] | FP00514_TestTargetMultiPopup.cs:372 |  | GRID_SET | siTarget.ActiveSheet.Columns[siTarget.GetColumnIndex(DefColumns.SCP_PLAN_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b8d351e5 | this.Load [try] | FP00514_TestTargetMultiPopup.cs:380 |  | GRID_SET | siTarget.ActiveSheet.ColumnHeader.Cells[0, siTarget.GetColumnIndex(DefColumns.CHK)].CellTy… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-418103c0 | this.Load [try] | FP00514_TestTargetMultiPopup.cs:381 |  | GRID_SET | siTarget.ActiveSheet.ColumnHeader.Cells[0, siTarget.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-d595ce00 | this.Load [try] | FP00514_TestTargetMultiPopup.cs:382 |  | GRID_SET | siTarget.ActiveSheet.ColumnHeader.Cells[0, siTarget.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## FP00514_TestTargetMultiPopup.spdTarget_CellClick

진입점: this.spdTarget.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17cfe34c | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1029 | if (siTarget.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (siTarget.ActiveSheet.ColumnH… | GRID_SET | siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-39c766d0 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1034 | if (siTarget.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (siTarget.ActiveSheet.ColumnH… | GRID_SET | siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-27ad33ad | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1041 | if (siTarget.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (siTarget.ActiveSheet.ColumnH… | GRID_SET | siTarget.ActiveSheet.SetValue | (iRow, e.Column, bChk) | 그리드 값 설정 |  |  |  |
| AC-b42d7967 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1068 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | dtProductionType.Select("DIVISION_ID = '" + sDivision + "'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f4c2b9ce | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1068 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | dtProductionType.Select | ("DIVISION_ID = '" + sDivision + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-fa6f7ab2 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1070 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | table1.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9532a68a | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1072 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | table1.Select("CODE <> '" + sValue + "' OR CODE = '4M-VALID'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a0b61f60 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1072 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | table1.Select | ("CODE <> '" + sValue + "' OR CODE = '4M-VALID'") | 데이터 객체 조작/조회 |  |  |  |
| AC-90e67e38 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1073 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | CALL_EXT | HardCodeService.MatchCodeFp | ("FP00514_TestTargetMultiPopup", "4MVALIDEXCEPT", sSite) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39ac4d77 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1074 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | table1.Select("CODE = '" + sValue + "' OR CODE = '4M-VALID'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-590e2b5e | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1074 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | table1.Select | ("CODE = '" + sValue + "' OR CODE = '4M-VALID'") | 데이터 객체 조작/조회 |  |  |  |
| AC-45bcca93 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1076 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | table1.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5811c1da | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1081 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | dtPDS_In["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-eed0355e | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1082 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | dtPDS_In["FACTORY_ID"] | siTarget.GetValue(e.Row, siTarget.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0794ffb1 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1083 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | dtPDS_In["OPERATION_ID"] | siTarget.GetValue(e.Row, siTarget.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3d558e10 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1084 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | dtPDS_In["LINE_ID"] | siTarget.GetValue(e.Row, siTarget.GetColumnIndex(DefColumns.LINE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1b521350 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1085 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00514_TEST_Target", "find_pdsType_filtering", dtPDS_In.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_pdsType_filtering] \| FP\M… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7aae6fe2 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1096 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | dtPDS_Out.getColumn | (i, "PROD_TYPE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e8ea3853 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1101 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | table2.Select(strExpr).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-11360ab4 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1101 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | table2.Select | (strExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-075deb81 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1105 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | STATE_RESET | table2.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-887f8cc3 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1110 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f03cf7a | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1111 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-536652be | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1115 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5823f7d4 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1120 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b29bcb3b | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1124 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | DATA_OP | dtResult.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c3c1d272 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1125 | if (siTarget.ActiveSheet.RowCount >= 1 && siTarget != null && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (e.Column == siTarget.GetCo… | GRID_COMBO | siTarget.SetCellTypeCombo | (e.Row, siTarget.GetColumnIndex(DefColumns.PRODUCTION_TYPE), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8871f515 | this.spdTarget.CellClick | FP00514_TestTargetMultiPopup.cs:1161 |  | FLAG | iClick_Row | 0 | 화면 필드/플래그 변경 |  |  |  |


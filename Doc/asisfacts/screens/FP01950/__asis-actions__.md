# AS-IS 액션 대조표 — FP01950

> 원천: `Doc/asisfacts/screens/FP01950/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 247행 · 메서드 31 · 종류 DATA_OP 63 · RETURN 28 · FLAG 24 · GRID_SET 23 · GRID_LOCK 16 · MESSAGE 13 · ENDPOINT 12 · UI_PROP 12 · POPUP 10 · UI_MISC 10 · CALL_EXT 7 · GRID_INIT 6 · GRID_COMBO 6 · THROW 5 · STATE 4 · VALIDATE 2 · EXCEL 1 · CALL_BASE 1 · GRID_BIND 1 · COMBO_DATA 1 · LIST_REBIND 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 8


## FP01950_Manual_Create_WO..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-339363a7 | .ctor | FP01950_Manual_Create_WO.cs:114 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP01950_Manual_Create_WO.btnCreateOrder_Click

진입점: this.btnCreateOrder.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe45c46e | this.btnCreateOrder.Click | FP01950_Manual_Create_WO.cs:1266 |  | DATA_OP | dtSave.Columns.Add | ("GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-86bbc546 | this.btnCreateOrder.Click | FP01950_Manual_Create_WO.cs:1268 |  | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d0523599 | this.btnCreateOrder.Click | FP01950_Manual_Create_WO.cs:1269 |  | DATA_OP | dtSave.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-335eba86 | this.btnCreateOrder.Click | FP01950_Manual_Create_WO.cs:1270 |  | GRID_SET | dtSave.Rows[0][0] | "999_0019" | 그리드 속성/값 설정 |  |  |  |
| AC-0f4ebcd8 | this.btnCreateOrder.Click | FP01950_Manual_Create_WO.cs:1272 |  | DATA_OP | dsSave.Tables.Add | (dtSave) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c22e434 | this.btnCreateOrder.Click | FP01950_Manual_Create_WO.cs:1274 |  | ENDPOINT | DataService.FP_UpdateBatch | ("FP01950_Manual_Create_WO", "update_Createorder", dsSave, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_Createorder] \| FP\ADMIN\… | 엔드포인트 호출 |  |  |  |
| AC-c2cc931b | this.btnCreateOrder.Click | FP01950_Manual_Create_WO.cs:1280 | if (ret != null && ret.DataSet == null) ▸ if (ret.Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ret.Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ea413ef | this.btnCreateOrder.Click | FP01950_Manual_Create_WO.cs:1288 | if (ret != null && ret.DataSet == null) ▸ else of (ret.Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01950_Manual_Create_WO.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dcc5d05d | this.btnSql.Click | FP01950_Manual_Create_WO.cs:702 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ad53c0c8 | this.btnSql.Click | FP01950_Manual_Create_WO.cs:703 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0dfe8c33 | this.btnSql.Click | FP01950_Manual_Create_WO.cs:705 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP01950_Manual_Create_WO") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf0fc9da | this.btnSql.Click | FP01950_Manual_Create_WO.cs:706 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01950_Manual_Create_WO.ClbOperation_SelectedIndexChanged

진입점: cboOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1f0801b | cboOperation.SelectedIndexChanged | FP01950_Manual_Create_WO.cs:227 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP01950_Manual_Create_WO.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4a14239 | this.Load | FP01950_Manual_Create_WO.cs:233 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, iColumnHeaderCount, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2acb0ce6 | this.Load | FP01950_Manual_Create_WO.cs:234 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6dd438b | this.Load | FP01950_Manual_Create_WO.cs:235 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aee564dd | this.Load | FP01950_Manual_Create_WO.cs:241 | if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "####-##-## ##:##:##", "", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef6bd9c8 | this.Load | FP01950_Manual_Create_WO.cs:244 | if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "####-##-## ##:##:##", "", false) | ⚠ 의미 확인 필요 |  |  |  |

## FP01950_Manual_Create_WO.CreateTrayTypeTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75e762ee | (진입점 미연결) | FP01950_Manual_Create_WO.cs:210 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4920d8a7 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:211 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d92dff5 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:213 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e126480 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:213 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f91d1b8 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:214 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6c0f8670 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:214 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-5502bcea | (진입점 미연결) | FP01950_Manual_Create_WO.cs:215 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-008e04e3 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:215 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-2bfe2d9b | (진입점 미연결) | FP01950_Manual_Create_WO.cs:216 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b872ecce | (진입점 미연결) | FP01950_Manual_Create_WO.cs:216 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-272146be | (진입점 미연결) | FP01950_Manual_Create_WO.cs:218 |  | GRID_SET | dt.Rows[0]["CODE"] | "D" | 그리드 속성/값 설정 |  |  |  |
| AC-ad006091 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:218 |  | GRID_SET | dt.Rows[0]["NAME"] | "Before Degas" | 그리드 속성/값 설정 |  |  |  |
| AC-69a85958 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:219 |  | GRID_SET | dt.Rows[1]["CODE"] | "E" | 그리드 속성/값 설정 |  |  |  |
| AC-eea4b2c4 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:219 |  | GRID_SET | dt.Rows[1]["NAME"] | "After Degas" | 그리드 속성/값 설정 |  |  |  |
| AC-df68e7fa | (진입점 미연결) | FP01950_Manual_Create_WO.cs:220 |  | GRID_SET | dt.Rows[2]["CODE"] | "A" | 그리드 속성/값 설정 |  |  |  |
| AC-19d09858 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:220 |  | GRID_SET | dt.Rows[2]["NAME"] | "Common" | 그리드 속성/값 설정 |  |  |  |
| AC-5551156c | (진입점 미연결) | FP01950_Manual_Create_WO.cs:221 |  | GRID_SET | dt.Rows[3]["CODE"] | "-" | 그리드 속성/값 설정 |  |  |  |
| AC-044f0a28 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:221 |  | GRID_SET | dt.Rows[3]["NAME"] | "Not defined" | 그리드 속성/값 설정 |  |  |  |
| AC-b6f48dc4 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:222 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP01950_Manual_Create_WO.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02fb3ffe | this.Load | FP01950_Manual_Create_WO.cs:142 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5003cdfc | this.Load | FP01950_Manual_Create_WO.cs:143 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-730ad7f7 | this.Load | FP01950_Manual_Create_WO.cs:144 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9445af6b | this.Load | FP01950_Manual_Create_WO.cs:148 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8967b68f | this.Load | FP01950_Manual_Create_WO.cs:149 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-9ce1f0ed | this.Load | FP01950_Manual_Create_WO.cs:150 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a4778a2f | this.Load | FP01950_Manual_Create_WO.cs:154 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-60b9bf9c | this.Load | FP01950_Manual_Create_WO.cs:156 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-c213a537 | this.Load | FP01950_Manual_Create_WO.cs:157 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-320060d9 | this.Load | FP01950_Manual_Create_WO.cs:158 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP01950_Manual_Create_WO.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2b05c51 | Dispose | FP01950_Manual_Create_WO.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01950_Manual_Create_WO.Excel_CheckRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0705882d | (진입점 미연결) | FP01950_Manual_Create_WO.cs:1032 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01950_Manual_Create_WO.Excel_CheckValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21dd0a9e | (진입점 미연결) | FP01950_Manual_Create_WO.cs:1002 | try | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-63d894d9 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:1003 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7d0f8d39 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:1004 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP00414_FormationTrayModel", "delete_Excel_buffer", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-5c8a0d36 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:1008 | try | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00414_FormationTrayModel", "insert_Excel_buffer", data, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\MASTE… | 엔드포인트 호출 |  |  |  |
| AC-5273d5f7 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:1011 | try | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-4b204e83 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:1012 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-92b294e4 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:1013 | try | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP00414_FormationTrayModel", "find_Excel_buffer_validation", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-499b2a19 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:1017 | try | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-cf914bc3 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:1018 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-a11c7dab | (진입점 미연결) | FP01950_Manual_Create_WO.cs:1022 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-a9adfe60 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:1026 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP01950_Manual_Create_WO.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffaf18c4 | ExcelButton | FP01950_Manual_Create_WO.cs:695 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP01950_Manual_Create_WO.Excel_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f22ddfc1 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:973 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-149ec24a | (진입점 미연결) | FP01950_Manual_Create_WO.cs:974 | try | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00414_FormationTrayModel", "merge_FP00411_import", data, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00411_import] \| FP\MAST… | 엔드포인트 호출 |  |  |  |
| AC-6201c7be | (진입점 미연결) | FP01950_Manual_Create_WO.cs:980 | try ▸ if (ret.DataSet != null) | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-366d7088 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:981 | try | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-347d4643 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:983 | try | DATA_OP | tmpDs.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ade48d9 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:984 | try | RETURN | return tmpDs; |  | 처리 중단/반환 |  |  |  |
| AC-65c150cc | (진입점 미연결) | FP01950_Manual_Create_WO.cs:988 | catch ((Exception ee)) | THROW | throw ee; |  | 예외 발생 |  |  |  |
| AC-db21698c | (진입점 미연결) | FP01950_Manual_Create_WO.cs:992 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP01950_Manual_Create_WO.Excel_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-173612b5 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:946 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4626a8df | (진입점 미연결) | FP01950_Manual_Create_WO.cs:950 | try ▸ if (set.Good()) | CALL_EXT | set.Tables[0].SetColumnsOrder | ( "DIVISION_ID", "SITE_ID", "PLANT_ID", "FACTORY_ID", "LINE_ID", "ITEM_ID", "NICK_NAME", "… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c751556 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:956 | try | RETURN | return set; |  | 처리 중단/반환 |  |  |  |
| AC-dc947057 | (진입점 미연결) | FP01950_Manual_Create_WO.cs:960 | catch ((Exception ae)) | THROW | throw ae; |  | 예외 발생 |  |  |  |
| AC-1310c40b | (진입점 미연결) | FP01950_Manual_Create_WO.cs:964 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP01950_Manual_Create_WO.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP01950_Manual_Create_WO")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa3b9000 | popSql.OnSql [if (programID == "PR_UI_FP01950_Manual_Create_… 외 3 | FP01950_Manual_Create_WO.cs:909 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { Filter["WO_BASE_DATE"] = dtpPlanDate.DateTime.ToString("y… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5da99b60 | popSql.OnSql [if (programID == "PR_UI_FP01950_Manual_Create_… 외 3 | FP01950_Manual_Create_WO.cs:911 | try ▸ lambda | DATA_OP | Filter["WO_BASE_DATE"] | dtpPlanDate.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-5b6f2801 | popSql.OnSql [if (programID == "PR_UI_FP01950_Manual_Create_… 외 3 | FP01950_Manual_Create_WO.cs:912 | try ▸ lambda | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-1e773ae1 | popSql.OnSql [if (programID == "PR_UI_FP01950_Manual_Create_… 외 3 | FP01950_Manual_Create_WO.cs:913 | try ▸ lambda | DATA_OP | Filter["ITEM_ID"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-a65e75b6 | popSql.OnSql [if (programID == "PR_UI_FP01950_Manual_Create_… 외 3 | FP01950_Manual_Create_WO.cs:917 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP01950_Manual_Create_WO", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3e178ed6 | popSql.OnSql [if (programID == "PR_UI_FP01950_Manual_Create_… 외 3 | FP01950_Manual_Create_WO.cs:918 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-eaa11e31 | popSql.OnSql [if (programID == "PR_UI_FP01950_Manual_Create_… 외 3 | FP01950_Manual_Create_WO.cs:923 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01950_Manual_Create_WO.FindData

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3126ffb4 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:799 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d6cb2035 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:799 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d6ab132 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:803 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d71e9d5e | FindButton 외 1 | FP01950_Manual_Create_WO.cs:804 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8597d20 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:807 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7137d2dd | FindButton 외 1 | FP01950_Manual_Create_WO.cs:811 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bc4b04bb | FindButton 외 1 | FP01950_Manual_Create_WO.cs:818 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-eb2ef527 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:820 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e1043d2 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:829 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2b1cb375 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:831 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-35700bd5 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:861 | try ▸ for (i < rowcount) | GRID_COMBO | siMain.SetCellTypeCombo | (i, siMain.GetColumnIndex(DefColumns.STATUS), dtStatus) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-447b2307 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:862 | try ▸ for (i < rowcount) | GRID_COMBO | siMain.SetCellTypeCombo | (i, siMain.GetColumnIndex(DefColumns.MARKET), dtMarket) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-80ad790e | FindButton 외 1 | FP01950_Manual_Create_WO.cs:863 | try ▸ for (i < rowcount) | GRID_COMBO | siMain.SetCellTypeCombo | (i, siMain.GetColumnIndex(DefColumns.REQUEST_TYPE), dtRequestType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-dd23616f | FindButton 외 1 | FP01950_Manual_Create_WO.cs:872 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToString() == "1") | GRID_SET | siMain.ActiveSheet.Cells[i, select_col].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-c675fbc9 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:873 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToString() == "1") | GRID_SET | siMain.ActiveSheet.Cells[i, 0].Value | CAppSetting.FlagM | 그리드 속성/값 설정 |  |  |  |
| AC-fe59740f | FindButton 외 1 | FP01950_Manual_Create_WO.cs:877 | try | FLAG | isApply | true | 화면 필드/플래그 변경 |  |  |  |
| AC-46438aa9 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:881 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0be17cd9 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:893 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-58c24814 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:897 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-ce774071 | FindButton 외 1 | FP01950_Manual_Create_WO.cs:898 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01950_Manual_Create_WO.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e49e9ca5 | this.Load | FP01950_Manual_Create_WO.cs:121 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01950_Manual_Create_WO.GetOperation

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e61abc8 | this.Load | FP01950_Manual_Create_WO.cs:202 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, CurrentUser, _sNonAuth, _sSaveAuth , null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-2bcba8f9 | this.Load | FP01950_Manual_Create_WO.cs:202 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-80455ffa | this.Load | FP01950_Manual_Create_WO.cs:204 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP01950_Manual_Create_WO.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77fb35f6 | this.Load | FP01950_Manual_Create_WO.cs:164 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6506c118 | this.Load | FP01950_Manual_Create_WO.cs:174 |  | VALUE_SET | dtpPlanDate.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-5aa5d6ac | this.Load | FP01950_Manual_Create_WO.cs:175 |  | DATA_OP | Filter["WO_BASE_DATE"] | dtpPlanDate.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-dc995eb4 | this.Load | FP01950_Manual_Create_WO.cs:177 |  | FLAG | dtStatus | Data_FP.CallGeneralProcedure2(("PR_UI_FP01950_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-2c82f27b | this.Load | FP01950_Manual_Create_WO.cs:177 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01950_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "STATUS") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e2d6b04c | this.Load | FP01950_Manual_Create_WO.cs:178 |  | FLAG | dtMarket | Data_FP.CallGeneralProcedure2(("PR_UI_FP01950_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-cf203534 | this.Load | FP01950_Manual_Create_WO.cs:178 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01950_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "MARKET") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-50e764a2 | this.Load | FP01950_Manual_Create_WO.cs:179 |  | FLAG | dtRequestType | Data_FP.CallGeneralProcedure2(("PR_UI_FP01950_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-99569739 | this.Load | FP01950_Manual_Create_WO.cs:179 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01950_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "REQUEST_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ce3ebc3f | this.Load | FP01950_Manual_Create_WO.cs:180 |  | FLAG | dtBasisTime | Data_FP.CallGeneralProcedure2(("PR_UI_FP01950_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-61267bcb | this.Load | FP01950_Manual_Create_WO.cs:180 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01950_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "BASIS_TIME") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP01950_Manual_Create_WO.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8938577f | this.Load | FP01950_Manual_Create_WO.cs:249 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-2bd13a2c | this.Load | FP01950_Manual_Create_WO.cs:250 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8903595e | this.Load | FP01950_Manual_Create_WO.cs:251 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9d2c0e28 | this.Load | FP01950_Manual_Create_WO.cs:252 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, iColumnHeaderCount) | 그리드 재구성/초기화 |  |  |  |

## FP01950_Manual_Create_WO.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3e72190 | InsertButton | FP01950_Manual_Create_WO.cs:293 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1defa2da | InsertButton | FP01950_Manual_Create_WO.cs:311 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-663bd5ed | InsertButton | FP01950_Manual_Create_WO.cs:319 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, 2, iRow, 2, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b4b3fe16 | InsertButton | FP01950_Manual_Create_WO.cs:320 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, 4, iRow, 4, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-04a0a158 | InsertButton | FP01950_Manual_Create_WO.cs:321 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, 11, iRow, 11, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0de00cfa | InsertButton | FP01950_Manual_Create_WO.cs:322 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, 13, iRow, 13, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ea995c39 | InsertButton | FP01950_Manual_Create_WO.cs:323 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, 15, iRow, 15, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5bedd889 | InsertButton | FP01950_Manual_Create_WO.cs:324 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, 21, iRow, 21, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-151d3ae7 | InsertButton | FP01950_Manual_Create_WO.cs:325 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, 23, iRow, 30, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a09ffd75 | InsertButton | FP01950_Manual_Create_WO.cs:328 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.STATUS), dtStatus) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9871d285 | InsertButton | FP01950_Manual_Create_WO.cs:329 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.MARKET), dtMarket) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-57d23673 | InsertButton | FP01950_Manual_Create_WO.cs:330 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.REQUEST_TYPE), dtRequestType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-775b38db | InsertButton | FP01950_Manual_Create_WO.cs:333 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.WO_BASE_DATE)].Value | Filter["WO_BASE_DATE"] | 그리드 속성/값 설정 |  |  |  |
| AC-daa3950d | InsertButton | FP01950_Manual_Create_WO.cs:334 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.STATUS)].Value | "INSERT" | 그리드 속성/값 설정 |  |  |  |

## FP01950_Manual_Create_WO.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7644b91 | InsertButton | FP01950_Manual_Create_WO.cs:280 | if (!isApply) | MESSAGE | MessageHelper.GMessageBox | ("조회 먼저 진행하시오.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7e301fa4 | InsertButton | FP01950_Manual_Create_WO.cs:281 | if (!isApply) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01950_Manual_Create_WO.planday_changed

진입점: dtpPlanDate.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cceeb02f | dtpPlanDate.DateTimeChanged | FP01950_Manual_Create_WO.cs:1258 |  | DATA_OP | Filter["WO_BASE_DATE"] | dtpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP01950_Manual_Create_WO.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-948e4357 | popSql.OnSql | FP01950_Manual_Create_WO.cs:935 | if (programID == "PR_UI_FP01950_Manual_Create_WO") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-729b6569 | popSql.OnSql | FP01950_Manual_Create_WO.cs:938 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01950_Manual_Create_WO.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a770fcf5 | SaveButton | FP01950_Manual_Create_WO.cs:343 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5cf541d2 | SaveButton | FP01950_Manual_Create_WO.cs:345 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ddda53d | SaveButton | FP01950_Manual_Create_WO.cs:350 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-03d9fac7 | SaveButton | FP01950_Manual_Create_WO.cs:351 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17369ab6 | SaveButton | FP01950_Manual_Create_WO.cs:355 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-47bc6867 | SaveButton | FP01950_Manual_Create_WO.cs:359 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a5c5d9cb | SaveButton | FP01950_Manual_Create_WO.cs:364 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-74839313 | SaveButton | FP01950_Manual_Create_WO.cs:366 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c7706c76 | SaveButton | FP01950_Manual_Create_WO.cs:367 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8cbd275d | SaveButton | FP01950_Manual_Create_WO.cs:387 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!isChk) | MESSAGE | MessageBox.Show | ("체크된 항목이 없습니다.") | 메시지 표시 |  |  |  |
| AC-95d3c9b0 | SaveButton | FP01950_Manual_Create_WO.cs:388 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!isChk) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0d70c6cc | SaveButton | FP01950_Manual_Create_WO.cs:389 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!isChk) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e324efe | SaveButton | FP01950_Manual_Create_WO.cs:450 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToS… | CALL_EXT | dtBasisTime.Lookup | ("FACTORY_ID", sFactTmp, "BASIS_TIME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-18a37553 | SaveButton | FP01950_Manual_Create_WO.cs:458 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToS… | CALL_EXT | dtBasisTime.Lookup | ("FACTORY_ID", sFactTmp, "SITE_DATE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-474a3e7f | SaveButton | FP01950_Manual_Create_WO.cs:473 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToS… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("START_TIME")].Value | sTmp | 그리드 속성/값 설정 |  |  |  |
| AC-c4cc7000 | SaveButton | FP01950_Manual_Create_WO.cs:474 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToS… | GRID_SET | dsBind.Tables[0].Rows[i]["START_TIME"] | sTmp | 그리드 속성/값 설정 |  |  |  |
| AC-d257322f | SaveButton | FP01950_Manual_Create_WO.cs:478 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToS… | MESSAGE | MessageBox.Show | ("START_TIME must be later than site local Time (" + sDateTimeTmpView + "). Row : " + (i +… | 메시지 표시 |  |  |  |
| AC-734e55df | SaveButton | FP01950_Manual_Create_WO.cs:479 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToS… | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e7f8c8d9 | SaveButton | FP01950_Manual_Create_WO.cs:480 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b7d4d74 | SaveButton | FP01950_Manual_Create_WO.cs:494 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToS… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("END_TIME")].Value | sTmp | 그리드 속성/값 설정 |  |  |  |
| AC-afd8d0dd | SaveButton | FP01950_Manual_Create_WO.cs:495 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToS… | GRID_SET | dsBind.Tables[0].Rows[i]["END_TIME"] | sTmp | 그리드 속성/값 설정 |  |  |  |
| AC-3fc57569 | SaveButton | FP01950_Manual_Create_WO.cs:499 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToS… | MESSAGE | MessageBox.Show | ("END_TIME must be later than site local Time (" + sDateTimeTmpView + "). Row : " + (i + 1… | 메시지 표시 |  |  |  |
| AC-05a827bf | SaveButton | FP01950_Manual_Create_WO.cs:500 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToS… | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a6acb6d5 | SaveButton | FP01950_Manual_Create_WO.cs:501 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, select_col].Value.ToS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c391e1d | SaveButton | FP01950_Manual_Create_WO.cs:510 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-69bed1e2 | SaveButton | FP01950_Manual_Create_WO.cs:515 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6184e767 | SaveButton | FP01950_Manual_Create_WO.cs:524 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bf461257 | SaveButton | FP01950_Manual_Create_WO.cs:528 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d4d4ed33 | SaveButton | FP01950_Manual_Create_WO.cs:532 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-97c39e77 | SaveButton | FP01950_Manual_Create_WO.cs:533 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-06cef542 | SaveButton | FP01950_Manual_Create_WO.cs:537 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-809a28fc | SaveButton | FP01950_Manual_Create_WO.cs:538 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP01950_Manual_Create_WO.Save_Data_Line

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a0400e7 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:583 | try | DATA_OP | dsSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7b32504b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:586 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e9162074 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:599 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | dsBind.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6289b722 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:600 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns._SELECT] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("_SELECT")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-9f37903a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:602 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.STATUS] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("STATUS")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-4324590a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:603 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.WO_BASE_DATE] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("WO_BASE_DATE")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-9ccc4ca7 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:604 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.FACTORY_ID] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("FACTORY_ID")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-5d9b80a9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:605 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.LINE_ID] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("LINE_ID")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-deb920bd | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:606 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.OPERATION_ID] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("OPERATION_ID")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-bd94a864 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:607 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.EQUIPMENT_ID] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("EQUIPMENT_ID")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-17339c72 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:608 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.ITEM_ID] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("ITEM_ID")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-7c0ef784 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:609 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.WORK_CENTER_ID] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("WORK_CENTER_ID")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-0e037a21 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:610 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.WO_ID] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("WO_ID")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-a4b27a2a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:611 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.MO_ID] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("MO_ID")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-7eceb10b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:612 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.ORDER_TYPE] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("ORDER_TYPE")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-233ee50b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:613 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.WO_TYPE] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("WO_TYPE")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-06fb7de9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:614 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.START_TIME] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("START_TIME")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-aadf1939 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:615 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.END_TIME] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("END_TIME")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-1235b3b1 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:616 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.IN_QTY] | string.IsNullOrEmpty(siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("IN_QTY")].Value.Sa… | 행/컬럼 값 대입 |  |  |  |
| AC-7e093dd2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:617 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.OUT_QTY] | string.IsNullOrEmpty(siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("OUT_QTY")].Value.S… | 행/컬럼 값 대입 |  |  |  |
| AC-c76dd133 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:618 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.LANE_QTY] | string.IsNullOrEmpty(siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("LANE_QTY")].Value.… | 행/컬럼 값 대입 |  |  |  |
| AC-b37d5602 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:620 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.MARKET] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("MARKET")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-e081d6e0 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:621 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.PROCESSING_YN] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("PROCESSING_YN")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-6a7dd03e | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:622 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.ORDER_CREAT_DATE] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("ORDER_CREAT_DATE")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-8ae9efeb | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:623 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.CREATE_DATE] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("CREATE_DATE")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-2fca10f7 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:624 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.CREATE_PSN_ID] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("CREATE_PSN_ID")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-853ca6b3 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:625 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.UPDATE_DATE] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("UPDATE_DATE")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-66b17071 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:626 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.UPDATE_PSN_ID] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("UPDATE_PSN_ID")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-c2a416f0 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:627 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.ERROR_MSG] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("ERROR_MSG")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-89df05a7 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:628 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.ERP_RESULT] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("ERP_RESULT")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-62e1013b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:629 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.REQUESTER] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("REQUESTER")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-2a636973 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:630 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.REQUEST_TYPE] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("REQUEST_TYPE")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-f656675d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:631 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.REQUEST_REASON] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("REQUEST_REASON")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-45bd183f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:632 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.TOP_ITEM_ID] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("TOP_ITEM_ID")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-26093dab | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:633 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | row[DefColumns.CSR_ID] | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex("CSR_ID")].Value | 행/컬럼 값 대입 |  |  |  |
| AC-f3f90edb | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:635 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | dsBind.Tables[0].Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-989a722b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:640 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagM: ▸ if (bindingRow.RowState != DataRowState.Modified) | CALL_EXT | bindingRow.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-71999c21 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:644 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagD: ▸ if (bindingRow.RowState != DataRowState.Deleted) | DATA_OP | bindingRow.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f13101b3 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:654 | try | CALL_EXT | dsSave.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-767107af | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:658 | try ▸ if (iCount > 0) | ENDPOINT | DataService.FP_UpdateBatch | ("FP01950_Manual_Create_WO", "update_FP01950", dsSave, 0, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_FP01950] \| FP\ADMIN\FP01… | 엔드포인트 호출 |  |  |  |
| AC-8fa7f021 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:661 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-5f36f434 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:663 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | DATA_OP | set.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ff601f2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:664 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6ac9742b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:666 | try ▸ if (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-74fef80e | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:670 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-a859d8e2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:676 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-397ca7dd | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP01950_Manual_Create_WO.cs:677 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01950_Manual_Create_WO.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81836095 | SaveButton | FP01950_Manual_Create_WO.cs:268 | if (!isApply) | MESSAGE | MessageHelper.GMessageBox | ("조회 먼저 진행하시오.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d65d9473 | SaveButton | FP01950_Manual_Create_WO.cs:269 | if (!isApply) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42a77394 | SaveButton | FP01950_Manual_Create_WO.cs:272 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01950_Manual_Create_WO.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5c2cdc2 | this.Load | FP01950_Manual_Create_WO.cs:187 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP01950_Manual_Create_WO.SetEditMode

진입점: FindButton [try ▸ if (spdMain != null)] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (spdMain != null)] / EditButton [if (spdMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be9c1fb6 | FindButton [try ▸ if (spdMain != null)] 외 2 | FP01950_Manual_Create_WO.cs:728 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-906736ec | FindButton [try ▸ if (spdMain != null)] 외 2 | FP01950_Manual_Create_WO.cs:731 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-1c8c09dd | FindButton [try ▸ if (spdMain != null)] 외 2 | FP01950_Manual_Create_WO.cs:743 | if (spdMain != null) ▸ if (isEdit) ▸ for (i < rowcount) | GRID_SET | siMain.ActiveSheet.Cells[i, reqIdx].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-05b1dfb3 | FindButton [try ▸ if (spdMain != null)] 외 2 | FP01950_Manual_Create_WO.cs:747 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (0, 0, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7791562e | FindButton [try ▸ if (spdMain != null)] 외 2 | FP01950_Manual_Create_WO.cs:748 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (2, 2, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0dac184a | FindButton [try ▸ if (spdMain != null)] 외 2 | FP01950_Manual_Create_WO.cs:749 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (4, 4, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8fd12fff | FindButton [try ▸ if (spdMain != null)] 외 2 | FP01950_Manual_Create_WO.cs:750 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (11, 11, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6fd6863e | FindButton [try ▸ if (spdMain != null)] 외 2 | FP01950_Manual_Create_WO.cs:751 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (13, 13, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c06e6c6e | FindButton [try ▸ if (spdMain != null)] 외 2 | FP01950_Manual_Create_WO.cs:752 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (15, 15, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2f34c63c | FindButton [try ▸ if (spdMain != null)] 외 2 | FP01950_Manual_Create_WO.cs:753 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (21, 21, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a302b2bc | FindButton [try ▸ if (spdMain != null)] 외 2 | FP01950_Manual_Create_WO.cs:754 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (23, 30, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP01950_Manual_Create_WO.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbf8cbab | this.spdMain.CellClick | FP01950_Manual_Create_WO.cs:1050 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2381c23c | this.spdMain.CellClick | FP01950_Manual_Create_WO.cs:1052 | try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88d59867 | this.spdMain.CellClick | FP01950_Manual_Create_WO.cs:1062 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUESTER)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e6e7e7f4 | this.spdMain.CellClick | FP01950_Manual_Create_WO.cs:1064 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUESTER)) | UI_PROP | popup.Width | 900 | 속성 Width 설정 |  |  |  |
| AC-61d4811b | this.spdMain.CellClick | FP01950_Manual_Create_WO.cs:1065 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUESTER)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-cce3fdd7 | this.spdMain.CellClick | FP01950_Manual_Create_WO.cs:1066 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUESTER)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2cba0c53 | this.spdMain.CellClick | FP01950_Manual_Create_WO.cs:1068 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUESTER)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2338f745 | this.spdMain.CellClick | FP01950_Manual_Create_WO.cs:1089 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUESTER)) ▸ if … | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].Value | item.UserID | 그리드 속성/값 설정 |  |  |  |
| AC-94edc9e3 | this.spdMain.CellClick | FP01950_Manual_Create_WO.cs:1091 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REQUESTER)) ▸ if … | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex("_SELECT")].Value | true | 그리드 속성/값 설정 |  |  |  |

## FP01950_Manual_Create_WO.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a2b0f9b | this.spdMain.Change | FP01950_Manual_Create_WO.cs:1241 | if (col == siMain.GetColumnIndex(DefColumns._SELECT)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b300b573 | this.spdMain.Change | FP01950_Manual_Create_WO.cs:1244 |  | GRID_SET | siMain.ActiveSheet.Cells[e.Row, select_col].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-49beb76d | this.spdMain.Change | FP01950_Manual_Create_WO.cs:1252 | if (!(col == siMain.GetColumnIndex(DefColumns.REQUESTER) \|\| col == siMain.GetColumnIndex(DefColumns.REQUEST_TYPE) \|\| col == …) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, proc_col].Value | "N" | 그리드 속성/값 설정 |  |  |  |

## FP01950_Manual_Create_WO.SwitchEdit

진입점: FindButton [try ▸ if (spdMain != null)] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (spdMain != null)] / EditButton [if (spdMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70b3e0ee | FindButton [try ▸ if (spdMain != null)] 외 2 | FP01950_Manual_Create_WO.cs:716 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |


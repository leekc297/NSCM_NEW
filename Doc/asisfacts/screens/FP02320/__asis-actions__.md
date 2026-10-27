# AS-IS 액션 대조표 — FP02320

> 원천: `Doc/asisfacts/screens/FP02320/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 329행 · 메서드 34 · 종류 DATA_OP 129 · FLAG 37 · GRID_SET 31 · RETURN 30 · UI_PROP 22 · ENDPOINT 12 · POPUP 10 · COMBO_DATA 9 · LIST_REBIND 9 · MESSAGE 8 · GRID_LOCK 6 · CALL_EXT 5 · GRID_INIT 4 · STATE 4 · UI_MISC 4 · THROW 3 · VALIDATE 2 · EXCEL 1 · GRID_BIND 1 · CALL_BASE 1 · GRID_COMBO 1 · ⚠ 의미 확인 필요 6


## FP02320_Pancake_Master.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47697c3c | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1110 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f8702c4 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1111 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3de5a5a | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1115 |  | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9c7fb79a | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1118 |  | DATA_OP | p.Filter["division_id"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-f041b570 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1119 |  | DATA_OP | p.Filter["site_id"] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-89044413 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1120 |  | DATA_OP | p.Filter["plant_id"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-604328d6 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1121 |  | DATA_OP | p.Filter["factory_id"] | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-e84c4402 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1122 |  | DATA_OP | p.Filter["item_id"] | tbItemId.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-618e7512 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1123 |  | DATA_OP | p.Filter["nick_name"] | tbNickName.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-a5bfb9fb | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1127 |  | DATA_OP | p.Filter["active_flag"] | CString.GetCheckedListValue(dtYesNo, cboActive.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-70f6e9ca | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1128 |  | DATA_OP | p.Filter["user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e434a001 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1130 |  | GRID_SET | p.KeyColumns["COMPANY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4d5d537b | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1131 |  | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ed6feb83 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1132 |  | GRID_SET | p.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e4e07d40 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1133 |  | GRID_SET | p.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5354f215 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1134 |  | GRID_SET | p.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-def6f8c8 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1135 |  | GRID_SET | p.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8b84a7c8 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1136 |  | GRID_SET | p.KeyColumns["LANE_QTY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-873f8928 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1137 |  | GRID_SET | p.KeyColumns["PROD_VERSION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-87c0efd0 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1139 |  | DATA_OP | p.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-493ac10a | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1140 |  | DATA_OP | p.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-c76cd0f2 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1141 |  | DATA_OP | p.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-1cc25fe4 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1142 |  | DATA_OP | p.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-858d2b43 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1143 |  | DATA_OP | p.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-6b9e8434 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1144 |  | DATA_OP | p.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-a79beb78 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1145 |  | DATA_OP | p.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-b7d0fa73 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1146 |  | DATA_OP | p.ColumnTitle["LANE_QTY"] | "Slitting" | 행/컬럼 값 대입 |  |  |  |
| AC-7e59101d | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1147 |  | DATA_OP | p.ColumnTitle["SLIT_WIDTH"] | "Width(mm)" | 행/컬럼 값 대입 |  |  |  |
| AC-5b442676 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1148 |  | DATA_OP | p.ColumnTitle["MAIN_LANE_QTY"] | "Main" | 행/컬럼 값 대입 |  |  |  |
| AC-ab45ba5b | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1149 |  | DATA_OP | p.ColumnTitle["SUB_LANE_QTY"] | "Sub" | 행/컬럼 값 대입 |  |  |  |
| AC-412fd5d6 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1150 |  | DATA_OP | p.ColumnTitle["HALF_SLIT_FLAG"] | "Half Slit Flag" | 행/컬럼 값 대입 |  |  |  |
| AC-70c1e619 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1151 |  | DATA_OP | p.ColumnTitle["ACTIVE_FLAG"] | "Active" | 행/컬럼 값 대입 |  |  |  |
| AC-662c58e9 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1152 |  | DATA_OP | p.ColumnTitle["PROD_VERSION_TYPE"] | "Conversion Type" | 행/컬럼 값 대입 |  |  |  |
| AC-eba234e4 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1154 |  | DATA_OP | p.ColumnWidth["PATTERN_QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-4cb83c29 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1155 |  | DATA_OP | p.ColumnWidth["ITEM_NAME"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-1efb63af | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1156 |  | DATA_OP | p.ColumnWidth["LANE"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-f91a45c7 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1158 |  | DATA_OP | p.ColumnWidth["COATED_LENGTH"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-7e447873 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1159 |  | DATA_OP | p.ColumnWidth["UNCOATED_LENGTH"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-21e4efed | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1160 |  | DATA_OP | p.ColumnWidth["LENGTH_UOM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-b264d536 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1161 |  | DATA_OP | p.ColumnWidth["PC_ROLL_LENGTH"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-6db61f03 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1162 |  | DATA_OP | p.ColumnWidth["PC_ROLL_LENGTH_UOM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-e9775ca4 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1163 |  | DATA_OP | p.ColumnWidth["PROD_VERSION_TYPE_ORG"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-1eb0942d | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1164 |  | DATA_OP | p.ColumnWidth["PROD_EDIT"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-e705db26 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1165 |  | DATA_OP | p.ColumnWidth["UPDATE_ID"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-8c3d5178 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1166 |  | DATA_OP | p.ColumnWidth["UPDATE_TIME"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-a49d4d1f | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1167 |  | DATA_OP | p.ColumnWidth["DESCRIPTION"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-04ef3db0 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1168 |  | DATA_OP | p.ColumnWidth["EDIT_YN"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-bb975527 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1170 |  | DATA_OP | p.ColumnBgColor["HALF_SLIT_FLAG"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-a57c117f | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1171 |  | DATA_OP | p.ColumnBgColor["ACTIVE_FLAG"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-1ebdefa6 | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1172 |  | DATA_OP | p.ColumnBgColor["PROD_VERSION_TYPE"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-30dd160e | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1174 |  | UI_PROP | p.DoSearchData | FP02320_SearchDataDelegate | 속성 DoSearchData 설정 |  |  |  |
| AC-519e90ca | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1175 |  | UI_PROP | p.DoLineCheck | FP02320_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-55e901ba | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1176 |  | UI_PROP | p.DoSaveData | FP02320_SaveDataDelegate | 속성 DoSaveData 설정 |  |  |  |
| AC-312eeeff | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1177 |  | UI_PROP | p.DoValidationData | FP02320_ValidateDataDelegate | 속성 DoValidationData 설정 |  |  |  |
| AC-c666631d | this.btnExcelImport.Click | FP02320_Pancake_Master.cs:1178 |  | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02320_Pancake_Master.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ed9a391 | this.btnSql.Click | FP02320_Pancake_Master.cs:517 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1366a9d4 | this.btnSql.Click | FP02320_Pancake_Master.cs:518 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-239fc1fb | this.btnSql.Click | FP02320_Pancake_Master.cs:520 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02320_PANCAKE_MASTER") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e1d9923 | this.btnSql.Click | FP02320_Pancake_Master.cs:521 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02320_Pancake_Master.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14877ff2 | (진입점 미연결) | FP02320_Pancake_Master.cs:1507 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02320_Pancake_Master.ClbDivision_SelectedIndexChanged

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a501fb2 | this.Load 외 1 | FP02320_Pancake_Master.cs:1186 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-470c5539 | this.Load 외 1 | FP02320_Pancake_Master.cs:1188 |  | UI_PROP | clbSite.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02320_Pancake_Master.ClbPlant_SelectedIndexChanged

진입점: this.Load / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b14d68d | this.Load 외 1 | FP02320_Pancake_Master.cs:1200 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-4853d3fe | this.Load 외 1 | FP02320_Pancake_Master.cs:1202 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02320_Pancake_Master.ClbSite_SelectedIndexChanged

진입점: this.Load / clbSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d6116e1 | this.Load 외 1 | FP02320_Pancake_Master.cs:1193 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-2ce748e7 | this.Load 외 1 | FP02320_Pancake_Master.cs:1195 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02320_Pancake_Master.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-416fa15c | this.Load | FP02320_Pancake_Master.cs:389 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-899c3e80 | this.Load | FP02320_Pancake_Master.cs:390 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-06dcd5ee | this.Load | FP02320_Pancake_Master.cs:392 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02320_Pancake_Master.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59a521cb | this.Load | FP02320_Pancake_Master.cs:169 |  | UI_PROP | siMain.ImagePopUp | imgList.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-96108912 | this.Load | FP02320_Pancake_Master.cs:171 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-9a8f3959 | this.Load | FP02320_Pancake_Master.cs:172 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-eae95ecd | this.Load | FP02320_Pancake_Master.cs:173 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-8476a622 | this.Load | FP02320_Pancake_Master.cs:178 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-672b4739 | this.Load | FP02320_Pancake_Master.cs:179 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-1311595d | this.Load | FP02320_Pancake_Master.cs:180 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0317e3ed | this.Load | FP02320_Pancake_Master.cs:184 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d14922d2 | this.Load | FP02320_Pancake_Master.cs:185 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-03d725d4 | this.Load | FP02320_Pancake_Master.cs:186 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP02320_Pancake_Master.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e3aca19 | DeleteButton | FP02320_Pancake_Master.cs:485 | if (spdMain != null) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ebd9c48 | DeleteButton | FP02320_Pancake_Master.cs:489 | if (spdMain != null) ▸ if (siMain.GetValue(nSelRow, siMain.GetColumnIndex(DefColumns.EDIT_YN)).SafeString() != "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90c9fe84 | DeleteButton | FP02320_Pancake_Master.cs:491 | if (spdMain != null) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP02320_Pancake_Master.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41208691 | Dispose | FP02320_Pancake_Master.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02320_Pancake_Master.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-720e1c74 | EditButton | FP02320_Pancake_Master.cs:428 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1256c91e | EditButton | FP02320_Pancake_Master.cs:430 | if (spdMain != null) | CALL_EXT | siMain.SwitchLockFP | (!isEdit) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8c7f8dc | EditButton | FP02320_Pancake_Master.cs:434 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SLIT_WIDTH), siMain.GetColumnIndex(DefColumns.PROD_VERSI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-786956c7 | EditButton | FP02320_Pancake_Master.cs:436 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.JUMBO_ROLL_LENGTH), siMain.GetColumnIndex(DefColumns.PC_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e755ca9d | EditButton | FP02320_Pancake_Master.cs:441 | if (spdMain != null) | CALL_EXT | siMain.LockColumnFPDone | () | ⚠ 의미 확인 필요 |  |  |  |

## FP02320_Pancake_Master.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-922ce799 | ExcelButton | FP02320_Pancake_Master.cs:510 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP02320_Pancake_Master.Find_Data

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e81ef8f6 | FindButton 외 1 | FP02320_Pancake_Master.cs:529 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4174810c | FindButton 외 1 | FP02320_Pancake_Master.cs:535 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7265281f | FindButton 외 1 | FP02320_Pancake_Master.cs:536 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35d35a4e | FindButton 외 1 | FP02320_Pancake_Master.cs:539 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-910b205c | FindButton 외 1 | FP02320_Pancake_Master.cs:541 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-3956c221 | FindButton 외 1 | FP02320_Pancake_Master.cs:541 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12663a42 | FindButton 외 1 | FP02320_Pancake_Master.cs:547 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-98ce6ada | FindButton 외 1 | FP02320_Pancake_Master.cs:554 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4a4b1ea3 | FindButton 외 1 | FP02320_Pancake_Master.cs:556 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-18bc5b26 | FindButton 외 1 | FP02320_Pancake_Master.cs:565 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ea24be6f | FindButton 외 1 | FP02320_Pancake_Master.cs:567 | try | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c5aace70 | FindButton 외 1 | FP02320_Pancake_Master.cs:568 | try | CALL_EXT | siMain.SetFormat | ("#,##0.#####", 9, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e2b8e89 | FindButton 외 1 | FP02320_Pancake_Master.cs:570 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2bea7a06 | FindButton 외 1 | FP02320_Pancake_Master.cs:573 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-21c67141 | FindButton 외 1 | FP02320_Pancake_Master.cs:586 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-91c67743 | FindButton 외 1 | FP02320_Pancake_Master.cs:587 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02320_Pancake_Master.Find_Data_Excel_Execute

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43ef9a81 | (진입점 미연결) | FP02320_Pancake_Master.cs:698 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02320_PANCAKE_MASTER") ⇒ FP_Master.PR_UI_FP02320_PANCAKE_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-0ea0c854 | (진입점 미연결) | FP02320_Pancake_Master.cs:699 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-72695410 | (진입점 미연결) | FP02320_Pancake_Master.cs:700 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-0b65fee5 | (진입점 미연결) | FP02320_Pancake_Master.cs:701 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-c41f99a1 | (진입점 미연결) | FP02320_Pancake_Master.cs:702 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-07f283a1 | (진입점 미연결) | FP02320_Pancake_Master.cs:703 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-14bf905c | (진입점 미연결) | FP02320_Pancake_Master.cs:705 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-2c097bdd | (진입점 미연결) | FP02320_Pancake_Master.cs:706 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-2fbfc6f7 | (진입점 미연결) | FP02320_Pancake_Master.cs:707 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-a0628b7b | (진입점 미연결) | FP02320_Pancake_Master.cs:708 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-13f33e34 | (진입점 미연결) | FP02320_Pancake_Master.cs:709 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-402147ee | (진입점 미연결) | FP02320_Pancake_Master.cs:710 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-a446a010 | (진입점 미연결) | FP02320_Pancake_Master.cs:711 | try | DATA_OP | request.Parameters["p_active_flag"] | pActive.Equals("ALL") ? DBNull.Value : pActive | 행/컬럼 값 대입 |  |  |  |
| AC-6c1a8ce1 | (진입점 미연결) | FP02320_Pancake_Master.cs:712 | try | DATA_OP | request.Parameters["p_bucket_from"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b36b1edf | (진입점 미연결) | FP02320_Pancake_Master.cs:713 | try | DATA_OP | request.Parameters["p_bucket_to"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1bc3c906 | (진입점 미연결) | FP02320_Pancake_Master.cs:714 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-356d7371 | (진입점 미연결) | FP02320_Pancake_Master.cs:716 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e3de5644 | (진입점 미연결) | FP02320_Pancake_Master.cs:723 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02320_Pancake_Master.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e84273cd | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:605 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pDivisionID = CString.GetCheckedListValue(dtDivision, clb… | ⚠ 의미 확인 필요 |  |  |  |
| AC-39bf70d5 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:607 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-518fe8a8 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:608 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-9749db71 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:609 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-e5e30240 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:610 | try ▸ lambda | FLAG | pFactoryID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd6c79b9 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:614 | try ▸ lambda | FLAG | pActive | cboActive.Text.Trim().ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-32fbc88e | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:633 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02320_PANCAKE_MASTER") ⇒ FP_Master.PR_UI_FP02320_PANCAKE_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-bdaf8698 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:634 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-eaf5b412 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:635 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b850fdec | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:636 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-d1fb2027 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:637 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1020df02 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:638 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-9d6b050b | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:640 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-b65e5eca | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:641 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-5b4090a0 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:642 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-725e7da2 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:643 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-e5ef8fbd | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:644 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-0f3e62d4 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:645 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-714fe3ad | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:647 | try | DATA_OP | request.Parameters["p_active_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f79816ab | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:652 | try | DATA_OP | request.Parameters["p_bucket_from"] | _b_FromDay | 행/컬럼 값 대입 |  |  |  |
| AC-29672534 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:654 | try | DATA_OP | request.Parameters["p_bucket_to"] | pCvtType.Equals("ALL") ? DBNull.Value : pCvtType | 행/컬럼 값 대입 |  |  |  |
| AC-c1e3c05f | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:657 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-afa6a03c | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:659 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f0227435 | popSql.OnSql [if (programID == "PR_UI_FP02320_PANCAKE_MASTER… 외 2 | FP02320_Pancake_Master.cs:666 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02320_Pancake_Master.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5377337 | this.Load | FP02320_Pancake_Master.cs:150 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02320_Pancake_Master.FP02320_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-333037fe | (진입점 미연결) | FP02320_Pancake_Master.cs:1100 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02320_Pancake_Master.FP02320_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a961e18 | (진입점 미연결) | FP02320_Pancake_Master.cs:1071 |  | ENDPOINT | DataService.FP_PseudoBatch | ("FP02320_PANCAKE_MASTER", "merge_FP02320", data) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02320] \| FP\Common\FP02… | 엔드포인트 호출 |  |  |  |
| AC-da8f848b | (진입점 미연결) | FP02320_Pancake_Master.cs:1075 |  | DATA_OP | rds.Tables.Add | (rdt) | 데이터 객체 조작/조회 |  |  |  |
| AC-98694b3f | (진입점 미연결) | FP02320_Pancake_Master.cs:1077 |  | RETURN | return rds; |  | 처리 중단/반환 |  |  |  |

## FP02320_Pancake_Master.FP02320_SearchDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73b76424 | (진입점 미연결) | FP02320_Pancake_Master.cs:1066 |  | RETURN | return set; |  | 처리 중단/반환 |  |  |  |

## FP02320_Pancake_Master.FP02320_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-923d30e4 | (진입점 미연결) | FP02320_Pancake_Master.cs:1084 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3d21529 | (진입점 미연결) | FP02320_Pancake_Master.cs:1085 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP02320_PANCAKE_MASTER", "delete_Excel_buffer", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-b5d68286 | (진입점 미연결) | FP02320_Pancake_Master.cs:1089 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP02320_PANCAKE_MASTER", "insert_Excel_buffer", data) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-c11667dc | (진입점 미연결) | FP02320_Pancake_Master.cs:1093 |  | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP02320_PANCAKE_MASTER", "find_Excel_buffer_validation", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-02f5d149 | (진입점 미연결) | FP02320_Pancake_Master.cs:1093 |  | RETURN | return DataService.FP_ExecuteQuery( "FP02320_PANCAKE_MASTER", "find_Excel_buffer… |  | 처리 중단/반환 |  |  |  |

## FP02320_Pancake_Master.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05cc9771 | this.Load | FP02320_Pancake_Master.cs:1533 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-16b4908f | this.Load | FP02320_Pancake_Master.cs:1534 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-53f8a6d7 | this.Load | FP02320_Pancake_Master.cs:1534 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7cf48559 | this.Load | FP02320_Pancake_Master.cs:1535 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02320_Pancake_Master.GetToDay

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8de9b24 | this.Load | FP02320_Pancake_Master.cs:260 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-3368099d | this.Load | FP02320_Pancake_Master.cs:261 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP02320_Pancake_Master.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82ecc10c | this.Load | FP02320_Pancake_Master.cs:193 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-84b24104 | this.Load | FP02320_Pancake_Master.cs:200 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-400816ac | this.Load | FP02320_Pancake_Master.cs:201 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2a90841a | this.Load | FP02320_Pancake_Master.cs:216 |  | FLAG | dtYesNo | Data_FP.Common_FP(Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 화면 필드/플래그 변경 |  |  |  |
| AC-1810da14 | this.Load | FP02320_Pancake_Master.cs:216 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-79247f98 | this.Load | FP02320_Pancake_Master.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesNo, cboActive, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fc8b9280 | this.Load | FP02320_Pancake_Master.cs:219 |  | FLAG | dtConversionType | Data_FP.Common_FP(Data_FP.Type.CONVERSION_TYPE, false, UserInfoContext.Current.UserId, _sN… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CONVERSION_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-0e2847b2 | this.Load | FP02320_Pancake_Master.cs:219 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.CONVERSION_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CONVERSION_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP02320_Pancake_Master.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fedfa8f5 | this.Load 외 2 | FP02320_Pancake_Master.cs:399 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-9ba8a376 | this.Load 외 2 | FP02320_Pancake_Master.cs:401 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-0477ccd7 | this.Load 외 2 | FP02320_Pancake_Master.cs:404 |  | CALL_EXT | siMain.SetColumnCombo | ("PROD_VERSION_TYPE", dtConversionType) | ⚠ 의미 확인 필요 |  |  |  |

## FP02320_Pancake_Master.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3008d33 | InsertButton | FP02320_Pancake_Master.cs:1029 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-97422a7b | InsertButton | FP02320_Pancake_Master.cs:1037 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.FACTORY_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-c4725e63 | InsertButton | FP02320_Pancake_Master.cs:1038 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-3199f90b | InsertButton | FP02320_Pancake_Master.cs:1042 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.LANE, 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1ffdd80 | InsertButton | FP02320_Pancake_Master.cs:1043 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.LANE_QTY, 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d76debd | InsertButton | FP02320_Pancake_Master.cs:1044 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.PATTERN_QTY, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-73dab6db | InsertButton | FP02320_Pancake_Master.cs:1045 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.SLIT_WIDTH, 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-65b7827c | InsertButton | FP02320_Pancake_Master.cs:1046 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.HALF_SLIT_FLAG, "N") | 데이터 객체 조작/조회 |  |  |  |
| AC-01f91dc0 | InsertButton | FP02320_Pancake_Master.cs:1047 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-89a1a201 | InsertButton | FP02320_Pancake_Master.cs:1048 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.PROD_VERSION_TYPE, "GENERAL") | 데이터 객체 조작/조회 |  |  |  |
| AC-099622fc | InsertButton | FP02320_Pancake_Master.cs:1049 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.EDIT_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e0cbd52 | InsertButton | FP02320_Pancake_Master.cs:1051 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-6867277e | InsertButton | FP02320_Pancake_Master.cs:1053 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.P… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a366eac0 | InsertButton | FP02320_Pancake_Master.cs:1054 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.SL… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8abaffda | InsertButton | FP02320_Pancake_Master.cs:1055 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.UPDATE_ID), siMain.GetColumnIndex(DefColumns.UP… | 그리드 편집 잠금/해제 |  |  |  |

## FP02320_Pancake_Master.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06fc9df5 | popSql.OnSql | FP02320_Pancake_Master.cs:1520 | if (programID == "PR_UI_FP02320_PANCAKE_MASTER") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-f61e704d | popSql.OnSql | FP02320_Pancake_Master.cs:1523 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02320_Pancake_Master.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-633a1577 | SaveButton | FP02320_Pancake_Master.cs:730 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-69697726 | SaveButton | FP02320_Pancake_Master.cs:732 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d663aeec | SaveButton | FP02320_Pancake_Master.cs:737 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5ec95914 | SaveButton | FP02320_Pancake_Master.cs:738 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d136b648 | SaveButton | FP02320_Pancake_Master.cs:741 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-571bcea5 | SaveButton | FP02320_Pancake_Master.cs:748 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-36b03236 | SaveButton | FP02320_Pancake_Master.cs:750 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-41e6548e | SaveButton | FP02320_Pancake_Master.cs:751 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1dd427e8 | SaveButton | FP02320_Pancake_Master.cs:784 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iLane_Qty != (iMain_Lane_Qty + iSub_Lane_Qty)) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iLane_Qty_Col].Value | iLane_Qty | 그리드 속성/값 설정 |  |  |  |
| AC-f4f80b76 | SaveButton | FP02320_Pancake_Master.cs:789 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iMain_Lane_Qty == 0 && iSub_Lane_Qty == 0) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f696d2d0 | SaveButton | FP02320_Pancake_Master.cs:792 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iMain_Lane_Qty == 0 && iSub_Lane_Qty == 0) | MESSAGE | MessageHelper.GMessageBox | ("Main and Sub Slitting is not zero.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-086f245e | SaveButton | FP02320_Pancake_Master.cs:793 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iMain_Lane_Qty == 0 && iSub_Lane_Qty == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d552821 | SaveButton | FP02320_Pancake_Master.cs:810 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | column_params.Add | ("COMPANY_ID", sCompany) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a3157f0 | SaveButton | FP02320_Pancake_Master.cs:811 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | column_params.Add | ("DIVISION_ID", sDivision) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d6bccff | SaveButton | FP02320_Pancake_Master.cs:812 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | column_params.Add | ("SITE_ID", sSite) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd478d84 | SaveButton | FP02320_Pancake_Master.cs:813 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | column_params.Add | ("PLANT_ID", sPlant) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4e1355c | SaveButton | FP02320_Pancake_Master.cs:814 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | column_params.Add | ("FACTORY_ID", sFactory) | 데이터 객체 조작/조회 |  |  |  |
| AC-a04a6822 | SaveButton | FP02320_Pancake_Master.cs:815 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | column_params.Add | ("ITEM_ID", sItem) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6c1c113 | SaveButton | FP02320_Pancake_Master.cs:816 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | column_params.Add | ("LANE_QTY", sLane) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4b1524f | SaveButton | FP02320_Pancake_Master.cs:817 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | column_params.Add | ("PROD_VERSION_TYPE", sProdType) | 데이터 객체 조작/조회 |  |  |  |
| AC-17f5601c | SaveButton | FP02320_Pancake_Master.cs:818 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a290d8c | SaveButton | FP02320_Pancake_Master.cs:820 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02320_PANCAKE_MASTER", "find_insertValid", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_insertValid] \| FP\Common\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4e7c7c56 | SaveButton | FP02320_Pancake_Master.cs:824 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ if (rtValid.Row… | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b70b8edf | SaveButton | FP02320_Pancake_Master.cs:826 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ if (rtValid.Row… | MESSAGE | MessageHelper.GMessageBox | ("Unmodifiable material is exists.\r\n - Building : " + sFactory + ", Material : " + sItem… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9fbc909b | SaveButton | FP02320_Pancake_Master.cs:830 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ if (rtValid.Row… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d7a951c | SaveButton | FP02320_Pancake_Master.cs:841 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e8815e45 | SaveButton | FP02320_Pancake_Master.cs:846 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39a47970 | SaveButton | FP02320_Pancake_Master.cs:855 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3096132 | SaveButton | FP02320_Pancake_Master.cs:859 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6cf1195d | SaveButton | FP02320_Pancake_Master.cs:863 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6fdbf858 | SaveButton | FP02320_Pancake_Master.cs:864 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-4477edc2 | SaveButton | FP02320_Pancake_Master.cs:868 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02320_Pancake_Master.Save_Data_Execute

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9170c854 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:977 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02320_SAVE") ⇒ FP_Master.PR_UI_FP02320_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-c5ddd06a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:978 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fe74c571 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:980 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-69aa59fe | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:981 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-775dc1ec | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:982 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-a4a0a143 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:983 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b6e76fa | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:985 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-7bccfbdb | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:986 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-61d7d013 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:987 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-989559bd | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:988 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-53cfcc09 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:989 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ba66b8e | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:990 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-7a370038 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:991 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_lane_qty"] | p_lane_qty | 행/컬럼 값 대입 |  |  |  |
| AC-1c66bd41 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:992 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_main_lane_qty"] | p_main_lane_qty | 행/컬럼 값 대입 |  |  |  |
| AC-ba702d39 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:993 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sub_lane_qty"] | p_sub_lane_qty | 행/컬럼 값 대입 |  |  |  |
| AC-f61fc7de | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:994 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pattern_qty"] | p_pattern_qty | 행/컬럼 값 대입 |  |  |  |
| AC-51bed43e | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:995 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_half_slit_flag"] | p_half_slit_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0850b412 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:996 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_slit_width"] | p_slit_width | 행/컬럼 값 대입 |  |  |  |
| AC-dbf8c43f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:997 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pc_roll_length"] | p_pc_roll_length | 행/컬럼 값 대입 |  |  |  |
| AC-9e6d39b2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:998 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pc_roll_length_uom"] | p_pc_roll_length_uom | 행/컬럼 값 대입 |  |  |  |
| AC-54c12c00 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:999 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_version_type"] | p_prod_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-68fc06a0 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:1000 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_version_type_org"] | p_prod_version_type_org | 행/컬럼 값 대입 |  |  |  |
| AC-f62123ae | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:1001 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pc_roll_length"] | p_pc_roll_length | 행/컬럼 값 대입 |  |  |  |
| AC-f78f5c8e | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:1002 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_jumbo_roll_length"] | p_jumbo_roll_length | 행/컬럼 값 대입 |  |  |  |
| AC-6e78a4da | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:1003 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-3112d10f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:1004 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9adccfba | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:1006 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2c16864d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:1007 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7adb43bd | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:1013 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-595d747e | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02320_Pancake_Master.cs:1019 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02320_Pancake_Master.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e30ae5cd | SaveButton | FP02320_Pancake_Master.cs:498 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02320_Pancake_Master.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3512e8bd | this.Load 외 3 | FP02320_Pancake_Master.cs:1545 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5071c2cf | this.Load 외 3 | FP02320_Pancake_Master.cs:1545 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1177cf88 | this.Load 외 3 | FP02320_Pancake_Master.cs:1550 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter["DIVISION_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-ee7f254d | this.Load 외 3 | FP02320_Pancake_Master.cs:1551 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-8a87d6a8 | this.Load 외 3 | FP02320_Pancake_Master.cs:1551 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f7ea6cf4 | this.Load 외 3 | FP02320_Pancake_Master.cs:1553 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)clbSite is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)clbSite as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bb705934 | this.Load 외 3 | FP02320_Pancake_Master.cs:1555 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)clbSite is UsrCombo) ▸ if ((object)clbSite … | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)clbSite as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-42d35373 | this.Load 외 3 | FP02320_Pancake_Master.cs:1562 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-09e3960b | this.Load 외 3 | FP02320_Pancake_Master.cs:1563 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-71b24b8e | this.Load 외 3 | FP02320_Pancake_Master.cs:1563 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-13a4ad3d | this.Load 외 3 | FP02320_Pancake_Master.cs:1565 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-179a4ef5 | this.Load 외 3 | FP02320_Pancake_Master.cs:1567 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlant is Usr… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-96b8c356 | this.Load 외 3 | FP02320_Pancake_Master.cs:1573 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-2d649cd0 | this.Load 외 3 | FP02320_Pancake_Master.cs:1574 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-c6f768ea | this.Load 외 3 | FP02320_Pancake_Master.cs:1574 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-72f1ad06 | this.Load 외 3 | FP02320_Pancake_Master.cs:1576 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ if ((object)clbFactory is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-983b4ff2 | this.Load 외 3 | FP02320_Pancake_Master.cs:1578 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ else of ((object)clbFactory is UsrCombo) ▸ if ((object)clbFactory … | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2985de4f | this.Load 외 3 | FP02320_Pancake_Master.cs:1585 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | DATA_OP | Filter["FACTORY_ID"] | sFactory | 행/컬럼 값 대입 |  |  |  |

## FP02320_Pancake_Master.SetCountry

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efa20c5b | this.Load | FP02320_Pancake_Master.cs:239 |  | FLAG | _b_ToDay | GetToDay() | 화면 필드/플래그 변경 |  |  |  |
| AC-2ece4e5f | this.Load | FP02320_Pancake_Master.cs:240 |  | FLAG | _b_FromDay | GetToDay() | 화면 필드/플래그 변경 |  |  |  |
| AC-03451110 | this.Load | FP02320_Pancake_Master.cs:242 |  | FLAG | _dicCountry | new Dictionary<string, string>() | 화면 필드/플래그 변경 |  |  |  |
| AC-f8cabfa4 | this.Load | FP02320_Pancake_Master.cs:243 |  | FLAG | dtCountryID | Data_FP.Common_FP(Data_FP.Type.COUNTRY_ID, false, UserInfoContext.Current.UserId, _sNonAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=COUNTRY_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-cb5efc45 | this.Load | FP02320_Pancake_Master.cs:243 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.COUNTRY_ID, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=COUNTRY_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ac6ab057 | this.Load | FP02320_Pancake_Master.cs:249 | if (dtCountryID != null && dtCountryID.Rows.Count > 0) ▸ for (i < dtCountryID.Rows.Count) | DATA_OP | _dicCountry.ContainsKey | (dtCountryID.Rows[i][0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-942ef848 | this.Load | FP02320_Pancake_Master.cs:251 | if (dtCountryID != null && dtCountryID.Rows.Count > 0) ▸ for (i < dtCountryID.Rows.Count) ▸ if (_dicCountry.ContainsKey(dtCountryID.Rows[i][… | DATA_OP | _dicCountry.Add | (dtCountryID.Rows[i][0].ToString(), dtCountryID.Rows[i][1].ToString()) | 데이터 객체 조작/조회 |  |  |  |

## FP02320_Pancake_Master.SetProd_Version_Type

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2c231db | this.Load | FP02320_Pancake_Master.cs:233 |  | FLAG | dtPROD_VERSION | Data_FP.Common_FP(Data_FP.Type.PROD_VERSION_TYPE, false, UserInfoContext.Current.UserId, _… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PROD_VERSION_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-27094f95 | this.Load | FP02320_Pancake_Master.cs:233 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PROD_VERSION_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveA… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PROD_VERSION_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8862640f | this.Load | FP02320_Pancake_Master.cs:234 |  | LIST_REBIND | clsCtrl.setListBox | (dtPROD_VERSION, clbConversion, true) | 목록 컨트롤 재구성 |  |  |  |

## FP02320_Pancake_Master.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-faed9037 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1347 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b66f935f | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1349 | try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-695e1ff3 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1366 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | FLAG | pDivisionID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5a0276fa | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1367 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | FLAG | pSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4d0a2425 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1368 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | FLAG | pPlantID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3b1b3e8f | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1375 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | POPUP | new FPC0001_BuildingPopup | (bFilterEnable, bMultiSelect, pDivisionID, pSiteID, pPlantID) | 팝업/폼 생성 |  |  |  |
| AC-1950a012 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1376 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | UI_PROP | factoryPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-09d713d2 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1377 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | POPUP | factoryPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-246c5427 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1389 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID), sCompany) | 그리드 값 설정 |  |  |  |
| AC-d00c1dcc | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1390 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-09601a7e | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1391 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID), sSite) | 그리드 값 설정 |  |  |  |
| AC-b0771bc6 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1392 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), sPlant) | 그리드 값 설정 |  |  |  |
| AC-4ce5c155 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1393 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID), sFactory) | 그리드 값 설정 |  |  |  |
| AC-c5b4d91a | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1402 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | DATA_OP | searchParam.Add | ("COMPANY_ID", siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID)).ToStri… | 데이터 객체 조작/조회 |  |  |  |
| AC-e45d3cbe | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1403 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | DATA_OP | searchParam.Add | ("DIVISION_ID", siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToSt… | 데이터 객체 조작/조회 |  |  |  |
| AC-a799d7e7 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1404 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | DATA_OP | searchParam.Add | ("SITE_ID", siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b25e6461 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1405 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | DATA_OP | searchParam.Add | ("LEVEL_2_CODE", "APC") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e15e35c | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1407 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | POPUP | new FPC0003_ItemPopup | (bFilterEnable, bMultiSelect, searchParam) | 팝업/폼 생성 |  |  |  |
| AC-006ffd6d | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1408 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6d166ad0 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1409 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-62a314c5 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1419 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID), sCompany) | 그리드 값 설정 |  |  |  |
| AC-ae70135b | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1420 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-8bb401d9 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1421 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID), sSite) | 그리드 값 설정 |  |  |  |
| AC-b282fc8d | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1422 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemID) | 그리드 값 설정 |  |  |  |
| AC-2ef94bd5 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1423 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID) \|\|… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |
| AC-0e90f92c | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1437 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3681c1a | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1440 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd889499 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1441 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc9570bb | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1445 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-36685dc2 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1446 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)… | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b8dead98 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1447 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)… | DATA_OP | dRow.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d3ad9ce | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1452 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-a297b3f8 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1455 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of ((e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PROD_VERSION_TYPE), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ae2477c0 | this.spdMain.CellClick | FP02320_Pancake_Master.cs:1469 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02320_Pancake_Master.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83389c35 | dsdmMain.Changed | FP02320_Pancake_Master.cs:1215 | if (this.IsEditMode != true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4525e89 | dsdmMain.Changed | FP02320_Pancake_Master.cs:1217 | if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.RowsAdded) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-64fb7e9c | dsdmMain.Changed | FP02320_Pancake_Master.cs:1227 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-eaab99fe | dsdmMain.Changed | FP02320_Pancake_Master.cs:1268 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIN_LANE_QTY)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SUB_LANE_QTY), vSLaneQty) | 그리드 값 설정 |  |  |  |
| AC-00e89bf3 | dsdmMain.Changed | FP02320_Pancake_Master.cs:1269 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIN_LANE_QTY)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LANE_QTY), (vMLaneQty + vSLaneQty)) | 그리드 값 설정 |  |  |  |
| AC-60981ea5 | dsdmMain.Changed | FP02320_Pancake_Master.cs:1270 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIN_LANE_QTY)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LANE), (vMLaneQty + vSLaneQty) * vPQty) | 그리드 값 설정 |  |  |  |
| AC-480d972f | dsdmMain.Changed | FP02320_Pancake_Master.cs:1292 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.MAIN_LANE_QTY)) ▸ if (e.Column… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LANE_QTY), (vMLaneQty + vSLaneQty)) | 그리드 값 설정 |  |  |  |
| AC-71bcba71 | dsdmMain.Changed | FP02320_Pancake_Master.cs:1293 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.MAIN_LANE_QTY)) ▸ if (e.Column… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LANE), (vMLaneQty + vSLaneQty) * vPQty) | 그리드 값 설정 |  |  |  |
| AC-d104f570 | dsdmMain.Changed | FP02320_Pancake_Master.cs:1318 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.MAIN_LANE_QTY)) ▸ else of (e.C… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LANE), vLaneQty) | 그리드 값 설정 |  |  |  |
| AC-e7f40010 | dsdmMain.Changed | FP02320_Pancake_Master.cs:1322 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.MAIN_LANE_QTY)) ▸ else of (e.C… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LANE), (vMLaneQty + vSLaneQty) * vPQty) | 그리드 값 설정 |  |  |  |
| AC-69097636 | dsdmMain.Changed | FP02320_Pancake_Master.cs:1325 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.MAIN_LANE_QTY)) ▸ else of (e.C… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LANE_QTY), (vMLaneQty + vSLaneQty)) | 그리드 값 설정 |  |  |  |
| AC-fc93dce0 | dsdmMain.Changed | FP02320_Pancake_Master.cs:1326 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.MAIN_LANE_QTY)) ▸ else of (e.C… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LANE), vLaneQty * vPQty) | 그리드 값 설정 |  |  |  |


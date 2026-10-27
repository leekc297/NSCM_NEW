# AS-IS 액션 대조표 — FP00413

> 원천: `Doc/asisfacts/screens/FP00413/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 242행 · 메서드 33 · 종류 DATA_OP 76 · RETURN 23 · FLAG 22 · CALL_EXT 20 · UI_PROP 15 · GRID_SET 14 · POPUP 10 · UI_MISC 10 · ENDPOINT 8 · GRID_INIT 6 · MESSAGE 6 · GRID_LOCK 6 · THROW 5 · LIST_REBIND 5 · STATE 4 · COMBO_DATA 4 · VALIDATE 3 · VALUE_SET 2 · EXCEL 1 · CALL_BASE 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 21


## FP00413_Formation_Tray_Master..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5595d53 | .ctor | FP00413_Formation_Tray_Master.cs:102 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00413_Formation_Tray_Master.btnExcel_Click

진입점: this.btnExcel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b925319f | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:744 |  | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-cd5a289b | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:745 |  | UI_PROP | p.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-f4e27434 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:745 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f3231851 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:747 |  | UI_PROP | p.ColumnHeaderCount | 1 | 속성 ColumnHeaderCount 설정 |  |  |  |
| AC-68db6f31 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:748 |  | GRID_SET | p.KeyColumns["COMPANY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-569cb6ab | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:749 |  | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-72dd1684 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:750 |  | GRID_SET | p.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-65d6bc81 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:751 |  | GRID_SET | p.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-063abcea | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:752 |  | GRID_SET | p.KeyColumns["TRAY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4ab12405 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:754 |  | DATA_OP | p.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-be67c2b8 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:755 |  | DATA_OP | p.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-34164250 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:756 |  | DATA_OP | p.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-c2084df4 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:757 |  | DATA_OP | p.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-227ea6ff | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:758 |  | DATA_OP | p.ColumnTitle["TRAY_ID"] | "Tray ID" | 행/컬럼 값 대입 |  |  |  |
| AC-22e71915 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:760 |  | DATA_OP | p.ColumnTitle["GROUP_TRAY_ID"] | "Group Tray ID" | 행/컬럼 값 대입 |  |  |  |
| AC-3c1c5a78 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:761 |  | DATA_OP | p.ColumnTitle["TRAY_NAME"] | "Tray Name" | 행/컬럼 값 대입 |  |  |  |
| AC-840d7a0e | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:762 |  | DATA_OP | p.ColumnTitle["TRAY_TYPE"] | "Tray Type" | 행/컬럼 값 대입 |  |  |  |
| AC-b4dbae55 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:763 |  | DATA_OP | p.ColumnTitle["CELL_CNT"] | "Channel Qty" | 행/컬럼 값 대입 |  |  |  |
| AC-5ba7ccc8 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:765 |  | DATA_OP | p.ColumnTitle["LOAD_YIELD"] | "Load Rate" | 행/컬럼 값 대입 |  |  |  |
| AC-1c682809 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:766 |  | DATA_OP | p.ColumnTitle["BUFFER_DAY"] | "Buffer Day" | 행/컬럼 값 대입 |  |  |  |
| AC-8ab51bbc | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:767 |  | DATA_OP | p.ColumnTitle["INVENTORY_CNT"] | "Inventory" | 행/컬럼 값 대입 |  |  |  |
| AC-aea5c039 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:768 |  | DATA_OP | p.ColumnTitle["INTRANSIT_CNT"] | "Intransit" | 행/컬럼 값 대입 |  |  |  |
| AC-bbc502d4 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:769 |  | DATA_OP | p.ColumnTitle["DESCRIPTION"] | "Description" | 행/컬럼 값 대입 |  |  |  |
| AC-c4d5bb38 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:771 |  | DATA_OP | p.ColumnTitle["ACTIVE_FLAG"] | "Active" | 행/컬럼 값 대입 |  |  |  |
| AC-e15e8252 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:773 |  | DATA_OP | p.ColumnWidth["COMPANY_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-30772ace | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:774 |  | DATA_OP | p.ColumnWidth["DIVISION_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-fb141387 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:775 |  | DATA_OP | p.ColumnWidth["SITE_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-e0e8c53a | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:776 |  | DATA_OP | p.ColumnWidth["PLANT_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-76f3c792 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:777 |  | DATA_OP | p.ColumnWidth["TRAY_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-e3bcf361 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:779 |  | DATA_OP | p.ColumnWidth["GROUP_TRAY_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-ac477167 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:780 |  | DATA_OP | p.ColumnWidth["TRAY_NAME"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-301cc23c | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:781 |  | DATA_OP | p.ColumnWidth["TRAY_TYPE"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-9e019782 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:782 |  | DATA_OP | p.ColumnWidth["CELL_CNT"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-b1efb321 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:784 |  | DATA_OP | p.ColumnWidth["LOAD_YIELD"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-a1b517b9 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:785 |  | DATA_OP | p.ColumnWidth["BUFFER_DAY"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-c6cb9c43 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:786 |  | DATA_OP | p.ColumnWidth["INVENTORY_CNT"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-2a8bd905 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:787 |  | DATA_OP | p.ColumnWidth["INTRANSIT_CNT"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-a5742846 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:788 |  | DATA_OP | p.ColumnWidth["DESCRIPTION"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-bc737076 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:791 |  | DATA_OP | p.ColumnWidth["ACTIVE_FLAG"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-b045a335 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:792 |  | DATA_OP | p.ColumnWidth["MESSAGE"] | 300 | 행/컬럼 값 대입 |  |  |  |
| AC-df0493df | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:795 |  | DATA_OP | p.ColumnBgColor["LOAD_YIELD"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-e96a2066 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:796 |  | DATA_OP | p.ColumnBgColor["BUFFER_DAY"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-381e9c32 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:797 |  | DATA_OP | p.ColumnBgColor["INVENTORY_CNT"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-fe03f4ea | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:798 |  | DATA_OP | p.ColumnBgColor["INTRANSIT_CNT"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-b5e31994 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:799 |  | DATA_OP | p.ColumnBgColor["DESCRIPTION"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-3adefe0e | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:802 |  | UI_PROP | p.DoSearchData | Excel_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-6d93f658 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:803 |  | UI_PROP | p.DoLineCheck | Excel_CheckRow | 속성 DoLineCheck 설정 |  |  |  |
| AC-d0260954 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:804 |  | UI_PROP | p.DoSaveData | Excel_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-41871a45 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:805 |  | UI_PROP | p.DoValidationData | Excel_CheckValidation | 속성 DoValidationData 설정 |  |  |  |
| AC-cd605919 | this.btnExcel.Click | FP00413_Formation_Tray_Master.cs:806 |  | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00413_Formation_Tray_Master.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21d8d0c6 | this.btnSql.Click | FP00413_Formation_Tray_Master.cs:483 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d89e1653 | this.btnSql.Click | FP00413_Formation_Tray_Master.cs:484 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c905940e | this.btnSql.Click | FP00413_Formation_Tray_Master.cs:486 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00413_FIND_FP00413") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea713077 | this.btnSql.Click | FP00413_Formation_Tray_Master.cs:487 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00413_Formation_Tray_Master.Cb_EditorValueChanged

진입점: cb.EditorValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-608e4d3c | cb.EditorValueChanged | FP00413_Formation_Tray_Master.cs:679 | if (buf_Index < 0 \|\| buf_Row < 0 \|\| buf_Cell < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78e93526 | cb.EditorValueChanged | FP00413_Formation_Tray_Master.cs:684 |  | GRID_SET | siMain.ActiveSheet.Cells[buf_Row, buf_Cell].Value | new_value | 그리드 속성/값 설정 |  |  |  |

## FP00413_Formation_Tray_Master.CboTray_SelectedIndexChanged

진입점: cboTray.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c7ff7e3 | cboTray.SelectedIndexChanged | FP00413_Formation_Tray_Master.cs:272 |  | DATA_OP | Filter["TRAY_TYPE"] | CString.GetCheckedListValue(dtTrayType, cboTray.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00413_Formation_Tray_Master.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a7b070b | this.Load | FP00413_Formation_Tray_Master.cs:285 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, iColumnHeaderCount, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8638173f | this.Load | FP00413_Formation_Tray_Master.cs:286 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7d9d6ca7 | this.Load | FP00413_Formation_Tray_Master.cs:287 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00413_Formation_Tray_Master.CreateTrayTypeTable

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cd86bc1 | this.Load | FP00413_Formation_Tray_Master.cs:239 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a849f2c | this.Load | FP00413_Formation_Tray_Master.cs:240 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d0efe9b | this.Load | FP00413_Formation_Tray_Master.cs:242 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-48e5e07b | this.Load | FP00413_Formation_Tray_Master.cs:242 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-380c20f7 | this.Load | FP00413_Formation_Tray_Master.cs:243 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b6dd1acc | this.Load | FP00413_Formation_Tray_Master.cs:243 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9724684 | this.Load | FP00413_Formation_Tray_Master.cs:244 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-40375c9a | this.Load | FP00413_Formation_Tray_Master.cs:244 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-276d4cb9 | this.Load | FP00413_Formation_Tray_Master.cs:245 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e053d1c | this.Load | FP00413_Formation_Tray_Master.cs:245 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2ac2f7e | this.Load | FP00413_Formation_Tray_Master.cs:247 |  | GRID_SET | dt.Rows[0]["CODE"] | "D" | 그리드 속성/값 설정 |  |  |  |
| AC-a2da1a0f | this.Load | FP00413_Formation_Tray_Master.cs:247 |  | GRID_SET | dt.Rows[0]["NAME"] | "Before Degas" | 그리드 속성/값 설정 |  |  |  |
| AC-797b736a | this.Load | FP00413_Formation_Tray_Master.cs:248 |  | GRID_SET | dt.Rows[1]["CODE"] | "E" | 그리드 속성/값 설정 |  |  |  |
| AC-0c933717 | this.Load | FP00413_Formation_Tray_Master.cs:248 |  | GRID_SET | dt.Rows[1]["NAME"] | "After Degas" | 그리드 속성/값 설정 |  |  |  |
| AC-39fed325 | this.Load | FP00413_Formation_Tray_Master.cs:249 |  | GRID_SET | dt.Rows[2]["CODE"] | "A" | 그리드 속성/값 설정 |  |  |  |
| AC-c524a30b | this.Load | FP00413_Formation_Tray_Master.cs:249 |  | GRID_SET | dt.Rows[2]["NAME"] | "Common" | 그리드 속성/값 설정 |  |  |  |
| AC-0efdeb09 | this.Load | FP00413_Formation_Tray_Master.cs:250 |  | GRID_SET | dt.Rows[3]["CODE"] | "-" | 그리드 속성/값 설정 |  |  |  |
| AC-abf39e31 | this.Load | FP00413_Formation_Tray_Master.cs:250 |  | GRID_SET | dt.Rows[3]["NAME"] | "Not defined" | 그리드 속성/값 설정 |  |  |  |
| AC-e552ae65 | this.Load | FP00413_Formation_Tray_Master.cs:251 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00413_Formation_Tray_Master.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f65f3ec | this.Load | FP00413_Formation_Tray_Master.cs:130 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e1f25ca5 | this.Load | FP00413_Formation_Tray_Master.cs:131 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-8db2e725 | this.Load | FP00413_Formation_Tray_Master.cs:132 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7862cb3d | this.Load | FP00413_Formation_Tray_Master.cs:136 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-466412df | this.Load | FP00413_Formation_Tray_Master.cs:137 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-007c38dc | this.Load | FP00413_Formation_Tray_Master.cs:138 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00413_Formation_Tray_Master.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9fc4a4e | Dispose | FP00413_Formation_Tray_Master.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00413_Formation_Tray_Master.Excel_CheckRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd6e4f2a | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:906 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00413_Formation_Tray_Master.Excel_CheckValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e48af64e | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:876 | try | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ff38094 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:877 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-18071ff9 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:878 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP00413_FormationTrayMaster", "delete_Excel_buffer", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-b5dfd392 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:882 | try | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00413_FormationTrayMaster", "insert_Excel_buffer", data, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\MASTE… | 엔드포인트 호출 |  |  |  |
| AC-c9f5386b | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:885 | try | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-7b079a4f | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:886 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-79b5b0aa | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:887 | try | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP00413_FormationTrayMaster", "find_Excel_buffer_validation", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ceefa35a | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:891 | try | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-d97c2bec | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:892 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-5e56d812 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:896 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-986e57a7 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:900 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP00413_Formation_Tray_Master.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5278e3a | ExcelButton | FP00413_Formation_Tray_Master.cs:476 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00413_Formation_Tray_Master.Excel_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09f7bf3d | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:847 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-00abfc54 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:848 | try | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00413_FormationTrayMaster", "merge_FP00413", data, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00413] \| FP\MASTER\FP00… | 엔드포인트 호출 |  |  |  |
| AC-6db26625 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:854 | try ▸ if (ret.DataSet != null) | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e5743772 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:855 | try | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-ca06b264 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:857 | try | DATA_OP | tmpDs.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-2771f697 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:858 | try | RETURN | return tmpDs; |  | 처리 중단/반환 |  |  |  |
| AC-a3f71200 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:862 | catch ((Exception ee)) | THROW | throw ee; |  | 예외 발생 |  |  |  |
| AC-19ba285d | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:866 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP00413_Formation_Tray_Master.Excel_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54826c4b | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:818 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0badd4ba | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:822 | try ▸ if (set.Good()) | CALL_EXT | set.Tables[0].SetColumnsOrder | ( "COMPANY_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID", "TRAY_ID", "GROUP_TRAY_ID", "TRAY_NA… | ⚠ 의미 확인 필요 |  |  |  |
| AC-314aadf4 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:830 | try | RETURN | return set; |  | 처리 중단/반환 |  |  |  |
| AC-003581cb | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:834 | catch ((Exception ae)) | THROW | throw ae; |  | 예외 발생 |  |  |  |
| AC-0a6b8013 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:838 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP00413_Formation_Tray_Master.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP00413_FIND_FP00413")] / this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) ▸ try ▸ lambda] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60f0c496 | popSql.OnSql [if (programID == "PR_UI_FP00413_FIND_FP00413")… 외 4 | FP00413_Formation_Tray_Master.cs:697 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { Filter["TRAY_ID"] = textTrayId.Text; if (radioActiveY.Che… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b1f9549 | popSql.OnSql [if (programID == "PR_UI_FP00413_FIND_FP00413")… 외 4 | FP00413_Formation_Tray_Master.cs:699 | try ▸ lambda | DATA_OP | Filter["TRAY_ID"] | textTrayId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-e0fe8c66 | popSql.OnSql [if (programID == "PR_UI_FP00413_FIND_FP00413")… 외 4 | FP00413_Formation_Tray_Master.cs:702 | try ▸ lambda ▸ if (radioActiveY.Checked) | DATA_OP | Filter["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-52e2aaa2 | popSql.OnSql [if (programID == "PR_UI_FP00413_FIND_FP00413")… 외 4 | FP00413_Formation_Tray_Master.cs:704 | try ▸ lambda ▸ else of (radioActiveY.Checked) ▸ if (radioActiveN.Checked) | DATA_OP | Filter["ACTIVE_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-a1826ad0 | popSql.OnSql [if (programID == "PR_UI_FP00413_FIND_FP00413")… 외 4 | FP00413_Formation_Tray_Master.cs:706 | try ▸ lambda ▸ else of (radioActiveY.Checked) ▸ else of (radioActiveN.Checked) | DATA_OP | Filter["ACTIVE_FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4e0b8bf4 | popSql.OnSql [if (programID == "PR_UI_FP00413_FIND_FP00413")… 외 4 | FP00413_Formation_Tray_Master.cs:708 | try ▸ lambda ▸ if (cbOnlyGroupTray.Checked) | DATA_OP | Filter["GROUP_TRAY_CNT"] | "1" | 행/컬럼 값 대입 |  |  |  |
| AC-a795f74b | popSql.OnSql [if (programID == "PR_UI_FP00413_FIND_FP00413")… 외 4 | FP00413_Formation_Tray_Master.cs:710 | try ▸ lambda ▸ else of (cbOnlyGroupTray.Checked) | DATA_OP | Filter["GROUP_TRAY_CNT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1f565182 | popSql.OnSql [if (programID == "PR_UI_FP00413_FIND_FP00413")… 외 4 | FP00413_Formation_Tray_Master.cs:712 | try ▸ lambda ▸ if (cboTray.SelectedIndex < 1) | DATA_OP | Filter["TRAY_TYPE_CODE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3c27f6fa | popSql.OnSql [if (programID == "PR_UI_FP00413_FIND_FP00413")… 외 4 | FP00413_Formation_Tray_Master.cs:718 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00413_FIND_FP00413", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c6ec3e8a | popSql.OnSql [if (programID == "PR_UI_FP00413_FIND_FP00413")… 외 4 | FP00413_Formation_Tray_Master.cs:719 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-6157e004 | popSql.OnSql [if (programID == "PR_UI_FP00413_FIND_FP00413")… 외 4 | FP00413_Formation_Tray_Master.cs:724 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00413_Formation_Tray_Master.FindData

진입점: this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] / FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bf49142 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:595 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f509ef20 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:596 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a35e03c5 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:599 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cc0dc31a | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:600 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-156edfe4 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:600 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a855004 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:604 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7ea48313 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:611 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-61d945ed | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:613 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b1ad32b2 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:619 | try | FLAG | dtTrayGroup | FP00413Service.findTray(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6e2fa63d | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:619 | try | CALL_EXT | FP00413Service.findTray | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-629899c1 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:623 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c8f0adf3 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:625 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a5cdd167 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:630 | try | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-644a415d | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:631 | try | CALL_EXT | siMain.SetFormat | ("#,##0", "CELL_CNT", "CELL_CNT", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b38ec106 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:632 | try | CALL_EXT | siMain.SetFormat | ("#,##0.00", "LOAD_YIELD", "LOAD_YIELD", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-83caac9f | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:633 | try | CALL_EXT | siMain.SetFormat | ("#,##0", "BUFFER_DAY", "BUFFER_DAY", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-17e2b2b4 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:634 | try | CALL_EXT | siMain.SetFormat | ("#,##0", "INVENTORY_CNT", "INVENTORY_CNT", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-02849738 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:635 | try | CALL_EXT | siMain.SetFormat | ("#,##0", "INTRANSIT_CNT", "INTRANSIT_CNT", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e47778a7 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:646 | try | UI_PROP | column.CellType | cb | 속성 CellType 설정 |  |  |  |
| AC-ae71b057 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:649 | try | LIST_REBIND | siMain.LoadCombo | (cb, dtTrayGroup,true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dbbe31ff | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:655 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-82c91bf4 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:667 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-94532952 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:671 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-20a71fb3 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00413_Formation_Tray_Master.cs:672 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP00413_Formation_Tray_Master.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08e9c445 | this.Load | FP00413_Formation_Tray_Master.cs:109 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00413_Formation_Tray_Master.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d603808 | this.Load | FP00413_Formation_Tray_Master.cs:226 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-00f6f5ed | this.Load | FP00413_Formation_Tray_Master.cs:227 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d9ae63e6 | this.Load | FP00413_Formation_Tray_Master.cs:227 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-580e24ad | this.Load | FP00413_Formation_Tray_Master.cs:230 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-1b04d797 | this.Load | FP00413_Formation_Tray_Master.cs:233 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00413_Formation_Tray_Master.GetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e81b050 | (진입점 미연결) | FP00413_Formation_Tray_Master.cs:963 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00413_Formation_Tray_Master.GetTrayType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b3a78aa | this.Load | FP00413_Formation_Tray_Master.cs:256 |  | FLAG | dtTrayType | CreateTrayTypeTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-8d622337 | this.Load | FP00413_Formation_Tray_Master.cs:257 |  | LIST_REBIND | clsCtrl.setListBox | (dtTrayType, cboTray, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00413_Formation_Tray_Master.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04e3358d | this.Load | FP00413_Formation_Tray_Master.cs:145 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-48ac5675 | this.Load | FP00413_Formation_Tray_Master.cs:160 |  | DATA_OP | Filter["TRAY_TYPE"] | CString.GetCheckedListValue(dtTrayType, cboTray.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-720633dc | this.Load | FP00413_Formation_Tray_Master.cs:162 |  | VALUE_SET | radioActiveAll.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-d79bb56f | this.Load | FP00413_Formation_Tray_Master.cs:163 |  | VALUE_SET | cbOnlyGroupTray.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-86a1505e | this.Load | FP00413_Formation_Tray_Master.cs:164 |  | DATA_OP | Filter["ACTIVE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-93653cf1 | this.Load | FP00413_Formation_Tray_Master.cs:165 |  | DATA_OP | Filter["ONLY_GROUP_TRAY"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00413_Formation_Tray_Master.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7caaf009 | this.Load | FP00413_Formation_Tray_Master.cs:211 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-2f86b2e2 | this.Load | FP00413_Formation_Tray_Master.cs:212 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00413_Formation_Tray_Master.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ece470e | this.Load | FP00413_Formation_Tray_Master.cs:294 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-08b524c5 | this.Load | FP00413_Formation_Tray_Master.cs:295 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4c8319c0 | this.Load | FP00413_Formation_Tray_Master.cs:296 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0a658bf2 | this.Load | FP00413_Formation_Tray_Master.cs:297 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, iColumnHeaderCount) | 그리드 재구성/초기화 |  |  |  |

## FP00413_Formation_Tray_Master.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff50f5a3 | popSql.OnSql | FP00413_Formation_Tray_Master.cs:736 | if (programID == "PR_UI_FP00413_FIND_FP00413") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-a77f3095 | popSql.OnSql | FP00413_Formation_Tray_Master.cs:739 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00413_Formation_Tray_Master.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3831381b | SaveButton | FP00413_Formation_Tray_Master.cs:318 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93d3552f | SaveButton | FP00413_Formation_Tray_Master.cs:320 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2519de77 | SaveButton | FP00413_Formation_Tray_Master.cs:325 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-05eda4a0 | SaveButton | FP00413_Formation_Tray_Master.cs:326 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bcd58643 | SaveButton | FP00413_Formation_Tray_Master.cs:329 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-de0858d8 | SaveButton | FP00413_Formation_Tray_Master.cs:333 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c49a3d8f | SaveButton | FP00413_Formation_Tray_Master.cs:337 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-3b80d274 | SaveButton | FP00413_Formation_Tray_Master.cs:339 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d4aeb68c | SaveButton | FP00413_Formation_Tray_Master.cs:340 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa8c0faa | SaveButton | FP00413_Formation_Tray_Master.cs:345 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-227e4a13 | SaveButton | FP00413_Formation_Tray_Master.cs:350 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0e2e7dd4 | SaveButton | FP00413_Formation_Tray_Master.cs:359 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-73348099 | SaveButton | FP00413_Formation_Tray_Master.cs:363 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6b873d79 | SaveButton | FP00413_Formation_Tray_Master.cs:367 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b3d7258f | SaveButton | FP00413_Formation_Tray_Master.cs:368 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-7e2ef94c | SaveButton | FP00413_Formation_Tray_Master.cs:372 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-09d001bd | SaveButton | FP00413_Formation_Tray_Master.cs:373 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP00413_Formation_Tray_Master.Save_Data_Line

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04e642a4 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:407 | try | DATA_OP | dsSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5a5adcb3 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:410 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-db2a3751 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:417 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: ▸ if (bindingRow.RowState !=… | CALL_EXT | bindingRow.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9628457c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:421 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagM: ▸ if (bindingRow.RowState != DataRowState.Modified) | CALL_EXT | bindingRow.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d2c631c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:425 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagD: ▸ if (bindingRow.RowState != DataRowState.Deleted) | DATA_OP | bindingRow.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-64c4b272 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:435 | try | CALL_EXT | dsSave.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6395b85a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:439 | try ▸ if (iCount > 0) | ENDPOINT | DataService.FP_UpdateBatch | ("FP00413_FormationTrayMaster", "update_FP00413", dsSave, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_FP00413] \| FP\MASTER\FP0… | 엔드포인트 호출 |  |  |  |
| AC-f1f77dc8 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:442 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-db12095b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:444 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | DATA_OP | set.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-de12ba96 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:445 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7813563a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:447 | try ▸ if (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-accc137b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:451 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-21167059 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:457 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-92a0c9e2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00413_Formation_Tray_Master.cs:458 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00413_Formation_Tray_Master.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc87b5c4 | SaveButton | FP00413_Formation_Tray_Master.cs:311 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00413_Formation_Tray_Master.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeff5c48 | this.Load 외 3 | FP00413_Formation_Tray_Master.cs:179 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c9a769a | this.Load 외 3 | FP00413_Formation_Tray_Master.cs:179 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4513e570 | this.Load 외 3 | FP00413_Formation_Tray_Master.cs:185 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-aee70506 | this.Load 외 3 | FP00413_Formation_Tray_Master.cs:185 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d56d240b | this.Load 외 3 | FP00413_Formation_Tray_Master.cs:186 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-01e619fa | this.Load 외 3 | FP00413_Formation_Tray_Master.cs:192 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-de7cf05e | this.Load 외 3 | FP00413_Formation_Tray_Master.cs:193 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-de00ddb8 | this.Load 외 3 | FP00413_Formation_Tray_Master.cs:193 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3a2b08c8 | this.Load 외 3 | FP00413_Formation_Tray_Master.cs:194 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8a12e453 | this.Load 외 3 | FP00413_Formation_Tray_Master.cs:201 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00413_Formation_Tray_Master.SetEditMode

진입점: this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) ▸ try] / FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / EditButton [if (spdMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-222a19e9 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:508 |  | CALL_EXT | siTarget.SwitchLockFP | (isEdit) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ede2b8b | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:522 | if (isEdit) ▸ if (EditByColumn == true) | CALL_EXT | siTarget.LockColumnFP | (c0, c0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d95a2c25 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:523 | if (isEdit) ▸ if (EditByColumn == true) | CALL_EXT | siTarget.LockColumnFP | (c1, c1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-309ea431 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:524 | if (isEdit) ▸ if (EditByColumn == true) | CALL_EXT | siTarget.LockColumnFP | (c2, c2, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-077e7d94 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:525 | if (isEdit) ▸ if (EditByColumn == true) | CALL_EXT | siTarget.LockColumnFP | (c3, c3, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b5845947 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:526 | if (isEdit) ▸ if (EditByColumn == true) | CALL_EXT | siTarget.LockColumnFP | (c4, c4, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc3b508c | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:527 | if (isEdit) ▸ if (EditByColumn == true) | CALL_EXT | siTarget.LockColumnFP | (c5, c5, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e647fa1 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:542 | if (isEdit) ▸ else of (EditByColumn == true) ▸ for (i < rowcount) ▸ if (EDITYN == "Y") | GRID_LOCK | siMain.LockRange | (i, c0, i, c0, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4ef822ad | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:543 | if (isEdit) ▸ else of (EditByColumn == true) ▸ for (i < rowcount) ▸ if (EDITYN == "Y") | GRID_LOCK | siMain.LockRange | (i, c1, i, c1, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d3f6f9de | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:544 | if (isEdit) ▸ else of (EditByColumn == true) ▸ for (i < rowcount) ▸ if (EDITYN == "Y") | GRID_LOCK | siMain.LockRange | (i, c2, i, c2, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a83b56a5 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:545 | if (isEdit) ▸ else of (EditByColumn == true) ▸ for (i < rowcount) ▸ if (EDITYN == "Y") | GRID_LOCK | siMain.LockRange | (i, c3, i, c3, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ba0adbc7 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:546 | if (isEdit) ▸ else of (EditByColumn == true) ▸ for (i < rowcount) ▸ if (EDITYN == "Y") | GRID_LOCK | siMain.LockRange | (i, c4, i, c4, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-411c8ec4 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:547 | if (isEdit) ▸ else of (EditByColumn == true) ▸ for (i < rowcount) ▸ if (EDITYN == "Y") | GRID_LOCK | siMain.LockRange | (i, c5, i, c5, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b7fa1424 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:559 | else of (isEdit) | CALL_EXT | siTarget.LockColumnFP | (0, siTarget.GetMaxColumnIndex(), true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f3ce249 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00413_Formation_Tray_Master.cs:585 |  | CALL_EXT | siTarget.LockColumnFPDone | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00413_Formation_Tray_Master.SetFilter

진입점: this.Load [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / clbDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / cboSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ada033ce | this.Load [switch (triggerControl) case DefColumns.DIVISION_… 외 3 | FP00413_Formation_Tray_Master.cs:958 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00413_Formation_Tray_Master.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c35b210 | this.spdMain.ComboSelChange | FP00413_Formation_Tray_Master.cs:916 | if (c != null) | FLAG | buf_Cell | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-34addffa | this.spdMain.ComboSelChange | FP00413_Formation_Tray_Master.cs:917 | if (c != null) | FLAG | buf_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b1494be1 | this.spdMain.ComboSelChange | FP00413_Formation_Tray_Master.cs:918 | if (c != null) | FLAG | buf_Index | c.SelectedIndex | 화면 필드/플래그 변경 |  |  |  |

## FP00413_Formation_Tray_Master.SwitchEdit

진입점: EditButton [if (spdMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd02e230 | EditButton [if (spdMain != null)] | FP00413_Formation_Tray_Master.cs:497 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## FP00413Service.findTray

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80c8856b | (진입점 미연결) | FP00413Service.cs:17 |  | DATA_OP | FilterSrc.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1319e98d | (진입점 미연결) | FP00413Service.cs:19 |  | DATA_OP | Filter["DIVISION_ID"] | FilterSrc["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-52d9881d | (진입점 미연결) | FP00413Service.cs:20 |  | DATA_OP | Filter["SITE_ID"] | FilterSrc["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d29b161d | (진입점 미연결) | FP00413Service.cs:21 |  | DATA_OP | Filter["PLANT_ID"] | FilterSrc["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c6b021bc | (진입점 미연결) | FP00413Service.cs:23 |  | DATA_OP | Filter["CTRL_DIVISION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fd024caa | (진입점 미연결) | FP00413Service.cs:24 |  | DATA_OP | Filter["CTRL_SITE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fa1d7e13 | (진입점 미연결) | FP00413Service.cs:25 |  | DATA_OP | Filter["CTRL_PLANT_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0f2372d7 | (진입점 미연결) | FP00413Service.cs:35 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00413_FormationTrayMaster", "find_Tray", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Tray] \| FP\Master\FP00413… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7398d30c | (진입점 미연결) | FP00413Service.cs:35 |  | RETURN | return DataService.FP_ExecuteQuery2("FP00413_FormationTrayMaster", "find_Tray", … |  | 처리 중단/반환 |  |  |  |


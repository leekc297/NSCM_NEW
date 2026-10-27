# AS-IS 액션 대조표 — FP02560

> 원천: `Doc/asisfacts/screens/FP02560/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 234행 · 메서드 26 · 종류 DATA_OP 87 · FLAG 29 · RETURN 22 · GRID_SET 18 · UI_PROP 18 · ENDPOINT 11 · POPUP 8 · MESSAGE 6 · COMBO_DATA 6 · GRID_INIT 4 · STATE 4 · UI_MISC 4 · GRID_LOCK 4 · LIST_REBIND 4 · THROW 3 · VALIDATE 2 · EXCEL 1 · GRID_BIND 1 · CALL_BASE 1 · GRID_COMBO 1 · ⚠ 의미 확인 필요 1


## FP02560_Site_Bod.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-725bc54b | this.btnExcelImport.Click | FP02560_Site_Bod.cs:781 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bdca04b6 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:782 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-479b8098 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:786 |  | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-cdb224bc | this.btnExcelImport.Click | FP02560_Site_Bod.cs:789 |  | DATA_OP | p.Filter["division_id"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-ef9e3195 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:790 |  | DATA_OP | p.Filter["site_id"] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-f44de8d1 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:791 |  | DATA_OP | p.Filter["plant_id"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-5539f267 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:792 |  | DATA_OP | p.Filter["user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-475da077 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:794 |  | GRID_SET | p.KeyColumns["COMPANY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6982f94a | this.btnExcelImport.Click | FP02560_Site_Bod.cs:795 |  | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-beeae101 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:796 |  | GRID_SET | p.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-de4c0e06 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:797 |  | GRID_SET | p.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ff645bfb | this.btnExcelImport.Click | FP02560_Site_Bod.cs:798 |  | GRID_SET | p.KeyColumns["TO_SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-12a33a05 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:799 |  | GRID_SET | p.KeyColumns["TO_PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a0f3df6f | this.btnExcelImport.Click | FP02560_Site_Bod.cs:800 |  | GRID_SET | p.KeyColumns["TRANSPORT_MODE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7e06c794 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:803 |  | DATA_OP | p.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-4b47a3bf | this.btnExcelImport.Click | FP02560_Site_Bod.cs:804 |  | DATA_OP | p.ColumnTitle["DIVISION_ID"] | "Divsion" | 행/컬럼 값 대입 |  |  |  |
| AC-ec75919a | this.btnExcelImport.Click | FP02560_Site_Bod.cs:805 |  | DATA_OP | p.ColumnTitle["SITE_ID"] | "From Site" | 행/컬럼 값 대입 |  |  |  |
| AC-f18f089b | this.btnExcelImport.Click | FP02560_Site_Bod.cs:806 |  | DATA_OP | p.ColumnTitle["PLANT_ID"] | "From Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-225c3cc5 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:807 |  | DATA_OP | p.ColumnTitle["TO_SITE_ID"] | "To Site" | 행/컬럼 값 대입 |  |  |  |
| AC-b31ef60c | this.btnExcelImport.Click | FP02560_Site_Bod.cs:808 |  | DATA_OP | p.ColumnTitle["TO_PLANT_ID"] | "To Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-e7409b9f | this.btnExcelImport.Click | FP02560_Site_Bod.cs:809 |  | DATA_OP | p.ColumnTitle["TRANSPORT_MODE"] | "Transport Mode" | 행/컬럼 값 대입 |  |  |  |
| AC-b8e2d343 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:810 |  | DATA_OP | p.ColumnTitle["TRANSPORT_PRIORITY"] | "Priority" | 행/컬럼 값 대입 |  |  |  |
| AC-19abe4aa | this.btnExcelImport.Click | FP02560_Site_Bod.cs:811 |  | DATA_OP | p.ColumnTitle["OUT_BUFFER_DAY"] | "Out Buffer" | 행/컬럼 값 대입 |  |  |  |
| AC-bf88530e | this.btnExcelImport.Click | FP02560_Site_Bod.cs:812 |  | DATA_OP | p.ColumnTitle["OUTBOUND_DAY"] | "Out Bound" | 행/컬럼 값 대입 |  |  |  |
| AC-96bf8454 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:813 |  | DATA_OP | p.ColumnTitle["SHIP_PORT_DAY"] | "Closing" | 행/컬럼 값 대입 |  |  |  |
| AC-b28ec78b | this.btnExcelImport.Click | FP02560_Site_Bod.cs:814 |  | DATA_OP | p.ColumnTitle["VOYAGE_DAY"] | "Voyage" | 행/컬럼 값 대입 |  |  |  |
| AC-ca42eb6b | this.btnExcelImport.Click | FP02560_Site_Bod.cs:815 |  | DATA_OP | p.ColumnTitle["INBOUND_DAY"] | "In Bound" | 행/컬럼 값 대입 |  |  |  |
| AC-fee1b34a | this.btnExcelImport.Click | FP02560_Site_Bod.cs:816 |  | DATA_OP | p.ColumnTitle["IN_BUFFER_DAY"] | "In Buffer" | 행/컬럼 값 대입 |  |  |  |
| AC-3790167e | this.btnExcelImport.Click | FP02560_Site_Bod.cs:817 |  | DATA_OP | p.ColumnTitle["ACTIVE_FLAG"] | "Active" | 행/컬럼 값 대입 |  |  |  |
| AC-002fd151 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:818 |  | DATA_OP | p.ColumnTitle["DESCRIPTION"] | "Description" | 행/컬럼 값 대입 |  |  |  |
| AC-f88c905c | this.btnExcelImport.Click | FP02560_Site_Bod.cs:820 |  | DATA_OP | p.ColumnBgColor["MON"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-a2a1b026 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:821 |  | DATA_OP | p.ColumnBgColor["TUE"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-c598b69e | this.btnExcelImport.Click | FP02560_Site_Bod.cs:822 |  | DATA_OP | p.ColumnBgColor["WED"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-aa47f220 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:823 |  | DATA_OP | p.ColumnBgColor["THU"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-b8bed1ec | this.btnExcelImport.Click | FP02560_Site_Bod.cs:824 |  | DATA_OP | p.ColumnBgColor["FRI"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-e9b23c00 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:825 |  | DATA_OP | p.ColumnBgColor["SAT"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-0673339c | this.btnExcelImport.Click | FP02560_Site_Bod.cs:826 |  | DATA_OP | p.ColumnBgColor["SUN"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-7494c115 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:828 |  | DATA_OP | p.ColumnBgColor["TRANSPORT_PRIORITY"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-574d25c0 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:829 |  | DATA_OP | p.ColumnBgColor["OUT_BUFFER_DAY"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-e6678af0 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:830 |  | DATA_OP | p.ColumnBgColor["OUTBOUND_DAY"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-07fa7245 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:831 |  | DATA_OP | p.ColumnBgColor["SHIP_PORT_DAY"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-a2af71dc | this.btnExcelImport.Click | FP02560_Site_Bod.cs:832 |  | DATA_OP | p.ColumnBgColor["VOYAGE_DAY"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-c7fbb988 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:833 |  | DATA_OP | p.ColumnBgColor["INBOUND_DAY"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-ccc9e2de | this.btnExcelImport.Click | FP02560_Site_Bod.cs:834 |  | DATA_OP | p.ColumnBgColor["IN_BUFFER_DAY"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-2eee4bd0 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:835 |  | DATA_OP | p.ColumnBgColor["ACTIVE_FLAG"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-04ca057c | this.btnExcelImport.Click | FP02560_Site_Bod.cs:836 |  | DATA_OP | p.ColumnBgColor["DESCRIPTION"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-a694a402 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:838 |  | DATA_OP | p.ColumnWidth["EDIT_YN"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-2ae4af53 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:839 |  | DATA_OP | p.ColumnWidth["EDIT_YN2"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-8e41f293 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:841 |  | UI_PROP | p.DoSearchData | FP02560_SearchDataDelegate | 속성 DoSearchData 설정 |  |  |  |
| AC-316ddd22 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:842 |  | UI_PROP | p.DoLineCheck | FP02560_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-5b0a84e3 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:843 |  | UI_PROP | p.DoSaveData | FP02560_SaveDataDelegate | 속성 DoSaveData 설정 |  |  |  |
| AC-56d5ed36 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:844 |  | UI_PROP | p.DoValidationData | FP02560_ValidateDataDelegate | 속성 DoValidationData 설정 |  |  |  |
| AC-c6accb75 | this.btnExcelImport.Click | FP02560_Site_Bod.cs:845 |  | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02560_Site_Bod.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53ea1579 | this.btnSql.Click | FP02560_Site_Bod.cs:330 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-656bf6eb | this.btnSql.Click | FP02560_Site_Bod.cs:331 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ed3882c9 | this.btnSql.Click | FP02560_Site_Bod.cs:333 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02560_SITE_BOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-dee333a9 | this.btnSql.Click | FP02560_Site_Bod.cs:334 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02560_Site_Bod.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7de3e5e | (진입점 미연결) | FP02560_Site_Bod.cs:1032 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02560_Site_Bod.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-803df7fb | this.Load | FP02560_Site_Bod.cs:241 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-33a623c6 | this.Load | FP02560_Site_Bod.cs:242 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f22580a3 | this.Load | FP02560_Site_Bod.cs:244 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02560_Site_Bod.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eec474fb | this.Load | FP02560_Site_Bod.cs:140 |  | UI_PROP | siMain.ImagePopUp | imgList.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-b295f86e | this.Load | FP02560_Site_Bod.cs:142 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-6caecfa2 | this.Load | FP02560_Site_Bod.cs:143 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-f0e5ef5b | this.Load | FP02560_Site_Bod.cs:144 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-50c4c108 | this.Load | FP02560_Site_Bod.cs:149 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4f3cfcc8 | this.Load | FP02560_Site_Bod.cs:150 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-9c74ba1e | this.Load | FP02560_Site_Bod.cs:151 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-84bb1ed1 | this.Load | FP02560_Site_Bod.cs:155 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7c132437 | this.Load | FP02560_Site_Bod.cs:156 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-7ee31f62 | this.Load | FP02560_Site_Bod.cs:157 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP02560_Site_Bod.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60540abc | Dispose | FP02560_Site_Bod.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02560_Site_Bod.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4f5b2e8 | EditButton | FP02560_Site_Bod.cs:280 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-72ef60b3 | EditButton | FP02560_Site_Bod.cs:282 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-a45935d0 | EditButton | FP02560_Site_Bod.cs:284 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.TRANSPORT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-853ca09b | EditButton | FP02560_Site_Bod.cs:291 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ca9dc97b | EditButton | FP02560_Site_Bod.cs:296 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-33b53040 | EditButton | FP02560_Site_Bod.cs:297 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.DefaultBackColor | 그리드 속성/값 설정 |  |  |  |

## FP02560_Site_Bod.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c03921f0 | ExcelButton | FP02560_Site_Bod.cs:323 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP02560_Site_Bod.Find_Data

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57ca9cb7 | FindButton 외 1 | FP02560_Site_Bod.cs:342 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-06c2b3b3 | FindButton 외 1 | FP02560_Site_Bod.cs:346 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-aa29fcdf | FindButton 외 1 | FP02560_Site_Bod.cs:346 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c3f2296 | FindButton 외 1 | FP02560_Site_Bod.cs:350 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d7006b69 | FindButton 외 1 | FP02560_Site_Bod.cs:351 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3765a113 | FindButton 외 1 | FP02560_Site_Bod.cs:354 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2a3a2860 | FindButton 외 1 | FP02560_Site_Bod.cs:360 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-613a59a2 | FindButton 외 1 | FP02560_Site_Bod.cs:367 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-da531be9 | FindButton 외 1 | FP02560_Site_Bod.cs:369 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cd3344e4 | FindButton 외 1 | FP02560_Site_Bod.cs:378 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-52b06aa5 | FindButton 외 1 | FP02560_Site_Bod.cs:380 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-889a3111 | FindButton 외 1 | FP02560_Site_Bod.cs:383 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0e875454 | FindButton 외 1 | FP02560_Site_Bod.cs:396 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-48dabbe8 | FindButton 외 1 | FP02560_Site_Bod.cs:397 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02560_Site_Bod.Find_Data_Excel_Execute

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e149774 | (진입점 미연결) | FP02560_Site_Bod.cs:480 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02560_SITE_BOD") ⇒ FP_Master.PR_UI_FP02560_SITE_BOD | 엔드포인트 요청 생성 |  |  |  |
| AC-9340494a | (진입점 미연결) | FP02560_Site_Bod.cs:481 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f537cacc | (진입점 미연결) | FP02560_Site_Bod.cs:482 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-f5944f85 | (진입점 미연결) | FP02560_Site_Bod.cs:483 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-ac7e145b | (진입점 미연결) | FP02560_Site_Bod.cs:484 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d3363a8d | (진입점 미연결) | FP02560_Site_Bod.cs:485 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-b8432eda | (진입점 미연결) | FP02560_Site_Bod.cs:487 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-11422cf2 | (진입점 미연결) | FP02560_Site_Bod.cs:488 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-a2e91df3 | (진입점 미연결) | FP02560_Site_Bod.cs:489 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-ba407e6e | (진입점 미연결) | FP02560_Site_Bod.cs:491 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-98681dd9 | (진입점 미연결) | FP02560_Site_Bod.cs:493 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5a07cb52 | (진입점 미연결) | FP02560_Site_Bod.cs:500 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02560_Site_Bod.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d7c09ee | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:411 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pDivisionID = CString.GetCheckedListValue(dtDivision, clb… | ⚠ 의미 확인 필요 |  |  |  |
| AC-de148ffa | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:413 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-a942e7d9 | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:414 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-df3e6bd3 | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:415 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-2306fe71 | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:432 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02560_SITE_BOD") ⇒ FP_Master.PR_UI_FP02560_SITE_BOD | 엔드포인트 요청 생성 |  |  |  |
| AC-d0a72631 | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:433 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f5db8500 | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:434 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-387df78b | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:435 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-0f461f09 | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:436 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3211200c | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:437 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-d1427be1 | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:439 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-b6eee783 | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:440 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-bc074380 | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:441 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-d75d3e53 | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:444 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-06ed52a2 | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:446 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-885dc0b4 | popSql.OnSql [if (programID == "PR_UI_FP02560_SITE_BOD")] 외 2 | FP02560_Site_Bod.cs:453 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02560_Site_Bod.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea34db90 | this.Load | FP02560_Site_Bod.cs:121 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02560_Site_Bod.FP02560_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-812a5a41 | (진입점 미연결) | FP02560_Site_Bod.cs:771 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02560_Site_Bod.FP02560_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b986774f | (진입점 미연결) | FP02560_Site_Bod.cs:743 |  | ENDPOINT | DataService.FP_PseudoBatch | ("FP02560_Site_Bod", "merge_FP02560", data) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02560] \| FP\Common\FP02… | 엔드포인트 호출 |  |  |  |
| AC-a17eb755 | (진입점 미연결) | FP02560_Site_Bod.cs:747 |  | DATA_OP | rds.Tables.Add | (rdt) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb9c7b79 | (진입점 미연결) | FP02560_Site_Bod.cs:749 |  | RETURN | return rds; |  | 처리 중단/반환 |  |  |  |

## FP02560_Site_Bod.FP02560_SearchDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a4c78ed | (진입점 미연결) | FP02560_Site_Bod.cs:738 |  | RETURN | return set; |  | 처리 중단/반환 |  |  |  |

## FP02560_Site_Bod.FP02560_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c931587 | (진입점 미연결) | FP02560_Site_Bod.cs:755 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ff77bfd | (진입점 미연결) | FP02560_Site_Bod.cs:756 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP02560_Site_Bod", "delete_Excel_buffer", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-fa1f762d | (진입점 미연결) | FP02560_Site_Bod.cs:760 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP02560_Site_Bod", "insert_Excel_buffer", data) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-e8a660a1 | (진입점 미연결) | FP02560_Site_Bod.cs:764 |  | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP02560_Site_Bod", "find_Excel_buffer_validation", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7433f3d7 | (진입점 미연결) | FP02560_Site_Bod.cs:764 |  | RETURN | return DataService.FP_ExecuteQuery( "FP02560_Site_Bod", "find_Excel_buffer_valid… |  | 처리 중단/반환 |  |  |  |

## FP02560_Site_Bod.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db2866d5 | this.Load | FP02560_Site_Bod.cs:164 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-294f599c | this.Load | FP02560_Site_Bod.cs:171 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fdd2a4db | this.Load | FP02560_Site_Bod.cs:172 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a4963887 | this.Load | FP02560_Site_Bod.cs:175 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-01a5dc27 | this.Load | FP02560_Site_Bod.cs:175 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5339cf2c | this.Load | FP02560_Site_Bod.cs:176 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ad64cde2 | this.Load | FP02560_Site_Bod.cs:178 |  | FLAG | dtYesNo | Data_FP.Common_FP(Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 화면 필드/플래그 변경 |  |  |  |
| AC-ef00980f | this.Load | FP02560_Site_Bod.cs:178 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7bbe4bd4 | this.Load | FP02560_Site_Bod.cs:180 |  | FLAG | dtTransportMode | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE, false, UserInfoContext.Current.UserId, _sNonAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-cf0e1bb9 | this.Load | FP02560_Site_Bod.cs:180 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP02560_Site_Bod.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2851901c | this.Load | FP02560_Site_Bod.cs:224 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-7d783233 | this.Load | FP02560_Site_Bod.cs:225 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-66a3913e | this.Load | FP02560_Site_Bod.cs:226 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02560_Site_Bod.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-232df27a | this.Load 외 2 | FP02560_Site_Bod.cs:251 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ad7452ae | this.Load 외 2 | FP02560_Site_Bod.cs:253 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |

## FP02560_Site_Bod.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f71a427 | InsertButton | FP02560_Site_Bod.cs:715 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f3497a5 | InsertButton | FP02560_Site_Bod.cs:720 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PLANT_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-f6bb493b | InsertButton | FP02560_Site_Bod.cs:721 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TO_PLANT_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-00c07a56 | InsertButton | FP02560_Site_Bod.cs:725 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-3314bd5b | InsertButton | FP02560_Site_Bod.cs:727 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-aa3af47f | InsertButton | FP02560_Site_Bod.cs:729 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |

## FP02560_Site_Bod.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ecebc75 | popSql.OnSql | FP02560_Site_Bod.cs:1045 | if (programID == "PR_UI_FP02560_SITE_BOD") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-296cae7f | popSql.OnSql | FP02560_Site_Bod.cs:1048 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02560_Site_Bod.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-244242ee | SaveButton | FP02560_Site_Bod.cs:507 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43243ee6 | SaveButton | FP02560_Site_Bod.cs:509 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b097062d | SaveButton | FP02560_Site_Bod.cs:514 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4a57fa96 | SaveButton | FP02560_Site_Bod.cs:515 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-421611fc | SaveButton | FP02560_Site_Bod.cs:518 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-dadcbda3 | SaveButton | FP02560_Site_Bod.cs:525 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-7bd070b7 | SaveButton | FP02560_Site_Bod.cs:527 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-32b87c74 | SaveButton | FP02560_Site_Bod.cs:528 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b89503d | SaveButton | FP02560_Site_Bod.cs:533 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c04f87ea | SaveButton | FP02560_Site_Bod.cs:538 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d0b70d5 | SaveButton | FP02560_Site_Bod.cs:547 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7a55e8f1 | SaveButton | FP02560_Site_Bod.cs:551 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f741f6b6 | SaveButton | FP02560_Site_Bod.cs:555 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2dd13d5f | SaveButton | FP02560_Site_Bod.cs:556 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-7b9844c4 | SaveButton | FP02560_Site_Bod.cs:560 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02560_Site_Bod.Save_Data_Execute

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-049bcfa9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:660 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02560_SAVE") ⇒ FP_Master.PR_UI_FP02560_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-29255da0 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:661 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1c643425 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:663 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-d0939734 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:664 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9331fa07 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:665 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-ce47527d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:666 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-28f2a203 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:668 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-ca417ea2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:669 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c9ad76c6 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:670 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-9dd1048a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:671 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-b7438073 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:672 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_to_site_id"] | p_to_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-9a441fd4 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:673 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_to_plant_id"] | p_to_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-9bfd049c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:674 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-c9dbbbfc | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:675 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_transport_priority"] | p_transport_priority | 행/컬럼 값 대입 |  |  |  |
| AC-02494c9e | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:676 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_out_buffer_day"] | p_out_buffer_day | 행/컬럼 값 대입 |  |  |  |
| AC-bfded157 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:677 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_outbound_day"] | p_outbound_day | 행/컬럼 값 대입 |  |  |  |
| AC-7bee6db9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:678 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_ship_port_day"] | p_ship_port_day | 행/컬럼 값 대입 |  |  |  |
| AC-80e43d0b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:679 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mon"] | p_mon | 행/컬럼 값 대입 |  |  |  |
| AC-9b1029e1 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:680 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_tue"] | p_tue | 행/컬럼 값 대입 |  |  |  |
| AC-97b3bd55 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:681 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wed"] | p_wed | 행/컬럼 값 대입 |  |  |  |
| AC-cb62a59f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:682 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_thu"] | p_thu | 행/컬럼 값 대입 |  |  |  |
| AC-04ac3ebb | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:683 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_fri"] | p_fri | 행/컬럼 값 대입 |  |  |  |
| AC-86c82c83 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:684 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sat"] | p_sat | 행/컬럼 값 대입 |  |  |  |
| AC-60d24921 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:685 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sun"] | p_sun | 행/컬럼 값 대입 |  |  |  |
| AC-c8ea1cd9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:686 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_voyage_day"] | p_voyage_day | 행/컬럼 값 대입 |  |  |  |
| AC-e4784aa7 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:687 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_inbound_day"] | p_inbound_day | 행/컬럼 값 대입 |  |  |  |
| AC-26ef4f54 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:688 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_in_buffer_day"] | p_in_buffer_day | 행/컬럼 값 대입 |  |  |  |
| AC-add82952 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:689 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b4b44a5d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:690 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-66c41a1d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:692 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7375d5c5 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:693 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fe8df26c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:699 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-f73d0712 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02560_Site_Bod.cs:705 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02560_Site_Bod.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-236a37a0 | SaveButton | FP02560_Site_Bod.cs:311 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02560_Site_Bod.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-009abe25 | this.Load 외 3 | FP02560_Site_Bod.cs:195 | if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-b6945834 | this.Load 외 3 | FP02560_Site_Bod.cs:196 | if (argType == "DIVISION") | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-b7f7ec46 | this.Load 외 3 | FP02560_Site_Bod.cs:198 | if (argType == "DIVISION") | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-02db9f41 | this.Load 외 3 | FP02560_Site_Bod.cs:198 | if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-94234553 | this.Load 외 3 | FP02560_Site_Bod.cs:199 | if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ef114885 | this.Load 외 3 | FP02560_Site_Bod.cs:202 | if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-13e06666 | this.Load 외 3 | FP02560_Site_Bod.cs:203 | if (argType == "DIVISION") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-94af0a9a | this.Load 외 3 | FP02560_Site_Bod.cs:204 | if (argType == "DIVISION") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-0a94d971 | this.Load 외 3 | FP02560_Site_Bod.cs:204 | if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b19b30df | this.Load 외 3 | FP02560_Site_Bod.cs:205 | if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ad6aa919 | this.Load 외 3 | FP02560_Site_Bod.cs:212 | if (argType == "SITE") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-e8edfb85 | this.Load 외 3 | FP02560_Site_Bod.cs:213 | if (argType == "SITE") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-331bc76e | this.Load 외 3 | FP02560_Site_Bod.cs:214 | if (argType == "SITE") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-f8e34bb1 | this.Load 외 3 | FP02560_Site_Bod.cs:214 | if (argType == "SITE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb4c4a68 | this.Load 외 3 | FP02560_Site_Bod.cs:215 | if (argType == "SITE") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP02560_Site_Bod.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26b06a37 | this.spdMain.CellClick | FP02560_Site_Bod.cs:879 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d9d94b6e | this.spdMain.CellClick | FP02560_Site_Bod.cs:881 | try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c36d2039 | this.spdMain.CellClick | FP02560_Site_Bod.cs:904 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID) \|\| e… | DATA_OP | searchParam.Add | ("SITE_ID", pSiteID) | 데이터 객체 조작/조회 |  |  |  |
| AC-020e6196 | this.spdMain.CellClick | FP02560_Site_Bod.cs:905 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID) \|\| e… | DATA_OP | searchParam.Add | ("PLANT_ID", pPlantID) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfeea31b | this.spdMain.CellClick | FP02560_Site_Bod.cs:907 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID) \|\| e… | POPUP | new FPC0023_PlantPopup | (bFilterEnable, bMultiSelect, searchParam) | 팝업/폼 생성 |  |  |  |
| AC-a4684803 | this.spdMain.CellClick | FP02560_Site_Bod.cs:908 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID) \|\| e… | UI_PROP | plantPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cab784d0 | this.spdMain.CellClick | FP02560_Site_Bod.cs:909 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID) \|\| e… | POPUP | plantPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-43b9d1d0 | this.spdMain.CellClick | FP02560_Site_Bod.cs:920 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID) \|\| e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID), sCompany) | 그리드 값 설정 |  |  |  |
| AC-26ce5847 | this.spdMain.CellClick | FP02560_Site_Bod.cs:921 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID) \|\| e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-95421b10 | this.spdMain.CellClick | FP02560_Site_Bod.cs:922 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID) \|\| e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID), sSite) | 그리드 값 설정 |  |  |  |
| AC-b1628c00 | this.spdMain.CellClick | FP02560_Site_Bod.cs:923 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID) \|\| e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), sPlant) | 그리드 값 설정 |  |  |  |
| AC-49e9bb71 | this.spdMain.CellClick | FP02560_Site_Bod.cs:944 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID) \|\| e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE_ID), sSite) | 그리드 값 설정 |  |  |  |
| AC-fb2fd042 | this.spdMain.CellClick | FP02560_Site_Bod.cs:945 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if ((e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID) \|\| e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TO_PLANT_ID), sPlant) | 그리드 값 설정 |  |  |  |
| AC-e4181ea5 | this.spdMain.CellClick | FP02560_Site_Bod.cs:956 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of ((e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID) \… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), dtTransportMode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9a44921b | this.spdMain.CellClick | FP02560_Site_Bod.cs:994 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |


# AS-IS 액션 대조표 — FP00414

> 원천: `Doc/asisfacts/screens/FP00414/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 534행 · 메서드 77 · 종류 DATA_OP 139 · FLAG 101 · GRID_INIT 37 · RETURN 35 · UI_PROP 33 · GRID_SET 32 · UI_MISC 29 · CALL_EXT 20 · POPUP 18 · ENDPOINT 14 · COMBO_DATA 14 · LIST_REBIND 13 · MESSAGE 9 · GRID_LOCK 9 · VALUE_SET 9 · STATE 8 · THROW 5 · GRID_BIND 4 · VALIDATE 2 · CALL_BASE 2 · EXCEL 1 · ⚠ 의미 확인 필요 22


## FP00414_Formation_Tray_4Model..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-129da07d | .ctor | FP00414_Formation_Tray_4Model.cs:91 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00414_Formation_Tray_4Model.btnExcel_Click

진입점: this.btnExcel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea5e6450 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:820 |  | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-04129d04 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:821 |  | UI_PROP | p.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-eae170bc | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:821 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3196e2c7 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:823 |  | UI_PROP | p.ColumnHeaderCount | 2 | 속성 ColumnHeaderCount 설정 |  |  |  |
| AC-20f90a20 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:824 |  | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6b3a7aeb | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:825 |  | GRID_SET | p.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6de1d115 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:826 |  | GRID_SET | p.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a6a5d559 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:827 |  | GRID_SET | p.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-53efcd3f | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:828 |  | GRID_SET | p.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c9349794 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:829 |  | GRID_SET | p.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-de12ddb4 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:830 |  | GRID_SET | p.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2e4d473b | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:831 |  | GRID_SET | p.KeyColumns["SHORTER_LT"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4cd7d718 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:833 |  | DATA_OP | p.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-fe226b06 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:834 |  | DATA_OP | p.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-49af0daa | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:835 |  | DATA_OP | p.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-4b6de821 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:836 |  | DATA_OP | p.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-d4902ad9 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:837 |  | DATA_OP | p.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-e2f278c5 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:838 |  | DATA_OP | p.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-ce05396f | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:839 |  | DATA_OP | p.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-3aba9487 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:840 |  | DATA_OP | p.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-074bd37b | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:842 |  | DATA_OP | p.ColumnTitle["BEFORE_DEGAS_ROUTE_ID"] | new Tuple<string, string>("Route", "Before Degas") | 행/컬럼 값 대입 |  |  |  |
| AC-3231aaac | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:843 |  | DATA_OP | p.ColumnTitle["BEFORE_DEGAS_LT"] | new Tuple<string, string>("L/T (min)", "Before Degas") | 행/컬럼 값 대입 |  |  |  |
| AC-24933753 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:844 |  | DATA_OP | p.ColumnTitle["BEFORE_DEGAS_LT_DAY"] | new Tuple<string, string>("L/T (day)", "Before Degas") | 행/컬럼 값 대입 |  |  |  |
| AC-b023f87e | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:845 |  | DATA_OP | p.ColumnTitle["AFTER_DEGAS_ROUTE_ID"] | new Tuple<string, string>("Route", "After Degas") | 행/컬럼 값 대입 |  |  |  |
| AC-1d48dd49 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:846 |  | DATA_OP | p.ColumnTitle["AFTER_DEGAS_LT"] | new Tuple<string, string>("L/T (min)", "After Degas") | 행/컬럼 값 대입 |  |  |  |
| AC-91a22f5e | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:847 |  | DATA_OP | p.ColumnTitle["AFTER_DEGAS_LT_DAY"] | new Tuple<string, string>("L/T (day)", "After Degas") | 행/컬럼 값 대입 |  |  |  |
| AC-ee810d37 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:849 |  | DATA_OP | p.ColumnTitle["SHORTER_LT"] | "SHorter L/T(day)" | 행/컬럼 값 대입 |  |  |  |
| AC-8122f6bd | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:851 |  | DATA_OP | p.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-bf0d3223 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:854 |  | DATA_OP | p.ColumnWidth["DIVISION_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-b148f6b6 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:855 |  | DATA_OP | p.ColumnWidth["SITE_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-b64c8462 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:856 |  | DATA_OP | p.ColumnWidth["PLANT_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-a751f70b | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:857 |  | DATA_OP | p.ColumnWidth["FACTORY_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-f24fc094 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:858 |  | DATA_OP | p.ColumnWidth["LINE_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-8b0f2c30 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:859 |  | DATA_OP | p.ColumnWidth["ITEM_ID"] | 140 | 행/컬럼 값 대입 |  |  |  |
| AC-91ab6a11 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:860 |  | DATA_OP | p.ColumnWidth["NICK_NAME"] | 110 | 행/컬럼 값 대입 |  |  |  |
| AC-cb7ac18a | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:861 |  | DATA_OP | p.ColumnWidth["OPERATION_ID"] | 110 | 행/컬럼 값 대입 |  |  |  |
| AC-fc152336 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:863 |  | DATA_OP | p.ColumnWidth["BEFORE_DEGAS_ROUTE_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-52b851a7 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:864 |  | DATA_OP | p.ColumnWidth["BEFORE_DEGAS_LT"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-6ae61146 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:865 |  | DATA_OP | p.ColumnWidth["BEFORE_DEGAS_LT_DAY"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-28748c87 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:866 |  | DATA_OP | p.ColumnWidth["AFTER_DEGAS_ROUTE_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-4d23fe75 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:867 |  | DATA_OP | p.ColumnWidth["AFTER_DEGAS_LT"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-0697d48c | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:868 |  | DATA_OP | p.ColumnWidth["AFTER_DEGAS_LT_DAY"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-50137d45 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:870 |  | DATA_OP | p.ColumnWidth["SHORTER_LT"] | 110 | 행/컬럼 값 대입 |  |  |  |
| AC-e23f6a3a | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:872 |  | DATA_OP | p.ColumnWidth["MESSAGE"] | 300 | 행/컬럼 값 대입 |  |  |  |
| AC-a8dd67a2 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:874 |  | DATA_OP | p.ColumnBgColor["SHORTER_LT"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-2a1c089d | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:876 |  | UI_PROP | p.DoSearchData | Excel_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-6c3dceef | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:877 |  | UI_PROP | p.DoLineCheck | Excel_CheckRow | 속성 DoLineCheck 설정 |  |  |  |
| AC-94d1a22d | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:878 |  | UI_PROP | p.DoSaveData | Excel_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-abce2150 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:879 |  | UI_PROP | p.DoValidationData | Excel_CheckValidation | 속성 DoValidationData 설정 |  |  |  |
| AC-81513a41 | this.btnExcel.Click | FP00414_Formation_Tray_4Model.cs:880 |  | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00414_Formation_Tray_4Model.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7761c17 | this.btnSql.Click | FP00414_Formation_Tray_4Model.cs:569 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1eac0f28 | this.btnSql.Click | FP00414_Formation_Tray_4Model.cs:570 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-97225f1f | this.btnSql.Click | FP00414_Formation_Tray_4Model.cs:572 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00414_FIND_FP00414") | 데이터 객체 조작/조회 |  |  |  |
| AC-548c0893 | this.btnSql.Click | FP00414_Formation_Tray_4Model.cs:573 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00414_Formation_Tray_4Model.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-305d4d28 | clbDivision.SelectedIndexChanged | FP00414_Formation_Tray_4Model.cs:232 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00414_Formation_Tray_4Model.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb58bab5 | clbPlant.SelectedIndexChanged | FP00414_Formation_Tray_4Model.cs:248 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00414_Formation_Tray_4Model.ClbSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8c057a4 | cboSite.SelectedIndexChanged | FP00414_Formation_Tray_4Model.cs:240 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00414_Formation_Tray_4Model.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9725e2b8 | this.Load | FP00414_Formation_Tray_4Model.cs:254 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, iColumnHeaderCount, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-443f5cfc | this.Load | FP00414_Formation_Tray_4Model.cs:255 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e511115 | this.Load | FP00414_Formation_Tray_4Model.cs:256 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00414_Formation_Tray_4Model.CreateTrayTypeTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0aa40fbd | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:215 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c32f323 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:216 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5d669f4 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:218 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-84ba74cb | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:218 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-567a60b3 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:219 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4d2b9f98 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:219 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-37c1cde9 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:220 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d94ed35a | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:220 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac749596 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:221 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f8d38b4e | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:221 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-237ef954 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:223 |  | GRID_SET | dt.Rows[0]["CODE"] | "D" | 그리드 속성/값 설정 |  |  |  |
| AC-03c373f4 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:223 |  | GRID_SET | dt.Rows[0]["NAME"] | "Before Degas" | 그리드 속성/값 설정 |  |  |  |
| AC-f3b17181 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:224 |  | GRID_SET | dt.Rows[1]["CODE"] | "E" | 그리드 속성/값 설정 |  |  |  |
| AC-3c1901ea | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:224 |  | GRID_SET | dt.Rows[1]["NAME"] | "After Degas" | 그리드 속성/값 설정 |  |  |  |
| AC-dc4f9143 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:225 |  | GRID_SET | dt.Rows[2]["CODE"] | "A" | 그리드 속성/값 설정 |  |  |  |
| AC-6584e1a7 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:225 |  | GRID_SET | dt.Rows[2]["NAME"] | "Common" | 그리드 속성/값 설정 |  |  |  |
| AC-9122e866 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:226 |  | GRID_SET | dt.Rows[3]["CODE"] | "-" | 그리드 속성/값 설정 |  |  |  |
| AC-fbd47889 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:226 |  | GRID_SET | dt.Rows[3]["NAME"] | "Not defined" | 그리드 속성/값 설정 |  |  |  |
| AC-31d157af | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:227 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00414_Formation_Tray_4Model.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e6d1f02 | this.Load | FP00414_Formation_Tray_4Model.cs:119 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e379b53e | this.Load | FP00414_Formation_Tray_4Model.cs:120 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-0b389113 | this.Load | FP00414_Formation_Tray_4Model.cs:121 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-82fb938f | this.Load | FP00414_Formation_Tray_4Model.cs:125 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6d00b8ba | this.Load | FP00414_Formation_Tray_4Model.cs:126 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-08be6f98 | this.Load | FP00414_Formation_Tray_4Model.cs:127 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-18022bca | this.Load | FP00414_Formation_Tray_4Model.cs:129 |  | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f0d4645f | this.Load | FP00414_Formation_Tray_4Model.cs:132 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-e2151b69 | this.Load | FP00414_Formation_Tray_4Model.cs:134 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-175e3468 | this.Load | FP00414_Formation_Tray_4Model.cs:135 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-8247f660 | this.Load | FP00414_Formation_Tray_4Model.cs:136 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP00414_Formation_Tray_4Model.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e5867e2 | Dispose | FP00414_Formation_Tray_4Model.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00414_Formation_Tray_4Model.Excel_CheckRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75121685 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:978 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00414_Formation_Tray_4Model.Excel_CheckValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9e67fd6 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:948 | try | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-0916e62d | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:949 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ede3084a | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:950 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP00414_FormationTrayModel", "delete_Excel_buffer", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-256c8eb3 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:954 | try | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00414_FormationTrayModel", "insert_Excel_buffer", data, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\MASTE… | 엔드포인트 호출 |  |  |  |
| AC-31496d6a | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:957 | try | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-19611676 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:958 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7c71f0dc | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:959 | try | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP00414_FormationTrayModel", "find_Excel_buffer_validation", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bd8c808a | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:963 | try | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-16744d94 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:964 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-b6903f2b | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:968 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-d0912adc | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:972 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP00414_Formation_Tray_4Model.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d40363ca | ExcelButton | FP00414_Formation_Tray_4Model.cs:562 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00414_Formation_Tray_4Model.Excel_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7915dad | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:919 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b391ef3f | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:920 | try | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00414_FormationTrayModel", "merge_FP00411_import", data, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00411_import] \| FP\MAST… | 엔드포인트 호출 |  |  |  |
| AC-e78d1ff6 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:926 | try ▸ if (ret.DataSet != null) | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3bcf74f6 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:927 | try | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-715f9949 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:929 | try | DATA_OP | tmpDs.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b400218 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:930 | try | RETURN | return tmpDs; |  | 처리 중단/반환 |  |  |  |
| AC-4b47e914 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:934 | catch ((Exception ee)) | THROW | throw ee; |  | 예외 발생 |  |  |  |
| AC-eb83c98c | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:938 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP00414_Formation_Tray_4Model.Excel_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90731216 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:892 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0d95f0de | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:896 | try ▸ if (set.Good()) | CALL_EXT | set.Tables[0].SetColumnsOrder | ( "DIVISION_ID", "SITE_ID", "PLANT_ID", "FACTORY_ID", "LINE_ID", "ITEM_ID", "NICK_NAME", "… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a3d20c5 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:902 | try | RETURN | return set; |  | 처리 중단/반환 |  |  |  |
| AC-a9ef6a51 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:906 | catch ((Exception ae)) | THROW | throw ae; |  | 예외 발생 |  |  |  |
| AC-10dcfd43 | (진입점 미연결) | FP00414_Formation_Tray_4Model.cs:910 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP00414_Formation_Tray_4Model.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP00414_FIND_FP00414")] / this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-908941f8 | popSql.OnSql [if (programID == "PR_UI_FP00414_FIND_FP00414")… 외 4 | FP00414_Formation_Tray_4Model.cs:786 | try ▸ if (radioActiveY.Checked) | DATA_OP | Filter["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-d6132150 | popSql.OnSql [if (programID == "PR_UI_FP00414_FIND_FP00414")… 외 4 | FP00414_Formation_Tray_4Model.cs:788 | try ▸ else of (radioActiveY.Checked) ▸ if (radioActiveN.Checked) | DATA_OP | Filter["ACTIVE_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-48d449bd | popSql.OnSql [if (programID == "PR_UI_FP00414_FIND_FP00414")… 외 4 | FP00414_Formation_Tray_4Model.cs:790 | try ▸ else of (radioActiveY.Checked) ▸ else of (radioActiveN.Checked) | DATA_OP | Filter["ACTIVE_FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a1cf1866 | popSql.OnSql [if (programID == "PR_UI_FP00414_FIND_FP00414")… 외 4 | FP00414_Formation_Tray_4Model.cs:791 | try | DATA_OP | Filter["FCS_MODEL_ID"] | txtFcsModelId.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-4b20f13c | popSql.OnSql [if (programID == "PR_UI_FP00414_FIND_FP00414")… 외 4 | FP00414_Formation_Tray_4Model.cs:792 | try | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-dfc8401f | popSql.OnSql [if (programID == "PR_UI_FP00414_FIND_FP00414")… 외 4 | FP00414_Formation_Tray_4Model.cs:793 | try | DATA_OP | Filter["ITEM_ID"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-9a53dd2d | popSql.OnSql [if (programID == "PR_UI_FP00414_FIND_FP00414")… 외 4 | FP00414_Formation_Tray_4Model.cs:794 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00414_FIND_FP00414", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4a94ab26 | popSql.OnSql [if (programID == "PR_UI_FP00414_FIND_FP00414")… 외 4 | FP00414_Formation_Tray_4Model.cs:795 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-f24bf1d6 | popSql.OnSql [if (programID == "PR_UI_FP00414_FIND_FP00414")… 외 4 | FP00414_Formation_Tray_4Model.cs:800 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00414_Formation_Tray_4Model.FindData

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-134d9cc7 | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:703 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-08d7ec79 | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:704 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2be3c181 | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:707 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-51265483 | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:709 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-8181a5a2 | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:709 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75304d0a | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:713 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9cdd0a68 | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:720 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8ca33c3a | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:722 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2fb51086 | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:731 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7c1d184c | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:733 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-08170634 | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:750 | try | UI_PROP | column.CellType | cb | 속성 CellType 설정 |  |  |  |
| AC-8b6a092c | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:751 | try | LIST_REBIND | siMain.LoadCombo | (cb, dtYesNo, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-090a30cb | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:757 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9b08f5cf | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:769 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-223a0a34 | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:773 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a402c876 | FindButton 외 1 | FP00414_Formation_Tray_4Model.cs:774 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP00414_Formation_Tray_4Model.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1a9d51c | this.Load | FP00414_Formation_Tray_4Model.cs:98 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00414_Formation_Tray_4Model.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75abd5ba | this.Load | FP00414_Formation_Tray_4Model.cs:191 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-df0031d6 | this.Load | FP00414_Formation_Tray_4Model.cs:191 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-10fb43da | this.Load | FP00414_Formation_Tray_4Model.cs:193 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00414_Formation_Tray_4Model.GetPlant

진입점: this.Load / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14eb0b64 | this.Load 외 1 | FP00414_Formation_Tray_4Model.cs:207 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-5ea468f4 | this.Load 외 1 | FP00414_Formation_Tray_4Model.cs:207 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0f371ac2 | this.Load 외 1 | FP00414_Formation_Tray_4Model.cs:209 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00414_Formation_Tray_4Model.GetSite

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-655f524a | this.Load 외 1 | FP00414_Formation_Tray_4Model.cs:198 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-c8bbfe8b | this.Load 외 1 | FP00414_Formation_Tray_4Model.cs:198 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2411b3d6 | this.Load 외 1 | FP00414_Formation_Tray_4Model.cs:200 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00414_Formation_Tray_4Model.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6c501c8 | this.Load | FP00414_Formation_Tray_4Model.cs:142 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea71531c | this.Load | FP00414_Formation_Tray_4Model.cs:145 |  | FLAG | dtYesNo | Data_FP.Common_FP(Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 화면 필드/플래그 변경 |  |  |  |
| AC-a4b707e2 | this.Load | FP00414_Formation_Tray_4Model.cs:145 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00414_Formation_Tray_4Model.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b4a409c | this.Load | FP00414_Formation_Tray_4Model.cs:179 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-76bad312 | this.Load | FP00414_Formation_Tray_4Model.cs:180 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00414_Formation_Tray_4Model.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bbc663c | this.Load | FP00414_Formation_Tray_4Model.cs:263 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-d8e7487b | this.Load | FP00414_Formation_Tray_4Model.cs:264 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-02855211 | this.Load | FP00414_Formation_Tray_4Model.cs:265 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0b99828e | this.Load | FP00414_Formation_Tray_4Model.cs:266 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, iColumnHeaderCount) | 그리드 재구성/초기화 |  |  |  |

## FP00414_Formation_Tray_4Model.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ae47758 | InsertButton | FP00414_Formation_Tray_4Model.cs:295 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0123d4b2 | InsertButton | FP00414_Formation_Tray_4Model.cs:304 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.LINE_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-bd0238d5 | InsertButton | FP00414_Formation_Tray_4Model.cs:305 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TRAY_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-de5ee222 | InsertButton | FP00414_Formation_Tray_4Model.cs:306 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-fc8bbd87 | InsertButton | FP00414_Formation_Tray_4Model.cs:309 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f6fef5c | InsertButton | FP00414_Formation_Tray_4Model.cs:310 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.EDIT_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae81e182 | InsertButton | FP00414_Formation_Tray_4Model.cs:312 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-d5ec2c63 | InsertButton | FP00414_Formation_Tray_4Model.cs:315 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, 1, max, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb2a4000 | InsertButton | FP00414_Formation_Tray_4Model.cs:317 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.LINE_ID), iRow, siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-899f48ff | InsertButton | FP00414_Formation_Tray_4Model.cs:318 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.TRAY_ID), iRow, siMain.GetColumnIndex(DefColumns.T… | 그리드 편집 잠금/해제 |  |  |  |
| AC-97b69264 | InsertButton | FP00414_Formation_Tray_4Model.cs:319 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), iRow, siMain.GetColumnIndex(DefColumns.I… | 그리드 편집 잠금/해제 |  |  |  |
| AC-edb47ed6 | InsertButton | FP00414_Formation_Tray_4Model.cs:320 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |

## FP00414_Formation_Tray_4Model.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33997d4b | popSql.OnSql | FP00414_Formation_Tray_4Model.cs:812 | if (programID == "PR_UI_FP00414_FIND_FP00414") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-d2137e1a | popSql.OnSql | FP00414_Formation_Tray_4Model.cs:815 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00414_Formation_Tray_4Model.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3935e82e | SaveButton | FP00414_Formation_Tray_4Model.cs:331 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61300a43 | SaveButton | FP00414_Formation_Tray_4Model.cs:333 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04d40931 | SaveButton | FP00414_Formation_Tray_4Model.cs:338 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd6c1b13 | SaveButton | FP00414_Formation_Tray_4Model.cs:339 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-749cc43a | SaveButton | FP00414_Formation_Tray_4Model.cs:343 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-95af10f7 | SaveButton | FP00414_Formation_Tray_4Model.cs:347 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c0485101 | SaveButton | FP00414_Formation_Tray_4Model.cs:352 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-105b94ea | SaveButton | FP00414_Formation_Tray_4Model.cs:354 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c29df9f9 | SaveButton | FP00414_Formation_Tray_4Model.cs:355 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b448c655 | SaveButton | FP00414_Formation_Tray_4Model.cs:375 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: | CALL_EXT | siMain.GetValue2 | (i, plant_col_pos) | ⚠ 의미 확인 필요 |  |  |  |
| AC-37b21a54 | SaveButton | FP00414_Formation_Tray_4Model.cs:376 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: | CALL_EXT | siMain.GetValue2 | (i, pseudo_factory_col_pos) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bcd27216 | SaveButton | FP00414_Formation_Tray_4Model.cs:377 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: | CALL_EXT | siMain.GetValue2 | (i, line_col_pos) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ae5fbce | SaveButton | FP00414_Formation_Tray_4Model.cs:378 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: | CALL_EXT | siMain.GetValue2 | (i, tray_col_pos) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd9e1b1e | SaveButton | FP00414_Formation_Tray_4Model.cs:379 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: | CALL_EXT | siMain.GetValue2 | (i, item_col_pos) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bdf264d5 | SaveButton | FP00414_Formation_Tray_4Model.cs:384 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: ▸ for (j… | CALL_EXT | siMain.GetValue2 | (j, plant_col_pos) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e40865e6 | SaveButton | FP00414_Formation_Tray_4Model.cs:385 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: ▸ for (j… | CALL_EXT | siMain.GetValue2 | (j, pseudo_factory_col_pos) | ⚠ 의미 확인 필요 |  |  |  |
| AC-453b694d | SaveButton | FP00414_Formation_Tray_4Model.cs:386 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: ▸ for (j… | CALL_EXT | siMain.GetValue2 | (j, line_col_pos) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2cd37d54 | SaveButton | FP00414_Formation_Tray_4Model.cs:387 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: ▸ for (j… | CALL_EXT | siMain.GetValue2 | (j, tray_col_pos) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6631214f | SaveButton | FP00414_Formation_Tray_4Model.cs:388 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: ▸ for (j… | CALL_EXT | siMain.GetValue2 | (j, item_col_pos) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c5f12f5e | SaveButton | FP00414_Formation_Tray_4Model.cs:393 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: ▸ for (j… | MESSAGE | MessageBox.Show | ("Duplicate data exists.") | 메시지 표시 |  |  |  |
| AC-582ba3d3 | SaveButton | FP00414_Formation_Tray_4Model.cs:394 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: ▸ for (j… | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-160f645d | SaveButton | FP00414_Formation_Tray_4Model.cs:395 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: ▸ for (j… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7767e85 | SaveButton | FP00414_Formation_Tray_4Model.cs:405 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e4e2b4d0 | SaveButton | FP00414_Formation_Tray_4Model.cs:410 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-22e7903f | SaveButton | FP00414_Formation_Tray_4Model.cs:419 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1a92e149 | SaveButton | FP00414_Formation_Tray_4Model.cs:423 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-39c772a2 | SaveButton | FP00414_Formation_Tray_4Model.cs:427 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-994f6fb6 | SaveButton | FP00414_Formation_Tray_4Model.cs:428 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-caef1324 | SaveButton | FP00414_Formation_Tray_4Model.cs:432 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1d054807 | SaveButton | FP00414_Formation_Tray_4Model.cs:433 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP00414_Formation_Tray_4Model.Save_Data_Line

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b22df7b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:467 | try | DATA_OP | dsSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-39e7ec94 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:470 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0f9ab2ac | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:477 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | dsSave.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-049deb62 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:478 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | dsSave.Tables[0].Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-80a1b323 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:492 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | bindingRow["DIVISION_ID"] | siMain.ActiveSheet.Cells[i, div_col_pos].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-609a0454 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:493 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | bindingRow["SITE_ID"] | siMain.ActiveSheet.Cells[i, site_col_pos].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1902ca6a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:494 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | bindingRow["PLANT_ID"] | siMain.ActiveSheet.Cells[i, plant_col_pos].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-679f6864 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:495 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | bindingRow["PSEUDO_FACTORY_ID"] | siMain.ActiveSheet.Cells[i, pseudo_factory_col_pos].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-efa43253 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:496 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | bindingRow["FACTORY_ID"] | siMain.ActiveSheet.Cells[i, factory_col_pos].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b7326c9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:497 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | bindingRow["LINE_ID"] | siMain.ActiveSheet.Cells[i, line_col_pos].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-35bd5bec | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:498 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | bindingRow["TRAY_ID"] | siMain.ActiveSheet.Cells[i, tray_col_pos].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc4c7e61 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:499 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | bindingRow["ITEM_ID"] | siMain.ActiveSheet.Cells[i, item_col_pos].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8549c2ae | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:500 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: | DATA_OP | bindingRow["ACTIVE_FLAG"] | siMain.ActiveSheet.Cells[i, active_col_pos].Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3e38439d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:503 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: ▸ if (bindingRow.RowState !=… | CALL_EXT | bindingRow.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a10b6caa | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:507 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagM: ▸ if (bindingRow.RowState != DataRowState.Modified) | CALL_EXT | bindingRow.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2503244 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:511 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagD: ▸ if (bindingRow.RowState != DataRowState.Deleted) | DATA_OP | bindingRow.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-12a1e9fa | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:521 | try | CALL_EXT | dsSave.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8705bf5f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:525 | try ▸ if (iCount > 0) | ENDPOINT | DataService.FP_UpdateBatch | ("FP00414_FormationTrayModel", "update_FP00414", dsSave, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_FP00414] \| FP\MASTER\FP0… | 엔드포인트 호출 |  |  |  |
| AC-542124ca | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:528 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-201f915b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:530 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | DATA_OP | set.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa086f1f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:531 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-87738097 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:533 | try ▸ if (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-62757cc6 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:537 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-aa2f1e2e | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:543 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-3dd7ad70 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00414_Formation_Tray_4Model.cs:544 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00414_Formation_Tray_4Model.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-707f264c | SaveButton | FP00414_Formation_Tray_4Model.cs:280 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00414_Formation_Tray_4Model.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59baaaee | this.Load | FP00414_Formation_Tray_4Model.cs:161 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-1c00a458 | this.Load | FP00414_Formation_Tray_4Model.cs:165 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-711f12bb | this.Load | FP00414_Formation_Tray_4Model.cs:169 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-f0f27e70 | this.Load | FP00414_Formation_Tray_4Model.cs:171 |  | VALUE_SET | radioActiveAll.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-90163b5c | this.Load | FP00414_Formation_Tray_4Model.cs:172 |  | DATA_OP | Filter["ACTIVE"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00414_Formation_Tray_4Model.SetEditMode

진입점: FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / EditButton [if (spdMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddcb8cfb | FindButton [try] 외 2 | FP00414_Formation_Tray_4Model.cs:596 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bdaf0bcd | FindButton [try] 외 2 | FP00414_Formation_Tray_4Model.cs:599 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-946924e4 | FindButton [try] 외 2 | FP00414_Formation_Tray_4Model.cs:605 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex() - 1, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00414_Formation_Tray_4Model.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b0411dc | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:999 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5be5e230 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1001 | try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf57f232 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1018 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColum… | POPUP | new FP00414_LineAddPop | ("LINE_ADD", sSite, "", true) | 팝업/폼 생성 |  |  |  |
| AC-7fd0bdd9 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1019 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColum… | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-362259c1 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1020 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColum… | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cbd6c7cd | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1034 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColum… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-dc413560 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1035 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColum… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID), sSite) | 그리드 값 설정 |  |  |  |
| AC-78fc366b | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1036 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColum… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), sPlant) | 그리드 값 설정 |  |  |  |
| AC-cdc28b32 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1037 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColum… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PSEUDO_FACTORY_ID), sPseudoFactory) | 그리드 값 설정 |  |  |  |
| AC-9cc042b5 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1038 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColum… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID), sFactory) | 그리드 값 설정 |  |  |  |
| AC-7646db88 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1039 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColum… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_ID), sLine) | 그리드 값 설정 |  |  |  |
| AC-467b32d6 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1042 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColum… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TRAY_ID), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-4e95164c | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1043 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColum… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-6333c177 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1044 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColum… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-7bb92287 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1053 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | MESSAGE | MessageBox.Show | ("Please enter [Line] first.") | 메시지 표시 |  |  |  |
| AC-900f36c7 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1054 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f36f4859 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1064 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | POPUP | new FP00414_TrayAddPop | ("TRAY_ADD", sDivision, sSite, sPlant, sFactory, true) | 팝업/폼 생성 |  |  |  |
| AC-c6ef9353 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1065 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | UI_PROP | popRtn.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3fe1a46f | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1066 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | POPUP | popRtn.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2d58bf63 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1072 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TRAY_ID), sTray) | 그리드 값 설정 |  |  |  |
| AC-0ec0dae8 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1086 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | MESSAGE | MessageBox.Show | ("Please enter [Line] first.") | 메시지 표시 |  |  |  |
| AC-0974e69b | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1087 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-108f2995 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1096 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | DATA_OP | searchParam.Add | ("DIVISION_ID", siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToSt… | 데이터 객체 조작/조회 |  |  |  |
| AC-8064cf0d | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1097 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | DATA_OP | searchParam.Add | ("SITE_ID", siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b861b4f8 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1101 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | POPUP | new FP00414_ItemAddPopup | (bFilterEnable, bMultiSelect, searchParam) | 팝업/폼 생성 |  |  |  |
| AC-8260f58b | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1102 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bc694d94 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1103 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ffc54f73 | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1116 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemID) | 그리드 값 설정 |  |  |  |
| AC-b7b28abf | this.spdMain.CellClick | FP00414_Formation_Tray_4Model.cs:1117 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ else of (e.Column == siMain.Get… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |

## FP00414_Formation_Tray_4Model.SwitchEdit

진입점: EditButton [if (spdMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-001e101e | EditButton [if (spdMain != null)] | FP00414_Formation_Tray_4Model.cs:583 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## FP00414_ItemAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b57023a | .ctor | FP00414_ItemAddPopup.cs:124 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-443135b0 | .ctor | FP00414_ItemAddPopup.cs:125 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7a1ed30d | .ctor | FP00414_ItemAddPopup.cs:126 |  | FLAG | this.sDivisionId | "ALL" | 화면 필드/플래그 변경 |  |  |  |
| AC-f3aedb7d | .ctor | FP00414_ItemAddPopup.cs:134 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-0469b8d2 | .ctor | FP00414_ItemAddPopup.cs:135 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-1c8da5c7 | .ctor | FP00414_ItemAddPopup.cs:137 |  | CALL_EXT | searchParam.TryGetValue | ("COMPANY_ID", out this.sCompanyId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8add432a | .ctor | FP00414_ItemAddPopup.cs:138 |  | CALL_EXT | searchParam.TryGetValue | ("DIVISION_ID", out this.sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-15908260 | .ctor | FP00414_ItemAddPopup.cs:139 |  | CALL_EXT | searchParam.TryGetValue | ("SITE_ID", out sSiteId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c56b0d5e | .ctor | FP00414_ItemAddPopup.cs:140 |  | CALL_EXT | searchParam.TryGetValue | ("LEVEL_2_CODE", out sLevel2Code) | ⚠ 의미 확인 필요 |  |  |  |
| AC-02217995 | .ctor | FP00414_ItemAddPopup.cs:141 |  | CALL_EXT | searchParam.TryGetValue | ("LEVEL_2_CODE_FLAG", out sLevel2CodeFlag) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b71ddc69 | .ctor | FP00414_ItemAddPopup.cs:142 |  | CALL_EXT | searchParam.TryGetValue | ("IS_FORMATION_FLOW_ID_EXISTS", out sIsFormationFlowIdExists) | ⚠ 의미 확인 필요 |  |  |  |

## FP00414_ItemAddPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0a632ea | this.btnButtonList.UsrButtonList_Click_Detected | FP00414_ItemAddPopup.cs:395 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-96fe0e16 | this.btnButtonList.UsrButtonList_Click_Detected | FP00414_ItemAddPopup.cs:398 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00414_ItemAddPopup.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29366314 | this.clbDivision.SelectedIndexChanged | FP00414_ItemAddPopup.cs:375 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-ba1e51a8 | this.clbDivision.SelectedIndexChanged | FP00414_ItemAddPopup.cs:375 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b3a0f097 | this.clbDivision.SelectedIndexChanged | FP00414_ItemAddPopup.cs:376 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00414_ItemAddPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dad8d975 | this.Load | FP00414_ItemAddPopup.cs:223 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-87303531 | this.Load | FP00414_ItemAddPopup.cs:224 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d6fb0b4 | this.Load | FP00414_ItemAddPopup.cs:225 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00414_ItemAddPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4314f667 | this.Load | FP00414_ItemAddPopup.cs:213 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00414_ItemAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1b706a6 | Dispose | FP00414_ItemAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00414_ItemAddPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43a1908b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:289 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-779d020d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:290 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8b2c0c4d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:293 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0e746f53 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:295 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Common.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-496e65eb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:299 | lambda | ENDPOINT | new FoxDataRequest | ("FP_Common.PR_UI_COMMON_POPUP") ⇒ FP_Common.PR_UI_COMMON_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-ff76cc77 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:301 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-eccc462d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:303 | lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-d5c573bf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:304 | lambda | DATA_OP | request.Parameters["p_sys_flag"] | "ITEM_POPUP_FP00414" | 행/컬럼 값 대입 |  |  |  |
| AC-3c6edbcb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:305 | lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5807a9dc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:306 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-907f58d5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:307 | lambda | DATA_OP | request.Parameters["p_non_auth"] | _sNonAuth | 행/컬럼 값 대입 |  |  |  |
| AC-93242268 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:308 | lambda | DATA_OP | request.Parameters["p_save_auth"] | _sSaveAuth | 행/컬럼 값 대입 |  |  |  |
| AC-4a2a5c4b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:310 | lambda | DATA_OP | request.Parameters["p_param1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2568a08a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:311 | lambda | DATA_OP | request.Parameters["p_param2"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-a2cb9826 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:312 | lambda | DATA_OP | request.Parameters["p_param3"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-21d5fa82 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:313 | lambda | DATA_OP | request.Parameters["p_param4"] | pItemID.Equals("ALL") ? DBNull.Value : pItemID | 행/컬럼 값 대입 |  |  |  |
| AC-d3b51674 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:314 | lambda | DATA_OP | request.Parameters["p_param5"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-c9fcb0ef | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:315 | lambda | DATA_OP | request.Parameters["p_param6"] | (string.IsNullOrEmpty(sLevel2CodeFlag)) ? DBNull.Value : sLevel2CodeFlag as object | 행/컬럼 값 대입 |  |  |  |
| AC-81832ed9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:316 | lambda | DATA_OP | request.Parameters["p_param7"] | (string.IsNullOrEmpty(sLevel2Code)) ? DBNull.Value : sLevel2Code as object | 행/컬럼 값 대입 |  |  |  |
| AC-25b2282a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:317 | lambda | DATA_OP | request.Parameters["p_param8"] | (string.IsNullOrEmpty(sIsFormationFlowIdExists)) ? DBNull.Value : sIsFormationFlowIdExists… | 행/컬럼 값 대입 |  |  |  |
| AC-e657562f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:318 | lambda | DATA_OP | request.Parameters["p_param9"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-af0562b8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:319 | lambda | DATA_OP | request.Parameters["p_param10"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3f6b4b9e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:321 | lambda | DATA_OP | request.Parameters["p_param11"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-dd2f692a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:322 | lambda | DATA_OP | request.Parameters["p_param12"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-985dce51 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:323 | lambda | DATA_OP | request.Parameters["p_param13"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1246dd56 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:324 | lambda | DATA_OP | request.Parameters["p_param14"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c8d1d331 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:325 | lambda | DATA_OP | request.Parameters["p_param15"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-86035025 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:326 | lambda | DATA_OP | request.Parameters["p_param16"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7ece72f2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:327 | lambda | DATA_OP | request.Parameters["p_param17"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-530cbd7e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:328 | lambda | DATA_OP | request.Parameters["p_param18"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c778af46 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:329 | lambda | DATA_OP | request.Parameters["p_param19"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-563c8a56 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:330 | lambda | DATA_OP | request.Parameters["p_param20"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-aeea3d0f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:331 | lambda | DATA_OP | request.Parameters["TimeZone"] | TimeZone | 행/컬럼 값 대입 |  |  |  |
| AC-23cbe84e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:333 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-90e9140d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:335 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4d04c258 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:340 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d9b9deb3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:344 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-e977247b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00414_ItemAddPopup.cs:350 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00414_ItemAddPopup.fn_setRowInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c6e78ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_ItemAddPopup.cs:435 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c37b62db | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_ItemAddPopup.cs:436 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1ae6385 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_ItemAddPopup.cs:438 |  | FLAG | _CompanyId | this.dtFindData.Rows[iClick_Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cbc7d9c3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_ItemAddPopup.cs:439 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-af93a6f7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_ItemAddPopup.cs:440 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-558e6800 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_ItemAddPopup.cs:441 |  | FLAG | _ItemId | this.dtFindData.Rows[iClick_Row][DefColumns.ITEM_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b1a2948c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_ItemAddPopup.cs:442 |  | FLAG | _NickName | this.dtFindData.Rows[iClick_Row][DefColumns.NICK_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-88997328 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_ItemAddPopup.cs:445 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00414_ItemAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11468e3c | this.Load | FP00414_ItemAddPopup.cs:153 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-06afd05a | this.Load | FP00414_ItemAddPopup.cs:155 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00414_ItemAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63997234 | this.Load | FP00414_ItemAddPopup.cs:179 | if (sDivisionId == "ALL") | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-41dfd04c | this.Load | FP00414_ItemAddPopup.cs:179 | if (sDivisionId == "ALL") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-81923766 | this.Load | FP00414_ItemAddPopup.cs:183 | else of (sDivisionId == "ALL") | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-e04f515e | this.Load | FP00414_ItemAddPopup.cs:183 | else of (sDivisionId == "ALL") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth,"",""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e1eb5dd2 | this.Load | FP00414_ItemAddPopup.cs:185 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a68979d6 | this.Load | FP00414_ItemAddPopup.cs:186 |  | VALUE_SET | clbDivision.ControlValues | sDivisionId | 컨트롤 값 설정 |  |  |  |
| AC-0e8fa0b1 | this.Load | FP00414_ItemAddPopup.cs:194 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-60cddcd8 | this.Load | FP00414_ItemAddPopup.cs:194 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40a2d368 | this.Load | FP00414_ItemAddPopup.cs:195 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-92dcfa1a | this.Load | FP00414_ItemAddPopup.cs:196 |  | VALUE_SET | cboSite.ControlValues | sSiteId | 컨트롤 값 설정 |  |  |  |
| AC-589aefa7 | this.Load | FP00414_ItemAddPopup.cs:200 | if (bCtlEnable == true) | STATE | clbDivision.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6c2eb48b | this.Load | FP00414_ItemAddPopup.cs:201 | if (bCtlEnable == true) | STATE | cboSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2c4ec9ff | this.Load | FP00414_ItemAddPopup.cs:205 | else of (bCtlEnable == true) | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-53862f73 | this.Load | FP00414_ItemAddPopup.cs:206 | else of (bCtlEnable == true) | STATE | cboSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00414_ItemAddPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d867b77d | this.Load | FP00414_ItemAddPopup.cs:232 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b4dc2092 | this.Load | FP00414_ItemAddPopup.cs:234 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00414_ItemAddPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ec26e0f | this.spdMain.CellClick | FP00414_ItemAddPopup.cs:409 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00414_ItemAddPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec89d583 | this.spdMain.CellDoubleClick | FP00414_ItemAddPopup.cs:414 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-e04b434e | this.spdMain.CellDoubleClick | FP00414_ItemAddPopup.cs:416 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a7b81c9 | this.spdMain.CellDoubleClick | FP00414_ItemAddPopup.cs:418 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-70fd7b3c | this.spdMain.CellDoubleClick | FP00414_ItemAddPopup.cs:419 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5cd10a7a | this.spdMain.CellDoubleClick | FP00414_ItemAddPopup.cs:420 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e7fcca6b | this.spdMain.CellDoubleClick | FP00414_ItemAddPopup.cs:421 |  | FLAG | _ItemId | this.dtFindData.Rows[e.Row][DefColumns.ITEM_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9cf96306 | this.spdMain.CellDoubleClick | FP00414_ItemAddPopup.cs:422 |  | FLAG | _NickName | this.dtFindData.Rows[e.Row][DefColumns.NICK_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-967b7496 | this.spdMain.CellDoubleClick | FP00414_ItemAddPopup.cs:425 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00414_LineAddPop..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c82a2742 | .ctor | FP00414_LineAddPop.cs:157 |  | FLAG | this.sSite | pSite | 화면 필드/플래그 변경 |  |  |  |
| AC-5e192f59 | .ctor | FP00414_LineAddPop.cs:158 |  | FLAG | this.sNoFactory | pNoFactory | 화면 필드/플래그 변경 |  |  |  |
| AC-63d31c0f | .ctor | FP00414_LineAddPop.cs:159 |  | FLAG | this.bFactoryVisibility | bFactoryDisplay | 화면 필드/플래그 변경 |  |  |  |
| AC-d3548615 | .ctor | FP00414_LineAddPop.cs:161 |  | UI_PROP | SpdSheet.shtMain | pSheetName | 속성 shtMain 설정 |  |  |  |
| AC-83aaf089 | .ctor | FP00414_LineAddPop.cs:163 |  | FLAG | sSysFlag | "LINE_ADD" | 화면 필드/플래그 변경 |  |  |  |

## FP00414_LineAddPop.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-367fe7d8 | this.btnButtonList.UsrButtonList_Click_Detected | FP00414_LineAddPop.cs:537 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-9594eac5 | this.btnButtonList.UsrButtonList_Click_Detected | FP00414_LineAddPop.cs:540 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00414_LineAddPop.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4aaf9705 | cboSite.SelectedIndexChanged | FP00414_LineAddPop.cs:515 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-6081be88 | cboSite.SelectedIndexChanged | FP00414_LineAddPop.cs:520 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-09c763f2 | cboSite.SelectedIndexChanged | FP00414_LineAddPop.cs:524 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-2c6c7e8d | cboSite.SelectedIndexChanged | FP00414_LineAddPop.cs:524 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-16da2aed | cboSite.SelectedIndexChanged | FP00414_LineAddPop.cs:525 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, cboPlant, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00414_LineAddPop.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74b88fd4 | clbDivision.SelectedIndexChanged | FP00414_LineAddPop.cs:489 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-08112c12 | clbDivision.SelectedIndexChanged | FP00414_LineAddPop.cs:492 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-36b58cb1 | clbDivision.SelectedIndexChanged | FP00414_LineAddPop.cs:492 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a0e0b6f8 | clbDivision.SelectedIndexChanged | FP00414_LineAddPop.cs:493 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-336a21c9 | clbDivision.SelectedIndexChanged | FP00414_LineAddPop.cs:497 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-7f359ed0 | clbDivision.SelectedIndexChanged | FP00414_LineAddPop.cs:500 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-a6f958c0 | clbDivision.SelectedIndexChanged | FP00414_LineAddPop.cs:500 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ef0a84c6 | clbDivision.SelectedIndexChanged | FP00414_LineAddPop.cs:501 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, cboPlant, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00414_LineAddPop.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c33d928f | this.Load | FP00414_LineAddPop.cs:276 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a62d1a72 | this.Load | FP00414_LineAddPop.cs:277 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c39ea4d1 | this.Load | FP00414_LineAddPop.cs:278 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00414_LineAddPop.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfec33c4 | this.Load | FP00414_LineAddPop.cs:248 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00414_LineAddPop.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d04c124f | Dispose | FP00414_LineAddPop.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00414_LineAddPop.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8db8f450 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:343 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pDivisionID = CString.GetCheckedListValue(dtMyDivision, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2cc8a38f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:352 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00414_ADD_POP") ⇒ FP_Master.PR_UI_FP00414_ADD_POP | 엔드포인트 요청 생성 |  |  |  |
| AC-e129d28b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:355 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-93571e75 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:357 | try | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-a5479269 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:358 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFalg | 행/컬럼 값 대입 |  |  |  |
| AC-32f5addb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:359 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-08639020 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:360 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2e1ffb6c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:362 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0baa3778 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:363 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-afcea381 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:364 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-8f9d1897 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:365 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-dc70d97c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:367 | try | DATA_OP | request.Parameters["p_param_1"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3777fcfa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:368 | try | DATA_OP | request.Parameters["p_param_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ed477dbf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:369 | try | DATA_OP | request.Parameters["p_param_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d0fc07b3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:370 | try | DATA_OP | request.Parameters["p_param_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b430ef02 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:371 | try | DATA_OP | request.Parameters["p_param_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-14f1e88d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:373 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f476ddc4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:382 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fad1c812 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:385 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9814ac77 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_LineAddPop.cs:390 | try | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## FP00414_LineAddPop.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db4b1abf | this.Load | FP00414_LineAddPop.cs:178 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-04ec2df8 | this.Load | FP00414_LineAddPop.cs:180 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00414_LineAddPop.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa143722 | this.Load | FP00414_LineAddPop.cs:209 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-0e103619 | this.Load | FP00414_LineAddPop.cs:211 | if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-5779a16b | this.Load | FP00414_LineAddPop.cs:214 |  | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-f7e2a4d6 | this.Load | FP00414_LineAddPop.cs:214 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b83ea4df | this.Load | FP00414_LineAddPop.cs:215 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-5c6d7cbd | this.Load | FP00414_LineAddPop.cs:218 | if (!string.IsNullOrEmpty(sDivision)) | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-3521fb4c | this.Load | FP00414_LineAddPop.cs:222 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-3505dbd2 | this.Load | FP00414_LineAddPop.cs:225 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-700c3f9f | this.Load | FP00414_LineAddPop.cs:225 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1c5e96cf | this.Load | FP00414_LineAddPop.cs:226 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-45aa03f5 | this.Load | FP00414_LineAddPop.cs:229 | if (!string.IsNullOrEmpty(sSite)) | VALUE_SET | cboSite.ControlValues | sSite | 컨트롤 값 설정 |  |  |  |
| AC-0fdf23e2 | this.Load | FP00414_LineAddPop.cs:233 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-4412c3b3 | this.Load | FP00414_LineAddPop.cs:237 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-54cf21a8 | this.Load | FP00414_LineAddPop.cs:237 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4a6e0b7b | this.Load | FP00414_LineAddPop.cs:238 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, cboPlant, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3456ad8c | this.Load | FP00414_LineAddPop.cs:242 | if (this.bFactoryVisibility==false) | UI_PROP | lblFactory.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00414_LineAddPop.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46955248 | this.Load | FP00414_LineAddPop.cs:253 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00414_LineAddPop.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2338724c | this.Load | FP00414_LineAddPop.cs:288 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f8831ac | this.Load | FP00414_LineAddPop.cs:289 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00414_LineAddPop.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16ea8582 | (진입점 미연결) | FP00414_LineAddPop.cs:321 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00414_LineAddPop.SetOperationInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1dfea44 | (진입점 미연결) | FP00414_LineAddPop.cs:583 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c2a9d0a | (진입점 미연결) | FP00414_LineAddPop.cs:584 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a105041 | (진입점 미연결) | FP00414_LineAddPop.cs:586 |  | FLAG | _CompanyId | this.dtFindData.Rows[iClick_Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cfb49dbc | (진입점 미연결) | FP00414_LineAddPop.cs:587 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a75d7efa | (진입점 미연결) | FP00414_LineAddPop.cs:588 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5f6f9c12 | (진입점 미연결) | FP00414_LineAddPop.cs:589 |  | FLAG | _PlantId | this.dtFindData.Rows[iClick_Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fa0b0f57 | (진입점 미연결) | FP00414_LineAddPop.cs:590 |  | FLAG | _PseudoFactoryId | this.dtFindData.Rows[iClick_Row][DefColumns.PSEUDO_FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-98f6bb21 | (진입점 미연결) | FP00414_LineAddPop.cs:591 |  | FLAG | _FactoryId | this.dtFindData.Rows[iClick_Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c24b9aeb | (진입점 미연결) | FP00414_LineAddPop.cs:596 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00414_LineAddPop.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12e2b570 | this.Load | FP00414_LineAddPop.cs:298 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-3ead44ac | this.Load | FP00414_LineAddPop.cs:300 |  | GRID_INIT | siMain.AddTextColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.Gen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-52d0b2c7 | this.Load | FP00414_LineAddPop.cs:301 |  | GRID_INIT | siMain.AddTextColumn | ("Site", DefColumns.SITE_ID, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.General) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ce537c4e | this.Load | FP00414_LineAddPop.cs:302 |  | GRID_INIT | siMain.AddTextColumn | ("Plant", DefColumns.PLANT_ID, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.General) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e1f05f3f | this.Load | FP00414_LineAddPop.cs:303 |  | GRID_INIT | siMain.AddTextColumn | ("Virtual Building", DefColumns.PSEUDO_FACTORY_ID, FPMerge.None, 100, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e2b9258 | this.Load | FP00414_LineAddPop.cs:304 |  | GRID_INIT | siMain.AddTextColumn | ("Building", DefColumns.FACTORY_ID, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.Gene… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a579e615 | this.Load | FP00414_LineAddPop.cs:305 |  | GRID_INIT | siMain.AddTextColumn | ("Line", DefColumns.LINE_ID, FPMerge.None, 100, true, FPHAlign.Left, FPVAlign.General) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a91ccee | this.Load | FP00414_LineAddPop.cs:306 |  | GRID_INIT | siMain.AddTextColumn | ("Line Name", DefColumns.LINE_NAME, FPMerge.None, 200, true, FPHAlign.Left, FPVAlign.Gener… | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00414_LineAddPop.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1264889f | this.spdMain.CellClick | FP00414_LineAddPop.cs:551 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00414_LineAddPop.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aab4603c | this.spdMain.CellDoubleClick | FP00414_LineAddPop.cs:556 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-4b3d6331 | this.spdMain.CellDoubleClick | FP00414_LineAddPop.cs:558 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad855369 | this.spdMain.CellDoubleClick | FP00414_LineAddPop.cs:560 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0030bb8b | this.spdMain.CellDoubleClick | FP00414_LineAddPop.cs:561 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2ae1d391 | this.spdMain.CellDoubleClick | FP00414_LineAddPop.cs:562 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0e7a4b4a | this.spdMain.CellDoubleClick | FP00414_LineAddPop.cs:563 |  | FLAG | _PlantId | this.dtFindData.Rows[e.Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9c7adc91 | this.spdMain.CellDoubleClick | FP00414_LineAddPop.cs:564 |  | FLAG | _PseudoFactoryId | this.dtFindData.Rows[e.Row][DefColumns.PSEUDO_FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a0126b76 | this.spdMain.CellDoubleClick | FP00414_LineAddPop.cs:565 |  | FLAG | _FactoryId | this.dtFindData.Rows[e.Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3d167762 | this.spdMain.CellDoubleClick | FP00414_LineAddPop.cs:566 |  | FLAG | _LineId | this.dtFindData.Rows[e.Row][DefColumns.LINE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c2d79206 | this.spdMain.CellDoubleClick | FP00414_LineAddPop.cs:567 |  | FLAG | _LineName | this.dtFindData.Rows[e.Row][DefColumns.LINE_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-57088eea | this.spdMain.CellDoubleClick | FP00414_LineAddPop.cs:572 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00414_TrayAddPop..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04b0b57b | .ctor | FP00414_TrayAddPop.cs:169 |  | FLAG | this.sDivision | pDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-b64a3436 | .ctor | FP00414_TrayAddPop.cs:170 |  | FLAG | this.sSite | pSite | 화면 필드/플래그 변경 |  |  |  |
| AC-d2f1eee6 | .ctor | FP00414_TrayAddPop.cs:171 |  | FLAG | this.sPlant | pPlant | 화면 필드/플래그 변경 |  |  |  |
| AC-5e475a5b | .ctor | FP00414_TrayAddPop.cs:172 |  | FLAG | this.sPseudoFactory | pFactory | 화면 필드/플래그 변경 |  |  |  |
| AC-f438e296 | .ctor | FP00414_TrayAddPop.cs:175 |  | FLAG | this.bFactoryVisibility | bFactoryDisplay | 화면 필드/플래그 변경 |  |  |  |
| AC-c9e8f694 | .ctor | FP00414_TrayAddPop.cs:177 |  | UI_PROP | SpdSheet.shtMain | pSheetName | 속성 shtMain 설정 |  |  |  |
| AC-5a30dadd | .ctor | FP00414_TrayAddPop.cs:179 |  | FLAG | sSysFlag | "TRAY_ADD" | 화면 필드/플래그 변경 |  |  |  |

## FP00414_TrayAddPop.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e85e242a | this.btnButtonList.UsrButtonList_Click_Detected | FP00414_TrayAddPop.cs:560 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-52121658 | this.btnButtonList.UsrButtonList_Click_Detected | FP00414_TrayAddPop.cs:563 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00414_TrayAddPop.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9c4739c | this.Load | FP00414_TrayAddPop.cs:293 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b700d5cc | this.Load | FP00414_TrayAddPop.cs:294 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-59fe9a32 | this.Load | FP00414_TrayAddPop.cs:295 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00414_TrayAddPop.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a13a005c | this.Load | FP00414_TrayAddPop.cs:272 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00414_TrayAddPop.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44b3c426 | Dispose | FP00414_TrayAddPop.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00414_TrayAddPop.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2a8f87b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:361 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pDivisionID = txtDivision.Text.Trim(); pSiteID = txtSite.… | ⚠ 의미 확인 필요 |  |  |  |
| AC-43bc7864 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:371 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00414_ADD_POP") ⇒ FP_Master.PR_UI_FP00414_ADD_POP | 엔드포인트 요청 생성 |  |  |  |
| AC-d8974bd7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:374 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e80f6fd6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:376 | try | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-1d091429 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:377 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFalg | 행/컬럼 값 대입 |  |  |  |
| AC-535ede37 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:378 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5a2932e4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:379 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6be5612a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:381 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-10b07693 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:382 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-5c779c0b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:383 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-1c435533 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:384 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-0e05214c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:386 | try | DATA_OP | request.Parameters["p_param_1"] | pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-fd240e8c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:387 | try | DATA_OP | request.Parameters["p_param_2"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6d553992 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:388 | try | DATA_OP | request.Parameters["p_param_3"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7c6bde88 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:389 | try | DATA_OP | request.Parameters["p_param_4"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-47a6048a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:390 | try | DATA_OP | request.Parameters["p_param_5"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7e5b23eb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:392 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9874a255 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:401 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-14efca89 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:404 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a6f94bdb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00414_TrayAddPop.cs:409 | try | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## FP00414_TrayAddPop.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9f8b3a7 | this.Load | FP00414_TrayAddPop.cs:194 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4a0d4ae | this.Load | FP00414_TrayAddPop.cs:196 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b6d0bbac | this.Load | FP00414_TrayAddPop.cs:209 |  | VALUE_SET | txtDivision.Text | this.sDivision | 컨트롤 값 설정 |  |  |  |
| AC-42bdbad3 | this.Load | FP00414_TrayAddPop.cs:210 |  | VALUE_SET | txtSite.Text | this.sSite | 컨트롤 값 설정 |  |  |  |
| AC-899f94b6 | this.Load | FP00414_TrayAddPop.cs:211 |  | VALUE_SET | txtPlant.Text | this.sPlant | 컨트롤 값 설정 |  |  |  |
| AC-954f7d8e | this.Load | FP00414_TrayAddPop.cs:212 |  | VALUE_SET | txtFactory.Text | this.sPseudoFactory | 컨트롤 값 설정 |  |  |  |

## FP00414_TrayAddPop.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8676fad4 | this.Load | FP00414_TrayAddPop.cs:230 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-c496e8a9 | this.Load | FP00414_TrayAddPop.cs:232 | if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |

## FP00414_TrayAddPop.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a957c744 | this.Load | FP00414_TrayAddPop.cs:305 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f30b543 | this.Load | FP00414_TrayAddPop.cs:306 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00414_TrayAddPop.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d47063ec | (진입점 미연결) | FP00414_TrayAddPop.cs:339 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00414_TrayAddPop.SetOperationInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6923ce3 | (진입점 미연결) | FP00414_TrayAddPop.cs:608 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aaaec477 | (진입점 미연결) | FP00414_TrayAddPop.cs:609 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-072fd118 | (진입점 미연결) | FP00414_TrayAddPop.cs:611 |  | FLAG | _CompanyId | this.dtFindData.Rows[iClick_Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4540d637 | (진입점 미연결) | FP00414_TrayAddPop.cs:612 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a5b78992 | (진입점 미연결) | FP00414_TrayAddPop.cs:613 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-eb4f197f | (진입점 미연결) | FP00414_TrayAddPop.cs:614 |  | FLAG | _PlantId | this.dtFindData.Rows[iClick_Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3932c2b0 | (진입점 미연결) | FP00414_TrayAddPop.cs:615 |  | FLAG | _FactoryId | this.dtFindData.Rows[iClick_Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4e872fc1 | (진입점 미연결) | FP00414_TrayAddPop.cs:618 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00414_TrayAddPop.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a172166a | this.Load | FP00414_TrayAddPop.cs:315 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-0905e203 | this.Load | FP00414_TrayAddPop.cs:317 |  | GRID_INIT | siMain.AddTextColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.Gen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-518a4a11 | this.Load | FP00414_TrayAddPop.cs:318 |  | GRID_INIT | siMain.AddTextColumn | ("Site", DefColumns.SITE_ID, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.General) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b83fd035 | this.Load | FP00414_TrayAddPop.cs:319 |  | GRID_INIT | siMain.AddTextColumn | ("Plant", DefColumns.PLANT_ID, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.General) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e2a5faaa | this.Load | FP00414_TrayAddPop.cs:320 |  | GRID_INIT | siMain.AddTextColumn | ("Building", DefColumns.FACTORY_ID, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.Gene… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-227954d5 | this.Load | FP00414_TrayAddPop.cs:321 |  | GRID_INIT | siMain.AddTextColumn | ("Tray ID", DefColumns.TRAY_TYPE_CODE, FPMerge.None, 100, true, FPHAlign.Left, FPVAlign.Ge… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b2d45b2 | this.Load | FP00414_TrayAddPop.cs:322 |  | GRID_INIT | siMain.AddTextColumn | ("Tray Name", DefColumns.TRAY_TYPE_NAME, FPMerge.None, 200, true, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a66acdf0 | this.Load | FP00414_TrayAddPop.cs:323 |  | GRID_INIT | siMain.AddTextColumn | ("Group Tray ID", DefColumns.TRAY_TYPE_GROUP, FPMerge.None, 100, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4393785a | this.Load | FP00414_TrayAddPop.cs:324 |  | GRID_INIT | siMain.AddTextColumn | ("Tray Type", DefColumns.TRAY_TYPE, FPMerge.None, 100, true, FPHAlign.Left, FPVAlign.Gener… | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00414_TrayAddPop.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36e7c309 | this.spdMain.CellClick | FP00414_TrayAddPop.cs:574 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00414_TrayAddPop.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a76ba1de | this.spdMain.CellDoubleClick | FP00414_TrayAddPop.cs:579 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-4b36c453 | this.spdMain.CellDoubleClick | FP00414_TrayAddPop.cs:581 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dae2ac9d | this.spdMain.CellDoubleClick | FP00414_TrayAddPop.cs:583 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0eaba195 | this.spdMain.CellDoubleClick | FP00414_TrayAddPop.cs:584 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-61728a8d | this.spdMain.CellDoubleClick | FP00414_TrayAddPop.cs:585 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-15693f6f | this.spdMain.CellDoubleClick | FP00414_TrayAddPop.cs:586 |  | FLAG | _PlantId | this.dtFindData.Rows[e.Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a786226c | this.spdMain.CellDoubleClick | FP00414_TrayAddPop.cs:588 |  | FLAG | _TrayTypeCode | this.dtFindData.Rows[e.Row][DefColumns.TRAY_TYPE_CODE ].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bbf03bc4 | this.spdMain.CellDoubleClick | FP00414_TrayAddPop.cs:589 |  | FLAG | _TrayTypeName | this.dtFindData.Rows[e.Row][DefColumns.TRAY_TYPE_NAME ].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bfcca92a | this.spdMain.CellDoubleClick | FP00414_TrayAddPop.cs:590 |  | FLAG | _TrayTypeGroup | this.dtFindData.Rows[e.Row][DefColumns.TRAY_TYPE_GROUP ].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9ac7b23a | this.spdMain.CellDoubleClick | FP00414_TrayAddPop.cs:591 |  | FLAG | _TrayType | this.dtFindData.Rows[e.Row][DefColumns.TRAY_TYPE ].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-18336ccb | this.spdMain.CellDoubleClick | FP00414_TrayAddPop.cs:597 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |


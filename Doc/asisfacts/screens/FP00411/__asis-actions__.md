# AS-IS 액션 대조표 — FP00411

> 원천: `Doc/asisfacts/screens/FP00411/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 195행 · 메서드 33 · 종류 DATA_OP 50 · FLAG 23 · UI_PROP 20 · RETURN 19 · LIST_REBIND 13 · CALL_EXT 9 · COMBO_DATA 9 · GRID_SET 8 · ENDPOINT 7 · GRID_INIT 6 · MESSAGE 6 · GRID_STYLE 6 · POPUP 5 · STATE 4 · UI_MISC 4 · VALIDATE 2 · EXCEL 1 · THROW 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 9


## FP00411_FCS_Shorter_Aging_Routing..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3528ab63 | .ctor | FP00411_FCS_Shorter_Aging_Routing.cs:82 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.btnExcel_Click

진입점: this.btnExcel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76b0549d | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:631 |  | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-bc1d1a0a | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:632 |  | UI_PROP | p.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-055c822a | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:632 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ae016d12 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:634 |  | UI_PROP | p.ColumnHeaderCount | 2 | 속성 ColumnHeaderCount 설정 |  |  |  |
| AC-b9b1e65c | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:635 |  | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0ec5f86b | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:636 |  | GRID_SET | p.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-cd6a0b14 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:637 |  | GRID_SET | p.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-861e7d7a | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:638 |  | GRID_SET | p.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-524b5985 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:639 |  | GRID_SET | p.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2342e13e | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:640 |  | GRID_SET | p.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4d202031 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:641 |  | GRID_SET | p.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ad1d17a0 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:642 |  | GRID_SET | p.KeyColumns["SHORTER_LT"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f0b6ff7e | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:644 |  | DATA_OP | p.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-8dd221b1 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:645 |  | DATA_OP | p.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-47cf33a6 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:646 |  | DATA_OP | p.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-cc91256a | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:647 |  | DATA_OP | p.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-589c6d12 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:648 |  | DATA_OP | p.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-d3a01636 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:649 |  | DATA_OP | p.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-5317f608 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:650 |  | DATA_OP | p.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-e306ef21 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:651 |  | DATA_OP | p.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-70ca6f15 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:653 |  | DATA_OP | p.ColumnTitle["BEFORE_DEGAS_ROUTE_ID"] | new Tuple<string, string>("Route", "Before Degas") | 행/컬럼 값 대입 |  |  |  |
| AC-6d04de38 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:654 |  | DATA_OP | p.ColumnTitle["BEFORE_DEGAS_LT"] | new Tuple<string, string>("L/T (min)", "Before Degas") | 행/컬럼 값 대입 |  |  |  |
| AC-62717068 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:655 |  | DATA_OP | p.ColumnTitle["BEFORE_DEGAS_LT_DAY"] | new Tuple<string, string>("L/T (day)", "Before Degas") | 행/컬럼 값 대입 |  |  |  |
| AC-b85219f2 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:656 |  | DATA_OP | p.ColumnTitle["AFTER_DEGAS_ROUTE_ID"] | new Tuple<string, string>("Route", "After Degas") | 행/컬럼 값 대입 |  |  |  |
| AC-72582cbd | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:657 |  | DATA_OP | p.ColumnTitle["AFTER_DEGAS_LT"] | new Tuple<string, string>("L/T (min)", "After Degas") | 행/컬럼 값 대입 |  |  |  |
| AC-77bf269e | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:658 |  | DATA_OP | p.ColumnTitle["AFTER_DEGAS_LT_DAY"] | new Tuple<string, string>("L/T (day)", "After Degas") | 행/컬럼 값 대입 |  |  |  |
| AC-94307c2a | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:660 |  | DATA_OP | p.ColumnTitle["SHORTER_LT"] | "SHorter L/T(day)" | 행/컬럼 값 대입 |  |  |  |
| AC-4b16cc70 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:662 |  | DATA_OP | p.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-d3d0d050 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:665 |  | DATA_OP | p.ColumnWidth["DIVISION_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-3ef4d3f4 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:666 |  | DATA_OP | p.ColumnWidth["SITE_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-15cda556 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:667 |  | DATA_OP | p.ColumnWidth["PLANT_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-872d8388 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:668 |  | DATA_OP | p.ColumnWidth["FACTORY_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-1f5031cb | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:669 |  | DATA_OP | p.ColumnWidth["LINE_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-f2060eaa | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:670 |  | DATA_OP | p.ColumnWidth["ITEM_ID"] | 140 | 행/컬럼 값 대입 |  |  |  |
| AC-b5fb0596 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:671 |  | DATA_OP | p.ColumnWidth["NICK_NAME"] | 110 | 행/컬럼 값 대입 |  |  |  |
| AC-f4b37359 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:672 |  | DATA_OP | p.ColumnWidth["OPERATION_ID"] | 110 | 행/컬럼 값 대입 |  |  |  |
| AC-f42f1188 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:674 |  | DATA_OP | p.ColumnWidth["BEFORE_DEGAS_ROUTE_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-04fb19fe | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:675 |  | DATA_OP | p.ColumnWidth["BEFORE_DEGAS_LT"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-cfdb05a4 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:676 |  | DATA_OP | p.ColumnWidth["BEFORE_DEGAS_LT_DAY"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-f10984a6 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:677 |  | DATA_OP | p.ColumnWidth["AFTER_DEGAS_ROUTE_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-f12d569d | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:678 |  | DATA_OP | p.ColumnWidth["AFTER_DEGAS_LT"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-d1c67424 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:679 |  | DATA_OP | p.ColumnWidth["AFTER_DEGAS_LT_DAY"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-4e618e42 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:681 |  | DATA_OP | p.ColumnWidth["SHORTER_LT"] | 110 | 행/컬럼 값 대입 |  |  |  |
| AC-3af6d70d | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:683 |  | DATA_OP | p.ColumnWidth["MESSAGE"] | 300 | 행/컬럼 값 대입 |  |  |  |
| AC-56e45acf | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:685 |  | DATA_OP | p.ColumnBgColor["SHORTER_LT"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-b9c9cafb | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:687 |  | UI_PROP | p.DoSearchData | Excel_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-82dd6650 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:688 |  | UI_PROP | p.DoLineCheck | Excel_CheckRow | 속성 DoLineCheck 설정 |  |  |  |
| AC-1b609fa3 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:689 |  | UI_PROP | p.DoSaveData | Excel_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-0c6fbd35 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:690 |  | UI_PROP | p.DoValidationData | Excel_CheckValidation | 속성 DoValidationData 설정 |  |  |  |
| AC-b6b03ed6 | this.btnExcel.Click | FP00411_FCS_Shorter_Aging_Routing.cs:691 |  | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af7104bb | this.btnSql.Click | FP00411_FCS_Shorter_Aging_Routing.cs:430 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-34c01eff | this.btnSql.Click | FP00411_FCS_Shorter_Aging_Routing.cs:431 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8727edfd | this.btnSql.Click | FP00411_FCS_Shorter_Aging_Routing.cs:433 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00411_FIND_FP00411") | 데이터 객체 조작/조회 |  |  |  |
| AC-e1b7168f | this.btnSql.Click | FP00411_FCS_Shorter_Aging_Routing.cs:434 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.ClbDivision_SelectedIndexChanged

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18381f74 | this.Load 외 1 | FP00411_FCS_Shorter_Aging_Routing.cs:200 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-89c91d8e | this.Load 외 1 | FP00411_FCS_Shorter_Aging_Routing.cs:202 |  | UI_PROP | clbSite.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.ClbFactory_SelectedIndexChanged

진입점: this.Load / clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-356221e1 | this.Load 외 1 | FP00411_FCS_Shorter_Aging_Routing.cs:221 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-50a1e425 | this.Load 외 1 | FP00411_FCS_Shorter_Aging_Routing.cs:223 |  | UI_PROP | clbLine.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.ClbPlant_SelectedIndexChanged

진입점: this.Load / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-059080dd | this.Load 외 1 | FP00411_FCS_Shorter_Aging_Routing.cs:214 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f3595a87 | this.Load 외 1 | FP00411_FCS_Shorter_Aging_Routing.cs:216 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.ClbSite_SelectedIndexChanged

진입점: this.Load / clbSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8e610ce | this.Load 외 1 | FP00411_FCS_Shorter_Aging_Routing.cs:207 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-fabb3c0a | this.Load 외 1 | FP00411_FCS_Shorter_Aging_Routing.cs:209 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75369206 | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:234 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, iColumnHeaderCount, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a14264f5 | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:235 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-10929ffd | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:236 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a26defbf | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:110 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d4103e10 | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:111 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-0138a89d | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:112 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-cc21f030 | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:116 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6b83b5f9 | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:117 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e547d76b | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:118 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fccc912d | Dispose | FP00411_FCS_Shorter_Aging_Routing.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.Excel_CheckRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3db50443 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:750 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.Excel_CheckValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7f28d6e | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:734 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-d57549d0 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:735 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP00411_FcsShortAging", "delete_Excel_buffer", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-eaa865ee | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:739 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00411_FcsShortAging", "insert_Excel_buffer", data,0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\MASTE… | 엔드포인트 호출 |  |  |  |
| AC-c61cc4f6 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:743 |  | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP00411_FcsShortAging", "find_Excel_buffer_validation", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9e95cd44 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:743 |  | RETURN | return DataService.FP_ExecuteQuery( "FP00411_FcsShortAging", "find_Excel_buffer_… |  | 처리 중단/반환 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88b3a4a0 | ExcelButton | FP00411_FCS_Shorter_Aging_Routing.cs:423 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.Excel_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89c3c196 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:715 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00411_FcsShortAging", "merge_FP00411_import", data, 0,"MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00411_import] \| FP\MAST… | 엔드포인트 호출 |  |  |  |
| AC-184f30b4 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:720 | if (ret == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-b481fc18 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:724 | if (ret.DataSet == null) | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-403a77f8 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:726 | if (ret.DataSet == null) | DATA_OP | tmpDs.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-3282606f | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:728 |  | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.Excel_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a54bdc52 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:703 | if (set.Good()) | CALL_EXT | set.Tables[0].SetColumnsOrder | ( "DIVISION_ID", "SITE_ID", "PLANT_ID", "FACTORY_ID", "LINE_ID", "ITEM_ID", "NICK_NAME", "… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e0adef1 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:710 |  | RETURN | return set; |  | 처리 중단/반환 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP00411_FIND_FP00411")] / this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) ▸ try ▸ lambda] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a63b818 | popSql.OnSql [if (programID == "PR_UI_FP00411_FIND_FP00411")… 외 4 | FP00411_FCS_Shorter_Aging_Routing.cs:603 | try | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-6e4583e2 | popSql.OnSql [if (programID == "PR_UI_FP00411_FIND_FP00411")… 외 4 | FP00411_FCS_Shorter_Aging_Routing.cs:604 | try | DATA_OP | Filter["ITEM_ID"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-92412b2b | popSql.OnSql [if (programID == "PR_UI_FP00411_FIND_FP00411")… 외 4 | FP00411_FCS_Shorter_Aging_Routing.cs:605 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00411_FIND_FP00411", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-adb1506c | popSql.OnSql [if (programID == "PR_UI_FP00411_FIND_FP00411")… 외 4 | FP00411_FCS_Shorter_Aging_Routing.cs:606 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-be16756f | popSql.OnSql [if (programID == "PR_UI_FP00411_FIND_FP00411")… 외 4 | FP00411_FCS_Shorter_Aging_Routing.cs:611 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.FindData

진입점: this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] / FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b957f35 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:534 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06807b71 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:535 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6814134c | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:538 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f1a70145 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:540 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-66b880da | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:540 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22fb7e37 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:544 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5de608da | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:551 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0c482b30 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:553 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8640f26e | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:563 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d6f5b5ec | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:565 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6134431 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:578 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2b92a59f | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:591 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c0f676e6 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK)] 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:592 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cfc4cca | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:89 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f866b44 | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:825 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bd19bfc0 | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:826 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2c86ec8c | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:826 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1a77603b | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:827 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.GetFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63c2d2c2 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:176 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE, false, CurrentUser, _sNonAuth, _sSaveAuth , n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-e52ed8a2 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:176 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-93fbe21a | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:180 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.GetLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f8552a6 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:193 |  | DATA_OP | Filter["LINE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d3e30222 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:194 |  | FLAG | dtLine | DataService.XpCommonCond.findLineCode_Common(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff21b797 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:194 |  | CALL_EXT | DataService.XpCommonCond.findLineCode_Common | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8389d7cf | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:195 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.GetPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91badc10 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:186 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-4363ab92 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:186 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6e35cd11 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:188 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.GetSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cedc5da | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:169 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-92785b9b | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:169 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4791c268 | (진입점 미연결) | FP00411_FCS_Shorter_Aging_Routing.cs:171 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d5c7687 | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:125 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7f32929 | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:243 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-acfbff49 | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:244 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-26bbc67f | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:245 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e3816dcb | this.Load | FP00411_FCS_Shorter_Aging_Routing.cs:246 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29e01fb3 | popSql.OnSql | FP00411_FCS_Shorter_Aging_Routing.cs:623 | if (programID == "PR_UI_FP00411_FIND_FP00411") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-40dc3656 | popSql.OnSql | FP00411_FCS_Shorter_Aging_Routing.cs:626 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23744a0a | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:267 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5abcc650 | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:269 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ebba1b9 | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:274 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1054ea85 | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:275 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f67f235c | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:278 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ba568f9d | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:285 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-5178fde9 | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:287 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f2e79ad1 | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:288 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6de4dd6d | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:293 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b8a12707 | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:298 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ff68bdc | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:307 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-101e9e0b | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:311 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-86da2ba6 | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:315 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-dd2d1579 | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:316 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-454dd506 | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:320 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.Save_Data_Line

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6da5a28f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:354 | try | DATA_OP | dsSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-73936381 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:357 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1f4216f9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:364 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: ▸ if (bindingRow.RowState !=… | CALL_EXT | bindingRow.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b01c75bd | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:368 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagM: ▸ if (bindingRow.RowState != DataRowState.Modified) | CALL_EXT | bindingRow.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-30758433 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:372 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagD: ▸ if (bindingRow.RowState != DataRowState.Deleted) | DATA_OP | bindingRow.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5bf66464 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:382 | try | CALL_EXT | dsSave.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec264e63 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:386 | try ▸ if (iCount > 0) | ENDPOINT | DataService.FP_UpdateBatch | ("FP00411_FcsShortAging", "merge_FP00411", dsSave, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00411] \| FP\MASTER\FP00… | 엔드포인트 호출 |  |  |  |
| AC-25890b05 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:389 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-f1baaa7f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:391 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | DATA_OP | set.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-299d313f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:392 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-aa2eb697 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:394 | try ▸ if (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-cca75ba8 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:398 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ef6412e7 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:404 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-75da6388 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00411_FCS_Shorter_Aging_Routing.cs:405 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1574810 | SaveButton | FP00411_FCS_Shorter_Aging_Routing.cs:260 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b91ec25 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:761 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7122804d | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:761 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ee57e447 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:766 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter["DIVISION_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-b28b1c72 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:770 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a18ef558 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:770 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-07eb91c2 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:772 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)clbSite is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)clbSite as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6e6a0bc8 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:774 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)clbSite is UsrCombo) ▸ if ((object)clbSite … | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)clbSite as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c8caaa55 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:780 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-33c96451 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:781 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-863c62fb | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:781 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1bb71d0a | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:783 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3a288406 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:785 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlant is Usr… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b51db3da | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:791 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-49b6eef4 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:792 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-86785386 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:792 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-bcce1f27 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:794 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ if ((object)clbFactory is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c6eeb07e | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:796 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ else of ((object)clbFactory is UsrCombo) ▸ if ((object)clbFactory … | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-163483aa | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:803 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | DATA_OP | Filter["FACTORY_ID"] | sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-7d5f9343 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:804 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-8a569904 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:804 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-afd6d79e | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:806 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ if ((object)clbLine is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtLine, (object)clbLine as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bbcd1791 | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:808 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ else of ((object)clbLine is UsrCombo) ▸ if ((object)clbLine is… | LIST_REBIND | clsCtrl.setListBox | (dtLine, (object)clbLine as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ba9cbbab | this.Load 외 5 | FP00411_FCS_Shorter_Aging_Routing.cs:817 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | sLINE | 행/컬럼 값 대입 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.SetEditMode

진입점: this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) ▸ try] / FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / EditButton [if (spdMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ace2e10a | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00411_FCS_Shorter_Aging_Routing.cs:494 |  | CALL_EXT | siTarget.SwitchLockFP | (isEdit) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3469ad63 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00411_FCS_Shorter_Aging_Routing.cs:500 | if (isEdit) | CALL_EXT | siTarget.LockColumnFP | (Chanage_Lt_Column, Chanage_Lt_Column, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-51a3dc7f | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00411_FCS_Shorter_Aging_Routing.cs:515 | if (isEdit) ▸ if (Chanage_Lt_Column >= 0) ▸ for (i < rowcount) ▸ if (EDITYN == "Y") | GRID_LOCK | siMain.LockRange | (i, Chanage_Lt_Column, i, Chanage_Lt_Column, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f816e516 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00411_FCS_Shorter_Aging_Routing.cs:521 | else of (isEdit) | CALL_EXT | siTarget.LockColumnFP | (0, siTarget.GetMaxColumnIndex(), true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b5a7d02d | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 3 | FP00411_FCS_Shorter_Aging_Routing.cs:524 |  | CALL_EXT | siTarget.LockColumnFPDone | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.SetLookColor

진입점: this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) ▸ try] / FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb46d044 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:472 | for (i < rowcount) ▸ if (CHECK_BEFORE_YN == "Y") ▸ if (before0 >= 0) | GRID_STYLE | siMain.SetBGColor | (i, before0, i, before0, System.Drawing.Color.FromArgb(255, 192, 203)) | 그리드 표시 설정 |  |  |  |
| AC-c8019dac | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:474 | for (i < rowcount) ▸ if (CHECK_BEFORE_YN == "Y") ▸ if (before1 >= 0) | GRID_STYLE | siMain.SetBGColor | (i, before1, i, before1, System.Drawing.Color.FromArgb(255, 192, 203)) | 그리드 표시 설정 |  |  |  |
| AC-dc71c805 | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:476 | for (i < rowcount) ▸ if (CHECK_BEFORE_YN == "Y") ▸ if (before2 >= 0) | GRID_STYLE | siMain.SetBGColor | (i, before2, i, before2, System.Drawing.Color.FromArgb(255, 192, 203)) | 그리드 표시 설정 |  |  |  |
| AC-4271059e | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:481 | for (i < rowcount) ▸ if (CHECK_AFTER_YN == "Y") ▸ if (after0 >= 0) | GRID_STYLE | siMain.SetBGColor | (i, after0, i, after0, System.Drawing.Color.FromArgb(255, 192, 203)) | 그리드 표시 설정 |  |  |  |
| AC-c278e8cb | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:483 | for (i < rowcount) ▸ if (CHECK_AFTER_YN == "Y") ▸ if (after1 >= 0) | GRID_STYLE | siMain.SetBGColor | (i, after1, i, after1, System.Drawing.Color.FromArgb(255, 192, 203)) | 그리드 표시 설정 |  |  |  |
| AC-6907db1b | this.btnExcel.Click [if (p.DialogResult == DialogResult.OK) … 외 2 | FP00411_FCS_Shorter_Aging_Routing.cs:485 | for (i < rowcount) ▸ if (CHECK_AFTER_YN == "Y") ▸ if (after2 >= 0) | GRID_STYLE | siMain.SetBGColor | (i, after2, i, after2, System.Drawing.Color.FromArgb(255, 192, 203)) | 그리드 표시 설정 |  |  |  |

## FP00411_FCS_Shorter_Aging_Routing.SwitchEdit

진입점: EditButton [if (spdMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05a3cc08 | EditButton [if (spdMain != null)] | FP00411_FCS_Shorter_Aging_Routing.cs:444 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |


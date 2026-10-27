# AS-IS 액션 대조표 — SSP0030

> 원천: `Doc/asisfacts/screens/SSP0030/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 368행 · 메서드 35 · 종류 DATA_OP 133 · FLAG 36 · UI_PROP 33 · CALL_EXT 30 · GRID_SET 30 · GRID_INIT 18 · LIST_REBIND 13 · ENDPOINT 13 · COMBO_DATA 11 · STATE 10 · VALUE_SET 9 · RETURN 9 · POPUP 8 · UI_MISC 5 · GRID_BIND 2 · GRID_LOCK 2 · VALUE_CLEAR 2 · MESSAGE 1 · VALIDATE 1 · STATE_RESET 1 · LIST_CLEAR 1 · ⚠ 의미 확인 필요 30


## SSP0030_Logistics_Simulation.btn_Noinfo_Click

진입점: btn_Noinfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c862fea | btn_Noinfo.Click | SSP0030_Logistics_Simulation.cs:196 |  | FLAG | this.G_SearchCondition | "1" | 화면 필드/플래그 변경 |  |  |  |

## SSP0030_Logistics_Simulation.CboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-485b553f | cboDivision.SelectedIndexChanged | SSP0030_Logistics_Simulation.cs:1637 |  | FLAG | G_SearchCondition | "0" | 화면 필드/플래그 변경 |  |  |  |
| AC-a64030bf | cboDivision.SelectedIndexChanged | SSP0030_Logistics_Simulation.cs:1638 |  | FLAG | p_DivisionK | "" | 화면 필드/플래그 변경 |  |  |  |

## SSP0030_Logistics_Simulation.cboDivisionK_SelectedIndexChanged

진입점: cboDivisionK.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c90da73 | cboDivisionK.SelectedIndexChanged | SSP0030_Logistics_Simulation.cs:1643 |  | FLAG | p_DivisionK | CString.GetCheckedListValue(dtDivisionK, cboDivisionK.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |

## SSP0030_Logistics_Simulation.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51426d0e | cboPlanDate.SelectedIndexChanged | SSP0030_Logistics_Simulation.cs:1676 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-12cbaebc | cboPlanDate.SelectedIndexChanged | SSP0030_Logistics_Simulation.cs:1676 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4554e44 | cboPlanDate.SelectedIndexChanged | SSP0030_Logistics_Simulation.cs:1677 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0023c852 | cboPlanDate.SelectedIndexChanged | SSP0030_Logistics_Simulation.cs:1679 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-fb934146 | cboPlanDate.SelectedIndexChanged | SSP0030_Logistics_Simulation.cs:1683 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SSP0030_Logistics_Simulation.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9317df83 | cboPlanType.SelectedIndexChanged | SSP0030_Logistics_Simulation.cs:1692 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-964b59e2 | cboPlanType.SelectedIndexChanged | SSP0030_Logistics_Simulation.cs:1692 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1273cd36 | cboPlanType.SelectedIndexChanged | SSP0030_Logistics_Simulation.cs:1693 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b0911f1a | cboPlanType.SelectedIndexChanged | SSP0030_Logistics_Simulation.cs:1695 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SSP0030_Logistics_Simulation.CreateMonthlyGrid

진입점: FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-266ba649 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:1197 |  | FLAG | G_MainGriHeaderdColumnIndex | 8 | 화면 필드/플래그 변경 |  |  |  |
| AC-cb34c2f4 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:1199 |  | GRID_INIT | siMain.Freeze | (0, G_MainGriHeaderdColumnIndex) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-09fe0145 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:1202 | if (G_Month.Count > 0) | CALL_EXT | G_Month.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b499b14 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:1204 | if (G_Dataindex.Count > 0) | CALL_EXT | G_Dataindex.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-64e0c041 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:1223 | if (G_TempYear.Count > 0) ▸ for (i < G_TempYear.Count) ▸ for (j < sep.Length) ▸ if (G_TempYear[i].ToString() == sep[j].ToString().Substring(… | DATA_OP | G_Month.Add | (T_year+sep[j].ToString().Substring(4, 2)) | 데이터 객체 조작/조회 |  |  |  |
| AC-017f505a | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:1234 | if (G_TempYear.Count > 0) ▸ for (i < G_TempYear.Count) | CALL_EXT | siMain.AddColumns | (G_MainGriHeaderdColumnIndex, SamYearCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3671a8fb | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:1235 | if (G_TempYear.Count > 0) ▸ for (i < G_TempYear.Count) | GRID_INIT | siMain.ColumnHeaderSpan | (0, G_MainGriHeaderdColumnIndex, 1, SamYearCount, 20, G_TempYear[i].ToString(), FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ccd969a0 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:1241 | if (G_TempYear.Count > 0) ▸ for (i < G_TempYear.Count) ▸ for (k < sep2.Length) ▸ if (k == 0) | GRID_INIT | siMain.SetColumnHeader | (1, G_MainGriHeaderdColumnIndex, sep2[k].ToString()) | 그리드 재구성/초기화 |  |  |  |
| AC-b9f4b660 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:1241 | if (G_TempYear.Count > 0) ▸ for (i < G_TempYear.Count) ▸ for (k < sep2.Length) ▸ if (k == 0) | DATA_OP | G_Dataindex.Add | (T_year + sep2[k].ToString().Substring(0, 2) + "-" + G_MainGriHeaderdColumnIndex.ToString(… | 데이터 객체 조작/조회 |  |  |  |
| AC-a846843a | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:1242 | if (G_TempYear.Count > 0) ▸ for (i < G_TempYear.Count) ▸ for (k < sep2.Length) ▸ else of (k == 0) | GRID_INIT | siMain.SetColumnHeader | (1, G_MainGriHeaderdColumnIndex + ColIndex, sep2[k].ToString()) | 그리드 재구성/초기화 |  |  |  |
| AC-76af0940 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:1242 | if (G_TempYear.Count > 0) ▸ for (i < G_TempYear.Count) ▸ for (k < sep2.Length) ▸ else of (k == 0) | DATA_OP | G_Dataindex.Add | (T_year + sep2[k].ToString().Substring(0, 2) + "-" + (G_MainGriHeaderdColumnIndex + ColInd… | 데이터 객체 조작/조회 |  |  |  |
| AC-1c8d2665 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:1245 | if (G_TempYear.Count > 0) ▸ for (i < G_TempYear.Count) | FLAG | G_MainGriHeaderdColumnIndex | += SamYearCount | 화면 필드/플래그 변경 |  |  |  |

## SSP0030_Logistics_Simulation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d325d47 | this.Load | SSP0030_Logistics_Simulation.cs:308 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6ec0b231 | this.Load | SSP0030_Logistics_Simulation.cs:309 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d3355805 | this.Load | SSP0030_Logistics_Simulation.cs:312 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtDetail, SpdSheet.shtDetail, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0009ee23 | this.Load | SSP0030_Logistics_Simulation.cs:313 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, spdDetail.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bec3bcf1 | this.Load | SSP0030_Logistics_Simulation.cs:316 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtPlanDetail_Excel, SpdSheet.shtPlanDetail_Excel, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-14f52681 | this.Load | SSP0030_Logistics_Simulation.cs:317 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c652acef | this.Load | SSP0030_Logistics_Simulation.cs:320 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0030_Logistics_Simulation.DataDivision

진입점: FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47f1dfb2 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:865 | for (row < OriginData.Tables[0].Rows.Count) ▸ if (OriginData.Tables[0].Rows[row]["POD_AREA_V"].ToString() == TextMacro.DESTNATION_COST \|\| … | DATA_OP | DataCopyTable.ImportRow | (Drow) | 데이터 객체 조작/조회 |  |  |  |
| AC-69b1c048 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:866 | for (row < OriginData.Tables[0].Rows.Count) ▸ if (OriginData.Tables[0].Rows[row]["POD_AREA_V"].ToString() == TextMacro.DESTNATION_COST \|\| … | DATA_OP | OriginData.Tables[0].Rows.Remove | (Drow) | 데이터 객체 조작/조회 |  |  |  |

## SSP0030_Logistics_Simulation.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04ed0d10 | this.Load | SSP0030_Logistics_Simulation.cs:147 |  | UI_PROP | usrConditionPanel1.Height | 100 | 속성 Height 설정 |  |  |  |

## SSP0030_Logistics_Simulation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-425e3c93 | Dispose | SSP0030_Logistics_Simulation.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0030_Logistics_Simulation.ExportExcel

진입점: this.formDown.Click [finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54036c99 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1351 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8ac5799 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1372 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c665c895 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1374 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9133ee91 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1377 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-29023a2d | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1413 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sv.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1e5e4fa7 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1418 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-41fd162c | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1423 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1d20c823 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1425 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2ec385f | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1438 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ce5bf0d | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1450 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-2a806a68 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1451 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-412882a7 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1460 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-caaa323d | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1461 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-21753ad2 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1467 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-9244ffa2 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1480 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-aac87975 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1489 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-0d778e4b | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1496 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a1d0039 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1501 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-3d76debd | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1503 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-38795d74 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1507 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-2662640c | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1509 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-a0f5cd26 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1512 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-c3993db6 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1514 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-c1e36dde | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1519 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-d02362b3 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1530 | try ▸ if (isOpen) | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-dcb2b34b | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1532 | try ▸ if (isOpen) | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e21c6f5f | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1536 | try ▸ else of (isOpen) | POPUP | new SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-d39c32ae | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1537 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Filter | "Excel files (*.xls or .xlsx)\|*.xls;*.xlsx" | 속성 Filter 설정 |  |  |  |
| AC-4c112986 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1538 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Title | "Save an Excel File" | 속성 Title 설정 |  |  |  |
| AC-23d8791b | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1539 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.FileName | sExcelFileName | 속성 FileName 설정 |  |  |  |
| AC-fc59e39d | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1540 | try ▸ else of (isOpen) | POPUP | saveFileDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-25cacc87 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1547 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") | CALL_EXT | sFileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-707ee9d6 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1548 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ if (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUpper() =… | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2c65d8f8 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1550 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ else of (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUppe… | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf8d61b1 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1554 | try | CALL_EXT | GC.GetGeneration | ((object)sp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-08b18f59 | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1560 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3aa113bd | this.formDown.Click [finally] | SSP0030_Logistics_Simulation.cs:1567 | finally ▸ if (ver >= 0) | CALL_EXT | GC.Collect | (ver) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0030_Logistics_Simulation.FindData_Detail

진입점: this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthValueSum_Row) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null && this.spdMain.Sheets[0].GetValue(e.Row, e.Column).ToString() …)] / btn_Noinfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d6598c0 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:468 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a99dcd23 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:490 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e7a9906a | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:498 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5a88cea2 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:499 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", sBinding)) { var request = new FoxD… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d38bee2f | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:503 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0030_GET_LOGISTICS_SIMULATION_DETAIL") ⇒ SSP.SSP0030_GET_LOGISTICS_SIMULATION_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-5fc0b65a | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:507 | try ▸ lambda ▸ if (G_SearchCondition == "0") | DATA_OP | request.Parameters["p_division_id"] | p_division | 행/컬럼 값 대입 |  |  |  |
| AC-224b4313 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:508 | try ▸ lambda ▸ if (G_SearchCondition == "0") | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4c402a6e | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:509 | try ▸ lambda ▸ if (G_SearchCondition == "0") | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8465e73a | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:510 | try ▸ lambda ▸ if (G_SearchCondition == "0") | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-136eb8a5 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:511 | try ▸ lambda ▸ if (G_SearchCondition == "0") | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-4b9857d8 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:512 | try ▸ lambda ▸ if (G_SearchCondition == "0") | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-b25285b0 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:513 | try ▸ lambda ▸ if (G_SearchCondition == "0") | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-c182a614 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:514 | try ▸ lambda ▸ if (G_SearchCondition == "0") | DATA_OP | request.Parameters["p_from_company"] | p_company | 행/컬럼 값 대입 |  |  |  |
| AC-a76eef4a | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:515 | try ▸ lambda ▸ if (G_SearchCondition == "0") | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-1ba2dd83 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:517 | try ▸ lambda ▸ if (G_SearchCondition == "0") ▸ if (sep[2] == "X") | DATA_OP | request.Parameters["p_transport_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8b07b836 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:519 | try ▸ lambda ▸ if (G_SearchCondition == "0") ▸ else of (sep[2] == "X") | DATA_OP | request.Parameters["p_transport_code"] | sep[2] | 행/컬럼 값 대입 |  |  |  |
| AC-0393adcd | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:521 | try ▸ lambda ▸ if (G_SearchCondition == "0") | DATA_OP | request.Parameters["p_exchange_rate"] | p_exchange | 행/컬럼 값 대입 |  |  |  |
| AC-cff8b3d4 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:522 | try ▸ lambda ▸ if (G_SearchCondition == "0") | DATA_OP | request.Parameters["p_type"] | sep[0] | 행/컬럼 값 대입 |  |  |  |
| AC-ec0fe316 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:523 | try ▸ lambda ▸ if (G_SearchCondition == "0") | DATA_OP | request.Parameters["p_pod_area"] | sep[1] | 행/컬럼 값 대입 |  |  |  |
| AC-d08bd27d | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:524 | try ▸ lambda ▸ if (G_SearchCondition == "0") | DATA_OP | request.Parameters["p_Condition"] | this.G_SearchCondition | 행/컬럼 값 대입 |  |  |  |
| AC-41a2f040 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:526 | try ▸ lambda ▸ if (G_SearchCondition == "0") | UI_PROP | request.CommandTimeout | 180 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a5ef0b2b | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:530 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_division_id"] | p_division | 행/컬럼 값 대입 |  |  |  |
| AC-e43c7dba | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:531 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-335633bd | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:532 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-44b7b809 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:533 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-22b56784 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:534 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-80790a3c | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:535 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-a1442d4d | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:536 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-1387281b | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:537 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_from_company"] | p_company | 행/컬럼 값 대입 |  |  |  |
| AC-c19613a1 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:538 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-3c3d845c | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:539 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_transport_code"] | p_transmode | 행/컬럼 값 대입 |  |  |  |
| AC-d9093732 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:540 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_exchange_rate"] | p_exchange | 행/컬럼 값 대입 |  |  |  |
| AC-afcb543a | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:541 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9b4a2f0b | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:542 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_pod_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-87d46f86 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:543 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | DATA_OP | request.Parameters["p_Condition"] | this.G_SearchCondition | 행/컬럼 값 대입 |  |  |  |
| AC-49256c38 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:545 | try ▸ lambda ▸ else of (G_SearchCondition == "0") ▸ if (G_SearchCondition == "1") | UI_PROP | request.CommandTimeout | 180 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ead8258d | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:548 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f55fd2e2 | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:549 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e6949b8b | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:557 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siDetail.Query | (ds.Tables[0]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-efa4da3a | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:560 | try | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f617ed0f | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:563 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-32a7795b | this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthV… 외 1 | SSP0030_Logistics_Simulation.cs:569 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0030_Logistics_Simulation.FindData_Excel

진입점: this.formDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c25c90b | this.formDown.Click | SSP0030_Logistics_Simulation.cs:629 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7ee26aec | this.formDown.Click | SSP0030_Logistics_Simulation.cs:633 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5dab1510 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:652 | try ▸ else of (txt_exchangerate.Text != "") | VALUE_SET | txt_exchangerate.Text | G_ExchangeRate | 컨트롤 값 설정 |  |  |  |
| AC-0fffceff | this.formDown.Click | SSP0030_Logistics_Simulation.cs:659 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-29084120 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:660 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", sBinding)) { var request = new FoxD… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-62ef3051 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:664 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0030_GET_LOGISTICS_SIMULATION_EXCEL") ⇒ SSP.SSP0030_GET_LOGISTICS_SIMULATION_EXCEL | 엔드포인트 요청 생성 |  |  |  |
| AC-b8add3c1 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:666 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division | 행/컬럼 값 대입 |  |  |  |
| AC-dec0417f | this.formDown.Click | SSP0030_Logistics_Simulation.cs:667 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-79bab9ba | this.formDown.Click | SSP0030_Logistics_Simulation.cs:668 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-dfcecd83 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:669 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b22f0c6e | this.formDown.Click | SSP0030_Logistics_Simulation.cs:670 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-61783da3 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:671 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-819d11e6 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:672 | try ▸ lambda | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-537fd32c | this.formDown.Click | SSP0030_Logistics_Simulation.cs:673 | try ▸ lambda | DATA_OP | request.Parameters["p_from_company"] | p_company | 행/컬럼 값 대입 |  |  |  |
| AC-9b3a7d38 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:674 | try ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-4d1f62f9 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:675 | try ▸ lambda | DATA_OP | request.Parameters["p_transport_code"] | p_transmode | 행/컬럼 값 대입 |  |  |  |
| AC-fff532bf | this.formDown.Click | SSP0030_Logistics_Simulation.cs:676 | try ▸ lambda | DATA_OP | request.Parameters["p_exchange_rate"] | p_exchange_rate | 행/컬럼 값 대입 |  |  |  |
| AC-83acac94 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:677 | try ▸ lambda | UI_PROP | request.CommandTimeout | 180 | 속성 CommandTimeout 설정 |  |  |  |
| AC-dd787c9c | this.formDown.Click | SSP0030_Logistics_Simulation.cs:678 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-31eb045b | this.formDown.Click | SSP0030_Logistics_Simulation.cs:679 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-467885e4 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:687 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0fd25f44 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:690 | try | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9aef78a | this.formDown.Click | SSP0030_Logistics_Simulation.cs:693 | try | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b23542f8 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:699 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0030_Logistics_Simulation.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5223aa4a | FindButton | SSP0030_Logistics_Simulation.cs:371 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-bb78eaa5 | FindButton | SSP0030_Logistics_Simulation.cs:375 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4a70e5ae | FindButton | SSP0030_Logistics_Simulation.cs:395 | try ▸ else of (txt_exchangerate.Text != "") | VALUE_SET | txt_exchangerate.Text | G_ExchangeRate | 컨트롤 값 설정 |  |  |  |
| AC-774994e1 | FindButton | SSP0030_Logistics_Simulation.cs:402 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e05bd8bd | FindButton | SSP0030_Logistics_Simulation.cs:403 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", sBinding)) { var request = new FoxD… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-de796edf | FindButton | SSP0030_Logistics_Simulation.cs:407 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0030_GET_LOGISTICS_SIMULATION") ⇒ SSP.SSP0030_GET_LOGISTICS_SIMULATION | 엔드포인트 요청 생성 |  |  |  |
| AC-6b1811cf | FindButton | SSP0030_Logistics_Simulation.cs:409 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division | 행/컬럼 값 대입 |  |  |  |
| AC-832ddda4 | FindButton | SSP0030_Logistics_Simulation.cs:410 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c75c4aa7 | FindButton | SSP0030_Logistics_Simulation.cs:411 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1f0219d1 | FindButton | SSP0030_Logistics_Simulation.cs:412 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d754565a | FindButton | SSP0030_Logistics_Simulation.cs:413 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-66ec589f | FindButton | SSP0030_Logistics_Simulation.cs:414 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-a1bd4c78 | FindButton | SSP0030_Logistics_Simulation.cs:415 | try ▸ lambda | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-8f302b55 | FindButton | SSP0030_Logistics_Simulation.cs:416 | try ▸ lambda | DATA_OP | request.Parameters["p_from_company"] | p_company | 행/컬럼 값 대입 |  |  |  |
| AC-ce5a3f7d | FindButton | SSP0030_Logistics_Simulation.cs:417 | try ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-2a24addc | FindButton | SSP0030_Logistics_Simulation.cs:418 | try ▸ lambda | DATA_OP | request.Parameters["p_transport_code"] | p_transmode | 행/컬럼 값 대입 |  |  |  |
| AC-339f1cb3 | FindButton | SSP0030_Logistics_Simulation.cs:419 | try ▸ lambda | DATA_OP | request.Parameters["p_exchange_rate"] | p_exchange_rate | 행/컬럼 값 대입 |  |  |  |
| AC-461a138f | FindButton | SSP0030_Logistics_Simulation.cs:420 | try ▸ lambda | DATA_OP | request.Parameters["p_Kubun"] | p_Kubun | 행/컬럼 값 대입 |  |  |  |
| AC-33fb24c0 | FindButton | SSP0030_Logistics_Simulation.cs:421 | try ▸ lambda | DATA_OP | request.Parameters["p_PIVOT_yyyymm"] | Set_PIVOT_DATE(p_plan_start_yyyymmdd.ToString(), p_to_yyyymmdd.ToString()) | 행/컬럼 값 대입 |  |  |  |
| AC-c8bf0704 | FindButton | SSP0030_Logistics_Simulation.cs:423 | try ▸ lambda | UI_PROP | request.CommandTimeout | 180 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0b0ec6eb | FindButton | SSP0030_Logistics_Simulation.cs:425 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-87083dc6 | FindButton | SSP0030_Logistics_Simulation.cs:426 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-201b3a09 | FindButton | SSP0030_Logistics_Simulation.cs:432 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | G_MainDataDT | null | 화면 필드/플래그 변경 |  |  |  |
| AC-89171418 | FindButton | SSP0030_Logistics_Simulation.cs:433 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | G_MainDataDT | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-da60b9e2 | FindButton | SSP0030_Logistics_Simulation.cs:446 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < G_Month.Count) | UI_PROP | Month.DataType | System.Type.GetType("System.String") | 속성 DataType 설정 |  |  |  |
| AC-a7fa8234 | FindButton | SSP0030_Logistics_Simulation.cs:447 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < G_Month.Count) | UI_PROP | Month.ColumnName | G_Month[i].ToString() | 속성 ColumnName 설정 |  |  |  |
| AC-6a6a78ae | FindButton | SSP0030_Logistics_Simulation.cs:448 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (i < G_Month.Count) | DATA_OP | this.G_MainDataDT.Columns.Add | (Month) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f6ceb67 | FindButton | SSP0030_Logistics_Simulation.cs:454 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-313141a5 | FindButton | SSP0030_Logistics_Simulation.cs:457 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c6474bc1 | FindButton | SSP0030_Logistics_Simulation.cs:463 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0030_Logistics_Simulation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a6dbf6f | this.Load | SSP0030_Logistics_Simulation.cs:127 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d6d0fd60 | this.Load | SSP0030_Logistics_Simulation.cs:135 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_CLEAR | clbCompany_ID.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-032132f2 | this.Load | SSP0030_Logistics_Simulation.cs:136 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | CALL_EXT | clbCompany_ID.FindString | (sUserCompany_NM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2641a17b | this.Load | SSP0030_Logistics_Simulation.cs:137 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_SET | clbCompany_ID.SelectedIndex | intComIdx | 컨트롤 값 설정 |  |  |  |

## SSP0030_Logistics_Simulation.formDown_Click_1

진입점: this.formDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06875a26 | this.formDown.Click | SSP0030_Logistics_Simulation.cs:1704 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtPlanDetail_Excel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37a148fd | this.formDown.Click | SSP0030_Logistics_Simulation.cs:1705 |  | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtPlanDetail_Excel) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0030_Logistics_Simulation.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75f33a71 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:1340 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-6945700b | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:1341 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-efad84a7 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:1342 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-7ffe1e1b | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:1343 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-02bb6782 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:1344 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f0a52f06 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:1346 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0030_Logistics_Simulation.GetLastRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-819f7ced | (진입점 미연결) | SSP0030_Logistics_Simulation.cs:1326 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-0a7658e1 | (진입점 미연결) | SSP0030_Logistics_Simulation.cs:1327 |  | DATA_OP | request.Parameters["p_division_id"] | divisionId | 행/컬럼 값 대입 |  |  |  |
| AC-2a620067 | (진입점 미연결) | SSP0030_Logistics_Simulation.cs:1328 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-30d3e219 | (진입점 미연결) | SSP0030_Logistics_Simulation.cs:1330 |  | RETURN | return dailyPlanPeriod; |  | 처리 중단/반환 |  |  |  |

## SSP0030_Logistics_Simulation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9801cd33 | this.Load | SSP0030_Logistics_Simulation.cs:206 |  | FLAG | p_DivisionK | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-143e8186 | this.Load | SSP0030_Logistics_Simulation.cs:209 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-1554a1a5 | this.Load | SSP0030_Logistics_Simulation.cs:210 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-1965e631 | this.Load | SSP0030_Logistics_Simulation.cs:213 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-8aa8a7fc | this.Load | SSP0030_Logistics_Simulation.cs:215 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1b226a8d | this.Load | SSP0030_Logistics_Simulation.cs:218 |  | DATA_OP | dtDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8d739569 | this.Load | SSP0030_Logistics_Simulation.cs:219 |  | DATA_OP | tmpDivision.Columns.Add | ("SORT_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-f332a16d | this.Load | SSP0030_Logistics_Simulation.cs:220 |  | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-80f3f37a | this.Load | SSP0030_Logistics_Simulation.cs:224 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3a62cad7 | this.Load | SSP0030_Logistics_Simulation.cs:225 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d4a3218d | this.Load | SSP0030_Logistics_Simulation.cs:226 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-e142af7f | this.Load | SSP0030_Logistics_Simulation.cs:227 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["SORT_ORDER"] | dr["CODE"].ToString() == "81" ? 1 : dr["CODE"].ToString() == "40" ? 2 : 3 | 행/컬럼 값 대입 |  |  |  |
| AC-9cc20bba | this.Load | SSP0030_Logistics_Simulation.cs:229 | foreach (DataRow dr in dtDivision.Rows) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e423cc4b | this.Load | SSP0030_Logistics_Simulation.cs:232 |  | UI_PROP | tmpDivision.DefaultView.Sort | "SORT_ORDER Asc" | 속성 Sort 설정 |  |  |  |
| AC-d36b7cee | this.Load | SSP0030_Logistics_Simulation.cs:233 |  | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-79226d6e | this.Load | SSP0030_Logistics_Simulation.cs:235 |  | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5e2d9abd | this.Load | SSP0030_Logistics_Simulation.cs:237 |  | STATE_RESET | dtDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-efafd59c | this.Load | SSP0030_Logistics_Simulation.cs:238 |  | FLAG | dtDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-b27f60d6 | this.Load | SSP0030_Logistics_Simulation.cs:238 |  | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3112977e | this.Load | SSP0030_Logistics_Simulation.cs:241 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-eef2b007 | this.Load | SSP0030_Logistics_Simulation.cs:245 |  | DATA_OP | dtCompany.Select().Where(c => c["DIVISION_ID"].ToString() == strSelDivision_ID).CopyToData… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5d4be45b | this.Load | SSP0030_Logistics_Simulation.cs:245 |  | DATA_OP | dtCompany.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-faa964c2 | this.Load | SSP0030_Logistics_Simulation.cs:246 |  | LIST_REBIND | clsCtrl.setListBox | (dtDiv_Company_ID, clbCompany_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a486ff43 | this.Load | SSP0030_Logistics_Simulation.cs:248 |  | FLAG | dtElecType | Data.Common(Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-2c37d77f | this.Load | SSP0030_Logistics_Simulation.cs:248 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c575ed04 | this.Load | SSP0030_Logistics_Simulation.cs:249 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1671e5cf | this.Load | SSP0030_Logistics_Simulation.cs:251 |  | UI_PROP | cbo_Kubun.DropDownStyle | ComboBoxStyle.DropDown | 속성 DropDownStyle 설정 |  |  |  |
| AC-e8fa85a5 | this.Load | SSP0030_Logistics_Simulation.cs:252 |  | VALUE_SET | cbo_Kubun.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-82577246 | this.Load | SSP0030_Logistics_Simulation.cs:253 |  | UI_PROP | cbo_Kubun.DropDownStyle | ComboBoxStyle.DropDownList | 속성 DropDownStyle 설정 |  |  |  |
| AC-100d385c | this.Load | SSP0030_Logistics_Simulation.cs:257 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SSP0030_Logistics_Simulation.InitSpread

진입점: this.formDown.Click [try] / this.Load / this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthValueSum_Row) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null && this.spdMain.Sheets[0].GetValue(e.Row, e.Column).ToString() …) ▸ try] / cboDivision.SelectedIndexChanged / btn_Noinfo.Click [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-559bf8e0 | this.formDown.Click [try] 외 5 | SSP0030_Logistics_Simulation.cs:326 | if (spdInfo.ActiveSheet.RowCount != 0) | GRID_SET | spdInfo.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-605e632c | this.formDown.Click [try] 외 5 | SSP0030_Logistics_Simulation.cs:329 |  | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-0689c1b8 | this.formDown.Click [try] 외 5 | SSP0030_Logistics_Simulation.cs:330 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-3833e2b7 | this.formDown.Click [try] 외 5 | SSP0030_Logistics_Simulation.cs:332 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f8dc8ea8 | this.formDown.Click [try] 외 5 | SSP0030_Logistics_Simulation.cs:333 |  | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0030_Logistics_Simulation.MainGrid_DataBinding

진입점: FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a4e0a8e | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:704 |  | DATA_OP | dt.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-38b21728 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:715 |  | CALL_EXT | siMain.AddRows | (0, G_MainDataDT.Rows.Count + 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-80486402 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:726 | try ▸ for (row < G_MainDataDT.Rows.Count) ▸ for (col < G_MainDataDT.Columns.Count) ▸ if (G_MainDataDT.Rows[row][col].ToString() == TextMacro… | GRID_SET | siMain.SetValue | (row, col + 1, G_MainDataDT.Rows[row][col].ToString()) | 그리드 값 설정 |  |  |  |
| AC-b5f06dac | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:727 | try ▸ for (row < G_MainDataDT.Rows.Count) ▸ for (col < G_MainDataDT.Columns.Count) ▸ if (G_MainDataDT.Rows[row][col].ToString() == TextMacro… | GRID_SET | spdMain.Sheets[0].Cells[row, col + 1].HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-fdb806c9 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:731 | try ▸ for (row < G_MainDataDT.Rows.Count) ▸ for (col < G_MainDataDT.Columns.Count) ▸ if (G_MainDataDT.Rows[row][col].ToString() == TextMacro… | GRID_SET | spdMain.Sheets[0].Cells[row, ColColor].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-45b3b670 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:735 | try ▸ for (row < G_MainDataDT.Rows.Count) ▸ for (col < G_MainDataDT.Columns.Count) ▸ else of (G_MainDataDT.Rows[row][col].ToString() == Text… | GRID_SET | siMain.SetValue | (row, col + 1, G_MainDataDT.Rows[row][col].ToString()) | 그리드 값 설정 |  |  |  |
| AC-845a644d | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:736 | try ▸ for (row < G_MainDataDT.Rows.Count) ▸ for (col < G_MainDataDT.Columns.Count) ▸ else of (G_MainDataDT.Rows[row][col].ToString() == Text… | GRID_SET | spdMain.Sheets[0].Cells[row, col + 1].HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Right | 그리드 속성/값 설정 |  |  |  |
| AC-cbe03a44 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:757 |  | GRID_SET | siMain.SetValue | (spdMain.Sheets[0].RowCount - 1, G_MonthValueSum_Col , String.Format("{0:#,0.0}", LOGISTIC… | 그리드 값 설정 |  |  |  |
| AC-7b28c250 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:758 |  | GRID_SET | siMain.SetValue | (spdMain.Sheets[0].RowCount - 2, G_MonthValueSum_Col, String.Format("{0:#,0}", VOLUME)) | 그리드 값 설정 |  |  |  |
| AC-d7507045 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:759 |  | GRID_SET | spdMain.Sheets[0].Cells[spdMain.Sheets[0].RowCount - 1, G_MonthValueSum_Col].HorizontalAli… | FarPoint.Win.Spread.CellHorizontalAlignment.Right | 그리드 속성/값 설정 |  |  |  |
| AC-12ed8979 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:760 |  | GRID_SET | spdMain.Sheets[0].Cells[spdMain.Sheets[0].RowCount - 2, G_MonthValueSum_Col].HorizontalAli… | FarPoint.Win.Spread.CellHorizontalAlignment.Right | 그리드 속성/값 설정 |  |  |  |
| AC-a473e6d7 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:763 |  | GRID_SET | siMain.SetValue | (spdMain.Sheets[0].RowCount-1, G_MonthValueSum_Col-1, TextMacro.LOGISTICS_COST_TOTAL) | 그리드 값 설정 |  |  |  |
| AC-d465b024 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:764 |  | GRID_SET | siMain.SetValue | (spdMain.Sheets[0].RowCount - 2, G_MonthValueSum_Col-1, TextMacro.VOLUME_TOTAL) | 그리드 값 설정 |  |  |  |
| AC-0537440e | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:777 | for (col < spdMain.Sheets[0].ColumnCount) | GRID_SET | siMain.SetValue | (spdMain.Sheets[0].RowCount - 1, col, String.Format("{0:#,0.0}", ContainrCost)) | 그리드 값 설정 |  |  |  |
| AC-7ff4fd99 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:777 | for (col < spdMain.Sheets[0].ColumnCount) | GRID_SET | spdMain.Sheets[0].Cells[spdMain.Sheets[0].RowCount - 1, col ].HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Right | 그리드 속성/값 설정 |  |  |  |
| AC-9e390900 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:778 | for (col < spdMain.Sheets[0].ColumnCount) | GRID_SET | siMain.SetValue | (spdMain.Sheets[0].RowCount - 2, col, String.Format("{0:#,0}", ContainerQty)) | 그리드 값 설정 |  |  |  |
| AC-83d2b1cb | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:778 | for (col < spdMain.Sheets[0].ColumnCount) | GRID_SET | spdMain.Sheets[0].Cells[spdMain.Sheets[0].RowCount - 2, col ].HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Right | 그리드 속성/값 설정 |  |  |  |
| AC-a579a714 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:785 | for (row < spdMain.Sheets[0].RowCount) ▸ if (spdMain.Sheets[0].GetValue(row, 6).ToString() != TextMacro.VOLUME_TOTAL && spdMain.Sheets[0].Ge… | GRID_SET | spdMain.Sheets[0].Cells[row, 7].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-b4930200 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:789 | for (row < spdMain.Sheets[0].RowCount) ▸ else of (spdMain.Sheets[0].GetValue(row, 6).ToString() != TextMacro.VOLUME_TOTAL && spdMain.Sheets[… | GRID_SET | spdMain.Sheets[0].Cells[row, 6].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |
| AC-711654eb | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:792 | for (row < spdMain.Sheets[0].RowCount) ▸ else of (spdMain.Sheets[0].GetValue(row, 6).ToString() != TextMacro.VOLUME_TOTAL && spdMain.Sheets[… | GRID_SET | spdMain.Sheets[0].Cells[row, col + 6].BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 그리드 속성/값 설정 |  |  |  |

## SSP0030_Logistics_Simulation.Make_Division_ComboBox

진입점: this.formDown.Click / this.Load / cboDivision.SelectedIndexChanged / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ad12605 | this.formDown.Click 외 3 | SSP0030_Logistics_Simulation.cs:340 | if (cboDivisionK.Items.Count > 0) | LIST_CLEAR | cboDivisionK.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-262644fb | this.formDown.Click 외 3 | SSP0030_Logistics_Simulation.cs:343 |  | DATA_OP | dt.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-656955e2 | this.formDown.Click 외 3 | SSP0030_Logistics_Simulation.cs:344 |  | DATA_OP | dt.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f344462a | this.formDown.Click 외 3 | SSP0030_Logistics_Simulation.cs:346 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6eec6a25 | this.formDown.Click 외 3 | SSP0030_Logistics_Simulation.cs:348 |  | DATA_OP | row["CODE"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-d5efe981 | this.formDown.Click 외 3 | SSP0030_Logistics_Simulation.cs:349 |  | DATA_OP | row["NAME"] | "물동량" | 행/컬럼 값 대입 |  |  |  |
| AC-aee65938 | this.formDown.Click 외 3 | SSP0030_Logistics_Simulation.cs:350 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf8ce0ca | this.formDown.Click 외 3 | SSP0030_Logistics_Simulation.cs:352 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-af8e935e | this.formDown.Click 외 3 | SSP0030_Logistics_Simulation.cs:353 |  | DATA_OP | row["CODE"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-19a9f197 | this.formDown.Click 외 3 | SSP0030_Logistics_Simulation.cs:354 |  | DATA_OP | row["NAME"] | "물류비" | 행/컬럼 값 대입 |  |  |  |
| AC-4b0fd9f8 | this.formDown.Click 외 3 | SSP0030_Logistics_Simulation.cs:355 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6485599 | this.formDown.Click 외 3 | SSP0030_Logistics_Simulation.cs:357 |  | FLAG | dtDivisionK | dt | 화면 필드/플래그 변경 |  |  |  |
| AC-9146a2a6 | this.formDown.Click 외 3 | SSP0030_Logistics_Simulation.cs:359 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivisionK, cboDivisionK, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0030_Logistics_Simulation.Make_MainDataTable

진입점: FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4daa2ce | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:960 | for (i < 7) | UI_PROP | MainGridHeader.DataType | System.Type.GetType("System.String") | 속성 DataType 설정 |  |  |  |
| AC-73ced9dd | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:964 | for (i < 7) ▸ switch (i.ToString()) case "0": | UI_PROP | MainGridHeader.ColumnName | "DIVISION_ID" | 속성 ColumnName 설정 |  |  |  |
| AC-cd08fea3 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:965 | for (i < 7) ▸ switch (i.ToString()) case "1": | UI_PROP | MainGridHeader.ColumnName | "COMPANY" | 속성 ColumnName 설정 |  |  |  |
| AC-a667f822 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:966 | for (i < 7) ▸ switch (i.ToString()) case "2": | UI_PROP | MainGridHeader.ColumnName | "TYPE" | 속성 ColumnName 설정 |  |  |  |
| AC-686c43a7 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:967 | for (i < 7) ▸ switch (i.ToString()) case "3": | UI_PROP | MainGridHeader.ColumnName | "POD_AREA" | 속성 ColumnName 설정 |  |  |  |
| AC-4200d438 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:968 | for (i < 7) ▸ switch (i.ToString()) case "4": | UI_PROP | MainGridHeader.ColumnName | "TRANSPORT_MODE" | 속성 ColumnName 설정 |  |  |  |
| AC-19ae72c0 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:969 | for (i < 7) ▸ switch (i.ToString()) case "5": | UI_PROP | MainGridHeader.ColumnName | "KUBUN" | 속성 ColumnName 설정 |  |  |  |
| AC-303a1623 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:970 | for (i < 7) ▸ switch (i.ToString()) case "6": | UI_PROP | MainGridHeader.ColumnName | "SUM" | 속성 ColumnName 설정 |  |  |  |
| AC-004d6c54 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SSP0030_Logistics_Simulation.cs:972 | for (i < 7) | DATA_OP | this.G_MainDataDT.Columns.Add | (MainGridHeader) | 데이터 객체 조작/조회 |  |  |  |

## SSP0030_Logistics_Simulation.RefreshOperationGroup

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d22198c3 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1257 | if (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-aef426dc | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1257 | if (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-73a6687b | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1261 | else of (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-57b1ca81 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1261 | else of (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a60bc28b | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1264 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0030_Logistics_Simulation.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfff8b3d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1269 |  | FLAG | dtPlanDate | Data.Common(Data.Type.DATE_WEEKLY, false, this._division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 화면 필드/플래그 변경 |  |  |  |
| AC-b683692f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1269 |  | COMBO_DATA | Data.Common | (Data.Type.DATE_WEEKLY, false, this._division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ac3262e0 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1270 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0030_Logistics_Simulation.RefreshPlanSeq

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85f8f9cc | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1282 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, this._division, this._planDate, this._planType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-eb484396 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1282 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, this._division, this._planDate, this._planType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-54a43ca5 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1283 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0030_Logistics_Simulation.RefreshPlanType

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1789bcc5 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1274 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, this._division, this._planDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-67b14306 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1274 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, this._division, this._planDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-58996aff | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1275 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4788a85d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SSP0030_Logistics_Simulation.cs:1278 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SSP0030_Logistics_Simulation.Select_KUBUN

진입점: cboDivisionK.SelectedIndexChanged [if (spdMain.Sheets[0].RowCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb24d6b1 | cboDivisionK.SelectedIndexChanged [if (spdMain.Sheets[0].Row… | SSP0030_Logistics_Simulation.cs:803 | if (Kubun == "A" \|\| Kubun == "T") ▸ for (row < spdMain.Sheets[0].RowCount) | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (row, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82cf1ea6 | cboDivisionK.SelectedIndexChanged [if (spdMain.Sheets[0].Row… | SSP0030_Logistics_Simulation.cs:821 | else of (Kubun == "A" \|\| Kubun == "T") ▸ try ▸ for (row < spdMain.Sheets[0].RowCount) ▸ if (spdMain.Sheets[0].GetValue(row, Index).ToStrin… | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (row, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2a4c1a8 | cboDivisionK.SelectedIndexChanged [if (spdMain.Sheets[0].Row… | SSP0030_Logistics_Simulation.cs:822 | else of (Kubun == "A" \|\| Kubun == "T") ▸ try ▸ for (row < spdMain.Sheets[0].RowCount) ▸ if (spdMain.Sheets[0].GetValue(row, Index).ToStrin… | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (row, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04f04a55 | cboDivisionK.SelectedIndexChanged [if (spdMain.Sheets[0].Row… | SSP0030_Logistics_Simulation.cs:827 | else of (Kubun == "A" \|\| Kubun == "T") ▸ try ▸ for (row < spdMain.Sheets[0].RowCount) ▸ else of (spdMain.Sheets[0].GetValue(row, Index).To… | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (row, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a268f92 | cboDivisionK.SelectedIndexChanged [if (spdMain.Sheets[0].Row… | SSP0030_Logistics_Simulation.cs:828 | else of (Kubun == "A" \|\| Kubun == "T") ▸ try ▸ for (row < spdMain.Sheets[0].RowCount) ▸ else of (spdMain.Sheets[0].GetValue(row, Index).To… | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (row, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1ef8c0c | cboDivisionK.SelectedIndexChanged [if (spdMain.Sheets[0].Row… | SSP0030_Logistics_Simulation.cs:838 | else of (Kubun == "A" \|\| Kubun == "T") ▸ try ▸ if (Kubun == "0") | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (spdMain.Sheets[0].RowCount - 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba6aafd7 | cboDivisionK.SelectedIndexChanged [if (spdMain.Sheets[0].Row… | SSP0030_Logistics_Simulation.cs:838 | else of (Kubun == "A" \|\| Kubun == "T") ▸ try ▸ if (Kubun == "0") | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (spdMain.Sheets[0].RowCount - 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-70bfda41 | cboDivisionK.SelectedIndexChanged [if (spdMain.Sheets[0].Row… | SSP0030_Logistics_Simulation.cs:840 | else of (Kubun == "A" \|\| Kubun == "T") ▸ try ▸ else of (Kubun == "0") | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (spdMain.Sheets[0].RowCount - 1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eaea0cd3 | cboDivisionK.SelectedIndexChanged [if (spdMain.Sheets[0].Row… | SSP0030_Logistics_Simulation.cs:840 | else of (Kubun == "A" \|\| Kubun == "T") ▸ try ▸ else of (Kubun == "0") | CALL_EXT | this.spdMain.Sheets[0].SetRowVisible | (spdMain.Sheets[0].RowCount - 2, false) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0030_Logistics_Simulation.Set_FixButtonEnabled

진입점: this.Load / cboPlanDate.SelectedIndexChanged / cboPlanType.SelectedIndexChanged / cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b68d3049 | this.Load 외 3 | SSP0030_Logistics_Simulation.cs:1294 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-36843576 | this.Load 외 3 | SSP0030_Logistics_Simulation.cs:1295 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2e9a7c23 | this.Load 외 3 | SSP0030_Logistics_Simulation.cs:1296 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-62ee12a4 | this.Load 외 3 | SSP0030_Logistics_Simulation.cs:1303 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | DATA_OP | dtPlanSeq.AsEnumerable().Select | (a => a.Field<int>("CODE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e53097b0 | this.Load 외 3 | SSP0030_Logistics_Simulation.cs:1303 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | DATA_OP | a.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a9070bf | this.Load 외 3 | SSP0030_Logistics_Simulation.cs:1307 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnFix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c9591f0f | this.Load 외 3 | SSP0030_Logistics_Simulation.cs:1308 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnUnfix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7762faca | this.Load 외 3 | SSP0030_Logistics_Simulation.cs:1313 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-98536050 | this.Load 외 3 | SSP0030_Logistics_Simulation.cs:1314 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b7a90039 | this.Load 외 3 | SSP0030_Logistics_Simulation.cs:1315 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0030_Logistics_Simulation.Set_MainDataTable

진입점: FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (OriginDT < OriginData.Tables[0].Rows.Count) ▸ if (OriginDT == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e819526c | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1010 | if (Option == 0) ▸ for (i < 2) | DATA_OP | this.G_MainDataDT.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a7a0b412 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1012 | if (Option == 0) ▸ for (i < 2) | DATA_OP | dr["DIVISION_ID"] | DIVI | 행/컬럼 값 대입 |  |  |  |
| AC-444486c6 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1013 | if (Option == 0) ▸ for (i < 2) | DATA_OP | dr["COMPANY"] | COMP | 행/컬럼 값 대입 |  |  |  |
| AC-96928442 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1014 | if (Option == 0) ▸ for (i < 2) | DATA_OP | dr["TYPE"] | TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-7ed58edd | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1015 | if (Option == 0) ▸ for (i < 2) | DATA_OP | dr["POD_AREA"] | POD | 행/컬럼 값 대입 |  |  |  |
| AC-990309db | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1016 | if (Option == 0) ▸ for (i < 2) | DATA_OP | dr["TRANSPORT_MODE"] | TRANS | 행/컬럼 값 대입 |  |  |  |
| AC-d1f512dd | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1020 | if (Option == 0) ▸ for (i < 2) ▸ if (i == 0) | DATA_OP | dr["KUBUN"] | TextMacro.VOLUME | 행/컬럼 값 대입 |  |  |  |
| AC-ae1d44ea | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1030 | if (Option == 0) ▸ for (i < 2) ▸ if (i == 0) ▸ if (sep3.Length > 0) ▸ for (j < sep3.Length) ▸ if (sep3[j].ToString() != "" && sep3[j].ToStri… | DATA_OP | dr[G_Month[j].ToString()] | String.Format("{0,10:N0}", System.Convert.ToDecimal(sep3[j].ToString())).Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-6c07674a | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1033 | if (Option == 0) ▸ for (i < 2) ▸ if (i == 0) ▸ if (sep3.Length > 0) ▸ for (j < sep3.Length) ▸ else of (sep3[j].ToString() != "" && sep3[j].T… | DATA_OP | dr[G_Month[j].ToString()] | null | 행/컬럼 값 대입 |  |  |  |
| AC-473eb6f0 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1036 | if (Option == 0) ▸ for (i < 2) ▸ if (i == 0) ▸ if (sep3.Length > 0) | DATA_OP | dr["SUM"] | String.Format("{0:#,0}", Column_ContainerQty_SUM).ToString().Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-cb08e61f | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1038 | if (Option == 0) ▸ for (i < 2) ▸ if (i == 0) ▸ if (sep3.Length > 0) | DATA_OP | this.G_MainDataDT.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-f93c98bb | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1044 | if (Option == 0) ▸ for (i < 2) ▸ else of (i == 0) | DATA_OP | dr["KUBUN"] | TextMacro.LOGISTICS_COST | 행/컬럼 값 대입 |  |  |  |
| AC-41d020c0 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1053 | if (Option == 0) ▸ for (i < 2) ▸ else of (i == 0) ▸ if (sep3.Length > 0) ▸ for (j < sep3.Length) ▸ if (sep3[j].ToString() != "" && sep3[j].T… | DATA_OP | dr[G_Month[j].ToString()] | String.Format("{0,10:N1}", System.Convert.ToDecimal(sep3[j].ToString())).Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-953364d4 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1057 | if (Option == 0) ▸ for (i < 2) ▸ else of (i == 0) ▸ if (sep3.Length > 0) ▸ for (j < sep3.Length) ▸ else of (sep3[j].ToString() != "" && sep3… | DATA_OP | dr[G_Month[j].ToString()] | null | 행/컬럼 값 대입 |  |  |  |
| AC-dd5aefb6 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1060 | if (Option == 0) ▸ for (i < 2) ▸ else of (i == 0) ▸ if (sep3.Length > 0) | DATA_OP | dr["SUM"] | String.Format("{0:#,0.0}", Column_ContainrCost_SUM).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5bc0afa3 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1062 | if (Option == 0) ▸ for (i < 2) ▸ else of (i == 0) ▸ if (sep3.Length > 0) | DATA_OP | this.G_MainDataDT.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-f26ea44d | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1070 | else of (Option == 0) | DATA_OP | this.G_MainDataDT.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-07253ab8 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1071 | else of (Option == 0) | DATA_OP | dr["DIVISION_ID"] | DIVI | 행/컬럼 값 대입 |  |  |  |
| AC-5b96fbbb | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1072 | else of (Option == 0) | DATA_OP | dr["COMPANY"] | COMP | 행/컬럼 값 대입 |  |  |  |
| AC-485cd3d4 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1073 | else of (Option == 0) | DATA_OP | dr["TYPE"] | TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-453a6ee8 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1074 | else of (Option == 0) | DATA_OP | dr["POD_AREA"] | KUBUN | 행/컬럼 값 대입 |  |  |  |
| AC-50f91cb3 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1075 | else of (Option == 0) | DATA_OP | dr["TRANSPORT_MODE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-19a6978d | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1076 | else of (Option == 0) | DATA_OP | dr["KUBUN"] | TextMacro.LOGISTICS_COST | 행/컬럼 값 대입 |  |  |  |
| AC-b259ac49 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1089 | else of (Option == 0) ▸ if (sep3.Length > 0) ▸ for (j < sep3.Length) ▸ if (sep3[j].ToString() != "" && sep3[j].ToString() != null) | DATA_OP | dr[G_Month[j].ToString()] | String.Format("{0,10:N1}", System.Convert.ToDecimal(sep3[j].ToString())) | 행/컬럼 값 대입 |  |  |  |
| AC-f519b340 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1094 | else of (Option == 0) ▸ if (sep3.Length > 0) ▸ for (j < sep3.Length) ▸ else of (sep3[j].ToString() != "" && sep3[j].ToString() != null) | DATA_OP | dr[G_Month[j].ToString()] | null | 행/컬럼 값 대입 |  |  |  |
| AC-46114bff | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1098 | else of (Option == 0) ▸ if (sep3.Length > 0) ▸ if (Check == true) | DATA_OP | dr["SUM"] | String.Format("{0:#,0.0}", Column_ContainrCost_SUM).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9f003272 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1099 | else of (Option == 0) ▸ if (sep3.Length > 0) ▸ else of (Check == true) | DATA_OP | dr["SUM"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-ab8319f1 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ for (Or… | SSP0030_Logistics_Simulation.cs:1101 | else of (Option == 0) ▸ if (sep3.Length > 0) | DATA_OP | this.G_MainDataDT.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |

## SSP0030_Logistics_Simulation.Set_PIVOT_DATE

진입점: FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e857c02 | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1109 |  | FLAG | G_TempYearMonthly | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1f594749 | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1110 | if (G_TempYear.Count > 0) | CALL_EXT | G_TempYear.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e98810b2 | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1126 | if (month_diff == 0) | FLAG | G_TempYearMonthly | += FDate.Substring(0, 6) + "," | 화면 필드/플래그 변경 |  |  |  |
| AC-22e7e887 | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1128 | if (month_diff == 0) | DATA_OP | G_TempYear.Contains | (FDate.Substring(0, 4)) | 데이터 객체 조작/조회 |  |  |  |
| AC-79b17974 | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1129 | if (month_diff == 0) ▸ if (G_TempYear.Contains(FDate.Substring(0, 4)) == false) | DATA_OP | G_TempYear.Add | (FDate.Substring(0, 4)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d02a4cb4 | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1133 | else of (month_diff == 0) | FLAG | G_TempYearMonthly | += FDate.Substring(0, 6) + "," | 화면 필드/플래그 변경 |  |  |  |
| AC-ed245b9c | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1135 | else of (month_diff == 0) | DATA_OP | G_TempYear.Contains | (FDate.Substring(0, 4)) | 데이터 객체 조작/조회 |  |  |  |
| AC-40f7bf10 | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1136 | else of (month_diff == 0) ▸ if (G_TempYear.Contains(FDate.Substring(0, 4)) == false) | DATA_OP | G_TempYear.Add | (FDate.Substring(0, 4)) | 데이터 객체 조작/조회 |  |  |  |
| AC-47b41c28 | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1144 | else of (month_diff == 0) ▸ for (i < month_diff) ▸ if (YEAR == null) ▸ if (FDate.Substring(4, 2) != "12") | CALL_EXT | (System.Convert.ToInt32(FDate.Substring(4, 2)) + 1).ToString().PadLeft | (2, '0') | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4e13c35 | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1168 | else of (month_diff == 0) ▸ for (i < month_diff) ▸ else of (YEAR == null) ▸ else of (CheckMonth == true) | CALL_EXT | (System.Convert.ToInt32(MONTH) + 1).ToString().PadLeft | (2, '0') | ⚠ 의미 확인 필요 |  |  |  |
| AC-c61c4a2d | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1175 | else of (month_diff == 0) ▸ for (i < month_diff) | FLAG | G_TempYearMonthly | += YEAR + MONTH + "," | 화면 필드/플래그 변경 |  |  |  |
| AC-9550e09c | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1177 | else of (month_diff == 0) ▸ for (i < month_diff) | DATA_OP | G_TempYear.Contains | (YEAR) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0ef2a0d | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1178 | else of (month_diff == 0) ▸ for (i < month_diff) ▸ if (G_TempYear.Contains(YEAR) == false) | DATA_OP | G_TempYear.Add | (YEAR) | 데이터 객체 조작/조회 |  |  |  |
| AC-67da4ccd | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1182 |  | FLAG | G_TempYearMonthly | G_TempYearMonthly.Substring(0, G_TempYearMonthly.Length - 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-78404f37 | FindButton [try ▸ lambda] | SSP0030_Logistics_Simulation.cs:1184 |  | RETURN | return strDate.Substring(0, strDate.Length - 1); |  | 처리 중단/반환 |  |  |  |

## SSP0030_Logistics_Simulation.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d434608 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:262 |  | FLAG | G_TempYearMonthly | null | 화면 필드/플래그 변경 |  |  |  |
| AC-286bc186 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:264 |  | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.AllPlantSiteDescription, false, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-254b31ce | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:264 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.AllPlantSiteDescription, false, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-11026854 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:271 | try | DATA_OP | dtCompany.Select().Where(c => c["DIVISION_ID"].ToString() == strSelDivision_ID).CopyToData… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f51de1f1 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:271 | try | DATA_OP | dtCompany.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b3b64d4c | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:272 | try | LIST_REBIND | clsCtrl.setListBox | (dtDiv_Company_ID, clbCompany_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-17eaf405 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:289 | if (!this._division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-9126d4dd | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:290 | if (!this._division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-59b8f531 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:294 | else of (!this._division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3549ba6c | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:299 |  | FLAG | dtInconterms | Data_SCP.Common(Data_SCP.Type.ssp0019_Incoterms, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-c0335079 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:299 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ssp0019_Incoterms, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-223d0ee1 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:300 |  | FLAG | dtTransMode | Data_SCP.Common(Data_SCP.Type.ssp0019_TransportMode, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-7934b0fa | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:300 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ssp0019_TransportMode, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0e59eb39 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:302 |  | LIST_REBIND | clsCtrl.setListBox | (dtInconterms, clbIncomterms, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-087fb8c6 | this.Load 외 1 | SSP0030_Logistics_Simulation.cs:303 |  | LIST_REBIND | clsCtrl.setListBox | (dtTransMode, clbTransportMode, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0030_Logistics_Simulation.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77d4b739 | this.spdMain.CellDoubleClick | SSP0030_Logistics_Simulation.cs:1598 |  | FLAG | G_ClickValues | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d4fc45ad | this.spdMain.CellDoubleClick | SSP0030_Logistics_Simulation.cs:1599 |  | FLAG | G_SearchCondition | "0" | 화면 필드/플래그 변경 |  |  |  |
| AC-ad23be48 | this.spdMain.CellDoubleClick | SSP0030_Logistics_Simulation.cs:1610 | try ▸ if (e.Column == G_MonthValueSum_Row) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null && this.spdMain.Sheets[0].GetValue… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9cea64bc | this.spdMain.CellDoubleClick | SSP0030_Logistics_Simulation.cs:1615 | try ▸ if (e.Column == G_MonthValueSum_Row) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null && this.spdMain.Sheets[0].GetValue… | FLAG | G_ClickValues | spdMain.Sheets[0].GetValue(e.Row, 4).ToString() + "/" + spdMain.Sheets[0].GetValue(e.Row, … | 화면 필드/플래그 변경 |  |  |  |
| AC-81088e1c | this.spdMain.CellDoubleClick | SSP0030_Logistics_Simulation.cs:1617 | try ▸ if (e.Column == G_MonthValueSum_Row) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null && this.spdMain.Sheets[0].GetValue… | FLAG | G_ClickValues | spdMain.Sheets[0].GetValue(e.Row, 4).ToString() + "/" + spdMain.Sheets[0].GetValue(e.Row, … | 화면 필드/플래그 변경 |  |  |  |

## SSP0030_Logistics_Simulation.txt_exchangerate_KeyPress

진입점: txt_exchangerate.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08755d6e | txt_exchangerate.KeyPress | SSP0030_Logistics_Simulation.cs:1590 |  | CALL_EXT | Char.IsDigit | (e.KeyChar) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dff6c583 | txt_exchangerate.KeyPress | SSP0030_Logistics_Simulation.cs:1592 | if (!(Char.IsDigit(e.KeyChar)) && e.KeyChar != '.' && e.KeyChar != 8) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |

## SSP0030_Logistics_Simulation.UpdateData

진입점: this.formDown.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)] / this.spdMain.CellDoubleClick [try ▸ if (e.Column == G_MonthValueSum_Row) ▸ if (this.spdMain.Sheets[0].GetValue(e.Row, e.Column) != null && this.spdMain.Sheets[0].GetValue(e.Row, e.Column).ToString() …) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / btn_Noinfo.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c77d11d0 | this.formDown.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 2 | SSP0030_Logistics_Simulation.cs:582 | for (row < dt.Rows.Count) ▸ for (col < dt.Columns.Count) ▸ if (dt.Columns[col].ColumnName.ToString() == "CONTAINER_QTY" \|\| dt.Columns[col]… | DATA_OP | dt.Rows[row].BeginEdit | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eea4c7d4 | this.formDown.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 2 | SSP0030_Logistics_Simulation.cs:590 | for (row < dt.Rows.Count) ▸ for (col < dt.Columns.Count) ▸ if (dt.Columns[col].ColumnName.ToString() == "CONTAINER_QTY" \|\| dt.Columns[col]… | GRID_SET | dt.Rows[row]["CONTAINER_QTY"] | String.Format("{0:#,0.000}", CoNumber) | 그리드 속성/값 설정 |  |  |  |
| AC-dd5089cf | this.formDown.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 2 | SSP0030_Logistics_Simulation.cs:598 | for (row < dt.Rows.Count) ▸ for (col < dt.Columns.Count) ▸ if (dt.Columns[col].ColumnName.ToString() == "CONTAINER_QTY" \|\| dt.Columns[col]… | GRID_SET | dt.Rows[row]["CONTAINER_COST"] | String.Format("{0:#,0.0}", CoNumber) | 그리드 속성/값 설정 |  |  |  |
| AC-74457130 | this.formDown.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 2 | SSP0030_Logistics_Simulation.cs:606 | for (row < dt.Rows.Count) ▸ for (col < dt.Columns.Count) ▸ if (dt.Columns[col].ColumnName.ToString() == "CONTAINER_QTY" \|\| dt.Columns[col]… | GRID_SET | dt.Rows[row]["SEMI_EX_COST"] | String.Format("{0:#,0.0}", CoNumber) | 그리드 속성/값 설정 |  |  |  |
| AC-4b570859 | this.formDown.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 2 | SSP0030_Logistics_Simulation.cs:614 | for (row < dt.Rows.Count) ▸ for (col < dt.Columns.Count) ▸ if (dt.Columns[col].ColumnName.ToString() == "CONTAINER_QTY" \|\| dt.Columns[col]… | GRID_SET | dt.Rows[row]["FG_EX_COST"] | String.Format("{0:#,0.0}", CoNumber) | 그리드 속성/값 설정 |  |  |  |
| AC-812505db | this.formDown.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 2 | SSP0030_Logistics_Simulation.cs:618 | for (row < dt.Rows.Count) ▸ for (col < dt.Columns.Count) ▸ if (dt.Columns[col].ColumnName.ToString() == "CONTAINER_QTY" \|\| dt.Columns[col]… | DATA_OP | dt.Rows[row].EndEdit | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a28b3710 | this.formDown.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 2 | SSP0030_Logistics_Simulation.cs:619 | for (row < dt.Rows.Count) ▸ for (col < dt.Columns.Count) ▸ if (dt.Columns[col].ColumnName.ToString() == "CONTAINER_QTY" \|\| dt.Columns[col]… | DATA_OP | dt.Rows[row].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |


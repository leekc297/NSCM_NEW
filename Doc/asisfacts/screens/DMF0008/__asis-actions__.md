# AS-IS 액션 대조표 — DMF0008

> 원천: `Doc/asisfacts/screens/DMF0008/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 674행 · 메서드 46 · 종류 GRID_SET 134 · DATA_OP 130 · GRID_LOCK 84 · RETURN 46 · ENDPOINT 40 · FLAG 39 · UI_PROP 37 · POPUP 36 · MESSAGE 29 · UI_MISC 25 · GRID_INIT 19 · COMBO_DATA 19 · GRID_BIND 8 · LIST_REBIND 8 · VALUE_SET 5 · GRID_COMBO 5 · GRID_CLEAR 4 · CALL_EXT 3 · STATE_RESET 2 · THROW 1 · ⚠ 의미 확인 필요 3


## DMF0008_ErpEdiMaster.btnStatusUpdate_Click

진입점: this.btnStatusUpdate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f6f9b7a | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3000 |  | GRID_CLEAR | siRepair.ActiveSheet.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-32196611 | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3001 |  | GRID_CLEAR | siSub.ActiveSheet.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-67c43386 | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3004 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1e2da022 | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3005 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e5f5c7a0 | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3009 |  | UI_MISC | siSummary.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b42d0386 | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3020 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-09749634 | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3022 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ef563138 | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3027 | lambda | ENDPOINT | new FoxDataRequest | ("DM.PR_DM_DNM_EDI_CALLOFF_STATUS") ⇒ DM.PR_DM_DNM_EDI_CALLOFF_STATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-b29487c7 | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3028 | lambda | UI_PROP | request.CommandTimeout | 10 * 600 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1b733621 | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3029 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e3a30ff0 | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3030 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3958527f | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3038 |  | GRID_BIND | siSummary.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-976a2e2d | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3039 |  | GRID_LOCK | siSummary.LockColumn | (0, siSummary.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-caf14822 | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3041 |  | GRID_INIT | siSummary.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-020da5ff | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3048 |  | UI_MISC | siSummary.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-444ea410 | this.btnStatusUpdate.Click | DMF0008_ErpEdiMaster.cs:3050 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0008_ErpEdiMaster.clbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ab0f193 | clbDivision.SelectedIndexChanged | DMF0008_ErpEdiMaster.cs:1995 |  | GRID_SET | siSummary.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |

## DMF0008_ErpEdiMaster.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-280d987c | this.Load | DMF0008_ErpEdiMaster.cs:437 |  | GRID_INIT | this.AddSheet | (spdSummary, SpdSheet.shtSummary, SpdSheet.shtSummary, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-834c353a | this.Load | DMF0008_ErpEdiMaster.cs:438 |  | FLAG | siSummary | GetSheetInfo(spdSummary.Name, spdSummary.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7fbb5654 | this.Load | DMF0008_ErpEdiMaster.cs:442 |  | GRID_INIT | this.AddSheet | (spdRepair, SpdSheet.shtRepair, SpdSheet.shtRepair, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c357c184 | this.Load | DMF0008_ErpEdiMaster.cs:443 |  | FLAG | siRepair | GetSheetInfo(spdRepair.Name, spdRepair.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0304e2e3 | this.Load | DMF0008_ErpEdiMaster.cs:446 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSales_Site, SpdSheet.shtSales_Site, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4c0d44fb | this.Load | DMF0008_ErpEdiMaster.cs:447 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSales_Site) | 화면 필드/플래그 변경 |  |  |  |
| AC-352b3a47 | this.Load | DMF0008_ErpEdiMaster.cs:450 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSSPM, SpdSheet.shtSSPM, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e2efb015 | this.Load | DMF0008_ErpEdiMaster.cs:451 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSSPM) | 화면 필드/플래그 변경 |  |  |  |
| AC-461fff45 | this.Load | DMF0008_ErpEdiMaster.cs:454 |  | UI_PROP | siSub.ActiveSheetIndex | 0 | 속성 ActiveSheetIndex 설정 |  |  |  |
| AC-f2994e4d | this.Load | DMF0008_ErpEdiMaster.cs:456 |  | GRID_INIT | siRepair.ChangeSheet | (SpdSheet.shtRepair) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81d094f5 | this.Load | DMF0008_ErpEdiMaster.cs:460 |  | GRID_INIT | siSummary.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0008_ErpEdiMaster.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2185fffd | this.Load | DMF0008_ErpEdiMaster.cs:416 |  | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a97a8c4c | this.Load | DMF0008_ErpEdiMaster.cs:418 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | FLAG | sMyDeptID | Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 화면 필드/플래그 변경 |  |  |  |
| AC-eb163c29 | this.Load | DMF0008_ErpEdiMaster.cs:418 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-62bc4954 | this.Load | DMF0008_ErpEdiMaster.cs:421 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-1c4dc766 | this.Load | DMF0008_ErpEdiMaster.cs:422 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-45a5a5c3 | this.Load | DMF0008_ErpEdiMaster.cs:423 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-3b32e32d | this.Load | DMF0008_ErpEdiMaster.cs:424 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-dbd15cc6 | this.Load | DMF0008_ErpEdiMaster.cs:425 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DMF0008_ErpEdiMaster.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca4f1cd6 | Dispose | DMF0008_ErpEdiMaster.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0008_ErpEdiMaster.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-daeea91c | EditButton | DMF0008_ErpEdiMaster.cs:561 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d2667b80 | EditButton | DMF0008_ErpEdiMaster.cs:562 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4fa00ce | EditButton | DMF0008_ErpEdiMaster.cs:567 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siSummary.IsLock(siSummary.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siSummary.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName }… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a76b286e | EditButton | DMF0008_ErpEdiMaster.cs:568 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siSummary.IsLock(siSummary.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75cd3191 | EditButton | DMF0008_ErpEdiMaster.cs:572 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb94ea22 | EditButton | DMF0008_ErpEdiMaster.cs:573 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-97342ee9 | EditButton | DMF0008_ErpEdiMaster.cs:588 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.sS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c6746b7c | EditButton | DMF0008_ErpEdiMaster.cs:598 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.sDIVISION_ID), iRow, siSub.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1c372929 | EditButton | DMF0008_ErpEdiMaster.cs:599 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.sSCM_SITE_ID), iRow, siSub.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1b4b3f9c | EditButton | DMF0008_ErpEdiMaster.cs:600 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.sREP_SOLDTO_CODE), iRow, siSub.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3f0ea5ae | EditButton | DMF0008_ErpEdiMaster.cs:601 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.sREP_SHIPTO_CODE), iRow, siSub.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-624e0b23 | EditButton | DMF0008_ErpEdiMaster.cs:602 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.sLAST_UPDATE_DATE), iRow, siSub.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c9c0946f | EditButton | DMF0008_ErpEdiMaster.cs:603 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.sLAST_UPDATED_BY), iRow, siSub.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0cf6a404 | EditButton | DMF0008_ErpEdiMaster.cs:609 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pEND_CUSTOMER)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-71495680 | EditButton | DMF0008_ErpEdiMaster.cs:610 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pSOLDTO_CUSTOMER)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-ae41842c | EditButton | DMF0008_ErpEdiMaster.cs:611 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCOMPANY_ID)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-57c4ff5b | EditButton | DMF0008_ErpEdiMaster.cs:612 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sVMI_YN)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-780c0f85 | EditButton | DMF0008_ErpEdiMaster.cs:613 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sSITE_VALID_YN)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-3e792933 | EditButton | DMF0008_ErpEdiMaster.cs:614 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCUSTOMER_VALID_YN)].BackCol… | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-c95c33d1 | EditButton | DMF0008_ErpEdiMaster.cs:615 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sREP_YN)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-db532edd | EditButton | DMF0008_ErpEdiMaster.cs:616 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCOUNTRY_NAME)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-1a058fba | EditButton | DMF0008_ErpEdiMaster.cs:617 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCITY_NAME)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-30bdfbcb | EditButton | DMF0008_ErpEdiMaster.cs:618 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sSHIP_PLAN_AUTO)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-30415a09 | EditButton | DMF0008_ErpEdiMaster.cs:622 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pEND_CUSTOMER)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-2bdd258a | EditButton | DMF0008_ErpEdiMaster.cs:623 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pSOLDTO_CUSTOMER)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-d9f6a475 | EditButton | DMF0008_ErpEdiMaster.cs:624 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCOMPANY_ID)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-7fbc9668 | EditButton | DMF0008_ErpEdiMaster.cs:625 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sVMI_YN)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-86b4e9b8 | EditButton | DMF0008_ErpEdiMaster.cs:626 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sSITE_VALID_YN)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-8209cc61 | EditButton | DMF0008_ErpEdiMaster.cs:627 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCUSTOMER_VALID_YN)].BackCol… | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-e29be3c6 | EditButton | DMF0008_ErpEdiMaster.cs:628 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sREP_YN)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-bdb3f440 | EditButton | DMF0008_ErpEdiMaster.cs:629 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCOUNTRY_NAME)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-174ea63a | EditButton | DMF0008_ErpEdiMaster.cs:630 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCITY_NAME)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-bfaa96b5 | EditButton | DMF0008_ErpEdiMaster.cs:631 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sSHIP_PLAN_AUTO)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-1f77d3a1 | EditButton | DMF0008_ErpEdiMaster.cs:640 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pEND_CUSTOMER)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-a4cb9bf5 | EditButton | DMF0008_ErpEdiMaster.cs:641 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pSOLDTO_CUSTOMER)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-7c3af53d | EditButton | DMF0008_ErpEdiMaster.cs:642 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCOMPANY_ID)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-620be1a7 | EditButton | DMF0008_ErpEdiMaster.cs:643 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sVMI_YN)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-ee7aadc7 | EditButton | DMF0008_ErpEdiMaster.cs:644 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sSITE_VALID_YN)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-bb2601a0 | EditButton | DMF0008_ErpEdiMaster.cs:645 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCUSTOMER_VALID_YN)].BackCol… | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-b643b1ea | EditButton | DMF0008_ErpEdiMaster.cs:646 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sREP_YN)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-3a22c24a | EditButton | DMF0008_ErpEdiMaster.cs:647 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCOUNTRY_NAME)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-eaf5d5c0 | EditButton | DMF0008_ErpEdiMaster.cs:648 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCITY_NAME)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-a2714f7d | EditButton | DMF0008_ErpEdiMaster.cs:649 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sSHIP_PLAN_AUTO)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-94e81533 | EditButton | DMF0008_ErpEdiMaster.cs:653 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pEND_CUSTOMER)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-03ca4bbb | EditButton | DMF0008_ErpEdiMaster.cs:654 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pSOLDTO_CUSTOMER)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-5696a0d3 | EditButton | DMF0008_ErpEdiMaster.cs:655 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCOMPANY_ID)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-d3764538 | EditButton | DMF0008_ErpEdiMaster.cs:656 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sVMI_YN)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-55140c7f | EditButton | DMF0008_ErpEdiMaster.cs:657 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sSITE_VALID_YN)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-e4c58914 | EditButton | DMF0008_ErpEdiMaster.cs:658 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCUSTOMER_VALID_YN)].BackCol… | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-24acebb7 | EditButton | DMF0008_ErpEdiMaster.cs:659 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sREP_YN)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-207735fb | EditButton | DMF0008_ErpEdiMaster.cs:660 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCOUNTRY_NAME)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-e66b5fae | EditButton | DMF0008_ErpEdiMaster.cs:661 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCITY_NAME)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-8e4ed15b | EditButton | DMF0008_ErpEdiMaster.cs:662 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ for (iRow <= siSub.GetMaxRowInde… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sSHIP_PLAN_AUTO)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-4e8a2252 | EditButton | DMF0008_ErpEdiMaster.cs:678 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.pS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7a214d4e | EditButton | DMF0008_ErpEdiMaster.cs:685 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pBPMS_EXIST), iRow, siSub.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5923d012 | EditButton | DMF0008_ErpEdiMaster.cs:686 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pCATHODE_MATERIALS), iRow, siSub.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-028fec87 | EditButton | DMF0008_ErpEdiMaster.cs:688 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pCELL_PER_CAR), iRow, siSub.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fe363582 | EditButton | DMF0008_ErpEdiMaster.cs:689 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pCELL_PER_MODULE), iRow, siSub.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-47de44b1 | EditButton | DMF0008_ErpEdiMaster.cs:691 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pCELL_TYPE_81), iRow, siSub.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9e2a7d90 | EditButton | DMF0008_ErpEdiMaster.cs:694 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pCURRENCY), iRow, siSub.GetColumnIndex(DefColumns.p… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8816ae33 | EditButton | DMF0008_ErpEdiMaster.cs:697 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pCUSTOMER_MODEL), iRow, siSub.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c1cefc49 | EditButton | DMF0008_ErpEdiMaster.cs:698 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pDEPT_ID), iRow, siSub.GetColumnIndex(DefColumns.pD… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5fc2d120 | EditButton | DMF0008_ErpEdiMaster.cs:701 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pDEPT_ID2), iRow, siSub.GetColumnIndex(DefColumns.p… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5ceb707d | EditButton | DMF0008_ErpEdiMaster.cs:702 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pCUST_GROUP), iRow, siSub.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2d25b6cd | EditButton | DMF0008_ErpEdiMaster.cs:703 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pEND_CUSTOMER40), iRow, siSub.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-df6d8246 | EditButton | DMF0008_ErpEdiMaster.cs:704 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pSCM_SITE_ID40), iRow, siSub.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bbba0d47 | EditButton | DMF0008_ErpEdiMaster.cs:705 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pCELL_TYPE), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-974c02a7 | EditButton | DMF0008_ErpEdiMaster.cs:706 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pPRODUCTION_PROCESS), iRow, siSub.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e72ac769 | EditButton | DMF0008_ErpEdiMaster.cs:707 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pCUST_GROUP_DTL), iRow, siSub.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-16d6e2ae | EditButton | DMF0008_ErpEdiMaster.cs:708 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pROUTE), iRow, siSub.GetColumnIndex(DefColumns.pROU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8144a569 | EditButton | DMF0008_ErpEdiMaster.cs:709 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pEDIT_FLAG2), iRow, siSub.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-afa6b445 | EditButton | DMF0008_ErpEdiMaster.cs:710 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pEDIT_FLAG3), iRow, siSub.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3f7c7e7c | EditButton | DMF0008_ErpEdiMaster.cs:715 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pSALES_PLAN_ADJUST_YN), iRow, siSub.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-be86e505 | EditButton | DMF0008_ErpEdiMaster.cs:716 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pCELL_TYPE_82), iRow, siSub.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-06c930f4 | EditButton | DMF0008_ErpEdiMaster.cs:717 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pCELL_NAME), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d91e303c | EditButton | DMF0008_ErpEdiMaster.cs:718 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pPARTIAL_PLAN_YN), iRow, siSub.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9d6db347 | EditButton | DMF0008_ErpEdiMaster.cs:721 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pDIVISION_ID), iRow, siSub.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-63f2010b | EditButton | DMF0008_ErpEdiMaster.cs:723 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pEDI_LT), iRow, siSub.GetColumnIndex(DefColumns.pED… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a5f750b9 | EditButton | DMF0008_ErpEdiMaster.cs:726 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pEND_CUSTOMER), iRow, siSub.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9cd21aa0 | EditButton | DMF0008_ErpEdiMaster.cs:729 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pITEM_CLASS_NAME), iRow, siSub.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c9c7fc77 | EditButton | DMF0008_ErpEdiMaster.cs:730 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pITEM_ID), iRow, siSub.GetColumnIndex(DefColumns.pI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c0e419fc | EditButton | DMF0008_ErpEdiMaster.cs:731 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pITEM_NAME), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e77de73c | EditButton | DMF0008_ErpEdiMaster.cs:732 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pITEM_TYPE), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e9f44678 | EditButton | DMF0008_ErpEdiMaster.cs:733 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pKWH), iRow, siSub.GetColumnIndex(DefColumns.pKWH),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2774c648 | EditButton | DMF0008_ErpEdiMaster.cs:734 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pLAST_UPDATE_DATE), iRow, siSub.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b2bd7892 | EditButton | DMF0008_ErpEdiMaster.cs:735 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pLAST_UPDATED_BY), iRow, siSub.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9b1c0024 | EditButton | DMF0008_ErpEdiMaster.cs:736 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pLIABILITY_PERIOD), iRow, siSub.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-05e98f6d | EditButton | DMF0008_ErpEdiMaster.cs:737 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pMODULE_PER_CAR), iRow, siSub.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb07c06f | EditButton | DMF0008_ErpEdiMaster.cs:738 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pMODULE_VARIANT), iRow, siSub.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-90472cce | EditButton | DMF0008_ErpEdiMaster.cs:739 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pNICK_NAME), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0a6518ed | EditButton | DMF0008_ErpEdiMaster.cs:741 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pOWNER), iRow, siSub.GetColumnIndex(DefColumns.pOWN… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f6c1b57d | EditButton | DMF0008_ErpEdiMaster.cs:744 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pPROJECT_CODE), iRow, siSub.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-099b9d45 | EditButton | DMF0008_ErpEdiMaster.cs:745 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pPROJECT_NAME), iRow, siSub.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6e693e56 | EditButton | DMF0008_ErpEdiMaster.cs:746 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pPROJECT_OWNER), iRow, siSub.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-657df950 | EditButton | DMF0008_ErpEdiMaster.cs:747 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pPROJECT_STATUS), iRow, siSub.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-988c7dc6 | EditButton | DMF0008_ErpEdiMaster.cs:749 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pSALES_COMPANY), iRow, siSub.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1dccae0e | EditButton | DMF0008_ErpEdiMaster.cs:752 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pSCM_SITE_ID), iRow, siSub.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-355da9e3 | EditButton | DMF0008_ErpEdiMaster.cs:754 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pSHIPTO_CODE), iRow, siSub.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e8844314 | EditButton | DMF0008_ErpEdiMaster.cs:755 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pSHIPTO_DESCRIPTION), iRow, siSub.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-544996df | EditButton | DMF0008_ErpEdiMaster.cs:756 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pSOLDTO_CODE), iRow, siSub.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e7f55852 | EditButton | DMF0008_ErpEdiMaster.cs:757 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pSOLDTO_CUSTOMER), iRow, siSub.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-57da412e | EditButton | DMF0008_ErpEdiMaster.cs:758 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pSOLDTO_DESCRIPTION), iRow, siSub.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-82047789 | EditButton | DMF0008_ErpEdiMaster.cs:759 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pUSER_ID), iRow, siSub.GetColumnIndex(DefColumns.pU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c99882cd | EditButton | DMF0008_ErpEdiMaster.cs:761 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.pVMI_LT), iRow, siSub.GetColumnIndex(DefColumns.pVM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a1265b38 | EditButton | DMF0008_ErpEdiMaster.cs:767 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pSALES_PLANT)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-c4176314 | EditButton | DMF0008_ErpEdiMaster.cs:768 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pEDI)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-2935b989 | EditButton | DMF0008_ErpEdiMaster.cs:769 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pVALID_YN)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-b521e0f3 | EditButton | DMF0008_ErpEdiMaster.cs:773 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pSALES_PLANT)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-f2edc5f2 | EditButton | DMF0008_ErpEdiMaster.cs:774 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pEDI)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-995d7891 | EditButton | DMF0008_ErpEdiMaster.cs:775 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pVALID_YN)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-b588c2f4 | EditButton | DMF0008_ErpEdiMaster.cs:784 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pSALES_PLANT)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-5c5c2049 | EditButton | DMF0008_ErpEdiMaster.cs:785 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pEDI)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-457f18a1 | EditButton | DMF0008_ErpEdiMaster.cs:786 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pVALID_YN)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-af191dca | EditButton | DMF0008_ErpEdiMaster.cs:790 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pSALES_PLANT)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-3de02714 | EditButton | DMF0008_ErpEdiMaster.cs:791 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pEDI)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-94992758 | EditButton | DMF0008_ErpEdiMaster.cs:792 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.Sheet… | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pVALID_YN)].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |

## DMF0008_ErpEdiMaster.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc080a9d | ExcelButton | DMF0008_ErpEdiMaster.cs:838 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-cf002f3e | ExcelButton | DMF0008_ErpEdiMaster.cs:839 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-bad22b9b | ExcelButton | DMF0008_ErpEdiMaster.cs:840 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-fd60c543 | ExcelButton | DMF0008_ErpEdiMaster.cs:841 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-f556a025 | ExcelButton | DMF0008_ErpEdiMaster.cs:842 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-8ed44e52 | ExcelButton | DMF0008_ErpEdiMaster.cs:843 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-981d2806 | ExcelButton | DMF0008_ErpEdiMaster.cs:845 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-db9005f8 | ExcelButton | DMF0008_ErpEdiMaster.cs:846 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-5ef2e321 | ExcelButton | DMF0008_ErpEdiMaster.cs:848 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-23a4b122 | ExcelButton | DMF0008_ErpEdiMaster.cs:857 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57bf89ae | ExcelButton | DMF0008_ErpEdiMaster.cs:862 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-4b2ab544 | ExcelButton | DMF0008_ErpEdiMaster.cs:866 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0008_ErpEdiMaster.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e212635 | FindButton | DMF0008_ErpEdiMaster.cs:533 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSummary.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0008_ErpEdiMaster.FindData_Main

진입점: this.btnStatusUpdate.Click / FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05dbeec2 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:889 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18c7507f | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:890 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-383a33f0 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:895 | if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fb0563a0 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:897 | if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(3) | 속성 Value2 설정 |  |  |  |
| AC-1555773a | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:899 | if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d275411e | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:902 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f8cd4e22 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:903 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e1ede111 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:907 |  | UI_MISC | siSummary.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-de28ac43 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:919 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f93354ac | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:921 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-659e0ff2 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:925 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0008_GET_EDI_MST_SUMMARY") ⇒ DM.DMF0008_GET_EDI_MST_SUMMARY | 엔드포인트 요청 생성 |  |  |  |
| AC-4e2f8bbf | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:926 | lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-290393c8 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:928 | lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-57d005e1 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:929 | lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-41cdbcaa | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:930 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-dc98c38f | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:932 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e6c1b0c2 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:934 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3f2b8c38 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:941 |  | GRID_BIND | siSummary.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4767938c | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:942 |  | GRID_LOCK | siSummary.LockColumn | (0, siSummary.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-889c75b9 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:944 |  | GRID_INIT | siSummary.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e412dcf | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:951 |  | UI_MISC | siSummary.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a9850280 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:953 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0008_ErpEdiMaster.FindData_SubCustomer

진입점: this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.IsLock(siSub.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25933838 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3275 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-53fed481 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3276 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-47a456b1 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3280 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0f9db6c3 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3284 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSales_Site) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b722ca6 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3290 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e128b94e | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3291 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-44b467e4 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3295 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0004_GET_SALES_SITE_CUSTOMER_DATA") ⇒ DM.DMF0004_GET_SALES_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-6758734b | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3297 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c5bd7b6f | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3298 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-8e0a4639 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3299 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-e285bdd5 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3300 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c609fdd7 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3301 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-72291759 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3303 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aff74c97 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3305 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ebc6e37d | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3312 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8fedc800 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3313 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5ed2bd26 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3317 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sREP_SOLDTO_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-a663f973 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3318 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sREP_SHIPTO_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-a8598b68 | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3326 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-143632dc | this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetNa… | DMF0008_ErpEdiMaster.cs:3327 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0008_ErpEdiMaster.FindData_SubRepair

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-671077de | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:962 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-29a8c80d | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:963 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1565b8ce | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:968 | if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bdf9b2f8 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:970 | if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(3) | 속성 Value2 설정 |  |  |  |
| AC-d785bd18 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:972 | if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15d5fbee | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:975 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7c19f80c | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:976 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-77cc69bb | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:980 |  | UI_MISC | siRepair.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-962589b8 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:984 |  | GRID_INIT | siRepair.ChangeSheet | (SpdSheet.shtRepair) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-436a1811 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:990 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-793f4fdb | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:991 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2beb6bee | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:995 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0008_GET_EDI_MST_REPAIR") ⇒ DM.DMF0008_GET_EDI_MST_REPAIR | 엔드포인트 요청 생성 |  |  |  |
| AC-82aa15fa | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:997 | lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-60f5067d | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:998 | lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-e655629c | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:999 | lambda | DATA_OP | request.Parameters["p_sender_name"] | sSenderName | 행/컬럼 값 대입 |  |  |  |
| AC-7b6c1402 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:1000 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-28cb54b0 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:1003 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3fd254d5 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:1005 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-20dd1d4b | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:1012 |  | GRID_BIND | siRepair.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8900a942 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:1013 |  | GRID_LOCK | siRepair.LockColumn | (0, siRepair.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1117c0ea | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:1017 |  | DATA_OP | ds.Tables[0].Compute | ("SUM(CNT)", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-a8185ec8 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:1019 |  | VALUE_SET | lblRepair_Cnt.Text | "정비 필요 합계 수량 : " + TotalCount.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-4d9deccc | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:1031 | for (i < spdRepair.Sheets[0].Rows.Count) ▸ for (s < spdRepair.Sheets[0].Columns.Count) | CALL_EXT | spdRepair.Sheets[0].GetColumnLabel | (0, s) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5bc21e43 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:1038 | for (i < spdRepair.Sheets[0].Rows.Count) ▸ for (s < spdRepair.Sheets[0].Columns.Count) ▸ if (columnName == "GSCM. Sales Site" \|\| columnNam… | GRID_SET | spdRepair.Sheets[0].Cells[i, s].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-4cfa7d72 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:1039 | for (i < spdRepair.Sheets[0].Rows.Count) ▸ for (s < spdRepair.Sheets[0].Columns.Count) ▸ if (columnName == "GSCM. Sales Site" \|\| columnNam… | GRID_SET | spdRepair.Sheets[0].Cells[i, s].BackColor | Color.Azure | 그리드 속성/값 설정 |  |  |  |
| AC-ccfa1ba4 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:1047 |  | UI_MISC | siRepair.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ebfd7f3e | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:1048 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0008_ErpEdiMaster.FindData_SubRepair_New

진입점: this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSummary.SheetName)) ▸ if (siSummary.ActiveSheet.SheetName == SpdSheet.shtSummary) ▸ else of ((sFlag == "4" && siSummary.GetText(e.Row, siSummary.GetColumnIndex(DefColumns.GscmMasterData)) == "0")) ▸ if (siSummary.ActiveSheet.SheetName == SpdSheet.shtSummary)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8d2959f | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1065 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a7ce24e7 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1066 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef5d0764 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1071 | if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc2274dd | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1073 | if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(3) | 속성 Value2 설정 |  |  |  |
| AC-33da6686 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1075 | if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72ab2893 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1078 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-744fb36e | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1079 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2ce5f1ec | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1083 |  | UI_MISC | siRepair.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fd77c1d8 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1087 |  | GRID_INIT | siRepair.ChangeSheet | (SpdSheet.shtRepair) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-be08bb1f | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1093 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f3218a7f | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1094 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-409914b6 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1098 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0008_GET_EDI_MST_REPAIR") ⇒ DM.DMF0008_GET_EDI_MST_REPAIR | 엔드포인트 요청 생성 |  |  |  |
| AC-74fee77c | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1100 | lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-fc8deab4 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1101 | lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-00e7338c | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1102 | lambda | DATA_OP | request.Parameters["p_sender_name"] | sSenderName | 행/컬럼 값 대입 |  |  |  |
| AC-f4945b40 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1103 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-0552a1e8 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1104 | lambda | DATA_OP | request.Parameters["p_Flag"] | sFlag | 행/컬럼 값 대입 |  |  |  |
| AC-5011cdd2 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1106 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-06d2e443 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1108 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b3fc7bd9 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1115 |  | GRID_BIND | siRepair.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2c49c7fb | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1116 |  | GRID_LOCK | siRepair.LockColumn | (0, siRepair.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3390ed38 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1131 | if (ds.Tables[0].Rows.Count > 0) | DATA_OP | ds.Tables[0].Compute | ("SUM(CNT)", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-80c175c8 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1132 | if (ds.Tables[0].Rows.Count > 0) | VALUE_SET | lblRepair_Cnt.Text | "정비 필요 합계 수량 : " + TotalCount.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b711c0e2 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1149 | for (i < spdRepair.Sheets[0].Rows.Count) ▸ for (s < spdRepair.Sheets[0].Columns.Count) | CALL_EXT | spdRepair.Sheets[0].GetColumnLabel | (0, s) | ⚠ 의미 확인 필요 |  |  |  |
| AC-397d5d18 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1156 | for (i < spdRepair.Sheets[0].Rows.Count) ▸ for (s < spdRepair.Sheets[0].Columns.Count) ▸ if (columnName == "GSCM. Sales Site" \|\| columnNam… | GRID_SET | spdRepair.Sheets[0].Cells[i, s].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-aa73304b | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1157 | for (i < spdRepair.Sheets[0].Rows.Count) ▸ for (s < spdRepair.Sheets[0].Columns.Count) ▸ if (columnName == "GSCM. Sales Site" \|\| columnNam… | GRID_SET | spdRepair.Sheets[0].Cells[i, s].BackColor | Color.Azure | 그리드 속성/값 설정 |  |  |  |
| AC-10d49523 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1165 |  | UI_MISC | siRepair.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-afc26f60 | this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSumm… | DMF0008_ErpEdiMaster.cs:1166 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0008_ErpEdiMaster.FindData_SubSalesSite

진입점: this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() == "0")] / this.spdRepair.CellDoubleClick [if (e.Column < iGSCM_SSPM_INDEX)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40a9e9cc | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1175 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7fbb39c4 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1179 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSales_Site) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1bd9494a | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1181 |  | UI_PROP | siSub.ActiveSheetIndex | 0 | 속성 ActiveSheetIndex 설정 |  |  |  |
| AC-e1704299 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1190 | if (_DS == null) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8ca98341 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1194 | if (_DS == null) ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0008_GET_SALES_SITE") ⇒ DM.DMF0008_GET_SALES_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-4763b429 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1196 | if (_DS == null) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e1a67c15 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1197 | if (_DS == null) ▸ lambda | DATA_OP | request.Parameters["p_soldto"] | ErpSoldTo | 행/컬럼 값 대입 |  |  |  |
| AC-6f437be0 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1198 | if (_DS == null) ▸ lambda | DATA_OP | request.Parameters["p_shipto"] | ErpShipTo | 행/컬럼 값 대입 |  |  |  |
| AC-caec9d67 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1199 | if (_DS == null) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-b3688d62 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1201 | if (_DS == null) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-728a377a | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1203 | if (_DS == null) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b9dbdbc5 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1210 | if (_DS == null) | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3f487c94 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1211 | if (_DS == null) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-49e914c8 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1213 | if (_DS == null) | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-19f97fcc | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1217 | else of (_DS == null) | GRID_BIND | siSub.Query | (_DS) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-04ec9f85 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1218 | else of (_DS == null) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b00840d6 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1227 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pEND_CUSTOMER)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-36e70dea | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1228 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pSOLDTO_CUSTOMER)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-3c8cae28 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1229 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCOMPANY_ID)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-b5c3601b | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1230 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sVMI_YN)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-0e36a7c4 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1231 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sSITE_VALID_YN)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-118cec14 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1232 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCUSTOMER_VALID_YN)].BackCol… | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-77d0c8c2 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1233 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sREP_YN)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-5b5b8dd5 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1234 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCOUNTRY_NAME)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-8d6ddc0f | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1235 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sCITY_NAME)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-bb80f582 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1236 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.sSHIP_PLAN_AUTO)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-7d6f1198 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1247 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f72d7f5c | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1254 | if (_DS == null && ds2 != null && ds2.Tables[0].Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00445") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6055cee9 | this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() ==… 외 2 | DMF0008_ErpEdiMaster.cs:1257 | if (_DS == null && ds2 != null && ds2.Tables[0].Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0008_ErpEdiMaster.FindData_SubSalesSiteProjectModel

진입점: this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString() == "0") ▸ if (e.SheetTabIndex.ToString() == "1")] / this.spdRepair.CellDoubleClick [else of (e.Column < iGSCM_SSPM_INDEX)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM) ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ if (iCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-398bf541 | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1266 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-39aceffa | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1270 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSSPM) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b7f7e5cd | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1272 |  | UI_PROP | siSub.ActiveSheetIndex | 1 | 속성 ActiveSheetIndex 설정 |  |  |  |
| AC-90a7b8be | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1279 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a841d896 | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1283 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0008_GET_SALES_SITE_PROJECT_MODEL") ⇒ DM.DMF0008_GET_SALES_SITE_PROJECT_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-02981af8 | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1285 | lambda | DATA_OP | request.Parameters["p_item_id"] | ErpItemId | 행/컬럼 값 대입 |  |  |  |
| AC-28b30aab | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1286 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-accc6987 | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1287 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-4cce4fa6 | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1291 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ce57d3c | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1293 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-75166f75 | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1300 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-80d951a3 | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1301 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2532c9bd | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1309 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pSALES_PLANT)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-2deecf13 | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1310 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pEDI)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-ffce1efd | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1311 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.pVALID_YN)].BackColor | Color.FromArgb(255, 255, 212, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-5481834e | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1319 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0050fbc3 | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1330 | if (ds != null && ds.Tables[0].Rows.Count == 0 && sScmSite.Equals("확인필요") && sACTIVE_SS.Equals("확인필요")) | ENDPOINT | asyncProxy2.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5eed069a | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1334 | if (ds != null && ds.Tables[0].Rows.Count == 0 && sScmSite.Equals("확인필요") && sACTIVE_SS.Equals("확인필요")) ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0008_GET_SALES_SITE") ⇒ DM.DMF0008_GET_SALES_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-ce4a71b2 | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1336 | if (ds != null && ds.Tables[0].Rows.Count == 0 && sScmSite.Equals("확인필요") && sACTIVE_SS.Equals("확인필요")) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-606fc0af | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1337 | if (ds != null && ds.Tables[0].Rows.Count == 0 && sScmSite.Equals("확인필요") && sACTIVE_SS.Equals("확인필요")) ▸ lambda | DATA_OP | request.Parameters["p_soldto"] | ErpSoldTo | 행/컬럼 값 대입 |  |  |  |
| AC-b11992c6 | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1338 | if (ds != null && ds.Tables[0].Rows.Count == 0 && sScmSite.Equals("확인필요") && sACTIVE_SS.Equals("확인필요")) ▸ lambda | DATA_OP | request.Parameters["p_shipto"] | ErpShipTo | 행/컬럼 값 대입 |  |  |  |
| AC-40c13633 | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1339 | if (ds != null && ds.Tables[0].Rows.Count == 0 && sScmSite.Equals("확인필요") && sACTIVE_SS.Equals("확인필요")) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-2a937491 | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1341 | if (ds != null && ds.Tables[0].Rows.Count == 0 && sScmSite.Equals("확인필요") && sACTIVE_SS.Equals("확인필요")) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-240c6c3f | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1343 | if (ds != null && ds.Tables[0].Rows.Count == 0 && sScmSite.Equals("확인필요") && sACTIVE_SS.Equals("확인필요")) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-da99090e | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1350 | if (ds != null && ds.Tables[0].Rows.Count == 0 && sScmSite.Equals("확인필요") && sACTIVE_SS.Equals("확인필요")) ▸ if (ds2 != null && ds2.Tables[0].R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00445") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a38c01ba | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1353 | if (ds != null && ds.Tables[0].Rows.Count == 0 && sScmSite.Equals("확인필요") && sACTIVE_SS.Equals("확인필요")) ▸ if (ds2 != null && ds2.Tables[0].R… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f0ca22cb | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1370 | if (ds != null && ds.Tables[0].Rows.Count == 0 && !sScmSite.Equals("확인필요") && sScmSite.Count() > 0 && !sACTIVE_SS.Equals("확인…) | MESSAGE | MessageHelper.GMessageBox | ("MSG00446") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f44d62fa | this.spdSub.SheetTabClick [else of (e.SheetTabIndex.ToString… 외 2 | DMF0008_ErpEdiMaster.cs:1373 | if (ds != null && ds.Tables[0].Rows.Count == 0 && !sScmSite.Equals("확인필요") && sScmSite.Count() > 0 && !sACTIVE_SS.Equals("확인…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0008_ErpEdiMaster.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1331cd44 | this.Load | DMF0008_ErpEdiMaster.cs:281 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-250e2d2a | this.Load | DMF0008_ErpEdiMaster.cs:282 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0008_ErpEdiMaster.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c91412d | this.Load | DMF0008_ErpEdiMaster.cs:2936 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-57365624 | this.Load | DMF0008_ErpEdiMaster.cs:2937 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-be91b221 | this.Load | DMF0008_ErpEdiMaster.cs:2938 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-6d43d21a | this.Load | DMF0008_ErpEdiMaster.cs:2940 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc7d392a | this.Load | DMF0008_ErpEdiMaster.cs:2943 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0008_ErpEdiMaster.GetPlantbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0524ef4 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2973 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_BY_DIVISION") ⇒ SCM.SCM0001_GET_PLANT_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-457fabe6 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2974 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-5b09b599 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2975 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5b9c3e2d | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2978 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0008_ErpEdiMaster.GetScmSiteInfobyDivision

진입점: this.spdSub.ComboSelChange [else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.pEND_CUSTOMER40)) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.pSCM_SITE_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-682d65f7 | this.spdSub.ComboSelChange [else of (e.Column == siSub.GetCo… | DMF0008_ErpEdiMaster.cs:2129 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_INFO_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-7b6f30d1 | this.spdSub.ComboSelChange [else of (e.Column == siSub.GetCo… | DMF0008_ErpEdiMaster.cs:2130 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-05b323db | this.spdSub.ComboSelChange [else of (e.Column == siSub.GetCo… | DMF0008_ErpEdiMaster.cs:2131 |  | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-fc807e5b | this.spdSub.ComboSelChange [else of (e.Column == siSub.GetCo… | DMF0008_ErpEdiMaster.cs:2132 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-01d0f529 | this.spdSub.ComboSelChange [else of (e.Column == siSub.GetCo… | DMF0008_ErpEdiMaster.cs:2135 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0008_ErpEdiMaster.GetSoldToCustomerData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e3fd543 | this.Load | DMF0008_ErpEdiMaster.cs:2987 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0004_GET_SOLDTO_CUSTOMER_DATA") ⇒ DM.DMF0004_GET_SOLDTO_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-c219051f | this.Load | DMF0008_ErpEdiMaster.cs:2988 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-2b4999a6 | this.Load | DMF0008_ErpEdiMaster.cs:2989 |  | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-759122fb | this.Load | DMF0008_ErpEdiMaster.cs:2990 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2e9de8d7 | this.Load | DMF0008_ErpEdiMaster.cs:2993 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0008_ErpEdiMaster.GetSpdTitle

진입점: this.btnStatusUpdate.Click / this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() == "0")] / this.Load / this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.IsLock(siSub.SheetName))] / this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSummary.SheetName)) ▸ if (siSummary.ActiveSheet.SheetName == SpdSheet.shtSummary) ▸ else of ((sFlag == "4" && siSummary.GetText(e.Row, siSummary.GetColumnIndex(DefColumns.GscmMasterData)) == "0")) ▸ if (siS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30b533da | this.btnStatusUpdate.Click 외 9 | DMF0008_ErpEdiMaster.cs:2953 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-c14423d0 | this.btnStatusUpdate.Click 외 9 | DMF0008_ErpEdiMaster.cs:2954 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3da89719 | this.btnStatusUpdate.Click 외 9 | DMF0008_ErpEdiMaster.cs:2955 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a3ae6d08 | this.btnStatusUpdate.Click 외 9 | DMF0008_ErpEdiMaster.cs:2956 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-54ad1d65 | this.btnStatusUpdate.Click 외 9 | DMF0008_ErpEdiMaster.cs:2957 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0008" | 행/컬럼 값 대입 |  |  |  |
| AC-53fc8369 | this.btnStatusUpdate.Click 외 9 | DMF0008_ErpEdiMaster.cs:2958 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-3e1fa922 | this.btnStatusUpdate.Click 외 9 | DMF0008_ErpEdiMaster.cs:2959 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-a150cc15 | this.btnStatusUpdate.Click 외 9 | DMF0008_ErpEdiMaster.cs:2961 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1497ea78 | this.btnStatusUpdate.Click 외 9 | DMF0008_ErpEdiMaster.cs:2963 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0008_ErpEdiMaster.GetUpdateHistory

진입점: this.btnStatusUpdate.Click / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b13a1560 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:3350 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_UPDATE_HISTORY") ⇒ DM.DMF0000_GET_UPDATE_HISTORY | 엔드포인트 요청 생성 |  |  |  |
| AC-f8f8934d | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:3352 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-82a863d1 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:3356 | if (dt.Rows.Count > 0) | VALUE_SET | lblTitle.Text | "*Last Update Start :\r\n*Last Update End :\r\n*Updated by :" | 컨트롤 값 설정 |  |  |  |
| AC-208d5484 | this.btnStatusUpdate.Click 외 1 | DMF0008_ErpEdiMaster.cs:3358 | if (dt.Rows.Count > 0) | VALUE_SET | lblUpdateHistory.Text | dt.Rows[0]["SDATE"].ToString() + "\r\n" + dt.Rows[0]["EDATE"].ToString() + "\r\n" + dt.Row… | 컨트롤 값 설정 |  |  |  |

## DMF0008_ErpEdiMaster.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e17271c | this.Load | DMF0008_ErpEdiMaster.cs:358 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d5279adb | this.Load | DMF0008_ErpEdiMaster.cs:366 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-802f142a | this.Load | DMF0008_ErpEdiMaster.cs:374 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c91cfea2 | this.Load | DMF0008_ErpEdiMaster.cs:381 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-5300debc | this.Load | DMF0008_ErpEdiMaster.cs:381 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e58f5635 | this.Load | DMF0008_ErpEdiMaster.cs:383 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-aa3f8c9a | this.Load | DMF0008_ErpEdiMaster.cs:390 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-445432d3 | this.Load | DMF0008_ErpEdiMaster.cs:400 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-fe04aa48 | this.Load | DMF0008_ErpEdiMaster.cs:401 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8bc2b0ec | this.Load | DMF0008_ErpEdiMaster.cs:403 |  | FLAG | dtSoldToCustomer | GetSoldToCustomerData() | 화면 필드/플래그 변경 |  |  |  |
| AC-ca46bcc6 | this.Load | DMF0008_ErpEdiMaster.cs:404 |  | LIST_REBIND | clsCtrl.setListBox | (dtSoldToCustomer, clbSoldToCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-51ced34b | this.Load | DMF0008_ErpEdiMaster.cs:406 |  | FLAG | dtSoldTo | Data.Common(Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-33b64104 | this.Load | DMF0008_ErpEdiMaster.cs:406 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e6cea964 | this.Load | DMF0008_ErpEdiMaster.cs:408 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0008_ErpEdiMaster.InitSaveDataTable

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f73ec6ed | this.Load | DMF0008_ErpEdiMaster.cs:488 |  | FLAG | dtSubBucket | new DataTable("SubSubBucketSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-58de56b7 | this.Load | DMF0008_ErpEdiMaster.cs:498 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pDIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-00487b0a | this.Load | DMF0008_ErpEdiMaster.cs:499 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pPROJECT_CODE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-08d56eca | this.Load | DMF0008_ErpEdiMaster.cs:500 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pSCM_SITE_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a377c399 | this.Load | DMF0008_ErpEdiMaster.cs:501 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pITEM_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-22a9cc6b | this.Load | DMF0008_ErpEdiMaster.cs:502 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pCURRENCY, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-69908e05 | this.Load | DMF0008_ErpEdiMaster.cs:503 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pKWH, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b0e2a42 | this.Load | DMF0008_ErpEdiMaster.cs:504 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pCELL_PER_CAR, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d777140a | this.Load | DMF0008_ErpEdiMaster.cs:505 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pCELL_PER_MODULE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d4b1e49 | this.Load | DMF0008_ErpEdiMaster.cs:506 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pLIABILITY_PERIOD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf909019 | this.Load | DMF0008_ErpEdiMaster.cs:507 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pVALID_YN, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-48f3dc60 | this.Load | DMF0008_ErpEdiMaster.cs:508 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pBPMS_EXIST, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-764c34b3 | this.Load | DMF0008_ErpEdiMaster.cs:509 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pSALES_COMPANY, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a839f50 | this.Load | DMF0008_ErpEdiMaster.cs:510 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pSALES_PLANT, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d905ace | this.Load | DMF0008_ErpEdiMaster.cs:511 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pMODULE_VARIANT, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-314ca3ee | this.Load | DMF0008_ErpEdiMaster.cs:512 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pEDI, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d623a3c | this.Load | DMF0008_ErpEdiMaster.cs:513 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.pUSER_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e53ace2 | this.Load | DMF0008_ErpEdiMaster.cs:515 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.BucketPer, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-280e44d6 | this.Load | DMF0008_ErpEdiMaster.cs:516 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.ConversionType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0008_ErpEdiMaster.InitSpread

진입점: this.btnStatusUpdate.Click / this.spdSub.SheetTabClick [if (e.SheetTabIndex.ToString() == "0")] / this.Load / this.spdSub.CellDoubleClick [if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.IsLock(siSub.SheetName))] / this.spdSummary.CellDoubleClick [if (siSummary.IsLock(siSummary.SheetName)) ▸ if (siSummary.ActiveSheet.SheetName == SpdSheet.shtSummary) ▸ else of ((sFlag == "4" && siSummary.GetText(e.Row, siSummary.GetColumnIndex(DefColumns.GscmMasterData)) == "0")) ▸ if (siS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5db311fa | this.btnStatusUpdate.Click 외 9 | DMF0008_ErpEdiMaster.cs:467 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e2b8f09 | this.btnStatusUpdate.Click 외 9 | DMF0008_ErpEdiMaster.cs:468 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0008_ErpEdiMaster.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f9aa53d | InsertButton | DMF0008_ErpEdiMaster.cs:1798 | if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e5d0765b | InsertButton | DMF0008_ErpEdiMaster.cs:1799 | if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1e3a9a9 | InsertButton | DMF0008_ErpEdiMaster.cs:1809 | if (fps.Name == "spdMain") ▸ if (siSummary != null && siSummary.IsLock(siSummary.SheetName) == false) ▸ if (siSummary.SheetName == SpdSheet.… | UI_MISC | siSummary.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b56d269a | InsertButton | DMF0008_ErpEdiMaster.cs:1811 | if (fps.Name == "spdMain") ▸ if (siSummary != null && siSummary.IsLock(siSummary.SheetName) == false) ▸ if (siSummary.SheetName == SpdSheet.… | DATA_OP | siSummary.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-938e8055 | InsertButton | DMF0008_ErpEdiMaster.cs:1819 | else of (fps.Name == "spdMain") ▸ if (siSummary.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4ad8352 | InsertButton | DMF0008_ErpEdiMaster.cs:1823 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8f30b8e0 | InsertButton | DMF0008_ErpEdiMaster.cs:1825 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a24f8c99 | InsertButton | DMF0008_ErpEdiMaster.cs:1829 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_COMBO | siSub.SetCellTypeCombo | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-bfc73725 | InsertButton | DMF0008_ErpEdiMaster.cs:1830 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.sDIVISION_ID), siSub.GetValue(siSum… | 그리드 값 설정 |  |  |  |
| AC-32336f84 | InsertButton | DMF0008_ErpEdiMaster.cs:1835 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.sDIVISION_ID), cDivision) | 그리드 값 설정 |  |  |  |
| AC-8d233ed4 | InsertButton | DMF0008_ErpEdiMaster.cs:1836 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.sREP_SOLDTO_CODE), ErpSoldTo) | 그리드 값 설정 |  |  |  |
| AC-6ab0883c | InsertButton | DMF0008_ErpEdiMaster.cs:1837 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.sREP_SHIPTO_CODE), ErpShipTo) | 그리드 값 설정 |  |  |  |
| AC-d3107999 | InsertButton | DMF0008_ErpEdiMaster.cs:1842 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.pDIVISION_ID), cDivision) | 그리드 값 설정 |  |  |  |
| AC-7ae20e0a | InsertButton | DMF0008_ErpEdiMaster.cs:1843 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.pSOLDTO_CODE), ErpSoldTo) | 그리드 값 설정 |  |  |  |
| AC-9f06b1f2 | InsertButton | DMF0008_ErpEdiMaster.cs:1844 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.pSHIPTO_CODE), ErpShipTo) | 그리드 값 설정 |  |  |  |
| AC-169cf377 | InsertButton | DMF0008_ErpEdiMaster.cs:1845 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.pITEM_ID), ErpItemId) | 그리드 값 설정 |  |  |  |
| AC-2bea5b8a | InsertButton | DMF0008_ErpEdiMaster.cs:1849 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-631a9d86 | InsertButton | DMF0008_ErpEdiMaster.cs:1850 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0008_ErpEdiMaster.InsertRowLockRangeSubSalesSite

진입점: InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-873cf9c1 | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1857 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.sDIVISION_ID), rowIndex, siSub.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eafff559 | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1858 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.sSCM_SITE_ID), rowIndex, siSub.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8960445d | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1861 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.sLAST_UPDATE_DATE), rowIndex, siSub.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ced9a081 | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1862 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.sLAST_UPDATED_BY), rowIndex, siSub.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0008_ErpEdiMaster.InsertRowLockRangeSubSSPM

진입점: InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c2722fe | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1868 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.pDIVISION_ID), rowIndex, siSub.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d29402b8 | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1869 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.pOWNER), rowIndex, siSub.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-73371310 | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1870 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.pSOLDTO_CODE), rowIndex, siSub.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-88b34c5d | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1871 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.pSHIPTO_CODE), rowIndex, siSub.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bce5291b | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1872 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.pPROJECT_NAME), rowIndex, siSub.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-55313bfa | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1873 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.pITEM_NAME), rowIndex, siSub.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2699f489 | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1874 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.pITEM_TYPE), rowIndex, siSub.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-34d4377e | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1875 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.pITEM_CLASS_NAME), rowIndex, siSub.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7b34a775 | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1876 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.pITEM_NAME), rowIndex, siSub.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-762a26ba | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1877 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.pMODULE_PER_CAR), rowIndex, siSub.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eebee116 | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1878 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.pLAST_UPDATED_BY), rowIndex, siSub.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-45917bdd | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… | DMF0008_ErpEdiMaster.cs:1879 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.pLAST_UPDATE_DATE), rowIndex, siSub.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0008_ErpEdiMaster.SaveSalesSite

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05c5da6a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1383 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-051e9ab0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1460 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCol… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-009572f5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1462 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCol… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e48ff65d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1471 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.G… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2f68c0b5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1473 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.G… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75548a4c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1482 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.G… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0114a5ac | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1484 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.G… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aefd5e22 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1493 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.G… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9dd8cec1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1495 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.G… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6bdb500 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1504 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.G… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-040b1668 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1506 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.G… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd1c8b55 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1517 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0008_SAVE_SALES_SITE_EDI_REPAIR | 엔드포인트 요청 생성 |  |  |  |
| AC-149441b0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1518 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-ce64d666 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1519 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-ae2a21b8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1520 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_soldto_customer"] | sSoldtoCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-969d550f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1521 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_company_id"] | sCompanyId | 행/컬럼 값 대입 |  |  |  |
| AC-dc31bb30 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1522 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-563aec6c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1523 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_soldto_code"] | sSoldtoCode | 행/컬럼 값 대입 |  |  |  |
| AC-9a041acc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1524 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_shipto_code"] | sShiptoCode | 행/컬럼 값 대입 |  |  |  |
| AC-4f6bf69b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1525 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_vmi_yn"] | sVmiYn | 행/컬럼 값 대입 |  |  |  |
| AC-ef637439 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1526 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYn | 행/컬럼 값 대입 |  |  |  |
| AC-3414c4bd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1527 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_cust_valid_yn"] | sCustValidYn | 행/컬럼 값 대입 |  |  |  |
| AC-08fa081e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1528 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_rep_yn"] | sRepYn | 행/컬럼 값 대입 |  |  |  |
| AC-28fc6a61 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1529 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_country"] | sCountry | 행/컬럼 값 대입 |  |  |  |
| AC-a4d99efb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1530 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_city"] | sCity | 행/컬럼 값 대입 |  |  |  |
| AC-ef1d9bbd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1531 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_ship_plan_auto"] | sShipPlanAuto | 행/컬럼 값 대입 |  |  |  |
| AC-33307038 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1532 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-7ca5393a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1533 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-0f025e1f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1535 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f32ae289 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1553 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-29d1aaec | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1568 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ if (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-87dd622c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0008_ErpEdiMaster.cs:1619 | if (siSub != null && siSub.IsLock(SpdSheet.shtSales_Site) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0008_ErpEdiMaster.SaveSSPM

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36c06ab1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1633 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8370bc3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1716 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR | 엔드포인트 요청 생성 |  |  |  |
| AC-0be0870a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1731 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-6e776d58 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1732 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-9bbffcbc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1733 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-40f593a2 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1734 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-b3ac27eb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1735 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_currency"] | sCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-bc2c1d71 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1736 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_kwh"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-1d3bfbb5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1737 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_cell_per_car"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-42c65b61 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1738 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_cell_per_module"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-19e39274 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1739 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_liability_period"] | sLiabilityPeriod | 행/컬럼 값 대입 |  |  |  |
| AC-03163b5d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1740 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYn | 행/컬럼 값 대입 |  |  |  |
| AC-90bbe0d0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1741 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_bpms_exist"] | sBpmsExist | 행/컬럼 값 대입 |  |  |  |
| AC-b72fb2cb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1742 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_sales_company"] | sSalesCompany | 행/컬럼 값 대입 |  |  |  |
| AC-6fc3244b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1743 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_sales_plant"] | sSalesPlant | 행/컬럼 값 대입 |  |  |  |
| AC-64bbc19d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1744 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_module_variant"] | sModuleVariant | 행/컬럼 값 대입 |  |  |  |
| AC-7b9eef5b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1745 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-a2b10660 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1746 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sCreatedBy | 행/컬럼 값 대입 |  |  |  |
| AC-4403a955 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1748 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a8f2a885 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1768 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ foreach (DataRow dr in dtSubBucket.Rows) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-888951cd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1782 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ if (iCount > 0) | MESSAGE | MessageBox.Show | ("데이터가 저장되었습니다.") | 메시지 표시 |  |  |  |
| AC-ea1563d0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0008_ErpEdiMaster.cs:1788 | if (siSub != null && siSub.IsLock(SpdSheet.shtSSPM) == false) ▸ if (iCount > 0) | STATE_RESET | dtSubBucket.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## DMF0008_ErpEdiMaster.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4684d08e | this.Load | DMF0008_ErpEdiMaster.cs:304 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-db7ebb3a | this.Load | DMF0008_ErpEdiMaster.cs:305 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d8cff9cf | this.Load | DMF0008_ErpEdiMaster.cs:311 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-44f57a68 | this.Load | DMF0008_ErpEdiMaster.cs:311 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-aa5fcefc | this.Load | DMF0008_ErpEdiMaster.cs:316 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c74c931e | this.Load | DMF0008_ErpEdiMaster.cs:318 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7fbb405a | this.Load | DMF0008_ErpEdiMaster.cs:318 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7533c89e | this.Load | DMF0008_ErpEdiMaster.cs:323 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-be6edced | this.Load | DMF0008_ErpEdiMaster.cs:324 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-7e253118 | this.Load | DMF0008_ErpEdiMaster.cs:326 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-19365b4f | this.Load | DMF0008_ErpEdiMaster.cs:326 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-52c2a3bd | this.Load | DMF0008_ErpEdiMaster.cs:331 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3e8fa8ed | this.Load | DMF0008_ErpEdiMaster.cs:332 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-f492c696 | this.Load | DMF0008_ErpEdiMaster.cs:333 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-614bcae4 | this.Load | DMF0008_ErpEdiMaster.cs:335 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-33e53957 | this.Load | DMF0008_ErpEdiMaster.cs:335 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7b6bc8df | this.Load | DMF0008_ErpEdiMaster.cs:340 | switch (triggerControl) case "ScmSitebyEndCustomer40": | FLAG | dtSalesSite | DataService.GetDMInnerTable("ScmSitebyEndCustomer40", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2b3beb42 | this.Load | DMF0008_ErpEdiMaster.cs:340 | switch (triggerControl) case "ScmSitebyEndCustomer40": | COMBO_DATA | DataService.GetDMInnerTable | ("ScmSitebyEndCustomer40", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0008_ErpEdiMaster.SetGridHeader

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7b6ac78 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2007 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DMF0004", siSummary.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DMF0008_ErpEdiMaster.SetSubSalesSiteData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-401645f6 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2763 |  | DATA_OP | dtSubBucket.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-52c5f847 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2767 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2eb9a9ee | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2768 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-6d9d1a2d | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2770 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.pSCM_SITE_ID] | sSCM_SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-7bb51def | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2771 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.pSOLDTO_CODE] | sSOLDTO_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-fa6840a4 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2772 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.pSHIPTO_CODE] | sSHIPTO_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-3e109072 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2773 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ConversionType] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-2f1a59cb | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2775 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1084803 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2776 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fac93745 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2780 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-9ca3285b | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2781 | else of (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0008_ErpEdiMaster.SetSubSSPMData

진입점: dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a377f5ae | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2795 |  | DATA_OP | dtSubBucket.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-78f48dfa | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2799 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-73eac08d | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2800 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-616e1ad0 | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2802 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.pSCM_SITE_ID] | sSCM_SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-8c83e4f2 | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2803 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.pPROJECT_CODE] | sPROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-424baa9d | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2805 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.pITEM_ID] | sITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-8640568b | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2806 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.pSALES_PLANT] | sSALES_PLANT | 행/컬럼 값 대입 |  |  |  |
| AC-79bb6d51 | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2807 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.pEDI] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-12326515 | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2808 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.pVALID_YN] | sValidYn | 행/컬럼 값 대입 |  |  |  |
| AC-193ce64f | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2809 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-ee3092d4 | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2810 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ConversionType] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-bc49588f | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2812 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf4013e6 | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2813 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c38c14a2 | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2817 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-23409626 | dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0008_ErpEdiMaster.cs:2818 | else of (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0008_ErpEdiMaster.shtSALES_SITEDataModel_Changed

진입점: dsdm1.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-208558b5 | dsdm1.Changed | DMF0008_ErpEdiMaster.cs:2530 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.sSOLD… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.sSCM_SITE_ID), ssScmSite) | 그리드 값 설정 |  |  |  |
| AC-9edb8510 | dsdm1.Changed | DMF0008_ErpEdiMaster.cs:2535 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.sSOLD… | FLAG | mbScmSite | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b21313f0 | dsdm1.Changed | DMF0008_ErpEdiMaster.cs:2549 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.… | FLAG | mbScmSite | false | 화면 필드/플래그 변경 |  |  |  |
| AC-44964b96 | dsdm1.Changed | DMF0008_ErpEdiMaster.cs:2566 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { "필수 입력사항입니다.\n\r다시한번 확인해주세요." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-52ed2f1c | dsdm1.Changed | DMF0008_ErpEdiMaster.cs:2568 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.sSCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-be06e7fe | dsdm1.Changed | DMF0008_ErpEdiMaster.cs:2579 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.sCOUNTRY), "") | 그리드 값 설정 |  |  |  |
| AC-d7a26a21 | dsdm1.Changed | DMF0008_ErpEdiMaster.cs:2581 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.sCITY), "") | 그리드 값 설정 |  |  |  |
| AC-213033d2 | dsdm1.Changed | DMF0008_ErpEdiMaster.cs:2582 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.sCITY_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-f62725d1 | dsdm1.Changed | DMF0008_ErpEdiMaster.cs:2590 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.sCITY), "") | 그리드 값 설정 |  |  |  |

## DMF0008_ErpEdiMaster.spdMain_ComboSelChange

진입점: this.spdSummary.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f773b3dd | this.spdSummary.ComboSelChange | DMF0008_ErpEdiMaster.cs:2022 | if (e.Column == siSummary.GetColumnIndex(DefColumns.Division)) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-fc5218b0 | this.spdSummary.ComboSelChange | DMF0008_ErpEdiMaster.cs:2022 | if (e.Column == siSummary.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8cb2132d | this.spdSummary.ComboSelChange | DMF0008_ErpEdiMaster.cs:2023 | if (e.Column == siSummary.GetColumnIndex(DefColumns.Division)) | FLAG | dtSoldTo | Data.Common(Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-86400476 | this.spdSummary.ComboSelChange | DMF0008_ErpEdiMaster.cs:2023 | if (e.Column == siSummary.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DMF0008_ErpEdiMaster.spdMain_LeaveCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c582e158 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:2505 | if (e.Row != e.NewRow) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.NewRow | iRow | 속성 NewRow 설정 |  |  |  |

## DMF0008_ErpEdiMaster.spdMain_TopChange

진입점: this.spdSummary.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0a69fb1 | this.spdSummary.TopChange | DMF0008_ErpEdiMaster.cs:2918 |  | GRID_INIT | siSummary.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0008_ErpEdiMaster.spdRepair_CellDoubleClick

진입점: this.spdRepair.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b9f7f4b | this.spdRepair.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1960 |  | FLAG | cDivision | sDivision | 화면 필드/플래그 변경 |  |  |  |
| AC-18d36036 | this.spdRepair.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1961 |  | FLAG | ErpSoldTo | siRepair.GetText(e.Row, siRepair.GetColumnIndex(DefColumns.ErpSoldTo)) | 화면 필드/플래그 변경 |  |  |  |
| AC-24a5c186 | this.spdRepair.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1962 |  | FLAG | ErpShipTo | siRepair.GetText(e.Row, siRepair.GetColumnIndex(DefColumns.ErpShipTo)) | 화면 필드/플래그 변경 |  |  |  |
| AC-023cc91d | this.spdRepair.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1963 |  | FLAG | ErpItemId | siRepair.GetText(e.Row, siRepair.GetColumnIndex(DefColumns.ErpItemId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-9cfc8087 | this.spdRepair.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1964 |  | FLAG | GscmSalesSiteId | siRepair.GetText(e.Row, siRepair.GetColumnIndex(DefColumns.GscmSalesSiteId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6cb9a5e | this.spdRepair.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1965 |  | FLAG | sACTIVE_SS | siRepair.GetText(e.Row, siRepair.GetColumnIndex(DefColumns.ACTIVE_SS)) | 화면 필드/플래그 변경 |  |  |  |
| AC-582a5c33 | this.spdRepair.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1966 |  | FLAG | sGSCM_SSPM | siRepair.GetText(e.Row, siRepair.GetColumnIndex(DefColumns.GSCM_SSPM)) | 화면 필드/플래그 변경 |  |  |  |
| AC-3aacde45 | this.spdRepair.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1980 | else of (e.Column < iGSCM_SSPM_INDEX) | STATE_RESET | dtSubBucket.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## DMF0008_ErpEdiMaster.spdSub_ActiveSheetChanging

진입점: this.spdSub.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac9be13a | this.spdSub.ActiveSheetChanging | DMF0008_ErpEdiMaster.cs:2470 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siSub.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-ab8e07de | this.spdSub.ActiveSheetChanging | DMF0008_ErpEdiMaster.cs:2472 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba32e681 | this.spdSub.ActiveSheetChanging | DMF0008_ErpEdiMaster.cs:2473 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0008_ErpEdiMaster.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-741b0191 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2141 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetText(e.Row, siSub.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91802064 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2143 | if (!siSub.IsLock(siSub.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2270ab51 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2151 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7a7c8a1 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2157 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ffed2bf6 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2158 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c16c539 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2170 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a6a5abf0 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2188 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | POPUP | new SCM0002_CustomerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f678578a | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2190 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | POPUP | popCustomer.Form_Load | (false, sDivision, sSoldToCode, sShipToCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ae286198 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2191 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | UI_PROP | popCustomer.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5ff9a2b6 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2192 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | POPUP | popCustomer.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ada5da30 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2197 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.sREP_SOLDTO_CODE), popCustomer.SoldToCode) | 그리드 값 설정 |  |  |  |
| AC-fbf2f4ec | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2198 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.sREP_SHIPTO_CODE), popCustomer.ShipToCode) | 그리드 값 설정 |  |  |  |
| AC-a534ba0c | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2224 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | POPUP | popCity.Form_Load | (false, sCountry, sCity) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c6296952 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2225 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | UI_PROP | popCity.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5d073c5d | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2226 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | POPUP | popCity.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-42277afe | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2235 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | FLAG | msScmSite | siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.sSOLDTO_CUSTOMER)) + "_" + sCity.Subs… | 화면 필드/플래그 변경 |  |  |  |
| AC-f57ec385 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2238 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | FLAG | mbScmSite | true | 화면 필드/플래그 변경 |  |  |  |
| AC-131d9448 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2241 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.sCOUNTRY), sCountry) | 그리드 값 설정 |  |  |  |
| AC-c941481e | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2242 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.sCOUNTRY_NAME), sCountryName) | 그리드 값 설정 |  |  |  |
| AC-27f1bc3a | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2243 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.sCITY), sCity) | 그리드 값 설정 |  |  |  |
| AC-b81bae8e | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2244 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.sCITY_NAME), sCityName) | 그리드 값 설정 |  |  |  |
| AC-dca71a70 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2265 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | POPUP | new SCM0002_TeamPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8de6fdfa | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2267 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | POPUP | popTeam.Form_Load | (false, sTeamID, sTeamName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-97c2e885 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2268 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | UI_PROP | popTeam.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-270b9155 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2269 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | POPUP | popTeam.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f4b053a2 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2276 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.sTEAM_ID), sTeamID) | 그리드 값 설정 |  |  |  |
| AC-db1804c7 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2277 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ if (siSub.ActiveSheet.SheetName == SpdSh… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.sTEAM_NAME), sTeamName) | 그리드 값 설정 |  |  |  |
| AC-0488f452 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2286 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98323bff | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2292 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bbc7e403 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2293 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9123f394 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2320 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-14ec2819 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2321 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d13cba86 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2322 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e6c50f84 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2323 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-efb63139 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2335 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pPROJECT_CODE), sProject) | 그리드 값 설정 |  |  |  |
| AC-efffc6c3 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2336 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pPROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-396d5934 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2337 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pPROJECT_STATUS), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-eef99ed8 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2339 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pCURRENCY), sCurrency) | 그리드 값 설정 |  |  |  |
| AC-3ff3d4f5 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2341 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pPROJECT_OWNER), sProjectOwner) | 그리드 값 설정 |  |  |  |
| AC-c77f0eee | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2367 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | POPUP | new DM0002_ItembySmallDivPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3f933b8b | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2371 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | POPUP | popItem.Form_Load | (true, sDivision, "ALL", "ALL", "ALL", "ALL", sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-cfa0e3bc | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2372 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a96e0e43 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2373 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4a87bf11 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2386 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-0be739db | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2388 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pITEM_NAME), sItemName) | 그리드 값 설정 |  |  |  |
| AC-606aec1a | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2390 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pITEM_TYPE), sItemType) | 그리드 값 설정 |  |  |  |
| AC-8414d447 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2392 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pNICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |
| AC-61e6873d | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2394 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pITEM_CLASS_NAME), sItemclassname) | 그리드 값 설정 |  |  |  |
| AC-ec65dbae | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2396 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pCURRENCY), sCurrency) | 그리드 값 설정 |  |  |  |
| AC-5ebd3929 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2411 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | POPUP | new DMF000_OwnerSet_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-07c4af9e | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2416 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | POPUP | popOwner.Form_Load | (sDivision, sUSER_ID) | 팝업 초기화(인자 전달) |  |  |  |
| AC-991d39f7 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2417 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | UI_PROP | popOwner.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-30e8b6b5 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2418 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | POPUP | popOwner.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-672825bd | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2422 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pOWNER), popOwner.userNameEn) | 그리드 값 설정 |  |  |  |
| AC-8f82a685 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2423 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pUSER_ID), popOwner.owner) | 그리드 값 설정 |  |  |  |
| AC-c1b5a9bc | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2425 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pDEPT_ID2), popOwner.DEPT_ID) | 그리드 값 설정 |  |  |  |
| AC-a1504048 | this.spdSub.CellDoubleClick | DMF0008_ErpEdiMaster.cs:2427 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtRepair) ▸ else of (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pDEPT_ID), popOwner.DEPT_ID) | 그리드 값 설정 |  |  |  |

## DMF0008_ErpEdiMaster.SpdSub_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85816bec | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3062 | if (siSub.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8626b368 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3068 | if (siSub.IsLock(siSub.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-130053a1 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3069 | if (siSub.IsLock(siSub.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4156bde7 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3103 | else of (siSub.IsLock(siSub.SheetName)) ▸ if ((siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pPROJECT_C… | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6d0084d9 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3104 | else of (siSub.IsLock(siSub.SheetName)) ▸ if ((siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pPROJECT_C… | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8a4a7262 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3105 | else of (siSub.IsLock(siSub.SheetName)) ▸ if ((siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pPROJECT_C… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-80294686 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3106 | else of (siSub.IsLock(siSub.SheetName)) ▸ if ((siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pPROJECT_C… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d657b190 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3118 | else of (siSub.IsLock(siSub.SheetName)) ▸ if ((siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pPROJECT_C… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pPROJECT_CODE), sProject) | 그리드 값 설정 |  |  |  |
| AC-f7ab6d37 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3119 | else of (siSub.IsLock(siSub.SheetName)) ▸ if ((siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pPROJECT_C… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pPROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-f369d87f | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3120 | else of (siSub.IsLock(siSub.SheetName)) ▸ if ((siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pPROJECT_C… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pPROJECT_STATUS), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-3f0df196 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3122 | else of (siSub.IsLock(siSub.SheetName)) ▸ if ((siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pPROJECT_C… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pCURRENCY), sCurrency) | 그리드 값 설정 |  |  |  |
| AC-d554944c | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3124 | else of (siSub.IsLock(siSub.SheetName)) ▸ if ((siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pPROJECT_C… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pPROJECT_OWNER), sProjectOwner) | 그리드 값 설정 |  |  |  |
| AC-5a17f6a7 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3150 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pITEM_ID)) … | POPUP | new DM0002_ItembySmallDivPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f351b4e9 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3154 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pITEM_ID)) … | POPUP | popItem.Form_Load | (true, sDivision, "ALL", "ALL", "ALL", "ALL", sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9826cbe6 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3155 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pITEM_ID)) … | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-10ee847d | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3156 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pITEM_ID)) … | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a7b0dc3d | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3169 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pITEM_ID)) … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-6714fef8 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3171 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pITEM_ID)) … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pITEM_NAME), sItemName) | 그리드 값 설정 |  |  |  |
| AC-5fbad2a1 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3173 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pITEM_ID)) … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pITEM_TYPE), sItemType) | 그리드 값 설정 |  |  |  |
| AC-a6ba828a | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3175 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pITEM_ID)) … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pNICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |
| AC-a8502c8d | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3177 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pITEM_ID)) … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pITEM_CLASS_NAME), sItemclassname) | 그리드 값 설정 |  |  |  |
| AC-77f1099a | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3179 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.pITEM_ID)) … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pCURRENCY), sCurrency) | 그리드 값 설정 |  |  |  |
| AC-3d837f39 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3194 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetText(e.Row, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸… | POPUP | new DMF000_OwnerSet_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-149b3662 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3199 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetText(e.Row, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸… | POPUP | popOwner.Form_Load | (sDivision, sUSER_ID) | 팝업 초기화(인자 전달) |  |  |  |
| AC-25543061 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3200 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetText(e.Row, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸… | UI_PROP | popOwner.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a919939c | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3201 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetText(e.Row, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸… | POPUP | popOwner.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b6c725ba | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3205 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetText(e.Row, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pOWNER), popOwner.userNameEn) | 그리드 값 설정 |  |  |  |
| AC-faa647cf | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3206 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetText(e.Row, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pUSER_ID), popOwner.owner) | 그리드 값 설정 |  |  |  |
| AC-9c65d9bf | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3208 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetText(e.Row, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pDEPT_ID2), popOwner.DEPT_ID) | 그리드 값 설정 |  |  |  |
| AC-db250e63 | (진입점 미연결) | DMF0008_ErpEdiMaster.cs:3210 | else of (siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetText(e.Row, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) ▸… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.pDEPT_ID), popOwner.DEPT_ID) | 그리드 값 설정 |  |  |  |

## DMF0008_ErpEdiMaster.spdSub_Changed

진입점: dsdm1.Changed / dsdm2.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a5f6013 | dsdm1.Changed 외 1 | DMF0008_ErpEdiMaster.cs:3244 | else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM) ▸ switch (e.Type) cas… | FLAG | dtSalesPlant | Data.Common(Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-7e4cc4b8 | dsdm1.Changed 외 1 | DMF0008_ErpEdiMaster.cs:3244 | else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM) ▸ switch (e.Type) cas… | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-de2cab95 | dsdm1.Changed 외 1 | DMF0008_ErpEdiMaster.cs:3245 | else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM) ▸ switch (e.Type) cas… | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.pSALES_PLANT), dtSalesPlant) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ebb71e14 | dsdm1.Changed 외 1 | DMF0008_ErpEdiMaster.cs:3248 | else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM) ▸ switch (e.Type) cas… | FLAG | dtSalesCompany | Data.Common(Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 화면 필드/플래그 변경 |  |  |  |
| AC-f68a8ea1 | dsdm1.Changed 외 1 | DMF0008_ErpEdiMaster.cs:3248 | else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM) ▸ switch (e.Type) cas… | COMBO_DATA | Data.Common | (Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0430ee99 | dsdm1.Changed 외 1 | DMF0008_ErpEdiMaster.cs:3249 | else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM) ▸ switch (e.Type) cas… | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.pSALES_COMPANY), dtSalesCompany) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-944bb097 | dsdm1.Changed 외 1 | DMF0008_ErpEdiMaster.cs:3259 | else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM) ▸ switch (e.Type) cas… | FLAG | dtSalesCompany | Data.Common(Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 화면 필드/플래그 변경 |  |  |  |
| AC-f499865d | dsdm1.Changed 외 1 | DMF0008_ErpEdiMaster.cs:3259 | else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM) ▸ switch (e.Type) cas… | COMBO_DATA | Data.Common | (Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95872c1e | dsdm1.Changed 외 1 | DMF0008_ErpEdiMaster.cs:3260 | else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM) ▸ switch (e.Type) cas… | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.pSALES_COMPANY), dtSalesCompany) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-510b8ad4 | dsdm1.Changed 외 1 | DMF0008_ErpEdiMaster.cs:3263 | else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM) ▸ switch (e.Type) cas… | FLAG | dtSalesPlant | Data.Common(Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-73b635c8 | dsdm1.Changed 외 1 | DMF0008_ErpEdiMaster.cs:3263 | else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM) ▸ switch (e.Type) cas… | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cbd68772 | dsdm1.Changed 외 1 | DMF0008_ErpEdiMaster.cs:3264 | else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSales_Site) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSSPM) ▸ switch (e.Type) cas… | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.pSALES_PLANT), dtSalesPlant) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0008_ErpEdiMaster.spdSub_ComboSelChange

진입점: this.spdSub.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c50f1d32 | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2057 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-2dfccfee | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2057 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1f7aadcb | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2072 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | FLAG | dtSalesSiteInfo | GetScmSiteInfobyDivision(sDivision, sScmSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-01acb039 | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2077 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.pSOLDTO_CODE), dtSalesSiteInfo.Rows[0][DefColumns.… | 그리드 값 설정 |  |  |  |
| AC-371c370b | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2078 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.pSOLDTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][DefC… | 그리드 값 설정 |  |  |  |
| AC-6fc9ea24 | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2079 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.pSHIPTO_CODE), dtSalesSiteInfo.Rows[0][DefColumns.… | 그리드 값 설정 |  |  |  |
| AC-a117a918 | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2080 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.pSHIPTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][DefC… | 그리드 값 설정 |  |  |  |
| AC-ce3e38cd | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2085 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.pSOLDTO_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-ba3739c2 | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2086 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.pSOLDTO_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-2769a422 | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2087 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.pSHIPTO_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-3a06c566 | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2088 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.pSHIPTO_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-8e5de62e | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2102 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | FLAG | dtSalesPlant | Data.Common(Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-1917006c | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2102 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4ee06322 | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2103 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.pSALES_PLANT), dtSalesPlant.Rows[0]["CODE"].ToStri… | 그리드 값 설정 |  |  |  |
| AC-b86bd9db | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2113 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | FLAG | dtSalesCompany | Data.Common(Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 화면 필드/플래그 변경 |  |  |  |
| AC-ccf83736 | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2113 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | COMBO_DATA | Data.Common | (Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3a09bd1c | this.spdSub.ComboSelChange | DMF0008_ErpEdiMaster.cs:2117 | else of (e.Column == siSub.GetColumnIndex(DefColumns.pDIVISION_ID)) ▸ else of (e.Column == siSub.GetColumnIndex(DefColumns.sEND_CUSTOMER)) ▸… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.pSALES_COMPANY), dtSalesCompany.Rows[0]["CODE"].To… | 그리드 값 설정 |  |  |  |

## DMF0008_ErpEdiMaster.spdSub_SheetTabClick

진입점: this.spdSub.SheetTabClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc965ebd | this.spdSub.SheetTabClick | DMF0008_ErpEdiMaster.cs:2484 | if (e.SheetTabIndex.ToString() == "0") ▸ if (ErpSoldTo == null && ErpShipTo == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0cbf2cf4 | this.spdSub.SheetTabClick | DMF0008_ErpEdiMaster.cs:2492 | else of (e.SheetTabIndex.ToString() == "0") ▸ if (e.SheetTabIndex.ToString() == "1") ▸ if (ErpItemId == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0008_ErpEdiMaster.spdSub_TopChange

진입점: this.spdSub.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f74753f7 | this.spdSub.TopChange | DMF0008_ErpEdiMaster.cs:2925 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0008_ErpEdiMaster.spdSummary_CellDoubleClick

진입점: this.spdSummary.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5a23e80 | this.spdSummary.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1891 | if (siSummary.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cac905b8 | this.spdSummary.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1898 | if (siSummary.IsLock(siSummary.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-272e8ae5 | this.spdSummary.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1899 | if (siSummary.IsLock(siSummary.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42a9d459 | this.spdSummary.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1923 | if (siSummary.IsLock(siSummary.SheetName)) | GRID_INIT | siSummary.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c707e304 | this.spdSummary.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1927 | if (siSummary.IsLock(siSummary.SheetName)) ▸ if (siSummary.ActiveSheet.SheetName == SpdSheet.shtSummary) | GRID_CLEAR | siRepair.ActiveSheet.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-6bdc61d5 | this.spdSummary.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1928 | if (siSummary.IsLock(siSummary.SheetName)) ▸ if (siSummary.ActiveSheet.SheetName == SpdSheet.shtSummary) | GRID_CLEAR | siSub.ActiveSheet.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-190da952 | this.spdSummary.CellDoubleClick | DMF0008_ErpEdiMaster.cs:1935 | if (siSummary.IsLock(siSummary.SheetName)) ▸ if (siSummary.ActiveSheet.SheetName == SpdSheet.shtSummary) ▸ if ((sFlag == "4" && siSummary.Ge… | MESSAGE | MessageBox.Show | ("정비할 데이터가 없습니다.") | 메시지 표시 |  |  |  |


# AS-IS 액션 대조표 — SCP0111

> 원천: `Doc/asisfacts/screens/SCP0111/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 299행 · 메서드 32 · 종류 DATA_OP 96 · FLAG 33 · RETURN 24 · GRID_LOCK 22 · MESSAGE 15 · POPUP 14 · ENDPOINT 14 · CALL_EXT 13 · UI_MISC 12 · COMBO_DATA 11 · UI_PROP 11 · GRID_INIT 8 · LIST_REBIND 7 · VALUE_SET 6 · GRID_SET 5 · GRID_CLEAR 3 · GRID_STYLE 2 · VALIDATE 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 13


## SCP0111_IntegrationPSI._defaultDataModel_Changed

진입점: _defaultDataModel.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afe23b85 | _defaultDataModel.Changed | SCP0111_IntegrationPSI.cs:1948 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a70f26bc | _defaultDataModel.Changed | SCP0111_IntegrationPSI.cs:1951 | if (siMain.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d76306b7 | _defaultDataModel.Changed | SCP0111_IntegrationPSI.cs:1954 | if ((e.Row == -1) \|\| (e.Column == -1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94bd70f5 | _defaultDataModel.Changed | SCP0111_IntegrationPSI.cs:1957 | if (siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d57f5ba8 | _defaultDataModel.Changed | SCP0111_IntegrationPSI.cs:1960 | if (!this.IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8df57fea | _defaultDataModel.Changed | SCP0111_IntegrationPSI.cs:1962 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f71766d | _defaultDataModel.Changed | SCP0111_IntegrationPSI.cs:1963 | if (siMain.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4baa3910 | _defaultDataModel.Changed | SCP0111_IntegrationPSI.cs:1974 | if (division_id == "82") ▸ if (action != CAppSetting.FlagM) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d608f44d | _defaultDataModel.Changed | SCP0111_IntegrationPSI.cs:1980 | if (division_id == "82") | COMBO_DATA | Data.Common | (Data.Type.CalendarMonth, false, this.periodFromDate.Substring(0, 6), this.periodToDate.Su… ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9e4e6b46 | _defaultDataModel.Changed | SCP0111_IntegrationPSI.cs:1981 | if (division_id == "82") | DATA_OP | DBUtils.Filter | (dtMonth, "CODE = '" + yyyymm + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5986729e | _defaultDataModel.Changed | SCP0111_IntegrationPSI.cs:1985 | if (division_id == "82") ▸ if (dtYYYYMM.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c497cfcd | _defaultDataModel.Changed | SCP0111_IntegrationPSI.cs:2056 | if (division_id == "82") ▸ if (measure == "PROD_PLAN" && seqFlag.Substring(0, 1) == "2") ▸ if (prodSum != inhouseQty) | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4ba50eec | _defaultDataModel.Changed | SCP0111_IntegrationPSI.cs:2125 | if (division_id == "82") ▸ if (measure == "IN_HOUSE_MOVING" && seqFlag.Substring(0, 1) == "3") ▸ if (prodSum != inhouseQty) | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0111_IntegrationPSI.BtnCellItem_Id_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57a906a6 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:1897 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-de3a48a5 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:1899 |  | POPUP | popCellItem.Form_Load | (true, division, "", "", sCellItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6b6ceb8e | (진입점 미연결) | SCP0111_IntegrationPSI.cs:1900 |  | UI_PROP | popCellItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c5e36c76 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:1901 |  | POPUP | popCellItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0111_IntegrationPSI.BtnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5babd0ba | this.btnItemId.Click | SCP0111_IntegrationPSI.cs:1916 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-bcac25b0 | this.btnItemId.Click | SCP0111_IntegrationPSI.cs:1918 |  | POPUP | popItem.Form_Load | (true, division, "", "", sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-10589c73 | this.btnItemId.Click | SCP0111_IntegrationPSI.cs:1919 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6540c3f8 | this.btnItemId.Click | SCP0111_IntegrationPSI.cs:1920 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dccef5f1 | this.btnItemId.Click | SCP0111_IntegrationPSI.cs:1926 | if (popItem.ItemID != string.Empty) | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0111_IntegrationPSI.BtnNickName_Click

진입점: this.btnNickName.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2237391f | this.btnNickName.Click | SCP0111_IntegrationPSI.cs:1877 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-71e5acb4 | this.btnNickName.Click | SCP0111_IntegrationPSI.cs:1879 |  | POPUP | popItem.Form_Load | (true, division, "", "", "") | 팝업 초기화(인자 전달) |  |  |  |
| AC-a1f04729 | this.btnNickName.Click | SCP0111_IntegrationPSI.cs:1880 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9f5a6244 | this.btnNickName.Click | SCP0111_IntegrationPSI.cs:1881 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4da0a1f2 | this.btnNickName.Click | SCP0111_IntegrationPSI.cs:1887 | if (popItem.NickName != string.Empty) | VALUE_SET | txtNickName.Text | sNickName | 컨트롤 값 설정 |  |  |  |

## SCP0111_IntegrationPSI.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-090e3b0a | cboPlanDate.SelectedIndexChanged | SCP0111_IntegrationPSI.cs:1860 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0111_IntegrationPSI.CboPlanSeq_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83a20099 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:380 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0111_IntegrationPSI.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9abe71b | cboPlanType.SelectedIndexChanged | SCP0111_IntegrationPSI.cs:1848 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0111_IntegrationPSI.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1eb2224d | this.Load | SCP0111_IntegrationPSI.cs:299 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d2109614 | this.Load | SCP0111_IntegrationPSI.cs:300 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-469bfdbb | this.Load | SCP0111_IntegrationPSI.cs:301 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0111_IntegrationPSI.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e716cb76 | this.Load | SCP0111_IntegrationPSI.cs:185 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |

## SCP0111_IntegrationPSI.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-784a389e | Dispose | SCP0111_IntegrationPSI.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0111_IntegrationPSI.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4024973 | EditButton | SCP0111_IntegrationPSI.cs:545 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c7fee05a | EditButton | SCP0111_IntegrationPSI.cs:546 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c596aed9 | EditButton | SCP0111_IntegrationPSI.cs:550 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.PLAN_TYPE), siMain.GetColumnIndex(DefMain.INCOTERMS), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e024f936 | EditButton | SCP0111_IntegrationPSI.cs:554 | if (spdMain != null) | COMBO_DATA | Data.Common | (Data.Type.CalendarMonth, false, this.periodFromDate.Substring(0, 6), this.periodToDate.Su… ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-48ac84ba | EditButton | SCP0111_IntegrationPSI.cs:568 | if (spdMain != null) ▸ if (!string.IsNullOrEmpty(nowGroupID) && (nowGroupID == "ADMIN" \|\| nowGroupID == "SCM PI Admin" \|\| nowGroupID == … | FLAG | this._isEditMode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cc41da4c | EditButton | SCP0111_IntegrationPSI.cs:576 | if (spdMain != null) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.UOM), siMain.GetColumnIndex(DefMain.TO_SITE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0a1572d8 | EditButton | SCP0111_IntegrationPSI.cs:589 | if (spdMain != null) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (k… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(month), iRow, siMain.GetColumnIndex(month), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-360e414f | EditButton | SCP0111_IntegrationPSI.cs:600 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.BOH_QTY), siMain.GetColumnIndex(DefMain.TO_SITE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a2971a1d | EditButton | SCP0111_IntegrationPSI.cs:615 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (division_id != "82" && division_id != "40"… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(startDate), iRow, siMain.GetColumnIndex(endDate), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4298a3e0 | EditButton | SCP0111_IntegrationPSI.cs:622 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (division_id != "82" && division_id != "40"… | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "MULTI_CHILD_ITEM") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aa13c657 | EditButton | SCP0111_IntegrationPSI.cs:642 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (division_id != "82" && division_id != "40"… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(startDate), iRow, siMain.GetColumnIndex(endDate), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2b11672a | EditButton | SCP0111_IntegrationPSI.cs:652 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (division_id != "82" && division_id != "40"… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefMain.BOH_QTY), iRow, siMain.GetColumnIndex(DefMain.BOH_QTY… | 그리드 편집 잠금/해제 |  |  |  |
| AC-48e401f6 | EditButton | SCP0111_IntegrationPSI.cs:664 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (division_id != "82" && division_id != "40"… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(month), iRow, siMain.GetColumnIndex(month), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-70f43b37 | EditButton | SCP0111_IntegrationPSI.cs:682 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ else of (division_id != "82" && division_id !=… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(startDate), iRow, siMain.GetColumnIndex(endDate), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7b90c811 | EditButton | SCP0111_IntegrationPSI.cs:688 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ else of (division_id != "82" && division_id !=… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(startDate), iRow, siMain.GetColumnIndex(endDate), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f5a5f7fa | EditButton | SCP0111_IntegrationPSI.cs:694 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ else of (division_id != "82" && division_id !=… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefMain.BOH_QTY), iRow, siMain.GetColumnIndex(DefMain.BOH_QTY… | 그리드 편집 잠금/해제 |  |  |  |
| AC-645e735f | EditButton | SCP0111_IntegrationPSI.cs:705 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ else of (division_id != "82" && division_id !=… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(month), iRow, siMain.GetColumnIndex(month), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4c0ac38b | EditButton | SCP0111_IntegrationPSI.cs:726 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ else of (division_id != "82" && division_id !=… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(startDate), iRow, siMain.GetColumnIndex(endDate), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9565b226 | EditButton | SCP0111_IntegrationPSI.cs:732 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ else of (division_id != "82" && division_id !=… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(startDate), iRow, siMain.GetColumnIndex(endDate), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-85c2922c | EditButton | SCP0111_IntegrationPSI.cs:738 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ else of (division_id != "82" && division_id !=… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(startDate), iRow, siMain.GetColumnIndex(endDate), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1275cc87 | EditButton | SCP0111_IntegrationPSI.cs:757 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ else of (division_id != "82" && division_id !=… | GRID_STYLE | siMain.SetBGColor2 | (iRow, siMain.GetColumnIndex(startDate), iRow, siMain.GetColumnIndex(endDate), mColor) | 그리드 표시 설정 |  |  |  |
| AC-dd156af1 | EditButton | SCP0111_IntegrationPSI.cs:767 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ else of (division_id != "82" && division_id !=… | FLAG | dtPSI | DBUtils.Filter(dtPSIAll, "ITEM_ID = '" + sToProduct + "' AND MEASURE = 'PROD_PLAN' ", true… | 화면 필드/플래그 변경 |  |  |  |
| AC-edd76824 | EditButton | SCP0111_IntegrationPSI.cs:767 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ else of (division_id != "82" && division_id !=… | DATA_OP | DBUtils.Filter | (dtPSIAll, "ITEM_ID = '" + sToProduct + "' AND MEASURE = 'PROD_PLAN' ", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0ffdd4d5 | EditButton | SCP0111_IntegrationPSI.cs:782 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ else of (division_id != "82" && division_id !=… | GRID_STYLE | siMain.SetBGColor2 | (iRow, siMain.GetColumnIndex(startDate), iRow, siMain.GetColumnIndex(endDate), mColor) | 그리드 표시 설정 |  |  |  |
| AC-4b163d07 | EditButton | SCP0111_IntegrationPSI.cs:791 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ else of (division_id != "82" && division_id !=… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefMain.BOH_QTY), iRow, siMain.GetColumnIndex(DefMain.BOH_QTY… | 그리드 편집 잠금/해제 |  |  |  |
| AC-65f18b07 | EditButton | SCP0111_IntegrationPSI.cs:803 | if (spdMain != null) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ else of (division_id != "82" && division_id !=… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(month), iRow, siMain.GetColumnIndex(month), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0111_IntegrationPSI.FindData_Main

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f50f0caf | FindButton 외 1 | SCP0111_IntegrationPSI.cs:833 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f1f5bb12 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:839 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-21599a71 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:839 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad3f7bb1 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:847 | try ▸ if (DateTime.Compare(dtFrom, dtTo) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00344") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-78f4b245 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:848 | try ▸ if (DateTime.Compare(dtFrom, dtTo) > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-209c5a12 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:852 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fc76584a | FindButton 외 1 | SCP0111_IntegrationPSI.cs:868 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4572bd66 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:870 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a0f00c5b | FindButton 외 1 | SCP0111_IntegrationPSI.cs:874 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0111_GET_INTEGRATION_PSI") ⇒ SCP.SCP0111_GET_INTEGRATION_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-5877f52b | FindButton 외 1 | SCP0111_IntegrationPSI.cs:875 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b3b8bfde | FindButton 외 1 | SCP0111_IntegrationPSI.cs:876 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-627d3892 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:877 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-de093f86 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:878 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4c7c470f | FindButton 외 1 | SCP0111_IntegrationPSI.cs:879 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f954c95b | FindButton 외 1 | SCP0111_IntegrationPSI.cs:880 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymm"] | p_from_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-a57329d9 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:881 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymm"] | p_to_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-5626bc65 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:882 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-a68f9515 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:883 | try ▸ lambda | DATA_OP | req.Parameters["p_cellitem_id"] | p_cellitem_id | 행/컬럼 값 대입 |  |  |  |
| AC-90193122 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:884 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-6c39c644 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:885 | try ▸ lambda | DATA_OP | req.Parameters["p_qty_yn"] | (chkQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-d88f0458 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:887 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-947d029b | FindButton 외 1 | SCP0111_IntegrationPSI.cs:888 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a3711462 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:897 | try ▸ if (dsBinding.Tables.Count > 0) | FLAG | this.dtPSIAll | dsBinding.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-45eab883 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:897 | try ▸ if (dsBinding.Tables.Count > 0) | DATA_OP | dsBinding.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-46664f2f | FindButton 외 1 | SCP0111_IntegrationPSI.cs:900 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9307b7d1 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:901 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee63333a | FindButton 외 1 | SCP0111_IntegrationPSI.cs:902 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c0d0eb24 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:907 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-414554e8 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:909 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-139d0034 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:915 | try | FLAG | this.periodFromDate | p_from_yyyymm.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d453ec64 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:916 | try | FLAG | this.periodToDate | p_to_yyyymm.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c6e3e971 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:924 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06e70471 | FindButton 외 1 | SCP0111_IntegrationPSI.cs:928 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2019f43b | FindButton 외 1 | SCP0111_IntegrationPSI.cs:930 | finally | FLAG | this._currRowIdx | 0 | 화면 필드/플래그 변경 |  |  |  |

## SCP0111_IntegrationPSI.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d911b9f4 | this.Load | SCP0111_IntegrationPSI.cs:172 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0111_IntegrationPSI.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1842c708 | this.Load | SCP0111_IntegrationPSI.cs:1095 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-bfb67d81 | this.Load | SCP0111_IntegrationPSI.cs:1096 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e7a2852f | this.Load | SCP0111_IntegrationPSI.cs:1098 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0111_IntegrationPSI.GetDayRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b28a3158 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:1800 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, BucketType.Monthly, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-71416e66 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:1801 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0111_IntegrationPSI.GetEssPackLineAll

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d53eece | this.Load | SCP0111_IntegrationPSI.cs:484 |  | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-832f7979 | this.Load | SCP0111_IntegrationPSI.cs:486 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a120eba6 | this.Load | SCP0111_IntegrationPSI.cs:490 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0111_GET_ESS_PACK_LINE") ⇒ SCP.SCP0111_GET_ESS_PACK_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-dd515771 | this.Load | SCP0111_IntegrationPSI.cs:491 | lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3d11674e | this.Load | SCP0111_IntegrationPSI.cs:493 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-75dc9cef | this.Load | SCP0111_IntegrationPSI.cs:494 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8f48dfef | this.Load | SCP0111_IntegrationPSI.cs:500 | if (dsBinding.Tables.Count > 0) | FLAG | this.dtEssPackLineAll | dsBinding.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-bcacd6b4 | this.Load | SCP0111_IntegrationPSI.cs:500 | if (dsBinding.Tables.Count > 0) | DATA_OP | dsBinding.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0111_IntegrationPSI.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-566bc305 | this.Load | SCP0111_IntegrationPSI.cs:226 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-7fdd04d9 | this.Load | SCP0111_IntegrationPSI.cs:229 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc80c1e0 | this.Load | SCP0111_IntegrationPSI.cs:230 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4b365ce | this.Load | SCP0111_IntegrationPSI.cs:233 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-420fbd3f | this.Load | SCP0111_IntegrationPSI.cs:235 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-77e08009 | this.Load | SCP0111_IntegrationPSI.cs:244 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |

## SCP0111_IntegrationPSI.InitFromToDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f23107a | (진입점 미연결) | SCP0111_IntegrationPSI.cs:1813 | if (initValue != null) ▸ if (initValue.Length > 0 && initValue.IndexOf(':') > -1) | FLAG | this.periodFromDate | initDates[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-d425f124 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:1814 | if (initValue != null) ▸ if (initValue.Length > 0 && initValue.IndexOf(':') > -1) | FLAG | this.periodToDate | initDates[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-a525961d | (진입점 미연결) | SCP0111_IntegrationPSI.cs:1819 | if (initValue != null) ▸ else of (initValue.Length > 0 && initValue.IndexOf(':') > -1) | FLAG | this.periodFromDate | date | 화면 필드/플래그 변경 |  |  |  |
| AC-969dadad | (진입점 미연결) | SCP0111_IntegrationPSI.cs:1820 | if (initValue != null) ▸ else of (initValue.Length > 0 && initValue.IndexOf(':') > -1) | FLAG | this.periodToDate | date | 화면 필드/플래그 변경 |  |  |  |
| AC-5a488730 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:1826 | else of (initValue != null) | FLAG | this.periodFromDate | date | 화면 필드/플래그 변경 |  |  |  |
| AC-0999e8c3 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:1827 | else of (initValue != null) | FLAG | this.periodToDate | date | 화면 필드/플래그 변경 |  |  |  |

## SCP0111_IntegrationPSI.InitSpread

진입점: this.Load / cboPlanDate.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fffe318f | this.Load 외 3 | SCP0111_IntegrationPSI.cs:309 |  | UI_PROP | this.IsEditMode | false | 속성 IsEditMode 설정 |  |  |  |
| AC-ad57a1d0 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:310 |  | FLAG | this._isEditMode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bc9b0a59 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:312 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-4fd6735d | this.Load 외 3 | SCP0111_IntegrationPSI.cs:315 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("LookupLine", dtLineAll) | 목록 컨트롤 재구성 |  |  |  |
| AC-aa3f17ac | this.Load 외 3 | SCP0111_IntegrationPSI.cs:333 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-dda9c0fc | this.Load 외 3 | SCP0111_IntegrationPSI.cs:337 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0111_IntegrationPSI.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48006b78 | InsertButton | SCP0111_IntegrationPSI.cs:967 | if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-188d18ec | InsertButton | SCP0111_IntegrationPSI.cs:972 | if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, division) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e8d6668 | InsertButton | SCP0111_IntegrationPSI.cs:974 | if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-920c3677 | InsertButton | SCP0111_IntegrationPSI.cs:976 | if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.DIVISION_ID), siMain.GetColumnIndex(DefMain.DIVISI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-afc699c7 | InsertButton | SCP0111_IntegrationPSI.cs:986 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3d43b1c2 | InsertButton | SCP0111_IntegrationPSI.cs:989 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | FLAG | this._currRowIdx | this._currRowIdx + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-a505ff3f | InsertButton | SCP0111_IntegrationPSI.cs:1027 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.PLAN_TYPE, plan_type) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc6fce9e | InsertButton | SCP0111_IntegrationPSI.cs:1028 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, division) | 데이터 객체 조작/조회 |  |  |  |
| AC-cccb5bf2 | InsertButton | SCP0111_IntegrationPSI.cs:1029 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.OPERATION_GROUP, operation_group) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e9cc448 | InsertButton | SCP0111_IntegrationPSI.cs:1030 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.CELL_MODEL_NICK_NAME, cell_model_nick_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-23983eeb | InsertButton | SCP0111_IntegrationPSI.cs:1031 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.CELL_ITEM_ID, cellitem_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-df924245 | InsertButton | SCP0111_IntegrationPSI.cs:1032 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.NICK_NAME, nick_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-af38c88e | InsertButton | SCP0111_IntegrationPSI.cs:1033 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.ITEM_ID, item_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba55c954 | InsertButton | SCP0111_IntegrationPSI.cs:1034 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.CELL_CF, cell_cf) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f665fd4 | InsertButton | SCP0111_IntegrationPSI.cs:1035 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.COMPANY_ID, company_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-06e8d133 | InsertButton | SCP0111_IntegrationPSI.cs:1036 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.PLANT_ID, plant_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-97687952 | InsertButton | SCP0111_IntegrationPSI.cs:1037 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, measure_label) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d21b38c | InsertButton | SCP0111_IntegrationPSI.cs:1038 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.VALUE_TYPE, valuation_type) | 데이터 객체 조작/조회 |  |  |  |
| AC-2abf0413 | InsertButton | SCP0111_IntegrationPSI.cs:1039 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.TO_PRODUCT, to_product) | 데이터 객체 조작/조회 |  |  |  |
| AC-13af6e10 | InsertButton | SCP0111_IntegrationPSI.cs:1040 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.LINE_ID, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-b622e8cb | InsertButton | SCP0111_IntegrationPSI.cs:1041 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.TO_SITE, to_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-05a82396 | InsertButton | SCP0111_IntegrationPSI.cs:1042 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.INCOTERMS, incoterms) | 데이터 객체 조작/조회 |  |  |  |
| AC-1974a7ef | InsertButton | SCP0111_IntegrationPSI.cs:1043 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.BOH_QTY, 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce3a4f7a | InsertButton | SCP0111_IntegrationPSI.cs:1044 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.UOM, uom) | 데이터 객체 조작/조회 |  |  |  |
| AC-5777d1db | InsertButton | SCP0111_IntegrationPSI.cs:1045 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.SEQ_FLAG, seq_flag) | 데이터 객체 조작/조회 |  |  |  |
| AC-599deae3 | InsertButton | SCP0111_IntegrationPSI.cs:1046 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.MEASURE, measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-95a69124 | InsertButton | SCP0111_IntegrationPSI.cs:1048 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.PLANT_ID_DESCRIPTION, plant_id_description) | 데이터 객체 조작/조회 |  |  |  |
| AC-7cbc80f5 | InsertButton | SCP0111_IntegrationPSI.cs:1049 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.TO_SITE_DESCRIPTION, to_site_description) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6146ab9 | InsertButton | SCP0111_IntegrationPSI.cs:1052 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-b69c55e4 | InsertButton | SCP0111_IntegrationPSI.cs:1054 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.PLAN_TYPE), siMain.GetColumnIndex(DefMain.VALUE_TY… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f252d7eb | InsertButton | SCP0111_IntegrationPSI.cs:1057 | else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPTION), siMain.GetMaxColumnIndex(), … | 그리드 편집 잠금/해제 |  |  |  |

## SCP0111_IntegrationPSI.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fba33819 | OnShown | SCP0111_IntegrationPSI.cs:1935 |  | VALUE_SET | this.cmbFromMonth.SelectedValue | this.periodFromDate.Substring(0, 6) | 컨트롤 값 설정 |  |  |  |
| AC-a3c601fe | OnShown | SCP0111_IntegrationPSI.cs:1936 |  | VALUE_SET | this.cmbToMonth.SelectedValue | this.periodToDate.Substring(0, 6) | 컨트롤 값 설정 |  |  |  |

## SCP0111_IntegrationPSI.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64c7b8b3 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0111_IntegrationPSI.cs:408 |  | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND CODE IN ('SE', 'FN')", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-321557ec | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0111_IntegrationPSI.cs:426 | if (dtPlanTypeFN.Rows.Count > 0) | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + division + "' AND CODE IN (" + sPlanDate… | 화면 필드/플래그 변경 |  |  |  |
| AC-60a3326e | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0111_IntegrationPSI.cs:426 | if (dtPlanTypeFN.Rows.Count > 0) | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + division + "' AND CODE IN (" + sPlanDateFN + ")") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6c76a95b | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0111_IntegrationPSI.cs:430 | else of (dtPlanTypeFN.Rows.Count > 0) | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-f38c7e9d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0111_IntegrationPSI.cs:430 | else of (dtPlanTypeFN.Rows.Count > 0) | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a76bb71b | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0111_IntegrationPSI.cs:434 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0111_IntegrationPSI.RefreshPlanType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1a68673 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:441 |  | FLAG | dtPlanType | DBUtils.Filter(dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanD… | 화면 필드/플래그 변경 |  |  |  |
| AC-b3c5a5fe | (진입점 미연결) | SCP0111_IntegrationPSI.cs:441 |  | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "'", tru… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9227eef2 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:443 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0111_IntegrationPSI.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d72b5392 | SaveButton | SCP0111_IntegrationPSI.cs:1105 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f9d67533 | SaveButton | SCP0111_IntegrationPSI.cs:1154 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | COMBO_DATA | Data.Common | (Data.Type.CalendarMonth, false, this.periodFromDate.Substring(0, 6), this.periodToDate.Su… ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-01a371b4 | SaveButton | SCP0111_IntegrationPSI.cs:1202 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for (i <… | FLAG | dtPSI | DBUtils.Filter(dtPSIAll, sb.ToString(), true) | 화면 필드/플래그 변경 |  |  |  |
| AC-3497b5bb | SaveButton | SCP0111_IntegrationPSI.cs:1202 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for (i <… | DATA_OP | DBUtils.Filter | (dtPSIAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3bb22073 | SaveButton | SCP0111_IntegrationPSI.cs:1205 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for (i <… | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-be598105 | SaveButton | SCP0111_IntegrationPSI.cs:1209 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for (i <… | DATA_OP | DBUtils.Filter | (dtOg, "NAME = '" + operation_group + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3a046392 | SaveButton | SCP0111_IntegrationPSI.cs:1217 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for (i <… | MESSAGE | MessageHelper.GMessageBox | ("OPERATION_GROUP이 Lookup에 없는 값입니다. ") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c5e0bdd | SaveButton | SCP0111_IntegrationPSI.cs:1218 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for (i <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df02322a | SaveButton | SCP0111_IntegrationPSI.cs:1228 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for (i <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c0b4214a | SaveButton | SCP0111_IntegrationPSI.cs:1229 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for (i <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98a94729 | SaveButton | SCP0111_IntegrationPSI.cs:1237 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for (i <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0f525902 | SaveButton | SCP0111_IntegrationPSI.cs:1238 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for (i <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-477ef590 | SaveButton | SCP0111_IntegrationPSI.cs:1242 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for (i <… | COMBO_DATA | Data.Common | (Data.Type.CalendarMonth, false, p_plan_start_yyyymmdd.Substring(0, 6), this._toDate.Subst… ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fffea736 | SaveButton | SCP0111_IntegrationPSI.cs:1375 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-14e18f54 | SaveButton | SCP0111_IntegrationPSI.cs:1379 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | ENDPOINT | new FoxDataRequest | ("SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN") ⇒ SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN | 엔드포인트 요청 생성 |  |  |  |
| AC-336f1247 | SaveButton | SCP0111_IntegrationPSI.cs:1383 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0c79663f | SaveButton | SCP0111_IntegrationPSI.cs:1387 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-01fe6a66 | SaveButton | SCP0111_IntegrationPSI.cs:1388 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-22a72c1c | SaveButton | SCP0111_IntegrationPSI.cs:1389 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d3ba9f1f | SaveButton | SCP0111_IntegrationPSI.cs:1390 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-5a4a6b48 | SaveButton | SCP0111_IntegrationPSI.cs:1391 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-db2ffb5c | SaveButton | SCP0111_IntegrationPSI.cs:1392 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-54253829 | SaveButton | SCP0111_IntegrationPSI.cs:1393 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-bb9e1df0 | SaveButton | SCP0111_IntegrationPSI.cs:1394 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_cellitem_id"] | p_cellitem_id | 행/컬럼 값 대입 |  |  |  |
| AC-bccaede6 | SaveButton | SCP0111_IntegrationPSI.cs:1395 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-7f8ed4aa | SaveButton | SCP0111_IntegrationPSI.cs:1396 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_measure"] | p_measure | 행/컬럼 값 대입 |  |  |  |
| AC-ffa101a0 | SaveButton | SCP0111_IntegrationPSI.cs:1397 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_valuation_type"] | p_valuation_type | 행/컬럼 값 대입 |  |  |  |
| AC-a67dc9b8 | SaveButton | SCP0111_IntegrationPSI.cs:1398 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_to_product"] | p_to_product | 행/컬럼 값 대입 |  |  |  |
| AC-389cf964 | SaveButton | SCP0111_IntegrationPSI.cs:1399 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-2985c49f | SaveButton | SCP0111_IntegrationPSI.cs:1400 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-eb19da6f | SaveButton | SCP0111_IntegrationPSI.cs:1401 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-687c5b48 | SaveButton | SCP0111_IntegrationPSI.cs:1402 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_boh_qty"] | p_boh_qty | 행/컬럼 값 대입 |  |  |  |
| AC-4586534d | SaveButton | SCP0111_IntegrationPSI.cs:1403 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_seq_flag"] | p_seq_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f8ee7e39 | SaveButton | SCP0111_IntegrationPSI.cs:1404 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_yyyymm"] | p_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-f0dfc4a5 | SaveButton | SCP0111_IntegrationPSI.cs:1405 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_modiQty"] | p_modiQty | 행/컬럼 값 대입 |  |  |  |
| AC-6fd839d9 | SaveButton | SCP0111_IntegrationPSI.cs:1406 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-74f95172 | SaveButton | SCP0111_IntegrationPSI.cs:1408 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e34f0108 | SaveButton | SCP0111_IntegrationPSI.cs:1408 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-35c349cc | SaveButton | SCP0111_IntegrationPSI.cs:1412 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-27dea432 | SaveButton | SCP0111_IntegrationPSI.cs:1419 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c4975731 | SaveButton | SCP0111_IntegrationPSI.cs:1427 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d3e0f7cd | SaveButton | SCP0111_IntegrationPSI.cs:1434 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a685c5e6 | SaveButton | SCP0111_IntegrationPSI.cs:1435 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47426849 | SaveButton | SCP0111_IntegrationPSI.cs:1439 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCou… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1d64445a | SaveButton | SCP0111_IntegrationPSI.cs:1490 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for… | FLAG | dtPSI | DBUtils.Filter(dtPSIAll, sb.ToString(), true) | 화면 필드/플래그 변경 |  |  |  |
| AC-f5ccfed9 | SaveButton | SCP0111_IntegrationPSI.cs:1490 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for… | DATA_OP | DBUtils.Filter | (dtPSIAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6aa417c5 | SaveButton | SCP0111_IntegrationPSI.cs:1495 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-631f00b9 | SaveButton | SCP0111_IntegrationPSI.cs:1496 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cfabaa64 | SaveButton | SCP0111_IntegrationPSI.cs:1502 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for… | MESSAGE | MessageHelper.GMessageBox | ("MSG00453") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-468689e2 | SaveButton | SCP0111_IntegrationPSI.cs:1504 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for… | FLAG | this._isEditMode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f7508b7d | SaveButton | SCP0111_IntegrationPSI.cs:1505 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-744c94dd | SaveButton | SCP0111_IntegrationPSI.cs:1511 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for… | COMBO_DATA | Data.Common | (Data.Type.CalendarMonth, false, p_plan_start_yyyymmdd.Substring(0, 6), this._toDate.Subst… ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1d0a3904 | SaveButton | SCP0111_IntegrationPSI.cs:1544 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for… | FLAG | dtPSI | DBUtils.Filter(dtPSIAll, "DIVISION_ID = '" + division_id + "' AND PLANT_ID = '" + plant_id… | 화면 필드/플래그 변경 |  |  |  |
| AC-1b665cf6 | SaveButton | SCP0111_IntegrationPSI.cs:1544 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ for… | DATA_OP | DBUtils.Filter | (dtPSIAll, "DIVISION_ID = '" + division_id + "' AND PLANT_ID = '" + plant_id + "' AND CELL… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d8c30ccf | SaveButton | SCP0111_IntegrationPSI.cs:1633 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ebcb2f30 | SaveButton | SCP0111_IntegrationPSI.cs:1637 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | ENDPOINT | new FoxDataRequest | ("SCP.SCP0111_SAVE_INTEGRATION_PSI") ⇒ SCP.SCP0111_SAVE_INTEGRATION_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-6429d173 | SaveButton | SCP0111_IntegrationPSI.cs:1641 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c7e5fa81 | SaveButton | SCP0111_IntegrationPSI.cs:1645 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ae8b7064 | SaveButton | SCP0111_IntegrationPSI.cs:1646 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-c4edb93b | SaveButton | SCP0111_IntegrationPSI.cs:1647 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-edf77ba6 | SaveButton | SCP0111_IntegrationPSI.cs:1649 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-a6ed5a6c | SaveButton | SCP0111_IntegrationPSI.cs:1650 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-ed89eac9 | SaveButton | SCP0111_IntegrationPSI.cs:1651 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-53d7b99c | SaveButton | SCP0111_IntegrationPSI.cs:1653 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7b382c11 | SaveButton | SCP0111_IntegrationPSI.cs:1654 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_seq_flag"] | p_seq_flag | 행/컬럼 값 대입 |  |  |  |
| AC-98f56467 | SaveButton | SCP0111_IntegrationPSI.cs:1655 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_cellitem_id"] | p_cellitem_id | 행/컬럼 값 대입 |  |  |  |
| AC-763eef69 | SaveButton | SCP0111_IntegrationPSI.cs:1656 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-28cd95fb | SaveButton | SCP0111_IntegrationPSI.cs:1657 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_measure"] | p_measure | 행/컬럼 값 대입 |  |  |  |
| AC-aca956ea | SaveButton | SCP0111_IntegrationPSI.cs:1658 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-4e2e62eb | SaveButton | SCP0111_IntegrationPSI.cs:1659 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-5fe25709 | SaveButton | SCP0111_IntegrationPSI.cs:1660 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_valuation_type"] | p_valuation_type | 행/컬럼 값 대입 |  |  |  |
| AC-4825f782 | SaveButton | SCP0111_IntegrationPSI.cs:1661 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_to_product"] | p_to_product | 행/컬럼 값 대입 |  |  |  |
| AC-407e2998 | SaveButton | SCP0111_IntegrationPSI.cs:1662 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-fb588295 | SaveButton | SCP0111_IntegrationPSI.cs:1663 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_yyyymm"] | p_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-950f9944 | SaveButton | SCP0111_IntegrationPSI.cs:1664 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_modiQty"] | p_modiQty | 행/컬럼 값 대입 |  |  |  |
| AC-8aae3c94 | SaveButton | SCP0111_IntegrationPSI.cs:1665 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4818abe8 | SaveButton | SCP0111_IntegrationPSI.cs:1668 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f5151d68 | SaveButton | SCP0111_IntegrationPSI.cs:1670 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-86e491ee | SaveButton | SCP0111_IntegrationPSI.cs:1670 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-573c6149 | SaveButton | SCP0111_IntegrationPSI.cs:1674 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5f8effae | SaveButton | SCP0111_IntegrationPSI.cs:1681 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-479bcc96 | SaveButton | SCP0111_IntegrationPSI.cs:1689 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9e715529 | SaveButton | SCP0111_IntegrationPSI.cs:1696 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-eb9eb44c | SaveButton | SCP0111_IntegrationPSI.cs:1697 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-efbc1d37 | SaveButton | SCP0111_IntegrationPSI.cs:1701 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if … | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0111_IntegrationPSI.Set_MeasureColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b59c717 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:937 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30d6b259 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:949 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-3668ad22 | (진입점 미연결) | SCP0111_IntegrationPSI.cs:953 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0111_IntegrationPSI.SetCalendar

진입점: this.Load / cboPlanDate.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03db839c | this.Load 외 3 | SCP0111_IntegrationPSI.cs:345 |  | COMBO_DATA | Data.Common | (Data.Type.CalendarMonth, false, this.cmbFromMonth.SelectedValue.ToString().Substring(0, 6… ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f6bf7e85 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:351 | foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefMain.YYYYMM) | 데이터 객체 조작/조회 |  |  |  |
| AC-19fa6130 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:352 | foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefMain.YYYYMM_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d1f09f9 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:354 | foreach (var a in dtCalendar.AsEnumerable()) | GRID_INIT | spreadinfo.AddNumColumn | (sYYYYMM_NAME, sYYYYMM, FPMerge.None, 75, true) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0111_IntegrationPSI.SetChangedPeriod

진입점: this.Load / cboDivision.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged / cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8248c63 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:269 |  | FLAG | dtScpPlanPeriod | Data_SCP.Common(Data_SCP.Type.SCPPlanPeriod, false, pPlanDate, division) | 화면 필드/플래그 변경 |  |  |  |
| AC-09736ec8 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:269 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SCPPlanPeriod, false, pPlanDate, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-676acd5d | this.Load 외 3 | SCP0111_IntegrationPSI.cs:282 |  | FLAG | this.periodFromDate | pPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-d497e6e7 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:283 |  | FLAG | this.periodToDate | periodMonth | 화면 필드/플래그 변경 |  |  |  |
| AC-74a0a9a6 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:284 |  | FLAG | this._toDate | toDate | 화면 필드/플래그 변경 |  |  |  |
| AC-251e29f7 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:287 |  | COMBO_DATA | Data.Common | (Data.Type.CalendarMonth, false, pPlanDate.Substring(0, 6), toDate.Substring(0, 6)) ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-46ec1895 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:288 |  | COMBO_DATA | Data.Common | (Data.Type.CalendarMonth, false, pPlanDate.Substring(0, 6), toDate.Substring(0, 6)) ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b319cfa | this.Load 외 3 | SCP0111_IntegrationPSI.cs:290 |  | LIST_REBIND | this.cmbFromMonth.DataBind | (dtFromMonth) | 목록 컨트롤 재구성 |  |  |  |
| AC-7d7f611a | this.Load 외 3 | SCP0111_IntegrationPSI.cs:291 |  | LIST_REBIND | this.cmbToMonth.DataBind | (dtToMonth) | 목록 컨트롤 재구성 |  |  |  |
| AC-44704e1b | this.Load 외 3 | SCP0111_IntegrationPSI.cs:293 |  | VALUE_SET | this.cmbFromMonth.SelectedValue | strStartYYYYMM | 컨트롤 값 설정 |  |  |  |
| AC-d1fab085 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:294 |  | VALUE_SET | this.cmbToMonth.SelectedValue | periodMonth.Substring(0, 6) | 컨트롤 값 설정 |  |  |  |

## SCP0111_IntegrationPSI.SetSpreadColumn

진입점: this.Load / cboPlanDate.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a9d1b5e | this.Load 외 3 | SCP0111_IntegrationPSI.cs:392 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ef36dfe9 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:396 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0111_IntegrationPSI.SetVisibleSheetColumns

진입점: this.Load / FindButton [try] / EditButton [if (spdMain != null) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN")] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!string.IsNullOrEmpty(nowGroupID) && nowGroupID == "ADMIN") ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-290efc31 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:1069 | if (siMain.OF.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefMain.SEQ_FLAG, 60, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a8b37914 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:1070 | if (siMain.OF.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefMain.MEASURE, 80, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4af1c952 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:1072 | if (siMain.OF.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefMain.PLANT_ID, 65, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-763dc26d | this.Load 외 3 | SCP0111_IntegrationPSI.cs:1073 | if (siMain.OF.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefMain.TO_SITE, 75, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae318ef5 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:1078 | else of (siMain.OF.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefMain.SEQ_FLAG, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-36f5c6bd | this.Load 외 3 | SCP0111_IntegrationPSI.cs:1079 | else of (siMain.OF.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefMain.MEASURE, 0, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6429c62d | this.Load 외 3 | SCP0111_IntegrationPSI.cs:1081 | else of (siMain.OF.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefMain.PLANT_ID, 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb52c8a2 | this.Load 외 3 | SCP0111_IntegrationPSI.cs:1082 | else of (siMain.OF.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (siMain, DefMain.TO_SITE, 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff2d762f | this.Load 외 3 | SCP0111_IntegrationPSI.cs:1086 |  | CALL_EXT | SheetUtils.SetColumHide | (siMain) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0111_IntegrationPSI.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8867fa81 | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1722 |  | FLAG | this._currRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-e9ddda2f | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1726 | if (!this._isEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25b2eb9c | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1735 | else of (!this._isEditMode) ▸ if (action != CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57409580 | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1765 | else of (!this._isEditMode) ▸ if (columnName == DefMain.LINE_ID) ▸ if (division == "82" && operation_group == "P") | FLAG | dtLine | DBUtils.Filter(dtEssPackLineAll, sb.ToString(), true) | 화면 필드/플래그 변경 |  |  |  |
| AC-ab6a5cb4 | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1765 | else of (!this._isEditMode) ▸ if (columnName == DefMain.LINE_ID) ▸ if (division == "82" && operation_group == "P") | DATA_OP | DBUtils.Filter | (dtEssPackLineAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cf65dcaa | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1775 | else of (!this._isEditMode) ▸ if (columnName == DefMain.LINE_ID) ▸ else of (division == "82" && operation_group == "P") | FLAG | dtLine | DBUtils.Filter(dtLineAll, sb.ToString(), true) | 화면 필드/플래그 변경 |  |  |  |
| AC-9e216e06 | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1775 | else of (!this._isEditMode) ▸ if (columnName == DefMain.LINE_ID) ▸ else of (division == "82" && operation_group == "P") | DATA_OP | DBUtils.Filter | (dtLineAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7108e34a | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1781 | else of (!this._isEditMode) ▸ if (columnName == DefMain.LINE_ID) ▸ for (i < dtLine.Rows.Count) | GRID_SET | dtLine.Rows[i]["NAME"] | dtLine.Rows[i]["CODE"] | 그리드 속성/값 설정 |  |  |  |
| AC-2bdbfa42 | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1784 | else of (!this._isEditMode) ▸ if (columnName == DefMain.LINE_ID) | DATA_OP | dtLine.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-98965b2d | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1785 | else of (!this._isEditMode) ▸ if (columnName == DefMain.LINE_ID) | DATA_OP | drLine["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-9d1d94b7 | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1786 | else of (!this._isEditMode) ▸ if (columnName == DefMain.LINE_ID) | DATA_OP | drLine["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-74e4abf8 | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1787 | else of (!this._isEditMode) ▸ if (columnName == DefMain.LINE_ID) | CALL_EXT | dtLine.Rows.InsertAt | (drLine, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-439f2acb | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1788 | else of (!this._isEditMode) ▸ if (columnName == DefMain.LINE_ID) | DATA_OP | dtLine.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b6897a4a | this.spdMain.CellClick | SCP0111_IntegrationPSI.cs:1790 | else of (!this._isEditMode) ▸ if (columnName == DefMain.LINE_ID) | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefMain.LINE_ID, dtLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0111_IntegrationPSI.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fed2d46a | this.spdMain.CellDoubleClick | SCP0111_IntegrationPSI.cs:1716 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0111_IntegrationPSI.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-330208e3 | this.spdMain.TopChange | SCP0111_IntegrationPSI.cs:1835 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |


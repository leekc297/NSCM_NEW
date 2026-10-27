# AS-IS 액션 대조표 — DMF0070

> 원천: `Doc/asisfacts/screens/DMF0070/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 211행 · 메서드 22 · 종류 DATA_OP 53 · GRID_LOCK 34 · UI_PROP 21 · FLAG 16 · MESSAGE 12 · RETURN 12 · ENDPOINT 12 · POPUP 11 · UI_MISC 7 · COMBO_DATA 6 · STATE 4 · LIST_REBIND 4 · GRID_STYLE 4 · VALUE_SET 3 · GRID_INIT 3 · GRID_COMBO 3 · GRID_SET 3 · CALL_EXT 1 · THROW 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 1


## DMF0070_PRRequestAuto.btmItem_Click

진입점: this.btmItem.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11845fe3 | this.btmItem.Click | DMF0070_PRRequestAuto.cs:839 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-32636cbf | this.btmItem.Click | DMF0070_PRRequestAuto.cs:841 |  | POPUP | popItem.Form_Load | (true, sdivision, "", sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-69791c4c | this.btmItem.Click | DMF0070_PRRequestAuto.cs:842 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-aac9852f | this.btmItem.Click | DMF0070_PRRequestAuto.cs:843 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-951af4cc | this.btmItem.Click | DMF0070_PRRequestAuto.cs:849 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0070_PRRequestAuto.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d51fd5b2 | this.btnOwner.Click | DMF0070_PRRequestAuto.cs:939 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-af146f55 | this.btnOwner.Click | DMF0070_PRRequestAuto.cs:942 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-62a36322 | this.btnOwner.Click | DMF0070_PRRequestAuto.cs:943 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0e456cbf | this.btnOwner.Click | DMF0070_PRRequestAuto.cs:944 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-81f8ceda | this.btnOwner.Click | DMF0070_PRRequestAuto.cs:946 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0070_PRRequestAuto.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-115be163 | this.btnProject.Click | DMF0070_PRRequestAuto.cs:813 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-c747dfa9 | this.btnProject.Click | DMF0070_PRRequestAuto.cs:814 |  | POPUP | popProject.Form_Load | (true, sDivision, "", sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1e369b19 | this.btnProject.Click | DMF0070_PRRequestAuto.cs:815 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a7da0977 | this.btnProject.Click | DMF0070_PRRequestAuto.cs:816 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3b19e644 | this.btnProject.Click | DMF0070_PRRequestAuto.cs:822 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0070_PRRequestAuto.cboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12bb2baa | cboDivision.SelectedIndexChanged | DMF0070_PRRequestAuto.cs:759 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-30bcd744 | cboDivision.SelectedIndexChanged | DMF0070_PRRequestAuto.cs:760 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-aa537775 | cboDivision.SelectedIndexChanged | DMF0070_PRRequestAuto.cs:774 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4db3da8b | cboDivision.SelectedIndexChanged | DMF0070_PRRequestAuto.cs:778 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d1cf264a | cboDivision.SelectedIndexChanged | DMF0070_PRRequestAuto.cs:779 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8e2829fc | cboDivision.SelectedIndexChanged | DMF0070_PRRequestAuto.cs:790 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0070_PRRequestAuto.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f82bc50 | this.Load | DMF0070_PRRequestAuto.cs:238 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bef53b5f | this.Load | DMF0070_PRRequestAuto.cs:239 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ca2dcf48 | this.Load | DMF0070_PRRequestAuto.cs:240 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9429874c | this.Load | DMF0070_PRRequestAuto.cs:246 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-9d0646a5 | this.Load | DMF0070_PRRequestAuto.cs:247 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-838072f7 | this.Load | DMF0070_PRRequestAuto.cs:248 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-c2f474b1 | this.Load | DMF0070_PRRequestAuto.cs:249 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-c4ef1499 | this.Load | DMF0070_PRRequestAuto.cs:250 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DMF0070_PRRequestAuto.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bc1b391 | Dispose | DMF0070_PRRequestAuto.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0070_PRRequestAuto.drpPeriod_ValueChanged

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9a63dc5 | drpPeriod.ValueChanged | DMF0070_PRRequestAuto.cs:862 | if (dtFrom > dtTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd18a823 | drpPeriod.ValueChanged | DMF0070_PRRequestAuto.cs:864 | if (dtFrom > dtTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0070_PRRequestAuto.EditButton

진입점: EditButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97b2e02c | EditButton 외 1 | DMF0070_PRRequestAuto.cs:306 | if (UserInfoContext.Current["NowGroupID"] == "DM Viewer") | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7c152e2 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:307 | if (UserInfoContext.Current["NowGroupID"] == "DM Viewer") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1abc2578 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:312 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2b207241 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:313 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-7c5c25b1 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:314 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (1, 8, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9edb2fef | EditButton 외 1 | DMF0070_PRRequestAuto.cs:321 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.BOD_VALIDATION), iRow, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5417e27f | EditButton 외 1 | DMF0070_PRRequestAuto.cs:322 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.CHK_FLAG), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bd279e27 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:326 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.IsLock(siMain.SheetName)) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.AUTO_FLAG), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7fa007d8 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:327 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.IsLock(siMain.SheetName)) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.STORAGE_PLANT_ID), iRow, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5826a1c8 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:328 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.IsLock(siMain.SheetName)) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.STORAGE_ID), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-38b43b15 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:329 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.IsLock(siMain.SheetName)) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PR_ITEM_DETAIL), iRow, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7b3a279d | EditButton 외 1 | DMF0070_PRRequestAuto.cs:333 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain.GetC… | GRID_STYLE | siMain.SetBGColor2 | (iRow, 0, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-6ddb78ef | EditButton 외 1 | DMF0070_PRRequestAuto.cs:342 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.AUTO_FLAG), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c056aa97 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:343 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.STORAGE_PLANT_ID), iRow, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e4f9e79a | EditButton 외 1 | DMF0070_PRRequestAuto.cs:344 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.STORAGE_ID), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e6a64b2 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:345 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PR_ITEM_DETAIL), iRow, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c1887d73 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:350 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.STORAGE_PLANT_ID), iRow, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-468e24f4 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:351 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.STORAGE_ID), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-74c2de8e | EditButton 외 1 | DMF0070_PRRequestAuto.cs:352 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PR_ITEM_DETAIL), iRow, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9aed6234 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:357 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.AUTO_FLAG), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-067624f4 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:358 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.STORAGE_PLANT_ID), iRow, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fba2a4b4 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:359 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.STORAGE_ID), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7ee70a44 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:360 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PR_ITEM_DETAIL), iRow, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e0a0c23e | EditButton 외 1 | DMF0070_PRRequestAuto.cs:365 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.AUTO_FLAG), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f4babbd6 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:366 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.STORAGE_PLANT_ID), iRow, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9a0442b4 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:367 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.STORAGE_ID), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee14ad1d | EditButton 외 1 | DMF0070_PRRequestAuto.cs:368 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PR_ITEM_DETAIL), iRow, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bc390689 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:370 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_STYLE | siMain.SetBGColor2 | (iRow, 0, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-9ac352e3 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:378 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.AUTO_FLAG), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1f180df6 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:379 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.STORAGE_PLANT_ID), iRow, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fbd54aa3 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:380 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.STORAGE_ID), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-08791d90 | EditButton 외 1 | DMF0070_PRRequestAuto.cs:381 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetValue(iRow, siMain… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PR_ITEM_DETAIL), iRow, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0070_PRRequestAuto.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-745b3c6a | ExcelButton | DMF0070_PRRequestAuto.cs:418 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-2ee73826 | ExcelButton | DMF0070_PRRequestAuto.cs:419 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-9be81287 | ExcelButton | DMF0070_PRRequestAuto.cs:420 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-a9b21587 | ExcelButton | DMF0070_PRRequestAuto.cs:421 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-e7df97fc | ExcelButton | DMF0070_PRRequestAuto.cs:422 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-03a3274a | ExcelButton | DMF0070_PRRequestAuto.cs:423 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-f944d16a | ExcelButton | DMF0070_PRRequestAuto.cs:425 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-8b7d192c | ExcelButton | DMF0070_PRRequestAuto.cs:426 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-a813a328 | ExcelButton | DMF0070_PRRequestAuto.cs:428 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.##0;[Red]-#,##0.##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-7cf471cb | ExcelButton | DMF0070_PRRequestAuto.cs:437 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6214f4a9 | ExcelButton | DMF0070_PRRequestAuto.cs:442 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-fa92c8c2 | ExcelButton | DMF0070_PRRequestAuto.cs:446 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0070_PRRequestAuto.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d51a757e | FindButton 외 1 | DMF0070_PRRequestAuto.cs:467 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-30734570 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:476 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f766532 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:478 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-546f2011 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:487 | try ▸ if (int.Parse(sDate[0]) > int.Parse(sDate[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-05ca79b7 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:488 | try ▸ if (int.Parse(sDate[0]) > int.Parse(sDate[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f675e7fa | FindButton 외 1 | DMF0070_PRRequestAuto.cs:493 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-387a83d3 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:495 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-a646f3f0 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:497 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e452a1c | FindButton 외 1 | DMF0070_PRRequestAuto.cs:500 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a95e5986 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:512 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0070_GET_REQUEST_AUTO_LIST") ⇒ DM.DMF0070_GET_REQUEST_AUTO_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-d1707bfd | FindButton 외 1 | DMF0070_PRRequestAuto.cs:514 | try | DATA_OP | request.Parameters["P_DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a6ff9c4c | FindButton 외 1 | DMF0070_PRRequestAuto.cs:515 | try | DATA_OP | request.Parameters["P_SCM_SITE_ID"] | clbScmSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-f4e17e6c | FindButton 외 1 | DMF0070_PRRequestAuto.cs:516 | try | DATA_OP | request.Parameters["P_DATE_FROM"] | sDate[0].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-be3332aa | FindButton 외 1 | DMF0070_PRRequestAuto.cs:517 | try | DATA_OP | request.Parameters["P_DATE_TO"] | sDate[1].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a0a165fe | FindButton 외 1 | DMF0070_PRRequestAuto.cs:518 | try | DATA_OP | request.Parameters["P_PROJECT"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-8fb0dcc5 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:519 | try | DATA_OP | request.Parameters["P_ITEM_ID"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-a0e13cf1 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:520 | try | DATA_OP | request.Parameters["P_OWNER"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-7404b2a4 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:521 | try | DATA_OP | request.Parameters["P_USER_GROUP"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-667c6fd5 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:522 | try | DATA_OP | request.Parameters["P_USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-05eaa82a | FindButton 외 1 | DMF0070_PRRequestAuto.cs:524 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a870cf21 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:526 | try | FLAG | dsMain | response.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-a1eaebba | FindButton 외 1 | DMF0070_PRRequestAuto.cs:532 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-414d98f3 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:534 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e9213909 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:535 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-aea9fd11 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:542 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK_FLAG)).ToString() == "N") | GRID_STYLE | siMain.SetBGColor2 | (i, 0, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-8be240d3 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:547 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK_FLAG)).ToString() == "N") | GRID_STYLE | siMain.SetBGColor2 | (0, 0, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), Color.White) | 그리드 표시 설정 |  |  |  |
| AC-53e6473a | FindButton 외 1 | DMF0070_PRRequestAuto.cs:558 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-04f0ea68 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:562 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d12ff439 | FindButton 외 1 | DMF0070_PRRequestAuto.cs:564 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0070_PRRequestAuto.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a73664e2 | this.Load | DMF0070_PRRequestAuto.cs:130 |  | FLAG | dtPlant | GetSPlant() | 화면 필드/플래그 변경 |  |  |  |
| AC-fcc26032 | this.Load | DMF0070_PRRequestAuto.cs:131 |  | FLAG | dtSLOC | GetSLOC("") | 화면 필드/플래그 변경 |  |  |  |
| AC-da624654 | this.Load | DMF0070_PRRequestAuto.cs:133 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f33d82fe | this.Load | DMF0070_PRRequestAuto.cs:134 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0070_PRRequestAuto.GetDayRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3956001 | (진입점 미연결) | DMF0070_PRRequestAuto.cs:918 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-e9994b05 | (진입점 미연결) | DMF0070_PRRequestAuto.cs:919 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-217a8b08 | (진입점 미연결) | DMF0070_PRRequestAuto.cs:920 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-53cbbf8e | (진입점 미연결) | DMF0070_PRRequestAuto.cs:922 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a60f69a4 | (진입점 미연결) | DMF0070_PRRequestAuto.cs:925 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0070_PRRequestAuto.GetSLOC

진입점: this.spdMain.CellClick [if (!siMain.IsLock()) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.BNP_IN_DATE)).ToString() == "") ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.STORAGE_PLANT_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.STORAGE_ID))] / this.Load / dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.STORAGE_PLANT_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d18e3955 | this.spdMain.CellClick [if (!siMain.IsLock()) ▸ if (siMain.G… 외 2 | DMF0070_PRRequestAuto.cs:973 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-7ed17862 | this.spdMain.CellClick [if (!siMain.IsLock()) ▸ if (siMain.G… 외 2 | DMF0070_PRRequestAuto.cs:974 |  | DATA_OP | request.Parameters["CODE"] | "PR_SLOC" | 행/컬럼 값 대입 |  |  |  |
| AC-c5e45089 | this.spdMain.CellClick [if (!siMain.IsLock()) ▸ if (siMain.G… 외 2 | DMF0070_PRRequestAuto.cs:975 |  | DATA_OP | request.Parameters["PARAM1"] | SPlant | 행/컬럼 값 대입 |  |  |  |
| AC-d0369a31 | this.spdMain.CellClick [if (!siMain.IsLock()) ▸ if (siMain.G… 외 2 | DMF0070_PRRequestAuto.cs:976 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9b66005a | this.spdMain.CellClick [if (!siMain.IsLock()) ▸ if (siMain.G… 외 2 | DMF0070_PRRequestAuto.cs:977 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9b8dbc78 | this.spdMain.CellClick [if (!siMain.IsLock()) ▸ if (siMain.G… 외 2 | DMF0070_PRRequestAuto.cs:978 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-af76a332 | this.spdMain.CellClick [if (!siMain.IsLock()) ▸ if (siMain.G… 외 2 | DMF0070_PRRequestAuto.cs:979 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8f156591 | this.spdMain.CellClick [if (!siMain.IsLock()) ▸ if (siMain.G… 외 2 | DMF0070_PRRequestAuto.cs:980 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d843807 | this.spdMain.CellClick [if (!siMain.IsLock()) ▸ if (siMain.G… 외 2 | DMF0070_PRRequestAuto.cs:982 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0070_PRRequestAuto.GetSpdTitle

진입점: this.Load / cboDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78562fce | this.Load 외 3 | DMF0070_PRRequestAuto.cs:1030 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-9a60a25e | this.Load 외 3 | DMF0070_PRRequestAuto.cs:1031 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-559f8803 | this.Load 외 3 | DMF0070_PRRequestAuto.cs:1032 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec3b2480 | this.Load 외 3 | DMF0070_PRRequestAuto.cs:1033 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0b4ca2b4 | this.Load 외 3 | DMF0070_PRRequestAuto.cs:1034 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0070" | 행/컬럼 값 대입 |  |  |  |
| AC-9ac0e483 | this.Load 외 3 | DMF0070_PRRequestAuto.cs:1035 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-7e4431c3 | this.Load 외 3 | DMF0070_PRRequestAuto.cs:1036 |  | DATA_OP | request.Parameters["p_division_id"] | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-e6d07793 | this.Load 외 3 | DMF0070_PRRequestAuto.cs:1038 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e61730ad | this.Load 외 3 | DMF0070_PRRequestAuto.cs:1040 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0070_PRRequestAuto.GetSPlant

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c03cf01 | this.Load | DMF0070_PRRequestAuto.cs:955 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-4adae844 | this.Load | DMF0070_PRRequestAuto.cs:956 |  | DATA_OP | request.Parameters["CODE"] | "PR_SPLANT" | 행/컬럼 값 대입 |  |  |  |
| AC-692367f4 | this.Load | DMF0070_PRRequestAuto.cs:957 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9137dc5b | this.Load | DMF0070_PRRequestAuto.cs:958 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fbf1e061 | this.Load | DMF0070_PRRequestAuto.cs:959 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-827e606b | this.Load | DMF0070_PRRequestAuto.cs:960 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c8dedcab | this.Load | DMF0070_PRRequestAuto.cs:961 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e72e59a7 | this.Load | DMF0070_PRRequestAuto.cs:962 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-635c7841 | this.Load | DMF0070_PRRequestAuto.cs:964 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0070_PRRequestAuto.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91aadd11 | this.Load | DMF0070_PRRequestAuto.cs:210 |  | FLAG | dtSprDivision | Data.Common(Data.Type.Division, false) ⇒ biz:CommonData.CommonDataList [code=Division] | 화면 필드/플래그 변경 |  |  |  |
| AC-b6ee4e33 | this.Load | DMF0070_PRRequestAuto.cs:210 |  | COMBO_DATA | Data.Common | (Data.Type.Division, false) ⇒ biz:CommonData.CommonDataList [code=Division] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-05a85804 | this.Load | DMF0070_PRRequestAuto.cs:213 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d09d4c50 | this.Load | DMF0070_PRRequestAuto.cs:221 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6b5300d0 | this.Load | DMF0070_PRRequestAuto.cs:225 |  | UI_PROP | drpPeriod.Text1 | DateTime.Now.AddMonths(-1).ToString("yyyy-MM-dd") | 속성 Text1 설정 |  |  |  |
| AC-11189eb4 | this.Load | DMF0070_PRRequestAuto.cs:226 |  | UI_PROP | drpPeriod.Text2 | DateTime.Now.ToString("yyyy-MM-dd") | 속성 Text2 설정 |  |  |  |

## DMF0070_PRRequestAuto.InitSpread

진입점: this.Load / cboDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8776073c | this.Load 외 3 | DMF0070_PRRequestAuto.cs:260 | if (spdInfo == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-984920c8 | this.Load 외 3 | DMF0070_PRRequestAuto.cs:264 |  | FLAG | dtTitle | GetSpdTitle(spdInfo.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-6cfbf5e0 | this.Load 외 3 | DMF0070_PRRequestAuto.cs:265 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (spdInfo, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0070_PRRequestAuto.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11db03f1 | SaveButton | DMF0070_PRRequestAuto.cs:395 | if (UserInfoContext.Current["NowGroupID"] == "DM Viewer") | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-297628cf | SaveButton | DMF0070_PRRequestAuto.cs:396 | if (UserInfoContext.Current["NowGroupID"] == "DM Viewer") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0070_PRRequestAuto.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb0d0a6d | SaveButton | DMF0070_PRRequestAuto.cs:672 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (intUnValidCnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00416") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-91bfee40 | SaveButton | DMF0070_PRRequestAuto.cs:673 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (intUnValidCnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8420d4b | SaveButton | DMF0070_PRRequestAuto.cs:684 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0070_SAVE_REQUEST_AUTO_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-1a7ceaa4 | SaveButton | DMF0070_PRRequestAuto.cs:685 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_MAIL_INFO_DATE"] | sMAIL_INFO_DATE | 행/컬럼 값 대입 |  |  |  |
| AC-3f993efc | SaveButton | DMF0070_PRRequestAuto.cs:686 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-5e5c8217 | SaveButton | DMF0070_PRRequestAuto.cs:687 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_PROJECT_CODE"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-d51f7d9d | SaveButton | DMF0070_PRRequestAuto.cs:688 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_SCM_SITE_ID"] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-2fae9f46 | SaveButton | DMF0070_PRRequestAuto.cs:689 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_ITEM_ID"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-e0eaa0d9 | SaveButton | DMF0070_PRRequestAuto.cs:690 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_DOM_EXP"] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-acdd5395 | SaveButton | DMF0070_PRRequestAuto.cs:691 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_FCST_TYPE"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-fecf1dbd | SaveButton | DMF0070_PRRequestAuto.cs:692 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_INCOTERMS"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-cc859efc | SaveButton | DMF0070_PRRequestAuto.cs:693 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_PLANT_SITE_ID"] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-16e1ad3f | SaveButton | DMF0070_PRRequestAuto.cs:694 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_MKT_FCST_DATE"] | sMKT_FCST_DATE | 행/컬럼 값 대입 |  |  |  |
| AC-8359ea6f | SaveButton | DMF0070_PRRequestAuto.cs:695 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_AUTO_FLAG"] | sAUTO_FLAG | 행/컬럼 값 대입 |  |  |  |
| AC-c303f90b | SaveButton | DMF0070_PRRequestAuto.cs:696 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c345b817 | SaveButton | DMF0070_PRRequestAuto.cs:697 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_STORAGE_ID"] | sSTORAGE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-cee28fb1 | SaveButton | DMF0070_PRRequestAuto.cs:698 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_PR_ITEM_DETAIL"] | sPR_ITEM_DETAIL | 행/컬럼 값 대입 |  |  |  |
| AC-69b504f1 | SaveButton | DMF0070_PRRequestAuto.cs:700 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | DATA_OP | request.Parameters["P_STORAGE_PLANT_ID"] | sSTORAGE_PLANT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-09d04363 | SaveButton | DMF0070_PRRequestAuto.cs:702 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-59c5dd8e | SaveButton | DMF0070_PRRequestAuto.cs:706 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b5c746e8 | SaveButton | DMF0070_PRRequestAuto.cs:707 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9416a144 | SaveButton | DMF0070_PRRequestAuto.cs:712 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ tr… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-871fb000 | SaveButton | DMF0070_PRRequestAuto.cs:722 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMKT_FCST_DATE != "") ▸ ca… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4e490f9 | SaveButton | DMF0070_PRRequestAuto.cs:731 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sMKT_FCST_DATE != "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00017") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0070_PRRequestAuto.SetChangeControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a59efff3 | this.Load 외 1 | DMF0070_PRRequestAuto.cs:153 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b4851afb | this.Load 외 1 | DMF0070_PRRequestAuto.cs:154 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-aae13cec | this.Load 외 1 | DMF0070_PRRequestAuto.cs:160 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2943d89c | this.Load 외 1 | DMF0070_PRRequestAuto.cs:160 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-593ba176 | this.Load 외 1 | DMF0070_PRRequestAuto.cs:165 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7b5ad5a9 | this.Load 외 1 | DMF0070_PRRequestAuto.cs:167 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-55e5532f | this.Load 외 1 | DMF0070_PRRequestAuto.cs:167 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9db6d825 | this.Load 외 1 | DMF0070_PRRequestAuto.cs:172 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-180e9d2f | this.Load 외 1 | DMF0070_PRRequestAuto.cs:173 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-dd38eeac | this.Load 외 1 | DMF0070_PRRequestAuto.cs:175 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9aca1fb6 | this.Load 외 1 | DMF0070_PRRequestAuto.cs:175 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-dd0e54a6 | this.Load 외 1 | DMF0070_PRRequestAuto.cs:187 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-0133040b | this.Load 외 1 | DMF0070_PRRequestAuto.cs:188 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-9f8c1448 | this.Load 외 1 | DMF0070_PRRequestAuto.cs:189 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-1a534ecc | this.Load 외 1 | DMF0070_PRRequestAuto.cs:191 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtScmSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5478971d | this.Load 외 1 | DMF0070_PRRequestAuto.cs:191 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4af5007f | this.Load 외 1 | DMF0070_PRRequestAuto.cs:196 | switch (triggerControl) case "UserPlantSiteByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-826a0299 | this.Load 외 1 | DMF0070_PRRequestAuto.cs:198 | switch (triggerControl) case "UserPlantSiteByDivision": | FLAG | dtPlantSite | DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-05129635 | this.Load 외 1 | DMF0070_PRRequestAuto.cs:198 | switch (triggerControl) case "UserPlantSiteByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0070_PRRequestAuto.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9713b2bb | this.spdMain.CellClick | DMF0070_PRRequestAuto.cs:995 | if (!siMain.IsLock()) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.BNP_IN_DATE)).ToString() == "") ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.STORAGE_PLANT_ID), dtPlant) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a679e197 | this.spdMain.CellClick | DMF0070_PRRequestAuto.cs:1004 | if (!siMain.IsLock()) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.BNP_IN_DATE)).ToString() == "") ▸ if (e.Column == siMain… | UI_PROP | cellinfo.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-e80a7b49 | this.spdMain.CellClick | DMF0070_PRRequestAuto.cs:1011 | if (!siMain.IsLock()) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.BNP_IN_DATE)).ToString() == "") ▸ else of (e.Column == s… | FLAG | dtSLOC | GetSLOC(sSPlant) | 화면 필드/플래그 변경 |  |  |  |
| AC-b79ed3d5 | this.spdMain.CellClick | DMF0070_PRRequestAuto.cs:1012 | if (!siMain.IsLock()) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.BNP_IN_DATE)).ToString() == "") ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.STORAGE_ID), dtSLOC) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f19649f8 | this.spdMain.CellClick | DMF0070_PRRequestAuto.cs:1017 | if (!siMain.IsLock()) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.BNP_IN_DATE)).ToString() == "") ▸ else of (e.Column == s… | UI_PROP | cellinfo.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |

## DMF0070_PRRequestAuto.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50fdfd70 | dsdm.Changed | DMF0070_PRRequestAuto.cs:877 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.STOR… | FLAG | dtSLOC | GetSLOC(sSPlant) | 화면 필드/플래그 변경 |  |  |  |
| AC-ca3568f2 | dsdm.Changed | DMF0070_PRRequestAuto.cs:878 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.STOR… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.STORAGE_ID), dtSLOC) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-fe949024 | dsdm.Changed | DMF0070_PRRequestAuto.cs:891 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.STORAGE_PLANT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-fc23696e | dsdm.Changed | DMF0070_PRRequestAuto.cs:892 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.STORAGE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-9171e19c | dsdm.Changed | DMF0070_PRRequestAuto.cs:893 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PR_ITEM_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-842d8687 | dsdm.Changed | DMF0070_PRRequestAuto.cs:895 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.STORAGE_PLANT_ID), e.Row, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-88cbba09 | dsdm.Changed | DMF0070_PRRequestAuto.cs:896 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.STORAGE_ID), e.Row, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d1829ebe | dsdm.Changed | DMF0070_PRRequestAuto.cs:897 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PR_ITEM_DETAIL), e.Row, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dd7ac7b1 | dsdm.Changed | DMF0070_PRRequestAuto.cs:901 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.STORAGE_PLANT_ID), e.Row, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3992fcfe | dsdm.Changed | DMF0070_PRRequestAuto.cs:902 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.STORAGE_ID), e.Row, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-862db45b | dsdm.Changed | DMF0070_PRRequestAuto.cs:903 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PR_ITEM_DETAIL), e.Row, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |


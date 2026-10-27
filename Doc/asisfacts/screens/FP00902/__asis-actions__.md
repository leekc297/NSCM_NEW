# AS-IS 액션 대조표 — FP00902

> 원천: `Doc/asisfacts/screens/FP00902/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 540행 · 메서드 35 · 종류 DATA_OP 210 · GRID_INIT 72 · FLAG 45 · RETURN 42 · UI_MISC 25 · MESSAGE 21 · GRID_LOCK 20 · CALL_EXT 18 · UI_PROP 18 · ENDPOINT 11 · GRID_SET 8 · GRID_BIND 7 · STATE 7 · POPUP 6 · STATE_RESET 5 · LIST_REBIND 4 · THROW 4 · VALUE_CLEAR 4 · COMBO_DATA 3 · VALUE_SET 3 · VALIDATE 3 · CALL_BASE 2 · LIST_CLEAR 1 · GRID_COMBO 1 · ⚠ 의미 확인 필요 20


## FP00902_Item_Setup_Attr..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-134ab310 | .ctor | FP00902_Item_Setup_Attr.cs:141 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00902_Item_Setup_Attr.ActiveSheet_CellChanged

진입점: this.spdMain.ActiveSheet.CellChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-831575cb | this.spdMain.ActiveSheet.CellChanged | FP00902_Item_Setup_Attr.cs:1757 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-acc41fbf | this.spdMain.ActiveSheet.CellChanged | FP00902_Item_Setup_Attr.cs:1760 | if (siMain.IsLock(siMain.SheetName) == true) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00902_Item_Setup_Attr.CboInstance_SelectedIndexChanged

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-663c057e | cboInstance.SelectedIndexChanged | FP00902_Item_Setup_Attr.cs:166 |  | FLAG | dtOperationByInstance | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-68de1c38 | cboInstance.SelectedIndexChanged | FP00902_Item_Setup_Attr.cs:166 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth, pInstanceID, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-486ff161 | cboInstance.SelectedIndexChanged | FP00902_Item_Setup_Attr.cs:167 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByInstance, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00902_Item_Setup_Attr.CheckValidation

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56e25715 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP00902_Item_Setup_Attr.cs:1988 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-70ff4854 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP00902_Item_Setup_Attr.cs:1990 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00902_Item_Setup_Attr.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c603e58 | this.Load | FP00902_Item_Setup_Attr.cs:335 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4a4074bf | this.Load | FP00902_Item_Setup_Attr.cs:336 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7c6590bd | this.Load | FP00902_Item_Setup_Attr.cs:338 |  | GRID_INIT | this.AddSheet | (spdList, SpdSheet.shtList, SpdSheet.shtList, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a310148c | this.Load | FP00902_Item_Setup_Attr.cs:339 |  | FLAG | siList | GetSheetInfo(spdList.Name, spdList.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-369adbdf | this.Load | FP00902_Item_Setup_Attr.cs:342 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8e1b7900 | this.Load | FP00902_Item_Setup_Attr.cs:343 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-56b3017f | this.Load | FP00902_Item_Setup_Attr.cs:345 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00902_Item_Setup_Attr.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86c498f6 | DeleteButton | FP00902_Item_Setup_Attr.cs:622 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22d58fb3 | DeleteButton | FP00902_Item_Setup_Attr.cs:625 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5aa27840 | DeleteButton | FP00902_Item_Setup_Attr.cs:627 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5a4206be | DeleteButton | FP00902_Item_Setup_Attr.cs:629 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | siList.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP00902_Item_Setup_Attr.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca8771e7 | Dispose | FP00902_Item_Setup_Attr.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00902_Item_Setup_Attr.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8340474 | EditButton | FP00902_Item_Setup_Attr.cs:638 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea7a3bff | EditButton | FP00902_Item_Setup_Attr.cs:639 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-79156f86 | EditButton | FP00902_Item_Setup_Attr.cs:642 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d3f072af | EditButton | FP00902_Item_Setup_Attr.cs:643 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.UPDATE_ID),siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4f9d815d | EditButton | FP00902_Item_Setup_Attr.cs:648 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b718d68a | EditButton | FP00902_Item_Setup_Attr.cs:649 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-a72244c0 | EditButton | FP00902_Item_Setup_Attr.cs:653 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.INSTANCE_ID), siSub.GetColumnIndex(DefColumns.ITEM_ID), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0b6421ed | EditButton | FP00902_Item_Setup_Attr.cs:654 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.UPDATE_ID), siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fba6bd39 | EditButton | FP00902_Item_Setup_Attr.cs:660 | if (fps != null) ▸ if (fps.Name == "spdList") | FLAG | siList | GetSheetInfo(spdList.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d0a433a | EditButton | FP00902_Item_Setup_Attr.cs:661 | if (fps != null) ▸ if (fps.Name == "spdList") | GRID_LOCK | siList.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5e420b7d | EditButton | FP00902_Item_Setup_Attr.cs:663 | if (fps != null) ▸ if (fps.Name == "spdList") | GRID_LOCK | siList.LockColumn | (siList.GetColumnIndex(DefColumns.INSTANCE_ID), siList.GetColumnIndex("ATTRIBUTE_NAME"), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-edfcd919 | EditButton | FP00902_Item_Setup_Attr.cs:664 | if (fps != null) ▸ if (fps.Name == "spdList") | GRID_LOCK | siList.LockColumn | (siList.GetColumnIndex(DefColumns.UPDATE_ID), siList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00902_Item_Setup_Attr.EssentialCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2858d60b | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1909 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c10c692e | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1917 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c842f6f | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1921 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a287fca0 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1922 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a1f9bf3c | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1929 | catch ((Exception ex)) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-80ca7204 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1931 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## FP00902_Item_Setup_Attr.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-717f9f99 | ExcelButton | FP00902_Item_Setup_Attr.cs:681 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-bf1c8069 | ExcelButton | FP00902_Item_Setup_Attr.cs:682 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-288bc39a | ExcelButton | FP00902_Item_Setup_Attr.cs:684 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4d5cb69e | ExcelButton | FP00902_Item_Setup_Attr.cs:688 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-93c26e41 | ExcelButton | FP00902_Item_Setup_Attr.cs:689 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-00dc636c | ExcelButton | FP00902_Item_Setup_Attr.cs:690 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-5a2f66fb | ExcelButton | FP00902_Item_Setup_Attr.cs:693 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-7df48c5f | ExcelButton | FP00902_Item_Setup_Attr.cs:694 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-6bede065 | ExcelButton | FP00902_Item_Setup_Attr.cs:695 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-faaa10dd | ExcelButton | FP00902_Item_Setup_Attr.cs:697 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-046ab039 | ExcelButton | FP00902_Item_Setup_Attr.cs:698 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-7daa29dc | ExcelButton | FP00902_Item_Setup_Attr.cs:705 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-25f81e59 | ExcelButton | FP00902_Item_Setup_Attr.cs:709 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-5799a9ec | ExcelButton | FP00902_Item_Setup_Attr.cs:713 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00902_Item_Setup_Attr.FindAttrList

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell)] / this.spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == true)] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true)] / FindButton [if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b86eda9d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:843 | try | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-968d9623 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:849 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a4038dcb | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:853 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1f486f82 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:863 | try | FLAG | dsMain | FindAttrList("SELECT", index) | 화면 필드/플래그 변경 |  |  |  |
| AC-8ef356a0 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:865 | try | FLAG | dsList | dsMain.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-a352511c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:865 | try | DATA_OP | dsMain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c19d6284 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:872 | try ▸ else of (!dsList.Good()) | FLAG | siList | GetSheetInfo(spdList.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-190aa1b8 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:874 | try ▸ else of (!dsList.Good()) | GRID_BIND | siList.Query | (dsList,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f60ea18c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:875 | try ▸ else of (!dsList.Good()) | GRID_LOCK | siList.LockColumn | (0, siList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-665f73ae | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:882 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-deec27c2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:887 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c5b185fa | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:888 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bcf9d4ff | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1724 | try | DATA_OP | Filter["LOOKUP_TYPE_CODE"] | mainLookupType.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-d99b7ece | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1728 | try ▸ if (attrTypeIdx < 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-579114d3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1734 | try ▸ if (dr == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-92a3ef56 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1736 | try | FLAG | LastAttrTypeIdx | attrTypeIdx | 화면 필드/플래그 변경 |  |  |  |
| AC-5da56de4 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1737 | try | DATA_OP | Filter[DefColumns.INSTANCE_ID] | dr[DefColumns.INSTANCE_ID].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-9284bd94 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1738 | try | DATA_OP | Filter[DefColumns.OPERATION_ID] | dr[DefColumns.OPERATION_ID].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-e85bed5c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1739 | try | DATA_OP | Filter["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-9527624d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1740 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00902_ItemSetupAttr", "get_attr_list", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] \| FP\Master\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ff422120 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1742 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-40cdfa9c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1746 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00902_Item_Setup_Attr.FindAttrListCondtion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dc4ba9b | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:969 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6425381f | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:973 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6c45ac01 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:983 | try | FLAG | dsMain | dsSub.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-eb46a2f7 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:983 | try | DATA_OP | dsSub.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e0053a65 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:985 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8446a6d5 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:998 | try ▸ if (usrTextBox_Att.Text.Length > 0) | DATA_OP | dsMain.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c7a63d74 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:999 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ lambda | DATA_OP | s[columIdx].ToString().Contains | (con_param) | 데이터 객체 조작/조회 |  |  |  |
| AC-492221e0 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1001 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).CopyToDat… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e1e7f31d | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1001 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8b2e7b01 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1002 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | s[columIdx].ToString().Contains | (con_param) | 데이터 객체 조작/조회 |  |  |  |
| AC-8441708f | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1004 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | STATE_RESET | dsMain.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-76e1195e | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1006 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables.Add | (dtSeg) | 데이터 객체 조작/조회 |  |  |  |
| AC-6545046c | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1010 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | DATA_OP | dsMain.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4093508c | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1011 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | STATE_RESET | dsMain.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-cc1cea15 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1012 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | DATA_OP | dsMain.Tables.Add | (dtTMP) | 데이터 객체 조작/조회 |  |  |  |
| AC-24636f9a | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1016 | try | GRID_BIND | siSub.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fb235450 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1017 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c9eb17a3 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1022 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51468e98 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1027 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5c2fc441 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1028 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00902_Item_Setup_Attr.FindAttrType

진입점: FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4ec5388 | FindButton [try ▸ lambda] 외 1 | FP00902_Item_Setup_Attr.cs:1499 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (cboValid.Text.ToUpper() != "ALL") { Filter["ACTIVE_FL… | ⚠ 의미 확인 필요 |  |  |  |
| AC-24728b86 | FindButton [try ▸ lambda] 외 1 | FP00902_Item_Setup_Attr.cs:1504 | try ▸ lambda ▸ if (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["ACTIVE_FLAG"] | cboValid.Text.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-a0a6def2 | FindButton [try ▸ lambda] 외 1 | FP00902_Item_Setup_Attr.cs:1508 | try ▸ lambda ▸ else of (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["ACTIVE_FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5e6f5c05 | FindButton [try ▸ lambda] 외 1 | FP00902_Item_Setup_Attr.cs:1532 | try | DATA_OP | Filter["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-05d3a9d5 | FindButton [try ▸ lambda] 외 1 | FP00902_Item_Setup_Attr.cs:1535 | try | DATA_OP | Filter["INSTANCE_ID"] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-347d784c | FindButton [try ▸ lambda] 외 1 | FP00902_Item_Setup_Attr.cs:1536 | try | DATA_OP | Filter["OPERATION_ID"] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-ac761386 | FindButton [try ▸ lambda] 외 1 | FP00902_Item_Setup_Attr.cs:1537 | try | DATA_OP | Filter["ITEM_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-440648d5 | FindButton [try ▸ lambda] 외 1 | FP00902_Item_Setup_Attr.cs:1538 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00902_ItemSetupAttr", "get_item_list", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list] \| FP\Master\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-eb3edbc5 | FindButton [try ▸ lambda] 외 1 | FP00902_Item_Setup_Attr.cs:1539 | try | CALL_EXT | Filter.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b4695bf | FindButton [try ▸ lambda] 외 1 | FP00902_Item_Setup_Attr.cs:1541 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-0cefca9d | FindButton [try ▸ lambda] 외 1 | FP00902_Item_Setup_Attr.cs:1545 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00902_Item_Setup_Attr.FindAttrValue

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell)] / this.spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == true)] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true)] / FindButton [if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76e72328 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:766 | try | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-5b6c9f4e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:772 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4b13e5ff | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:776 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4afbe057 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:786 | try | FLAG | dsMain | FindAttrValue("SELECT",index) | 화면 필드/플래그 변경 |  |  |  |
| AC-11c74dc0 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:788 | try | FLAG | dsSub | dsMain.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-65b603f3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:788 | try | DATA_OP | dsMain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-594488cc | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:790 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-91ac26e3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:794 | try | GRID_BIND | siSub.Query | (dsSub) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9f61a551 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:795 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ede995a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:799 | try | CALL_EXT | col_head.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6cee40b2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:800 | try | CALL_EXT | col_head_idx.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-029fd218 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:804 | try | LIST_CLEAR | SubComboBox_param.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-6b6e5360 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:812 | try ▸ for (i < siSub.ActiveSheet.ColumnCount) ▸ if (siSub.ActiveSheet.Columns[i].Visible) ▸ if (siSub.ActiveSheet.Columns[i].Label != "Last … | DATA_OP | col_head.Add | (siSub.ActiveSheet.Columns[i].Label) | 데이터 객체 조작/조회 |  |  |  |
| AC-b182a459 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:813 | try ▸ for (i < siSub.ActiveSheet.ColumnCount) ▸ if (siSub.ActiveSheet.Columns[i].Visible) ▸ if (siSub.ActiveSheet.Columns[i].Label != "Last … | DATA_OP | col_head_idx.Add | (SP_DataSource.Tables[0].Columns[siSub.ActiveSheet.Columns[i].Tag.ToString()].Ordinal) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f8f36f7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:821 | try ▸ for (i < col_head.Count) | DATA_OP | SubComboBox_param.Items.Add | (col_head[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b87c5868 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:823 | try | VALUE_SET | SubComboBox_param.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-23743a03 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:829 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ad22859 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:834 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8acef885 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:835 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-895bbee9 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1695 | if (index < 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-632a8416 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1701 | if (dr == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-d2b80933 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1704 | try | DATA_OP | Filter["LOOKUP_TYPE_CODE"] | mainLookupType.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-723226b6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1707 | try | DATA_OP | Filter[DefColumns.INSTANCE_ID] | dr[DefColumns.INSTANCE_ID].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-bf266b83 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1708 | try | DATA_OP | Filter[DefColumns.OPERATION_ID] | dr[DefColumns.OPERATION_ID].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-ff56d98e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1709 | try | DATA_OP | Filter["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-4d0e190e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1710 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00902_ItemSetupAttr", "get_item_values", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_values] \| FP\Master\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2cbcd3b6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1712 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-bfb8f90e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00902_Item_Setup_Attr.cs:1716 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00902_Item_Setup_Attr.FindAttrValueCondition

진입점: this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] / this.simpleButton1.Click / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (res.Good()) ▸ if (cnt > 0) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7d666c0 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:899 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b653adc8 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:903 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9be1e70c | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:913 | try | FLAG | dsMain | dsSub.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-07ec19eb | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:913 | try | DATA_OP | dsSub.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6fa1b9b2 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:915 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2999d370 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:927 | try ▸ if (usrTextBox_Att.Text.Length > 0) | DATA_OP | dsMain.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-064a4bc3 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:928 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ lambda | DATA_OP | s[columIdx].ToString().Contains | (con_param) | 데이터 객체 조작/조회 |  |  |  |
| AC-98965888 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:930 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).CopyToDat… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-22793360 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:930 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1b4527ed | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:931 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | s[columIdx].ToString().Contains | (con_param) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2b77fdd | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:933 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | STATE_RESET | dsMain.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8aadf4a5 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:935 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables.Add | (dtSeg) | 데이터 객체 조작/조회 |  |  |  |
| AC-05b33d8b | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:939 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | DATA_OP | dsMain.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9001dc9d | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:940 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | STATE_RESET | dsMain.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-0a6d00ee | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:941 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | DATA_OP | dsMain.Tables.Add | (dtTMP) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b03ff12 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:945 | try | GRID_BIND | siSub.Query | (dsMain,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cfbdcfbd | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:946 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-deafa72a | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:951 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-20eb2b15 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:956 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a26a59ad | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00902_Item_Setup_Attr.cs:957 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00902_Item_Setup_Attr.FindDataAttrList

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (res.Good()) ▸ if (cnt > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40c6045a | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1092 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-290cab43 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1096 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c10b2a67 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1106 | try | FLAG | dsMain | FindAttrList("SELECT", LastAttrTypeIdx) | 화면 필드/플래그 변경 |  |  |  |
| AC-a507cad5 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1108 | try | FLAG | dsList | dsMain.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-10f7a7ad | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1108 | try | DATA_OP | dsMain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2c35b35d | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1110 | try | FLAG | siList | GetSheetInfo(spdList.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-228cbfaf | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1112 | try | GRID_BIND | siList.Query | (dsList, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-70fb0839 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1113 | try | GRID_LOCK | siList.LockColumn | (0, siList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a51fca54 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1114 | try | CALL_BASE | SetFilter | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9661d89e | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1120 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-acd1c89f | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1125 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-cd159901 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1126 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00902_Item_Setup_Attr.FindDataAttrValue

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (res.Good()) ▸ if (cnt > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f1c71e7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1041 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d5eee34f | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1045 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6aa0c911 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1055 | try | FLAG | dsMain | FindAttrValue("SELECT", LastAttrTypeIdx) | 화면 필드/플래그 변경 |  |  |  |
| AC-70461590 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1057 | try | FLAG | dsSub | dsMain.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-144ffada | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1057 | try | DATA_OP | dsMain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2a89680c | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1059 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e4f069f | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1063 | try | GRID_BIND | siSub.Query | (dsMain,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4a7e7d31 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1064 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bb90ca78 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1070 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad765a47 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1075 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4381a999 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1076 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00902_Item_Setup_Attr.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-038d453b | this.Load | FP00902_Item_Setup_Attr.cs:282 |  | DATA_OP | dtSystem.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-20bd8aa5 | this.Load | FP00902_Item_Setup_Attr.cs:283 |  | DATA_OP | dtSystem.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f6aabe4 | this.Load | FP00902_Item_Setup_Attr.cs:284 |  | DATA_OP | dtSystem.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-80edae06 | this.Load | FP00902_Item_Setup_Attr.cs:285 |  | DATA_OP | dr["CODE"] | "FP" | 행/컬럼 값 대입 |  |  |  |
| AC-cdccdec3 | this.Load | FP00902_Item_Setup_Attr.cs:286 |  | DATA_OP | dr["NAME"] | "FP" | 행/컬럼 값 대입 |  |  |  |
| AC-2f452a10 | this.Load | FP00902_Item_Setup_Attr.cs:287 |  | DATA_OP | dtSystem.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-d86e19f2 | this.Load | FP00902_Item_Setup_Attr.cs:289 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00902_Item_Setup_Attr.GetAttrValueHeaderInfo

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell)] / this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter) ▸ try ▸ if (!dtColumInfo.Good())] / this.simpleButton1.Click [try ▸ if (!dtColumInfo.Good())] / this.spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == true)] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true)] / FindButton [if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d6afda9 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1833 | if (siMain.SpreadObject.Name == "spdMain") | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-17c356a6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1834 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dtColumInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-45709053 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1840 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE1] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-836ebed8 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1841 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE2] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dc4efc96 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1842 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE3] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4b292858 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1843 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE4] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2fb8c2a1 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1844 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE5] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-08901402 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1845 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE6] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0049a595 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1846 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE7] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eb1f0cee | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1847 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE8] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e385f08f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1848 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE9] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7017faa4 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1849 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE10] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-76eb2063 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1850 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE11] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4512d44b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1851 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE12] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0a8f7593 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1852 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE13] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a857699c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1853 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE14] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-24b37ab8 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1854 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE15] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cca36fca | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1856 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dtColumInfo.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |

## FP00902_Item_Setup_Attr.GoSave

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4adc5cd | SaveButton | FP00902_Item_Setup_Attr.cs:1137 | if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-4535d413 | SaveButton | FP00902_Item_Setup_Attr.cs:1137 | if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca05f27a | SaveButton | FP00902_Item_Setup_Attr.cs:1142 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) ▸ if (!CheckValidation(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b0ea270 | SaveButton | FP00902_Item_Setup_Attr.cs:1145 | if (fps.Name == "spdMain") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-fa01b531 | SaveButton | FP00902_Item_Setup_Attr.cs:1145 | if (fps.Name == "spdMain") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ceafe82d | SaveButton | FP00902_Item_Setup_Attr.cs:1152 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b8f00660 | SaveButton | FP00902_Item_Setup_Attr.cs:1153 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d36ef661 | SaveButton | FP00902_Item_Setup_Attr.cs:1154 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) | DATA_OP | saveDS.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-97b7e8d4 | SaveButton | FP00902_Item_Setup_Attr.cs:1167 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | deleteDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d1e6e961 | SaveButton | FP00902_Item_Setup_Attr.cs:1168 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | deleteDS.Tables[0].Rows.Add | (cRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-87b30d0d | SaveButton | FP00902_Item_Setup_Attr.cs:1171 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) ▸ if (siMain.GetValue(i, siMain.GetColumn… | DATA_OP | cRow["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-e8f3e36d | SaveButton | FP00902_Item_Setup_Attr.cs:1175 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) ▸ else of (siMain.GetValue(i, siMain.GetC… | DATA_OP | cRow["ACTIVE_FLAG"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a6e60472 | SaveButton | FP00902_Item_Setup_Attr.cs:1177 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow[DefColumns.INSTANCE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4e9d7d76 | SaveButton | FP00902_Item_Setup_Attr.cs:1178 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow[DefColumns.OPERATION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0456bb22 | SaveButton | FP00902_Item_Setup_Attr.cs:1182 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-651c7c9a | SaveButton | FP00902_Item_Setup_Attr.cs:1183 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE2"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3999e586 | SaveButton | FP00902_Item_Setup_Attr.cs:1184 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE3"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a2e3af5b | SaveButton | FP00902_Item_Setup_Attr.cs:1185 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE4"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1a10f3b6 | SaveButton | FP00902_Item_Setup_Attr.cs:1186 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE5"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3d18b557 | SaveButton | FP00902_Item_Setup_Attr.cs:1187 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE6"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dfe6723e | SaveButton | FP00902_Item_Setup_Attr.cs:1188 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE7"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-59ad39c5 | SaveButton | FP00902_Item_Setup_Attr.cs:1189 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE8"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d2958c45 | SaveButton | FP00902_Item_Setup_Attr.cs:1190 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE9"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3acdf617 | SaveButton | FP00902_Item_Setup_Attr.cs:1191 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE10"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3b689c9a | SaveButton | FP00902_Item_Setup_Attr.cs:1192 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE11"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-411b627d | SaveButton | FP00902_Item_Setup_Attr.cs:1193 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE12"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3bced220 | SaveButton | FP00902_Item_Setup_Attr.cs:1194 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE13"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-467b3ce3 | SaveButton | FP00902_Item_Setup_Attr.cs:1195 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE14"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5c3f8f38 | SaveButton | FP00902_Item_Setup_Attr.cs:1196 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE15"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ba95cbac | SaveButton | FP00902_Item_Setup_Attr.cs:1200 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-98146b84 | SaveButton | FP00902_Item_Setup_Attr.cs:1201 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | saveDS.Tables[0].Rows.Add | (cRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-617dd711 | SaveButton | FP00902_Item_Setup_Attr.cs:1204 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) ▸ if (siMain.GetValue(i, siMain.GetC… | DATA_OP | cRow["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-e8045170 | SaveButton | FP00902_Item_Setup_Attr.cs:1208 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) ▸ else of (siMain.GetValue(i, siMain… | DATA_OP | cRow["ACTIVE_FLAG"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-16852b1f | SaveButton | FP00902_Item_Setup_Attr.cs:1210 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow[DefColumns.INSTANCE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-05ebe680 | SaveButton | FP00902_Item_Setup_Attr.cs:1211 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow[DefColumns.OPERATION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-343809d2 | SaveButton | FP00902_Item_Setup_Attr.cs:1215 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-440c994b | SaveButton | FP00902_Item_Setup_Attr.cs:1216 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE2"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-16b7759d | SaveButton | FP00902_Item_Setup_Attr.cs:1217 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE3"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-de65ab81 | SaveButton | FP00902_Item_Setup_Attr.cs:1218 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE4"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-63906ddf | SaveButton | FP00902_Item_Setup_Attr.cs:1219 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE5"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-da7d1a30 | SaveButton | FP00902_Item_Setup_Attr.cs:1220 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE6"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9239d81f | SaveButton | FP00902_Item_Setup_Attr.cs:1221 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE7"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-43cbd8f0 | SaveButton | FP00902_Item_Setup_Attr.cs:1222 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE8"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc52d043 | SaveButton | FP00902_Item_Setup_Attr.cs:1223 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE9"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-943ba801 | SaveButton | FP00902_Item_Setup_Attr.cs:1224 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE10"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7deb99de | SaveButton | FP00902_Item_Setup_Attr.cs:1225 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE11"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-21fa8cd9 | SaveButton | FP00902_Item_Setup_Attr.cs:1226 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE12"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e64faaeb | SaveButton | FP00902_Item_Setup_Attr.cs:1227 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE13"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6a83b45f | SaveButton | FP00902_Item_Setup_Attr.cs:1228 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE14"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f2e5ec08 | SaveButton | FP00902_Item_Setup_Attr.cs:1229 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE15"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7f1761be | SaveButton | FP00902_Item_Setup_Attr.cs:1250 | if (fps.Name == "spdMain") ▸ if (res.Good()) | CALL_EXT | res.Tables[0].Rows[0][1].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e2bc1f2 | SaveButton | FP00902_Item_Setup_Attr.cs:1251 | if (fps.Name == "spdMain") ▸ if (res.Good()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { cnt.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d25ee3e1 | SaveButton | FP00902_Item_Setup_Attr.cs:1262 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-48a7e2bd | SaveButton | FP00902_Item_Setup_Attr.cs:1262 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d5def5c | SaveButton | FP00902_Item_Setup_Attr.cs:1264 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!CheckValidation(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa0f8d65 | SaveButton | FP00902_Item_Setup_Attr.cs:1266 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-273ee2f8 | SaveButton | FP00902_Item_Setup_Attr.cs:1266 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d0267b33 | SaveButton | FP00902_Item_Setup_Attr.cs:1269 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | (siSub.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-471cb621 | SaveButton | FP00902_Item_Setup_Attr.cs:1271 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (saveDS == null) | THROW | throw new Exception("Cannot Find Data Source"); |  | 예외 발생 |  |  |  |
| AC-828e1a02 | SaveButton | FP00902_Item_Setup_Attr.cs:1274 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | saveDS.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-43aa744b | SaveButton | FP00902_Item_Setup_Attr.cs:1292 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-45ed313f | SaveButton | FP00902_Item_Setup_Attr.cs:1293 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cTable.Rows.Add | (cRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a128ca6 | SaveButton | FP00902_Item_Setup_Attr.cs:1301 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.INSTANCE_ID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-95f97b39 | SaveButton | FP00902_Item_Setup_Attr.cs:1302 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.OPERATION_ID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3b09a4e7 | SaveButton | FP00902_Item_Setup_Attr.cs:1303 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ITEM_ID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b0942302 | SaveButton | FP00902_Item_Setup_Attr.cs:1305 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE1] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5cfaee8 | SaveButton | FP00902_Item_Setup_Attr.cs:1306 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE2] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d68b48fb | SaveButton | FP00902_Item_Setup_Attr.cs:1307 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE3] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d4bfc67 | SaveButton | FP00902_Item_Setup_Attr.cs:1308 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE4] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eedf66ed | SaveButton | FP00902_Item_Setup_Attr.cs:1309 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE5] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d6c109f1 | SaveButton | FP00902_Item_Setup_Attr.cs:1310 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE6] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-88e00288 | SaveButton | FP00902_Item_Setup_Attr.cs:1311 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE7] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0cfd76f2 | SaveButton | FP00902_Item_Setup_Attr.cs:1312 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE8] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-22cbf24f | SaveButton | FP00902_Item_Setup_Attr.cs:1313 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE9] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f6b8c895 | SaveButton | FP00902_Item_Setup_Attr.cs:1314 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE10] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-78edbbfc | SaveButton | FP00902_Item_Setup_Attr.cs:1315 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE11] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3a0f463c | SaveButton | FP00902_Item_Setup_Attr.cs:1316 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE12] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f0038d5e | SaveButton | FP00902_Item_Setup_Attr.cs:1317 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE13] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5f2fbae5 | SaveButton | FP00902_Item_Setup_Attr.cs:1318 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE14] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4bb192b5 | SaveButton | FP00902_Item_Setup_Attr.cs:1319 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE15] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-419a0ef5 | SaveButton | FP00902_Item_Setup_Attr.cs:1323 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ACTIVE_FLAG] | active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-5bf1f4f3 | SaveButton | FP00902_Item_Setup_Attr.cs:1330 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (res.Good()) | CALL_EXT | res.Tables[0].Rows[0][1].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ef2e955 | SaveButton | FP00902_Item_Setup_Attr.cs:1334 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (res.Good()) ▸ if (cnt > 0) | MESSAGE | MessageBox.Show | ("Save success") | 메시지 표시 |  |  |  |
| AC-a1c6f2b3 | SaveButton | FP00902_Item_Setup_Attr.cs:1339 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (res.Good()) ▸ else of (cnt > 0) | MESSAGE | MessageBox.Show | ("Nothing saveds") | 메시지 표시 |  |  |  |
| AC-b575c942 | SaveButton | FP00902_Item_Setup_Attr.cs:1344 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ else of (res.Good()) | MESSAGE | MessageBox.Show | ("Fail to save") | 메시지 표시 |  |  |  |
| AC-d8236883 | SaveButton | FP00902_Item_Setup_Attr.cs:1350 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | VALIDATE | DataUtil.checkRequiredOfSpread | (siList) | 프레임워크 검증 |  |  |  |
| AC-a7e0f3ec | SaveButton | FP00902_Item_Setup_Attr.cs:1350 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (!DataUtil.checkRequiredOfSpread(siList)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d51f4c60 | SaveButton | FP00902_Item_Setup_Attr.cs:1352 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (!CheckValidation(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-744847da | SaveButton | FP00902_Item_Setup_Attr.cs:1354 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c22131e9 | SaveButton | FP00902_Item_Setup_Attr.cs:1354 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d1af6a28 | SaveButton | FP00902_Item_Setup_Attr.cs:1356 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | (siList.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-efc9150c | SaveButton | FP00902_Item_Setup_Attr.cs:1358 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (saveDS == null) | THROW | throw new Exception("Cannot Find Data Source"); |  | 예외 발생 |  |  |  |
| AC-beb7b7ee | SaveButton | FP00902_Item_Setup_Attr.cs:1359 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | saveDS.Tables[0].Columns.SafeAdd | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-526c4230 | SaveButton | FP00902_Item_Setup_Attr.cs:1360 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | saveDS.Tables[0].Columns.SafeAdd | (DefColumns.OLD_ATTRIBUTE_LIST, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-22045e1c | SaveButton | FP00902_Item_Setup_Attr.cs:1361 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | saveDS.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-43389417 | SaveButton | FP00902_Item_Setup_Attr.cs:1379 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a6d8bea4 | SaveButton | FP00902_Item_Setup_Attr.cs:1380 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cTable.Rows.Add | (cRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-be5eb11d | SaveButton | FP00902_Item_Setup_Attr.cs:1388 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.INSTANCE_ID] | siList.GetValue(i, siList.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d2e0dac5 | SaveButton | FP00902_Item_Setup_Attr.cs:1389 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.OPERATION_ID] | siList.GetValue(i, siList.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5e91b560 | SaveButton | FP00902_Item_Setup_Attr.cs:1390 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE_TYPE] | siList.GetValue(i, siList.GetColumnIndex(DefColumns.ATTRIBUTE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a08ca642 | SaveButton | FP00902_Item_Setup_Attr.cs:1391 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE_LIST] | siList.GetValue(i, siList.GetColumnIndex(DefColumns.ATTRIBUTE_LIST)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-67275140 | SaveButton | FP00902_Item_Setup_Attr.cs:1392 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.OLD_ATTRIBUTE_LIST] | old_attr_list | 행/컬럼 값 대입 |  |  |  |
| AC-ee8788ee | SaveButton | FP00902_Item_Setup_Attr.cs:1393 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.DESCRIPTION] | siList.GetValue(i, siList.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-35767a3d | SaveButton | FP00902_Item_Setup_Attr.cs:1394 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ACTIVE_FLAG] | active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c6ea43a1 | SaveButton | FP00902_Item_Setup_Attr.cs:1401 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (res.Good()) | CALL_EXT | res.Tables[0].Rows[0][1].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ed0cab9 | SaveButton | FP00902_Item_Setup_Attr.cs:1405 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (res.Good()) ▸ if (cnt > 0) | MESSAGE | MessageBox.Show | ("Save success") | 메시지 표시 |  |  |  |
| AC-e2a0936a | SaveButton | FP00902_Item_Setup_Attr.cs:1410 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (res.Good()) ▸ else of (cnt > 0) | MESSAGE | MessageBox.Show | ("Nothing saveds") | 메시지 표시 |  |  |  |
| AC-e9236142 | SaveButton | FP00902_Item_Setup_Attr.cs:1415 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ else of (res.Good()) | MESSAGE | MessageBox.Show | ("Fail to save") | 메시지 표시 |  |  |  |

## FP00902_Item_Setup_Attr.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba26f26d | this.Load | FP00902_Item_Setup_Attr.cs:312 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-11652dc3 | this.Load | FP00902_Item_Setup_Attr.cs:313 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c3145da3 | this.Load | FP00902_Item_Setup_Attr.cs:315 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.INSTANCE, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=INSTANCE] | 화면 필드/플래그 변경 |  |  |  |
| AC-66f13d92 | this.Load | FP00902_Item_Setup_Attr.cs:315 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.INSTANCE, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7cac6215 | this.Load | FP00902_Item_Setup_Attr.cs:316 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c45590d2 | this.Load | FP00902_Item_Setup_Attr.cs:319 |  | FLAG | dtOperationByInstance | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-e7285fee | this.Load | FP00902_Item_Setup_Attr.cs:319 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth, pInstanceID, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c0905560 | this.Load | FP00902_Item_Setup_Attr.cs:320 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByInstance, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-06a1b072 | this.Load | FP00902_Item_Setup_Attr.cs:322 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-76b90f0b | this.Load | FP00902_Item_Setup_Attr.cs:324 |  | VALUE_SET | cboValid.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-874f82dd | this.Load | FP00902_Item_Setup_Attr.cs:326 |  | FLAG | dtColumInfo | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-64e8969f | this.Load | FP00902_Item_Setup_Attr.cs:329 | foreach (string str in sColumnList) | DATA_OP | dtColumInfo.Columns.SafeAdd | (str, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## FP00902_Item_Setup_Attr.InitSpread

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ try] / this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter) ▸ try] / this.simpleButton1.Click [try] / this.Load / this.spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / FindButton / SaveButton [if (fps.Name == "spdMain")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99b9346e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:356 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-0fbe1c6a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:358 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6387381b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:360 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Instance*","INSTANCE_NAME", FPMerge.None, 210, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e01aa34 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:361 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Operation*", DefColumns.OPERATION_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2829bea3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:362 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ad8fe1af | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:363 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b63c8167 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:364 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-84726f1f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:365 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-286a1bfc | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:366 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-01f3b857 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:367 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e531ba45 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:368 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-06fb8c4b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:369 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4fd1f2b7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:370 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1cd0e411 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:371 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-18213676 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:372 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-70323654 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:373 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a22d14d0 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:374 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-201bf888 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:375 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b685f28a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:376 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-103b728c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:378 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b421c7fb | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:380 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("UPDATE_ID ID", DefColumns.UPDATE_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-374a846e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:381 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("UPDATE_TIME", DefColumns.UPDATE_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d5f3a8e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:382 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("INSERT_ID", DefColumns.INSERT_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-690d7238 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:383 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("INSERT_TIME", DefColumns.INSERT_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dcdd5e3e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:385 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fd25ae98 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:387 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b56642fd | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:392 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b57cf05a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:394 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f6ec0cd8 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:395 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Instance*", "INSTANCE_NAME", FPMerge.None, 210, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d6f0a4ba | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:396 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Operation*", DefColumns.OPERATION_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-899baece | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:397 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Material*", DefColumns.ITEM_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-215d9fa3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:398 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8e9da092 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:399 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d1217bc0 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:400 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5af06f30 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:401 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f0afe4d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:402 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-af8c7d42 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:403 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a3312a3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:404 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d05a3e3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:405 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-78b2c509 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:406 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-445a8856 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:407 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f35c07df | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:408 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aba8a878 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:409 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-faccc3f7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:410 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9651b846 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:411 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d6bd1782 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:412 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fec394d2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:414 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e41c5b27 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:416 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("UPDATE ID", DefColumns.UPDATE_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c0e11b4 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:417 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("UPDATE TIME", DefColumns.UPDATE_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ffd35c32 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:418 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("INSERT ID", DefColumns.INSERT_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f1c40f6e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:419 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("INSERT TIME", DefColumns.INSERT_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-99d96939 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:421 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.Freeze | (0, siSub.GetColumnIndex(DefColumns.ITEM_ID)+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b8183fab | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:423 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-22246598 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:428 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-18a3fbb6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:430 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4cc686c2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:431 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("Instance*", "INSTANCE_NAME", FPMerge.None, 210, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7845a56c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:432 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("Operation*", DefColumns.OPERATION_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa631325 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:433 | if (spreadInfo.SheetName == SpdSheet.shtList) | DATA_OP | dtYesOrNo.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7024855e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:436 | if (spreadInfo.SheetName == SpdSheet.shtList) ▸ for (i < 16) | DATA_OP | dtAttributesNames.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2ad954a8 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:437 | if (spreadInfo.SheetName == SpdSheet.shtList) ▸ for (i < 16) | DATA_OP | dtAttributesNames.Rows.Add | (eachAttr) | 데이터 객체 조작/조회 |  |  |  |
| AC-376a95b3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:438 | if (spreadInfo.SheetName == SpdSheet.shtList) ▸ for (i < 16) | DATA_OP | eachAttr["CODE"] | eachAttr["NAME"] = string.Format("ATTRIBUTE{0}",i) | 행/컬럼 값 대입 |  |  |  |
| AC-a50f4a95 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:438 | if (spreadInfo.SheetName == SpdSheet.shtList) ▸ for (i < 16) | DATA_OP | eachAttr["NAME"] | string.Format("ATTRIBUTE{0}",i) | 행/컬럼 값 대입 |  |  |  |
| AC-4c5b8a80 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:440 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddComboColumn | ("Attribute Type", DefColumns.ATTRIBUTE_TYPE, FPMerge.None, 100, true, dtAttributesNames, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-505e7d23 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:441 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("Name", "ATTRIBUTE_NAME", FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-97fef45d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:442 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute Option", DefColumns.ATTRIBUTE_LIST, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d2019ec5 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:443 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("Description", DefColumns.DESCRIPTION, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61bb88f5 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:445 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e2e8c9df | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:447 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("UPDATE ID", DefColumns.UPDATE_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61c1ff5f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:448 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("UPDATE TIME", DefColumns.UPDATE_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34280551 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:449 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("INSERT ID", DefColumns.INSERT_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cc74f407 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:450 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("INSERT TIME", DefColumns.INSERT_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6676198 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:452 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.Freeze | (0, siList.GetColumnIndex(DefColumns.OPERATION_ID)+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-38d2570e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00902_Item_Setup_Attr.cs:454 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00902_Item_Setup_Attr.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83c9fc7c | InsertButton | FP00902_Item_Setup_Attr.cs:1425 | if (fps.Name == "spdMain") | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e3695f25 | InsertButton | FP00902_Item_Setup_Attr.cs:1428 | if (fps.Name == "spdMain") | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0b59165 | InsertButton | FP00902_Item_Setup_Attr.cs:1430 | if (fps.Name == "spdMain") | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-a3bfccff | InsertButton | FP00902_Item_Setup_Attr.cs:1436 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-da5ffcda | InsertButton | FP00902_Item_Setup_Attr.cs:1451 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx <= siMain.GetMaxRowIndex()) | DATA_OP | defaultData.Add | (DefColumns.INSTANCE_ID, instance_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-7909fae6 | InsertButton | FP00902_Item_Setup_Attr.cs:1452 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx <= siMain.GetMaxRowIndex()) | DATA_OP | defaultData.Add | (DefColumns.OPERATION_ID, operation_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-91a9d641 | InsertButton | FP00902_Item_Setup_Attr.cs:1455 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-50cec9fc | InsertButton | FP00902_Item_Setup_Attr.cs:1457 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.INSTANCE_ID), siSub.GetColumnIndex(DefColumns.OP… | 그리드 편집 잠금/해제 |  |  |  |
| AC-23427406 | InsertButton | FP00902_Item_Setup_Attr.cs:1458 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.UPDATE_ID), siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3880a056 | InsertButton | FP00902_Item_Setup_Attr.cs:1462 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | siList.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b3264b1c | InsertButton | FP00902_Item_Setup_Attr.cs:1477 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx … | DATA_OP | defaultData.Add | (DefColumns.INSTANCE_ID, instance_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-b77e147b | InsertButton | FP00902_Item_Setup_Attr.cs:1478 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx … | DATA_OP | defaultData.Add | (DefColumns.OPERATION_ID, operation_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0ec0945 | InsertButton | FP00902_Item_Setup_Attr.cs:1480 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-1124c8c0 | InsertButton | FP00902_Item_Setup_Attr.cs:1481 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | defaultData.Add | (DefColumns.ATTRIBUTE_TYPE, "ATTRIBUTE1") | 데이터 객체 조작/조회 |  |  |  |
| AC-18472a00 | InsertButton | FP00902_Item_Setup_Attr.cs:1483 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | GRID_SET | siList.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## FP00902_Item_Setup_Attr.RefreshSpreadSheet

진입점: FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-594de222 | FindButton [try] 외 1 | FP00902_Item_Setup_Attr.cs:599 | if (mode == "MAIN") | CALL_EXT | siMain.EditQuery | (dsMain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7973c38b | FindButton [try] 외 1 | FP00902_Item_Setup_Attr.cs:600 | if (mode == "MAIN") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-59c63e35 | FindButton [try] 외 1 | FP00902_Item_Setup_Attr.cs:604 | else of (mode == "MAIN") ▸ if (mode == "SUB") | CALL_EXT | siSub.EditQuery | (dsSub) | ⚠ 의미 확인 필요 |  |  |  |
| AC-068fdd50 | FindButton [try] 외 1 | FP00902_Item_Setup_Attr.cs:605 | else of (mode == "MAIN") ▸ if (mode == "SUB") | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9d4c6460 | FindButton [try] 외 1 | FP00902_Item_Setup_Attr.cs:609 | else of (mode == "MAIN") ▸ else of (mode == "SUB") ▸ if (mode == "LIST") | CALL_EXT | siList.EditQuery | (dsList) | ⚠ 의미 확인 필요 |  |  |  |
| AC-47d9c429 | FindButton [try] 외 1 | FP00902_Item_Setup_Attr.cs:610 | else of (mode == "MAIN") ▸ else of (mode == "SUB") ▸ if (mode == "LIST") | GRID_LOCK | siList.LockColumn | (0, siList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00902_Item_Setup_Attr.SaveAttrList

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-812d05a2 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1655 |  | UI_PROP | rt.TableName | "RES" | 속성 TableName 설정 |  |  |  |
| AC-c3f691fc | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1656 |  | DATA_OP | rt.Columns.SafeAdd | ("RESULT", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9936a0c9 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1657 |  | DATA_OP | rt.Columns.SafeAdd | ("COUNT", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-85a5430e | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1658 |  | DATA_OP | r.Tables.Add | (rt) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddc2f3b8 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1662 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00902_ItemSetupAttr", "save_item_group_list", dsSave, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_list] \| FP\Mast… | 엔드포인트 호출 |  |  |  |
| AC-9c79ecef | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1663 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00902_ItemSetupAttr", "delete_item_group_list", dsDelete, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_list] \| FP\Ma… | 엔드포인트 호출 |  |  |  |
| AC-8de2065c | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1666 | try ▸ if (rSave.Good()) | CALL_EXT | rSave.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a36ae15 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1670 | try ▸ if (rRemove.Good()) | CALL_EXT | rRemove.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ee1af14 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1675 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-081a50b3 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1677 |  | DATA_OP | rt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1dd186c2 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1680 | if (count > 0) | DATA_OP | rRow["RESULT"] | "SUCCESS" | 행/컬럼 값 대입 |  |  |  |
| AC-b0c6e959 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1681 | if (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-f2724af8 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1685 | else of (count > 0) | DATA_OP | rRow["RESULT"] | "FAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-d4785d24 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1686 | else of (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-65c89be0 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1688 |  | DATA_OP | rt.Rows.Add | (rRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf952f45 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00902_Item_Setup_Attr.cs:1689 |  | RETURN | return r; |  | 처리 중단/반환 |  |  |  |

## FP00902_Item_Setup_Attr.SaveAttrType

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7200444 | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1552 |  | UI_PROP | rt.TableName | "RES" | 속성 TableName 설정 |  |  |  |
| AC-8a119eac | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1553 |  | DATA_OP | rt.Columns.SafeAdd | ("RESULT", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6452642a | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1554 |  | DATA_OP | rt.Columns.SafeAdd | ("COUNT", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-45cccf66 | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1555 |  | DATA_OP | r.Tables.Add | (rt) | 데이터 객체 조작/조회 |  |  |  |
| AC-17508771 | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1559 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00902_ItemSetupAttr", "save_item_group_type", dsSave, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_type] \| FP\Mast… | 엔드포인트 호출 |  |  |  |
| AC-66fd4718 | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1560 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00902_ItemSetupAttr", "delete_item_group_type", dsDelete, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_type] \| FP\Ma… | 엔드포인트 호출 |  |  |  |
| AC-9db75d78 | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1563 | try ▸ if (rSave.Good()) | CALL_EXT | rSave.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-508039c1 | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1567 | try ▸ if (rRemove.Good()) | CALL_EXT | rRemove.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8dbd4f1f | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1572 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-33be2948 | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1574 |  | DATA_OP | rt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-24907863 | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1577 | if (count > 0) | DATA_OP | rRow["RESULT"] | "SUCCESS" | 행/컬럼 값 대입 |  |  |  |
| AC-779a6ae9 | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1578 | if (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-452a7c1d | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1582 | else of (count > 0) | DATA_OP | rRow["RESULT"] | "FAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-9d61edc6 | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1583 | else of (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-5ceb7f84 | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1585 |  | DATA_OP | rt.Rows.Add | (rRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c46bdbc | SaveButton [if (fps.Name == "spdMain")] | FP00902_Item_Setup_Attr.cs:1586 |  | RETURN | return r; |  | 처리 중단/반환 |  |  |  |

## FP00902_Item_Setup_Attr.SaveAttrValue

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e7d8acb | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1600 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-142ab162 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1602 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-2f5d997f | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1606 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8e9b9197 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1614 |  | UI_PROP | rt.TableName | "RES" | 속성 TableName 설정 |  |  |  |
| AC-875ac1f6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1615 |  | DATA_OP | rt.Columns.SafeAdd | ("RESULT", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9954fc10 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1616 |  | DATA_OP | rt.Columns.SafeAdd | ("COUNT", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d97fe761 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1617 |  | DATA_OP | r.Tables.Add | (rt) | 데이터 객체 조작/조회 |  |  |  |
| AC-150b4565 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1621 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00902_ItemSetupAttr", "save_item_group_value", dsSave, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_value] \| FP\Mas… | 엔드포인트 호출 |  |  |  |
| AC-1249c7b6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1622 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00902_ItemSetupAttr", "delete_item_group_value", dsDelete, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_value] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-685a3e09 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1625 | try ▸ if (rSave.Good()) | CALL_EXT | rSave.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-93756ce7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1629 | try ▸ if (rRemove.Good()) | CALL_EXT | rRemove.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4303db9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1634 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ce27b333 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1636 |  | DATA_OP | rt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f2fa89e9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1639 | if (count > 0) | DATA_OP | rRow["RESULT"] | "SUCCESS" | 행/컬럼 값 대입 |  |  |  |
| AC-c384abd3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1640 | if (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-484d752b | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1644 | else of (count > 0) | DATA_OP | rRow["RESULT"] | "FAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-d644d453 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1645 | else of (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-8d7ed7f1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1647 |  | DATA_OP | rt.Rows.Add | (rRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1ff8896 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00902_Item_Setup_Attr.cs:1648 |  | RETURN | return r; |  | 처리 중단/반환 |  |  |  |

## FP00902_Item_Setup_Attr.SetAttrValueHeaderInfo

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ try] / this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter) ▸ try] / this.simpleButton1.Click [try] / this.spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / FindButton [if (siMain.ActiveSheet.RowCount > 0) ▸ try] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (res.Good()) ▸ if (cnt > 0) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39c62b25 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1873 | if (dtColumInfo.Good()) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) | DATA_OP | dtColumInfo.Columns.Contains | (sColName) | 데이터 객체 조작/조회 |  |  |  |
| AC-7175fc96 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1882 | if (dtColumInfo.Good()) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ if (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace… | STATE | col.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-3b423883 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 7 | FP00902_Item_Setup_Attr.cs:1888 | if (dtColumInfo.Good()) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ else of (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhite… | UI_PROP | col.Label | sValue | 속성 Label 설정 |  |  |  |

## FP00902_Item_Setup_Attr.simpleButton1_Click

진입점: this.simpleButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3866bead | this.simpleButton1.Click | FP00902_Item_Setup_Attr.cs:2039 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | MESSAGE | MessageBox.Show | ("Can't search in Edit-Mode") | 메시지 표시 |  |  |  |
| AC-639d0c88 | this.simpleButton1.Click | FP00902_Item_Setup_Attr.cs:2040 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00902_Item_Setup_Attr.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a88d09b | this.spdMain.CellClick | FP00902_Item_Setup_Attr.cs:1776 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a093a30a | this.spdMain.CellClick | FP00902_Item_Setup_Attr.cs:1778 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | _UpAct_Cell | this.spdMain.ActiveSheet.ActiveCell.Row.Index2.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0f8b2e71 | this.spdMain.CellClick | FP00902_Item_Setup_Attr.cs:1781 | if (siMain.IsLock(siMain.SheetName) == true) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e5277e15 | this.spdMain.CellClick | FP00902_Item_Setup_Attr.cs:1796 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) | POPUP | new FPC0623_OperationByInstPopup | (false, false, "") | 팝업/폼 생성 |  |  |  |
| AC-761fcd76 | this.spdMain.CellClick | FP00902_Item_Setup_Attr.cs:1797 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cb65d6bd | this.spdMain.CellClick | FP00902_Item_Setup_Attr.cs:1798 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cccc57d0 | this.spdMain.CellClick | FP00902_Item_Setup_Attr.cs:1804 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) ▸ if (pop… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INSTANCE_ID), _sInstance) | 그리드 값 설정 |  |  |  |
| AC-cf1ffa82 | this.spdMain.CellClick | FP00902_Item_Setup_Attr.cs:1805 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) ▸ if (pop… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), sOperation) | 그리드 값 설정 |  |  |  |

## FP00902_Item_Setup_Attr.SpdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8916e2b0 | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1815 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1758e61a | (진입점 미연결) | FP00902_Item_Setup_Attr.cs:1818 | if (siMain.IsLock(siMain.SheetName) == true) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00902_Item_Setup_Attr.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a402153f | this.spdMain.KeyUp | FP00902_Item_Setup_Attr.cs:2004 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-174da005 | this.spdMain.KeyUp | FP00902_Item_Setup_Attr.cs:2007 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (e.KeyData != Keys.Left && e.KeyData != Keys.Right) | FLAG | _PressAct_Cell | _UpAct_Cell | 화면 필드/플래그 변경 |  |  |  |
| AC-bc0794ab | this.spdMain.KeyUp | FP00902_Item_Setup_Attr.cs:2008 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (e.KeyData != Keys.Left && e.KeyData != Keys.Right) | FLAG | _UpAct_Cell | this.spdMain.ActiveSheet.ActiveCell.Row.Index2.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7ad28d01 | this.spdMain.KeyUp | FP00902_Item_Setup_Attr.cs:2013 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(this.spdMain.ActiveSheet.ActiveCell.Row.Index2, siMain.GetColumnIndex(DefC… | 행/컬럼 값 대입 |  |  |  |
| AC-a31f8fce | this.spdMain.KeyUp | FP00902_Item_Setup_Attr.cs:2024 | if (siMain.IsLock(siMain.SheetName) == true) | UI_PROP | this.ActiveControl | spdMain | 속성 ActiveControl 설정 |  |  |  |
| AC-03ccf1f1 | this.spdMain.KeyUp | FP00902_Item_Setup_Attr.cs:2029 | else of (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00902_Item_Setup_Attr.SpdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0879242c | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:180 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f38142c3 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:182 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if ((siSub.ActiveSheet.Rows.Count <= 0) \|\| siSub.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7491cb9 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:199 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Insert Plan Group Value.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9259db3f | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:200 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e90b83a | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:205 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Insert Operation Value.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-87f9bb02 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:206 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc95028e | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:208 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | DATA_OP | Filter[DefColumns.INSTANCE_ID] | instance | 행/컬럼 값 대입 |  |  |  |
| AC-2ca50d1d | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:209 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | DATA_OP | Filter[DefColumns.OPERATION_ID] | operation | 행/컬럼 값 대입 |  |  |  |
| AC-06332daa | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:210 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | DATA_OP | Filter["ITEM_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-62fe9230 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:212 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | POPUP | new FPC0624_ItemByInstancePopup | () | 팝업/폼 생성 |  |  |  |
| AC-4e60ad21 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:213 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | UI_PROP | ItemPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-d38a64b6 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:213 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0e0a5bf6 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:214 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | UI_PROP | ItemPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-acce1a91 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:215 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | UI_PROP | ItemPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-f597e99e | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:216 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | POPUP | ItemPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5e10c461 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:222 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ITEM_ID), data["ITEM_ID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-ff6e3e98 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:248 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | attribute_type.Contains | ("ATTRIBUTE") | 데이터 객체 조작/조회 |  |  |  |
| AC-531fac70 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:253 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | dRow.Field | ("ATTRIBUTE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b17e1fa2 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:253 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | dRow.Field | ("ACTIVE_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-7edaea71 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:258 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c84ba072 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:259 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-11d0cc56 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:262 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | dtResult.Rows.Add | (row.col2.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-21b4f9e2 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:265 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(attribute_type), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5dc57230 | this.spdSub.CellClick | FP00902_Item_Setup_Attr.cs:273 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00902_Item_Setup_Attr.UIFindData

진입점: FindButton / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-640206af | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:481 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-95d5c945 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:482 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7bf2a158 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:485 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-78819451 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:487 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cee18860 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:491 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-686c5e44 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:494 | try | STATE | usrTextBox_Att.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-593887c5 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:495 | try | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0d95dc90 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:496 | try | STATE | simpleButton1.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-23ed71d9 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:506 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ad697f9a | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:508 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindAttrType("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-f082ecb7 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:508 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindAttrType("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7e6f9323 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:523 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | STATE | usrTextBox_Att.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-2ff2437e | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:524 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | STATE | simpleButton1.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-de5377b1 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:528 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5a99c8fa | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:529 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ac347db0 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:530 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-6f7d5b37 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:532 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | STATE | usrTextBox_Att.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-67f402ca | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:533 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2a2910c6 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:534 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | STATE | simpleButton1.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8a4b3f22 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:539 | try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-f7e3a9b0 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:540 | try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-5303e2fa | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:560 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72eed9af | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:565 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-547034d3 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:566 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-88087513 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:567 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3d89cad2 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:577 | if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b4f4b099 | FindButton 외 1 | FP00902_Item_Setup_Attr.cs:590 | if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00902_Item_Setup_Attr.usrTextBox_Att_KeyUp

진입점: this.usrTextBox_Att.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6da0074 | this.usrTextBox_Att.KeyUp | FP00902_Item_Setup_Attr.cs:2056 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | MESSAGE | MessageBox.Show | ("Can't search in Edit-Mode") | 메시지 표시 |  |  |  |
| AC-d9fe8608 | this.usrTextBox_Att.KeyUp | FP00902_Item_Setup_Attr.cs:2057 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |


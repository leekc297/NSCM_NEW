# AS-IS 액션 대조표 — FP00466

> 원천: `Doc/asisfacts/screens/FP00466/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 561행 · 메서드 35 · 종류 DATA_OP 228 · GRID_INIT 72 · FLAG 44 · RETURN 41 · UI_MISC 25 · MESSAGE 22 · GRID_LOCK 21 · UI_PROP 20 · CALL_EXT 19 · ENDPOINT 11 · POPUP 8 · GRID_SET 8 · GRID_BIND 7 · STATE 7 · STATE_RESET 5 · LIST_REBIND 4 · THROW 4 · VALUE_CLEAR 4 · VALUE_SET 3 · COMBO_DATA 2 · CALL_BASE 2 · VALIDATE 2 · LIST_CLEAR 1 · GRID_COMBO 1 · ⚠ 의미 확인 필요 21


## FP00466_Item_Setup_Attr..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff0efba5 | .ctor | FP00466_Item_Setup_Attr.cs:142 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00466_Item_Setup_Attr.ActiveSheet_CellChanged

진입점: this.spdMain.ActiveSheet.CellChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61a88842 | this.spdMain.ActiveSheet.CellChanged | FP00466_Item_Setup_Attr.cs:1869 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f07a905 | this.spdMain.ActiveSheet.CellChanged | FP00466_Item_Setup_Attr.cs:1872 | if (siMain.IsLock(siMain.SheetName) == true) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00466_Item_Setup_Attr.CboInstance_SelectedIndexChanged

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1979457c | cboInstance.SelectedIndexChanged | FP00466_Item_Setup_Attr.cs:168 |  | FLAG | dtOperationByInstance | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-e4393cd4 | cboInstance.SelectedIndexChanged | FP00466_Item_Setup_Attr.cs:168 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth, pInstanceID, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf749814 | cboInstance.SelectedIndexChanged | FP00466_Item_Setup_Attr.cs:169 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByInstance, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00466_Item_Setup_Attr.CheckValidation

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-376e60fc | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP00466_Item_Setup_Attr.cs:2138 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-29c3dc08 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP00466_Item_Setup_Attr.cs:2140 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00466_Item_Setup_Attr.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33bc8aa0 | this.Load | FP00466_Item_Setup_Attr.cs:371 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bba12060 | this.Load | FP00466_Item_Setup_Attr.cs:372 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3bad95c1 | this.Load | FP00466_Item_Setup_Attr.cs:374 |  | GRID_INIT | this.AddSheet | (spdList, SpdSheet.shtList, SpdSheet.shtList, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-043618c8 | this.Load | FP00466_Item_Setup_Attr.cs:375 |  | FLAG | siList | GetSheetInfo(spdList.Name, spdList.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-433a8c08 | this.Load | FP00466_Item_Setup_Attr.cs:378 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9cb6ab43 | this.Load | FP00466_Item_Setup_Attr.cs:379 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-85737033 | this.Load | FP00466_Item_Setup_Attr.cs:381 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00466_Item_Setup_Attr.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f70f870d | DeleteButton | FP00466_Item_Setup_Attr.cs:658 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb0fa95b | DeleteButton | FP00466_Item_Setup_Attr.cs:661 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-082e8656 | DeleteButton | FP00466_Item_Setup_Attr.cs:663 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c8a7d969 | DeleteButton | FP00466_Item_Setup_Attr.cs:665 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | siList.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP00466_Item_Setup_Attr.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71373781 | Dispose | FP00466_Item_Setup_Attr.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00466_Item_Setup_Attr.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10b2f5e5 | EditButton | FP00466_Item_Setup_Attr.cs:674 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-399883aa | EditButton | FP00466_Item_Setup_Attr.cs:675 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-937ebfa1 | EditButton | FP00466_Item_Setup_Attr.cs:678 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f6b09aec | EditButton | FP00466_Item_Setup_Attr.cs:679 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.UPDATE_ID),siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3f7f220c | EditButton | FP00466_Item_Setup_Attr.cs:684 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-83ac5820 | EditButton | FP00466_Item_Setup_Attr.cs:685 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-98577c28 | EditButton | FP00466_Item_Setup_Attr.cs:689 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.INSTANCE_ID), siSub.GetColumnIndex(DefColumns.ITEM_ID), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9fcc41cc | EditButton | FP00466_Item_Setup_Attr.cs:690 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.UPDATE_ID), siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1537062b | EditButton | FP00466_Item_Setup_Attr.cs:696 | if (fps != null) ▸ if (fps.Name == "spdList") | FLAG | siList | GetSheetInfo(spdList.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-147d927f | EditButton | FP00466_Item_Setup_Attr.cs:697 | if (fps != null) ▸ if (fps.Name == "spdList") | GRID_LOCK | siList.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e5a7b966 | EditButton | FP00466_Item_Setup_Attr.cs:699 | if (fps != null) ▸ if (fps.Name == "spdList") | GRID_LOCK | siList.LockColumn | (siList.GetColumnIndex(DefColumns.INSTANCE_ID), siList.GetColumnIndex("ATTRIBUTE_NAME"), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-995bbc7f | EditButton | FP00466_Item_Setup_Attr.cs:700 | if (fps != null) ▸ if (fps.Name == "spdList") | GRID_LOCK | siList.LockColumn | (siList.GetColumnIndex(DefColumns.UPDATE_ID), siList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00466_Item_Setup_Attr.EssentialCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c89a4db | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:2059 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3f74cac5 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:2067 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ee82aad | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:2071 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee9c2068 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:2072 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3510a13f | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:2079 | catch ((Exception ex)) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-4f167bce | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:2081 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## FP00466_Item_Setup_Attr.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4453e704 | ExcelButton | FP00466_Item_Setup_Attr.cs:717 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-3e19c987 | ExcelButton | FP00466_Item_Setup_Attr.cs:718 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-2d58fb06 | ExcelButton | FP00466_Item_Setup_Attr.cs:720 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6ef6701d | ExcelButton | FP00466_Item_Setup_Attr.cs:724 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-37e14c40 | ExcelButton | FP00466_Item_Setup_Attr.cs:725 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-fd7154a9 | ExcelButton | FP00466_Item_Setup_Attr.cs:726 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-9d088575 | ExcelButton | FP00466_Item_Setup_Attr.cs:729 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-d9a08d35 | ExcelButton | FP00466_Item_Setup_Attr.cs:730 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-c2ab0aed | ExcelButton | FP00466_Item_Setup_Attr.cs:731 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-a5db8cc2 | ExcelButton | FP00466_Item_Setup_Attr.cs:733 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-5dc2b2f0 | ExcelButton | FP00466_Item_Setup_Attr.cs:734 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-3722a7f9 | ExcelButton | FP00466_Item_Setup_Attr.cs:741 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-22ead8cd | ExcelButton | FP00466_Item_Setup_Attr.cs:745 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-ddd4ac46 | ExcelButton | FP00466_Item_Setup_Attr.cs:749 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00466_Item_Setup_Attr.FindAttrList

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell)] / this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true)] / FindButton [if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad38b2f4 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:879 | try | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-cd14d41e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:885 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d0a074f7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:889 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0fd7ec3f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:899 | try | FLAG | dsList | FindAttrList("SELECT", index) | 화면 필드/플래그 변경 |  |  |  |
| AC-8254c008 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:906 | try ▸ else of (!dsList.Good()) | FLAG | siList | GetSheetInfo(spdList.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e692a18e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:908 | try ▸ else of (!dsList.Good()) | GRID_BIND | siList.Query | (dsList,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b305c18e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:909 | try ▸ else of (!dsList.Good()) | GRID_LOCK | siList.LockColumn | (0, siList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fd40b1df | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:916 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2beb2196 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:921 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3b3827fc | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:922 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8e3e4705 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:1836 | try | DATA_OP | Filter["LOOKUP_TYPE_CODE"] | mainLookupType.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-094d3747 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:1848 | try | FLAG | LastAttrTypeIdx | attrTypeIdx | 화면 필드/플래그 변경 |  |  |  |
| AC-7f5c4766 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:1849 | try | DATA_OP | Filter[DefColumns.INSTANCE_ID] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-01d29b16 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:1850 | try | DATA_OP | Filter[DefColumns.OPERATION_ID] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dfced7b7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:1851 | try | DATA_OP | Filter["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-d4d52f7e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:1852 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00466_ItemSetupAttr", "get_attr_list", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] \| FP\Master\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4497881b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:1854 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-61a098a5 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 4 | FP00466_Item_Setup_Attr.cs:1858 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00466_Item_Setup_Attr.FindAttrListCondtion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f03cef47 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1003 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-998f9cde | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1007 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1e197d46 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1017 | try | FLAG | dsMain | dsSub.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-3c460e6b | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1017 | try | DATA_OP | dsSub.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-da75e33c | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1019 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-669aa4f6 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1032 | try ▸ if (usrTextBox_Att.Text.Length > 0) | DATA_OP | dsMain.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ce29190a | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1033 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ lambda | DATA_OP | s[columIdx].ToString().Contains | (con_param) | 데이터 객체 조작/조회 |  |  |  |
| AC-072e2c00 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1035 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).CopyToDat… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8e6a4ba5 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1035 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8c505b1a | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1036 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | s[columIdx].ToString().Contains | (con_param) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e7d1719 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1038 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | STATE_RESET | dsMain.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-9c0d1ede | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1040 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables.Add | (dtSeg) | 데이터 객체 조작/조회 |  |  |  |
| AC-e815dae1 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1044 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | DATA_OP | dsMain.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ef4c17c1 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1045 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | STATE_RESET | dsMain.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-3746ac99 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1046 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | DATA_OP | dsMain.Tables.Add | (dtTMP) | 데이터 객체 조작/조회 |  |  |  |
| AC-58324a70 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1050 | try | GRID_BIND | siSub.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-61d6895e | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1051 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c48cbd11 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1056 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd484019 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1061 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f3a074e1 | (진입점 미연결) | FP00466_Item_Setup_Attr.cs:1062 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00466_Item_Setup_Attr.FindAttrType

진입점: FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b37e1315 | FindButton [try ▸ lambda] 외 1 | FP00466_Item_Setup_Attr.cs:1604 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (cboValid.Text.ToUpper() != "ALL") { Filter["ACTIVE_FL… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7430906 | FindButton [try ▸ lambda] 외 1 | FP00466_Item_Setup_Attr.cs:1609 | try ▸ lambda ▸ if (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["ACTIVE_FLAG"] | cboValid.Text.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-accdcacb | FindButton [try ▸ lambda] 외 1 | FP00466_Item_Setup_Attr.cs:1613 | try ▸ lambda ▸ else of (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["ACTIVE_FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d3c70123 | FindButton [try ▸ lambda] 외 1 | FP00466_Item_Setup_Attr.cs:1637 | try | DATA_OP | Filter["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-ca514320 | FindButton [try ▸ lambda] 외 1 | FP00466_Item_Setup_Attr.cs:1640 | try | DATA_OP | Filter["INSTANCE_ID"] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-26772cb3 | FindButton [try ▸ lambda] 외 1 | FP00466_Item_Setup_Attr.cs:1641 | try | DATA_OP | Filter["OPERATION_ID"] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-46774881 | FindButton [try ▸ lambda] 외 1 | FP00466_Item_Setup_Attr.cs:1642 | try | DATA_OP | Filter["ITEM_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8a4bd13c | FindButton [try ▸ lambda] 외 1 | FP00466_Item_Setup_Attr.cs:1643 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00466_ItemSetupAttr", "get_item_list", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list] \| FP\Master\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1d75fdf2 | FindButton [try ▸ lambda] 외 1 | FP00466_Item_Setup_Attr.cs:1644 | try | CALL_EXT | Filter.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-096f2065 | FindButton [try ▸ lambda] 외 1 | FP00466_Item_Setup_Attr.cs:1646 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-9595572d | FindButton [try ▸ lambda] 외 1 | FP00466_Item_Setup_Attr.cs:1650 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00466_Item_Setup_Attr.FindAttrValue

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell)] / this.spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == true)] / this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true)] / FindButton [if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-143b05d6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:802 | try | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-fb16de98 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:808 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-93e4369d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:812 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-bfec1943 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:822 | try | FLAG | dsMain | FindAttrValue("SELECT",index) | 화면 필드/플래그 변경 |  |  |  |
| AC-f6064214 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:824 | try | FLAG | dsSub | dsMain.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1406adc2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:824 | try | DATA_OP | dsMain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e7a2b8da | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:826 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-adb56089 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:830 | try | GRID_BIND | siSub.Query | (dsSub,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c88e14b9 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:831 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b22c89f7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:835 | try | CALL_EXT | col_head.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-169eaea5 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:836 | try | CALL_EXT | col_head_idx.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d36b601 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:840 | try | LIST_CLEAR | SubComboBox_param.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-f2876cda | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:848 | try ▸ for (i < siSub.ActiveSheet.ColumnCount) ▸ if (siSub.ActiveSheet.Columns[i].Visible) ▸ if (siSub.ActiveSheet.Columns[i].Label != "Last … | DATA_OP | col_head.Add | (siSub.ActiveSheet.Columns[i].Label) | 데이터 객체 조작/조회 |  |  |  |
| AC-a28441c2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:849 | try ▸ for (i < siSub.ActiveSheet.ColumnCount) ▸ if (siSub.ActiveSheet.Columns[i].Visible) ▸ if (siSub.ActiveSheet.Columns[i].Label != "Last … | DATA_OP | col_head_idx.Add | (SP_DataSource.Tables[0].Columns[siSub.ActiveSheet.Columns[i].Tag.ToString()].Ordinal) | 데이터 객체 조작/조회 |  |  |  |
| AC-58bc7a7b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:857 | try ▸ for (i < col_head.Count) | DATA_OP | SubComboBox_param.Items.Add | (col_head[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-50381ea3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:859 | try | VALUE_SET | SubComboBox_param.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-769ba527 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:865 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2406e71e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:870 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4cd2da8d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:871 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-dd8a0fc8 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:1799 |  | FLAG | LastAttrTypeIdx | index | 화면 필드/플래그 변경 |  |  |  |
| AC-d2e9514d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:1806 | if (index < 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-688765a3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:1813 | if (dr == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-eaaacd88 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:1816 | try | DATA_OP | Filter["LOOKUP_TYPE_CODE"] | mainLookupType.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-94f433bc | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:1819 | try | DATA_OP | Filter[DefColumns.INSTANCE_ID] | dr[DefColumns.INSTANCE_ID].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-9b26bfa1 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:1820 | try | DATA_OP | Filter[DefColumns.OPERATION_ID] | dr[DefColumns.OPERATION_ID].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-82dcf5b0 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:1821 | try | DATA_OP | Filter["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-ad1b5806 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:1822 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00466_ItemSetupAttr", "get_item_values", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_values] \| FP\Master\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-25d72ad3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:1824 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-a6b6bfcc | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP00466_Item_Setup_Attr.cs:1828 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00466_Item_Setup_Attr.FindAttrValueCondition

진입점: this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] / this.simpleButton1.Click / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (res.Good()) ▸ if (cnt > 0) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66d0573a | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:933 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-13c8e8d5 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:937 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-828de108 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:947 | try | FLAG | dsMain | dsSub.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-08f9355a | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:947 | try | DATA_OP | dsSub.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9698b242 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:949 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6344ebf4 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:961 | try ▸ if (usrTextBox_Att.Text.Length > 0) | DATA_OP | dsMain.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8973b1f4 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:962 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ lambda | DATA_OP | s[columIdx].ToString().Contains | (con_param) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5297a5a | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:964 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).CopyToDat… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-966c3de5 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:964 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5aae2fd8 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:965 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | s[columIdx].ToString().Contains | (con_param) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f997aaf | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:967 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | STATE_RESET | dsMain.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-58b0bcdc | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:969 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables.Add | (dtSeg) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b67a6a0 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:973 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | DATA_OP | dsMain.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-25c74cfe | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:974 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | STATE_RESET | dsMain.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-d54145ae | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:975 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | DATA_OP | dsMain.Tables.Add | (dtTMP) | 데이터 객체 조작/조회 |  |  |  |
| AC-833d2ecb | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:979 | try | GRID_BIND | siSub.Query | (dsMain,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9dd1e36c | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:980 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e68051b0 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:985 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f3c240c | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:990 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1bbd745d | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP00466_Item_Setup_Attr.cs:991 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00466_Item_Setup_Attr.FindDataAttrList

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (res.Good()) ▸ if (cnt > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e41b1294 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1128 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-51866a15 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1132 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d2285006 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1142 | try | FLAG | dsMain | FindAttrList("SELECT", LastAttrTypeIdx) | 화면 필드/플래그 변경 |  |  |  |
| AC-1f4a4cbf | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1144 | try | FLAG | dsList | dsMain.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-a5bc96f6 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1144 | try | DATA_OP | dsMain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bf14601a | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1146 | try | FLAG | siList | GetSheetInfo(spdList.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b859c584 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1148 | try | GRID_BIND | siList.Query | (dsList, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b1417a80 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1149 | try | GRID_LOCK | siList.LockColumn | (0, siList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-55fb3624 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1150 | try | CALL_BASE | SetFilter | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-662d8e4d | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1156 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-568388ae | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1161 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-aba106a7 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1162 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00466_Item_Setup_Attr.FindDataAttrValue

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (res.Good()) ▸ if (cnt > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54a93886 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1075 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bab1fb0d | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1079 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4c319e8f | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1091 | try | FLAG | dsSub | FindAttrValue("SELECT", LastAttrTypeIdx) | 화면 필드/플래그 변경 |  |  |  |
| AC-0a8f85e1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1094 | try ▸ if (dsSub.Good()) | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e0ff680c | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1098 | try ▸ if (dsSub.Good()) | GRID_BIND | siSub.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6adcea2e | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1100 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8a7f7503 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1106 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c1583da6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1111 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7114120b | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1112 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00466_Item_Setup_Attr.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d794a4dc | this.Load | FP00466_Item_Setup_Attr.cs:319 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00466_Item_Setup_Attr.GetAttrValueHeaderInfo

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell)] / this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter) ▸ try ▸ if (!dtColumInfo.Good())] / this.simpleButton1.Click [try ▸ if (!dtColumInfo.Good())] / this.spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == true)] / this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true)] / FindButton [if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.Act…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11ab5873 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:1983 | if (siMain.SpreadObject.Name == "spdMain") | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-cd9b8411 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:1984 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dtColumInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b8c7b25e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:1990 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE1] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6673e182 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:1991 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE2] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2a3b60a0 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:1992 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE3] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-470670be | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:1993 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE4] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-91da4011 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:1994 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE5] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3f79d1c0 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:1995 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE6] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1ffbe88f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:1996 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE7] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-da11d52d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:1997 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE8] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d2122bed | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:1998 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE9] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-505af37b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:1999 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE10] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cf6126fc | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:2000 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE11] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6a49cfb2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:2001 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE12] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-100bce0a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:2002 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE13] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8282f10d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:2003 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE14] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-81a568a9 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:2004 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE15] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fe032607 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:2006 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dtColumInfo.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |

## FP00466_Item_Setup_Attr.GoSave

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e06b37c3 | SaveButton | FP00466_Item_Setup_Attr.cs:1173 | if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-69ce1ce2 | SaveButton | FP00466_Item_Setup_Attr.cs:1173 | if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4e03d04 | SaveButton | FP00466_Item_Setup_Attr.cs:1178 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) ▸ if (!CheckValidation(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98917c81 | SaveButton | FP00466_Item_Setup_Attr.cs:1181 | if (fps.Name == "spdMain") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-7b7ea9d4 | SaveButton | FP00466_Item_Setup_Attr.cs:1181 | if (fps.Name == "spdMain") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d901ba50 | SaveButton | FP00466_Item_Setup_Attr.cs:1188 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9f90eb67 | SaveButton | FP00466_Item_Setup_Attr.cs:1189 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0b8c203 | SaveButton | FP00466_Item_Setup_Attr.cs:1190 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) | DATA_OP | saveDS.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-51da22e3 | SaveButton | FP00466_Item_Setup_Attr.cs:1204 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | deleteDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8551a46d | SaveButton | FP00466_Item_Setup_Attr.cs:1205 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | deleteDS.Tables[0].Rows.Add | (cRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf25af8b | SaveButton | FP00466_Item_Setup_Attr.cs:1208 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) ▸ if (siMain.GetValue(i, siMain.GetColumn… | DATA_OP | cRow["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-ac603791 | SaveButton | FP00466_Item_Setup_Attr.cs:1212 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) ▸ else of (siMain.GetValue(i, siMain.GetC… | DATA_OP | cRow["ACTIVE_FLAG"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cc636ce4 | SaveButton | FP00466_Item_Setup_Attr.cs:1214 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow[DefColumns.INSTANCE_ID] | ror[DefColumns.INSTANCE_ID].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ce2702c | SaveButton | FP00466_Item_Setup_Attr.cs:1215 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow[DefColumns.OPERATION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-082ee774 | SaveButton | FP00466_Item_Setup_Attr.cs:1219 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2da55290 | SaveButton | FP00466_Item_Setup_Attr.cs:1220 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE2"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9a84077e | SaveButton | FP00466_Item_Setup_Attr.cs:1221 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE3"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ba821591 | SaveButton | FP00466_Item_Setup_Attr.cs:1222 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE4"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c951a6e9 | SaveButton | FP00466_Item_Setup_Attr.cs:1223 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE5"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a57b0912 | SaveButton | FP00466_Item_Setup_Attr.cs:1224 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE6"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5be9da1a | SaveButton | FP00466_Item_Setup_Attr.cs:1225 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE7"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-83162e1c | SaveButton | FP00466_Item_Setup_Attr.cs:1226 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE8"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6fdec003 | SaveButton | FP00466_Item_Setup_Attr.cs:1227 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE9"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f1f04dbd | SaveButton | FP00466_Item_Setup_Attr.cs:1228 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE10"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b7ed8a20 | SaveButton | FP00466_Item_Setup_Attr.cs:1229 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE11"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a20ec400 | SaveButton | FP00466_Item_Setup_Attr.cs:1230 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE12"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b52de07a | SaveButton | FP00466_Item_Setup_Attr.cs:1231 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE13"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3bf39bcb | SaveButton | FP00466_Item_Setup_Attr.cs:1232 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE14"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6dae7b2a | SaveButton | FP00466_Item_Setup_Attr.cs:1233 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE15"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6deb3351 | SaveButton | FP00466_Item_Setup_Attr.cs:1237 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e6c83d13 | SaveButton | FP00466_Item_Setup_Attr.cs:1238 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | saveDS.Tables[0].Rows.Add | (cRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc9e4909 | SaveButton | FP00466_Item_Setup_Attr.cs:1241 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) ▸ if (siMain.GetValue(i, siMain.GetC… | DATA_OP | cRow["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-bf905ef7 | SaveButton | FP00466_Item_Setup_Attr.cs:1245 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) ▸ else of (siMain.GetValue(i, siMain… | DATA_OP | cRow["ACTIVE_FLAG"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6663a79b | SaveButton | FP00466_Item_Setup_Attr.cs:1249 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) ▸ if (action == CAppSetting.FlagI) | DATA_OP | tmp_instance_type.Keys.Contains | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4c7eb96 | SaveButton | FP00466_Item_Setup_Attr.cs:1250 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) ▸ if (action == CAppSetting.FlagI) ▸… | DATA_OP | cRow[DefColumns.INSTANCE_ID] | tmp_instance_type[i] | 행/컬럼 값 대입 |  |  |  |
| AC-92108cf3 | SaveButton | FP00466_Item_Setup_Attr.cs:1254 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) ▸ else of (action == CAppSetting.Fla… | DATA_OP | cRow[DefColumns.INSTANCE_ID] | ror[DefColumns.INSTANCE_ID].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d09626a9 | SaveButton | FP00466_Item_Setup_Attr.cs:1256 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow[DefColumns.OPERATION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0afe298a | SaveButton | FP00466_Item_Setup_Attr.cs:1260 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-00f81e5c | SaveButton | FP00466_Item_Setup_Attr.cs:1261 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE2"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-19c546fd | SaveButton | FP00466_Item_Setup_Attr.cs:1262 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE3"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e8fd9e8f | SaveButton | FP00466_Item_Setup_Attr.cs:1263 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE4"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f0a0efeb | SaveButton | FP00466_Item_Setup_Attr.cs:1264 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE5"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-224a18cb | SaveButton | FP00466_Item_Setup_Attr.cs:1265 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE6"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bdf36a34 | SaveButton | FP00466_Item_Setup_Attr.cs:1266 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE7"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dbe35f9c | SaveButton | FP00466_Item_Setup_Attr.cs:1267 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE8"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b271a4ef | SaveButton | FP00466_Item_Setup_Attr.cs:1268 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE9"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c52c6eed | SaveButton | FP00466_Item_Setup_Attr.cs:1269 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE10"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-63cf9f5a | SaveButton | FP00466_Item_Setup_Attr.cs:1270 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE11"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ad3f927e | SaveButton | FP00466_Item_Setup_Attr.cs:1271 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE12"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8ac2c739 | SaveButton | FP00466_Item_Setup_Attr.cs:1272 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE13"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-58d9fdd7 | SaveButton | FP00466_Item_Setup_Attr.cs:1273 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE14"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cabd8d87 | SaveButton | FP00466_Item_Setup_Attr.cs:1274 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagD) | DATA_OP | cRow["ATTRIBUTE15"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d420483e | SaveButton | FP00466_Item_Setup_Attr.cs:1295 | if (fps.Name == "spdMain") ▸ if (res.Good()) | CALL_EXT | res.Tables[0].Rows[0][1].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-be6422b2 | SaveButton | FP00466_Item_Setup_Attr.cs:1296 | if (fps.Name == "spdMain") ▸ if (res.Good()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { cnt.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b6e22e27 | SaveButton | FP00466_Item_Setup_Attr.cs:1309 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!CheckValidation(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71f91b10 | SaveButton | FP00466_Item_Setup_Attr.cs:1311 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-97d7eb29 | SaveButton | FP00466_Item_Setup_Attr.cs:1311 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2252446d | SaveButton | FP00466_Item_Setup_Attr.cs:1314 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | (siSub.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-954c3977 | SaveButton | FP00466_Item_Setup_Attr.cs:1316 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (saveDS == null) | THROW | throw new Exception("Cannot Find Data Source"); |  | 예외 발생 |  |  |  |
| AC-65fe9dbf | SaveButton | FP00466_Item_Setup_Attr.cs:1319 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | saveDS.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f8ac43ca | SaveButton | FP00466_Item_Setup_Attr.cs:1337 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f00cdfa2 | SaveButton | FP00466_Item_Setup_Attr.cs:1338 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cTable.Rows.Add | (cRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ac97663 | SaveButton | FP00466_Item_Setup_Attr.cs:1350 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | tmp_instance_value.Keys.Contains | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef60a17e | SaveButton | FP00466_Item_Setup_Attr.cs:1351 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ if (tmp… | DATA_OP | cRow[DefColumns.INSTANCE_ID] | tmp_instance_value[i] | 행/컬럼 값 대입 |  |  |  |
| AC-953ee9a5 | SaveButton | FP00466_Item_Setup_Attr.cs:1356 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagI) ▸ if… | DATA_OP | cRow[DefColumns.INSTANCE_ID] | src_row[DefColumns.INSTANCE_ID].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f12a3adb | SaveButton | FP00466_Item_Setup_Attr.cs:1361 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (cRow[DefColumns.INSTANCE_ID].SafeStrin… | DATA_OP | tmp_instance_type.Keys.Contains | (siMain.ActiveRow.Index) | 데이터 객체 조작/조회 |  |  |  |
| AC-176886d4 | SaveButton | FP00466_Item_Setup_Attr.cs:1362 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (cRow[DefColumns.INSTANCE_ID].SafeStrin… | DATA_OP | cRow[DefColumns.INSTANCE_ID] | tmp_instance_type[siMain.ActiveRow.Index] | 행/컬럼 값 대입 |  |  |  |
| AC-4ae08a61 | SaveButton | FP00466_Item_Setup_Attr.cs:1365 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (cRow[DefColumns.INSTANCE_ID].SafeStrin… | DATA_OP | cRow[DefColumns.INSTANCE_ID] | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues.SafeString()) | 행/컬럼 값 대입 |  |  |  |
| AC-30c7a52b | SaveButton | FP00466_Item_Setup_Attr.cs:1369 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.OPERATION_ID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-98159ac3 | SaveButton | FP00466_Item_Setup_Attr.cs:1370 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ITEM_ID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3faee648 | SaveButton | FP00466_Item_Setup_Attr.cs:1372 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE1] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-15424ba1 | SaveButton | FP00466_Item_Setup_Attr.cs:1373 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE2] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-af7e954b | SaveButton | FP00466_Item_Setup_Attr.cs:1374 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE3] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-da143eee | SaveButton | FP00466_Item_Setup_Attr.cs:1375 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE4] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7278660e | SaveButton | FP00466_Item_Setup_Attr.cs:1376 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE5] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6facf20a | SaveButton | FP00466_Item_Setup_Attr.cs:1377 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE6] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-80484779 | SaveButton | FP00466_Item_Setup_Attr.cs:1378 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE7] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ea5b85bd | SaveButton | FP00466_Item_Setup_Attr.cs:1379 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE8] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9f8108d5 | SaveButton | FP00466_Item_Setup_Attr.cs:1380 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE9] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-65c20e6f | SaveButton | FP00466_Item_Setup_Attr.cs:1381 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE10] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ad2c87a6 | SaveButton | FP00466_Item_Setup_Attr.cs:1382 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE11] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-57ac4854 | SaveButton | FP00466_Item_Setup_Attr.cs:1383 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE12] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c2bd2c52 | SaveButton | FP00466_Item_Setup_Attr.cs:1384 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE13] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cc306966 | SaveButton | FP00466_Item_Setup_Attr.cs:1385 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE14] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1c2b485b | SaveButton | FP00466_Item_Setup_Attr.cs:1386 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE15] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8c52cc7e | SaveButton | FP00466_Item_Setup_Attr.cs:1390 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ACTIVE_FLAG] | active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-5b5b2f0d | SaveButton | FP00466_Item_Setup_Attr.cs:1397 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (res.Good()) | CALL_EXT | res.Tables[0].Rows[0][1].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-52dd066a | SaveButton | FP00466_Item_Setup_Attr.cs:1401 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (res.Good()) ▸ if (cnt > 0) | MESSAGE | MessageBox.Show | ("Save success") | 메시지 표시 |  |  |  |
| AC-56df3522 | SaveButton | FP00466_Item_Setup_Attr.cs:1406 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (res.Good()) ▸ else of (cnt > 0) | MESSAGE | MessageBox.Show | ("Nothing saveds") | 메시지 표시 |  |  |  |
| AC-0baa3e8f | SaveButton | FP00466_Item_Setup_Attr.cs:1411 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ else of (res.Good()) | MESSAGE | MessageBox.Show | ("Fail to save") | 메시지 표시 |  |  |  |
| AC-bb98729e | SaveButton | FP00466_Item_Setup_Attr.cs:1417 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | VALIDATE | DataUtil.checkRequiredOfSpread | (siList) | 프레임워크 검증 |  |  |  |
| AC-fd231ce3 | SaveButton | FP00466_Item_Setup_Attr.cs:1417 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (!DataUtil.checkRequiredOfSpread(siList)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aeffffbe | SaveButton | FP00466_Item_Setup_Attr.cs:1419 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (!CheckValidation(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b843b4a7 | SaveButton | FP00466_Item_Setup_Attr.cs:1421 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-26ef30d8 | SaveButton | FP00466_Item_Setup_Attr.cs:1421 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-96abfb90 | SaveButton | FP00466_Item_Setup_Attr.cs:1423 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | (siList.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-192f3853 | SaveButton | FP00466_Item_Setup_Attr.cs:1425 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (saveDS == null) | THROW | throw new Exception("Cannot Find Data Source"); |  | 예외 발생 |  |  |  |
| AC-16efb84e | SaveButton | FP00466_Item_Setup_Attr.cs:1426 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | saveDS.Tables[0].Columns.SafeAdd | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c83c5236 | SaveButton | FP00466_Item_Setup_Attr.cs:1427 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | saveDS.Tables[0].Columns.SafeAdd | (DefColumns.OLD_ATTRIBUTE_LIST, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9b9fdf2 | SaveButton | FP00466_Item_Setup_Attr.cs:1428 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | saveDS.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2a44f3f6 | SaveButton | FP00466_Item_Setup_Attr.cs:1446 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dcd951b4 | SaveButton | FP00466_Item_Setup_Attr.cs:1447 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cTable.Rows.Add | (cRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-a920808c | SaveButton | FP00466_Item_Setup_Attr.cs:1459 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) ▸ if (act… | DATA_OP | tmp_instance_list.Keys.Contains | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4e2effa | SaveButton | FP00466_Item_Setup_Attr.cs:1460 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) ▸ if (act… | DATA_OP | cRow[DefColumns.INSTANCE_ID] | tmp_instance_list[i] | 행/컬럼 값 대입 |  |  |  |
| AC-72e40948 | SaveButton | FP00466_Item_Setup_Attr.cs:1465 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) ▸ else of… | DATA_OP | cRow[DefColumns.INSTANCE_ID] | src_row[DefColumns.INSTANCE_ID].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8cf2c4f1 | SaveButton | FP00466_Item_Setup_Attr.cs:1467 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.OPERATION_ID] | siList.GetValue(i, siList.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b9a1f0c5 | SaveButton | FP00466_Item_Setup_Attr.cs:1468 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE_TYPE] | siList.GetValue(i, siList.GetColumnIndex(DefColumns.ATTRIBUTE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ecfe9db9 | SaveButton | FP00466_Item_Setup_Attr.cs:1469 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE_LIST] | siList.GetValue(i, siList.GetColumnIndex(DefColumns.ATTRIBUTE_LIST)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-958ba61f | SaveButton | FP00466_Item_Setup_Attr.cs:1470 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.OLD_ATTRIBUTE_LIST] | old_attr_list | 행/컬럼 값 대입 |  |  |  |
| AC-f94bec1c | SaveButton | FP00466_Item_Setup_Attr.cs:1471 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.DESCRIPTION] | siList.GetValue(i, siList.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0a2dde4f | SaveButton | FP00466_Item_Setup_Attr.cs:1472 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ACTIVE_FLAG] | active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1fc87265 | SaveButton | FP00466_Item_Setup_Attr.cs:1479 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (res.Good()) | CALL_EXT | res.Tables[0].Rows[0][1].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d944d96 | SaveButton | FP00466_Item_Setup_Attr.cs:1483 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (res.Good()) ▸ if (cnt > 0) | MESSAGE | MessageBox.Show | ("Save success") | 메시지 표시 |  |  |  |
| AC-e85a5e45 | SaveButton | FP00466_Item_Setup_Attr.cs:1488 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (res.Good()) ▸ else of (cnt > 0) | MESSAGE | MessageBox.Show | ("Nothing saveds") | 메시지 표시 |  |  |  |
| AC-3e421f40 | SaveButton | FP00466_Item_Setup_Attr.cs:1493 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ else of (res.Good()) | MESSAGE | MessageBox.Show | ("Fail to save") | 메시지 표시 |  |  |  |

## FP00466_Item_Setup_Attr.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f049d49a | this.Load | FP00466_Item_Setup_Attr.cs:343 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c572416e | this.Load | FP00466_Item_Setup_Attr.cs:344 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ed5448c0 | this.Load | FP00466_Item_Setup_Attr.cs:346 |  | FLAG | dtInstance | DataService.GetInstanceSetupInstance(Filter, _sNonAuth, _sSaveAuth) | 화면 필드/플래그 변경 |  |  |  |
| AC-b9afd658 | this.Load | FP00466_Item_Setup_Attr.cs:346 |  | CALL_EXT | DataService.GetInstanceSetupInstance | (Filter, _sNonAuth, _sSaveAuth) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a34cd28 | this.Load | FP00466_Item_Setup_Attr.cs:349 | if (!dtInstance.Good()) | MESSAGE | MessageBox.Show | ("You have no right to apply instance setup. ") | 메시지 표시 |  |  |  |
| AC-59f404e6 | this.Load | FP00466_Item_Setup_Attr.cs:352 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2e42159a | this.Load | FP00466_Item_Setup_Attr.cs:355 |  | FLAG | dtOperationByInstance | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-ec45f94d | this.Load | FP00466_Item_Setup_Attr.cs:355 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth, pInstanceID, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e00ffa91 | this.Load | FP00466_Item_Setup_Attr.cs:356 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByInstance, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9cd4e40a | this.Load | FP00466_Item_Setup_Attr.cs:358 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-8019bda5 | this.Load | FP00466_Item_Setup_Attr.cs:360 |  | VALUE_SET | cboValid.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-4bf3a808 | this.Load | FP00466_Item_Setup_Attr.cs:362 |  | FLAG | dtColumInfo | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-da66ec6e | this.Load | FP00466_Item_Setup_Attr.cs:365 | foreach (string str in sColumnList) | DATA_OP | dtColumInfo.Columns.SafeAdd | (str, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## FP00466_Item_Setup_Attr.InitSpread

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ try] / this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter) ▸ try] / this.simpleButton1.Click [try] / this.Load / this.spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / FindButton / SaveButton [if (fps.Name == "spdMain")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb96b164 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:392 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-22865e1b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:394 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3e160140 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:396 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Instance*","INSTANCE_NAME", FPMerge.None, 210, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5293472d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:397 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Operation*", DefColumns.OPERATION_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d2bc34c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:398 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b0d2a2ac | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:399 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f34e75f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:400 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7cd1cc0d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:401 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-452eba6d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:402 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-635e1ad5 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:403 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10071a37 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:404 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d0ca18c2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:405 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a1a682b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:406 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0ead5b0b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:407 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10e4c423 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:408 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5512115b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:409 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-199e5756 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:410 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de588147 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:411 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-84b9e359 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:412 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3aff3a23 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:414 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61cdd6c4 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:416 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("UPDATE_ID ID", DefColumns.UPDATE_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da900ab1 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:417 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("UPDATE_TIME", DefColumns.UPDATE_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb2d0248 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:418 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("INSERT_ID", DefColumns.INSERT_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f75ec141 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:419 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("INSERT_TIME", DefColumns.INSERT_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-121ab281 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:421 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5047a2dc | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:423 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8aada91d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:428 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-61826312 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:430 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9b88e97e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:431 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Instance*", "INSTANCE_NAME", FPMerge.None, 210, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-03767af9 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:432 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Operation*", DefColumns.OPERATION_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-738b25fc | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:433 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Material*", DefColumns.ITEM_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8a2a361 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:434 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4576de7b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:435 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-150a6364 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:436 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aafad976 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:437 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f9f31fb | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:438 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3f352b3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:439 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f9fccbf | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:440 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-01129b83 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:441 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b27d1bd1 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:442 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-adf54d37 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:443 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27940d5c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:444 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f66e1b6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:445 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-782c7fda | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:446 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf80cd29 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:447 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e74bb06 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:448 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c486015 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:450 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cdfa3ae2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:452 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("UPDATE ID", DefColumns.UPDATE_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d8cc59d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:453 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("UPDATE TIME", DefColumns.UPDATE_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-87d89bd5 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:454 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("INSERT ID", DefColumns.INSERT_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-88c17bd1 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:455 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("INSERT TIME", DefColumns.INSERT_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4477e652 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:457 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.Freeze | (0, siSub.GetColumnIndex(DefColumns.ITEM_ID)+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-82542735 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:459 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ae0d62d6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:464 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-0bb4d5fe | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:466 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fccb59bf | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:467 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("Instance*", "INSTANCE_NAME", FPMerge.None, 210, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d194b48 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:468 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("Operation*", DefColumns.OPERATION_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0462ad34 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:469 | if (spreadInfo.SheetName == SpdSheet.shtList) | DATA_OP | dtYesOrNo.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0029f047 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:472 | if (spreadInfo.SheetName == SpdSheet.shtList) ▸ for (i < 16) | DATA_OP | dtAttributesNames.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c9d7dd7d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:473 | if (spreadInfo.SheetName == SpdSheet.shtList) ▸ for (i < 16) | DATA_OP | dtAttributesNames.Rows.Add | (eachAttr) | 데이터 객체 조작/조회 |  |  |  |
| AC-5910ebf0 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:474 | if (spreadInfo.SheetName == SpdSheet.shtList) ▸ for (i < 16) | DATA_OP | eachAttr["CODE"] | eachAttr["NAME"] = string.Format("ATTRIBUTE{0}",i) | 행/컬럼 값 대입 |  |  |  |
| AC-163c26e7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:474 | if (spreadInfo.SheetName == SpdSheet.shtList) ▸ for (i < 16) | DATA_OP | eachAttr["NAME"] | string.Format("ATTRIBUTE{0}",i) | 행/컬럼 값 대입 |  |  |  |
| AC-af7f12a2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:476 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddComboColumn | ("Attribute Type", DefColumns.ATTRIBUTE_TYPE, FPMerge.None, 100, true, dtAttributesNames, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b26056ae | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:477 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("Name", "ATTRIBUTE_NAME", FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9d859e9 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:478 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute Option", DefColumns.ATTRIBUTE_LIST, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-54fb5903 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:479 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("Description", DefColumns.DESCRIPTION, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17cc656d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:481 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fbce121e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:483 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("UPDATE ID", DefColumns.UPDATE_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c2371385 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:484 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("UPDATE TIME", DefColumns.UPDATE_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f2d109b9 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:485 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddTextColumn | ("INSERT ID", DefColumns.INSERT_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7eb136fe | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:486 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("INSERT TIME", DefColumns.INSERT_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c6287be | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:488 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.Freeze | (0, siList.GetColumnIndex(DefColumns.OPERATION_ID)+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-98ea9a31 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 9 | FP00466_Item_Setup_Attr.cs:490 | if (spreadInfo.SheetName == SpdSheet.shtList) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00466_Item_Setup_Attr.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98cec824 | InsertButton | FP00466_Item_Setup_Attr.cs:1503 | if (fps.Name == "spdMain") | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d7cce3d4 | InsertButton | FP00466_Item_Setup_Attr.cs:1506 | if (fps.Name == "spdMain") | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-6bebfd75 | InsertButton | FP00466_Item_Setup_Attr.cs:1508 | if (fps.Name == "spdMain") | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-e84bc446 | InsertButton | FP00466_Item_Setup_Attr.cs:1514 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a59bcf13 | InsertButton | FP00466_Item_Setup_Attr.cs:1534 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx <= siMain.GetMaxRowIndex()) ▸ if (… | DATA_OP | tmp_instance_value.Keys.Contains | (insCell.Row.Index) | 데이터 객체 조작/조회 |  |  |  |
| AC-51a23264 | InsertButton | FP00466_Item_Setup_Attr.cs:1535 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx <= siMain.GetMaxRowIndex()) ▸ if (… | DATA_OP | tmp_instance_value[insCell.Row.Index] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-372095a7 | InsertButton | FP00466_Item_Setup_Attr.cs:1537 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx <= siMain.GetMaxRowIndex()) ▸ if (… | DATA_OP | tmp_instance_value.Add | (insCell.Row.Index, instance_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-12f074f1 | InsertButton | FP00466_Item_Setup_Attr.cs:1541 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx <= siMain.GetMaxRowIndex()) | DATA_OP | defaultData.Add | (DefColumns.INSTANCE_NAME, instance_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-5cbf5e52 | InsertButton | FP00466_Item_Setup_Attr.cs:1542 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx <= siMain.GetMaxRowIndex()) | DATA_OP | defaultData.Add | (DefColumns.INSTANCE_ID, instance_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad129e1a | InsertButton | FP00466_Item_Setup_Attr.cs:1543 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx <= siMain.GetMaxRowIndex()) | DATA_OP | defaultData.Add | (DefColumns.OPERATION_ID, operation_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-83f40e68 | InsertButton | FP00466_Item_Setup_Attr.cs:1550 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-7e609e7f | InsertButton | FP00466_Item_Setup_Attr.cs:1552 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.INSTANCE_NAME), siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d3117dca | InsertButton | FP00466_Item_Setup_Attr.cs:1553 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.UPDATE_ID), siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-40d55903 | InsertButton | FP00466_Item_Setup_Attr.cs:1557 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | siList.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a8901e04 | InsertButton | FP00466_Item_Setup_Attr.cs:1577 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx … | DATA_OP | tmp_instance_list.Keys.Contains | (insCell.Row.Index) | 데이터 객체 조작/조회 |  |  |  |
| AC-48e80c67 | InsertButton | FP00466_Item_Setup_Attr.cs:1578 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx … | DATA_OP | tmp_instance_list[insCell.Row.Index] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-38cac0f9 | InsertButton | FP00466_Item_Setup_Attr.cs:1580 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx … | DATA_OP | tmp_instance_list.Add | (insCell.Row.Index, instance_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-d41e4362 | InsertButton | FP00466_Item_Setup_Attr.cs:1585 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx … | DATA_OP | defaultData.Add | (DefColumns.INSTANCE_NAME, instance_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-35072648 | InsertButton | FP00466_Item_Setup_Attr.cs:1586 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx … | DATA_OP | defaultData.Add | (DefColumns.INSTANCE_ID, instance_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-40563eba | InsertButton | FP00466_Item_Setup_Attr.cs:1587 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") ▸ if (LastAttrTypeIdx >= 0 && LastAttrTypeIdx … | DATA_OP | defaultData.Add | (DefColumns.OPERATION_ID, operation_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd749fec | InsertButton | FP00466_Item_Setup_Attr.cs:1589 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-437f9efd | InsertButton | FP00466_Item_Setup_Attr.cs:1590 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | defaultData.Add | (DefColumns.ATTRIBUTE_TYPE, "ATTRIBUTE1") | 데이터 객체 조작/조회 |  |  |  |
| AC-21b93dd9 | InsertButton | FP00466_Item_Setup_Attr.cs:1592 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | GRID_SET | siList.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-c3502148 | InsertButton | FP00466_Item_Setup_Attr.cs:1593 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | GRID_LOCK | siList.LockRange | (insCell, siList.GetColumnIndex(DefColumns.UPDATE_ID), siList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00466_Item_Setup_Attr.RefreshSpreadSheet

진입점: FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f142f5e | FindButton [try] 외 1 | FP00466_Item_Setup_Attr.cs:635 | if (mode == "MAIN") | CALL_EXT | siMain.EditQuery | (dsMain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac52de3d | FindButton [try] 외 1 | FP00466_Item_Setup_Attr.cs:636 | if (mode == "MAIN") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6bf2369b | FindButton [try] 외 1 | FP00466_Item_Setup_Attr.cs:640 | else of (mode == "MAIN") ▸ if (mode == "SUB") | CALL_EXT | siSub.EditQuery | (dsSub) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6123cbe8 | FindButton [try] 외 1 | FP00466_Item_Setup_Attr.cs:641 | else of (mode == "MAIN") ▸ if (mode == "SUB") | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ec341b77 | FindButton [try] 외 1 | FP00466_Item_Setup_Attr.cs:645 | else of (mode == "MAIN") ▸ else of (mode == "SUB") ▸ if (mode == "LIST") | CALL_EXT | siList.EditQuery | (dsList) | ⚠ 의미 확인 필요 |  |  |  |
| AC-75969b4b | FindButton [try] 외 1 | FP00466_Item_Setup_Attr.cs:646 | else of (mode == "MAIN") ▸ else of (mode == "SUB") ▸ if (mode == "LIST") | GRID_LOCK | siList.LockColumn | (0, siList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00466_Item_Setup_Attr.SaveAttrList

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b62913ff | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1760 |  | UI_PROP | rt.TableName | "RES" | 속성 TableName 설정 |  |  |  |
| AC-6bd9e183 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1761 |  | DATA_OP | rt.Columns.SafeAdd | ("RESULT", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-32c9ddea | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1762 |  | DATA_OP | rt.Columns.SafeAdd | ("COUNT", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-26371b5e | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1763 |  | DATA_OP | r.Tables.Add | (rt) | 데이터 객체 조작/조회 |  |  |  |
| AC-7559550c | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1767 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00466_ItemSetupAttr", "save_item_group_list", dsSave, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_list] \| FP\Mast… | 엔드포인트 호출 |  |  |  |
| AC-fea44734 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1768 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00466_ItemSetupAttr", "delete_item_group_list", dsDelete, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_list] \| FP\Ma… | 엔드포인트 호출 |  |  |  |
| AC-cba1b616 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1771 | try ▸ if (rSave.Good()) | CALL_EXT | rSave.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2239657e | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1775 | try ▸ if (rRemove.Good()) | CALL_EXT | rRemove.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d1ee804 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1780 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e6f30f69 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1782 |  | DATA_OP | rt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c794fd59 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1785 | if (count > 0) | DATA_OP | rRow["RESULT"] | "SUCCESS" | 행/컬럼 값 대입 |  |  |  |
| AC-67210263 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1786 | if (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-b0fbb3b5 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1790 | else of (count > 0) | DATA_OP | rRow["RESULT"] | "FAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-3b5256a6 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1791 | else of (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-3cc08112 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1793 |  | DATA_OP | rt.Rows.Add | (rRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-95ca1a7e | SaveButton [else of (fps.Name == "spdMain") ▸ else of (fps.N… | FP00466_Item_Setup_Attr.cs:1794 |  | RETURN | return r; |  | 처리 중단/반환 |  |  |  |

## FP00466_Item_Setup_Attr.SaveAttrType

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adcb237a | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1657 |  | UI_PROP | rt.TableName | "RES" | 속성 TableName 설정 |  |  |  |
| AC-8cffe919 | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1658 |  | DATA_OP | rt.Columns.SafeAdd | ("RESULT", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5c87e94 | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1659 |  | DATA_OP | rt.Columns.SafeAdd | ("COUNT", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f741020 | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1660 |  | DATA_OP | r.Tables.Add | (rt) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a29afaf | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1664 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00466_ItemSetupAttr", "save_item_group_type", dsSave, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_type] \| FP\Mast… | 엔드포인트 호출 |  |  |  |
| AC-526af4cf | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1665 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00466_ItemSetupAttr", "delete_item_group_type", dsDelete, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_type] \| FP\Ma… | 엔드포인트 호출 |  |  |  |
| AC-610b6766 | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1668 | try ▸ if (rSave.Good()) | CALL_EXT | rSave.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-26cc7bc2 | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1672 | try ▸ if (rRemove.Good()) | CALL_EXT | rRemove.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b593432f | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1677 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-1ef0ad78 | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1679 |  | DATA_OP | rt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4cb3a74e | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1682 | if (count > 0) | DATA_OP | rRow["RESULT"] | "SUCCESS" | 행/컬럼 값 대입 |  |  |  |
| AC-14680eae | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1683 | if (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-6079dc98 | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1687 | else of (count > 0) | DATA_OP | rRow["RESULT"] | "FAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-c4c7b760 | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1688 | else of (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-f2ad1da1 | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1690 |  | DATA_OP | rt.Rows.Add | (rRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-0509ca43 | SaveButton [if (fps.Name == "spdMain")] | FP00466_Item_Setup_Attr.cs:1691 |  | RETURN | return r; |  | 처리 중단/반환 |  |  |  |

## FP00466_Item_Setup_Attr.SaveAttrValue

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77427f60 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1705 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-08669d04 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1707 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-a4628181 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1711 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-2199d040 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1719 |  | UI_PROP | rt.TableName | "RES" | 속성 TableName 설정 |  |  |  |
| AC-e236a114 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1720 |  | DATA_OP | rt.Columns.SafeAdd | ("RESULT", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-070a8a3f | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1721 |  | DATA_OP | rt.Columns.SafeAdd | ("COUNT", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d31b3924 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1722 |  | DATA_OP | r.Tables.Add | (rt) | 데이터 객체 조작/조회 |  |  |  |
| AC-d089d311 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1726 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00466_ItemSetupAttr", "save_item_group_value", dsSave, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_value] \| FP\Mas… | 엔드포인트 호출 |  |  |  |
| AC-df91ecaf | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1727 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00466_ItemSetupAttr", "delete_item_group_value", dsDelete, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_value] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-544f4cea | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1730 | try ▸ if (rSave.Good()) | CALL_EXT | rSave.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3fa862d6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1734 | try ▸ if (rRemove.Good()) | CALL_EXT | rRemove.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a00a1463 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1739 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-0f045540 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1741 |  | DATA_OP | rt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-47c4b3f1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1744 | if (count > 0) | DATA_OP | rRow["RESULT"] | "SUCCESS" | 행/컬럼 값 대입 |  |  |  |
| AC-212ee170 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1745 | if (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-9a3a1111 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1749 | else of (count > 0) | DATA_OP | rRow["RESULT"] | "FAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-ca764b7d | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1750 | else of (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-a81227eb | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1752 |  | DATA_OP | rt.Rows.Add | (rRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1cabb87 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00466_Item_Setup_Attr.cs:1753 |  | RETURN | return r; |  | 처리 중단/반환 |  |  |  |

## FP00466_Item_Setup_Attr.SetAttrValueHeaderInfo

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ try] / this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter) ▸ try] / this.simpleButton1.Click [try] / this.spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / FindButton [if (siMain.ActiveSheet.RowCount > 0) ▸ try] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (r…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7177f8a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:2023 | if (dtColumInfo.Good()) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) | DATA_OP | dtColumInfo.Columns.Contains | (sColName) | 데이터 객체 조작/조회 |  |  |  |
| AC-3163e50a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:2032 | if (dtColumInfo.Good()) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ if (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace… | STATE | col.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-9f59972f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP00466_Item_Setup_Attr.cs:2038 | if (dtColumInfo.Good()) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ else of (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhite… | UI_PROP | col.Label | sValue | 속성 Label 설정 |  |  |  |

## FP00466_Item_Setup_Attr.simpleButton1_Click

진입점: this.simpleButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89aa9f20 | this.simpleButton1.Click | FP00466_Item_Setup_Attr.cs:2189 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | MESSAGE | MessageBox.Show | ("Can't search in Edit-Mode") | 메시지 표시 |  |  |  |
| AC-8e35295b | this.simpleButton1.Click | FP00466_Item_Setup_Attr.cs:2190 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00466_Item_Setup_Attr.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a6ce724 | this.spdMain.CellClick | FP00466_Item_Setup_Attr.cs:1888 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-855328b8 | this.spdMain.CellClick | FP00466_Item_Setup_Attr.cs:1890 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | _UpAct_Cell | this.spdMain.ActiveSheet.ActiveCell.Row.Index2.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1cc9aaa6 | this.spdMain.CellClick | FP00466_Item_Setup_Attr.cs:1893 | if (siMain.IsLock(siMain.SheetName) == true) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7ed9a2db | this.spdMain.CellClick | FP00466_Item_Setup_Attr.cs:1908 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) | POPUP | new FPC0623_OperationByInstPopup | (false, false, "") | 팝업/폼 생성 |  |  |  |
| AC-d7841b09 | this.spdMain.CellClick | FP00466_Item_Setup_Attr.cs:1909 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) | UI_PROP | popOperation.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-ec80e626 | this.spdMain.CellClick | FP00466_Item_Setup_Attr.cs:1909 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b73d211e | this.spdMain.CellClick | FP00466_Item_Setup_Attr.cs:1910 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-db8d2c85 | this.spdMain.CellClick | FP00466_Item_Setup_Attr.cs:1911 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-17728110 | this.spdMain.CellClick | FP00466_Item_Setup_Attr.cs:1919 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) ▸ if (pop… | DATA_OP | tmp_instance_type.Keys.Contains | (e.Row) | 데이터 객체 조작/조회 |  |  |  |
| AC-23e7dd8b | this.spdMain.CellClick | FP00466_Item_Setup_Attr.cs:1920 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) ▸ if (pop… | DATA_OP | tmp_instance_type[e.Row] | _sInstanceId | 행/컬럼 값 대입 |  |  |  |
| AC-8525bc98 | this.spdMain.CellClick | FP00466_Item_Setup_Attr.cs:1922 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) ▸ if (pop… | DATA_OP | tmp_instance_type.Add | (e.Row, _sInstanceId) | 데이터 객체 조작/조회 |  |  |  |
| AC-69ed30e1 | this.spdMain.CellClick | FP00466_Item_Setup_Attr.cs:1924 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) ▸ if (pop… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INSTANCE_NAME), _sInstanceName) | 그리드 값 설정 |  |  |  |
| AC-749c6aee | this.spdMain.CellClick | FP00466_Item_Setup_Attr.cs:1925 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (Row >= 0 && action == CAppSetting.FlagI && (e.Column==1 \|\| e.Column==2)) ▸ if (pop… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), sOperation) | 그리드 값 설정 |  |  |  |

## FP00466_Item_Setup_Attr.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab397e7d | this.spdMain.CellDoubleClick | FP00466_Item_Setup_Attr.cs:1940 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-de8c8eeb | this.spdMain.CellDoubleClick | FP00466_Item_Setup_Attr.cs:1946 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column < siMain.GetColumnIndex(DefColumns.ATTRIBUTE1) \|\| e.Column > siMain.GetColumnI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33d6a674 | this.spdMain.CellDoubleClick | FP00466_Item_Setup_Attr.cs:1961 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (string.IsNullOrWhiteSpace(attrname)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78769005 | this.spdMain.CellDoubleClick | FP00466_Item_Setup_Attr.cs:1963 | if (siMain.IsLock(siMain.SheetName) == true) | POPUP | new FPC0625_AttrOptionEditPopup | (instance_id, instance_name,operation, attrtype, attrname) | 팝업/폼 생성 |  |  |  |
| AC-981910c6 | this.spdMain.CellDoubleClick | FP00466_Item_Setup_Attr.cs:1964 | if (siMain.IsLock(siMain.SheetName) == true) | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ac3c5ad8 | this.spdMain.CellDoubleClick | FP00466_Item_Setup_Attr.cs:1965 | if (siMain.IsLock(siMain.SheetName) == true) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5896849e | this.spdMain.CellDoubleClick | FP00466_Item_Setup_Attr.cs:1968 | if (siMain.IsLock(siMain.SheetName) == true) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00466_Item_Setup_Attr.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bff8d909 | this.spdMain.KeyUp | FP00466_Item_Setup_Attr.cs:2154 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dd3942c9 | this.spdMain.KeyUp | FP00466_Item_Setup_Attr.cs:2157 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (e.KeyData != Keys.Left && e.KeyData != Keys.Right) | FLAG | _PressAct_Cell | _UpAct_Cell | 화면 필드/플래그 변경 |  |  |  |
| AC-b4d83b2a | this.spdMain.KeyUp | FP00466_Item_Setup_Attr.cs:2158 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (e.KeyData != Keys.Left && e.KeyData != Keys.Right) | FLAG | _UpAct_Cell | this.spdMain.ActiveSheet.ActiveCell.Row.Index2.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a09133a5 | this.spdMain.KeyUp | FP00466_Item_Setup_Attr.cs:2163 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(this.spdMain.ActiveSheet.ActiveCell.Row.Index2, siMain.GetColumnIndex(DefC… | 행/컬럼 값 대입 |  |  |  |
| AC-47a410a8 | this.spdMain.KeyUp | FP00466_Item_Setup_Attr.cs:2174 | if (siMain.IsLock(siMain.SheetName) == true) | UI_PROP | this.ActiveControl | spdMain | 속성 ActiveControl 설정 |  |  |  |
| AC-698373f4 | this.spdMain.KeyUp | FP00466_Item_Setup_Attr.cs:2179 | else of (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00466_Item_Setup_Attr.SpdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-179e1aa0 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:182 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab080bb7 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:184 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if ((siSub.ActiveSheet.Rows.Count <= 0) \|\| siSub.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2e69ad36 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:192 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | DATA_OP | siSub.GetBindingRow | (e.Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8b1ad138 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:197 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | DATA_OP | tmp_instance_value.Keys.Contains | (e.Row) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd81f1e0 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:206 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Insert Plan Group Value.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-20265939 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:207 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e6ac3f52 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:212 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Insert Operation Value.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39ac2ddc | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:213 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16cc71ca | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:215 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | DATA_OP | Filter[DefColumns.INSTANCE_ID] | instance | 행/컬럼 값 대입 |  |  |  |
| AC-3cd53080 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:216 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | DATA_OP | Filter[DefColumns.OPERATION_ID] | operation | 행/컬럼 값 대입 |  |  |  |
| AC-071ae03a | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:217 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | DATA_OP | Filter["ITEM_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7454e477 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:219 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | POPUP | new FPC0624_ItemByInstancePopup | () | 팝업/폼 생성 |  |  |  |
| AC-ec94ca0e | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:220 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | UI_PROP | ItemPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-b4e0c98d | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:220 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6ee7f046 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:221 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | UI_PROP | ItemPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-8fa05d9d | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:222 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | UI_PROP | ItemPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-b6e0c29a | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:223 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | POPUP | ItemPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1b7da31d | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:229 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ITEM_ID), data["ITEM_ID"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-62f24199 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:258 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | tmp_instance_value.Keys.Contains | (e.Row) | 데이터 객체 조작/조회 |  |  |  |
| AC-2014504c | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:273 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | attribute_type.Contains | ("ATTRIBUTE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f6077882 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:278 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | dRow.Field | ("ATTRIBUTE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-43969844 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:279 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | dRow.Field | ("ACTIVE_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b4bb087 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:280 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | dRow.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-925c91aa | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:281 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-96f25978 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:287 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0cb09b6 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:288 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b827b17 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:291 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | DATA_OP | dtResult.Rows.Add | (row.col2.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-fbdf5bf0 | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:294 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (siSub.Act… | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(attribute_type), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f2a37aaa | this.spdSub.CellClick | FP00466_Item_Setup_Attr.cs:302 | if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00466_Item_Setup_Attr.UIFindData

진입점: FindButton / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b917dffe | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:517 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-13aa1991 | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:518 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-816bb12a | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:521 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-653df823 | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:523 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-95b6dc3a | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:527 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-671bac2d | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:530 | try | STATE | usrTextBox_Att.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-00958d4a | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:531 | try | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c0b84729 | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:532 | try | STATE | simpleButton1.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-784b8285 | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:542 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-52b8ae3a | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:544 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindAttrType("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-822435d0 | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:544 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindAttrType("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1ad59245 | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:559 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | STATE | usrTextBox_Att.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-0fd2659b | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:560 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | STATE | simpleButton1.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c34bd1fc | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:564 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-40a8fe65 | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:565 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-162ac7ce | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:566 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-1ab659ed | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:568 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | STATE | usrTextBox_Att.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-9b8524c5 | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:569 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-b5d9f1f3 | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:570 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | STATE | simpleButton1.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8b467349 | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:575 | try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-a7333c87 | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:576 | try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-4919832f | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:596 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aed62ee5 | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:601 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1aed738b | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:602 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-43aafbdd | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:603 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-66c8e954 | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:613 | if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-016f917b | FindButton 외 1 | FP00466_Item_Setup_Attr.cs:626 | if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00466_Item_Setup_Attr.usrTextBox_Att_KeyUp

진입점: this.usrTextBox_Att.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4582b3e7 | this.usrTextBox_Att.KeyUp | FP00466_Item_Setup_Attr.cs:2206 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | MESSAGE | MessageBox.Show | ("Can't search in Edit-Mode") | 메시지 표시 |  |  |  |
| AC-259cee02 | this.usrTextBox_Att.KeyUp | FP00466_Item_Setup_Attr.cs:2207 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |


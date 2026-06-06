# AS-IS Framework — `BaseForm` 정밀 분석

> **source**: `C:\Projects\NSCM\GSCM\01.Framework\GSCM.Windows.Forms\UI\BaseForm.cs` (6,329 lines)
>
> **상속**: `BaseForm : FoxForm` (line 194). `FoxForm` 은 TheOne / DevExpress 기반 wrapper.
>
> **중요성**: GSCM 332 도메인 화면이 모두 `BaseForm` 직접 또는 간접 상속 (예외: `DialogForm` / `DXRibbonForm` 일부). **이 문서가 모든 화면의 inheritance substrate.**

---

## §0 메타

| 항목 | 값 |
|---|---|
| Source path | `GSCM\01.Framework\GSCM.Windows.Forms\UI\BaseForm.cs` |
| Lines | 6,329 |
| 상속 | `BaseForm : FoxForm` |
| 분석 일자 | 2026-06-03 |
| Phase | Phase 1 |
| 진행도 | 핵심 dispatcher / virtual hook / lifecycle 100% / 일부 utility (Excel export / FilterService 등) skeleton |

---

## §1 핵심 protected fields / public properties

| 라인 | 식별자 | 타입 | 책임 |
|---:|---|---|---|
| 209 | `FIX_SMART_MERGE_FILTER_COMPATABLE_MODE` | `public bool` | SmartMerge ↔ AutoFilter 충돌 회피 모드 |
| 212 | `bEnable` | `protected bool[7]` | CRUD 6대 + Help 버튼 활성 상태 (인덱스 0~6) |
| 215 | `formauth` | `protected FormAuth` | 화면 권한 enum (None / Disable / Inquiry / Update / All) |
| 217 | `SpreadInfoList` | `protected readonly ArrayList` | 모든 sheet 의 SpreadInfo wrapper |
| 223 | `fps` | `protected FpSpread` | 현재 선택된 FpSpread (active grid) |
| 231 | `IsChange` | `public bool` | 데이터 변경 여부 (FormClosing 시 MSG00013 trigger) |
| 240 | `CanMoveFrozenColumn` | `public bool` | Frozen column 위치 변경 허용 |
| 486 | `IsInitOpen` | `public bool` | 초기 open 여부 (SelectionChanged event 차단용) |
| 490 | `IsSmartMerge` | `public bool` | SpreadInfo.SmartColMerge 사용 여부 |
| 496 | `smartMergeInfo` | `public Dictionary<string,bool>` | sheet 별 smart merge 적용 여부 |
| 500 | `CanModelChange` | `public bool` | data model Changed event 차단 플래그 |
| 538 | `DeleteOperation` | `public DeleteOperationKind` | Delete 키 동작 (ToNull / ToZero / None) |
| 545 | `ManualSearchCondition` | `public DataSet` | 수동 검색조건 override |
| 611 | `FindWhenOpen` | `public bool` | OnShown 시 자동 FindButton 호출 |
| 615 | `IgnoreSearchCondition` | `public bool` | 저장된 검색조건 무시 |
| 630 | `IsPopup` | `public bool` | popup form 여부 (FormClosing 처리 분기) |
| 633 | `lstSearchConditon` | `List<SearchConditon>` | 저장 대상 검색조건 buffer |
| 636 | `dsSearchCondition` | `DataSet` | 저장된 검색조건 (FoxBizClient → UP_FX_GetSearchCondition) |
| 650 | `_MenuID` | `public string` | 현재 화면 메뉴 ID |
| 651 | `_MenuGroup` | `public string` | 메뉴 그룹 (column setting 저장 키) |
| 654 | `ControlList` | `Dictionary<Control,int>` | 검색조건 컨트롤 인벤토리 (TabIndex 정렬용) |
| 657 | `IsEditMode` | `public bool` | 편집 모드 (Sort/Save 가드) |
| 664 | `IsPopupEditCheck` | `public bool` | popup 닫을 때 IsChange 체크 여부 |
| 667 | `IsFilter` | `public bool` | 필터 적용 여부 |
| 672, 676 | `dtFilterColum / dtFilterValue` | `DataTable` | ⚠️ **deprecated** (사용 안 됨, 보존만) |
| 678, 679 | `dtFilterCol2 / dtFilterVal2` | `public DataTable` | sheet 별 column 필터 상태 (활성) |
| 686 | `ConditionNotUseList` | `List<object>` | 검색조건 제외 컨트롤 list (override 가능) |
| 687 | `ReadOnlySheetList` | `List<string>` | 읽기 전용 sheet 명 list |

---

## §2 hotkey dispatcher (F1~F12)

### §2.1 dispatcher 패턴 (3 단계)

```
물리 keystroke (F1~F12) → ProcessCmdKey (940) → AssignShortCut (946) → OnClickXxxButton (public dispatcher) → XxxButton (protected virtual override target)
```

| F-key | dispatcher (public, BaseForm 정의) | 권한 체크 | 추가 가드 | 호출하는 virtual |
|---|---|---|---|---|
| F1 | `OnClickHelpButton` (3598) | - | - | `HelpButton()` (4030) |
| F2 | `OnClickEditButton` (3664) | CanUpdate → MSG00096 | AllowGroup → MSG00115 / IsSort → MSG00139 / IsSortChange → MSG00162 / CheckValidation(Edit) | `EditButton()` (3998) |
| F3 | `OnClickSortButton` (5268) | - | IsEditMode → MSG00140 (수정모드에서는 Sort 불가) | (내부 toggle, virtual 없음) |
| F4 | `OnClickFilterButton` (5054) | - | (None) | (내부 toggle, virtual 없음) |
| F5 | `OnClickFindButton` (3603) | CanSelect → MSG00096 | IsChange → MSG00127 (변경 후 조회) / SetFilterALLCancel 임시 | `FindButton()` (3989) |
| F6 | `OnClickConditionButton` (5237) | - | IsPopup return | `SavePanelCondition` (FoxBizClient.SaveSearchCondition) |
| F7 | `OnClickSaveButton` (3840) | CanSave → MSG00096 | CheckValidation(Save) → MSG00010 / Action cell count = 0 → MSG00133 | `SaveButton()` (3994) |
| F8 | `OnClickInsertButton` (3786) | CanInsert → MSG00096 | CheckValidation(Insert) → MSG00008 | `InsertButton()` (4002) |
| F9 | `OnClickDeleteButton` (3824) | CanDelete → MSG00096 | CheckValidation(Delete) → MSG00009 | `DeleteButton()` (4006) |
| F10 | `OnClickResetConditionButton` (5245) | - | IsPopup return / MSG00397 (확인) → ResetPanelCondition | `ResetPanelCondition` (FoxBizClient.ResetSearchCondition) |
| F11 | (주석 처리, 미사용) | - | - | `OnClickFullScreenButton` (3929) |
| F12 | `OnClickExcelButton` (3923) | - | CheckValidation(None) | `ExcelButton()` (4151) |

### §2.2 권한 체크 패턴 (모든 OnClickXxxButton 공통)

```csharp
// 위치: 모든 OnClickXxxButton 의 첫 부분
if (this.ViewModel != null) {
    if (!this.ViewModel.SecurityContext.CanXxx) {
        MessageHelper.GMessageBox("MSG00096");  // 사용 권한이 없습니다
        return;
    }
}
```

`SecurityContext` 4 권한: `CanSelect / CanInsert / CanUpdate / CanDelete / CanSave`. 단순화: **CanSelect=F5/CanUpdate=F2/CanInsert=F8/CanDelete=F9/CanSave=F7** 매핑.

### §2.3 `CheckValidation(ButtonType)` 패턴 (3939)

```csharp
// Insert/Delete/Save 시점에 호출, 편집 모드 가드
// fps == null → MSG00007 "선택한 Spread 가 없습니다"
// IsLock(sheetName) = true → 수정 모드 아님 → 종류별 MSG (MSG00008/9/10)
```

| ButtonType | MSG Code |
|---|---|
| Insert | MSG00008 (수정모드가 아니므로 추가할 수 없습니다) |
| Delete | MSG00009 (수정모드가 아니므로 삭제할 수 없습니다) |
| Save | MSG00010 (수정모드가 아니므로 저장할 수 없습니다) |
| Edit | (return true) |
| None | (return true) |

### §2.4 TO-BE 매핑

| AS-IS | TO-BE |
|---|---|
| `SecurityContext.CanXxx` | `SCM_ADM_USER_GR_MNU_BTN_MPG_M.BTN_ID = 'FIND'/'INSERT'/'DELETE'/'SAVE'` 권한 |
| `OnClickXxxButton` 3 단계 (권한 → 가드 → virtual) | `SubTitle.DefaultButtonActions` + `hotkeyConfig.{search/insert/delete/save}` |
| F-key 매핑 | `SubTitle` 자동 hotkey 등록 (F5=search / F7=save / F8=insert / F9=delete) |
| `MSG00096` 권한 없음 | `setAlert(t('MSG00096'))` (TO-BE i18n KO/EN/CN 동등 코드) |
| `CheckValidation(Insert/Delete/Save)` IsLock 체크 | TO-BE 는 column meta `_inputEditType` 자동 처리 (DataGrid wrapper) |
| `MSG00133` 수정한 내용 없음 | `useSaveWithValidation` 안의 변경 row 0 건 check |

---

## §3 CRUD 6대 + Aux 4대 — protected virtual (override 대상)

> **모든 도메인 화면이 override 하는 hook. body 가 비어 있음 = 화면별 구현 의무.**

### §3.1 CRUD 6대 hook

| 라인 | 시그니처 | default body | TO-BE 매핑 |
|---:|---|---|---|
| 3989 | `protected virtual void FindButton()` | empty | `handleSearch` + `useTabProcQuery` refetch |
| 3994 | `protected virtual void SaveButton()` | empty | `handleSave` + `useSaveWithValidation` + `useProcMutation` |
| 3998 | `protected virtual void EditButton()` | empty | (TO-BE 는 column meta 자동 처리, 별도 hook 불필요) |
| 4002 | `protected virtual void InsertButton()` | empty | `handleInsert` + `GridAction.addRow` |
| 4006 | `protected virtual void DeleteButton()` | empty | `handleDelete` + `GridAction.removeRow(true)` |
| 4151 | `protected virtual void ExcelButton()` | (overload 호출) | `SubTitle.excelFileName` (자동) |

### §3.2 ExcelButton overload chain

| 라인 | 시그니처 | 책임 |
|---:|---|---|
| 4220 | `ExportExcel(int ignoreDepth, bool RemoveActionCell, bool RemoveInvisibleCell)` | 기본 export (default `ignoreDepth=1`, `RemoveActionCell=true`, `RemoveInvisibleCell=true`) |
| 4478 | `ExportExcel2()` | 변형 export |
| 4611 | `ExportExcel(bool isOpen)` | 저장 후 자동 열기 옵션 |
| 4850 | `ExportExcel3(bool isOpen)` | (또 다른 변형) |
| 6138 | `ExcelButtonWithoutCopy()` | MSG00100 (저장하지 않고 바로 열겠습니까?) 분기 후 ExportExcel3 |

### §3.3 Search Aux 4대 (Sort / Filter / Condition / ResetCondition)

| 라인 | 메서드 | virtual? | 내부 동작 | TO-BE 매핑 |
|---:|---|---|---|---|
| 5054 | `OnClickFilterButton()` | non-virtual | 선택 column 의 `AllowAutoFilter` toggle + dtFilterCol2/Val2 추적 + SmartColMerge 재적용 | TO-BE `FlexGridFilter` 자동 활성 (column header click) |
| 5237 | `OnClickConditionButton()` | non-virtual | `CheckCondition` → `SavePanelCondition` → FoxBizClient `Authentication.SaveSearchCondition` (사용자별 검색조건 저장) | **⚠️ TO-BE 미구현 = 격차** |
| 5245 | `OnClickResetConditionButton()` | non-virtual | MSG00397 → `ResetPanelCondition` → FoxBizClient `Authentication.ResetSearchCondition` | **⚠️ TO-BE 미구현 = 격차** |
| 5268 | `OnClickSortButton()` | non-virtual | IsEditMode → MSG00140 / 선택 column 의 `AllowAutoSort` toggle | TO-BE `allowSorting={true}` (DataGrid 자동) |

### §3.4 정렬 virtual hook (별도 호출 경로)

| 라인 | 시그니처 | default |
|---:|---|---|
| 5618 | `public virtual void SortAsc()` | (내부 spread sort) |
| 5646 | `public virtual void SortDesc()` | (내부 spread sort) |
| 5673 | `public virtual void SortNone()` | (sort indicator clear) |
| 5694 | `public virtual void FilterRemove()` | (필터 전체 제거) |

### §3.5 기타 virtual hook

| 라인 | 시그니처 | 호출 시점 |
|---:|---|---|
| 4010 | `protected virtual void CloseButton()` | `OnClickCloseButton` 에서 호출 / default `this.Close()` |
| 4015 | `protected virtual void HideButton()` | F11 (현재 disabled) |
| 4020 | `protected virtual void Closed(object, FormClosingEventArgs)` | FormClosing event 안 / 자식이 정리 처리 |
| 4030 | `protected virtual void HelpButton()` | F1 / pptx 다운로드 |
| 4138 | `protected virtual void AddHelpButton(string fileName)` | 화면 추가 도움말 |
| 5037 | `public virtual void VisiblePanel(bool bVisible)` | 조건 패널 표시/숨김 (현재 body 주석 처리) |
| 6005 | `public virtual void setPrgCancle()` | 진행 취소 hook |
| 6026 | `protected virtual void MenuEtcFileDownButton(string fileNm)` | 첨부 파일 다운로드 |
| 3022 | `public virtual void OnChildClick(object, CellClickEventArgs)` | spread 자식 cell click 위임 hook |
| 3026 | `public virtual void OnSpreadKeyDown(object, KeyEventArgs)` | spread KeyDown 위임 hook |

---

## §4 Form Lifecycle

### §4.1 호출 순서

```
new BaseForm() (696)
  → InitializeComponent() (Designer.cs)
  → IsFloating = false
→ (외부에서) InitForm() (702)
  → CreateToolButton 9 개 (Find/Edit/Insert/Delete/Save/Sort/Filter/Condition/ResetCondition/Excel/Help)
  → foreach (Controls) InitSpread (재귀)
  → DefineEvent (782) — FormClosed/FormClosing/Resize 핸들러
  → dtFilterCol2/Val2 컬럼 초기화
→ (Form show) OnShown(EventArgs) (798)
  → if IsPopup → InitPanel 만
  → else:
    → ViewModel null 가드
    → FoxDataClient → "MenuContainer.UP_FX_GetSearchCondition" → dsSearchCondition 로딩
    → foreach (Controls) CheckInitCondition → InitPanel (1093) — 검색조건 컨트롤 hash + i18n label 처리 + 저장된 값 restore
    → if FindWhenOpen → FindButton() 자동 호출
→ (사용자 작업)
→ FormClosing event (785)
  → ChildForm_FormClosing (967)
  → IsChange == true → MSG00013 (작업중 데이터 있음, 닫으시겠습니까?) → No 시 cancel
  → Closed(sender, e) virtual hook 호출
→ FormClosed event (785)
  → ChildForm_FormClosed (994)
  → FoxBizClient → "Authentication.SaveMenuConnect" (메뉴 닫기 로그, CnntCode=0104002)
  → foreach SpreadInfoList → SpreadInit() + RemoveSheet()
  → SpreadInfoList.Clear() + this.Controls.Clear() + GC.WaitForFullGCComplete()
```

### §4.2 InitForm (702-771) — Ribbon button 등록

```csharp
BarButtonGroup barButtonGroup = new BarButtonGroup();
CreateToolButton(barButtonGroup, "Find", "F5", Keys.F5, ...);
CreateToolButton(barButtonGroup, "Edit", "F2", Keys.F2, ...);
// ... 10 개 동일 패턴
BaseRibbonCtl.PageHeaderItemLinks.Add(barButtonGroup);
foreach (Control myCtl in this.Controls) InitSpread(myCtl);  // 재귀
DefineEvent();
```

### §4.3 InitPanel (1093-1862) — 검색조건 컨트롤 i18n + 저장값 restore

> **730+ lines 의 복잡한 분기**. 핵심 동작:

1. `UsrConditionPanel` 발견 → ConditionPanel size 조정 (`-5` height) + 접기/펴기 버튼 추가
2. 모든 `LayoutControlItem` 의 Text 를 `MessageHelper.GetTerm(label)` 로 다국어 처리
3. 컨트롤 type 별 (UsrCheckBox / UsrCheckedList / UsrCheckedList2 / UsrCheckedListBox / UsrCheckedListFilter / UsrColumnCombo / UsrCombo / UsrComboBox / UsrRadio / UsrTextBox / DevExpress.RadioGroup) 각각 `dsSearchCondition` 에서 저장된 값 restore
4. 필수 항목 (`label.EndsWith("*")`) 표시 처리

**중요 발견**: 화면 별 검색조건 컨트롤은 `UsrConditionPanel` 안의 `LayoutControlItem` 에 배치. 컨트롤 type 별 ControlValues / SelectedItem / SelectedValue / Checked / Text 접근 방식이 다름.

### §4.4 OnShown (798-849) — 검색조건 load + FindWhenOpen

```csharp
if (!IgnoreSearchCondition) {
    using (var client = new FoxDataClient("GSCM", "GSCM.BizService.WSL/FoxDataService.svc")) {
        var request = new FoxDataRequest("MenuContainer.UP_FX_GetSearchCondition");
        request.Parameters["GroupID"] = UserInfoContext.Current["NowGroupID"];
        request.Parameters["UserID"]  = UserInfoContext.Current["USER_ID"];
        request.Parameters["MenuID"]  = ViewModel.MenuId;
        var response = client.ExecuteDataSet(request);
        dsSearchCondition = response.DataSet;
    }
} else if (ManualSearchCondition != null) {
    dsSearchCondition = ManualSearchCondition;
}
foreach (Control myCtl in this.Controls) CheckInitCondition(myCtl);
IsInitOpen = false;
if (FindWhenOpen == true) FindButton();
```

**TO-BE 매핑**: 현재 TO-BE 는 검색조건 사용자별 저장/복원 미구현 (격차). 사용자가 매번 검색조건 재입력. AS-IS 사용 패턴 (자동 restore) 필요 시 신규 구현.

### §4.5 ChildForm_FormClosed (994-1076) — 정리 + 메뉴 close 로그

```csharp
// 메뉴 close 로그 기록
FoxBizClient client = new FoxBizClient("GSCM", "GSCM.BizService.WSL/FoxBizService.svc");
var request = new FoxBizRequest("Authentication", "SaveMenuConnect");
request.Parameters["MenuID"] = sMenuID;
request.Parameters["CnntCode"] = "0104002";  // Close (0104001 = Open)
request.Parameters["UserID"] = UserInfoContext.Current.UserId;
client.Execute(request);

// SpreadInfoList 정리
foreach (SpreadInfo spd in SpreadInfoList) {
    // dtFilterCol2/Val2 정리
    spd.SpreadInit();
    spd.RemoveSheet(spd.SheetName);
}
SpreadInfoList.Clear();
this.Controls.Clear();
GC.WaitForFullGCComplete();
```

**TO-BE 매핑**: 메뉴 open/close 로그 (Authentication.SaveMenuConnect) → TO-BE 의 `@SystemLog` annotation 또는 별도 SCM_SYS_LOG INSERT.

---

## §5 검색조건 저장/복원 (AS-IS 사용자별)

### §5.1 저장 (`SavePanelCondition` — F6)

| 라인 | 메서드 | 책임 |
|---:|---|---|
| 1966 | `SavePanelCondition(Control ctl)` | 컨트롤별 ControlValues / SelectedItem 추출 → lstSearchConditon 에 add |
| 1956 | `SetSearchCondition(controlName, controlValue)` | lstSearchConditon.Add |
| 2134-2169 | 저장 호출 | foreach lstSearchConditon → FoxBizClient `Authentication.SaveSearchCondition` (loop, 한 컨트롤씩) |
| 2168 | 성공 메시지 | MSG00155 (조회 조건이 저장되었습니다) |

### §5.2 복원 (`ResetPanelCondition` — F10)

| 라인 | 메서드 | 책임 |
|---:|---|---|
| 2180 | `ResetPanelCondition()` | FoxBizClient `Authentication.ResetSearchCondition` 호출 |
| 2204 | 성공 메시지 | MSG00398 (검색조건이 초기화 되었습니다) |
| 2208 | 실패 메시지 | MSG00399 (검색조건 초기화중 오류가 발생하였습니다) |

### §5.3 ⚠️ TO-BE 격차

| 항목 | AS-IS | TO-BE 현재 | 격차 해소 방안 |
|---|---|---|---|
| 사용자별 검색조건 저장 | F6 `OnClickConditionButton` → SaveSearchCondition SP | **없음** | (1) SCM_SYS_USR_SEARCH_COND_M 테이블 생성 (2) BE Controller 신규 (3) FE SubTitle 의 `condition` action 등록 |
| 사용자별 검색조건 복원 | F10 `OnClickResetConditionButton` → ResetSearchCondition SP | **없음** | 동일 |
| 화면 진입 시 자동 restore | OnShown 안에서 UP_FX_GetSearchCondition 호출 후 InitPanel 의 컨트롤별 restore | **없음** | 화면 entry hook (zustand store init) 에서 자동 fetch |

> **격차 결정 의무**: 사용자에게 (a) 격차 그대로 유지 (b) TO-BE 신규 구현 중 선택 받아야 함. 현재 TO-BE 룰셋은 (a) 가정 → 메모리 `feedback_search_aux_default_activation.md` 의 "UsrConditionPanel 없으면 condition/resetCondition false" 룰은 AS-IS 의 UsrConditionPanel 유무가 아니라 **사용자 결정 사항** 으로 갱신 필요.

---

## §6 Spread / Grid 관리

### §6.1 AddSheet overloads (5종)

| 라인 | 시그니처 | 책임 |
|---:|---|---|
| 3209 | `AddSheet(fpSpread, sheetName, tableName, iRow, iCol)` | 기본 sheet 추가 |
| 3245 | `AddSheet(..., bVisibleRowNumber)` | row 번호 표시 옵션 |
| 3271 | `AddSheet(..., iHeaderHeight)` | header height 지정 |
| 3278 | `AddSheet(..., iHeaderHeight, bVisibleRowNumber)` | (위 2 조합) — **return SpreadInfo** |
| 3296 | `AddSheet(..., bVisibleRowNumber, bIncludeChangeEvent)` | data model Changed event 자동 wire 옵션 |

### §6.2 SpreadInfo 관련 helper

| 라인 | 시그니처 | 책임 |
|---:|---|---|
| 3030 | `protected SpreadInfo GetSheetInfo(int iIndex)` | index 기반 |
| 3046 | `public SpreadInfo GetSheetInfo(sSpreadName, iIndex)` | spread+index |
| 3063 | `public SpreadInfo GetSheetInfo(sSpreadName, sSheetName)` | spread+sheet |
| 3083 | `protected SpreadInfo GetSheetInfo(sSheetName)` | sheet name |
| 3098 | `protected SpreadInfo GetSpread(sSpreadName)` | spread 인스턴스 |
| 2855 | `public void InitSpreadInfo()` | (별도 호출) |

### §6.3 FpSpread event wiring (`InitSpread`)

> `InitSpread` (line 2246-2356) 안에서 FpSpread 마다 다음 event 가 자동 연결:

| Event | Handler | line |
|---|---|---:|
| `CellClick` | `FpSpread_CellClick` | 2305 |
| `KeyDown` | `FpSpread_KeyDown` | 2306 |
| `SelectionChanged` | `FpSpread_SelectionChanged` | 2307 |
| `ColumnDragMoveCompleted` | `FpSpreadColumnDragMoveCompleted` | 2309 |
| `SubEditorOpening` | `FpSpread_SubEditorOpening` | 2310 |
| `SelectionChanged` | `BaseForm_SelectionChanged` | 2311 |
| `AutoSortedColumn` | `BaseForm_AutoSortedColumn` | 2312 |
| `AutoFilteredColumn` | `BaseForm_AutoFilteredColumn` | 2313 |
| `KeyUp` | `BaseForm_KeyUp` | 2314 |
| `TopChange` | `Fp_TopChange` (smart merge re-apply) | 1113 |
| `Resize` | `Fp_Resize` | 1115 |

또한 `InitSpread` 가 자동 설정:
- `EditModeReplace = true` (cell 진입 시 select 처리)
- `ButtonDrawMode.AlwaysPrimaryButton`
- `HorizontalScrollBarPolicy = AsNeeded`
- `TabStripPolicy = Never`
- `ClipboardPasteToFill = true`
- SCPSkin 적용 (`SCPSkin.skn`)
- `FocusRenderer = ExIndicator`
- Escape 키 차단 (`SpreadActions.None`)
- Ctrl+V → `ClipboardPasteAsStringSkipHidden`
- Ctrl+C → `ClipboardCopyAsStringSkipHidden`

### §6.4 SmartColMerge (특수)

- `smartMergeInfo` Dictionary 가 sheet 별 활성 상태 추적
- TopChange / AutoFiltered / AutoSorted / SplitterMoved / Resize / MouseWheel 시 자동 재적용 (CanModelChange=false 보호)
- `SpreadInfo.SmartColMerge()` (별도 클래스) 가 실제 머지 수행

### §6.5 TO-BE 매핑 (Spread → Wijmo FlexGrid)

| AS-IS | TO-BE |
|---|---|
| `AddSheet(fps, sheetName, tableName, iRow=1, iCol=N, headerH, rowVisible)` | `<DataGrid sheetName={...} itemsSource={...} staticColumns={...} />` |
| `SpreadInfoList` | (TO-BE 는 sheet 별 ref array 또는 단수) |
| `SmartColMerge` | `HierarchicalMergeManager` (룰 12 §11.6) |
| `BaseForm_AutoFilteredColumn` 의 dtFilterCol2/Val2 추적 | `FlexGridFilter` 자동 (DataGrid 내장) |
| `BaseForm_AutoSortedColumn` | `allowSorting={true}` (DataGrid 자동) |
| `FpSpread_CellClick` / `KeyDown` / `SubEditorOpening` | wijmo `cellEditEnded` / `dblClick` event |
| Ctrl+V/C clipboard | wijmo `clipboardPaste` / `clipboardCopy` (자동) |

---

## §7 권한 (Authentication / Authorization)

### §7.1 FormAuth enum (5395)

```csharp
public enum FormAuth { None, Disable, Inquiry, Update, All }
```

| 값 | 의미 |
|---|---|
| None | 초기 / 권한 미지정 |
| Disable | 모든 UI disable |
| Inquiry | 조회만 (F5 only) |
| Update | 조회 + 편집 (F2/F5/F7/F8/F9) |
| All | 전체 (F12 Excel 포함) |

### §7.2 SecurityContext (CreateSecurityContext, line 865)

```csharp
protected override FoxSecurityContext CreateSecurityContext() {
    using (var client = new FoxBizClient("GSCM", "GSCM.BizService.WSL/FoxBizService.svc")) {
        var request = new FoxBizRequest("Authentication", "GetSecurityACL");
        request.Parameters["groupId"] = UserInfoContext.Current["NowGroupID"];
        request.Parameters["userId"]  = this.UserInfo.UserId;
        request.Parameters["menuId"]  = this.ViewModel.MenuId;
        var response = client.Execute(request);
        string acl = (string)response.Result;
        return new SecurityContext(acl);
    }
}
```

→ `SecurityContext.CanSelect / CanInsert / CanUpdate / CanDelete / CanSave` boolean 으로 OnClickXxxButton 마다 권한 가드.

### §7.3 부서별 권한 (`SetDivisionAuthCheck`, line 5995)

```csharp
public void SetDivisionAuthCheck(UsrLayoutControl usrLayoutControl, bool bFlag = true) {
    if (bFlag) MessageHelper.GMessageBox("MSG00097");  // 권한을 가진 Division이 없습니다.
    usrLayoutControl.Enabled = false;
}
```

호출 패턴: 화면 안에서 `DataService.GetDMInnerTable("MyDivision", filter)` 결과 0 건이면 `SetDivisionAuthCheck(usrLayout1, true)`.

### §7.4 TO-BE 매핑

| AS-IS | TO-BE |
|---|---|
| `SecurityContext` (acl 문자열) | `SCM_ADM_USER_GR_MNU_MPG_M` (메뉴 권한 4비트) + `SCM_ADM_USER_GR_MNU_BTN_MPG_M` (버튼별) |
| `CanSelect / CanInsert / CanUpdate / CanDelete / CanSave` | TO-BE 권한 4 비트 → 각 버튼 enable/disable |
| `SetDivisionAuthCheck` | TO-BE 의 `SCM_ADM_USER_GR_UNIT_AUTH_MPG_M` (Division 권한). 조회조건 Division dropdown 이 권한있는 것만 표시 (BE filter) |
| `bEnable[]` | (TO-BE 는 SubTitle 의 `hotkeyConfig` 의 함수 = active / `false` = hidden / 생략 = default active) |
| `formauth` 4 단계 | TO-BE 는 메뉴/버튼 권한 조합으로 표현 (formauth 자체는 폐기) |

---

## §8 i18n / MessageHelper

### §8.1 호출 패턴 (BaseForm 안 사용 인스턴스 20+)

| MSG Code | 호출 위치 | 의미 |
|---|---|---|
| MSG00003 | InitForm catch (768), InitPanel catch (1860), SavePanelCondition catch (2176) | 일반 오류 (ex.Message 인자) |
| MSG00007 | CheckValidation (3944) | 선택한 Spread 가 없습니다 |
| MSG00008 | CheckValidation Insert (3950) | 수정모드가 아니므로 추가할 수 없습니다 |
| MSG00009 | CheckValidation Delete (3952) | 수정모드가 아니므로 삭제할 수 없습니다 |
| MSG00010 | CheckValidation Save (3954) | 수정모드가 아니므로 저장할 수 없습니다 |
| MSG00012 | FileDownLoad_AttcFile (6054) | (파일 다운로드 확인) |
| MSG00013 | FormClosing (979) | 작업중인 데이터가 있습니다. 이 화면을 닫으시겠습니까? |
| MSG00096 | OnClick* 권한 (3610/3671/3793/3831/3847) | 사용 권한이 없습니다 |
| MSG00097 | SetDivisionAuthCheck (6000) | 권한을 가진 Division이 없습니다 |
| MSG00100 | ExcelButtonWithoutCopy (6181) | 저장하지 않고 바로 열겠습니까? |
| MSG00115 | OnClickEditButton (3678) | Allow Group일 경우 수정모드로 변경할 수 없습니다 |
| MSG00127 | OnClickFindButton (3618) | 작업중인 데이터가 있습니다 조회 하시겠습니까? |
| MSG00132 | FileDownLoad_AttcFile (6107) | 파일이 존재하지 않습니다 |
| MSG00133 | OnClickSaveButton (3919) | 수정한 내용이 없습니다 |
| MSG00139 | OnClickEditButton (3685) | Sort 상태에서는 수정모드를 할 수 없습니다 |
| MSG00140 | OnClickSortButton (5274) | 수정모드에서는 Sort를 할 수 없습니다 |
| MSG00155 | SavePanelCondition (2168) | 조회 조건이 저장되었습니다 |
| MSG00162 | OnClickEditButton (3692) | Sort 후에는 조회 후 수정모드로 가능합니다 |
| MSG00397 | OnClickResetConditionButton (5249) | (검색조건 초기화 확인) |
| MSG00398 | ResetPanelCondition (2204) | 검색조건이 초기화 되었습니다 |
| MSG00399 | ResetPanelCondition (2208) | 검색조건 초기화중 오류가 발생하였습니다 |

### §8.2 GetTerm (term lookup)

- `MessageHelper.GetTerm(itemLabel)` — LayoutControlItem / UsrLabel / UsrButton / SimpleButton 의 텍스트 다국어 변환
- 필수 항목은 끝에 `*` 추가
- 사용 위치: InitPanel (1093-1862) 안 30+ 회

### §8.3 TO-BE 매핑

| AS-IS | TO-BE |
|---|---|
| `MessageHelper.GMessageBox(msgId, args)` | `setAlert(t(msgId, args))` / `setConfirm(t(msgId, args))` (`@shared/hooks`) |
| `MessageHelper.GetTerm(label)` | `t(label)` (`i18next` + `KO.json / EN.json / CN.json`) |
| MSG XML (`MessageInfo.xml`) | `nscm-fe/apps/web/public/locales/{ko,en,cn}/translation.json` (i18next) |

**MSG ID 매핑 의무**: 위 §8.1 의 23 개 MSG ID 가 모두 TO-BE `KO.json` 에 동등 코드로 존재해야 함 (Phase 4 검증).

---

## §9 로깅

### §9.1 SCM_SYS_LOG_BATCH (6112)

```csharp
protected void SCM_SYS_LOG_BATCH(
    String p_program_name,   // 프로그램 / FormName
    String p_log_type,       // "PARAM" / "SQL" / "ERROR" / "ONE"
    int p_log_count,         // 처리 건수
    String p_log_message,    // 메시지
    String p_description)    // 상세
{
    using (var client = new FoxDataClient("GSCM", "GSCM.BizService.WSL/FoxDataService.svc")) {
        var request = new FoxDataRequest("SCP.PR_SCM_SYS_LOG_BATCH");
        request.Parameters["p_program_name"] = p_program_name;
        request.Parameters["p_log_type"]     = p_log_type;
        request.Parameters["p_log_count"]    = p_log_count;
        request.Parameters["p_log_message"]  = p_log_message;
        request.Parameters["p_description"]  = p_description;
        request.Parameters["p_event_date"]   = DateTime.Now;
        client.ExecuteDataSet(request);
    }
}
```

### §9.2 SetSaveLog (5963) — 화면 실행 로그

```csharp
// menu / log_type / count / db_time / ui_time / user_id 6 인자
FoxDataRequest("MenuContainer.UP_FX_SaveMenuExecutionLog")
```

### §9.3 TO-BE 매핑

| AS-IS | TO-BE |
|---|---|
| `SCM_SYS_LOG_BATCH("ONE", count, message, desc)` | TO-BE `@SystemLog` annotation + traceId(ULID) + Logback MDC → `SCM_SYS_LOG` 테이블 |
| `SetSaveLog(FIND/SAVE)` | TO-BE `@SystemLog` 의 autoLog |
| `DataService.FP_Log2("SpeedUp", form, action, "start"/"end")` | (TO-BE 미구현. 성능 추적 격차) |

---

## §10 메뉴 / 화면 navigation

### §10.1 openSubMenu (6010, 6015)

```csharp
public void openSubMenu(string prgId) {  // 단순 호출
    Open_userMenu(prgId);
}

public void openSubMenu(string prgId, bool floating, bool IgnoreSearchCondition, DataSet msc) {  // ManualSearchCondition 전달
    Open_userMenu(prgId, floating, IgnoreSearchCondition, msc);
}

private void Open_userMenu(string prgId, ...) {
    ((DXRibbonForm)this.MdiParent).OpenUserMenu(prgId, ...);
}
```

### §10.2 MenuEtcFileDownButton (6026) — 첨부파일 다운로드

```csharp
protected virtual void MenuEtcFileDownButton(string fileNm) {
    string _addr = GAppSettings.GetHelpServer();
    string _port = GAppSettings.GetHelpPort();
    string _path = GAppSettings.GetHelpPath();
    FileDownLoad_AttcFile("http://" + _addr + ":" + _port + "/" + _path + "/" + fileNm, fileNm);
}
```

### §10.3 TO-BE 매핑

| AS-IS | TO-BE |
|---|---|
| `openSubMenu(prgId, msc)` | MDI 탭 시스템 (룰 15) — useNavigate + searchParams 전달 |
| `MenuEtcFileDownButton(fileNm)` | (TO-BE 는 별도 첨부 파일 다운로드 메커니즘 — Spring Boot resource controller) |

---

## §11 BaseForm 전체 method 인벤토리 (157 개)

> `grep -nE "^\s*(public|protected|internal|private)\s+(virtual|override|async|static)?\s*[\w<>]+\s+\w+\s*\("` 결과 (line:signature 매핑).

### §11.1 Public utility (50+)

| 라인 | 메서드 | 책임 (1줄) |
|---:|---|---|
| 302 | `SetDefaultFrozenColumn(name, setDefault)` | 기본 frozen column 지정 |
| 308 | `ApplyDefaultFrozenColumn()` | 기본 frozen 적용 |
| 546 | `SetManualCondition(ds, key, value)` (static) | manualCondition 에 값 설정 |
| 575 | `GetManualCondtion(ds, key)` (static) | manualCondition 에서 값 추출 |
| 600 | `CreateManualSearchCondtion()` (static) | 빈 manualCondition DataSet 생성 |
| 702 | `InitForm()` | Ribbon 버튼 + spread init |
| 2620 | `ApplyCategoryAsFilter(siMain)` | 카테고리 기반 필터 적용 |
| 2705 | `SetCategoryFilter(colName, measureId, measure)` | 컬럼별 카테고리 필터 등록 |
| 2726 | `GetColumnMergeDictionay()` | column merge 사전 반환 |
| 2855 | `InitSpreadInfo()` | (현재 비어 있음 추정) |
| 3209/3245/3271/3278/3296 | `AddSheet(...)` 5 overloads | sheet 추가 |
| 3383~3506 | `HideColumns / UnHideColumns / HideRows / UnHideRows / ZoomIn / ZoomOut / Zoom100 / FindData / MergeColumns / MergeRows / FindSheetData / Freeze` | spread 조작 utility |
| 3593~3937 | `OnClickXxxButton` 10 개 | F-key dispatcher |
| 5023 | `FilterAdd()` | (별도 필터 추가) |
| 5372 | `SetRows(al)` | rows arraylist 설정 |
| 5381 | `SetSearchCount(ds)` | status bar 조회 건수 |
| 5404~5597 | `SetOperationMode / SetBackColor / SetForeColor / SetHAlign / SetVAlign / Sorting` | spread 스타일 |
| 5618/5646/5673/5694 | `SortAsc / SortDesc / SortNone / FilterRemove` (virtual) | 정렬/필터 동작 |
| 5710~5751 | `AutoColumnWidth / AutoRowHeight / SetFont` | spread 레이아웃 |
| 5770~5818 | `BlockEdit / UndoAction / RedoAction / BlockTotal2MessageBox / SearchStartTime / SearchEndTime / UIEndTime` | misc utility |
| 5849 | `SetFilter()` | 저장된 필터 재적용 |
| 5995 | `SetDivisionAuthCheck(usrLayout, bFlag)` | 부서 권한 disable |
| 6005 | `setPrgCancle()` (virtual) | 진행 취소 hook |
| 6010/6015 | `openSubMenu(prgId, ...)` 2 overloads | 다른 화면 열기 |
| 6138 | `ExcelButtonWithoutCopy()` | Excel 바로 열기 |
| 6199~6302 | `SaveTopRow / RestoreTopRow / RestoreRowRow / ManualAutoFilter / SaveColumnWith / RestoreColumnWidth / SaveView / RestoreView` | 상태 저장/복원 |

### §11.2 Protected (override target / 자식 호출)

| 라인 | 메서드 |
|---:|---|
| 798 | `OnShown(EventArgs)` override |
| 865 | `CreateSecurityContext()` override |
| 940 | `ProcessCmdKey(ref Message, Keys)` override |
| 2361 | `CheckClipboardText()` |
| 2391 | `BaseForm_KeyUp(sender, KeyEventArgs)` |
| 3022/3026 | `OnChildClick / OnSpreadKeyDown` (virtual) |
| 3030/3083/3098 | `GetSheetInfo / GetSpread` overloads |
| 3114 | `defaultSheetDataModel_Changed(sender, SheetDataModelEventArgs)` |
| 3184 | `objSpread_ButtonClicked(sender, EditorNotifyEventArgs)` |
| 3358 | `FnControls(ctlList, sControlName)` (자식 검색) |
| 3989~4151 | `FindButton / SaveButton / EditButton / InsertButton / DeleteButton / CloseButton / HideButton / Closed / HelpButton / AddHelpButton / ExcelButton` (virtual hooks) |
| 4220/4478/4611/4850 | `ExportExcel / ExportExcel2 / ExportExcel(bool) / ExportExcel3(bool)` (virtual overloads) |
| 4592 | `SetColumnFooter(sv, columnHeaerStyle)` |
| 4978 | `fnControls(ctlList, sControlName)` |
| 5037 | `VisiblePanel(bVisible)` (virtual) |
| 6026 | `MenuEtcFileDownButton(fileNm)` (virtual) |
| 6112 | `SCM_SYS_LOG_BATCH(name, type, count, msg, desc)` |

### §11.3 Private (내부 only)

| 라인 | 메서드 | 책임 |
|---:|---|---|
| 426/449 | `onFrozMenu / onUnFrozMenu` | frozen column 컨텍스트 메뉴 |
| 782 | `DefineEvent` | FormClosed/Closing/Resize wire |
| 790 | `IsDesignMode` (static) | 디자인 모드 체크 |
| 856 | `CheckInitCondition(ctl)` | 검색조건 재귀 init |
| 885/902 | `CreateToolButton` 2 overloads | 툴버튼 생성 |
| 928 | `Bt_ItemClick(sender, ItemClickEventArgs)` | ribbon click → AssignShortCut |
| 934 | `TsBtn_Click(sender, EventArgs)` | toolstrip click → AssignShortCut |
| 946 | `AssignShortCut(Keys)` | F-key → OnClickXxxButton 분기 |
| 967/994/1078 | `ChildForm_FormClosing / FormClosed / Resize` | form 이벤트 |
| 1093 | `InitPanel(ctl)` | 검색조건 컨트롤 i18n + restore (730 lines) |
| 1864/1873/1878/1893/1906/1920/1934 | `Fp_Resize / UsrCtl_MouseWheel / Fp_MouseWheel / Fp_TopChange / SpScrollBar_Scroll / SpContainer_SplitterMoved / Ubutton_Click` | spread/scroll/splitter event |
| 1951/1956 | `GetSearchCondition(name) / SetSearchCondition(name, value)` | dsSearchCondition CRUD |
| 1966 | `SavePanelCondition(ctl)` | F6 의 패널 검색조건 저장 |
| 2180 | `ResetPanelCondition()` | F10 의 검색조건 초기화 |
| 2213/2223/2237 | `InitLable / InitButton / InitCheckBox` | 컨트롤 폰트/색상 |
| 2246 | `InitSpread(objSp)` | FpSpread 표준 설정 + event wire |
| 2415 | `BaseForm_AutoFilteredColumn(sender, AutoFilteredColumnEventArgs)` | 필터 변경 추적 (200+ lines) |
| 2733 | `BaseForm_AutoSortedColumn(sender, AutoSortedColumnEventArgs)` | 정렬 변경 추적 |
| 2743 | `BaseForm_SelectionChanged(sender, SelectionChangedEventArgs)` | merge 영역 자동 확장 |
| 2860/2945/2983/3004/3013 | `FpSpread_CellClick / KeyDown / SelectionChanged / ColumnDragMoveCompleted / SubEditorOpening` | spread event 내부 dispatcher |
| 3114 | `defaultSheetDataModel_Changed` | data model 변경 추적 |
| 3322/4942 | `FnControls / fnControls` (case-sensitive 중복) | 자식 컨트롤 재귀 검색 |
| 3939 | `CheckValidation(ButtonType)` | edit 모드 가드 |
| 3980 | `ActivateFullScreenMode(ribbon)` | F11 hook |
| 4043 | `FileDownLoad(url, fileName)` | help pptx 다운로드 |
| 5259 | `CheckCondition(ctl)` | F6 의 컨트롤 재귀 |
| 5952 | `SetTime()` | DB/UI 시간 status bar |
| 5963 | `SetSaveLog(logType)` | 화면 실행 로그 |
| 6020 | `Open_userMenu(prgId, ...)` | MDI 메뉴 열기 |
| 6040 | `FileDownLoad_AttcFile(url, fileName)` | 첨부파일 다운로드 |

---

## §12 신규 화면 작성 시 BaseForm 활용 cheatsheet

> 모든 도메인 화면이 BaseForm 상속 후 다음 패턴 따름:

### §12.1 minimal 필수 override (단순 조회 화면)

```csharp
public partial class DMF0XXX_Xxx : BaseForm {
    public DMF0XXX_Xxx() { InitializeComponent(); InitForm(); }
    
    protected override void FindButton() {
        // 1. 검색 파라미터 build
        var filter = new FilterDataSet();
        filter["P_DIVISION_ID"] = cboDivision.SelectedValue;
        filter["P_USER_ID"] = UserInfoContext.Current["USER_ID"];
        filter["_SAVE_AUTH"] = "Y";
        
        // 2. SP 호출 (sync 또는 async)
        DataSet ds = DataService.FP_ExecuteQuery2(...);  // 또는 FoxDataClient async
        
        // 3. spread 에 적용
        siMain.Query(ds);
        SetSearchCount(ds);
    }
}
```

### §12.2 full CRUD (CRUD 6대 모두 override)

- `FindButton` — 조회
- `InsertButton` — 신규 행 추가 (siMain.AddRow + SetBGColor 편집 가능 표시)
- `EditButton` — SwitchLock + LockRange/LockColumn 으로 row 단위 편집 활성
- `DeleteButton` — siMain.Rows.Remove + Action='D' 마킹
- `SaveButton` — fnValidation + SaveData_DataService (async)
- `ExcelButton` — `ExportExcel(0, true, true)` 또는 `ExportExcel3(false)`

### §12.3 화면 내 SP 호출 패턴

```csharp
// 동기
FilterDataSet filter = new FilterDataSet();
filter["DIVISION_ID"] = ...;
DataSet ds = DataService.FP_ExecuteQuery2("page", "batch", filter.ToDict(), "/WSL/.svc");

// 비동기 (Save 권장)
using (var client = new FoxDataClient("GSCM", "GSCM.DM.Master.WSL/FoxDataService.svc")) {
    var request = new FoxDataRequest("DM.DMF0XXX_SAVE_DATA");
    request.Parameters["..."] = ...;
    var response = await client.ExecuteDataSetAsync(request);
}
```

### §12.4 로깅 패턴

```csharp
// 화면 안 성능 추적 (Division 변경 등)
DataService.FP_Log2("SpeedUp", "DMF0XXX", "division_id_changed", "start");
// ... work ...
DataService.FP_Log2("SpeedUp", "DMF0XXX", "division_id_changed", "end");

// 저장 후 감사 로그
SCM_SYS_LOG_BATCH(this.Name, "ONE", saveCount, "Save Complete", $"User={UserInfoContext.Current.UserId}");
```

---

## §13 TO-BE 매핑 총괄

| AS-IS BaseForm 메커니즘 | TO-BE 등가물 | TO-BE 룰 위치 |
|---|---|---|
| F1~F12 dispatcher | `SubTitle.hotkeyConfig` (자동 hotkey 등록) | `_tobe/09_subtitle_hotkey.md` |
| `FindButton` virtual | `handleSearch` + `useTabProcQuery` refetch | `_tobe/03_main_component.md` |
| `InsertButton` virtual | `handleInsert` + `GridAction.addRow` | `_tobe/03_main_component.md` |
| `DeleteButton` virtual | `handleDelete` + `GridAction.removeRow(true)` | `_tobe/03_main_component.md` |
| `EditButton` virtual | (TO-BE 미사용. column meta `_inputEditType` 자동) | `_tobe/08_column_meta.md` |
| `SaveButton` virtual | `handleSave` + `useSaveWithValidation` + `useProcMutation` | `_tobe/03_main_component.md` |
| `ExcelButton` virtual | `SubTitle excelFileName` (자동 export) | `_tobe/09_subtitle_hotkey.md` |
| `OnClickFilterButton` (F4) | `FlexGridFilter` 자동 (DataGrid 내장) | `_tobe/07_datagrid.md` §filter |
| `OnClickSortButton` (F3) | `allowSorting={true}` | `_tobe/07_datagrid.md` §sort |
| `OnClickConditionButton` (F6) — 검색조건 저장 | **⚠️ 격차** (TO-BE 미구현) | `_mapping/asis_to_tobe.md` §격차 |
| `OnClickResetConditionButton` (F10) — 검색조건 초기화 | **⚠️ 격차** | 동일 |
| `SecurityContext.CanXxx` | 메뉴/버튼 권한 2 테이블 | `_tobe/11_be_controller_service.md` §권한 |
| `SetDivisionAuthCheck` | TO-BE BE Division dropdown filter (SCM_ADM_USER_GR_UNIT_AUTH_MPG_M) | 동일 |
| `MessageHelper.GMessageBox(msgId)` | `setAlert(t(msgId))` | `_tobe/14_error_handling.md` (Phase 4) |
| `MessageHelper.GetTerm(label)` | `t(labelId)` (i18next) | `_tobe/05_constants.md` §i18n |
| `dsSearchCondition` (사용자별) | **⚠️ 격차** (TO-BE 사용자별 검색조건 저장 미구현) | `_mapping/asis_to_tobe.md` |
| `AddSheet(fps, name, table, row, col)` | `<DataGrid sheetName={SHEETS.X} />` | `_tobe/07_datagrid.md` |
| `FpSpread_CellClick / KeyDown / SubEditorOpening` | wijmo `cellEditEnded / dblClick / click` | `_tobe/07_datagrid.md` §events |
| `IsChange` | `useEffect ([data])` + EditTracker | `_tobe/04_store.md` |
| `IsEditMode` | (column meta 자동) | `_tobe/08_column_meta.md` |
| `IsLock` | column meta `_inputEditType: 'O'` | 동일 |
| `LockColumn` / `LockRange` | column meta `_inputEditType: 'M'` (Masked) | 동일 |
| `SetBGColor` / `SetBGColor2` | `.wj-cell-editable` / `.wj-cell-non-editable` CSS (자동) | 동일 |
| `SetValue` Auto-Sync | wijmo `cellEditEnded` handler + `editTrackerRef.storeChange` | `_tobe/03_main_component.md` |
| `SmartColMerge` | `HierarchicalMergeManager` 또는 `mergedRanges` | `_tobe/07_datagrid.md` §merge |
| `BaseForm_AutoFilteredColumn` dtFilterCol2/Val2 | (TO-BE FlexGridFilter 자동, 사용자 저장 미구현) | 동일 |
| `SCM_SYS_LOG_BATCH` | `@SystemLog` annotation + Logback MDC | `_tobe/16_logging.md` (Phase 4) |
| `SetSaveLog` (UP_FX_SaveMenuExecutionLog) | (TO-BE 미구현 또는 access log filter 로 대체) | `_mapping/asis_to_tobe.md` |
| `openSubMenu(prgId, msc)` | MDI 탭 `useNavigate` + searchParams | `_tobe/13_routing_menu.md` |
| `FormAuth` enum (None/Disable/Inquiry/Update/All) | (폐기, 메뉴/버튼 권한 조합으로 대체) | `_mapping/asis_to_tobe.md` |
| `bEnable[]` | `hotkeyConfig.{xxx}: false` (숨김) | `_tobe/09_subtitle_hotkey.md` |
| FormClosing IsChange MSG00013 | (TO-BE 도 동등 confirm 필요) | `_tobe/14_error_handling.md` |
| FormClosed `SaveMenuConnect` 로그 | (TO-BE 메뉴 close 로그 = 별도) | `_mapping/asis_to_tobe.md` |

---

## §14 진행 / 보강 예정

- [ ] `ExportExcel` 4 overload 의 body 정밀 분석 (4220-4942, 700+ lines) — Excel export 패턴 추출
- [ ] `BaseForm_AutoFilteredColumn` (2415-2616) 의 dtFilterCol2/Val2 추적 로직 정밀 분석
- [ ] `BaseForm_SelectionChanged` (2743-2854) merge 자동 확장 로직
- [ ] `FpSpread_CellClick / KeyDown / SubEditorOpening` (2860-3021) 의 cell 이벤트 처리
- [ ] `defaultSheetDataModel_Changed` (3114-3183) — data model dirty 추적
- [ ] `objSpread_ButtonClicked` (3184-3208) — cellTypeButton 이벤트
- [ ] `AddSheet` 5 overloads (3209-3322) body 정밀 비교 (어떤 화면이 어떤 overload 사용)
- [ ] `BaseForm.Designer.cs` 분석 — base 컨트롤 (BaseRibbonCtl, statusStripBaseForm, pnlBaseForm, tsStatusLblBaseForm 등) 인벤토리

위 항목은 Phase 1 의 BaseForm 정밀 분석 v2 작업 (다음 세션) 의 우선 순위. 현재 v1 은 **CRUD/Aux dispatcher + 권한 + 로깅 + 검색조건 + spread 초기 설정** 까지 완료.

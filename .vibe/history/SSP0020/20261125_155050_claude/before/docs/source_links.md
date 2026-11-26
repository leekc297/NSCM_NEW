# SSP0020 소스 링크

기준 경로: `06.UIL\GSCM.SSP.Plan.UIL\`

## 1. 엔드포인트 호출 지점 (전수 5건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0020_Delegate.cs | FindData_Main | 268 | `SSP.SSP0020_GET_DELEGATE` 호출 (SP SSP0020_GET_DELEGATE) |
| SSP0020_Delegate.cs | SaveData | 507 | `SSP.SSP0020_SAVE_DELEGATE` 호출 (SP SSP0020_SAVE_DELEGATE) |
| SSP0020_Delegate.cs | UnSet | 657 | `SSP.SSP0020_SAVE_UNSET` 호출 (1번째) |
| SSP0020_Delegate.cs | UnSet | 715 | `SSP.SSP0020_SAVE_UNSET` 호출 (2번째) |
| SSP0020_Delegate.cs | UserName_Search | 781 | `SSP.UP_FX_GetSSPUserUseInfoList` 호출 |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0020_Delegate.Designer.cs | InitializeComponent | 298 | `this.chkAll.CheckStateChanged += chkAll_CheckStateChanged` |
| SSP0020_Delegate.cs | .ctor | 104 | `this.Load += Form_Load` |
| SSP0020_Delegate.cs | InitEvent | 224 | `btnDelegatee.Click += BtnDelegatee_Click` |
| SSP0020_Delegate.cs | InitEvent | 225 | `btnSave.Click += BtnSave_Click` |
| SSP0020_Delegate.cs | InitEvent | 226 | `btnUnSet.Click += BtnUnSet_Click` |
| SSP0020_Delegate.cs | InitEvent | 228 | `spdMain.SheetTabClick += SpdMain_SheetTabClick` |
| SSP0020_Delegate.cs | InitEvent | 229 | `spdMain.CellClick += SpdMain_CellClick` |

## 3. Grid / 시트

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0020_Delegate.cs | CreateSpread | 181 | AddSheet `Delegate` (SpdSheet.shtMain, 1,1,35) |
| SSP0020_Delegate.cs | CreateSpread | 182 | AddSheet `Delegated List` (SpdSheet.shtMainList, 1,1,35) |
| SSP0020_Delegate.cs | CreateSpread | 184~185 | GetSheetInfo / ChangeSheet `Delegate` |
| SSP0020_Delegate.cs | CreateSpread | 188~189 | GetSheetInfo / ChangeSheet `Delegated List` |
| SSP0020_Delegate.cs | InitSpread | 198~199 | InitSheet + `SetSheetHeaderColumn(spdInfo,1)` — Delegate |
| SSP0020_Delegate.cs | InitSpread | 206~207 | InitSheet + `SetSheetHeaderColumn(spdInfo,1)` — Delegated List |
| SSP0020_Delegate.cs | InitSpread | 216~218 | CHK CellType=chk / Value=false / Border=bevelbrdr |
| SSP0020_Delegate.cs | FindData_Main | 290~291 | `Tables[0].Rows.Count > 0` → ChangeSheet/ChangeActiveSheet Delegate |
| SSP0020_Delegate.cs | FindData_Main | 299~300 | `Tables[1].Rows.Count > 0 && isReLoad == false` → Delegated List |
| SSP0020_Delegate.cs | FindData_Main | 312~313 | `intActiveSheetIdx == 0` → Delegate 활성 |
| SSP0020_Delegate.cs | FindData_Main | 317~318 | 그 외 → Delegated List 활성 |
| SSP0020_Delegate.cs | SpdMain_CellClick | 859 / 863 | 헤더 CheckBox Value false / true 토글 |
| SSP0020_Delegate.Designer.cs | InitializeComponent | 667~670 | 컬럼 헤더 스타일(HorizontalAlignment.General, NoteIndicatorColor.Red, Parent=ColumnHeaderDefaultEnhanced, VerticalAlignment.General) |

## 4. 데이터 컬럼 사용

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0020_Delegate.cs | `<field:dtMyDivision>` | 52 | `UserInfoContext.Current` NowGroupID |
| SSP0020_Delegate.cs | InitControls | 137 | `c["CODE"]` |
| SSP0020_Delegate.cs | InitControls | 160 | `dtMyDivision.Rows[i]` CODE, NAME |
| SSP0020_Delegate.cs | InitControls | 168 | `txtDelegatee.Text = ""` |
| SSP0020_Delegate.cs | Validation_Check | 417~422 | DIVISION_ID, VALID, FROM_DATE, TO_DATE |
| SSP0020_Delegate.cs | Validation_Check | 431~437 | DIVISION_ID, VALID, USER_ID, FROM_DATE, TO_DATE |
| SSP0020_Delegate.cs | Validation_Check | 445~451 | DIVISION_ID, VALID, DELEGATEE_ID, FROM_DATE, TO_DATE |
| SSP0020_Delegate.cs | UserName_Search | 791 | UserID |
| SSP0020_Delegate.cs | UserName_Search | 793 | `txtDelegatee.Text = UserName` |
| SSP0020_Delegate.cs | UserName_Search | 795 | `txtDelegatee.Text = UserName_E` |
| SSP0020_Delegate.cs | UserPopup | 841 / 843 | `txtDelegatee.Text = item.UserName / item.UserName_E` |
| SSP0020_Delegate.cs | BtnSave_Click | 352 | `SaveData` 호출(프레임워크 해석 = PersonalSettingPopup.SaveData, **확인 필요**) |

## 5. 화면 속성

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0020_Delegate.Designer.cs | InitializeComponent | 701 | `this.Text = "Inventory Raw(Small)"` |

# AS-IS 화면 분석 템플릿 v2 — `{MENU_ID}_{ScreenName}`

> **사용 의무 (anti-simplification)**: 이 템플릿은 GSCM AS-IS 화면 (UIL `*.cs` + `*.Designer.cs`) 을 line-by-line 분석할 때 **13 category 100% 채움** 의무. 빈 항목은 `(N/A: <근거 line>)` 명시. 빈 칸 다수 = 즉시 재작업.
>
> **추출 원칙**:
> - .cs + .Designer.cs 처음 ~ 끝 모두 Read (block 단위 200~500 line)
> - 추측 금지. 모든 항목에 source line 인용 (`{filename}:{line}`)
> - 메서드 body 가 길면 핵심 5~10 line 인용 후 나머지 line 범위 명시
> - 빈도 1회 호출이라도 누락 금지 (1건 누락 = anti-simplification 위반)

---

## §0 메타 정보

| 항목 | 값 | 근거 |
|---|---|---|
| MENU_ID | DMF0XXX | (.cs 파일명) |
| Screen Name | (한글/영문 명) | .cs 클래스명 |
| 위치 | `GSCM/06.UIL/GSCM.{Domain}.UIL/...` | 절대 경로 |
| .cs lines | N | `wc -l` |
| .Designer.cs lines | N | `wc -l` |
| Base class | `BaseForm` / `DialogForm` / `DXRibbonForm` | `class X : BaseForm` |
| Sheet 개수 | N | `AddSheet(...)` 호출 카운트 |
| Grid 컨트롤 | `spdMain` / `spdSub` 등 | Designer instance 명 |
| 분석 일자 | YYYY-MM-DD | |
| 분석자 | (이름/세션 ID) | |

---

## §1 Layout (.Designer.cs)

> **모든 컨트롤 인벤토리 + 좌표/parent + 동적 생성 여부**

### §1.1 정적 컨트롤 인벤토리

| # | 컨트롤 명 | 타입 | parent | X | Y | W | H | 라벨/속성 | 동적 갱신 | line |
|---:|---|---|---|---:|---:|---:|---:|---|---|---:|
| 1 | cboDivision | UsrCombo | UsrLayoutControl1 | 56 | 12 | 174 | 20 | - | bound to MyDivision | Designer.cs:NN |
| 2 | clbTeam | UsrCheckedList | ... | ... | ... | ... | ... | multi-select | ... | ... |
| ... | | | | | | | | | | |

**누락 검증 명령**:
```bash
grep -cE "this\.(cbo|clb|btn|chk|lbl|txt|grd|spd|usr)\w+\s*=" {file}.Designer.cs
# = §1.1 행 수와 일치
```

### §1.2 Grid 컨트롤 상세

| Grid | 시트 수 | 헤더 행 수 | DefColumns 메서드 | line |
|---|---:|---:|---|---:|
| spdMain | 1 | 1 | `CreateSheetHeaderColumn(siMain, 1, dtTitle)` | .cs:NN |
| spdSub | 3 | 2 | `CreateSheetHeaderColumn(siSub, 2, dtTitle)` | .cs:NN |

### §1.3 컨트롤 panel 계층

```
Form (BaseForm)
├─ UsrLayoutControl1 (조건 패널)
│  ├─ cboDivision
│  ├─ clbTeam
│  └─ ...
├─ spdMain (Grid)
└─ spdSub (Detail Grid)
```

---

## §2 Screen Lifecycle (.cs)

> **Form_Load → InitForm → InitControls → CreateSpread → InitSpread → InitEvent → AfterDataBind**

### §2.1 호출 순서

| 단계 | 메서드 명 | 호출처 | 책임 | line |
|---:|---|---|---|---:|
| 1 | `Form_Load(...)` | base.Form_Load | combo 로드, sheet 추가 | .cs:NN |
| 2 | `InitForm()` | Form_Load | UI 초기 상태 | .cs:NN |
| 3 | `InitControls()` | InitForm | DataService.GetDMInnerTable 호출 | .cs:NN |
| 4 | `CreateSpread()` | InitForm | siMain/siSub.AddSheet | .cs:NN |
| 5 | `InitSpread(SpreadInfo si)` | CreateSpread | header column 정의 | .cs:NN |
| 6 | `InitEvent()` | InitForm | combo / spread event 연결 | .cs:NN |

### §2.2 lifecycle body deep-dive

#### Form_Load (.cs:NN-NN)
```csharp
// 핵심 라인 인용 (5~10줄)
protected override void Form_Load(...) {
    base.Form_Load(...);
    // ...
}
```

#### InitControls (.cs:NN-NN)
- combo 데이터 로드 순서: Division → Team → EndCustomer → SalesSite
- 호출 SP: `MyDivision`, `UserTeamByDivision`, `EndCustomerByDivision`, `UserSiteByEndCustomer`

#### CreateSpread (.cs:NN-NN)
- `siMain = AddSheet(spdMain, "Main", "Main", 1, 1, 30);`
- ...

---

## §3 CRUD 6대 override (BaseForm)

> **각각 explicit override 여부 + body 인용. default 사용 시 "default" 명시.**

### §3.1 FindButton

- **Override 여부**: `[O / X / default]`
- **위치**: .cs:NN-NN (NN lines)
- **body 핵심**:
```csharp
protected override void FindButton() {
    // 인용
}
```
- **호출 SP**: `DM.DMF0004_GET_DATA(p1, p2)`
- **사용 메서드**: `siMain.Query(ds)` / `FoxDataClient.GetData2Async`
- **권한 체크**: `if (formauth == FormAuth.None) { ... }`

### §3.2 InsertButton
(동일 양식)

### §3.3 EditButton
(동일 양식, `SwitchLock()` / `LockRange2()` 등 포함)

### §3.4 DeleteButton
(동일 양식)

### §3.5 SaveButton
- 저장 호출 SP, 저장 데이터 build 패턴 (Action flag / EditFlag 분류), 비동기 호출 (`async/await FoxDataClient`)
- **Validation 호출 순서**: §5 의 어느 validator 가 SaveButton 안에서 호출되는지 인용

### §3.6 ExcelButton
- `ExportExcel(int ignoreDepth, bool RemoveActionCell, bool RemoveInvisibleCell)` 호출 인자
- custom export 메서드 사용 시 별도 명시

---

## §4 Search Aux 4대 override (BaseForm default)

> **Sort / Filter / Condition / ResetCondition — override 없으면 BaseForm default 사용.**

| 메서드 | override 여부 | body 인용 / default | line |
|---|---|---|---:|
| `OnClickSortButton` | [O/X/default] | `base.SortAsc()` or custom | .cs:NN |
| `OnClickFilterButton` | [O/X/default] | `base.FilterRemove()` or custom | .cs:NN |
| `OnClickConditionButton` | [O/X/default] | `base.VisiblePanel(true)` or custom | .cs:NN |
| `OnClickResetConditionButton` | [O/X/default] | custom reset logic | .cs:NN |

**UsrConditionPanel 사용 여부**: [O/X] (없으면 Condition/ResetCondition default 의미 없음 = TO-BE `condition: false` 매핑)

---

## §5 Validation 인벤토리

> **모든 `MessageHelper.GMessageBox` + `ValidationHelper.*` + custom validator 호출 — 1건이라도 누락 금지.**

### §5.1 MessageHelper.GMessageBox 호출 전체

| # | Msg ID | 카테고리 | 호출 위치 | trigger | args | line |
|---:|---|---|---|---|---|---:|
| 1 | MSG00002 | 조회/입력 | InitForm 안 | required field 누락 | `{LBL_DIVISION}` | .cs:NN |
| 2 | MSG00004 | 조회 결과 | FindButton 안 | 조회 성공 후 | `{count}` | .cs:NN |
| 3 | MSG00060 | 저장 | SaveButton 안 | duplicate key | - | .cs:NN |
| 4 | MSG00091 | 저장 | fnValidation | bucket 100% 초과 | - | .cs:NN |
| 5 | MSG00096 | 권한 | FindButton 안 | 권한 없음 | - | .cs:NN |
| 6 | MSG00097 | 일반 | 여러 곳 | 일반 오류 | - | .cs:NN |
| 7 | MSG00130 | 시트 | siMain.Query | Sub 시트 의존 | - | .cs:NN |
| 8 | MSG00137 | 조회 결과 | FindButton 안 | 조회 0건 | - | .cs:NN |
| ... | | | | | | |

### §5.2 ValidationHelper / custom validator 호출

| 메서드 | 호출 위치 | 검증 내용 | line |
|---|---|---|---:|
| `fnValidation()` | SaveButton 직전 | 월합계 100% / 중복 키 / NULL 체크 | .cs:NN |
| ... | | | |

### §5.3 누락 검증 명령
```bash
grep -cE "MessageHelper\.GMessageBox|ValidationHelper\." {file}.cs
# = §5.1 + §5.2 행 수의 합
```

---

## §6 Event 인벤토리

> **Cell event / Combo event / Button event / DataModel.Changed — 1건이라도 누락 금지.**

### §6.1 Cell event (Spread)

| Grid | event | 메서드 | trigger 컬럼/조건 | body 요약 | line |
|---|---|---|---|---|---:|
| spdMain | CellDoubleClick | `spdMain_CellDoubleClick` | binding=PROJECT | popup 호출 | .cs:NN |
| spdMain | CellEditEnded | `spdMain_CellEditEnded` | binding=SOLDTO | 의존 cell 갱신 | .cs:NN |
| spdMain | ComboSelChange | `spdMain_ComboSelChange` | binding=DIVISION | sub combo refresh | .cs:NN |
| spdMain | EditChange | `spdMain_EditChange` | (전체) | EditFlag='U' 자동 set | .cs:NN |
| spdMain | TopChange | (default) | - | - | - |
| spdMain | LeaveCell | `spdMain_LeaveCell` | (전체) | validation | .cs:NN |
| spdSub | ActiveSheetChanging | `spdSub_ActiveSheetChanging` | (sheet 전환) | edit 상태 검증 | .cs:NN |
| spdMain | DataModel.Changed | `shtMainDataModel_Changed` | (전체) | row dirty 추적 | .cs:NN |

### §6.2 Combo event

| 컨트롤 | event | 메서드 | 책임 | line |
|---|---|---|---|---:|
| cboDivision | SelectedIndexChanged | `cboDivision_SelectedIndexChanged` | EndCustomer/SalesSite refresh | .cs:NN |
| ... | | | | |

### §6.3 Button event (CRUD/Aux 외 추가 버튼)

| 버튼 | event | 메서드 | 책임 | line |
|---|---|---|---|---:|
| btnApply | Click | `btnApply_Click` | bulk update | .cs:NN |
| ... | | | | |

### §6.4 CheckBox / Radio event

| 컨트롤 | event | 메서드 | 책임 | line |
|---|---|---|---|---:|
| chkDetail | CheckedChanged | `chkDetail_CheckedChanged` | detail grid 표시 토글 | .cs:NN |
| ... | | | | |

---

## §7 API / SP 호출 인벤토리

> **DataService.* / FoxDataClient.* / Data.Common / ProcedureHelper / SqlHelper — 전부.**

### §7.1 호출 인벤토리

| # | 메서드 | SP / lookup ID | 호출 위치 | parameter | 결과 처리 | line |
|---:|---|---|---|---|---|---:|
| 1 | `DataService.GetDMInnerTable` | MyDivision | InitControls | UserId | cboDivision DataSource | .cs:NN |
| 2 | `DataService.GetDMInnerTable` | UserTeamByDivision | cboDivision_SelChange | DivisionId | clbTeam DataSource | .cs:NN |
| 3 | `FoxDataClient.GetData2Async` | DM.DMF0004_GET_DATA | FindButton | FilterDataSet | siMain.Query(ds) | .cs:NN |
| 4 | `FoxDataClient.SaveData2Async` | DM.DMF0004_SAVE_DATA | SaveButton | FilterDataSet + change rows | record count msg | .cs:NN |
| 5 | `DataService.FP_Log2` | SpeedUp | cboDivision_SelChange | "DMF0004", "division_id_changed", "start"/"end" | - | .cs:NN |

### §7.2 FilterDataSet 의 `_SAVE_AUTH` / `_AUTH` 플래그 사용
- `filter["_SAVE_AUTH"] = "Y";` 위치 (.cs:NN)
- `filter["USER_ID"] = UserInfoContext.Current.UserId;` 위치 (.cs:NN)

### §7.3 SP body 위치 (cross-reference)
- AS-IS SP: `GSCM/04.WSL/.../{SP}.sql` 또는 MSSQL DB
- TO-BE 변환 SP: `_artifacts/` 또는 `To-be_v2_converted/`
- **변환 격차** (있으면): "param X 누락" 등

---

## §8 Expression / Auto-Sync 인벤토리

> **LockColumn / LockRange / SetValue / SetBGColor / 편집 가능 토글 — 전부.**

### §8.1 LockRange / LockColumn

| # | 메서드 | 시트 | row/col 범위 | 조건 | line |
|---:|---|---|---|---|---:|
| 1 | `LockRange2` | siMain | row=N, all cols | EditFlag != 'U' | .cs:NN |
| 2 | `LockColumn` | siMain | binding=PROJECT_CODE | CRUD_TYPE='I' false | .cs:NN |
| ... | | | | | |

### §8.2 SetBGColor / SetCellBackColor

| # | 메서드 | 시트 | row/col | 색상 | 조건 | line |
|---:|---|---|---|---|---|---:|
| 1 | `SetBGColor2` | siMain | edit row | LockColor (Gainsboro) | 잠긴 row | .cs:NN |
| 2 | `SetBGColor2` | siMain | edit row | UnLockColor (Pink) | 편집 가능 row | .cs:NN |
| ... | | | | | | |

### §8.3 SetValue / SetText Auto-Sync

| # | 메서드 | 변경 cell | 자동 갱신 cell | 조건 | line |
|---:|---|---|---|---|---:|
| 1 | `SetValue` | DIVISION_ID | TEAM_ID = null | division 변경 시 | .cs:NN |
| ... | | | | | |

### §8.4 cellTypeImage / cellTypeButton

| # | 시트 | col binding | image / 버튼 | trigger | line |
|---:|---|---|---|---|---:|
| 1 | siMain | PROJECT_CODE | `cellTypeImage` (popup icon) | dblClick → popup | .cs:NN |
| ... | | | | | |

---

## §9 Combo / Lookup 인벤토리

> **화면의 모든 dropdown / multi-select 데이터 source.**

### §9.1 정적 컨트롤 combo

| 컨트롤 | 데이터 소스 | 결과 컬럼 (CODE/NAME) | filter param | line |
|---|---|---|---|---:|
| cboDivision | `DataService.GetDMInnerTable("MyDivision", filter)` | CODE / NAME | UserId | .cs:NN |
| clbTeam | `DataService.GetDMInnerTable("UserTeamByDivision", filter)` | TEAM_ID / TEAM_NM | DivisionId | .cs:NN |
| ... | | | | |

### §9.2 Grid cell combo

| Grid / 시트 | binding | 데이터 소스 | filter param | 갱신 trigger | line |
|---|---|---|---|---|---:|
| siMain | PROJECT_TYPE | static DataTable | - | InitSpread | .cs:NN |
| siMain | SALES_SITE_ID | `SetCellTypeCombo` from dt | DivisionId | cboDivision_SelChange | .cs:NN |
| ... | | | | | |

### §9.3 TO-BE `SCM_ADM_CMBO_SQL_M` 매핑

| AS-IS lookup ID | TO-BE SQL_ID | 격차 |
|---|---|---|
| MyDivision | `MyDivision` | OK |
| UserTeamByDivision | `TeambyDivision` | naming 변경 |
| EndCustomerByDivision | `EndCustomerByDivisionDept` | naming 변경 |
| ScmSitebyEndCustomer40 | (미등록) | 신규 INSERT 필요 |
| ... | | |

---

## §10 Popup 호출 인벤토리

> **모든 `new XxxPopup()` + Form_Load 인자 + 콜백 데이터 처리 — 1건이라도 누락 금지.**

### §10.1 호출 인벤토리

| # | popup 클래스 | trigger 위치 | trigger 종류 | Form_Load 인자 | 콜백 데이터 처리 | line |
|---:|---|---|---|---|---|---:|
| 1 | `SCM0002_SoldtobyDivisionPopup` | spdMain_CellDoubleClick | cell dblClick (binding=SOLDTO) | (false, divisionId, soldTo) | SetValue SOLDTO_ID + 의존 cell | .cs:NN |
| 2 | `SCM0002_TeamPopup` | btnTeam_Click | button click | (false, divisionId) | SetValue TEAM_ID | .cs:NN |
| 3 | `DM0002_ItembyDivisionPopupEx` | spdSub_CellDoubleClick | cell dblClick (binding=ITEM) | (false, divisionId, projectCode, ...) | SetValue ITEM_CODE + ITEM_NM | .cs:NN |
| ... | | | | | | |

### §10.2 TO-BE 공용 modal 매핑

| AS-IS popup | TO-BE modal | 위치 | 격차 (검색조건/표시컬럼/이벤트 4축) |
|---|---|---|---|
| `SCM0002_ProjectbyDivisionPopupEx` | `ProjectByDivisionModal` | `@master/components` | 표시 컬럼 ProjectStatus 누락? |
| `DM0002_ItembyDivisionPopupEx` | `ItemByDivisionModal` | `@master/components` | OK |
| `SCM0002_TeamPopup` | `TeamModal` | `@master/components` | OK |
| `SCM0002_OwnerbyDivisionPopup` | `OwnerByDivisionModal` | `@master/components` | OK |
| `SCM0002_CustomerbyDivisionPopup` | `CustomerModal` | `@master/components` | OK |
| `SCM0002_StoragebyDivisionPopup` | `StorageLocationModal` | `@master/components` | OK |
| `SCM0002_CityPopup` / Region | `RegionModal` | `@master/components` | OK |
| `DM0002_TitleSetForm_Popup` | `ColumnSettingModal` | `@master/components` | OK |
| `SCM0002_SoldtobyDivisionPopup` | (없음) | - | **신규 공용 modal 후보** |
| ... | | | |

### §10.3 누락 검증
```bash
grep -cE "new\s+\w+Popup\s*\(" {file}.cs
# = §10.1 행 수와 일치
```

---

## §11 Dynamic Column 인벤토리

> **`SetSpreadColumn(DataTable dt)` / `GET_SPREAD_TITLE_DATE` / `AddNumColumn` / `ColumnHeaderSpan` 패턴.**

### §11.1 동적 column 생성 메서드

| 메서드 | 호출 위치 | source 데이터 | 생성 패턴 | line |
|---|---|---|---|---:|
| `SetSpreadColumn(dt)` | InitSpread (isChangeHeader=true) | `DM.DMF0020_GET_FUTURE_PRICE_COL_TITLE` 결과 | BASIS_START_DATE 기반 월 column 생성 | .cs:NN |
| `AddNumColumn` | SetSpreadColumn 안 | dt.Rows[i] | format = "#,##0.00" | .cs:NN |
| `ColumnHeaderSpan` | SetSpreadColumn 안 | 연도별 그룹 | 2~3 row header 머지 | .cs:NN |
| ... | | | | |

### §11.2 헤더 row 수 + 머지 패턴

```
Row 0: [Year]     [2025]                    [2026]
Row 1: [Quarter]  [Q1]      [Q2]            [Q1]
Row 2: [Month]    [1] [2] [3] [4] [5] [6]   [1] [2] [3]
```

### §11.3 TO-BE 매핑
- `_tobe/07_datagrid.md` § Dynamic Column (DMF0007 dateColumns 패턴) 참조
- 동적 column SP 동반 변환 의무 (메타 BLOCK 4 SCM_ADM_PROC_M 필요)

---

## §12 권한 적용 인벤토리

> **formauth / bEnable[] / SetDivisionAuthCheck / _SAVE_AUTH flag 사용 위치.**

### §12.1 권한 처리

| 패턴 | 위치 | 동작 | line |
|---|---|---|---:|
| `formauth = FormAuth.X` | InitForm | 화면 진입 권한 결정 | .cs:NN |
| `bEnable[N] = false` | InitForm | N 번째 버튼 disabled (0=Find/1=Insert/...) | .cs:NN |
| `SetDivisionAuthCheck(usrLayout, true)` | cboDivision_SelChange | 부서별 권한 체크 | .cs:NN |
| `filter["_SAVE_AUTH"] = "Y"` | InitControls | SP 권한 플래그 | .cs:NN |

### §12.2 TO-BE 매핑
- TO-BE 화면 진입 권한은 `SCM_ADM_USER_GR_MNU_MPG_M` (menu 권한) + `SCM_ADM_USER_GR_MNU_BTN_MPG_M` (버튼 권한) 의 2 테이블
- AS-IS `formauth` 4단계 (None/Disable/Inquiry/Update/All) → TO-BE 는 메뉴/버튼 권한 조합으로 표현
- **격차**: AS-IS 의 `SetDivisionAuthCheck` (부서별 grid row 권한) 은 TO-BE 의 어디서 처리되는지 확인 의무

---

## §13 로깅 / 감사 인벤토리

> **SCM_SYS_LOG_BATCH / FP_Log2 / 기타 로그 호출 위치.**

| # | 메서드 | 호출 위치 | 인자 | 용도 | line |
|---:|---|---|---|---|---:|
| 1 | `DataService.FP_Log2` | cboDivision_SelChange (시작) | "SpeedUp", "DMF0004", "division_id_changed", "start" | 성능 추적 | .cs:NN |
| 2 | `DataService.FP_Log2` | cboDivision_SelChange (종료) | "SpeedUp", "DMF0004", "division_id_changed", "end" | 성능 추적 | .cs:NN |
| 3 | `SCM_SYS_LOG_BATCH` | SaveButton 종료 | program / "ONE" / count / message / desc | 저장 감사 | .cs:NN |
| ... | | | | | |

### §13.1 TO-BE 매핑
- TO-BE 는 `@SystemLog` annotation + traceId(ULID) + Logback MDC → `SCM_SYS_LOG` 테이블
- AS-IS `FP_Log2 "SpeedUp"` 같은 성능 추적은 TO-BE 의 어디서 (없으면 격차)

---

## §14 화면 분석 완료 자기 점검

작성 종료 전 다음 grep cross-check **모두 통과**:

```bash
# (1) 모든 Designer.cs 컨트롤이 §1.1 에 있는지
test $(grep -cE "this\.(cbo|clb|btn|chk|lbl|txt|grd|spd|usr)\w+\s*=" {f}.Designer.cs) -eq $(awk '/^## §1\.1/,/^## §1\.2/' __analysis__.md | grep -c "^| [0-9]")

# (2) 모든 MessageHelper 호출이 §5.1 에 있는지
test $(grep -cE "MessageHelper\.GMessageBox" {f}.cs) -le $(awk '/^## §5\.1/,/^## §5\.2/' __analysis__.md | grep -c "MSG[0-9]")

# (3) 모든 popup 호출이 §10.1 에 있는지
test $(grep -cE "new\s+\w+Popup\s*\(" {f}.cs) -eq $(awk '/^## §10\.1/,/^## §10\.2/' __analysis__.md | grep -c "Popup")

# (4) 모든 DataService 호출이 §7.1 에 있는지
test $(grep -cE "DataService\.|FoxDataClient\." {f}.cs) -le $(awk '/^## §7\.1/,/^## §7\.2/' __analysis__.md | grep -c "DataService\|FoxDataClient")

# (5) 모든 LockRange/LockColumn 이 §8.1 에 있는지
test $(grep -cE "LockRange|LockColumn" {f}.cs) -le $(awk '/^## §8\.1/,/^## §8\.2/' __analysis__.md | grep -c "Lock")
```

**1건이라도 불일치 = 재작업.** anti-simplification 룰 위반 자체 분석.

---

## §15 TO-BE 매핑 종합 표 (선택, 신규 화면 생성 직전)

| AS-IS 요소 | TO-BE 매핑 | 위치 | 격차 |
|---|---|---|---|
| BaseForm.FindButton | `handleSearch` + `useTabProcQuery` refetch | `_tobe/03_main_component.md` | - |
| BaseForm.InsertButton | `handleInsert` + `GridAction.addRow` | `_tobe/03_main_component.md` | - |
| BaseForm.SaveButton | `handleSave` + `useSaveWithValidation` + `useProcMutation` | `_tobe/03_main_component.md` | - |
| BaseForm.ExcelButton | SubTitle `excelFileName` (자동) | `_tobe/09_subtitle_hotkey.md` | - |
| `MessageHelper.GMessageBox` | `setAlert` / `setConfirm` (`@shared/hooks`) + i18n MSG ID | `_tobe/14_error_handling.md` | i18n KO.json 신규 등록 의무 |
| Popup (`new XxxPopup()`) | Modal (state `open`) + `setSelectedValue` callback | `_tobe/10_popup_modal.md` | TO-BE 공용 modal 11종 우선 사용 |
| `DataService.GetDMInnerTable` | `useTabComboQueries(['SqlId'])` | `_tobe/06_search_area.md` | SQL_ID 인벤토리 의무 cross-check |
| `FoxDataClient.GetData2Async` | `useTabProcQuery({menuId, sheetName, tabId})` | `_tobe/03_main_component.md` | SCM_ADM_PROC_M 메타 등록 의무 |
| `LockColumn` / `LockRange` | column meta `_inputEditType` (S/O/M/IO/IM) | `_tobe/08_column_meta.md` | DataGrid wrapper 자동 처리 |
| Dynamic column (SetSpreadColumn) | `dynamicColumns` prop + DMF0007 패턴 | `_tobe/07_datagrid.md` § Dynamic | SP 동반 변환 필요 |

---

> **이 분석서 작성 완료 = 다음 단계 (TO-BE 화면 생성) 의 baseline.** §14 자기 점검 미통과 시 절대 다음 단계 진행 금지.

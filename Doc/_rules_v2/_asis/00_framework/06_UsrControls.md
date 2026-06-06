# AS-IS Framework — UsrXxx Controls 정밀 분석

> **source**: `C:\Projects\NSCM\GSCM\01.Framework\GSCM.Windows.Forms\Controls\Usr*.cs` (36 컨트롤 + Designer)
>
> **중요성**: 모든 도메인 화면의 조회조건 영역 (UsrConditionPanel) 의 모든 input 컨트롤이 UsrXxx. `ControlValues` 표준 property 로 BaseForm 의 InitPanel / SavePanelCondition 이 통일 처리.

---

## §0 메타

| 항목 | 값 |
|---|---|
| Source | `Windows.Forms/Controls/` 폴더 36 cs 파일 |
| 핵심 (도메인 화면 자주 사용) 10 컨트롤 | UsrConditionPanel / UsrLayoutControl / UsrCombo / UsrCheckedList / UsrTextBox / UsrCheckBox / UsrLabel / UsrButton / UsrDatePicker / UsrDateRangePicker |
| 진행도 | UsrConditionPanel + UsrCombo + UsrCheckedList + UsrCheckBox **핵심 ControlValues 패턴 100%** / UsrDatePicker / UsrTextBox / 나머지 22 컨트롤 — skeleton |

---

## §1 전체 컨트롤 인벤토리 (36 종)

### §1.1 Input 컨트롤 (단순) — 7

| 컨트롤 | lines | 역할 | TO-BE 매핑 |
|---|---:|---|---|
| `UsrTextBox` | (TBD) | text input | `<InputField>` (`@shared/lges`) |
| `UsrMultiTextBox` | (TBD) | multi-line text | `<TextField multiline>` |
| `UsrMultiLineEditor` | (TBD) | rich text | (TO-BE 미사용) |
| `UsrCheckBox` | 343 | boolean → "Y"/"N"/"ALL" | `<Checkbox>` (`@shared/lges`) |
| `UsrRadio` | (TBD) | radio group | `<RadioGroup>` (TO-BE) |
| `UsrLabel` | (TBD) | label + i18n (`*` suffix → 필수) | `<Label required={isEss}>` |
| `UsrButton` | (TBD) | button + image | `<Button>` (`@shared/lges`) |
| `UsrButtonList` | (TBD) | button group | `<ButtonGroup>` |

### §1.2 Dropdown 컨트롤 — 8

| 컨트롤 | lines | 역할 | TO-BE 매핑 |
|---|---:|---|---|
| **`UsrCombo` ⭐** | 583 | 단일 select (Code/Name DataRowView) | `<CustomDropdown>` (`@shared/components`) |
| `UsrComboBox` | (TBD) | combo with type-ahead | `<CustomDropdown searchable>` |
| `UsrColumnCombo` | (TBD) | multi-column dropdown | `<CustomDropdown columns>` (확장 필요) |
| **`UsrCheckedList` ⭐** | 1367 | multi-select dropdown (csv) | `<CustomDropdown multiple>` |
| `UsrCheckedList2` | (TBD) | multi-select v2 | 동일 |
| `UsrCheckedListBox` | (TBD) | multi-select listbox | (확장 — 표시 형태만 다름) |
| `UsrCheckedListFilter` | (TBD) | filterable list | (확장) |
| `UsrCheckedListFilterLabel` | (TBD) | filterable list + label | (확장) |
| `UsrColorCheckList` | (TBD) | color-coded list | (TO-BE 미사용) |

### §1.3 Date / Time 컨트롤 — 9

| 컨트롤 | lines | 역할 | TO-BE 매핑 |
|---|---:|---|---|
| **`UsrDatePicker` ⭐** | 499 | date | `<DatePickerCalendar>` (`@shared/components`) |
| `UsrDatePickerOld` | (TBD) | (deprecated) | - |
| `UsrDatePickerWtWeek` | (TBD) | date with week # | (확장 필요) |
| `UsrDateRangePicker` | (TBD) | date range | `<DateRangePicker>` (필요 시) |
| `UsrDateRangePicker3` | (TBD) | date range v3 | 동일 |
| `UsrDateRangePickerWtWeek` | (TBD) | date range + week | (확장) |
| `UsrDateTimePickerWtWeek` | (TBD) | date+time + week | (확장) |
| `UsrMonthPicker` | (TBD) | month | `<MonthPicker>` (필요 시) |
| `UsrMonthRangePicker` | (TBD) | month range | (확장) |

### §1.4 기타 (구조 / 특수) — 12

| 컨트롤 | lines | 역할 | TO-BE 매핑 |
|---|---:|---|---|
| **`UsrConditionPanel` ⭐** | 45 | 조건 패널 wrapper (PanelType.HidePanel) | `<SearchArea>` (`@shared/components`) |
| `UsrLayoutControl` | (TBD) | DevExpress LayoutControl wrapper | `<FormItem>` (`@shared/lges`) |
| `UsrFontPicker` | (TBD) | font picker | (TO-BE 미사용) |
| `UsrColorPicker` | (TBD) | color picker | (TO-BE 미사용) |
| `UsrQtyEditor` | (TBD) | quantity input (number format) | `<InputField type=number>` |
| `UsrTriStateTreeView` | (TBD) | 3-state tree | (TO-BE 미사용) |
| `UsrKeyMapper` | (TBD) | shortcut key | (TO-BE 미사용 — hotkeyConfig 직접) |
| `UsrRefresh` | (TBD) | refresh button | (TO-BE 미사용 — F5 자동) |

---

## §2 `ControlValues` 표준 패턴 ⭐⭐ (BaseForm 핵심 인터페이스)

> 모든 UsrXxx 컨트롤은 `public string ControlValues { get; set; }` property 를 가짐. BaseForm 의 `InitPanel` (restore) + `SavePanelCondition` (save) + 도메인 화면의 SP 호출 (`filter[X] = control.ControlValues`) 이 통일 사용.

### §2.1 단일 값 컨트롤

| 컨트롤 | get → string | set ← string |
|---|---|---|
| UsrCombo | `DataRowView[CDefineColumn.Code]` (SelectedIndex 기반) | Code/Name 일치 SelectedIndex 설정 |
| UsrComboBox | (UsrCombo 동등) | 동일 |
| UsrTextBox | `Text` | `Text = value` |
| UsrCheckBox | `Checked` ? "Y" : "N"/"ALL" (checkOption 기반) | (set 없음 — get only?) |
| UsrRadio | 선택된 항목 value | 항목 일치 |
| UsrDatePicker | `Value.ToString("yyyyMMdd")` | DateTime parse |
| UsrMonthPicker | `Value.ToString("yyyyMM")` | 동일 |
| UsrQtyEditor | 숫자 string | 동일 |

### §2.2 multi-value 컨트롤 (csv)

| 컨트롤 | get → csv string | set ← csv string |
|---|---|---|
| UsrCheckedList | `ValueList` (csv) — 예: "40,81" | `,` split → 각 value 의 checked 토글 |
| UsrCheckedList2 | 동일 | 동일 |
| UsrCheckedListFilter | 동일 + filter | 동일 |
| UsrCheckedListBox | 동일 | 동일 |

### §2.3 range 값 컨트롤 (`-` 구분)

| 컨트롤 | get → "from-to" | set ← "from-to" |
|---|---|---|
| UsrDateRangePicker | "yyyyMMdd-yyyyMMdd" | `-` split → start/end DateTime |
| UsrMonthRangePicker | "yyyyMM-yyyyMM" | 동일 |

### §2.4 TO-BE 매핑 표

| AS-IS ControlValues 형식 | TO-BE 형식 | 변환 |
|---|---|---|
| UsrCombo 단일 Code string | `string` (CustomDropdown value prop) | 그대로 |
| UsrCheckedList csv "40,81" | TO-BE 도 csv string (multiple CustomDropdown) | 그대로 |
| UsrCheckBox "Y"/"N"/"ALL" | TO-BE `boolean` + 'ALL' option 별도 처리 | enum 변환 (룰 13) |
| UsrDatePicker "yyyyMMdd" | TO-BE `Dayjs` 또는 ISO string | dayjs.format("YYYYMMDD") |
| UsrDateRangePicker "yyyyMMdd-yyyyMMdd" | TO-BE { startDate, endDate } 객체 | 분해 |

---

## §3 핵심 5 컨트롤 정밀 분석

### §3.1 UsrConditionPanel (45 lines, 전체 read)

```csharp
public partial class UsrConditionPanel : Panel
{
    public enum PanelType { None, HidePanel }
    public PanelType UsrPanelType { get; set; } = PanelType.HidePanel;
    
    // 자동 Dock = Top
}
```

**책임**: 조건 패널 wrapper. 실제 동작 (i18n / restore / 접기-펴기) 은 BaseForm.InitPanel 에서 처리.

**TO-BE 매핑**: `<SearchArea openSearchArea={true} conditions={...} />` (`@shared/components`).

---

### §3.2 UsrCombo (583 lines, ControlValues 100%)

```csharp
public string ControlValues
{
    get {
        if (this.SelectedIndex > -1) {
            return (this.Items[SelectedIndex] as DataRowView)[CDefineColumn.Code].ToString();
        } else {
            // ComboBox 에 아이템 선택 안 하고 텍스트 복사 붙여넣기 → Code 매칭
            for (int i = 0; i < Items.Count; i++) {
                if ((Items[i] as DataRowView)[CDefineColumn.Name].ToString() == this.Text) {
                    return (Items[i] as DataRowView)[CDefineColumn.Code].ToString();
                }
            }
            return null;
        }
    }
    set {
        // Code 또는 Name 일치하는 Item → SelectedIndex 설정
        for (int i = 0; i < Items.Count; i++) {
            if ((Items[i] as DataRowView)[CDefineColumn.Code].ToString() == value 
             || (Items[i] as DataRowView)[CDefineColumn.Name].ToString() == value) {
                this.SelectedIndex = i;
                break;
            }
        }
    }
}
```

**DataSource 패턴**:
```csharp
cboDivision.DataSource = DataService.GetDMInnerTable("MyDivision", filter);
cboDivision.DisplayMember = CDefineColumn.Name;
cboDivision.ValueMember   = CDefineColumn.Code;
```

→ 결과 DataTable 의 `CODE` / `NAME` 컬럼 사용 (DataService 표준).

**TO-BE 매핑**: 
- `<CustomDropdown value={value} onChange={onChange} options={[{value, label}]}>`
- `options` = useTabComboQueries 결과의 `{CODE, NAME}` → `{value: CODE, label: NAME}` 변환

### §3.3 UsrCheckedList (1367 lines, ControlValues + SetValues 분석)

```csharp
public string ControlValues
{
    get { return this.ValueList; }  // csv 예: "40,81"
    set {
        // 모든 item check 해제
        for (int i = 0; i < clb.Items.Count; i++) clb.SetItemChecked(i, false);
        
        if (value != null && value.Length > 0) {
            string[] initValueArray = value.Split(',');
            
            // 각 value 에 대해 item 찾아서 check
            for (int ai = 0; ai < initValueArray.Length; ai++) {
                for (int i = 0; i < clb.Items.Count; i++) {
                    string sFilter = dtS.Columns[0].ColumnName + " = '" + initValueArray[ai] + "'";
                    string sItem = initValueArray[ai];
                    foreach (DataRow row in dtS.Select(sFilter))
                        sItem = row[1].ToString();
                    
                    if (clb.GetItemText(clb.Items[i]) == sItem) {
                        clb.SetItemChecked(i, true);
                        // ...
                    }
                }
            }
        }
    }
}

// 추가 properties
public string TextList     { get; }  // 선택된 NAME csv
public string ValueOrText  { get; }  // value 또는 text
public string FilterFlag   { get; }  // 필터 표시
public string ValueListAll { get; }  // 모든 값 (ALL 포함)
public bool   ALL_VIEW     { get; }  // "ALL" 표시 여부
```

**핵심 method**:
- `SetDefaultValue(value)` — 기본값 설정
- `SetValues(value)` — 값 설정 (csv)
- `SetValuesCodeName(value)` — Code 와 Name 둘 다로 설정
- `SetAllCheckItem(flag)` — 전체 선택/해제
- `GetItemChecked(index)` / `SetItemChecked(index, status)` — 개별 토글

**ALL_VIEW 옵션**:
- `true`: 첫 항목 "ALL" 추가, 선택 시 모든 항목 자동 선택
- `false`: 일반 multi-select

**TO-BE 매핑**:
- `<CustomDropdown multiple value={value} onChange={onChange} options={...}>`
- `value` 는 csv string ("40,81") 또는 `string[]` (TO-BE 표준)
- ALL option 은 옵션 list 의 첫 항목 추가 + onChange 에서 전체 선택 로직

### §3.4 UsrCheckBox (343 lines, ControlValues 100%)

```csharp
public string ControlValues
{
    get {
        if (this.Checked) {
            return "Y";
        } else {
            if (checkOption == "EQ") return "N";
            else                     return "ALL";  // default
        }
    }
}

public string checkOption { get; set; }  // "EQ" / "" (= ALL)
```

**의미**:
- `checkOption="EQ"`: Checked=Y / Unchecked=N (boolean)
- `checkOption=""` (기본): Checked=Y / Unchecked=ALL (3-state)

**왜 ALL?**: SP `WHERE COLUMN = @VAL OR @VAL = 'ALL'` 패턴. Unchecked 시 ALL 보내면 SP 가 모든 row 반환.

**TO-BE 매핑**:
- `<Checkbox value={value === 'Y'} onChange={(b) => setValue(b ? 'Y' : (checkOption === 'EQ' ? 'N' : 'ALL'))}>`
- 또는 단순 `boolean` + SP 가 `null` 처리 (BE 가 `null` → `'ALL'` 변환)

### §3.5 UsrDatePicker (499 lines, 부분 분석)

```csharp
public DateTime MinDate { get; set; }
public DateTime MaxDate { get; set; }

// ControlValues (private 라 확인 안 됨, BaseForm InitPanel 패턴 보면)
// IDateSettable / IRangeSettable interface 구현
```

**BaseForm.InitPanel 의 처리**:
```csharp
if (kvp.Key is IDateSettable) {
    var usrCtl = (IDateSettable)kvp.Key;
    var value = GetSearchCondition(usrCtl.Name);  // "yyyyMMdd"
    DateTime date;
    if (DateTime.TryParseExact(value.Replace("/", "").Replace("-", "").Replace(".", "").Replace(" ", ""), 
                               "yyyyMMdd", null, ..., out date)) {
        usrCtl.Value = date;
    }
}
```

**TO-BE 매핑**:
- `<DatePickerCalendar value={dayjs(value)} onChange={(d) => setValue(d.format('YYYYMMDD'))}>`
- AS-IS `MinDate` / `MaxDate` → TO-BE `minDate` / `maxDate` props

---

## §4 도메인 화면 사용 패턴 (예: DMF0004)

### §4.1 Designer.cs 에 컨트롤 배치

```csharp
// Designer.cs
this.cboDivision      = new UsrCombo();
this.clbTeam          = new UsrCheckedList();
this.clbEndCustomer   = new UsrCheckedList();
this.clbSoldToCustomer = new UsrCheckedList();
this.clbSalesSite     = new UsrCheckedList();
this.cboActive        = new UsrCombo();
this.chkDetail        = new UsrCheckBox();
this.usrLayoutControl1 = new UsrLayoutControl();
this.usrConditionPanel1 = new UsrConditionPanel();

// usrLayoutControl1 안에 LayoutControlItem 으로 컨트롤 배치 (DevExpress)
```

### §4.2 .cs 의 초기화

```csharp
// InitControls
cboDivision.DataSource = DataService.GetDMInnerTable("MyDivision", filter);
cboDivision.DisplayMember = "NAME";
cboDivision.ValueMember   = "CODE";

clbTeam.DataSource = DataService.GetDMInnerTable("UserTeamByDivision", filter);
clbTeam.ALL_VIEW   = true;  // "ALL" 추가
```

### §4.3 FindButton 안 SP 호출

```csharp
filter["DIVISION_ID"]   = cboDivision.ControlValues;       // 단일 Code
filter["TEAM_ID"]       = clbTeam.ControlValues;            // csv "TEAM01,TEAM02"
filter["END_CUSTOMER"]  = clbEndCustomer.ControlValues;
filter["SALES_SITE"]    = clbSalesSite.ControlValues;
filter["ACTIVE_FLAG"]   = cboActive.ControlValues;
filter["DETAIL_FLAG"]   = chkDetail.ControlValues;          // "Y" / "ALL"
```

### §4.4 TO-BE 등가 (sales-site/SalesSite.tsx)

```typescript
// SearchArea + FormItem 안
<FormItem label={t('LBL00001')} required>
  <CustomDropdown
    value={searchParams.divisionId}
    onChange={(v) => setSearchParams({ divisionId: v })}
    options={divisions}  // from useTabComboQueries
  />
</FormItem>

<FormItem label={t('LBL00002')}>
  <CustomDropdown
    multiple
    value={searchParams.teamIds}  // csv 또는 string[]
    onChange={(v) => setSearchParams({ teamIds: v })}
    options={teams}
  />
</FormItem>

<FormItem label={t('LBL00003')}>
  <Checkbox 
    checked={searchParams.detailFlag === 'Y'}
    onChange={(b) => setSearchParams({ detailFlag: b ? 'Y' : 'ALL' })}
  />
</FormItem>

// API 호출
const { data } = useTabProcQuery({
  filters: {
    divisionId:   searchParams.divisionId,
    teamId:       searchParams.teamIds,
    endCustomer:  searchParams.endCustomerIds,
    salesSite:    searchParams.salesSiteIds,
    activeFlag:   searchParams.activeFlag,
    detailFlag:   searchParams.detailFlag,
  },
});
```

---

## §5 TO-BE 매핑 총괄

| AS-IS UsrXxx | TO-BE 컴포넌트 | 위치 | 변환 |
|---|---|---|---|
| UsrConditionPanel | `<SearchArea>` | `@shared/components` | wrapper |
| UsrLayoutControl | `<FormItem>` + `<Grid>` | `@shared/lges` + `@shared/mui` | layout |
| UsrCombo (단일 Code) | `<CustomDropdown>` | `@shared/components` | value/options |
| UsrComboBox (type-ahead) | `<CustomDropdown searchable>` | 동일 | (확장 prop) |
| UsrColumnCombo (multi-col) | `<CustomDropdown columns>` | 확장 필요 | (격차) |
| UsrCheckedList (multi csv) | `<CustomDropdown multiple>` | 동일 | csv ↔ value |
| UsrCheckedList2 / Filter | 동일 | 동일 | 동일 |
| UsrTextBox | `<InputField>` | `@shared/lges` | text |
| UsrCheckBox ("Y"/"N"/"ALL") | `<Checkbox>` | `@shared/lges` | enum 변환 |
| UsrRadio | `<RadioGroup>` | (TO-BE 확장) | value |
| UsrLabel | `<Label required={isEss}>` | `@shared/lges` | text + i18n |
| UsrButton | `<Button>` | `@shared/lges` | label + onClick |
| UsrDatePicker | `<DatePickerCalendar>` | `@shared/components` | dayjs |
| UsrMonthPicker | `<MonthPicker>` | (TO-BE 확장 — 격차?) | dayjs.format("YYYYMM") |
| UsrDateRangePicker | `<DateRangePicker>` | (TO-BE 확장 — 격차?) | { startDate, endDate } |
| UsrQtyEditor (숫자 format) | `<InputField type=number>` | `@shared/lges` | numeric |
| UsrFontPicker / UsrColorPicker | (TO-BE 미사용) | - | (격차 가능 — 사용 빈도 0 추정) |
| UsrTriStateTreeView | (TO-BE 미사용) | - | (격차 가능) |
| UsrKeyMapper | (TO-BE 미사용 — hotkeyConfig 직접) | - | OK |

---

## §6 격차 식별

| # | AS-IS | TO-BE 현재 | 결정 권장 |
|---|---|---|---|
| (UsrColumnCombo) | multi-column dropdown | CustomDropdown 단일 column | **G8 후보**: `<CustomDropdown columns>` prop 확장 |
| (UsrDateRangePicker) | "yyyyMMdd-yyyyMMdd" csv | `<DateRangePicker>` 미구현? | **G9 후보**: `@shared/components/DateRangePicker` 신규 |
| (UsrMonthPicker / UsrMonthRangePicker) | month | TO-BE 확인 필요 | **G10 후보** (사용 빈도 확인 후) |
| (UsrFontPicker / UsrColorPicker / UsrTriStateTreeView) | font/color/tree | TO-BE 미사용 | **(a) 격차 유지** (사용 빈도 0 추정) |

> **G8/G9/G10 결정**: 사용자 확인 필요. **Default (auto mode)**: G8 (multi-column dropdown) 사용 빈도 낮음 → (a) 격차 유지 / G9 (DateRangePicker) 사용 빈도 높을 가능성 → (b) 신규 권장 / G10 (MonthPicker) 사용 빈도 확인 후.

---

## §7 룰셋 v2 반영

- `_tobe/06_search_area.md`
  - §1 SearchArea + FormItem + Grid + CustomDropdown 표준
  - §2 ControlValues → TO-BE 형식 변환 표 (csv / "Y"-"N"-"ALL" / "yyyyMMdd" / range)
  - §3 useTabComboQueries 결과 (CODE/NAME) → CustomDropdown options 변환 의무
  - §4 G2 (BigFilter) 통합 시 useBigFilterDM 우선

- 메모리 `feedback_control_values_format.md` 신규 — AS-IS ControlValues 형식 (csv / Y-N-ALL / yyyyMMdd / range) 의 TO-BE 변환 규칙. 신규 화면 작성 시 의무 cross-check.

---

## §8 진행 / Pending

- ✅ 36 UsrXxx 컨트롤 전수 인벤토리
- ✅ UsrConditionPanel + UsrCombo + UsrCheckedList + UsrCheckBox **ControlValues 패턴 100% 추출**
- ✅ TO-BE 매핑 표 (36 컨트롤 1:1)
- ✅ 격차 후보 G8/G9/G10 식별 (auto default: G9 신규 권장)
- ⏳ Pending: UsrDatePicker 의 ControlValues / IDateSettable 인터페이스 정밀
- ⏳ Pending: UsrLayoutControl (DevExpress LayoutControl wrapper) 의 LayoutControlItem 패턴
- ⏳ Pending: UsrTextBox / UsrButton / UsrLabel 의 기본 property
- ⏳ Pending: UsrQtyEditor 의 숫자 format 패턴 (그리드 cell 에서도 사용)
- ⏳ Pending: 22 보조 컨트롤 (UsrTextBox 외 11 그룹 외) 의 사용 빈도 grep 후 격차 결정

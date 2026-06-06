# TO-BE 룰 06 — SearchArea / Form / 조회조건

> **추출 reference**: DMF0006 (modal cell 단순) / DMF0004 (extraConditions / Checkbox) / DMF0007 (required + userId 자동 + limitTags)

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | 06 |
| 토픽 | SearchArea + Form + useTabComboQueries + Modal cell |
| 적용 trigger | 조회조건 영역 작성 |
| 관련 hook | `pre-write.md`, AS-IS UsrControls 매핑 |

---

## §1 표준 구조 (의무) — Form sub-component

> reference: `CustomerModelMappingForm.tsx` (287 lines, 표준)

### §1.1 구조 5 단계

```typescript
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { ProjectByDivisionModal, ItemByDivisionModal } from '../../../components';
import { use{Name}Store } from '../use{Name}Store';
import styles from './{Name}Form.module.scss';

export const {Name}Form = () => {
  const { t } = useTranslation();
  
  // [1] Store selector
  const searchParams = useStore(state => state.searchParams);
  const setSearchParams = useStore(state => state.setSearchParams);
  const setFilters = useStore(state => state.setFilters);
  const isOpenSearchArea = useStore(state => state.isOpenSearchArea);
  
  // [2] Modal state (필요 시)
  const [openPrjByDivisionModal, setOpenPrjByDivisionModal] = useState(false);
  const [openItemByDivisionModal, setOpenItemByDivisionModal] = useState(false);
  
  // [3] useTabComboQueries (필요한 lookup list)
  const [myDivision, teambyDivision, endCustomer, salesSite, yesOrNo] = useTabComboQueries({
    filters: ['MyDivision', 'TeambyDivision', 'EndCustomer', 'SalesSite', 'YesOrNo'],
  });
  
  // [4] JSX: SearchArea + FormItem grid
  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        onSearch={setFilters}
        isHidden={!isOpenSearchArea}
        conditions={
          <>
            <Grid size={3}>
              <FormItem label={t('LBL00001', '_Div.')} labelAlign='right' required render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={myDivision?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => setSearchParams({ divisionId: option })}
                />
              )} />
            </Grid>
            {/* ... 더 많은 FormItem */}
          </>
        }
        extraConditions={
          <Grid size={3}>
            <FormItem label={t('LBL00007', '_Active')} render={() => (
              <CustomDropdown value={searchParams.activeFlag} ... />
            )} />
          </Grid>
        }
      />
      {/* [5] Modal */}
      <ProjectByDivisionModal
        open={openPrjByDivisionModal}
        modalClose={() => setOpenPrjByDivisionModal(false)}
        setSelectedValue={projects => setSearchParams({ projectCode: projects })}
        preSearchParams={{ ...searchParams }}
        callFromCell={false}
      />
    </>
  );
};
```

### §1.2 의무 사항 인벤토리

| # | 의무 | reference |
|---:|---|---|
| 1 | `<SearchArea searchButtonLabel onSearch isHidden conditions extraConditions>` 5 props | 모든 화면 |
| 2 | `onSearch = setFilters` (store action 그대로) | DMF0006:34 |
| 3 | `isHidden = !isOpenSearchArea` (toggle) | 모든 화면 |
| 4 | `useTabComboQueries({ filters: [...] })` 표준 | DMF0006:26-28 |
| 5 | 각 항목 = `<Grid size={N}><FormItem label labelAlign='right' render>` (N=3 기본, =4 (DMF0007 3-col)) | DMF0006 / DMF0007 |
| 6 | `<CustomDropdown value options onChange>` 3 props | 모든 화면 |
| 7 | options 형식 = `[{ label: 'name', value: 'code' }]` (BE CODE/NAME → FE label/value 변환) | 모든 화면 |
| 8 | Modal 사용 시 `<InputField endAdornment>` + `onDoubleClick` 두 방법 trigger | DMF0006:151-181 |

---

## §2 허용 변형

### §2.1 useTabComboQueries 표준 filter list

| filter 이름 | 의미 | DM 도메인 사용? | TO-BE Phase 5 G2 통합 |
|---|---|:---:|---|
| `MyDivision` | 권한 division | ✅ 모든 화면 | `useBigFilterDM.myDivision` |
| `TeambyDivision` | 부서별 team | ✅ | `useBigFilterDM.team` |
| `EndCustomer` (또는 `EndCustomerByDivisionDept`) | 부서별 end customer | ✅ | `useBigFilterDM.endCustomer` |
| `SalesSite` | sales site | ✅ | `useBigFilterDM.salesSite` |
| `BucketType` | bucket (DAILY/WEEKLY/MONTHLY) | DMF0007 | (별도 — DM 도메인 BigFilter 외) |
| `YesOrNo` | 활성 Y/N | ✅ 거의 모든 화면 | (별도 — 공용) |

→ 메모리 `reference_combo_sql_id_inventory.md` cross-check 의무. 미등록 키 사용 시 BE `BusinessException "Query is not exist"`.

### §2.2 의존 filter (cascade)

```typescript
const filteredEndCustomers = endCustomer?.filter(item =>
  item.DIVISION_ID === searchParams.divisionId &&
  (searchParams.deptId === 'ALL' || searchParams.deptId.split(',').includes(item.DEPT_ID))
);
```

→ DIVISION → DEPT → END_CUSTOMER → SALES_SITE cascade. 의존성 chain.

### §2.3 Map 으로 중복 제거 (DMF0006 표준)

```typescript
[
  ...new Map(
    items?.filter(...)
      .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
  ).values(),
].map(item => ({ label: item.NAME, value: item.CODE }))
```

→ `${DIVISION_ID}|${CODE}` 키로 Map → 중복 제거 → label/value 변환.

**reference**: `CustomerModelMappingForm.tsx:67-74` / 다수 화면.

### §2.4 Multi-select dropdown

```typescript
<CustomDropdown
  multiple
  allOption          // 'ALL' option 자동 추가
  useClearIcon       // X 클리어 버튼
  limitTags={1}      // 표시 tag 1개 (DMF0007)
  value={searchParams.endCustomer}   // csv string ("CUST1,CUST2") 또는 string[]
  options={...}
  onChange={(_, options) => setSearchParams({ endCustomer: options })}
/>
```

**reference**: `CustomerModelMappingForm.tsx:62-78` (multi), `CustomerFcstMasterForm.tsx:83-106` (multi + limitTags).

### §2.5 required (필수 항목)

```typescript
<FormItem label={t('LBL00001', '_Div.')} required render={() => ...} />
```

→ FormItem 의 `required` prop → label 끝에 `*` 자동 표시. AS-IS UsrLabel 의 `*` suffix 와 동등.

**reference**: `CustomerFcstMasterForm.tsx:44, 64, 82`.

### §2.6 Modal cell (input + 더블클릭 / 검색 버튼)

```typescript
<InputField
  fullWidth
  value={searchParams.projectCode}
  onChange={event => setSearchParams({ projectCode: event.target.value })}
  InputProps={{
    endAdornment: (
      <Button appearance='outlined' priority='normal'
        iconComponent={<FunctionSearchIcon appearance='lined' onClick={() => setOpenModal(true)} />}
      />
    ),
  }}
  onDoubleClick={() => setOpenModal(true)}
/>
```

→ 사용자가 (1) 직접 input typing (2) 검색 버튼 click (3) input 더블클릭 → 3 방법으로 modal open.

**reference**: `CustomerModelMappingForm.tsx:155-180`.

### §2.7 extraConditions (별도 영역)

```typescript
<SearchArea
  conditions={ <>... 메인 조회조건 ...</> }
  extraConditions={ <Grid size={3}><FormItem ... ActiveFlag .../></Grid> }
/>
```

→ `extraConditions` 는 검색 버튼 아래 별도 row. ActiveFlag (Active/Inactive 토글) 같은 보조 조건에 사용.

**reference**: `CustomerModelMappingForm.tsx:247-268`.

### §2.8 useSessionStore default + useEffect 주입 (DMF0007)

```typescript
const userId = useSessionStore(state => state.session.userId);

useEffect(() => {
  setSearchParams({ userId: userId });
}, [userId]);
```

→ session 의 userId 를 searchParams 에 자동 주입.

**reference**: `CustomerFcstMasterForm.tsx:21, 27-31`.

### §2.9 Grid size 선택 (3 vs 4)

| size | 의미 | 사용 화면 |
|---|---|---|
| 3 | 4-column layout (4 items per row) | DMF0006 (단순한 화면) |
| 4 | 3-column layout (3 items per row) | DMF0007 (필수 항목 강조) |

→ 화면별 조회조건 항목 수에 따라 결정. 권장: 8 항목 이상 = size=3 / 5 항목 이하 = size=4.

---

## §3 금지 (anti-pattern)

### §3.1 `<label>` + `<input>` 직접 작성

**금지**:
```typescript
<label>Division</label>
<input value={...} onChange={...} />   ❌
```

**의무**: `FormItem + CustomDropdown / InputField` 사용 (메모리 `feedback_form_search_area_standard.md`).

### §3.2 직접 useTabProcQuery (lookup 조회)

**금지**:
```typescript
const { data } = useTabProcQuery({ menuId, sheetName: 'lookup', tabId, ... });   ❌
```

**의무**: `useTabComboQueries({ filters: ['SqlId'] })` 사용. lookup 전용 hook.

### §3.3 unregistered SQL_ID 사용

**금지**: 메모리 `reference_combo_sql_id_inventory.md` 의 52 등록 키 외 임의 키 사용 → BE `BusinessException "Query is not exist"`.

**의무**: 신규 lookup 필요 시 `SCM_ADM_CMBO_SQL_M` 에 INSERT 후 사용 (룰 12 §lookup).

### §3.4 options 형식 직접 사용 (CODE/NAME → label/value 변환 누락)

**금지**:
```typescript
<CustomDropdown value={...} options={data ?? []} />   ❌ (CODE/NAME 그대로 - render 안 됨)
```

**의무**:
```typescript
<CustomDropdown options={data?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []} />   ✅
```

### §3.5 onSearch 의 inline 함수 (성능)

**금지**:
```typescript
<SearchArea onSearch={() => { setFilters(); doSomething(); }} ... />   ❌ 매 render 새 함수
```

**의무**:
```typescript
// store action 그대로 또는 useCallback 으로 memoize
<SearchArea onSearch={setFilters} ... />   ✅
// 또는
const handleSearch = useCallback(() => { ... }, [deps]);
<SearchArea onSearch={handleSearch} ... />
```

### §3.6 React Query refetch loop (메모리 `feedback_popup_dialog_layout` 사고)

**금지**:
```typescript
<Modal preSearchParams={{ divisionId, endCustomer, ...searchParams }} />   ❌ 매 render 새 객체 → refetch loop
```

**의무**:
```typescript
const preSearchParams = useMemo(() => ({ ...searchParams }), [searchParams]);
<Modal preSearchParams={preSearchParams} />   ✅
```

→ 메모리 `feedback_popup_dialog_layout.md` Refetch loop 사고 (DMF0020 popup 3종).

### §3.7 직접 `<input>` / `<button>` (LGES design system 미사용)

**금지**: native HTML `<input>` / `<button>` 사용. LGES design system 안 가져오기.

**의무**: `Button` (`@shared/lges`), `InputField` (`@shared/lges`), `Checkbox` (`@shared/lges`).

---

## §4 자동 검증 (PR 머지 게이트)

```bash
FORM="features/{domain}/src/pages/{screen}/components/{Name}Form.tsx"

# 1. SearchArea + onSearch + isHidden 의무
grep -c "<SearchArea" "$FORM"  # = 1
grep -c "onSearch=" "$FORM"  # ≥ 1
grep -c "isHidden=" "$FORM"  # ≥ 1

# 2. useTabComboQueries 사용
grep -c "useTabComboQueries" "$FORM"  # ≥ 1

# 3. FormItem + Grid + CustomDropdown 표준
grep -c "<FormItem" "$FORM"  # ≥ 1 (각 조회조건 항목)
grep -c "<Grid size=" "$FORM"  # ≥ 1
grep -c "<CustomDropdown" "$FORM"  # ≥ 1 (대부분 화면)

# 4. options 변환 패턴
grep -E "options=\{.*map.*label.*item\.NAME.*value.*item\.CODE" "$FORM" | wc -l  # ≥ 1

# 5. native <input>/<button>/<label> 금지
grep -nE "<input |<button |<label " "$FORM" | wc -l  # = 0

# 6. lookup SQL_ID 등록 확인 (cross-check)
USED_FILTERS=$(grep -oE "filters: \[[^]]+\]" "$FORM" | grep -oE "'[A-Za-z]+'")
# USED_FILTERS 의 각 키가 SCM_ADM_CMBO_SQL_M 에 등록되어 있는지 cross-check

# 7. React Query refetch loop 검출 (useMemo 권장)
grep -n "preSearchParams=\{\{ \.\.\." "$FORM"  # → useMemo 권장 (warning)
```

---

## §5 AS-IS 매핑

| AS-IS UsrConditionPanel | TO-BE SearchArea + FormItem |
|---|---|
| `UsrConditionPanel.UsrPanelType = HidePanel` | `<SearchArea isHidden={!openSearchArea}>` |
| `cboDivision = new UsrCombo(); DataSource = GetDMInnerTable("MyDivision")` | `<CustomDropdown options={myDivision?.map(...)} />` + `useTabComboQueries({ filters: ['MyDivision'] })` |
| `clbTeam = new UsrCheckedList(); DataSource = GetDMInnerTable("UserTeamByDivision")` | `<CustomDropdown multiple options={teambyDivision?.filter(...)} />` |
| `chkDetail = new UsrCheckBox()` | `<Checkbox checked onChange>` |
| `cboDivision.ControlValues` (SelectedValue CODE) | `searchParams.divisionId` |
| `clbTeam.ControlValues` (csv "T01,T02") | `searchParams.teamIds` (csv string 또는 string[]) |
| `cboDivision.SelectedIndexChanged` → 의존 combo refresh | store `setSearchParams({ divisionId })` 안에 자동 fetchStaticColumns + filters reset |
| `OnClickFindButton()` → FindButton override → SP 호출 | `setFilters` (search params → filters 복사) → `useTabProcQuery` 자동 refetch |
| `MessageHelper.GetTerm("LBL_DIVISION")` | `t('LBL00001')` |

---

## §6 조회조건 표준 카탈로그 (메모리 룰)

> 메모리 `feedback_search_fields_catalog.md` — 신규 화면 Form 작성 시 표준 카탈로그 그대로 사용 의무.

**의무**: `@master/components/searchFields/` 카탈로그 사용 (13 종 — 자매 화면 표준).

| 카탈로그 컴포넌트 | 용도 | 자동 적용 |
|---|---|---|
| `DivisionField` | Division dropdown | useTabComboQueries('MyDivision') + LBL00001 + required |
| `TeamField` | Team multi-select | filter by divisionId |
| `ProjectField` | Project + modal cell | ProjectByDivisionModal 자동 |
| `ItemField` | Item + modal cell | ItemByDivisionModal 자동 |
| `OwnerField` | Owner + modal cell | OwnerByDivisionModal 자동 |
| `PeriodField` | Period (시작-종료) | (Phase 5 G9 신규) DateRangePicker |
| `BucketField` | Bucket (DAILY/WEEKLY/MONTHLY) | useTabComboQueries('BucketType') |
| `VersionField` | Version dropdown | (도메인별 lookup) |
| `EndCustomerField` | End Customer multi | filter by divisionId/deptId |
| `SalesSiteField` | Sales Site multi | filter by divisionId/end_customer |
| `ActiveFlagField` | Active Y/N (extraConditions) | useTabComboQueries('YesOrNo') |
| `BizTypeField` | Business Type | filter by divisionId |
| `PlantSiteField` | Plant Site | filter by divisionId/end_customer |

**Phase 5 G9/G10 추가 예정**:
- `PeriodRangeField` (G9 DateRangePicker)
- `MonthField` / `MonthRangeField` (G10 MonthPicker / MonthRangePicker)

---

## §7 G2 통합 (Phase 5 BigFilter 후)

> G2 (BigFilter 캐싱) 신규 구현 후 DM 도메인 Form 의 표준:

```typescript
// Phase 5 G2 후 표준
const { data: bigFilter } = useBigFilterDM({ divisionIds: searchParams.divisionId });

// teambyDivision / endCustomer / salesSite 별도 useTabComboQueries 불필요
// → bigFilter.team / bigFilter.endCustomer / bigFilter.salesSite 사용

const teamOptions = bigFilter?.team?.filter(t => t.DIVISION_ID === searchParams.divisionId);
```

→ DM 도메인은 G2 우선 사용. 다른 lookup (BizType / Bucket 등) 만 useTabComboQueries 별도 호출.

---

## §8 reference file:line 인용

| 패턴 | reference |
|---|---|
| 표준 Form (단순) | `CustomerModelMappingForm.tsx` (287 lines) |
| Form + Multi-modal | `SalesSiteProjectModelForm.tsx` (344 lines) |
| Form + required + userId 자동 | `CustomerFcstMasterForm.tsx` (165 lines) |
| useTabComboQueries 5 filter | `CustomerModelMappingForm.tsx:26-28` |
| Map 중복 제거 | `CustomerModelMappingForm.tsx:67-74` |
| Modal cell (input + endAdornment + onDoubleClick) | `CustomerModelMappingForm.tsx:155-180` |
| extraConditions | `CustomerModelMappingForm.tsx:247-268` |
| useSessionStore default | `CustomerFcstMasterForm.tsx:21-31` |
| Grid size=4 (필수 항목) | `CustomerFcstMasterForm.tsx:40, 60, 78` |
| multi-select limitTags | `CustomerFcstMasterForm.tsx:88` |

---

## §10 Grid size 균등 표준 (2026-06-06 신규)

### §10.1 원칙

`SearchArea conditions` 안의 `<Grid size={N}>` 은 **사용자가 시각적으로 인지하는 field 간격을 균등하게** 유지하기 위해 다음 규칙 적용:

| 조회조건 개수 | 권장 size (총 12 column) | 비고 |
|---|---|---|
| 1 field | size=12 (full) 또는 4 | 가독성 위해 size=4 권장 |
| 2 field | size=4 + size=4 (총 8) 또는 size=6 + size=6 | 4+4 = 더 컴팩트 |
| 3 field | **size=3 + size=3 + size=3 (총 9)** | 가장 균등하고 컴팩트 (권장) |
| 4 field | size=3 × 4 (총 12) | 한 줄 가득 |
| 5+ field | size=4 × 3 다음 줄 + ... | 4 column 단위 wrap |

### §10.2 표준 패턴 (3 field 예)

```typescript
<SearchArea conditions={
  <>
    <Grid size={3}>
      <FormItem label='User ID' labelAlign='right'
        render={() => <InputField fullWidth value={...} onChange={...} />} />
    </Grid>
    <Grid size={3}>
      <FormItem label='Period' labelAlign='right' required
        render={() => <DatePickerCalendar usecase='date-range-multi' ... />} />
    </Grid>
    <Grid size={3}>
      <FormItem label='Status' labelAlign='right'
        render={() => <CustomDropdown value={...} options={...} onChange={...} />} />
    </Grid>
  </>
} />
```

### §10.3 anti-pattern

```typescript
// ❌ 불균등 (Period 가 size=8 → 옆 field 와 큰 간격)
<Grid size={3}>User ID</Grid>
<Grid size={8}>Period</Grid>     {/* ← 다음 field 와 큰 간격 */}
<Grid size={3}>Status</Grid>

// ❌ 4/4/4 (DatePickerCalendar 가 4 col 안에 비좁게 + 남는 우측 여백)
<Grid size={4}>User ID</Grid>
<Grid size={4}>Period</Grid>
<Grid size={4}>Status</Grid>
```

### §10.4 PRE-WRITE 체크리스트

```
☐ 조회조건 개수 카운트?
☐ 표 §10.1 에 따라 권장 size 적용?
☐ DatePickerCalendar (date-range-multi) 는 size 3 이상 필요?
  → date-range 는 2 datepicker 가 들어가므로 최소 size=3 권장
☐ AS-IS .Designer.cs 의 Layout 과 시각 일치 확인?
```

### §10.5 사고 사례

| 사례 | 결과 |
|---|---|
| SCM0009 3 field 4/4/4 (2026-06-06) | Period 옆 Status 와의 간격이 너무 넓다는 사용자 보고 |
| SCM0009 3 field 3/6/3 (이전) | Period 가 너무 넓고 Status 와 비대칭 |

→ Fix: 3/3/3 균등

### §10.6 cross-ref

- 메모리 `feedback_form_grid_equal_sizing`
- AS-IS 의 SearchPanel Layout 시각 분석 의무

---

## §9 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-03 | 초안 (Phase 3 추출) | DMF0004~7 Form 통합 분석 + G2 통합 사양 + 카탈로그 cross-ref |
| 2026-06-06 | §10 Grid size 균등 표준 신설 | SCM0009 사용자 보고 "Period 와 Status 간격이 너무 넓음" |

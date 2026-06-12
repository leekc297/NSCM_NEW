# Hook — components/ 폴더 패턴 (진입 페이지 + sub-component 분리 의무)

> 적용 trigger: T01 (신규 화면) / T04 (Grid 작성) / T06 (Modal 작성)
> 신설 일자: 2026-06-09 (DMF0008 inline 4 grid 440 라인 사고 후, 사용자 명시 요구)
> 관련 룰: `_tobe/01_file_structure.md §1.5` + `_tobe/03_main_component.md §1.1` + `_tobe/03_main_component.md §3.7`
> 메모리: `feedback_components_folder_separation_mandatory.md`

---

## §0 사고 사례 (DMF0008 erp-edi-master)

**Symptom**: 진입 페이지 `ErpEdiMaster.tsx` **440 라인** 안에 4 grid (`Summary` / `Repair` / `SalesSite` / `SSPM`) `<FlexGrid>` JSX 모두 inline 정의 + UpdateHistory bar (13 라인) inline + `components/modals/` 폴더 부재.

**Root cause**: 신규 화면 작성 시 `components/` 의무 + sub-component 분리 원칙이 룰 v2 에 약하게 명시 (§3.7 "200 lines 초과 분리" 만 있고 inline JSX 금지 명시 부재).

**Impact**:
- CLAUDE.md §3 원칙 1 **"한 사람이 개발한 것처럼"** 위반 — DMF0004/0005/0006 표준과 일관성 단절
- 진입 페이지 logic + UI 혼재로 가독성 저하 + sub-component 재사용 불가
- 향후 grid 컴포넌트 별 단위 테스트 / props 명세 / SCSS module 분리 불가

**Fix**: 본 hook + 룰 01 §1.5 + 룰 03 §1.1 보강 + DMF0008 4 grid + UpdateHistoryBar sub-component 추출.

---

## §1 의무 매트릭스

| # | 의무 | 한도 / 형식 | 위반 시 |
|---:|---|---|---|
| 1 | `components/` 폴더 즉시 생성 | 화면 폴더 생성 직후 (skeleton 단계여도) | 후속 grid/form 추가 시 root 분산 |
| 2 | Form / Grid / SubGrid / Tab 별 .tsx 분리 | JSX 30 라인 초과 시 강제 분리 | 진입 페이지 라인 폭증 |
| 3 | Modal / Popup `components/modals/` 서브폴더 | (현재 modal 0 개여도 폴더 의무) | modal 신규 작성 시 root 배치 사고 |
| 4 | 진입 페이지 line 한도 | **≤ 400 강제 / ≤ 300 권장** | 룰 03 §3.7 위반 |
| 5 | 진입 페이지 안 `<FlexGrid>` / `<DataGrid>` JSX 직접 정의 | **금지** | DMF0008 사고 패턴 재발 |
| 6 | 진입 페이지 안 `<CustomDialog>` / `<Dialog>` JSX 직접 정의 | **금지** | inline modal 누적 |
| 7 | 진입 페이지 역할 | composition + layout 만 | logic + UI 혼재 |

---

## §2 PRE-WRITE 자기 점검 (신규 화면 진입 페이지 작성 직전)

```bash
# 1. {화면 폴더}/components/ 존재 확인 (없으면 즉시 생성)
test -d features/{domain}/src/pages/{screen}/components || mkdir -p features/{domain}/src/pages/{screen}/components

# 2. {화면 폴더}/components/modals/ 존재 확인 (현재 modal 0 개여도 폴더 신설)
test -d features/{domain}/src/pages/{screen}/components/modals || mkdir -p features/{domain}/src/pages/{screen}/components/modals

# 3. 자매 화면 (DMF0004 sales-site) 표준 인벤토리 cross-check
ls features/master/src/pages/sales-site/components/
# 결과: 5 .tsx + modals/ 폴더 — 신규 화면도 동일 패턴 학습

# 4. JSX 30 라인 초과 블록 사전 식별
# 작성할 grid / form / tab JSX 가 30 라인 초과 예상 시 sub-component 로 시작
```

---

## §3 POST-WRITE 자동 grep (3종 의무 + 1 옵션)

```bash
SCREEN_PATH="features/{domain}/src/pages/{screen}"
ENTRY_FILE="$SCREEN_PATH/{Pascal}.tsx"

# [의무 1] 진입 페이지 라인 수 한도 (400 초과 시 분리 의무)
LINES=$(wc -l < "$ENTRY_FILE")
if [ "$LINES" -gt 400 ]; then
  echo "❌ ERROR: 진입 페이지 $LINES 라인 — 400 한도 초과. sub-component 분리 의무."
  exit 1
elif [ "$LINES" -gt 300 ]; then
  echo "⚠️ WARN: 진입 페이지 $LINES 라인 — 300 권장 초과. sub-component 분리 검토."
fi

# [의무 2] 진입 페이지 안 FlexGrid/DataGrid 직접 정의 금지
INLINE_GRID=$(rg -n "<FlexGrid\b|<DataGrid\b" "$ENTRY_FILE" | wc -l)
if [ "$INLINE_GRID" -gt 0 ]; then
  echo "❌ ERROR: 진입 페이지 안 <FlexGrid> / <DataGrid> JSX 직접 정의 $INLINE_GRID 건 검출."
  echo "         components/{Pascal}Grid.tsx 로 분리 의무."
  rg -n "<FlexGrid\b|<DataGrid\b" "$ENTRY_FILE"
  exit 1
fi

# [의무 3] 진입 페이지 안 CustomDialog/Dialog 직접 정의 금지
INLINE_MODAL=$(rg -n "<CustomDialog\b|<Dialog\b" "$ENTRY_FILE" | wc -l)
if [ "$INLINE_MODAL" -gt 0 ]; then
  echo "❌ ERROR: 진입 페이지 안 <CustomDialog> / <Dialog> JSX 직접 정의 $INLINE_MODAL 건 검출."
  echo "         components/modals/{Pascal}{Action}Modal.tsx 로 분리 의무."
  rg -n "<CustomDialog\b|<Dialog\b" "$ENTRY_FILE"
  exit 1
fi

# [옵션] components/ + modals/ 폴더 의무
test -d "$SCREEN_PATH/components" || { echo "❌ ERROR: components/ 폴더 부재."; exit 1; }
test -d "$SCREEN_PATH/components/modals" || { echo "⚠️ WARN: components/modals/ 폴더 부재. modal 신규 작성 대비 폴더 신설 권장."; }
```

---

## §4 자매 화면 인벤토리 (Reference 5종)

| 화면 | 위치 | 구조 |
|---|---|---|
| DMF0004 sales-site | `features/master/src/pages/sales-site/` | Form + Grid + CustomerGrid + LocationGrid + BucketGrid + modals/ (multi-sheet 표준) |
| DMF0005 sales-site-project-model | `features/master/src/pages/sales-site-project-model/` | Form + Grid + PurchaseGrid + Panel 분할 (DMF0005 표준) |
| DMF0006 customer-model-mapping | `features/master/src/pages/customer-model-mapping/` | Form + Grid (단순형 표준) |
| DMF0007 customer-forecast-master | `features/master/src/pages/customer-forecast-master/` | Form + FcstGrid + PsiGrid + Tab + utils/ (Dynamic column 표준) |
| DMF0020 sales-future-price | `features/master/src/pages/sales-future-price/` | Form + Grid + ExchangeRate / PriceBatch / ColumnSetting modal 3종 (modal 표준) |

→ 신규 화면 작성 시 위 5종 중 1~2 개 골라서 sub-component 명명 / props 패턴 학습 의무.

---

## §5 Anti-pattern 사례 (DMF0008, 2026-06-09 보완)

❌ **잘못된 패턴** (`ErpEdiMaster.tsx` 440 라인 — fix 전):
```tsx
return (
  <>
    <MainTitle ... />
    <ErpEdiMasterForm ... />
    <div className={styles.subTitleRow}>
      {/* 13 라인 inline UpdateHistory bar */}
      <div className={styles.updateHistoryBar}>...</div>
      <SubTitle ... />
    </div>

    {/* 27 라인 inline Summary FlexGrid */}
    <FlexGrid initialized={...} itemsSource={summaryRows}>
      <FlexGridColumn binding='DIVISION_ID' .../>
      ...
    </FlexGrid>

    {/* 45 라인 inline Repair FlexGrid */}
    <FlexGrid initialized={...} itemsSource={repairRows}>...</FlexGrid>

    <TabWrapper>
      <TabItem label='Sales Site'>
        {/* 21 라인 inline SalesSite FlexGrid */}
        <FlexGrid initialized={...} itemsSource={salesSiteRows}>...</FlexGrid>
      </TabItem>
      <TabItem label='SSPM'>
        {/* 19 라인 inline SSPM FlexGrid */}
        <FlexGrid initialized={...} itemsSource={sspmRows}>...</FlexGrid>
      </TabItem>
    </TabWrapper>
  </>
);
```

✅ **올바른 패턴** (sub-component 분리 후 — 약 200 라인):
```tsx
import { ErpEdiMasterForm } from './components/ErpEdiMasterForm';
import { ErpEdiMasterUpdateHistoryBar } from './components/ErpEdiMasterUpdateHistoryBar';
import { ErpEdiMasterSummaryGrid } from './components/ErpEdiMasterSummaryGrid';
import { ErpEdiMasterRepairGrid } from './components/ErpEdiMasterRepairGrid';
import { ErpEdiMasterSalesSiteGrid } from './components/ErpEdiMasterSalesSiteGrid';
import { ErpEdiMasterSspmGrid } from './components/ErpEdiMasterSspmGrid';

return (
  <>
    <MainTitle ... />
    <ErpEdiMasterForm onSearch={handleSearch} />
    <div className={styles.subTitleRow}>
      <ErpEdiMasterUpdateHistoryBar history={updateHistory} />
      <SubTitle ... />
    </div>
    <ErpEdiMasterSummaryGrid gridRef={summaryGridRef} rows={summaryRows} onDoubleClick={handleSummaryDoubleClick} />
    <ErpEdiMasterRepairGrid gridRef={repairGridRef} rows={repairRows} repairTotal={repairTotal} onDoubleClick={handleRepairDoubleClick} />
    <TabWrapper persist>
      <TabItem label='Sales Site'><ErpEdiMasterSalesSiteGrid gridRef={salesSiteGridRef} rows={salesSiteRows} /></TabItem>
      <TabItem label='SSPM'><ErpEdiMasterSspmGrid gridRef={sspmGridRef} rows={sspmRows} /></TabItem>
    </TabWrapper>
  </>
);
```

---

## §6 cross-ref

- 룰 `_tobe/01_file_structure.md §1.5` — components/ 폴더 의무 + 7 의무 매트릭스
- 룰 `_tobe/03_main_component.md §1.1` — sub-component import 라인 명시
- 룰 `_tobe/03_main_component.md §3.7` — 진입 페이지 inline JSX 금지
- 룰 `_tobe/10_popup_modal.md` — modal 작성 시 components/modals/ 위치
- 메모리 `feedback_components_folder_separation_mandatory.md`
- 00_INDEX §A T01 (신규 화면) 트리거 매트릭스에서 본 hook 자동 분기

---

## §7 Sub-component Props 표준 (Grid / Form / Modal) — 2026-06-10 신규

> 사용자 명시 요구 (2026-06-10): "기존 컴퍼넌트 형태를 파악해서 차후 컴퍼넌트 생성 시 동일한 RULE 로 생성되도록 해주세요."
> + "컬럼 하드코딩 없이 컴퍼넌트 사용하는 것으로 적용 요청"
>
> 배경: DMF0008 재개발 시 사용자가 components/ 폴더에 DMF0004/0005 표준 정상본 6개를 복사/붙이기로 복원. 그러나 메인 ErpEdiMaster.tsx 가 옛 형식 (`rows`/`onDoubleClick`/`gridFilterRef` 누락) 으로 호출하여 인터페이스 mismatch 5건 사고. → 본 §7 신설로 sub-component props 표준 명문화.

### §7.1 Grid sub-component (의무 4 props)

```ts
// reference: ErpEdiMasterSummaryGrid / ErpEdiMasterSalesSiteGrid / SalesSiteGrid (DMF0004)
interface {Pascal}{Sheet}GridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.{X}>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.{X}>[];
  onDblClick?: (...event-specific args) => void;  // 선택 — 메인이 cascade 필요 시
}

export const {Pascal}{Sheet}Grid = ({ gridRef, gridFilterRef, data, onDblClick }: Props) => {
  const staticColumns = use{Pascal}Store(state => state.staticColumns.{sheet});
  // ... handleDblClick / handleFormatItem ...
  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.{X}>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dblClick={handleDblClick}
      formatItem={handleFormatItem}
    />
  );
};
```

**금지 사항**:
- ❌ `rows` (의무 = `data`)
- ❌ `onDoubleClick` (의무 = `onDblClick`)
- ❌ `gridFilterRef` 누락
- ❌ `staticColumns` 하드코딩 (`[{ binding, header, width }]`) — store.staticColumns 구독 의무 (메모리 `feedback_grid_no_hardcoded_static_columns`)
- ❌ `<FlexGrid>` 직접 사용 (의무 = `DataGrid` 래퍼 — 룰 12 §11.7)

**의무 패턴**:
- handleDblClick: `grid.hitTest(mouseEvent)` → `GridUtils.getRow/getBinding` → 조건 분기 → `onDblClick` 콜백
- handleFormatItem: cell type 체크 → binding 매칭 → Set 화이트리스트 (예: `const YELLOW_HIGHLIGHT_COLUMNS = new Set([...])`)
- Modal 통합 시: `useState` opens + `clickedRow` row index + `setSelectedValue` 콜백 + CRUD_TYPE 가드 (`if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;`)

### §7.2 Form sub-component (props 0 — store 직접 구독)

```ts
// reference: ErpEdiMasterForm / SalesSiteForm (DMF0004)
export const {Pascal}Form = () => {
  const { t } = useTranslation();  // ambient (auto-imports.d.ts) — import 불필요
  const openSearchArea = use{Pascal}Store(state => state.openSearchArea);
  const searchParams = use{Pascal}Store(state => state.searchParams);
  const setSearchParams = use{Pascal}Store(state => state.setSearchParams);
  const setSummaryFilters = use{Pascal}Store(state => state.setSummaryFilters);  // 또는 setSiteFilters 등
  const fetchStaticColumns = use{Pascal}Store(state => state.fetchStaticColumns);

  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={() => { setSummaryFilters(); void fetchStaticColumns(); }}
      conditions={...}
    />
  );
};
```

**금지 사항**:
- ❌ `onSearch` prop 받기 (의무 = store 직접 호출)
- ❌ store 의 `searchCondition` / `setSearchCondition` / `setFilter` 명칭 사용 (의무 = `searchParams` / `setSearchParams` / `setSummaryFilters` DMF0004 표준)
- ❌ raw `<label>` + `<input>` (의무 = `SearchArea` + `FormItem` + `Grid size` + `CustomDropdown` — 룰 25 §1.5.4)
- ❌ 직접 `useTabProcQuery` 호출 (lookup combo 는 `useTabComboQueries` 의무)

### §7.3 Modal sub-component (5 props 표준)

```ts
// reference: features/master/src/components/{customerByDivisionModal,projectByDivisionModal,...}/
interface {Pascal}{Action}ModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (...) => void;
  preSearchParams?: { divisionId?: string; [key: string]: unknown };
  callFromCell?: boolean;
}
```

**금지 사항**:
- ❌ `isOpen` / `onClose` / `onSelect` (의무 = `open` / `modalClose` / `setSelectedValue`)
- ❌ `CustomDialog` / `Dialog` 직접 정의 메인 페이지 안 (의무 = `components/modals/` 위치)

### §7.4 store 표준 명칭 (Form 호출 의무)

| Store member | 의미 | DMF0004 reference |
|---|---|---|
| `searchParams: T` | 조회조건 객체 | useSalesSiteStore:22 |
| `setSearchParams: (Partial<T>) => void` | 조회조건 일부 갱신 | useSalesSiteStore:82 |
| `setSummaryFilters: () => void` (or `set{Sheet}Filters`) | filter trigger (search button) | useSalesSiteStore:71 (setSiteFilters) |
| `fetchStaticColumns: () => Promise<void>` | BE 메타 GET → staticColumns 채움 + G1 GET search-conditions restore | useSalesSiteStore:91 |
| `staticColumns: { [sheet]: RawFlexGridColumnConfig[] }` | column meta cache | useSalesSiteStore:23 |
| `updateHistory: { SDATE/EDATE/UPDATED_BY }` (선택) | Update History 영역 (Form 구독) | DMF0008 신규 |
| `openSearchArea: boolean` + `setOpenSearchArea` | SearchArea 토글 | useSalesSiteStore:27 |
| `initialized: boolean` | fetchStaticColumns 첫 회 가드 (G1 GET restore 부분만) | useSalesSiteStore:19 |

⚠️ DMF0008 의 옛 `searchCondition` / `setSearchCondition` / `setFilter` 명칭은 **deprecated**. 신규 화면 + 재개발은 DMF0004 표준 명칭 의무.

### §7.5 POST-WRITE 자동 grep (Props mismatch 검출)

```bash
SCREEN_PATH="features/{domain}/src/pages/{screen}"
ENTRY_FILE="$SCREEN_PATH/{Pascal}.tsx"

# [의무 1] 메인의 grid 호출에서 rows= / onDoubleClick= 사용 검출 (의무 = data / onDblClick)
BAD=$(rg -nE "rows=\\{|onDoubleClick=\\{" "$ENTRY_FILE" | wc -l)
if [ "$BAD" -gt 0 ]; then
  echo "❌ ERROR: rows / onDoubleClick prop 사용 $BAD 건. data / onDblClick 으로 변경 의무."
  rg -nE "rows=\\{|onDoubleClick=\\{" "$ENTRY_FILE"
  exit 1
fi

# [의무 2] sub-grid 호출에 gridFilterRef 전달 확인 (FlexGridFilter 의무)
# grid 호출 N건 = gridFilterRef 전달 N건
GRID_CALLS=$(rg -c "<{Pascal}.*Grid\b" "$ENTRY_FILE" || echo 0)
FILTER_PROPS=$(rg -c "gridFilterRef=\\{" "$ENTRY_FILE" || echo 0)
[ "$GRID_CALLS" -ne "$FILTER_PROPS" ] && \
  echo "⚠️ WARN: grid 호출 $GRID_CALLS 건 vs gridFilterRef 전달 $FILTER_PROPS 건 불일치"

# [의무 3] grid 안 staticColumns 하드코딩 금지
HARDCODED=$(rg -n "staticColumns=\\{\\[" "$SCREEN_PATH/components/" | wc -l)
[ "$HARDCODED" -gt 0 ] && \
  echo "❌ ERROR: staticColumns 하드코딩 $HARDCODED 건. store.staticColumns 구독 의무."
```

### §7.6 reference 인벤토리

| 컴포넌트 종류 | reference 위치 |
|---|---|
| Grid (조회 전용) | `features/master/src/pages/erp-edi-master/components/ErpEdiMasterSummaryGrid.tsx` (69 라인) |
| Grid (formatItem + 화이트리스트) | `features/master/src/pages/erp-edi-master/components/ErpEdiMasterRepairGrid.tsx` (76 라인) |
| Grid (modal trigger 통합) | `features/master/src/pages/erp-edi-master/components/ErpEdiMasterSalesSiteGrid.tsx` (168 라인) |
| Form | `features/master/src/pages/sales-site/components/SalesSiteForm.tsx` / DMF0008 `ErpEdiMasterForm.tsx` (73 라인) |
| Modal | `features/master/src/components/projectByDivisionModal/` 등 7종 (메모리 `reference_public_modals_master_components`) |
| Store (fetchStaticColumns 표준) | `features/master/src/pages/sales-site/useSalesSiteStore.ts:91~132` |

---

## §8 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-09 | 신규 (PRE/POST WRITE 양방향 검증 + 자매 인벤토리 + DMF0008 사고 사례) | 사용자 명시 요구 + DMF0008 보완 |
| 2026-06-10 | §7 신설 (Sub-component Props 표준 — Grid/Form/Modal + store 명칭) | DMF0008 재개발 시 props mismatch 5건 사고. 사용자 명시 요구 "동일한 RULE 로 생성" + "컬럼 하드코딩 없이" |

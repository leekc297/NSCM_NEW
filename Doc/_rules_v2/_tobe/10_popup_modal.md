# TO-BE 룰 10 — Popup / Modal (CustomDialog + 공용 modal 11종)

> **추출 reference**: `@master/components/index.ts` 의 11 공용 modal + DMF0006 / DMF0004 의 modal 사용 패턴 + 메모리 `reference_public_modals_master_components.md` + `feedback_popup_dialog_layout.md`

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | 10 |
| 토픽 | 공용 modal 사용 + CustomDialog 표준 + setSelectedValue 콜백 |
| 적용 trigger | Form / Grid 에서 modal 사용 |
| 관련 hook | `popup-asis-analysis.md`, `popup-dialog-layout.md` (메모리 사고 후) |

---

## §1 공용 modal 11종 인벤토리 (의무 인지)

> 위치: `nscm-fe/features/master/src/components/`
> 메모리 `reference_public_modals_master_components.md` 동기.

| # | Modal | AS-IS 원본 | 사용 시점 | 사용 화면 |
|---:|---|---|---|---|
| 1 | `ProjectByDivisionModal` | `SCM0002_ProjectbyDivisionPopupEx` / `DMF000_ProjectbyDivisionPopupEx` | Project 선택 | DMF0005/0006/0008/다수 |
| 2 | `ItemByDivisionModal` | `SCM0002_ItembyDivisionPopupEx` / `DM0002_ItembyDivisionPopupEx` | Item 선택 | DMF0005/0006/0008/다수 |
| 3 | `OwnerByDivisionModal` | `DM0020_OwnerbyDivisionPopup` | Owner 선택 | DMF0005/0020 |
| 4 | `CustomerModal` | `SCM0002_CustomerbyDivisionPopup` | Customer 선택 | DMF0004 |
| 5 | `TeamModal` | `SCM0002_TeamPopup` | Team 선택 | DMF0004 |
| 6 | `RegionModal` | `SCM0002_CitybyCountry` | Country + City 선택 | DMF0004 |
| 7 | `StorageLocationModal` | `SCM0002_StoragebyDivisionPopup` | Storage 선택 | DMF0004 |
| 8 | `ColumnSettingModal` | `SCM0002_TitleSetForm_Popup` / `DM0002_TitleSetForm_Popup` | 사용자별 column 설정 | DMF0020/0043_01 |
| 9 | `OwnerModal` | (도메인별 변형) | Owner 단순 선택 | (사용처 확인) |
| 10 | `ProjectModal` | (도메인별 변형) | Project 단순 선택 | (사용처 확인) |
| 11 | `SearchFields` (catalog, not modal) | (조회조건 카탈로그) | Form 컴포넌트 직접 사용 | 룰 06 §6 |

### §1.1 신규 공용 modal 후보 (Phase 5)

| 신규 modal | AS-IS 원본 | 우선순위 | Phase |
|---|---|---|---|
| `SoldtoByDivisionModal` (G11) | `SCM0002_SoldtobyDivisionPopup` | ⭐ High (DMF0004 retrofit) | Phase 5 |
| `VendorModal` | `SCM0002_VendorPopup` | Medium | Phase 5 lazy |
| `ExchangeRateModal` | `DMF0042_ExchangeRatePopup` | Medium (DMF0042) | Phase 5 (already in DMF0020 작업) |
| `FactoryByDivisionModal` | `SCM0002_FactoryByDivisionPopup` | Low | Phase 5+ |

---

## §2 표준 modal 사용 (의무)

### §2.1 import + state + callback 표준

```typescript
import { useState } from 'react';
import { ProjectByDivisionModal, ItemByDivisionModal } from '../../../components';

// State
const [openProjectModal, setOpenProjectModal] = useState<boolean>(false);

// Trigger (Form 안 input cell 더블클릭 또는 검색 button)
<InputField
  endAdornment={
    <Button iconComponent={<FunctionSearchIcon onClick={() => setOpenProjectModal(true)} />} />
  }
  onDoubleClick={() => setOpenProjectModal(true)}
/>

// Modal
<ProjectByDivisionModal
  open={openProjectModal}
  modalClose={() => setOpenProjectModal(false)}
  setSelectedValue={(projects, projectsNames) => {
    setSearchParams({ projectCode: projects });
    // 또는 grid cell update
  }}
  preSearchParams={preSearchParams}
  callFromCell={false}
/>
```

### §2.2 modal Props 표준 시그니처

| Prop | 타입 | 의무 | 의미 |
|---|---|---|---|
| `open` | `boolean` | ⭐ 의무 | modal 표시 여부 |
| `modalClose` | `() => void` | ⭐ 의무 | 닫기 콜백 |
| `setSelectedValue` | `(value: string, name?: string, type?: string) => void` | ⭐ 의무 | 선택 결과 콜백 |
| `preSearchParams` | `Partial<SearchParamProps>` | 의무 (대부분) | 초기 검색조건 |
| `callFromCell` | `boolean` | 의무 (대부분) | `false` = Form 호출, `true` = Grid cell 호출 (필터 동작 차이) |

### §2.3 useMemo preSearchParams (React Query refetch loop 방지)

**의무** (메모리 `feedback_popup_dialog_layout.md`):

```typescript
const preSearchParams = useMemo(() => ({
  divisionId: searchParams.divisionId,
  deptId: searchParams.deptId ?? 'ALL',
  endCustomer: searchParams.endCustomer ?? 'ALL',
  // ...
}), [searchParams.divisionId, searchParams.deptId, searchParams.endCustomer]);

<Modal preSearchParams={preSearchParams} ... />
```

→ 매 render 시 새 객체 생성 → React Query queryKey 변경 → refetch loop 사고.

### §2.4 Grid cell 에서 modal 호출 (callFromCell={false} but clicked row 기반)

```typescript
// Grid 컴포넌트 안
const [clickedRow, setClickedRow] = useState(-1);
const clickedDataItem = GridUtils.getRow(gridRef.current, clickedRow);

<ProjectByDivisionModal
  open={openProjectModal}
  modalClose={() => setOpenProjectModal(false)}
  setSelectedValue={(projects, projectsNames) => {
    handleProjectSelected(projects, projectsNames);   // EditTracker.storeChange + dataItem update + refreshRange
  }}
  preSearchParams={{
    divisionId: clickedDataItem?.DIVISION_ID,
    deptId: clickedDataItem?.DEPT_ID || 'ALL',
    endCustomer: clickedDataItem?.END_CUSTOMER || 'ALL',
    salesSite: clickedDataItem?.SCM_SITE_ID || 'ALL',
    projectCode: clickedDataItem?.PROJECT_CODE,
  }}
  callFromCell={false}
/>
```

**reference**: `CustomerModelMappingGrid.tsx:122-153`.

---

## §3 신규 modal 작성 표준 (Phase 5 G11 같은 경우)

### §3.1 폴더 구조

```
nscm-fe/features/master/src/components/{kebab-name}Modal/
├─ {PascalName}Modal.tsx
├─ {PascalName}Modal.module.scss
└─ index.ts (선택 — `@master/components/index.ts` 에 export 추가)
```

### §3.2 컴포넌트 표준

```typescript
import { useMemo, useRef } from 'react';
import { CustomDialog, DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem } from '@shared/lges';

interface {Name}ModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (value: string, name?: string) => void;
  preSearchParams?: Partial<SearchParamProps>;
  callFromCell?: boolean;
  headerTitle?: string;   // optional override
}

export const {Name}Modal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  callFromCell = false,
  headerTitle,
}: {Name}ModalProps) => {
  const { t } = useTranslation();
  
  // 내부 state (검색조건 + grid ref + 선택 row)
  const [searchParams, setSearchParams] = useState({...preSearchParams});
  const [selectedRow, setSelectedRow] = useState(-1);
  const gridRef = useRef<FlexGrid>();
  
  // BE 호출 (modal 전용 SP)
  const { data } = useTabProcQuery({
    menuId: 'COM0001',           // 공용 modal 의 menuId
    sheetName: 'project',         // modal SP sheet
    tabId: 'modal',
    filters: searchParams,
    enabled: !!searchParams.divisionId,
  });
  
  // 확인 button click 시
  const handleApply = () => {
    const row = data?.o_rc1?.[selectedRow];
    if (row) {
      setSelectedValue(row.PROJECT_CODE, row.PROJECT_NAME);
      modalClose();
    }
  };
  
  return (
    <CustomDialog
      open={open}
      onClose={modalClose}
      title={headerTitle ?? t('LBL_MODAL_TITLE')}
      position='basic'              // 중앙 (메모리 룰)
      // height 명시 안 함 (DEFAULT_HEIGHT='50vh' 자동)
    >
      {/* 검색조건 영역 */}
      <FormItem ... />
      <DataGrid ... />
      
      {/* 하단 button */}
      <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
        <Button onClick={handleApply}>{t('LBL_APPLY')}</Button>
        <Button onClick={modalClose}>{t('LBL_CANCEL')}</Button>
      </div>
    </CustomDialog>
  );
};
```

### §3.3 SCSS Module 표준

```scss
// {Name}Modal.module.scss
.gridWrap {
  flex: 1;
  min-height: 0;     // ⭐ flex 안 grid 가 늘어나도록
}

.filterRow {
  flex-shrink: 0;    // ⭐ filter 영역은 고정 높이
}

.bottomRow {
  flex-shrink: 0;
  margin-top: 8px;
}
```

→ 메모리 `feedback_popup_dialog_layout.md` 의 표준.

---

## §4 CustomDialog 사용 (메모리 룰)

### §4.1 의무

> 메모리 `feedback_popup_dialog_layout.md`:

```typescript
import { CustomDialog } from '@shared/components';

<CustomDialog
  open={open}
  onClose={modalClose}
  title={title}
  position='basic'          // ⭐ 의무 (중앙)
  // height = DEFAULT_HEIGHT='50vh' 자동
>
  {children}
</CustomDialog>
```

**의무 사항**:
1. `position='basic'` 명시 (중앙 표시 — `position='overflow'` 사용 시 중앙 미표시 사고)
2. height 명시 안 함 (CustomDialog DEFAULT_HEIGHT='50vh' 자동)
3. SCSS Module 의 `min-height: 70vh` 같은 강제 높이 금지 (잘림 사고)
4. flex layout: `.gridWrap { flex:1; min-height:0 }` + `.filterRow / .bottomRow { flex-shrink: 0 }`

### §4.2 금지 (사고 사례)

```typescript
// ❌ height 명시 시 DEFAULT_HEIGHT 무시 → 의도와 다름
<CustomDialog height="80vh" ... />

// ❌ position='overflow' → 중앙 미표시
<CustomDialog position='overflow' ... />

// ❌ SCSS Module 의 강제 min-height: 70vh → CustomDialog DEFAULT_HEIGHT 무시 + 내용 잘림
.modal { min-height: 70vh }   // ❌
```

---

## §5 modal 안 검색조건 / Grid

### §5.1 modal 안의 SearchArea (DMF0020 ExchangeRateModal 표준)

```typescript
<CustomDialog ...>
  <div className={styles.filterRow}>
    {/* 검색조건 (단순) */}
    <FormItem ... />
    <Button onClick={handleSearch}>{t('LBL_SEARCH')}</Button>
  </div>
  
  <div className={styles.gridWrap}>
    <DataGrid ... />
  </div>
  
  <div className={styles.bottomRow}>
    <Button onClick={handleApply}>{t('LBL_APPLY')}</Button>
    <Button onClick={modalClose}>{t('LBL_CANCEL')}</Button>
  </div>
</CustomDialog>
```

### §5.2 PIVOT modal (DMF0020 ExchangeRateModal)

> `Wijmo 직접 PIVOT FORMAT` standalone SP + COL_NM = `mnuId` — 룰 12 §lookup 참조.

→ Modal 안의 grid 도 PIVOT 변환 가능 (DMF0020 ExchangeRate long → wide).

---

## §6 금지 (anti-pattern)

### §6.1 공용 modal 인벤토리 미확인 (메모리 룰)

**금지** (메모리 `reference_public_modals_master_components.md`):
- 신규 modal 작성 전 11 공용 modal 인벤토리 확인 안 함 → 중복 작성

**의무**: 신규 popup 필요 시 (1) `@master/components/index.ts` cross-check (2) AS-IS popup 분석 (`_asis/01_popups/`) cross-check (3) 매핑 modal 없으면 신규 작성

### §6.2 setSelectedValue callback 의 잘못된 데이터 사용

**금지**:
```typescript
setSelectedValue={(items, name) => {
  setSearchParams({ projectCode: name });   // ❌ name 대신 code 사용해야 함
}}
```

**의무**:
```typescript
setSelectedValue={(items, name) => {
  setSearchParams({ projectCode: items });   // ✅ code (첫 인자)
}}
```

→ Modal callback 의 첫 인자 = code (csv 또는 단일), 두 번째 인자 = name.

### §6.3 Modal cell 의 CRUD_TYPE 가드 누락

**금지** (룰 07 §3.5 + 메모리 `feedback_grid_popup_cell_mandatory.md`):
```typescript
if (binding === 'PROJECT_CODE') {   ❌ 조회 row 도 modal 열림
  setOpenModal(true);
}
```

**의무**:
```typescript
if (dataItem.CRUD_TYPE === CRUD_TYPE.INSERT && binding === 'PROJECT_CODE') {   ✅
  setOpenModal(true);
}
```

### §6.4 modal 자유 작성 (CustomDialog 미사용)

**금지**:
```typescript
import { Dialog } from '@mui/material';   // ❌ MUI 직접 사용
import { Modal } from '@shared/lges';     // ❌ lges 미존재 (export 확인)
```

**의무**: `CustomDialog` (`@shared/components`) 만 사용.

### §6.5 useMemo preSearchParams 누락 (refetch loop)

**금지**: 룰 06 §3.6 / 07 §3.8 와 동일.

### §6.6 modal 닫힘 시 state 초기화 누락

**금지**: modal 다시 열 때 이전 검색 상태가 남아 있음.

**의무**: modal `useEffect` 안에 `open` 변경 시 state reset.

```typescript
useEffect(() => {
  if (open) {
    setSearchParams({...preSearchParams});
    setSelectedRow(-1);
  }
}, [open]);
```

---

## §7 자동 검증 (PR 머지 게이트)

```bash
SCREEN_DIR="features/{domain}/src/pages/{screen}"

# 1. @master/components 공용 modal 사용 확인 (11 modal 중 1 이상)
rg -c "from '\.\./\.\./\.\./components'" "$SCREEN_DIR"  # ≥ 1 (Form 또는 Grid 안 사용 시)

# 2. CustomDialog 사용 (신규 modal 작성 시)
NEW_MODAL_DIR="features/master/src/components/{newModal}"
test -d "$NEW_MODAL_DIR" && grep -c "CustomDialog" "$NEW_MODAL_DIR/{Name}Modal.tsx"  # ≥ 1

# 3. position='basic' 의무 (CustomDialog 사용 시)
grep -A 5 "<CustomDialog" "$NEW_MODAL_DIR/{Name}Modal.tsx" | grep -c "position='basic'"  # ≥ 1

# 4. height / min-height vh 금지 (CustomDialog SCSS)
grep -nE "min-height: \d+vh|height: \d+vh" "$NEW_MODAL_DIR/{Name}Modal.module.scss"  # = 0

# 5. setSelectedValue callback 표준
grep -A 5 "setSelectedValue=\{" "$SCREEN_DIR" | grep -cE "\(\w+(, \w+)?\)\s*=>"  # ≥ 1

# 6. useMemo preSearchParams (refetch loop 방지)
grep -B 2 "preSearchParams=\{" "$SCREEN_DIR/components/" | grep -c "useMemo"  # ≥ 1 (대부분 화면)

# 7. CRUD_TYPE.INSERT 가드 (Grid modal cell)
GRID="$SCREEN_DIR/components/{Name}Grid.tsx"
test -f "$GRID" && awk '/setOpenModal/,/return/' "$GRID" | grep -c "CRUD_TYPE.INSERT"  # ≥ 1 (modal cell 시)

# 8. Dialog 직접 import 금지
grep -nE "from '@mui/material'.*Dialog\b" "$SCREEN_DIR"  # = 0
```

---

## §8 AS-IS 매핑

| AS-IS popup | TO-BE modal | 매핑 |
|---|---|---|
| `new XxxPopup(); popup.Form_Load(...); popup.ShowDialog()` | `setOpen{X}Modal(true)` + `<{X}Modal open setSelectedValue ... />` | state-based open |
| `popup.SelectedValue` (반환) | `setSelectedValue(value, name?, type?)` callback | callback 형식 |
| `popup.Form_Load(isMultiSelect, p1, p2, ...)` | `preSearchParams={{ ... }}` + `callFromCell?` | props 매핑 |
| Spread cell dblClick → popup | `dblClick` handler → `setOpenModal` (CRUD_TYPE 가드 + binding 매핑) | 룰 07 §1 |
| `cellTypeImage` (popup icon) | column meta `_ctrlType: 'FPModal' + _modalKey` | 룰 08 §1.3 |
| `MessageHelper.GMessageBox` (popup 형식) | `setAlert / setConfirm` (`@shared/hooks`) — modal 아님 | 룰 14 (Phase 4) |

---

## §9 reference file:line 인용

| 패턴 | reference |
|---|---|
| Form 에서 modal 사용 | `CustomerModelMappingForm.tsx:270-283` |
| Grid cell 에서 modal 사용 (CRUD 가드) | `SalesSiteGrid.tsx:98-105, 130-136` |
| 표준 callback 3 단계 | `CustomerModelMappingGrid.tsx:38-61` |
| preSearchParams 의 clicked row 기반 | `CustomerModelMappingGrid.tsx:128-150` |
| 공용 modal index.ts | `nscm-fe/features/master/src/components/index.ts` |

---

## §10 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-03 | 초안 (Phase 3 추출) | DMF0004~7 modal 사용 + 메모리 공용 modal 인벤토리 + 사고 패턴 통합 |

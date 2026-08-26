# Hook — Grid Cell Interaction Patterns (Grid 변형 3 시나리오 + drill-down + 다중 popup + CSV 변환)

> **Trigger**: T01 (신규 화면) + T04 (Grid / Cell interaction)
> **PR 차단 강도**: ⭐⭐⭐ (anti-simplification 동등)
> **신설일**: 2026-06-18 (자가 진화 #27, 사용자 명시 — "DMF0004/0005/0006 cross-check 한번 더")
> **세트 hook**: #60+#61+#62+#63+#64+#65 + **#66 (본 hook)**

## 0. 원칙

DMF0004/0005/0006 의 모든 Grid 변형 (Edit+Popup / drill-down / read-only) 과 Cell 호출 분기 (단일 popup / 다중 popup / drill-down filter set) 표준 정리. **신규 화면 Grid 변형 작성 시 시나리오 선택 의무**.

---

## 1. Grid 변형 3 시나리오 (DMF0004 master)

| 시나리오 | 화면 | 인프라 사용 | Master |
|---|---|---|---|
| **A. Edit + Popup 호출** | DMF0004 SalesSiteCustomerGrid / DMF0006 CustomerModelMappingGrid | editTrackerRef + dblClick + Modal + CRUD_TYPE 분기 | SalesSiteCustomerGrid |
| **B. Edit + Popup + drill-down** | DMF0005 SalesSiteProjectModelGrid | A + setXxxFilter store action 호출 | SalesSiteProjectModelGrid |
| **C. Read-only (편집/popup 없음)** | DMF0004 SalesSiteBucketGrid | gotFocus + setActiveTab 만 | SalesSiteBucketGrid |

### 1.1 시나리오 C — Read-only Grid 최소 시그니처 (DMF0004 SalesSiteBucketGrid master)

```tsx
import { AllowMerging, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';
import type { MENU_ID, SHEETS } from '../xxx.constants';
import { RESPONSE_SET, SHEET_INDEX } from '../xxx.constants';
import { useXxxStore } from '../useXxxStore';

interface XxxBucketGridProps {
  gridRef: MutableRefObject<FlexGrid<...> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.BUCKET, RESPONSE_SET.BUCKET>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const XxxBucketGrid = ({ gridRef, gridFilterRef, data, setActiveTab }: Props) => {
  const staticColumns = useXxxStore(state => state.staticColumns);
  const handleFocus = () => setActiveTab(SHEET_INDEX.BUCKET);

  return (
    <DataGrid<...>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns[RESPONSE_SET.BUCKET] ?? []}
      allowMerging={AllowMerging.ColumnHeaders}   // ⭐ 시계열 read-only 표준
      gotFocus={handleFocus}
    />
  );
};
```

> ⭐ **시나리오 C 최소 구성**: ~40 lines. `editTrackerRef` / `dblClick` / `clickedRow` state / Modal **전부 미사용**. 시계열 데이터 / 마스터 read-only 시 적용.

---

## 2. Drill-down 패턴 (DMF0005 SalesSiteProjectModelGrid master)

Grid 셀 더블클릭 → popup 안 열고 **store 의 `setXxxFilter()` 호출** → 하위 grid 가 `useTabProcQuery` 의 filters 로 자동 fetch:

```tsx
const setPurchaseFilter = useSalesSiteProjectModelStore(s => s.setPurchaseFilter);

const handleDblClick = (mouseEvent: MouseEvent) => {
  const grid = gridRef.current;
  if (!grid) return;
  const ht = grid.hitTest(mouseEvent);
  if (ht.cellType !== CellType.Cell) return;

  const dataItem = GridUtils.getRow(grid, ht.row);
  const binding = GridUtils.getBinding(grid, ht.col);
  if (!dataItem || !binding) return;

  // 1) popup 분기 우선 (DEPT_ID/OWNER/PROJECT_CODE/ITEM_ID 등)
  if (binding === 'DEPT_ID' || binding === 'TEAM_NAME') {
    setClickedRow(ht.row); setOpenTeamModal(true); return;
  }
  // ... 다른 popup 분기

  // 2) ⭐ drill-down — popup 분기 후 + 편집 가능 cell 도 아닌 경우
  if (dataItem?.DIVISION_ID === '40' || GridUtils.isEditableCell(grid, ht.row, ht.col)) return;

  setClickedRow(ht.row);
  setPurchaseFilter({                         // ⭐ store action 호출
    divisionId: dataItem.DIVISION_ID,
    salesSite: dataItem.SCM_SITE_ID,
    projectCode: dataItem.PROJECT_CODE,
    activeFlag: dataItem.VALID_YN,
  });
};
```

### 2.1 Drill-down store action 표준
```ts
// Store
setPurchaseFilter: (filter?: ProcRequest<MENU_ID, SHEETS.PURCHASE>) => {
  set(state => {
    state.filters[SHEETS.PURCHASE] = filter ? { ...filter } : undefined;
  });
},
```

### 2.2 의무 사항
- popup 분기 우선 → drill-down 후 분기 (`return` 의무)
- `GridUtils.isEditableCell` guard — 편집 가능 cell 에서 drill-down 안 함 (사용자 편집 의도와 충돌 방지)
- `dataItem.DIVISION_ID === '40'` 같은 화면 의미별 guard (드릴다운 비대상 division 분기)
- drill-down 호출 = store action 만 — useTabProcQuery 가 자동 refetch

---

## 3. 다중 Popup 분기 (DMF0005 master)

같은 grid 에서 4+ popup 분기 시 표준:

```tsx
const [openTeamModal, setOpenTeamModal] = useState<boolean>(false);
const [openOwnerModal, setOpenOwnerModal] = useState<boolean>(false);
const [openItemModal, setOpenItemModal] = useState<boolean>(false);
const [openProjectModal, setOpenProjectModal] = useState<boolean>(false);
const [ownerOpenByPm, setOwnerOpenByPm] = useState<boolean>(false);   // ⭐ transient — 같은 popup 다른 사용처 구분
const [clickedRow, setClickedRow] = useState(-1);
const clickedDataItem = GridUtils.getRow(gridRef.current, clickedRow);

const handleDblClick = (e) => {
  // ...
  if (binding === 'DEPT_ID' || binding === 'TEAM_NAME') {
    setClickedRow(ht.row); setOpenTeamModal(true); return;
  } else if (binding === 'OWNER' || binding === 'PRJ_OWNR_ID') {
    setClickedRow(ht.row);
    setOwnerOpenByPm(binding === 'PRJ_OWNR_ID');   // ⭐ 같은 popup 분기 — Owner vs PM Owner
    setOpenOwnerModal(true); return;
  } else if (
    dataItem.DIVISION_ID !== '40' &&
    dataItem.CRUD_TYPE === CRUD_TYPE.INSERT &&
    binding === 'PROJECT_CODE'
  ) {
    setClickedRow(ht.row); setOpenProjectModal(true); return;
  } else if (
    dataItem.CRUD_TYPE === CRUD_TYPE.INSERT &&
    dataItem.DIVISION_ID === '40' &&
    ['ITEM_ID', 'ITEM_NAME', 'ITEM_CLASS_NAME'].includes(binding)
  ) {
    setClickedRow(ht.row); setOpenItemModal(true);
  }
  // ...
};
```

### 3.1 의무 사항
- popup 별 `useState` 1 항목 각각 분리 (단일 `openModal: 'team' | 'owner' | ...` discriminated union 안 함)
- `transient state` (예: `ownerOpenByPm`) — 같은 popup 의 다른 호출 위치 구분 시 사용
- 각 분기 끝 `return` — fallthrough 방지
- 분기 조건 = `binding` + `CRUD_TYPE` + 화면 의미 (DIVISION_ID 등) 조합

### 3.2 같은 popup 분기 처리 (`ownerOpenByPm` 패턴)

```tsx
const handleOwnerSelected = (selectedUsers: ResponseData<MODAL_OWNER, 'owner', 'o_rc1'>[]) => {
  if (!clickedDataItem || !selectedUsers) return;

  const owners = selectedUsers.map(item => item.USER_ID).join(',');   // ⭐ CSV 변환

  if (ownerOpenByPm) {
    // PM Owner 분기
    editTrackerRef.current?.storeChange(clickedDataItem, 'PRJ_OWNR_ID', clickedDataItem.PRJ_OWNR_ID, owners);
    clickedDataItem.PRJ_OWNR_ID = owners;
  } else {
    // 일반 Owner 분기
    editTrackerRef.current?.storeChange(clickedDataItem, 'OWNER', clickedDataItem.OWNER, owners);
    editTrackerRef.current?.storeChange(clickedDataItem, 'OWNER_NAME', clickedDataItem.OWNER_NAME, ownersNames);
    clickedDataItem.OWNER = owners;
    clickedDataItem.OWNER_NAME = ownersNames;
  }
  gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
};
```

---

## 4. CSV ↔ 단일 값 변환 표준

### 4.1 다중 선택 popup → CSV string 저장
```tsx
const owners = selectedUsers.map(item => item.USER_ID).join(',');         // CSV
const ownersNames = selectedUsers.map(item => item.USER_NAME_EN).join(',');
```

### 4.2 다중 선택 popup → 단일 값 추출 (DMF0005/0006)
```tsx
const projectCode = projects?.split(',')[0] ?? '';   // ⭐ 단일 값만 추출
const projectName = projectsNames?.split(',')[0] ?? '';
```

### 4.3 의무 사항
- BE 저장 시 CSV string — 다중 선택 결과
- 화면 단일 값만 보존 시 `split(',')[0] ?? ''` fallback
- `null` / `undefined` guard 의무 (`?? ''`)

---

## 5. 다른 화면 popup 의 `ResponseData` 인용 패턴 (DMF0005 OwnerModal)

```tsx
import type { MODAL_OWNER } from '../../../components/ownerModal/owner-modal.constants';

const handleOwnerSelected = (
  selectedUsers: ResponseData<MODAL_OWNER, 'owner', 'o_rc1'>[]   // ⭐ 다른 화면(MODAL_OWNER)의 ResponseData 인용
) => { ... };
```

### 5.1 의무 사항
- 공용 popup 의 응답 type 은 해당 popup 의 `MODAL_XXX` constants 에서 import
- popup 의 `xxx-modal.constants.ts` 가 export 한 MENU_ID 만 인용 가능
- 직접 type 재정의 금지 — 다른 화면 변경 시 동기화 안 됨 사고

---

## 6. Division 정규화 패턴 (DMF0005 fetchStaticColumns L107)

특정 도메인에서 division ID 변환 후 BE 호출:

```ts
fetchStaticColumns: async () => {
  const columnDivision = get().searchParams.divisionId ?? '81';
  const [production, purchase] = await Promise.all([
    apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
      sheetNm: RESPONSE_SET.PRODUCTION,
      divisionId: columnDivision.startsWith('81_') ? '81' : columnDivision,   // ⭐ 정규화
    }),
    ...
  ]);
  // ...
}
```

### 6.1 의무 사항
- division 변환 규칙은 화면별 도메인 의미 (`'81_X'` → `'81'`, `'40_Y'` → `'40'` 등) 명시
- 변환 위치 = `fetchStaticColumns` 또는 `setXxxFilters` (BE 호출 직전)
- 변환 규칙은 AS-IS .cs reference 주석 의무

---

## 7. `staticColumns` 키 분기 — RESPONSE_SET vs SHEETS

### 7.1 RESPONSE_SET 키 (DMF0004 master)
```ts
staticColumns: { [key in RESPONSE_SET]: RawFlexGridColumnConfig[] };
// 사용: staticColumns[RESPONSE_SET.SITE]
```
- ✅ 단일 sheet 가 여러 SP 응답 cursor 로 나뉠 때 (cursor 별 컬럼 메타 다름)
- ✅ RESPONSE_SET enum 값이 SP OUT cursor alias 와 정확 일치

### 7.2 SHEETS 키 (DMF0005 master)
```ts
staticColumns: { [key in SHEETS]: RawFlexGridColumnConfig[] };
// 사용: staticColumns[SHEETS.PRODUCTION]
```
- ✅ sheet 1 = cursor 1 (1:1 매핑)
- ✅ RESPONSE_SET = SHEETS 동일 값일 때 (DMF0005 production/purchase 동일)
- ✅ 가독성 향상

### 7.3 선택 기준
- sheet ↔ cursor 1:1 = SHEETS 키 (DMF0005)
- sheet 1 ↔ cursor N = RESPONSE_SET 키 (DMF0004 SITE → salesSite)

---

## 8. 시나리오별 화면 선택 표 (PRE-WRITE 의무)

신규 Grid 작성 직전 다음 표로 시나리오 결정 + master 참조:

| 화면 의미 | 시나리오 | Master |
|---|---|---|
| 마스터 row 편집 + 필드별 popup 검색 | **A. Edit+Popup** | DMF0004 SalesSiteCustomerGrid / DMF0006 CustomerModelMappingGrid |
| 마스터 + 상세 drill-down (master 더블클릭 → 상세 fetch) | **B. Edit+Popup+drill-down** | DMF0005 SalesSiteProjectModelGrid |
| 시계열 / 통계 / read-only 데이터 표시 | **C. Read-only** | DMF0004 SalesSiteBucketGrid |
| 다중 grid (Tab) | A/B/C 조합 + TabWrapper | DMF0004 SalesSite (Customer A + Location A + Bucket C) |
| 다중 grid (Panel resize) | A + B 또는 A + A | DMF0005 (Production B + Purchase A) |

---

## 9. PRE-WRITE 체크리스트 (Grid 변형 작성 직전 — 10 항목)

```
[ ] 1.  Grid 시나리오 (A/B/C) 결정 + master 참조 명시?
[ ] 2.  시나리오 C (read-only) 시 editTrackerRef/dblClick/clickedRow state/Modal 0?
[ ] 3.  시나리오 B (drill-down) 시 popup 분기 우선 + GridUtils.isEditableCell guard + 화면 의미 guard?
[ ] 4.  다중 popup 분기 시 popup 별 useState 항목 분리 (discriminated union 사용 안 함)?
[ ] 5.  같은 popup 다른 호출 위치 구분 시 transient state (예: ownerOpenByPm)?
[ ] 6.  다중 선택 popup 결과 → CSV string (`join(',')`) 또는 단일 값 (`split(',')[0] ?? ''`) 명시?
[ ] 7.  다른 popup 의 ResponseData 인용 시 해당 popup constants 의 MODAL_XXX import?
[ ] 8.  division 정규화 필요 시 fetchStaticColumns 또는 setXxxFilters 안 명시 + AS-IS 주석?
[ ] 9.  staticColumns 키 = RESPONSE_SET (cursor 1:N) 또는 SHEETS (sheet 1:1) 선택 의식적?
[ ] 10. drill-down 시 store action (setXxxFilter) 만 호출 — 화면 안 fetch 직접 0?
```

---

## 10. POST-WRITE grep (작성 직후 의무)

```bash
SCREEN="nscm-fe/features/{domain}/src/pages/{my-screen}"

# 1. drill-down 시 자체 fetch (useTabProcQuery 화면 안 직접 호출)
grep -nE "useTabProcQuery" "$SCREEN/components/*Grid.tsx"
# 결과 = 0 (Page Shell 안에서만 호출, Grid 안 fetch 0)

# 2. 다중 popup discriminated union 안티 패턴
grep -nE "openModal:\\s*'[a-z]+'\\s*\\|" "$SCREEN"
# 결과 = 0 (각 popup useState 분리)

# 3. CSV 변환 시 fallback 누락
grep -nE "\\.split\\(','\\)\\[0\\][^?]" "$SCREEN" | grep -v "??"
# 결과 = 0 (?? '' fallback 의무)

# 4. read-only grid 인데 editTrackerRef 사용
# (수동 검토 — 시나리오 C 화면에서 useRef<EditTracker> 검출 시 시나리오 재확인)
grep -nE "EditTracker" "$SCREEN/components/*Bucket*Grid.tsx"  # 또는 read-only 화면
# 결과 = 0 (시나리오 C 면)

# 5. 다른 popup ResponseData 인용 시 type import 누락
grep -nE "ResponseData<\\w+,\\s*'\\w+',\\s*'\\w+'>" "$SCREEN" | head
# 결과 — MODAL_XXX 타입 import 확인
```

---

## 11. 안티 패턴 (PR 차단)

| # | 안티 패턴 | 대체 |
|---:|---|---|
| 1 | Read-only grid 인데 `editTrackerRef` / `dblClick` / Modal 코드 작성 | 시나리오 C 최소 시그니처 |
| 2 | drill-down 시 popup 분기 후 `return` 누락 → fallthrough | 각 분기 끝 `return` 의무 |
| 3 | drill-down + 편집 가능 cell 충돌 (isEditableCell guard 누락) | `if (isEditableCell) return;` 가드 의무 |
| 4 | 다중 popup `openModal: 'team' \| 'owner' \| ...` discriminated union | popup 별 `useState<boolean>` 분리 |
| 5 | 같은 popup 다른 사용처 — transient state 없이 분기 | `useState<boolean>` transient + boolean 분기 |
| 6 | 다중 선택 결과 BE 저장 시 `join` 누락 (배열 직접 BE 전송) | `selectedUsers.map(u => u.X).join(',')` CSV |
| 7 | 단일 값 추출 시 `split(',')[0]` 만 (`?? ''` fallback 없음) | `split(',')[0] ?? ''` |
| 8 | 다른 popup 의 ResponseData 직접 type 재정의 | `ResponseData<MODAL_OWNER, 'owner', 'o_rc1'>` import 인용 |
| 9 | division 정규화 화면 분산 (각 호출처마다 작성) | `fetchStaticColumns` 또는 `setXxxFilters` 1 곳에 명시 + AS-IS 주석 |
| 10 | drill-down 시 화면 안 `useTabProcQuery` 직접 호출 | Page Shell 안에서 호출 + Grid 는 store action (setXxxFilter) 만 |
| 11 | `staticColumns` 키 임의 선택 (의도 없음) | RESPONSE_SET (cursor N) vs SHEETS (1:1) 명시적 결정 |
| 12 | popup 호출 시 `setClickedRow + setOpenModal` 2 set 순서 뒤바꿈 | 항상 `setClickedRow(ht.row);` 먼저, `setOpenModal(true);` 다음 |

---

## 12. 관련 hook / 메모리 cross-ref

| 항목 | 참조 |
|---|---|
| Grid 영역 / DataGrid wrap | hook #60 |
| Cell→Popup 4 단계 (단일 popup) | hook #63 §7 |
| Screen Shell + Form + Store + Hook | hook #61 |
| Conventions (폴더 / 명명 / constants) | hook #63 |
| SubTitle 11 버튼 | hook #64 |
| Additional Skills 9 (immer / atomic selector 등) | hook #65 |
| Regression Zero (Hard Boundary + 사고 카탈로그) | hook #62 |
| Master reference 3 (각 시나리오 master) | `nscm-fe/features/master/src/pages/{sales-site, sales-site-project-model, customer-model-mapping}/` |

---

## 13. 검증 — PR 차단 강도

§9 PRE-WRITE 10 + §10 POST-WRITE grep 5 + §11 안티패턴 12 모두 PR 차단.
사용자 cross-check 요청 (2026-06-18 "한번만 더 확인").

---

## ⛔ 병합 판정에 상태를 섞지 말 것 (hook #141)

`MergeManager.getMergedRange()` 의 입력은 **행 데이터뿐**이다. `selectionChanged` / `prepareCellForEdit` / MergeManager 가변 상태 필드로 병합을 바꾸면 **"포커스만 가도 병합이 깨진다"** 가 된다.
허용되는 상태 의존은 `cellEditEnded → invalidate()` 하나뿐.

> 본문 = `Doc/_rules_v2/hooks/wijmo-merge-row-data-only.md` (#141, 2026-08-21 사용자 명시).
> "클릭 시 병합이 풀리고 편집 가능" 류 요구 문구는 **결함 신고일 수 있으므로 구현 전 확인**.

# Hook — Screen Conventions (신규 화면 컨벤션 종합, DMF0004/0005/0006 master)

> **Trigger**: T01 (신규 화면 / 화면 수정) + 모든 화면 영역
> **PR 차단 강도**: ⭐⭐⭐ (anti-simplification 동등) — 위반 시 머지 차단
> **신설일**: 2026-06-18 (자가 진화 #24, 사용자 명시 — "DMF0004/0005/0006 의 기존 개발 방식 따르기 필수")
> **세트 hook**: #60 (Grid) + #61 (Shell) + #62 (Regression Zero) + **#63 (Conventions, 본 hook)**

## 0. 원칙 (불변)

DMF0004 (`sales-site`) / DMF0005 (`sales-site-project-model`) / DMF0006 (`customer-model-mapping`) 3 master 의 폴더 구조 / 명명 / 타입 / 상수 / 유틸 / SCSS / i18n / 폴더 ID 정합 패턴을 **신규 화면이 동일하게 따라야 함**. "한 사람이 개발한 것처럼" 원칙의 구체적 구현 — 한 줄도 임의 변형 금지.

---

## 1. 폴더 구조 표준 (4 master 동일)

```
nscm-fe/features/{domain}/src/pages/{kebab-case-screen}/
├─ {PascalCase}.tsx                  ← 메인 Page (단수, 폴더명 PascalCase 화)
├─ {PascalCase}.module.scss          ← .upperGrid / .lowerGrid 등 flex 비율
├─ {kebab-case-screen}.constants.ts  ← MENU_ID / SHEETS / RESPONSE_SET / SHEET_INDEX
├─ {kebab-case-screen}.types.ts      ← (선택) SearchParamProps + 자체 타입
├─ use{PascalCase}Store.ts           ← camelCase + use prefix + Store suffix
├─ index.ts                          ← export { PascalCase } 1 line only
├─ components/
│  ├─ {PascalCase}Form.tsx           ← 조회조건 (SearchArea wrap)
│  ├─ {PascalCase}Grid.tsx           ← 메인 grid (DataGrid wrap, #60)
│  ├─ {PascalCase}{Detail}Grid.tsx   ← (다중 grid 시) 변형 grid 들
│  └─ modals/                        ← (화면 전용 modal 시)
└─ utils/
   └─ {kebab-case-screen}.util.ts    ← 화면 전용 logic (auto-sync 등)
```

### 1.1 명명 규약 매핑 (4 master 검증 완료)

| 항목 | 형식 | DMF0004 | DMF0005 | DMF0006 |
|---|---|---|---|---|
| 폴더 | kebab-case | `sales-site` | `sales-site-project-model` | `customer-model-mapping` |
| 메인 Page | PascalCase 단수 | `SalesSite.tsx` | `SalesSiteProjectModel.tsx` | `CustomerModelMapping.tsx` |
| Constants | kebab-case + `.constants.ts` | `sales-site.constants.ts` | `sales-site-project-model.constants.ts` | `customer-model-mapping.constants.ts` |
| Types | kebab-case + `.types.ts` | (constants 안 inline) | (constants 안 inline) | `customer-model-mapping.types.ts` ⭐ |
| Store | camelCase + `use` + `Store` | `useSalesSiteStore.ts` | `useSalesSiteProjectModelStore.ts` | `useCustomerModelMappingStore.ts` |
| Module SCSS | PascalCase + `.module.scss` | `SalesSite.module.scss` | `SalesSiteProjectModel.module.scss` | `customer-model-mapping/...` |
| Index barrel | 1 line export | `export { SalesSite } from './SalesSite';` | `export { SalesSiteProjectModel } from './SalesSiteProjectModel';` | `export { CustomerModelMapping } from './CustomerModelMapping';` |

> ⚠️ **연속 대문자 분리 사고 주의** (메모리 `feedback_kebab_case_consecutive_uppercase.md`): `NNMasterMapping` → ❌ `n-n-master-mapping` / ✅ `nn-master-mapping` (NN/EE/UI/ID/AI 등 약어 한 단어 처리). FE 폴더명 ↔ DB MNU_URL 1:1.

### 1.2 화면 ID 4 cross-check 의무

| Layer | DMF0004 예 |
|---|---|
| FE `MENU_ID = '...'` (constants.ts) | `'DMF0004'` |
| FE 폴더명 | `sales-site` |
| Router `ROUTE_PATHS.DMF0004` | `'sales-site'` |
| DB `SCM_ADM_MNU_M.MNU_URL` (leaf slug only, 메모리 `reference_scm_adm_mnu_m_url_slug.md`) | `'sales-site'` |

→ 4개 모두 일치 의무. 1 불일치 = 라우팅 404 또는 메뉴 미표시.

---

## 2. `{kebab-case}.constants.ts` 표준 5 export (DMF0004 master)

```ts
// 1. MENU_ID — string literal type + value 듀얼 export (procedures.d.ts 유니온 매칭용)
export const MENU_ID = 'DMF0004' as const;
export type MENU_ID = typeof MENU_ID;

// 2. SHEETS enum — string value, DB SCM_ADM_SHT_M.SHT_NM 와 1:1 정렬
//    표준: 단일 메인 시트는 'main' 사용 (메모리 `feedback_sheet_name_main_standard.md`)
export enum SHEETS {
  SITE = 'site',
  CUSTOMER = 'customer',
  LOCATION = 'location',
  BUCKET = 'bucket',
}

// 3. RESPONSE_SET enum — string value, SP OUT 커서 alias
//    단일 cursor: 'o_rc1' 표준 (DMF0006 pattern), 다중: RESPONSE_SET enum 명시 (DMF0004 pattern)
export enum RESPONSE_SET {
  SITE = 'salesSite',
  CUSTOMER = 'salesCustomer',
  LOCATION = 'salesLocation',
  BUCKET = 'salesBucket',
}

// 4. SHEET_INDEX enum — numeric (UI 탭 / Panel index)
export enum SHEET_INDEX {
  SITE,
  CUSTOMER,
  LOCATION,
  BUCKET,
}

// 5. (선택) SearchParamProps interface — 자체 타입 (types.ts 분리 가능, DMF0006 패턴)
export interface SearchParamProps {
  divisionId: string;
  endCustomer: string;
  // ...
}
```

### 2.1 의무 사항
- `MENU_ID` 듀얼 export (const + type) — procedures.d.ts 의 유니온 매칭에 필수
- `SHEETS` / `RESPONSE_SET` 둘 다 enum (string value) — type-check + runtime 모두 활용
- `SHEET_INDEX` numeric enum — 탭/Panel index 와 1:1
- DB SCM_ADM_SHT_M.SHT_NM ↔ FE SHEETS 값 정확 일치 의무 — type 통과해도 BE 0 row 사고 (메모리 `feedback_fe_cloud_type_lint_readiness.md` §1)

### 2.2 단일 cursor SP 패턴 (DMF0006 master)
```ts
// 단일 sheet 화면 — RESPONSE_SET 미정의 시 SP 응답 = data?.o_rc1
export enum RESPONSE_SET {
  DATA = 'o_rc1',  // ← SP OUT cursor 표준 alias
}
// 사용: data?.o_rc1.filter(...)
```

---

## 3. `{kebab-case}.types.ts` 표준 (선택, DMF0006 master)

자체 타입이 많을 때 constants.ts 와 분리:

```ts
// customer-model-mapping.types.ts
export interface SearchParamProps {
  divisionId: string;
  deptId: string;
  endCustomer: string;
  // ...
}
```

> ⚠️ 글로벌 타입 (`PageProps<M>` / `ResponseData<M, S>` / `ProcRequest<M, S>` / `ProcResponse<M, S>` / `RawFlexGridColumnConfig` / `WijmoRowItem`) 은 **import 불필요** — `nscm-fe/configs/types/*.d.ts` 가 global 선언. 화면별 type 만 자체 정의.

---

## 4. `utils/{kebab-case}.util.ts` 표준 (DMF0004 master `applySalesSite`)

화면 전용 logic (auto-sync / 데이터 변환 등):

```ts
import type { EditTracker } from '@foundation/utils';
import type { MENU_ID, SHEETS } from '../{kebab-case}.constants';

const buildSalesSite = (row: WijmoRowItem) => {
  // 1. 데이터 정규화 — ?? '' fallback + trim + slice 등
  const country = String(row['COUNTRY'] ?? '').trim().slice(0, 2);
  // ⭐ AS-IS reference 주석 + DB 검증 결과 의무
  // B4 fix (Phase 7 적용, 2026-06-04): DB SCM_MST_SITE.CITY 가 5-char 합성 코드.
  // AS-IS DMF0004_SalesSite.cs L2565~2567 의 City.Substring(2,3) 동등.
  const city = String(row['CITY'] ?? '').trim().slice(2, 5);
  if (!soldToCustomer || !country || !city) return '';
  return `${soldToCustomer}_${country}_${city}`;
};

// ⭐ 표준 시그니처 — ResponseData 제네릭 + editTracker?.storeChange 의무
export const applySalesSite = <
  T extends ResponseData<MENU_ID, SHEETS.CUSTOMER> | ResponseData<MENU_ID, SHEETS.SITE>,
>(
  row: T,
  editTracker?: EditTracker<T>
) => {
  const next = buildSalesSite(row);
  editTracker?.storeChange(row, 'SCM_SITE_ID', row['SCM_SITE_ID'], next);  // ⭐ EditTracker 의무
  row['SCM_SITE_ID'] = next;  // ⭐ dataItem 할당 (refreshRange 는 호출자가)
};
```

### 4.1 의무 사항
- 데이터 변환 시 `String(value ?? '')` fallback (메모리 `feedback_fe_string_undefined_cast_guard.md`)
- 셀 값 변경 시 `editTracker?.storeChange()` 호출 — CRUD_TYPE='U' 자동 + dirty flag (메모리 `feedback_sp_cursor_reassignment_overwrite.md` 와 별개로 FE side)
- AS-IS reference 주석 + DB 검증 결과 / Phase 적용 일자 + 작성자 (메모리 `feedback_asis_to_tobe_sp_no_omission.md` 동등 강도)
- 제네릭 `<T extends ResponseData<MENU_ID, SHEETS.X> | ...>` 명시

---

## 5. `{PascalCase}.module.scss` 표준

### 5.1 다중 grid 비율 layout (DMF0004 master)
```scss
.upperGrid {
  height: 0;        // ⭐ flex container 내부 fill 강제
  flex-grow: 5;     // 비율 (master : detail = 5 : 3)
}
.lowerGrid {
  height: 0;
  flex-grow: 3;
}
```

### 5.2 의무 사항
- `height: 0` + `flex-grow: N` 패턴 — flex parent 안 vertical fill
- inline style (`style={{ ... }}`) 절대 금지 (메모리 #62 사고 #17)
- 자체 SCSS variable 정의 시 `@lges/design-system/design-token` 우선 활용

---

## 6. `index.ts` barrel 표준 (3 master 동일)

```ts
export { SalesSite } from './SalesSite';
```

- **1 line only** — re-export 메인 컴포넌트만
- 추가 export 금지 (types / constants / utils 등은 화면 내부만)
- `@master/{folder}` alias 가 자동으로 이 export 만 노출 — `import { SalesSite } from '@master/sales-site'`

---

## 7. Grid 변형 컴포넌트 4 props 표준 (DMF0004 SalesSiteCustomerGrid master)

다중 grid 화면에서 각 Grid 컴포넌트의 표준 props:

```ts
interface XxxGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.X, RESPONSE_SET.Y>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.X, RESPONSE_SET.Y>[];
  setActiveTab: (tab: SHEET_INDEX) => void;  // ⭐ Tab/Panel 다중 grid 시 의무
}
```

### 7.1 Grid 내부 표준 (Cell → Popup 호출 패턴)

```tsx
const editTrackerRef = useRef<EditTracker<RowT>>();
const filters = useXxxStore(s => s.filters);
const staticColumns = useXxxStore(s => s.staticColumns);

const [clickedRow, setClickedRow] = useState(-1);  // ⭐ 표준 state
const [openXxxModal, setOpenXxxModal] = useState(false);

// ⭐ Modal 결과 set 패턴 — editTracker.storeChange + dataItem 할당 + refreshRange
const setXxx = (a: string, b: string, ...) => {
  const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
  if (!dataItem || dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;   // ⭐ CRUD_TYPE 분기 의무

  editTrackerRef.current?.storeChange(dataItem, 'A', dataItem.A, a);
  editTrackerRef.current?.storeChange(dataItem, 'B', dataItem.B, b);
  dataItem.A = a;
  dataItem.B = b;
  gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));  // ⭐ row 전체 refresh
};

const handleFocus = () => setActiveTab(SHEET_INDEX.CUSTOMER);

const handleDblClick = (mouseEvent: MouseEvent) => {
  const grid = gridRef.current;
  if (!grid) return;
  const ht = grid.hitTest(mouseEvent);
  if (ht.cellType !== CellType.Cell) return;

  const dataItem = GridUtils.getRow(grid, ht.row);
  const binding = GridUtils.getBinding(grid, ht.col);
  if (!dataItem || !binding) return;

  if (
    dataItem.CRUD_TYPE === CRUD_TYPE.INSERT &&    // ⭐ Insert 시에만 modal 활성
    (binding === 'SOLDTO_CODE' || binding === 'SHIPTO_CODE')
  ) {
    setClickedRow(ht.row);
    setOpenXxxModal(true);
  }
};

return (
  <>
    <DataGrid<ResponseData<MENU_ID, SHEETS.X, RESPONSE_SET.Y>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns[RESPONSE_SET.Y] ?? []}
      gotFocus={handleFocus}
      dblClick={handleDblClick}
    />
    <XxxModal
      open={openXxxModal}
      modalClose={() => setOpenXxxModal(false)}
      setSelectedValue={setXxx}
      divisionId={filters[SHEETS.SITE]?.divisionId ?? ''}
      a={GridUtils.getRow(gridRef.current, clickedRow)?.A_DESCRIPTION}  // ⭐ optional chain
    />
  </>
);
```

### 7.2 의무 사항
- `<DataGrid<ResponseData<...>>>` 3 인자 제네릭 (MENU_ID + SHEETS.X + RESPONSE_SET.Y) 명시
- `clickedRow` state + `setOpenModal` state 분리
- Modal callback 4 단계: editTracker.storeChange → dataItem 할당 → refreshRange(CellRange row 전체 -1) → CRUD_TYPE.INSERT 분기
- `GridUtils.getRow` / `getBinding` 의무 (직접 `grid.rows[row].dataItem` 금지)

---

## 8. 글로벌 타입 표준 (자동 선언, import 불필요)

`nscm-fe/configs/types/*.d.ts` 가 다음 글로벌 타입 선언:

| 타입 | 용도 |
|---|---|
| `PageProps<M extends MenuId>` | 화면 entry: `{ tabId: string; title: string }` |
| `ProcRequest<M, S>` | SP IN 파라미터 (sheet 별 자동 추론) |
| `ProcResponse<M, S>` | SP OUT 응답 (sheet 별 자동 추론) |
| `ResponseData<M, S, RS?>` | SP 응답 단일 row 타입 |
| `RawFlexGridColumnConfig` | admin 동적 column meta |
| `WijmoRowItem` / `WijmoPrimitive` | Wijmo grid row 공통 |
| `ResponseKeys<M, S>` | RESPONSE_SET 유니온 |

```tsx
// 화면 안 사용 예
export const SalesSite = ({ tabId, title }: PageProps<MENU_ID>) => { ... };
const { data } = useTabProcQuery<MENU_ID, SHEETS.SITE>({ ... });  // data: ProcResponse 자동
```

> ⛔ `import type { PageProps, ResponseData, ... } from '@foundation/...';` 작성 금지 — 글로벌 자동 선언으로 충분. 시도 시 lint fail.

---

## 9. i18n 키 표준 (메모리 `feedback_i18n_lbl_code_pattern.md` 동기화)

| Prefix | 용도 | 예 |
|---|---|---|
| `LBL00xxx` (5 자리) | UI 라벨 | `t('LBL00001', '_Div.')` / `t('LBL00112', '_Search')` |
| `MSG00xxx` | 메시지/alert | `t('MSG00013', '_필수값을 입력하세요.')` |
| `BTN00xxx` | 버튼 텍스트 | (드물 — 보통 LBL) |
| `TITLE00xxx` | 모달/팝업 타이틀 | |
| `PLH00xxx` | placeholder | |
| `TOOLTIP00xxx` | 툴팁 | |
| `MNU_*` | 메뉴 트리 | `t(menu.mnuMsgId, menu.mnuDesc)` |

### 9.1 의무 사항
- 자유 형식 키 (`LBL_DMF0020_DIV`, `LBL_COMMON_SEARCH` 등) 절대 금지 — 메모리 `feedback_i18n_lbl_code_pattern.md`
- 기존 공용 코드 재사용 전 KO.json 등록 의미 cross-check (DMF0020 LBL00026 충돌 사고)
- 신규 영역은 KO.json 최대 + 100-block 단위 (예: 화면 X = LBL00501~514)
- `t('keyId', 'fallback')` 2 인자 형식 의무 — fallback 영문 = 캡쳐 일치

---

## 10. `@foundation/constants` 표준 활용

```ts
import { CRUD_TYPE, CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE, BUTTON_TYPE } from '@foundation/constants';

// ❌ 금지: dataItem.CRUD_TYPE === 'I'
// ✅ 의무: dataItem.CRUD_TYPE === CRUD_TYPE.INSERT
```

| Enum | 값 |
|---|---|
| `CRUD_TYPE` | `INSERT='I'` / `UPDATE='U'` / `DELETE='D'` |
| `CELL_CONTROL_TYPE` | `TEXT` / `COMBO` / `MODAL` / `CHECK` 등 14종 (메모리) |
| `CELL_INPUT_EDIT_TYPE` | `STATIC='S'` / `OPTIONAL='O'` / `MANDATORY='M'` / `OPTIONAL_INSERT_ONLY='IO'` / `MANDATORY_INSERT_ONLY='IM'` 5종 (메모리 `feedback_input_tp_cd_im_standard.md`) |
| `BUTTON_TYPE` | `SEARCH='S'` / `SAVE='SAVE'` / `COMBO='C'` / `LOOKUP='L'` 등 |

> ⛔ 화면 안 literal `'I'` / `'U'` / `'D'` 사용 금지. `CRUD_TYPE.INSERT` 등 의무.

---

## 11. `'ALL'` Sentinel 표준 (combo / cascade)

```ts
// searchParams 의 'ALL' = 전체 선택 sentinel
const initSearchParams: SearchParamProps = {
  divisionId: useSessionStore.getState().session.div ?? '40',  // ← 로그인 division default
  endCustomer: 'ALL',
  salesSite: 'ALL',
  activeFlag: 'ALL',
};

// cascade reset 시 부모 변경 → 자식 'ALL' (cascade-combo-filter #59)
setSearchParams({ divisionId: newDiv, endCustomer: 'ALL', salesSite: 'ALL' });

// BE 호출 시 filter 의미: 'ALL' = 전체 (BE SP 안 '%' 또는 NVL 처리)
```

---

## 12. Session 활용 표준

```ts
import { useSessionStore } from '@shared/stores';

// 1. 로그인 division 초기값 (store init)
divisionId: useSessionStore.getState().session.div ?? '40',

// 2. 메뉴 트리 walk-up (MainTitle 자동, breadcrumb)
const { findMenuPath, toggleFavorite } = useSessionStore();

// 3. 권한 분기 (필요 시)
const userId = useSessionStore.getState().session.user_id;
```

> ⛔ `localStorage.getItem('div')` 등 직접 접근 금지 — `useSessionStore` 의무.

---

## 13. SP 응답 매핑 표준

### 13.1 단일 sheet 화면 (DMF0006 master)
```ts
// constants.ts
export enum RESPONSE_SET { DATA = 'o_rc1' }

// Screen
const { data } = useTabProcQuery<MENU_ID>({ menuId, sheetName: SHEETS.X, tabId, filters });
const rows = data?.o_rc1 ?? [];  // ⭐ default cursor alias
```

### 13.2 다중 sheet 화면 (DMF0004 master)
```ts
// constants.ts
export enum RESPONSE_SET {
  SITE = 'salesSite',
  CUSTOMER = 'salesCustomer',
  // ...
}

// Screen
const { data: siteData } = useTabProcQuery<MENU_ID, SHEETS.SITE>({ ... });
const rows = siteData?.salesSite ?? [];  // ⭐ RESPONSE_SET.SITE 값 사용
```

### 13.3 SAVE 후 invalidate 자동 — `useProcMutation` 의 onSuccess 가 처리
별도 `queryClient.invalidateQueries` 호출 금지 (중복 fetch).

---

## 14. PRE-WRITE 체크리스트 (신규 화면 작성 직전 — 14 항목)

```
[ ] 1.  폴더 구조 §1 4 master 패턴 일치 (kebab-case 폴더 + PascalCase 메인 + components/ + utils/ + index.ts)
[ ] 2.  명명 매핑 §1.1 표 4 행 일치 (특히 NN/EE/UI 연속 대문자 약어 한 단어 처리)
[ ] 3.  화면 ID 4 cross-check §1.2 (MENU_ID = 폴더 = ROUTE_PATHS = DB MNU_URL)
[ ] 4.  constants.ts 5 export §2 (MENU_ID 듀얼 + SHEETS string + RESPONSE_SET string + SHEET_INDEX numeric)
[ ] 5.  SHEETS 값 ↔ DB SCM_ADM_SHT_M.SHT_NM 1:1 정렬 (단일 sheet 시 'main' 표준)
[ ] 6.  글로벌 타입 (PageProps/ResponseData/ProcRequest 등) import 0 — 자동 선언
[ ] 7.  utils/*.util.ts 화면 전용 logic — String(value ?? '') fallback + editTracker.storeChange 의무 + AS-IS reference 주석
[ ] 8.  module.scss `height: 0 + flex-grow: N` 패턴 (다중 grid 비율 시) — inline style 0
[ ] 9.  index.ts 1 line export only
[ ] 10. Grid 변형 컴포넌트 4 props (gridRef / gridFilterRef / data / setActiveTab) 표준
[ ] 11. Cell→Popup 호출 4 단계 (clickedRow state + setOpenModal + editTracker.storeChange + refreshRange + CRUD_TYPE.INSERT 분기)
[ ] 12. i18n 키 `LBL00xxx` 5자리 / `MSG00xxx` / 카테고리 prefix — 자유 형식 금지
[ ] 13. `@foundation/constants` enum 사용 (CRUD_TYPE / CELL_CONTROL_TYPE / CELL_INPUT_EDIT_TYPE / BUTTON_TYPE) — literal 금지
[ ] 14. 'ALL' sentinel + session.div ?? '40' default + useSessionStore 의무
```

---

## 15. POST-WRITE grep (작성 직후 의무)

```bash
SCREEN="nscm-fe/features/{domain}/src/pages/{my-screen}"

# 1. literal CRUD_TYPE 사용 (== 'I' / 'U' / 'D')
grep -nE "CRUD_TYPE\\s*[!=]==?\\s*'[IUD]'" "$SCREEN"
# 결과 = 0 — CRUD_TYPE.INSERT 등 의무

# 2. 글로벌 타입 import (불필요)
grep -nE "import type \\{[^}]*\\b(PageProps|ResponseData|ProcRequest|ProcResponse|RawFlexGridColumnConfig|WijmoRowItem)\\b" "$SCREEN"
# 결과 = 0 — 자동 선언

# 3. inline style
grep -nE 'style=\\{\\{' "$SCREEN"
# 결과 = 0

# 4. localStorage 직접 접근
grep -nE "localStorage\\.(getItem|setItem)" "$SCREEN"
# 결과 = 0 — useSessionStore 의무

# 5. constants.ts MENU_ID 듀얼 export
grep -nE "export (const|type) MENU_ID" "$SCREEN/{kebab-case}.constants.ts"
# 결과 = 2 (const + type)

# 6. index.ts 1 line check
wc -l "$SCREEN/index.ts"
# 결과 = 1

# 7. i18n 자유 형식 키 검출
grep -nE "t\\('LBL_[A-Z]+|t\\('MSG_[A-Z]+|t\\('BTN_[A-Z]+" "$SCREEN"
# 결과 = 0 — LBL00xxx / MSG00xxx 5자리 의무
```

---

## 16. 안티 패턴 (PR 차단)

| # | 안티 패턴 | 사고 / 메모리 |
|---:|---|---|
| 1 | `MENU_ID` const 만 export (type 누락) | procedures.d.ts 유니온 매칭 fail |
| 2 | `SHEETS` 를 `as const` 객체로 정의 (enum 미사용) | runtime 값 추론 깨짐 |
| 3 | RESPONSE_SET 정의 없이 `data?.salesSite` 하드코딩 | 단일 cursor SP 와 다중 cursor SP 패턴 혼선 |
| 4 | utils 에서 `dataItem.X = value` 직접 (editTracker.storeChange 누락) | SAVE diff 손실 (메모리 `feedback_fe_grid_visible_no_fallback_loss.md` 와 별개로 변경 누락) |
| 5 | utils 안 AS-IS reference 주석 0 | 향후 fix 시 의도 손실 (anti-simplification 동등) |
| 6 | inline style `style={{ ... }}` | SCSS Module 표준 깨짐 |
| 7 | index.ts 다중 export (types / constants 등) | barrel 표준 깨짐 + alias 노출 의도 위반 |
| 8 | Grid 변형 컴포넌트 props 누락 (`setActiveTab` / `gridFilterRef`) | Tab/Panel 다중 grid 시 활성 분기 깨짐 |
| 9 | Cell→Popup 패턴 4 단계 누락 (refreshRange / CRUD_TYPE 분기) | 사용자 입력 미반영 + 비활성 row modal 열림 |
| 10 | 글로벌 타입 `import type { PageProps }` | lint fail (자동 선언) |
| 11 | i18n 자유 형식 키 (`LBL_DMF0020_DIV`) | KO.json 인덱스 충돌 (메모리) |
| 12 | `CRUD_TYPE === 'I'` literal | enum 표준 깨짐 |
| 13 | `localStorage.getItem('div')` 직접 | useSessionStore 우회 → 다른 화면 동기화 깨짐 |
| 14 | constants.ts 의 enum 값 ↔ DB SHT_NM 불일치 | BE 0 row 사고 |
| 15 | PascalCase 폴더명 또는 snake_case 폴더명 | kebab-case 표준 깨짐 — feature alias resolve fail |
| 16 | 폴더명 ↔ DB MNU_URL 불일치 | 메뉴 클릭 404 (메모리 `feedback_kebab_case_consecutive_uppercase.md`) |

---

## 17. 신규 화면 작성 시 4 master 비교 의무

신규 화면 작성 직전 다음 3 화면 폴더를 **반드시 cross-check**:

```bash
# 1. DMF0004 (Tab + 다중 grid + RegionModal/CustomerModal cell 호출)
cat nscm-fe/features/master/src/pages/sales-site/SalesSite.tsx
cat nscm-fe/features/master/src/pages/sales-site/sales-site.constants.ts
cat nscm-fe/features/master/src/pages/sales-site/useSalesSiteStore.ts
cat nscm-fe/features/master/src/pages/sales-site/utils/sales-site.util.ts

# 2. DMF0005 (Panel + 다중 popup InputField → Project/Item/Owner)
cat nscm-fe/features/master/src/pages/sales-site-project-model/SalesSiteProjectModel.tsx

# 3. DMF0006 (단일 grid, RESPONSE_SET='o_rc1')
cat nscm-fe/features/master/src/pages/customer-model-mapping/CustomerModelMapping.tsx
```

상응하는 시나리오 (단일 / Tab / Panel) 의 master 를 baseline 으로 동일 패턴 적용.

---

## 18. 관련 hook / 메모리 cross-ref

| 항목 | 참조 |
|---|---|
| Grid 영역 표준 | hook `datagrid-shared-component-mandatory.md` (#60) |
| Page Shell + Form + Hook + Store | hook `screen-shell-composition-mandatory.md` (#61) |
| Type/Lint 0 + Hard Boundary | hook `regression-zero-mandatory.md` (#62) |
| FE Import 경로 인벤토리 | `fe-import-check.md` (auto-attach) |
| i18n LBL 5자리 표준 | 메모리 `feedback_i18n_lbl_code_pattern.md` |
| INPUT_TP_CD 'IM' 표준 | 메모리 `feedback_input_tp_cd_im_standard.md` |
| SHEETS 'main' 표준 | 메모리 `feedback_sheet_name_main_standard.md` |
| 폴더명 ↔ MNU_URL 1:1 | 메모리 `feedback_kebab_case_consecutive_uppercase.md` + `reference_scm_adm_mnu_m_url_slug.md` |
| String(value) guard | 메모리 `feedback_fe_string_undefined_cast_guard.md` |
| Master reference 경로 | `nscm-fe/features/master/src/pages/{sales-site, sales-site-project-model, customer-model-mapping}/` |

---

## 19. 검증 — PR 차단 강도

§14 PRE-WRITE 14 + §15 POST-WRITE grep 7 + §17 4 master cross-check 의무.
§16 안티패턴 16종 모두 PR 차단 (anti-simplification 동등 강도).
사용자 결정 (2026-06-18, 필수 항목).

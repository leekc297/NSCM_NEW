# Hook — FE 클라우드 type-check + lint 통과 의무

> ⭐ **사용자 명시 사고 (2026-06-12)**:
> 사내 환경 build pass 됐으나 클라우드 환경 `pnpm type-check` / `pnpm lint` 실행 시 9 errors 발생.
> 사내↔클라우드 type 의 generated file (procedures.d.ts) 동기화 + ESLint 룰 정합 필수.

작성: 2026-06-12 (DMF0020 클라우드 이관 후 type-check + lint errors fix 사고)
상위 룰: `anti-simplification.md`
관련 룰: `_tobe/01_file_structure.md` / `_tobe/05_constants.md` (SHEETS enum)

---

## §0. 트리거

| 트리거 | 적용 시점 |
|---|---|
| 신규 화면 작성 (T01) | PRE-WRITE + POST-WRITE |
| 클라우드 이관 패키지 작성 (T18 deploy) | PRE-SUBMIT 의무 |
| Wijmo `<FlexGrid>` 직접 사용 | POST-WRITE |
| `Ref<T>.current` 할당 (Wijmo initialized) | PRE-WRITE |

---

## §1. SHEETS enum = procedures.d.ts 유니온 정확 일치 (의무)

### 1.1 사고 패턴 (DMF0020)
```ts
// ❌ 사내 환경 적용 — 클라우드 procedures.d.ts 유니온 불일치
export enum SHEETS {
  EXCHANGE = 'exchangeRate',       // 클라우드 union: 'exchange'
  PRICE_BATCH = 'priceBatchInput', // 클라우드 union: 'priceBatch'
}
// → TS2820 "Type 'SHEETS.EXCHANGE' is not assignable to ... 'exchange'"
```

### 1.2 의무 패턴
```ts
// ✅ 클라우드 procedures.d.ts 유니온과 정확 일치
export enum SHEETS {
  MAIN = 'main',
  EXCHANGE = 'exchange',     // BE 등록 SHT_NM 도 'exchange' (둘 다 정렬)
  PRICE_BATCH = 'priceBatch',
}
```

### 1.3 DB SHT_NM 정렬 (동시 의무)
- `SCM_ADM_MNU_BTN_MPG_M.SHT_NM` = FE `SHEETS` 값 정확 일치
- `SCM_ADM_USER_GR_MNU_BTN_MPG_M.SHT_NM` = 동일
- `SCM_ADM_API_M.API_ID` = `{MENU_ID}_{SHT_NM}_{BTN_CD}` 패턴 정렬

### 1.4 PRE-WRITE 의무
- [ ] 클라우드 `nscm-fe/configs/types/procedures.d.ts` 확인 (또는 BE 가 자동 generate 한 union)
- [ ] FE `SHEETS` enum 값 정확 일치 (case-sensitive)
- [ ] DB SCM_ADM_MNU_BTN_MPG_M.SHT_NM 정렬

---

## §2. Wijmo `Ref<T>.current` 할당 — type guard + cast 의무

### 2.1 사고 패턴
```ts
// ❌ Ref<T> 의 current 는 readonly
<FlexGrid initialized={(g) => {
  if (gridRef && 'current' in gridRef) {
    gridRef.current = g;   // TS2540 Cannot assign to 'current' because it is a read-only property
  }
}} />
```

### 2.2 의무 패턴
```ts
// ✅ type guard + mutable cast
<FlexGrid initialized={(g: FlexGridType<Row>) => {
  if (gridRef && typeof gridRef === 'object' && 'current' in gridRef) {
    (gridRef as { current: FlexGridType<Row> | null }).current = g;
  }
}} />
```

또는 callback ref 사용:
```ts
<FlexGrid initialized={typeof gridRef === 'function' ? gridRef : (g) => { /* ... */ }} />
```

---

## §3. Wijmo imports 순서 (ESLint `import/order` 의무)

### 3.1 사고 패턴
```ts
// ❌ react.grid 가 wijmo.grid 보다 먼저 → import/order error
import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { CellRange, CellType, /* ... */ } from '@mescius/wijmo.grid';
import { toggleClass } from '@mescius/wijmo';
```

### 3.2 의무 패턴 (알파벳 정렬)
```ts
// ✅ wijmo (base) → wijmo.grid → wijmo.react.grid
import { toggleClass } from '@mescius/wijmo';
import { CellRange, CellType, /* ... */ } from '@mescius/wijmo.grid';
import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
```

⚠ `@mescius/wijmo.grid.filter` 도 동일 순서 — 모든 `@mescius/wijmo*` 패키지 알파벳.

### 3.3 sibling imports 순서 (같은 그룹)
```ts
// ✅ ./components/modals/{알파벳} → ./components/{알파벳} → ./hooks → ./constants → ./types → ./styles → ./store
import { ExchangeRateModal } from './components/modals/ExchangeRateModal';
import { PriceBatchInputModal } from './components/modals/PriceBatchInputModal';
import { SalesPriceVersionModal } from './components/modals/SalesPriceVersionModal';
import { SalesFuturePriceFlexGrid } from './components/SalesFuturePriceFlexGrid';
import { SalesFuturePriceForm } from './components/SalesFuturePriceForm';
import { useSalesFuturePriceValidation } from './hooks/useSalesFuturePriceValidation';
import { type BUCKET_TYPE, MAIN_COLUMNS, MENU_ID, SHEETS } from './sales-future-price.constants';
import type { FuturePriceRow } from './sales-future-price.types';
import styles from './SalesFuturePrice.module.scss';
import { useSalesFuturePriceStore } from './useSalesFuturePriceStore';
```

⚠ `import` group 사이 빈 줄 1개만, group 안 빈 줄 X.

---

## §4. inline type import (`@typescript-eslint/consistent-type-imports`)

### 4.1 사고 패턴
```ts
// ❌ BUCKET_TYPE 이 type 으로만 사용되면 → error
import { BUCKET_TYPE, MAIN_COLUMNS, MENU_ID } from './constants';
const x: BUCKET_TYPE = ...;   // value 사용 안 함
```

### 4.2 의무 패턴
```ts
// ✅ inline type import — value/type 혼용 시
import { type BUCKET_TYPE, MAIN_COLUMNS, MENU_ID } from './constants';
```

또는 분리:
```ts
import type { BUCKET_TYPE } from './constants';
import { MAIN_COLUMNS, MENU_ID } from './constants';   // 두 import 분리
```

---

## §5. 불필요 `as` cast 제거 (`@typescript-eslint/no-unnecessary-type-assertion`)

### 5.1 사고 패턴 (DMF0020)
```ts
// ❌ 이미 같은 타입 → 불필요
const gid = sel.INSERT_GROUP_ID as string | undefined;   // 이미 string | undefined
const spRows = ((data?.o_rc1 ?? []) as FuturePriceRow[]);  // 이미 동일 타입
(e.cell as HTMLElement).style.textAlign = 'center';   // Wijmo cell 이미 HTMLElement
const ht = g.hitTest(ev as MouseEvent);   // ev 이미 MouseEvent (dblclick handler)
const cellsRoot = root.querySelector('.wj-cells') as HTMLElement | null;   // 이미 Element | null
```

### 5.2 의무 패턴
```ts
// ✅ cast 제거
const gid = sel.INSERT_GROUP_ID;
const spRows = (data?.o_rc1 ?? []);
e.cell.style.textAlign = 'center';
const ht = g.hitTest(ev);
const cellsRoot = root.querySelector('.wj-cells');
```

⚠ 단 정말 type narrowing 필요한 경우 (예: `unknown` → 구체 타입) 는 유지.

---

## §6. PRE-WRITE 자기 점검 (모두 ✓ 필수)

- [ ] FE `SHEETS` enum 값 = 클라우드 `procedures.d.ts` SheetName 유니온 정확 일치?
- [ ] DB `SCM_ADM_MNU_BTN_MPG_M.SHT_NM` = FE SHEETS 값 동일?
- [ ] Wijmo `<FlexGrid initialized={...}>` 안 ref 할당 시 type guard + mutable cast 패턴?
- [ ] Wijmo imports 순서: `wijmo` → `wijmo.grid` → `wijmo.react.grid`?
- [ ] sibling imports 알파벳 정렬 + 그룹 사이 빈 줄 1개?
- [ ] value/type 혼용 import 는 `import { type X, Y }` inline?
- [ ] 불필요 `as cast` 모두 제거?

---

## §7. POST-WRITE 검증 (사내 환경 명령)

```bash
cd nscm-fe/features/{domain}

# type-check (사내)
pnpm type-check    # tsc --noEmit

# lint
pnpm exec eslint src --quiet   # errors 만 표시 (warnings 무시)

# 클라우드 환경 정합 가능 시
pnpm exec eslint src --fix    # auto-fix import/order + no-unnecessary-as
```

⚠ `pnpm install` 자동 호출 금지 (메모리 `feedback_pnpm_install_avoidance`). `pnpm exec eslint` 만 사용.

---

## §8. PRE-SUBMIT 의무 (클라우드 이관 패키지)

- [ ] 사내 `pnpm type-check` PASS 확인
- [ ] 사내 `pnpm exec eslint src` errors 0 건 (warnings 가능)
- [ ] 클라우드 `procedures.d.ts` 확인 — FE `SHEETS` 일치
- [ ] DB SCM_ADM_MNU_BTN_MPG_M.SHT_NM 정렬 SQL 포함
- [ ] 이관 README §3 적용 순서에 type-check 명시

---

## §9. anti-pattern 사고 사례

### 9.1 DMF0020 SHT_NM 명명 불일치 (2026-06-12)
- 사내: `'exchangeRate'` / `'priceBatchInput'` 등록 → 동작 OK
- 클라우드: procedures.d.ts 유니온 `'exchange'` / `'priceBatch'` → TS2820
- fix: FE SHEETS enum 값 + DB SHT_NM 둘 다 클라우드 유니온 정렬

### 9.2 Ref<T>.current 직접 할당 (DMF0020 SalesFuturePriceFlexGrid)
- `gridRef.current = g;` → TS2540 (Ref 의 current 는 readonly)
- fix: type guard + mutable cast

### 9.3 import/order 8건 (DMF0020 4 파일)
- 외부 wijmo 패키지 순서 + sibling 알파벳 누락
- fix: 일괄 정렬

### 9.4 불필요 as cast (DMF0020 11건)
- `(e.cell as HTMLElement)` × 5 / `gridRef as { current: ... }` / `sel.X as string | undefined` 등
- fix: 제거

### 9.5 type-only import 미사용
- `BUCKET_TYPE` 가 type 으로만 사용되는데 value import → consistent-type-imports error
- fix: `import { type BUCKET_TYPE, ... }`

---

## §10. Cross-ref

- 룰 02_imports — Import alias + 정확 export 인벤토리
- 룰 05_constants — SHEETS enum / MENU_ID / RESPONSE_SET
- 룰 12_metadata_sql §13 — MNU_BTN_CD 표준
- hook `runtime-error-prevention.md` — 런타임 오류 방지
- hook `pre-submit.md` — PR 직전 의무
- 메모리:
  - `feedback_pnpm_install_avoidance.md` — pnpm install/i/type-check/build 자동 호출 금지
  - `feedback_runtime_error_prevention.md` — alias / 정확 export

---

## §11. 위반 시 대응

- 클라우드 type-check 실패 = build 차단
- 사내 환경에서 못 잡은 사고 = anti-simplification 위반 (사내↔클라우드 정합 의무 누락)
- 이관 패키지 작성 후 클라우드 환경 검증 의무

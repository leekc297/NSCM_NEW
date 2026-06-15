# Cloud PC 전용 — `features/master/src/pages/erp-edi-master/` 추가 fix 가이드

cloud 의 어제 분리 작업으로 추가된 5 file (이 PC 에는 없음). cloud PC 에서 직접 수정 필요.

## 영향 file (cloud 전용)

```
features/master/src/pages/erp-edi-master/components/
  ├── ErpEdiMasterRepairGrid.tsx       (1 error)
  ├── ErpEdiMasterSalesSiteGrid.tsx    (3 errors)
  ├── ErpEdiMasterSspmGrid.tsx         (1 error)
  └── ErpEdiMasterSummaryGrid.tsx      (4 errors)
features/master/src/pages/erp-edi-master/
  └── erp-edi-master.empty-rows.ts     (2 errors)
```

총 11 errors → 모두 cloud 에서 직접 fix

---

## 1. `staticColumns` 사용 4 errors

각 grid file (Repair/SalesSite/Sspm/Summary) 의 동일 패턴:

```typescript
// 변경 전 (오류):
const staticColumns = useErpEdiMasterStore(state => state.staticColumns.repair);

// 변경 후 (임시 — 빈 배열 fallback):
const staticColumns: ColumnMeta[] = [];
```

또는 store 에 `staticColumns` 추가 (root cause):

`features/master/src/pages/erp-edi-master/useErpEdiMasterStore.ts` 의 `ErpEdiMasterState` 에 다음 추가:

```typescript
interface ErpEdiMasterState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  // 추가:
  staticColumns: {
    summary: ColumnMeta[];
    repair: ColumnMeta[];
    salesSite: ColumnMeta[];
    sspm: ColumnMeta[];
  };
}
```

`initState` 에 default:
```typescript
const initState: ErpEdiMasterState = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  staticColumns: { summary: [], repair: [], salesSite: [], sspm: [] },  // 추가
};
```

## 2. `SHEETS.SUMMARY` 3 errors (`ErpEdiMasterSummaryGrid.tsx`)

✅ 이미 v3 patch 의 `erp-edi-master.constants.ts` 에 `SUMMARY = 'summary'` 추가됨. cloud 에 patch 적용 후 추가 변경 불필요.

## 3. `RESPONSE_SET` namespace 2 errors (`erp-edi-master.empty-rows.ts`)

`RESPONSE_SET.CUD` 가 type alias 인데 namespace 처럼 사용됨. enum 으로 변경 또는 string literal:

```typescript
// 변경 전 (오류):
} satisfies ResponseData<MENU_ID, SHEETS.SALES_SITE, RESPONSE_SET.CUD>;

// 변경 후 (string literal — 가장 안전):
} satisfies ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>;
```

또는 enum 변환 (`erp-edi-master.constants.ts` 의 RESPONSE_SET):
```typescript
// 변경 전:
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  ...
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// 변경 후 (enum):
export enum RESPONSE_SET {
  MAIN = 'o_rc1',
  REPAIR = 'o_rc1',
  SALES_SITE = 'O_RESULT_CURSOR',
  SSPM = 'o_rc1',
  DIVISION = 'o_rc1',
  UPDATE_HISTORY = 'o_rc1',
  CUD = 'o_rc1',  // empty-rows 용 추가
}
```

## 4. `row possibly undefined` 1 error (`ErpEdiMasterSalesSiteGrid.tsx:111`)

```typescript
// 변경 전:
(row, idx) => idx !== clickedRow && row.SSCM_SITE_ID === composed

// 변경 후 (optional chaining):
(row, idx) => idx !== clickedRow && row?.SSCM_SITE_ID === composed
```

## 5. `DataGrid<ResponseData<...>>` generic constraint 1 error (`ErpEdiMasterSalesSiteGrid.tsx:136`)

```typescript
// 변경 전 (오류):
<DataGrid<ResponseData<MENU_ID, SHEETS.SALES_SITE>>

// 변경 후 (WijmoRowItem cast):
<DataGrid<WijmoRowItem>
  // ... 그 외 props 동일
```

또는 generic 제거 + itemsSource cast:
```typescript
<DataGrid
  itemsSource={salesSiteRows as unknown as WijmoRowItem[]}
  ...
```

---

## 적용 순서

1. v3 patch (`cloud_master_fix_v3.patch`) 먼저 적용 (cloud 의 components / pages 7 file fix)
2. cloud 의 5 file 만 위 가이드대로 직접 수정
3. type-check 재실행:
   ```bash
   cd /c/Projects/NSCM/nscm-fe/features/master
   pnpm type-check
   ```
4. 0 errors 확인 후 commit & push

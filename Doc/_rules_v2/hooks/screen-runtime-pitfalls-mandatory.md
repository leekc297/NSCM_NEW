# Hook — Screen Runtime Pitfalls (런타임 사고 9종 통합 차단)

> 작성 / Authored: 2026-06-19 (DMF0043 룰 전면 점검 작업 중 발견된 사고 패턴 통합)
> 강도 / Strength: **PR 차단** — 발견 시 머지 거부
> 적용 / Apply: T01 신규 화면 / T01M 화면 수정 / T04 Grid 작업 / T05 Popup 작업

DMF0043 (Overseas Subs. Contribution Rate Reg.) 룰 전면 점검 작업 중 실 화면 진입 차단 또는 시각/기능 오작동을 일으킨 5 사고 패턴을 통합. 모두 코드 변경 시점에 grep / 패턴 검사로 사전 차단 가능.

---

## §0. 사고 카탈로그 — 9 분류

**9 분류** (2026-08-06 갱신 — P9 상호배타 prop 함정 추가[SYS0017 감사] / 2026-07-29 P8 useTabProcQuery filters 참조 동일성 추가 / 2026-06-19 P6·P7 추가)

| # | 사고 증상 | Root cause | 영향 |
|---|---|---|---|
| P1 | **Maximum update depth exceeded** (화면 진입 차단 ErrorBoundary) | `useStore(s => s.field ?? [])` selector 의 `?? []` 가 매 render 새 `[]` 참조 → zustand 변경 감지 → re-render → 무한 loop | 화면 진입 0 (사용자 작업 차단) |
| P2 | **DataGrid prop `initialized` callback 미호출** (cell coloring / sort / merge 적용 안 됨) | DataGrid wrapper 의 외부 `initialized` prop 이 deprecated — wrapper 가 자체 handleInitialized 만 FlexGrid 에 전달, 외부 prop 호출 안 함 | 시각 사고 (사용자 보고 다회) |
| P3 | **TS2411 / TS2344 — WijmoRowItem 미호환 type error** | `interface XxxRow` 에 인덱스 시그니처 `[k:string]:string \| number \| undefined` 또는 optional fields `?` 정의 → DataGrid `<T>` 제네릭 제약 (WijmoPrimitive) 위반 | tsc 실패, 빌드 차단 |
| P4 | **Header/Cell 머지 풀림 또는 동적 column sort indicator 표시** | DataGrid prop `allowMerging` 미지정/잘못 지정 + dynamicColumns 의 nested 객체에 `allowSorting/allowMerging` 옵션 미설정 → wijmo default 동작 | UI 일관성 사고 |
| P5 | **admin 메타 INSERT 시 ORA-01400 (cannot insert NULL)** | DDL 의 NOT NULL 컬럼 (예: `VALID_YN`) 을 INSERT column list 에서 누락. 추측·다른 테이블 패턴 일반화 | 메타 적용 실패, 화면 데이터 0 |
| P6 | **다단 헤더 시 row 높이가 1단과 같아 가독성/UI 정합 깨짐** | wijmo columnGroups 로 자동 row 추가되지만 default `defaultSize` 가 1단과 동일. DMF0007 customer-forecast-master 와 시각 정합 깨짐 | UI 일관성 사고 |
| P7 | **동적 컬럼 셀이 편집되지 않음** (모든 row readonly) | BE 응답 row 의 `EDIT_FLAG='N'` → DataGrid wrapper 의 `setEditableColumns` 가 `beginningEdit.cancel = !isEditableCell` 처리. `GridUtils.isEditableCell` 의 OPTIONAL/MANDATORY 분기 = `editFlag !== 'N'` → false → 편집 차단 | 사용자 편집 불가 (저장 0 row) |
| **P8** | **조회 후 스피너가 멈추지 않음** (동일 SEARCH 가 초 단위 무한 반복) | `useTabProcQuery` 의 `filters` 를 **인라인 객체 리터럴**로 전달 → `useCustomQueryClient.ts` 가 `prevKeyRef.current !== filters` **참조 비교**로 변경을 판정하므로 매 렌더 새 참조 = 항상 "변경" → removeQueries + 재요청 무한 루프 | 화면 사용 불가 + BE 부하 (2026-07-29 SYS0017 사고) |
| **P9** | **모달에 OK/Cancel(공통 footer) 이 안 보임** | `CustomDialog` 의 **상호배타 prop 함정** — `customContentArea` 지정 시 `CustomDialogContent` 가 삼항 분기로 **공통 OK/Cancel footer 자체를 렌더하지 않음** → 자체 footer 미구현이면 저장/닫기 경로 소실 | 팝업 저장·확정 기능 전체 소실 (2026-08-06 SYS0017 감사 — E05 OK→SAVE_MASTER_U 실행 불가) |

---

## §1. P1 — Zustand selector stable reference (`?? []` 금지)

### 1.1 안티패턴

```typescript
// ❌ 매 render `[]` 새 참조 → 무한 loop
const staticColumns = useStore(s => s.staticColumns[KEY] ?? []);
const rows = (data?.o_rc1 ?? []) as Row[];  // render 안에서 fallback
const list = useStore(s => s.list ?? defaultList);  // defaultList 가 매 호출 새 참조면 동일 사고
```

### 1.2 표준 — 2 패턴 중 택일

**A. Store 초기값에 stable 참조 명시** (권장 — selector 가장 깔끔)

```typescript
// store
const initState = {
  staticColumns: {
    [SHEETS.MAIN]: [],          // 빈 배열도 초기 stable 참조
    [SHEETS.MAIN_TITLE]: [],
    [SHEETS.VERSION]: [],
  },
};

// selector — fallback 없이 직접 사용
const staticColumns = useStore(s => s.staticColumns[SHEETS.MAIN]);
```

**B. useMemo 안정화** (data fetch 응답 같은 store 외부 값)

```typescript
const rows = useMemo(() => (data?.o_rc1 ?? []) as Row[], [data]);
```

### 1.3 PRE-WRITE 체크

- [ ] selector 안에 `?? []` / `?? {}` / `?? defaultXxx` 의 `defaultXxx` 가 module-level constant 가 아니면 사용 금지
- [ ] store 초기값에 빈 배열/객체 명시
- [ ] render 직접 안에서 `data?.x ?? []` 패턴은 useMemo 로 감싸기

### 1.4 POST-WRITE grep (0 hit 의무)

```bash
# 화면 폴더 안
grep -rn "useStore\(s => s\.\w\+ ?? " features/{domain}/src/pages/{screen}/   # 직접 fallback
grep -rn "useStore\(s => s\.\w\+\[\w\+\] ?? " features/{domain}/src/pages/{screen}/
```

---

## §2. P2 — DataGrid wrapper external `initialized` prop deprecated

### 2.1 사실

- `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:41` 의 `initialized?:` prop 은 `@deprecated` 주석
- wrapper `handleInitialized` 가 FlexGrid 의 initialized 로 전달 — 외부 prop 호출 안 함
- 외부에서 `<DataGrid initialized={handler}>` 로 전달해도 handler 실행 X

### 2.2 안티패턴

```tsx
// ❌ handler 가 호출 안 됨 — wj-cell-editable / sort indicator / handler 등록 모두 미적용
<DataGrid
  initialized={(grid) => {
    grid.formatItem.addHandler(myHandler);
    grid.cellEditEnded.addHandler(myEditHandler);
  }}
  ...
/>
```

### 2.3 표준 — useEffect + gridRef 패턴 (모든 wijmo 이벤트 핸들러 동일)

```tsx
const gridRef = useRef<FlexGrid<Row> | undefined>();

useEffect(() => {
  const grid = gridRef.current;
  if (!grid) return;
  const handler = (_s, e) => { /* ... */ };
  grid.formatItem.addHandler(handler);   // 또는 cellEditEnded / beginningEdit / loadedRows / ...
  grid.invalidate(); // 즉시 redraw 강제 (formatItem 류)
  return () => grid.formatItem.removeHandler(handler);
}, [staticColumns, dynamicColumns]);  // grid set 시점 이후 dependency 변경 시 재등록

return <DataGrid gridRef={gridRef} ... />;
```

> **timing 의미**: wrapper `handleInitialized` 가 gridRef.current=grid set + 자체 formatEditableColumns / setEditableColumns(beginningEdit handler) 등록. mount 후 useEffect 실행 — 그 때 gridRef.current 가 set 됐고, 내 handler 가 **wrapper 다음 (FIFO)** 등록되어 toggle/cancel/cellEditEnded 결과 최종 적용 보장.

### 2.4 ⭐ 모든 wijmo grid 이벤트 핸들러에 동일 적용 (의무)

| wijmo Event | 사용 시 dependency / 참조 |
|---|---|
| `grid.formatItem.addHandler` | `[staticColumns, dynamicColumns]` + `gridRef.current` (cell coloring 등) |
| `grid.cellEditEnded.addHandler` | 동일 (EDIT_FLAG 마킹 등) |
| `grid.beginningEdit.addHandler` | 동일 (P7 — cancel override) |
| `grid.loadedRows.addHandler` | 동일 (row 재생성 시점 처리) |
| `grid.cellEditEnding.addHandler` | 동일 (저장 전 검증) |
| `grid.selectionChanged.addHandler` | 동일 |
| `grid.gotFocus.addHandler` | 동일 |

> ⚠️ **`internalRef.current` 단독 참조 금지** — wrapper 가 외부 `initialized` prop 호출 안 함. `handleGridInitialized` 안에서 `internalRef.current = grid` 코드는 실행 안 됨 → mount 시점 undefined → handler 미등록 → 사용자 보고 사고 ("수정 후 저장 시 변경 항목 없음" — `cellEditEnded` 가 등록 안 돼 row.EDIT_FLAG 'M' 마킹 실패).

> ⚠️ **dependency `[]` (mount 1회) 금지** — gridRef.current 가 첫 render 에 undefined → effect return → handler 미등록 → 사고. `[staticColumns, dynamicColumns]` 의무 (column 재생성 시 wrapper 가 re-add 하므로 동시 재등록 필요).

### 2.5 PRE-WRITE 체크

- [ ] `<DataGrid initialized={...}>` 사용 금지 — wrapper 가 호출 안 함
- [ ] grid 인스턴스 접근 시 `gridRef.current` 사용 (DataGrid wrapper 가 자동 set, `internalRef` 단독 금지)
- [ ] 모든 wijmo 이벤트 (formatItem / cellEditEnded / beginningEdit / loadedRows / cellEditEnding / selectionChanged / gotFocus) 등록은 useEffect 안 + dependency `[staticColumns, dynamicColumns]` + cleanup 의무
- [ ] handler 안 row.EDIT_FLAG / 마킹 logic 은 cellEditEnded 등록 필수 (handleSave dirty filter 동작 정합)

### 2.6 POST-WRITE grep

```bash
# 외부 initialized prop 0 hit
grep -rn "<DataGrid[^/]*initialized=" features/{domain}/src/pages/{screen}/

# internalRef 단독 사용 검출 (의심 hit — 검토 필요)
grep -rn "internalRef\.current" features/{domain}/src/pages/{screen}/

# wijmo 이벤트 useEffect dependency 누락 검출 (수동 검토 — 정규식 어려움)
grep -rn "addHandler" features/{domain}/src/pages/{screen}/components/
# 각 hit 의 useEffect dependency 가 [] 인지 [staticColumns, dynamicColumns] 인지 확인
```

### 2.7 ⭐ `handleSave` dirty 검출 표준 + `itemsSource` 의 `CRUD_TYPE` 임의 set 금지

**사고 (사용자 보고)**: VersionModal handleSave → "변경 항목 없음" alert 후 (또는 두 번째 클릭에) 저장 진행. dirty.length=0 이 첫 호출에 발생.

**진짜 root cause** (2026-06-19 EditTracker source 정밀 read 후):
- `EditTracker._cellChanged` (cellEditEnded handler) 가 `storeChange` 를 **동기 호출** → `row.CRUD_TYPE = 'M'` 즉시 set + `_originalValues` Map 에 row 등록
- 따라서 `grid.finishEditing()` 직후 동기 dirty 검출 가능. **`await Promise.resolve()` 불필요** (오히려 React re-render 유발 → `itemsSource` useMemo 재계산 → 새 row 객체 → EditTracker Map key 불일치 → dirty=0 사고).
- 더 큰 사고: **`itemsSource` 의 row 객체에 `CRUD_TYPE: 'N'` 같은 임의 값 강제 set** → EditTracker 의 `if (item.CRUD_TYPE !== INSERT && !== DELETE)` 분기 동작은 OK 이지만, useMemo 재계산 시 새 row 가 'N' 으로 reset → 기존 EditTracker Map 의 row reference 와 mismatch → dirty=0.

**Fix 표준**:

```tsx
// itemsSource 정의 — CRUD_TYPE 임의 set 금지
const itemsSource = useMemo<Row[]>(
  () => (data?.o_rc1 ?? []).map(r => ({
    ...r,
    // 비어있는 필드 보강만, CRUD_TYPE 은 EditTracker 가 'M' / undefined 자체 마킹
    // CRUD_TYPE: 'N',  ❌ 금지
  })),
  [data, selectedYear]
);

const handleSave = async () => {
  const grid = gridRef.current;
  if (!grid) return;
  grid.finishEditing();  // 진행 중 cell edit 동기 commit + EditTracker storeChange 동기 호출
  // ❌ await Promise.resolve() — React re-render 유발 → itemsSource 재계산 → Map key 불일치

  // 3 dirty 검출 union (DMF0007 master 패턴):
  //   (1) row.CRUD_TYPE marker — EditTracker storeChange 가 'M' 자체 set
  //   (2) wijmo CollectionView itemsAdded/Edited/Removed
  //   (3) EditTracker.getOriginalValues()?.keys() — 변경된 row Map
  const items = (grid.collectionView?.sourceCollection ?? []) as Row[];
  const cv = grid.collectionView as CollectionView<Row> | undefined;
  const trackedRows = Array.from(editTrackerRef.current?.getOriginalValues()?.keys() ?? []);
  const editedList = [
    ...(cv?.itemsAdded?.slice() ?? []),
    ...(cv?.itemsEdited?.slice() ?? []),
    ...(cv?.itemsRemoved?.slice() ?? []),
    ...trackedRows,
  ] as Row[];
  const editedSet = new Set<Row>(editedList);
  editedSet.forEach(r => {
    if (!r.CRUD_TYPE || (r.CRUD_TYPE !== CRUD_TYPE.INSERT && r.CRUD_TYPE !== CRUD_TYPE.DELETE)) {
      r.CRUD_TYPE = CRUD_TYPE.MODIFY;  // EditTracker 마킹 row 의 marker 보강
    }
  });
  const dirty = items.filter(r =>
    r.CRUD_TYPE === CRUD_TYPE.INSERT ||
    r.CRUD_TYPE === CRUD_TYPE.MODIFY ||
    r.CRUD_TYPE === CRUD_TYPE.DELETE ||
    editedSet.has(r)
  );
  if (dirty.length === 0) {
    void setAlert({ type: 'alert', content: t('MSG_NO_CHANGE') });
    return;
  }
  // ... 이후 SP 호출
};
```

### 2.8 PRE-WRITE 체크

- [ ] `itemsSource` useMemo 안 row 객체에 **`CRUD_TYPE` 임의 set 금지** ('N'/''/등) — EditTracker 의 자체 마킹 흐름 보호
- [ ] `handleSave` 시작 시 `grid.finishEditing()` 후 **동기 dirty 검출** — `await` 추가 시 re-render 사고
- [ ] dirty 검출 = 3 union (CRUD_TYPE marker + CollectionView.itemsAdded/Edited/Removed + EditTracker.getOriginalValues)
- [ ] `import { CollectionView } from '@mescius/wijmo'` (concrete class) — `ICollectionView` 에 itemsAdded 등 없음

### 2.9 POST-WRITE grep

```bash
# itemsSource 안 CRUD_TYPE 임의 set 검출
grep -B 2 -A 2 "useMemo" features/{domain}/src/pages/{screen}/ | grep "CRUD_TYPE\s*:"
# 0 hit 이어야 함

# handleSave 안 await Promise.resolve / setTimeout 검출 (잘못된 패턴)
grep -B 2 -A 3 "handleSave" features/{domain}/src/pages/{screen}/ | grep -E "await Promise\.resolve|setTimeout"
# 0 hit 이어야 함

# handleSave 안 EditTracker.getOriginalValues 사용 확인 (의무)
grep "getOriginalValues" features/{domain}/src/pages/{screen}/
# 1+ hit 의무 (handleSave dirty 검출)
```

### 2.10 변경 이력 (2026-06-19)

- 초안: `await Promise.resolve()` 의무로 명시 → ❌ 잘못된 룰 (사용자 보고로 정정)
- 진정: `await` 금지 (re-render 사고) + `itemsSource` 안 `CRUD_TYPE` 임의 set 금지 (Map key 불일치 사고). EditTracker source 정밀 read 후 발견.

---

## §3. P3 — Wijmo Type 호환 (`WijmoRowItem extends` 의무)

### 3.1 사실

- `configs/types/global.d.ts:19-22`: `type WijmoPrimitive = string | number | boolean | Date | null;`
- `interface WijmoRowItem extends Record<string, WijmoPrimitive> { CRUD_TYPE?: string }`
- DataGrid `<T>` 제네릭 제약: `T extends WijmoRowItem`
- 따라서 `T` 의 인덱스 시그니처 / 모든 필드 = WijmoPrimitive 호환 의무

### 3.2 안티패턴

```typescript
// ❌ TS2411 — undefined 가 WijmoPrimitive 아님
interface MainRow {
  DIVISION_ID: string;
  EDIT_FLAG: string;
  [dynamicKey: string]: string | number | undefined;  // ❌ undefined
}

// ❌ TS2352 — optional fields 가 WijmoRowItem 으로 cast 안 됨
interface YearOption {
  CODE?: string | number;    // ❌
  NAME?: string;
  NAME2?: string;
}
const opts = (data?.o_rc1 ?? []) as YearOption[];  // cast error
```

### 3.3 표준

```typescript
// ✅ undefined 제거 + WijmoRowItem extends
interface MainRow extends WijmoRowItem {
  DIVISION_ID: string;
  EDIT_FLAG: string;
  [dynamicKey: string]: string | number;  // ✅ WijmoPrimitive 호환
}

interface YearOption extends WijmoRowItem {
  CODE: string | number;    // ✅ non-optional
  NAME: string;
  NAME2: string;
}
```

### 3.4 PRE-WRITE 체크

- [ ] Grid 의 row interface 는 `extends WijmoRowItem`
- [ ] 인덱스 시그니처 (`[k: string]: ...`) 에 `undefined` 미포함
- [ ] DataGrid `<T>` 에 전달하는 type 의 모든 field 가 WijmoPrimitive (`string | number | boolean | Date | null`) 와 호환

### 3.5 POST-WRITE grep

```bash
grep -rn "interface \w\+Row\b" features/{domain}/src/pages/{screen}/ | grep -v "extends WijmoRowItem"
# 0 hit 이어야 함 (Grid row type 은 모두 extends)
```

---

## §4. P4 — AllowMerging 정합 + dynamicColumns 옵션 직접 설정

### 4.1 사실

- DataGrid wrapper default `allowMerging = AllowMerging.ColumnHeaders` (헤더 머지만)
- `AllowMerging.Cells` 단독 → ColumnHeaders 머지 풀림
- `AllowMerging.All` = Cells | ColumnHeaders | RowHeaders 모두 활성
- staticColumns (admin 메타 fetch) → DataGrid wrapper 가 `column.allowMerging = (allowMerging !== None)` 자동 설정
- **dynamicColumns (화면에서 derive) → wrapper 자동 처리 안 됨 — 객체에 명시 의무**
- wijmo `column.allowSorting` default = `true` → DataGrid wrapper formatSortableColumns 가 indicator 자동 표시 → GridAction.toggleColumnSort(F3) toggle 방식과 충돌

### 4.2 안티패턴

```tsx
// ❌ Cell 머지만 — header 머지 풀림
<DataGrid allowMerging={AllowMerging.Cells} ... />

// ❌ dynamicColumns 에 allowMerging/allowSorting 없음 → 동적 컬럼만 default 동작 → 사용자 보고 사고
const dynamicColumns = useMemo(() => groups.map(g => ({
  header: g.label,
  columns: g.leaves.map(l => ({ binding: l.k, header: l.lbl, width: 80 })),
})), [groups]);
```

### 4.3 표준

```tsx
// ✅ Cell + Header 동시 머지 (BASE 컬럼 세로 머지 + 2단 헤더 가로 머지)
<DataGrid allowMerging={AllowMerging.All} ... />

// ✅ dynamicColumns 객체에 직접 옵션 명시 (group + leaf 양쪽)
const dynamicColumns = useMemo(() => groups.map(g => ({
  header: g.label,
  allowSorting: false,    // ✅ F3 toggle 전엔 indicator 미표시
  allowMerging: false,    // ✅ 동적 컬럼은 세로 머지 안 함 (BASE 만 머지)
  columns: g.leaves.map(l => ({
    binding: l.k,
    header: l.lbl,
    width: 80,
    allowSorting: false,
    allowMerging: false,
  })),
})), [groups]);
```

### 4.4 결정 매트릭스

| 화면 시나리오 | DataGrid `allowMerging` |
|---|---|
| 다단 헤더 (period+leaf 등) + BASE 인접 row 머지 | `AllowMerging.All` |
| 다단 헤더만 (Cell 머지 X) | `AllowMerging.ColumnHeaders` (default) |
| Cell 머지만 (단일 헤더) | `AllowMerging.Cells` |
| 머지 전혀 없음 | `AllowMerging.None` |

### 4.5 PRE-WRITE 체크

- [ ] dynamicColumns 의 group + 모든 leaf 객체에 `allowSorting: false` (toggle 방식이라 default false 가 맞음)
- [ ] dynamicColumns 에 머지 의도 없으면 group + leaf 에 `allowMerging: false` 명시
- [ ] DataGrid `allowMerging` prop 을 위 결정 매트릭스 따라 명시
- [ ] BASE 컬럼 (staticColumns) 의 머지는 admin SHEET_COLUMNS 메타에 명시 컬럼만 작동

### 4.6 POST-WRITE grep

```bash
# dynamicColumns 가 있으면 allowSorting:false 명시 확인
grep -A 3 "dynamicColumns\s*=" features/{domain}/src/pages/{screen}/components/*.tsx | grep -E "allowSorting|allowMerging"
```

---

## §5. P5 — admin 메타 INSERT 시 DDL NOT NULL 컬럼 매핑 의무

### 5.1 사실

- `SCM_MST_SHEET_COLUMNS` 의 NOT NULL 컬럼 (실측 16종): PROGRAM_ID / SHEET_NAME / COLUMN_NAME / COLUMN_LABEL_NAME / SORT_ORDER_NO / FIXED_FLAG / COLUMN_WIDTH / HORIZONTAL_ALIGN_CODE / UPPERCASE_APPLY_FLAG / VISIBLE_FLAG / DEFAULT_FLAG / USER_SELECTABLE_FLAG / **VALID_YN** / CREATED_BY / LAST_UPDATED_BY / INPUT_TP_CD
- 기존 패키지 SQL (예: 060_DMF0043_dynamic_property_management.sql) 에서 `VALID_YN` 누락 사례 발견 — 적용 시 ORA-01400
- 다른 NOT NULL 컬럼도 동일 누락 위험

### 5.2 안티패턴

```sql
-- ❌ VALID_YN 누락 (DDL: NOT NULL) → ORA-01400
INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS (
  PROGRAM_ID, SHEET_NAME, COLUMN_NAME,
  COLUMN_LABEL_NAME, SORT_ORDER_NO, COLUMN_WIDTH,
  VISIBLE_FLAG, FIXED_FLAG, UPPERCASE_APPLY_FLAG, USER_SELECTABLE_FLAG, DEFAULT_FLAG,
  -- VALID_YN 누락!
  INPUT_TP_CD, HORIZONTAL_ALIGN_CODE,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
) ...
```

### 5.3 표준

**Step 1**: 메타 INSERT 작성 전 DDL 정밀 확인

```bash
# ora.py / sqlcl / DBeaver 어느 도구든 사용
python _artifacts/_diagnostics/ora.py desc SCM_MST_SHEET_COLUMNS
# NULLABLE='N' 컬럼 전체 인벤토리 (16개) 확정
```

**Step 2**: INSERT column list 에 NOT NULL 컬럼 모두 매핑

```sql
INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS (
  PROGRAM_ID, SHEET_NAME, COLUMN_NAME,
  COLUMN_LABEL_NAME, SORT_ORDER_NO, COLUMN_WIDTH,
  VISIBLE_FLAG, FIXED_FLAG, UPPERCASE_APPLY_FLAG, USER_SELECTABLE_FLAG, DEFAULT_FLAG,
  VALID_YN,                                    -- ✅ NOT NULL — default 'Y'
  INPUT_TP_CD, HORIZONTAL_ALIGN_CODE,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
)
SELECT ..., 'Y', ...
```

### 5.4 다른 admin 테이블도 동일

| 테이블 | 작성 전 의무 |
|---|---|
| `SCM_MST_SHEET_COLUMNS` | DDL desc → NOT NULL 16종 확인 (VALID_YN 등) |
| `SCM_ADM_MNU_BTN_MPG_M` | 동일 |
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | 동일 |
| `SCM_ADM_API_M` | API_MSG_ID 등 NOT NULL 추가 — `reference_scm_adm_api_m_ddl.md` 메모리 entry 참조 |
| `SCM_ADM_PROC_M` | 동일 |

### 5.5 PRE-WRITE 체크

- [ ] INSERT 작성 전 `desc TABLE_NAME` (또는 USER_TAB_COLUMNS 조회) — NULLABLE='N' 컬럼 인벤토리 확인
- [ ] INSERT column list 와 NOT NULL 인벤토리 cross-check
- [ ] default 값 (예: VALID_YN='Y', VISIBLE_FLAG='Y') 명시
- [ ] 다른 테이블 패턴 일반화 금지 (테이블 별 NOT NULL 컬럼 다름)

### 5.6 POST-AUDIT (실 적용 후)

```sql
-- 멱등 NOT EXISTS 패턴이면 재실행 시 0 row inserted
-- inserted count = expected count 일치 확인
```

---

---

## §6. P6 — 다단 헤더 row 높이 정합 (DMF0007 ↔ 신규 화면 일관성)

### 6.1 사실

- wijmo `columnGroups` 가 nested 구조 (`{header, columns: []}`) 면 `grid.columnHeaders.rows` 가 자동 N 단 row 추가
- 단 각 row 의 height = default `rows.defaultSize` (대개 28px) — 1 단과 동일
- DMF0007 customer-forecast-master 의 dateColumns nested 구조 (`주/월/연 단위 group + 날짜 leaf`) 에서 다단 row 높이가 명시 조정되지 않으면 시각 정합 깨짐 (사용자 보고: "DMF0007 은 다단일 때 1 단 기준과 다르게 변경")
- 결정 정합: **다단 (`columnHeaders.rows.length > 1`) 시 각 row 높이를 일관된 값 (예: 38px) 로 강제** — DMF0007 / DMF0043 / 향후 신규 다단 화면 동일 처리

### 6.2 안티패턴

```tsx
// ❌ 다단 columnGroups 만 정의 + height 조정 없음 → 가독성 깨짐, 사용자 보고
const dynamicColumns = useMemo(() => groups.map(g => ({
  header: g.label,
  columns: g.leaves.map(...),  // 2단 자동 row 생성
})), [groups]);

return <DataGrid dynamicColumns={dynamicColumns} ... />;
```

### 6.3 표준 (2026-06-19 — 진짜 root cause 발견 + DMF0007 정합)

**진짜 root cause**: DataGrid wrapper 의 `mapRawColumnsToWijmoColumns` (`packages/foundation/src/utils/columnMapping.ts`) 가 `HEIGHT_BY_COLUMN_DEPTH` 상수로 각 column 의 `height` 자동 적용:

```ts
enum HEIGHT_BY_COLUMN_DEPTH {
  ONE_DEPTH = 48,    // 1단
  TWO_DEPTH = 24,    // 2단 (각 column)
  THREE_DEPTH = 16,  // 3단
}
```

- **staticColumns (admin 메타)**: wrapper 가 small/large class label depth 따라 **자동 적용** → DMF0007 처럼 작음
- **dynamicColumns (화면 측 derive)**: wrapper 자동 처리 **안 됨** → wijmo default 48 × N = cell rowspan 96 사고

**Fix (표준)**: 화면 `buildDynamicColumns` 의 group + leaf 객체에 `height` 직접 명시 — DataGrid wrapper 상수와 정합:

```ts
return groups.map(g => ({
  header: g.label,
  align: 'center',
  height: 24,             // ← TWO_DEPTH 정합 의무
  columns: g.leaves.map(l => ({
    binding: l.binding,
    header: l.header,
    width: 80,
    height: 24,           // ← TWO_DEPTH 정합 의무
  })),
}));
```

> **wrapper 변경 금지** (Hard Boundary): `mapRawColumnsToWijmoColumns` 가 dynamicColumns 도 자동 처리하면 좋겠지만 shared 변경은 별도 PR. 화면 측 dynamicColumns 정의 시 height 명시가 표준.

### 6.4 결정 값 (`HEIGHT_BY_COLUMN_DEPTH` 캐노니컬 상수)

| Depth | 각 column.height | 출처 |
|---|---:|---|
| 1단 (ONE_DEPTH) | **48 px** | `columnMapping.ts:27` |
| 2단 (TWO_DEPTH) | **24 px** | `columnMapping.ts:28` |
| 3단 (THREE_DEPTH) | **16 px** | `columnMapping.ts:29` |

DMF0007 의 staticColumns 는 wrapper 가 이 값 자동 적용. dynamicColumns 는 화면 측에서 동일 값 명시 의무.

> ⚠️ **2026-06-19 변경 이력 (5 회 점진 조정 + 최종 SCSS 전환)**:
> - 초안: 다단 38px 다음 28/22/18/14px — 모두 wijmo 가 inline `style.height: 96px` 로 무력화 (사용자 browser DevTools 측정 결과)
> - **최종 (확정)**: SCSS module `:global(.wj-colheaders .wj-cell.wj-header) { height:14px !important }` 로 inline style override — useEffect/loadedRows/defaultSize 모두 무용 (wijmo cell rowspan 처리)

### 6.5 PRE-WRITE 체크

- [ ] `dynamicColumns` 또는 `staticColumns` 에 nested 구조 (`{header, columns:[]}`) 가 있으면 다단 헤더 row 높이 강제 useEffect 추가
- [ ] 디자인 토큰 (Figma) 우선 — 없으면 표준 값 (1단 28 / 다단 38) 사용
- [ ] DMF0007 처럼 nested 가 동적 (기간/그룹 변경 시 변동) 이면 dependency 에 해당 source 포함

### 6.6 POST-WRITE grep

```bash
# nested columnGroups 가 있는 곳에 height 조정 있는지 검증
grep -rn "columns:\s*\[" features/{domain}/src/pages/{screen}/components/ | head
grep -rn "columnHeaders\.rows" features/{domain}/src/pages/{screen}/ | head
```

---

## §7. P7 — 동적 컬럼 셀 편집 EDIT_FLAG 우회 (`beginningEdit` 강제 override)

### 7.1 사실 (DMF0043 사례)

- BE `DMF0043_GET_CONTRIBUTE_MAIN_DATA` SP 응답 row 의 `EDIT_FLAG: "N"` (모든 row, BE log 측정 확인)
- DataGrid wrapper (`packages/shared/dataGridUtils.ts:226-247`) 의 `setEditableColumns` 가 `grid.beginningEdit.addHandler` 등록:
  ```ts
  args.cancel = !GridUtils.isEditableCell(grid, args.row, args.col);
  ```
- `GridUtils.isEditableCell` (`packages/foundation/utils/gridUtils.ts:48-69`) 분기:
  ```ts
  case CELL_INPUT_EDIT_TYPE.OPTIONAL:
  case CELL_INPUT_EDIT_TYPE.MANDATORY:
    return editFlag !== 'N';  // ← EDIT_FLAG='N' 이면 false → cancel = true
  ```
- 동적 컬럼 (admin 메타 없음) leaf 에 `_inputEditType: OPTIONAL` 설정해도 EDIT_FLAG='N' 이면 readonly

### 7.2 안티패턴

```tsx
// ❌ EDIT_FLAG='N' 인 row 에서 동적 cell 편집 시도 — wrapper 가 cancel → 입력 불가
const dynamicColumns = useMemo(() => leaves.map(leaf => ({
  header: leaf.label,
  columns: [{
    binding: leaf.binding,
    _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,  // 이것만으론 부족
  }],
})), [leaves]);

return <DataGrid dynamicColumns={dynamicColumns} ... />;
// ↑ 사용자 편집 시 wrapper 가 cancel
```

### 7.3 표준 — `beginningEdit` 핸들러 화면 측 등록 (FIFO 마지막 override)

```tsx
useEffect(() => {
  const grid = gridRef.current;
  if (!grid) return;
  const handler = (_s, e) => {
    const col = grid.columns[e.col];
    if (!col?.binding) return;
    // 동적 컬럼 (또는 EDIT_FLAG 무관 편집 의도 영역) 만 분기
    if (!col.binding.startsWith('Y#') && !col.binding.startsWith('M#')) return;
    if (col.binding.endsWith('RBU_0999')) return;  // readonly 의도 컬럼 제외
    e.cancel = false;  // wrapper 의 cancel 강제 override
  };
  grid.beginningEdit.addHandler(handler);
  return () => grid.beginningEdit.removeHandler(handler);
}, [staticColumns, dynamicColumns]);
```

**핵심**: wrapper 의 `setEditableColumns` 가 grid initialize 시점에 핸들러 등록. 화면 측 useEffect 가 mount 후 등록 → FIFO 호출 순서에서 **wrapper 다음** → 내 `cancel = false` 가 최종 결과.

### 7.4 PRE-WRITE 체크

- [ ] BE 응답 row 의 `EDIT_FLAG` 값 확인 (BE log `grep EDIT_FLAG`) — 'N' 이면 readonly 처리
- [ ] 편집 의도 동적 컬럼이 있으면 `beginningEdit` handler 등록 + 해당 binding 만 cancel=false
- [ ] readonly 의도 컬럼 (예: RBU_0999) 은 분기 제외
- [ ] dependency `[staticColumns, dynamicColumns]` — column 재생성 시 재등록

### 7.5 POST-WRITE grep

```bash
# 동적 컬럼이 있고 BE EDIT_FLAG='N' 환경이면 beginningEdit handler 존재 확인
grep -rn "beginningEdit\.addHandler" features/{domain}/src/pages/{screen}/components/
# 0 hit + 동적 컬럼 편집 안 되는 사고 보고 시 위반
```

### 7.6 적용 시나리오

| 화면 패턴 | P7 필요 여부 |
|---|---|
| BE row 의 EDIT_FLAG 가 row 별 'Y'/'N' 혼재 + admin 메타 컬럼만 편집 | N.A. (wrapper 정상 동작) |
| BE row 의 EDIT_FLAG='N' (모든 row) + 동적 컬럼 편집 의도 | **필수 (P7 적용)** |
| AS-IS .cs 의 LockRange 가 row 별 분기 → row.EDIT_FLAG 화면 측에서 재계산 | row 변환 시 EDIT_FLAG override (대안) |

---

## §8. 적용 화면 표 (현 시점 — 2026-06-19)

| 화면 | P1 | P2 | P3 | P4 | P5 | P6 | P7 | 비고 |
|---|---|---|---|---|---|---|---|---|
| DMF0043 (contribute-main) | ✅ fix | ✅ fix | ✅ fix | ✅ fix | ✅ fix (060+061 SQL) | ✅ fix (height:24 + admin sCls) | ✅ fix (beginningEdit handler) | 본 hook 의 reference 화면 |
| DMF0004 (sales-site) master | ⚠️ 검증 권장 | ⚠️ 검증 권장 | (이미 표준) | (CustomMergeManager 자동) | (이미 표준) | reference baseline |
| DMF0005 (sales-site-project-model) | ⚠️ 검증 권장 | ⚠️ 검증 권장 | (이미 표준) | (Panel split) | (이미 표준) | reference baseline |
| DMF0006 (customer-model-mapping) | ⚠️ 검증 권장 | ⚠️ 검증 권장 | (이미 표준) | (단일 grid) | (이미 표준) | reference baseline |
| DMF0007 / 0008 / 0020 / 0043_01 / 0072 (마이그레이션) | ⚠️ 점검 필요 | ⚠️ 점검 필요 | ⚠️ 점검 필요 | ⚠️ 점검 필요 | ⚠️ 점검 필요 | 다음 점검 작업 시 본 hook 적용 |

---

## §8-B. P8 — `useTabProcQuery({ filters })` 참조 동일성 (인라인 객체 금지)

### 8B.1 사실
`packages/shared/src/hooks/useCustomQueryClient.ts` 의 `useTabProcQuery` 는 filters 변경을 **값이 아니라 참조**로 판정한다.

```ts
const isKeyChanged = prevKeyRef.current !== filters;   // 참조 비교
```

따라서 렌더마다 새로 만들어지는 객체를 넘기면 **항상 "변경됨"** 으로 판정되어 이전 쿼리 제거 + 재요청이 무한 반복된다.

### 8B.2 안티패턴
```tsx
// ❌ 매 렌더 새 참조 → 무한 재조회(스피너 안 멈춤) + BE 부하
const { data } = useTabProcQuery<MENU_ID, SHEETS.MESSAGE>({
  menuId: MENU_ID, sheetName: SHEETS.MESSAGE, tabId,
  filters: { useType: 'MAIL', categoryId: selectedCategoryId },
  enabled: !!selectedCategoryId,
});
```

### 8B.3 표준 — 2 패턴 중 택일
```tsx
// ✅ (A) store 보관 값 그대로 전달 (notice-setup 등 기존 화면 표준)
const filters = useXxxStore(state => state.filters);   // setFilters() 로만 갱신

// ✅ (B) useMemo 안정 참조
const detailFilters = useMemo(
  () => ({ useType: USE_TYPE_CODE, categoryId: selectedCategoryId }),
  [selectedCategoryId]
);
```

고빈도 이벤트(그리드 `selectionChanged` 등)가 store 를 갱신할 때는 **동일 값이면 set 을 건너뛰는 가드**를 store 액션에 둔다 — 불필요 리렌더 → 재조회 연쇄를 끊는다.

```ts
selectCategory: row => {
  const nextId = row?.CATEGORY_ID ?? '';
  if (get().selectedCategoryId === nextId) return;   // ← 가드
  set(state => { state.selectedCategoryId = nextId; /* ... */ });
},
```

### 8B.4 PRE-WRITE 체크
- [ ] `useTabProcQuery` 의 `filters` 는 store 값 또는 `useMemo` 결과인가? (인라인 리터럴 0)
- [ ] 그리드 selection/포커스 이벤트가 store 를 갱신한다면 동일 값 set-skip 가드가 있는가?

### 8B.5 POST-WRITE grep (0 hit 의무)
```bash
# 화면 폴더 안 — useTabProcQuery 호출부의 인라인 filters 리터럴
grep -nE "filters:\s*\{" features/**/pages/{screen}/**/*.tsx
grep -nE "filters=\{\{" features/**/pages/{screen}/**/*.tsx
```

### 8B.6 진단 (증상 → 원인)
"조회 후 스피너가 멈추지 않음" 신고 시 **BE 로그에서 동일 `mnuId`/`mnuBtnCd` 의 SEARCH 가 초 단위로 반복**되는지 먼저 확인한다. 반복이면 P8 이 1순위 (사고: 2026-07-29 SYS0017 Mail Setup — Message/selReceiver/sqlText 3곳 인라인 객체).

---

## §8-C. P9 — 공용 컴포넌트 **상호배타 prop 함정** (`customContentArea` = 공통 footer 미렌더) — 2026-08-06 SYS0017 감사 계기 신설

### 8C.1 사실

- `CustomDialog` 의 content 렌더(`CustomDialogContent`, 삼항 분기)는 **`customContentArea` 지정 시 공통 OK/Cancel footer 를 아예 렌더하지 않는다** — 상호배타 prop (children 경로에서만 공통 footer 렌더).
- 컴파일·타입 전부 통과 + 모달도 뜨므로 **런타임에 열어보기 전까지 발견 불가** — pre-write §0.2 는 "없는 심볼" import 만 검사해 이 계약 위반을 잡지 못했다 (SYS0017 감사 (e): 게이트 공백).

### 8C.2 안티패턴

```tsx
// ❌ customContentArea 지정 + 자체 footer 없음 → OK/Cancel 소실 → 저장(E05 OK→SAVE)·닫기 경로 소실
<CustomDialog size={800} customHeaderTitle={t('LBL...')} handleClose={onClose}
  customContentArea={<div>{/* grid/form ... 버튼 없음 */}</div>} />
```

### 8C.3 표준 — `customContentArea` 사용 시 **자체 footer 구현 의무** (정본: forecast-price `ExchangeRateModal`)

```tsx
// ✅ customContentArea 내부 마지막에 자체 footer (OK/Cancel — 공통 버튼 스타일 재사용)
<CustomDialog ... customContentArea={
  <div className={styles.wrap}>
    {/* content ... */}
    <div className={styles.footer}>
      <Button onClick={handleSave}>{t('LBL00366') /* OK/Save */}</Button>
      <Button variant="outlined" onClick={onClose}>{t('LBL00627') /* Close */}</Button>
    </div>
  </div>
} />
```

- 대안: footer 가 공통형이면 `customContentArea` 를 쓰지 말고 children 경로(공통 footer 자동)로 작성.

### 8C.4 ⭐ 상호배타 prop 함정 표 (유사 함정 발견 시 **본 표에 행 추가** — 확장 규약)

> 공용 컴포넌트에서 "prop A 지정 = 기본 동작 B 소실" 형태의 상호배타 계약을 발견하면 즉시 아래 표에 등재한다
> (컴포넌트 / prop / 소실되는 기본 동작 / 화면 측 의무 / 정본). 등재 = pre-write §0.2 계약 확인 대상 자동 편입.

| 컴포넌트 | prop | 지정 시 소실되는 기본 동작 | 화면 측 의무 | 정본 |
|---|---|---|---|---|
| `CustomDialog` | `customContentArea` | 공통 OK/Cancel footer (CustomDialogContent 삼항) | 자체 footer 구현 (8C.3) | forecast-price `ExchangeRateModal` |
| (발견 시 추가) | | | | |

### 8C.5 PRE-WRITE 체크

- [ ] 공용 컴포넌트에 낯선 prop 을 지정하기 전 **소스에서 조건 분기(삼항/early return)를 확인** — 그 prop 이 기본 렌더 경로를 대체하는지(상호배타) 판정
- [ ] `customContentArea` 지정 모달 = 자체 footer(OK/Cancel) 포함 여부 확인
- [ ] 8C.4 표의 등재 함정 전수 확인

### 8C.6 POST-WRITE grep (+ G6-1 런타임 확인 의무)

```bash
# customContentArea 사용 모달 검출 → 각 hit 파일에 자체 footer(Button onClick={handleSave|onClose}) 존재 확인
grep -rln "customContentArea" features/{domain}/src/pages/{screen}/ | while read f; do
  grep -qE "className=\{?.*footer|<Button" "$f" || echo "⛔ $f: customContentArea + 자체 footer 부재 의심 (P9)"
done
```

- grep 은 의심 검출까지 — 최종 판정은 **screen-completion-gate §0.5 G6-1 (모달 전수 열어 footer 확인)** 런타임 증명.

---

## §9. cross-ref 메모리 entry

- `feedback_ddl_grep_before_sql.md` — DDL 추측 금지 (P5 cross-ref)
- `feedback_shared_global_prop_change_forbidden.md` — shared 변경 금지 (P2 의 fix 가 shared 변경이 아니라 화면 측 우회 패턴)
- `feedback_regression_zero_mandatory.md` — Hard Boundary 6종 (전 사고 통합)
- `feedback_datagrid_shared_component_mandatory.md` — DataGrid wrapper 사용 의무 (#60)
- `feedback_tabprocquery_filters_reference_identity.md` — filters 참조 비교 (P8)

---

## §10. 변경 이력

- 2026-06-19: 신규 작성 — DMF0043 룰 전면 점검 작업 중 발견된 5 사고 패턴 통합. 사용자 명시: "기존의 UI 수정요청에 대한 프로세스에 더해서 이 화면 기준으로 보완 후에 추가적으로 작업했던 내용들도 rule 로 반영해서 차후 화면 수정, 신규 생성 시 반영되도록".
- 2026-07-29: **P8 추가** — `useTabProcQuery({filters})` 인라인 객체 → 무한 재조회(스피너 안 멈춤). SYS0017 Mail Setup 사고. 사용자 신고 → BE 로그 실측으로 확정, §8-B 신설 + RULESET_MASTER §3.1/§3.3 반영.
- 2026-08-06: **P9 추가** — `CustomDialog customContentArea` 상호배타 prop = 공통 OK/Cancel footer 미렌더 → 자체 footer 의무 + 상호배타 prop 함정 확장 표(8C.4). SYS0017 근본원인 감사 (e) 게이트 공백 보강. screen-completion-gate §0.5 G6-1 짝.

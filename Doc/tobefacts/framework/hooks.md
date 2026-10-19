# hooks (26)

사용 수 내림차순. **신규 화면은 여기 있는 것만 쓴다** — 없으면 사전(map_control.csv) 보완 제안이 먼저(룰 23).

## app-shell

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **useTabActivation** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  |  |
| **useViewReload** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  |  |

## foundation

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **useIsBusy** | `@foundation/lib` | 0 |  |  |

### useIsBusy  <sub>packages/foundation/src/lib/query-client.ts:161</sub>

```ts
(key: string[]): boolean
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => string — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: string[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<string>[]): string[]; (...items: (string`
- `ConcatArray< — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => string[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => string — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => string[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: string, b: string) => number) => string[] — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): string[]; (start: number, deleteCount:  — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: string[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: string, index: number, array: string[]) => unknown, thisArg? — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: string, index: number, array: string[]) => void, thisArg?:  — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: string, index: number, array: string[]) => U, thisArg?:  — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends string>(predicate: (value: string, index: number, obj: string[]) => — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: string, index: number, obj: string[]) => unknown, thisArg?:  — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: string, start?: number, end?: number) => string[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => string[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, string]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<string> — Returns an iterable of values in the array`
- `includes: (searchElement: string, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: string, index: number, array — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => string — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<string> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

## master-common

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **useCascadeFields** | `features/master/src/components` | 0 |  | 단계별 엘리먼트를 만들어 돌려주는 훅. 단계를 붙여서 렌더할 수 있으면 CascadeFields 컴포넌트를 그대로 쓰면 되고, NnMasterMappingForm 처럼 중간에 다른 조회조건(popup input 등)이 끼어서 배치가 찢어지는 화면은 이 |

### useCascadeFields  <sub>features/master/src/components/searchFields/useCascadeFields.tsx:40</sub>

```ts
<V extends object>({ comboId, levels, value, onChange, gridSize, enabled, debugLabel, }: UseCascadeFieldsOptions<V>): { fields: any; field: (key: "division" | "team" | "endCustomer" | "salesSite" | "soldToCustomer" | "plantSite" | "bizType" | "senderCode") => any; }
```

props/params:

- `comboId: string — 조인된 평면 콤보 1건의 등록 ID (SCM_ADM_CMBO_SQL_M).`
- `levels: ("division"`
- `"team"`
- `"endCustomer"`
- `"salesSite"`
- `"soldToCustomer"`
- `"plantSi — 화면에 렌더할 단계와 순서. 배열 순서가 곧 cascade 순서다.`
- `value: V — 조회조건 스토어 객체. 단계 field(미지정 시 key)로 선택값을 읽는다.`
- `onChange: (next: Partial<V>, changed: "division"`
- `"team"`
- `"endCustomer"`
- `"salesSite"`
- ` — 바뀐 단계 + 그 아래 전 단계(초기화)를 담은 부분 객체. 스토어가 partial merge 라 그대로 setSearchParams(next) 하면 된다. 값 모양은 스토어 필드 타입을 따라간다 — 문자열 필드면 문자열('ALL'), 배열 필드면 배열([])이다. writeValue `
- `gridSize?: number — 전 단계 공통 Grid size. 단계별로 다르게 주려면 levels 항목의 gridSize 로 덮는다.`
- `enabled?: boolean — 콤보 조회 자체를 막을 때.`
- `debugLabel?: string — 임시 로컬 디버그 — 넘기면 콤보 원본 컬럼 목록과 단계별 잔여 행 수가 콘솔에 찍힌다. 목록이 비는 사고의 대부분은 콤보 SQL 컬럼명이 규약과 달라 첫 단계에서 전 행이 잘리는 경우다. SearchFields.debug 참조. 확인이 끝나면 호출부에서 지운다.`

## shared

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **useTabComboQueries** | `@shared/hooks` | 211 |  |  |
| **useTabProcQuery** | `@shared/hooks` | 202 |  | filters 는 매 렌더 새로 만들지 말 것 — 아래 useLayoutEffect 는 filters 참조가 바뀌면 값이 같아도 "사용자가 재조회했다"로 판정해 캐시를 비운다. store selector / useState 값 / useMemo / 모 |
| **useTabBtnPermissions** | `@shared/hooks` | 107 |  | 메뉴 버튼 권한 동적 fetch — UI 동적 속성관리 master hook §3 (2026-06-15) BE: GET /admin/menu/{mnuId}/auth → MenuAuthDto.mnuBtnAuth: List<String> SCM_ADM_U |
| **useTabid** | `@shared/stores` | 71 |  |  |
| **useSaveWithValidation** | `@shared/hooks` | 65 |  |  |
| **useTabLookupQueries** | `@shared/hooks` | 49 |  |  |
| **useProcMutation** | `@shared/hooks` | 40 |  |  |
| **useTabComboQueryResults** | `@shared/hooks` | 8 |  | `useTabComboQueries` 와 같은 쿼리를 구독하되 `data` 뿐 아니라 `isPending`/`isError` 도 함께 돌려준다. 콤보 데이터가 아직 안 온 것(로딩 중)과 조회했지만 실패한 것을 구분해야 하는 호출부용 (예: DataG |
| **useInvalidateCombos** | `@shared/hooks` | 3 |  | 콤보 캐시 무효화 — 콤보의 원천 마스터를 저장한 화면이 저장 성공 직후 호출한다. 콤보는 staleTime 0 이지만 그건 "화면을 새로 열 때 다시 받는다"는 뜻이다. MDI 는 keep-alive 라 저장한 그 화면은 리마운트되지 않으므로, 방금 |
| **useStreamProcQuery** | `@shared/hooks` | 1 |  |  |
| **useTabLookupQuery** | `@shared/hooks` | 1 |  | @deprecated useTabLookupQueries 사용하세요 |
| **useClearAppData** | `@shared/hooks` | 0 |  |  |
| **useDataGridUtils** | `@shared/components` | 0 |  |  |
| **useDirtyCheck** | `@shared/stores` | 0 |  | 화면용 편의 훅 — 그리드 외의 미저장 상태(폼 입력, 별도 편집 UI 등)를 dirty 집계에 참여시킨다. 현재 탭 키(+다이얼로그 안이면 스코프 키)에 자동 등록되고 언마운트 시 해제된다. DataGrid 는 이미 내부에서 자동 등록하므로 그리드에 |
| **useDirtyReset** | `@shared/stores` | 0 |  | 화면용 편의 훅 — 이탈 confirm 에서 "확인" 을 눌렀을 때 그리드 밖의 미저장 상태를 함께 되돌린다. 등록 스코프는 useDirtyCheck 과 동일(현재 탭 + 다이얼로그 안이면 스코프). 그리드 자체는 DataGrid 가 자동 등록하므로  |
| **useFilteredGridCount** | `@shared/hooks` | 0 |  | 그리드에 F4/헤더 필터가 적용되면 실제로 화면에 보이는 건수를, 미적용이면 조회 건수(dataCount)를 반환한다. SubTitle.tsx 의 상단 툴바 건수 배지에 쓰던 로직을 공용 훅으로 뽑아, ResultArea 처럼 그리드별로 건수를 표시하 |
| **useFlexGridRowDnD** | `@shared/components` | 0 |  |  |
| **useGuardedDialogClose** | `@shared/stores` | 0 |  | 다이얼로그용 "가드된 닫기" — 미저장 변경이 있으면 confirm 을 거치고, 확인이면 되돌린 뒤 닫는다. CustomDialog 의 헤더 X 버튼은 이미 같은 가드를 타지만, 화면이 직접 만든 Close/Cancel 버튼은 modalClose 를  |
| **useInsertedRows** | `@shared/hooks` | 0 |  |  |
| **useMenuId** | `@shared/stores` | 0 |  |  |
| **useRowParamCombos** | `@shared/components` | 0 |  | 행 값 조합마다 콤보를 조회해 `컬럼 binding -> 조합 키 -> 후보 행` 으로 돌려준다. 지연 조회다 - 그리드에 실린 행을 미리 훑지 않고, 사용자가 닿은 행만 조회한다. 첫 조회는 공란 조합 1건뿐이고 그 뒤로는 포커스가 닿을 때마다 1건 |
| **useTabComboQuery** | `@shared/hooks` | 0 |  | @deprecated useTabComboQueries를 사용하세요 |

### useTabComboQueries  <sub>packages/shared/src/hooks/useCustomQueryClient.ts:314</sub>

```ts
(args: UseTabComboQueriesArgs): any
```

props/params:

- `filters: any[]`
- `enabled?: boolean`
- `queryOptions?: Omit<UseQueryOptions<ComboResponse[]>, "queryKey"`
- `"queryFn">`
- `src?: string — 요청 출처 표식. URL 쿼리(`admin/combo?src=grid`)와 쿼리 키에만 붙고 본문에는 안 실린다 — 본문 키는 BE makeComboQuery 가 등록 SQL 의`
- `sheetName?: string — 그리드 시트명 — 지정 시 각 콤보 파라미터에 sheetName 으로 기본 주입해`

### useTabProcQuery  <sub>packages/shared/src/hooks/useCustomQueryClient.ts:89</sub>

```ts
<M extends MenuId, S extends SheetName<M> = SheetName<M>>({ menuId, sheetName, procedureAction, tabId, filters, enabled, queryOptions, }: { menuId: M; sheetName: S; procedureAction?: BUTTON_TYPE; tabId: string; filters?: ProcRequest<M, S>; enabled?: boolean; queryOptions?: Omit<UseQueryOptions<ProcResponse<M, S>>, "queryKey" | "queryFn">; }): any
```

props/params:

- `menuId: M`
- `sheetName: S`
- `procedureAction?: BUTTON_TYPE`
- `tabId: string`
- `filters?: ProcRequest<M, S>`
- `enabled?: boolean`
- `queryOptions?: Omit<UseQueryOptions<ProcResponse<M, S>>, "queryKey"`
- `"queryFn">`

### useTabBtnPermissions  <sub>packages/shared/src/hooks/useTabBtnPermissions.ts:32</sub>

```ts
({ menuId, enabled, }: { menuId: string; enabled?: boolean; }): { buttons: any; hasButton: (btnCd: string) => boolean; isLoading: any; refetch: any; }
```

props/params:

- `menuId: string`
- `enabled?: boolean`

### useTabid  <sub>packages/shared/src/stores/createStore.ts:15</sub>

```ts
(): any
```

### useSaveWithValidation  <sub>packages/shared/src/hooks/useSaveWithValidation.ts:66</sub>

```ts
(): { saveWithValidation: <T>(saveData: T[], staticColumns: RawFlexGridColumnConfig[], mutate: (data: T[]) => void, validationRows?: WijmoRowItem[]) => void; }
```

### useTabLookupQueries  <sub>packages/shared/src/hooks/useCustomQueryClient.ts:349</sub>

```ts
({ filters, enabled, queryOptions, }: { filters: any[]; enabled?: boolean; queryOptions?: Omit<UseQueryOptions<LookupResponse[]>, "queryKey" | "queryFn">; }): any
```

props/params:

- `filters: any[]`
- `enabled?: boolean`
- `queryOptions?: Omit<UseQueryOptions<LookupResponse[]>, "queryKey"`
- `"queryFn">`

### useProcMutation  <sub>packages/shared/src/hooks/useCustomQueryClient.ts:166</sub>

```ts
<M extends MenuId, S extends SheetName<M> = SheetName<M>, RS extends ResponseKeys<M, S> = ResponseKeys<M, S>>({ menuId, sheetName, procedureAction, tabId, onSuccess, onError, }: { menuId: M; sheetName: S; procedureAction?: BUTTON_TYPE; tabId: string; onSuccess?: () => void; onError?: (error?: Error) => void; }): any
```

props/params:

- `menuId: M`
- `sheetName: S`
- `procedureAction?: BUTTON_TYPE`
- `tabId: string`
- `onSuccess?: () => void`
- `onError?: (error?: Error) => void`

### useTabComboQueryResults  <sub>packages/shared/src/hooks/useCustomQueryClient.ts:322</sub>

```ts
({ filters, enabled, queryOptions, src, sheetName }: UseTabComboQueriesArgs): any
```

props/params:

- `filters: any[]`
- `enabled?: boolean`
- `queryOptions?: Omit<UseQueryOptions<ComboResponse[]>, "queryKey"`
- `"queryFn">`
- `src?: string — 요청 출처 표식. URL 쿼리(`admin/combo?src=grid`)와 쿼리 키에만 붙고 본문에는 안 실린다 — 본문 키는 BE makeComboQuery 가 등록 SQL 의`
- `sheetName?: string — 그리드 시트명 — 지정 시 각 콤보 파라미터에 sheetName 으로 기본 주입해`

### useInvalidateCombos  <sub>packages/shared/src/hooks/useCustomQueryClient.ts:233</sub>

```ts
(): any
```

### useStreamProcQuery  <sub>packages/shared/src/hooks/useStreamProcQuery.ts:38</sub>

```ts
<Row extends object>({ menuId, sheetName, procedureAction, dataCursor, gridRef, transformRow, refreshIntervalMs, onDone, onError, }: UseStreamProcQueryOptions<Row>): { data: any; start: any; cancel: any; isStreaming: any; loadedCount: any; error: any; }
```

props/params:

- `menuId: string`
- `sheetName: string`
- `procedureAction?: string`
- `dataCursor?: string — 그리드에 넣을 데이터 커서 이름 (PROC_M COL_NM)`
- `gridRef?: MutableRefObject<any> — 데이터를 이어 붙일 그리드 — collectionView.refresh 대상`
- `transformRow?: (row: Row) => Row — 행 정규화(날짜 등) — 묶음 도착 시 행마다 1회`
- `refreshIntervalMs?: number — 수신 중 그리드 갱신 최소 간격(ms)`
- `onDone?: (result: any) => void`
- `onError?: (error: Error) => void`

### useTabLookupQuery  <sub>packages/shared/src/hooks/useCustomQueryClient.ts:328</sub>

```ts
({ filters, enabled, queryOptions, }: { filters: LookupParam; enabled?: boolean; queryOptions?: Omit<UseQueryOptions<LookupResponse[]>, "queryKey" | "queryFn">; }): any
```

props/params:

- `filters: LookupParam`
- `enabled?: boolean`
- `queryOptions?: Omit<UseQueryOptions<LookupResponse[]>, "queryKey"`
- `"queryFn">`

### useClearAppData  <sub>packages/shared/src/hooks/useClearAppData.ts:7</sub>

```ts
(): { clearAllData: () => Promise<void>; }
```

### useDataGridUtils  <sub>packages/shared/src/components/organisms/data-grid/dataGridUtils.ts:36</sub>

```ts
<T extends WijmoRowItem = WijmoRowItem>(): { setSummaryTooltip: (grid: FlexGrid<T>) => void; setCellTooltip: (grid: FlexGrid<T>) => void; setAggregationRow: (grid: FlexGrid<T>, placement: "above" | "below") => void; setCheckbox: (grid: FlexGrid<T>) => any; formatPopupIcon: (grid: FlexGrid<T>, formatItemEventArgs: FormatItemEventArgs) => void; formatEditableColumns: (grid: FlexGrid<T>, formatItemEventArgs: FormatItemEventArgs, hasCheckboxColumn?: boolean) => void; formatSortableColumns: (grid: Fl
```

### useDirtyCheck  <sub>packages/shared/src/stores/useDirtyRegistry.ts:164</sub>

```ts
(check: DirtyCheck, enabled?: boolean): void
```

### useDirtyReset  <sub>packages/shared/src/stores/useDirtyRegistry.ts:220</sub>

```ts
(reset: DirtyReset, enabled?: boolean): void
```

### useFilteredGridCount  <sub>packages/shared/src/hooks/useFilteredGridCount.ts:14</sub>

```ts
(gridRef: any, gridFilterRef: any, dataCount: number): number
```

### useFlexGridRowDnD  <sub>packages/shared/src/components/organisms/column-button/hook/useFlexGridDnD.ts:12</sub>

```ts
(): FlexGridRowDnD
```

### useGuardedDialogClose  <sub>packages/shared/src/stores/useDirtyRegistry.ts:192</sub>

```ts
(close: () => void): () => void
```

### useInsertedRows  <sub>packages/shared/src/hooks/useInsertedRows.ts:200</sub>

```ts
<T extends object>(gridRef?: InsertAnchorGridRef): UseInsertedRowsResult<T>
```

props/params:

- `current?: InsertAnchorGrid`

### useMenuId  <sub>packages/shared/src/stores/createStore.ts:29</sub>

```ts
(): any
```

### useRowParamCombos  <sub>packages/shared/src/components/organisms/data-grid/useRowParamCombos.ts:104</sub>

```ts
({ columns, sheetName }: UseRowParamCombosParams): { rowParamRows: any; insertRowParamRows: any; registerTouchedRow: any; }
```

props/params:

- `columns: RawFlexGridColumnConfig[] — 표시 중인 컬럼 메타 (D 컬럼만 골라 쓴다)`
- `sheetName?: string — 그리드 시트명 — 행 조합 콤보 요청에도 sheetName 으로 실어 보낸다(그리드 콤보 규약, DataGrid 가 넘김).`

### useTabComboQuery  <sub>packages/shared/src/hooks/useCustomQueryClient.ts:254</sub>

```ts
({ filters, enabled, queryOptions, }: { filters: ComboParam; enabled?: boolean; queryOptions?: Omit<UseQueryOptions<ComboResponse[]>, "queryKey" | "queryFn">; }): any
```

props/params:

- `filters: ComboParam`
- `enabled?: boolean`
- `queryOptions?: Omit<UseQueryOptions<ComboResponse[]>, "queryKey"`
- `"queryFn">`

# components (69)

사용 수 내림차순. **신규 화면은 여기 있는 것만 쓴다** — 없으면 사전(map_control.csv) 보완 제안이 먼저(룰 23).

## app-shell

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **AtlasBridge** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  |  |
| **MDIContainer** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  |  |
| **MDITabs** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  |  |
| **RouterSync** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  |  |
| **ViewContainer** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  |  |

### AtlasBridge  <sub>apps/web/src/mdi/AtlasBridge.tsx:30</sub>

```ts
(): any
```

### MDIContainer  <sub>apps/web/src/mdi/MDIContainer.tsx:32</sub>

```ts
({ mirrorRouteOnMount }: MDIContainerProps): any
```

props/params:

- `mirrorRouteOnMount?: boolean — 404 로 진입한 경우 false — RouterSync 가 마운트 시 URL 을 덮어쓰지 않게 한다`

### MDITabs  <sub>apps/web/src/mdi/MDITabs.tsx:16</sub>

```ts
(): any
```

### RouterSync  <sub>apps/web/src/mdi/RouterSync.tsx:34</sub>

```ts
({ mirrorOnMount }: RouterSyncProps): any
```

props/params:

- `mirrorOnMount?: boolean — 마운트 시점에 활성 탭 URL 로 미러링할지 여부. `/` · `/home` 처럼 셸만 매칭된 경로는 활성 탭 URL 로 보정해야 하지만, 404 로 진입한 경우엔 보정하면 안 된다(NotFound 가 뜨기도 전에 튕겨나감). 마운트 이후의 탭 전환/오픈은 이 값과 무관하게 항상 미러링`

### ViewContainer  <sub>apps/web/src/mdi/ViewContainer.tsx:78</sub>

```ts
(): any
```

## master-common

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **PeriodField** | `features/master/src/components` | 60 | UsrDateRangePicker / UsrDateRangePicker3 / UsrDateRangePickerWtWeek / UsrMonthRangePicker / UsrDateRangePickerWtWeek2 / field:^(drp\|d\|mrp)Period\d*$\|^dCalendar$\|^drpDate$ |  |
| **ItemByDivisionModal** | `features/master/src/components` | 46 | button:^btn(Item\|Model\|Material)(Id)?$ |  |
| **MaterialByDivisionModal** | `features/master/src/components` | 44 |  |  |
| **MeasureSelectModal** | `features/master/src/components` | 29 | button:^btnMeasure$ |  |
| **ProjectByDivisionModal** | `features/master/src/components` | 29 | button:^btnProject$ |  |
| **ItemField** | `features/master/src/components` | 11 | field:^(txt\|usr)(Item\|ItemId\|Model\|ModelId\|Nickname\|Material\|MaterialId)$ / field:^(txt\|usr)NickName$ |  |
| **ProjectField** | `features/master/src/components` | 11 | field:^(txt\|usr)Project(Code)?$ |  |
| **OwnerField** | `features/master/src/components` | 9 | field:^(txt\|cbo\|usr)Owner$ |  |
| **DivisionField** | `features/master/src/components` | 6 | field:^cboDivision$\|^cboDiv$ |  |
| **ModelByDivisionPopup** | `features/master/src/components` | 6 |  |  |
| **CustomerModal** | `features/master/src/components` | 5 | button:^btnCustomer$ |  |
| **SalesSiteField** | `features/master/src/components` | 5 | field:^clbSalesSite$\|^cboSalesSite$ | // 4. SalesSiteField (size=4, combo=SalesSite) // |
| **ContributeVersionModal** | `features/master/src/components` | 4 |  |  |
| **VersionField** | `features/master/src/components` | 4 | field:^cboVersion$\|^cboVer(sion)?No$ |  |
| **EndCustomerField** | `features/master/src/components` | 3 | field:^clb(End)?Customer$\|^cboEndCustomer$ | // 3. EndCustomerField (size=4, combo=EndCustomer) // |
| **OwnerByDivisionModal** | `features/master/src/components` | 3 | button:^btnOwner$ |  |
| **PlantSiteField** | `features/master/src/components` | 3 | field:^clbPlantSite$\|^cboPlantSite$\|^clbPlant$ | // 6. PlantSiteField (size=4, combo=PlantSitebyEndCustomer) // // Plant Site — combo `PlantSitebyEndCustomer`. // 2026-08-22 콤보 SQL 개정: 파라미터 |
| **RegionModal** | `features/master/src/components` | 3 |  |  |
| **TeamField** | `features/master/src/components` | 3 | field:^clbTeam$\|^cboTeam$ | // 2. TeamField (size=4, combo=TeambyDivision) // |
| **TeamModal** | `features/master/src/components` | 3 |  |  |
| **BizTypeField** | `features/master/src/components` | 2 | field:^cboBizType$\|^cboBiz / field:^clbBizType$ | // 7. BizTypeField (size=4, combo=BizType — SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='BIZ_TYPE') // |
| **ColumnSettingModal** | `features/master/src/components` | 2 |  |  |
| **OwnerModal** | `features/master/src/components` | 2 |  |  |
| **VersionModal** | `features/master/src/components` | 2 |  |  |
| **YearField** | `features/master/src/components` | 2 | field:^cboYear$\|^cboYYYY$ |  |
| **BucketField** | `features/master/src/components` | 1 | field:^cboBucket(Type)?$ |  |
| **CapaNewModelPopup** | `features/master/src/components` | 1 |  |  |
| **ItemByPlantSiteModal** | `features/master/src/components` | 1 |  |  |
| **ProjectByDivisionPopup** | `features/master/src/components` | 1 |  |  |
| **ProjectModal** | `features/master/src/components` | 1 |  |  |
| **SearchOverRangeField** | `features/master/src/components` | 1 | field:^chk(Over\|SearchOver)Range$ |  |
| **StorageLocationModal** | `features/master/src/components` | 1 |  |  |
| **CascadeFields** | `features/master/src/components` | 0 |  | 단계를 levels 순서대로 붙여서 렌더하는 기본형. 중간에 다른 조회조건이 끼는 화면은 이 컴포넌트 대신 useCascadeFields 를 쓴다. prop 설명과 콤보 SQL 규약은 이 파일 헤더 참조. |
| **ContributeRateModal** | `features/master/src/components` | 0 |  | AS-IS DMF0043_ContributeRatePopup (.cs L573 btnCutOff_Click) — 기여율 설정 모달. // RegionModal 표준 (#67) — open / modalClose props 외부 제어 + staticCo |
| **SoldToCustomerField** | `features/master/src/components` | 0 | field:^clbSoldTo\|^cboSoldTo | // 5. SoldToCustomerField (size=4, combo=SoldCustomer) // |

### PeriodField  <sub>features/master/src/components/searchFields/SearchFields.tsx:1123</sub>

```ts
({ start, end, onChange, gridSize, label, mode, disabledStart, disabled, }: PeriodFieldProps): any
```

props/params:

- `start: string`
- `end: string`
- `onChange: (start: string, end: string) => void`
- `gridSize?: number`
- `label?: string`
- `mode?: "date"`
- `"month" — 'month' = 년월(YYYYMM) 구간 — AS-IS drpPeriodMonth 계열 화면(DMF0074 등, usecase='month' 정본 = DemandManagerForm). 기본 'date'(YYYYMMDD) — 기존 사용처 회귀 0. ⚠ 값 형식이 모드에 따라 다르다(Y`
- `disabledStart?: boolean — 시작(From) 피커를 비활성화한다 — AS-IS 일부 화면(SCP0006 등)이 `MonthMin1=MonthMax1`로 From 월 자체를 고정하는 동작 재현용(design/02_search-combo.md §2 #6). 기본 false — 미지정 시 기존 사용처와 동일하게 동작(회`
- `disabled?: boolean — From/To 두 피커 모두 비활성화 (예: SSP0015 Packer 시트 — Period 편집 불가). 기본 false(회귀 0).`

### ItemByDivisionModal  <sub>features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx:129</sub>

```ts
({ open, modalClose, setSelectedValue, preSearchParams, callFromCell: _callFromCell, headerTitle, multiCheckbox, visibleConditions, visibleColumns, dialogSize, smallDivision, }: ItemByDivisionModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (items: string, itemName?: string, itemClassName?: string, itemType?: string, ni`
- `preSearchParams: ProcRequest<"COM0008", "itemByDivision">`
- `callFromCell: boolean`
- `headerTitle?: string`
- `multiCheckbox?: boolean`
- `visibleConditions?: ItemModalCondition[] — ⭐ 노출할 검색조건(옵션). 미지정이면 DEFAULT_ITEM_MODAL_CONDITIONS = 기존 동작 그대로(회귀 0). 여기 없는 조건은 화면에서 빠질 뿐 **조회 조건에서 빠지는 게 아니다** — Div/Team/EndCustomer/ SalesSite/Project 는 전부 `
- `visibleColumns?: ItemModalColumn[] — ⭐ 결과 그리드에 남길 컬럼(colNm)과 그 순서(옵션). 미지정이면 admin 컬럼 메타 전체(기존 동작). 컬럼 메타는 division 단위(COM0008 fetchStaticColumns)라 호출 화면별로 나눌 수단이 없다. 같은 division 을 쓰는 다른 호출처에 영향을 주`
- `dialogSize?: number — ⭐ 팝업 가로 폭(px, 옵션). 미지정이면 1000 = 기존 동작 그대로(회귀 0). 검색조건/컬럼을 줄여 연 화면에서 폭까지 좁히라고 둔 opt-in.`
- `smallDivision?: { menuId: string; itemType?: string; } — 좁은 조회(itemBySmallDivision) 사용 opt-in. 미지정이면 기존 itemByDivision 그대로(회귀 0). 넓은 쪽은 team/end customer/site 축까지 펼친 목록이라, visibleColumns 로 컬럼을 좁혀 연 화면에서는 같은 Model 이 여러`

### MaterialByDivisionModal  <sub>features/master/src/components/materialByDivisionModal/MaterialByDivisionModal.tsx:84</sub>

```ts
({ open, modalClose, setSelectedValue, preSearchParams, headerTitle, multiCheckbox, multiDivision, dialogSize, }: MaterialByDivisionModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (items: string, itemName?: string, itemClassName?: string, nickName?: string) => — 선택 확정 콜백. AS-IS SetItem 이 넘기던 값과 같은 순서: (Material Code, Description, Class Name, Nickname). 다건 선택 시 Code 는 콤마 결합, 나머지는 첫 행.`
- `preSearchParams: ProcRequest<"COM0013", "materialByDivision"> — 열 때 넘기는 조회 파라미터. - divisionId: 호출 화면의 Division(단일). 팝업에서 비활성 표시. - scpModuleType: 호출 화면 ID(예: 'SCP0022'). SP 의 Operation Group 분기 기준. - operationGroup: 대개 빈값(호출`
- `headerTitle?: string — 호출처 헤더 title 커스터마이즈(옵션). 기본 'Material by Division'.`
- `multiCheckbox?: boolean — 멀티 선택 모드(옵션, default false). true 시 체크박스 컬럼으로 선택.`
- `multiDivision?: boolean — Division 검색조건 멀티 표시 모드(옵션, default false). false 면 호출 화면의 단일 divisionId 를 disabled 로 고정 표시(AS-IS SCM0002 계약, 27개+ 화면 공용 기본값). true 면 호출 화면이 넘긴 콤마 결합 divisionId(`
- `dialogSize?: number — 팝업 가로 폭(px, 옵션).`

### MeasureSelectModal  <sub>features/master/src/components/measureSelectModal/MeasureSelectModal.tsx:88</sub>

```ts
({ open, modalClose, measures, visibleMeasures, onApply, fallbackCodes, showMeasureCode, }: MeasureSelectModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `measures: MeasureMeta[] — 동적 fetch measure (SCM_MST_SHEET_MEASURE)`
- `visibleMeasures: string[] — 현재 표시 중인 measure 코드 목록(null = 전체). 모달 재진입 시 좌/우 상태 복원.`
- `onApply: (measureCodes: string[]) => void — OK — 표시할 measure 코드 목록(전체 선택 시 null) 적용.`
- `fallbackCodes?: readonly string[] — measures 0건(BE 미적재) 시 degrade 용 코드 목록. 미지정 시 빈 목록.`
- `showMeasureCode?: boolean — Measure Code(colNm) 컬럼 노출 여부. 미지정(false) 이면 표시명만 노출. DMF0082 전용 — 통합테스트 1st No.40 "Measure Code, Measure Name만" 요구.`

### ProjectByDivisionModal  <sub>features/master/src/components/projectByDivisionModal/ProjectByDivisionModal.tsx:48</sub>

```ts
({ open, modalClose, setSelectedValue, preSearchParams, callFromCell: _callFromCell, multiCheckbox, }: ProjectByDivisionModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (projects: string, projectsNames?: string, projectStatus?: string, bizTypeName?:`
- `preSearchParams: ProcRequest<"COM0005", "projectByDivision">`
- `callFromCell: boolean`
- `multiCheckbox?: boolean`

### ItemField  <sub>features/master/src/components/searchFields/SearchFields.tsx:946</sub>

```ts
(props: ItemFieldProps): any
```

props/params:

- `itemIds?: string[]`
- `multiCheckbox?: boolean`
- `value: string[]`
- `onChange: (v: string[]) => void`
- `division: string`
- `deptIds?: string[]`
- `endCustomers?: string[]`
- `scmSiteIds?: string[]`
- `projectCodes?: string[]`
- `gridSize?: number`

### ProjectField  <sub>features/master/src/components/searchFields/SearchFields.tsx:868</sub>

```ts
(props: ProjectFieldProps): any
```

props/params:

- `multiCheckbox?: boolean`
- `disabled?: boolean`
- `value: string[]`
- `onChange: (v: string[]) => void`
- `division: string`
- `deptIds?: string[]`
- `endCustomers?: string[]`
- `scmSiteIds?: string[]`
- `projectCodes?: string[]`
- `gridSize?: number`

### OwnerField  <sub>features/master/src/components/searchFields/SearchFields.tsx:1021</sub>

```ts
(props: OwnerFieldProps): any
```

props/params:

- `owners?: string[]`
- `multiCheckbox?: boolean`
- `value: string[]`
- `onChange: (v: string[]) => void`
- `division: string`
- `deptIds?: string[]`
- `endCustomers?: string[]`
- `scmSiteIds?: string[]`
- `projectCodes?: string[]`
- `gridSize?: number`

### DivisionField  <sub>features/master/src/components/searchFields/SearchFields.tsx:286</sub>

```ts
({ value, onChange, gridSize, disabled }: DivisionFieldProps): any
```

props/params:

- `disabled?: boolean`
- `value: string`
- `onChange: (v: string) => void`
- `gridSize?: number`

### ModelByDivisionPopup  <sub>features/master/src/components/modelByDivisionPopup/ModelByDivisionPopup.tsx:75</sub>

```ts
({ open, onClose, onSelect, params, multiSelect, }: ModelByDivisionPopupProps): any
```

props/params:

- `open: boolean`
- `onClose: () => void`
- `onSelect?: (selected: ModelSelection) => void`
- `params?: ModelByDivisionPopupParams`
- `multiSelect?: boolean — 다중선택 opt-in (기본 false = 기존 단일선택). AS-IS `Form_Load` 첫 인자 bMultiSelect 자리다. true 면 체크박스 열이 생기고, OK 가 체크된 행들을 AS-IS 와 같은 규약으로 돌려준다 — `SetItem()`(SCM0002_ItembyDiv`

### CustomerModal  <sub>features/master/src/components/customerModal/CustomerModal.tsx:32</sub>

```ts
({ open, modalClose, setSelectedValue, divisionId, soldTo, shipTo, }: CustomerModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (soldTo: string, soldToDesc: string, shipTo: string, shipToDesc: string, shipToR`
- `divisionId?: string`
- `soldTo?: string`
- `shipTo?: string`

### SalesSiteField  <sub>features/master/src/components/searchFields/SearchFields.tsx:464</sub>

```ts
({ value, onChange, division, gridSize, comboId, endCustomer, deptId, asYn, cascade, sortBy, debugLabel, }: MultiFieldProps & { comboId?: string; endCustomer?: string; deptId?: string; asYn?: boolean; cascade?: CascadeFilter; sortBy?: DropdownSortKey; debugLabel?: string; }): any
```

props/params:

- `value: string[]`
- `onChange: (v: string[]) => void`
- `division?: string`
- `gridSize?: number`
- `comboId?: string — ⭐ 2026-07-23 (조회조건 AS-IS 정합, hook #117) — opt-in 서버 바인드 콤보 대체. comboId 지정 시 'UserSiteByEndCustomer'(AS-IS UP_FX SiteByEndCustomer/40 1:1) 형태의`
- `endCustomer?: string`
- `deptId?: string`
- `asYn?: boolean`
- `cascade?: CascadeFilter — 2026-08-22 opt-in — 클라이언트 cascade 필터. 컬럼명 -> 값 매핑 (CascadeFilter 주석 참조). 기본 'SalesSite' 콤보는 DIVISION_ID / DEPT_ID / PROJECT_CODE 를 함께 반환하므로 division-team-projec`
- `sortBy?: DropdownSortKey — 목록 정렬. 미지정 = 위 TEMP_LIST_SORT_BY(임시 일괄 'label'). 화면이 명시하면 그 값이 이긴다. 'label' 은 표시명 기준 숫자-영어-한글 순 (CustomDropdown sortOptionsBy 참조). 표시 계층 전용이라 cascade 가 좁히는 원본 행`
- `debugLabel?: string — 임시 로컬 디버그 — 넘기면 cascade 단계별 결과가 콘솔에 찍힌다. SearchFields.debug 참조.`

### ContributeVersionModal  <sub>features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx:92</sub>

```ts
({ open, modalClose }: ContributeVersionModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`

### VersionField  <sub>features/master/src/components/searchFields/SearchFields.tsx:1325</sub>

```ts
({ value, onOpenPopup, gridSize, label, emptyText, onValueChange, versionNo, }: VersionFieldProps): any
```

props/params:

- `value: string`
- `onOpenPopup: () => void`
- `gridSize?: number`
- `label?: string — 라벨 override — 화면별 Version 명칭이 다른 경우(DMF0044/0049 BP/SP Version). 미전달 = LBL00513 'Version'`
- `emptyText?: string — value 가 빈 값일 때 표시할 문자열. 미전달 = 'Current' (DMF0020 기존 동작 보존)`
- `onValueChange?: (v: string) => void — 직접 입력(key-in) 허용. 미전달 = 팝업 선택 전용 (기존 동작 그대로 — 회귀 0). 사용자가 친 문자열이 가공 없이 그대로 올라오므로, 조회키/표시문 매핑은 호출 측이 정한다.`
- `versionNo?: string — 조회에 실제로 나가는 VERSION_NO. 팝업이 채운 표시문(`value`)은 'VERSION_NO + 설명' 이라 그 상태에서 편집을 시작하면 설명까지 조회키로 올라가 0건이 된다. 이 값을 주면 포커스 순간 표시문을 코드만 남긴 상태로 되돌린다 (정본 DemandManagerFor`

### EndCustomerField  <sub>features/master/src/components/searchFields/SearchFields.tsx:376</sub>

```ts
({ value, onChange, division, gridSize, comboId, cascade, disabled, sortBy, debugLabel, }: MultiFieldProps & { comboId?: string; cascade?: CascadeFilter; disabled?: boolean; sortBy?: DropdownSortKey; debugLabel?: string; }): any
```

props/params:

- `value: string[]`
- `onChange: (v: string[]) => void`
- `division?: string`
- `gridSize?: number`
- `comboId?: string — ⭐ 2026-07-23 (DMF0003 조회조건 AS-IS 정합) — opt-in 콤보 대체. 기본 'EndCustomer'(기존 화면 무영향). DMF0003 은 AS-IS BigFilter 1:1 등록본 'EndCustomerByDivision'(40=SITE_ITEM owner-d`
- `cascade?: CascadeFilter — 클라이언트 cascade 필터. CascadeFilter 주석 참조. 예: { DEPT_ID: sc.deptIds }`
- `disabled?: boolean — 2026-08-22 opt-in — division 기준 잠금 (AS-IS DMF0043 Enabled=false 계열). 미지정 = 기존 동작(무영향). 판정은 호출 측 책임 (예: divisionId === '40').`
- `sortBy?: DropdownSortKey — 목록 정렬. 미지정 = 위 TEMP_LIST_SORT_BY(임시 일괄 'label'). 화면이 명시하면 그 값이 이긴다. 'label' 은 표시명 기준 숫자-영어-한글 순 (CustomDropdown sortOptionsBy 참조). 표시 계층 전용이라 cascade 가 좁히는 원본 행`
- `debugLabel?: string — 임시 로컬 디버그 — 넘기면 cascade 단계별 결과가 콘솔에 찍힌다. SearchFields.debug 참조.`

### OwnerByDivisionModal  <sub>features/master/src/components/ownerByDivisionModal/OwnerByDivisionModal.tsx:36</sub>

```ts
({ open, modalClose, setSelectedValue, preSearchParams, ownerId, multiCheckbox, }: OwnerByDivisionModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (owners: string, ownerNames?: string) => void`
- `preSearchParams: ProcRequest<"COM0006", "ownerByDivision">`
- `ownerId?: string`
- `multiCheckbox?: boolean`

### PlantSiteField  <sub>features/master/src/components/searchFields/SearchFields.tsx:697</sub>

```ts
({ value, onChange, division, endCustomer, gridSize, comboId, cascade, disabled: disabledOverride, sortBy, debugLabel, }: MultiFieldProps & { endCustomer?: string; comboId?: string; cascade?: CascadeFilter; disabled?: boolean; sortBy?: DropdownSortKey; debugLabel?: string; }): any
```

props/params:

- `value: string[]`
- `onChange: (v: string[]) => void`
- `division?: string`
- `gridSize?: number`
- `endCustomer?: string — End Customer 조회조건 (콤마 조인). 콤보의 END_CUSTOMER 컬럼과 엄격 매칭한다.`
- `comboId?: string — 2026-08-20 (DMF0048 조회조건 AS-IS 정합) — opt-in. comboId 기본 'PlantSitebyEndCustomer'(파라미터 없음). DMF0048 은 AS-IS UP_FX_GetCommonDataList 기준 'FromSiteByDivision' 사용 — `
- `cascade?: CascadeFilter — 추가 클라이언트 cascade 단계. CascadeFilter 주석 참조. END_CUSTOMER 단계 뒤에 붙는다.`
- `disabled?: boolean — 활성 기준 오버라이드 — 기본은 81 계열 전용 게이트. DMF0048 처럼 AS-IS 가 40 만 비활성인 화면은 호출 측이 직접 지정한다.`
- `sortBy?: DropdownSortKey — 목록 정렬. 미지정 = 위 TEMP_LIST_SORT_BY(임시 일괄 'label'). 화면이 명시하면 그 값이 이긴다. 'label' 은 표시명 기준 숫자-영어-한글 순 (CustomDropdown sortOptionsBy 참조). 표시 계층 전용이라 cascade 가 좁히는 원본 행`
- `debugLabel?: string — 임시 로컬 디버그 — 넘기면 cascade 단계별 결과가 콘솔에 찍힌다. SearchFields.debug 참조.`

### RegionModal  <sub>features/master/src/components/regionModal/RegionModal.tsx:31</sub>

```ts
({ open, modalClose, setSelectedValue, country, city, }: RegionModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (countryCode: string, countryName: string, cityCode: string, cityName: string) =`
- `country?: string`
- `city?: string`

### TeamField  <sub>features/master/src/components/searchFields/SearchFields.tsx:322</sub>

```ts
({ value, onChange, division, gridSize, comboId, }: MultiFieldProps & { comboId?: string; }): any
```

props/params:

- `value: string[]`
- `onChange: (v: string[]) => void`
- `division?: string`
- `gridSize?: number`
- `comboId?: string — ⭐ 2026-07-23 (DMF0003 조회조건 AS-IS 정합) — opt-in 콤보 대체. 기본 'TeambyDivision'(기존 화면 무영향). DMF0003 은 AS-IS BigFilter 1:1 등록본 'UserTeamByDivision'(SITE_ITEM.OWNER 1번 토`

### TeamModal  <sub>features/master/src/components/teamModal/TeamModal.tsx:26</sub>

```ts
({ open, modalClose, setSelectedValue, teamId, teamName, divisionId, }: TeamModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (teamId: string, teamName?: string) => void`
- `teamId?: string`
- `teamName?: string`
- `divisionId?: string`

### BizTypeField  <sub>features/master/src/components/searchFields/SearchFields.tsx:814</sub>

```ts
({ value, onChange, gridSize, comboId, division, }: Omit<MultiFieldProps, "division"> & { comboId?: string; division?: string; }): any
```

props/params:

- `value: string[]`
- `onChange: (v: string[]) => void`
- `gridSize?: number`
- `comboId?: string — ⭐ 2026-07-23 (DMF0003 조회조건 AS-IS 정합) — opt-in. comboId 기본 'BizType'(전역 lookup — 기존 화면 무영향). DMF0003 은 AS-IS BigFilter 1:1 'BizTypebyDivision'(DM_BIZ_TYPE(40) UN`
- `division?: string`

### ColumnSettingModal  <sub>features/master/src/components/columnSettingModal/ColumnSettingModal.tsx:70</sub>

```ts
({ open, modalClose, menuId, sheetName, columnType, divisionId, fallbackColumns, onSave, title, initialVisibleKeys, leftTitle, rightTitle, }: Props): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `menuId: string — 화면 메뉴 ID — SP `programId` 인자`
- `sheetName: string — SP 의 sheetName 인자 (예: 'main', 'ContributeSalesList')`
- `columnType?: string — SP 의 columnType 인자 (예: 'main', 'C') — 기본 sheetName 과 동일`
- `divisionId?: string — SP 의 divisionId 인자`
- `fallbackColumns?: ColumnSettingFallback[] — BE 결과 없을 때 fallback (FE column meta)`
- `onSave: (settings: ColumnSettingRow[]) => void — OK 클릭 시 callback — User flag='Y' rows + sort order + Sort method`
- `title?: string — popup title (기본: 'Column Setting')`
- `initialVisibleKeys?: string[] — 이전에 OK 했던 visible column 키 목록 (popup 재진입 시 좌/우 상태 복원)`
- `leftTitle?: string — dual list 좌측 상단 라벨 (예: 'Invisible') — 미지정 시 라벨 없음(기존 사용처 무영향)`
- `rightTitle?: string — dual list 우측 상단 라벨 (예: 'Visible')`

### OwnerModal  <sub>features/master/src/components/ownerModal/OwnerModal.tsx:36</sub>

```ts
({ open, modalClose, setSelectedValue, divisionId, ownerId, singleSelect, maxSelect, }: OwnerModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (selectedOwners: ResponseData<"COM0004", "owner", "o_rc1">[]) => void`
- `divisionId: string`
- `ownerId?: string`
- `singleSelect?: boolean — true 면 담당자를 한 명만 확정할 수 있다 — 2명 이상 선택 후 OK 시 경고하고 닫지 않는다.`
- `maxSelect?: number — 확정할 수 있는 최대 인원. 넘게 선택한 채 OK 를 누르면 경고하고 닫지 않는다(singleSelect 와 같은 방식). 미지정이면 상한 없음(종전 동작). singleSelect 가 켜져 있으면 그 판정이 먼저다. 첫 사용처 DMF0005 Owner 10명 제한 (2026-10-13`

### VersionModal  <sub>features/master/src/components/versionModal/VersionModal.tsx:61</sub>

```ts
({ open, modalClose, divisionId, projectType, onSelect, }: VersionModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `divisionId: string`
- `projectType: string`
- `onSelect: (versionNo: string, label: string) => void`

### YearField  <sub>features/master/src/components/searchFields/SearchFields.tsx:1212</sub>

```ts
({ value, onChange, gridSize, label, required, minYear, maxYear, }: YearFieldProps): any
```

props/params:

- `value: string`
- `onChange: (v: string) => void`
- `gridSize?: number`
- `label?: string`
- `required?: boolean`
- `minYear?: number`
- `maxYear?: number`

### BucketField  <sub>features/master/src/components/searchFields/SearchFields.tsx:1269</sub>

```ts
({ value, onChange, gridSize }: BucketFieldProps): any
```

props/params:

- `value: "W"`
- `"M"`
- `onChange: (v: "W"`
- `"M") => void`
- `gridSize?: number`

### CapaNewModelPopup  <sub>features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx:85</sub>

```ts
({ open, onClose, params }: Props): any
```

props/params:

- `open: boolean`
- `onClose: () => void`
- `params?: CapaNewModelPopupParams`

### ItemByPlantSiteModal  <sub>features/master/src/components/itemByPlantSiteModal/ItemByPlantSiteModal.tsx:50</sub>

```ts
({ open, modalClose, setSelectedValue, preSearchParams, headerTitle, }: ItemByPlantSiteModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (itemId: string, itemName?: string, itemClassName?: string, itemType?: string, n`
- `preSearchParams: ProcRequest<"COM0014", "itemByPlantSite">`
- `headerTitle?: string`

### ProjectByDivisionPopup  <sub>features/master/src/components/projectByDivisionPopup/ProjectByDivisionPopup.tsx:56</sub>

```ts
({ open, onClose, onSelect, params, }: ProjectByDivisionPopupProps): any
```

props/params:

- `open: boolean`
- `onClose: () => void`
- `onSelect?: (selected: ProjectByDivisionSelection) => void`
- `params?: ProjectByDivisionPopupParams`

### ProjectModal  <sub>features/master/src/components/projectModal/ProjectModal.tsx:24</sub>

```ts
({ open, modalClose, setSelectedValue, preSearchParams, preProject, }: ProjectModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (projects: string, projectsNames?: string) => void`
- `preSearchParams: ProcRequest<"COM0012", "project">`
- `preProject: string`

### SearchOverRangeField  <sub>features/master/src/components/searchFields/SearchFields.tsx:1376</sub>

```ts
({ value, onChange, gridSize }: CheckFieldProps): any
```

props/params:

- `value: boolean`
- `onChange: (v: boolean) => void`
- `gridSize?: number`

### StorageLocationModal  <sub>features/master/src/components/storageLocationModal/StorageLocationModal.tsx:24</sub>

```ts
({ open, modalClose, setSelectedValue, divisionId, storageId, }: StorageLocationModalProps): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (plantId: string, storageId: string, storageDesc: string) => void`
- `divisionId?: string`
- `storageId?: string`

### CascadeFields  <sub>features/master/src/components/searchFields/CascadeFields.tsx:172</sub>

```ts
<V extends object>(props: CascadeFieldsProps<V>): any
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

### ContributeRateModal  <sub>features/master/src/components/contributeRateModal/ContributeRateModal.tsx:32</sub>

```ts
({ open, yyyy, modalClose, setSelectedValue, }: ContributeRateModalProps): any
```

props/params:

- `open: boolean`
- `yyyy: string`
- `modalClose: () => void`
- `setSelectedValue: (row: ContributeRateModalSelection) => void`

### SoldToCustomerField  <sub>features/master/src/components/searchFields/SearchFields.tsx:585</sub>

```ts
({ value, onChange, division, gridSize, comboId, endCustomer, deptId, cascade, debugLabel, }: MultiFieldProps & { comboId?: string; endCustomer?: string; deptId?: string; cascade?: CascadeFilter; debugLabel?: string; }): any
```

props/params:

- `value: string[]`
- `onChange: (v: string[]) => void`
- `division?: string`
- `gridSize?: number`
- `comboId?: string — opt-in 서버 바인드 콤보 대체 — SalesSiteField 와 같은 모양이다. 미지정이면 기본 'SoldCustomer' 를 전량 받아 클라에서 좁힌다(종전 동작). 지정하면`
- `endCustomer?: string`
- `deptId?: string`
- `cascade?: CascadeFilter — 클라이언트 cascade 필터. CascadeFilter 주석 참조. 예: { TEAM_CODE: sc.deptIds }`
- `debugLabel?: string — 임시 로컬 디버그 — 넘기면 cascade 단계별 결과가 콘솔에 찍힌다. SearchFields.debug 참조.`

## shared

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **DataGrid** | `@shared/components` | 262 | FpSpread |  |
| **SearchArea** | `@shared/components` | 166 | UsrConditionPanel / button:^btn(Search\|Find\|Inquiry\|Retrieve)$ / button:^(FindButton\|btnQuery)$ |  |
| **CustomDropdown** | `@shared/components` | 163 | UsrCombo / UsrComboBox / ComboBox / UsrCheckedList / UsrCheckedList2 / CheckedListBoxControl |  |
| **MainTitle** | `@shared/components` | 136 |  |  |
| **SubTitle** | `@shared/components` | 136 | button:^btnExcel(Down\|Download\|Export)?$ |  |
| **CustomDialog** | `@shared/components` | 88 |  |  |
| **ResultArea** | `@shared/components` | 48 |  |  |
| **TabItem** | `@shared/components` | 28 | TabPage |  |
| **TabWrapper** | `@shared/components` | 28 | TabControl |  |
| **ColumnLayoutModal** | `@shared/components` | 26 | button:^btnColumn$ |  |
| **PeriodRangePicker** | `@shared/components` | 17 |  |  |
| **SsoUserModal** | `@shared/components` | 11 |  |  |
| **ColumnSelectDualList** | `@shared/components` | 3 |  |  |
| **MessageModal** | `@shared/components` | 2 |  |  |
| **Alert** | `@shared/components` | 1 |  |  |
| **CascadeDropdown** | `@shared/components` | 1 |  | 종속 콤보(공유 캐스케이더) — 1~N단계 필드를 항상 나란히 보여주되, 어느 필드를 누르든 같은 액션(하나의 컬럼 팝업)이 열린다. 팝업에서 경로를 골라 내려가면 각 단계 필드가 함께 채워지고, 상위를 다시 고르면 하위는 초기화된다. 값은 name  |
| **SsoDeptModal** | `@shared/components` | 1 |  |  |
| **ColorPickerButton** | `@shared/components` | 0 |  |  |
| **ColumnButton** | `@shared/components` | 0 |  |  |
| **ColumnGrids** | `@shared/components` | 0 |  |  |
| **ColumnLayoutList** | `@shared/components` | 0 |  |  |
| **ControlButtonGroup** | `@shared/components` | 0 |  |  |
| **CustomDropdownMui** | `@shared/components` | 0 |  | export const CustomDropdownMui = ({ ...props }: SingleProps<Lookup> \| MultipleProps<Lookup>) => { |
| **CustomListbox** | `@shared/components` | 0 |  |  |
| **CustomListboxRow** | `@shared/components` | 0 |  |  |
| **DROPDOWN_SEARCH_ATTR** | `@shared/components` | 0 |  | CustomDropdown 이 blur 판정에 쓰는 표식. 필드 입력창의 blur 를 막을지, // 검색칸의 blur 로 목록을 닫을지 가르는 기준이라 양쪽이 같은 값을 봐야 한다. |
| **OlapPivotGrid** | `@shared/components` | 0 |  |  |
| **SEARCH_AREA_MIN_WIDTH** | `@shared/components` | 0 |  | 조회조건 필드(4개/행, 각 25%)가 이 폭 아래에서 더 줄지 않도록 유지하는 페이지 최소너비. // ViewContainer(apps/web/src/mdi)가 페이지 전체(MainTitle+SearchArea+SubTitle+Result)를 //  |
| **ToastMessage** | `@shared/components` | 0 |  |  |

### DataGrid  <sub>packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1824</sub>

```ts
<T extends WijmoRowItem = WijmoRowItem>({ gridFilterRef, gridRef, editTrackerRef, itemsSource, staticColumns, dynamicColumns, useSummaryTooltip, useCellTooptip, useCheckbox, useResultColumns, useAggregationRow, aggregationRowPlacement, emptyCellAsZero, negativeCellAsZero, numberRules, excludeFromDirtyCheck, useContextMenu, contextMenuItems, excelFileName, layoutKey, comboParams, sheetName, allowMerging, selectionMode, initialized, headerRowHeight, dblClick, click, ...gridProps }: DataGridProps<T
```

props/params:

- `gridFilterRef?: MutableRefObject<any>`
- `gridRef?: MutableRefObject<any>`
- `editTrackerRef?: MutableRefObject<any>`
- `itemsSource?: T[]`
- `staticColumns?: RawFlexGridColumnConfig[]`
- `dynamicColumns?: FlexGridColumnConfig[]`
- `useSummaryTooltip?: boolean`
- `useCellTooptip?: boolean`
- `useCheckbox?: boolean`
- `useResultColumns?: boolean`
- `useAggregationRow?: boolean`
- `aggregationRowPlacement?: "above"`
- `"below"`
- `emptyCellAsZero?: (binding: string) => boolean — 편집 종료 시 비어 있는 셀을 '0' 으로 채울 컬럼 판정 (AS-IS spdMain_Changed L1295~1302 파리티). binding 을 받아 true 면 채운다. 미지정이면 아무 동작 없음(기본). 화면이 직접 cellEditEnded 에 붙이지 말 것 — 이 처리는 **E`
- `negativeCellAsZero?: (binding: string) => boolean — 편집 종료 시 음수가 들어온 셀을 '0' 으로 보정할 컬럼 판정 (AS-IS Dsdm_Changed L1186~1193 파리티). binding 을 받아 true 면 보정한다. 미지정이면 아무 동작 없음(기본). emptyCellAsZero 와 같은 이유로 화면에서 직접 cellEdit`
- `numberRules?: Record<string, NumberInputRule> — 정적 컬럼(admin 메타)의 숫자 입력 제한. 키는 컬럼 binding(colNm). 메타에 없는 화면 선언이라 admin 이 관리하는 속성을 덮어쓰지 않는다. 동적 컬럼은 FlexGridColumnConfig 의 positiveOnly/integerOnly/decimalPlaces `
- `comboParams?: Record<string, string> — 자동 콤보(cellCtrlObjTpCd=COMBO)의 SQL 바인드 파라미터(@mnuId /`
- `sheetName?: string — 그리드 시트명(admin SHEET_NAME). 지정 시 이 그리드의 셀 콤보 요청(자동 콤보 + 행파라미터 콤보)에 sheetName 이 함께 실려 콤보 SQL 의`
- `headerRowHeight?: number — 다단(2단/3단) 헤더 행 높이(px). 미지정(default)이면 Wijmo 기본 동작 — 기존 화면 무영향(회귀 0). 지정 시 columnHeaders 의 모든 헤더 row 를 이 높이로 강제(예: 3단 헤더 총높이 48px → 16 전달). 화면 useEffect/CSS 로는 w`
- `excludeFromDirtyCheck?: boolean — 미저장 변경(dirty) 집계에서 이 그리드를 제외한다. 조회 전용인데도 코드가 CRUD_TYPE 를 임의로 세팅하는 등 오탐이 나는 그리드에만 사용. (편집 불가 그리드는 CRUD_TYPE 이 생기지 않아 원칙적으로 지정할 필요가 없다.)`
- `useContextMenu?: boolean — 공통 컨텍스트(우클릭) 메뉴 사용 여부 (기본 true)`
- `layoutKey?: GridLayoutKey — 그리드 레이아웃 개인화(컬럼 표시/순서/폭) 활성화 키 — GSCM TitleSet 승계(opt-in). 지정 시: 진입할 때 저장된 레이아웃 자동 적용 + 컨텍스트 메뉴에 Save/Load/Reset Layout 항목. ⚠️ sheetName 은 admin SHEET_NAME(컬럼 메`
- `contextMenuItems?: GridContextMenuItem[]`
- `((context: GridContextMenuContext) => GridContextMenuIte — 컨텍스트 메뉴 하단에 붙는 화면 전용 항목. 배열이면 항상 노출, 함수면 우클릭 지점 context 로 셀 조건부(예: 특정 measure 행에서만) 반환.`
- `excelFileName?: string — 컨텍스트 메뉴 Export 파일명 (SubTitle 의 excelFileName 과 동일 용도, 기본 'Excel File')`
- `initialized?: (grid: TFlexGrid) => void`
- `dblClick?: (mouseEvent: MouseEvent) => void`
- `click?: (mouseEvent: MouseEvent) => void`
- `gotFocus?: (sender: Control, args: EventArgs) => void`

### SearchArea  <sub>packages/shared/src/components/organisms/search-area/SearchArea.tsx:62</sub>

```ts
({ searchButtonLabel, isHidden, sx, myOptions, onSearch, onResetCondition, onSaveOption, onSelectedMyOption, conditions, extraConditions, isCustomExtraCondition, extraButtons, aboveSearch, }: any): any
```

### CustomDropdown  <sub>packages/shared/src/components/molecules/customDropdown/CustomDropdown.tsx:251</sub>

```ts
({ options: rawOptions, value, onChange, limitTags, allOption, sortBy, className, ...props }: SingleProps<DropdownOption> | MultipleProps<DropdownOption>): any
```

props/params:

- `multiple?: boolean`
- `allOption?: boolean`
- `sortBy?: "label"`
- `value?: string`
- `onChange?: ((event: React.SyntheticEvent, value: string) => void)`
- `((event: React.Syntheti`

### CustomDialog  <sub>packages/shared/src/components/molecules/dialog/CustomDialog.tsx:352</sub>

```ts
({ open, type, position, size, isOutBound, anchorEl, title, subTitle, contentArea, customHeaderTitle, customHeaderSubTitle, customContentArea, disableButtonCancel, handleClose, handleSubmit, draggable, height, disableMaximize, disableScale, minWidth, minHeight, disableEnforceFocus, }: any): any
```

### ResultArea  <sub>packages/shared/src/components/organisms/result-area/ResultArea.tsx:175</sub>

```ts
({ children, title, depth, count, gridRef, gridFilterRef, rightButtons, flex, gap, onClickCapture, className, style, }: ResultAreaProps): any
```

props/params:

- `children: ReactNode — 그리드 본문(DataGrid 등). 남은 공간을 모두 채운다.`
- `title?: string — 영역 제목. 주면 상단에 TitleArea(isSubTitle) 헤더를 렌더하고, 생략하면 그리드만 채운다.`
- `depth?: SubTitleDepthType — 제목 depth. 기본 'h4'.`
- `count?: number — 제목 우측 건수. 0/undefined 면 미표시. gridRef 를 주면 필터 적용 시 이 값 대신 실제 표시 건수를 보여준다.`
- `gridRef?: RefObject<any> — 필터 반영 건수 계산 대상 그리드(선택). 주면 F4/헤더 필터로 좁혀진 실제 표시 건수를 count 대신 보여준다. gridFilterRef 와 함께 줘야 필터 적용/해제 이벤트를 구독한다.`
- `gridFilterRef?: RefObject<any> — gridRef 그리드에 붙은 FlexGridFilter. gridRef 와 함께 준다.`
- `rightButtons?: ReactNode — 제목 우측 버튼 영역(이 영역 전용 추가/삭제 등).`
- `flex?: any — 이 영역이 차지할 비율. 생략하면 남은 공간 전부(`1 1 0`). - 숫자 = grow 비율. **형제들의 합이 10** 이 되게 준다 — 6:4, 7:3, 5:5, 3단이면 4:3:3. (5:3 처럼 합이 10 이 아니면 실제로는 62.5%/37.5% 라 코드만 보고 오해하게 된다.`
- `gap?: number — 헤더와 그리드 사이 간격(px). 기본 4.`
- `onClickCapture?: MouseEventHandler<HTMLDivElement> — 이 영역 안을 클릭했을 때(capture 단계라 그리드 내부 클릭도 잡힌다). 그리드가 여럿인 화면에서 SubTitle 의 Excel/Sort/Filter 대상 그리드를 추적하는 용도.`
- `className?: string`
- `style?: CSSProperties`

### TabItem  <sub>packages/shared/src/components/molecules/tab/Tab.tsx:97</sub>

```ts
({ children }: TabItemProps): any
```

props/params:

- `label: string`
- `closable?: boolean`
- `children?: ReactNode`

### TabWrapper  <sub>packages/shared/src/components/molecules/tab/Tab.tsx:25</sub>

```ts
({ children, onTabClick, onClose, clearAll, clearOthers, persist, activeTabIndex, setActiveTabIndex, }: TabWrapperProps): any
```

props/params:

- `onTabClick?: (index: number) => void`
- `onClose?: (index: number) => void`
- `clearAll?: () => void`
- `clearOthers?: () => void`
- `persist?: boolean`
- `children: any`
- `activeTabIndex?: number`
- `setActiveTabIndex?: (index: number) => void`

### ColumnLayoutModal  <sub>packages/shared/src/components/templates/modals/column-layout-modal/ColumnLayoutModal.tsx:94</sub>

```ts
({ open, modalClose, menuId, sheetName, columnType, divisionId, fallbackColumns, initialSettings, defaultSettings, onSave, title, leftTitle, rightTitle, }: Props): any
```

props/params:

- `open: boolean`
- `modalClose: () => void`
- `menuId: string`
- `sheetName: string`
- `columnType?: string`
- `divisionId?: string`
- `fallbackColumns?: ColumnSettingFallback[]`
- `initialSettings?: ColumnLayoutRow[] — 재진입 시 이전 저장 상태 복원 (visible+width+color+order)`
- `defaultSettings?: ColumnLayoutRow[]`
- `onSave: (settings: ColumnLayoutRow[]) => void — OK 시 전체 컬럼 반환 — 우측(USER_FLAG='Y')이 표시 순서대로 앞에 온다.`
- `title?: string`
- `leftTitle?: string — dual list 좌측 상단 라벨 (예: 'Invisible')`
- `rightTitle?: string — dual list 우측 상단 라벨 (예: 'Visible')`

### PeriodRangePicker  <sub>packages/shared/src/components/molecules/periodRangePicker/PeriodRangePicker.tsx:252</sub>

```ts
({ start, end, onChange, label, required, className, quickWeeksFromToday, allowTextInput, monthOnly, }: PeriodRangePickerProps): any
```

props/params:

- `start: string`
- `end: string`
- `onChange: (start: string, end: string) => void`
- `label?: string`
- `required?: boolean`
- `className?: string`
- `quickWeeks?: number[]`
- `lastWeeks?: number`
- `quickWeeksFromToday?: boolean`
- `allowTextInput?: boolean`
- `monthOnly?: boolean`

### SsoUserModal  <sub>packages/shared/src/components/templates/modals/sso-user-modal/SsoUserModal.tsx:47</sub>

```ts
({ size, open, modalClose, setSelectedValue, initialUser, ssoUserYn, multiCheckbox, setSelectedValues, }: SsoUserModalProps): any
```

props/params:

- `size?: DialogNavigationSize`
- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (userId: string, userNm: string, userEngNm: string, deptNm?: string, deptId?: st`
- `initialUser?: string`
- `ssoUserYn?: "Y"`
- `"N"`
- `multiCheckbox?: boolean — 멀티 선택 모드(옵션, 기본 false). true 면 체크박스 컬럼으로 여러 사용자를 고르고 OK 시 setSelectedValues 로 체크된 행 전부를 넘긴다. 더블클릭은 그 행 하나만 넘긴다(ItemByDivisionModal multiCheckbox 와 같은 규약). 미지정 호`
- `setSelectedValues?: (users: ResponseData<"COM0010", SHEETS>[]) => void`

### ColumnSelectDualList  <sub>packages/shared/src/components/molecules/columnSelectDualList/ColumnSelectDualList.tsx:59</sub>

```ts
<T extends Record<string, string | number>>({ leftItems, rightItems, leftColumns, rightColumns, itemKey, checkedLeft, checkedRight, onToggleLeft, onToggleRight, onToggleAllLeft, onToggleAllRight, onMoveRight, onMoveLeft, onReorderRight, onRowDoubleClickLeft, onRowDoubleClickRight, leftTitle, rightTitle, }: Props<T>): any
```

props/params:

- `leftItems: T[]`
- `rightItems: T[]`
- `leftColumns: DualListColumn<T>[]`
- `rightColumns: DualListColumn<T>[]`
- `itemKey: keyof T — 행 고유 식별 컬럼 (예: 'COLUMN_NAME')`
- `checkedLeft: Set<string> — 체크된 좌/우 키 집합 (다중선택)`
- `checkedRight: Set<string>`
- `onToggleLeft: (key: string) => void`
- `onToggleRight: (key: string) => void`
- `onToggleAllLeft: (checked: boolean) => void`
- `onToggleAllRight: (checked: boolean) => void`
- `onMoveRight: () => void`
- `onMoveLeft: () => void`
- `onReorderRight?: (orderedKeys: string[]) => void — 우측 grid 행 D&D 순서 이동 — 재정렬된 key 배열(위→아래) 전달`
- `onRowDoubleClickLeft?: (key: string) => void — 좌측 행 더블클릭 — 해당 행 1개를 우측으로 이동 (▶ 와 동일 동작)`
- `onRowDoubleClickRight?: (key: string) => void — 우측 행 더블클릭 — 해당 행 1개를 좌측으로 이동 (◀ 와 동일 동작)`
- `leftTitle?: string — 좌측 grid 상단 라벨 (예: 'Invisible') — 미지정 시 라벨 없음(기존 사용처 무영향)`
- `rightTitle?: string — 우측 grid 상단 라벨 (예: 'Visible')`

### MessageModal  <sub>packages/shared/src/components/templates/modals/message-modal/MessageModal.tsx:28</sub>

```ts
({ size, open, modalClose, setSelectedValue, initialType, initialMessage, messageTypeFilters, }: MessageModalProps): any
```

props/params:

- `size?: DialogNavigationSize`
- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (messageId: string, message: string) => void`
- `initialType?: string`
- `initialMessage?: string`
- `messageTypeFilters?: string[]`

### Alert  <sub>packages/shared/src/components/organisms/alert/Alert.tsx:4</sub>

```ts
(): any
```

### CascadeDropdown  <sub>packages/shared/src/components/molecules/cascadeDropdown/CascadeDropdown.tsx:60</sub>

```ts
({ tree, levels, value: valueProp, onChange, placeholder, gridSize, columnSpacing, rowSpacing, variant, labelAlign, formItemClassName, }: CascadeDropdownProps): any
```

props/params:

- `tree: CascadeNode[]`
- `levels: CascadeLevel[]`
- `value?: Record<string, string>`
- `onChange?: (value: Record<string, string>) => void`
- `placeholder?: string`
- `gridSize?: number`
- `columnSpacing?: string`
- `rowSpacing?: string`
- `variant?: "horizontal"`
- `"vertical"`
- `labelAlign?: "left"`
- `"right"`
- `formItemClassName?: string`

### SsoDeptModal  <sub>packages/shared/src/components/templates/modals/sso-dept-modal/SsoDeptModal.tsx:24</sub>

```ts
({ size, open, modalClose, setSelectedValue, initialDept, }: SsoDeptModalProps): any
```

props/params:

- `size?: DialogNavigationSize`
- `open: boolean`
- `modalClose: () => void`
- `setSelectedValue: (deptId: string, deptNm: string) => void`
- `initialDept?: string`

### ColorPickerButton  <sub>packages/shared/src/components/molecules/colorPickerButton/ColorPickerButton.tsx:22</sub>

```ts
({ value, onChange, title, autoColor, }: ColorPickerButtonProps): any
```

props/params:

- `value: string — 현재 색 hex 또는 '' (자동/기본색)`
- `onChange: (hex: string) => void`
- `title?: string`
- `autoColor?: string`

### ColumnButton  <sub>packages/shared/src/components/organisms/column-button/ColumnButton.tsx:35</sub>

```ts
(): any
```

### ColumnGrids  <sub>packages/shared/src/components/organisms/column-button/components/ColumnGrids.tsx:19</sub>

```ts
({ candidateItems, selectedItems, candidateGridColumnGroups, selectedGridColumnGroups, initGrid, handleMove, }: ColumnGridsProps): any
```

props/params:

- `candidateItems: FlexGridColumnConfig[]`
- `selectedItems: FlexGridColumnConfig[]`
- `candidateGridColumnGroups: FlexGridColumnConfig[]`
- `selectedGridColumnGroups: FlexGridColumnConfig[]`
- `initGrid: (grid: TFlexGrid, type: MoveType) => void`
- `handleMove: (type: MoveType) => void`

### ColumnLayoutList  <sub>packages/shared/src/components/molecules/columnLayoutList/ColumnLayoutList.tsx:31</sub>

```ts
({ rows, onToggleDisplay, onChangeWidth, onChangeCellColor, onChangeTextColor, onReorder, }: Props): any
```

props/params:

- `rows: ColumnLayoutRow[] — SORT_ORDER_NO 오름차순 정렬된 전체 컬럼`
- `onToggleDisplay: (key: string) => void`
- `onChangeWidth: (key: string, rawValue: string) => void`
- `onChangeCellColor: (key: string, hex: string) => void`
- `onChangeTextColor: (key: string, hex: string) => void`
- `onReorder: (orderedKeys: string[]) => void`

### ControlButtonGroup  <sub>packages/shared/src/components/organisms/column-button/components/ControlButtonGroup.tsx:10</sub>

```ts
({ handleDefault, handleOk, handleCancel, }: ControlButtonGroupProps): any
```

props/params:

- `handleDefault: () => void`
- `handleOk: () => Promise<void>`
- `handleCancel: () => void`

### CustomDropdownMui  <sub>packages/shared/src/components/molecules/customDropdown/CustomDropdownMui.tsx:25</sub>

```ts
({ ...props }: SingleProps<Lookup> | MultipleProps<Lookup>): any
```

props/params:

- `multiple?: boolean`
- `onChange?: ((event: React.SyntheticEvent, value: Lookup) => void)`
- `((event: React.Syntheti`

### CustomListboxRow  <sub>packages/shared/src/components/molecules/customDropdown/components/CustomListboxRow.tsx:17</sub>

```ts
({ index, rowData, multiple, style, }: any): any
```

### ToastMessage  <sub>packages/shared/src/components/organisms/toast-message/ToastMessage.tsx:9</sub>

```ts
(): any
```

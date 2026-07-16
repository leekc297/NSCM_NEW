# Hook — Cascade Combo Filter (Form + Grid combo lookup 5단계 표준)

> ⭐ **신규 화면 조회조건 Form 또는 Grid 가 Division/Team/Customer 등 종속 combo 사용 시 의무 적용.**
> 이전 column 값이 다음 column 의 combo SQL filter 로 전달되는 표준 패턴 (DMF0004/0005/0006/0007 reference 추출).
> 위반 시 **PR 차단** (사용자 명시 2026-06-18).

작성: 2026-06-18 (사용자 명시 — DMF0004/0005/0006/0007 4 reference 화면의 cascade 패턴 정형화)
상위 룰: `anti-simplification.md`
관련 hook: `cascade-pattern-check.md`, `modal-callback-cascade-check.md`, `column-lookup-meta-standard.md`, `ui-category-setup-column-meta.md`
Reference 화면: **DMF0004 / DMF0005 / DMF0006 / DMF0007**

---

## §0. 배경 (사용자 명시 — 2026-06-18)

> "cell object 가 combo 일 경우에 이전 column 의 값을 filter 로 적용해야 하는 경우를 이전에 개발된 dmf0004、 dmf0005、 dmf0006、 dmf0007 에서 찾아서 rule을 적용해주세요."

4 reference 화면 모두 **"Division-centric" Form cascade** + **"Modal-driven" Grid cascade** 패턴으로 통일. backend `SCM_ADM_CMBO_SQL_M` 의 SQL_ID 변수 치환 (`@divisionId` 등) + FE client-side filter 조합.

---

## §1. Form §1 — Cascade reset (Division 변경 시 하위 dropdown `'ALL'` reset)

### 1.1 표준 패턴

```typescript
// DMF0004 SalesSiteForm.tsx:54-60 / DMF0005 SalesSiteProjectModelForm.tsx:75-81 / DMF0007 CustomerFcstMasterForm.tsx:49-56
<CustomDropdown
  value={searchParams.divisionId}
  options={divisionOptions}
  onChange={(_, option) => {
    setSearchParams({
      divisionId: option,
      endCustomer: 'ALL',     // ⭐ 하위 reset
      soldToCustomer: 'ALL',  // ⭐ 하위 reset
      salesSite: 'ALL',       // ⭐ 하위 reset
    });
  }}
/>
```

### 1.2 의무
- Division 변경 시 의존하는 모든 combo (`team`, `endCustomer`, `salesSite`, `soldToCustomer`, `project`, `item`, `owner` 등) 의 state 를 **단일 `setSearchParams` 호출** 안에서 `'ALL'` reset
- 개별 `setState` 분리 금지 (race condition 회피)
- 다단 reset 필요 시 `useEffect([divisionId])` 가 아닌 `onChange` 핸들러 직접 — anti-simplification 정신

### 1.3 위반 사고
- division 변경 후 하위 dropdown 의 이전 값이 남아서 그 값으로 메인 grid 조회 → 결과 mismatch
- 사용자 경험: "분명히 division 바꿨는데 grid 결과가 이상" → root cause

### 1.4 ⭐ Division 변경 시 **Grid 데이터 초기화(비움) 의무** (사용자 명시 2026-07-14)

> "UI 개발/보완 시 조회조건 중 division 을 변경하면 Grid 초기화 되도록 해주세요."

- Division onChange 핸들러에서 하위 combo 'ALL' reset(§1.2)과 **함께** 화면의 **모든 grid 데이터를 초기화(빈 상태)** 한다 — 이전 division 조회 결과가 화면에 남아 새 조건과 mismatch 로 보이는 것 자체를 차단.
- 동반 초기화: **CRUD pending(EditTracker 미저장 변경분) reset** (hook #97 부모키 변경 시 CRUD reset 과 동일 메커니즘) + 조회 상태 플래그(조회됨 표시/카운트) 초기화.
- 구현 위치: Form 의 division onChange → store 액션 1곳 (예: `setSearchParams({divisionId, …하위 'ALL'})` + `clearSheetData()` / query 결과는 refetch 트리거가 아니라 **비움** — 재조회는 사용자의 Search 버튼).
- 적용 범위: **신규(T01) 의무 + 보완/수정(T01M) 시 미적용 화면 정정** (일괄 audit 아님 — 수정 시 적용, hook #91 방식).
- 선례: hook #89 **P**(DMF0020 — Div 변경 시 검색조건 초기화+그리드 비움+disabled) 의 일반화 — 이제 특정 화면이 아닌 **전 화면 공통 의무**.

---

## §2. Form §2 — Multi-level filter composition (`&&` 조합 N 단)

### 2.1 표준 패턴

```typescript
// DMF0005 SalesSiteProjectModelForm.tsx:131-140 / DMF0006 CustomerModelMappingForm.tsx:99-107
options={
  [
    ...new Map(
      endCustomers
        ?.filter(item =>
          item.DIVISION_ID === searchParams.divisionId &&   // ⭐ 1 단
          (searchParams.deptId === 'ALL' || searchParams.deptId.includes(item.DEPT_ID))  // ⭐ 2 단
        )
        .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
    ).values(),
  ].map(item => ({ label: item.NAME, value: item.CODE }))
}
```

### 2.2 의무
- `&&` 조합으로 N 단 cascade 구현 — 최대 4 단까지 검증된 패턴
- 'ALL' sentinel 처리 의무: `searchParams.deptId === 'ALL' || searchParams.deptId.includes(item.DEPT_ID)`
- 빈 array 결과 시 사용자에게 "조건 일치 없음" 안내 또는 default 옵션 제공

---

## §3. Form §3 — Map dedup (`new Map([key, item]).values()`)

### 3.1 표준 패턴

```typescript
// 4 화면 공통 — Map + duplicate key 기반 deduplication
[
  ...new Map(
    items
      .filter(...)
      .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])  // ⭐ key = 복합 unique
  ).values(),
].map(item => ({ label: item.NAME, value: item.CODE }))
```

### 3.2 의무
- 복합 unique key 형식 = `` `${컬럼1}|${컬럼2}` `` (예: `${DIVISION_ID}|${CODE}`)
- `Array.from(new Set(...))` 대신 **Map 기반** 사용 — 객체 전체 유지 + 마지막 occurrence 우선
- 중복 array 직접 .map → option 직접 금지 (중복 option 사고)

### 3.3 위반 사고
- 같은 EndCustomer 가 2 row (Division=A, Division=B) → division 무관 dedup 시 1 row 만 남음 → division=A 컨텍스트 정보 손실
- → 복합 key `${DIVISION_ID}|${CODE}` 사용 의무

---

## §4. Form §4 — `useTabComboQueries` 1 round-trip + client-side filter

### 4.1 표준 패턴

```typescript
// 4 화면 공통 — 1 round-trip 으로 모든 lookup 미리 load + 메모리 filter
const [divisions, teams, endCustomers, salesSites, yesOrNo] = useTabComboQueries({
  filters: ['MyDivision', 'TeambyDivision', 'EndCustomer', 'SalesSite', 'YesOrNo'],
});
```

### 4.2 의무
- 모든 combo 옵션 1 round-trip 으로 미리 fetch — backend 호출 회수 최소
- client-side `.filter()` 로 cascade 처리 — backend 호출 회피
- `useTabComboQueries` 사용 (`useTabComboQuery` 단일 호출 금지 — N 회 round-trip 비효율)
- BE 가 변수 치환 (`@divisionId` 등) 호출 필요 시 `SCM_ADM_CMBO_SQL_M` 의 SQL_ID 사용 — `column-lookup-meta-standard.md` cross-ref

---

## §5. Grid §5 — Modal callback cascade (cell dblClick → modal → row refresh)

### 5.1 표준 패턴

```typescript
// DMF0004 SalesSiteGrid.tsx:82-86 / DMF0005 SalesSiteProjectModelGrid.tsx:46-65
const handleAutoSalesSite = (s: FlexGrid<...>, e: CellRangeEventArgs) => {
  const dataItem = s.rows[e.row].dataItem as ResponseData<...>;
  editTrackerRef.current?.storeChange(dataItem, 'SOLDTO_CUSTOMER', oldValue, newValue);
  applySalesSite(dataItem, editTrackerRef.current);  // ⭐ 같은 row 의 다른 cell 자동 갱신
};

<DataGrid
  ...
  cellEditEnded={handleAutoSalesSite}
  dblClick={handleGridDblClick}  // modal 호출
/>
```

### 5.2 의무
- Cell 변경 → `editTracker.storeChange()` 호출 → 같은 row 의 dependent cell 자동 update
- Modal 선택 콜백 → `setCellData()` 직접 호출 또는 `editTracker` 사용
- Cell dblClick → modal open → 선택값 → 같은 row refresh (`g.collectionView.refresh()` 또는 `g.invalidate()`)
- Cell combo 의 lookup SQL 은 `CELL_COMBO_DATA_TYPE` (FE `cellCboDataTp`) 위치 등록 — `ATTRIBUTE1` 위치 절대 금지

### 5.3 Reference
- DMF0004 `SalesSiteGrid.tsx:82-86` (SOLDTO 변경 → SalesSite cell 자동 갱신)
- DMF0005 `SalesSiteProjectModelGrid.tsx:46-65` (TEAM/OWNER modal callback)
- DMF0006 `CustomerModelMappingGrid.tsx:38-90` (PROJECT/ITEM modal)

---

## §5-G. Grid combo/modal 셀 cascade — 행 컨텍스트 필터 (2026-07-03 DMF0020 확립, 사용자 명시)

> **"그리드 셀 combo 가 같은 행의 상위 셀 값으로 필터되어야 하는 경우"의 표준.**
> AS-IS 원천: `spdMain_ComboSelChange` 가 같은 행의 상위 셀 값을 `Data.Common(Type, false, param1=division, ...)`
> 으로 SP(UP_FX PARAM1~5)에 넘겨 재조회 후 `SetCellTypeCombo` 로 행 단위 combo 를 덮어쓰는 구조.
> ⚠️ **AS-IS 실측 확정 (2026-07-03)**: cascade 필터는 **메타(UI Category Setup)가 아니라 화면 코드가 결정**한다 —
> `SCM_MST_SHEET_COLUMNS` 에 PARAM 저장 컬럼은 없고(ATTRIBUTE1~10 실질 미사용), 프레임워크의 메타 기반
> combo 자동 부여(`SpreadInfo.cs L1444~1483`)는 `Data.Common(eDataType)` **파라미터 0개(전체 목록)** 다.
> → TO-BE 등가 = **화면 constants 의 cascade 정의**(`GRID_CASCADE_FILTERS`/`GRID_CASCADE_CLEAR`). 메타 주도 확장(ATTRIBUTE 슬롯)은 사용자 결정 사항 — 임의 도입 금지.

### 5-G.1 표준 5 의무 요소 (reference: DMF0020 `SalesFuturePriceGrid.tsx` + `CustDemandAnalysisModal.tsx`)

| # | 의무 | 구현 |
|---:|---|---|
| 1 | **beginningEdit dataMap 스왑** — FPComboBox 편집 진입 시 해당 행의 상위 셀 값으로 콤보 전체 결과(1RT fetch)를 `.filter()` 해 `col.dataMap` 교체. Wijmo dataMap 은 컬럼 전역이라 행별 콤보는 이 방법이 유일 (룰 07 §2.10.5) | `GRID_CASCADE_FILTERS[binding]` = `{rowKey, comboKey}[]` |
| 2 | ⭐ **cellEditEnded 진입 시 전체 dataMap 원복 필수** — 스왑이 남으면 필터 밖 CODE 를 가진 **다른 행의 CODE→NAME 표시가 깨짐** (편집 취소 포함 커버) | `dataMapsRef.current[binding]` 원복 — 핸들러 **맨 앞** |
| 3 | **계단식 clear** — 상위 combo 값이 **실제로 변경된 경우만**(beginningEdit oldVal 캡처 비교) 하위 셀 + 팝업 파생 필드를 형제 행(INSERT_GROUP) 포함 일괄 `''` | `GRID_CASCADE_CLEAR[binding]` = 하위 컬럼 목록 (AS-IS clear 체인 1:1) |
| 4 | **관대 통과 sentinel** — 행 상위 값이 비거나 'ALL' 이거나 **콤보 row 의 필터 키가 없으면 통과** (사내 미이관 필터 키는 데이터 적재 시 자동 활성 — 엄격 필터로 빈 콤보 사고 금지) | `!rv \|\| rv==='ALL' \|\| !cv \|\| rv===cv` |
| 5 | **modal 셀 cascade** — 팝업 preSearchParams 는 조회조건이 아니라 **클릭한 행의 상위 셀 값** (AS-IS `Form_Load(false, div, team, endCust, site, project[, item])` 1:1) | `popupRow` state — dblClick 시 행 보관 |

### 5-G.2 콤보 선택·변경 기준 (2026-07-03 사고 회피 — 사용처 역매핑 의무)

1. cascade 필터 키(DIVISION_ID 등)를 **이미 반환하는 등록 콤보를 우선 재사용** (예: TeambyDivision2→TeambyDivision 교체 — DIVISION_ID 반환+권한 필터)
2. ❌ **공유 콤보 SQL 에 필터 키 컬럼 추가 금지** — DISTINCT 조합이 늘어 **타 화면 콤보에 중복 CODE 표시** (TeambyDivision2 7화면 / EndCustomerByDivisionDept 29화면 / BizTypeByDivision 10화면 공유 실측). 변경 전 `SHEET_COLUMNS.CELL_COMBO_DATA_TYPE` 사용처 역매핑 의무
3. 콤보 교체는 SHEET_COLUMNS 해당 화면 시트 행만 UPDATE (+FE fallback 상수 동기) — 타 화면 무변경
4. AS-IS 그리드에서 combo 가 아닌 컬럼(팝업이 채우는 잠금 값 등)은 cascade **비대상** — `__asis-mapping__` 에 근거 기재

### 5-G.3 카운트 대사 의무
`__asis-mapping__.md` 에 "AS-IS 트리거(ComboSelChange 분기 + CellDoubleClick 팝업) N = TO-BE 배선 N" 표 작성 (modal-callback-cascade-check §3 동등). reference: `sales-future-price/__asis-mapping__.md` §Grid Cascade Filter.

---

## §6. PRE-WRITE 자기 점검 (모두 ✓ 필수)

```
[ ] 1. Form 에 Division 변경 onChange 핸들러 단일 setSearchParams 안에서 하위 'ALL' reset?
[ ] 1-1. ⭐ Division 변경 시 grid 데이터 초기화(비움) + CRUD pending reset? (§1.4 — 2026-07-14 의무)
[ ] 2. Multi-level filter 의 'ALL' sentinel 처리 (===  'ALL' OR includes(CODE))?
[ ] 3. Dedup 시 Map 기반 + 복합 unique key (`${col1}|${col2}`)?
[ ] 4. useTabComboQueries 1 round-trip + client-side filter (useTabComboQuery N 회 X)?
[ ] 5. Grid cell combo 의 lookup 메타가 CELL_COMBO_DATA_TYPE (ATTRIBUTE1 X)?
[ ] 6. (Grid 셀 종속 combo) §5-G 5요소 — beginningEdit 스왑 / cellEditEnded 원복 / 계단식 clear(변경시만)
       / 관대 sentinel / modal preSearchParams=행값? 콤보 응답에 필터 키 컬럼 존재 실측?
[ ] 7. (콤보 변경 필요 시) 사용처 역매핑 후 공유 SQL 무변경 + 필터 키 반환 콤보 재사용?
```

---

## §7. POST-WRITE grep 자기 점검 (6 항목)

```bash
# 1) Division 변경 시 하위 reset 패턴 검출 (최소 1 row 기대)
grep -rnE "endCustomer: 'ALL'|deptId: 'ALL'|salesSite: 'ALL'" \
  features/*/src/pages/<screen>/components/*Form.tsx

# 2) Multi-level filter (DIVISION_ID && DEPT_ID 패턴)
grep -rnE "DIVISION_ID === sc\.divisionId|DIVISION_ID === searchParams\.divisionId" \
  features/*/src/pages/<screen>/components/*Form.tsx

# 3) Map dedup 패턴 — new Map([key, item])
grep -rnE "new Map\([^)]*map\(item =>" features/*/src/pages/<screen>/components/*Form.tsx

# 4) useTabComboQueries 1 round-trip
grep -rnE "useTabComboQueries\(\{" features/*/src/pages/<screen>/components/*Form.tsx

# 5) 안티패턴 — useTabComboQuery 단일 N 회 호출 (0 row 기대)
grep -rnE "useTabComboQuery\(\{" features/*/src/pages/<screen>/components/*Form.tsx

# 6) ATTRIBUTE1 위치에 SQL_ID 등록 안티패턴 (0 row 기대)
grep -rnE "ATTRIBUTE1.*=.*'[A-Z]" features/*/src/pages/<screen>/components/*Form.tsx
```

→ 1-4 = 1+ row, 5-6 = 0 row 기대.

---

## §8. 적용 강도 — **PR 차단 의무** (사용자 명시 2026-06-18)

| 위반 | 차단 시점 |
|---|---|
| §1 Form Cascade reset 누락 | `screen-completion-gate.md` 통합 — PR 머지 차단 |
| §2 Multi-level filter 의 'ALL' sentinel 누락 | PR 머지 차단 |
| §3 Map dedup 누락 (Set 직접 사용 등) | PR 머지 차단 |
| §4 useTabComboQuery 단일 N 회 호출 | PR 머지 차단 |
| §5 Grid Modal callback 누락 (cell 직접 setCellData 만) | warning (조건부 — 단순 1 step popup 시 허용) |

### Bypass 절차
- `feedback_*` 메모리에 사고 사례 추가 + 사용자 명시 승인 후 진행
- anti-simplification 룰 동등 강도

---

## §9. 사고 사례 + reference 코드 좌표

| 사고 | reference 정밀 위치 |
|---|---|
| Division 변경 후 하위 reset 누락 → grid 조회 mismatch | DMF0004 `SalesSiteForm.tsx:54-60` (정정 후) |
| Same EndCustomer 2 row (Division=A,B) dedup 시 1 row 손실 → division 컨텍스트 손실 | DMF0007 `CustomerFcstMasterForm.tsx:94-127` (Map 복합 key) |
| useTabComboQuery N 회 호출 → BE 응답 hang | DMF0006 `CustomerModelMappingForm.tsx:26-28` (useTabComboQueries 사용 권장) |
| Cell combo SQL_ID 가 ATTRIBUTE1 에 등록 → DataGrid wrapper 인식 X → dropdown empty | `column-lookup-meta-standard.md` §1-3 |

### Reference 코드 정밀 좌표 (PRE-WRITE 의무 참조)

| 패턴 | 위치 |
|---|---|
| §1 Form reset | `features/master/src/pages/sales-site/components/SalesSiteForm.tsx:54-60` |
| §2 Multi-level filter | `features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelForm.tsx:131-140` |
| §3 Map dedup | `features/master/src/pages/customer-forecast-master/componenets/CustomerFcstMasterForm.tsx:94-127` |
| §4 useTabComboQueries | 4 화면 공통 — Form L25-30 부근 |
| §5 Grid Modal cascade | `features/master/src/pages/sales-site/components/SalesSiteGrid.tsx:82-86` |
| §5-G Grid 셀 cascade (스왑/원복/clear) | `features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx` (beginningEdit 스왑 + cellEditEnded 원복·clear) + `sales-future-price.constants.ts` (GRID_CASCADE_FILTERS/CLEAR) |
| §5-G modal preSearchParams=행값 | `features/master/src/pages/sales-future-price/SalesFuturePrice.tsx` (popupRow) |
| §5-G 상수 기반 3단 cascade (팝업 내 grid) | `features/demand/src/pages/mkt-fcst/components/modals/CustDemandAnalysisModal.tsx` (CUST_DEMAND_CASCADE) |

---

## §10. Cross-ref

### Hook
- `cascade-pattern-check.md` — 조회조건/grid cascade 일반 (룰 07 §2.10)
- `modal-callback-cascade-check.md` — modal callback 전파 (DMF0004 §2.10.6)
- `column-lookup-meta-standard.md` — CELL_COMBO_DATA_TYPE 표준 위치 (`ATTRIBUTE1` 금지)
- `ui-category-setup-column-meta.md` — admin SCM_MST_SHEET_COLUMNS 동적 fetch
- `oracle-cmbo-varname-quote.md` — backend `@divisionId` 변수 치환 + ORA-01722 회피

### 메모리
- `feedback_drilldown_grid_flow_asis_mapping.md` — 다단 grid drilldown
- `feedback_combo_migration_asis_to_tobe.md` — AS-IS combo → TO-BE lookup
- `reference_combo_sql_id_inventory.md` — combo SQL_ID 인벤토리 (52 개 등록)
- `feedback_cascade_combo_filter_hook.md` (본 hook 메모리 entry)

### 사용자 명시
- 2026-06-18 — DMF0004/0005/0006/0007 4 화면 cascade 패턴 정형화 + DMF0020/0003 적용 의무 (룰화 요청)

### 적용 화면 인벤토리 (자가 진화 #18 동반)

| 화면 | §1 reset | §2 multi | §3 dedup | §4 1RT | §5 modal | 비고 |
|---|---|---|---|---|---|---|
| DMF0004 | ✅ L54-60 | ✅ L84-88 | ✅ Map | ✅ | ✅ L82-86 | reference |
| DMF0005 | ✅ L75-81 | ✅ L131-140 | ✅ Map | ✅ | ✅ L46-65 | reference |
| DMF0006 | ✅ L49-76 | ✅ L99-107 | ✅ Map | ✅ | ✅ L38-90 | reference |
| DMF0007 | ✅ L49-56 | ✅ L94-127 | ✅ Map | ✅ | (modal 없음) | reference |
| DMF0020 | ✅ Form L69-82 | ✅ GRID_CASCADE_FILTERS | ✅ Map 복합키 | ✅ 1RT+beginningEdit 스왑 | ✅ popupRow preSearchParams | 2026-07-03 grid cascade 적용 (`__asis-mapping__.md` §Grid Cascade) |
| DMF0003 | ⚠️ 미발견 → 보강 | △ comboFilters | ❌ Set 만 → 보강 | ✅ | ✅ L283-311 | 본 작업 §1/§3 보강 |

---

## §11. 위반 시 대응

- PRE-SUBMIT 시 §6 체크리스트 + §7 grep 모두 통과 의무
- 1건이라도 위반 = PR 머지 차단 (anti-simplification 동등 강도)
- 사고 사례 §9 재현 가능 → 즉시 fix
- bypass 필요 시 메모리 `feedback_*` 에 사고 사례 + 사용자 승인 의무

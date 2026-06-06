# Hook — modal callback cascade 자기 점검

> §2.10.6 modal callback cascade 패턴의 PR 머지 게이트.
> DMF0004 / DMF0005 / DMF0006 의 표준 패턴 cross-check.

작성: 2026-06-04 (Phase 7 보완 F4)

---

## §0 적용 시점

| 시점 | 행위 |
|---|---|
| **PRE-WRITE** (Grid + Modal 컴포넌트 작성 직전) | AS-IS 의 combo cell + `Data.Common` lookup 패턴 → TO-BE modal cell + setSelectedValue 콜백으로 전환 의도 확인 |
| **POST-WRITE** (Grid 작성 직후) | §2 grep 7종 — modal callback 의 5 의무 요소 검증 |
| **PRE-SUBMIT** (PR 직전) | §3 PR 머지 게이트 cross-check 표 |

---

## §1 modal callback cascade 5 의무 요소

> 룰 07 §2.10.6 표준 — 5 요소 모두 누락 시 사고 (storeChange 누락 / CRUD_TYPE guard 누락 / refresh 누락 등)

| # | 의무 요소 | 검증 grep |
|---:|---|---|
| 1 | `dblClick` handler — `hitTest` + `CRUD_TYPE === CRUD_TYPE.INSERT` guard + 특정 binding 분기 | `rg -nE "hitTest.*CRUD_TYPE\\.INSERT" {grid-tsx}` |
| 2 | `setOpenXxxModal(true)` + `setClickedRow(ht.row)` | `rg -nE "setOpen\w+Modal.*true|setClickedRow" {grid-tsx}` |
| 3 | `setSelectedValue` callback 안 `CRUD_TYPE` guard 의무 | `rg -nE "setSelectedValue.*=>|CRUD_TYPE\\.INSERT" {grid-tsx}` |
| 4 | `editTrackerRef.current?.storeChange()` 다중 호출 (cell 별 1 회) | `rg -nE "editTrackerRef\\.current\\?\\.storeChange" {grid-tsx}` |
| 5 | `dataItem.COL = val` 동기 + 마지막 `refreshRange(new CellRange(row, 0, row, -1))` | `rg -nE "refreshRange.*new CellRange.*-1" {grid-tsx}` |

→ 5 요소 모두 grep 결과 ≥ 1 (의무).

---

## §2 POST-WRITE grep 7종

```bash
# 1. dblClick handler
rg -nE "dblClick\s*=" {grid-tsx}

# 2. dblClick 안의 CRUD_TYPE guard
rg -nE "CRUD_TYPE\\.INSERT.*binding|binding.*CRUD_TYPE\\.INSERT" {grid-tsx}

# 3. modal state
rg -nE "useState.*<boolean>\\(false\\)|setOpen\\w+Modal" {grid-tsx}

# 4. setSelectedValue callback 의 CRUD_TYPE guard
rg -nE "setSelectedValue\\s*=" {grid-tsx} -A 5 | grep CRUD_TYPE

# 5. storeChange 다중 호출 (cell 수만큼)
rg -nE "editTrackerRef\\.current\\?\\.storeChange" {grid-tsx}

# 6. dataItem direct assign (storeChange 후 sync)
rg -nE "dataItem\\.\\w+\\s*=" {grid-tsx}

# 7. refreshRange 마지막 호출
rg -nE "refreshRange\\(new CellRange" {grid-tsx}
```

---

## §3 PR 머지 게이트 — cross-check 표

> `__asis-mapping__.md` 의 cascade 절에 다음 표 작성 의무:

| Modal | trigger binding | 일괄 cascade column 수 | CRUD_TYPE guard | storeChange 수 | refreshRange | auto-derive 후속 |
|---|---|---:|---|---:|---|---|
| (예: RegionModal) | COUNTRY_NAME / CITY_NAME | 4 | ✅ INSERT | 4 | ✅ row 전체 | ⭐ applySalesSite |
| (예: CustomerModal) | SOLDTO_CODE / SHIPTO_CODE | 6 | ✅ INSERT | 6 | ✅ row 전체 | (없음) |

→ "CRUD_TYPE guard" 컬럼 = ❌ 시 PR 머지 차단.

---

## §4 reference (DMF0004~6)

| 화면 | modal callback 수 | reference 파일 |
|---|---:|---|
| DMF0004 SalesSite | 3 (setRegion / setCustomers / setSloc) | `nscm-fe/features/master/src/pages/sales-site/components/{SalesSite/Customer/Location}Grid.tsx` |
| DMF0005 SalesSiteProjectModel | 7 (Form 3 + Grid 4: Team/Owner/Item/Project) | `nscm-fe/features/master/src/pages/sales-site-project-model/componenets/SalesSiteProjectModelGrid.tsx` |
| DMF0006 CustomerModelMapping | 2 (handleProjectSelected / handleItemSelected) | `nscm-fe/features/master/src/pages/customer-model-mapping/components/CustomerModelMappingGrid.tsx` |

→ 총 **12 modal callback reference** — 5 요소 의무 cross-check 통과.

---

## §5 cross-ref

- 룰 07 `_tobe/07_datagrid.md` §2.10.6 modal callback cascade
- 룰 07 §3.5 CRUD_TYPE 가드 (modal cell)
- 룰 23 `_dev_rules/23_FE_IMPORT_INVENTORY.md` (`@master/components` 공용 modal 11종)
- Hook `cascade-pattern-check.md` (상위 — 전체 cascade 7 sub-pattern)
- 메모리 `reference_public_modals_master_components.md` (공용 modal 인벤토리)
- 메모리 `feedback_grid_popup_cell_mandatory.md` (popup cell 표준)

---

## §6 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-04 | 신규 작성 — Phase 7 보완 F4. 5 의무 요소 + 12 reference cross-check |

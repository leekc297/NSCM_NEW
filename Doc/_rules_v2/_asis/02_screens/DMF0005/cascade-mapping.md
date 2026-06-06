# DMF0005 (SalesSiteProjectModelMapping) — cascade DataModel.Changed cross-check

> Phase 7 후속 cross-check (2026-06-04) — 룰 07 §2.10 의 reference 확장. **신규 sub-pattern #6 후보 발견 — 다중 row cascade propagate**.

---

## §0 결과 종합

| 항목 | 값 |
|---|---|
| AS-IS source | `GSCM.DM.Master.UIL/DMF0005_SaleSite_PjtModelMapping.cs` (~3500 lines) |
| TO-BE source | `nscm-fe/features/master/src/pages/sales-site-project-model/` (Form + Grid + PurchaseGrid) |
| AS-IS cascade handler 수 | **2 종** (shtMainDataModel + shtSubDataModel + 2 ComboSelChange) |
| AS-IS branch 수 | **4 branch** (Main 3 + Sub 1) |
| TO-BE 구현된 branch | **modal callback cascade 7 종** (Form: Project/Item/Owner / Grid: Team/Owner/Item/Project / PurchaseGrid: Owner) |
| **신규 sub-pattern 발견** | ⭐ **§2.10.x 다중 row cascade propagate** (VMI_LT 동일 row group propagate) |
| 격차 | 4 건 |

---

## §1 AS-IS handler #1 — `shtMainDataModel_Changed` (L3090~3231)

| Branch | Trigger column | 동작 | sub-pattern |
|---|---|---|---|
| (a) | LIABILITY_PERIOD | < 0 시 revert (clear) | (validation — §2.10.2 변형) |
| (b) | CELL_PER_CAR / CELL_PER_MODULE | 두 입력 시 MODULE_PER_CAR = CELL_PER_CAR / CELL_PER_MODULE 자동 계산 / 나누어 떨어지지 않으면 MSG00177 + 3 column clear | §2.10.1 auto-derive (계산) + §2.10.2 (조건부 차단) |
| (c) | VMI_LT | 동일 SCM_SITE_ID + ITEM_ID 의 **모든 row** 에 동일 vmi_lt cascade propagate (Division=40 분기) | ⭐ **§2.10.x 다중 row cascade propagate (신규 sub-pattern)** |

### §1.1 Branch (a) — LIABILITY_PERIOD validation (L3100~3109)

```csharp
if (e.Column == LIABILITY_PERIOD) {
    if (int.Parse(text) < 0) siMain.SetText(e.Row, e.Column, "");
}
```

→ TO-BE 미구현 (격차 #1).

### §1.2 Branch (b) — MODULE_PER_CAR 계산 (L3110~3163)

```csharp
if (e.Column == CELL_PER_CAR || e.Column == CELL_PER_MODULE) {
    if (text == "0") { revert; break; }
    if (CELL_PER_CAR != "" && CELL_PER_MODULE != "") {
        if (iCellPerCar % iCellPerModule > 0) {
            MessageHelper.GMessageBox("MSG00177");   // 정수 분할 X
            // 3 column clear
        } else {
            siMain.SetValue(MODULE_PER_CAR, iCellPerCar / iCellPerModule);
        }
    }
}
```

→ TO-BE 미구현 (격차 #2). **auto-derive 의 계산 변형** — §2.10.1 의 변형.

### §1.3 Branch (c) — VMI_LT 다중 row cascade propagate (L3164~3228)

> ⭐ **신규 sub-pattern 발견** — 한 row 의 VMI_LT 변경 시 동일 (SCM_SITE_ID + ITEM_ID) 의 **모든 row 에 cascade propagate**.

```csharp
if (e.Column == VMI_LT) {
    int vmi_lt = Convert.ToInt32(GetValue(e.Row, VMI_LT));
    // Division=40 분기: SCM_SITE_ID40 vs SCM_SITE_ID
    string scm_site_id = (division_id == "40") ? GetValue(e.Row, SCM_SITE_ID40) : GetValue(e.Row, SCM_SITE_ID);
    string item_id = GetValue(e.Row, ITEM_ID);
    
    // 위로 올라가면서 scm_site_id 가 동일한 첫 row 찾기
    int iStartRow = e.Row;
    for (int i = e.Row; i >= 0; i--) {
        new_site_id = (division_id == "40") ? GetValue(i, SCM_SITE_ID40) : GetValue(i, SCM_SITE_ID);
        if (scm_site_id == new_site_id) iStartRow = i;
    }
    
    // 내려가면서 동일 (site_id + item_id) 모든 row 에 vmi_lt propagate
    for (int i = iStartRow; i <= MaxRowIndex; i++) {
        new_site_id = (division_id == "40") ? ... ;
        new_item_id = GetValue(i, ITEM_ID);
        if (scm_site_id == new_site_id && item_id == new_item_id) {
            siMain.SetValue(i, VMI_LT, vmi_lt);   // 다중 row update
        } else if (scm_site_id != new_site_id) break;
    }
}
```

→ TO-BE 미구현 (격차 #3). **§2.10.5 combo cascade (전체 grid column.dataMap) 와는 다른 패턴** — 동일 key 의 다중 row 의 **특정 cell 만** 동기.

---

## §2 AS-IS handler #2 — `shtSubDataModel_Changed` (L3234~3253)

| Branch | Trigger | 동작 | sub-pattern |
|---|---|---|---|
| (a) | LIABILITY_PERIOD | < 0 시 revert | (validation — §2.10.2 변형) |

→ TO-BE 미구현 (격차 #4). Main Branch (a) 와 동일 패턴.

---

## §3 TO-BE 구현 인벤토리

| TO-BE 위치 | 방식 | sub-pattern | AS-IS 매핑 |
|---|---|---|---|
| `SalesSiteProjectModelForm.tsx:324` `handleProjectByDivisionModal` | modal callback (Form-level) | §2.10.6 modal callback | (Form 검색 조건 set) |
| `SalesSiteProjectModelForm.tsx:331` `handleItemByDivisionModal` | modal callback | §2.10.6 | (Form 검색 조건) |
| `SalesSiteProjectModelForm.tsx:338` `handleOwnerByDivisionModalSubmit` | modal callback | §2.10.6 | (Form 검색 조건) |
| `SalesSiteProjectModelGrid.tsx` `handleTeamSelected` (storeChange 다수) | modal callback (Grid-level) | §2.10.6 | (cascade 아님 — Team 선택 cell 채움) |
| `SalesSiteProjectModelGrid.tsx` `handleOwnerSelected` (L82~83) | modal callback | §2.10.6 | — |
| `SalesSiteProjectModelGrid.tsx` `handleItemSelected` (L103~109) | modal callback | §2.10.6 | — |
| `SalesSiteProjectModelGrid.tsx` `handleProjectSelected` (L125~137) | modal callback | §2.10.6 | — |
| `SalesSiteProjectModelPurchaseGrid.tsx` `handleOwnerSelected` (L46~47) | modal callback | §2.10.6 | — |

→ TO-BE 는 **7 modal callback** 패턴만 사용. **cellEditEnded cascade 0 위치** — AS-IS 의 3 branch (계산 / VMI_LT propagate / LIABILITY_PERIOD validation) 모두 미구현.

---

## §4 격차 4 건

| # | 격차 | sub-pattern | AS-IS 위치 |
|---:|---|---|---|
| 1 | Main LIABILITY_PERIOD < 0 revert | (validation) | L3100~3109 |
| 2 | Main CELL_PER_CAR / MODULE 정수 분할 검증 + MODULE_PER_CAR 자동 계산 + MSG00177 | §2.10.1 (계산 변형) + §2.10.2 | L3110~3163 |
| 3 | Main VMI_LT 다중 row cascade propagate (Division=40 분기) | ⭐ **§2.10.x 신규 sub-pattern** | L3164~3228 |
| 4 | Sub LIABILITY_PERIOD < 0 revert | (validation) | L3241~3252 |

→ 격차 4 건 모두 TO-BE 미구현. **§4 의 #3 (VMI_LT propagate) 은 신규 sub-pattern**.

---

## §5 ⭐ 신규 sub-pattern 발견 — 다중 row cascade propagate

### §5.1 패턴 정의

> 한 row 의 cell 변경이 동일 key 의 모든 다른 row 의 **특정 cell 만** cascade propagate. 전체 grid column.dataMap 변경 (§2.10.5) 과 다름.

### §5.2 TO-BE 권장 구현

```typescript
const handleVmiLtCascade = (grid: FlexGrid, e: CellRangeEventArgs) => {
  if (e.panel.cellType !== CellType.Cell) return;
  const binding = grid.columns[e.col]?.binding;
  if (binding !== 'VMI_LT') return;

  const dataItem = GridUtils.getRow(grid, e.row);
  const items = grid.itemsSource as ResponseData[];
  const divisionId = dataItem.DIVISION_ID;
  const siteIdKey = divisionId === '40' ? 'SCM_SITE_ID40' : 'SCM_SITE_ID';
  const siteId = String(dataItem[siteIdKey] ?? '');
  const itemId = String(dataItem.ITEM_ID ?? '');
  const newVmiLt = Number(dataItem.VMI_LT);

  grid.deferUpdate(() => {
    items.forEach((other, idx) => {
      if (idx === e.row) return;
      const otherSiteId = String(other[siteIdKey] ?? '');
      const otherItemId = String(other.ITEM_ID ?? '');
      if (otherSiteId === siteId && otherItemId === itemId) {
        editTrackerRef.current?.storeChange(other, 'VMI_LT', other.VMI_LT, newVmiLt);
        other.VMI_LT = newVmiLt;
      }
    });
    grid.refresh();
  });
};
```

### §5.3 룰 07 §2.10 보강 후보 — §2.10.7 신규

본 패턴은 **`_tobe/07_datagrid.md` §2.10.7 신규 sub-pattern** 으로 정식 등록 가치 — 후속 작업.

---

## §6 변경 이력

| 일자 | 변경 | Phase |
|---|---|---|
| 2026-06-04 | DMF0005 cascade cross-check + 신규 sub-pattern #6 (다중 row propagate) 발견 + 격차 4 건 | Phase 7 후속 |

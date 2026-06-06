# DMF0006 (CustomerModelMapping) — cascade DataModel.Changed cross-check

> Phase 7 후속 cross-check (2026-06-04) — 룰 07 §2.10 의 reference 확장.

---

## §0 결과 종합

| 항목 | 값 |
|---|---|
| AS-IS source | `GSCM.DM.Master.UIL/DMF0006_CustomerModelMapping.cs` (~1500 lines) |
| TO-BE source | `nscm-fe/features/master/src/pages/customer-model-mapping/` (Form + Grid) |
| AS-IS cascade handler 수 | **1 종** (Dsdm_Changed) — 단순 |
| AS-IS branch 수 | **1 branch** (CONVERT_QTY_CELL/MODULE/PACK 음수 → "0" 보정) |
| TO-BE 구현된 branch | **0 (cascade) + 2 modal callback** (Project / Item) |
| **신규 발견** | ⭐ **handler unsubscribe/subscribe 패턴 (AS-IS 의 cascade re-entry 방지)** — TO-BE `deferUpdate` 의 의미 동등 |
| 격차 | 1 건 |

---

## §1 AS-IS handler — `Dsdm_Changed` (L1124~1172)

| Branch | Trigger column | 동작 | sub-pattern |
|---|---|---|---|
| (a) | CONVERT_QTY_CELL / CONVERT_QTY_MODULE / CONVERT_QTY_PACK | 음수 입력 시 "0" 보정 | (validation — §2.10.2 변형) |

### §1.1 Branch (a) — 음수 → "0" 보정

```csharp
if (CONVERT_QTY_CELL || CONVERT_QTY_MODULE || CONVERT_QTY_PACK) {
    int iValue = Convert.ToInt32(GetValue(e.Row, e.Column));
    if (iValue < 0) siMain.SetText(e.Row, e.Column, "0");
}
```

→ TO-BE 미구현 (격차 #1).

### §1.2 ⭐ AS-IS handler unsubscribe/subscribe 패턴

```csharp
try {
    dsdm.Changed -= Dsdm_Changed;   // ⭐ cascade 안 cascade 방지
    switch (e.Type) { ... }
}
finally {
    dsdm.Changed += Dsdm_Changed;   // ⭐ 복원
}
```

→ **§2.10.6-bis (TO-BE `deferUpdate`) 의 AS-IS 형태** — `siMain.SetText()` 가 다시 `Dsdm_Changed` 를 호출하는 무한 루프 방지. TO-BE 의 `grid.deferUpdate(() => {...})` 와 의미 동등.

---

## §2 TO-BE 구현 인벤토리

| TO-BE 위치 | 방식 | sub-pattern | AS-IS 매핑 |
|---|---|---|---|
| `CustomerModelMappingGrid.tsx:38~61` `handleProjectSelected` (storeChange 2 회) | modal callback (Project) | §2.10.6 modal callback | (cascade 아님) |
| `CustomerModelMappingGrid.tsx:63~90` `handleItemSelected` (storeChange 3 회) | modal callback (Item — split string 처리) | §2.10.6 | (cascade 아님) |
| `CustomerModelMappingGrid.tsx:92~110` `handleGridDblclick` | dblClick → Modal | §3.5 modal cell | — |

→ TO-BE 는 **2 modal callback** + dblClick. cellEditEnded cascade 0 위치. AS-IS 의 단일 validation (음수 → 0) 도 미구현.

---

## §3 격차 1 건

| # | 격차 | sub-pattern | AS-IS 위치 |
|---:|---|---|---|
| 1 | CONVERT_QTY_CELL/MODULE/PACK 음수 → "0" 보정 | (validation) | L1147~1156 |

→ 격차 1 건만. DMF0006 은 가장 단순한 cascade 화면.

---

## §4 룰 07 §2.10 reference 확장

| sub-pattern | 본 화면의 reference |
|---|---|
| §2.10.6 modal callback | DMF0006 의 handleProjectSelected / handleItemSelected — **2 modal cell 화면** (가장 단순) |
| §2.10.6-bis deferUpdate | AS-IS DMF0006 의 `unsubscribe/subscribe` 패턴 = TO-BE `deferUpdate` 의 의미 동등 (Wijmo 의 cellEditEnded 는 re-entry 미발생 — `dataItem.X = newVal` 직접 할당이 다시 event 발생 X) |
| §2.10.2 validation 변형 | 음수 → "0" 보정 — duplicate-check 의 변형 (값 보정 vs revert) |

---

## §5 변경 이력

| 일자 | 변경 | Phase |
|---|---|---|
| 2026-06-04 | DMF0006 cascade cross-check + AS-IS unsubscribe/subscribe 패턴 발견 + 격차 1 건 | Phase 7 후속 |

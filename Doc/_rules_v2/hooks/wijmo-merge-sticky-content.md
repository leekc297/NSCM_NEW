# Hook — Wijmo Cell Merge + Viewport Sticky Content (viewport row 제한 패턴)

> ⭐ 신규 화면에 세로 cell merge 가 필요하면 **viewport 안에서만 머지 범위 제한** 패턴 의무 적용.
> 사용자 요구: 머지 그룹 첫 row 가 viewport 위로 사라지면 → 새 viewport 첫 row 에 cell content 자동 표시 (sticky 효과).

작성: 2026-06-03 (DMF0020 SalesFuturePrice 사용자 사고 후, translateY 보정 패턴)
**갱신: 2026-06-18 — viewport row 제한 패턴으로 전환** (DMF0004 `CustomMergeManager` 표준 + DMF0043 ContributeMainGrid 적용 검증 완료)

---

## §0. 사용자 사고 (재발 방지)

> "Column의 cell merge 가 다 풀렸네요. 보완 요청 합니다." (2026-06-03 DMF0020)
> "세로 머지 cell 에서 scroll 시 viewport 위로 사라지면 데이터가 보이지 않음. dmf0004 와 같은 패턴으로." (2026-06-18 DMF0043)

**원인 패턴 — v1 ~ v3 단계별 진화**:

| 버전 | 패턴 | 문제 |
|---|---|---|
| v1 | borderTop 제거 (시각 효과만) | 진짜 머지 X — 사용자 불만족 1 |
| v2 | `g.mergedRanges = {...}` 잘못된 API | 미동작 |
| v3 (deprecated) | formatItem 안 `.merge-content` div wrap + `scrollPositionChanged` 에서 `translateY` 보정 | CSS 변환 — sort/filter 충돌 가능, 추가 DOM 조작 비용 |
| **v4 (표준, 2026-06-18)** | **viewport row 제한** (`panel.viewRange.row/row2`) + `scrollPositionChanged → g.invalidate()` | wijmo native — 모든 동작 호환, DMF0004 표준 |

---

## §1. 적용 시점

다음 트리거 시 본 hook 의무 진입:

| 트리거 | 적용 |
|---|---|
| T01 신규 화면 + 세로 cell merge 요구 | viewport 제한 패턴 의무 |
| T04 Grid 작업 + cell merge 추가 | viewport 제한 패턴 적용 |
| 기존 화면 머지 cell scroll 사고 보고 | translateY 패턴 → viewport 제한 패턴 교체 |

---

## §2. 정확한 Wijmo API (3개 동시)

```ts
import { AllowMerging, CellRange, CellType, MergeManager } from '@mescius/wijmo.grid';

// ① allowMerging enum (필수)
g.allowMerging = AllowMerging.Cells;   // 또는 All / ColumnHeaders

// ② column 단위 flag (column 별 머지 허용 — 초기 + 동적 col 추가 후 재적용 의무)
for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
// 또는 FlexGridColumn 의 allowMerging prop 으로 column 별 설정

// ③ MergeManager subclass + g.mergeManager 할당 (g.mergedRanges 는 존재하지 않음 — 잘못된 API)
class StickyMergeManager extends MergeManager {
  getMergedRange(panel: GridPanel, r: number, c: number, clip = true): CellRange | null {
    // viewport 제한 패턴 (§3 참조)
  }
}
g.mergeManager = new StickyMergeManager();
```

**❌ 잘못된 사용**: `g.mergedRanges = { getMergedRange: ... }` — property 없음, 무시됨.

---

## §3. ⭐ Viewport row 제한 패턴 (표준 — v4)

### 3.1 알고리즘

```ts
class StickyMergeManager extends MergeManager {
  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
    if (panel.cellType !== CellType.Cell) return super.getMergedRange(panel, r, c, _clip);
    const col = panel.columns[c];
    if (!col?.allowMerging) return null;

    const rng = new CellRange(r, c);
    const minRow = panel.viewRange.row;     // ⭐ 현재 viewport 시작 row
    const maxRow = panel.viewRange.row2;    // ⭐ 현재 viewport 끝 row

    // 위로 확장 — viewport 시작까지만
    while (rng.row > minRow && _canMerge(panel, rng.row, c, rng.row - 1, c)) rng.row--;
    // 아래로 확장 — viewport 끝까지만
    while (rng.row2 < maxRow && _canMerge(panel, rng.row2, c, rng.row2 + 1, c)) rng.row2++;

    return rng.isSingleCell ? null : rng;
  }
}
g.mergeManager = new StickyMergeManager();

// scroll 시 머지 재계산 trigger (viewport 변경 시 새 viewRange 기준)
g.scrollPositionChanged.addHandler(() => g.invalidate());
```

### 3.2 작동 원리 (4 단계)

| 단계 | 동작 |
|---|---|
| 1 | Wijmo 가 cell 별로 `mergeManager.getMergedRange(panel, r, c)` 호출 (매 render 시) |
| 2 | `panel.viewRange` = 현재 viewport 안에서 보이는 row 범위 (예: scroll 위치 따라 row 12~28) |
| 3 | 머지 그룹 확장 시 **viewport row 시작/끝까지만** 확장 (위 row 12 / 아래 row 28) |
| 4 | 같은 값 row 들이 viewport 안에서만 그룹화 → 머지 cell 의 top row = 현재 viewport 의 첫 row → content 항상 표시 |

### 3.3 scroll 시 동작

1. 사용자가 grid 스크롤 → `scrollPositionChanged` event fire
2. `g.invalidate()` 호출 → mergeManager 가 새 `viewRange` 로 머지 범위 재계산
3. 새 viewport 첫 row 가 머지 그룹 top → cell content (예: "MOLI") 그 자리에 표시
4. scroll 위로 사라진 row 들은 새 viewport 밖이므로 머지 그룹에서 제외

### 3.4 reference 코드 (DMF0004 표준 + DMF0043 적용 검증)

| 사용 형태 | 위치 |
|---|---|
| **DataGrid wrapper 사용 화면** (자동 적용) | `packages/foundation/src/utils/mergeManager.ts` 의 `CustomMergeManager._getCellMergedRange` |
| **FlexGrid 직접 사용 화면** (수동 적용) | `features/master/src/pages/contribute-main/components/ContributeMainGrid.tsx` 의 `HeaderMergeManager` Cell case |

`CustomMergeManager` 추가 보강: 캐시 (`_mergeKeyCache`) + `bindInvalidateEvents` (cellEditEnded/collectionChanged/sortedColumn 시 cache 무효화). 성능 + dirty mark 정합.

---

## §4. ❌ 기존 v3 (deprecated) — translateY 보정 패턴 회피 사유

```ts
// ❌ 더 이상 사용 금지 — viewport 제한 패턴으로 교체
const adjustMergedContent = () => {
  cellsHost.querySelectorAll('.wj-cell .merge-content').forEach(div => {
    const stickyOffset = viewportTop - cellTop;
    if (stickyOffset > 0 && stickyOffset < cellH - 24) {
      div.style.transform = `translateY(${stickyOffset}px)`;
    } else {
      div.style.transform = 'translateY(0)';
    }
  });
};
g.scrollPositionChanged.addHandler(adjustMergedContent);
g.updatedView.addHandler(adjustMergedContent);
```

문제점:
- formatItem 안 추가 DOM 조작 (`.merge-content` div wrap) — render 비용 증가
- `translateY` CSS 변환 — sort / filter / edit 시 위치 오차
- wijmo native 머지 그룹 정렬과 충돌 가능
- 다른 cellTemplate / formatItem 과 간섭

→ v4 (viewport row 제한) 가 wijmo native 동작 + 호환성 우수.

---

## §5. PRE-WRITE 자기 점검 (모두 ✓ 필수)

```
[ ] 1. `g.allowMerging` enum 명시 설정?
[ ] 2. column 별 `allowMerging=true` (또는 FlexGridColumn allowMerging prop)?
[ ] 3. MergeManager subclass 의 `getMergedRange` 에 `panel.viewRange.row/row2` 사용?
[ ] 4. `scrollPositionChanged → g.invalidate()` handler 추가?
[ ] 5. (deprecated) `.merge-content` div wrap + translateY 패턴 0건?
[ ] 6. DataGrid wrapper 사용 시 별도 작업 없이 자동 적용 확인?
```

---

## §6. POST-WRITE grep 자기 점검

```bash
# 1) viewport 제한 패턴 적용 검증
grep -rnE "panel\.viewRange\.(row|row2)" features/*/src/pages/<screen>/components/*Grid.tsx

# 2) scrollPositionChanged → invalidate 검증
grep -rnE "scrollPositionChanged.*invalidate" features/*/src/pages/<screen>/components/*Grid.tsx

# 3) translateY sticky 안티패턴 검출 (0 row 기대)
grep -rnE "translateY\(\$\{|\.merge-content" features/*/src/pages/<screen>/

# 4) 잘못된 API 검출 (g.mergedRanges = ...)
grep -rnE "g\.mergedRanges\s*=" features/*/src/pages/

# 5) MergeManager subclass + g.mergeManager 할당
grep -rnE "extends MergeManager|g\.mergeManager\s*=" features/*/src/pages/<screen>/components/*Grid.tsx
```

→ 1/2/5 = 1+ row, 3/4 = 0 row 기대.

---

## §7. 사고 사례 — DMF0043 (2026-06-18)

| 적용 전 | 적용 후 |
|---|---|
| 머지 그룹 (예: 부문='MOLI', 5 row) 의 첫 row 가 scroll 시 viewport 위로 사라짐 | 새 viewport 첫 row 에 content "MOLI" 자동 표시 |
| 사용자가 어느 부문인지 알 수 없음 | 항상 보임 |

코드 변경:
- `HeaderMergeManager` 의 Cell case: `rng.row > 0` / `rng.row2 < panel.rows.length - 1` → `rng.row > minRow` / `rng.row2 < maxRow` (viewport 제한)
- `g.scrollPositionChanged.addHandler(() => g.invalidate())` 추가
- translateY sticky content wrap 패턴 (deprecated v3) 제거

---

## §8. 룰 12 §11.6 + DMF0004 CustomMergeManager cross-ref

룰 12 §11.6 의 `HierarchicalMergeManager` 패턴과 동일 기반. DMF0004 `CustomMergeManager` 가 표준 reference (성능 캐시 + invalidate event binding 포함). FlexGrid 직접 사용 화면은 본 hook §3.1 알고리즘 그대로 적용.

---

## §9. 예외 — sticky content 가 필요 없는 경우

- popup grid (스크롤 적음) — 단순 머지 OK
- header 머지만 필요 (cell merge X) — 단순 mergeManager OK
- 머지 row 수가 viewport 보다 작음 (예: 최대 3 row 머지) — viewport 제한 효과 미미

→ 메인 화면 그리드 (scroll 큼) + 좌측 fixed col 세로 머지 시에만 viewport 제한 필수.

---

## §10. Cross-ref

### Hook
- `column-meta-rework-checklist.md` §2 (Wijmo 직접 grid 사용 시 자기 점검)
- `wijmo-flexgrid-entry.md` (Wijmo FlexGrid 작업 진입점)
- `grid-column-setting-popup-pattern.md` (column setting popup 사용 화면 — column 관리와 cross-ref)

### 메모리
- `feedback_wijmo_direct_static_columns.md` (Wijmo 직접 grid 표준)
- `feedback_fe_grid_visible_no_fallback_loss.md` (admin 결정 우선 — column visible)

### 코드 위치
- `packages/foundation/src/utils/mergeManager.ts` — DMF0004 표준 `CustomMergeManager`
- `features/master/src/pages/contribute-main/components/ContributeMainGrid.tsx` — FlexGrid 직접 사용 적용 사례

### 사용자 명시
- 2026-06-03 — DMF0020 cell merge 사고 (v3 translateY 보정 도입)
- **2026-06-18 — DMF0043 cell merge 사고 (v4 viewport row 제한 패턴 표준화 요청)**

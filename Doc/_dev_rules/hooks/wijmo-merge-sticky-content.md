# Hook — Wijmo Cell Merge + Viewport Sticky Content

> 신규 화면 작성 시 좌측 fixed cols 의 cell merge 가 사용자 요구이면, **머지 cell content 의 viewport scroll 안 sticky** 패턴까지 함께 적용.

작성: 2026-06-03 (DMF0020 SalesFuturePrice 사용자 사고 후)

---

## §0. 사용자 사고 (재발 방지)

> "Column의 cell merge 가 다 풀렸네요. 보완 요청 합니다."
> "현재 row 에서 값이 보이도록 하고 싶어요"

**원인 패턴 — 사고 v1 ~ v2 단계별**:

1. **v1 단순 borderTop 제거** — 머지 시각 효과 약함, 진짜 머지 아님 → 사용자 불만족 1
2. **Wijmo `g.mergedRanges = {...}` 잘못된 API** — 미동작 → cell merge 안 됨
3. **Wijmo merge 적용 (정확 API) 만으로는 부족** — 머지 그룹 topmost row 가 viewport 밖이면 cell 빈 영역 → 사용자 불만족 2

## §1. 정확한 Wijmo API (3개 동시)

```ts
import { AllowMerging, CellRange, CellType, MergeManager } from '@mescius/wijmo.grid';

// ① allowMerging enum (필수)
g.allowMerging = AllowMerging.All;   // ColumnHeaders | RowHeaders | Cells

// ② column 단위 flag (초기 + 동적 col 추가 후 재적용 의무)
for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;

// ③ MergeManager subclass + g.mergeManager 할당 (g.mergedRanges 는 존재하지 않음)
class HierarchicalMergeManager extends MergeManager {
  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
    // ... 머지 범위 계산
  }
}
g.mergeManager = new HierarchicalMergeManager();
```

**❌ 잘못된 사용**: `g.mergedRanges = { getMergedRange: ... }` — 무시됨 (property 없음)

## §2. Viewport Sticky Content (사용자 요구 — "현재 row 값 가시")

Wijmo merge cell 의 default 동작: 머지 그룹의 **topmost row 만** 표시. scroll 시 topmost 가 viewport 위로 나가면 그룹의 다른 visible row 위치에 빈 cell.

### 해결 — formatItem 안에서 cell content 를 `.merge-content` div 로 감싼 후 scroll event 에서 `translateY` 보정

```ts
// ① formatItem 에서 cell 의 textContent 를 div 로 wrap
g.formatItem.addHandler((_s, e) => {
  if (e.panel.cellType !== CellType.Cell) return;
  const col = e.panel.columns[e.col];
  if (!fixedBindings.includes(col.binding ?? '')) return;

  const cellEl = e.cell as HTMLElement;
  const text = cellEl.textContent ?? '';
  if (text && !cellEl.querySelector('.merge-content')) {
    const wrap = document.createElement('div');
    wrap.className = 'merge-content';
    wrap.textContent = text;
    wrap.style.cssText = 'padding-top:4px;text-align:center;will-change:transform;';
    cellEl.textContent = '';
    cellEl.appendChild(wrap);
    cellEl.style.verticalAlign = 'top';
    cellEl.style.padding = '0';
  }
});

// ② scrollPositionChanged + updatedView 에서 translateY 보정
const adjustMergedContent = () => {
  const root = g.cells.hostElement as HTMLElement | null;
  if (!root) return;
  const viewportTop = (root.querySelector('.wj-cells') as HTMLElement | null)?.scrollTop ?? root.scrollTop ?? 0;
  root.querySelectorAll<HTMLElement>('.wj-cell .merge-content').forEach(div => {
    const cellEl = div.parentElement as HTMLElement;
    if (!cellEl) return;
    const cellTop = cellEl.offsetTop;
    const cellH = cellEl.offsetHeight;
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

## §3. PRE-WRITE grep 자기 점검

```bash
# 1. mergedRanges 잘못된 API 검출
grep -rn "g\.mergedRanges\s*=" features/**/*.tsx

# 2. allowMerging enum import 확인
grep -rn "AllowMerging" features/**/*.tsx

# 3. MergeManager subclass + g.mergeManager 할당
grep -rn "extends MergeManager" features/**/*.tsx
grep -rn "g\.mergeManager\s*=" features/**/*.tsx
```

## §4. 룰 12 §11.6 cross-ref

룰 12 의 `HierarchicalMergeManager` 패턴과 동일. 본 hook 은 추가로 viewport sticky 보강.

## §5. 예외 — 머지 cell content sticky 가 필요 없는 경우

- popup grid (스크롤 적음) — 단순 머지 OK
- header 머지만 필요 (cell merge X) — 단순 mergeManager OK

→ 메인 화면 그리드 (scroll 큼) + 좌측 fixed col 머지 시에만 sticky 필수.

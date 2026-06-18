# DMF0020 (Sales Future Price) — viewport sticky cell merge 적용

## 변경 항목 (2026-06-18)

| # | 항목 | 영향 파일 |
|---|---|---|
| 1 | Wijmo 세로 cell merge **viewport sticky** 패턴 적용 (`wijmo-merge-sticky-content.md` v4) | `SalesFuturePriceFlexGrid.tsx` |
| 2 | `scrollPositionChanged → g.invalidate()` 머지 재계산 | `SalesFuturePriceFlexGrid.tsx` |

---

## 적용

### Step 1 — FE 파일 배포

`01_FE/sales-future-price/components/SalesFuturePriceFlexGrid.tsx` 를 클라우드 FE 의 `nscm-fe/features/master/src/pages/sales-future-price/components/` 에 덮어쓰기.

### Step 2 — 검증

브라우저 새로고침 → DMF0020 진입 → 조회 → 세로 머지 cell 영역에서 스크롤:
- ✅ 좌측 fixed cols (Division/Site Item 등) 의 머지 그룹 첫 row 가 viewport 위로 사라지면 새 viewport 첫 row 에 cell content 자동 표시
- ✅ 머지 범위가 viewport 안에서만 재계산됨

## 패치 위치 (코드 기준)

`SalesFuturePriceFlexGrid.tsx:367-370`:
```typescript
// ⭐ viewport row 제한 (wijmo-merge-sticky-content.md v4, 2026-06-18)
const minRow = panel.viewRange.row;
const maxRow = panel.viewRange.row2;
let r1 = r, r2 = r;
while (r1 > minRow && sameRow(r1 - 1, r)) r1--;
while (r2 < maxRow && sameRow(r2 + 1, r)) r2++;
```

`SalesFuturePriceFlexGrid.tsx:422-423`:
```typescript
g.mergeManager = new HierarchicalMergeManager();
g.scrollPositionChanged.addHandler(() => g.invalidate());
```

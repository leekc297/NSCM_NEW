# DMF0020 v5 — 클라우드 이관 패키지 (2026-06-18, UI only)

## 변경 요지

이번 이관의 핵심 변경은 FE 3 파일 (61 +/12 −) 의 UI 동작 보강 3건. BE / DB / SP / 메타 변경 0건.

### v4_20260616_w27_split → v5_20260618_ui 차이점

| # | 영역 | 파일 | 변경 |
|---:|---|---|---|
| 1 | FE | `SalesFuturePrice.tsx` | ⭐ menu-button-dynamic-fetch (#2.1) — `useTabBtnPermissions({ menuId })` 추가. `hotkeyConfig` 의 search/insert/save/delete 가 `hasButton(BTN_CD)` 조건부. admin SYS0009 USE_YN='N' 즉시 hotkey 무효 보장. |
| 2 | FE | `SalesFuturePrice.tsx` | ⭐ grid-column-setting-popup-pattern (#58) — `ColumnSettingModal` 의 `fallbackColumns.visible` 매칭 + `onSave` 시 `setVisibleBaseColumns` 호출. popup 재진입 시 이전 이동 내역 복원. |
| 3 | FE | `components/SalesFuturePriceFlexGrid.tsx` | ⭐ grid-column-setting-popup-pattern (#58) §1.4 — `visibleBaseColumns` Set filter 로 좌측 이동된 column 을 grid 에서 숨김. |
| 4 | FE | `components/SalesFuturePriceFlexGrid.tsx` | ⭐ wijmo-merge-sticky-content v4 — `HierarchicalMergeManager` 의 머지 범위를 `panel.viewRange.row/row2` 로 제한 + `scrollPositionChanged → g.invalidate()`. 머지 그룹 첫 row 가 viewport 위로 사라지면 새 viewport 첫 row 에 자동 표시. |
| 5 | FE | `useSalesFuturePriceStore.ts` | ⭐ grid-column-setting-popup-pattern (#58) — `visibleBaseColumns: string[]` state + `setVisibleBaseColumns` action 신설. |

> **클라우드 사내 환경에서 사용자 체감 변화**:
> 1. F-key (Search/Insert/Save/Delete) 가 admin Menu Button 권한과 즉시 동기화.
> 2. ColumnSettingModal 에서 column 좌측 이동 + OK 시 grid 에서 즉시 사라지고, popup 재진입 시 이전 이동 내역 복원.
> 3. 메인 grid 세로 cell merge 가 스크롤 시 viewport 첫 row 에 sticky 표시.

## 폴더 구조

```
DMF0020_v5_20260618_ui/
├─ 00_README.md                                                (이 파일)
└─ 01_FE/
   └─ sales-future-price/                                      (변경 3 파일만)
       ├─ SalesFuturePrice.tsx                                 ⭐ menu-button-dynamic-fetch + column-setting #58
       ├─ useSalesFuturePriceStore.ts                          ⭐ visibleBaseColumns state 추가
       └─ components/
           └─ SalesFuturePriceFlexGrid.tsx                     ⭐ column-setting #58 filter + wijmo-merge v4 sticky
```

> 03_META 없음 (DB / SP / SHEET_COLUMNS / SHEET_MEASURE 변경 0건).

## 적용 순서 (클라우드)

> **사전 조건**: DMF0020 v4_20260616_w27_split 이 이미 사내 적용된 상태 가정. v5 는 그 위에 FE 만 patch.

### Step 1: FE 적용

3 개 파일을 클라우드 FE workspace 의 동일 경로에 덮어쓰기:

```
nscm-fe/features/master/src/pages/sales-future-price/SalesFuturePrice.tsx
nscm-fe/features/master/src/pages/sales-future-price/useSalesFuturePriceStore.ts
nscm-fe/features/master/src/pages/sales-future-price/components/SalesFuturePriceFlexGrid.tsx
```

### Step 2: 빌드 / type-check / lint

```bash
# 클라우드 환경에서
cd nscm-fe
pnpm type-check
pnpm lint
pnpm build
```

> 빌드 실패 시: 사용자 메모리 `feedback_fe_cloud_type_lint_readiness.md` 5 패턴 점검.

### Step 3: 동작 검증

브라우저에서 DMF0020 진입 → 다음 3 시나리오:

1. **menu button dynamic** — admin SYS0009 에서 DMF0020 의 SEARCH 버튼 USE_YN 을 'N' 으로 변경 → grid 새로고침 후 F1 (Search) 무반응 확인. 'Y' 로 복귀 시 동작.
2. **column setting popup** — Column Setting 버튼 → 우측 column 1개를 좌측으로 이동 → OK → grid 에서 즉시 사라짐. popup 재진입 → 좌측에 그 column 그대로 있음.
3. **viewport sticky merge** — grid 스크롤 (수직) → 머지 그룹 (DIVISION/PRODUCT_GROUP 등 좌측 컬럼) 의 첫 row 가 viewport 위로 사라지면 새 viewport 첫 row 에 group 값 표시 유지.

## 관련 hook / 메모리

- `Doc/_rules_v2/hooks/menu-button-dynamic-fetch.md` (#2)
- `Doc/_rules_v2/hooks/grid-column-setting-popup-pattern.md` (#58)
- `Doc/_rules_v2/hooks/wijmo-merge-sticky-content.md` (#38, v4)
- 메모리 `feedback_grid_column_setting_popup_pattern.md`
- 메모리 `feedback_wijmo_viewport_sticky_merge.md`

## diff stat

```
 SalesFuturePrice.tsx                    | 40 ++++++++++++++++++----
 components/SalesFuturePriceFlexGrid.tsx | 23 ++++++++++---
 useSalesFuturePriceStore.ts             | 10 ++++++
 3 files changed, 61 insertions(+), 12 deletions(-)
```

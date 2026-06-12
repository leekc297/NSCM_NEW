# Hook — CustomDialog Layout (Popup 잘림 / 중앙 표시 방지)

> Popup 작성 시 `CustomDialog` 의 height 정책 + position 선택 + container/grid flex layout 일관 적용.

작성: 2026-06-03 (DMF0020 popup 3종 잘림 + 중앙 미표시 사고 후)

---

## §0. 사용자 사고 (재발 방지)

> "Exchange Rate, Price 일괄입력, 그리드 컬럼 정렬 3개의 popup 이 제대로 기동되거나 기동되어도 사이즈 문제로 잘리거나 합니다."
> "환율 조회를 누르면 popup 이 화면 중앙이 띄지 않아요"
> "Price 일괄입력 popup 이 하단이 잘려요"
> "그리드 컬럼 Setting POPUP 의 경우 하단이 짤려요"

**근본 원인**: `CustomDialog` 의 `DEFAULT_HEIGHT='50vh'` 고정 정책 cross-check 누락 → SCSS 의 `min-height: 70vh` 적용 시 50vh 안에서 overflow hidden 영역 잘림.

## §1. CustomDialog DDL (정확 인벤토리)

`packages/shared/src/components/molecules/dialog/CustomDialog.tsx`:

```ts
export type DialogNavigationPosition = 'basic' | 'overflow';
export type DialogNavigationSize     = 1600 | 1400 | 1200 | 1000 | 800 | 600 | 400;

const DEFAULT_WIDTH  = 800;
const DEFAULT_HEIGHT = '50vh';   // ⚠ 고정 — size prop 은 width 만 영향
```

**중요**:
- `size` prop = **width** 만 결정 (enum 1600~400)
- height 는 항상 `50vh` (resize 가능하지만 SCSS 에서 100% 보장 불가)
- `position`:
  - `'basic'` — viewport 중앙 (modal default)
  - `'overflow'` — 화면 가득 사용 (scroll 영역 안에 떠 있음)

## §2. ❌ 금지 패턴 (실제 사고)

### 2.1 `.container { min-height: 70vh }` — 잘림
```scss
.container {
  min-height: 70vh;   // ❌ dialog 의 50vh 안에서 overflow hidden 영역 잘림
  height: 100%;
}
```

### 2.2 `position='overflow'` — 중앙 미표시 (사용자 의도와 다름)
```tsx
<CustomDialog position='overflow' />   // ❌ 화면 가득, 중앙 아님
```

## §3. ✅ 올바른 패턴 — 3 요소 묶음

```tsx
<CustomDialog
  open={open}
  type='modal'
  position='basic'           // ① 중앙 표시
  size={1200}                // width 만 (height 는 50vh 고정)
  handleClose={modalClose}
  disableButtonCancel
  customContentArea={
    <div className={styles.container}>
      <div className={styles.filterRow}>...</div>    {/* ② flex-shrink: 0 */}
      <div className={styles.gridWrap}>...</div>     {/* ③ flex: 1 + min-height: 0 */}
      <div className={styles.bottomRow}>...</div>    {/* ② flex-shrink: 0 */}
    </div>
  }
/>
```

```scss
// ✅ container — height 100% (dialog 안에서 100%) + flex layout, min-height 금지
.container {
  display: flex; flex-direction: column; gap: 8px; padding: 8px;
  height: 100%;
  box-sizing: border-box;
  overflow: hidden;
  // ❌ NO min-height: 70vh / 65vh / 등
}

// ✅ filter / button row — 고정 영역, 잘림 방지
.filterRow, .buttonRow, .bottomRow {
  flex-shrink: 0;   // 잘림 방지
}

// ✅ grid 영역 — flex 확장 + min-height: 0 (flex parent 안 grid 잘림 방지)
.gridWrap {
  flex: 1 1 auto;
  min-height: 0;   // ⚠ 필수 — flex 안 grid 가 부모 제약 무시 못 하게 함
  overflow: hidden;
  position: relative;
}
```

## §4. PRE-WRITE grep 자기 점검

```bash
# 1. min-height vh 사용 검출 (잘림 위험)
grep -rn "min-height:.*vh" features/**/modals/*.module.scss

# 2. position='overflow' (중앙 표시 미적용)
grep -rn "position='overflow'" features/**/modals/*.tsx
# → 사용자가 중앙 원하면 'basic' 으로 변경

# 3. gridWrap min-height: 0 검증 (flex 잘림 방지)
grep -rn "gridWrap\|.gridWrap" features/**/modals/*.module.scss
```

## §5. 예외 — 'overflow' 사용 시점

- popup 안 grid 가 매우 크고 (1000+ rows) viewport 가득 사용 의도 시
- 그러나 사용자가 "중앙 표시" 명시한 경우는 항상 `'basic'`

## §6. cross-ref

- 룰 22 §3 popup CustomDialog props 정확 인벤토리 보강
- 룰 23 §1 `@shared/components` CustomDialog (Dialog 아님)
- hook `popup-asis-analysis.md` §SCSS 패턴 보강

## §7. 사용자 사고 사례

| 사례 | 사고 | Fix |
|---|---|---|
| DMF0020 ExchangeRate v1 | position='overflow' + min-height: 70vh | position='basic' + height: 100% + flex-shrink: 0 + min-height: 0 |
| DMF0020 PriceBatch v1 | min-height: 70vh + bottomRow 잘림 | flex layout + flex-shrink: 0 on bottomRow |
| DMF0020 ColumnTitleSet v1~v2 | min-height: 65vh + bottomRow 잘림 (Default/OK/Cancel) | min-height 제거 + bottomRow flex-shrink: 0 |

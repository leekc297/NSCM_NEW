# Hook — search-button-when-no-searcharea

> **트리거**: 신규 화면이 SearchArea (조회조건 영역) 를 사용하지 않을 때 (`MainTitle disableSearchArea` 또는 SearchArea 컴포넌트 미사용)
>
> **목적**: 사용자가 조회 트리거 수단을 가지도록 SubTitle 좌측에 Search 버튼 자동 렌더 + F5 hotkey 연동 보장

작성: 2026-06-06 (SCM0008 Auth Request 사고 후 — SearchArea 부재 + hotkeyConfig.search false → 조회 트리거 불가)
관련 룰: `_tobe/09_subtitle_hotkey.md` §2.5 / §7.5
상위 룰: `anti-simplification.md`

---

## §0 배경 (사용자 명시 요구 — 2026-06-06)

> **"조회조건이 없는 경우에는 공통버튼 왼쪽에 서치 버튼 추가해주세요."**

SubTitle (`packages/shared/src/components/organisms/sub-title/SubTitle.tsx`) 의 `rightButtons` cluster:

```
[customButtons] → [upload] → [insert] → [delete] → [save] → [sort] → [filter] → [condition] → [resetCondition] → [excel] → [manual]
```

→ `customButtons` 는 이미 공통버튼 좌측에 위치. 단, F5 hotkey 자동 연동 + 표준화를 위해 **`searchAction` prop** 신설.

---

## §1 SubTitle 구현 (의무 — 1회만 수정)

### §1.1 prop 추가

```typescript
interface SubTitleProps {
  // ... 기존 props
  searchAction?: () => void;   // ⭐ 2026-06-06 신설
}
```

### §1.2 rightButtons 렌더 (customButtons 보다 먼저)

```tsx
rightButtons={
  <>
    {searchAction && (
      <Tooltip followCursor title='Search' placement='bottom'>
        <div>
          <Button
            appearance='outlined'
            priority='normal'
            size='small'
            buttonLabel='Search(F5)'
            onClick={searchAction}
            iconComponent={<FunctionSearchIcon />}
          />
        </div>
      </Tooltip>
    )}
    {customButtons?.map(...)}
    {/* upload / insert / delete / save / sort / filter / condition / resetCondition / excel / manual */}
  </>
}
```

### §1.3 F5 hotkey 연동

```typescript
const buttonActions = { ...DefaultButtonActions, ...hotkeyConfig };
// searchAction 가 있으면 F5 → searchAction (hotkeyConfig.search 보다 우선)
if (searchAction) buttonActions[Hotkeys.F5] = searchAction;
```

---

## §2 화면 적용 (의무)

### §2.1 조건

- `MainTitle disableSearchArea` 사용 또는 SearchArea 컴포넌트 미사용
- 화면에 `useTabProcQuery` / `useTabComboQueries` / `useProcQuery` 등 조회 동작 존재

### §2.2 표준 패턴

```typescript
import { useQueryClient } from '@tanstack/react-query';

const queryClient = useQueryClient();

const handleSearch = () => {
  void queryClient.invalidateQueries({ queryKey: ['proc', MENU_ID] });
};

return (
  <>
    <MainTitle title={title} menuId={MENU_ID} disableSearchArea />
    <SubTitle
      menuId={MENU_ID}
      grid={gridRef}
      gridFilter={gridFilterRef}
      dataCount={data?.o_rc?.length ?? 0}
      excelFileName='{Screen Name}'
      hotkeyConfig={hotkeyConfig}
      searchAction={handleSearch}   // ⭐ 의무
      customButtons={customButtons}
    />
    {/* ... grids */}
  </>
);
```

### §2.3 다중 sheet 화면

```typescript
const handleSearch = () => {
  // 모든 sheet refetch
  void queryClient.invalidateQueries({ queryKey: ['proc', MENU_ID] });
  // 또는 특정 sheet 만
  // void queryClient.invalidateQueries({ queryKey: ['proc', MENU_ID, SHEETS.MAIN] });
};
```

---

## §3 PRE-WRITE 자기 점검

```
☐ 화면에 SearchArea / FormItem 사용 있나?
  → YES = SearchArea 가 Search 버튼 제공, searchAction 불필요
  → NO  = §2.2 표준 패턴 의무
☐ MainTitle 에 disableSearchArea prop 있나?
  → YES = searchAction 의무
☐ handleSearch 가 단순 refetch (useQueryClient.invalidateQueries) 인가?
  → 다른 side effect (stale 정리 등) 가 필요하면 명시
```

---

## §4 POST-WRITE 자동 검증

```bash
MAIN="features/{domain}/src/pages/{screen}/{Name}.tsx"

# 1. disableSearchArea 사용 시 searchAction 의무
if grep -qE "disableSearchArea|<MainTitle[^>]*disableSearchArea" "$MAIN"; then
  grep -c "searchAction=" "$MAIN"  # ≥ 1
fi

# 2. SearchArea / FormItem 미사용 시 searchAction 의무
if ! grep -qE "<SearchArea|<FormItem" "$MAIN"; then
  grep -c "searchAction=" "$MAIN"  # ≥ 1
fi

# 3. handleSearch 정의 확인
grep -c "const handleSearch" "$MAIN"  # ≥ 1 (searchAction 사용 시)
```

---

## §5 PR 머지 게이트

- [ ] SearchArea 부재 화면이 `searchAction` 누락 = 0 건
- [ ] `searchAction` 의 handler 가 실제 refetch / 조회 동작 호출 (빈 함수 금지)
- [ ] F5 hotkey 작동 검증 (수동 — 브라우저 콘솔 또는 직접 F5)

---

## §6 anti-pattern

### §6.1 SearchArea 부재 + search 키 false (사고 패턴)

```typescript
// ❌ SCM0008 2026-06-06 위반
<MainTitle ... disableSearchArea />
<SubTitle ... hotkeyConfig={{ search: false, ... }} />
// → 사용자가 조회 트리거 수단 없음. F5 도 비활성.
```

```typescript
// ✅ Fix
<MainTitle ... disableSearchArea />
<SubTitle ... hotkeyConfig={hotkeyConfig} searchAction={handleSearch} />
```

### §6.2 searchAction 에 빈 함수 / undefined 전달

```typescript
// ❌ 금지
<SubTitle ... searchAction={() => undefined} />
<SubTitle ... searchAction={() => {}} />
```

---

## §7 cross-ref

| 항목 | 룰 |
|---|---|
| SubTitle hotkeyConfig 10 키 정책 | `_tobe/09_subtitle_hotkey.md` §2 |
| 공통 버튼 기본 표시 정책 | `_tobe/09_subtitle_hotkey.md` §2.2.1 |
| SearchArea 부재 searchAction 의무 | `_tobe/09_subtitle_hotkey.md` §2.5 |
| 일괄 false 금지 | `_tobe/09_subtitle_hotkey.md` §7.4 |
| asis-button-mapping hook | `hooks/asis-button-mapping.md` §5 |
| 메모리 | `feedback_search_button_when_no_searcharea.md` |

---

## §8 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-06 | 초안 작성 + SubTitle searchAction prop 신설 사양 | SCM0008 SearchArea 부재 + search false → 조회 트리거 불가 사고 |

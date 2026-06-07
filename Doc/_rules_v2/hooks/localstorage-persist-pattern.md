# Hook — localStorage Tab-Cross Persist 패턴

> ⚠ **화면 close/reopen 후에도 유지되어야 하는 state 작성 시 의무 hook**
> DMF0003 Measure 선택 상태 persist 사고 (2026-06-07) 에서 누적된 사고 → 룰화.

작성: 2026-06-07 (DMF0003 Measure persist 사고 후)
관련 룰: `_tobe/04_store.md` §11
상위 룰: `anti-simplification.md`

---

## §0. 배경 사고

DMF0003 (MKT FCST) 의 Measure 선택 상태가 popup 적용 후에도 화면 close/reopen 시 사라지는 문제.

| 시도 | 결과 |
|---|---|
| #1: `createPersistedStoreWithTab` (sessionStorage) | tab close 시 사라짐 |
| #2: 추가 `useEffect([state] → setItem)` 자동 저장 | **mount 시 default 값으로 saved 덮어쓰기 사고** |
| #3 (✅): mount 복원 useEffect + `handleApply` callback 안 직접 `setItem` | OK |

---

## §1. ❌ Anti-pattern (사고 발생 패턴)

```tsx
// ❌ mount 시 default 값으로 saved 덮어쓰기
useEffect(() => {
  // 복원
  const saved = localStorage.getItem(KEY);
  if (saved) setMyState(JSON.parse(saved));
}, []);

useEffect(() => {
  // 저장 — mount 시 closure 의 myState = default → saved 덮어쓰기 사고!
  localStorage.setItem(KEY, JSON.stringify(myState));
}, [myState]);
```

**사고 흐름**:
1. mount → 복원 useEffect → `setMyState(saved)` (React state queue, async)
2. **같은 render** → 저장 useEffect → closure 의 myState = **default** → `localStorage.setItem(default)` ← saved 덮어쓰기
3. 다음 render → 복원된 값 반영되지만 이미 localStorage 는 default

---

## §2. ✅ 정확한 패턴

```tsx
const KEY = '{screen-id}-{state-name}';

// ✅ mount 시 1회만 복원 (저장 useEffect 없음)
useEffect(() => {
  try {
    const saved = localStorage.getItem(KEY);
    if (saved) {
      const parsed = JSON.parse(saved) as unknown;
      if (Array.isArray(parsed) && parsed.length > 0 && parsed.every(x => typeof x === 'string')) {
        setMyState(parsed as string[]);
      }
    }
  } catch { /* noop */ }
// eslint-disable-next-line react-hooks/exhaustive-deps
}, []);

// ✅ state 변경 callback 안에서 store + localStorage 동시 저장
const handleApply = (newValue: string[]) => {
  setMyState(newValue);                                  // store
  try {
    localStorage.setItem(KEY, JSON.stringify(newValue)); // localStorage
  } catch { /* noop */ }
};

// 사용
<MyModal onApply={handleApply} />
```

---

## §3. sessionStorage vs localStorage 결정 표

| state 종류 | storage | 이유 |
|---|---|---|
| 검색조건 (조회조건) | sessionStorage (`createPersistedStoreWithTab`) | F5 새로고침 유지 + tab close 시 reset (다음 진입 시 default) |
| Grid sort/filter | sessionStorage | 동일 |
| **Column 설정 / Measure 선택** | **localStorage** | **사용자 의도 — 화면 close/reopen 후에도 유지** |
| User profile / 환경설정 | localStorage | 동일 |

---

## §4. 검증 grep

```bash
# 사고 패턴 검출 (deps [state] + setItem)
grep -rn "localStorage\.setItem" features/{domain}/src/pages/{screen}/*.tsx -A 1 | grep -B 1 "\[.*State.*\]"

# ✅ 권장 패턴: handleXxx callback 안 setItem
grep -rn "localStorage\.setItem" features/{domain}/src/pages/{screen}/*.tsx
```

---

## §5. cross-ref

- `_tobe/04_store.md §11` (localStorage 별도 persist 패턴)
- `_tobe/03_main_component.md` (handleApply callback 패턴)
- 메모리: `feedback_localstorage_persist_callback_pattern.md`

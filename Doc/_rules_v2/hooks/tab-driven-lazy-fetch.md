# Hook — Tab 전환 시 sub-grid lazy fetch (multi-tab + row-context 화면)

> **Trigger**: T01 (신규 화면) + T07 (데이터 조회) — 다단 grid + 하단 multi-tab sub-grid 패턴 화면
> **PR 차단 강도**: ⭐⭐ (사용자가 tab 전환 시 빈 grid 경험 — UX 사고)
> **신설일**: 2026-06-22 (DMF0008 V13 사용자 명시 — "sspm tab 선택 시 sspm 데이터 조회 + 상단 조회 후 tabpage 변경 시 데이터 표시")
> **Reference**: `nscm-fe/features/master/src/pages/erp-edi-master/ErpEdiMaster.tsx` (V13)

작성: 2026-06-22
상위 룰: `anti-simplification.md` / `screen-shell-composition-mandatory.md`
짝 hook: `grid-cell-interaction-patterns-mandatory.md` (drill-down 패턴 master)

---

## §0. 사용자 명시 (2026-06-22)

> "sspm tabpage 선택 시 에는 sspm 의 데이터를 조회해서 보여주세요.
> 그리고 상단 조회 후 tabpage 변경 시 선택된 Tabpage 데이터도 보여줄 수 있도록 조회 해주세요."

---

## §1. 적용 화면 패턴

DMF0008 (ErpEdiMaster) 같은 **다단 grid + 하단 multi-tab sub-grid** 화면:

```
┌─ Form (검색 조건)
├─ 상단 Grid 1 (Summary)
├─ 중단 Grid 2 (Repair) ← row 더블클릭 (context 선택)
└─ 하단 Tab Panel
   ├─ Tab A (SALES_SITE) ← dblclick 분기 1
   └─ Tab B (SSPM)       ← dblclick 분기 2
```

---

## §2. 잘못된 패턴 (사고 재현)

```ts
// ❌ DMF0008 이전 (사용자 보고 사고)
const handleRepairDoubleClick = (targetSheet: 'SALES_SITE' | 'SSPM', row) => {
  setSearchParams({ ...row });
  if (targetSheet === 'SALES_SITE') {
    setSalesSiteOnly();        // SALES_SITE filter 만 set
    setActiveTab(SALES_SITE);
  } else {
    setSspmOnly();              // SSPM filter 만 set
    setActiveTab(SSPM);
  }
};
```

→ 사용자가 SALES_SITE icon dblclick → SALES_SITE tab + 데이터 OK.
→ 그 후 **SSPM tab 클릭 → SSPM filter 미설정 → useTabProcQuery `enabled: !!filter` → SSPM SP 미호출 → 빈 grid** ❌

---

## §3. 올바른 패턴 (V13 fix)

```ts
// ✅ DMF0008 V13 — useEffect 로 activeTab 변경 시 lazy fetch
useEffect(() => {
  if (!repairContext) return;  // context 없으면 noop
  if (activeTab === SHEET_INDEX.SALES_SITE) {
    setSalesSiteOnly();        // searchParams 기준 filter 재설정 → fetch
  } else if (activeTab === SHEET_INDEX.SSPM) {
    setSspmOnly();
  }
  // eslint-disable-next-line react-hooks/exhaustive-deps
}, [activeTab, repairContext]);
```

### §3.1 작동 원리

- `setSalesSiteOnly()` / `setSspmOnly()` 는 store 의 **현재 searchParams 기준** 으로 filter 채움
- searchParams 는 dblclick 마다 갱신 (최신 row context)
- activeTab 변경 시 useEffect 발화 → 해당 sheet filter 재설정 → useTabProcQuery 자동 fetch
- 동일 값 set 시 tanstack queryKey 미변경 → BE 재호출 없음 (캐시)

### §3.2 시나리오별 동작

| 시나리오 | 결과 |
|---|---|
| REPAIR row A 더블클릭 (SALES_SITE 아이콘) | filters[SALES_SITE] = A data, activeTab=SALES_SITE → SALES_SITE 표시 ✅ |
| **SSPM tab 클릭** | useEffect → `setSspmOnly()` (현재 searchParams A 기준) → filters[SSPM] = A → SSPM 표시 ✅ |
| 다시 SALES_SITE tab | 캐시 hit (filter A 동일) → 재호출 없음 |
| REPAIR row B 더블클릭 (SSPM 아이콘) | searchParams 갱신 → filters[SSPM] = B → SSPM 표시 ✅ |
| 그 후 SALES_SITE tab | useEffect → searchParams B 기준 → filters[SALES_SITE] = B (이전 A 와 다름) → 새 fetch ✅ |

---

## §4. PRE-WRITE 점검 (의무 — 다단 grid + multi-tab 화면)

1. [ ] **`activeTab` state 가 있는가?** (NO → 단일 grid 화면 — 본 hook 미적용)
2. [ ] **dblclick / context state 가 있는가?** (`repairContext` 같은 row 선택 상태 — NO → 본 hook 미적용)
3. [ ] **각 tab 의 filter 가 store 의 `filters[SHEET_X]` 로 분리되어 있는가?** (NSCM 표준 패턴 — YES 이어야 함)
4. [ ] **useTabProcQuery 의 `enabled: !!filters[...]` 가드 적용?** (YES — filter 없으면 호출 안 함)
5. [ ] **`useEffect([activeTab, context])` lazy fetch 추가?** (본 hook 핵심)

---

## §5. POST-WRITE grep 검증

```bash
# multi-tab sub-grid 패턴에서 lazy fetch useEffect 누락 검색
# SHEET_INDEX 사용 + filters[SHEETS.X] 분리 + tab 분기 있는 화면 대상
grep -rnE "setActiveTab\(SHEET_INDEX\." features/ | while read f; do
  dir=$(dirname "$f")
  if ! grep -q "useEffect.*activeTab.*Context" "$dir"/*.tsx 2>/dev/null; then
    echo "missing lazy fetch useEffect: $f"
  fi
done
```

---

## §6. 안티 패턴 카탈로그

| # | 안티패턴 | 대안 |
|---:|---|---|
| 1 | ❌ dblclick 핸들러에서 모든 tab filter 를 한꺼번에 set (eager) | ✅ lazy fetch — useEffect 로 필요 시점에만 |
| 2 | ❌ tab onChange 콜백에서 직접 filter set | ✅ useEffect — activeTab dep 으로 자동 추적 (deprecated callback 비교 회피) |
| 3 | ❌ `if (filters[X])` 가드로 한번만 fetch | ✅ 항상 setX() 호출 — searchParams 변경 시 자동 새 fetch (queryKey 변경) |
| 4 | ❌ 1개 SP 로 2 tab data 동시 반환 (over-engineering) | ✅ SP 분리 + lazy fetch — 사용자 실제 조회 tab 만 호출 |
| 5 | ❌ activeTab 변경 후 setTimeout 등 비동기 처리 | ✅ useEffect — React 가 정상 ordering 보장 |

---

## §7. 성능 고려

- **eager (dblclick 시 둘 다 fetch)**: 사용자가 tab 안 누를 수도 있는 sheet 까지 SP 호출 → 낭비
- **lazy (본 hook)**: 사용자가 tab 누른 시점에만 SP 호출 → 효율
- **재방문 (캐시)**: 같은 row + 같은 tab 재방문 시 tanstack queryKey 동일 → BE 무호출

DMF0008 측정: 1 row dblclick + 양 tab 왕복 → SP 호출 2 회 (각 1회), 재방문 무호출. eager 대비 50% 동일 + 단일 tab 만 보는 경우 100% 절약.

---

## §8. 사고 카탈로그

| 일자 | 화면 | 사고 | Fix |
|---|---|---|---|
| 2026-06-22 | DMF0008 V12 | REPAIR dblclick → 하단 grid 빈 (cursor name 사고) | `sp-cursor-name-response-key.md` |
| 2026-06-22 | DMF0008 V13 | SSPM tab 클릭 시 데이터 미조회 | 본 hook (lazy fetch useEffect) |

---

## §9. 자기 진화 메타

### 9.1 generalizable 패턴
다단 grid + multi-tab + row-context 화면은 **사용자가 자유롭게 tab 전환** 하는 것이 자연스러운 UX. 한 tab 만 fetch 하고 나머지 tab 을 빈 상태로 두는 것은 사용자 기대 위반.

### 9.2 store 활용
- `setSearchParams` — dblclick row 의 context 저장 (재사용)
- `setXOnly()` action — 현재 searchParams 기준 filter set (다른 tab 도 같은 row 데이터 fetch)
- `useEffect([activeTab, context])` — tab 전환 자동 추적

3 요소 결합 시 — dblclick + tab 전환 + 재방문 모두 동작.

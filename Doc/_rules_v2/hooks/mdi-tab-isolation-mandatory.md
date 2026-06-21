# Hook — MDI 탭 상태 격리 (Multiton Store + Query Key 격리, 공식 설계서 §4)

> **Trigger**: T01 (신규 화면 / 화면 수정) + T04 (Grid 데이터 fetch) + T05 (조회조건 store)
> **출처(공식)**: `NSCM_FE 프로그램설계서.docx` §4 "MDI 상태 격리 설계" + §5 "데이터 흐름 및 생명주기" + `NSCM_FE 인수인계서.docx` §2-1
> **PR 차단 강도**: ⭐⭐⭐ (탭 간 데이터 간섭 = 데이터 무결성 사고)
> **신설일**: 2026-06-19 (03.Framework 룰화)
> **상위 hook**: `framework-foundation-entry.md`

## 0. 원칙 — "동일 메뉴를 여러 탭에서 열어도 완벽 격리"

본 시스템은 **MDI 구조**(단일 화면 내 다중 메뉴 동시 활성). 동일 메뉴를 여러 탭에서 열었을 때 각 탭이 **상호 간섭 없는 독립 데이터 컨텍스트**를 유지해야 한다. 격리는 3개 축(라우팅 / Zustand / React Query)에서 **Tab ID(UUID)** 를 식별자로 일관 적용해 달성한다.

---

## 1. 축 1 — UUID 기반 탭 식별·라우팅 (Application Layer)

- 최상위 `@web` 가 전체 MDI 탭 리스트 관리. 메뉴 호출 시마다 **고유 UUID(Tab ID)** 발급.
- 동일 경로라도 Tab ID 로 라우팅 분기 → 렌더링 시 **서로 다른 인스턴스**로 인식.
- **메모리 관리**: 비활성 탭 컴포넌트는 **Unmount** 기본 → 힙 메모리 점유 최적화.
- 화면 컴포넌트는 `PageProps<MENU_ID>` 의 `tabId` 를 props 로 받아 모든 격리 식별자로 사용.

```tsx
export const SalesSite = ({ tabId, title }: PageProps<MENU_ID>) => { ... }
```

## 2. 축 2 — Zustand 멀티톤(Multiton) 스토어

- 싱글톤 전역 store 가 아니라, **동일 정의를 공유하되 Tab ID 가 다르면 별도 인스턴스**를 생성하는 멀티톤 빌더 사용.
- 빌더 표준(인수인계서 §2-1 `createStore`):

| 빌더 | 구성 | 용도 |
|---|---|---|
| `createPersistedStoreWithTab` | persist + immer + **멀티톤** | **페이지(화면)별 store** — 기본 |
| `createPersistedStore` | persist + immer + 싱글톤 | 글로벌 store |
| `createStandardStore` | immer + 싱글톤 (persist 없음) | persister 불필요 시 |

- 각 탭 컴포넌트는 자신의 Tab ID 로 전용 store 엔티티에 **직접 접근** → Props Drilling 없이 완벽 격리.
- 생성된 store 는 `storeRegistry` 가 레지스트리로 관리(추후 일괄 GC 제어 목적).
- `storageName` = **화면 폴더명(kebab-case)** 고정 (#screen-additional-skills 와 정합).

## 3. 축 3 — TanStack Query 탭별 데이터 격리·영속화

- **Query Key 에 Tab ID 포함** → `[tabId, menuId, params]` 형태로 탭 간 캐시 자동 격리.
- 데이터 호출은 `useCustomQueryClient` 기반 커스텀 훅으로만:

| 훅 | 역할 | 메모리 정책 |
|---|---|---|
| `useTabProcQuery` | 데이터 fetch (SP 조회) | 새 검색 시 기존 키 **invalidate** → GC |
| `useProcMutation` | 데이터 저장(SAVE) | 성공 시 해당 탭 캐시 invalidate → 재조회 유도 |
| `useTabComboQueries` / `useTabLookupQueries` | combo/lookup fetch | 캐시는 **전역** 관리 (탭 무관) |

- **IndexedDB Persister**: 폐쇄망 데이터 안정성 위해 IndexedDB persist 구현 → 새로고침 시에도 각 탭 작업 내역 유지.
- **메모리 최적화**: 검색 조건 변경 시 `invalidate` + `remove` 로 과거 데이터 즉시 GC 대상화.

---

## 4. ⭐ SSOT — store 는 검색 파라미터만, 결과 데이터는 Query 가 보유

설계서 §5-2 명시: **store 에는 조회 결과(Data)를 직접 담지 않고, 오직 '검색 파라미터'만 관리**한다. 결과 데이터의 단일 진실 공급원은 React Query 캐시.

- store: `searchParams`(UI 입력) + `filters`(BE trigger) + UI 상태(staticColumns/open 등)
- React Query: 조회 결과 `data`
- `searchParams` ↔ `filters` 분리: 입력 즉시 trigger 금지, 검색 버튼 시 `filters` 갱신 → useTabProcQuery 자동 refetch (#screen-shell-composition §Store 와 동일)

---

## 5. 데이터 생명주기 (설계서 §5)

1. **탭 생성**: 메뉴 클릭 → `@web` 가 UUID 발급
2. **store 동적 생성**: Multiton Builder 가 Tab ID 바인딩 독립 Zustand store 생성 (검색조건/UI상태)
3. **Context 주입**: store 인스턴스가 탭 하위 전 컴포넌트에 전파 → 독립 작업 공간
4. **조회**: useTabProcQuery 가 `[tabId, menuId, params]` 키로 fetch, 결과는 Query 캐시
5. **탭 전환**: 비활성 컴포넌트 unmount, 검색조건 변경 시 invalidate+remove

---

## 6. PRE-WRITE 체크리스트

- [ ] 화면 컴포넌트가 `PageProps<MENU_ID>` 의 `tabId` 를 받아 store/query 식별자로 쓰는가?
- [ ] 페이지 store 가 `createPersistedStoreWithTab` (멀티톤)인가? (싱글톤 `createStore`/`create` 직접 금지)
- [ ] `storageName` = 화면 폴더명(kebab-case)인가?
- [ ] 데이터 fetch 가 `useTabProcQuery` (Query Key 에 tabId 포함)인가? (직접 `useQuery` 금지)
- [ ] store 에 조회 결과 `data` 를 저장하지 않았는가? (SSOT — searchParams/filters/UI 상태만)
- [ ] 검색조건 변경 시 invalidate/remove 가 동작하는가?

## 7. POST-WRITE grep (0 hit 의무)

```bash
# 페이지 store 가 멀티톤이 아닌 싱글톤 빌더 사용
grep -rEn "create(PersistedStore|StandardStore)\(" features/*/src/pages/   # 페이지 store 면 위반 (Tab 빌더여야)
# React Query 직접 사용 (tabId 격리 우회)
grep -rEn "use(Query|Mutation)\(" features/                                # 0 (useTabProcQuery/useProcMutation 경유)
# store 에 결과 data 보관 흔적
grep -rEn "set\w*\(.*\bdata\b.*\)" features/*/src/pages/*/use*Store.ts     # 결과 data set 이면 SSOT 위반 검토
```

## 8. 안티패턴

| ❌ | ✅ |
|---|---|
| 페이지 store 를 `create()` 싱글톤으로 작성 | `createPersistedStoreWithTab` (멀티톤) |
| `useQuery({ queryKey: [menuId] })` (tabId 누락) | `useTabProcQuery` ([tabId, menuId, params]) |
| 조회 결과를 `set({ rows })` 로 store 에 저장 | 결과는 Query 캐시, store 는 filters 만 |
| 비활성 탭 계속 mount 유지 | 비활성 탭 unmount (메모리) |
| 검색조건 변경 후 과거 캐시 잔존 | invalidate + remove |

> 예외: popup modal 의 가상 store 는 tabId 분리 불필요 → `create()` 단순 zustand 허용 (#popup-modal-and-routing-mandatory §6). 본 hook 은 **페이지 화면 store** 에 적용.

## 9. Cross-ref

- `framework-foundation-entry.md` (상위) / `screen-shell-composition-mandatory.md` (#61, Store searchParams↔filters) / `localstorage-persist-pattern.md` (#23) / `react-query-foundation-reexport.md` (#40) / `_tobe/04_store.md`

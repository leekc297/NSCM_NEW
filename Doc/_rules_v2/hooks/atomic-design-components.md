# Hook — Atomic Design 컴포넌트 계층 (@lges/design-system 우선)

> **Trigger**: T01 (신규 화면) + T04 (Grid) + T06 (Modal/Popup) — 컴포넌트 작성/재사용 시
> **출처(공식)**: `NSCM_FE 인수인계서.docx` §2-3 "주요 컴포넌트" + §2-1/§2-2 (Store/Hooks/Utils 카탈로그)
> **PR 차단 강도**: ⭐⭐ (자체 컴포넌트 중복 작성 = 일관성·유지보수 손상)
> **신설일**: 2026-06-19 (03.Framework 룰화)
> **상위 hook**: `framework-foundation-entry.md`
> **짝 hook**: `datagrid-shared-component-mandatory.md` (#10) / `screen-shell-composition-mandatory.md` (#51)

## 0. 원칙 — "디자인 시스템 우선, 없을 때만 직접 작성, 아토믹 계층 준수"

UI 는 **아토믹 디자인 패턴**을 차용하고 **`@lges/design-system`** 요소를 기본 사용한다. 디자인 시스템이 지원하지 않는 컴포넌트만 직접 작성해 `@shared/components` 에서 관리한다. 신규 화면에서 동일 기능 컴포넌트를 **자체 작성하기 전, 반드시 카탈로그를 먼저 검색**한다(중복 작성 금지).

---

## 1. 3 계층 분류 (인수인계서 §2-3)

| 계층 | 정의 | 의존 | 예 |
|---|---|---|---|
| **atoms** | 원자 단위 컴포넌트 | `@lges/design-system` 에 의존 | Button 등 — 필요 시 추가 |
| **molecules** | atoms 의 조합/확장 | atoms | `CustomDropdown`, `Dialog`(디자인시스템 확장), `Tab`(TabWrapper+TabItem) |
| **organisms** | Hooks/Store 에 의존하거나 자체 기능 | molecules + hooks/stores | `Alert`, `ColumnButtonDataGrid`, `MainTitle`, `SearchArea`, `SubTitle`, `ToastMessage` |

## 2. 공통 컴포넌트 카탈로그 (organisms — 화면 조립 표준)

| 컴포넌트 | 역할 | 비고 |
|---|---|---|
| `MainTitle` | 페이지 상단 타이틀 + 브레드크럼 (+ favorite/SearchSwitch) | 페이지 최상단 |
| `SubTitle` | 페이지 중단 타이틀 + 그리드 액션 버튼 + F1~F11 hotkey | #subtitle-button-actions (#63) |
| `SearchArea` | 조회조건 영역 (디자인시스템 변형) | #screen-shell §Form |
| `DataGrid` / `ColumnButtonDataGrid` | Wijmo 그리드에 공통기능 입힌 컴포넌트 | #datagrid-shared-component (#10) — FlexGrid JSX 직접 금지 |
| `CustomDropdown` | 디자인시스템 확장 드롭다운 (multiple/allOption/Map dedup) | molecule |
| `Dialog` / `CustomDialog` | 디자인시스템 확장 다이얼로그 (7 size) | #messaging-api §CustomDialog (#26) |
| `Tab` (`TabWrapper` + `TabItem`) | 탭 구조 (persist) | molecule |
| `Alert` / `ToastMessage` | `useMessageStore` 와 동작 | §3 |

## 3. Store / Hooks / Utils 카탈로그 (재사용 우선 — 신규 생성 전 검색)

**Global Store / Custom Hooks** (`@shared/stores`, `@shared/hooks`):
- `useCustomQueryClient` — 탭별 캐시관리 React Query 래퍼 (→ #mdi-tab-isolation)
- `useTabProcQuery` / `useProcMutation` / `useTabComboQueries` / `useTabLookupQueries`
- `createPersistedStore` / `createPersistedStoreWithTab` / `createStandardStore` (store 빌더)
- `useMessageStore` (`setToast`/`setAlert`) — 컴포넌트는 `MDIContainer.tsx`
- `useSessionStore` (로그인/언어코드/id/이름/메뉴목록 — 현재 SSO 미연동, 직접 login/logout)
- `useUIStore` (사이드바 등 UI), `storeRegistry` (store 레지스트리/일괄 GC)
- ⚠️ `useDataGridStore` = **DEPRECATED** (사용 금지)

**주요 Utilities** (`@foundation/utils`):
- `gridAction` — 행 추가/제거, 엑셀다운로드 등 그리드 동작
- `gridUtils` — 그리드 선택 행 읽기/데이터 핸들링 (Wijmo 타입 안정성 확보)

## 4. PRE-WRITE 체크리스트

- [ ] 필요한 컴포넌트가 `@lges/design-system` 또는 `@shared/components` 카탈로그(§2)에 이미 있는가? (검색 우선)
- [ ] 자체 작성이 정말 필요한가? (디자인시스템 미지원 확인) — 있으면 자체 작성 금지
- [ ] 자체 작성 시 올바른 계층(atoms/molecules/organisms)에 배치했는가?
- [ ] Store/Hook/Util 을 신규 생성하기 전 §3 카탈로그를 검색했는가?
- [ ] `useDataGridStore`(DEPRECATED)를 사용하지 않았는가?
- [ ] 메시지/토스트를 `useMessageStore` 경유로 호출하는가? (직접 alert 금지)

## 5. POST-WRITE grep (0 hit 의무)

```bash
grep -rEn "useDataGridStore" features/                          # 0 (DEPRECATED)
grep -rEn "\b(alert|confirm)\(" features/                       # 0 (useMessageStore 경유)
grep -rEn "<FlexGrid\b" features/                               # 0 (DataGrid 래퍼 사용)
grep -rEn "<dialog\b|@mui/material'.*Dialog" features/          # 0 (CustomDialog 사용)
```

## 6. 안티패턴

| ❌ | ✅ |
|---|---|
| 화면마다 자체 타이틀/검색영역 JSX 작성 | `MainTitle`/`SubTitle`/`SearchArea` 재사용 |
| `<FlexGrid>` 직접 작성 | `DataGrid` 래퍼 |
| `window.alert` / 자체 토스트 | `useMessageStore.setAlert/setToast` |
| `useDataGridStore` | DEPRECATED — 제거 |
| 디자인시스템에 있는 컴포넌트 재작성 | `@lges/design-system` 우선 |
| organism 을 atoms 폴더에 배치 | 계층 정확 배치 |

## 7. Cross-ref

- `framework-foundation-entry.md` (상위) / `datagrid-shared-component-mandatory.md` (#10) / `screen-shell-composition-mandatory.md` (#51) / `messaging-api-and-search-fields-mandatory.md` (#26) / `components-folder-pattern.md` (#9) / `_tobe/03_main_component.md` / `_tobe/10_popup_modal.md`

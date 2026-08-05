# 카테고리 06 — 화면 골격·타입·명명·런타임 / Screen Architecture, Types & Naming

> **연다: 언제?** 신규 화면 골격/폴더·명명/타입/store/import 규율/런타임 사고 예방을 다룰 때.

## A. 아키텍처·골격
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 71 | [framework-foundation-entry](../hooks/framework-foundation-entry.md) | ⭐⭐⭐ | 4-Layer 의존방향(foundation←shared←features←web) + 2-depth alias + 고정 기술스택 |
| 72 | [mdi-tab-isolation-mandatory](../hooks/mdi-tab-isolation-mandatory.md) | ⭐⭐⭐ | MDI 탭 격리 3축 — createPersistedStoreWithTab 멀티톤 + QueryKey tabId + store=searchParams only(SSOT) |
| 73 | [procedure-dts-ssot-mandatory](../hooks/procedure-dts-ssot-mandatory.md) | ⭐⭐⭐ | procedures.d.ts IN/OUT 먼저 작성 → 제네릭 추론. 로컬 재정의/any/`as unknown as` 금지 |
| 47 | [screen-conventions-mandatory](../hooks/screen-conventions-mandatory.md) | ⭐⭐⭐ | 폴더/명명/constants 5종/utils/SCSS/ID 정합 (DMF0004~6 master) |
| 51 | [screen-shell-composition-mandatory](../hooks/screen-shell-composition-mandatory.md) | ⭐⭐⭐ | Page/Form/Hook/Store 인프라 구성 의무 |
| 9 | [components-folder-pattern](../hooks/components-folder-pattern.md) | ⭐ | 진입 Page ≤400라인 + inline grid/dialog JSX 금지 + components/modals 분리 |
| 74 | [atomic-design-components](../hooks/atomic-design-components.md) | ⭐⭐ | @lges/design-system + @shared 카탈로그 우선(중복 작성 금지) + useDataGridStore DEPRECATED |
| 48 | [screen-create-checklist](../hooks/screen-create-checklist.md) | ⭐ | 신규 화면 작성 체크리스트 |
| 49 | [screen-entry-asis-baseline](../hooks/screen-entry-asis-baseline.md) | ⭐ | 신규 화면 진입 AS-IS baseline 4단계 (features walk-up 포함) |
| 45 | [screen-additional-skills-mandatory](../hooks/screen-additional-skills-mandatory.md) | ⭐⭐⭐ | useTranslation/clsx/immer/atomic selector/preSearchParams 9 skill |
| 81 | [tab-driven-lazy-fetch](../hooks/tab-driven-lazy-fetch.md) | ⭐⭐ | multi-tab + row-context 화면 = tab 전환 lazy fetch |
| 23 | [localstorage-persist-pattern](../hooks/localstorage-persist-pattern.md) | ⭐ | mount 1회 복원 + handleApply 직접 setItem |

## B. 코드 규율·타입·품질
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 76 | [code-naming-convention-mandatory](../hooks/code-naming-convention-mandatory.md) | ⭐⭐ | 함수=동사 camelCase / boolean=is·has·can / 상수=SNAKE_CASE / 축약어 금지 + 품질 게이트 |
| 40 | [react-query-foundation-reexport](../hooks/react-query-foundation-reexport.md) | ⭐ | `@tanstack/react-query` 직접 금지 → `@foundation/query-client` |
| 42 | [relative-import-order](../hooks/relative-import-order.md) | ⭐ | 상대 import 알파벳/계층 정렬 |
| 64 | [type-check-error-patterns](../hooks/type-check-error-patterns.md) | ⭐ | FE 17 패턴 self-check (grep 기반) |
| 16 | [fe-cloud-type-lint-readiness](../hooks/fe-cloud-type-lint-readiness.md) | ⭐ | 클라우드 type/lint 통과 5 패턴 |
| 41 | [regression-zero-mandatory](../hooks/regression-zero-mandatory.md) | ⭐⭐⭐ | Hard Boundary 6종(공유물 변경 금지) + 사고 카탈로그 18 + type/lint 0 + regression-impact.ps1 |

## C. 런타임 사고 예방
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 70 | [screen-runtime-pitfalls-mandatory](../hooks/screen-runtime-pitfalls-mandatory.md) | ⭐⭐⭐ | 런타임 사고 통합 차단 — filters 인라인 금지/selector fallback 금지/wijmo 핸들러 useEffect 등록/WijmoRowItem extends 등 (RULESET_MASTER §3.1 8종) |
| 43 | [runtime-error-prevention](../hooks/runtime-error-prevention.md) | ⭐ | 사고 사례 사전 차단 카탈로그 |
| 80 | [sp-cursor-name-response-key](../hooks/sp-cursor-name-response-key.md) | ⭐⭐⭐ | SP OUT cursor 이름 ↔ FE response key fallback chain(`o_rc1 ?? O_RESULT_CURSOR`) 의무 |
| 28 | [mutation-onsuccess-defaults](../hooks/mutation-onsuccess-defaults.md) | ⭐ | onSuccess override 시 default invalidate+toast 명시 재현 |

## Cross-ref
- TO-BE 정밀: `_tobe/01_file_structure.md`~`05_constants.md` / `_tobe/00_SCREEN_ANATOMY.md` · 공식 설계서: `Doc/03.Framework`
- 메모리: `feedback_new_screen_features_location`(features 폴더 5단계) / `feedback_components_folder_separation_mandatory` / `feedback_createpersistedstorewithtab_signature` / `feedback_type_check_error_patterns_rule`

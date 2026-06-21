# Hook — Regression Zero (신규 화면 작업 시 type/lint 오류 0 + 기존 화면 regression 0)

> **Trigger**: T01 (신규 화면 / 화면 수정) + 모든 FE 파일 변경
> **PR 차단 강도**: ⭐⭐⭐ (anti-simplification 동등) — 위반 시 머지 차단
> **신설일**: 2026-06-18 (자가 진화 #23, 사용자 명시 — "기발생 type-check, run lint 오류 재발 금지 + 기존 화면 영향 0")
> **상위 룰**: `anti-simplification.md` / `feedback_shared_global_prop_change_forbidden.md` / `feedback_be_no_modification_rule.md`

## 0. 원칙 (불변)

1. **자기 작업 = 0 error**: 작성한 모든 파일 `pnpm type-check` + `pnpm lint:fix` 0 error / 0 warning (의도적 lint disable 시 주석 사유 + 메모리 entry).
2. **타 화면 영향 = 0**: 신규 작업은 자기 화면 폴더 + 자기 도메인 메타 (admin SQL) 외 **절대 다른 파일을 수정하지 않는다**. 공용 인프라 수정 = 분리 PR + 다른 화면 regression 0 검증.
3. **사고 카탈로그 우선**: 본 hook §2 의 18 반복 패턴은 과거 실 사고로 발생한 것 — 작성 직전 의무 점검.

---

## 1. 변경 가능 / 변경 절대 금지 영역 (Hard Boundary)

### 1.1 ✅ 변경 가능 (신규 화면 작업 범위)

| 경로 | 범위 |
|---|---|
| `nscm-fe/features/{domain}/src/pages/{my-screen}/` | 신규 화면 폴더 전체 |
| `nscm-fe/apps/web/src/core/Router.tsx` | 라우팅 추가 1 entry |
| `nscm-fe/apps/web/src/lazy-loaders/...` | LazyLoader 1 entry |
| `nscm-fe/configs/types/procedures.d.ts` | SHEETS 유니온 자기 화면 항목 |
| `_artifacts/_deploy_packages/{MENU_ID}/` | DB 메타 SQL |
| `Doc/_analysis/...` 자기 화면 분석 자료 | 분석 산출물 |

### 1.2 ⛔ 변경 절대 금지 (Hard Boundary)

| 경로 | 사유 / 메모리 |
|---|---|
| **`nscm-fe/packages/shared/**`** | 전역 공용 — 1 화면 fix 가 모든 화면 regression. `feedback_shared_global_prop_change_forbidden.md` (#17 DataGrid `autoGenerateColumns={false}` 전역 사고) |
| **`nscm-fe/packages/foundation/**`** | FE 인프라 — 동일 |
| **`nscm-fe/packages/lges/**`** | 디자인 시스템 — 동일 |
| **`nscm-fe/features/{other-domain}/**`** | 타 도메인 화면 — 본인 화면 작업과 무관 |
| **`nscm-fe/features/{same-domain}/src/pages/{other-screen}/**`** | 같은 도메인 다른 화면도 절대 금지 |
| **`nscm-fe/features/{domain}/src/components/**`** (공용 인벤토리) | feature 도메인 공용 — 변경 시 도메인 내 다른 화면 regression. **단** 신규 prop 추가 (default = 기존 보존) 만 허용 + 분리 PR |
| **`nscm-be/**`** | BE 변경 금지 (메모리 `feedback_be_no_modification_rule.md`) — fix 는 SP / admin 메타 / FE 측 한정 |
| `Doc/_rules_v2/anti-simplification.md` | 룰 최상위 불변 |

### 1.3 ⚠️ 변경 시 PR 분리 + 다른 화면 regression cross-check 의무

| 경로 | 절차 |
|---|---|
| `nscm-fe/packages/shared/**` 신규 prop 추가 (default 보존) | (1) PR 분리 — 화면 PR 과 별도 (2) 다른 화면 regression 0 cross-check: admin / authority / demand / master 최소 4 도메인 1+ 화면씩 진입 검증 (3) memory entry 작성 (4) 본 hook §1.2 의 default 보존 확인 |
| `features/{domain}/src/components/` 공용 모달 (`ProjectByDivisionModal` 등) | 동일 — 도메인 내 다른 화면 모두 진입 검증 |

---

## 2. 사고 카탈로그 — 반복 type/lint/runtime 오류 18종 (PRE-WRITE 체크)

> 모두 과거 실 사고. 작성 직전 의무 점검.

### 2.1 TypeScript / Type-check

| # | 패턴 | 사고 | 대체 |
|---:|---|---|---|
| 1 | `String(value)` 캐스팅 시 undefined/null guard 누락 | `String(undefined)` → `'undefined'` 직렬화 → BE → SP `TO_NUMBER` → ORA-01722. 메모리 `feedback_fe_string_undefined_cast_guard.md` (SYS0013) | `String(value ?? '')` + 빈 값 차단 |
| 2 | `as unknown as X` 강제 cast | type-check 만 속이고 런타임 폭발. 메모리 `feedback_no_type_cast_around_runtime.md` (CustomDropdown multiple = 쉼표 string) | 컴포넌트 내부 구현 + 기존 화면 사용 패턴 cross-check 후 데이터 모양 변환 |
| 3 | `any` 타입 | type 안전성 손실 — strict 룰 위반 | 정확한 타입 (제네릭 / Generic Inference / Discriminated Union) |
| 4 | 불필요 `as` cast | TS 5+ strict 시 type 추론 우선 — 불필요한 narrow 금지 | `as` 제거 후 type-check pass 시 그대로. 메모리 `feedback_fe_cloud_type_lint_readiness.md` §5 |
| 5 | inline type import 혼용 — `import { type X }` vs `import type { X }` | `verbatimModuleSyntax: true` 환경 차이로 lint fail | type 만 import 시 항상 `import type { X } from '...'`. 메모리 `feedback_fe_cloud_type_lint_readiness.md` §4 |
| 6 | Ref<T>.current 할당 type guard 누락 | `ref.current = grid` 시 ts 미허용 (`MutableRefObject` vs `RefObject`) | `MutableRefObject<T \| undefined>` 명시 + null check 후 사용. 메모리 `feedback_fe_cloud_type_lint_readiness.md` §2 |
| 7 | SHEETS / RESPONSE_SET 유니온 — `procedures.d.ts` 와 DB `SHT_NM` 불일치 | type-check 통과해도 BE 0 row | (1) FE constants.ts `SHEETS.MAIN = 'main'` (2) DB SCM_ADM_SHT_M `SHT_NM='main'` (3) procedures.d.ts 자동 생성 유니온 정렬 의무. 메모리 `feedback_fe_cloud_type_lint_readiness.md` §1 + `feedback_sheet_name_main_standard.md` |
| 8 | Generic 추론 실패 — `<DataGrid<T>>` T 누락 | DataGrid 내부 T = `WijmoRowItem` default — 화면 타입 손실 | `<DataGrid<ResponseData<MENU_ID, SHEETS.X>>>` 명시 |

### 2.2 ESLint / 모듈 시스템

| # | 패턴 | 사고 | 대체 |
|---:|---|---|---|
| 9 | 상대 경로 import (`../../../`) | alias 미사용 → 경로 의존 + 리팩토링 위험 | `@shared` / `@foundation` / `@master` 등 alias 의무 (룰 §4 No.1) |
| 10 | Feature 간 직접 import (admin → demand 등) | 모듈 경계 위반 — `apps/web` 에서 조합 의무 | apps/web/src/core/Router.tsx 에서 LazyLoader |
| 11 | Wijmo `@mescius/wijmo.*` 패키지 import 순서 | lint `import/order` rule 위반 | builtin → external → internal → relative + `import type` 우선. 메모리 `feedback_fe_cloud_type_lint_readiness.md` §3 |
| 12 | `import { X } from '@shared/components'` — alias export 부재 | runtime polyfill error (Box/Container/Paper/IconButton 등 @shared/mui 부재) | 메모리 `feedback_runtime_error_prevention.md` — alias 실 export 인벤토리 점검 + hook `fe-import-check.md` 의무 (auto-attach) |
| 13 | `console.log` / `console.error` 잔존 | lint `no-console` fail | Logger / 메시지 store (`useMessageStore.setAlert`) |

### 2.3 Vite / 빌드 / 런타임

| # | 패턴 | 사고 | 대체 |
|---:|---|---|---|
| 14 | `import(\`dayjs/locale/${X}\`)` 동적 import 패턴 | Vite 정적 분석 불가 → 런타임 module not found | `apps/web/src/dayjs-setup.ts` 정적 import + vite.config esbuild plugin. 메모리 `feedback_vite_dayjs_locale.md` |
| 15 | PascalCase → kebab-case 연속 대문자 분리 | `NNMasterMapping` → `n-n-master-mapping` (잘못된 lowercase 분해) → MNU_URL 404. 메모리 `feedback_kebab_case_consecutive_uppercase.md` | NN/EE/UI/ID/AI 등 2~3 글자 약어는 한 단어 처리. FE 폴더명 ↔ DB MNU_URL 1:1 cross-check |
| 16 | `<FlexGridColumnGroup>` JSX 단일 child | React 19 + wijmo.react.grid → `_setOwnerList is not a function`. 메모리 `feedback_wijmo_columngroup_jsx_avoid.md` | DataGrid wrap + staticColumns + dynamicColumns 분리 (#60) |
| 17 | inline style (`style={{ color: 'red' }}`) | 디자인 시스템 무력화 + lint `react/forbid-dom-props` fail | SCSS Module (`styles.xxx`) |
| 18 | DataGrid `autoGenerateColumns={false}` 전역 사고 (#17) | shared default 변경 → 모든 화면 grid 컬럼 0. 메모리 `feedback_shared_global_prop_change_forbidden.md` | 새 optional prop + default = 기존 동작 보존 |

---

## 3. PRE-WRITE 체크리스트 (작성 직전 의무 — 23 항목)

### 3.1 영역 점검 (1~4)
```
[ ] 1. 작성하려는 파일이 §1.1 (변경 가능) 안에 있는가? §1.2 (금지) 면 작업 재설계
[ ] 2. shared/foundation/lges 공용 컴포넌트는 읽기만? 변경 시 §1.3 분리 PR
[ ] 3. 같은 도메인 다른 화면 폴더는 절대 건드리지 않는가?
[ ] 4. nscm-be/** 변경 0 — fix 는 SP / admin 메타 / FE 한정?
```

### 3.2 사고 카탈로그 점검 (5~22)
```
[ ] 5.  String(value) 사용 시 ?? '' fallback?
[ ] 6.  as unknown as X / as any 절대 미사용?
[ ] 7.  any 타입 0 (정확한 제네릭)?
[ ] 8.  불필요 as cast 제거?
[ ] 9.  type 만 import 시 `import type { ... }` 일관?
[ ] 10. Ref<T> type — MutableRefObject<T | undefined> 명시 + null check?
[ ] 11. SHEETS / RESPONSE_SET 유니온 — procedures.d.ts ↔ DB SHT_NM 일치?
[ ] 12. <DataGrid<T>> 제네릭 T 명시?
[ ] 13. 상대 경로 `../../../` 0 — alias (@shared / @foundation / @master) 사용?
[ ] 14. Feature 간 직접 import 0?
[ ] 15. import 순서: builtin → external → internal → relative + import type 우선?
[ ] 16. alias export 인벤토리 확인 (fe-import-check.md §1.1 ~ §1.4 의무)?
[ ] 17. console.log / console.error 0?
[ ] 18. dayjs/locale 동적 import 0 (정적 setup 만)?
[ ] 19. 폴더명 ↔ DB MNU_URL kebab-case 1:1 cross-check (NN/EE/UI 약어 처리)?
[ ] 20. FlexGrid JSX 직접 사용 0 (DataGrid wrap 의무, #60)?
[ ] 21. inline style 0 (SCSS Module 만)?
[ ] 22. DataGrid default prop 변경 0 — 새 optional prop 만?
```

### 3.3 자기 화면 표준 점검 (23)
```
[ ] 23. #60 (DataGrid 공용 컴포넌트) + #61 (Screen Shell Composition) + #58 (Column Setting Popup) + #59 (Cascade Combo Filter) 4 master hook 적용?
```

---

## 4. POST-WRITE grep (작성 직후 / PR 직전 의무)

### 4.1 자기 화면 자체 점검

```bash
SCREEN_PATH="nscm-fe/features/{domain}/src/pages/{my-screen}"

# 1. String(undefined) guard 누락
grep -nE "String\([^)]+\)" "$SCREEN_PATH" | grep -v "??\\|||" | head
# 결과 — fallback 확인 의무

# 2. as unknown as / as any
grep -nE "as unknown as|as any" "$SCREEN_PATH"
# 결과 = 0

# 3. 상대 경로 import
grep -nE "from '\\.\\./\\.\\./\\.\\." "$SCREEN_PATH"
# 결과 = 0

# 4. console.log / error
grep -nE "console\\.(log|error|warn)" "$SCREEN_PATH"
# 결과 = 0

# 5. inline style
grep -nE 'style=\\{\\{' "$SCREEN_PATH"
# 결과 = 0

# 6. any 타입
grep -nE ': any[,;\\)\\s]|<any>' "$SCREEN_PATH"
# 결과 = 0

# 7. FlexGrid JSX 직접
grep -nE "<FlexGrid|<FlexGridColumnGroup|<FlexGridColumn[^M]" "$SCREEN_PATH"
# 결과 = 0 (DataGrid 만)
```

### 4.2 Hard Boundary 위반 검출 (PR 직전 의무)

```bash
# 1. 신규 화면 PR 에 shared/foundation/lges/be 변경 포함 검출
git diff --name-only main...HEAD | grep -E "(packages/shared|packages/foundation|packages/lges|nscm-be)/"
# 결과 = 0 — 있으면 분리 PR 또는 작업 재설계

# 2. 같은 도메인 다른 화면 변경 검출
git diff --name-only main...HEAD | \
  grep -E "features/{domain}/src/pages/" | \
  grep -v "{my-screen}"
# 결과 = 0
```

### 4.3 Build / Type-check / Lint (PR 직전 의무)

```bash
pnpm type-check   # 0 error
pnpm lint:fix     # 0 error / 0 warning
# 의도적 lint disable 시: 주석 + 메모리 entry 작성 의무
```

---

## 5. 신규 prop 추가 시 (공용 컴포넌트 확장 — 분리 PR 절차)

DataGrid / SearchArea / SubTitle / MainTitle / ColumnSettingModal 등 공용 컴포넌트에 신규 기능이 필요한 경우:

### 5.1 분리 PR 절차 (의무)

1. **별도 브랜치 + PR**: 화면 PR (`feat/{menuId}-...`) 과 별개 (`feat/shared-{component}-add-{prop}`).
2. **default = 기존 동작 보존**: `<NewProp default={기존동작값}>` — 기존 사용처 0 영향.
3. **다른 화면 regression cross-check** (최소 4 도메인 1 화면씩):
   - admin: `user-management` 또는 `menu`
   - authority: `auth-request`
   - demand: `mkt_forecast` (DMF0003)
   - master: `sales-site` (DMF0004) + `contribute-main` (DMF0043) + `contribute-view` (DMF0043_01)
   - 각 화면 진입 → grid 표시 → 검색 → CRUD 동작 검증 보고서 첨부
4. **메모리 entry**: shared 변경 사유 + 다른 화면 regression 0 검증 결과 보고.

### 5.2 사용자 작업 PR 에서 shared 변경 발견 시 (Reviewer 처리)

→ PR 차단 + "분리 PR 요청" 코멘트 + 사고 카탈로그 #18 (DataGrid 전역 사고) reference.

---

## 6. 작업 종료 직전 보고 양식 (PR 본문 / 사용자 보고)

```
## 검증
- [x] pnpm type-check: 0 error
- [x] pnpm lint:fix: 0 error / 0 warning
- [x] 변경 파일 Hard Boundary 점검:
  - packages/shared/** 변경: 0
  - packages/foundation/** 변경: 0
  - features/{other}/** 변경: 0
  - nscm-be/** 변경: 0
- [x] 본 화면 진입 / grid / 검색 / CRUD 동작 OK
- [x] (해당 시) shared 변경 — 분리 PR + regression 0 cross-check 보고서 #링크

## 사고 카탈로그 점검
- [x] String(value) ?? '' fallback 적용
- [x] as unknown as / any 0
- [x] Ref<T> MutableRefObject 명시
- [x] SHEETS ↔ DB SHT_NM 일치 확인
- ... (사용된 항목만)
```

---

## 7. 관련 hook / 메모리 cross-ref

| 항목 | 참조 |
|---|---|
| FE Import 경로 인벤토리 (auto-attach) | `fe-import-check.md` §1 |
| shared/* default 변경 금지 | 메모리 `feedback_shared_global_prop_change_forbidden.md` |
| BE 변경 금지 | 메모리 `feedback_be_no_modification_rule.md` |
| as cast 우회 금지 | 메모리 `feedback_no_type_cast_around_runtime.md` |
| String(undefined) guard | 메모리 `feedback_fe_string_undefined_cast_guard.md` |
| 클라우드 type-check + lint 통과 5 패턴 | 메모리 `feedback_fe_cloud_type_lint_readiness.md` |
| Wijmo FlexGrid 안티패턴 10 row | hook `wijmo-flexgrid-entry.md` (#57) |
| FlexGridColumnGroup JSX 단일 child | 메모리 `feedback_wijmo_columngroup_jsx_avoid.md` |
| Vite dayjs/locale 정적 setup | 메모리 `feedback_vite_dayjs_locale.md` |
| Alias export 인벤토리 (Box/IconButton 부재 등) | 메모리 `feedback_runtime_error_prevention.md` |
| PascalCase → kebab-case 변환 | 메모리 `feedback_kebab_case_consecutive_uppercase.md` |
| SHEETS / SHT_NM 'main' 표준 | 메모리 `feedback_sheet_name_main_standard.md` |
| 자기 화면 표준 (Grid) | hook `datagrid-shared-component-mandatory.md` (#60) |
| 자기 화면 표준 (Shell) | hook `screen-shell-composition-mandatory.md` (#61) |

---

## 8. 검증 — PR 차단 강도

§3 PRE-WRITE 23 항목 / §4 POST-WRITE grep 8 / §6 보고 양식 의무.
§1.2 Hard Boundary 위반 시 즉시 머지 차단 (anti-simplification 동등 강도) + 분리 PR 요청.
사용자 결정 (2026-06-18).

---

## 9. 자동화 보강 (2026-06-19, DMF0043 회고 후) — 룰 + 도구 + 절차

> **배경**: DMF0043 작업 중 클라우드 lint/type-check 회신으로 인접 화면 4개 (DMF0008 / DMF0072 / SalesFuturePrice + 기타) 의 type/lint 오류 일괄 fix (commit `2d7badb`). Hard Boundary 위반은 0이었으나, **로컬 pre-commit (lint-staged 변경 파일만) ↔ 클라우드 전체 lint 사이 lag** + **글로벌 룰 / `procedures.d.ts` SHEETS 유니온 변경**으로 인접 화면 잠재 사고가 commit 후 발견되는 회귀 root path 식별.

### 9.1 룰 강화 4 항목 (R1~R4)

| # | 항목 | 강화 |
|---|---|---|
| **R1** | Hard Boundary 6 자동 grep | `.husky/pre-commit` 안 staged 파일 path grep — 위반 시 경고 (commit 차단 X, 분리 PR 권고) |
| **R2** | 사고 카탈로그 18종 PRE-WRITE | 본 hook §2 18 패턴은 작성 직전 의무 — POST-WRITE 후 §4 8 grep 0 hit 확인 |
| **R3** | 도메인 공용 변경 시 인접 화면 인벤토리 출력 | `_artifacts/_local_setup/regression-impact.ps1` 실행 — 같은 도메인 인접 화면 자동 추출 |
| **R4** | `procedures.d.ts` (SHEETS 유니온 / RESPONSE_SET / ProcRequest / ResponseData) 변경 | 신규 SP 추가 시 cross-screen type narrow 영향 가능. anti-simplification grep 의무 + 전 도메인 lint 회신 cross-check |

### 9.2 도구 인벤토리

| 도구 | 위치 | 동작 |
|---|---|---|
| Hard Boundary git hook | `nscm-fe/.husky/pre-commit` | staged 파일 중 `packages/{shared,foundation,lges}/`, `features/*/src/components/`, `nscm-be/` 변경 감지 → 경고 메시지 + 분리 PR 권고 |
| 영향 화면 인벤토리 도구 | `_artifacts/_local_setup/regression-impact.ps1` | `git diff --name-only HEAD` → 변경 영역 + 같은 도메인 인접 화면 + `procedures.d.ts` 변경 여부 출력 |
| CI/MR static_analysis | `nscm-fe/.gitlab-ci.yml` | 전 monorepo `pnpm lint` + `pnpm type-check` (사내 nexus 차단으로 로컬 불가) — exit code 강제 |
| 클라우드 회신 patch 워크플로 | `_artifacts/_lint_fix_patch/*.patch` | 클라우드 lint 회신 → patch 생성 → cross-domain regression 동일 PR fix |

### 9.3 절차 (작업 흐름 — 의무)

```
[작업 시작]
  → 룰셋 로드 (anti-simplification + RULESET_MASTER + 00_INDEX)
  → 작업 영역 식별 (T01 신규 / T01M 수정 / T04 Grid 등)

[작성 중]
  → PRE-WRITE: Hard Boundary 6 grep + 사고 카탈로그 18 체크 (본 hook §3)
  → POST-WRITE: 8 grep 0 hit 확인 (본 hook §4)

[작업 종료 직전]
  → Screen Completion Gate 통과 (`screen-completion-gate.md` 8 게이트)
  → regression-impact.ps1 실행 → 변경 파일 + Hard Boundary 위반 + 영향 도메인 보고
  → 사용자에게 보고 양식 (본 hook §6) 제출

[사용자 → 클라우드]
  → 클라우드에서 pnpm lint + pnpm type-check (로컬 차단됨)
  → 회신 오류를 AI 에게 전달

[AI → fix]
  → _artifacts/_lint_fix_patch/ 워크플로 따라 patch 생성
  → cross-domain regression fix 동일 PR 안 포함
  → 사용자 확인 후 commit + push
```

### 9.4 사고 회고 (DMF0043, 2026-06-19)

| 사고 | 영향 받은 화면 | 원인 | 학습 |
|---|---|---|---|
| commit `2d7badb` 일괄 fix | DMF0008 / DMF0072 / SalesFuturePrice (+ 기타) | 글로벌 룰 신규 적용 + `procedures.d.ts` SHEETS 추가 + lint-staged 의 변경 파일 한정 검사 | 로컬 nexus 차단 환경에서 회귀는 commit 후 클라우드에서만 발견 → §9.3 절차로 작업 종료 직전 영향 인벤토리 의무화 |

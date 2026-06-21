# Hook — 코드 Naming Convention + 품질 게이트 (공식 인수인계서 §4 / 설계서 §3)

> **Trigger**: T01 (신규 화면 / 화면 수정) + 모든 FE 코드 작성/수정 시
> **출처(공식)**: `NSCM_FE 인수인계서.docx` §4 "코드 컨벤션"(§4-1 Naming convention / §4-2 Import Rules / §4-3 Naming Rule) + `NSCM_FE 프로그램설계서.docx` §3 "공통 설정 및 품질관리"
> **PR 차단 강도**: ⭐⭐ (lint/type 게이트 위반은 push·배포 자동 차단)
> **신설일**: 2026-06-19 (사용자 누락 점검 요청 — §4-3 변수 naming rule + §3 품질 게이트 미룰화 발견)
> **상위 hook**: `framework-foundation-entry.md`
> **짝 룰**: `_dev_rules/02_DEVELOPMENT_RULES.md` (브랜치/커밋) / `screen-conventions-mandatory.md` (#47, 화면 구조 명명) / `procedure-dts-ssot-mandatory.md` (#73, 타입 strict)

## 0. 원칙

파일·폴더 명명(§1)은 기존 `_tobe/01` / `screen-conventions`(#47)와 동일하나, 본 hook 은 공식 인수인계서가 명시한 **변수·함수·상수 레벨 Naming Rule(§4-3)** 과 **품질 자동화 게이트(설계서 §3)** 를 명문화한다 — 두 영역은 기존 룰에 없던 누락분이다.

---

## 1. 파일/폴더 Naming Convention (인수인계서 §4-1)

| 대상 | 형식 | 예 |
|---|---|---|
| Components (`*.tsx`) | **PascalCase** | `Button.tsx`, `ForecastPrice.tsx` |
| Utils / Hooks / Stores (`*.ts`) | **camelCase** | `useSessionStore.ts`, `gridUtils.ts` |
| Types / Constants (`*.ts`) | **kebab-case** | `forecast-price.types.ts`, `forecast-price.constants.ts` |
| Folders | **kebab-case** | `forecast-price/` |
| SCSS Module (`*.module.scss`) | **부모와 동일(PascalCase)** | `ForecastPrice.module.scss` |

## 2. ⭐ 변수·함수·상수 Naming Rule (인수인계서 §4-3 — 신규 룰화)

1. **의미없는 단어 / 축약어 금지** — 모든 변수명은 의미를 표현. (`tmp`, `val2`, `d`, `arr1` 등 금지)
2. **함수**: **동사로 시작하는 camelCase** — `getUserSession`, `handleSearch`, `fetchStaticColumns`.
3. **컴포넌트 내 변수/상수**: 의미 표현 camelCase. **boolean 은 `is`/`has`/`can` 으로 시작** — `isLoading`, `hasPermission`, `canEdit`.
4. **상수(constant)**: **SNAKE_CASE(대문자)** — `MENU_ID`, `BASE_COLUMN_COUNT`, `DEFAULT_DIVISION`.
5. **미사용 파라미터**: 함수 파라미터 등에서 사용하지 않는 input 은 **`_` 접두** — `(_event, value) => ...`, `map((_, idx) => ...)`.

## 3. Import Rules (인수인계서 §4-2 — #71 §3 과 동일, 재확인)

- **Deep Import 금지**: Layer 1/2 import 는 항상 2-depth + `index.ts` export.
- **Relative Import 금지**(패키지 사이): Path Alias 2-depth 만.

## 4. 품질 게이트 (설계서 §3 — 자동 차단, 신규 룰화)

| 게이트 | 도구 | 차단 시점 |
|---|---|---|
| **정적 분석** | ESLint + Prettier + SonarLint(IDE 실시간) | 작성 중 / pre-push |
| **타입 안정성** | TypeScript **Strict** (`any` 금지, Generic + Type Guard 유틸) | 컴파일 / pre-push |
| **Husky pre-push** | lint + type-check **강제** | push 전 — 실패 시 원격 반영 불가 |
| **Branch Naming Check** | 사전 정의 규칙 위반 시 push 차단 | push 전 (`_dev_rules/02`) |
| **단위 테스트** | Vitest (핵심 로직/유틸) | CI |
| **CI Pipeline** | GitLab CI — Validation(Branch/Lint/Type) → Build(Turborepo) → Deploy | 서버 사이드, 위반 시 빌드/배포 즉시 Fail |

> 작성 직후 self-check 로 lint+type 위반 0 을 확인한다(`type-check-error-patterns.md` #64 grep + `pnpm lint:fix` / `pnpm type-check`). 게이트는 로컬·CI 양쪽에서 동일 검사.

## 5. PRE-WRITE 체크리스트

- [ ] 파일/폴더명이 §1 형식과 일치하는가? (Component PascalCase / hook·util·store camelCase / types·constants kebab-case / folder kebab-case / scss 부모 동일)
- [ ] 함수명이 동사로 시작하는 camelCase 인가?
- [ ] boolean 변수가 `is`/`has`/`can` 접두인가?
- [ ] 상수가 SNAKE_CASE 인가?
- [ ] 미사용 파라미터에 `_` 접두를 적용했는가?
- [ ] 의미없는 단어/축약어를 쓰지 않았는가?
- [ ] `any` 0 / strict 통과 + (필요 시)Type Guard 유틸로 처리했는가?

## 6. POST-WRITE grep (위반 검출)

```bash
# boolean 변수가 is/has/can 없이 선언된 의심 (수동 검토)
grep -rEn "const (show|open|loading|disabled|checked|active|visible|valid)\b" features/*/src/pages/   # is/has/can 접두 검토
# 상수가 camelCase 로 선언된 의심 (대문자 상수여야)
grep -rEn "^\s*const [a-z][a-zA-Z]+ = ('[^']+'|[0-9]+);" features/*/src/pages/*.constants.ts          # SNAKE_CASE 검토
# any 사용
grep -rEn ":\s*any\b" features/                                                                       # 0
# 미사용 파라미터 lint (ESLint no-unused-vars 가 자동 — _ 접두로 회피)
```

## 7. 안티패턴

| ❌ | ✅ |
|---|---|
| `const tmp = ...`, `val2`, `arr1` | 의미있는 이름 |
| `function userData() {}` (명사) | `function getUserData() {}` (동사) |
| `const loading = true` | `const isLoading = true` |
| `const maxCount = 100` (변하지 않는 상수) | `const MAX_COUNT = 100` |
| `(event, value) => use(value)` (event 미사용) | `(_event, value) => use(value)` |
| `: any` 로 타입 우회 | strict + Type Guard 유틸 |
| lint/type 실패 상태로 push 시도 | pre-push 게이트 통과 후 push |

## 8. Cross-ref

- `framework-foundation-entry.md` (#71, import·기술스택·설계원칙) / `screen-conventions-mandatory.md` (#47, 화면 폴더/constants 구조) / `procedure-dts-ssot-mandatory.md` (#73, strict 타입 SSOT) / `type-check-error-patterns.md` (#64, FE self-check) / `relative-import-order.md` (#42) / `_dev_rules/02_DEVELOPMENT_RULES.md` (브랜치/커밋/MR) / `_tobe/01_file_structure.md` / `_tobe/05_constants.md`

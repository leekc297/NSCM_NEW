# Hook — Framework Foundation Entry (공식 FE 프레임워크 설계서 준수 진입점)

> **Trigger**: T01 (신규 화면 / 화면 수정) + 모든 FE UI 작업 진입 시 1차 확인
> **출처(공식 단일 진실)**: `Doc/03.Framework/NSCM_FE 프로그램설계서.docx` + `Doc/03.Framework/NSCM_FE 인수인계서.docx` (LG CNS 표준 프로세스 Ver 1.0, 2026-03-30)
> **PR 차단 강도**: ⭐⭐⭐ (anti-simplification 동등 — 아키텍처 위반은 신뢰성 손상)
> **신설일**: 2026-06-19 (사용자 명시 — "03.Framework 폴더 문서를 UI 개발/수정 시 적용 가능하도록 rule 로 생성")
> **짝 hook**: #mdi-tab-isolation + #procedure-dts-ssot + #atomic-design-components + #be-api-contract-ui (4 종 동시 신설)

## 0. 원칙 — "공식 설계서가 reverse-engineered 룰을 압도한다"

기존 hook 다수(screen-conventions / screen-shell-composition 등)는 reference 화면(DMF0004~0007)에서 역추출한 룰이다. 본 hook 은 **LG CNS 공식 FE 설계서·인수인계서**를 단일 진실 출처로 삼아, 화면 hook 들이 따르는 **아키텍처 원리**를 명문화한다. 화면 hook 과 충돌 시 본 hook 의 아키텍처 원칙(Layer 방향 / import 규율 / 설계 3원칙)이 우선한다.

신규 화면/수정 진입 시 본 hook 으로 **아키텍처 적합성**을 먼저 통과한 후 화면별 hook(#60~#70 등)으로 진행한다.

---

## 1. 기술 스택 (고정 — 임의 변경 금지)

| 영역 | 표준 | 비고 |
|---|---|---|
| Core | **React 18 + TypeScript(strict) + Vite** | React 19 표기 혼재 주의 — 설계서 기준 18 계열, 실제 코드 버전 cross-check |
| Monorepo | **Turborepo + pnpm v10+** (Node 20 LTS) | npm/yarn 금지, pnpm strict mode |
| 전역 상태 | **Zustand** (Flux, 멀티톤) | Redux/Recoil 도입 금지 |
| 서버 상태 | **TanStack Query (React Query)** | 서버 데이터는 store 가 아닌 Query 가 보유 |
| HTTP | **Axios** (인터셉터로 공통 에러/인증) | 화면에서 `fetch`/`axios` 직접 호출 금지 → `@foundation/apis` apiClient 경유 |
| 스타일 | **SCSS Module** | inline style 금지 |
| 다국어 | **i18next** | 하드코딩 텍스트 금지 |
| 테스트/품질 | **Vitest + ESLint + Prettier + SonarLint** | Husky pre-push 로 lint+type-check 강제 |

⚠️ 폐쇄망 특성: pnpm 설치 시 `pnpm config set strict-ssl false` 필요. 스크립트는 Linux 기준 — CLI 는 **git bash** 사용(PowerShell 비권장).

---

## 2. 4-Layer 아키텍처 + 의존 방향 (절대 준수)

```
Layer 4  apps/web              ← 메인 App (진입점, MDI 조립, Router)
Layer 3  features/{domain}     ← 도메인 비즈니스 로직 (demand/supply/factory/shipping/admin ...)
Layer 2  packages/shared       ← 공유 로직 (components/hooks/lib/stores)
Layer 1  packages/foundation   ← 기반 (apis/assets/constants/lib/models/styles/utils)
         configs/              ← 공통 설정 (eslint/tsconfig/types)
```

**의존 방향(단방향, 역방향 절대 금지)**: `foundation(1) ← shared(2) ← features(3) ← web(4)`

- ❌ Layer 1/2 가 Layer 3/4 를 import
- ❌ feature 간 직접 import (`admin → demand` 등) — 조합은 `apps/web` 에서만
- ❌ 하위 레이어가 상위 레이어 자원 참조

> CLAUDE.md §3 원칙 2 + `_tobe/01_file_structure.md` 와 동일 — 본 hook 은 공식 설계서 출처로 이를 재확인.

---

## 3. Import 규율 (인수인계서 §4-2 — PR 차단)

1. **Deep Import 금지** — 트리셰이킹 방해 + 빌드 성능 저하. Layer 1/2 import 는 **항상 2-depth** 로 끝나도록 `index.ts` 를 통해 export.
   - ✅ `import { MainTitle } from '@shared/components'`
   - ❌ `import { MainTitle } from '@shared/components/organisms/MainTitle/MainTitle'`
2. **Relative Import 금지** (패키지 사이) — 패키지 독립성 파괴 + 성능 저하. **Path Alias** 2-depth import 만 허용.
   - ✅ `@foundation/utils`, `@shared/hooks`, `@admin/...`
   - ❌ `../../../packages/shared/...`
3. 동일 패키지 **내부**의 상대 import 는 ESLint 정렬 규칙(#relative-import-order) 준수.

---

## 4. 소프트웨어 설계 3원칙 (설계서 §2.3)

| 원칙 | 의미 | 적용 |
|---|---|---|
| **YAGNI** | 미래 예측 기능 금지 | 현재 요구에 없는 추상화/store/컴포넌트 확장 금지 (코드베이스 비대화 방지) |
| **SoC** | 관심사 분리 | 컴포넌트=표시만 / 비즈니스 로직=Custom Hook / 전역상태(Zustand)와 서버데이터(React Query) 분리 |
| **SSOT** | 단일 진실 공급원 | 동일 데이터 전역+로컬 중복 저장 금지 / 백엔드 인터페이스는 `procedure.d.ts` 한 곳에서 정의 (→ #procedure-dts-ssot) |

> 단, YAGNI 는 **anti-simplification 룰을 약화시키지 않는다**. "모두/전체/정밀" 요청 시 다중 패턴+Cross-check 의무는 그대로 유효. YAGNI 는 미사용 추상화를 금지할 뿐, 요구된 분석/구현의 단순화를 정당화하지 않는다.

---

## 5. PRE-WRITE 체크리스트 (화면 작성 직전)

- [ ] 작성 위치의 Layer 가 의존 방향을 위반하지 않는가? (역방향 import 0)
- [ ] feature 간 직접 import 0 인가?
- [ ] Layer 1/2 import 가 2-depth alias 인가? (deep import / relative import 0)
- [ ] 서버 데이터를 store 에 담지 않고 React Query 로만 보유하는가? (SSOT)
- [ ] 전역상태(Zustand) ↔ 서버상태(React Query) 가 분리되어 있는가? (SoC)
- [ ] 현재 요구에 없는 store/prop/추상화를 추가하지 않았는가? (YAGNI)
- [ ] 기술 스택 표(§1) 외 라이브러리를 임의 도입하지 않았는가?

## 6. POST-WRITE grep (작성 직후 — 0 hit 의무)

```bash
# deep import (3-depth 이상 alias)
grep -rEn "from '@(foundation|shared)/[^']+/[^']+/" features/ packages/   # 0
# relative cross-package import
grep -rEn "from '\.\./\.\./\.\./" features/                               # 0 (패키지 경계 넘는 상대경로)
# fetch/axios 직접
grep -rEn "\b(fetch|axios)\(" features/                                   # 0 (apiClient 경유)
# feature 간 직접 import (예: admin 화면이 demand 직접)
grep -rEn "from '@demand/" features/admin/                                # 0
```

## 7. 안티패턴

| ❌ | ✅ |
|---|---|
| `import x from '@shared/components/organisms/X/X'` (deep) | `import { X } from '@shared/components'` |
| `import { y } from '../../../packages/foundation/utils'` | `import { y } from '@foundation/utils'` |
| store 에 조회 결과 `data` 저장 | store 는 `searchParams`/UI 상태만, data 는 useTabProcQuery |
| `features/admin` 가 `features/demand` 직접 import | `apps/web` 에서 조합 |
| "나중에 쓸 수도" 미사용 generic store/prop | YAGNI — 제거 |
| 새 상태관리/HTTP 라이브러리 임의 추가 | §1 고정 스택 |

---

## 8. Cross-ref (본 hook 이 묶는 화면/인프라 hook)

- 아키텍처 상세: `_tobe/01_file_structure.md` / `_tobe/02_imports.md` / CLAUDE.md §3·§4
- MDI 격리: `mdi-tab-isolation-mandatory.md`
- 타입 SSOT: `procedure-dts-ssot-mandatory.md`
- 컴포넌트 계층: `atomic-design-components.md`
- BE 호출 계약: `be-api-contract-ui.md`
- Page/Form/Store 인프라: `screen-shell-composition-mandatory.md` (#61)
- import 정렬: `relative-import-order.md` (#42) / `react-query-foundation-reexport.md` (#40)

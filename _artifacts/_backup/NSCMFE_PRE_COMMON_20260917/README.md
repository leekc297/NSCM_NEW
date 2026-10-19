# 공통소스 다운로드 적용 보고 — 2026-09-17

| 항목 | 값 |
|---|---|
| 원천 | `eunjoo-hwang/nscm-fe.git` (remote `common`, push=`no_push` 유지) |
| 직전 기준선 | `d3cd9e4a` (2026-09-16 16:15) |
| **신규 기준선** | **`410bd38b` (2026-09-17 09:37 "Update ForecastPrice.tsx")** |
| fetch 유형 | fast-forward (`d3cd9e4a..410bd38b`) — force-push 아님 |
| 범위 | `apps` · `features` · `packages` · `public` 4폴더 |
| 변경 파일 | 35 (M 19 / A 16) · 공통 커밋 16건 |
| 정적검증 | **미수행** (사용자 상시 지시 2026-09-02 — 요청 시 `fe-check.ps1`) |

## 1. 분류

| 분류 | 건수 | 처리 |
|---|---:|---|
| 공통 채택 (로컬 = 직전기준선) | 18 | 공통본 그대로 덮어쓰기 |
| 이미 동일 | 1 | 무처리 (`production-plan-line/index.ts`) |
| 3-way 병합 (로컬 편집본) | **0** | — |
| 신규 파일 | 9 | 추가 |
| **로컬 구버전 초안 교체** | **7** | 공통본 채택 (§3) |

3-way 병합 0건 = 직전 회차(09-16 2차) 이후 로컬에서 대상 18파일을 편집하지 않았다.

## 2. 공통 채택 18건 (로컬 = 직전 기준선, 무손실)

```
apps/web/src/core/Providers.tsx
features/admin/src/pages/dynamic-query/DynamicQuery.tsx
features/admin/src/pages/mail-setup/MailSetup.tsx
features/admin/src/pages/mail-setup/components/MailReceiverPanel.tsx
features/admin/src/pages/sms-setup/SmsSetup.tsx
features/admin/src/pages/sms-setup/components/SmsReceiverPanel.tsx
features/admin/src/pages/ui-catrgory-setup/UICategorySetup.tsx
features/demand/src/pages/demand-manager/utils/demand-manager.merge.ts
features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx
features/demand/src/pages/forecast-price/ForecastPrice.tsx
features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx
features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx
features/demand/src/pages/metal-link-price/components/modals/metalLinkVersionModalStore.ts
features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx
features/demand/src/pages/mkt-fcst/utils/mkt-fcst.division.ts
features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts
packages/foundation/src/utils/columnMapping.ts
packages/shared/src/components/organisms/search-area/SearchArea.tsx
```

주요 반영 내용(공통 커밋 기준): SYS0017 Mail Setup 수신자 그리드 더블클릭 즉시삭제 제거 · 세션만료(8h/401) MSG01146 유도 · SearchArea F5=조회 공통 단축키 · Metal Link Price 검색조건 연결 · Dynamic Query 파라미터 추가 · demand manager 상태바 병합 해제 · mkt fcst 버그수정.

## 3. ⭐ 로컬 구버전 초안 교체 7건 — SCP0013 Production Plan Line

공통이 `242981c8`(09-16 17:51 "spc0013 전환 테스트")로 **화면 전체를 신규 구현**했고,
로컬에는 `git` 미추적(`??`) 상태의 **구버전 초안**(07-13 ~ 08-13 작성)이 있었다.

| 판정 근거 | 내용 |
|---|---|
| 로컬본 출처 | 공통 이력 **어디에도 없음** (`git log --all` 0건) · GitLab origin 미추적 → 독립 로컬 초안 |
| 로컬본 최신성 | **아님** — 07-13~08-13 vs 공통 09-16 |
| 로컬본 배선 | **미배선** — `apps/web` 에서 참조 0건 (Router 등록 없음) |
| 완전성 | 공통이 상위 — Grid 89→212행 · constants 105→197행 · `utils/`(4) · `hooks/`(1) · `components/modals/`(1) · 테스트 2본 · `__asis-mapping__.md` 포함 |

→ 규칙("내 것이 더 최신이면 내걸로")의 **최신·완전 조건을 로컬이 충족하지 못해** 공통본 채택.
로컬 원본 7파일은 `local_before/` 에 보존 — 필요 시 그대로 원복 가능.

교체 대상:
```
features/supply/src/pages/production-plan-line/ProductionPlanLine.tsx
features/supply/src/pages/production-plan-line/ProductionPlanLine.module.scss
features/supply/src/pages/production-plan-line/production-plan-line.constants.ts
features/supply/src/pages/production-plan-line/production-plan-line.types.ts
features/supply/src/pages/production-plan-line/useProductionPlanLineStore.ts
features/supply/src/pages/production-plan-line/components/ProductionPlanLineForm.tsx
features/supply/src/pages/production-plan-line/components/ProductionPlanLineGrid.tsx
```

### 잔재 1건 (삭제하지 않음)
`components/ProductionPlanLineForm.module.scss` — 로컬 초안 산물이며 공통에는 없다.
채택본 `ProductionPlanLineForm.tsx` 는 `@foundation/styles/common-styles.module.scss` 를 쓰므로
**참조하는 파일이 0건인 고아 파일**이다. 빌드에 영향 없어 보존했다(삭제는 사용자 판단).

## 4. 신규 파일 9건

```
features/admin/src/pages/ui-catrgory-setup/useUICategorySetupSave.ts
features/supply/src/pages/production-plan-line/__asis-mapping__.md
features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx
features/supply/src/pages/production-plan-line/hooks/useProductionPlanLineValidation.ts
features/supply/src/pages/production-plan-line/utils/productionPlanLineColumns.ts
features/supply/src/pages/production-plan-line/utils/productionPlanLineDerive.ts
features/supply/src/pages/production-plan-line/utils/productionPlanLineDerive.test.ts
features/supply/src/pages/production-plan-line/utils/productionPlanLineEditLock.ts
features/supply/src/pages/production-plan-line/utils/productionPlanLineEditLock.test.ts
```

## 5. ⚠️ 미해소 — `procedures.d.ts` 키 불일치 (SCP0013)

채택한 공통 코드가 요구하는 `ProcedureMap` 키와 로컬 `configs/types/procedures.d.ts` 선언이 어긋난다.

| 항목 | 값 |
|---|---|
| 공통 코드가 요구 | `SCP0013.main` · `SCP0013.load` |
| 로컬 d.ts 선언 | `SCP0013.Line` **뿐** (83행 블록, 구버전 초안 기준) |
| 공통 d.ts | `SCP0013` **0건** — 공통 저장소가 이 화면의 d.ts 를 갖고 있지 않아 발췌할 원본이 없다 |

호출 지점:
```
ProductionPlanLine.tsx:55   useTabProcQuery<MENU_ID, SHEETS.MAIN>   (SHEETS.MAIN = 'main')
ProductionPlanLine.tsx:62   useProcMutation<MENU_ID, SHEETS.MAIN>
components/modals/ProductionPlanLineLoadModal.tsx:44  useTabProcQuery<MENU_ID, SHEETS.LOAD>  (= 'load')
```

`configs/` 는 다운로드 범위(4폴더) 밖이고, 공통에 원본이 없어 **임의 작성하지 않고 남겨두었다**.
SCP0013 를 실제로 쓰기 전에 아래 중 하나를 사용자 결정으로 처리해야 한다.

1. 로컬 d.ts `SCP0013` 블록을 `main` / `load` 키 체계로 개정 (권위 원천 = AS-IS SP `SCP0013_GET_PRODUCTION_PLAN_LINEBY` + 공통 코드 실사용 필드)
2. 7파일을 `local_before/` 초안으로 원복 (`Line` 키 체계 유지)

> 참고: SCP0013 는 `SCM_ADM_MNU_BTN_MPG_M` 0행(버튼-API 미배선)이라 현재 실행 체인 자체가 미배선 상태다 — 공통 `production-plan-line.constants.ts` 주석 실측.

## 6. 무결성 점검

| 점검 | 결과 |
|---|---|
| 대상 35파일 공통본 바이트 일치 (개행 정규화) | **35/35** |
| 충돌 마커 | **0** |
| 값 import 중복 | **0** |
| 신규파일 상대 import 해소 | **0 미해소** |
| `procedures.d.ts` 키 정합 | **FAIL 1건 — §5** |

## 7. 범위 밖 (미반영)

- 공통 커밋 `0f945a01` "feat(convert): 오피스 추출을 마크다운 테이블로 + office-to-md 툴 등록" — 4폴더 밖(툴)이라 미반영
- 공통 신규 브랜치 `feat/scm0002-model-popup` — `main` 만 받는 규약이라 미반영

## 8. 원복 자료

- `local_before/` — 적용 직전 로컬 원본 **25파일** (신규 9는 원본 없음 → 삭제로 원복)
- `local_worktree.patch` (2.6MB) / `local_git_head.txt` / `local_git_status.txt` (505행)
- `adopted_files.txt` — 기록한 34파일 목록

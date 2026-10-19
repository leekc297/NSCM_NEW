# 공통소스 다운로드 적용 보고 — 2026-09-21

| 항목 | 값 |
|---|---|
| 원천 | `eunjoo-hwang/nscm-fe.git` (remote `common`, push=`no_push` 유지) |
| 직전 기준선 | `a53fe246` (2026-09-17 13:24) |
| **신규 기준선** | **`03dfab78` (2026-09-21 "Merge branch 'main'")** |
| fetch 유형 | fast-forward (`a53fe246..03dfab78`) — force-push 아님 |
| 범위 | `apps` · `features` · `packages` · `public` 4폴더 |
| 변경 파일 | **80** (M 77 / A 3) · 공통 커밋 90건 |
| 정적검증 | **미수행** (사용자 상시 지시 2026-09-02 — 요청 시 `fe-check.ps1`) |

## 1. 분류

| 분류 | 건수 | 처리 |
|---|---:|---|
| 공통 채택 | **74** | 공통본 그대로 덮어쓰기 |
| 이미 동일 | 0 | — |
| **3-way 병합 (로컬 편집본)** | **3** | base=실제 출발 판본, 자동병합 충돌 0 |
| 신규 파일 | **3** | 추가 |

전체 목록 = `adopted_files.txt`

## 2. 3-way 병합 3건 (로컬 편집 보존 + 공통 개선 수용)

| 파일 | base(실제 출발 판본) | 로컬 편집분 | 공통 변경분 | 충돌 |
|---|---|---|---|---:|
| `features/demand/.../forecast-price/components/ForecastPriceGrid.tsx` | `6f79b297`(09-16) | `comboParamExcludes={['CELL_PROD_SITE_ID']}` (E20260901-CPSDISP 표시/편집 콤보 이원화) | forecastprice 수정 | 0 |
| `packages/foundation/src/utils/gridAction.ts` | `fee489eb`(09-15) | `groupedHeaderExcelDownload` 2단 병합 헤더 양식 (룰 #136/#137 회차) | `996e4104` insert 앵커 pin 추적 공통화 (`chaseInsertPinAnchor`) | 0 |
| `packages/shared/.../column-layout-modal/ColumnLayoutModal.tsx` | `655b05e8`(09-08) | 관리자 폭 0 컬럼 목록 은닉(`toZeroWidthColumnSet`) + MSG 하드코딩 | `1acaefc3` 컬럼셋팅팝업 고정컬럼 기준변경 | 0 |

> base 탐색 = 공통 이력 전 판본과 로컬의 변경량 최소본 (메모리 룰 2026-09-15). 3건 모두 직전 기준선 blob 과 동일했다.

## 3. 신규 파일 3건

```
features/supply/src/pages/production-plan-line/components/modals/ProductionPlanFixReasonModal.tsx
packages/shared/src/components/molecules/periodRangePicker/PeriodRangePicker.module.scss
packages/shared/src/components/molecules/periodRangePicker/PeriodRangePicker.tsx
```

공통 커밋 `c409c525`(period range 초안) · `8e17fc12`(scp0013 소스 재생성) 반영분.

## 4. ⭐ 로컬 편집본 재판정 1건 — `__asis-mapping__.md`

`features/demand/src/pages/cust-fcst-waterfall/__asis-mapping__.md` 는 1차 분류에서 EDITED 로 잡혔으나,
공통 이력본 `8393f5bb`(2026-09-01 "fix: 이규철이사 소스반영 35 53 40" = **역수입 커밋**)과 **바이트 완전 일치**(diff 0행)였다.
메모리 룰("공통소스의 어떤 이력본과도 일치하지 않을 때만 내 편집본") 적용 → 내 편집본 아님 → **공통 채택**.

## 5. 무결성 점검

| 점검 | 결과 |
|---|---|
| 공통 채택/신규 77파일 바이트 일치(개행 정규화) | **77/77** |
| 충돌 마커 | **0** |
| 3-way 병합본 최상위 선언 중복 | **0** (3/3) |
| 3-way 병합본 import 식별자 중복 | **0** (3/3) |
| 신규파일 상대 import 미해소 | **0** |
| 신규파일 외부 alias | `@shared` · `@mui` 만 — Feature 간 직접 import **0** |

## 6. ⚠️ 미해소 1건 (이월) — SCP0013 `procedures.d.ts` 시트 키

| 항목 | 값 |
|---|---|
| 공통 코드 요구 키 | `SCP0013.main` · `SCP0013.load` (`production-plan-line.constants.ts` SHEETS enum) |
| 로컬 d.ts 보유 키 | `SCP0013.Line` 만 |
| 공통 d.ts 내 SCP0013 | **0건** (공통 최상위 SCP 키 = SCP0005 / SCP0007 / SCP0022) |
| 조치 | 발췌 원본이 없어 **임의 작성하지 않음** — 09-17 1차부터 이월, 사용자 결정 대기 |

## 7. 범위 밖 (미반영)

공통 커밋 90건 중 4폴더 밖은 받지 않았다.

- `configs/types/procedures.d.ts` — 공통이 **SCP0007 블록 46행 추가**(`countryCity` / `routeCnt`).
  이번 적용 4폴더 파일 중 SCP0007 참조 **0건** → 동반 삽입 불필요로 판정(미반영).
- roslyn 분석기 / convert-* 문서·툴 / atlas / analyze_menu 설계문서 / CLAUDE.md / skill·가이드 문서 / figma 주석 삭제 등

## 8. 원복 자료

- `local_before/` — 적용 직전 로컬 원본 **77파일** (신규 3은 원본 없음 → 삭제로 원복)
- `local_worktree.patch` (56,072행) / `local_git_head.txt` / `local_git_status.txt`
- `adopted_files.txt` — 80파일 분류표

# 공통소스 다운로드 적용 보고 — 2026-09-16 (2차)

| 항목 | 값 |
|---|---|
| 원천 | `eunjoo-hwang/nscm-fe.git` (remote `common`, push=`no_push`) |
| 직전 기준선 | `cb0ee783` (2026-09-16 09:19) — 같은 날 1차 다운로드분 |
| **신규 기준선** | **`d3cd9e4a` (2026-09-16 16:15 "fix: 셀 값 원복시 M남는버그 수정 mkt fcst")** |
| 범위 | `apps` · `features` · `packages` · `public` 4폴더 |
| 변경 파일 | 44 (M 43 / A 1) · 공통 커밋 22건 |
| 정적검증 | **미수행** (사용자 상시 지시 2026-09-02 — 요청 시 `fe-check.ps1`) |

## 1. 분류

| 분류 | 건수 | 처리 |
|---|---:|---|
| 공통 채택 (로컬=직전기준선) | 42 | 공통본 그대로 덮어쓰기 |
| 이미 동일 | 0 | — |
| 3-way 병합 (로컬 편집본) | 1 | 자동 병합 (충돌 0) |
| 신규 파일 | 1 | 추가 |

## 2. 3-way 병합 1건

| 파일 | base | 결과 |
|---|---|---|
| `features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx` | `c2210452` (09-15 15:49, 후보 16개 중 변경량 최소=6) | 자동 병합 · 충돌 0 |

공통은 오늘 이 파일을 `88e5577e`(12:21) · `6f79b297`(14:33) 로 두 번 더 고쳤고, 로컬은 1차 다운로드 때 같은 base 로 병합한 상태였다.
규칙대로 **직전 기준선이 아니라 '로컬이 실제 출발한 공통 판본'**(변경량 최소)을 base 로 잡았다.

## 3. 신규 파일 1

- `features/master/src/pages/sales-site-project-model/sales-site-project-model.salesCompanyGuard.ts`
  → `SalesSiteProjectModelGrid.tsx` · `SalesSiteProjectModelPurchaseGrid.tsx` 가 `useSalesCompanyGuard` 를 import — 참조 해소 확인.

## 4. 무결성 점검

| 점검 | 결과 |
|---|---|
| 대상 44파일 충돌 마커 | **0** |
| 병합 유래 선언 중복(merged > max(local, common)) | **0** |
| import 중복 | `react` 1건 검출 → **오탐**. `import type { MutableRefObject }` + `import { useEffect, … }` 로 로컬·공통 모두 동일한 기존 패턴 |
| 신규 파일 import 해소 | OK |
| 개행 정규화 후 대조 (CRLF/LF 혼재) | 적용 |

## 5. 범위 밖 (미반영)

- `nscm-fe/docs/낙서장.md` — 4폴더 밖이라 받지 않았다(메모 성격 문서).

## 6. 원복 자료

- `local_before/` — 대상 43파일의 **적용 직전 로컬 원본** (신규 1은 원본 없음 → 삭제로 원복)
- `local_worktree.patch` / `local_git_head.txt` / `local_git_status.txt`
- `adopted_files.txt` — 공통 채택 42건 목록

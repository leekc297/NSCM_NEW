# 공통소스 다운로드 & 병합 회차 보고 — 2026-10-23 17:17

- 원천: remote `common` (https://gyucheollee297@github.com/eunjoo-hwang/nscm-fe.git) · push URL `no_push` 확인 — 푸시 없음
- 기준선 `965d11de5` → **신규 기준선 `decb32c81`** (decb32c81 2026-10-23 16:54 eunjoo_hwang fix(SSP0026): Shipment Date 달력 선택 후 표시 형식 yyyy-MM-dd 로 통일)
- 공통 신규 커밋 420건 · 대상(apps·features·packages·public·configs) 변경 652건 (이름변경은 삭제+신규로 풀어 집계)
- 판정 = 내용 대조(개행·BOM 정규화) · 로컬이 공통 이력본과 일치하면 공통 채택, 내 편집본이면 유지/3-way(base = 로컬이 실제 출발한 공통 판본)

## 분류·처리 결과

| 구분 | 건수 | 처리 |
|---|---:|---|
| 수정(M) — 로컬 = 공통 이력본(무편집) | 497 | 공통 원문 적용 |
| 신규(A) — 로컬 부재 | 77 | 공통 원문 적용 |
| 삭제(D) — 로컬 = 공통 이력본 | 46 | 삭제 |
| 동일 | 19 | 변경 없음 |
| 로컬 부재 — 공통 수정 파일(결정 대기) | 9 | 로컬 유지 |
| 3-way 병합 — 충돌 0 | 3 | 병합본 적용 |
| d.ts 구조 병합 | 1 | 병합본 적용 |

적용 폴더별: supply 285 / shipping 162 / demand 59 / master 40 / admin 11 / shared 10 / apps 3 / report 2 / spms-demand 2 / foundation 2 / configs 1 / authority 1

## ⚠️ 결정 대기 9건 (로컬 유지 상태 — 자동 적용 안 함)

| 파일 | 사유 | 비고 | 자료 |
|---|---|---|---|
| `features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx` | 로컬 부재 — 공통 수정 파일(결정 대기) |  |  |
| `features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailBar.module.scss` | 로컬 부재 — 공통 수정 파일(결정 대기) |  |  |
| `features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailBar.tsx` | 로컬 부재 — 공통 수정 파일(결정 대기) |  |  |
| `features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx` | 로컬 부재 — 공통 수정 파일(결정 대기) |  |  |
| `features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx` | 로컬 부재 — 공통 수정 파일(결정 대기) |  |  |
| `features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx` | 로컬 부재 — 공통 수정 파일(결정 대기) |  |  |
| `features/shipping/src/pages/shipment-plan-mobility-it/shipment-plan-mobility-it.constants.ts` | 로컬 부재 — 공통 수정 파일(결정 대기) |  |  |
| `features/shipping/src/pages/shipment-plan-mobility-it/useShipmentPlanMobilityItStore.ts` | 로컬 부재 — 공통 수정 파일(결정 대기) |  |  |
| `features/shipping/src/pages/shipment-plan-mobility-it/utils/shipment-plan-mobility-it.save.ts` | 로컬 부재 — 공통 수정 파일(결정 대기) |  |  |

## `procedures.d.ts` 병합 (RawProcedureMap 메뉴 키 블록 단위)

| 처리 | 메뉴 키 |
|---|---|
| 동일 (90) | — |
| 공통 채택 — 로컬 = 기준선 (4) | `SSP0026` · `SCP0023` · `SCP0123` · `SSP0060` |
| 로컬 유지 — 공통 무변경·내 편집 (10) | `DMF0035` · `DMF0082` · `SYS0016` · `SCM0002` · `DMF0049` · `DMF0044` · `SYS0017` · `SDM1010` · `SDM1020` · `SDM5010` |
| 공통 신규 추가 (2) | `SCP0134` · `SCP0132` |
| 로컬 전용 유지 (3) | `SCP0013` · `DMF0013` · `DMF0068` |

검사: 멤버 수(로컬→병합) 105 → 107 / 중복 키 0 / declare global 1 / 로컬 키 유실 [] / 공통 키 유실 []

## 병합 적용

| 파일 | 구분 | 비고 |
|---|---|---|
| `features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx` | 3-way 병합 — 충돌 0 | base 기준선 |
| `packages/foundation/src/utils/gridAction.ts` | 3-way 병합 — 충돌 0 | base 기준선 |
| `packages/shared/src/hooks/index.ts` | 3-way 병합 — 충돌 0 | base 기준선 |

## 삭제 46건

- `features/demand/src/pages/dmf0045/ShipmentRequest.module.scss`
- `features/demand/src/pages/dmf0045/ShipmentRequest.tsx`
- `features/demand/src/pages/dmf0045/__asis-mapping__.md`
- `features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx`
- `features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx`
- `features/demand/src/pages/dmf0045/components/ShipmentRequestModals.tsx`
- `features/demand/src/pages/dmf0045/components/modals/BodItemRouteModal.module.scss`
- `features/demand/src/pages/dmf0045/components/modals/BodItemRouteModal.tsx`
- `features/demand/src/pages/dmf0045/dmf0045.constants.ts`
- `features/demand/src/pages/dmf0045/dmf0045.types.ts`
- `features/demand/src/pages/dmf0045/index.ts`
- `features/demand/src/pages/dmf0045/useShipmentRequestStore.ts`
- `features/demand/src/pages/dmf0045/utils/dmf0045.api.ts`
- `features/demand/src/pages/dmf0045/utils/dmf0045.bohFrontFill.ts`
- `features/demand/src/pages/dmf0045/utils/dmf0045.division.ts`
- `features/demand/src/pages/dmf0045/utils/dmf0045.editLock.ts`
- `features/demand/src/pages/dmf0045/utils/dmf0045.gridCombos.ts`
- `features/demand/src/pages/dmf0045/utils/dmf0045.merge.ts`
- `features/demand/src/pages/dmf0045/utils/dmf0045.recalc.ts`
- `features/demand/src/pages/dmf0045/utils/dmf0045.save.ts`
- `features/demand/src/pages/dmf0045/utils/dmf0045.searchCombos.ts`
- `features/demand/src/pages/dmf0045/utils/dmf0045.validate.ts`
- `features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.module.scss`
- `features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.tsx`
- `features/shipping/src/pages/shipment-master-electrode/components/modals/ItemByDivisionModal.module.scss`
- `features/shipping/src/pages/shipment-master-electrode/components/modals/ItemByDivisionModal.tsx`
- `features/shipping/src/pages/shipment-plan-auto-ess/components/modals/MeasureSelectModal.module.scss`
- `features/shipping/src/pages/shipment-plan-auto-ess/components/modals/MeasureSelectModal.tsx`
- `features/shipping/src/pages/shipment-plan-auto-ess/components/modals/OrderDetailModal.tsx`
- `features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/DrilldownModal.module.scss`
- `features/shipping/src/pages/shipment-plan-electrode/components/RequestorModal.tsx`
- `features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx`
- `features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.module.scss`
- `features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx`
- `features/shipping/src/pages/shipment-plan/components/modals/OrderDetailModal.tsx`
- `features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.module.scss`
- `features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx`
- `features/supply/src/pages/capa-line-assign/components/CapaLineAssignForm.module.scss`
- `features/supply/src/pages/plan-management/components/EngineToolbar.tsx`
- `features/supply/src/pages/plan-management/utils/planManagementEngine.test.ts`
- `features/supply/src/pages/plan-management/utils/planManagementEngine.ts`
- `features/supply/src/pages/plan-management/utils/planManagementLock.test.ts`
- `features/supply/src/pages/plan-management/utils/planManagementLock.ts`
- `features/supply/src/pages/plan-management/utils/planManagementMerge.ts`
- `public/locales/EN.json`
- `public/locales/KO.json`

삭제 파일을 가리키는 import 후보: 
- `features/demand/src/pages/dmf0045/ShipmentRequest.tsx` ← features/demand/src/pages/shipment-request/index.ts
- `features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx` ← features/demand/src/pages/shipment-request/ShipmentRequest.tsx
- `features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx` ← features/demand/src/pages/shipment-request/ShipmentRequest.tsx
- `features/demand/src/pages/dmf0045/components/ShipmentRequestModals.tsx` ← features/demand/src/pages/shipment-request/ShipmentRequest.tsx, features/demand/src/pages/shipment-request/components/ShipmentRequestGrid.tsx
- `features/demand/src/pages/dmf0045/useShipmentRequestStore.ts` ← features/demand/src/pages/shipment-request/ShipmentRequest.tsx, features/demand/src/pages/shipment-request/components/ShipmentRequestForm.tsx, features/demand/src/pages/shipment-request/components/ShipmentRequestModals.tsx
- `features/demand/src/pages/dmf0045/ShipmentRequest.module.scss` ← features/demand/src/pages/shipment-request/components/ShipmentRequestGrid.tsx
- `features/demand/src/pages/dmf0045/components/modals/BodItemRouteModal.tsx` ← features/demand/src/pages/shipment-request/components/ShipmentRequestModals.tsx, features/shipping/src/pages/shipment-request-semi/ShipmentRequestSemi.tsx
- `features/demand/src/pages/dmf0045/components/modals/BodItemRouteModal.module.scss` ← features/demand/src/pages/shipment-request/components/modals/BodItemRouteModal.tsx, features/shipping/src/pages/shipment-request-semi/components/modals/BodItemRouteModal.tsx
- `features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.tsx` ← features/master/src/components/index.ts, features/master/src/components/searchFields/SearchFields.tsx
- `features/shipping/src/pages/shipment-master-electrode/components/modals/ItemByDivisionModal.tsx` ← features/master/src/components/index.ts, features/master/src/components/searchFields/SearchFields.tsx
- `features/shipping/src/pages/shipment-plan-auto-ess/components/modals/MeasureSelectModal.tsx` ← features/master/src/components/index.ts
- `features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx` ← features/master/src/components/index.ts
- `features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx` ← features/master/src/components/index.ts, features/master/src/components/searchFields/SearchFields.tsx
- `features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.module.scss` ← features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx
- `features/shipping/src/pages/shipment-master-electrode/components/modals/ItemByDivisionModal.module.scss` ← features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx
- `features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.module.scss` ← features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx
- `features/shipping/src/pages/shipment-plan-auto-ess/components/modals/MeasureSelectModal.module.scss` ← features/master/src/components/measureSelectModal/MeasureSelectModal.tsx
- `features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.module.scss` ← features/master/src/components/measureSelectModal/MeasureSelectModal.tsx
- `features/shipping/src/pages/shipment-plan-auto-ess/components/modals/OrderDetailModal.tsx` ← features/shipping/src/components/index.ts, features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx, features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx, features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx
- `features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx` ← features/shipping/src/components/index.ts
- `features/shipping/src/pages/shipment-plan/components/modals/OrderDetailModal.tsx` ← features/shipping/src/components/index.ts, features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx, features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx, features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx

## 원복 자료
- `local_before/` — 덮어쓰거나 삭제한 로컬 원본
- `worktree_tracked.patch` — 적용 직전 nscm-fe 추적파일 전체 diff
- `git_status_before.txt` — 적용 직전 워킹트리 상태
- `conflicts/` — 결정 대기 파일의 base · common · merged(충돌 마커 포함) 사본

## 검증
- 공통 원문 적용 574건 — 개행 정규화 후 공통 원문과 불일치 0건
- 적용 파일 충돌 마커 잔존 0건
- 삭제 46건 — 잔존 0
- procedures.d.ts `declare global` 1건(기대 1)
- 정적검증(type-check/lint) **미수행** — 사용자 지시(요청 시만). 공통 신규 소스 ↔ 내 화면 소스 타입 불일치는 type-check 로 확인 필요

## 결정 대기 9건 처리 — 2026-10-23 (사용자 지시: 로컬 유지 없이 공통소스 다운분 적용)
- 대상: `features/shipping/src/pages/shipment-plan-mobility-it/` (SSP0015) — 로컬에 폴더 자체가 없었음(덮어쓴 로컬 원본 없음 → 백업 대상 없음)
- 처리: 기준선 `decb32c81` 의 폴더 전체 **20개 파일**을 공통 원문으로 적용 (결정 대기 9건 + 같은 폴더 무변경 11건 — 9건만 넣으면 index.ts·types·utils import 누락)
- 검증: 공통 원문 바이트 일치 20/20 · 충돌 마커 0
- 원복: 폴더 삭제 (`features/shipping/src/pages/shipment-plan-mobility-it/`)

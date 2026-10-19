# 공통소스 다운로드 회차 보고 — 2026-10-01

- 원천: `https://github.com/eunjoo-hwang/nscm-fe.git` (remote `common`, push URL = `no_push` 유지 — 푸시 없음)
- 기준선: `886146083` (09-28 적용분) → **신규 기준선 `2dc843467`**
  (2026-09-30 21:45 Jungwon Ha "fix(SCP0028): Input/Delete 팝업·저장 AS-IS 파리티 — SP 실측 기반 교정")
- `886146083` 는 `2dc843467` 의 조상 — 이번 회차 force-push 재작성 없음
- 공통 신규 커밋 134건 / 전체 변경 756파일 중 **4폴더(apps·features·packages·public) + configs 대상 409건**
  (M 382 / A 25 / D 2) — 나머지는 4폴더 밖(`.atlas`·`Doc` 등) → 미반영

## 분류·처리 결과

| 구분 | 건수 | 처리 |
|---|---:|---|
| 수정(M) — 로컬 = 기준선(무편집) | 378 | 공통 채택 (supply 228 / shipping 113 / demand 14 / master 10 / packages 10 / locales EN·KO 2 / apps 1) |
| 신규(A) — 로컬 부재 | 25 | 공통 원문 신규 적용 (로컬 기존 파일 충돌 0) |
| 삭제(D) — 로컬 = 기준선 | 2 | `features/supply/src/pages/bod-item/components/modals/ItemByDivisionModal.{tsx,module.scss}` 삭제 — 화면 내 참조 0 확인(공통이 `features/master` 공용 모달로 전환) |
| 수정(M) — 3-way | 3 | 아래 (충돌 0) |
| 수정(M) — d.ts 구조 병합 | 1 | `configs/types/procedures.d.ts` — 아래 |

### 신규 화면
- shipping `shipment-working-day` (**SSP0005**, 11본) — `apps` 라우팅 미배선(공통 HEAD 도 미배선 = 동일)
- 그 외 신규 = 유틸/테스트/스타일 (forecast-price.cellProdSites · mkt-fcst.recalc.test · distribution-route.excelForm ·
  shipmentModelPicUserLookup · shipment-plan-mobility-it.merge · constraintMgmt.restore.test · formation/__asis-mapping__ ·
  IntegrationPsiForm.module.scss · foundation numberInputRule(+test)·input-selection.scss · shared customDropdown/filterBySearch(+test))

### 3-way (base = 로컬이 실제 출발한 공통 판본 — 이력 전수 중 로컬과 변경량 최소)
| 파일 | base | 결과 | 병합본에 남은 내 편집 |
|---|---|---|---|
| `features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx` | `2ea54cbc2` (09-18) | 충돌 0 | `comboParamExcludes={['CELL_PROD_SITE_ID']}` (E20260901-CPSDISP) |
| `features/demand/src/pages/forecast-price/forecast-price.constants.ts` | `aa46b5871` (09-28) | 충돌 0 | 주석만 (E20260923-XLSUPHDR) — 배열 값 공통과 동일 |
| `packages/foundation/src/utils/gridAction.ts` | `936315877` (09-22) | 충돌 0 | `groupedHeaderExcelDownload` 메서드 (선언 1회·wijmo import 전부 존재) |

### `procedures.d.ts` 병합 (RawProcedureMap 메뉴 키 블록 단위)
| 처리 | 메뉴 키 |
|---|---|
| 공통 신규 추가 (6) | `SCP0055` · `SSP0005` · `SSP0014` · `SSP0017` · `SSP0022` · `SSP0026` |
| 공통 채택 — 로컬 = 기준선 (4) | `SCP0125` · `SSP0015` · `SSP0021` · `SSP0060` |
| 3-way / 충돌 | 0 |

결과: 멤버 93 → 99 / 중복 키 0 / 블록 원문 일치 검사 불일치 0 / 로컬 키 유실 0 / 인터페이스 밖 로컬 편집(tail) 보존.

## ⚠️ 미해소
1. **신규 화면 d.ts 키 부재** — 직전 회차 39건 중 5건(`SSP0014/0017/0022/0026`, `SCP0055`) 이번 공통으로 해소,
   **34건 여전히 공통 원본에도 없음** → 임의 작성 안 함(결정 대기 유지).
2. **`comboParamExcludes` prop 고아 (이번 회차 원인 아님)** — `ForecastPriceGrid.tsx` 가 `DataGrid` 에 넘기는
   `comboParamExcludes` 를 `DataGrid.tsx` 가 정의하지 않는다. 09-23B 회차 백업(`NSCMFE_PRE_COMMON_20260923B/local_before/.../DataGrid.tsx`)
   까지는 로컬 DataGrid 에 있었고 그 회차 공통 채택으로 사라진 것으로 추정. 이번 회차 직전 로컬 DataGrid 도 이미 부재(= 기준선, `M_adopt` 분류).
   영향: DMF0082 Cell Prod Site 표시 콤보 축소 → raw 코드 표시 재발 가능 + type-check TS2322 가능. 복원 여부 결정 대기.

## 원복 자료
- `local_before/` — 이번 회차에 덮어쓰거나 삭제한 로컬 원본 384본 (378 + 삭제 2 + 3-way 3 + d.ts 1)
- `worktree_tracked.patch` — 적용 직전 `nscm-fe` 추적파일 전체 diff (63,875행)
- `git_status_before.txt` — 적용 직전 워킹트리 상태 (536행)

## 검증
- 적용 405건(채택 378·신규 25·삭제 2) **공통 원문과 개행 정규화 후 일치 — 불일치 0**, 삭제 잔존 0
- 충돌 마커 잔존 0건
- 정적검증(type-check/lint) 미수행 — 사용자 지시(2026-09-02) 유지

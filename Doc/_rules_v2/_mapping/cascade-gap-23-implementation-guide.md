# cascade 격차 23건 구현 가이드 (Phase 7 B3 후속, 2026-06-04)

> 사용자 결정 결과: cascade 격차 25 건 중 **2 건 즉시 구현 / 23 건 사양 문서**.
> 메타-룰 #4 (사용자 작업물 우선) 적용 — UI 테스트 + 사용자 확인 후 진행 의무.

---

## §0 즉시 구현 완료 (2 건)

| # | 화면 | 격차 | 위치 | sub-pattern |
|---:|---|---|---|---|
| 1 | DMF0006 | CONVERT_QTY_CELL/MODULE/PACK 음수 → 0 보정 | `CustomerModelMappingGrid.tsx` `handleNegativeGuard` (신규) | §2.10.2 변형 (validation 값 보정) |
| 2 | DMF0007 FCST | Measure='CUST_FCST' 차단 + MSG00379 + revert | `CustomerFcstMasterFcstGrid.tsx` `handleActiveChange` 확장 | §2.10.2 (single-value 차단) |

→ UI 테스트 의무 — 사용자 검증.

---

## §1 사양 작성 23 건 (사용자 결정 후 구현)

### §1.1 DMF0004 격차 5건 (Branch 1=즉시 구현 권장 X — modal callback 으로 충분)

| # | 격차 | sub-pattern | AS-IS 위치 | TO-BE 구현 가이드 |
|---:|---|---|---|---|
| 4-1 | Main SiteId 중복 check + MSG00060 + revert | §2.10.2 | L2572~2606 | `SalesSiteGrid.tsx` 의 cellEditEnded 추가 — itemsSource.filter (idx !== row && r.SCM_SITE_ID === newVal).length > 0 → setAlert + revert |
| 4-2 | Main Attribute5 + VMI_YN check (조건부 차단) | §2.10.2 변형 | L2623~2633 | `SalesSiteGrid.tsx` 의 cellEditEnded 확장 — binding === 'ATTRIBUTE5' && dataItem.VMI_YN !== 'Y' → setAlert("VMI Site 만") + revert |
| 4-3 | SubCustomer RepYn 단일 Y 제약 + MSG00149 | §2.10.2 (single Y) | L2375~2392 | `SalesSiteCustomerGrid.tsx` 의 cellEditEnded 추가 — itemsSource.filter (REP_YN === 'Y').length > 1 → setAlert + revert (N) |
| 4-4 | SubCustomer SoldTo+ShipTo+ValidYn='Y' 중복 + 4 column cascade clear | §2.10.2 + §2.10.3 | L2393~2422 | `SalesSiteCustomerGrid.tsx` 의 cellEditEnded — composite key 중복 check + setAlert + 4 column storeChange clear |
| 4-5 | SubBucket D_ 3 필수 입력 + Incoterms 중복 | §2.10.2 + §2.10.4 | L2434~2514 | `SalesSiteBucketGrid.tsx` 의 cellEditEnded 추가 (현재 cellEditEnded 없음) — 8 validation MSG00002 + composite key check |

### §1.2 DMF0005 격차 4건

| # | 격차 | sub-pattern | TO-BE 가이드 |
|---:|---|---|---|
| 5-1 | LIABILITY_PERIOD < 0 revert | (validation) | `SalesSiteProjectModelGrid.tsx` 의 cellEditEnded 추가 — Number(val) < 0 → revert |
| 5-2 | CELL_PER_CAR / MODULE 정수 분할 + MODULE_PER_CAR 자동 계산 + MSG00177 | §2.10.1 (계산) + §2.10.2 | 동일 cellEditEnded — 두 값 입력 시 modulo check + MODULE_PER_CAR = CELL_PER_CAR / CELL_PER_MODULE storeChange |
| 5-3 | VMI_LT 다중 row cascade propagate (Division 분기) | ⭐ §2.10.7 (다중 row) | 룰 07 §2.10.7 의 예시 코드 적용 — Division 별 SCM_SITE_ID40 vs SCM_SITE_ID 분기 + 동일 (siteId+itemId) row 모두 propagate |
| 5-4 | Sub LIABILITY_PERIOD < 0 revert | (validation) | `SalesSiteProjectModelPurchaseGrid.tsx` 의 cellEditEnded 추가 — 동일 패턴 |

### §1.3 DMF0007 격차 6건 (Branch 1 = 즉시 구현 완료)

| # | 격차 | sub-pattern | TO-BE 가이드 |
|---:|---|---|---|
| 7-2 | FCST Insert 5-key 중복 check + MSG00136 | §2.10.2 | `CustomerFcstMasterFcstGrid.tsx` 의 handleActiveChange 확장 — Insert 시 composite key (Division+Customer+Site+MeasureGroup+Measure) 중복 check |
| 7-3 | FCST D_ 변경 시 8 필수 입력 validation (MSG00002) | (validation) | 룰 25 §1.5.3 (validation) 별도 — cellEditEnded 또는 onSubmit |
| 7-4 | FCST D_ Y 중복 check (5-key + Y) | §2.10.2 | 동일 — composite key + 해당 D_ column='Y' row 중복 check |
| 7-5 | PSI ActiveFlag 5-key 중복 check + MSG00136 | §2.10.2 | `CustomerFcstMasterPsiGrid.tsx` 의 handleActiveChange 확장 — composite key (Division+Customer+Site+MeasureGroup+CustomerPSI) 중복 check |
| 7-6 | ComboSelChange: DeptId → CustomerCode + ScmSite cascade reload (2-level) | §2.10.5 (combo cascade) | `Form.tsx` 의 deptId 변경 → useTabComboQueries 의 filters 재계산 + Division=40 분기 |
| 7-7 | ComboSelChange: CustomerCode → ScmSite cascade reload | §2.10.5 | 동일 — customerCode 변경 → siteId combo refetch |

### §1.4 DMF0008 격차 8+건 (read-only — 편집 가능 전환 시)

DMF0008 의 4 grid 모두 `g.isReadOnly = true` — cascade 0 구현. 편집 가능 전환 시:
- 5 handler 모두 구현 (cascade-mapping.md §3~§5)
- §2.10.6 modal callback (SSPM 의 SetCellTypeCombo → ProjectByDivisionModal 패턴 적용)
- §2.10.5 combo cascade (SalesPlant ↔ SalesCompany)
- Validation 16 MSG → useMessageStore.setAlert 매핑 (__asis-mapping__.md Validation 절)
- Expression 60+ LockRange → column meta `_inputEditType` 분류

---

## §2 구현 절차 (격차별 공통)

### §2.1 PR 전 단계

1. **AS-IS .cs 의 해당 branch 정밀 read** (cascade-mapping.md cross-ref)
2. **TO-BE Grid 컴포넌트 의 cellEditEnded 추가/확장** (룰 07 §2.10 적용)
3. **EditTracker 의 `getOriginalValue` 활용** (revert 시) — 단 API 확인 필요
4. **UI 테스트 의무** — 사용자 화면 cell 편집 후 cascade 정상 동작 확인
5. **i18n MSG 등록** (룰 13) — MSG ID + KO/EN/CN locale 추가

### §2.2 grep 검증

```bash
# AS-IS branch 카운트
rg -nE "e\.Column\s*==.*GetColumnIndex" Doc/_legacy_source/.../{화면}_/{화면}.cs | wc -l

# TO-BE cellEditEnded sub-pattern 카운트
rg -nE "binding\s*===|binding\s*!==" {features}/.../{Grid}.tsx | wc -l

# 격차 = AS-IS - TO-BE
```

---

## §3 사용자 결정 위임

| 결정 항목 | 옵션 | 우선순위 |
|---|---|---|
| 격차별 즉시 구현 vs 사양 보류 | (각 격차별 선택) | DMF0007 高 / 나머지 中 |
| EditTracker API 확장 | `getOriginalValue` 표준 정의 / 사용자 화면 진입 시점 snapshot | (별도 검토) |
| Wijmo `cellEditEnding` (편집 차단 시점) vs `cellEditEnded` (편집 후) | 차단 = `Ending` (e.cancel=true) / 보정 = `Ended` (revert) | (격차별 결정) |
| MSG ID i18n 등록 | MSG00060/MSG00136/MSG00149/MSG00177/MSG00379 등 5+ MSG 추가 | (룰 13 절차 적용) |

---

## §4 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-04 | B3 사양 작성 — 25 건 cascade 격차 중 2 건 즉시 구현 + 23 건 가이드. 메타-룰 #4 (사용자 작업물 우선) 적용 |

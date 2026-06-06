# Hook — cascade 패턴 cross-check

> PR 머지 직전 + 신규 화면 작성 직후 의무 hook. AS-IS `DataModel.Changed` handler 수 vs TO-BE `cellEditEnded` sub-pattern 수 cross-check 자동화.
>
> 룰: `Doc/_rules_v2/_tobe/07_datagrid.md` §2.10 (7 sub-pattern)

작성: 2026-06-04 (Phase 7 보완 F3)

---

## §0 적용 시점

| 시점 | 행위 |
|---|---|
| **PRE-WRITE** (Grid 컴포넌트 작성 직전) | AS-IS .cs 의 `DataModel.Changed` handler 모두 read 후 5 sub-pattern (+§2.10.6 modal callback / §2.10.7 다중 row propagate) 분류 |
| **POST-WRITE** (Grid 작성 직후) | 본 hook 의 §2 grep 4종 실행 — AS-IS handler 수 = TO-BE sub-pattern 수 |
| **PRE-SUBMIT** (PR 직전) | §3 cross-check 표 작성 — `__asis-mapping__.md` 의 Cascade 절 동등 |

---

## §1 7 sub-pattern 분류 의무

> AS-IS handler 의 각 branch 를 다음 7 카테고리 중 어느 것에 매핑할지 분류:

| AS-IS 패턴 | sub-pattern | TO-BE 매핑 |
|---|---|---|
| 다른 cell 값 자동 생성 (예: SoldTo+Country+City → SCM_SITE_ID) | §2.10.1 auto-derive | `cellEditEnded` + EditTracker.storeChange |
| grid 전체 중복 row check + MSG + revert | §2.10.2 duplicate-check | `cellEditEnded` + getOriginalValue + revert |
| parent clear → child cell 다중 clear (예: CountryName clear → Country/City clear) | §2.10.3 cascade-clear | `cellEditEnded` + 다중 storeChange |
| staging table (예: dtSubBucket) | §2.10.4 staging | EditTracker 자동 (DataGrid wrapper) |
| combo 옵션 reload (예: SalesPlant ↔ SalesCompany) | §2.10.5 combo cascade | column.dataMap 갱신 (⚠️ 전체 grid 적용 — row 별 불가) |
| modal cell 선택 → 다중 cell 일괄 cascade (예: setRegion / setCustomers) | §2.10.6 modal callback | dblClick → Modal → setSelectedValue callback (storeChange N 회) |
| 동일 key 의 **다중 row 의 특정 cell** 동기 (예: VMI_LT) | §2.10.7 다중 row propagate | `deferUpdate` + items.forEach + 다중 storeChange |

→ 분류 불가 시 anti-simplification 원칙 따라 사용자에게 보고. 임의 변형 절대 금지.

---

## §2 POST-WRITE grep 4종 (자동 검증)

```bash
# 1. AS-IS handler 인벤토리
rg -nU "DataModel\.Changed|\.Changed\s*\+=" {asis-cs} > asis_cascade.txt
rg -nE "protected\s+void\s+\w*DataModel_Changed" {asis-cs} >> asis_cascade.txt

# 2. AS-IS branch 인벤토리 (e.Column == 비교)
rg -nE "e\.Column\s*==.*GetColumnIndex" {asis-cs} | head -30

# 3. TO-BE cellEditEnded 사용 인벤토리
rg -nE "cellEditEnded\s*=" {tobe-tsx}
rg -nE "storeChange|deferUpdate" {tobe-tsx}

# 4. TO-BE modal callback 인벤토리 (§2.10.6)
rg -nE "setSelectedValue\s*=" {tobe-tsx}

# 5. AS-IS handler unsubscribe/subscribe 패턴 (Wijmo deferUpdate 동등)
rg -nE "\.Changed\s*-=" {asis-cs}
```

→ AS-IS handler 수 vs TO-BE cellEditEnded + modal callback 수 비교.

---

## §3 PR 머지 게이트 — cross-check 표

> `__asis-mapping__.md` 의 Cascade 절에 다음 표 작성 의무 (PoC report 의 §0 결과 종합과 동등):

| sub-pattern | AS-IS 발견 위치 | TO-BE 구현 위치 | 매핑 여부 |
|---|---|---|---|
| §2.10.1 auto-derive | (라인) | (파일:라인) | ✅ / ❌ / ⏳ (의도된 미구현) |
| §2.10.2 duplicate-check | ... | ... | ... |
| §2.10.3 cascade-clear | ... | ... | ... |
| §2.10.4 staging | ... | ... | ... |
| §2.10.5 combo cascade | ... | ... | ... |
| §2.10.6 modal callback | ... | ... | ... |
| §2.10.7 다중 row propagate | ... | ... | ... |

매핑 결과 3 상태:
- ✅ TO-BE 구현 (룰 §2.10 표준 적용)
- ❌ TO-BE 미구현 (격차 — 사용자 보강 결정 후보)
- ⏳ 의도된 미구현 (read-only 화면 / 사용자 작업물 우선)

---

## §4 reference 화면 (5 종)

> Phase 7 후속 cross-check 완료 화면 — 본 hook 적용 사례.

| 화면 | cascade-mapping.md | 특징 |
|---|---|---|
| DMF0004 SalesSite | `_asis/02_screens/DMF0004/cascade-mapping.md` | modal callback 패턴 (§2.10.6) 표준 reference |
| DMF0005 SalesSiteProjectModel | `_asis/02_screens/DMF0005/cascade-mapping.md` | 다중 row propagate (§2.10.7) reference |
| DMF0006 CustomerModelMapping | `_asis/02_screens/DMF0006/cascade-mapping.md` | 가장 단순 (1 branch) + AS-IS unsubscribe/subscribe |
| DMF0007 CustomerFcstMaster | `_asis/02_screens/DMF0007/cascade-mapping.md` | cascade-clear (§2.10.3) TO-BE 구현 reference |
| DMF0008 ErpEdiMaster | `_asis/02_screens/DMF0008/cascade-mapping.md` | read-only 화면 (cascade 0 구현 — 의도된 차이) |

---

## §5 cross-ref

- 룰 07 `_tobe/07_datagrid.md` §2.10 (7 sub-pattern 정형)
- 룰 25 `_dev_rules/25_NEW_SCREEN_MANDATORY_CHECKLIST.md` §1.5.2 (As-Is `.cs` 의 `LockColumn`/`SetCellTypeCombo`/`cellTypeImage` → To-Be `_inputEditType`/`_ctrlType`/`_modalKey` 매핑)
- Hook `asis-coverage-check.md` (4축 매핑 PR 머지 게이트)
- 메타-룰 `meta-rule-evolution.md` (PoC → 룰 보강 사이클)
- 메모리 `feedback_cell_cascade_5_patterns.md` (트리거)

---

## §6 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-04 | 신규 작성 — Phase 7 후속 (F3 — 룰 v2 정비). 7 sub-pattern 분류 + PR 머지 게이트 cross-check 표 |

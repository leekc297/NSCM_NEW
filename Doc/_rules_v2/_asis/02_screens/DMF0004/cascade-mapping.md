# DMF0004 (SalesSite) — cascade DataModel.Changed cross-check

> Phase 7 후속 cross-check (2026-06-04) — 룰 07 §2.10 의 reference 확장.
> DMF0004 의 3 cascade handler 정밀 분석 + TO-BE cross-check + 격차 6 건 + **modal callback cascade 신규 패턴 발견**.

---

## §0 결과 종합

| 항목 | 값 |
|---|---|
| AS-IS source | `GSCM.DM.Master.UIL/DMF0004_SalesSite.cs` (~3700 lines) |
| TO-BE source | `nscm-fe/features/master/src/pages/sales-site/` (4 grid: SalesSiteGrid + Customer + Location + Bucket) |
| AS-IS cascade handler 수 | **3 종** (shtMainDataModel + shtSubCustomerDataModel + shtSubBucketDataModel) |
| AS-IS branch 수 | **9 branch** (Main 5 + SubCustomer 2 + SubBucket 2) |
| TO-BE 구현된 branch | **2 / 9 + modal callback 3 종** (Main auto-derive cellEditEnded + 3 modal callback (Region/Customer/Location)) |
| 룰 07 §2.10 sub-pattern 매핑 | §2.10.1 (3) / §2.10.2 (5) / §2.10.3 (2) / §2.10.4 (1) |
| **신규 패턴 발견** | ⭐ **modal callback cascade** — TO-BE 의 표준 패턴 (setRegion/setCustomers/setSloc) |
| 격차 | 6 건 (다음 §6) |

---

## §1 AS-IS handler #1 — `shtMainDataModel_Changed` (L2550~2636)

| Branch | Trigger column | 동작 | sub-pattern |
|---|---|---|---|
| (a) | SoldTo / Country / City | 3 입력 모두 있을 시 SCM_SITE_ID = SoldTo + "_" + City[0:2] + "_" + City[2:5] 자동 생성 | §2.10.1 auto-derive |
| (b) | SiteId | grid 전체 중복 check + MSG00060 + revert | §2.10.2 duplicate-check |
| (c) | CountryName | clear 시 Country + SiteId cascade clear | §2.10.3 cascade-clear |
| (d) | CityName | clear 시 City + SiteId cascade clear | §2.10.3 cascade-clear |
| (e) | Attribute5 | VMI_YN != 'Y' 시 "VMI Site 에만 입력할 수 있습니다" + revert | §2.10.2 변형 (조건부 차단) |

### §1.1 Branch (a) — SCM_SITE_ID 자동 생성 (L2557~2571)

```csharp
if (e.Column == SoldTo || Country || City) {
    if (3 입력 모두 != "") {
        string sScmSite = SoldTo + "_" + City.Substring(0,2) + "_" + City.Substring(2,3);
        siMain.SetText(e.Row, SiteId, sScmSite);
    }
}
```

→ **TO-BE 구현됨** — `SalesSiteGrid.tsx:72~86` `handleAutoSalesSite` + `utils/sales-site.util.ts:39~48` `applySalesSite` (`${SoldTo}_${Country.slice(0,2)}_${City.slice(0,3)}` — ⚠️ **City slice 가 AS-IS 의 [2,3] = 3 chars vs TO-BE 의 [0,3] = 첫 3 chars** — 명세 차이 가능 / 룰 검증 필요).

### §1.2 Branch (b) — SiteId 중복 check (L2572~2606)

→ **TO-BE 미구현** (격차 #1)

### §1.3 Branch (c)(d) — Country/CityName clear cascade (L2607~2622)

→ **TO-BE 부분 구현** — `setRegion` (SalesSiteGrid.tsx:43~66) modal callback 안에서 COUNTRY/CITY/COUNTRY_NAME/CITY_NAME 4 column 일괄 set + applySalesSite cascade. **단 modal callback 방식** — AS-IS cellEditEnded clear 와 architecture 차이.

### §1.4 Branch (e) — Attribute5 + VMI_YN check (L2623~2633)

→ **TO-BE 미구현** (격차 #2)

---

## §2 AS-IS handler #2 — `shtSubCustomerDataModel_Changed` (L2368~2425)

| Branch | Trigger column | 동작 | sub-pattern |
|---|---|---|---|
| (a) | RepYn | grid 의 RepYn='Y' 1개 이상 시 MSG00149 + revert (N) | §2.10.2 (single Y constraint) |
| (b) | SoldToCode / ShipToCode | (SoldTo+ShipTo) 중복 + ValidYn='Y' row 발견 시 MSG00060 + 4 column cascade clear (SoldToCode/Description + ShipToCode/Description) | §2.10.2 + §2.10.3 |

→ **TO-BE 미구현** — `SalesSiteCustomerGrid.tsx` 는 `setCustomers` modal callback 만 보유 (CustomerModal 의 setSelectedValue 콜백 — SOLDTO/SHIPTO/SHIPTO_REGION/CITY 6 column 일괄 set). RepYn 단일 Y 제약 + SoldTo/ShipTo 중복 check 모두 미구현 (격차 #3, #4).

---

## §3 AS-IS handler #3 — `shtSubBucketDataModel_Changed` (L2427~2518)

| Branch | Trigger column | 동작 | sub-pattern |
|---|---|---|---|
| (a) | D_YYYYMMDD column | 3 필수 입력 validation (Division/SiteId/Incoterms) + `SetSubBucketData` (dtSubBucket staging sync) | §2.10.4 staging |
| (b) | Incoterms | (Division+SiteId+Incoterms) 중복 check + MSG00060 + revert | §2.10.2 duplicate-check |

→ **TO-BE 미구현** — `SalesSiteBucketGrid.tsx` 는 read-only grid 처럼 동작 (cellEditEnded 없음, modal 없음). dtSubBucket staging + Incoterms 중복 check 모두 미구현 (격차 #5, #6).

---

## §4 TO-BE 구현 인벤토리

| TO-BE 위치 | 방식 | sub-pattern | AS-IS 매핑 |
|---|---|---|---|
| `SalesSiteGrid.tsx:72~86` `handleAutoSalesSite` (cellEditEnded) | cellEditEnded 직접 | §2.10.1 auto-derive | Main Branch (a) — SCM_SITE_ID 자동 생성 ✅ |
| `SalesSiteGrid.tsx:43~66` `setRegion` | **modal callback** | §2.10.3 cascade-clear (변형 — modal 안에서 cascade) | Main Branch (c)(d) — Country/CityName cascade clear (의도된 차이) |
| `SalesSiteGrid.tsx:88~114` `handleGridDblClick` | dblClick → modal 열기 | §2.5 dblClick → setDetailFilters | (cascade 와 별개 — parent-child grid drill-down) |
| `SalesSiteCustomerGrid.tsx:40~86` `setCustomers` | **modal callback** | (modal cell 6 column set) | (cascade 아님 — CustomerModal cell 값 채움) |
| `SalesSiteCustomerGrid.tsx:92~110` `handleDblClick` | dblClick → CustomerModal | §3.5 modal cell + CRUD_TYPE guard | — |
| `SalesSiteLocationGrid.tsx:40~61` `setSloc` | **modal callback** | (modal cell 3 column set) | (cascade 아님 — StorageLocationModal) |
| `SalesSiteLocationGrid.tsx:67~82` `handleDblClick` | dblClick → StorageLocationModal | §3.5 modal cell + CRUD_TYPE guard | — |
| `SalesSiteBucketGrid.tsx` | (cellEditEnded 없음, modal 없음) | (read-only 패턴) | Bucket Branch (a)(b) — 모두 미구현 ❌ |

---

## §5 ⭐ 신규 패턴 발견 — modal callback cascade

> AS-IS 의 cellEditEnded 직접 cascade 와 architecture 차이.
> DMF0004 의 TO-BE 는 **modal cell 변경 → modal callback 안에서 다중 cell cascade** 패턴이 표준.

### §5.1 패턴 정의

```typescript
// modal cell (CRUD_TYPE='I' + 특정 binding) 더블클릭 → modal 열기
const handleDblClick = (mouseEvent: MouseEvent) => {
  const grid = gridRef.current;
  const ht = grid.hitTest(mouseEvent);
  const dataItem = GridUtils.getRow(grid, ht.row);
  const binding = GridUtils.getBinding(grid, ht.col);
  if (dataItem.CRUD_TYPE === CRUD_TYPE.INSERT &&
      (binding === 'XXX_CODE' || binding === 'YYY_CODE')) {
    setClickedRow(ht.row);
    setOpenModal(true);
  }
};

// modal 의 setSelectedValue 콜백 — 다중 cell 일괄 cascade (storeChange N 회)
const setSelectedValue = (val1: string, val2: string, val3: string, ...) => {
  const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
  if (!dataItem || dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;

  editTrackerRef.current?.storeChange(dataItem, 'COL1', dataItem.COL1, val1);
  editTrackerRef.current?.storeChange(dataItem, 'COL2', dataItem.COL2, val2);
  // ... N 회
  dataItem.COL1 = val1; dataItem.COL2 = val2; // ...
  // (선택) auto-derive 호출
  applySalesSite(dataItem, editTrackerRef.current);
  gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
};
```

### §5.2 DMF0004 의 3 modal callback

| Component | Modal | Trigger binding | 일괄 cascade column 수 | auto-derive |
|---|---|---|---|---|
| SalesSiteGrid | RegionModal | COUNTRY_NAME / CITY_NAME | 4 (COUNTRY/CITY/COUNTRY_NAME/CITY_NAME) | ⭐ applySalesSite 호출 |
| SalesSiteCustomerGrid | CustomerModal | SOLDTO_CODE / SHIPTO_CODE | 6 (SOLDTO/SHIPTO/Description ×2 + REGION/CITY) | (없음) |
| SalesSiteLocationGrid | StorageLocationModal | LOCATION_CODE | 3 (PLANT_ID/LOCATION_CODE/LOCATION_DESCRIPTION) | (없음) |

### §5.3 AS-IS 와의 architecture 차이

| AS-IS | TO-BE (modal callback) |
|---|---|
| FpSpread combo cell (Lookup master / Data.Common) | Wijmo 일반 cell + dblClick 으로 Modal 호출 |
| `siMain.SetCellTypeCombo(row, col, dt)` | Modal 안 grid 또는 dropdown 으로 선택 |
| cellEditEnded → cascade | dblClick → Modal → callback 안 cascade |
| 단점: combo 데이터셋 모두 client 메모리 적재 | 단점: dblClick 으로 명시적 호출 필요 (UX 차이) |
| 장점: AS-IS 사용자에게 익숙 | 장점: 검색 + paging + 권한 적용 가능 |

→ TO-BE 의 modal callback cascade 는 룰 07 §3.5 (CRUD_TYPE guard) 와 §2.10.1 (auto-derive) 의 결합 패턴 — **§2.10.7 신규 sub-pattern 후보**.

---

## §6 격차 6 건

| # | 격차 | sub-pattern | AS-IS 위치 |
|---:|---|---|---|
| 1 | Main: SiteId 중복 check + MSG00060 + revert | §2.10.2 | L2572~2606 |
| 2 | Main: Attribute5 + VMI_YN check (조건부 차단) | §2.10.2 변형 | L2623~2633 |
| 3 | SubCustomer: RepYn 단일 Y 제약 + MSG00149 | §2.10.2 (single Y) | L2375~2392 |
| 4 | SubCustomer: SoldTo+ShipTo+ValidYn='Y' 중복 check + 4 column cascade clear | §2.10.2 + §2.10.3 | L2393~2422 |
| 5 | SubBucket: D_ 변경 시 3 필수 입력 + staging sync | §2.10.4 | L2434~2481 |
| 6 | SubBucket: Incoterms 중복 check + MSG00060 + revert | §2.10.2 | L2482~2514 |

→ **격차 6 건 모두 TO-BE 미구현**. SubBucket sheet 는 read-only 처럼 동작 — 의도된 부분 구현 가능성 高 (또는 향후 보강).

### §6.1 사용자 작업물 우선 (메타-룰 #4)

- DMF0004 의 TO-BE 는 **modal callback cascade + auto-derive 만 구현** + 나머지 (중복 check / single Y / VMI_YN / staging) 는 BE-side SP 위임 또는 향후 보강
- 본 cross-check 는 **분석 보고서** — DMF0004 코드 변경 X

---

## §7 룰 07 §2.10 reference 확장

| sub-pattern | reference (룰 작성 시) | 확장 reference (본 cross-check) |
|---|---|---|
| §2.10.1 auto-derive | DMF0008 SalesSite Branch (a) | **DMF0004 Main Branch (a) — SCM_SITE_ID + handleAutoSalesSite + applySalesSite — TO-BE 구현 사례** ⭐ |
| §2.10.2 duplicate-check | DMF0008 SalesSite Branch (b), DMF0007 (3 위치) | **DMF0004 5 위치 추가** (Main SiteId / Attribute5 / SubCustomer RepYn / SubCustomer SoldTo+ShipTo / SubBucket Incoterms) |
| §2.10.3 cascade-clear | DMF0008 SalesSite Branch (c)(d), DMF0007 FCST/PSI | **DMF0004 Main (c)(d) + SubCustomer (b) — 단 TO-BE 는 modal callback 변형** |
| §2.10.4 staging | DMF0008 SSPM dtSubBucket | DMF0004 SubBucket dtSubBucket — 동일 패턴 (AS-IS) |
| §2.10.5 combo cascade | DMF0008 SSPM, DMF0007 ComboSelChange | (DMF0004 사용 X — modal callback 으로 대체) |
| ⭐ **§2.10.7 modal callback cascade (신규 후보)** | (없음) | **DMF0004 setRegion / setCustomers / setSloc — 3 modal callback** |

→ 5 sub-pattern 모두 reference 보강 + 신규 §2.10.7 후보 발견.

---

## §8 명세 차이 발견 — City slice (Phase 7 후속 B4 검증 — 2026-06-04)

### §8.1 AS-IS DefColumns 정의 (DMF0004_SalesSite.cs L119~122)

```csharp
public static string City = "CITY";
public static string CityName = "CITY_NAME";
public static string Country = "COUNTRY";
public static string CountryName = "COUNTRY_NAME";
```

→ AS-IS DefColumns 도 **COUNTRY / CITY 별도 column** 으로 정의. cascade Branch (a) 의 `City.Substring(0,2) + "_" + City.Substring(2,3)` 코드 자체가 **버그 가능성** — Country column 무시.

### §8.2 AS-IS cascade 코드 정밀 분석

```csharp
// L2565~2567
string sScmSite = siMain.GetText(e.Row, SoldTo)
                + "_" + siMain.GetText(e.Row, City).Substring(0, 2)
                + "_" + siMain.GetText(e.Row, City).Substring(2, 3);
```

⚠️ **AS-IS 의 의도 추정**: `City` column 에 **5-char 합성값** (예: `KRSEO`) 이 저장됨. UI 상 보이는 City Name 과 다른 raw code.
- AS-IS DB 의 SCM_MST_SITE.CITY = `KRSEO` (5-char)
- AS-IS DB 의 SCM_MST_SITE.COUNTRY = `KR` 또는 별도 의미 (UI 입력용)

또는 **버그** — Country column 사용해야 함에도 City 만 사용 (legacy code).

### §8.3 TO-BE buildSalesSite 의도

```typescript
// utils/sales-site.util.ts L26~36
const country = String(row['COUNTRY'] ?? '').trim().slice(0, 2);
const city = String(row['CITY'] ?? '').trim().slice(0, 3);
return `${soldToCustomer}_${country}_${city}`;
```

→ TO-BE 는 **정규화된 데이터 모델 가정** (COUNTRY 2-char + CITY 3-char 별도 column).

### §8.4 결과 형식 비교

| 데이터 모델 시나리오 | AS-IS 결과 | TO-BE 결과 | 동등성 |
|---|---|---|---|
| (시나리오 A) DB CITY = "KRSEO" (5-char 합성) / COUNTRY = "KR" | `SoldTo_KR_SEO` (City[0:2]+City[2:5]) | `SoldTo_KR_KRS` (Country[0:2]+City[0:3] — 잘림) | ❌ 다름 |
| (시나리오 B) DB CITY = "SEO" (3-char) / COUNTRY = "KR" (2-char) | `SoldTo_SE_O__` (City Substring 인덱스 초과 → 예외) | `SoldTo_KR_SEO` | ❌ AS-IS 예외 |
| (시나리오 C) DB CITY = "SEO" (3-char) + AS-IS 의 City Substring 이 안전 가드 보유 | `SoldTo_SE_O` (Substring(2,3) 짧음) | `SoldTo_KR_SEO` | ❌ 다름 |

### §8.5 결정 위임 — 사용자 확인 의무

**확인 필요 항목**:
1. **AS-IS DB 의 SCM_MST_SITE.CITY column 의 실제 데이터 길이** (sqlcmd 또는 Oracle SELECT)
   ```sql
   SELECT LENGTH(CITY), CITY, COUNTRY FROM SCM_MST_SITE WHERE ROWNUM <= 10;
   ```
2. **AS-IS 의 의도된 결과 형식** = `SoldTo_CountryCode_CityCode` (`KR_SEO`) 인지 확인
3. **TO-BE buildSalesSite 의 Country / City slice 로직 검증** — 사용자 화면에서 SCM_SITE_ID 자동 생성 결과 비교

**옵션**:
- (A) AS-IS 가 버그 — TO-BE 가 정확 (Country + City 분리 모델). 조치: 무시 + TO-BE 그대로.
- (B) AS-IS 가 정확 — TO-BE 의 buildSalesSite 가 결과 다름. 조치: TO-BE 수정 (City slice 로직 변경).
- (C) DB 마이그레이션 시 데이터 변환 (CITY = "KRSEO" → COUNTRY = "KR" + CITY = "SEO"). 조치: 변환 SQL 검증.

→ **권장**: (A) — TO-BE 가 정규화 + 향후 표준. AS-IS 결과 1:1 동등성 미보장 명시 (DB 마이그레이션 시 변환 의무).

⚠️ **본 자동 진행 scope 에서는 분석 결과 정리만** — 실제 검증 + 결정 = 사용자 진행.

---

## §9 변경 이력

| 일자 | 변경 | Phase |
|---|---|---|
| 2026-06-04 | DMF0004 cascade cross-check 신규 작성 — 3 handler × 9 branch + TO-BE 매핑 + 격차 6 건 + **modal callback cascade 신규 패턴 발견** (§5) + 룰 07 §2.10 reference 확장 + §2.10.7 신규 sub-pattern 후보 | Phase 7 후속 |

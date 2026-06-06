# DMF0008 — 4 sheet cascade DataModel.Changed 매핑

> Phase 7 PoC 보완 8 (2026-06-04) — DMF0008 의 4 sheet 별 cascade DataModel.Changed handler 정밀 인벤토리 + TO-BE 매핑.
>
> **결론**: TO-BE 현재 4 grid 모두 `g.isReadOnly = true` → AS-IS 의 5 cascade 모두 미구현 (의도적 차이). 향후 편집 가능으로 전환 시 본 문서를 가이드 사용.

---

## §0 4 sheet × cascade handler 매트릭스

| # | sheet | TO-BE sheetName | AS-IS handler | Bind 위치 | 동작 |
|---:|---|---|---|---|---|
| 1 | Summary | `main` | `shtSummaryDataModel_Changed` (L2391) | — | **NoOp** — body 전체 주석 처리 (AS-IS 도 read-only 의도) |
| 2 | Repair | `repair` | (없음) | — | **NoOp** — handler 부재 = read-only |
| 3 | SalesSite | `salesSite` | `shtSALES_SITEDataModel_Changed` (L2080) | dsdm1 (L456) | **5 column trigger cascade** — SCM_SITE_ID 자동 생성 / 중복 row check / Country/City clear cascade |
| 4 | SSPM | `sspm` | `shtSSPMDataModel_Changed` (L2279) | dsdm2 (L459) | **모든 cell 동기** — dtSubBucket 에 row sync |
| 5 | SalesSite/SSPM 통합 | `salesSite` + `sspm` | `spdSub_Changed` (L2786) | dsdm1+dsdm2 (L411, L413) | **SSPM 만 활성** — PROJECT_CODE / TEAM_ID 변경 시 SalesPlant + SalesCompany combo reload (Data.Common) |

---

## §1 Cascade #1 — `shtSummaryDataModel_Changed` (Summary)

| 항목 | 값 |
|---|---|
| 위치 | DMF0008_ErpEdiMaster.cs L2391~2477 |
| switch case | `CellsUpdated` (1 case) |
| body | **전부 주석 처리** (L2398~2474 — 약 76 lines comment-out) |
| 주석 본문 의도 | SoldTo/Country/City → SiteId 자동 생성 + 중복 check (SalesSite 와 동일 패턴) |
| 실제 동작 | NoOp |

### TO-BE 매핑

| TO-BE 결정 | 매핑 |
|---|---|
| `g.isReadOnly = true` (ErpEdiMaster.tsx L270) | ✅ AS-IS NoOp 과 동등 |
| Wijmo cellEditEnded handler | 없음 (불필요) |

---

## §2 Cascade #2 — Repair (handler 부재)

| 항목 | 값 |
|---|---|
| 위치 | (없음) |
| Bind | (없음) |
| 의미 | AS-IS Repair grid 는 처음부터 read-only |

### TO-BE 매핑

| TO-BE 결정 | 매핑 |
|---|---|
| `g.isReadOnly = true` (ErpEdiMaster.tsx L299) | ✅ AS-IS handler 부재와 동등 |

---

## §3 Cascade #3 — `shtSALES_SITEDataModel_Changed` (SalesSite)

| 항목 | 값 |
|---|---|
| 위치 | DMF0008_ErpEdiMaster.cs L2080~2177 |
| switch case | `CellsUpdated` (1 case) |
| Trigger columns | sSOLDTO_CUSTOMER / sCOUNTRY / sCITY / sSCM_SITE_ID / sCOUNTRY_NAME / sCITY_NAME (5 column 분기) |
| 5 branch | (a) 3 입력 → SCM_SITE_ID 자동 생성 (b) SCM_SITE_ID 변경 → 중복 row check (c) CountryName clear → cascade clear (d) CityName clear → cascade clear |

### §3.1 5 branch 정밀

**Branch (a)** — L2087~2108: SoldTo + Country + City 모두 입력 시 SCM_SITE_ID 자동 생성
```csharp
if (e.Column == sSOLDTO_CUSTOMER || sCOUNTRY || sCITY) {
    if (3 column 모두 != "") {
        ssScmSite = SoldTo + "_" + City.Substring(0,2) + "_" + City.Substring(2,3);
        siSub.SetText(e.Row, sSCM_SITE_ID, ssScmSite);
    }
}
```

**Branch (b)** — L2109~2143: SCM_SITE_ID 변경 시 grid 전체 중복 check
```csharp
else if (e.Column == sSCM_SITE_ID) {
    for (int iRow = 0; iRow <= GetMaxRowIndex(); iRow++) {
        if (sScmSite == iRow.SCM_SITE_ID) iChkCount++;
        if (iChkCount > 1) {
            MessageHelper.GMessageBox("MSG00060", new object[] { "필수 입력사항입니다..." });
            siSub.SetValue(e.Row, sSCM_SITE_ID, "");
            break;
        }
    }
}
```

**Branch (c)** — L2144~2154: CountryName clear → Country + City + CityName cascade clear
**Branch (d)** — L2155~2163: CityName clear → City cascade clear

### §3.2 TO-BE 매핑

| AS-IS branch | TO-BE 현재 | TO-BE 향후 (편집 가능 전환 시) |
|---|---|---|
| (a) SCM_SITE_ID 자동 생성 | ❌ 미구현 (`g.isReadOnly=true`) | Wijmo `cellEditEnded` (s, e) → if (e.col in [SoldTo/Country/City]) → e.panel.setCellData(e.row, scmSiteCol, value) |
| (b) 중복 check (MSG00060) | ❌ 미구현 | `cellEditEnded` (s, e) → if (e.col == scmSiteCol) → itemsSource.forEach 로 중복 count + `useMessageStore.setAlert({type:'alert', content: ...})` |
| (c) CountryName clear cascade | ❌ 미구현 | `cellEditEnded` → cascade setCellData |
| (d) CityName clear cascade | ❌ 미구현 | 동일 |

**중요**: TO-BE 의 모든 cascade 는 `s.deferUpdate(() => { ... })` 로 wrap 의무 (성능 + cascade 안 cascade 방지).

---

## §4 Cascade #4 — `shtSSPMDataModel_Changed` (SSPM)

| 항목 | 값 |
|---|---|
| 위치 | DMF0008_ErpEdiMaster.cs L2279~2320 |
| switch case | `CellsUpdated` (1 case) |
| Trigger columns | 모든 cell update (filter 없음) |
| 동작 | 9 column 값 추출 → `SetSubSSPMData(...)` 로 dtSubBucket 동기 |

### §4.1 동작 본문

```csharp
sDivisionId = siSub.GetValue(e.Row, pDIVISION_ID).ToString();
sSCM_SITE_ID = siSub.GetValue(e.Row, pSCM_SITE_ID).ToString();
sSOLDTO_CODE = siSub.GetValue(e.Row, pSOLDTO_CODE).ToString();
... (9 column)
SetSubSSPMData(sDivisionId, sSCM_SITE_ID, sPROJECT_CODE, sItemId, sSalesPlant, sIncoterms, sValidYn, "", "WTOD");
```

**`SetSubSSPMData` (L2354~2389)** — `dtSubBucket` 의 row insert/update:
- filter: pITEM_ID + pSCM_SITE_ID + pSALES_PLANT + pEDI + pVALID_YN (5 column composite)
- 없으면 NewRow + Add / 있으면 BucketPer / ConversionType update

### §4.2 TO-BE 매핑

| AS-IS | TO-BE 현재 | TO-BE 향후 |
|---|---|---|
| dtSubBucket = 클라이언트 사이드 staging table | ❌ 미구현 | TO-BE 는 dirty row 추적을 Wijmo `EditTracker` 로 처리 (룰 07 §2.3) — dtSubBucket 와 의미 동등 |
| Save 시 dtSubBucket 전체 BE 전송 | ❌ 미구현 | TO-BE 는 `EditTracker.getChangedItems()` 결과를 G4 useBatchMutation 으로 일괄 전송 |

---

## §5 Cascade #5 — `spdSub_Changed` (SalesSite + SSPM 통합)

| 항목 | 값 |
|---|---|
| 위치 | DMF0008_ErpEdiMaster.cs L2786~2839 |
| Bind | dsdm1 (L411) + dsdm2 (L413) — SalesSite + SSPM 통합 handler |
| 분기 | `siSub.ActiveSheet.SheetName == shtSales_Site` → 빈 본문 / `== shtSSPM` → SSPM only 활성 |
| 결과 | **사실상 SSPM 전용** — SalesSite 분기는 빈 본문 |

### §5.1 SSPM 분기 본문

**Trigger #1** — `e.Column == pPROJECT_CODE`:
```csharp
sSalesCompany = siSub.GetValue(e.Row, pSALES_COMPANY).ToString();
dtSalesPlant = Data.Common(Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem);
siSub.SetCellTypeCombo(e.Row, pSALES_PLANT, dtSalesPlant);  // 동적 combo reload

sSalesPlant = siSub.GetValue(e.Row, pSALES_PLANT).ToString();
dtSalesCompany = Data.Common(Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem);
siSub.SetCellTypeCombo(e.Row, pSALES_COMPANY, dtSalesCompany);
```

**Trigger #2** — `e.Column == sTEAM_ID`: 동일 패턴 (SalesPlant + SalesCompany combo reload)

### §5.2 TO-BE 매핑

| AS-IS | TO-BE 현재 | TO-BE 향후 |
|---|---|---|
| `Data.Common(Type.SalesPlant, ...)` 동적 combo 데이터 fetch | ❌ 미구현 | TO-BE 는 `useTabComboQueries` 의 동적 filter 로 처리 — `enabled: !!projectCode` + `filters: { projectCode }` |
| `siSub.SetCellTypeCombo(row, col, dt)` — row 별 cell combo 변경 | ❌ 미구현 | Wijmo column 의 `dataMap` 동적 변경 = 어려움. 대신 column 의 `dataMap = new DataMap(itemsSource, 'CODE', 'NAME')` 를 store 의 `salesPlantOptions` 와 sync |
| cascade combo (SalesPlant ↔ SalesCompany 양방향) | ❌ 미구현 | `cellEditEnded` (s, e) → projectCode/teamId 변경 시 store action 호출 → React Query refetch combo |

---

## §6 요약 — TO-BE 현재 vs AS-IS

| sheet | AS-IS cascade | TO-BE 현재 (read-only) | 매핑 결과 |
|---|---|---|---|
| Summary | NoOp (주석 처리) | `g.isReadOnly=true` | ✅ 동등 |
| Repair | 없음 (read-only) | `g.isReadOnly=true` | ✅ 동등 |
| SalesSite | 5 branch cascade | `g.isReadOnly=true` | ⚠️ 의도적 차이 — TO-BE 는 Save 미지원 |
| SSPM (DataModel) | dtSubBucket 동기 | `g.isReadOnly=true` | ⚠️ 의도적 차이 |
| SSPM (combo cascade) | SalesPlant ↔ SalesCompany | `g.isReadOnly=true` | ⚠️ 의도적 차이 |

> **결론**: PoC_REPORT §3.2 보완 4 의 fetchStaticColumns 추가 (G1 GET) 와 본 문서는 **별개**.
> - 보완 4 = 검색조건 자동 restore (모든 화면 의무)
> - 보완 8 = cascade 매핑 (편집 가능 전환 시 가이드)

---

## §7 향후 편집 가능 전환 시 Hook 권장

> AS-IS 의 5 cascade 를 TO-BE 로 이관하려면:

| Hook | 패턴 |
|---|---|
| Wijmo `cellEditEnded` | `(s, e) => { if (e.panel.cellType !== CellType.Cell) return; ... }` |
| `s.deferUpdate` | cascade 안 cascade 방지 |
| `s.beginUpdate / endUpdate` | 명시적 batch 처리 (deferUpdate 의 alternate) |
| Wijmo column `dataMap` 동적 변경 | row 단위 combo 변경은 Wijmo 기본 미지원 — column 의 `dataMap` 자체를 store 와 sync |
| EditTracker | row 단위 dirty 추적 (dtSubBucket 동등) |
| G4 useBatchMutation | Save 시 변경 row 일괄 전송 |

### §7.1 룰 07 §2.10 정식 등록 완료 (2026-06-04)

본 cascade 패턴은 **TO-BE `_tobe/07_datagrid.md` §2.10** 으로 정식 등록 완료 (2026-06-04). 5 sub-pattern + deferUpdate + 의사결정 표 + PR 머지 게이트 grep 포함.

| sub-pattern | 룰 위치 |
|---|---|
| §2.10.1 auto-derive (값 자동 생성) | 본 문서 §3.1 Branch (a) 정형화 |
| §2.10.2 duplicate-check (중복 + MSG + revert) | 본 문서 §3.1 Branch (b) 정형화 |
| §2.10.3 cascade-clear (parent clear → child clear) | 본 문서 §3.1 Branch (c)(d) 정형화 |
| §2.10.4 staging (dtSubBucket) | 본 문서 §4 — TO-BE EditTracker 가 자동 |
| §2.10.5 combo-cascade (SetCellTypeCombo) | 본 문서 §5 — Wijmo column.dataMap (전체 grid 적용 — 의미 차이 주의) |
| §2.10.6 deferUpdate (cascade 안 cascade 방지) | (룰 신규) |

---

## §8 변경 이력

| 일자 | 변경 | Phase |
|---|---|---|
| 2026-06-04 | 본 파일 신규 작성 — 4 sheet × 5 cascade 정밀 매핑 + TO-BE 매핑 + 향후 편집 가능 전환 가이드 | Phase 7 PoC 보완 8 |

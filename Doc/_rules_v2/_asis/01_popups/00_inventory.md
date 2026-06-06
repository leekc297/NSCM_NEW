# AS-IS Popup 전수 인벤토리 + TO-BE 매핑

> **source**: `C:\Projects\NSCM\GSCM\06.UIL\**\*Popup*.cs` (592 파일, .Designer.cs 제외)
>
> **목적**: 모든 AS-IS popup 의 분류 + Top 30 공용 popup 의 TO-BE `@master/components/*Modal` 매핑 + 격차 식별.

---

## §0 메타

| 항목 | 값 |
|---|---|
| 총 popup 파일 | **592** (UIL 전체, .Designer.cs 제외) |
| 공용 popup prefix (SCM0002_) | **41** (= `GSCM.SCM.Popup.UIL` 폴더의 메인) |
| 도메인 popup | 551 (FP / SCP / SSP / DM 등 도메인별) |
| TO-BE 공용 modal | **11** (`@master/components/*Modal/`) |
| 진행도 | 분류 + 핵심 SCM0002 38 매핑 + DM 도메인 popup 매핑 — **개별 deep-dive 다음 세션** |

---

## §1 Prefix 분류 통계 (Top 25)

| Prefix | 파일 수 | 의미 |
|---|---:|---|
| **`SCM0002_`** | **41** | 공용 lookup popup (Project/Item/Customer/Team/Storage/City/Vendor 등) |
| `FP01551_` | 26 | FP 분석 화면 popup |
| `SCP0049_` | 17 | SCP Validation popup |
| `FP00601_` | 16 | FP 도메인 |
| `FP00595_` | 16 | FP 도메인 |
| `FP02841_` | 14 | FP 도메인 |
| `FP01624_` | 14 | FP 도메인 |
| `FP00590_` | 14 | FP 도메인 |
| `FP00602_` | 13 | FP 도메인 |
| `FP03033_` | 12 | FP 도메인 |
| `FP01552_` | 12 | FP 도메인 |
| `FP00596_` | 12 | FP 도메인 |
| `FP00594_` | 12 | FP 도메인 |
| `FP00643_` | 11 | FP 도메인 |
| `FP00607_` | 8 | FP 도메인 |
| `FP00606_` | 8 | FP 도메인 |
| `FP00514_` | 8 | FP 도메인 |
| `FP00510_` | 8 | FP 도메인 |
| `FP01559_` | 7 | FP 도메인 |
| `FP02842_` | 6 | FP 도메인 |
| `FP00623_` | 6 | FP 도메인 |
| (그 외 542 종) | ≤ 5 | 단일 화면 specific popup |

→ **공용 popup 의 메인 source = SCM0002_ 41개**. FP 도메인이 압도적 다수 (300+) 지만 FP 화면 자체 specific.

---

## §2 SCM0002_ 38개 공용 popup 전수 인벤토리 + TO-BE 매핑

> **위치**: `C:\Projects\NSCM\GSCM\06.UIL\GSCM.SCM.Popup.UIL\` (38 파일, `*.designer.cs` 제외)

| # | AS-IS Popup | 용도 (1줄) | TO-BE Modal | 상태 |
|---:|---|---|---|---|
| 1 | `SCM0002_CapacityAllocationPopup` | Capacity allocation 선택 | (없음) | **격차** (DM0036 specific) |
| 2 | `SCM0002_CAPAItemPopup` | CAPA Item 선택 | (없음) | **격차** |
| 3 | `SCM0002_CitybyCountry` | 국가-도시 선택 | `RegionModal` | ✅ 매핑 |
| 4 | **`SCM0002_CustomerbyDivisionPopup` ⭐** | 부서별 고객 선택 | `CustomerModal` | ✅ 매핑 |
| 5 | `SCM0002_DepartmentPopup` | 부서 선택 | (없음) | **격차 후보** |
| 6 | `SCM0002_ElectrodeItembyDivisionPopup` | Electrode Item (전극) | (없음) | **격차** (SCM 특화) |
| 7 | `SCM0002_FactoryByDivisionPopup` | 부서별 공장 선택 | (없음) | **격차 후보** |
| 8 | `SCM0002_GetBODItemPopup` | BOD Item 선택 | (없음) | **격차** (BOD 특화) |
| 9 | `SCM0002_GetBODItemPrjRoutePopup` | BOD Item + Project Route | (없음) | **격차** |
| 10 | `SCM0002_GetBODPopup` | BOD 선택 | (없음) | **격차** |
| 11 | `SCM0002_ItembyDivisionPopup` | 부서별 Item 선택 (basic) | (`ItembyDivisionPopupEx` 와 비교) | (Ex 가 표준) |
| 12 | `SCM0002_ItembyDivisionPopupEE` | Electrode Item 변형 | (없음) | **격차** (SCM 특화) |
| 13 | **`SCM0002_ItembyDivisionPopupEx` ⭐** | 부서별 Item 확장 (DMF0004~7 표준) | `ItemByDivisionModal` | ✅ 매핑 |
| 14 | `SCM0002_ItembyPlantSitePopup` | 공장-사이트별 Item | (없음) | **격차 후보** |
| 15 | `SCM0002_ItembySitePopup` | 사이트별 Item | (없음) | **격차 후보** |
| 16 | `SCM0002_JigbyDivisionPopup` | Jig (지그) 선택 | (없음) | **격차** (제조 특화) |
| 17 | `SCM0002_LocationbyDivisionPopup` | 부서별 Location | (`StorageLocationModal` 가능) | (확인 필요) |
| 18 | `SCM0002_MKTFCSTAdjstPopup` | Market FCST 조정 | (없음) | **격차** (DM 특화) |
| 19 | `SCM0002_PlanlineExcelUploadForm` | Excel upload form | (없음) | **격차** (G5 흡수) |
| 20 | `SCM0002_PlantCustomerbyDivisionPopup` | 공장-고객 선택 | (없음) | **격차 후보** |
| 21 | `SCM0002_ProductionPlanInsertPopup` | 생산 계획 입력 | (없음) | **격차** (FP 특화) |
| 22 | `SCM0002_ProjectbyDivisionPopup` | 부서별 Project (basic) | (`PopupEx` 가 표준) | (Ex 가 표준) |
| 23 | **`SCM0002_ProjectbyDivisionPopupEx` ⭐** | 부서별 Project 확장 (DMF0004~7 표준) | `ProjectByDivisionModal` | ✅ 매핑 |
| 24 | `SCM0002_ProjectRouteListSavePopup` | Project Route List 저장 | (없음) | **격차** |
| 25 | `SCM0002_RejectReasonPopup` | 거절 사유 선택 | (없음) | **격차 후보** |
| 26 | `SCM0002_ShipmentLotSizePopup` | Shipment Lot Size | (없음) | **격차** (SSP 특화) |
| 27 | `SCM0002_ShipmentPlanConfirmBODPopup` | Shipment Plan BOD 확인 | (없음) | **격차** (SSP) |
| 28 | `SCM0002_ShipmentPlanInsertPopup` | Shipment Plan 입력 | (없음) | **격차** (SSP) |
| 29 | `SCM0002_ShipmentPlanRequestPopup` | Shipment Plan 요청 | (없음) | **격차** (SSP) |
| 30 | `SCM0002_ShipmentRequestChangePopup` | Shipment Request 변경 | (없음) | **격차** (SSP) |
| 31 | **`SCM0002_SoldtobyDivisionPopup` ⭐** | 부서별 Sold-To 선택 (DMF0004 grid cell) | (없음) | **격차 후보** (DMF0004 의무) |
| 32 | **`SCM0002_StoragebyDivisionPopup` ⭐** | 부서별 Storage 선택 | `StorageLocationModal` | ✅ 매핑 |
| 33 | **`SCM0002_TeamPopup` ⭐** | Team 선택 | `TeamModal` | ✅ 매핑 |
| 34 | **`SCM0002_TitleSetForm_Popup` ⭐** | 사용자별 컬럼 설정 | `ColumnSettingModal` | ✅ 매핑 |
| 35 | `SCM0002_VendorPopup` | Vendor 선택 | (없음) | **격차 후보** |
| 36 | `SCM0002_VersionByWaterfallPopup` | Version 선택 (Waterfall) | (없음) | **격차** (DM 특화) |
| 37 | `SCM0002_VersionByWaterfallPopupEx` | Version 확장 | (없음) | **격차** |
| 38 | (`*Designer.cs` 외 기타) | | | |

### §2.1 매핑 요약

- ✅ **매핑 완료 (7 종)**: CitybyCountry / Customer / ItembyDivisionEx / ProjectbyDivisionEx / Storage / Team / TitleSetForm
- **격차 후보 (Top priority — 사용 빈도 높음)**: SoldtobyDivisionPopup, Vendor, FactoryByDivision, ItembyPlantSite, ItembySite, RejectReason, Department, PlantCustomer, Location
- **도메인 특화 (현재 미사용 / 향후 필요 시)**: 나머지 22 종 (FP/SCP/SSP/BOD/Capacity 등)

---

## §3 DM 도메인 popup (DM*Popup + DMF*Popup) 매핑

| # | AS-IS Popup | 용도 | TO-BE Modal | 상태 |
|---:|---|---|---|---|
| 1 | **`DM0002_ItembyDivisionPopupEx` ⭐** | DM Item 확장 (DMF0005/0006 사용) | `ItemByDivisionModal` | ✅ 매핑 (SCM0002_ItembyDivisionPopupEx 와 동등) |
| 2 | `DM0002_ItembySmallDivPopup` | 소부서 Item | (없음) | **격차 후보** (DMF0008 사용) |
| 3 | `DM0002_MatsterChgPopup` | Master 변경 popup | (없음) | **격차** |
| 4 | `DM0002_OwnerInfoPopup` | Owner 정보 | (`OwnerModal` 가능) | (확인 필요) |
| 5 | **`DM0002_TitleSetForm_Popup` ⭐** | DM 컬럼 설정 | `ColumnSettingModal` | ✅ 매핑 |
| 6 | **`DM0020_OwnerbyDivisionPopup` ⭐** | 부서별 Owner | `OwnerByDivisionModal` | ✅ 매핑 |
| 7 | `DM0041_MDFVersionPopup` | MDF Version | (없음) | **격차** (DMF0041 특화) |
| 8 | `DMF0000_EOL_BasicMngPopup` | EOL Basic 관리 | (없음) | **격차** |
| 9 | `DMF0000_ExchangeRatePopup` | 환율 popup | (없음) | **격차 후보** (DMF0020 사용) |
| 10 | `DMF0000_VersionByWaterfallPopup` | Version Waterfall | (없음) | **격차** |
| 11 | `DMF0003_MatsterChgPopup` | Master 변경 | (없음) | **격차** |
| 12 | `DMF0003_PRHistoryPopup` | PR 이력 | (없음) | **격차** |
| 13 | `DMF0003_PRPopup` | PR 선택 | (없음) | **격차** |
| 14 | `DMF000_OwnerSet_Popup` | Owner 설정 | (`OwnerByDivisionModal` 가능) | (확인 필요) |
| 15 | `DMF000_ProjectbyDivisionPopupEx` | Project 확장 | `ProjectByDivisionModal` | ✅ 매핑 (SCM0002 와 동등) |
| 16 | `DMF0020_SalesPriceTemplatePopup` | Sales Price Template | (없음) | **격차** (DMF0020 특화) |
| 17 | `DMF0020_SaveSalesFuturePrice_Popup` | Future Price 저장 확인 | (DMF0020 작업 시 신규 modal 작성됨) | (이미 구현 — 격차 X) |
| 18 | `DMF0041_DMS_SalesSet_Popup` | DMS Sales 설정 | (없음) | **격차** |
| 19 | `DMF0042_ExchangeRatePopup` | 환율 popup (별도) | (DMF0020 작업 시 `ExchangeRateModal` 신규) | (이미 구현 — 격차 X) |
| 20 | `DMF0043_ContributeRatePopup` | Contribute Rate (DMF0043 작업) | (이미 구현) | OK |
| 21 | `DMF0043_VersionPopup` | DMF0043 Version | (이미 구현) | OK |
| 22 | `DMF0044_SalesReportExchangePopup` | Sales Report 환율 | (없음) | **격차** (DMF0044 특화) |
| 23 | `DMF0044_SalesReport_TextboxPopup` | TextBox popup | (없음) | **격차** |
| 24 | `DMF0044_United_VersionPopup` | United Version | (없음) | **격차** |
| 25 | `DMF0046_GetBODItemPrjRoutePopup` | BOD Item Project Route | (없음) | **격차** |
| 26 | `DMF0047_ItembyDivisionPopupEx` | Item 확장 (DMF0047 specific) | `ItemByDivisionModal` (재사용 가능) | ✅ 매핑 (재사용) |
| 27 | `DMF0052_GSCMDataPopup` | GSCM Data | (없음) | **격차** |
| 28 | `DMF0068_VersionPopup` | DMF0068 Version | (없음) | **격차** |
| 29 | `DMF0071_BPCutOffPopup` | BP Cut-Off | (없음) | **격차** |
| 30 | `DMF0073_VersionBySalesPricePopup` | Sales Price Version | (없음) | **격차** |

### §3.1 DM 도메인 매핑 요약

- ✅ **매핑 완료**: 6 종 (ItembyDivisionPopupEx + ItembyDivisionPopupEx_DMF0047 + ProjectbyDivisionPopupEx_DMF000 + TitleSetForm + OwnerbyDivisionPopup + DMF0020/0042/0043 작업물)
- **격차** (도메인 화면 작업 시 신규 필요): 24 종

---

## §4 도메인별 popup 통계 (FP / SCP / SSP)

| 도메인 | 폴더 | popup 수 (대략) | TO-BE 작업 시점 |
|---|---|---:|---|
| FP (Foreign Plan) | `GSCM.FP.*.UIL` | 300+ | FP 화면 작업 시 (Phase 5+) |
| SCP (Supply Chain Planning) | `GSCM.SCP.*.UIL` | 100+ | SCP 화면 작업 시 (Phase 5+) |
| SSP (Shipping Plan) | `GSCM.SSP.Plan.UIL` | 30+ | SSP 화면 작업 시 (Phase 5+) |
| DM (Demand Master) | `GSCM.DM.*.UIL` | 30 (위 §3) | Phase 5 (DM Master 우선) |
| SCM (System Master) | `GSCM.SCM.*.UIL` | 41 + 보조 (위 §2) | Phase 5 |

→ DM/SCM 우선 분석. FP/SCP/SSP 는 도메인 화면 작업 시점에 lazy 분석.

---

## §5 사용 빈도 확인 방법

> 어느 도메인 화면이 어떤 popup 을 호출하는지 — TO-BE 작업 시 우선순위 결정.

```bash
# 1. 특정 popup 의 호출 카운트
rg -l "new SCM0002_TeamPopup" GSCM/06.UIL | wc -l

# 2. 한 도메인 안의 모든 popup 호출
rg -n "new SCM0002_\w+Popup" GSCM/06.UIL/GSCM.DM.Master.UIL | head -50

# 3. popup 호출 매트릭스 (도메인 × popup)
# 별도 script — 다음 세션 작업
```

### §5.1 DM Master 도메인의 SCM0002 popup 사용 매트릭스 (이미 측정)

| AS-IS Screen | TeamPopup | CustomerPopup | StoragePopup | ItembyDivisionPopupEx | ProjectbyDivisionPopupEx | ItembyDivisionPopup | ProjectbyDivisionPopup | TitleSetForm | ItembySitePopup | CapacityPopup |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| DM0004_SalesSite | ✅ | ✅ | ✅ | - | - | - | - | - | - | - |
| DMF0004_SalesSite | ✅ | ✅ | ✅ | - | - | - | - | - | - | - |
| DM0005_PjtModelMapping | - | - | - | ✅ | ✅ | ✅ | ✅ | - | - | - |
| DMF0005_PjtModelMapping | - | - | - | (없음 = grep 미발견) | ✅ | (없음) | ✅ | - | - | - |
| DMF00051_PjtModelMapping | - | - | - | - (Ex 만) | ✅ | ✅ | ✅ | - | - | - |
| DM0006_CustomerModelMapping | - | - | - | ✅ | ✅ | - | - | - | - | - |
| DM0007_CustFcstMaster | - | - | - | - | - | - | - | (주석) | - | - |
| DM0015_BOD | - | - | - | - | - | - | - | - | ✅ | - |
| DM0036_Capacity_Allocation | - | - | - | - | - | ✅ | - | - | - | ✅ |

→ **DMF0004 의 호출**: TeamPopup, CustomerbyDivisionPopup, StoragebyDivisionPopup (3 종)
→ **SoldtobyDivisionPopup 사용처**: §5 grep 결과 미발견 — DMF0004 의 다른 곳에서 grid cell dbl-click 으로 호출 추정. **추가 확인 필요**.

---

## §6 격차 결정 우선순위

### §6.1 즉시 신규 modal 필요 (DMF0004~7 retrofit 시)

| Modal 명 | AS-IS 원본 | 사용 화면 | 우선순위 |
|---|---|---|---|
| `SoldtoByDivisionModal` | `SCM0002_SoldtobyDivisionPopup` | DMF0004 (Sold-To 컬럼 dbl-click) | ⭐ High (DMF0004 retrofit 필수) |

> DMF0004 의 SoldtobyDivisionPopup 사용처는 추가 grep 으로 확인 필요. 현재 grep 결과는 명시적 `new` 호출 미발견 → grid cell dbl-click event handler 안에서 다른 방식으로 호출되는지 정밀 확인.

### §6.2 도메인 화면 작업 시 신규 (Phase 5 lazy)

| 도메인 | 신규 modal | 사용 화면 |
|---|---|---|
| DM | `ExchangeRateModal` (DMF0042 작업 시 신규) | DMF0042, DMF0020 |
| DM | `ItembySmallDivModal` | DMF0008 |
| DM | `MdfVersionModal` | DMF0041 |
| DM | `BodItemModal` | DMF0046 |
| DM | (도메인 화면 작업 시 결정) | |
| SCM/SCP/SSP/FP | (lazy) | (도메인 화면 작업 시 결정) |

### §6.3 사용 빈도 0 / 거의 0 (격차 유지 권장)

| AS-IS popup | 사유 |
|---|---|
| `SCM0002_GetBOD*` 3 종 | BOD 시스템 deprecated 추정 |
| `SCM0002_Shipment*` 5 종 | SSP 도메인 (Phase 5+ 작업 시점) |
| `SCM0002_Jig*`, `SCM0002_Electrode*` | 제조 특화 (사용 빈도 낮음) |
| `SCM0002_ProductionPlanInsertPopup` | FP 특화 |
| `DMF0044_*` 3 종 | DMF0044 화면 작업 시 결정 |

---

## §7 Top 10 공용 popup deep-dive 우선순위 (Phase 2 다음 작업)

다음 세션에서 9 category 정밀 분석 (`__POPUP_TEMPLATE__.md` 기준):

| 우선순위 | Popup | TO-BE Modal | deep-dive 필요 사유 |
|:---:|---|---|---|
| 1 | `SCM0002_ProjectbyDivisionPopupEx` | `ProjectByDivisionModal` | DMF0005/0006 + 모든 master 사용. 격차 확인 (검색조건/표시컬럼/이벤트 4축) |
| 2 | `SCM0002_ItembyDivisionPopupEx` | `ItemByDivisionModal` | 동일 |
| 3 | `SCM0002_CustomerbyDivisionPopup` | `CustomerModal` | DMF0004 + 다수 사용 |
| 4 | `SCM0002_StoragebyDivisionPopup` | `StorageLocationModal` | DMF0004 사용 |
| 5 | `SCM0002_TeamPopup` | `TeamModal` | DMF0004 사용 |
| 6 | `SCM0002_TitleSetForm_Popup` | `ColumnSettingModal` | 모든 master 사용 (사용자별 컬럼 설정) |
| 7 | `SCM0002_CitybyCountry` | `RegionModal` | DMF0004 사용 |
| 8 | `DM0020_OwnerbyDivisionPopup` | `OwnerByDivisionModal` | DMF0020 사용 |
| 9 | **`SCM0002_SoldtobyDivisionPopup`** | **신규 `SoldtoByDivisionModal`** | DMF0004 grid cell — 격차 |
| 10 | `SCM0002_VendorPopup` | (신규 `VendorModal`) | DMF0008 / FP 등 다수 사용 추정 |

각 popup 의 deep-dive 산출:
- `_asis/01_popups/{popup-name}.md` (Phase 0 template 기준 9 category)
- 검색조건 + 표시컬럼 + 이벤트 + 콜백 데이터 정밀 인벤토리
- TO-BE modal 과 cross-check → 격차 항목 list (보강 필요 사항)

---

## §8 룰셋 v2 반영

- `_tobe/10_popup_modal.md` (Phase 4 작성)
  - §1 공용 modal 11종 + 사용 표준
  - §2 신규 modal 추가 시 의무 (위치 / Props / setSelectedValue 콜백 패턴)
  - §3 격차 식별 → 보강 항목 (Top 10 popup 의 격차 보강)
  - §4 사용 빈도 grep cross-check (PR 머지 게이트)

- 메모리 `reference_public_modals_master_components.md` (기존) 갱신 — 11 modal + 격차 후보 list (특히 `SoldtoByDivisionModal` 우선)

---

## §9 진행 / 다음 작업

- ✅ 592 popup 전수 분류 + 통계
- ✅ SCM0002_ 38 popup 인벤토리 + TO-BE 매핑 표
- ✅ DM 도메인 30 popup 인벤토리 + 매핑
- ✅ DM Master 사용 빈도 매트릭스 (DMF0004~7 + DMF0008/0015/0036)
- ✅ Top 10 deep-dive 우선순위 식별
- ⏳ **다음 세션**: Top 10 popup 의 `_asis/01_popups/{popup-name}.md` 작성 (9 category 정밀)
- ⏳ Pending: FP / SCP / SSP 도메인 popup 인벤토리 (Phase 5 도메인 화면 작업 시 lazy)
- ⏳ Pending: `SoldtobyDivisionPopup` 사용처 정밀 grep (event handler 안 호출 확인)

---

## §10 격차 정리 (Phase 2 종합)

| # | 격차 종류 | 수량 | 결정 |
|---|---|---:|---|
| 신규 modal 즉시 필요 | `SoldtoByDivisionModal` (DMF0004 retrofit 시) | 1 | **G11 후보** — 사용자 결정 |
| 신규 modal 도메인 화면 작업 시 (lazy) | ExchangeRate / ItembySmallDiv / MdfVersion / BodItem 등 | 7~10 | Phase 5 lazy |
| 격차 유지 권장 (사용 빈도 0) | BOD / Shipment / Jig / Electrode / ProductionPlan / DMF0044 specific 등 | 20+ | (a) 격차 유지 |

> **G11 후보**: `SoldtoByDivisionModal` 신규 작성 결정 — 추가 grep 으로 사용처 확인 후 결정.

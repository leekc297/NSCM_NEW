# SCP0001 Plant Site — AS-IS ↔ TO-BE 매핑 매트릭스

AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0001_PlantSite/SCP0001_PlantSite.cs`
TO-BE: `nscm-fe/features/supply/src/pages/plant-site/`
근거 설계: `design/01_layout.md`(영역1 49행) · `design/02_search-combo.md`(영역2 14행) · `design/03_grid-columns.md`(영역3 208행 + PU4)

> 주의: 이 저장소에는 AS-IS `validation.md`/`expressions.md` 원본이 없다(CLAUDE.md §9 미이관). 따라서
> `asis_mapping_gate.py --check` 자동 대조는 실행할 수 없고, 아래 매핑은 design 3영역 문서(Roslyn 백본
> gridSignals 158 / buttonGuards 29 / validations 22 를 R-01~38 로 합성)를 원천으로 한 수기 대조다.

## 1. 레이아웃/버튼 (영역1 R-01~08)

| 설계 규칙 | AS-IS 근거 | TO-BE 구현 |
|---|---|---|
| R-01 Division 권한 0건 → 조회영역 비활성 | cs:260-261 | `PlantSiteForm` noAuth(EE 제외 0건) → 5필드 disable + 조회 차단 + MSG00096 (iter-2 G5 해소) |
| R-02 활성그리드 라우팅(INSERT/DELETE) | cs:477-554 | `PlantSite.tsx` activeTab + 각 Grid `gotFocus`→`setActiveTab` |
| R-03 Delete=신규행('I') 전용 | cs:481-496 | `PlantSite.handleDelete` = `GridAction.removeRow(grid, true)` |
| R-04/R-07 편집잠금 카탈로그 | cs:517-608 | `SCM_MST_SHEET_COLUMNS.INPUT_TP_CD`(메타 정본, 05_register 미변경 — 실측 정합) |
| R-05 packer 2컬럼 행조건 잠금 | cs:525-549 | `isSiteCellRowLocked`(util) — beginningEdit·pastingCell·formatItem 3곳 공통(grid-behavior-parity §2, gap-resolve iter-1) |
| R-06 sub 편집 3중 배타 | cs:556-605 | ① sub 3그리드 beginningEdit `isMainDirty()` cancel + MSG00129 (iter-2 G6 해소) ② `PlantSiteLocationGrid`(OSP='Y' 차단) ③ `PlantSiteLocationOspGrid`(OSP='N' 차단) — 붙여넣기도 동일 게이트(pastingCell, gap-resolve iter-1) |
| R-08 시트 탭 상시 표시 | cs:393-457 | `PlantSite.tsx` TabWrapper 3탭 상시 렌더 |

## 2. 조회조건 (영역2)

| 설계 | AS-IS | TO-BE |
|---|---|---|
| Division 다중 + EE 필터 | cs:45, BLUtils.GetDivisionWithoutEE | `PlantSiteForm` `Division_SCP` + `filterEeDivisions`(ATTRIBUTE3<>'EE') |
| ALL → 권한 division 콤마 확장(권한 함정) | CString.GetCheckedListValue | `usePlantSiteStore.setPlantSiteFilters` + `expandDivisionAll` |
| Plant/Vendor·Plant Site 텍스트(UPPER LIKE) | cs Designer txt* | `PlantSiteForm` InputField → SP UPPER LIKE |
| OSP/Active YesOrNo + ALL sentinel | cs:266-270 | `PlantSiteForm` YesOrNo + `comboAllToNull` |
| p_new_yn 항상 null | cs:641 | `setPlantSiteFilters` newYn:null |

## 3. 그리드 파생/cascade/검증 (영역3 R-11~38)

| R# | AS-IS | TO-BE |
|---|---|---|
| R-11~14 Location cascade/배타 | cs:1539-1589 | `PlantSiteLocationGrid.handleCellEdit` |
| R-15 customer div→site 재조회 | cs:1591-1601 | 의도적 축소(G9) — TO-BE customer 신규행은 마스터 DIVISION/SCM_SITE 고정 복사(R-09). div 셀 편집 없음 → cascade 불요. 04 §runtime-parity |
| R-16 osp plant→storage 재조회 | cs:1929-1939 | `PlantSiteLocationOspGrid.handleCellEdit`(PLANT_ID→STORAGE clear) + 메타 재조회형 |
| R-17 Vendor 팝업(신규행 PLANT_NAME) | cs:1612-1632 | `PlantSiteGrid.setVendor`(PLANT_NAME 분기) + `deriveScmSiteId` |
| R-18 HQ Vendor 팝업 | cs:1635-1651 | `PlantSiteGrid.setVendor`(HQ 분기) |
| R-20 City 팝업 | cs:1758-1776 | `PlantSiteGrid.setCity` + `CityByCountryModal`(COM0001) |
| R-21 SCM_SITE_ID 재파생 | cs:1805-1836 | `PlantSiteGrid.handleCellEdit`(DIVISION/OP_GROUP→deriveScmSiteId) |
| R-22/23 packer 행잠금 | cs:1827-1849 | `isSiteCellRowLocked`(util) — beginningEdit·pastingCell·formatItem 공통 적용 |
| R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PLAN_PERIOD) | cs:1439-1452 | `defaultPeriodOf`(LookupCommon DEFAULT_PERIOD 조회, FP=PROD 복사) — 하드코딩 제거(gap-resolve iter-1) |
| R-10 locationOsp 신규행 SITE_DESCRIPTION 마스터 복사 | cs:1514 (GS-073) | `handleInsert` LOCATION_OSP — `selectedSite.siteDescription` 복사(gap-resolve iter-1) |
| R-24 PROD_FROZEN→FP_PLAN_PERIOD | cs:2250-2255 | `PlantSiteGrid.handleCellEdit` |
| R-25 HQ 클리어 | cs:2256-2262 | `PlantSiteGrid.handleCellEdit` |
| R-26 REP 단일성 | cs:2018-2048 | `PlantSiteCustomerGrid.handleCellEdit` |
| R-27/28 Customer 팝업+중복 | cs:2112-2171 | `PlantSiteCustomerGrid.setCustomer` + `CustomerModal`(COM0002) |
| R-05 Warranty 특례 | cs:709-723 | `PlantSiteGrid.handleCellEdit`(isWarrantyRow→A002) |
| R-31 붙여넣기 name→code(G4) | cs:2195-2238 | `PlantSiteLocationGrid.handlePaste`(dataMap.getKeyValue 역조회 + 미일치 clear+경고 §6-8②) |
| R-33 Location 필수(G1) | cs:1103-1131 | `validateLocationSave`(STORAGE 공백행 FACTORY/OPERATION 필수) → `PlantSite.handleSave` 저장 차단 |
| R-34 Location 중복(G2) | cs:1947-2016 | `validateLocationSave`(STORAGE / (FACTORY,OPERATION) 전행 비교) → 저장 차단 |
| R-38 customer 신규필수(G3) | cs:1246-1253 | `validateCustomerSave`(신규행 SOLDTO/SHIPTO 공백) → `PlantSite.handleSave` 저장 차단 |
| R-06① main dirty↔sub 배타(G6) | cs:556-560 | sub 3그리드 beginningEdit `isMainDirty()` → cancel + MSG00129 |
| R-32 편집 중 탭 전환 차단(G8) | cs:2095-2104 | `PlantSite.handleLowerTabChange`(현재 탭 dirty 시 전환 차단 + MSG00130), TabWrapper 제어형 |
| site.DIVISION_ID 셀 EE 필터(G7) | dtMyDivision=GetDivisionWithoutEE | 메타 `Division_SCP_NoEE`(05_register [5], ATTRIBUTE3<>'EE') 로 셀 repoint |
| 셀 병합(G10) | cs:364-445 전 컬럼 FPMerge.None + 2189 SmartColMerge no-op | main `allowMerging` 제거 — 병합 없음이 AS-IS 파리티(sub 도 없음) |

## 4. 저장 (영역3 §4.2)

| SP | TO-BE |
|---|---|
| SAVE_PLANT_SITE (vmiYn='N', FlagD→validYn='N') | `PlantSite.handleSave` SITE case (VMI_YN 주입 + FlagD validYn) |
| SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP | `PlantSite.handleSave` 시트별 `useProcMutation` + `saveWithValidation` + 커스텀검증(R-33/34/38) |

## 5. MSG 코드 역조회 (iter-2 hook #114 실측 — ora.py TO-BE SCM_ADM_MSG_M)

주의: AS-IS MSG_ID 를 그대로 쓰면 안 된다 — TO-BE 는 같은 번호가 부재이거나 의미가 다르다(실측).

| 용도(AS-IS) | AS-IS ID | TO-BE ID(실측) | TO-BE 문구 |
|---|---|---|---|
| 필수값 공백(R-33) | MSG00002 | **MSG00614** | The {0} value is required. (AS-IS MSG00002 는 TO-BE 에서 'Saved successfully.' — 재사용 금지) |
| 중복 키(R-34/28) | MSG00060 | MSG00060 | Duplicate key exists. (의미 동일 — 유지) |
| customer 신규필수(R-38) | MSG00120 | **MSG01144** | Ship To, Sold To, and Rep Y/N are mandatory columns (TO-BE MSG00120 부재) |
| Rep 단일성(R-26) | MSG00149 | **MSG00028** | Only one record with Rep YN = Y can exist... (TO-BE MSG00149 부재) |
| 외주 Location 불가(R-06②) | MSG00168 | **MSG01183** | Outsourcing Vendor locations can not be registered. |
| 외주만 Location(OSP)(R-06③) | MSG00224 | **MSG01235** | Only Outsourcing Vendors can register Location (OSP). |
| 마스터 미선택(R-06 Insert) | MSG00161 | **MSG00014** | No row selected. |
| 권한 division 0(R-01) | (SetDivisionAuthCheck) | **MSG00096** | No permission. |
| main/sub 편집 배타(R-06①) | MSG00130 | **MSG00129** | Sheet-specific edit mode notice. (TO-BE 는 의미가 AS-IS 와 뒤바뀜) |
| 탭 전환 차단(R-32) | MSG00129 | **MSG00130** | You have unsaved changes. Switch sheet? (TO-BE 는 의미가 AS-IS 와 뒤바뀜) |
| 붙여넣기 미일치(R-31) | (NullRef) | **MSG01079** | Not existing {0}. (§6-8② 교정) |

## 6. 미구현/잔여 (정직 보고 — 04_react-gap.md 와 동기화)

- G12(저) Warranty Op.Group 'W' 옵션: OPERATION_GROUP='W' 기존행 편집 시 콤보에 W 추가 — per-row 콤보
  옵션은 정적 메타(LookupCommon P/A/E)로 재현 불가(W 를 lookup 에 넣으면 신규행에도 노출돼 오히려 오차).
  W 행 값 자체는 저장·표시에 보존됨. LOGISTIC A002 고정은 구현. 커스텀 셀 에디터는 사용자 결정 대기.
- 런타임 육안(병합 시각/드롭다운/toast/조작감) — 사용자 확인 축.

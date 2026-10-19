# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:CityByCountryModal | FE 실존 모달 (components/modals/CityByCountryModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | `PlantSiteGrid.tsx` setCity + `components/modals/CityByCountryModal.tsx` | PU-06(SCM0002_CitybyCountry, cs:1765) 대응 — R-20 | 구현 |
| MODAL:CustomerModal | FE 실존 모달 (components/modals/CustomerModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | `PlantSiteCustomerGrid.tsx` setCustomer + `components/modals/CustomerModal.tsx` | PU-07(SCM0002_PlantCustomerbyDivisionPopup, cs:2130) 대응 — R-27/28 | 구현 |
| MODAL:FPModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | — | 정규식 오탐(RE_MD_POPUP 이 `00_checklist.md:469` 산문 "셀유형 FPModal/FPButton 후보"의 일반 용어를 팝업 식별자로 오추출) — 실제 팝업은 PU-04~07 이며 아래 VendorModal/CityByCountryModal/CustomerModal 행으로 매핑 완료 | 해당없음 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | — | 정규식 오탐(`00_checklist.md` §4e "반환" 열의 공통 트리거 문자열 "ShowDialog"가 팝업명으로 오추출) — 실제 팝업 4건(PU-04~07)은 VendorModal ×2·CityByCountryModal·CustomerModal 행으로 이미 매핑됨 | 해당없음 |
| MODAL:VendorModal | FE 실존 모달 (components/modals/VendorModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | `PlantSiteGrid.tsx` setVendor + `components/modals/VendorModal.tsx` | PU-04(SCM0002_VendorPopup, cs:1616)·PU-05(HQ Vendor, cs:1637) 대응 — R-17/18 | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | `nscm-fe/packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1118~1130`(신규행 필터예외 집합 + itemsSourceChanged 복원) | 공용 DataGrid 표준 배선(화면별 배선 불요) — plant-site 4그리드 전부 DataGrid 사용 | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | `nscm-fe/packages/shared/src/stores/useDirtyRegistry.ts:110~134`(confirmIfDirtyKey 'search') + `nscm-fe/packages/shared/src/components/organisms/search-area/SearchArea.tsx:115`/`nscm-fe/packages/shared/src/components/organisms/sub-title/SubTitle.tsx:198` 호출 | 공용 표준 배선. TO-BE 실제 메시지 코드는 MSG00704(검색용, useDirtyRegistry.ts:110) — 원표의 MSG00703 은 화면 닫기용('close' kind)과 혼동 표기, 문구·동작 자체는 등가 | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | `nscm-fe/packages/shared/src/components/organisms/data-grid/DataGrid.tsx:680~709` handleColumnSettingsSave | **미구현(공용 컴포넌트 결함, 화면 범위 밖)** — 컬럼 레이아웃 저장 시 titleSet invalidate·그리드 레이아웃 재적용만 하고 조회 데이터 reset·재조회 유도는 없음(`ColumnLayoutModal.tsx:449~450` 주석상 2026-09-08 에 오히려 "무변경 시 Reset 하던 동작"을 제거한 이력). plant-site 는 비PIVOT(MEASURE 0, iter-1 G14) 이라 Measure 축 영향은 없음. 수정 시 전 화면 영향(Hard Boundary 밖) — 별도 activity(공용 컴포넌트) 필요 | 미구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | `nscm-fe/packages/shared/src/hooks/useCustomQueryClient.ts:203`(useProcMutation 표준 성공 toast MSG00002) | 공용 표준 배선 — plant-site 저장은 handleSave(PlantSite.tsx)가 시트별 useProcMutation 경유(CLAUDE.md §6 표준 호출) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | `nscm-fe/packages/foundation/src/utils/gridAction.ts:1093~1097`(liveDataMaps 채집 후 재구성 컬럼에 주입) | 공용 표준 배선(2026-08-12 통합테스트 1st No.60-① 결함 수정 이력 그대로 승계) | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | — | G06 과 동일 항목(notes.md 미해결 표) — Plant/Vendor·Plant Site 조회조건은 (a) SP UPPER LIKE 단일 텍스트 계약을 정본으로 유지 중(02 §7-3). 콤마 다중검색은 (b) 전환안(전용 CMBO+SP IN 계약)에 포함되며 사용자 결정 대기 | 제외 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | `nscm-fe/packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1481~1483`(columnGroups 재대입 후 rebindFilterColumns 호출) | 공용 DataGrid 표준 배선 | 구현 |

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
| R-32 편집 중 탭 전환 차단(G8) | cs:2095-2104 | `PlantSite.handleLowerTabChange`(현재 탭 dirty 시 전환 차단 + MSG01468 신규 채번, 확인 1개뿐인 하드 블록 — AS-IS 캡처 실측 2026-09-28), TabWrapper 제어형 |
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
| 마스터 미선택(P-06, Insert 방어) | **정정(2026-09-28 독립 감사)**: 없음 — `MSG00161`/`nMainSelRow` 는 이 화면 AS-IS 소스에 부재(grep 0건, SCP0020/0021/0042 관용구를 오인용) | **MSG00014** | No row selected. — TO-BE 의도적 추가(AS-IS 재현 아님, P-06) |
| 권한 division 0(R-01) | (SetDivisionAuthCheck) | **MSG00096** | No permission. |
| main/sub 편집 배타(R-06①) | MSG00130 | **MSG00129** | Sheet-specific edit mode notice. (`{0}` 없는 문구 — 이 화면에서 그대로 사용 중) |
| 탭 전환 차단(R-32) | MSG00129 | **MSG01468**(신규 채번) | You are modifying {0} and can not change the sheet. (정정 2026-09-28: 이전 서술은 MSG00130 "You have unsaved changes. Switch sheet?"를 Yes/No 확인으로 오판했으나, AS-IS 캡처 실측 결과 확인 버튼 1개뿐인 하드 블록이었다. `{0}` 치환이 필요해 MSG00129 재사용은 금지되고, Workbench/opt-capa 의 MSG01149 재사용 대신 이 화면 전용으로 DB 최대 번호(MSG01467, MSG99999 sentinel 제외) 다음 값을 신규 채번했다 — `05_register.sql` [14]) |
| 붙여넣기 미일치(R-31) | (NullRef) | **MSG01079** | Not existing {0}. (§6-8② 교정) |

## 6. 미구현/잔여 (정직 보고 — 04_react-gap.md 와 동기화)

- G02/D-02(해소, 2026-09-28) Warranty Op.Group 'W' 옵션: OPERATION_GROUP='W' 기존행 편집 시 콤보에 W
  추가(R-05a) — AS-IS `SetCellTypeCombo(iRow,...)`(cs:709)와 동일하게 행 단위로만 재현하도록
  `PlantSiteGrid.tsx` 에 Wijmo `DataMap.getDisplayValues(rowItem)` 행별 오버라이드 구현(사용자 결정,
  project-route-warranty DIVISION_ID 패턴 준용). 신규행·다른 P/A/E 행에는 W 미노출.
- G02-b(해소, 2026-09-28) Warranty Logistic Plant 드롭다운 단일 제한(R-05b): AS-IS 원본 소스
  (`GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0001_PlantSite/SCP0001_PlantSite.cs` — 이 레포에 실존,
  `InitData()` 240-246행이 `dtLogisticW={CODE:"A002",NAME:"A002"}` 리터럴 생성, `SetWarranty()`
  702-716행이 Warranty 행마다 `SetCellTypeCombo(iRow, LOGISTIC_PLANT_ID, dtLogisticW)`(710행)로
  드롭다운을 A002 단일 옵션으로 교체) 확인 후 구현. A002는 공장 마스터(`SCM_MST_PLANT_SN`)에 없는
  코드라(DB 실측) 서버 조회 대신 클라 리터럴로 합성 — `PlantSiteGrid.tsx` 에 OPERATION_GROUP과 동일한
  `DataMap.getDisplayValues` 행별 패턴 적용, 그 외 행은 기존 division 필터(`ATTRIBUTE2=DIVISION_ID:DIVISION_ID`)
  그대로 재현. Op.Group→A002 값 강제 대입(`PlantSiteGrid.tsx:191-192`)은 기존대로 유지.
- G03(해소, 2026-09-28) 런타임 육안(병합 시각/드롭다운/toast/조작감): 사용자가 브라우저로 8항목(FROZEN_TYPE
  드롭다운 65행 렌더·SHIP_FROZEN 미표시·하단 탭 캡션·location 콤보 좁힘·병합 없음·저장 toast·false-success·
  팝업 재오픈 검색조건 유지) 전건 직접 확인 완료.
- G04(해소, 2026-09-28) 하단 탭 라벨(`LBL01147`/`LBL01148`) KO/CN: "정식 번역" 대신 EN 문구를 KO/CN 에도
  그대로 쓰는 것으로 사용자 최종 결정. 추가 번역 등록 불요.

# SSP0017 InventoryRaw — AS-IS ↔ TO-BE 매핑

> 원문 근거: `.atlas/gscm-design/SSP0017/design/00_checklist.md`(Roslyn 인덱스 백본) ·
> `01_layout.md` · `02_search-combo.md` · `03_grid-columns.md`. 이 문서는 그 표들을
> 코드 파일 단위로 재정리한 대사표다 — 세부 근거(파일:라인)는 각 design 문서를 참조.

## 컨트롤/레이아웃 (design 01)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| `usrConditionPanel1`(HidePanel) + `usrLayoutControl2`/`layoutControlGroup2` | `MainTitle` openSearchArea + `InventoryRawForm`(SearchArea) | 구현 |
| `panel1`(Dock=Fill) → `spdMain` | `InventoryRawGrid`(DataGrid) | 구현 |
| `usrButton1`(미배선 죽은 컨트롤) | 이식 불요 | 해당 없음(확인 완료) |
| `imageList1`(edit.png, cellTypeImage) | 미적용 대상 칼럼 미확정(design 01 §5#3) | 확인 필요 |

## 조회조건 (design 02)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| `clbDivision`(고정 "40"+disabled, `MyDivisionInEE_SCP`) | `InventoryRawForm` Division 필드(disabled) | 구현 |
| `clbPlantSite`(Division EE 분기 2종 SQL_ID) | `plantSiteFilter` comboId 동적 스위칭 | 구현 |
| `cboInventoryType`(`LookupCommon`/INV_TYPE) | `useTabLookupQueries({lookupType:'INV_TYPE'})` | 구현 |
| `cboPlanDate`(`PlanDateShip`) | `COMBO.PLAN_DATE='PlanDateShip'`(동명 SQL_ID 실측) + 목록 첫 행[0] 자동선택 | 구현(2026-10-14 해소, 아래 §해소 1) |
| `txtItemId`+`btnItemId`(`SCM0002_ItembyDivisionPopup`) | 공용 `MaterialByDivisionModal`(COM0013) | 구현(**의도적 드리프트** — 아래 §드리프트) |
| `DataUtil.checkRequiredOfSearch` alert 문구(MSG00614) | `handleSearch` 에서 `.replace('{0}', LBL00039)` 치환 | 구현(2026-10-14 수정 — i18next 는 `{0}` 를 안 채운다, MSG-03) |
| `clbDivision_SelectedIndexChanged`(cascade) | comboId/comboParam 재조회(react-query 키 변경) | 구현(Division 자체가 disabled라 초기 mount 1회만 실효) |
| `DataUtil.checkRequiredOfSearch`("Plan-date*") | `handleSearch` 내 `sc.planStartYyyymmdd` 가드 | 구현(값 소스는 위 확인 필요와 연동) |

## 그리드 (design 03)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| `LockColumn(0, max, true)`(조회 직후 전 컬럼 잠금) | admin 메타 `INPUT_TP_CD='S'` 31행 전부(ora.py 실측) → DataGrid 기본 lock | 구현(메타 이미 등록, 신규 반영 불요) |
| 컬럼 31개(DB메타, hidden 4건) | `fetchStaticColumns` → `InventoryRawGrid staticColumns` | 구현 |
| `INVENTORY_TYPE`/`INVENTORY_STATUS` 셀 콤보 | admin 메타 `CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox'` 자동 배선 | 구현(메타 이미 등록) |
| `InitSpreadFooterSum()`(cs:213-233 — Sum 라벨, LightGray, `{0:#,##0.###}`, SumIgnoreHidden) | `useAggregationRow` + `InventoryRawGrid` effect: wijmo Column 에 `Aggregate.Sum` 직접 대입(`updatedLayout` 마다 재적용) + `formatItem`(ColumnFooter 한정 서식·배경) + `bottomLeftCells` 'Sum' | 구현(2026-10-15 수정 — 종전 raw 컬럼메타에 `aggregate` 를 얹던 방식은 공용 `toLeafColumn` 이 메타를 재조립하며 버려 **합계가 한 건도 안 나왔다**. 자매 SSP0021 과 동일 처방) |
| `SmartColMerge()`(스크롤 재계산) | `allowMerging={AllowMerging.Cells}` | 구현(런타임 시각 확인 필요) |
| `btnMeasure_Click` → `SCM0002_TitleSetForm_Popup("SSP0001",...)` | 버튼 노출 유지, 클릭 시 결정 대기 알림만(팝업 미오픈) — design 03 §2/§4 | **확인 필요(사용자 결정)** |
| `Insert/Delete/Edit/SaveButton` override(전부 NO-OP) | `hotkeyConfig` 명시적 무동작 함수 4종 | 구현 |
| `siMain.Query(dsBinding)`(SP 바인딩) | `useTabProcQuery` → `o_rc1` | 구현(`PKG_SSP0017` VALID 배포 확인 — ora.py 실측 2026-10-15) |
| (AS-IS 상당 없음 — FPNumber 빈 셀) | `InventoryRaw.tsx` rows: `EXPIRATION_QTY ?? 0` | **의도적 드리프트**(사용자 지시 2026-10-15) — 원천 NULL 194,935/803,818행(ora.py 실측)이고 BE 가 NULL 키를 응답에서 빼 빈칸으로 오던 것을 0 표기로 보정 |

## 죽은 코드(이식 불요, design 00 §5 확정)

`GetDivision()`/`GetDayRange()`/`GetShipType()`/`GetShipToParty()`/`GetSoldToParty()`/
`CboPeriod_SelectedIndexChanged` — 파일 내 호출부 0건 확정, TO-BE 미이식.

## 의도적 드리프트 (AS-IS 와 다르게 구현, 근거 있음)

**Model/Nickname 팝업 — `SCM0002_ItembyDivisionPopup` → 공용 `MaterialByDivisionModal`(COM0013)**
사용자 지시 2026-10-14. 자매 SSP0003/SSP0019/SSP0026 의 교체 선례와 같은 규약이다.
AS-IS 는 `SSP0017_InventoryRaw.cs:291` 에서 `new SCM0002_ItembyDivisionPopup()` 을 열므로
엄밀히는 `ItemByDivisionModal`(COM0008)이 1:1 대응이고, **조회 SP 가
`SCM.SCM0002_GET_ITEM_BY_DIVISION_POPUP` → `PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION`
으로 바뀐다**. `scpModuleType` 에 SSP 화면 ID 는 SP 에 열거돼 있지 않아 기본 ELSE 분기를 타
기본 Material 목록을 돌려준다(자매 화면 실측). 라벨도 `LBL00669`('Model') →
`LBL00618`('Model/Nickname')로 교체했다(DB KO/EN/CN 전건 `USE_YN='Y'` 실측 → 등록 요청 불요).
이 화면 Division 은 '40' 고정 단일이라 `multiDivision` 과 'ALL' 센티널은 쓰지 않는다.

## 해소된 확인 필요

1. **Plan Date 콤보(해소, 2026-10-14)** — `SCM_ADM_CMBO_SQL_M` 에 AS-IS 와 **동명인
   `PlanDateShip`**(`USE_YN='Y'`)이 실재하고 본문도 `SSP_PLAN_VERSION_V` 의
   `PLAN_START_YYYYMMDD` 를 `@divisionId` 로 거르는 AS-IS 등가다(ora.py 실측). 설계 당시
   "미등록" 판정은 별개 콤보 `PlanDateShipReq40_SCP`(원천 `SSP_MST_SHIP_REQ`)만 보고 내린
   오판이었고, 그 사이 콤보가 빈 목록·disabled 라 Plan Date 필수검증에 걸려 **조회 자체가
   불가능**했다. 기본 선택값은 목록 첫 행[0](= 최신 Plan, 콤보 SQL `ORDER BY CODE DESC`) —
   AS-IS `cs:364` 주석("기본값 설정하기위해 division만 가지고 우선 조회") + `cs:366`
   `setListBox(...,"CODE","NAME")` 5인자 오버로드의 `DataSource` 바인딩(WinForms 자동 첫행 선택)
   + `cs:168` `ConditionNotUseList.Add(cboPlanDate)`(조회조건 저장 제외) 근거.

## 잔여 확인 필요 (정직 보고)

1. `btnMeasure` 크로스화면(SSP0001) 참조 — 그대로 재현 vs 버튼 숨김 사용자 결정 필요. design 03 §4
   권고대로 버튼은 노출하되, 실제 SSP0001 팝업은 열지 않고 결정 대기 알림만 표시한다(잘못
   구현해 SSP0001 메타를 실수로 바꾸는 위험 회피).
2. SP `SSP.SSP0017_GET_INVENTORY_RAW` 미배포 — 런타임 조회 동작(반환 컬럼 실측 대조 포함)은
   `convert-sp` 완료 후 검증.

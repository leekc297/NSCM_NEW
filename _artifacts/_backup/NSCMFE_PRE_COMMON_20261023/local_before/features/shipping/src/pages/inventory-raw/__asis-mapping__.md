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
| `cboPlanDate`(`PlanDateShip`) | `PLAN_DATE_COMBO_UNRESOLVED` — 빈 슬롯만 렌더 | **확인 필요(FAIL 후보)** |
| `txtItemId`+`btnItemId`(`SCM0002_ItembyDivisionPopup`) | `ItemByDivisionModal` | 구현 |
| `clbDivision_SelectedIndexChanged`(cascade) | comboId/comboParam 재조회(react-query 키 변경) | 구현(Division 자체가 disabled라 초기 mount 1회만 실효) |
| `DataUtil.checkRequiredOfSearch`("Plan-date*") | `handleSearch` 내 `sc.planStartYyyymmdd` 가드 | 구현(값 소스는 위 확인 필요와 연동) |

## 그리드 (design 03)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| `LockColumn(0, max, true)`(조회 직후 전 컬럼 잠금) | admin 메타 `INPUT_TP_CD='S'` 31행 전부(ora.py 실측) → DataGrid 기본 lock | 구현(메타 이미 등록, 신규 반영 불요) |
| 컬럼 31개(DB메타, hidden 4건) | `fetchStaticColumns` → `InventoryRawGrid staticColumns` | 구현 |
| `INVENTORY_TYPE`/`INVENTORY_STATUS` 셀 콤보 | admin 메타 `CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox'` 자동 배선 | 구현(메타 이미 등록) |
| `ColumnFooter`(Sum, LightGray, `#,##0.###`) | `useAggregationRow` + 5컬럼 `aggregate: Aggregate.Sum` | 구현(Wijmo 표준 합계행 — Footer 셀 배경색·"Sum" 라벨 정확 재현 여부는 육안 확인 필요) |
| `SmartColMerge()`(스크롤 재계산) | `allowMerging={AllowMerging.Cells}` | 구현(런타임 시각 확인 필요) |
| `btnMeasure_Click` → `SCM0002_TitleSetForm_Popup("SSP0001",...)` | 버튼 노출 유지, 클릭 시 결정 대기 알림만(팝업 미오픈) — design 03 §2/§4 | **확인 필요(사용자 결정)** |
| `Insert/Delete/Edit/SaveButton` override(전부 NO-OP) | `hotkeyConfig` 명시적 무동작 함수 4종 | 구현 |
| `siMain.Query(dsBinding)`(SP 바인딩) | `useTabProcQuery` → `o_rc1` | 구현(SP `PKG_SSP0017` MISSING — convert-sp 후속, 런타임 미검증) |

## 죽은 코드(이식 불요, design 00 §5 확정)

`GetDivision()`/`GetDayRange()`/`GetShipType()`/`GetShipToParty()`/`GetSoldToParty()`/
`CboPeriod_SelectedIndexChanged` — 파일 내 호출부 0건 확정, TO-BE 미이식.

## 잔여 확인 필요 (정직 보고)

1. Plan Date 콤보 SQL_ID(`PlanDateShip`) — TO-BE `SCM_ADM_CMBO_SQL_M` 미등록, AS-IS MSSQL 접속
   ERROR(이 activity 세션도 재확인: 로그인 타임아웃)로 원본 대조 불가.
2. `btnMeasure` 크로스화면(SSP0001) 참조 — 그대로 재현 vs 버튼 숨김 사용자 결정 필요. design 03 §4
   권고대로 버튼은 노출하되, 실제 SSP0001 팝업은 열지 않고 결정 대기 알림만 표시한다(잘못
   구현해 SSP0001 메타를 실수로 바꾸는 위험 회피).
3. SP `SSP.SSP0017_GET_INVENTORY_RAW` 미배포 — 런타임 조회 동작(반환 컬럼 실측 대조 포함)은
   `convert-sp` 완료 후 검증.

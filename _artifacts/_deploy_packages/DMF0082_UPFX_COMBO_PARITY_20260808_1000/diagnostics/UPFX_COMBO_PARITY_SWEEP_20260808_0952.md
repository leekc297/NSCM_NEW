# 전 화면 UP_FX 콤보 파라미터 정합 — 진단 매트릭스

> 실행 2026-08-08 09:52 · `_artifacts/_diagnostics/upfx_combo_sweep.py` · **읽기 전용(코드 수정 0)**
> 룰 = hook #117 §5.5~§5.10 · 판정 로직 = `ui_gate_runner.py` 섹션 7 재사용
> 수정은 각 화면 작업 시점(T01M)에 적용한다 — 일괄 소급 작업 아님(#124 §3 방식).

## 판정 기준

BE `BaseService.makeComboQuery` 는 `@토큰` 을 **raw 치환**하고 미전달 토큰을 `''` 로 채운다.
Oracle 에서 `''` = NULL 이므로:

- **FAIL** — 비관대형(`COL = @t`) + 미전달 → **0행**. 콤보가 비고 그리드는 CODE 를 raw 로 표시한다.
- **WARN** — 관대형(`@t IS NULL OR …` / `NVL(TRIM(@t),'ALL')='ALL' OR …` / `CASE @t …`) + 미전달 → 무필터(전체 목록).
  AS-IS 가 실제로 필터했는지 대조 필요(과다 노출은 저장값 오염으로 이어질 수 있음).
- **PASS** — 필요 토큰 전부 전달.

## 요약 — FAIL **6** / WARN **60** / PASS **9** (화면 17개 · 파라미터 보유 콤보 75건)

### ⛔ FAIL (0행 = 조용한 빈 콤보)

| 화면 | SQL_ID | 필요 토큰 | 미전달 | 사유 |
|---|---|---|---|---|
| DMF0021 | Measure | mnuId | mnuId | 비관대형 미전달 → 0행(코드 raw 표시) |
| DMF0022 | Measure | mnuId | mnuId | 비관대형 미전달 → 0행(코드 raw 표시) |
| DMF0035 | Measure | mnuId | mnuId | 비관대형 미전달 → 0행(코드 raw 표시) |
| DMF0042 | DM_LOOKUP_DIV | param1, param2 | param1, param2 | 비관대형 미전달 → 0행(코드 raw 표시) |
| DMF0044 | DM_LOOKUP_DIV | param1, param2 | param1, param2 | 비관대형 미전달 → 0행(코드 raw 표시) |
| DMF0048 | Measure | mnuId | mnuId | 비관대형 미전달 → 0행(코드 raw 표시) |

### ⚠ WARN (관대형 무전달 = 무필터)

| 화면 | SQL_ID | 필요 토큰 | 미전달 |
|---|---|---|---|
| DMF0003 | PlantByDivisionCompany | companyId, divisionId | companyId |
| DMF0003 | SiteByEndCustomer | divisionId, endCustomer | endCustomer |
| DMF0004 | Division | divisionId | divisionId |
| DMF0004 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer |
| DMF0005 | CompanySalesSite | divisionId, scmSiteId | divisionId, scmSiteId |
| DMF0005 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId |
| DMF0005 | PlantByDivisionCompany | companyId, divisionId | companyId, divisionId |
| DMF0005 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer |
| DMF0005 | TeambyDivision | langCd | langCd |
| DMF0005 | TeambyDivision2 | langCd | langCd |
| DMF0006 | Division | divisionId | divisionId |
| DMF0006 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer |
| DMF0006 | TeambyDivision | langCd | langCd |
| DMF0007 | Division | divisionId | divisionId |
| DMF0007 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId |
| DMF0007 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer |
| DMF0008 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId |
| DMF0008 | SalesCompany | Param1, Param2, Param3, Param4, divisionId, plantId | Param1, Param2, Param3, Param4, divisionId, plantId |
| DMF0008 | SalesPlant | Param1, Param2, Param3, Param4, companyId, divisionId | Param1, Param2, Param3, Param4, companyId, divisionId |
| DMF0008 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer |
| DMF0008 | TeambyDivision | langCd | langCd |
| DMF0020 | BizTypeByDivision | divisionId | divisionId |
| DMF0020 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId |
| DMF0020 | FromSiteByDivision | divisionId | divisionId |
| DMF0020 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer |
| DMF0020 | TeambyDivision | langCd | langCd |
| DMF0021 | BizTypeByDivision | divisionId | divisionId |
| DMF0021 | CELL_PROD_SITE_ID | divisionId, itemId | divisionId, itemId |
| DMF0021 | Division | divisionId | divisionId |
| DMF0021 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId |
| DMF0021 | FromSiteByDivision | divisionId | divisionId |
| DMF0021 | SiteByEndCustomer_InnerCode | divisionId | divisionId |
| DMF0022 | BizTypeByDivision | divisionId | divisionId |
| DMF0022 | CELL_PROD_SITE_ID | divisionId, itemId | divisionId, itemId |
| DMF0022 | Division | divisionId | divisionId |
| DMF0022 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId |
| DMF0022 | FromSiteByDivision | divisionId | divisionId |
| DMF0035 | BizTypeByDivision | divisionId | divisionId |
| DMF0035 | Division | divisionId | divisionId |
| DMF0035 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId |
| DMF0035 | PlantSitebyEndCustomer | divisionId, endCustomer | divisionId, endCustomer |
| DMF0035 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer |
| DMF0042 | DMF0042_BP_Measure | divisionId | divisionId |
| DMF0042 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId |
| DMF0042 | FromSiteByDivision | divisionId | divisionId |
| DMF0042 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer |
| DMF0043 | DMF0043_UPPER_DEPT | langCd | langCd |
| DMF0043 | TeambyDivision2 | langCd | langCd |
| DMF0048 | BizTypeByDivision | divisionId | divisionId |
| DMF0048 | Division | divisionId | divisionId |
| DMF0048 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId |
| DMF0048 | FromSiteByDivision | divisionId | divisionId |
| DMF0048 | SiteByEndCustomer_InnerCode | divisionId | divisionId |
| DMF0049 | DMF0044_DEPARTMENT_TEAM2 | divisionId | divisionId |
| DMF0049 | DMF0044_MDF_DEPARTMENT | divisionId | divisionId |
| DMF0049 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId |
| DMF0072 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId |
| DMF0072 | SiteByEndCustomer_InnerCode | divisionId | divisionId |
| DMF0082 | EndCustomerByDivisionDept | deptId, divisionId | deptId |
| DMF0082 | PlantByDivisionCompany | companyId, divisionId | companyId |

### ⛔ quoting 누락 (hook #117 §5.7 — ORA-00904/01722)

| 화면 | 파일 | SQL_ID | 키 | 값 |
|---|---|---|---|---|
| DMF0048 | `components/SalesMonitoringForm.tsx` | SalesPlant | `divisionId` | `sc.divisionId` |
| DMF0049 | `EtcSalesReports.tsx` | DM_LOOKUP_DIV | `param1` | `sc.divisionId` |
| DMF0049 | `EtcSalesReports.tsx` | DM_LOOKUP_DIV | `param2` | `EDIT_MEASURE_LOOKUP` |

### 전체 매트릭스

| 화면 | SQL_ID | 필요 토큰 | 미전달 | 판정 |
|---|---|---|---|---|
| DMF0003 | AS_FROM_SITE | param1 | - | ✅ PASS |
| DMF0003 | Measure | mnuId | - | ✅ PASS |
| DMF0003 | PlantByDivisionCompany | companyId, divisionId | companyId | ⚠ WARN |
| DMF0003 | SiteByEndCustomer | divisionId, endCustomer | endCustomer | ⚠ WARN |
| DMF0004 | Division | divisionId | divisionId | ⚠ WARN |
| DMF0004 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer | ⚠ WARN |
| DMF0005 | CompanySalesSite | divisionId, scmSiteId | divisionId, scmSiteId | ⚠ WARN |
| DMF0005 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId | ⚠ WARN |
| DMF0005 | PlantByDivisionCompany | companyId, divisionId | companyId, divisionId | ⚠ WARN |
| DMF0005 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer | ⚠ WARN |
| DMF0005 | TeambyDivision | langCd | langCd | ⚠ WARN |
| DMF0005 | TeambyDivision2 | langCd | langCd | ⚠ WARN |
| DMF0006 | Division | divisionId | divisionId | ⚠ WARN |
| DMF0006 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer | ⚠ WARN |
| DMF0006 | TeambyDivision | langCd | langCd | ⚠ WARN |
| DMF0007 | Division | divisionId | divisionId | ⚠ WARN |
| DMF0007 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId | ⚠ WARN |
| DMF0007 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer | ⚠ WARN |
| DMF0008 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId | ⚠ WARN |
| DMF0008 | SalesCompany | Param1, Param2, Param3, Param4, divisionId, plantId | Param1, Param2, Param3, Param4, divisionId, plantId | ⚠ WARN |
| DMF0008 | SalesPlant | Param1, Param2, Param3, Param4, companyId, divisionId | Param1, Param2, Param3, Param4, companyId, divisionId | ⚠ WARN |
| DMF0008 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer | ⚠ WARN |
| DMF0008 | TeambyDivision | langCd | langCd | ⚠ WARN |
| DMF0020 | BizTypeByDivision | divisionId | divisionId | ⚠ WARN |
| DMF0020 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId | ⚠ WARN |
| DMF0020 | FromSiteByDivision | divisionId | divisionId | ⚠ WARN |
| DMF0020 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer | ⚠ WARN |
| DMF0020 | TeambyDivision | langCd | langCd | ⚠ WARN |
| DMF0021 | BizTypeByDivision | divisionId | divisionId | ⚠ WARN |
| DMF0021 | CELL_PROD_SITE_ID | divisionId, itemId | divisionId, itemId | ⚠ WARN |
| DMF0021 | Division | divisionId | divisionId | ⚠ WARN |
| DMF0021 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId | ⚠ WARN |
| DMF0021 | FromSiteByDivision | divisionId | divisionId | ⚠ WARN |
| DMF0021 | Measure | mnuId | mnuId | ⛔ FAIL |
| DMF0021 | SiteByEndCustomer_InnerCode | divisionId | divisionId | ⚠ WARN |
| DMF0022 | BizTypeByDivision | divisionId | divisionId | ⚠ WARN |
| DMF0022 | CELL_PROD_SITE_ID | divisionId, itemId | divisionId, itemId | ⚠ WARN |
| DMF0022 | Division | divisionId | divisionId | ⚠ WARN |
| DMF0022 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId | ⚠ WARN |
| DMF0022 | FromSiteByDivision | divisionId | divisionId | ⚠ WARN |
| DMF0022 | Measure | mnuId | mnuId | ⛔ FAIL |
| DMF0035 | BizTypeByDivision | divisionId | divisionId | ⚠ WARN |
| DMF0035 | Division | divisionId | divisionId | ⚠ WARN |
| DMF0035 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId | ⚠ WARN |
| DMF0035 | Measure | mnuId | mnuId | ⛔ FAIL |
| DMF0035 | PlantSitebyEndCustomer | divisionId, endCustomer | divisionId, endCustomer | ⚠ WARN |
| DMF0035 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer | ⚠ WARN |
| DMF0042 | DMF0042_BP_Measure | divisionId | divisionId | ⚠ WARN |
| DMF0042 | DM_LOOKUP_DIV | param1, param2 | param1, param2 | ⛔ FAIL |
| DMF0042 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId | ⚠ WARN |
| DMF0042 | FromSiteByDivision | divisionId | divisionId | ⚠ WARN |
| DMF0042 | SiteByEndCustomer | divisionId, endCustomer | divisionId, endCustomer | ⚠ WARN |
| DMF0043 | DMF0043_UPPER_DEPT | langCd | langCd | ⚠ WARN |
| DMF0043 | TeambyDivision2 | langCd | langCd | ⚠ WARN |
| DMF0044 | DM_LOOKUP_DIV | param1, param2 | param1, param2 | ⛔ FAIL |
| DMF0048 | BizTypeByDivision | divisionId | divisionId | ⚠ WARN |
| DMF0048 | Division | divisionId | divisionId | ⚠ WARN |
| DMF0048 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId | ⚠ WARN |
| DMF0048 | FromSiteByDivision | divisionId | divisionId | ⚠ WARN |
| DMF0048 | Measure | mnuId | mnuId | ⛔ FAIL |
| DMF0048 | SiteByEndCustomer_InnerCode | divisionId | divisionId | ⚠ WARN |
| DMF0049 | DMF0044_DEPARTMENT_TEAM2 | divisionId | divisionId | ⚠ WARN |
| DMF0049 | DMF0044_MDF_DEPARTMENT | divisionId | divisionId | ⚠ WARN |
| DMF0049 | DM_LOOKUP_DIV | param1, param2 | - | ✅ PASS |
| DMF0049 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId | ⚠ WARN |
| DMF0072 | EndCustomerByDivisionDept | deptId, divisionId | deptId, divisionId | ⚠ WARN |
| DMF0072 | SiteByEndCustomer_InnerCode | divisionId | divisionId | ⚠ WARN |
| DMF0082 | BizTypeByDivision | divisionId | - | ✅ PASS |
| DMF0082 | CELL_PROD_SITE_ID | divisionId, itemId | - | ✅ PASS |
| DMF0082 | Division | divisionId | - | ✅ PASS |
| DMF0082 | EndCustomerByDivisionDept | deptId, divisionId | deptId | ⚠ WARN |
| DMF0082 | FromSiteByDivision | divisionId | - | ✅ PASS |
| DMF0082 | Measure | mnuId | - | ✅ PASS |
| DMF0082 | PlantByDivisionCompany | companyId, divisionId | companyId | ⚠ WARN |
| DMF0082 | SiteByEndCustomer | divisionId, endCustomer | - | ✅ PASS |

### 한계
- FE 정적 파싱 기준: `comboId` 가 변수인 호출(설정 맵 경유)은 페이지 단위로만 귀속되어 판정이 완화된다.
- `SHEET_COLUMNS` 에 `FPComboBox` 로 등록된 셀 콤보만 대상. 조회조건 콤보(SearchFields 카탈로그)와
  `FPModal` 키(모달 검색 API)는 제외 — 각각 hook #112 / 모달 배선 축에서 다룬다.
- FE 페이지를 찾지 못한 PROGRAM_ID 는 매트릭스에서 빠진다(MENU_ID 상수 미보유 화면).


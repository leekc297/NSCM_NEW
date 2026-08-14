# AS-IS ↔ TO-BE 콤보 **호출 지점 수(N:N)** 대사

> 실행 2026-08-12 10:49 · `_artifacts/_diagnostics/combo_callsite_parity.py` · **읽기 전용**
> 룰 = hook #117 §5.12. SQL·파라미터가 맞아도 **부르는 시점이 빠지면 조용히 죽는다.**
> 섹션 7·E2E D2축이 못 보는 축 — 이 대사표가 유일한 방어선이다.

판정: **FAIL** = 배선 자체 부재(AS-IS ≥2 지점) 또는 **행 생성(InsertRow) 지점 누락** /
**WARN** = AS-IS 지점 수 > TO-BE(트리거 부족 의심) 또는 대응 콤보 미식별 / **PASS** = 그 외

## 종합 — FAIL **0** / WARN **0** / PASS **13** (화면 1개)

## DMF0021 (FAIL 0 / WARN 0 / PASS 13)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0021_SalesPlan/DMF0021_SalesPlan.cs (5643행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 3개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| AS_INCOTERMS | AsIncotermsEdit | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| CELL_PROD_SITE_ID | CELL_PROD_SITE_ID | 2 | 4 | 2 | 1 | O | ✅ PASS | 이식 안 함(사유 기재): AS-IS 재바인딩 2이벤트(ITEM 변경 ComboSelChange L4806 / ClipboardPasted L5631) ↔ TO-BE 동등 2경로: pastedCellHandler(ITEM_ID 포함 paste 시 dataMap 재부착) + cellEditEnded 의 syncRowComboContext(ITEM 변경 → rowCombo divisionId·itemId 재조회). 트리거 카운터가 context 재조회 경로를 인식하지 못한 오탐 — 실배선 SalesPlanGrid.tsx 실측 (2026-08-12) |
| CURRENCY_LIST | CurrencyList | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| DM_CUSTOMS_HANDBOOK | CustomsHandbook | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| EndCustomerByDivision40 | EndCustomerByDivision40 | 1 | 1 | 2 | 1 | O | ✅ PASS |  |
| EndCustomerByDivisionDept | EndCustomerByDivisionDept | 1 | 1 | 2 | 1 | O | ✅ PASS |  |
| EndCustomerByDivisionDeptAuth | EndCustomerByDivisionDept | 2 | 3 | 2 | 1 | O | ✅ PASS |  |
| FCST_TYPE | FcstType | 1 | 1 | 1 | 0 | O | ✅ PASS |  |
| PlantSiteByDivision | FromSiteByDivision | 1 | 1 | 1 | 1 | O | ✅ PASS |  |
| SALES_PLAN_ITEM_ID | SalesPlanItemId | 1 | 1 | 1 | 0 | - | ✅ PASS |  |
| SiteByEndCustomer | SiteByEndCustomer | 1 | 1 | 1 | 1 | - | ✅ PASS |  |
| SiteByEndCustomerAuth | SiteByEndCustomer | 2 | 3 | 1 | 1 | - | ✅ PASS | 이식 안 함(사유 기재): AS-IS InsertRow 는 dtSalesSiteAuth(권한 전체)를 선바인딩(L2951~2954) 후 상위 셀 변경 시 좁힘 — TO-BE 동등 2단: ①신규행 선택 시 selectionChanged→syncRowComboContext 가 행 컨텍스트 (divisionId·deptId·endCustomer)로 SiteByEndCustomer 재조회(프라이밍) ②편집 진입 시 로딩 미완이면 전역(division) 표시 콤보 폴백 개방(2026-08-12 No.61-① 보완 — AS-IS 선바인딩과 동일 계약). 카운터가 selectionChanged 프라이밍 경로를 인식하지 못한 오탐 (SalesPlanGrid.tsx 실측) |
| TeamByDivisionAuth | DeptId | 3 | 3 | 2 | 1 | O | ✅ PASS | AS-IS 3지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |

## 한계 (은폐 없음)
- AS-IS 명명 헬퍼는 **1단계**만 해소한다(헬퍼 안의 헬퍼는 미추적).
- TO-BE 트리거 추출은 `binding === 'X'` 정적 매칭 — 동적 분기(맵/스위치)는 누락될 수 있다.
- 이름이 다른 대응 콤보는 정규화(영숫자 소문자) 매칭이 실패하면 '미식별 WARN' 으로 노출한다(조용한 통과 없음).
- 주석 처리된 AS-IS 호출은 **제외하되 건수를 표에 기록**한다 — 사문 = 미이관이 파리티.


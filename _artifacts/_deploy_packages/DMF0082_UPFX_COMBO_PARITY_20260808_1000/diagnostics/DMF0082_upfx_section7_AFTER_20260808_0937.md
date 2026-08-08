# DMF0082 UP_FX 콤보 정합 — **수정 후** (섹션 7)

> 2026-08-08 09:37

## 판정: **WARN** — 셀 콤보 19종 — FAIL 0 / WARN 7

⚠ CMBO 'BizTypeByDivision' 토큰 @divisionId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'Division' 토큰 @divisionId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'EndCustomerByDivisionDept' 토큰 @deptId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'EndCustomerByDivisionDept' 토큰 @divisionId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'FromSiteByDivision' 토큰 @divisionId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'PlantByDivisionCompany' 토큰 @companyId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'PlantByDivisionCompany' 토큰 @divisionId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요

셀 콤보 19종 / DataGrid comboParams 키 ['mnuId']

| SQL_ID | 필요 토큰 | 서버자동 | FE전달 | 미전달 | 판정 |
|---|---|---|---|---|---|
| BizType | - | - | - | - | ✅ PASS |
| BizTypeByDivision | ['divisionId'] | - | - | ['divisionId'] | ⚠ WARN |
| CELL_PROD_SITE_ID | ['divisionId', 'itemId'] | - | ['divisionId', 'itemId'] | - | ✅ PASS |
| CurrencyList | - | - | - | - | ✅ PASS |
| DOM_EXP | - | - | - | - | ✅ PASS |
| DeptId | - | - | - | - | ✅ PASS |
| Division | ['divisionId'] | - | - | ['divisionId'] | ⚠ WARN |
| EndCustomerByDivision40 | - | - | - | - | ✅ PASS |
| EndCustomerByDivisionDept | ['deptId', 'divisionId'] | ['sesUserId'] | - | ['deptId', 'divisionId'] | ⚠ WARN |
| FCST_TYPE_NOT_FREE | - | - | - | - | ✅ PASS |
| FcstTypeByUserGroupDMF0082 | - | ['sesUserId'] | - | - | ✅ PASS |
| FromSiteByDivision | ['divisionId'] | - | - | ['divisionId'] | ⚠ WARN |
| Incoterms | - | - | - | - | ✅ PASS |
| ItemType | - | - | - | - | ✅ PASS |
| Measure | ['mnuId'] | - | ['mnuId'] | - | ✅ PASS |
| PlantByDivisionCompany | ['companyId', 'divisionId'] | - | - | ['companyId', 'divisionId'] | ⚠ WARN |
| SiteByEndCustomer | ['divisionId', 'endCustomer'] | ['sesUserId'] | ['divisionId', 'endCustomer'] | - | ✅ PASS |
| SoldCustomer | - | - | - | - | ✅ PASS |
| YesOrNo | - | - | - | - | ✅ PASS |

# DMF0082 UP_FX 콤보 정합 — **수정 전 채증** (섹션 7)

> 2026-08-08 08:48 · 게이트가 결함을 실제로 잡는지 증명하기 위한 수정 전 실행 기록

## 판정: **FAIL** — 셀 콤보 19종 — FAIL 9 / WARN 12

⛔ CMBO 'Measure' 토큰 @mnuId 미전달 + 비관대형(`COL = @mnuId`) — '' 치환 → **0행**(조용한 빈 콤보)
⛔ quoting 누락 components/ForecastPriceGrid.tsx · SalesBucket · divisionId: div — `'값'` 형태 필요
⛔ quoting 누락 components/ForecastPriceGrid.tsx · SalesBucket · scmSiteId: site — `'값'` 형태 필요
⛔ quoting 누락 components/ForecastPriceGrid.tsx · SalesBucket · incoterms: inco — `'값'` 형태 필요
⛔ quoting 누락 components/ForecastPriceGrid.tsx · FcstPriceEditMeasure · divisionId: div — `'값'` 형태 필요
⛔ quoting 누락 components/ForecastPriceGrid.tsx · FcstPriceEditMeasure · scmSiteId: site — `'값'` 형태 필요
⛔ quoting 누락 components/ForecastPriceGrid.tsx · FcstPriceEditMeasure · bucketType: bucketTypeParamRef.current — `'값'` 형태 필요
⛔ 빈 .catch components/ForecastPriceGrid.tsx · SalesBucket — 최소 console.error 필요
⛔ 빈 .catch components/ForecastPriceGrid.tsx · FcstPriceEditMeasure — 최소 console.error 필요
⚠ CMBO 'BizTypeByDivision' 토큰 @divisionId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'CELL_PROD_SITE_ID' 토큰 @divisionId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'CELL_PROD_SITE_ID' 토큰 @itemId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'Division' 토큰 @divisionId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'EndCustomerByDivisionDept' 토큰 @deptId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'EndCustomerByDivisionDept' 토큰 @divisionId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'FromSiteByDivision' 토큰 @divisionId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'PlantByDivisionCompany' 토큰 @companyId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'PlantByDivisionCompany' 토큰 @divisionId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'SiteByEndCustomer' 토큰 @divisionId 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ CMBO 'SiteByEndCustomer' 토큰 @endCustomer 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요
⚠ __asis-mapping__.md 에 토큰 대사표 섹션 부재 (hook #117 §5.6)

셀 콤보 19종 / DataGrid comboParams 키 없음

| SQL_ID | 필요 토큰 | 서버자동 | FE전달 | 미전달 | 판정 |
|---|---|---|---|---|---|
| BizType | - | - | - | - | ✅ PASS |
| BizTypeByDivision | ['divisionId'] | - | - | ['divisionId'] | ⚠ WARN |
| CELL_PROD_SITE_ID | ['divisionId', 'itemId'] | - | - | ['divisionId', 'itemId'] | ⚠ WARN |
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
| Measure | ['mnuId'] | - | - | ['mnuId'] | ⛔ FAIL |
| PlantByDivisionCompany | ['companyId', 'divisionId'] | - | - | ['companyId', 'divisionId'] | ⚠ WARN |
| SiteByEndCustomer | ['divisionId', 'endCustomer'] | ['sesUserId'] | - | ['divisionId', 'endCustomer'] | ⚠ WARN |
| SoldCustomer | - | - | - | - | ✅ PASS |
| YesOrNo | - | - | - | - | ✅ PASS |

**quoting 누락 (hook #117 §5.7 — BE raw 치환 → ORA-00904/01722)**
- `components/ForecastPriceGrid.tsx` · SalesBucket · `divisionId: div`
- `components/ForecastPriceGrid.tsx` · SalesBucket · `scmSiteId: site`
- `components/ForecastPriceGrid.tsx` · SalesBucket · `incoterms: inco`
- `components/ForecastPriceGrid.tsx` · FcstPriceEditMeasure · `divisionId: div`
- `components/ForecastPriceGrid.tsx` · FcstPriceEditMeasure · `scmSiteId: site`
- `components/ForecastPriceGrid.tsx` · FcstPriceEditMeasure · `bucketType: bucketTypeParamRef.current`

**조용한 실패 (hook #117 §5.8 — 빈 .catch 로 ORA 오류 은폐)**
- `components/ForecastPriceGrid.tsx` · SalesBucket
- `components/ForecastPriceGrid.tsx` · FcstPriceEditMeasure

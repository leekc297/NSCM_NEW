# DMF0020 Sales Future Price — 클라우드 이관 (Plant Site 수정 반영분만 · 2026-07-10)

> 범위 = **이번 라운드 수정분만** (Plant Site 조회조건 콤보 교정). SP/메타 변경 **없음** — FE 2파일.

## 변경 내용

Plant Site 조회조건이 잘못된 콤보(`SalesSite` 재사용)를 쓰던 것을 **AS-IS 정합 콤보 `PlantSitebyEndCustomer`** 로 교정:
- 종속 = Division **+ End Customer** 서버측 @바인드 (AS-IS `UserPlantSiteByEndCustomer` 1:1)
- **Enable = 81 계열만** (40·82 비활성)
- 값 quoting 의무 (BE `makeComboQuery` raw 치환 대응)

## 파일 (FE only)

| 파일 | 변경 |
|---|---|
| `fe/features/master/src/components/searchFields/SearchFields.tsx` | ⭐ `PlantSiteField` — combo `PlantSitebyEndCustomer` + `endCustomer` prop + 81* enable (⚠ **공유 컴포넌트** — DMF0014/0074 와 공유. 소비처 = DMF0020 뿐이나 최신본 반영) |
| `fe/features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.tsx` | `<PlantSiteField>` 에 `endCustomer={sc.endCustomers...}` prop 전달 |

## ⚠ 클라우드 이슈 (2026-07-10) — Plant Site 가 81 division 기준 조회 안 됨

**원인**: 클라우드 `SCM_ADM_CMBO_SQL_M` 에 `PlantSitebyEndCustomer` 미등록(또는 구버전 잔존).
**해결**: **`sql/00_CMBO_PlantSitebyEndCustomer_cloud.sql`** 실행 (진단[1] → 멱등 등록/교정[2] → 검증[3]).
검증 [3] `CNT_DIV81 > 0`(사내=28) 확인. 0 이면 클라우드 `SCM_MST_SITE` 데이터/END_CUSTOMER 컬럼 점검.

## 적용

1. **`sql/00_CMBO_PlantSitebyEndCustomer_cloud.sql`** 실행 (Plant Site 조회 정상화 — 필수)
2. FE 파일 배포 후 빌드 (BODY/메타 변경 없음)

## 검증

- Division 81* 선택 시 Plant Site 활성 + 목록 조회 / 40·82 비활성
- End Customer 변경 시 Plant Site 후보 재조회 (서버 바인드 cascade)

## 룰

`Doc/_rules_v2/hooks/messaging-api-and-search-fields-mandatory §3.1` + 메모리 `feedback_search_fields_catalog` (Plant Site = PlantSitebyEndCustomer 의무).

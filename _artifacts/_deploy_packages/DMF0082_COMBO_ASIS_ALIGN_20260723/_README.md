# DMF0082 조회조건·Grid Cell Combo AS-IS 차이분석 + 정합 — 2026-07-23

## A. Grid Cell Combo Data Type 대조 (AS-IS MSSQL ↔ 사내 Oracle SHEET_COLUMNS 전수)
- 구조: 행수/시트/컬럼 완전 일치 (누락 0). CELL_CONTROL/CELL_COMBO_DATA_TYPE 상이분만 아래 표.
- 등록명 camelCase rename(CURRENCY_LIST→CurrencyList 등)은 **값 집합 실측 완전 동일 = 실질 일치** (AS-IS 해석기 `UP_FX_GetCommonDataList` 분기 ↔ TO-BE CMBO 대조).
- ⭐ 공통 실질 차이 2건 → **사내 정정 완료 + 본 폴더 sql 동봉**:
  | CMBO | 차이 | 정정 |
  |---|---|---|
  | `FcstType` | TO-BE가 ATTR2='Y'(WS/WSF) 제외 12종 — AS-IS 해석기 FCST_TYPE = SALES_TYPE_CODE 전체 **14종** | ATTR2 필터 제거 → 14종 (실측 OK) |
  | `DmBizType` | TO-BE 'ALL' UNION 행 — AS-IS DM_Biz_Type 에 없음. 셀 에디터에 'ALL' 선택지 노출(저장 오염 위험) + 조회조건에선 FE allOption 과 중복 | 'ALL' 행 제거 → 3종 (실측 OK) |

- DMF0082 관련 상이: CURRENCY×2(CurrencyList)/CUST_GROUP(CustGroup) — **값 집합 실측 동일 = rename 일치** ✅. FCST_TYPE 셀 관련은 FcstType 정정 반영.

## B. 조회조건 데이터 소스 대조 (AS-IS = DMF0003 동일 세트)
| 항목 | 판정 | 근거 |
|---|---|---|
| Division/EndCustomer(스왑)/PlantSite/Bucket/ItemType/CustomsHandbook/Version/팝업 | ✅ 일치 | |
| **Team** | ❌→**정정** | `comboId='UserTeamByDivision'` 전환 (fe 동봉) |
| **Biz Type** | ❌→**정정** | 공유 `BizType`(lookup 3종) — AS-IS BigFilter = DM_BIZ_TYPE ∪ SCM_MST_PROJECT(81/82 프로젝트 기반 후보) → `BizTypebyDivision`+division 필터 전환 (DMF0003 P1 동형) |
| **Period 기본값** | ❌→**정정** | 당일~+6개월 당일 → **월초~(+6개월 1일−1일)** (PR_GET_DAY_RANGE 1:1, DMF0003 P6 동형) |
| Sales Site | ⚠ 보고 | 공유 `SalesSite` — EndCustomer cascade·40 team 필터 없음 (AS-IS UP_FX SiteByEndCustomer/40, AS 파라미터는 ''=무영향). 적용 시 DMF0003 방식(전용 CMBO+바인드) — 확인 후 진행 |
| Sender Code | ✅ 제외 정당 | AS-IS 화면에 clbEDISender 컨트롤 없음(dtEdiSender 로드는 공용코드 잔재), SP 파라미터도 없음 |

## 적용 (클라우드)
1) sql/01_CMBO_ASIS_PARITY.sql (FcstType/UserTeamByDivision/BizTypebyDivision/CustGroup/CurrencyList 멱등)
2) fe/ 3파일 (ForecastPriceForm.tsx / useForecastPriceStore.ts / SearchFields.tsx)

---
## v2 갱신 (2026-07-23 — 사용자 승인 3건 반영)
1. **Sales Site cascade 적용** — 신규 공용 CMBO `UserSiteByEndCustomer`(AS-IS UP_FX SiteByEndCustomer/40 1:1: EndCustomer/Team cascade + 40 owner-team 필터 + OPERATION_GROUP 'W' 제외, @divisionId/@endCustomer/@deptId/@asYn 바인드) 등록 + SalesSiteField opt-in 확장(comboId/endCustomer/deptId/asYn — 기본값 무영향) + 본 화면 전환. 검증: div 81 = 437행.
2. **BizTypeByDivision AS-IS 교체** — BIZ_TYPE_BPMS lookup(12종 고정) → SCM_MST_PROJECT division별 distinct(@divisionId 바인드, AS-IS SCM0001_GET_BIZ_TYPE_BY_DIVISION 1:1). 검증: 81=12/82=9 (AS-IS 실측 동일). (본 화면은 BizTypebyDivision 사용 — 참고 동봉)
3. **DMF0021 FROM_SITE_ID 셀 콤보 = 유지 확정** (TO-BE 추가 기능, 사용자 승인).
- fe/ 동봉본은 v2 최신 스냅샷. sql/01 은 v2 재생성분.

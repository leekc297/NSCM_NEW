# DMF0021 조회조건·Grid Cell Combo AS-IS 차이분석 + 정합 — 2026-07-23

## A. Grid Cell Combo Data Type 대조 (AS-IS MSSQL ↔ 사내 Oracle SHEET_COLUMNS 전수)
- 구조: 행수/시트/컬럼 완전 일치 (누락 0). CELL_CONTROL/CELL_COMBO_DATA_TYPE 상이분만 아래 표.
- 등록명 camelCase rename(CURRENCY_LIST→CurrencyList 등)은 **값 집합 실측 완전 동일 = 실질 일치** (AS-IS 해석기 `UP_FX_GetCommonDataList` 분기 ↔ TO-BE CMBO 대조).
- ⭐ 공통 실질 차이 2건 → **사내 정정 완료 + 본 폴더 sql 동봉**:
  | CMBO | 차이 | 정정 |
  |---|---|---|
  | `FcstType` | TO-BE가 ATTR2='Y'(WS/WSF) 제외 12종 — AS-IS 해석기 FCST_TYPE = SALES_TYPE_CODE 전체 **14종** | ATTR2 필터 제거 → 14종 (실측 OK) |
  | `DmBizType` | TO-BE 'ALL' UNION 행 — AS-IS DM_Biz_Type 에 없음. 셀 에디터에 'ALL' 선택지 노출(저장 오염 위험) + 조회조건에선 FE allOption 과 중복 | 'ALL' 행 제거 → 3종 (실측 OK) |

- DMF0021 관련 상이: BIZ_TYPE_NAME40(DmBizType — 정정 반영) / FCST_TYPE(FcstType — 정정 반영) / **FROM_SITE_ID: AS-IS 셀 콤보 없음 → TO-BE FromSiteByDivision 부여** = TO-BE 추가 기능(AS-IS .cs 동적 설정도 없음 실측). 제거 여부 사용자 판단 — 현행 유지.

## B. 조회조건 데이터 소스 대조 (AS-IS BigFilter/SP ↔ TO-BE Form/CMBO)
| 항목 | 판정 | 근거 |
|---|---|---|
| Division(MyDivision)/Period(월초~+6개월 말일)/Bucket/ItemType/PlantSite(bind)/Project·Model·Owner 팝업 | ✅ 일치 | 값·산식 파리티 |
| End Customer | ✅ 일치 | 40=`EndCustomerByDivision40`(owner 1토큰+lookup-only UNION — AS-IS 1:1 실측) / 비40=`EndCustomer` 스왑 구조 |
| **Team** | ❌→**정정** | 공유 `TeambyDivision`(SITE_ITEM.DEPT_ID 직접) ≠ AS-IS UserTeamByDivision(owner 1토큰 부서) — 차집합 35/64 실측 → `comboId='UserTeamByDivision'` 전환 (fe 동봉) |
| Biz Type(비40) | ⚠ 경미 | TO-BE `BizTypeByDivision`=BIZ_TYPE_BPMS lookup 12종(전 division 동일) vs AS-IS=SCM_MST_PROJECT division별 distinct(82는 부분집합) — 코드 체계 동일(LGC_BIZ_*), 82에 미사용 코드 노출만. 보류(변경 시 별도 확정) |
| Sales Site | ⚠ 보고 | 공유 `SalesSite`(division 필터만) — AS-IS UserSiteByEndCustomer 는 EndCustomer cascade + 40 owner-team 필터. DMF0003 은 전용 `SiteByEndCustomer_DMF0003` 로 해소 — 본 화면 적용은 SalesSiteField 확장 수반 → **확인 후 진행** |
| KRW/USD/LOC 통화 라디오 | ✅ 제외 정당 | AS-IS 핸들러 전부 주석(사문 컨트롤) |

## 적용 (클라우드)
1) sql/01_CMBO_ASIS_PARITY.sql (FcstType/DmBizType/UserTeamByDivision 멱등 MERGE)
2) fe/ 동봉 2파일 덮어쓰기 (SalesPlanForm.tsx / SearchFields.tsx — comboId opt-in, DMF0003 패키지와 동일 최신본)

---
## v2 갱신 (2026-07-23 — 사용자 승인 3건 반영)
1. **Sales Site cascade 적용** — 신규 공용 CMBO `UserSiteByEndCustomer`(AS-IS UP_FX SiteByEndCustomer/40 1:1: EndCustomer/Team cascade + 40 owner-team 필터 + OPERATION_GROUP 'W' 제외, @divisionId/@endCustomer/@deptId/@asYn 바인드) 등록 + SalesSiteField opt-in 확장(comboId/endCustomer/deptId/asYn — 기본값 무영향) + 본 화면 전환. 검증: div 81 = 437행.
2. **BizTypeByDivision AS-IS 교체** — BIZ_TYPE_BPMS lookup(12종 고정) → SCM_MST_PROJECT division별 distinct(@divisionId 바인드, AS-IS SCM0001_GET_BIZ_TYPE_BY_DIVISION 1:1). 검증: 81=12/82=9 (AS-IS 실측 동일). (본 화면은 sales/business plan 스왑 콤보)
3. **DMF0021 FROM_SITE_ID 셀 콤보 = 유지 확정** (TO-BE 추가 기능, 사용자 승인).
- fe/ 동봉본은 v2 최신 스냅샷. sql/01 은 v2 재생성분.

# DMF0042 조회조건·Grid Cell Combo AS-IS 차이분석 + 정합 — 2026-07-23

## A. Grid Cell Combo Data Type 대조 (AS-IS MSSQL ↔ 사내 Oracle SHEET_COLUMNS 전수)
- 구조: 행수/시트/컬럼 완전 일치 (누락 0). CELL_CONTROL/CELL_COMBO_DATA_TYPE 상이분만 아래 표.
- 등록명 camelCase rename(CURRENCY_LIST→CurrencyList 등)은 **값 집합 실측 완전 동일 = 실질 일치** (AS-IS 해석기 `UP_FX_GetCommonDataList` 분기 ↔ TO-BE CMBO 대조).
- ⭐ 공통 실질 차이 2건 → **사내 정정 완료 + 본 폴더 sql 동봉**:
  | CMBO | 차이 | 정정 |
  |---|---|---|
  | `FcstType` | TO-BE가 ATTR2='Y'(WS/WSF) 제외 12종 — AS-IS 해석기 FCST_TYPE = SALES_TYPE_CODE 전체 **14종** | ATTR2 필터 제거 → 14종 (실측 OK) |
  | `DmBizType` | TO-BE 'ALL' UNION 행 — AS-IS DM_Biz_Type 에 없음. 셀 에디터에 'ALL' 선택지 노출(저장 오염 위험) + 조회조건에선 FE allOption 과 중복 | 'ALL' 행 제거 → 3종 (실측 OK) |

- DMF0042 관련 상이: INCOTERMS(incotermsEdit→IncotermsEdit — 값 동일 rename) / **CELL_PROD_SITE: AS-IS 는 .cs 동적 SetComboCol(DM_CELL_PROD_SITE,'ALL'=VALID 무시) → TO-BE 메타 `DMF0042CellProdSite`(무VALID, 7=7 값 동일) = 구현 방식 메타화, 실질 일치** ✅.

## B. 조회조건 데이터 소스 대조
| 항목 | 판정 | 근거 |
|---|---|---|
| Division/EndCustomer(40 스왑)/Period(월초~+7개월, p_month=7)/Bucket(BucketType2 M/Q/Y)/ItemType/PlantSite/팝업 3종 | ✅ 일치 | |
| **Team** | ❌→**정정** | DMF0021 동일 — `comboId='UserTeamByDivision'` 전환 (fe 동봉) |
| Biz Type(비40) | ⚠ 경미 | BIZ_TYPE_BPMS vs PROJECT distinct — DMF0021 과 동일 보류 |
| Sales Site | ⚠ 보고 | cascade 미구현 — DMF0021 과 동일, 확인 후 진행 |

## 적용 (클라우드)
1) sql/01_CMBO_ASIS_PARITY.sql  2) fe/ 2파일 (BusinessPlanForm.tsx / SearchFields.tsx)

---
## v2 갱신 (2026-07-23 — 사용자 승인 3건 반영)
1. **Sales Site cascade 적용** — 신규 공용 CMBO `UserSiteByEndCustomer`(AS-IS UP_FX SiteByEndCustomer/40 1:1: EndCustomer/Team cascade + 40 owner-team 필터 + OPERATION_GROUP 'W' 제외, @divisionId/@endCustomer/@deptId/@asYn 바인드) 등록 + SalesSiteField opt-in 확장(comboId/endCustomer/deptId/asYn — 기본값 무영향) + 본 화면 전환. 검증: div 81 = 437행.
2. **BizTypeByDivision AS-IS 교체** — BIZ_TYPE_BPMS lookup(12종 고정) → SCM_MST_PROJECT division별 distinct(@divisionId 바인드, AS-IS SCM0001_GET_BIZ_TYPE_BY_DIVISION 1:1). 검증: 81=12/82=9 (AS-IS 실측 동일). (본 화면은 sales/business plan 스왑 콤보)
3. **DMF0021 FROM_SITE_ID 셀 콤보 = 유지 확정** (TO-BE 추가 기능, 사용자 승인).
- fe/ 동봉본은 v2 최신 스냅샷. sql/01 은 v2 재생성분.

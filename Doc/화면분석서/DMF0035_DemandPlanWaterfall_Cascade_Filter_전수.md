# DMF0035 Demand Plan Waterfall — Cascade·Filter 전수 분석 (hook #123 R2)

> 작성: 2026-08-06 · 정본: `DMF0035_DemandPlanWaterfall_ASIS_통합분석_v1.0.md` 의 부속. AS-IS 3화면(.cs 전문 정독) cascade·필터 체인 전수 + TO-BE GUBUN 통합 시 적용 설계.
> AS-IS 라인 근거: 0035=`DMF0035_MktFcstWaterfall.cs` / 0022=`DMF0022_SalesPlanWaterfall.cs` / 0051=`DMF0051_BizPlanWaterfall.cs` (모두 `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\`).

## 1. Cascade 체인 (3화면 공통 골격)

```
Division(단일, 필수)
 ├─→ Team 재로드 (UserTeamByDivision)
 │    ├─→ End Customer 재로드 (EndCustomerByDivision: div+team)
 │    │    └─→ Sales Site 재로드 (UserSiteByEndCustomer: div+endCust)
 │    └─→ Sales Site 재로드
 ├─→ Biz Type 재로드
 ├─→ Plant Site 재로드
 ├─→ [0035만] EDI Sender 재로드 + enabled 판정(div=='81' 정확일치)
 ├─→ 텍스트 클리어: Project / ItemId / Owner / Version
 ├─→ div40 분기: Project·PlantSite disable+클리어 (+0051 은 BizType 도 disable) / Cell Qty enable
 └─→ InitSpread(true) — 그리드 재초기화
```

라인 근거: 0035=.cs:1387-1499 / 0022=.cs:1499-1628(클리어 1609-1612) / 0051=cs:801-898.

### 1.1 하위 cascade

| 트리거 | 재로드 대상 | 0035 | 0022 | 0051 |
|---|---|---|---|---|
| Team 변경 | End Customer → Sales Site | .cs:1501-1536 | .cs:2599-2637 | cs:1720-1759 |
| Customer 변경 | Sales Site | .cs:1538-1563 | .cs:2308-2321 | cs:1433-1447 |
| SalesSite/PlantSite 변경 | `SetClbVersion()` — **3화면 모두 빈 함수(dead)** | .cs:1565-1592 | .cs:1630-1660 | cs:900-930 |
| Bucket 변경 | 0035/0022: (W\|M→DAILY, ONLY_WEEKLY 진출입)만 InitSpread, 그 외 SetSpreadColumn / 0051: **SetSpreadColumn 만(재조회·재초기화 없음)** | .cs:1594-1617 | .cs:1662-1686 | cs:932-954 |
| Version 팝업 확정 | txtVersion + **drpPeriod 덮어쓰기(sPeriod)** | .cs:2139-2143 | .cs:2707-2711 | cs:1783 |
| TitleSet(C/M) OK | InitSpread(true) 재구성 (Measure 는 다음 조회 반영) | §1.E | .cs:1807-1828 | cs:1126-1146 |

### 1.2 콤보 데이터 원천 차이 (전수)

| 콤보 | 0035 | 0022 | 0051 |
|---|---|---|---|
| Division | MyDivision(GROUP_ID+USER_ID) | 동일 | 동일 |
| Team | UserTeamByDivision | 동일 | 동일 |
| End Customer | EndCustomerByDivision(DIVISION+DEPT) | 동일 | 동일(div40 은 Team 값 전달) |
| Sales Site | UserSiteByEndCustomer | 동일 | 동일 |
| Plant Site | UserPlantSiteByDivision | 초기 `UserPlantSiteByEndCustomer` → **Division 변경 후 `UserPlantSiteByDivision`**(.cs:1595-1599) | UserPlantSiteByEndCustomer |
| Biz Type | BizType | BizType | div40=`DM_BIZ_TYPE` 공통코드 / 그 외 `SCM0001_GET_BIZ_TYPE_BY_DIVISION` |
| EDI Sender | EdiSender (0035 전용) | — | — |
| Item Type | SCM0001_GET_LOOKUP_VALUES('ITEM_TYPE_CODE') | 동일 | 동일 |
| Bucket | DMF0003_GET_REPORT_BUCKET_TYPE_CODE(D/W/M/OW) | 동일 | **LOOKUP 'BUCKET2_TYPE_CODE'(M/Q/Y)** |
| QTY | DMF0003_GET_QTY_TYPE_CODE | 동일 | 동일 |
| KRW/USD/LOC | — | SALES_PLAN_AMOUNT_KRW/USD/LOC | 동일 |

## 2. 팝업 게이트·필터 전달 (hook #123 R1 연동)

| 팝업 | 오픈 게이트 | 전달 필터 | 반환 소비 |
|---|---|---|---|
| Project | 0035: div 81*/82 만(40 disable) / 0022·0051: div40 disable | div, team, endCust, salesSite, (기존 project) | CSV → txtProject (0035 는 `!=""` 일 때만 대입) |
| Item | 82 계열에서 project<3자 & item<3자 → MSG00147 즉시 Close(0035 실측 — Ex:173-183) | +project, itemId | 단일/CSV → txtItemId |
| Version | 0035: btnVersion/txtVersion 아무 키("MF_SF") / 0022: KeyDown(DMF0073 "SP") / 0051: KeyDown(SCM0002 "BP", month 고정) | div, from, to | CSV sVersions + **sPeriod→Period 덮어쓰기** |
| Owner | 게이트 없음, 자동조회 | div, team, endCust, salesSite, project, item, (기존 owner) | **무조건 대입**(취소 시 빈값 — AS-IS 특성) |
| TitleSet C/M | btnColumn/btnMeasure | program_id(화면별), sheet_name(화면별), isColumn, division | OK → InitSpread |

## 3. SP 측 필터 처리 방식 (전수)

3화면 공통: **선적재 후 DELETE**(성능 사유 — AS-IS 주석 명기). 'ALL' 판정 후 String_Split(0022)/REGEXP 상당(0051·0035) 토큰화.

| 파라미터 | 처리 | div40 특칙 |
|---|---|---|
| p_dept_id | ≠ALL: SITE_ITEM temp 의 DEPT_ID(Team Mapping) 기준 DELETE | 0022: ETC=ATTRIBUTE1 |
| p_end_customer | ≠ALL: SCM_MST_SITE.END_CUSTOMER | **40=PROJECT_CODE 토큰 매칭**(3화면 공통) |
| p_scm_site_id / p_plant_site_id | ≠ALL: 정확일치 | — |
| p_item_type | ≠ALL: ITEM_TYPE(P>H>Q>R 집약) | — |
| p_biz_type | ≠ALL: PROJECT.BIZ_TYPE LIKE | **40=FORECAST_INFO_BIZ_TYPE 정확일치** |
| p_project_code | ≠'': CODE/NAME LIKE | — |
| p_item_id | ≠'': ITEM_ID/NICK_NAME LIKE | — |
| p_owner | ≠'': OWNER/OWNER_NAME(EN/KO) LIKE | — |
| p_sender_code (0035) | ≠ALL: SENDER_CODE 미일치 DELETE — **비 EDI 메저 행도 함께 삭제되는 AS-IS 특성** | — |
| p_internal_yn (0022) | ≠'Y': 사내거래처(SCM_MST_COMPANY_SN) 행 DELETE / div82 실적 ATTRIBUTE2 가산 | — |
| p_qty_yn (0051) | ='Y': Business_Plan SUM=0 차원조합 DELETE | — |
| p_version_no/type | `(` 앞 절단 → CURRENT=라이브 / MF_·SF_·SP_·BP_=컷오프 `_C` | — |

## 4. TO-BE 통합 적용 설계 (구현 체크리스트)

1. **cascade 훅 단일화**: Division 변경 핸들러 1개가 GUBUN 무관 공통 체인(§1) 수행 + GUBUN별 가변(EDI Sender 재로드=MKT 만, BizType 원천 스왑=BIZ div40). Division 변경 = Grid 초기화+CRUD reset 표준(hook 계보) 준수.
2. **클리어 의무**: Division 변경 시 project/item/owner/version 4종 클리어 — TO-BE sales-plan-waterfall 누락분(§2.H-③) 승계 금지.
3. **div40 분기**: Project·PlantSite disable+클리어, CellQty enable(MKT·BIZ), BIZ 는 BizType 도 disable. div 이탈 시 CellQty checked 리셋.
4. **PlantSite 원천**: GUBUN=SALES 는 Division 변경 후 UserPlantSiteByDivision 전환 실측 준수(§1.2).
5. **Version 모달**: GUBUN별 3타입 스왑 + sPeriod→Period 덮어쓰기 공통 구현. MKT 만 비필수(''=CURRENT).
6. **Bucket**: GUBUN 전환 시 콤보 원천 스왑(D/W/M/OW ↔ M/Q/Y) + 값 MONTHLY 리셋. BIZ 는 버킷 변경 시 재조회 없이 컬럼 토글만(AS-IS 준수 — 데이터는 항상 3계층 수신).
7. **p_now 산식**(SALES 만): 이번주 월요일, from≥월요일→from, to<now→to+1일 — dayjs() 단순 대입 금지.
8. **필터 파라미터 멀티선택**: TO-BE 표준 '^' 구분자 + SP 측 `[^,^]+` 겸용 토큰화(#기존 DMF0003 계보) 적용 — 신규 PKG_DMF0051 GET 재변환 시 반영.
9. **dead 요소 이관 금지**: SetClbVersion/p_user_dept_id/p_group_id/spdMain_ComboSelChange/구 ExportExcel.

# DMF0020 (Sales Future Price) — 조회조건·GRID Cascade/Filter 전 케이스 Flow (AS-IS 기준) v1.0

> 작성 2026-08-05 · 원천 = AS-IS `DMF0020_SalesFuturePrice.cs`(3,969줄) 전수 + BigFilter.xml + UP_FX 원문 + AS-IS lookup 실값.
> TO-BE 반영 현황 병기(✅/🔶/❌). **Δ = 4UI(0003/0020/0021/0082) 간 상이 구현 강조**.

## 0. 공통 축
- 콤보 계통·권한 축 = DMF0003 문서 §0 공통(BigFilter 캐시 / UP_FX 기본판·_DM판 / NowGroupID·TB_FX D·부서제약).
- **Δ 최상위 차이**: DMF0020 검색영역 Sales Site는 **BigFilter 캐시만 사용** — DMF0003의 UP_FX(_DM) 이벤트 혼용·`GetSalesSite()` 함수가 없음. (AS 사이트·W 제외 미반영 계보)

## §1 조회조건 13필드

| # | 필드 | AS-IS Cascade/Filter | Δ | TO-BE |
|---|---|---|---|---|
| 1 | Division | 초기 BigFilter `MyDivision`(다중). 변경(L2465~2601): Team→Customer→BizType→PlantSite→SalesSite 연쇄 + Owner/Project/Model clear + **81만 ExcelUpload/Template 표시**(L2579~2590) | Δ Excel 버튼 81 전용 | ✅ DivisionField+reset |
| 2 | Team | Division 변경 L2484 / Team 변경(L3655~3680)→Customer(81·82=sTeam/40=ControlValues)→SalesSite | | ✅ TeamField |
| 3 | End Customer | `EndCustomerByDivision`(BigFilter, div+team 클라 필터). Customer 변경(L3539~3545)→SalesSite | | ✅ EndCustomerField |
| 4 | Sales Site | **전 이벤트 BigFilter `UserSiteByEndCustomer`**(L2562/3543/3678 — 캐시 클라 필터, W 미제외·AS 미포함·NAME=ID) | **Δ UP_FX 미사용** (0003과 상이) | ✅ SalesSiteField(_comboKey `SiteByEndCustomer`) |
| 5 | Biz.Type | BigFilter `BizType` + 81/82 시 직접 SP `SCM0001_GET_BIZ_TYPE_BY_DIVISION` 재조회(L2499) | Δ 이중 원천 | ✅ BizTypeField |
| 6 | Sender Code | **미사용** | | — |
| 7 | Period | `PR_GET_DAY_RANGE`(drpDateTime) | | ✅ PeriodField |
| 8 | Bucket | `DMF0003_GET_BUCKET_TYPE_CODE`(공용, L3810) | | ✅ |
| 9 | Project | 81/82만(umltProject — 40 비활성 layoutControlItem6, L2544~2547). Division 변경 clear | | ✅ |
| 10 | Model/Nickname | umltModel(81/82만) + Division 변경 clear | | ✅ ItemField |
| 11 | Plant Site | **81만** `UserPlantSiteByEndCustomer`(L2514) · 82 비활성+clear(L2519~2523) · 40 비활성 | | ✅ PlantSiteField |
| 12 | Item Type | **미사용** | | — |
| 13 | Owner | txtOwner — Division 변경 clear(L2572) | | ✅ payload |
| + | InvalidExec(82만)·usrDiscard(폐기 포함, L3829) | Δ usrDiscard 고유 | ✅ |

## §2 GRID INSERT/UPDATE

### 2-1. 셀 cascade (ComboSelChange L2603~3110 — 잠금 해제 상태만)
| 셀 | cascade | Δ |
|---|---|---|
| DIVISION_ID | DEPT=**`UserTeamByDivision`(비Auth판)** → END_CUSTOMER=`EndCustomerByDivisionDeptAuth` / END_CUSTOMER40 → SITE=`UserSiteByEndCustomerAuth` → PLANT(81만 unlock) + **하위 일괄 clear**(DEPT/CUSTOMER/SITE/PROJECT/PROJECT_NAME/ITEM/ITEM_CLASS — SetText2, L2666~2679) | **Δ 셀 Team 비Auth판**(0003/0021은 Auth판) · Δ 광범위 clear |
| DEPT_ID | Customer(Auth/40) → Site(Auth) + clear(L2706~2717) | |
| END_CUSTOMER | Site(Auth) + SITE/PROJECT/ITEM clear | |
| SCM_SITE_ID | PROJECT/PROJECT_NAME/ITEM/ITEM_CLASS clear (L2740~2747) | Δ Incoterms/Measure 재구성 없음(0003과 상이) |
| END_CUSTOMER40 | Site=기본판 `UserSiteByEndCustomer` | |
| INCOTERMS/FcstType/DomExp/CURRENCY | **빈값이면 포커스행(sTempRow) 값 복제**(L2761~2780) | **Δ 0020 고유** |
| PROJECT_CODE/ITEM_ID | SCM0002/모델 팝업(L3080/3089) | |
| CURRENCY 셀 클릭 | 기존행('I' 아님)이면 **MSG00447**(변경 불가, L3686~3691) | **Δ 0020 고유** |
| Raw_CellClick | `PlantSiteByItem`(div,project,item) PlantSite 콤보(L3698~3713) | Δ 고유 |

### 2-2. 편집 게이트
- `DM_UI_EDITABLE_DIVISION` 실값 ('DMF0020','40') = **40 편집 금지**.
- 행 게이트 = 조회 SP `DMF0020_GET_SCM_MST_FUTURE_PRICE` 반환 **AUTHORITY_YN**(부서 매칭 OR ADMIN) — **Δ 0020 고유**(0003/0082=GET_ADMIN_GROUP measure 권한과 다른 축).
- 단가(LOC 계열) 행 + 과거 잠금.

### TO-BE 현황
- 'Sales Price' 시트 = **셀 신규입력 구현**(IM/IO): DEPT_ID=`TeambyDivision`·END_CUSTOMER=`EndCustomerByDivisionDept`·END_CUSTOMER40=`EndCustomerByDivision40`·SCM_SITE_ID=`SiteByEndCustomer`·FCST_TYPE=`FCST_TYPE_NOT_FREE`·INCOTERMS/DOM_EXP/CURRENCY/PLANT(FromSiteByDivision) + Save All 팝업 시트 동일 계열.
- 편집: `SalesFuturePriceEditableDivision` CMBO(❌ 미등재 — fallback 없음=편집 전면 불가 잠재) × hasButton × LOC행+과거잠금 × SP AUTHORITY_YN. 🔶 AUTHUNION 2곳(GET L190/SAVE_PRICE_POPUP L55) 권고 승인 대기.

## §3 커버리지
핸들러 9종(L558/2465/2603/3211/3539/3655/3684/3698/3829) 전건 §1·§2 매핑. 13필드 표기 완료(미사용 2종 명기). 콤보 키: MyDivision·UserTeamByDivision·EndCustomerByDivision(40)·BizType·UserSiteByEndCustomer(Auth)·UserPlantSiteByDivision/ByEndCustomer·UpperDeptId·CURRENCY_LIST·EndCustomer·SalesPlant·PlantSiteByItem·SCM0001_*·PR_GET_DAY_RANGE·DMF0020_GET_*(WEEKDATA/MEASURE_COUNTINFO/FUTUREPRICE_INFO/SCM_MST_FUTURE_PRICE/SAVE_ALL/SPREAD_TITLE)·DM_BIZ_TYPE·DMF0003_GET_BUCKET_TYPE_CODE·UP_FX_GetCommonDataList_DM·DM0021_GET_DM_PLN_SALES_PLAN·PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW — 전건 본 문서/§2 참조 매핑.

# DMF0021 (Sales Plan) — 조회조건·GRID Cascade/Filter 전 케이스 Flow (AS-IS 기준) v1.0

> 작성 2026-08-05 · 원천 = AS-IS `DMF0021_SalesPlan.cs`(5,644줄) 전수 + BigFilter.xml + UP_FX 원문 + AS-IS lookup 실값.
> TO-BE 반영 현황 병기(✅/🔶/❌). **Δ = 4UI(0003/0020/0021/0082) 간 상이 구현 강조**.

## 0. 공통 축
- 콤보 계통·권한 축 = DMF0003 문서 §0 공통.
- **Δ 최상위 차이**: 검색 Sales Site는 **BigFilter 캐시만**(UP_FX 검색 미사용 — Team 변경 40 분기 L5383만 team 전달 클라 필터). 그리드 ITEM은 팝업이 아니라 **`SALES_PLAN_ITEM_ID` lookup 콤보(GUBUN=40/81/82 필터)**.

## §1 조회조건 13필드

| # | 필드 | AS-IS Cascade/Filter | Δ | TO-BE |
|---|---|---|---|---|
| 1 | Division | 초기 `MyDivision`(다중). 변경(L5136~5254): Team→BizType→Customer→SalesSite→**PlantSite=`UserPlantSiteByDivision`(division 기반)** + Project/Item/Owner clear + 40: Project/PlantSite 비활성 | Δ PlantSite가 division 기반(0003=EndCustomer 기반) | ✅ DivisionField+reset |
| 2 | Team | Division 변경 L5155 / Team 변경(L5338~5388): Customer(81·82=sTeam/40=ControlValues)→SalesSite(**40 분기만 team 전달** L5383) | | ✅ TeamField |
| 3 | End Customer | `EndCustomerByDivision`(BigFilter). Customer 변경(L5125~5134)→SalesSite | | ✅ EndCustomerField |
| 4 | Sales Site | **전 이벤트 BigFilter `UserSiteByEndCustomer`**(L504/5130/5220/5367/5383) — W 미제외·AS 미포함·NAME=ID | **Δ UP_FX 미사용**(0003과 상이) | ✅ comboContext `SiteByEndCustomer`(서버 바인드) |
| 5 | Biz.Type | BigFilter `BizType`(L452/474/5167/5189) | | ✅ BizTypeField·40=DmBizType(셀) |
| 6 | Sender Code | **미사용** | | — |
| 7 | Period | `PR_GET_DAY_RANGE`(L518/3411) | | ✅ PeriodField |
| 8 | Bucket | `DMF0003_GET_BUCKET_TYPE_CODE`(공용, L515/3431) + chkColor/chkSum | | ✅ |
| 9 | Project | 81/82만(txtProject+btnProject → SCM0002 팝업 L3530~3540, div/team/customer/site/project 전달). 40 비활성+clear | | ✅ |
| 10 | Model/Nickname | txtItemId 텍스트. Division 변경 clear(L5238) | | ✅ ItemField |
| 11 | Plant Site | 초기=`UserPlantSiteByEndCustomer`(L511) / Division 변경=`UserPlantSiteByDivision`(L5227) · 40 비활성+clear | Δ 이벤트별 원천 상이 | ✅ PlantSiteField |
| 12 | Item Type | `GetItemType()` 콤보(L520) | | ✅ ItemType |
| 13 | Owner | txtOwner — Division 변경 clear(L5239) | | ✅ payload |
| + | **InternalYN 체크**(p_internal_yn)·**KRW/USD/LOC 통화 표시 콤보**(L5444~5472)·`SALES_PLAN_ITEM_ID`/`CURRENCY_LIST` 사전 로드(L526/529) | **Δ 0021 고유**(통화 콤보) | ✅ 대응 |

- 조회 SP `DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx` 파라미터 17종(L1553~1573): division/dept/end_customer/scm_site/project/item/item_type/from·now·to/created_by/plant_site/biztype/**p_userinfo(NowGroupID)**/owner/internal_yn/bucket/**p_user_dept_id(JV Planner 과제)**.

## §2 GRID INSERT/UPDATE

### 2-1. 셀 cascade (ComboSelChange L4531~4860 — 잠금 해제 상태만)
| 셀 | cascade | Δ |
|---|---|---|
| DIVISION_ID | DEPT=**`UserTeamByDivisionAuth`(Auth판)** → END_CUSTOMER=`EndCustomerByDivisionDeptAuth` / END_CUSTOMER40(team=검색 clbTeam) → SITE=`UserSiteByEndCustomerAuth` → PLANT=`UserPlantSiteByDivision`(81만 unlock) → **ITEM=`SALES_PLAN_ITEM_ID` lookup 콤보(GUBUN=division)** + 하위 clear(DEPT/CUSTOMER/SITE/PROJECT/ITEM/TEXT/ITEM_CLASS, L4607~4622) | Δ ITEM lookup 콤보(팝업 아님) |
| DEPT_ID | **분기 전체 주석 — 미동작**(L4628~4685) | **Δ 0021 고유(비활성)** |
| END_CUSTOMER | Site(Auth) + ITEM 콤보(GUBUN) + clear(L4709~4720) | |
| END_CUSTOMER40 | Site=기본판 + ITEM(40은 **Measure≠'Catch_Up'만** L4743) | Δ Catch_Up 예외 |
| SCM_SITE_ID | ITEM 콤보(GUBUN, 40 Catch_Up 예외) + PROJECT/ITEM/TEXT clear | |
| ITEM_ID | ITEM_CLASS_NAME 자동 세팅(L4792~4794) + **CELL_PROD_SITE_ID 콤보 재구성**(L4808~4812) | Δ 0082와 공유 축 |
| MEASURE | 편집 시작 컬럼 재계산 — **당월(this_YYYYMM) 포함**(L4856~4860) | |
- Paste(L5617~5641): ITEM_ID → CELL_PROD_SITE_ID 재구성.

### 2-2. 편집 게이트 (EditButton L688~)
- 필수 컬럼 division별 상이(L710~725): 공통 DIVISION/SCM_SITE/ITEM/DomExp/FcstType/INCOTERMS/MEASURE/CURRENCY + **40: END_CUSTOMER40·DEPT_ID(MSG00429 "Team")·CELL_PROD_SITE_ID** + **81: PROJECT/TEXT/FromSite/PLANT_SITE** + 비40: END_CUSTOMER — **Δ division별 필수셋 고유**.
- **Weekly/Monthly 버킷만 편집**(L745) — Δ(0082는 Daily 포함).
- 40: 당월(M_)부터 편집(L772~777) / 측정 권한 = `DMF0021_GET_SALES_PLAN_MEASUREINFO(2)` + 조회 SP p_userinfo(그룹) 기반 EDIT_FLAG.

### TO-BE 현황 (2026-08-05 정정)
- **셀 신규행 편집 구현됨** — SalesPlanGrid: 셀 모달 2종(PROJECT 81·82 / ITEM 40+Catch_Up), 편집콤보 스왑(MEASURE=measureInfo SP·FCST_TYPE=Catch_Up ETC 제외·CURRENCY=CurrencyList), ITEM_CLASS_NAME 자동 세팅, cascade/clear. ⚠ corp SHEET meta 는 전 컬럼 `INPUT_TP_CD='S'`(미등재) — FE 하드코딩 fallback(_inputEditType)으로 구동. 표시 dataMap: DeptId/EndCustomerByDivisionDept/EndCustomerByDivision40/`SiteByEndCustomer_InnerCode`/DmBizType(40)/BizTypeByDivision/ItemType/Incoterms/FcstType/DOM_EXP/FromSiteByDivision 등.
- 권한: CMBO `SalesPlanUserAuthGroup`(보유그룹×lookup 교집합→authGroup) + PKG_DMF0021 **AUTHUNION 3곳** + **PLANTNORM**(PLANT_SITE_ID 센티널 '-' 정규화) 적용 완료.
- 🔶 잔여: JV Planner `p_user_dept_id` 미구현(AS-IS 대조 필요) / SalesPlanUserDept CMBO 미등재 / 82×RTF_SYS_RP lookup 의도 확인.

## §3 커버리지
핸들러 15종(L330/3577/3790/4441/4448/4460/4531/5125/5136/5256/5338/5444/5454/5464/5617) 전건 매핑(중복 ClipboardPasted 2본 포함 — L330 구본·L5617 활성). 13필드+고유 조건(InternalYN/통화 콤보) 명기. 콤보 키: MyDivision·UserTeamByDivision(Auth)·EndCustomerByDivision(40)·BizType·UserSiteByEndCustomer(Auth)·UserPlantSiteByEndCustomer/ByDivision·SALES_PLAN_ITEM_ID·CURRENCY_LIST·CELL_PROD_SITE_ID·SiteByEndCustomer40·DM_BIZ_TYPE·SCM0001_*·PR_GET_DAY_RANGE·DMF0021_GET_*(SPREAD_TITLE/DATAEx/MEASUREINFO/MEASUREINFO2)·DMF0003_GET_BUCKET_TYPE_CODE·UP_FX_GetCommonDataList_DM — 전건 매핑.

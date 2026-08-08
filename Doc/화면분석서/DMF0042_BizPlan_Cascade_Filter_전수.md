# DMF0042 Business Plan — 조회조건·Grid Cascade/Filter 전수 (AS-IS ↔ TO-BE 대조)

| 항목 | 값 |
|---|---|
| 원천 | `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0042_BizPlan\DMF0042_BizPlan.cs` (정본 — 2026-05-06 판) + Designer.cs 배선 실측 + 사내 `SCM_ADM_CMBO_SQL_M`·AS-IS `UP_FX_GetCommonDataList` L13630 실측 |
| 분석일 | 2026-08-05 (짝 문서: `DMF0042_BizPlan_주요이벤트_상세분석.md` §1/§2/§5/§6 — 배분·잠금·InsertRow 정밀은 그쪽이 정본) |
| TO-BE | `features/demand/src/pages/business-plan/` — 본 문서 §4 보완 5건 반영 (2026-08-05) |

## §1. 조회조건 cascade 전수 (AS-IS)

이벤트 배선 실측: Division/Bucket = DefineProperty L372~373, Team/Customer = **Designer.cs L773/L733** (활성).
⚠ Bucket 은 Designer L538 + DefineProperty L373 **이중 배선** — 변경 1회당 핸들러 2회 실행(SetSpreadColumn×2, 편집모드 시 EditButton×4. 멱등이라 무해 — 파리티 대상 아님).

| # | 트리거 | cascade 동작 (L = .cs) | 콤보 원천 |
|---|---|---|---|
| 1 | 초기 로드 (InitControls L245~337) | Division→Team→(div분기)BizType·Customer·Measure→Customer→SalesSite→PlantSite→Bucket→**Period(GetDayRange 7개월)**→ItemType→Currency 순차 바인딩 | Division=`MyDivision` / Team=`UserTeamByDivision(div)` / SalesSite=`UserSiteByEndCustomer(div,EC)` / PlantSite=**`UserPlantSiteByDivision(div)`** (EC 무관 — L315 EC판은 주석) / Bucket=`BUCKET2_TYPE_CODE` / ItemType=`ITEM_TYPE_CODE` / Currency=`CURRENCY_LIST` |
| 2 | **Division 변경** (L1485~1570) | `InitSpread()`+`InitSaveDataTable()`(그리드 재구성·저장버퍼 리셋) → #1 전체 재바인딩 반복 → **Period=GetDayRange() 재설정(L1554)** → **txtProject/txtItemId/txtOwner 클리어(L1567~1569)** | div 분기: **40** = BizType=`DM_BIZ_TYPE`(전역)·EC=`EndCustomerByDivision40(div,team)`·Project/PlantSite **비활성** / **81\*** = BizType=`GetBizTypebyDivision(div)`·EC=`UserEndCustomerByDivisionDept(div,team)`·활성 / **82(else)** = 81 동일(Measure '82') |
| 3 | **Team 변경** (L1572~1596) | EC 재바인딩 → SalesSite 재바인딩 (기존 체크 소실 = 사실상 초기화) | 81\*/82: EC=`UserEndCustomerByDivisionDept(div,team)` → Site=`UserSiteByEndCustomer(div,EC현재값)` / 40: EC=`EndCustomerByDivision40(div,team)` → Site=**`SiteByEndCustomer40(div,team,EC)`** (40 전용 원천) |
| 4 | **Customer 변경** (L1598~1610) | SalesSite 재바인딩 | 81\*/82: `UserSiteByEndCustomer(div,EC)` / 40: `SiteByEndCustomer40(div,team,EC)` |
| 5 | Bucket 변경 (L1612~1626) | `SetSpreadColumn()`(버킷별 M_/Q_/Y_ visible — L490~522) + 편집모드면 `EditButton()`×2(잠금 재계산 유지) | — |
| 6 | Sum 체크 (L2895~2901) | `SetSpreadColumn()` — Monthly: Q_/Y_=chk / Quarterly: Y_=chk | — |
| 7 | Bucket 클릭 가드 (L3026~3036) | 신규(I)행 존재 시 MSG00227 경고(변경 차단) | — |
| — | cascade 없음 | Period/Project/Model/Owner/ItemType/PlantSite/BizType = 값만 조회 파라미터 (FindData 16 IN — 주요이벤트 md §4) | |

**AS-IS `EndCustomerByDivision40` 서버 필터 실측** (UP_FX_GetCommonDataList L13630~13694): SITE_ITEM(40) × owner 1토큰 사용자 부서(`B.DEPT_ID`) 를 `@PARAM2(team)` IN-split 필터('ALL'/''=통과) + lookup END_CUSTOMER UNION 은 **team='ALL'일 때만** 포함.

## §2. Grid 수정 가능 컬럼 + cascade/filter 전수 (AS-IS)

### §2.1 수정 가능 컬럼 매트릭스 (행 유형 × division)

| 행 유형 | 편집 가능 | 잠금 |
|---|---|---|
| **DB행(조회)** | 데이터 셀만: EDIT_FLAG='Y' && MEASURE∈{Business_Plan, LOC} 행의 활성 버킷 축(M_/Q_/Y_) — 40: 컷오프 유효창(커서2) 내 / Q_·Y_ 직접입력은 40+유효창만 / 과거 연도 잠금 (EditButton — 주요이벤트 md §2) | 키영역(0~MEASURE) 전 잠금. 그 외 measure(KRW/USD/SalesAmt_\*/CAR_QTY) 행 전체 |
| **신규행(I)** | 키영역 중: 콤보 = DEPT_ID40(40)·DEPT_ID(비40)·END_CUSTOMER·END_CUSTOMER40·SCM_SITE_ID40/81/82·CURRENCY·BIZ_TYPE_NAME81·CELL_PROD_SITE(40) / 팝업 = PROJECT_CODE(81)·PROJECT_CODE82(82)·ITEM_ID·ITEM_ID40 / 텍스트 = INCOTERMS·FCST_TYPE·UNIT_ENERGY(82) 등 + 데이터 셀(버킷·유효창·과거연도 동일) | 파생/표시 40종(InsertRow L1296~1388 — 주요이벤트 md §5-7-3) + MEASURE(자동 세팅·잠금) + DIVISION_ID(자동)·PROJECT_CODE(40) |

### §2.2 신규행 콤보 원천 (InsertRow L1236~1278)

| 컬럼 | 원천 | 비고 |
|---|---|---|
| DEPT_ID40(40) / DEPT_ID(비40) | `UserTeamByDivisionAuth` | Auth 판 |
| END_CUSTOMER / END_CUSTOMER40 | dtCustomer (조회조건과 동일 원천 — div 분기 §1-2) | |
| SCM_SITE_ID40 | `UserSiteByEndCustomerAuth`(40) | Auth 판 |
| SCM_SITE_ID81 / 82 | `UserSiteByEndCustomer`(비40) | |
| CURRENCY | `CURRENCY_LIST` | 2회 중복 세팅(L1244·L1268) |
| BIZ_TYPE_NAME81 | lookup `DM_BIZ_TYPE_81` | |
| CELL_PROD_SITE(40) | `GetCellProdSite('DM_CELL_PROD_SITE','Y')` — 유효건만 | 조회 표시 콤보는 'ALL' 판(InitSpread L392~397) |

### §2.3 Grid cascade (spdMain_ComboSelChange L1628~1659 — **40 전용 2단**)

| 트리거(셀 변경) | cascade |
|---|---|
| END_CUSTOMER40 | 같은 행 `SCM_SITE_ID40` 콤보 재바인딩 = `UserSiteByEndCustomer(40, EC행값)` — 값 클리어 없음 |
| DEPT_ID40 | 같은 행 `END_CUSTOMER40` 콤보 재바인딩 = `EndCustomerByDivision40(40, team행값)` (행값 빈값 → **조회조건 Team 폴백** L1645~1648) → 이어서 `SCM_SITE_ID40` 재바인딩 (2단) |
| (81/82) | grid cascade 없음 — InsertRow 시점 정적 콤보만 |

### §2.4 셀 팝업 cascade (spdMain_CellDoubleClick L1661~1861)

| 팝업 | 진입 가드 | 사전 필터 컨텍스트(행값) | 반영 컬럼 |
|---|---|---|---|
| ITEM (ITEM_ID/ITEM_ID40) | **편집모드 + I행만** (L1706) | div(조회조건)·DEPT_ID·EC/EC40·SCM_SITE_ID40/81/82·PROJECT_CODE/82·ITEM_ID | 클릭셀 + ITEM_ID + ITEM_ID40 + **ITEM_NAME** |
| PROJECT (PROJECT_CODE — 81) | **가드 없음** (DB행에서도 팝업 — AS-IS 특이점) | 행 DIVISION_ID·DEPT_ID·END_CUSTOMER·SCM_SITE_ID81·PROJECT | 클릭셀 + PROJECT_NAME + **BIZ_TYPE_NAME81** |
| PROJECT82 (PROJECT_CODE82) | 가드 없음 | 행 DIVISION_ID·DEPT_ID·END_CUSTOMER·SCM_SITE_ID82·PROJECT_CODE82 | 클릭셀 + PROJECT_NAME + **BIZ_TYPE_NAME82** |
| 헤더 더블클릭 | — | — | Y_→하위 Q_ 토글+열린 M_ 접기 / Q_→하위 M_ 토글 (드릴) |

### §2.5 값 변경 cascade (spdMain_Changed — 배분·롤업 필터)

Red(dirty) 셀만 진행. Business_Plan=정수 split(몫 균등+나머지 마지막 달, MSG00289 소수 절삭) / LOC 등=copy(Q_→M_ 동일값, Y_→"0") — 6분기 매트릭스 정밀은 주요이벤트 md §1 이 정본.

## §3. TO-BE 대조 결과 (2026-08-05 실측 — CMBO SQL 사내 실측 포함)

| # | 항목 | AS-IS | TO-BE(대조 시점) | 판정 |
|---|---|---|---|---|
| F-1 | Division 변경 시 Period | GetDayRange 기본값 재설정 (L1554) | 사용자 선택 유지 | **누락 → 보완**(store `defaultPeriod` + onChange 리셋) |
| F-2 | 81/82 EC 콤보 Team 반영 | `UserEndCustomerByDivisionDept(div,team)` | 'EndCustomer' CMBO(DEPT_ID 반환)를 인라인 toOptions 가 DIVISION_ID 만 필터 | **누락 → 보완**(deptIds 클라 필터 — 카탈로그 EndCustomerField 규약 동일) |
| F-3 | 40 EC 콤보 Team 반영 | `EndCustomerByDivision40(40,team)` 서버 필터 | CMBO 'EndCustomerByDivision40' 는 **DEPT_ID 미반환·team 미지원** (사내 SQL 실측) | **누락 — CMBO SQL 확장 필요 (승인 대기)**: SELECT 에 DEPT_ID(owner 1토큰 부서) 추가 → FE 클라 필터(기적용) 즉시 발효. `_artifacts/_apply_corporate/DMF0042_CMBO_EC40_DEPTID_20260805.sql` |
| F-4 | PlantSite 원천 | `UserPlantSiteByDivision(div)` — EC 무관 (양 지점) | 'PlantSitebyEndCustomer'에 endCustomer 바인드 → EC 선택 시 목록 축소 | **Δ → 보완**(endCustomer 항상 'ALL' 전달 = division 만) |
| G-1 | DEPT_ID40→EC40 grid cascade | EC40 콤보를 team행값(빈값=조회조건 폴백)으로 재바인딩 | END_CUSTOMER40 cascade 필터에 DEPT_ID40 키 부재 | **누락 → FE 선반영**(`{rowKey:'DEPT_ID40', comboKey:'DEPT_ID'}` — 현 CMBO 가 DEPT_ID 미반환이라 관대 통과, F-3 확장 시 즉시 발효) |
| G-2 | PROJECT 팝업 BIZ_TYPE 반영 | BIZ_TYPE_NAME81/82 자동 채움 (L1807/L1857) | 미반영 (bizTypeName 인자 미소비) | **누락 → 보완**(더블클릭 경로 bizTypeName patch — 미제공 시 기존값 보존) |
| — | EC40→Site40 cascade | 재바인딩 | `SCM_SITE_ID40: [DIVISION_ID, END_CUSTOMER40↔END_CUSTOMER]` dataMap 스왑 | ✓ 등가 |
| — | Team/EC 변경 시 하위 clear | 재바인딩(체크 소실) | deptIds→EC·Site clear / EC→Site clear | ✓ 등가 |
| — | Bucket 가드/visible·Sum | MSG00227 + SetSpreadColumn | validateBucketChange + applyDynVisibility | ✓ |
| — | MEASURE 컬럼 | 항상 표시(고정 헤더 병합 축) | admin 메타 VISIBLE 'N' 로 숨김 | **사용자 확정(2026-08-05)** → 정적 컬럼 마지막 상시 표시 + ColumnSetting 목록·titleset 'C' 저장 제외 |

**Δ 기록 (보완 아님 — 확정/확장)**: ①팝업 사전필터 = 'ALL' 고정(2026-07-03 사용자 확정 — AS-IS 행 컨텍스트 전달과 다름) ②ITEM 팝업 NICK_NAME 추가 세팅(TO-BE 확장) ③PROJECT 팝업 ITEM_ID/ITEM_CLASS_NAME clear(TO-BE 확장) ④DEPT_ID40 빈값 시 조회조건 Team 폴백 → TO-BE 는 관대 통과(전체 표시) ⑤40 EC lookup UNION 행: AS-IS 는 team 선택 시 숨김, TO-BE 클라 규약(DEPT_ID 공란=통과)은 항상 표시 ⑥PROJECT 팝업 DB행 가드 없음(AS-IS 특이) → TO-BE 는 I 행만(모달 open 조건) — 안전 강화.

## §4. 보완 적용 내역 (2026-08-05, tsc/eslint 0)

- `useBusinessPlanStore.ts` — `defaultPeriod` 신설(applyDayRange 가 서버값 보관) [F-1]
- `BusinessPlanForm.tsx` — Division onChange Period 리셋 [F-1] / toOptions deptIds 필터 [F-2] / PlantSite endCustomer='ALL' [F-4]
- `business-plan.constants.ts` — END_CUSTOMER40 cascade 에 DEPT_ID40 키 [G-1]
- `BusinessPlanModals.tsx` — PROJECT 팝업 bizTypeName → BIZ_TYPE_NAME81/82 patch [G-2] + MEASURE ColumnSetting 제외 3점
- `BusinessPlanGrid.tsx` — MEASURE 정적 컬럼 마지막 상시 표시
- ⏸ 승인 대기: CMBO `EndCustomerByDivision40` DEPT_ID 컬럼 확장 [F-3] — SQL 준비본 참조

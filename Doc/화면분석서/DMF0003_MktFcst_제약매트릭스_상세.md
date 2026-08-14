# DMF0003 MKT FCST — 제약 매트릭스 상세

> 원천: 정본 `GSCM.DM.Forms.UIL/Plan/DMF0003_MktFcst/DMF0003_MktFcst.cs` 7,143줄 전량 Read (2026-08-12).
> 이벤트 흐름은 `DMF0003_MktFcst_주요이벤트_상세분석.md` 가 정본 — 본 문서는 **제약(잠금/검증/콤보/권한/색) 축 매트릭스**.
> 표기: `81*` = 81,81_UC,81_HM,81_ST,81_HD,81_HG (`.cs Substring(0,2)=="81"`).

## 1. 편집 게이트 (EditButton 진입 순서)

| # | 조건 | 결과 | 근거 |
|---|---|---|---|
| 1 | `SCP Planner` × division 82 또는 40 | MSG00096 차단 | L829~833 (E20260604) |
| 2 | `DM_UI_EDITABLE_DIVISION`('DMF0003',div) EDIT_YN='N' | MSG00448 차단 (40→DMF0082 유도) | L838~846 (PJ2025-50017) |
| 3 | `SCP Planner` × 81* × `SCP_PLANNER_EDIT_FLAG` 0건 | MSG00477 차단 (시간 게이트) | L849~859 (E20260604) |
| 4 | Planner 3그룹 × `DM_PLANNER_EDIT_FLAG` 행 존재 | MSG00478 차단 (인자 5: LIMIT_AUTH/EDIT_DAYS/FROM_TIME/TO_TIME/AUTH) — ⚠ 연산자 우선순위로 DM ADMIN 만 81 한정, Planner 2종은 division 무관 | L863~873 (E20260604) |
| 5 | Planner 3그룹 × 81*/82 × AS_FROM_SITE 컬럼 부재 | MSG00113 차단 | L877~888 (E20260402) |
| 6 | 필수 컬럼 부재 — 81*: 9종(+PlantSiteId) / 82: 8종 / 40: 8종(40 계열 키) | MSG00113 차단 | L891~924 |
| 7 | dt8Week 없음(조회 선행 안 함) | MSG00259 차단 | L941~945 |

## 2. 버킷×시점 잠금 매트릭스 (편집모드 컬럼 단위 / Insert 행 단위 동형)

기준일 = 당주 월요일. 40 추가 기준 = dt8Week(CALENDAR_YYYY/ISO_WEEK/MONTH_NAME — SP Tables[1]).

| Bucket | D_ 컬럼 | W_ 컬럼 | M_ 컬럼 |
|---|---|---|---|
| Daily | 과거(<당주월요일) 잠금 | 전부 잠금 | 전부 잠금 |
| Weekly | 전부 잠금 | 다음 D_ 일자로 과거 판정 잠금 (C20210827) | 전부 잠금 |
| Monthly | 전부 잠금 (40: 조건부 — MONTH_NAME 비교) | 전부 잠금 (40 포함) | 과거 월 잠금 + **40: dt8Week.MONTH_NAME 이전 월 추가 잠금** |

| # | 행 단위 제약 | 근거 |
|---|---|---|
| 1 | `EDIT_FLAG != 'Y'` 행 = Measure 이후 전열 잠금 | L1132~1135 |
| 2 | Measure 컬럼까지(키 영역) 전 행 잠금 — Insert 행만 예외 | L1123 |
| 3 | I 행 아닌 행 Measure 잠금 | L1163·2775 |
| 4 | division 81*/82 → Division 컬럼 잠금 / 40 → Division40 잠금 | L1275~1278·2698~2701 |

## 3. Insert 행 정적 컬럼 잠금 전수 (InsertRow L2697~2783)

| # | 잠금 컬럼 | 근거 |
|---|---|---|
| 1 | Division/Division40/BizType/SoldToCustomer/CountryName/CityName | L2698~2709 |
| 2 | ProjectName/ProjectStatus/ProjectOwner/ItemName/NickName/ItemType | L2710~2721 |
| 3 | CUST_GROUP/CUST_GROUP_DTL/Owner/APPLICATION/ROUTE/MDM_PROJECT_NAME/MIN_CAPACITY/FORECAST_INFO_BIZ_TYPE | L2722~2737 |
| 4 | CellType/FORECAST_INFO_CELL_MODEL/FORECAST_INFO_CELL_PACK_COUNT/FORECAST_INFO_SPEC/VMI_YN/DMS_SALES/DMS_CUSTOMER | L2738~2751 |
| 5 | **AS_FROM_SITE — 초기 잠금** (해제는 §5 AS 3축만) | L2752~2753 (E20260211) |
| 6 | LAST_UPDATE_DATE/LAST_UPDATED_BY/SENDER_CODE/SENDER_NAME | L2754~2761 |
| 7 | **PROJECT_S_OP_REPORT** (E20241030) / **CELL_PER_MODULE** (E20241015) | L2765~2772 |
| 8 | **Team/TeamName — 입력 불가** (E20260311) | L2779~2782 |

편집 개방(Insert 행): 81*/82 = Project(이미지팝업)/ItemId(이미지팝업)/ScmSiteId/Customer/DomExp/FcstType/Incoterms/Measure/
PlantSiteId(**81* 만** — Division ComboSelChange 에서 81* 해제·그 외 잠금 L3348~3351) + AS_FROM_SITE(조건부) /
40 = Customer40/ScmSiteId40/ItemId40(이미지팝업)/DomExp/FcstType/Incoterms/Measure.

## 4. 셀 콤보 매트릭스 (SetCellTypeCombo 전수)

| # | 컬럼 | 원천 (UP_FX_GetCommonDataList_DM @Code / Data.Type) | 파라미터 | 트리거 |
|---|---|---|---|---|
| 1 | FCST_TYPE | `FCST_TYPE` — W/S 그룹=`EDIT_MODE`(SALES_TYPE_CODE2∪_ADD 6종) / 그 외=NowGroupID(비W/S=SALES_TYPE_CODE−ATTRIBUTE2'Y' 11종·W/S=CODE2 4종) | PARAM1=EDIT_MODE 또는 그룹명 | InsertRow L2593~2603 |
| 2 | INCOTERMS | `INCOTERMS`(ALL,'Y' — VALID_YN 만) / AS 사이트 행 = `AS_INCOTERMS`(division, site) 스왑 | PARAM1~2 | InsertRow L2608 / ScmSiteId 변경 L3441~3442 / Paste L6517 |
| 3 | AS_FROM_SITE | `AS_FROM_SITE`(division) | PARAM1=division | InsertRow L2613~2617 (E20260211) |
| 4 | MEASURE | `MktFcstEditMeasure`(division, site, project, userId) — 81*/82 비W/S 는 `AS_In_Req` 삭제, AS 3축 시 단독화(§5) | 4축 | InsertRow L2646·2673 / Division·Site·Project 변경 L3360~3370·4104~4110 / Paste L6506 / CellClick L6628·6645 |
| 5 | TEAM | `UserTeamByDivisionAuth` | 그룹/유저/division | InsertRow L2637·ComboSelChange L3303 |
| 6 | END_CUSTOMER(40) | `EndCustomerByDivision40` | division/team/그룹/유저 | InsertRow L2629 / ComboSelChange L3324·3397 |
| 7 | END_CUSTOMER(81*/82) | `UserEndCustomerByDivisionDeptAuth` | 그룹/유저/division/team | InsertRow L2651 / ComboSelChange L3312·3380 |
| 8 | SCM_SITE_ID | [E20260402] `GetSalesSite`=SiteByEndCustomer(**PARAM5=W/S 'Y'**) — 구 UserSiteByEndCustomerAuth 대체 | division/customer/그룹/유저/W-S | InsertRow L2655 / ComboSelChange L3331·3384·3410 |
| 9 | SCM_SITE_ID40 | `UserSiteByEndCustomer` | 그룹/유저/division/customer | ComboSelChange L3337·3402·3418 |
| 10 | PLANT_SITE_ID | 조회조건 dtPlantSite → 행별 `SalesPlant`/`PlantSiteByItem`(division, project, item) | 3축 | InsertRow L2574 / Project·Item 변경 L4157·4166 / CellClick L6614 |
| 11 | DOM_EXP(40) | `DM_CUSTOMS_HANDBOOK` | — | InsertRow L2569~2570 (C20220704) |

## 5. AS FROM SITE 3축 계약 (E20260211 + E20260402 — DMF0082 이식 정본)

| # | 축 | 활성 조건 | 부수 효과 |
|---|---|---|---|
| 1 | division | `81*` 또는 `82` 만 로직 진입 | 그 외 division 은 항상 잠금(§3-5 초기 잠금 유지) |
| 2 | Sales Site 향 | AS_FROM_SITE 콤보 **Name** 에 행 SCM_SITE_ID 매칭 = **비축향 → 잠금+값 클리어** + Measure `AS_In_Req` 단독(+값 클리어) | 미매칭(고객향) → Measure `MKT_FCST_RP` 단독 + 축3 판정 |
| 3 | FCST Type | 고객향에서 FCST Type ∈ SALES_TYPE_CODE2(4종: WS/WSF/AS/ASF) → **해제** / 아니면 잠금+값 클리어 | 컬럼 부재 시 MSG00472 안내 (FcstType 변경 경로만) |
| 4 | 적용 지점 | ScmSiteId ComboSelChange(L3446~3514) / FcstType ComboSelChange(L3556~3602) / ClipboardPasted(L6521~6589 — 기준 `EDIT_MODE` 6종으로 **더 넓음**) / CellClick Measure(L6633~6686 — Measure 스왑만) | 저장 게이트 §6-4 와 쌍 |
| 5 | 조회 컬럼 강제 | [E20260402] W/S 권한 진입 시 GET_SPREAD_TITLE(p_user_group, p_type='LOAD') 이 AS_FROM_SITE 컬럼 자동 추가 | GetSpdTitle L6349~6352 |
| 6 | 저장값 | 행 컬럼 값 직접 직렬화(sASFromSite `Replace(",","^")`) — 구 cboAS 사문 | L2297·2359·2401 |

## 6. 저장(Validation) 제약

| # | 조건 | 결과 | 근거 |
|---|---|---|---|
| 1 | I 행 키 중복(그리드 전수 — 81*=9키/82·40=8키) | MSG00043 | fnValidation L5910~6019 |
| 2 | I 행 D_ 수량 입력 0건 | MSG00034 | L6022~6041·2260~2264 |
| 3 | dtSave 행 중 그리드 실재+AS_FROM_SITE 일치(bAsCompare)만 dtSaveFinal 승계 / I 저장이 기존 행 키와 같으면 제외 | 조용히 제외 | L6056~6271 |
| 4 | **[E20260402] W/S 그룹 × 81*/82 × 고객향 × FCST Type ∈ W/S 4종 × AS_FROM_SITE 빈값** | MSG00476 차단 | L2300~2329·2362~2391 |
| 5 | 저장 성공(Tables 없음) | MSG00004(건수) + 재조회 + viewport 복원 | L2461~2468 |
| 6 | SP 가 Tables[0] 반환 | 그 메시지 표시 + Tables[1] 있으면 SspSyncPopUp | L2447~2460 |

## 7. 그리드 입력 검증 (spdMain_Changed)

| # | 조건 | 결과 | 근거 |
|---|---|---|---|
| 1 | 수량 셀 수정 시 필수값 빈값 — Division/Project(81*·82)/EndCustomer(40)/SalesSite/Item/DomExp(Customs Handbook 명칭 — C20200420)/FcstType/Incoterms/Measure/PlantSite(81*) | MSG00002(컬럼명) + 값 회수 | L4020~4088 |
| 2 | I 행 키 8~9축 중복 2건 이상 | MSG00260 + 값 회수 | L4172~4313 |
| 3 | Monthly 입력 < 실적(과거 D_) 합 | MSG00225 차단 | L4899~4905 |
| 4 | Weekly 입력 < SSP 동기화(PaleGreen) 합 — 40 × MKT_FCST_RP × **FCST Type≠RMA**(E20241210) | 값을 sync 합으로 되돌림 | L4496~4516 |
| 5 | I 행 키값 변경 | 수량 전부 클리어 + dtSave 에서 제거 | L5319~5379 |
| 6 | I 행 Measure 를 AS_In_Req/BNPIn 외로 변경 | Item 4종 클리어 | L3531~3554 |
| 7 | 버킷 배분 | 주→일: 요일비트(기본 '0000010'=FRI) 균등+잔여 마지막, 비트 없으면 기본요일 단일, PaleGreen 제외 / 월→일: 기본요일(sDefaultDay) 기준 | L4318~5167 |

## 8. 조회조건 제약

| # | 조건 | 결과 | 근거 |
|---|---|---|---|
| 1 | division 미선택 | MSG00097 | L1685~1690 |
| 2 | 기간 from > to | MSG00108 | L1696~1700 |
| 3 | 기간 3년 초과 | MSG00164 + to=from+2년 보정 | L1702~1709 |
| 4 | division=40 | Project/PlantSite/btnProject 비활성, cboCellQty 활성, checkInvalidExec 비활성 | L443~462·3049~3081 |
| 5 | division=82 | checkInvalidExec 활성+**기본 체크**, PlantSite 비활성·클리어, Bucket 기본 **Daily** | L483~487·3129~3135·348~355 |
| 6 | division=81 | lblEDISender 활성(+콤보), PlantSite 활성 | L493~502·3119~3126·3142~3145 |
| 7 | I 행 존재 중 Bucket 변경 시도 | MSG00227 | L6470~6480 |
| 8 | 버킷 변경(편집모드) | EditButton 2회 재호출로 잠금 재계산 | L3282~3288 |
| 9 | 캐스케이드 | Division→Team→EndCustomer→SalesSite(+PlantSite 81) 순 재조회, division 변경 시 txtProject/ItemId/Owner 클리어 | L3019~3164·3166~3215 |

## 9. 색·표시 제약

| # | 대상 | 규칙 | 근거 |
|---|---|---|---|
| 1 | SSP 동기화 셀(40/82) | ATTR1 `일자/A^P` — A=PaleGreen, P=PapayaWhip | L2186~2213 |
| 2 | 당주 라인 | 초록 BevelBorder — count≥2 시 [E20250313] 조회시작>당주월요일 이면 this_YYYYMMWW, 아니면 W_{당주월}{iso} / Daily 는 D_당주월요일 | L2134~2183 |
| 3 | 당주/당월 헤더 | 초록 볼드(굴림 9 Bold) | L5850~5877 |
| 4 | 과거 실적 구간 | chkColor 체크 시 Gainsboro(당월 M_ 는 White) | L1203~1207·2126~2132 |
| 5 | 주말 헤더 | SAT 파랑 / SUN 빨강 | L704~709 |
| 6 | NOTATION 서식 | INTEGER=정수 / POINT=입력 형태 / POINT3=소수 3자리 강제(0.000→0) | L2026~2092 |
| 7 | 저장 후 | Action 클리어 + UnLockColor + 행 재잠금(빨강 계열) | SetSaveSheetColor L2508~2527 |

## 10. 권한(그룹)축 총괄

| # | 그룹 | 제약 |
|---|---|---|
| 1 | ADMIN / DM ADMIN | Master Chg 버튼 조건 충족(단 §1.1-5 최종 숨김) / DM ADMIN 은 81 Planner 시간 게이트 대상 |
| 2 | DM Planner | 81* 시간 게이트(§1-4) / AS_FROM_SITE 컬럼 부재 차단(§1-5) |
| 3 | DM Planner (W/S) | FCST Type=EDIT_MODE 6종 / AS_In_Req 사용 가능(유일) / p_as_yn='Y' / Site 콤보 PARAM5='Y' / 저장 MSG00476 게이트 대상 |
| 4 | SCP Planner | 82·40 편집 차단(MSG00096) / 81* 시간 게이트(MSG00477) / 81* Insert 차단(MSG00096) |
| 5 | 그 외(Viewer 등) | Master Chg 숨김·편집 버튼 BaseForm 권한 체계(hasButton) 위임 |

## 11. SP·외부 호출 전수 (활성)

| # | SP | 용도 | 파라미터 수 |
|---|---|---|---|
| 1 | DM.DMF0003_GET_MKT_FCST_DATA | 조회 | 19 |
| 2 | DM.DMF0003_SAVE_MKT_FCST | 저장 | 16 (p_bucket·p_authority 포함) |
| 3 | DM.DMF0003_GET_SPREAD_TITLE | 헤더 | 6 (p_user_group·p_type 포함) |
| 4 | DM.DMF0003_GET_BUCKET_TYPE_CODE | 버킷 콤보 | 0 |
| 5 | DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP | 동기화 비교 팝업 | 8 |
| 6 | DM.PR_GET_DAY_RANGE | 기간 기본값 | 2 |
| 7 | SCM.SCM0001_GET_LOOKUP_VALUES | ITEM_TYPE_CODE 등 | 1 |
| 8 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | BizType | 1 |
| 9 | DM.UP_FX_GetCommonDataList_DM | 콤보 범용(FCST_TYPE/AS_INCOTERMS/SiteByEndCustomer(40)/DM_CUSTOMS_HANDBOOK/EDI_SENDER_CODE/lookup 범용) | CODE+PARAM1~5 |
| 10 | DataService.GetDMInnerTable | 조회조건 콤보 8축(§1.1-1) | Filter |
| 11 | (팝업 경유) DMF0003_GET_PRPOPUP/GET_PR_HISTORY_POPUP/SAVE_PRPOPUP | PR 계열 | 팝업 내부 |

# DMF0053 (Customer FCST Waterfall) — 조회조건 Cascade/Filter 전수 + 종속 모달 분석

> 작성: 2026-08-27 (T01 — hook #123/#124 ④CRUD+모달 영역)
> AS-IS 원천 = InitControls(L263~369)·cboDivision/clbTeam/clbCustomer Changed(L928~1092) + GetDMInnerTable 6 키 + FoxDataRequest 콤보 6종.
> TO-BE 조회조건 구성 = **#112 카탈로그 'Customer FCST Waterfall' 17행** (`_rules_v2/_mapping/search_conditions_scp_dm.md` L1593~) + Figma `Doc/_figma/CAP_SVG/DMF0053.png` 실측 — 양자 정합 확인.

## 1. 조회조건 17행 (카탈로그 전 행 대조 — #112 의무)

| # | As-Is | To-Be (카탈로그) | Figma 실측 | 데이터 소스 (TO-BE) | cascade 종속 |
|---|---|---|---|---|---|
| 1 | Div* (단일) | **Div.** (명칭 O) | 1행: "40 Mobility & IT Battery" | master `DivisionField` (MyDivision 계보) | → 전부 |
| 2 | Team (다중) | Team + 검색·ALL | 1행 ALL | `TeamField` division prop | → End Customer, Sales Site |
| 3 | End Customer (다중) | End Customer + 검색·ALL | 1행 ALL | `EndCustomerField` division/team | → Sales Site |
| 4 | Sales Site (다중) | Sales Site + 검색·ALL | 1행 ALL | `SalesSiteField` division/endCustomer(81*·82)·+team(40) | — |
| 5 | Biz Type (다중) | **Biz. Type** (명칭 O) | 2행 ALL | `BizTypeField` division | — |
| 6 | Input Date* (drpCreateDate) | Input Date (달력) | 2행 2026.03.01~2026.08.3 | PeriodField 계보 — 초기값 `PR_GET_DAY_RANGE(p_month=1)` 2번째 커서 | — |
| 7 | Period* (drpPeriod) | Period (달력) | 2행 2026.03.01~2026.08.31 | 동일 SP `p_month=6` | — |
| 8 | Bucket (단일) | Bucket | 2행 Monthly | `DMF0003_GET_REPORT_BUCKET_TYPE_CODE` (공유) — 기본 **MONTHLY** (DefineProperty L374) | → 타이틀 재조회·컬럼 가시성 |
| 9 | Project (다중·팝업, 40 비활성) | **PJT** (명칭 O, 프2) | 3행 PJT+🔍 | master `ProjectByDivisionModal` | Division 클리어 대상 |
| 10 | Model / Nickname (다중·팝업 모3) | **Model/Nickname** (명칭 O) | 3행 +🔍 | master `ItemByDivisionModal` | 동일 |
| 11 | Plant Site (다중, 40 비활성) | Plant Site + 검색·ALL | 3행 ALL | `PlantSiteField` division | — |
| 12 | Item Type (다중) | Item Type + 검색·ALL | 3행 ALL | `SCM0001_GET_LOOKUP_VALUES` p_lookup_type='ITEM_TYPE_CODE' → 공용 lookup 콤보 | — |
| 13 | Owner (다중·팝업 오1) | Owner | 4행 +🔍 | master `OwnerByDivisionModal` | 동일 |
| 14 | QTY (단일) | (공통기능화 검토) | 4행 "QTY/1" 실존 | `DMF0003_GET_QTY_TYPE_CODE` (공유) — **Figma 실존 → 구현** (÷1/1,000/1,000,000/100,000,000) | 표시 사본만 |
| 15 | Sum (체크) | (공통기능화 검토) | 4행 실존 | 로컬 상태 — **Figma 실존 → 구현** | D_/W_ 상위 집계 가시성 |
| 16 | Column Setting 버튼 | (공통기능화) | 그리드 우상 아이콘 | SubTitle customButtons — 공용 `ColumnLayoutModal` (hook #120 순서: ColumnSet→Measure) | UC-03 |
| 17 | Measure 버튼 | (공통기능화) | 동일 | master `MeasureSelectModal` | UC-03 |

> ⭐ **Version(Date*) 칸 = TO-BE 미구현**: AS-IS 는 txtVersion(라벨 "Date*")+btnVersion(**Visible=false**)+KeyDown 진입의 은닉 기능. #112 카탈로그 17행·Figma 프레임 양쪽 모두 부재 → 조회조건에서 제외하고 SP `versionNo=''` 고정 전달. `SCM0002_VersionByWaterfallPopup`("CF" 축) 도 함께 제외 (대사표 MODAL 행에 사유 기재).

## 2. Cascade 매트릭스 (AS-IS 실측 → TO-BE)

| 트리거 | 재적재 | 클리어 | 81*/82 vs 40 분기 |
|---|---|---|---|
| Division 변경 | Team, End Customer, Biz Type, Sales Site, Plant Site (+타이틀 재조회) | PJT·Model·Owner (텍스트 4칸 — AS-IS L1020~1023. Version 칸은 미구현) + **Grid 데이터 초기화+CRUD reset (§1.4)** | 81*(접두)·82: PJT/Plant Site **활성** / 40: **비활성** (AS-IS L951~983 — ⚠ DMF0040 과 반대) |
| Team 변경 | End Customer → Sales Site | — | 81*/82: SalesSite 에 team 미전달('') / 40: team 전달 |
| End Customer 변경 | Sales Site | — | 동일 분기 |
| Bucket 변경 | 스프레드 타이틀 재조회 (W·M→D / ONLY_WEEKLY 진출입 시) + 컬럼 가시성 | — | — |
| ONLY_WEEKLY | Sum 체크 **비활성+해제** (InitSpread L394~398) | — | — |

## 3. 종속 모달 4영역 분석 (hook #124 — 각 모달 = MAIN 동등)

| 모달 | AS-IS 팝업 (.cs 라인) | TO-BE 정본 | 4영역 판정 |
|---|---|---|---|
| PJT 검색 | `SCM0002_ProjectbyDivisionPopupEx` L1286 — Form_Load(true, div, team, endCust, scmSite, project) | master `ProjectByDivisionModal` (공용 — 사본 금지 #132) | 디자인=공용 정본 / V=팝업 내부 소관 / E=열기·선택 반영(E15) / CRUD=R 전용 |
| Model/Nickname 검색 | `DM0002_ItembyDivisionPopupEx` L1311 — Form_Load(false, div, 'ALL', 'ALL', scmSite, project, itemId) | master `ItemByDivisionModal` | 동일 (E16) |
| Owner 검색 | `DM0020_OwnerbyDivisionPopup` L1713 — Form_Load(true, div, team, endCust, scmSite, project, itemId, owner) | master `OwnerByDivisionModal` | 동일 (E23) |
| Column/Measure 설정 | `DM0002_TitleSetForm_Popup("DMF0053", 'CUST Fcst Waterfall', bool, division)` L1328·1340 | 공용 `ColumnLayoutModal`('C') + `MeasureSelectModal` — titleSet SAVE = `SCM0002_SET_TITLESET_POPUP` | E17/E18 + UC-03(저장=그리드 비움) + 저장 성공 Toast(#132) |
| (제외) Version | `SCM0002_VersionByWaterfallPopup` "CF" L1664 — btnVersion 숨김 | — | 제외 (§1 Version 항 사유) |
| (제외) 셀 더블클릭 Project/Item | `SCM0002_ProjectbyDivisionPopup`/`SCM0002_ItembyDivisionPopup` L1221·1238 | — | 제외 (dead path — ACTION='I' 전용, 읽기 전용 화면) |

## 4. 콤보 토큰 대사 (hook #117 §5.6 선행 정리)

| 콤보 | 필요 토큰 | 전달 주체 |
|---|---|---|
| Division | (관대 — 목록 자체) | 공용 SQL |
| TeamByDivision / EndCustomerByDivision / BizTypeByDivision / PlantSitebyEndCustomer / SiteByEndCustomer | @divisionId (+@endCustomer) | master 공용 검색필드 prop (`division=`/`endCustomer=`) — DMF0040 §5.6 대사표 계보 동일 |
| ItemType (LOOKUP) | @param1='ITEM_TYPE_CODE' | 공용 lookup 콤보 파라미터 |
| Bucket / QTY | 무토큰 | 공유 SP (DMF0003_GET_REPORT_BUCKET_TYPE_CODE / DMF0003_GET_QTY_TYPE_CODE) |

## 5. Grid 셀 콤보/이벤트 (#146)

- 그리드 셀 EVENT 배선 실측 4종 (Designer L1421~1424): CellDoubleClick(E11 헤더 드릴다운=구현 / E12 셀 팝업=dead) · ComboSelChange(E10=dead) · TopChange(E13=wijmo 기본) · KeyUp(E14=Copy 만)
- **편집 셀 콤보 0종** — 조회 후 전열 잠금(L786)·Insert 미노출. `events_grid_cell.md` 별도 파일은 본 문서 §5 로 갈음 (셀 편집 이벤트 부재 실측).

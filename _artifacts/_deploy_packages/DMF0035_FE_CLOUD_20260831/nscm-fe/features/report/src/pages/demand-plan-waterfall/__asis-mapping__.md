# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `DMF0035_DemandPlanWaterfall_ASIS_통합분석_v1.0.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:WaterfallVersionModal | FE 실존 모달 (components/WaterfallVersionModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) |  |  | 미구현 |
| REQ:CHAT-20260828-UM01-DMF0035 | Div Default 선택 + 변경 시 초기화 | EV:features/report/src/pages/demand-plan-waterfall/DemandPlanWaterfall.tsx::UM-01 Division 기본 선택 · FE:handleDivisionChange · FE:clearData |  | 구현 |
| REQ:CHAT-20260828-UM02-DMF0035 | Team 선택 시 End Customer cascade | FE:E20260831-UM02FIX;;FE:DEPT_ID: \{ values: searchParams.deptIds |  | 구현 |
| REQ:CHAT-20260828-UM03-DMF0035 | div 선택 시 Biz.Type / Plant Site cascade | EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx::PlantSiteField · EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx::BizTypeField |  | 구현 |
| REQ:CHAT-20260828-UM04-DMF0035 | 숫자 자릿수 AS-IS 동일 | FE:scaleOf · EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::DATA_SCALE_NUMBER |  | 구현 |
| REQ:CHAT-20260828-UM05-DMF0035 | 초기화 일자 AS-IS 동일 | FE:defaultPeriod |  | 구현 |
| REQ:CHAT-20260828-UM06-DMF0035 | header 높이 1단 크기·최대 3줄 | EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::HEADER_TOTAL_PX |  | 구현 |
| REQ:CHAT-20260828-UM07-DMF0035 | 필터 버튼 동작 | EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::new FlexGridFilter\(g\) |  | 구현 |
| REQ:CHAT-20260828-UM08-DMF0035 | (BUCKET) 즉각 반응 / ONLY_WEEKLY 전환 시 grid 초기화+헤더 재생성 | FE:isBucketResetBoundary · FE:resetForBucket |  | 구현 |
| REQ:CHAT-20260828-UM09-DMF0035 | (BUCKET) ONLY_WEEKLY 헤더 주차:날짜 1:1 | EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::UM-09 |  | 구현 |
| REQ:CHAT-20260828-UM10-DMF0035 | (BUCKET) 월/주차 헤더 더블클릭 접힘·펼침 |  | ⚠ USER-DECISION — OLAP 피벗은 단일 PERIOD 축(접두 토글)이라 M_→W_→D_ 헤더 드릴은 계층 재설계 필요(잔여 4). 사용자 결정 대기. type-check·lint PASS · HTTP E2E 종합 PASS(2026-08-28) · 실화면 사용자 확인 인계 | 해당없음 |
| REQ:CHAT-20260828-UM11-DMF0035 | (BUCKET) ONLY_WEEKLY 최하단 sum | EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::showRowTotals |  | 구현 |
| REQ:CHAT-20260828-UM12-DMF0035 | 합계 값 기준 AS-IS 통일 | EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::aggregate: 'Sum' |  | 구현 |
| REQ:CHAT-20260828-C1-DMF0035 | COLUMN 전체 조회 + DIVISION DEFAULT 만 ROWS | EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::extraColumnFields;;EV:_artifacts/_apply_corporate/DMF0035_ALLCOLS_20260828/_patch_apply.py::E20260828-ALLCOLS | 사내 적용 완료 2026-08-28 (컬럼 22→55·행수 불변) | 구현 |
| REQ:CHAT-20260828-C2-DMF0035 | MEASURE 컬럼 VISIBLE='N' 이어도 항상 표시 | EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::MEASURE | 사내 적용 완료 2026-08-28 (C1 동일 패치) | 구현 |
| REQ:CHAT-20260828-C3-DMF0035 | BUCKET 3종 필드 등록 + 선택 BUCKET 만 COLUMNS | EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::bucketFieldsFor;;EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::extraFields |  | 구현 |
| REQ:CHAT-20260828-C4-DMF0035 | Grid Layout FILTERS 필터 편집 영역 | EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx::FilterEditorPopover;;EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx::PivotFilterEditor |  | 구현 |
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 해당없음 — Insert 기능 없음 (읽기 전용 화면, AS-IS InsertButton 빈 구현) | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) |  | 해당없음 — 편집 기능 없음 (수정 중 상태가 존재하지 않음) | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | DemandPlanWaterfall.tsx:ColumnLayoutModal onSave·MeasureSelectModal onApply → clearData() (filters 리셋 = 그리드 비움, hook #132 §2-2) |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) |  | 해당없음 — CRUD 저장 없음 (titleSet 개인화 저장은 공용 모달 경로) | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | 공용 SubTitle Excel Download (gridAction dataMap 승계 — 본 화면 정적 컬럼은 콤보 셀 없음·코드 그대로가 원장 값) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | components/DemandPlanWaterfallForm.tsx:ProjectField/ItemField/OwnerField — master 공용 필드의 콤마 다중 입력 지원 (join(',') 전달 useDemandPlanWaterfallStore.ts:setFilters) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/DemandPlanWaterfallGrid.tsx (공용 DataGrid 소비 — rebindFilterColumns 는 packages/shared 공용 DataGrid 내장 L850~852, 화면 배선 불요) |  | 구현 |
| REQ:CHAT-20260831-W01 | Div Default 선택안됨·변경 시 초기화 안됨 (+Layout 조회상태 한정이면 초기화 시 빈값, Grid 초기화) |  |  | 미구현 |
| REQ:CHAT-20260831-W02 | Team 선택 시 End Customer cascade 누락 | FE:E20260831-UM02FIX |  | 구현 |
| REQ:CHAT-20260831-W34 | DMF0035 SALES PLAN TYPE 선택 시 OLAP GRID 데이터 미조회 | EV:_artifacts/_apply_corporate/DMF0035_W34_DEFAULTFLAG_20260831/01_PKG_DMF0022_BODY.sql::E20260831-W34 |  | 구현 |
| REQ:CHAT-20260831-W35 | DMF0035 PERIOD 초기값 6개월 설정 | FE:E20260831-PERIOD6M |  | 구현 |
| REQ:CHAT-20260831-W36 | DMF0035 조회조건 BUCKET 에서 ONLY WEEKLY 제거 | FE:E20260831-NOONLYWEEKLY |  | 구현 |
| REQ:CHAT-20260831-W37 | DMF0035 BUCKET 변경 시 GRID 초기화 | FE:E20260831-BUCKETRESET |  | 구현 |
| REQ:CHAT-20260831-W38 | GRID LAYOUT 레일 전체 WIDTH 150% 확대 + ROWS 영역 항목 많으면 VSCROLLBAR | EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.module.scss::E20260831-RAILW150 |  | 구현 |
| REQ:CHAT-20260831-W39 | SALES PLAN GRID 컬럼 순서 재배치 — 정적 → VERSION·MEASURE → 동적 (MEASURE 는 SALES/BIZ 도 동적 앞 고정) | FE:E20260831-W39 |  | 구현 |
| REQ:CHAT-20260831-W40 | WATERFALL TYPE 변경 시 PERIOD 초기값 6개월 재설정 | FE:E20260831-PERIOD6M |  | 구현 |
| REQ:CHAT-20260831-W03 | div 선택 시 Biz.Type/Plant Site cascade 누락 |  |  | 미구현 |
| REQ:CHAT-20260831-W04 | 82 선택 시 Plant Site 활성화 |  |  | 미구현 |
| REQ:CHAT-20260831-W05 | 81 일때만 Sender Code 활성 (JV 비활성) |  |  | 미구현 |
| REQ:CHAT-20260831-W06 | 선택 div 기준 version = Current default | FE:E20260831-VERCUR |  | 구현 |
| REQ:CHAT-20260831-W07 | waterfall type 변경 시 전체 초기화 (+Layout 빈값 세부) |  |  | 미구현 |
| REQ:CHAT-20260831-W08 | 초기화 시 종료일자 잘못됨 (6개월) |  |  | 미구현 |
| REQ:CHAT-20260831-W09 | sort/filter 적용 가능 확인 후 적용 |  |  | 미구현 |
| REQ:CHAT-20260831-W10 | Menu context 적용 여부 확인 후 적용 |  |  | 미구현 |
| REQ:CHAT-20260831-W11 | waterfall type·div 별 column/pivot layout 에 UI Category 전량 적용 (우측 layout 건수 ≠ category 건수) + 개인화 팝업 연동 | FE:E20260831-METASHEET |  | 구현 |
| REQ:CHAT-20260831-W12 | Measure 항목 안 보임 (VISIBLE/DEFAULT Y 시 보임·Layout 에서 Measure 제외) + sales plan SQL 오류 |  |  | 미구현 |
| REQ:CHAT-20260831-W13 | 컬럼 영역 클릭 안 됨 |  |  | 미구현 |
| REQ:CHAT-20260831-W14 | 컬럼을 filter 영역으로 이동 시 동작 확인 (현재 안 보임) |  |  | 미구현 |
| REQ:CHAT-20260831-W15 | 엑셀 다운로드 Column 영역 포함(보이는 대로) + 파일명에 waterfall type |  |  | 미구현 |
| REQ:CHAT-20260831-W16 | DATA 영역 SORT 기능 삭제 |  |  | 미구현 |
| REQ:CHAT-20260831-W17 | DATA 영역 소수점 삭제 |  |  | 미구현 |
| REQ:CHAT-20260831-W18 | DATA 클릭 시 마지막 컬럼 TEXT BOLD 삭제 |  |  | 미구현 |
| REQ:CHAT-20260831-W19 | GRID 표준 CSS 공통 적용 (영역 색 구분 제거·폰트) |  |  | 미구현 |
| REQ:CHAT-20260831-W20 | waterfall type 별 UI CATEGORY FIX/WIDTH 적용 (가능여부 판단) |  |  | 미구현 |
| REQ:CHAT-20260831-W21 | Waterfall type 별 AS-IS 건수·합계 차이 |  |  | 미구현 |
| REQ:CHAT-20260831-W22 | DIV 82/Sales plan(Biz plan 동일) Plant Site 비활성 — AS-IS 활성 |  |  | 미구현 |
| REQ:CHAT-20260831-W23 | KRW/USD/LOC 표시값 AS-IS 통일 (KRW/1, KRW/1,000 …) |  |  | 미구현 |
| REQ:CHAT-20260831-W24 | Cell QTY 조회조건 — 40만 활성, 나머지 비활성 |  |  | 미구현 |
| REQ:CHAT-20260831-W25 | MKT FCST TYPE 조회조건 LAYOUT 을 Sales plan/Biz 와 통일 (Project/Plant Site 접힘 영역 배치) |  |  | 미구현 |
| REQ:CHAT-20260831-W26 | DMF0035 동적(기간) 컬럼에만 필터 아이콘 보임 — 아이콘 숨김 | FE:E20260831-NOFILTERICON |  | 구현 |
| REQ:CHAT-20260831-W27 | waterfall type 변경 시 Version 초기값 = CURRENT (전 타입) | FE:E20260831-VERCUR |  | 구현 |
| REQ:CHAT-20260831-W28 | Grid Layout 3섹션(Subtotal/Fields/Zones) 사이 스플릿바로 사이즈 조절 | FE:E20260831-RAILSPLIT |  | 구현 |
| REQ:CHAT-20260831-W29 | DMF0035 공통 FILTER/SORT 기능 제외 — 공통버튼 숨김 | FE:E20260831-NOCOMMONFS |  | 구현 |
| REQ:CHAT-20260831-W30 | AS-IS Waterfall 공통 메저 선택 — DMF0035 에 Measure 아이콘 버튼+기능 추가 + OLAP GRID 에 MEASURE 필수 유지 | FE:E20260831-MEASURE |  | 구현 |
| REQ:CHAT-20260831-W31 | DMF0035 전 waterfall type 에 Version 필수 조회조건 | FE:E20260831-VERREQ |  | 구현 |
| REQ:CHAT-20260831-W32 | DMF0035 Chart 버튼 삭제 | FE:E20260831-NOCHARTBTN |  | 구현 |
| REQ:CHAT-20260831-W33 | DMF0035 MKT FCST 에서 OLAP GRID 에 MEASURE 미표시 — 메저를 동적 컬럼 앞(Rows 최하단)에 항상 고정 | FE:E20260831-MEASROW |  | 구현 |
| REQ:CHAT-20260831-W41 | DMF0035 BIZ PLAN 조회 시 DIVISION 누락 — 선택된 조회조건 DIVISION 표시 | EV:_artifacts/_apply_corporate/DMF0035_W34_DEFAULTFLAG_20260831/03_PKG_DMF0051_BODY.sql::E20260831-W41 |  | 구현 |
| REQ:CHAT-20260831-W43 | DMF0035 BIZ PLAN 건수 대사(AS-IS 9,330/클라우드 V002 9,310/로컬) + 로컬 CURRENT·버전 조회 0건 | EV:_artifacts/_apply_corporate/DMF0035_W34_DEFAULTFLAG_20260831/03_PKG_DMF0051_BODY.sql::E20260831-VERCASE |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 해당없음 — Insert 기능 없음 (읽기 전용 화면, AS-IS InsertButton 빈 구현) | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) |  | 해당없음 — 편집 기능 없음 (수정 중 상태가 존재하지 않음) | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | DemandPlanWaterfall.tsx:ColumnLayoutModal onSave·MeasureSelectModal onApply → clearData() (filters 리셋 = 그리드 비움, hook #132 §2-2) |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) |  | 해당없음 — CRUD 저장 없음 (titleSet 개인화 저장은 공용 모달 경로) | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | 공용 SubTitle Excel Download (gridAction dataMap 승계 — 본 화면 정적 컬럼은 콤보 셀 없음·코드 그대로가 원장 값) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | components/DemandPlanWaterfallForm.tsx:ProjectField/ItemField/OwnerField — master 공용 필드의 콤마 다중 입력 지원 (join(',') 전달 useDemandPlanWaterfallStore.ts:setFilters) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/DemandPlanWaterfallGrid.tsx (공용 DataGrid 소비 — rebindFilterColumns 는 packages/shared 공용 DataGrid 내장 L850~852, 화면 배선 불요) |  | 구현 |

## UI 필수 12행동(UM) 축 (2026-08-28 — hook #149, 착수 화면부터)

> 원천: 사용자 지정 12항목(2026-08-28) — hook #149 `ui-mandatory-12-behaviors`. 12행 전부 판정(구현+위치 / 해당없음+사유). 빈 행 = FAIL.
> 코드 증거(판정신호)는 원장 `REQ:CHAT-20260828-UM{nn}-<MENU>` 행이 담당 — 산문 '정합' 만으로 구현을 쓰지 말 것.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| UM-01 | Div Default 선택(세션 division 우선·없으면 첫 행) + Division 변경 시 Grid 초기화·CRUD reset (hook #149 / #59 §1.4) | DemandPlanWaterfall.tsx (MyDivision effect · handleDivisionChange→clearData) / useDemandPlanWaterfallStore.ts clearData | 런타임 probe PASS (um12_browser_probe 2026-08-28) | 구현 |
| UM-02 | Team 선택 시 End Customer cascade (EndCustomerField cascade DEPT_ID strict — AS-IS EndCustomerByDivision(division, team)) | components/DemandPlanWaterfallForm.tsx EndCustomerField cascade={{ DEPT_ID: { values, strict: true } }} |  | 구현 |
| UM-03 | Division 선택 시 Biz.Type / Plant Site cascade + 81*/82 활성 분기 (AS-IS cboDivision_SelectedIndexChanged) | components/DemandPlanWaterfallForm.tsx BizTypeField division= / PlantSiteField division= endCustomer= disabled 분기 |  | 구현 |
| UM-04 | 숫자 자릿수 = AS-IS (타이틀 SP DATA_SCALE_NUMBER 소비 — SpreadInfo.cs L1433~1440 decimalPlaces) | components/DemandPlanWaterfallGrid.tsx DynColMeta scale (scaleOf DATA_SCALE_NUMBER) / demand-plan-waterfall.constants.ts scaleOf·DEFAULT_DYN_SCALE |  | 구현 |
| UM-05 | 초기 일자 = AS-IS (PR_GET_DAY_RANGE p_month — 당월 1일~+p_month 개월 말일) | useDemandPlanWaterfallStore.ts defaultPeriod (PR_GET_DAY_RANGE 등가) |  | 구현 |
| UM-06 | 헤더 높이 = 1단 크기(48px) 안에 최대 3줄 (#93 — DataGrid row 단위 강제) | components/DemandPlanWaterfallGrid.tsx HEADER_TOTAL_PX / applyHeaderHeight (columnHeaders.rows[i].height=48/단수) | probe 총 48 | 구현 |
| UM-07 | 필터 버튼(F4) 실동작 — gridFilterRef 페이지→Grid→DataGrid 관통 (OLAP = Grid Layout 레일 Filters) | DemandPlanWaterfall.tsx hotkeyConfig.filter → setShowLayout(true) / components/olap-field-rail/OlapFieldRail.tsx FilterEditorPopover (PivotFilterEditor) | OLAP 은 컬럼필터 대신 Grid Layout 레일 Filters 편집기 | 구현 |
| UM-08 | (BUCKET) 선택 즉시 컬럼 가시성 반응 + ONLY_WEEKLY 경계 전환 시 grid 초기화·헤더 재생성 (AS-IS InitSpread) | components/DemandPlanWaterfallGrid.tsx extraFields(bucket 3종 PERIOD 바인딩)·handleLayoutChange→onBucketChange / demand-plan-waterfall.constants.ts isBucketResetBoundary(gubun) / useDemandPlanWaterfallStore.ts resetForBucket |  | 구현 |
| UM-09 | (BUCKET) ONLY_WEEKLY 헤더 = AS-IS 3행(월/주차/SUM) 병합 없음, 주차:날짜 1:1 (사용자 결정 2026-08-28) | components/DemandPlanWaterfallGrid.tsx columnFields ONLY_WEEKLY = [PERIOD_LARGE 'Period', PERIOD_SMALL] + 값 헤더 'SUM' | probe rows [16,16,16]=48 | 구현 |
| UM-10 | (BUCKET) 월/주차 헤더 더블클릭 접힘·펼침 — 머지 원점(getMergedRange) 복원 (#103) | (OLAP) 단일 PERIOD 축 — 월/주차 계층 접힘은 피벗 축 재설계 필요 | 사용자 결정 대기 — 원장 REQ:CHAT-20260828-UM10-DMF0035 USER-DECISION | 해당없음 |
| UM-11 | (BUCKET) ONLY_WEEKLY 에도 최하단 sum (footer 는 bucket 무관 항상 — AS-IS InitSpreadFooterSum) | components/DemandPlanWaterfallGrid.tsx showRowTotals='GrandTotals' |  | 구현 |
| UM-12 | 합계 값 기준 = AS-IS (SumIgnoreHidden = 표시 행·컬럼 클라이언트 합, SP 합계행 없음) | components/DemandPlanWaterfallGrid.tsx valueFields aggregate:'Sum' | ⚠ AS-IS 가격 메저(KRW/USD/LOC) AVG 미적용 — 잔여 | 구현 |

## 보완요청(REQ) 축 (2026-08-20 — 사용자 지정 보완요청 · 대상: DMF0035)

> 원장: `Doc/단위테스트_보완대상/보완요청_원장.md` · 대상 UI=DMF0035 행 59건.
> ⭐ 미적용 전제 — 원장 PENDING 행은 본 표 상태와 무관하게 --check FAIL. 전이는 실측 근거 기입 시에만 (사전 판단 SKIP 금지).

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| REQ:CHAT-20260828-UM01-DMF0035 | Div Default 선택 + 변경 시 초기화 | EV:features/report/src/pages/demand-plan-waterfall/DemandPlanWaterfall.tsx::UM-01 Division 기본 선택 · FE:handleDivisionChange · FE:clearData |  | 구현 |
| REQ:CHAT-20260828-UM02-DMF0035 | Team 선택 시 End Customer cascade | FE:E20260831-UM02FIX;;FE:DEPT_ID: \{ values: searchParams.deptIds |  | 구현 |
| REQ:CHAT-20260828-UM03-DMF0035 | div 선택 시 Biz.Type / Plant Site cascade | EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx::PlantSiteField · EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx::BizTypeField |  | 구현 |
| REQ:CHAT-20260828-UM04-DMF0035 | 숫자 자릿수 AS-IS 동일 | FE:scaleOf · EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::DATA_SCALE_NUMBER |  | 구현 |
| REQ:CHAT-20260828-UM05-DMF0035 | 초기화 일자 AS-IS 동일 | FE:defaultPeriod |  | 구현 |
| REQ:CHAT-20260828-UM06-DMF0035 | header 높이 1단 크기·최대 3줄 | EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::HEADER_TOTAL_PX |  | 구현 |
| REQ:CHAT-20260828-UM07-DMF0035 | 필터 버튼 동작 | EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::new FlexGridFilter\(g\) |  | 구현 |
| REQ:CHAT-20260828-UM08-DMF0035 | (BUCKET) 즉각 반응 / ONLY_WEEKLY 전환 시 grid 초기화+헤더 재생성 | FE:isBucketResetBoundary · FE:resetForBucket |  | 구현 |
| REQ:CHAT-20260828-UM09-DMF0035 | (BUCKET) ONLY_WEEKLY 헤더 주차:날짜 1:1 | EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::UM-09 |  | 구현 |
| REQ:CHAT-20260828-UM10-DMF0035 | (BUCKET) 월/주차 헤더 더블클릭 접힘·펼침 |  | ⚠ USER-DECISION — OLAP 피벗은 단일 PERIOD 축(접두 토글)이라 M_→W_→D_ 헤더 드릴은 계층 재설계 필요(잔여 4). 사용자 결정 대기. type-check·lint PASS · HTTP E2E 종합 PASS(2026-08-28) · 실화면 사용자 확인 인계 | 해당없음 |
| REQ:CHAT-20260828-UM11-DMF0035 | (BUCKET) ONLY_WEEKLY 최하단 sum | EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::showRowTotals |  | 구현 |
| REQ:CHAT-20260828-UM12-DMF0035 | 합계 값 기준 AS-IS 통일 | EV:features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::aggregate: 'Sum' |  | 구현 |
| REQ:CHAT-20260828-C1-DMF0035 | COLUMN 전체 조회 + DIVISION DEFAULT 만 ROWS | EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::extraColumnFields;;EV:_artifacts/_apply_corporate/DMF0035_ALLCOLS_20260828/_patch_apply.py::E20260828-ALLCOLS | 사내 적용 완료 2026-08-28 (컬럼 22→55·행수 불변) | 구현 |
| REQ:CHAT-20260828-C2-DMF0035 | MEASURE 컬럼 VISIBLE='N' 이어도 항상 표시 | EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::MEASURE | 사내 적용 완료 2026-08-28 (C1 동일 패치) | 구현 |
| REQ:CHAT-20260828-C3-DMF0035 | BUCKET 3종 필드 등록 + 선택 BUCKET 만 COLUMNS | EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::bucketFieldsFor;;EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx::extraFields |  | 구현 |
| REQ:CHAT-20260828-C4-DMF0035 | Grid Layout FILTERS 필터 편집 영역 | EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx::FilterEditorPopover;;EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx::PivotFilterEditor |  | 구현 |
| REQ:CHAT-20260831-W01 | Div Default 선택안됨·변경 시 초기화 안됨 (+Layout 조회상태 한정이면 초기화 시 빈값, Grid 초기화) |  |  | 미구현 |
| REQ:CHAT-20260831-W02 | Team 선택 시 End Customer cascade 누락 | FE:E20260831-UM02FIX |  | 구현 |
| REQ:CHAT-20260831-W34 | DMF0035 SALES PLAN TYPE 선택 시 OLAP GRID 데이터 미조회 | EV:_artifacts/_apply_corporate/DMF0035_W34_DEFAULTFLAG_20260831/01_PKG_DMF0022_BODY.sql::E20260831-W34 |  | 구현 |
| REQ:CHAT-20260831-W35 | DMF0035 PERIOD 초기값 6개월 설정 | FE:E20260831-PERIOD6M |  | 구현 |
| REQ:CHAT-20260831-W36 | DMF0035 조회조건 BUCKET 에서 ONLY WEEKLY 제거 | FE:E20260831-NOONLYWEEKLY |  | 구현 |
| REQ:CHAT-20260831-W37 | DMF0035 BUCKET 변경 시 GRID 초기화 | FE:E20260831-BUCKETRESET |  | 구현 |
| REQ:CHAT-20260831-W38 | GRID LAYOUT 레일 전체 WIDTH 150% 확대 + ROWS 영역 항목 많으면 VSCROLLBAR | EV:nscm-fe/features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.module.scss::E20260831-RAILW150 |  | 구현 |
| REQ:CHAT-20260831-W39 | SALES PLAN GRID 컬럼 순서 재배치 — 정적 → VERSION·MEASURE → 동적 (MEASURE 는 SALES/BIZ 도 동적 앞 고정) | FE:E20260831-W39 |  | 구현 |
| REQ:CHAT-20260831-W40 | WATERFALL TYPE 변경 시 PERIOD 초기값 6개월 재설정 | FE:E20260831-PERIOD6M |  | 구현 |
| REQ:CHAT-20260831-W41 | DMF0035 BIZ PLAN 조회 시 DIVISION 누락 — 선택된 조회조건 DIVISION 표시 | EV:_artifacts/_apply_corporate/DMF0035_W34_DEFAULTFLAG_20260831/03_PKG_DMF0051_BODY.sql::E20260831-W41 |  | 구현 |
| REQ:CHAT-20260831-W43 | DMF0035 BIZ PLAN 건수 대사(AS-IS 9,330/클라우드 V002 9,310/로컬) + 로컬 CURRENT·버전 조회 0건 | EV:_artifacts/_apply_corporate/DMF0035_W34_DEFAULTFLAG_20260831/03_PKG_DMF0051_BODY.sql::E20260831-VERCASE |  | 구현 |
| REQ:CHAT-20260831-W44 | DMF0035 메저 5개 선택했는데 건수 15,897 그대로 표시 | FE:E20260831-MEASCOUNT |  | 구현 |
| REQ:CHAT-20260831-W45 | DMF0035 메저 COLUMN FIX 해제 | FE:E20260831-W45 |  | 구현 |
| REQ:CHAT-20260831-W03 | div 선택 시 Biz.Type/Plant Site cascade 누락 |  |  | 미구현 |
| REQ:CHAT-20260831-W04 | 82 선택 시 Plant Site 활성화 |  |  | 미구현 |
| REQ:CHAT-20260831-W05 | 81 일때만 Sender Code 활성 (JV 비활성) |  |  | 미구현 |
| REQ:CHAT-20260831-W06 | 선택 div 기준 version = Current default | FE:E20260831-VERCUR |  | 구현 |
| REQ:CHAT-20260831-W07 | waterfall type 변경 시 전체 초기화 (+Layout 빈값 세부) |  |  | 미구현 |
| REQ:CHAT-20260831-W08 | 초기화 시 종료일자 잘못됨 (6개월) |  |  | 미구현 |
| REQ:CHAT-20260831-W09 | sort/filter 적용 가능 확인 후 적용 |  |  | 미구현 |
| REQ:CHAT-20260831-W10 | Menu context 적용 여부 확인 후 적용 |  |  | 미구현 |
| REQ:CHAT-20260831-W11 | waterfall type·div 별 column/pivot layout 에 UI Category 전량 적용 (우측 layout 건수 ≠ category 건수) + 개인화 팝업 연동 | FE:E20260831-METASHEET |  | 구현 |
| REQ:CHAT-20260831-W12 | Measure 항목 안 보임 (VISIBLE/DEFAULT Y 시 보임·Layout 에서 Measure 제외) + sales plan SQL 오류 |  |  | 미구현 |
| REQ:CHAT-20260831-W13 | 컬럼 영역 클릭 안 됨 |  |  | 미구현 |
| REQ:CHAT-20260831-W14 | 컬럼을 filter 영역으로 이동 시 동작 확인 (현재 안 보임) |  |  | 미구현 |
| REQ:CHAT-20260831-W15 | 엑셀 다운로드 Column 영역 포함(보이는 대로) + 파일명에 waterfall type |  |  | 미구현 |
| REQ:CHAT-20260831-W16 | DATA 영역 SORT 기능 삭제 |  |  | 미구현 |
| REQ:CHAT-20260831-W17 | DATA 영역 소수점 삭제 |  |  | 미구현 |
| REQ:CHAT-20260831-W18 | DATA 클릭 시 마지막 컬럼 TEXT BOLD 삭제 |  |  | 미구현 |
| REQ:CHAT-20260831-W19 | GRID 표준 CSS 공통 적용 (영역 색 구분 제거·폰트) |  |  | 미구현 |
| REQ:CHAT-20260831-W20 | waterfall type 별 UI CATEGORY FIX/WIDTH 적용 (가능여부 판단) |  |  | 미구현 |
| REQ:CHAT-20260831-W21 | Waterfall type 별 AS-IS 건수·합계 차이 |  |  | 미구현 |
| REQ:CHAT-20260831-W22 | DIV 82/Sales plan(Biz plan 동일) Plant Site 비활성 — AS-IS 활성 |  |  | 미구현 |
| REQ:CHAT-20260831-W23 | KRW/USD/LOC 표시값 AS-IS 통일 (KRW/1, KRW/1,000 …) |  |  | 미구현 |
| REQ:CHAT-20260831-W24 | Cell QTY 조회조건 — 40만 활성, 나머지 비활성 |  |  | 미구현 |
| REQ:CHAT-20260831-W25 | MKT FCST TYPE 조회조건 LAYOUT 을 Sales plan/Biz 와 통일 (Project/Plant Site 접힘 영역 배치) |  |  | 미구현 |
| REQ:CHAT-20260831-W26 | DMF0035 동적(기간) 컬럼에만 필터 아이콘 보임 — 아이콘 숨김 | FE:E20260831-NOFILTERICON |  | 구현 |
| REQ:CHAT-20260831-W27 | waterfall type 변경 시 Version 초기값 = CURRENT (전 타입) | FE:E20260831-VERCUR |  | 구현 |
| REQ:CHAT-20260831-W28 | Grid Layout 3섹션(Subtotal/Fields/Zones) 사이 스플릿바로 사이즈 조절 | FE:E20260831-RAILSPLIT |  | 구현 |
| REQ:CHAT-20260831-W29 | DMF0035 공통 FILTER/SORT 기능 제외 — 공통버튼 숨김 | FE:E20260831-NOCOMMONFS |  | 구현 |
| REQ:CHAT-20260831-W30 | AS-IS Waterfall 공통 메저 선택 — DMF0035 에 Measure 아이콘 버튼+기능 추가 + OLAP GRID 에 MEASURE 필수 유지 | FE:E20260831-MEASURE |  | 구현 |
| REQ:CHAT-20260831-W31 | DMF0035 전 waterfall type 에 Version 필수 조회조건 | FE:E20260831-VERREQ |  | 구현 |
| REQ:CHAT-20260831-W32 | DMF0035 Chart 버튼 삭제 | FE:E20260831-NOCHARTBTN |  | 구현 |
| REQ:CHAT-20260831-W33 | DMF0035 MKT FCST 에서 OLAP GRID 에 MEASURE 미표시 — 메저를 동적 컬럼 앞(Rows 최하단)에 항상 고정 | FE:E20260831-MEASROW |  | 구현 |

## UI 필수 12행동(UM) 축 (2026-08-28 — hook #149, 착수 화면부터)

> 원천: 사용자 지정 12항목(2026-08-28) — hook #149 `ui-mandatory-12-behaviors`. 12행 전부 판정(구현+위치 / 해당없음+사유). 빈 행 = FAIL.
> 코드 증거(판정신호)는 원장 `REQ:CHAT-20260828-UM{nn}-<MENU>` 행이 담당 — 산문 '정합' 만으로 구현을 쓰지 말 것.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| UM-01 | Div Default 선택(세션 division 우선·없으면 첫 행) + Division 변경 시 Grid 초기화·CRUD reset (hook #149 / #59 §1.4) | DemandPlanWaterfall.tsx (MyDivision effect · handleDivisionChange→clearData) / useDemandPlanWaterfallStore.ts clearData | 런타임 probe PASS (um12_browser_probe 2026-08-28) | 구현 |
| UM-02 | Team 선택 시 End Customer cascade (EndCustomerField cascade DEPT_ID strict — AS-IS EndCustomerByDivision(division, team)) | components/DemandPlanWaterfallForm.tsx EndCustomerField cascade={{ DEPT_ID: { values, strict: true } }} |  | 구현 |
| UM-03 | Division 선택 시 Biz.Type / Plant Site cascade + 81*/82 활성 분기 (AS-IS cboDivision_SelectedIndexChanged) | components/DemandPlanWaterfallForm.tsx BizTypeField division= / PlantSiteField division= endCustomer= disabled 분기 |  | 구현 |
| UM-04 | 숫자 자릿수 = AS-IS (타이틀 SP DATA_SCALE_NUMBER 소비 — SpreadInfo.cs L1433~1440 decimalPlaces) | components/DemandPlanWaterfallGrid.tsx DynColMeta scale (scaleOf DATA_SCALE_NUMBER) / demand-plan-waterfall.constants.ts scaleOf·DEFAULT_DYN_SCALE |  | 구현 |
| UM-05 | 초기 일자 = AS-IS (PR_GET_DAY_RANGE p_month — 당월 1일~+p_month 개월 말일) | useDemandPlanWaterfallStore.ts defaultPeriod (PR_GET_DAY_RANGE 등가) |  | 구현 |
| UM-06 | 헤더 높이 = 1단 크기(48px) 안에 최대 3줄 (#93 — DataGrid row 단위 강제) | components/DemandPlanWaterfallGrid.tsx HEADER_TOTAL_PX / applyHeaderHeight (columnHeaders.rows[i].height=48/단수) | probe 총 48 | 구현 |
| UM-07 | 필터 버튼(F4) 실동작 — gridFilterRef 페이지→Grid→DataGrid 관통 (OLAP = Grid Layout 레일 Filters) | DemandPlanWaterfall.tsx hotkeyConfig.filter → setShowLayout(true) / components/olap-field-rail/OlapFieldRail.tsx FilterEditorPopover (PivotFilterEditor) | OLAP 은 컬럼필터 대신 Grid Layout 레일 Filters 편집기 | 구현 |
| UM-08 | (BUCKET) 선택 즉시 컬럼 가시성 반응 + ONLY_WEEKLY 경계 전환 시 grid 초기화·헤더 재생성 (AS-IS InitSpread) | components/DemandPlanWaterfallGrid.tsx extraFields(bucket 3종 PERIOD 바인딩)·handleLayoutChange→onBucketChange / demand-plan-waterfall.constants.ts isBucketResetBoundary(gubun) / useDemandPlanWaterfallStore.ts resetForBucket |  | 구현 |
| UM-09 | (BUCKET) ONLY_WEEKLY 헤더 = AS-IS 3행(월/주차/SUM) 병합 없음, 주차:날짜 1:1 (사용자 결정 2026-08-28) | components/DemandPlanWaterfallGrid.tsx columnFields ONLY_WEEKLY = [PERIOD_LARGE 'Period', PERIOD_SMALL] + 값 헤더 'SUM' | probe rows [16,16,16]=48 | 구현 |
| UM-10 | (BUCKET) 월/주차 헤더 더블클릭 접힘·펼침 — 머지 원점(getMergedRange) 복원 (#103) | (OLAP) 단일 PERIOD 축 — 월/주차 계층 접힘은 피벗 축 재설계 필요 | 사용자 결정 대기 — 원장 REQ:CHAT-20260828-UM10-DMF0035 USER-DECISION | 해당없음 |
| UM-11 | (BUCKET) ONLY_WEEKLY 에도 최하단 sum (footer 는 bucket 무관 항상 — AS-IS InitSpreadFooterSum) | components/DemandPlanWaterfallGrid.tsx showRowTotals='GrandTotals' |  | 구현 |
| UM-12 | 합계 값 기준 = AS-IS (SumIgnoreHidden = 표시 행·컬럼 클라이언트 합, SP 합계행 없음) | components/DemandPlanWaterfallGrid.tsx valueFields aggregate:'Sum' | ⚠ AS-IS 가격 메저(KRW/USD/LOC) AVG 미적용 — 잔여 | 구현 |

## UI 필수 12행동(UM) 축 (2026-08-28 — hook #149, 착수 화면부터)

> 원천: 사용자 지정 12항목(2026-08-28) — hook #149 `ui-mandatory-12-behaviors`. 12행 전부 판정(구현+위치 / 해당없음+사유). 빈 행 = FAIL.
> 코드 증거(판정신호)는 원장 `REQ:CHAT-20260828-UM{nn}-<MENU>` 행이 담당 — 산문 '정합' 만으로 구현을 쓰지 말 것.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| UM-01 | Div Default 선택(세션 division 우선·없으면 첫 행) + Division 변경 시 Grid 초기화·CRUD reset (hook #149 / #59 §1.4) | DemandPlanWaterfall.tsx (MyDivision effect · handleDivisionChange→clearData) / useDemandPlanWaterfallStore.ts clearData | 런타임 probe PASS (um12_browser_probe 2026-08-28) | 구현 |
| UM-02 | Team 선택 시 End Customer cascade (EndCustomerField cascade DEPT_ID strict — AS-IS EndCustomerByDivision(division, team)) | components/DemandPlanWaterfallForm.tsx EndCustomerField cascade={{ DEPT_ID: { values, strict: true } }} |  | 구현 |
| UM-03 | Division 선택 시 Biz.Type / Plant Site cascade + 81*/82 활성 분기 (AS-IS cboDivision_SelectedIndexChanged) | components/DemandPlanWaterfallForm.tsx BizTypeField division= / PlantSiteField division= endCustomer= disabled 분기 |  | 구현 |
| UM-04 | 숫자 자릿수 = AS-IS (타이틀 SP DATA_SCALE_NUMBER 소비 — SpreadInfo.cs L1433~1440 decimalPlaces) | components/DemandPlanWaterfallGrid.tsx DynColMeta scale (scaleOf DATA_SCALE_NUMBER) / demand-plan-waterfall.constants.ts scaleOf·DEFAULT_DYN_SCALE |  | 구현 |
| UM-05 | 초기 일자 = AS-IS (PR_GET_DAY_RANGE p_month — 당월 1일~+p_month 개월 말일) | useDemandPlanWaterfallStore.ts defaultPeriod (PR_GET_DAY_RANGE 등가) |  | 구현 |
| UM-06 | 헤더 높이 = 1단 크기(48px) 안에 최대 3줄 (#93 — DataGrid row 단위 강제) | components/DemandPlanWaterfallGrid.tsx HEADER_TOTAL_PX / applyHeaderHeight (columnHeaders.rows[i].height=48/단수) | probe 총 48 | 구현 |
| UM-07 | 필터 버튼(F4) 실동작 — gridFilterRef 페이지→Grid→DataGrid 관통 (OLAP = Grid Layout 레일 Filters) | DemandPlanWaterfall.tsx hotkeyConfig.filter → setShowLayout(true) / components/olap-field-rail/OlapFieldRail.tsx FilterEditorPopover (PivotFilterEditor) | OLAP 은 컬럼필터 대신 Grid Layout 레일 Filters 편집기 | 구현 |
| UM-08 | (BUCKET) 선택 즉시 컬럼 가시성 반응 + ONLY_WEEKLY 경계 전환 시 grid 초기화·헤더 재생성 (AS-IS InitSpread) | components/DemandPlanWaterfallGrid.tsx extraFields(bucket 3종 PERIOD 바인딩)·handleLayoutChange→onBucketChange / demand-plan-waterfall.constants.ts isBucketResetBoundary(gubun) / useDemandPlanWaterfallStore.ts resetForBucket |  | 구현 |
| UM-09 | (BUCKET) ONLY_WEEKLY 헤더 = AS-IS 3행(월/주차/SUM) 병합 없음, 주차:날짜 1:1 (사용자 결정 2026-08-28) | components/DemandPlanWaterfallGrid.tsx columnFields ONLY_WEEKLY = [PERIOD_LARGE 'Period', PERIOD_SMALL] + 값 헤더 'SUM' | probe rows [16,16,16]=48 | 구현 |
| UM-10 | (BUCKET) 월/주차 헤더 더블클릭 접힘·펼침 — 머지 원점(getMergedRange) 복원 (#103) | (OLAP) 단일 PERIOD 축 — 월/주차 계층 접힘은 피벗 축 재설계 필요 | 사용자 결정 대기 — 원장 REQ:CHAT-20260828-UM10-DMF0035 USER-DECISION | 해당없음 |
| UM-11 | (BUCKET) ONLY_WEEKLY 에도 최하단 sum (footer 는 bucket 무관 항상 — AS-IS InitSpreadFooterSum) | components/DemandPlanWaterfallGrid.tsx showRowTotals='GrandTotals' |  | 구현 |
| UM-12 | 합계 값 기준 = AS-IS (SumIgnoreHidden = 표시 행·컬럼 클라이언트 합, SP 합계행 없음) | components/DemandPlanWaterfallGrid.tsx valueFields aggregate:'Sum' | ⚠ AS-IS 가격 메저(KRW/USD/LOC) AVG 미적용 — 잔여 | 구현 |

## UI 필수 12행동(UM) 축 (2026-08-28 — hook #149, 착수 화면부터)

> 원천: 사용자 지정 12항목(2026-08-28) — hook #149 `ui-mandatory-12-behaviors`. 12행 전부 판정(구현+위치 / 해당없음+사유). 빈 행 = FAIL.
> 코드 증거(판정신호)는 원장 `REQ:CHAT-20260828-UM{nn}-<MENU>` 행이 담당 — 산문 '정합' 만으로 구현을 쓰지 말 것.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| UM-01 | Div Default 선택(세션 division 우선·없으면 첫 행) + Division 변경 시 Grid 초기화·CRUD reset (hook #149 / #59 §1.4) | DemandPlanWaterfall.tsx (MyDivision effect · handleDivisionChange→clearData) / useDemandPlanWaterfallStore.ts clearData | 런타임 probe PASS (um12_browser_probe 2026-08-28) | 구현 |
| UM-02 | Team 선택 시 End Customer cascade (EndCustomerField cascade DEPT_ID strict — AS-IS EndCustomerByDivision(division, team)) | components/DemandPlanWaterfallForm.tsx EndCustomerField cascade={{ DEPT_ID: { values, strict: true } }} |  | 구현 |
| UM-03 | Division 선택 시 Biz.Type / Plant Site cascade + 81*/82 활성 분기 (AS-IS cboDivision_SelectedIndexChanged) | components/DemandPlanWaterfallForm.tsx BizTypeField division= / PlantSiteField division= endCustomer= disabled 분기 |  | 구현 |
| UM-04 | 숫자 자릿수 = AS-IS (타이틀 SP DATA_SCALE_NUMBER 소비 — SpreadInfo.cs L1433~1440 decimalPlaces) | components/DemandPlanWaterfallGrid.tsx DynColMeta scale (scaleOf DATA_SCALE_NUMBER) / demand-plan-waterfall.constants.ts scaleOf·DEFAULT_DYN_SCALE |  | 구현 |
| UM-05 | 초기 일자 = AS-IS (PR_GET_DAY_RANGE p_month — 당월 1일~+p_month 개월 말일) | useDemandPlanWaterfallStore.ts defaultPeriod (PR_GET_DAY_RANGE 등가) |  | 구현 |
| UM-06 | 헤더 높이 = 1단 크기(48px) 안에 최대 3줄 (#93 — DataGrid row 단위 강제) | components/DemandPlanWaterfallGrid.tsx HEADER_TOTAL_PX / applyHeaderHeight (columnHeaders.rows[i].height=48/단수) | probe 총 48 | 구현 |
| UM-07 | 필터 버튼(F4) 실동작 — gridFilterRef 페이지→Grid→DataGrid 관통 (OLAP = Grid Layout 레일 Filters) | DemandPlanWaterfall.tsx hotkeyConfig.filter → setShowLayout(true) / components/olap-field-rail/OlapFieldRail.tsx FilterEditorPopover (PivotFilterEditor) | OLAP 은 컬럼필터 대신 Grid Layout 레일 Filters 편집기 | 구현 |
| UM-08 | (BUCKET) 선택 즉시 컬럼 가시성 반응 + ONLY_WEEKLY 경계 전환 시 grid 초기화·헤더 재생성 (AS-IS InitSpread) | components/DemandPlanWaterfallGrid.tsx extraFields(bucket 3종 PERIOD 바인딩)·handleLayoutChange→onBucketChange / demand-plan-waterfall.constants.ts isBucketResetBoundary(gubun) / useDemandPlanWaterfallStore.ts resetForBucket |  | 구현 |
| UM-09 | (BUCKET) ONLY_WEEKLY 헤더 = AS-IS 3행(월/주차/SUM) 병합 없음, 주차:날짜 1:1 (사용자 결정 2026-08-28) | components/DemandPlanWaterfallGrid.tsx columnFields ONLY_WEEKLY = [PERIOD_LARGE 'Period', PERIOD_SMALL] + 값 헤더 'SUM' | probe rows [16,16,16]=48 | 구현 |
| UM-10 | (BUCKET) 월/주차 헤더 더블클릭 접힘·펼침 — 머지 원점(getMergedRange) 복원 (#103) | (OLAP) 단일 PERIOD 축 — 월/주차 계층 접힘은 피벗 축 재설계 필요 | 사용자 결정 대기 — 원장 REQ:CHAT-20260828-UM10-DMF0035 USER-DECISION | 해당없음 |
| UM-11 | (BUCKET) ONLY_WEEKLY 에도 최하단 sum (footer 는 bucket 무관 항상 — AS-IS InitSpreadFooterSum) | components/DemandPlanWaterfallGrid.tsx showRowTotals='GrandTotals' |  | 구현 |
| UM-12 | 합계 값 기준 = AS-IS (SumIgnoreHidden = 표시 행·컬럼 클라이언트 합, SP 합계행 없음) | components/DemandPlanWaterfallGrid.tsx valueFields aggregate:'Sum' | ⚠ AS-IS 가격 메저(KRW/USD/LOC) AVG 미적용 — 잔여 | 구현 |

## UI 필수 12행동(UM) 축 (2026-08-28 — hook #149, 착수 화면부터)

> 원천: 사용자 지정 12항목(2026-08-28) — hook #149 `ui-mandatory-12-behaviors`. 12행 전부 판정(구현+위치 / 해당없음+사유). 빈 행 = FAIL.
> 코드 증거(판정신호)는 원장 `REQ:CHAT-20260828-UM{nn}-<MENU>` 행이 담당 — 산문 '정합' 만으로 구현을 쓰지 말 것.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| UM-01 | Div Default 선택(세션 division 우선·없으면 첫 행) + Division 변경 시 Grid 초기화·CRUD reset (hook #149 / #59 §1.4) | DemandPlanWaterfall.tsx (MyDivision effect · handleDivisionChange→clearData) / useDemandPlanWaterfallStore.ts clearData | 런타임 probe PASS (um12_browser_probe 2026-08-28) | 구현 |
| UM-02 | Team 선택 시 End Customer cascade (EndCustomerField cascade DEPT_ID strict — AS-IS EndCustomerByDivision(division, team)) | components/DemandPlanWaterfallForm.tsx EndCustomerField cascade={{ DEPT_ID: { values, strict: true } }} |  | 구현 |
| UM-03 | Division 선택 시 Biz.Type / Plant Site cascade + 81*/82 활성 분기 (AS-IS cboDivision_SelectedIndexChanged) | components/DemandPlanWaterfallForm.tsx BizTypeField division= / PlantSiteField division= endCustomer= disabled 분기 |  | 구현 |
| UM-04 | 숫자 자릿수 = AS-IS (타이틀 SP DATA_SCALE_NUMBER 소비 — SpreadInfo.cs L1433~1440 decimalPlaces) | components/DemandPlanWaterfallGrid.tsx DynColMeta scale (scaleOf DATA_SCALE_NUMBER) / demand-plan-waterfall.constants.ts scaleOf·DEFAULT_DYN_SCALE |  | 구현 |
| UM-05 | 초기 일자 = AS-IS (PR_GET_DAY_RANGE p_month — 당월 1일~+p_month 개월 말일) | useDemandPlanWaterfallStore.ts defaultPeriod (PR_GET_DAY_RANGE 등가) |  | 구현 |
| UM-06 | 헤더 높이 = 1단 크기(48px) 안에 최대 3줄 (#93 — DataGrid row 단위 강제) | components/DemandPlanWaterfallGrid.tsx HEADER_TOTAL_PX / applyHeaderHeight (columnHeaders.rows[i].height=48/단수) | probe 총 48 | 구현 |
| UM-07 | 필터 버튼(F4) 실동작 — gridFilterRef 페이지→Grid→DataGrid 관통 (OLAP = Grid Layout 레일 Filters) | DemandPlanWaterfall.tsx hotkeyConfig.filter → setShowLayout(true) / components/olap-field-rail/OlapFieldRail.tsx FilterEditorPopover (PivotFilterEditor) | OLAP 은 컬럼필터 대신 Grid Layout 레일 Filters 편집기 | 구현 |
| UM-08 | (BUCKET) 선택 즉시 컬럼 가시성 반응 + ONLY_WEEKLY 경계 전환 시 grid 초기화·헤더 재생성 (AS-IS InitSpread) | components/DemandPlanWaterfallGrid.tsx extraFields(bucket 3종 PERIOD 바인딩)·handleLayoutChange→onBucketChange / demand-plan-waterfall.constants.ts isBucketResetBoundary(gubun) / useDemandPlanWaterfallStore.ts resetForBucket |  | 구현 |
| UM-09 | (BUCKET) ONLY_WEEKLY 헤더 = AS-IS 3행(월/주차/SUM) 병합 없음, 주차:날짜 1:1 (사용자 결정 2026-08-28) | components/DemandPlanWaterfallGrid.tsx columnFields ONLY_WEEKLY = [PERIOD_LARGE 'Period', PERIOD_SMALL] + 값 헤더 'SUM' | probe rows [16,16,16]=48 | 구현 |
| UM-10 | (BUCKET) 월/주차 헤더 더블클릭 접힘·펼침 — 머지 원점(getMergedRange) 복원 (#103) | (OLAP) 단일 PERIOD 축 — 월/주차 계층 접힘은 피벗 축 재설계 필요 | 사용자 결정 대기 — 원장 REQ:CHAT-20260828-UM10-DMF0035 USER-DECISION | 해당없음 |
| UM-11 | (BUCKET) ONLY_WEEKLY 에도 최하단 sum (footer 는 bucket 무관 항상 — AS-IS InitSpreadFooterSum) | components/DemandPlanWaterfallGrid.tsx showRowTotals='GrandTotals' |  | 구현 |
| UM-12 | 합계 값 기준 = AS-IS (SumIgnoreHidden = 표시 행·컬럼 클라이언트 합, SP 합계행 없음) | components/DemandPlanWaterfallGrid.tsx valueFields aggregate:'Sum' | ⚠ AS-IS 가격 메저(KRW/USD/LOC) AVG 미적용 — 잔여 | 구현 |

## 1. 조회조건 (통합분석 §4.3 설계표 1:1)

| AS-IS | TO-BE | 구현 |
|---|---|---|
| (신규) GUBUN | `GUBUN_OPTIONS` 콤보, 초기 MKT_FCST | Form Row A. 전환=`gubunResetParams`(버킷 스왑+버전 클리어) |
| cboDivision(필수) | Div. 콤보(MyDivision) | cascade+텍스트 4종 클리어(AS-IS .cs:1609-1612 — 0022 TO-BE 누락분 보완) |
| clbTeam/Customer/SalesSite/PlantSite/BizType/ItemType | 멀티 콤보 6종 | Team→Customer→SalesSite 연쇄. div40: Project·PlantSite disable(+BIZ 는 BizType), CellQty enable |
| clbEDISender (0035, div81만) | Sender Code 콤보 | `isMkt && isDivision81` 활성 |
| txtProject/ItemId/Owner + 팝업 | 공용 모달 3종 | Project/Item/OwnerByDivisionModal |
| txtVersion + 팝업 3종 | `WaterfallVersionModal`(신설) | DMF0073 9-arg 공유 계약 + GUBUN 접두 확장(MF·SF+ME_S / SP / BP). MKT 비필수(''=CURRENT) |
| drpPeriod | DatePickerCalendar | 상한 MKT/SALES 3년·BIZ 10년(MSG00164, To 보정) |
| cboBucketType | Bucket 콤보 | MKT/SALES=CMBO 'BucketType' / BIZ=BUCKET2 상수(AS-IS LOOKUP 실측 3계층 — CMBO 'BucketType2' 등록 시 교체) |
| chkSum/chkColor(chkMem) | 체크박스 | ONLY_WEEKLY 시 Sum 강제 해제 |
| cboCellQty | Cell Qty | MKT·BIZ 만 표시(SALES 는 AS-IS Visible=false → 미표시·'N' 고정), div40 만 활성, 이탈 시 해제 |
| InternalYN (0022) | 미표시 | AS-IS Visible=false → `internalYn:'N'` 고정 |
| cbxQty "Qty≠0" (0051) | 체크박스 | BIZ 만 표시 → `qtyYn` |
| cboKRW/USD/LOC/QTY | 환산 콤보 | SALES/BIZ=4종, MKT=QTY만. CODE=배수('1'~'100000000') |

## 2. SP 계약 (procedures.d.ts DMF0035 블록)

| 시트 | canonical PROC | IN |
|---|---|---|
| mktFcstWaterfall | PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL | AS-IS 19 + USER/MENU = 21 |
| salesPlanWaterfall | PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL | 20+2 = 22 (기존 재사용) |
| bizPlanWaterfall | PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL | AS-IS 17+2 = 19 (재변환 — Phase B) |
| *SpreadTitle ×3 | 각 PKG GET_SPREAD_TITLE | 5 |
| version | DMF0073_GET_VERSION_SALESPRICE | 9-arg 공유(DMF0082 선례) |

- `p_now`(SALES/BIZ): **이번주 월요일 + from/to 경계 보정**(AS-IS .cs:1077-1081 1:1 — `calcNowYyyymmdd`). dayjs() 단순 대입(구 오구현) 승계 금지.
- dead 쌍 `p_user_dept_id/p_group_id`: SP 본문 미사용 실측 — 시그니처 유지용 빈값(주석 명기).

## 3. Validation·MSG (실문구 대사 #114 — 통합분석 §2.F 실측)

| MSG | 조건 | 위치 |
|---|---|---|
| MSG00137 | 조회 중 재조회 | handleSubmit |
| MSG00097 | Division 미선택 | handleSubmit |
| MSG00013 | Period 미입력 / Version 미입력(SALES·BIZ) | handleSubmit |
| MSG00108 | From > To | handleSubmit |
| MSG00164 | 기간 상한 초과(3y/10y) — To 보정 후 중단 | handleSubmit |
| (MSG00109) | 조회 전용 — hotkeyConfig 로 CUD 자체 숨김이라 미발화 | hotkeyConfig |

## 4. Grid (OLAP 대체 매핑)

| AS-IS | TO-BE OLAP | 상태 |
|---|---|---|
| 동적 PIVOT + titleset 'C' 고정컬럼 | TITLE SP → rowFields(SORT_ORDER_NO 순, B_/VISIBLE 'N' 제외) | ✅ |
| 기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(0051) | wide→long `unpivotWideRows` + PERIOD 열 축 | ✅ |
| 버킷·Sum 토글(SetSpreadColumn) | `visiblePrefixes` 접두 필터 | ✅ (실측 규칙 1:1) |
| footer SUM(SumIgnoreHidden) | showRowTotals='GrandTotals' | ✅ (총계 행) |
| 환산 콤보(SetAmountCalculating) | `divisorFor` — 금액 6·수량 8(+BIZ Business_Plan)·MKT 전행, Round 2 | ✅ (실측 measure 목록) |
| 전 컬럼 읽기전용 | PivotGrid 기본 read-only | ✅ |
| Excel(F12) | OlapPivotGridRef.exportExcel + SubTitle grid 연동 | ✅ |
| 3단 헤더 병합(LARGE/SMALL 라벨) | OLAP 열 계층 미적용 — PERIOD 원시 키(M_202608) 헤더 | ⚠ 부분(하기 잔여) |
| chkColor 회색 실적구간 / NOTATION 행 포맷 / 당기 Green·주말색 / 헤더 더블클릭 드릴 | 미구현 | ⚠ 잔여(하기) |

### 잔여(2차 또는 폴리시 확정 필요 — 침묵 금지 전수 기록)
1. **PERIOD 헤더 라벨**: TITLE SP 의 lCls/sCls 3단 라벨 → OLAP 열 계층(연>월>주) 매핑 — 2차.
2. **chkColor(Gainsboro 실적구간)**: OLAP formatItem 커스터마이징 — 2차. 기준일 GUBUN별(주/전월) 상이 — 통합분석 §4.2.
3. **NOTATION 행 포맷 / 당기 강조 / 주말색**: formatItem — 2차.
4. **헤더 드릴(M_→W_→D_ / M_↔Q_)**: OLAP 계층 접기로 대체 검토 — 2차.
5. **Version 팝업 sPeriod(조회기간 덮어쓰기)**: 공유 계약(DMF0073)에 버전 기준일 컬럼 부재 — 계약 결손. Phase B 에서 SP OUT 확장 또는 버전명 파싱 정책 확정 후 반영.
6. CMBO 신설 대기: 'BucketType2'(BIZ M/Q/Y), 'QtyType'(환산 배수 — 현재 상수 옵션) — Phase B 메타 세트.

## UI 필수 12행동(UM) 축 (2026-08-28 — hook #149, 착수 화면부터)

> 원천: 사용자 지정 12항목(2026-08-28) — hook #149 `ui-mandatory-12-behaviors`. 12행 전부 판정(구현+위치 / 해당없음+사유). 빈 행 = FAIL.
> 코드 증거(판정신호)는 원장 `REQ:CHAT-20260828-UM{nn}-DMF0035` 행이 담당 — 산문 '정합' 만으로 구현을 쓰지 말 것. 런타임 실측 = `_artifacts/_diagnostics/um12_browser_probe.py DMF0035` (2026-08-28 PASS).

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| UM-01 | Div Default 선택(세션 division 우선·없으면 첫 행) + Division 변경 시 Grid 초기화·CRUD reset (hook #149 / #59 §1.4) | DemandPlanWaterfall.tsx (MyDivision effect · handleDivisionChange→clearData) / useDemandPlanWaterfallStore.ts clearData | 런타임 probe PASS (um12_browser_probe 2026-08-28) | 구현 |
| UM-02 | Team 선택 시 End Customer cascade (EndCustomerField cascade DEPT_ID strict — AS-IS EndCustomerByDivision(division, team)) | components/DemandPlanWaterfallForm.tsx EndCustomerField cascade={{ DEPT_ID: { values, strict: true } }} |  | 구현 |
| UM-03 | Division 선택 시 Biz.Type / Plant Site cascade + 81*/82 활성 분기 (AS-IS cboDivision_SelectedIndexChanged) | components/DemandPlanWaterfallForm.tsx BizTypeField division= / PlantSiteField division= endCustomer= disabled 분기 |  | 구현 |
| UM-04 | 숫자 자릿수 = AS-IS (타이틀 SP DATA_SCALE_NUMBER 소비 — SpreadInfo.cs L1433~1440 decimalPlaces) | components/DemandPlanWaterfallGrid.tsx DynColMeta scale (scaleOf DATA_SCALE_NUMBER) / demand-plan-waterfall.constants.ts scaleOf·DEFAULT_DYN_SCALE |  | 구현 |
| UM-05 | 초기 일자 = AS-IS (PR_GET_DAY_RANGE p_month — 당월 1일~+p_month 개월 말일) | useDemandPlanWaterfallStore.ts defaultPeriod (PR_GET_DAY_RANGE 등가) |  | 구현 |
| UM-06 | 헤더 높이 = 1단 크기(48px) 안에 최대 3줄 (#93 — DataGrid row 단위 강제) | components/DemandPlanWaterfallGrid.tsx HEADER_TOTAL_PX / applyHeaderHeight (columnHeaders.rows[i].height=48/단수) | probe 총 48 | 구현 |
| UM-07 | 필터 버튼(F4) 실동작 — gridFilterRef 페이지→Grid→DataGrid 관통 (OLAP = Grid Layout 레일 Filters) | DemandPlanWaterfall.tsx hotkeyConfig.filter → setShowLayout(true) / components/olap-field-rail/OlapFieldRail.tsx FilterEditorPopover (PivotFilterEditor) | OLAP 은 컬럼필터 대신 Grid Layout 레일 Filters 편집기 | 구현 |
| UM-08 | (BUCKET) 선택 즉시 컬럼 가시성 반응 + ONLY_WEEKLY 경계 전환 시 grid 초기화·헤더 재생성 (AS-IS InitSpread) | components/DemandPlanWaterfallGrid.tsx extraFields(bucket 3종 PERIOD 바인딩)·handleLayoutChange→onBucketChange / demand-plan-waterfall.constants.ts isBucketResetBoundary(gubun) / useDemandPlanWaterfallStore.ts resetForBucket |  | 구현 |
| UM-09 | (BUCKET) ONLY_WEEKLY 헤더 = AS-IS 3행(월/주차/SUM) 병합 없음, 주차:날짜 1:1 (사용자 결정 2026-08-28) | components/DemandPlanWaterfallGrid.tsx columnFields ONLY_WEEKLY = [PERIOD_LARGE 'Period', PERIOD_SMALL] + 값 헤더 'SUM' | probe rows [16,16,16]=48 | 구현 |
| UM-10 | (BUCKET) 월/주차 헤더 더블클릭 접힘·펼침 — 머지 원점(getMergedRange) 복원 (#103) | (OLAP) 단일 PERIOD 축 — 월/주차 계층 접힘은 피벗 축 재설계 필요 | 사용자 결정 대기 — 원장 REQ:CHAT-20260828-UM10-DMF0035 USER-DECISION | 해당없음 |
| UM-11 | (BUCKET) ONLY_WEEKLY 에도 최하단 sum (footer 는 bucket 무관 항상 — AS-IS InitSpreadFooterSum) | components/DemandPlanWaterfallGrid.tsx showRowTotals='GrandTotals' |  | 구현 |
| UM-12 | 합계 값 기준 = AS-IS (SumIgnoreHidden = 표시 행·컬럼 클라이언트 합, SP 합계행 없음) | components/DemandPlanWaterfallGrid.tsx valueFields aggregate:'Sum' | ⚠ AS-IS 가격 메저(KRW/USD/LOC) AVG 미적용 — 잔여 | 구현 |

## 5. 이관 제외 (AS-IS dead — Cascade 전수 md §4.9)
SetClbVersion(빈 함수)/spdMain_ComboSelChange(사문)/구 ExportExcel(주석 블록)/p_user_dept_id·p_group_id(본문 미사용)/MSG00003(dead)/그리드 셀 더블클릭 팝업 2종(read-only 도달 불가).

# Hook #149 — ui-mandatory-12-behaviors ⭐⭐⭐ (사용자 명시 2026-08-28)

> **트리거**: nscm-fe UI **신규 생성(T01)·보완(T01M) 전부** — 조회조건(Division/Team/End Customer/Biz.Type/Plant Site/기간/Bucket) ·
> 그리드(헤더·숫자 서식·필터·합계) 를 만들거나 고치는 모든 작업. 12항목 중 하나라도 "안 봤다" = 누락.
> **한 줄**: 아래 12행동(UM-01~12)은 **반드시 확인하고, 구현돼 있지 않으면 구현**한다. 룰이 있어도 게이트가 안 보면 빠진다 —
> 그래서 `asis_mapping_gate.py` 의 **UM 축**(착수 화면부터)과 `__asis-mapping__.md` 의 `UM:` 섹션이 판정한다.
> **연관**: #59(=RM §4 #5) cascade-combo-filter §1.4 · #26 messaging-api-and-search-fields-mandatory §3.1 · #65 ui-category-setup-column-meta ·
> #93 grid-multi-tier-header-height · #97 common-button-grid-routing · #103 pivot-header-drilldown · #117 search-condition-datasource-asis-parity ·
> #133 ui-common-testitem-mapping-axis · #139 request-ledger-and-subclause-mapping · #125 셀프 런타임 검증
> **계기**: 2026-08-27 신규 화면 DMF0040/DMF0053 에서 12항목 중 **NO 5 · partial 4** (사용자 발견). 누락 사유 3계보 = ①룰 부재(2·4·8·9·11·12)
> ②룰은 있으나 §3 체크리스트/게이트 밖(1·7·10) ③게이트가 산문 "정합" 을 코드 증거 없이 통과(2·7). 본 hook 이 ①을 신설하고 ②③을 게이트로 봉인.
> 카테고리 = `01_ui_design_layout`(주) · `04_search_condition_combo` · `03_grid_column_meta` · `11_asis_parity`.

---

## §0. 원칙

1. **12항목은 체크리스트이지 참고가 아니다.** 화면 착수 시 `__asis-mapping__.md` 에 `## UI 필수 12행동(UM) 축` 섹션을 만들고 12행 전부 판정(구현 / 해당없음+사유)한다. 빈 행 = FAIL.
2. **판정 근거 = 코드 증거(EV/FE 신호)** — "공용 필드가 담당" 같은 산문만으로 '구현' 을 쓰지 않는다 (DMF0053 `EndCustomerByDivision(Dept)` "정합" 허위 기재 사고).
3. **AS-IS 가 심판** — 각 항목의 정본은 AS-IS `.cs` 핸들러/프레임워크(`SpreadInfo.cs`)다. 사용자 결정이 AS-IS 와 다른 항목(UM-01 default·UM-09)은 본 hook 에 결정 원문을 남긴다.
4. **해당없음 규약** — Bucket 이 없는 화면은 UM-08~11 을 `해당없음(bucket 없음)` 으로 명시해야 통과. 조회 전용 화면의 "CRUD reset" 은 `해당없음(편집 축 없음)`.
5. **런타임 실측** — HTTP 러너(`ui_http_e2e.py`)는 UI 행동을 못 본다. `um12_browser_probe.py`(Playwright, 활성 뷰 스코프)로 UM-01/06/07/08/09/11 을 DOM 실측하고 결과를 대사표 근거에 남긴다.

## §1. 12행동 표 (판정 기준·정본·EV 신호)

| ID | 항목 | 판정 기준 (AS-IS 정본) | TO-BE 정본 | EV 신호(게이트) | 기존 hook |
|---|---|---|---|---|---|
| UM-01 | **Div Default 선택 + 변경 시 초기화** | ①기본값 = **세션 division 이 MyDivision 목록에 있으면 그것, 없으면 첫 행**(사용자 결정 2026-08-28 — AS-IS DMF0040 `cboDivision.SelectedIndex=1` 계보; 2026-08-23 "자동 보정 없음" 은 *사용자 선택 후 재보정 금지* 로 한정) ②변경 = `InitSpread()` = **Grid 비움 + CRUD pending reset** + 하위 조건 clear (#59 §1.4) | `mkt-fcst-comparison/MktFcstComparison.tsx` (`useTabComboQueries(['MyDivision'])` effect + `handleDivisionChange` → `clearData()`) · `sales-reports/SalesReports.tsx resetGrid` | `FE:handleDivisionChange;;FE:clearData` + `EV:<page>::UM-01 Division 기본 선택` | #59 §1.4 · #47 |
| UM-02 | **Team → End Customer cascade** | AS-IS `clbTeam_SelectedIndexChanged` → `EndCustomerByDivision(division, team)` 재적재 | `EndCustomerField cascade={{ DEPT_ID: { values: deptIds, strict: true } }}` (`SearchFields.tsx` runCascade — strict 필수: 콤보 DEPT_ID 공란 행 다수) · Sales Site 의 team 파라미터는 81*/82 = '' / 40 = team (.cs 분기) | `EV:<form>::cascade=\{\{ DEPT_ID` | #26 §3.1 |
| UM-03 | **Div → Biz.Type / Plant Site cascade** | Division 변경마다 `BizType(division)` · `UserPlantSiteByDivision`; Project/Plant Site Enable = 81*/82 만 | `BizTypeField division=` (글로벌 콤보 DIVISION_ID 클라 필터) · `PlantSiteField division= endCustomer= disabled={!isProjectPlantEnabled}` | `EV:<form>::PlantSiteField;;EV:<form>::BizTypeField` | #26 §3.1 (Plant Site) — ⚠ BizType 행 "no cascade" 는 오기 → 본 hook 이 정정 |
| UM-04 | **숫자 자릿수 = AS-IS** | 기간 컬럼 = 타이틀 SP `DATA_SCALE_NUMBER` → `SpreadInfo.cs L1433~1440 decimalPlaces`(NULL/''/0 = 0자리·구분자 없음) · 화면별 값이 다르다(DMF0040 ''=0 / DMF0053 3 / DMF0035 NULL+행별 NOTATION) | `scaleOf(r.DATA_SCALE_NUMBER)` → `format: n${scale}` + `COLUMN_WIDTH` 소비 · footer 는 `{0:#,##0.###}`=n3 · DMF0035 는 `formatByNotation`(INTEGER/POINT/POINT3) | `FE:scaleOf;;EV:<grid>::DATA_SCALE_NUMBER` | #65 (배관) — 동일성 의무는 본 hook |
| UM-05 | **초기 일자 = AS-IS** | `PR_GET_DAY_RANGE(p_month)` 당월 1일 ~ +p_month 개월 말일 (0040/0035 6 · 0053 Period 6/Create 1) | store `defaultPeriod()` dayjs 등가 | `FE:defaultPeriod` | #117 §1 |
| UM-06 | **헤더 높이 = 1단 크기(48) 안에 최대 3줄** | 총 48px 고정 (1단48/2단24/3단16) | `headerRowHeight={tierH}` + 정적 컬럼 `sCls/lCls=colLbl` 정규화 · **DataGrid 가 row 단위로 강제**(2026-08-28 정정: wijmo `_buildColumnGroups` 가 정의 height 로 row 에 명시 높이를 넣어 defaultSize 가 무시됨) · OLAP = `columnHeaders.rows[i].height = 48/단수` | `EV:<grid>::tierH` (OLAP `HEADER_TOTAL_PX`) | #93 |
| UM-07 | **필터 버튼 동작** | Search Aux 4대 자동 활성(#1 §0.2) — 눌렀을 때 실제로 컬럼 필터가 켜져야 함 | `gridFilterRef` 를 **페이지 → Grid → `<DataGrid gridFilterRef>`** 로 관통 (미전달 = SubTitle F4 가 조용한 no-op) · OLAP = `hotkeyConfig.filter` 가 Grid Layout 레일(Filters 영역 값 필터 편집기)을 연다 | `EV:<grid>::gridFilterRef=\{gridFilterRef\}` | #97 §2-3 · #144 |
| UM-08 | **(BUCKET) 즉각 반응 + ONLY_WEEKLY 전환 시 grid 초기화·헤더 재생성** | AS-IS `cboBucketType_SelectedIndexChanged`: 재조회 없음, `SetSpreadColumn()` 가시성 즉시 토글 · **경계**(ONLY_WEEKLY 진출입 — 0053/0035 는 W·M→DAILY 도) 에만 `InitSpread()` = 타이틀 재조회 + 시트 재생성(빈 그리드) | `isBucketResetBoundary(prev,next)` → `resetForBucket(next)`(메인 filter 제거 + 타이틀 filter bucket 교체) · 그 외 `bucketPrefix` 가시성 | `FE:isBucketResetBoundary;;FE:resetForBucket` | #103 §1-5 (드릴 리셋만) |
| UM-09 | **(BUCKET) ONLY_WEEKLY 헤더 주차:날짜 1:1** | AS-IS `SetSpreadHeader` **3행(월/주차/SUM) 병합 없음**, 컬럼마다 반복 — **사용자 결정 2026-08-28 = AS-IS 3행 그대로** | FlexGrid: ONLY_WEEKLY 분기 = 컬럼마다 독립 3단 그룹 + MergeManager 무병합 + tierH 16 · OLAP: 열 축 2단(LARGE 날짜구간 > SMALL 주차, LARGE 유일=1:1) + 값 헤더 'SUM'(`showValueFieldHeaders`) | `EV:<grid>::UM-09` | — (신설) |
| UM-10 | **(BUCKET) 월/주차 헤더 더블클릭 접힘·펼침** | `spdMain_CellDoubleClick`: M_ → 다음 M_ 전 W_ 토글 + 보이는 D_ 접기 / W_ → 다음 W_ 전 D_ 토글 | #103 + **머지 원점 복원** `g.getMergedRange(columnHeaders, row, col).leftCol` (hitTest 는 물리 컬럼) · OLAP 은 단일 PERIOD 축 — 계층 재설계 없이는 해당없음(USER-DECISION) | `EV:<grid>::getMergedRange` | #103 |
| UM-11 | **(BUCKET) ONLY_WEEKLY 최하단 sum** | `InitSpreadFooterSum()` 이 `InitSpread()` 말미에 **무조건** — bucket 무관 항상 · `ColumnFooter` LightGray · `{0:#,##0.###}` | `columnFooters` GroupRow + `Aggregate.Sum` + formatItem(ColumnFooter: n3·LightGray) · OLAP = `showRowTotals='GrandTotals'` | `EV:<grid>::columnFooters` (OLAP `showRowTotals`) | #10 (`useAggregationRow` prop) |
| UM-12 | **합계 기준 = AS-IS** | `AggregationType.SumIgnoreHidden` = 보이는 행·컬럼의 클라이언트 합 (SP 합계행 없음) · DMF0035 가격 메저(KRW/USD/LOC) 는 AVG | `Aggregate.Sum` over 표시 사본(QTY 스케일 적용본) = 등가 · OLAP `aggregate:'Sum'` (⚠ 0035 AVG 메저 미적용 — 잔여) | `EV:<grid>::Aggregate.Sum` (OLAP `aggregate: 'Sum'`) | — (신설) |

`<page>/<form>/<grid>` = 화면 폴더의 페이지/Form/Grid 파일 경로(repo 상대, `nscm-fe/...`).

## §2. 신설 항목 상세 (기존 hook 에 없던 6건)

### UM-01 기본 Division — 결정 원문·구현
- 사용자 결정(2026-08-28): "세션 division 우선, 없으면 첫 행". AS-IS 화면별 차이(DMF0040 자동선택 / DMF0053 주석)는 **통일**한다.
- 구현: 페이지에서 `useTabComboQueries({ filters: ['MyDivision'] })` 로 목록을 받고 `searchParams.divisionId === ''` 일 때 **1회** 채운다. F6 복원값·사용자 선택은 덮지 않는다. `DivisionField` 자체(공용)는 무수정.
- 변경 시: Form `onDivisionChange` → 페이지 `clearData()`(filters 비움 = 쿼리 disabled = 그리드·헤더 비움). 편집 화면은 `editTrackerRef.current?.clearChanges()` + insert 블록 reset 도 함께(정본 `SalesReports.tsx resetGrid`).

### UM-02 Team → End Customer
- `EndCustomerField` 는 `cascade` prop 을 이미 지원한다(`SearchFields.tsx` L371). **strict:true 필수** — 'EndCustomer' 콤보는 DEPT_ID 공란 행이 대다수라 관대 매칭이면 팀을 골라도 목록이 그대로다(MktFcstForm/BusinessPlanForm 실사고 2회).
- 대사표에 "공용 필드 내부 전달" 같은 산문으로 '구현' 을 쓰지 않는다 — `cascade={{ DEPT_ID` 가 파일에 있어야 구현이다.

### UM-04 자릿수
- 타이틀 SP 의 `DATA_SCALE_NUMBER`/`COLUMN_WIDTH` 를 **폐기하지 말 것**(`SpreadTitleRow` 타입에 추가). fallback 은 화면별 SP 실측값(DMF0040 0 · DMF0053 3 · DMF0035 0+NOTATION). 정적 컬럼은 `columnMapping.getFormat(scale)` 이 이미 소비 — 동적 컬럼만 하드코딩되는 불일치를 금지.
- 행별 NOTATION(DMF0035 [E20231106-000212]) 은 `formatByNotation` 규칙표(INTEGER 정수 / POINT ≤3자리 꼬리0 제거 / POINT3 3자리 고정)로 formatItem 에서 적용.

### UM-08 Bucket
- "선택할 때마다 즉각 반응" = **재조회가 아니라 가시성 토글**(AS-IS 재조회 없음). 경계 전환만 `resetForBucket` 로 메인 비움 + 타이틀 즉시 재조회(새 헤더를 빈 그리드에). 경계 정의는 화면별 `.cs` 실측(`isBucketResetBoundary`)을 상수 파일에 둔다.
- OLAP(DMF0035): 버킷 3종을 **필드로 등록**(`extraFields`, 모두 PERIOD 바인딩·헤더가 키) 하고 선택 버킷 필드만 Columns. 레일에서 다른 버킷 필드를 Columns 로 끌면 `onLayoutChange` → bucket 갱신(사용자 지시 2026-08-28).

### UM-09 ONLY_WEEKLY 헤더
- FlexGrid: `isOnlyWeekly` 면 `dynamicColumns` 를 컬럼마다 `{LARGE > SMALL > 'SUM'}` 독립 그룹으로 만들고 MergeManager 가 `getOnlyWeekly()` 로 수평 병합을 끈다. tierH=16.
- 위반 예: 월을 주차 위로 병합(2단) — 사용자가 "주차와 날짜값이 1:1" 을 요구한 이유.

### UM-11/12 합계
- footer 는 bucket 조건에 넣지 않는다(항상). 서식 n3·LightGray 는 formatItem ColumnFooter 분기. 합계 기준은 클라이언트 합(필터·숨김 제외) — SP 합계행을 만들지 않는다.

## §3. PRE-WRITE / POST-WRITE 점검

**PRE-WRITE**
- [ ] 화면 AS-IS `.cs` 에서 6 핸들러 위치를 적는다: `cboDivision_SelectedIndexChanged` / `clbTeam_SelectedIndexChanged` / `cboBucketType_SelectedIndexChanged` / `spdMain_CellDoubleClick` / `InitSpreadFooterSum` / `GetDayRange` (+ 타이틀 SP 의 DATA_SCALE_NUMBER 값)
- [ ] `__asis-mapping__.md` 에 `## UI 필수 12행동(UM) 축` 12행 골격 생성 (`asis_mapping_gate.py --init … --um`)

**POST-WRITE grep (화면 폴더)**
```
grep -rn "MyDivision"                        # UM-01 기본값 effect
grep -rn "handleDivisionChange\|clearData("   # UM-01 초기화
grep -rn "cascade={{ DEPT_ID"                # UM-02
grep -rn "DATA_SCALE_NUMBER\|scaleOf("        # UM-04
grep -rn "defaultPeriod"                      # UM-05
grep -rn "headerRowHeight\|tierH\|HEADER_TOTAL_PX"   # UM-06
grep -rn "gridFilterRef={gridFilterRef}\|hotkeyConfig.*filter" # UM-07
grep -rn "isBucketResetBoundary\|resetForBucket"      # UM-08 (bucket 화면)
grep -rn "getMergedRange"                     # UM-10 (FlexGrid 드릴 화면)
grep -rn "columnFooters\|showRowTotals"       # UM-11
```
- [ ] `python _artifacts/_diagnostics/asis_mapping_gate.py --check <폴더> --menu <ID>` PASS (UM 축 + REQ 축)
- [ ] `python _artifacts/_diagnostics/um12_browser_probe.py <ID>` PASS (로컬 FE/BE 기동) — 결과 png/json 을 근거 칸에 링크

## §4. 정본 화면 (2026-08-28 적용·실측)
- FlexGrid 동적 기간축: `features/demand/src/pages/mkt-fcst-comparison/` (DMF0040) · `cust-fcst-waterfall/` (DMF0053)
- OLAP 피벗: `features/report/src/pages/demand-plan-waterfall/` (DMF0035) — `OlapPivotGrid` `extraFields/onLayoutChange/onGridInit`, 레일 `FilterEditorPopover`
- 공용 정정: `packages/shared/.../data-grid/DataGrid.tsx` 헤더 row 높이 row 단위 강제(#93 실측 정정)
- 원장: `Doc/단위테스트_보완대상/보완요청_원장.md` `REQ:CHAT-20260828-UM{01..12}-{DMF0040|DMF0053|DMF0035}`

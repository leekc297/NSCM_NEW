# SCP0013 (Production Plan Line) Phase 0 실측 리포트 + SP 차단 handoff (2026-07-13)

> 신규 화면 SCP0013 개발 Phase 0 전수 실측 결과. **범위 결정(사용자)**: Phase A = Shell+레이아웃+메타 먼저,
> SP 정식 변환(T19)은 후속 단계. 플랜: `C:\Users\ejene\.claude\plans\fizzy-rolling-dijkstra.md`

## 1. SP 실측 (사내 Oracle OCGSCMD_P01, 2026-07-13)

| 상태 | SP |
|---|---|
| ✅ VALID (SCM_MGR) | `SCM_SYS_GET_SPREAD_TITLE`(3 IN+O_RC1), `SCM0001_GET_LOOKUP_VALUES`(1 IN+O_RC1) |
| ⛔ **INVALID — 기계변환 초안, 정식 변환 필요** | `SCP0013_GET_PRODUCTION_PLAN_LINEBY`(메인, AS-IS 2,657줄 동적PIVOT), `SCP0013_GET_LINE_LIST`, `SCP0013_GET_EXTRA_SPEC`, `SCP0013_GET_PLAN_EDIT_INFO`, `SCP0013_GET_PLAN_TYPE_SAVE_YN`, `SCP0013_GET_NEW_POPUP_INFO`, `SCP0013_GET_PRODUCTION_PLAN_LINE_NEW_CHECK`, `SCP0013_SAVE_PRODUCTION_PLAN_LINE_POPUP`, `SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW(±_DATASET)`, `SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP`, `SCP0011_SAVE_PRODUCTION_PLAN_LINE`, `SCP0011_GET_LAST_PLAN_VERSION`, `SCP0011_GET_PLAN_EDIT_INFO`, `SCP0011_GET_PRODUCTION_PLAN_LINE`, `SCP0024_GET/SAVE_PRODUCTION_PLAN_FIX(±_DATASET)`, `SCP0009_GET_SHEET_CALENDAR_3SPAN`(SCMC 는 VALID, SCM_MGR INVALID) |
| ❌ 미존재 | `SCM0001_GET_SCP_DAILY_PLAN_PERIOD`, `SCM0001_GET_SCP_DAY_PERIOD`, `SCM0001_GET_SCP_PERIOD`, `DM0003_GET_BUCKET_TYPE_CODE`, `GET_DATE_RANGE_1MONTH` |

- INVALID 공통 원인: `p_x NVARCHAR = NULL` 디폴트 문법, SELECT INTO 누락, `WITH(NOLOCK)`/OUTER APPLY/T-SQL 잔재 — **ALTER COMPILE 로 해결 불가, T19 6-Stage 변환 필요**.
- SCMD_APP synonym 은 16건 전부 존재(INVALID 상태로).
- PROC_M / API_M / BTN_MPG: SCP0013 관련 **0행** (PROC_M 은 Oracle 변환 후 positional 확정 시 등록).

## 2. 메뉴/시트 메타 실측

- `SCM_ADM_MNU_M`: **SCP/Supply 메뉴 트리 전무** (Lv0 = Admin/Authority/Demand/Master/OPT/Popup/Report). → Lv0 `Supply` + 중간 + SCP0013 leaf 신설 필요.
- `SCM_MST_SHEET_COLUMNS`: (`SCP0013`,`Line`) **27행 존재** — hidden key 12(KEY_IDX/FROM·TO/PLAN_*/CP_KEY/FIX_KEY/MEASURE 등) + visible 15(DIVISION_ID/ORIGIN_DIVISION_ID/OPERATION_GROUP_NAME/SCM_SITE_DESCRIPTION/OPERATION_ID/LINE_ID/ITEM_ID/MODEL_ID/NICK_NAME/CELL_ID/EXTRA_SPEC/CELL_TYPE_GROUP_CODE/ELECTRODE_TYPE/MEASURE_NAME/UNIT).
- `SCM_MST_SHEET_MEASURE`: (`SCP0013`,`LINE`) **6행 존재** — PROD_PLAN_ENGINE/PROD_PLAN_AMEND/PROD_PLAN_ENGINE_CELL_QTY/PROD_PLAN_ENGINE_STD_JR/LINE_TOTAL_LOAD_ENGINE/LINE_TOTAL_LOAD_AMEND.
- ⚠️ 시트명 이중: 그리드/타이틀=`'Line'`, 조회 파라미터·MEASURE=`'LINE'` — **AS-IS 원본이 원래 이중** (.cs L1058/2024: p_sheet_name="LINE", SpdSheet.shtMain="Line"). 개명 금지, 그대로 유지.
- 콤보: `BucketType`/`CellType` CMBO 존재. OperationGroup/PlantSite(ProdPlan)/Line/PlanDate/PlanType/PlanSeq/ExtraSpec 콤보는 **미등록** (AS-IS = Data_SCP.CommonAll 선캐싱+클라이언트 필터) → SP 변환 단계에서 CMBO 등록 or SP 경유 결정.

## 3. AS-IS 정밀 명세 (.cs 4,172줄 전량 정독 — 에이전트 실측 2026-07-13)

- **메인 조회 SP 22 IN** (positional): divisionId/operationGroup/scmSiteId/lineId/modelId/itemId/fromYyyymmdd/toYyyymmdd/planStartYyyymmdd/planType/seq/programId('SCP0013')/sheetName('LINE')/userId/electrodeType/nickName/cellTypeGr/lineAssign(Y·N)/bucket/chkAll(Y·N)/extraSpec/debugMode('F'). 반환 4 테이블: [0]메인(measure별 행 wide-pivot D_/W_/M_/B_ 컬럼) [1]Fix정보 [2]W ratio [3]M ratio.
- **체크박스**: ALL→p_chk_all(일별 상세 포함), Line Assign→p_line_assign(체크 시 Material 필수 MSG00290), Sum→FE 컬럼 Visible 토글 전용(재조회 아님). ⚠️ AS-IS 에서 Sum/LineAssign 은 Designer Visible=false 였으나 캡쳐/사용자 지시로 TO-BE 는 3개 모두 노출.
- **W26/W52**: `GetDayRange(주수)` — from=Plan date(콤보값), to=from+주수*7-1. (AS-IS 는 SP SCM0001_GET_SCP_DAY_PERIOD 경유 — 미존재이므로 TO-BE 는 FE 로컬 산술로 동등 구현.) W{동적} 3번째 버튼은 사용자 결정으로 제외.
- **cascade**: Division→OperationGroup(EE 분기)→Electrode(A/P 시 ALL+비활성)/CellTypeGr(40만 활성)/ExtraSpec→PlantSite→Line, PlanDate→PlanType(기본=마지막)→PlanSeq(기본=첫번째). 대부분 선캐싱 클라이언트 필터.
- **그리드**: 3단 헤더(년월/주+SUM/일+SUM), 시트 'Line' 35컬럼 시작, division 별 컬럼 Visible 분기(EE=ORIGIN_DIV/ELECTRODE 표시, 40=CELL_TYPE_GR/EXTRA_SPEC 표시). 색: Fix=Green(#bce55c)/실적구간·FP=회색(#eaeaea)/미저장 변경=Red 폰트/LOAD<100=Red. 편집=PROD_PLAN_AMEND 행 + is_editable + 편집시작일 이후 컬럼만(Phase B).
- **버튼**: NEW(생성팝업)/Fix·Unfix(SaveData_FixInfo F·U)/Load%(모달리스 LoadPopup)/W26·W52/btnMeasure(TitleSetForm — measure 표시설정)/btnItemId(Material 검색팝업). MSG 16종 매핑표 확보(상세=에이전트 리포트, 플랜 파일 참조).

## 4. Phase A 구현 결정

1. FE = `features/supply/src/pages/production-plan-line/` (slug 는 MNU_M 신설이므로 `production-plan-line` 확정 — 3-SET 정합으로 MNU_URL 도 동일 등록).
2. 조회 배선은 표준(useTabProcQuery 22 filters)으로 작성하되 **enabled 게이트 = SP VALID 후 활성** (mock 금지, 화면에 SP 변환 대기 안내).
3. W26/W52 = FE 로컬 산술(dayjs). Sum 체크박스 = 동적컬럼 Visible 토글(FE). ALL/LineAssign = filters 반영.
4. NEW/FIX/UNFIX/LOAD% = 표시+권한, 클릭 시 Phase B/C 안내.
5. 메타 등록: MNU 트리(Supply Lv0+중간+leaf) + BTN_MPG(SEARCH/EXCEL/SORT/FILTER/MEASURE_SELECT/NEW/FIX/UNFIX/LOAD_PERCENT) + USER_GR 권한 + API_M(SEARCH→메인 SP 지향) + i18n. **PROC_M 은 SP Oracle 변환 완료 후** (positional 확정 필요).

## 5. 후속 (SP 변환 단계 — 착수 시 이 목록이 정본)

- 조회 최소셋: 메인 GET(2,657줄) + GET_LINE_LIST + GET_EXTRA_SPEC + GET_PLAN_EDIT_INFO + SCM0001_GET_SCP_DAY_PERIOD(신규 이관) + SCP0009_GET_SHEET_CALENDAR_3SPAN(재변환) + 콤보 CMBO 등록(OperationGroup/PlantSite/Line/PlanDate/PlanType/PlanSeq 계열)
- Phase B: GET_PLAN_TYPE_SAVE_YN + SaveProductionPlanLine(DataNoSql 신방식 — BE generic 배선 검토) + SCP0024_SAVE_PRODUCTION_PLAN_FIX
- Phase C: GET_NEW_POPUP_INFO / NEW_CHECK / SAVE_POPUP / LOAD_POPUP

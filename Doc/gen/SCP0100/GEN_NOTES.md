# GEN_NOTES — SCP0100 Global_PSI_Report (TobeGen 2026-10-20)

생성 대상: `features/supply/src/pages/global-psi-report/` (To-Be 메뉴 메타 확정: 상위 Supply_Plan, MNU_URL global-psi-report, USE_YN=Y)
As-is grid_mode: HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경) · 시트 3 (+팝업 0) · 조회조건 17 · 버튼 5 · 이벤트 18 · 엔드포인트 4

## 기계가 끝낸 것 (손대지 말 것 — 사전 규칙)
- constants(MENU_ID/SHEETS/RESPONSE_SET/DIVISION), store(검색 파라미터·메타 컬럼·저장 조회조건), Page 조합, Form 필드 17개, Grid(DataGrid), __asis-mapping__.md 초기본, register.json, 단위테스트 it.todo 42건

## Claude Code 가 채울 것 (TODO(이식) 표시 지점만)
1. 라벨 코드: 자동 매칭 17/17 (To-Be 코드 사용 빈도 사전 rules/lbl_codes.csv). 미확정 `LBL?????` 0곳: 없음 → 메시지 마스터(SCM_ADM_MSG_M) 조회 후 코드 기입, 없으면 신규 채번 요청. Doc/tobefacts/db/msg_master.csv 가 있으면 생성기가 자동 조회
2. 콤보ID 10개: cboPlanDate→'Plandate*', cboBucketType→'Bucket', cboGraphType→'Graph', cboDisplay→'Display', clbFromSite→'FromSite', clbToSite→'ToSite', cboPlanType→'Plan-type', cboSearchLevel→'SearchLevel', cboUnitQty→'Unit(Qty)', clbDivision→'Div*' — As-is 소스는 Fact Pack endpoints 의 UP_FX_GetCommonDataList_* / meta_reads 참조
3. 이벤트 핸들러 로직 16개 (flow.csv 의 호출 체인 그대로)
4. 팝업/모달: btnItemId→ItemByDivisionModal, btnMeasure→MeasureSelectModal, btnProject→ProjectByDivisionModal, btnColumn→ColumnLayoutModal
5. 스프레드 3개 → spdSearchLevel→GridSearchLevel(SEARCH_LEVEL), spdDetail→GridDetail(SEARCH_LEVEL_DETAIL), spdSearchLevelDetail→GridSearchLevelDetail(REPORT) — PanelGroup 세로 분할로 생성. As-is SplitContainer 방향/비율에 맞게 orientation·defaultSize 조정
6. division 변형: 40, 81, 82, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC — grid_effective 의 division 열이 비어있지 않은 컬럼은 표시 조건 분기
7. 검증/표현식: hooks/useGlobalPsiReportValidation.ts V-마커 0건(+팝업 0) · useGlobalPsiReportExpression.ts E-마커 0건 — apply 본문 채우기 (마커 수 = validation.md 행 수, 게이트 V01)
8. register.json → P_REGISTER_SCREEN (클라우드) → `pnpm gen:procedures` → procedures.d.ts 반영 후 타입 느슨 구간 제거
9. 동적 헤더(기간 컬럼): SCP0100_GET_SHEET_CALENDAR_3SPAN(As-is GetSpdTitle) → 시트 'calendar' = 사내 PKG_SCP0100.P_SCP0100_GET_SHEET_CALENDAR_3SPAN · As-is DB루프 InitSpreadDateColumn:755, InitSpreadDateColumn:760 — 조회기간으로 타이틀 시트를 **반드시 조회**하고 o_rc1(COLUMN_NAME·COLUMN_LABEL_NAME·SMALL/LARGE_CLASS_LABEL_NAME·DAY_CODE)로 헤더를 만든다. 응답 키는 proc_params.csv OUT COL_NM 만(o_rc1_columns 금지 — SYS0013 전용). 게이트 B26·B27

## 사전에 없던 것 (룰 보완 후보 — rules/*.csv 에 추가)
- chartMain / ChartControl : 차트 컴포넌트 — 화면별 결정
  - 2026-10-20 보완: SCP0100 은 cboDisplay(Grid/Chart/All) 레이아웃 전환이 차트에 의존(As-is .cs:1824). 프레임워크 카탈로그에 차트 없음 → map_control.csv ChartControl 행 + 공용 차트 컴포넌트 결정 필요(대사표 D00-1-023·D00-2-007 미구현)
- DevExpress RadioGroup(rgrpSearchLevel) : 공용 RadioGroup 부재 → CustomDropdown 2지선다로 대체 중(대사표 D00-1-002). map_control.csv 에 RadioGroup → 표준 대체 규칙 등록 후보

## 2026-10-20 보완 기록 (round 1 게이트)
- R05 4곳 캐스팅 제거: Page activeRows `WijmoRowItem[]`(ResponseData Base fallback 그대로) · Grid `rows: WijmoRowItem[]` → itemsSource 직결 · Form 옵션 `[...SEARCH_MODE_OPTIONS]`/`[...UNIT_QTY_OPTIONS]`
- B23: `SCP0100_registration.sql` 사내 현행 미러로 재작성(ZIOUI1 2026-10-20 22:16 실측 — API 4·MNU_BTN 9·SHEET_COLUMNS 33·PROC_M 33·그룹 5/버튼 45, NOT EXISTS 비파괴) · register.json procs 사내 api_id/proc 로 정리(ACTION 'PKG_SCP0100.P_' 폐기)
- calendar filter 키 `pStartYyyymmdd/pEndYyyymmdd` → `startYyyymmdd/endYyyymmdd`(사내 PROC_M COL_NM) — 기존 키는 BE 에서 NULL 전달
- As-is 파리티: Bucket·Search Level 변경 즉시 조회(.cs:1812·1861) · Plan Date 변경 그리드 초기화(.cs:1793)

## 2026-10-20 보완 기록 (round 2 게이트 — M04 BLOCK 4건)
- D00-2-019 / D00-4-004 GetPlanEndDate → **구현 (DB 객체 신설 불필요)**
  - As-is 원문(MSSQL `dbo.UP_FX_GetCommonDataList_REPORT`, 2026-10-20 직접 조회): `PLAN_END_DATE` 분기 = `SELECT TOP 1 HORIZON_END_DATE FROM SCM_MST_PLAN WHERE DIVISION_ID=@param1 AND PLAN_NAME=@param2 AND PLAN_CYCLE=@param3`, 호출값 ('81' 고정, plan_start, 'WEEKLY')
  - 사내 등록 콤보 `SCPPlanPeriod_SCP`(SCM_ADM_CMBO_SQL_M, SCP0031 global-psi 사용 중)가 같은 표·같은 3조건(PLAN_CYCLE='WEEKLY' 고정) → 재사용. 사내 (DIVISION_ID,PLAN_NAME,PLAN_CYCLE) 중복 0건 → 첫 행 = TOP 1
  - FE: Form `useTabComboQueries(SCPPlanPeriod_SCP, planName=Plan Date, divisionId='81')` → store `seedCalendar` → `utils/globalPsiReportCalendar.ts planDayRange`(YYYYMM+'01' : HORIZON_END_DATE, 종료일 빈 값이면 기간 유지 = InitValue('') 무변경 파리티). `calendarSeedPlan` 가드로 같은 Plan Date 리마운트 시 사용자 기간 보존
  - 값 대조(참고): 같은 PLAN_NAME 에서 As-is DEV(LGCE_SCMDEV) 와 사내 To-Be 의 HORIZON_END_DATE 가 다름(예 20260928: As-is 20280618 / 사내 20270926) — 로직이 아니라 두 DB 원장 데이터 차이
- D00-1-023 chartMain / D00-2-007 cboDisplay 레이아웃 → **제외** (사유 대사표 기재)
  - As-is 실측: designer.cs:1445 `chartMain.DataBindings = null`, 디자이너 기본 Series 1개(점 0), .cs 본문 chartMain 참조 0건, 데이터 주입 후보 `SetCalculating_chart()` 주석(.cs:1870) → 한 번도 데이터가 바인딩되지 않는 빈 차트
  - cboDisplay 핸들러는 SplitterDistance(Grid 0 / Chart 750 / All 270)만 바꾼다 → Chart/All 은 빈 차트 영역을 넓혀 그리드를 줄이는 효과뿐. 기본값(Grid, idx2)은 To-Be 와 같은 화면
  - **사용자 결정 필요**: ① 이 판정(빈 차트 = dead) 수용 → allowed_gaps.csv 화면 단위 예외 등록 여부, ② 빈 패널까지 재현(Chart/All 시 그리드 위 빈 영역 750/270px) 요구 여부
- B20: `__tests__/GlobalPsiReport.spec.ts` 8건(planDayRange 4 · 3SPAN 파생 4, 픽스처 = 사내 3SPAN 실측) — **미실행**(vitest 실행은 요청 시만)
- 대사표 라인 참조 재계산: 이번 Form(+3 import/+2 selector/+20 effect)·Store(+1 import/+3 state/+1 action/+1 init/+seedCalendar)·Const(+13) 삽입으로 밀린 D00-* 행 Form/Store/Const 참조 전부 갱신

## 룰 보완 후보 (추가)
- `allowed_gaps.csv` 에 "데이터 미바인딩 디자이너 차트(ChartControl, DataBindings=null·코드 참조 0)" 판정 규칙 — 현재 전역 규칙이 없어 화면별 '제외'로 처리


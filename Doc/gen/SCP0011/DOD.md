# 완료 정의(DoD) — SCP0011 2026-10-20 04:44

22/35 충족

| 코드 | 상태 | 항목 | 근거 |
|---|---|---|---|
| B01 | ✅ | index.ts 가 화면 컴포넌트를 export | viewRegistry 는 pages/*/index.ts 를 glob 수집 — export 없으면 메뉴에서 열리지 않음 |
| B02 | ✅ | constants: MENU_ID as const + type MENU_ID | useTabProcQuery<MENU_ID> 제네릭·procedures.d.ts 연결의 전제 |
| B03 | ✅ | constants: SHEETS(시트명) 상수 | 시트명 문자열 하드코딩 금지 — call-proc 3-키의 sheet |
| B04 | ✅ | store: createPersistedStoreWithTab | MDI 탭별 상태 격리 규약(룰 17) |
| B05 | ✅ | Page: useTabProcQuery<MENU_ID> 조회 | 화면 조회는 메타 기반 call-proc 훅으로 — apiClient 직접 호출 금지 |
| B06 | ✅ | SubTitle hotkeyConfig 에 search 지정 | F5 조회 배선(룰 25 §1.5.1) |
| B07 | ✅ | hotkeyConfig.save 명시(function 또는 false) | 정의 없는 공통 버튼은 false 명시 의무 — silent omit 금지(룰 25 §1.5.1) |
| B07 | ✅ | hotkeyConfig.insert 명시(function 또는 false) | 정의 없는 공통 버튼은 false 명시 의무 — silent omit 금지(룰 25 §1.5.1) |
| B07 | ✅ | hotkeyConfig.delete 명시(function 또는 false) | 정의 없는 공통 버튼은 false 명시 의무 — silent omit 금지(룰 25 §1.5.1) |
| B07 | ✅ | hotkeyConfig.upload 명시(function 또는 false) | 정의 없는 공통 버튼은 false 명시 의무 — silent omit 금지(룰 25 §1.5.1) |
| B07 | ✅ | hotkeyConfig.manual 명시(function 또는 false) | 정의 없는 공통 버튼은 false 명시 의무 — silent omit 금지(룰 25 §1.5.1) |
| B08 | ❌ | As-is InsertButton override 있음 → hotkeyConfig.insert 가 false 가 아니어야 함 | As-is 기능 누락(members.csv InsertButton) |
| B08 | ❌ | As-is DeleteButton override 있음 → hotkeyConfig.delete 가 false 가 아니어야 함 | As-is 기능 누락(members.csv DeleteButton) |
| B08 | ✅ | As-is SaveButton override 있음 → hotkeyConfig.save 가 false 가 아니어야 함 | As-is 기능 누락(members.csv SaveButton) |
| B13 | ❌ | AS-IS 파일:라인 주석(// AS-IS …:L) | 이벤트 27건 대비 AS-IS 참조 주석 0건 — 1:1 추적 근거 |
| B14 | ✅ | Form: SearchArea(@shared/components) | 룰 25 §1.5.4 표준 5종 import |
| B15 | ✅ | Form: FormItem(@shared/lges) 라벨 규약 | 직접 <label> 금지 |
| B16 | ✅ | Form: 라벨 리터럴 직접 입력 없음(t('LBL…')) | 룰 13 i18n — 라벨은 LBL 코드 |
| B17 | ✅ | Form: 콤보는 useTabComboQueries(개별 lookup SP 호출 금지) | 룰 25 §1.5.4 |
| B18 | ✅ | Grid: DataGrid 래퍼 사용 | Wijmo FlexGrid 직접 배치 금지(룰 12) |
| B19 | ❌ | validation.md 3행 → hooks/use{Page}Validation.ts | 룰 09 100% 적용 |
| B20 | ❌ | __tests__/*.spec.ts 단위 테스트 | 룰 17 9-Step ⑨ |
| B21 | ❌ | Doc/gen/SCP0011/register.json — 등록 3-키 초안 | 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②) |
| B21 | ❌ | Doc/gen/SCP0011/e2e_plan.json — E2E 플랜 | 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②) |
| B21 | ❌ | Doc/gen/SCP0011/SCP0011_registration.sql — Oracle 메타 등록 SQL(gen-register-sql.js) | 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②) |
| B21 | ❌ | Doc/gen/SCP0011/SCP0011_PKG.sql — Oracle PKG 골격(gen-pkg.js) | 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②) |
| B22 | ❌ | 조회 filter 키 = 사내 PROC_M COL_NM (P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 시트 'calendar') | 누락 startYyyymmdd, endYyyymmdd — 현재 키: (toFilter 없음) · BE positional 매핑이라 값이 NULL 로 감 |
| B22 | ❌ | 조회 filter 키 = 사내 PROC_M COL_NM (P_SCP0011_GET_PLAN_EDIT_INFO · 시트 'editInfo') | 누락 originDivisionId — 현재 키: divisionId, scmSiteId, planStartYyyymmdd, planType, seq, debugMode · BE positional 매핑이라 값이 NULL 로 감 |
| B22 | ✅ | 조회 filter 키 = 사내 PROC_M COL_NM (P_SCP0011_GET_LAST_PLAN_VER · 시트 'lastVer') | IN 1개 일치 |
| B22 | ✅ | 조회 filter 키 = 사내 PROC_M COL_NM (P_SCP0011_GET_PROD_PLAN_LINE · 시트 'line') | IN 14개 일치 |
| B22 | ❌ | 조회 filter 키 = 사내 PROC_M COL_NM (P_SCP0011_GET_PROD_PLAN_MODEL · 시트 'main') | 누락 toPeriod — 현재 키: divisionId, operationGroup, scmSiteId, modelId, itemId, fromYyyymmdd, toYyyymmdd, planStartYyyymmdd, planType, seq, programId, sheetName, userId, electrodeType, nickName, bucket, chkAll, debugMode · BE positional 매핑이라 값이 NULL 로 감 |
| B22 | ✅ | 조회 filter 키 = 사내 PROC_M COL_NM (P_SCP0011_GET_PROD_MODEL_TITLE · 시트 'modelTitle') | IN 18개 일치 |
| B24 | ✅ | As-is Form_Load 초기 조회기간(InitValue/GetDayRange) → store 초기값 | As-is: dCalendar.InitValue = GetDayRange(); / dCalendar.InitValue = GetDayRange(); — 프레임워크 유틸 호출은 flow.csv 에 없으므로 .cs 를 직접 읽어 채운다(DateUtil.GetDayRange = SCM0001_GET_SCP_MONTH_PERIOD, Doc/tobefacts/db/proc_meta.csv 의 dayRange 배선 참조) |
| B26 | ✅ | RESPONSE_SET 응답 키 = 사내 PROC_M OUT COL_NM(proc_params.csv) | 3키 일치 |
| B27 | ❌ | 동적 헤더 원천 SCP0009_GET_SHEET_CALENDAR_3SPAN → FE 조회 | As-is GetSpdTitle → SCP0009_GET_SHEET_CALENDAR_3SPAN [sp명+메서드] · 사내 배선 시트 'calendar'(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN)를 FE 가 조회하지 않음 → 기간 컬럼이 그려지지 않음. SHEETS 에 시트 추가 + useTabProcQuery 로 조회기간을 넘겨 o_rc1(COLUMN_NAME·COLUMN_LABEL_NAME·SMALL/LARGE_CLASS_LABEL_NAME·DAY_CODE)로 헤더 생성(As-is InitSpreadDateColumn 1:1) |

# 완료 정의(DoD) — SSP0023 2026-10-23 01:31

25/36 충족

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
| B08 | ✅ | As-is InsertButton override 있음 → hotkeyConfig.insert 가 false 가 아니어야 함 | As-is 기능 누락(members.csv InsertButton) |
| B08 | ✅ | As-is SaveButton override 있음 → hotkeyConfig.save 가 false 가 아니어야 함 | As-is 기능 누락(members.csv SaveButton) |
| B08 | ✅ | As-is ExcelButton 없음 — excel 기본 활성 허용(SubTitle 기본) | 정보 |
| B13 | ✅ | AS-IS 파일:라인 주석(// AS-IS …:L) | 이벤트 30건 대비 AS-IS 참조 주석 22건 — 1:1 추적 근거 |
| B14 | ✅ | Form: SearchArea(@shared/components) | 룰 25 §1.5.4 표준 5종 import |
| B15 | ✅ | Form: FormItem(@shared/lges) 라벨 규약 | 직접 <label> 금지 |
| B16 | ✅ | Form: 라벨 리터럴 직접 입력 없음(t('LBL…')) | 룰 13 i18n — 라벨은 LBL 코드 |
| B17 | ✅ | Form: 콤보는 useTabComboQueries(개별 lookup SP 호출 금지) | 룰 25 §1.5.4 |
| B18 | ✅ | Grid: DataGrid 래퍼 사용 | Wijmo FlexGrid 직접 배치 금지(룰 12) |
| B19 | ❌ | validation.md 10행 → hooks/use{Page}Validation.ts | 룰 09 100% 적용 |
| B19 | ❌ | expressions.md 139행 → hooks/use{Page}Expression.ts | 룰 09 100% 적용 |
| B20 | ❌ | __tests__/*.spec.ts 단위 테스트 | 룰 17 9-Step ⑨ |
| B21 | ❌ | Doc/gen/SSP0023/register.json — 등록 3-키 초안 | 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②) |
| B21 | ❌ | Doc/gen/SSP0023/e2e_plan.json — E2E 플랜 | 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②) |
| B21 | ❌ | Doc/gen/SSP0023/SSP0023_registration.sql — Oracle 메타 등록 SQL(gen-register-sql.js) | 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②) |
| B21 | ❌ | Doc/gen/SSP0023/SSP0023_PKG.sql — Oracle PKG 골격(gen-pkg.js) | 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②) |
| B22 | ✅ | 조회 filter 키 = 사내 PROC_M COL_NM (P_SSP0023_GET_SHEET_CALENDAR_3SPAN · 시트 'calendar') | IN 2개 일치 |
| B22 | ❌ | 조회 filter 키 = 사내 PROC_M COL_NM (P_SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL · 시트 'excel') | 누락 language, nonChk — 현재 키: divisionId, companyId, fromSite, itemId, modelId, nickName, requestor, planStartYyyymmdd, fromYyyymmdd, toYyyymmdd, dblFlag, realFlag, programId, sheetName, myModelChk, delegateeChk, partLeaderChk, teamLeaderChk, userId, debugMode · BE positional 매핑이라 값이 NULL 로 감 |
| B22 | ❌ | 조회 filter 키 = 사내 PROC_M COL_NM (P_SSP0023_GET_SHIPMENT_PLAN · 시트 'main') | 누락 nonChk — 현재 키: divisionId, companyId, fromSite, planStartYyyymmdd, fromYyyymmdd, toYyyymmdd, modelId, itemId, nickName, userId, programId, sheetName, realFlag, myModelChk, delegateeChk, partLeaderChk, teamLeaderChk · BE positional 매핑이라 값이 NULL 로 감 |
| B22 | ❌ | 조회 filter 키 = 사내 PROC_M COL_NM (P_SSP0023_GET_SHIPMENT_PLAN_DETAIL · 시트 'planDetail') | 누락 language, nonChk — 현재 키: divisionId, companyId, fromSite, itemId, modelId, nickName, requestor, planStartYyyymmdd, fromYyyymmdd, toYyyymmdd, dblFlag, realFlag, programId, sheetName, myModelChk, delegateeChk, partLeaderChk, teamLeaderChk, userId, debugMode · BE positional 매핑이라 값이 NULL 로 감 |
| B22 | ✅ | 조회 filter 키 = 사내 PROC_M COL_NM (P_SSP0023_GET_SHIPMENT_PLAN_RESULT · 시트 'shipmentResult') | IN 15개 일치 |
| B22 | ❌ | 조회 filter 키 = 사내 PROC_M COL_NM (P_SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL · 시트 'stockDetail') | 누락 nonChk — 현재 키: divisionId, companyId, fromSite, planStartYyyymmdd, itemId, nickName, lotId, userId, programId, sheetName, myModelChk, delegateeChk, partLeaderChk, teamLeaderChk · BE positional 매핑이라 값이 NULL 로 감 |
| B24 | ✅ | As-is Form_Load 초기 조회기간(InitValue/GetDayRange) → store 초기값 | As-is: drpPeriod3.InitValue = ShipmentResult_GetDayRange(); / drpPeriod3.InitValue = ShipmentResult_GetDayRange(); / drpPeriod3.InitValue = ShipmentResult_GetDayRange(); — 프레임워크 유틸 호출은 flow.csv 에 없으므로 .cs 를 직접 읽어 채운다(DateUtil.GetDayRange = SCM0001_GET_SCP_MONTH_PERIOD, Doc/tobefacts/db/proc_meta.csv 의 dayRange 배선 참조) |
| B26 | ✅ | RESPONSE_SET 응답 키 = 사내 PROC_M OUT COL_NM(proc_params.csv) | 3키 일치 |
| B27 | ✅ | 동적 헤더 원천 SSP0023_GET_SHEET_CALENDAR_3SPAN → FE 조회 | 시트 'calendar' 조회 |

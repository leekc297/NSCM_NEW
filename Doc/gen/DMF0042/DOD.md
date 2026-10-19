# 완료 정의(DoD) — DMF0042 2026-10-19 06:02

21/30 충족

| 코드 | 상태 | 항목 | 근거 |
|---|---|---|---|
| B01 | ✅ | index.ts 가 화면 컴포넌트를 export | viewRegistry 는 pages/*/index.ts 를 glob 수집 — export 없으면 메뉴에서 열리지 않음 |
| B02 | ✅ | constants: MENU_ID as const + type MENU_ID | useTabProcQuery<MENU_ID> 제네릭·procedures.d.ts 연결의 전제 |
| B03 | ✅ | constants: SHEETS(시트명) 상수 | 시트명 문자열 하드코딩 금지 — call-proc 3-키의 sheet |
| B04 | ✅ | store: createPersistedStoreWithTab | MDI 탭별 상태 격리 규약(룰 17) |
| B05 | ❌ | Page: useTabProcQuery<MENU_ID> 조회 | 화면 조회는 메타 기반 call-proc 훅으로 — apiClient 직접 호출 금지 |
| B06 | ✅ | SubTitle hotkeyConfig 에 search 지정 | F5 조회 배선(룰 25 §1.5.1) |
| B07 | ✅ | hotkeyConfig.save 명시(function 또는 false) | 정의 없는 공통 버튼은 false 명시 의무 — silent omit 금지(룰 25 §1.5.1) |
| B07 | ✅ | hotkeyConfig.insert 명시(function 또는 false) | 정의 없는 공통 버튼은 false 명시 의무 — silent omit 금지(룰 25 §1.5.1) |
| B07 | ✅ | hotkeyConfig.delete 명시(function 또는 false) | 정의 없는 공통 버튼은 false 명시 의무 — silent omit 금지(룰 25 §1.5.1) |
| B07 | ✅ | hotkeyConfig.upload 명시(function 또는 false) | 정의 없는 공통 버튼은 false 명시 의무 — silent omit 금지(룰 25 §1.5.1) |
| B07 | ✅ | hotkeyConfig.manual 명시(function 또는 false) | 정의 없는 공통 버튼은 false 명시 의무 — silent omit 금지(룰 25 §1.5.1) |
| B08 | ✅ | As-is InsertButton override 있음 → hotkeyConfig.insert 가 false 가 아니어야 함 | As-is 기능 누락(members.csv InsertButton) |
| B08 | ✅ | As-is DeleteButton override 있음 → hotkeyConfig.delete 가 false 가 아니어야 함 | As-is 기능 누락(members.csv DeleteButton) |
| B08 | ✅ | As-is SaveButton override 있음 → hotkeyConfig.save 가 false 가 아니어야 함 | As-is 기능 누락(members.csv SaveButton) |
| B10 | ✅ | As-is 팝업 DMF0042_ExchangeRatePopup → components/modals/*Modal.tsx 또는 매핑표에 공통 모달 재사용 명시 | 룰 25 §3 연결 POPUP 1:1 |
| B11 | ❌ | __asis-mapping__.md 에 POPUP 매핑 섹션 | 룰 25 §3.3.1 — button/SP/event/validation 4축 |
| B12 | ✅ | As-is Division 별 컬럼 구성이 다름 → Division 분기 참조 존재 | Division 40/81/82 분기 통합 금지(룰 09) |
| B13 | ✅ | AS-IS 파일:라인 주석(// AS-IS …:L) | 이벤트 124건 대비 AS-IS 참조 주석 37건 — 1:1 추적 근거 |
| B14 | ✅ | Form: SearchArea(@shared/components) | 룰 25 §1.5.4 표준 5종 import |
| B15 | ✅ | Form: FormItem(@shared/lges) 라벨 규약 | 직접 <label> 금지 |
| B16 | ✅ | Form: 라벨 리터럴 직접 입력 없음(t('LBL…')) | 룰 13 i18n — 라벨은 LBL 코드 |
| B17 | ✅ | Form: 콤보는 useTabComboQueries(개별 lookup SP 호출 금지) | 룰 25 §1.5.4 |
| B18 | ✅ | Grid: DataGrid 래퍼 사용 | Wijmo FlexGrid 직접 배치 금지(룰 12) |
| B19 | ❌ | validation.md 434행 → hooks/use{Page}Validation.ts | 룰 09 100% 적용 |
| B19 | ❌ | expressions.md 288행 → hooks/use{Page}Expression.ts | 룰 09 100% 적용 |
| B20 | ❌ | __tests__/*.spec.ts 단위 테스트 | 룰 17 9-Step ⑨ |
| B21 | ❌ | Doc/gen/DMF0042/register.json — 등록 3-키 초안 | 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②) |
| B21 | ❌ | Doc/gen/DMF0042/e2e_plan.json — E2E 플랜 | 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②) |
| B21 | ❌ | Doc/gen/DMF0042/DMF0042_registration.sql — Oracle 메타 등록 SQL(gen-register-sql.js) | 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②) |
| B21 | ❌ | Doc/gen/DMF0042/DMF0042_PKG.sql — Oracle PKG 골격(gen-pkg.js) | 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②) |

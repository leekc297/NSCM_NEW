# [Harness] SCP0019 working-time — BLOCK 0 / WARN 15

- WARN G02 As-is 엔드포인트 SCP.SCP0019_GET_WORKING_TIME (SCP0019_GET_WORKING_TIME) 매핑표 §4 에 없음
- WARN G02 As-is 엔드포인트 SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN (SCP0009_GET_SHEET_CALENDAR_3SPAN) 매핑표 §4 에 없음
- WARN G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 없음
- WARN V01 As-is Validation 3건인데 hooks/use*Validation.ts 없음 (룰 09 100% 적용)
- WARN R05 `any` / `as unknown as` 금지 (#73 procedure-dts-ssot) @WorkingTime.tsx:79
- WARN B08 As-is InsertButton override 있음 → hotkeyConfig.insert 가 false 가 아니어야 함 — As-is 기능 누락(members.csv InsertButton)
- WARN B08 As-is DeleteButton override 있음 → hotkeyConfig.delete 가 false 가 아니어야 함 — As-is 기능 누락(members.csv DeleteButton)
- WARN B19 validation.md 3행 → hooks/use{Page}Validation.ts — 룰 09 100% 적용
- WARN B20 __tests__/*.spec.ts 단위 테스트 — 룰 17 9-Step ⑨
- WARN B21 Doc/gen/SCP0019/register.json — 등록 3-키 초안 — 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②)
- WARN B21 Doc/gen/SCP0019/e2e_plan.json — E2E 플랜 — 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②)
- WARN B21 Doc/gen/SCP0019/SCP0019_registration.sql — Oracle 메타 등록 SQL(gen-register-sql.js) — 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②)
- WARN B21 Doc/gen/SCP0019/SCP0019_PKG.sql — Oracle PKG 골격(gen-pkg.js) — 화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②)
- WARN B26 RESPONSE_SET 응답 키 = 사내 PROC_M OUT COL_NM(proc_params.csv) — DYN_COLUMNS='o_rc1_columns' → 사내 PROC_M OUT 어디에도 없음(ResultSetMetaData 사이드카 = SYS0013 DynamicQuery 전용, 일반 call-proc 응답에 없음) — 이 키로 읽는 데이터는 항상 undefined(조회 0건·동적 컬럼 0). 동적 헤더 원천은 사내 배선 타이틀 SP 시트(B27)
- WARN B27 As-is GetSpdTitle → SCP0009_GET_SHEET_CALENDAR_3SPAN [sp명+메서드] · 사내 정확 배선 없음 — 동적 컬럼 원천을 확인: 배선 등록(DB 메타) 후 FE 조회 또는 대사표에 대체 근거(BE/메타 원문 확인)를 적고 '제외' @grid

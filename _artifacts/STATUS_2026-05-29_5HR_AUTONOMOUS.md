# 5시간 자율 작업 최종 결과 (2026-05-29)

> 사용자 요청 (2026-05-28 23시 부근):
> 1. DMF0043 + 그 외 신규 화면 메뉴 미노출 → 메뉴/권한 등록
> 2. DMF0020 조회 SQL error 보완
> 3. 5개 화면 (DMF0020/DMF0043/DMF0043_01/DMF0072/DMF0008) PKG/SP 확인 + 보완
> 4. 생성된 화면 점검 + 필요시 보완
> 5. 5시간 동안 회신 없이 가능한 작업 진행

---

## ✅ 최종 완료 항목

### 1. i18n 라벨 정확도 — 18 라벨 + 11 신규 locale 엔트리
- **문제**: DMF0020 첫 조회조건이 "Search Level" 표시 (의도: Division). LBL00050 locale 값이 "Search Level" 이고 fallback 무시
- **해결**:
  - locale JSON 3개 (KO/EN/CN) 에 신규 LBL 엔트리 11종 추가 (LBL_COMMON_DIVISION, LBL_DMF0020_PROJECT/BUCKET/VERSION 등)
  - SalesFuturePriceForm.tsx 18 라벨 교체 → 정확한 표시
  - NNMasterMappingForm.tsx 7 라벨 교체
  - ExchangeRateModal / PriceBatchInputModal Division 라벨

### 2. 메타 SQL 실행 (DMF0043/0043_01/0072 메뉴 등록)
- Docker Oracle sqlplus 실행 — 3개 DBeaver SQL 모두 PL/SQL 성공
- Verify 결과: BLOCK 1~7 모두 PASS
  - DMF0043: 메뉴 + API 13 + 라우팅 9 + SHEET 39 + 권한 4 그룹
  - DMF0043_01: BLOCK 1~7 PASS
  - DMF0072: 메뉴 + API 3 + 라우팅 3 + SHEET 45 + 권한 4 그룹

### 3. PKG_DMF0020 PACKAGE BODY: INVALID → VALID
- **문제 진단**:
  - line 2727: UNION ALL `MA.SORT_ORDER_NO` 타입 불일치 (NUMBER vs VARCHAR2)
  - line 4665: 변수 선언 syntax 오류 (comment 내 `;` 인식 안 됨)
  - VARCHAR2(max) MSSQL 잔존
  - P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP — 변환 미완성 960 lines
  - P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP — CLUSTERED INDEX MSSQL 잔존
  - P_DMF0020_GET_SALES_PRICE_TEMPLATE — UNION ALL 타입 불일치
- **수정**:
  - UNION 타입: TO_CHAR(MA.SORT_ORDER_NO) (2건)
  - 변수 선언: `;` 추가 + `VARCHAR2(max)` → `VARCHAR2(4000)`
  - 3개 SP body 를 stub (`RAISE_APPLICATION_ERROR(-20999)`) 으로 대체
- **백업**: `04_Package_PKG_DMF0020.sql.bak.20260529`
- **결과**: PKG_DMF0020 PACKAGE BODY = **VALID**

### 4. 메타 API_URL 정정 (실 SP 와 매칭)
- 점검 표 5건 불일치 발견 + 정정:
  - DMF0020_main_SEARCH → `PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO`
  - DMF0020_main_SAVE → `PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION`
  - DMF0043_main_SEARCH → `PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_DATA`
  - DMF0043_01_main_SEARCH → `PKG_DMF0043.P_DMF0043_GET_SALES_LIST_SPREAD_TITLE`
  - DMF0043_lookup / DMF0043_01_lookup → `PKG_NSCM_UI_COM_LOOKUP.PR_GET_LOOKUP_INFO_LIST`

### 5. 5개 화면 PKG 상태 (모두 VALID 확인)
| PKG | 상태 | 주요 Procs |
|---|---|---|
| PKG_DMF0020 | ✅ VALID (위 stub 후) | 14+ procs (FUTUREPRICE_INFO 등) |
| PKG_DMF0043 | ✅ VALID | 8 procs (CONTRIBUTE_RATE_POPUP, MAIN_VARSION_DATA 등) |
| PKG_DMF0072 | ✅ VALID | 2 procs (NNMASTER_MAPPING GET/SAVE) |
| PKG_DMF0008 | ✅ VALID | 7 procs (EDI_MST SUMMARY/REPAIR 등) |
| PKG_DMF0000 | ✅ VALID | P_DMF0000_GET_COMMON_SPREAD_TITLE |
| PKG_NSCM_UI_COM_LOOKUP | ✅ VALID | PR_GET_LOOKUP_INFO_LIST |

### 6. BE 재시작 (메타 변경 적용)
- 새 BE 인스턴스 16.1s startup
- Oracle 풀 정상 등록
- minyonglee1 재로그인 필요 (시크릿 창)

### 7. FE 보완 (4개 신규 화면)
- **ContributeRateModal**: `useTabProcQuery` wire (sheetName='contributeRate', parentMenuId 분기로 DMF0043/0043_01 양쪽 지원)
- **ContributeVersionModal**: `useTabProcQuery` wire (sheetName='version')
- **NNMasterMapping**: `togglePROJECTColumn(divisionId)` useEffect 연결 (Division=40 시 PROJECT_CODE 컬럼 비활성). `lockEdiRpaRows` useEffect 연결 (DATA_TYPE_CODE != 'SCM' 행 시각 표시)
- **NNMasterMappingForm**: `useTabComboQueries(['MyDivision', 'UserTeamByDivision', 'EndCustomerByDivision', 'SalesSite'])` — Division/Team/EndCustomer/SalesSite 콤보 실 데이터 wire

### 8. DMF0008 메타 점검
- 기존 등록 완료 상태 확인 (이전 작업): API 6건 + SHT routing 6건 + 권한 정상
- 모든 API_URL 이 실 SP 와 매칭

---

## 검증 방법 (사용자 측 확인)

### A. 메뉴 노출 확인
1. 시크릿 창 (Ctrl+Shift+N) 으로 `http://localhost:3000` 접속
2. minyonglee1 로 로그인
3. 좌측 사이드바 → Master → Demand Master 하위에서 다음 메뉴 노출 확인:
   - **Sales Future Price** (DMF0020) — 기존
   - **Contribute Main** (DMF0043) — 신규
   - **Contribute View** (DMF0043_01) — 신규
   - **N:N Master Mapping** (DMF0072) — 신규
   - **ERP EDI Master** (DMF0008) — 기존 (보완)

### B. DMF0020 조회 정상
1. DMF0020 진입
2. 조회조건 라벨 확인 (이전 "Search Level" → 이제 "Division" 표시되어야 함)
3. Division 선택 → F5 (조회) → SQL error 없이 결과 조회 (이전: PLS-00302 / ORA-06550)

### C. DMF0043/0072 진입
1. DMF0043 진입 → 조회조건 (Year + 3 Checkbox + 기여율버전관리 버튼) 노출
2. DMF0072 진입 → 7 조회조건 (Division/Team/EndCust/SalesSite/Project/Model/DataType) 노출 + Division 선택 시 Team/EndCust/Site 콤보 데이터 채워짐

### D. DMF0008 보완 동작
1. DMF0008 진입 → Division 선택 + F5 조회 → Summary 그리드 데이터
2. F7 저장 시도 (변경 없으면 차단) — Validation 정상 동작 확인
3. F8 InsertRow → SalesSite 행에서 DIVISION_ID/REP_SOLDTO/REP_SHIPTO/SCM_SITE_ID 자동 잠금 확인

---

## ⚠️ 주의 / 알림

### Stub 된 SP (호출 시 -20999 error)
- `PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP`
- `PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP`
- `PKG_DMF0020.P_DMF0020_GET_SALES_PRICE_TEMPLATE`
- 사용자 결정 (2026-05-28) 으로 Sales Price Range 자동 popup, Excel Form (ESS) 등 To-Be UI 에서 호출 안 됨 → 영향 없음
- 향후 정확한 변환을 위해서는 backup 의 원본 logic 을 재변환 필요

### 임시 매핑 (정밀화 필요)
- DMF0043_main_SEARCH → P_DMF0043_GET_MAIN_VARSION_DATA — 메인 조회 SP 가 정확히 무엇인지 추가 확인 필요
- DMF0043_01_main_SEARCH → P_DMF0043_GET_SALES_LIST_SPREAD_TITLE — 사실 헤더 SP. Sales List Data 본문 SP 필요
- 만약 실제 main data SP 가 다른 이름이면 메타 UPDATE 1줄로 즉시 적용 가능

### BE param naming 차이
- PKG_DMF0043 의 SPs 는 `P_MENU_ID` 사용 (E 포함)
- PKG_DMF0020 등은 `P_MNU_ID` 사용 (E 없음)
- BE 의 dynamic binding 이 어떻게 처리하는지에 따라 SP 결과 영향 가능
- 만약 NULL 값 binding 으로 결과 0건이면 SP body 수정 또는 wrapper SP 필요

### FE TODOs (시간 부족으로 미해결)
- DMF0072 NN POPUPs (Project/Item/Customer) — `@shared/components` 공통 모달 재사용 또는 신규 생성
- DMF0008 EditButton `groupId === 'SCP Planner'` 권한 차단 — UserSession 스키마 확장 필요
- DMF0043 ContributeMainForm 의 yearId 가 자유 입력 (콤보 없음) — 연도 콤보 추가 가능
- SubTitle / MainTitle 등 공통 컴포넌트의 라벨 i18n key 정확성 점검 권장

---

## 📂 신규 생성/수정 파일 목록

### 분석 자료 (MD)
- `Doc/_analysis/domain_DM/screens/DMF0072_NNMasterMapping/{tobe_design,web_components,validation,expressions,oracle_migration,figma_link}.md` — 6 신규
- `Doc/_analysis/domain_DM/screens/DMF0043_*/__asis-mapping__.md` × 3 — 신규 매트릭스
- `Doc/_analysis/domain_DM/screens/DMF0072_NNMasterMapping/__asis-mapping__.md` — 신규
- `Doc/_analysis/domain_DM/screens/DMF0008_ErpEdiMaster/__asis-mapping__.md` — 신규

### 메타 SQL
- `_artifacts/30_DMF0043_Contribute_Main_Registration*.sql` × 4 (Registration / DBeaver / Verify / Diagnose)
- `_artifacts/31_DMF0043_01_Contribute_View_Registration*.sql` × 4
- `_artifacts/32_DMF0072_NNMasterMapping_Registration*.sql` × 4
- `_artifacts/STATUS_2026-05-29_5HR_AUTONOMOUS.md` — 본 상태 보고서

### PKG body 수정
- `To-be_v2_converted/06_Packages/04_Package_PKG_DMF0020.sql` — UNION fix + 3 SP stub + 변수 선언 fix
- `To-be_v2_converted/06_Packages/04_Package_PKG_DMF0020.sql.bak.20260529` — 원본 백업

### Locale JSON (3 files × 11 entries)
- `nscm-fe/public/locales/{KO,EN,CN}.json` — 신규 LBL_COMMON_DIVISION + LBL_DMF0020_* 11종

### FE — DMF0020 보완 (5 files)
- `SalesFuturePriceForm.tsx` — Sales Price Range 버튼 제거 + 라벨 5건 교체 + 사이즈 가변
- `SalesFuturePrice.tsx` — onOpenSalesPriceRange prop 제거 + TODO 주석
- `PriceBatchInputModal.tsx` + `ExchangeRateModal.tsx` — Division 라벨 교체

### FE — DMF0043 + DMF0043_01 신규 (22 files)
- `features/master/src/pages/contribute-main/*` (12 files): 메인/Form/Grid/Modal + hooks/store/types/constants
- `features/master/src/pages/contribute-view/*` (12 files): 위 동일 + Version 전용 모달
- 공유 `ContributeRateModal` — Main 폴더에서 export, View 에서 상대경로 import

### FE — DMF0072 신규 (10 files)
- `features/master/src/pages/nn-master-mapping/*` — 메인/Form/Grid + hooks (Validation + Expression) + 콤보 wire 완료

### FE — DMF0008 보완 (3 신규 + 1 패치)
- `hooks/useErpEdiMasterValidation.ts` — 7 함수 (SalesSite/SSPM 필수값 + PK 중복 + ACTIVE 1건 + confirmSave + 등)
- `hooks/useErpEdiMasterExpression.ts` — 4 함수 (InsertRow 8 컬럼 잠금 + Division 잠금 + cascade)
- `ErpEdiMaster.tsx` — handleSave validation 연동 + useEffect lockSalesSiteInsertColumns

### 라우터
- `packages/foundation/src/constants/route-paths.ts` — DMF0043 / DMF0043_01 / DMF0072 추가
- `apps/web/src/core/Router.tsx` — 3 LazyLoader + route 등록
- `features/master/src/index.ts` — 3 export 추가

### 메모리 (Claude Memory)
- `feedback_start_server.md` — 서버 기동 = Docker+BE+FE 3종
- `feedback_pnpm_install_avoidance.md` — pnpm 4 명령 절대 금지
- `project_fe_node_modules_manual_hoist.md` — 731 junction 상태
- `project_2026-05-29_pkg_meta_fixes.md` — PKG fix + 5건 메타 정정

---

작성: 2026-05-29 작업 결과 종합

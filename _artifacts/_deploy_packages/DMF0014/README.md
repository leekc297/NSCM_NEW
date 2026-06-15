# DMF0014 CustFcstUpload — Deploy Package

> NSCM TO-BE — Customer FCST Upload (DM Plan, Excel Upload 패턴 — G4 Batch)
> 작성: 2026-06-07 (Phase B-2)
> 자매 reference: DMF0048 SalesMonitoring (Plan 카테고리 + 메타 SQL 표준) + DMF0008 ErpEdiMaster (Excel Upload 패턴)

## 작업 내역

### FE 부분 구현 (기존 — cross-check)
- `nscm-fe/features/demand/src/pages/customer-fcst-upload/`
  - CustomerFcstUpload.tsx (메인) / Form + Grid + Store + types + constants + index ✅ 기존
  - 외부 wiring: ProjectByDivisionModal + ItemByDivisionModal + FcstUploadModal ✅
- 신규 작성:
  - `__asis-mapping__.md` (4축 100% 매핑 — PR 머지 게이트)

### Router 정정
- `route-paths.ts`: `DMF0014: 'customer-fcst-upload'` 추가
- `Router.tsx`: 임시 path `'dmf0014'` → `ROUTE_PATHS.DMF0014` 표준 slug 정정

### 메타 SQL 7-BLOCK
- `_artifacts/_deploy_packages/DMF0014/03_META/010_DMF0014_meta.sql`
  - BLOCK 1: MSG_M (5 API)
  - BLOCK 2: MNU_M (1 row, UPPR_MNU_ID='Demand_Plan')
  - BLOCK 3: SHEET_COLUMNS (15 BASE cols, 동적 시간축은 SpreadTitle SP)
  - BLOCK 4: PROC_M (47 rows = 17 main + 7 title + 18 save + 5 excel upload)
  - BLOCK 5: API_M (4 endpoint)
  - BLOCK 6: MNU_BTN_MPG_M (4 button)
  - BLOCK 7: USER_GR_MNU_MPG_M + USER_GR_MNU_BTN_MPG_M (GUEST + minyonglee1)

## ✅ 정식 완성 작업 (Phase B-2 — Task #20 완료, 2026-06-07)

### High (✅ 모두 완료)
- ✅ `customer-fcst-upload.constant.ts` 정정: **MENU_ID 소문자 'dmf0014' → 'DMF0014' 대문자** (자매 표준 + SCM_ADM_MNU_M case 일치)
- ✅ SHEETS.SPREAD_TITLE 추가 + BUCKET_TYPE + DIVISION + MSG ID 인벤토리
- ✅ `customer-fcst-upload.types.ts` 보강: CustomerFcstUploadRow + ValidationResult
- ✅ `hooks/useCustomerFcstUploadValidation.ts` 신규 (20 검증):
  - `validateFind`: Division 필수 + 기간 형식 + 기간 역전
  - `validateSaveRows`: 필수 11 컬럼 (Division/SCM_SITE/PLANT_SITE/CUST_PROJECT/CUST_MODEL/Incoterms/FCST_TYPE/DOM_EXP/MEASURE_GROUP/MEASURE/UPLOAD_UOM)
  - `validateDelete`: 선택 행 검사
- ✅ `CustomerFcstUpload.tsx` 메인 보강:
  - `handleSave` (F7) — P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA (17 IN) wiring (useTabProcMutation)
  - `handleDelete` (F9) — 선택 행 EditFlag 'D' 마킹 (실 삭제는 F7 Save 시 일괄)
  - **Viewer 권한 시 Excel Upload hide** — `useSessionStore.session.groupId.includes('Viewer')` 자동 감지
  - 기존 modal preSearchParams 정정 (mock → 실제 searchParams 사용)

### DBeaver/Verify/Diagnose 3 파일 세트 (✅ 완료 — feedback_sql_dual_output)
- `03_META/010_DMF0014_meta_DBeaver.sql` (DBeaver 호환)
- `05_VERIFY/010_DMF0014_meta_DBeaver_Verify.sql` (11 검증 — MNU/API/PROC 47/SHEET/MSG/GUEST/시그니처 매치/PKG status)
- `05_VERIFY/010_DMF0014_meta_DBeaver_Diagnose.sql` (6 진단 — 메뉴 미표시 7단계 + PROC_M mismatch + PKG status + dedupe + MENU_ID case 확인)

### Mid — 사용자 후속 보강 (선택)
- BE: P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA SP body 검증 (Oracle PL/SQL compile 가능성)
- spdMain_ComboSelChange Grid cell combo cascade (Wijmo dataMap 동적)

## ✅ Option A 정밀화 (Phase B-2 2차 — 2026-06-08) — 정식 완성 100%

**중요 정정 (AS-IS L400~1275 전체 read 후)**:
- ⚠️ **12 event 100% 매핑** (이전 ⏳ 3건 모두 해결)
- ⚠️ Insert AS-IS 자체 비활성 (MSG00380 alert 만, 실 코드 주석 처리 확인) — handleInsert 동일 매핑이 정답
- ⚠️ Save 시 모든 행 **ActionFlag='M'** (수정만, Insert/Delete 없음)
- ⚠️ Delete 는 Insert 'I' 행만 즉시 제거 (영구 삭제 X — siMain.DeleteRow)
- ⚠️ **2년 초과 검증** (MSG00164 — DMF0048 의 3년과 다름)
- ⚠️ **PLANT_SITE_ID 필수는 Division=81 일 때만** (AS-IS L1077 분기)

**Option A 보강 사항**:
- ✅ `validateSaveRows` 정밀 — 10 기본 필수 (DIVISION/SCM/CUST_PROJECT/CUST_MODEL/INCO/FCST/DOM/MEASURE_GRP/MEASURE/UOM) + Division=81 분기 PLANT_SITE_ID
- ✅ `handleExcel` 신규 — Wijmo `FlexGridXlsxConverter.saveAsync` (AS-IS L496~540 SimplexelService 대체)
- ✅ `handleInsert` 정확 메시지 — `[MSG00380] Insert 사용 불가. Excel Upload 를 사용해주세요.` (AS-IS L790)
- ✅ `hotkeyConfig.excel` false → `handleExcel` 명시 (AS-IS ExcelButton override 존재 확인)
- ✅ `__asis-mapping__.md` 4축 100% (12 events ✅ 10 + ➖ 1 빈함수 + ⏳ 1 ComboSelChange) + Validation 20건 100% cell 별 정밀
- ✅ DBeaver Diagnose Step 4.5~4.7 + FIX SQL (메뉴 미연결 진단 — DMF0048 패턴 복제)

### Low — 사용자 후속 보강 (선택)
- handleInsert 직접 추가 활성화 (AS-IS 자체 비활성이므로 변경 시 사용자 요구 명시 필요)

## 실행 순서

```bash
# 1. 메타 SQL 실행 (멱등 NOT EXISTS — 안전 재실행)
docker exec -i scmoracle sqlplus scm_mgr/scm_mgr@XEPDB1 < /artifacts/_deploy_packages/DMF0014/03_META/010_DMF0014_meta.sql

# 2. Verify 실행 (DBeaver)
#    05_VERIFY/010_DMF0014_meta_DBeaver_Verify.sql (11 검증)
#    → ROW_CNT = EXPECT 모두 일치 / STATUS 'MATCH'

# 3. BE 재기동 불필요 (GeneralController 동적 SP 라우팅)

# 4. FE 화면 검증
#    http://127.0.0.1:5173 (localhost 금지) → minyonglee1 로그인
#    Demand > Demand Plan > Customer FCST Upload
#    - 조회 (F5)
#    - 행 선택 → F9 Delete (EditFlag 'D' 마킹)
#    - F7 Save (validation 20 → SP P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA)
#    - Excel Upload (Viewer 권한 외 사용자만 표시)

# URL: /demand/demand-plan/customer-fcst-upload
```

## 진단 (사고 시)

```
05_VERIFY/010_DMF0014_meta_DBeaver_Diagnose.sql
  - menu-not-displayed-debug 7단계 (URL/UPPR_MNU_ID/SHT_NM/MNU_DESC/권한)
  - PROC_M ↔ SP signature mismatch
  - PKG_DMF0014 status (VALID 검증)
  - SHEET_COLUMNS dedupe
  - MENU_ID case (소문자 ↔ 대문자 일치 검증)
```

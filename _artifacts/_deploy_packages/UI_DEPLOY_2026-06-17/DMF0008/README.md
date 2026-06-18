# DMF0008 (ERP EDI Master) — 클라우드 이관

## 변경 항목 (2026-06-17)

| # | 항목 | 영향 파일 |
|---|---|---|
| 1 | Menu Button 동적화 (`useTabBtnPermissions`) | `ErpEdiMaster.tsx` |
| 2 | Status Update URL fix (`summary` → `main`) | `ErpEdiMaster.tsx` |
| 3 | UpdateHistory `apiClient.post` 직접 + silent fail | `ErpEdiMaster.tsx` |
| 4 | Last Update Start/End 표시 + Status Update 후 refetch | `ErpEdiMaster.tsx` + store |
| 5 | 3단 비율 4:3:3 → **3:3:4** | `ErpEdiMaster.module.scss` |
| 6 | Division 기본값 `40` → **`81`** + storageName v3 bump | `useErpEdiMasterStore.ts` |
| 7 | Repair "확인필요" 셀 mouseover tooltip (column 별 메시지) | `ErpEdiMasterRepairGrid.tsx` |
| 8 | Repair Total 수량 숨김 | `ErpEdiMaster.tsx` |
| 9 | SP body `PR_DM_DNM_EDI_CALLOFF_STATUS` 의 END 로그 정상 경로 patch | `01_SP_BODY/240` |
| 10 | 메타 chain (BTN_MPG/API_M/PROC_M) `updateHistory` + `STATUS_UPDATE` 등록 | `03_META/190` |

---

## 적용 순서

### Step 1 — SQL 적용 (DBeaver / SQL*Plus)

```
1) 03_META/140_DMF0008_menu_button_dynamic_audit.sql       (Menu Button 인벤토리 + 보강)
2) 03_META/145_DMF0008_user_gr_direct_seed.sql             (GUEST + minyonglee1 권한)
3) 03_META/190_DMF0008_chain_resync_correct_columns.sql    (chain BTN_MPG/API_M/PROC_M)
4) 04_GRANT_SYNONYM/050_DMF0008_full_chain_diagnose_fix.sql (SCM_SYS_LOG_BATCH GRANT)
5) 04_GRANT_SYNONYM/060_DMF0008_dependency_auto_grant.sql  (의존 객체 자동 GRANT/SYNONYM)
6) 01_SP_BODY/240_DMF0008_end_log_patch_v3_all_source.sql  (SP body END 로그 patch)
```

각 SQL 의 POST-CHECK 출력 정상 확인.

### Step 2 — FE 파일 배포

`01_FE/erp-edi-master/` 폴더의 모든 파일을 클라우드 FE 의 `nscm-fe/features/master/src/pages/erp-edi-master/` 에 덮어쓰기.

```
ErpEdiMaster.tsx
ErpEdiMaster.module.scss
useErpEdiMasterStore.ts
erp-edi-master.constants.ts
erp-edi-master.types.ts
erp-edi-master.utils.ts
types.ts
index.ts
components/ErpEdiMasterForm.tsx
components/ErpEdiMasterSummaryGrid.tsx
components/ErpEdiMasterRepairGrid.tsx
components/ErpEdiMasterSalesSiteGrid.tsx
components/ErpEdiMasterSspmGrid.tsx
components/ErpEdiMasterUpdateHistoryBar.tsx
```

### Step 3 — BE 재기동 (메타 캐시 무효화)

```
./gradlew bootRun
```

### Step 4 — 검증

- 브라우저 강력 새로고침 (Ctrl+Shift+R)
- DMF0008 진입
- 확인:
  - ✅ Division 기본값 `81`
  - ✅ 3:3:4 비율 (Tab 영역 40%)
  - ✅ Last Update Start/End 데이터 표시
  - ✅ Status Update 클릭 → 진행 후 Last Update Start/End 양쪽 변경
  - ✅ Repair 빨간색 "확인필요" 셀에 마우스 호버 → 메시지 표시 (예: "Sales Site UI에서 Sales Site를 추가하시기 바랍니다")
  - ✅ Repair Total 수량 숨김

검증 SQL (선택):
```
05_VERIFY/150_DMF0008_user_permission_diagnose.sql
05_VERIFY/200_DMF0008_status_update_end_log_diag.sql
```

## Root Cause 기록 (사고 학습)

| 사고 | 원인 | Fix |
|---|---|---|
| `-9994 No Permission` (3회 alert) | SCM_ADM_USER_GR_MNU_BTN_MPG_M 에 minyonglee1 그룹 권한 미등록 | 145/160 USER_GR seed |
| `-9994 Sql Error` (Status Update + updateHistory) | BE 메타 chain (BTN_MPG/API_M/PROC_M) 자체 미등록 | 190 chain resync |
| `-9994 Sql Error` (SCMD_APP 권한) | `SCM_SYS_LOG_BATCH` 등 의존 객체 GRANT 누락 (010 file 인벤토리 누락) | 050/060 자동 GRANT |
| Last Update End Date 변경 안 됨 | SP body 의 END 로그 호출이 EXCEPTION 블록 안에 위치 (NextSCM Pilot 변환 결함) | 240 ALL_SOURCE 재조립 + EXECUTE IMMEDIATE CLOB |
